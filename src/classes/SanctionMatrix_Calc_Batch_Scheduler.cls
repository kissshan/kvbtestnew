/*
* Name          : SanctionMatrix_Calc_Batch_Scheduler
* Description   : Schdule SanctionMatrix_Calc_Batch
* Author        : Dushyant
*/
global class SanctionMatrix_Calc_Batch_Scheduler implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new SanctionMatrix_Calc_Batch(null),1);
    }   
}