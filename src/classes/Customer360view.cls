/*
* Purpose   : WS Resposne Wrapper for Customer360 view
* Author    : Amritesh
*/ 
public class Customer360view{
    
    public String TYPE_OF_APPLICATION;
    public String IS_C1_GENERATED;
    public String LOS_APPLICATION_NAME;
    public String LOS_BASE_DOMAIN_URL;
    public String LOS_APPLICATION_ID;
    public String LOS_CUSTOMER_SF_ID;
    public string LOS_CUSTOMER_ID;
    public string CUSTOMER_ID;
    public string IS_ONLY_STOCK_UPDATION;
    public String REQUEST_DATE_TIME;    
    public String APPLICATION_UI_STAGE; 
    public String APPLICATION_STAGE;
    public String APP_SUB_STAGE;
    public String DIGIO_DOC_ID;
    public string APP_TYPE;
    public String APPLICATION_TO_CLOSE;
    public String PARENT_APPLICATION;
    public String TYPE;
    public String ENHANCEMENT_MAX_LIMIT;
    public String IS_PROVISIONAL_FINANCIAL;
    public String NEW_TO_BUSINESS;
    public String BRANCH_CODE;
    public String BRANCH_NAME;
    public String IS_CLPC_TASK;
    public String IS_TEMPORARY_LIMIT;
    public String IS_LIABILITIES_DATA;
    public String RENEWAL_DUE_DATE;
    public cls_COMPANY_DETAILS COMPANY_DETAILS;
    public cls_KEY_PERSON_DETAILS[] KEY_PERSON_DETAILS;
    public cls_SANCTION_SECTION SANCTION_SECTION;
    public cls_FINANCIAL_SECTION[] FINANCIAL_SECTION;
    public cls_LOANDETAIL loanInfo;
    public DocumentFetch.DocumentCategory ORDERS_ON_HAND;
    public List<DocumentFetch.DocumentCategory> MASTER_DOC_CAT_LIST;
    public DocumentFetch.DocumentCategory ENHANCEMENT_DOCUMENTS;
    public DocumentFetch.DocCatRequest DOCUMENT_CATEGORY_LIST;
    public List<cls_newFinacialDocuments> financial_documents;
    public cls_SUMMARY SUMMARY_VIEW;
    public cls_FINANCIAL_STATEMENT FINANCIALS;
    public CustEnhancementDetails CUST_ENHANCEMENT;
    public cls_NET_WORTH_STATEMENT NET_WORTH_STATEMENT;
    // Added from sme_CustomerfetchWrapper
    public List<cls_TEMPLATES> DOWNLOADABLE_TEMPLATES;
    public List<cls_MISSING_FIN> MISSING_FINACIAL_YEARS;
    public cls_APP_REQUEST NEW_REQUEST;
    public cls_DEBTORS_CREDITORS_INFO DEBTORS_CREDITORS_DETAILS;
    public List<cls_LIMIT_ASSESMENT> LIMIT_ASSESMENT;
    public cls_QUERY_FOLLOWUP CUSTOMER_QUERY;
    public string REJECT_REASON;
    public List<cls_Sanction_Document> SANCTION_DOCUMENT_LIST;
    public cls_Slider_Changes SLIDER_CHANGES;
    public List<cls_PERFIOS_TRXNID> PERFIOS_TRXNID;
    public List<cls_GSTN_FINANCIAL> GSTN_FINANCIAL;
    public String LOS_QUESTION_NEW_LOAN;
    public cls_BusinessLiabilityDetails BusinessLiabilityDetails;
    public List<cls_KeyPersonLiabilityDetails> KeyPersonLiabilityDetails;
    /*public List<QuestionAndAnswer> EXISTING_FACILITY_QUESTION;
    public List<QuestionAndAnswer> NEW_FACILITY_QUESTION;*/
    //public DocumentFetch.FinanceSection FINANCIAL_SECTION; soql
    public class cls_COMPANY_DETAILS {
        /*Added for Term LOAN Change*/
        public List<QuestionAndAnswer> EXISTING_FACILITY_QUESTION;
        public List<QuestionAndAnswer> NEW_FACILITY_QUESTION;
        public String TU_TRIGGER_COMPLETED;
        public String PROFIT_AFTER_TAX;
        public String NET_FIXED_ASSET_LAND_AND_BUILDING;
        public String NET_FIXED_ASSET_PLANT_AND_MACHINERY;
        public String PREVIOUS_YEAR_GROWTH_RATE;
        public String UDYOG_ADHAAR_NUMBER;
        public String BUREAU_FEE;
        public String BUREAU_FEE_RESULT;
        public Boolean IS_SRTO;
        public Boolean IS_NEW_TO_BUSINESS_TL;
        public String NET_BANKING_FLAG;
        public String PROCESSING_FEE_RESULT;
        public String LEGAL_CHARGES;
        public String LEGAL_CHARGES_RESULT;
        public String UNIQUE_KEY;
        public String EXPANSION_CRITERIA;
        public String BUREAU_FEE_GST;
        public String LEGAL_OPINION_WITH_GST;
        public String VALUATION_CHARGES;
        public String VALUATION_CHARGES_WITH_GST;
        public String TRANSACTION_DATE;


        
        public Map<String,String> ACCOUNT_BANK_MAP;
        public String CREDIT_BUREAU_CHECK;
        public String PRIMARY_BANK_NAME;
        public String PRIMARY_IFSC_CODE;
        public String PRIMARY_BRANCH_NAME;
        public String PRIMARY_ACCOUNT_NUMBER;
        
