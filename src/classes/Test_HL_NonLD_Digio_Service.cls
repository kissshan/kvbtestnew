// written by prashant singh
// date:--01/10/2018
// class name:-HL_NonLD_Digio_Service
// code coverage:- 82%

@isTest
public class Test_HL_NonLD_Digio_Service {
    @testsetup    
  public static void testDataSetup()
    {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=false;
            insert genApp;
          //   Account acc = new Account(name='TestQuery');
        //INSERT acc;
        
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
        }
         DIGIO_Templates__c digio=new DIGIO_Templates__c();
         digio.Template_Unique_Id__c='56gy78ug';
        digio.Name='C1';
        insert digio;
        
       KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb;
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'DocGeneration';
        KVB1.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/CreateDocTemplate1';
        kvb1.Username__c='prashant';
     	insert kvb1;
       
        
        
    }
      @isTest    
  public static void method1()
  {
      
       DIGIO_Templates__c digio=[select id,Template_Unique_Id__c,Name from DIGIO_Templates__c];
        digio.Template_Unique_Id__c='56gy78ug';
        digio.Name='C1';
        update digio;
        genesis__Applications__c genApp=[select id from genesis__Applications__c where Branch_Code__c ='KB23'];  
      
        Test.startTest();
        HL_NonLD_Digio_Service.CallDocs(genApp.Id,Constants.HL_DIGIO_MANUAL_C1C11); 
      HL_NonLD_Digio_Service.CallDocs(genApp.Id,'Disburse'); 
      genApp.Loan_Purpose__c=Constants.IdentifiedProperty ;
      update genApp;
      HL_NonLD_Digio_Service.CallDocs(genApp.Id,'Disburse');
          Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

       DIGIO_Templates__c digio1=[select id,Template_Unique_Id__c,Name from DIGIO_Templates__c];
        //digio1.Template_Unique_Id__c='56gy78u';
        digio1.Name='HL_B1_Manual';
        update digio1;
      HL_NonLD_Digio_Service.CallDocs(genApp.Id,'MOD');      
        Test.stopTest();
  }
 
    

}