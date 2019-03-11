//written by prashant singh
//on 30-11-2018
//code coverage:-94%
//claas name:-WS_CBS_CASA_Disbursement_Retail
@istest
public class WS_CBS_CASA_Disbursement_Retail_Test { 
    @isTest static void retry_CBS_Sequence_22_v1(){
                     Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();

        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
         KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='CBS_Disbu_CASA',Endpoint_URL__c='https://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/POST_DISBURSEMENT');
        insert kvb1;
				
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='20.5',Retry_CBS__c=false,genesis__Disbursement_Date__c=date.parse('7/12/2017'),SI_Bank_Name__c = Constants.PL_SI_KVB,RecordTypeId = recttype);
        insert app;
        test.starttest();
        Re_try_CBS_HL.retry_CBS(app.Id);
		test.stoptest();
    }
     @isTest static void retry_CBS_Sequence_22_v2(){

        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
         KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='CBS_Disbu_CASA',Endpoint_URL__c='https://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/POST_DISBURSEMENT1');
        insert kvb1;
				
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='20.5',Retry_CBS__c=false,genesis__Disbursement_Date__c=date.parse('7/12/2017'));
        insert app;
        test.starttest();
        Re_try_CBS_HL.retry_CBS(app.Id);
		test.stoptest();
    }
     @isTest static void retry_CBS_Sequence_22_v3(){
                     Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();

        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
         KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='CBS_Disbu_CASA',Endpoint_URL__c='https://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/POST_DISBURSEMENT');
        insert kvb1;
				
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='20.5',Retry_CBS__c=false,genesis__Disbursement_Date__c=date.parse('7/12/2017'),SI_Bank_Name__c = 'sbi',RecordTypeId = recttype);
        insert app;
        test.starttest();
        Re_try_CBS_HL.retry_CBS(app.Id);
		test.stoptest();
    }

}