/*
* @purpose : Test class for Person_CIBIL_Call
* @author  : Yadagiri
*/ 
@isTest
public class Person_CIBIL_Call_Test {
    public static testmethod void testMethod1() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Account acc1 = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc1;
            
            String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account peracc= new Account(
                RecordTypeID=recordTypeId ,
                FirstName='Test FName',
                LastName='Test LName',
                PersonMailingStreet='test@yahoo.com',
                PersonMailingPostalCode='12345',
                PersonMailingCity='SFO',
                PersonEmail='test@yahoo.com',
                PersonHomePhone='1234567',
                PersonMobilePhone='12345678'
            );
            // CIBIL_Status__pc='Error'
            insert peracc;
            update peracc;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Active__c = true;
            genApp.Application_Stage__c='Identified for renewal';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Renewal_Due_Date__c=system.Today();
            insert genApp;
            
            clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('Test Prodcuct','KVB45','Funded');
            insert clProd;
            
            Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'test2345',2345.50);
            fac.Existing_Limit__c=4555.44;
            insert fac;
            
            genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,acc.id,'Partner','Pending');
            genAppPart.Active__c=true;
            genAppPart.Key_Contact__c=acc.Id;
            genAppPart.genesis__Party_Account_Name__c=acc1.Id;
            insert genAppPart;
            
            Test.startTest();
            Person_CIBIL_Call ob=new Person_CIBIL_Call('');
            DataBase.executeBatch(ob);
            Test.stopTest();
            
        } 
    }
    
}