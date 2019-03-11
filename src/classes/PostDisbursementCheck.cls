Global class PostDisbursementCheck{



webservice static List<String> mandatoryCheckCollateralls(List<String>  collidlist,String appid){
	Map<String,String> errormessagemap=new Map<String,String>();
	List<String> retmessage=new List<String>();
	String returmessage='';
	List<clcommon__Collateral__c> lstcol=new List<clcommon__Collateral__c>();
	try{
		lstcol=[select id,recordtype.developername,name,RC_No__c,Beneficiary_Name__c,IsFirstCompletionCertificate__c,BeneficiaryCheckDone__c,RCCheckDone__c,Financing_Authority__c,Demand_Draft_Number_NEFT_Number__c,Deviation_RC__c,IsSaleDeedLoaded__c,Deviation_Beneficiary__c,Rationale__c,IsRCCopyLoaded__c,IsInstallationCertificateLoaded__c,IsCompletionCertificateLoaded__c,IsTaxInvoiceLoaded__c,IsCACertificateLoaded__c,Chassis_Number__c,Engine_number__c,Machine_Serial_Number__c from clcommon__Collateral__c where id in :collidlist];
		For(clcommon__Collateral__c collrec:lstcol){
			if(collrec.recordtype.developername =='Passenger_Vehicle'){
				Map<String,String> resultmap=checkmissingfieldforVehicles(collrec);	
				if(resultmap!=null && !resultmap.isEmpty()){
					errormessagemap.putAll(resultmap);
				}		

			}
			else if(collrec.recordtype.developername =='Commercial_Vehicle'){
				Map<String,String> resultmap=checkmissingfieldforVehicles(collrec);
				if(resultmap!=null && !resultmap.isEmpty()){
					errormessagemap.putAll(resultmap);
				}	
			}
			else if(collrec.recordtype.developername =='Land_And_Building'){
				if(collrec.IsSaleDeedLoaded__c==false || collrec.IsFirstCompletionCertificate__c==false){
					errormessagemap.put(collrec.name,'Documents not Uploaded');
				}
				if(collrec.BeneficiaryCheckDone__c==false){
					if(errormessagemap.containsKey(collrec.name)){
						String message=errormessagemap.get(collrec.name);
						errormessagemap.put(collrec.name,message+', Beneficiary Check');
					}else{
						errormessagemap.put(collrec.name,'Beneficiary Check');
					}
				}
			}
			else if(collrec.recordtype.developername=='Commercial_Machinery'){
				if(String.isBlank(collrec.Machine_Serial_Number__c)){
					errormessagemap.put(collrec.name,'Machine Serial Number ');
				}
				if(collrec.IsInstallationCertificateLoaded__c==false || collrec.IsTaxInvoiceLoaded__c==false){
					if(errormessagemap.containsKey(collrec.name)){
						String message=errormessagemap.get(collrec.name);
						errormessagemap.put(collrec.name,message+', Documents Not Uploaded');
				}
				else{
					errormessagemap.put(collrec.name,'Documents Not Uploaded');
				}
			}
			if(collrec.BeneficiaryCheckDone__c==false){
					if(errormessagemap.containsKey(collrec.name)){
						String message=errormessagemap.get(collrec.name);
						errormessagemap.put(collrec.name,message+', Beneficiary Check');
					}else{
						errormessagemap.put(collrec.name,'Beneficiary Check');
					}
				}
			}
			else if(collrec.recordtype.developername=='Construction_Equipment'){
				if(String.isBlank(collrec.Machine_Serial_Number__c)){
					errormessagemap.put(collrec.name,'Machiner Serial Number ');
				}
				if(collrec.IsInstallationCertificateLoaded__c==false || collrec.IsTaxInvoiceLoaded__c==false){
					if(errormessagemap.containsKey(collrec.name)){
						String message=errormessagemap.get(collrec.name);
						errormessagemap.put(collrec.name,message+', Documents Not Uploaded');
				}
				else{
					errormessagemap.put(collrec.name,'Documents Not Uploaded');
				}
			}
			if(collrec.BeneficiaryCheckDone__c==false){
					if(errormessagemap.containsKey(collrec.name)){
						String message=errormessagemap.get(collrec.name);
						errormessagemap.put(collrec.name,message+', Beneficiary Check');
					}else{
						errormessagemap.put(collrec.name,'Beneficiary Check');
					}
				}

			}
			else if(collrec.recordtype.developername=='Other'){
				if(String.isBlank(collrec.Machine_Serial_Number__c)){
					errormessagemap.put(collrec.name,'Machiner Serial Number ');
				}
				if(collrec.IsCompletionCertificateLoaded__c==false || collrec.IsTaxInvoiceLoaded__c==false){
					if(errormessagemap.containsKey(collrec.name)){
						String message=errormessagemap.get(collrec.name);
						errormessagemap.put(collrec.name,message+', Documents Not Uploaded');
				}else{
					errormessagemap.put(collrec.name,'Documents Not Uploaded');
				}
			}
			if(collrec.BeneficiaryCheckDone__c==false){
					if(errormessagemap.containsKey(collrec.name)){
						String message=errormessagemap.get(collrec.name);
						errormessagemap.put(collrec.name,message+', Beneficiary Check');
					}else{
						errormessagemap.put(collrec.name,'Beneficiary Check');
					}
				}
			}
			else if(collrec.recordtype.developername=='Business_Term_Loan'){
				if(collrec.IsCACertificateLoaded__c==false){
						errormessagemap.put(collrec.name,'Documents Not Uploaded');
				}
				if(collrec.BeneficiaryCheckDone__c==false){
					if(errormessagemap.containsKey(collrec.name)){
						String message=errormessagemap.get(collrec.name);
						errormessagemap.put(collrec.name,message+', Beneficiary Check');
					}else{
						errormessagemap.put(collrec.name,'Beneficiary Check');
					}
				}
			
			
			}
		}
	}
	catch(Exception ex){
		HandleBusinessException.captureError('PostDisbursementCheck','mandatoryCheckCollateralls',ex);
	}
	if(errormessagemap!=null && !errormessagemap.isEmpty()){
		for(String collname:errormessagemap.keySet()){
			retmessage.add(collname+' : '+errormessagemap.get(collname)+'\n');
		}
	}
	return retmessage;
}





webservice static List<String> checkdeviations(List<String>  collidlist,String appid){
List<String> deviationcollname=new List<String>();
boolean result=false;
Map<String,Boolean> allcollaterdevaition=new Map<String,Boolean>();
Boolean OpenDeviationTaskexist=false;
closePostDisbursementTaskbeforecheckingdeviation(appid);
try{
List<clcommon__Collateral__c> lstcol=[select id,recordtype.developername,name,RC_No__c,Beneficiary_Name__c,IsFirstCompletionCertificate__c,BeneficiaryCheckDone__c,RCCheckDone__c,Financing_Authority__c,Demand_Draft_Number_NEFT_Number__c,Deviation_RC__c,IsSaleDeedLoaded__c,Deviation_Beneficiary__c,Rationale__c,IsRCCopyLoaded__c,IsInstallationCertificateLoaded__c,IsCompletionCertificateLoaded__c,IsTaxInvoiceLoaded__c,IsCACertificateLoaded__c from clcommon__Collateral__c where id in :collidlist];


For(clcommon__Collateral__c collrec: lstcol){
OpenDeviationTaskexist=checkdeviationtASK(appid);
if(collrec.recordtype.developername =='Passenger_Vehicle'){
	System.debug('before checking deviations '+result);
	result=checkdeviationforVehicles(collrec,appid);
	System.debug('After checking deviations '+result);
	allcollaterdevaition.put(collrec.name,result);

}
else if(collrec.recordtype.developername =='Commercial_Vehicle'){
	result=checkdeviationforVehicles(collrec,appid);
	allcollaterdevaition.put(collrec.name,result);

}



else if(collrec.recordtype.developername =='Land_And_Building'){
	result=checkdeviationLandBuilding(collrec,appid);
	allcollaterdevaition.put(collrec.name,result);


}
else if(collrec.recordtype.developername=='Commercial_Machinery'){
	result=checkdeviationCMandCE(collrec,appid);
	allcollaterdevaition.put(collrec.name,result);
}
else if(collrec.recordtype.developername=='Construction_Equipment'){
	result=checkdeviationCMandCE(collrec,appid);
	allcollaterdevaition.put(collrec.name,result);

}
else if(collrec.recordtype.developername=='Other'){
  	result=checkdeviationotherloan(collrec,appid);
	allcollaterdevaition.put(collrec.name,result);
}
else if(collrec.recordtype.developername=='Business_Term_Loan'){
	result=checkdeviationBusinessLoan(collrec,appid);
	allcollaterdevaition.put(collrec.name,result);
}

}

}
catch(Exception ex){
	HandleBusinessException.captureError('PostDisbursementCheck','checkdeviations',ex);

}

for(String collname:allcollaterdevaition.keySet()){
	if(allcollaterdevaition.get(collname) == true){
		deviationcollname.add(collname);

	}
}

return deviationcollname;


}



webservice static Boolean checkdeviationtASK(String appid){
	Boolean flag=false;
try{
	System.debug('checkdeviation task '+flag);
List<genesis__Applications__c> lstapp=SOQL_Util.getApplication(new Set<Id>{appId});


flag=Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appid,'Post Disbursement Deviation');


}
catch(Exception ex){
HandleBusinessException.captureError('PostDisbursementCheck','checkdeviationtASK',ex);

}

	System.debug('checkdeviation task '+flag);

return flag;




}
public static void createopenTask(string appid){
try{
	System.debug('creating task');
List<genesis__Applications__c> lstapp=SOQL_Util.getApplication(new Set<Id>{appId});

SOQL_Util.createTaskForBM(appid,'Review Post Disbursement Discrepancy','Post Disbursement Deviation');


}
catch(Exception ex){
HandleBusinessException.captureError('PostDisbursementCheck','createopenTask',ex);

}
}

