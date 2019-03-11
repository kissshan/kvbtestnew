/*
* Description : Test_WS_Perfios_Get_Operational_Data
* Author      : Kishan Panchal
*/
@isTest
public class Test_WS_Perfios_Get_Operational_Data {

    @isTest public static void OperationalDataMethod(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            insert genApp;
            
            clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('Test Product','test234','Non-funded');
            insert clProd;
            
            Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'34455677',345.55);
            insert fac;
            
            Operations_Detail__c opDetail = new Operations_Detail__c();
            opDetail.Account__c=acc.id;
            opDetail.Facility__c=fac.Id;
            insert opDetail;
            
            Perfios__c perfio = SME_TestUtil.createperfios(genApp.Id,acc.Id);
            insert perfio;
            KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb1;  
            KVB_Endpoint_URLs__c kvb = new KVB_Endpoint_URLs__c(name='Perfios SME New Loan',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/analysis/offline/statement/report?txnId=');
          insert kvb;
            
            
          
             Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_Perfios_Get_Operational_Data.getPerfiosResponse('2345d','234567');
            WS_Perfios_Get_Operational_Data.sendRequest('2345d',genApp.Id,perfio.Id);
            Test.stopTest();
        } 
    }
    @isTest static void OperationalDataCatch(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            insert genApp;
            
            clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('Test Product','test234','Non-funded');
            insert clProd;
            
            Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'34455677',345.55);
            insert fac;
            
            Operations_Detail__c opDetail = new Operations_Detail__c();
            opDetail.Account__c=acc.id;
            opDetail.Facility__c=fac.Id;
            insert opDetail;
            
            Perfios__c perfio = SME_TestUtil.createperfios(genApp.Id,acc.Id);
            insert perfio;
         Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_Perfios_Get_Operational_Data.getPerfiosResponse('2345d','234567');
            WS_Perfios_Get_Operational_Data.sendRequest('2345d',genApp.Id,perfio.Id);
            Test.stopTest();
    }
   
}
}