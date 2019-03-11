/*
* Name    : DigioDocID_EsignPL_Test
* Company  : ET Marlabs
* Purpose   : Test class for DigioDocID_EsignPL class
* Author  : Yadagiri
* last Modified By : 
*/
@isTest
public class DigioDocID_EsignPL_Test {
    public static testmethod void testMethod1() {
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        insert genApp;
        
        genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,acc.id,'Partner','Pending');
        insert genAppPart;
        
        Test.startTest();
        DigioDocID_EsignPL.DocumentIDGeneration(genApp.Id, 'PL Sanction Letter',15,'JVBERuA4NDZmZDk4Kc');
        Test.stopTest();
    }
    public static testmethod void testMethod2() {
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        insert genApp;
        
        genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,acc.id,'Partner','Pending');
        insert genAppPart;
        
        Test.startTest();
        DigioDocID_EsignPL.DocumentIDGeneration(genApp.Id,'PL Loan Agreement',15,'JVBERuA4NDZmZDk4Kc');
        Test.stopTest();
    }
}