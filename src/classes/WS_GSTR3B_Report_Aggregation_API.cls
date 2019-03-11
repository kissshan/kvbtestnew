/*
 * Name     : WS_GSTR3B_Report_Aggregation_API
 * Company  : ET Marlabs
 * Purpose  : This class is used to .
 * Author   : Raushan
*/

@RestResource(urlMapping='/pushGSTR3BReport')
global class WS_GSTR3B_Report_Aggregation_API {
    
    public static void sendRequest(String custId, String appId, String gstNumber){
        If(custId !=null && custId !='' && appId !=null && appId !='' && gstNumber !=null && gstNumber !=''){
            Integer currentYear = Utility.getCurrentYear();
            String cyString = String.valueOf(currentYear);
            String n_1_FiscalYear  = (currentYear-3)+'-'+Integer.valueOf(String.valueOf(currentYear-2).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
            String fromDate = '04'+n_1_FiscalYear.split('-')[1];
            String fromDateCheck    = n_1_FiscalYear.split('-')[0]; 
            List<String> listOfString = String.valueOf(System.today()).split('-');
            String toDate = listOfString[1]+listOfString[0];
            RequestStructure    reqObj  =   new RequestStructure();
            reqObj.callbackURL  =  System.URL.getSalesforceBaseUrl().toExternalForm()+Utility.getFullEndpoints('GSTR3B Callback Report');
            If(Integer.valueOf(fromDateCheck) <= 2017){
                reqObj.from_date    = '072017';    
            }else{
                reqObj.from_date    = fromDate;    
            }
            reqObj.to_date      = toDate;
            reqObj.gstn         = gstNumber;
            try{
                Map<String,String> headerMap         = new Map<String,String>();
                headerMap.put('Content-Type','application/json');
                headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
                HTTPResponse response                 = new HTTPResponse();
                response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('GSTR3B Report'), 'POST', null,JSON.serialize(reqObj),headerMap,null);
                If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    String jsonData                    = response.getBody();
                    ResponseStructure resStrObj        = (ResponseStructure)JSON.deserialize(jsonData, ResponseStructure.class);
                    If(resStrObj !=null) {
                        try{
                            Id devRecordTypeId = Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
                            GSTN_Info__c gstInfoObj   = new GSTN_Info__c();
                            gstInfoObj.Account__c     = (Id)custId;
                            gstInfoObj.Application__c = (Id)appId;
                            gstInfoObj.Status__c      = resStrObj.status;
                            gstInfoObj.Message__c     = resStrObj.msg;
                            gstInfoObj.GST_Number__c  = gstNumber;  
                            gstInfoObj.RecordTypeId   = devRecordTypeId;
                            gstInfoObj.External_Id__c = custId+'@'+gstNumber;
                            upsert gstInfoObj;
                       
                        }catch(Exception ex){
                            System.debug(ex.getLineNumber());
                            System.debug(ex.getStackTraceString());
                        }   
                    }
                }else{                
                    throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
                }
                
            }catch(Exception ex){
                String error = ex.getMessage();
                System.debug('Error Message'+error);
            } 
        }
    }
    global class Response extends WS_Response{
           public Response(){
        }
    }
    @HttpPost
    global static Response getRespone(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();

        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;
        }else{
            try{
                String jsonData     = req.requestBody.toString();
            List<GSTN_Info__c> listGSTNInfoObj  = new List<GSTN_Info__c>();
            WS_GSTR3B_Report_Aggregation_API.ResponseStructure_Child    resChildObj =   new ResponseStructure_Child();
                resChildObj =   resChildObj.parse(jsonData);
                if(resChildObj != null){
                    Id devRecordTypeId = Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
                    If(resChildObj.yearwise !=null){
                        List<WS_GSTR3B_Report_Aggregation_API.Yearwise> listYearWise    = resChildObj.yearwise ;
                        If(listYearWise !=null){
                            for(WS_GSTR3B_Report_Aggregation_API.Yearwise   yearWise : listYearWise){
                                GSTN_Info__c gstInfoObj   = new GSTN_Info__c();
                                If(!Utility.ISStringBlankorNull(yearWise.year))
                                    gstInfoObj.Year__c        = yearWise.year;
                                If(!Utility.ISStringBlankorNull(yearWise.total_sales))
                                    gstInfoObj.Total_Sales__c     = Decimal.valueOf(yearWise.total_sales);
                                If(!Utility.ISStringBlankorNull(yearWise.period_from))
                                    gstInfoObj.From_Date__c       = yearWise.period_from;
                                If(!Utility.ISStringBlankorNull(yearWise.period_to))
                                    gstInfoObj.To_Date__c         = yearWise.period_to;
                                If(!Utility.ISStringBlankorNull(yearWise.months))
                                    gstInfoObj.Months__c          = yearWise.months;
                                If(!Utility.ISStringBlankorNull(resChildObj.gstn))
                                    gstInfoObj.Parent__r  = new GSTN_Info__c(GST_Number__c =resChildObj.gstn);
                                
                                gstInfoObj.recordtypeId       = devRecordTypeId;
                                
                                listGSTNInfoObj.add(gstInfoObj);
                            }
                        }
                    }
            
                }
                If(listGSTNInfoObj !=null && listGSTNInfoObj.size() >0){
                    insert listGSTNInfoObj;
                }    
            }catch(Exception ex){
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage    = ex.getMessage();
                res.statusCode      = Constants.WS_ERROR_CODE;
                return res;    
            }
            
        return res;
    }
    
    }     
   public class RequestStructure {
         public String callbackURL;
         public String from_date;
         public String to_date;
         public String gstn;
    }
    public class ResponseStructure {
         public String status;
         public String msg;
    }
    public class ResponseStructure_Child {
     public String gstn;
    public List<Yearwise> yearwise;
      ResponseStructure_Child parse(String json) {
        return (ResponseStructure_Child) System.JSON.deserialize(json, ResponseStructure_Child.class);
        }
    }
   public class Yearwise {
        public String year;
        public String total_sales;
        public String period_from;
        public String period_to;
        public String months;
    }    
}