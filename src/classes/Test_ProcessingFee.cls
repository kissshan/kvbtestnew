@isTest
public class Test_ProcessingFee {
@isTest
    public static void method1(){
   
        Account acc=new Account();
        acc.FirstName='test';
        acc.LastName='test2';
        acc.Phone='70030841389';
        insert acc;
        
        Branch_Master__c bb=new Branch_Master__c();
        bb.CODCCBRN__c='1857';
        bb.State__c='Kerala';
        insert bb;
        
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL4W').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Terms and Conditions Accepted';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.genesis__Loan_Amount__c=10000;
        appObj.Sanction_Authority_Limit__c=20000;
        appObj.Branch_Code__c='1857';
        insert appObj;

        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Application__c = appObj.id;
        genAppPart.genesis__Party_Account_Name__c = acc.id;
        genAppPart.genesis__Party_Type__c = 'Co-Borrower';
        genAppPart.Status__c = 'Pending';
        genAppPart.Signatories__c = true;
        genAppPart.Guarantor__c = true;
        insert genAppPart;
        Set<id> Appidset=new set<id>();
        Appidset.add(appObj.id);
        
        Set<id> Accidset=new set<id>();
        Accidset.add(acc.id);
        ProcessingFee.calculateFeeList(Appidset,Accidset);
        ProcessingFee.dynamicCalStampDuty(100000,'Andhra Pradesh');
    }
    
    @isTest
    public static void method2(){
   
        Account acc=new Account();
        acc.FirstName='test';
        acc.LastName='test2';
        acc.Phone='70030841389';
        insert acc;
        
        Branch_Master__c bb=new Branch_Master__c();
        bb.CODCCBRN__c='1857';
        bb.State__c='Kerala';
        insert bb;
        
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Terms and Conditions Accepted';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.genesis__Loan_Amount__c=10000;
        appObj.Sanction_Authority_Limit__c=20000;
        appObj.Branch_Code__c='1857';
        insert appObj;

        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Application__c = appObj.id;
        genAppPart.genesis__Party_Account_Name__c = acc.id;
        genAppPart.genesis__Party_Type__c = 'Co-Borrower';
        genAppPart.Status__c = 'Pending';
        genAppPart.Signatories__c = true;
        genAppPart.Guarantor__c = true;
        insert genAppPart;
        Set<id> Appidset=new set<id>();
        Appidset.add(appObj.id);
        
        Set<id> Accidset=new set<id>();
        Accidset.add(acc.id);
        ProcessingFee.calculateFeeList(Appidset,Accidset);
        ProcessingFee.dynamicCalStampDuty(100000,'Gujarat');
        
    }
    
     @isTest
    public static void method3(){
   
        Account acc=new Account();
        acc.FirstName='test';
        acc.LastName='test2';
        acc.Phone='70030841389';
        insert acc;
        
        Branch_Master__c bb=new Branch_Master__c();
        bb.CODCCBRN__c='1857';
        bb.State__c='Kerala';
        insert bb;
        
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Terms and Conditions Accepted';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.genesis__Loan_Amount__c=10000;
        appObj.Sanction_Authority_Limit__c=20000;
        appObj.Branch_Code__c='1857';
        insert appObj;

        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Application__c = appObj.id;
        genAppPart.genesis__Party_Account_Name__c = acc.id;
        genAppPart.genesis__Party_Type__c = 'Co-Borrower';
        genAppPart.Status__c = 'Pending';
        genAppPart.Signatories__c = true;
        genAppPart.Guarantor__c = true;
        insert genAppPart;
        Set<id> Appidset=new set<id>();
        Appidset.add(appObj.id);
        
        Set<id> Accidset=new set<id>();
        Accidset.add(acc.id);
        ProcessingFee.calculateFeeList(Appidset,Accidset);
        ProcessingFee.dynamicCalStampDuty(100000,'Maharashtra');
    }
    
