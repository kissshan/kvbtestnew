/*
* Name    	: Test_WS_FetchBankName
* Company  	: ET Marlabs
* Purpose   : WS_FetchBankName test class
* Author  	: Braj 
*/
@isTest
public class Test_WS_FetchBankName {
	@testSetup 
    static void setup(){
        
        List<KVB_Endpoint_URLs__c> kvbEndpointLst = new List<KVB_Endpoint_URLs__c>();
        KVB_Endpoint_URLs__c kvbEndpoint1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        kvbEndpointLst.add(kvbEndpoint1);
        KVB_Endpoint_URLs__c kvbEndpoint2 = new KVB_Endpoint_URLs__c(name='BankName',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/analysis/institutions');
        kvbEndpointLst.add(kvbEndpoint2);
        Insert kvbEndpointLst;
        
    }

	@isTest 
    static void test_fetchBankNameList_method1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_FetchBankName.fetchBankNameList();
        Test.stopTest();
    }

    @isTest 
    static void test_fetchBankNameList_method2() {
    	KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('Apigee_Access_Token');
        System.debug('@@@@@@@'+kvb);
        kvb.Endpoint_URL__c = 'test';
        update kvb;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_FetchBankName.fetchBankNameList();
        Test.stopTest();
    }
}