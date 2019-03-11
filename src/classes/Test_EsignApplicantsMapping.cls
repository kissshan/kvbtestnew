@isTest
public class Test_EsignApplicantsMapping {
@isTest
    public static void method1(){
        genesis__Applications__c  app=TestUtility.intialSetUp('TestName',true);
        
        genesis__Applications__c app1=new genesis__Applications__c();
        app1.Property_State__c='Tamil Nadu';
        update app1;
        System.debug('TEST app: '+app);
        
        
        Digio_Document_ID__c docobj=new Digio_Document_ID__c();
        docobj.Application__c=app.id;
        docobj.Borrower__c=true;
        docobj.Document_ID__c='udiu778';
        docobj.Name='C11';
      
        insert docobj;
        //list<Digio_Document_ID__c> doclist=[select id,Name,Application__r.Property_State__c,Application__c,Borrower__c,Document_ID__c from Digio_Document_ID__c where id=:docobj.id];
         list<Digio_Document_ID__c> doclist=[select Application__r.Property_State__c from Digio_Document_ID__c where id=:docobj.id];
        System.debug('Doc list propert '+doclist);
        system.debug('TEST property '+doclist[0].Application__r.Property_State__c);
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        par.genesis__Application__c=app.id;
        par.genesis__Party_Type__c='Co-Borrower';
        insert par;
        
       EsignApplicantsMapping.CreateApplicantSign(docobj,app.id);
        EsignApplicantsMapping.ApplicantCreating(doclist);
    }
}