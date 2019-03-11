/*
* Description : Test_SME_Digio_Service_EAE
* Author      : Kishan Panchal
*/
@isTest
public class Test_SME_Digio_Service_EAE {
    @isTest public static void digioServiceMethod1(){
        
        DIGIO_Templates__c dgo  = new DIGIO_Templates__c(Name='A1_EAE',	Template_Unique_Id__c = 'A1_EAE_v.2');
        insert dgo;
        DIGIO_Templates__c dgo1 = new DIGIO_Templates__c(Name='C7_EAE',	Template_Unique_Id__c = 'C7_EAE_v.3');
        insert dgo1;
        DIGIO_Templates__c dgo2 = new DIGIO_Templates__c(Name='C8_EAE',	Template_Unique_Id__c = 'C8_EAE_v.5');
        insert dgo2;
        DIGIO_Templates__c dgo3 = new DIGIO_Templates__c(Name='C9_EAE',	Template_Unique_Id__c = 'C9_EAE_v.4');
        insert dgo3;
        
        Account accObj = SME_TestUtil.createAccount('test','1857','123456','test','father','kvb');
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        insert genApp;
        
        clcommon__Collateral__c colObj =  SME_TestUtil.createcollateral(genApp.id, 'test', 'property');
        insert colObj;
        
        Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        
        Facility__c fcParentObj = new Facility__c();
        fcParentObj.RecordTypeId              = devRecordTypeId;
        fcParentObj.role__C                   ='BR';
        fcParentObj.Application__c            = genApp.Id;
        fcParentObj.Higher_Authority_Order__c = 67;
        insert fcParentObj;
        
        Facility__c fcChildObj = new Facility__c();
        fcChildObj.RecordTypeId                = devRecordTypeId1;
        fcChildObj.Role__c                     = 'BR'; 
        fcChildObj.Facility__c                 = fcParentObj.Id;
        fcChildObj.Deviation_Approver__c       = true;
        fcChildObj.Highest_Authority__c        = true;
        fcChildObj.Is_Referred_Back_Enabled__c = true;
        fcChildObj.Read_Only_User__c           = true;
        fcChildObj.Higher_Authority_Order__c   = 0;
        insert fcChildObj;
        
        Attachment attchObj = new Attachment();
        attchObj.ParentId = genApp.Id;
        attchObj.Name     = 'test';
        attchObj.Body     = blob.valueOf('UHV0IHNvbWUgY2hhcmFjdGVycyB0by');
        insert attchObj;
        
        list<id> lstIdObj = new list<id>();
        lstIdObj.add(fcChildObj.id);
        String testLbl = Label.A1_EAE;
        
        SME_Digio_Service_EAE.docGenAndSignDoc(genApp.Id,'MOD Needed',lstIdObj,colObj.id);
    }
    
