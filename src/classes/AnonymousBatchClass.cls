/*
* Name     : AnonymousBatchClass
* Company  : ET Marlabs
* Purpose  : Anonymous_Perpose
* Author   : Dushyant
*/
global class AnonymousBatchClass implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id FROM genesis__Application_Document_Category__c WHERE genesis__Application__c = null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<genesis__Application_Document_Category__c> appList){
        DELETE appList;
    }
    global void finish(Database.BatchableContext BC){}
    
}