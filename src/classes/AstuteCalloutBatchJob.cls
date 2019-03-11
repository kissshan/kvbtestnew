/*
* Name      : AstuteCalloutBatchJob
* Compnay   : ET Marlabs
* Purpose   : Re-Trigger failed astute record
* Author    : Niladri
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
v1.1        17-Dec-2018     Shubham         FI status and application substage condition added for astute retry query
*******************************************************************************************/
global class AstuteCalloutBatchJob implements Schedulable,Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts {
    String query;
     global Database.QueryLocator start(Database.BatchableContext BC){
        String status='Failed';
        String appSubStage = 'Terms and Conditions Accepted';
        String fistatus1='Not Applicable';
        String fistatus2='Request yet to be initiated';
        query ='select id,Case_Notification_Id__c,Status__c,Property_Type__c,Application__c,Application__r.Record_Type_Name__c,Application__r.Sub_Stage__c,Account__c from Astute_Verification__c where Status__c=:status AND  Application__r.Sub_Stage__c =:appSubStage AND (Application__r.FI_Status__c=:fistatus1 OR Application__r.FI_Status__c=:fistatus2)';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Astute_Verification__c> astutelist) {
        System.debug(astutelist.size()+'**astutelist:::'+astutelist);
        WS_AstuteCallingAPI.astuteRetry2(astutelist);
    }
    
    global void finish(Database.BatchableContext BC){
       
    }

    global void execute(SchedulableContext sc) {
      AstuteCalloutBatchJob b = new AstuteCalloutBatchJob(); 
      database.executebatch(b,5);
   }

}