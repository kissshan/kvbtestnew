/* 
* Name      : Constansts
* Purpose   : This class is used for all constant values.
* Company   : ET Marlabs
* Author    : Amritesh
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      ==========      ==================================
V1.1        08-10-2018      Venu            KYC DOcuments Updating
v1.2        17-01-2019      Braj            HL MVP2
*******************************************************************************************/
public class Constants {
    
    // Generic
    public static final string WS_SUCCESS_STATUS                            = 'Success';
    public static final string SENT_STAGE                                   = 'Sent';
    public static final string WS_SUCCESS_CODE                              = '200';
    public static final string WS_NO_ERROR                                  = 'NO_ERROR';
    public static final string WS_ERROR_STATUS                              = 'Error';
    public static final string WS_ERROR_CODE                                = '400';
    public static final string WS_REQ_BODY_IS_NULL                          = 'REQUEST_BODY_IS_NULL';
    public static final string WS_UNABLE_TO_PARSE_REQ                       = 'UNABLE_PARSE_REQ_PARAMS';
    public static final string WS_NO_RECORD_FOUND                           = 'No Records Found';
    public static final string SME_APP_RECORD_TYPE                          = 'SME_Renewal';
    public static final string SME_APP_RECORD_TYPE_EXCEEDING                = 'SME_Exceeding';
    public static final string SME_APP_RECORD_TYPE_ADHOC                    = 'SME_AdHoc';
    public static final string SME_APP_RECORD_TYPE_ENHANCEMENT              = 'SME_Enhancement';
    public static final string SME_RECORD_TYPE_LABEL                        = 'SME Renewal';
    public static final string SME_RECORD_TYPE_LABEL_EXE                    = 'SME Exceeding';
    public static final string SME_RECORD_TYPE_LABEL_ADHOC                  = 'SME AdHoc';
    public static final string SME_RECORD_TYPE_LABEL_ENHANCEMENT            = 'SME Enhancement';
    public static final String SME_NEW_LOAN_RECORD_TYPE                     = 'SME_NEW_Loan';
    public static final String SME_NEW_LOAN_RECORD_TYPE_LABEL               = 'SME NEW Loan';
    public static final String TERM_LOAN                                    = 'Term Loan';
    public static final string SME_FACILITY                                 = 'Facility__c';
    public static final string ETB_CA_TAKEOVER                              = 'ETB-CA - Takeover';
    public static final string NTB_TAKEOVER                                 = 'NTB - Takeover';
    public static final String ETB_WC_TAKEOVER                              = 'ETB-WC - Takeover';
    public static final string ETB_CA_NEW_TO_CREDIT                         = 'ETB-CA - New to credit';
    public static final string NTB_NEW_TO_CREDIT                            = 'NTB - New to credit';
    public static final string NTB                                          = 'NTB';
    public static final string WC_CA                                        = 'ETB-CA';
    public static final string ETB_WC                                       = 'ETB-WC';
    public static final Decimal SME_FIFTY_LAKH                              = 5000000.00;
    public static final string COMMERCIAL_VEHICLE                           = 'Commercial_Vehicle';
    public static final string SME_APP_STAGE_ENHANCEMENT_FINAL_SANC         = 'Enhancement- Final sanction';
    public static final string SME_APP_STAGE_ADHOC_FINAL_SANC               = 'Adhoc-Final sanction';
    public static final string SME_APP_STAGE_EXE_FINAL_SANC                 = 'Exceeding-Final sanction';
    
    public static final string HL_APP_RECORD_TYPE                           = 'Home_Loan';
    public static final string BUSINESS_ACCOUNT                             = 'Business_Account';
    public static final string PERSON_ACCOUNT                               = 'Person_Account';
    public static final string PERSON_ACCOUNT_DEVNAME                       = 'PersonAccount';
    public static final String PERFIOS_EXISTING_DATA_MESSAGE                = 'Existing perfios data found in LOS for the customer against received fiscal year';
    public static final String CLASS_OF_ACTIVITY                            =  'ALL OTHER LOANS NOT CLASSIFIED ELSEWHERE OR ACTIVITIES NOT ADEQUATELY DESCRIBED (THIS CODE SHOULD BE USED SPARINGLY)';
    public static final String APPLICANT_TYPE_COMPANY                       = 'Company';
    public static final String APPLICANT_TYPE_DIRECTOR                      = 'Director';
    public static final String HUF                                          = 'HUF';
    public static final String HINDU_UNDIVIDED_FAMILY                       = 'HINDU UNDIVIDED FAMILY';
    public static final String LLP                                          = 'LLP';
    public static final String COMPANIES                                    = 'Companies';
    public static final String NOT_CLASSIFIED                               = 'NOT CLASSIFIED';
    public static final String REGISTERED_OFFICE                            = 'REGISTERED OFFICE';
    public static final String RENEWAL_ENHANCEMENT                          = 'RENEWAL/ENHANCEMENT';
    public static final String CONSUMER_CIR_TRUE                            = 'true';
    public static final String CONSUMER_CIR_FALSE                           = 'false';
    public static final String COMPLETED                                    = 'Completed';
    
    public static final string SCORECARD_CREATION_SUCCESS_STATUS    = 'Successfully generated scorecard';
    // Application Stage
    public static final string Enhancement_App_Submitted        = 'Enhancement- Application submitted';
    public static final string Exceeding_App_Submitted          = 'Exceeding- Application submitted';
    public static final string Adhoc_App_Submitted              = 'Adhoc- Application submitted';
    public static final string New_Loan_Submitted               = 'New loans- Application submitted'; 
    public static final string INSUFFICIENTCOLLETRALCOVERAGE    = 'Application Sub Stage has been changed to Insufficient Collateral Stage';
    public static final string APPL_STAGE_LOAN_SANCTIONED_NON_STOP = 'Loan Sanctioned Non-STP';
    public static final string APPL_STAGE_LOAN_ACCOUNT_OPENED = 'Loan Account opened';
    public static final string AppCreateStage = 'Application Created';
    public static final String WC_KVB       = 'WC KVB';
    public static final String WC_OTHERS    = 'WC Others';
    public static final String NEW_FACILITY = 'New';
    public static final String APPLICATION_REVIEW_CRITICAL_CHANGE   = 'Application review-Critical changes';
    public static final String INSUFFICIENT_COLLATERAL_COVERAGE     = 'Insufficient collateral coverage';
    //Loan Typee
    public static final string HOMELOAN = 'Home Loan';
    public static final string LAPLOAN = 'LAP';
    public static final string PERSONALLOAN = 'Personal Loan';
    public static final string PL           = 'Personal_Loan';
    public static final string SMElOAN = 'SME';
    public static final string HomeLoanName = 'Smart Home Loan - 797';  //Happy Home Loan - 753
    
    
    // Vehicle Loan  All Tags
    public static final string VL4W ='VL4W';
    public static final string VL2W ='VL2W';
    public static final string Fixed='Fixed Rate';
    public static final string FloatRate='Float Rate';
    public static final string PreApprovedMessage='Successfully PreApproved';
    public static final string AppProcessed='Application Processed - Closed';
    
