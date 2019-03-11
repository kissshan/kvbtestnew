@isTest
public class Test_NumberToWord{
    public static list<Account> acclist = new list<Account>();
    public static list<Account> parentAcc = new list<Account>();
  
    public static genesis__Applications__c newApp;
    public static genesis__Applications__c newApp2;
   
    public static genesis__Application_Parties__c gapp;
    public static string AccountID;
   
   
    
    public static testmethod void createapplication(){   
       /* sch=TestUtility.createScheme();
       insert sch;
        newApp =  TestUtility.intialSetUp('Home Loan', false, null);
        newapp.Loan_EMI__c=null;
        newapp.genesis__Interest_Rate__c=12.2555;
        newapp.genesis__Loan_Amount__c=9000000000000000.20;
        update newapp;

        parentAcc = TestUtility.createAccounts('Dalai', 'Lama');        
        acclist = TestUtility.createAccounts('Jotin', 'Bagha');
        List <ID> appList =new List<ID>();
        appList.add(newApp.ID);
        NumberToWord testNTW = new NumberToWord ();
        NumberToWord.getApplication(appList);
*/
      }
      
     public static testmethod void createapplication2(){   
        NumberToWordConversion ntw = new NumberToWordConversion();
        ntw.getNumberTOWordConvertion(999999999999999.1234);
      }
}