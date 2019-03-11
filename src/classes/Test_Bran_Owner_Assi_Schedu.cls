@isTest
public class Test_Bran_Owner_Assi_Schedu {
 public static testMethod void testschedule(){
        Branch_Ownership_Assignment_Scheduler boa=new Branch_Ownership_Assignment_Scheduler();
        string sch='0 0 23 * * ?';
        system.schedule('Branch_Ownership_Assignment_Scheduler', sch, boa);
    } 
}