/*
* Name          : TaskBatchSchdular
* Description   : Schdular class for TaskNotificationBatch
* Author        : Dushyant
*/
global class TaskBatchSchdular implements Schedulable {    
    global void execute(SchedulableContext sContext) {
        Database.executeBatch(new TaskNotificationBatch());
    }   
}