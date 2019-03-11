@isTest
public class Test_updateParty {
@isTest
    public static void method1(){
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
            
        genesis__Applications__c app=TestUtility.intialSetUp('Test',true);
        app.RecordTypeId=genAppRecordType;
        update app;
        genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
        parobj.Income_Computation_From__c='Bank Statement';
        parobj.genesis__Application__c=app.id;
        insert parobj;
        parobj.Active__c=true;
        parobj.Salary_Credited_4__c=15000;
        parobj.Employment_Types__c='Salaried';
        parobj.Income_Computation_From__c='ITR';
        parobj.Net_Monthly_Income__c=89900;
        update parobj;
    }
    @isTest
    public static void method2(){
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
            
        genesis__Applications__c app=TestUtility.intialSetUp('Test',true);
        app.RecordTypeId=genAppRecordType;
        update app;
        genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
        parobj.Income_Computation_From__c='Bank Statement';
        parobj.genesis__Application__c=app.id;
        insert parobj;
        parobj.Active__c=true;
        parobj.Salary_Credited_4__c=15000;
        parobj.Employment_Types__c='Salaried';
        parobj.Net_Monthly_Income__c=89900;
        update parobj;
    }
}