        public cls_COMPANY_PRIMARY_DETAILS COMPANY_PRIMARY_DETAILS;
        public cls_COMPANY_COMMUNICATION_DETAILS COMPANY_COMMUNICATION_DETAILS;
        public cls_COLLATERAL_DETAILS COLLATERAL_DETAILS;
        public cls_GROUP_CONCERN_DETAILS[] GROUP_CONCERN_DETAILS;
        public String CUSTOMER_ID;  
        public String LOAN_ACCOUNT_NO;  
        public String BORROWER_NAME;
        public String BORROWER_LOS_ID;
        public String CONTACT_PERSON_DESIGNATION;   
        public String LINE_OF_ACTIVITY;
        Public String LINE_OF_ACTIVITY_CODE;
        public String CIN_NUMBER;   
        public String PAN_NUMBER;   
        public String IE_CODE_NUMBER;   
        public String RECONSTITUTED;    
        public String RELATED;
        public String REASONS_FOR_GST_NOT_APPLICABLE;
        public String TURNOVER;
        public String PRINCIPAL_NATURE_OF_BUSINESS;
        public String PRIORITY;
        public String DATE_OF_INCORPORATION;
		public String UAM_NUMBER;
        public String MAJOR_ACTIVITY;
        public String ENTERPRISE_TYPE;
        public String ACTIVITY_TYPE;
        //public String NAME_OF_THE_FACILITY;   
        public String LOAN_AMOUNT;  
        /*public String APPROVED_LOAN_AMOUNT;*/
        public String BALANCE_OUTSTANDING;  
        public String OVER_DUE; 
        public String OVERALL_EXPOSURE; 
        public cls_DOCUMENT_SECTION[] DOCUMENT_SECTION;
        public cls_CURRENT_LOAN_APPLICATION CURRENT_LOAN_APPLICATION;
        public cls_NEW_LOAN_FACILITY_DETAILS NEW_LOAN_FACILITY_DETAILS;
        public string OPENING_BALANCE;
        // Different attributes from Sme_CustomerFetch
        public String CASH_FLOW_METHOD;   
        public string CUSTOMER_NAME;
        public List<cls_REJECTED_KEY_PERSON> REJECTED_KEY_PERSON;
        public String PROCESSING_FEE;
        public STring STATUS;
        public cls_SECTION_20_CUSTOMER SECTION_20_CUSTOMER;
    }

    public class cls_New_facility_Info{

        public String LOS_Facility_Id;
        public String New_Limit_Amount;
    }

    public class cls_Slider_Changes{

        public String ACCEPTED;
        public String Reason_For_Reject;
        public String Terms_And_Condition;
        public String APP_STAGE;
        public String APP_SUBSTAGE;
        public List<cls_New_facility_Info> Facility_Wise_New_Limit;
    }
    
    public class cls_Signatory{

        public string LOS_Party_Id;
        public string LOS_Digio_Status_Updation_Id;
        public Boolean IS_ESIGN_DONE;
    }
    
    public class cls_Sanction_Document{

        public string Document_Name;
        public string Document_Id;
        public string DMS_UUID;
        public List<cls_Signatory> Signers;
    }
    
    public class cls_newFinacialDocuments{
        public List<DocumentFetch.DocumentCategory> Category_list;
        //public DocumentFetch.DocCatRequest DOCUMENT_CATEGORY_LIST;
        public string year;
    }
    public class cls_QUERY_FOLLOWUP{
        public DocumentFetch.DocumentCategory QUERY_FOLLOW_CATEGOREY;
        public List<cls_CUSTOMER_QUERY> ALL_QUERIES;
    }
    public class cls_CUSTOMER_QUERY{
        public string LOS_ID;
        public string Question;
        public string Answer;
        public string Status;
    }
    
    public class cls_COMPANY_PRIMARY_DETAILS {
        public String NAME_OF_THE_GROUP;    
        public String NAME; 
        public String INDUSTRY_TYPE;    
        public cls_CONSTITUTION_DETAILS CONSTITUTION_DETAILS;   
        public String GST_NUMBER;   
    }
    
    public class cls_COMPANY_COMMUNICATION_DETAILS {
        public cls_ADDRESS REGISTERED_OFFICE_ADDRESS;
        public cls_ADDRESS CORPORATE_OFFICE_ADDRESS;
        public String CONTACT_PERSON_NAME;
        public String CONTACT_NUMBER;
        public String EMAIL_ADDRESS;
    }
    public class cls_CONSTITUTION_DETAILS {
        public String CONSTITUTION;
        public String RECONSTITUTION_DATE;
        /*Sme_customer Fetch wrapper does'nt have following attributes*/
        public cls_FINANCIAL_SECTION[] CONSTITUTION_EXISTING_DOC;   
        public DocumentFetch.DocCatRequest CONSTITUTION_DOCUMENT_CATEGORY;
    }
    public class cls_COLLATERAL_DETAILS {
        public cls_PRIMARY_SECURITIES[] PRIMARY_SECURITIES;
        public cls_COLLATERAL_SECURITIES[] COLLATERAL_SECURITIES;
    }
    
