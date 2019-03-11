/*
* Name          : ProcessingFee_Scheduler_HL
* Description   : Schdular class for Batch_ProcessingFee
* Author        : Subas
*/
global class ProcessingFee_Scheduler_HL implements Schedulable {    
    global void execute(SchedulableContext sContext) {
        Database.executeBatch(new Batch_ProcessingFee());
    }   
}