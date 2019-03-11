@isTest
public class Test_WS_docFetch {
@isTest
    public static void method1(){
        
         genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        Account acc=new Account(Name='TestName');
        acc.Current_Address_Proof_Type__c='uid';
        insert acc;
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        par.genesis__Application__c=app.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.Additional_Income__c=166666;
        insert par;

         genesis__Document_Category__c docob=new genesis__Document_Category__c();
        docob.Document_Category__c='Proof of income';
        docob.genesis__Category_Name__c='Proof of current address';
        insert docob;
        
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getDoc'; 
        req.httpMethod  = 'GET';
        req.params.put('appId',app.id);
       
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        WS_docFetch.getDetails();
        Test.stopTest();
    }
    
    @isTest
    public static void method2(){
        
         genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        Account acc=new Account(Name='TestName');
        insert acc;

         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getDoc'; 
        req.httpMethod  = 'GET';
        req.params.put('appIdw',app.id);
       
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        WS_docFetch.getDetails();
        Test.stopTest();
    }
}