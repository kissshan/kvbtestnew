global with sharing class SME_Collateral_DeDupe {
	public SME_Collateral_DeDupe() {
		
	}



	public class collatDedupeRequest{
		public String exe_tenantId;	//cuecent_tenant
		public String owner_tenantId;	//cuecent_tenant
		public cls_inputVariables inputVariables;
	}
	class cls_inputVariables {
		public cls_in_msg in_msg;
	}
	public class cls_in_msg {
		public String SuveryNo;	//737
		public String SubDivNo;	//part
		public String PattaNo;	//0
		public String DocumentNo;	//991
		public String DocumentDate;	//14-Mar-2011
		public String CustName;	//DHARMENDRA RAMAIYA VENKATACHALAPATHY
		public String StateName;	//tamilNADU
		public String DistrictName;	//chennai
	}

	public class collatDedupeResponse{
		public String bpms_error_code;	//00
		public cls_out_msg out_msg;
		public String bpms_error_msg;	//Success
		
	}
	public class cls_out_msg {
		public String CollateralID;	//NA17001
		public String LoanCustID;	//11840353
		public String ErrorCode;	//0
		public String ErrorMessage;	//Success
		public String CustFullName;	//DHARMENDRA R V
	}

	webService static String dedupeCallout(String SuveryNo,String SubDivNo,String PattaNo,String DocumentNo,String DocumentDate,String CustName,String StateName,String DistrictName){
		String returnString=null;
		collatDedupeRequest dedupReq= new collatDedupeRequest();
		dedupReq.inputVariables = new cls_inputVariables();
		dedupReq.inputVariables.in_msg= new cls_in_msg();

		dedupReq.exe_tenantId= 'cuecent_tenant';
		dedupReq.owner_tenantId= 'cuecent_tenant';
		//dedupReq.inputVariables.in_msg.SuveryNo= SuveryNo;
		dedupReq.inputVariables.in_msg.SubDivNo= SubDivNo;
		dedupReq.inputVariables.in_msg.PattaNo= PattaNo;
		dedupReq.inputVariables.in_msg.DocumentNo= DocumentNo;
		dedupReq.inputVariables.in_msg.DocumentDate= DocumentDate;
		dedupReq.inputVariables.in_msg.CustName= CustName;
		dedupReq.inputVariables.in_msg.SuveryNo= SuveryNo;
		dedupReq.inputVariables.in_msg.StateName= StateName;
		dedupReq.inputVariables.in_msg.DistrictName= DistrictName;

		system.debug('dedupReq============> '+ JSON.serialize(dedupReq));

		KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('FRS_COLLATERAL_DEDUPE');
		//(String endpoint, String method, Integer timeOut,String body,Map<String,String> headerMap,String certfName){
		map<String,String> headerMap= new map<String,String>{'Content-Type' => 'application/json'};
		HttpResponse dedupRes= HttpUtility.sendHTTPRequest(kvb.Endpoint_URL__c,'POST',null,JSON.serialize(dedupReq),headerMap,null); 
		//HttpUtility.sendHTTPRequest(kvb.Endpoint_URL__c,'POST',JSON.serialize(dedupReq));
		system.debug('getStatusCode===> '+dedupRes.getStatusCode());
		system.debug('getStatus===> '+dedupRes.getStatus());
		system.debug('getBody===> '+dedupRes.getBody());

		if(dedupRes.getStatusCode()==200 || dedupRes.getStatusCode()==201){
			String jsonString= dedupRes.getBody();
			collatDedupeResponse res= (collatDedupeResponse) JSON.deserialize(jsonString, collatDedupeResponse.class);
			if(res.out_msg.ErrorMessage=='Success'){
				//returnString = jsonString;
				returnString=  res.out_msg.CollateralID+'--'+res.out_msg.LoanCustID+'--'+res.out_msg.CustFullName;
				//system.debug(' res.out_msg.CollateralID===>'+  res.out_msg.CollateralID);
				/*returnString.replace('<CollateralID>', '"'+String.valueOf(res.out_msg.CollateralID)+'"');
				returnString.replace('<LoanCustID>', '"'+String.valueOf(res.out_msg.LoanCustID)+'"');
				returnString.replace('<LoanCustID>', '"'+String.valueOf(res.out_msg.LoanCustID)+'"');
				returnString.replace('<CustFullName>', '"'+String.valueOf(res.out_msg.CustFullName)+'"');*/
				//system.debug('returnString====> '+returnString);
			}
		}

		return returnString;
	}
}