public class CBS_CustomerID_Creation_Handler{
    public cls_inputVariables inputVariables;
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String ApplicationId;	//012345678901
		public String serviceName;	//Customer_ID_Creation_HL
        public cls_CustIDDetails[] CustIDDetails;
    }
    public class cls_CustIDDetails {                
        public String ApplicantID; 
        public String TransactionBranch;	//1219
        public String DOB;	//19991120
        public String NRICity;	//
        public String NRIState;	//
        public String busnstyp;	//0
        public String codCustIc;	//SPOO150
        public String countryResidence;	//IN
        public String custtyp;	//RESIDENT INDIAN
        public String empId;	//
        public String fathername;	//SK
        public String firstName;	//SPOOO
        public String flgStaff;	//N
        public String fullName;	//
        public String gender;	//Female
        public String husbandname;	//
        public String introId;	//28459
        public String introcat;	//1
        public String lang;	//Eng
        public String lastName;	//Saxena
        public String mailAddr1;	//18A
        public String mailAddr2;	//Brookfiled
        public String mailAddr3;	//Whitefield
        public String mailCity;	//875
        public String mailCtry;	//IN
        public String mailEmail;	//vishal@gmail.com
        public String mailMobno;	//919455251638
        public String mailPhRes;	//919455251639
        public String mailPin;	//202111
        public String mailState;	//33
        public String maritalStatus;	//Married
        public String middleName;	//Kumar
        public String namePrefix;	//Mr
        public String nationality;	//IN
        public String nonCustType;	//KYC Provided
        public String nonCustdtls;	//Sample non customer details
        public String proffCode;	//5
        public String shrtName;	//SPOOO
        public String spousename;	//PS
    }

    
    public class CBS_CustomerID_Creation_response{
        public String bpms_error_code;
        public String bpms_error_msg;
        public cls_out_msg out_msg;
    }
    public class cls_out_msg {
        public String Status_Desc;
        public String Status_Code;
    }
}