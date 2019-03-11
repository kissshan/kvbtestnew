/*
* Name          : Person_CIBIL_Call_Scheduler
* Description   : Schdule Person_CIBIL_Call
* Author        : Ashik Shetty
*/
global class Person_CIBIL_Call_Scheduler implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Person_CIBIL_Call(''),1);
    }   
}