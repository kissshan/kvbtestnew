//uday---->83%
@isTest
public class YTDAnalysisController_Test {
    @isTest
    public static void method1(){
        Account acc = new Account(FirstName = 'Test', LastName = 'Data');
        Insert acc;
        
        genesis__Applications__c genApp_Enhancement=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        
        genApp_Enhancement.Application_Stage__c     = 'EXCEEDING- Application created';
        genApp_Enhancement.RecordTypeId             = SOQL_Util.getRecordTypeId('SME_EXCEEDING');
        Insert genApp_Enhancement;
        genesis__Applications__c genApp_Newloan=SME_TestUtil.createApplication('KB231',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        
        //genApp_Enhancement.Application_Stage__c     = 'EXCEEDING- Application created';
        genApp_Newloan.RecordTypeId             = SOQL_Util.getRecordTypeId('SME_NEW_Loan');
        Insert genApp_Newloan;
        
        M68_Balance_Sheet_Analysis__c current_Year_m68BalSheet       = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68',acc.Id,'Perfios','Estimated','Apr-Feb','2018-19',123.45);
        Insert current_Year_m68BalSheet;
        
        GSTN_Info__c gstnP= new GSTN_Info__c();
        Id RecordTypeIdGstnP = Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId(); 
        Id RecordTypeIdGstnC 		= Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Child').getRecordTypeId(); 		
        gstnP.GST_Number__c= '33ADHPN9706C1ZP';
        gstnP.Status__c= 'Success';
        gstnP.Application__c= genApp_Newloan.Id;
        gstnP.RecordTypeId= RecordTypeIdGstnP;
        gstnP.Months__c= '9';
        insert gstnP;

        GSTN_Info__c gstnC= new GSTN_Info__c();
        gstnC.GST_Number__c= '33ADHPN9706C1ZQ';
        gstnC.Status__c= 'Success';
        gstnC.Parent__c= gstnP.Id;
        gstnC.RecordTypeId= RecordTypeIdGstnC;
        gstnC.Months__c= '9';
        gstnC.To_Date__c= '122018';
        insert gstnC;

        GSTN_Info__c gstnC1= SME_TestUtil.createGSTInfo(RecordTypeIdGstnC,'33ADHPN9706C1ZQ','Success',gstnP.Id,'12');
        gstnC1.To_Date__c= '122018';
        insert gstnC1;
        
        YTDAnalysisController.ytdAnalysisMap.put('Current ratio',true);        
        Test.startTest();
        YTDAnalysisController.getAllFlagAnalysis(acc.id,genApp_Enhancement.id);
        YTDAnalysisController.getAllFlagAnalysis(acc.id,genApp_Newloan.id);
        Test.stopTest();
        
    }
    
    @isTest
    public static void method2(){
        Account acc = new Account(FirstName = 'Test', LastName = 'Data');
        Insert acc;
        
        genesis__Applications__c genApp_Enhancement=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        
        genApp_Enhancement.Application_Stage__c     = 'EXCEEDING- Application created';
        genApp_Enhancement.RecordTypeId             = SOQL_Util.getRecordTypeId('SME_EXCEEDING');
        Insert genApp_Enhancement;
        genesis__Applications__c genApp_Newloan=SME_TestUtil.createApplication('KB231',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        
        //genApp_Enhancement.Application_Stage__c     = 'EXCEEDING- Application created';
        genApp_Newloan.RecordTypeId             = SOQL_Util.getRecordTypeId('SME_NEW_Loan');
        Insert genApp_Newloan;
        
        M68_Balance_Sheet_Analysis__c current_Year_m68BalSheet       = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68',acc.Id,'Perfios','Estimated','Apr-Feb','2018-19',123.45);
        Insert current_Year_m68BalSheet;
        
        GSTN_Info__c gstnP= new GSTN_Info__c();
        Id RecordTypeIdGstnP = Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId(); 
        Id RecordTypeIdGstnC 		= Schema.SObjectType.GSTN_Info__c.getRecordTypeInfosByName().get('Child').getRecordTypeId(); 		
        gstnP.GST_Number__c= '33ADHPN9706C1ZP';
        gstnP.Status__c= 'Success';
        gstnP.Application__c= genApp_Newloan.Id;
        gstnP.RecordTypeId= RecordTypeIdGstnP;
        gstnP.Months__c= '9';
        insert gstnP;

        GSTN_Info__c gstnC= new GSTN_Info__c();
        gstnC.GST_Number__c= '33ADHPN9706C1ZQ';
        gstnC.Status__c= 'Success';
        gstnC.Parent__c= gstnP.Id;
        gstnC.RecordTypeId= RecordTypeIdGstnC;
        gstnC.Months__c= '9';
        gstnC.To_Date__c= '122018';
        insert gstnC;

        GSTN_Info__c gstnC1= SME_TestUtil.createGSTInfo(RecordTypeIdGstnC,'33ADHPN9706C1ZQ','Success',gstnP.Id,'12');
        gstnC1.To_Date__c= '122018';
        insert gstnC1;
        
        YTDAnalysisController.ytdAnalysisMap.put('YTD Sales (Rs. )',false);        
        Test.startTest();
        YTDAnalysisController.getAllFlagAnalysis(acc.id,genApp_Enhancement.id);
        YTDAnalysisController.getAllFlagAnalysis(acc.id,genApp_Newloan.id);
        Test.stopTest();
        
    }
    
}