    @isTest public static void digioServiceMethod2(){
        
        DIGIO_Templates__c dgo     = new DIGIO_Templates__c(Name='B1_EAE',	Template_Unique_Id__c = '5b28ad0007c01e2054483587');
        insert dgo;
        KVB_Endpoint_URLs__c kvb   = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb;
        KVB_Endpoint_URLs__c kvb1  = new KVB_Endpoint_URLs__c(name='ListMatchingSatusAPI',Endpoint_URL__c='http://www.kvbbank.net/next/v1/kyc/status/listmatching?txnId=');
        insert kvb1;
        KVB_Endpoint_URLs__c  kvb2 = new  KVB_Endpoint_URLs__c(name='eStamp_url_test',Endpoint_URL__c='	https://kvb-test.apigee.net/next/v1/estamp');
        insert kvb2;
        
        Account accObj = SME_TestUtil.createAccount('test','1857','123456','test','father','kvb');
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        insert genApp;
        
        clcommon__Collateral__c colObj =  SME_TestUtil.createcollateral(genApp.id, 'test', 'property');
        colObj.Ownership_Type__c = 'Single';
        insert colObj;
        
        Id devRecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        
        Facility__c fcParentObj = new Facility__c();
        fcParentObj.RecordTypeId              = devRecordTypeId;
        fcParentObj.role__C                   ='BR';
        fcParentObj.Application__c            = genApp.Id;
        fcParentObj.Higher_Authority_Order__c = 67;
        insert fcParentObj;
        
        Facility__c fcChildObj = new Facility__c();
        fcChildObj.RecordTypeId                = devRecordTypeId1;
        fcChildObj.Role__c                     = 'BR'; 
        fcChildObj.Facility__c                 = fcParentObj.Id;
        fcChildObj.Deviation_Approver__c       = true;
        fcChildObj.Highest_Authority__c        = true;
        fcChildObj.Is_Referred_Back_Enabled__c = true;
        fcChildObj.Read_Only_User__c           = true;
        fcChildObj.Higher_Authority_Order__c   = 0;
        insert fcChildObj;
        
        Attachment attchObj = new Attachment();
        attchObj.ParentId = genApp.Id;
        attchObj.Name     = 'test';
        attchObj.Body     = blob.valueOf('UHV0IHNvbWUgY2hhcmFjdGVycyB0by');
        insert attchObj;
        
        Branch_Master__c branchObj = new Branch_Master__c();
        branchObj.CODCCBRN__c = accObj.Branch_Code__c;
        branchObj.State__c    = 'Chennai';
        insert branchObj;
        
        list<id> lstIdObj = new list<id>();
        String testLbl = Label.A1_EAE;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_Digio_Service_EAE.docGenAndSignDoc(genApp.Id,'MOD Needed',lstIdObj,colObj.id);
        Test.stopTest();
    }
    @isTest public static void digioServiceMethod3(){
        
        
        DIGIO_Templates__c dgo  = new DIGIO_Templates__c(Name='Loan Agreement',Template_Unique_Id__c = '5b29076f07c01e2054483598');
        insert dgo;
        DIGIO_Templates__c dgo1 = new DIGIO_Templates__c(Name='Sanction Document',Template_Unique_Id__c = 'Sanction_Document_v5');
        insert dgo1;
        DIGIO_Templates__c dgo2 = new DIGIO_Templates__c(Name='Guarantor Agreement',Template_Unique_Id__c = '5b27a225d9bfaf2fe01e293c');
        insert dgo2;
        
        KVB_Endpoint_URLs__c kvb   = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb;
        KVB_Endpoint_URLs__c kvb1  = new KVB_Endpoint_URLs__c(name='ListMatchingSatusAPI',Endpoint_URL__c='http://www.kvbbank.net/next/v1/kyc/status/listmatching?txnId=');
        insert kvb1;
        KVB_Endpoint_URLs__c  kvb2 = new  KVB_Endpoint_URLs__c(name='eStamp_url_test',Endpoint_URL__c='	https://kvb-test.apigee.net/next/v1/estamp');
        insert kvb2;
        
        KVB_Company_Details__c kvbDtl = new KVB_Company_Details__c(Penal_Interest__c = 20,Commitment_charges__c = 5);
        insert kvbDtl;
        
        Account accObj = SME_TestUtil.createAccount('test','1857','123456','test','father','kvb');
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        insert accObj;
        
        Account accObj1 = new Account();
        accObj1.RecordTypeId      = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj1.PersonMobilePhone = '123456';
        accObj1.FirstName         = 'test';
        accObj1.LastName          = 'test1';
        insert accObj1;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        insert genApp;
        
        clcommon__Collateral__c colObj =  SME_TestUtil.createcollateral(genApp.id, 'test', 'property');
        colObj.Ownership_Type__c = 'Single';
        colObj.Active__c         = true;
        insert colObj;
        
        Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        
        Facility__c fcParentObj = new Facility__c();
        fcParentObj.RecordTypeId              = devRecordTypeId;
        fcParentObj.role__C                   = 'BR';
        fcParentObj.Application__c            = genApp.Id;
        fcParentObj.Higher_Authority_Order__c = 67;
        insert fcParentObj;
        
        Facility__c fcChildObj = new Facility__c();
        fcChildObj.RecordTypeId                = devRecordTypeId1;
        fcChildObj.Role__c                     = 'BR'; 
        fcChildObj.Facility__c                 = fcParentObj.Id;
        fcChildObj.Deviation_Approver__c       = true;
        fcChildObj.Highest_Authority__c        = true;
        fcChildObj.Is_Referred_Back_Enabled__c = true;
        fcChildObj.Read_Only_User__c           = true;
        fcChildObj.Higher_Authority_Order__c   = 0;
        insert fcChildObj;
        
        
        genesis__Application_Collateral__c genAppCol = new genesis__Application_Collateral__c();
        genAppCol.Application__c         = genApp.id;
        genAppCol.genesis__Collateral__c = colObj.Id;
        genAppCol.Facility__c            = fcParentObj.Id;
        insert genAppCol;
        
        Attachment attchObj = new Attachment();
        attchObj.ParentId = genApp.Id;
        attchObj.Name     ='test';
        attchObj.Body     = blob.valueOf('UHV0IHNvbWUgY2hhcmFjdGVycyB0by');
        insert attchObj;
        
        Branch_Master__c branchObj = new Branch_Master__c();
        branchObj.CODCCBRN__c = accObj.Branch_Code__c;
        branchObj.State__c    = 'Chennai';
        insert branchObj;
        
        genesis__Application_Parties__c partyObj = new genesis__Application_Parties__c();
        partyObj.Guarantor__c                   = true;
        partyObj.Active__c                      = true;
        partyObj.Signatories__c                 = true;
        partyObj.genesis__Application__c        = genApp.id;
        partyObj.Key_Contact__c                 = accObj.id;
        partyObj.genesis__Party_Account_Name__c = accObj1.id;
        insert partyObj;
        
        list<id> lstIdObj = new list<id>();
        String testLbl = Label.A1_EAE;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_Digio_Service_EAE.docGenAndSignDoc(genApp.Id,'MOD Needed',lstIdObj,'');
        Test.stopTest();
    }
    @isTest public static void digioServiceMethod4(){
        
        
        DIGIO_Templates__c dgo = new DIGIO_Templates__c(Name='SME_SanctionLetter',Template_Unique_Id__c = 'SanctionLetterV1.4');
        insert dgo;
        
        KVB_Endpoint_URLs__c kvb   = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb;
        KVB_Endpoint_URLs__c kvb1  = new KVB_Endpoint_URLs__c(name='ListMatchingSatusAPI',Endpoint_URL__c='http://www.kvbbank.net/next/v1/kyc/status/listmatching?txnId=');
        insert kvb1;
        KVB_Endpoint_URLs__c  kvb2 = new  KVB_Endpoint_URLs__c(name='eStamp_url_test',Endpoint_URL__c='	https://kvb-test.apigee.net/next/v1/estamp');
        insert kvb2;
        
        KVB_Company_Details__c kvbDtl = new KVB_Company_Details__c(Penal_Interest__c = 20,Commitment_charges__c = 5);
        insert kvbDtl;
        
        Account accObj = SME_TestUtil.createAccount('test','1857','123456','test','father','kvb');
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        insert accObj;
        
        Account accObj1 = new Account();
        accObj1.RecordTypeId      = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj1.PersonMobilePhone = '123456';
        accObj1.FirstName         = 'test';
        accObj1.LastName          = 'test1';
        insert accObj1;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Final Sanction','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Sanction_Doc_Generation_Check__c = false;
        insert genApp;
        
        clcommon__Collateral__c colObj =  SME_TestUtil.createcollateral(genApp.id, 'test', 'property');
        colObj.Ownership_Type__c = 'Single';
        colObj.Active__c         = true;
        insert colObj;
        
        Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        
        Facility__c fcParentObj = new Facility__c();
        fcParentObj.RecordTypeId              = devRecordTypeId;
        fcParentObj.role__C                   ='BR';
        fcParentObj.Application__c            = genApp.Id;
        fcParentObj.Higher_Authority_Order__c = 67;
        insert fcParentObj;
        
        Facility__c fcChildObj = new Facility__c();
        fcChildObj.RecordTypeId                = devRecordTypeId1;
        fcChildObj.Role__c                     = 'BR'; 
        fcChildObj.Facility__c                 = fcParentObj.Id;
        fcChildObj.Deviation_Approver__c       = true;
        fcChildObj.Highest_Authority__c        = true;
        fcChildObj.Is_Referred_Back_Enabled__c = true;
        fcChildObj.Read_Only_User__c           = true;
        fcChildObj.Higher_Authority_Order__c   = 0;
        insert fcChildObj;
        
        
        genesis__Application_Collateral__c genAppCol = new genesis__Application_Collateral__c();
        genAppCol.Application__c         = genApp.id;
        genAppCol.genesis__Collateral__c = colObj.Id;
        genAppCol.Facility__c            = fcParentObj.Id;
        insert genAppCol;
        
        Attachment attchObj = new Attachment();
        attchObj.ParentId = genApp.Id;
        attchObj.Name     = 'test';
        attchObj.Body     = blob.valueOf('UHV0IHNvbWUgY2hhcmFjdGVycyB0by');
        insert attchObj;
        
        Branch_Master__c branchObj = new Branch_Master__c();
        branchObj.CODCCBRN__c = accObj.Branch_Code__c;
        branchObj.State__c    = 'Chennai';
        insert branchObj;
        
        genesis__Application_Parties__c partyObj = new genesis__Application_Parties__c();
        partyObj.Guarantor__c                   = true;
        partyObj.Active__c                      = true;
        partyObj.Signatories__c                 = true;
        partyObj.genesis__Application__c        = genApp.id;
        partyObj.Key_Contact__c                 = accObj.id;
        partyObj.genesis__Party_Account_Name__c = accObj1.id;
        insert partyObj;
        
        list<id> lstIdObj = new list<id>();
        
        String testLbl = Label.A1_EAE;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_Digio_Service_EAE.docGenAndSignDoc(genApp.Id,'test',lstIdObj,'');
        Test.stopTest();
    }
    
