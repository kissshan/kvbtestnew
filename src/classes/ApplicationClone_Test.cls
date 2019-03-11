/*
* Description : ApplicationClone_Test
* Author       : Yadagiri
*edited By: vignesh
*/
@isTest(seeAllData=false)
public class ApplicationClone_Test {
    
    public static genesis__Application_Parties__c genAppParties;
    public static Facility__c faclty ;
    public static genesis__Applications__c genApp;
    
    public static void init(){
        Account acc = new Account();
        acc.name='TestName';
        insert acc;
        
        Id stExam = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        
        genApp  = new genesis__Applications__c();
        genApp.Application_Stage__c= 'Enhancement- Application created';
        
        insert genApp;
        genAppParties = new genesis__Application_Parties__c();
        	genAppParties.Key_Contact__c = acc.id;
            genAppParties.genesis__Party_Account_Name__c=acc.id;
            genAppParties.genesis__Party_Type__c = Constants.Co_Borrower;
            genAppParties.Active__c = true;
        insert genAppParties;
        
        faclty = new Facility__c();
        faclty.RecordtypeId=stExam;
        faclty.Total_Loan_Amount__c=1000;
        faclty.Balance_Outstandings__c=12000;
        faclty.Over_Due__c=200;
        faclty.MCLR_Rate__c=3;
        faclty.Existing_Processing_Charge__c=200;
        faclty.Interest_Type__c='Commission';
        faclty.Approved_Margin__c=3.2;
        faclty.Loan_Purpose__c='To develop my Business';
        //faclty.Existing_Margin__c=2.3;
        faclty.Existing_Margin_Receivables__c=2.4;
        faclty.Existing_Margin_Stock_Manufacturing__c=3.4;
        faclty.Existing_Margin_Stock_Trading__c=4.5;
        faclty.Amount_Disbursed__c=2300;
        faclty.Amount_Net_Disbursed__c=245;
        faclty.Amount_Yet_disbursed__c=34.5;
        faclty.Variance__c=34;
        faclty.Final_Authority_Name__c='Test Authority';
        faclty.Processing_Charge__c=234;
        faclty.Existing_Rate__c=456;
        faclty.Existing_Limit__c=426;
        faclty.Account_Number__c='KVB12345';
        insert faclty;
        
    }
    
    @isTest
    public static void method1(){
        
        init();
        
        Test.startTest();
        ApplicationClone.partiesCreation(genAppParties.Id,new List<genesis__Application_Parties__c>{genAppParties});
        ApplicationClone.facilityCreation(new List<Facility__c>{faclty},genApp.Id);
        ApplicationClone.getApplicationStage('SME Enhancement');
        ApplicationClone.getRecordType('SME_Adhoc');
        ApplicationClone.applicationCreation(genApp,'SME NEW Loan');
        
        ApplicationClone.cloneApplication(genApp.Id,'SME_Adhoc');
        Test.stopTest();  
    }
    @isTest
    public static void method2(){
        
        init();
        
        Test.startTest();
        ApplicationClone.partiesCreation(genAppParties.Id,new List<genesis__Application_Parties__c>{genAppParties});
        ApplicationClone.facilityCreation(new List<Facility__c>{faclty},genApp.Id);
        ApplicationClone.getApplicationStage('SME Enhancement');
        ApplicationClone.getRecordType('SME_Adhoc');
        ApplicationClone.applicationCreation(genApp,'SME NEW Loan');
        
        ApplicationClone.cloneApplication(genApp.Id,'SME_Adhoc');
        Test.stopTest();
        
        
    }
    
}