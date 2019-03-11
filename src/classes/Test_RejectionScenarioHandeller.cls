/*
* Name      : Test_RejectionScenarioHandeller
* Company   : ET Marlabs
* Purpose   : Test class for RejectionScenarioHandeller
* Author    : Braj 
*
*/

@isTest
public class Test_RejectionScenarioHandeller {
    /*@isTest
    public static void rejectionMethod(){
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=true;
        insert cs;
        Utility.runApplicationTrigger();
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            acc.Jocata_List_Match__c='true';
            acc.Bureau_Score__c='780';
            update acc;
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='Personal Details Captured';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=45.6;
            genApp.RecordTypeId=genAppRecordType;
            insert genApp;
            System.debug('genApp.RecordType'+genApp.RecordTypeId);
            
                
            //after update
            genApp.Sub_Stage__c='Work Information Captured';
            genApp.Loan_Purpose__c='Repair or Renovation of House';
            genApp.Flat_No__c='T-42';
            genApp.genesis__Loan_Amount__c = 77789;
            update genApp;
            
            genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
            genAppPart.genesis__Party_Account_Name__c =acc.Id;
            genAppPart.Active__c=True;
            genAppPart.Net_Monthly_Income__c=300000;
            genAppPart.Employment_Types__c='Salaried';
            genAppPart.Company__c=false;
            //genAppPart.genesis__Application__c=genApp.id;
            genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
            insert genAppPart;
            
     
        }
    }
    
    @isTest
    public static void rejectionMethodBefore(){
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=true;
        insert cs;
        Utility.runApplicationTrigger();
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            acc.Jocata_List_Match__c='true';
            acc.Bureau_Score__c='780';
            update acc;
            
            System.debug('accId::::'+acc.Id);
            genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
            genAppPart.genesis__Party_Account_Name__c =acc.Id;
            genAppPart.Active__c=True;
            genAppPart.Net_Monthly_Income__c=300000;
            genAppPart.Employment_Types__c='Salaried';
            genAppPart.Company__c=false;
            genAppPart.Employment_Types__c='Salaried';
            //genAppPart.genesis__Application__c=genApp.id;
            genAppPart.Annual_Other_IncomeRecurring_CreditsITR__c=392982;
            insert genAppPart;
            System.debug('genAppPart.Id&&&&'+genAppPart.Id);
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='Property information captured';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=45.6;
            genApp.RecordTypeId=genAppRecordType;
            insert genApp;
            System.debug('genApp.RecordType'+genApp.RecordTypeId);
        //    Id genAppRecordType1 = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            
            List<genesis__Applications__c> oldlist=new List<genesis__Applications__c>{genApp};
                
                //after update
                
            genApp.Sub_Stage__c='Work Information Captured';
            genApp.Loan_Purpose__c='Repair or Renovation of House';
            genApp.Flat_No__c='T-42';
          //  genApp.RecordTypeId=genAppRecordType1;
            genApp.genesis__Loan_Amount__c=77789;
            update genApp;
            
            //collateral
            clcommon__Collateral__c clColl = SME_TestUtil.createcollateral(genApp.Id,'Test Collateral','Vacant Land');
            clColl.Nature_of_Property__c='Own property';
            clColl.FE_Created__c=true;
            clColl.genesis__Application__c=genApp.id;
            clColl.EM_Charge_Types__c='Fresh';
            
            clcommon__Collateral__c clColl2 = SME_TestUtil.createcollateral(genApp.Id,'Test Collateral','Vacant Land');
            clColl2.Nature_of_Property__c='Own property';
            clColl2.FE_Created__c=true;
            clColl2.genesis__Application__c=genApp.id;
            clColl2.EM_Charge_Types__c='Additional';
            
            List<clcommon__Collateral__c> colList = new List<clcommon__Collateral__c>{clColl,clColl2};
                insert colList;
        }
    }
*/    
//......
    @isTest
    public static void BranchMethod(){
        
        Branch_Master__c bmobj=new Branch_Master__c();
        bmobj.State__c='wb';
        bmobj.CODCCBRN__c='104';
        bmobj.Retail_Category__c='A';
        insert bmobj;
        RejectionScenarioHandeller.getBranchCity('104',true);
        RejectionScenarioHandeller.getInstance();
    }
      
        @testSetup 
        static void setup(){
            //initial test setup
            List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);

