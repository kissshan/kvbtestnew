/*
* Description : Batch_Cal_CustomerDrawingPower_Test
* Author       : Yadagiri
*/
@isTest
public class Batch_Cal_CustomerDrawingPower_Test {
    @isTest
    public static void method1(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Industry_Type__c='Manufacturing';
        insert acc;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Application_Stage__c='Adhoc Application close';
        genApp.Overall_Exposure__c=2600000;
        insert genApp;  
        
        clcommon__Collateral_Type__c  collType = SME_TestUtil.createCollType('Test Collateral');
        insert collType;
        
        Id clProductRecordType = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clcommon__CL_Product__c clProduct = SME_TestUtil.createClProd('Test Collateral', collType.Id,'Test KVB');
        clProduct.clcommon__Product_Name__c='Test KVB Product';
        clProduct.RecordTypeId=clProductRecordType;
        insert clProduct;
        
        Facility__c facil = new Facility__c();
        facil.Application__c= genApp.Id;
        facil.CL_Product__c	=clProduct.Id;
        facil.Margin_Stock_Manufacturing__c=2000;
        facil.Existing_Margin_Stock_Manufacturing__c=23;
        facil.Margin_Receivables__c=21;
        insert facil;
        
        Stocks__c stock = new Stocks__c();
        stock.Account__c= acc.Id;
        stock.Month__c ='JAN';
        insert stock;
        
        Stock_Statement__c stockStatmnt = new Stock_Statement__c();
        stockStatmnt.Stocks__c=stock.Id;
        insert stockStatmnt;
        
        Stock_Below_Limit__c stockbelowLimit = new Stock_Below_Limit__c();
        stockbelowLimit.Stocks__c= stock.id;
        insert stockbelowLimit;
        
        Sundry_Creditors__c sundryCredit = SME_TestUtil.createSundryCreditors(acc.Id,'31-60',20000,'2018-19','Shatagni TradeCenter');
        insert sundryCredit;
        
        Debtors__c  deb = SME_TestUtil.createDeb(acc.Id,'Yadagiri','31-60',25000,'2018-19');
        insert deb;
        
        Test.startTest();
        Batch_Cal_CustomerDrawingPower obj = new Batch_Cal_CustomerDrawingPower();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
    
    @isTest
    public static void method2(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Industry_Type__c= 'Trading';
        insert acc;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Application_Stage__c='Adhoc Application close';
        genApp.Overall_Exposure__c=2200000;
        insert genApp;  
        
        clcommon__Collateral_Type__c  collType = SME_TestUtil.createCollType('Test Collateral');
        insert collType;
        
        Id clProductRecordType = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        
        clcommon__CL_Product__c clProduct = SME_TestUtil.createClProd('Test Collateral', collType.Id,'202');
        clProduct.clcommon__Product_Name__c='Test KVB Product';
        clProduct.RecordTypeId=clProductRecordType;
      
        insert clProduct;
        
        Facility__c facil = new Facility__c();
        facil.Application__c= genApp.Id;
        facil.CL_Product__c	=clProduct.Id;
        facil.Margin_Stock_Manufacturing__c=2000;
        facil.Existing_Margin_Stock_Manufacturing__c=23;
        facil.Margin_Receivables__c=21;
        insert facil;
        
        Stocks__c stock = new Stocks__c();
        stock.Account__c= acc.Id;
        stock.Month__c ='JAN';
        insert stock;
        
        Stock_Statement__c stockStatmnt = new Stock_Statement__c();
        stockStatmnt.Stocks__c=stock.Id;
        insert stockStatmnt;
        
        Stock_Below_Limit__c stockbelowLimit = new Stock_Below_Limit__c();
        stockbelowLimit.Stocks__c= stock.id;
        insert stockbelowLimit;
        
        Sundry_Creditors__c sundryCredit = SME_TestUtil.createSundryCreditors(acc.Id,'31-60',20000,'2018-19','Shatagni TradeCenter');
        insert sundryCredit;
        
        Debtors__c  deb = SME_TestUtil.createDeb(acc.Id,'Yadagiri','31-60',25000,'2018-19');
        insert deb;
        
        Test.startTest();
        Batch_Cal_CustomerDrawingPower obj = new Batch_Cal_CustomerDrawingPower();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
}