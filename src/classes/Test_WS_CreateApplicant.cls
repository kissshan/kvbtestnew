//written by prashant singh
//date:-28/09/2018
//percentage:---88%
//class name--WS_CreateApplicant
@isTest
public class Test_WS_CreateApplicant {
    //exception condition!!!!!!
   @istest
    public static void method1() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
    @istest
    public static void method02() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan","AppSubType":"Top Up", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"PL", "Sourced_by":"jj", "Sourced_by_office":"kk"}';
                RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
    @istest
    public static void method002() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan","AppSubType":"Take Over", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"PL", "Sourced_by":"jj", "Sourced_by_office":"kk"}';
                RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
    @istest
    public static void method2() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan","AppSubType":"Top Up", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"PL", "Sourced_by":"jj", "Sourced_by_office":"kk",'+
                            +'"BranchCode":"002", "BranchName":"psit", "HL_Facility": [{"Existing_HL_Loan_Account_No": "1234567890","Existing_HL_Sanctioned_Amount": "200000","Existing_HL_Disbursed_Amount": "200000","Existing_HL_Oustanding_Balance":"12345671","Existing_HL_SMA_Status":"True","Existing_HL_Party1_Name":"Dipen","Existing_HL_Party1_Type":"Co-Borrower","Existing_HL_Party1_CustID":"12345","Existing_HL_Party2_Name":"Ishani","Existing_HL_Party2_Type":"Guarantor","Existing_HL_Party2_CustID":"56789","Existing_HL_Party3_Name":"Mansoor","Existing_HL_Party3_Type":"Guarantor","Existing_HL_Party3_CustID":"12347","Existing_HL_Party4_Name":"Test User","Existing_HL_Party4_Type":"Co-Borrower","Existing_HL_Party4_CustID":"23875","Existing_HL_Party5_Name":"Test1","Existing_HL_Party5_Type":"Guarantor","Existing_HL_Party5_CustID":"980764","Existing_HL_Party6_Name":"Test2","Existing_HL_Party6_Type":"Primary applicant","Existing_HL_Party6_CustID":"209513"}] }';
                RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
    //CretePrimaryAcc:false
    @istest
    public static void method3() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
        system.debug('accountid:--'+appid.id);
         String jsonString ='{ "AccountID":"'+appid.id+'"'+
             ', "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :false, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"PL", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
               
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
       @istest
    public static void method4() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
        system.debug('accountid:--'+appid.id);
         String jsonString ='{ "AccountID":"'+appid.id+'"'+
             ', "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :null, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"PL", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
               
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
           @istest
        public static void method5() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
        system.debug('accountid:--'+appid.id);
         String jsonString ='{ "AccountID":"'+appid.id+'"'+
             ', "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "2000-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"PL", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
               
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
       @istest
        public static void method6() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
        system.debug('accountid:--'+appid.id);
         String jsonString ='{ "AccountID":"'+appid.id+'"'+
             ', "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "2005-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"VL2W", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
               
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
        @istest
        public static void method7() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
        system.debug('accountid:--'+appid.id);
         String jsonString ='{ "AccountID":"'+appid.id+'"'+
             ', "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "2005-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :false, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"VL2W", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
               
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
      @istest
        public static void method8() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        genesis__Applications__c appid=[select id from genesis__Applications__c limit 1];
        system.debug('accountid:--'+appid.id);
         String jsonString ='{ "AccountID":"'+appid.id+'"'+
             ', "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1900-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :false, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"VL2W", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
               
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
   
    @istest
    public static void method9() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":null, "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :false, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"PL", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
                RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    @istest
    public static void method10() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"VL2W", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
                RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
       @istest
    public static void method11() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"VL4W", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
                RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
      @istest
    public static void method12() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "j Raj", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false, "LoanType" :"LAP", "Sourced_by":"jj", "Sourced_by_office":"kk", "BranchCode":"002", "BranchName":"psit" }';
                RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
        @istest
    public static void method13() {
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.PL_NAME__c='HomeLoan';
        insert kvb;
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         //String jsonString ='';
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = null;
        WS_CreateApplicant.AccCreating();
    }
    
    @istest
    public static void method14() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : null, "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : "M", "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
       @istest
    public static void method15() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "pras", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : null, "Bname" : "Tenyampet", "Pbirthdate" : "1991-02-15", "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
         @istest
    public static void method16() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "pras", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : null, "Bname" : "Tenyampet", "Pbirthdate" : null, "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : "6100424254", "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
       @istest
    public static void method17() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "pras", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : null, "Bname" : "Tenyampet", "Pbirthdate" : null, "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : null, "PanNumber" : "BGFPS7134H", "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
      @istest
    public static void method18() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "pras", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : null, "Bname" : "Tenyampet", "Pbirthdate" : null, "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : "124786069", "CBScustID" : "12345", "AdhaarNumber" : null, "PanNumber" : null, "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
       @istest
    public static void method19() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "pras", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : "kjsk", "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : null, "Bname" : "Tenyampet", "Pbirthdate" : null, "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : null, "CBScustID" : "12345", "AdhaarNumber" : null, "PanNumber" : null, "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
    
       @istest
    public static void method20() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "pras", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : null, "PMcity" : "Banglore", "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : null, "Bname" : "Tenyampet", "Pbirthdate" : null, "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : null, "CBScustID" : "12345", "AdhaarNumber" : null, "PanNumber" : null, "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
     @istest
    public static void method21() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "pras", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : null, "PMcity" : null, "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : "560078", "Gender" : null, "Bname" : "Tenyampet", "Pbirthdate" : null, "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : null, "CBScustID" : "12345", "AdhaarNumber" : null, "PanNumber" : null, "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
     @istest
    public static void method22() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "pras", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : null, "PMcity" : null, "PMstate" : "Karnataka", "PMcountry" : "India", "PMpostalcode" : null, "Gender" : null, "Bname" : "Tenyampet", "Pbirthdate" : null, "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : null, "CBScustID" : "12345", "AdhaarNumber" : null, "PanNumber" : null, "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
     @istest
    public static void method23() {
        genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
        Account acc = new Account(Name = 'TestName');
        insert acc;
         String jsonString ='{ "AccountID":"a4V5D0000001L3NUAU", "Fname" : "pras", "Lname" : "Raja", "Mname" : "Mulakan", "POstreet" : "ASsdil", "POcity" : "Chennai", "POstate" : "Tamil Nadu", "POcountry" : "India", "POpostalcode" : "560067", "PMstreet" : null, "PMcity" : null, "PMstate" : null, "PMcountry" : "India", "PMpostalcode" : null, "Gender" : null, "Bname" : "Tenyampet", "Pbirthdate" : null, "Nationality" : "Indian", "NationalIdentificationCode" : "Passport", "CustType" : "ss", "Occupation" : "employee", "MariStatus" : "M", "PersonEmail" : "ss@ss.com", "PersonMobile" : null, "CBScustID" : "12345", "AdhaarNumber" : null, "PanNumber" : null, "FatherName" : "SS", "HusbName" : "ss", "BankAccountNumber" : "7868797988768", "PartyType":"Co-Borrower", "RelationToBorrower":"Wife", "CretePrimaryAcc" :true, "Customer_IC" :"ABC", "Phone" :"123456789", "Fax_no" :"124232344", "Title" :"MR", "Caste" :"ABC", "Religion" :"XYZ", "IsExistingCustomer" :true, "CustIDCreatedDate" :"2000-02-15", "isAadharAvailable": false, "isPanAvailabe": false }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/CreateApplicant';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        WS_CreateApplicant.AccCreating();
    }
  
  
}