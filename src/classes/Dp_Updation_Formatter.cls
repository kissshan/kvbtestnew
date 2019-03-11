public class Dp_Updation_Formatter{
    public class RequestFormat{
        public String exe_tenantId;  //cuecent_tenant
        public String owner_tenantId;  //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    
    public class cls_in_msg {
        public String Channel;  //BRN
        public String ExternalReferenceNo;  //1021
        public String TransactionBranch;  //1152
        public String AccountNo;  //1152223000001430
        public String DP_Amt;  //200000
        public String ExtUniqueRefId;  //1
        public String BranchCode;  //1152
        public String ServiceTypeId;  //1
        public String ServiceTypeName;  //CollateralDlink
        public String CollateralID;  //11522231430
        public String CollateralCode;  //141
        public String TypeofCharge;  //1
        public String DatOrginalValuation;  //20170903
        public String DatLastValuation;  //20170903
        public String DeedStatus;  //1
        public String Location;  //VISAKHAPATNAM
        public String AreaUnit;  //SQ.YD
        public String TotalArea;  //7353.9
        public String TypeofProperty;  //1
        public String DatLeaseExpiry;  //20190101
        public String DescriptionProp1;  //EM CHARGE ON 
        public String DescriptionProp2;  //3 PROPERTIES
        public String DocumentCode;  //
        public String FlgOperation;  //
        public String NameofLender;  //
        public String OriginalValue;  //
        public String LastValue;  //
        public String MarketValue;  //
        public String CustodianName;  //
        public String DateDeedsSent;  //
        public String ExpectedReturnDate;  //
        public String DeedDetails;  //SALE DEED
        public String RegisteringAuth;  //
        public String InsurancePlanCode;  //
        public String InsurancePolicyNumber;  //
        public String InsurancePremiumBilling;  //
        public String BillingMode;  //
        public String Percentage;  //
        public String PremiumBilingAccount;  //
        public String InsurancePremiumAmount;  //
        public String NonStandardCollId;  //
        public String Description1;  //
        public String Description2;  //
        public String ChasisNumber;  //
        public String EngineNumber;  //
        public String RegistrationNumber;  //
        public String ModelNumber;  //
        public String YearofMfg;  //
        public String DescriptionAuto1;  //
        public String DescriptionAuto2;  //
        public String SecurityCode;  //
        public String NumberofUnits;  //
        public String SeriesNumber1;  //
        public String SeriesNumber2;  //
        public String ForcedSaleValue;  //
        public String QuitRentValue;  //
        public String Make;  //
        public String SLNum;  //
        public String RegNo;  //
        public String EngNo;  //
        public String HPCapacity;  //
        public String MachDesciption;  //
        public String AreaCult;  //
        public String AreaLand;  //
        public String DetailsCult;  //
        public String VillageNam;  //
        public String SurveyNo;  //
        public String SecDescription1;  //
        public String SecDescription2;  //
        public String Breed;  //
        public String Age;  //
        public String Number1;  //
        public String Quantity;  //
        public String CatDescription1;  //
        public String CatDescription2;  //
        public String IdentMArk;  //
        public String ASNAcctNumber;  //
        public String TotNumUnits;  //
        public String CertNumber;  //
        public String CertNumber1;  //
        public String CertNumber2;  //
        public String CertNumber3;  //
        public String CertNumber4;  //
        public String DivDate;  //
        public String SecurityCodec;  //
        public String GrossWeight;  //
        public String NetWeight;  //
        public String AppraiserValue;  //
        public String DateValuation;  //
        public String DescCommodity;  //
        public String LimitNo;  //1
        public String CollateralDegree;  //P
        public String CollateralAmt;  //150000
        public String CollateralDesc;  //sod
        
    }
    ///////Response
    
    
    public class ResponseFormat{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;  //Success
    }
    public class cls_out_msg {
        public String ErrorCode;  //0
        public String ErrorMessage;  //Success
        public cls_Success Success;
        public cls_Failure Failure;
        public String Response;  //99
        public cls_CallBackData CallBackData;
        public cls_Reason Reason;
        public String HttpStatus;  //504
        
    }
    public class cls_Success {
        public cls_ODLimitLinkResponse ODLimitLinkResponse;
    }
    public class cls_ODLimitLinkResponse {
        public cls_Status Status;
        public cls_CollateralDetails CollateralDetails;
        public String AccountNo;  //1152223000001430
        public String LimitAmount;  //200000
        public String ExtUniqueRefId;  //1
        public String LimitNo;  //1
        public String CustomerName;  //NALINAKRISHNAN S
    }
    public class cls_Status {
        public String IsServiceChargeApplied;  //false
        public String ReplyCode;  //0
        public cls_ExtendedReply ExtendedReply;
        public String ErrorCode;  //0
        public String IsOverriden;  //false
        public String SpReturnValue;  //0
        public String Memo;  //
        public String ExternalReferenceNo;  //82017100400010015
        public String ReplyText;  //
    }
    public class cls_ExtendedReply {
        public String MessagesArray;  //
    }
    public class cls_CollateralDetails {
        public cls_Collateral[] Collateral;
    }
    public class cls_Collateral {
        public String CollateralCode;  //141
        public String Linked;  //Y
        public String Description;  //sod
        public String CollateralID;  //WC2231430004
        public String DrawingPowerUpdate;  //N
        public String CollateralDegree;  //P
        public String LendableValue;  //250000
        public String CollateralValue;  //250000
    }
    public class cls_Failure {
        public String Response;  //99
        public cls_CallBackData CallBackData;
        public String ErrorCode;  //2435
        public String ErrorMessage;  //Invalid Input  - LimitNo Cannot be empty .
        public cls_Reason Reason;
        public cls_Exception1 Exception1;
    }
    
    public class cls_CallBackData {
        public String ServiceTypeName;  //CollateralDlink
        public String AccountNo;  //115222300000143
        public String ServiceTypeId;  //1
        public String DP_Amt;  //200000
        public String CollateralID;  //WC2231430004
        public String LimitNo;  //1
        public String CollateralDegree;  //P
        public String TypeofProperty;  //1
        public String MarketValue;  //200000
        public String TotalArea;  //7353.9
        public String DatLeaseExpiry;  //20190101
        public String DatOrginalValuation;  //20170903
        public String ExtUniqueRefId;  //1
        public String DescriptionProp1;  //EM CHARGE ON
        public String DescriptionProp2;  //3 PROPERTIES
        public String AmtCollateral;  //250000
        public String AreaUnit;  //SQ.YD
        public String TypeofCharge;  //1
        public String DeedDetails;  //SALE DEED
        public String NameofLender;  //
        public String collateralDesc;  //sod
        public String Channel;  //BRN
        public String OriginalValue;  //200000
        public String DeedStatus;  //1
        public String DatLastValuation;  //20170903
        public String CollateralCode;  //141
        public String LastValue;  //200000
        public String TransactionBranch;  //1152
        public String Location;  //VISAKHAPATNAM
        public String CollateralAmt;  //
        
    }
    
    public class cls_Reason {
        public String Message;  // Internal OLTP Error. 
        public String Code;  //29
        
    }
    
    public class cls_Exception1 {
        public String Response;  //99
        public String ErrorCode;  //4456
        public String ErrorMessage;  //Authorised record exists
        public cls_Reason Reason;
    }
}