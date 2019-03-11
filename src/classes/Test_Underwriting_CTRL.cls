@IsTest(seeAllData = false)
private class Test_Underwriting_CTRL{

    @testSetup static void setup() {
        String businessaccrecordTypeId                      = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        String personrecordTypeId                           = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        Account acc                                         = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.RecordTypeID                                    = businessaccrecordTypeId ;
        insert acc;

        Id genAppRecordTypeExceeding                        = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
        Id genAppRecordTypeAdHoc                            = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
        Id genAppRecordTypeEnhancement                      = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();

        genesis__Applications__c appExceeding               = SME_TestUtil.createApplication('KB23',acc.Id,'Exceeding- Application submitted','FI_Approved','COMPANY_DETAILS');
        appExceeding.Application_UI_Stage__c                = 'FinancialUploads';
        appExceeding.RecordTypeId                           = genAppRecordTypeExceeding;
        appExceeding.Active__c                              = true;
        //.Renewal_Due_Date__c                    = System.today();

        insert appExceeding;

        genesis__Applications__c appAdhoc                   = SME_TestUtil.createApplication('KB23',acc.Id,'Adhoc- Application submitted','FI_Approved','COMPANY_DETAILS');
        appAdhoc.Application_UI_Stage__c                    = 'FinancialUploads';
        appAdhoc.RecordTypeId                               = genAppRecordTypeAdHoc;
        appAdhoc.Active__c                                  = true;

        insert appAdhoc;

        genesis__Applications__c appEnhance                 = SME_TestUtil.createApplication('KB23',acc.Id,'Enhancement- Application submitted','FI_Approved','COMPANY_DETAILS');
        appEnhance.Application_UI_Stage__c                  = 'FinancialUploads';
        appEnhance.RecordTypeId                             = genAppRecordTypeEnhancement;
        appEnhance.Active__c                                = true;

        insert appEnhance;

        Digio_Document_ID__c digDoc=SME_TestUtil.createDgioDoc(appExceeding.Id,'B1 Document');
        digDoc.eSign_Required__c=true;
        digDoc.Guarantor__c=true;
        insert digDoc;

        Document_Applicant__c docAppli = SME_TestUtil.createDocAppli(acc.Id,digDoc.Id);
        insert docAppli;

        clcommon__Collateral_Type__c colltype               = SME_TestUtil.createCollType('Test Collateral');
        insert colltype;

        Id prodRectype                                      = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();

        clcommon__CL_Product__c clProducts                  = SME_TestUtil.createclproduct('Test product','KVB11','Funded');
        clProducts.Active__c                                = true;
        clProducts.RecordtypeId                             = prodRectype;
        clProducts.clcommon__Primary_Collateral_Type__c     = colltype.Id;
        insert clProducts;


        Facility__c facil                                   = SME_TestUtil.createFacility(appExceeding.Id,clProducts.Id,'KVB2344',32423.2);
        facil.Existing_Limit__c                             = 3432.22;
        facil.Existing_Limit__c                             = 2323.2;
        facil.Over_Due__c                                   = 23.3;
        facil.Existing_Rate__c                              = 3.2;
        //facil.Type__c                                       = 'Non-Funded';
        facil.RecordTypeId=Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        insert facil;

        clcommon__Collateral__c clColl                      = SME_TestUtil.createcollateral(appExceeding.Id,'Test Collateral','Vacant Land');
        clColl.Nature_of_Property__c                        = 'Own property';
        clColl.SurveyKhasraKhataPatta_No__c                 = 'S56';
        clColl.FE_Created__c                                = true;
        insert clColl;

        clcommon__Collateral__c clColl2                     = SME_TestUtil.createcollateral(appExceeding.Id,'Test Collateral','Vacant Land');
        clColl2.Nature_of_Property__c                       = 'Own property';
        clColl2.SurveyKhasraKhataPatta_No__c                = 'S56';
        clColl2.FE_Created__c                               = true;
        insert clColl2;

        genesis__Application_Collateral__c genAppColl       = new genesis__Application_Collateral__c();
        genAppColl                                          = SME_TestUtil.createAppCollateral(acc.Id,appExceeding.Id,facil.Id,clColl.Id);
        genAppColl.Security_Type__c                         = 'Primary Securities';
        genAppColl.genesis__Pledge_Amount__c                = 45.45;
        insert genAppColl;

        genesis__Application_Collateral__c genAppCollat     = new genesis__Application_Collateral__c();
        genAppCollat                                        = SME_TestUtil.createAppCollateral(acc.Id,appExceeding.Id,facil.Id,clColl2.Id);
        genAppCollat.Security_Type__c                       ='Collateral Securities';
        genAppCollat.genesis__Pledge_Amount__c              =35.45;
        insert genAppCollat;






        M68_Balance_Sheet_Analysis__c m68BalsheetAnal       = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68',acc.Id,'Perfios','Estimated','Apr-Feb','2018-19',123.45);
        insert m68BalsheetAnal;

        M68_Balance_Sheet_Analysis__c m68BalsheetAnals      = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68',acc.Id,'Perfios','Projected','Apr-Feb','2019-20',123.45);
        insert m68BalsheetAnals;

        M68_Balance_Sheet_Analysis__c ytdm68BalsheetAnalsy  = SME_TestUtil.createM68BalSheetAnalysis('Test Data M68bal',acc.Id,'Perfios','YTD','Apr-Feb','2019-20',123.45);
        insert  ytdm68BalsheetAnalsy;

        M68_Balance_Sheet_Analysis__c ytdm68BalsheetAnalsyc = SME_TestUtil.createM68BalSheetAnalysis('Test Data M68Ansyc',acc.Id,'Perfios','YTD','Apr-Feb','2018-19',123.45);
        insert ytdm68BalsheetAnalsyc;

        M68_Balance_Sheet_Analysis__c m68BalsheetAnalsys    = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68BalAnalsys',acc.Id,'Probe 42','Actual','Apr-Feb','2017-18',123.45);
        insert m68BalsheetAnalsys;

        M68_Balance_Sheet_Analysis__c m68BalsheetAnalsis    = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68BalAnalsis',acc.Id,'Probe 42','Actual','Apr-Feb','2016-17',123.45);
        insert m68BalsheetAnalsis;

        M68_Balance_Sheet_Analysis__c m68BalsheetAnalysis   = SME_TestUtil.createM68BalSheetAnalysis('Test Data for m68BalsheetAnalysis',acc.Id,'Probe 42','Actual','Apr-Feb','2015-16',123.45);
        insert m68BalsheetAnalysis;



        Sundry_Creditors__c suncredit                       = SME_TestUtil.createSundryCreditors(acc.Id,'0-30',34.56,'2016-17','Test Trade Creditors');
        insert suncredit;

        Sundry_Creditors__c suncreditr                      = SME_TestUtil.createSundryCreditors(acc.Id,'31-60',34.56,'2017-18','Test Trade Creditors-1');
        insert suncreditr;

        Sundry_Creditors__c suncreditrs                     = SME_TestUtil.createSundryCreditors(acc.Id,'61-90',34.56,'2018-19','Test Trade Creditors-2');
        insert suncreditrs;

        Debtors__c db                                       = SME_TestUtil.createDeb(acc.Id,'Test Customer test','0-30',34.56,'2017-18');
        insert db;

        Debtors__c dbt                                      = SME_TestUtil.createDeb(acc.Id,'Test Customer','31-60',34.56,'2018-19');
        insert dbt;

        Debtors__c dbtr                                     = SME_TestUtil.createDeb(acc.Id,'Test Customer-2','31-60',34.56,'2016-17');
        insert dbtr;




        Audit__c aud                                        = new Audit__c();
        String auditTCRTypeID                               = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get(Constants.UNDERWRITING_T_N_C).getRecordTypeId();

        aud.Application__c                                  = appExceeding.Id;
        aud.Sanction_Authority_Comment__c                      = 'aaa';
        aud.RecordTypeId                                    = auditTCRTypeID;
        insert aud;

        Deviation_Rules__c dr = new Deviation_Rules__c();
        dr.name='TestRule';
        insert dr;

        Task t                                              = SME_TestUtil.createtask('Property Evaluation','Subject','Not Started',UserInfo.getUserId(),appExceeding.Id);
        insert t;
        Task preTask                                        = SME_TestUtil.createtask('Pre-disbursement Approval','Subject','Not Started',UserInfo.getUserId(),appExceeding.Id);
        insert preTask;
        Task legalTask                                      = SME_TestUtil.createtask('Legal Evaluation','Subject','Not Started',UserInfo.getUserId(),appExceeding.Id);
        insert legalTask;
    }
    static testmethod void testUnderwriting(){

        genesis__Applications__c app                        = [Select Id,Name,(SELECT Id,Existing_Limit__c,Limit_Amount__c,Balance_Outstandings__c,Amount_Yet_disbursed__c FROM Facilities__r) from genesis__Applications__c Limit 1];
        Account acc                                         = [Select Id,Name from Account Limit 1];

        Underwriting_CTRL.saveWrapper  wrp                  = new Underwriting_CTRL.saveWrapper();
        SanctionUnderwriting_Process.userInfoWrapper aWrp   = new SanctionUnderwriting_Process.userInfoWrapper();
        Underwriting_CTRL.saveUnderWrite(wrp);
        Underwriting_CTRL.otherAuthoritySubmit(app.Id,'');
        Underwriting_CTRL.sanctionApprovalSubmit(app.Id,'Approved',aWrp,null);
        Underwriting_CTRL.sanctionApprovalSubmit(app.Id,'Mark as Exit',aWrp,null);
        // start
        Underwriting_CTRL.checkSecurityCoverage(app.Id,wrp);
        
    }
    static testmethod void coverAllCatchBlocks(){
        genesis__Applications__c app                        = [Select Id,Name from genesis__Applications__c Limit 1];
        Account acc                                         = [Select Id,Name from Account Limit 1];

        //Underwriting_CTRL_Helper.saveProfileDataForNewSourcing(acc);
    }
    static testmethod void coverAllTask(){
        genesis__Applications__c app                        = [Select Id,Name,(SELECT Id,Existing_Limit__c,Limit_Amount__c,Balance_Outstandings__c,Amount_Yet_disbursed__c FROM Facilities__r)  from genesis__Applications__c Limit 1];
        Account acc                                         = [Select Id,Name from Account Limit 1];
        Audit__c aud                                        = [SELECT Id,Name from Audit__c limit 1];
        List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();
        List<String> fyList = new List<String>{YearDataConstant.currFiscalYear, YearDataConstant.nthFiscalYear, YearDataConstant.n_1_FiscalYear};
        m68DataList = SOQL_Util.getM68Data(acc.Id, fyList);

        Underwriting_CTRL_Helper.isPreDisburementTaskCountOne(app.id,'Not Started');
        Underwriting_CTRL_Helper.createMODTaskForBm(app.id,'Mod Needed','Mod is Required');
        Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(app.id,'Mod Needed');

        Underwriting_CTRL_Helper.updateApplicationStage(app);
        Underwriting_CTRL_Helper.updateApplicationStagetoFinalSanction(app.Id);
        Underwriting_CTRL_Helper.checkIfFECollateralExist(app.Id);
        Underwriting_CTRL_Helper.updateFinalSecurityCoverage(app.Id,'LEGAL');
        Underwriting_CTRL_Helper.updateFinalSecurityCoverageHelper(app.Id,'FS');
        Underwriting_CTRL_Helper.getTrimmedIds(new Map<String,Decimal>{'111111111111111111111'=>4.5});
        Underwriting_CTRL_Helper.updateApplicationAndTaskForBUUser(app);
        Underwriting_CTRL_Helper.checkIfFacilityIsScematic(new List<String>{app.Facilities__r[0].Id});
        Underwriting_CTRL_Helper.calculatePercentageChangeInExistingFacility(app.Facilities__r[0],34.5);
        Underwriting_CTRL_Helper.saveOtherAuthorityInput(app.Id,'comment');
        Underwriting_CTRL_Helper.deleteExistingAuditRecs(app.Id);
        Underwriting_CTRL_Helper.getAccountOperationalDataForCurrentYTD(acc.Id);
        Underwriting_CTRL_Helper.getNetSalesForNewSourcing(acc.Id);
        Underwriting_CTRL_Helper.checkIfNewDashboardIsNeeded(acc.Id);
        Underwriting_CTRL_Helper.saveProfileDataForNewSourcing(app);
        Underwriting_CTRL_Helper.updateAppStage(app.Id);
        Underwriting_CTRL_Helper.updatedeviationApproverTermsAndCondition(app.Id,new List<Audit__c>{aud});
        Underwriting_CTRL_Helper.updateFinalAuthTermsAndCondition(app.Id,new List<Audit__c>{aud});
        Underwriting_CTRL_Helper.getTermLoanAmount(app.Id,acc.Id);
        Underwriting_CTRL_Helper.rejectEnhancementHelper(app.Id);
        Underwriting_CTRL_Helper.rejectExceedingAdhocHelper(app.Id);
        Underwriting_CTRL_Helper.createBMAuthRecommendationIfNotExist(app.Id);
        Underwriting_CTRL_Helper.runBreAfterM121(app.Id);
        Underwriting_CTRL_Helper.checkIfLegalTaskHasToBeCreatedForBM(app.Id,true);
        Underwriting_CTRL_Helper.createTaskForPreviousAuthority(null);
        Underwriting_CTRL_Helper.currency('23');
        Underwriting_CTRL_Helper.decimalConversion(23.5);
        Underwriting_CTRL_Helper.getRecomendedLimitAggregate(app.Id);
        //Underwriting_CTRL_Helper.createDOLegalTask(app.Id,'Legal Evaluation','sub');
        Underwriting_CTRL_Helper.checkIFAllB1DocumentsAreAvailable(app.Id);
        //Underwriting_CTRL_Helper.closeExistingCLPCTask(app.Id,'Legal Evaluation');
        Underwriting_CTRL_Helper.checkIfM21ExistForLastThreeYears(acc.Id);
        Underwriting_CTRL_Helper.isAllDataSourceAvailable(m68DataList);
      //  Underwriting_CTRL_Helper.isEnhancementApplication(app.Id);
        Underwriting_CTRL_Helper.isNewLoanApplication(app.Id);
        //Underwriting_CTRL_Helper.isAdhocApplication(app.Id);
        ///Underwriting_CTRL_Helper.isExceedingAdhoc(app.Id);
        ///Underwriting_CTRL_Helper.isExceeding(app.Id);
        ///Underwriting_CTRL_Helper.checkIfSignerDetailsNeeded(app.Id,'B1 Document');
        //Underwriting_CTRL_Helper.markBMAsHighestAuth(new List<String>{app.Facilities__r[0].Id},app.Id);
        ////Underwriting_CTRL_Helper.getNonSchematicProcessingCharges();
        ////Underwriting_CTRL_Helper.getRoleWiseLimitAmount();
        ///Underwriting_CTRL_Helper.getLevelHirerachyMap(SanctionMatrix_Helper.getAuthorityLevel(),'DO_DM');

        //Underwriting_CTRL_Helper.saveProfileDataForNewSourcing(acc);
    }
    static testMethod void testMethod1(){

        genesis__Applications__c app                        = [Select Id,Name from genesis__Applications__c Limit 1];

        Account acc                                         = [Select Id,Name from Account Limit 1];

        Audit__c aud                                        = [SELECT Id,Name from Audit__c limit 1];

        Deviation_Rules__c dr                               = [SELECT Id,Name,DOCC__c,CO_GM__c,COCC__c,Limit_Value__c,President_and_COO__c,Schematic__c,Rule__c from Deviation_Rules__c limit 1];

        User u                                              = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;

        System.runAs(u) {
            Underwriting_CTRL_Helper ob=new Underwriting_CTRL_Helper();
            ob.getDashboardContent(app.Id, u);
            Underwriting_CTRL_Helper.updateApplicationStage(app);
            Underwriting_CTRL_Helper.updateFinalSecurityCoverage(app.Id, 'LEGAL');
            Underwriting_CTRL_Helper.updateApplicationStagetoFinalSanction(app.Id);
            Underwriting_CTRL_Helper.updateApplicationAndTaskForBUUser(app);
            Underwriting_CTRL_Helper.saveOtherAuthorityInput(app.Id,'Newcommnet');
            Underwriting_CTRL_Helper.getAuthorityComment(app.Id);
            Underwriting_CTRL_Helper.createCLPCTask(app.Id,'MOD Needed','Test subject');
            Underwriting_CTRL_Helper.checkIfLegalTaskHasToBeCreatedForBM(app.Id,true);
            Underwriting_CTRL_Helper.createInsCollTaskForBm(app.Id);
            Underwriting_CTRL_Helper.sendNotificationToBM(app.Id);
            Underwriting_CTRL_Helper.getFinalAuthorityUser(app.Id,u);
            Underwriting_CTRL_Helper.geMargintDeviationRole(2.3,dr);
            Underwriting_CTRL_Helper.getDeviationRole(2.3,dr);
            Underwriting_CTRL_Helper.marginDeviation(2.3,3,dr,'frde324');
            Underwriting_CTRL_Helper.savePreDisbursementComments(new List<Audit__c>{aud},app.Id);
            Underwriting_CTRL_Helper.getPercentageChangeInValue(6.5,4.5);
            Underwriting_CTRL_Helper.createMODTaskForBm(app.Id,'MOD Needed','Test subject');
            Underwriting_CTRL_Helper.isPreDisburementTaskCountOne(app.Id,'Completed');
            Underwriting_CTRL_Helper.checkIfFECollateralExist(app.Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(app);
            Underwriting_CTRL WE= new Underwriting_CTRL();
            WE.loadPageData(app.Id);

        }
    }
}