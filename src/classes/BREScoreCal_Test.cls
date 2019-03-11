@isTest
public class BREScoreCal_Test {
    @isTest
    public static void method1(){
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=true;
        //cs.Other fiels values
        insert cs;
        Utility.runApplicationTrigger();
        ApplicationTriggerHandler.IsFirstRun=true;
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='FI Approved';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=45.6;
            genApp.RecordTypeId=genAppRecordType;
            insert genApp;
            
            genApp.Sub_Stage__c='Loan Requirement Captured';
            genApp.Loan_Purpose__c='Repair or Renovation of House';
            genApp.Flat_No__c='T-42';
           
           /* 
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            BREScoreCal.breCal(new List<genesis__Applications__c>{gpps},genAppOldMap);*/
        }
    }
    
}