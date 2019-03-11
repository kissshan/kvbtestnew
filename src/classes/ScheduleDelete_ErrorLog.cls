/*
* @name        : ScheduleDelete_ErrorLog
* @description : Schedular class for Batch_Delete_ErrorLog 
* @author      : Souvik Banik
*/

public class ScheduleDelete_ErrorLog implements Schedulable{

	public void execute(SchedulableContext sc) {

		Batch_Delete_ErrorLog bc = new Batch_Delete_ErrorLog();

	database.executebatch(bc);
	}
}