public static Boolean checkdeviationforVehicles(clcommon__Collateral__c collrec,string appid){
  
  	Boolean deviationresult=false;

	if((collrec.RCCheckDone__c==true && collrec.BeneficiaryCheckDone__c==true)){

	if(((collrec.Deviation_RC__c == true || collrec.Deviation_Beneficiary__c) && String.isBlank(collrec.Rationale__c))){
        deviationresult=true;
		if(!checkdeviationtASK(appid)){
        
			createopenTask(appid);
		}
		

		}

	}	

 	return deviationresult;

	}

	public static Boolean checkdocsuploadvehicle(clcommon__Collateral__c collrec){
		Boolean docsuploaded=false;

		if(collrec.IsRCCopyLoaded__c == true && collrec.IsTaxInvoiceLoaded__c){
		 	 docsuploaded=true;
		}

		return docsuploaded;
	}

	public static Boolean checkdeviationLandBuilding(clcommon__Collateral__c collrec,string appid){
		Boolean deviationresult=false;
		if(collrec.BeneficiaryCheckDone__c == true){
			if((collrec.Deviation_Beneficiary__c && String.isBlank(collrec.Rationale__c))){
				deviationresult=true;
				if(!checkdeviationTask(appid)){
        			createopenTask(appid);
        		}
		}


		}

		return deviationresult;
	}

	public static Boolean checkdocuploadsLandBuilding(clcommon__Collateral__c collrec){
		Boolean docscheck=false;
		if(collrec.IsSaleDeedLoaded__c == true && collrec.IsFirstCompletionCertificate__c ==true){
			docscheck=true;
		}
		return docscheck;
	}


	public static Boolean checkdeviationCMandCE(clcommon__Collateral__c collrec,String appid){
		Boolean deviationresult=false;
		if(collrec.BeneficiaryCheckDone__c == true){
			if((collrec.Deviation_Beneficiary__c && String.isBlank(collrec.Rationale__c))){
				deviationresult=true;
				if(!checkdeviationTask(appid)){
        			createopenTask(appid);
        		}
			}
		}
		return deviationresult;

	}

	public static Boolean checkdocsuploadCMandCE(clcommon__Collateral__c collrec){
		Boolean docscheck=false;
		if(collrec.IsInstallationCertificateLoaded__c==true && collrec.IsTaxInvoiceLoaded__c==true){
			docscheck=true;
		}
		return docscheck;
	}

	public static Boolean checkdeviationotherloan(clcommon__Collateral__c collrec,string appid){
		Boolean deviationresult=false;
		if(collrec.BeneficiaryCheckDone__c ==true){
			if((collrec.Deviation_Beneficiary__c && String.isBlank(collrec.Rationale__c))){
				deviationresult=true;
				if(!checkdeviationTask(appid)){
        			createopenTask(appid);
        		}
			}
		}
		return deviationresult;
	}
	public static Boolean checkdocsuploadOther(clcommon__Collateral__c collrec){
		Boolean docscheck=false;
		if(collrec.IsCompletionCertificateLoaded__c ==true && collrec.IsTaxInvoiceLoaded__c ==true){
			docscheck=true;
		}
		return docscheck;
	}

	public static Boolean checkdeviationBusinessLoan(clcommon__Collateral__c collrec,string appid){
		Boolean deviationresult=false;
		if(collrec.BeneficiaryCheckDone__c ==true){
			if((collrec.Deviation_Beneficiary__c && String.isBlank(collrec.Rationale__c))){
				deviationresult=true;
				if(!checkdeviationTask(appid)){
        			createopenTask(appid);
        		}
			}
		}
		return deviationresult;
	}

