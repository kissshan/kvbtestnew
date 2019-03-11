/*
* Name          : CommercialPRBatch_Scheduler
* Description   : Schdule CommercialPRBatch
* Author        : Dushyant
*/
global class CommercialPRBatch_Scheduler implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CommercialPRBatch(''));
    }   
}