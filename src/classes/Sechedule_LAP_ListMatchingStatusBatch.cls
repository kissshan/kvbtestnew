/*
 * @description: Secheduler for Batch_ListMatchingStatus_LAP
 */ 
global class Sechedule_LAP_ListMatchingStatusBatch implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_ListMatchingStatus_LAP(''),1);
    }   
}