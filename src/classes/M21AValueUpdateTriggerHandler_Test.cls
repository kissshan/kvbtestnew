/*
* Description : Batch_CRILIC_API_Test
* Author       : Yadagiri
*/
@isTest
public class M21AValueUpdateTriggerHandler_Test {
     @isTest
    public static void method1(){
        genesis__Applications__c app=TestUtility.intialSetUp('TestName',true);
        
        clcommon__Collateral__c col=new clcommon__Collateral__c(genesis__Application__c=app.id,Active__c=true,clcommon__Collateral_Name__c='test');
        insert col;
        M21_A__c ob=new M21_A__c(Collateral__c=col.id,Comments__c='test',Estimated_value_Rs__c=5555,Visit_Date__c=System.today());
        insert ob;
    }

}