    public class cls_PRIMARY_SECURITIES {
        public string LOS_FACILITY_SECURITY_ID;
        public string LOS_PRIMARY_SECURITY_ID;
        public String SECYRITY_TYPE;    
        public String SECURITY_ADDRESS; 
        public String SECURITY_OWNERSHIP_TYPE;  
        public String SECURITY_VALUATION_DATE;  
        public String SECURITY_VALUE;   
        public String MORTGAGE_DETAILS;
        public String NATURE_OF_PROPERTY;
        public String PERCENTAGE_OWNERSHIP;
        public String SURVEY_NO;
        public String TYPE_OF_COMMERCIAL_VEHICLE;
        public String ASSET_TYPE;
        public String DOOR_NO;
        public String NEAREST_LANDMARK;
        public String PROPERTY_AREA;
        public cls_ADDRESS ADDRESS;
    }
    
    public class cls_COLLATERAL_SECURITIES {
        public string LOS_FACILITY_SECURITY_ID;
        public string LOS_COLLATERAL_SECURITY_ID;
        public String SECYRITY_TYPE;    
        public String SECURITY_ADDRESS; 
        public String SECURITY_OWNERSHIP_TYPE;  
        public String SECURITY_VALUATION_DATE;  
        public String SECURITY_VALUE;
        public String MORTGAGE_DETAILS;
        public String NATURE_OF_PROPERTY;
        public String PERCENTAGE_OWNERSHIP;
        public String SURVEY_NO;
        public String TYPE_OF_COMMERCIAL_VEHICLE;
        public String ASSET_TYPE;
        public String DOOR_NO;
        public String NEAREST_LANDMARK;
        public String PROPERTY_AREA;
        //public String PERCENTAGE_OWNERSHIP;
        public cls_ADDRESS ADDRESS;
    }
    
    public class cls_DOCUMENT_SECTION {
        public String FILE_TYPE;    
        public String FILE_NAME;    
        public String FILE_URL;
        public String LOS_SANC_FILE_ID;
    }
    
    public class cls_CURRENT_LOAN_APPLICATION {
        public cls_PRIMARY_SECURITIES[] PRIMARY_SECURITIES;
        public cls_COLLATERAL_SECURITIES[] COLLATERAL_SECURITIES;
        public String PRESENT_RATE_OF_INTEREST; 
    }
    
    public class cls_KEY_PERSON_DETAILS {
        public cls_PRIMARY_DETAILS PRIMARY_DETAILS;
        public cls_COMMUNICATION_DETAILS COMMUNICATION_DETAILS;
        public cls_SECTION_CHANGES SECTION_CHANGES;
        public cls_NETWORTH_DETAILS[] NETWORTH_DETAILS;
        public string LOS_PARTY_TYPE_ID;
        public string DIGIO_STATUS;        
        public String CBS_CUSTOMER_ID;  
        public String PASSPORT_NUMBER;  
        public String SEX;  
        public String NATIONALITY;  
        public String FATHER_NAME;  
        public String MARITAL_STATUS;   
        public String SPOUSE_NAME;  
        public String CASTE;    
        public String RESIDENTIAL_STATUS;   
        public String RESIDENCE_TYPE;   
        public String DIN_NUMBER;   
        public String LAND_AND_BUILDING;    
        public String LOCATION_TYPE;    
        public String CITY; 
        public String STATE;    
        public String PINCODE;  
        public String BUILT_UP_AREA;    
        public String NUMBER_OF_STOREYS;    
        public String VALUE_OF_LAND_AND_BUILDING;   
        public String ALREADY_CHARGED;  
        public String JOINT_HOLDERS;    
        public String TYPE_OF_LAND; 
        public String TYPE_OF_OWNERSHIP;    
        public String AREA_OF_LAND; 
        public String VALUE_OF_LAND;    
        public String PARTY_TYPE;
        public String PRODUCT_TYPE;
        public String GUARANTOR;    //YES/NO
        public string DELETEKEYPERSON; //YES/NO
        public string IS_PHYSTCALLY_HANDICAPPED; //YES/NO
        public string IS_EXSERVICE_MAN; //YES/NO
        public string IS_ACTIVE;//YES/NO
        public string ITR_DOCCATEGORY_ID;
        public string EXISTING_NETWORTH;
        public string RELIGION;
        public string RELIGION_CODE;
    }
    
