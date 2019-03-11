//written by prashant singh.
//current code coverage :--89%
//class name:-CBS_SI_CreateHandler
@isTest
public class Test_CBS_SI_CreateHandler 
{
    @testsetup
    public static void CBS_SI_Creation()
        
    {	
         KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb;
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'CBS_SI_API';
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_SI_CHRG_COLL';
     	insert kvb1;
     
        Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
        insert acc;
     
//        genesis__Applications__c app = Utility_Test.createApplication('1323', acc.id);
        
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='Home Loan');
        insert product;
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Loan_Amount__c = 100000;
        app.genesis__Term__c =12;
        app.genesis__Amortization_Term__c = 12;
        app.genesis__Loan_Number__c = 'TS123'; 
        app.genesis__Interest_Rate__c = 15;
        app.genesis__Payment_Frequency__c = 'Monthly';
        app.genesis__Account__c =acc.id;
        app.genesis__CL_Product__c = product.id;
        app.Sub_Stage__c = 'Loan Account opened';
        app.Branch_City__c = '1858';
        app.branch_Code__c = '1858';
        app.Flags_Raised__c=false;
        app.Charges_Processed__c=true;
        app.SI_Bank_Name__c='Karur Vysya Bank';
        
        INSERT app;
        System.debug('check data '+app);
        
        /*genesis__Applications__c app =TestUtility.intialSetUp('Home Loan',true);
        app.SI_Bank_Name__c='Karur Vysya Bank';
        update app;*/
    
        
     
    }    
    @istest
    public static void method1()
    {
      list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
               list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id from genesis__Applications__c limit 1]);
        list<id> ids=new list<id>();
        for(genesis__Applications__c genapp:app)
        {
            ids.add(genapp.id);
        }
    Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.starttest();
        CBS_SI_CreateHandler.CBS_SI_Creation(ids,UpcbsLog,null);
        test.stoptest();     
                        
        
    }
     @isTest public static void method2()
    {
            list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();

         KVB_Endpoint_URLs__c change=[select id from KVB_Endpoint_URLs__c];
        change.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_SI_CHRG_COLL1';
		update change;
      //  list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id,Record_Type_Name__c from genesis__Applications__c limit 1]);
        Account acc = Utility_Test.createAccount('TestAccount09411', '1323', '42354324');
        insert acc;
     
//        genesis__Applications__c app = Utility_Test.createApplication('1323', acc.id);
        
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='VL2W');
        insert product;
        genesis__Applications__c app = new genesis__Applications__c();
        app.genesis__Loan_Amount__c = 10000;
        app.genesis__Term__c =12;
        app.genesis__Amortization_Term__c = 12;
        app.genesis__Loan_Number__c = 'TS123'; 
        app.genesis__Interest_Rate__c = 15;
        app.genesis__Payment_Frequency__c = 'Monthly';
        app.genesis__Account__c =acc.id;
        app.genesis__CL_Product__c = product.id;
        app.Sub_Stage__c = 'Loan Account opened';
        app.Branch_City__c = '1858';
        app.branch_Code__c = '1858';
        app.Flags_Raised__c=false;
        app.Charges_Processed__c=true;
        app.SI_Bank_Name__c='Karur Vysya Bank';
        
        INSERT app;
        System.debug('check data '+app);
        list<genesis__Applications__c> applist=new list<genesis__Applications__c>();
        applist.add(app);
        
        list<id> ids=new list<id>();
        for(genesis__Applications__c genapp:applist)
        {
            ids.add(genapp.id);
        }
    Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.starttest();
        CBS_SI_CreateHandler.CBS_SI_Creation(ids,UpcbsLog,null);
        test.stoptest();     
                        
        
    }
     @isTest public static void method3()
    {
            list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();

         KVB_Endpoint_URLs__c change=[select id from KVB_Endpoint_URLs__c];
        change.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_SI_CHRG_COLL2';
		update change;
        list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id from genesis__Applications__c limit 1]);
        list<id> ids=new list<id>();
        for(genesis__Applications__c genapp:app)
        {
            ids.add(genapp.id);
        }
    Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        test.starttest();
        CBS_SI_CreateHandler.CBS_SI_Creation(ids,UpcbsLog,null);
        test.stoptest();     
        string json='';
   //      CBS_SI_CreationPL.parse(json);              
        
    }
    
    
}