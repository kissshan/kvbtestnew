@isTest
public class JocataListMatchStatus_Scheduler_Test {
    @isTest
    public static void testschedule(){
        Test.StartTest();
        Batch_JocataListMatchStatus_Scheduler sh1 = new Batch_JocataListMatchStatus_Scheduler();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    
}