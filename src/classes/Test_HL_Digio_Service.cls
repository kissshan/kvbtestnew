//written by prashant singh
//date:-05/11/2018
//class name:-HL_Digio_Service
//code coverage 80%
@isTest
public class Test_HL_Digio_Service {
    @testsetup
    public static void settingRecord()
    {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
        genApp.RecordTypeId = genAppRecordType;
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
        }
                
           KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb;
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'DocGeneration';
        KVB1.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/CreateDocTemplate1';
     	insert kvb1;
        KVB_Endpoint_URLs__c kvb2 = new KVB_Endpoint_URLs__c();
     	KVB2.Name = 'DocSigner';
        KVB2.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/SignDoc';
     	insert kvb2;
        DIGIO_Templates__c digio=new DIGIO_Templates__c();
        digio.Template_Unique_Id__c='56gy78ug';
        digio.Name='C1';
        insert digio;
        
    
    }
    @istest
    public static  void method1(){
        
        genesis__Applications__c genApp=[select id from genesis__Applications__c where Branch_Code__c ='KB23'];  
       // genesis__Application_Parties__c genPar=[select id,genesis__Party_Type__c from genesis__Application_Parties__c where id=:genApp.id];
        test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        HL_Digio_Service.CallDocs(genApp.Id,'C1'); 
       HL_Digio_Service.CallDocs(genApp.Id,Constants.Acknowledgement_For_SanctionLAP); 
        HL_Digio_Service.CallDocs(genApp.Id,Constants.PRE_Approval_Sanction_HL); 
        
        
                
    }
    
  
    
      @istest
    public static  void method2(){
           
        DIGIO_Templates__c digiotemp=[select id from DIGIO_Templates__c];
        digiotemp.Name=Constants.Acknowledgement_For_SanctionLAP_NLD;
        update digiotemp;
         genesis__Applications__c genApp1=[select id from genesis__Applications__c where Branch_Code__c ='KB23'];    
        genApp1.Legal_desk_state_flag__c=false;
        update genApp1;
                test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        HL_Digio_Service.CallDocs(genApp1.Id,Constants.Acknowledgement_For_Sanction); 
        HL_Digio_Service.CallDocs(genApp1.Id,Constants.Acknowledgement_For_SanctionLAP); 
        HL_Digio_Service.CallDocs(genApp1.Id,Constants.LAP_A23D_LAFA);  
        HL_Digio_Service.CallDocs(genApp1.Id,Constants.LAP_A46DOC); 
        HL_Digio_Service.CallDocs(genApp1.Id,Constants.LAP_B1_B2DOC); 
        test.stopTest();
        
        
    }
    
    
   /* @istest
public static  void method2(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c where Branch_Code__c ='KB23'];    
        Test.startTest();
        HL_Digio_Service.CallDocs(genApp.Id,'LAP_C1'); 
        Test.stopTest();
    }
    @istest
    public static  void method3(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c where Branch_Code__c ='KB23'];    
        Test.startTest();
         //String Filename4 = Constants.PRE_Approval_Sanction_HL;
        //string FF=''; 
       // FF = Filename4;
        HL_Digio_Service.CallDocs(genApp.Id,'HL_Preapproval_Letter'); 
        Test.stopTest();
    }
     @istest
    public static  void method4(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c where Branch_Code__c ='KB23'];    
        Test.startTest();
        HL_Digio_Service.CallDocs(genApp.Id,'LAP_A46'); 
        Test.stopTest();
    }
    
      @istest
    public static  void method5(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c where Branch_Code__c ='KB23']; 
        genApp.Legal_desk_state_flag__c = false;
        update genApp;
        Test.startTest();
        HL_Digio_Service.CallDocs(genApp.Id,'LAP_A23_Sign'); 
        Test.stopTest();
    }
    
    @istest
    public static  void method6(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c where Branch_Code__c ='KB23'];    
             genApp.Legal_desk_state_flag__c = false;
        update genApp;
        Test.startTest();
        HL_Digio_Service.CallDocs(genApp.Id,'LAP_A46_Sign'); 
        Test.stopTest();
    }
    
      @istest
    public static  void method7(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c where Branch_Code__c ='KB23'];    
                genApp.Legal_desk_state_flag__c = false;
        update genApp;
        Test.startTest();
        HL_Digio_Service.CallDocs(genApp.Id,'LAP_B1_Sign'); 
        Test.stopTest();
    }
    
     @istest
    public static  void method8(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c where Branch_Code__c ='KB23'];
        genApp.Legal_desk_state_flag__c = false;
        Test.startTest();
        HL_Digio_Service.CallDocs(genApp.Id,'LAP_B1_Sign'); 
        Test.stopTest();
    }  */
    
}

