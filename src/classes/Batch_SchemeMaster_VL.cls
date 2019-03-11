/*
* Name    : Batch_SchemeMaster_VL for Scheme Inactive after Enddate
* Company : ET Marlabs
* Purpose : This class will be used to make scheme inactive after Scheme expires
* Author  : Ashok
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
======= ==========   =============  ==================================
V1.1    24-Oct-2018   Ashok          Batch Implementation to Inactive Scheme
*******************************************************************************************/

global class Batch_SchemeMaster_VL implements Database.Batchable<sObject>,Schedulable{
	
	String query;
	
	global Batch_SchemeMaster_VL() {
		query = 'Select Id,Name,Scheme_Code__c,Active_Flag__c,End_Date__c from Scheme_Master__c where Active_Flag__c = true AND End_Date__c < Today';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Scheme_Master__c> scope) {
		Batch_SchemeMasterHandler.SchemeMasterHandler(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	global void execute(SchedulableContext CTX){
		Database.executeBatch(new Batch_SchemeMaster_VL(),5);
	}
	
}