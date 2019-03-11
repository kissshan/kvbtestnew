//prashant singh
//date:-23/11/2018
//class:-SendSMSService
//code coverage:-80%
@isTest
public class SendSMSService_Test {
    
     @testsetup
    public static void setup()
    {
         clcommon__CL_Product__c clprod=new clcommon__CL_Product__c();
        clprod.clcommon__Product_Name__c='prashant';
        insert clprod;
        
             Account  acc = new Account();
        Id RecordTypeIdaccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();       
		acc.RecordTypeId=RecordTypeIdaccount;
        acc.Full_Name__c='gajni';
        acc.LastName='HP Agencies';
        acc.Branch_Code__c='CHENNAI';
        acc.CBS_Customer_ID__c='1210009';
        acc.Name_Of_Director_Related_To__c='Mahesh';
        acc.Relationship__c='Father in law';
        acc.Bank_name__c='KVB';  
        acc.PersonMobilePhone='7526076363';
        acc.PersonEmail='prashantsingh345@gmail.com';
        acc.Financial_Applicant__c=true;
        acc.Perfios_URL__c='www.prashant.com';
        insert acc;
        genesis__Applications__c  appObj  =  new genesis__Applications__c();
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();       

        appObj.Branch_Code__c='KB23';
        appObj.genesis__Account__c = acc.id;
        appObj.Application_Stage__c = 'Sanctioned';
        appObj.Sub_Stage__c = 'FI_Approved';
        appObj.Application_UI_Stage__c = 'COMPANY_DETAILS';
        appObj.Active__c = true;
        appObj.genesis__CL_Product__c=clprod.id;
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanction_Authority_Limit__c=1000000.00;
        appObj.Property_Verification__c=false;
        appObj.genesis__Loan_Amount__c=109399434.00;

        //appObj.genesis__Account__c=acc.id;

            insert appObj;
            
       
		 genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Application__c = appObj.id;
        genAppPart.Key_Contact__c = acc.id;
        genAppPart.genesis__Party_Type__c = 'Partner';
        genAppPart.Status__c = 'Pending';
        genAppPart.Signatories__c = true;
        genAppPart.Guarantor__c = true;
        genAppPart.genesis__Party_Account_Name__c=acc.id;
        insert genAppPart;
        Trigger_Setting__c setting=new Trigger_Setting__c();
        setting.Execute_Application_Trigger__c=true;
        insert setting;
       
        
    }
    
    //after update
 public static testmethod void Method1() {
        
        genesis__Application_Parties__c party=[select id from genesis__Application_Parties__c];
        party.Status__c='Completed';
        update party;
        genesis__Applications__c genapp=[select id,Branch_Code__c from genesis__Applications__c];
        genapp.Branch_Code__c='KB13';
		update genapp;

        
    }
    //after insert
        public static testmethod void Method2() {
             clcommon__CL_Product__c clprod=new clcommon__CL_Product__c();
        clprod.clcommon__Product_Name__c='prashant';
        insert clprod;
        
             Account  acc = new Account();
        Id RecordTypeIdaccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();       
		acc.RecordTypeId=RecordTypeIdaccount;
        acc.LastName='HP Agencies';
        acc.Branch_Code__c='CHENNAI';
        acc.CBS_Customer_ID__c='1210009';
        acc.Name_Of_Director_Related_To__c='Mahesh';
        acc.Relationship__c='Father in law';
        acc.Bank_name__c='KVB';  
        acc.PersonMobilePhone='7526076363';
        insert acc;
              genesis__Applications__c  appObj  = new genesis__Applications__c();
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();       

        appObj.Branch_Code__c='KB23';
        appObj.genesis__Account__c = acc.id;
        appObj.Application_Stage__c = 'Sanctioned';
        appObj.Sub_Stage__c = 'FI_Approved';
        appObj.Application_UI_Stage__c = 'COMPANY_DETAILS';
        appObj.Active__c = true;
        appObj.genesis__CL_Product__c=clprod.id;
        appObj.RecordTypeId = RecordTypeIdgenApp;
        //appObj.genesis__Account__c=acc.id;

            insert appObj;
        }
   // after update application
       public static testmethod void Method3() {
        
        
        genesis__Applications__c genapp=[select id,Branch_Code__c from genesis__Applications__c];
        genapp.Branch_Code__c='KB13';
           genapp.Sub_Stage__c='Loan Sanctioned Non-STP';
		update genapp;

        
    }
    public static testmethod void Method4() {
        
        
        genesis__Applications__c genapp=[select id,Branch_Code__c from genesis__Applications__c];
        genapp.Branch_Code__c='KB13';
           genapp.Sub_Stage__c='Processing Fee Paid';
		update genapp;
        

        
    }
     public static testmethod void Method5() {
        genesis__Applications__c genapp2=[select id,Branch_Code__c from genesis__Applications__c];
        genapp2.Branch_Code__c='KB13';
           genapp2.Sub_Stage__c='Disbursement Approved';
		update genapp2;

        
    }
     public static testmethod void Method6() {
        
        
        genesis__Applications__c genapp=[select id,Branch_Code__c from genesis__Applications__c];
        genapp.Branch_Code__c='KB13';
           genapp.Sub_Stage__c='MOD Initiated';
		update genapp;
        

        
    }
      public static testmethod void Method7() {
        
        
        genesis__Applications__c genapp=[select id,Branch_Code__c from genesis__Applications__c];
        genapp.Branch_Code__c='KB13';
           genapp.Sub_Stage__c='Sanction pending - Non STP';
		update genapp;
        

        
    }
      public static testmethod void Method8() {
               
          genesis__Application_Parties__c party=[select id from genesis__Application_Parties__c];
          party.genesis__Party_Type__c='Co-Borrower';
          party.Active__c=true;
          update party;
           genesis__Applications__c genapp=[select id,Branch_Code__c from genesis__Applications__c];
        genapp.Branch_Code__c='KB13';
           genapp.Sub_Stage__c='Terms and Conditions Accepted';
		update genapp;
         

        
    }
     public static testmethod void Method9() {
               
         account acc=[select id from account];
         list<id> accid=new list<id>();
         accid.add(acc.id);
         SendSMSService.perfiosSMS(accid);
         

        
    }
  /*  public static testmethod void testMethod1() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
       // System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Account[] acct = [SELECT Id from Account WHERE Name='HP Agencies'];
            System.assertEquals(1, acct.size());
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            insert genApp;
            
            genesis__Application_Parties__c genAppPart = SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'partner','Pending');
            insert genAppPart;
            
            Map<Id,genesis__Application_Parties__c> genAppPartMap = new Map<Id,genesis__Application_Parties__c>();
            genAppPartMap.put(genAppPart.Id, genAppPart);
            
            Map<Id,genesis__Applications__c> genAppOldMap = new Map<Id,genesis__Applications__c>();
            genAppOldMap.put(genApp.Id, genApp);
            
            Test.startTest();
            SendSMSService.sendSMSParties(genApp.Id);
            SendSMSService.sendSMSApp(genApp.Id);
            SendSMSService.sendSMSonCrt(genApp.Id);
            SendSMSService.termsSms(new List<genesis__Applications__c>{genApp},genAppOldMap);
            SendSMSService.Delparties(new List<genesis__Application_Parties__c>{genAppPart},genAppPartMap,genAppPartMap);
            Test.StopTest();
      //  }
    }*/
}