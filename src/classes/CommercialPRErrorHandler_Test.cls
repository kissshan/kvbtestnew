/*
 * Purpose: Test class for CommercialPRErrorHandler class
 * Author :Yadagiri
*/
@isTest 
public class CommercialPRErrorHandler_Test {
    public static testmethod void testMethod1() {
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Active__c = true;
        insert genApp;
        
        TU_Error__c tuError= new TU_Error__c();
        tuError.Account__c=acc.Id;
         insert tuError;
         Test.startTest();
        CommercialPRErrorHandler.getCommercialPRError(new CommercialPRErrorService());
        Test.stopTest();
    }
}