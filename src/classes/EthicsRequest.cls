/*
 * Name     : EthicsRequest
 * Company  : ET Marlabs
 * Purpose  : This class is used as a Request for WS_EthicsCall Webservice.
 * Author   : Raushan
 * 
 */
public class EthicsRequest{
	public String exe_tenantId;	
	public String owner_tenantId;	
	public cls_inputVariables inputVariables;
	
	public class cls_inputVariables {
       	public cls_in_msg in_msg;
	}
    public class cls_in_msg {
		public String REQ_APP;	
		public String REQ_DATE;	
		public String REQ_TIME;	
		public String Branch_Code;	
		public String Customer_ID;	
		public String GL_Date;
	}
	public static EthicsRequest parse(String json){
		return (EthicsRequest) System.JSON.deserialize(json, EthicsRequest.class);
	}

	
}