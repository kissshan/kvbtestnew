/*
* Description : Test_SME_SendSMSService
* Author      : Kishan Panchal
*/
@isTest
public class Test_SME_SendSMSService {
    
    @isTest public static void SMESendSMSServicemethod1(){
        
        KVB_Endpoint_URLs__c kvbUrl = new KVB_Endpoint_URLs__c(name='SMS_Service',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/SendSMSAlert');
        insert kvbUrl;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Identified for renewal';
        genApp.Renewal_Due_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod2(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Identified for renewal';
        genApp.Renewal_Due_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod3(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Application filling initiated';
        genApp.Renewal_Due_Date__c = system.today();
        insert genApp;
        system.debug('genApp==++'+genApp.recordtype.developerName);
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod4(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Application filling initiated';
        genApp.Renewal_Due_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod5(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Application review-Critical changes';
        genApp.Renewal_Due_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod6(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Application review-Critical changes';
        genApp.Renewal_Due_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
     @isTest public static void SMESendSMSServicemethod06(){
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
        
        SME_SendSMSService.sendSMSApp_SME(appId);
         SME_Email_Handler.getFinancialSubmissionPendingIndividuals(genApp);
         SME_Email_Handler.getPerfiosError(genApp);
         SME_Email_Handler.getEnhancementPerfiosError(genApp);
         SME_Email_Handler.getNewApplicationCreated(genApp);
         SME_Email_Handler.getNewApplicationPerfiosError(genApp);
         SME_Email_Handler.getFinalSanctionStageEmailTemplate(genApp);
         SME_Email_Handler.getApplicationPerfiosErrorBMTemplate(genApp);
         SME_Email_Handler.getFinalSanctionOfferedStageEmailTemplate(genApp);
    }
    @isTest public static void SMESendSMSServicemethod7(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Limit extended';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod8(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Limit extended';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod9(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Exceeding E-sign pending';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod10(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Exceeding E-sign pending';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod11(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        
        SME_SendSMSService.sendSMSApp_SME(appId);
    }
    @isTest public static void SMESendSMSServicemethod12(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod13(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Perfios error';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod14(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Application created';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod15(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Application created';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod16(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Application submitted';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod17(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Application submitted';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod18(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Application BM Review';
        genApp.Sub_Stage__c = 'Insufficient collateral coverage';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod19(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Application BM Review';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Insufficient collateral coverage';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod20(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Final sanction';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod21(){
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Final sanction';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod22(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Delined by customer';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod23(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement- Delined by customer';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod24(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement E-sign pending';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod25(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement E-sign pending';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod26(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement application close';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod27(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Enhancement application close';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod28(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Customer query';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod29(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Customer query';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod30(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Perfios error';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod31(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Perfios error';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod32(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Exceeding- Application submitted';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod33(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Exceeding- Application submitted';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod34(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Exceeding-Final sanction';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod35(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Exceeding-Final sanction';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod36(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Exceeding application close';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod37(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Exceeding application close';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod38(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Adhoc- Application submitted';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod39(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Adhoc- Application submitted';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod40(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Adhoc application close';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod41(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'ETB-WC';
        genApp.Application_Stage__c = 'Adhoc application close';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod42(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'New loans - Application created';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod43(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'New loans - Application created';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod44(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'New loans - Application created';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod45(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'New loans - Application created';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod46(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'New loan - Informal sanction through STP';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod47(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'New loan - Informal sanction through STP';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod48(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'New loan - Application rejected';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod49(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'New loan - Application rejected';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload financials';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod50(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'Perfios error';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload bank statements';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod51(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'Perfios error';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload bank statements';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod52(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'Interim Sanction';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload bank statements';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod53(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'Interim Sanction';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload bank statements';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod54(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '123456789012';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'Re-upload financials';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload bank statements';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
    }
    @isTest public static void SMESendSMSServicemethod55(){
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        insert kvbDetail;
        
        Account accObj = new Account();
        accObj.Name = 'test';
        accObj.Cust_mobile_phone__c = '1234567890';
        insert accObj;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',accObj.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Enhancement').getRecordTypeId();
        genApp.Type__c      = 'NTB';
        genApp.Application_Stage__c = 'Re-upload financials';
        genApp.Application_UI_Stage__c = 'Submission';
        genApp.Sub_Stage__c = 'Re-upload bank statements';
        genApp.Application_to_close__c = true;
        genApp.Renewal_Due_Date__c = system.today();
        genApp.Next_Renewal_Date__c = system.today();
        insert genApp;
        
        Document docObj = new Document();
        docObj.Name = 'test';
        docObj.FolderId =  UserInfo.getUserId();
        docobj.DeveloperName = 'Kvb_logo_for_Email';
        insert  docObj; 
        
        Set<string> appId=new Set<string>();
        appid.add(genApp.id);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        
        SME_SendSMSService.sendSMSApp_SME(appId);
        // https://kvb--sit--c.cs58.visual.force.com/resource/1521973842000/KVB_Logo
        // 
    }
}