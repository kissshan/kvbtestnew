/*
* Name    : WS_Vendor_Constants
* Company : ET Marlabs
* Purpose : This class is used for all constants for 3rd party loan onboarding.
* Author  : Bhavya
*/
public class WS_Vendor_Constants{

    //Response related
    public static final string WS_SUCCESS_STATUS = 'Success';
    public static final string WS_SUCCESS_CODE = '200';
    public static final string WS_NO_ERROR = 'NO_ERROR';
    public static final string WS_ERROR_STATUS = 'Error';
    public static final string WS_ERROR_CODE  = '400';
    public static final string WS_REQ_BODY_IS_NULL = 'REQUEST_BODY_IS_NULL';
    public static final string WS_INTERNAL_ERROR = 'Server encountered an unexpected condition that prevented it from fulfilling the request.';
    public static final string WS_ERROR_TYPE  = 'Bad Request';
    public static final string WS_ERROR_INTERNAL_CODE  = '500';
    public static final string WS_ERROR_TYPE_INTERNAL  = 'Internal Server Error';
    
    //Third Party
    public static final string THIRDPARTY_HOMECREDIT = 'Home Credit';
    
    //Classes In Logs
    public static final string CLASS_CreateApplicationAndAccount = 'WS_Vendor_CreateApplicationAndAccount';
    
    //CBS
    public static final string CBS_INITIATION_DONE='CBS Process has been initiated succesfully';
    public static final string NO_PHOTO='Please attach photos for all the applicants';

    //Loan and applicant types
    public static final string PRIMARY_APP = 'Primary Applicant';
    public static final string CO_BORROWER = 'Co-Borrower';
    public static final string HOMELOAN = 'Home Loan';
    public static final string LAPLOAN = 'LAP';
    public static final string PERSONALLOAN = 'Personal Loan';
    public static final string VL4W ='VL4W';
    public static final string VL2W ='VL2W';

    //Document main folders
    public static final string PARENT_CATEGORY_HL = 'HL Documents';
    public static final string PARENT_CATEGORY_LAP = 'LAP Documents';
    public static final string PARENT_CATEGORY_PL = 'PL Documents';
    public static final string PARENT_CATEGORY_VL ='VL Documents';
    
    //Stage and substage
    public static final string STAGE = 'Disbursement Applications';
    public static final string SUB_STAGE_CBS_PENDING = '3rd Party CBS Pending';
    public static final string SUB_STAGE_APP_CREATED = '3rd Party Application Created';
    public static final string SUB_STAGE_CO_ADDED = '3rd Party Co-borrower Added';
    public static final string SUB_STAGE_CBS_INITIATED = '3rd Party CBS Initiated';
    
    //Account record types
    public static final string BUSINESS_ACCOUNT = 'Business Account';
    public static final string PERSON_ACCOUNT = 'Person Account';

    //Roles and designations
    public static final string BRANCH_MANAGER = 'Nodal Officer';
    public static final string RLPC_HEAD = 'RLPC Head';
    public static final string NODAL_OFFICER = 'Third Party Nodal Officer';

    //Folders and sub folder
    public static final string CustPhoto = 'Photo';
    public static final string KYCDocumnents = 'KYC Proof';
    public static final string FIReport = 'FI_Report';
    public static final string IncomeDocuments = 'Income_Docs';
    public static final string PropertyDocuments = 'Property_Docs';
    public static final string LoanDocuments = 'Loan_Docs';
    public static final string CreditInsurancePolicy = 'Credit Insurance Policy';
    public static final string Others = 'Others';
    public static final string PropVerifiReport = 'Property_verification_Docs';
    public static final string UploadEC = 'UploadEC';
    public static final string UploadInsurance = 'Upload_Property_Insurance';
    public static final string Uploadcomfortletter = 'Upload_comfort_letter';
    public static final string MainIncome = 'Main_Income';
    public static final string AgriIncomeProof = 'Agri_Income';
    public static final string ShareProfIncoProof = 'Share_of_profit_income';
    public static final string RentalIncomeProof = 'Rental_income';
    public static final string PensIncoemProof = 'Pension_income';
    public static final string ITR = 'ITR';
    public static final string FormAS = '26AS';
    public static final string BankStatement = 'Bank Statement';
    public static final string CustAddresProof = 'Current_Add_Proof';
    public static final string PermanantAdd = 'Permanant_Add_Proof';
    public static final string IdentityProof = 'Identity_Proof';
    public static final string LegalOpinion = 'Legal_Opinion';
    public static final string ValuReport = 'Valuation_report';
    public static final string CibilReport= 'CIBIL Report';
    public static final string AppForm = 'Application Form';
    public static final string C1 = 'C1';
    public static final string C11 = 'C11';
    public static final string A23 = 'A23';
    public static final string B17 = 'B17';
    public static final string A46 = 'A46';
    public static final string B1B2 = 'B1/B2';
    public static final string MODDoc = 'MOD Document';
    public static final string Tripartite = 'Tripartite agreement';
    public static final string DisbursementRequest = 'Request for disbursement';
    public static final string OtherIncome = 'Other_Income';
    public static final string LoanAgreement = 'Loan Agreement';
    public static final string SanctionLetter = 'Sanction Letter';
    public static final string VLSanctionLetter = 'VLSanctionLetter';
    public static final string VLPaymentAuthLetter = 'VLPaymentAuthLetter';
    public static final string VLHypothecationLD = 'VLHypothecationLD';
    public static final string VlDealerPaymentLetter = 'VlDealerPaymentLetter';
    public static final string VEHICLE_INSURANCE = 'Vehicle Insurance';
    public static final string UPLOAD_VEHICLE_INSURANCE = 'Upload_Vehicle_Insurance';
    
    //max and min loan amount
    public static final Decimal Max_HL = 6000000;
    public static final Decimal Min_HL = 200000; 
    public static final Decimal Max_LAP = 10000000;
    public static final Decimal Min_LAP = 1000000; 
    public static final Decimal Max_PL = 1000000;
    public static final Decimal Min_PL = 50000; 
     public static final Decimal Max_V2W = 5000000;
    public static final Decimal Min_V2W = 10000; 
    public static final Decimal Max_V4W = 10000000;
    public static final Decimal Min_V4W = 100000;  
}