    @isTest public static void digioServiceMethod5(){
        
        
        DIGIO_Templates__c dgo1 = new DIGIO_Templates__c(Name='SME_SanctionLetter',Template_Unique_Id__c = 'SanctionLetterV1.4');
        insert dgo1;
        DIGIO_Templates__c dgo2 = new DIGIO_Templates__c(Name='Exceeding Sanction Letter',Template_Unique_Id__c = 'Ex_Sanction_Letter_1.4');
        insert dgo2;
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='DocGeneration',Endpoint_URL__c='	/bpmsUAT/rest/CueRest/invokeESBService/CreateDocTemplate');
        insert kvb1;
        
        KVB_Company_Details__c kvbDtl = new KVB_Company_Details__c(Penal_Interest__c = 20,Commitment_charges__c = 5,City__c = 'Chennai');
        insert kvbDtl;
        
        Account accObj = SME_TestUtil.createAccount('test','1857','123456','test','father','kvb');
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        insert accObj;
        
        Account accObj1 = new Account();
        accObj1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj1.PersonMobilePhone = '123456';
        accObj1.FirstName         = 'test';
        accObj1.LastName          = 'test1';
        insert accObj1;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Final Sanction','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
        genApp.Type__c = 'ETB-WC';
        genApp.Sanction_Doc_Generation_Check__c = false;
        insert genApp;
        
