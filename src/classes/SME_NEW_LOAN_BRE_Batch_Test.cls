@isTest
public class SME_NEW_LOAN_BRE_Batch_Test {
    @isTest
    public static void method1(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Industry_Type__c='Manufacturing';
        insert acc;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Application_Stage__c='New loans- Application submitted';
        genApp.BRE_Done__c= false;
        genApp.Overall_Exposure__c = 2300000;
        genApp.Active__c=true;
        genApp.List_Matching_Stage__c='Completed';
        genApp.CommercialPR_Stage__c='Completed';
        genApp.Loan_Account_Number__c='1234';
        genApp.MCLR_Type__c='Three Months';
        insert genApp;  
        
        genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        genAppPart.Active__c=True;
        insert genAppPart;
        
        //Completed,Completed,true,SME_NEW_Loan,New loans- Application submitted,true,2300000
        Test.startTest();
        SME_NEW_LOAN_BRE_Batch obj = new SME_NEW_LOAN_BRE_Batch('');
        DataBase.executeBatch(obj); 
        //obj.execute(null,new list<genesis__Applications__c>{genApp});
        //obj.Finish(null);
        Test.stopTest();
    }
    
}