webservice static genesis__Applications__c changeapplicationstageandsubstage(List<String>  collidlist,String appid){
	List<String> returnval=new List<String>();
	genesis__Applications__c apprec;
	try{


 	apprec=changeappstages(appid);
}
catch(Exception ex){
	HandleBusinessException.captureError('PostDisbursementCheck','changeapplicationstageandsubstage',ex);
}

 return apprec;
}

public static genesis__Applications__c changeappstages(String appid){

List<genesis__Applications__c> lstapp=SOQL_Util.getApplication(new Set<Id>{appid});
Map<id,id> appcreditofficemap=SOQL_Util.BranchCreditOfficerIdMap(lstapp);
Map<string,Task> taskmap=new Map<string,Task>();
try{




//Checking the application Stage
List<Task> lsttask=[select id,type,status,ownerid,whatid from Task where whatid=:appid];
for(Task t:lsttask){
	if((t.type=='MOD Needed' && (t.ownerid ==appcreditofficemap.get(appid) || t.ownerid==lstapp[0].ownerid))){
		System.debug('Mod Needed task exist');
		taskmap.put('MOD Needed',t);
	}
	else if(t.type=='Validate Post Disbursement Details'){
		System.debug('Validate Post Disbursement Details');
		taskmap.put('PostDisbursement',t);
	}
	else if(t.type=='Verify Document'){
		System.debug('Verify Document task exist');
		taskmap.put('Verify Document',t);
	}
	else if(t.type=='Verify SI/Emandate Details'){
		System.debug('Verify SI/Emandate Details');
		taskmap.put('Verify SI/Emandate Details',t);
	}
	else if(t.type=='Post Disbursement Deviation'){
		System.debug('Post Disbursement Deviation');
		taskmap.put('Post Disbursement Deviation',t);
	}
}
System.debug(taskmap);
System.debug(taskmap.get('Verify Document'));
if(!taskmap.isEmpty()){
if(taskmap.get('Verify Document').status=='Completed' && taskmap.get('PostDisbursement').status=='Completed' && taskmap.get('MOD Needed').status=='Completed' && taskmap.get('Post Disbursement Deviation').status=='Completed' && taskmap.get('Verify SI/Emandate Details').status=='Completed'){
	System.debug('closing Application');
	lstapp[0].Application_Stage__c='New loan - Application close';
	lstapp[0].Sub_Stage__c='Applicaton Processed - Closed';

}
else if((taskmap.get('MOD Needed').status=='Completed') && taskmap.get('Verify Document').status!='Completed' && taskmap.get('PostDisbursement').status!='Completed'){
	System.debug('Document Verification Pending');
	lstapp[0].Sub_Stage__c='Document Verification Pending';
}
else if((taskmap.get('MOD Needed').status=='Completed') && taskmap.get('Verify Document').status!='Completed' && taskmap.get('PostDisbursement').status=='Completed'){
	System.debug('Document Verification');
	lstapp[0].Sub_Stage__c='Document Verification Pending';
}
else if((taskmap.get('MOD Needed').status=='Completed') && taskmap.get('Verify Document').status=='Completed' && taskmap.get('PostDisbursement').status!='Completed'){
	System.debug('PostDisbursement Pending');
	lstapp[0].Sub_Stage__c='Post Disbursement Pending';
}
else if((taskmap.get('MOD Needed').status=='Not Started')){
	System.debug('Mod Needed');
	lstapp[0].Sub_Stage__c='MOD Pending';
}
else if((taskmap.get('MOD Needed').status=='Completed') && taskmap.get('Verify Document').status=='Completed' && taskmap.get('PostDisbursement').status=='Completed'){
	if(taskmap.get('Post Disbursement Deviation').status!='Completed' || taskmap.get('Verify SI/Emandate Details').status!='Completed'){
		System.debug('PostDisbursementCheck Pending');
		lstapp[0].Sub_Stage__c='Post Disbursement Pending';
	}
}

ApplicationTriggerHandler.IsFirstRun = false;
update lstapp;
}
}
catch(Exception ex){
	HandleBusinessException.captureError('PostDisbursementCheck','changeappstages',ex);
}
/*
Task PostDisbursementtask=taskmap.get('PostDisbursement');
PostDisbursementtask.status='Completed';
update PostDisbursementtask;
*/
return lstapp[0];




}

