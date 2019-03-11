// written by prashant singh..............
//date:-20/09/2018....
// code coverage--100%



@isTest
public class Test_Call_BRE_HL {
    @testsetup
    public static void setup()
    {
                clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='product');
        insert product;
        Trigger_Setting__c custmsetting=new Trigger_Setting__c();
        custmsetting.Execute_Application_Trigger__c=true;
        insert custmsetting;
        ApplicationTriggerHandler.IsFirstRun=true;
            
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();

       genesis__Applications__c newApp=new genesis__Applications__c();
        newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Loan_Number__c = 'TS123'; 
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
       // newApp.genesis__Account__c =acc.id;
        //newApp.genesis__CL_Product__c = product.id;
        newApp.Branch_City__c = '1858';
        newApp.branch_Code__c = '1858';
        newApp.Flags_Raised__c=false;
        newApp.Charges_Processed__c=true;       
        newApp.Sub_Stage__c='Disbursement Rejected';
        newApp.RecordTypeId=genAppRecordType;
        newApp.genesis__CL_Product__c=product.id;

        insert newApp;
        
          genesis__Application_Parties__c party =new genesis__Application_Parties__c();     
            party.genesis__Party_Type__c = Constants.Co_Borrower;
            party.Active__c = true;
        party.genesis__Application__c=newApp.id;
            insert party;

        Task newTask = new Task(
Status = 'Not Started', 
Subject = 'Approval for disbursement', 
WhatID=newApp.id
);             
insert newTask;
    }
 
@isTest
    public static void method1(){      
        genesis__Applications__c genapp=[select id,Sub_Stage__c from genesis__Applications__c];
        genapp.Sub_Stage__c='Terms and Conditions Accepted';
        update genapp;
    }
    @isTest
 	public static void method2(){      
        genesis__Applications__c genapp=[select id from genesis__Applications__c];
        genapp.Sub_Stage__c='Loan Requirement Captured';
        update genapp;
    }
    @isTest
 	public static void method3(){      
         Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL2W).getRecordTypeId();
        genesis__Applications__c genapp=[select id from genesis__Applications__c];
        genapp.Sub_Stage__c='Loan Requirement Captured';
        genapp.RecordTypeId=genAppRecordType;

        update genapp;
    }
      @isTest
 	public static void method4(){      
        genesis__Applications__c genapp=[select id,RecordTypeId,Record_Type_Name__c,Loan_Purpose__c from genesis__Applications__c];
        genapp.Loan_Purpose__c=constants.IdentifiedProperty;
        update genapp;
        Call_BRE_HL.DocumnetsCount(genapp);
    }
    
      @isTest
    public static void method5(){      
        genesis__Applications__c genapp=[select id,RecordTypeId,Record_Type_Name__c,Loan_Purpose__c,(select id,genesis__Party_Type__c from genesis__Application_Parties__r) from genesis__Applications__c];
        genapp.Loan_Purpose__c=constants.Construction;
        update genapp;
        system.debug('kk--'+[select id from genesis__Application_Parties__c where genesis__Application__c=:genapp.id]);
        Call_BRE_HL.DocumnetsCount(genapp);
    }
         @isTest
 	public static void method6(){      
        genesis__Application_Parties__c party=[select id,genesis__Party_Type__c from genesis__Application_Parties__c];
        party.genesis__Party_Type__c=Constants.Gurantor;
        update party;
        genesis__Applications__c genApp=[select id,Record_Type_Name__c,RecordTypeId,Loan_Purpose__c,(select id,genesis__Party_Type__c from genesis__Application_Parties__r) from genesis__Applications__c];
        //genesis__Application_Parties__c party=[select id ,(select id,Record_Type_Name__c,RecordTypeId,Loan_Purpose__c from genesis__Applications__r) from genesis__Application_Parties__c];
        system.debug('record:--'+genApp);
        Call_BRE_HL.DocumnetsCount(genApp);

    }
}