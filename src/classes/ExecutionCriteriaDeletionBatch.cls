global class ExecutionCriteriaDeletionBatch implements Database.Batchable<sObject>,Schedulable{
    
    public Database.QueryLocator start(Database.BatchableContext context)
    {
        return Database.getQueryLocator('Select ID from clcommon__Execution_Criteria_Result__c');
    }
    
    public void execute(Database.BatchableContext context, List<SObject> records)
    {
        if(records.size()>0){ 
            integer inte = records.size();
            delete records;
        }        
    }
   
    global void execute(SchedulableContext ctx) 
    {
        Database.executeBatch(new ExecutionCriteriaDeletionBatch());
    }

    global void finish(Database.BatchableContext BC){
    }
}