/*
* Description : AccountTriggerHandler_Test
* Author       : Yadagiri
*/
@isTest
public class AccountTriggerHandler_Test {
     @isTest
    public static void method1(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Is_KVB_Director__c=True;
        acc.Net_Monthly_Income__c=34.4;
        acc.Previous_Constitution__c='LLP';
        acc.Constitution__c='LLP';
        acc.Income_Computation_From__c='Bank Statement';
        acc.Gross_Income_3__c=345.4;
        acc.Salary_Credited_1__c=22.33;
        acc.Employment_Type__c='Salaried';
        insert acc;
        
        Map<Id,Account> accountNewMap = new Map<Id,Account>();
        accountNewMap.put(acc.Id, acc);
        
        Map<Id,Account> accountOldMap = new Map<Id,Account>();
        accountOldMap.put(acc.Id, acc);        
        
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Term Loan').getRecordTypeId();

        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        insert genApp;
        list<RecordType> rList = [Select id From RecordType Where sObjectType = 'genesis__Applications__c' and RecordType.DeveloperName= 'SME_Renewal'];
        //Id rengenAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();

        genesis__Applications__c renewelgenApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        renewelgenApp.RecordTypeId=rList[0].Id;
        insert renewelgenApp;
        
        clcommon__Collateral_Type__c colltype= SME_TestUtil.createCollType('Test Collateral');
        insert colltype;
        
        Id prodRectype = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();

        clcommon__CL_Product__c clProducts=SME_TestUtil.createclproduct('Test product','KVB11','Funded');
        clProducts.Active__c=true;
        clProducts.RecordtypeId=prodRectype;
        clProducts.clcommon__Primary_Collateral_Type__c=colltype.Id;
        insert clProducts; 
        
        Facility__c facil= SME_TestUtil.createFacility(genApp.Id,clProducts.Id,'KVB2344',32423.2);
        facil.Existing_Limit__c=3432.22;
        facil.Existing_Limit__c=2323.2;
        facil.Amount_Yet_disbursed__c=23.3;
        facil.Existing_Rate__c=3.2;
        facil.Balance_Outstandings__c=4555.44;
        facil.RecordTypeId=Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        insert facil;
        
        Facility__c renefacil = new Facility__c();
        renefacil.Account_Number__c='KVB2344';
        renefacil.Balance_Outstandings__c=34343.3;
        renefacil.Application__c=renewelgenApp.Id;
        renefacil.CL_Product__c= clProducts.Id; 
        renefacil.Balance_Outstandings__c=4555.44;
        insert renefacil;
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        
        Credit_Underwriting__c creditunderwriting = new Credit_Underwriting__c();
        creditunderwriting.Application__c=genApp.Id;
        creditunderwriting.Threshold_breached__c= false;
        creditunderwriting.Variable_type__c='Sales trend-3 yrs(CAGR%)';
        insert creditunderwriting;
        
        Test.startTest();
        AccountTriggerHandler acctriggerhandlertest =new AccountTriggerHandler();
        acctriggerhandlertest.beforeUpdate(accountNewMap,accountOldMap,new List<Account>{acc});
        acctriggerhandlertest.updateITRAndBankStatement(new List<Account>{acc},accountOldMap);
        AccountTriggerHandler.limitCalculation(genApp);
        AccountTriggerHandler.loamAmountCalculation(genApp);
        AccountTriggerHandler.exposureAmountCalculation(genApp);
        AccountTriggerHandler.checkFinancialFlagStatus(genApp.Id);
        AccountTriggerHandler.getInstance();
        acctriggerhandlertest.updateApproveNMI(new List<Account>{acc},accountOldMap);
        Test.stopTest();
        
    } 
    @isTest
    public static void method2(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Is_KVB_Director__c=True;
        acc.Net_Monthly_Income__c=34.4;
        acc.Previous_Constitution__c='ITR';
        acc.Constitution__c='LLP';
        acc.Income_Computation_From__c='ITR';
        acc.Gross_Income_3__c=345.4;
        acc.Salary_Credited_1__c=22.33;
        acc.Employment_Type__c='Self-Employed Businessman';
        insert acc;
        
        Map<Id,Account> accountOldMap = new Map<Id,Account>();
        accountOldMap.put(acc.Id, acc);  
         Test.startTest();
        AccountTriggerHandler acctriggerhandlertest =new AccountTriggerHandler();
        acctriggerhandlertest.updateApproveNMI(new List<Account>{acc},accountOldMap);
        Test.StopTest();
    }
    
}