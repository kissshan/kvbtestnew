/*
*   Name    : Batch_ListMatchingStatus_LAP
*   purpose : Get the status from Jocata List Matching
*   Author  : Amritesh
*/ 
public class Batch_ListMatchingStatus_LAP implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts{
    Static Set<String> APP_SUB_STAGES           = new Set<String>{'Terms and Conditions Accepted'};  
    String query;   
    string whereCondition                   = '';
    public Batch_ListMatchingStatus_LAP(string whereQuery){
        whereCondition    = whereQuery;
    }
    
     public Database.QueryLocator start(Database.BatchableContext BC) {  
         string isBlank       = '';
         String APP_TYPE    = 'LAP';
         if(whereCondition == '' || whereCondition == null){
            whereCondition = 'genesis__Application__r.RecordType.DeveloperName =:APP_TYPE AND genesis__Application__r.Sub_Stage__c IN:APP_SUB_STAGES AND Key_Contact__r.Jocata_TxnId__c != null AND (Key_Contact__r.Jocata_List_Match__c =:isBlank OR Key_Contact__r.Jocata_List_Match__c =null)';
        }
        
        query = 'SELECT Id,Key_Contact__c,Key_Contact__r.Jocata_TxnId__c FROM genesis__Application_Parties__c where ' + whereCondition ;
       
         return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<genesis__Application_Parties__c> records) {
        try{
            Batch_JocataListMatchStatus ctrl                = new Batch_JocataListMatchStatus('');
            Batch_JocataListMatchStatus.updateAccList       = new List<Account>(); 
            for(genesis__Application_Parties__c ap : records){
                JocataListMatching_Model.JocataLMStatusResponse jocataRes= Batch_JocataListMatchStatusHelper.getJocataListMatchingresponse(ap.Key_Contact__r.Jocata_TxnId__c);
                if(jocataRes != null){
                    ctrl.insertListMatchings(jocataRes,ap.Key_Contact__c);
                }
            }
             if(Batch_JocataListMatchStatus.updateAccList.size() > 0){
                AccountTriggerHandler.isAccountTrigger  = true;
                update Batch_JocataListMatchStatus.updateAccList;
            }
        }catch(Exception ex){}
        
    }
     public void finish(Database.BatchableContext BC) {       
        
    }
}