/*
* Name      : WS_CBS_Loan_Creation_HL
* Compnay   : ET Marlabs
* Purpose   : For HL Service(Open Loan Account in CBS) 
* Author    : Subas
*/
public class Loan_Creation_Helper_HL{
    public String exe_tenantId; //cuecent_tenant
    public String owner_tenantId;   //cuecent_tenant
    public cls_inputVariables inputVariables;
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String AssetValue;   //500000
        public String BranchCode;   //1315
        public String Contribution; //0
        public String CustomerId;   //6113631
        public String InterestVariance; //2
        public String LoanAmount;   //500000
        public String LoanPurpose;  //TO MEET HER PERSONAL EXPENSES
        public String LoanTerm; //60
        public String ProductCode;  //939
        public String ScheduleName; //9399
        public String TransactionBranch;
    }
    public static Loan_Creation_Helper_HL parse(String json){
        return (Loan_Creation_Helper_HL) System.JSON.deserialize(json, Loan_Creation_Helper_HL.class);
    }
    
    //Response
    public class Loan_creation_response{
        public String bpms_error_code;	//00
        public cls_out_msg out_msg;
        public String bpms_error_msg;	//Success
    }
    public class cls_out_msg {
        public cls_LoanResponse LoanResponse;
        public String ErrorMessage;
        public String Response;
        //New tag added
        public String ErrorCode;
    }
    public class cls_LoanResponse {
        public cls_Status Status;
        public String AccountId;	//1152753000003309
    }
    public class cls_Status {
        public String IsServiceChargeApplied;	//false
        public String ReplyCode;	//0
        public cls_ExtendedReply ExtendedReply;
        public String ErrorCode;	//
        public String IsOverriden;	//false
        public String SpReturnValue;	//0
        public String Memo;	//
        public String ExternalReferenceNo;	//136162017100400010063
        public String ReplyText;	//
    }
    public class cls_ExtendedReply {
        public String MessagesArray;	//
    }  
}