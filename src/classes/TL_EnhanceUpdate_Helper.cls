public class TL_EnhanceUpdate_Helper{



	public static void bundling(String appid, String custid){
	List<genesis__Applications__c> bundledapplication=new List<genesis__Applications__c>(); 
	List<genesis__Applications__c> listApp=TermLoan_SOQL_Util.getApplicationbycustomerid(new List<String>{custid},true);
	//System.debug('all Eligible apps ===='+listApp);
	genesis__Applications__c newapp;
	try{
		if(!listApp.isEmpty()){
			for(genesis__Applications__c app:listApp){
				if(app.id==appid){
					newapp=app;
				}
			}
		}
		System.debug('all Eligible apps ===='+newapp);
		//List<genesis__Applications__c> allappcust=SOQL_Util.getCustApplicationListbyCustomer(lstapp[0].genesis__Account__C);
		System.debug('newapp.recordtype.developername==='+newapp.recordtype.developername);
		System.debug('newapp.Active__c==='+newapp.Active__c);
		System.debug('1.Number of Queries used in this apex code so far: @@@@' + Limits.getQueries());
		if(newapp!=null && !listApp.isEmpty()){
			if(newapp.recordtype.developername==Constants.SME_NEW_LOAN_RECORD_TYPE &&  newapp.Active__c==true){
				//System.debug('Heree 1 ====');
				for(genesis__Applications__c currentApp:listApp){
					System.debug('1.Number of Queries used in this apex code so far: @@@@' + Limits.getQueries());
					if(currentApp.id!=appid){ //existing renewal application check
						//System.debug('Heree 2 ====');
						if(currentApp.recordtype.developername==Constants.SME_APP_RECORD_TYPE && !((currentApp.Application_Stage__c==Constants.ACCOUNT_CLOSE) || (currentApp.Application_Stage__c==Constants.GREATER_THAN_2CR) || (currentApp.Application_Stage__c==Constants.NEW_LOAN_UNDER_PROCESS) || (currentApp.Application_Stage__c==Constants.ENHANCEMENT_LOAN_UNDER_PROCESS)) && currentApp.Active__c==true){
							//System.debug('Heree 3 ====');
							bundledapplication.add(bundleexistingapp(currentApp,Constants.NEW_LOAN_UNDER_PROCESS));
						}
						else if(currentApp.recordtype.developername==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT && !(((Utility.getEnhancementExcludedStages(Constants.ENHANCEMENT_CUSTOM_SETTING)).split(';')).contains(currentApp.Application_Stage__c)) && currentApp.Active__c==true){
							//System.debug('Hereee 3 ====');
							bundledapplication.add(bundleexistingapp(currentApp,Constants.NEW_LOAN_UNDER_PROCESS));
						}// for enhancment limit opened
						/*if(currentApp.recordtype.developername==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT && currentApp.Application_Stage__c==Constants.ENHANCEMENT_APPLICATION_CREATED && currentApp.Active__c==true){
							bundledapplication.add(bundleexistingapp(currentApp,Constants.NEW_LOAN_UNDER_PROCESS));
						}*/

					}
				}		
			}
			else if(newapp.recordtype.developername==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT && newapp.Active__c==true){
				for(genesis__Applications__c currentApp:listApp){
					if(currentApp.id!=appid){//existing renewal application check
						if(currentApp.recordtype.developername==Constants.SME_APP_RECORD_TYPE && !((currentApp.Application_Stage__c==Constants.ACCOUNT_CLOSE) || (currentApp.Application_Stage__c==Constants.GREATER_THAN_2CR)) && currentApp.Active__c==true){
							bundledapplication.add(bundleexistingapp(currentApp,Constants.ENHANCEMENT_LOAN_UNDER_PROCESS));
						}/* Exusting renewal with any other stage
						if(currentApp.recordtype.developername==Constants.SME_APP_RECORD_TYPE && currentApp.Application_Stage__c==Constants.APPLN_MORE_THAN_6_MONTH && currentApp.Active__c==true){
							bundledapplication.add(bundleexistingapp(currentApp,Constants.ENHANCEMENT_LOAN_UNDER_PROCESS));
						}*/
					}
				}
			}
		}

		if(!bundledapplication.isEmpty()){
			System.debug('Heree 8 ===='+bundledapplication);
			newapp.Application_to_close__c=true;
			bundledapplication.add(newapp);
			ApplicationTriggerHandler.IsFirstRun = false;
			update bundledapplication;
		}
	}
	catch(Exception ex){
		HandleBusinessException.captureError('TL_EnhanceUpdate_Helper', 'bundling', ex);
	}
	}

	public static genesis__Applications__c bundleexistingapp(genesis__Applications__c bundleapp,string stage){
		List<Task> tasklist=new List<Task>();
		
		try{
			System.debug('Heree 4 ===='+bundleapp);
			if(bundleapp.recordtype.developername!=Constants.SME_APP_RECORD_TYPE){
				bundleapp.Active__c=false;
			}
			bundleapp.Bundled_Stage__c=bundleapp.Application_Stage__c;
			bundleapp.Application_Stage__c=stage;
			if(!bundleapp.tasks.isEmpty()){
				//System.debug('Heree 5 ===='+bundleapp.tasks);
				for(Task taskrec:bundleapp.tasks){
					if(taskrec.status==Constants.TASK_STATUS_NOT_STARTED){
						taskrec.status=Constants.COMPLETED;
						taskrec.Bundled_Task__c=true;
						tasklist.add(taskrec);
						//System.debug('Heree 6 ===='+tasklist);
					}
				}
			}
			if(tasklist!=null && !tasklist.isEmpty()){
				//System.debug('Heree 7 ===='+tasklist);
				TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
				update tasklist;
			}
		}
		catch(Exception ex){
			HandleBusinessException.captureError('TL_EnhanceUpdate_Helper','bundleexistingapp',ex);
		}
		return bundleapp;
	}

	public static void ApllicationTriggerUbundling(List<genesis__Applications__c> currentApps){
		//Map<String,List<genesis__Applications__c>> allrelatedapps=new Map<String,List<genesis__Applications__c>>();
		//List<genesis__Applications__c> rejectedapps=new List<genesis__Applications__c>();
		List<genesis__Applications__c> listApplicationUp=new list<genesis__Applications__c>();
		List<genesis__Applications__c> renewalinactiveapp=new List<genesis__Applications__c>();
		System.debug('currentApps==='+currentApps);
		try{
			
			if(!currentApps.isEmpty()){
				for(genesis__Applications__c apprec:currentApps){
					System.debug('here 1 ===='+apprec.RecordType_Developer_Name__c);
					if(apprec.RecordType_Developer_Name__c==Constants.SME_NEW_LOAN_RECORD_TYPE){
						System.debug('here 2 ====');
						if(apprec.Application_to_close__c==true && (apprec.Application_Stage__c=='New loan - Application rejected' || apprec.Application_Stage__c=='Discontinued Application'|| apprec.Application_Stage__c=='Application Rejected')){
							System.debug('here 3 ====');
							renewalinactiveapp.addAll(TermLoan_SOQL_Util.getinactiveapp(apprec.genesis__Account__c));
							System.debug('here 4 ===='+renewalinactiveapp);
						}
					}
					else if(apprec.RecordType_Developer_Name__c==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
						if(apprec.Application_to_close__c==true && (apprec.Application_Stage__c=='Discontinued Application'||apprec.Application_Stage__c=='Application Rejected')){
							renewalinactiveapp.addAll(TermLoan_SOQL_Util.getinactiveapp(apprec.genesis__Account__c));
						}
					}
				}
				for(genesis__Applications__c renewapp:renewalinactiveapp){
					renewapp.Active__c=true;
					renewapp.Application_Stage__c=renewapp.Bundled_Stage__c;
					listApplicationUp.add(renewapp);
					reopenallTask(renewapp.Tasks);
				}


			}

			if(!listApplicationUp.isEmpty()){
				ApplicationTriggerHandler.isFirstRun=false;
				update listApplicationUp;
			}
		}
		catch(Exception ex){
			HandleBusinessException.captureError('Applicationtriggerclass','ApllicationTriggerUbundling',ex);
		}

	}

	public static void reopenallTask(List<Task> tasktobeOpened){
		List<Task> tasklist=new List<Task>();
		if(!tasktobeOpened.isEmpty()){
			For(Task taskrec:tasktobeOpened){
				if(taskrec.Bundled_Task__c){
					taskrec.status=Constants.TASK_STATUS_NOT_STARTED;
					tasklist.add(taskrec);
				}
			}
		}
		if(!tasklist.isEmpty()){
			TaskFlow_Helper.TASK_TRIGGER_RUNNING=true;
			update tasklist;
		}
	}






	public static Map<String,genesis__Applications__c> getMapofCustomerEnhancamentApp(Set<String> customerids,String recordtypename){
		Map<String,genesis__Applications__c> custEnhancementMap=new Map<String,genesis__Applications__c>();
		List<genesis__Applications__c> applist=TermLoan_SOQL_Util.getApplicationbycustomerid(new List<String>(customerids),false);
		if(!applist.isEmpty()){

			For(genesis__Applications__c apprec:applist){
				if(apprec.recordtype.developername==recordtypename){
						if(custEnhancementMap.containsKey(apprec.genesis__Account__c)){
							if(custEnhancementMap.get(apprec.genesis__Account__c).createddate < apprec.createddate){
								custEnhancementMap.put(apprec.genesis__Account__c,apprec);
							}
						}
						else{
							custEnhancementMap.put(apprec.genesis__Account__c,apprec);
						}
				}
			}
			System.debug('mapof customer createddate'+custEnhancementMap);

		}
		return custEnhancementMap;
	}

	/*public static void unbundleapplication(String appid){
		Map<String,genesis__Applications__c> deactivateappMap=new Map<String,genesis__Applications__c>();
		genesis__Applications__c currentApp=TermLoan_SOQL_Util.getApplicationbyappid(appid);
		try{
			if(currentApp!=null && currentApp.recordtype.developername==Constants.SME_NEW_LOAN_RECORD_TYPE){
				currentApp.Application_Stage__c='New loan - Application rejected';

			}

		}








		List<genesis__Applications__c> deactivatedapplst=TermLoan_SOQL_Util.getApplicationbycustomerid(new List<String>{applist[0].genesis__Account__c},false);
		if(!applist.isEmpty() && applist[0].recordtype.developername!=Constants.SME_APP_RECORD_TYPE){
			if(applist[0].Application_to_close__c==true && applist[0].recordtype.developername==Constants.SME_NEW_LOAN_RECORD_TYPE && (applist[0].Application_Stage__c=='New loan - Application rejected' || applist[0].Application_Stage__c=='Discontinued Application')){
				genesis__Applications__c inactiveapp=TermLoan_SOQL_Util.getinactiveapp(appid)[0];
				inactiveapp.Active__c=true;
				inactiveapp.Application_Stage__c=inactiveapp.Bundled_Stage__c;
				for(Task taskrec:inactiveapp.Tasks){
					if(taskrec.Bundled_Task__c==true){
						taskrec.status=Constants.TASK_STATUS_NOT_STARTED;
					}
				}
			}
			else if(applist[0].Application_to_close__c==true && applist[0].recordtype.developername==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT && applist[0].Application_Stage__c=='Discontinued Application'){
				genesis__Applications__c inactiveapp=TermLoan_SOQL_Util.getinactiveapp(appid)[0];
				inactiveapp.Active__c=true;
				inactiveapp.Application_Stage__c=inactiveapp.Bundled_Stage__c;
				for(Task taskrec:inactiveapp.Tasks){
					if(taskrec.Bundled_Task__c==true){
						taskrec.status=Constants.TASK_STATUS_NOT_STARTED;
					}
				}
			}

		}

		update inactiveapp;
	}*/

}