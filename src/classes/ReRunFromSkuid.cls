global class ReRunFromSkuid{
	webservice static  void reRunMethod(String appId){
		genesis__applications__c application = new genesis__applications__c();
		application = queryService.getApplication(appId);
		Retry_Task_call.calculateEligibilityPL(application,'3');
	}
}