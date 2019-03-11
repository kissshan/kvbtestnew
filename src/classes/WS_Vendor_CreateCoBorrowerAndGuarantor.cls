/*
* Name    : WS_Vendor_CreateCoBorrowerAndGuarantor.
* Company : ET Marlabs.
* Purpose : This class is used to create co-borrowers' and guarantors' accounts during 3rd party loan onboarding.
* Author  : Bhavya P.
*/

@RestResource(urlMapping='/createCoApplicants')
global class WS_Vendor_CreateCoBorrowerAndGuarantor{

    public cls_APPLICATION_DETAILS App_Details;

    global class Response extends WS_Vendor_RestAPIHelper.WS_Vendor_Response{        
        public String ApplicationId;
        public List<Applicant_Response> ApplicantDetails;
        public List<WS_Vendor_AppDocCategoryCreation.Document_Response> ApplicationDocCategoryDetails;
        global Response(){
             ApplicantDetails  = new List<Applicant_Response>();
             ApplicationId = '';    
        }
    } 

    public class Applicant_Response {
        public string ApplicantId = '';
        public string Applicant_Name = '';
    }

    public class cls_APPLICATION_DETAILS {

        //Wrapper for Account and party details 
        public cls_ApplicantDetails[] ApplicantDetails; 

        //Application Id       
        public String ApplicationID;               
    }

    public class cls_ApplicantDetails {

        //Company details
        public cls_Company[] CompanyDetails;

        //Account fields
        public String FirstName;    
        public String MiddleName;   
        public String LastName; 
        public String FullName; 
        public String PAN;  
        public String AadharNumber; 
        public String CBSCustId;    
        public String Title;    
        public String Nationality;  
        public String Gender;   
        public String Caste;    
        public String BirthDate; 
        public String Maritalstatus;   
        public String FatherName;   
        public String HusbandName;  
        public String BankingWithUs;    
        public String Religion; 
        public String ExServiceMan; 
        public String PhysicallyHandicapped;
        public String VoterId;  
        public String DrivingLicId; 
        public String RationCard;   
        public String PassportNo;   
        public String PassportExpDate;  
        public String OtherId;  
        public String OtherIdNo;
        public String CurrentAddress;   
        public String CurrentCity;  
        public String CurrentState; 
        public String CurrentCountry;   
        public String CurrentZip;   
        public String PermanentAddress; 
        public String PermanentCity;    
        public String PermanentState;   
        public String PermanentCountry; 
        public String PermanentZip; 
        public String PhoneNo;  
        public String Mobile;   
        public String Email;    
        public String Fax;  
        public String RelatedToDirector;    
        public String DirectorBank; 
        public String DirectorName; 
        public String CustomerIC;   
        public String CompanyName;  
        public String GroupCompanyAddress;  
        public String CompanyPIN;   
        public String CompanyFax;   
        public String CompanyEmail;          
        public String AltMobile;    
        public String Landline; 
        public String Experience;
        public String Residential_Status;
        //Party fields
        public String CibilScore;
        public String EmploymentType;                    
        public String CompanyPhone; 
        public String FinancialApplicant;           
        //public String ApprovedNMIITR;
        public String ClaimedNMIITR;
        public String ClaimedAgriIncome;    
        public String ApprovedAgriIncome; 
        public String CustomerType;  
        //public String ClaimedNMI; 
        //public String ApprovedNMI;    
        public String ExistingEMIClaimed;   
        public String PerfiosEMI;   
        public String CIBILEMI; 
        public String KVBEMI;   
        public String CIBILEMIOverride; 
        public String ComputedEMI;  
        public String ExistingEMIApproved;  
        public String TotalChequeBounce;    
        public String AverageCASABal; 
        public String PrimaryBank;  
        public String PrimaryBranch;    
        public String PrimaryAccNo; 
        public String PrimaryIFSC;  
        public String GrossIncome1; 
        public String AnnualCapGain1;   
        public String InterestIncome1;  
        public String AnnualTax1;   
        public String DividendIncome1;  
        public String ShareOfProfit1;   
        public String AgricultureITR1;  
        //public String NetAnnualIncome1;   
        public String GrossIncome2; 
        public String AnnualCapGain2;   
        public String InterestIncome2;  
        public String AnnualTax2;   
        public String DividendIncome2;  
        public String ShareOfProfit2;   
        public String AgricultureITR2;  
        //public String NetAnnualIncome2;
        public String GrossIncome3; 
        public String AnnualCapGain3;   
        public String InterestIncome3;  
        public String AnnualTax3;   
        public String DividendIncome3;  
        public String ShareOfProfit3;   
        public String AgricultureITR3;     
        public String SalaryPaid; 
        public String TaxDeducted;  
        //public String NetSalary;    
        public String OtherReccuringIncome; 
        public String EstimatedBusinessIncome;
        //public String Party_Type; 
        public String Average_CASA_Balance;
        public String Title_Holder;         
    }

    public class cls_Company {
        public String CBS_Customer_ID;  
        public String Company_name; 
        public String Company_type; 
        public String Relationship_with_Company;    
        public String Company_PAN;  
        public String Company_Address;  
        public String Company_Pincode;  
        public String Company_City; 
        public String Company_State;    
    }
    
    @HttpPost
    global static Response insertCoApplicant(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
       if(req == null || req.requestBody == null){
            return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_CODE, WS_Vendor_Constants.WS_REQ_BODY_IS_NULL,'');
       }else{
            try{
                String jsonData  = req.requestBody.toString();
                cls_APPLICATION_DETAILS reqApp  = (cls_APPLICATION_DETAILS)Json.deserialize(jsonData, cls_APPLICATION_DETAILS.class);

                List<Account> accList = new List<Account>();
                List<Account> insertList = new List<Account>();
                Map<String,Account> AccMap = new Map<String,Account>();
                Map<String,Account> existAccMap = new Map<String,Account>();
                Map<String,String> compAccMap = new Map<String,String>();
                Map<String,Id> AccIdMap = new Map<String,Id>();
                Map<String,Account> compAccList = new Map<String,Account>();
                List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();                 
                Map<String,genesis__Application_Parties__c> AccPartyMap = new Map<String,genesis__Application_Parties__c>(); 
                Id accRecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.BUSINESS_ACCOUNT);                
                Id accountRecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.PERSON_ACCOUNT);

                //get application deatils
                genesis__Applications__c primaryAcc = [SELECT Id,genesis__Account__c,Sub_Stage__c,Record_Type_Name__c,Sourced_By__c FROM genesis__Applications__c WHERE Id=:reqApp.ApplicationID];
                String productType;
                List<String> usrList1 = new List<String>();
                usrList1 = WS_Vendor_RestAPIHelper.getUserList(primaryAcc.Sourced_By__c);
                
                if(primaryAcc.Record_Type_Name__c == WS_Vendor_Constants.HOMELOAN){
                    productType = 'HL';
                }
                else if(primaryAcc.Record_Type_Name__c == WS_Vendor_Constants.LAPLOAN){
                    productType = 'LAP';
                }

                //Map account fields
                for(cls_ApplicantDetails accDetails: reqApp.ApplicantDetails){
                    String s = checkForInvalidValues(accDetails);
                    if(s != null && s != ''){
                        return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_CODE, s,WS_Vendor_Constants.WS_ERROR_TYPE );                
                    }
                    Account acc = new Account();
                    genesis__Application_Parties__c party = new genesis__Application_Parties__c(); 
                    if(!String.isBlank(accDetails.FirstName)){
                        acc.FirstName = accDetails.FirstName;
                    }
                    if(!String.isBlank(accDetails.MiddleName)){
                        acc.MiddleName = accDetails.MiddleName;
                    }
                    if(!String.isBlank(accDetails.LastName)){
                        acc.LastName = accDetails.LastName;
                    }
                    if(!String.isBlank(accDetails.FullName)){
                        acc.Full_Name__c = accDetails.FullName;
                    }
                    if(!String.isBlank(accDetails.PAN)){
                        acc.Pan_Number__c  = accDetails.PAN;
                    }
                    if(!String.isBlank(accDetails.AadharNumber)){
                        acc.Aadhaar_Number__pc = accDetails.AadharNumber;
                    }
                    /*if(!String.isBlank(accDetails.CBSCustId)){
                        acc.CBS_Customer_ID__c = accDetails.CBSCustId;
                    }*/
                    if(!String.isBlank(accDetails.Title)){
                        acc.PersonTitle = accDetails.Title;
                        acc.Salutation = accDetails.Title;
                    }
                    /*if(!String.isBlank(accDetails.Nationality)){
                        acc.Nationality__pc = accDetails.Nationality;
                    }*/
                    acc.Nationality__pc = 'Indian';
                    if(!String.isBlank(accDetails.Gender)){
                        acc.Gender__pc = accDetails.Gender;
                    }
                    if(!String.isBlank(accDetails.Caste)){
                        acc.Caste__pc = accDetails.Caste;
                    }
                    if(!String.isBlank(accDetails.BirthDate)){
                        acc.PersonBirthdate = date.valueOf(accDetails.BirthDate);
                    }
                    if(!String.isBlank(accDetails.Maritalstatus)){
                        acc.Marital_Status__pc = accDetails.Maritalstatus;
                    }
                    if(!String.isBlank(accDetails.FatherName)){
                        acc.Father_Name__pc = accDetails.FatherName;
                    }
                    if(!String.isBlank(accDetails.HusbandName)){
                        acc.Husband_Name__pc = accDetails.HusbandName;
                    }
                    if(!String.isBlank(accDetails.BankingWithUs)){
                        acc.Banking_with_us__c = date.ValueOf(accDetails.BankingWithUs);
                    }
                    if(!String.isBlank(accDetails.Religion)){
                        acc.Religion__c = accDetails.Religion;
                    }
                    if(!String.isBlank(accDetails.ExServiceMan)){
                        acc.Is_Ex_Service_Man__c = boolean.valueOf(accDetails.ExServiceMan);
                    }
                    if(!String.isBlank(accDetails.PhysicallyHandicapped)){
                        acc.Is_Physically_Handicapped__c = boolean.valueOf(accDetails.PhysicallyHandicapped);
                    }
                    if(!String.isBlank(accDetails.VoterId)){
                        acc.Voter_Id__c = accDetails.VoterId;
                    }
                    if(!String.isBlank(accDetails.DrivingLicId)){
                        acc.Driving_License_ID__c = accDetails.DrivingLicId;
                    }
                    if(!String.isBlank(accDetails.RationCard)){
                        acc.Ration_Card__c = accDetails.RationCard;
                    }
                    if(!String.isBlank(accDetails.PassportNo)){
                        acc.Passport_Number__pc = accDetails.PassportNo;
                    }
                    if(!String.isBlank(accDetails.PassportExpDate)){
                        acc.passport_Expiry_Date__pc = date.ValueOf(accDetails.PassportExpDate);
                    }
                    if(!String.isBlank(accDetails.OtherId)){
                        acc.Other_Identification_Document__c = accDetails.OtherId;
                    }
                    if(!String.isBlank(accDetails.OtherIdNo)){
                        acc.Other_identification_number__c = accDetails.OtherIdNo;
                    }
                    if(!String.isBlank(accDetails.CurrentAddress)){
                        acc.PersonMailingStreet = accDetails.CurrentAddress;
                    }
                    if(!String.isBlank(accDetails.CurrentCity)){
                        acc.PersonMailingCity = accDetails.CurrentCity;
                    }
                    if(!String.isBlank(accDetails.CurrentState)){
                        acc.PersonMailingState = accDetails.CurrentState;
                    }
                    if(!String.isBlank(accDetails.CurrentCountry)){
                        acc.PersonMailingCountry = accDetails.CurrentCountry;
                    }
                    if(!String.isBlank(accDetails.CurrentZip)){
                        acc.PersonMailingPostalCode = accDetails.CurrentZip;
                    }
                    if(!String.isBlank(accDetails.PermanentAddress)){
                        acc.PersonOtherStreet = accDetails.PermanentAddress;
                    }
                    if(!String.isBlank(accDetails.PermanentCity)){
                        acc.PersonOtherCity = accDetails.PermanentCity;
                    }
                    if(!String.isBlank(accDetails.PermanentState)){
                        acc.PersonOtherState = accDetails.PermanentState;
                    }
                    if(!String.isBlank(accDetails.PermanentCountry)){
                        acc.PersonOtherCountry = accDetails.PermanentCountry;
                    }
                    if(!String.isBlank(accDetails.PermanentZip)){
                        acc.PersonOtherPostalCode = accDetails.PermanentZip;
                    }
                    if(!String.isBlank(accDetails.PhoneNo)){
                        acc.Phone = accDetails.PhoneNo;
                    }
                    if(!String.isBlank(accDetails.Mobile)){
                        acc.PersonMobilePhone = accDetails.Mobile;
                    }
                    if(!String.isBlank(accDetails.Email)){
                        acc.PersonEmail = accDetails.Email;
                    }
                    if(!String.isBlank(accDetails.Fax)){
                        acc.Fax = accDetails.Fax;
                    }
                    if(!String.isBlank(accDetails.RelatedToDirector)){
                        acc.Is_Applicant_Related_To_Bank_Directors__c = boolean.valueOf(accDetails.RelatedToDirector);
                    }
                    if(!String.isBlank(accDetails.DirectorBank)){
                        acc.Bank_name__c = accDetails.DirectorBank;
                    }
                    if(!String.isBlank(accDetails.DirectorName)){
                        acc.Name_Of_Director_Related_To__c = accDetails.DirectorName;
                    }
                    /*if(!String.isBlank(accDetails.CustomerIC)){
                        acc.Customer_IC__c = accDetails.CustomerIC;
                    }*/               
                    if(!String.isBlank(accDetails.CompanyName)){
                        acc.Company_Name__c = accDetails.CompanyName;
                    }
                    if(!String.isBlank(accDetails.GroupCompanyAddress)){
                        acc.Holding_Comp_Address__c = accDetails.GroupCompanyAddress;
                    }
                    if(!String.isBlank(accDetails.CompanyPIN)){
                        acc.Company_Pincode__c = accDetails.CompanyPIN;
                    }
                    if(!String.isBlank(accDetails.CompanyFax)){
                        acc.Company_Fax__c = accDetails.CompanyFax;
                    }
                    if(!String.isBlank(accDetails.CompanyEmail)){
                        acc.Company_Email__c = accDetails.CompanyEmail;
                    }                   
                    if(!String.isBlank(accDetails.AltMobile)){
                        acc.PersonOtherPhone = accDetails.AltMobile;
                    }
                    if(!String.isBlank(accDetails.Landline)){
                        acc.Phone = accDetails.Landline;
                    }
                    if(!String.isBlank(accDetails.Experience)){
                        acc.Experience__c = accDetails.Experience;
                    }
                    if(!String.isBlank(accDetails.Residential_Status)){
                        acc.Company_Residential_Address1__c = accDetails.Residential_Status;
                    }
                    acc.Customer_Type__c = 'RESIDENT INDIAN';
                    /*if((!String.isBlank(accDetails.FirstName)) && (!String.isBlank(accDetails.Gender)) && (!String.isBlank(accDetails.BirthDate))){
                        String name = accDetails.FirstName.replaceAll(' ','');
                        String DOB;
                        String gen = accDetails.Gender.left(1);
                        String x = 'X';
                        if(name.length()>=5){
                            name = name.left(5);
                        }else{
                            name = name + x.repeat(5-name.length());
                        }
                        if(String.valueOf(acc.PersonBirthdate.day()).length()< 2){
                            DOB = String.valueOf(acc.PersonBirthdate.day()).leftPad(2,'0');
                        }else{
                            DOB = String.valueOf(acc.PersonBirthdate.day());
                        }
                        if(String.valueOf(acc.PersonBirthdate.month()).length()< 2){
                            DOB = DOB + String.valueOf(acc.PersonBirthdate.month()).leftPad(2,'0');
                        }else{
                            DOB = DOB + String.valueOf(acc.PersonBirthdate.month());
                        }
                        DOB = DOB + String.valueOf(acc.PersonBirthdate.year());
                        acc.Customer_IC__c  = (name + DOB + gen).toUpperCase();                        
                    }*/
                    acc.RecordTypeId = accountRecordTypeId;
                   
                    //Update Party fields
                    if(!String.isBlank(accDetails.CibilScore)){
                        //acc.CIBIL_Score__c = decimal.ValueOf(accDetails.CibilScore);
                        party.CIBIL_Scores__c = decimal.ValueOf(accDetails.CibilScore);
                    }
                    if(!String.isBlank(accDetails.EmploymentType)){
                        party.Employment_Types__c = accDetails.EmploymentType;
                    }               
                    if(!String.isBlank(accDetails.CompanyPhone)){
                        party.Company_Phone__c = accDetails.CompanyPhone;
                    }
                    if(!String.isBlank(accDetails.FinancialApplicant)){
                        party.Financial_Applicant__c = boolean.valueOf(accDetails.FinancialApplicant);
                    }                
                    /*if(!String.isBlank(accDetails.ApprovedNMIITR)){
                        party.Approved_NMI_From_ITR__c = accDetails.ApprovedNMIITR;
                    }*/
                    if(!String.isBlank(accDetails.ClaimedNMIITR)){
                        party.Net_Monthly_Income__c = decimal.ValueOf(accDetails.ClaimedNMIITR);
                    }
                    if(!String.isBlank(accDetails.ClaimedAgriIncome)){
                        party.Additional_Income_Amount1__c = decimal.ValueOf(accDetails.ClaimedAgriIncome);
                    }
                    if(!String.isBlank(accDetails.ApprovedAgriIncome)){
                        party.Agriculture2__c = decimal.ValueOf(accDetails.ApprovedAgriIncome);
                    }
                    if(!String.isBlank(accDetails.CustomerType)){
                        party.genesis__Party_Type__c = accDetails.CustomerType;
                    }
                    /*if(!String.isBlank(accDetails.ClaimedNMI)){
                        party.NMI_Claimed_By_Customer__c = accDetails.ClaimedNMI;
                    }
                    if(!String.isBlank(accDetails.ApprovedNMI)){
                        party.NMI_Approved__c = accDetails.ApprovedNMI;
                    }*/
                    if(!String.isBlank(accDetails.ExistingEMIClaimed)){
                        party.Exisiting_EMIs_Claimed_by_Customer__c = decimal.ValueOf(accDetails.ExistingEMIClaimed);
                    }
                    if(!String.isBlank(accDetails.PerfiosEMI)){
                        party.Existing_EMI_Perfios__c = decimal.ValueOf(accDetails.PerfiosEMI);
                    }
                    if(!String.isBlank(accDetails.CIBILEMI)){
                        party.CIBIL_EMI__c = decimal.ValueOf(accDetails.CIBILEMI);
                    }
                    if(!String.isBlank(accDetails.KVBEMI)){
                        party.KVB_EMI__c = decimal.ValueOf(accDetails.KVBEMI);
                    }
                    if(!String.isBlank(accDetails.CIBILEMIOverride)){
                        party.CIBIL_EMI_Override__c = decimal.ValueOf(accDetails.CIBILEMIOverride);
                    }
                    /*if(!String.isBlank(accDetails.ComputedEMI)){
                        party. = decimal.ValueOf(accDetails.ComputedEMI);
                    }*/
                    if(!String.isBlank(accDetails.ExistingEMIApproved)){
                        party.Existing_Emis__c = decimal.ValueOf(accDetails.ExistingEMIApproved);
                    }
                    if(!String.isBlank(accDetails.TotalChequeBounce)){
                        party.Total_ChequeECS_bounces__c = decimal.ValueOf(accDetails.TotalChequeBounce);
                    }
                    if(!String.isBlank(accDetails.AverageCASABal)){
                        party.Average_Balances_6_months__c = decimal.ValueOf(accDetails.AverageCASABal);
                    }
                    if(!String.isBlank(accDetails.PrimaryBank)){
                        party.Primary_Bank__c = accDetails.PrimaryBank;
                    }
                    if(!String.isBlank(accDetails.PrimaryBranch)){
                        party.Primary_Bank_Branch__c = accDetails.PrimaryBranch;
                    }
                    if(!String.isBlank(accDetails.PrimaryAccNo)){
                        party.Bank_Account_Number__c = accDetails.PrimaryAccNo;
                    }
                    if(!String.isBlank(accDetails.PrimaryIFSC)){
                        party.IFSC_code__c = accDetails.PrimaryIFSC;
                    }
                    if(!String.isBlank(accDetails.GrossIncome1)){
                        party.Gross_Income1__c = decimal.ValueOf(accDetails.GrossIncome1);
                    }
                    if(!String.isBlank(accDetails.AnnualCapGain1)){
                        party.Annual_Capital_Gain1__c = decimal.ValueOf(accDetails.AnnualCapGain1);
                    }
                    if(!String.isBlank(accDetails.InterestIncome1)){
                        party.Interest_Income1__c = decimal.ValueOf(accDetails.InterestIncome1);
                    }
                    if(!String.isBlank(accDetails.AnnualTax1)){
                        party.Annual_Tax1__c = decimal.ValueOf(accDetails.AnnualTax1);
                    }
                    if(!String.isBlank(accDetails.DividendIncome1)){
                        party.Dividend_Income1__c = decimal.ValueOf(accDetails.DividendIncome1);
                    }
                    if(!String.isBlank(accDetails.ShareOfProfit1)){
                        party.Share_of_Profit_1__c = decimal.ValueOf(accDetails.ShareOfProfit1);
                    }
                    if(!String.isBlank(accDetails.AgricultureITR1)){
                        party.Agriculture_ITR1__c = decimal.ValueOf(accDetails.AgricultureITR1);
                    }
                    /*if(!String.isBlank(accDetails.NetAnnualIncome1)){
                        party.Net_Annual_Income1__c = accDetails.NetAnnualIncome1;
                    }*/
                    if(!String.isBlank(accDetails.GrossIncome2)){
                        party.Gross_Income2__c = decimal.ValueOf(accDetails.GrossIncome2);
                    }
                    if(!String.isBlank(accDetails.AnnualCapGain2)){
                        party.Annual_Capital_Gain2__c = decimal.ValueOf(accDetails.AnnualCapGain2);
                    }
                    if(!String.isBlank(accDetails.InterestIncome2)){
                        party.Interest_Income2__c = decimal.ValueOf(accDetails.InterestIncome2);
                    }
                    if(!String.isBlank(accDetails.AnnualTax2)){
                        party.Annual_Tax2__c = decimal.ValueOf(accDetails.AnnualTax2);
                    }
                    if(!String.isBlank(accDetails.DividendIncome2)){
                        party.Dividend_Income2__c = decimal.ValueOf(accDetails.DividendIncome2);
                    }
                    if(!String.isBlank(accDetails.ShareOfProfit2)){
                        party.Share_of_Profit_1__c = decimal.ValueOf(accDetails.ShareOfProfit2);
                    }
                    if(!String.isBlank(accDetails.AgricultureITR2)){
                        party.Agriculture_ITR2__c = decimal.ValueOf(accDetails.AgricultureITR2);
                    }
                    /*if(!String.isBlank(accDetails.NetAnnualIncome2)){
                        party.Net_Annual_Income2__c = accDetails.NetAnnualIncome2;
                    }*/
                    if(!String.isBlank(accDetails.GrossIncome3)){
                    party.Gross_Income3__c = decimal.ValueOf(accDetails.GrossIncome3);
                    }
                    if(!String.isBlank(accDetails.AnnualCapGain3)){
                        party.Annual_Capital_Gain3__c = decimal.ValueOf(accDetails.AnnualCapGain3);
                    }
                    if(!String.isBlank(accDetails.InterestIncome3)){
                        party.Interest_Income3__c = decimal.ValueOf(accDetails.InterestIncome3);
                    }
                    if(!String.isBlank(accDetails.AnnualTax3)){
                        party.Annual_Tax3__c = decimal.ValueOf(accDetails.AnnualTax3);
                    }
                    if(!String.isBlank(accDetails.DividendIncome3)){
                        party.Dividend_Income3__c = decimal.ValueOf(accDetails.DividendIncome3);
                    }
                    if(!String.isBlank(accDetails.ShareOfProfit3)){
                        party.Share_of_Profit_3__c = decimal.ValueOf(accDetails.ShareOfProfit3);
                    }
                    if(!String.isBlank(accDetails.AgricultureITR3)){
                        party.Agriculture_ITR3__c = decimal.ValueOf(accDetails.AgricultureITR3);
                    }
                    if(!String.isBlank(accDetails.SalaryPaid)){
                        party.Amount_Paid__c = decimal.ValueOf(accDetails.SalaryPaid);
                    }
                    if(!String.isBlank(accDetails.TaxDeducted)){
                        party.Tax_Deducted__c = decimal.ValueOf(accDetails.TaxDeducted);
                    }
                    /*if(!String.isBlank(accDetails.NetSalary)){
                        party.Net_Amount_Paid__c = accDetails.NetSalary;
                    }*/
                    if(!String.isBlank(accDetails.OtherReccuringIncome)){
                        party.Annual_Other_IncomeRecurring_CreditsITR__c = decimal.ValueOf(accDetails.OtherReccuringIncome);
                    }
                    if(!String.isBlank(accDetails.EstimatedBusinessIncome)){
                        party.Estimated_Business_Income__c = decimal.ValueOf(accDetails.EstimatedBusinessIncome);
                    }
                    if(!String.isBlank(accDetails.Title_Holder)){
                    party.Title_Holder__c = boolean.ValueOf(accDetails.Title_Holder);
                    }
                    if(!String.isBlank(accDetails.Average_CASA_Balance)){
                    party.Average_Balances_6_months__c = decimal.ValueOf(accDetails.Average_CASA_Balance);
                    } 
                    if(usrList1.size()>0){
                        acc.OwnerId = usrList1[0];
                        party.OwnerId = usrList1[0];
                    }
                                    
                    accList.add(acc);
                    AccPartyMap.put(acc.Aadhaar_Number__pc,party);
                    system.debug('accDetails.CompanyDetails'+accDetails.CompanyDetails);
                    if(accDetails.CompanyDetails!=null){
                        for(cls_Company comp : accDetails.CompanyDetails){
                            Account compAcc = new Account();
                            /*if(!String.isBlank(comp.CBS_Customer_ID)){
                            compAcc.CBS_Customer_ID__c = comp.CBS_Customer_ID;
                            }*/
                            if(!String.isBlank(comp.Company_name)){
                            compAcc.Name = comp.Company_name;
                            }
                            if(!String.isBlank(comp.Company_type)){
                            compAcc.Firm_Type__c = comp.Company_type;
                            }
                            if(!String.isBlank(comp.Relationship_with_Company)){
                            compAcc.Relationship_with_Firm__c = comp.Relationship_with_Company;
                            }
                            if(!String.isBlank(comp.Company_PAN)){
                            compAcc.Pan_Number__c = comp.Company_PAN;
                            }
                            if(!String.isBlank(comp.Company_Address)){
                            compAcc.BillingStreet = comp.Company_Address;
                            }
                            if(!String.isBlank(comp.Company_Pincode)){
                            compAcc.BillingPostalCode = comp.Company_Pincode;
                            }
                            if(!String.isBlank(comp.Company_City)){
                            compAcc.BillingCity = comp.Company_City;
                            }
                            if(!String.isBlank(comp.Company_State)){
                            compAcc.BillingState = comp.Company_State;
                            }
                            compAcc.RecordTypeId = accRecordTypeId;
                            if(usrList1.size()>0){
                                compAcc.OwnerId = usrList1[0];
                            }
                            compAccList.put(compAcc.Pan_Number__c,compAcc); 
                            compAccMap.put(compAcc.Pan_Number__c,acc.Aadhaar_Number__pc);                           
                        }
                    }
                }
                
                for(Account ac : [SELECT Id,Aadhaar_Number__pc FROM Account WHERE Aadhaar_Number__pc IN:AccPartyMap.keyset()]){
                    AccMap.put(ac.Aadhaar_Number__pc,ac);
                }

                for(Account cac : [SELECT Id,Pan_Number__c FROM Account WHERE Pan_Number__c IN:compAccList.keyset()]){
                    existAccMap.put(cac.Pan_Number__c,cac);
                }
                                
                if(accList.size()>0){
                    for(Account ac : accList){
                        if(AccMap.keyset().contains(ac.Aadhaar_Number__pc)){
                            ac.Id = AccMap.get(ac.Aadhaar_Number__pc).Id;                            
                        }    
                        insertList.add(ac);                       
                    }
                }

                if(compAccList.size()>0){
                    for(Account a:compAccList.values()){
                        if(existAccMap.keyset().contains(a.Pan_Number__c)){
                            a.Id = existAccMap.get(a.Pan_Number__c).Id;
                        }                         
                        insertList.add(a);
                    }               
                }

                if(insertList.size()>0){
                    upsert insertList;
                }
                
                if(insertList.size()>0){
                    for(Account ac : insertList){
                        if(ac.RecordTypeId == accountRecordTypeId){
                            AccIdMap.put(ac.Aadhaar_Number__pc,ac.Id);
                        }
                    }
                }       
                //genesis__Application_Parties__c primaryAcc = [SELECT Key_Contact__c FROM genesis__Application_Parties__c WHERE genesis__Application__c=:reqApp.ApplicationID AND genesis__Party_Type__c=:WS_Vendor_Constants.PRIMARY_APP];
       
                //Create parties
                if(insertList.size()>0){
                    for(Account ac : insertList){
                        genesis__Application_Parties__c part = new genesis__Application_Parties__c();
                        if(ac.RecordTypeId == accountRecordTypeId){
                            part = AccPartyMap.get(ac.Aadhaar_Number__pc);
                            part.genesis__Application__c = reqApp.ApplicationID;
                            part.genesis__Party_Account_Name__c = ac.Id;
                            part.Key_Contact__c = primaryAcc.genesis__Account__c;
                            part.Product_Type__c = productType; 
                            if(part.genesis__Party_Type__c != WS_Vendor_Constants.PRIMARY_APP){
                                partyList.add(part);
                            }
                            Applicant_Response ar = new Applicant_Response();
                            ar.ApplicantId = ac.Id;
                            ar.Applicant_Name = ac.LastName;
                            res.ApplicantDetails.add(ar);
                        }else if(ac.RecordTypeId == accRecordTypeId){
                            part.genesis__Application__c = reqApp.ApplicationID;
                            part.genesis__Party_Account_Name__c = ac.Id;
                            if(ac.Relationship_with_Firm__c!=null || ac.Relationship_with_Firm__c!=''){
                                part.genesis__Party_Type__c = ac.Relationship_with_Firm__c;
                            }
                            part.Key_Contact__c = AccIdMap.get(compAccMap.get(ac.Pan_Number__c));
                            part.Company__c = true;
                            part.Product_Type__c = productType;
                            if(usrList1.size()>0){
                                part.OwnerId = usrList1[0];
                            }
                            partyList.add(part);
                        }                    
                    }
                }
                
                if(partyList.size()>0){
                    insert partyList;
                } 

                if(primaryAcc.Record_Type_Name__c == WS_Vendor_Constants.HOMELOAN || primaryAcc.Record_Type_Name__c == WS_Vendor_Constants.LAPLOAN){
                    primaryAcc.Sub_Stage__c = WS_Vendor_Constants.SUB_STAGE_CO_ADDED;  
                }
                update primaryAcc;  

                if(insertList.size()>0){
                    res.ApplicationDocCategoryDetails = WS_Vendor_AppDocCategoryCreation.CreateDocCat(primaryAcc,accList,false);
                }                                         
                res.ApplicationId = reqApp.ApplicationID;
                return getWSResponse(res, WS_Vendor_Constants.WS_SUCCESS_STATUS, '', WS_Vendor_Constants.WS_SUCCESS_CODE, '','');
            }
            catch(Exception e){
                system.debug(e.getMessage()+' At '+e.getLineNumber());
                return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_INTERNAL_CODE, WS_Vendor_Constants.WS_INTERNAL_ERROR,WS_Vendor_Constants.WS_ERROR_TYPE_INTERNAL);
            }
       }
   }

   static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg,string errType){
        res.status           = status;
        res.successMessage  = succMsg;
        res.statusCode        = statusCode;
        res.errorMessage  = errMsg;
        res.errorType = errType;
        return res;
    }

    static String checkForInvalidValues(cls_ApplicantDetails accDetails){
        system.debug('testing'+WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.BankingWithUs));
        String s = '';
        
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.BirthDate)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(accDetails.BirthDate)){
                s = 'Invalid BirthDate field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.CompanyEmail)){
            if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}',accDetails.CompanyEmail)){
                s = 'Invalid CompanyEmail field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.Email)){
            if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}',accDetails.Email)){
                s = 'Invalid Email field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.BankingWithUs)){
            system.debug('In1');
            if(!WS_Vendor_RestAPIHelper.isValidDate(accDetails.BankingWithUs)){
                system.debug('In2');
                s = 'Invalid BankingWithUs field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.PassportExpDate)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(accDetails.PassportExpDate)){
                s = 'Invalid PassportExpDate field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.ExServiceMan)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(accDetails.ExServiceMan)){
                s = 'Invalid ExServiceMan field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.PhysicallyHandicapped)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(accDetails.PhysicallyHandicapped)){
                s = 'Invalid PhysicallyHandicapped field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.RelatedToDirector)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(accDetails.RelatedToDirector)){
                s = 'Invalid RelatedToDirector field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.FinancialApplicant)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(accDetails.FinancialApplicant)){
                s = 'Invalid FinancialApplicant field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.Title_Holder)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(accDetails.Title_Holder)){
                s = 'Invalid Title_Holder field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.CibilScore)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.CibilScore)){
                s = 'Invalid CibilScore field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.ClaimedNMIITR)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.ClaimedNMIITR)){
                s = 'Invalid ClaimedNMIITR field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.ClaimedAgriIncome)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.ClaimedAgriIncome)){
                s = 'Invalid ClaimedAgriIncome field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.ApprovedAgriIncome)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.ApprovedAgriIncome)){
                s = 'Invalid ApprovedAgriIncome field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.ExistingEMIClaimed)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.ExistingEMIClaimed)){
                s = 'Invalid ExistingEMIClaimed field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.PerfiosEMI)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.PerfiosEMI)){
                s = 'Invalid PerfiosEMI field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.CIBILEMI)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.CIBILEMI)){
                s = 'Invalid CIBILEMI field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.KVBEMI)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.KVBEMI)){
                s = 'Invalid KVBEMI field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.CIBILEMIOverride)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.CIBILEMIOverride)){
                s = 'Invalid CIBILEMIOverride field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.ExistingEMIApproved)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.ExistingEMIApproved)){
                s = 'Invalid ExistingEMIApproved field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.TotalChequeBounce)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.TotalChequeBounce)){
                s = 'Invalid TotalChequeBounce field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AverageCASABal)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AverageCASABal)){
                s = 'Invalid AverageCASABal field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.GrossIncome1)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.GrossIncome1)){
                s = 'Invalid GrossIncome1 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AnnualCapGain1)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AnnualCapGain1)){
                s = 'Invalid AnnualCapGain1 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.InterestIncome1)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.InterestIncome1)){
                s = 'Invalid InterestIncome1 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AnnualTax1)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AnnualTax1)){
                s = 'Invalid AnnualTax1 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.DividendIncome1)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.DividendIncome1)){
                s = 'Invalid DividendIncome1 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.ShareOfProfit1)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.ShareOfProfit1)){
                s = 'Invalid ShareOfProfit1 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AgricultureITR1)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AgricultureITR1)){
                s = 'Invalid AgricultureITR1 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.GrossIncome2)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.GrossIncome2)){
                s = 'Invalid GrossIncome2 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AnnualCapGain2)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AnnualCapGain2)){
                s = 'Invalid AnnualCapGain2 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.InterestIncome2)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.InterestIncome2)){
                s = 'Invalid InterestIncome2 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AnnualTax2)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AnnualTax2)){
                s = 'Invalid AnnualTax2 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.DividendIncome2)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.DividendIncome2)){
                s = 'Invalid DividendIncome2 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.ShareOfProfit2)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.ShareOfProfit2)){
                s = 'Invalid ShareOfProfit2 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AgricultureITR2)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AgricultureITR2)){
                s = 'Invalid AgricultureITR2 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.GrossIncome3)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.GrossIncome3)){
                s = 'Invalid GrossIncome3 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AnnualCapGain3)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AnnualCapGain3)){
                s = 'Invalid AnnualCapGain3 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.InterestIncome3)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.InterestIncome3)){
                s = 'Invalid InterestIncome3 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AnnualTax3)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AnnualTax3)){
                s = 'Invalid AnnualTax3 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.DividendIncome3)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.DividendIncome3)){
                s = 'Invalid DividendIncome3 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.ShareOfProfit3)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.ShareOfProfit3)){
                s = 'Invalid ShareOfProfit3 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.SalaryPaid)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.SalaryPaid)){
                s = 'Invalid SalaryPaid field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.AgricultureITR3)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.AgricultureITR3)){
                s = 'Invalid AgricultureITR3 field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.TaxDeducted)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.TaxDeducted)){
                s = 'Invalid TaxDeducted field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.OtherReccuringIncome)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.OtherReccuringIncome)){
                s = 'Invalid OtherReccuringIncome field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.EstimatedBusinessIncome)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.EstimatedBusinessIncome)){
                s = 'Invalid EstimatedBusinessIncome field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.Average_CASA_Balance)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(accDetails.Average_CASA_Balance)){
                s = 'Invalid Average_CASA_Balance field value';  
            } 
        }
        system.debug('string s'+s);
        return s;
    }
}