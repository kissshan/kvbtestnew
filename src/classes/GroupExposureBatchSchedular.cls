/*
* Name          : GroupExposureBatchSchedular
* Description   : Schdular class for Batch_ToCalculateGroupExposure
* Author        : Dushyant
*/
global class GroupExposureBatchSchedular implements Schedulable {    
    global void execute(SchedulableContext sContext) {
        Database.executeBatch(new Batch_ToCalculateGroupExposure(),100);
    }   
}