/*
* Description : Test_Batch_Perfios_SME_New_Loan
* Author      : Kishan Panchal
* modified    : uday kali----->85% 
*/
@isTest
public class Test_Batch_Perfios_SME_New_Loan {
@isTest
    public static void testMethod1(){
        Account acc = TestUtility_SME_New_Loan.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB','12345');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Service_Type_Name__c='CollateralDlink';
        insert genApp;
        //uday started
        Id perfioRecordType = Schema.SObjectType.Perfios__c.getRecordTypeInfosByName().get('SME New Loan Perfios').getRecordTypeId();
        system.debug('perfioRecordType==='+perfioRecordType);
        Perfios__c perfio= SME_TestUtil.createperfios(genApp.Id,acc.Id);
        perfio.RecordTypeId=perfioRecordType;
        perfio.Perfios_Status__c='Initiated';
        perfio.Application__c = genApp.id;
        perfio.Transaction_Id__c = acc.Jocata_TxnId__c;
        insert perfio;
        //string status='Initiated';
        //string rectype='SME_New_Loan_Perfios';
        Test.startTest();
        Batch_Perfios_SME_New_Loan ob=new Batch_Perfios_SME_New_Loan('Perfios_Status__c IN :status AND RecordType.DeveloperName =:RecordTypeName AND Transaction_Id__c != null');
        //ob.setAppId= new set<Id>{genApp.Id};
       // List<genesis__Applications__c> listOfApplication= new List<genesis__Applications__c>{genApp};
        DataBase.executeBatch(ob);
       
        Test.stopTest();
        //end
    }
}