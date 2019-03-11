public class CBS_Stamp_Charge_Handler_HL{
    public String exe_tenantId;	//cuecent_tenant
    public String owner_tenantId;	//cuecent_tenant
    public cls_inputVariables inputVariables;
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String AccountNumber;	//PT8E1516613664147
        public String BranchCode;	//1751
        public Decimal TotalAmount;	//325
       // public Integer GST_Charge;	//10
        public String ApplicationNumber;	//38378475938475
        public String ApplicantName;	//Ganesh
        public String TransactionDate; //20171004
        public String ValueDate; //20171004
        public string Flg_StmpFee_Brn; // "Y"
        public string Flg_Force_Debit; // "N" for retail
        public cls_Charges[] Charges;
    }
    public class cls_Charges {
        public String GL_Type;	//PRCH_CHG
        public Decimal ChargeAmount;	//30
        public Decimal GST_Charge;
    }

    public class CBS_Stamp_Charge_Response{
        public String bpms_error_code;	//00
        public cls_out_msg out_msg;
        public String bpms_error_msg;
    }
    public class cls_out_msg {
        public String StatusDecs;	//Success
        public String CBSReferenceNo;	//201710040001602902
        public String ApplicationNumber;	//HL115202102018
        public String StatusCode;	//0
        public String ErrorCode;	//999
        public String ErrorMessage;	//BackOffice_Timeout
    }
}