    public class cls_PRIMARY_DETAILS {
        public string LOS_PERSON_ACCOUNT_ID;
        public String FIRST_NAME;
        public String LAST_NAME;
        public String DESIGNATION;  
        public String DOB;  
        public String EDUCATIONAL_QUALIFICATION;
        public String EDUCATIONAL_QUALIFICATION_CODE;
        public String PAN_NUMBER;   
        public String AADHAAR_NUMBER;   
    }
    public class cls_COMMUNICATION_DETAILS {
        public String MOBILE_NUMBER;    
        public String EMAIL_ADDRESS;    
        public cls_ADDRESS PARMANENT_ADDRESS;   
        public String ADDRESS;  
    }
    public class cls_SECTION_CHANGES {
        public string FIRST_NAME;
        public string LAST_NAME;
        public String NAME;
        public String RELATIONSHIP;
        public String BANK_NAME;
        public String IS_KVB_DIRECTOR;
    }
    public class cls_NETWORTH_DETAILS {
        /*public string Existing_Networth;
        public string PROPERTY_TYPE;
        public string PROPERTY_VALUE;
        public string LOS_PROPERTY_ID;
        public cls_ADDRESS ADDRESS;*/
                //attributes copied from sme_customer_fetch wrapper
        public string LOS_PROPERTY_ID;
        public string NATURE_OF_PROPERTY;
        public string PROPERTY_VALUE;
        public string OWNERSHIP_TYPE;
        public string SURVEY_NO;
        public string MORTGAGE_DETAILS;
        public string PERCENTAGE_OWNERSHIP; 
        public string ASSET_TYPE;
        public cls_ADDRESS ADDRESS;
        public string DOOR_NO;
        public string NEAREST_LANDMARK;
        public string PROPERTY_AREA;
        public string EXISTING_NETWORTH; 
        public string PROPERTY_TYPE;
        public string IS_COLLATERAL;
        public List<cls_TITLE_HOLDER> TILE_HOLDERS ;

        /* New Tag for TL */
        //public List<String> FACILITY_SEQ_NO_LIST;

        public Map<String,String> FACILITY_LINKAGE_MAP;//= new map<String,String>{'F1'=>'PS','F2'=>'SS'};

        public string NATURE_OF_MACHINERY;
        public string NATURE_OF_COMMERCIAL_VEHICLE;
        public string NATURE_OF_CONSTRUCTION_EQUIPMENT;
        public string NATURE_OF_PASSENGER_VEHICLE;
        public string NATURE_OF_OTHERS;
        public string MACHINERY_COST;
        public string INSTALLATION_COST;
        public string OTHER_COST;
        public string CHASSIS_COST;
        public string CATEGORY_CV;
        public string BODY_BUILDING_COST;
        public string GST_PAN;
        public string DEALER_GST_NUMBER;
        public string DEALER_PAN_NUMBER;

        public string COMMERCIAL_VEHICLE_APG;
        public string COST_DEVIATION;


        /* Existing Tags for TL*/
        public string RECORD_TYPE;
        public string MAKE;
        public string MODEL;
        public string VARIANT;

        public string DEALER_NAME;
        public string ADDRESS_LINE_1;
        public string ADDRESS_LINE_2;
        public string STATE ;
        public string CITY ;
        public string PIN_CODE;

        public string EXSHOWROOMPRICE_APG;
        public string REGISTRATION_COST; 
        public string INSURANCE_AMOUNT; 
        public string ADVANCES_PAID;
        public String TYPE_OF_COMMERCIAL_VEHICLE;
        public String IS_DELETED;

        public String EXSHOWROOMPRICE;
        public String ACCESSORY_COST;
        public String TAX;
        public string VARIANT_ID;
        public string CITY_ID;
        public String MAKE_ID;

        public String TL_INVESTMENT_PROPERTY;
        public String TYPE_OF_VEHICLE;
        public String STATE_ID;
        public String MODEL_ID;
        public String NUMBER_OF_EQUIPMENT;
        public String IS_TL_COLLATERAL;
        public String CURRENTLY_MORTGAGED;


    }
    public class cls_TITLE_HOLDER{
        public string LOS_TITLE_HOLDER_ID;
        public string LOS_TITLE_HOLDER_NAME;
        public string LOS_TITLE_HOLDER_RECORD_ID ;
        
    }
    public class cls_ADDRESS{
        public string STREET;
        public string CITY;
        public string STATE;
        public string COUNTRY;
        public string PIN_CODE;
        public string TALUK;
        
    }   
    public class cls_SANCTION_SECTION {
        public String RECOMMENDED_FINAL_RATE_OF_INTEREST;   
    }
    public class cls_FINANCIAL_SECTION {
        public Decimal LABEL_ID;    
        public String FILE_NAME;    
        public String FILE_URL; 
        public String LOS_FINANCE_FILE_ID;
        public cls_FINANCIAL_SECTION(String fName, String fId,Decimal labelId){
            this.FILE_NAME = fName;
            this.FILE_URL = Constants.SITE_BASE_URL+fId; 
            this.LOS_FINANCE_FILE_ID = fId;
            this.LABEL_ID = labelId;
        }
        public cls_FINANCIAL_SECTION(){}
    }
    public class cls_GROUP_CONCERN_DETAILS {
        public String PAN_NUMBER;
        public Boolean IS_DELETED;
        public String GROUP_CONCERN_ID;
        public String FIRM_RELATED_NAME;
        public String BANK_NAME;
        public String LIMIT_AMOUNT;
        public String TYPE;
    }
    
