//uday----->70
@IsTest(seeAllData = false)
private class Test_Underwriting_CTRL_Helper{

    @testSetup static void setup() {
        // Create common test accounts
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;

        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
        genesis__Applications__c app=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        app.Application_UI_Stage__c = 'FinancialUploads';
        insert app;

        Audit__c aud = new Audit__c();
        aud.Application__c=app.Id;
        insert aud;

        Deviation_Rules__c dr = new Deviation_Rules__c();
        dr.name='TestRule';
        insert dr;

        Task t = SME_TestUtil.createtask('Property Evaluation','Subject','Not Started',UserInfo.getUserId(),app.Id);
        insert t;
        Task preTask = SME_TestUtil.createtask('Pre-disbursement Approval','Subject','Not Started',UserInfo.getUserId(),app.Id);
        insert preTask;
        Task legalTask = SME_TestUtil.createtask('Legal Evaluation','Subject','Not Started',UserInfo.getUserId(),app.Id);
        insert legalTask;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('Test Product','Testcode','Non-Funded');
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(app.Id,clProd.Id,'test12345',2345.65);
        fac.Recommended_Processing_Charge__c=1.2;
        insert fac;
        
        Processing_charges_scheme__c proc = new Processing_charges_scheme__c();
        proc.Product__c=clProd.Id;
        insert proc;
    }
    static testmethod void testUnderwriting(){

        genesis__Applications__c app = [Select Id,Name from genesis__Applications__c Limit 1];
        Account acc = [Select Id,Name from Account Limit 1];
        
        Facility__c fac=[select id, name, Balance_Outstandings__c,Recommended_Processing_Charge__c,Type__c from Facility__c where Balance_Outstandings__c=2345.65];
        System.debug('fac'+fac);
        Underwriting_CTRL.saveWrapper  wrp    = new Underwriting_CTRL.saveWrapper();
        SanctionUnderwriting_Process.userInfoWrapper aWrp    = new SanctionUnderwriting_Process.userInfoWrapper();
        Underwriting_CTRL_Helper.calculateProcessingCharges(wrp);
        Underwriting_CTRL_Helper.calculatePercentageChangeInExistingFacility(fac,345.56);
        Underwriting_CTRL.saveUnderWrite(wrp);
        Underwriting_CTRL.otherAuthoritySubmit(app.Id,'');
        Underwriting_CTRL.sanctionApprovalSubmit(app.Id,'Approved',aWrp,null);
        Underwriting_CTRL.sanctionApprovalSubmit(app.Id,'Mark as Exit',aWrp,null);
        
        Underwriting_CTRL_Helper.ifSchematic=true;
        Underwriting_CTRL_Helper.calculatePercentageChangeInExistingFacility(fac,345.56);
    }
    static testmethod void coverAllCatchBlocks(){
        genesis__Applications__c app = [Select Id,Name from genesis__Applications__c Limit 1];
        Account acc = [Select Id,Name from Account Limit 1];

        //Underwriting_CTRL_Helper.saveProfileDataForNewSourcing(acc);
    }
    static testmethod void coverAllTask(){
        genesis__Applications__c app = [Select Id,Name from genesis__Applications__c Limit 1];
        Account acc = [Select Id,Name from Account Limit 1];
        
        Underwriting_CTRL_Helper.isPreDisburementTaskCountOne(app.id,'Not Started');
		Underwriting_CTRL_Helper.createMODTaskForBm(app.id,'Mod Needed','Mod is Required');
        Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(app.id,'Mod Needed');
        
        Underwriting_CTRL_Helper.updateApplicationStage(app);
        Underwriting_CTRL_Helper.updateApplicationStagetoFinalSanction(app.Id);
        Underwriting_CTRL_Helper.checkIfFECollateralExist(app.Id);
        Underwriting_CTRL_Helper.updateFinalSecurityCoverage(app.Id,'LEGAL');
        Underwriting_CTRL_Helper.updateFinalSecurityCoverageHelper(app.Id,'LEGAL');
        Underwriting_CTRL_Helper.getTrimmedIds(new Map<String,Decimal>{'111111111111111111111'=>4.5});
        Underwriting_CTRL_Helper.updateApplicationAndTaskForBUUser(app);
        
        //Underwriting_CTRL_Helper.saveProfileDataForNewSourcing(acc);
    }
    static testMethod void testMethod1(){

        genesis__Applications__c app = [Select Id,Name from genesis__Applications__c Limit 1];
        Account acc = [Select Id,Name from Account Limit 1];
        User u = Utility_Test.createUser('TestUserkvb@test.com');
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
            //Underwriting_CTRL_Helper.createLegalTask(app.Id);
            Underwriting_CTRL_Helper.createInsCollTaskForBm(app.Id);
            Underwriting_CTRL_Helper.sendNotificationToBM(app.Id);
            Underwriting_CTRL_Helper.getFinalAuthorityUser(app.Id,u);
            //Underwriting_CTRL_Helper.geMargintDeviationRole(2.3,dr);
            //Underwriting_CTRL_Helper.getDeviationRole(2.3,dr);
            //Underwriting_CTRL_Helper.marginDeviation(2.3,3,dr,'frde324');
            //Underwriting_CTRL_Helper.savePreDisbursementComments(new List<Audit__c>{aud},app.Id);
            // Underwriting_CTRL_HelpergetPercentageChangeInValue(6.5,4.5);
            Underwriting_CTRL_Helper.createMODTaskForBm(app.Id,'MOD Needed','Test subject');
            Underwriting_CTRL_Helper.isPreDisburementTaskCountOne(app.Id,'Completed');
            Underwriting_CTRL_Helper.checkIfFECollateralExist(app.Id);
            

        }
    }
}