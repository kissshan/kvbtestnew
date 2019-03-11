@isTest
public class Test_Re_try_CBS_HL {
   
  /*  @isTest static void retry_CBS_Sequence_null(){
        
        genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='',Retry_CBS__c=false);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);
    }
   
    @isTest static void retry_CBS_Sequence_1(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
       insert kvb;
       

        Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
        acc.CBS_Customer_ID__c=null;
        insert acc;

        genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='1',genesis__Account__c=acc.id);
        insert app;
        Test.startTest();
        Re_try_CBS_HL.retry_CBS(app.Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Test.stopTest();    
        
        
    }
     @isTest static void retry_CBS_Sequence_1_personal_loan(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
       insert kvb;
         KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='CBS_Dedupe_Bulk',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_CUST_DEDUP_IC_PAN_AADHAAR_HL');
       insert kvb1;
        Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
        acc.CBS_Customer_ID__c=null;
        insert acc;
        Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();

        genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='1',genesis__Account__c=acc.id,recordtypeid=devRecordTypeId);
        insert app;
        Test.startTest();
        Re_try_CBS_HL.retry_CBS(app.Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Test.stopTest();    
        
        
    }
    
    @isTest static void retry_CBS_Sequence_2(){
        genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='2',Retry_CBS__c=false);
        
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);
    }
    
    @isTest static void retry_CBS_Sequence_2_else(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='2',Retry_CBS__c=false, recordtypeid=devRecordTypeId);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);   
        
    }
   
    @isTest static void retry_CBS_Sequence_3_if(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='3',Retry_CBS__c=false, recordtypeid=devRecordTypeId);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }
     
    @isTest static void retry_CBS_Sequence_3_else(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='3',Retry_CBS__c=false, recordtypeid=devRecordTypeId);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }
     
    
    @isTest static void retry_CBS_Sequence_5_if(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='5',Retry_CBS__c=false, recordtypeid=devRecordTypeId);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }
     
    @isTest static void retry_CBS_Sequence_5_else(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='5',Retry_CBS__c=false, recordtypeid=devRecordTypeId);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }
    
    
    @isTest static void retry_CBS_Sequence_9(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='9',Retry_CBS__c=false);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }*/
    
     @isTest static void retry_CBS_Sequence_11(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
         KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='CBS_Bulk_API',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES');
        insert kvb1;
         
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();

                Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
        insert acc;
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='11',Retry_CBS__c=false,genesis__Account__c=acc.id);
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
   /* @isTest static void retry_CBS_Sequence_11_1(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
         KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='CBS_Bulk_API',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES');
        insert kvb1;
         
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
                Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
        insert acc;
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='11',Retry_CBS__c=false,genesis__Account__c=acc.id);
        insert app;
        
         
                 genesis__Application_Document_Category__c ob=new genesis__Application_Document_Category__c();
        ob.genesis__Active__c=true;
        ob.genesis__Application__c=app.id;
         ob.Name='Photo';
         ob.Applicant__c=acc.id;
        insert ob;
         
         test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Re_try_CBS_HL.retry_CBS(app.Id);
         test.stoptest();

    }
     @isTest static void retry_CBS_Sequence_12(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='12',Retry_CBS__c=false);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }
     @isTest static void retry_CBS_Sequence_13(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='13',Retry_CBS__c=false);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }
     @isTest static void retry_CBS_Sequence_14(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='14',Retry_CBS__c=false);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }
     @isTest static void retry_CBS_Sequence_15(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='15',Retry_CBS__c=false);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }
     @isTest static void retry_CBS_Sequence_21(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
                Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
                //Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
 genesis__Applications__c app = new genesis__Applications__c
            (CBS_API_Sequence__c='21',Retry_CBS__c=false);
        insert app;
        Re_try_CBS_HL.retry_CBS(app.Id);

    }*/
    
     
}