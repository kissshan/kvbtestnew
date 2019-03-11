/*
* Name     : CommercialPRBatch
* Company  : ET Marlabs
* Purpose  : Batch Class  to send CommercialPRCallout request to MiddleWare. 
* Author   : Raushan
*/
global class CommercialPRBatch implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts{
    public List<genesis__Application_Parties__c> parties;
    public String whereCondition                = '';
    public Map<String,Integer> fileNameCountMap = new Map<String,Integer>();
    
    public CommercialPRBatch(String condition){
        parties = new List<genesis__Application_Parties__c>();
        whereCondition += condition;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        List<String> divisionNameList       = new List<String>();
        List<String> listRecordTypeName     = new List<String>();
        List<user> userList                 = new List<User>();
        String query                        = '';
        
        String stage                        = 'Identified for renewal';
        String Apln_Stage                   = 'Greater than 2Cr.';
        Integer days                        = Utility.getExecuteBatch();  
        Set<String> setCommercialPRStage    = new Set<String>{'Not Initiated','Error',''};

        if(whereCondition == ''){
            whereCondition = 'Application_Stage__c =:stage AND CommercialPR_Stage__c IN :setCommercialPRStage AND Execute_batch_in_days__c <=:days AND Active__c = true AND genesis__Account__r.Pan_Number__c != NULL AND genesis__Account__r.BillingCity != NULL AND genesis__Account__r.BillingState != NULL AND genesis__Account__r.BillingPostalCode != NULL AND genesis__Loan_Amount__c != NULL';
            If(System.Label.APPLICATION_RECORDTYPE_NAME != null){
                for(String str : (System.Label.APPLICATION_RECORDTYPE_NAME).split(',')){
                    listRecordTypeName.add('\''+str+'\'');
                }
                whereCondition += ' AND Recordtype.DeveloperName  IN'+listRecordTypeName; 
            }
        }
        System.debug(whereCondition);
        query = 'SELECT id,genesis__Account__c,Product_Code__c,genesis__Loan_Amount__c,Application_Stage__c,Pre_Renewal_Checklist__c,CommercialPR_Stage__c,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.AccountNumber,genesis__Account__r.Name,genesis__Account__r.BillingStreet,genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingCountry,genesis__Account__r.Pan_Number__c,(Select id,genesis__Party_Account_Name__c from genesis__Application_Parties__r where genesis__Party_Account_Name__c!=null AND Active__c = true) from genesis__Applications__c WHERE '+whereCondition;
     return Database.getQueryLocator(query);
    }
    //Execute Method.
    global void execute(Database.BatchableContext BC, List<genesis__Applications__c> scope){
        try{
            List<Account> accList                                       = new List<Account>();
            List<genesis__Applications__c>  listApp                     =   new List<genesis__Applications__c>();
            CommercialPRRequest   commPRReq                             =   new CommercialPRRequest();
            commPRReq.inputVariables                                    =   new CommercialPRRequest.cls_inputVariables();
            
            commPRReq.inputVariables.in_msg                             =   new CommercialPRRequest.cls_in_msg();
            commPRReq.inputVariables.in_msg.requestJsonStr              =   new List<CommercialPRRequest.cls_requestJsonStr>();
            commPRReq.inputVariables.in_msg.Batch_ID                    =   Utility.generateRandomString();
            for(genesis__Applications__c                appObj          :   scope){
                If(appObj !=null){
                    if(appObj.genesis__Application_Parties__r.size() > 0)parties.addAll(appObj.genesis__Application_Parties__r);
                    genesis__Applications__c                appObject       =   new genesis__Applications__c();
                    CommercialPRRequest.cls_requestJsonStr    applicantsObj =   new CommercialPRRequest.cls_requestJsonStr();
                    applicantsObj.Request_ID                                =   Utility.getBlankStringIfNull(appObj.genesis__Account__r.CBS_Customer_ID__c);
                    applicantsObj.Product_Code                              =   'P2';
                    applicantsObj.AddOn                                     =   'A1';
                    applicantsObj.Output_Format                             =   'O3';
                    applicantsObj.Future_Use1                               =   '';
                    applicantsObj.Future_Use2                               =   '';
                    applicantsObj.Member_Reference_Number                   =   Utility.getBlankStringIfNull(appObj.genesis__Account__r.CBS_Customer_ID__c);
                    applicantsObj.Account_Number                            =   Utility.getBlankStringIfNull(appObj.genesis__Account__r.AccountNumber);
                    applicantsObj.Subject_Full_Name                         =   Utility.getBlankStringIfNull(appObj.genesis__Account__r.Name);
                    applicantsObj.Subject_Street_Address                    =   Utility.getBlankStringIfNull(appObj.genesis__Account__r.BillingStreet);
                    applicantsObj.City                                      =   Utility.getBlankStringIfNull(appObj.genesis__Account__r.BillingCity);
                    applicantsObj.State                                     =   Utility.getBlankStringIfNull(appObj.genesis__Account__r.BillingState);
                    applicantsObj.Pin_Code                                  =   Utility.getBlankStringIfNull(appObj.genesis__Account__r.BillingPostalCode);
                    applicantsObj.PAN                                       =   Utility.getBlankStringIfNull(appObj.genesis__Account__r.Pan_Number__c);
                    applicantsObj.CIN                                       =   '';
                    applicantsObj.CRN                                       =   '';
                    applicantsObj.TIN                                       =   '';
                    applicantsObj.Telephone_Type                            =   '';
                    applicantsObj.Telephone_Number                          =   '';
                    applicantsObj.Enquiry_Purpose                           =   '';
                    applicantsObj.Loan_Amount                               =   Utility.getBlankStringIfNull(String.valueOf(Integer.valueOf(appObj.genesis__Loan_Amount__c)));
                    
                    appObject.id                                            =   appObj.id;
                    appObject.CommercialPR_Stage__c                         =   'Sent';
                    
                    listApp.add(appObject);
                    accList.add(new Account(Id = appObj.genesis__Account__c,TU_Trigger_Time__c = System.now()));
                    commPRReq.inputVariables.in_msg.requestJsonStr.add(applicantsObj);
                }   
            }
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('CommercialPR Req'), 'GET', null,JSON.serialize(commPRReq),headerMap,null);
           
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonData         = response.getBody(); 
                CommercialPRRequest res = (CommercialPRRequest)Json.deserialize(jsonData,CommercialPRRequest.class);
                if(res.out_msg.message == 'File uploaded Successfully' && res.out_msg.statusCode == '0'){
                    if(scope.size() > 0){
                        fileNameCountMap.put(res.out_msg.UploadBatchFileName,scope.size());
                    }
                }      
            }else{                
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
            if(listApp.size()>0){
                ApplicationTriggerHandler.IsFirstRun=false;
                update listApp;
            }
            if(!accList.isEmpty()){
                AccountTriggerHandler.isAccountTrigger = true;
                UPDATE accList;
            }
        }catch(Exception ex){
            String error = ex.getMessage();
            System.debug('Error Message'+error+ex.getMessage()+'---'+ex.getLineNumber()+'---'+ex.getStackTraceString());
        } 
    }
    
    global void finish(Database.BatchableContext BC){
        List<String> listEmail          = new List<String>();
        if(Commercial_PR_Trigger_Point__c.getOrgDefaults().Email__c != null)listEmail = Commercial_PR_Trigger_Point__c.getOrgDefaults().Email__c.split(',');
        Messaging.SingleEmailMessage[] messages     = new List<Messaging.SingleEmailMessage>();
        List<String> mobile_MessageList             = new List<String>();
        String mobile_Number                        = Commercial_PR_Trigger_Point__c.getOrgDefaults().Mobile__c;
        try{ 
            for(String fileName  :   fileNameCountMap.keySet()){
                String mobile_Message;
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                
                String mailSubject = 'TU CommercialPR Notification';
                String emailBody = 'We have placed a request file '+fileName+' in production for '+fileNameCountMap.get(fileName)+' customers on '+System.today().format()+', please process and send the response.';
                message.toAddresses = listEmail;
                message.setSubject(mailSubject);
                message.setReplyTo('support@kvb.com');
                message.setSenderDisplayName('KVB TEAM');
                message.setBccSender(false);
                message.setHtmlBody(emailBody);
                messages.add(message);
                
                mobile_Message = 'We have placed a request file '+fileName+' in production for '+fileNameCountMap.get(fileName)+' customers on '+ System.today().format() +', please process and send the response.';
                mobile_MessageList.add(mobile_Message);
            }
            if(mobile_Number != null && mobile_MessageList.size() > 0 && mobile_Number != ''){
                for(String mob_msg : mobile_MessageList){
                    SMS_Services.sendSMSCall(mobile_Number,mob_msg);   
                }
            }
            if(!messages.isEmpty()){
                Messaging.sendEmail(messages); 
            }
            
        }catch(Exception ex){
            System.debug('Error while Sending Email***'+ex.getMessage()+ex.getLineNumber());
        }  
    }  
}