/*
* @name        : Batch_Delete_ErrorLogTest
* @description : Test class for Batch_Delete_ErrorLog.
* @author      : Souvik Banik
*/

@isTest 
private class Batch_Delete_ErrorLogTest {

    public static testMethod void batchTest(){
        clcommon__Log__c clLog = new clcommon__Log__c();
        clLog.Class_Name__c = 'Test';
        clLog.clcommon__Type__c = 'System.ListException';
        //clLog.CreatedDate = Date.today().addDays(-16);
        INSERT clLog;
        Test.setCreatedDate(clLog.Id, Date.today().addDays(-16));
     
        Batch_Delete_ErrorLog b = new Batch_Delete_ErrorLog();
        Id batchId = Database.executeBatch(b);
        System.assert(batchId != null);

    }  
    public static testMethod void batchTest3(){
       	Database.BatchableContext BC;
        Batch_Delete_ErrorLog batchInstance = new Batch_Delete_ErrorLog();
        batchInstance.execute(BC,null);

    } 
    public static testMethod void batchTest4(){
       	Batch_Delete_ErrorLog batchInstance = new Batch_Delete_ErrorLog();
        batchInstance.start(null);
    }

}