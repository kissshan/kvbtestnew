/*
* Description : PerfiosTriggerHandler_Test
* Author       : Yadagiri
*/
@isTest
public class PerfiosTriggerHandler_Test {
    @isTest
    public static void method1(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
             Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
           Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.RecordTypeId=genAppRecordType;
            insert genApp;
            
            Perfios__c perfio = SME_TestUtil.createperfios(genApp.Id, acc.Id);
            perfio.EMI_for_Latest_Month__c=23.33;
            insert perfio;
            
            Map<Id,Perfios__c> perfioOldMap = new Map<Id,Perfios__c>();
            perfioOldMap.put(perfio.Id, perfio);
            
            Update perfio;
            
           Map<Id,Perfios__c> perfioNewMap = new Map<Id,Perfios__c>();
           perfioNewMap.put(perfio.Id, perfio);
            
            Test.startTest();
           PerfiosTriggerHandler perfiotriggerhandler = PerfiosTriggerHandler.getInstance();
           perfiotriggerhandler.afterUpdate(perfioNewMap,perfioOldMap);
           perfiotriggerhandler.updateEmiAcc(new List<Perfios__c>{perfio},perfioOldMap);
            Test.stopTest();
            
        }
    }

}