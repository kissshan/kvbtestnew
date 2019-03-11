/* 
* Name     : CBS_ChargeCreation_Formatter
* Purpose  : Formatter class to prepare request/response structure for Charge creation
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class CBS_ChargeCollaction_Formatter {
    //Request Format
    public class RequestFormat{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String AccountNumber;    //1185156000000445
        public String BranchCode;   //1260
        public Decimal TotalAmount; //3068
        public String ApplicationNumber;    //a4V0l0000004HqiEAE
        public String TransactionDate;  //20180301
        public String ValueDate;    //20180301
        public String ApplicantName;    //ANITHAnullS
        public String Flg_StmpFee_Brn;
        public String Flg_Force_Debit;
        public cls_Charges[] Charges;
    }
    public class cls_Charges {
        public String GL_Type;  //PRCH_CHG
        public Decimal ChargeAmount;    //2500
        public Decimal GST_Charge;    //2500
    }
    
    //Response Format
    public class ResponseFormat{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;   //Success
    }
    
    public class cls_out_msg {
        public String StatusDecs;   //Success
        public String CBSReferenceNo;   //2018030100010007
        public String ApplicationNumber;    //a4V0l0000004HqiEAE
        public String StatusCode;   //0
        public String ErrorCode;    //0
        public String ErrorMessage; //0
        
    }
}