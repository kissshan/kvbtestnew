/*
 * Name     : EthicsResponse
 * Company  : ET Marlabs
 * Purpose  : This class is used as a Response for WS_EthicsCall Webservice.
 * Author   : Raushan
 * 
 */
public class EthicsResponse{
	public String bpms_error_code;	//00
	public cls_out_msg out_msg;
	public String bpms_error_msg;
	public class cls_out_msg {
		public cls_Ethics_Response[] Ethics_Response;
		public String Status;	//00
		public String RES_DATE;	//15-02-2018
		public String ErrorCode;	//00
		public String ErrorMessage;	//Success
		public String RES_TIME;	//10:44:25
	}
	public class cls_Ethics_Response {
		public String Branch_Code;	//1152
		public String Branch_Name;	//KARUR - LNS (WEST)
		public String Account_Name;	//SHREE AUTOMOBILES
		public String Account_Number;	//1152280000001133
		public Integer GL_Date;	//1472754600000
		public Double Balance_OutStanding;	//984108.63
		public Integer AUD_Point;	//76901
		public String PROD_Desc;	//Insurance (General)    
		public String Regularity;	//Insurance not obtained / Insurance Expired
		public String Addtnl_Comment;
	}
		public static EthicsResponse parse(String json){
		return (EthicsResponse) System.JSON.deserialize(json, EthicsResponse.class);
	}

	/*static testMethod void testParse() {
		String json=		'{'+
		'   "bpms_error_code": "00",'+
		'   "out_msg":    {'+
		'      "Ethics_Response": [      {'+
		'         "Branch_Code": "1152",'+
		'         "Branch_Name": "KARUR - LNS (WEST)",'+
		'         "Account_Name": "SHREE AUTOMOBILES",'+
		'         "Account_Number": "1152280000001133",'+
		'         "GL_Date": 1472754600000,'+
		'         "Balance_OutStanding": 984108.63,'+
		'         "AUD_Point": 76901,'+
		'         "PROD_Desc": "Insurance (General)    ",'+
		'         "Regularity": "Insurance not obtained / Insurance Expired",'+
		'         "Addtnl_Comment": null'+
		'      }],'+
		'      "Status": "00",'+
		'      "RES_DATE": "15-02-2018",'+
		'      "ErrorCode": "00",'+
		'      "ErrorMessage": "Success",'+
		'      "RES_TIME": "10:44:25"'+
		'   },'+
		'   "bpms_error_msg": null'+
		'}';
		fromJSON obj = parse(json);
		System.assert(obj != null);
	} */
}