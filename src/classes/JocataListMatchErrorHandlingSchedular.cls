/*
* Name          : TaskBatchSchdular
* Description   : Schdular class for Batch_JocataListMatchErrorHandling
* Author        : Subas
*/
global class JocataListMatchErrorHandlingSchedular {
    global void execute(SchedulableContext sContext) {
        Database.executeBatch(new Batch_JocataListMatchErrorHandling());
    } 
}