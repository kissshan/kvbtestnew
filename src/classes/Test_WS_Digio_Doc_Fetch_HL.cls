@isTest 
public class Test_WS_Digio_Doc_Fetch_HL {
    @isTest
    public static void method1(){
        
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        String accId = [select id , genesis__account__c from genesis__applications__c where Id =:app.Id].genesis__account__c;
        System.debug('accId:::'+accId);
        Account acct = [select Id from Account where Id =: accId];
        app.genesis__Account__c =acct.Id;
        
        System.debug('acct:::'+acct);
		genesis__Applications__c  genApp = [select id, genesis__Account__c from genesis__Applications__c limit 1];
        
        Digio_Document_ID__c digioobj=new Digio_Document_ID__c(Application__c=genApp.Id,Stamp_Charges__c=90,Borrower__c=true);
        insert digioobj;
        Document_Applicant__c docobj=new Document_Applicant__c(Digio_Document_ID__c=digioobj.Id,Account__c=acct.id,eSigned__c=true);
        insert docobj;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getDgioDoc'; 
        req.httpMethod  = 'GET';
        req.params.put('appId',app.id);
        
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        WS_Digio_Doc_Fetch_HL.getDetails();
        Test.stopTest();
    }
    
    @isTest
    public static void method2(){
        
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        Account acc=new Account(Name='TestName');
        insert acc;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getDgioDoc'; 
        req.httpMethod  = 'GET';
        req.params.put('appIdk',app.id);
        
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        WS_Digio_Doc_Fetch_HL.getDetails();
        Test.stopTest();
    }
}