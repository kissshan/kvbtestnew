/*
* Description : WS_FetchSMEInfo_Test
* Author       : Yadagiri
*/
@isTest
public class Test_WS_FetchSMEInfo {
   
   
    
}
/*
   @testSetup
    public static void setupmethod(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Is_KVB_Director__c=True;
        acc.Constitution__c='LLP';
        insert acc;
        
        
        
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acct= SME_TestUtil.createparentAccount('Test FName','Test LName','nagaram','12345','SFO','test@yahoo.com','1234567','12345678','Mahesh','Father in law','KVB');
        acct.RecordTypeID=recordTypeId ;
        acct.Is_KVB_Director__c=True;
        insert acct;
        
        String businessaccrecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account buacct= SME_TestUtil.createAccount('AB Power','Guntur','1210010','Pawan','Brother in law','SBI');
        buacct.RecordTypeID=businessaccrecordTypeId ;
        buacct.Is_KVB_Director__c=True;
        insert buacct;
        
        genesis__Applications__c genApps=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        insert genApps;
        
        genesis__Applications__c busigenApps=SME_TestUtil.createApplication('KB23',buacct.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        insert busigenApps;
        
        M68_Balance_Sheet_Analysis__c m68BalsheetAnal =SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68',acc.Id,'Perfios','Estimated','Apr-Feb','2018-19',123.45);
        insert m68BalsheetAnal;
        
        M68_Balance_Sheet_Analysis__c m68BalsheetAnals = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68',acc.Id,'Perfios','Projected','Apr-Feb','2019-20',123.45);
        insert m68BalsheetAnals;
        
        M68_Balance_Sheet_Analysis__c ytdm68BalsheetAnalsy = SME_TestUtil.createM68BalSheetAnalysis('Test Data M68bal',acc.Id,'Perfios','YTD','Apr-Feb','2019-20',123.45);
        insert  ytdm68BalsheetAnalsy;
        
        M68_Balance_Sheet_Analysis__c ytdm68BalsheetAnalsyc = SME_TestUtil.createM68BalSheetAnalysis('Test Data M68Ansyc',acc.Id,'Perfios','YTD','Apr-Feb','2018-19',123.45);
        insert ytdm68BalsheetAnalsyc;
        
        M68_Balance_Sheet_Analysis__c m68BalsheetAnalsys = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68BalAnalsys',acc.Id,'Probe 42','Actual','Apr-Feb','2017-18',123.45);
        insert m68BalsheetAnalsys;
        
        M68_Balance_Sheet_Analysis__c m68BalsheetAnalsis = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68BalAnalsis',acc.Id,'Probe 42','Actual','Apr-Feb','2016-17',123.45);
        insert m68BalsheetAnalsis;
        
        M68_Balance_Sheet_Analysis__c m68BalsheetAnalysis = SME_TestUtil.createM68BalSheetAnalysis('Test Data for m68BalsheetAnalysis',acc.Id,'Probe 42','Actual','Apr-Feb','2015-16',123.45);
        insert m68BalsheetAnalysis;
        
        Sundry_Creditors__c suncredit = SME_TestUtil.createSundryCreditors(acc.Id,'0-30',34.56,'2016-17','Test Trade Creditors');
        insert suncredit;
        
        Sundry_Creditors__c suncreditr = SME_TestUtil.createSundryCreditors(acc.Id,'31-60',34.56,'2017-18','Test Trade Creditors-1');
        insert suncreditr;
        
        Sundry_Creditors__c suncreditrs = SME_TestUtil.createSundryCreditors(acc.Id,'61-90',34.56,'2018-19','Test Trade Creditors-2');
        insert suncreditrs;
        
        Debtors__c db = SME_TestUtil.createDeb(acc.Id,'Test Customer test','0-30',34.56,'2017-18');
        insert db;
        
        Debtors__c dbt = SME_TestUtil.createDeb(acc.Id,'Test Customer','31-60',34.56,'2018-19');
        insert dbt;
        
        Debtors__c dbtr = SME_TestUtil.createDeb(acc.Id,'Test Customer-2','31-60',34.56,'2016-17');
        insert dbtr;
        
       
    }
   
    @isTest
    public static void method1(){
        Test.startTest();
        
        Account acc = [select id,Name,Branch_Code__c,CBS_Customer_ID__c,Name_Of_Director_Related_To__c,Relationship__c,Bank_name__c,Is_KVB_Director__c,Constitution__c from Account where name='HP Agencies'];
        Account acct =[select id,FirstName,LastName,RecordTypeID,PersonHomePhone,Is_KVB_Director__c,Bank_name__c,Relationship__c,Name_Of_Director_Related_To__c,PersonMobilePhone,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonEmail from Account where FirstName='Test FName'];
       Account buacct =[select id,FirstName,LastName,RecordTypeID,PersonHomePhone,Is_KVB_Director__c,Bank_name__c,Relationship__c,Name_Of_Director_Related_To__c,PersonMobilePhone,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonEmail from Account where Name='AB Power'];

        System.debug('@@@@@@@@@@@'+acc.CBS_Customer_ID__c);
        Contact  con = SME_TestUtil.createContact('Siva',acc.ID,'PPT123','Female','Algeria','Pavan','Married');
        con.Spouse_Name__c='Jyo';
        con.Caste__c='General';
        con.Residential_Status__c='Good';
        insert con;

        Id genAppRectype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Term Loan').getRecordTypeId();
        
        genesis__Applications__c genApps=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApps.RecordTypeId=genAppRectype;
        genApps.Application_to_close__c=True;
        genApps.Type__c='EAE';
        genApps.Active__c=true;
        genApps.Renewal_Due_Date__c=System.today();
        insert genApps;
        
        Id bugenAppRectype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        System.debug('bugenAppRectype'+bugenAppRectype);
        genesis__Applications__c bugenApps=SME_TestUtil.createApplication('KB23',buacct.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        bugenApps.RecordTypeId=bugenAppRectype;
        bugenApps.Application_to_close__c=True;
        bugenApps.Type__c='EAE';
        bugenApps.Active__c=true;
        bugenApps.Renewal_Due_Date__c=System.today();
        insert bugenApps;
        
        clcommon__Collateral_Type__c colltype= SME_TestUtil.createCollType('Test Collateral');
        insert colltype;
        
        Id prodRectype = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();

        clcommon__CL_Product__c clProducts=SME_TestUtil.createclproduct('Test product','KVB11','Funded');
        clProducts.Active__c=true;
        clProducts.RecordtypeId=prodRectype;
        clProducts.clcommon__Primary_Collateral_Type__c=colltype.Id;
        insert clProducts;  
        
        Facility__c facil= SME_TestUtil.createFacility(genApps.Id,clProducts.Id,'KVB2344',32423.2);
        facil.Existing_Limit__c=3432.22;
        facil.Existing_Limit__c=2323.2;
        facil.Over_Due__c=23.3;
        facil.Existing_Rate__c=3.2;
        facil.RecordTypeId=Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        insert facil;
        
      
        
        Id stExam = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        // Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB24',acc.Id,'MOD Applications','FI Approved','FINANCIAL_SECTION');
        genApp.RecordTypeId=stExam;
        genApp.Application_to_close__c=True;
        genApp.Type__c='EAE';
        genApp.Active__c=true;
        genApp.Renewal_Due_Date__c=System.today();
        insert genApp;
        
        genApp = [select id,recordTypeId from genesis__Applications__c limit 1];
        genApp.recordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();  
        update genApp;
        
        
        Facility__c fac= SME_TestUtil.createFacility(genApps.Id,clProducts.Id,'KVB2344',32423.2);
        fac.Existing_Limit__c=3432.22;
        fac.Existing_Limit__c=2323.2;
        fac.Over_Due__c=23.3;
        fac.Existing_Rate__c=3.2;
        fac.Active__c=true;
        insert fac;
        
        clcommon__Collateral__c clColl = SME_TestUtil.createcollateral(genApp.Id,'Test collaeral','Vacant Land');
        clColl.clcommon__Collateral_Name__c='Test Collateral';
        clColl.Nature_of_Property__c='Own property';
        clColl.SurveyKhasraKhataPatta_No__c='S56';
        clColl.FE_Created__c=true;
        insert clColl;
        
        clcommon__Collateral__c clColl2 = SME_TestUtil.createcollateral(genApp.Id,'Test Colleral','Vacant Land');
        clColl2.clcommon__Collateral_Name__c='Test Collateral';
        clColl2.Nature_of_Property__c='Own property';
        clColl2.SurveyKhasraKhataPatta_No__c='S56';
        clColl2.FE_Created__c=true;
        insert clColl2;
        
        genesis__Application_Collateral__c genAppColl = new genesis__Application_Collateral__c();
        genAppColl = SME_TestUtil.createAppCollateral(acc.Id,genApp.Id,fac.Id,clColl.Id);
        genAppColl.Security_Type__c='Primary Securities';
        genAppColl.genesis__Pledge_Amount__c=45.45;
        insert genAppColl;
        
        genesis__Application_Collateral__c genAppCollat = new genesis__Application_Collateral__c();
        genAppCollat = SME_TestUtil.createAppCollateral(acc.Id,genApp.Id,fac.Id,clColl2.Id);
        genAppCollat.Security_Type__c='Collateral Securities';
        genAppCollat.genesis__Pledge_Amount__c=35.45;
        insert genAppCollat;
        
        Id genAppDocs = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        // Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        genesis__Applications__c genAppDoc=SME_TestUtil.createApplication('KB24',acc.Id,'MOD Applications','FI Approved','FINANCIAL_SECTION');
        genAppDoc.RecordTypeId=genAppDocs;
        genAppDoc.Application_to_close__c=True;
        genAppDoc.Type__c='EAE';
        genAppDoc.Active__c=true;
        genAppDoc.Renewal_Due_Date__c=System.today();
        insert genAppDoc;
        
        genAppDoc = [select id,recordTypeId from genesis__Applications__c limit 1];
        genAppDoc.recordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();  
        update genAppDoc;
        
        genesis__Application_Document_Category__c genAppDocCat= new genesis__Application_Document_Category__c();
        genAppDocCat.Applicant__c=acc.Id;
        genAppDocCat.genesis__Application__c=genAppDoc.Id;
        genAppDocCat.Name='Individual ITR';
        insert genAppDocCat;
        
         
        genesis__Application_Document_Category__c genAppDocCatquery= new genesis__Application_Document_Category__c();
        genAppDocCatquery.Applicant__c=acc.Id;
        genAppDocCatquery.genesis__Application__c=genAppDoc.Id;
        genAppDocCatquery.Name='Query Followup';
        insert genAppDocCatquery;
        
        genesis__Document_Category__c   genDocCat = new genesis__Document_Category__c  ();
        genDocCat.Document_Category__c='Test Documnet';
        genDocCat.genesis__Category_Name__c='Test name';
        genDocCat.Required_for_Missing_Financial__c=true;
        genDocCat.Doc_Category_No__c=344;
        insert genDocCat;
        
         genesis__Document_Category__c   genDocCatfin = new genesis__Document_Category__c  ();
        genDocCatfin.Document_Category__c='SME Financial Document';
        genDocCatfin.genesis__Category_Name__c='Test name';
        genDocCatfin.Required_for_Missing_Financial__c=true;
        genDocCatfin.Doc_Category_No__c=342;
        insert genDocCatfin;
        
          genesis__Document_Category__c   genDocCatfin2 = new genesis__Document_Category__c  ();
        genDocCatfin2.Document_Category__c='SME Financial Document';
        genDocCatfin2.genesis__Category_Name__c='Test name';
        genDocCatfin2.Required_for_Missing_Financial__c=true;
        genDocCatfin2.Doc_Category_No__c=341;
        insert genDocCatfin2;
        
        genesis__Application_Parties__c genAppPart= new genesis__Application_Parties__c();
        genAppPart.Status__c='Completed';
        genAppPart.Active__c=true;
        genAppPart.genesis__Application__c=genApp.Id;
        genAppPart.genesis__Party_Account_Name__c= acct.Id;
        genAppPart.genesis__Party_Type__c='Partner';
        genAppPart.Is_New__c= true;
        genAppPart.Guarantor__c=true;
        insert genAppPart;
        
        genesis__Application_Parties__c genAppParties= new genesis__Application_Parties__c();
        genAppParties.Status__c='Pending';
        genAppParties.Active__c=false;
        genAppParties.genesis__Application__c=genApp.Id;
        genAppParties.genesis__Party_Account_Name__c= acct.Id;
        genAppParties.genesis__Party_Type__c='Proprietor';
        genAppParties.Is_New__c= true;
        genAppParties.Guarantor__c=true;
        insert genAppParties;
        
        Customer_Feedback__c cusFeedbck = SME_TestUtil.creategenCustFeedback(genApp.Id,'What is your name?','My name is mahesh');
        cusFeedbck.Status__c='Completed';
        insert cusFeedbck;
        
        Digio_Document_ID__c digDoc=SME_TestUtil.createDgioDoc(genApp.Id,'B1 Document');
        digDoc.eSign_Required__c=true;
        digDoc.Guarantor__c=true;
        insert digDoc;
        
        Document_Applicant__c docAppli = SME_TestUtil.createDocAppli(acct.Id,digDoc.Id);
        insert docAppli;
        
        Property__c  prop = new Property__c ();
        prop.Account__c = acct.id;
        prop.Nature_of_Property__c='Residential Land & Building';
        prop.Property_Type__c='Test property';
        prop.Property_Value__c=23.4;
        prop.Survey_No__c='SN123';
        prop.Property_Value__c=23.42;
        prop.Ownership_percentage__c=23.3;
        prop.Door_Number__c='DN-123';
        prop.Nearest_Landmark__c='My Home';
        prop.Area__c='My Area';
        prop.Asset_Type__c='My Assert';
        prop.Property_Street__c='My Street';
        prop.Property_City__c='Chennai';
        prop.Property_State__c='Andra Pradesh';
        prop.Property_Country__c='India';
        prop.Property_Pincode__c='522413';
        prop.Taluk__c='New City';
        insert prop;
        
        Group_Concern__c gc = new Group_Concern__c();
        gc.Group_1__c=acct.Id;
        gc.Type__c='Sister Concern';
        insert gc;
   
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getApplicationDetails'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"LOS_APPLICATION_ID":"","Customer_ID":"1210009","TYPE":"EAE","APP_TYPE":"SME_Adhoc"}');
        RestContext.request = req;
        RestContext.response= res;
        WS_FetchSMEInfo.getApplicationDetail();
        SMELoan_Helper.getCustomAppDetails(genMap,'123423',genApp.Id,new List<Facility__c>{fac});
        LandingPageHelper.excuteListMatchingBatch(new List<genesis__Applications__c> {genApp},True,True);
        LandingPageHelper.preEnhancementChecksTrigger(genApp.Id);
        LandingPageHelper.getAppDetail('1210009');
        LandingPageHelper.excuteBureauBatch(new List<genesis__Applications__c> {genApp});
        SMELoan_Helper.getTitleHolderInfo(genApp.id);
      //  Handle_FetchSMEReq_Response.getKeyPersonDetails(new Customer360view(), new List<genesis__Application_Parties__c>{genAppPart});
        SMELoan_Helper.getCustomAppDetailsUpdate(new Customer360view());
        SMELoan_Helper.getUpdatedFinanialDocWrapper(genMap,new List<genesis__Application_Document_Category__c>{genAppDocCat},new list<String>{'2013-14','2014-15','2015-16'},False);
        SMELoan_Helper.getCustomerWrapper(new List<Account> {acc});
        SMELoan_Helper.getCustomer(genApp.Id,'123423');
        DocumentFetch.checkDocumentCategory2(genApp.Id,new list<String>{'Test Documnet'},new list<String>{'2013-14','2014-15','2015-16'});
        Test.stopTest(); 
        
    }
    
    @isTest
    public static void method2(){
        
        Account acc = [select id,Name,Branch_Code__c,CBS_Customer_ID__c,Name_Of_Director_Related_To__c,Relationship__c,Bank_name__c,Is_KVB_Director__c,Constitution__c from Account where name='HP Agencies'];
        Account acct =[select id,FirstName,LastName,RecordTypeID,PersonHomePhone,Is_KVB_Director__c,Bank_name__c,Relationship__c,Name_Of_Director_Related_To__c,PersonMobilePhone,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonEmail from Account where FirstName='Test FName'];
        
        Id stExam = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Account__c=acc.Id;
        genApp.Application_Stage__c='Enhancement/New Loan under process';
        genApp.RecordTypeId=stExam;
        genApp.Renewal_Due_Date__c=System.today();
        genApp.Application_to_close__c=True;
        genApp.Type__c='ETB-WC';
        genApp.Active__c=true;
        insert genApp;
        
        Facility__c fac= new Facility__c();
        fac.RecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        fac.Application__c=genApp.Id;
        fac.Account_Number__c='KVB2344';
        fac.Existing_Limit__c=3432.22;
        fac.Balance_Outstandings__c=32423.2;
        fac.Existing_Limit__c=2323.2;
        fac.Over_Due__c=23.3;
        fac.Existing_Rate__c=3.2;
        fac.Active__c=true;
        insert fac;
        
        clcommon__Collateral__c clColl = new clcommon__Collateral__c();
        clColl= SME_TestUtil.createcollateral(genApp.Id,'test Colleral','Vacant Land');
        clColl.clcommon__Collateral_Name__c='Test Collateral';
        insert clColl;
        
        genesis__Application_Collateral__c genAppColl = new genesis__Application_Collateral__c();
        genAppColl = SME_TestUtil.createAppCollateral(acc.Id,genApp.Id,fac.Id,clColl.Id);
        genAppColl.Security_Type__c='Collateral Securities';
        genAppColl.genesis__Pledge_Amount__c=35.45;
        insert genAppColl;
        
        
        genesis__Application_Parties__c genAppPart= new genesis__Application_Parties__c();
        genAppPart.Status__c='Completed';
        genAppPart.Active__c=true;
        genAppPart.genesis__Application__c=genApp.Id;
        genAppPart.genesis__Party_Account_Name__c= acct.Id;
        genAppPart.genesis__Party_Type__c='Partner';
        genAppPart.Is_New__c= true;
        genAppPart.Guarantor__c=true;
        
        insert genAppPart;
        
        genesis__Application_Document_Category__c genAppDocCat= new genesis__Application_Document_Category__c();
        genAppDocCat.Applicant__c=acc.Id;
        genAppDocCat.genesis__Application__c=genApp.Id;
        genAppDocCat.Name='Individual ITR';
        insert genAppDocCat;
        
        //genesis__Document_Category__c genDocCat = new genesis__Document_Category__c();
        //genDocCat.Document_Category__c='Test Documnet';
//        insert genDocCat;
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getApplicationDetails'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"LOS_APPLICATION_ID":"","Customer_ID":"1210033","TYPE":"ETB-WC","APP_TYPE":"SME NEW Loan"}');
        RestContext.request = req;
        RestContext.response= res;
        WS_FetchSMEInfo.getApplicationDetail();
        SMELoan_Helper.getCustomAppDetails(genMap,'123423',genApp.Id,new List<Facility__c>{fac});
        LandingPageHelper.excuteListMatchingBatch(new List<genesis__Applications__c> {genApp},True,True);
        LandingPageHelper.preEnhancementChecksTrigger(genApp.Id);
        LandingPageHelper.getAppDetail('1210009');
        LandingPageHelper.excuteBureauBatch(new List<genesis__Applications__c> {genApp});
        SMELoan_Helper.getTitleHolderInfo(genApp.id);
       // Handle_FetchSMEReq_Response.getKeyPersonDetails(new Customer360view(), new List<genesis__Application_Parties__c>{genAppPart});
        SMELoan_Helper.getCustomAppDetailsUpdate(new Customer360view());
        SMELoan_Helper.getUpdatedFinanialDocWrapper(genMap,new List<genesis__Application_Document_Category__c>{genAppDocCat},new list<String>{'2013-14','2014-15','2015-16'},False);
        SMELoan_Helper.getCustomerWrapper(new List<Account> {acc});
        SMELoan_Helper.getCustomer(genApp.Id,'123423');
        Test.stopTest(); 
    }
    @isTest
    public static void method3(){
        
        Account acc = [select id,Name,Branch_Code__c,CBS_Customer_ID__c,Name_Of_Director_Related_To__c,Relationship__c,Bank_name__c,Is_KVB_Director__c,Constitution__c from Account where name='HP Agencies'];
        Account acct =[select id,FirstName,LastName,RecordTypeID,PersonHomePhone,Is_KVB_Director__c,Bank_name__c,Relationship__c,Name_Of_Director_Related_To__c,PersonMobilePhone,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonEmail from Account where FirstName='Test FName'];
        
        Id stExam = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Account__c=acc.Id;
        genApp.Application_Stage__c='New loans - Application created';
        genApp.RecordTypeId=stExam;
        genApp.Renewal_Due_Date__c=System.today();
        genApp.Application_to_close__c=True;
        genApp.Type__c='ETB-CA';
        genApp.Active__c=true;
        insert genApp;
        
        Facility__c fac= new Facility__c();
        fac.RecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        fac.Application__c=genApp.Id;
        fac.Account_Number__c='KVB2344';
        fac.Existing_Limit__c=3432.22;
        fac.Balance_Outstandings__c=32423.2;
        fac.Existing_Limit__c=2323.2;
        fac.Over_Due__c=23.3;
        fac.Existing_Rate__c=3.2;
        fac.Active__c=true;
        insert fac;
        
        clcommon__Collateral__c clColl = new clcommon__Collateral__c();
        clColl= SME_TestUtil.createcollateral(genApp.Id,'Test colleteral','Vacant Land');
        clColl.clcommon__Collateral_Name__c='Test Collateral';
        insert clColl;   
        
        genesis__Application_Collateral__c genAppColl = new genesis__Application_Collateral__c();
        genAppColl = SME_TestUtil.createAppCollateral(acc.Id,genApp.Id,fac.Id,clColl.Id);
        genAppColl.Security_Type__c='Collateral Securities';
        genAppColl.genesis__Pledge_Amount__c=35.45;
        insert genAppColl;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getApplicationDetails'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"LOS_APPLICATION_ID":"","Customer_ID":"1210033","TYPE":"ETB-CA","APP_TYPE":"SME NEW Loan"}');
        RestContext.request = req;
        RestContext.response= res;
        WS_FetchSMEInfo.getApplicationDetail();
        Test.stopTest(); 
    } 
   
    @isTest
    public static void method4(){
        
        Account acc = [select id,Name,Branch_Code__c,CBS_Customer_ID__c,Name_Of_Director_Related_To__c,Relationship__c,Bank_name__c,Is_KVB_Director__c,Constitution__c from Account where name='HP Agencies'];
        Account acct =[select id,FirstName,LastName,RecordTypeID,PersonHomePhone,Is_KVB_Director__c,Bank_name__c,Relationship__c,Name_Of_Director_Related_To__c,PersonMobilePhone,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonEmail from Account where FirstName='Test FName'];
        
        Id stExam = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Account__c=acc.Id;
        genApp.Application_Stage__c='Enhancement/New Loan under process';
        genApp.RecordTypeId=stExam;
        genApp.Renewal_Due_Date__c=System.today();
        genApp.Application_to_close__c=True;
        genApp.Type__c='NTB';
        genApp.Active__c=true;
        insert genApp;
        
        
        Facility__c fac= new Facility__c();
        fac.RecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        fac.Application__c=genApp.Id;
        fac.Account_Number__c='KVB2344';
        fac.Existing_Limit__c=3432.22;
        fac.Balance_Outstandings__c=32423.2;
        fac.Existing_Limit__c=2323.2;
        fac.Over_Due__c=23.3;
        fac.Existing_Rate__c=3.2;
        insert fac;
        
        clcommon__Collateral__c clColl = new clcommon__Collateral__c();
        clColl= SME_TestUtil.createcollateral(genApp.Id,'Test Colleteral','Vacant Land');
        clColl.clcommon__Collateral_Name__c='Test Collateral';
        insert clColl;
        
        genesis__Application_Collateral__c genAppColl = new genesis__Application_Collateral__c();
        genAppColl = SME_TestUtil.createAppCollateral(acc.Id,genApp.Id,fac.Id,clColl.Id);
        genAppColl.Security_Type__c='Collateral Securities';
        genAppColl.genesis__Pledge_Amount__c=35.45;
        insert genAppColl;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getApplicationDetails'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"LOS_APPLICATION_ID":"test_LOS_APPLICATION_ID","Customer_ID":"1210033","TYPE":"NTB","APP_TYPE":"SME NEW Loan"}');
        RestContext.request = req;
        RestContext.response= res;
        WS_FetchSMEInfo.getApplicationDetail();
        Test.stopTest();    
    }
 * */