/*
 * Name     : EthicsRequest
 * Company  : ET Marlabs
 * Purpose  : This class is used as a Request for WS_CommercialPRCallout Webservice.
 * Author   : Raushan
 * 
 */

public class CommercialPRRequest{
	public string exe_tenantId ='cuecent_tenant';
	public string owner_tenantId ='cuecent_tenant';
	public cls_inputVariables inputVariables;
	public String bpms_error_code;
	public cls_out_msg out_msg;
	public String bpms_error_msg;
	
    public class cls_inputVariables {
		public cls_in_msg in_msg;	//
	}
	public class cls_in_msg {
		public String Batch_ID;	//518424064915
		public cls_requestJsonStr[] requestJsonStr;
	}
	//public cls_Applicants[] Applicants; 
	public class cls_requestJsonStr {
		public String Request_ID;	//2384759706
		public String Product_Code;	//P1
		public String AddOn;	//null
		public String Output_Format;	//CSV
		public String Future_Use1;	//null
		public String Future_Use2;	//null
		public String Member_Reference_Number;	//1234556567678690
		public String Account_Number;	//348957329485
		public String Subject_Full_Name;	//skjdfhakjsdfasd
		public String Subject_Street_Address;	//sdfasdgff,dsfggfhetghd, dfgsdfgsdf
		public String City;	//Chennai
		public String State;	//Tamil Nadu
		public String Pin_Code;	//6000098
		public String PAN;	//BWLKP3456F
		public String CIN;	//null
		public String CRN;	//null
		public String TIN;	//null
		public String Telephone_Type;	//null
		public String Telephone_Number;	//null
		public String Enquiry_Purpose;	//Credit Type
		public String Loan_Amount;	//2000000.00
	}

	public class cls_out_msg {
		public String statusCode;	//0
		public String message;	//File uploaded Successfully
		public cls_HttpStatus HttpStatus;
		public String UploadBatchFileName;	//COMM_BP03220002_27062018_201147.csv
		public Integer No_Of_Records;	//4
	}

	public class cls_HttpStatus {
	}

	public static CommercialPRRequest parse(String json){
		return (CommercialPRRequest) System.JSON.deserialize(json, CommercialPRRequest.class);
	}

}