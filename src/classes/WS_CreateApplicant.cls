/*
* Name    : WS_CreateApplicant 
* Company : ET Marlabs
* Purpose : This class is used to Create applicant from App
* Author  : Venugopal N
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
V1.1    23-Aug-2018    Braj          Addition and modification in age validation for Vehicle loan
V1.2    28-Sep-2018    Venu          Adhare removing code and Applciation service Changes
v1.3    15-Oct-2018    Braj          Assign Home Loan if get producttype=null/blank 
*******************************************************************************************/
@RestResource(urlMapping='/CreateApplicant')

global  class WS_CreateApplicant {
    
    global class Response extends WS_Response{
        public Account ApplicantDetails;
        public genesis__Applications__c ApplicationDetails;
        // public string errorCode;
        public genesis__Application_Parties__c PartyDetails; 
        CibilRequestTU_HL IdvRequest;
        public string TUCall;
        public boolean DOCStructure;
    }
    
    public class applicantRequest{
        public Co_applicant applicants;
        
        
        public applicantRequest(){
            applicants =new Co_applicant();
        }
        
    }
    
    public class Co_applicant{
        public string ApplicantionID;
        public string AccountID;
        public string Fname;
        public string Lname;
        public string Mname;
        public string POstreet;
        public string POcity;
        public string POstate;
        public string POcountry;  
        public string POpostalcode;
        public string PMstreet;   
        public string PMcity;
        public string PMstate;
        public string PMcountry;  
        public string PMpostalcode;
        public string Gender;
        public string Bname;   
        public Date Pbirthdate;
        public string Nationality;
        public string NationalIdentificationCode;
        public string CustType;
        public string MariStatus;
        public string Occupation;
        public string PersonEmail;
        public string PersonMobile;
        public string CBScustID;
        public string AdhaarNumber;
        public string PanNumber;
        public string FatherName;
        public string HusbName;
        public string CBSaccountNumber1;
        public String RelationToBorrower;
        public string PartyType;
        public boolean CretePrimaryAcc;
        public string Customer_IC;
        public string Phone;
        public string Fax_no;
        public string Title;
        public string Caste; 
        public string Religion; 
        public boolean IsExistingCustomer;
        public string CustIDCreatedDate;    
        public string CBSaccountNumber2;
        public string CBSaccountNumber3;
        public string CBSaccountNumber4;
        public string CBSaccountNumber5;
        public string FullName;
        public boolean isAadharAvailable;
        public boolean isPanAvailabe;
        public String Sourced_by;
        public String Sourced_by_office;
        public String BranchCode;
        public String BranchName;
        public String LoanType; //Pass type of Loan //(Null for HL)
        public string iskyc;  // V1.2 added by venu
        public string AppSubType;
        public cls_Facilitys[] HL_Facility;
    }

    public class cls_Facilitys {
        public string Existing_HL_Loan_Account_No;
        public string Existing_HL_Sanctioned_Amount;
        public string Existing_HL_Disbursed_Amount;
        public string Existing_HL_Oustanding_Balance;
        public string Existing_HL_SMA_Status;
        public string Existing_HL_1st_EMI_Date;
        public string Existing_HL_Party1_Name;
        public string Existing_HL_Party1_Type;
        public string Existing_HL_Party1_CustID;
        public string Existing_HL_Party2_Name;
        public string Existing_HL_Party2_Type;
        public string Existing_HL_Party2_CustID;
        public string Existing_HL_Party3_Name;
        public string Existing_HL_Party3_Type;
        public string Existing_HL_Party3_CustID;
        public string Existing_HL_Party4_Name;
        public string Existing_HL_Party4_Type;
        public string Existing_HL_Party4_CustID;
        public string Existing_HL_Party5_Name;
        public string Existing_HL_Party5_Type;
        public string Existing_HL_Party5_CustID;
        public string Existing_HL_Party6_Name;
        public string Existing_HL_Party6_Type;
        public string Existing_HL_Party6_CustID; 
    }
    
    
    @HttpPost
    global static Response AccCreating(){
        RestRequest req      = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        Response res         = new Response();
        
        
        if(req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }
        else{
            try{
                Decimal ApplicantAge = 0.00;
                String jsonData = req.requestBody.toString();
                System.debug('Json Data======>'+jsonData);
                List<Account> actupdt = new List<Account>();
                
                Co_applicant applicantRequestobj=(Co_applicant)Json.deserialize(jsonData, Co_applicant.class);
                system.debug('applicantRequestobj'+applicantRequestobj);
                system.debug('applicantRequestobj'+applicantRequestobj.AccountID);
                //prashant singh removed !Utility.ISStringBlankorNull(applicantRequestobj.AdhaarNumber)
                
                if(!Utility.ISStringBlankorNull(applicantRequestobj.Fname) && !Utility.ISStringBlankorNull(applicantRequestobj.Gender ) && !Utility.ISStringBlankorNull(string.valueof(applicantRequestobj.Pbirthdate))  && !Utility.ISStringBlankorNull(applicantRequestobj.PanNumber) && !Utility.ISStringBlankorNull(applicantRequestobj.PersonMobile)&& !Utility.ISStringBlankorNull(applicantRequestobj.PMcity ) && !Utility.ISStringBlankorNull(applicantRequestobj.PMstreet ) && !Utility.ISStringBlankorNull(applicantRequestobj.PMpostalcode ) && !Utility.ISStringBlankorNull(applicantRequestobj.PMstate )){
                    system.debug('applicantRequestobj'+applicantRequestobj.AccountID);
                    ApplicantService.borrowerDetail basicAcc=new ApplicantService.borrowerDetail();
                    basicAcc.Fname=applicantRequestobj.Fname;
                    basicAcc.Lname=applicantRequestobj.Lname;
                    basicAcc.Mname=applicantRequestobj.Mname;
                    basicAcc.POstreet =applicantRequestobj.POstreet;
                    basicAcc.POcity  =applicantRequestobj.POcity;
                    basicAcc.POstate =applicantRequestobj.POstate;
                    basicAcc.POcountry =applicantRequestobj.POcountry;
                    basicAcc.POpostalcode =applicantRequestobj.POpostalcode;
                    basicAcc.PMstreet =applicantRequestobj.PMstreet;
                    basicAcc.PMcity =applicantRequestobj.PMcity;
                    basicAcc.PMstate=applicantRequestobj.PMstate;
                    basicAcc.PMcountry =applicantRequestobj.PMcountry;
                    basicAcc.PMpostalcode =applicantRequestobj.PMpostalcode;
                    basicAcc.Gender =applicantRequestobj.Gender;
                    basicAcc.Bname =applicantRequestobj.Bname;
                    basicAcc.Pbirthdate =applicantRequestobj.Pbirthdate;
                    basicAcc.Nationality =applicantRequestobj.Nationality;
                    basicAcc.NationalIdentificationCode =applicantRequestobj.NationalIdentificationCode;
                    basicAcc.CustType =applicantRequestobj.CustType;
                    basicAcc.MariStatus=applicantRequestobj.MariStatus;
                    basicAcc.PersonEmail=applicantRequestobj.PersonEmail;
                    basicAcc.PersonMobile =applicantRequestobj.PersonMobile;
                    basicAcc.CBScustID =applicantRequestobj.CBScustID;
                    basicAcc.AdhaarNumber =applicantRequestobj.AdhaarNumber;
                    basicAcc.PanNumber =applicantRequestobj.PanNumber;
                    basicAcc.FatherName =applicantRequestobj.FatherName;
                    basicAcc.HusbName=applicantRequestobj.HusbName;
                    basicAcc.CBSaccountNumber1=applicantRequestobj.CBSaccountNumber1;//
                    basicAcc.Occupation = applicantRequestobj.Occupation;
                    basicAcc.CustIDCreatedDate =applicantRequestobj.CustIDCreatedDate;
                    basicAcc.Customer_IC =applicantRequestobj.Customer_IC;
                    basicAcc.Phone =applicantRequestobj.Phone;
                    basicAcc.CBSaccountNumber2 = applicantRequestobj.CBSaccountNumber2;//
                    basicAcc.CBSaccountNumber3 =applicantRequestobj.CBSaccountNumber3;//
                    basicAcc.CBSaccountNumber4 =applicantRequestobj.CBSaccountNumber4;//
                    basicAcc.CBSaccountNumber5 =applicantRequestobj.CBSaccountNumber5;//
                    basicAcc.Fax_no=applicantRequestobj.Fax_no;
                    basicAcc.Title=applicantRequestobj.Title;
                    basicAcc.Caste = applicantRequestobj.Caste; 
                    basicAcc.Religion=applicantRequestobj.Religion;
                    basicAcc.IsExistingCustomer = applicantRequestobj.IsExistingCustomer; //
                    basicAcc.FullName = applicantRequestobj.FullName;
                    basicAcc.isAadharAvailable = applicantRequestobj.isAadharAvailable; //
                    basicAcc.isPanAvailabe = applicantRequestobj.isPanAvailabe; //
                    basicAcc.iskyc = applicantRequestobj.iskyc; //V1.2
                    account acc=  ApplicantService.CreateAccount(basicAcc);
                    CibilRequestTU_HL Creq = new  CibilRequestTU_HL();
                    // Unique application flag. 2018_06_25
                    Boolean UniqFlag = False;
                    
                    if(basicAcc.Pbirthdate<>null){    
                        system.debug('Pbirthdate:--'+basicAcc.Pbirthdate+'  system.today():--'+system.today());
                        ApplicantAge = (basicAcc.Pbirthdate.daysBetween(system.today())/365.2425);
                        system.debug('applicationage:--'+ApplicantAge);
                    }
                    //V1.1//modified condition for vehicle loan
                    if(ApplicantAge <23 && applicantRequestobj.CretePrimaryAcc == true && (applicantRequestobj.LoanType != 'VL2W' && applicantRequestobj.LoanType != 'VL4W')){
                        res.status          = 'ERROR';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Primary Applicant Age should be more than 23';
                        
                        return res;
                    }
                    //V1.1//added condition for Vehicle loan
                    else if(ApplicantAge <18 && applicantRequestobj.CretePrimaryAcc == true && (applicantRequestobj.LoanType == 'VL2W' || applicantRequestobj.LoanType == 'VL4W')){
                        res.status          = 'ERROR';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Primary Applicant Age should be more than 18';
                        
                        return res;
                    }
                    else if(ApplicantAge <18 && applicantRequestobj.CretePrimaryAcc == false){
                        res.status          = 'ERROR';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Co Applicant Age should be more than 18';
                        
                        return res;
                    }
                    else if(ApplicantAge >80){
                        res.status          = 'ERROR';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Applicant age should be less than 80';
                        
                        return res;                    
                    }
                    else if(applicantRequestobj.CretePrimaryAcc == true){
                        if(!Utility.ISStringBlankorNull(applicantRequestobj.CBScustID)) {
                            actupdt = [Select id,CBS_Customer_ID__c,Aadhaar_Number__pc from Account where CBS_Customer_ID__c =:applicantRequestobj.CBScustID Limit 1];
                            system.debug('##DataLog Customer### --- > '+ actupdt);
                            
                        }
                        if(actupdt.size() <= 0){
                            if( !Utility.ISStringBlankorNull(applicantRequestobj.AdhaarNumber)){
                                actupdt = [Select id,CBS_Customer_ID__c,Aadhaar_Number__pc from Account where Aadhaar_Number__pc =:applicantRequestobj.AdhaarNumber Limit 1];
                                system.debug('##DataLog Aadhar### --- > '+ actupdt);
                            }
                        }
                         else if( !Utility.ISStringBlankorNull(applicantRequestobj.PanNumber)){
                              actupdt = [Select id,CBS_Customer_ID__c,Pan_Number__c from Account where Pan_Number__c =:applicantRequestobj.PanNumber Limit 1];
                              system.debug('##DataLog Aadhar### --- > '+ actupdt);

                        }
                        if(actupdt.size() > 0){
                            acc.id = actupdt[0].id;
                            update acc;
                        }else{
                            insert acc;  
                        }
                        
                        // Unique application start here
                        //UniqFlag = CreateUnique_App.checkuniqApp(applicantRequestobj.PanNumber);  
                        
                        account ac=[select id,name,FirstName,LastName,MiddleName,Gender__pc,PersonBirthdate,Aadhaar_Number__pc,Pan_Number__c,PersonMobilePhone,
                                    PersonMailingStreet,PersonMailingCity,PersonMailingPostalCode,PersonMailingState,Full_Name__c from account where id=:acc.id limit 1];
                        system.debug('aaaaa'+ac.name);
                        //if(!UniqFlag){
                            Creq=  WS_CibilServiceTU_HL.prepareRequest(ac,Constants.IDVCall) ;   
                        //}
                        
                        //v1.3(start)
                        String RType = '';
                        if(applicantRequestobj.LoanType == Constants.LAPLOAN){
                            RType = Constants.LAPLOAN;
                        }else if(applicantRequestobj.LoanType == 'PL'){
                            RType = Constants.PERSONALLOAN;
                        }else if(applicantRequestobj.LoanType == 'VL2W'){
                            RType = Constants.VL2W;
                        }else if(applicantRequestobj.LoanType == 'VL4W'){
                            RType = Constants.VL4W;
                        }else {
                            RType = Constants.HOMELOAN;
                        }  
                        //v1.3(end)

                        // V1.2 Start   added by venu
                        genesis__Applications__c App = ApplicationService.createApplication2(Acc.id,RType,applicantRequestobj); 
                        String PriAccType = Constants.PRIMARY_APP;
                        genesis__Application_Parties__c Party= PartyService.createPartyRep(basicAcc,acc.id,PriAccType ,applicantRequestobj.RelationToBorrower,App.Id,App.genesis__Account__c,applicantRequestobj.LoanType);
                        // V1.2 End 
                        
                        //HL MVP2(start)
                        if(applicantRequestobj.AppSubType == Constants.Sub_Type_Top_Up){
                            if(applicantRequestobj.HL_Facility!=null && applicantRequestobj.HL_Facility.size()>0){
                                List<Facility__c> FacilList= new List<Facility__c>();
                                Id FacID=Schema.getGlobalDescribe().get('Facility__c').getDescribe().getRecordTypeInfosByName().get('HL Facility').getRecordTypeId();
                                for(cls_Facilitys reqFa:applicantRequestobj.HL_Facility){
                                    Facility__c ft = new Facility__c();
                                    ft.RecordTypeId=FacID;
                                    ft.Application__c=App.id;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Loan_Account_No))
                                        ft.Existing_HL_Loan_Account_No__c=reqFa.Existing_HL_Loan_Account_No;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Sanctioned_Amount))
                                        ft.Existing_HL_Sanctioned_Amount__c=Decimal.valueOf(reqFa.Existing_HL_Sanctioned_Amount) ;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Disbursed_Amount))
                                        ft.Existing_HL_Disbursed_Amount__c=Decimal.valueOf(reqFa.Existing_HL_Disbursed_Amount);
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_SMA_Status))
                                        ft.Existing_HL_SMA_Status__c=Boolean.valueOf(reqFa.Existing_HL_SMA_Status) ;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_1st_EMI_Date))
                                        ft.Existing_HL_1st_EMI_Date__c=date.valueOf(reqFa.Existing_HL_1st_EMI_Date) ;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party1_Name))
                                        ft.Existing_HL_Party1_Name__c=reqFa.Existing_HL_Party1_Name;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party1_Type))
                                        ft.Existing_HL_Party1_Type__c=reqFa.Existing_HL_Party1_Type;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party1_CustID))
                                        ft.Existing_HL_Party1_Cust_ID__c=reqFa.Existing_HL_Party1_CustID;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party2_Name))
                                        ft.Existing_HL_Party2_Name__c=reqFa.Existing_HL_Party2_Name;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party2_Type))
                                        ft.Existing_HL_Party2_Type__c=reqFa.Existing_HL_Party2_Type;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party2_CustID))
                                        ft.Existing_HL_Party2_Cust_ID__c=reqFa.Existing_HL_Party2_CustID;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party3_Name))
                                        ft.Existing_HL_Party3_Name__c=reqFa.Existing_HL_Party3_Name;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party3_Type))
                                        ft.Existing_HL_Party3_Type__c=reqFa.Existing_HL_Party3_Type;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party3_CustID))
                                        ft.Existing_HL_Party3_Cust_ID__c=reqFa.Existing_HL_Party3_CustID;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party4_Name))
                                        ft.Existing_HL_Party4_Name__c=reqFa.Existing_HL_Party4_Name;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party4_Type))
                                        ft.Existing_HL_Party4_Type__c=reqFa.Existing_HL_Party4_Type;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party4_CustID))
                                        ft.Existing_HL_Party4_Cust_ID__c=reqFa.Existing_HL_Party4_CustID;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party5_Name))
                                        ft.Existing_HL_Party5_Name__c=reqFa.Existing_HL_Party5_Name;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party5_Type))
                                        ft.Existing_HL_Party5_Type__c=reqFa.Existing_HL_Party5_Type;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party5_CustID))
                                        ft.Existing_HL_Party5_Cust_ID__c=reqFa.Existing_HL_Party5_CustID;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party6_Name))
                                        ft.Existing_HL_Party6_Name__c=reqFa.Existing_HL_Party6_Name;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party6_Type))
                                        ft.Existing_HL_Party6_Type__c=reqFa.Existing_HL_Party6_Type;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Party6_CustID))
                                        ft.Existing_HL_Party6_Cust_ID__c=reqFa.Existing_HL_Party6_CustID;
                                    if(!Utility.ISStringBlankorNull(reqFa.Existing_HL_Oustanding_Balance))
                                        ft.Existing_HL_Oustanding_Balance__c=Decimal.valueOf(reqFa.Existing_HL_Oustanding_Balance); 
                                    
                                    FacilList.add(ft);
                                }
                                
                                if(FacilList!=null && FacilList.size()>0){
                                    Database.insert(FacilList);
                                }
                                if(applicantRequestobj.HL_Facility.size()==1){
                                    genesis__Applications__c Ap=new genesis__Applications__c();
                                    if(Boolean.valueOf(applicantRequestobj.HL_Facility[0].Existing_HL_SMA_Status)){
                                        Ap.genesis__Terms_Selected__c='SMA';
                                    }
                                    else if(system.today().addyears(-2)<date.valueOf(applicantRequestobj.HL_Facility[0].Existing_HL_1st_EMI_Date)){
                                        Ap.genesis__Terms_Selected__c='Within 2 years';
                                    }
                                    system.debug(Ap);
                                    if(!Utility.ISStringBlankorNull(Ap.genesis__Terms_Selected__c)){
                                        Ap.Sub_Stage__c =Constants.Sub_Stage_Top_Up_Ineligible;
                                        Ap.id= App.id;
                                        update Ap;
                                        res.status          = 'ERROR';
                                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                                        res.errorMessage  = Ap.genesis__Terms_Selected__c;
                                        res.ApplicationDetails=App;
                                        res.IdvRequest=null;
                                        res.TUcall=null;
                                        return res;
                                    }
                                    
                                }
                            }
                            else {
                                genesis__Applications__c Ap=new genesis__Applications__c();
                                Ap.Sub_Stage__c =Constants.Sub_Stage_Top_Up_Ineligible;
                                Ap.genesis__Terms_Selected__c='No Existing HL';
                                Ap.Id = App.id;
                                update Ap;
                                res.status          = 'ERROR';
                                res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                                res.errorMessage  = 'No Existing HL';
                                res.ApplicationDetails=App;
                                res.IdvRequest=null;
                                res.TUcall=null;
                                return res;
                            }
                        }
                        else if(applicantRequestobj.AppSubType == Constants.Sub_Type_Take_Over){
                            set<string> Doclist=new set<string>{Constants.DocrecCanc,Constants.DocOrginSale};
                                list<Document_Model__c> DList=new list<Document_Model__c>();
                                for(string s:Doclist){
                                    Document_Model__c d=new Document_Model__c();
                                    d.Document_Name__c=s;
                                    d.Application__c =App.id;
                                    DList.add(d);
                                }
                            if(DList!=null && DList.size()>0)
                                insert DList;
                        }

                        if (App.id!=null) {
                            insert new FEC__c(Application__c=App.id);
                        }
                        //HL MVP2(end)

                        /*if(UniqFlag){
genesis__Applications__c uniApp = new genesis__Applications__c();
uniApp.Id = App.id;
uniApp.Sub_Stage__c = Constants.APP_REJECTED_STAGE;
uniApp.Application_Stage__c = 'Duplicate Application';
ApplicationTriggerHandler.IsFirstRun = False;
update uniApp;
res.status        = 'ERROR';
res.statusCode    = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
res.errorMessage  = 'You have open Retail Application can not create new Application';
return res;
}*/
                        
                        genesis__Applications__c Applicatoin=[select id,name,Pre_Approved_Flag__c,Record_Type_Name__c,Sub_Type__c from genesis__Applications__c where ID=:App.id];//added Sub_Type__c
                        res.DOCStructure  = APPDocCategoryCreation.CreateDocCat(Applicatoin,ac,applicantRequestobj.CretePrimaryAcc);
                        system.debug('App Doc creation done - '+res.DOCStructure);
                        if(Party.genesis__Party_Type__c == Constants.PRIMARY_APP){
                            Party.genesis__Party_Type__c = 'Applicant';
                        }
                        res.ApplicationDetails=Applicatoin;
                        res.ApplicantDetails=acc; 
                        res.PartyDetails=Party;  
                        res.IdvRequest=Creq;
                        res.TUcall=Constants.IDVCall;
                        return res;
                    }
                    //creating co-applicant
                    else if(applicantRequestobj.AccountID != null && ((applicantRequestobj.AccountID.length() == 15 || applicantRequestobj.AccountID.length() == 18)) && applicantRequestobj.CretePrimaryAcc == false){ 
                        genesis__Applications__c App= Applicationservice.getApplication(applicantRequestobj.AccountID);
                        ValidateApp(App);        
                        Boolean dupeCheck;
                        Boolean dupeMobCheck;
                        List <Account> accountList = queryService.accList(App.Id);
                        List<String> aadharList = new List<String>();
                        List<String> mobileList = new List<String>();
                        if(accountList.size()>0){
                            for(Account a:accountList){
                                // Changes to check pan number flow. 2018/10/15
                                aadharList.add(a.Pan_Number__c);
                            }
                            dupeCheck = aadharList.contains(basicAcc.PanNumber);
                        }
                        if(accountList.size()>0){
                            for(Account a:accountList){
                                System.debug('!!!!!!:::'+a.PersonMobilePhone);
                                //string MobNumber;
                                //if(a.PersonMobilePhone!=null && (a.PersonMobilePhone).length()==12){
                                //    MobNumber = a.PersonMobilePhone;
                                //}
                                //else if(a.PersonMobilePhone!=null && (a.PersonMobilePhone).length()==10){
                                //    System.debug('!!!!^^^^:::'+a.PersonMobilePhone);
                                //     MobNumber ='91'+a.PersonMobilePhone;
                                //}
                                //System.debug('#####::::'+MobNumber);
                                mobileList.add(a.PersonMobilePhone);
                            }
                            for(String mob : mobileList){
                                if((basicAcc.PersonMobile).length() != 10){
                                    basicAcc.PersonMobile = (basicAcc.PersonMobile).right(10);
                                }
                                if(mob.length() != 10){
                                    mob = mob.right(10);
                                }
                                if(mob == basicAcc.PersonMobile){
                                    dupeMobCheck = true;
                                }
                            }
                            //  dupeMobCheck = mobileList.contains(basicAcc.PersonMobile); commented to check duplicate mobile validation
                        }
                        /* if(accountList.size()>0){
for(Account a:accountList){
mobileList.add(a.PersonMobilePhone);
} 
dupeMobCheck = mobileList.contains(basicAcc.PersonMobile);
}*/
                        if(dupeCheck ==True){
                            res.status          = 'ERROR';
                            res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                            res.errorMessage  = 'Duplicate Pan Card found for the same Application';
                            
                            return res;                        
                        }else if(dupeMobCheck == True){
                            res.status          = 'ERROR';
                            res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                            res.errorMessage  = 'Duplicate Mobile No found for the same Application';
                            
                            return res;                        
                        }
                        
                        else{                    
                            //  insert acc; 
                            if(!Utility.ISStringBlankorNull(applicantRequestobj.CBScustID)) {
                                actupdt = [Select id,CBS_Customer_ID__c,Aadhaar_Number__pc from Account where CBS_Customer_ID__c =:applicantRequestobj.CBScustID Limit 1];
                                system.debug('##DataLog Customer### --- > '+ actupdt);
                                
                            }else if( !Utility.ISStringBlankorNull(applicantRequestobj.AdhaarNumber)){
                                actupdt = [Select id,CBS_Customer_ID__c,Aadhaar_Number__pc from Account where Aadhaar_Number__pc =:applicantRequestobj.AdhaarNumber Limit 1];
                                system.debug('##DataLog Aadhar### --- > '+ actupdt);
                                
                            }
                            if(actupdt.size() > 0){
                                acc.id = actupdt[0].id;
                                update acc;
                            }else{
                                insert acc;  
                            }
                            
                            res.DOCStructure  = APPDocCategoryCreation.CreateDocCat(App,acc,applicantRequestobj.CretePrimaryAcc);
                            // Unique application start here
                            //UniqFlag = CreateUnique_App.checkuniqApp(applicantRequestobj.PanNumber); 
                            
                            account ac=[select id,name,FirstName,LastName,MiddleName,Gender__pc,PersonBirthdate,Aadhaar_Number__pc,Pan_Number__c,PersonMobilePhone,
                                        PersonMailingStreet,PersonMailingCity,PersonMailingPostalCode,PersonMailingState,Full_Name__c from account where id=:acc.id limit 1];
                            //if(!UniqFlag){
                                Creq=  WS_CibilServiceTU_HL.prepareRequest(ac,Constants.IDVCall) ;   
                            //}
                            // res.DOCStructure  = APPDocCategoryCreation.CreateDocCat(App,acc,applicantRequestobj.CretePrimaryAcc);
                            // party create for re run model
                            genesis__Application_Parties__c Party= PartyService.createPartyRep(basicAcc,acc.id, applicantRequestobj.PartyType,applicantRequestobj.RelationToBorrower,App.Id,App.genesis__Account__c,applicantRequestobj.LoanType);
                            
                            
                            /*if(UniqFlag){
if(Party.genesis__Party_Type__c == 'Co-Borrower'){
genesis__Application_Parties__c  partyDeactive = new genesis__Application_Parties__c();
partyDeactive.id = Party.id;
partyDeactive.Active__c = False;
update partyDeactive;
res.status          = 'ERROR';
res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
res.errorMessage  = 'You have open Retail Application can not create new Application';
return res;
}
}*/
                            
                            res.ApplicantDetails=acc; 
                            
                            res.PartyDetails=Party;                
                            res.ApplicationDetails= App;
                            res.IdvRequest=Creq;
                            res.TUcall='IDV';
                            return res;
                        }
                    }
                    else if(applicantRequestobj.CretePrimaryAcc == null){
                        res.status          = 'ERROR';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Please Select the Applicant type';
                        
                        return res;
                    }
                    else{
                        //  res.errorCode       = genesis.Constants.API_EXCEPTION;
                        res.status          = 'ERROR';
                        res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                        res.errorMessage  = 'Please provide Application ID';
                        
                        return res;
                        
                        
                    }
                }
                else{
                    string s='';
                    if(Utility.ISStringBlankorNull(applicantRequestobj.Fname)){
                        s=s+'Name';
                    }
                    if(Utility.ISStringBlankorNull(applicantRequestobj.Gender)){
                        if(s.length()>1){
                            s=s+',Gender ';                 }
                        else{
                            s=s+'Gender ';}}
                    if(Utility.ISStringBlankorNull(string.valueof(applicantRequestobj.Pbirthdate))){
                        if(s.length()>1){
                            s=s+', Birth Date ';
                        }
                        else{
                            s=s+'Birth Date ';}}
                    if(Utility.ISStringBlankorNull(applicantRequestobj.AdhaarNumber)){
                        if(s.length()>8){
                            s=s+', Aadhar Number ';
                        }
                        else{
                            s=s+'Aadhar Number ';}}
                    if(Utility.ISStringBlankorNull(applicantRequestobj.PanNumber)){
                        if(s.length()>8){
                            s=s+' , Pan Number ';
                        }
                        else{
                            s=s+'Pan Number ';}}
                    if(Utility.ISStringBlankorNull(applicantRequestobj.PersonMobile)){
                        if(s.length()>1){
                            s=s+' , Mobile number ';
                        }
                        else{
                            s=s+'Mobile number '; }}
                    if(Utility.ISStringBlankorNull(applicantRequestobj.PMstreet)){
                        if(s.length()>8){
                            s=s+', Street Address ';
                        }
                        else{
                            s=s+'Street Address ';}}
                    if(Utility.ISStringBlankorNull(applicantRequestobj.PMcity)){
                        if(s.length()>8){
                            s=s+' , City ';
                        }
                        else{
                            s=s+'City ';
                        }}
                    if(Utility.ISStringBlankorNull(applicantRequestobj.PMpostalcode))
                    {
                        if(s.length()>8){
                            s=s+', Postal Code ';
                        }
                        else{
                            s=s+'Postal Code ';
                        }}
                    if(Utility.ISStringBlankorNull(applicantRequestobj.PMstate)){
                        if(s.length()>8){
                            s=s+' , PMstate ';
                        }
                        else{
                            s=s+' PMstate '; 
                        }
                    }
                    s='Please Provide the '+s;
                    
                    res.status          = Constants.WS_ERROR_STATUS;
                    res.errorMessage    = s ;
                    res.statusCode      = Constants.WS_ERROR_CODE;
                    return res;            
                }
            }
            catch(exception e){
                system.debug('Exception in Creatapplicant'+e.getMessage()+' Stack '+e.getStackTraceString());
                // res.errorCode       = genesis.Constants.API_EXCEPTION;
                res.status          = 'ERROR';
                res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                res.errorMessage  = e.getMessage();
                
                return res;
            }
        }
        return res;
    }
    
    public static void ValidateApp(genesis__Applications__c app){
        if(app.id==null){
            Throw new CustomException('AppID not found For Primary Applicant ');
        }
    }
    
}