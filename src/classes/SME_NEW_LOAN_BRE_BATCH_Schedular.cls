/*
* Name          : SME_NEW_LOAN_BRE_BATCH_Schedular
* Description   : Schdule SME_NEW_LOAN_BRE_Batch
* Author        : Raushan
*/
global class SME_NEW_LOAN_BRE_BATCH_Schedular implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new SME_NEW_LOAN_BRE_Batch(''));
    }   
}