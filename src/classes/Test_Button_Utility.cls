/*
* Description : Test_Button_Utility
* Author      : Kishan Panchal
*/
@isTest
public class Test_Button_Utility {
    public static genesis__Applications__c app;
    public static genesis__Applications__c app1;
    public static Facility__c fasi;
    public static account acc;
    
    @isTest static void test_method_one() {
        
        app   = Test_utilityMethod.intialSetUp('SME Renewal',true);
        app.RecordTypeId=Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        app.Active__c=true;
        app.Application_Stage__c='Identified for renewal';
        app.List_Matching_Stage__c='Not Initiated';
        update app;
        //acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB'); 
        //insert acc;
        clcommon__CL_Product__c prod=new clcommon__CL_Product__c();
        prod.clcommon__Product_Name__c='SME Renewal';
        prod.Product_Type__c='Non-Funded';
        insert prod;
        fasi = new Facility__c(Application__c=app.Id);
        //fasi.CL_Product__c=prod.id;
        insert fasi;
        clcommon__Collateral__c clColl = new clcommon__Collateral__c();
        clColl= SME_TestUtil.createcollateral(app.Id,'Test colleteral','Vacant Land');
        clColl.clcommon__Collateral_Name__c='Test Collateral';
        insert clColl; 
       genesis__Application_Collateral__c genAppColl = new genesis__Application_Collateral__c();
       genAppColl = SME_TestUtil.createAppCollateral(APP.genesis__Account__r.id,App.Id,fasi.Id,clColl.Id);
       genAppColl.Security_Type__c='Collateral Securities';
       genAppColl.genesis__Pledge_Amount__c=35.45;
       insert genAppColl;
        
        //clcommon__CL_Product__c prod=SME_TestUtil.createclproduct('SME Renewal', productcode, prodType);
        //fasi=SME_TestUtil.createFacility(app.id, prod.id, accountnumber, balanceoutstanding);
        set<string> id1=new set<string>();
        id1.add(app.Id);
        set<string> id2=new set<string>();
        id2.add(app.id);
        Button_Utility.runBRE(app.Id);
        Button_Utility.generateB1document(app.Id,null);
        Button_Utility.runPersonCIBILBatch(app.Id);
        Button_Utility.runPersonCIBIL(Test_utilityMethod.acc.Id);
        //Button_Utility.runListMatching(app.Id);
        Button_Utility.getListMatchingStatus(app.Id);
        Button_Utility.getPreRenewalChecklist(app.Id);
        Button_Utility.createTaskForBM(app.Id, 'Collect processing fees from the new to bank customer','BM task for Collect processing fees from the new to bank customer');
        Button_Utility.callFacilityDocGenBatch(app.Id);
        
        Button_Utility.runSanctionAuth(app.Id);
        
        Button_Utility.calSecurityCoverage( app.Id);
        Button_Utility.closeExistingBMTask( app.Id, 'Application Review');
        Button_Utility.adminStageReset(app.Id, 'Application Review - Final Authority');
        Button_Utility.docGeneration(app.Id);
        //Button_Utility.docGenerationForSME_EAE_Future(app.Id,'MOD Needed');
        //Button_Utility.docGenerationForSME_EAE(app.Id,'MOD Needed');
        Button_Utility.updateFacilityExistMargin(fasi.id);
        Button_Utility.setUpLimit(app.Id);
        Button_Utility.GenerateAllFinalDocumets(app.Id);
        Button_Utility.fnlAcceptedTaskCheck(app.Id);
        Button_Utility.discontinuationApplication(app.Id);
        Button_Utility.checkExistingTask(app.Id,'Assign to primary owner');
        Button_Utility.getLiabilitiesAPIData(app.Id);
        //Button_Utility.runListMatching(app.Id);
       // Button_Utility.generateDocs(id1,id2);
        
    }/*
    @isTest static void test_method_two(){
        acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB'); 

        insert acc;
        //app   = Test_utilityMethod.intialSetUp('SME Renewal',true);
        app1=SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
        Id RecordTypeIdclProd = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        system.debug('app1===+++'+app1);
        //app1.Application_to_close__c=true;
       // app1.Parent_Application__c=app.id;
       // system.debug('app1.id+++==='+app1.id);
        app1.RecordTypeId=RecordTypeIdclProd;
        insert app1;
        system.debug('app1.id+++==='+app1.id);
        system.debug('app1.id+++==='+app1.RecordType_Developer_Name__c);
        //Button_Utility.discontinuationApplication(app1.Id);
        Button_Utility.adminStageReset(app1.Id,app1.Sub_Stage__c);
    }
    */
     @isTest static void test_method_three(){
        acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB'); 
        insert acc;
        app   = Test_utilityMethod.intialSetUp('SME Renewal',true);
        app1=SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
         ////clcommon__CL_Product__c prod=SME_TestUtil.createclproduct(productname, productcode, prodType);
        // fasi=SME_TestUtil.createFacility(app1.id, clProdId, accountnumber, balanceoutstanding);
        system.debug('app1===+++'+app1);
        app1.Application_to_close__c=true;
        app1.Parent_Application__c=app.id;
       // system.debug('app1.id+++==='+app1.id);
        insert app1;
        system.debug('app1.id+++==='+app1.id);
        system.debug('app1.id+++==='+app1.RecordType_Developer_Name__c);
        Button_Utility.discontinuationApplication(app1.Id);
        //Button_Utility.adminStageReset(app1.Id,app1.Sub_Stage__c);
    }
    @isTest static void test_method_four() {
        
        app   = Test_utilityMethod.intialSetUp('SME Renewal',true);
        app.RecordTypeId=Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        app.Active__c=true;
        app.Application_Stage__c='Identified for renewal';
        app.List_Matching_Stage__c='Not Initiated';
        update app;
        //acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB'); 
        //insert acc;
        clcommon__CL_Product__c prod=new clcommon__CL_Product__c();
        prod.clcommon__Product_Name__c='SME Renewal';
        prod.Product_Type__c='Non-Funded';
        insert prod;
        fasi = new Facility__c(Application__c=app.Id);
        //fasi.CL_Product__c=prod.id;
        insert fasi;
        clcommon__Collateral__c clColl = new clcommon__Collateral__c();
        clColl= SME_TestUtil.createcollateral(app.Id,'Test colleteral','Vacant Land');
        clColl.clcommon__Collateral_Name__c='Test Collateral';
        insert clColl; 
       genesis__Application_Collateral__c genAppColl = new genesis__Application_Collateral__c();
       genAppColl = SME_TestUtil.createAppCollateral(APP.genesis__Account__r.id,App.Id,fasi.Id,clColl.Id);
       genAppColl.Security_Type__c='Collateral Securities';
       genAppColl.genesis__Pledge_Amount__c=35.45;
       insert genAppColl;
        
        //clcommon__CL_Product__c prod=SME_TestUtil.createclproduct('SME Renewal', productcode, prodType);
        //fasi=SME_TestUtil.createFacility(app.id, prod.id, accountnumber, balanceoutstanding);
        set<string> id1=new set<string>();
        id1.add(app.Id);
        set<string> id2=new set<string>();
        id2.add(app.id);
        Button_Utility.runBRE(app.Id);
        Button_Utility.generateB1document(app.Id,null);
        Button_Utility.runPersonCIBILBatch(app.Id);
        Button_Utility.runPersonCIBIL(Test_utilityMethod.acc.Id);
        //Button_Utility.runListMatching(app.Id);
        Button_Utility.getListMatchingStatus(app.Id);
        Button_Utility.getPreRenewalChecklist(app.Id);
        Button_Utility.createTaskForBM(app.Id, 'Collect processing fees from the new to bank customer','BM task for Collect processing fees from the new to bank customer');
        Button_Utility.callFacilityDocGenBatch(app.Id);
        
        Button_Utility.runSanctionAuth(app.Id);
        
        Button_Utility.calSecurityCoverage( app.Id);
        Button_Utility.closeExistingBMTask( app.Id, 'Application Review');
        Button_Utility.adminStageReset(app.Id, 'Application Review - Final Authority');
        Button_Utility.docGeneration(app.Id);
        //Button_Utility.docGenerationForSME_EAE_Future(app.Id,'MOD Needed');
        //Button_Utility.docGenerationForSME_EAE(app.Id,'MOD Needed');
        Button_Utility.updateFacilityExistMargin(fasi.id);
        Button_Utility.setUpLimit(app.Id);
        Button_Utility.GenerateAllFinalDocumets(app.Id);
        Button_Utility.fnlAcceptedTaskCheck(app.Id);
        Button_Utility.discontinuationApplication(app.Id);
        Button_Utility.checkExistingTask(app.Id,'Assign to primary owner');
        Button_Utility.getLiabilitiesAPIData(app.Id);
        Button_Utility.runListMatching(app.Id);
       // Button_Utility.generateDocs(id1,id2);
        
    }
     
  
}