webservice static Boolean checkValidatePostDisbursementTaskexistOrDeviationtask(String appid){
	Boolean flag=false;
try{
	//System.debug('checkdeviation task '+flag);
//List<genesis__Applications__c> lstapp=SOQL_Util.getApplication(new Set<Id>{appId});


if(Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appid,'Validate Post Disbursement Details') || checkdeviationtASK(appid)){
	flag=true;
}


}
catch(Exception ex){
HandleBusinessException.captureError('PostDisbursementCheck','checkValidatePostDisbursementTaskexistOrDeviationtask',ex);

}
return flag;

}

public static void closePostDisbursementTaskbeforecheckingdeviation(String appid){
		
	try{
		List<Task> PostDisbursementtask=[select id,type,status,ownerid,whatid from Task where whatid=:appid and type='Validate Post Disbursement Details' and status!='Completed'];
		System.debug(PostDisbursementtask);
		if(PostDisbursementtask.size()==1){
		PostDisbursementtask[0].status='Completed';
		update PostDisbursementtask;
		}
	}
	catch(Exception ex){
		HandleBusinessException.captureError('PostDisbursementCheck','getmodneededtask',ex);
	}

}

public static Map<String,String> checkmissingfieldforVehicles(clcommon__Collateral__c collrec){

	Map<String,String> errormessagemap=new Map<String,String>();
	
				String message='';
				if(collrec.RCCheckDone__c==false){
					//returmessage='RC check has not been done for collateral : '+collrec.name+'\\n';
					message='RC Check ';
					errormessagemap.put(collrec.name,message);
				}
				if(String.isBlank(collrec.Engine_number__c)){
					if(errormessagemap.keySet().contains(collrec.name)){
					message=errormessagemap.get(collrec.name);
					errormessagemap.put(collrec.name,message+'Engine No. Blank, ');
					}
					else{
						errormessagemap.put(collrec.name,message+'Engine No. Blank');
					}
				}
				if(String.isBlank(collrec.Chassis_Number__c)){
					if(errormessagemap.keySet().contains(collrec.name)){
					message=''+errormessagemap.get(collrec.name);
					errormessagemap.put(collrec.name,message+'Chassis No. Blank');
					}
					else{
						errormessagemap.put(collrec.name,'Chassis No. Blank');
					}
				}
				if(collrec.BeneficiaryCheckDone__c==false){
					if(errormessagemap.keySet().contains(collrec.name)){
					message=''+errormessagemap.get(collrec.name);
					errormessagemap.put(collrec.name,message+', Beneficiary Check');
					}
					else{
						errormessagemap.put(collrec.name,'Beneficiary Check');
					}
				}

			
		return errormessagemap;

}

