/*
* Description : Test_jocataListMatchStatusSch_SNL
* Author      : Kishan Panchal
*/
@isTest
public class Test_jocataListMatchStatusSch_SNL {
    @isTest public static void testSchedul_SNL(){
        Test.StartTest();
        Batch_JocataListMatchStatusSchedular_SNL schObj = new Batch_JocataListMatchStatusSchedular_SNL();
        string sch = '0 0 23 * * ?';
        system.schedule('Test check',sch,schObj);
        Test.stopTest();
    }
}