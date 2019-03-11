@isTest
public class Test_WS_CBS_HOST_Disbursment_HL {
    public static genesis__Applications__c app;
    public static void init(){
        app=TestUtility.intialSetUp('HomeLoan',true);
        app.Cersai_Charges__c=700;
        update app;
        
        KVB_Endpoint_URLs__c loanChargeURLs = new KVB_Endpoint_URLs__c();
        loanChargeURLs.Name = 'CBS_CBR_DTLS_MNT_HL' ;
        loanChargeURLs.Endpoint_URL__c = 'http://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/CBS_CBR_DTLS_MNT_HL' ;
        loanChargeURLs.Password__c = '' ;
        loanChargeURLs.Username__c = '' ;
        INSERT loanChargeURLs;
        
    }
    @isTest
    public static void test1(){
        
    }
}