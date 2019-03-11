@isTest
public class Test_Application_AssessmentCtrl {
    
    
    @isTest
    public static void methodCalculateFLC_ILCAssessment(){
        genesis__Applications__c genApp = Testutility.intialSetUp('Home Loan', true);
        //genApp.Name = 'TestGenApp';
        genApp.Lead_Time__c = 10;
        genApp.Usance_Period__c = 2;
        genApp.Renewal_Due_Date__c = Date.today();
        UPDATE genApp;
        system.debug('---genApp'+genApp);
        Account acc = new Account(name='TestAppAsses');
        INSERT acc;
       
        PageReference pageRef = Page.Application_AssessmentVf; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(genApp.Id));
        Test.setCurrentPage(pageRef);
        System.debug('pageRef===='+pageRef);
        
        M68_Balance_Sheet_Analysis__c m68BalSheet = new M68_Balance_Sheet_Analysis__c();
        m68BalSheet.Fiscal_Year__c = '2018-20';
        m68BalSheet.Net_sales__c = 100;
        m68BalSheet.Purchases__c = 500;
        m68BalSheet.Account__c = genApp.genesis__Account__c;
        m68BalSheet.Financial_type__c = 'Projected';
        INSERT m68BalSheet;
        
        M68_Balance_Sheet_Analysis__c m68BalSheet1 = new M68_Balance_Sheet_Analysis__c();
        m68BalSheet1.Fiscal_Year__c = '2018-19';
        m68BalSheet1.Net_sales__c = 100;
        m68BalSheet1.Purchases__c = 500;
        m68BalSheet1.Account__c = genApp.genesis__Account__c;
        m68BalSheet1.Financial_type__c = 'Estimated';
        INSERT m68BalSheet1;
        
        M68_Balance_Sheet_Analysis__c m68BalSheet2 = new M68_Balance_Sheet_Analysis__c();
        m68BalSheet2.Fiscal_Year__c = '2017-18';
        m68BalSheet2.Net_sales__c = 100;
        m68BalSheet2.Purchases__c = 500;
        m68BalSheet2.Account__c = genApp.genesis__Account__c;
        m68BalSheet2.Financial_type__c = 'Actual';
        INSERT m68BalSheet2;
        
        System.debug('m68BalSheet!!!!'+m68BalSheet);
        System.debug('m68BalSheet1!!!!'+m68BalSheet1);
        System.debug('m68BalSheet2!!!!'+m68BalSheet2);
        
        Id devRecordTypeId = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        System.debug('devRecordTypeId@@@'+devRecordTypeId);
        
        clcommon__CL_Product__c clProd = new clcommon__CL_Product__c();
        clProd.clcommon__Product_Name__c = 'Home Loan12';
        clProd.Facility_Category__c = 'ILC';
        clProd.RecordTypeId = devRecordTypeId;
        INSERT clProd;
        
        Id devRecordTypeId1 = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clcommon__CL_Product__c clProd1 = new clcommon__CL_Product__c();
        clProd1.clcommon__Product_Name__c = 'Home Loan12';
        clProd1.Facility_Category__c = 'PCFC';
        clProd1.RecordTypeId = devRecordTypeId1;
        INSERT clProd1;
        
        genApp.genesis__CL_Product__c = clProd.id;
        update genApp;

        Facility__c fac = new Facility__c();
        fac.Existing_Limit__c = 1000;
        fac.CL_Product__c = clProd.Id;
        fac.Application__c = genApp.Id;
        INSERT fac;
        
        genApp.genesis__CL_Product__c = clProd1.id;
        update genApp;

        Facility__c fac1 = new Facility__c();
        fac1.Existing_Limit__c = 2000;
        fac1.CL_Product__c = clProd1.Id;
        fac1.Application__c = genApp.Id;
        INSERT fac1;
        
        test.startTest();
        Application_AssessmentCtrl appAssessment = new Application_AssessmentCtrl();
        appAssessment.calculateFLC_ILCAssessment();
        test.stopTest();
    }
    
}