    public static final string ParentDOCCatgNameVL             ='VL Documents';
    public static final string VehicleVerifiReport             ='Vehicle_verification_Docs';
    public static final string Upload_Vehicle_Insurance        ='Upload_Vehicle_Insurance';
    public static final string VehicleDocuments                ='Vehicle_Docs';
    public static final integer VEHICLECOST2L                  =200000;
    public static final integer VEHICLECOST10L                 =1000000;
    public static final integer VEHICLEPF2W1K                  =1000;
    public static final integer VEHICLEPF2W3K                  =3000;
    public static final integer VEHICLEPF2W7500                =7500;
    
    public static final string VL_SI_E_mandate                  = '21'; 
    public static final string KVB_LTD                          = 'THE KARUR VYSYA BANK LTD';  
    
    //VL Document Tags
    public static final string VLSANCTIONLETTER                 = 'VLSanctionLetter';
    public static final string VLDEALERPYMNTAUTH                = 'VLPaymentAuthLetter';
    public static final string VLHYPOTHECATIONLD                = 'VLHypothecationLD';
    public static final string VLDEALERACK                      = 'VLPaymentAcknoLetter';

    //VL Document---Non legal desk----prashant 25-10-2018-start
    public static final string VLSANCTIONLETTER_NLD             = 'VL_Sanction_Letter_Manual';
    public static final string VLDEALERPYMNTAUTH_NLD            = 'VL_Payment_Auth_Letter_Manual'; 
    public static final string VLHYPOTHECATION                  = 'VL_Hypothecation_Manual';
    //VL Document---Non legal desk----prashant 25-10-2018-ends
    public static final string VLCover                     = 'VLCoverLetter';
    
    //VL Sanction document  106.       
    public static final string Interest_charge_4W               = 'Compounding on monthly basis';  
    public static final string Interest_charge_2W               = 'Simple';   
    public static final string VL4W_Name                        ='Four-wheeler';   
    public static final string VL2W_Name                        ='Two-wheeler';
    
    public static final string VL2WPRODNM                   ='Digital Two wheeler loan - 774';
    public static final string VL4WPRODNM                   ='Digital four wheeler loan - 775';
    
    //VL Document Status Flag
    public static final string VL1_DOCGEN                   = 'VL1 DocGEN';//Senction letter
    public static final string VL1_C2SIGN                   = 'VL1 C2Sign';
    public static final string VL1_DOCID                    = 'VL1 DocID';
    public static final string VL2_DOCGEN                   = 'VL2 DocGEN';//Dealer Payment Auth Letter
    public static final string VL2_C2SIGN                   = 'VL2 C2Sign';
    public static final string VL2_DOCID                    = 'VL2 DocID';
    public static final string VL3_DOCGEN                   = 'VL3 DocGEN';//Dealer Payment Ack Letter 
    public static final string VL3_C2SIGN                   = 'VL3 C2Sign';
    public static final string VL3_DOCID                    = 'VL3 DocID';
    public static final string VL4_DOCGEN                   = 'VL4 DocGEN';//Hypothecation LD Letter 
    public static final string VL4_C2SIGN                   = 'VL4 C2Sign';
    public static final string VL4_DOCID                    = 'VL4 DocID';
    public static final string VL5_DOCGEN                   = 'VL5 DocGEN';//Hypothecation NonLD Letter 
    public static final string VL5_C2SIGN                   = 'VL5 C2Sign';
    public static final string VL5_DOCID                    = 'VL5 DocID';
    
    public static final string VL6_DOCGEN                   = 'VL6 DocGEN';//Cover Letter 
    public static final string VL6_C2SIGN                   = 'VL6 C2Sign';
    public static final string VL6_DOCID                    = 'VL6 DocID';
    
    //VL Stamp Duty //States
    public static final string ANDHRA_PRADESH               = 'ANDHRA PRADESH';
    public static final string GUJARAT                      = 'GUJARAT';
    public static final string KARNATAKA                    = 'KARNATAKA';
    public static final string MAHARASHTRA                  = 'MAHARASHTRA';
    public static final string TELANGANA                    = 'TELANGANA';
    
    //VL Stamp Duty //Loan Amount
    public static final integer STAMPDUTY2LAKHS             =200000;
    public static final integer STAMPDUTY3LAKHS             =300000;
    public static final integer STAMPDUTY8LAKHS             =800000;
    public static final integer LOANAMOUNT5LAKHS            =500000;
    public static final integer LOANAMOUNT10LAKHS           =1000000;
    public static final integer LOANAMOUNT10CRORES          =100000000;
    
    //VL Stamp Duty %
    public static final Decimal STAMPDUTYPERCENT_PT5        =0.5;
    public static final Decimal STAMPDUTYPERCENT_PT25       =0.25;
    public static final Decimal STAMPDUTYPERCENT_PT2        =0.2;
    public static final Decimal STAMPDUTYPERCENT_PT1        =0.1;
    
