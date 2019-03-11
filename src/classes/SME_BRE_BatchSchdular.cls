/*
* Name          : SME_BRE_BatchSchdular
* Description   : Schdule SME_BRE_Batch
* Author        : Dushyant
*/
global class SME_BRE_BatchSchdular implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new SME_BRE_Batch(''),1);
    }   
}