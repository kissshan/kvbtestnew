global class ExecutionCriteriaDeletionBatch_schedular implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new ExecutionCriteriaDeletionBatch(),200);
    }   
}