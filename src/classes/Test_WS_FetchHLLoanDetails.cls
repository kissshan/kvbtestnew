/*
* Name    	: Test_WS_FetchHLLoanDetails
* Company  	: ET Marlabs
* Purpose   : WS_FetchHLLoanDetails test class
* Author  	: Braj 
*/
@isTest
public class Test_WS_FetchHLLoanDetails {
    @testSetup 
    static void setup(){
        //initial test setup
        genesis__Applications__c appln=TestUtility.intialSetUp('Home Loan',true);
        appln.Sub_Type__c = Constants.Sub_Type_Top_Up;
        update appln;
        
        Facility__c ft = new Facility__c();
        Id FacID=Schema.getGlobalDescribe().get('Facility__c').getDescribe().getRecordTypeInfosByName().get('HL Facility').getRecordTypeId();
        ft.RecordTypeId=FacID;
        ft.Application__c=appln.id;
        ft.Existing_HL_Loan_Account_No__c = '2301753000000083';
        Insert ft;
        
        Insert new KVB_Endpoint_URLs__c(name='CBS_Fetch_HLLoanDetails',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/FCR_HL_LOAN_ACCT_DTLS');
        
    }
    
    @isTest 
    static void test_fetchLoanDetails_method1() {
        List<Facility__c> facilityList = new List<Facility__c>();
        facilityList = [SELECT Id,Active__c,Application__c,Existing_HL_Loan_Account_No__c FROM Facility__c where Active__c = true Limit 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_FetchHLLoanDetails.fetchLoanDetails(facilityList[0].Existing_HL_Loan_Account_No__c,facilityList[0].Id,facilityList[0].Application__c);
        Test.stopTest();
    }

    @isTest 
    static void test_fetchLoanDetails_method2() {
        List<Facility__c> facilityList = new List<Facility__c>();
        facilityList = [SELECT Id,Active__c,Application__c,Existing_HL_Loan_Account_No__c FROM Facility__c where Active__c = true Limit 1];

        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Fetch_HLLoanDetails');
        System.debug('@@@@@@@'+kvb);
        kvb.Endpoint_URL__c = 'test';
        update kvb;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_FetchHLLoanDetails.fetchLoanDetails(facilityList[0].Existing_HL_Loan_Account_No__c,facilityList[0].Id,facilityList[0].Application__c);
        Test.stopTest();
    }

    @isTest 
    static void test_fetchLoanDetails_method3() {
        List<Facility__c> facilityList = new List<Facility__c>();
        facilityList = [SELECT Id,Active__c,Application__c,Existing_HL_Loan_Account_No__c FROM Facility__c where Active__c = true Limit 1];

        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Fetch_HLLoanDetails');
        System.debug('@@@@@@@'+kvb);
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_HL_LOAN_ACCT_DTLS1';
        update kvb;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_FetchHLLoanDetails.fetchLoanDetails(facilityList[0].Existing_HL_Loan_Account_No__c,facilityList[0].Id,facilityList[0].Application__c);
        WS_FetchHLLoanDetails.HLLoanDetails loanDetails = new WS_FetchHLLoanDetails.HLLoanDetails();
        WS_FetchHLLoanDetails.cls_Collateral collWrap = new WS_FetchHLLoanDetails.cls_Collateral();
        WS_FetchHLLoanDetails.cls_Application applnWrap = new WS_FetchHLLoanDetails.cls_Application();
        WS_FetchHLLoanDetails.cls_Facility facilityWrap = new WS_FetchHLLoanDetails.cls_Facility();
        Test.stopTest();
    }
}