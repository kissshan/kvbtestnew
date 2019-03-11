public with sharing class PL_Approve_Sanction_DigioDocreq {
		
	public String exe_tenantId= 'cuecent_tenant';   //cuecent_tenant
    public String owner_tenantId= 'cuecent_tenant'; //cuecent_tenant
    public String serviceName= 'TestJsonStr';   //TestJsonStr
    public cls_inputVariables inputVariables;
    public class cls_inputVariables {        
        public String in_msg= '';   //
        public String unique_key= '';
        public String pdf_unique_key= '';   //
        public cls_inputmap inputmap;
    }
    
    public class cls_inputmap {
        public string Borrower1_Add_line1='';
        public string Application_date   ='';
        public string Loc_Ref_Branch     ='';
        public string Borrower1_Name1    ='';
        public string Processing_charges ='';
        public string Date_Time_Ver      ='';
        public string Application_number ='';
        public string Date_Time_Adm      ='';
        public string sanction_date      ='';
        public string Ap_LT              ='';
        public string Borrower1_Add_line3='';
        public string Borrower1_Add_line2='';
        public string Int_ROI            ='';
        public string Loan_product       ='';
        public string Financial_Yr       ='';
        public string Loan_tenor         ='';
        public string Branch_code        ='';
        public string Doc_gen_date       ='';
        public string Auth_Sign_Bnk     ='';

        //additional Tags for PL Approval sanction letter
        public string Conditions_LOS = '';
        public string Borrower1_Pan = '';
        public string Penal_Interest ='';
        public string Borrower1_Email ='';
        public string PreClosure_Charges ='';
        public string Borrower1_Aadhaar = '';
        public string EMI_amount ='';
        public string Borrower1_Phone = '';
        public string Non_refundable_charges = '';
        
        //Tags for Sanction and Dealer Payment document of Vehicle Loan
        public string DD_FI = '';
        public string Security_any = '';
        public string Primary_Sec = '';
        public string Collateral_Sec = '';
        public string Guarantor_any = '';
        public string Borrower_Details = '';
        public string Ap_LT_inwords = '';
        public string Interest_charge = '';
        public string Borrower2_Name1    ='';
        public string Borrower2_Add_line1='';
        public string Borrower2_Add_line2='';
        public string Borrower2_Add_line3='';
        public string Margin ='';
        public string V_Amt ='';
        public string MCLR_Refresh='';
        public string Vehicle_Type='';
        public string Borrower2_eSign='';
        public string Borrower2_Email ='';
        public string Borrower2_Aadhaar='';
        public string Dealer_Name='';
        public string Interest_Type_Rate='';
        public string Borrower2_Pan='';
        public string MCLR_Rate ='';
        public string Borrower2_Phone='';
        public string Borrower1_eSign='';
        public string Dealer_Add='';
        public string Vehicle_Details='';
        public string Margin_Amt = '';
        
        //Tags for Hypothecation document of Vehicle Loan
        public string Manufacture_Year='';
        public string Disb_Ref_Month='';
        public string Disb_Ref_Day='';
        public string Borrower_Names='';
        public string DD_LI ='';
        public string CC_Details='';
        public string DD_PI='';
        public string Disb_Ref_Year='';
        public string Proforma_No='';
        public string Int_Type ='';
        public string Borrower1_Names='';
        public string Borrower2_Names='';
        public string Class_2_Signature='';

        //Tags for Acknowledgement Letter of Vehicle Loan
        public string DD_No='';
        public string DD_date ='';
        //Tags for cover letter
        public string DD_amount='';
    }
    
}