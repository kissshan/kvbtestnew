public with sharing class CBS_SI_CreationPL {
	
		
	// Request structure

	public String exe_tenantId;
	public String owner_tenantId;
	public cls_InputVariables inputVariables;

	public class cls_InputVariables {
		public cls_In_msg in_msg;
	}

	public class cls_In_msg {
		public String TransactionBranch;
		public String UserReferenceNumber;
		public String AccountNo;
		public String TsfFrmCasa;
		public String CasaAcctNo;
		public String SalChkCredit;
		public String EmployerCode;
		public String SalCreditDrwDown;
		public String SalCreditPct;
		public String Mode;
	}

// Success/Fail response

	public class cls_Status {
		public String IsServiceChargeApplied;
		public String ReplyCode;
		public cls_ExtendedReply ExtendedReply;
		public String ErrorCode;
		public String IsOverriden;
		public String SpReturnValue;
		public String Memo;
		public String ReplyText;
	}

	public class cls_Response {
		public cls_AcctpayInstrResponse AcctpayInstrResponse;
	}

	public class cls_Out_msg {
		public cls_Response Response;
		public String ErrorCode;
		public String ErrorMessage;
		public cls_Except Failure;
	}

	public String bpms_error_code;
	public cls_Out_msg out_msg;
	public String bpms_error_msg;

	public class cls_ExtendedReply {
		public String MessagesArray;
	}

	public class cls_AcctpayInstrResponse {
		public cls_Status Status;
		public String CustomerName;
	}

	public class cls_Reason {
		public String Message;
		public String Code;
	}

	public class cls_Except {
		public String Response;
		public String ErrorCode;
		public String ErrorMessage;
		public cls_Reason Reason;
	}

	
	public static CBS_SI_CreationPL parse(String json) {
		return (CBS_SI_CreationPL) System.JSON.deserialize(json, CBS_SI_CreationPL.class);
	}
}