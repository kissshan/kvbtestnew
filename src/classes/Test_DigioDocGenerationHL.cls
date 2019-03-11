/*
* Description : Test_DigioDocGenerationHL
* Purpose : Test class for DigioDocGenerationHL class
* Last Modified:Braj Mohan
*/
@isTest
public class Test_DigioDocGenerationHL {
    @testSetup 
    static void setup(){
        //initial test setup
        List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);

        //Insert DIGIO Templates
        List<DIGIO_Templates__c> digioTemplateLst = VL_Test_Utility.createDigioTemplate();
        Insert digioTemplateLst;

        //KVB Company Details
        KVB_Company_Details__c kvbCompanyDetails = VL_Test_Utility.createKVBCompanyDetails();
        Insert kvbCompanyDetails;

        //KVB Company Details
        List<KVB_Endpoint_URLs__c> kvbEndpointLst = VL_Test_Utility.createKVBEndpointURLs();
        Insert kvbEndpointLst;

        Branch_Master__c BM=VL_Test_Utility.createBranchmasterWithState('A','WEST BENGAL','1857');
        insert BM;
    }
    
    @isTest 
    static void method1() {
        List<genesis__Applications__c> appLst = [Select Id from genesis__Applications__c];
        genesis__Applications__c appln = new genesis__Applications__c();
        appln = queryService.getApplication(appLst[0].Id);
        appln.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HomeLoan).getRecordTypeId();
        update appln;
        System.debug('appln**'+appln);

        genesis__Application_Document_Category__c appdoccat=new genesis__Application_Document_Category__c();
        appdoccat.genesis__Application__c=appln.id;
        appdoccat.name=Constants.LoanDocuments;
        insert appdoccat;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        	DigioDocGenerationHL.CallDocuments(appln.Id,'Disburse',new List<clcommon__Collateral__c>{});     
        Test.stopTest();
    }

    @isTest 
    static void method2() {
        List<genesis__Applications__c> appLst = [Select Id from genesis__Applications__c];
        genesis__Applications__c appln = new genesis__Applications__c();
        appln = queryService.getApplication(appLst[0].Id);
        appln.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HomeLoan).getRecordTypeId();
        update appln;
        System.debug('appln**'+appln);

        genesis__Application_Document_Category__c appdoccat=new genesis__Application_Document_Category__c();
        appdoccat.genesis__Application__c=appln.id;
        appdoccat.name=Constants.LoanDocuments;
        insert appdoccat;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            DigioDocGenerationHL.CallDocuments(appln.Id,'MOD',new List<clcommon__Collateral__c>{});     
        Test.stopTest();
    }

    @isTest 
    static void method3() {
        List<genesis__Applications__c> appLst = [Select Id from genesis__Applications__c];
        genesis__Applications__c appln = new genesis__Applications__c();
        appln = queryService.getApplication(appLst[0].Id);
        appln.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
        update appln;
        System.debug('appln**'+appln);

        genesis__Application_Document_Category__c appdoccat=new genesis__Application_Document_Category__c();
        appdoccat.genesis__Application__c=appln.id;
        appdoccat.name=Constants.LoanDocuments;
        insert appdoccat;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            DigioDocGenerationHL.CallDocuments(appln.Id,'LAPADOC',new List<clcommon__Collateral__c>{});     
        Test.stopTest();
    }

}