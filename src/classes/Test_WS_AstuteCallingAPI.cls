@isTest
public class Test_WS_AstuteCallingAPI {
    
    @testSetup 
	static void setup(){
		//initial test setup
		List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
        KVB1.Name = 'Apigee_Access_Token';
        KVB1.Endpoint_URL__c = 'http://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken';
        KVB1.Username__c='prashant';
        insert kvb1;
         KVB_Endpoint_URLs__c kvb2 = new KVB_Endpoint_URLs__c();
        KVB2.Name = 'AstuteRequest1';
        KVB2.Endpoint_URL__c = 'https://kvb-test.apigee.net/next/v1/astute/case';
        KVB2.Username__c='prashant';
        insert kvb2;
        
	}
    
	public static testMethod void AstuteCallingMethod1(){
        genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
        app.RecordTypeId = recttype;
        update app;
        
        genesis__applications__c genapp = [select id, Record_Type_Name__c from genesis__applications__c limit 1];
        Test.startTest();
        WS_AstuteCallingAPI.callAstute(genApp.Id, '1234322', 'Search');
        Test.stopTest();
    }
    
    public static testMethod void AstuteCallingMethod2(){
       // genesis__applications__c app = TestUtility.intialSetUp('LAP', true);
        
        Account acc=new Account(Name='testname', Financial_Applicant__c=true, Employment_Type__c='Salaried',Verify_PAN_Number__c = 'Yes',Holding_Comp_Address__c='ksdisjdimiejdie');
        acc.Net_Monthly_Income__c = 30000;
        insert acc;
        Account acct = [select id, name, Financial_Applicant__c, Employment_Type__c, Verify_PAN_Number__c, Net_Monthly_Income__c from Account limit 1];
        

        
        genesis__applications__c genApp = [select id, Record_Type_Name__c from genesis__applications__c limit 1];

        genesis__Application_Parties__c appParty=[select id,Employment_Types__c from genesis__Application_Parties__c limit 1];
        appParty.Employment_Types__c=Constants.EMPTYP_SELFEMPB;
		update appParty;
    Test.startTest();
        WS_AstuteCallingAPI.callAstute(genApp.Id, '1234322', 'Office');
        WS_AstuteCallingAPI.callAstute(genApp.Id, '1234322', 'Residence');
        Test.stopTest();
    }
     public static testMethod void AstuteCallingMethod2_1(){       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();    

        
        genesis__applications__c genApp = [select id, Record_Type_Name__c from genesis__applications__c limit 1];
         genApp.RecordTypeId=recttype;
         update genApp;
        genesis__Application_Parties__c appParty=[select id,Employment_Types__c,Key_Contact__r.RecordType.DeveloperName from genesis__Application_Parties__c limit 1];
        appParty.Employment_Types__c=Constants.EMPTYP_SELFEMPB;
		update appParty;
         system.debug('appParty:-'+appParty);
    Test.startTest();
        WS_AstuteCallingAPI.callAstute(genApp.Id, '1234322', 'Office');
        WS_AstuteCallingAPI.callAstute(genApp.Id, '1234322', 'Residence');
        Test.stopTest();
    }
    public static testMethod void AstuteCallingMethod2_2(){       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();    

        
        genesis__applications__c genApp = [select id, Record_Type_Name__c from genesis__applications__c limit 1];
         genApp.RecordTypeId=recttype;
         update genApp;
        genesis__Application_Parties__c appParty=[select id,Employment_Types__c,Key_Contact__r.RecordType.DeveloperName from genesis__Application_Parties__c limit 1];
        appParty.Employment_Types__c=Constants.EMPTYP_SELFEMPB;
		update appParty;
         system.debug('appParty:-'+appParty);
    Test.startTest();
        WS_AstuteCallingAPI.callAstute(genApp.Id, '1234322', 'Office');
        WS_AstuteCallingAPI.callAstute(genApp.Id, '1234322', 'Residence');
        Test.stopTest();
    }
        public static testMethod void AstuteCallingMethod2_3(){       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();    

        
        genesis__applications__c genApp = [select id, Record_Type_Name__c from genesis__applications__c limit 1];
         genApp.RecordTypeId=recttype;
         update genApp;
        genesis__Application_Parties__c appParty=[select id,Employment_Types__c,Key_Contact__r.RecordType.DeveloperName from genesis__Application_Parties__c limit 1];
        appParty.Employment_Types__c=Constants.EMPTYP_SELFEMPB;
		update appParty;
         system.debug('appParty:-'+appParty);
    Test.startTest();
        WS_AstuteCallingAPI.callAstute(genApp.Id, '1234322', 'Office');
        WS_AstuteCallingAPI.callAstute(genApp.Id, '1234322', 'Residence');
        Test.stopTest();
    }
    
