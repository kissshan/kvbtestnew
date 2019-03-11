/*
* Description : Batch_GenerateFacility_Doc_Test
* Author       : Yadagiri
*/
@isTest
public class Batch_GenerateFacility_Doc_Test {
    @isTest
    public static void method1(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        insert genApp;
        
        Facility__c fac= new Facility__c();
        fac.Application__c=genApp.Id;
        insert fac;
        
        Test.startTest();
        Batch_GenerateFacility_Doc obj = new Batch_GenerateFacility_Doc(genApp.Id);
        DataBase.executeBatch(obj); 
        Test.stopTest();
        
    }
}