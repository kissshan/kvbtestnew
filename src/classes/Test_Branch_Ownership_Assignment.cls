/*
 * Purpose: Test class for Branch_Ownership_Assignment class
 * Author :Yadagiri
*/
@isTest  
public class Test_Branch_Ownership_Assignment {
    
 public static testmethod void testMethod1() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        u.Office_Code__c='1857';
        u.isActive= true;
        insert u;
     System.debug('u.Office_Code__c'+u.Office_Code__c);
         System.RunAs(u){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.OwnerId=u.Id;
        insert acc;

        //Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Active__c = true;
        genApp.Branch_Code__c='1857';
        genApp.OwnerId=u.Id;
        //genApp.RecordTypeId=genAppRecordType;
        insert genApp;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('Test Prodcuct','KVB45','Funded');
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'test2345',2345.50);
        fac.Existing_Limit__c=4555.44;
        insert fac;
        
        genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,acc.id,'Partner','Pending');
        genAppPart.Active__c=true;
        genAppPart.Key_Contact__c=acc.Id;
        insert genAppPart;
        
        clcommon__Collateral__c clCollater = SME_TestUtil.createcollateral(genApp.Id,'Test collateral','Vacant Land');
        insert clCollater;
        
        genesis__Application_Collateral__c genAppColl = SME_TestUtil.createAppCollateral(acc.Id,genApp.Id,fac.Id,clCollater.Id);
        insert genAppColl;
       
        ints__TransUnion_Credit_Report__c transUnion = new ints__TransUnion_Credit_Report__c();
        transUnion.Account__c = acc.id;
        insert transUnion;
         
            Test.startTest();
            Branch_Ownership_Assignment ob=new Branch_Ownership_Assignment();
            DataBase.executeBatch(ob);
            Test.stopTest();
         } 
    }
}