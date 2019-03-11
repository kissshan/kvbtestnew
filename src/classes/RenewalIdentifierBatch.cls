/*
* Name     : RenewalIdentifierBatch
* Company  : ET Marlabs
* Purpose  : Batch Class to identify application for renewal
* Author   : Prashant
*/
global class RenewalIdentifierBatch implements Database.Batchable<sObject>,Database.Stateful{
    public String whereCondition                = '';   
    
    public RenewalIdentifierBatch(String condition){
        whereCondition = condition;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        string query='SELECT Id,Renewal_Due_Date__c,Application_Stage__c,Active__c,RecordType.developerName FROM genesis__Applications__c';

        if(whereCondition != null && whereCondition != '') {
            query += ' WHERE ' + whereCondition;      
        }
        else{
            whereCondition=' WHERE RecordType.developerName = \'SME_renewal\' AND Application_Stage__c = \'>6 months due for renewal\' AND Execute_batch_in_days__c = 60 AND Active__c = true';
            query += whereCondition;
        }
        //system.debug('database'+database.query(query).size());
        System.debug('query::'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<genesis__Applications__c> scope){
        for(genesis__Applications__c app : scope){
            app.Application_Stage__c = 'Identified for renewal';
            system.debug('stage:::'+app.Application_Stage__c);
        }
        ApplicationTriggerHandler.IsFirstRun = false;
        UPDATE scope;        
    }
    global void finish(Database.BatchableContext BC){
    }
}