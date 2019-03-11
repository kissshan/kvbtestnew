global class SME_PRERENEWAL_BATCH implements Database.Batchable<sObject> {
    String query;
    public SME_PRERENEWAL_BATCH(String query){
        this.query =query;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        String recordTYPE_SME = 'SME_Renewal';
        String query = 'Select id from genesis__Applications__c where ID Not IN (Select Application__c from Renewal_Checklists__c) AND Active__c = true AND RecordType.developerName =:recordTYPE_SME';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<genesis__Applications__c> scope){
        List<id> listId     =   new List<id>(); 
        for(genesis__Applications__c    applObj :   scope) {
            listId.add(applObj.id);
        }
        SME_PRE_RENEWAL_CHECKING.createPrechecklist(listId);
    }
    global void finish(Database.BatchableContext BC) {
        
    }
}