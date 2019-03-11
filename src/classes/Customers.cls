/*
 * Name     : Customers
 * Company  : ET Marlabs
 * Purpose  : This class is used as a wrapper for Webservice callout
 * Author   : Amritesh
*/
public class Customers {
    
    /*public string customerID;
    public string customerName;
    public string accountNumber;
    public string renewalDueDate;
    public string renewalAmount;
    public string preCheckListStatus;
    public string applicationID;
    public string applicationName;
    public string applicationStage;
    public string applicationUIStage;*/

    public List<cls_customerDetails> CUSTOMER_DETAILS ;
    public class cls_customerDetails{
        public String LOS_SF_RECORD_ID;
        public string customerID;
        public string customerName;
        public List<cls_ApplicationDetails> appln_info;
    }
    public class cls_ApplicationDetails{

        public String app_stage;
        public String app_type;
        public String app_due_date;
        public String app_los_id;
        public String app_name;
        public String app_ui_stage;
        public String app_total_amount;
        public String type;
        public String product_code;
        public String IS_C1_GENERATED;
        public List<cls_AppLication_Facilities> ALL_FACILITIES;

    }
    public class cls_AppLication_Facilities{
        public string facilityID;
        public string facilityLimitAmount;

        public string facilityAccountNumber;
        public string facilityProductCode;
        public string facilityProductName;
    }
}