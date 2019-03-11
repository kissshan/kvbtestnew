/*
 * Purpose : Test class for the Batch_eStamp_B1_DocGeneration class 
 *Author :Yadagiri 
 */
@isTest
public class Batch_eStamp_B1_DocGeneration_Test {
    
     public static testmethod void testMethod1() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            insert genApp;
            
            clcommon__Collateral__c clCollateral = SME_TestUtil.createcollateral(genApp.Id,'Test colletaral','Vacant Land');
            clCollateral.Active__c=true;
            insert clCollateral;
            Test.startTest();
            Batch_eStamp_B1_DocGeneration ob=new Batch_eStamp_B1_DocGeneration(genApp.Id);
            DataBase.executeBatch(ob);
            Test.stopTest();
        }
     }
}