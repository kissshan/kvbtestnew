//uday---->82%
@isTest
public class Test_SME_BRE_Batch {
    @isTest
    public static void testMethod1(){
        Account acc = TestUtility_SME_New_Loan.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB','12345');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS','SME Renewal');
        //genApp.Service_Type_Name__c='CollateralDlink';
        genApp.Application_Stage__c='Identified for renewal';
        genApp.Qualitative_input_done__c=true;
        genApp.CommercialPR_Stage__c='Completed';
        genApp.List_Matching_Stage__c='Completed';
        genApp.Active__c=true;
        genApp.Renewal_Due_Date__c=System.today()+5;
        insert genApp;
        clcommon__CL_Product__c clPrd = SME_TestUtil.createclproduct('KVB Product','KVB77','Funded');
        insert clprd;
        genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.id,'Partner','Pending');
        insert prty;
        facility__C faci=SME_TestUtil.createFacility(genApp.Id,clprd.Id,'1234567',34568923);
        insert faci;
          
        test.startTest();
            SME_BRE_Batch sbb=new SME_BRE_Batch(' WHERE Qualitative_input_done__c=true AND CommercialPR_Stage__c = \'Completed\' AND List_Matching_Stage__c = \'Completed\' AND Active__c = true AND ((RecordType.DeveloperName = \'SME_Renewal\' AND Application_Stage__c = \'Identified for renewal\') OR (RecordType.DeveloperName = \'SME_Enhancement\' AND Application_Stage__c = \'Enhancement- Application submitted\' AND BRE_Done__c !=true) OR (RecordType.DeveloperName = \'SME_Exceeding\' AND Application_Stage__c = \'Exceeding- Application submitted\' AND BRE_Done__c !=true) OR (RecordType.DeveloperName = \'SME_AdHoc\' AND Application_Stage__c = \'Adhoc- Application submitted\' AND BRE_Done__c !=true) OR (RecordType.DeveloperName = \'SME_NEW_Loan\' AND Application_Stage__c = \'New loans- Application submitted\' AND BRE_Done__c !=true))');
            DataBase.executeBatch(sbb);
        test.stopTest();
    }
}