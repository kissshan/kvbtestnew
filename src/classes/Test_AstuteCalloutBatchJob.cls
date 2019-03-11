//code coverage-100%
@isTest
public class Test_AstuteCalloutBatchJob { 
    @isTest
    public static void method1()
    {
        List<Astute_Verification__c> astutelist= new List<Astute_Verification__c>();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        app.FI_Status__c = 'Request yet to be initiated';
        app.Sub_Stage__c = 'Terms and Conditions Accepted';
        update app;
        for(Integer i=0 ;i <20;i++)
        {
            Astute_Verification__c astuteobj = new Astute_Verification__c();
            astuteobj.Case_Notification_Id__c ='Name'+i;
            astuteobj.Status__c='Failed';
            astuteobj.Application__c=app.id;
            astutelist.add(astuteobj);
        }
        
        insert astutelist;
        
        Test.startTest();
        
        AstuteCalloutBatchJob obj = new AstuteCalloutBatchJob();
        DataBase.executeBatch(obj); 
        /*SchedulableContext sc;
        
        obj.execute(sc);*/
        Test.stopTest();
    }

    @isTest
    public static void method2()
    {        
        Test.startTest();
        AstuteCalloutBatchJob obj = new AstuteCalloutBatchJob();
        SchedulableContext sc;
        obj.execute(sc);
        Test.stopTest();
    }
}