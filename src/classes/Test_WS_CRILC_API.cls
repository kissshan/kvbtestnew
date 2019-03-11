@isTest
public class Test_WS_CRILC_API {
    @isTest
    public static void testGetResponse()
    {
        List<KVB_Endpoint_URLs__c> kvbEndpointLst = new List<KVB_Endpoint_URLs__c>();
        AccountTriggerHandler.isAccountTrigger=false;
        Account app = new Account(CBS_Customer_ID__c = '1234', Pan_Number__c = '09876',name='kvb');
        insert app;
        
        
       KVB_Endpoint_URLs__c kvbEndpoint2 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
       kvbEndpointLst.add(kvbEndpoint2);
       insert kvbEndpoint2; 
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'Crilc Request Apigee';
        KVB1.Endpoint_URL__c = 'https://kvb-test.apigee.net/next/v1/kyc/crilc1';
        kvbEndpointLst.add(KVB1);
     	insert kvb1;
        Test.startTest();
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CRILC_API.getRequest(app.id,app.Pan_Number__c);
        Test.stopTest();
    }

}