    public class cls_LOANDETAIL {
        public List<cls_FACILITIES> WORKING_CAPITAL; 
        public STOCK_MODEL STOCK; 
        public List<cls_FACILITIES> MY_LOAN; 
    }
    
    public class cls_FACILITIES {
        public string NAME_OF_THE_FACILITY;
        public string ACCOUNT_NUMBER;
        public string TOTAL_LOAN_AMT;
        public string BALANCE_OUTSTANDING;
        public string LIMIT_AMT;
        public string OVER_DUE;
        public string INTEREST_RATE;
        public string PRODUCT_CODE;
        public string PRODUCT_NAME;
        public string APPROVED_LIMIT;
        public string DAYS;
        public string FACILITY_ID;
        public string NEW_LIMIT_AMT;
        public String MARGIN;
        public String END_DATE;
        public String IS_DELETED;
        public String PURPOSE_OF_LOAN;
        public String CURRENT_LIMIT;
        public String PROPOSED_LIMIT;
        public String APPLY_FOR_ENHANCEMENT;
        public String REASON_FOR_ENHANCEMENT;

        public String DATE_OF_MATURITY;

        /*added for New Doc flow*/
        public String MCLR_RATE;
        public String Loan_Rate_of_Interest;
        public String VALIDITY_PERIOD;
        public String Preclosure_Charge;
        public String Penal_Charges;

        
       /* 
        public String BANK_STATEMENT_END_DATE;
        public String BANK_STATEMENT_START_DATE;
        public String BANK_NAME;
        public String TYPE_OF_LOAN;
        public String START_DATE;
        public String TAKEOVER;
        public String PURPOSE_OF_SHIFTING;
        public String FUNDED_NON_FUNDED;
        public String FUNDED_TYPE;
        public String PRE_SHIPMENT;
        public String POST_SHIPMENT;
        public String RUNNING_AC;
        public String NON_RUNNING_AC;
        public String FOREIGN_EXCHANGE;
        public String INR;
        public String LC;
        public String NON_LC;
        public String SIGHT;
        public String USANCE;
        public String INLAND;
        public String FOREIGN;
        public String PERFORMANCE;
        public String FINANCE;
        public String NTB_FACILITY_TYPE;
        public String UNIQUE_NO;
         */
    }
    public class cls_SUMMARY {
        public cls_CONSTITUTION CONSTITUTION_CHANGED;
        public cls_KEYPERSON NEW_KEYPERSON;
        public cls_KEYPERSON DELETE_KEYPERSON;
        public List<cls_SECTION_CHANGES> SEC_20_CHANGES;
        public cls_REQUEST_SUMMARY REQUEST_SUMMARY;
        
    }
    public class cls_REQUEST_SUMMARY {
        public string REASON_FOR_APPLICATION;
        public string LIMIT_PERIOD;
        public cls_FACILITIES[] FACILITY_INFO;
    }
    public class cls_CONSTITUTION {
        public string PREVIOUS_VALUE;
        public string NEW_VALUE;
    }
    
    public class cls_KEYPERSON {
        public string NAMES;    
    }
    public static Customer360view parse(String json){
        return (Customer360view) System.JSON.deserialize(json, Customer360view.class);
    }
    //Financial statements
    public class cls_FINANCIAL_STATEMENT{
        public cls_FINANCIALS SALES;
        public cls_FINANCIALS PURCHASE;
        public cls_FINANCIALS DEBITOR_AEP  ;
        public cls_FINANCIALS SUNDARY_CREDITOR_AEP  ;
        public cls_FINANCIALS LAND_AND_BUILDING;
        public cls_FINANCIALS PLANT_AND_MACHINERY;
        public cls_FINANCIALS INTANGIBLE_OTHERS;
    }
    public class cls_FINANCIALS{
        public cls_FY ACTUAL_PREV_FY;
        public cls_FY ACTUAL_CURRENT_FY;
        public cls_FY YTD_CURRENT_FY;
        public cls_FY EST_NEXT_FY;
        public cls_FY PROJ_NEXT2_FY;
        public cls_FY ACTUAL_N_1_FY;
    }
    public class cls_FY{
        public String FY_LABEL;
        public String FY_TOTAL;
        public String MONTH;
        public String LOS_ID;
    }
    //Customer enhancement details
    public class CustEnhancementDetails{
        public String AMOUNT;
        public String REASON;
    }
    
    public class STOCK_MODEL {
        public List<STOCK_TEMPLATE> templates;
        public List<cls_STOCK_STATEMENT> STOCK_STATEMENT;      
    }
    
    public class STOCK_TEMPLATE{
        public string TEMPLATE_LABEL;
        public string TEMPLATE_LINK;
    }
    
    public class cls_STOCK_STATEMENT{
        public string year;
        public string month;
        public string status;
        public STOCK_BELOW_LIMIT belowLimit;
        public STOCK_ABOVE_LIMIT aboveLimit;
    }
    public class STOCK_BELOW_LIMIT {      
        public string OPENING_STOCK;
        public string PURCHASE;
        public string SALES;
        public string SUNDRY_DEBT;
        public string SUNDRY_CREDIT;
        public string LOS_RECORD_ID;
        
