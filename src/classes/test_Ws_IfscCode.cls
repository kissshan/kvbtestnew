//written by prashant singh.............
//date:-18-09-2018.
@istest
public class test_Ws_IfscCode {
    @testsetup
    public static void setup()
        {
                   KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb;
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'IFSC';
        KVB1.Endpoint_URL__c = '/ext_bpms/rest/CueRest/invokeESBService/Fetch_IFSC_Details';
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
            
             genesis__Applications__c app=new  genesis__Applications__c();
             genesis__Application_Parties__c party =new genesis__Application_Parties__c();           
            party.Primary_Bank__c='kvb';
             party.Primary_Bank_Branch__c='chennai';
                party.genesis__Application__c=app.id;
     		party.Active__c = true;
            insert party;
              Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            test.startTest();
            Ws_IfscCode.callIfsc('UTIB0001926',party.Id);
            test.stopTest();
        }

}