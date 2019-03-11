/*
* Description : ApplicationTriggerHandler_Test
* Author       : Yadagiri
*/
@isTest
public class ProcessingFee_Test {
@isTest
    public static void method1(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
         Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Project_Master__c projmaster = new Project_Master__c();
            projmaster.Project_Code__c='PC-12';
            insert projmaster;
            
            
             Flat_Master__c flatmaster = new Flat_Master__c();
            flatmaster.ProjectCode__c=projmaster.Id;
            flatmaster.Flat_No_House_No__c='T-45';
            insert flatmaster;
            System.debug('**flatmaster'+flatmaster);
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();

            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='FI Approved';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=45.6;
            genApp.RecordTypeId=genAppRecordType;

            insert genApp;
           
            genesis__Applications__c gpps = new genesis__Applications__c();
            gpps.Sub_Stage__c='Loan Pre - Approved STP';
            gpps.Loan_Purpose__c='Repair or Renovation of House';
            gpps.Flat_No__c='T-42';
            gpps.id = genApp.Id;
            //update genApp;
            
            genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
            genAppPart.Active__c=True;
            insert genAppPart;
            
            /////
            //
  /*         Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(acc.id);

        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id); 

        // Submit the record to specific process and skip the criteria evaluation
//      req1.setProcessDefinitionNameOrId('Example_Process');
        req1.setSkipEntryCriteria(true);

        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);*/
            
           
            
            
             Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            Test.startTest();
        //  ProcessingFee.CallCalculatefee(new List<genesis__Applications__c>{genApp},genAppOldMap,new List<genesis__Applications__c>{genApp},genAppOldMap);
            ProcessingFee.calculateFeeList(new set<Id>{genApp.id},new set<Id>{acc.id});
            ProcessingFee.callPropertyDetails(new List<genesis__Applications__c>{gpps},genAppOldMap);
            ProcessingFee.PropertyDetails(new List<genesis__Applications__c>{genApp},new set<string>{'T-42','T-45'});
          //  ProcessingFee.RejectedCheck(genAppOldMap);
            Test.stopTest();

        }
    }
    
@isTest
public static void method2(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
         Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;

            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();

            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='FI Approved';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=2600000.00;
            genApp.RecordTypeId=genAppRecordType;

            insert genApp;
           
            genApp.Sub_Stage__c='Loan Pre - Approved STP';
            genApp.Loan_Purpose__c='Repair or Renovation of House';
            genApp.Flat_No__c='T-42';
            update genApp;
            
           
            Test.startTest();
            ProcessingFee.calculateFeeList(new set<Id>{genApp.id},new set<Id>{acc.id});
            
            Test.stopTest();

        }
    }
@isTest
public static void method3(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
         Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;

            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();

            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='FI Approved';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=5600000.00;
            genApp.RecordTypeId=genAppRecordType;

            insert genApp;
           
           
            Test.startTest();
            ProcessingFee.calculateFeeList(new set<Id>{genApp.id},new set<Id>{acc.id});
            
            Test.stopTest();

        }
    }
@isTest
public static void method4(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
         Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;

            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();

            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='FI Approved';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=5600000.00;
            genApp.RecordTypeId=genAppRecordType;
  			genApp.Processing_Charges__c=28000.00;
            genApp.Branch_State__c='Andra Pradesh';
            genApp.Total_Stamp_Paper_Charge__c=345.00;
            insert genApp;
           
            Test.startTest();
            ProcessingFee.calculateFeeList(new set<Id>{genApp.id},new set<Id>{acc.id});
            Test.stopTest();

        }
    }
@isTest
public static void method5(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
         Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;

            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();

            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='FI Approved';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=5600000.00;
            genApp.RecordTypeId=genAppRecordType;
  			genApp.Processing_Charges__c=28000.00;
            genApp.Branch_State__c='Andra Pradesh';
            genApp.Pre_Renewal_Checklist__c='Completed';
            insert genApp;
            
            genApp.Sub_Stage__c='Personal Details Captured';
            update genApp;
            
           
            clcommon__Collateral__c  clcollateral= SME_Testutil.createcollateral(genApp.Id,'Test colleteral','Vacant Land');
            clcollateral.Collateral_Market_Value__c=20000001.00;
            insert clcollateral;
            
            Test.startTest();
            ProcessingFee.calculateFeeList(new set<Id>{genApp.id},new set<Id>{acc.id});
            Test.stopTest();

        }
    }
    
@isTest
     public static void method6(){
         Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=true;
        //cs.Other fiels values
     insert cs;
         Utility.runApplicationTrigger();
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
         Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Map<Id,Account> accOldMap = new Map<Id,Account>();
            accOldMap.put(acc.Id, acc);
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();

            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Industry_type_Application__c='Manufacturing';
            genApp.Sub_Stage__c='FI Approved';
            genApp.Loan_Purpose__c='Construction on Own Land';
            genApp.Flat_No__c='T-45';
            genApp.genesis__Loan_Amount__c=45.6;
            genApp.RecordTypeId=genAppRecordType;

            insert genApp;
           
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            
            List<genesis__Applications__c> oldlist=new List<genesis__Applications__c>{genApp};
            
         //   genesis__Applications__c genApp = new genesis__Applications__c();
            genApp.Sub_Stage__c='Personal Details Captured';
            genApp.Loan_Purpose__c='Repair or Renovation of House';
            genApp.Flat_No__c='T-42';
            genApp.genesis__Loan_Amount__c=77789;
         // genApp.id = genApp.Id;
            update genApp;
            Map<Id,genesis__Applications__c> genAppnewMap = new Map<Id,genesis__Applications__c>();
            genAppnewMap.put(genApp.Id, genApp);
            List<genesis__Applications__c> newlist=new List<genesis__Applications__c>{genApp};
            
            genesis__Application_Parties__c genAppPart= SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
            genAppPart.Active__c=True;
            insert genAppPart;
            
            Project_Master__c projmaster = new Project_Master__c();
            projmaster.Project_Code__c='PC-12';
            insert projmaster;
            
            Flat_Master__c flatmaster = new Flat_Master__c();
            flatmaster.ProjectCode__c=projmaster.Id;
            flatmaster.Flat_No_House_No__c='T-42';
            insert flatmaster;
            
            
             
            Test.startTest();
         // ProcessingFee.CallCalculatefee(newlist,genAppOldMap,oldlist,genAppnewMap);
            Test.stopTest();

        }
    }
}