/*
* Description : Perfios_New_SME_Response_Handler_Test
* Author       : Yadagiri
* edited by    : Vignesh
*/
@isTest
public class Perfios_New_SME_Response_Handler_Test {
     @isTest
    public static void method1(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            insert genApp;
            
            Perfios__c perfio = SME_TestUtil.createperfios(genApp.Id,acc.Id);
            insert perfio;

            Operations_Detail__c opDetl= new Operations_Detail__c();
            opDetl.Account__c= acc.Id;
            opDetl.Fiscal_Type__c= 'YTD';
            opDetl.Fiscal_Year__c= '2018-19';
            insert opDetl;

            Operations_Detail__c opDetl1= new Operations_Detail__c();
            opDetl1.Account__c= acc.Id;
            opDetl1.Fiscal_Type__c= 'ACTUAL';
            opDetl1.Fiscal_Year__c= '2017-18';
            insert opDetl1;

            Perfios_New_SME_Response perfiRes= new Perfios_New_SME_Response();

            Perfios_New_SME_Response.cls_CustomerInfo custInfo= new Perfios_New_SME_Response.cls_CustomerInfo();
            custInfo.name= 'Vignesh';
            custInfo.address= 'Bengaluru';

            Perfios_New_SME_Response.cls_Total tot= new Perfios_New_SME_Response.cls_Total();
            tot.intPayDelay= '2';
            tot.totalDebit= '34562'; 
            tot.totalCredit= '32455';
            tot.debits= '23456';
            tot.Credits= '32567';
            tot.overdrawnInstances= '23445';
            tot.inwBounces= '3245';
            tot.cashDeposits= '3456';
            tot.totalCashWithdrawal= '32456';
            tot.totalCashDeposit= '34524';
            tot.cashWithdrawals= '34567';
            tot.totalInterestIncome= '23456';

            Perfios_New_SME_Response.cls_Average avg= new Perfios_New_SME_Response.cls_Average();
            avg.balAvg= '2345678';

            Perfios_New_SME_Response.cls_SummaryInfo summInfo= new Perfios_New_SME_Response.cls_SummaryInfo();
            summInfo.instName= 'instName';
            summInfo.accNo= '12338934';
            summInfo.total= tot;
            summInfo.highestNonTechnicalBounce= '4356782';
            summInfo.lowestNonTechnicalBounce= '345672';
            summInfo.average= avg;

            perfiRes.customerInfo= custInfo;
            perfiRes.summaryInfo= summInfo;
            Test.startTest();
            Perfios_New_SME_Response_Handler.getPerfiosData(perfiRes,acc.Id);
            Test.stopTest();
        } 
    }
}