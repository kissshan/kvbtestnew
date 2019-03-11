public class Form26asResponse{

public cls_form26ASDetails form26ASDetails;
	public class cls_form26ASDetails {
		public cls_form26asInfo[] form26asInfo;
		public cls_personalInfo personalInfo;
	}
	public class cls_form26asInfo {
		public String assessmentYear;	//2016-17
		public String financialYear;	//2015-16
		public cls_nonTdsList[] nonTdsList;
		public cls_tdsList[] tdsList;
	}
	public class cls_nonTdsList {
		public String tax;	//0
		public String datevalue;	//2017-01-18
		public String bsrCode;	//192
		public String minorHead;	//XXXXX########
		public String majorHead;	//XXXXX########
	}
	public class cls_tdsList {
		public String section;
		public String deductor;
		public String tdsDate;
		public String amount;
		public String tan;
		public String taxDeducted;
	}
	public class cls_personalInfo {
		public String address;	//XXXXXXXXXX XXXXX ######
		public String dob;	//01/01/1990
		public String name;	//TAXPAYER
		public String pan;	//ABCD1234Z
		public String panStatus;	//Active
	}
	public static Form26asResponse parse(String json){
		return (Form26asResponse) System.JSON.deserialize(json, Form26asResponse.class);
	}

	
}