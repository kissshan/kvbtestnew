/*
* Name          : Batch_Perfios_SME_New_Loan_Scheduler
* Description   : Schdule Batch_Perfios_SME_New_Loan_Scheduler
* Author        : Raushan
*/
global class Batch_Perfios_SME_New_Loan_Scheduler implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_Perfios_SME_New_Loan(),1);
    }   
}