    @isTest
    public static void method4(){
   
        Account acc=new Account();
        acc.FirstName='test';
        acc.LastName='test2';
        acc.Phone='70030841389';
        insert acc;
        
        Branch_Master__c bb=new Branch_Master__c();
        bb.CODCCBRN__c='1857';
        bb.State__c='Kerala';
        insert bb;
        
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Loan Pre - Approved STP';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.genesis__Loan_Amount__c=10000;
        appObj.Sanction_Authority_Limit__c=20000;
        appObj.Branch_Code__c='1857';
        appObj.Flat_No__c='256';
        insert appObj;

        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Application__c = appObj.id;
        genAppPart.genesis__Party_Account_Name__c = acc.id;
        genAppPart.genesis__Party_Type__c = 'Co-Borrower';
        genAppPart.Status__c = 'Pending';
        genAppPart.Signatories__c = true;
        genAppPart.Guarantor__c = true;
        insert genAppPart;
        Set<id> Appidset=new set<id>();
        Appidset.add(appObj.id);
        
        List<genesis__Applications__c> applist=new List<genesis__Applications__c>();
        applist.add(appObj);
        Map<Id,genesis__Applications__c> mapval=new Map<id,genesis__Applications__c>();
        mapval.put(appObj.id,appObj);
        Set<id> Accidset=new set<id>();
        Accidset.add(acc.id);
        ProcessingFee.calculateFeeList(Appidset,Accidset);
        ProcessingFee.callPropertyDetails(applist,mapval);
        ProcessingFee.dynamicCalStampDuty(100000,'Karnataka');
 //       ProcessingFee.RejectedCheck(mapval);
         
    }
    
     @isTest
    public static void method5(){
   
        Account acc=new Account();
        acc.FirstName='test';
        acc.LastName='test2';
        acc.Phone='70030841389';
        insert acc;
        
        Branch_Master__c bb=new Branch_Master__c();
        bb.CODCCBRN__c='1857';
        bb.State__c='Kerala';
        insert bb;
        
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL2W').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Terms and Conditions Accepted';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.genesis__Loan_Amount__c=10000;
        appObj.Sanction_Authority_Limit__c=20000;
        appObj.Branch_Code__c='1857';
        insert appObj;

        clcommon__Collateral__c colobj=VL_Test_Utility.createcollateral(appObj.Id,WS_UpdatemandatoryFieldsAcc.getRandomExternalIdForCollateral());
        insert colobj;
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Application__c = appObj.id;
        genAppPart.genesis__Party_Account_Name__c = acc.id;
        genAppPart.genesis__Party_Type__c = 'Co-Borrower';
        genAppPart.Status__c = 'Pending';
        genAppPart.Signatories__c = true;
        genAppPart.Guarantor__c = true;
        insert genAppPart;
        Set<id> Appidset=new set<id>();
        Appidset.add(appObj.id);
        
        Set<id> Accidset=new set<id>();
        Accidset.add(acc.id);
        ProcessingFee.calculateFeeList(Appidset,Accidset);
        
    }
    @isTest
    public static void methodwithtrigger(){
        Flat_Master__c ff=new  Flat_Master__c();
         ff.Flat_No_House_No__c='296';
        insert ff;
         Account acc=new Account();
        acc.FirstName='test';
        acc.LastName='test2';
        acc.Phone='70030841389';
        insert acc;

        
        Trigger_Setting__c custmsetting=new Trigger_Setting__c();
        custmsetting.Execute_Application_Trigger__c=true;
        insert custmsetting;
        ApplicationTriggerHandler.IsFirstRun=true;
        
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId(); 
        genesis__Applications__c appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c='1857';//'1857'
        appObj.genesis__Account__c = acc.id;
        appObj.Sub_Stage__c = 'Application Created';
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.BankYear__c=5;
        appObj.Max_CIBIL_Score__c=755;
        appObj.Active__c = true;
        appObj.Weighted_Average_Income__c=25;
        appObj.genesis__Loan_Amount__c=10000;
        appObj.Sanction_Authority_Limit__c=20000;
        appObj.Branch_Code__c='1857';
        appObj.Flat_No__c='256';
        insert appObj;
        
        genesis__Applications__c appObj2  =  new genesis__Applications__c();
        appObj2.id=appObj.id;
        appObj2.Flat_No__c='296';
        appObj2.Sub_Stage__c = 'Loan Pre - Approved STP';
      //  update appObj2;
    }
    
