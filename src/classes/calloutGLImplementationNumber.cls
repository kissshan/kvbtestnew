global class calloutGLImplementationNumber{

global static String checGLNumberAndAmount(String GlNumber,Decimal feesamount ,String brcode,Datetime taskcreationdate){
//= decimal.valueof(feesamount1);
Date dateofTransaction;
String returnmess='';
string reqStr;
Date taskcreationdateindate;
if(taskcreationdate !=null){

taskcreationdateindate= date.newinstance(taskcreationdate.year(), taskcreationdate.month(), taskcreationdate.day());
}

SME_TL_GL_ImplementationRequest outerreq=new SME_TL_GL_ImplementationRequest();
outerreq.exe_tenantId='cuecent_tenant';
outerreq.owner_tenantId='cuecent_tenant';

SME_TL_GL_ImplementationRequest.inputvar innergl=new SME_TL_GL_ImplementationRequest.inputvar();
SME_TL_GL_ImplementationRequest.inmsg innermsg=new SME_TL_GL_ImplementationRequest.inmsg();
innermsg.ReconNo=GlNumber;
innermsg.BranchCode=brcode;
outerreq.inputVariables=innergl;
innergl.in_msg=innermsg;
reqStr = JSON.serialize(outerreq);
HTTPResponse response = new HTTPResponse();

try{

Map<String,String> headerMap = new Map<String,String>();  
headerMap.put('Content-Type','application/json'); 
//headerMap.put('Authorization',auth);
response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('FCR_SME_TL_PROSFEECONF_GL_Endpoint'),'POST',null,reqStr,headerMap,null);
System.debug(response.getbody());

}

catch(Exception ex){
HandleBusinessException.captureError('calloutGLImplementationNumber','checGLNumberAndAmount',ex);

}

SME_TL_GL_ImplementationResponse finalresp=(SME_TL_GL_ImplementationResponse)Json.deserialize(response.getbody(),SME_TL_GL_ImplementationResponse.class);
System.debug(finalresp.out_msg.DateOfTransaction);
if(finalresp.out_msg.HttpStatus==null)
{
    dateoftransaction=setStringToDateFormat(finalresp.out_msg.DateOfTransaction);
}
System.debug(dateoftransaction);
System.debug(taskcreationdateindate);
System.debug(math.abs(taskcreationdateindate.daysBetween(dateoftransaction)));
System.debug(feesamount);
//System.debug(Integer.valueof(finalresp.out_msg.ReconAmount)+ '-----'+feesamount );
System.debug(decimal.valueOf(finalresp.out_msg.ReconAmount));
if(finalresp!=null){
if(finalresp.out_msg.HttpStatus == null && taskcreationdateindate!=null){
System.debug(finalresp.out_msg.HttpStatus+' --'+taskcreationdateindate);
if(decimal.valueOf(finalresp.out_msg.ReconAmount) == feesamount && math.abs(taskcreationdateindate.daysBetween(dateoftransaction)) <= 10){

returnmess='Success';
}
}
else{
//System.debug('Either amount or date did not match');
if(finalresp.out_msg.ErrorMessage == 'Success'){
returnmess='Either amount or date did not match the criteria';
}
else{
returnmess=finalresp.out_msg.ErrorMessage;
}
}

}
return returnmess;

}

global static Date setStringToDateFormat(String myDate) {
   String[] strDate = myDate.split('-');
   Integer myIntMonth = integer.valueOf(strDate[1]);
   
   Integer myIntyear = integer.valueOf(strDate[0]);
   Integer myIntDate = integer.valueOf(strDate[2]);
   System.debug(myIntDate +' --- '+myIntMonth+'--- '+myIntYear);
   Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
   return d;
}

}