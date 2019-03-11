/*
* Name          : Batch_JocataListMatching_Scheduler
* Description   : Schdule Batch_JocataListMatching
* Author        : Dushyant
*/
global class Batch_JocataListMatching_Scheduler implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_JocataListMatching(''),1);
    }   
}