    ////added new 
    @isTest
    public static void method6(){
         Trigger_Setting__c cs = new Trigger_Setting__c();
         cs.Execute_Application_Trigger__c=true;
         insert cs;
        
             genesis__Applications__c appnew=TestUtility.intialSetUp('HomeLoan',true);
        genesis__Applications__c app =[select id,genesis__Loan_Amount__c,Sub_Stage__c,Loan_Purpose__c from genesis__Applications__c where id=:appnew.id];
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       
      
         app.Loan_Purpose__c='home';
         app.Flat_No__c = '302';
         app.Sub_Stage__c = 'Loan Sanctioned Non-STP';
         app.genesis__Loan_Amount__c=50000;
         app.RecordTypeId=RecordTypeIdgenApp;
         update app;
         List<genesis__Applications__c> applist=new List<genesis__Applications__c>();
         applist.add(app);
         Map<Id,genesis__Applications__c> AppMap=new Map<Id,genesis__Applications__c>();
         AppMap.put(app.Id, app);
        
         genesis__Applications__c appold=app;
         appold.Loan_Purpose__c='car';
         appold.genesis__Loan_Amount__c=90000;
        appold.Flat_No__c = '402';
        appold.Sub_Stage__c = 'Loan Requirement Captured';
       //   appold.Sub_Stage__c = 'SI details captured'; 
        //appold.Pre_Renewal_Checklist__c = 'Completed';
         update appold;
          List<genesis__Applications__c> applistold=new List<genesis__Applications__c>();
         applistold.add(appold);
         Map<Id,genesis__Applications__c> AppMapold=new Map<Id,genesis__Applications__c>();
         AppMapold.put(appold.Id, appold);
        
        Project_Master__c proMas = new Project_Master__c();
        proMas.City_Town_Village__c = 'Bang';
        proMas.Address_Line_1__c = 'Kormangala';
        proMas.Address_Line_2__c = 'ET Marlabs';
        proMas.Address_Line_3__c = 'India';
        proMas.State__c = 'karnataka';
        proMas.Pin_Code__c = '560029';
        proMas.Boundary_East__c = '2';
        proMas.Boundary_North__c = '2';
        proMas.Boundary_South__c = '2';
        proMas.Boundary_West__c = '2';
        proMas.Project_Name__c = 'KVB Property';
        proMas.Location_Of_The_Proeprty__c = 'Metro';
        proMas.Extent_Area_Sq_Feet__c = '5';
        proMas.District__c = 'Blr';
        proMas.Project_Code__c = '11';
        INSERT proMas;
        //ProjectCode__c     proCode = new ProjectCode__c();
       // proCode.
        string flatids = appold.id;
        Flat_Master__c flatMas = new Flat_Master__c();
        flatMas.Survey_number__c = '123';
        flatMas.Flat_No_House_No__c = flatids;//'402';
        flatMas.ProjectCode__c = proMas.Id;
        flatMas.UDS__c = 20;
        flatMas.Floor_No__c = '1';
        flatMas.Recommended_Rate_Of_Flat_House_Rs_Sq__c = 5000;
        flatMas.Built_Up_Area_Sq_Feet__c = '123';
        flatMas.Date_Of_Valuation_Update__c = system.today();
        flatMas.Market_Value_Of_Property_Rs__c = 5000;
        flatMas.Tower_Construction_Start_Date__c = system.today();
        flatMas.Tower_Construction_End_Date__c = system.today();
        flatMas.Stage_Of_Construction__c = 1;
        flatMas.Valuers_Name__c = 'TestVal';
        //flatMas.Market_Value_Of_the_Building__c = 2000;
       // flatMas.Market_Value_Of_The_Land__c = 3000;
        flatMas.MAST_Of_Property__c = 'KVB';
        flatMas.Presence_of_Amenities__c = 'TestAmen';
        INSERT flatMas;
        ProcessingFee.CallCalculatefee(applist,AppMap,applistold,AppMapold);
        
    }
    
