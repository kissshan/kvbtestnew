//written by prashant singh
//code coverage:-88%

@istest
public class Test_WS_getAadharNo {
    @testsetup
    public static void setupMethod()
    {
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='Get_AadharNo',Endpoint_URL__c='https://www.kvbbank.net.in/next/v1/mw/uid/reference/');
        insert kvb;
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb1;
    }
    @istest
    public static void method1()
    {
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_getAadharNo.getAadharNo('758929010');
        test.stoptest();
    }

}