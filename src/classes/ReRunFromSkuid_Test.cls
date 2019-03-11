/*
* Description : ReRunFromSkuid_Test
* Author       : Yadagiri
*/
@isTest
public class ReRunFromSkuid_Test {
    @isTest
    public static void method1(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        insert genApp;
      
        Test.startTest();
        ReRunFromSkuid.reRunMethod(genApp.Id);
        Test.stopTest();
        
    }
}