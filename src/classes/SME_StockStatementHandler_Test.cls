/*
* Description : ApplicationTriggerHandler_Test
* Author       : Yadagiri
*/
@isTest
public class SME_StockStatementHandler_Test {
    @isTest
    public static void method1(){
        
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        Id genAppRecordType = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();

        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Service_Type_Name__c ='CollateralDlink';
        insert genApp;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('Test product','202','Funded');
        insert clProd;
        
        Id facRecordType = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        
        Facility__c facil = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'202',10000.00);
        facil.RecordTypeId=facRecordType;
        insert facil;
        
        SME_StockStatementHandler.requestHandler(genApp.Id);
        SME_StockStatementHandler.coll_D_Link(genApp);
        
    }
}