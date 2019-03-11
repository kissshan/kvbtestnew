//modified by prashant singh
//date:-05/11/2018
//code coverage:-83%
@isTest
public class Test_GmraCal {
    @isTest
    public static void method1(){
    /*    genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        Account acc=new Account(Name='TestName');
        acc.Net_Monthly_Income__c=50000;
        insert acc;
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account newPersonAccount = new Account();
        
        // for person accounts we can not update the Name field instead we have to update the    FirstName and LastName individually
        
        newPersonAccount.FirstName = 'Fred';
        newPersonAccount.LastName = 'Smith';
        newPersonAccount.RecordType = personAccountRecordType;
        newPersonAccount.PersonBirthdate= Date.newInstance(2000, 12, 9); 
        insert newPersonAccount;
        
        app.genesis__Interest_Rate__c=10;
        app.genesis__Term__c=5;
        app.genesis__Account__c=acc.id;
        update app;
        
        genesis__Application_Parties__c parapp=new genesis__Application_Parties__c(genesis__Application__c=app.Id,genesis__Party_Account_Name__c=acc.id);
        insert parapp;
        
        GmraCal.calGMRA(app.Id) ;*/
            Date birthday=system.today();
        Account  acc = new Account();
        Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      	 acc.LastName='HP Agencies';
        acc.Branch_Code__c='CHENNAI';
        acc.CBS_Customer_ID__c='1210009';
        acc.Name_Of_Director_Related_To__c='Mahesh';
        acc.Relationship__c='Father in law';
        acc.Bank_name__c='KVB';
        acc.RecordTypeId=accRecordType;
        acc.PersonBirthdate=date.parse('07/06/1991');
            insert acc;
        
          
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='Personal Details Captured';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=45.6;
            genApp.RecordTypeId=genAppRecordType;
            genApp.genesis__Interest_Rate__c=9;
            genApp.genesis__Term__c=8;
        	genApp.Sanctioned_Tenure__c=230;
        	genApp.EMI_Max__c=1000;
            insert genApp;
           
            genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
            genAppPart.genesis__Party_Account_Name__c =acc.Id;
            genAppPart.genesis__Party_Type__c='Co-Borrower';
            genAppPart.Active__c=True;
            genAppPart.Net_Monthly_Income__c=300000;
            genAppPart.Employment_Types__c='Salaried';
            genAppPart.Company__c=false;
            genAppPart.genesis__Application__c=genApp.id;
            genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
        	genAppPart.Financial_Applicant__c=true;
        genAppPart.Eligible_EMI1__c=20190;
        genAppPart.Approve_Elgibile_EMI__c=1345.2;
            insert genAppPart;
            
            GMRA_Master__c gmobj=new GMRA_Master__c();
            gmobj.Age__c=27;
            gmobj.Bank__c='SBI';
            gmobj.Max_Interest__c=10;
            gmobj.Max_Term__c=10;
            gmobj.Min_Term__c=6;
            gmobj.Min_Interest__c=6;
            gmobj.Name='testgmra';
            insert gmobj;
             
            GMRA__c gg=new GMRA__c();
            gg.Amount__c=10000;
            gg.Application__c=genApp.id;
            gg.Name='SBI: 100% Prim Appl.';
            insert gg;
           // genesis__Applications__c appnew =[select id from genesis__Applications__c where id =:genApp.id];
           
            GmraCal.GmraCalculations(genApp.id);
GmraCal.Gmra1(genApp.id,120000000.2,12000);
    }
}