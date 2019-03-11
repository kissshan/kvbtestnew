//written by prashant singh
//date:-06-10-2018
//code coverage:-83%
//class name:--PartyTriggerHandeller
@istest
public class Test_PartyTriggerHandeller {
@testsetup
    public static void setupMethod()
        
    {	
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
          Account acc = new Account();
         acc.LastName = 'Ashish';
         acc.Full_Name__c = 'Ashish G Jain';
         acc.PersonEmail = 'qulity@data.com';
         acc.PersonMobilePhone = '2335232345'; 
         acc.RecordTypeID = RecordTypeIdclPerson;
         insert acc; 
                Id recordidapp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();

        genesis__Applications__c newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Loan_Number__c = 'TS123'; 
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
        newApp.genesis__Account__c =acc.id;
        //newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = 'Disbursement Rejected';
        newApp.Branch_City__c = '1858';
        newApp.branch_Code__c = '1858';
        newApp.Flags_Raised__c=false;
        newApp.Charges_Processed__c=true;  
         newApp.RecordTypeId=recordidapp; 
        INSERT newApp;
        
          Perfios__c perf = new Perfios__c();
        perf.Applicant_Name__c = acc.id;
         perf.Active__c=true;
         perf.Application__c=newApp.id;
         perf.Bank_Account_Number__c='1185156000000445';
        INSERT perf;
         genesis__Application_Parties__c party =new genesis__Application_Parties__c();
            
            party.Key_Contact__c = acc.id;
            party.genesis__Party_Account_Name__c=acc.id;
            party.genesis__Party_Type__c = Constants.Co_Borrower;
            party.Active__c = true;
        party.Company__c=false;
        party.genesis__Application__c=newApp.id;
        party.Net_Monthly_Income__c=10;
            insert party;
    }
    
        public static testMethod void method1(){
            genesis__Application_Parties__c party=[select id from genesis__Application_Parties__c];
            party.Company__c=false;
            party.Income_Computation_From__c='Bank Statement';
            party.Employment_Types__c='Salaried';
            update party;

        }
    public static testMethod void method2(){
            genesis__Application_Parties__c party=[select id from genesis__Application_Parties__c];
            party.Company__c=false;
            party.Income_Computation_From__c='Bank Statement';
            party.Employment_Types__c='Self-Employed Businessman';
            update party;

        }
      public static testMethod void method3(){
            genesis__Application_Parties__c party=[select id from genesis__Application_Parties__c];
            party.Company__c=false;
            party.Income_Computation_From__c='ITR';
            update party;

        }
    public static testMethod void method4(){
            genesis__Application_Parties__c party=[select id from genesis__Application_Parties__c];
            party.Company__c=false;
            party.Income_Computation_From__c='Form 26 AS';
            update party;

        }
    public static testMethod void method5(){
            list<genesis__Application_Parties__c> listofparty=new list<genesis__Application_Parties__c>([select id,Net_Monthly_Income__c,Computed_NMI__c from genesis__Application_Parties__c]);
        map<id,genesis__Application_Parties__c> mapofparty=new map<id,genesis__Application_Parties__c>([select id,Net_Monthly_Income__c,Computed_NMI__c from genesis__Application_Parties__c]) ;
         new PartyTriggerHandeller().updateITRAndBankStatement(listofparty, mapofparty);
        }
     public static testMethod void method6(){
            genesis__Applications__c app=[select id from genesis__Applications__c];
            Id recordidapp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
            app.RecordTypeId=recordidapp;
            update app;
            genesis__Application_Parties__c party=[select id from genesis__Application_Parties__c];
            party.Company__c=true;
           // party.Income_Computation_From__c='Form 26 AS';
            update party;

        }
     public static testMethod void method7(){
            genesis__Application_Parties__c party=[select id from genesis__Application_Parties__c];
            party.Company__c=false;
            party.Income_Computation_From__c='ITR';
            party.Net_Monthly_Income__c=20000;
            update party;

        }
     public static testMethod void method8(){
           genesis__Application_Parties__c party=[select id,Net_Monthly_Income__c from genesis__Application_Parties__c];
           party.Net_Monthly_Income__c=170000;
           update party;
            list<genesis__Application_Parties__c> listofparty=new list<genesis__Application_Parties__c>([select id,Net_Monthly_Income__c,Computed_NMI__c from genesis__Application_Parties__c]);
        map<id,genesis__Application_Parties__c> mapofparty=new map<id,genesis__Application_Parties__c>([select id,Net_Monthly_Income__c,Computed_NMI__c from genesis__Application_Parties__c]) ;
         new PartyTriggerHandeller().updateITRAndBankStatement(listofparty, mapofparty);
        }
    public static testMethod void method9(){
           genesis__Application_Parties__c party=[select id,Net_Monthly_Income__c from genesis__Application_Parties__c];
           
            list<genesis__Application_Parties__c> listofparty=new list<genesis__Application_Parties__c>([select id,Net_Monthly_Income__c,Computed_NMI__c from genesis__Application_Parties__c]);
            map<id,genesis__Application_Parties__c> mapofparty=new map<id,genesis__Application_Parties__c>([select id,Net_Monthly_Income__c,Computed_NMI__c from genesis__Application_Parties__c]) ;
          party.Net_Monthly_Income__c=170000;
           update party;
        list<genesis__Application_Parties__c> listofoldeparty=new list<genesis__Application_Parties__c>([select id,Net_Monthly_Income__c,Computed_NMI__c from genesis__Application_Parties__c]);
      
        map<id,genesis__Application_Parties__c> mapofoldparty=new map<id,genesis__Application_Parties__c>([select id,Net_Monthly_Income__c,Computed_NMI__c from genesis__Application_Parties__c]) ;
        new PartyTriggerHandeller().checkConditionForBRE_Run_OR_Cibil_Score(listofparty,listofoldeparty,mapofparty,mapofoldparty);
        } 
    
}