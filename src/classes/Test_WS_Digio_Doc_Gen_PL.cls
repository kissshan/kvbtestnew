@isTest
public class Test_WS_Digio_Doc_Gen_PL {
 @isTest
    public static void method1(){
        
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        app.Document_Generation__c='PL1 Doc ID';
        app.Sanction_Doc_Generation_Check__c=true;
        app.Legal_desk_state_flag__c=true;
        app.genesis__Interest_Rate__c=10;
        app.MCLR_Rate__c=8;
        app.Branch_Code__c='104';
        app.Sanctioned_EMI__c=100000;
        app.Sanctioned_Tenure__c=10;
        app.Branch_State__c='wb';
        app.genesis__Disbursement_Date__c=System.today();
        app.Holiday_Period__c=2;
        app.Docgen_Fail__c=true;
        //app.Property_Type__c='Rent';
        update app;
        
        Branch_Master__c bmobj=new Branch_Master__c();
        bmobj.State__c='wb';
        bmobj.CODCCBRN__c='104';
        insert bmobj;
        
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
        WS_Digio_Doc_Gen_PL.getDetails();
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
        WS_Digio_Doc_Gen_PL.getDetails();
        Test.stopTest();
    }
}