/*
* Name    : BREScoreCal
* Company : ET Marlabs
* Purpose : This class is used to calculate BRE computation varibles value
* Author  : Subas
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
v1.1    22-Aug-2018    Braj          #VL717:Addition of record type VL2W and VL4W for Calculate_Bre()
v1.2    12-Dec-2018    Ashok           Remove Sub stage update from eligibility.
*******************************************************************************************/ 
public class BREScoreCal {
    
    public static string EmpTypeVL;
    
    public static void breCal(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        try{
            for(genesis__Applications__c app : appList){ 
                system.debug('####Stage####'+app.Sub_Stage__c);
                if(oldList.get(app.Id).sub_stage__c <> app.Sub_Stage__c && app.Sub_Stage__c =='Loan Requirement Captured' && (app.Record_Type_Name__c == 'Home Loan' || app.Record_Type_Name__c == 'LAP'|| app.Record_Type_Name__c == Constants.VL2W || app.Record_Type_Name__c == Constants.VL4W)){//v1.1                    
                    Calculate_Bre(app,null,null,null);
                }                
            }
        }catch(Exception e){}
    }
    public static void Calculate_Bre(genesis__Applications__c app, Decimal MaxLoanamt, Decimal EMIMAX, String Appstage){
        try{

            List <ID> AppIDList = new List<ID>();   
            String Coborrower = Constants.Co_Borrower;
            String PrimaryApp = Constants.PRIMARY_APP;         
            List<genesis__Application_Parties__c> PartyList = [Select Id,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,Approved_NMI_From_ITR__c,Agriculture2__c,Perfios_Captured__c,age__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,Net_Monthly_Income__c,Total_Annual_other_Income_Claimed__c,CIBIL_Scores__c,Average_Balances_6_months__c,Total_ChequeECS_bounces__c,Employment_Types__c,Additional_Income_Amount1__c From genesis__Application_Parties__c Where genesis__Application__c =: app.Id AND Active__c =: True AND Financial_Applicant__c =: True AND (genesis__Party_Type__c =: Coborrower OR genesis__Party_Type__c=: PrimaryApp)];
            for(genesis__Application_Parties__c pt : PartyList){
                AppIDList.add(pt.genesis__Party_Account_Name__c);                        
            }
            
            
            //List<Account> accList = [Select ID,Approved_NMI_From_ITR__c,Agriculture2__c,Perfios_Captured__c,age__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,Net_Monthly_Income__c,Total_Annual_other_Income_Claimed__c,CIBIL_Score__c,Average_Balances6_months__c,Total_ChequeECS_bounces__c,Employment_Type__c,Additional_Income_Amount1__c From Account Where ID IN: AppIDList AND Financial_Applicant__c =: True];
            // Re model structure chnages 
            //List<genesis__Application_Parties__c> PartyList = [Select ID,genesis__Party_Account_Name__c,Approved_NMI_From_ITR__c,Agriculture2__c,Perfios_Captured__c,age__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,Net_Monthly_Income__c,Total_Annual_other_Income_Claimed__c,CIBIL_Score__c,Average_Balances_6_months__c,Total_ChequeECS_bounces__c,Employment_Type__c,Additional_Income_Amount1__c From genesis__Application_Parties__c Where genesis__Party_Account_Name__c IN: AppIDList AND Financial_Applicant__c =: True];
            
            List <Integer> CibilList = new List<Integer>();
            List <Integer> BankYearList = new List<Integer>();
            Integer MaxCibil = 0;
            Integer cnt = 0;
            Decimal NetSalary = 0.00;
            Decimal EMINMI = 0;
            Decimal WeightedAge = 0.00;
            Decimal weightedAvg = 0.00;
            List<Integer> ageList = new List<Integer>();
            Integer Maxage = 0;
            Decimal AdditionalIncome =0.00;
            Decimal CASAValue = 0.00;
            Decimal CheckBounce = 0.00;
            Decimal EMICASA = 0.00;
            Decimal EMI = 0;
            Decimal TotalNMIClaimed = 0;
            Decimal NMIClaimed = 0;
            Decimal TotalNMIApproved = 0;
            Decimal NmiApproved = 0;
            Decimal totalAdditionalClaim = 0;
            Decimal totalAdditionalApprov = 0;
            String Category = '';
            Integer MaxBankWithUS = 0;
            String SelectedSchm;
            /**Code added for LAP**/
            //Property Type calculation
            List<clcommon__Collateral__c> collateralList = [select Id,Age_Of_The_Building__c,Scheme_Type__c,Collateral_Uses__c,Total_Market_value__c,Cost_of_Property__c,Collateral_Market_Value__c,clcommon__City__c,Residual_Life_of_Property__c From clcommon__Collateral__c where genesis__Application__c =: app.Id AND Active__c =: true];
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
                if(col.Collateral_Market_Value__c != null && col.Total_Market_value__c == 0){
                Col_Value = Col_Value + (col.Collateral_Market_Value__c != null ? col.Collateral_Market_Value__c : 0);
                }// Commented above on 2019-jan-11 discussed with shreya and kk sir.
                else{Col_Value = Col_Value + (col.Total_Market_value__c != null ? col.Total_Market_value__c : 0);
                }
                // VL Scheme Discount ROI 
                SelectedSchm = col.Scheme_Type__c != null ? col.Scheme_Type__c : '';
            }
            if(collateralList.size() >0 && r > 0){
                app.Property_Type_BRE__c = 'Residential';
            }else if(collateralList.size() == c){
                app.Property_Type_BRE__c = 'Commercial';
            }
            
            //LTV calculation
            if(Col_Value != null && Col_Value != 0){
                app.LTV__c = ((app.genesis__Loan_Amount__c != null ? app.genesis__Loan_Amount__c : 0)/Col_Value) * 100;
            }
            if(collateralList.size()>0){
                Category = ApplicationEligibiltyHandler.getRetailCatagory(collateralList);//RejectionScenarioHandeller.getBranchCity(app.Branch_Code__c,true);
            }    
            system.debug('Category'+Category);
            if(Category == 'A'){
                app.Location_Type__c = 'Metro or Urban';
            }else if(Category == 'B' || Category == 'C'){
                app.Location_Type__c = 'Others';
            }
            
            
            /**Code end for LAP**/
            List <Perfios__c> perfiosList = [Select Id,Cheque_Bounces__c,AvgBalance_Of_6_Months__c From Perfios__c Where Active__c =: true AND Applicant_Name__c IN: AppIDList AND Application__c =: App.Id];
            for(genesis__Application_Parties__c acc : PartyList){
                CASAValue = CASAValue + (acc.Average_Balances_6_months__c != null ? acc.Average_Balances_6_months__c : 0);
                CheckBounce = CheckBounce + (acc.Total_ChequeECS_bounces__c != null ? acc.Total_ChequeECS_bounces__c : 0);
            }
            for(Perfios__c per : perfiosList){
                //add CASA & Cheque bounse 
                if(CASAValue == 0){
                    CASAValue = CASAValue + (per.AvgBalance_Of_6_Months__c != null ? per.AvgBalance_Of_6_Months__c : 0);
                }  
                if(CheckBounce == 0){
                    CheckBounce = CheckBounce + (per.Cheque_Bounces__c != null ? per.Cheque_Bounces__c : 0);
                }                
            }            
            Map<Decimal,String> maxNmi = new Map<Decimal,String>();
            List<Decimal> NMICust = new List<Decimal>();
            Map<String,String> EmpType = new Map<String,String>();
            for(genesis__Application_Parties__c acc : PartyList){
                if(acc.CIBIL_Scores__c <> null){
                    CibilList.add(Integer.ValueOf(acc.CIBIL_Scores__c));
                }
                system.debug('%%%%%%'+acc.Net_Monthly_Income__c+'$$$$$$$'+acc.NMI_Approved__c);
                if(acc.age__c<>null){
                    Decimal age = acc.age__c;// + (app.Maturity_Time__c != null ? app.Maturity_Time__c : 0);
                    ageList.add(Integer.ValueOf(age));
                }
                if(acc.Total_Annual_other_Income_Claimed__c<>null){
                    AdditionalIncome = AdditionalIncome + acc.Total_Annual_other_Income_Claimed__c; 
                }                                 
                
                if(acc.Employment_Types__c == 'Agriculturist' && (app.Record_Type_Name__c != Constants.VL4W && app.Record_Type_Name__c != Constants.VL2W)){
                    //first val calculation
                    TotalNMIClaimed =TotalNMIClaimed + (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                    NMIClaimed = (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                    //Rerun val calculation
                    NmiApproved = (acc.Approved_NMI_From_ITR__c != null ? acc.Approved_NMI_From_ITR__c : 0) + (acc.Agriculture2__c !=null ? acc.Agriculture2__c != 0 ? acc.Agriculture2__c/12 : 0 : 0);
                    TotalNMIApproved = TotalNMIApproved + NmiApproved;
                    totalAdditionalClaim = totalAdditionalClaim + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                }
                else if(acc.Employment_Types__c != 'Agriculturist' && (app.Record_Type_Name__c != Constants.VL4W && app.Record_Type_Name__c != Constants.VL2W)){
                    //first val calculation
                    Decimal minVal = Math.min((acc.Additional_Income_Amount1__c !=null ? acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 :0),(((acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0)/0.7)*0.3));
                    totalAdditionalClaim = totalAdditionalClaim + Math.min(minVal,200000/12);
                    TotalNMIClaimed = TotalNMIClaimed + (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12);
                    NMIClaimed = (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12);
                    //Rerun val calculation
                    Decimal minVal2 = Math.min((acc.Agriculture2__c !=null ? acc.Agriculture2__c != 0 ? acc.Agriculture2__c/12 : 0 :0),(((acc.Approved_NMI_From_ITR__c != null ? acc.Approved_NMI_From_ITR__c : 0)/0.7)*0.3));               
                    NmiApproved = (acc.Approved_NMI_From_ITR__c != null ? acc.Approved_NMI_From_ITR__c : 0) + Math.min(minVal2,200000/12);                    
                    TotalNMIApproved = TotalNMIApproved + NmiApproved;
                }
                System.debug('TotalNMIClaimed   '+TotalNMIClaimed+'NMIClaimed'+NMIClaimed);
                // #VL717 - Bre Calculation for Vehicle loan VL4W
                if((acc.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c != null )&& (app.Record_Type_Name__c == Constants.VL4W || app.Record_Type_Name__c == Constants.VL2W)){
                    Decimal YearCount = 0.00;
                    YearCount =( (acc.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c.daysBetween(System.today()))/365.2425);
                    System.debug('object YearCount>>> ' + YearCount);
                    BankYearList.add(Integer.valueOf(YearCount.round(System.RoundingMode.HALF_UP)));
                }
                if((acc.Employment_Types__c == Constants.EMPTYP_AGRICULTUR || acc.Employment_Types__c == Constants.EMPTYP_SELFEMPB) && (app.Record_Type_Name__c == Constants.VL4W || app.Record_Type_Name__c == Constants.VL2W) ){
                    //first val calculation
                    TotalNMIClaimed =TotalNMIClaimed + (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                    NMIClaimed = (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                    //Rerun val calculation
                    NmiApproved = (acc.Approved_NMI_From_ITR__c != null ? acc.Approved_NMI_From_ITR__c : 0) + (acc.Agriculture2__c !=null ? acc.Agriculture2__c != 0 ? acc.Agriculture2__c/12 : 0 : 0);
                    TotalNMIApproved = TotalNMIApproved + NmiApproved;
                    totalAdditionalClaim = totalAdditionalClaim + (acc.Additional_Income_Amount1__c != null ? (acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 ) : 0);
                }
                else if((acc.Employment_Types__c != Constants.EMPTYP_AGRICULTUR && acc.Employment_Types__c != Constants.EMPTYP_SELFEMPB) && (app.Record_Type_Name__c == Constants.VL4W || app.Record_Type_Name__c == Constants.VL2W)){
                    //first val calculationConstants
                    Decimal minVal = Math.min((acc.Additional_Income_Amount1__c !=null ? acc.Additional_Income_Amount1__c != 0 ? acc.Additional_Income_Amount1__c/12 : 0 :0),(((acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0)/0.7)*0.3));
                    totalAdditionalClaim = totalAdditionalClaim + Math.min(minVal,200000/12);
                    TotalNMIClaimed = TotalNMIClaimed + (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12);
                    NMIClaimed = (acc.Net_Monthly_Income__c != null ? acc.Net_Monthly_Income__c : 0) + Math.min(minVal,200000/12);
                    //Rerun val calculation
                    Decimal minVal2 = Math.min((acc.Agriculture2__c !=null ? acc.Agriculture2__c != 0 ? acc.Agriculture2__c/12 : 0 :0),(((acc.Approved_NMI_From_ITR__c != null ? acc.Approved_NMI_From_ITR__c : 0)/0.7)*0.3));               
                    NmiApproved = (acc.Approved_NMI_From_ITR__c != null ? acc.Approved_NMI_From_ITR__c : 0) + Math.min(minVal2,200000/12);                    
                    TotalNMIApproved = TotalNMIApproved + NmiApproved;
                }
                // VL End here
                
                EmpType.put(acc.Id,acc.Employment_Types__c);
                if(MaxLoanamt == null && EMIMAX == null){
                    WeightedAge = WeightedAge + (acc.age__c * NMIClaimed);
                    Decimal NMIC = NMIClaimed;
                    maxNmi.put(NMIC,acc.Id);
                    NMICust.add(NMIC);
                }else{
                    WeightedAge = WeightedAge + (acc.age__c * NmiApproved);
                    Decimal NMIC = NmiApproved;
                    maxNmi.put(NMIC,acc.Id);
                    NMICust.add(NMIC);
                }
                
            } 
            system.debug('WeightedAge'+WeightedAge+'TotalNMIClaimed'+TotalNMIClaimed);
            NMICust.sort();
            system.debug('^^^^'+NMICust);
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
            
            // #VL717 Vehicle loan employment type
            
            if(app.Record_Type_Name__c == Constants.VL4W || app.Record_Type_Name__c == Constants.VL2W){
                
                NumberToWordConversion ntwc = new NumberToWordConversion();
                if(BankYearList.size() > 0){
                    BankYearList.sort();
                    Integer BnkCount = BankYearList.size()-1;
                    MaxBankWithUS = BankYearList[BnkCount];
                }
                // Need field to store max year with bank on application level
                System.debug('**MaxBankWithUS'+MaxBankWithUS);
                app.BankYear__c = MaxBankWithUS;
                System.debug('** before check***&&&'+BreEmpType);
                
                if(BreEmpType !=Constants.EMPTYP_AGRICULTUR && BreEmpType !=Constants.EMPTYP_SELFEMPB){
                    System.debug('** inside EMPTYP_AGRICULTUR');
                    app.Employment_Type__c = 'Others';
                }
                else {
                    System.debug('** inside other');
                    app.Employment_Type__c = BreEmpType;
                }
                EmpTypeVL = BreEmpType;
                if(MaxLoanamt != null)
                    app.Sanction_Amount_Words__c = ntwc.getNumberTOWordConvertion(Retry_Task_call.conversion(MaxLoanamt));
            }
            // VL End here
            
            if(TotalNMIClaimed != 0 && TotalNMIClaimed != null){
                app.Additional_Income_Total_Income__c = (totalAdditionalClaim/TotalNMIClaimed)*100;
            }
            
            //NetSalary = NetSalary + app.genesis__Account__r.Net_Monthly_Income__c; // Net Salary
            if(MaxLoanamt != null || EMIMAX != null){
                if(app.NMI_Approved__c <>null ){
                    NetSalary = app.NMI_Approved__c;
                    EMI = EMIMAX != null ? EMIMAX : 0;
                } 
            }else{
                if(app.NMI_Claimed_By_Customer__c <>null && app.NMI_Claimed_By_Customer__c >0){
                    NetSalary = app.NMI_Claimed_By_Customer__c;
                    EMI = app.genesis__Payment_Amount__c != null ? app.genesis__Payment_Amount__c : 0;
                }            
            }
            if(MaxLoanamt != null || EMIMAX != null){
                if(NetSalary <>null && NetSalary<>0){
                    if(EMIMAX != null){
                        EMINMI = (EMIMAX/NetSalary)*100; //EMI/NMI ratio
                    }else{
                        EMINMI = (app.genesis__Payment_Amount__c/NetSalary)*100; //EMI/NMI ratio
                    }                
                }            
            }else{
                if(NetSalary <>null && NetSalary<>0){
                    if(app.Sanctioned_EMI__c != null){
                        EMINMI = (app.Sanctioned_EMI__c/NetSalary)*100; //EMI/NMI ratio
                    }else{
                        EMINMI = (app.genesis__Payment_Amount__c/NetSalary)*100; //EMI/NMI ratio
                    }                
                }  
            }
            
            if(MaxLoanamt == null || EMIMAX == null){
                if(TotalNMIClaimed != null && TotalNMIClaimed != 0){
                    weightedAvg = (WeightedAge / TotalNMIClaimed); //Weighted Average income                
                }
            }else{
                if(TotalNMIApproved != null && TotalNMIApproved != 0){
                    weightedAvg = (WeightedAge / TotalNMIApproved); //Weighted Average income
                }
            }
            
            if(NetSalary<>null && NetSalary<>0){                
                if(CASAValue != 0 && CASAValue != null){
                    EMICASA = (EMI/CASAValue) * 100;                    
                }
            }
            if(CibilList.size() >0){
                System.debug('**CibilList'+CibilList);
                CibilList.sort();
                cnt = CibilList.size()-1;
                MaxCibil = CibilList[cnt];
                system.debug('@@'+MaxCibil);//External credit agency score(CIBIL)    
            }                                               
            
            ageList.sort();
            integer i = ageList.size()-1;
            Maxage = ageList[i];  //Max age of financial applicant        
            
            //Integer TotalRepayment = Integer.ValueOf(application.genesis__Term__c + application.Holiday_Period__c);  //Total Repayment period
            
            if(AdditionalIncome==0.00 && NetSalary <>0.00){
                app.Composition_of_Income__c = 1; //ITR
            }
            else if(AdditionalIncome <>0.00 && NetSalary <>0.00){
                app.Composition_of_Income__c = 2; //Additional and ITR
            }
            else if(AdditionalIncome <>0.00 && NetSalary == 0.00){
                app.Composition_of_Income__c = 3; //Additional income
            }
            system.debug('MaxCibil:-'+MaxCibil+'EMINMI:-'+EMINMI+'weightedAvg:-'+weightedAvg+'EMI/CASA:-'+EMICASA+'Net Salary'+NetSalary+'Maxage:-'+Maxage);
            if((EMINMI<>0 && EMINMI<>null)){                       
                app.EMINMI__c = EMINMI.round();
            }
            
            // Interest calculations by Venu added 1-7-18
            if((MaxLoanamt != null || EMIMAX != null) ||(MaxLoanamt == null || EMIMAX == null)){
                if(app.Record_Type_Name__c == Constants.LAPLOAN){   
                    system.debug('**Prod_ID**'+app.genesis__CL_Product__c);
                    List<clcommon__CL_Product__c> ProdList = [Select Id,Interest_Calculation_Method__c,Pre_Closure_Interest_Rate__c,Holiday_Period__c,MCLR_Type__c From clcommon__CL_Product__c Where Id =: app.genesis__CL_Product__c];
                    Integer mclrMonth = 0;
                    if(ProdList.size()>0){
                        if(ProdList[0].MCLR_Type__c =='One Year'){
                            mclrMonth = 365;
                        }else if(ProdList[0].MCLR_Type__c =='Six Month'){
                            mclrMonth = 180;
                        }else if(ProdList[0].MCLR_Type__c =='Three Month'){
                            mclrMonth = 90;
                        }else if(ProdList[0].MCLR_Type__c =='One Month'){
                            mclrMonth = 30;
                        }                        
                        App.PreClosure_Interest_Rate__c = ProdList[0].Pre_Closure_Interest_Rate__c;
                        App.Holiday_Period__c = ProdList[0].Holiday_Period__c;
                        App.genesis__Interest_Calculation_Method__c = ProdList[0].Interest_Calculation_Method__c;
                        App.MCLR_Type__c = ProdList[0].MCLR_Type__c;                        
                    }else{
                        mclrMonth = 365;
                    }                    
                    String retailCatagory = ApplicationEligibiltyHandler.getRetailCatagory(collateralList);
                    system.debug('****'+mclrMonth+'####'+retailCatagory);
                    if(!String.isBlank(retailCatagory)){
                        if(MaxCibil >=-1  && MaxCibil <= 10) {                                                
                            App.genesis__Interest_Rate__c=  getInterestRate(mclrMonth,retailCatagory,-1,'INT'); 
                            
                        }                
                        else if( MaxCibil>=650  &&  MaxCibil<700){
                            App.genesis__Interest_Rate__c =   getInterestRate(mclrMonth,retailCatagory,650,'INT'); 
                            
                        }
                        else if( MaxCibil>=700 &&  MaxCibil<750){
                            App.genesis__Interest_Rate__c=   getInterestRate(mclrMonth,retailCatagory,700,'INT');
                            
                        }
                        else if( MaxCibil>=750){                        
                            App.genesis__Interest_Rate__c=   getInterestRate(mclrMonth,retailCatagory,750,'INT');  
                            
                        }           
                        app.genesis__Margin__c = 100 - (app.LTV__c != null ? app.LTV__c : 0);
                        app.MCLR_Rate__c = getInterestRate(365,retailCatagory,0,'MCLR'); 
                        app.Interest_Variation__c = App.genesis__Interest_Rate__c - app.MCLR_Rate__c;
                        App.Excess_MCLR__c = App.genesis__Interest_Rate__c - app.MCLR_Rate__c;
                        system.debug('%%%%%'+App.genesis__Interest_Rate__c+'^^^^^^'+app.MCLR_Rate__c);
                    }
                }
                else if(app.Record_Type_Name__c == Constants.HOMELOAN){
                    IntRateCal IntCal=  HL_Intrate(app); 
                    App.genesis__Interest_Rate__c=    INTCal.IntRate ;
                    App.MCLR_Rate__c=  INTCal.MCLRRate;
                    App.Excess_MCLR__c= INTCal.Excess;
                    App.MCLR_Type__c= INTCal.MCLRType ;
                    App.Interest_Variation__c=  INTCal.IntVari ;
                }  
                // Vehicle Loan 4 wheeler Calculation
                else if(app.Record_Type_Name__c == Constants.VL4W){
                    
                    List<clcommon__CL_Product__c> ProdList = [Select Id,Interest_Calculation_Method__c,Pre_Closure_Interest_Rate__c,Penal_Interest__c,Holiday_Period__c,MCLR_Type__c From clcommon__CL_Product__c Where Id =: app.genesis__CL_Product__c];
                    Integer mclrMonth = 365;
                    Decimal ROI = 0.00;
                    Branch_Master__c BranchList=[select id,CODCCBRN__c,Retail_Category__c,NAMCCCITY__c from Branch_Master__c where CODCCBRN__c =:app.Branch_Code__c];
                    List<Scheme_Master__c> SelectedScheme =  [Select Id,Name,Scheme_Code__c,ProductType__c,Active_Flag__c,LTV_increase__c,Pricing_Discount__c,Processing_fee_discount__c from Scheme_Master__c Where ProductType__c=:Constants.VL4W and Scheme_Code__c=:SelectedSchm limit 1];
                    String retailCatagory = BranchList.Retail_Category__c;
                    
                    system.debug('****'+mclrMonth+'####'+retailCatagory);
                    
                    if(!String.isBlank(retailCatagory)){
                        if(MaxCibil >=-1  && MaxCibil <= 10 || MaxCibil==-1) {                                                
                            ROI=  getInterestRate(mclrMonth,retailCatagory,-1,'VLINT'); 
                            
                        }                
                        else if( MaxCibil>=650  &&  MaxCibil <700){
                            ROI =   getInterestRate(mclrMonth,retailCatagory,650,'VLINT'); 
                            
                        }
                        else if( MaxCibil>=700 &&  MaxCibil <750){
                            ROI=   getInterestRate(mclrMonth,retailCatagory,700,'VLINT');
                            
                        }
                        else if( MaxCibil>=750){                        
                          // VL Cibil >= 750 - only MCL rate need - no need excess rate.
                            ROI=getInterestRate(mclrMonth,retailCatagory,0,'MCLR');  
                        }           
                        if(SelectedScheme.size() > 0){
                            App.genesis__Interest_Rate__c= (ROI - SelectedScheme[0].Pricing_Discount__c);
                        }else{
                            App.genesis__Interest_Rate__c= ROI;
                        }
                        //app.genesis__Margin__c = 100 - (app.LTV__c != null ? app.LTV__c : 0);
                        app.MCLR_Rate__c = getInterestRate(365,retailCatagory,0,'MCLR'); 
                        app.Interest_Variation__c = App.genesis__Interest_Rate__c - app.MCLR_Rate__c;
                        app.Excess_MCLR__c = App.genesis__Interest_Rate__c - app.MCLR_Rate__c;
                        app.Preclosure_Charges__c =  ProdList[0].Pre_Closure_Interest_Rate__c;
                        app.Penal_Interest__c =  ProdList[0].Penal_Interest__c;
                        app.genesis__Interest_Calculation_Method__c = ProdList[0].Interest_Calculation_Method__c;
                        system.debug('%%%%%'+App.genesis__Interest_Rate__c+'^^^^^^'+app.MCLR_Rate__c);
                    }
                }else if(app.Record_Type_Name__c == Constants.VL2W){
                    
                    List<clcommon__CL_Product__c> ProdList = [Select Id,Interest_Calculation_Method__c,Pre_Closure_Interest_Rate__c,Penal_Interest__c,Holiday_Period__c,MCLR_Type__c From clcommon__CL_Product__c Where Id =: app.genesis__CL_Product__c];
                    
                    app.Preclosure_Charges__c = ProdList[0].Pre_Closure_Interest_Rate__c;
                    app.Penal_Interest__c = ProdList[0].Penal_Interest__c;
                    app.genesis__Interest_Calculation_Method__c = ProdList[0].Interest_Calculation_Method__c;
                    
                }//VL2W end here
            }
            app.Max_CIBIL_Score__c = MaxCibil;
            app.Weighted_Average_Income__c = weightedAvg.round();
            if(MaxLoanamt == null || EMIMAX == null){
                app.Max_Age__c = Maxage + (app.Maturity_Time__c != null ? app.Maturity_Time__c : 0);
            }            
            app.Reject_Scenario__c = '';
            /* if((app.AVG_Balance__c<>null && app.AVG_Balance__c>0) && (NetSalary<>null && NetSalary<>0)){
                //app.EMICASA__c = (NetSalary/app.AVG_Balance__c).round();                    
                //Total_Cheque_Bounces__c                                       
                } */
            if(EMICASA != null){                
                app.EMICASA__c = (EMICASA);
            }
            if(CheckBounce != null){
                app.Total_Cheque_Bounces__c = CheckBounce;
            }
            system.debug('@@@@'+app);
            //update app;
            if(MaxLoanamt != null || EMIMAX != null){
                system.debug('***MaxLoanamt***'+MaxLoanamt);
                if(app.Record_Type_Name__c==Constants.HOMELOAN || app.Record_Type_Name__c==Constants.LAPLOAN || app.Record_Type_Name__c==Constants.VL2W ||app.Record_Type_Name__c==Constants.VL4W){
                    //collateral structure changes--on 29-11-2018 
                    if(collateralList.size() >0 && collateralList[0].Age_Of_The_Building__c >= 30 && collateralList[0].Age_Of_The_Building__c <= 50 && collateralList[0].Residual_Life_of_Property__c != null && collateralList[0].Residual_Life_of_Property__c != 0){
                        //app.Sanctioned_Tenure__c = (app.Residual_Life_of_Property__c/1.5).round();
                        Decimal Term = ((collateralList[0].Residual_Life_of_Property__c/1.5).round());
                        if(integer.valueOf(Term) >= app.genesis__Term__c){
                            app.Sanctioned_Tenure__c = app.genesis__Term__c;
                        }
                        else{
                            app.Sanctioned_Tenure__c=integer.valueOf(Term);
                        }
                        app.Max_Age__c = Maxage + ((collateralList[0].Residual_Life_of_Property__c/1.5)/12);
                        
                    }else{
                        app.Sanctioned_Tenure__c = app.genesis__Term__c;  
                        app.Max_Age__c = Maxage + (app.genesis__Term__c/12);
                    }
                    decimal FinalGMRA=0.00;
                    system.debug('app.Is_GMRA_Policy_Selected__c'+app.Is_GMRA_Policy_Selected__c);
                    if(app.Record_Type_Name__c != Constants.VL2W && app.Record_Type_Name__c != Constants.VL4W &&  app.Is_GMRA_Policy_Selected__c){
                      FinalGMRA=GmraCal.Gmra1(app.id,MaxLoanamt,EMIMAX);
                    }
                    
                    app.Sanction_Authority_Limit__c = Retry_Task_call.conversion(MaxLoanamt) + FinalGMRA;
                    if(app.Record_Type_Name__c==Constants.LAPLOAN || (app.Record_Type_Name__c==Constants.HOMELOAN && app.Sub_Type__c == Constants.Sub_Type_Top_Up )){
                         app.Disbursement_Amount__c=Retry_Task_call.conversion(MaxLoanamt);
                    }
                    if(app.Record_Type_Name__c==Constants.HOMELOAN){
                        Decimal Approve_Additional_Charge =0;
                        if (app.Sub_Type__c == Constants.Sub_Type_Top_Up && app.genesis__Collaterals__r.size() > 0 && app.Facilities__r.size() > 0 ) {
                            Approve_Additional_Charge = (app.Facilities__r[0].Existing_HL_Oustanding_Balance__c != null ?app.Facilities__r[0].Existing_HL_Oustanding_Balance__c : 0) + (app.Sanction_Authority_Limit__c != null ?app.Sanction_Authority_Limit__c :0) - (app.Facilities__r[0].Existing_HL_Sanctioned_Amount__c !=null ?app.Facilities__r[0].Existing_HL_Sanctioned_Amount__c : 0);
                        }
                        decimal Margin=(((FinalGMRA + collateralList[0].Cost_of_Property__c) - app.Sanction_Authority_Limit__c)/collateralList[0].Cost_of_Property__c) *100;
                        clcommon__Collateral__c Col= new clcommon__Collateral__c();
                        col.Margin__c = Margin;
                        col.Approved_Additional_Charge__c = Approve_Additional_Charge >= 0 ? Approve_Additional_Charge : 0;
                        col.Id=collateralList[0].id;
                        update col;
                    }
                    app.Sanctioned_EMI__c = EMIMAX;
                    app.Final_GMRA__c=FinalGMRA;
                    if(EMICASA != null){
                        app.EMICASA__c = EMICASA;
                    }
                }
                /*if(Appstage != null && Appstage != ''){                
                    app.Sub_Stage__c = Appstage;
                }*/ //v1.9 stage will update through PB only                     
                
                //app.Perfios_Captured__c = true;
                system.debug('##1##'+app.Retail_BRE_Hit__c);
                if(Appstage != 'VELAP' && Appstage != 'VEVL' && Appstage != 'VEHL' && Appstage != 'VEPL'){
                    app.Retail_BRE_Hit__c = app.Retail_BRE_Hit__c != null ? app.Retail_BRE_Hit__c == 1 ? 2 : app.Retail_BRE_Hit__c == 2 ?  3 : app.Retail_BRE_Hit__c :1;
                    system.debug('##>>>>>Not VerifyElig##'+app.Retail_BRE_Hit__c);
                }
                system.debug('##2##'+app.Retail_BRE_Hit__c);
                system.debug('##ID##'+app.ID);
                update app;
            }
        }catch(Exception e){
            system.debug('Error@@@@@'+e.getLineNumber()+'WRONG Path#####'+e.getStackTraceString());
            system.debug('Error@@@@@'+e.getMessage());
            HandleBusinessException.captureError('BREScoreCal','Calculate_Bre', e);
        }
    }
    //Updating perfios check for BRE
    public static void updatePerfioscheck(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        integer perInt = 0;
        integer count  = 0;
        try{
            for(genesis__Applications__c app : appList){ 
                if(oldList.get(app.Id).sub_stage__c <> app.Sub_Stage__c && app.Sub_Stage__c =='Work Information Captured' && (app.Record_Type_Name__c == 'Home Loan' || app.Record_Type_Name__c == 'LAP' || app.Record_Type_Name__c == 'Personal Loan' || app.Record_Type_Name__c==Constants.VL4W || app.Record_Type_Name__c==Constants.VL2W)){                
                    //List<Account> accList = queryService.accList(app.Id);
                    
                    List<genesis__Application_Parties__c> PartyList = queryService.getparties(app.Id);
                    system.debug('PartyList'+PartyList);
                    for(genesis__Application_Parties__c ptc: PartyList){
                        if(ptc.Financial_Applicant__c){
                            count++;
                            if(ptc.Perfios_Captured__c == true){
                                perInt++;
                            }
                        }
                    }
                    if(count == perInt){     
                        if(app.Perfios_Captured__c != true){
                            app.Perfios_Captured__c = true;   
                        }
                    }else{
                        app.Perfios_Captured__c = false;
                    }
                }                              
            }    
        }catch(Exception e){
            system.debug('Exception::'+e+e.getLineNumber());
            HandleBusinessException.captureError('BREScoreCal','updatePerfioscheck', e);
        }
    }
    public static Decimal getInterestRate(Integer Month,string Cat,Integer score,String type){
        
        if(type == 'INT'){
            system.debug('Category'+Cat+'Score'+score);  
            Decimal MCLRInt = [select COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=:Month limit 1].MCLR_Of_Interest__c;
            System.debug('MCLRInt'+MCLRInt);
            Decimal MCLR_Excess_Code = [Select ID,Excess__c,Retail_Category__c,Product_Name__c,From_CIBIL__c from MCLR_Excess_Code__c where Retail_Category__c =:Cat AND From_CIBIL__c=:score AND Product_Name__c=:Constants.LAPLOAN Limit 1].Excess__c;
            system.debug('MCLRInt'+MCLRInt+'MCLR_Excess_Code'+MCLR_Excess_Code);            
            Decimal TotalMCLR = MCLRInt + MCLR_Excess_Code;
            return TotalMCLR;
        }else if(type == 'MCLR'){
            Decimal MCLRInt = [select COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=:Month limit 1].MCLR_Of_Interest__c;        
            Decimal TotalMCLR = MCLRInt;
            return TotalMCLR;
        }else if(type == 'VLINT'){
            system.debug('Category VL'+Cat+'VL Score'+score);  
            Decimal MCLRInt = [select COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=:Month limit 1].MCLR_Of_Interest__c;
            System.debug('MCLRInt'+MCLRInt);
            if(EmpTypeVL!='Salaried' && EmpTypeVL!='Self-Employed Professional'){
                EmpTypeVL='Other';
            }
            Decimal MCLR_Excess_Code = [Select ID,Excess__c,Retail_Category__c,Product_Name__c,From_CIBIL__c from MCLR_Excess_Code__c where Retail_Category__c =:Cat AND From_CIBIL__c=:score AND Product_Name__c=:Constants.VL4W AND Employment_Type__c=:EmpTypeVL Limit 1].Excess__c;
            system.debug('MCLRInt'+MCLRInt+'MCLR_Excess_Code'+MCLR_Excess_Code);            
            Decimal TotalMCLR = MCLRInt + MCLR_Excess_Code;
            return TotalMCLR;
        }else{
            return 0.00;
        }                   
    }  
    
    public static IntRateCal HL_Intrate(genesis__Applications__c App){
        map<Decimal,String> AppEmpType =new Map<Decimal,string>();
        List<Decimal> CibilScore=new List<Decimal>();
        Decimal MaxCiblScore = 0;
        decimal IntRate;
        IntRateCal INTCal=new IntRateCal();
        genesis__Applications__c ApList = [select id,Branch_Code__c,Sub_Type__c,genesis__CL_Product__c,Property_City__c,Record_Type_Name__c,Loan_Purpose__c, (select id,genesis__Party_Type__c,Age__c,Net_Monthly_Income__c,NMI_Claimed_By_Customer__c,Approved_NMI_From_ITR__c,Annual_Other_IncomeRecurring_CreditsITR__c,Financial_Applicant__c,Age_In_Months__c,NMI_Approved__c,Employment_Types__c,Max_Existing_EMI__c,CIBIL_Scores__c,Additional_Income_Amount1__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false),(select id,Age_Of_The_Building__c,clcommon__City__c from genesis__Collaterals__r where Active__c=true) from genesis__Applications__c where ID =:app.id limit 1];
        
        for(genesis__Application_Parties__c parties:ApList.genesis__Application_Parties__r){
            
            Decimal NMIITR1 = 0;
            NMIITR1=parties.Approved_NMI_From_ITR__c;
            // re model primary applicant
            if(parties.Financial_Applicant__c && parties.genesis__Party_Type__c==Constants.PRIMARY_APP){
                //Employment Type
                AppEmpType.put(parties.Approved_NMI_From_ITR__c,parties.Employment_Types__c);
                CibilScore.add(parties.CIBIL_Scores__c);
            }
            
            if(parties.genesis__Party_Type__c==Constants.Co_Borrower  && parties.Financial_Applicant__c){
                // employment Type
                AppEmpType.put(NMIITR1,parties.Employment_Types__c);
                CibilScore.add(parties.CIBIL_Scores__c);
                
            }
        }
        
        if(CibilScore.size()>0){
            CibilScore.sort();
            MaxCiblScore=CibilScore[(CibilScore.size()-1)];    
        }
        if(ApList.Record_Type_Name__c==Constants.HOMELOAN){
            List<Decimal> NMIList = new List<Decimal>();
            // system.debug('AppEmpType'+AppEmpType);
            NMIList.addAll(AppEmpType.keySet());
            NMIList.sort();
            Decimal IntProp = 0.00;
            if(ApList.genesis__Collaterals__r[0].Age_Of_The_Building__c!=null){
                if(ApList.genesis__Collaterals__r[0].Age_Of_The_Building__c > 30 && ApList.genesis__Collaterals__r[0].Age_Of_The_Building__c <= 50){
                    IntProp = 0.50;
                }                                                        
            }
            List<Branch_Master__c> BranchList=[select id,CODCCBRN__c,Retail_Category__c,NAMCCCITY__c from Branch_Master__c where NAMCCCITY__c =:ApList.genesis__Collaterals__r[0].clcommon__City__c OR CODCCBRN__c=:App.Branch_Code__c];
            System.debug('BranchList==++'+BranchList);
            ApplicationEligibiltyHandler.mclr MInt=new ApplicationEligibiltyHandler.mclr();
            
            string EMType=AppEmpType.get(NMIList[NMIList.size()-1]);
             Map<String,string> BranchCodemap=new map<String,string>();
            for(Branch_Master__c Bm:BranchList){
                if(Bm.NAMCCCITY__c!=null){
                    System.debug('Bm::'+bm.NAMCCCITY__c);
                    BranchCodemap.put(Bm.NAMCCCITY__c,Bm.Retail_Category__c);
                }
                if(Bm.CODCCBRN__c!=null){
                    BranchCodemap.put(Bm.CODCCBRN__c,Bm.Retail_Category__c);
                }
                
            }
            string RetCat;
            if(ApList.Loan_Purpose__c!=Constants.Loanpurpose){
                        RetCat= BranchCodemap.get(ApList.genesis__Collaterals__r[0].clcommon__City__c.toUppercase()); 
                    }
                    else{
                        RetCat=  BranchCodemap.get(ApList.Branch_Code__c);
                    }
            
            if(EMType!=Constants.EmpType_Salaried && EMType!=Constants.EmpType_SelfProfes){
                EMType=Constants.EmpType_Other;
            }
            System.debug('MaxCiblScore=='+MaxCiblScore);
            if((MaxCiblScore >=1  && MaxCiblScore <= 10) || MaxCiblScore==-1) { 
                MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.HOMELOAN,RetCat,-1,EMType);
                INTCal.IntRate =   MInt.IntRate /*+ IntCIBIL */+IntProp+MInt.Excess;
                INTCal.MCLRRate=  MInt.IntRate;
                INTCal.Excess = MInt.Excess;
                INTCal.MCLRType = Constants.MCLR_OneYear;
                INTCal.IntVari =  INTCal.IntRate - MInt.IntRate;
                
            }
            else{
                 if(ApList.Sub_Type__c==Constants.Sub_Type_Top_Up && MaxCiblScore>=700 ){
                    MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.Sub_Type_Top_Up,BranchList[0].Retail_Category__c,700,EMType);
                    INTCal.IntRate =   MInt.IntRate+MInt.Excess + IntProp;
                    INTCal.MCLRRate=MInt.IntRate;
                    INTCal.Excess=MInt.Excess;
                    INTCal.MCLRType=Constants.MCLR_OneYear;
                    INTCal.IntVari = INTCal.IntRate - MInt.IntRate;
                }else{
                
                if( MaxCiblScore>=650  &&  MaxCiblScore<700){
                    MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.HOMELOAN,RetCat,650,EMType);
                    INTCal.IntRate =   MInt.IntRate+MInt.Excess + IntProp;
                    INTCal.MCLRRate=  MInt.IntRate;
                    INTCal.Excess = MInt.Excess;
                    INTCal.MCLRType = Constants.MCLR_OneYear;
                    INTCal.IntVari =  INTCal.IntRate - MInt.IntRate;
                }
                else if( MaxCiblScore>=700 &&  MaxCiblScore<750){
                    MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.HOMELOAN,RetCat,700,EMType);
                    INTCal.IntRate=   MInt.IntRate +MInt.Excess+ IntProp;
                    INTCal.MCLRRate=  MInt.IntRate;
                    INTCal.Excess = MInt.Excess;
                    INTCal.MCLRType = Constants.MCLR_OneYear;
                    INTCal.IntVari =  INTCal.IntRate - MInt.IntRate;
                    
                }
                else if( MaxCiblScore>=750){
                    MInt=ApplicationEligibiltyHandler.MclrCalc(90,Constants.HOMELOAN,RetCat,750,EMType);
                    INTCal.IntRate  =   MInt.IntRate+MInt.Excess + IntProp;
                    INTCal.MCLRRate=  MInt.IntRate;
                    INTCal.Excess = MInt.Excess;
                    INTCal.MCLRType = Constants.MCLR_ThreeMonths;
                    INTCal.IntVari =  INTCal.IntRate - ApplicationEligibiltyHandler.getMCLR(365,null,null);
                }
                }
            }
        }
        else if(ApList.Record_Type_Name__c==Constants.LAPLOAN){
            List<clcommon__Collateral__c> collateralList = [select Id,Collateral_Uses__c,Collateral_Market_Value__c,clcommon__City__c From clcommon__Collateral__c where genesis__Application__c =: app.Id AND Active__c =: true];
            
            List<clcommon__CL_Product__c> ProdList = [Select Id,Interest_Calculation_Method__c,Pre_Closure_Interest_Rate__c,Holiday_Period__c,MCLR_Type__c From clcommon__CL_Product__c Where Id =: ApList.genesis__CL_Product__c];
            Integer mclrMonth = 0;
            if(ProdList.size()>0){
                if(ProdList[0].MCLR_Type__c =='One Year'){
                    mclrMonth = 365;
                }else if(ProdList[0].MCLR_Type__c =='Six Month'){
                    mclrMonth = 180;
                }else if(ProdList[0].MCLR_Type__c =='Three Month'){
                    mclrMonth = 90;
                }else if(ProdList[0].MCLR_Type__c =='One Month'){
                    mclrMonth = 30;
                }
            }
            else{
                mclrMonth = 365;
            }                    
            String retailCatagory = ApplicationEligibiltyHandler.getRetailCatagory(collateralList);
            system.debug('****'+mclrMonth+'####'+retailCatagory);
            if(!String.isBlank(retailCatagory)){
                if(MaxCiblScore >=-1  && MaxCiblScore <= 10) {                                                
                    INTCal.IntRate=  getInterestRate(mclrMonth,retailCatagory,-1,'INT'); 
                    
                }                
                else if( MaxCiblScore>=650  &&  MaxCiblScore<700){
                    INTCal.IntRate =   getInterestRate(mclrMonth,retailCatagory,650,'INT'); 
                }
                else if( MaxCiblScore>=700 &&  MaxCiblScore<750){
                    INTCal.IntRate=   getInterestRate(mclrMonth,retailCatagory,700,'INT');
                    
                }
                else if( MaxCiblScore>=750){                        
                    INTCal.IntRate=   getInterestRate(mclrMonth,retailCatagory,750,'INT');  
                    
                }          
            }
        }else if(ApList.Record_Type_Name__c==Constants.VL4W){
            List<Decimal> NMIList = new List<Decimal>();
            // system.debug('AppEmpType'+AppEmpType);
            NMIList.addAll(AppEmpType.keySet());
            NMIList.sort();

            EmpTypeVL=AppEmpType.get(NMIList[NMIList.size()-1]);

            List<clcommon__CL_Product__c> ProdList = [Select Id,Interest_Calculation_Method__c,Pre_Closure_Interest_Rate__c,Penal_Interest__c,Holiday_Period__c,MCLR_Type__c From clcommon__CL_Product__c Where Id =: ApList.genesis__CL_Product__c];
            Integer mclrMonth = 365;
                    
            Branch_Master__c BranchList=[select id,CODCCBRN__c,Retail_Category__c,NAMCCCITY__c from Branch_Master__c where CODCCBRN__c =:ApList.Branch_Code__c];
                    
            String retailCatagory = BranchList.Retail_Category__c;
                    
            system.debug('****'+mclrMonth+'####'+retailCatagory);

            if(!String.isBlank(retailCatagory)){
                 if(MaxCiblScore >=-1  && MaxCiblScore <= 10 || MaxCiblScore==-1) {                                                
                            INTCal.IntRate = getInterestRate(mclrMonth,retailCatagory,-1,'VLINT'); 
                            
                        }                
                        else if( MaxCiblScore>=650  &&  MaxCiblScore <700){
                            INTCal.IntRate =  getInterestRate(mclrMonth,retailCatagory,650,'VLINT'); 
                            
                        }
                        else if( MaxCiblScore>=700 &&  MaxCiblScore <750){
                            INTCal.IntRate =  getInterestRate(mclrMonth,retailCatagory,700,'VLINT');
                            
                        }
                        else if( MaxCiblScore>=750){                        
                            INTCal.IntRate = getInterestRate(mclrMonth,retailCatagory,0,'MCLR');  
                        }         
            }
        }
        
        return INTCal;
        
    }
    
    public class IntRateCal{
        public decimal MCLRRate;
        public decimal IntRate;
        Public decimal Excess;
        Public decimal IntVari;
        Public String MCLRType;
        
    }
        
  }