@istest
public class SME_Email_Handler_test {
	 @isTest public static void method1(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'New loans- Application submitted';
        genApp.Renewal_Due_Date__c = system.today();
        insert genApp;
         
         Facility__c fac = new Facility__c();
         
         fac.Application__c  = genApp.Id;
         fac.Active__c = true;
        
         insert fac;
         
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
       
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(genApp);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(genApp);
    }
     @isTest public static void method2(){
         //KVB_Company_Details__c kvb=VL_Test_Utility.KVB_Company_Details__c();
         
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
       	kvb.GST__c = 18;
        insert kvb;
         
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'New loans- Application submitted';
        genApp.Renewal_Due_Date__c = system.today();
        insert genApp;
         
         System.debug('TESt class genapp'+genapp);
         Facility__c fac = new Facility__c();
         fac.Application__c  = genApp.Id;
         fac.Active__c = true;
         fac.Recommended_Limit__c=10000;
         insert fac;
         
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
         genesis__Applications__c app = [select id,recordtype.developerName,genesis__Account__r.name,name,recordtypeid,Sanction_Authority__c,genesis__Account__r.Perfios_error_message__c,genesis__Account__r.Priority_Sector__c,(select id,Recommended_Limit__c,Product_Name__c,Existing_Limit__c,MCLR_Rate__c,Margin__c,Recommended_Rate__c,Recommended_Days__c from Facilities__r),genesis__Total_Upfront_Payments__c,Renewal_Due_Date__c,owner.name,Branch_Name__c from genesis__Applications__c where id=:genApp.id];
        // SME_SendSMSService.sendSMSApp_SME(appId);
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(app);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(app);
         SME_Email_Handler.getRenewalDueTemplates(app);
         
    }
    @isTest public static void method02(){
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
       	kvb.GST__c = 18;
        insert kvb;
        
         clcommon__CL_Product__c prod = new clcommon__CL_Product__c();
        prod.Product_Code__c = '777';
        prod.clcommon__Product_Name__c = 'Digital Home Loan - 777';
        insert prod;
         
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'New loans- Application submitted';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Branch_Name__c='test';
        insert genApp;
         
         System.debug('TESt class genapp'+genapp);
         Facility__c fac = new Facility__c();
         fac.Application__c  = genApp.Id;
         fac.Active__c = true;
         fac.Recommended_Limit__c=10000;
         //fac.CL_Product__c=prod.id;
         insert fac;
         
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
         genesis__Applications__c app = [select id,Branch_Name__c,Next_Renewal_Date__c,Application_Stage__c,recordtype.developerName,genesis__Account__r.name,genesis__Account__r.Perfios_error_message__c,name,recordtypeid,Recordtype.Name,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c,owner.name,(select id,Recommended_Limit__c,Product_Name__c,Existing_Limit__c,Margin__c,MCLR_Rate__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Name from Facilities__r),genesis__Total_Upfront_Payments__c,Renewal_Due_Date__c,ownerid from genesis__Applications__c where id=:genApp.id];
        // SME_SendSMSService.sendSMSApp_SME(appId);
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(genApp);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(app);
         SME_Email_Handler.getRenewalDueTemplatesBM(genApp);
         SME_Email_Handler.getAfterRenewalTemplatesCust(genApp);
        SME_Email_Handler.getAfterRenewalTemplatesBM(genApp);
        SME_Email_Handler.getEAENLCreationTemplateCust(genApp);
        SME_Email_Handler.getEAENLCreationTemplateBM(genApp);
        SME_Email_Handler.getEAENLSubmitTemplateBM(genApp);
        SME_Email_Handler.getEAENLFinalSanctionTemplateCust(genApp);
        SME_Email_Handler.getEAENLRejectTemplateCust(App);
        SME_Email_Handler.getEAENLLimitOpenedTemplateCust(genApp);
        SME_Email_Handler.getRenewalFinalSanctionTemplate(App);
        //SME_Email_Handler.getRenewalApplicationSubmissionPending(App);
        SME_Email_Handler.getLoanUnderProcessing(genApp);
        SME_Email_Handler.getESignPartiallyCompleted_Individuals(genApp);
        SME_Email_Handler.getEnhancementApplicationSubmitted(App);
        SME_Email_Handler.getEnhancementApplicationBMReview(App);
        SME_Email_Handler.getEnhancementFinalSanction(App);
        SME_Email_Handler.getEnhancementDelinedByCustomer(App);
        SME_Email_Handler.getEnhancementApplicationClose(App);
        SME_Email_Handler.getApplicationSubmittedBMTemplate(App);
        SME_Email_Handler.getNewApplicationInformalSacntionSTP(App);
        SME_Email_Handler.getExceedingApplicationSubmitted(App);
        SME_Email_Handler.getAdhocApplicationSubmitted(App);
        SME_Email_Handler.getNewApplicationNTBCreated(App);
    }
     @isTest public static void method3(){
         KVB_Company_Details__c kvb = new KVB_Company_Details__c();
       	kvb.GST__c = 18;
        insert kvb;
         
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        accObj.Priority_Sector__c=true;
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'New loans- Application submitted';
        genApp.Renewal_Due_Date__c = system.today();
        genapp.Sanction_Authority__c='BR_MGR';
        insert genApp;
         
         System.debug('TESt class genapp'+genapp);
         Facility__c fac = new Facility__c();
         fac.Application__c  = genApp.Id;
         fac.Active__c = true;
         fac.Recommended_Limit__c=5000;
         insert fac;
         
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        genesis__Applications__c app = [select id,recordtype.developerName,genesis__Account__r.name,name,recordtypeid,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c,(select id,Recommended_Limit__c,Product_Name__c,Existing_Limit__c,Recommended_Days__c,MCLR_Rate__c,Margin__c,Recommended_Rate__c from Facilities__r),genesis__Total_Upfront_Payments__c,Renewal_Due_Date__c,Ownerid from genesis__Applications__c where id=:genApp.id];
        // SME_SendSMSService.sendSMSApp_SME(appId);
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(genApp);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(app);
    }
    @isTest public static void method4(){
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
       	kvb.GST__c = 18;
        insert kvb;
         
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        accObj.Priority_Sector__c=False;
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'New loans- Application submitted';
        genApp.Renewal_Due_Date__c = system.today();
        genapp.Sanction_Authority__c='BR_MGR';
        insert genApp;
         
         System.debug('TESt class genapp'+genapp);
         Facility__c fac = new Facility__c();
         fac.Application__c  = genApp.Id;
         fac.Active__c = true;
         fac.Recommended_Limit__c=50000;
         insert fac;
         
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        genesis__Applications__c app = [select id,recordtype.developerName,genesis__Account__r.name,name,recordtypeid,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c,(select id,Recommended_Limit__c,Product_Name__c,Existing_Limit__c,Recommended_Days__c,MCLR_Rate__c,Margin__c,Recommended_Rate__c from Facilities__r),genesis__Total_Upfront_Payments__c,Renewal_Due_Date__c from genesis__Applications__c where id=:genApp.id];
        // SME_SendSMSService.sendSMSApp_SME(appId);
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(genApp);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(app);
    }
    @isTest public static void method5(){
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
       	kvb.GST__c = 18;
        insert kvb;
         
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        accObj.Priority_Sector__c=false;
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'New loans- Application submitted';
        genApp.Renewal_Due_Date__c = system.today();
        genapp.Sanction_Authority__c='BR_MGR';
        insert genApp;
         
         System.debug('TESt class genapp'+genapp);
         Facility__c fac = new Facility__c();
         fac.Application__c  = genApp.Id;
         fac.Active__c = true;
         fac.Recommended_Limit__c=800000;
         insert fac;
         
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        genesis__Applications__c app = [select id,recordtype.developerName,genesis__Account__r.name,name,recordtypeid,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c,(select id,Recommended_Limit__c,Product_Name__c,Existing_Limit__c,Recommended_Days__c,MCLR_Rate__c,Margin__c,Recommended_Rate__c from Facilities__r),genesis__Total_Upfront_Payments__c,Renewal_Due_Date__c from genesis__Applications__c where id=:genApp.id];
        // SME_SendSMSService.sendSMSApp_SME(appId);
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(genApp);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(app);
    }
    @isTest public static void method05(){
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
       	kvb.GST__c = 18;
        insert kvb;
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        accObj.Priority_Sector__c=False;
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'New loans- Application submitted';
        genApp.Renewal_Due_Date__c = system.today();
        genapp.Sanction_Authority__c='BR_MGR';
        insert genApp;
         
         System.debug('TESt class genapp'+genapp);
         Facility__c fac = new Facility__c();
         fac.Application__c  = genApp.Id;
         fac.Active__c = true;
         fac.Recommended_Limit__c=2000000;
         insert fac;
         
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        genesis__Applications__c app = [select id,recordtype.developerName,genesis__Account__r.name,name,recordtypeid,Sanction_Authority__c,genesis__Account__r.Perfios_error_message__c,genesis__Account__r.Priority_Sector__c,(select id,Recommended_Limit__c,Product_Name__c,Existing_Limit__c,MCLR_Rate__c,Margin__c,Recommended_Rate__c,Recommended_Days__c from Facilities__r),genesis__Total_Upfront_Payments__c,Renewal_Due_Date__c,owner.name,Branch_Name__c from genesis__Applications__c where id=:genApp.id];
        // SME_SendSMSService.sendSMSApp_SME(appId);
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(genApp);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(app);
    }
    @isTest public static void method051(){
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
       	kvb.GST__c = 18;
        insert kvb;
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        accObj.Priority_Sector__c=False;
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'New loans- Application submitted';
        genApp.Renewal_Due_Date__c = system.today();
        genapp.Sanction_Authority__c='BR_MGR';
        insert genApp;
         
         System.debug('TESt class genapp'+genapp);
         Facility__c fac = new Facility__c();
         fac.Application__c  = genApp.Id;
         fac.Active__c = true;
         fac.Recommended_Limit__c=3000000;
         insert fac;
         
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        genesis__Applications__c app = [select id,recordtype.developerName,genesis__Account__r.name,name,recordtypeid,Sanction_Authority__c,genesis__Account__r.Perfios_error_message__c,genesis__Account__r.Priority_Sector__c,(select id,Recommended_Limit__c,Product_Name__c,Existing_Limit__c,MCLR_Rate__c,Margin__c,Recommended_Rate__c,Recommended_Days__c from Facilities__r),genesis__Total_Upfront_Payments__c,Renewal_Due_Date__c,owner.name,Branch_Name__c from genesis__Applications__c where id=:genApp.id];
        // SME_SendSMSService.sendSMSApp_SME(appId);
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(genApp);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(app);
    }
     
   
         @isTest public static void method9(){
             KVB_Company_Details__c kvb = new KVB_Company_Details__c();
       	kvb.GST__c = 18;
        insert kvb;
         
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        accObj.Priority_Sector__c=True;
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'New loans- Application submitted';
        genApp.Renewal_Due_Date__c = system.today();
        genapp.Sanction_Authority__c='DO_MGR';
        insert genApp;
         
         System.debug('TESt class genapp'+genapp);
         Facility__c fac = new Facility__c();
         fac.Application__c  = genApp.Id;
         fac.Active__c = true;
         fac.Recommended_Limit__c=8000000;
         insert fac;
         
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        genesis__Applications__c app = [select id,recordtype.developerName,genesis__Account__r.name,name,recordtypeid,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c,genesis__Total_Upfront_Payments__c,(select id,Recommended_Limit__c,Product_Name__c,Existing_Limit__c,Recommended_Days__c,MCLR_Rate__c,Margin__c,Recommended_Rate__c from Facilities__r),Renewal_Due_Date__c from genesis__Applications__c where id=:genApp.id];
        // SME_SendSMSService.sendSMSApp_SME(appId);
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(genApp);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(app);
    }
}