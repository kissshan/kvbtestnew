/*
* Name 	    : SMS_Services
* Compnay 	: ET Marlabs
* Purpose	: For SMS Service. 
* Author 	: Raushan
*/
public class SMS_Services {
	
    @future(callOut=true)
    public static void sendSMSFutureCall(String mobNumber , String message){
        sendSMSCall(mobNumber, message);
    }
    
    public static void sendSMSCall(String mobNumber , String message){
        try{
            SMS_ServicesRequest smsServicesObj				=	new SMS_ServicesRequest();
            smsServicesObj.exe_tenantId						=	'cuecent_tenant';
            smsServicesObj.owner_tenantId					=	'cuecent_tenant';
            smsServicesObj.inputVariables					= 	new SMS_ServicesRequest.cls_inputVariables();
            
            smsServicesObj.inputVariables.in_msg			=	new SMS_ServicesRequest.cls_in_msg();
            smsServicesObj.inputVariables.in_msg.mobno		=	mobNumber;
            smsServicesObj.inputVariables.in_msg.message	=	message;
            
            callSMSAPI(JSON.serialize(smsServicesObj));
        }catch(Exception e){
            system.debug('exception::'+e.getMessage());
        }
		
		
	}
	public static void callSMSAPI(string smsReq){
			
		try{
            KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('SMS_Service');
            String endPoint                                         = kvb.Endpoint_URL__c; 
			Map<String,String> headerMap            				= new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response 									= new HTTPResponse();
            //String endPoint 										= 'https://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/SendSMSAlert';
            System.debug('smsReq*****'+smsReq);
    		response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,smsReq,headerMap,label.CA_CERTIFICATE);
            System.debug('Response code '+ response.getStatusCode());
    		If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
    			String jsonData 									= response.getBody();
                
                System.debug('smsResponse******'+jsonData);
    		}else{
                
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
		}catch(Exception ex){
			System.debug('Exception Message'+ ex.getMessage() + 'Line number'+ex.getLineNumber());
            System.debug('Exception Message @@@'+ ex.getStackTraceString());
		} 
	}
}