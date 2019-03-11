@isTest
public class Test_WS_EthicsCall {
    Static genesis__Applications__c app;
    static Account acc;
     @testsetup
        public static void setup(){
            KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        insert kvb;
            KVB_Endpoint_URLs__c endurl=new KVB_Endpoint_URLs__c();
            endurl.Name='Ethics Data';
            endurl.Endpoint_URL__c='https://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/ETHICS_Fetch';
            insert endurl;
        }
    @isTest
    public static void getSMECustomersValid() {
        app = TestUtility.intialSetUp('Test Application', true);
        acc = new Account(Name = 'TestName');
        insert acc;
        
        List<Audit__c> auditList = new List<Audit__c>();
        Audit__c auditobj = new Audit__c();
        auditobj.Account_Name__c              =   acc.Id;
        auditList.add(auditobj);
        
        Audit__c auditobj2 = new Audit__c();
        auditobj2.Account_Name__c              =   acc.Id;
        auditList.add(auditobj2);
        Insert auditList; 
        
       /* Facility__c facilitiesobj	= new Facility__c();
        facilitiesobj.Application__c = app.Id;
        insert facilitiesobj;
        
        Facility__c facilitiesobj1	= new Facility__c();
        facilitiesobj1.Facility__c = facilitiesobj.Id;
        delete facilitiesobj1;*/
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        Test.startTest();
        WS_EthicsCall.getEthicsInfo(acc.Id);
        WS_EthicsCall.deleteChildFacilities(app.Id);
        Test.stopTest();
    }
}