@isTest
public class ApplicationEligibiltyHandler_Test {
    

    @testsetup
    public static void setupMethod(){
	
        MCLR_Excess_Code__c mclrexcess=new MCLR_Excess_Code__c();
        mclrexcess.Employment_Type__c='Salaried';
        mclrexcess.Product_Name__c='VL2W';
        mclrexcess.Retail_Category__c='D';
        mclrexcess.From_CIBIL__c=759;
        mclrexcess.Name='mclrrecord';
        mclrexcess.Excess__c=18.22;
        insert mclrexcess;
        MCLR_Master__c mclrmaster=new MCLR_Master__c();
        mclrmaster.COD_Term_From__c=90;
        mclrmaster.MCLR_Of_Interest__c=123.23;
        insert mclrmaster;
    }
    
/*  @isTest
    public static void method1(){
        
        MCLR_Excess_Code__c mclrexcess=[select id,Employment_Type__c,Product_Name__c,From_CIBIL__c,Retail_Category__c from MCLR_Excess_Code__c];
        	mclrexcess.Retail_Category__c='D';
            mclrexcess.From_CIBIL__c =  750;
            mclrexcess.Product_Name__c=Constants.VL2W;
           mclrexcess.Employment_Type__c='Salaried';
                update mclrexcess;
        MCLR_Master__c mclrmstr=[select id,COD_Term_From__c from MCLR_Master__c];
        mclrmstr.COD_Term_From__c=365;
        update mclrmstr;
            
        Trigger_Setting__c custmsetting=new Trigger_Setting__c();
        custmsetting.Execute_Application_Trigger__c=true;
        insert custmsetting;
        ApplicationTriggerHandler.IsFirstRun=true;
        String customLabelValue = System.Label.VL_Waiver_Percent;
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true);
      
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        
        update genApp;
    }
  */
 
   @isTest
    public static void method5(){
        
                MCLR_Excess_Code__c mclrexcess=[select id,Employment_Type__c,Product_Name__c,From_CIBIL__c,Retail_Category__c from MCLR_Excess_Code__c];
        	mclrexcess.Retail_Category__c='D';
            mclrexcess.From_CIBIL__c =  750;
            mclrexcess.Product_Name__c=Constants.VL2W;
           mclrexcess.Employment_Type__c='Salaried';
                update mclrexcess;
        MCLR_Master__c mclrmstr=[select id,COD_Term_From__c from MCLR_Master__c];
        mclrmstr.COD_Term_From__c=365;
        update mclrmstr;
        clcommon__CL_Product__c pp=VL_Test_Utility.createProduct('Digital Flexi mobile loan - 717');
        insert pp;
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(false,false,'VL4W');
       // List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true);
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Work Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        update genApp;
        applist2.add(genApp);
        
        Account acct = new Account(firstName='Venu',LastName='Gopal');
        insert acct;
        
        genesis__Application_Parties__c par=VL_Test_Utility.createAppParty(acct.id,genApp.id,'Primary Applicant');
        insert par;
        par.Employment_Types__c=Constants.EMPTYP_AGRICULTUR;
        par.Financial_Applicant__c = True;
        par.Net_Monthly_Income__c = 500;
        update par;
        
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
    }
   