            Branch_Master__c branchmaster = new Branch_Master__c();
            branchmaster.State__c='Andra pradesh';
            branchmaster.Retail_Category__c='A';
            branchmaster.NAMCCCITY__c='Guntur';
            branchmaster.CODCCBRN__c='Chennai';
            insert branchmaster;

        }

        //low age rejection scenario for 2 wheeeler
        @isTest
        public static void rejectionMethodForVL(){
        System.debug('rejectionMethodForVL >>>');
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;

        genesis__Applications__c genApp = new genesis__Applications__c();

        Map<id,genesis__Applications__c> oldAppMap  = new Map<id,genesis__Applications__c>([select id,name,genesis__Account__r.RecordTypeId,Sub_Stage__c,Record_Type_Name__c,PMin__c,PMax1__c,PMax__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1]);

        Account acc = [select id,RecordTypeId,RecordType.Name,PersonBirthdate,CBS_Customer_ID__c from Account where id=:oldAppMap.values()[0].genesis__Account__c];
        acc.PersonBirthdate = Date.today().addYears(-10);
        update acc;
        System.debug('acc >>> ' + acc);

        genApp.Id=oldAppMap.values()[0].Id;
        genApp.Sub_Stage__c = 'Work Information Captured';
        update genApp;
        System.debug('genApp after>>> '+genApp);

        Map<Id, genesis__Applications__c> newAppMap = new Map<Id,genesis__Applications__c>();
        newAppMap.put(genApp.Id, genApp);

        Test.startTest();
        RejectionScenarioHandeller.getInstance();
        RejectionScenarioHandeller.RejectioMethodPersonalLoan(newAppMap,oldAppMap);
        Test.stopTest();
        }

        //low pmax rejection scenario for 2 wheeler
        @isTest
        public static void rejectionMethodForVL1(){
        System.debug('rejectionMethodForVL1 >>>');
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;

        genesis__Applications__c genApp = new genesis__Applications__c();

        Map<id,genesis__Applications__c> oldAppMap  = new Map<id,genesis__Applications__c>([select id,name,genesis__Account__r.RecordTypeId,Sub_Stage__c,Record_Type_Name__c,PMin__c,PMax1__c,PMax__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1]);
        genApp.Id=oldAppMap.values()[0].Id;

        genApp.Sub_Stage__c = 'Work Information Captured';
        genApp.PMin__c = 10000;
        genApp.PMax1__c = 5000;
        update genApp;
        System.debug('genApp after>>> '+genApp);

        List<genesis__Applications__c> newAppList = new List<genesis__Applications__c>();
        newAppList.add(genApp);

        Map<Id, genesis__Applications__c> newAppMap = new Map<Id,genesis__Applications__c>(newAppList);

        Test.startTest();
        RejectionScenarioHandeller.RejectioMethodPersonalLoan(newAppMap,oldAppMap);
        Test.stopTest();

        }

        //Low Nmax rejection scenario for 2 wheeler
        @isTest
        public static void rejectionMethodForVL2(){
        System.debug('rejectionMethodForVL2 >>>');
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;

        genesis__Applications__c genApp = new genesis__Applications__c();

        Map<id,genesis__Applications__c> oldAppMap  = new Map<id,genesis__Applications__c>([select id,name,genesis__Account__r.RecordTypeId,Sub_Stage__c,Record_Type_Name__c,PMin__c,PMax1__c,PMax__c,Nmax__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1]);
        genApp.Id=oldAppMap.values()[0].Id;

        genApp.Sub_Stage__c = 'Work Information Captured';
        genApp.PMin__c = 10000;
        genApp.PMax1__c = 15000;
        genApp.EMI_Max__c = 20000;
        genApp.Nmax__c = 10;
        update genApp;
        System.debug('genApp after>>> '+genApp);

        List<genesis__Applications__c> newAppList = new List<genesis__Applications__c>();
        newAppList.add(genApp);

        Map<Id, genesis__Applications__c> newAppMap = new Map<Id,genesis__Applications__c>(newAppList);

        Test.startTest();
        RejectionScenarioHandeller.RejectioMethodPersonalLoan(newAppMap,oldAppMap);
        Test.stopTest();

        }

        //low Net_Monthly_Income__c rejection scenario for 2 wheeler
        @isTest
        public static void rejectionMethodForVL3(){
        System.debug('rejectionMethodForVL3 >>>');
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;

        genesis__Applications__c genApp = new genesis__Applications__c();

        Map<id,genesis__Applications__c> oldAppMap  = new Map<id,genesis__Applications__c>([select id,name,genesis__Account__r.RecordTypeId,Sub_Stage__c,Record_Type_Name__c,PMin__c,PMax1__c,PMax__c,Nmax__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1]);
        genApp.Id=oldAppMap.values()[0].Id;

        genApp.Sub_Stage__c = 'Work Information Captured';
        genApp.PMin__c = 10000;
        genApp.PMax1__c = 15000;
        genApp.EMI_Max__c = 20000;
        genApp.Nmax__c = 16;
        update genApp;
        System.debug('genApp after>>> '+genApp);

        List<genesis__Applications__c> newAppList = new List<genesis__Applications__c>();
        newAppList.add(genApp);

        Map<Id, genesis__Applications__c> newAppMap = new Map<Id,genesis__Applications__c>(newAppList);

        Test.startTest();
        RejectionScenarioHandeller.RejectioMethodPersonalLoan(newAppMap,oldAppMap);
        Test.stopTest();

        }

        //Low Nmax rejection scenario for 4 wheeler
        @isTest
        public static void rejectionMethodForVL4(){
        System.debug('rejectionMethodForVL4 >>>');
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;

        genesis__Applications__c genApp = new genesis__Applications__c();

        Map<id,genesis__Applications__c> oldAppMap  = new Map<id,genesis__Applications__c>([select id,name,genesis__Account__r.RecordTypeId,Sub_Stage__c,Record_Type_Name__c,PMin__c,PMax1__c,PMax__c,Nmax__c from genesis__Applications__c where Record_Type_Name__c = 'VL4W' LIMIT 1]);
        genApp.Id=oldAppMap.values()[0].Id;

        genApp.Sub_Stage__c = 'Work Information Captured';
        genApp.PMin__c = 10000;
        genApp.PMax1__c = 15000;
        genApp.EMI_Max__c = 20000;
        genApp.Nmax__c = 10;
        update genApp;
        System.debug('genApp after>>> '+genApp);

        List<genesis__Applications__c> newAppList = new List<genesis__Applications__c>();
        newAppList.add(genApp);

        Map<Id, genesis__Applications__c> newAppMap = new Map<Id,genesis__Applications__c>(newAppList);

        Test.startTest();
        RejectionScenarioHandeller.RejectioMethodPersonalLoan(newAppMap,oldAppMap);
        Test.stopTest();

        }

        //low Net_Monthly_Income__c rejection scenario for 4 wheeler
        @isTest
        public static void rejectionMethodForVL5(){
        System.debug('rejectionMethodForVL5 >>>');
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;

        genesis__Applications__c genApp = new genesis__Applications__c();

        Map<id,genesis__Applications__c> oldAppMap  = new Map<id,genesis__Applications__c>([select id,name,genesis__Account__r.RecordTypeId,Sub_Stage__c,Record_Type_Name__c,PMin__c,PMax1__c,PMax__c,Nmax__c from genesis__Applications__c where Record_Type_Name__c = 'VL4W' LIMIT 1]);
        genApp.Id=oldAppMap.values()[0].Id;

        genApp.Sub_Stage__c = 'Work Information Captured';
        genApp.PMin__c = 10000;
        genApp.PMax1__c = 15000;
        genApp.EMI_Max__c = 20000;
        genApp.Nmax__c = 40;
        update genApp;
        System.debug('genApp after>>> '+genApp);

        List<genesis__Applications__c> newAppList = new List<genesis__Applications__c>();
        newAppList.add(genApp);

        Map<Id, genesis__Applications__c> newAppMap = new Map<Id,genesis__Applications__c>(newAppList);

        Test.startTest();
        RejectionScenarioHandeller.RejectioMethodPersonalLoan(newAppMap,oldAppMap);
        Test.stopTest();

        }

        //vehicle rejection scenario for 2 wheeler
        @isTest
        public static void rejectionMethodForVL6(){
        System.debug('rejectionMethodForVL6 >>>');
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;

        genesis__Applications__c genApp = new genesis__Applications__c();

        Map<id,genesis__Applications__c> oldAppMap  = new Map<id,genesis__Applications__c>([select id,name,genesis__Account__r.RecordTypeId,Sub_Stage__c,Record_Type_Name__c,PMin__c,PMax1__c,PMax__c,Nmax__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1]);

        clcommon__Collateral__c coll = [select id,ExshowRoomPrice_Api__c from clcommon__Collateral__c where genesis__Application__c=:oldAppMap.values()[0].Id limit 1];
        coll.ExshowRoomPrice_Api__c = null;
        update coll;

        genApp.Id=oldAppMap.values()[0].Id;

        genApp.Sub_Stage__c = 'Vehicle details captured';
        genApp.PMin__c = 10000;
        genApp.PMax1__c = 15000;
        genApp.EMI_Max__c = 20000;
        genApp.Nmax__c = 40;
        update genApp;
        System.debug('genApp after>>> '+genApp);

        List<genesis__Applications__c> newAppList = new List<genesis__Applications__c>();
        newAppList.add(genApp);

        Map<Id, genesis__Applications__c> newAppMap = new Map<Id,genesis__Applications__c>(newAppList);

        Test.startTest();
        RejectionScenarioHandeller.RejectioMethodPersonalLoan(newAppMap,oldAppMap);
        Test.stopTest();

        }

        //braj comment:Added test method of PL to increase code coverage
        @isTest
        public static void testRejectionHandlerForPL(){
            System.debug('testRejectionHandlerForPL >>>');
            Trigger_Setting__c cs = new Trigger_Setting__c();
            cs.Execute_Application_Trigger__c=false;
            insert cs;

            genesis__Applications__c genApp = new genesis__Applications__c();
            Map<id,genesis__Applications__c> oldAppMap  = new Map<id,genesis__Applications__c>([select id,name,genesis__Account__c,Sub_Stage__c,Record_Type_Name__c,PMin__c,PMax1__c,PMax__c,Nmax__c from genesis__Applications__c where Record_Type_Name__c = 'VL4W' LIMIT 1]);

            genesis__Application_Parties__c gap = new genesis__Application_Parties__c();
            gap.genesis__Application__c = oldAppMap.values()[0].Id;
            gap.genesis__Party_Account_Name__c=oldAppMap.values()[0].genesis__Account__c;
            gap.genesis__Party_Type__c = Constants.PRIMARY_APP;//primary,co-borrower
            gap.Active__c =true;
            gap.Financial_Applicant__c=true;
            gap.Existing_Emis__c=7000;
            gap.Net_Monthly_Income__c=30000;
            gap.Agriculture2__c=6000;
            gap.CIBIL_Scores__c = 800;
            gap.Employment_Types__c = 'Salaried';
            gap.Financial_Applicant__c = true;
            Insert gap;
            
            Id rectType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
            genApp.Id=oldAppMap.values()[0].Id;
            genApp.RecordTypeId = rectType;
            genApp.Sub_Stage__c = 'Work Information Captured';
            update genApp;


            Map<Id, genesis__Applications__c> newAppMap = new Map<Id,genesis__Applications__c>(new List<genesis__Applications__c>{genApp});

            System.debug('oldAppMap>>>'+oldAppMap);
            System.debug('newAppMap>>>'+newAppMap);
            Test.startTest();
            RejectionScenarioHandeller.RejectioMethodPersonalLoan(newAppMap,oldAppMap);
            Test.stopTest();
        }

        //braj comment:Added test method of LAP to increase code coverage
        @isTest
        public static void testRejectionHandlerForLAP(){
            System.debug('testRejectionHandlerForLAP >>>');
            Trigger_Setting__c cs = new Trigger_Setting__c();
            cs.Execute_Application_Trigger__c=false;
            insert cs;

            genesis__Applications__c genApp = new genesis__Applications__c();
            Map<id,genesis__Applications__c> oldAppMap  = new Map<id,genesis__Applications__c>([select id,name,genesis__Account__r.RecordTypeId,Sub_Stage__c,Record_Type_Name__c,PMin__c,PMax1__c,PMax__c,Nmax__c from genesis__Applications__c where Record_Type_Name__c = 'VL4W' LIMIT 1]);
            
            Id rectType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
            genApp.Id=oldAppMap.values()[0].Id;
            genApp.RecordTypeId = rectType;
            genApp.Sub_Stage__c = 'Property information captured';
            update genApp;

            List<genesis__Applications__c> appLst = new List<genesis__Applications__c>();
            appLst.add(genApp);

            Map<Id, genesis__Applications__c> newAppMap = new Map<Id,genesis__Applications__c>(appLst);

            System.debug('oldAppMap>>>'+oldAppMap);
            System.debug('newAppMap>>>'+newAppMap);
            Test.startTest();
            RejectionScenarioHandeller.ClearRejectscenario(appLst,oldAppMap);
            RejectionScenarioHandeller.RejectioMethod(newAppMap,newAppMap);
            Test.stopTest();
        }

}