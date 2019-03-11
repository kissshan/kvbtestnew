/*
* Name          : Batch_JocataListMatchStatus_Scheduler
* Description   : Schdule Batch_JocataListMatchStatus
* Author        : Dushyant
*/
global class Batch_JocataListMatchStatus_Scheduler implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_JocataListMatchStatus(''),1);
    }   
}