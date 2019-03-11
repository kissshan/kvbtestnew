/*
* Name    : Batch_SchemeMasterHandler calling from Batch_SchemeMaster_VL
* Company : ET Marlabs
* Purpose : This class will be used to make scheme inactive after Scheme expires
* Author  : Ashok
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
======= ==========   =============  ==================================
V1.1    24-Oct-2018   Ashok         SchemeMasterHandler - logic to inactive scheme
v1.2    24-Oct-2018   Braj          Change scheme code to name after expired;Check application main stage and sub stage in Query to make this method generic
*******************************************************************************************/

public with sharing class Batch_SchemeMasterHandler {

	public static void SchemeMasterHandler(List<Scheme_Master__c> ScmMster){
	List<String> recordTypesList = new List<String>{Constants.VL2W,Constants.VL4W};
	//List<String> stagesList = new List<String>{Constants.SAVED_APPLCIATION_MAINSTAGE};
	List<String> subStageList = new List<String>{Constants.APPLICATION_CREATED_SUBSTAGE,Constants.TERMS_AND_CONDITIONS_ACCESPT_SUBSTAGE};
	List<Scheme_Master__c> updateSchmList = new List<Scheme_Master__c>();
	List<clcommon__Collateral__c> upCollatList = new List<clcommon__Collateral__c>();
	List<genesis__Applications__c> upAppsList = new List<genesis__Applications__c>();
	//List<String> schemeNameList = new List<String>();
	Map<String,String> mapSchemeCodeToName = new Map<String,String>();
	Set<ID> appsIDSet = new Set<ID>();
		for(Scheme_Master__c scm: ScmMster){
			Scheme_Master__c upscm = new Scheme_Master__c();
			upscm.Active_Flag__c = False;
			upscm.id = scm.id;
			updateSchmList.add(upscm);
			//schemeNameList.add(scm.Scheme_Code__c);
			mapSchemeCodeToName.put(scm.Scheme_Code__c, scm.Name);//v1.2
		}
		for(clcommon__Collateral__c collats: [select id,Name,Scheme_Type__c,genesis__Application__c,genesis__Application__r.Record_Type_Name__c,genesis__Application__r.Sub_Stage__c 
											 from clcommon__Collateral__c where Scheme_Type__c IN :mapSchemeCodeToName.keySet() AND genesis__Application__r.Application_Stage__c =: Constants.SAVED_APPLCIATION_MAINSTAGE AND genesis__Application__r.Sub_Stage__c Not IN: subStageList
											 AND genesis__Application__r.Record_Type_Name__c =:recordTypesList]){//v1.2
			clcommon__Collateral__c colss = new clcommon__Collateral__c();
			if (mapSchemeCodeToName.containsKey(collats.Scheme_Type__c)) {
				colss.Scheme_Type__c = mapSchemeCodeToName.get(collats.Scheme_Type__c)+' has expired';//collats.Scheme_Type__c +'has expired';//v1.2
				colss.id = collats.id;
				upCollatList.add(colss);
				appsIDSet.add(collats.genesis__Application__c);
			}
		}
		for(Id gapps:appsIDSet){
			genesis__Applications__c upapp = new genesis__Applications__c();
			upapp.id = gapps;
			upapp.Sub_Stage__c = Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE;
			upAppsList.add(upapp);
		}
		try{
			update upCollatList;
			update updateSchmList;
			ApplicationTriggerHandler.IsFirstRun = false;
			update upAppsList;
		}catch(exception e){
			HandleBusinessException.captureError('Batch_SchemeMasterHandler','SchemeMasterHandler', e);
		}

	}
}