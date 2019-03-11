/*
* Name    : WS_FetchApplicationDetails
* Company : ET Marlabs
* Purpose : This class is used to fetch Application with Account details
* Author  : Subas
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
    V1.1    25-Sep-2018    Venu         #Added Perfios Captured
    V1.2    28-Sep-2018    Venu         # Aadhaar and Pan Available Scenario ?! 4-8-10 removeing Adhar
    v1.3    28-Nov-2018    Braj         # Added stamp paper and Cersai with GST in fetch appln
    v1.4    11-Jan-2019    Braj         # HL MVP2:Added Facility and collateral in fetch
*******************************************************************************************/
@RestResource(urlMapping='/getAlldetailsHL')
global class WS_FetchApplicationDetails {
    
    global class DetailResponse extends WS_Response{
        //public genesis__Applications__c application;
        //public list<Account> applicants;
        public cls_APPLICATION_DETAILS application;
        public list<PerfiosData> PerfiosDetails;
        public DetailResponse (){
            application = New cls_APPLICATION_DETAILS();
            //perfs=new list<PerfiosData>();
        }
        //prashant on 04-10-2018
        public List<KYC_Detail_Fetch> KYCDetail; 
      //prashant ends 
    }
    
    public class cls_APPLICATION_DETAILS {
        public List<string> fetch_reason=constants.fetch_reason;         
        public List<AcctReqWrapper> ACCTDETAILS;
        public list<GmraWrapper> GmraDetails;
        public List<AppDocCategory> ApplicationDocCategoryDetails;
        public cls_Collateral[] Collateral;
        public String ApplicationID;
        public String Purpose_of_loan;
        public String Property_type;
        public String Purchase_cost_of_property;
        public String Cost_of_land;
        public String Cost_of_construction;
        public String Cost_of_repair;
        public String Bank_of_existing_home_loan;
        public String Loan_start_date_of_existing_home_loan;
        public String Tenure_of_existing_home_loan;
        public String Outstanding_balance;
        public String Project_code;
        public String Builder_name;
        public String Project_name;
        public String Tower;
        public String Flat;
        public String PMin;
        public String LMax;
        public String Is_CreditLife;
        public String Property_Address1;
        public String Total_repayment_amount;
        public string EMI;
        public String Interest;
        public String Loan_required_amount;
        public String Required_loan_tenure;
        public String Holiday_period;
        public String GMRA_policy_is_selected;
        public String Is_GMRA_policy_added_to_loan_amount;
        public String Branch_code;
        public String Branch_name;
        public String Is_loan_processing_fee_paid;
        public String Documents_uploaded;
        public String Sourced_by;
        public String Sourced_by_office;
        public String Stage;
        public String ProductCode;
        public string Charge_Processed;
      
        
        //SI bank information PL
        public String SI_Account_Number;
        public String SI_Bank_Name;
        public String SI_Branch_Name;
        public String SI_IFSC_Code;
        
        //disbursement bank information PL
        public String Disbursement_Account_Bank_Name;
        public String Disbursement_Account_Branch_Name;
        public String Disbursement_Account_IFSC_Code;
        public String Disbursement_Account_Number;
        public String Sanction_Message;
        
        //Value for Processing Fee status
        public String FETransId;
        public String PGTransId;
        public String TransDateTime;
        public String TotalAmnt;
        public String PgStatus;
        
        //Value for Eligibility
        public String Max_EMI;
        public String Max_Term;
        
        // public String Max_LTV;
        public String PMax;
        public String ROI;
        public String BorrowerDktId; //Docket Ids
        public String GuarantorDktId; //Docket Ids
        public String ModDktId; //Docket Ids
        public Boolean BorrowerEsign;
        public Boolean GuarantorEsign;
        public String BuildingAge;
        public String Fe_Extras;
        public string Property_State;
        public string Property_City;
        public string Property_Pincode;
        public string Branch_city;
        public string Branch_State;
        public String GMRA_Selected_Option;
        public String GMRA_Amount;
        public string Property_State_Id;
        public string Property_City_Id;
        public string Property_Address2;
        public string Whether_Construction_Completed;
        public string Branch_State_Id;
        public string Branch_city_Id;
        public string Holiday_PeriodMax;
        public string RejectScenario;
        
        //Processing Fee
        public string Processing_Charges;
        public string Processing_Charges_GST;
        public string Total_StampCharges;
        public string Cibil_Charges_GST;
        public string Cibil_Charges;
        public string Valuation_Charges;
        public string Valuation_Charges_GST;
        public string Legal_Charges;
        public string Legal_Charges_GST;
        public string Total_Processing_Fee;
        public string Cersai_Charges;
        public string CersaiCharges_GST;
        public string AppNo;
               
        //Added for MVP2
        public string Is_take_over;
        public string IFSC_code;
        public string Bank_Name;
        public string Branch_Name_Existing;
        public string Sanctioned_Loan_Amount;
        public string Outstanding_Loan_Amount;
        public string Date_of_Loan_Sanction;
        public string Start_Date_of_EMI;
        public string End_Date_of_EMI;
        public string Sanctioned_Loan_Term_in_months;
        public string Outstanding_Loan_Term_in_months;
        public string Sanctioned_ROI;
        public string Current_ROI;
        public string No_of_coapplicant_remaining;
        //LAP fields

         //vehicle tag - start-------------------------------------------------------------------
        public string VehicleType;
        public string MarginValue;
        public string MarginPaymentMode;
        public string MarginPaymentReference;
        public string PreApprovedValue;
        public string PreApprovedFlag;
        public string PreApprovedMessage;
        public string Legal_desk_state_flag;
        public string StampDuty;
        //vehicle tag - End----------------------------------------------------------------------
        public List<cls_SchemeMaster> SchemeMaster;

        //v1.4
        public List<cls_Facility> HL_Facility;
        public string SubType;
        //Collateral
        public String Total_cost_incurred_till_date;
        public String Cost_incurred_in_the_last_6_months;
        public string ApplicationNumber;

    }
    
    public class GmraWrapper{
        public string GMRA_Name;
        public string Amount;
    }
    
    public class AppDocCategory{
        public List<Uplodedfile> Uplodedfile;
        public string FolderName;
        public string FolderID;
        public string ApplicantID;
        public Boolean MultiDocCheckList;
    }
    
    public class Uplodedfile{
        public string FileName;
        public string UuID;
    }
    
    public class cls_Collateral {
        public String CollateralId;
        public String Collateral_Type;  //primary
        public String Collateral_Address;   //sahidnagar
        public String Collateral_State; //WestBengal
        public String Collateral_City;  //kolkata
        public String Collateral_PinCode;   //700075
        public String Collateral_Use;   //pp
        public String EM_Charge_Type;   //kdsj
        public String No_of_Tenants;    //2
        public String Vacant_Land_area; //500
        public String Collateral_Market_Value;  //100000
        //vehicle tag - start---------------------------------------------------------------------------
        public String  ManufacturerName;
        public String  ManufactureYear;
        public String  Model;
        public String  Variant;
        public String  DealerName;
        public String  DealerEmail;    
        public String  DealerPincode;
        public String  DealerPhone;
        public String  ExShowRoomPrice;
        public String  RegistrationCost;
        public String  InsuranceAmount;
        public String  AccessoriesValue;
        public String  TotalVehicleValue;
        public String  FinalVehicleValue;
        public String  AdvancesPaid;
        public String  ProformaInvoiceNo;
        public String  ProformaInvoiceDate;
        public String  ExshowroomPrice_Apg;
        public String  VLCalculatedValue;
        public String  ManualDealer;
        public String  SchemeType;
        public String  Ref_by_Dealer;
        public String  ManufactureMonth;
        //vehicle tag - End-------------------------------------------------------------------------------
        public cls_Title_Holder[] Title_Holder;
    }
    
    public class cls_SchemeMaster{
        public string SchemeName;
        public string SchemeCode;
        public string Active;
        public string StartDate;
        public string EndDate;
        public string LTVIncrese;
        public string Make;
        public string Model;
        public string PriceDiscount;
        public string FeeDiscount;        
    }

    public class cls_Title_Holder {
        public String ApplicantId;  //0015D000007LYcrQAG
        public String ApplicantName;
    }
    
    public class AcctReqWrapper {
        public String AccountId;
        public String Business_Account_Name;
        public string presentAddress1;
        public string presentAddress2;
        public string presentAddress3;
        public string presentCity;
        public string presentState;
        public string presentCountry;
        public string presentZip;
        public string addProof;
        public string voterId;
        public string electricityCustNo;
        public string CustLpgNo;
        public String AlternativeMobile;
        public String LandLine;
        public string waterBill;
        public string driveLicense;
        public string passport;
        public string caste;
        public string maritalStatus;
        public string branchCode;
        public string isPhyHandicap;
        public string isExserviceMan;
        public string religion;
        public string eduQualification;
        public string isAppRelatedBankDir;
        public string nameBankRelated;
        public string nameDirRelated;
        public string Annual_Other_Income_Recurring_Credits_IT; //this field to capture recurring income at applicant level for PL By Ashish Jain
        public string Are_you_an_existing_customer;
        public string Customer_since;
        public String Customer_ID;
        public String Aadhaar_No;
        public String account_No;
        public String PAN_No;
        public String Mobile_Number;
        public String E_mail;
        public String Reason_for_not_having_PAN_card;
        public String First_Name;
        public String Last_Name;
        public String Middle_Name;
        public string DOB;
        public String Fathers_Name;
        public String Husbands_Name;
        public String permanentAddress1;
        public String permanentAddress2;
        public String permanentAddress3;
        public String permanentCity;
        public String permanentState;
        public String permanentZip;
        public String permanentCountry;
        public String Nationality;
        public String Resdential_status;
        public string Do_you_have_any_assets;
        public String Immovable_assets;
        public String Other_assets;
        public String Employment_type;
        public String Cust_Type;
        public String Experience;
        public String Company_name;
        public String Company_address;
        public string Net_monthly_income;
        public String Mode_of_bank_statement_verification;
        public String Mode_of_ITR_verification;
        public string Additional_income;
        public String Source_of_income1;
        public string Additional_income_amount1;
        public String Source_of_income2;
        public string Additional_income_amount2;
        public String Source_of_income3;
        public string Additional_income_amount3;
        public String Source_of_income4;
        public string Additional_income_amount4;
        public String Source_of_income5;
        public string Additional_income_amount5;
        public string Applicant_Type;
        public string CBSAccNo1;
        public string CBSAccNo2;
        public string CBSAccNo3;
        public string CBSAccNo4;
        public string CBSAccNo5;
        public string IsFinancial;
        public string Full_Name;
        public string CurrentAddAsPermanentAddress;
        public string EmploymentSubType;
        public string ExisitingEMI_Claimed;
        public string AddressFrmCBS;
        public string Is_Bank_Statement_required;
        public string Is_ITR_required;
        //Lap Fields
        public String Gross_Income_1;
        public String Capital_Gains_1;
        public String Interest_income_1;
        public String Dividend_income_1;
        public String Tax_1;
        public String Gross_Income_2;
        public String Capital_Gains_2;
        public String Interest_income_2;
        public String Dividend_income_2;
        public String Tax_2;
        public String Gross_Income_3;
        public String Capital_Gains_3;
        public String Interest_income_3;
        public String Dividend_income_3;
        public String Tax_3;
        public String Month_1_Income;
        public String Month_2_Income;
        public String Month_3_Income;
        public String Month_4_Income;
        public String Month_5_Income;
        public String Month_6_Income;
        public String Amount_Paid;
        public String MinNMI;
        public String Tax;
        public String Agriculture_Income_itr1;
        public String Agriculture_Income_itr2;
        public String Agriculture_Income_itr3;
        public String Share_of_Profit_itr_yr1;
        public String Share_of_Profit_itr_yr2;
        public String Share_of_Profit_itr_yr3;
        public List<Company> Company;
        public string PerfiosUsed; //V1.1
        public string isKyc;  // V1.2
        
        //PL fields
        public string company_pincode;
        public string Company_City;
        public string Company_State;
        public String IncomeComputationForm;
        //vehicle start----------------------------------------------------------------
        public String PrimaryBank;
        public String primaryBankAccNo;
        public string PrimaryBranch;
        public String IfscCode;
        //mother maiden no
        public String Mothers_Name;
        public string party_TitleHolder;
        //Official email id field at party level
        public string Official_Email;
    }
    
    public class Company{
        public String FirmId;
        public String Business_Customer_ID; //12309900
        public String Firm_Name;    //Tcs
        public String Firm_Type;    //primary
        public String Relationship_with_Firm;   //AASEAR
        public String Firm_PAN; //ASDD
        public String Firm_Address; ///54 bangalore
        public String Firm_Pincode; //700075nfetch
        public String Firm_City;
        public String Firm_State;
    }
    
    public class PerfiosData{
        public string BankAccountNumber;
        public string ApplicantID;
        public string BankName;
        public string RecordID;
        // prashant singh
        public string status;
        public string ErrorMessage;
        public string BSUploadType ;
        public boolean IsDeleted;
        public boolean UploadBankStatement;
        public boolean ITRUploaded;
    }
     
    //prashant on 04-10-2018
    public class KYC_Detail_Fetch{
        public string Label;
        public string Code;
        public string ProofType;
    }
    //prashant ends

    //v1.4(start)
    public class cls_Facility {
        public string Takeover_Bank_Name;
        public string Takeover_Outstanding_Loan_Amount;
        public string Takeover_Outstanding_Loan_Tenure_months;
        public string Takeover_Loans_EMI;
        public string Existing_HL_Loan_Account_No;
        public string Existing_HL_Sanctioned_Amount;
        public string Existing_HL_Disbursed_Amount;
        public string Existing_HL_Oustanding_Balance;
        public string Existing_HL_Party1_Name;
        public string Existing_HL_Party1_Type;
        public string Existing_HL_Party1_Cust_ID;
        public string Existing_HL_Party2_Name;
        public string Existing_HL_Party2_Type;
        public string Existing_HL_Party2_Cust_ID;
        public string Existing_HL_Party3_Name;
        public string Existing_HL_Party3_Type;
        public string Existing_HL_Party3_Cust_ID;
        public string Existing_HL_Party4_Name;
        public string Existing_HL_Party4_Type;
        public string Existing_HL_Party4_Cust_ID;
        public string Existing_HL_Party5_Name;
        public string Existing_HL_Party5_Type;
        public string Existing_HL_Party5_Cust_ID;
        public string Existing_HL_Party6_Name;
        public string Existing_HL_Party6_Type;
        public string Existing_HL_Party6_Cust_ID;
        public string Selected_for_Top_Up;
        public string Existing_HL_SMA_Status;
        public string Existing_HL_1st_EMI_Date;
        public string Existing_HL_Outstanding_Tenure;
        public string Existing_HL_Sanctioned_Tenure;
        public string Active;
        public string FacilityId;
    }
    //v1.4(end)
    
    @httpGet
    global static DetailResponse getDetails(){
        RestRequest req = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        try{
            DetailResponse res = new DetailResponse();
            boolean includeLoans= false;
            string appId = req.params.get('appId');
            System.debug('appId>>>'+appId);
            string ApplicantID = req.params.get('ApplicantID');
            string Type = req.params.get('Type');
            System.debug('Type>>>'+Type);
            //String autoPopulate = req.params.get('autoPopulate');
             //prashant on 04-10-2018
                        res.KYCDetail   =   new List<KYC_Detail_Fetch>();
            List<Kyc_Master__mdt> listkycobj=[select id ,MasterLabel,Code__c,Type__c,DeveloperName from Kyc_Master__mdt ];
            System.debug('pp:-'+listkycobj);
            if(listkycobj !=null && !listkycobj.isEmpty()){
                for(Kyc_Master__mdt kycobj : listkycobj){
                    KYC_Detail_Fetch kycWrrpObj = new KYC_Detail_Fetch();
                    kycWrrpObj.Label=kycobj.MasterLabel;
                    kycWrrpObj.Code=kycobj.Code__c;
                    kycWrrpObj.ProofType = kycobj.Type__c;
                    
                    res.KYCDetail.add(kycWrrpObj);
                }    
            }
            //prashant ends
            
            if(!Utility.ISStringBlankorNull(appId) && Utility.ISStringBlankorNull(ApplicantID)){
                System.debug('INSIDE FETCH API');
                genesis__Applications__c appl = queryService.getApplication(appId);
                System.debug('**********'+appl.Branch_Name__c);
                if(Type =='ProcessFee'){
                    res.application.ApplicationID = String.ValueOf(appl.Id);
                    res.application.AppNo=String.ValueOf(appl.Name);
                    res.application.Processing_Charges = String.ValueOf(appl.Processing_Charges__c);
                    res.application.Processing_Charges_GST = String.ValueOf(appl.Processing_charges_with_GST__c);
                    res.application.Total_Processing_Fee = String.ValueOf(appl.Processing_Fee__c);
                    res.application.Cibil_Charges_GST = String.ValueOf(appl.CIBIL_Charges_with_GST__c);
                    res.application.Cibil_Charges = String.ValueOf(appl.Cibil_Charges__c);
                    if(appl.Record_Type_Name__c==Constants.PERSONALLOAN){
                        res.application.Total_StampCharges = String.ValueOf(appl.Total_Stamp_Paper_Charge__c);
                        res.application.Valuation_Charges = '0';
                        res.application.Valuation_Charges_GST = '0';
                        res.application.Legal_Charges = '0';
                        res.application.Legal_Charges_GST = '0';
                    }else if(appl.Record_Type_Name__c==Constants.VL2W || appl.Record_Type_Name__c==Constants.VL4W){
                        res.application.Valuation_Charges = '0';
                        res.application.Valuation_Charges_GST = '0';
                        res.application.Legal_Charges = '0';
                        res.application.Legal_Charges_GST = '0';
                        res.application.Total_StampCharges = String.ValueOf(appl.Total_Stamp_Paper_Charge__c);
                        res.application.Cersai_Charges = String.ValueOf(appl.Cersai_Charges__c);
                        res.application.CersaiCharges_GST = String.ValueOf(appl.Cersai_Fee_with_GST__c);
                        res.application.StampDuty = String.ValueOf(appl.Max_EMI__c);
                    }
                    else{
                        res.application.Valuation_Charges = String.ValueOf(appl.Valuation_Charges__c);
                        res.application.Valuation_Charges_GST = String.ValueOf(appl.Valuation_Charges_with_GST__c);
                        res.application.Legal_Charges = String.ValueOf(appl.Legal_Charges__c);
                        res.application.Legal_Charges_GST = String.ValueOf(appl.Legal_Opinion_with_GST__c); 
                        //v1.3(start)
                        res.application.Total_StampCharges = String.ValueOf(appl.Total_Stamp_Paper_Charge__c);
                        res.application.Cersai_Charges = String.ValueOf(appl.Cersai_Charges__c);
                        res.application.CersaiCharges_GST = String.ValueOf(appl.Cersai_Fee_with_GST__c);
                        //v1.3(end)
                    }
                    
                    return res;
                }
                else{
                    List<genesis__Application_Parties__c> PTList = queryService.getCompany(appId);
                    List<clcommon__Collateral__c> CollateralList = queryService.getCollateral(appId);
                    List<Facility__c> facilityList = queryService.getFacilityRecord(appId,false);//v1.4
                    //List<genesis__Application_Parties__c> accCount = queryService.getAccCount(appId);
                    res.application.ApplicationID = String.ValueOf(appl.Id);
                    res.application.SubType = String.ValueOf(appl.Sub_Type__c);//v1.4
                    res.application.Purpose_of_loan = String.ValueOf(appl.Loan_Purpose__c);
                    //res.application.Cost_of_repair = String.ValueOf(appl.Cost_Of_Repair__c);
                    res.application.Bank_of_existing_home_loan = String.ValueOf(appl.Bank_Of_Existing_Home_Loan__c);
                    res.application.Loan_start_date_of_existing_home_loan = String.ValueOf(appl.Loan_Start_Date_Of_Existing_Home_Loan__c);
                    res.application.Tenure_of_existing_home_loan = String.ValueOf(appl.Tenure_Of_Existing_Home_Loan__c);
                    res.application.Outstanding_balance = String.ValueOf(appl.Outstanding_Balance__c);
                    res.application.Project_code = String.ValueOf(appl.Project_Code__c);
                    res.application.Tower = String.ValueOf(appl.Tower__c);
                    res.application.PMin = String.ValueOf(appl.PMin__c);
                    if(appl.Record_Type_Name__c == 'Personal Loan'){
                        if(appl.PrimaryApplicant_CIBIL_Score__c >= 750){
                            res.application.LMax = String.ValueOf(appl.genesis__CL_Product__r.max_amount__c);
                        }else{
                            res.application.LMax = String.ValueOf(appl.genesis__CL_Product__r.LMax_PL__c);
                        }
                    }else{
                        res.application.LMax = String.ValueOf(appl.Pmax_Limit__c);
                    }
                    res.application.Is_CreditLife = String.ValueOf(appl.Is_CreditLife__c);
                    res.application.Property_Address1 = String.ValueOf(appl.Property_Address__c);
                    res.application.Property_Address2 = String.ValueOf(appl.Property_Address_Line_2__c);
                    res.application.Total_repayment_amount = String.ValueOf(appl.Total_Repayment_Amount__c);
                    res.application.EMI = String.ValueOf(appl.genesis__Payment_Amount__c);
                    res.application.Interest = String.ValueOf(appl.genesis__Interest_Rate__c);
                    res.application.Loan_required_amount = String.ValueOf(appl.genesis__Loan_Amount__c);
                    res.application.Required_loan_tenure = String.ValueOf(appl.genesis__Term__c);
                    res.application.Holiday_period = String.ValueOf(appl.Holiday_Period__c);
                    res.application.GMRA_policy_is_selected = String.ValueOf(appl.Is_GMRA_Policy_Selected__c);
                    res.application.Is_GMRA_policy_added_to_loan_amount = String.ValueOf(appl.Is_GMRA_Policy_Added_To_Loan_Amount__c);
                    res.application.Branch_code = String.ValueOf(appl.Branch_Code__c);    
                    res.application.Branch_name = String.ValueOf(appl.Branch_Name__c);    
                    res.application.Is_loan_processing_fee_paid = String.ValueOf(appl.Is_Loan_processing_Fee_Paid__c);
                    res.application.Documents_uploaded = String.ValueOf(appl.Documents_Uploaded__c);
                    res.application.Sourced_by = String.ValueOf(appl.Sourced_By__c);
                    res.application.Sourced_By_Office = String.ValueOf(appl.Sourced_By_Office__c);
                    res.application.Stage = String.ValueOf(appl.Sub_Stage__c);
                    res.application.ProductCode =String.valueOf(appl.Product_Code__c);
                    res.application.Max_EMI = String.ValueOf(appl.EMI_Max__c);
                    res.application.Max_Term = String.ValueOf(appl.Nmax__c);
                    res.application.PMax = String.ValueOf(appl.PMax__c);
                    System.debug('pmax:-'+res.application.PMax);
                    res.application.ROI = String.ValueOf(appl.genesis__Interest_Rate__c);
                    res.application.BorrowerEsign = appl.Borrowers_Esign__c;
                    res.application.GuarantorEsign = appl.Guarantor_Esign_Check__c;
                   // res.application.BuildingAge = String.valueOf(appl.Age_Of_The_Building__c);
                    res.application.Fe_Extras = String.valueOf(appl.FE_Extra__c);
                    res.application.Property_State = appl.Property_State__c;
                    res.application.Property_City = String.valueOf(appl.Property_City__c);
                    res.application.Property_Pincode = String.valueOf(appl.Property_Pincode__c);
                    res.application.Branch_city = String.valueOf(appl.Branch_City__c);
                    res.application.Branch_State = String.valueOf(appl.Branch_State__c);
                    res.application.GMRA_Selected_Option = String.valueOf(appl.GMRA_Option__c);
                    res.application.GMRA_Amount = String.valueOf(appl.GMRA_Amount__c);
                    res.application.Branch_State_Id = String.valueOf(appl.Branch_State_Id__c);
                    res.application.Branch_city_Id = String.valueOf(appl.Branch_City_Id__c);
                    res.application.Holiday_PeriodMax = String.valueOf(appl.Holiday_Max__c);
                    res.application.RejectScenario = appl.Reject_Scenario__c; //Reject Scenario
                    res.application.Is_take_over = String.ValueOf(appl.Is_Take_Over__c);
                    res.application.IFSC_code = appl.IFSC_code__c;
                    res.application.Branch_Name = appl.Branch_Name__c;
                    res.application.Branch_Name_Existing = appl.Bank_Name__c;
                    res.application.Sanctioned_Loan_Amount = String.ValueOf(appl.Sanctioned_Loan_Amount__c);
                    res.application.Outstanding_Loan_Amount = String.ValueOf(appl.Outstanding_Loan_Amount__c);
                    res.application.Date_of_Loan_Sanction = String.ValueOf(appl.Date_of_Loan_Sanction_Existing_Loan__c);
                    res.application.Start_Date_of_EMI = String.ValueOf(appl.Start_Date_of_EMI_Existing_Loan__c);
                    res.application.End_Date_of_EMI = String.ValueOf(appl.End_Date_of_EMI_Existing_Loan__c);
                    res.application.Sanctioned_Loan_Term_in_months = string.ValueOf(appl.Sanctioned_Loan_Term_Existing_Loan__c);
                    res.application.Outstanding_Loan_Term_in_months = String.ValueOf(appl.Outstanding_Loan_Term_Existing_Loan__c);
                    res.application.Sanctioned_ROI = String.ValueOf(appl.Sanctioned_ROI_Existing_Loan__c);
                    res.application.Current_ROI = String.ValueOf(appl.Current_ROI_Existing_Loan__c);
                    res.application.Charge_Processed =string.valueOf(appl.Charges_Processed__c);
                    
                    
                    //SI account related information PL
                    res.application.SI_Account_Number = Utility.getBlankStringIfNull(String.valueOf(appl.SI_Account_Number__c));
                    res.application.SI_Bank_Name = Utility.getBlankStringIfNull(appl.SI_Bank_Name__c);
                    res.application.SI_Branch_Name = Utility.getBlankStringIfNull(appl.SI_Branch_Name__c);
                    res.application.SI_IFSC_Code = Utility.getBlankStringIfNull(appl.SI_IFSC_Code__c);
                    
                    //vechicle Loan - Start--------------------------------------------------------------------------------
                    res.application.PreApprovedValue = Utility.getBlankStringIfNull(String.valueOf(appl.Pre_approved_value__c));
                    res.application.PreApprovedFlag = Utility.getBlankStringIfNull(String.valueOf(appl.Pre_approved_flag__c));
                    res.application.PreApprovedMessage = Constants.PreApprovedMessage;
                    res.application.Legal_desk_state_flag = Utility.getBlankStringIfNull(String.valueOf(appl.Legal_desk_state_flag__c));                
                    if( (appl.Record_Type_Name__c==Constants.VL2W || appl.Record_Type_Name__c==Constants.VL4W) && appl.Application_Stage__c == Constants.DISBURSEMENT_APPLICATIONS_MAINSTAGE){
                        res.application.Loan_required_amount = Utility.getBlankStringIfNull(String.ValueOf(appl.Sanction_Authority_Limit__c));
                        res.application.Interest = Utility.getBlankStringIfNull(String.ValueOf(appl.genesis__Interest_Rate__c));
                        res.application.Required_loan_tenure = Utility.getBlankStringIfNull(String.ValueOf(appl.Sanctioned_Tenure__c));
                        res.application.EMI = Utility.getBlankStringIfNull(String.ValueOf(appl.Sanctioned_EMI__c));
                   
                    }
                    //vehicle Loan -end------------------------------------------------------------------------------------
                    //for pre Approved loan
                    if(appl.Record_Type_Name__c==Constants.PERSONALLOAN && appl.Pre_approved_flag__c==true )
                    {
                        res.application.Loan_required_amount = Utility.getBlankStringIfNull(String.ValueOf(appl.Sanction_Authority_Limit__c));
                        res.application.EMI = Utility.getBlankStringIfNull(String.ValueOf(appl.Sanctioned_EMI__c));
                    }

                    //Scheme master
                    if(appl.Record_Type_Name__c==Constants.VL2W || appl.Record_Type_Name__c==Constants.VL4W){
                        List<Scheme_Master__c> SchemeList = queryService.getSchemes();
                        res.application.SchemeMaster = new List<cls_SchemeMaster>();
                        for(Scheme_Master__c schm: SchemeList){
                            if(appl.Record_Type_Name__c==schm.ProductType__c || appl.Record_Type_Name__c==schm.ProductType__c){
                            cls_SchemeMaster schms = new cls_SchemeMaster();
                            schms.SchemeName = Utility.getBlankStringIfNull(String.valueOf(schm.Name));
                            schms.SchemeCode = Utility.getBlankStringIfNull(String.valueOf(schm.Scheme_Code__c));
                            schms.Active = Utility.getBlankStringIfNull(String.valueOf(schm.Active_Flag__c));
                            schms.StartDate = Utility.getBlankStringIfNull(String.valueOf(schm.Start_Date__c));
                            schms.EndDate = Utility.getBlankStringIfNull(String.valueOf(schm.End_Date__c));
                            schms.LTVIncrese = Utility.getBlankStringIfNull(String.valueOf(schm.LTV_increase__c));
                            schms.Make = Utility.getBlankStringIfNull(String.valueOf(schm.Make__c));
                            schms.Model = Utility.getBlankStringIfNull(String.valueOf(schm.Model__c));
                            schms.PriceDiscount = Utility.getBlankStringIfNull(String.valueOf(schm.Pricing_Discount__c));
                            schms.FeeDiscount = Utility.getBlankStringIfNull(String.valueOf(schm.Processing_fee_discount__c));
                            res.application.SchemeMaster.add(schms);
                            }
                        } 
                    }
                    //End of Scheme master
                    //disbursement account related information PL
                    res.application.Disbursement_Account_Bank_Name = Utility.getBlankStringIfNull(appl.Disbursement_Account_Bank_Name__c);
                    res.application.Disbursement_Account_Number = Utility.getBlankStringIfNull(String.valueOf(appl.Disbursement_Account_Number__c));
                    res.application.Disbursement_Account_Branch_Name = Utility.getBlankStringIfNull(appl.Disbursement_Account_Branch_Name__c);
                    res.application.Disbursement_Account_IFSC_Code = Utility.getBlankStringIfNull(appl.Disbursement_Account_IFSC_Code__c);
                    res.application.Sanction_Message = Utility.getBlankStringIfNull(appl.Sanction_Message__c);
                    res.application.ACCTDETAILS = new List<AcctReqWrapper>();
                    
                    for(genesis__Application_Parties__c c : appl.genesis__Application_Parties__r){
                        AcctReqWrapper ab = new AcctReqWrapper();
                        ab.Company = new List<Company>();
                        if(c.Active__c ==true && c.Company__c == false ){
                            System.debug('@@@@@@@!!!!!@@@@@'+c);
                            ab.presentAddress1  =   String.valueOf(c.genesis__Party_Account_Name__r.PersonMailingStreet    )   ;
                            ab.presentCity  =   String.valueOf( c.genesis__Party_Account_Name__r.PersonMailingCity  )   ;
                            ab.presentState =   String.valueOf( c.genesis__Party_Account_Name__r.PersonMailingState )   ;
                            ab.presentCountry   =   String.valueOf( c.genesis__Party_Account_Name__r.PersonMailingCountry   )   ;
                            ab.presentZip   =   String.valueOf( c.genesis__Party_Account_Name__r.PersonMailingPostalCode    )   ;
                            ab.addProof =   String.valueOf( c.genesis__Party_Account_Name__r.Current_Address_Proof_Type__c  )   ;
                            ab.voterId  =   String.valueOf( c.genesis__Party_Account_Name__r.Voter_Id__c    )   ;
                            ab.electricityCustNo    =   String.valueOf( c.genesis__Party_Account_Name__r.Electricity_Customer_No__c )   ;
                            ab.CustLpgNo    =   String.valueOf( c.genesis__Party_Account_Name__r.Customer_LPG_No__c )   ;
                            ab.AlternativeMobile = String.valueOf(c.genesis__Party_Account_Name__r.PersonOtherPhone);
                            ab.LandLine = String.valueOf(c.genesis__Party_Account_Name__r.Phone);
                            ab.waterBill    =   String.valueOf( c.genesis__Party_Account_Name__r.Water_Bill_No__c   )   ;
                            ab.driveLicense =   String.valueOf( c.genesis__Party_Account_Name__r.Driving_License_ID__c  )   ;
                            ab.passport =   String.valueOf( c.genesis__Party_Account_Name__r.Passport_Number__pc    )   ;
                            ab.caste    =   String.valueOf( c.genesis__Party_Account_Name__r.Caste__pc  )   ;
                            ab.maritalStatus    =   String.valueOf( c.genesis__Party_Account_Name__r.Marital_Status__pc )   ;
                            ab.branchCode   =   String.valueOf( c.genesis__Party_Account_Name__r.Branch_Code__c )   ;
                            ab.isPhyHandicap    =   String.valueOf( c.genesis__Party_Account_Name__r.Is_Physically_Handicapped__c   )   ;
                            ab.isExserviceMan   =   String.valueOf( c.genesis__Party_Account_Name__r.Is_Ex_Service_Man__c   )   ;
                            ab.religion =   String.valueOf( c.genesis__Party_Account_Name__r.Religion__c    )   ;
                            ab.eduQualification =   String.valueOf( c.genesis__Party_Account_Name__r.Education_Qualification__pc    )   ;
                            ab.isAppRelatedBankDir  =   String.valueOf( c.genesis__Party_Account_Name__r.Is_Applicant_Related_To_Bank_Directors__c  )   ;
                            ab.nameBankRelated  =   String.valueOf( c.genesis__Party_Account_Name__r.Name_Of_Bank_Related_To__c )   ;
                            ab.nameDirRelated   =   String.valueOf( c.genesis__Party_Account_Name__r.Name_Of_Director_Related_To__c )   ;
                            ab.Are_you_an_existing_customer =   String.valueOf( c.Is_Existing_Customer__c    )   ;
                            ab.Customer_since   =   String.valueOf( c.genesis__Party_Account_Name__r.CUSTSINCE__c   )   ;
                            ab.Customer_ID  =   String.valueOf( c.genesis__Party_Account_Name__r.CBS_Customer_ID__c )   ;
                            ab.Aadhaar_No   =   String.valueOf( c.genesis__Party_Account_Name__r.Aadhaar_Number__pc )   ;
                            ab.account_No   =   String.valueOf( c.genesis__Party_Account_Name__r.ints__Bank_Account_Number__pc) ;
                            ab.PAN_No   =   String.valueOf( c.genesis__Party_Account_Name__r.Pan_Number__c  )   ;
                            ab.Mobile_Number    =   String.valueOf( c.genesis__Party_Account_Name__r.PersonMobilePhone  )   ;
                            ab.E_mail   =   String.valueOf( c.genesis__Party_Account_Name__r.PersonEmail    )   ;
                            ab.Reason_for_not_having_PAN_card   =   String.valueOf( c.genesis__Party_Account_Name__r.Reason_For_Not_Having_PAN_Card__c  )   ;
                            ab.First_Name   =   String.valueOf( c.genesis__Party_Account_Name__r.FirstName  )   ;
                            ab.Last_Name    =   String.valueOf( c.genesis__Party_Account_Name__r.LastName   )   ;
                            ab.Middle_Name  =   String.valueOf( c.genesis__Party_Account_Name__r.MiddleName )   ;
                            ab.DOB  =   String.valueOf( c.genesis__Party_Account_Name__r.PersonBirthdate    )   ;
                            ab.Fathers_Name =   String.valueOf( c.genesis__Party_Account_Name__r.Father_Name__pc    )   ;
                            ab.Husbands_Name    =   String.valueOf( c.genesis__Party_Account_Name__r.Husband_Name__pc   )   ;
                            ab.permanentAddress1    =   String.valueOf( c.genesis__Party_Account_Name__r.PersonOtherStreet  )   ;
                            ab.permanentCity    =   String.valueOf( c.genesis__Party_Account_Name__r.PersonOtherCity    )   ;
                            ab.permanentState   =   String.valueOf( c.genesis__Party_Account_Name__r.PersonOtherState   )   ;
                            ab.permanentCountry =   String.valueOf( c.genesis__Party_Account_Name__r.PersonOtherCountry )   ;
                            ab.permanentZip =   String.valueOf( c.genesis__Party_Account_Name__r.PersonOtherPostalCode  )   ;
                            ab.Nationality  =   String.valueOf( c.genesis__Party_Account_Name__r.Nationality__pc    )   ;
                            ab.Resdential_status    =   String.valueOf( c.genesis__Party_Account_Name__r.Residential_Status__pc )   ;
                            ab.Do_you_have_any_assets   =   String.valueOf( c.genesis__Party_Account_Name__r.Do_You_Have_Any_Assets__c  )   ;
                            ab.Immovable_assets =   String.valueOf( c.genesis__Party_Account_Name__r.Immovable_Assets__c    )   ;
                            ab.Other_assets =   String.valueOf( c.genesis__Party_Account_Name__r.Other_Assets__c    )   ;
                            ab.Employment_type  =   String.valueOf( c.Employment_Types__c )   ;
                            ab.Cust_Type    =   String.valueOf( c.genesis__Party_Account_Name__r.Type__c    )   ;
                            ab.Experience   =   String.valueOf( c.genesis__Party_Account_Name__r.Experience__c  )   ;
                            ab.Company_name =   String.valueOf( c.genesis__Party_Account_Name__r.Company_Name__c    )   ;
                            ab.Company_address  =   String.valueOf( c.genesis__Party_Account_Name__r.Holding_Comp_Address__c    )   ;
                            ab.Net_monthly_income   =   String.valueOf( c.Net_Monthly_Income__c);
                            ab.Mode_of_bank_statement_verification  =   String.valueOf( c.genesis__Party_Account_Name__r.Mode_Of_Bank_Statement_Verification__c )   ;
                            ab.Mode_of_ITR_verification =   String.valueOf( c.genesis__Party_Account_Name__r.Mode_Of_ITR_Verification__c    )   ;
                            ab.CBSAccNo1                    = c.genesis__Party_Account_Name__r.CBS_Account_No_1__c;
                            ab.CBSAccNo2                    = c.genesis__Party_Account_Name__r.CBS_Account_No_2__c;
                            ab.CBSAccNo3                    = c.genesis__Party_Account_Name__r.CBS_Account_No_3__c;
                            ab.CBSAccNo4                    = c.genesis__Party_Account_Name__r.CBS_Account_No_4__c;
                            ab.CBSAccNo5                    = c.genesis__Party_Account_Name__r.CBS_Account_No_5__c;
                            ab.AccountId                    =c.genesis__Party_Account_Name__r.id;
                            ab.Full_Name                    =c.genesis__Party_Account_Name__r.Full_Name__c;
                            ab.Is_Bank_Statement_required   =String.ValueOf(c.Is_Bank_Statement_required__c);
                            ab.isKyc                     = string.valueOf(c.IsKYC__c);  // V1.2
                            ab.Mothers_Name             =c.genesis__Party_Account_Name__r.Mother_s_Maiden_Name__pc;
                            
                            // Re model data start
                            ab.Additional_income             =   String.valueOf(c.Additional_Income__c);
                            ab.Source_of_income1             =   String.valueOf(c.Source_of_Income1__c);
                            ab.Additional_income_amount1     =   String.valueOf(c.Additional_Income_Amount1__c);
                            ab.Source_of_income2             =   String.valueOf(c.Source_Of_Income2__c);
                            ab.Additional_income_amount2     =   String.valueOf(c.Additional_Income_Amount2__c);
                            ab.Source_of_income3             =   String.valueOf(c.Source_Of_Income3__c);
                            ab.Additional_income_amount3     =   String.valueOf(c.Additional_Income_Amount3__c);
                            ab.Source_of_income4             =   String.valueOf(c.Source_Of_Income4__c);
                            ab.Additional_income_amount4     =   String.valueOf(c.Additional_Income_Amount4__c);
                            ab.Source_of_income5             =   String.valueOf(c.Source_Of_Income5__c);
                            ab.Additional_income_amount5     =   String.valueOf(c.Additional_Income_Amount5__c);
                            ab.Applicant_Type                =   c.genesis__Party_Type__c == Null  ? Constants.PRIMARY_APP : String.valueOf(c.genesis__Party_Type__c);
                            ab.IsFinancial                   =   String.valueOf(c.Financial_Applicant__c);
                            ab.CurrentAddAsPermanentAddress  =   string.valueOf(c.Same_Present_Address_Permanent_Address__c);
                            ab.EmploymentSubType             =   string.valueOf(c.Employment_SubType__c);
                            ab.ExisitingEMI_Claimed          =   string.valueOf(c.Exisiting_EMIs_Claimed_by_Customer__c);
                            ab.AddressFrmCBS                 =   c.genesis__Party_Account_Name__r.Present_address_from_CBS__c;
                            ab.Gross_Income_1                =   string.valueOf(c.Gross_Income1__c);
                            ab.Capital_Gains_1               =   string.valueOf(c.Annual_Capital_Gain1__c);
                            ab.Interest_income_1             =   string.valueOf(c.Interest_Income1__c);
                            ab.Dividend_income_1             =   string.valueOf(c.Dividend_Income1__c);
                            ab.Tax_1                         =   string.valueOf(c.Annual_Tax1__c);
                            ab.Gross_Income_2                =   string.valueOf(c.Gross_Income2__c);
                            ab.Capital_Gains_2               =   string.valueOf(c.Annual_Capital_Gain2__c);
                            ab.Interest_income_2             =   string.valueOf(c.Interest_Income2__c);
                            ab.Dividend_income_2             =   string.valueOf(c.Dividend_Income2__c);
                            ab.Tax_2                         =   string.valueOf(c.Annual_Tax2__c);
                            ab.Gross_Income_3                =   string.valueOf(c.Gross_Income3__c);
                            ab.Capital_Gains_3               =   string.valueOf(c.Annual_Capital_Gain3__c);
                            ab.Interest_income_3             =   string.valueOf(c.Interest_income3__c);
                            ab.Dividend_income_3             =   string.valueOf(c.Dividend_income3__c);
                            ab.Tax_3                         =   string.valueOf(c.Annual_Tax3__c);
                            ab.Month_1_Income                =   string.valueOf(c.Salary_Credited_1__c);
                            ab.Month_2_Income                =   string.valueOf(c.Salary_Credited_2__c);
                            ab.Month_3_Income                =   string.valueOf(c.Salary_Credited_3__c);
                            ab.Month_4_Income                =   string.valueOf(c.Salary_Credited_4__c);
                            ab.Month_5_Income                =   string.valueOf(c.Salary_Credited_5__c);
                            ab.Month_6_Income                =   string.valueOf(c.Salary_Credited_6__c);
                            ab.Amount_Paid                   =   string.valueOf(c.Amount_Paid__c);
                            ab.MinNMI                        =   string.valueOf(c.MinNMI__c);
                            ab.Tax                           =   string.valueOf(c.Tax_Deducted__c);
                            ab.Agriculture_Income_itr1       =   string.valueOf(c.Agriculture_ITR1__c);
                            ab.Agriculture_Income_itr2       =   string.valueOf(c.Agriculture_ITR2__c);
                            ab.Agriculture_Income_itr3       =   string.valueOf(c.Agriculture_ITR3__c);
                            ab.Share_of_Profit_itr_yr1       =   string.valueOf(c.Share_of_Profit_1__c);
                            ab.Share_of_Profit_itr_yr2       =   string.valueOf(c.Share_of_Profit_2__c);
                            ab.Share_of_Profit_itr_yr3       =   string.valueOf(c.Share_of_Profit_3__c);
                            ab.company_pincode               =   c.genesis__Party_Account_Name__r.Company_Pincode__c;
                            ab.Company_City                  =   c.genesis__Party_Account_Name__r.Company_City__c;
                            ab.Company_State                 =   c.genesis__Party_Account_Name__r.Company_State__c;
                            ab.Is_ITR_required               =   String.ValueOf(c.Is_ITR_required__c);
                            ab.IncomeComputationForm         =   String.valueOf(c.Income_Computation_From__c);
                           
                            ab.PerfiosUsed         =   String.valueOf(c.Perfios_Captured__c); // V1.1

                            //title holder changes on 3-12-2018
                            if(appl.Record_Type_Name__c==Constants.VL2W || appl.Record_Type_Name__c==Constants.VL4W||appl.Record_Type_Name__c==constants.HOMELOAN ){

                                ab.party_TitleHolder    =   string.valueOf(c.Title_Holder__c);
                            }
                            //title holder ends..

                            
                            //vehicle Loan start---------Niladri Done------------------------------------------------
                            ab.PrimaryBank         =   c.Primary_Bank__c;
                            ab.primaryBankAccNo         =   c.Bank_Account_Number__c;
                            ab.PrimaryBranch         =   c.Primary_Bank_Branch__c;  
                            ab.IfscCode         =   String.ValueOf(c.IFSC_code__c);

                            //vehicle Loan end--------------------------------------------------------------------------
                            ab.Official_Email = c.Official_Email_ID__c;
                         }

                         for(genesis__Application_Parties__c PT : PTList){
                            if(c.genesis__Party_Account_Name__r.Id == PT.genesis__Party_Account_Name__r.Id){
                                company com = new company();
                                com.FirmId = PT.Key_Contact__r.Id;
                                com.Business_Customer_ID = PT.Key_Contact__r.CBS_Customer_ID__c;
                                com.Firm_Address = PT.Key_Contact__r.BillingStreet;
                                com.Firm_Name = PT.Key_Contact__r.Name;
                                com.Firm_PAN = PT.Key_Contact__r.Pan_Number__c;
                                com.Relationship_with_Firm = PT.Key_Contact__r.Relationship_with_Firm__c;
                                com.Firm_Pincode = PT.Key_Contact__r.BillingPostalCode;
                                com.Firm_Type = PT.Key_Contact__r.Firm_type__c;
                                com.Firm_State = PT.Key_Contact__r.BillingState;
                                com.Firm_City = PT.Key_Contact__r.BillingCity;
                                ab.Company.add(com);
                            }
                        }
                        res.application.ACCTDETAILS.add(ab);
                    }
                    res.application.Collateral = new List<cls_Collateral>();
                    System.debug(CollateralList.size()+'<<<CollateralList>>>'+CollateralList);
                    for(clcommon__Collateral__c col : CollateralList){
                        cls_Collateral cl = new cls_Collateral();
                        cl.CollateralId       = col.Id;
                        cl.Collateral_Address = col.clcommon__Address__c;
                        cl.Collateral_City = col.clcommon__City__c;
                        cl.Collateral_Market_Value = String.ValueOf(col.Collateral_Market_Value__c);
                        cl.Collateral_PinCode = col.clcommon__Postal_Code__c;
                        cl.Collateral_State = col.State__c;
                        cl.Collateral_Type = col.Collateral_Type__c;
                        cl.Collateral_Use = col.Collateral_Uses__c;
                        cl.EM_Charge_Type = col.EM_Charge_Types__c;
                        cl.No_of_Tenants = col.No_of_tenants__c;
                        cl.Vacant_Land_area = String.ValueOf(col.Vacant_Land_area__c);
                        cl.Title_Holder = new List<cls_Title_Holder>();
                           
                        //vechicle Loan - Start-----------------------------------------------------------------------------
                        cl.ManufacturerName = col.clcommon__Manufacturer__c;
                        cl.ManufactureYear = col.clcommon__Year__c;
                        cl.Model = col.clcommon__Model__c;
                        cl.Variant = col.Variant__c;
                        cl.DealerName = col.Dealer_name__c;
                        cl.DealerEmail = col.Dealer_Email__c;
                        cl.DealerPincode = String.ValueOf(col.Dealer_Pincode__c);
                        cl.DealerPhone = String.ValueOf(col.Dealer_Phone_Number__c);
                        cl.ExShowRoomPrice = String.ValueOf(col.ExShow_Room_Price__c);
                        cl.RegistrationCost = String.ValueOf(col.Registration_cost__c);
                        cl.InsuranceAmount = String.ValueOf(col.clcommon__Insurance_Amount__c);
                        cl.AccessoriesValue = String.ValueOf(col.Accessories_value__c);
                        cl.TotalVehicleValue = String.ValueOf(col.Total_Vehicle_Value__c);
                        cl.FinalVehicleValue = String.ValueOf(col.Final_vehicle_value__c);
                        cl.AdvancesPaid = String.ValueOf(col.Advances_Paid__c);
                        cl.ProformaInvoiceNo = String.ValueOf(col.Proforma_Invoice_No__c);
                        cl.ProformaInvoiceDate = String.ValueOf(col.Proforma_Invoice_Date__c);
                        cl.ExshowroomPrice_Apg=String.ValueOf(col.ExshowRoomPrice_Api__c);
                        cl.VLCalculatedValue = String.valueOf(col.Vehicle_CalculatedValue__c);
                        cl.ManualDealer = String.valueOf(col.Manual_Dealer__c);
                        cl.SchemeType = String.valueOf(col.Scheme_Type__c);
                        cl.Ref_by_Dealer = String.valueOf(col.Reff_by_Dealer__c);
                        cl.ManufactureMonth = String.valueOf(col.Month__c);
                         //vehicle Loan -end---------------------------------------------------------------------------------

                        for(Ownership__c own : col.Ownerships__r){
                            cls_Title_Holder th = new cls_Title_Holder();
                            th.ApplicantId = own.Account__r.Id;
                            th.ApplicantName = own.Account__r.Name;
                            cl.Title_Holder.add(th);
                        }
                        res.application.Collateral.add(cl);
                    }
                    // for App Document Category
                    List<genesis__Application_Document_Category__c> DocList = queryService.getappDocument(appId);
                    res.application.ApplicationDocCategoryDetails = new list<AppDocCategory>();
                    for(genesis__Application_Document_Category__c Adc : DocList){
                        AppDocCategory ad =new AppDocCategory();
                        ad.FolderName=Adc.Name;
                        ad.FolderID=Adc.ID;
                        ad.ApplicantID = Adc.Applicant__c;
                     List<String> MultidocList = System.Label.MultipleDocumentFolderList.split(',');
                    if(MultidocList != null){
                      if(MultidocList.contains(Adc.Name)){
                            ad.MultiDocCheckList=true;
                          }
                      else{
                            ad.MultiDocCheckList=false;     
                          }
                       }
                        ad.Uplodedfile = new List<Uplodedfile>();
                        for(genesis__AppDocCatAttachmentJunction__c appdoc : Adc.genesis__AppDocCatAttachmentJunctions__r){
                            Uplodedfile up = new Uplodedfile();
                            up.FileName = appdoc.Document_Name__c;
                            up.UuID=appdoc.Dms_Uuid__c;
                            ad.Uplodedfile.add(up);
                        }
                        res.application.ApplicationDocCategoryDetails.add(ad);
                    }
                    
                    res.application.GmraDetails=new list<GmraWrapper>();
                    // for GMRA
                    for(GMRA__c GMR:appl.GMRA__r){
                        GmraWrapper GMW =new GmraWrapper();
                        GMW.GMRA_Name=GMR.Name;
                        GMW.Amount=String.valueOf(GMR.Amount__c);
                        res.application.GmraDetails.add(GMW);
                    }

                    //added by prashant singh on 16-11-2018
                    if(appl.Record_Type_Name__c==constants.HOMELOAN && CollateralList!=null && CollateralList.size()>0)
                    {
                        res.application.Property_type = String.ValueOf(CollateralList[0].clcommon__Property_Type__c);
                        res.application.Cost_of_land = String.ValueOf(CollateralList[0].Cost_Of_Land__c);
                        res.application.Cost_of_repair = String.ValueOf(CollateralList[0].Cost_Of_Repair__c);
                        res.application.Property_Address1 = String.ValueOf(CollateralList[0].Property_Address__c);
                        res.application.Property_State = CollateralList[0].State__c;
                        res.application.Property_City = String.valueOf(CollateralList[0].clcommon__City__c);
                        res.application.Property_Pincode = String.valueOf(CollateralList[0].Property_Pincode__c);
                        res.application.Whether_Construction_Completed=String.valueOf(CollateralList[0].Whether_The_Construction_Completed__c);
                        res.application.Cost_of_construction = String.valueOf(CollateralList[0].Cost_Of_Construction__c);
                        res.application.Purchase_cost_of_property=String.valueOf(CollateralList[0].Cost_Of_Flat_House__c);
                        res.application.BuildingAge = string.valueOf(CollateralList[0].Age_Of_The_Building__c);
                        res.application.Flat = String.ValueOf(CollateralList[0].Flat_Door_Shop_Bungalow_Nos__c);
                        //res.application.Builder_name = CollateralList[0].Builder_Present_Owner_Seller_Name__c;
                        res.application.Project_name = CollateralList[0].Builder_Present_Owner_Seller_Name__c;

                        //v1.4(start)
                        res.application.Total_cost_incurred_till_date = String.valueOf(CollateralList[0].Total_cost_incurred_till_date__c);
                        res.application.Cost_incurred_in_the_last_6_months = String.valueOf(CollateralList[0].Cost_incurred_in_the_last_6_months__c);
                        //v1.4(end)
                    }
                    //prashant singh ends

                    //v1.4(start)
                    if(appl.Record_Type_Name__c==constants.HOMELOAN && facilityList!=null && facilityList.size()>0 && (appl.Sub_Stage__c == Constants.AppCreated || appl.Sub_Stage__c == Constants.Sub_Stage_HL_Selected || appl.Sub_Stage__c == Constants.Sub_Stage_Parties_Verified || appl.Sub_Stage__c == Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE || appl.Sub_Stage__c == Constants.Sub_Stage_PropInfoCaptured)){
                        res.application.HL_Facility = new List<cls_Facility>();
                        for(Facility__c fc:facilityList){
                            cls_Facility ft = new cls_Facility();
                            ft.Takeover_Bank_Name = String.ValueOf(fc.Bank_Name__c);
                            ft.Takeover_Outstanding_Loan_Amount = String.ValueOf(fc.Takeover_Outstanding_Loan_Amount__c);
                            ft.Takeover_Outstanding_Loan_Tenure_months = String.ValueOf(fc.Takeover_Outstanding_Loan_Tenure_months__c);
                            ft.Takeover_Loans_EMI = String.ValueOf(fc.Takeover_Loans_EMI__c);
                            ft.Existing_HL_Loan_Account_No = String.ValueOf(fc.Existing_HL_Loan_Account_No__c);
                            ft.Existing_HL_Sanctioned_Amount = String.ValueOf(fc.Existing_HL_Sanctioned_Amount__c);
                            ft.Existing_HL_Disbursed_Amount = String.ValueOf(fc.Existing_HL_Disbursed_Amount__c);
                            ft.Existing_HL_Oustanding_Balance = String.ValueOf(fc.Existing_HL_Oustanding_Balance__c);
                            ft.Existing_HL_Party1_Name = String.ValueOf(fc.Existing_HL_Party1_Name__c);
                            ft.Existing_HL_Party1_Type = String.ValueOf(fc.Existing_HL_Party1_Type__c);
                            ft.Existing_HL_Party1_Cust_ID = String.ValueOf(fc.Existing_HL_Party1_Cust_ID__c);
                            ft.Existing_HL_Party2_Name = String.ValueOf(fc.Existing_HL_Party2_Name__c);
                            ft.Existing_HL_Party2_Type = String.ValueOf(fc.Existing_HL_Party2_Type__c);
                            ft.Existing_HL_Party2_Cust_ID = String.ValueOf(fc.Existing_HL_Party2_Cust_ID__c);
                            ft.Existing_HL_Party3_Name = String.ValueOf(fc.Existing_HL_Party3_Name__c);
                            ft.Existing_HL_Party3_Type = String.ValueOf(fc.Existing_HL_Party3_Type__c);
                            ft.Existing_HL_Party3_Cust_ID = String.ValueOf(fc.Existing_HL_Party3_Cust_ID__c);
                            ft.Existing_HL_Party4_Name = String.ValueOf(fc.Existing_HL_Party4_Name__c);
                            ft.Existing_HL_Party4_Type = String.ValueOf(fc.Existing_HL_Party4_Type__c);
                            ft.Existing_HL_Party4_Cust_ID = String.ValueOf(fc.Existing_HL_Party4_Cust_ID__c);
                            ft.Existing_HL_Party5_Name = String.ValueOf(fc.Existing_HL_Party5_Name__c);
                            ft.Existing_HL_Party5_Type = String.ValueOf(fc.Existing_HL_Party5_Type__c);
                            ft.Existing_HL_Party5_Cust_ID = String.ValueOf(fc.Existing_HL_Party5_Cust_ID__c);
                            ft.Existing_HL_Party6_Name = String.ValueOf(fc.Existing_HL_Party6_Name__c);
                            ft.Existing_HL_Party6_Type = String.ValueOf(fc.Existing_HL_Party6_Type__c);
                            ft.Existing_HL_Party6_Cust_ID = String.ValueOf(fc.Existing_HL_Party6_Cust_ID__c);
                            ft.Selected_for_Top_Up = String.ValueOf(fc.Selected_for_Top_Up__c);
                            ft.Existing_HL_SMA_Status = String.ValueOf(fc.Existing_HL_SMA_Status__c);
                            ft.Existing_HL_1st_EMI_Date = String.ValueOf(fc.Existing_HL_1st_EMI_Date__c);
                            ft.Existing_HL_Outstanding_Tenure = String.ValueOf(fc.Existing_HL_Outstanding_Tenure__c);
                            ft.Existing_HL_Sanctioned_Tenure = String.ValueOf(fc.Existing_HL_Sanctioned_Tenure__c);
                            ft.Active = String.ValueOf(fc.Active__c);
                            ft.FacilityId = String.ValueOf(fc.Id);
                            res.application.HL_Facility.add(ft);
                        }
                    }
                    //v1.4(end)

                }
            res.application.ApplicationNumber=appl.Name;
            }
            else if(!Utility.ISStringBlankorNull(ApplicantID) && !Utility.ISStringBlankorNull(appId)){
                List<Perfios__c> pfs=queryService.GetBankAccounts(ApplicantID,appId);
               
                 genesis__Application_Parties__c par=queryService.PartieswithAcc(ApplicantID,appId);
                res.PerfiosDetails  = new List<PerfiosData>();
                for(Perfios__c perf:pfs){
                    PerfiosData p=new PerfiosData();
                    p.BankAccountNumber=perf.Bank_Account_Number__c;
                    p.ApplicantID=perf.Applicant_Name__c;
                    p.BankName=perf.Bank_Name__c;
                    p.RecordID=perf.id;
                    
                    //prashant singh
                    p.BSUploadType=perf.BS_UploadType__c;
                    p.status=perf.Status__c;
                    p.ErrorMessage=perf.Error_Message__c;
                    p.IsDeleted=perf.IS_DELETED__c;
                    p.UploadBankStatement=perf.Upload_Bank_Statement__c;
                    p.ITRUploaded=par.ITR_Uploaded__c;
                    System.debug('prashant');
                    res.PerfiosDetails.add(p);
                }
            }
            else if(Utility.ISStringBlankorNull(ApplicantID) && Utility.ISStringBlankorNull(appId)){
                
                res.errorMessage = 'Please pass Application or Applicant ID.';
            }            
            res.application.No_of_coapplicant_remaining = queryService.getCLProd(appId) != null ? String.valueOf(queryService.getCLProd(appId) - Decimal.valueOf(queryService.getAccCount(appId))) : '';
            System.debug('res>>> '+res);
            return  res;
            
            
        }catch(QueryException qe){
        
            DetailResponse res = new DetailResponse();
            res.statusCode      = '400';
            res.status         = 'ERROR';
            res.errorMessage   = qe.getMessage();//'No Applications Found.';
            System.debug('exception:-'+qe.getLineNumber()+'::message:-'+qe.getStackTraceString());
            return res;
        }
    }
    
}