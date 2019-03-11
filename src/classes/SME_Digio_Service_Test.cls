/*
* Purpose : Test class for the SME_Digio_Service 
*Author :Yadagiri 
*/
@isTest
public class SME_Digio_Service_Test {
    public static testmethod void testMethod1() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Account[] acct = [SELECT Id from Account WHERE Name='HP Agencies'];
            System.assertEquals(1, acct.size());
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Sanction_Class2_Check__c=True;
            genApp.Sanction_Doc_Generation_Check__c=True;
            genApp.Sanction_Letter_Name__c='Test Letter';
            insert genApp;
            
            genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'partner','Pending');
            insert genAppPart;
            
            Attachment attach=new Attachment();   	
            attach.Name='Unit_Test_Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=genApp.id;
            insert attach;
            
            List<Attachment> attachments=[select id, name from Attachment where parent.id=:genApp.id];
            System.assertEquals(1, attachments.size()); 
            
            Test.startTest();
            SME_Digio_Service.doESignUpdated(genApp.Id,genAppPart.Id);   
            Test.StopTest();
        }
    }
}