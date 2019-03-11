/*
* Name          : VL_Webservices_Test
* Company       : ET Marlabs
* Purpose       : Test class for all VL webservices
* Author        : Braj 
* Created Date  : 25-Sep-2018
*/
//updated on 27-11-2018
//code  coverage:-94% for class WS_CBS_Collateral_Creation

@isTest
public class VL_Webservices_Test {

    @testSetup 
    static void setup(){
        //initial test setup
        List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);

        //Insert DIGIO Templates
        List<DIGIO_Templates__c> digioTemplateLst = VL_Test_Utility.createDigioTemplate();
        Insert digioTemplateLst;

        //Insert KVB Company Details
        KVB_Company_Details__c kvbCompanyDetails = VL_Test_Utility.createKVBCompanyDetails();
        Insert kvbCompanyDetails;

        //Insert KVB Company Details
        List<KVB_Endpoint_URLs__c> kvbEndpointLst = VL_Test_Utility.createKVBEndpointURLs();
        Insert kvbEndpointLst;

    }

    @isTest
    static void test_WS_Create_Update_Applicant(){
        genesis__Applications__c app = [Select Id,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        RestContext.request = req;
        
        //CreateApplicant
        //String jsonString = '{"AccountID":"'+app.genesis__Account__c+'","Fname":"Subas","Lname":"Mallick","Mname":"Chandra","POstreet":"ASsdil","POcity":"Chennai","POstate":"Tamil Nadu","POcountry":"India","POpostalcode":"560067","PMstreet":"kjsk","PMcity":"Bangalore","PMstate":"Karnataka","PMcountry":"India","PMpostalcode":"560078","Gender":"M","Bname":"Tenyampet","Pbirthdate":"2012-02-15","Nationality":"Indian","NationalIdentificationCode":"Passport","CustType":"ss","Occupation":"employee","MariStatus":"M","PersonEmail":"ss@ss.com","PersonMobile":"7204788607","CBScustID":"iuhijkijojoi","AdhaarNumber":"uhkjkjk","PanNumber":"iuhkkjn","FatherName":"SS","HusbName":"ss","BankAccountNumber":"78687,9798,8768","PartyType":"Co-Borrower","RelationToBorrower":"Wife","CretePrimaryAcc":false}';
        String jsonString = '{"CustType":"SR ","LoanType":"VL2W","POpostalcode":"635001","POcity":"Vaniyambadi","POcountry":"India","FullName":"Braj","RelationToBorrower":"","Fname":"Braj Mohan","AccountID":"","PMpostalcode":635001,"Sourced_by_office":"D.C - CHENNAI","Pbirthdate":"1990-01-01","CBScustID":"","Sourced_by":"DTPC","Mname":null,"Bname":"1229","Caste":"","isPanAvailabe":false,"FatherName":"ABDULLAH SAHIB T","Fe_Extras":"{\"MobileAppVersion\":\"1.0.1107.2\"}","CustIDCreatedDate":"2010-09-02","Title":"Mr","Gender":"Male","Religion":"","PanNumber":"AAAPA8464A","Lname":"DK","NationalIdentificationCode":"MOHAM10031946M","IsExistingCustomer":true,"PMcity":"Vaniyambadi","MariStatus":"Married","HusbName":null,"BranchCode":"1260","CBSaccountNumber5":"","CBSaccountNumber4":"","eduQualification":null,"Fax_no":null,"CBSaccountNumber3":"","PersonEmail":"rohit.patil@qualitykiosk.com","CBSaccountNumber2":"","Customer_IC":"MOHAM10031946M","CBSaccountNumber1":"1211172000004114","CretePrimaryAcc":true,"PMcountry":"India","isAadharAvailable":false,"PMstate":"Tamil Nadu","AdhaarNumber":"211522080588","PersonMobile":"919890662353","Occupation":"0","POstate":"Tamil Nadu","Phone":"919890662353","PMstreet":"28 ONJEE STREET MUSLIMPURE ","POstreet":"28 ONJEE STREET MUSLIMPURE "}';
        req.requestURI = '/services/apexrest/CreateApplicant';
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
        
        /*//updateMandateFields
        jsonString = '{"ApplicationID":"'+app.Id+'","Stage":"Work Information Captured","Additional_income":"TRUE","ACCTDETAILS":[{"AccountId":"'+app.genesis__Account__c+'","Employment_type":"Self Employed","EmploymentSubType":"Other","Cust_Type":"","Experience":"","Net_monthly_income":"65136","Annual_Other_Income_Recurring_Credits_IT":"0","Additional_income":"0","Source_of_income1":"","Additional_income_amount1":"0","IsFinancial":"TRUE","Gross_Income_1":"300","Capital_Gains_1":"500","Interest_income_1":"600","Dividend_income_1":"300","Tax_1":"120","Gross_Income_2":"2800","Capital_Gains_2":"600","Interest_income_2":"400","Dividend_income_2":"200","Tax_2":"100","Gross_Income_3":"2400","Capital_Gains_3":"700","Interest_income_3":"300","Dividend_income_3":"150","Tax_3":"500","Month_1_Income":"","Month_2_Income":"","Month_3_Income":"","Month_4_Income":"","Month_5_Income":"","Month_6_Income":"","Amount_Paid":"5000","MinNMI":"","Tax":"4000"}]}';
        req.requestURI = '/services/apexrest/updateMandateFields';
        req.requestBody = Blob.valueof(jsonString);
        WS_UpdatemandatoryFieldsAcc.getMandateFields();*/
        
    }

    @isTest
    static void test_WS_CBS_CBR_DTLS_HL_ForVL(){
        genesis__Applications__c app = [Select Id,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];
        
        Test.startTest();
        try{
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CBS_CBR_DTLS_HL.CBR_DTLSF(app.Id);
        Test.stopTest();
        }catch(exception e)
        {
            
        }
        
    }

    @isTest
    static void test_WS_CBS_CBR_DTLS_HL_ForPL(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];

        Id rectType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
        app.RecordTypeId = rectType;
        update app;
        try{
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CBS_CBR_DTLS_HL.CBR_DTLSF(app.Id);
        Test.stopTest();
        }catch(exception e)
        {}
        
    }

    @isTest
    static void test_WS_CBS_Collateral_Linkage_HL_ForVL(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Collateral_Linkage_HL.linkCollateral(app.id,null,null);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_Collateral_Linkage_HL_ForLAP(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];

        Id rectType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        app.RecordTypeId = rectType;
        update app;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Collateral_Linkage_HL.linkCollateral(app.id,null,null);
        Test.stopTest();
        
    }


    @isTest
    static void test_WS_CBS_Loan_Creation_HL_ForVL(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL4W' LIMIT 1];
        app.Max_CIBIL_Score__c = 800;
        update app;

        //test with Positive response
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Loan_Creation_HL');
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN/VL';
        update kvb;

        List<MCLR_Master__c> mclrmstrLst = new List<MCLR_Master__c>(); 
        for(Integer i = 0; i < 2; i++) {
            MCLR_Master__c mclrmstr=new MCLR_Master__c();
            mclrmstr.MCLR_Of_Interest__c=12.20;
            if (math.mod(i,2)==0)    
                mclrmstr.COD_Term_From__c=90;
            else 
                mclrmstr.COD_Term_From__c=365;
            mclrmstrLst.add(mclrmstr); 
        }
        Insert mclrmstrLst;
        
        Map<String,String> accMap = new Map<String,String>();
        accMap.put(app.genesis__Account__c, app.genesis__Account__c);
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Loan_Creation_HL.createLoanF(app.Id,accMap);
            WS_CBS_Loan_Creation_HL.customerLinkageF(null,app.Id,null);
            WS_CBS_Loan_Creation_HL.VariationHL(app);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_Loan_Creation_HL_ForVL1(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL4W' LIMIT 1];
        app.Max_CIBIL_Score__c = 600;
        update app;

        //test with Negative response
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_CUST_LINKAGE');
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_CUST_ACCT_LINK/VL';
        update kvb;

        List<MCLR_Master__c> mclrmstrLst = new List<MCLR_Master__c>(); 
        for(Integer i = 0; i < 2; i++) {
            MCLR_Master__c mclrmstr=new MCLR_Master__c();
            mclrmstr.MCLR_Of_Interest__c=12.20;
            if (math.mod(i,2)==0)    
                mclrmstr.COD_Term_From__c=90;
            else 
                mclrmstr.COD_Term_From__c=365;
            mclrmstrLst.add(mclrmstr); 
        }
        Insert mclrmstrLst;

        Map<String,String> accMap = new Map<String,String>();
        accMap.put(app.genesis__Account__c, app.genesis__Account__c);
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Loan_Creation_HL.createLoanF(app.Id,accMap);
            WS_CBS_Loan_Creation_HL.customerLinkageF(null,app.Id,null);
            WS_CBS_Loan_Creation_HL.VariationHL(app);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_Loan_Creation_HL_ForVL2(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL4W' LIMIT 1];
        
        //test with statuscode=500
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Loan_Creation_HL');
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN/VL1';
        update kvb;
        
        Map<String,String> accMap = new Map<String,String>();
        accMap.put(app.genesis__Account__c, app.genesis__Account__c);
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Loan_Creation_HL.createLoanF(app.Id,accMap);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_Loan_Creation_HL_ForVL3(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL4W' LIMIT 1];
        
        //test with statuscode=500
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_CUST_LINKAGE');
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_CUST_ACCT_LINK1';
        update kvb;

        Map<String,String> accMap = new Map<String,String>();
        accMap.put(app.genesis__Account__c, app.genesis__Account__c);
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Loan_Creation_HL.createLoanF(app.Id,accMap);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_MIS_Update_HL_ForVL(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        //Positive test
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_MIS_Update_HL.Mis_UpdateNEW(app.Id,'123456789',UpcbsLog);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_MIS_Update_HL_ForVL1(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];

        //Negative test
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_MIS_Update');
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF/VL';
        update kvb;
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
            WS_CBS_MIS_Update_HL.Mis_UpdateNEW(app.Id,'123456789',UpcbsLog);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_MIS_Update_HL_ForVL2(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];

        //test with statuscode=500
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_MIS_Update');
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF/VL1';
        update kvb;
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_MIS_Update_HL.Mis_Update(app.Id,UpcbsLog);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_Collateral_Creation_ForVL(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];

        Map<String,String> accMap = new Map<String,String>();
        accMap.put(app.genesis__Account__c, app.genesis__Account__c);
list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Collateral_Creation.Collateral_Creation(app.Id,accMap,'123456789',UpcbsLog);
        Test.stopTest();
    }

    @isTest
    static void test_WS_CBS_Collateral_Creation_ForVL1(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];

        Id rectType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        app.RecordTypeId = rectType;
        update app;

        Map<String,String> accMap = new Map<String,String>();
        accMap.put(app.genesis__Account__c, app.genesis__Account__c);
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Collateral_Creation.Collateral_Creation(app.Id,accMap,'123456789',UpcbsLog);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_Collateral_Creation_ForVL2(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];

        //test with statuscode=500
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Bulk_API');
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF/VL';
        update kvb;

        Map<String,String> accMap = new Map<String,String>();
        accMap.put(app.genesis__Account__c, app.genesis__Account__c);
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Collateral_Creation.Collateral_Creation(app.Id,accMap,'123456789',UpcbsLog);
        Test.stopTest();
        
    }

    @isTest
    static void test_WS_CBS_Collateral_Creation_ForVL3(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' LIMIT 1];

        //test with statuscode=500
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Bulk_API');
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF/VL1';
        update kvb;

        Map<String,String> accMap = new Map<String,String>();
        accMap.put(app.genesis__Account__c, app.genesis__Account__c);
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Collateral_Creation.Collateral_Creation(app.Id,accMap,'123456789',UpcbsLog);
        Test.stopTest();
        
    }
    
    @isTest
    static void test_WS_CBS_Loan_Creation_HL_ForVL_method(){
        genesis__Applications__c app = [Select Id,RecordTypeId,genesis__Account__c,Max_CIBIL_Score__c from genesis__Applications__c where Record_Type_Name__c = 'VL4W' LIMIT 1];
        app.Max_CIBIL_Score__c = 800;
        update app;

        //test with Positive response
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Loan_Creation_HL');
        kvb.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN/VL';
        update kvb;

        List<MCLR_Master__c> mclrmstrLst = new List<MCLR_Master__c>(); 
        for(Integer i = 0; i < 2; i++) {
            MCLR_Master__c mclrmstr=new MCLR_Master__c();
            mclrmstr.MCLR_Of_Interest__c=12.20;
            if (math.mod(i,2)==0)    
                mclrmstr.COD_Term_From__c=90;
            else 
                mclrmstr.COD_Term_From__c=365;
            mclrmstrLst.add(mclrmstr); 
        }
        Insert mclrmstrLst;
        
        Map<String,String> accMap = new Map<String,String>();
        accMap.put(app.genesis__Account__c, app.genesis__Account__c);
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            WS_CBS_Loan_Creation_HL.createLoanF(app.Id,accMap);
            WS_CBS_Loan_Creation_HL.customerLinkageF(null,app.Id,null);
            WS_CBS_Loan_Creation_HL.VariationHL(app);
        Test.stopTest();
        
    }

}