    //VL SchemeMaster related Tags.
    public static final Decimal VL2WLESS_2L75PRCNT        =0.75; //2 Wheeler 75% of lessthen 2lac Vehicle cost
    public static final Decimal VL2WGRET_2L85PRCNT        =0.85; //2 Wheeler 85% of Morethen 2lac Vehicle cost
    public static final Decimal VL4WEQUL_VL90PRCNT        =0.90; //4 Wheeler 90% of Vehicle cost
    public static final Decimal VL_MSTRVLCOSTPRCNT        =1.05; //Overall Final Vehicle cost 1.05 of Showroom price.
    //KVB EMI Tags
    public static final string NONKVB   ='NOT DISCLOSED';
    public static final string TUHL     ='Personal Loan';
    public static final string TUPL     ='Housing Loan';
    public static final string TULAP    ='Property Loan';
    public static final integer NMONTHS = 3;
    
    // Specific to SME
    public static final string SME_PRODUCT_CODE                     = 'WC';
    public static final string PRIMARY_SECURITIES                   = 'Primary Securities';
    public static final string COLLATERAL_SECURITIES                = 'Collateral Securities';
    public static final string SANCTION_TEMPLATE_SME                = 'SME_SanctionLetter';
    public static final string PROV_SANCTION_TEMPLATE_SME           = 'SME_ProvisionalSanctionLetter';
    public static final string SME_DOC_CATEGORY                     = 'SME Financial Document';
    public static final string SITE_BASE_URL                        = System.Label.Site_doc_URL;
    public static final string SME_SANCTION_Letter123               = 'SME_SanctionLetter';
    public static final string SME_SANCTION_Letter12                = 'SME_Sanction_Letter12';
    public static final string SME_SANCTION_Letter1                 = 'SME_Sanction_Letter1';
    public static final string SME_SANCTION_Letter13                = 'SME_Sanction_Letter13';
    public static final string M68C_BALANCE_SHEET_TEST_ID           = 'a7N5D0000008PGD';
    public static final string EMAIL_REASON                         = 'EMAIL_IDENTIFIER';
    public static final string MOB_REASON                           = 'Loan Sanctioned';
    public static final string SME_YES                              = 'Yes';
    public static final string APP_STAGE_PERFIOS_ERROR              = 'Perfios error';
    public static final string APP_STAGE_CLOSE                      = 'Limit renewed/Application close';
    public static final string APP_STAGE_WB_CUST                    = 'Withdrawn by customer';
    public static final string CONSTITUTION_DOCUMENT_CATEGORY       = 'Constitution Document Category';
    public static final string DOC_NAME_SME                         = 'SME_SanctionLetter';
    public static final string FINANCIAL_DONE                       = 'Financials done';
    public static final string RLPC_FINANCIAL_TASK                  = 'Review financials uploaded by customer';
    public static final string CLPC_FINANCIAL_TASK                  = 'CLPC task for uploading financials';
    public static final string LEGAL_EVALUATION_TASK                = 'Legal Evaluation';
    public static final string COMMITTEE_EXCLUDE_DESIGNATION        = 'DOCC:BR_MGR_SMALL:BR_MGR_MEDIUM:BR_MGR_LARGE:BR_MGR_VERYLARGE:BR_MGR_XPLARGE';
    public static final String TASK_TEMPLATE_MANAGER                = 'Task_Notification';
    public static final String PROPERTY_LIST_INSERT                 = 'Property list insert';
    public static final String PROPERTY_LIST_UPDATE                 = 'Property list update';
    public static final String FACILITY_LIST_UPDATE                 = 'Facility list update';
    public static final String LIST_OF_LIMIT_ASSESSMENT             = 'List of limit Assessment';
    public static final String LIST_OF_LIMIT_ASSESSMENT_C           = 'List of limit Assessment c';
    public static final String LIST_OF_ACCOUNT                      = 'List of Account';
    public static final String LIST_OF_DEBTORS_INSERT               = 'List of Debtors insert';
    public static final String LIST_OF_DEBTORS_UPDATE               = 'List of Debtors update';
    public static final String LIST_OF_CREDITORS_INSERT             = 'List of creditors insert';
    public static final String LIST_OF_CREDITORS_UPDATE             = 'List of creditors update';
    public static final String COLLATERAL_RECTYPE_OTHER             = 'Other';
    public static final String COLLATERAL_TYPE_FIXED_DEPOSIT        = 'Fixed Deposit';
    public static final String COLLATERAL_TYPE_NSC_KVP              = 'NSC/KVP';
    public static final String COLLATERAL_TYPE_INSURANCE_POLICIES   = 'Insurance Policies';
    public static final String COLLATERAL_TYPE_VEHICLES             = 'Vehicles';
    public static final String LEGAL_CLEARANCE_PENDING              ='Legal Clearance Pending';
    public static final String LEGAL_CHARGES_RESULT                 ='Success';
    public static final String COLLATERAL_TYPE_MACHINERY            = 'Machinery';
    public static final String CUSTOMER_RESPONDED_TASK_SUBJECT      = 'Customer Responded to Query';
    public static final Set<String> allSMERecordTypeDeveloperName = new Set<String>{'SME_Renewal','SME_Exceeding','SME_Enhancement','SME_AdHoc','SME_NEW_Loan'};
        public static final String NEW_LOAN_FINAL_SANCTION              = 'New loan - Final sanction';
    public static final String NEW_LOAN_FINAL_SANCTION_ACCEPTED    ='New Loan- Final Sanction Accepted';
    public static final String NEW_LOAN_FINAL_SANCTION_OFFERED      = 'New Loan - Final sanction offered';
    public static final String ACCOUNT_CLOSE                =  'Account Closed';
    public static final String BANK_STATEMENT_CATEGORY      = 'BANK STATEMENT CATEGORY';
    public static final String SANCTION_LETTER_CATEGORY     = 'SANCTION LETTER CATEGORY';
    public static final String SUPPORTING_DOCS_CATEGORY     = 'SUPPORTING DOCS CATEGORY';
    //Specific to PL
    public static final string PL_PRODUCT_CODE              = 'PL910';
    public static final string InvalidCIBIL                 = 'Invalid CIBIL';
    public static final string CIBILRejectedMsg             = 'Customer does not have a valid CIBIL score, loan cannot be processed';
    public static final string LowCIBILScoreMsg             = 'Customer CIBIL score is less than 750, loan cannot be processed';
    public static final string APP_REJECTED_STAGE           = 'Application Rejected';
    public static final string EXPERIAN                     = 'experian';
    public static final string PL_LOAN_STP                  = 'Loan Sanctioned STP';
    public static final string PL_DISBURSMNTFAIL_SEQ_NO     = '20';
    public static final string SUBSTAGE_DISBURSEMENTESIGN   = 'Disbursement Documents Esigned';
    public static final string PL_SI_KVB                    = 'Karur Vysya Bank';
    //PL Interest Rate Tags
    public static final integer PLIR_12                     =12;
    public static final integer PLIR_13                     =13;
    public static final integer PLIR_14                     =14;
    public static final integer PLIR_15                     =15;
    public static final integer PLIR_16                     =16;
    public static final integer PLIR_18                     =18;
    //FI Status falgs
    public static final string PL_FIREQ_INIT                = 'Request yet to be initiated';
    public static final string PL_FIRES_OBTN                = 'Response to be obtained'; 
    public static final string PL_FIRES_POSI                = 'Positive';
    public static final string FI_Nega                      = 'Negative';
    public static final string FI_Refer                     = 'Refer';
    public static final string PL_FIRES_FRUD                = 'Fraud';
    public static final string PL_FINOTAPPLICABLE           = 'Not Applicable';
    public static final string FI_MANUAL                    = 'Manual';
    public static final string GREATER_THAN_2CR             = 'Greater than 2Cr.';
    public static final string ENHANCEMENT_CUSTOM_SETTING   = 'Enhancement Excluded stages';
    //Document generation PL
    public static final string PRE_APPROVE_SANCTION_PL      = 'PL Sanction Letter';
    public static final string PL_DOC_DEVELOPERNAME         = 'PL_Sanction_Letter';
    public static final string PL1_DOCGEN                   = 'PL1 Doc Generation';
    public static final string PL1_CLASS2                   = 'PL1 Class 2 Sign';
    public static final string PL1_DOCID                    = 'PL1 Doc ID';
    public static final string PL_AGREEMENT_DOC             = 'PL Loan Agreement';
    public static final string PL2_DOC_DEVELOPERNAME        = 'PL_Loan_Agreement';
    //public static final string PL_loan_Agreement_Letter     = 'PL_loan_Agreement_Letter';
    public static final string PL2_DOCGEN                   = 'PL2 Doc Generation';
    public static final string PL2_CLASS2                   = 'PL2 Class 2 Sign';
    public static final string PL2_DOCID                    = 'PL2 Doc ID';
    //prashant singh----on 26/10/2018 ----changed  PL_loan_Agreement_Letter----PL Loan Agreement Manual
    public static final string PL_loan_Agreement_Letter     = 'PL_Loan_Agreement_Manual';
    public static final string PRE_APPROVE_SANCTION_PL_NLD  = 'PL_Sanction_Letter_Manual';
    
