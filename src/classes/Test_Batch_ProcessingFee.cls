@isTest
public class Test_Batch_ProcessingFee {
    
    @isTest
    public static void method1(){
        
        List<genesis__Applications__c> lstapplication= new List<genesis__Applications__c>();
       
        genesis__Applications__c newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
        //   newApp.genesis__Account__c =acc.id;
        //  newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = 'Disbursement Rejected';
        //newApp.Application_Stage__c = 'Sanction complete- Final Sanction';
        insert newApp;
        
        
        genesis__Applications__c newApp2 = new genesis__Applications__c();
        newApp2.genesis__Loan_Amount__c = 10000;
        newApp2.genesis__Term__c =12;
        newApp2.genesis__Amortization_Term__c = 12;
        newApp2.genesis__Interest_Rate__c = 14;
        newApp2.genesis__Payment_Frequency__c = 'Monthly';
        //   newApp.genesis__Account__c =acc.id;
        //  newApp.genesis__CL_Product__c = product.id;
        newApp2.Sub_Stage__c = 'Disbursement Rejected';
        //newApp.Application_Stage__c = 'Sanction complete- Final Sanction';
        
        insert newApp2;
        
        lstapplication.add(newApp);
        lstapplication.add(newApp2);
        
        Test.startTest();
        Batch_ProcessingFee obj = new Batch_ProcessingFee();
        Database.QueryLocator ql = obj.start(null);
        obj.execute(null,lstapplication);
        obj.Finish(null);
        
        Test.stopTest();
    }
    
}