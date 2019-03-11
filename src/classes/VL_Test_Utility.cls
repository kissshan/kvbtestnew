/*
* Name      : VL_Test_Utility
* Company   : ET Marlabs
* Purpose   : VL Data factory for test class 
* Author    : Braj 
*/

@isTest
public class VL_Test_Utility {

    //common test setup
    public static List<genesis__Applications__c> intialSetUp(boolean createPartyRecord,boolean createcollateralRecord){
        //Insert product
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='Digital Flexi mobile loan - 717');
        insert product;

        //Insert account
        List<Account> accLst = new List<Account>();
        Account acc1 = createAccount('Braj Mohan Prasad Sinha','2133','16782007','KVB','Person Account');
        Account acc2 = createAccount('Niladri','2133','16782008','KVB','Person Account');
        Account acc3 = createAccount('Ashok','2133','16782009','KVB','Business Account');
        accLst.add(acc1);
        accLst.add(acc2);
        accLst.add(acc3);
        Insert accLst;

        //Insert application
        List<genesis__Applications__c> appLst = new List<genesis__Applications__c>();
        genesis__Applications__c app1 = createApplication('1857',accLst[0].Id,'Vehicle Details Captured','VL2W');
        genesis__Applications__c app2 = createApplication('1857',accLst[0].Id,'Vehicle Details Captured','VL4W');
        appLst.add(app1);
        appLst.add(app2);
        Insert appLst;

        if (createPartyRecord) {
            //insert applicant party for application1
            List<genesis__Application_Parties__c> partyLst = new List<genesis__Application_Parties__c>();
            genesis__Application_Parties__c  primaryParty1  = createAppParty(accLst[0].Id,appLst[0].Id,Constants.PRIMARY_APP);
            genesis__Application_Parties__c  coParty1  = createAppParty(accLst[1].Id,appLst[0].Id,Constants.Co_Borrower);
            partyLst.add(primaryParty1);
            partyLst.add(coParty1);

            //insert applicant party for application2
            genesis__Application_Parties__c  primaryParty2  = createAppParty(accLst[0].Id,appLst[1].Id,Constants.PRIMARY_APP);
            genesis__Application_Parties__c  coParty2  = createAppParty(accLst[1].Id,appLst[1].Id,Constants.Co_Borrower);
            partyLst.add(primaryParty2);
            partyLst.add(coParty2);
            Insert partyLst;
        }
        