   @isTest
    public static void method6(){
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        update genApp;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
    }
      @isTest
    public static void method7(){
        list<genesis__Application_Parties__c> partylist=new list<genesis__Application_Parties__c>();
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(false,true,'Personal Loan');
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Sub_Type__c='Take Over';
        update genApp;
        applist2.add(genApp);
      
        
         Id devRecordTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
            
        Facility__c fac1 = new Facility__c();
        fac1.RecordTypeId = devRecordTypeId;
        fac1.role__C='BR';
        fac1.Application__c = genApp.Id;
        fac1.Higher_Authority_Order__c=67;
        fac1.Recommended_Limit__c=700000;
        fac1.Recommended_Processing_Charge__c=0.45;
        insert fac1;
        
        Account acct = new Account(firstName='Venu',LastName='Gopal');
        //acct.Customer_ID_Creation_Date__c=Date.parse('09/11/2019');
        insert acct;
        
        genesis__Application_Parties__c par=VL_Test_Utility.createAppParty(acct.id,genApp.id,'Primary Applicant');
        insert par;
        par.Employment_Types__c=Constants.EmpType_Agricul;
        par.Financial_Applicant__c = True;
        update par;

        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
        
        Branch_Master__c brmas=new Branch_Master__c();
        brmas.CODCCBRN__c='1858';//app.branch_Code__c;
        brmas.Retail_Category__c='A';
        brmas.NAMCCCITY__c='kanpur';
        insert brmas;  
        list<clcommon__Collateral__c> collaterallist=new list<clcommon__Collateral__c>( [select id,clcommon__City__c from clcommon__Collateral__c ]);
        ApplicationEligibiltyHandler.getRetailCatagory(collaterallist);
    }
     @isTest
    public static void method07(){
        list<genesis__Application_Parties__c> party=new list<genesis__Application_Parties__c>();
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        genesis__Applications__c genApp =new genesis__Applications__c();
        for(genesis__Applications__c app:applist )
        {
            for(genesis__Application_Parties__c par:app.genesis__Application_Parties__r)
            {
        	par.Employment_Types__c=Constants.EmpType_Agricul;
             par.CIBIL_Scores__c=600;
                par.Net_Monthly_Income__c=4000;
                   party.add(par);
            }
         
        }
        system.debug('party:-'+party);
        update party;
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        update genApp;
        Account acct = new Account(firstName='Venu',LastName='Gopal');
        acct.Customer_ID_Creation_Date__c=Date.parse('09/11/2019');
        insert acct;
        genesis__Application_Parties__c par=VL_Test_Utility.createAppParty(acct.id,genApp.id,'co-borrower');
        par.Employment_Types__c= 'Salaried';
        //par.Financial_Applicant__c = false;
        insert par;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
        
         Branch_Master__c brmas=new Branch_Master__c();
        brmas.CODCCBRN__c='1858';//app.branch_Code__c;
        brmas.Retail_Category__c='A';
        brmas.NAMCCCITY__c='kanpur';
        insert brmas;  
        list<clcommon__Collateral__c> collaterallist=new list<clcommon__Collateral__c>( [select id,clcommon__City__c from clcommon__Collateral__c ]);
        ApplicationEligibiltyHandler.getRetailCatagory(collaterallist);
    }
   @isTest
    public static void method71(){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       

        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Loan_Purpose__c=Constants.RepairHouse;
		genApp.Sub_Type__c = Constants.Sub_Type_Top_Up;
        genApp.RecordTypeId=RecordTypeIdgenApp;
        update genApp;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
        
    }
    @isTest
    public static void method8(){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       

        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.RecordTypeId=RecordTypeIdgenApp;
        genApp.Loan_Purpose__c=Constants.IdentifiedProperty;
        update genApp;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
    }
    @isTest
    public static void method9(){
     // Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       

        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Home Loan');
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.RecordTypeId=applist[0].recordtypeid;
        genApp.Loan_Purpose__c=Constants.Construction;
        update genApp;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
    }
     @isTest
    public static void method10(){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       
			
        MCLR_Excess_Code__c mclrexcess=[select id ,Employment_Type__c,Product_Name__c,Retail_Category__c,From_CIBIL__c from MCLR_Excess_Code__c];
        mclrexcess.Product_Name__c='Home Loan';
        mclrexcess.Retail_Category__c=null;
            mclrexcess.From_CIBIL__c=750;
        
        update mclrexcess;
       
        
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.RecordTypeId=RecordTypeIdgenApp;
        genApp.Loan_Purpose__c=Constants.ConstructionOn;
        
        update genApp;
      
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
      
    }
    @isTest
    public static void method11(){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       
			
        
         MCLR_Excess_Code__c mclrexcess=[select id ,Employment_Type__c,Product_Name__c,Retail_Category__c,From_CIBIL__c from MCLR_Excess_Code__c];
        mclrexcess.Product_Name__c=Constants.LAPLOAN;
        mclrexcess.Retail_Category__c='A';
            mclrexcess.From_CIBIL__c=NULL;
       // mclrexcess.Excess__c=123.12;
        update mclrexcess;
         MCLR_Master__c mclrmaster=[select id,COD_Term_From__c from MCLR_Master__c];
        mclrmaster.COD_Term_From__c=NULL;
        mclrmaster.MCLR_Of_Interest__c=123.23;
        update mclrmaster;
       
        
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.RecordTypeId=RecordTypeIdgenApp;
        genApp.Loan_Purpose__c=Constants.ConstructionOn;
        
        update genApp;
      
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
         ApplicationEligibiltyHandler.getMCLR(null,'A',null);
        
      
    }
     @isTest
    public static void method12(){
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,Constants.LAPLOAN);
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        update genApp;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
    }
     
	@istest	
    public static void method13(){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       
		
         MCLR_Excess_Code__c mclrexcess=[select id ,Employment_Type__c,Product_Name__c,Retail_Category__c,From_CIBIL__c from MCLR_Excess_Code__c];
        mclrexcess.Product_Name__c=Constants.HOMELOAN;
        mclrexcess.Retail_Category__c=null;
            mclrexcess.From_CIBIL__c=700;
        update mclrexcess;
        
         MCLR_Master__c mclrmaster=[select id,COD_Term_From__c from MCLR_Master__c];
        mclrmaster.COD_Term_From__c=365;
        mclrmaster.MCLR_Of_Interest__c=123.23;
        update mclrmaster;
        
       List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        list<genesis__Application_Parties__c> party=new list<genesis__Application_Parties__c>([select id,CIBIL_Scores__c from genesis__Application_Parties__c where genesis__Application__c=:applist[0].id ]);
      	 list<genesis__Application_Parties__c> tempparty=new list<genesis__Application_Parties__c>();
        for(genesis__Application_Parties__c par:party){
            par.CIBIL_Scores__c=700;
            tempparty.add(par);
        }
        update  tempparty;
        system.debug('party:-'+party);
        //genesis__Applications__c genApp =new genesis__Applications__c();
       for(genesis__Applications__c genapp : applist) {
            //genApp.id=applist[0].id;
            genApp.genesis__Term__c=10;
            genApp.Sub_Stage__c='Property Information Captured';
            genApp.Pre_approved_flag__c=true;
            genApp.Perfios_Captured__c=true;
            genApp.RecordTypeId=RecordTypeIdgenApp;
            genApp.Loan_Purpose__c=Constants.Construction;
            genApp.Sub_Type__c = 'Top Up';
            applist2.add(genApp);
        
       }
        update applist2;
        
        System.debug(applist2);
        
        
        list<genesis__Applications__c> app=[select id,genesis__Term__c,Sub_Stage__c,Pre_approved_flag__c,Perfios_Captured__c,Sub_Type__c from genesis__Applications__c where id = : applist2[0].id];
        Facility__c fac= new Facility__c();
        fac.Application__c = applist2[0].id;
        insert fac;
        
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(app);
    }    
    
    @istest	
    public static void method14(){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       
		
         MCLR_Excess_Code__c mclrexcess=[select id ,Employment_Type__c,Product_Name__c,Retail_Category__c,From_CIBIL__c from MCLR_Excess_Code__c];
        mclrexcess.Product_Name__c=Constants.HOMELOAN;
        mclrexcess.Retail_Category__c=null;
            mclrexcess.From_CIBIL__c=650;
        update mclrexcess;
        
         MCLR_Master__c mclrmaster=[select id,COD_Term_From__c from MCLR_Master__c];
        mclrmaster.COD_Term_From__c=365;
        mclrmaster.MCLR_Of_Interest__c=123.23;
        update mclrmaster;
        
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        list<genesis__Application_Parties__c> party=new list<genesis__Application_Parties__c>([select id,CIBIL_Scores__c from genesis__Application_Parties__c where genesis__Application__c=:applist[0].id ]);
      	 list<genesis__Application_Parties__c> tempparty=new list<genesis__Application_Parties__c>();
        for(genesis__Application_Parties__c par:party)
        {
            par.CIBIL_Scores__c=650;
            tempparty.add(par);
        }
        update  tempparty;
        system.debug('party:-'+party);
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.RecordTypeId=RecordTypeIdgenApp;
        genApp.Loan_Purpose__c=Constants.Construction;
        update genApp;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
    }   
     @istest	
    public static void method15(){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       
		
         MCLR_Excess_Code__c mclrexcess=[select id ,Employment_Type__c,Product_Name__c,Retail_Category__c,From_CIBIL__c from MCLR_Excess_Code__c];
        mclrexcess.Product_Name__c=Constants.HOMELOAN;
        mclrexcess.Retail_Category__c=null;
            mclrexcess.From_CIBIL__c=-1;
        update mclrexcess;
        
         MCLR_Master__c mclrmaster=[select id,COD_Term_From__c from MCLR_Master__c];
        mclrmaster.COD_Term_From__c=365;
        mclrmaster.MCLR_Of_Interest__c=123.23;
        update mclrmaster;
        
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        list<genesis__Application_Parties__c> party=new list<genesis__Application_Parties__c>([select id,CIBIL_Scores__c from genesis__Application_Parties__c where genesis__Application__c=:applist[0].id ]);
      	 list<genesis__Application_Parties__c> tempparty=new list<genesis__Application_Parties__c>();
        for(genesis__Application_Parties__c par:party)
        {
            par.CIBIL_Scores__c=-1;
            tempparty.add(par);
        }
        update  tempparty;
        system.debug('party:-'+party);
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.RecordTypeId=RecordTypeIdgenApp;
        genApp.Loan_Purpose__c=Constants.Construction;
        update genApp;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
    }   
   public static void method72(){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       

        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'Personal Loan');
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        genApp.Loan_Purpose__c=Constants.RepairHouse;
        genApp.Sub_Type__c='Top Up';

        genApp.RecordTypeId=RecordTypeIdgenApp;
        update genApp;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
       
       Branch_Master__c bm=new Branch_Master__c();
       bm.CODCCBRN__c='1857';
       bm.Retail_Category__c='A';
       bm.NAM_BRANCH__c='CHENNAI - DTPC';
       insert bm;
        
    }
   
     @isTest
    public static void method02(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
            Trigger_Setting__c triggersetting = new Trigger_Setting__c();
            triggersetting.Name = 'Test Setting';
            triggersetting.Execute_Application_Trigger__c=True;
            insert triggersetting;
            
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Customer_ID_Creation_Date__c=Date.parse('09/11/2019');
            acc.CIBIL_Score__c=1000;
            insert acc;
            
            Account acc1 = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc1.Customer_ID_Creation_Date__c=Date.parse('09/11/2019');
            acc1.CIBIL_Score__c=100;
            insert acc1;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            clcommon__CL_Product__c clprod = SME_TestUtil.createclproduct('Test Product','777',null);
            insert clprod;
            clprod.Min_Amount__c=4000;
            clprod.LMax_PL__c=9000;
            clprod.Max_Amount__c=2000;
            update clprod;
           
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            list<genesis__Applications__c> genapplist = new list<genesis__Applications__c>();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Flat_No__c='T-12';
            genApp.RecordTypeId=genAppRecordType;
            genApp.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp.Application_Stage__c ='Exceeding-Final sanction';
            genApp.genesis__CL_Product__c = clprod.Id;
            insert genApp;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp.Flat_No__c='T-45';
            genApp.Sub_Stage__c='Terms and Conditions Accepted';
            genApp.Application_Stage__c='Enhancement- Final sanction offered';
           genapplist.add(genApp);
            //update genApp;
            
             Id genAppRecordType1 = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
            System.debug('genAppRecordType'+genAppRecordType);
            genesis__Applications__c genApp1=SME_TestUtil.createApplication('KB231',acc1.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp1.Flat_No__c='T-12';
            genApp1.RecordTypeId=genAppRecordType1;
            genApp1.Sub_Stage__c='Loan Sanctioned Non-STP';
            genApp1.Application_Stage__c ='Exceeding-Final sanction';
            genApp1.genesis__CL_Product__c = clprod.Id;
            insert genApp1;
            ApplicationTriggerHandler.IsFirstRun= true;
            genApp1.Flat_No__c='T-45';
            genApp1.Sub_Stage__c='Terms and Conditions Accepted';
            genApp1.Application_Stage__c='Enhancement- Final sanction offered';
           
            //update genApp1;
            genapplist.add(genapp1);
            update genapplist;
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            
            genesis__Application_Parties__c part=new genesis__Application_Parties__c();
            part.CIBIL_Scores__c=700;
            part.genesis__Application__c = genApp.id;
            part.genesis__Party_Account_Name__c = acc.id;
            part.Employment_Types__c = 'Salaried';
            part.genesis__Party_Type__c = 'Primary Applicant';
            part.Financial_Applicant__c = true;
            part.Net_Monthly_Income__c = 10000;
            insert part;
            ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(genapplist);
            ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(genapplist);
        }
    }
      @isTest
    public static void method17(){
        list<genesis__Application_Parties__c> party=new list<genesis__Application_Parties__c>();
        List<genesis__Applications__c> applist2=new List<genesis__Applications__c>();
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUpOther(true,true,'VL2W');
        genesis__Applications__c genApp =new genesis__Applications__c();
        for(genesis__Applications__c app:applist )
        {
            for(genesis__Application_Parties__c par:app.genesis__Application_Parties__r)
            {
        	par.Employment_Types__c=Constants.EmpType_Agricul;
             par.CIBIL_Scores__c=600;
                par.Net_Monthly_Income__c=4000;
                   party.add(par);
            }
         
        }
        system.debug('party:-'+party);
        update party;
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Property Information Captured';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        update genApp;
        Account acct = new Account(firstName='Venu',LastName='Gopal');
        acct.Customer_ID_Creation_Date__c=Date.parse('09/11/2019');
        insert acct;
        genesis__Application_Parties__c par=VL_Test_Utility.createAppParty(acct.id,genApp.id,'co-borrower');
        par.Employment_Types__c= 'Salaried';
        //par.Financial_Applicant__c = false;
        insert par;
        applist2.add(genApp);
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(applist2);
        
         Branch_Master__c brmas=new Branch_Master__c();
        brmas.CODCCBRN__c='1858';//app.branch_Code__c;
        brmas.Retail_Category__c='A';
        brmas.NAMCCCITY__c='kanpur';
        insert brmas;  
        list<clcommon__Collateral__c> collaterallist=new list<clcommon__Collateral__c>( [select id,clcommon__City__c from clcommon__Collateral__c ]);
        ApplicationEligibiltyHandler.getRetailCatagory(collaterallist);
    }
}