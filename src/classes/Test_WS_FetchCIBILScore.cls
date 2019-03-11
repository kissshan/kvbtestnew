@isTest
public class Test_WS_FetchCIBILScore {
@isTest
    public static void method1(){
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        Account acc=new Account(Name='TestName');
        insert acc;

         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FetchCIBILDetails'; 
        req.httpMethod  = 'GET';
        req.params.put('AccId',acc.id);
       
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        WS_FetchCIBILScore.getCIBILdetails();
        Test.stopTest();
        
    }
    
    @isTest
    public static void method2(){
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        Account acc=new Account(Name='TestName');
        insert acc;

         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FetchCIBILDetails'; 
        req.httpMethod  = 'GET';
        req.params.put('AccIdw',acc.id);
       
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        WS_FetchCIBILScore.getCIBILdetails();
        Test.stopTest();
        
    }
    
     @isTest
    public static void method3(){
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
      
      Account acc=new Account(Name='333');
        insert acc;
        Account acc2=[select id,CIBIL_Score__c from Account where id=:acc.id];
     //   Account acc1;
	//	delete acc;
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FetchCIBILDetails'; 
        req.httpMethod  = 'GET';
        req.params.put('AccIdw',acc2.id);
       
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        WS_FetchCIBILScore.getCIBILdetails();
        Test.stopTest();
    
        
    }
}