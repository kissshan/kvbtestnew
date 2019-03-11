//written by prashant singh...
////percentage:-----91%
@istest
public class Test_WS_CBS_Loan_Disbursment_HL {
      @testsetup
    public static void CBS_SI_Creation()
        
    {	
          KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb;
        
       
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'Branch_Disbursement_HL';
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_AC_GL_DISB_Transfer';
     	insert kvb1;
        
         KVB_Endpoint_URLs__c kvb2 = new KVB_Endpoint_URLs__c();
     	KVB2.Name = 'CBS_SI_API';
        KVB2.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_SI_CHRG_COLL';
     	insert kvb2;
     
        Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
        insert acc;
     
        genesis__Applications__c app = Utility_Test.createApplication('1323', acc.id);
        app.SI_Bank_Name__c='Karur Vysya Bank';
        app.Disbursement_Amount__c=123.22;
        app.Final_GMRA__c=12.22;
        app.Sourced_By__c='dummy';
        
        insert app;
        Third_Party_CBR_Codes__c thirdparty=new Third_Party_CBR_Codes__c();
        thirdparty.CASAAccountNumber__c='7526076363';
        thirdparty.Name='dummy';
        insert thirdparty;
        
    
        
     
    } 
    @istest
    public static void method1() 
        
    {
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        genesis__Applications__c app=[select id from genesis__Applications__c];     
         Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        app.RecordTypeId=genAppRecordType;
		update app;
           Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.startTest();
        WS_CBS_Loan_Disbursment_HL.callDisb(app.id,UpcbsLog,null);
        test.stopTest();
        
    }
     @istest
    public static void method2()        
    {
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
             genesis__Applications__c app=[select id from genesis__Applications__c];     
         Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        app.RecordTypeId=genAppRecordType;
                app.SI_Bank_Name__c='psit kanpur';

		update app;
           Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.startTest();
        WS_CBS_Loan_Disbursment_HL.callDisb(app.id,UpcbsLog,null);
        test.stopTest();
        
    }
      @istest
    public static void method3()        
    {
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
             genesis__Applications__c app=[select id from genesis__Applications__c];     
         Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
        app.RecordTypeId=genAppRecordType;
                app.SI_Bank_Name__c='psit kanpur';

		update app;
           Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.startTest();
        WS_CBS_Loan_Disbursment_HL.callDisb(app.id,UpcbsLog,null);
        test.stopTest();
        
    }
      @istest
    public static void method4()        
    {
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        KVB_Endpoint_URLs__c kvb1=[select id from KVB_Endpoint_URLs__c where name='Branch_Disbursement_HL'];
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_AC_GL_DISB_Transfer1';
        update kvb1;
             genesis__Applications__c app=[select id from genesis__Applications__c];     
         Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
        app.RecordTypeId=genAppRecordType;
                app.SI_Bank_Name__c='psit kanpur';

		update app;
           Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.startTest();
        WS_CBS_Loan_Disbursment_HL.callDisb(app.id,UpcbsLog,null);
        test.stopTest();
        
    }
      

}