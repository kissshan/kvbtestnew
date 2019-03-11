/*
* Description : Docket_ESign_Service_Test
* Author       : Yadagiri
*/
@isTest(seeAllData = false)
public class Docket_ESign_Service_Test {
    @isTest
    public static void method1(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account peracc= new Account(
            RecordTypeID=recordTypeId ,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='My way street',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678' 
        );
        
        insert peracc;
        peracc =[select id,RecordType.Name ,name from Account where PersonMailingStreet='My way street' ];
        
        system.debug('peracc.RecordType'+peracc.RecordType.Name);
        
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Overall_Exposure__c=2600000;
        insert genApp;  
        
        
        genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,peracc.Id,'Co-Borrower','Pending');
        genAppPart.Active__c=true;
        insert genAppPart;
        
        Attachment attach=new Attachment();     
        attach.Name='Execution_Certificate_C11_HL.pdf:Agreement of Guarantee.pdf:Acknowledgement_For_Sanction.pdf';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=genApp.id;
        insert attach;
        
        
        Test.startTest();
        Docket_ESign_Service.uploadDocketForCoBrwr(genApp.Id,'Gurantor');
        Test.stopTest();        
    }
}