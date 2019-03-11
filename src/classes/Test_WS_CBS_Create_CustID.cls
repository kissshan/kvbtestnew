//name:-prashant singh
//date:-24-12-2018
//code coverage:-93%
//class name:-WS_CBS_Create_CustID

@isTest
public class Test_WS_CBS_Create_CustID {

     @testsetup
    public static void setupMethod()
        
    {	

         //Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();

          KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb; 
       KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'CBS_Bulk_API';
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES';
     	insert kvb1;       
		genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        account acc=[select id from account limit 1];
        acc.PersonBirthdate=date.parse('05/12/1995');
        acc.Customer_IC__c='123';
        update acc;
        
        
    }  
    @istest
    public static void  method1()
    {
		genesis__Applications__c genapp=[select id from genesis__Applications__c];
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CBS_Create_CustID.getCBSID(genapp.id);
        test.stopTest();
        
    }
        @istest
    public static void  method2()
    {
        //response code!=201
        KVB_Endpoint_URLs__c url=[select id  from KVB_Endpoint_URLs__c];
        url.name='CBS_Bulk_API';
        url.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES_custom';
        update url;
        
		genesis__Applications__c genapp=[select id from genesis__Applications__c];
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CBS_Create_CustID.getCBSID(genapp.id);
        test.stopTest();
        
    }
    
}