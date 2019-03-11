/*
* Name          : SME_MCLR_BatchSchdular
* Description   : Schdule SME_MCLR_Batch
* Author        : Dushyant
*/
global class SME_MCLR_BatchSchdular implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new SME_MCLR_Batch());
    }   
}