/*
* Name          : ApplicationEligibiltyHandler
* Description   : Handle HL FOR Calculating the EMI,LTV,ROI
* Author        : Venu gopal
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
v1.1    11-Sep-2018    Braj           #VL717:ROI replace with custom label 'VL_ROI_2W_COST2L','VL_ROI_2W_COST_ABOVE_2L'
v1.2    25-Oct-2018    Ashok          #VL717:Scheme Discount code added to LTV & ROI discount.
v1.3    13-Nov-2018    Braj           #VL717:ROI for Cibil score -1 to 10 and 650-700 is also made configurable in custom setting record 'MCLR Excess Code' and putting zero year for NTB customer
v1.4    26-Dec-2018    Braj           #VL774: LTV criteria changes to cibil from loan amount
*******************************************************************************************/
public class ApplicationEligibiltyHandler {
    public static boolean Recursing=true;
    public static void CheckEMI(List<genesis__Applications__c> APlist,Map<Id,genesis__Applications__c> oldApp){
        List<genesis__Applications__c> ApplicationList=new List<genesis__Applications__c>();
        for(genesis__Applications__c Ap:APlist){
            genesis__Applications__c oldPlan = oldApp.get(Ap.Id);
            //COLLATERAL STRUCTURE CHANGES--on 27-11-2018
            if(((oldPlan.Sub_Stage__c!=Ap.Sub_Stage__c && Ap.Sub_Stage__c==Constants.Sub_Stage_PropInfoCaptured) && (ap.Record_Type_Name__c ==Constants.LAPLOAN || ap.Record_Type_Name__c ==Constants.HOMELOAN )) ||                 
               ((oldPlan.Sub_Stage__c!=Ap.Sub_Stage__c && Ap.Sub_Stage__c==Constants.Sub_Stage_WorkInfoCaptured && ap.Record_Type_Name__c ==Constants.PERSONALLOAN) || (oldPlan.NMI_Claimed_By_Customer__c != Ap.NMI_Claimed_By_Customer__c && Ap.Sub_Stage__c==Constants.Sub_Stage_WorkInfoCaptured && ap.Record_Type_Name__c ==Constants.PERSONALLOAN ) || (oldPlan.Sub_Stage__c!=Ap.Sub_Stage__c && Ap.Sub_Stage__c==Constants.Sub_Stage_WorkInfoCaptured && ap.Record_Type_Name__c ==Constants.VL2W) ||  (oldPlan.Sub_Stage__c!=Ap.Sub_Stage__c && Ap.Sub_Stage__c==Constants.Sub_Stage_WorkInfoCaptured && ap.Record_Type_Name__c ==Constants.VL4W))){     
                   
                   
                   ApplicationList.add(Ap);
               }
        }
        
        if(ApplicationList.size()>0 && Recursing==True){
            getEmi_LTV_ROIValues(ApplicationList);
        }
    }
    
