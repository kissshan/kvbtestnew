/*
* Description : ApplicationTriggerHandler_Test
* Author       : Yadagiri
*/
//modified by prashant singh--on 30-11-2018
@isTest
public class NMICalculations_Test {
    @isTest
    public static void method1(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
			acc.Employment_Type__c='Agriculturist'; 
            acc.Financial_Applicant__c=true;
            acc.Salary_Credited_2__c=10000;
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.NMI_Approved__c=455.44;
            genApp.RecordTypeId=genAppRecordType;
            insert genApp;
            
            
            genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
            genAppPart.Active__c=True;
            genAppPart.Financial_Applicant__c=true;
            genAppPart.Agriculture2__c=34.5;
            genAppPart.Net_Monthly_Income__c=40000.00;
            genAppPart.genesis__Party_Type__c='Co-Borrower';
            genAppPart.Average_Balances_6_months__c=454.44;
            genAppPart.Total_ChequeECS_bounces__c=2;
            genAppPart.KVB_EMI__c=23.0;
            genAppPart.Perfios_Captured__c=true;
            genAppPart.NMI_as_per_26AS__c=23;
            insert genAppPart;
            
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            
            Test.startTest();
            NMICalculations.Calculations(genApp.Id);
            NMICalculations.CallNMI(new List<genesis__Applications__c>{genApp},genAppOldMap);
            NMICalculations.NMICal1(genApp,'Claimed');
            Test.stopTest();
            
        }
    }
    
}