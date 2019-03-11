/*
* Description : Test_RenewalIdentifierBatch_Scheduler
* Author      : Kishan Panchal
*/
@isTest
public class Test_RenewalIdentifierBatch_Scheduler {
    @isTest public static  void testschedule() {
        id recTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.Application_Stage__c = '>6 months due for renewal';
        genApp.Active__c = true;
        genApp.RecordTypeId = recTypeId;
        genApp.Renewal_Due_Date__c = Date.newInstance(2018,11,27);
        insert genApp;
        System.debug(genApp.Renewal_Due_Date__c);
        Test.StartTest();
        RenewalIdentifierBatch_Scheduler testsche = new RenewalIdentifierBatch_Scheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, testsche);
        Test.stopTest();
    }
}