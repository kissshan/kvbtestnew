global class Batch_ApplicationDeactivate_Schedular implements Schedulable{
	global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_ApplicationDeactivate(),5);
    }  
}