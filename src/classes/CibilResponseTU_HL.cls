public class CibilResponseTU_HL{
    public String Status;   //String
    public string Provider; //provider type 
    public cls_Authentication Authentication;
    public cls_ResponseInfo ResponseInfo;
    public cls_ContextData ContextData;
    public string errorCode;
    public string errorMessage;
    public class cls_Authentication {
        public String Status;   //String
        public String Token;    //String
    }
    public class cls_ResponseInfo {
        public String ApplicationId;    //Number
        public String LosApplicationId;
        public String SolutionSetInstanceId;    //String
        //public String CurrentQueue; //String
    }
    public class cls_ContextData {
        public cls_Applicants[] Applicants;
    }
    public class cls_Applicants {
        public cls_Applicant Applicant;
    }
    public class cls_Applicant {
        public cls_DsCibilBureau DsCibilBureau;
        public String DateOfBirth;  //String
        public String ApplicantFirstName;   //String
        public String ApplicantMiddleName;  //String
        public String ApplicantLastName;    //String
        public String ApplicantType;    //String
        //added by shubham
        public String Alias;
        public String IncomeTaxPAN;
        public String EmailId;
        public String Gender;   //String
        //31 end
    }
    public class cls_DsCibilBureau {
        public cls_DsCibilBureauStatus DsCibilBureauStatus;
        public cls_DsCibilResponse DsCibilResponse;
    }
    public class cls_DsCibilBureauStatus {
        public String Trail;    //String
    }
    public class cls_DsCibilResponse {
        public cls_CibilBureauResponse CibilBureauResponse;
        public String IsSuccess;
        public String ErrorMessage;
        public String ErrorCode;
        public String ErrorDetails;
    }
    public class cls_CibilBureauResponse {
        public String BureauResponseRaw;    //String
        public cls_BureauResponseXml BureauResponseXml;
    }
    public class cls_BureauResponseXml {
        public cls_CreditReport CreditReport;
        public AccountSummary AccountSummary;
        public RecentActivities RecentActivities;
        public OtherKeyInd OtherKeyInd;
        public EnquirySummary EnquirySummary;
    }

    public class cls_CreditReport {
        public cls_Header Header;
        public cls_NameSegment NameSegment;
        public cls_IDSegment[] IDSegment;
        public cls_TelephoneSegment[] TelephoneSegment;
        public cls_ScoreSegment[] ScoreSegment;
        public cls_Enquiry[] Enquiry;
        public cls_Accounts[] Accounts;
        public cls_Credit_Account[] Credit_Account;
        public cls_Total_Outstanding_Balance[] Total_Outstanding_Balance;
        public cls_ReportAddress[] ReportAddress;
        public cls_ReportEnd ReportEnd;
     
    }
    
    
    //end 131
    public class cls_Header {
        public String SegmentTag;   //String
        public String Version;  //String
        public String ReferenceNumber;  //String
        public String MemberCode;   //String
        public String SubjectReturnCode;    //String
        public String EnquiryControlNumber; //String
        public String DateProcessed;    //String
        public String TimeProcessed;    //String
        //Extra added
      //  public String ReportOrderNO;
      //  public String productCode;
    }
    public class cls_NameSegment {
        public String Length;   //String
        public String SegmentTag;   //String
        public String ConsumerName1FieldLength; //String
        public String ConsumerName1;    //String
        public String ConsumerName2FieldLength; //String
        public String ConsumerName2;    //String
        public String ConsumerName3FieldLength; //String
        public String ConsumerName3;    //String
        public String DateOfBirthFieldLength;   //String
        public String DateOfBirth;  //String
        public String GenderFieldLength;    //String
        public String Gender;
        public String Age;
        public String TotalIncome;
        public String EmailAddress; //String
        //added by shubham
        public String Alais;
        public String Income_Tax_PAN;
    }
    public class cls_IDSegment {
        public String Length;   //String
        public String SegmentTag;   //String
        public String IDType;   //String
        public String IDNumberFieldLength;  //String
        public String IDNumber; //String
        public String EnrichedThroughEnquiry;   //String
    }
    public class cls_TelephoneSegment {
        public String Length;   //String
        public String SegmentTag;   //String
        public String TelephoneType;    //String
        public String TelephoneNumberFieldLength;   //String
        public String TelephoneNumber;  //String
        public String EnrichedThroughEnquiry;   //String
    }
    public class cls_ScoreSegment {
        public String Length;   //String
        public String ScoreName;    //String
        public String ScoreCardName;    //String
        public String ScoreCardVersion; //String
        public String ScoreDate;    //String
        public String Score;    //String
    }
    public class cls_Enquiry {
        public String Length;   //String
        public String SegmentTag;   //String
        public String DateOfEnquiryFields;  //String
        public String EnquiringMemberShortNameFieldLength;  //String
        public String EnquiringMemberShortName; //String
        public String EnquiryPurpose;   //String
        public String EnquiryAmountFieldLength; //String
        public String EnquiryAmount;    //String
        //extra added
        public String DateOfEnquiry;
        public String TimeOfEnquiry;
    }
    public class cls_Accounts {
        public String Length;   //String
        public String SegmentTag;   //String
        public cls_Account_Summary_Segment_Fields[] Account_Summary_Segment_Fields;
        public cls_Account_NonSummary_Segment_Fields[] Account_NonSummary_Segment_Fields;
    }
    public class cls_Credit_Account{
    	public String CreditAccountTotal;
     	public String CreditAccountActive;
        public String CreditAccountDefault;
        public String CreditAccountClosed;
        public String CADSuitFiledCurrentBalance;
    }
    public class cls_Total_Outstanding_Balance{
        public String Outstanding_Balance_Secured;
        public String Outstanding_Balance_Secured_Percentage;
        public String Outstanding_Balance_UnSecured;
        public String Outstanding_Balance_UnSecured_Percentage;
        public String Outstanding_Balance_All;
    }
    public class cls_ReportAddress {
        public String AddressSegmentTag;    //String
        public String Length;   //String
        public String SegmentTag;   //String
        public String AddressLine1FieldLength;  //String
        public String AddressLine1; //String
        public String AddressLine2FieldLength;  //String
        public String AddressLine2; //String
        public String AddressLine3FieldLength;  //String
        public String AddressLine3; //String
        public String AddressLine4FieldLength;  //String
        public String AddressLine4; //String
        public String AddressLine5FieldLength;  //String
        public String AddressLine5; //String
        public String StateCode;    //String
        public String PinCodeFieldLength;   //String
        public String PinCode;  //String
        public String AddressCategory;  //String
        public String ResidenceCode;    //String
        public String DateReported; //String
        public String EnrichedThroughEnquiry;   //String
    }
    public class cls_Account_Summary_Segment_Fields {
        public String ReportingMemberShortName; //String
        public String NumberOfAccounts; //String
        public String AccountGroup; //String
        public String LiveClosedIndicator;  //String
        public String DateOpenedOrDisbursed;    //String
        public String DateOfLastPayment;    //String
        public String DateClosed;   //String
        public String DateReported; //String
        public String HighCreditOrSanctionedAmount; //String
        public String CurrentBalance;   //String
        public String AmountOverdue;    //String
        public String PaymentHistory1;  //String
        public String PaymentHistory2;  //String
        public String PaymentHistoryStartDate;  //String
        public String PaymentHistoryEndDate;    //String
    }
    public class cls_Account_NonSummary_Segment_Fields {
        public String ReportingMemberShortNameFieldLength;  //String
        public String ReportingMemberShortName; //String
        public String AccountNumber;    //String                         -- Exp
        public String AccountType;  //String                             -- Exp
        public String OwenershipIndicator;  //String
        public String DateOpenedOrDisbursed;    //String                 -- Exp
        public String DateOfLastPayment;    //String                     -- Exp
        public String DateClosed;   //String                             -- Exp
        public String DateReportedAndCertified; //String                 -- Exp
        public String HighCreditOrSanctionedAmount; //String             -- Exp
        public String CurrentBalance;   //String                         -- Exp
        public String AmountOverdue;    //String                         -- Exp
        public String PaymentHistory1;  //String                         -- Exp
        public String PaymentHistory2;  //String
        public String PaymentHistoryStartDate;  //String
        public String PaymentHistoryEndDate;    //String
        public String SuitFiledOrWilfulDefault; //String                 -- Exp
        public String WrittenOffAndSettled; //String                     -- Exp
        public String ValueOfCollateralFieldLength; //String
        public String ValueOfCollateral;    //String
        public String TypeOfCollateral; //String
        public String CreditLimit;  //String
        public String CashLimit;    //String
        public String RateOfInterest;   //String
        public String RepaymentTenure;  //String                         -- Exp
        public String EmiAmount;    //String                             -- Exp
        public String WrittenOffAmountTotal;    //String
        public String WrittenOffAmountPrincipal;    //String
        public String SettlementAmount; //String
        public String PaymentFrequency; //String                         -- Exp
        public String ActualPaymentAmount;  //String
        public String ErrorCode;    //String
        public String CIBILRemarksCode; //String
        public String DateOfEntryForErrorDisputeRemarksCode;    //String
        public String ErrorDisputeRemarksCode1; //String
        public String ErrorDisputeRemarksCode2; //String
        public String FID;  //String
        public String SNo;  //String
        public String SuppressFlag; //String
        public String DateOfSuppression;    //String
        //added by shubham
        public String Account_Status;
        public String Payment_Rating;
        public String OriginalChargeOffAmount;
        public String DateOfFirstDelinquency;
        public String SuitFiledWillfulDefaultWrittenOffStatus;
        public String DefaultStatusDate;
        public String LitigationStatusDate;
        public String WriteOffStatusDate;
        public String DateOfAddition;
        public cls_CAIS_Account_History[] AccountHistory;
    }
    public class cls_CAIS_Account_History{
        public String Year;
        public String Month;
        public String DPD;
        public String AssetClassification;
    }
    
     // Extra added
    public class AccountSummary {
        public String NoOfAccounts;
        public String NoOfActiveAccounts;
        public String NoOfWriteOffs;
        public String TotalPastDue;
        public String MostSevereStatusWithIn24Months;
        public String SingleHighestCredit;
        public String SingleHighestSanctionAmount;
        public String TotalHighCredit;
        public String AverageOpenBalance;
        public String SingleHighestBalance;
        public String NoOfPastDueAccounts;
        public String NoOfZeroBalanceAccounts;
        public String RecentAccount;
        public String OldestAccount;
        public String TotalBalanceAmount;
        public String TotalSanctionAmount;
        public String TotalCreditLimit;
        public String TotalMonthlyPaymentAmount;
    }
    //Extra added
    public class RecentActivities {
        public String AccountsDeliquent;
        public String AccountsOpened;
        public String TotalInquiries;
        public String AccountsUpdated;
    }
    //extra added
    public class OtherKeyInd {
        public String AgeOfOldestTrade;
        public String NumberOfOpenTrades;
        public String AllLinesEVERWritten;
        public String AllLinesEVERWrittenIn9Months;
        public String AllLinesEVERWrittenIn6Months;
    }
    //Extra added
    public class EnquirySummary {
        public String Purpose;
        public String Total;
        public String Past30Days;
        public String Past12Months;
        public String Past24Months;
        public String Recent;
    }
      //285 end
    public class cls_ReportEnd {
        public String SegmentTag;   //String
        public String TotalLength;  //String
    }
    public static CibilResponseTU_HL parse(String json){
        system.debug('JSON----->'+json);
        return (CibilResponseTU_HL) System.JSON.deserialize(json, CibilResponseTU_HL.class);
    }
}