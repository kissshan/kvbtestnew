/*
* @name        : StandardReportController
* @description : Controller class for StandardReport VF Page
* @author      : Souvik Banik
*/

public class StandardReportController {

	@RemoteAction
    public static User getUserDetails(){
        try{
            return [SELECT Id,Designation__c,Division,Branch_Name__c,Office_Code__c FROM USER WHERE Id =: UserInfo.getUserId()];
        }catch(Exception e){
            HandleBusinessException.captureError('StandardReportController', 'getUserDetails', e);
            return null;
        }
    }
    
    @RemoteAction
    public static List<Product_Categories__c> getProdCategory() {
        try{
            return [SELECT Name,Recordtype_Developer_Name__c FROM Product_Categories__c ORDER BY Name ASC];
        }catch(Exception e){
            HandleBusinessException.captureError('StandardReportController', 'getProdCategory', e);
            return null;
        }
    }
    
    @RemoteAction
    public static List<Period__c> getPeriod() {
        try{
            return [SELECT Name,Value__c,Order__c FROM Period__c ORDER BY Order__c ASC];
        }catch(Exception e){
            HandleBusinessException.captureError('StandardReportController', 'getPeriod', e);
            return null;
        }
    }
    
    @RemoteAction
    public static Map<String,List<Branch_Master__c>> getDivisionAndBranch(){
    	try{
    		Map<String,List<Branch_Master__c>> divBranchmap = new Map<String,List<Branch_Master__c>>();
    		List<AggregateResult> results = [SELECT Division_Code__c FROM Branch_Master__c GROUP BY Division_Code__c];
			Set<String> divCodeSet = new Set<String>();
			if(! results.isEmpty()){
				for(AggregateResult ar : results){
				    divCodeSet.add(String.valueOf(ar.get('Division_Code__c')));
				    System.debug('@@@--> ' + divCodeSet);
				}
				System.debug('Size' + divCodeSet.size());
			}
			List<Branch_Master__c> divNameList = [SELECT Division__c,Division_Code__c,CODCCBRN__c,NAM_BRANCH__c FROM Branch_Master__c WHERE Division_Code__c IN : divCodeSet AND Division_Code__c != null];
			if(! divNameList.isEmpty()){
				for(Branch_Master__c bm : divNameList){
					if(divBranchmap.containsKey(bm.Division__c)){
						divBranchmap.get(bm.Division__c).add(bm);
					}
					else{
						divBranchmap.put(bm.Division__c,new List<Branch_Master__c>{bm});
					}
				}
			}
			return divBranchmap;
    	}catch(Exception e){
    		HandleBusinessException.captureError('StandardReportController', 'getDivisionAndBranch', e);
            return null;
    	}
    }

    @RemoteAction
    public static List<Branch_Master__c> getBranchForDivision(String divCode){
    	try{
    		List<Branch_Master__c> branchList;
    		if(divCode != null)
    		branchList = [SELECT Division_Code__c,CODCCBRN__c,NAM_BRANCH__c FROM Branch_Master__c WHERE Division_Code__c =: divCode];
    		return branchList;
    	}catch(Exception e){
    		HandleBusinessException.captureError('StandardReportController', 'getBranchForDivision', e);
            return null;
    	}
    }

