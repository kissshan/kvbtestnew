global class Batch_CSVAdd implements Database.Batchable<sObject>, Database.Stateful{
    global Static String abc = '';
	 global Database.QueryLocator start(Database.BatchableContext BC){
    
        String query = 'SELECT Id, OwnerId, Test_check__c, Owner_name__c,Task_Subject__c, Application_Name__c,Subject, WhatId, ActivityDate,Createddate, Pending_Days__c, Due_Date__c,Created_Date__c,Owner_Division__c,Owner.UserRole.Name,Status,Owner_Branch__c, Product_Name__c, Application_Type__c, Application_Record_Type__c FROM Task Where Status !=\'Completed\' AND ActivityDate != null AND Subject != null AND Due_Date__c != null';
    
        return Database.getquerylocator(query);
        
    }
    global void execute(Database.BatchableContext BC, List<Task> scope){
        System.debug('11111111'+abc);
        for(Task tk : scope){
            if(abc != ''){
                abc += tk.Task_Subject__c; 
                System.debug('2222222'+abc);
            }else{
                abc = 'shubham';
                System.debug('333333'+abc);
            }
            
		}
    }
    global void finish(Database.BatchableContext BC){
           system.debug(abc);
    }

}