webservice static Boolean closepostdibursementDiscrepancyTask(String appid){
	Boolean taskexisted=checkdeviationtASK(appid);
	List<Task> DiscrepancyTask=new List<Task>();
	try{

	if(checkdeviationtASK(appid)){
	DiscrepancyTask=[Select id,type,subject,status from Task where subject='Review Post Disbursement Discrepancy' and type='Post Disbursement Deviation' and status!='Completed' and whatid=:appid];
	if(DiscrepancyTask!=null && DiscrepancyTask.size()>0){

		DiscrepancyTask[0].status='Completed';
		update DiscrepancyTask;
	}
	}
	}
	catch(Exception ex){
		HandleBusinessException.captureError('PostDisbursementCheck','postdibursementDiscrepancyTask',ex);
	}
	return taskexisted;
}
webservice static Boolean checkifvalidatepostdisbursementaskexistOpen(String appid){
	Boolean flag=false;
	try{
		flag=Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appid,'Validate Post Disbursement Details');
	}
	catch(Exception ex){
		HandleBusinessException.captureError('PostDisbursementCheck','checkifvalidatepostdisbursementaskexistOpen',ex);
	}

	return flag;
}

public static void updateProductvalues(List<Facility__c> facility){
	//List<genesis__Applications__c> applst=SOQL_Util.getApplication(new Set<String>{appid});
	List<Facility__c> lstoffacilitytoUpdate=new List<Facility__c>();
	Set<String> facidset=new Set<String>();
	Set<id> productid=new Set<id>();
	Decimal maxexistingmargin=0.0;
	Map<id,List<Product_Support_Configuration__c>> productchildmap=new Map<id,List<Product_Support_Configuration__c>>();
	For(Facility__c facerec:facility){
		productid.add(facerec.CL_Product__r.id);
		facidset.add(facerec.id);
	}
	List<clcommon__CL_Product__c> productlist=[select id,Product_Code__c,(select id,Commercial_Vehicle_Category__c,Product__r.id,Existing_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Holiday_Period__c,Processing_fee_freshNumber__c,Processing_fee_freshPercent__c,Processing_fee_renwal_Number__c,Processing_fee_renwalPercent__c from Product_Support_Configurations__r) from clcommon__CL_Product__c where id in:productid and Product_Code__c in (' 743','744','746','749','752','792')];
	if(!productlist.isEmpty()){
	For(clcommon__CL_Product__c prodrec:productlist){
		List<Product_Support_Configuration__c> prosupconlist=new list<Product_Support_Configuration__c>();
		for(Product_Support_Configuration__c pscrec:prodrec.Product_Support_Configurations__r){
			prosupconlist.add(pscrec);
		}
		productchildmap.put(prodrec.id,prosupconlist);
	}
	}
	for(Facility__c facrec: facility){
		checkmaxexistingmargin(facrec,productchildmap);
		checkProcessingFees(facrec,productchildmap);
		checkholidatperiod(facrec,productchildmap);
	}
	System.debug('lstoffacilitytoUpdate==== '+facility);
	update facility; 
}

public static void checkmaxexistingmargin(Facility__c faclityRec, Map<id,List<Product_Support_Configuration__c>> productchildmap){
	
	List<Decimal> existingmargin=new List<Decimal>(); 
	List<genesis__Application_Collateral__c> appcolllist=new List<genesis__Application_Collateral__c>();
	try{
		if(faclityRec!=null && productchildmap!=null && !productchildmap.isEmpty()){
		appcolllist=[select id,Facility__c,Facility__r.id,Facility__r.CL_Product__r.id,Application__c,genesis__Collateral__c,genesis__Collateral__r.Commercial_Vehicle_Category__c,genesis__Collateral__r.Collateral_Record_Type__c from genesis__Application_Collateral__c where Facility__r.id=:faclityRec.id and genesis__Collateral__r.Collateral_Record_Type__c=:CONSTANTS.COMMERCIAL_VEHICLE and genesis__Collateral__r.Commercial_Vehicle_Category__c!=null];
		if(!appcolllist.isEmpty()){
		for(genesis__Application_Collateral__c appcollrec:appcolllist){
		
			List<Product_Support_Configuration__c> prosuppconf=productchildmap.get(appcollrec.Facility__r.CL_Product__c);
			for(Product_Support_Configuration__c pscrec:prosuppconf){
				if(appcollrec.genesis__Collateral__r.Commercial_Vehicle_Category__c == pscrec.Commercial_Vehicle_Category__c){
					existingmargin.add(pscrec.Existing_Margin__c);
					
				}			
			}
	
		}
		}
	}
	System.debug('existingmargin =='+existingmargin);
	
	if(existingmargin!=null && !existingmargin.isEmpty()){
		existingmargin.sort();
		faclityRec.Approved_Margin__c=existingmargin[existingmargin.size()-1];
	}
	}
	catch(Exception ex){
		HandleBusinessException.captureError('ApplicationClone','checkmaxexistingmargin',ex);
	}
	//return faclityRec;
}