        if (createcollateralRecord) {
            //insert collateral record
            List<clcommon__Collateral__c> collLst = new List<clcommon__Collateral__c>();
            clcommon__Collateral__c coll1 = createcollateral(appLst[0].Id,WS_UpdatemandatoryFieldsAcc.getRandomExternalIdForCollateral());
            clcommon__Collateral__c coll2 = createcollateral(appLst[1].Id,WS_UpdatemandatoryFieldsAcc.getRandomExternalIdForCollateral());
            collLst.add(coll1);
            collLst.add(coll2);
            insert collLst;
        }
        return appLst;
    }

    
    /// initial setup for other product
     //common test setup
    public static List<genesis__Applications__c> intialSetUpOther(boolean createPartyRecord,boolean createcollateralRecord, string recordName){
        //Insert product
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='Digital Flexi mobile loan - 717');
        insert product;

        //Insert account
        List<Account> accLst = new List<Account>();
        Account acc1 = createAccount('Braj Mohan Prasad Sinha','2133','16782007','KVB','Person Account');
        Account acc2 = createAccount('Niladri','2133','16782008','KVB','Person Account');
        Account acc3 = createAccount('Ashok','2133','16782009','KVB','Business Account');
        accLst.add(acc1);
        accLst.add(acc2);
        accLst.add(acc3);
        Insert accLst;

        //Insert application
        List<genesis__Applications__c> appLst = new List<genesis__Applications__c>();
        genesis__Applications__c app1 = createApplication('1857',accLst[0].Id,'Application Created',recordName);
       // genesis__Applications__c app2 = createApplication('1857',accLst[0].Id,'Vehicle Details Captured','VL4W');
        appLst.add(app1);
      //  appLst.add(app2);
        Insert appLst;

        if (createPartyRecord) {
            //insert applicant party for application1
            List<genesis__Application_Parties__c> partyLst = new List<genesis__Application_Parties__c>();
            genesis__Application_Parties__c  primaryParty1  = createAppParty(accLst[0].Id,appLst[0].Id,Constants.PRIMARY_APP);
        //    genesis__Application_Parties__c  coParty1  = createAppParty(accLst[1].Id,appLst[0].Id,Constants.Co_Borrower);
            partyLst.add(primaryParty1);
        //    partyLst.add(coParty1);

            //insert applicant party for application2
            genesis__Application_Parties__c  primaryParty2  = createAppParty(accLst[0].Id,appLst[0].Id,Constants.PRIMARY_APP);
         //   genesis__Application_Parties__c  coParty2  = createAppParty(accLst[1].Id,appLst[1].Id,Constants.Co_Borrower);
            partyLst.add(primaryParty2);
      //      partyLst.add(coParty2);
            Insert partyLst;
        }
        
        if (createcollateralRecord) {
            //insert collateral record
            List<clcommon__Collateral__c> collLst = new List<clcommon__Collateral__c>();
            clcommon__Collateral__c coll1 = createcollateral(appLst[0].Id,WS_UpdatemandatoryFieldsAcc.getRandomExternalIdForCollateral());
         //   clcommon__Collateral__c coll2 = createcollateral(appLst[1].Id,WS_UpdatemandatoryFieldsAcc.getRandomExternalIdForCollateral());
            collLst.add(coll1);
        //    collLst.add(coll2);
            insert collLst;
        }
        return appLst;
    }

    //create product
    public static clcommon__CL_Product__c createProduct(String productName){
    clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c=productName,Max_Amount__c=20000);
    return product;
    }
    
    //create Customer/Account
    public static Account createAccount(String name, String Branch_Code, String CBS_CustomerId,string bankname,String recType){
         String accRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get(recType).getRecordTypeId();
        Account  acc = new Account();
        //acc.LastName=name;
        acc.Branch_Code__c=Branch_Code;//2133
        acc.CBS_Customer_ID__c=CBS_CustomerId;//16782007
        acc.Relationship__c='';//''
        acc.Bank_name__c=bankname;//''
        acc.RecordTypeId = accRecordTypeId;
        acc.Customer_ID_Creation_Date__c=System.today();
        if (recType=='Person Account') {
            acc.LastName=name;
            acc.PersonBirthdate = Date.today().addYears(-30);
            acc.PersonEmail = 'testok@mailinator.com';
            acc.PersonMobilePhone = '3454545447';
            //acc.Aadhaar_Number__pc = '1233456777755';
        } else {
            acc.Name=name;
        }
        return acc;
    } 

    //create account parent
    public static Account createparentAccount(string FirstName, string LastName,string PersonMailingStreet,string PersonMailingPostalCode,string PersonMailingCity,string PersonEmail,string PersonHomePhone,string PersonMobilePhone,string NameOfDirectoRelatedTo,string Relationship,string Bankname){
        Account acct = new Account();
        acct.FirstName=FirstName;
        acct.LastName=LastName;
        acct.PersonMailingStreet=PersonMailingStreet;
        acct.PersonMailingPostalCode=PersonMailingPostalCode;
        acct.PersonMailingCity=PersonMailingCity;
        acct.PersonEmail= PersonEmail;
        acct.PersonHomePhone=PersonHomePhone;
        acct.PersonMobilePhone=PersonMobilePhone;
        acct.Name_Of_Director_Related_To__c=NameOfDirectoRelatedTo;
        acct.Relationship__c=Relationship;
        acct.Bank_name__c= Bankname;
        return acct;
    } 
    
    //create contact
    public static Contact createContact(String name, Id accID,string passportnumner,string gender,string nationality, string fathersname,string martialstatus ){
        Contact  con = new Contact();
        con.Accountid=accID;
        con.LastName=name;
        con.Passport_Number__c=passportnumner;
        con.Gender__c=gender;
        con.Nationality__c=nationality;
        con.Father_Name__c=fathersname;
        con.Marital_Status__c=martialstatus;
        return con;
    } 

    //create application
    public static genesis__Applications__c createApplication(String Branch_Code,String accID,string substage, String recType){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(recType).getRecordTypeId();       
       genesis__Applications__c  appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c=Branch_Code;//'1857'
        appObj.genesis__Account__c = accID;
        //appObj.Application_Stage__c = Applicationstage;
        appObj.Sub_Stage__c = substage;
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Sanctioned_Tenure__c = 36;
        appObj.Sanctioned_EMI__c = 2400;
        appObj.genesis__Interest_Rate__c = 12;
        appObj.genesis__Loan_Amount__c=100000;
        appObj.genesis__Payment_Amount__c=7000;
        appObj.Sanction_Date__c  = Date.today().addDays(-4);
        appObj.genesis__Disbursement_Date__c = Date.today();
        appObj.Active__c = true;
        return appObj;
    }
    
    // basic Application
    public static  genesis__Applications__c createApplication(){
          return  genesis.TestHelper.createApplication();
    }

    //create party
    public static genesis__Application_Parties__c createAppParty(String AccID,string AppID,String partyType){
        genesis__Application_Parties__c gap = new genesis__Application_Parties__c();
        gap.genesis__Application__c = AppID;
        gap.Key_Contact__c = AccID;
        gap.genesis__Party_Account_Name__c=AccID;
        gap.genesis__Party_Type__c = partyType;//primary,co-borrower
        gap.Active__c =true;
        gap.Financial_Applicant__c=true;
        gap.Existing_Emis__c=7000;
        gap.Net_Monthly_Income__c=2000;
        gap.Agriculture2__c=6000;
        gap.CIBIL_Scores__c = 800;
        gap.Employment_Types__c = 'Salaried';
        return gap;
    }

    //create collateral
    public static clcommon__Collateral__c createcollateral(Id AppID,String clColName){
        clcommon__Collateral__c collater  =  new clcommon__Collateral__c();
        collater.genesis__Application__c=AppID;
        collater.clcommon__Collateral_Name__c = clColName;//FE-00000000001202167533104
        collater.Vehicle_CalculatedValue__c = String.valueOf(238025);
        collater.Advances_Paid__c = 2000;
        collater.Active__c = true;
        collater.ExShow_Room_Price__c=70000;
        collater.Registration_cost__c=6000;
        collater.Accessories_value__c=10000;
        collater.clcommon__Insurance_Amount__c=8000;
        collater.ExshowRoomPrice_Api__c=80000;
        collater.Active__c = true;
        collater.Final_vehicle_value__c=78000;
        collater.clcommon__City__c='kanpur';
        collater.Cost_Of_Land__c=1234.32;
        collater.Cost_Of_Construction__c=2832.33;
        return collater;
    }


    public static User createUser(string dummyusername){
        //String user_id = userinfo.getUserId();
        //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User dummyUser = new User(Alias = 'abcuser', Email='testuser@mailinator.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_IN', ProfileId = UserInfo.getProfileId(),TimeZoneSidKey='Asia/Kolkata',UserName=dummyusername,IsActive=true);
        return dummyUser;
    }

    public static List<DIGIO_Templates__c> createDigioTemplate(){
        List<DIGIO_Templates__c> digioTemplateLst = new List<DIGIO_Templates__c>();
        DIGIO_Templates__c dgo  = new DIGIO_Templates__c(Name='VLSanctionLetter', Template_Unique_Id__c = 'VL_Sanction_Letter_v.3');
        digioTemplateLst.add(dgo);
        DIGIO_Templates__c dgo1 = new DIGIO_Templates__c(Name='VLPaymentAuthLetter', Template_Unique_Id__c = 'VL_PaymentAuth_v.3');
        digioTemplateLst.add(dgo1);
        DIGIO_Templates__c dgo2 = new DIGIO_Templates__c(Name='VLPaymentAcknoLetter', Template_Unique_Id__c = 'VL_PaymentAck_v.1');
        digioTemplateLst.add(dgo2);
        DIGIO_Templates__c dgo3 = new DIGIO_Templates__c(Name='VLHypothecation', Template_Unique_Id__c = 'VL_Hypothecation_v.2');
        digioTemplateLst.add(dgo3);
        DIGIO_Templates__c dgo4 = new DIGIO_Templates__c(Name='VLHypothecationLD', Template_Unique_Id__c = '5b7d04d3b7f9e1066b01a488',UID__c = 'kBtb5aQ48k4x5Vlkp8qk2eOH1bql/zEjyzgyHFGCUGw=');
        digioTemplateLst.add(dgo4);
        DIGIO_Templates__c dgo5 = new DIGIO_Templates__c(Name='A23', Template_Unique_Id__c = '5a587b5ea6317218d4db382e',UID__c = 'kBtb5aQ48k4x5Vlkp8dj2eOH1bql/zEjyzgyHFGCUGw=');
        digioTemplateLst.add(dgo5);
        DIGIO_Templates__c dgo6 = new DIGIO_Templates__c(Name='A46', Template_Unique_Id__c = '5a5f170fd2929b2448ec30a4',UID__c = 'kBtb5aQ48k4x5Vlkp8dj2eOH1bql/zEjyzgyHFGCUGw=');
        digioTemplateLst.add(dgo6);
        DIGIO_Templates__c dgo7 = new DIGIO_Templates__c(Name='B1', Template_Unique_Id__c = '5a5f3906d2929b2448ec30a5',UID__c = 'kBtb5aQ48k4x5Vlkp8dj2eOH1bql/zEjyzgyHFGCUGw=');
        digioTemplateLst.add(dgo7);
        DIGIO_Templates__c dgo8 = new DIGIO_Templates__c(Name='B17', Template_Unique_Id__c = '5a4e0bd91c32160854d5c687',UID__c = 'kBtb5aQ48k4x5Vlkp8dj2eOH1bql/zEjyzgyHFGCUGw=');
        digioTemplateLst.add(dgo8);
        DIGIO_Templates__c dgo9 = new DIGIO_Templates__c(Name='LAP_A23', Template_Unique_Id__c = '5b288a011c7c4c0e18f6c128',UID__c = 'kBtb5aQ48k4x5Vlkp8dj2eOH1bql/zEjyzgyHFGCUGw=');
        digioTemplateLst.add(dgo9);
        DIGIO_Templates__c dgo10 = new DIGIO_Templates__c(Name='LAP_A46', Template_Unique_Id__c = '5b21503ede176c2b6c76f191',UID__c = 'kBtb5aQ48k4x5Vlkp8dj2eOH1bql/zEjyzgyHFGCUGw=');
        digioTemplateLst.add(dgo10);
        DIGIO_Templates__c dgo11 = new DIGIO_Templates__c(Name='LAP_B1', Template_Unique_Id__c = '5b276323d9bfaf2fe01e292e',UID__c = 'kBtb5aQ48k4x5Vlkp8dj2eOH1bql/zEjyzgyHFGCUGw=');
        digioTemplateLst.add(dgo11);
        DIGIO_Templates__c dgo12 = new DIGIO_Templates__c(Name='PL Sanction Letter', Template_Unique_Id__c = 'PL_Sanction_Letter_v.1',UID__c = 'kBtb5aQ48k4x5Vlkp8dj2eOH1bql/zEjyzgyHFGCUGw=');
        digioTemplateLst.add(dgo12);
        DIGIO_Templates__c dgo13 = new DIGIO_Templates__c(Name='PL Loan Agreement', Template_Unique_Id__c = '5b276323d9bfaf2fe01e292e',UID__c = 'TMP180605125852883WLXQVWXCWTCTDX');
        digioTemplateLst.add(dgo13);
        DIGIO_Templates__c dgo14 = new DIGIO_Templates__c(Name='PL_Loan_Agreement_Manual', Template_Unique_Id__c = 'PL_loan_Agreement_Letter1.0',UID__c = '');
        digioTemplateLst.add(dgo14);
        DIGIO_Templates__c dgo15 = new DIGIO_Templates__c(Name='PL_Sanction_Letter_Manual', Template_Unique_Id__c = 'PL_Sanction_Letter_v.1',UID__c = '');
        digioTemplateLst.add(dgo15);
        return digioTemplateLst;
    }

    public static KVB_Company_Details__c createKVBCompanyDetails(){
        KVB_Company_Details__c kvbCompanyDetails = new KVB_Company_Details__c();
        kvbCompanyDetails.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvbCompanyDetails.GST__c = 18;
        kvbCompanyDetails.VL2W__c = 'Digital Two wheeler loan - 745';
        kvbCompanyDetails.VL4W__c = 'Digital Flexi mobile loan - 717';
        return kvbCompanyDetails;
    }

    public static List<KVB_Endpoint_URLs__c> createKVBEndpointURLs(){
        List<KVB_Endpoint_URLs__c> kvbEndpointLst = new List<KVB_Endpoint_URLs__c>();
        KVB_Endpoint_URLs__c kvbEndpoint = new KVB_Endpoint_URLs__c(name='DocGeneration',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/CreateDocTemplateVL');
        kvbEndpointLst.add(kvbEndpoint);
        KVB_Endpoint_URLs__c kvbEndpoint1 = new KVB_Endpoint_URLs__c(name='VL_RCInstaVeritasAPI',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/instaveritas/vehiclerc/details?rcnumber=');
        kvbEndpointLst.add(kvbEndpoint1);
        KVB_Endpoint_URLs__c kvbEndpoint2 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        kvbEndpointLst.add(kvbEndpoint2);
        KVB_Endpoint_URLs__c kvbEndpoint3 = new KVB_Endpoint_URLs__c(name='DocSigner',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/SignDoc');
        kvbEndpointLst.add(kvbEndpoint3);
        KVB_Endpoint_URLs__c kvbEndpoint4 = new KVB_Endpoint_URLs__c(name='CBS_CBR_DTLS_MNT_HL',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/FCR_CBR_DTLS_MNT');
        kvbEndpointLst.add(kvbEndpoint4);
        KVB_Endpoint_URLs__c kvbEndpoint5 = new KVB_Endpoint_URLs__c(name='CBS_Bulk_API',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES');
        kvbEndpointLst.add(kvbEndpoint5);
        KVB_Endpoint_URLs__c kvbEndpoint6 = new KVB_Endpoint_URLs__c(name='CBS_Loan_Creation_HL',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_LN_AC_OPEN');
        kvbEndpointLst.add(kvbEndpoint6);
        KVB_Endpoint_URLs__c kvbEndpoint7 = new KVB_Endpoint_URLs__c(name='CBS_CUST_LINKAGE',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/FCR_CUST_ACCT_LINK');
        kvbEndpointLst.add(kvbEndpoint7);
        KVB_Endpoint_URLs__c kvbEndpoint8 = new KVB_Endpoint_URLs__c(name='CBS_MIS_Update',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF');
        kvbEndpointLst.add(kvbEndpoint8);
        KVB_Endpoint_URLs__c kvbEndpoint9 = new KVB_Endpoint_URLs__c(name='CBS_CustIC_API',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/CBS_CustIC_API');
        kvbEndpointLst.add(kvbEndpoint9);
        KVB_Endpoint_URLs__c kvbEndpoint10 = new KVB_Endpoint_URLs__c(name='HOST_Disb_HL',Endpoint_URL__c='/bpmsPREPROD/rest/CueRest/invokeESBService/FCR_TL_HOST_SCH_LN521');
        kvbEndpointLst.add(kvbEndpoint10);
        KVB_Endpoint_URLs__c kvbEndpoint11 = new KVB_Endpoint_URLs__c(name='eStamp_url_test',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/estamp');
        kvbEndpointLst.add(kvbEndpoint11);
        KVB_Endpoint_URLs__c kvbEndpoint12 = new KVB_Endpoint_URLs__c(name='DigioESign',Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/DocumentUploadPdf');
        kvbEndpointLst.add(kvbEndpoint12);
        return kvbEndpointLst;
    }
    public static  Branch_Master__c getbranchmaster(String ret,String city,String cod){
          Branch_Master__c bb=new Branch_Master__c(Retail_Category__c=ret,NAMCCCITY__c=city,CODCCBRN__c=cod);
        return bb;
    }

    public static  Branch_Master__c createBranchmasterWithState(String ret,String state,String cod){
          Branch_Master__c bb=new Branch_Master__c(Retail_Category__c=ret,State__c=state.toUpperCase(),CODCCBRN__c=cod);
        return bb;
    }

    public static State_Master__c createStateMaster(String state,Boolean Legal){
        State_Master__c  stateObject  = new State_Master__c();
        stateObject.Name = state;
        stateObject.Legal_desk_state_flag__c = Legal;
        stateObject.COD_STATE__c = '17';
        return stateObject;
    }

    public static Branch_Master__c createBranchMaster(String category,String city,String branchCode){
        Branch_Master__c branchMaster = new Branch_Master__c();
        branchMaster.Retail_Category__c = category;
        branchMaster.NAMCCCITY__c = city;
        branchMaster.CODCCBRN__c = branchCode;
        branchMaster.Linked_RLPC__c = branchCode;
        branchMaster.Division_Code__c = branchCode;
        branchMaster.Active__c = true;
        return branchMaster;
    }

    public static Task createTask(String appId,String usrId,String subject,String status,Integer days){
        Task tsk = new Task();
        tsk.WhatId = appId;
        tsk.OwnerId = usrId;
        tsk.ActivityDate = System.today() + days;
        tsk.Subject = subject;
        tsk.Status = status;
        tsk.Priority = 'High';
        return tsk;
    }
        
    public static genesis__Application_Parties__c   creategenAppPartiForRetail(Id appObjId, Id accId, string Partner,string status ){
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Application__c = appObjId;
        genAppPart.genesis__Party_Account_Name__c = accId;
        genAppPart.genesis__Party_Type__c = Partner;
        genAppPart.Status__c = status;
        genAppPart.Signatories__c = true;
        genAppPart.Guarantor__c = true;
        return genAppPart;
    }
}