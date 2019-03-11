/* 
 * Name     : CBS_OD_TOD_Formatter
 * Purpose  : Formatter class to prepare request and handle response for OD Limit Creation /Modification and OD/TOD limit Variance
 * Company  : ET Marlabs
 * Author   : Dushyant
*/
public class CBS_OD_TOD_Formatter {
    //public CBS_OD_TOD_Formatter(){}
    //Request Format
    public class RequestFormat{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String AccountNo;
        public String MaintenanceMode;
        public String LimitStartDate;
        public String LimitEndDate;
        public String LimitAmount;
        public String SecuredFlag;
        public String InterestIndexCode;
        public String InterestRate;
        public String InterestVariance;
        public String MakerID;
        public String CheckerID;
        //public String LimitNo;
    }
    //response Format
    public class ResponseFormat{
        public String bpms_error_code;
        public cls_out_msg out_msg;
        public String bpms_error_msg;
    }
    public class cls_out_msg {
        public String ErrorCode;
        public String ReplyText;
        public String ErrorMessage;
    }
}