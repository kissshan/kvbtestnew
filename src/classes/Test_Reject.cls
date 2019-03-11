@isTest
public class Test_Reject {

    @isTest
    public static void method1(){
        
         genesis__Applications__c app=TestUtility.intialSetUp('Test',true);
        
         Id recordtypeID                      =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
            app.RecordTypeID = recordtypeID;
        
        
        
        clcommon__Collateral__c col=new clcommon__Collateral__c();
        col.EM_Charge_type__c='fresh';
        col.No_of_tenants__c='18';
        col.Vacant_Land_area__c=100000;
        col.genesis__Application__c=app.Id;
        col.clcommon__Collateral_Name__c='Test';   
        insert col;
        
        app.Sub_Stage__c='Property information captured';
        
        update app;
    }
}