//written by prashant singh
//class name :-WS_CBS_CreateCustIC
//code coverage:-80%
//date:-24-12-2018


@istest
public class Test_WS_CBS_CreateCustIC {
    public static string custid;
    @testsetup
    public static void setup()
    {
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
        KVB1.Name = 'CBS_CustIC_API';
        KVB1.Endpoint_URL__c = 'https://www.kvbbank.co.in/bpmsPROD/rest/CueRest/invokeESBService/CreateCustIC_Retail';
        insert kvb1;     
        account acc = new Account(firstName='Venu',LastName='Gopal', Employment_Type__c = 'Salaried',Jocata_TxnId__c = '12345');
        insert acc;
        custid=acc.id;
        
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', false);
        genesis__Application_Parties__c party =new genesis__Application_Parties__c();       
        party.Key_Contact__c = acc.id;
        party.genesis__Party_Account_Name__c=acc.id;
        party.genesis__Party_Type__c = Constants.Co_Borrower;
        party.Active__c = true;
        party.genesis__Application__c=app.id;
        party.RetryEkyc__c=false;
        party.Company__c=false;
        insert party;
        
        
        
    }
    @istest
    public static void method1()
    {
        
        genesis__Applications__c genapp=[select id from genesis__Applications__c];    
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        WS_CBS_CreateCustIC.cbs_CreateCustIC(genapp.id,custid);
        test.stopTest();
        
    }
    @istest
    public static void method2()
    {
        
        KVB_Endpoint_URLs__c kvb1 = [select id,Endpoint_URL__c from KVB_Endpoint_URLs__c];
        KVB1.Endpoint_URL__c = 'https://www.kvbbank.co.in/bpmsPROD/rest/CueRest/invokeESBService/CreateCustIC_Retail_1';
        update kvb1;  
        genesis__Applications__c genapp=[select id from genesis__Applications__c];
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        WS_CBS_CreateCustIC.cbs_CreateCustIC(genapp.id,custid);
        test.stopTest();
        
    }
    
    @istest
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
        
    }
    
    @istest
    public static void method4()
    {
        
        KVB_Endpoint_URLs__c kvb1 = [select id,Endpoint_URL__c from KVB_Endpoint_URLs__c];
        KVB1.Endpoint_URL__c = 'https://www.kvbbank.co.in/bpmsPROD/rest/CueRest/invokeESBService/CreateCustIC_Retail_3';
        update kvb1;  
        genesis__Applications__c genapp=[select id from genesis__Applications__c];
        account acc=[select id from account limit 1];
        system.debug('account:-'+acc);
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        // WS_CBS_CreateCustIC.cbs_CreateCustIC(genapp.id,custid);
        WS_CBS_CreateCustIC.getCustIC(null,genapp.id,acc.id);
        test.stopTest();
        
    }
}