    public static testmethod void method()
    {
        id accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc=new Account(Name='testname');
        acc.Financial_Applicant__c=true;
        acc.Employment_Type__c='Salaried';
        acc.Agriculture2__c =  2000.44;
        acc.Annual_Share_of_Profit_Firm__c = 3434.34;
        acc.Rental2__c = 2344.45;
        acc.Pension_Income2__c = 7654.98;
        acc.Others_Income2__c = 2434.34;
        acc.Income_Computation_From__c = 'Bank Statement';
        acc.Salary_Credited_1__c = 2000.34;
        acc.Salary_Credited_2__c = 1000.99;
        acc.Salary_Credited_3__c = 0;
        acc.CIBIL_Score__c = 780;
        acc.RecordTypeId=accountRecordType;
        
        insert acc;
        system.debug('account:-'+acc);
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication('1857',acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
            genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        par.Employment_Types__c=Constants.EMPTYP_SELFEMPB;
        par.FI_Exempted__c=false;
        insert par;
        list<genesis__Applications__c> appobj=new list<genesis__Applications__c>([select id,(select id,Key_Contact__r.RecordType.DeveloperName,Employment_Types__c from genesis__Application_Parties__r) from genesis__Applications__c limit 1]);
        system.debug('appobj:-'+appobj);
        for(genesis__Applications__c app:appobj)
        {
            for(genesis__Application_Parties__c party:app.genesis__Application_Parties__r)
            {
             system.debug('party:-'+party.Key_Contact__r.RecordType.DeveloperName); 
                party.Employment_Types__c=Constants.EMPTYP_SELFEMPB;
                update party;
                
            }
           
        }
        list<account> acclist=new list<account>([select id from account]);
        for(account ac:acclist)
        {
            ac.RecordTypeId=accountRecordType;
            update ac;
            system.debug('aa');
        }
        
        WS_AstuteCallingAPI.callAstute(appobj[0].Id, '1234322', '');

    }
    
    
   	public static testMethod void AstuteCallingMethod3(){
        genesis__applications__c app = TestUtility.intialSetUp('LAP', true);
        
        Account acc=new Account(Name='testname', Financial_Applicant__c=true, Employment_Type__c='Salaried',Verify_PAN_Number__c = 'Yes',Holding_Comp_Address__c='swewe');
        acc.Net_Monthly_Income__c = 30000;
        insert acc;
        Account acct = [select id, name, Financial_Applicant__c, Employment_Type__c, Verify_PAN_Number__c, Net_Monthly_Income__c from Account limit 1];
        
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        
        app.RecordTypeId = recttype;
        app.genesis__Account__c = acct.Id;
        update app;
        
        genesis__applications__c genApp = [select id, Record_Type_Name__c from genesis__applications__c limit 1];
        
        genesis__Application_Parties__c appParty = new genesis__Application_Parties__c();
        appParty.genesis__Party_Account_Name__c = acct.Id;
        appParty.genesis__Application__c = genApp.Id;
        appParty.Active__c = true;
        appParty.genesis__Party_Type__c = 'Co-Borrower';
        appParty.Employment_Types__c=Constants.EMPTYP_SELFEMPB;
        
        insert appParty;
        
        Astute_Verification__c av = new Astute_Verification__c();
        av.Case_Notification_Id__c = '12323';
        av.Application__c = genapp.Id;
        av.Account__c = acct.Id;
        av.Property_Type__c = 'Office';
        insert av;
        List<Astute_Verification__c> avList = new List<Astute_Verification__c>();
        avList.add(av);
        Test.startTest();
        	WS_AstuteCallingAPI.astuteRetry2(avList);
        Test.stopTest();
    }
    
   public static testMethod void AstuteCallingMethod3_1(){
        genesis__applications__c app = TestUtility.intialSetUp('LAP', true);
        
        Account acc=new Account(Name='testname', Financial_Applicant__c=true, Employment_Type__c='Salaried',Verify_PAN_Number__c = 'Yes',Holding_Comp_Address__c='swewe');
        acc.Net_Monthly_Income__c = 30000;
        insert acc;
        Account acct = [select id, name, Financial_Applicant__c, Employment_Type__c, Verify_PAN_Number__c, Net_Monthly_Income__c from Account limit 1];
        
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        
        app.RecordTypeId = recttype;
        app.genesis__Account__c = acct.Id;
        update app;
        
        genesis__applications__c genApp = [select id, Record_Type_Name__c from genesis__applications__c limit 1];
        
        genesis__Application_Parties__c appParty = new genesis__Application_Parties__c();
        appParty.genesis__Party_Account_Name__c = acct.Id;
        appParty.genesis__Application__c = genApp.Id;
        appParty.Active__c = true;
        appParty.genesis__Party_Type__c = 'Co-Borrower';
        appParty.Employment_Types__c=Constants.EMPTYP_SELFEMPB;
        
        insert appParty;
        
        Astute_Verification__c av = new Astute_Verification__c();
        av.Case_Notification_Id__c = '12323';
        av.Application__c = genapp.Id;
        av.Account__c = acct.Id;
        av.Property_Type__c = 'Office';
        insert av;
        List<Astute_Verification__c> avList = new List<Astute_Verification__c>();
        avList.add(av);
       id accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
       list<account> acclist=new list<account>([select id from account]);
       for(account ac:acclist)
       {
           ac.RecordTypeId=accountRecordType;
           update ac;
           system.debug('aa');
       }
       Test.startTest();
        	WS_AstuteCallingAPI.astuteRetry2(avList);
        Test.stopTest();
    } 
    public static testMethod void AstuteCallingMethod4(){
        genesis__applications__c app = TestUtility.intialSetUp('LAP', true);
        
        Account acc=new Account(Name='testname', Financial_Applicant__c=true, Employment_Type__c='Salaried',Verify_PAN_Number__c = 'Yes');
        acc.Net_Monthly_Income__c = 30000;
        insert acc;
        Account acct = [select id, name, Financial_Applicant__c, Employment_Type__c, Verify_PAN_Number__c, Net_Monthly_Income__c from Account limit 1];
        
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        
        app.RecordTypeId = recttype;
        app.genesis__Account__c = acct.Id;
        update app;
        
        genesis__applications__c genApp = [select id, Record_Type_Name__c from genesis__applications__c limit 1];
        
        genesis__Application_Parties__c appParty = new genesis__Application_Parties__c();
        appParty.genesis__Party_Account_Name__c = acct.Id;
        appParty.genesis__Application__c = genApp.Id;
        appParty.Active__c = true;
        appParty.genesis__Party_Type__c = 'Co-Borrower';
        insert appParty;
        
        Astute_Verification__c av = new Astute_Verification__c();
        av.Case_Notification_Id__c = '12323';
        av.Application__c = genapp.Id;
        av.Account__c = acct.Id;
        av.Property_Type__c = 'Residence';
        insert av;
        set<Id> appIds = new Set<Id>();
        appIds.add(genapp.Id);
        List<Astute_Verification__c> avList = new List<Astute_Verification__c>();
        avList.add(av);
        Test.startTest();
        	WS_AstuteCallingAPI.astuteRetry2(avList);
        	//WS_AstuteCallingAPI.AppFIStatus_Update(appIds);
        Test.stopTest();
    }
    
    @isTest
    static void AstuteCallingMethodVL(){
    	Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

    	genesis__Applications__c app = [select id,name,genesis__Account__c,Sub_Stage__c,Record_Type_Name__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Test.startTest();
        	//Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        	WS_AstuteCallingAPI.callAstute(app.Id, '1234322', 'Search');
        	//WS_AstuteCallingAPI.astuteRetry2(avList);
        	//WS_AstuteCallingAPI.AppFIStatus_Update(appIds);
        	WS_AstuteCallingAPI.getExpectedDate('229404');
        WS_AstuteCallingAPI.addDays(3);
        Test.stopTest();
    }
    
}