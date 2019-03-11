/*
* Description : Batch_ListMatchingStatus_LAP_Test
* Author       : Yadagiri
*/
@isTest
public class Batch_ListMatchingStatus_LAP_Test {
    @isTest
    public static void method1(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Jocata_List_Match__c='Yes';
        acc.Jocata_TxnId__c='Test Jocata';
        insert acc;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Application_Stage__c='Terms and Conditions Accepted';
        insert genApp;
        
        genesis__Application_Parties__c  genAppPart= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        insert genAppPart;
        
        Test.startTest();
        Batch_ListMatchingStatus_LAP obj = new Batch_ListMatchingStatus_LAP('');
        DataBase.executeBatch(obj); 
        
        Database.QueryLocator ql = obj.start(null);
        obj.execute(null,new List<genesis__Application_Parties__c>{genAppPart});
        Test.stopTest();
    }
}