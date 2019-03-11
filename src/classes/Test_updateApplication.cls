@isTest

public class Test_updateApplication {

    
    static genesis__Applications__c  newApp;
    static Account acc;
    
    Public static void CreateApp(){
        newApp=TestUtility.intialSetUp(Constants.HL_PRODUCT_CODE, true);
    }
    
    public static testmethod void method1(){
        CreateApp();
        newapp.Loan_Purpose__c='Construction on own land';
        update newapp;
    }
}