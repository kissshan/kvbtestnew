@istest
public class Test_Ws_CBS_collateral_updateAPI {

    public static string custid;
    @testsetup
    public static void setup()
    {
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
        KVB1.Name = 'CBS_Bulk_API';
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES';
        insert kvb1;     
        account acc = new Account(firstName='Venu',LastName='Gopal', Employment_Type__c = 'Salaried',Jocata_TxnId__c = '12345');
        insert acc;
        custid=acc.id;
        
        /*genesis__Applications__c app = TestUtility.intialSetUp('VL4W', false);
        app.Sub_Stage__c='Collaterals details captured';
        update app;*/
        List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);
        appLst[0].Sub_Stage__c='Collaterals details captured';
        update appLst[0];
        
        genesis__Application_Parties__c party =new genesis__Application_Parties__c();       
        party.Key_Contact__c = acc.id;
        party.genesis__Party_Account_Name__c=acc.id;
        party.genesis__Party_Type__c = Constants.Co_Borrower;
        party.Active__c = true;
        party.genesis__Application__c=appLst[0].id;
        party.RetryEkyc__c=false;
        party.Company__c=false;
        insert party;
        
        
        
    }
    @istest
    public static void method1()
    {
        
        genesis__Applications__c genapp=[select id,Sub_Stage__c,Record_Type_Name__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];  
       System.debug('********genapp'+ genapp);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        Ws_CBS_collateral_updateAPI.Collateral_Update(genapp.id,null);
        test.stopTest();
        
    }
  @istest
    public static void method2()
    {
        KVB_Endpoint_URLs__c kvb1 =[select Endpoint_URL__c  from KVB_Endpoint_URLs__c limit 1];
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES12';
        update kvb1;
        
        genesis__Applications__c genapp=[select id,Sub_Stage__c,Record_Type_Name__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];  
       System.debug('********genapp'+ genapp);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        Ws_CBS_collateral_updateAPI.Collateral_Update(genapp.id,null);
        test.stopTest();
        
    }
    
   /* @istest
    public static void method3()
    {
        
        KVB_Endpoint_URLs__c kvb1 = [select id,Endpoint_URL__c from KVB_Endpoint_URLs__c];
        KVB1.Endpoint_URL__c = 'https://www.kvbbank.co.in/bpmsPROD/rest/CueRest/invokeESBService/CreateCustIC_Retail_2';
        update kvb1;  
        genesis__Applications__c genapp=[select id from genesis__Applications__c];
        account acc=[select id from account limit 1];
        system.debug('account:-'+acc);
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        // WS_CBS_CreateCustIC.cbs_CreateCustIC(genapp.id,custid);
        WS_CBS_CreateCustIC.getCustIC(null,genapp.id,acc.id);
        test.stopTest();
        
    }*/
    
}