//uday---->98%
@isTest
public class Test_SanctionMessageGenerator {
    @isTest
    public static void method1(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=true;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=false;
        genApp.Additional_Income_Approval__c=true;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=true;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
     @isTest
    public static void method2(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=true;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=false;
        genApp.Additional_Income_Approval__c=false;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=true;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method3(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=true;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=false;
        genApp.Additional_Income_Approval__c=true;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=false;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method4(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=true;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=false;
        genApp.Additional_Income_Approval__c=false;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=false;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method5(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=false;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=false;
        genApp.Additional_Income_Approval__c=true;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=true;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method6(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=false;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=false;
        genApp.Additional_Income_Approval__c=false;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=true;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method7(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=false;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=false;
        genApp.Additional_Income_Approval__c=true;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=false;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method8(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=false;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=false;
        genApp.Additional_Income_Approval__c=false;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=false;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method9(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=true;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Additional_Income_Approval__c=true;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=true;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method10(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=true;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        SanctionMessage__c cs2 = new SanctionMessage__c();
        cs2.name='SM10';
        cs2.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs2;
        SanctionMessage__c cs3 = new SanctionMessage__c();
        cs3.name='SM12';
        cs3.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs3;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Additional_Income_Approval__c=false;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=true;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method11(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=true;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        SanctionMessage__c cs2 = new SanctionMessage__c();
        cs2.name='SM10';
        cs2.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs2;
        SanctionMessage__c cs3 = new SanctionMessage__c();
        cs3.name='SM12';
        cs3.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs3;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Additional_Income_Approval__c=true;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=false;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method12(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=true;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        SanctionMessage__c cs2 = new SanctionMessage__c();
        cs2.name='SM10';
        cs2.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs2;
        SanctionMessage__c cs3 = new SanctionMessage__c();
        cs3.name='SM12';
        cs3.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs3;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Additional_Income_Approval__c=false;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=false;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method13(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=false;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        SanctionMessage__c cs2 = new SanctionMessage__c();
        cs2.name='SM10';
        cs2.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs2;
        SanctionMessage__c cs3 = new SanctionMessage__c();
        cs3.name='SM12';
        cs3.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs3;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Additional_Income_Approval__c=true;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=true;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method14(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=false;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        SanctionMessage__c cs2 = new SanctionMessage__c();
        cs2.name='SM10';
        cs2.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs2;
        SanctionMessage__c cs3 = new SanctionMessage__c();
        cs3.name='SM12';
        cs3.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs3;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Additional_Income_Approval__c=false;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=true;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method15(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=false;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        SanctionMessage__c cs2 = new SanctionMessage__c();
        cs2.name='SM10';
        cs2.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs2;
        SanctionMessage__c cs3 = new SanctionMessage__c();
        cs3.name='SM12';
        cs3.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs3;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Additional_Income_Approval__c=true;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=false;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
    @isTest
    public static void method16(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        
        acc.Jocata_List_Match__c='true';
        acc.Bureau_Score__c='780';
        acc.Net_Monthly_Income__c=770000;
        acc.Are_you_An_Existing_Customer__c=false;
        //  acc.PersonBirthdate=birthday.addDays(-1400);
        insert acc;
        
        SanctionMessage__c cs = new SanctionMessage__c();
        cs.name='SM1';
        cs.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs;
        SanctionMessage__c cs1 = new SanctionMessage__c();
        cs1.name='SM3';
        cs1.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs1;
        SanctionMessage__c cs2 = new SanctionMessage__c();
        cs2.name='SM10';
        cs2.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs2;
        SanctionMessage__c cs3 = new SanctionMessage__c();
        cs3.name='SM12';
        cs3.Message__c='Your Personal Loan will sanctioned subject to income verification';
        insert cs3;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        genApp.Active__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Additional_Income_Approval__c=false;
        insert genApp;
        
        genesis__Applications__c  genApp2=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','Work Information Captured','COMPANY_DETAILS');
        genApp2.id=genApp.id;
        genapp2.Sub_Stage__c='Personal Details Captured';
        genApp.Industry_type_Application__c='Manufacturing';
        genApp.Loan_Purpose__c='Construction on Own Land';
        genApp.Flat_No__c='T-45';
        genApp.genesis__Loan_Amount__c=45.6;
        genApp.RecordTypeId=genAppRecordType;
        genApp.genesis__Interest_Rate__c=9;
        genApp.genesis__Term__c=8;
        update genApp2;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Party_Account_Name__c =acc.Id;
        genAppPart.genesis__Party_Type__c='Primary Applicant';
        genAppPart.Active__c=True;
        genAppPart.Net_Monthly_Income__c=300000;
        genAppPart.Employment_Types__c='Salaried';
        genAppPart.Company__c=false;
        genAppPart.genesis__Application__c=genApp.id;
        genAppPart.Perfios_Captured__c=true;
        genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        genAppPart.Same_Present_Address_Permanent_Address__c=false;
        insert genAppPart;
        
      //  genesis__Applications__c appcreate=[select id from genesis__Applications__c where id =:genApp.id];
        
       
      /*  appcreate.genesis__Interest_Rate__c=9;
        appcreate.genesis__Term__c=8;
        update appcreate;*/
        list<genesis__Applications__c> oldlist=new list<genesis__Applications__c>();
        oldlist.add(genApp);
        map<id,genesis__Applications__c> oldmap=new map<id,genesis__Applications__c>();
        oldmap.put(genApp.id,genApp);
        list<genesis__Applications__c> newlist=new list<genesis__Applications__c>();
        newlist.add(genApp2);
        map<id,genesis__Applications__c> newmap=new map<id,genesis__Applications__c>();
        newmap.put(genApp2.id,genApp2);
        test.startTest();
        SanctionMessageGenerator.sanctionMessageMethod(newlist, oldmap, oldlist, newmap);
        test.stopTest();
    }
}