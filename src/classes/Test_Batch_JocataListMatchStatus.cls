/*
* Description : Test_Batch_JocataListMatchStatus
* Author      : Kishan Panchal
*/
@isTest
public class Test_Batch_JocataListMatchStatus {
    
    @istest static void jocLstMatchStsMethod(){
        
        genesis__Applications__c genAppObj = new genesis__Applications__c();
        
        genAppObj = Test_utilityMethod.intialSetUp('KVB STEEL PLUS - OCC',true);
        system.debug('genAppObj:::'+genAppObj);
        
        Database.QueryLocator     QL;
        Database.BatchableContext BC;
        
        KVB_Endpoint_URLs__c kvb  = new KVB_Endpoint_URLs__c(name='ListMatchingSatusAPI',Endpoint_URL__c='http://www.kvbbank.net/next/v1/kyc/status/listmatching?txnId=');
        insert kvb;
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb1;    
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Batch_JocataListMatchStatus batchObj = new Batch_JocataListMatchStatus(null);
        batchObj.execute(BC,new List<genesis__Applications__c>{genAppObj});
        Database.executeBatch(batchObj);
        Test.stopTest();
    }
    
}