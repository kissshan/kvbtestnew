//written by prashant singh
//code coverage-86%
@isTest
public class Test_SendEmailHandler {
    
    @testsetup
    public static void setupmethod()
    {
              
        Trigger_Setting__c cs = new Trigger_Setting__c();
        cs.Execute_Application_Trigger__c=true;
        insert cs;
        Utility.runApplicationTrigger();
        //Id RecordTypeIdApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home_Loan').getRecordTypeId();
        genesis__Applications__c app=TestUtility.intialSetUp('Test',true);
        
        account acc=[select id from account limit 1];
        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf('test');
        attachment.Name = String.valueOf('A23');
        attachment.ParentId = acc.id; 
        insert attachment;
        Contact cont=new Contact();
        cont.Email='prashant.singh@etmarlabs.com';
        cont.LastName='singh';
        insert cont;
        
        
    }
    @isTest
    public static void method1(){
        Id RecordTypeIdApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        account acc = new Account(firstName='Venu',LastName='Gopal', Employment_Type__c = 'Salaried',Jocata_TxnId__c = '12345',Financial_Applicant__c=true,PersonEmail='prashant.singh@etmarlabs.com');
        insert acc;        
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
        newApp.Flags_Raised__c=true;
        newApp.Charges_Processed__c=true;
        INSERT newApp;
        Map<Id,genesis__Applications__c> oldList=new Map<Id,genesis__Applications__c>();
        oldList.put(newApp.id,newApp);
        
        genesis__Applications__c app=[select id from genesis__Applications__c where Flags_Raised__c=false];
                genesis__Application_Parties__c party=[Select Id,genesis__Party_Account_Name__c From genesis__Application_Parties__c limit 1 ];
        party.genesis__Application__c=app.id;
        party.genesis__Party_Type__c = 'Co-Borrower';
        party.Active__c =True;
        party.genesis__Party_Account_Name__c=acc.id;
        update party;
        
		Attachment attachment=[select id,Name from Attachment limit 1];
        system.Debug('app:-'+app+'   attachment:-'+attachment);
        app.Additional_Income_Approval__c=true;
        app.Sub_Stage__c='Terms and Conditions Accepted';
        app.RecordTypeId=RecordTypeIdApp;
        update app;

        system.debug('party:-'+party);
        list<genesis__Applications__c> applist=new list<genesis__Applications__c>();
        applist.add(app);
      //  SendEmailHandler.SendEmail(app.id, attachment);
        SendEmailHandler.termsEmail(applist,oldList);
        
    }
    
    @isTest
    public static void method2(){
        Id RecordTypeIdApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        account acc = new Account(firstName='Venu',LastName='Gopal', Employment_Type__c = 'Salaried',Jocata_TxnId__c = '12345',Financial_Applicant__c=true);
        insert acc;        
        genesis__Applications__c newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Loan_Number__c = 'TS123'; 
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
        newApp.genesis__Account__c =acc.id;
        //newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = 'Loan Sanctioned Non-STP';
        newApp.Branch_City__c = '1858';
        newApp.branch_Code__c = '1858';
        newApp.Flags_Raised__c=true;
        newApp.Charges_Processed__c=true;
        INSERT newApp;
        Map<Id,genesis__Applications__c> oldList=new Map<Id,genesis__Applications__c>();
        oldList.put(newApp.id,newApp);
        
        genesis__Applications__c app=[select id from genesis__Applications__c where Flags_Raised__c=false];
		Attachment attachment=[select id,Name,Body from Attachment limit 1];
        system.Debug('app:-'+app+'   attachment:-'+attachment);
        app.Additional_Income_Approval__c=true;
        app.Sub_Stage__c='Terms and Conditions Accepted';
        app.RecordTypeId=RecordTypeIdApp;
        update app;
        list<genesis__Applications__c> applist=new list<genesis__Applications__c>();
        applist.add(app);
       SendEmailHandler.SendEmail(newApp.id, attachment);
       // SendEmailHandler.termsEmail(applist,oldList);
        
    }
   
    
}