    //Document generation LAP
    public static final string PRE_APPROVE_SANCTION_LAP      = 'LAP-C1';
    public static final string LAP_DOC_DEVELOPERNAME         = 'LAP_C1';
    public static final string LAP1_DOCGEN                   = 'LAP1 Doc Generation';
    public static final string LAP1_CLASS2                   = 'LAP1 Class 2 Sign';
    public static final string LAP1_DOCID                    = 'LAP1 Doc ID';
    
    //Astute API tags
    public static final string BORROWER_TYPE                 ='Borrower';
    public static final string ACTIVITY_DESCO                ='Office';
    public static final string ACTIVITY_DESCR                ='Residence';
    public static final string EMPTYP_SALARIED               ='Salaried';
    public static final string EMPTYP_SELFEMPP               ='Self-Employed Professional';
    public static final string EMPTYP_SELFEMPB               ='Self-Employed Businessman';
    public static final string EMPTYP_AGRICULTUR             ='Agriculturist';
    public static final string EMPTYP_HOMEMAKER              ='Home maker';
    public static final string EMPTYP_NOTWORKING             ='Not Working';
    
    //Astute TAT calculation:12-12-18
    public static final string LOCAL                         ='Local';
    public static final string OCL                           ='OCL';
    public static final string OCL50_100                     ='OCL50_100';
    public static final string OCL100ABOVE                   ='OCL100Above';
    
    // Specific to HL
    public static final string HL_PRODUCT_CODE                  = 'HL001';
    public static final string EmpType_Salaried                 = 'Salaried';
    public static final string EmpType_Agricul                  = 'Agriculturist';
    public static final string EmpType_SelfProfes               = 'Self-Employed Professional';
    public static final string EmpType_Other                    = 'Other';
    public static final string EmpType_SelfEmp                  = 'Self Employed';
    public static final string MCLR_OneYear                     = 'One Year';
    public static final string MCLR_ThreeMonths                 = 'Three Months';
    public static final string HL_Value                         = 'HL';
    public static final string PersonalDetailsCapt              ='Personal Details Captured';
    public static final string Sub_Stage_PropInfoCaptured       = 'Property Information Captured';
    public static final string Sub_Stage_WorkInfoCaptured       = 'Work Information Captured';
    public static final string Sub_Stage_LoanReqCaptured        = 'Loan Requirement Captured';
    public static final string LOW_CIBIL_SCORE_SUBSTAGE         = 'Low CIBIL score';
    public static final string TermsAccepted                    = 'Terms and Conditions Accepted';
    public static final string AppCreated                       = 'Application Created';
    public static final string InitaiteMOD                      = 'MOD Initiated';
    public static final string ScoreLowStage                    ='Low Application Score';
    public static final string SI_DETAILS_CAPTURED_SUBSTAGE     = 'SI details captured';
    public static final string Sub_Stage_DisbuApprov            = 'Disbursement Approved';
    public static final string App_Process_Closed               = 'Application Processed - Closed';
    public static final string col_details                      = 'Collaterals details captured';
    public static final string Co_Borrower                      ='Co-Borrower';
    public static final string Gurantor                         ='Guarantor';
    public static final string IDVCall                          ='IDV';
    public static final string CIBIL                            ='CIBIL';
    public static final string PRE_Approval_Sanction_HL         = 'HL_Preapproval_Letter';
    public static final string Execution_Certificate_C11_HL     = 'C11';
    public static final string Acknowledgement_For_Sanction     = 'C1';
    public static final string Acknowledgement_For_SanctionLAP  = 'LAP_C1';
    public static final string GuarantorAgree_For_LAP           = 'LAP_A46';
    public static final String APP_ATTACHMENT_COBORROWER        = 'Execution_Certificate_C11_HL.pdf:Acknowledgement_For_Sanction.pdf';
    public static final String APP_ATTACHMENT_GUARANTOR         = 'Execution_Certificate_C11_HL.pdf:Agreement of Guarantee.pdf:Acknowledgement_For_Sanction.pdf';
    public static final string DOCKET_UPLOAD_REASON_HL          = 'HL_DisbursmentLetter';
    public static final string ParentDOCCatgName                = 'HL Documents';
    public static final string ParentDOCCatgNamePL              = 'PL Documents';
    public static final string ParentDOCCatgNameLAP             = 'LAP Documents';
    public static final string DOC_NAME_HL_BORROWER             = 'A23:B17:A66:A54';//v1.2
    public static final string DOC_NAME_HL_BORR_PH              = 'B1:B2';
    public static final string DOC_NAME_HL_GUARANTER            = 'A46';
    public static final string DOC_NAME_HL_COMMON               = 'C1:C11';
    public static final Integer TITLE_HOOLDER_LIMIT             = 15;
    public static final String KvbBank                         = 'Kvb Bank';
    public static final string Acknowledgement_For_SanctionLAP_NLD  = 'LAP_C1_Manual';
    
