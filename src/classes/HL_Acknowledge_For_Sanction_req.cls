public class HL_Acknowledge_For_Sanction_req {
    
    public String exe_tenantId= 'cuecent_tenant';   //cuecent_tenant
    public String owner_tenantId= 'cuecent_tenant'; //cuecent_tenant
    public String applicationType = '';
    public String applicationId = '';
    public String customerId = '';
    public String documentType = '';
    public String accountNumbers = '';
    public String fileName = '';
    public String uuid = '';
    
    public String serviceName= 'TestJsonStr';   //TestJsonStr
    public cls_inputVariables inputVariables;
    public class cls_inputVariables {        
        public String in_msg= '';   //
        public String unique_key= '';   //
        public String pdf_unique_key= '';
        public cls_inputmap inputmap;
    }
    
    public class cls_inputmap {
        public string  Extent_Site_Uds          ='';
        public string  Built_up_area            =''; 
        public string  Tittle_B4                ='';
        public string  Tittle_B1                ='';
        public string  Tittle_B2                ='';
        public string  Tittle_B3                ='';
        public string  MCLR_TYPE                ='';
        public string  Borrower5_Names          ='';
        public string  Financial_Yr             ='';
        public string  Margin                   ='';
        public string  Borrower1_Names          ='';
        public string  Borrower2_F_H_D_NAME1    ='';
        public string  Borrower4_Add_line3      ='';
        public string  Loan_Purpose             ='';
        public string  Borrower4_Add_line2      ='';
        public string  Borrower4_Add_line1      ='';
        public string  Processing_charges       ='';
        public string  EMI_amount               ='';
        public string  PIN_CODE                 ='';
        public string  Nature_Property          ='';
        public string  Street_Name              ='';
        public string  Ap_LT                    ='';
        public string  Borrower4_Name1          ='';
        public string  Conditions_LOS           ='';
        public string  Rating_Freq              ='';
        public string  Borrower1_F_H_D_NAME1    ='';
        public string  Borrower2_Names          ='';
        public string  Penal_Interest           ='';
        public string  Taluka_Tehsil            ='';
        public string  Village_Town             ='';
        public string  Guarantor4_Names         ='';
        public string  Branch_code              ='';
        public string  Guarantor5_Names         ='';
        public string  Holiday_period           ='';
        public string  Guarantor3_Names         ='';
        public string  Guarantor1_Names         ='';
        public string  Borrower2_Add_line1      ='';
        public string  Borrower3_Names          ='';
        public string  Collateral_Sec           ='';
        public string  Borrower2_Add_line2      ='';
        public string  Borrower2_Add_line3      ='';
        public string  Borrower4_F_H_D_NAME1    ='';
        public string  Borrower1_Add_line1      ='';
        public string  State_Name               ='';
        public string  Market_value             ='';
        public string  Title_Holder             ='';
        public string  Application_date         ='';
        public string  Borrower3_Add_line1      ='';
        public string  Loc_Ref_Branch           ='';
        public string  Borrower3_Add_line3      ='';
        public string  Borrower3_Add_line2      ='';
        public string  Borrower1_Name1          ='';
        public string  Valuation_report_date    ='';
        public string  Ward_No                  ='';
        public string  Seller_Name              ='';
        public string  Borrower4_Names          ='';
        public string  Prop_Measu_det           ='';
        public string  Date_Time_Ver            ='';
        public string  Date_Time_Adm            ='';
        public string  Application_number       ='';
        public string  Guarantor2_Names         ='';
        public string  dd_fi                    ='';
        public string  Borrower3_F_H_D_NAME1    ='';
        public string  Non_refundable_charges   ='';
        public string  Borrower1_Add_line3      ='';
        public string  Floor_No                  ='';
        public string  Borrower1_Add_line2      ='';
        public string  Int_ROI                  ='';
        public string  Loan_product             ='';
        public string  Survey_No                ='';
        public string  ROI_MCLR                 ='';
        public string  PreClosure_Charges       ='';
        public string  Loan_tenor               ='';
        public string  Int_type                 ='';
        public string  Plot_Door_Bungalow_No    ='';
        public string  Borrower2_Name1          ='';
        public string  MCLR_Rate                ='';
        public string  District_Name            ='';
        public string  Borrower3_Name1          ='';
        public string  Doc_gen_date             ='';
        public string  Building_Society_Name_No ='';
        public string Repay_Method              ='';
        public string  Guarantor6_Names         ='';
        public string  Guarantor7_Names         ='';
        public string  Guarantor8_Names         ='';
        public string  Guarantor9_Names         ='';
        public string  Guarantor10_Names        ='';
        public string  Auth_Sign_Bnk            ='';
       
        
        //added by prashant singh
           public string Type_of_Charge ='';
        public string Site_extent='';
        public string Sanction_Ref_Number='';
        public string Sanction_date      ='';
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
        public string Guarantor1_Phone = '';
        public string Guarantor2_Phone = '';
        public string Guarantor1_Email = '';
        public string Guarantor2_Email = '';
        public string Guarantor1_PAN = '';
        public string Guarantor2_PAN = '';
        
        public string Party_Type_1   = '';
        public string Party_Type_2   = '';
        public string Party_Type_3   = '';
        public string Party_Type_4   = '';
        public string Party_Type_5   = '';
        public string Party_Type_6   = '';
        public string Signer1        = '';
        public string Signer2        = '';
        public string Signer3        = '';
        public string Signer4        = '';
        public string Signer5        = '';
        public string Signer6        = '';
        public string bEsign1 = '';
        public string bEsign2 = '';
        public string bEsign3 = '';
        public string bEsign4 = '';
        public string gEsign1 = '';
        public string gEsign2 = '';

        //prashant singh ends

    }
}