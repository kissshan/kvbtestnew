/*
@name         : SME_CBS_EAE_Formatter
@description  : CBS callouts Request and response formatter(SME_EAE)
@author       : Dushyant
*/
public class SME_CBS_EAE_Formatter {
    //Request Format
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
        public String TransactionBranch;    //1418
        public String AccountNo;    //1418280000000077
        public String ExtUniqueRefId;   //1
        public String BranchCode;   //1418
        public String ServiceTypeId;    //1
        public String ServiceTypeName;  //CollateralDlink
        public String CollAddModDel;    //A
        public String FlgInquire;   //N
        public String LimitNo;  //1
        public String LimitStartDate;
        public String LimitEndDate;
        public cls_linkageDetails[] linkageDetails;
		public cls_CASA_ACCT_DTLS[] CASA_ACCT_DTLS;
        public cls_TL_Account_Dtls[] TL_Account_Dtls;        
        public String Cod_Cust1;
        public String Cod_Acct_Cust_Rel1;
        public String Cod_Cust2;
        public Object Cod_Acct_Cust_Rel2;
        public String Cod_Cust3;
        public Object Cod_Acct_Cust_Rel3;
        public String Nam_Cust_Shrt;
        public String Flg_Sc_Waiver;
        public String Flg_Int_Waiver;
        public String Cod_Officerid;
        public String Cod_Makerid;
        public String Cod_Chkrid;
        public String Cod_Cc_Brn;
        public String Cod_Prod;
        public String Cod_Lang;
        public String Flg_Joint_Acct;
        public String Cod_Module;
        public String Cod_Org_Brn;
        public String Cod_Tds;
        public String Cod_Tds_2;
        public String Acct_Desc;
        public String User_Id;
        public String Cod_Laps_Reference_No;
    }
    
    public class cls_CASA_ACCT_DTLS {
		public String Cod_Cust1;	//2401876
		public String Cod_Acct_Cust_Rel1;	//SOW
		public String Cod_Cust2;	//0
		public object Cod_Acct_Cust_Rel2;
		public String Cod_Cust3;	//0
		public object Cod_Acct_Cust_Rel3;
		public String Nam_Cust_Shrt;	//SATHYABAHAMA R
		public String Flg_Sc_Waiver;	//N
		public String Flg_Int_Waiver;	//N
		public String Cod_Officerid;	//LAPSCHECKER
		public String Cod_Makerid;	//LAPSMAKER
		public String Cod_Chkrid;	//LAPSCHECKER
		public String Cod_Cc_Brn;	//1219
		public String Cod_Prod;	//223
		public String Cod_Lang;	//ENG
		public String Flg_Joint_Acct;	//N
		public String Cod_Module;	//CH
		public String Cod_Org_Brn;	//1219
		public String Cod_Tds;	//999
		public String Cod_Tds_2;	//999
		public String Acct_Desc;	//SATHYABAHAMA R
		public String User_Id;	//LAPSMAKER
		public String Cod_Laps_Reference_No;	//SATHYABAHAMA22R
		public String Limit_Amt;	//123
		public String API_Trigger_Date;	//03/08/2019
	}
    public class cls_linkageDetails {
        public String CollateralID; //11522230000004183
        public String CollateralCode;   //142
        public String CollateralDegree; //P
        public String CollateralAmt;    //2000001
        public String CollateralDesc;   //NalinTest11
        public String LinkCollateral;   //Y
    }
    
    //Response Format
    public class ResponseFormat{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;  //Success
    }
    public class cls_out_msg {
        public String ErrorCode;    //0
        public String ErrorMessage; //Success
        public String Cod_Acct_No;
        public String ReplyText;
        public String Cod_Laps_Reference_No;
        public cls_TL_ACCOUNT_RES[] TL_ACCOUNT_RES;
        public cls_Success[] Success;
        public cls_Failure[] Failure;
    }
    public class cls_Success {
        public cls_ODLimitLinkResponse ODLimitLinkResponse;
    }
    public class cls_ODLimitLinkResponse {
        public cls_Status Status;
        public cls_CollateralDetails CollateralDetails;
        public String AccountNo;    //1152223000001430
        public String LimitAmount;  //200000
        public String ExtUniqueRefId;   //1
        public String LimitNo;  //1
        public String CustomerName; //NALINAKRISHNAN S
    }
    public class cls_TL_ACCOUNT_RES{
        public String CustomerId;
        public cls_LoanResponse LoanResponse;

    }
    public class cls_LoanResponse{
        public cls_Status Status;
        public String AccountId;
    }
    public class cls_Status {
        public String IsServiceChargeApplied;   //false
        public String ReplyCode;    //0
        public cls_ExtendedReply ExtendedReply;
        public String ErrorCode;    //0
        public String IsOverriden;  //false
        public String SpReturnValue;    //0
        public String Memo; //
        public String ExternalReferenceNo;  //82017100400010015
        public String ReplyText;    //
    }
    public class cls_ExtendedReply {
        public String MessagesArray;    //
    }
    public class cls_CollateralDetails {
        public cls_Collateral[] Collateral;
    }
    public class cls_Collateral {
        public String CollateralCode;   //141
        public String Linked;   //Y
        public String Description;  //sod
        public String CollateralID; //WC2231430004
        public String DrawingPowerUpdate;   //N
        public String CollateralDegree; //P
        public String LendableValue;    //250000
        public String CollateralValue;  //250000
    }
    public class cls_Failure {
        public String Response; //99
        public cls_CallBackData CallBackData;
        public String ErrorCode;    //2807
        public String ErrorMessage; //Collateral not found
        public cls_Reason Reason;
    }
    public class cls_CallBackData {
        public String ServiceTypeName;  //CollateralDlink
        public String AccountNo;    //1238223000000173
        public String ServiceTypeId;    //1
    }
    public class cls_Reason {
        public String Message;  // Internal OLTP Error. 
        public String Code; //29
    }
    public class cls_TL_Account_Dtls{
        public String AssetValue;
        public String BranchCode;
        public String Contribution;
        public String CustomerId;
        public String InterestVariance;
        public String LoanAmount;
        public String LoanPurpose;
        public String LoanTerm;
        public String ProductCode;
        public String TransactionBranch;
        public String ScheduleName;
        public String API_Trigger_Date;
    }
}