//uday--->100%
@isTest
public class Test_SME_BRE_BatchSchdular {
    @isTest
    public static void testMethod1(){
        Test.StartTest();
        SME_BRE_BatchSchdular ba = new SME_BRE_BatchSchdular();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Branch_Ownership_Assignment_Scheduler', sch, ba); 
        Test.stopTest(); 
    }
}