/*
@isTest
public class Test_HL_Digio_Service {
    @isTest
    public static void HLDigioServiceMethod(){
        String Filename1 = Constants.Acknowledgement_For_Sanction;
        String Filename2 = Constants.Acknowledgement_For_SanctionLAP;
        String Filename3 = Constants.GuarantorAgree_For_LAP;
        String Filename4 = Constants.PRE_Approval_Sanction_HL;
        String Filename5 = Constants.LAP_A23D_LAFA;
        String Filename6 = Constants.LAP_A46DOC;
        String Filename7 = Constants.LAP_B1_B2DOC;
        String Filename8 = '';
        String Filename9  = Constants.PRE_APPROVE_SANCTION_PL;
        String Filename10 = Constants.PL_AGREEMENT_DOC;
        String Filename11 = Constants.PL_loan_Agreement_Letter;
        string FF='';
        
        
        genesis__Applications__c genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Legal_desk_state_flag__c = false;
        Test.startTest();
        if(Filename1 == Constants.Acknowledgement_For_Sanction){
            FF = Filename1;
             HL_Digio_Service.CallDocs(genApp.Id, Filename1);
        	 HL_Digio_Service.docGenAndSignDoc(genApp.Id, Filename1);
        }
       if(Filename2 == Constants.Acknowledgement_For_SanctionLAP){
            FF = Filename2;
             HL_Digio_Service.CallDocs(genApp.Id, Filename2);
       		 HL_Digio_Service.docGenAndSignDoc(genApp.Id, Filename2);
        }
        if(Filename3 == Constants.GuarantorAgree_For_LAP){
            FF = Filename3;
             HL_Digio_Service.CallDocs(genApp.Id, Filename3);
             HL_Digio_Service.docGenAndSignDoc(genApp.Id, Filename3);
        }
        if(Filename4 == Constants.PRE_Approval_Sanction_HL){
            FF = Filename4;
             HL_Digio_Service.CallDocs(genApp.Id, Filename4);
        	 HL_Digio_Service.docGenAndSignDoc(genApp.Id, Filename4);
        }
        if(Filename5 == Constants.LAP_A23D_LAFA){
            FF = Filename5;
             HL_Digio_Service.CallDocs(genApp.Id, Filename5);
             HL_Digio_Service.docGenAndSignDoc(genApp.Id, Filename5);
        }
        if(Filename6 == Constants.LAP_A46DOC){
            FF = Filename6;
             HL_Digio_Service.CallDocs(genApp.Id, Filename6);
             HL_Digio_Service.docGenAndSignDoc(genApp.Id, Filename6);
        }
        if(Filename7 == Constants.LAP_B1_B2DOC){
            FF = Filename7;
             HL_Digio_Service.CallDocs(genApp.Id, Filename7);
             HL_Digio_Service.docGenAndSignDoc(genApp.Id, Filename7);
        }
        if(Filename8 == ''){
            FF = Filename8;
            HL_Digio_Service.CallDocs(genApp.Id, Filename8);
            HL_Digio_Service.docGenAndSignDoc(genApp.Id, Filename8);
        }
        if(Filename9 == Constants.PRE_APPROVE_SANCTION_PL){
            FF = Filename9;
            PL_Digio_Services.docGenAndSignDocPL(genApp.Id, Filename9);
        }
        if(Filename10 == Constants.PL_AGREEMENT_DOC){
            FF = Filename10;
            PL_Digio_Services.docGenAndSignDocPL(genApp.Id, Filename10);
        }
        if(Filename11 == Constants.PL_loan_Agreement_Letter){
            FF = Filename11;
            PL_Digio_Services.docGenAndSignDocPL(genApp.Id, Filename11);
        }
        Test.stopTest();
    }

}
*/