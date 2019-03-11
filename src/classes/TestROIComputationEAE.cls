/*
* Name          : TestROIComputationEAE
* Author        : Vignesh
*/
@isTest
private class TestROIComputationEAE {
	
	@isTest static void test_method_one() {
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId 		= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.RecordTypeId		=	devRecordTypeId;
        acc.CBS_Customer_ID__c= '12345677';
        acc.Date_of_Incorporation__c=Date.parse('09/11/2018');
        insert acc;
        genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();  //  SME NEW Loan  
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        app.Type__c= 'NTB - New to credit';
        app.genesis__Customer_Cash_Used_For__c='Priority';
        app.New_to_Business__c=true;
        insert app;

        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('SOD REAL ESTATE','280','Funded');
        clProd.Facility_Category__c = 'SOD';
        INSERT clProd;
        Id fesiRecordTypeIdPer 		= Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Facility__c fesi= new Facility__c();
        fesi.Application__c= app.id;
        fesi.Active__c= true;
        fesi.RecordTypeId= fesiRecordTypeIdPer;
        fesi.Balance_Outstandings__c= 17423;
        fesi.Amount_Yet_disbursed__c=17423;
        fesi.CL_Product__c= clProd.id;
        insert fesi;
            

        Test.startTest();
        ROIComputationEAE.computeROI(app.Id,75.0);
        Test.stopTest();
	}
	@isTest static void test_method1() {
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId 		= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.RecordTypeId		=	devRecordTypeId;
        acc.CBS_Customer_ID__c= '12345677';
        acc.Date_of_Incorporation__c=Date.parse('09/11/2018');
        insert acc;
        genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();  //  SME NEW Loan  
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        app.Type__c= 'NTB - New to credit';
        app.genesis__Customer_Cash_Used_For__c='Priority';
        app.New_to_Business__c=true;
        insert app;

        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('SOD REAL ESTATE','280','Funded');
        clProd.Facility_Category__c = 'OCC';
        INSERT clProd;
        Id fesiRecordTypeIdPer 		= Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Facility__c fesi= new Facility__c();
        fesi.Application__c= app.id;
        fesi.Active__c= true;
        fesi.RecordTypeId= fesiRecordTypeIdPer;
        fesi.Balance_Outstandings__c= 17423;
        fesi.Amount_Yet_disbursed__c=17423;
        fesi.CL_Product__c= clProd.id;
        insert fesi;
            

        Test.startTest();
        ROIComputationEAE.computeROI(app.Id,75.0);
        Test.stopTest();
	}	
	@isTest static void test_method_two() {
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId 		= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.RecordTypeId		=	devRecordTypeId;
        acc.CBS_Customer_ID__c= '12345677';
        insert acc;
        genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();  //  SME NEW Loan  
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        app.New_to_Business__c= false;
        app.Overall_Score__c= '65.0';
        //app.Type__c= 'NTB - New to credit';
        app.genesis__Customer_Cash_Used_For__c='Priority';
        insert app;

        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('SOD REAL ESTATE','280','Funded');
        clProd.Facility_Category__c = 'SOD';
        INSERT clProd;
        Id fesiRecordTypeIdPer 		= Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Facility__c fesi= new Facility__c();
        fesi.Application__c= app.id;
        fesi.Active__c= true;
        fesi.RecordTypeId= fesiRecordTypeIdPer;
        fesi.Balance_Outstandings__c= 17423;
        fesi.Amount_Yet_disbursed__c=17423;
        fesi.CL_Product__c= clProd.id;
        insert fesi;
            

        Test.startTest();
        ROIComputationEAE.computeROI(app.Id,75.0);
        Test.stopTest();
	}
	
}