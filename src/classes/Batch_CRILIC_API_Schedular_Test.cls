/*
* Description : Batch_CRILIC_API_Schedular_Test
* Author       : Yadagiri
*/
@isTest
public class Batch_CRILIC_API_Schedular_Test {
    
    @isTest
    public static void method1(){
        Test.StartTest();
        Batch_CRILIC_API sh1 = new Batch_CRILIC_API();      
        String sch = '0 0 23 * * ?';
       //system.schedule('Test',50,sh1);
        Test.stopTest();
    }
    
}