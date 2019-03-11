@isTest
public class Test_Batch_JocataListMatching {
        
    @istest 
        public static void jocLstMatchStsMethod(){
        
        genesis__Applications__c genAppObj = new genesis__Applications__c();
        
        genAppObj = Test_utilityMethod.intialSetUp('KVB STEEL PLUS - OCC',true);
        system.debug('genAppObj:::'+genAppObj);
        
        
        Database.QueryLocator     QL;
        Database.BatchableContext BC;
        
        KVB_Endpoint_URLs__c kvb  = new KVB_Endpoint_URLs__c(name='Listmatching',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/kyc/listmatching');
        insert kvb;
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb1;    
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Batch_JocataListMatching batchObj = new Batch_JocataListMatching(null);
       	batchObj.execute(BC,new List<genesis__Applications__c>{genAppObj});
        Database.executeBatch(batchObj);
        Test.stopTest();
    }

}