    public static void getEmi_LTV_ROIValues(List<genesis__Applications__c> APPlist){
        System.debug('*getEmi_LTV_ROIValues');
        Recursing=false;
        Integer lmax_Pl = 0;
        Integer minAmount = 0;      
        Integer maxAmount = 0;
        Decimal IntProp = 0.00;   //Addtion for Property 
        //  Decimal IntCIBIL = 0.00;  //Addition for CIBIL    
        List<ID> AppID=new List<ID>();
        map<id,id> AccAppID=new Map<id,id>();
        Map<id,Decimal> APPEmi=new Map<id,Decimal>();
        Map<id,List<ID>> ApplistAcc = new  Map<id,List<ID>>();
        Map<ID,Decimal>     AccEmi= new Map<id,Decimal>();
        Map<Id,Integer> AccNmax=new Map<Id,Integer>();
        map<Decimal,String> AppEmpType  = NEW map<Decimal,String>();
        List<Decimal> CibilScore=new List<Decimal>();
        Map<String,string> BranchCodemap=new map<String,string>();
        map<id,string> APPFiType= new Map<id,string>(); 
        set<string> Bcodes=new set<string>();
        set<string> BCodeNum=new Set<string>();
        Decimal MaxCiblScore = 0;
        // Vehicle Loan Variables
        Decimal VehicleCost = 0.00;
        Decimal ExShowVehicleCost = 0.00;
        Decimal MasterVehicleCost = 0.00;
        Decimal TotalVehicleCost = 0.00;
        Decimal RegistrationCost = 0.00;
        Decimal AccessoriesCost = 0.00;
        Decimal TotalAccessoriesCost = 0.00;
        Decimal InsuranceCost = 0.00;
        Decimal ROI = 0.00;
        //Decimal NmiClaimed = 0.00;
        Decimal ExistingEMI = 0.00;
        Decimal EMIMax = 0.00;
        List<Integer> NmaxTWList=new List<Integer>();
        String colid;
        List<clcommon__Collateral__c> collist=new List<clcommon__Collateral__c>();
        // VL Banking with us calculation 
        Map<Decimal,Integer> BankYearList = new Map<Decimal,Integer>();
        Integer MaxBankWithUS = 0;
        //VL Scheme Selection Variables
        String SelectedSchm;
        List<Scheme_Master__c> SelectedScheme = new List<Scheme_Master__c>();
        try{
            list<genesis__Applications__c> UpdateAppList = new list<genesis__Applications__c>();
            
            
            List<genesis__Applications__c> ApList=[select id,BankYear__c,Max_CIBIL_Score__c,Sub_Type__c,Employment_Type__c,PrimaryApplicant_CIBIL_Score__c,CIBIL_score__c, genesis__CL_Product__r.Min_Amount__c, genesis__CL_Product__r.LMax_PL__c, genesis__CL_Product__r.Max_Amount__c,Branch_Code__c,Property_City__c,Record_Type_Name__c,
                                                   Loan_Purpose__c,genesis__Account__r.Age__c, (select id,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                                                                                CIBIL_Scores__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                                                                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                                                                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false),
                                                   (select id,clcommon__City__c from genesis__Collaterals__r where Active__c=true),
                                                   (select id,Takeover_Loans_EMI__c from Facilities__r where Selected_for_Top_Up__c=:true)  from genesis__Applications__c where ID IN:APPlist];
            
            Decimal EMI=0;
            decimal EMI1=0;
            Integer Nmax=0;
            Integer Nmax1=0;
            integer AppNmax;
            Boolean CoCheck = False;
            
            
            for(genesis__Applications__c Appl:ApList){
                if(Appl.genesis__Application_Parties__r.size() >1){
                    CoCheck = true;
                }
                
                //  Primary Applicant EMI
                if(Appl.Loan_Purpose__c!=Constants.Loanpurpose && (Appl.Record_Type_Name__c != Constants.VL4W && Appl.Record_Type_Name__c != Constants.VL2W)){
                    //added by prashant singh on 21_11_2018....collateral structure changes
                    for(clcommon__Collateral__c col:Appl.genesis__Collaterals__r)
                    {
                        Bcodes.add(col.clcommon__City__c);
                        break;
                    }
                    //prashant ends
                }
                else{
                    BCodeNum.add(Appl.Branch_Code__c);
                }
                
                
                
                for(genesis__Application_Parties__c parties:Appl.genesis__Application_Parties__r){
                    
                    //  For Co-applicant and Gurantor EMI
                    AccAppID.put(parties.id,Appl.id);
                    AppID.add(parties.id);
                    
                    Decimal NMI1 = 0;
                    Decimal NMIITR1 = 0;
                    Decimal AddIncome1=0;
                    
                    if(Appl.Record_Type_Name__c == Constants.HOMELOAN){
                        NMI1= parties.NMI_Claimed_By_Customer__c ;
                    }else{
                        NMI1=parties.NMI_Claimed_By_Customer__c;
                    }
                    
                    
                    NMIITR1=parties.Net_Monthly_Income__c;
                    
                    AddIncome1 = parties.Additional_Income_Amount1__c != null ? parties.Additional_Income_Amount1__c : 0;
                    // re model start here for primary applicant
                    if(parties.genesis__Party_Type__c==Constants.PRIMARY_APP){
                        
                        if(parties.Financial_Applicant__c){
                            //Employment Type
                            AppEmpType.put(NMIITR1,parties.Employment_Types__c);
                            // Nmax
                            CibilScore.add(parties.CIBIL_Scores__c);
                            
                            if(parties.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c <> null){
                                Decimal YearCount = 0.00;
                                YearCount =( (parties.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c.daysBetween(System.today()))/365.2425);
                                System.debug('object YearCount>>> ' + YearCount);
                                BankYearList.put(NMIITR1,Integer.valueOf(YearCount.round(System.RoundingMode.HALF_UP)));
                            }
                            //v1.3(start)
                            else {
                                BankYearList.put(NMIITR1,0);
                            }
                            //v1.3(end)
                            
                            if(parties.Employment_Types__c==Constants.EmpType_Salaried){
                                
                                if(Appl.Record_Type_Name__c==Constants.PERSONALLOAN) {
                                    if(parties.CIBIL_Scores__c >= 750){
                                        Nmax=Math.min(60,(720-integer.valueOf(parties.Age_In_Months__c)));
                                    }else{
                                        Nmax=Math.min(36,(720-integer.valueOf(parties.Age_In_Months__c)));
                                    }
                                    //if(NMIITR<25000 && NMIITR>=15000){ //updated on 2018-06-29
                                    //   EMI=NMI*0.55;
                                    //  }
                                    if(NMIITR1 < 50000 && NMIITR1>=25000){
                                        EMI=NMICalcu(NMIITR1,AddIncome1)*0.55;   //EMI=NMI*0.60; updated on 2018-06-29
                                    }
                                    else if(NMIITR1>=50000){
                                        EMI=NMICalcu(NMIITR1,AddIncome1)*0.65;   //EMI=NMI*0.70; updated on 2018-06-29
                                    }
                                }
                                else{
                                    Nmax=NmaxCalculation(integer.valueOf(parties.Age_In_Months__c),true,Appl.Record_Type_Name__c,CoCheck);
                                    if(NMIITR1 <=100000){
                                        System.debug('NMIITR1:::'+NMIITR1+' AddIncome1:::'+AddIncome1);
                                        EMI=NMICalcu(NMIITR1,AddIncome1)*0.70;
                                        
                                    }
                                    else if(NMIITR1>100000){
                                        EMI=NMICalcu(NMIITR1,AddIncome1)*0.75;
                                        system.debug('EMI'+EMI);
                                    }
                                }
                            }
                            else if(parties.Employment_Types__c==Constants.EmpType_Agricul){
                                if(Appl.Record_Type_Name__c==Constants.PERSONALLOAN ) {
                                    Nmax=Math.min(60,(756-integer.valueOf(parties.Age_In_Months__c)));
                                    EMI=NMI1*0.50; // EMI=NMI*0.70; updated on 2018-06-29
                                }
                                else{
                                    Nmax=NmaxCalculation(integer.valueOf(parties.Age_In_Months__c),true,Appl.Record_Type_Name__c,CoCheck);
                                    if(NMIITR1 <=66666.67){
                                        EMI=NMI1*0.70;
                                    }
                                    else if(NMIITR1>66666.67){
                                        EMI=NMI1*0.75;
                                    }
                                }
                            }
                            else{
                                if(Appl.Record_Type_Name__c==Constants.PERSONALLOAN ) {
                                    
                                    if(parties.CIBIL_Scores__c >= 750){
                                        Nmax=Math.min(60,(756-integer.valueOf(parties.Age_In_Months__c)));
                                    }else{
                                        Nmax=Math.min(36,(756-integer.valueOf(parties.Age_In_Months__c)));
                                    }
                                    //Nmax=Math.min(60,(756-integer.valueOf(Appl.genesis__Account__r.Age_In_Months__c)));
                                    EMI=NMICalcu(NMIITR1,AddIncome1)*0.50; // EMI=NMI*0.70; updated on 2018-06-29
                                }
                                else{
                                    Nmax=NmaxCalculation(integer.valueOf(parties.Age_In_Months__c),true,Appl.Record_Type_Name__c,CoCheck);
                                    if(NMIITR1 <=66666.67){
                                        EMI=NMICalcu(NMIITR1,AddIncome1)*0.70;
                                    }
                                    else if(NMIITR1>66666.67){
                                        EMI=NMICalcu(NMIITR1,AddIncome1)*0.75;
                                    }
                                }
                            }
                            system.debug('EMI'+EMI);
                            System.debug(Appl.Sub_Type__c);
                            System.debug(Appl.Facilities__r);
                            System.debug(Appl);
                            if(Appl.Sub_Type__c==Constants.Sub_Type_Take_Over && Appl.Facilities__r !=null && Appl.Facilities__r.size()>0){
                                EMI= EMI+Appl.Facilities__r[0].Takeover_Loans_EMI__c;
                            }
                            if(parties.Max_Existing_EMI__c!=null){
                                EMI= EMI-parties.Max_Existing_EMI__c;
                                if(EMI<0){
                                    EMI=0;
                                }
                            }
                        }
                        else if(!parties.Financial_Applicant__c){
                            Nmax=NmaxCalculation(integer.valueOf(parties.Age_In_Months__c),false,Appl.Record_Type_Name__c,CoCheck);
                        }
                        system.debug('##Data Namx ### --- > '+ Nmax);
                        AccNmax.put(parties.id,Nmax);
                        AccEmi.put(parties.id, EMI);
                    } //----------------remodel chnages end here for primary applicant----
                    
                    if( (parties.genesis__Party_Type__c==Constants.Co_Borrower) && parties.Financial_Applicant__c){
                        // employment Type
                        AppEmpType.put(NMIITR1,parties.Employment_Types__c);
                        // NMAX
                        CibilScore.add(parties.CIBIL_Scores__c);
                        // VL banking with us
                        if(parties.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c <> null){
                            Decimal YearCount = 0.00;
                            YearCount =( (parties.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c.daysBetween(System.today()))/365.2425);
                            System.debug('object YearCount>>> ' + YearCount);
                            BankYearList.put(NMIITR1,Integer.valueOf(YearCount.round(System.RoundingMode.HALF_UP)));
                        }
                        //v1.3(start)
                        else {
                            BankYearList.put(NMIITR1,0);
                        }
                        //v1.3(end)
                        
                        Nmax1=NmaxCalculation(integer.valueOf(parties.Age_In_Months__c),true,Appl.Record_Type_Name__c,CoCheck);
                        
                        system.debug('NMI'+NMI1);
                        if(parties.Employment_Types__c==Constants.EmpType_Salaried){
                            if(NMIITR1<=100000){
                                EMI1 =NMICalcu(NMIITR1,AddIncome1)*0.70;
                            }
                            else if(NMIITR1>100000){
                                EMI1=NMICalcu(NMIITR1,AddIncome1)*0.75;
                            }
                            
                        }
                        else if(parties.Employment_Types__c==Constants.EmpType_Agricul){
                            if(NMIITR1<=66666.67){
                                EMI1=NMI1*0.70;
                            }
                            else if(NMIITR1>66666.67){
                                EMI1=NMI1*0.75;
                            }
                        }
                        else{
                            if(NMIITR1<=66666.67){
                                EMI1=NMICalcu(NMIITR1,AddIncome1)*0.70;
                            }
                            else if(NMIITR1>66666.67){
                                EMI1=NMICalcu(NMIITR1,AddIncome1)*0.75;
                            }
                        }
                        if(Appl.Sub_Type__c==Constants.Sub_Type_Take_Over && Appl.Facilities__r !=null && Appl.Facilities__r.size()>0){
                            EMI1= EMI1+Appl.Facilities__r[0].Takeover_Loans_EMI__c;
                        }
                        if(parties.Max_Existing_EMI__c!=null){
                            EMI1= EMI1-parties.Max_Existing_EMI__c;
                            if(EMI1<0){
                                EMI1=0;
                            }
                        }
                        
                        AccEmi.put(parties.id, EMI1);
                        //for remodel
                        AccNmax.put(parties.id,Nmax1);
                    }
                    else if(parties.genesis__Party_Type__c==Constants.Gurantor  || !parties.Financial_Applicant__c){
                        
                        Nmax1=NmaxCalculation(integer.valueOf(parties.Age_In_Months__c),false,Appl.Record_Type_Name__c,CoCheck);
                        //for remodel
                        AccNmax.put(parties.id,Nmax1);
                    }
                    
                    //AccNmax.put(parties.id,Nmax1);
                    
                }
                ApplistAcc.put(Appl.Id, AppID);
                List<Decimal> NMIList = new List<Decimal>();
                // system.debug('AppEmpType'+AppEmpType);
                NMIList.addAll(AppEmpType.keySet());
                NMIList.sort();
                // AppEmpType.get(NMIList[NMIList.size()-1]);
                if(NMIList.size() > 0){
                    APPFiType.put(Appl.Id,AppEmpType.get(NMIList[NMIList.size()-1]));
                }
                
            }
            
            //------------ ACC For loop ends here---------------------------------
            
            system.debug('APPFiType'+APPFiType);
            System.debug('AccEmi.keySet():'+AccEmi.keySet());
            System.debug('AccNmax:'+AccNmax);
            
            //List<Account> AcclISt= new List<Account>();
            List<genesis__Application_Parties__c> AcclISt= new List<genesis__Application_Parties__c>();
            Decimal x=0;
            for(string s:AccEmi.keySet()){
                //account a=new account();
                genesis__Application_Parties__c a =new genesis__Application_Parties__c();
                a.id=s;
                a.Eligible_EMI1__c=AccEmi.get(S);
                a.NMax__c=AccNmax.get(s);
                AcclISt.add(a);
                
                system.debug('##DataLog### --- > '+ a +' '+ AccNmax);
                
                
                if(ApplistAcc.containsKey(AccAppID.get(s))){
                    x=x+AccEmi.get(s);
                    system.debug(x);
                    if(APPEmi.containsKey(AccAppID.get(s))){
                        APPEmi.put(AccAppID.get(s), x);
                    }
                    else{
                        APPEmi.put(AccAppID.get(s), AccEmi.get(s));
                    }
                }
            }
            List<integer>  Num=new List<integer>();
            for(Id nm:AccNmax.keySet()){
                
                Num.add( AccNmax.get(nm));
            }
            
            Num.sort();
            AppNmax =num[0];  
            
            if(CibilScore.size()>0){
                CibilScore.sort();
                MaxCiblScore=CibilScore[(CibilScore.size()-1)];    
            }
            System.debug('Test Bcodes'+Bcodes+' BCodeNum '+BCodeNum);
            List<Branch_Master__c> BranchList=[select id,CODCCBRN__c,Retail_Category__c,NAMCCCITY__c from Branch_Master__c where NAMCCCITY__c IN:Bcodes OR CODCCBRN__c IN:BCodeNum];
            System.debug('**BranchList'+BranchList);
            for(Branch_Master__c Bm:BranchList){
                if(Bm.NAMCCCITY__c!=null){
                    BranchCodemap.put(Bm.NAMCCCITY__c,Bm.Retail_Category__c);
                }
                if(Bm.CODCCBRN__c!=null){
                    BranchCodemap.put(Bm.CODCCBRN__c,Bm.Retail_Category__c);
                }
                
            }
            system.debug('BranchCodemap'+BranchCodemap);
            system.debug('MaxCiblScore'+MaxCiblScore);
            
            list<genesis__Applications__c> newApplist=[select id,PL_Score__c,CIBIL_score__c,Sub_Type__c,genesis__CL_Product__r.Min_Amount__c,genesis__CL_Product__r.Existing_Margin__c,genesis__CL_Product__r.LMax_PL__c, genesis__CL_Product__r.Max_Amount__c,Branch_Code__c,Record_Type_Name__c,Property_City__c,BankYear__c,Max_CIBIL_Score__c,PrimaryApplicant_CIBIL_Score__c,genesis__Loan_Amount__c,Total_Market_value__c,
                                                       Holiday_Max__c,genesis__Account__r.Max_Existing_EMI__c,genesis__Account__r.Net_Monthly_Income__c,genesis__Account__r.NMI_Claimed_By_Customer__c,genesis__Account__r.Employment_Type__c,Is_Take_Over__c, Loan_Purpose__c,Cost_Of_Construction__c,Cost_Of_Land__c,PMax1__c,Cost_Of_Repair__c,
                                                       (select id,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                                        CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,
                                                        NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                                        Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false),
                                                       (select id,Cost_of_Property__c,Cost_Of_Flat_House__c,Collateral_Market_Value__c,clcommon__City__c,clcommon__Insurance_Amount__c,Scheme_Type__c,
                                                        Market_valueProposedRepairs_Renovation__c,Cost_Of_Construction__c,Cost_Of_Land__c,Age_Of_The_Building__c,Cost_Of_Repair__c,
                                                        Dealer_name__c,clcommon__Model__c,clcommon__Make__c,clcommon__Manufacturer__c,Accessories_value__c,ExShow_Room_Price__c,ExshowRoomPrice_Api__c,Variant__c,
                                                        Registration_cost__c,Total_Vehicle_Value__c,Whether_The_Construction_Completed__c,Cost_incurred_in_the_last_6_months__c,Total_cost_incurred_till_date__c From genesis__Collaterals__r),
                                                       (select id,Takeover_Outstanding_Loan_Tenure_months__c,Existing_HL_Outstanding_Tenure__c,Takeover_Outstanding_Loan_Amount__c,Existing_HL_Oustanding_Balance__c from Facilities__r where Selected_for_Top_Up__c=:true) 
                                                       From genesis__Applications__c where id IN:APPEmi.keySet()];
            
            
            system.debug('newApplist:-'+newApplist);
            for(genesis__Applications__c App:newApplist){
                
                
                //AppEmpType =new Map<Decimal,string>();
                if(app.Record_Type_Name__c == Constants.PERSONALLOAN){
                    lmax_Pl = Integer.valueOf(App.genesis__CL_Product__r.LMax_PL__c);
                    if(App.genesis__CL_Product__r.Min_Amount__c != null){
                        App.PMin__c = App.genesis__CL_Product__r.Min_Amount__c;    
                    }
                    if(app.PrimaryApplicant_CIBIL_Score__c >= 750){
                        if(app.genesis__CL_Product__r.Max_Amount__c != null){
                            App.Pmax_Limit__c = app.genesis__CL_Product__r.Max_Amount__c;
                        }   
                    }else{
                        if(app.genesis__CL_Product__r.LMax_PL__c != null){
                            App.Pmax_Limit__c = app.genesis__CL_Product__r.LMax_PL__c;  
                        }
                    }
                }else{
                    if(App.genesis__CL_Product__r.Min_Amount__c != null){
                        App.PMin__c = App.genesis__CL_Product__r.Min_Amount__c;    
                    }
                    if(app.genesis__CL_Product__r.Max_Amount__c != null){
                        App.Pmax_Limit__c = app.genesis__CL_Product__r.Max_Amount__c;
                    }
                }  
                //$End Here$ This code belongs to Pl Score related logic and PMIN and PMAX_LIMIT is getting updated on sub stage change
                
                // For Nmax
                App.Nmax__c=AppNmax<0?0:AppNmax;
                
                if(App.Record_Type_Name__c==Constants.HOMELOAN){
                    // Holiday Max
                    if(Utility.ISStringBlankorNull(App.Sub_Type__c)){
                        if(App.genesis__Collaterals__r[0].Whether_The_Construction_Completed__c ){
                            App.Holiday_Max__c=3;
                        }
                        else{
                            App.Holiday_Max__c=24; 
                        } 
                    }
                    else if(App.Sub_Type__c==Constants.Sub_Type_Reimbursement && !App.genesis__Collaterals__r[0].Whether_The_Construction_Completed__c){
                        App.Holiday_Max__c=24; 
                    }
                    else{
                        App.Holiday_Max__c=0; 
                    }
                    if(!Utility.ISStringBlankorNull(App.Sub_Type__c) && App.Facilities__r!=null &&  App.Facilities__r.size()>0){
                        if(App.Sub_Type__c==Constants.Sub_Type_Take_Over ){
                            if(!Utility.ISStringBlankorNull(string.valueof(App.Facilities__r[0].Takeover_Outstanding_Loan_Tenure_months__c)))
                                App.Nmax__c=math.min(AppNmax,App.Facilities__r[0].Takeover_Outstanding_Loan_Tenure_months__c);
                        }
                        else if(App.Sub_Type__c==Constants.Sub_Type_Top_Up){
                            if(!Utility.ISStringBlankorNull(string.valueof(App.Facilities__r[0].Existing_HL_Outstanding_Tenure__c)))
                                App.Nmax__c=math.min(AppNmax,App.Facilities__r[0].Existing_HL_Outstanding_Tenure__c);
                        }
                    }
                    
                    // Pmax1  
                    
                    Decimal CostProperty = 0;
                    Decimal PropertyValue = 0;
                    if(App.Loan_Purpose__c==Constants.IdentifiedProperty || App.Loan_Purpose__c==Constants.Loanpurpose){
                        CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c;
                        PropertyValue=App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c;
                    }
                    else if(App.Loan_Purpose__c==Constants.RepairHouse){
                        if(App.Sub_Type__c==Constants.Sub_Type_Top_Up){
                            CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c;
                            PropertyValue=App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c;
                            
                        }
                        else{
                            
                            CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Repair__c;
                            PropertyValue=App.genesis__Collaterals__r[0].Cost_Of_Repair__c;
                            
                        }
                    }
                    else if(App.Loan_Purpose__c==Constants.Construction){
                        CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Construction__c;
                        PropertyValue=App.genesis__Collaterals__r[0].Cost_Of_Construction__c ;
                    }
                    else if(App.Loan_Purpose__c==Constants.ConstructionOn){
                        CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Land__c + App.genesis__Collaterals__r[0].Cost_Of_Construction__c;
                        PropertyValue=App.genesis__Collaterals__r[0].Cost_Of_Land__c + App.genesis__Collaterals__r[0].Cost_Of_Construction__c;
                    }
                    system.debug('CostProperty'+CostProperty);

                    if(App.genesis__Collaterals__r[0].Age_Of_The_Building__c!=null){
                        if(App.genesis__Collaterals__r[0].Age_Of_The_Building__c > 30 && App.genesis__Collaterals__r[0].Age_Of_The_Building__c <= 50){
                            IntProp = 0.50;
                        }
                        Decimal Minvalue =0;
                        if(PropertyValue==0){
                            Minvalue=CostProperty;
                        }
                        else{
                            Minvalue=Math.min(CostProperty,PropertyValue);  
                        }
                        system.debug('Minvalue'+Minvalue);
                        //if(App.Age_Of_The_Building__c<=Constants.one){
                        
                        if(Minvalue <3750000 && (App.genesis__Collaterals__r[0].Age_Of_The_Building__c <= 1 || App.genesis__Collaterals__r[0].Age_Of_The_Building__c == NULL)){
                            App.PMax1__c = Math.min(0.90*Minvalue,3000000);
                        }
                        else if(Minvalue <3750000 && App.genesis__Collaterals__r[0].Age_Of_The_Building__c > 1){
                            App.PMax1__c = Math.min(0.80*Minvalue,3000000);
                        }
                        else if(Minvalue>=3750000 && Minvalue<=10000000){
                            App.PMax1__c = Math.min(0.80*Minvalue,7500000);
                        }
                        else if(Minvalue>10000000){
                            App.PMax1__c = 0.75*Minvalue;
                        }
                        system.debug('llll'+App.PMax1__c);
                        if(!Utility.ISStringBlankorNull(App.Sub_Type__c) ){
                            system.debug('Inside'+App.PMax1__c);
                            system.debug('Facility'+App.Facilities__r+'size'+App.Facilities__r.size());
                            if(App.Sub_Type__c==Constants.Sub_Type_Take_Over &&  App.Facilities__r!=null &&  App.Facilities__r.size()>0){
                                system.debug('Inside'+App.PMax1__c);
                                if(!Utility.ISStringBlankorNull(string.valueof(App.Facilities__r[0].Takeover_Outstanding_Loan_Amount__c)))
                                    system.debug('Inside'+App.Facilities__r[0].Takeover_Outstanding_Loan_Amount__c);
                                App.PMax1__c=Math.min(App.PMax1__c,App.Facilities__r[0].Takeover_Outstanding_Loan_Amount__c);
                            }
                            else if(App.Sub_Type__c==Constants.Sub_Type_Top_Up && App.Facilities__r!=null &&  App.Facilities__r.size()>0){
                                
                                Decimal Pmaxv2;
                                Decimal FInalpmax;
                                Decimal MiniValue=App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c;
                                if(MiniValue <3750000 && (App.genesis__Collaterals__r[0].Age_Of_The_Building__c <= 1 || App.genesis__Collaterals__r[0].Age_Of_The_Building__c == NULL)){
                                    Pmaxv2 = Math.min(0.90*MiniValue,3000000);
                                }
                                else if(MiniValue <3750000 && App.genesis__Collaterals__r[0].Age_Of_The_Building__c > 1){
                                    Pmaxv2 = Math.min(0.80*MiniValue,3000000);
                                }
                                else if(MiniValue>=3750000 && MiniValue<=10000000){
                                    Pmaxv2 = Math.min(0.80*MiniValue,7500000);
                                }
                                else if(MiniValue>10000000){
                                    Pmaxv2 = 0.75*MiniValue;
                                }
                                
                                if(!Utility.ISStringBlankorNull(string.valueof(App.Facilities__r[0].Existing_HL_Oustanding_Balance__c)))
                                    FInalpmax= Pmaxv2 -App.Facilities__r[0].Existing_HL_Oustanding_Balance__c;
                                if(FInalpmax!=null){
                                    App.PMax1__c =Math.min(FInalpmax,App.PMax1__c);
                                    
                                }
                            }
                            else if(App.Sub_Type__c==Constants.Sub_Type_Reimbursement){
                                App.PMax1__c = Math.min( App.PMax1__c,(CostProperty+App.genesis__Collaterals__r[0].Cost_incurred_in_the_last_6_months__c-App.genesis__Collaterals__r[0].Total_cost_incurred_till_date__c));
                              App.PMax1__c =  App.PMax1__c>=0? App.PMax1__c:0;
                            }
                        }
                    }
                    
                    // ROI HL
                    mclr MInt=new mclr();
                    string EMType=APPFiType.get(App.id);
                    if(EMType!=Constants.EmpType_Salaried && EMType!=Constants.EmpType_SelfProfes){
                        EMType=Constants.EmpType_Other;
                    }
                    string RetCat;
                    
                    if(App.Loan_Purpose__c!=Constants.Loanpurpose){
                        RetCat= BranchCodemap.get(App.genesis__Collaterals__r[0].clcommon__City__c.toUppercase()); 
                    }
                    else{
                        RetCat=  BranchCodemap.get(App.Branch_Code__c);
                    }
                    
                    if((MaxCiblScore >=1  && MaxCiblScore <= 10) || MaxCiblScore==-1) { 
                        MInt=MclrCalc(365,Constants.HOMELOAN,RetCat,-1,EMType);
                        App.genesis__Interest_Rate__c=   MInt.IntRate /*+ IntCIBIL */+IntProp+MInt.Excess;
                        App.MCLR_Rate__c= MInt.IntRate ;
                        App.Excess_MCLR__c= MInt.Excess;
                        App.MCLR_Type__c=Constants.MCLR_OneYear;
                    }
                    else{
                        App.Reject_Scenario__c='';
                        if(App.Sub_Type__c==Constants.Sub_Type_Top_Up && MaxCiblScore>=700 ){
                            MInt=MclrCalc(365,Constants.Sub_Type_Top_Up,RetCat,700,EMType);
                            App.genesis__Interest_Rate__c =   MInt.IntRate+MInt.Excess + IntProp;
                            App.MCLR_Rate__c=MInt.IntRate;
                            App.Excess_MCLR__c=MInt.Excess;
                            App.MCLR_Type__c=Constants.MCLR_OneYear;
                        }else{
                            if( MaxCiblScore>=650  &&  MaxCiblScore < 700){
                                MInt=MclrCalc(365,Constants.HOMELOAN,RetCat,650,EMType);
                                App.genesis__Interest_Rate__c =   MInt.IntRate+MInt.Excess + IntProp;
                                App.MCLR_Rate__c=MInt.IntRate;
                                App.Excess_MCLR__c=MInt.Excess;
                                App.MCLR_Type__c=Constants.MCLR_OneYear;
                            }
                            else if( MaxCiblScore>=700 &&  MaxCiblScore < 750){
                                system.debug('RetCat:-'+RetCat+'  EMType:-'+EMType);
                                MInt=MclrCalc(365,Constants.HOMELOAN,RetCat,700,EMType);
                                App.genesis__Interest_Rate__c=   MInt.IntRate +MInt.Excess+ IntProp;
                                App.MCLR_Rate__c=MInt.IntRate;
                                App.Excess_MCLR__c=MInt.Excess;
                                App.MCLR_Type__c=Constants.MCLR_OneYear;
                            }
                            else if( MaxCiblScore>=750){
                                MInt=MclrCalc(90,Constants.HOMELOAN,RetCat,750,EMType);
                                App.genesis__Interest_Rate__c=   MInt.IntRate+MInt.Excess + IntProp;
                                App.MCLR_Rate__c=MInt.IntRate;
                                App.Excess_MCLR__c=MInt.Excess;
                                App.MCLR_Type__c=Constants.MCLR_ThreeMonths;
                            }
                        }
                    }
                    
                }
                else if(App.Record_Type_Name__c==Constants.LAPLOAN){
                    Decimal Marketvalue =0;
                    system.debug('####'+App.genesis__Collaterals__r.size());
                    String RetailCat = getRetailCatagory(App.genesis__Collaterals__r);
                    for(clcommon__Collateral__c cc : App.genesis__Collaterals__r){
                        if(!Utility.ISStringBlankorNull(string.valueof(cc.Collateral_Market_Value__c))){
                            Marketvalue +=cc.Collateral_Market_Value__c;
                        }
                    }
                    if(Marketvalue!=null){
                        integer i=0;
                        for(genesis__Application_Parties__c parties:App.genesis__Application_Parties__r){
                            if(parties.genesis__Party_Type__c == Constants.Co_Borrower || parties.genesis__Party_Type__c == Constants.Gurantor ){
                                i++;
                            }
                        }
                        system.debug('Party Value i++++'+i);
                        if(i==0){
                            App.PMax1__c = Marketvalue*0.55;
                        }
                        else{
                            App.PMax1__c = Marketvalue*0.60; 
                        }
                        
                    }     
                    
                    // ROI LAP
                    if(MaxCiblScore >=-1  && MaxCiblScore <= 10) {                                                
                        App.genesis__Interest_Rate__c=  getMCLR(365,RetailCat,-1);                        
                    }
                    
                    else if( MaxCiblScore>=650  &&  MaxCiblScore<700){
                        App.genesis__Interest_Rate__c =   getMCLR(365,RetailCat,650);                                                
                    }
                    else if( MaxCiblScore>=700 &&  MaxCiblScore<750){
                        App.genesis__Interest_Rate__c=   getMCLR(365,RetailCat,700);                        
                    }
                    else if( MaxCiblScore>=750){                        
                        App.genesis__Interest_Rate__c=   getMCLR(365,RetailCat,750);                        
                    }
                }
                else if(App.Record_Type_Name__c==Constants.PERSONALLOAN){
                    //  Nmax reject scenario
                    for(genesis__Application_Parties__c parties:App.genesis__Application_Parties__r){
                        
                        if(parties.genesis__Party_Type__c==Constants.PRIMARY_APP){
                            System.debug('parties.CIBIL_Scores__c:'+parties.CIBIL_Scores__c+'app.Max_CIBIL_Score__c:'+app.Max_CIBIL_Score__c);
                            if(!Utility.ISStringBlankorNull(String.valueOf(parties.CIBIL_Scores__c))){
                                app.Max_CIBIL_Score__c = parties.CIBIL_Scores__c;
                            }
                            if(parties.Employment_Types__c==Constants.EmpType_Salaried){
                                System.debug('PL SCore::'+app.PL_Score__c);
                                if(MaxCiblScore>=800){
                                    App.genesis__Interest_Rate__c=Constants.PLIR_12;
                                }
                                else if(MaxCiblScore>=750 && MaxCiblScore <= 799){
                                    App.genesis__Interest_Rate__c=Constants.PLIR_14;
                                }
                                else if(MaxCiblScore  < 750){
                                    App.genesis__Interest_Rate__c=Constants.PLIR_16; 
                                }
                                App.PMax1__c  =12* (parties.Net_Monthly_Income__c-parties.Max_Existing_EMI__c);
                            }
                            else {
                                System.debug(app.PL_Score__c);
                                if(MaxCiblScore>=800){
                                    App.genesis__Interest_Rate__c=Constants.PLIR_13; // updated after discussion on 23/05/2018 - agin reupdated on 13-6-2018
                                }
                                else if(MaxCiblScore>=750 && MaxCiblScore <= 799){
                                    App.genesis__Interest_Rate__c=Constants.PLIR_15; //// again updated on 28/6/18 3rdtime
                                } 
                                else if(MaxCiblScore  < 750 ){
                                    App.genesis__Interest_Rate__c=Constants.PLIR_18;  
                                }
                                System.debug(app.genesis__Interest_Rate__c);
                                App.PMax1__c       =36*parties.Net_Monthly_Income__c; // updated on 2018-07-01 3* to 36*
                            }
                        }
                    }
                }
                App.EMI_Max__c=APPEmi.get(App.id);
                //Vehicle Loan 2 Wheeler Loan----------------------------------------------------------------------------
                
                if(App.Record_Type_Name__c == Constants.VL2W){
                    mclr MInt=new mclr();
                    String EMType=APPFiType.get(App.id);
                    String RetCat;
                    if(EMType!=Constants.EmpType_Salaried){
                        EMType=Constants.EmpType_Other;
                    }
                    List<Decimal> MaxNMIList = new List<Decimal>();
                    
                    if(BankYearList.size() > 0){
                        MaxNMIList.addAll(BankYearList.keySet());
                        MaxNMIList.sort();
                        Integer BnkCount = MaxNMIList.size()-1;
                        MaxBankWithUS = BankYearList.get(MaxNMIList[BnkCount]);
                        System.debug(' MaxBankWithUS  >>> ' +  MaxBankWithUS );
                    }
                    System.debug('*inside VL2W');
                    for(clcommon__Collateral__c cc : App.genesis__Collaterals__r){
                        ExShowVehicleCost += Utility.isNullOrZeroDecimal(cc.ExShow_Room_Price__c);
                        //   MasterVehicleCost += getPriceMaster(cc.clcommon__Model__c,cc.clcommon__Manufacturer__c,cc.Variant__c);
                        MasterVehicleCost += Utility.isNullOrZeroDecimal(cc.ExshowRoomPrice_Api__c);     
                        RegistrationCost += Utility.isNullOrZeroDecimal(cc.Registration_cost__c);
                        AccessoriesCost += Utility.isNullOrZeroDecimal(cc.Accessories_value__c);
                        InsuranceCost += Utility.isNullOrZeroDecimal(cc.clcommon__Insurance_Amount__c);
                        SelectedSchm = cc.Scheme_Type__c != null ? cc.Scheme_Type__c : '';
                        colid=cc.Id;
                    }
                    //v1.2 Scheme type
                    SelectedScheme =  [Select Id,Name,Scheme_Code__c,ProductType__c,Active_Flag__c,LTV_increase__c,Pricing_Discount__c,Processing_fee_discount__c from Scheme_Master__c Where Active_Flag__c = True and ProductType__c=:Constants.VL2W and Scheme_Code__c=:SelectedSchm limit 1];
                    
                    VehicleCost = Math.min((Constants.VL_MSTRVLCOSTPRCNT*MasterVehicleCost), (ExShowVehicleCost));
                    if(VehicleCost > Constants.VEHICLECOST2L){
                        TotalAccessoriesCost = Math.min(20000, AccessoriesCost);
                    }else{
                        TotalAccessoriesCost = 0;
                    }
                    TotalVehicleCost =(VehicleCost + RegistrationCost + TotalAccessoriesCost + InsuranceCost);
                    System.debug('2W*TotalVehicleCost'+TotalVehicleCost);
                    
                    if(TotalVehicleCost <= Constants.VEHICLECOST2L){
                        // Vehicle value <= 2L
                        //v1.3(start)
                        if( (MaxCiblScore >=-1  && MaxCiblScore <= 10)){
                            RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'C' : 'D') : ( MaxBankWithUS > 0.5 ? 'C' : 'D');
                                System.debug('Below 2L/Cibil=-1/RetCat==='+RetCat+' EMType=='+EMType);
                            MInt=MclrCalc(365,Constants.VL2W,RetCat,-1,EMType);
                            ROI=   MInt.Excess;
                        }
                        else if( MaxCiblScore>=650 &&  MaxCiblScore <700){
                            RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'C' : 'D') : ( MaxBankWithUS > 0.5 ? 'C' : 'D');
                                System.debug('Below 2L/Cibil=650/RetCat==='+RetCat+' EMType=='+EMType);
                            MInt=MclrCalc(365,Constants.VL2W,RetCat,650,EMType);
                            ROI=   MInt.Excess;
                        }
                        //v1.3(end)
                        else if( MaxCiblScore>=700 &&  MaxCiblScore <750){
                            RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'C' : 'D') : ( MaxBankWithUS > 0.5 ? 'C' : 'D');
                                System.debug('Below 2L/Cibil=700/RetCat==='+RetCat+' EMType=='+EMType);
                            MInt=MclrCalc(365,Constants.VL2W,RetCat,700,EMType);
                            ROI=   MInt.Excess;
                        }
                        else if( MaxCiblScore>=750){
                            RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'C' : 'D') : ( MaxBankWithUS > 0.5 ? 'C' : 'D');
                                System.debug('Below 2L/Cibil=750/RetCat==='+RetCat+' EMType=='+EMType);
                            MInt=MclrCalc(365,Constants.VL2W,RetCat,750,EMType);
                            ROI=   MInt.Excess;
                        }
                    }else{
                        // Vehicle value > 2L
                        //v1.3(start)
                        if( (MaxCiblScore >=-1  && MaxCiblScore <= 10)){
                            RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'A' : 'B') : ( MaxBankWithUS > 0.5 ? 'A' : 'B');
                                System.debug('Above 2L/Cibil=-1/RetCat==='+RetCat+' EMType=='+EMType);
                            MInt=MclrCalc(365,Constants.VL2W,RetCat,-1,EMType);
                            ROI=   MInt.Excess;
                        }
                        else if( MaxCiblScore>=650 &&  MaxCiblScore <700){
                            RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'A' : 'B') : ( MaxBankWithUS > 0.5 ? 'A' : 'B');
                                System.debug('Above 2L/Cibil=650/RetCat==='+RetCat+' EMType=='+EMType);
                            MInt=MclrCalc(365,Constants.VL2W,RetCat,650,EMType);
                            ROI=   MInt.Excess;
                        }
                        //v1.3(end)
                        else if( MaxCiblScore>=700 &&  MaxCiblScore <750){
                            RetCat  = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'A' : 'B') : ( MaxBankWithUS > 0.5 ? 'A' : 'B');
                                System.debug('Above 2L/Cibil=700/RetCat==='+RetCat+' EMType=='+EMType);
                            MInt    =MclrCalc(365,Constants.VL2W,RetCat,700,EMType);
                            ROI     =   MInt.Excess;
                        }
                        else if( MaxCiblScore>=750){
                            RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'A' : 'B') : ( MaxBankWithUS > 0.5 ? 'A' : 'B');
                                System.debug('Above 2L/Cibil=750/RetCat==='+RetCat+' EMType=='+EMType);
                            MInt   = MclrCalc(365,Constants.VL2W,RetCat,750,EMType);
                            ROI    = MInt.Excess;
                        }
                    }
                    
                    // End of new chnages of 2wheeler
                    Decimal Pmax1 = 0.00;                    
                    Decimal Pmax = 0.00;
                    Integer NmaxTW = 0; 
                    Decimal AddIncome1 = 0;
                    clcommon__Collateral__c colupdate=new clcommon__Collateral__c();
                    colupdate.Vehicle_CalculatedValue__c=string.valueOf(TotalVehicleCost);  
                    colupdate.Id=colid;
                    collist.add(colupdate);
                    System.debug('collist'+collist);
                    if(SelectedScheme.size() > 0){ //v1.2 
                        Pmax1 = (SelectedScheme[0].LTV_increase__c*TotalVehicleCost)/100; 
                        ROI = (ROI - SelectedScheme[0].Pricing_Discount__c);
                    }else{
                        //v1.4(start)
                        if(MaxCiblScore>=750){
                            Pmax1 = (Constants.VL4WEQUL_VL90PRCNT*TotalVehicleCost);
                        }else if((MaxCiblScore < 750 && MaxCiblScore >= 650) || MaxCiblScore == -1 || MaxCiblScore == 5 || (MaxCiblScore >= 8 && MaxCiblScore <= 10)){
                            Pmax1 = (Constants.VL2WGRET_2L85PRCNT*TotalVehicleCost);
                        }
                        //v1.4(end)
                    }
                    for(genesis__Application_Parties__c PT : App.genesis__Application_Parties__r){
                        Decimal EMICal = 0.0;
                        Decimal NmiClaimed = 0.0;
                        if(TotalVehicleCost <= Constants.VEHICLECOST2L){
                            if(PT.Financial_Applicant__c){
                                NmaxTW = Math.min(36,(840-Integer.ValueOf(PT.Age_In_Months__c)));
                            }else{
                                NmaxTW = Math.min(36,(960-Integer.ValueOf(PT.Age_In_Months__c))); 
                            }
                            
                        }else{
                            if(PT.Financial_Applicant__c){
                                NmaxTW = Math.min(60,(840-Integer.ValueOf(PT.Age_In_Months__c)));
                            }else{
                                NmaxTW = Math.min(60,(960-Integer.ValueOf(PT.Age_In_Months__c))); 
                            }
                        }
                        NmaxTWList.add(NmaxTW);
                        if(PT.Financial_Applicant__c){
                            if(PT.Employment_Types__c == Constants.EMPTYP_AGRICULTUR){
                                AddIncome1 = 0;
                                System.debug(NmiClaimed +'---'+PT.Net_Monthly_Income__c);
                                if(PT.Net_Monthly_Income__c < Decimal.ValueOf(Label.VL_NMI_SLAB)){
                                    NmiClaimed = PT.Net_Monthly_Income__c != null ?(PT.Net_Monthly_Income__c*0.60) : 0;
                                }
                                else{
                                    NmiClaimed = PT.Net_Monthly_Income__c != null ?(PT.Net_Monthly_Income__c*0.75) : 0; 
                                }
                            }
                            
                            if(PT.Employment_Types__c != Constants.EMPTYP_AGRICULTUR){
                                AddIncome1 = PT.Additional_Income_Amount1__c != null ? PT.Additional_Income_Amount1__c : 0;
                                Double minVal = PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c : 0;
                                System.debug(NmiClaimed +':::nmiClValue::'+(NMICalcu(minVal,AddIncome1)*0.75));
                                if(PT.Net_Monthly_Income__c < Decimal.ValueOf(Label.VL_NMI_SLAB)){
                                    NmiClaimed = (NMICalcu(minVal,AddIncome1)*0.60);
                                }
                                else{
                                    NmiClaimed = (NMICalcu(minVal,AddIncome1)*0.75);
                                }
                            }  
                            
                            System.debug('** NMI Claimed'+NmiClaimed);  
                            ExistingEMI = PT.Max_Existing_EMI__c != null ? PT.Max_Existing_EMI__c : 0 ;
                            if(NmiClaimed>ExistingEMI){
                                EMICal = NmiClaimed - ExistingEMI;    
                            }else{
                                EMICal = 0;
                            } 
                        }
                        EMIMax += EMICal;
                        
                    }
                    
                    System.debug('* total ExistingEMI'+ExistingEMI);
                    NmaxTWList.sort();
                    App.EMI_Max__c = EMIMax;
                    App.genesis__Interest_Rate__c = ROI;
                    App.Nmax__c = NmaxTWList[0];
                    App.PMax1__c = Pmax1;
                    App.Max_CIBIL_Score__c = MaxCiblScore;
                    App.BankYear__c = MaxBankWithUS;
                    //App.Employment_Type__c = EMType != Constants.EmpType_Salaried ? 'Others' : EMType;
                }
                //Vehicle loan 4 Wheeler loan----------------------------------------------------------------------------------------
                if(App.Record_Type_Name__c == Constants.VL4W){
                    System.debug('*inside vl4w');
                    mclr MInt=new mclr();
                    string EMType=APPFiType.get(App.id);
                    if(EMType!=Constants.EmpType_Salaried && EMType!=Constants.EmpType_SelfProfes){
                        EMType=Constants.EmpType_Other;
                    }
                    string RetCat;
                    
                    
                    RetCat=  BranchCodemap.get(App.Branch_Code__c);
                    
                    if((MaxCiblScore >=1  && MaxCiblScore <= 10) || MaxCiblScore==-1) { 
                        
                        MInt=MclrCalc(365,Constants.VL4W,RetCat,-1,EMType);
                        ROI =   MInt.IntRate +MInt.Excess;
                        
                    }
                    else{
                        App.Reject_Scenario__c='';
                        if( MaxCiblScore>=650  &&  MaxCiblScore<700){
                            System.debug('**** from 650 to 700');
                            System.debug('**RetCat'+RetCat);
                            MInt=MclrCalc(365,Constants.VL4W,RetCat,650,EMType);
                            System.debug('**MInt'+MInt);
                            ROI =   MInt.IntRate+MInt.Excess;
                            
                        }
                        else if( MaxCiblScore>=700 &&  MaxCiblScore<750){
                            
                            MInt=MclrCalc(365,Constants.VL4W,RetCat,700,EMType);
                            ROI =   MInt.IntRate +MInt.Excess;
                            
                        }
                        else if( MaxCiblScore>=750){
                            MInt=MclrCalcVL(365,Constants.VL4W,RetCat,750,EMType);
                            System.debug('MInt.IntRate'+MInt.IntRate);
                            ROI =   MInt.IntRate;
                        }
                    }
                    
                    for(clcommon__Collateral__c cc : App.genesis__Collaterals__r){
                        System.debug('cc'+cc);
                        ExShowVehicleCost += Utility.isNullOrZeroDecimal(cc.ExShow_Room_Price__c);
                        //  MasterVehicleCost += getPriceMaster(cc.clcommon__Model__c,cc.clcommon__Manufacturer__c,cc.Variant__c);
                        MasterVehicleCost += Utility.isNullOrZeroDecimal(cc.ExshowRoomPrice_Api__c);      
                        System.debug('*MasterVehicleCost'+MasterVehicleCost);
                        RegistrationCost +=Utility.isNullOrZeroDecimal(cc.Registration_cost__c);
                        AccessoriesCost += Utility.isNullOrZeroDecimal(cc.Accessories_value__c);
                        InsuranceCost += Utility.isNullOrZeroDecimal(cc.clcommon__Insurance_Amount__c);
                        SelectedSchm = cc.Scheme_Type__c != null ? cc.Scheme_Type__c : '';
                        colid=cc.Id;
                    }
                    
                    SelectedScheme =  [Select Id,Name,Scheme_Code__c,ProductType__c,Active_Flag__c,LTV_increase__c,Pricing_Discount__c,Processing_fee_discount__c from Scheme_Master__c Where Active_Flag__c = True and ProductType__c=:Constants.VL4W and Scheme_Code__c=:SelectedSchm limit 1];
                    
                    VehicleCost = Math.min((Constants.VL_MSTRVLCOSTPRCNT*MasterVehicleCost), (ExShowVehicleCost));System.debug('**VehicleCost'+VehicleCost);
                    TotalAccessoriesCost = Math.min(50000, AccessoriesCost);
                    TotalVehicleCost =(VehicleCost + RegistrationCost + TotalAccessoriesCost + InsuranceCost);
                    System.debug('**TotalVehicleCost'+TotalVehicleCost);
                    Decimal Pmax1 = 0.00;                    
                    Decimal Pmax = 0.00;
                    Integer NmaxTW = 0; 
                    Decimal AddIncome1 = 0;
                    clcommon__Collateral__c colupdate=new clcommon__Collateral__c();
                    colupdate.Vehicle_CalculatedValue__c=string.valueOf(TotalVehicleCost);  
                    colupdate.Id=colid;
                    collist.add(colupdate);
                    System.debug('collist'+collist);
                    if(SelectedScheme.size() > 0){
                        Pmax1 = (SelectedScheme[0].LTV_increase__c*TotalVehicleCost)/100;
                        ROI = (ROI - SelectedScheme[0].Pricing_Discount__c); 
                    }else{
                        Pmax1 = (Constants.VL4WEQUL_VL90PRCNT*TotalVehicleCost);
                    }
                    System.debug('**Pmax1 VL4W'+Pmax1);
                    for(genesis__Application_Parties__c PT : App.genesis__Application_Parties__r){
                        Decimal NmiClaimed = 0.0;
                        Decimal EMICal = 0.0;
                        
                        if(PT.Financial_Applicant__c){
                            NmaxTW = Math.min(84,(840-Integer.ValueOf(PT.Age_In_Months__c)));
                        }else{
                            NmaxTW = Math.min(84,(960-Integer.ValueOf(PT.Age_In_Months__c))); 
                        }
                        NmaxTWList.add(NmaxTW);
                        System.debug('Nmax4W'+NmaxTW);
                        if(PT.Financial_Applicant__c){
                            if(PT.Employment_Types__c == Constants.EMPTYP_AGRICULTUR){
                                AddIncome1 = 0;
                                if(PT.Net_Monthly_Income__c < Decimal.ValueOf(Label.VL_NMI_SLAB)){
                                    NmiClaimed =  PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c*0.60 : 0;
                                }
                                else{
                                    NmiClaimed =  PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c *0.75: 0;
                                    
                                }
                            }
                            else if(PT.Employment_Types__c != Constants.EMPTYP_AGRICULTUR){
                                AddIncome1 = PT.Additional_Income_Amount1__c != null ? PT.Additional_Income_Amount1__c : 0;
                                Double minVal =  PT.Net_Monthly_Income__c != null ? PT.Net_Monthly_Income__c : 0;
                                if(PT.Net_Monthly_Income__c< Decimal.ValueOf(Label.VL_NMI_SLAB)){
                                    NmiClaimed = NMICalcu(minVal,AddIncome1)*0.60;
                                }
                                else{
                                    NmiClaimed = NMICalcu(minVal,AddIncome1)*0.75;
                                    
                                }  
                            }    
                            System.debug('*NmiClaimed'+NmiClaimed);
                            ExistingEMI = PT.Max_Existing_EMI__c != null ? PT.Max_Existing_EMI__c : 0 ;
                            System.debug('**ExistingEMI'+ExistingEMI);
                            if(NmiClaimed>ExistingEMI){
                                EMICal =NmiClaimed- ExistingEMI;    
                            }else{
                                EMICal = 0;
                            }
                        }
                        EMIMax += EMICal;
                    }
                    
                    NmaxTWList.sort();
                    System.debug('**EMIMax 4W'+EMIMax);
                    App.EMI_Max__c = EMIMax;
                    App.genesis__Interest_Rate__c = ROI;
                    App.Nmax__c = NmaxTWList[0];
                    App.PMax1__c = Pmax1;
                    App.Max_CIBIL_Score__c = MaxCiblScore;
                    App.BankYear__c = MaxBankWithUS;
                } //End of 4 Wheeler loan ---------------------------------------------------------------------
                system.debug(' App.PMax1__c'+ App.PMax1__c);
                system.debug(MaxCiblScore);
                UpdateAppList.add(App);
            }
            system.debug('******'+UpdateAppList+'#####'+AcclISt);
            //UPDATE updateListNew;
            update UpdateAppList;
            update AcclISt;
            update collist;
        }
        catch(exception e){
            system.debug('error'+e.getMessage()+'line Number'+e.getLineNumber());
            HandleBusinessException.captureError('ApplicationEligibiltyHandler','getEmi_LTV_ROIValues', e);
        } 
    }
    
    public static Decimal getMCLR(Integer Month,string Cat,Integer score){
        if(Cat==null && score==null){
            return[select COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=:Month limit 1].MCLR_Of_Interest__c;
        }
        else{
            //return[select     FInal_Interest__c,  Cibil_Score__c from MCLR_Master__c where Retail_Category__c=:Cat  and   Cibil_Score__c=:score].FInal_Interest__c;
            SYSTEM.debug('Integer Month,string Cat,Integer score:-----'+Month+Cat+ score);
            
            Decimal MCLRInt = [select COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=:Month limit 1].MCLR_Of_Interest__c;
            Decimal MCLR_Excess_Code = [Select ID,Excess__c,Retail_Category__c,Product_Name__c,From_CIBIL__c from MCLR_Excess_Code__c where Retail_Category__c =:Cat AND From_CIBIL__c=:score AND Product_Name__c=:Constants.LAPLOAN Limit 1].Excess__c;
            Decimal TotalMCLR = MCLRInt + MCLR_Excess_Code;
            return TotalMCLR;
        }
    }
    
    public static integer NmaxCalculation(Integer age,Boolean Fa,string Recordtype, Boolean CoCheck){
        Integer Nm;
        Integer ageVal;
        if(CoCheck == true){
            ageVal = 900;
        }else if(CoCheck == false){
            ageVal = 840;
        }
        if(Recordtype==Constants.HOMELOAN){
            if(Fa==true){
                Nm=Math.min(300,(ageVal-age)); //change added
            }
            else if(Fa==false){
                Nm=Math.min(300,(960-age));
            }
        }
        else if(Recordtype==Constants.LAPLOAN){
            if(Fa==true){
                Nm=Math.min(100,(840-age)); //change added
            }
            else if(Fa==false){
                Nm=Math.min(100,(960-age));
            }
        }
        
        
        
        return Nm;
    }
    public static Double NMICalcu(Decimal NMITR,Decimal AddIncome){
        Double EMI=(NMITR+math.Min(((NMITR/0.7)*0.3),(math.Min((200000/12),(AddIncome/12)))));
        return EMI;
    }
    //Return Retail category 
    public static String getRetailCatagory(List<clcommon__Collateral__c> collList){
        String  retailCatagary = '';
        Set<String> CitySet = new Set<String>();
        Set<String> setStrg = new Set<String>();
        if(collList.size()>0){
            for(clcommon__Collateral__c col : collList){
                if(col.clcommon__City__c != null){
                    CitySet.add(col.clcommon__City__c);
                }
            }
            List<Branch_Master__c> BranchList = [select id,CODCCBRN__c,Retail_Category__c,NAMCCCITY__c from Branch_Master__c where NAMCCCITY__c IN: CitySet];
            if(BranchList.size()>0){
                for(Branch_Master__c branch : BranchList){                        
                    if(branch.Retail_Category__c != null){
                        setStrg.add(branch.Retail_Category__c);
                    }                        
                }                    
            }         
            system.debug('$$$$'+setStrg);
            if(setStrg.size()>0){
                if(setStrg.contains('C')){
                    retailCatagary = 'C';
                }else if(setStrg.contains('B')){
                    retailCatagary = 'B';
                }else if(setStrg.contains('A')){
                    retailCatagary = 'A';
                }
            }
        }
        return retailCatagary;
    }
    public static mclr MclrCalc(integer Month,string ProdName,string Cat,Integer score,string EType){
        system.debug('integer Month,string ProdName,string Cat,Integer score,string EType'+ Month+ ProdName+ Cat+ score+ EType);
        mclr m=new mclr();
        m.Excess=[select id,Employment_Type__c,Excess__c,From_CIBIL__c,Product_Name__c,Retail_Category__c from MCLR_Excess_Code__c where Retail_Category__c =:Cat AND From_CIBIL__c=:score AND Product_Name__c=:ProdName AND Employment_Type__c=:EType  Limit 1 ].Excess__c;
        m.IntRate=[select id,COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=:Month limit 1].MCLR_Of_Interest__c;
        system.debug('Test1232@@@@@@'+M);
        return m;
    }
    //vehicle details start
    public static mclr MclrCalcVL(integer Month,string ProdName,string Cat,Integer score,string EType){
        mclr m=new mclr();
        system.debug('Month:-'+Month);
        // m.Excess=[select id,Employment_Type__c,Excess__c,From_CIBIL__c,Product_Name__c,Retail_Category__c from MCLR_Excess_Code__c where Retail_Category__c =:Cat AND From_CIBIL__c=:score AND Product_Name__c=:ProdName AND Employment_Type__c=:EType  Limit 1 ].Excess__c;
        m.IntRate=[select id,COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=:Month limit 1].MCLR_Of_Interest__c;
        system.debug('Test1232@@@@@@'+M);
        return m;
    }//end vehicle details
    public class Mclr{
        public decimal Excess;
        public decimal IntRate;
    }
    
}