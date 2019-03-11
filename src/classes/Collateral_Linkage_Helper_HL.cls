public class Collateral_Linkage_Helper_HL{
	public String exe_tenantId;	//cuecent_tenant
	public String owner_tenantId;	//cuecent_tenant
	public cls_inputVariables inputVariables;
	public class cls_inputVariables {
		public cls_in_msg in_msg;
	}
	public class cls_in_msg {
        public String serviceName; //Term_Loan_Linkage_Collateral_HL
        public String ApplicationId;
        public cls_LinkCollateralDetails[] LinkCollateralDetails;
	}
    public class cls_LinkCollateralDetails{
		public String ApplicantID;
        public String TransactionBranch;	//1152
		public String AccountNo;	//1152753000002522
		public String CollateralCode;	//107
		public String CollateralID;	//115275300025221
		public String CollateralValue;	//500000
		public String ExtUniqueRefId;	//1
		public String FlgOperation;	//A
		public String SecurityType;	//P
		public String Channel;	//BRN        
    }
	public static Collateral_Linkage_Helper_HL parse(String json){
		return (Collateral_Linkage_Helper_HL) System.JSON.deserialize(json, Collateral_Linkage_Helper_HL.class);
	}
//response structure
public class Collateral_Linkage_Response{
	public String bpms_error_code;	//00
	public cls_out_msg out_msg;
	public String bpms_error_msg;
}
    public class cls_out_msg {
        public String Status_Desc;
        public String Status_Code;
	}
}