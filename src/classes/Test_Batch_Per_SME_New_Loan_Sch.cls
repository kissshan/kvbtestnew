/*
* Description : Test_Batch_Per_SME_New_Loan_Sch
* Author      : Kishan Panchal
*/
@istest
public class Test_Batch_Per_SME_New_Loan_Sch {
    @isTest public static  void testschedule() {
        Test.StartTest();
        Batch_Perfios_SME_New_Loan_Scheduler testsche = new Batch_Perfios_SME_New_Loan_Scheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, testsche);
        Test.stopTest();
    }
    
}