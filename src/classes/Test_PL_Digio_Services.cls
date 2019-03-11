/*
*Name:          Test_PL_Digio_Services
*Author:        prashant singh
*Date:          05/11/2018
*class name:    PL_Digio_Services
*Last Modified: Braj
*Purpose:       Test class for PL_Digio_Services
*Code coverage: 84%
*/
@isTest
public class Test_PL_Digio_Services {
  @testsetup    
  public static void testDataSetup()
    {
      User u = Utility_Test.createUser('TestUserkvb@test.com');
      insert u;
      System.RunAs(u){   
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
        acc.PersonMobilePhone='9876543210';
        insert acc;
            
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Document_Generation__c='None';
        genApp.Legal_desk_state_flag__c=true;
        genApp.genesis__Disbursement_Date__c=date.parse('01/11/2018');
        insert genApp;
        
        genesis__Application_Parties__c genPar = new genesis__Application_Parties__c();
        genPar.genesis__Party_Account_Name__c = acc.Id;
        genPar.Key_Contact__c = acc.Id;
        genPar.genesis__Application__c = genApp.Id;
        genPar.genesis__Party_Type__c = Constants.Co_Borrower;
        genPar.Active__c=true;
        genPar.Company__c=false;
        INSERT genPar;
            
        genesis__Application_Document_Category__c appdoccat=new genesis__Application_Document_Category__c();
        appdoccat.genesis__Application__c=genApp.Id;
        appdoccat.name=Constants.LoanDocuments;
        insert appdoccat;
            
        Branch_Master__c branchObj = new Branch_Master__c();
        branchObj.CODCCBRN__c = genApp.Branch_Code__c;
        branchObj.State__c = 'Chennai';
        insert branchObj; 
      }

      insert VL_Test_Utility.createDigioTemplate();
      
      KVB_Company_Details__c kvb = new KVB_Company_Details__c();
	    kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
      kvb.GST__c = 18;
      insert kvb;

      insert VL_Test_Utility.createKVBEndpointURLs();
    }
    @isTest
    public static void method1()
    {
      genesis__Applications__c genApp=[select id,Legal_desk_state_flag__c from genesis__Applications__c Limit 1];
      genApp.Legal_desk_state_flag__c=true;
      update genApp;

      KVB_Endpoint_URLs__c kvb1 = [select id,Name,Endpoint_URL__c,Username__c from KVB_Endpoint_URLs__c where Name='DocGeneration' limit 1];
      kvb1.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/CreateDocTemplate1';
      kvb1.Username__c='';
      update kvb1;

      test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        PL_Digio_Services.docGenAndSignDocPL(genApp.id,Constants.PRE_APPROVE_SANCTION_PL);
      test.stopTest();
            
    }
     
    @isTest
    public static void method2()
    {
      genesis__Applications__c genApp=[select id,Legal_desk_state_flag__c from genesis__Applications__c Limit 1];
      genApp.Legal_desk_state_flag__c=false;
      update genApp;

      KVB_Endpoint_URLs__c kvb1 = [select id,Name,Endpoint_URL__c,Username__c from KVB_Endpoint_URLs__c where Name='DocGeneration' limit 1];
      kvb1.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/CreateDocTemplate1';
      kvb1.Username__c='';
      update kvb1;

      test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        PL_Digio_Services.docGenAndSignDocPL(genApp.id,Constants.PRE_APPROVE_SANCTION_PL);
      test.stopTest();
            
    }
}