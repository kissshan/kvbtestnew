@isTest(SeeAllData=false)
public class Batch_JocataListMatching_Scheduler_Test {
    @isTest
    public static void testschedule(){
        Test.StartTest();
        Batch_JocataListMatching_Scheduler sh1 = new Batch_JocataListMatching_Scheduler();   		
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }
    
  /*  @isTest
    public static void testMethod2(){
        Account buisnessAcc =  new Account();
        buisnessAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        buisnessAcc.Name = 'Buisness Account';
        buisnessAcc.Jocata_TxnId__c = '18317';
        insert buisnessAcc;
        
        genesis__Applications__c geAppl =  new genesis__Applications__c();
        geAppl.genesis__Account__c  =  buisnessAcc.id;
        geAppl.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        geAppl.Branch_Code__c = '100'; 
        geAppl.Active__c = true;
        geAppl.genesis__Loan_Amount__c = 0.0;
        geAppl.Application_Stage__c = 'Identified for renewal';
        geAppl.List_Matching_Stage__c = 'Sent';
        geAppl.Application_Stage__c = Constants.APPLN_INITIATED;
        geAppl.List_Matching_Status__c = true;
        insert geAppl;
        
        list<KVB_Endpoint_URLs__c> kvbEndPtUrlsList = new  list<KVB_Endpoint_URLs__c>();
        KVB_Endpoint_URLs__c listmatching 		= 	new KVB_Endpoint_URLs__c();
        listmatching.Name 						= 	'ListMatchingSatusAPI';
        listmatching.Endpoint_URL__c 			= 	'https://kvb-dev.apigee.net/next/v1/kyc/status/listmatching?txnId=';
        kvbEndPtUrlsList.add(listmatching);
        
        //Apigee_Access_Token
        KVB_Endpoint_URLs__c apiGiee 	= new KVB_Endpoint_URLs__c();
        apiGiee.Name 					= 'Apigee_Access_Token';
        apiGiee.Endpoint_URL__c 		= 'https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken';
        apiGiee.Username__c 			= 'Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==';
        kvbEndPtUrlsList.add(apiGiee);
        insert kvbEndPtUrlsList;
        
        List<genesis__Applications__c> applList = [SELECT Id,genesis__Account__c,genesis__Account__r.Jocata_TxnId__c FROM genesis__Applications__c];
        System.debug('applList=====>'+applList.size());
        Test.startTest();
        Batch_JocataListMatchStatus cb = New Batch_JocataListMatchStatus('');
        Database.QueryLocator ql = cb.start(null);
        cb.execute(null,applList);
        cb.Finish(null);
        Test.stopTest();
    }
    
    @isTest
    public static void methodCallResponse(){
        KVB_Endpoint_URLs__c apiGiee 	= new KVB_Endpoint_URLs__c();
        apiGiee.Name 					= 'Apigee_Access_Token';
        apiGiee.Endpoint_URL__c 		= 'https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken';
        apiGiee.Username__c 			= 'Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==';
        insert apiGiee;
        if(!Test.isRunningTest()){  
            MockResponse mokResp = new MockResponse();
            mokResp.serviceName = 'Apigee_Access_Token';
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, mokResp);
           // WS_ApiGatewayAccToken.getAccTkn();
            //System.debug('response====='+WS_ApiGatewayAccToken.getAccTkn());
            Test.stopTest();
        }
    }
      */
    
    public static String apiGeeAccTokenResponse(){
        return '{"expires_in":"22/02/18","access_token":"456"}';
        
    }
    
  
}