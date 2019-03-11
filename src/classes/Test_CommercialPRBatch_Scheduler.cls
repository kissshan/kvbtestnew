@isTest
public class Test_CommercialPRBatch_Scheduler {
    
    @isTest
    public static void method1(){
        
        Test.startTest();
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        
        String sch = '0 0 23 * * ?';
        CommercialPRBatch_Scheduler abs= new CommercialPRBatch_Scheduler();
        String jobId = System.schedule('myJobTestJobName', sch, abs);
        abs.execute(null);
        Test.stopTest();
        
        
        
    }
}