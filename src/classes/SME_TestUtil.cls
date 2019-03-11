/*
* Name    : SME_TestUtil
* Company  : ET Marlabs
* Purpose   : SME objects Test util 
* Author  : Yadagiri
* Edited by: Vignesh
* last Modified By :  
*/
public class SME_TestUtil{
    
    
       
    public static Account createAccount(String name, String Branch_Code, String CBS_CustomerId,string nameofdirector,string relationship,string bankname){
        Account  acc = new Account();
        acc.Name=name;
        acc.Branch_Code__c=Branch_Code;
        acc.CBS_Customer_ID__c=CBS_CustomerId;
        acc.Name_Of_Director_Related_To__c=nameofdirector;
        acc.Relationship__c=relationship;
        acc.Bank_name__c=bankname;
        return acc;
    } 
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
    public static Sundry_Creditors__c createSundryCreditors(Id accId, string age,Decimal amounttobepaid,string year,string nameofthetradecenter){
       Sundry_Creditors__c suncredit = new Sundry_Creditors__c();
        suncredit.Account__c=accId;
        suncredit.Age__c=age;
        suncredit.Amount_To_Be_Paid__c=amounttobepaid;
        suncredit.Fiscal_Year__c=year;
        suncredit.Name_Of_Trade_Creditors__c=nameofthetradecenter;
        return  suncredit;
        
    }
    
    public static Debtors__c createDeb(Id accid,string customername, string age,Decimal amountcollected,string fiscalyear){
        Debtors__c deb = new Debtors__c();
        deb.Account__c=accid;
        deb.Customer_Name__c=customername;
        deb.Age__c=age;
        deb.Amount_Collected__c=amountcollected;
        deb.Fiscal_Year__c=fiscalyear;
        return deb;
    }
    
    public static genesis__Applications__c createApplication(String Branch_Code,Id accID,string Applicationstage,string substage, string ApplicationUIstage){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME AdHoc').getRecordTypeId();       
       genesis__Applications__c  appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c=Branch_Code;
        appObj.genesis__Account__c = accID;
        appObj.Application_Stage__c = Applicationstage;
        appObj.Sub_Stage__c = substage;
        appObj.Application_UI_Stage__c = ApplicationUIstage;
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Active__c = true;
        appObj.Type__c = 'Final Sanction';
        return appObj;
    }
    
    // basic Application
    public static  genesis__Applications__c createApplication(){
          return  genesis.TestHelper.createApplication();
    }
    
    // For All Products
    public static genesis__Applications__c createApplication(String Branch_Code,Id accID,string Applicationstage,string substage, string ApplicationUIstage ,string RecType){
      Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(RecType).getRecordTypeId();       
       genesis__Applications__c  appObj  =  new genesis__Applications__c();
        appObj.Branch_Code__c=Branch_Code;
        appObj.genesis__Account__c = accID;
        appObj.Application_Stage__c = Applicationstage;
        appObj.Sub_Stage__c = substage;
        appObj.Application_UI_Stage__c = ApplicationUIstage;
        appObj.RecordTypeId = RecordTypeIdgenApp;
        appObj.Active__c = true;
        return appObj;
    }
    public static User createUser(string dummyusername){
        String user_id = userinfo.getUserId();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User dummyUser = new User();
        dummyUser.Alias = 'abcuser';
        dummyUser.Email='tfistandarduser@testorg.com';
        dummyUser.EmailEncodingKey='UTF-8';
        dummyUser.LastName='Testing';
        dummyUser.LanguageLocaleKey='en_US';
        dummyUser.LocaleSidKey='en_IN';
        dummyUser.ProfileId = p.Id;
        dummyUser.TimeZoneSidKey='Asia/Kolkata';
        dummyUser.UserName=dummyusername;
        return dummyUser;
    }
    public static clcommon__Party__c createParties(Id accID, Id appObjId,Id userID, Id conId){
        clcommon__Party__c  clParty  =  new clcommon__Party__c();
        clParty.genesis__Application__c=appObjId;
        clParty.clcommon__Account__c=accID;
        clParty.clcommon__Contact__c=conId;
        return clParty;
    }
    
