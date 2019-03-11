global with sharing class TermLoan_Button_Utility {

	webservice static Boolean linkDedupCollateral(String appId,String sellectedName, String duplicateCollateralId, String oldM21Data){
		try{
			list<clcommon__Collateral__c> selectedCollatList= [select Id from clcommon__Collateral__c where Name=: sellectedName];
			list<genesis__Application_Collateral__c> appCollateralsLst=[select id,Application__c,genesis__Collateral__c,genesis__Collateral__r.Visit_Date__c from genesis__Application_Collateral__c where  Application__c=: appId];
			for(genesis__Application_Collateral__c appCollat:appCollateralsLst){
				if(appCollat.genesis__Collateral__c == duplicateCollateralId){
					appCollat.genesis__Collateral__c= selectedCollatList[0].Id;
					appCollat.M121_Done__c= true;
				}else if(appCollat.genesis__Collateral__r.Visit_Date__c!=null){
					appCollat.M121_Done__c= true;
				}
				
			}
			update appCollateralsLst;
			checkM121andCloseTask(appId);
			return true;
		}catch(Exception e){
			System.debug('Error Line Number ===> '+e.getLineNumber());
			System.debug('Error Message ===> '+e.getMessage());
			return false;
		}
	}

	webservice static Boolean linkMWdedupcollateral(String appId,String currentCollateralId,String sellectedApiNAname,String M21Obj){
		System.debug('M21Obj===> '+M21Obj);
		
		
		list<clcommon__Collateral__c> sellectedApiNAnameCollatList= [select Id,clcommon__Collateral_Name__c from clcommon__Collateral__c where clcommon__Collateral_Name__c=: sellectedApiNAname];
		list<genesis__Application_Collateral__c> appCollateralsLst=[select id,Application__c,genesis__Collateral__c,genesis__Collateral__r.Visit_Date__c from genesis__Application_Collateral__c where  Application__c=: appId];
		if(sellectedApiNAnameCollatList.size()>0){
			if(appCollateralsLst.size()>0){
				for(genesis__Application_Collateral__c appCollat: appCollateralsLst){
					if(appCollat.genesis__Collateral__c== currentCollateralId){
						appCollat.genesis__Collateral__c= sellectedApiNAnameCollatList[0].Id;
						appCollat.M121_Done__c= true;
					}
				}
			}
		}else if(sellectedApiNAnameCollatList.size()==0){
			list<clcommon__Collateral__c> currentCollateralIdList= [select Id,clcommon__Collateral_Name__c from clcommon__Collateral__c where Id=: currentCollateralId];
			M21_A__c M21data= (M21_A__c) JSON.deserialize(M21Obj, M21_A__c.class);
			if(currentCollateralIdList.size()>0){
				currentCollateralIdList[0].clcommon__Collateral_Name__c= sellectedApiNAname;
				currentCollateralIdList[0].SurveyKhasraKhataPatta_No__c= M21data.SurveyKhasraKhataPatta_No__c;
				currentCollateralIdList[0].Customer_id__c= M21data.Customer_id__c;
				currentCollateralIdList[0].Division__c= M21data.Division__c;
				currentCollateralIdList[0].State__c= M21data.State__c;
				currentCollateralIdList[0].Document_Number__c= M21data.Document_Number__c;
				currentCollateralIdList[0].District_Name__c= M21data.District_Name__c;
				currentCollateralIdList[0].Document_Date__c= M21data.Document_Date__c!=null ? Date.valueOf(M21data.Document_Date__c):null;
				currentCollateralIdList[0].Visit_Date__c= M21data.Visit_Date__c!=null? Date.valueOf(M21data.Visit_Date__c): null;
				update currentCollateralIdList;
			}
			if(appCollateralsLst.size()>0){
				for(genesis__Application_Collateral__c appCollat: appCollateralsLst){
					if(appCollat.genesis__Collateral__c== currentCollateralId){
						appCollat.M121_Done__c= true;
					}
					
				}
			}
		}
		
		if(appCollateralsLst.size()>0){
			for(genesis__Application_Collateral__c appCollat: appCollateralsLst){
				if(appCollat.genesis__Collateral__r.Visit_Date__c!=null){
					appCollat.M121_Done__c= true;
				}
			}
			update appCollateralsLst;
		}
		
		checkM121andCloseTask(appId);
		return true;
	}
	webservice static Boolean updteCollateDetails(String appId,String M21Obj,String currentCollateralId){
		System.debug('M21Obj====> '+M21Obj);
		M21_A__c bbb= (M21_A__c) JSON.deserialize(M21Obj, M21_A__c.class);
		M21_A__c M21data= (M21_A__c) JSON.deserialize(M21Obj, M21_A__c.class);
		System.debug('bbb===> '+bbb);
		list<clcommon__Collateral__c> currentCollateralIdList= [select Id,clcommon__Collateral_Name__c from clcommon__Collateral__c where Id=: currentCollateralId];
		if(currentCollateralIdList.size()>0){
			currentCollateralIdList[0].SurveyKhasraKhataPatta_No__c= M21data.SurveyKhasraKhataPatta_No__c; // text
			currentCollateralIdList[0].Customer_id__c= M21data.Customer_id__c;//Text
			currentCollateralIdList[0].Division__c= M21data.Division__c;//Text
			currentCollateralIdList[0].State__c= M21data.State__c;//Text
			currentCollateralIdList[0].Document_Number__c= M21data.Document_Number__c;//Text
			currentCollateralIdList[0].District_Name__c= M21data.District_Name__c;//Text
			currentCollateralIdList[0].Document_Date__c= M21data.Document_Date__c!=null ? Date.valueOf(M21data.Document_Date__c):null;//Date
			currentCollateralIdList[0].Visit_Date__c= M21data.Visit_Date__c!=null? Date.valueOf(M21data.Visit_Date__c): null;
			update currentCollateralIdList;
		}
		list<genesis__Application_Collateral__c> appCollateralsLst=[select id,Application__c,genesis__Collateral__c,genesis__Collateral__r.Visit_Date__c from genesis__Application_Collateral__c where Application__c=: appId];//genesis__Collateral__c=: currentCollateralId AND 
		if(appCollateralsLst.size()>0){
			for(genesis__Application_Collateral__c appCollat: appCollateralsLst){
				if(appCollat.genesis__Collateral__r.Visit_Date__c!=null){
					appCollat.M121_Done__c= true;
				}
			}
			update appCollateralsLst;
		}
		checkM121andCloseTask(appId);
		return true;

	}
	webservice static void checkM121andCloseTask(String appId){
		List<String> CollatRecordType= new List<String>{'Land_And_Building','Land_And_Buildings_Other'};
		list<genesis__Application_Collateral__c> appCollateralsLst=[select id,Application__c,genesis__Collateral__c from genesis__Application_Collateral__c 
			where  Application__c=: appId AND genesis__Collateral__r.Collateral_Record_Type__c IN: CollatRecordType AND M121_Done__c=false];
		if(appCollateralsLst.size()==0){
			List<Task> getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And Type='M121 A Needed' And  Status = 'Not Started'];
			if(! getExistingTaskList.isEmpty()){
                getExistingTaskList[0].Status = 'Completed';
                update getExistingTaskList;
            }
		}

	}
		
}