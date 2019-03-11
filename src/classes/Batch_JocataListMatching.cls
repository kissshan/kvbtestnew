/*
*   Name    : Batch_JocataListMatching
*   purpose : Get the status FROM Jocata List Matching
*   Author  : Numaan
*/ 
public class Batch_JocataListMatching implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts {
    String query;
    public String appId     = '';
    string whereCondition   = '';
    public List<genesis__Applications__c> appRecords    = new List<genesis__Applications__c>();
    Static Set<String> APP_STAGES                       = new Set<String>{Constants.APPLN_INITIATED};
       
    public Batch_JocataListMatching(string whereQuery){
        whereCondition    = whereQuery;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> listRecordTypeName = new List<String>();
        List<String> divisionNameList   = new List<String>();
        List<user> userList             = new List<User>();
        
        Set<String> setObject   = new Set<String>{'Not Initiated','Error',''}; 
        Integer days            = Utility.getExecuteBatch();
        String Apln_Stage       = 'Greater than 2Cr.';
        
        query = 'SELECT Id,List_Matching_Stage__c,(Select Id,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CIBIL_Status__pc FROM genesis__Application_Parties__r WHERE genesis__Party_Account_Name__c != null AND Active__c = true),genesis__Account__c,genesis__Account__r.Id,genesis__Account__r.Name,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.PersonBirthdate,genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,'+
            'genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingCountry,genesis__Account__r.Nationality__pc,genesis__Account__r.Driving_License_ID__c,genesis__Account__r.Pan_Number__c,genesis__Account__r.BillingStreet,genesis__Account__r.BillingState,'+
            'genesis__Account__r.BillingCity,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingCountry,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Ration_Card__c,genesis__Account__r.PersonMobilePhone,genesis__Account__r.Phone,genesis__Account__r.PersonEmail,genesis__Account__r.Jocata_TxnId__c FROM genesis__Applications__c';
        
        if(whereCondition == '' || whereCondition == null){
            whereCondition = ' Application_Stage__c IN :APP_STAGES AND List_Matching_Stage__c IN :setObject AND Execute_batch_in_days__c <=: days AND Application_Stage__c !=:Apln_Stage AND Active__c = true';
        }
        
        
        /*(If(System.Label.APPLICATION_RECORDTYPE_NAME != null){
            for(String str : (System.Label.APPLICATION_RECORDTYPE_NAME).split(',')){
                listRecordTypeName.add('\''+str+'\'');
            }
            system.debug('listRecordTypeName==++'+listRecordTypeName);
            whereCondition += ' AND Recordtype.DeveloperName  IN'+listRecordTypeName; 
        }*/
        
        
        if(whereCondition != '') query += ' WHERE '+whereCondition; 
        System.debug(query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> records) {
        if(records !=null){
            List<Account>   listAccount             =   new List<Account>();
            List<genesis__Applications__c> listApp  =   new List<genesis__Applications__c>();
            Map<String,String> custIdTxIdMap = new Map<String,String>();
            Boolean checkIfTxnId = false;
            
            for(genesis__Applications__c    appObj      :   records){
                
                genesis__Applications__c appObject   =   new genesis__Applications__c();
                custIdTxIdMap = Batch_jocataListMatchingHelper.getJocataTocken(appObj);
                checkIfTxnId = true;
                System.debug('custIdTxIdMapSize-----> ' + custIdTxIdMap.size());
                System.debug('custIdTxIdMap-----> ' + custIdTxIdMap);
                for(String custId : custIdTxIdMap.keySet()){
                    Account acc = new Account();
                    acc.Id = custId;
                    acc.List_Matching_Trigger_Time__c = System.now();
                    if(custIdTxIdMap.get(custId) != null){
                        acc.Jocata_TxnId__c = custIdTxIdMap.get(custId);
                    }
                    else checkIfTxnId = false;
                    listAccount.add(acc);
                }
                If(appObj != null){
                    System.debug('Flag Value ---> ' + checkIfTxnId);
                    appObject.Id = appObj.Id;
                    if(checkIfTxnId) appObject.List_Matching_Stage__c    = 'Sent';
                    listApp.add(appObject);
                }                   
            } 
            
            If(listAccount.size()>0){               
                    AccountTriggerHandler.isAccountTrigger=true;                
                try{
                    UPDATE listAccount; 
                }catch(Exception ex){
                    System.debug('@@@@@ inside acc UPDATE'+ex.getMessage()+ex.getLineNumber());
                }  
            }
            
            If(listApp.size()>0){                
                    ApplicationTriggerHandler.IsFirstRun=false;                
                try{
                    UPDATE listApp;  
                }catch(Exception ex){
                    System.debug('@@@@@ inside acc UPDATE'+ex.getMessage()+ex.getLineNumber());
                }
            }
        }
        
    }
    
    public void finish(Database.BatchableContext BC) { 
           
        
    }
}