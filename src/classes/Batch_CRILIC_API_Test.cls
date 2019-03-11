/*
* Description : Batch_CRILIC_API_Test
* Author       : Yadagiri
* Edited By: vignesh
*/
@isTest
public class Batch_CRILIC_API_Test {
@isTest
    public static void method1(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Industry_Type__c='Manufacturing';
        acc.Crilc_Info__c=null;
        acc.CRILC_TxnId__c='Test Crilc';
        insert acc;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Application_Stage__c='Adhoc Application close';
        genApp.Overall_Exposure__c=2600000;
        //genApp.CreatedDate = datetime.newInstance(2018, 7, 21, 13, 30, 0);
        insert genApp;
        
        Test.startTest();
        Batch_CRILIC_API obj = new Batch_CRILIC_API();
        DataBase.executeBatch(obj); 
       // obj.excute(,new List<genesis__Applications__c>{genApp});
        Test.stopTest();
    }
}