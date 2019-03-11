@isTest
public class test_Branch_Ownp_Assigt_Scheduler {
      public static testMethod void testschedule() { 
        Test.StartTest();
        Branch_Ownership_Assignment_Scheduler boa = new Branch_Ownership_Assignment_Scheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Branch_Ownership_Assignment_Scheduler', sch, boa); 
        Test.stopTest(); 
      } 
}