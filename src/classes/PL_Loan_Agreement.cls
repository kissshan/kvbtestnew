public class PL_Loan_Agreement {
    public String exe_tenantId= 'cuecent_tenant';   //cuecent_tenant
    public String owner_tenantId= 'cuecent_tenant'; //cuecent_tenant
    public String serviceName= 'TestJsonStr'; //TestJsonStr
    public cls_inputVariables inputVariables;
    public class cls_inputVariables {        
        public String in_msg= '';   //
        public String unique_key= '';   //
        public String pdf_unique_key= '';
        public cls_inputmap inputmap;
    }
    public class cls_inputmap {
        public string Loc_Ref_Branch 			= '';
        //public string Branch_code 				= '';
        public string Disb_Ref_Month            = '';
        public string Ap_LT_inwords             = '';
        public string Disb_Ref_Year				= '';
        public string Borrower_Details          = '';
        //public string Application_number 		= '';
        public string Disb_Ref_Day              = '';
		public string DD_FI						= '';
        public string DD_LI						= '';
        public string Borrower1_Names    		= '';
        public string Auth_Sign_Bnk				= '';
        //public string Financial_Yr 				= '';
        //public string Application_date 			= '';
        //public string Loan_product 				= '';
        public string Ap_LT 					= '';
        public string MCLR_Rate 				= '';
        public string Int_ROI 					= '';
        public string Loan_tenor 				= '';
        public string Int_type 					= '';
        public string EMI_amount 				= '';
        public string PreClosure_Charges 		= '';
        public string Penal_Interest 			= '';
        //public string Conditions_LOS 			= '';
        
        
        
        
    }
}