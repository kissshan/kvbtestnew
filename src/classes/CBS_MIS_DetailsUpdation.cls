/* 
* Name     : CBS_MIS_DetailsUpdation
* Purpose  : Formatter class to prepare request and handle response for MIS details updation
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class CBS_MIS_DetailsUpdation {
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
        public String Mnemonic;	//1152223000000359
        public String Security;	//1
        public String NoOfDependents;	//
        public String PrioritySectorCode;	//999
        public String SpouseIncome;	//2
        public String Occupation;	//99999
        public String MonthlyHouseHoldIncome;	//2
        public String RBIPurpose;	//99999
        public String AssetOwnership;	//4
        public String Nostro;	//NO_NOSTRO
        public String ResidenceDetails;	//1
        public String SelectedSecurityCode;	//1
        public String CreditCardDetails;	//10
        public String BSRActivityCode;	//9
        public String BankingActivities;	//99
        public String CategoryOfBorrowers;	//99
        public String InvestmentPreference;	//1
        public String ExportDocType;	//NA
        public String LoanDetails;	//2
        public String ExportStatusHolder;	//NA
        public String PresentLoanRequirements;	//1
        public String MakerID;	//LAPSMAKER
        public String CheckerID;	//LAPSCHECKER
    }
    
    //Response structure
    public class ResponseStructure{
        public String bpms_error_code;	//00
        public cls_out_msg out_msg;
        public cls_bpms_error_msg bpms_error_msg;
    }
    public class cls_out_msg {
        public String ErrorCode;	//0
        public String ReplyText;	//MIS Maintained sucessfully
    }
    class cls_bpms_error_msg {
    }
}