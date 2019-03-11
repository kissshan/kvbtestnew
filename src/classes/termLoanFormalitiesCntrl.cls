global with sharing class termLoanFormalitiesCntrl {
	
	public String appId {set;get;}
	public Set<Id> CollatIdSet;
	public string collStr {get;set;}
	public List<clcommon__Collateral__c> listAppColl{get;set;}
	public termLoanFacilityWrapper termLoanWrap {get;set;}
	public String termLoanWrapStr {get;set;}
	

	public termLoanFormalitiesCntrl() {

		appId 									= apexpages.currentpage().getparameters().get('id');
		CollatIdSet 							= new Set<Id>();
		termLoanWrap 							= new termLoanFacilityWrapper();
		termLoanWrap.appRecord 					= [Select Id,Name ,Application_Stage__c,genesis__Account__r.Name from genesis__Applications__c where Id=:appId];
		termLoanWrap.catOfLoanPicklistValues 	= DropDownHandler.getPicklistEntries('clcommon__Collateral__c','Category_of_Loan__c');
		termLoanWrap.pangstPicklistValues 		= DropDownHandler.getPicklistEntries('clcommon__Collateral__c','GST_PAN__c');
		termLoanWrap.isPageNonEditable 			= checkIFOpenTaskAlreadyExistForCLPC(appId,'Validate TL Details');
		termLoanWrap.appId						= appId;
		termLoanWrap.pvStateList				= PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'STATE'=>'ALL'},'GET_STATE');
		termLoanWrap.pvMakeList  		= PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'MAKEID'=>''},'GET_MAKE');
		if(appId!= null){

			for(genesis__Application_Collateral__c appCollat: [Select id,Application__c,Facility__c,genesis__Collateral__c,genesis__Collateral__r.RecordType.DeveloperName from genesis__Application_Collateral__c where Application__c=: appId And genesis__Collateral__r.RecordType.DeveloperName != 'Land_And_Building']){
				if(appCollat.genesis__Collateral__c!= null){
					CollatIdSet.add(appCollat.genesis__Collateral__c);
				}
			}

			if(CollatIdSet.size()>0){
				listAppColl 					= SOQL_Util.getCollateralWithCollIds(new List<Id>(new Set<Id>(CollatIdSet)));
				collStr 						= JSON.serialize(listAppColl);
			}

		}

		termLoanWrapStr 						= JSON.serialize(termLoanWrap);
	}

	@RemoteAction
	global static List<String> getDropDownValues(String objectApiName, String fieldApiName) {
		return DropDownHandler.getPicklistEntries(objectApiName,fieldApiName);

	}
	/*@RemoteAction
    global static String getDealerInformation() {
        return JSON.serialize('[{"firstname":"Vignesh","surname":"T Ram","phone":["555-0104450","55665-0120"]},{"firstname":"Ajeet","surname":"Kumar","phone":["555-0trtr100","555-rtr0120"]}]');
    }*/
	@RemoteAction
	global static String getDealerInformationByMakeAndCity( String make,String city) {

		return DealerAPICallout.getDealerDetails(make,city,'FW');
	}
    @RemoteAction
    global static Object getGSTInformation(String gst) {
		return GSTapiCallout.getGSTDetails(gst,'TP');
    }
    @RemoteAction
    global static Object getPANInformation(String pan) {
		return PANapiCallout.getPANDetails(pan);
        //return JSON.serialize('{ "code": "1", "pan": "BCGPB4258L", "status": "E", "statusDesc": "Exisiting/ Active PAN", "firstName": "PRITAM", "lastName": "BHOWMIK", "middleName": "PIYUSH", "title": "Shri", "lastUpdateDate": "24/07/2016", "constitution": "Proprietorship" }');
    }
	@RemoteAction
	global static String closeCLPCTask(String appId) {
		try {
			closeExistingLeagalTask(appId,'Validate TL Details');
			return ' All Information Saved Successfully';
		} catch (Exception e) {
			HandleBusinessException.captureError('TermLoanFacility','saveCollInformation',e);
			return 'Exception ::: '+e.getMessage()+' AT '+e.getLineNumber();
		}
	}
	public static void closeExistingLeagalTask(string appId,String taskType) {
		try{
			User rlpcUser = SOQL_Util.getDOLegalUser(appId);
			List<Task> getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And OwnerId =: UserInfo.getUserId() And Type=:taskType And Status = 'Not Started'];

			if(! getExistingTaskList.isEmpty()){
				getExistingTaskList[0].Status = 'Completed';
			}
			update getExistingTaskList;
		}catch(Exception e){
			HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'closeExistingLeagalTask', e);
		}

	}
	@RemoteAction
	global static String refferBackByCLPC(String appId) {
		try {

			genesis__Applications__c appRecord = new genesis__Applications__c(Id=appId,Application_UI_Stage__c ='SubmissionView');
			update appRecord;
			return ' Application UI Stage Changed to Securities';
		} catch (Exception e) {
			HandleBusinessException.captureError('TermLoanFacility','saveCollInformation',e);
			return 'Exception ::: '+e.getMessage()+' AT '+e.getLineNumber();
		}
	}


    @RemoteAction
    global static String saveCollInformation(String CollatString ) {
		try {

			system.debug('collatList=========> '+CollatString);
			//CollatString= CollatString.replace(', Collateral_Record_Type__c=Construction_Equipment,', ',');

			clcommon__Collateral__c collatList= (clcommon__Collateral__c) JSON.deserialize( CollatString, clcommon__Collateral__c.class);

				update collatList;
			return 'Collateral Information Saved Successfully';
		} catch (Exception e) {
			HandleBusinessException.captureError('TermLoanFacility','saveCollInformation',e);
			return 'Exception ::: '+e.getMessage()+' AT '+e.getLineNumber();
		}

        
    }
	public static Boolean checkIFOpenTaskAlreadyExistForCLPC(string appId,String taskSubject) {
		try{
			//Update Term Loan Details
			List<Task> getExistingTaskList;
			getExistingTaskList = [SELECT Id,Subject FROM Task WHERE WhatId=:appId AND Type=:taskSubject AND Status ='Not Started'];
			if(!getExistingTaskList.isEmpty()){
				return true;
			}
			return false;
		}catch(Exception e){
			HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIFOpenTaskAlreadyExistForRLPC', e);
			return false;
		}
	}
    @RemoteAction
    global static Object getAllPVStateInfo() {
        
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'STATE'=>'ALL'},'GET_STATE');
    }
	@RemoteAction
    global static Object getAllPVCityInfo(Integer stateId) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'STATEID'=>String.valueOf(stateId)},'GET_CITIES');
        
    }
	@RemoteAction
    global static Object getAllPVMakeInfo() {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'MAKEID'=>''},'GET_MAKE');
        
    }
	@RemoteAction
    global static Object getAllPVModelInfo(Integer makeId) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'MAKEID'=>String.valueOf(makeId)},'GET_MODEL');
        
    }
	@RemoteAction
    global static Object getAllPVVersionInfo(Integer modelId) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'MODELID'=>String.valueOf(modelId)},'GET_VERSION');
        
    }
	@RemoteAction
    global static Object getAllPVPriceInfo(Integer versionId,Integer cityId) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'VERSIONID'=>String.valueOf(versionId),'CITYID'=>String.valueOf(cityId)},'GET_PRICE');
        
    }
	@RemoteAction
    global static Object getAllPVDealerInfo(Integer makeId,Integer cityId) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'MAKEID'=>String.valueOf(makeId),'CITYID'=>String.valueOf(cityId)},'GET_DEALERS');
        
    }
    @RemoteAction
    global static Object getAllBUSMakeInfo() {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'STATE'=>'ALL'},'GET_MAKE_BUS');
        
    }
    @RemoteAction
    global static Object getAllBUSCityInfo(String brandid) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'BRANDID'=>String.valueOf(brandid)},'GET_CITIES_BUS');
        
    }
    @RemoteAction
    global static Object getAllBUSDealerInfo(String brandid,String cityId) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'BRANDID'=>String.valueOf(brandid),'CITYID'=>cityId},'GET_DEALERS_BUS');
        
    }
    @RemoteAction
    global static Object getAllBUSModelInfo(String brandid) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'BRANDID'=>brandid},'GET_MODEL_BUS');
        
    }
    @RemoteAction
    global static Object getAllBUSVariantInfo(String brandid,String modelid) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'BRANDID'=>brandid,'MODELID'=>modelid},'GET_VARIANT_BUS');
        
    }

    @RemoteAction
    global static Object getAllTruckMakeInfo() {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'STATE'=>'ALL'},'GET_MAKE_TRUCK');
        
    }
    @RemoteAction
    global static Object getAllTruckCityInfo(String brandid) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'BRANDID'=>String.valueOf(brandid)},'GET_CITIES_TRUCK');
        
    }
    @RemoteAction
    global static Object getAllTruckDealerInfo(String brandid,String cityId) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'BRANDID'=>String.valueOf(brandid),'CITYID'=>cityId},'GET_DEALERS_TRUCK');
        
    }
    @RemoteAction
    global static Object getAllTruckModelInfo(String brandid) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'BRANDID'=>brandid},'GET_MODEL_TRUCK');
        
    }
    @RemoteAction
    global static Object getAllTruckVariantInfo(String brandid,String modelid) {
        return PassengerVehicleCallout.getPasengerVehicleApi(new Map<String,String>{'BRANDID'=>brandid,'MODELID'=>modelid},'GET_VARIANT_TRUCK');
        
    }
	public class termLoanFacilityWrapper{
		public genesis__Applications__c appRecord;
		public List<String> catOfLoanPicklistValues;
		public List<String> pangstPicklistValues;
		public Boolean isPageNonEditable;
		public Object pvStateList;
		public Object pvMakeList;
		public String appId;
	}

}