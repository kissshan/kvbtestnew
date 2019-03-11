//code coverage :-96%
@isTest
public class Test_AstuteVerificationTriggerHandler {
    @isTest
    public static void method1(){
        
        List<Astute_Verification__c> astutelist= new List<Astute_Verification__c>();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        genesis__Applications__c app2 = TestUtility.intialSetUp('LAP', false);
        
        Astute_Verification__c astuteobj = new Astute_Verification__c();
        astuteobj.Case_Notification_Id__c ='Name';
        astuteobj.Status__c='SUCCESS';
        astuteobj.Application__c=app.id;
        astuteobj.DeDupe_Status__c='Match found';
        
        Astute_Verification__c astuteobj2 = new Astute_Verification__c();
        astuteobj2.Case_Notification_Id__c ='Name2';
        astuteobj2.Status__c='SUCCESS';
        astuteobj2.Application__c=app2.id;
        astuteobj2.DeDupe_Status__c='Match found';
        
        astutelist.add(astuteobj);
        astutelist.add(astuteobj2);
        
        insert astutelist; 
        AstuteVerificationTriggerHandler.fiStatusUpdate(astutelist);
        AstuteVerificationTriggerHandler.fiStatusInsert(astutelist);
        
    }
    
    @isTest
    public static void method2(){
        
        List<Astute_Verification__c> astutelist= new List<Astute_Verification__c>();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        genesis__Applications__c app2 = TestUtility.intialSetUp('LAP', false);
        
        Astute_Verification__c astuteobj = new Astute_Verification__c();
        astuteobj.Case_Notification_Id__c ='Name';
        astuteobj.Status__c='SUCCESS';
        astuteobj.Application__c=app.id;
        astuteobj.DeDupe_Status__c='Match Not found';
        astuteobj.Residence_Verification__c = 'Negative';
        astuteobj.Property_Type__c = 'Office';
        
        Astute_Verification__c astuteobj2 = new Astute_Verification__c();
        astuteobj2.Case_Notification_Id__c ='Name2';
        astuteobj2.Status__c='SUCCESS';
        astuteobj2.Application__c=app2.id;
        astuteobj2.DeDupe_Status__c='Match Not found';
        astuteobj2.Residence_Verification__c = 'Negative';
        astuteobj2.Property_Type__c = 'Office';
        
        astutelist.add(astuteobj);
        astutelist.add(astuteobj2);
        
        insert astutelist; 
        AstuteVerificationTriggerHandler.fiStatusUpdate(astutelist);
        AstuteVerificationTriggerHandler.fiStatusInsert(astutelist);
        
    }
    
