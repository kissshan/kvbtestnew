@isTest
public class Test_BRE_ScoreCalExperian {
    public static genesis__Applications__c app;
    
   @isTest 
    public static void method1(){
        app=TestUtility.intialSetUp('HomeLoan',true);
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc= new Account(
          RecordTypeID=recordTypeId ,
          FirstName='Test FName',
          LastName='Test LName',
          Aadhaar_Number__pc='678905642341',
          Pan_Number__c='AAAPL1234C',
          PersonMailingStreet='test@yahoo.com',
          PersonMailingPostalCode='12345',
          PersonMailingCity='SFO',
          PersonEmail='test@yahoo.com',
          PersonHomePhone='1234567',
          PersonMobilePhone='12345678',
          PersonBirthdate=system.today()  
        );
 
        //insert acc;
        
       /*  List<AccountHistory__c> accounthistoryList = new List<AccountHistory__c>();
        for(Integer i=0; i<5; i++){
            AccountHistory__c accounthistory = new AccountHistory__c();
            accounthistoryList.add(accounthistory);
        }
        insert accounthistoryList;*/
        
      /*  List<TU_Account__c> tu_accountList = new List<TU_Account__c>();
        for(Integer i=0; i<5; i++){
            TU_Account__c tu_account = new TU_Account__c();
            tu_accountList.add(tu_account);
        }
        insert tu_accountList;*/
        
        ints__TransUnion_Credit_Report__c crReport=new ints__TransUnion_Credit_Report__c();
        crReport.Account__c=app.genesis__Account__c;
        crReport.Application__c=app.id;
        insert crReport;
        
        
        TU_Account__c tuacc1=new TU_Account__c();
        tuacc1.High_Credit_Or_Sanctioned_Amount__c='189900';
        tuacc1.TU_Credit_Report__c=crReport.id;
        tuacc1.Account_Type__c='';
        tuacc1.Date_Opened_Or_Disbursed__c='01032019';
        insert tuacc1;
        
        AccountHistory__c accounthistory = new AccountHistory__c();
        accounthistory.TUAccount__c=tuacc1.id;
        accounthistory.AssetClassification__c='yes';
        accounthistory.DaysPastDue__c='01032019';
        accounthistory.Year__c='2019';
        accounthistory.Month__c='02';
        insert accounthistory;
        
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        par.genesis__Application__c=app.id;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
        par.genesis__Party_Type__c='Primary Applicant';
        insert par;
        
       /* List<ints__TransUnion_Credit_Report__c> transunion_credit_reportList = new List<ints__TransUnion_Credit_Report__c>();
        for(Integer i=0; i<2; i++){
            ints__TransUnion_Credit_Report__c transunion_credit_report = new ints__TransUnion_Credit_Report__c();
            transunion_credit_report.Account__c = acc.id;
            transunion_credit_reportList.add(transunion_credit_report);
        }
        insert transunion_credit_reportList;*/
        
        BRE_ScoreCalExperian.BRE_ScoreCalExp(app,null);
    }
    
    @isTest 
    public static void method2(){
        app=TestUtility.intialSetUp('Personal Loan',true);
        app.Sub_Stage__c='Loan Requirement Captured';
        update app;
        List<genesis__Applications__c> applist=new List<genesis__Applications__c>();
        applist.add(app);
        Map<Id,genesis__Applications__c> oldList =new Map<Id,genesis__Applications__c>();
        oldList.put(app.id, app);
        BRE_ScoreCalExperian.ExpBreCal(appList,oldList);
        
    }

}