    //v1.2:HL MVP2
    public static final string Sub_Stage_HL_Selected            = 'HL Selected';
    public static final string Sub_Stage_Parties_Verified       = 'Parties Verified';
    public static final string Sub_Stage_Top_Up_Ineligible      = 'Top Up Ineligible';
    public static final Integer Property_Cost                   = 20000000 ;
    public static final string Sub_Type_Top_Up                  = 'Top Up';
    public static final string Sub_Type_Take_Over               = 'Take Over';
    public static final string Sub_Type_Reimbursement           = 'Reimbursement';
    public static final Decimal ProcessingFee_HL_TopUp          = 0.005;
    public static final string HL_Topup_A66                     = 'A66';
    public static final string HL_Takeover_A54                  = 'A54';
    public static final string HL_Topup_A66_Manual              = 'HL_TakeOver_A54_Manual';
    public static final string HL_Takeover_A54_Manual           = 'HL_TopUp_A66_Manual';
    public static final string DocrecCanc    			        ='Existing Banker\'s cancellation of MOD';
    public static final string DocOrginSale                     ='Original Sale Deed';
    
    //HL revised digio manual doc names/tags
    public static final string HL_DIGIO_MANUAL_A23                            = 'HL_A23_Manual';
    public static final string HL_DIGIO_MANUAL_A46                            = 'HL_A46_Manual';
    public static final string HL_DIGIO_MANUAL_B17                            = 'HL_B17_Manual';
    public static final string HL_DIGIO_MANUAL_B1B2                           = 'HL_B1_Manual';
    public static final string HL_DIGIO_MANUAL_C1C11                          = 'HL_C1_Manual';
    
    // E-stamp document name
    public static final string A23_HL                           = 'A23';
    public static final string A46_HL                           = 'A46';
    public static final string LAP_B1                           = 'LAP_B1';
    public static final string B1_HL                            = 'B1';
    public static final string B2_HL                            = 'B2';
    public static final string B17_HL                           = 'B17';   
    public static final string LAP_A46                          = 'LAP_A46';
    public static final string LAP_A23                          = 'LAP_A23';
    
    public static final string LAP_A23D_LAFA                    = 'LAP_A23_Manual';
    public static final string LAP_A46DOC                       = 'LAP_A46_Manual';
    public static final string LAP_B1_B2DOC                     = 'LAP_B1_';
    public static final string LAPMOD                           = 'LAPMOD';
    public static final string DISBURSE                         = 'Disburse';
    public static final string MOD                              = 'MOD';
    public static final string LAPADOC                          = 'LAPADOC';
    
    public static final string Loanpurpose                  = 'Property not Identified';
    public static final string Construction                 = 'Construction on Own Land';
    public static final string IdentifiedProperty           = 'Purchase of Identified Property';
    public static final string RepairHouse                  = 'Repair or Renovation of House';
    public static final string ConstructionOn               = 'Purchase of land and construction there on';
    
    // Cibil & IDV
    public static final string IDVRejeted                   = 'IDV Rejected';
    public static final string CIBILRejected                = 'CIBIL Rejected';
    public static final string LowCIBILScore                = 'Low CIBIL Score';
    public static final string CIBILRejectMessage          = 'There are no financial applicants or co-applicant attached to this application with CIBIL score > -1';
    
    // HL DOc Generation Checks
    public static final string PreApproveGenerated                 ='Pre-Approval Doc generation';
    public static final string PreApproveClass2                    ='Pre-Approval Class2';
    public static final string C1docGen                            ='C1 Doc Generation';
    public static final string C1class2Sign                        ='C1 Class 2 Sign';
    public static final string C1DocID                             ='C1 Doc ID';
    public static final string C11DocGen                           ='C11 Doc Generation';
    public static final string C11DocID                            ='C11 Doc ID';
    public static final string A23DocGen                           ='A23 Doc Generation';
    public static final string A23Class2                           ='A23 Class 2 Sign';
    public static final string A23DocID                            ='A23 Doc ID';
    public static final string B17DocGen                           ='B17 Doc Generation';
    public static final string B17DocID                            ='B17 Doc ID';
    public static final string A46DocGene                          ='A46 Doc Generation';
    public static final string A46Class2sign                       ='A46 Class 2 Sign';
    public static final string A46DocID                            ='A46 Doc ID';
    public static final string B1DOcGene                           ='B1 Doc Generation';
    public static final string B1DOcID                             ='B1 Doc ID';
    public static final string B2DocGene                           ='B2 Doc Generation';
    public static final string B2DocID                             ='B2 Doc ID';
    public static final string A66DocGene                          ='A66 DocGEN';
    public static final string A66Class2sign                       ='A66 C2Sign';
    public static final string A66DocID                            ='A66 DocID';
    public static final string A54DocGene                          ='A54 DocGEN';
    public static final string A54Class2sign                       ='A54 C2Sign';
    public static final string A54DocID                            ='A54 DocID';
    
