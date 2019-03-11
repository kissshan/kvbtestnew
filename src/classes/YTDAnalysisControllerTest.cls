/*
* Name     : YTDAnalysisControllerTest
* Company  : ET Marlabs
* Purpose  : This class is used as a test class for 'YTDAnalysisController' class
* Author   : Souvik Banik
* Last Modified by : Yadagiri
*/

@isTest
public class YTDAnalysisControllerTest {
    
    @isTest
    public static void create_App_Acc_M68(){
        
        
        Account acc = new Account(FirstName = 'Test', LastName = 'Data');
        Insert acc;
        
        genesis__Applications__c genApp_Enhancement=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        
        genApp_Enhancement.Application_Stage__c     = 'Enhancement- Application created';
        genApp_Enhancement.RecordTypeId             = SOQL_Util.getRecordTypeId('SME_Enhancement');
        Insert genApp_Enhancement;
        
        genesis__Applications__c genApp_Exceeding=SME_TestUtil.createApplication('KB231',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp_Exceeding.Application_Stage__c     = 'Exceeding- Application created';
        genApp_Exceeding.RecordTypeId             = SOQL_Util.getRecordTypeId('SME_Exceeding');
        Insert genApp_Exceeding;
        
        genesis__Applications__c genApp_AdHoc=SME_TestUtil.createApplication('KB231',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp_AdHoc.Application_Stage__c     = 'Adhoc- Application created';
        genApp_AdHoc.RecordTypeId             = SOQL_Util.getRecordTypeId('SME_AdHoc');
        Insert genApp_AdHoc;
        
        M68_Balance_Sheet_Analysis__c current_Year_m68BalSheet       = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68',acc.Id,'Perfios','Estimated','Apr-Feb','2018-19',123.45);
        Insert current_Year_m68BalSheet;
        
        M68_Balance_Sheet_Analysis__c n_1_Year_m68BalSheet       = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68',acc.Id,'Perfios','Estimated','Apr-Feb','2018-19',123.45);
        Insert n_1_Year_m68BalSheet;
        
        M68_Balance_Sheet_Analysis__c n_2_Year_m68BalSheet       = SME_TestUtil.createM68BalSheetAnalysis('Test Data for M68',acc.Id,'Perfios','Estimated','Apr-Feb','2018-19',123.45);
        Insert n_2_Year_m68BalSheet;
        
        M68_Balance_Sheet_Analysis__c estimated_m68BalSheet 		= (M68_Balance_Sheet_Analysis__c)TestUtil_SME.createSobjectTypeRecord('M68_Balance_Sheet_Analysis__c',
                                                                                                                                          null,new Map<String,Object>{'Account__c'=>acc.Id,'Financial_type__c'=>'Estimated',
                                                                                                                                              'Fiscal_Year__c'=>'2018-19','Net_sales__c'=>700.23,'Purchases__c'=>200.0,'Sundry_Creditors__c'=>13,
                                                                                                                                              'Sundry_Debtors__c'=>100000});
        Insert estimated_m68BalSheet;
        
        M68_Balance_Sheet_Analysis__c projected_m68BalSheet 		= (M68_Balance_Sheet_Analysis__c)TestUtil_SME.createSobjectTypeRecord('M68_Balance_Sheet_Analysis__c',
                                                                                                                                          null,new Map<String,Object>{'Account__c'=>acc.Id,'Financial_type__c'=>'Projected',
                                                                                                                                              'Fiscal_Year__c'=>'2019-20','Net_sales__c'=>900.23,'Purchases__c'=>300.0,'Sundry_Creditors__c'=>13,
                                                                                                                                              'Sundry_Debtors__c'=>100000});
        Insert projected_m68BalSheet;
        
        M68_Balance_Sheet_Analysis__c ytd_m68BalSheet 			= (M68_Balance_Sheet_Analysis__c)TestUtil_SME.createSobjectTypeRecord('M68_Balance_Sheet_Analysis__c',
                                                                                                                                      null,new Map<String,Object>{'Account__c'=>acc.Id,'Financial_type__c'=>'YTD',
                                                                                                                                          'Fiscal_Year__c'=>'2017-18','Net_sales__c'=>500.23,'Purchases__c'=>100.0,'Sundry_Creditors__c'=>13,
                                                                                                                                          'Sundry_Debtors__c'=>100000});
        Insert ytd_m68BalSheet;
        
        Test.startTest();
        
        YTDAnalysisController.getAllFlagAnalysis(acc.Id,genApp_Enhancement.Id);
        YTDAnalysisController.getAllFlagAnalysis(acc.Id,genApp_Exceeding.Id);
        YTDAnalysisController.getAllFlagAnalysis(acc.Id,genApp_AdHoc.Id);
        YTDAnalysisHelper.getCreditorDebitorsFlag(acc.Id);
        YTDAnalysisHelper.getSalesAnalysisFlag(400.23,300.23,700.23,'EST');
        YTDAnalysisHelper.getSalesAnalysisFlag(400.23,300.23,900.23,'PROJ');
        YTDAnalysisHelper.getPurchaseAnalysisFlag(400.23,300.23,200.0,'EST');
        YTDAnalysisHelper.getPurchaseAnalysisFlag(400.23,300.23,300.23,'PROJ');
        YTDAnalysisHelper.getYTDAnalysis(ytd_m68BalSheet,'SALES',700.23);
        YTDAnalysisHelper.getYTDAnalysis(ytd_m68BalSheet,'PURCHASE',200.0);
        YTDAnalysisHelper.isExceedingAdhocLessThanFifty(null);
        YTDAnalysisHelper.getYTDAnalysis(null,null,null);
        YTDAnalysisHelper.getDeltaFlag(null,null,null,null);
        YTDAnalysisHelper.calculateVelocity(null,null);
        Test.stopTest();
        
    }
    
}