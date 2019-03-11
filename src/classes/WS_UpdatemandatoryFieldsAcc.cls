/*
* Name    : WS_UpdatemandatoryFieldsAcc
* Company : ET Marlabs
* Purpose : This class is used to update Account with Mandatory fields from App
* Author  : Subas
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
V1.1    25-Sep-2018    Venu         #Added Perfios Captured
V1.2    28-Sep-2018    Venu         #added Aadhar Not Available scenario iskyc?! 4-10-18 Adhar removed
v1.3    11-Jan-2019    Braj         # HL MVP2:Added Facility and collateral in fetch(cbs callout) and update. Update valuation flag based on cost property and valuation date
*******************************************************************************************/
@RestResource(urlMapping='/updateMandateFields')
global with sharing class WS_UpdatemandatoryFieldsAcc {
    public cls_APPLICATION_DETAILS App_Details;
    global class Response extends WS_Response{
        //public Account acctUpdate;
        public List<OUT_MAP> GMRA_outmaps;
        public Response(){
            // acctUpdate = new Account();
            GMRA_outmaps  = new List<OUT_MAP>();
        }
    }
    
    public class OUT_MAP {
        public string GMRA_Name = '';
        public string GMRA_AMT = '';
    }
    
    public class cls_APPLICATION_DETAILS {
        public string RejectionScenario;
        public List<AcctReqWrapper> ACCTDETAILS;
        public cls_Collateral[] Collateral;
        public String ApplicationID;
        public String Purpose_of_loan;
        public String SI_Applicant;
        public String Minimum_Loan_Amount;
        public String ITRs_Filled_within_3_Months;
        public String ITR_Uploaded;
        public String Docgen_Fail;
        public String FI_Status;
        public String Error_Message_PL;
        public String Sanction_Message;
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
        public String Pmin;
        public String Is_CreditLife;
        public String Tower;
        public String Flat;
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
        public String Stage;
        public String FETransId;
        public String PGTransId;
        public String TransDateTime;
        public String TotalAmnt;
        public String PgStatus;
        public String Term;
        public String Option;
        public String BorrowerEsign;
        public String GuarantorEsign;
        public String BuildingAge;
        public string Fe_Extras;
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
        public string Additional_income;
        public string Is_take_over;
        public string Type_Of_Loan;
        public string Type_of_charge;
        public string Type_of_property;
        
        //vehicle tag - start-------------------------------------------------------------------
        public string VehicleType;
        public string MarginValue;
        public string MarginPaymentMode;
        public string MarginPaymentReference;
        //vehicle tag - End----------------------------------------------------------------------
        
        //v1.3
        public List<cls_Facility> HL_Facility;
        public string SubType;
        //Collateral
        public String Total_cost_incurred_till_date;
        public String Cost_incurred_in_the_last_6_months;
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
        public String No_Of_Tenants;    //2
        public String Vacant_Land_Area; //500
        public String Collateral_Market_Value;  //100000
        
        //vehicle tag - start ----------------------------------------------------------------------------------
        public String  ManufacturerName;
        public String  ManufactureYear;
        public String  Model;
        public String  Variant;
        public String  VariantId;
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
        public String  CityID;
        public String  ManualDealer;
        public String  SchemeType;
        public String  Ref_by_Dealer;
        public String  ManufactureMonth;
        //vehicle tag - End------------------------------------------------------------------------------------
        
        public cls_Title_Holder[] Title_Holder;
        
    }
    
    public class cls_Title_Holder {
        public String ApplicantId;  //0015D000007LYcrQAG
    }
    
    public class AcctReqWrapper {
        public String ApplicationId;
        public String AccountId;
        public String AlternativeMobile;
        public String LandLine;
        public String Company_Pincode;
        public String Company_City;
        public String Company_State;
        public String Is_ITR_Required;
        public string accountName;
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
        public string Annual_Other_Income_Recurring_Credits_IT; //For PL purpose by Ashish
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
        public String DisbursmentEsignCheck;
        public String ModEsignCheck;
        public String CBSAccNo1;
        public String CBSAccNo2;
        public String CBSAccNo3;
        public String CBSAccNo4;
        public String CBSAccNo5;
        public String IsFinancial;
        public String IncomeComputationForm;
        public string PerfiosUsed;  // V1.1
        public string party_TitleHolder;
        
        //Perfios Tags
        public String PerfiosReqId1;
        public String PerfiosReqId2;
        public String PerfiosUrl;
        public string Full_Name;
        public string CurrentAddAsPermanentAddress;
        public string EmploymentSubType;
        public string Customer_IC;
        public string ExisitingEMI_Claimed;
        public string AddressFrmCBS;
        
        //LAP details
        public String Gross_Income_1;   //73872
        public String Capital_Gains_1;  //73827
        public String Interest_income_1;    //9312829
        public String Dividend_income_1;    //723873
        public String Tax_1;    //12873
        public String Gross_Income_2;   //8373
        public String Capital_Gains_2;  //7379279
        public String Interest_income_2;    //278372
        public String Dividend_income_2;    //73262
        public String Tax_2;    //72837
        public String Gross_Income_3;   //73287
        public String Capital_Gains_3;  //7837
        public String Interest_income_3;    //7382
        public String Dividend_income_3;    //63286
        public String Tax_3;    //73287
        public String Month_1_Income;   //73872
        public String Month_2_Income;   //72872
        public String Month_3_Income;   //732872
        public String Month_4_Income;   //72387
        public String Month_5_Income;   //6237673
        public String Month_6_Income;   //7328732
        public String Amount_Paid;  //8378723
        public String MinNMI;   //83298
        public String Tax;
        public String Agriculture_Income_itr1;
        public String Agriculture_Income_itr2;
        public String Agriculture_Income_itr3;
        public String Share_of_Profit_itr_yr1;
        public String Share_of_Profit_itr_yr2;
        public String Share_of_Profit_itr_yr3;
        //vehicle start-----------------------------------------------------
        public String PrimaryBank;
        public String primaryBankAccNo;
        ////vehicle end------------------------------------------------------
        public String Mothers_Name;
        public cls_Company[] Company;
        public string Official_Email;
        public String Company_Category;
    }
    
    public class cls_Company {
        public String AccountId;
        public String FirmId;
        public String Business_Customer_ID; //12309900
        public String Firm_Name;    //Tcs
        public String Firm_Type;    //primary
        public String Relationship_with_Firm;   //AASEAR
        public String Firm_PAN; //ASDD
        public String Firm_Address; ///54 bangalore
        public String Firm_Pincode; //700075
        public String Firm_City;
        public String Firm_State;
    }
    
    //v1.3(start)
    public class cls_Facility {
        public string Takeover_Bank_Name;
        public string Takeover_Outstanding_Loan_Amount;
        public string Takeover_Outstanding_Loan_Tenure_months;
        public string Takeover_Loans_EMI;
        public string Selected_for_Top_Up;
        public string Existing_HL_Loan_Account_No;
        public string Existing_HL_SMA_Status;
        public string Active;
        public string FacilityId;
    }
    //v1.3(end)
    
    @HttpPost 
    global static Response getMandateFields(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;
        }else{
            try{
                String jsonData  = req.requestBody.toString();
                system.debug('jsonData:::'+jsonData);
                cls_APPLICATION_DETAILS reqApp  = (cls_APPLICATION_DETAILS)Json.deserialize(jsonData, cls_APPLICATION_DETAILS.class);
                List<Account> listAccount = new List<Account>();
                genesis__Applications__c application = new genesis__Applications__c();
                Map<String,Account> dupeCheck = new Map<String,Account>();
                Set<String> uniqueBacc = new Set<String>();
                Map<String,List<Account>> baccListMap = new Map<String,List<Account>>();
                //List<clcommon__Collateral__c> colList = new List<clcommon__Collateral__c>();
                system.debug('%%%%%%%'+reqApp.ApplicationID);
                if(!String.isBlank(reqApp.ApplicationID)){
                    application.Id = reqApp.ApplicationID;
                }
                if(!String.isBlank(reqApp.Purpose_of_loan)){
                    application.Loan_Purpose__c = reqApp.Purpose_of_loan;
                }
                if(!String.isBlank(reqApp.SI_Applicant)){
                    application.SI_Applicant__c = reqApp.SI_Applicant;
                }
                if(!String.isBlank(reqApp.Minimum_Loan_Amount)){
                    application.Minimum_Loan_Amount__c = Decimal.valueOf(reqApp.Minimum_Loan_Amount);
                }
                if(!String.isBlank(reqApp.ITRs_Filled_within_3_Months)){
                    application.ITRs_Filled_within_3_Months__c = Boolean.valueOf(reqApp.ITRs_Filled_within_3_Months);
                }
                
                if(!String.isBlank(reqApp.ITR_Uploaded)){
                    application.ITR_Uploaded__c = Boolean.valueOf(reqApp.ITR_Uploaded);
                }
                if(!String.isBlank(reqApp.Docgen_Fail)){
                    application.Docgen_Fail__c = Boolean.valueOf(reqApp.Docgen_Fail);
                }
                if(!String.isBlank(reqApp.FI_Status)){
                    application.FI_Status__C = reqApp.FI_Status;
                }
                if(!String.isBlank(reqApp.Error_Message_PL)){
                    application.Error_Message_PL__c = reqApp.Error_Message_PL;
                }
                if(!String.isBlank(reqApp.Sanction_Message)){
                    application.Sanction_Message__c = reqApp.Sanction_Message;
                }
                if(!String.isBlank(reqApp.Loan_start_date_of_existing_home_loan)){
                    application.Loan_Start_Date_Of_Existing_Home_Loan__c = date.ValueOf(reqApp.Loan_start_date_of_existing_home_loan);
                }
                if(!String.isBlank(reqApp.Project_code)){
                    application.Project_Code__c = reqApp.Project_code;
                }
                if(!String.isBlank(reqApp.Pmin)){
                    application.PMin__c = Decimal.ValueOf(reqApp.Pmin);
                }
                if(!String.isBlank(reqApp.Is_CreditLife)){
                    application.Is_CreditLife__c = Boolean.ValueOf(reqApp.Is_CreditLife);
                }
                if(!String.isBlank(reqApp.Total_repayment_amount)){
                    application.Total_Repayment_Amount__c = decimal.ValueOf(reqApp.Total_repayment_amount);
                }
                if(!String.isBlank(reqApp.EMI)){
                    application.genesis__Payment_Amount__c = decimal.ValueOf(reqApp.EMI);
                }
                if(!String.isBlank(reqApp.Interest)){
                    application.genesis__Interest_Rate__c = decimal.ValueOf(reqApp.Interest);
                }
                if(!String.isBlank(reqApp.Loan_required_amount)){
                    application.genesis__Loan_Amount__c = decimal.ValueOf(reqApp.Loan_required_amount);
                }
                if(!String.isBlank(reqApp.Required_loan_tenure)){
                    application.genesis__Term__c = Integer.ValueOf(reqApp.Required_loan_tenure);
                }
                if(!String.isBlank(reqApp.Holiday_period)){
                    application.Holiday_Period__c = decimal.ValueOf(reqApp.Holiday_period);
                }
                if(!String.isBlank(reqApp.GMRA_policy_is_selected)){
                    application.Is_GMRA_Policy_Selected__c = Boolean.valueOf(reqApp.GMRA_policy_is_selected);
                }
                if(!String.isBlank(reqApp.Is_GMRA_policy_added_to_loan_amount)){
                    application.Is_GMRA_Policy_Added_To_Loan_Amount__c = Boolean.valueOf(reqApp.Is_GMRA_policy_added_to_loan_amount);
                }
                if(!String.isBlank(reqApp.Branch_code)){
                    application.Branch_Code__c = reqApp.Branch_code;
                }
                if(!String.isBlank(reqApp.Branch_name)){
                    application.Branch_Name__c = reqApp.Branch_name;
                }
                if(!String.isBlank(reqApp.Is_loan_processing_fee_paid)){
                    application.Is_Loan_processing_Fee_Paid__c = reqApp.Is_loan_processing_fee_paid;
                }
                if(!String.isBlank(reqApp.Documents_uploaded)){
                    application.Documents_Uploaded__c = Boolean.valueOf(reqApp.Documents_uploaded);
                }
                if(!String.isBlank(reqApp.Sourced_by)){
                    application.Sourced_By__c = reqApp.Sourced_by;
                }
                if(!String.isBlank(reqApp.Sourced_By_Office)){
                    application.Sourced_By_Office__c = reqApp.Sourced_By_Office;
                }
                if(!String.isBlank(reqApp.Stage)){
                    application.Sub_Stage__c = reqApp.Stage;
                }
                if(!String.isBlank(reqApp.SubType)){
                    application.Sub_Type__c = reqApp.SubType;//v1.3
                }
                if(!String.isBlank(reqApp.Term)){
                    application.genesis__Term__c = Integer.valueOf(reqApp.Term);
                }
                if(!String.isBlank(reqApp.Option)){
                    application.GMRA_Option__c = String.valueOf(reqApp.Option);
                }
                if(!String.isBlank(reqApp.BorrowerEsign)){
                    application.Borrowers_Esign__c = Boolean.valueOf(reqApp.BorrowerEsign);
                }
                if(!String.isBlank(reqApp.guarantorEsign)){
                    application.Guarantor_Esign_Check__c = Boolean.valueOf(reqApp.guarantorEsign);
                }
                if(!String.isBlank(reqApp.Fe_Extras)){
                    application.FE_Extra__c = String.valueOf(reqApp.Fe_Extras);
                }
                if(!String.isBlank(reqApp.Branch_city)){
                    application.Branch_City__c = String.valueOf(reqApp.Branch_city);
                }
                if(!String.isBlank(reqApp.Branch_State)){
                    application.Branch_State__c = String.valueOf(reqApp.Branch_State);
                }
                
                //SI account information  PL
                if(!String.isBlank(reqApp.SI_Account_Number)){
                    application.SI_Account_Number__c = reqApp.SI_Account_Number;
                }
                if(!String.isBlank(reqApp.SI_Bank_Name)){
                    application.SI_Bank_Name__c = String.valueOf(reqApp.SI_Bank_Name);
                }
                if(!String.isBlank(reqApp.SI_Branch_Name)){
                    application.SI_Branch_Name__c = String.valueOf(reqApp.SI_Branch_Name);
                }
                if(!String.isBlank(reqApp.SI_IFSC_Code)){
                    application.SI_IFSC_Code__c = String.valueOf(reqApp.SI_IFSC_Code);
                }
                if(!String.isBlank(reqApp.Disbursement_Account_Bank_Name)){
                    application.Disbursement_Account_Bank_Name__c = String.valueOf(reqApp.Disbursement_Account_Bank_Name);
                }
                if(!String.isBlank(reqApp.Disbursement_Account_Branch_Name)){
                    application.Disbursement_Account_Branch_Name__c = String.valueOf(reqApp.Disbursement_Account_Branch_Name);
                }
                if(!String.isBlank(reqApp.Disbursement_Account_IFSC_Code)){
                    application.Disbursement_Account_IFSC_Code__c = String.valueOf(reqApp.Disbursement_Account_IFSC_Code);
                }
                if(!String.isBlank(reqApp.Disbursement_Account_Number)){
                    application.Disbursement_Account_Number__c = reqApp.Disbursement_Account_Number;
                }
                //SI and disbursement account info ends here PL
                if(!String.isBlank(reqApp.GMRA_Selected_Option)){
                    application.GMRA_Option__c = String.valueOf(reqApp.GMRA_Selected_Option);
                }
                if(!String.isBlank(reqApp.GMRA_Amount)){
                    application.GMRA_Amount__c = Integer.valueOf(reqApp.GMRA_Amount);
                }
                if(!String.isBlank(reqApp.Branch_State_Id)){
                    application.Branch_State_Id__c = string.valueOf(reqApp.Branch_State_Id);
                }
                if(!String.isBlank(reqApp.Branch_city_Id)){
                    application.Branch_City_Id__c = String.valueOf(reqApp.Branch_city_Id);
                }
                if(!String.isBlank(reqApp.Holiday_PeriodMax)){
                    application.Holiday_Max__c = Decimal.valueOf(reqApp.Holiday_PeriodMax);
                }
                if(!String.isBlank(reqApp.Additional_income)){
                    application.Additional_Income_Approval__c = Boolean.valueOf(reqApp.Additional_income);
                }
                if(!String.isBlank(reqApp.Is_take_over)){
                    application.Is_Take_Over__c = Boolean.valueOf(reqApp.Is_take_over);
                }
                if(!String.isBlank(reqApp.Type_Of_Loan)){
                    application.Type_Of_Loan__c = String.valueOf(reqApp.Type_Of_Loan);
                }
                if(!String.isBlank(reqApp.Type_of_charge)){
                    application.Type_Of_Charge__c = String.valueOf(reqApp.Type_of_charge);
                }
                if(!String.isBlank(reqApp.Type_of_property)){
                    application.Type_of_Property__c = String.valueOf(reqApp.Type_of_property);
                }
                //closure reason changes
                if(!String.isBlank(reqApp.RejectionScenario)){
                    application.genesis__Terms_Selected__c=string.valueof(reqApp.RejectionScenario);
                }

                //v1.3(start)
                if (reqApp.HL_Facility!=null && reqApp.HL_Facility.size() > 0 && (reqApp.Stage == Constants.Sub_Stage_HL_Selected || reqApp.Stage == Constants.Sub_Stage_PropInfoCaptured)){
                    List<Facility__c> facilitiesToUpdate = new List<Facility__c>();
                    List<Facility__c> facilityList = new List<Facility__c>();
                    if (reqApp.HL_Facility[0].FacilityId != null && reqApp.HL_Facility[0].FacilityId != '')
                        facilityList = [Select Id,Name,Application__c,Existing_HL_Loan_Account_No__c,Existing_HL_Sanctioned_Amount__c,Existing_HL_Disbursed_Amount__c,Existing_HL_SMA_Status__c,Existing_HL_1st_EMI_Date__c from Facility__c where Id=:reqApp.HL_Facility[0].FacilityId];
                    else {
                        facilityList = [Select Id,Name,Application__c,Existing_HL_Loan_Account_No__c,Existing_HL_Sanctioned_Amount__c,Existing_HL_Disbursed_Amount__c,Existing_HL_SMA_Status__c,Existing_HL_1st_EMI_Date__c from Facility__c where Application__c=:reqApp.ApplicationID ];
                    }
                    
                    if(reqApp.SubType == Constants.Sub_Type_Take_Over && reqApp.Stage == Constants.Sub_Stage_PropInfoCaptured){
                            
                        for(cls_Facility reqFacility : reqApp.HL_Facility){
                            Facility__c ft = new Facility__c();
                            if(!Utility.ISStringBlankorNull(reqFacility.Takeover_Bank_Name))
                                ft.Bank_Name__c = reqFacility.Takeover_Bank_Name;
                            if(!Utility.ISStringBlankorNull(reqFacility.Takeover_Outstanding_Loan_Amount))
                                ft.Takeover_Outstanding_Loan_Amount__c = Decimal.Valueof(reqFacility.Takeover_Outstanding_Loan_Amount);
                            if(!Utility.ISStringBlankorNull(reqFacility.Takeover_Outstanding_Loan_Tenure_months))
                                ft.Takeover_Outstanding_Loan_Tenure_months__c = Decimal.Valueof(reqFacility.Takeover_Outstanding_Loan_Tenure_months);
                            if(!Utility.ISStringBlankorNull(reqFacility.Takeover_Loans_EMI))
                                ft.Takeover_Loans_EMI__c = Decimal.Valueof(reqFacility.Takeover_Loans_EMI);
                            ft.Selected_for_Top_Up__c = true;
                            
                            facilitiesToUpdate.add(ft);
                        }
                        if (facilityList.size() > 0) {
                            facilitiesToUpdate[0].Id = facilityList[0].Id;
                            update facilitiesToUpdate;
                         } else {
                            Id FacRecType=Schema.getGlobalDescribe().get('Facility__c').getDescribe().getRecordTypeInfosByName().get('HL Facility').getRecordTypeId();
                            facilitiesToUpdate[0].RecordTypeId=FacRecType;
                            facilitiesToUpdate[0].Application__c = reqApp.ApplicationID;
                            insert facilitiesToUpdate;
                         }
                    } else if(reqApp.SubType == Constants.Sub_Type_Top_Up && reqApp.Stage == Constants.Sub_Stage_HL_Selected){
                        if (facilityList.size() > 0) {
                            if(facilityList[0].Existing_HL_SMA_Status__c){
                                application.genesis__Terms_Selected__c='SMA';
                            }
                            else if(system.today().addyears(-2)<date.valueOf(facilityList[0].Existing_HL_1st_EMI_Date__c)){
                                application.genesis__Terms_Selected__c='Within 2 years';
                            }
                            
                            if(application.genesis__Terms_Selected__c == 'Property under Construction' || application.genesis__Terms_Selected__c == 'SMA' || application.genesis__Terms_Selected__c == 'Within 2 years'){
                                application.Sub_Stage__c = Constants.Sub_Stage_Top_Up_Ineligible;
                                application.id = reqApp.ApplicationID;
                                update application;
                                res.status          = 'ERROR';
                                res.statusCode      = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                                res.errorMessage    = application.genesis__Terms_Selected__c;
                                return res;
                            }

                            if(boolean.Valueof(reqApp.HL_Facility[0].Selected_for_Top_Up)){
                                
                                WS_FetchHLLoanDetails.cls_Response cbs_res = WS_FetchHLLoanDetails.fetchLoanDetails(facilityList[0].Existing_HL_Loan_Account_No__c,facilityList[0].Id,facilityList[0].Application__c);
                                if(cbs_res != null && cbs_res.status == 'ERROR'){
                                    res.status          = cbs_res.status;
                                    res.statusCode      = cbs_res.statusCode;
                                    res.errorMessage    = cbs_res.errorMessage;
                                    return res;
                                } else if(cbs_res != null && cbs_res.applicationDetails != null){
                                    application.Branch_Code__c = cbs_res.applicationDetails.branchCode;
                                    application.Branch_Name__c = cbs_res.applicationDetails.branchName;
                                    application.Branch_City__c = cbs_res.applicationDetails.branchCity;
                                    application.Branch_State__c = cbs_res.applicationDetails.branchState;
                                }
                            }
                        }
                    }
                }
                //v1.3(end)

                String Owner_Id = '';
                if(!String.isBlank(reqApp.Branch_code) || !String.isBlank(reqApp.Sourced_by)){
                    if(!String.isBlank(reqApp.Branch_code)){
                        Owner_Id = AssignBranch.getBranch(reqApp.ApplicationID,reqApp.Branch_code,null);
                    }else if(!String.isBlank(reqApp.Sourced_by)){
                        Owner_Id = AssignBranch.getBranch(reqApp.ApplicationID,null,reqApp.Sourced_by);
                    }
                }
                if(!String.isBlank(Owner_Id)){
                    application.OwnerId = Owner_Id;
                }
                List<String> allaccList = new List<String>();
                List<Account> insertAcc = new List<Account>();
                List<Account> updateAcc = new List<Account>();
                Id primaryAccId;
                Id appforPrimaryAccId;                
                List<genesis__Application_Parties__c> partListToInsert = new List<genesis__Application_Parties__c>();
                List<genesis__Application_Parties__c> partListToUpdate = new List<genesis__Application_Parties__c>();
                integer count = 0;
                for(acctReqWrapper reqObj :reqApp.ACCTDETAILS){
                    List<Account> listBAcc = new List<Account>();
                    primaryAccId = reqObj.AccountId;
                    appforPrimaryAccId = reqObj.ApplicationID;
                    Account ac =new Account();
                    if(!String.isBlank(reqObj.AccountId)){
                        ac.id = reqObj.AccountId;
                    }
                    if(!String.isBlank(reqObj.presentAddress1) || !String.isBlank(reqObj.presentAddress2) || !String.isBlank(reqObj.presentAddress3)){
                        ac.PersonMailingStreet = reqObj.presentAddress1+' '+reqObj.presentAddress2+' '+reqObj.presentAddress3;
                    }
                    if(!String.isBlank(reqObj.presentCity)){
                        ac.PersonMailingCity = reqObj.presentCity;
                    }
                    if(!String.isBlank(reqObj.presentState)){
                        ac.PersonMailingState = reqObj.presentState;
                    }
                    if(!String.isBlank(reqObj.presentCountry)){
                        ac.PersonMailingCountry = reqObj.presentCountry;
                    }
                    if(!String.isBlank(reqObj.presentZip)){
                        ac.PersonMailingPostalCode = reqObj.presentZip;
                    }
                    if(!String.isBlank(reqObj.addProof)){
                        ac.Current_Address_Proof_Type__c = reqObj.addProof;
                    }
                    if(!String.isBlank(reqObj.voterId)){
                        ac.Voter_Id__c = reqObj.voterId;
                    }
                    if(!String.isBlank(reqObj.electricityCustNo)){
                        ac.Electricity_Customer_No__c = reqObj.electricityCustNo;
                    }
                    if(!String.isBlank(reqObj.CustLpgNo)){
                        ac.Customer_LPG_No__c = reqObj.CustLpgNo;
                    }
                    if(!String.isBlank(reqObj.waterBill)){
                        ac.Water_Bill_No__c = reqObj.waterBill;
                    }
                    if(!String.isBlank(reqObj.driveLicense)){
                        ac.Driving_License_ID__c = reqObj.driveLicense;
                    }
                    if(!String.isBlank(reqObj.passport)){
                        ac.Passport_Number__pc = reqObj.passport;
                    }
                    if(!String.isBlank(reqObj.caste)){
                        ac.Caste__pc = reqObj.caste;
                    }
                    if(!String.isBlank(reqObj.maritalStatus)){
                        ac.Marital_Status__pc = reqObj.maritalStatus;
                    }
                    if(!String.isBlank(reqObj.branchCode)){
                        ac.Branch_Code__c = reqObj.branchCode;
                    }
                    if(!String.isBlank(reqObj.isPhyHandicap)){
                        ac.Is_Physically_Handicapped__c = Boolean.valueOf(reqObj.isPhyHandicap);
                    }
                    if(!String.isBlank(reqObj.isExserviceMan)){
                        ac.Is_Ex_Service_Man__c = Boolean.valueOf(reqObj.isExserviceMan);
                    }
                    if(!String.isBlank(reqObj.religion)){
                        ac.Religion__c = reqObj.religion;
                    }
                    if(!String.isBlank(reqObj.eduQualification)){
                        ac.Education_Qualification__pc = reqObj.eduQualification;
                    }
                    if(!String.isBlank(reqObj.isAppRelatedBankDir)){
                        ac.Is_Applicant_Related_To_Bank_Directors__c = Boolean.valueOf(reqObj.isAppRelatedBankDir);
                    }
                    if(!String.isBlank(reqObj.nameBankRelated)){
                        ac.Name_Of_Bank_Related_To__c = reqObj.nameBankRelated;
                    }
                    if(!String.isBlank(reqObj.nameDirRelated)){
                        ac.Name_Of_Director_Related_To__c = reqObj.nameDirRelated;
                    }
                    if(!String.isBlank(reqObj.company_pincode)){
                        ac.Company_Pincode__c =  reqObj.company_pincode;
                    } 
                    if(!String.isBlank(reqObj.Company_City)){
                        ac.Company_City__c    =  reqObj.Company_City;
                    } 
                    if(!String.isBlank(reqObj.Company_State)){
                        ac.Company_State__c    =  reqObj.Company_State;
                    } 
                    if(!String.isBlank(reqObj.Customer_since)){
                        ac.CUSTSINCE__c = date.valueOf(reqObj.Customer_since);
                    }
                    if(!String.isBlank(reqObj.Customer_ID)){
                        ac.CBS_Customer_ID__c = reqObj.Customer_ID;
                    }
                    if(!String.isBlank(reqObj.Aadhaar_No)){
                        ac.Aadhaar_Number__pc = reqObj.Aadhaar_No;
                    }
                    if(!String.isBlank(reqObj.account_No)){
                        ac.ints__Bank_Account_Number__pc = reqObj.account_No;
                    }
                    if(!String.isBlank(reqObj.PAN_No)){
                        ac.Pan_Number__c = reqObj.PAN_No;
                    }
                    if(!String.isBlank(reqObj.Mobile_Number)){
                        string MobNumber;
                        if(reqObj.Mobile_Number!=null && (reqObj.Mobile_Number).length()==12){
                            MobNumber = reqObj.Mobile_Number;
                        }
                        else if(reqObj.Mobile_Number!=null && (reqObj.Mobile_Number).length()==10){
                            MobNumber ='91'+reqObj.Mobile_Number;
                        }
                        ac.PersonMobilePhone = MobNumber;
                    }
                    if(!String.isBlank(reqObj.E_mail)){
                        ac.PersonEmail = reqObj.E_mail;
                    }
                    if(!String.isBlank(reqObj.Reason_for_not_having_PAN_card)){
                        ac.Reason_For_Not_Having_PAN_Card__c = reqObj.Reason_for_not_having_PAN_card;
                    }
                    if(!String.isBlank(reqObj.First_Name)){
                        ac.FirstName = reqObj.First_Name;
                    }
                    if(!String.isBlank(reqObj.Last_Name)){
                        ac.LastName = reqObj.Last_Name;
                    }
                    if(!String.isBlank(reqObj.Middle_Name)){
                        ac.MiddleName = reqObj.First_Name;
                    }
                    if(!String.isBlank(reqObj.DOB)){
                        ac.PersonBirthdate = date.valueOf(reqObj.DOB);
                    }
                    if(!String.isBlank(reqObj.Fathers_Name)){
                        ac.Father_Name__pc = reqObj.Fathers_Name;
                    }
                    if(!String.isBlank(reqObj.Husbands_Name)){
                        ac.Husband_Name__pc = reqObj.Husbands_Name;
                    }
                    if(!String.isBlank(reqObj.permanentAddress1) || !String.isBlank(reqObj.permanentAddress2) || !String.isBlank(reqObj.permanentAddress3)){
                        ac.PersonOtherStreet = reqObj.permanentAddress1+' '+reqObj.permanentAddress2+' '+reqObj.permanentAddress3;
                    }
                    if(!String.isBlank(reqObj.permanentCity)){
                        ac.PersonOtherCity = reqObj.permanentCity;
                    }
                    if(!String.isBlank(reqObj.permanentState)){
                        ac.PersonOtherState = reqObj.permanentState;
                    }
                    if(!String.isBlank(reqObj.permanentCountry)){
                        ac.PersonOtherCountry = reqObj.permanentCountry;
                    }
                    if(!String.isBlank(reqObj.permanentZip)){
                        ac.PersonOtherPostalCode = reqObj.permanentZip;
                    }
                    if(!String.isBlank(reqObj.Nationality)){
                        ac.Nationality__pc = reqObj.Nationality;
                    }
                    if(!String.isBlank(reqObj.Resdential_status)){
                        ac.Residential_Status__pc = reqObj.Resdential_status;
                    }
                    if(!String.isBlank(reqObj.Do_you_have_any_assets)){
                        ac.Do_You_Have_Any_Assets__c = boolean.valueOf(reqObj.Do_you_have_any_assets);
                    }
                    if(!String.isBlank(reqObj.Immovable_assets)){
                        ac.Immovable_Assets__c = reqObj.Immovable_assets;
                    }
                    if(!String.isBlank(reqObj.Other_assets)){
                        ac.Other_Assets__c = reqObj.Other_assets;
                    }
                    if(!String.isBlank(reqObj.Cust_Type)){
                        ac.Type__c = reqObj.Cust_Type;
                    }
                    if(!String.isBlank(reqObj.Experience)){
                        ac.Experience__c = reqObj.Experience;
                    }
                    if(!String.isBlank(reqObj.Company_name)){
                        ac.Company_Name__c = reqObj.Company_name;
                    }
                    if(!String.isBlank(reqObj.Company_address)){
                        ac.Holding_Comp_Address__c = reqObj.Company_address;
                    }
                    if(!String.isBlank(reqObj.Mode_of_bank_statement_verification)){
                        ac.Mode_Of_Bank_Statement_Verification__c = reqObj.Mode_of_bank_statement_verification;
                    }
                    if(!String.isBlank(reqObj.Mode_of_ITR_verification)){
                        ac.Mode_Of_ITR_Verification__c = reqObj.Mode_of_ITR_verification;
                    }
                    if(!String.isBlank(reqObj.DisbursmentEsignCheck)){
                        ac.Disbursement_Esign__c = boolean.valueOf(reqObj.DisbursmentEsignCheck);
                    }
                    if(!String.isBlank(reqObj.ModEsignCheck)){
                        ac.MOD_Esign__c = boolean.valueOf(reqObj.ModEsignCheck);
                    }
                    if(!String.isBlank(reqObj.PerfiosUrl)){
                        ac.Perfios_URL__c = reqObj.PerfiosUrl;
                    }
                    //commented for Re model 
                    if(!String.isBlank(reqObj.CBSAccNo1)){
                        ac.CBS_Account_No_1__c = reqObj.CBSAccNo1;
                    }
                    if(!String.isBlank(reqObj.CBSAccNo2)){
                        ac.CBS_Account_No_2__c = reqObj.CBSAccNo2;
                    }
                    if(!String.isBlank(reqObj.CBSAccNo3)){
                        ac.CBS_Account_No_3__c = reqObj.CBSAccNo3;
                    }
                    if(!String.isBlank(reqObj.CBSAccNo4)){
                        ac.CBS_Account_No_4__c = reqObj.CBSAccNo4;
                    }
                    if(!String.isBlank(reqObj.CBSAccNo5)){
                        ac.CBS_Account_No_5__c = reqObj.CBSAccNo5;
                    }
                    if(!String.isBlank(reqObj.Full_Name)){
                        ac.Full_Name__c =  String.valueOf(reqObj.Full_Name);
                    }
                    
                    if(!String.isBlank(reqObj.Customer_IC)){
                        ac.Customer_IC__c =  String.valueOf(reqObj.Customer_IC);
                    }
                    
                    if(!String.isBlank(reqObj.AddressFrmCBS)){
                        ac.Present_address_from_CBS__c =  String.valueOf(reqObj.AddressFrmCBS);
                    }
                    
                    
                    if(!String.isBlank(reqObj.AlternativeMobile)){
                        ac.PersonOtherPhone = reqObj.AlternativeMobile;
                    }
                    if(reqObj.LandLine != null){
                        ac.Phone = reqObj.LandLine;
                    }
                    //mother maiden name
                    if(!String.isBlank(reqObj.Mothers_Name)){
                        ac.Mother_s_Maiden_Name__pc = reqObj.Mothers_Name;
                    }
                    
                    if(!String.isBlank(ac.Id)){
                        listAccount.add(ac);
                    }
                    //res.acctUpdate  = ac;
                    if(reqObj.Company != null){
                        //Deleting existing Firm Party(added by Subas)   
                        List<genesis__Application_Parties__c> delPartyList = [Select Id,Company__c From genesis__Application_Parties__c Where genesis__Application__c =: reqApp.ApplicationID AND Company__c = true];
                        if(delPartyList.size() >0){
                        for(genesis__Application_Parties__c inAct : delPartyList){
                            inAct.Company__c = false;
                        }
                            UPDATE delPartyList;
                        }
                        for(cls_Company comReq : reqObj.Company) {
                            
                            account bacc = new account ();
                            if((!String.isBlank(comReq.Firm_Name))) {
                                bacc.Name = comReq.Firm_Name;
                            }
                            if((!String.isBlank(comReq.Firm_Type))) {
                                bacc.Firm_Type__c = comReq.Firm_Type;
                            }
                            if((!String.isBlank(comReq.Relationship_with_Firm))) {
                                bacc.Relationship_with_Firm__c = comReq.Relationship_with_Firm;
                            }
                            if((!String.isBlank(comReq.Firm_PAN))) {
                                bacc.Pan_Number__c = comReq.Firm_PAN;
                            }
                            if((!String.isBlank(comReq.Firm_Address))) {
                                bacc.BillingStreet = comReq.Firm_Address;
                            }
                            if(!String.isBlank(comReq.Firm_Pincode)) {
                                bacc.BillingPostalCode = comReq.Firm_Pincode;
                            }
                            if(!String.isBlank(comReq.Business_Customer_ID)) {
                                bacc.CBS_Customer_ID__c = comReq.Business_Customer_ID;
                            }else{  
                                string uniqueno = CreateUniqueId.uniqID();                        
                                bacc.CBS_Customer_ID__c = uniqueno.subString(0,18);
                            }
                            if(!String.isBlank(comReq.Firm_City)){
                                bacc.BillingCity = comReq.Firm_City;
                            }
                            if(!String.isBlank(comReq.Firm_State)){
                                bacc.BillingState = comReq.Firm_State;
                            }
                            if(!String.isBlank(comReq.FirmId)) {
                                bacc.Id = comReq.FirmId;
                            }
                            
                            bacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
                            if( ! checkifAccountExist(bacc,listBAcc))
                                listBAcc.add(bacc);
                        }                        
                    }
                    List<genesis__Application_Parties__c> partList = new List<genesis__Application_Parties__c>();
                    List<genesis__Application_Parties__c> partiesList = new List<genesis__Application_Parties__c>();
                    //List<genesis__Application_Parties__c> partListToInsert = new List<genesis__Application_Parties__c>();
                    Set<Id> cretedAccIdList = new Set<Id>();
                    Map<Id,Id> pAccPartyMap = new Map<Id,Id>();
                    List<Id> accToDelete = new List<Id>();
                    List<Id> partyToDeleteList = new List<Id>();
                    
                    List<genesis__Application_Parties__c> allAppParties = new List<genesis__Application_Parties__c>();
                    List<String> panCheck = new List<String>();
                    List<Account> insertAccList = new List<Account>();
                    Map<String,String> exMap = new Map<String,String>();
                    allAppParties = [SELECT Id, genesis__Application__c, Key_Contact__c,genesis__Party_Account_Name__c, genesis__Party_Type__c FROM genesis__Application_Parties__c WHERE genesis__Application__c =: reqApp.ApplicationID];
                    Set<Id> allKeyContact = new Set<Id>();
                    for(genesis__Application_Parties__c key : allAppParties){
                        allKeyContact.add(key.Key_Contact__c);
                    }
                    List<Account> businessContact = [SELECT Id, Pan_Number__c FROM Account WHERE Id IN : allKeyContact];
                    for(Account qAcc : businessContact){
                        exMap.put(qAcc.Pan_Number__c,qAcc.Id);
                    }

                    if (reqApp.Stage == Constants.Sub_Stage_WorkInfoCaptured) {
                        for(Account ACC : listBAcc){
                            if(ACC.Id == null){
                                insertAccList.add(ACC);
                            }
                        }
                        genesis__Application_Parties__c partyMapping;
                        for(Account inAcct : insertAccList){
                            partyMapping = new genesis__Application_Parties__c();
                            if(exMap.size()>0)
                                if(inAcct.Pan_Number__c != null  && exMap.keySet().contains(inAcct.Pan_Number__c)){
                                    partyMapping.Key_Contact__c = exMap.get(inAcct.Id);
                                    partyMapping.genesis__Party_Account_Name__c = primaryAccId;
                                    partyMapping.genesis__Application__c = reqApp.ApplicationID;
                                    partyMapping.genesis__Party_Type__c = inAcct.Relationship_with_Firm__c;
                                    partyMapping.Company__c = true;
                                    partListToInsert.add(partyMapping);
                                }
                        }
                    }
                    
                    try{
                        system.debug('listBAcc>>>>> '+listBAcc);
                        UPSERT listBAcc;
                    }catch(Exception e){
                        HandleBusinessException.captureError('WS_UpdateAPI', 'getMandateFields', e);
                        System.debug('Line number >> '+e.getLineNumber()+'**Class name >> '+e.getStackTraceString()+'** message >> '+e.getMessage());
                    }
                    
                    partList = [SELECT Id, genesis__Application__c, Key_Contact__c,genesis__Party_Account_Name__c, genesis__Party_Type__c FROM genesis__Application_Parties__c WHERE genesis__Party_Account_Name__c =: primaryAccId ];
                    for(genesis__Application_Parties__c party : partList){
                        pAccPartyMap.put(party.Key_Contact__c, party.Id);
                    }

                    // Re model chnages
                    partiesList = queryService.getparties(reqApp.ApplicationID);
                    system.debug('##DataLog### --- > '+ partiesList);
                    for(genesis__Application_Parties__c party : partiesList){
                        
                        if( (party.genesis__Party_Type__c == Constants.PRIMARY_APP || party.genesis__Party_Type__c == Constants.Co_Borrower || party.genesis__Party_Type__c == Constants.Gurantor) && count == 0){
                            
                            if(!String.isBlank(reqObj.AccountId) && party.genesis__Party_Account_Name__c == string.valueOf(reqObj.AccountId)){
                                
                                if(!String.isBlank(reqObj.Agriculture_Income_itr1)){
                                    party.Agriculture_ITR1__c =  decimal.valueOf(checkZero(reqObj.Agriculture_Income_itr1));
                                }
                                if(!String.isBlank(reqObj.Agriculture_Income_itr2)){
                                    party.Agriculture_ITR2__c =  decimal.valueOf(checkZero(reqObj.Agriculture_Income_itr2));
                                }
                                if(!String.isBlank(reqObj.Agriculture_Income_itr3)){
                                    party.Agriculture_ITR3__c =  decimal.valueOf(checkZero(reqObj.Agriculture_Income_itr3));
                                }
                                if(!String.isBlank(reqObj.Share_of_Profit_itr_yr1)){
                                    party.Share_of_Profit_1__c =  decimal.valueOf(checkZero(reqObj.Share_of_Profit_itr_yr1));
                                }
                                if(!String.isBlank(reqObj.Share_of_Profit_itr_yr2)){
                                    party.Share_of_Profit_2__c =  decimal.valueOf(checkZero(reqObj.Share_of_Profit_itr_yr2));
                                }
                                if(!String.isBlank(reqObj.Share_of_Profit_itr_yr3)){
                                    party.Share_of_Profit_3__c =  decimal.valueOf(checkZero(reqObj.Share_of_Profit_itr_yr3));
                                }   //-----------
                                if(!String.isBlank(reqObj.Gross_Income_1)){
                                    party.Gross_Income1__c =  decimal.valueOf(checkZero(reqObj.Gross_Income_1));
                                }
                                if(!String.isBlank(reqObj.Capital_Gains_1)){
                                    party.Annual_Capital_Gain1__c =  decimal.valueOf(checkZero(reqObj.Capital_Gains_1));
                                }
                                if(!String.isBlank(reqObj.Interest_income_1)){
                                    party.Interest_Income1__c =  decimal.valueOf(checkZero(reqObj.Interest_income_1));
                                }
                                if(!String.isBlank(reqObj.Dividend_income_1)){
                                    party.Dividend_Income1__c =  decimal.valueOf(checkZero(reqObj.Dividend_income_1));
                                }
                                if(!String.isBlank(reqObj.Tax_1)){
                                    party.Annual_Tax1__c =  decimal.valueOf(checkZero(reqObj.Tax_1));
                                }
                                if(!String.isBlank(reqObj.Gross_Income_2)){
                                    party.Gross_Income2__c =  decimal.valueOf(checkZero(reqObj.Gross_Income_2));
                                }
                                if(!String.isBlank(reqObj.Capital_Gains_2)){
                                    party.Annual_Capital_Gain2__c =  decimal.valueOf(checkZero(reqObj.Capital_Gains_2));
                                }
                                if(!String.isBlank(reqObj.Interest_income_2)){
                                    party.Interest_Income2__c =  decimal.valueOf(checkZero(reqObj.Interest_income_2));
                                }
                                if(!String.isBlank(reqObj.Dividend_income_2)){
                                    party.Dividend_Income2__c =  decimal.valueOf(checkZero(reqObj.Dividend_income_2));
                                }
                                if(!String.isBlank(reqObj.Tax_2)){
                                    party.Annual_Tax2__c =  decimal.valueOf(checkZero(reqObj.Tax_2));
                                }
                                if(!String.isBlank(reqObj.Gross_Income_3)){
                                    party.Gross_Income3__c =  decimal.valueOf(checkZero(reqObj.Gross_Income_3));
                                }
                                if(!String.isBlank(reqObj.Capital_Gains_3)){
                                    party.Annual_Capital_Gain3__c =  decimal.valueOf(checkZero(reqObj.Capital_Gains_3));
                                }
                                if(!String.isBlank(reqObj.Interest_income_3)){
                                    party.Interest_income3__c =  decimal.valueOf(checkZero(reqObj.Interest_income_3));
                                }
                                if(!String.isBlank(reqObj.Dividend_income_3)){
                                    party.Dividend_income3__c =  decimal.valueOf(checkZero(reqObj.Dividend_income_3));
                                }
                                if(!String.isBlank(reqObj.Tax_3)){
                                    party.Annual_Tax3__c =  decimal.valueOf(checkZero(reqObj.Tax_3));
                                }
                                if(!String.isBlank(reqObj.Month_1_Income)){
                                    party.Salary_Credited_1__c =  decimal.valueOf(checkZero(reqObj.Month_1_Income));
                                }
                                if(!String.isBlank(reqObj.Month_2_Income)){
                                    party.Salary_Credited_2__c =  decimal.valueOf(checkZero(reqObj.Month_2_Income));
                                }
                                if(!String.isBlank(reqObj.Month_3_Income)){
                                    party.Salary_Credited_3__c =  decimal.valueOf(checkZero(reqObj.Month_3_Income));
                                }
                                if(!String.isBlank(reqObj.Month_4_Income)){
                                    party.Salary_Credited_4__c =  decimal.valueOf(checkZero(reqObj.Month_4_Income));
                                }
                                if(!String.isBlank(reqObj.Month_5_Income)){
                                    party.Salary_Credited_5__c =  decimal.valueOf(checkZero(reqObj.Month_5_Income));
                                }
                                if(!String.isBlank(reqObj.Month_6_Income)){
                                    party.Salary_Credited_6__c =  decimal.valueOf(checkZero(reqObj.Month_6_Income));
                                }
                                if(!String.isBlank(reqObj.Amount_Paid)){
                                    party.Amount_Paid__c =  decimal.valueOf(checkZero(reqObj.Amount_Paid));
                                }
                                if(!String.isBlank(reqObj.MinNMI)){
                                    party.MinNMI__c =  decimal.valueOf(checkZero(reqObj.MinNMI));
                                }
                                if(!String.isBlank(reqObj.Tax)){
                                    party.Tax_Deducted__c =  decimal.valueOf(checkZero(reqObj.Tax));
                                }
                                if(!String.isBlank(reqObj.IncomeComputationForm)){
                                    party.Income_Computation_From__c = reqObj.IncomeComputationForm;
                                }
                                //field transfer form ac to party start here
                                if(!String.isBlank(reqObj.Annual_Other_Income_Recurring_Credits_IT)){
                                    party.Annual_Other_IncomeRecurring_CreditsITR__c = Decimal.valueOf(reqObj.Annual_Other_Income_Recurring_Credits_IT);
                                }
                                if(!String.isBlank(reqObj.Net_monthly_income)){
                                    party.Net_Monthly_Income__c = decimal.valueOf(checkZero(reqObj.Net_monthly_income));
                                }
                                if(!String.isBlank(reqObj.Source_of_income1)){
                                    party.Source_of_Income1__c = reqObj.Source_of_income1;
                                }
                                if(!String.isBlank(reqObj.Additional_income_amount1)){
                                    party.Additional_Income_Amount1__c = decimal.valueOf(checkZero(reqObj.Additional_income_amount1));
                                }
                                if(!String.isBlank(reqObj.Source_of_income2)){
                                    party.Source_Of_Income2__c = reqObj.Source_of_income2;
                                }
                                if(!String.isBlank(reqObj.Additional_income_amount2)){
                                    party.Additional_Income_Amount2__c = decimal.valueOf(checkZero(reqObj.Additional_income_amount2));
                                }
                                if(!String.isBlank(reqObj.Source_of_income3)){
                                    party.Source_Of_Income3__c = reqObj.Source_of_income3;
                                }
                                if(!String.isBlank(reqObj.Additional_income_amount3)){
                                    party.Additional_Income_Amount3__c = decimal.valueOf(checkZero(reqObj.Additional_income_amount3));
                                }
                                if(!String.isBlank(reqObj.Source_of_income4)){
                                    party.Source_Of_Income4__c = reqObj.Source_of_income4;
                                }
                                if(!String.isBlank(reqObj.Additional_income_amount4)){
                                    party.Additional_Income_Amount4__c = decimal.valueOf(checkZero(reqObj.Additional_income_amount4));
                                }
                                if(!String.isBlank(reqObj.Source_of_income5)){
                                    party.Source_Of_Income5__c = reqObj.Source_of_income5;
                                }
                                if(!String.isBlank(reqObj.Additional_income_amount5)){
                                    party.Additional_Income_Amount5__c = decimal.valueOf(checkZero(reqObj.Additional_income_amount5));
                                }
                                if(!String.isBlank(reqObj.ExisitingEMI_Claimed)){
                                    party.Exisiting_EMIs_Claimed_by_Customer__c =  decimal.valueOf(checkZero(reqObj.ExisitingEMI_Claimed));
                                }
                                if(!String.isBlank(reqObj.Employment_type)){
                                    party.Employment_Types__c = reqObj.Employment_type;
                                }
                                if(!String.isBlank(reqObj.EmploymentSubType)){
                                    party.Employment_SubType__c = String.valueOf(reqObj.EmploymentSubType);
                                }
                                if(!String.isBlank(reqObj.PerfiosReqId1)){
                                    party.Perfios_Request_ID_1__c = reqObj.PerfiosReqId1;
                                }
                                if(!String.isBlank(reqObj.PerfiosReqId2)){
                                    party.Perfios_Request_ID_2__c = reqObj.PerfiosReqId2;
                                }
                                if(!String.isBlank(reqObj.CurrentAddAsPermanentAddress)){
                                    party.Same_Present_Address_Permanent_Address__c = Boolean.valueOf(reqObj.CurrentAddAsPermanentAddress);
                                }
                                if(!String.isBlank(reqObj.Are_you_an_existing_customer)){
                                    party.Is_Existing_Customer__c = Boolean.valueOf(reqObj.Are_you_an_existing_customer);
                                }
                                // PL score card - Company category
                                if(!String.isBlank(reqObj.Company_Category)){
                                    party.Employment_Cat__c = String.valueOf(reqObj.Company_Category);
                                }
                                // Start V1.1
                                if(!String.isBlank(reqObj.PerfiosUsed)){
                                    party.Perfios_Captured__c = boolean.valueof(reqObj.PerfiosUsed);
                                } 
                                // End  V1.1
                                //vehicle loan -start-------------------------------------
                                if(!String.isBlank(reqObj.PrimaryBank)){
                                    party.Primary_Bank__c = reqObj.PrimaryBank;
                                }
                                if(!String.isBlank(reqObj.primaryBankAccNo)){
                                    party.Bank_Account_Number__c = reqObj.primaryBankAccNo;
                                }

                                //vehicle loan -end-----------------------------------------
                                //title holder changes on 2-12-2018
                                if(!String.isBlank(reqObj.party_TitleHolder))
                                    party.Title_Holder__c = boolean.valueof(reqObj.party_TitleHolder); 
                                
                                //title holder ends 
                                
                                if(!String.isBlank(reqObj.IsFinancial)){
                                    party.Financial_Applicant__c =  Boolean.valueOf(reqObj.IsFinancial);
                                    
                                    if( !Boolean.valueOf(reqObj.IsFinancial) ||(!Utility.ISStringBlankorNull(reqObj.PerfiosUsed) && Boolean.valueOf(reqObj.PerfiosUsed))){
                                        party.Is_ITR_required__c=false;
                                        party.Is_Bank_Statement_required__c=false;
                                        Decimal PerfiosEMI = party.Existing_EMI_Perfios__c != null ? party.Existing_EMI_Perfios__c :0.00;
                                        Decimal CibilEmi = party.CIBIL_EMI__c != null ? party.CIBIL_EMI__c :0.00;
                                        Decimal KvbEmi = party.KVB_EMI__c != null ? party.KVB_EMI__c :0.00;
                                        party.Existing_Emis__c = math.max(Decimal.valueOf(reqObj.ExisitingEMI_Claimed !=null? reqObj.ExisitingEMI_Claimed :'0'), math.max(CibilEmi,PerfiosEMI)) + KvbEmi;
                                    }
                                    else{
                                        party.Is_ITR_required__c=true;
                                        party.Is_Bank_Statement_required__c=true;
                                        party.Existing_Emis__c = 0;
                                        system.debug('Extra'+reqObj.IsFinancial);
                                    }
                                    
                                }
                                system.debug('##DataLog### --- > Count '+ count);
                                //add official mail id at party level
                                if(!String.isBlank(reqObj.Official_Email)){
                                    party.Official_Email_ID__c = reqObj.Official_Email;
                                }                                
                                
                                partListToUpdate.add(party);
                            }
                        }
                    }
                    //remodel end here
                    for(Account pAcc : listBAcc){
                        genesis__Application_Parties__c party = new genesis__Application_Parties__c();
                        party.Key_Contact__c = pAcc.Id;
                        party.genesis__Party_Account_Name__c = primaryAccId;
                        party.genesis__Application__c = reqApp.ApplicationID;
                        party.genesis__Party_Type__c = pAcc.Relationship_with_Firm__c;
                        party.Company__c = true;
                        if(pAccPartyMap.keySet().contains(pAcc.Id)){
                            party.Id = pAccPartyMap.get(pAcc.Id);
                        }
                        partListToInsert.add(party);
                        cretedAccIdList.add(pAcc.Id);
                    }
                    
                    for(Id pAccId : pAccPartyMap.keySet()){
                        if(!cretedAccIdList.contains(pAccId)){
                            accToDelete.add(pAccId);
                            partyToDeleteList.add(pAccPartyMap.get(pAccId));
                        }
                    }
                    
                    List<genesis__Application_Parties__c> changelist = new List<genesis__Application_Parties__c>();
                    if(!partyToDeleteList.isEmpty()) {
                        for(genesis__Application_Parties__c accCg : [SELECT Id, Active__c FROM genesis__Application_Parties__c WHERE Id IN :partyToDeleteList AND Company__c = true])
                        {
                            accCg.Active__c = true;
                            changelist.add(accCg);
                            
                        }
                        update changelist;
                    }
                    
                    
                }
                count++; // Count to execute party loop only one time
                UPSERT partListToInsert;
                system.debug('##DataLog update### --- > '+ partListToUpdate);
                UPDATE partListToUpdate;
                
                if(reqApp.Collateral != null &&  reqApp.Collateral.size() > 0){
                    List<clcommon__Collateral__c> insertList = new List<clcommon__Collateral__c>();
                    List<clcommon__Collateral__c> updateList = new List<clcommon__Collateral__c>();
                    
                    List<clcommon__Collateral__c> collList = [SELECT Id,genesis__Application__r.Record_Type_Name__c,(Select ID from Ownerships__r) from clcommon__Collateral__c WHERE genesis__Application__c =: reqApp.ApplicationID];
                    List<clcommon__Collateral__c> collateralList = new List<clcommon__Collateral__c>();
                    if(collList.Size()>0){
                        List<Ownership__c> ownerList  = new List<Ownership__c>();
                        for(clcommon__Collateral__c col : collList){
                            collateralList.add(col);
                            for(Ownership__c owner : col.Ownerships__r){
                                ownerList.add(owner);
                            }
                        }
                        if(ownerList.size()>0){
                            delete ownerList;
                        }
                        if(collList[0].genesis__Application__r.Record_Type_Name__c ==Constants.LAPLOAN){
                            delete collateralList;
                        }
                    }
                    
                    for(cls_Collateral reqCol : reqApp.Collateral){
                        clcommon__Collateral__c col = new clcommon__Collateral__c();
                        col.Active__c = true;
                        
                        if(!String.isBlank(reqCol.Collateral_Type)){
                            col.Collateral_Type__c = reqCol.Collateral_Type;
                        }
                        if(!String.isBlank(reqCol.Collateral_Address)){
                            col.clcommon__Address__c = reqCol.Collateral_Address;
                        }
                        if(!String.isBlank(reqCol.Collateral_State)){
                            col.State__c = reqCol.Collateral_State;
                        }
                        if(!String.isBlank(reqCol.Collateral_City)){
                            col.clcommon__City__c = reqCol.Collateral_City;
                        }
                        if(!String.isBlank(reqCol.Collateral_PinCode)){
                            col.clcommon__Postal_Code__c = reqCol.Collateral_PinCode;
                        }
                        if(!String.isBlank(reqCol.Collateral_Use)){
                            col.Collateral_Uses__c = reqCol.Collateral_Use;
                        }
                        if(!String.isBlank(reqCol.EM_Charge_type)){
                            col.EM_Charge_Types__c = reqCol.EM_Charge_Type;
                        }
                        if(!String.isBlank(reqCol.No_of_tenants)){                            
                            col.No_of_tenants__c = reqCol.No_of_tenants;                            
                        }
                        if(!String.isBlank(reqCol.Vacant_Land_area)){
                            col.Vacant_Land_area__c = Decimal.ValueOf(reqCol.Vacant_Land_area);
                        }
                        if(!String.isBlank(reqCol.Collateral_Market_Value)){
                            col.Collateral_Market_Value__c = Decimal.ValueOf(reqCol.Collateral_Market_Value);
                            //v1.3(start)
                            if(Decimal.ValueOf(reqCol.Collateral_Market_Value) >= Constants.Property_Cost){
                                col.Double_Valuation_Charge__c = true;
                            } else {
                                Col.Double_Valuation_Charge__c = false;
                            }
                            //v1.3(end)
                        }
                        //vechicle Loan - Start------------------------------------------------------------------
                        if(!String.isBlank(reqCol.ManufacturerName)){
                            col.clcommon__Manufacturer__c = reqCol.ManufacturerName;
                        }
                        if(!String.isBlank(reqCol.Model)){
                            col.clcommon__Model__c = reqCol.Model;
                        }
                        if(!String.isBlank(reqCol.Variant)){
                            col.Variant__c = reqCol.Variant;
                        }
                        if(!String.isBlank(reqCol.DealerName)){
                            col.Dealer_name__c = reqCol.DealerName;
                        }
                        if(!String.isBlank(reqCol.DealerEmail)){
                            col.Dealer_Email__c= reqCol.DealerEmail;
                        }
                        if(!String.isBlank(reqCol.DealerPincode)){
                            col.Dealer_Pincode__c= reqCol.DealerPincode;
                        }
                        if(!String.isBlank(reqCol.DealerPhone)){
                            col.Dealer_Phone_Number__c= reqCol.DealerPhone;
                        }
                        if(!String.isBlank(reqCol.ExShowRoomPrice)){
                            col.ExShow_Room_Price__c= Decimal.ValueOf(reqCol.ExShowRoomPrice);
                        }
                        if(!String.isBlank(reqCol.RegistrationCost)){
                            col.Registration_cost__c= Decimal.ValueOf(reqCol.RegistrationCost);
                        }
                        if(!String.isBlank(reqCol.InsuranceAmount)){
                            col.clcommon__Insurance_Amount__c= Decimal.ValueOf(reqCol.InsuranceAmount);
                        }
                        if(!String.isBlank(reqCol.AccessoriesValue)){
                            col.Accessories_value__c= Decimal.ValueOf(reqCol.AccessoriesValue);
                        }
                        if(!String.isBlank(reqCol.TotalVehicleValue)){
                            col.Total_Vehicle_Value__c= Decimal.ValueOf(reqCol.TotalVehicleValue);
                        }
                        if(!String.isBlank(reqCol.FinalVehicleValue)){
                            col.Final_vehicle_value__c= Decimal.ValueOf(reqCol.FinalVehicleValue);
                        }
                        if(!String.isBlank(reqCol.AdvancesPaid)){
                            col.Advances_Paid__c= Decimal.ValueOf(reqCol.AdvancesPaid);
                        }
                        if(!String.isBlank(reqCol.ProformaInvoiceNo)){
                            col.Proforma_Invoice_No__c= reqCol.ProformaInvoiceNo;
                        }
                        if(!String.isBlank(reqCol.ProformaInvoiceDate)){
                            col.Proforma_Invoice_Date__c= Date.valueOf(reqCol.ProformaInvoiceDate);
                        }
                        if(!String.isBlank(reqCol.ExshowroomPrice_Apg)){
                            col.ExshowRoomPrice_Api__c= Decimal.valueOf(reqCol.ExshowroomPrice_Apg);
                        }
                        if(!String.isBlank(reqCol.ManufactureYear)){
                            col.clcommon__Year__c= reqCol.ManufactureYear;
                        }
                        if(!String.isBlank(reqCol.VLCalculatedValue)){
                            col.Vehicle_CalculatedValue__c= reqCol.VLCalculatedValue;
                        }
                        if(!String.isBlank(reqCol.ManualDealer)){
                            col.Manual_Dealer__c = boolean.valueof(reqCol.ManualDealer);
                        }
                        if(!String.isBlank(reqCol.SchemeType)){
                            col.Scheme_Type__c = String.valueof(reqCol.SchemeType);
                        }
                        if(!String.isBlank(reqCol.Ref_by_Dealer)){
                            col.Reff_by_Dealer__c = boolean.valueof(reqCol.Ref_by_Dealer);
                        }
                        if(!String.isBlank(reqCol.ManufactureMonth)){
                            col.Month__c= reqCol.ManufactureMonth;
                        }
                        //vehicle Loan -end----------------------------------------------------------------------
                        
                        col.genesis__Application__c = reqApp.ApplicationID;
                        
                        if((!String.isBlank(reqApp.ApplicationID) && reqApp.Stage == Constants.Sub_Stage_PropInfoCaptured)){
                            col.clcommon__Collateral_Name__c = getRandomExternalIdForCollateral();
                            insert col;

                            List<Ownership__c> newownerList = new List<Ownership__c>();
                            for(cls_Title_Holder th : reqCol.Title_Holder){
                                Ownership__c ow = new Ownership__c();
                                ow.Account__c = th.ApplicantId;
                                ow.Collateral__c = col.ID;
                                newownerList.add(ow);
                            }
                            if(newownerList.size() > 0){
                                system.debug('##OW##'+newownerList);
                                insert newownerList;
                            }                             
                        }

                        //vehicle Loan(Start)
                        if((!String.isBlank(reqApp.ApplicationID) && (reqApp.Stage ==Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE || reqApp.Stage ==Constants.SI_DETAILS_CAPTURED_SUBSTAGE1 || reqApp.Stage == NULL) )){
                            if(collList!=null && collList.size()>0){
                                Col.id=collList[0].id;
                                update Col;
                            }
                            else{
                                
                                Id genAppRecordType = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Motor Vehicle').getRecordTypeId();       
                                col.clcommon__Collateral_Name__c = getRandomExternalIdForCollateral();
                                col.RecordTypeId=genAppRecordType;
                                insert col;
                            }                        
                        }
                        // vehicle Loan (end)
                    }
                }
                
                List<Account> accBList = new List<Account>();
                List<Account> accBList2 = new List<Account>();
                List<Account> accBList3 = new List<Account>();
                for(String s : uniqueBacc){
                    accBList.add(dupeCheck.get(s));
                }
                Map<string,string>bAccMap = new Map<string,string>();
                system.debug('****'+baccListMap.keyset());
                system.debug('####'+listAccount);
                if(accBList.size()>0){
                    
                    //Insert accBList;
                    for(Account a : accBList){
                        if(a.CBS_Customer_ID__c != null){
                            accBList2.add(a); //upsert
                        }else{
                            accBList3.add(a); //insert
                        }
                    }
                    if(accBList2.size()>0){
                        upsert accBList2 CBS_Customer_ID__c;
                        for(Account a : accBList2){
                            bAccMap.put(a.Pan_Number__c,a.Id);
                        }
                    }
                    if(accBList3.size()>0){
                        insert accBList3;
                        for(Account a : accBList3){
                            bAccMap.put(a.Pan_Number__c,a.Id);
                        }
                    }
                }
                List<genesis__Application_Parties__c> PTList = new List<genesis__Application_Parties__c>();
                for(Account a : listAccount){
                    List<Account> accList = new List<Account>();
                    ///if(baccListMap.containsKey(a.id))
                    
                    accList               = baccListMap.get(a.Id);
                    if(accList != null){
                        for(Account acc : accList){
                            genesis__Application_Parties__c pt = new genesis__Application_Parties__c();
                            pt.Active__c = true;
                            pt.Key_Contact__c = bAccMap.get(acc.Pan_Number__c);
                            pt.genesis__Party_Account_Name__c = a.ID;
                            pt.genesis__Application__c = application.Id;
                            pt.Company__c = True;
                            PTList.add(pt);
                        }
                    }
                }
                if(PTList.size()>0){
                    insert PTList;
                }
                
                system.debug('@@@'+application+application.Id);
                If(listAccount.size() > 0 ){
                    Update listAccount;
                }

                if(!String.isBlank(application.Id)){
                    if(!Utility.ISStringBlankorNull(reqApp.Property_type) || !Utility.ISStringBlankorNull(reqApp.Purchase_cost_of_property) || !Utility.ISStringBlankorNull(reqApp.Cost_of_land) || !Utility.ISStringBlankorNull(reqApp.Cost_of_construction) || !Utility.ISStringBlankorNull(reqApp.Cost_of_repair) || !Utility.ISStringBlankorNull(reqApp.Flat) || !Utility.ISStringBlankorNull(reqApp.Property_Address1) || !Utility.ISStringBlankorNull(reqApp.Property_State) || !Utility.ISStringBlankorNull(reqApp.Property_City) || !Utility.ISStringBlankorNull(reqApp.Property_Pincode) || !Utility.ISStringBlankorNull(reqApp.Whether_Construction_Completed) || !Utility.ISStringBlankorNull(reqApp.Purpose_of_loan)){//v1.3
                        clcommon__Collateral__c Col = new clcommon__Collateral__c();
                        List<clcommon__Collateral__c> CollateralList = queryService.getCollateral(application.Id);
                        //prashant
                        if(!Utility.ISStringBlankorNull(reqApp.Builder_name))
                            col.Builder_Present_Owner_Seller_Name__c = string.valueof(reqApp.Builder_name);
                        if(!Utility.ISStringBlankorNull(reqApp.BuildingAge))
                            col.Age_Of_The_Building__c = Decimal.valueOf(reqApp.BuildingAge);
                        if(!Utility.ISStringBlankorNull(reqApp.Whether_Construction_Completed))
                            Col.Whether_The_Construction_Completed__c =Boolean.valueOf(reqApp.Whether_Construction_Completed);
                        if(!Utility.ISStringBlankorNull(reqApp.Property_Pincode))
                            Col.Property_Pincode__c =String.valueOf(reqApp.Property_Pincode);
                        if(!Utility.ISStringBlankorNull(reqApp.Property_City))
                            Col.clcommon__City__c =String.valueOf(reqApp.Property_City);
                        if(!Utility.ISStringBlankorNull(reqApp.Property_State))
                            Col.State__c =String.valueOf(reqApp.Property_State);
                        if(!Utility.ISStringBlankorNull(reqApp.Property_Address1))
                            Col.Property_Address__c =String.valueOf(reqApp.Property_Address1); 
                        if(!Utility.ISStringBlankorNull(reqApp.Cost_of_repair))
                            Col.Cost_Of_Repair__c =decimal.valueOf(reqApp.Cost_of_repair);
                        if(!Utility.ISStringBlankorNull(reqApp.Cost_of_construction))
                            Col.Cost_Of_Construction__c =decimal.valueOf(reqApp.Cost_of_construction);
                        if(!Utility.ISStringBlankorNull(reqApp.Cost_of_land))
                            Col.Cost_Of_Land__c =decimal.valueOf(reqApp.Cost_of_land);
                        if(!Utility.ISStringBlankorNull(reqApp.Purchase_cost_of_property))
                            Col.Cost_Of_Flat_House__c =decimal.valueOf(reqApp.Purchase_cost_of_property);
                        if(!Utility.ISStringBlankorNull(reqApp.Property_type))
                            Col.clcommon__Property_Type__c =String.valueOf(reqApp.Property_type);
                        if(!Utility.ISStringBlankorNull(reqApp.Flat))
                            Col.Flat_Door_Shop_Bungalow_Nos__c = reqApp.Flat;
                        if(!Utility.ISStringBlankorNull(reqApp.Project_name))
                            Col.Builder_Present_Owner_Seller_Name__c =reqApp.Project_name;

                        //v1.3(start)
                        if(!String.isBlank(reqApp.Total_cost_incurred_till_date)){
                            Col.Total_cost_incurred_till_date__c = Decimal.Valueof(reqApp.Total_cost_incurred_till_date);
                        }
                        if(!String.isBlank(reqApp.Cost_incurred_in_the_last_6_months)){
                            Col.Cost_incurred_in_the_last_6_months__c = Decimal.Valueof(reqApp.Cost_incurred_in_the_last_6_months);
                        }
                        //v1.3(end)
                        
                        if(CollateralList!=null && CollateralList.size()>0){
                            //v1.3(start)
                            if (reqApp.Stage == Constants.Sub_Stage_PropInfoCaptured) {
                                Decimal CostProperty = 0;
                                if(reqApp.Purpose_of_loan==Constants.IdentifiedProperty || reqApp.Purpose_of_loan==Constants.Loanpurpose){
                                    CostProperty=CollateralList[0].Cost_Of_Flat_House__c;
                                }
                                else if(reqApp.Purpose_of_loan==Constants.RepairHouse){
                                    if (reqApp.SubType == Constants.Sub_Type_Top_Up) {
                                        CostProperty=CollateralList[0].Cost_Of_Flat_House__c;
                                    } else {
                                        CostProperty=CollateralList[0].Cost_Of_Repair__c;
                                    }
                                }
                                else if(reqApp.Purpose_of_loan==Constants.Construction){
                                    CostProperty=CollateralList[0].Cost_Of_Construction__c;
                                }
                                else if(reqApp.Purpose_of_loan==Constants.ConstructionOn){
                                    CostProperty=CollateralList[0].Cost_Of_Land__c + CollateralList[0].Cost_Of_Construction__c;
                                }
                                System.debug('CostProperty>>> '+CostProperty);
                                //Double valuation check for all HL product
                                if(CostProperty >= Constants.Property_Cost){
                                    Col.Double_Valuation_Charge__c = true;
                                }else {
                                    Col.Double_Valuation_Charge__c = false;
                                }
                                //Valuation check for HL Top Up
                                if(reqApp.SubType == Constants.Sub_Type_Top_Up && CollateralList[0].Valuation_Date__c!=null && (CollateralList[0].Valuation_Date__c.monthsBetween(System.today())) < 33){
                                    Col.Valuation_Applicable__c = false;
                                } else if(reqApp.SubType == Constants.Sub_Type_Top_Up && CollateralList[0].Valuation_Date__c!=null && (CollateralList[0].Valuation_Date__c.monthsBetween(System.today())) >= 33){
                                    Col.Valuation_Applicable__c = true;
                                }
                            }
                            //v1.3(end)
                            Col.id=CollateralList[0].id;
                            update Col;
                        }
                        else{
                            //v1.3(start)
                            if (reqApp.Stage == Constants.Sub_Stage_PropInfoCaptured) {
                                Decimal CostProperty = 0;
                                if((reqApp.Purpose_of_loan==Constants.IdentifiedProperty || reqApp.Purpose_of_loan==Constants.Loanpurpose) && !Utility.ISStringBlankorNull(reqApp.Purchase_cost_of_property)){
                                    CostProperty = Decimal.valueOf(reqApp.Purchase_cost_of_property);
                                }
                                else if(reqApp.Purpose_of_loan==Constants.RepairHouse && !Utility.ISStringBlankorNull(reqApp.Cost_of_repair)){
                                    CostProperty = Decimal.valueOf(reqApp.Cost_of_repair);
                                }
                                else if(reqApp.Purpose_of_loan==Constants.Construction && !Utility.ISStringBlankorNull(reqApp.Cost_of_construction)){
                                    CostProperty = Decimal.valueOf(reqApp.Cost_of_construction);
                                }
                                else if(reqApp.Purpose_of_loan == Constants.ConstructionOn && !Utility.ISStringBlankorNull(reqApp.Cost_of_land) && !Utility.ISStringBlankorNull(reqApp.Cost_of_construction)){
                                    CostProperty = Decimal.valueOf(reqApp.Cost_of_land) + Decimal.valueOf(reqApp.Cost_of_construction);
                                }
                                System.debug('CostProperty>>> '+CostProperty);
                                //Double valuation check for all HL product
                                if(CostProperty >= Constants.Property_Cost){
                                    Col.Double_Valuation_Charge__c = true;
                                }else {
                                    Col.Double_Valuation_Charge__c = false;
                                }
                            }
                            //v1.3(end)
                            Col.genesis__Application__c=application.Id;
                            col.clcommon__Collateral_Name__c = getRandomExternalIdForCollateral();
                            insert col;
                        }
                    }
                    
                    application.Reject_Scenario__c = '';
                    update application;
                    if(reqApp.Stage==Constants.Sub_Stage_WorkInfoCaptured){
                        NMICalculations.Calculations(application.id);
                    }
                    
                    if(reqApp.Loan_required_amount <> '0' & reqApp.Loan_required_amount<>null && !Utility.ISStringBlankorNull(reqApp.EMI) && Utility.ISStringBlankorNull(reqApp.Stage)){
                        //Adding GMRA list in the response
                        String Ids=reqApp.ApplicationID;
                        List<GMRA__c> gmraList = GmraCal.GmraCalculations(Ids);
                        //List<GMRA__c> gmraList = new List<GMRA__c>();
                        if(gmraList<>null){
                            system.debug('^^^^'+gmraList);
                            res.GMRA_outmaps            = new List<OUT_MAP>();
                            for(GMRA__c gm : gmraList){
                                OUT_MAP ot = new OUT_MAP();
                                ot.GMRA_AMT = String.ValueOf(gm.Amount__c); //Adding Value for GMRA
                                ot.GMRA_Name    = gm.Name;
                                res.GMRA_outmaps.add(ot);
                                system.debug('****'+res.GMRA_outmaps);
                            }
                        }
                    } 
                }
                res.status      = Constants.WS_SUCCESS_STATUS;
                res.statusCode  = Constants.WS_SUCCESS_CODE;
            }catch(Exception e){
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage   = e.getMessage()+' At '+e.getLineNumber();
                res.statusCode  = Constants.WS_ERROR_CODE;
                system.debug('Exception::'+e+e.getLineNumber()+' At '+e.getLineNumber());
                HandleBusinessException.captureError('WS_UpdateAPI', 'getMandateFields', e);
                return res;
            }
            
            
            return res;
        }
    }
    public static Boolean checkifAccountExist(Account acc,List<Account> listBAcc){
        
        for(Account accrec:listBAcc){
            if(acc.Pan_Number__c ==accrec.Pan_Number__c)
                return true;
        }
        return false;
    }
    public static String checkZero(String Jval){
        String conVal = '';
        if(Jval == '0'){
            conVal = '0.00';
        }else{
            conVal = Jval;
        }
        return conVal;
    }
    public static List<clcommon__Collateral__c> getAppCollaterals(String appId){
        List<clcommon__Collateral__c> delQuery = [SELECT Id, genesis__Application__c, (Select Id, Account__r.Name from Ownerships__r) FROM clcommon__Collateral__c WHERE genesis__Application__c=:appId];
        System.debug('delQuery'+delQuery);
        return delQuery;
    }
    public static String getRandomExternalIdForCollateral(){
        String leftPaddedString = getRandomString();
        return 'FE-'+leftPaddedString;
    }
    public static String getRandomString(){
        Integer randomInteger = Crypto.getRandomInteger();
        String randomString=String.valueOf(math.abs(randomInteger));
        String leftPadding = '000000';
        String leftPaddedString = randomString.leftPad(20,leftPadding);
        return leftPaddedString+String.valueOf(DateTime.now().millisecond());
    }
}