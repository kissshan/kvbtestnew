global class DisbursemetApprovalCheck{


webservice static Boolean keyapplicationcheck(String appid){
	Boolean appcheck=false;
	try{
	List<genesis__Applications__c> lstapp=SOQL_Util.getApplication(new Set<Id>{appid});
	if((lstapp!=null) && !(lstapp.isEmpty())){
		if(!String.isBlank(lstapp[0].Open_CASA_Account__c) && !String.isBlank(lstapp[0].Verify_Sale_Agreement__c) && !String.isBlank(lstapp[0].Verify_Construction__c) && !String.isBlank(lstapp[0].Verify_Advance_Payment__c) && !String.isBlank(lstapp[0].Verify_Latest_EC__c) && !String.isBlank(lstapp[0].Verify_NOC__c) && !String.isBlank(lstapp[0].Verify_Margin_Payment__c) && !String.isBlank(lstapp[0].Complete_E_KYC_for_NTB_customers__c) && !String.isBlank(lstapp[0].Plan_Approval_available__c) && !String.isBlank(lstapp[0].Dibursment_Comments__c)){
			appcheck=true;
		}
	}
	}

	catch(Exception ex){
		HandleBusinessException.captureError('DisbursemetApprovalCheck','keyapplicationcheck',ex);
	}	
	return appcheck;


}

webservice static Boolean closeapprovedisbursementtassk(String appid){
	Boolean flag=false;
	try{
	//List<genesis__Applications__c> lstapp=SOQL_Util.getApplication(new Set<Id>{appid});

	Underwriting_CTRL_Helper.closeExistingBMTask(appid,'Approve Disbursement');
	//flag=Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appid,'Document Review');
	//System.debug('heree '+flag);
	}
	catch(Exception ex){
		HandleBusinessException.captureError('DisbursemetApprovalCheck','closeDisbursementapprovalAndDocumentGeneration',ex);
	}
	return flag;

}

public static Boolean checkIFOpenTaskAlreadyExistwithSubject(string appId,String taskType,String subject) {
        List<Task> getExistingTaskList;
        if(taskType =='EME BM Review')
            getExistingTaskList                                                       = [SELECT Id FROM Task where WhatId=:appId and Type IN ('EME BM Review','Application Review') And Status!='Completed'];
        else
                getExistingTaskList                                                       = [SELECT Id FROM Task where WhatId=:appId and Type=:taskType And Status!='Completed' and status=:subject];

        return getExistingTaskList.size()>0?true:false;

    }
 webservice static Boolean checkIFcloseTaskAlreadyExistwithSubject(string appId,String taskType,String subject) {
        List<Task> getExistingTaskList;
        
                getExistingTaskList                                                       = [SELECT Id FROM Task where WhatId=:appId and Type=:taskType And Status='Completed' and subject=:subject];

        return getExistingTaskList.size()>0?true:false;

    }

webservice static Boolean checkdisbappAndDoccomptask(String appid){
	Boolean rendercbsbutton=false;
	try{
		System.debug('Document Review ==>'+DisbursemetApprovalCheck.checkIFOpenTaskAlreadyExistwithSubject(appid,'Document Review','Complete Documentation'));
		System.debug('Approve Disbursement ==> '+Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appid,'Approve Disbursement'));
		System.debug('Document Review ==> '+DisbursemetApprovalCheck.checkIFcloseTaskAlreadyExistwithSubject(appid,'Document Review','Complete Documentation'));
		System.debug('Approve Disbursement ==>'+DisbursemetApprovalCheck.checkIFcloseTaskAlreadyExistwithSubject(appid,'Approve Disbursement','Approve Disbursement'));
	if(DisbursemetApprovalCheck.checkIFOpenTaskAlreadyExistwithSubject(appid,'Document Review','Complete Documentation') || Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appid,'Approve Disbursement')){
		rendercbsbutton=false;
	}
	else if(DisbursemetApprovalCheck.checkIFcloseTaskAlreadyExistwithSubject(appid,'Document Review','Complete Documentation') && DisbursemetApprovalCheck.checkIFcloseTaskAlreadyExistwithSubject(appid,'Approve Disbursement','Approve Disbursement')){
		rendercbsbutton=true;
	}
	}
	catch(Exception ex){
		HandleBusinessException.captureError('DisbursemetApprovalCheck','checkdisbappAndDoccomptask',ex);
	}	
	return rendercbsbutton;
}

webservice static Boolean closesiemandatetask(String appId){
	Boolean taskclosed=false;
	try{
	Underwriting_CTRL_Helper.closeExistingBMTask(appid,'Verify SI/Emandate Details');
	if(DisbursemetApprovalCheck.checkIFcloseTaskAlreadyExistwithSubject(appid,'Verify SI/Emandate Details','Verify SI/Emandate Details')){
		 genesis__Applications__c apprec=PostDisbursementCheck.changeappstages(appid);
		 taskclosed=true;
	}
	
	}
	catch(Exception ex){
		HandleBusinessException.captureError('DisbursemetApprovalCheck','closesiemandatetask',ex);
	}
	return taskclosed;

}

}