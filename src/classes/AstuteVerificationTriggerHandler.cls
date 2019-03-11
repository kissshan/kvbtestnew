/*
*Class Name :	AstuteVerificationTriggerHandler
*Author     :	Ashish Jain
*Date		:	13/06/2018
*Purpose	:	To update FI status on application based on response of Astute call
-----------------------------------------------------------------------
Version  	Date         	Author          Remarks                                                 
=======   	==========   	=============  	==================================
v1.1    	17-Dec-2018    	Braj          	Optimized class and update substage to 'FI Rejected' for fraud;Creation of manual astute if response is not positive
*******************************************************************************************/
public class AstuteVerificationTriggerHandler {
	
	//v1.1(start)
	public static void fiStatusUpdate(List<Astute_Verification__c> astuteList){
		try{
			List<genesis__applications__c> appListupdate= new List<genesis__applications__c>();
			Integer AllResponse = 0; // to check all response got from FI.
			Integer AllAPIAstute = 0;
			Integer NegativeCount =0;
			Integer PositiveCount =0;
			Integer ReferCount =0;
			Integer MatchFound =0;
			Set<Id> appIdList = new Set<Id>();
			List<Id> finalAppIdList = new List<Id>();
			Map<Id, List<Id>> appAccIdMap = new Map<Id, List<Id>>();
			List<Astute_Verification__c> astList = new List<Astute_Verification__c>();
			List<Astute_Verification__c> manualAstuteLst = new List<Astute_Verification__c>();
			Set<String> setAstuteCNID = new Set<String>();

			for( Astute_Verification__c astute : astuteList ){
				appIdList.add(astute.Application__c);
			}
			System.debug('appIdList:::'+appIdList);
			finalAppIdList.addAll(appIdList);

			astList = [select id,Name,Employment_Type__c,Requested_Address__c,Requested_Pincode__c,Account__c,DeDupe_Status__c,Property_Type__c, Application__c,Employer_Verification__c,Residence_Verification__c, Case_Id__c, Case_Notification_Id__c,Status__c,Status_ID__c from Astute_Verification__c where Application__c IN : appIdList];
			System.debug('astList:::'+astList);

			//FI status check
			for(Astute_Verification__c AstuteRE : astList){
				if(AstuteRE.Case_Id__c!=Constants.FI_MANUAL){
					AllAPIAstute++;
					if(AstuteRE.DeDupe_Status__c != null){
						AllResponse++;//v1.1
						if(AstuteRE.DeDupe_Status__c == 'Match found'){
							MatchFound++;
						}else if(AstuteRE.Residence_Verification__c == 'Negative' ){
							NegativeCount++;
							manualAstuteLst.add(AstuteRE);
						}else if(AstuteRE.Residence_Verification__c == 'Refer' ){
							ReferCount++;
							manualAstuteLst.add(AstuteRE);
						}else if(AstuteRE.Employer_Verification__c == 'Negative'){
							NegativeCount++;
							manualAstuteLst.add(AstuteRE);
						}else if(AstuteRE.Employer_Verification__c == 'Refer'){
							ReferCount++;
							manualAstuteLst.add(AstuteRE);
						}else if(AstuteRE.Employer_Verification__c == 'Positive'){
							PositiveCount++;
						}else if(AstuteRE.Residence_Verification__c == 'Positive'){
							PositiveCount++;
						}
					}
				} else {
					setAstuteCNID.add(AstuteRE.Status_ID__c);
				}
			}
			System.debug('MatchFound>>'+MatchFound);
			System.debug('PositiveCount>>'+PositiveCount);
			genesis__applications__c appst = new genesis__applications__c();
			if(MatchFound > 0){
				appst.id = finalAppIdList[0];
				appst.FI_Status__c = Constants.PL_FIRES_FRUD;//fraud
				appst.Sub_Stage__c = Constants.FI_REJECTED_SUBSTAGE;//v1.1
				appst.FI_Final_Decision__c = Constants.REJECTED_STATUS;//v1.1
				appListupdate.add(appst);
			}else if(NegativeCount > 0 ){
				appst.id = finalAppIdList[0];
				appst.FI_Status__c = Constants.FI_Nega;
				appListupdate.add(appst);
				createManualAstute(manualAstuteLst,setAstuteCNID);//v1.1
			}else if(ReferCount > 0){
				appst.id = finalAppIdList[0];
				appst.FI_Status__c = Constants.FI_Refer;
				appListupdate.add(appst);
				createManualAstute(manualAstuteLst,setAstuteCNID);//v1.1
			}else if(PositiveCount > 0){
				appst.id = finalAppIdList[0];
				appst.FI_Status__c = Constants.PL_FIRES_POSI;
				appst.FI_Final_Decision__c = Constants.APPROVED_STATUS;//v1.1
				appListupdate.add(appst);
			}
			System.debug('appListupdate>> '+appListupdate);
			System.debug(AllResponse+'<<AllResponse-AllAPIAstute>>'+AllAPIAstute);
			if(AllResponse == AllAPIAstute)
				update appListupdate;
		}catch(Exception e){
			System.debug('##### Exception at line '+ e.getLineNumber() +' Message'+e.getMessage());
		}
	}
	//v1.1(end)