    ///add new
    @isTest
    public static void method7(){
         Trigger_Setting__c cs = new Trigger_Setting__c();
         cs.Execute_Application_Trigger__c=true;
         insert cs;
        
         genesis__Applications__c appnew=TestUtility.intialSetUp('HomeLoan',true);
        genesis__Applications__c app =[select id,genesis__Loan_Amount__c,Sub_Stage__c,Loan_Purpose__c from genesis__Applications__c where id=:appnew.id];
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       
      
         app.Loan_Purpose__c='home';
         app.Flat_No__c = '302';
         app.Sub_Stage__c = 'Loan Sanctioned Non-STP';
         app.genesis__Loan_Amount__c=50000;
         app.RecordTypeId=RecordTypeIdgenApp;
         update app;
         List<genesis__Applications__c> applist=new List<genesis__Applications__c>();
         applist.add(app);
         Map<Id,genesis__Applications__c> AppMap=new Map<Id,genesis__Applications__c>();
         AppMap.put(app.Id, app);
        
         genesis__Applications__c appold=app;
         appold.Loan_Purpose__c='car';
         appold.genesis__Loan_Amount__c=90000;
        appold.Flat_No__c = '402';
        appold.Sub_Stage__c = 'Loan Requirement Captured';
       //   appold.Sub_Stage__c = 'SI details captured'; 
        //appold.Pre_Renewal_Checklist__c = 'Completed';
         update appold;
          List<genesis__Applications__c> applistold=new List<genesis__Applications__c>();
         applistold.add(appold);
         Map<Id,genesis__Applications__c> AppMapold=new Map<Id,genesis__Applications__c>();
         AppMapold.put(appold.Id, appold);
        
        Project_Master__c proMas = new Project_Master__c();
        proMas.City_Town_Village__c = 'Bang';
        proMas.Address_Line_1__c = 'Kormangala';
        proMas.Address_Line_2__c = 'ET Marlabs';
        proMas.Address_Line_3__c = 'India';
        proMas.State__c = 'karnataka';
        proMas.Pin_Code__c = '560029';
        proMas.Boundary_East__c = '2';
        proMas.Boundary_North__c = '2';
        proMas.Boundary_South__c = '2';
        proMas.Boundary_West__c = '2';
        proMas.Project_Name__c = 'KVB Property';
        proMas.Location_Of_The_Proeprty__c = 'Metro';
        proMas.Extent_Area_Sq_Feet__c = '5';
        proMas.District__c = 'Blr';
        proMas.Project_Code__c = '11';
        INSERT proMas;
        //ProjectCode__c     proCode = new ProjectCode__c();
       // proCode.
        string flatids = appold.id;
        Flat_Master__c flatMas = new Flat_Master__c();
        flatMas.Survey_number__c = '123';
        flatMas.Flat_No_House_No__c = '402';//'402';
        flatMas.ProjectCode__c = proMas.Id;
        flatMas.UDS__c = 20;
        flatMas.Floor_No__c = '1';
        flatMas.Recommended_Rate_Of_Flat_House_Rs_Sq__c = 5000;
        flatMas.Built_Up_Area_Sq_Feet__c = '123';
        flatMas.Date_Of_Valuation_Update__c = system.today();
        flatMas.Market_Value_Of_Property_Rs__c = 5000;
        flatMas.Tower_Construction_Start_Date__c = system.today();
        flatMas.Tower_Construction_End_Date__c = system.today();
        flatMas.Stage_Of_Construction__c = 1;
        flatMas.Valuers_Name__c = 'TestVal';
        //flatMas.Market_Value_Of_the_Building__c = 2000;
       // flatMas.Market_Value_Of_The_Land__c = 3000;
        flatMas.MAST_Of_Property__c = 'KVB';
        flatMas.Presence_of_Amenities__c = 'TestAmen';
        INSERT flatMas;
       // ProcessingFee.CallCalculatefee(applist,AppMap,applistold,AppMapold);
        set<string> flatset=new set<string>();
        flatset.add('402');
        flatset.add('502');
        ProcessingFee.PropertyDetails(applistold,flatset);
    }
}