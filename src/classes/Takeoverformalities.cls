global class Takeoverformalities{


webService static Boolean checkDocForCompleteChecklists(String appId){
	Boolean onedocumentnotuploaded=true;

List<genesis__Checklist__c> allappchecklists=[select id,Complete__c,Not_complete__c,OneDocumentUpload__c from genesis__Checklist__c where genesis__Application__r.id=:appid];
	For(genesis__Checklist__c checklistInstance: allappchecklists){
		if(checklistInstance.Complete__c==true && checklistInstance.OneDocumentUpload__c==false){
			onedocumentnotuploaded=false;
		}
	}


	return onedocumentnotuploaded;

}

}