@isTest
public class Test_DocMasterFetchHandler {
@isTest
    public static void method1(){
        Account acc=new Account(Name='TestName');
        acc.Additional_Income__c=8000;
        acc.Current_Address_Proof_Type__c='bangalore';
        insert acc;
       
        genesis__Applications__c app=TestUtility.intialSetUp('TestName',true);
        app.genesis__Account__c=acc.id;
       // app.Product_Code__c='12345';
        update app;
        
         
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        par.genesis__Application__c=app.id;
        par.genesis__Party_Account_Name__c=acc.id;
         insert par;
        
        genesis__Document_Category__c docob=new genesis__Document_Category__c();
        docob.Document_Category__c='Test';
        docob.genesis__Category_Name__c='TestName';
        insert docob;
            
        DocMasterFetchHandler.getDocumentCategory(app.id);
    }
}