        public STOCK_BELOW_LIMIT(){           
            this.OPENING_STOCK          = '';
            this.PURCHASE               = '';
            this.SALES                  = '';
            this.SUNDRY_DEBT            = '';
            this.SUNDRY_CREDIT          = '';
            this.LOS_RECORD_ID          = '';
        } 
    }
    public class STOCK_ABOVE_LIMIT {
        public cls_STATUS STOCK_STATUS;
        public cls_STATUS DEBTORS_STATUS;
        public cls_STATUS CREDITORS_STATUS;
    }
    public class cls_TEMPLATES {
        public string TEMPLATE_LABEL;
        public string TEMPLATE_LINK;
    }
    public class cls_APP_REQUEST {
        public string REQ_REASON;
        public string REASON_FOR_APPLICATION;
        public string LIMIT_PERIOD;
        public List<cls_NETWORTH_DETAILS> COLLATERAL_DETAILS;
        public cls_FACILITIES[] FACILITY_INFO;
    }
    public class cls_DEBTORS_CREDITORS_INFO {
        public List<cls_DEBTORS_CREDITORS> DEBOTORS_AS_FINACIAL_END;
        public List<cls_DEBTORS_CREDITORS> DEBOTORS_AS_CURRENT_DATE;
        public List<cls_DEBTORS_CREDITORS> CREDITORS_AS_FINACIAL_END;
        public List<cls_DEBTORS_CREDITORS> CREDITORS_AS_CURRENT_DATE;
    }
    public class cls_LIMIT_ASSESMENT {
        public string YEAR;
        public List<cls_LIMIT_ASSESMENT_INFO> monthwiseInfo;
    }
    public class cls_DEBTORS_CREDITORS {
        public string LOS_RECORD_ID;
        public string NAME;
        public String AGE;
        public string AMOUNT;        
    }
    public class cls_LIMIT_ASSESMENT_INFO{
        public string MONTH; 
        public String Advances_from_customers;
        public String Cash_Sales_Receipts;
        public String Credit_Purchases;
        public String Other_payments_if_any;
        public String Other_receipts_if_any;
        public String Payment_of_creditors;
        public String Payment_of_Expenses;
        public String Purchases;
        public String Realization_of_debtors;
        public String Salary_and_Wages;
    }
    public class cls_STATUS{
        public string status; // COMPLETED, PENDING
    }
    public class cls_MISSING_FIN{
        public String CA_NUMBER;
        public String CA_NAME;
        public string year;
        public string status;
        public string datasource;
    }
    public class cls_NET_WORTH_STATEMENT{
        
        public String TOTAL_OUTSTANDING_LIABALITIES;
        public String TOTAL_NETWORTH;
        public String ORIGINAL_AMOUNT_INVESTMENTS;
        public DocumentFetch.DocumentCategory TOL_AND_TNW_DOC_CATEGORY;
    }
    public class cls_NEW_LOAN_FACILITY_DETAILS{
        
        public List<cls_WC_WITH_KVB> WC_WITH_KVB;
        public List<cls_APP_WC_WITH_KVB> APP_WC_WITH_KVB;
        public List<cls_CURRENT_ACCOUNT_WITH_OTHER_BANKS> CURRENT_ACCOUNT_WITH_OTHER_BANKS;
        public List<cls_NETWORTH_DETAILS> SECURITY;
        public cls_WC_WITH_OTHER_BANK WC_WITH_OTHER_BANK;
        public cls_NEW_LOAN_FACILTY NEW_LOAN_FACILTY;
        public cls_SUPPORTING_DOCS_CATEGORY SUPPORTING_DOCS_CATEGORY;
        public cls_SUPPORTING_DOCS_CATEGORY SANCTION_LETTER_CATEGORY;
        public cls_SUPPORTING_DOCS_CATEGORY BANK_STATEMENT_CATEGORY;
        public String TU_OVERALL_EXPOSURE;
        public String IS_TASK_FAILED;
        public String APPLICATION_EXPOSURE;
        /*Added for Term Loan*/
        public cls_WC_WITH_OTHER_BANK  TL_WITH_OTHER_BANK;
        public List<cls_APP_WC_WITH_KVB> APP_TL_WITH_KVB;
        
    }
    public class cls_WC_WITH_KVB {
        
        public String LOAN_ACCOUNT_NUMBER;
        public String FACILITY_NAME;
        public String FACILITY_ID;
        public String MARGIN;
        public String INTEREST_RATE;
        public String SANCTION_LIMIT;
        public String END_DATE;
        public String APPLY_FOR_ENHANCEMENT;
        public String LIMIT_AMOUNT;
        public String PURPOSE_OF_LOAN;
        public String CURRENT_LIMIT;
        public String EMI_NMI;
        public String PROPOSED_LIMIT;
        public String PRODUCT_ID;
        public String UNIQUE_NO;
        public String REASON_FOR_ENHANCEMENT;
        public String SEQUENCE_NO;
        public string APPROVED_LIMIT;
        public string NEW_LIMIT_AMT;        
    }
    public class cls_APP_WC_WITH_KVB {
        
