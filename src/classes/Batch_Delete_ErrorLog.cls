/*
* @name        : Batch_Delete_ErrorLog
* @description : Delete all error log record which are 15days old.
* @author      : Souvik Banik
*/
public class Batch_Delete_ErrorLog implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
            string query = 'SELECT Id FROM clcommon__Log__c WHERE createDdate < LAST_N_Days:15 AND Type__c != \'Document generation error\'';
            return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<clcommon__Log__c> logList){
        try{
            List<clcommon__Log__c> listToDelete = new List<clcommon__Log__c>();
            if(! logList.isEmpty())
                for(clcommon__Log__c clLogObj : logList){
                    listToDelete.add(clLogObj);
                }
            DELETE listToDelete;
            Database.EmptyRecycleBin(listToDelete);
        }
        catch(Exception e){
            HandleBusinessException.captureError('Batch_Delete_ErrorLog', 'execute method', e);
        }
    }

    public void finish(Database.BatchableContext BC){
        
    }
}