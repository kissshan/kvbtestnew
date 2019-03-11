@isTest
public class Test_PerfiosErrorLog_MW {
    
    @isTest
    public static void method1(){
        
        Account acc = new Account(firstName='Priti',LastName='Gupta');
        acc.CBS_Customer_ID__c = 'Str1234';
        INSERT acc;
        
        genesis__Applications__c genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Application_Stage__c = 'Perfios error';
        genApp.genesis__Account__c = acc.Id;
        UPDATE genApp;
        
        Perfios__c per = new Perfios__c();
        per.Applicant_Name__c = acc.Id;
        INSERT per;
        
        Perfios_Error__c perError = new Perfios_Error__c();
        perError.Perfios__c = per.Id;
        perError.Transaction_Id__c = 'Str123';
        INSERT perError;
        
            
        Test.startTest();
        PerfiosErrorLog_MW.getErrorLog();
        Test.stopTest();       
    }
    
}