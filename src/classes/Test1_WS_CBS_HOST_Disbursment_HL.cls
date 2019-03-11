/*
 Purpose : Test class for WS_CBS_HOST_Disbursment_HL

*/
@isTest
public class Test1_WS_CBS_HOST_Disbursment_HL 
{
@isTest 
   static void Host_request()
   {
      
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='HOST_Disb_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_HOST_SCH_LN521');
        insert kvb;
       KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='Branch_Disbursement_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_AC_GL_DISB_Transfer');
        insert kvb1;
       
       clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='Co-Lending');
        insert product;
       Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
            
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
        genesis__Applications__c genApp= SME_TestUtil.createApplication('Chennai',acc.Id,'Application Filling','FI Approved','Submission');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Loan_Account_Number__c='test12333';
     //  Date datetest=System.Today();
     //   Date disdate= datetest.addDays(-12);
        genApp.genesis__Disbursement_Date__c=Date.newInstance(2018, 8, 5);
       genApp.Holiday_Period__c=10;
       genApp.Disbursement_Amount__c=122232342.23;
       genApp.Final_GMRA__c=1232.43;
       genApp.genesis__CL_Product__c = product.id;

        insert genApp;
        
      //  insert new KVB_Endpoint_URLs__c(name ='CBS_MIS_Update',Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CBS_HOST_Disbursment_HL.Host_request(genApp.Id,null);
        Test.stopTest();
        
       
   }
    @isTest 
   static void Host_request1()
   {
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='HOST_Disb_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_HOST_SCH_LN5211');
        insert kvb;
       
       clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='Co-Lending');
        insert product;
       Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
            
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
        genesis__Applications__c genApp= SME_TestUtil.createApplication('Chennai',acc.Id,'Application Filling','FI Approved','Submission');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Loan_Account_Number__c='test12333';
     //  Date datetest=System.Today();
     //   Date disdate= datetest.addDays(-12);
        genApp.genesis__Disbursement_Date__c=Date.newInstance(2018, 8, 5);
       genApp.Holiday_Period__c=10;
       genApp.Disbursement_Amount__c=122232342.23;
       genApp.Final_GMRA__c=1232.43;
       genApp.genesis__CL_Product__c = product.id;

        insert genApp;
        
      //  insert new KVB_Endpoint_URLs__c(name ='CBS_MIS_Update',Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CBS_HOST_Disbursment_HL.Host_request(genApp.Id,null);
        Test.stopTest();
        
       
   }
    @istest
     static void Host_request2()
   {
      
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='HOST_Disb_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_HOST_SCH_LN521');
        insert kvb;
       KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='Branch_Disbursement_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_AC_GL_DISB_Transfer');
        insert kvb1;
       
       clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='dummy');
        insert product;
       Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
            
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
        genesis__Applications__c genApp= SME_TestUtil.createApplication('Chennai',acc.Id,'Application Filling','FI Approved','Submission');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Loan_Account_Number__c='test12333';
     //  Date datetest=System.Today();
     //   Date disdate= datetest.addDays(-12);
        genApp.genesis__Disbursement_Date__c=system.today();
       genApp.Holiday_Period__c=null;
       genApp.Disbursement_Amount__c=122232342.23;
       genApp.Final_GMRA__c=1232.43;
       genApp.genesis__CL_Product__c = product.id;
       genApp.Holiday_Period__c=10;
        insert genApp;
        
      //  insert new KVB_Endpoint_URLs__c(name ='CBS_MIS_Update',Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CBS_HOST_Disbursment_HL.Host_request(genApp.Id,null);
        Test.stopTest();
        
       
   }
 
}