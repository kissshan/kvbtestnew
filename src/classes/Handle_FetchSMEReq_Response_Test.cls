/*
* Description : to cover test code for Handle_FetchSMEReq_Response class
* Author       : Vignesh
*
*/

@isTest
private class Handle_FetchSMEReq_Response_Test {
	
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
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();       
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        insert app;

        Id fesiRecordTypeIdPer 		= Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Facility__c fesi= new Facility__c();
        fesi.Application__c= app.id;
        fesi.RecordTypeId= fesiRecordTypeIdPer;
        insert fesi;

        Debtors__c deb= new Debtors__c();
        deb.Account__c= acc.Id;
        deb.Fiscal_Year__c= '2017-18';
        insert deb;

        Debtors__c deb1= new Debtors__c();
        deb1.Account__c= acc.Id;
        deb1.Fiscal_Year__c= '2018-19';
        insert deb1;

        Sundry_Creditors__c sunCred= new Sundry_Creditors__c();
        sunCred.Account__c= acc.Id;
        sunCred.Fiscal_Year__c= '2017-18';
        insert sunCred;

        Sundry_Creditors__c sunCred1= new Sundry_Creditors__c();
        sunCred1.Account__c= acc.Id;
        sunCred1.Fiscal_Year__c= '2018-19';
        insert sunCred1;





		Test.startTest();
			Handle_FetchSMEReq_Response.getApplicationInfo(acc.CBS_Customer_ID__c,app.Id);

		Test.stopTest();
	}
	
}