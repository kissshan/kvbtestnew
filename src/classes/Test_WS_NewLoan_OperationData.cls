/*
* Description : Test_Batch_JocataListMatchStatus
* Author      : Kishan Panchal
*/
@isTest
public class Test_WS_NewLoan_OperationData {
    @isTest static void newLoanOperationalMethod(){
       
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='NewLoan_OperationalData',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/FCR_OPR_DATA_CUST');
        insert kvb;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
         WS_NewLoan_OperationalData.getRequest('12345');
        Test.stopTest();
    }
    @isTest static void newLoanOperationalMethod1(){
       
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='NewLoan_OperationalData',Endpoint_URL__c='');
        insert kvb;
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
         WS_NewLoan_OperationalData.getRequest('12345');
        Test.stopTest();
    }
}