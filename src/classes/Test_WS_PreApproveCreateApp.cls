@isTest
public class Test_WS_PreApproveCreateApp {
    public  static void init(){
        PreApprovePL__c pp=new PreApprovePL__c();
        pp.Account_Number__c='21281';
        pp.Already_have_Pre_Approve_Loan__c=false;
        pp.Rate_Of_Interest__c=10;
        pp.Maximum_Tenure__c=30;
        pp.Maximum_Tenure__c=20;
        pp.PreApproved_Loan__c=50000;
        pp.Branch_Code__c='1857';
        pp.Rate_Of_Interest__c=13.5;
        pp.Customer_ID__c='8055609';
        pp.Adhaar_Number__c='823788898912';
        pp.AQB__c=7171;
        pp.Branch_Name__c='Bangalore';
        pp.CIBIL_Score__c=780;
        pp.Communication_Address__c='kskja';
        pp.Communication_City__c='sajh';
        pp.Communication_State__c='iusIU';
        pp.Communication_ZIPCODE__c='780000';
        pp.Customer_First_Name__c='teet';
        pp.Customer_IC__c='kss';
        pp.Customer_Last_Name__c='lasttest';
        pp.Customer_Middle_Name__c='kjask';
        pp.Date_Of_Birth__c=system.today();
        pp.Email_Address__c='aa@gmail.com';
        pp.Father_Name__c='skjksa';
        pp.Land_Line_Number__c='2872722';
        pp.Permanent_Address__c='asks';
        pp.Permanent_City__c='jsj';
        pp.Permanent_State__c='skjs';
        pp.Permanent_ZIPCODE__c='jskas';
        insert pp;
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='Digital Unsecured Personal Loan - 910';
        insert kvb;
        clcommon__CL_Product__c prod=new clcommon__CL_Product__c();
        //prod.Name='test1';
        prod.clcommon__Product_Name__c='Digital Unsecured Personal Loan - 910';
        prod.Product_Code__c='6780';
        insert prod;
    }
    @istest
    public static void method1() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName',CBS_Customer_ID__c='8055609');
        insert acc;
        init();
        
        String jsonString ='{ "CustID": "8055609","Tenure": "19","PreApprovedLoan": "25000","RateOfInterest": "13.5", "EMI": "1000"}';
        
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/preApproveCreateApp';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_PreApproveCreateApp.preApprove();
    }
    @istest
    public static void method2() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName',CBS_Customer_ID__c='8055609');
        init();
        
        String jsonString ='{ "CustID": "8055609","Tenure": "19","PreApprovedLoan": "25000","RateOfInterest": "13.5", "EMI": "1000"}';
        
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/preApproveCreateApp';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_PreApproveCreateApp.preApprove();
    }
     @istest
    public static void method3() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName',CBS_Customer_ID__c='8055609');
          PreApprovePL__c pp=new PreApprovePL__c();
        pp.Account_Number__c='21281';
        pp.Already_have_Pre_Approve_Loan__c=false;
        pp.Rate_Of_Interest__c=10;
        pp.Maximum_Tenure__c=30;
        pp.Maximum_Tenure__c=20;
        pp.PreApproved_Loan__c=50000;
        pp.Branch_Code__c='1857';
        pp.Rate_Of_Interest__c=8;
        pp.Customer_ID__c='8055609';
        pp.Adhaar_Number__c='823788898912';
        pp.AQB__c=7171;
        pp.Branch_Name__c='Bangalore';
        pp.CIBIL_Score__c=780;
        pp.Communication_Address__c='kskja';
        pp.Communication_City__c='sajh';
        pp.Communication_State__c='iusIU';
        pp.Communication_ZIPCODE__c='780000';
        pp.Customer_First_Name__c='teet';
        pp.Customer_IC__c='kss';
        pp.Customer_Last_Name__c='lasttest';
        pp.Customer_Middle_Name__c='kjask';
        pp.Date_Of_Birth__c=system.today();
        pp.Email_Address__c='aa@gmail.com';
        pp.Father_Name__c='skjksa';
        pp.Land_Line_Number__c='2872722';
        pp.Permanent_Address__c='asks';
        pp.Permanent_City__c='jsj';
        pp.Permanent_State__c='skjs';
        pp.Permanent_ZIPCODE__c='jskas';
        insert pp;
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='Digital Unsecured Personal Loan - 910';
        insert kvb;
        clcommon__CL_Product__c prod=new clcommon__CL_Product__c();
        //prod.Name='test1';
        prod.clcommon__Product_Name__c='Digital Unsecured Personal Loan - 910';
        prod.Product_Code__c='6780';
        insert prod;
        
        String jsonString ='{ "CustID": "8055609","Tenure": "19","PreApprovedLoan": "25000","RateOfInterest": "13.5", "EMI": "1000"}';
        
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/preApproveCreateApp';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_PreApproveCreateApp.preApprove();
    }
}