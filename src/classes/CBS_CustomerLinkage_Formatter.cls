/* 
* Name     : CBS_CustomerLinkage_Formatter
* Purpose  : Formatter class to prepare request/response structure for customer linkage
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class CBS_CustomerLinkage_Formatter {
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
        public String TransactionBranch;	//1152
        public String Mode;	//M
        public String ValueDateText;	//01-01-2018
        public cls_CustDetl[] CustDetl;
    }
    public class cls_CustDetl {
        public String AccountNo;	//1152753000002522
        public String CustId1;	//16141796
        public String CustRel1;	//JOO
        public String FlgDel;	//N
    }
    
    //Response Format
    public class ResponseFormat{
	public String bpms_error_code;	//00
	public cls_out_msg out_msg;
	public String bpms_error_msg;	//
	}
	
	public class cls_out_msg {
		public boolean IsServiceChargeApplied;
		public String ReplyCode;	//0
		public cls_ExtendedReply ExtendedReply;
		public String ErrorCode;	//0
		public String IsOverriden;	//
		public String SpReturnValue;	//0
		public String Memo;	//
		public String ExternalReferenceNo;	//
		public String ReplyText;	//
        public String ErrorMessage;
        
        public String Response;
        public String SuccessMessage;
        public String ReasonMessage;
        public String ReasonCode;
	}
	public class cls_ExtendedReply {
		public String MessagesArray;	//
	}
}