    //LAP
    public static final string LAPC1DocGene                           ='LAP C1 Doc Generation';
    public static final string LAPC1DocID                             ='LAP C1 Doc ID';
    
    // HL Amount Values
    public static final Decimal OneCrore                           = 10000000;
    public static final Decimal NintyThreeLakhs                    = 9375000;
    public static final Decimal SeventyFiveLakhs                   = 7500000;
    public static final Decimal SevenFivePer                       = 0.75;
    public static final Decimal EightyPer                          = 0.8;
    public static final Decimal Seventy                            = 0.7;
    public static final Decimal one                                = 1;
    public static final Decimal Fifteen                            = 15;
    // HL Document Categorys
    public static final string CustPhoto='Photo';
    public static final string CustAddresProof='Current_Add_Proof';
    public static final string PropVerifiReport='Property_verification_Docs';
    public static final string LegalOpinion='Legal_Opinion';
    public static final string ValuReport='Valuation_report';
    public static final string FIReport='FI_Report';
    public static final string IncomeDocuments='Income_Docs';
    public static final string MainIncome='Main_Income';
    public static final string ITR='ITR';
    public static final string AgriIncomeProof='Agri_Income';
    public static final string ShareProfIncoProof='Share_of_profit_income';
    public static final string RentalIncomeProof='Rental_income';
    public static final string PensIncoemProof='Pension_income';
    public static final string Others='Others';
    public static final string PropertyDocuments='Property_Docs';
    public static final string LoanDocuments='Loan_Docs';
    public static final string UploadEC='UploadEC';
    public static final string Uploadcomfortletter = 'Upload_comfort_letter'; 
    public static final string UploadInsurance = 'Upload_Property_Insurance'; //to upload property insurance related document (By Ashish Jain)
    public static final string CreditInsurancePolicy = 'Credit Insurance Policy';
    public static final string FormAS = '26AS'; 
    public static final string BankStatement = 'Bank Statement'; 
    // v1.1 Start
    public static final string KYCDocumnents = 'KYC Proof';
    public static final string PermanantAdd = 'Permanant_Add_Proof'; 
    public static final string IdentityProof = 'Identity_Proof';
    // V1.1 End
    public static final string custDec       = 'Customer_Declaration';

    //HL MVP2
    public static final string Original_Sanction_Letters = 'Original Sanction Letters';
    public static final string Loan_Account_Statement = 'Loan Account Statement'; 
    //public static final string Latest_Loan_Schedule = 'Latest Outstanding Letter';//Latest Loan Schedule
    public static final string Original_Payment_Receipts = 'Original Payment Receipts' ;
    public static final string DOcuments_Other_Bank = 'Documents from Other Bank';
    //public static final string DocList_Bank_Letterhead = 'List of documents submitted to bank on bank letterhead';
    
    
    //DIGIO Template Names
    public static final string Test_Template          = 'Test_HL';
    
    // HL_IDV CIbil
    public static final string HL_CibilRecordType   ='HL_TU';
    
    // HL_Perfios Key
    public static final string E_Amount ='E_AMOUNT_BALANCE_MISMATCH';
    public static final string E_Api    ='E_API_SESSION_EXPIRED';
    public static final string E_NAccept='E_NOT_ACCEPTED';
    public static final string E_N_Accnt='E_NO_ACCOUNT';
    public static final string E_NErr   ='E_NO_ERROR';
    public static final string E_othe   ='E_OTHER';
    public static final string E_SITE   ='E_SITE';
    public static final string E_sys    ='E_SYSTEM';
    public static final string E_UAct   ='E_USER_ACTION';
    public static final string E_usBloc ='E_USER_BLOCKED';
    public static final string E_usCanc ='E_USER_CANCELLED';
    public static final string E_uSExpir='E_USER_SESSION_EXPIRED';
    public static final string E_wCredent='E_WRONG_CREDENTIALS';
    
    // HL perfios values
    public static final string IBSPtry='Incorrect Bank Statements. Please try again.';
    public static final string Pta='Please try again.';
    public static final string IBAPtanothAcc='Invalid bank account. Please try another account or another mode of input.';
    public static final string NoErr='No errors';
    public static final string ILCPta24='Incorrect login credentials. Please try again after 24 hours or use upload option.';
    
    public static final string PFITR='ITR';
    
    //DIGIO Document Names
    public static final string Test_Document          = 'Test_HL';
    
