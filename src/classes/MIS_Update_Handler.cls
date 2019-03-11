public class MIS_Update_Handler{
	public String exe_tenantId;	//cuecent_tenant
	public String owner_tenantId;	//cuecent_tenant
	public cls_inputVariables inputVariables;
	public class cls_inputVariables {
		public cls_in_msg in_msg;
	}
	public class cls_in_msg {
		public String Mnemonic;	//1152753000002664
		public String Security;	//19
		public String NoOfDependents;	//
		public String PrioritySectorCode;	//517
		public String SpouseIncome;	//
		public String Occupation;	//95019
		public String MonthlyHouseHoldIncome;	//
		public String RBIPurpose;	//99999
		public String AssetOwnership;	//
		public String Nostro;	//NO_NOSTRO
		public String ResidenceDetails;	//
		public String SelectedSecurityCode;	//99
		public String CreditCardDetails;	//
		public String BSRActivityCode;	//9
		public String BankingActivities;	//
		public String CategoryOfBorrowers;	//99
		public String InvestmentPreference;	//
		public String ExportDocType;	//NA
		public String LoanDetails;	//
		public String ExportStatusHolder;	//NA
		public String PresentLoanRequirements;	//
		public String MakerID;	//LAPSMAKER
		public String CheckerID;	//LAPSCHECKER
	}
    public class MIS_Update_Response{
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