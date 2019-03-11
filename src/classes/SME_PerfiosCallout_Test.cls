/*
* Description : To cover the Test for SME_PerfiosCallout and SME_perfiosReportBatch
* Author      : Vignesh
*/
@isTest
private class SME_PerfiosCallout_Test {
	public static genesis__Applications__c genApp  = new genesis__Applications__c();
	public static genesis__Document_Category__c docCat= new genesis__Document_Category__c();
	

	public static void init(){
		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Industry_Type__c='Manufacturing';
        acc.Crilc_Info__c=null;
        acc.CRILC_TxnId__c='Test Crilc';
        insert acc;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        
        genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Application_Stage__c='Adhoc Application close';
        genApp.Overall_Exposure__c=2600000;
        insert genApp;
        //createDocuments

        docCat= SME_TestUtil.DocCateCeation('Audited Balance Sheet','Audited Balance Sheet');
        insert docCat;
        

        

	}
	
	@isTest static void test_method_one() {
		init();
		genesis__Application_Document_Category__c appDocCat= new genesis__Application_Document_Category__c();
        appDocCat.Name= docCat.genesis__Category_Name__c+' 2017-18';
        appDocCat.genesis__Application__c= genApp.Id;
        appDocCat.genesis__Document_Category__c= docCat.Id;
        appDocCat.Transaction_Id__c='3e85a191-4f7b-c85d-f53a-f28d9b5e4ed5';
        appDocCat.Success_Error_Msg__c= 'Financial Data Processing Completed';
        insert appDocCat;

        genesis__AppDocCatAttachmentJunction__c appDocJn= new genesis__AppDocCatAttachmentJunction__c();
        appDocJn.genesis__Application_Document_Category__c= appDocCat.Id;
        appDocJn.Document_Submitted__c= true;
        insert appDocJn;

        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb1; 
        KVB_Endpoint_URLs__c kvb = new KVB_Endpoint_URLs__c(name='Perfios_Financial_Porcess',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/analysis/financials/process');
        insert kvb;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_PerfiosCallout.ProcessPerfios(genApp.Id);
        Test.stopTest();


	}
	
	@isTest static void test_method_two() {
		init();
		genesis__Application_Document_Category__c appDocCat1= new genesis__Application_Document_Category__c();
        appDocCat1.Name= docCat.genesis__Category_Name__c+' 2017-18';
        appDocCat1.genesis__Application__c= genApp.Id;
        appDocCat1.genesis__Document_Category__c= docCat.Id;
        appDocCat1.Transaction_Id__c='3e85a191-4f7b-c85d-f53a-f28d9b5e4ed6';
        appDocCat1.Success_Error_Msg__c= 'Financial Data Processing Completed';
        insert appDocCat1;

        genesis__AppDocCatAttachmentJunction__c appDocJn1= new genesis__AppDocCatAttachmentJunction__c();
        appDocJn1.genesis__Application_Document_Category__c= appDocCat1.Id;
        appDocJn1.Document_Submitted__c= true;
        insert appDocJn1;

		KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb1;
        KVB_Endpoint_URLs__c kvb = new KVB_Endpoint_URLs__c(name='Perfios_Financial_Report',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/analysis/financials/report?reportFormat=json&txnId=');
        insert kvb;

        Task t= new Task();
        t.whatId= genApp.Id;
        //t.Task_Subject__c= 'Financial Doc Upload';
        insert t;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_perfiosReportBatch obj= new SME_perfiosReportBatch();
        DataBase.executeBatch(obj);
        Test.stopTest();
 

	}
	@isTest static void test_method_three() {
		init();
		genesis__Application_Document_Category__c appDocCat= new genesis__Application_Document_Category__c();
        appDocCat.Name= docCat.genesis__Category_Name__c+' 2017-18';
        appDocCat.genesis__Application__c= genApp.Id;
        appDocCat.genesis__Document_Category__c= docCat.Id;
        appDocCat.Transaction_Id__c='3e85a191-4f7b-c85d-f53a-f28d9b5e4ed5';
        appDocCat.Success_Error_Msg__c= 'Financial Data Processing Completed';
        insert appDocCat;

        genesis__AppDocCatAttachmentJunction__c appDocJn= new genesis__AppDocCatAttachmentJunction__c();
        appDocJn.genesis__Application_Document_Category__c= appDocCat.Id;
        appDocJn.Document_Submitted__c= true;
        insert appDocJn;

        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb1;
        KVB_Endpoint_URLs__c kvb = new KVB_Endpoint_URLs__c(name='Perfios_Financial_Report',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/analysis/financials/report?reportFormat=json&txnId=');
        insert kvb;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_perfiosReportBatch obj= new SME_perfiosReportBatch();
        DataBase.executeBatch(obj);
        Test.stopTest();
	}
	
}