        public String LOAN_ACCOUNT_NUMBER;
        public String FACILITY_NAME;
        public String FACILITY_ID;
        public String MARGIN;
        public String INTEREST_RATE;
        public String SANCTION_LIMIT;
        public String END_DATE;
        public String APPLY_FOR_ENHANCEMENT;
        public String LIMIT_AMOUNT;
        public String PURPOSE_OF_LOAN;
        public String CURRENT_LIMIT;
        public String PROPOSED_LIMIT;
        public String PRODUCT_ID;
        public String UNIQUE_NO;
        public String REASON_FOR_ENHANCEMENT;
        public String IS_DELETED;
        public String RECOMMENDED_LIMIT;
        public List<cls_SUPPORTING_DOCS_DETAILS> SUPPORTING_DOCS_DETAILS;
        public String HOLIDAY_PERIOD;
        public String CURRENT_OUTSTANDING;
        public String NATURE_OF_FACILITY;
        public String ACCOUNT_NUMBER;
        public String CURRENT_BALANCE;
        public String TENURE;
        public String SEQUENCE_NO;
        public string APPROVED_LIMIT;
        public string NEW_LIMIT_AMT;

        /*added for New Doc flow*/
        public String MCLR_Rate;
        public String Loan_Rate_of_Interest;
        public String Validity_Period;
        public String Preclosure_Charge;
        public String Penal_Charges;

    }
    
    public class cls_SUPPORTING_DOCS_DETAILS {
        
        public String FACILITY_ID ;
        public String DOC_UUID;
        public String CATEGORY_ID;
    }
    public class cls_WC_WITH_OTHER_BANK{
        
        public String REASON_FOR_SHIFTING;
        public List<cls_FACILITY_OTHER> FACILITY_OTHER;
        public List<cls_SUPPORTING_DOCS_DETAILS> SUPPORTING_DOCS_DETAILS;
        //public List<cls_TERM_LOAN_WITH_OTHER> TERM_LOAN_WITH_OTHER;
    }
    
    public class cls_FACILITY_OTHER{

        public String BANK_NAME;
        public String FACILITY_NAME;
        public String FACILITY_ID;
        public String SANCTION_LIMIT;
        public String START_DATE;
        public String END_DATE;
        public String BALANCE_OUTSTANDING;
        public String INTEREST_RATE;
        public String MARGIN;
        public String IS_DELETED;
        public String REQUESTED_AMOUNT;
        public String UNIQUE_NO;
        public String RECOMMENDED_LIMIT;
        public List<cls_BANK_STATEMENT> BANK_STATEMENT;
        public cls_SANCTION_LETTER  SANCTION_LETTER;
        public String TENURE;
        public String ORIGINAL_TENURE;
        public String HOLIDAY_PERIOD;
        public String CURRENT_OUTSTANDING;
        public String NATURE_OF_FACILITY;
        public String ACCOUNT_NUMBER;
        public String CURRENT_BALANCE;
        public String TENURE_START_DATE;
        public Boolean isScannedStatement;
        public String PASSWORD;

        public String TAKEOVER;
        public String FACILITY_PRODUCT_CATEGORY;
        public String APP_FACILITY_TYPE;
        public String PURPOSE_OF_LOAN;
        public String BANK_INSTITUTION;
        public String DISBURSEMENT_DATE;
        public String SEQUENCE_NO;
        public string APPROVED_LIMIT;
        public string NEW_LIMIT_AMT;


        /*Added for New Doc Flow*/
        public String MCLR_Rate;
        public String Loan_Rate_of_Interest;
        public String Validity_Period;
        public String Preclosure_Charge;
        public String Penal_Charges;
    }
    public class cls_BANK_STATEMENT {
        
        public String TRANXN_ID ;
        public String CATEGORY_ID;
        public String DOC_UUID;
        public String PERFIOS_STATUS;
    }
    public class cls_SANCTION_LETTER {
        
        public String FACILITY_ID;
        public String DOC_UUID;
        public String CATEGORY_ID;
    }
    
    public class cls_NEW_LOAN_FACILTY{
        public List<cls_NEW_FACILITIES> NEW_FACILITIES;
        public List<cls_SUPPORTING_DOCS_DETAILS> SUPPORTING_DOCS_DETAILS;    
    }
    public class cls_NEW_FACILITIES {
        
        public String REQUESTED_AMOUNT;
        public String FUNDED_NON_FUNDED;
        public String UNIQUE_NO;
        public String NATURE_OF_ADVANCE;
        public String FACILITY_ID;
        public String IS_DELETED;
        public String RECOMMENDED_LIMIT;
        
        public String FACILITY_TYPE;


        /*Added for New Doc Flow*/
        public String FACILITY_NAME;
        public String MARGIN;
        public String MCLR_Rate;
        public String Loan_Rate_of_Interest;
        public String Validity_Period;
        public String Preclosure_Charge;
        public String Penal_Charges;

