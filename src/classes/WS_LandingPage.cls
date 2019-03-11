/*
* Name          : WS_LandingPage
* Description   : Web service to get application details against customer data
* Author        : Dushyant
*/
@RestResource(urlMapping = '/getCustomerList')
global class WS_LandingPage{
    
    //Response structure
    global class Response extends WS_Response{
        public String LOS_SF_RECORD_ID;
        public LandingInfo landing_info;
        public Response(){
            landing_info = new LandingInfo();
        }
    }
    public class LandingInfo{
        public List<AppDetails> appln_info;
        public Customer360view.cls_LOANDETAIL loanInfo;
        
        public LandingInfo(){
            appln_info      = new List<AppDetails>();
            loanInfo 		= new Customer360view.cls_LOANDETAIL();
            
        }
    }
    public class AppDetails{
        public String app_stage;
        public String app_sub_stage;
        public String app_type;
        public String app_due_date;
        public String app_los_id;
        public String app_name;
        public String app_ui_stage;
        public String app_total_amount;
        public String Type;
        public String LOS_SF_RECORD_ID;
        public String IS_C1_GENERATED;
        public String NET_BANKING_FLAG;
        public String PROCESSING_FEE_RESULT;
    }
    
    //Request structure
    public class ReqWrapObj{
       public String custId;
    }
    
    @HttpPost
    global static Response handleRequest(){
        RestRequest req = RestContext.request;
        Response res         = new Response(); 
        
        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
                       
        }else{
            String jsonData     = req.requestBody.toString();        
            ReqWrapObj reqObj   = (ReqWrapObj)Json.deserialize(jsonData, ReqWrapObj.class);
            system.debug('reqObj::'+reqObj);
            If(reqObj.custId !=null && reqObj.custId !=''){
                System.debug('reqObj@@@'+reqObj);
                Account accObject  = getAccountByCustomerID(reqObj.custId);

                System.debug('accObject@@@'+accObject);
                If(accObject !=null){
                   	res = (WS_LandingPage.Response)LandingPageHelper.landingPageRes(reqObj.custId,false);
                    System.debug('ressssss@@@'+res);
                    res.LOS_SF_RECORD_ID = accObject.id;
                }else{
                   return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'No customer found.'); 
                }
            	    
            }else{
                 return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Customer Id require.');
            }
            System.debug('resObj::'+res);
        }
        RETURN res;
    }
    static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg) {
        res.status = status;
        res.successMessage = succMsg;
        res.statusCode = statusCode;
        res.errorMessage = errMsg;
        return res;
     }
    public static Account getAccountByCustomerID(String custId){
        If(custId !=null && custId !=''){
            System.debug('custId'+custId);
            try{
              	Account acc =  [select id,Name from Account where CBS_Customer_ID__c =:custId];
                System.debug('Account'+acc);
               	return acc;  
            }catch(Exception ex){
                return null;
            }
        }
        return null;
    }
}