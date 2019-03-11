/*
 * Name		: SMS_ServicesRequest
 * Company	: ET Marlabs
 * Purpose 	: Request Class  for SMS_Services. 
 * Author	: Raushan
*/

public class SMS_ServicesRequest{
	public String exe_tenantId;	//cuecent_tenant
	public String owner_tenantId;	//cuecent_tenant
	public cls_inputVariables inputVariables;
    public class cls_inputVariables{
      public cls_in_msg in_msg;  
    }
	public class cls_in_msg {
		public String mobno;	//919884734748
		public String message;	//Test
	}
	public static SMS_ServicesRequest parse(String json){
		return (SMS_ServicesRequest) System.JSON.deserialize(json, SMS_ServicesRequest.class);
	}

}