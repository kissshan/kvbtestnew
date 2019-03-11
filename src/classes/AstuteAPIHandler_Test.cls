/*
* Name    	: AstuteAPIHandler_Test
* Company  	: ET Marlabs
* Purpose   : Test class for AstuteAPIHandler
* Author  	: Braj 
*/
//code coverage :-90%

@isTest
public class AstuteAPIHandler_Test
{
    @testSetup 
    static void setup(){
        //initial test setup
        List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);
        
    }
    
    @isTest
    static void testAstuteHandler(){
        System.debug('#####testAstuteHandler');
        
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;
        
        genesis__Applications__c app = [select id,name,genesis__Account__c,Sub_Stage__c,Record_Type_Name__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];
        //app.Pre_approved_flag__c = true;
        app.Perfios_Captured__c = true;
        app.Sanction_Class2_Check__c = true;
        update app;
        
        Account acc = [select id,Customer_ID_Creation_Date__c,Are_you_An_Existing_Customer__c from Account where id=:app.genesis__Account__c];
        acc.Customer_ID_Creation_Date__c = Date.today().addYears(-10);
        acc.Are_you_An_Existing_Customer__c = true;
        update acc;
        
        Test.startTest();
        AstuteAPIHandler.VL_FICheck(app.Id);
        AstuteAPIHandler.AstuteCallHandler(app.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testAstuteHandler1(){
        System.debug('#####testAstuteHandler1');
        
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;
        
        genesis__Applications__c app = [select id,name,genesis__Account__c,Sub_Stage__c,Record_Type_Name__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];
        
        Account acc = [select id,Customer_ID_Creation_Date__c,Are_you_An_Existing_Customer__c from Account where id=:app.genesis__Account__c];
        acc.Customer_ID_Creation_Date__c = Date.today().addMonths(-3);
        acc.Are_you_An_Existing_Customer__c = true;
        update acc;
        
        Test.startTest();
        AstuteAPIHandler.VL_FICheck(app.Id);
        AstuteAPIHandler.AstuteCallHandler(app.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testAstuteHandler2(){
        System.debug('#####testAstuteHandler2');
        
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;
        
        genesis__Applications__c app = [select id,name,genesis__Account__c,Sub_Stage__c,Record_Type_Name__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];
        
        Account acc = [select id,Customer_ID_Creation_Date__c,Are_you_An_Existing_Customer__c from Account where id=:app.genesis__Account__c];
        acc.Customer_ID_Creation_Date__c = Date.today().addMonths(-3);
        acc.Are_you_An_Existing_Customer__c = false;
        update acc;
        
        Test.startTest();
        AstuteAPIHandler.VL_FICheck(app.Id);
        AstuteAPIHandler.AstuteCallHandler(app.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testAstuteHandler3(){
        System.debug('#####testAstuteHandler3');
        
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;
        
        genesis__Applications__c app = [select id,name,genesis__Account__c,Sub_Stage__c,Record_Type_Name__c,Perfios_Captured__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];
        
        Account acc = [select id,Customer_ID_Creation_Date__c,Are_you_An_Existing_Customer__c from Account where id=:app.genesis__Account__c];
        acc.Customer_ID_Creation_Date__c = Date.today().addMonths(-3);
        acc.Are_you_An_Existing_Customer__c = false;
        update acc;
        
        genesis__Application_Parties__c party= [select id,name,CIBIL_Scores__c from genesis__Application_Parties__c where genesis__Application__c =:app.Id Limit 1];
        party.CIBIL_Scores__c = 550;
        update party;
        
        Test.startTest();
        AstuteAPIHandler.VL_FICheck(app.Id);
        AstuteAPIHandler.AstuteCallHandler(app.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testNonVL(){
        System.debug('#####negativeTest');
        
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;
        
        Account acc = [select id,Customer_ID_Creation_Date__c,Are_you_An_Existing_Customer__c from Account Limit 1];
        
        genesis__Applications__c app = VL_Test_Utility.createApplication('1857',acc.Id,'Personal Details Captured','Home Loan');
        insert app;
        
        Test.startTest();
        AstuteAPIHandler.AstuteCallHandler(app.Id);
        Test.stopTest();
    }
    
    @isTest
    static void negativeTest(){
        System.debug('#####negativeTest');
        
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=false;
        insert cs;
        
        Test.startTest();
        AstuteAPIHandler.VL_FICheck('qwerty123456');
        AstuteAPIHandler.AstuteCallHandler('qwerty12345');
        Test.stopTest();
    }
    
}