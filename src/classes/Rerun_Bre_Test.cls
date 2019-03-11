/*
* Description : Rerun_Bre_Test
* Author       : Yadagiri
*/
//code coverage-100%
//modified date:-27-11-2018
//modified by :-prashant singh
@isTest
public class Rerun_Bre_Test {
    @testSetup
    public static void setupmethod(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.RecordTypeId=genAppRecordType;
            insert genApp;
            genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
            genAppPart.Active__c=True;
            insert genAppPart;
            
        }
    }
    @isTest
    public static void method1(){
        genesis__Applications__c genApp =[select id,name,Branch_Code__c from genesis__Applications__c where Branch_Code__c='KB23'];
        Test.startTest();
        Rerun_Bre.recallEligibility(genApp.Id,'LAP');
        Test.stopTest();
        
    }
    @isTest
    public static void method2(){
        genesis__Applications__c genApp =[select id,name,Branch_Code__c from genesis__Applications__c where Branch_Code__c='KB23'];
        Test.startTest();
        Rerun_Bre.recallEligibility(genApp.Id,'HL');
        Test.stopTest();
        
    }
    @isTest
    public static void method3(){
        genesis__Applications__c genApp =[select id,name,Branch_Code__c from genesis__Applications__c where Branch_Code__c='KB23'];
        Test.startTest();
        Rerun_Bre.recallEligibility(genApp.Id,'PL');
        Test.stopTest();
        
    }
     @isTest
    public static void method4(){
        genesis__Applications__c genApp =[select id,name,Branch_Code__c from genesis__Applications__c where Branch_Code__c='KB23'];
        Test.startTest();
        Rerun_Bre.recallEligibility(genApp.Id,'vL');
        Test.stopTest();
        
    }
}