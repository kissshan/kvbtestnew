//written by prashant singh
//code coverage:-----98%
//date:---29/09/2018
//class name:----WS_CBS_Collateral_Linkage_HL
//updated on 27-11-2018
//code coverage:--97%
@istest
public class Test_WS_CBS_Collateral_Linkage_HL {
 @testsetup
    public static void setupMethod()
        
    {	
          KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb; 
       KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'CBS_Bulk_API';
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES';
     	insert kvb1;       
		genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
          
        clcommon__Collateral__c collateral = new clcommon__Collateral__c() ;
            collateral.FE_Created__c=True;
            collateral.Active__c=True;
        	collateral.clcommon__Collateral_Name__c='land';
        collateral.Market_Value_Of_The_Land__c=1234.22;
        collateral.Market_Value_Of_The_Building__c=100922.00;
        collateral.genesis__Application__c=app.id;
            insert collateral;
    }     
      @istest
    public static void method1()        
    {
        genesis__Applications__c app=[select id from genesis__Applications__c limit 1];
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		test.startTest();
        WS_CBS_Collateral_Linkage_HL.linkCollateral(app.id,null,null);
        test.stopTest();
    }
    
       @istest
    public static void method2()        
    {
       Id rcdid = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();

        KVB_Endpoint_URLs__c kvb1 =[select Endpoint_URL__c  from KVB_Endpoint_URLs__c limit 1];
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES12';
        update kvb1;
        genesis__Applications__c app=[select id from genesis__Applications__c limit 1];
        app.RecordTypeId=rcdid;
        update app;
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		test.startTest();
        WS_CBS_Collateral_Linkage_HL.linkCollateral(app.id,null,null);
        test.stopTest();
    }
    
      @istest
    public static void method3()        
    {
       Id rcdid = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();

        KVB_Endpoint_URLs__c kvb1 =[select Endpoint_URL__c  from KVB_Endpoint_URLs__c limit 1];
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES12';
        update kvb1;
        genesis__Applications__c app=[select id from genesis__Applications__c limit 1];
        app.RecordTypeId=rcdid;
        update app;
       clcommon__Collateral__c clCollateral1 = SME_TestUtil.createcollateral(app.Id, 'Test Collateral1','Vacant Land');
        clCollateral1.Active__c=true;
        insert clCollateral1;
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		test.startTest();
        WS_CBS_Collateral_Linkage_HL.linkCollateral(app.id,null,null);
        test.stopTest();
    }
     @istest  
     public static void method4()        
    {
       Id rcdid = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL4W).getRecordTypeId();

        KVB_Endpoint_URLs__c kvb1 =[select Endpoint_URL__c  from KVB_Endpoint_URLs__c limit 1];
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES12';
        update kvb1;
        genesis__Applications__c app=[select id from genesis__Applications__c limit 1];
        app.RecordTypeId=rcdid;
        update app;
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		test.startTest();
        WS_CBS_Collateral_Linkage_HL.linkCollateral(app.id,null,null);
        test.stopTest();
    }
}