    public static clcommon__CL_Product__c createclproduct (string productname,string productcode,String prodType){
        
        clcommon__CL_Product__c clprod = new clcommon__CL_Product__c();
        Id RecordTypeIdclProd = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clprod.clcommon__Product_Name__c=productname;
        clprod.Product_Code__c=productcode;
        clprod.Product_Type__c = prodType;
        clprod.RecordTypeId = RecordTypeIdclProd;
        return clprod;
    }
    public static Facility__c createFacility(Id appObjId,Id clProdId,string accountnumber,Decimal balanceoutstanding){
        Facility__c facil  =  new Facility__c();
        facil.Application__c=appObjId;
        facil.CL_Product__c= clProdId;   
        facil.Account_Number__c=accountnumber;
        facil.Balance_Outstandings__c=balanceoutstanding;
        facil.Recommended_Limit__c = 50000;
        return facil;
    }
    public static clcommon__Collateral__c createcollateral(Id appObjId,String clColName,String colType){
        clcommon__Collateral__c collater  =  new clcommon__Collateral__c();
        collater.genesis__Application__c=appObjId;
        collater.Active__c = true;
        collater.clcommon__Collateral_Name__c = clColName;
        collater.Collateral_Type__c = colType;
        return collater;
    }
    public static List<clcommon__Collateral__c> colDataList(Id appIdRec,String clColName,String colType){
        List<clcommon__Collateral__c> collList  =  new List<clcommon__Collateral__c>();
        	clcommon__Collateral__c collrec = new clcommon__Collateral__c();
            collrec.genesis__Application__c = appIdRec;
            collrec.Active__c = true;
            collrec.clcommon__Collateral_Name__c = clColName;
            collrec.Collateral_Type__c = colType;
            collList.add(collrec);
            return collList;
        
    }
    public static genesis__Application_Collateral__c createAppCollateral(Id accId,Id appObjId, Id facilId,Id collaterId){
        genesis__Application_Collateral__c appCollat  =  new genesis__Application_Collateral__c();
        appCollat.Application__c=appObjId;
        appCollat.Account__c= accId;
        appCollat.genesis__Collateral__c=collaterId;
        appCollat.Facility__c=facilId;
        return appCollat;
    } 
    
        public static Debtors__c createDebtors(Id accId,string name, string age){
        Debtors__c dbtr  =  new Debtors__c();
        dbtr.Account__c=accId;
        dbtr.Customer_Name__c=name;
        dbtr.Age__c=age;
        dbtr.Amount_Collected__c=34.76;
        dbtr.Fiscal_Year__c='2016-17';
        
        return dbtr;
    } 
    public static Operations_Detail__c createOperationDetail(Id accId, Id facilId ,string loan, string Actual, string Test_From_Account,string ToAccount, string Rental){
        Operations_Detail__c operDetail  =  new Operations_Detail__c();
        	operDetail.Account__c= accId;
       		operDetail.Facility__c=facilId;
        	operDetail.Account_Number__c='KVB12344';
            operDetail.Credit_Type__c=Loan;
            operDetail.To_Date__c=Date.newInstance(2016, 12, 9);
            operDetail.Fiscal_Type__c=Actual;
            operDetail.Fiscal_Year__c='2018-19';
            operDetail.From_Account__c	= Test_From_Account;
            operDetail.From_Date__c=Date.newInstance(2016, 12, 9);
            operDetail.To_Account__c= ToAccount;
            operDetail.Company_premises__c=Rental;
        
        return operDetail;
    } 
    public static M68_Balance_Sheet_Analysis__c createM68BalSheetAnalysis(string name,Id accId, string dataSource, string financialType,string month,string fiscalYear,Decimal netsales){
        M68_Balance_Sheet_Analysis__c m68BalSheetAnal  =  new M68_Balance_Sheet_Analysis__c();
            //m68BalSheetAnal.Name= name;
        	m68BalSheetAnal.Account__c= accId;
            m68BalSheetAnal.Data_Source__c=dataSource;
            m68BalSheetAnal.Financial_type__c=financialType;
        	m68BalSheetAnal.Month__c=month;
            m68BalSheetAnal.Fiscal_Year__c=fiscalYear;
            m68BalSheetAnal.Net_sales__c=netsales;
        return m68BalSheetAnal;
    } 
    public static Perfios__c createperfios(Id appObjId,Id accId){
        Perfios__c perfio  =  new Perfios__c();
        perfio.Applicant_Name__c= accId;
        perfio.Application__c=appObjId;
        return perfio;
    } 
    public static Ownership__c createOwnership(Id collaterId,Id accId){
        Ownership__c ownersh =  new Ownership__c();
        ownersh.Account__c= accId;
        ownersh.Collateral__c=collaterId;
        return ownersh;
    } 
    public static Survey__c creatSurvey(Id collaterId){
        Survey__c surv =  new Survey__c();
        surv.Collateral__c=collaterId;
        return surv;
    } 
    public static ints__TransUnion_Credit_Report__c creatTU(Id collaterId,Id accId, Id conId){
        ints__TransUnion_Credit_Report__c tu =  new ints__TransUnion_Credit_Report__c();
        tu.Account__c=accId;
        tu.ints__Contact__c=conId;
        tu.Borrower_Name__c='Test Borrower';
        return tu;
    } 
    public static clcommon__Collateral_Type__c createCollType(string name){
        clcommon__Collateral_Type__c  colltype=  new clcommon__Collateral_Type__c();
        colltype.name=name;
        return colltype;
    } 
    
    public static clcommon__CL_Product__c createClProd(string name, Id colltypeId,string KVB1){
        clcommon__CL_Product__c  clProd             = new clcommon__CL_Product__c();
        clProd.clcommon__Primary_Collateral_Type__c = colltypeId;
        clProd.Product_Code__c                      = KVB1;
        clProd.clcommon__Product_Name__c = name;
        return clProd;
    } 

