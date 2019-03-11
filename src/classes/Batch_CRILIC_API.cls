/*
* Name     : Batch_CRILIC_API
* Company  : ET Marlabs
* Purpose  : Batch class for CRILIC API . 
* Author   : Raushan
*/

public class Batch_CRILIC_API implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts {
    
    Map<String,Id> mapOfAccount = new Map<String,Id>();
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        Date startDate = Date.today().addDays(-Integer.valueOf(15));
        String query = 'select id,CreatedDate,genesis__Account__c,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.Crilc_Info__c,genesis__Account__r.CRILC_TxnId__c from genesis__Applications__c'+
            			' where CreatedDate >= :startDate AND genesis__Account__r.CRILC_TxnId__c !=null AND genesis__Account__r.Crilc_Info__c = null';
        return Database.getQueryLocator(query);
        
    }
    
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> records){
        If(records !=null){
            System.debug('List of Record'+records);
            Integer count = 0;
            for(genesis__Applications__c	appObj	:	records){
                
                If(appObj !=null){
                    System.debug('Application Details'+appObj);
                    If(!mapOfAccount.containsKey(appObj.genesis__Account__r.CBS_Customer_ID__c)){
                     	
                        WS_CRILC_API_Response.getResponse(appObj.genesis__Account__c);
                        
                        mapOfAccount.put(appObj.genesis__Account__r.CBS_Customer_ID__c,appObj.genesis__Account__c);
                        count++;   
                    }
                    
                }
            }
            System.debug('Count++'+count);
        }
        
    }
    public void finish(Database.BatchableContext BC) {
        
    }
    
}