    @RemoteAction
    public static Map<String,List<MISReportWrapper>> getBuckettedRecords(getRecordWrapper saveData){

    	try{
    		List<MISReportWrapper> MISReportWrapList = new List<MISReportWrapper>();
    		List<MISReportWrapper> MISReportWrapListLast = new List<MISReportWrapper>();

            if(saveData != null){
                String appRecType		= saveData.prodCat;
                String periodvalue  	= saveData.period;
                String branch 			= saveData.branchName;
                String division 		= saveData.division;
                System.debug('Product--> ' + appRecType);
                System.debug('Periodvalue--> ' + periodvalue);
                System.debug('branch--> ' + branch);
                System.debug('division--> ' + division);
                System.debug('StartDate--> ' + saveData.fromDate);
                System.debug('EndDate--> ' + saveData.toDate);
				
				/***** FromDateTime ******/
                String fDate 				= saveData.fromDate; 									// Wed Aug 01 2018 00:00:00 GMT+0530 (India Standard Time)
                fdate 						= fdate.substring(0,fdate.length()-27);					// Wed Aug 01 2018 00:00:00 GMT
                DateTime fDatetime 			= getFormattedDateTime(fdate);							// 2018-08-01 00:00:00
                String formattedFROMDate 	= fDatetime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');  // 2018-08-01T00:00:00Z
                DateTime custFDateTime				= getFormattedDateTimeForCustomLastPeriod(fdate);				// 2017-08-01 00:00:00
                String formattedFROMDateLastPeriod 	= custFDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');		// 2017-08-01T00:00:00Z
                /***** ToDateTime *****/
                String tDate 				= saveData.toDate;										// Fri Aug 31 2018 00:00:00 GMT+0530 (India Standard Time)
                tDate 						= tDate.substring(0,tDate.length()-27);					// Fri Aug 31 2018 00:00:00 GMT
                DateTime tDatetime 			= getFormattedDateTime(tDate);							// 2018-08-31 00:00:00
                String formattedTODate 		= tDatetime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');  // 2018-08-31T00:00:00Z
                DateTime custTDateTime				= getFormattedDateTimeForCustomLastPeriod(tDate);				// 2017-08-31 00:00:00
                String formattedTODateLastPeriod 	= custTDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');		// 2017-08-31T00:00:00Z
				
                List<MIS_Report_Bucketing__mdt> MisBucketingList = [SELECT Bucket_Category__c,Order__c,Product_Name__c,Rule__c,Active__c,(SELECT Expression__c,Field_API__c,Field_Value__c,Order__c FROM MIS_Report_Childs__r) FROM MIS_Report_Bucketing__mdt WHERE Product_Name__c=:appRecType AND Order__c!=null AND Active__c = true ORDER BY Order__c ASC];
                System.debug('Bucket Category--> '+MisBucketingList);
                List<genesis__Applications__c> appList;
				List<genesis__Applications__c> appListForLastperiod;
                MISReportWrapper wrapObj;
                MISReportWrapper wrapObj2;
 
                for(MIS_Report_Bucketing__mdt parentMDTObj : MisBucketingList){
                    System.debug('Bucket Category--> '+parentMDTObj.Bucket_Category__c);

                    String query = '';
					String queryForLastPeriod = '';
                    query = 'SELECT Id,Name,Branch_Name__c,genesis__Loan_Amount__c,Disbursement_Amount__c,Sanction_Authority_Limit__c,(SELECT Id,Existing_Limit__c,Recommended_Limit__c FROM Facilities__r) FROM genesis__Applications__c WHERE (';
					queryForLastPeriod = 'SELECT Id,Name,Branch_Name__c,genesis__Loan_Amount__c,Disbursement_Amount__c,Sanction_Authority_Limit__c,createdDate,(SELECT Id,Existing_Limit__c,Recommended_Limit__c FROM Facilities__r) FROM genesis__Applications__c WHERE (';
                    wrapObj = new MISReportWrapper();
                    wrapObj2 = new MISReportWrapper();
                    String whereClause = parentMDTObj.Rule__c;
                    System.debug('my Rule--> ' + whereClause);
                    for(MIS_Report_Child__mdt childMDTObj : parentMDTObj.MIS_Report_Childs__r){
                    	System.debug('my Rule Order--> ' + String.valueOf(childMDTObj.Order__c));
                        whereClause = whereClause.replace('RULE'+String.valueOf(childMDTObj.Order__c),String.valueOf(childMDTObj.Field_API__c +childMDTObj.Expression__c+ childMDTObj.Field_Value__c));
                    	System.debug('whereClause--> ' + whereClause);
                    }

					if(periodvalue == 'Current CY'){
						query += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND createdDate >= '+formattedFROMDate +' AND createdDate <= '+ formattedTODate;
						appList = Database.query(query);
						queryForLastPeriod += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = LAST_YEAR';
						appListForLastperiod = Database.query(queryForLastPeriod);
						System.debug('query--> ' + query);
						System.debug('queryForLastPeriod--> ' + queryForLastPeriod);
						System.debug('appList--> ' + appList.size());
						System.debug('appListForLastperiod--> ' + appListForLastperiod.size());
					}
                    else if(periodvalue == 'Current CQ'){
						query += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND createdDate >= '+formattedFROMDate +' AND createdDate <= '+ formattedTODate;
						appList = Database.query(query);
						queryForLastPeriod += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = LAST_QUARTER';
						appListForLastperiod = Database.query(queryForLastPeriod);
						System.debug('query---> ' + query);
						System.debug('queryForLastPeriod---> ' + queryForLastPeriod);
						System.debug('appList---> ' + appList);
						System.debug('appListForLastperiod---> ' + appListForLastperiod);
					}
					else if(periodvalue == 'This Month'){
						query += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND createdDate >= '+formattedFROMDate +' AND createdDate <= '+ formattedTODate;
						queryForLastPeriod += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = LAST_MONTH';
						appList = Database.query(query);
						appListForLastperiod = Database.query(queryForLastPeriod);
						System.debug('query--> ' + query);
						System.debug('queryForLastPeriod--> ' + queryForLastPeriod);
						System.debug('appList--> ' + appList.size());
						System.debug('appListForLastperiod--> ' + appListForLastperiod.size());
					}
					else if(periodvalue == 'This Week'){
						query += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND createdDate >= '+formattedFROMDate +' AND createdDate <= '+ formattedTODate;
						appList = Database.query(query);
						queryForLastPeriod += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = LAST_WEEK';
						appListForLastperiod = Database.query(queryForLastPeriod);
						System.debug('query--> ' + query);
						System.debug('queryForLastPeriod--> ' + queryForLastPeriod);
						System.debug('appList--> ' + appList.size());
						System.debug('appListForLastperiod--> ' + appListForLastperiod.size());
					}
					else if(periodvalue == 'Yesterday'){
						query += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND createdDate >= '+formattedFROMDate +' AND createdDate <= '+ formattedTODate;
						appList = Database.query(query);
						queryForLastPeriod += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND CreatedDate = LAST_N_DAYS:2 AND CreatedDate NOT IN (TODAY, YESTERDAY)';
						appListForLastperiod = Database.query(queryForLastPeriod);
						System.debug('query--> ' + query);
						System.debug('queryForLastPeriod--> ' + queryForLastPeriod);
						System.debug('appList--> ' + appList.size());
						System.debug('appListForLastperiod--> ' + appListForLastperiod.size());
					}
					else if(periodvalue == 'Today'){
						query += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND createdDate >= '+formattedFROMDate +' AND createdDate <= '+ formattedTODate;
						appList = Database.query(query);
						queryForLastPeriod += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND DAY_ONLY(convertTimezone(CreatedDate)) = YESTERDAY';
						appListForLastperiod = Database.query(queryForLastPeriod);
						System.debug('query--> ' + query);
						System.debug('queryForLastPeriod--> ' + queryForLastPeriod);
						System.debug('appList--> ' + appList.size());
						System.debug('appListForLastperiod--> ' + appListForLastperiod.size());
					}
					else if(periodvalue == 'Custom'){
						query += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND createdDate >= '+formattedFROMDate +' AND createdDate <= '+ formattedTODate;
						appList = Database.query(query);
						queryForLastPeriod += whereClause + ') AND Active__c = true AND Branch_Code__c ='+'\''+branch+'\''+ ' AND RecordType.DeveloperName = '+'\''+appRecType+'\''+' AND CreatedDate >= '+formattedFROMDateLastPeriod +' AND createdDate <= '+ formattedTODateLastPeriod;
						appListForLastperiod = Database.query(queryForLastPeriod);
						System.debug('query--> ' + query);
						System.debug('queryForLastPeriod--> ' + queryForLastPeriod);
						System.debug('appList--> ' + appList.size());
						System.debug('appListForLastperiod--> ' + appListForLastperiod.size());
					}
                    
                    /********** For Selected Period **********/
                    
                    if(!appList.isEmpty() ){
                    	wrapObj.bucketName 	= parentMDTObj.Bucket_Category__c;
                    	wrapObj.count 		= appList.size();
                    	if(wrapObj.bucketName=='Disbursed' || wrapObj.bucketName=='Total' || wrapObj.bucketName=='Sanctioned'){
                    		if(appRecType == 'SME_Enhancement'){
                    			System.debug('Inside SME Enhancement');
                    			wrapObj.amount = getAmountByCountForSME_Enhancement(appList) ;
                    			System.debug('Amount--> ' + wrapObj.amount);
                    		}
                    		else{
                    			wrapObj.amount = getAmountByCount(appList,appRecType,wrapObj.bucketName) != null ? getAmountByCount(appList,appRecType,wrapObj.bucketName) : 0.0;
                    		}
                    	}
                    	else{
                    		wrapObj.amount = 0.0;
                    	}
                    	MISReportWrapList.add(wrapObj);
                    }else{
						wrapObj.bucketName = parentMDTObj.Bucket_Category__c;
						wrapObj.count      = 0;
						wrapObj.amount 	   = 0.0;
						MISReportWrapList.add(wrapObj);
					}
                    
                    /****** For Last Period of Selected Period ******/
                    
                    if(!appListForLastperiod.isEmpty()){
                    	wrapObj2.bucketName 	= parentMDTObj.Bucket_Category__c;
                    	wrapObj2.count			= appListForLastperiod.size();                    	
                    	if(wrapObj2.bucketName=='Disbursed' || wrapObj2.bucketName=='Total' || wrapObj2.bucketName=='Sanctioned' ){
                    		if(appRecType == 'SME_Enhancement'){
                    			wrapObj2.amount = getAmountByCountForSME_Enhancement(appList) ;
                    		}
                    		else{
                    			wrapObj2.amount = getAmountByCount(appList,appRecType,wrapObj.bucketName) != null ? getAmountByCount(appList,appRecType,wrapObj.bucketName) : 0.0;
                    		}
                    	}
                    	else{
                    		wrapObj2.amount = 0.0;
                    	}
                    	MISReportWrapListLast.add(wrapObj2);
                    }else{
						wrapObj2.bucketName = parentMDTObj.Bucket_Category__c;
						wrapObj2.count      = 0;
						wrapObj2.amount 	= 0.0;
						MISReportWrapListLast.add(wrapObj2);
					}
                    
                }
            }
            System.debug('@@@ MISReportWrapList'+MISReportWrapList);
            System.debug('@@@ MISReportWrapListLast'+MISReportWrapListLast);
            return new Map<String,List<MISReportWrapper>>{'CURRENT'=>MISReportWrapList,'LAST'=>MISReportWrapListLast};    
        }catch(Exception e){
        	HandleBusinessException.captureError('StandardReportController', 'getBuckettedRecords', e);
            return null;
        }
    }