        /*Added for Term Loan Changes*/
        public String SEQUENCE_NO;
        public String REPAYMENT_TYPE;
        public String PURPOSE_OF_LOAN;
        public String TENURE;
        public String HOLIDAY_PERIOD;
        public String NATURE_OF_FACILITY;
        public String APPLICANT_CONTRIBUTION;
        public String ONE_TIME_LC_BG;
        public String FACILITY_PRODUCT_CATEGORY;
        public String APP_FACILITY_TYPE;

        public String PRIMARY_SECURITY_REQUESTED;
        public String COLLATERAL_SECURITY_REQUESTED;
        public String BANK_INSTITUTION;
        public String TYPE_OF_REQUEST;
        public String EXISTING_LIMIT;
        public String EMI_NMI;
        public string APPROVED_LIMIT;
        public string NEW_LIMIT_AMT;
        
    }
    public class cls_CURRENT_ACCOUNT_WITH_OTHER_BANKS{
        public String CURRENT_LOS_ID;
        public String BANK_NAME;
        public String ACCOUNT_NUMBER;
        public String CURRENT_BALANCE;
        public String START_DATE;
        public String END_DATE;
        public String PURPOSE_OF_CA;
        public String IS_DELETED;
        public String UNIQUE_NO;
        public List<cls_BANK_STATEMENT> BANK_STATEMENT;
    }
    public class cls_SUPPORTING_DOCS_CATEGORY {
        public String CATEGORY_ID;
        public String DOC_LABEL;
    }
    public class cls_REJECTED_KEY_PERSON {
        public String ID;
        public String NAME;
    }
    public class cls_GSTN_FINANCIAL {
        
        public String ACTUAL_SALES;
        public String YTD_SALES;
        public String YTD_MONTH;
        
    }
    public class cls_PERFIOS_TRXNID {
        
        public String FACILITY_ID;
        public String TRXNID;
        public String DOC_UUID;
        
    }
    public class cls_SECTION_20_CUSTOMER {
        public String NAME_OF_DIRECTOR;
        public String NAME_OF_BANK;
        public String NATURE_OF_RELATIONSHIP;
        public String SECTION_20;
    }
    //Liabilities API.
    public class cls_BusinessLiabilityDetails {
        public List<cls_GroupConcernDetailsPersonal> GroupConcernDetailsPersonal;
        public List<cls_DirectLiabilityLongTerm> DirectLiabilityLongTerm;
        public String CustomerStatus;   
        public List<cls_GroupConcernDetailsBusiness> GroupConcernDetailsBusiness;
        public List<cls_DirectLiabilityTemporary> DirectLiabilityTemporary;
        public String CustomerId;   
        public List<cls_IndirectLiabilityGroup> IndirectLiabilityGroup;
        public String CustomerType; 
        public List<cls_IndirectLiabilityRetail> IndirectLiabilityRetail;
    }
    public class cls_KeyPersonLiabilityDetails {
        public List<cls_GroupConcernDetailsPersonal> GroupConcernDetailsPersonal;
        public List<cls_DirectLiabilityLongTerm> DirectLiabilityLongTerm;
        public String CustomerStatus;   
        public List<cls_GroupConcernDetailsBusiness> GroupConcernDetailsBusiness;
        public List<cls_DirectLiabilityTemporary> DirectLiabilityTemporary;
        public String CustomerId;   
        public List<cls_IndirectLiabilityGroup> IndirectLiabilityGroup;
        public String CustomerType; 
        public List<cls_IndirectLiabilityRetail> IndirectLiabilityRetail;
    }
    public class cls_GroupConcernDetailsPersonal {
        public String GROUP_CONCERN;    
        public String GROUP_NAME;   
        public String PERSONAL_ID;  
        public String COD_ACCT_NO;  
        public String PERSONAL_NAME;    
    }
    public class cls_DirectLiabilityLongTerm {
        public String COD_CC_BRN;   
        public String NAM_CUST_SHRT;    
        public String COD_ACCT_NO;  
        public String BAL_AVAILABLE;    
        public String COD_PROD; 
        public String LIMITNO;  
    }
    public class cls_GroupConcernDetailsBusiness {
        public String NAM_CUST_FULL;    
        public String PERSONALCUSTID;   
        public String COD_ACCT_TITLE;   
        public String COD_ACCT_NO;  
        public String FLG_CUST_TYP; 
        public String BUSINESSCUSTID;   
    }
    public class cls_DirectLiabilityTemporary {
        public String COD_CC_BRN;   
        public String NAM_CUST_SHRT;    
        public String COD_ACCT_NO;  
        public String BAL_AVAILABLE;    
        public String AMT_LIMIT;    
        public String COD_PROD; 
    }
    public class cls_IndirectLiabilityGroup {
        public String D_OPEN_DATE;  
        public String V_CUST_CODE;
        public String V_ACCT_NO;    
        public String N_FALLBACK_BAL;
        public String LIMITNO;
    }
    public class cls_IndirectLiabilityRetail {
        public String D_OPEN_DATE;  
        public String V_CUST_CODE;  
        public String V_ACCT_NO;    
        public String N_FALLBACK_BAL;   
    }
    public class QuestionAndAnswer{
        public string question;
        public string answer;
        public string priority;
    }

}