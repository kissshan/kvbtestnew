//uday----->82%
@isTest
public class Test_WS_LiabilitiesAPI {
        @isTest
        public static void testMethod1(){
            KVB_Endpoint_URLs__c kvb = new KVB_Endpoint_URLs__c();
            kvb.Name	= 'Apigee_Access_Token';
            kvb.Endpoint_URL__c = '/next/v1/oauth/cc/accesstoken';
            kvb.Username__c	='uday.kali@etmarlabs.com';
            insert kvb;
            
            KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='Liabilities API',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/mw/liabilities');
            //kvb.Username__c	= 'Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==';
            insert kvb1;
            

            account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
            genApp.Type__c='NTB';
            insert genApp;
            genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
            prty.genesis__Party_Account_Name__c=acc.id;
            insert prty;
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_LiabilitiesAPI.getDataFromCBS(genApp.id);
            Test.stopTest();
        }
        @isTest
        public static void testMethod2(){
            KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='Liabilities API',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/mw/liabilities');
            insert kvb;

            account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
            //genApp.Type__c='NTB';
            insert genApp;
            genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
            prty.genesis__Party_Account_Name__c=acc.id;
            insert prty;
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_LiabilitiesAPI.getDataFromCBS(genApp.id);
            Test.stopTest();
        }
}