    public static Decimal getAmountByCount(List<genesis__Applications__c> applist,String applnRecType,String bucketCategory){
	  	try{
	  		System.debug('@@@@@@ applnRecType-- '+applnRecType);
	  		System.debug('@@@@@@ bucketCategory-- '+bucketCategory);
			Decimal finalAmount = 0.0;
		   
			Amount_Calculation__mdt reportAmountMDTList = [SELECT Bucket_Name__c,Field_To_Aggregate__c,Source_Object_Name__c,RecordType__c FROM Amount_Calculation__mdt WHERE RecordType__c =: applnRecType AND Bucket_Name__c =: bucketCategory LIMIT 1];
		    if(! applist.isEmpty()){
				for(genesis__Applications__c appObj : applist){
					if(reportAmountMDTList.Source_Object_Name__c == 'Application'){

						if( appObj.genesis__Loan_Amount__c != null){

								System.debug('@@->> '+ appObj.genesis__Loan_Amount__c);
								finalAmount += appObj.genesis__Loan_Amount__c;
						}
						
					}
					else if(reportAmountMDTList.Source_Object_Name__c == 'Facility'){
						if((appObj.Facilities__r).size()>0)
						for(Facility__c fac:appObj.Facilities__r){
							if( fac.Recommended_Limit__c != null)
							finalAmount += fac.Recommended_Limit__c;
						}
					}
				}
		    }
			finalAmount = (finalAmount/10000000).setScale(2);
			System.debug('#####'+finalAmount);
			return finalAmount;
		}
		catch(Exception e){
			HandleBusinessException.captureError('StandardReportController', 'getAmountByCount', e);
			return null;
		}
 	}

