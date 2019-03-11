public with sharing class TermLoan_SOQL_Util {
	public TermLoan_SOQL_Util() {
		
	}

	public static void createInputRecord(String appId,String createdBy){
        List<New_Loan_Input__c> inputList= [select Id from New_Loan_Input__c where Application__c=: appId AND Input_Given_By__c=: createdBy];
        if(inputList.size()== 0){
            List<New_Loan_Input__c> newInputList= new List<New_Loan_Input__c>();
            New_Loan_Input__c inputCust= new New_Loan_Input__c(Application__c= appId,Input_Given_By__c= createdBy);
            New_Loan_Input__c inputBM= new New_Loan_Input__c(Application__c= appId,Input_Given_By__c= 'Manager');
            newInputList.add(inputCust);
            newInputList.add(inputBM);

            if(newInputList.size()>0){
                insert newInputList;

            }

        }

    }
	public static map<Id,Boolean> modTriggerMethod(Set<Id> appIdSet){

        List<genesis__Application_Collateral__c> allAppCollateral       = new List<genesis__Application_Collateral__c>();
        set<Id> collatAppIds= new Set<Id>();
        map<Id,Boolean> tlMap= new map<Id,Boolean>();
        String Land_And_Building_RT= Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();
        String Land_And_Building_Other_RT= Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Buildings - Other').getRecordTypeId();
        
        if(appIdSet.size()>0){
            allAppCollateral= [SELECT Id,Application__c,genesis__Collateral__r.Is_TL_Collateral__c,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c IN: appIdSet AND (genesis__Collateral__r.RecordTypeId =:Land_And_Building_RT OR genesis__Collateral__r.RecordTypeId=:Land_And_Building_Other_RT) AND genesis__Collateral__r.Category_of_Loan__c NOT IN ('Outright purchase of building','Purchase of land and construction there on')];
        
            for(genesis__Application_Collateral__c appcollat: allAppCollateral){
                collatAppIds.add(appcollat.Application__c);
            }
            if(collatAppIds.size()>0){
                for(Id appId:appIdSet){
                    if(collatAppIds.contains(appId)){
                        tlMap.put(appId,true);
                    }else{
                        tlMap.put(appId,false);
                    }
                }
            }else{
                for(Id appId:appIdSet){
                     tlMap.put(appId,false);
                }
            }
            return tlMap;
        }

     return null;    
    }
	public static map<String,String> bankAndAccountMap(String appRecId) {  //map<String,String>
        map<String,String> bankAccountMap= new map<String,String>();
        /*map<String,String> bankAccNameAndAccNumMap= new map<String,String>();
        map<String,Decimal> bankAccNumAndSumMap= new map<String,Decimal>();*/
        try{
        	List<genesis__Applications__c> appList= [select Type__c,genesis__Account__c,Overall_EMI__c,(select id,App_Facility_Type__c,CL_Product__r.Product_Type__c,Account_Number__c from Facilities__r where CL_Product__r.Product_Type__c= 'Funded' AND App_Facility_Type__c='WC') from genesis__Applications__c where Id=: appRecId];
	        decimal nonKVBCheckValue;
	        if(appList[0].Type__c== 'ETB-WC'||  appList[0].Type__c=='ETB-WC - Takeover'){
	            List<genesis__Applications__c> renewalappList= [select Type__c,genesis__Account__c,(select id,CL_Product__r.Product_Type__c,Account_Number__c from Facilities__r where CL_Product__r.Product_Type__c= 'Funded') from genesis__Applications__c where genesis__Account__c=: appList[0].genesis__Account__c AND Record_Type_Name__c= 'SME Renewal' AND Active__c= true];
	            if(renewalappList.size()>0 && renewalappList[0].Facilities__r.size()>0){
	                for(Facility__c faci:renewalappList[0].Facilities__r){
	                    bankAccountMap.put(faci.Account_Number__c,'KVB');
	                }
	                if(bankAccountMap.size()== 0){
	                    bankAccountMap.put('No Data','No Data');
	                }
	            }else{
	                bankAccountMap.put('No Data','No Data');
	            }
	        }else if(appList[0].Type__c== 'ETB-CA'|| appList[0].Type__c=='NTB' || appList[0].Type__c=='NTB - New to credit' || appList[0].Type__c=='ETB-CA - New to credit'){
	            List<Bank_Operations_Detail__c> bankOperationDtlsList= [select id,FIN_CR_AMT__c,Account__c,Bank_Type__c,Bank_Name__c,Bank_Account_No__c from Bank_Operations_Detail__c where Account__c=: appList[0].genesis__Account__c];
	            system.debug('appList[0].genesis__Account__c=====> '+appList[0].genesis__Account__c);
	            system.debug('appList[0].genesis__Account__c=====> '+appList[0].genesis__Account__c);
	            system.debug('bankOperationDtlsList=====> '+bankOperationDtlsList);
	            if(appList.size()>0 && appList[0].Facilities__r.size()>0){
	            	bankAccountMap.put('BM Enter','BM Enter');
	            }else if(bankOperationDtlsList.size()>0){
	                if(appList[0].Overall_EMI__c!=null){
	                    nonKVBCheckValue= 1.05*appList[0].Overall_EMI__c;
	                }
	                for(Bank_Operations_Detail__c bnkOpDtl: bankOperationDtlsList){
	                    if(bnkOpDtl.Bank_Type__c== 'Non KVB' && bnkOpDtl.FIN_CR_AMT__c!=null && nonKVBCheckValue!=null && bnkOpDtl.FIN_CR_AMT__c>= nonKVBCheckValue){
	                        bankAccountMap.put(bnkOpDtl.Bank_Account_No__c,bnkOpDtl.Bank_Name__c);
	                    }
	                    /*if(bnkOpDtl.Bank_Type__c== 'Non KVB'){
	                    	bankAccNameAndAccNumMap.put(bnkOpDtl.Bank_Account_No__c,bnkOpDtl.Bank_Name__c);
	                    	Decimal summation = bnkOpDtl.FIN_CR_AMT__c==null? 0:bnkOpDtl.FIN_CR_AMT__c;
	                    	if(bankAccNumAndSumMap.containskey(bnkOpDtl.Bank_Account_No__c)){
	                    		bankAccNumAndSumMap.put(bnkOpDtl.Bank_Account_No__c,bankAccNumAndSumMap.get(bnkOpDtl.Bank_Account_No__c)+summation);
                    		}else{
                    			bankAccNumAndSumMap.put(bnkOpDtl.Bank_Account_No__c,summation);
                    		}
	                    	

	                    }*/else if(bnkOpDtl.Bank_Type__c== 'KVB' && bnkOpDtl.Bank_Account_No__c!= null){
	                        List<String> accList = bnkOpDtl.Bank_Account_No__c.split(';');
	                        for(String str:accList){
	                            bankAccountMap.put(str,'KVB');
	                        }

	                    }
	                }
	                /*if(bankAccNumAndSumMap.size()>0){
	                	for(String str: bankAccNumAndSumMap.keyset()){
	                		if(bankAccNumAndSumMap.get(str)>nonKVBCheckValue){
	                			bankAccountMap.put(str,bankAccNameAndAccNumMap.get(str));
	                		}
	                	}
	                }*/
	                 
	            }
	            if(bankAccountMap.size()==0){
                    bankAccountMap.put('No Data','No Data');
                }
	        }else if(appList[0].Type__c=='ETB-CA - Takeover' || appList[0].Type__c=='NTB - Takeover'){
	            /*Boolean wcFaci= false;
	            Boolean tlFaci= false;*/
	            if(appList[0].Facilities__r.size()>0){
	            	bankAccountMap.put('BM Enter','BM Enter');
	                /*for(Facility__c faci:appList[0].Facilities__r){
	                    if(faci.App_Facility_Type__c== 'WC'){
	                        wcFaci= true;
	                    }else if(faci.App_Facility_Type__c== 'TL'){
	                        tlFaci=true;
	                    }
	                }*/

	                /*if(wcFaci== true){
	                    bankAccountMap.put('BM Enter','BM Enter');
	                }else if(tlFaci= true && wcFaci== false){*/
	            }else{
	            	List<Bank_Operations_Detail__c> bankOperationDtlsList= [select id,FIN_CR_AMT__c,Account__c,Bank_Type__c,Bank_Name__c,Bank_Account_No__c from Bank_Operations_Detail__c where Account__c=: appList[0].genesis__Account__c ORDER BY createddate ASC];
                    if(bankOperationDtlsList.size()>0){
                        if(appList[0].Overall_EMI__c!=null){
                            nonKVBCheckValue= 1.05*appList[0].Overall_EMI__c;
                        }
                        for(Bank_Operations_Detail__c bnkOpDtl: bankOperationDtlsList){
                            if(bnkOpDtl.Bank_Type__c== 'Non KVB' && bnkOpDtl.FIN_CR_AMT__c!=null && nonKVBCheckValue!=null && bnkOpDtl.FIN_CR_AMT__c>= nonKVBCheckValue){
                                bankAccountMap.put(bnkOpDtl.Bank_Account_No__c,bnkOpDtl.Bank_Name__c);
                            }
                            /*if(bnkOpDtl.Bank_Type__c== 'Non KVB'){
                            	bankAccNameAndAccNumMap.put(bnkOpDtl.Bank_Account_No__c,bnkOpDtl.Bank_Name__c);
		                    	Decimal summation = bnkOpDtl.FIN_CR_AMT__c==null? 0:bnkOpDtl.FIN_CR_AMT__c;
		                    	if(bankAccNumAndSumMap.containskey(bnkOpDtl.Bank_Account_No__c)){
		                    		bankAccNumAndSumMap.put(bnkOpDtl.Bank_Account_No__c,bankAccNumAndSumMap.get(bnkOpDtl.Bank_Account_No__c)+summation);
	                    		}else{
	                    			bankAccNumAndSumMap.put(bnkOpDtl.Bank_Account_No__c,summation);
	                    		}
                        	}*/else if(bnkOpDtl.Bank_Type__c== 'KVB' && bnkOpDtl.Bank_Account_No__c!= null){
                                List<String> accList = bnkOpDtl.Bank_Account_No__c.split(';');
                                for(String str:accList){
                                    bankAccountMap.put(str,'KVB');
                                }

                            }
                        }
                        /*if(bankAccNumAndSumMap.size()>0){
		                	for(String str: bankAccNumAndSumMap.keyset()){
		                		if(bankAccNumAndSumMap.get(str)>nonKVBCheckValue){
		                			bankAccountMap.put(str,bankAccNameAndAccNumMap.get(str));
		                		}
		                	}
		                }*/ 
                    }
	            }

	                //}
                if(bankAccountMap.size()==0){
                    bankAccountMap.put('No Data','No Data');
                }

	            
	        }

    	}catch(Exception e){
    		HandleBusinessException.captureError('TermLoan_SOQL_Util','bankAndAccountMap',e);
    	}
        return bankAccountMap;
    }

    @future (callout=true)
    public static void futureSmeTUcall(List<String> custCBSList,String type, String appId){
    	system.debug('custCBSList====> '+custCBSList);
    	system.debug('type====> '+type);
    	system.debug('appId====> '+appId);
    	CommercialPR_EAE_Batch.getCommercialPR_EAE_Request(custCBSList,type,appId);
    }

    public static List<genesis__Applications__c> getApplicationbycustomerid(List<String> custid,Boolean activestate){
    	//check recordtypeoof customer: Business Account
    	List<String> excludedrectype=new List<String>{'SME_AdHoc','SME_Exceeding','Term_Loan'};
    	List<genesis__Applications__c> appList=new List<genesis__Applications__c>();
    	//String custRecordType   = Soql_util.getCustomerRecordType(custid);
    	//System.debug(custRecordType);
    	
    	appList=[select id,RecordType.developername,genesis__Account__c,Application_to_close__c,createddate,Application_Stage__c,Bundled_Stage__c,Active__c,(Select id,whatid,Status,Bundled_Task__c from Tasks) from genesis__Applications__c where RecordType.developername not in: excludedrectype and Active__c=:activestate and genesis__Account__c in :custid];
    	//System.debug('appList=='+appList);
    	return appList;
    }

    public static List<genesis__Applications__c> getApplicationbyappid(String appid){

    	String queryString      = 'Select Id,Name,RecordType.DeveloperName,CustomerID__c,Application_to_close__c,genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.CBS_Customer_ID__c,Loan_Account_Number__c,Renewal_Due_Date__c,genesis__Loan_Amount__c,Pre_Renewal_Checklist__c,Application_Status__c,Application_UI_Stage__c,Application_Stage__c from genesis__Applications__c';
        queryString             += ' where Id=:appid AND  Active__c = true';
        return database.query(queryString);

    }
    public static List<genesis__Applications__c> getinactiveapp(String custid){
    	List<genesis__Applications__c> lstapp=new List<genesis__Applications__c>();
    	lstapp=[select id,RecordType.developername,genesis__Account__c,Application_to_close__c,createddate,Application_Stage__c,Bundled_Stage__c,Active__c,(Select id,whatid,Status,Bundled_Task__c from Tasks) from genesis__Applications__c where RecordType.developername=:Constants.SME_APP_RECORD_TYPE and Active__c=true and genesis__Account__c =:custid order by createddate DESC Limit 1];
    	return lstapp;

    }
    public static List<genesis__Applications__c> getinactiveEnhancementapp(String custid){
    	List<genesis__Applications__c> lstapp=new List<genesis__Applications__c>();
    	lstapp=[select id,RecordType.developername,genesis__Account__c,Application_to_close__c,createddate,Application_Stage__c,Bundled_Stage__c,Active__c,(Select id,whatid,Status,Bundled_Task__c from Tasks) from genesis__Applications__c where RecordType.developername=:Constants.SME_APP_RECORD_TYPE_ENHANCEMENT and Active__c=true and genesis__Account__r.CBS_Customer_ID__c =:custid and Application_Stage__c='Enhancement Loan under process' order by createddate DESC Limit 1];
    	System.debug('lstapp==='+lstapp);
    	return lstapp;

    }
    public static Boolean bankDataExist(String accuntNumber, String accountId){
    	Boolean accountExist;
    	List<Bank_Operations_Detail__c> bnkOpDtl= [select Id from Bank_Operations_Detail__c where Account__c=:accountId AND Bank_Account_No__c=:accuntNumber];
    	if(bnkOpDtl.size()>0){
    		accountExist= true;
		}else{
			accountExist= false;
		}
		return accountExist;
    }
}