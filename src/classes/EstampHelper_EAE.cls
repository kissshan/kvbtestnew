/*
* Name          : SME_EStamp_Req_Structure
* Description   : request structure for Legal desk SME
* Author        : Dushyant
*/
public class EstampHelper_EAE {
        public String ReferenceID;
        public String TemplateID;
        public String ApplicationID;
        public StampPaperData StampPaperData;
        public Map<String,Object> FormData;
        //public cls_TableData TableData;
        //public FormData frmData;

   /* public class FormData {
        public String Disb_Ref_Day;
        public String Disb_Ref_Month;
        public String Disb_Ref_Year;
        public String Loc_Ref_Branch;
        public String Borrower_Details;
        public String Loan_Product;
        public String Seller_Name;
        public String Advance_Amount;
        public String Sale_Agreem_Date;
        public String Nature_Property;
        public String Survey_No;
        public String Plot_Door_Bungalow_No;
        public String Built_up_area;
        public String Floor_No;
        public String Ward_No;
        public String Building_Society_Name_No;
        public String Street_Name;
        public String Village_Town;
        public String Taluka_Tehsil;
        public String District_Name;
        public String State_Name;
        public String PIN_CODE;
        public String Doc_Gen_date;
        public String Title_Holder1_Name1;
        public String Title_Holder1_Add_line1;
        public String Title_Holder1_Add_line2;
        public String Title_Holder1_Add_line3;
        public String Title_Holder2_Name1;
        public String Title_Holder2_Add_line1;
        public String Title_Holder2_Add_line2;
        public String Title_Holder2_Add_line3;
        public String Title_Holder3_Name1;
        public String Title_Holder3_Add_line1;
        public String Title_Holder3_Add_line2;
        public String Title_Holder3_Add_line3;
        public String Title_Holder4_Name1;
        public String Title_Holder4_Add_line1;
        public String Title_Holder4_Add_line2;
        public String Title_Holder4_Add_line3;
        public String Title_Holder5_Name1;
        public String Title_Holder5_Add_line1;
        public String Title_Holder5_Add_line2;
        public String Title_Holder5_Add_line3;
        public String Title_Holder6_Name1;  //name6
        public String Title_Holder6_Add_line1;  //L1
        public String Title_Holder6_Add_line2;  //L2
        public String Title_Holder6_Add_line3;  //L3
        public String Title_Holder7_Name1;  //name7
        public String Title_Holder7_Add_line1;  //L1
        public String Title_Holder7_Add_line2;  //L2
        public String Title_Holder7_Add_line3;  //L3
        public String Title_Holder8_Name1;  //name8
        public String Title_Holder8_Add_line1;  //L1
        public String Title_Holder8_Add_line2;  //L2
        public String Title_Holder8_Add_line3;  //L3
        public String Title_Holder9_Name1;  //name9
        public String Title_Holder9_Add_line1;  //L1
        public String Title_Holder9_Add_line2;  //L2
        public String Title_Holder9_Add_line3;  //L3
        public String Title_Holder10_Name1;  //name10
        public String Title_Holder10_Add_line1;  //L1
        public String Title_Holder10_Add_line2;  //L2
        public String Title_Holder10_Add_line3;  //L3
        public String Title_Holder11_Name1;  //name11
        public String Title_Holder11_Add_line1;  //L1
        public String Title_Holder11_Add_line2;  //L2
        public String Title_Holder11_Add_line3;  //L3
        public String Title_Holder12_Name1;  //name12
        public String Title_Holder12_Add_line1;  //L1
        public String Title_Holder12_Add_line2;  //L2
        public String Title_Holder12_Add_line3;  //L3
        public String Title_Holder13_Name1;  //name13
        public String Title_Holder13_Add_line1;  //L1
        public String Title_Holder13_Add_line2;  //L2
        public String Title_Holder13_Add_line3;  //L3
        public String Title_Holder14_Name1;  //name14
        public String Title_Holder14_Add_line1;  //L1
        public String Title_Holder14_Add_line2;  //L2
        public String Title_Holder14_Add_line3;  //L3        
        public String MOD_Branch;
        public String Borrower_Names;
        public String Title_Holder_details;
        public String Mod_date;
        public String Xerox_Doc_table;
        public String Xerox_Reason1;
        public String Xerox_Reason2;
        public String Sanction_Ref_Number;
        public String Sanction_date;
        public String Ap_LT;
        public String Guarantor_Details;
        public String Int_ROI;
        public String Loan_tenor;
        public String Holiday_period;
        public String Guarantor1_Names;
        public String Guarantor2_Names;
        public String Guarantor3_Names;
        public String Guarantor4_Names;
        public String Guarantor5_Names;
        public String Guarantor6_Names;
        public String Guarantor7_Names;
        public String Guarantor8_Names;
        public String Guarantor9_Names;
        public String Guarantor10_Names;        
        public String Auth_Sign_Bnk;
        public String Ap_LT_inwords;
        public String Loan_Purpose;
        public String Int_Type;
        public String ROI_MCLR;
        public String MCLR_Rate;
        public String Rating_Freq;
        public String PreClosure_Charges;
        public String DD_FI;
        public String DD_LI;
        public String Borrower1_Names;
        public String Borrower2_Names;
        public String Borrower3_Names;
        public String Borrower4_Names;
        public String Borrower5_Names;
        public String Extent_Site_Uds; //new
        public String Penal_Interest; //new field 19/06/2018
        Public String EMI_amount; //new added 26-6-2018
        //LAP-A23
        public String Variance;
        public String Property_Nature1;
        public String Property_Nature2;
        public String Property_Nature3;
        public String Property_Nature4;
        public String Property_Nature5;
        public String Survey_No_1;
        public String Survey_No_2;
        public String Survey_No_3;
        public String Survey_No_4;
        public String Survey_No_5;
        public String Plot_Door_Bungalow_No_1;
        public String Plot_Door_Bungalow_No_2;
        public String Plot_Door_Bungalow_No_3;
        public String Plot_Door_Bungalow_No_4;
        public String Plot_Door_Bungalow_No_5;
        public String Extent_Site_Uds_1;
        public String Extent_Site_Uds_2;
        public String Extent_Site_Uds_3;
        public String Extent_Site_Uds_4;
        public String Extent_Site_Uds_5;
        public String Built_up_area_1;
        public String Built_up_area_2;
        public String Built_up_area_3;
        public String Built_up_area_4;
        public String Built_up_area_5;
        public String Floor_No_1;
        public String Floor_No_2;
        public String Floor_No_3;
        public String Floor_No_4;
        public String Floor_No_5;
        public String Ward_No_1;
        public String Ward_No_2;
        public String Ward_No_3;
        public String Ward_No_4;
        public String Ward_No_5;
        public String Building_Society_Name_No_1;
        public String Building_Society_Name_No_2;
        public String Building_Society_Name_No_3;
        public String Building_Society_Name_No_4;
        public String Building_Society_Name_No_5;
        public String Street_Name_1;
        public String Street_Name_2;
        public String Street_Name_3;
        public String Street_Name_4;
        public String Street_Name_5;
        public String Village_Town_1;
        public String Village_Town_2;
        public String Village_Town_3;
        public String Village_Town_4;
        public String Village_Town_5;
        public String Taluka_Tehsil_1;
        public String Taluka_Tehsil_2;
        public String Taluka_Tehsil_3;
        public String Taluka_Tehsil_4;
        public String Taluka_Tehsil_5;
        public String District_Name_1;
        public String District_Name_2;
        public String District_Name_3;
        public String District_Name_4;
        public String District_Name_5;
        public String State_Name_1;
        public String State_Name_2;
        public String State_Name_3;
        public String State_Name_4;
        public String State_Name_5;
        public String PIN_CODE_1;
        public String PIN_CODE_2;
        public String PIN_CODE_3;
        public String PIN_CODE_4;
        public String PIN_CODE_5;
        public cls_TableData[] TableData;
    }*/
    
    public class FirstPartyAddress {
        public String StreetAddress;
        public String Locality;
        public String City;
        public String State;
        public String Pincode;
        public String Country;
    }
    
    public class StampPaperData {
        public String UID;   //kBtb5aQ48k4x5Vlkp8dj2eOH1bql/zEjyzgyHFGCUGw=
        public String FirstParty;
        public FirstPartyAddress FirstPartyAddress;
        public String SecondParty;
        public FirstPartyAddress SecondPartyAddress;
        public String StampAmount;
        public String StampDutyPaidBy;
        public String DocumentCategory;
        public String StampState;
    }
    public class cls_TableData {
        public String sr_no;  //1
        public String Doc_no;  //doc_no
        public String Doc_dt;  //doc_dt
        public String doc_nature;  //doc_nature
        public String transferor;  //transferor
        public String transferee;  //transferee
    }    
    
    
    public static Estamp_HelperStructure parse(String json) {
        return (Estamp_HelperStructure) System.JSON.deserialize(json, Estamp_HelperStructure.class);
    }
}