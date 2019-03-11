@isTest
public class Test_TaskBatchSchdular {
@isTest
    public static void method1(){
        Test.StartTest();
TaskBatchSchdular sh1 = new TaskBatchSchdular();      
 String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
Test.stopTest();
    }
}