/* 
* Name     : WS_COUNTRY_Master
* Purpose  : Formatter class to prepare request/response structure for COUNTRY master sync
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class WS_COUNTRY_Master {
    public static void masterRequest(){
        try{
            List<Country_masters__c> countryMasterList = new List<Country_masters__c>();
            WS_COUNTRY_Master.RequestFormat req = new WS_COUNTRY_Master.RequestFormat();
            req.exe_tenantId 		= 'cuecent_tenant';
            req.owner_tenantId 		= 'cuecent_tenant';
            req.inputVariables  	= new WS_COUNTRY_Master.cls_inputVariables();
            
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            for(Integer retryCount = 0;retryCount < 3; retryCount++){
                response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('COUNTRY_MASTER_API'), 'POST', null,JSON.serialize(req),headerMap,label.CA_CERTIFICATE);
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    try{
                        String jsonResString = response.getBody();
                        System.debug('jsonResString****'+jsonResString);
                        WS_COUNTRY_Master.ResponseFormat res = (WS_COUNTRY_Master.ResponseFormat)Json.deserialize(jsonResString,WS_COUNTRY_Master.ResponseFormat.class);
                        if(res.out_msg.ErrorCode == '0'  ){
                            for(cls_Country_Master countryData : res.out_msg.Country_Master){
                                Country_masters__c country = new Country_masters__c();
                                If(!Utility.ISStringBlankorNull(countryData.DESCRIPTION))
                                    country.Name = countryData.DESCRIPTION;
                                If(!Utility.ISStringBlankorNull(countryData.COUNTRY_CODE))
                                    country.Country_code__c = countryData.COUNTRY_CODE;
                                If(countryData.COUNTRY_DIAL_CODE != null)
                                    country.Dial_code__c = Integer.valueOf(countryData.COUNTRY_DIAL_CODE);
                                countryMasterList.add(country);
                            }
                        }  
                        System.debug('countryMasterList********'+countryMasterList);
                        if(!countryMasterList.isEmpty()) UPSERT countryMasterList Country_code__c;
                        break;
                    }
                    catch(Exception e){
                        System.debug(e.getStackTraceString());
                        if(retryCount == 2){
                            //Send Email
                            Utility.sendEmail('City ',e.getMessage());
                            break;
                        }
                    }
                }
                if(retryCount == 2){
                    //Send Email
                    Utility.sendEmail('Country Master ', 'Retry Failed'); 
                    break;
                }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            Utility.sendEmail('Country Master','Retry Failed');
            //throw new CustomException('Error occured in response while fetching COUNTRY master data!!!!'); 
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
        public String HttpStatus;  //500
        public String ErrorCode;  //MW9999
        public String ErrorMessage;  //TECHNICAL ERROR
        public cls_Country_Master[] Country_Master;
    }
    public class cls_Country_Master {
        public String COUNTRY_CODE;  //AD
        public String DESCRIPTION;  //Andorra
        public Decimal COUNTRY_DIAL_CODE;  //376
    }
}