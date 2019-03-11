/* 
* Name     : CBS_StockStatement
* Purpose  : Formatter class to prepare request and handle response for CBS StockStatement(CHM06)
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class CBS_StockStatement_Formatter {
    //Request Format
    public class RequestFormat{
        public String exe_tenantId;	//cuecent_tenant
        public String owner_tenantId;	//cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String Channel;	//BRN
		public String ExternalReferenceNo;	//1001
		public String TransactionBranch;	//1152
		public String AccountNo;	//1219223000000794
		public String DP_Amt;	//120000
		public String ExtUniqueRefId;	//1
		public String BranchCode;	//1147
    }
    //response Format
    public class ResponseFormat{
        public String bpms_error_code;	//00
        public cls_out_msg out_msg;
        public String bpms_error_msg;	//Success
	}
	public class cls_out_msg {
		public cls_ODLimitLinkResponse ODLimitLinkResponse;
	}
	public class cls_ODLimitLinkResponse {
		public cls_Status Status;
		public cls_CollateralDetails CollateralDetails;
		public String AccountNo;	//1219223000000794
		public String LimitAmount;	//150000
		public String ExtUniqueRefId;	//1
		public String LimitNo;	//1
		public String CustomerName;	//SATHYABAHAMA R
	}
	public class cls_Status {
		public String IsServiceChargeApplied;	//false
		public String ReplyCode;	//0
		public cls_ExtendedReply ExtendedReply;
		public String ErrorCode;	//0
		public String IsOverriden;	//false
		public String SpReturnValue;	//0
		public String Memo;	//
		public String ExternalReferenceNo;	//82017100400010267
		public String ReplyText;	//
	}
	public class cls_ExtendedReply {
		public String MessagesArray;	//
	}
	public class cls_CollateralDetails {
		public cls_Collateral[] Collateral;
	}
	public class cls_Collateral {
		public String CollateralCode;	//107
		public String Linked;	//Y
		public String Description;	//test
		public String CollateralID;	//1186280501
		public String DrawingPowerUpdate;	//Y
		public String CollateralDegree;	//P
		public String LendableValue;	//120000
		public String CollateralValue;	//120000
	}
}