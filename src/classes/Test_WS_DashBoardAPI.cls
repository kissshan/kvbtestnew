@isTest
public class Test_WS_DashBoardAPI {
@isTest
    public static void method1(){
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        Account acc=new Account(Name='TestName');
        insert acc;

         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FetchApplications'; 
        req.httpMethod  = 'GET';
        req.params.put('AppType',acc.id);
       
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        WS_DashBoardAPI.FetchApplicationts();
        Test.stopTest();
        
    }
    
    @isTest
    public static void method2(){
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        Account acc=new Account(Name='TestName');
        insert acc;

         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FetchApplications'; 
        req.httpMethod  = 'GET';
        req.params.put('AppTypew',acc.id);
       
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        WS_DashBoardAPI.FetchApplicationts();
        Test.stopTest();
        
    }
}