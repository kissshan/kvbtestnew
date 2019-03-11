/*
* Name          : Branch_Ownership_Assignment_Scheduler
* Description   : Schdule Branch_Ownership_Assignment
* Author        : Ashik Shetty
*/
global class Branch_Ownership_Assignment_Scheduler implements Schedulable {    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Branch_Ownership_Assignment(),1);
    }   
}