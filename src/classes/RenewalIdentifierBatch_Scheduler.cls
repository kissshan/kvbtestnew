/*
* Name          : RenewalIdentifierBatch_Scheduler
* Description   : Schdule RenewalIdentifierBatch
* Author        : Dushyant
*/
global class RenewalIdentifierBatch_Scheduler implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new RenewalIdentifierBatch(''),1);
    }   
}