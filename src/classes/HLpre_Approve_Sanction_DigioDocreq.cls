/*
   Digio Pre approval Sanction letter doc generation Req. Class
*/

public class HLpre_Approve_Sanction_DigioDocreq {
     
    public String exe_tenantId= 'cuecent_tenant';   //cuecent_tenant
    public String owner_tenantId= 'cuecent_tenant'; //cuecent_tenant
    public String serviceName= 'TestJsonStr';   //TestJsonStr
    public cls_inputVariables inputVariables;
    public class cls_inputVariables {        
        public String in_msg= '';   //
        public String unique_key= '';   //
        public String pdf_unique_key= '';
        public cls_inputmap inputmap;
    }
    
    public class cls_inputmap {
        public string Borrower1_Add_line1='';
        public string Application_date   ='';
        public string Borrower3_Add_line1='';
        public string Borrower4_Add_line3='';
        public string Loc_Ref_Branch     ='';
        public string Borrower3_Add_line3='';
        public string Borrower3_F_H_D_NAME1='';
        public string Borrower3_Add_line2='';
        public string Borrower1_Name1    ='';
        public string Borrower4_Add_line2='';
        public string Borrower4_Add_line1='';
        public string Borrower4_F_H_D_NAME1='';
        public string Processing_charges ='';
        public string Date_Time_Ver      ='';
        public string Application_number ='';
        public string Date_Time_Adm      ='';
        public string sanction_date      ='';
        public string Ap_LT_inwords      ='';
        public string Bank_Auth_Sign     ='';
        public string Ap_LT              ='';
        public string Borrower4_Name1    ='';
        public string Borrower1_Add_line3='';
        public string Borrower1_Add_line2='';
        public string Int_ROI            ='';
        public string Loan_product       ='';
        public string Borrower2_F_H_D_NAME1='';
        public string Financial_Yr       ='';
        public string Loan_tenor         ='';
        public string Branch_code        ='';
        public string Borrower2_Name1    ='';
        public string Auth_Signatory_Bnk ='';
        public string Borrower1_F_H_D_NAME1='';
        public string Borrower3_Name1    ='';
        public string Borrower2_Add_line1='';
        public string Borrower2_Add_line2='';
        public string Doc_gen_date       ='';
        public string Borrower2_Add_line3='';
        public string  Auth_Sign_Bnk            ='';
    }

}