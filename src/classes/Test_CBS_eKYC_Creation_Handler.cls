//written by prashant singh
//class name:--WS_CBS_eKYC_Creation_HL
//percentage coverage---88%
//date:-28/09/2018
@isTest
public class Test_CBS_eKYC_Creation_Handler {

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
          
    } 
    //status==200||201
    @istest
    public static void method1()        
    {
        genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
        list<account> listacc=new list<account>([select id from account]);
        list<id> listaccids=new list<id>();
        for(account tempaccvar:listacc)
        {
            listaccids.add(tempaccvar.id);
        }
        map<string,string> m=new  map<string,string>();
        m.put('1', '1');
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		test.startTest();
        WS_CBS_eKYC_Creation_HL.cbs_eKYC_Creation(listaccids, appid.id, m);
        test.stopTest();
    }
@istest
    public static void method2()  //status!=200||201      
    {
 		KVB_Endpoint_URLs__c kvb1 =[select Endpoint_URL__c  from KVB_Endpoint_URLs__c limit 1];
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES12';
        update kvb1;
        genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
        genesis__Application_Parties__c partyobj=[select id from genesis__Application_Parties__c limit 1];
        partyobj.Active__c=true;
        partyobj.Company__c=false;
        partyobj.genesis__Party_Type__c=Constants.PRIMARY_APP;
        partyobj.genesis__Application__c=appid.id;
        update partyobj;
        system.debug('partyobj:====='+partyobj);
        list<account> listacc=new list<account>([select id from account]);
        list<id> listaccids=new list<id>();
        for(account tempaccvar:listacc)
        {
            listaccids.add(tempaccvar.id);
        }
        map<string,string> m=new  map<string,string>();
        m.put('1', '1');
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		test.startTest();
        WS_CBS_eKYC_Creation_HL.cbs_eKYC_Creation(listaccids, appid.id, m);
        test.stopTest();
    }


}