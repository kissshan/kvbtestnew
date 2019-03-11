//written by prashant singh
//code coverage:-82%
@isTest
public class Test_File_Upload_Ctrl {
    @testsetup
    public static void setupMethod()
    {
       
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();
        genesis__Applications__c genApp=SME_TestUtil.createApplication('sdfsdKB23sdfsdfds',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Document_Generation__c='None';
        genApp.Legal_desk_state_flag__c=true;
        genApp.RecordTypeId = genAppRecordType;
        insert genApp;
         Digio_Document_ID__c did=new Digio_Document_ID__c();
        did.Application__c=genApp.id;
        did.Name='hh';
       insert did;
         Attachment attchObj = new Attachment();
        attchObj.ParentId = did.Application__c;
        attchObj.Name     = 'hh_Uploaded';
        attchObj.Body     = blob.valueOf('UHV0IHNvbWUgY2hhcmFjdGVycyB0by'); 
        attchObj.ContentType='jndiwqmmicjdkjdalw';
        
        insert attchObj;
        
         DIGIO_Templates__c digio=new DIGIO_Templates__c();
        digio.Template_Unique_Id__c='56gy78ug';
        digio.Name='C1';        
        insert digio;

        
        
    }
    @isTest
    public static void method1()
    {
        genesis__Applications__c genApp=[select id from genesis__Applications__c];
        Digio_Document_ID__c doc=[select id,Application__c,name from Digio_Document_ID__c];        
       Attachment att=[select id,body,ParentId from Attachment];        
  		apexpages.currentPage().getParameters().put('id',doc.id);
        genesis__Application_Document_Category__c appdoccat=new genesis__Application_Document_Category__c();
        appdoccat.genesis__Application__c=genApp.id;
        appdoccat.name=Constants.LoanDocuments;
        insert appdoccat;
        
       test.startTest();
        File_Upload_Ctrl filupld= new File_Upload_Ctrl();
        filupld.attach=att;
       	filupld.upload();
        
        test.stopTest();
    }
        @isTest
    public static void method2()
    {
        genesis__Applications__c genApp=[select id from genesis__Applications__c];
        Digio_Document_ID__c doc=[select id,Application__c,name from Digio_Document_ID__c];        
       Attachment att=[select id,body,ParentId from Attachment];        
  		apexpages.currentPage().getParameters().put('id',doc.id);
        
       test.startTest();
        File_Upload_Ctrl filupld= new File_Upload_Ctrl();
        filupld.attach=att;
       	filupld.upload();
        
        test.stopTest();
    }
    @isTest
    public static void method3()
    {
        genesis__Applications__c genApp=[select id from genesis__Applications__c];
        Digio_Document_ID__c doc=[select id,Application__c,name from Digio_Document_ID__c];        
       Attachment att=[select id,body,ParentId from Attachment];        
  		apexpages.currentPage().getParameters().put('id',doc.id);
        
       test.startTest();
        File_Upload_Ctrl filupld= new File_Upload_Ctrl();
        filupld.attach=att;
       	filupld.cancel();
        
        test.stopTest();
    }

}