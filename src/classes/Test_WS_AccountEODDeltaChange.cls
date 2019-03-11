@isTest
public class Test_WS_AccountEODDeltaChange {
    public static genesis__Applications__c app;
     public static void init(){
        app=TestUtility.intialSetUp('HomeLoan',true);
           
        KVB_Endpoint_URLs__c loanChargeURLs = new KVB_Endpoint_URLs__c();
        loanChargeURLs.Name = '' ;
        loanChargeURLs.Endpoint_URL__c = 'http://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/CBS_CBR_DTLS_MNT_HL' ;
        loanChargeURLs.Password__c = '' ;
        loanChargeURLs.Username__c = '' ;
        INSERT loanChargeURLs;
        
    }
@isTest
    public static void method1(){
        try{
        init();
        //    MockResponse mokResp = new MockResponse();
         //   mokResp.serviceName = '';
            
            Test.startTest();
       //     Test.setMock(HttpCalloutMock.class, mokResp);
            WS_AccountEODDeltaChange.accountDeltaChange();
            Test.stopTest();
        }Catch(Exception e){}
    }
}