/*
* Name      : WS_SMS_OTP_HL
* Compnay   : ET Marlabs
* Purpose   : Will be used for OTP generation 
* Author    : Subas
*/
global class WS_SMS_OTP_HL {
    /*Request Structure*/
    public class SMS_OTP_Request{
        public String exe_tenantId;	//cuecent_tenant
        public String owner_tenantId;	//cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String OTP_Service;	//Authentication
        public String OTP_Type;	//SMS
        public String CustomerId;	//3347040
        public String adharNo;	//
        public String panNo;	//
        public String accNo;	//
        public String GenerateOTP;	//xxxx
    }
    /*Response Structure*/
    public class SMS_OTP_Response{
        public String bpms_error_code;	//00
        public cls_out_msg out_msg;
        public String bpms_error_msg;	//Success
    }
    public class cls_out_msg {
        public String Status;	//Success
        public String Message;	//Thank you for using our Pull SMS Service to generate the OTP for the User ID  - KVB.
        public String ErrorCode;	//00
        public String ErrorMessage;	//Thank you for using our Pull SMS Service to generate the OTP for the User ID  - KVB.
    }
    /**OTP Generation Class**/
    Webservice static void generateOTP(String CasaAcNo){
        //genesis__Applications__c application = new genesis__Applications__c();
        //application = queryService.getApp(appId);        
        WS_SMS_OTP_HL.SMS_OTP_Request cbs = new WS_SMS_OTP_HL.SMS_OTP_Request();
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbs.inputVariables = new WS_SMS_OTP_HL.cls_inputVariables();
        WS_SMS_OTP_HL.cls_inputVariables cbsInput  = new WS_SMS_OTP_HL.cls_inputVariables();
        cbsInput.in_msg = new WS_SMS_OTP_HL.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbsInput.in_msg.accNo = CasaAcNo;
        cbsInput.in_msg.adharNo = '';
        cbsInput.in_msg.CustomerId = '';//CasaAcNo;//application.CustomerID__c;
        //cbsInput.in_msg.GenerateOTP = '';
        cbsInput.in_msg.OTP_Service = 'Generation';
        cbsInput.in_msg.OTP_Type = 'SMS';
        cbsInput.in_msg.panNo = '';
        callSMS_Service(JSON.serialize(cbs));
    }
    
    public static void callSMS_Service(String OTPGen){
        system.debug('!!!JSON STR!!!'+OTPGen);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_OTP_SERVICE');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,OTPGen,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();
        }
    }
    
    /**Validate OTP Service**/
    
    Webservice static String validateOTP(String CasaAcNo, String OTPNo, String AppId){
        if(OTPNo != null){
            //genesis__Applications__c application = new genesis__Applications__c();
            //application = queryService.getApp(appId);        
            WS_SMS_OTP_HL.SMS_OTP_Request cbs = new WS_SMS_OTP_HL.SMS_OTP_Request();
            cbs.exe_tenantId = 'cuecent_tenant';
            cbs.owner_tenantId = 'cuecent_tenant';
            cbs.inputVariables = new WS_SMS_OTP_HL.cls_inputVariables();
            WS_SMS_OTP_HL.cls_inputVariables cbsInput  = new WS_SMS_OTP_HL.cls_inputVariables();
            cbsInput.in_msg = new WS_SMS_OTP_HL.cls_in_msg();
            cbs.inputVariables = cbsInput;
            cbsInput.in_msg.accNo = CasaAcNo;
            cbsInput.in_msg.adharNo = '';
            cbsInput.in_msg.CustomerId = '';//application.CustomerID__c;
            cbsInput.in_msg.GenerateOTP = OTPNo;
            cbsInput.in_msg.OTP_Service = 'Authentication';
            cbsInput.in_msg.OTP_Type = 'SMS';
            cbsInput.in_msg.panNo = '';
            String resultV = callValidateOTP(JSON.serialize(cbs),AppId,CasaAcNo);
            return resultV;
        }else{
            return 'OTP Cannot be Blank';
        }        
    }
    public static String callValidateOTP(String ValidateOTP, String AppId, String CasaAcNo){
        system.debug('!!!JSON STR!!!'+ValidateOTP);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_OTP_SERVICE');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,ValidateOTP,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();
            WS_SMS_OTP_HL.SMS_OTP_Response res = (WS_SMS_OTP_HL.SMS_OTP_Response)JSON.deserialize(jsonString, WS_SMS_OTP_HL.SMS_OTP_Response.class);
            system.debug('**Response Data**'+res);
            if(res.out_msg.Status =='Success'){
                //call Processing fee
                system.debug('**A/C No**'+CasaAcNo);
                WS_CBS_Stamp_Charge_HL.sendStamp_Charge(AppId,CasaAcNo);
                
                return System.Label.HL_OTP_Success;
            }
            return 'OTP Validation Failed';
        }      
        return 'OTP Validation Failed';
    }
}