public static void checkholidatperiod(Facility__c faclityRec, Map<id,List<Product_Support_Configuration__c>> productchildmap){
	List<Decimal> holidayperiod=new List<Decimal>(); 
	List<genesis__Application_Collateral__c> appcolllist=new List<genesis__Application_Collateral__c>();
	try{
		if(faclityRec!=null && productchildmap!=null && !productchildmap.isEmpty()){
			appcolllist=[select id,Facility__c,Facility__r.id,Facility__r.CL_Product__r.id,Application__c,genesis__Collateral__c,genesis__Collateral__r.Commercial_Vehicle_Category__c,genesis__Collateral__r.Collateral_Record_Type__c from genesis__Application_Collateral__c where Facility__r.id=:faclityRec.id and genesis__Collateral__r.Collateral_Record_Type__c=:CONSTANTS.COMMERCIAL_VEHICLE and genesis__Collateral__r.Commercial_Vehicle_Category__c!=null];
			if(!appcolllist.isEmpty()){
				for(genesis__Application_Collateral__c appcollrec:appcolllist){
		
				List<Product_Support_Configuration__c> prosuppconf=productchildmap.get(appcollrec.Facility__r.CL_Product__c);
				for(Product_Support_Configuration__c pscrec:prosuppconf){
				if(appcollrec.genesis__Collateral__r.Commercial_Vehicle_Category__c == pscrec.Commercial_Vehicle_Category__c){
					holidayperiod.add(pscrec.Holiday_Period__c);
					
				}			
				}
				}
			}
		}
		System.debug('existingmargin =='+holidayperiod);
	
	if(holidayperiod!=null && !holidayperiod.isEmpty()){
		holidayperiod.sort();
		faclityRec.Holiday_Period__c=holidayperiod[holidayperiod.size()-1];
		//System.debug('holiday period=='+faclityRec.Holiday_Period__c);
	}
	}
	catch(Exception ex){
		HandleBusinessException.captureError('ApplicationClone','checkholidatperiod',ex);
	}
	//return faclityRec;
}