        clcommon__Collateral__c colObj =  SME_TestUtil.createcollateral(genApp.id, 'test', 'property');
        colObj.Ownership_Type__c = 'Single';
        colObj.Active__c = true;
        insert colObj;
        
        Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        
        Facility__c fcParentObj = new Facility__c();
        fcParentObj.RecordTypeId = devRecordTypeId;
        fcParentObj.role__C='BR';
        fcParentObj.Application__c = genApp.Id;
        fcParentObj.Higher_Authority_Order__c=67;
        insert fcParentObj;
        
        Facility__c fcChildObj = new Facility__c();
        fcChildObj.RecordTypeId = devRecordTypeId1;
        fcChildObj.Role__c = 'BR'; 
        fcChildObj.Facility__c = fcParentObj.Id;
        fcChildObj.Deviation_Approver__c = true;
        fcChildObj.Highest_Authority__c = true;
        fcChildObj.Is_Referred_Back_Enabled__c = true;
        fcChildObj.Read_Only_User__c = true;
        fcChildObj.Higher_Authority_Order__c = 0;
        insert fcChildObj;
        
        genesis__Application_Collateral__c genAppCol = new genesis__Application_Collateral__c();
        genAppCol.Application__c = genApp.id;
        genAppCol.genesis__Collateral__c = colObj.Id;
        genAppCol.Facility__c = fcParentObj.Id;
        insert genAppCol;
        
        Attachment attchObj = new Attachment();
        attchObj.ParentId = genApp.Id;
        attchObj.Name='test';
        attchObj.Body = blob.valueOf('UHV0IHNvbWUgY2hhcmFjdGVycyB0by');
        insert attchObj;
        
        Branch_Master__c branchObj = new Branch_Master__c();
        branchObj.CODCCBRN__c = accObj.Branch_Code__c;
        branchObj.State__c = 'Chennai';
        insert branchObj;
        
