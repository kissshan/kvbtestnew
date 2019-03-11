//modified by prashant singh on 24-12-2018
//coode coverage:-90%
@isTest
public class Test_Re_run_Bureau {
    
    @testsetup
    public static void setupMethod(){
        
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=true;
        insert cs;
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Financial_Applicant__c=true;
        acc.Jocata_TxnId__c='yesy23';  
        insert acc;
        
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='Test');
        insert product;
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        
        genesis__Applications__c newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
        newApp.genesis__Account__c =acc.id;
        newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = 'Disbursement Rejected';
        newApp.RecordTypeId=genAppRecordType;
        insert newApp;
        

        
        Map<Id,genesis__Applications__c> genOldMap = new Map<Id,genesis__Applications__c>();
        genOldMap.put(newApp.Id, newApp);

        
        genesis__Application_Parties__c party =new genesis__Application_Parties__c();
        party.Key_Contact__c = acc.id;
        party.genesis__Party_Account_Name__c=acc.id;
        party.genesis__Party_Type__c = 'Partner';
        party.Active__c=true;
        party.Key_Contact__c=acc.id;
        party.genesis__Application__c=newApp.Id;
        party.Company__c=true;
        party.Financial_Applicant__c=true;
        insert party;
       /* 
        genesis__Application_Parties__c party2 =new genesis__Application_Parties__c();
        party2.Key_Contact__c = acc.id;
        party2.genesis__Party_Account_Name__c=acc.id;
        party2.genesis__Party_Type__c = Constants.Co_Borrower;
        party2.Active__c=true;
        party2.Key_Contact__c=acc.id;
        insert party2;
        */
        /*Re_run_Bureau.getAccount(newApp.id);
        Re_run_Bureau.getcompany(newApp.id);
        Re_run_Bureau.run_bureau(new List<genesis__Applications__c>{newApp},genOldMap);
        Re_run_Bureau.callJocataTokenMethod('');
        Re_run_Bureau.callCommercial(newApp.Id,'SME');*/
        
        
    }
    @istest
    public static void method1(){
        genesis__Applications__c newApp = [select id from genesis__Applications__c];
        newApp.Sub_Stage__c='Terms and Conditions Accepted';
        update newApp;
        //Re_run_Bureau.getAccount(newApp.id);
        //Re_run_Bureau.getcompany(newApp.id);
        //Re_run_Bureau.run_bureau(new List<genesis__Applications__c>{newApp},genOldMap);
        //Re_run_Bureau.callJocataTokenMethod('');
        //Re_run_Bureau.callCommercial(newApp.Id,'SME');        
    }
}