    @isTest
    public static void method3(){
        
        List<Astute_Verification__c> astutelist= new List<Astute_Verification__c>();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        genesis__Applications__c app2 = TestUtility.intialSetUp('LAP', false);
        
        Astute_Verification__c astuteobj = new Astute_Verification__c();
        astuteobj.Case_Notification_Id__c ='Name';
        astuteobj.Status__c='SUCCESS';
        astuteobj.Application__c=app.id;
        astuteobj.DeDupe_Status__c='Match Not found';
        astuteobj.Employer_Verification__c = 'Refer';
        astuteobj.Property_Type__c = 'Office';
        
        Astute_Verification__c astuteobj2 = new Astute_Verification__c();
        astuteobj2.Case_Notification_Id__c ='Name2';
        astuteobj2.Status__c='SUCCESS';
        astuteobj2.Application__c=app2.id;
        astuteobj2.DeDupe_Status__c='Match Not found';
        astuteobj2.Employer_Verification__c = 'Refer';
        astuteobj2.Property_Type__c = 'Office';
        
        astutelist.add(astuteobj);
        astutelist.add(astuteobj2);
        
        insert astutelist; 
        AstuteVerificationTriggerHandler.fiStatusUpdate(astutelist);
        AstuteVerificationTriggerHandler.fiStatusInsert(astutelist);
        
    }
    @isTest
    public static void method4(){
        
        List<Astute_Verification__c> astutelist= new List<Astute_Verification__c>();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        genesis__Applications__c app2 = TestUtility.intialSetUp('LAP', false);
        
        Astute_Verification__c astuteobj = new Astute_Verification__c();
        astuteobj.Case_Notification_Id__c ='Name';
        astuteobj.Status__c='SUCCESS';
        astuteobj.Application__c=app.id;
        astuteobj.DeDupe_Status__c='Match Not found';
        astuteobj.Employer_Verification__c = 'Negative';
        astuteobj.Property_Type__c = 'Office';
        
        Astute_Verification__c astuteobj2 = new Astute_Verification__c();
        astuteobj2.Case_Notification_Id__c ='Name2';
        astuteobj2.Status__c='SUCCESS';
        astuteobj2.Application__c=app2.id;
        astuteobj2.DeDupe_Status__c='Match Not found';
        astuteobj2.Employer_Verification__c = 'Negative';
        astuteobj2.Property_Type__c = 'Office';
        
        astutelist.add(astuteobj);
        astutelist.add(astuteobj2);
        
        insert astutelist; 
        AstuteVerificationTriggerHandler.fiStatusUpdate(astutelist);
        AstuteVerificationTriggerHandler.fiStatusInsert(astutelist);
        
    }
    @isTest
    public static void method5(){
        
        List<Astute_Verification__c> astutelist= new List<Astute_Verification__c>();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        genesis__Applications__c app2 = TestUtility.intialSetUp('LAP', false);
        
        Astute_Verification__c astuteobj = new Astute_Verification__c();
        astuteobj.Case_Notification_Id__c ='Name';
        astuteobj.Status__c='SUCCESS';
        astuteobj.Application__c=app.id;
        astuteobj.DeDupe_Status__c='Match Not found';
        astuteobj.Residence_Verification__c = 'Refer';
        astuteobj.Property_Type__c = 'Office';
        
        Astute_Verification__c astuteobj2 = new Astute_Verification__c();
        astuteobj2.Case_Notification_Id__c ='Name2';
        astuteobj2.Status__c='SUCCESS';
        astuteobj2.Application__c=app2.id;
        astuteobj2.DeDupe_Status__c='Match Not found';
        astuteobj2.Residence_Verification__c = 'Refer';
        astuteobj2.Property_Type__c = 'Office';
        
        astutelist.add(astuteobj);
        astutelist.add(astuteobj2);
        
        insert astutelist; 
        AstuteVerificationTriggerHandler.fiStatusUpdate(astutelist);
        AstuteVerificationTriggerHandler.fiStatusInsert(astutelist);
        
    }
    @isTest
    public static void method6(){
        
        List<Astute_Verification__c> astutelist= new List<Astute_Verification__c>();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        genesis__Applications__c app2 = TestUtility.intialSetUp('LAP', false);
        
        Astute_Verification__c astuteobj = new Astute_Verification__c();
        astuteobj.Case_Notification_Id__c ='Name';
        astuteobj.Status__c='SUCCESS';
        astuteobj.Application__c=app.id;
        astuteobj.DeDupe_Status__c='Match Not found';
        astuteobj.Residence_Verification__c = 'Positive';
        astuteobj.Property_Type__c = 'Office';
        
        Astute_Verification__c astuteobj2 = new Astute_Verification__c();
        astuteobj2.Case_Notification_Id__c ='Name2';
        astuteobj2.Status__c='SUCCESS';
        astuteobj2.Application__c=app2.id;
        astuteobj2.DeDupe_Status__c='Match Not found';
        astuteobj.Residence_Verification__c = 'Positive';
        astuteobj2.Property_Type__c = 'Office';
        
        astutelist.add(astuteobj);
        astutelist.add(astuteobj2);
        
        insert astutelist; 
        AstuteVerificationTriggerHandler.fiStatusUpdate(astutelist);
        AstuteVerificationTriggerHandler.fiStatusInsert(astutelist);
        
    }
    
    @isTest
    public static void method7(){
        
        List<Astute_Verification__c> astutelist= new List<Astute_Verification__c>();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        genesis__Applications__c app2 = TestUtility.intialSetUp('LAP', false);
        
        Astute_Verification__c astuteobj = new Astute_Verification__c();
        astuteobj.Case_Notification_Id__c ='Name';
        astuteobj.Status__c='SUCCESS';
        astuteobj.Application__c=app.id;
        astuteobj.DeDupe_Status__c='Match Not found';
        astuteobj.Residence_Verification__c = 'Positive';
        astuteobj.Property_Type__c = 'Office';
        astuteobj.Case_Id__c = 'Manual';
        
        
        Astute_Verification__c astuteobj2 = new Astute_Verification__c();
        astuteobj2.Case_Notification_Id__c ='Name2';
        astuteobj2.Status__c='SUCCESS';
        astuteobj2.Application__c=app2.id;
        astuteobj2.DeDupe_Status__c='Match Not found';
        astuteobj.Residence_Verification__c = 'Positive';
        astuteobj2.Property_Type__c = 'Office';
        astuteobj2.Case_Id__c = 'Manual';
        
        astutelist.add(astuteobj);
        astutelist.add(astuteobj2);
        
        insert astutelist; 
        Test.startTest();
        AstuteVerificationTriggerHandler.fiStatusInsert(astutelist);
        Test.stopTest();
    }
    
    @isTest
    public static void method8(){
        
        List<Astute_Verification__c> astutelist= new List<Astute_Verification__c>();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        genesis__Applications__c app2 = TestUtility.intialSetUp('LAP', false);
        
        Astute_Verification__c astuteobj = new Astute_Verification__c();
        astuteobj.Case_Notification_Id__c ='Name';
        astuteobj.Status__c='SUCCESS';
        astuteobj.Application__c=app.id;
        astuteobj.Property_Type__c = 'Office';
        
        
        Astute_Verification__c astuteobj2 = new Astute_Verification__c();
        astuteobj2.Case_Notification_Id__c ='Name2';
        astuteobj2.Status__c='SUCCESS';
        astuteobj2.Application__c=app2.id;
        astuteobj2.Property_Type__c = 'Office';
        
        astutelist.add(astuteobj);
        astutelist.add(astuteobj2);
        
        insert astutelist; 
        Test.startTest();
        AstuteVerificationTriggerHandler.fiStatusInsert(astutelist);
        Test.stopTest();
    }
    
}