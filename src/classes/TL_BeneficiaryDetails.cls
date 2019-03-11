global class TL_BeneficiaryDetails{

Webservice static clcommon__Collateral__c getbeneficiarydetails(String collateralid,String ddneftnumber,String disbursementtype){

Boolean flag=false;
FetchNeftDDresponsewrapper reswrap;
List<clcommon__Collateral__c> lcoltrl=[select id,Beneficiary_Name__c,Demand_Draft_Number_NEFT_Number__c,Disbursement_Type__c,Disbursed_Amount__c,Dealer_name__c from clcommon__Collateral__c where id =:collateralid];
String reqStr='';
try{

BeneficiaryDetailsWrapper outreq=new BeneficiaryDetailsWrapper();
outreq.exe_tenantId='cuecent_tenant';
outreq.owner_tenantId='cuecent_tenant';

BeneficiaryDetailsWrapper.inputvar innerinputvar=new BeneficiaryDetailsWrapper.inputvar();
BeneficiaryDetailsWrapper.inmsg lastinner=new BeneficiaryDetailsWrapper.inmsg();
lastinner.Transaction_Ref_Number=lcoltrl[0].Demand_Draft_Number_NEFT_Number__c;
lastinner.Mode_Of_Payment=lcoltrl[0].Disbursement_Type__c;
innerinputvar.in_msg=lastinner;
outreq.inputVariables=innerinputvar;
reqStr = JSON.serialize(outreq);
System.DEBUG('REQUEST '+reqStr);
HTTPResponse response = new HTTPResponse();
Map<String,String> headerMap = new Map<String,String>();  
headerMap.put('Content-Type','application/json'); 
//headerMap.put('Authorization',auth);
System.DEBUG('BEFORE SENDING REQUEST');
System.DEBUG(Utility.getFullEndpoints('Fetch_DDNEFT_Details'));
response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('Fetch_DDNEFT_Details'),'POST',null,reqStr,headerMap,null);
System.debug('HERERE '+response.getbody());


if(response.getStatusCode() == 200 || response.getStatusCode() == 201){

	reswrap=(FetchNeftDDresponsewrapper)Json.deserialize(response.getbody(),FetchNeftDDresponsewrapper.class);

	if(reswrap.out_msg.ErrorCode!='01'){
	lcoltrl[0].Beneficiary_Name__c= reswrap.out_msg.Beneficiary_Cust_Name;
	lcoltrl[0].Disbursed_Amount__c	=Decimal.valueof(reswrap.out_msg.Transation_Amount);
	lcoltrl[0].BeneficiaryCheckDone__c=true;
	update lcoltrl;
}
else{
	System.debug('No Data');

}
}
}
catch(Exception e){

	HandleBusinessException.captureError('TL_BeneficiaryDetails','getbeneficiarydetails',e);
}

return lcoltrl[0];

}

}