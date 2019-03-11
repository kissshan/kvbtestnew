/*
* Name          : ThreeMonthMCLR_Scheduler
* Description   : Schdular class for Batch_MCLRThreeMonths
* Author        : Subas
*/
global class ThreeMonthMCLR_Scheduler implements Schedulable {    
    global void execute(SchedulableContext sContext) {
        Database.executeBatch(new Batch_MCLRThreeMonths());
    }   
}