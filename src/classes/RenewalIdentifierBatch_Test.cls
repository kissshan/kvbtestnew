/*
 * author  :  uday kali
 * coverage : 100%
 */ 
@isTest
public class RenewalIdentifierBatch_Test {
    @isTest
    public static void testMethod1(){
         Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Pan_Number__c='Doapk2819k';
            acc.BillingCity='Bangalore';
            acc.BillingState='Karnataka';
            acc.BillingPostalCode='86987';
            insert acc;
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            genApp.Application_Stage__c='>6 months due for renewal';
            genApp.CommercialPR_Stage__c='Not Initiated';
            genApp.Renewal_Due_Date__c = Date.newInstance(2018,11,27);
            genApp.Active__c=true;
            genApp.genesis__Loan_Amount__c=100000;
            genApp.RecordTypeId=RecordTypeIdgenApp;
            insert genApp;
        test.startTest();
        RenewalIdentifierBatch rib=new RenewalIdentifierBatch('');
        Database.executeBatch(rib);
        test.stopTest();
    }
     @isTest
    public static void testMethod2(){
         Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Pan_Number__c='Doapk2819k';
            acc.BillingCity='Bangalore';
            acc.BillingState='Karnataka';
            acc.BillingPostalCode='86987';
            insert acc;
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c ='>6 months due for renewal';
        genApp.CommercialPR_Stage__c='Not Initiated';
        genApp.Renewal_Due_Date__c = system.today()+60;
        genApp.Active__c=true;
        genApp.genesis__Loan_Amount__c=100000;
        //genApp.Execute_batch_in_days__c=60;
        insert genApp;
           system.debug('genApp==++'+genApp.recordtype.developerName);
        test.startTest();
        RenewalIdentifierBatch rib=new RenewalIdentifierBatch(' RecordType.developerName = \'SME_Renewal\' AND Application_Stage__c = \'>6 months due for renewal\' AND Execute_batch_in_days__c = 60 AND Active__c = true');
        Database.executeBatch(rib);
        test.stopTest();
    }
}