    //Underwriting Dashboard Constants
    public static final string SANCTION_AUTHORITY_AUDIT_RTYPE   = 'Sanction_Authority';
    public static final string SANCTION_AUTHORITY_LABEL         = 'Sanction Authority';
    public static final string UNDERWRITING_T_N_C               = 'Underwriting T&C';
    public static final string UNDERWRITING_PRE_T_N_C           = 'Pre-Disbursement Terms and Condition';
    public static final string CU_CHILD_APP_SCORE_RECORD_TYPE   = 'Child_Application_Score';
    public static final string CU_CHILD_FLAG_RECORD_TYPE        = 'Child_Flag';
    public static final string SYSTEM_ADMIN_PROFILE             = 'System Administrator';
    public static final string APPLICATION_REVIEW_STAGE         = 'Application review';
    public static final string APP_DEVIATION_PENDING_STAGE      = 'Application deviation pending';
    public static final string APP_FILLING_FINAL_STAGE          = 'Application Filling - Final';
    public static final string APP_REVIEW_FINAL_STAGE           = 'Application Review - Final Authority';
    public static final string INTERIM_EXTENSION_LABEL          = 'For Interim Extension';
    public static final string RENEWAL_LABEL                    = 'For Renewal';
    public static final string BRE_DONE_FINANCIALS              = 'BRE rule engine completed-with financials';
    public static final string APP_REVIEW_FINANCIAL_STAGE       = 'Application review -with financials';
    public static final string APP_DEVIATION_FINANCIAL_STAGE    = 'Application deviation pending-with financials';
    public static final string RECOMMENDED_CHANGE_TYPE_HISTORY  = 'Recommendation Change';
    public static final string FACILITY_CHILD_RECORD_TYPE       = 'Child';
    public static final string FACILITY_PARENT_RECORD_TYPE      = 'Parent';
    public static final string NO_STRING                        = 'No';
    public static final string SOD_CATEGORY                     = 'SOD';
    public static final string OCC_CATEGORY                     = 'OCC';
    public static final string MANUFACTURING_INDUSTRY           = 'Manufacturing';
    public static final string TRADING_INDUSTRY                 = 'Trading';
    public static final string APPROVE_ACTION                   = 'Approve';
    public static final string RECOMMEND_TO_HIGHER_ACTION       = 'Recommend to higher authority';
    public static final string INTERIM_SANCTION_STAGE           = 'Interim Sanction';
    public static final string FINAL_SANCTION_STAGE             = 'Final Sanction';
    public static final string SME_RENEWAL_APPROVED             = 'Working Capital Renewal Approved.';
    public static final string SUCCESS_STATUS                   = 'Success';
    public static final string MARK_EXIT_ACTION                 = 'Mark as exit';
    public static final string REJECT_ACTION                    = 'Reject';
    public static final string EXIT_STAGE                       = 'Marked as exit';
    public static final string SME_RENEWAL_REJECTED             = 'Working Capital Renewal Rejected.';
    public static final string AUTHORITY_REVIEW_SENT            = 'Application sent for higher authority review.';
    public static final string DEVIATION_MESSAGE                = 'Deviation identified with respect to your current change.Notifed to higher authority.';
    public static final string DEVIATION_STATUS                 = 'Deviation';
    public static final string COMPLETED_STATUS                 = 'Completed';
    public static final string ERROR_STATUS                     = 'Error';
    public static final string EXCEPTION_MESSAGE                = 'There is some error while saving your changes. Please try later.';
    public static final string RECORD_SAVED_MSG                 = 'Input saved successfully.Application moved to next authority.';
    public static final string ERROR_MESSAGE                    = 'Oops! Somthing went wrong.Please try again.';
    public static final string PENDING_APP_SUBJECT              = 'Application Approval Pending: Deviation';
    public static final string APPROVE_ALERT_MESSAGE            = 'The deviation has been approved.';
    public static final string REJECTALERT_MESSAGE              = 'The deviation has been rejected.';
    public static final string SANCTION_SUCC_MESSAGE            = 'Approved.';
    public static final string SANCTION_REJ_MESSAGE             = 'Rejected.';
    public static final string COCC_ROLE                        = 'COCC';
    public static final string APPLN_INITIATED                  = 'Identified for renewal';
    public static final string APPLN_MORE_THAN_6_MONTH          = '>6 months due for renewal';
    public static final string TL_INITIATED                     = 'TL Open Applications';
    public static final string NEW_LOAN_UNDER_PROCESS           = 'New Loan under process';
    public static final string ENHANCEMENT_LOAN_UNDER_PROCESS   = 'Enhancement Loan under process';   
    public static final string TASK_STATUS_NOT_STARTED          = 'Not Started';
    public static final string ENHANCEMENT_APPLICATION_CREATED  = 'Enhancement- Application created';
    // Deviation Rule Name
    public static final string ROI_SCHEMATIC_RULE               = 'ROI';
    public static final string ROI_NON_SCHEMATIC_RULE           = 'ROI-Non Schematic';
    public static final string COMISSION_BG_RULE                = 'COMISSION BG';
    public static final string PROCESSING_CHARGE_SCHEMATIC      = 'PROCESSING CHARGE SCHEMATIC';
    public static final string PROCESSING_CHARGE_NON_SCHEMATIC  = 'PROCESSING CHARGE NON SCHEMATIC';
    public static final string MARGIN_SOD                       = 'Margin for SOD';
    public static final string MARGIN_STOCK_MANUFACTURING       = 'Margin Stock Manufacturing';
    public static final string MARGIN_STOCK_TRADING             = 'Margin Stock Trading';
    public static final string MARGIN_RECIEVABLES               = 'Margin Recievables';
    public static final string PROV_EXTENTION                   = 'Provisional Extension';
    public static final string FINAL_REVIEW                     = 'Renewed';
    public static final string LETTER_VALID_DATE                = 'one year';
    public static final string APP_FINAL_DEVIATION              = 'Application Review - Deviation Pending';
    public static final string UNDERWRITING_T_C_RTYPE           = 'Underwriting_T_C';
    public static final string PREDISBURSEMENT_T_C_RTYPE        = 'Pre_Disbursement_T_C';
    public static final string PRESIDENT_COO_API                = 'President_COO';
    public static final string PRESIDENT_COO_NAME               = 'President & COO';
    public static final string APPROVED_STATUS                  = 'Approved';
    public static final string REJECTED_STATUS                  = 'Rejected';
    public static final string PRIMARY_APP                     = 'Primary Applicant';
    
    //genesis__Aplication__c related record type constant
    public static final string SME_RENEWAL = 'SME_Renewal';
    public static final string SME_ADHOC = 'SME AdHoc';
    public static final string SME_ENHANCEMENT = 'SME Enhancement';
    public static final String LAND_BUILDING_OTHER  = 'Land_And_Buildings_Other';
    
    //Jocata list match task creation field
    public static final String APPLICATION_STATGE_TNC_ACCEPTED = 'Terms and Conditions Accepted';
    
    //Conditions LOS
    public static final String CONDITIONS_LOS = 'Amounts received under the above Credit facility cannot be utilized for any share market activities and other speculative activities and all the relevant guidelines stipulated by RBI are met from time to time';
    