public static void checkProcessingFees(Facility__c faclityRec, Map<id,List<Product_Support_Configuration__c>> productchildmap){
	
	List<Decimal> existingProcessingfees=new List<Decimal>(); 
	List<genesis__Application_Collateral__c> appcolllist=new List<genesis__Application_Collateral__c>();
	try{
		if(faclityRec!=null && productchildmap!=null && !productchildmap.isEmpty()){
			appcolllist=[select id,Facility__c,Facility__r.id,Facility__r.CL_Product__r.id,Application__c,genesis__Collateral__c,genesis__Collateral__r.Commercial_Vehicle_Category__c,genesis__Collateral__r.Collateral_Record_Type__c from genesis__Application_Collateral__c where Facility__r.id=:faclityRec.id and genesis__Collateral__r.Collateral_Record_Type__c=:CONSTANTS.COMMERCIAL_VEHICLE and genesis__Collateral__r.Commercial_Vehicle_Category__c!=null];
			if(!appcolllist.isEmpty()){
				for(genesis__Application_Collateral__c appcollrec:appcolllist){
		
				List<Product_Support_Configuration__c> prosuppconf=productchildmap.get(appcollrec.Facility__r.CL_Product__c);
				for(Product_Support_Configuration__c pscrec:prosuppconf){
					if(appcollrec.genesis__Collateral__r.Commercial_Vehicle_Category__c == pscrec.Commercial_Vehicle_Category__c){
						existingProcessingfees.add(pscrec.Processing_fee_freshPercent__c);
					
						}			
				}
				}
			}
		}
		System.debug('existingProcessingfees =='+existingProcessingfees);
	
		if(existingProcessingfees!=null && !existingProcessingfees.isEmpty()){
			existingProcessingfees.sort();
			faclityRec.BRE_Processing_Charge__c=existingProcessingfees[existingProcessingfees.size()-1];
		}
	}
	catch(Exception ex){
		HandleBusinessException.captureError('ApplicationClone','checkmaxexistingmargin',ex);
	}
	//return faclityRec;
}

	public static Boolean UpdateCibil(String appid){
		List<genesis__Applications__c> applst=new List<genesis__Applications__c>();
		Boolean flag=true;
		List<Facility__c> facillst =new List<Facility__c>();
		List<Integer> productcibil=new List<Integer>();
		Decimal minpartyCibili;
		Integer maxProductCibil;

		try{
			applst=SOQL_Util.getApplication(new Set<Id>{appId});
			facillst =SOQL_Util.getFacilities(appid);
			if(applst[0].CIBIL_score__c!=null){
				minpartyCibili=applst[0].CIBIL_score__c;
			}

			if(applst!=null && !applst.isEmpty() && applst[0].recordtype.developername==CONSTANTS.SME_NEW_LOAN_RECORD_TYPE && minpartyCibili!=null){
				For(Facility__c facrec:facillst){
					if(facrec.CL_Product__r.clcommon__Product_Name__c!=null && facrec.CL_Product__r.CIBIL_Required__c!=null){
						if(facrec.CL_Product__r.CIBIL_Required__c >maxProductCibil)
						maxProductCibil = Integer.valueOf(facrec.CL_Product__r.CIBIL_Required__c);
					}
				}

				System.debug('minpartyCibili ===='+minpartyCibili);
				if(minpartyCibili!=null && maxProductCibil!=null && minpartyCibili<maxProductCibil){
					applst[0].Application_Stage__c='New loan - Application rejected	';
					applst[0].Sub_Stage__c='CIBIL Rejected';
					flag=false;
					update applst;
				}
			}
		}
		catch(Exception ex){
			HandleBusinessException.captureError('PostDisbursementCheck','UpdateCibil',ex);
		}
		return flag;
	}



	webservice static List<String> getallfacilities(String appid){
    	List<Facility__c> faclist=[select id,name from Facility__c where Application__c=:appid];
    	List<String> facname=new List<String>();
    	for(Facility__c facrec:faclist){
    		facname.add(facrec.name);
    	}
    	return facname;
    }

    webservice static List<String> getallCollateral(String appid){
    	List<String> namelist=new List<String>();
    	List<genesis__Application_Collateral__c> appcolllist=[select id,name,genesis__Collateral__r.name,genesis__Collateral__r.id from genesis__Application_Collateral__c where Application__c=:appid];
    	for(genesis__Application_Collateral__c appcolrec: appcolllist){
    		namelist.add(appcolrec.genesis__Collateral__r.name);
    	}
    	return namelist;
    }

    webservice static void createwrapperinstance(List<String> appcollist){
    	System.debug('appcollist==='+appcollist);
    	Map<String,Decimal> facilresidual=new Map<String,Decimal>();
    	/*for(genesis__Application_Collateral__c appcol:appcollist){
    		System.debug(appcol.genesis__Collateral__r.name);
    		System.debug(appcol.Facility__r.name);
    		System.debug(appcol.Residual_Percentage__c);
    	}*/




    	List<SecurityCoverageRefactorHelper.collatralResidualReallocationWrapper> wrapperlist=new List<SecurityCoverageRefactorHelper.collatralResidualReallocationWrapper>();
    	for(String row:appcollist){
    		List<String> rowdata=row.split('==');
    		//facilresidual.put
    		SecurityCoverageRefactorHelper.collatralResidualReallocationWrapper wrapperrec=new SecurityCoverageRefactorHelper.collatralResidualReallocationWrapper();
    		wrapperrec.collId=rowdata[0];
    		wrapperrec.percentageAllocationByFacility.put(rowdata[1],Decimal.valueOf(rowdata[2]));
    		wrapperlist.add(wrapperrec);
    	}
    	System.debug('wrapperlist=='+wrapperlist);

    }


    public static Boolean UpdateCibil_new(String appid){
		List<genesis__Applications__c> applst=new List<genesis__Applications__c>();
		Boolean flag=true;
		set<String> facilitycategory=new set<String>();
		List<Facility__c> facillst =new List<Facility__c>();
		List<Integer> productcibil=new List<Integer>();
		List<clcommon__CL_Product__c> prodlist=new List<clcommon__CL_Product__c	>();
		List<genesis__Application_Parties__c> partyList=new List<genesis__Application_Parties__c>();
		Integer minpartyCibili=9999;
		Integer maxProductCibil=0;
		Integer cvcibil=0;

		try{
			applst=SOQL_Util.getApplication(new Set<Id>{appId});
			facillst =SOQL_Util.getFacilities(appid);
			partyList = [SELECT Id,genesis__Party_Account_Name__r.CIBIL_Score__c,genesis__Party_Account_Name__r.CIBIL_Status__pc,CIBIL_Score__c,Guarantor__c FROM genesis__Application_Parties__c WHERE genesis__Application__c =: appid AND Active__c = true];
			if(applst[0].CIBIL_score__c!=null){
				//minpartyCibili=applst[0].CIBIL_score__c;
			}
			if(!facillst.isEmpty()){
				for(Facility__c facrec:facillst){
					if(facrec.NTB_Facility_Category__c!='' && facrec.NTB_Facility_Category__c!=null){
					if((facrec.NTB_Facility_Category__c).contains('Term Loan')){
						if((facrec.NTB_Facility_Category__c).contains('Construction Equipment')){
							facilitycategory.add('Commercial Machinery');
						}
						else if((facrec.NTB_Facility_Category__c).contains('Passenger Car')){
							facilitycategory.add('Commercial Vehicle');
						}
						else{
							facilitycategory.add((facrec.NTB_Facility_Category__c).substring(12));
						}
					}
				}
				}
			}
			System.debug('facilitycategory=='+facilitycategory);
			if(!facilitycategory.isEmpty()){
				prodlist=SOQL_Util.getProductDetails(new List<String>(facilitycategory));
			}
			System.debug('prodlist==>'+prodlist);
			if(!prodlist.isEmpty()){
				for(clcommon__CL_Product__c prodrec:prodlist){
					if(prodrec.CIBIL_Required__c!=null){
						if(prodrec.Facility_Category__c=='Commercial Vehicle'){
							System.debug('prodrec.Product_Support_Configurations__r==='+prodrec.Product_Support_Configurations__r);
							for(Product_Support_Configuration__c pscrec:prodrec.Product_Support_Configurations__r){
								System.debug('pscrec.cibil__c=='+pscrec.cibil__c);
								if(pscrec.cibil__c > cvcibil){
									cvcibil=Integer.valueof(pscrec.cibil__c);
								}
							}
							if(cvcibil>maxProductCibil){
								maxProductCibil=cvcibil;
							}	
						}
						else{
							if(prodrec.CIBIL_Required__c > maxProductCibil){
								maxProductCibil = Integer.valueOf(prodrec.CIBIL_Required__c);
							}
						}
					}
				}
			}
			System.debug('partyList=='+partyList);
			if(!prodlist.isEmpty()){
				for(genesis__Application_Parties__c partyrec:partyList){
					System.debug('partyrec=='+partyrec);
					if(partyrec.CIBIL_Score__c!=null && partyrec.genesis__Party_Account_Name__r.CIBIL_Status__pc !=null && partyrec.genesis__Party_Account_Name__r.CIBIL_Status__pc !='' && partyrec.genesis__Party_Account_Name__r.CIBIL_Status__pc =='Complete' ){
						if(partyrec.CIBIL_Score__c!=-1 && partyrec.CIBIL_Score__c!=5){
							if(partyrec.CIBIL_Score__c < minpartyCibili){
							//System.debug('partyrec.CIBIL_Score__c==='+partyrec.CIBIL_Score__c);
							//System.debug('genesis__Party_Account_Name__r.CIBIL_Score__c=='+partyrec.genesis__Party_Account_Name__r.CIBIL_Score__c);
							//System.debug('minpartyCibili=='+minpartyCibili);
							minpartyCibili=Integer.valueOf(partyrec.CIBIL_Score__c);
							}
						}
					}
				}
			}
			System.debug('minpartyCibili==>'+minpartyCibili);
			System.debug('maxProductCibil==>'+maxProductCibil);
			if(prodlist.isEmpty()){
				return flag;
			}
			if(applst!=null && !applst.isEmpty() && minpartyCibili!=null){
				if(minpartyCibili!=null && maxProductCibil!=null && minpartyCibili!=9999 && maxProductCibil!=0 && minpartyCibili<maxProductCibil){
					applst[0].Application_Stage__c='New loan - Application rejected	';
					applst[0].Sub_Stage__c='CIBIL Rejected';
					flag=false;
					ApplicationTriggerHandler.IsFirstRun = false;
					update applst;
				}

			}


			/*if(applst!=null && !applst.isEmpty() && applst[0].recordtype.developername==CONSTANTS.SME_NEW_LOAN_RECORD_TYPE && minpartyCibili!=null){
				For(Facility__c facrec:facillst){
					if(facrec.CL_Product__r.clcommon__Product_Name__c!=null && facrec.CL_Product__r.CIBIL_Required__c!=null){
						if(facrec.CL_Product__r.CIBIL_Required__c >maxProductCibil)
						maxProductCibil = Integer.valueOf(facrec.CL_Product__r.CIBIL_Required__c);
					}
				}

				System.debug('minpartyCibili ===='+minpartyCibili);
				if(minpartyCibili!=null && maxProductCibil!=null && minpartyCibili<maxProductCibil){
					applst[0].Application_Stage__c='New loan - Application rejected	';
					applst[0].Sub_Stage__c='CIBIL Rejected';
					flag=false;
					update applst;
				}
			}*/
		}
		catch(Exception ex){
			HandleBusinessException.captureError('PostDisbursementCheck','UpdateCibil',ex);
		}
		return flag;
	}
}