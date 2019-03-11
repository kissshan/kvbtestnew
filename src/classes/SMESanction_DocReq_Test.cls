/*
* Name    : SME_TestUtil
* Company  : ET Marlabs
* Purpose   : Test class for SMESanction_DocReq class
* Author  : Yadagiri
* last Modified By : 
*/
@isTest
public class SMESanction_DocReq_Test {
    @testSetup static void setup() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            genesis__Applications__c genApplication=SME_TestUtil.createApplication('KB234',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApplication.Active__c = true;
            genApplication.Application_Stage__c='Limit extended';
            insert genApplication;
            
            // Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Active__c = true;
            genApp.Application_Stage__c='Limit extended';
            genApp.Parent_Application__c=genApplication.Id;
            insert genApp;
            
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
            
            insert peracc;
            
            genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,acc.id,'Partner','Pending');
            genAppPart.Active__c=true;
            genAppPart.Key_Contact__c=acc.Id;
            genAppPart.genesis__Party_Account_Name__c=peracc.Id;
            genApppart.Signatories__c=true;
            genApppart.genesis__Party_Type__c = 'Co-Borrower';
            insert genAppPart;
            
            genesis__Application_Parties__c genAppParts = SME_TestUtil.creategenAppParti(genApp.Id,acc.id,'Partner','Pending');
            genAppParts.Active__c=true;
            genAppParts.Key_Contact__c=acc.Id;
            genAppParts.genesis__Party_Account_Name__c=peracc.Id;
            genAppparts.Signatories__c=true;
            genAppparts.genesis__Party_Type__c = 'Guarantor';
            insert genAppParts;
            
            Id audRecordType = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get('Other').getRecordTypeId();
            Audit__c aud = SME_TestUtil.createAudit(genApp.Id,'SOD','Test terms and conditions',23);
            aud.Account_Name__c=acc.Id;
            aud.RecordTypeId=audRecordType;
            aud.Tag_Name__c ='CORP_ADV_TNC' ;
            aud.Content__c='Test Content';
            aud.User__c=u.Id;
            insert aud;
            
            clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('Test Prodcuct','KVB45','Funded');
            insert clProd;
            
            Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'test2345',2345.50);
            fac.Existing_Limit__c=4555.44;
            insert fac;
            
            MCLR_Master__c mclr = new MCLR_Master__c();
            mclr.COD_prod_type__c='Test Product';
            insert mclr;
        }
    }
    public static testmethod void testMethod1() {
        Account acc =[select id,Name from Account where name='HP Agencies'];
        
        genesis__Applications__c genApps =[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB234' limit 1];
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Facility__c fac=[select id,Existing_Limit__c from Facility__c where Existing_Limit__c=4555.44 limit 1];
        date myDate = date.newInstance(1989, 4, 21);
        Test.startTest();
        SMESanction_DocReq.getcorpAdvTnC();
        SMESanction_DocReq.docChargeCalculation(50000000);
        SMESanction_DocReq.documentDetails();
        SMESanction_DocReq.processingFeeCalculation(new List<Facility__c>{fac},genApp);
        SMESanction_DocReq.genCordStructure(23,genApp.Id,'B1:B2');
        SMESanction_DocReq.getNextRenewalDate(myDate,'Interim Extension');
        SMESanction_DocReq.getMCLRValues();
        Test.stopTest();
        
    }
    public static testmethod void testMethod2() {
        Account acc =[select id,Name from Account where name='HP Agencies'];
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        date myDate = date.newInstance(1989, 1, 21);
        Id audRecordType = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get('Other').getRecordTypeId();
        Audit__c aud = SME_TestUtil.createAudit(genApp.Id,'SOD','Test terms and conditions',23);
        aud.Account_Name__c=acc.Id;
        aud.RecordTypeId=audRecordType;
        aud.Tag_Name__c ='FORX_ADV_TNC' ;
        aud.Content__c='Test Content';
        insert aud;
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id,'A23:B17');
        SMESanction_DocReq.getNextRenewalDate(myDate,'Interim Extension');
        SMESanction_DocReq.getForexAdvTnC();
        Test.stopTest();
        
    }   
    public static testmethod void testMethod3() {
        Account acc =[select id,Name from Account where name='HP Agencies'];
        
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        date myDate = date.newInstance(1989, 3, 21);
        Id audRecordType = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get('Other').getRecordTypeId();
        Audit__c aud = SME_TestUtil.createAudit(genApp.Id,'SOD','Test terms and conditions',23);
        aud.Account_Name__c=acc.Id;
        aud.RecordTypeId=audRecordType;
        aud.Tag_Name__c ='FORX_ADV_TNC_EAE' ;
        aud.Content__c='Test Content';
        insert aud;
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id,'A46');
        SMESanction_DocReq.getNextRenewalDate(myDate,'Interim Extension');
        SMESanction_DocReq.getForexAdvTnCEAE();
        Test.stopTest();
        
    }
    public static testmethod void testMethod4() {
        Account acc =[select id,Name from Account where name='HP Agencies'];
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Id audRecordType = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get('Other').getRecordTypeId();
        Audit__c aud = SME_TestUtil.createAudit(genApp.Id,'SOD','Test terms and conditions',23);
        aud.Account_Name__c=acc.Id;
        aud.RecordTypeId=audRecordType;
        aud.Tag_Name__c ='CORP_ADV_TNC_EAE' ;
        aud.Content__c='Test Content';
        insert aud;
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id,'C1:C11');
        SMESanction_DocReq.getcorpAdvTnCEAE();
        Test.stopTest();
        
    }
    public static testmethod void testMethod5() {
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id, 'PL_Sanction_Letter');
        Test.stopTest();
        
    }
    public static testmethod void testMethod6() {
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id,'PL_Loan_Agreement');
        Test.stopTest();
        
    }
    public static testmethod void testMethod7() {
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id,'LAP_C1');
        Test.stopTest();
        
    }
    public static testmethod void testMethod8() {
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id, 'LAP_A46');
        Test.stopTest();
        
    }
    public static testmethod void testMethod9() {
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id, 'LAP_A23');
        Test.stopTest();
        
    }
    public static testmethod void testMethod10() {
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id, 'B1_EAE');
        Test.stopTest();
        
    }
    public static testmethod void testMethod11() {
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id, 'GCFA_EAE');
        Test.stopTest();
        
    }
    public static testmethod void testMethod12() {
        genesis__Applications__c  genApp=[select id,Branch_code__c from genesis__Applications__c where Branch_code__c='KB23' limit 1];
        Test.startTest();
        SMESanction_DocReq.genCordStructure(23,genApp.Id, 'LAP_B1');
        Test.stopTest();
        
    }
}