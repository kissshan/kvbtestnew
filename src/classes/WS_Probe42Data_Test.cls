/*
* Purpose : Test class for the WS_Probe42Data 
*Author :Yadagiri 
*/
@isTest
public class WS_Probe42Data_Test {
    public static testmethod void testMethod1() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Account[] acct = [SELECT Id from Account WHERE Name='HP Agencies'];
            System.assertEquals(1, acct.size());
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            insert genApp;
            
            genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'partner','Pending');
            insert genAppPart;
            
            Map<Id,genesis__Application_Parties__c> genAppPartMap = new Map<Id,genesis__Application_Parties__c>();
            genAppPartMap.put(genAppPart.Id, genAppPart);
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            
            Test.startTest();
            WS_Probe42Data.getResponse('345656','genApp.Id');
            Test.StopTest();
        }
    }
}