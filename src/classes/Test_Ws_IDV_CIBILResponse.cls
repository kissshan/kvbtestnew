@isTest
public class Test_Ws_IDV_CIBILResponse {
    @testsetup
    public static void dataFactory(){
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc=new Account();
       acc.CIBIL_Status__pc='Complete';
        acc.FirstName = 'TestWs';
        acc.MiddleName = '_IDV_';
        acc.LastName = 'CIBILResponse';
        acc.Gender__pc = 'Male';
        acc.PersonBirthdate = system.today();
        acc.Aadhaar_Number__pc = '123343233444';
        acc.Pan_Number__c = 'EQAD2133RJ';
        acc.Verify_PAN_Number__c = 'Yes';
        acc.Is_PAN_card_available__c = true;
        acc.PersonMailingStreet='test@yahoo.com';
        acc.PersonMailingPostalCode='12345';
        acc.PersonMailingCity='SFO';
        acc.PersonEmail='test@yahoo.com';
        acc.PersonHomePhone='1234567';
        acc.PersonMobilePhone='12345678' ;
        acc.RecordTypeID=recordTypeId;
        acc.TU_Trigger_Time__c=system.now();
        //acc.= genApp.Id;
        insert acc;
        contact c=new contact(lastname='kk',accountid=acc.PersonContactId,CIBIL_Status__c='Complete'); 
        insert c;
        
                clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='HomeLoan');  
        insert product;
        
        genesis__Applications__c newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Loan_Number__c = 'TS123'; 
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
        newApp.genesis__Account__c =acc.id;
        newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = 'Disbursement Rejected';
        newApp.Branch_City__c = '1858';
        newApp.branch_Code__c = '1858';
        newApp.Flags_Raised__c=false;
        newApp.Charges_Processed__c=true;        
        INSERT newApp;
        genesis__Application_Parties__c genPar = new genesis__Application_Parties__c();
        genPar.genesis__Party_Account_Name__c = acc.Id;
        genPar.genesis__Application__c = newApp.Id;
        genPar.Active__c = true;
        INSERT genPar;
    }

    /*@isTest
    public static void getIDVCreating(){

       account acc=[select id from account];
        genesis__Applications__c newApp=[select id from genesis__Applications__c];
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IDV_CIBILResponse'; 
        req.httpMethod  = 'POST';
        req.params.put('Appid',acc.id);
        req.params.put('ApplicationId', newApp.Id);
        req.params.put('TUCall','IDV');
        req.requestBody = Blob.valueOf(Test_IDVResponseTU_HL.testParse());
        //req.requestBody = Blob.valueOf(Test_CibilTUService.methodGetIDVDetails());
        
        RestContext.request = req;
        RestContext.response = res;
        
        IDVResponse reg= new IDVResponse();
        reg.Result = false;

        Test.startTest();
        Ws_IDV_CIBILResponse.IDVCreating();
        Test.stopTest();
    }
    
    @isTest
    public static void method2(){
        
        account acc=[select id from account];
        
        RestRequest req1 = new RestRequest(); 
    	RestResponse res1 = new RestResponse();
        
        req1.requestURI = '/services/apexrest/IDV_CIBILResponse'; 
        req1.httpMethod  = 'POST';
        req1.params.put('Appid',acc.id);
        req1.params.put('TUCall','IDV1');
        req1.requestBody = Blob.valueOf(Test_CibilTUService.methodGetCibilDetails());
        
        RestContext.request = req1;
        RestContext.response = res1;
        
        Test.startTest();
        Ws_IDV_CIBILResponse.IDVCreating();
        Test.stopTest();
    }*/

    @isTest
    public static void getIDVCreating2(){ 

        
        genesis__Applications__c newApp=[select id from genesis__Applications__c];
        account acnt=[select id,CIBIL_Score__c,CIBIL_Status__pc,TU_Trigger_Time__c from account ];
       // contact c=new contact();
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IDV_CIBILResponse'; 
        req.httpMethod  = 'POST';
        req.params.put('Appid',acnt.id);
        req.params.put('ApplicationId', newApp.Id);
        req.params.put('TUCall',Constants.IDVCall);
        req.requestBody = Blob.valueOf(Test_CibilTUService.methodGetCibilDetails());
        //req.requestBody = Blob.valueOf(Test_CibilTUService.methodGetIDVDetails());
        
        RestContext.request = req;
        RestContext.response = res;
        
        IDVResponse reg= new IDVResponse();
        reg.Result = true;

        Test.startTest();
        Ws_IDV_CIBILResponse.IDVCreating();
        Test.stopTest();
    }
    /*public static void getIDVCreating3(){ 

        
        genesis__Applications__c newApp=[select id from genesis__Applications__c];
        account acnt=[select id,CIBIL_Score__c,CIBIL_Status__pc,TU_Trigger_Time__c from account ];
       // contact c=new contact();
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IDV_CIBILResponse'; 
        req.httpMethod  = 'POST';
        req.params.put('Appid',acnt.id);
        req.params.put('ApplicationId', newApp.Id);
        //req.params.put('TUCall',Constants.IDVCall);
        req.params.put('TUCall',Constants.CIBIL);
        req.requestBody = Blob.valueOf(Test_CibilTUService.methodGetCibilDetails());
        //req.requestBody = Blob.valueOf(Test_CibilTUService.methodGetIDVDetails());
        
        RestContext.request = req;
        RestContext.response = res;
        
        IDVResponse reg= new IDVResponse();
        reg.Result = true;

        Test.startTest();
        Ws_IDV_CIBILResponse.IDVCreating();
        Test.stopTest();
    }*/
   
  }