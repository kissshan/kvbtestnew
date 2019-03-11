/*
* Description : ApplicationTriggerHandler_Test
* Author       : Yadagiri
------------------------------------------------------------
added by prashant singh.....
*/
@isTest
public class ApplicationTriggerHandler_Test {
    @isTest
    public static void method1(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            triggersetting.Execute_Account_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            update acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Exceeding-Final sanction';
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c='Enhancement- Final sanction offered';
            update genApp;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
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
            
            clcommon__CL_Product__c clprod = SME_TestUtil.createclproduct('Test Product','777',null);
            insert clprod;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Exceeding-Final sanction';
            genApp.genesis__CL_Product__c = clprod.Id;
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c='Enhancement- Final sanction offered';
            update genApp;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        }
    }
    //added by prashant singh
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
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            clcommon__CL_Product__c clprod = SME_TestUtil.createclproduct('Test Product','777',null);
            insert clprod;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c ='Exceeding-Final sanction';
            genApp.Legal_desk_state_flag__c=false;
            genApp.genesis__CL_Product__c = clprod.Id;
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c='Enhancement- Final sanction offered';
            update genApp;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
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
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL4W').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Exceeding-Final sanction';        
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c='Enhancement- Final sanction offered';
            update genApp;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        }
    }
    //prashant singh..................
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
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            clcommon__CL_Product__c clprod = SME_TestUtil.createclproduct('Test Product','777',null);
            insert clprod;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Exceeding-Final sanction';
            genApp.genesis__CL_Product__c = clprod.Id;
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c='Enhancement- Final sanction offered';
            update genApp;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
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
            triggersetting.Execute_Account_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            update acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='New Loan- Final Sanction Accepted';
            genApp.Branch_Code__c = '1861';
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c='Exceeding- Final sanction offered';
            update genApp;
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        }
    }
   @isTest
    public static void method7(){
        
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
            
            clcommon__CL_Product__c clprod = SME_TestUtil.createclproduct('Test Product','777',null);
            insert clprod;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Exceeding-Final sanction';
            genApp.genesis__CL_Product__c = clprod.Id;
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c='Enhancement- Final sanction offered';
            update genApp;
            Perfios__c perobj=new Perfios__c();
            perobj.Applicant_Name__c=acc.id;
            perobj.Application_id__c=genApp.id;
            perobj.SelfEmpNMI__c=100000;
            insert perobj;
            genesis__Application_Parties__c party=new genesis__Application_Parties__c();
            party.Active__c=true;
            party.Additional_Income_Amount3__c=20000;
            party.Employment_Types__c='Salaried';
            party.Salary_Continous_Flag__c=true;
            party.genesis__Application__c=genApp.id;
            party.Key_Contact__c=acc.id;
            insert party;
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
        }
    }
    
    
}