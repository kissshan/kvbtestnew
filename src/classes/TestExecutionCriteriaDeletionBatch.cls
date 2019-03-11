@isTest
public class TestExecutionCriteriaDeletionBatch {
    static testMethod void deleteBatch()
    {
        String cronExpr = '0 0 0 15 3 ? 2022';
        String jobRunningTime = '2022-03-15 00:00:00';
        List<clcommon__Execution_Criteria_Result__c> exList = new List<clcommon__Execution_Criteria_Result__c>();
        for(integer i=0 ;i<200; i++)
        {
            clcommon__Execution_Criteria_Result__c ex = new clcommon__Execution_Criteria_Result__c();
            ex.clcommon__Description__c = 'test'+i;
            exList.add(ex);
        }        
        insert exList;
        
        Test.startTest();
        String jobId = System.schedule('myJobTestJobName', cronExpr, new ExecutionCriteriaDeletionBatch_schedular());
        Test.stopTest();
    }    
}