/*
* Description : to cover test code for CommercialPR_EAE_Request_Handler class
* Author       : Vignesh
*
*/



@isTest
private class CommercialPR_EAE_Request_Handler_Test {
	
	@isTest static void test_method_one() {
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId      = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.Aadhaar_Number__c   =  '1234567689900';
        acc.Pan_Number__c       =   'BXCV12PIL';
        acc.BillingStreet       =  '30 A T.Nagar';
        acc.BillingCity         =  'Chennai';
        acc.BillingState        =  'Tamil Nadu';
        acc.BillingPostalCode   =  '560029';
        acc.Constitution__c     =  'Private Limited';
        acc.Line_of_Activity__c =  'Retail Trade';
        acc.RecordTypeId        =   devRecordTypeId;
        acc.CBS_Customer_ID__c  = '1234hfag8f321hntqf';
        acc.Relationship_with_Firm__c = '';
        insert acc;

        genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();       
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        insert app;

        Test.startTest();
        CommercialPR_EAE_Request commeReq= new CommercialPR_EAE_Request();
            commeReq = CommercialPR_EAE_Request_Handler.getRequest(acc.CBS_Customer_ID__c,'SME_NEW_LOAN',app.Id);

            List<CommercialPR_EAE_Request.ApplicantsData> appdataLst= new List<CommercialPR_EAE_Request.ApplicantsData>();
            
			CommercialPR_EAE_Request.ApplicantsData appData= new CommercialPR_EAE_Request.ApplicantsData();
            CommercialPR_EAE_Request.RegisteredAddress regiAddr= new CommercialPR_EAE_Request.RegisteredAddress ();
            regiAddr.AddressType= 'Current';

            appData.RegisteredAddress= regiAddr;
            appdataLst.add(appData);
        	appData= CommercialPR_EAE_Request_Handler.getBusinnessApplicantData(acc,appData,'LAP',acc);

        	genesis__Application_Parties__c party =new genesis__Application_Parties__c();
            party.Key_Contact__c = acc.id;
            party.genesis__Party_Account_Name__c=acc.id;
            party.genesis__Party_Type__c = Constants.Co_Borrower;
            party.Active__c = true;
            insert party;

        	appData= CommercialPR_EAE_Request_Handler.getPersonApplicantData( party,appData);

        Test.stopTest();


	}
	
	@isTest static void test_method_two() {
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId      = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.Aadhaar_Number__c   =  '1234567689900';
        acc.Pan_Number__c       =   'BXCV12PIL';
        acc.BillingStreet       =  '30 A T.Nagar';
        acc.BillingCity         =  'Chennai';
        acc.BillingState        =  'Tamil Nadu';
        acc.BillingPostalCode   =  '560029';
        acc.Constitution__c     =  'Private Limited';
        acc.Line_of_Activity__c =  'Retail Trade';
        acc.RecordTypeId        =   devRecordTypeId;
        acc.CBS_Customer_ID__c  = '1234hfag8f321hntqf';
        acc.Relationship_with_Firm__c = '';
        insert acc;

        genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();       
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        insert app;

        Test.startTest();
        CommercialPR_EAE_Request commeReq= new CommercialPR_EAE_Request();
        //commeReq.customerType='Old Application';
        //commeReq.NEW_APPLICATION_TYPE= 'LAP1';
        commeReq = CommercialPR_EAE_Request_Handler.getRequest(acc.CBS_Customer_ID__c,'LAP1',app.Id);
        Test.stopTest();

	}
	
}