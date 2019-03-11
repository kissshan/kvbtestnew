/*
 *LAst Modified by :Yadagiri 
 
 */
@isTest
public class Batch_ToCalculateGroupExposure_Test {
    public static testmethod void testMethod1() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Account acc1 = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc1;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Active__c = true;
            genApp.Application_Stage__c='Limit extended';
            genApp.RecordTypeId=genAppRecordType;
            insert genApp;
            
            Group_Concern__c grpconcern = new Group_Concern__c();
            grpconcern.Group_1__c=acc.Id;
            grpconcern.Type__c='Sister Concern';
            grpconcern.Group_2__c=acc1.Id;
            insert grpconcern;
            
            clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('Test Prodcuct','KVB45','Funded');
            insert clProd;
            
            Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'test2345',2345.50);
            fac.Existing_Limit__c=4555.44;
            insert fac;
            
            genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,acc.id,'Partner','Pending');
            genAppPart.Active__c=true;
            genAppPart.Key_Contact__c=acc.Id;
            genAppPart.genesis__Party_Account_Name__c=acc1.Id;
            insert genAppPart;
            
            Test.startTest();
            Batch_ToCalculateGroupExposure ob=new Batch_ToCalculateGroupExposure();
            DataBase.executeBatch(ob);
            Test.stopTest();
            
        } 
    }
}