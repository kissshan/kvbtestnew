/*
* Name          : TaskBatchSchdular
* Description   : Schdular class for Batch_ListMatchingStatus_LAP
* Author        : Subas
*/
global class Batch_ListMatchingStatus_LAPSchedulaer implements Schedulable{
	global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_ListMatchingStatus_LAP(''),1);
    }  
}