     public static genesis__Application_Parties__c	 creategenAppParti(Id appObjId, Id accId, string Partner,string status ){
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Application__c = appObjId;
        genAppPart.Key_Contact__c = accId;
        genAppPart.genesis__Party_Type__c = Partner;
        genAppPart.Status__c = status;
        genAppPart.Signatories__c = true;
        genAppPart.Guarantor__c = true;
        return genAppPart;
    } 
    public static genesis__Application_Parties__c	 creategenAppPartiForRetail(Id appObjId, Id accId, string Partner,string status ){
        genesis__Application_Parties__c  genAppPart =  new genesis__Application_Parties__c();
        genAppPart.genesis__Application__c = appObjId;
        genAppPart.genesis__Party_Account_Name__c = accId;
        genAppPart.genesis__Party_Type__c = Partner;
        genAppPart.Status__c = status;
        genAppPart.Signatories__c = true;
        genAppPart.Guarantor__c = true;
        return genAppPart;
    } 
    
    public static Customer_Feedback__c	 creategenCustFeedback(Id appObjId, string quest,string ans ){
        Customer_Feedback__c  custfb=  new Customer_Feedback__c();
        custfb.Application__c=appObjId;
        custfb.Answer__c=ans;
        custfb.Question__c=quest;
        
        return custfb; 
    } 
    
    public static Digio_Document_ID__c	 createDgioDoc(Id appObjId, string name ){
        Digio_Document_ID__c  digDoc=  new Digio_Document_ID__c();
        digDoc.Application__c=appObjId;
        digDoc.Name=name;
        return digDoc; 
    } 
     public static Document_Applicant__c createDocAppli(Id appId, Id DocId ){
        Document_Applicant__c  digDoc=  new Document_Applicant__c();
        digDoc.Account__c=appId;
        digDoc.Digio_Document_ID__c=DocId;
        return digDoc; 
    } 
    
    public static Audit__c createAudit(Id appId,String facCategory,String termAndCon,Decimal seqNo){
        Audit__c aud = new Audit__c();
        aud.Application__c = appId;
        aud.Facility_Category__c = facCategory;
        aud.Terms_and_Conditions__c = termAndCon;
        aud.Seq_No__c = seqNo;
        return aud;
    }

    public static MCLR_Master__c createMCLRMaster(Decimal COD_Term_From,Decimal COD_Term_To,String COD_prod_type){
        MCLR_Master__c mclrMaster  = new MCLR_Master__c();
        mclrMaster.COD_Term_From__c = COD_Term_From;
        mclrMaster.COD_Term_To__c = COD_Term_To;
        mclrMaster.COD_prod_type__c = COD_prod_type;
        return mclrMaster;
    }  
    
    public static Branch_Master__c createBranchRecord(String branchName,String branchCode,String branchCat,String branchState){
        Branch_Master__c brnchMst 		= new Branch_Master__c();
        brnchMst.NAM_BRANCH__c			= branchName;   
        brnchMst.CODCCBRN__c			= branchCode;
        brnchMst.Retail_Category__c		= branchCat;
        brnchMst.State__c				= branchState;
        return brnchMst;
    }
    public static Task createtask(String taskType,String taskSubject,String taskStatus,String taskWhoId,String taskWhatId){
        
        Task taskrec 		= new Task();
        taskrec.OwnerId 	= taskWhoId;
        taskrec.Subject		= taskSubject;
        taskrec.Status 		= taskStatus;
        taskrec.Priority 	= 'Normal';
        
        return taskrec;
    } 

    public static GSTN_Info__c createGSTInfo(String RecTypeId,String GSTNum,String Status,String ParentId,String Months){
        
        GSTN_Info__c GSTRec = new GSTN_Info__c();
        GSTRec.RecordTypeId     = RecTypeId;
        GSTRec.GST_Number__c= GSTNum;
        GSTRec.Status__c     = Status;
        GSTRec.Parent__c      = ParentId; 
        GSTRec.Months__c  =  Months;    
        return GSTRec;
    }    
    public static genesis__Document_Category__c DocCateCeation(String DocCateName,String DocCateType){

        genesis__Document_Category__c docCat= new genesis__Document_Category__c();
        docCat.genesis__Category_Name__c= DocCateName;
        docCat.Document_Category__c= DocCateType;
        return docCat;

    }
    public static Credit_Facility_Detail__c createCredit(String AccNum, String CurrBal){

        Credit_Facility_Detail__c cre= new Credit_Facility_Detail__c();
        cre.Account_Number__c= AccNum;
        cre.Current_Balance__c= CurrBal;
        return cre;
    }


    public static Current_Account__c creCurrAcc(String AccId,String UniqNo){
        Current_Account__c crAcc= new Current_Account__c();
        crAcc.Account__c= AccId;
        crAcc.Unique_Number__c= UniqNo;
        return crAcc;

    } 

    public static Group_Concern__c creGrp(String AccId,String BankName){
        
        Group_Concern__c grp= new Group_Concern__c();
        grp.Group_1__c= AccId;
        grp.Bank_Name__c= BankName;
        return grp;

    }  

    public static Property__c creProp(String accId,String assType){
        
        Property__c prop= new Property__c();
        prop.Account__c= accId;
        prop.Asset_Type__c= assType;
        return prop;

    }
    
}