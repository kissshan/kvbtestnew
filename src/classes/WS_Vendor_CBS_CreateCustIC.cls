/*
* Name    : WS_Vendor_CBS_CreateCustIC
* Company : ET Marlabs
* Purpose : This class CBS API to create customer IC // CBS002
* Author  : Ashok
*/
public class WS_Vendor_CBS_CreateCustIC {
  
  public class CBS_CustIC_Request{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String ApplicationNumber;
        public cls_cust_details[] CustICDetails;        
    }

    public class cls_cust_details{
        public String ApplicantNumber;
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
      public String ApplicationNumber;
      public cust_IC_details[] CustomerICDetails;      
    }
    public class cust_IC_details{
      public String Cust_IC;      
      public String ApplicantNumber;
      public String HttpStatus;
      public String ErrorCode;
      public String ErrorMessage;
    }

  // @future (Callout=true)
  public static void cbs_CreateCustIC(String AppId) {
    List<genesis__Application_Parties__c>  partyList = new List<genesis__Application_Parties__c>();
    List<Id>  accList = new List<Id>();
    genesis__Applications__c application = new genesis__Applications__c();
    WS_Vendor_CBS_CreateCustIC.CBS_CustIC_Request cbs = new WS_Vendor_CBS_CreateCustIC.CBS_CustIC_Request();
    cbs.inputVariables = new WS_Vendor_CBS_CreateCustIC.cls_inputVariables();
    WS_Vendor_CBS_CreateCustIC.cls_inputVariables cbsInput = new WS_Vendor_CBS_CreateCustIC.cls_inputVariables();
    cbsInput.in_msg = new WS_Vendor_CBS_CreateCustIC.cls_in_msg();
    cbsInput.in_msg.CustICDetails = new List<WS_Vendor_CBS_CreateCustIC.cls_cust_details>();
    cbs.exe_tenantId = 'cuecent_tenant';
    cbs.owner_tenantId = 'cuecent_tenant';
    try{
      application = [SELECT Id,Name FROM genesis__Applications__c WHERE Id =: AppId]; 
      cbsInput.in_msg.ApplicationNumber = application.Name;
      partyList= [SELECT genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.PersonBirthdate,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.Gender__pc FROM genesis__Application_Parties__c WHERE genesis__Application__c =: AppId AND Company__c = false];
      system.debug('partyList-->' + partyList);
      for(genesis__Application_Parties__c parts: partyList){
          WS_Vendor_CBS_CreateCustIC.cls_cust_details custdetail = new WS_Vendor_CBS_CreateCustIC.cls_cust_details();
          Date bd = parts.genesis__Party_Account_Name__r.PersonBirthdate;
          custdetail.ApplicantNumber = String.valueOf(parts.genesis__Party_Account_Name__c);
          custdetail.First_Name = String.valueOf(parts.genesis__Party_Account_Name__r.FirstName) ;
          custdetail.Date_Of_Birth = DateTime.newInstance(bd.year(),bd.month(),bd.day()).format('dd-MM-YYYY');
          custdetail.Gender = parts.genesis__Party_Account_Name__r.Gender__pc != null ? string.valueof(parts.genesis__Party_Account_Name__r.Gender__pc).LEFT(1) : '';
          cbsInput.in_msg.CustICDetails.add(custdetail);
      }
      cbs.inputVariables = cbsInput;  
    }catch(Exception e){
        HandleBusinessException.captureError('CBS_Vendor_CustIC_API','cbs_Vendor_CreateCustIC', e); 
      }
    getCustIC(json.serialize(cbs),AppId);

  }

  public static void getCustIC(String CustICData,String AppId){
    System.debug('CustICData >>> ' + CustICData);
    KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_CustIC_API_ThirdParty');
    Map<String,String> headerMap                            = new Map<String,String>();
    headerMap.put('Content-Type','application/json');
    HTTPResponse response                                   = new HTTPResponse();
    String endPoint                                         = kvb.Endpoint_URL__c;
    response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,CustICData,headerMap,label.CA_CERTIFICATE);
    system.debug('##### ------> '+response);
    system.debug('$$$$----> '+response.getBody());
    List<Account> accountList = new List<Account>();
    List<CBS_API_Log__c> UpCBSLog = new List<CBS_API_Log__c>();
    List<CBS_API_Log__c> UpCBSErrorLog = new List<CBS_API_Log__c>();
    try{
      if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
        String jsonString = response.getBody(); 
          WS_Vendor_CBS_CreateCustIC.CBS_CustIC_Response res = (WS_Vendor_CBS_CreateCustIC.CBS_CustIC_Response)Json.deserialize(jsonString, WS_Vendor_CBS_CreateCustIC.CBS_CustIC_Response.Class);
          system.debug('@@@ getCustIC'+res);
          for(cust_IC_details out: res.out_msg.CustomerICDetails){
            if(out.Cust_IC != null || out.Cust_IC != ''){
              account acc = new account();
              acc.Id = out.ApplicantNumber;
              acc.Customer_IC__c = out.Cust_IC;
              accountList.add(acc);
              //Success entry Log - converted to bulk on 30-11-2018
              CBS_API_Log__c log = new CBS_API_Log__c();    
              log.Application__c = AppId;
              log.API_Name__c = 'CBS_CustIC_API_ThirdParty';
              log.Status__c = 'Success';
              log.Success_Error_Message__c = out.Cust_IC;
              log.Sequence_No__c = '0.1';  
              UpCBSLog.add(log);
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.Applicant__c = out.ApplicantNumber;
                log.API_Name__c = 'CBS_CustIC_API_ThirdParty';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = out.ErrorMessage;
                log.Sequence_No__c = '0.1';
                log.Failure_Error_Message__c =  'Request >> '+CustICData+' Response >> '+ String.valueOf(res);  
                UpCBSErrorLog.add(log);
            }
          }
          if(accountList.size()>0){
            update accountList;
            insert UpCBSLog;        
          }
          if(UpCBSErrorLog.size()>0){
            insert UpCBSErrorLog;
          }else{
            WS_CBS_Dedupe.callDedupe(AppId);
          }
      }else{
        CBS_API_Log__c log = new CBS_API_Log__c();    
        log.Application__c = AppId;
        log.API_Name__c = 'CBS_CustIC_API_ThirdParty - No Hit';
        log.Status__c = 'Failure';
        log.Success_Error_Message__c = String.valueOf(response);
        log.Sequence_No__c = '0.1';  
        insert log;
      }
    }catch(Exception e){
      HandleBusinessException.captureError('CBS_Vendor_CustIC_API','getCustIC', e);
      CBS_API_Log__c log = new CBS_API_Log__c();    
      log.Application__c = AppId;
      log.API_Name__c = 'CBS_CustIC_API_ThirdParty - No Hit - Exception';
      log.Status__c = 'Failure';
      log.Success_Error_Message__c = String.valueOf(response);
      log.Sequence_No__c = '0.1';  
      insert log; 
    }
  }
}