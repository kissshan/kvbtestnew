/*
* Name    : ThirdParty_BREScoreCal
* Company : ET Marlabs
* Purpose : This class is used to calculate BRE computation variables values for third party
* Author  : Bhavya
*******************************************************************************************/ 
public class ThirdParty_BREScoreCal {
   
    public static void Calculate_Bre(genesis__Applications__c app){
        try{            
            if(app.Record_Type_Name__c == 'Home Loan' || app.Record_Type_Name__c == 'LAP'|| app.Record_Type_Name__c == Constants.VL2W || app.Record_Type_Name__c == Constants.VL4W){ 
                Decimal AdditionalIncome =0.00;
                Decimal NetSalary = 0.00;           
                List<Integer> ageList = new List<Integer>();
                Integer Maxage = 0;
                Decimal weightedAvg = 0.00;
                Decimal WeightedAge = 0.00;
                Decimal NmiApproved = 0;
                Decimal TotalNMIClaimed = 0;
                Decimal NMIClaimed = 0;
                Decimal EMICASA = 0.00;
                Decimal EMI = 0;
                Decimal CASAValue = 0.00;
                Decimal CheckBounce = 0.00;
                Decimal totalAdditionalClaim = 0;
                String Category = '';
                List <Integer> BankYearList = new List<Integer>(); //For VL
                Integer MaxBankWithUS = 0; //For VL

                List<genesis__Application_Parties__c> PartyList = [Select Id,genesis__Party_Account_Name__c,Approved_NMI_From_ITR__c,Agriculture2__c,Perfios_Captured__c,age__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,Net_Monthly_Income__c,Total_Annual_other_Income_Claimed__c,CIBIL_Scores__c,Average_Balances_6_months__c,Total_ChequeECS_bounces__c,Employment_Types__c,Additional_Income_Amount1__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c From genesis__Application_Parties__c Where genesis__Application__c =: app.Id AND Active__c =: True AND Financial_Applicant__c =: True AND (genesis__Party_Type__c =: WS_Vendor_Constants.PRIMARY_APP OR genesis__Party_Type__c=: WS_Vendor_Constants.CO_BORROWER)];
                Map<String,String> EmpType = new Map<String,String>();
                Map<Decimal,String> maxNmi = new Map<Decimal,String>();
                List<Decimal> NMICust = new List<Decimal>();
                for(genesis__Application_Parties__c acc : PartyList){ 

                    //To calculate composition of income            
                    if(acc.Total_Annual_other_Income_Claimed__c<>null){
                        AdditionalIncome = AdditionalIncome + acc.Total_Annual_other_Income_Claimed__c; 
                        NetSalary = NetSalary + acc.NMI_Claimed_By_Customer__c;
                    }//
                   
                    if(acc.Employment_Types__c == 'Agriculturist' && (app.Record_Type_Name__c != Constants.VL4W && app.Record_Type_Name__c != Constants.VL2W)){
                        //first val calculation
                        TotalNMIClaimed =TotalNMIClaimed + (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                        NMIClaimed = (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);                    
                        totalAdditionalClaim = totalAdditionalClaim + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                    }
                    else if(acc.Employment_Types__c != 'Agriculturist' && (app.Record_Type_Name__c != Constants.VL4W && app.Record_Type_Name__c != Constants.VL2W)){
                        //first val calculation
                        Decimal minVal = Math.min((acc.Additional_Income_Amount1__c !=null ? acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 :0),(((acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0)/0.7)*0.3));       
                        totalAdditionalClaim = totalAdditionalClaim + Math.min(minVal,200000/12);
                        TotalNMIClaimed = TotalNMIClaimed + (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12);
                        NMIClaimed = (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12);                   
                    } 
                    //VL
                    if((acc.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c != null )&& (app.Record_Type_Name__c == Constants.VL4W || app.Record_Type_Name__c == Constants.VL2W)){
                        Decimal YearCount = 0.00;
                        YearCount =( (acc.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c.daysBetween(System.today()))/365.2425);
                        System.debug('object YearCount>>> ' + YearCount);
                        BankYearList.add(Integer.valueOf(YearCount.round(System.RoundingMode.HALF_UP)));
                    }
                    if((acc.Employment_Types__c == Constants.EMPTYP_AGRICULTUR || acc.Employment_Types__c == Constants.EMPTYP_SELFEMPB) && (app.Record_Type_Name__c == Constants.VL4W || app.Record_Type_Name__c == Constants.VL2W) ){
                        TotalNMIClaimed =TotalNMIClaimed + (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                        NMIClaimed = (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                        totalAdditionalClaim = totalAdditionalClaim + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                    }
                    else if((acc.Employment_Types__c != Constants.EMPTYP_AGRICULTUR && acc.Employment_Types__c != Constants.EMPTYP_SELFEMPB) && (app.Record_Type_Name__c == Constants.VL4W || app.Record_Type_Name__c == Constants.VL2W)){
                        Decimal minVal = Math.min((acc.Additional_Income_Amount1__c !=null ? acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 :0),(((acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0)/0.7)*0.3));
                        totalAdditionalClaim = totalAdditionalClaim + Math.min(minVal,200000/12);
                        TotalNMIClaimed = TotalNMIClaimed + (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12);
                        NMIClaimed = (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12);
                    }
                    //VL ends
                    //To calculate max age
                    if(acc.age__c<>null){
                        Decimal age = acc.age__c;
                        ageList.add(Integer.ValueOf(age));
                    }

                    WeightedAge = WeightedAge + (acc.age__c * NMIClaimed); // To calculate weighted income
                    
                    // To populate employment type 
                    EmpType.put(acc.Id,acc.Employment_Types__c);                        
                    Decimal NMIC = NMIClaimed;
                    maxNmi.put(NMIC,acc.Id);
                    NMICust.add(NMIC);
                    
                    CASAValue = CASAValue + (acc.Average_Balances_6_months__c != null ? acc.Average_Balances_6_months__c : 0); //To calculate EMI/CASA
                    CheckBounce = CheckBounce + (acc.Total_ChequeECS_bounces__c != null ? acc.Total_ChequeECS_bounces__c : 0); //To calculate total cheque bounces              
               
                    system.debug('acc.Net_Monthly_Income__c-->'+acc.Net_Monthly_Income__c);
                    system.debug('acc.Additional_Income_Amount1__c-->'+acc.Additional_Income_Amount1__c);
                }
                
                //Composition of Income
                app.NMI_Claimed_By_Customer__c = NetSalary;
                if(AdditionalIncome==0.00 && NetSalary <>0.00){
                    app.Composition_of_Income__c = 1; //ITR
                }
                else if(AdditionalIncome <>0.00 && NetSalary <>0.00){
                    app.Composition_of_Income__c = 2; //Additional and ITR
                }
                else if(AdditionalIncome <>0.00 && NetSalary == 0.00){
                    app.Composition_of_Income__c = 3; //Additional income
                }
                
                //Max Age
                ageList.sort();
                integer i = ageList.size()-1;
                Maxage = ageList[i];            
                app.Max_Age__c = Maxage + (app.Maturity_Time__c != null ? app.Maturity_Time__c : 0);

                //Weighted Average Income
                if(TotalNMIClaimed != null && TotalNMIClaimed != 0){
                    weightedAvg = (WeightedAge / TotalNMIClaimed); //Weighted Average income                
                }
                app.Weighted_Average_Income__c = weightedAvg.round();

                //EMI/CASA
                Decimal roi = (app.genesis__Interest_Rate__c/12)/100;
                Decimal ratePlusOne = 1 + roi;            
                Integer term = Integer.valueOf(app.genesis__Term__c);
                if(term != null && term != 0){
                    Decimal pow1 = ratePlusOne.pow(term);
                    system.debug('all variables-->'+roi+'-'+ratePlusOne+'-'+term+'-'+pow1);
                    app.genesis__Payment_Amount__c = ((app.genesis__Loan_Amount__c * roi * pow1)/(pow1-1)).round();             
                    system.debug('genesis__Payment_Amount__c-->'+app.genesis__Payment_Amount__c);
                    if(app.NMI_Claimed_By_Customer__c <>null && app.NMI_Claimed_By_Customer__c >0){
                        EMI = app.genesis__Payment_Amount__c != null ? app.genesis__Payment_Amount__c : 0;
                    }  
                }                            
                if(CASAValue != 0 && CASAValue != null){                   
                    EMICASA = (EMI/CASAValue) * 100;                    
                }
                
                if(EMICASA != null && EMICASA != 0){   
                    //app.Perfios_captured__c = true;             
                    app.EMICASA__c = (EMICASA);
                }

                //Total Cheque Bounces
                if(CheckBounce != null){
                    app.Total_Cheque_Bounces__c = CheckBounce;
                }
                               
                //Additional Income to total Income
                if(TotalNMIClaimed != 0 && TotalNMIClaimed != null){
                    app.Additional_Income_Total_Income__c = (totalAdditionalClaim/TotalNMIClaimed)*100;
                }

                //Property Type
                List<clcommon__Collateral__c> collateralList = [select Id,Scheme_Type__c,Collateral_Uses__c,Cost_of_Property__c,Collateral_Market_Value__c,clcommon__City__c,Residual_Life_of_Property__c,Age_Of_The_Building__c From clcommon__Collateral__c where genesis__Application__c =: app.Id AND Active__c =: true];
                integer r = 0;
                integer c = 0;
                Decimal Col_Value = 0;
                for(clcommon__Collateral__c col : collateralList){
                    if(col.Collateral_Uses__c =='Residential'){
                        r++;
                    }
                    if(col.Collateral_Uses__c =='Commercial'){
                        c++;
                    }
                    Col_Value = Col_Value + (col.Collateral_Market_Value__c != null ? col.Collateral_Market_Value__c : 0);               
                }
                if(collateralList.size() >0 && r > 0){
                    app.Property_Type_BRE__c = 'Residential';
                }else if(collateralList.size() == c){
                    app.Property_Type_BRE__c = 'Commercial';
                }
                
                //LTV 
                if(Col_Value != null && Col_Value != 0){
                    app.LTV__c = ((app.genesis__Loan_Amount__c != null ? app.genesis__Loan_Amount__c : 0)/Col_Value) * 100;
                }

                //Location Type
                if(collateralList.size()>0){
                    Category = ApplicationEligibiltyHandler.getRetailCatagory(collateralList);//RejectionScenarioHandeller.getBranchCity(app.Branch_Code__c,true);
                }    
                system.debug('Category'+Category);
                if(Category == 'A'){
                    app.Location_Type__c = 'Metro or Urban';
                }else if(Category == 'B' || Category == 'C'){
                    app.Location_Type__c = 'Others';
                }

                //Employment Type
                NMICust.sort();
                Integer Ncount = NMICust.size()-1;
                Decimal MaxNMIValue = NMICust[Ncount];
                System.debug('MaxNMIValue'+MaxNMIValue);
                String MaxNMIID = maxNmi.get(MaxNMIValue);
                String BreEmpType = '';
                if(MaxNMIID != null){
                    BreEmpType = EmpType.get(MaxNMIID);
                    System.debug('**BreEmpType'+BreEmpType);
                }
                if(BreEmpType != 'Self-Employed Businessman' && BreEmpType != 'Salaried'){
                    app.Employment_Type__c = 'Others';
                }else{
                    app.Employment_Type__c = BreEmpType;
                }  
                
                system.debug('TotalNMIClaimed-->'+TotalNMIClaimed);
                system.debug('EMI-->'+EMI);
                system.debug('NMICust-->'+NMICust);
                system.debug('BreEmpType-->'+BreEmpType);
                // #VL717 Vehicle loan employment type and bank year                        
                if(app.Record_Type_Name__c == Constants.VL4W || app.Record_Type_Name__c == Constants.VL2W){  
                    if(BankYearList.size() > 0){
                        BankYearList.sort();
                        Integer BnkCount = BankYearList.size()-1;
                        MaxBankWithUS = BankYearList[BnkCount];
                    }                                      
                    app.BankYear__c = MaxBankWithUS;             
                    if(BreEmpType !=Constants.EMPTYP_AGRICULTUR && BreEmpType !=Constants.EMPTYP_SELFEMPB){
                        app.Employment_Type__c = 'Others';
                    }
                    else {
                        app.Employment_Type__c = BreEmpType;
                    }                   
                }
                // VL End here 

                //check if perfios and avgCASAbal are null
                if((CASAValue == null || CASAValue == 0) && (app.Perfios_captured__c == true)){
                    app.Perfios_captured__c = false;
                }
                
               /* if(app.Record_Type_Name__c == 'LAP'){
                    app.Perfios_captured__c = true;
                }*/
            }
        }catch(Exception e){
            system.debug('Error@@@@@'+e.getLineNumber()+'WRONG Path#####'+e.getStackTraceString());
            system.debug('Error@@@@@'+e.getMessage());
            HandleBusinessException.captureError('ThirdParty_BREScoreCal','Calculate_Bre', e);
        }
    }   
}