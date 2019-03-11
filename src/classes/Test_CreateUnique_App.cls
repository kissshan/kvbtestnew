@isTest
public class Test_CreateUnique_App {
    @isTest
    public static void method1(){
        
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acct=new Account(LastName='testName');
        acct.RecordTypeID = RecordTypeIdclPerson;
        acct.Aadhaar_Number__pc = '835080582';
		insert acct;

		ints__TransUnion_Credit_Report__c repobj=new ints__TransUnion_Credit_Report__c(Account__c=acct.id);
		insert repobj;

		TU_Account__c tuobj=new TU_Account__c(TU_Credit_Report__c=repobj.id,Account_Type__c='Personal Loan',High_Credit_Or_Sanctioned_Amount__c = '242423');
		insert tuobj;
        

        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='Test');
        insert product;
        Account acc = new Account(firstName='Nama',LastName='Gopal', Employment_Type__c = 'Salaried');
        insert acc;
        Account acc1 = new Account(firstName='Venu1',LastName='Gopal1', Employment_Type__c = 'Self-Employed Businessman');
        insert acc1;
        
        genesis__Application_Parties__c party =new genesis__Application_Parties__c();
        
        party.Key_Contact__c = acc.id;
        party.genesis__Party_Account_Name__c=acct.id;
        party.genesis__Party_Type__c = Constants.PRIMARY_APP;
        party.Active__c = true;
        insert party;
        
        genesis__Application_Parties__c party1 =new genesis__Application_Parties__c();
        
        party1.Key_Contact__c = acc1.id;
        party1.genesis__Party_Account_Name__c=acct.id;
        party1.genesis__Party_Type__c = Constants.Co_Borrower;
        party1.Active__c = true;
        insert party1;
        
        Id RecordTypeIdclProd = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();
        genesis__Applications__c newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Loan_Number__c = 'TS123'; 
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
        newApp.genesis__Account__c =acct.id;
        newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = Constants.APPLICATION_STATGE_TNC_ACCEPTED;
        newApp.Perfios_Captured__c=false;
        newApp.RecordTypeID = RecordTypeIdclProd;
        //newApp.Application_Stage__c = 'Sanction complete- Final Sanction';
        
        test.startTest();
        insert newApp;
        CreateUnique_App.checkuniqApp('923889119182');
        CreateUnique_App.KvbEmiCalculation(acct.id);
        test.stopTest();
    }

     @isTest
    public static void method2(){
        
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acct=new Account(LastName='testName');
        acct.RecordTypeID = RecordTypeIdclPerson;
        acct.Aadhaar_Number__pc = '835080582';
		insert acct;

		ints__TransUnion_Credit_Report__c repobj=new ints__TransUnion_Credit_Report__c(Account__c=acct.id);
		insert repobj;
		
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='Test');
        insert product;
        //Account acc = new Account(firstName='Nama',LastName='Gopal', Employment_Type__c = 'Salaried');
        //insert acc;
        Account acc1 = new Account(firstName='Venu1',LastName='Gopal1', Employment_Type__c = 'Self-Employed Businessman');
        insert acc1;
        
        /*genesis__Application_Parties__c party =new genesis__Application_Parties__c();
        
        party.Key_Contact__c = acc.id;
        party.genesis__Party_Account_Name__c=acct.id;
        party.genesis__Party_Type__c = Constants.PRIMARY_APP;
        party.Active__c = true;
        insert party;
        */
        genesis__Application_Parties__c party1 =new genesis__Application_Parties__c();
        
        party1.Key_Contact__c = acc1.id;
        party1.genesis__Party_Account_Name__c=acct.id;
        party1.genesis__Party_Type__c = Constants.Co_Borrower;
        party1.Active__c = true;
        insert party1;
        
        Id RecordTypeIdclProd = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();
        genesis__Applications__c newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        //.genesis__Amortization_Term__c = 12;
        //newApp.genesis__Loan_Number__c = 'TS123'; 
        //newApp.genesis__Interest_Rate__c = 15;
        //newApp.genesis__Payment_Frequency__c = 'Monthly';
        newApp.genesis__Account__c =acct.id;
        newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = Constants.APPLICATION_STATGE_TNC_ACCEPTED;
        //newApp.Perfios_Captured__c=false;
        newApp.RecordTypeID = RecordTypeIdclProd;
        //newApp.Application_Stage__c = 'Sanction complete- Final Sanction';
        
        test.startTest();
        insert newApp;
        //CreateUnique_App.checkuniqApp('923889119182');
        CreateUnique_App.KvbEmiCalculation(acct.id);
        test.stopTest();
    }
}