/*
* Name    : WS_CBS_CreateCustIC
* Company : ET Marlabs
* Purpose : This class CBS API to create customer IC // CBS002
* Author  : Ashok
*/
public class WS_CBS_CreateCustIC {
	
	public class CBS_CustIC_Request{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String First_Name;
        public String Date_Of_Birth;
        public String Gender;
    }
    //Response structure
    public class CBS_CustIC_Response{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;   //Success
    }
    public class cls_out_msg {
    	public String Cust_IC;
    	public String HttpStatus;
    	public String ErrorCode;
    	public String ErrorMessage;
    }
    @future (Callout=true)
	public static void cbs_CreateCustIC(String AppId,String CustID) {
		List<genesis__Application_Parties__c>  partyList = new List<genesis__Application_Parties__c>();
		WS_CBS_CreateCustIC.CBS_CustIC_Request cbs = new WS_CBS_CreateCustIC.CBS_CustIC_Request();
		cbs.inputVariables = new WS_CBS_CreateCustIC.cls_inputVariables();
        WS_CBS_CreateCustIC.cls_inputVariables cbsInput = new WS_CBS_CreateCustIC.cls_inputVariables();
        cbsInput.in_msg = new WS_CBS_CreateCustIC.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        try{
			partyList= queryService.PartyListApp(AppId);
			for(genesis__Application_Parties__c parts: partyList){
				if(parts.genesis__Party_Account_Name__r.id == CustID){
					Date bd = parts.genesis__Party_Account_Name__r.PersonBirthdate;
					cbsInput.in_msg.First_Name = String.valueOf(parts.genesis__Party_Account_Name__r.FirstName) ;
					cbsInput.in_msg.Date_Of_Birth = DateTime.newInstance(bd.year(),bd.month(),bd.day()).format('dd-MM-YYYY');
					cbsInput.in_msg.Gender = parts.genesis__Party_Account_Name__r.Gender__pc != null ? string.valueof(parts.genesis__Party_Account_Name__r.Gender__pc).LEFT(1) : '';
				}
			}
		}catch(Exception e){
	    	HandleBusinessException.captureError('CBS_CustIC_API','cbs_CreateCustIC', e); 
	    }
		getCustIC(json.serialize(cbs),AppId,CustID);

	}

	public static void getCustIC(String CustICData,String AppId,String CustID){
		List<Account> accountList = new List<Account>();
        List<CBS_API_Log__c> UpCBSLog = new List<CBS_API_Log__c>();
		System.debug('CustICData >>> ' + CustICData);
		KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_CustIC_API');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,CustICData,headerMap,label.CA_CERTIFICATE);
        system.debug('##### ------> '+response);
        system.debug('$$$$----> '+response.getBody());
        try{
	        If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
	        	String jsonString = response.getBody(); 
	            WS_CBS_CreateCustIC.CBS_CustIC_Response res = (WS_CBS_CreateCustIC.CBS_CustIC_Response)Json.deserialize(jsonString, WS_CBS_CreateCustIC.CBS_CustIC_Response.Class);
	            system.debug('@@@ getCustIC'+res+'  custid:-'+CustID);
	            if(res.out_msg.Cust_IC != null || res.out_msg.Cust_IC != ''){
	            	if(CustID <> null){
	            		account acc = new account();
                        acc.Id = CustID;
                        acc.Customer_IC__c = res.out_msg.Cust_IC;
                        accountList.add(acc);
                        //Success entry Log
                        CBS_API_Log__c log = new CBS_API_Log__c();    
                        log.Application__c = AppId;
                        log.API_Name__c = 'CBS_CustIC_API';
                        log.Status__c = 'Success';
                        log.Success_Error_Message__c = res.out_msg.Cust_IC;
                        log.Sequence_No__c = '2.1';  
                        UpCBSLog.add(log);
	            	}
	            }else{
	            	CBS_API_Log__c log = new CBS_API_Log__c();    
	                log.Application__c = AppId;
	                log.API_Name__c = 'CBS_CustIC_API';
	                log.Status__c = 'Fail';
	                log.Success_Error_Message__c = res.out_msg.ErrorMessage;
	                log.Sequence_No__c = '2.1';  
	                insert log;
	            }
	            if(accountList.size()>0){
                    update accountList;
                    insert UpCBSLog;        
                }
	        }else{
	        	CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'CBS_CustIC_API - No Hit';
                log.Status__c = 'Fail';
                log.Success_Error_Message__c = String.valueOf(response);
                log.Sequence_No__c = '2.1';  
                insert log;
	        }
	    }catch(Exception e){
	    	HandleBusinessException.captureError('CBS_CustIC_API','getCustIC', e); 
	    }
	}
}