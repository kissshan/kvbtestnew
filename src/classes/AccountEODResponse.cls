/*
 * Name     : AccountEODResponse
 * Company  : ET Marlabs
 * Purpose  : Account Master sink from CBS to LOS System. 
 * Author   : Raushan
*/

public class AccountEODResponse{
    public cls_out_msg out_msg;
    public String bpms_error_code;  //00
    public String bpms_error_msg;   //Success
    public class cls_out_msg {
        public Integer total_size;  //1
        public cls_ACCOUNT[] ACCOUNT;
    }
    public class cls_ACCOUNT {
        public String name; //SUYOJIT BIO TECH
        public String customer_id;  //768965
        public String account_open_date;    //01-01-1990
        public String banking_with_us;  //01-01-1990
        public String branch_code;  //1234
        public String branch_name;  //KARUR
        public String export_zone;  //true
        public String cin_number;   //12345
        public String pan_number;   //bpl1234px
        public String chief_person_name;    //str123
        public String contact_person_name;  //str123
        public String contact_person_designation;   //PARTNER
        public String constitution; //PARTNERSHIP FIRM
        public String customer_type;    //str123
        public String date_of_incorporation;    //01-01-1990
        public String firm_company_was_reconstituted;   //true
        public String gst_number;   //str12334
        public String ie_code;  //str1234
        public String industry_type;    //str123
        public String line_of_activity; //GROWING AND SUPPLY OF MUSHROOM VEGETABLES BIO FERTILIZERS
        public String national_identification;  //IN
        public String networth_as_on;   //01-01-1990
        public String existing_networth;    //12345
        public String number_of_share_held; //1234
        public String over_due; //str123
        public String paid_up_capital_on;   //01-01-1990
        public String paid_up;  //1234
        public String priority_sector;  //true
        public String whether_sme;  //true
        public String registered_office_street; //str123
        public String registered_office_city;   //str123
        public String registered_office_state;  //str123
        public String registered_office_country;    //str123
        public String registered_office_postalcode; //123456
        public String corporate_office_street;  //str123
        public String corporate_office_city;    //str123
        public String corporate_office_state;   //str123
        public String corporate_office_country; //str123
        public String corporate_office_postalcode;  //123456
        public String Ship_bill_date;   //12-03-2017
        public String Remit_date;   //12-03-2017
        public String ORM_date; //12-03-2017
        public String is_kvb_director;  
        public cls_PARTIES[] PARTIES;
        public cls_FACILITY[] FACILITY;
        public cls_INSURANCE[] INSURANCE;
        public cls_GROUP_CONCERN[] GROUP_CONCERN;
    }
    public class cls_PARTIES {
        public String is_active;    //12345
        public String Business_custid;  //12345
        public String applicant_related_to_bank_director;
        public String customer_id;  //12345
        public String name; //str123
        public String pan_number;   //bpl1234px
        public String aadhar_card;  //1234567890
        public String passport; //str123
        public String spouse_name;  //str123
        public String voter_id; //str123
        public String marital_status;   //Married
        public String designation;  //str123
        public String education_qualification;  //Other
        public String electricity_no;   //str123
        public String nationality;  //str123
        public String ration_card;  //str123
        public String email;    //str123
        public String mobile;   //9876565433
        public String DOB;  //01-01-1991
        public String father_name;  //str123
        public String husband_name; //str123
        public String gender;   //str123
        public String branch_code;  //1234
        public String customer_type;    //PARTNERSHIP FIRM
        public String branch_name;  //KARUR
        public String banking_with_us;  //01-01-1990
        public String customer_ic;  //123456
        public String party_type;   //PARTNER
        public String Permanent_Street; //str123
        public String Permanent_city;   //str123
        public String Permanent_pincode;    //123456
        public String Permanent_country;    //str123
        public String Permanent_State;      //str345
        public String Active_Partener; //true
        public cls_INSURANCE[] PARTIES_INSURANCE;
        public cls_FACILITY[] PARTIES_FACILITY;
    }
    public class cls_FACILITY {
        public String account_number;   //12345678913456
        public String customer_id;  //12345
        public String branch_code;  //1143
        public String branch_name;  //KARUR - CENTRAL
        public String due_date; //01-01-1991
        public String product_class;    //Working Capital
        public String sub_class;    //str123
        public String fec_number;   //1142201700003
        public String fin_year; //01-01-1991
        public String usance;   //12345
        public String lead_time;    //12345
        public String sanction_auth;    //DO
        public String brnrefno; //1142201700003
        public String prod_code;    //792
        public String prod_desc;    //FLEXI MOBILE - COMM / CORP
        public String existing_limit;   //1410000
        public String balos;    //12345
        public String int_rate; //123
        public String arrears;  //1234
        public String amount_disbursed; //12345
        public String amount_net_disbursed; //12345
        public String amount_yet_disbursed; //12345
        public String purpose_of_loan;  //TO PURCHASE BRAND NEW HYUNDAI CRETA CAR COSTING RS.1574551.00
        public String los_prod_code;    //79200
        public String active;   //true
        public cls_COLLATERALS[] COLLATERALS;
        public cls_COLLATERALS[] PARTIES_COLLATERALS;
    }
    public class cls_COLLATERALS {
        public String is_active;    //12345
        public String collateral_id;    //NA10461
        public String branch_code;  //1234
        public String loan_custid;  //12345
        public String cersai_asset_id;  //12345
        public String cersai_security_id;   //12345
        public String cersai_reg_date;  //01-01-1991
        public String srn_no;   //12345
        public String srn_date; //01-01-1991
        public String nature_of_property;   //str123
        public String tot_survey_numbers;   //str123
        public String plot_no;  //str123
        public String door_no;  //str123
        public String area_sqft;    //1234
        public String floor_no; //str123
        public String block_ward_no;    //str123
        public String building_name;    //str123
        public String street;   //str123
        public String landmark; //str123
        public String state_name;   //str123
        public String district; //str123
        public String taluk;    //str123
        public String sro_name; //str123
        public String city; //str123
        public String pincode;  //123456
        public String land_value;   //12345
        public String building_value;   //12345
        public String tot_asset_value;  //12345
        public String carpet_area;  //1234
        public String builtup;  //1234
        public String valuation_date;   //01-01-1990
        public String valuer_name;  //str123
        public String valuer_identity;  //str123
        public String legal_opinion_date;   //01-01-1990
        public String advocate_name;    //str123
        public String advocate_identity;    //str123
        public String em_date;  //01-01-1990
        public String latitude; //1234
        public String longitude;    //1234
        public String ownership_type;   //str123
        public String no_of_owners; //123
        public String mortgage_type;    //str123
        public String document_type;    //str123
        public String document_no;  //1234
        public String document_date;    //01-01-1990
        public String ec_date;  //01-01-1990
        public String collateral_category;  //Land and Building
        public String collateral_type;  //Primary securities
        public String account_number;   //12345678901234
        public String branch_name;  
        public String surrender_value;
        public String policy_number;
        public String maturity_date;
        public String vehicle_number;
        public String machinery_model;
        public cls_OWNERSHIP[] OWNERSHIP;
        public cls_Survey[] Survey;
        public cls_OWNERSHIP[] PARTIES_OWNERSHIP;
        public cls_Survey[] PARTIES_Survey;
    }
    public class cls_OWNERSHIP {
        public String Collateral_id;    //NA10461
        public String branch_code;  //1234
        public String loan_custid;  //11840353
        public String owner_name;   //str123
        public String owner_cust_id;    //13766650
        public String owner_aadhar; //0123456789123
        public String owner_pan;    //bpl1234px
    }
    public class cls_Survey {
        public String Collateral_id;    //NA10461
        public String Branch_code;  //1234
        public String Survey_No;    //732
        public String sub_div_No;   //12
    }
    public class cls_INSURANCE {
        public String customer_id;  //12345
        public String Entry_Branch_Code;    //4825
        public String Assured_Amount;   //1,450,000.00
        public String CBS_Reference_Value;  //4825223000000012
        public String Insurance_Details;    //for stock insurance renewd from 280317 STOCK VALUE IS 30,00,000.00
        public String Sl_No;    //1
        public String Security_Type;    //GOODS
        public String Security_Value;   //3,000,000
        public String Date_Insure;  //19-03-2014
        public String Date_Policy_Expiry;   //27-03-2018
        public String Insurer_Name; //BAJAJ ALLIANZ GENERAL INSURANCE
        public String Insurer_Number;   //og-17-1801-4001-00004779
    }
    public class cls_GROUP_CONCERN {
        public String firm_custid;  //12345
        public String related_firm_custid;  //12345
        public String related_firm_name; // DTDC & Co.
        public String comp_detail_type; //str123
        public String account_open_date;    //01-01-1990
        public String banking_with_us;  //01-01-1990
        public String branch_code;  //1234
        public String branch_name;  //KARUR
        public String export_zone;  //true
        public String customer_since;   //01-01-1990
        public String cin_number;   //12345
        public String pan_number;   //bpl1234px
        public String chief_person_name;    //str123
        public String contact_person_name;  //str123
        public String contact_person_designation;   //PARTNER
        public String constitution; //PARTNERSHIP FIRM
        public String customer_type;    //str123
        public String date_of_incorporation;    //01-01-1990
        public String firm_company_was_reconstituted;   //true
        public String gst_number;   //str12334
        public String ie_code;  //str1234
        public String industry_type;    //str123
        public String line_of_activity; //GROWING AND SUPPLY OF MUSHROOM VEGETABLES BIO FERTILIZERS
        public String national_identification;  //IN
        public String networth_as_on;   //01-01-1990
        public String existing_networth;    //12345
        public String number_of_share_held; //1234
        public String over_due; //str123
        public String overall_exposure; //12345
        public String paid_up_capital_on;   //01-01-1990
        public String paid_up;  //1234
        public String priority_sector;  //true
        public String whether_sme;  //true
        public String availment_amount; //1234
        public String registered_office_street; //str123
        public String registered_office_city;   //str123
        public String registered_office_state;  //str123
        public String registered_office_country;    //str123
        public String registered_office_postalcode; //123456
        public String corporate_office_street;  //str123
        public String corporate_office_city;    //str123
        public String corporate_office_state;   //str123
        public String corporate_office_country; //str123
        public String corporate_office_postalcode;  //123456
    }
    public static AccountEODResponse parse(String json){
        return (AccountEODResponse) System.JSON.deserialize(json, AccountEODResponse.class);
    }

}