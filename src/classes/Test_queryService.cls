/*
* Name    : Test_queryService
* Company : ET Marlabs
* Purpose : Test class for queryService
* Author  : Subas
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
   V1.1    20-Sep-2018    Prashant      Added test method method1,method2,method3
   V1.2    28-Sep-2018    Braj          Modified some test method
*******************************************************************************************/
@isTest
public class Test_queryService {
    //public static genesis__Applications__c genApp;
    
    @testsetup
    public static void methodGetApplicants(){
        //initial test setup
        List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);

       /*genesis__Applications__c genApp = TestUtility.intialSetUp('Home Loan', true);
        System.debug('genapp:::'+genApp);
        
        Account acc = new Account(name='TestQuery');
        INSERT acc;
        
        genesis__Application_Parties__c genPar = new genesis__Application_Parties__c();
        genPar.genesis__Party_Account_Name__c = acc.Id;
        genPar.Key_Contact__c = acc.Id;
        genPar.genesis__Application__c = genApp.Id;
        genPar.genesis__Party_Type__c = Constants.Co_Borrower;
        genPar.Active__c=true;
        genPar.Company__c=false;
        INSERT genPar;*/

        //LoanProcess_Config__mdt loanProcess_Config = VL_Test_Utility.createLoanProcess_Config();
        //insert loanProcess_Config;

    }

    @isTest
    public static void method1()
    {
        genesis__Application_Parties__c genPar = [select id,genesis__Party_Type__c,genesis__Application__c,genesis__Party_Account_Name__c,Key_Contact__c,Active__c,Company__c from genesis__Application_Parties__c where genesis__Application__c!=null and genesis__Party_Account_Name__c!=null limit 1];
        genPar.Active__c = true;
        genPar.Company__c=false;
        update genPar;
        System.debug('genPar>>>'+genPar);
        
        genesis__Applications__c genApp =[select id,name,genesis__Account__c from genesis__Applications__c where Id=:genPar.genesis__Application__c];
        system.debug('genapp'+genApp);
        
        set<id> accountidSet=new set<id>();
        accountidSet.add(genApp.genesis__Account__c);

        DSA_Master__c dsa=new DSA_Master__c(Branch_Code__c='1213',Employ_Code__c='1705',Employ_Name__c='Braj Mohan',Branch_Name__c='CHENNAI - T.NAGAR',Role__c = 'DSA');
        insert dsa;

        Test.startTest();
        queryService.getApplication(genApp.Id);
        queryService.getDateFormatFromString('20/09/2018');
        queryService.accList(genApp.id);
        queryService.accListCust(new List<String>{genApp.genesis__Account__c});
        queryService.getApp(genApp.id);
        queryService.getNMIJunction(genApp.genesis__Account__c,genApp.id);
        queryService.getPartyRelType(genPar.genesis__Party_Type__c);
        queryService.getparties(genApp.id);
        queryService.acclistwithset(accountidSet);
        queryService.PartyListApp(genApp.id);
        queryService.getCLProd(genApp.id);
        queryService.getCompany(genApp.id);
        queryService.getAccCount(genApp.id);
        queryService.getCollateral(genApp.id);
        queryService.ApplicantList(genApp.id);
        queryService.getAccount(genApp.genesis__Account__c);
        queryService.getInsurance(genApp.id);
        queryService.getAllApplication();
        queryService.GetBankAccounts(genApp.genesis__Account__c,genApp.id);
        queryService.getappDocument(genApp.id);
        queryService.getCode('pp','1');
        queryService.getUserDetails('');
        queryService.getApplicants(genApp.Id);

        queryService.processingFee('VL');//V1.2
        queryService.PartieswithAcc(genApp.genesis__Account__c,genApp.Id);//V1.2
        queryService.getApplication(dsa.Employ_Code__c,'Vehicle Details Captured');//V1.2
        Test.stopTest();
    }

    @istest
    public static void method2()
    {       
        DSA_Master__c dsa=new DSA_Master__c(Branch_Code__c='1213',Employ_Code__c='1705',Employ_Name__c='Braj Mohan',Branch_Name__c='CHENNAI - T.NAGAR',Role__c = 'OFF');
        insert dsa;

        Test.startTest();
        queryService.getApplication(dsa.Employ_Code__c,'Vehicle Details Captured');//V1.2
        queryService.getCode('pp','2');       
        Test.stopTest();
    }

    @istest
    public static void method3()
    {       
         Test.startTest();
        queryService.getCode('pp','3');       
        Test.stopTest();
    }
}