 	public static Decimal getAmountByCountForSME_Enhancement(List<genesis__Applications__c> applist){
		try{
			Decimal totalAmount = 0.0;
			Decimal totalRecLimit = 0.0;
			Decimal totalExistingLimit = 0.0;
			if(! applist.isEmpty()){
				for(genesis__Applications__c appRec : applist){
					if(! (appRec.Facilities__r).isEmpty()){
						for(Facility__c facRec : appRec.Facilities__r){
							if(facRec.Recommended_Limit__c != null){
								totalRecLimit += facRec.Recommended_Limit__c;
							}
							if(facRec.Existing_Limit__c != null){
								totalExistingLimit += facRec.Existing_Limit__c;
							}
							if((totalRecLimit - totalExistingLimit) < 0 ){
								totalAmount = totalAmount;
								System.debug('totalAmount1--> ' + totalAmount);
							}
							else{
								totalAmount = totalRecLimit;
								System.debug('totalAmount2--> ' + totalAmount);
							}
						}
					}
				}
			}	
			totalAmount = (totalAmount/10000000).setScale(2);
			System.debug('totalAmount3--> ' + totalAmount);
			return totalAmount;
		}catch(Exception e){
			HandleBusinessException.captureError('StandardReportController', 'getAmountByCountForSME_Enhancement', e);
			return 0.0;
		}
	}

