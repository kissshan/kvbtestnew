/*
* Name          : Batch_CRILIC_API_Schedular
* Description   : Schdule Batch_CRILIC_API
* Author        : Raushan
*/
global class Batch_CRILIC_API_Schedular implements Schedulable {
	global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_CRILIC_API(),50);
    } 
}