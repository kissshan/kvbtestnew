/*
* Name      : ExpiryofApplicationsBatch
* Compnay   : ET Marlabs
* Purpose   : Close the Applications which are created 60 days back based on the Stage.
* Author    : Vignesh
*/
global class ExpiryofApplicationsBatch implements Database.Batchable<sObject> {
    
    String query;
    Set<Id> accIdSet= new Set<Id>();
    //Set<Id> appIds= new Set<Id>{'a4V0l000000HQkMEAW','a4V0l000000HRYCEA4','a4V0l000000HklBEAS','a4V0l0000004epOEAQ','a4V0l0000004oN9EAI'};
    List<String> appStages= new List<String>{'Adhoc- Application created','Enhancement- Application created','Exceeding- Application created','New loans - Application created'};
    List<Task> taskCompleteList = new List<Task>();
    global ExpiryofApplicationsBatch() {
        query='SELECT id,Application_Stage__c,genesis__Account__c,Type__c from genesis__applications__c  WHERE Application_Stage__c IN: appStages   AND CreatedDate < LAST_N_DAYS:'+Label.Application_Expiry_Days; //AND Id IN :appIds
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<genesis__applications__c> scope) {
        try{
            for(genesis__applications__c app: scope){
                if((app.Type__c!=null && app.Type__c.contains('ETB-CA')) || (app.Type__c!= null && app.Type__c.contains('NTB'))){
                    accIdSet.add(app.genesis__Account__c);
                }
                app.Application_Stage__c= 'Discontinued Application';
                //taskCompleteList = SOQL_Util.completeTask(app.Id);
                taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
            }
            if(accIdSet.size()>0){
                List<Account> accLst= [SELECT id,Active__c from Account WHERE Id IN: accIdSet AND Active__c = true];
                for(Account acc: accLst){
                    acc.Active__c= false;
                }
                AccountTriggerHandler.isAccountTrigger = true;
                Update accLst;
            }
            ApplicationTriggerHandler.IsFirstRun = false;
            Update scope;
            if(taskCompleteList.size() > 0){
                TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
                Update taskCompleteList;
            }
        }catch(Exception e){
            System.debug('Exception Error  '+e.getMessage());
            System.debug('Exception Line Number  '+e.getLineNumber());
            HandleBusinessException.captureError('ExpiryofApplicationsBatch', 'BatchRocess', e);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}