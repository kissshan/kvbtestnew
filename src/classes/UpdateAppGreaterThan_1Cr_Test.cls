@isTest
public class UpdateAppGreaterThan_1Cr_Test {
    @isTest
    public static void method1(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Industry_Type__c='Manufacturing';
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Application_Stage__c='Greater than 2Cr.';
        insert genApp;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('Test Product','test234','Non-funded');
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'34455677',345.55);
        fac.Existing_Limit__c=343;
        insert fac;
        
        Test.startTest();
        UpdateAppGreaterThan_1Cr updateAppGreater = new UpdateAppGreaterThan_1Cr(' CustomerID__c IN:custIdSet',new set<string>{'1210009'});
        DataBase.executeBatch(updateAppGreater); 
        updateAppGreater.execute(null,new list<genesis__Applications__c>{genApp});
        updateAppGreater.Finish(null);
        Test.stopTest();
    }
}