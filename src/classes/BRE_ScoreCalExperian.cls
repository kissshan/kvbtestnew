public with sharing class BRE_ScoreCalExperian {

	public static Map<id,ints__TransUnion_Credit_Report__c> TUCreditReportMap;
	public static Map<id,TU_Account__c> TUAccountMap;
	public static List<Integer> RegExpScore = new List<Integer>{8,9,10};
	public static List<String> SecuredLoans = new List<String>{'Auto Loan (Personal)','Housing Loan','Property Loan','Loan against Shares/Security','Gold Loan','Leasing','Two-wheeler Loan','Loan Against Bank Deposits','Commercial Vehicle Loan','Secured Credit Card','Used Car Loan','Construction Equipment Loan','Tractor Loan','Kisan Credit Card','Microfinance – Other'};
	public static String AutoLoan = 'Auto Loan (Personal)';
	//Customer First Account holding
	public static List<String> HomeNPropLoan = new List<String>{'Housing Loan','Property Loan'};
	public static List<String> EduNCreditCard = new List<String>{'Education Loan','Credit Card','Secured Credit Card','Fleet Card'};
	public static List<String> CreditCards = new List<String>{'Credit Card','Secured Credit Card','Fleet Card'};
	
	public static String PersonalLoan = 'Personal Loan';
	public static Map<Datetime,List<String>> ListofDates;

	// Geo risk rankings
	public static Map<id,Pincode_Risk_Master__c> ListofPRM;
	//Maximum months on Bureau
	public static Date TodayDat= System.today();
	public static Decimal MaxBureauYears = 0.0;
	public static String MaxYears;
	//Months since customer bought last credit Card
	public static String CustLastCC = 'No Credit Card';
	public static Map<Datetime,String> ListofCCDates;
	public static List<Datetime> CCOpenDateList;
	public static Decimal CCMonths = 0.00;
	//Month since customer went last time delinquent (1+ DPD)
	public static Map<Id,List<AccountHistory__c>> ListofAccHistory;
	public static List<String> AssetClassificationList = new List<String>{'S','?','-1','U'};
	public static String AssetClsZero = '0'; 
	public static Map<id,Datetime> DelinquentList;
	public static List<Datetime> DelinquentDats;
	public static Integer DeliQMonths = 0;
	//Number of live accounts as of Current Month - Total live loans  
	public static Integer CountNoLiveAcc = 0;

	// BRE Variables
	public static long TotalLoanAmount = 0;
	public static String EmpType;
	public static String EmpCategory;
	public static List<Datetime> OpenDateList;
	public static String CustFirstAccHolding = '';
	public static String GeoRiskRank = '9-12'; //Default value is >> 9-12
	public static String DeliquntMonth = 'No delinquency';
	public static String NoOfLiveAcc = 'No Live Account';

	public static void ExpBreCal(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        try{
            for(genesis__Applications__c app : appList){ 
                system.debug('####PL Score Stage####'+app.Sub_Stage__c);
                if(oldList.get(app.Id).sub_stage__c <> app.Sub_Stage__c && app.Sub_Stage__c =='Loan Requirement Captured' && app.Record_Type_Name__c == Constants.PERSONALLOAN){//v1.1                    
                    BRE_ScoreCalExp(app,'LRC');
                }                
            }
        }catch(Exception e){
        	system.debug('Error@@@@@'+e.getLineNumber()+'WRONG Path#####'+e.getMessage());
	        HandleBusinessException.captureError('BRE_ScoreCalExperian','ExpBreCal', e);
        }
    }

	public static void BRE_ScoreCalExp(genesis__Applications__c UpdateApp,String Appstage){
		try {
			//genesis__Applications__c UpdateApp = app;//new genesis__Applications__c();
			//UpdateApp.id = app.id;
			System.debug(' UpdateApp.genesis__Account__r.id>>> ' + UpdateApp.genesis__Account__c);
			// All DDL operations
			TUCreditReportMap = new Map<id,ints__TransUnion_Credit_Report__c>([Select id,Account__c,Application__c from ints__TransUnion_Credit_Report__c WHERE Account__c =: UpdateApp.genesis__Account__c AND Application__c =:UpdateApp.id order by CreatedDate desc limit 1]);	
            System.debug('**TUCreditReportMap'+TUCreditReportMap);
			TUAccountMap = new Map<id,TU_Account__c>([Select id,Name,Date_Closed__c,High_Credit_Or_Sanctioned_Amount__c,Account_Type__c,Date_Opened_Or_Disbursed__c,(Select id,AssetClassification__c,Year__c,Month__c,DaysPastDue__c,TUAccount__c from Account_Histories__r) from TU_Account__c WHERE TU_Credit_Report__r.id =:TUCreditReportMap.keySet()]);
			System.debug('check'+TUAccountMap);
            
			List<genesis__Application_Parties__c> PartyList = [Select Id,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.PersonMailingPostalCode,Employment_Cat__c,Approved_NMI_From_ITR__c,Agriculture2__c,Perfios_Captured__c,age__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,Net_Monthly_Income__c,Total_Annual_other_Income_Claimed__c,CIBIL_Scores__c,Average_Balances_6_months__c,Total_ChequeECS_bounces__c,Employment_Types__c,genesis__Party_Account_Name__r.Company_Name__c,Additional_Income_Amount1__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c From genesis__Application_Parties__c Where genesis__Application__c =: UpdateApp.Id AND Active__c =: True AND Financial_Applicant__c =: True AND genesis__Party_Type__c=: Constants.PRIMARY_APP];
			OpenDateList = new List<Datetime>();
			ListofDates = new Map<Datetime,List<String>>();
			DelinquentList =  new Map<id,Datetime>();
			DelinquentDats = new List<Datetime>();
			ListofCCDates = new Map<Datetime,String>();
			CCOpenDateList = new List<Datetime>();
			//last time delinquent (1+ DPD)
			ListofAccHistory = new Map<id,List<AccountHistory__c>>();//([Select id,AssetClassification__c,DaysPastDue__c,TUAccount__c from AccountHistory__c Where TUAccount__c =:TUAccountMap.keySet()]);
			
			
			for(ID Tuid:TUAccountMap.keySet()){
				System.debug('Tuid >>> ' + Tuid);
				//Total Loan Amount on live secured Product
				if( (TUAccountMap.get(Tuid).Date_Closed__c == null || TUAccountMap.get(Tuid).Date_Closed__c == '') && SecuredLoans.contains(TUAccountMap.get(Tuid).Account_Type__c)){
					TotalLoanAmount+= long.valueOf(TUAccountMap.get(Tuid).High_Credit_Or_Sanctioned_Amount__c != null ? TUAccountMap.get(Tuid).High_Credit_Or_Sanctioned_Amount__c : '0');
					System.debug('TotalLoanAmount >>> ' + TotalLoanAmount);
					}

				//Customer First Account holding
				if(TUAccountMap.get(Tuid).Date_Opened_Or_Disbursed__c != null && (TUAccountMap.get(Tuid).Account_Type__c != null || TUAccountMap.get(Tuid).Account_Type__c != '')){

					Integer myIntDate = integer.valueOf(TUAccountMap.get(Tuid).Date_Opened_Or_Disbursed__c.substring(0,2));
					Integer myIntMonth = integer.valueOf(TUAccountMap.get(Tuid).Date_Opened_Or_Disbursed__c.substring(2,4));
		    		Integer myIntYear = integer.valueOf(TUAccountMap.get(Tuid).Date_Opened_Or_Disbursed__c.substring(4,8));
		    		
		    		if (ListofDates.containsKey(Date.newInstance(myIntYear, myIntMonth, myIntDate))) {
		    			ListofDates.get(Date.newInstance(myIntYear, myIntMonth, myIntDate)).add(TUAccountMap.get(Tuid).Account_Type__c);
		    		}else {
		    			ListofDates.put(Date.newInstance(myIntYear, myIntMonth, myIntDate),new List<String>{TUAccountMap.get(Tuid).Account_Type__c});
		    		}
		    		
		    		//OpenDateList.add(Date.newInstance(myIntYear, myIntMonth, myIntDate));
		    		
		    		//Months since customer bought last credit Card
		    		if(CreditCards.contains(TUAccountMap.get(Tuid).Account_Type__c) && TUAccountMap.get(Tuid).Account_Type__c != null){
		    			System.debug('null check Tuid >>> ' + Tuid);
		    			System.debug('null check TUAccountMap >>> ' + TUAccountMap.get(Tuid).Account_Type__c);
		    			ListofCCDates.put(Date.newInstance(myIntYear, myIntMonth, myIntDate), TUAccountMap.get(Tuid).Account_Type__c);
		    		} 
		    		System.debug('Inside TUAccountMap >>> ' + ListofCCDates);
				}

				//Month since customer went last time delinquent (1+ DPD) - Map creation
				if(TUAccountMap.get(Tuid).Account_Histories__r <> null){
					System.debug('TUAccountMap.get(Tuid).Account_Histories__r >>> ' + TUAccountMap.get(Tuid).Account_Histories__r);
					ListofAccHistory.put(Tuid,TUAccountMap.get(Tuid).Account_Histories__r);
					System.debug('ListofAccHistory.size() >>> ' + ListofAccHistory.size());
				}
				//Counts No of live accounts
				if(TUAccountMap.get(Tuid).Date_Closed__c == null || TUAccountMap.get(Tuid).Date_Closed__c == ''){
					CountNoLiveAcc ++;
				}
			}
			System.debug('TotalLoanAmount >>> ' + TotalLoanAmount);
			System.debug('CountNoLiveAcc >>> ' + CountNoLiveAcc);
			String EmpCats = '';
			String RiskPinCode = '';
			for(genesis__Application_Parties__c parts: PartyList){
				EmpType = parts.Employment_Types__c;
				EmpCats = parts.Employment_Cat__c;
				RiskPinCode = parts.genesis__Party_Account_Name__r.PersonMailingPostalCode;
			}

			// Geo Risk
			ListofPRM = new Map<id,Pincode_Risk_Master__c>([Select id,Pincode__c,Thick_Rank__c,Thin_Rank__c from Pincode_Risk_Master__c Where Pincode__c =: RiskPinCode]);
			// END of DDL
			System.debug('ListofPRM >>> ' + ListofPRM);
			
			EmpType = EmpType != null ? EmpType == 'Salaried' ? EmpType : 'Others' : '';

			if(EmpType != '' && EmpType == 'Salaried'){
				//List<CompanyMaster__c> EmpCats =  [Select CompanyCat__c from CompanyMaster__c Where CompanyName__c =: app.genesis__Account__r.Company_Name__c limit 1];
				//if(EmpCats != null || EmpCats != ''){
					EmpCategory = EmpCats != null ? EmpCats == 'CAT A' ? 'Salary Cat A' : EmpCats == 'CAT B' ? 'Salary Cat B/C' : 'Salary Cat B/C' : 'Salary Cat No CAT';
				//}else{
				//	EmpCategory = 'Salary Cat No CAT';
				//}
			}else if(EmpType != '' && EmpType != 'Salaried'){
				EmpCategory = 'Others';
			}
			

			//EmpCategory = EmpType != null ? EmpType == 'Salaried' ? [Select CompanyCat__c from CompanyMaster__c Where CompanyName__c =: genesis__Party_Account_Name__r.Company_Name__c limit 1]; :  :

			// Get older Accounts from experian - Customer First Account holding
			Map<String,String> vallist= new Map<String,String>();
			OpenDateList.addAll(ListofDates.keySet());
			OpenDateList.sort();
			if(OpenDateList.size() > 0 && ListofDates.size() > 0){
				
				if(ListofDates.get(OpenDateList[0]).contains('Credit Card')) CustFirstAccHolding = 'Credit Card';
				else if(ListofDates.get(OpenDateList[0]).contains('Education Loan') && CustFirstAccHolding =='') CustFirstAccHolding = 'Education Loan';
				else if(ListofDates.get(OpenDateList[0]).contains('Housing Loan') && CustFirstAccHolding =='') CustFirstAccHolding = 'Housing Loan';
				else if(ListofDates.get(OpenDateList[0]).contains('Property Loan') && CustFirstAccHolding =='') CustFirstAccHolding = 'Property Loan';
				else if(ListofDates.get(OpenDateList[0]).contains(AutoLoan) && CustFirstAccHolding =='') CustFirstAccHolding = 'Auto Loan (Personal)';
				else if(ListofDates.get(OpenDateList[0]).contains('Personal Loan') && CustFirstAccHolding =='') CustFirstAccHolding = 'Personal Loan';
				else CustFirstAccHolding = ListofDates.get(OpenDateList[0])[0];
				//BKP>> CustFirstAccHolding = ListofDates.get(OpenDateList[0])[0]; // Need to give priority of Acc Type if List size >1 else same Acc type assign
				
				System.debug('After Sorting Account Type  & priority>>' +CustFirstAccHolding);
				
				CustFirstAccHolding = HomeNPropLoan.contains(CustFirstAccHolding) ? 'Home Loan or Property Loan' : EduNCreditCard.contains(CustFirstAccHolding) ? 'Education Loan or Credit Card' : (CustFirstAccHolding == AutoLoan || CustFirstAccHolding == PersonalLoan) ? CustFirstAccHolding :'Anything else';
				System.debug('Final Account types >>> ' + CustFirstAccHolding);
			}


			// Geo Risk Rankings
			if(ListofPRM.values().size() > 0){
				GeoRiskRank = ListofPRM.values()[0].Thick_Rank__c;
			}

			//Maximum months on Bureau
			if(OpenDateList.size() > 0){

				MaxBureauYears = (Date.valueOf(OpenDateList[0]).daysBetween(System.today())/365.2425);

				/* BKP No need--> MaxYears = MaxBureauYears < 1 ? 'Less than 1 Year' : (1 < MaxBureauYears && MaxBureauYears < 2) ? '1-2 Years' : (2 < MaxBureauYears && MaxBureauYears < 3) ? '2-3 Years' : (3 < MaxBureauYears && MaxBureauYears < 5) ? '3-5 Years' : (5 < MaxBureauYears && MaxBureauYears < 9) ? '5-9 Years' : 'Greater than 9 Years';*/
			}

			//Months since customer bought last credit Card
			if(ListofCCDates.size() > 0){
				CCOpenDateList.addAll(ListofCCDates.keySet());
				CCOpenDateList.sort();
				CCMonths = ((Date.valueOf(CCOpenDateList.get(CCOpenDateList.size()-1)).daysBetween(System.today()))/30.4).Round(System.RoundingMode.CEILING); // Considering 0.1 as 1 	

			//For integer>> CCMonths = Date.valueOf(CCOpenDateList.get(CCOpenDateList.size()-1)).monthsBetween(System.today());
				
			// Only for Integer >> if(System.today().day() > Date.valueOf(CCOpenDateList.get(CCOpenDateList.size()-1)).day()) CCMonths++;
			
			// Extra backup code	
				//CustLastCC = (0< CCMonths <6) ?'0-6 Month': (7< CCMonths <12) ? '7-12 Month' : (12< CCMonths <24)?'12-24 Month':(CCMonths > 24) ? '24+ Months' : CustLastCC;
			}

			//Month since customer went last time delinquent (1+ DPD)
			for(ID AhId: ListofAccHistory.keySet()){
					for(AccountHistory__c AccH : ListofAccHistory.get(AhId)){
						integer Skips = 0;
						if(!AssetClassificationList.contains(AccH.AssetClassification__c)){
							if(AccH.AssetClassification__c == AssetClsZero && AccH.DaysPastDue__c <> '0'){
							DelinquentDats.add(Date.newInstance(Integer.valueOf(AccH.Year__c),Integer.valueOf(AccH.Month__c),01));
								Skips++;
							}else{	Skips = 0; }

							if(Skips == 0){DelinquentDats.add(Date.newInstance(Integer.valueOf(AccH.Year__c),Integer.valueOf(AccH.Month__c), 01));}
						}
					}	
				}
				//Sorting all deliquents dates
			if(DelinquentDats.size() > 0){
				DelinquentDats.sort();
				DeliQMonths = Date.valueOf(DelinquentDats[DelinquentDats.size()-1]).monthsBetween(System.today());
				System.debug('DeliQMonths >>> ' + DeliQMonths);
				if(System.today().day() > Date.valueOf(DelinquentDats[DelinquentDats.size()-1]).day()) DeliQMonths++;
			}
				//DeliquntMonth = (1< DeliQMonths <2) ? '1-2 Months': (3< DeliQMonths <6) ? '3-6 Months' : (7< DeliQMonths <24) ? '7-24 Months':( DeliQMonths >24) ? '24+ Months' : DeliquntMonth;
				System.debug('DeliQMonths outers >>> ' + DeliQMonths);
				//Number of live accounts as of Current Month
				/*if(CountNoLiveAcc != null){
					if(1 =< CountNoLiveAcc && CountNoLiveAcc =< 3) NoOfLiveAcc = '1-3 Live Accounts';
					else if(3 =< CountNoLiveAcc && CountNoLiveAcc =<5) NoOfLiveAcc = '3-5 Live Accounts';
					else if(5 < CountNoLiveAcc) NoOfLiveAcc = '5+ Live Accounts';
				}*/ 
				// PB Handle
				if(Appstage != 'VEPL' && Appstage != 'LRC'){
                    UpdateApp.Retail_BRE_Hit__c = UpdateApp.Retail_BRE_Hit__c != null ? UpdateApp.Retail_BRE_Hit__c == 1 ? 2 : UpdateApp.Retail_BRE_Hit__c == 2 ?  3 : UpdateApp.Retail_BRE_Hit__c :1;
                    system.debug('##>>>>>Not VerifyElig##'+UpdateApp.Retail_BRE_Hit__c);
                }
				//Update application with final BRE values
				UpdateApp.Weighted_Average_Income__c = TotalLoanAmount;
				UpdateApp.Employment_Type__c = EmpCategory;
				UpdateApp.Valuers_Name__c = CustFirstAccHolding;
				UpdateApp.Lawyer_name__c = GeoRiskRank;
				UpdateApp.BankYear__c = MaxBureauYears;
				UpdateApp.Holiday_Max__c = CCMonths;
				UpdateApp.Composition_of_Income__c = DeliQMonths;
				UpdateApp.No_Of_Joint_Holder__c = CountNoLiveAcc;

				if(Appstage != 'LRC'){
					update UpdateApp;
				}
		
			}catch(Exception e){
	            system.debug('Error@@@@@'+e.getLineNumber()+'WRONG Path#####'+e.getMessage());
	            system.debug('Error@@@@@'+e.getStackTraceString());
	            HandleBusinessException.captureError('BRE_ScoreCalExperian','BRE_ScoreCalExp', e);
	    	}
	}
}