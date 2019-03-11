/*
* Description : to cover test code for LandingPageHelper class
* Author       : Vignesh
*
*/

@isTest
private class LandingPageHelper_Test {
	
	@isTest static void test_method_one() {
		
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId 		= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.Aadhaar_Number__c	=  '1234567689900';
        acc.Pan_Number__c		=	'BXCV12PIL';
        acc.BillingStreet		=  '30 A T.Nagar';
        acc.BillingCity			=  'Chennai';
        acc.BillingState		=  'Tamil Nadu';
        acc.BillingPostalCode	=  '560029';
        acc.Constitution__c		=  'Private Limited';
        acc.Line_of_Activity__c	=  'Retail Trade';
        acc.RecordTypeId		=	devRecordTypeId;
        acc.CBS_Customer_ID__c= '4899990715';
        insert acc;
		//genesis__Applications__c app= TestUtility.intialSetUp('VL2W',true);
		genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();       
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        insert app;
        
        Id fesiRecordTypeIdPer 		= Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Facility__c fesi= new Facility__c();
        fesi.Application__c= app.id;
        fesi.RecordTypeId= fesiRecordTypeIdPer;
        insert fesi;

        

        Test.startTest();
   			LandingPageHelper.landingPageRes(acc.CBS_Customer_ID__c,false);
   			LandingPageHelper.getAppDetail(acc.CBS_Customer_ID__c);
   			LandingPageHelper.preEnhancementChecksTrigger(app.Id);
   			LandingPageHelper.excuteListMatchingBatch(new List<genesis__Applications__c>{app},true,true);     
        Test.stopTest();

	}
	
	@isTest static void test_method_two() {
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId 		= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.Aadhaar_Number__c	=  '1234567689900';
        acc.Pan_Number__c		=	'BXCV12PIL';
        acc.BillingStreet		=  '30 A T.Nagar';
        acc.BillingCity			=  'Chennai';
        acc.BillingState		=  'Tamil Nadu';
        acc.BillingPostalCode	=  '560029';
        acc.Constitution__c		=  'Private Limited';
        acc.Line_of_Activity__c	=  'Retail Trade';
        acc.RecordTypeId		=	devRecordTypeId;
        acc.CBS_Customer_ID__c= '4899990716';
        insert acc;

        genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();       
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        insert app;

        Test.startTest();
   			LandingPageHelper.landingPageRes(acc.CBS_Customer_ID__c,false);
   			     
        Test.stopTest();
	}

	@isTest static void test_method_three() {
		
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId 		= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.Aadhaar_Number__c	=  '1234567689900';
        acc.Pan_Number__c		=	'BXCV12PIL';
        acc.BillingStreet		=  '30 A T.Nagar';
        acc.BillingCity			=  'Chennai';
        acc.BillingState		=  'Tamil Nadu';
        acc.BillingPostalCode	=  '560029';
        acc.Constitution__c		=  'Private Limited';
        acc.Line_of_Activity__c	=  'Retail Trade';
        acc.RecordTypeId		=	devRecordTypeId;
        acc.CBS_Customer_ID__c= '4899990715';
        insert acc;
		//genesis__Applications__c app= TestUtility.intialSetUp('VL2W',true);
		genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Term Loan').getRecordTypeId();       
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        insert app;
        
        Id fesiRecordTypeIdPer 		= Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Facility__c fesi= new Facility__c();
        fesi.Application__c= app.id;
        fesi.RecordTypeId= fesiRecordTypeIdPer;
        insert fesi;

        

        Test.startTest();
   			LandingPageHelper.landingPageRes(acc.CBS_Customer_ID__c,false);
   			LandingPageHelper.getAppDetail(acc.CBS_Customer_ID__c);
   			LandingPageHelper.preEnhancementChecksTrigger(app.Id);
   			LandingPageHelper.excuteListMatchingBatch(new List<genesis__Applications__c>{app},true,true);     
        Test.stopTest();

	}
	@isTest static void test_method_four() {
		
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId 		= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.Aadhaar_Number__c	=  '1234567689900';
        acc.Pan_Number__c		=	'BXCV12PIL';
        acc.BillingStreet		=  '30 A T.Nagar';
        acc.BillingCity			=  'Chennai';
        acc.BillingState		=  'Tamil Nadu';
        acc.BillingPostalCode	=  '560029';
        acc.Constitution__c		=  'Private Limited';
        acc.Line_of_Activity__c	=  'Retail Trade';
        acc.RecordTypeId		=	devRecordTypeId;
        acc.CBS_Customer_ID__c= '4899990715';
        insert acc;
		//genesis__Applications__c app= TestUtility.intialSetUp('VL2W',true);
		genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();       
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        insert app;
        Test.startTest();
   			LandingPageHelper.landingPageRes(acc.CBS_Customer_ID__c,false);     
        Test.stopTest();

	}
	
}