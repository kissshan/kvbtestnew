/*
* Name          : WS_Vendor_TestUtil
* Company       : ET Marlabs
* Purpose       : This is utility class for all 3rd party loan onboarding test classes.
* Author        : Bhavya P
*/
public class WS_Vendor_TestUtil{

    public static void kvbCompanyDetails(){
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
        kvb.HomeLoanName__c = 'Digital Home Loan - 777';
        kvb.PL_NAME__c = 'Digital Unsecured Personal Loan - 910';
        kvb.LAP_NAME__c = 'KVB MORTGAGE TERM LOAN';
        kvb.VL4W__c = 'Digital Flexi mobile loan - 717';
        kvb.VL2W__c = 'Digital Two wheeler loan - 745';
        kvb.Third_Party_HL_Name__c = 'Co-Lending Home Loan';
        kvb.Third_Party_LAP_Name__c = 'Co-Lending LAP';
        kvb.Third_Party_PL_Name__c = 'Co-Lending Personal Loan';
        insert kvb;
    }

    public static void productDetails(){
        List<clcommon__CL_Product__c> prodList = new List<clcommon__CL_Product__c>();
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '777',clcommon__Product_Name__c = 'Digital Home Loan - 777'));
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '910',clcommon__Product_Name__c = 'Digital Unsecured Personal Loan - 910'));
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '717',clcommon__Product_Name__c = 'Digital Flexi mobile loan - 717'));
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '776',clcommon__Product_Name__c = 'KVB MORTGAGE TERM LOAN'));
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '745',clcommon__Product_Name__c = 'Digital Two wheeler loan - 745'));
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '798',clcommon__Product_Name__c = 'Co-Lending Home Loan'));
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '799',clcommon__Product_Name__c = 'Co-Lending LAP'));
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '800',clcommon__Product_Name__c = 'Co-Lending Personal Loan'));  
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '774',clcommon__Product_Name__c = 'Co-Lending Two Wheeler Loan'));  
        prodList.add(new clcommon__CL_Product__c(Product_Code__c = '775',clcommon__Product_Name__c = 'Co-Lending Four Wheeler Loan'));  
        insert prodList;
    }

    public static Account createAccount(){
        Account ac = new Account();
        ac.RecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.PERSON_ACCOUNT);
        ac.Aadhaar_Number__pc = 'TestRef123456789';
        ac.LastName = 'TestAccount';
        ac.PersonBirthdate = Date.valueOf('1990-08-09');
        insert ac;
        return ac;
    }

    public static void createBusinessAccount(){
        Account ac = new Account();
        ac.RecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.BUSINESS_ACCOUNT);
        ac.Pan_Number__c = 'ASDD123P';
        ac.Name = 'Test Account';
        insert ac;
    }

    public static genesis__Applications__c createApplication(String Rtype){
        createCustomSettingRecords();
        genesis__Applications__c app = new genesis__Applications__c();  
        app.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(RType).getRecordTypeId(); 
        if(RType == WS_Vendor_Constants.HOMELOAN){
        app.genesis__CL_Product__c = [SELECT Id FROM clcommon__CL_Product__c WHERE clcommon__Product_Name__c = 'Co-Lending Home Loan'].Id;
        }else if(RType == WS_Vendor_Constants.LAPLOAN){
        app.genesis__CL_Product__c = [SELECT Id FROM clcommon__CL_Product__c WHERE clcommon__Product_Name__c = 'Co-Lending LAP'].Id;
        }  
        else if(RType == WS_Vendor_Constants.VL4W){
        app.genesis__CL_Product__c = [SELECT Id FROM clcommon__CL_Product__c WHERE clcommon__Product_Name__c = 'Co-Lending Four Wheeler Loan'].Id;
        }else if(RType == WS_Vendor_Constants.VL2W){
        app.genesis__CL_Product__c = [SELECT Id FROM clcommon__CL_Product__c WHERE clcommon__Product_Name__c = 'Co-Lending Two Wheeler Loan'].Id;
        }  
        //app.Sub_Stage__c=WS_Vendor_Constants.SUB_STAGE_CBS_PENDING;  
          
                if(app.Type_Of_Loan__c == 'HL'|| app.Type_Of_Loan__c == 'LAP' || app.Type_Of_Loan__c == 'VL2W' || app.Type_Of_Loan__c == 'VL4W'){
                    app.Sub_Stage__c = WS_Vendor_Constants.SUB_STAGE_APP_CREATED;
                }else if(app.Type_Of_Loan__c == 'PL'){
                    app.Sub_Stage__c = WS_Vendor_Constants.SUB_STAGE_CBS_PENDING;       
                }    
                System.debug('app.genesis__CL_Product__c'+app.genesis__CL_Product__c);
                System.debug('app.Sub_Stage__c'+app.Sub_Stage__c);
       // app.Sub_Stage__c=WS_Vendor_Constants.SUB_STAGE_CBS_PENDING;      
        insert app;
        return app;
    }

    public static void createUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name =: WS_Vendor_Constants.BRANCH_MANAGER];
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'BR_MGR_MEDIUM'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name =: WS_Vendor_Constants.BRANCH_MANAGER];
        UserRole r1 = [SELECT Id FROM UserRole WHERE Name = 'RLPC Head'];
        List<User> usrList = new List<User>();

        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, Office_Code__c = '4843', Designation__c = WS_Vendor_Constants.NODAL_OFFICER , UserRoleId = r.Id,IsActive=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='standardtest456@testorg.com');

        User u1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p1.Id, Office_Code__c = '4844', Designation__c = WS_Vendor_Constants.RLPC_HEAD, UserRoleId = r1.Id,IsActive=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='standardur71@testorg.com');

        usrList.add(u);
        usrList.add(u1);

        insert usrList;       
    }

    public static void createCustomSettingRecords(){
        Trigger_Setting__c trg = new Trigger_Setting__c();
        trg.Execute_Application_Trigger__c = true;
        insert trg;

        Branch_Master__c bm = new Branch_Master__c();
        bm.CODCCBRN__c = '4843';
        bm.Linked_RLPC__c = '4844';
        bm.NAM_BRANCH__c = 'KARUR-CHENNAI';
        bm.Third_Party__c = 'CHFL';
        insert bm;
        
        MCLR_Master__c mclr = new MCLR_Master__c();
        mclr.MCLR_Of_Interest__c = 9.65;
        mclr.COD_Term_From__c = 365;
        mclr.COD_Term_To__c = 9999;
        insert mclr;

    }
}