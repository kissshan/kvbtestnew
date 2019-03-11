/***************************************************************************************************************************************
=========================================================================================================================================
__________________________________________________________________________________________________________________________________________
VERSION      DEVELOPER          DATE         DETAIL                MODIFIED DATE     MODIFIED BY     
_________________________________________________________________________________________________________________________________________
  v1.0        Bhavya           24/9/2018    Initial Development      11/12/2018         Bhavya 
=========================================================================================================================================
 Name    : WS_Vendor_CreateApplicationAndAccount.
 Company : ET Marlabs.
 Purpose : This class is used to create application and applicant during 3rd party loan onboarding
 Author  : Bhavya P 
==========================================================================================================================================  
******************************************************************************************************************************************/
@RestResource(urlMapping='/createApplication')
global class WS_Vendor_CreateApplicationAndAccount{

    public cls_APPLICATION_DETAILS App_Details;

    global class Response extends WS_Vendor_RestAPIHelper.WS_Vendor_Response{
        public String ApplicationName;
        public String ApplicationId;
        public String ApplicantId;
        public List<WS_Vendor_AppDocCategoryCreation.Document_Response> ApplicationDocCategoryDetails; //Document folder details
        global Response(){
            ApplicationName = '';
            ApplicationId = ''; 
            ApplicantId = '';
            ApplicationDocCategoryDetails = new List<WS_Vendor_AppDocCategoryCreation.Document_Response>();
        }
    } 

    public class InvalidValueException extends Exception {}

    public class cls_APPLICATION_DETAILS {

        //Wrapper for Account and party details 
        public cls_ApplicantDetails ApplicantDetails; 

        //Application fields         
        public String SourcedBy;    
        public String SourcedByOffice;
        public String InterestRate; //interest rate from 3rd party vendor, but stored in Recommended_Final_Rate_of_Interest
        public String LoanAmount; 
        public String SanctionDate; 
        public String EMISanctioned;   
        public String BranchCode;   
        public String BranchName;  
        public String SanctionedTerm;   
        public String HolidayPeriod;    
        public String TotalRepayAmount;         
        public String ReqLoanAmount;    
        public String ReqTerm;  
        public String ReqEMI;   
        public String ChargePaymentComplete;    
        public String DateOfDisbursement;   
        //public String DayOfDisbursal; 
        //public String MonthOfDisbursal;   
        //public String DisbursalFinancialYear; 
        public String DisbursementAmount;   
        public String DateOfAdvancePayment; 
        public String AdvancePaid;  
        public String SaleAgreementDate;    
        public String MarginToPay;  
        public String Margin;   
        public String TypeOfCharge; 
        public String RERAComplaint;    
        public String LoanAccNo;    
        public String LoanPurpose;  
        public String FIVerDate;    
        public String FISuccess;    
        public String DisbAccBank;  
        public String DisbAccBranch;    
        public String DisbAccIFSC;  
        public String DisbAccNo;    
        public String SIAccNo;  
        public String SIBank;   
        public String SIBranch; 
        public String SIIFSC;   
        public String SIApplicant;  
        public String ExcessMCLR;   
        public String MCLRType; 
        public String PreClosureRate;
        public String MCLRRate; 
        public String CASAAccNo;    
        public String MODDate;
        public String CKYC; //
        public String Scource_Type;
        public String Type_Of_Loan;
        public String Third_party_loan_account_no;
        public String KVB_Amount_Sanction; 
        public String CBR_Code; //related to PL and stored in genesis__Class_Code__c 
        public String PL_Score;
        public String Processing_Fee_Waiver;    //
        public String BankYear; //
        public String Reason_for_waiver;    //
        public String Acknowledgement;  //
        public String ProcessingFees;
        public String CERSAIFee;
        public String CIBILCharges;
        public String StampPaperFee;
        public String LegalCharges;
        public String ValuationCharges;               
    }

    public class cls_ApplicantDetails {

        //Company details for LAP
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
        public String Reason_for_Exemption; 
        public String FI_Exempted;  

        //Insurance ddetails
        public String Policy_type;
        public String Policy_number;
        //public String Policy_period;
        public String Insure_date;
        public String Expiry_date;
        public String Upload_insurance_policy;
        public String Is_KVB_designated_assignee;
        public String Standing_instruction;         
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
    global static Response insertApplication(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
       if(req == null || req.requestBody == null){
            return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_CODE, WS_Vendor_Constants.WS_REQ_BODY_IS_NULL,'');
       }else{
            try{
                String jsonData  = req.requestBody.toString();
                cls_APPLICATION_DETAILS reqApp  = (cls_APPLICATION_DETAILS)Json.deserialize(jsonData, cls_APPLICATION_DETAILS.class);
                cls_ApplicantDetails accDetails = new cls_ApplicantDetails();                
                accDetails = reqApp.ApplicantDetails;
                genesis__Applications__c application = new genesis__Applications__c();
                genesis__Application_Parties__c party = new genesis__Application_Parties__c();                
                Account acc = new Account();
                List<Account> insertList = new List<Account>();
                List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>(); 

                String s = checkForInvalidValues(reqApp,accDetails);
                if(s != null && s != ''){
                    return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_CODE, s,WS_Vendor_Constants.WS_ERROR_TYPE );                
                }

                //Check if account already exists
                List<Account> accList = new List<Account>();
                accList = [SELECT Id FROM Account WHERE Aadhaar_Number__pc=:accDetails.AadharNumber];               
                
                //Get Application record type and product type 
                application = WS_Vendor_RestAPIHelper.getRecordTypeAndProduct(reqApp.Type_Of_Loan);

                //Set Application Stage and Substage 
                application.Application_Stage__c = WS_Vendor_Constants.STAGE;
                if(reqApp.Type_Of_Loan == 'HL'|| reqApp.Type_Of_Loan == 'LAP' || reqApp.Type_Of_Loan == 'VL2W' || reqApp.Type_Of_Loan == 'VL4W'){
                    application.Sub_Stage__c = WS_Vendor_Constants.SUB_STAGE_APP_CREATED;
                }else if(reqApp.Type_Of_Loan == 'PL'){
                    application.Sub_Stage__c = WS_Vendor_Constants.SUB_STAGE_CBS_PENDING;                    
                }
                if(!String.isBlank(accDetails.CibilScore)){
                    application.Max_CIBIL_Score__c = decimal.ValueOf(accDetails.CibilScore);
                } 

                //Map application fields 
                if(!String.isBlank(reqApp.SourcedBy)){
                    application.Sourced_By__c = reqApp.SourcedBy;
                }
                if(!String.isBlank(reqApp.SourcedByOffice)){
                    application.Sourced_By_Office__c = reqApp.SourcedByOffice;
                }   
                if(!String.isBlank(reqApp.InterestRate)){
                    application.Recommended_Final_Rate_of_Interest__c =  decimal.ValueOf(reqApp.InterestRate);
                }   
                if(!String.isBlank(reqApp.LoanAmount)){
                    application.Sanction_Authority_Limit__c = decimal.ValueOf(reqApp.LoanAmount);
                }   
                if(!String.isBlank(reqApp.SanctionDate)){
                    application.Sanction_Date__c = date.valueOf(reqApp.SanctionDate);
                }                    
                if(!String.isBlank(reqApp.EMISanctioned)){
                    application.Sanctioned_EMI__c = decimal.ValueOf(reqApp.EMISanctioned);
                }   
                if(!String.isBlank(reqApp.BranchCode)){
                    application.Branch_Code__c = reqApp.BranchCode;
                }   
                if(!String.isBlank(reqApp.BranchName)){
                    application.Branch_Name__c = reqApp.BranchName;
                }  
                if(!String.isBlank(reqApp.SanctionedTerm)){
                    application.Sanctioned_Tenure__c = decimal.ValueOf(reqApp.SanctionedTerm);
                }
                if(!String.isBlank(reqApp.HolidayPeriod)){
                    application.Holiday_Period__c = decimal.ValueOf(reqApp.HolidayPeriod);
                }
                if(!String.isBlank(reqApp.TotalRepayAmount)){
                    application.Total_Repayment_Amount__c = decimal.ValueOf(reqApp.TotalRepayAmount);
                }               
                if(!String.isBlank(reqApp.ReqLoanAmount)){
                    application.genesis__Loan_Amount__c = decimal.ValueOf(reqApp.ReqLoanAmount);
                }
                if(!String.isBlank(reqApp.ReqTerm)){
                    application.genesis__Term__c = decimal.ValueOf(reqApp.ReqTerm);
                }
                if(!String.isBlank(reqApp.ReqEMI)){
                    application.EMI_Max__c = decimal.ValueOf(reqApp.ReqEMI);
                }
                if(!String.isBlank(reqApp.ChargePaymentComplete)){
                    application.CBS_Charge_Payment_Completed__c = boolean.valueOf(reqApp.ChargePaymentComplete);
                }
                if(!String.isBlank(reqApp.DateOfDisbursement)){
                    application.genesis__Disbursement_Date__c = date.ValueOf(reqApp.DateOfDisbursement);
                }
                /*if(!String.isBlank(reqApp.DayOfDisbursal)){
                    application.Day_Of_Disbursal__c = reqApp.DayOfDisbursal;
                }
                if(!String.isBlank(reqApp.MonthOfDisbursal)){
                    application.Month_Of_Disbursal__c = reqApp.MonthOfDisbursal;
                }
                if(!String.isBlank(reqApp.DisbursalFinancialYear)){
                    application.Disbursal_Financial_Year__c = reqApp.DisbursalFinancialYear;
                }*/
                if(!String.isBlank(reqApp.DisbursementAmount)){
                    application.Disbursement_Amount__c = decimal.ValueOf(reqApp.DisbursementAmount);
                }
                if(!String.isBlank(reqApp.DateOfAdvancePayment)){
                    application.Date_Of_Advance_Payment__c = date.ValueOf(reqApp.DateOfAdvancePayment);
                }
                if(!String.isBlank(reqApp.AdvancePaid)){
                    application.Advance_Payment_Made_If_Any__c = decimal.ValueOf(reqApp.AdvancePaid);
                }
                if(!String.isBlank(reqApp.SaleAgreementDate)){
                    application.Date_Of_Sale_Agreement__c = date.ValueOf(reqApp.SaleAgreementDate);
                }
                if(!String.isBlank(reqApp.MarginToPay)){
                    application.Margin_To_Be_Paid__c = decimal.ValueOf(reqApp.MarginToPay);
                }
                if(!String.isBlank(reqApp.Margin)){
                    application.genesis__Margin__c = decimal.ValueOf(reqApp.Margin);
                }
                /*if(!String.isBlank(reqApp.TypeOfCharge)){
                    application.Type_Of_Charge__c = reqApp.TypeOfCharge;
                }*/
                application.Type_Of_Charge__c = 'Third Party Charge';
                if(!String.isBlank(reqApp.RERAComplaint)){
                    application.Is_Property_RERA_Complaint__c = boolean.valueOf(reqApp.RERAComplaint);
                }
                /*if(!String.isBlank(reqApp.LoanAccNo)){
                    application.Loan_Account_Number__c = reqApp.LoanAccNo;
                }*/
                if(!String.isBlank(reqApp.LoanPurpose)){
                    application.Loan_Purpose__c = reqApp.LoanPurpose;
                }
                if(!String.isBlank(reqApp.FIVerDate)){
                    application.Date__c = date.ValueOf(reqApp.FIVerDate);
                }
                if(!String.isBlank(reqApp.FISuccess)){
                    application.FI_Success__c = reqApp.FISuccess;
                }
                if(!String.isBlank(reqApp.DisbAccBank)){
                    application.Disbursement_Account_Bank_Name__c = reqApp.DisbAccBank;
                }
                if(!String.isBlank(reqApp.DisbAccBranch)){
                    application.Disbursement_Account_Branch_Name__c = reqApp.DisbAccBranch;
                }
                if(!String.isBlank(reqApp.DisbAccIFSC)){
                    application.Disbursement_Account_IFSC_Code__c = reqApp.DisbAccIFSC;
                }
                if(!String.isBlank(reqApp.DisbAccNo)){
                    application.Disbursement_Account_Number__c = reqApp.DisbAccNo;
                }
                if(!String.isBlank(reqApp.SIAccNo)){
                    application.SI_Account_Number__c = reqApp.SIAccNo;
                }
                if(!String.isBlank(reqApp.SIBank)){
                    application.SI_Bank_Name__c = reqApp.SIBank;
                }
                if(!String.isBlank(reqApp.SIBranch)){
                    application.SI_Branch_Name__c = reqApp.SIBranch;
                }
                if(!String.isBlank(reqApp.SIIFSC)){
                    application.SI_IFSC_Code__c = reqApp.SIIFSC;
                }
                if(!String.isBlank(reqApp.SIApplicant)){
                    application.SI_Applicant__c = reqApp.SIApplicant;
                }
                if(!String.isBlank(reqApp.ExcessMCLR)){
                    application.Excess_MCLR__c = decimal.ValueOf(reqApp.ExcessMCLR);
                }
                if(!String.isBlank(reqApp.MCLRType)){
                    application.MCLR_Type__c = reqApp.MCLRType;
                }
                if(!String.isBlank(reqApp.PreClosureRate)){
                    application.PreClosure_Interest_Rate__c = decimal.ValueOf(reqApp.PreClosureRate);
                }
                if(!String.isBlank(reqApp.MCLRRate)){
                    application.MCLR_Rate__c = decimal.ValueOf(reqApp.MCLRRate);
                }
                if(!String.isBlank(reqApp.CASAAccNo)){
                    application.CASA_Account_No__c = reqApp.CASAAccNo;
                }
                if(!String.isBlank(reqApp.MODDate)){
                    application.MOD_Date__c = date.ValueOf(reqApp.MODDate);
                }
                if(!String.isBlank(reqApp.CKYC)){
                    application.genesis__ID_Number__c = reqApp.CKYC;
                }
                if(!String.isBlank(reqApp.Third_party_loan_account_no)){
                    application.genesis__Portfolio__c = reqApp.Third_party_loan_account_no;
                }
                if(!String.isBlank(reqApp.KVB_Amount_Sanction)){
                    application.genesis__Financed_Amount__c = decimal.ValueOf(reqApp.KVB_Amount_Sanction);
                }
                if(!String.isBlank(reqApp.CBR_Code)){
                    application.genesis__Class_Code__c = reqApp.CBR_Code;
                }
                if(!String.isBlank(reqApp.PL_Score)){
                    application.PL_Score__c = decimal.ValueOf(reqApp.PL_Score);
                }
                if(!String.isBlank(reqApp.Processing_Fee_Waiver)){
                    application.Book_Debts_Age__c = decimal.ValueOf(reqApp.Processing_Fee_Waiver);
                }
                if(!String.isBlank(reqApp.BankYear)){
                    application.BankYear__c = decimal.ValueOf(reqApp.BankYear);
                }
                if(!String.isBlank(reqApp.Reason_for_waiver)){
                    application.Reason_for_waiver__c =reqApp.Reason_for_waiver;
                }
                if(!String.isBlank(reqApp.Acknowledgement)){
                    application.Acknowledgement__c = boolean.ValueOf(reqApp.Acknowledgement);
                }
                if(!String.isBlank(reqApp.ProcessingFees)){
                    application.Processing_Charges__c = decimal.ValueOf(reqApp.ProcessingFees);
                }
                if(!String.isBlank(reqApp.CERSAIFee)){
                    application.Cersai_Charges__c = decimal.ValueOf(reqApp.CERSAIFee);
                }
                if(!String.isBlank(reqApp.CIBILCharges)){
                    application.Cibil_Charges__c = decimal.ValueOf(reqApp.CIBILCharges);
                }
                if(!String.isBlank(reqApp.StampPaperFee)){
                    application.Total_Stamp_Paper_Charge__c = decimal.ValueOf(reqApp.StampPaperFee);
                }
                if(!String.isBlank(reqApp.LegalCharges)){
                    application.Legal_Charges__c = decimal.ValueOf(reqApp.LegalCharges);
                }
                if(!String.isBlank(reqApp.ValuationCharges)){
                    application.Valuation_Charges__c = decimal.ValueOf(reqApp.ValuationCharges);
                }
                //Map account fields
                Id accountRecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.PERSON_ACCOUNT);
                if(!String.isBlank(accDetails.FirstName)){
                    acc.FirstName = accDetails.FirstName;
                    acc.Full_Name__c = accDetails.FirstName;
                }
                if(!String.isBlank(accDetails.MiddleName)){
                    acc.MiddleName = accDetails.MiddleName;
                    acc.Full_Name__c = acc.Full_Name__c +' '+accDetails.MiddleName;
                }
                if(!String.isBlank(accDetails.LastName)){
                    acc.LastName = accDetails.LastName;
                    acc.Full_Name__c = acc.Full_Name__c +' '+accDetails.LastName;
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
                } */               
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
                if(!String.isBlank(accDetails.EmploymentType)){
                    acc.Employment_Type__c = accDetails.EmploymentType;
                }
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
                acc.Customer_Type__c = 'RESIDENT INDIAN';
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
                }else{
                    party.genesis__Party_Type__c = WS_Vendor_Constants.PRIMARY_APP;
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
                if(!String.isBlank(accDetails.Reason_for_Exemption)){
                    party.Reason_for_Exemption__c = accDetails.Reason_for_Exemption;
                }
                if(!String.isBlank(accDetails.FI_Exempted)){
                    party.FI_Exempted__c = boolean.ValueOf(accDetails.FI_Exempted);
                }

                //Primary account creation
                if(accList.size()>0){                    
                    acc.Id = accList[0].Id;                  
                }
                
                //set owner Id
                List<String> usrList1 = new List<String>();
                usrList1 = WS_Vendor_RestAPIHelper.getUserList(application.Sourced_By__c);
                if(usrList1.size()>0){
                    application.OwnerId = usrList1[0];
                    acc.OwnerId = usrList1[0];
                    party.OwnerId = usrList1[0];
                }
                
                upsert acc;
                
                //ROI
                String RecordType;
                if(reqApp.Type_Of_Loan == 'HL'){
                    RecordType = WS_Vendor_Constants.HOMELOAN;
                }else if(reqApp.Type_Of_Loan == 'LAP'){
                    RecordType = WS_Vendor_Constants.LAPLOAN;
                }else if(reqApp.Type_Of_Loan == 'PL'){
                    RecordType = WS_Vendor_Constants.PERSONALLOAN;
                }else if(reqApp.Type_Of_Loan == 'VL2W'){
                    RecordType = WS_Vendor_Constants.VL2W;
                }else if(reqApp.Type_Of_Loan == 'VL4W'){
                    RecordType = WS_Vendor_Constants.VL2W;
                }
                Account ageAccount = [SELECT Age__c FROM Account WHERE Id =: acc.Id];
                if(RecordType != WS_Vendor_Constants.PERSONALLOAN){
                    List<Decimal> decList = WS_Vendor_RestAPIHelper.getInterestRate(application.Sourced_By__c,accDetails.EmploymentType,party.Financial_Applicant__c,application.Sanction_Authority_Limit__c,ageAccount.Age__c,RecordType,application.Max_CIBIL_Score__c);
                    if(decList.size()>1){
                        application.genesis__Interest_Rate__c = decList[0];
                        application.MCLR_Rate__c = decList[1];
                    }
                    application.Interest_Variation__c = application.genesis__Interest_Rate__c - application.MCLR_Rate__c;                              
                }else if(RecordType == WS_Vendor_Constants.PERSONALLOAN){
                    Decimal indexVar = Third_Party_CBR_Codes__c.getValues(application.Sourced_By__c).Index_Variance__c;
                    application.genesis__Interest_Rate__c = application.Recommended_Final_Rate_of_Interest__c;
                    application.Interest_Variation__c = application.genesis__Interest_Rate__c - indexVar;
                }
                application.genesis__Account__c = acc.Id;
                insert application;  
                genesis__Applications__c app = [SELECT Id,Name,Record_Type_Name__c,Branch_Code__c FROM genesis__Applications__c WHERE Id=:application.Id];

                //Insurance details for personal loan
                if(app.Record_Type_Name__c == WS_Vendor_Constants.PERSONALLOAN){
                     clcommon__Collateral_Insurance__c insurance = new clcommon__Collateral_Insurance__c();
                    if(!String.isBlank(accDetails.Policy_type)){
                        insurance.Policy_Type_pl__c = accDetails.Policy_type;
                    }
                    if(!String.isBlank(accDetails.Policy_number)){
                        insurance.clcommon__Policy_Number__c = accDetails.Policy_number;
                    }
                    /*if(!String.isBlank(accDetails.Policy_period)){
                        insurance.Policy_Period__c = accDetails.Policy_period;
                    }*/
                    if(!String.isBlank(accDetails.Insure_date)){
                        insurance.Date_Insure__c = date.ValueOf(accDetails.Insure_date);
                    }
                    if(!String.isBlank(accDetails.Expiry_date)){
                        insurance.Date_Policy_Expiry__c = date.ValueOf(accDetails.Expiry_date);
                    }
                    if(!String.isBlank(accDetails.Upload_insurance_policy)){
                        insurance.Upload_Insurance_Policy__c = boolean.ValueOf(accDetails.Upload_insurance_policy);
                    }
                    if(!String.isBlank(accDetails.Is_KVB_designated_assignee)){
                        insurance.Is_KVB_the_designated_assignee__c = accDetails.Is_KVB_designated_assignee;
                    }
                    if(!String.isBlank(accDetails.Standing_instruction)){
                        insurance.Standing_Instruction_E_Mandate_Set_up_Co__c = accDetails.Standing_instruction;
                    }
                    insurance.Application__c = application.Id;
                    if(usrList1.size()>0){
                        insurance.OwnerId = usrList1[0];
                    }
                    insert insurance;  
                }

                //Business account and party creation for company
                Map<String,Account> existAccMap = new Map<String,Account>();
                Map<String,Account> compAccList = new Map<String,Account>();
                Id accRecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.BUSINESS_ACCOUNT);
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
                        if(usrList1.size()>0){
                            compAcc.OwnerId = usrList1[0];
                        }
                        compAcc.RecordTypeId = accRecordTypeId;
                        compAccList.put(compAcc.Pan_Number__c,compAcc);
                    }
                }
               
                for(Account ac : [SELECT Id,Pan_Number__c FROM Account WHERE Pan_Number__c IN:compAccList.keyset()]){
                    existAccMap.put(ac.Pan_Number__c,ac);
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
                        genesis__Application_Parties__c part = new genesis__Application_Parties__c();
                        part.genesis__Application__c = application.Id;
                        part.Key_Contact__c = acc.Id;
                        part.genesis__Party_Account_Name__c = ac.Id;
                        part.Product_Type__c = reqApp.Type_Of_Loan;
                        if(ac.Relationship_with_Firm__c!=null || ac.Relationship_with_Firm__c!=''){
                            part.genesis__Party_Type__c = ac.Relationship_with_Firm__c;
                        }
                        if(usrList1.size()>0){
                            part.OwnerId = usrList1[0];
                        }
                        part.Company__c = true;
                        partyList.add(part);
                    }
                }

                //Create Party linking Application and Account
                party.genesis__Application__c = application.Id;
                party.Key_Contact__c = acc.Id;
                party.Product_Type__c = reqApp.Type_Of_Loan;
                party.genesis__Party_Account_Name__c = acc.Id;
                partyList.add(party);

                if(partyList.size()>0){
                    insert partyList;
                }

                /*try{
                    //Create task
                    String userId = WS_Vendor_RestAPIHelper.getUserList(app.Branch_Code__c,WS_Vendor_Constants.BRANCH_MANAGER);
                    String Rlpc = WS_Vendor_RestAPIHelper.getUserList(app.Branch_Code__c,WS_Vendor_Constants.RLPC_HEAD);
                    String pbg = WS_Vendor_RestAPIHelper.getUserList(app.Branch_Code__c,WS_Vendor_Constants.RLPC_HEAD);
                    if(userId != null){
                        WS_Vendor_RestAPIHelper.creatTaskAll(app.Id, userId, 'Review Vendor Application',2, Rlpc, pbg);                            
                    }
                }
                catch(Exception e){
                    return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_CODE, 'Invalid Branch code',WS_Vendor_Constants.WS_ERROR_TYPE );  
                }*/
                
                 if(partyList.size()>0 && application.Sourced_By__c == WS_Vendor_Constants.THIRDPARTY_HOMECREDIT){
                    clcommon__Log__c log=new clcommon__Log__c();
                    log.Application__c=application.Id;
                     log.Class_Name__c= WS_Vendor_Constants.CLASS_CreateApplicationAndAccount;
                    log.Error_Code__c=WS_Vendor_Constants.WS_SUCCESS_CODE;
                    log.clcommon__Message__c=WS_Vendor_Constants.WS_SUCCESS_STATUS;
                    insert log;
                }
                
                                             
                res.ApplicationName = app.Name;
                res.ApplicationId = application.Id;
                res.ApplicantId = acc.Id;
                List<Account> accList1 = new List<Account>();
                accList1.add(acc);
                res.ApplicationDocCategoryDetails = WS_Vendor_AppDocCategoryCreation.CreateDocCat(app,accList1,true); 
                //res.ApplicationDocCategoryDetails = WS_Vendor_AppDocCategoryCreation.createDocCategory(app);
                return getWSResponse(res, WS_Vendor_Constants.WS_SUCCESS_STATUS, '', WS_Vendor_Constants.WS_SUCCESS_CODE, '', '');
            }
            catch(Exception e){
                system.debug(e.getMessage()+' At '+e.getLineNumber());
                  clcommon__Log__c log = new clcommon__Log__c();
                  log.clcommon__Message__c = e.getMessage();
                  log.Error_Code__c=WS_Vendor_Constants.WS_ERROR_CODE;     
                  log.Class_Name__c= WS_Vendor_Constants.CLASS_CreateApplicationAndAccount;            
                  insert log;
                return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_INTERNAL_CODE, WS_Vendor_Constants.WS_INTERNAL_ERROR,WS_Vendor_Constants.WS_ERROR_TYPE_INTERNAL);
            }
        }
    }

    //Method to generate response
    static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg, string errType){
        res.status           = status;
        res.successMessage  = succMsg;
        res.statusCode        = statusCode;
        res.errorMessage  = errMsg;
        res.errorType = errType;
        return res;
    }

    //Method for datatype error handling
    static String checkForInvalidValues(cls_APPLICATION_DETAILS reqApp,cls_ApplicantDetails accDetails){
        system.debug('testing'+WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.BankingWithUs));
        String s = '';
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.InterestRate)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.InterestRate)){
                s = 'Invalid InterestRate field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.LoanAmount)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.LoanAmount)){
                s = 'Invalid LoanAmount field value';  
            } 
            if((reqApp.Type_Of_Loan == 'HL' && (Decimal.valueOf(reqApp.LoanAmount) < WS_Vendor_Constants.Min_HL || Decimal.valueOf(reqApp.LoanAmount) > WS_Vendor_Constants.Max_HL)) || (reqApp.Type_Of_Loan == 'PL' && (Decimal.valueOf(reqApp.LoanAmount) < WS_Vendor_Constants.Min_PL || Decimal.valueOf(reqApp.LoanAmount) > WS_Vendor_Constants.Max_PL)) || (reqApp.Type_Of_Loan == 'LAP' && (Decimal.valueOf(reqApp.LoanAmount) < WS_Vendor_Constants.Min_LAP || Decimal.valueOf(reqApp.LoanAmount) > WS_Vendor_Constants.Max_LAP)) || (reqApp.Type_Of_Loan == 'V2W' && (Decimal.valueOf(reqApp.LoanAmount) < WS_Vendor_Constants.Min_V2W || Decimal.valueOf(reqApp.LoanAmount) > WS_Vendor_Constants.Max_V2W)) || (reqApp.Type_Of_Loan == 'V4W' && (Decimal.valueOf(reqApp.LoanAmount) < WS_Vendor_Constants.Min_V4W || Decimal.valueOf(reqApp.LoanAmount) > WS_Vendor_Constants.Max_V4W))){
                s = 'LoanAmount does not meet the criteria to proceed';
            }
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.SanctionedTerm)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.SanctionedTerm)){
                s = 'Invalid SanctionedTerm field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.EMISanctioned)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.EMISanctioned)){
                s = 'Invalid EMISanctioned field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.HolidayPeriod)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.HolidayPeriod)){
                s = 'Invalid HolidayPeriod field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.TotalRepayAmount)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.TotalRepayAmount)){
                s = 'Invalid TotalRepayAmount field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.ReqLoanAmount)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.ReqLoanAmount)){
                s = 'Invalid ReqLoanAmount field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.ReqTerm)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.ReqTerm)){
                s = 'Invalid ReqTerm field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.ReqEMI)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.ReqEMI)){
                s = 'Invalid ReqEMI field value';  
            } 
        }
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.DisbursementAmount)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.DisbursementAmount)){
                s = 'Invalid DisbursementAmount field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.AdvancePaid)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.AdvancePaid)){
                s = 'Invalid AdvancePaid field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.MarginToPay)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.MarginToPay)){
                s = 'Invalid MarginToPay field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.Margin)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.Margin)){
                s = 'Invalid Margin field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.ExcessMCLR)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.ExcessMCLR)){
                s = 'Invalid ExcessMCLR field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.PreClosureRate)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.PreClosureRate)){
                s = 'Invalid PreClosureRate field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.MCLRRate)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.MCLRRate)){
                s = 'Invalid MCLRRate field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.KVB_Amount_Sanction)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.KVB_Amount_Sanction)){
                s = 'Invalid KVB_Amount_Sanction field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.PL_Score)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.PL_Score)){
                s = 'Invalid PL_Score field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.ChargePaymentComplete)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(reqApp.ChargePaymentComplete)){
                s = 'Invalid ChargePaymentComplete field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.RERAComplaint)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(reqApp.RERAComplaint)){
                s = 'Invalid RERAComplaint field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.SanctionDate)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(reqApp.SanctionDate)){
                s = 'Invalid SanctionDate field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.DateOfDisbursement)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(reqApp.DateOfDisbursement)){
                s = 'Invalid DateOfDisbursement field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.DateOfAdvancePayment)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(reqApp.DateOfAdvancePayment)){
                s = 'Invalid DateOfAdvancePayment field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.SaleAgreementDate)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(reqApp.SaleAgreementDate)){
                s = 'Invalid SaleAgreementDate field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.FIVerDate)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(reqApp.FIVerDate)){
                s = 'Invalid FIVerDate field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.MODDate)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(reqApp.MODDate)){
                s = 'Invalid MODDate field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.Processing_Fee_Waiver)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.Processing_Fee_Waiver)){
                s = 'Invalid Processing_Fee_Waiver field value';  
            } 
        }
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.BankYear)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.BankYear)){
                s = 'Invalid BankYear field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.Acknowledgement)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(reqApp.Acknowledgement)){
                s = 'Invalid Acknowledgement field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.ProcessingFees)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.ProcessingFees)){
                s = 'Invalid ProcessingFees field value';  
            } 
        }
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.CERSAIFee)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.CERSAIFee)){
                s = 'Invalid CERSAIFee field value';  
            } 
        }
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.CIBILCharges)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.CIBILCharges)){
                s = 'Invalid CIBILCharges field value';  
            } 
        }
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.StampPaperFee)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.StampPaperFee)){
                s = 'Invalid StampPaperFee field value';  
            } 
        }
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.LegalCharges)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.LegalCharges)){
                s = 'Invalid LegalCharges field value';  
            } 
        }
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.ValuationCharges)){
            if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.ValuationCharges)){
                s = 'Invalid ValuationCharges field value';  
            } 
        }  
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
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.FI_Exempted)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(accDetails.FI_Exempted)){
                s = 'Invalid FI_Exempted field value';  
            } 
        }
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.Insure_date)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(accDetails.Insure_date)){
                s = 'Invalid Insure_date field value';  
            } 
        } 
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.Expiry_date)){
            if(!WS_Vendor_RestAPIHelper.isValidDate(accDetails.Expiry_date)){
                s = 'Invalid Expiry_date field value';  
            } 
        }
        if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(accDetails.Upload_insurance_policy)){
            if(!WS_Vendor_RestAPIHelper.ISBoolean(accDetails.Upload_insurance_policy)){
                s = 'Invalid Upload_insurance_policy field value';  
            } 
        }
        system.debug('string s'+s);
        return s;
    }
}