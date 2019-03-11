@isTest
public class MasterSyncScheduler_Test {
@isTest
    public static void method1(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        Test.startTest();
       /* MasterSyncBatch obj = new MasterSyncBatch('Branch');
        DataBase.executeBatch(obj); */
        Test.stopTest();
        
    }
}