    public static DateTime getFormattedDateTime(String dateTimeValue){
        try{
            Map <String, Integer> monthNames = new Map <String, Integer> {'Jan'=>1, 'Feb'=>2, 'Mar'=>3, 'Apr'=>4, 'May'=>5, 'Jun'=>6, 'Jul'=>7, 'Aug'=>8, 'Sep'=>9, 'Oct'=>10, 'Nov'=>11, 'Dec'=>12};
            DateTime dateTimeToReturn;
            if(dateTimeValue != null && dateTimeValue !=''){
                List<String> dateComponents = dateTimeValue.split(' ');
                List<String> timeComponents = dateComponents[4].split(':');
                dateTimeToReturn = DateTime.newInstanceGmt(Integer.valueOf(dateComponents[3]), monthNames.get(dateComponents[1]), Integer.valueOf(dateComponents[2]), Integer.valueOf(timeComponents[0]), Integer.valueOf(timeComponents[1]), Integer.valueOf(timeComponents[2]));
            }
            return dateTimeToReturn;
        }catch(Exception e){
            HandleBusinessException.captureError('StandardReportController', 'getFormattedDate', e);
            return null;
        }
    }

    public static DateTime getFormattedDateTimeForCustomLastPeriod(String dateTimeValue){
        try{
            Map <String, Integer> monthNames = new Map <String, Integer> {'Jan'=>1, 'Feb'=>2, 'Mar'=>3, 'Apr'=>4, 'May'=>5, 'Jun'=>6, 'Jul'=>7, 'Aug'=>8, 'Sep'=>9, 'Oct'=>10, 'Nov'=>11, 'Dec'=>12};
            DateTime dateTimeToReturnLastPeriod;
            if(dateTimeValue != null && dateTimeValue !=''){
                List<String> dateComponents = dateTimeValue.split(' ');
                List<String> timeComponents = dateComponents[4].split(':');
                dateTimeToReturnLastPeriod = DateTime.newInstanceGmt((Integer.valueOf(dateComponents[3]))-1, monthNames.get(dateComponents[1]), Integer.valueOf(dateComponents[2]), Integer.valueOf(timeComponents[0]), Integer.valueOf(timeComponents[1]), Integer.valueOf(timeComponents[2]));
            }
            return dateTimeToReturnLastPeriod;
        }catch(Exception e){
            HandleBusinessException.captureError('StandardReportController', 'getFormattedDate', e);
            return null;
        }
    }
    
    public class getRecordWrapper{        
        public String 			prodCat;
        public String 			period;
        public String 			branchName;
        public String 			fromDate;
        public String 			toDate;
        public String 			division;
    }
	
    //Final Wrapper passed from Page to Controller
    public class MISReportWrapper{
    	public String bucketName;
    	public Integer count;
    	public Decimal amount;
    }
    
    
}