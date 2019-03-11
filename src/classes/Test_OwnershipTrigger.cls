//written by:- prashant singh
//code coverage:-92%
@istest
public class Test_OwnershipTrigger {
@testsetup
    public static void setupMethod()
    {
        Account acc = SME_TestUtil.createAccount('HP Agencies4','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;     
        
        Id appRecordTypeId=Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        genesis__Applications__c app = Utility_Test.createApplication('1323', acc.id);
        app.SI_Bank_Name__c='Karur Vysya Bank';
        app.recordtypeid = appRecordTypeId;
        insert app;
        
        clcommon__Collateral__c cc=new clcommon__Collateral__c();
        cc.Advances_Paid__c=100;
        cc.Branch_Name__c='san';
        cc.Dealer_name__c='test';
        cc.Dealer_Email__c='cc@gmail.com';
        cc.genesis__Application__c=app.Id;
        cc.clcommon__Manufacturer__c='ooie';
        cc.clcommon__Model__c='iwej';
        cc.Variant__c='jsdj';
        cc.clcommon__Collateral_Name__c='test123';
        cc.Collateral_Type__c='Vehicles';
        
        insert cc;
        

        Ownership__c ow=new Ownership__c();
        ow.Account__c=acc.id;
        ow.Collateral__c=cc.id;
        insert ow;
        
    }
    @istest
    public static void method1()
    {
        Ownership__c ownr=[select id ,Branch_Code__c,Account__c from Ownership__c];
        ownr.Branch_Code__c='1857';
        update ownr;
        
    }
}