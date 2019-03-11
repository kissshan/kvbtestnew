@isTest
public class Test_WS_Vendor_CBS_CustIC {
    
public class mockWSVendorResposne implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"bpms_error_code": "00","out_msg":{"ApplicationNumber": "APP-0000228857","CustomerICDetails":[{"Cust_IC": "SARAT19051981M","ApplicantNumber": "0010l00000ZAKwa"}]},"bpms_error_msg": "Success"}');
        res.setStatusCode(200);
        return res;
    }
}

public class mockWSVendorResposneFailure implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"bpms_error_code": "00","out_msg":{"ApplicationNumber": "APP-0000228857","CustomerICDetails":[{"HttpStatus": "500","ErrorCode": "MW9999","ErrorMessage": "TECHNICAL ERROR","ApplicantNumber": ""}]},"bpms_error_msg": "Failure"}');
        res.setStatusCode(100);
        return res;
    }
}

       
    @isTest static void retry_CBS_vendor_CustIC(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_CustIC_API_ThirdParty',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        genesis__Applications__c app = new genesis__Applications__c
        (CBS_API_Sequence__c='0.1',Retry_CBS__c=false, recordtypeid=devRecordTypeId);
        insert app;
        Account acc = new Account(LastName = 'TestCustIC',PersonBirthdate=date.valueOf('1989-06-09'));
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert acc;
        genesis__Application_Parties__c part = new genesis__Application_Parties__c(genesis__Application__c=app.Id,genesis__Party_Account_Name__c=acc.Id);
        insert part;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockWSVendorResposne());
        Re_try_CBS_HL.retry_CBS(app.Id);
        test.stopTest();
    }
    
      @isTest static void retry_CBS_vendor_CustIC1(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_CustIC_API_ThirdParty',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        genesis__Applications__c app = new genesis__Applications__c
        (CBS_API_Sequence__c='0.1',Retry_CBS__c=false, recordtypeid=devRecordTypeId);
        insert app;
        Account acc = new Account(LastName = 'TestCustIC',PersonBirthdate=date.valueOf('1989-06-09'));
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert acc;
        genesis__Application_Parties__c part = new genesis__Application_Parties__c(genesis__Application__c=app.Id,genesis__Party_Account_Name__c=acc.Id);
        insert part;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockWSVendorResposneFailure());
        Re_try_CBS_HL.retry_CBS(app.Id);
        test.stopTest();
    }
    
    @isTest static void retry_CBS_vendor_CustIC2(){
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_CustIC_API_ThirdParty',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        insert kvb;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        genesis__Applications__c app = new genesis__Applications__c
        (CBS_API_Sequence__c='0.1',Retry_CBS__c=false, recordtypeid=devRecordTypeId);
        insert app;
        Account acc = new Account(LastName = 'TestCustIC',PersonBirthdate=date.valueOf('1989-06-09'));
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert acc;
        genesis__Application_Parties__c part = new genesis__Application_Parties__c(genesis__Application__c=app.Id,genesis__Party_Account_Name__c=acc.Id);
        insert part;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Re_try_CBS_HL.retry_CBS(app.Id);
        test.stopTest();
    }
}