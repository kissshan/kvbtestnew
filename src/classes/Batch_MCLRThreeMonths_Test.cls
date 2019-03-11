@isTest
public class Batch_MCLRThreeMonths_Test {
@isTest
    public static void method1(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Industry_Type__c='Manufacturing';
        insert acc;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Application_Stage__c='Adhoc Application close';
        genApp.Overall_Exposure__c=2600000;
        genApp.Loan_Account_Number__c='1234';
        genApp.MCLR_Type__c='Three Months';
        insert genApp;  
           
        Test.startTest();
        Batch_MCLRThreeMonths obj = new Batch_MCLRThreeMonths();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
}