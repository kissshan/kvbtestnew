/*
* Name    : Test_WS_FetchApplicationDetails
* Company : ET Marlabs
* Purpose : Test class for WS_FetchApplicationDetails
* Author  : Subhash
-----------------------------------------------------------------------
Version     Date            Author              Remarks                                                 
=======     ==========      =============       ==================================
v1.1        29-Nov-2018     Braj                Added test setup and some test method
*******************************************************************************************/
@isTest
public class Test_WS_FetchApplicationDetails {

    @testSetup 
    public static void setup(){
        genesis__Applications__c app=TestUtility.intialSetUp(Constants.HOMELOAN,true);
        
        Account acc=new Account(Name='TestName');
        acc.Current_Address_Proof_Type__c='tavrekere';
        acc.Voter_Id__c='76127618';
        acc.Electricity_Customer_No__c='712878';
        acc.Customer_LPG_No__c='871287';
        acc.Water_Bill_No__c='8928213';
        acc.Driving_License_ID__c='928198';
        insert acc;
        
        genesis__Application_Parties__c parobj=new genesis__Application_Parties__c(genesis__Application__c=app.id,genesis__Party_Account_Name__c=acc.id);
        insert parobj;
        clcommon__Collateral__c coll2 =VL_Test_Utility.createcollateral(app.Id,WS_UpdatemandatoryFieldsAcc.getRandomExternalIdForCollateral());
        insert coll2;   
        genesis__Application_Document_Category__c docobj=new genesis__Application_Document_Category__c(genesis__Application__c=app.id);
        insert docobj;
        
        genesis__AppDocCatAttachmentJunction__c  junobj=new genesis__AppDocCatAttachmentJunction__c (genesis__Application_Document_Category__c=docobj.Id);
        insert junobj;
        GMRA__c gmobj=new GMRA__c(Application__c=app.id);
        insert gmobj;
    }

    @isTest
    public static void method1(){
        genesis__Applications__c app = [Select Id,genesis__Account__c from genesis__Applications__c LIMIT 1];
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
        app.Sub_Stage__c = Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
        app.RecordTypeId = genAppRecordType;
        update app;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getAlldetailsHL'; 
        req.httpMethod  = 'GET';
        req.params.put('appId',app.id);
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            WS_FetchApplicationDetails.getDetails();
        Test.stopTest();
    }

    @isTest
    public static void method2(){
        genesis__Applications__c app = [Select Id,genesis__Account__c from genesis__Applications__c LIMIT 1];
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
        app.Sub_Stage__c = Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
        app.RecordTypeId = genAppRecordType;
        update app;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getAlldetailsHL';
        req.httpMethod  = 'GET';
        req.params.put('appId',app.id);
        req.params.put('Type','Processfee');
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            WS_FetchApplicationDetails.getDetails();
        Test.stopTest();
    }

    @isTest
    public static void method3(){
        genesis__Applications__c app = [Select Id,genesis__Account__c from genesis__Applications__c LIMIT 1];
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL4W).getRecordTypeId();
        app.Sub_Stage__c = Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
        app.RecordTypeId = genAppRecordType;
        update app;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getAlldetailsHL';
        req.httpMethod  = 'GET';
        req.params.put('appId',app.id);
        req.params.put('Type','Processfee');
        
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            WS_FetchApplicationDetails.getDetails();
        Test.stopTest();
    }

}