    //SME CBS API.
    public static final String CODE_ACCT_CUST_REL1              = 'SOW';
    public static final String CODE_CUST_2                      = '0';
    public static final String CODE_CUST_3                      = '0';
    public static final String FLG_SC_WAIVER                    = 'N';
    public static final String FLG_INT_WAIVER                   = 'N';
    public static final String CODE_OFFICER_ID                  = 'LAPSCHECKER';
    public static final String CODE_MAKER_ID                    = 'LAPSMAKER';
    public static final String CODE_CHECKKER_ID                 = 'LAPSCHECKER';
    public static final String CODE_LANG                        = 'ENG';
    public static final String FLAG_JOINT_ACC                   = 'N';
    public static final String CODE_MODULE                      = 'CH';
    public static final String CODE_TDS                         = '999';
    public static final String CODE_TDS_2                       = '999';
    public static final String USER_ID                          = 'LAPSMAKER';
    
    public static final String FUNDED    = 'Funded';
    public static final String NONFUNDED = 'Non-Funded';
    
    //Application Sub_Stage__c and Application_Stage__c picklist value
    public static final string APPLICATION_CREATED_SUBSTAGE                 = 'Application created';
    public static final string VEHICLE_DETAILS_CAPTURED_SUBSTAGE            = 'Vehicle details captured';
    public static final string PLE_APPROVED_SUBSTAGE                        = 'Pre-approved';
    public static final string WORK_INFORMATION_CAPTURED_SUBSTAGE           = 'Work information Captured';
    public static final string LOAN_REQUIREMENT_CAPTURED_SUBSTAGE           = 'Loan requirement Captured';
    public static final string PERSONNAL_DETAILS_CAPTURED_SUBSTAGE          = 'Personal Details Captured';
    public static final string PROCESSING_FEE_PAID_SUBSTAGE                 = 'Processing Fee Paid';
    public static final string TERMS_AND_CONDITIONS_ACCESPT_SUBSTAGE        = 'Terms and Conditions Accepted';
    public static final string LOAN_SANCTIONED_STP_SUBSTAGE                 = 'Loan Sanctioned STP';
    public static final string LOAN_SANCTIONED_NON_STP_SUBSTAGE             = 'Loan Sanctioned Non-STP';
    public static final string DISBURSEMENT_INFO_CAPTURED_SUBSTAGE          = 'Disbursement Info Captured';
    public static final string SI_DETAILS_CAPTURED_SUBSTAGE1                 = 'SI details captured';
    public static final string DISBURSEMENT_DOCUMENTS_ESIGNED_SUBSTAGE      = 'Disbursement Documents Esigned';
    public static final string LOAN_ACCOUNT_OPENED_SUBSTAGE                 = 'Loan Account Opened';
    public static final string APPLICATION_PROCESSED_CLOSED_SUBSTAGE        = 'Applicaton Processed - Closed';
    public static final string LOW_CIBIL_SCORE_SUBSTAGE1                     = 'Low CIBIL score';
    public static final string AGE_INELIGIBLE_SUBSTAGE                      = 'Age Ineligible';
    public static final string FI_REJECTED_SUBSTAGE                         = 'FI Rejected';
    public static final string REJECTED_BY_BRANCH_MANAGER_SUBSTAGE          = 'Rejected by branch manager';
    public static final string INCOME_ASSESMENT_REJECTED_SUBSTAGE           = 'Income assessment rejected';
    public static final string INCOME_REJECTED_SUBSTAGE                     = 'Income rejected';
    public static final string LOW_APPLICATION_SCORE_SUBSTAGE               = 'Low application score';
    public static final string SAVED_APPLCIATION_MAINSTAGE                  = 'Saved applications';
    public static final string DISBURSEMENT_APPLICATIONS_MAINSTAGE          = 'Disbursement applications';
    public static final string DISBURSED_APPLICATION_MAINSTAGE              = 'Disbursed application';
    public static final string APPLICATION_REJECTED_MAINSTAGE               = 'Application Rejected';
    public static final string DEACTIVATED_APPLICATIONS_MAINSTAGE           = 'Deactivated Applications';
    
    public static final list<String> SME_RECORD_TYPE_LIST = new list<String>{'SME_Enhancement','SME_AdHoc','SME_NEW_Loan'};
        public static final list<String> SME_APP_STAGES_LST = new list<String>{'Adhoc- Application submitted','Enhancement- Application submitted',
            'Exceeding- Application submitted',
            'New loans- Application submitted'
            };
                public static final list<String> fetch_reason= new list<String>{'Interest rate too high','Insufficient loan amount - eligibility','Insufficient loan amount - policy limit','Do not want to apply for GMRA','Processing Fee too high','Do not want to pay processing fee before formal sanction','Other'};                                                                              
                    
                    //form26
                    public static final string form26Section='192';
    public static final list<String> SME_PROCESSING_FEE_LIST = new list<String>{'SME Enhancement'}; // ,'SME AdHoc','SME Exceeding'  
        
        //for auto Bre Run.
        public static final List<String> listOfTaskOfNewLoan       = new List<String>{'Qualitative Input Needed','Takeover Intelligence','Verified diff b/w App Exposure and TU Exposure as per Application','Financial Upload'};
            public static final List<String> listOfTaskOfNewLoan_NTB   = new List<String>{'Qualitative Input Needed','Takeover Intelligence','Market Intelligence','Verified diff b/w App Exposure and TU Exposure as per Application','Financial Upload'};    
                public static final List<String> listOfTaskOfEnhacement    = new List<String>{'Qualitative Input Needed','Financial Upload'};
                    public static final List<String> listOfTaskOfExceeding     = new List<String>{'Qualitative Input Needed'};                                                                         
                        
                        /* New Doc Flow*/
                        public static final string Preclosure_Charge = '2';
    public static final string Penal_Charges = '2';
    //cibil tag
    public static final string Transunion='transunion';
    //RMD task tag
    public static final Decimal PlNTB        =0.5;
    public static final Integer Plcibil        =750;
    public static final Integer Plage        =55;
    public static final Integer PlLoanamount        =500000;
    
    public static final string RegistrationNot='Registration does not exist';

    public static final set<String> expansion_CriteriaList= new set<String>{'Expanding own business','Starting a new venture','Moving to own premises','Letting out to third parties','Maintaining the premises','Replacing a machinery','Upgrading existing machinery','Replacing a vehicle','Replacing a construction equipment','Using for administrative purpose'};
    public static final set<String> newLoanTypeOfRequest= new set<String>{'Takeover','Fresh Loan','Enhancement'};
}