//written by prashant singh
//class name:---WS_CBS_Stamp_Charge_HL
//coverage percentage:---100%.... 
@istest
public class Test_WS_CBS_Stamp_Charge_HL {
      @testsetup
    public static void setupMethod()        
    {	
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb;
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'Processing_Fee_API';
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_ACDR_GLCR_Charge_COLL';
     	insert kvb1;
        
     
     
        Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
        insert acc;
     
        genesis__Applications__c app = Utility_Test.createApplication('1323', acc.id);
        app.SI_Bank_Name__c='Karur Vysya Bank';
        insert app;      
     
    } 
     @istest
    public static void method1()        
    {
        Account acc=[select id from Account limit 1];
         genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
     	 Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.startTest();
        WS_CBS_Stamp_Charge_HL.sendStamp_Charge(appid.id,acc.id);
        test.stopTest();       

    }
     @istest
    public static void method2()        
    {
            KVB_Endpoint_URLs__c kvb1 =[select Endpoint_URL__c  from KVB_Endpoint_URLs__c limit 1];
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_ACDR_GLCR_Charge_COLL1';
        update kvb1;
        Account acc=[select id from Account limit 1];
         genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
     	 Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.startTest();
        WS_CBS_Stamp_Charge_HL.sendStamp_Charge(appid.id,acc.id);
        test.stopTest();       

    }
      @istest
    public static void method3()        
    {
            KVB_Endpoint_URLs__c kvb1 =[select Endpoint_URL__c  from KVB_Endpoint_URLs__c limit 1];
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_ACDR_GLCR_Charge_COLL2';
        update kvb1;
        Account acc=[select id from Account limit 1];
         genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
     	 Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.startTest();
        WS_CBS_Stamp_Charge_HL.sendStamp_Charge(appid.id,acc.id);
        test.stopTest();       

    }
    
     @istest
    public static void method4()        
    {
            KVB_Endpoint_URLs__c kvb1 =[select Endpoint_URL__c  from KVB_Endpoint_URLs__c limit 1];
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_ACDR_GLCR_Charge_COLL3';
        update kvb1;
        Account acc=[select id from Account limit 1];
         genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
     	 Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.startTest();
        WS_CBS_Stamp_Charge_HL.sendStamp_Charge(appid.id,acc.id);
        test.stopTest();       

    }
     

}