        genesis__Application_Parties__c partyObj = new genesis__Application_Parties__c();
        partyObj.Guarantor__c = true;
        partyObj.Active__c = true;
        partyObj.Signatories__c = true;
        partyObj.genesis__Application__c = genApp.id;
        partyObj.Key_Contact__c = accObj.id;
        partyObj.genesis__Party_Account_Name__c = accObj1.id;
        insert partyObj;
        list<id> lstIdObj = new list<id>();
        String testLbl = Label.A1_EAE;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_Digio_Service_EAE.docGenAndSignDoc(genApp.Id,'test',lstIdObj,'');
        Test.stopTest();
    }
    @isTest public static void digioServiceMethod6(){
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='DigioESign',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/DocumentUploadPdf');
        insert kvb1;
        
        Account accObj = SME_TestUtil.createAccount('test','1857','123456','test','father','kvb');
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        insert accObj;
        
        Account accObj1 = new Account();
        accObj1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj1.PersonMobilePhone = '123456';
        accObj1.FirstName = 'test';
        accObj1.LastName = 'test1';
        insert accObj1;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Final Sanction','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
        genApp.Type__c = 'ETB-WC';
        genApp.Sanction_Doc_Generation_Check__c = false;
        insert genApp;
        
        clcommon__Collateral__c colObj =  SME_TestUtil.createcollateral(genApp.id, 'test', 'property');
        colObj.Ownership_Type__c = 'Single';
        colObj.Active__c = true;
        insert colObj;
        
        Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        
        Facility__c fcParentObj = new Facility__c();
        fcParentObj.RecordTypeId = devRecordTypeId;
        fcParentObj.role__C='BR';
        fcParentObj.Application__c = genApp.Id;
        fcParentObj.Higher_Authority_Order__c=67;
        insert fcParentObj;
        
        Facility__c fcChildObj = new Facility__c();
        fcChildObj.RecordTypeId = devRecordTypeId1;
        fcChildObj.Role__c = 'BR'; 
        fcChildObj.Facility__c = fcParentObj.Id;
        fcChildObj.Deviation_Approver__c = true;
        fcChildObj.Highest_Authority__c = true;
        fcChildObj.Is_Referred_Back_Enabled__c = true;
        fcChildObj.Read_Only_User__c = true;
        fcChildObj.Higher_Authority_Order__c = 0;
        insert fcChildObj;
        
        genesis__Application_Collateral__c genAppCol = new genesis__Application_Collateral__c();
        genAppCol.Application__c = genApp.id;
        genAppCol.genesis__Collateral__c = colObj.Id;
        genAppCol.Facility__c = fcParentObj.Id;
        insert genAppCol;
        
        Attachment attchObj = new Attachment();
        attchObj.ParentId = genApp.Id;
        attchObj.Name='test';
        attchObj.Body = blob.valueOf('UHV0IHNvbWUgY2hhcmFjdGVycyB0by');
        insert attchObj;
        
        Branch_Master__c branchObj = new Branch_Master__c();
        branchObj.CODCCBRN__c = accObj.Branch_Code__c;
        branchObj.State__c = 'Chennai';
        insert branchObj;
        
        genesis__Application_Parties__c partyObj = new genesis__Application_Parties__c();
        partyObj.Guarantor__c = true;
        partyObj.Active__c = true;
        partyObj.Signatories__c = true;
        partyObj.genesis__Application__c = genApp.id;
        partyObj.Key_Contact__c = accObj.id;
        partyObj.genesis__Party_Account_Name__c = accObj1.id;
        insert partyObj;
        
        Digio_Document_ID__c dgoDoc = SME_TestUtil.createDgioDoc(genApp.id,'test');
        dgoDoc.Document_ID__c = attchObj.Id;
        insert dgoDoc;
        
        Document_Applicant__c docApp  = new Document_Applicant__c();
        docApp.Party__c = partyObj.Id;
        docApp.Digio_Document_ID__c = dgoDoc.id;
        docApp.llx__c = 325.90;
        docApp.lly__c = 258.98;
        docApp.urx__c = 234.45;
        docApp.ury__c = 321.12;
        docApp.Signer_page_no__c = 5;
        insert docApp;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_Digio_Service_EAE.doESignUpdated(genApp.Id,docApp.Id);
        Test.stopTest();
        
    }
    @isTest public static void digioServiceMethod7(){
        map<string,string> mapObj = new map<string,string>();
        mapObj.put('abc','123');
        
        Account accObj = SME_TestUtil.createAccount('test','1857','123456','test','father','kvb');
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Final Sanction','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        genApp.Type__c = 'ETB-WC';
        genApp.Active__c = true;
        
        genApp.Application_Stage__c = 'Interim sanction offered';
        genApp.Sanction_Doc_Generation_Check__c = false;
        insert genApp;
        
        Attachment attchObj = new Attachment();
        attchObj.ParentId = genApp.Id;
        attchObj.Name='Sanction';
        attchObj.Body = blob.valueOf('UHV0IHNvbWUgY2hhcmFjdGVycyB0by');
        insert attchObj;
        
        Test.startTest();
        SME_Digio_Service_EAE.createFailedDocLogs(genApp,mapObj);
        SME_Digio_Service_EAE.documentDetails();
        Test.stopTest();
    }
}