//written by prashant singh
//class name:-Digioe_Docs_Service
//code coverage:-49%
//date:-04/11/2018


@isTest
public class Digioe_Docs_Service_Test {
      @testsetup
public static void setupMethod()
{

      Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
   // acc.PersonEmail='p@gmail.com';
   // acc.PersonMobilePhone='2322221312';
        insert acc;
     genesis__Applications__c app = Utility_Test.createApplication('1323', acc.id);
        app.SI_Bank_Name__c='Karur Vysya Bank';
      app.genesis__Interest_Rate__c=12;
        app.Sanctioned_EMI__c=12.90;
        app.genesis__Disbursement_Date__c=date.parse('05/12/2018');
            app.Sanctioned_Tenure__c=230;
        insert app;
    genesis__Application_Parties__c genPar = new genesis__Application_Parties__c();
        genPar.genesis__Party_Account_Name__c = acc.Id;
        genPar.Key_Contact__c = acc.Id;
        genPar.genesis__Application__c = app.Id;
        genPar.genesis__Party_Type__c = Constants.Co_Borrower;
        genPar.Active__c=true;
        genPar.Company__c=false;
        INSERT genPar;
    clcommon__Collateral__c cc=new clcommon__Collateral__c();
        cc.Advances_Paid__c=100;
        cc.Branch_Name__c='san';
        cc.Dealer_name__c='test';
        cc.Dealer_Email__c='cc@gmail.com';
        cc.genesis__Application__c=app.Id;
        cc.clcommon__Manufacturer__c='ooie';
        cc.clcommon__Model__c='iwej';
        cc.Variant__c='jsdj';
        cc.clcommon__Collateral_Name__c='test123';
             cc.Collateral_Type__c='Vehicles';
        insert cc;
    KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'DocGeneration';
        KVB1.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/CreateDocTemplate1';
        KVB1.Username__c='prashant';
     	insert kvb1;
     KVB_Endpoint_URLs__c kvb2 = new KVB_Endpoint_URLs__c();
     	KVB2.Name = 'DocumentDownload';
        KVB2.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/DownloadDocument';
        KVB2.Username__c='prashant';
     	insert kvb2;
     KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
    kvb.Key_Store_Name__c='prashant';
        insert kvb;
     DIGIO_Templates__c digio=new DIGIO_Templates__c();
         digio.Template_Unique_Id__c='56gy78ug';
        digio.Name=Constants.Acknowledgement_For_Sanction;
        insert digio;
    genesis__Application_Document_Category__c appdoccat=new genesis__Application_Document_Category__c();
        appdoccat.genesis__Application__c=app.id;
            appdoccat.name=Constants.LoanDocuments;
            insert appdoccat;
     Digio_Document_ID__c docobj=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='111',Guarantor__c=true,Stamp_Charges__c=100,name=Constants.Acknowledgement_For_Sanction);
        insert docobj; 
     Attachment att = new Attachment();
          att.Name = Constants.Acknowledgement_For_Sanction;
            att.ParentId = app.id;
            att.Body = blob.valueOf('jfdifjscijdnehfo9jdw fodjwdkmjdkenoedfwj');
    att.Description=docobj.id;
            insert att;
    
    
}
    
    @isTest
    public static void method1(){
      
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];  
        Attachment att=[select id from Attachment];
                Digio_Document_ID__c docobj=[select id from Digio_Document_ID__c];

        		test.startTest();
			          Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        string templateId   = Utility.getDIGIOTemplateId(Constants.Acknowledgement_For_Sanction); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.Acknowledgement_For_Sanction, templateId);  
        Digioe_Docs_Service.upsertDoc(genApp.id,Constants.Acknowledgement_For_Sanction,'prashant');       
         Digioe_Docs_Service.upsertDoc(genApp.id,'negative senario','prashant');
        Digioe_Docs_Service.upsertDocWithDocId(att,'djkfhidjjdf');
        Digioe_Docs_Service.getApplication(genApp.id);
        Digioe_Docs_Service.getAttachmentBody(genApp.id,Constants.Acknowledgement_For_Sanction);
     
        test.stopTest();
        
    }
     @isTest
    public static void method2(){
      
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        Digio_Document_ID__c docobj=[select id from Digio_Document_ID__c];

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
       
        Digioe_Docs_Service.downloadDocument(docobj.id);
        
        
        test.stopTest();
        
    }
    @isTest
    public static void method3(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
       
              DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];

         digio.Name=Constants.PRE_Approval_Sanction_HL;
        update digio;
        test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     

       
        string templateId   = Utility.getDIGIOTemplateId(Constants.PRE_Approval_Sanction_HL); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.PRE_Approval_Sanction_HL, templateId);
        test.stopTest();
        
    }
      @isTest
    public static void method4(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.PRE_APPROVE_SANCTION_PL;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.PRE_APPROVE_SANCTION_PL); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.PRE_APPROVE_SANCTION_PL, templateId);
        test.stopTest();
    }
     @isTest
    public static void method5(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.PL_loan_Agreement_Letter;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.PL_loan_Agreement_Letter); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.PL_loan_Agreement_Letter, templateId);
        test.stopTest();
    }
       @isTest
    public static void method6(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.HL_DIGIO_MANUAL_A23;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.HL_DIGIO_MANUAL_A23); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.HL_DIGIO_MANUAL_A23, templateId);
        test.stopTest();
    }
        @isTest
    public static void method7(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.HL_DIGIO_MANUAL_A46;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.HL_DIGIO_MANUAL_A46); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.HL_DIGIO_MANUAL_A46, templateId);
        test.stopTest();
    }
      @isTest
    public static void method8(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.HL_DIGIO_MANUAL_B17;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.HL_DIGIO_MANUAL_B17); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.HL_DIGIO_MANUAL_B17, templateId);
        test.stopTest();
    }
     @isTest
    public static void method9(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.HL_DIGIO_MANUAL_B1B2;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.HL_DIGIO_MANUAL_B1B2); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.HL_DIGIO_MANUAL_B1B2, templateId);
        test.stopTest();
    }
    @isTest
    public static void method10(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.HL_DIGIO_MANUAL_C1C11;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.HL_DIGIO_MANUAL_C1C11); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.HL_DIGIO_MANUAL_C1C11, templateId);
        test.stopTest();
    }
    @isTest
    public static void method11(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.VLSANCTIONLETTER;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.VLSANCTIONLETTER); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.VLSANCTIONLETTER, templateId);
        test.stopTest();
    }
    @isTest
    public static void method12(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.VLDEALERPYMNTAUTH;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.VLDEALERPYMNTAUTH); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.VLDEALERPYMNTAUTH, templateId);
        test.stopTest();
    }
         @isTest
    public static void method14(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.VLHYPOTHECATION;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.VLHYPOTHECATION); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.VLHYPOTHECATION, templateId);
        test.stopTest();
    }
    
         @isTest
    public static void method15(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.Acknowledgement_For_SanctionLAP;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.Acknowledgement_For_SanctionLAP); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.Acknowledgement_For_SanctionLAP, templateId);
        test.stopTest();
    }
    
         @isTest
    public static void method16(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.LAP_A23D_LAFA;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.LAP_A23D_LAFA); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.LAP_A23D_LAFA, templateId);
        test.stopTest();
    }
      @isTest
    public static void method17(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name=Constants.LAP_A46DOC;
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId(Constants.LAP_A46DOC); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, Constants.LAP_A46DOC, templateId);
        test.stopTest();
    }
      @isTest
    public static void method19(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name='A1_EAE';
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId('A1_EAE'); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, 'A1_EAE', templateId);
        test.stopTest();
    }
      @isTest
    public static void method20(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name='C7_EAE';
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId('C7_EAE'); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, 'C7_EAE', templateId);
        test.stopTest();
    }
      @isTest
    public static void method21(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name='C8_EAE';
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId('C8_EAE'); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, 'C8_EAE', templateId);
        test.stopTest();
    }
      @isTest
    public static void method22(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name='C9_EAE';
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId('C9_EAE'); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, 'C9_EAE', templateId);
        test.stopTest();
    }
      @isTest
    public static void method23(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name='Sanction Document';
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId('Sanction Document'); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, 'Sanction Document', templateId);
        test.stopTest();
    }
      @isTest
    public static void method24(){
        genesis__Applications__c genApp=[select id from genesis__Applications__c ];
        
        DIGIO_Templates__c digio=[select id ,name from DIGIO_Templates__c ];
          digio.Name='Exceeding Sanction Letter';
        update digio;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());     
      
        string templateId   = Utility.getDIGIOTemplateId('Exceeding Sanction Letter'); 
        system.debug('templateId:-'+templateId);
        Digioe_Docs_Service.getEDocs(genApp.id, 'Exceeding Sanction Letter', templateId);
        test.stopTest();
    }
    
    
    
    
}