	public static void fiStatusInsert(List<Astute_Verification__c> astuteList){
		//v1.1(start)
		Integer count = 0;
		Integer countManualAst = 0;
		Boolean isUpdateAppln = false;
		Set<Id> appIdList = new Set<Id>();
		List<genesis__applications__c> appListupdate= new List<genesis__applications__c>();
		List<Astute_Verification__c> astList = new List<Astute_Verification__c>();

		for( Astute_Verification__c astute : astuteList ){
			appIdList.add(astute.Application__c);
		}
		System.debug('appIdList:::'+appIdList);

		astList = [select id, Name, DeDupe_Status__c,Property_Type__c,Employer_Verification__c,Residence_Verification__c, Application__c, Case_Id__c, Case_Notification_Id__c, Status__c from Astute_Verification__c where Application__c IN : appIdList];
		System.debug('appList:::'+astList);

		for(Astute_Verification__c AstuteRE : astList){
			if(AstuteRE.DeDupe_Status__c == null && AstuteRE.Case_Id__c != Constants.FI_MANUAL && AstuteRE.Status__c == Constants.SUCCESS_STATUS){
				count++;
			}
			if(AstuteRE.Case_Id__c == Constants.FI_MANUAL){
				countManualAst++;
			}
		}

		genesis__applications__c appst = new genesis__applications__c();
		System.debug(count+'<<count-astList size>>'+astList.size());
		System.debug(countManualAst+'<<countManualAst-astList size>>'+astList.size());
		if(astList.size() == count){
			appst.id = astList[0].Application__c;
			appst.FI_Status__c = Constants.PL_FIRES_OBTN;
			appListupdate.add(appst);
			isUpdateAppln = true;
		}else if (astList.size() == countManualAst){
			appst.id = astList[0].Application__c;
			appst.FI_Status__c = Constants.FI_MANUAL;
			appListupdate.add(appst);
			isUpdateAppln = true;
		}
		System.debug('appListupdate>> '+appListupdate);
		//v1.1(end)
		try{
			if(isUpdateAppln){
				//ApplicationTriggerHandler.IsFirstRun = False;//commented because verify fi task not getting generated
				update appListupdate;
			}
		}catch(Exception e){
			System.debug('##### Exception at line '+ e.getLineNumber() +' Message'+e.getMessage());
		}
	}

	//v1.1(start)
	public static void createManualAstute(List<Astute_Verification__c> astuteList,set<String> astuteCNIdSet){
		try {
			List<Astute_Verification__c> ListAstuteUpdt = new List<Astute_Verification__c>();
			String PickUpDate = String.valueOf(System.now());
	        for(Astute_Verification__c eachAstute: astuteList){
	            Astute_Verification__c AstuteVefr = new Astute_Verification__c();
	            if (((eachAstute.Property_Type__c=='RESIDENCE' && eachAstute.Residence_Verification__c!='Positive') || (eachAstute.Property_Type__c=='OFFICE' && eachAstute.Employer_Verification__c!='Positive')) && !astuteCNIdSet.contains(eachAstute.Case_Notification_Id__c)){
	            	//AstuteVefr = eachAstute.clone();
	            	AstuteVefr.Status__c = '';
		            AstuteVefr.Message__c = '';
		            AstuteVefr.Case_Id__c = Constants.FI_MANUAL;
		            AstuteVefr.Status_ID__c = eachAstute.Case_Notification_Id__c;
		            String dts = CreateUniqueId.uniqID();
		            AstuteVefr.Case_Notification_Id__c = dts.substring(0,dts.length()-PickUpDate.length())+PickUpDate;
		            AstuteVefr.Account__c=eachAstute.Account__c;
	                AstuteVefr.Application__c=eachAstute.Application__c;
	                AstuteVefr.Property_Type__c=eachAstute.Property_Type__c;
	                AstuteVefr.Requested_Pincode__c = eachAstute.Requested_Pincode__c;
	                AstuteVefr.Requested_Address__c = eachAstute.Requested_Address__c;
	                AstuteVefr.Employment_Type__c = eachAstute.Employment_Type__c;
		            ListAstuteUpdt.add(AstuteVefr);
	            }
	        }
	        insert ListAstuteUpdt;
		} catch(Exception e) {
			System.debug('##### Exception at line '+ e.getStackTraceString() +' Message'+e.getMessage());
		}
		
	}
	//v1.1(end)
}