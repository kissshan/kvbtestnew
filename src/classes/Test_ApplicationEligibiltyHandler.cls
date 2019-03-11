@isTest
public class Test_ApplicationEligibiltyHandler {
    public static genesis__Applications__c genApp;
    //public static Account acc;
    public static genesis__Application_Parties__c genAppParty;
    
    @isTest
    public static void init(){
        Trigger_Setting__c custmsetting=new Trigger_Setting__c();
        custmsetting.Execute_Application_Trigger__c=true;
        insert custmsetting;
        ApplicationTriggerHandler.IsFirstRun=true;
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Property Information Captured';//Constants.Sub_Stage_PropInfoCaptured;
        update genApp;
        Account acct = new Account(firstName='Venu',LastName='Gopal');
        insert acct;
        System.assertEquals(genApp.Sub_Stage__c , Constants.Sub_Stage_PropInfoCaptured);
        System.debug('>>>>>>'+genApp.Sub_Stage__c);
        System.debug('>>>>>>'+Constants.Sub_Stage_PropInfoCaptured);
       
    }
    @isTest
    public static void init2(){
        Trigger_Setting__c custmsetting=new Trigger_Setting__c();
        custmsetting.Execute_Application_Trigger__c=true;
        insert custmsetting;
        ApplicationTriggerHandler.IsFirstRun=true;
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId(); 
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Property Information Captured';//Constants.Sub_Stage_PropInfoCaptured;
        genApp.RecordTypeId=RecordTypeIdgenApp;
        update genApp;
        Account acct = new Account(firstName='Venu',LastName='Gopal');
        insert acct;
        genesis__Application_Parties__c par=VL_Test_Utility.createAppParty(acct.id,genApp.id,'co-borrower');
        insert par;
        System.assertEquals(genApp.Sub_Stage__c , Constants.Sub_Stage_PropInfoCaptured);
        System.debug('>>>>>>'+genApp.Sub_Stage__c);
        System.debug('>>>>>>'+Constants.Sub_Stage_PropInfoCaptured);
       
    }
     @isTest
    public static void init02(){
        Trigger_Setting__c custmsetting=new Trigger_Setting__c();
        custmsetting.Execute_Application_Trigger__c=true;
        insert custmsetting;
        ApplicationTriggerHandler.IsFirstRun=true;
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId(); 
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Property Information Captured';//Constants.Sub_Stage_PropInfoCaptured;
        genApp.RecordTypeId=RecordTypeIdgenApp;
        update genApp;
        Account acct = new Account(firstName='Venu',LastName='Gopal');
        insert acct;
        
        genesis__Application_Parties__c part=new genesis__Application_Parties__c();
        part.CIBIL_Scores__c=700;
        part.genesis__Application__c = genApp.id;
        part.genesis__Party_Account_Name__c = acct.id;
        part.Employment_Types__c = 'Salaried';
        part.genesis__Party_Type__c =  'Co-Borrower';
        part.Financial_Applicant__c = True;
        part.Net_Monthly_Income__c = 200000;
        
        insert part;
        
        genesis__Application_Parties__c par=VL_Test_Utility.createAppParty(acct.id,genApp.id,'co-borrower');
        insert par;
        System.assertEquals(genApp.Sub_Stage__c , Constants.Sub_Stage_PropInfoCaptured);
        System.debug('>>>>>>'+genApp.Sub_Stage__c);
        System.debug('>>>>>>'+Constants.Sub_Stage_PropInfoCaptured);
       
    }
   
    public static void methodCheckEMI(){
        init();
        List<genesis__Applications__c> genAppList = new List<genesis__Applications__c>();
        genAppList.add(genApp);
        System.debug('~~genAppList'+genAppList);
        Map<Id,genesis__Applications__c> mapGenApp = new Map<Id,genesis__Applications__c>();
        mapGenApp.put(genApp.Id, genApp);
        System.debug('~~mapGenApp'+mapGenApp);
        ApplicationEligibiltyHandler.CheckEMI(genAppList, mapGenApp);
    }
    /*@isTest
    public static void methodGetEmi_LTV_ROIValues(){
        init();
        List<genesis__Applications__c> genAppList = new List<genesis__Applications__c>();
        genAppList.add(genApp);
        
        
        
        
        ApplicationEligibiltyHandler.getEmi_LTV_ROIValues(genAppList);
    }*/
    
}