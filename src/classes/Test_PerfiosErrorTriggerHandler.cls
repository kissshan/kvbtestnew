@isTest
public class Test_PerfiosErrorTriggerHandler {
    @isTest
    public static void methodUpdateApplicationStatus(){
        
        
        
        Account acc = new Account(firstName='@Priti',LastName='@Gupta');
        INSERT acc;
        
       
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.genesis__Applications__c; 
        Map<String,Schema.RecordTypeInfo> genAppRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('~~RecordTypeId'+devRecordTypeId);
        RecordType rt = [select id,Name from RecordType where SobjectType='genesis__Applications__c' and Name='Home Loan' Limit 1];
        System.debug('~~rt'+rt);
       
        
        Perfios__c per = new Perfios__c();
        per.Applicant_Name__c = acc.Id;
        INSERT per;
        
        Perfios_Error__c perErr1 = new Perfios_Error__c();
        perErr1.Perfios__c = per.Id;
        // perErr1.Error_message__c = 'Cannot open uploaded file';
        INSERT perErr1;
         
        genesis__Applications__c genApp = TestUtility.intialSetUp('Home Loan', true);
        Id devRecordTypeId1 = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        genApp.RecordTypeId = devRecordTypeId1;
        genApp.Application_Stage__c = 'Perfios error';
        genApp.genesis__Account__c = acc.Id;   
        //genApp.Record_Type_Name__c = rt.Name;
        UPDATE genApp;
        
        List<Perfios_Error__c> listPerErrortest = [Select id,Perfios__r.Applicant_Name__c from Perfios_Error__c];
        
        //system.debug(perErr1.Perfios__r.Applicant_Name__c);
        system.debug(listPerErrortest[0].Perfios__r.Applicant_Name__c);
        system.debug(genApp.genesis__Account__c);
        List<Perfios_Error__c> listPerError = new List<Perfios_Error__c>();
        listPerError.add(perErr1);
        Test.startTest();
        PerfiosErrorTriggerHandler pertriHand = new PerfiosErrorTriggerHandler();
        pertriHand.updateApplicationStatus(listPerErrortest);
        Test.stopTest();
    }
    
}