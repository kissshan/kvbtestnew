/*
* Name          : Batch_JocataListMatchingStatus_Scheduler
* Description   : Schdule Batch_JocataListMatchingStatus
* Author        : Raushan
*/
global class Batch_JocataListMatchStatusSchedular_SNL implements Schedulable { 
    global void execute(SchedulableContext ctx) {
        String condition = 'List_Matching_Stage__c IN:setObject AND genesis__Account__r.Jocata_TxnId__c != null AND Active__c = true AND (RecordType.DeveloperName =:SME_NEW_LOAN_RECORD_TYPE OR RecordType.DeveloperName =:SME_APP_RECORD_TYPE_EXCEEDING) AND CreatedDate =TODAY';
        Database.executeBatch(new Batch_JocataListMatchStatus(condition),1);
    }   
}