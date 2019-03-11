/*
* Name     : LAPGuaAgree_DocReq
* Company  : ET Marlabs
* Purpose  : Digio Sanction letter doc generation Req for LAP. 
* Author   : Shubham Shukla
*/
public class LAPSanction_DocReq {
   // public static Map<Integer,Integer> signerPageCountMap;
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
        public string Loc_Ref_Branch            = '';
        public string Branch_code               = '';
        public string Application_number        = '';
        public string sanction_date             = '';
        public string Ap_LT_inwords             = '';
        public string Financial_Yr              = '';
        public string Doc_gen_date              = '';
        public string Tittle_B1                 = '';
        public string Borrower1_Name1           = '';
        public string Borrower1_Add_line1       = '';
        public string Borrower1_Add_line2       = '';
        public string Borrower1_Add_line3       = '';
        public string Tittle_B2                 = '';
        public string Borrower2_Name1           = '';
        public string Borrower2_Add_line1       = '';
        public string Borrower2_Add_line2       = '';
        public string Borrower2_Add_line3       = '';
        public string Tittle_B3                 = '';
        public string Borrower3_Name1           = '';
        public string Borrower3_Add_line1       = '';
        public string Borrower3_Add_line2       = '';
        public string Borrower3_Add_line3       = '';
        public string Tittle_B4                 = '';
        public string Borrower4_Name1           = '';
        public string Borrower4_Add_line1       = '';
        public string Borrower4_Add_line2       = '';
        public string Borrower4_Add_line3       = '';
        public string Application_date          = '';
        public string Loan_product              = '';
        public string Ap_LT                     = '';
        public string Margin                    = '';
        public string MCLR_Rate                 = '';
        public string Int_ROI                   = '';
        public string Loan_tenor                = '';
        public string MCLR_TYPE                 = '';
        public string ROI_MCLR                  = '';
        public string Int_type                  = '';
        public string Loan_Purpose              = '';
        public string Repay_Method              = '';
        public string EMI_amount                = '';
        public string Holiday_period            = '';
        public string Guarantor1_Names          = '';
        public string Guarantor2_Names          = '';
        public string Guarantor3_Names          = '';
        public string Guarantor4_Names          = '';
        public string Guarantor5_Names          = '';
        public string Guarantor6_Names          = '';
        public string Processing_charges        = '';
        public string Non_refundable_charges    = '';
        public string PreClosure_Charges        = '';
        public string Penal_Interest            = '';
        public string Conditions_LOS            = '';
        public string Auth_Sign_Bnk             = '';
        public string Type_of_Charge1           = '';
        public string Type_of_Charge2           = '';
        public string Type_of_Charge3           = '';
        public string Type_of_Charge4           = '';
        public string Type_of_Charge5           = '';
        public string Type_of_Charge6           = '';
        public string Survey_No_1               = '';
        public string Survey_No_2               = '';
        public string Survey_No_3               = '';
        public string Survey_No_4               = '';
        public string Survey_No_5               = '';
        public string Survey_No_6               = '';
        public string Plot_Door_Bungalow_No_1   = '';
        public string Plot_Door_Bungalow_No_2   = '';
        public string Plot_Door_Bungalow_No_3   = '';
        public string Plot_Door_Bungalow_No_4   = '';
        public string Plot_Door_Bungalow_No_5   = '';
        public string Plot_Door_Bungalow_No_6   = '';
        public string Extent_Site_Uds_1         = '';
        public string Extent_Site_Uds_2         = '';
        public string Extent_Site_Uds_3         = '';
        public string Extent_Site_Uds_4         = '';
        public string Extent_Site_Uds_5         = '';
        public string Extent_Site_Uds_6         = '';
        public string Built_up_area_1           = '';
        public string Built_up_area_2           = '';
        public string Built_up_area_3           = '';
        public string Built_up_area_4           = '';
        public string Built_up_area_5           = '';
        public string Built_up_area_6           = '';
        public string Floor_No_1                = '';
        public string Floor_No_2                = '';
        public string Floor_No_3                = '';
        public string Floor_No_4                = '';
        public string Floor_No_5                = '';
        public string Floor_No_6                = '';
        public string Ward_No_1                 = '';
        public string Ward_No_2                 = '';
        public string Ward_No_3                 = '';
        public string Ward_No_4                 = '';
        public string Ward_No_5                 = '';
        public string Ward_No_6                 = '';
        public string Building_Society_Name_No_1 = '';
        public string Building_Society_Name_No_2 = '';
        public string Building_Society_Name_No_3 = '';
        public string Building_Society_Name_No_4 = '';
        public string Building_Society_Name_No_5 = '';
        public string Building_Society_Name_No_6 = '';
        public string Street_Name_1                 = '';
        public string Street_Name_2                 = '';
        public string Street_Name_3                 = '';
        public string Street_Name_4                 = '';
        public string Street_Name_5                 = '';
        public string Street_Name_6                 = '';
        public string Village_Town_1                = '';
        public string Village_Town_2                = '';
        public string Village_Town_3                = '';
        public string Village_Town_4                = '';
        public string Village_Town_5                = '';
        public string Village_Town_6                = '';
        public string Taluka_Tehsil_1               = '';
        public string Taluka_Tehsil_2               = '';
        public string Taluka_Tehsil_3               = '';
        public string Taluka_Tehsil_4               = '';
        public string Taluka_Tehsil_5               = '';
        public string Taluka_Tehsil_6               = '';
        public string District_Name_1               = '';
        public string District_Name_2               = '';
        public string District_Name_3               = '';
        public string District_Name_4               = '';
        public string District_Name_5               = '';
        public string District_Name_6               = '';
        public string State_Name_1                  = '';
        public string State_Name_2                  = '';
        public string State_Name_3                  = '';
        public string State_Name_4                  = '';
        public string State_Name_5                  = '';
        public string State_Name_6                  = '';
        public string PIN_CODE_1                    = '';
        public string PIN_CODE_2                    = '';
        public string PIN_CODE_3                    = '';
        public string PIN_CODE_4                    = '';
        public string PIN_CODE_5                    = '';
        public string PIN_CODE_6                    = '';
        public string Title_Holder_Details_1 = '';
        public string Title_Holder_Details_2 = '';
        public string Title_Holder_Details_3 = '';
        public string Title_Holder_Details_4 = '';
        public string Title_Holder_Details_5 = '';
        public string Title_Holder_Details_6 = '';
        public string Market_value_1 = '';
        public string Market_value_2 = '';
        public string Market_value_3 = '';
        public string Market_value_4 = '';
        public string Market_value_5 = '';
        public string Market_value_6 = '';
        public string Valuation_report_date_1 = '';
        public string Valuation_report_date_2 = '';
        public string Valuation_report_date_3 = '';
        public string Valuation_report_date_4 = '';
        public string Valuation_report_date_5 = '';
        public string Valuation_report_date_6 = '';
        public string Borrower1_Names = '';
        public string Borrower2_Names = '';
        public string Borrower3_Names = '';
        public string Borrower4_Names = '';
        public string Borrower1_Aadhaar = '';
        public string Borrower2_Aadhaar = '';
        public string Borrower3_Aadhaar = '';
        public string Borrower4_Aadhaar = '';
        public string Borrower1_Phone = '';
        public string Borrower2_Phone = '';
        public string Borrower3_Phone = '';
        public string Borrower4_Phone = '';
        public string Borrower1_Email = '';
        public string Borrower2_Email = '';
        public string Borrower3_Email = '';
        public string Borrower4_Email = '';
        public string Borrower1_PAN = '';
        public string Borrower2_PAN = '';
        public string Borrower3_PAN = '';
        public string Borrower4_PAN = '';
        public string Guarantor1_Aadhaar = '';
        public string Guarantor2_Aadhaar = '';
        public string Guarantor3_Aadhaar = '';
        public string Guarantor4_Aadhaar = '';
        public string Guarantor5_Aadhaar = '';
        public string Guarantor6_Aadhaar = '';
        public string Guarantor1_Phone = '';
        public string Guarantor2_Phone = '';
        public string Guarantor3_Phone = '';
        public string Guarantor4_Phone = '';
        public string Guarantor5_Phone = '';
        public string Guarantor6_Phone = '';
        public string Guarantor1_Email = '';
        public string Guarantor2_Email = '';
        public string Guarantor3_Email = '';
        public string Guarantor4_Email = '';
        public string Guarantor5_Email = '';
        public string Guarantor6_Email = '';
        public string Guarantor1_PAN = '';
        public string Guarantor2_PAN = '';
        public string Guarantor3_PAN = '';
        public string Guarantor4_PAN = '';
        public string Guarantor5_PAN = '';
        public string Guarantor6_PAN = '';
        public string bEsign1 = '';
        public string bEsign2 = '';
        public string bEsign3 = '';
        public string bEsign4 = '';
        public string gEsign1 = '';
        public string gEsign2 = '';
        public string gEsign3 = '';
        public string gEsign4 = '';
        public string gEsign5 = '';
        public string gEsign6 = '';
        public string titleDetails1  = '';
        public string titleDetails2  = '';
        public string titleDetails3  = '';
        public string titleDetails4  = '';
        public string titleDetails5  = '';
        public string titleDetails6  = '';
        public string Party_Type_1   = '';
        public string Party_Type_2   = '';
        public string Party_Type_3   = '';
        public string Party_Type_4   = '';
        public string Party_Type_5   = '';
        public string Party_Type_6   = '';
        public string Party_Type_7   = '';
        public string Party_Type_8   = '';
        public string Party_Type_9   = '';
        public string Signer1        = '';
        public string Signer2        = '';
        public string Signer3        = '';
        public string Signer4        = '';
        public string Signer5        = '';
        public string Signer6        = '';
        public string Signer7        = '';
        public string Signer8        = '';
        public string Signer9        = '';
        //public string Clas_2_Signature = '';
    }
    

    public class cls_PgSigner{
        public Integer pgNo;
        public String signer;
        public cordWrapClass cord;
        public cls_PgSigner(Integer pgNo, String signer, cordWrapClass cord){
            this.pgNo = pgNo;
            this.signer = signer;
            this.cord = cord;
        }
    }
    public class cls_cordWrap{
        public Map<String,Map<Integer,List<Object>>> sign_coordinates;
        public cls_cordWrap(Map<String,Map<Integer,List<Object>>> sign_coordinates){
            this.sign_coordinates = sign_coordinates;
        }
    }
    public class cordWrapClass {
        public Decimal llx; 
        public Decimal lly; 
        public Decimal urx; 
        public Decimal ury; 
        public cordWrapClass(Decimal llx, Decimal lly, Decimal urx, Decimal ury){
            this.llx = llx;
            this.lly = lly;
            this.urx = urx;
            this.ury = ury;
        }
        public cordWrapClass(){}
    }
}