//modified by prashant singh on 17-12-2018
//code coverage:-100%
@isTest
public class Test_FetchAllApplication {
@isTest
    public static void method1(){
        
         genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        app.Sub_Stage__c='primary';
        app.Sourced_By__c='87ad';
        app.Application_Stage__c='primary';
        update app;
        Account acc=new Account(Name='TestName');
        insert acc;
        DSA_Master__c	dsaobj=new DSA_Master__c(Branch_Code__c='909',Branch_Name__c='testbranch',Employ_Code__c='87ad',Employ_Name__c='Niladri',Role__c='DSA');
        insert dsaobj;
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getApplication'; 
        req.httpMethod  = 'GET';
        req.params.put('appStage','primary');
        req.params.put('dsaCode','87ad');
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        FetchAllApplication.getDetails();
        FetchAllApplication.AppReqWrapper appReqWra = new FetchAllApplication.AppReqWrapper();
        Test.stopTest();
    }

@isTest
    public static void method2(){
        
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        app.Sub_Stage__c='primary';
        update app;
        Account acc=new Account(Name='TestName');
        insert acc;
        DSA_Master__c	dsaobj=new DSA_Master__c(Branch_Code__c='909',Branch_Name__c='testbranch',Employ_Code__c='87ad',Employ_Name__c='Niladri',Role__c='DSA');
        insert dsaobj;
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getApplication'; 
        req.httpMethod  = 'GET';
        req.params.put('appStage','primary');
        req.params.put('dsaCode',dsaobj.Id);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        FetchAllApplication.getDetails();
        Test.stopTest();
    }
    
}