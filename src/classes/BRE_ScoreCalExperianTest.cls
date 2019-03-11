/**
* @author huangxy
*/
@isTest
private class BRE_ScoreCalExperianTest {

     static testMethod void test_ExpBreCal() {


        Test.startTest();
        List<Account> accountList = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account acc = new Account();
            acc.Name='tetsss'+i;
            acc.Branch_Code__c='3435'+i;
            acc.CBS_Customer_ID__c='35353'+i;
            acc.Name_Of_Director_Related_To__c='Chennai'+i;
            acc.Relationship__c='Father'+i;
            acc.Bank_name__c='KVB';
            acc.Employment_Type__c='Agriculturist'; 
            acc.Financial_Applicant__c=true;
            acc.Salary_Credited_2__c=10000;
            accountList.add(acc);
        }
        insert accountList;
        
        List<AccountHistory__c> accounthistoryList = new List<AccountHistory__c>();
        for(Integer i=0; i<5; i++){
            AccountHistory__c accounthistory = new AccountHistory__c();
            accounthistoryList.add(accounthistory);
        }
        insert accounthistoryList;
        
        List<genesis__Applications__c> applicationsList = new List<genesis__Applications__c>();
        for(Integer i=0; i<5; i++){
            genesis__Applications__c applications = new genesis__Applications__c();
            applications.genesis__Account__c = accountList[i].id;
            applicationsList.add(applications);
        }
        insert applicationsList;
        
        List<TU_Account__c> tu_accountList = new List<TU_Account__c>();
        for(Integer i=0; i<5; i++){
            TU_Account__c tu_account = new TU_Account__c();
            tu_accountList.add(tu_account);
        }
        insert tu_accountList;
        
        List<ints__TransUnion_Credit_Report__c> transunion_credit_reportList = new List<ints__TransUnion_Credit_Report__c>();
        for(Integer i=0; i<5; i++){
            ints__TransUnion_Credit_Report__c transunion_credit_report = new ints__TransUnion_Credit_Report__c();
            transunion_credit_report.Account__c = accountList[i].id;
            transunion_credit_reportList.add(transunion_credit_report);
        }
        insert transunion_credit_reportList;
        
        
        
        
		List<genesis__Applications__c> appList = null;
		Map<Id,genesis__Applications__c> oldList = null;
		BRE_ScoreCalExperian.ExpBreCal(appList,oldList);

        Test.stopTest();

    }

    static testMethod void test_BRE_ScoreCalExp() {

        Test.startTest();

		genesis__Applications__c app = null;
		BRE_ScoreCalExperian.BRE_ScoreCalExp(app,null);


        Test.stopTest();

    }

    static testMethod void test_all() {
   
        Test.startTest();

		List<genesis__Applications__c> appList = null;
		Map<Id,genesis__Applications__c> oldList = null;
		//  test ExpBreCal
		BRE_ScoreCalExperian.ExpBreCal(appList,oldList);

		genesis__Applications__c app = null;
		//  test BRE_ScoreCalExp
		BRE_ScoreCalExperian.BRE_ScoreCalExp(app,null);

        Test.stopTest();

    }


}