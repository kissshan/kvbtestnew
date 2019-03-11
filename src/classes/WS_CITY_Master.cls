/* 
* Name     : WS_CITY_Master
* Purpose  : Formatter class to prepare request/response structure for CITY master sync
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class WS_CITY_Master {
    public static void masterRequest(){
        try{
            List<City_Master__c> cityMasterList = new List<City_Master__c>();
            WS_CITY_Master.RequestFormat req = new WS_CITY_Master.RequestFormat();
            req.exe_tenantId = 'cuecent_tenant';
            req.owner_tenantId = 'cuecent_tenant';
            req.inputVariables  = new WS_CITY_Master.cls_inputVariables();
            System.debug(Utility.getEndpoint('CITY_MASTER_API'));
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            for(Integer retryCount = 0;retryCount < 3; retryCount++){
                response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('CITY_MASTER_API'), 'POST', null,JSON.serialize(req),headerMap,label.CA_CERTIFICATE);
                System.debug('response.getStatusCode()::::::'+response.getStatusCode());
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    //Store Data
                    try{
                        
                        String jsonResString = response.getBody();
                        System.debug('res::'+jsonResString);
                        //Decimal.valueOf('asas');
                        WS_CITY_Master.ResponseFormat res = (WS_CITY_Master.ResponseFormat)Json.deserialize(jsonResString,WS_CITY_Master.ResponseFormat.class);
                        
                        if(res.out_msg.ErrorCode == '0'){
                            for(cls_City_Master cityData : res.out_msg.City_Master){
                                City_Master__c city = new City_Master__c();
                                If(!Utility.ISStringBlankorNull(cityData.COD_CITY))
                                    city.CODCITY__c = cityData.COD_CITY;
                                If(!Utility.ISStringBlankorNull(cityData.NAM_CITY))
                                    city.Name = cityData.NAM_CITY;
                                If(!Utility.ISStringBlankorNull(cityData.COD_STATE))
                                    city.CODSTATE__c = cityData.COD_STATE;
                                If(cityData.COD_PIN != null)
                                    city.CODPIN__c = String.valueOf(cityData.COD_PIN);
                                
                                cityMasterList.add(city);
                            }
                        }
                        if(!cityMasterList.isEmpty()) UPSERT cityMasterList CODCITY__c;
                        break;
                    }
                    catch(Exception e){
                        System.debug(e.getStackTraceString());
                        if(retryCount == 2){
                            //Send Email
                            Utility.sendEmail('City',e.getMessage());
                            break;
                        }
                    }
                }
                if(retryCount == 2){
                    //Send Email
                    Utility.sendEmail('City','Retry Failed');
                    break;
                }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            Utility.sendEmail('City Master','Retry Failed');
            //throw new CustomException('Error occured in response while fetching CITY master data!!!!');        
        }
    }
    
    //Request Format
    public class RequestFormat{
        public String exe_tenantId;  //cuecent_tenant
        public String owner_tenantId;  //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {}
    
    //Response Format
    public class ResponseFormat{
        public String bpms_error_code;  //00
        public String bpms_error_msg;  //Success
        public cls_out_msg out_msg;
    }
    public class cls_out_msg {
        public String ErrorCode;  //MW9999
        public String ErrorMessage;  //TECHNICAL ERROR
        public cls_City_Master[] City_Master;
    }
    public class cls_City_Master {
        public String COD_CITY;  //121 
        public String NAM_CITY;  //Gujarwas
        public String COD_STATE;  //13 
        public Decimal COD_PIN;  //123
    }
    
}