@isTest
public class Test_ApplicationService {
    public static genesis__Applications__c genApp;
    public static Account acc;
    
    @isTest
    public static void init (){
        genApp = TestUtility.intialSetUp('Smart Home Loan - 797', true);
        acc = new Account(name = 'Testname');
    }
 
    @isTest
    public static void methodCreateApplication(){
        init();
        clcommon__CL_Product__c cl_Prod = new clcommon__CL_Product__c(clcommon__Product_Name__c = 'Digital Home Loan - 777');
        insert cl_prod;
        KVB_Company_Details__c kvb_cd = new KVB_Company_Details__c(HomeLoanName__c = 'Digital Home Loan - 777');
        insert kvb_cd;
        ApplicationService.createApplication(acc.Id, 'Home Loan', 'test_sourced by', 'test_sourced by office');
    }
    
    @isTest
    public static void methodGetApplication(){
        Account acc =new Account(name = 'TestAccount');
        insert acc;
        genApp = TestUtility.intialSetUp('Smart Home Loan - 797', true);
        genApp.genesis__Account__c = acc.Id;
        update genApp;
        System.debug('acc.Id:::'+acc.Id);
        System.debug('genApp:::'+genApp);
        ApplicationService.getApplication(genApp.Id);
    }
}