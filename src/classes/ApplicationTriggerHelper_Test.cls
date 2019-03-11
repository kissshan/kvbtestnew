/*
* Description : ApplicationTriggerHandler_Test
* Author       : Yadagiri
*/
@isTest
public class ApplicationTriggerHelper_Test {
   @isTest
    public static void method1(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Exceeding-Final sanction';
            genApp.Qualitative_input_done__c=false;
            genApp.Industry_type_Application__c='Manufacturing';
            insert genApp;
            
          
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c='Limit extended';
            genApp.Qualitative_input_done__c=true;
            genApp.Industry_type_Application__c='TRADING';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
           /* clcommon__Collateral__c collateral = SME_TestUtil.createcollateral(genApp.Id,'Test Collateral');
            collateral.FE_Created__c=True;
            collateral.Active__c=True;
            insert collateral;
            
            genesis__Application_Collateral__c genAppColl = new genesis__Application_Collateral__c();
            genAppColl.genesis__Application__c= genApp.Id;
            insert genAppColl;*/
          
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            
            Perfios__c perfio = SME_TestUtil.createperfios(genApp.Id,acc.Id);
            insert perfio;
            
            genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
            genAppPart.Active__c=True;
            insert genAppPart;
            
            genesis__Application_Parties__c genAppParties= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Proprietor','Signed');
            genAppParties.Active__c=True;
            insert genAppParties;
            
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
    @isTest
    public static void method11(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Sanctioned';
            genApp.Qualitative_input_done__c=false;
            genApp.Industry_type_Application__c='Manufacturing';
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
             genApp.Application_Stage__c='Limit extended';
            genApp.Qualitative_input_done__c=true;
            genApp.Industry_type_Application__c='TRADING';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
                   
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            
            Perfios__c perfio = SME_TestUtil.createperfios(genApp.Id,acc.Id);
            insert perfio;
            
            genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
            genAppPart.Active__c=True;
            insert genAppPart;
            
            genesis__Application_Parties__c genAppParties= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Proprietor','Signed');
            genAppParties.Active__c=True;
            insert genAppParties;
            
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
        @isTest
    public static void method111(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Sanctioned';
            genApp.Qualitative_input_done__c=false;
            genApp.Industry_type_Application__c='Manufacturing';
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
             genApp.Application_Stage__c='Customer follow up- Critical changes';
            genApp.Qualitative_input_done__c=true;
            genApp.Industry_type_Application__c='TRADING';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
                   
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            
            Perfios__c perfio = SME_TestUtil.createperfios(genApp.Id,acc.Id);
            insert perfio;
            
            genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
            genAppPart.Active__c=True;
            insert genAppPart;
            
            genesis__Application_Parties__c genAppParties= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Proprietor','Signed');
            genAppParties.Active__c=True;
            insert genAppParties;
            
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
   
@isTest
public static void method2(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Exceeding-Final sanction';
            genApp.Application_UI_Stage__c='EnhancementView';
            insert genApp;
            
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
            
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Application filling initiated';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
    @isTest
public static void method21(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Exceeding-Final sanction';
            genApp.Application_UI_Stage__c='EnhancementView';
            insert genApp;
            
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
            
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Final Sanction';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
   @isTest
public static void method3(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            acc.Priority_Sector__c=True;
            update acc;
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            genapp.Qualitative_input_done__c=false;
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            fcparentObj.Recommended_Limit__c=500000;
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
            
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Exceeding-Final sanction';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genapp.Qualitative_input_done__c=true;
            genApp.Sanction_Authority__c='BR_MGR';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
     @isTest
public static void method31(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Priority_Sector__c=True;
            acc.Overall_Exposure__c=25000;
            insert acc;
            
           
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            genapp.Qualitative_input_done__c=false;
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            list<Facility__c> fac=new list<Facility__c>();
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            fcparentObj.Recommended_Limit__c=800000;
            fac.add(fcparentObj);
            
            Facility__c fc1 = new Facility__c();
            fc1.RecordTypeId = devRecordTypeId;
            fc1.role__C='BR';
            fc1.Application__c = genApp.Id;
            fc1.Higher_Authority_Order__c=67;
            fc1.Recommended_Limit__c=2000000;
            fac.add(fc1);
            
            Facility__c fc2 = new Facility__c();
            fc2.RecordTypeId = devRecordTypeId;
            fc2.role__C='BR';
            fc2.Application__c = genApp.Id;
            fc2.Higher_Authority_Order__c=67;
            fc2.Recommended_Limit__c=3000000;
            fac.add(fc2);
            
            insert fac;
            /*
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
            */
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Exceeding-Final sanction';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genapp.Qualitative_input_done__c=true;
            genApp.Sanction_Authority__c='BR_MGR';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
     @isTest
public static void method311(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Priority_Sector__c=False;
            insert acc;
            
           
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            genapp.Qualitative_input_done__c=false;
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            list<Facility__c> fac=new list<Facility__c>();
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            fcparentObj.Recommended_Limit__c=800000;
            fac.add(fcparentObj);
            
            Facility__c fc1 = new Facility__c();
            fc1.RecordTypeId = devRecordTypeId;
            fc1.role__C='BR';
            fc1.Application__c = genApp.Id;
            fc1.Higher_Authority_Order__c=67;
            fc1.Recommended_Limit__c=2000000;
            fac.add(fc1);
            
            Facility__c fc2 = new Facility__c();
            fc2.RecordTypeId = devRecordTypeId;
            fc2.role__C='BR';
            fc2.Application__c = genApp.Id;
            fc2.Higher_Authority_Order__c=67;
            fc2.Recommended_Limit__c=3000000;
            fac.add(fc2);
            
            insert fac;
            /*
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
            */
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Exceeding-Final sanction';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genapp.Qualitative_input_done__c=true;
            genApp.Sanction_Authority__c='BR_MGR';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
    @isTest
public static void method4(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Priority_Sector__c=true;
            acc.Overall_Exposure__c=100000;
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            fcparentObj.Recommended_Limit__c=500000;
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
            
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='New Loan- Final Sanction Accepted';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
    @isTest
	public static void method5(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Priority_Sector__c=true;
            acc.Overall_Exposure__c=100000;
            insert acc;
            
           
            Account acc1 = SME_TestUtil.createAccount('HP1 Agencies','CHENNAI','1210009','Mahesh1','Father in law','KVB');
            insert acc1;
            acc1.Priority_Sector__c=True;
            acc1.Overall_Exposure__c=10000;
            update acc1;
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            fcparentObj.Recommended_Limit__c=500000;
            fcparentObj.Recommended_Processing_Charge__c=0.45;
            insert fcParentObj;
            
           /* genesis__Application_Collateral__c coll=new genesis__Application_Collateral__c();
            coll.genesis__Application__c=genApp.Id;
            coll.Facility__c=fcparentObj.id;
            insert coll;*/
            
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
            
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Adhoc- Final Sanction Accepted';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genApp.Renewal_Due_Date__c=Date.parse('09/11/2020');
            genApp.Sanction_Authority__c='BR_MGR';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
   /*  @isTest
	public static void method15(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Priority_Sector__c=False;
            acc.Overall_Exposure__c=1000000;
            insert acc;
            
           
            Account acc1 = SME_TestUtil.createAccount('HP1 Agencies','CHENNAI','1210009','Mahesh1','Father in law','KVB');
            insert acc1;
            acc1.Priority_Sector__c=True;
            acc1.Overall_Exposure__c=10000;
            update acc1;
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            Facility__c fac1 = new Facility__c();
            fac1.RecordTypeId = devRecordTypeId;
            fac1.role__C='BR';
            fac1.Application__c = genApp.Id;
            fac1.Higher_Authority_Order__c=67;
            fac1.Recommended_Limit__c=700000;
            fac1.Recommended_Processing_Charge__c=0.45;
            insert fac1;
            
             Facility__c fac1 = new Facility__c();
            fac1.RecordTypeId = devRecordTypeId;
            fac1.role__C='BR';
            fac1.Application__c = genApp.Id;
            fac1.Higher_Authority_Order__c=67;
            fac1.Recommended_Limit__c=700000;
            fac1.Recommended_Processing_Charge__c=0.45;
            insert fac1;
            
           /* genesis__Application_Collateral__c coll=new genesis__Application_Collateral__c();
            coll.genesis__Application__c=genApp.Id;
            coll.Facility__c=fcparentObj.id;
            insert coll;*/
            
                  
            /*            
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Adhoc- Final Sanction Accepted';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genApp.Renewal_Due_Date__c=Date.parse('09/11/2020');
            genApp.Sanction_Authority__c='BR_MGR';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }*/
    @isTest
	public static void method05(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Priority_Sector__c=False;
            acc.Overall_Exposure__c=10000;
            insert acc;
            
           
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
           
            list<Facility__c> faclist= new list<Facility__c>();
            
             Facility__c fac1 = new Facility__c();
            fac1.RecordTypeId = devRecordTypeId;
            fac1.role__C='BR';
            fac1.Application__c = genApp.Id;
            fac1.Higher_Authority_Order__c=67;
            fac1.Recommended_Limit__c=500000;
            fac1.Recommended_Processing_Charge__c=0.45;
            faclist.add(fac1);
            
              Facility__c fac2 = new Facility__c();
            fac2.RecordTypeId = devRecordTypeId;
            fac2.role__C='BR';
            fac2.Application__c = genApp.Id;
            fac2.Higher_Authority_Order__c=67;
            fac2.Recommended_Limit__c=700000;
            fac2.Recommended_Processing_Charge__c=0.45;
            faclist.add(fac2);
            
              Facility__c fac3 = new Facility__c();
            fac3.RecordTypeId = devRecordTypeId;
            fac3.role__C='BR';
            fac3.Application__c = genApp.Id;
            fac3.Higher_Authority_Order__c=67;
            fac3.Recommended_Limit__c=5000000;
            fac3.Recommended_Processing_Charge__c=0.45;
            faclist.add(fac3);
            insert faclist;
            
           /* genesis__Application_Collateral__c coll=new genesis__Application_Collateral__c();
            coll.genesis__Application__c=genApp.Id;
            coll.Facility__c=fcparentObj.id;
            insert coll;*/
                      
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Adhoc- Final Sanction Accepted';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genApp.Renewal_Due_Date__c=Date.parse('09/11/2020');
            genApp.Sanction_Authority__c='BR_MGR';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
     @isTest
public static void method51(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Priority_Sector__c=False;
            acc.Overall_Exposure__c=25000;
            insert acc;
            
                      
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            genapp.Qualitative_input_done__c=false;
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            list<Facility__c> fac=new list<Facility__c>();
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            fcparentObj.Recommended_Limit__c=800000;
            fac.add(fcparentObj);
            
            Facility__c fc1 = new Facility__c();
            fc1.RecordTypeId = devRecordTypeId;
            fc1.role__C='BR';
            fc1.Application__c = genApp.Id;
            fc1.Higher_Authority_Order__c=67;
            fc1.Recommended_Limit__c=2000000;
            fac.add(fc1);
            
            Facility__c fc2 = new Facility__c();
            fc2.RecordTypeId = devRecordTypeId;
            fc2.role__C='BR';
            fc2.Application__c = genApp.Id;
            fc2.Higher_Authority_Order__c=67;
            fc2.Recommended_Limit__c=3000000;
            fac.add(fc2);
            
            insert fac;
            /*
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
            */
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Exceeding-Final sanction';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genapp.Qualitative_input_done__c=true;
            genApp.Sanction_Authority__c='DO_MGR';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
    public static void method52(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Priority_Sector__c=True;
            acc.Overall_Exposure__c=500000;
            insert acc;
            
           
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            genapp.Qualitative_input_done__c=false;
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            list<Facility__c> fac=new list<Facility__c>();
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            fcparentObj.Recommended_Limit__c=800000;
            fac.add(fcparentObj);
            
            Facility__c fc1 = new Facility__c();
            fc1.RecordTypeId = devRecordTypeId;
            fc1.role__C='BR';
            fc1.Application__c = genApp.Id;
            fc1.Higher_Authority_Order__c=67;
            fc1.Recommended_Limit__c=2000000;
            fac.add(fc1);
            
            Facility__c fc2 = new Facility__c();
            fc2.RecordTypeId = devRecordTypeId;
            fc2.role__C='BR';
            fc2.Application__c = genApp.Id;
            fc2.Higher_Authority_Order__c=67;
            fc2.Recommended_Limit__c=3000000;
            fac.add(fc2);
            
            insert fac;
            /*
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
            */
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Exceeding-Final sanction';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genapp.Qualitative_input_done__c=true;
            genApp.Sanction_Authority__c='DO_MGR';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
     public static void method53(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Priority_Sector__c=True;
            acc.Overall_Exposure__c=500000;
            insert acc;
            
           
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            genapp.Qualitative_input_done__c=false;
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            list<Facility__c> fac=new list<Facility__c>();
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            fcparentObj.Recommended_Limit__c=800000;
            fac.add(fcparentObj);
            
            Facility__c fc1 = new Facility__c();
            fc1.RecordTypeId = devRecordTypeId;
            fc1.role__C='BR';
            fc1.Application__c = genApp.Id;
            fc1.Higher_Authority_Order__c=67;
            fc1.Recommended_Limit__c=2000000;
            fac.add(fc1);
            
            Facility__c fc2 = new Facility__c();
            fc2.RecordTypeId = devRecordTypeId;
            fc2.role__C='BR';
            fc2.Application__c = genApp.Id;
            fc2.Higher_Authority_Order__c=67;
            fc2.Recommended_Limit__c=3000000;
            fac.add(fc2);
            
            insert fac;
            /*
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
            */
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Re-upload financials';
            genApp.Application_Stage__c='Exceeding-Final sanction';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genapp.Qualitative_input_done__c=true;
            genApp.Sanction_Authority__c='DO_MGR';
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }
    @isTest
	public static void method6(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            WS_Vendor_TestUtil.kvbCompanyDetails();
            WS_Vendor_TestUtil.productDetails();

			  List<clcommon__CL_Product__c> prodList = new List<clcommon__CL_Product__c>();
        		prodList.add(new clcommon__CL_Product__c(Product_Code__c = '777',clcommon__Product_Name__c = 'Digital Home Loan - 777'));
        		insert prodList;			
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Exceeding-Final sanction';
            genApp.Application_Stage__c ='Application filling initiated';
            genApp.Application_UI_Stage__c='EnhancementView';
            insert genApp;
            
            Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            Id devRecordTypeId1 = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            Facility__c fcParentObj = new Facility__c();
            fcParentObj.RecordTypeId = devRecordTypeId;
            fcParentObj.role__C='BR';
            fcParentObj.Application__c = genApp.Id;
            fcParentObj.Higher_Authority_Order__c=67;
            fcparentObj.Recommended_Limit__c=500000;
            fcparentObj.Recommended_Processing_Charge__c=0.45;
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
            
                        
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c='Final Sanction';
            genApp.Application_UI_Stage__c='CompanyDetailsView';
            genApp.Renewal_Due_Date__c=Date.parse('09/11/2020');
           genApp.genesis__CL_Product__c=prodList[0].id;
            update genApp;
            genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
            genAppDocCat.Name='Audited-balance sheet document last FY';
            genAppDocCat.Applicant__c=acc.id;
            genAppDocCat.genesis__Application__c = genApp.Id;
            insert genAppDocCat;
            
            genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
           // genAppDocAttjun.genesis__AttachmentId__c='test1233';
            genAppDocAttjun.genesis__Application_Document_Category__c= genAppDocCat.Id;
            insert genAppDocAttjun;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        
        
        Test.startTest();
        ApplicationTriggerHelper.CBS_ApiCall(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialData(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.deleteFinancialDataHelper(new List<genesis__Applications__c>{genApp});
        ApplicationTriggerHelper.clearPerfiosTxId(genAppOldMap,genAppOldMap);
        ApplicationTriggerHelper.runBREAfteANDCheckCollateral(genApp.Id);
        ApplicationTriggerHelper.runBREAfterM21Future(genApp.Id);
        ApplicationTriggerHelper.getCollateralFlag(genApp.Id);
        Test.stopTest();
    }

    }

}