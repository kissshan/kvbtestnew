/* 
* Name     : CBS_CBR_FieldUpdation
* Purpose  : Formatter class to prepare request and handle response for CBR Filed Updation
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class CBS_CBR_FieldUpdation {
    //Request structure
    public class RequestStructure{
        public String exe_tenantId;	//cuecent_tenant
        public String owner_tenantId;	//cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String AccountNumber;	//1152223000000359
        public String CustomerID;	//16141796
        public String MISType;	//CH
        public String GovtScheme;	//null
        public String Guarantee;	//null
        public String Others;	//null
        public String Refinance;	//null
        public String SanctionReference;	//CC/1101/2018/001
        public String SanctionDate;	//07022018
        public String DateoOfDPN;	//07022018
        public String DateOfRevivalLetter;	//null
        public String PSDateOfValuation_Inspection;	//null
        public String Investment_In_P_And_M;	//null
        public String CreditRiskRating;	//null
        public String RiskClass;	//null
        public String SME;	//null
        public String RiskWeight;	//null
        public String LoanDate;	//07022018
        public String SanctionBy;	//5
        public Integer PSValue_On_Date_Of_Inspection;	//0
        public Integer CSValue_On_Date_Of_Inspection;	//0
        public Integer SubsidyAmount;	//0
        public Integer Margin;	//0
        public Integer Code_No_Of_Manager_Sanction;	//0
        public Integer RBIPurposeCode;	//0
        public Integer ENCPortCode;	//0
        public Integer SectorEngagedIn;	//0
        public Integer Investment_In_Equipment_Service;	//0
        public Integer Sales_Turnover_Rupees;	//0
        public Integer Number_Of_Items_Jewels;	//0
        public Integer Jewels_Gross_Weight_gms;	//0
        public Integer Jewels_Net_Weight_gms;	//0
        public Integer Category_Of_Borrowers;	//0
        public String MakerID;	//TELLER
        public String CheckerID;	//SYSSUPER
    }
    //Response structure
    public class ResponseStructure{
        public String bpms_error_code;	//00
        public cls_out_msg out_msg;
        public cls_bpms_error_msg bpms_error_msg;
    }
    
    public class cls_out_msg {
        public String RESDate;	//07-02-2018
        public Integer REPLY_CODE;	//0
        public String RESTime;	//15:53:34
        public String ErroCode;	//00
        public String ErrorMessage;	//Success
    }
    class cls_bpms_error_msg {
    }
}