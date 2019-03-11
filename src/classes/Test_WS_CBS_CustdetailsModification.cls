//written by prashant singh
//code coverage:-83%
//date:-10-01-2019


@istest
public class Test_WS_CBS_CustdetailsModification {
    @isTest 
    static void retry_CBS_Sequence_3_5(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
         KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='CBS_FCR_CustModi',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_CUST_DTLS_MODIFICATION');
        insert kvb1;
        
         
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();

                Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
        acc.CBS_Customer_ID__c='123';
        insert acc;
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='3.5',Retry_CBS__c=false,genesis__Account__c=acc.id);
        insert app;
        
         
                 genesis__Application_Document_Category__c ob=new genesis__Application_Document_Category__c();
        //ob.genesis__Active__c=true;
        ob.genesis__Application__c=app.id;
         ob.Applicant__c=acc.id;
         ob.Name='Photo';
         ob.genesis__Parent_Application_Document_Category__c=ob.id;
        insert ob;
         
         genesis__AppDocCatAttachmentJunction__c  genAppDocAttjun = new genesis__AppDocCatAttachmentJunction__c();
         genAppDocAttjun.genesis__Application_Document_Category__c= ob.Id;
         insert genAppDocAttjun;
         
         test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Re_try_CBS_HL.retry_CBS(app.Id);
         test.stoptest();

    }

}