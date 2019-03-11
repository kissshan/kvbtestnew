/*
* Name    : Retry_Task_call
* Company : ET Marlabs
* Purpose : This class will be used to re call the eligibility calculation and BRE.
* Author  : Subas
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
v1.1        22-Aug-2018     Braj            Addition in validation rule for Vehicle Loan and addition of field in query
v1.2        31-Aug-2018     Braj            #VL717:2nd and 3rd Rejection scenario added for vehicle loan
v1.3        03-Sep-2018     Venu            Adding Astute conditions for HL
v1.4        08-Oct-2018     Braj            New task validation added for VL name 'Generate dealer document'
v1.5        09-oct-2018     prashant        added two task Verify KYC for New to Bank Customers AND Approve KYC Data for Changes New to Bank Customers for all products
v1.6        20-Oct-2018     Braj            New task creation/validation and initiate CBS api call added for HL,LAP,PL,VL
v1.7        18-oct-2018     Venu            Validate the Kyc task
v1.8        23-oct-2018     Venu            Changing the FI positivee scenraio logics
v2.0        30-oct-2018     Braj            Changed IsFirstRun from fasle to True
v2.1        12-dec-2018     Niladri         RMD related task for pl
v2.3        20-dec-2018     Braj            'Verify FI rejection' and 'Approve FI' task validation condition changed and added fi status 'manual'(All),'Not Applicable'(Except PL);Removed 'Verify FI rejection' task and fi status 'fraud' for rerun for all retail products; Added application stage 'Deactivated Applications'& 'Application Rejected' to skip validation for task closure of rejected and deactivated application
v2.4        16-jan-2019     prashant        changing task name as per requirement
v2.5        31-jan-2019     Braj            HL MVP2 New Task validation
v2.6        01-Feb-2019     Venu            TReimbursement and  Take over Trigger points
v2.7        19-Feb-2019     Venu            Top Up validations
*******************************************************************************************/
public class Retry_Task_call {
    public static void recallTask(Task tsk){
        recallTasknew(tsk,False,null);
    }
    public static String appid;
    public static void recallTasknew(Task tsk, Boolean ReRun, String appsId){
        try{
            
            if(tsk != null){
                appid = tsk.WhatId;
            }else{
                appid = appsId;
            }
            //removed--collateral structure changes----on 29-11-2018--Cost_Of_Land__c...
            List<genesis__Applications__c> listapp =[select id,Sub_Type__c,genesis__Account__c,genesis__Account__r.PersonMailingPostalCode,GMRA_Amount__c,Is_GMRA_Policy_Selected__c,Pre_approved_flag__c,Retail_BRE_Hit__c, genesis__CL_Product__c,
                                                     Sub_Stage__c,  Branch_Code__c, PMax__c , PMin__c, FI_Status__c, Total_Cheque_Bounces__c, Application_Stage__c, Record_Type_Name__c, PreClosure_Interest_Rate__c,
                                                     Holiday_Period__c,Preclosure_Charges__c,Penal_Interest__c,genesis__Interest_Calculation_Method__c,
                                                     Sanction_Amount_Words__c,ValidateTask__c,Sanctioned_EMI__c, Sanctioned_Tenure__c, Sanction_Authority_Limit__c, genesis__Payment_Amount__c,
                                                     MCLR_Type__c, genesis__Margin__c, Interest_Variation__c, genesis__Loan_Amount__c, genesis__Term__c, Excess_MCLR__c, 
                                                     Loan_Purpose__c,   genesis__Interest_Rate__c,  Maturity_Time__c, NMI_Approved__c,genesis__CL_Product__r.Existing_Margin__c,
                                                     (select id, genesis__Party_Type__c, Additional_Income_Amount1__c, Total_Annual_other_Income_Approved__c,
                                                      Employment_Types__c,NMI_Approved__c, Approved_NMI_From_ITR__c, NMI_Claimed_By_Customer__c,Age__c, Existing_Emis__c, Financial_Applicant__c, Agriculture2__c, Net_Monthly_Income__c,
                                                      Max_Existing_EMI__c from genesis__Application_Parties__r where Active__c=true),
                                                     (select id,clcommon__City__c,Cost_Of_Flat_House__c,Total_Market_value__c,Cost_Of_Repair__c,Market_valueProposedRepairs_Renovation__c,Market_value_Proposed_Repair_Renovation2__c,Cost_Of_Construction__c,
                                                      Market_Value_Of_The_Building__c,Market_Value_Of_The_Building2__c,Cost_Of_Land__c,Cost_of_Property__c,Age_Of_The_Building__c,Residual_Life_of_Property__c,Approved_Cost_incurred_in_last_6_Months__c,Total_cost_incurred_till_date__c,Valuation_Applicable__c,Double_Valuation_Charge__c from genesis__Collaterals__r where Active__c=true),
                                                     (select id,Approved_Takeover_Outstanding_Loan_Tenur__c,Existing_HL_Sanctioned_Amount__c,Takeover_Outstanding_Loan_Tenure_months__c,Existing_HL_Outstanding_Tenure__c,Approved_Takeover_Outstanding_Loan_Amoun__c,Existing_HL_Oustanding_Balance__c,Approved_Takeover_Loans_EMI__c,Takeover_Outstanding_Loan_Amount__c from Facilities__r where Selected_for_Top_Up__c=:true) from genesis__Applications__c where ID =: appid];//v2.6
            
            if(listapp.size() > 0 && tsk != null){ 
                //Home Loan Eligibility Re run Start here
                if(((tsk.Subject =='Approve income' || tsk.Subject =='Legal Clearance' || tsk.Subject =='Approve FI' || tsk.Subject =='Approve score deviation' || tsk.subject=='Approve KYC' || tsk.Subject =='Approve property details' || (listapp[0].Sub_Type__c==Constants.Sub_Type_Take_Over && (tsk.Subject =='Approve Take Over Details' ||  tsk.Subject =='Verify Loan Application' || tsk.Subject =='Collect Additional Documents')) || (listapp[0].Sub_Type__c==Constants.Sub_Type_Reimbursement && tsk.Subject =='Approve Expenses incurred') || (listapp[0].Sub_Type__c==Constants.Sub_Type_Top_Up && tsk.Subject =='Approve Top Up Details')) && (listapp[0].FI_Status__c <> Constants.PL_FIREQ_INIT && listapp[0].FI_Status__c <> Constants.PL_FIRES_OBTN)) && listapp[0].Record_Type_Name__c == Constants.HOMELOAN && listapp[0].Sub_Stage__c == Constants.TermsAccepted){//v2.3  //v2.4 //v2.6                    
                    List<Task> tskList = new List<Task>();
                    List <String> completeList = new List<String>();
                    List <String> incompleteList = new List<String>();
                    tskList = [Select Id,WhatID,Status,Subject From Task Where WhatID IN: listapp];
                    System.debug('***tskList***'+tskList);
                    for(Task tk : tskList){
                        if(tk.Status =='Completed'){
                            completeList.add(tk.Subject);
                        }
                        if(tk.Status !='Completed'){
                            incompleteList.add(tk.Subject);
                        }
                    }
                    //removed completeList.contains('Approve income')---prashant singh
                    if(incompleteList.size() == 0 ){
                        
                        calculateEligibility(listapp[0],null);
                    }
                }
                //Home Loan Eligibility Re run End Here
                
                //Personal Loan Eligibility Re run Start here
                if(((tsk.Subject =='Assess Income' || tsk.Subject =='Assess Additional income' || tsk.Subject =='Approve income' || tsk.Subject =='Approve FI' || tsk.subject=='Approve KYC' || tsk.subject=='RMD Application Review' ||ReRun) && (listapp[0].FI_Status__c <> Constants.PL_FINOTAPPLICABLE && listapp[0].FI_Status__c <> Constants.PL_FIREQ_INIT && listapp[0].FI_Status__c <> Constants.PL_FIRES_OBTN)) && listapp[0].Record_Type_Name__c == Constants.PERSONALLOAN && listapp[0].Sub_Stage__c == Constants.TermsAccepted){//v2.3
                    List<Task> tskList = new List<Task>();
                    List <String> completeList = new List<String>();
                    List <String> incompleteList = new List<String>();
                    List<genesis__Applications__c> listappReCheck = new List<genesis__Applications__c>();
                    tskList = [Select Id,WhatID,Status,Subject From Task Where WhatID =: listapp[0].Id];
                    System.debug('**tasklist'+tskList);
                    Boolean DuplicateTaskCheck =true;
                    for(Task tk : tskList){
                        if(tk.Subject=='RMD Application Review'){
                            DuplicateTaskCheck =false;
                        }
                        if(tk.Status =='Completed'){
                            completeList.add(tk.Subject);
                        }
                        if(tk.Status !='Completed'){
                            incompleteList.add(tk.Subject);
                        }
                    }
                    
                    if((incompleteList.size() == 0)|| ReRun){
                        genesis__Applications__c appdetails=[select id,Sub_Stage__c,Branch_Code__c,genesis__Loan_Amount__c from genesis__Applications__c where id=:appid];
                        if(DuplicateTaskCheck){
                            // RMD Task start---v2.2
                            List<genesis__Application_Parties__c> partyList= [select id,Age__c,Employment_Types__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,CIBIL_Scores__c from genesis__Application_Parties__c  where genesis__Application__c=:appid];
                            System.debug('**partylist RMD'+partylist);
                            Decimal YearCount = 0.00;
                            if(partyList[0].genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c !=null){
                                Date customerCreationDate=partyList[0].genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c; 
                                YearCount =( (customerCreationDate.daysBetween(System.today()))/365.2425);
                            }
                            System.debug('**YearCount'+YearCount); 
                            Decimal YearRounded = YearCount.setScale(2, RoundingMode.HALF_UP);
                            System.debug('**YearRounded'+YearRounded);
                            
                            Boolean check=false; 
                            genesis__Applications__c app1=new genesis__Applications__c();
                            app1.id=appid;
                            String usrId = TaskFlow_Helper.getUserList(appdetails.Branch_Code__c,'RMD officer');
                            if(YearRounded< Constants.PlNTB && partyList[0].Age__c > Constants.Plage ){
                                check=true; 
                                app1.genesis__Call_Code__c ='NTB applicant age greater than 55';  
                            }
                            if(YearRounded< Constants.PlNTB && partyList[0].Employment_Types__c!=Constants.EMPTYP_SALARIED  && appdetails.genesis__Loan_Amount__c> Constants.PlLoanamount) {
                                check=true; 
                                app1.genesis__Call_Code__c =' NTB non-salaried applicant with loan amount greater than 5,00,000';
                            }
                            if(YearRounded< Constants.PlNTB && partyList[0].Employment_Types__c!=Constants.EMPTYP_SALARIED  && partyList[0].CIBIL_Scores__c < Constants.Plcibil){
                                check=true; 
                                app1.genesis__Call_Code__c ='NTB non-salaried applicant with CIBIL score less than 750';     
                            }
                            
                            if(usrId != null && check ){
                                TaskFlow_Helper.creatTaskAll(appdetails.Id, usrId, 'RMD Application Review', 1);        
                            }
                            if(check){
                                ApplicationTriggerHandler.IsFirstRun = false;
                                System.debug('**app1'+app1);
                                update app1;
                            }
                            else{                                
                                calculateEligibilityPL(listapp[0],null);
                                
                            }
                            // RMD Task end---2.2
                        }
                        else{
                            if(appdetails.Sub_Stage__c!='RMD Rejected'){
                                System.debug('RMD rerun call  >>> ');
                                calculateEligibilityPL(listapp[0],null);
                            }
                        }
                    }
                }
                //Personal Loan Eligibility Re run End here
                
                //LAP Loan Eligibility Re run Start here
                if(((tsk.Subject == 'Approve income' || tsk.Subject == 'Legal clearance' || tsk.Subject == 'Approve FI' || tsk.Subject == 'Approve associated business entity' || tsk.subject=='Approve KYC' || tsk.subject=='Approve property details' ||ReRun) && (listapp[0].FI_Status__c <> Constants.PL_FIREQ_INIT && listapp[0].FI_Status__c <> Constants.PL_FIRES_OBTN)) && listapp[0].Record_Type_Name__c == Constants.LAPLOAN && listapp[0].Sub_Stage__c == Constants.TermsAccepted){//v2.3 //v2.4
                    List<Task> tskList = new List<Task>(); 
                    List <String> completeList = new List<String>();
                    List <String> incompleteList = new List<String>();            
                    tskList = [Select Id,WhatID,Status,Subject From Task Where WhatID IN: listapp];
                    System.debug('***tskList***'+tskList);
                    for(Task tk : tskList){
                        if(tk.Status =='Completed'){
                            completeList.add(tk.Subject);
                        }
                        if(tk.Status !='Completed'){
                            incompleteList.add(tk.Subject);
                        }
                    }
                    //removed  Approve FI,Legal clearance,Approve income,Verify FI rejection
                    if((incompleteList.size() == 0)|| ReRun){
                        calculateEligibilityLAP(listapp[0],null);
                    }            
                }
                //LAP Loan Eligibility Re run End here
                
                //Vehicle Loan Eligibility Re run Start here
                if(((tsk.Subject == 'Approve income' || tsk.Subject == 'Approve FI' || tsk.subject=='Approve KYC' || ReRun)&& (listapp[0].FI_Status__c <> Constants.PL_FIREQ_INIT && listapp[0].FI_Status__c <> Constants.PL_FIRES_OBTN)) && (listapp[0].Record_Type_Name__c == Constants.VL4W || listapp[0].Record_Type_Name__c == Constants.VL2W) && listapp[0].Sub_Stage__c == Constants.TermsAccepted){//v2.3
                    List<Task> tskList = new List<Task>();
                    List <String> completeList = new List<String>();
                    List <String> incompleteList = new List<String>();            
                    tskList = [Select Id,WhatID,Status,Subject From Task Where WhatID IN: listapp];
                    System.debug('***tskList***'+tskList);
                    for(Task tk : tskList){
                        if(tk.Status =='Completed'){
                            completeList.add(tk.Subject);
                        }
                        if(tk.Status !='Completed'){
                            incompleteList.add(tk.Subject);
                        }
                    }
                    if((incompleteList.size() == 0)|| ReRun){
                        System.debug('in side vl rerun');
                        Retry_Task_call_VL.RecalculateEligibilityVL(listapp[0],null);
                    }            
                }
                //Vehicle Loan Eligibility Re run End here
                
                if(tsk != Null){
                    /*if(tsk.Subject == 'SI/ E-mandate' && tsk.Status == 'Completed' && listapp[0].Record_Type_Name__c == Constants.LAPLOAN){
genesis__Applications__c app = new genesis__Applications__c();
app.Id = listapp[0].ID;
app.Application_Stage__c = 'Disbursed Application';
app.Sub_Stage__c = 'Application Processed - Closed';
app.Retry_CBS__c = true;
update app;
}*/
                    if(tsk.Subject == 'Initiate MOD' && tsk.Status == 'Completed' && listapp[0].Record_Type_Name__c == Constants.LAPLOAN){
                        genesis__Applications__c app = new genesis__Applications__c();
                        app.Id = listapp[0].ID;
                        app.Sub_Stage__c = 'MOD Initiated';
                        update app;
                    }
                }
            }
            // v1.8 start
            if(ReRun && listapp.size() > 0 && tsk == null){
                // PL
                if(listapp[0].Record_Type_Name__c == Constants.PERSONALLOAN)
                    calculateEligibilityPL(listapp[0],null);
                // Home Loan
                if(listapp[0].Record_Type_Name__c == Constants.HOMELOAN)
                    calculateEligibility(listapp[0],null);
                // LAP
                if(listapp[0].Record_Type_Name__c == Constants.LAPLOAN)
                    calculateEligibilityLAP(listapp[0],null);
                // VL2W or VL4W
                if(listapp[0].Record_Type_Name__c == Constants.VL4W || listapp[0].Record_Type_Name__c == Constants.VL2W )
                {   System.debug('in side vl rerun FI Positive');
                 Retry_Task_call_VL.RecalculateEligibilityVL(listapp[0],null);
                }
            }
            // v1.8 End
        }
        catch(exception e){
            System.debug('Errror LineNumber>>'+e.getLineNumber()+'message>>'+e.getMessage()+'trace Tracking>>'+e.getStackTraceString());
            HandleBusinessException.captureError('Retry_Task_call', 'recallTasknew', e);
        }
    }
    // PL re run eligibility call-----------
    public static Void calculateEligibilityPL(genesis__Applications__c application,String checkCal){
        try{
            String Stage = '';
            Integer ETerm = 0;
            Decimal loanSan = 0;
            Decimal emiSan = 0;
            Decimal MaxLoanamt = 0;
            Decimal PMAX1 =0;
            Decimal PMAX2 =0;
            Decimal EMIMAX = CallEMIPL(application);
            Decimal FinalGMRA=0.00;
            Decimal NmaxPL = application.genesis__Term__c > 36 ? 36 : application.genesis__Term__c;
            PMAX2 =(EMIMAX*((Math.exp( NmaxPL*(Math.log((1+((application.genesis__Interest_Rate__c /12)/100))))))-1)) / ((( application.genesis__Interest_Rate__c /12)/100)*(Math.exp( NmaxPL* (Math.log((1+(( application.genesis__Interest_Rate__c /12)/100)))))));
            NumberToWordConversion ntwc = new NumberToWordConversion();
            for(genesis__Application_Parties__c parties:application.genesis__Application_Parties__r){
                if(parties.genesis__Party_Type__c == Constants.PRIMARY_APP){
                    if(parties.Employment_Types__c==Constants.EmpType_Salaried){
                        PMAX1=12 * (parties.NMI_Approved__c - parties.Existing_Emis__c);
                    }else { 
                        PMAX1=36 * (parties.NMI_Approved__c); //updated on 2018-07-01
                    }
                }
            }  
            MaxLoanamt = math.min((PMAX1 != null ? PMAX1 : 0),(PMAX2 != null ? PMAX2 : 0));
            MaxLoanamt = MaxLoanamt >= 0 ? MaxLoanamt : 0; // added to hnadel -ve values
            MaxLoanamt = conversion(MaxLoanamt);
            System.debug('NEW EMI : '+EMIMAX+ 'PMAx1 --> '+ PMAX1 +'PMAx2-->  '+ PMAX2+ 'MaxLoanamt -----------> '+MaxLoanamt);
            genesis__Applications__c appsupdt = new genesis__Applications__c();
            appsupdt = application.clone(true,true,false,false);
            // Changed pmax to recalculated max loan amount 
            System.debug('MaxLoanamt =='+MaxLoanamt+'application.genesis__Loan_Amount__c=='+application.genesis__Loan_Amount__c);
            
            if(MaxLoanamt < application.PMin__c  && application.Record_Type_Name__c == Constants.PERSONALLOAN){
                System.debug('##### application.PMax__c < 50000 '+MaxLoanamt);
                if(application.Is_GMRA_Policy_Selected__c){
                    FinalGMRA=GmraCal.Gmra1(application.id,MaxLoanamt,EMIMAX);
                }
                appsupdt.Sanction_Authority_Limit__c = conversion(MaxLoanamt)+FinalGMRA;
                appsupdt.Disbursement_Amount__c=conversion(MaxLoanamt);
                appsupdt.Final_GMRA__c=FinalGMRA;
                appsupdt.Sanction_Amount_Words__c = ntwc.getNumberTOWordConvertion(appsupdt.Sanction_Authority_Limit__c);
            }
            if(MaxLoanamt >= (application.genesis__Loan_Amount__c- (application.GMRA_Amount__c != null ? application.GMRA_Amount__c : 0))){
                
                if(application.Is_GMRA_Policy_Selected__c){
                    FinalGMRA=GmraCal.Gmra1(application.id,(application.genesis__Loan_Amount__c - (application.GMRA_Amount__c != null ? application.GMRA_Amount__c : 0)),EMIMAX);
                    
                }
                appsupdt.Sanction_Authority_Limit__c = conversion((application.genesis__Loan_Amount__c-(application.GMRA_Amount__c != null ? application.GMRA_Amount__c : 0)))+FinalGMRA;
                appsupdt.Final_GMRA__c=FinalGMRA;
                appsupdt.Disbursement_Amount__c=conversion(application.genesis__Loan_Amount__c-(application.GMRA_Amount__c != null ? application.GMRA_Amount__c : 0));
                appsupdt.Sanction_Amount_Words__c = ntwc.getNumberTOWordConvertion(appsupdt.Sanction_Authority_Limit__c);
                //change
                appsupdt.Sanctioned_Tenure__c = application.genesis__Term__c;
                appsupdt.Sanctioned_EMI__c = EMIMAX;
                //
            }else{
                String usrId = TaskFlow_Helper.getUserList(application.Branch_Code__c,'Branch manager');
                if(usrId != null){
                    TaskFlow_Helper.creatTaskAll(application.Id, usrId, 'Validate sanction at re-calculated eligibility', 2);                            
                }
                if(application.Is_GMRA_Policy_Selected__c){
                    FinalGMRA=GmraCal.Gmra1(application.id,MaxLoanamt,EMIMAX);
                }
                appsupdt.Sanction_Authority_Limit__c = conversion(MaxLoanamt)+FinalGMRA;
                appsupdt.Disbursement_Amount__c= conversion(MaxLoanamt);
                appsupdt.Final_GMRA__c=FinalGMRA;
                appsupdt.Sanction_Amount_Words__c = ntwc.getNumberTOWordConvertion(appsupdt.Sanction_Authority_Limit__c);   
                //change
                appsupdt.Sanctioned_Tenure__c = application.genesis__Term__c;
                appsupdt.Sanctioned_EMI__c = EMIMAX;
                //
            }
            ApplicationTriggerHandler.IsFirstRun = true;//v2.0
            //appsupdt.id=application.id;
            //appsupdt.Retail_BRE_Hit__c=application.Retail_BRE_Hit__c;
            // PL score card extra add
            //appsupdt.genesis__Account__c = application.genesis__Account__c;
            //appsupdt.genesis__Account__r.PersonMailingPostalCode = 

            if(checkCal == '3' || checkCal == 'VEPL'){
                //BREScoreCal.Calculate_Bre(appsupdt,MaxLoanamt,EMIMAX,checkCal); //v1.9
                BRE_ScoreCalExperian.BRE_ScoreCalExp(appsupdt,checkCal);
            }else{
                //BREScoreCal.Calculate_Bre(appsupdt,MaxLoanamt,EMIMAX,'');
                BRE_ScoreCalExperian.BRE_ScoreCalExp(appsupdt,'');
            } 
            //update appsupdt;
            //System.debug('application:::'+application);
            
        }catch(Exception e){
            System.debug('##### Error in calculateEligibilityPL Class '+e.getMessage() +'  '+e.getLineNumber());
            HandleBusinessException.captureError('Retry_Task_call', 'calculateEligibilityPL', e);
        }
    }
    public static Decimal CallEMIPL(genesis__Applications__c Appl){
        Decimal EMI=0;
        decimal EMI1=0;
        Decimal NMI = 0;
        Decimal NMIITR = 0;
        Decimal MinEMI = 0;
        Decimal AddIncome=0;
        List<genesis__Application_Parties__c> updateApproEMIPL = new list<genesis__Application_Parties__c>(); 
        for(genesis__Application_Parties__c parties:Appl.genesis__Application_Parties__r){
            System.debug('parties.genesis__Party_Type__c:--'+parties.genesis__Party_Type__c);
            
            if(parties.genesis__Party_Type__c == Constants.PRIMARY_APP){
                NMI = parties.NMI_Approved__c;
                NMIITR = parties.Approved_NMI_From_ITR__c;
                AddIncome = parties.Total_Annual_other_Income_Approved__c;
                System.debug('NMI:::'+NMI);
                if(parties.Financial_Applicant__c){
                    // Nmax
                    if(parties.Employment_Types__c==Constants.EmpType_Salaried){
                        if(NMIITR < 50000 && NMIITR>=25000){
                            EMI =ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.55; //EMI=NMI*0.55;   //EMI=NMI*0.60; updated on 2018-06-29
                        }       
                        else if(NMIITR>=50000){
                            EMI =ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.65;   //EMI=NMI*0.65;   //EMI=NMI*0.70; updated on 2018-06-29
                        }
                    }
                    else if(parties.Employment_Types__c==Constants.EmpType_Agricul){
                        EMI=NMI*0.50;
                    }else{
                        EMI=ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.50; //EMI=NMI*0.50; // EMI=NMI*0.70; updated on 2018-06-29
                    }
                    if(parties.Existing_Emis__c!=null){
                        EMI= EMI-parties.Existing_Emis__c;
                        if(EMI<0){
                            EMI=0;
                        }
                    }
                    
                    MinEMI = EMI;
                    genesis__Application_Parties__c P=New genesis__Application_Parties__c(); 
                    P.id=parties.id;
                    P.Approve_Elgibile_EMI__c= MinEMI;
                    updateApproEMIPL.add(p);
                }
            }
        }
        if(updateApproEMIPL!=null && updateApproEMIPL.size()>0){
            update  updateApproEMIPL;
        }
        return MinEMI;   
    }   
    // PL Rerun eligibility END here
    public static Void calculateEligibility(genesis__Applications__c application,String checkCal){
        try{
            //prashant singh on 21-11-2018 collateral structure changes for home loan... 
            //added clcommon__Collateral__c Collateral and tags changes
            //clcommon__Collateral__c Collateral= [Select Id,Residual_Life_of_Property__c,Age_Of_The_Building__c from clcommon__Collateral__c Where genesis__Application__c =: application.Id  and Active__c=true limit 1];
            String Stage = '';
            Integer ETerm = 0;
            Decimal loanSan = 0;
            Decimal emiSan = 0;
            Decimal MaxLoanamt = 0;
            BREScoreCal.IntRateCal Intrest= BREScoreCal.HL_Intrate(application);
            decimal IntRate_Latest=Intrest.IntRate;
            System.debug('IntRate_Latest'+IntRate_Latest);
            application.genesis__Interest_Rate__c=IntRate_Latest;
            
            Decimal EMIMAX = CallEMI(application);
            System.debug('EMIMAX'+EMIMAX);
            MaxLoanamt =(EMIMAX*((Math.exp(application.genesis__Term__c *(Math.log((1+((IntRate_Latest/12)/100))))))-1)) / ((( IntRate_Latest /12)/100)*(Math.exp(application.genesis__Term__c * (Math.log((1+(( IntRate_Latest /12)/100)))))));
            System.debug('MaxLoanamt'+MaxLoanamt);
            
            if((application.genesis__Loan_Amount__c - (application.GMRA_Amount__c != null ? application.GMRA_Amount__c : 0)) > MaxLoanamt){
                //if(application.ValidateTask__c){
                String usrId = TaskFlow_Helper.getUserList(application.Branch_Code__c,'Branch manager');
                if(usrId != null){
                    TaskFlow_Helper.creatTaskAll(application.Id, usrId, 'Validate sanction at re-calculated eligibility', 1);
                } 
                // }   
            }else{
                String appStage = '';
                MaxLoanamt = application.genesis__Loan_Amount__c - (application.GMRA_Amount__c != null ? application.GMRA_Amount__c : 0); //GMRA
                //COLLATERAL STRUCTUTE CHANGES
                if(application.genesis__Collaterals__r[0].Age_Of_The_Building__c >= 30 && application.genesis__Collaterals__r[0].Age_Of_The_Building__c  <= 50 && application.genesis__Collaterals__r[0].Residual_Life_of_Property__c != null && application.genesis__Collaterals__r[0].Residual_Life_of_Property__c != 0){
                    Decimal Term = ((application.genesis__Collaterals__r[0].Residual_Life_of_Property__c/1.5).round());
                    if(integer.valueOf(Term) >= application.genesis__Term__c){
                        application.Sanctioned_Tenure__c = application.genesis__Term__c;
                    }else{
                        application.Sanctioned_Tenure__c=integer.valueOf(Term);
                    }
                }else{
                    application.Sanctioned_Tenure__c = application.genesis__Term__c;
                }
                if(!Utility.ISStringBlankorNull(string.valueOf(application.Sanctioned_Tenure__c))){
                    if(!Utility.ISStringBlankorNull(application.Sub_Type__c) && application.Facilities__r!=null &&  application.Facilities__r.size()>0){
                        if(application.Sub_Type__c==Constants.Sub_Type_Take_Over ){
                            if(!Utility.ISStringBlankorNull(string.valueof(application.Facilities__r[0].Approved_Takeover_Outstanding_Loan_Tenur__c)))
                                application.Sanctioned_Tenure__c=math.min(application.Sanctioned_Tenure__c,application.Facilities__r[0].Approved_Takeover_Outstanding_Loan_Tenur__c);
                        }
                        else if(application.Sub_Type__c==Constants.Sub_Type_Top_Up){
                            if(!Utility.ISStringBlankorNull(string.valueof(application.Facilities__r[0].Existing_HL_Outstanding_Tenure__c)))
                                application.Sanctioned_Tenure__c=math.min(application.Sanctioned_Tenure__c,application.Facilities__r[0].Existing_HL_Outstanding_Tenure__c);
                        }
                    }
                }
                EMIMAX = application.genesis__Payment_Amount__c;
                //Outside-->// BREScoreCal.Calculate_Bre(application,MaxLoanamt,EMIMAX,''); //Rerun BRE calculation // v1.9
            }
            if(checkCal == '3' || checkCal == 'VEHL'){
                //ApplicationTriggerHandler.IsFirstRun = false;//v3.0
                //IsSecondRun = true;                   
                BREScoreCal.Calculate_Bre(application,MaxLoanamt,EMIMAX,checkCal); //v1.9
            }else{
                //ApplicationTriggerHandler.IsFirstRun = false;//v3.0
                //IsSecondRun = true;
                BREScoreCal.Calculate_Bre(application,MaxLoanamt,EMIMAX,'');
            }     
        }catch(Exception e){
            System.debug('Errror'+e.getLineNumber()+'message'+e.getMessage());
            HandleBusinessException.captureError('Retry_Task_call', 'calculateEligibility', e);
        }
    }
    //Calling from Application Trigger Handler //commented in calling class on 2019-jan-11
    public static void applicationReCal(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        try{
            List <ID> AppIDList = new List<ID>();
            System.debug('appList:-'+appList);
            for(genesis__Applications__c application : appList){
                System.debug('oldList.get(application.Id).sub_stage__c:-'+oldList.get(application.Id).sub_stage__c+'    application.Sub_Stage__c:-'+application.Sub_Stage__c);
                if(oldList.get(application.Id).sub_stage__c <> application.Sub_Stage__c && application.Sub_Stage__c =='All NSTP Processes Completed' && application.Record_Type_Name__c =='Home Loan'){          
                    if(application.Sub_Stage__c == 'All NSTP Processes Completed'){                
                        decimal score = application.Application_Score__c;
                        if(score < 47 && !application.Tripartite_Agreement__c){
                            //application.Sub_Stage__c = 'Low Application Score';
                            application.Sub_Stage__c = Constants.ScoreLowStage;
                            application.Reject_Scenario__c= Constants.ScoreLowStage;
                        }
                        else if(score >= 47 && score <50 && !application.Tripartite_Agreement__c){
                            application.Sub_Stage__c ='All NSTP Processes Completed';
                            application.Reject_Scenario__c= Constants.ScoreLowStage;
                        }
                        else{
                            application.Sub_Stage__c = 'Loan Sanctioned Non-STP';
                            HL_Digio_Service.docGenAndSignDoc(application.Id, Constants.Acknowledgement_For_Sanction);
                        }
                    }
                }
            }
        }Catch(Exception e){
            System.debug('Class name'+e.getStackTraceString()+'Line number'+e.getLineNumber()+'     message:-'+e.getMessage());
            HandleBusinessException.captureError('Retry_Task_call', 'applicationReCal', e);
        }
    }
    
    //Calculate Max EMI
    public static Decimal CallEMI(genesis__Applications__c App){
        Decimal EMI=0;
        decimal EMI1=0;
        Decimal NMI;
        Decimal NMIITR;
        Decimal CoApp_EMI =0;
        Decimal IntProp = 0.00;
        Decimal AddIncome = 0.00;
        System.debug('APP'+App);
        System.debug('hi--'+app.genesis__Application_Parties__r);
        List<genesis__Application_Parties__c> updateApproEMI =new list<genesis__Application_Parties__c>();
        for(genesis__Application_Parties__c parties:app.genesis__Application_Parties__r){
            if(parties.genesis__Party_Type__c == Constants.PRIMARY_APP){
                System.debug('##DataLog### --- > '+ parties);
                AddIncome = parties.Agriculture2__c != null ? parties.Agriculture2__c : 0;
                NMI=parties.NMI_Approved__c;
                NMIITR=parties.Approved_NMI_From_ITR__c;
                if(parties.Financial_Applicant__c){
                    if(parties.Employment_Types__c==Constants.EmpType_Salaried){
                        if(NMIITR<=100000){
                            EMI=ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.70;                    
                        }else if(NMIITR>100000){
                            EMI=ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.75;
                        }
                    }else if(parties.Employment_Types__c == Constants.EmpType_Agricul){
                        if(NMIITR<=66666.67){
                            EMI=NMI*0.70;                    
                        }else if(NMIITR>66666.67){
                            EMI=NMI*0.75;
                        }
                    }else{
                        if(NMIITR<=66666.67){
                            EMI=ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.70;                    
                        }else if(NMIITR>66666.67){
                            EMI=ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.75;                    
                        }
                    }
                    if(parties.Existing_Emis__c!=null){
                        EMI= EMI-parties.Existing_Emis__c;
                        if(App.Sub_Type__c==Constants.Sub_Type_Take_Over && App.Facilities__r !=null && App.Facilities__r.size()>0){
                            EMI=EMI+(App.Facilities__r[0].Approved_Takeover_Loans_EMI__c!=null?App.Facilities__r[0].Approved_Takeover_Loans_EMI__c:0);
                            
                        }
                        if(EMI<0){
                            EMI=0;
                        }
                    }
                    genesis__Application_Parties__c P=New genesis__Application_Parties__c(); 
                    P.id=parties.id;
                    P.Approve_Elgibile_EMI__c= EMI;
                    updateApproEMI.add(p);
                }
            }
        }
        for(genesis__Application_Parties__c parties:App.genesis__Application_Parties__r){
            //  For Co-applicant and Gurantor EMI
            Decimal NMI1;
            Decimal NMIITR1;
            Decimal AddIncome1 = 0.00;
            NMI1=parties.NMI_Approved__c;
            NMIITR1=parties.Approved_NMI_From_ITR__c;
            AddIncome1 = parties.Agriculture2__c != null ? parties.Agriculture2__c : 0;
            
            if(parties.genesis__Party_Type__c==Constants.Co_Borrower  && parties.Financial_Applicant__c){
                
                if(parties.Employment_Types__c==Constants.EmpType_Salaried){
                    if(NMIITR1<=100000){
                        EMI1 =ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome1)*0.70;
                    }
                    else if(NMIITR1>100000){
                        EMI1 =ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome1)*0.75;
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
                else {
                    if(NMIITR1<=66666.67){
                        EMI1=ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome1)*0.70;
                    }
                    else if(NMIITR1>66666.67){
                        EMI1=ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome1)*0.75;
                    }
                }
                if(!Utility.ISStringBlankorNull(string.valueOf(parties.Existing_Emis__c))){                 
                    EMI1= EMI1-parties.Existing_Emis__c ;                      
                    if(App.Sub_Type__c==Constants.Sub_Type_Take_Over && App.Facilities__r !=null && App.Facilities__r.size()>0){
                        EMI1=EMI1+(App.Facilities__r[0].Approved_Takeover_Loans_EMI__c!=null?App.Facilities__r[0].Approved_Takeover_Loans_EMI__c:0);
                        
                    } if(EMI1<0){
                        EMI1=0;
                    }
                }
                genesis__Application_Parties__c P=New genesis__Application_Parties__c(); 
                P.id=parties.id;
                P.Approve_Elgibile_EMI__c= EMI1;
                updateApproEMI.add(p);
            }
            CoApp_EMI=CoApp_EMI+EMI1;
        }  
        Decimal Total_Emi=EMI+CoApp_EMI;
        
        //Pmax calculations 
        Decimal CostProperty;
        Decimal PropertyValue;
        Decimal Pmax;
        //collateral structure changes---on 27-11-2018
        if(App.Loan_Purpose__c==Constants.IdentifiedProperty || App.Loan_Purpose__c==Constants.Loanpurpose){
            CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c;
            PropertyValue=App.genesis__Collaterals__r[0].Total_Market_value__c;
        }
        else if(App.Loan_Purpose__c==Constants.RepairHouse){
            if(App.Sub_Type__c==Constants.Sub_Type_Top_Up){
                CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c;
                PropertyValue=App.genesis__Collaterals__r[0].Total_Market_value__c;
            } else {
                CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Repair__c;
                PropertyValue= App.genesis__Collaterals__r[0].Double_Valuation_Charge__c ? math.min(App.genesis__Collaterals__r[0].Market_valueProposedRepairs_Renovation__c,App.genesis__Collaterals__r[0].Market_value_Proposed_Repair_Renovation2__c) : App.genesis__Collaterals__r[0].Market_valueProposedRepairs_Renovation__c;
            }  
        }
        else if(App.Loan_Purpose__c==Constants.Construction){
            CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Construction__c;
            PropertyValue = App.genesis__Collaterals__r[0].Double_Valuation_Charge__c ? math.min(App.genesis__Collaterals__r[0].Market_Value_Of_The_Building__c,App.genesis__Collaterals__r[0].Market_Value_Of_The_Building2__c) : App.genesis__Collaterals__r[0].Market_Value_Of_The_Building__c;
        }
        else if(App.Loan_Purpose__c==Constants.ConstructionOn){
            CostProperty=App.genesis__Collaterals__r[0].Cost_Of_Land__c + App.genesis__Collaterals__r[0].Cost_Of_Construction__c;
            PropertyValue=App.genesis__Collaterals__r[0].Total_Market_value__c;
        }
        
        Decimal Minvalue;
        if(PropertyValue==null){
            Minvalue=CostProperty;
        }
        else{
            Minvalue=Math.min(CostProperty,PropertyValue);  
        }
        
        if(Minvalue <3750000 && (App.genesis__Collaterals__r[0].Age_Of_The_Building__c <= 1 || App.genesis__Collaterals__r[0].Age_Of_The_Building__c == NULL)){
            Pmax= Math.min(0.90*Minvalue,3000000);
        }
        else if(Minvalue <3750000 && App.genesis__Collaterals__r[0].Age_Of_The_Building__c > 1){
            Pmax = Math.min(0.80*Minvalue,3000000);
        }
        else if(Minvalue>=3750000 && Minvalue<=10000000){
            Pmax = Math.min(0.80*Minvalue,7500000);
        }
        else if(Minvalue>10000000){
            Pmax = 0.75*Minvalue;
        }
        if(!Utility.ISStringBlankorNull(App.Sub_Type__c) ){
            if(App.Sub_Type__c==Constants.Sub_Type_Reimbursement){
                Pmax = Math.min( Pmax,(Minvalue+App.genesis__Collaterals__r[0].Approved_Cost_incurred_in_last_6_Months__c-App.genesis__Collaterals__r[0].Total_cost_incurred_till_date__c));
                Pmax = Pmax>=0?Pmax:0;
            }
            else if(App.Sub_Type__c==Constants.Sub_Type_Top_Up && App.Facilities__r!=null &&  App.Facilities__r.size()>0){
                
                Decimal Pmaxv2;
                Decimal FInalpmax;
                
                if(Minvalue <3750000 && (App.genesis__Collaterals__r[0].Age_Of_The_Building__c <= 1 || App.genesis__Collaterals__r[0].Age_Of_The_Building__c == NULL)){
                    Pmaxv2 = Math.min(0.90*Minvalue,3000000);
                }
                else if(Minvalue <3750000 && App.genesis__Collaterals__r[0].Age_Of_The_Building__c > 1){
                    Pmaxv2 = Math.min(0.80*Minvalue,3000000);
                }
                else if(Minvalue>=3750000 && Minvalue<=10000000){
                    Pmaxv2 = Math.min(0.80*Minvalue,7500000);
                }
                else if(Minvalue>10000000){
                    Pmaxv2 = 0.75*Minvalue;
                }
                
                
                if(Pmaxv2!=null && !Utility.ISStringBlankorNull(string.valueof(App.Facilities__r[0].Existing_HL_Oustanding_Balance__c))){
                    FInalpmax= Pmaxv2 -App.Facilities__r[0].Existing_HL_Oustanding_Balance__c;
                }
                else{
                    FInalpmax= Pmaxv2;
                }
                if(FInalpmax!=null){
                    Pmax =Math.min(FInalpmax,Pmax);
                    
                }
            }
            else if(App.Sub_Type__c==Constants.Sub_Type_Take_Over &&  App.Facilities__r!=null &&  App.Facilities__r.size()>0){
                if(!Utility.ISStringBlankorNull(string.valueof(App.Facilities__r[0].Takeover_Outstanding_Loan_Amount__c)))
                    Pmax=Math.min(Pmax,App.Facilities__r[0].Approved_Takeover_Outstanding_Loan_Amoun__c);
            }
            
        }
        System.debug('Pmax'+ Pmax);
        
        // Decimal Emimax1=Pmax*(interestrate/1200)*Math.exp(term*Math.log((1+interestrate/1200)))/((Math.exp(term*Math.log((1+interestrate/1200))))-1) ;
        Decimal Emimax1=0;
        if(Pmax!=null){
            Emimax1=Pmax*(App.genesis__Interest_Rate__c/1200)*Math.exp(App.genesis__Term__c*Math.log((1+App.genesis__Interest_Rate__c/1200)))/((Math.exp(App.genesis__Term__c*Math.log((1+App.genesis__Interest_Rate__c/1200))))-1);
        }
        system.debug('Emimax1'+Emimax1+'Total_Emi'+Total_Emi);
        Decimal MinEMI=math.min(Emimax1, Total_Emi); 
        MinEMI=MinEMI<=0?0:MinEMI;
        
        clcommon__Collateral__c Col= new clcommon__Collateral__c();
        col.Cost_of_Property__c = Minvalue;
        col.Id=App.genesis__Collaterals__r[0].id;
        update col;
        
        if(updateApproEMI!=null && updateApproEMI.size()>0)
            update updateApproEMI;
        return MinEMI;
    }    
    
    public static Void calculateEligibilityLAP(genesis__Applications__c application,String checkCal){
        try{
            
            BREScoreCal.IntRateCal Intrest= BREScoreCal.HL_Intrate(application);
            decimal IntRate_Latest=Intrest.IntRate;
            application.genesis__Interest_Rate__c=IntRate_Latest; 
            Decimal EMIMAX = calEMILAP(application);
            //System.debug('EMIMAX:-'+EMIMAX);
            Decimal Pmax1 = calPmaxLAP(application);
            Decimal PMax2 = (EMIMAX*((Math.exp(application.genesis__Term__c *(Math.log((1+((application.genesis__Interest_Rate__c /12)/100))))))-1)) / ((( application.genesis__Interest_Rate__c /12)/100)*(Math.exp(application.genesis__Term__c * (Math.log((1+(( application.genesis__Interest_Rate__c /12)/100)))))));            
            Decimal PMax = math.min((Pmax1 != null ? Pmax1 : 0),(PMax2 != null ? PMax2 : 0)); 
            PMax = conversion(PMax);
            Decimal EMIMAX2;
            System.debug('%%%%% >> Loan Amount >> '+application.genesis__Loan_Amount__c+'$$ Recalculated loan amount >> '+PMax);
            if((application.genesis__Loan_Amount__c  - (application.GMRA_Amount__c != null ? application.GMRA_Amount__c : 0)) > PMax){
                application.Sanction_Authority_Limit__c = PMax;
                Decimal R = application.genesis__Interest_Rate__c/1200;
                Integer N = Integer.ValueOf(application.genesis__Term__c);
                Decimal Rplus = (1+R);
                EMIMAX2 = ((PMax) * R * (Rplus.pow(N))/((Rplus.pow(N))-1));
                //if(application.ValidateTask__c){  
                String usrId = TaskFlow_Helper.getUserList(application.Branch_Code__c,'Branch manager');
                if(usrId != null){
                    TaskFlow_Helper.creatTaskAll(application.Id, usrId, 'Validate sanction at re-calculated eligibility', 1);                            
                }
                // }
            }else{
                PMax = (application.genesis__Loan_Amount__c - (application.GMRA_Amount__c != null ? application.GMRA_Amount__c : 0));
                EMIMAX2 = application.genesis__Payment_Amount__c;
                //BREScoreCal.Calculate_Bre(application,(application.genesis__Loan_Amount__c - (application.GMRA_Amount__c != null ? application.GMRA_Amount__c : 0)),application.genesis__Payment_Amount__c,''); //v1.9
            }
            if(checkCal == '3' || checkCal == 'VELAP'){
                //ApplicationTriggerHandler.IsFirstRun = false;//v3.0
                //IsSecondRun = true;
                BREScoreCal.Calculate_Bre(application,PMax,EMIMAX2,checkCal); //v1.9
            }else{
                //ApplicationTriggerHandler.IsFirstRun = false;//v3.0
                //IsSecondRun = true;
                BREScoreCal.Calculate_Bre(application,PMax,EMIMAX2,'');      
            }
        }
        catch(Exception e){
            System.debug('##Retry Exceptions ### --- > '+ e.getStackTraceString() +' '+e.getMessage());
            HandleBusinessException.captureError('Retry_Task_call', 'calculateEligibilityLAP', e);
        }
    }
    public static decimal calPmaxLAP(genesis__Applications__c application){
        List <clcommon__Collateral__c> ColList = new List<clcommon__Collateral__c>();
        Decimal PMax1 = 0;
        Decimal TotalMarketVal = 0;
        colList = [Select Id,Is_property_legally_valid__c,Total_Market_value__c,Collateral_Market_Value__c From clcommon__Collateral__c Where genesis__Application__c =: application.Id AND Is_property_legally_valid__c =: 'Yes'];
        for(clcommon__Collateral__c col : colList){
            TotalMarketVal = TotalMarketVal + col.Total_Market_value__c;
        }
        integer i=0;
        for(genesis__Application_Parties__c parties:application.genesis__Application_Parties__r){
            if(parties.genesis__Party_Type__c == Constants.Co_Borrower || parties.genesis__Party_Type__c == Constants.Gurantor ){
                i++;
            }
        }
        System.debug('Party Value i++++'+i);
        if(i==0){
            PMax1 = TotalMarketVal*0.55;
        }
        else{
            PMax1 = TotalMarketVal*0.60; 
        }
        return PMax1;
    }
    //Calculating Max EMI for LAP
    public static decimal calEMILAP(genesis__Applications__c App){
        Decimal EMI=0;
        Decimal EMI1=0;
        Decimal NMI;
        Decimal NMIITR;
        Decimal CoApp_EMI =0;
        Decimal IntProp = 0.00;
        Decimal AddIncome = 0.00;
        List<genesis__Application_Parties__c> updateSanctEMI =new list<genesis__Application_Parties__c>();
        for(genesis__Application_Parties__c parties:App.genesis__Application_Parties__r){
            if(parties.genesis__Party_Type__c == Constants.PRIMARY_APP){
                NMI = parties.NMI_Approved__c;
                NMIITR = parties.Approved_NMI_From_ITR__c;
                AddIncome = parties.Agriculture2__c != null ? parties.Agriculture2__c : 0;
                
                if(parties.Financial_Applicant__c){
                    if(parties.Employment_Types__c == Constants.EmpType_Salaried){               
                        if(NMIITR<=100000){
                            EMI=ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.70;                    
                        }
                        else if(NMIITR>100000){
                            EMI=ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.75;
                        }                
                    }
                    else if(parties.Employment_Types__c == Constants.EmpType_Agricul){
                        if(NMIITR<=100000){
                            EMI=NMI*0.70;                    
                        }
                        else if(NMIITR>100000){
                            EMI=NMI*0.75;
                        }
                    }
                    else {
                        if(NMIITR<=66666.67){
                            EMI=ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.70;
                        }
                        else if(NMIITR>66666.67){
                            EMI=ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome)*0.75;
                        }
                    }
                    if(parties.Existing_Emis__c!=null){
                        EMI= EMI - parties.Existing_Emis__c;
                        if(EMI<0){
                            EMI=0;
                        }
                    }
                    genesis__Application_Parties__c P=New genesis__Application_Parties__c(); 
                    P.id=parties.id;
                    P.Approve_Elgibile_EMI__c= EMI;
                    updateSanctEMI.add(p);
                    
                    
                }
            }
        }
        for(genesis__Application_Parties__c parties:App.genesis__Application_Parties__r){
            System.debug('parties.NMI_Approved__c:::'+parties.NMI_Approved__c);
            //  For Co-applicant and Gurantor EMI
            Decimal NMI1;
            Decimal NMIITR1; 
            Decimal AddIncome1 = 0.00;
            NMI1=parties.NMI_Approved__c;
            NMIITR1=parties.Approved_NMI_From_ITR__c;
            AddIncome1 = parties.Agriculture2__c != null ? parties.Agriculture2__c : 0;
            
            if(parties.genesis__Party_Type__c==Constants.Co_Borrower  && parties.Financial_Applicant__c){
                
                if(parties.Employment_Types__c==Constants.EmpType_Salaried){
                    if(NMIITR1<=100000){
                        System.debug('NMIITR1'+NMIITR1+'AddIncome'+AddIncome);
                        EMI1 =ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome)*0.70;
                        System.debug('EMI1'+EMI1);
                    }
                    else if(NMIITR1>100000){
                        EMI1=ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome)*0.75;
                    }
                }
                else if(parties.Employment_Types__c==Constants.EmpType_Agricul){
                    if(NMIITR1<=66666.67){
                        EMI1=NMI*0.70;
                    }
                    else if(NMIITR1>66666.67){
                        EMI1=NMI*0.75;
                    }
                }
                else {
                    if(NMIITR1<=66666.67){
                        EMI1=ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome)*0.70;
                    }
                    else if(NMIITR1>66666.67){
                        EMI1=ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome)*0.75;
                    }
                }
                if(parties.Existing_Emis__c!=null){
                    EMI1= EMI1-parties.Existing_Emis__c;
                    if(EMI1<0){
                        EMI1=0;
                    }
                }
                genesis__Application_Parties__c P=New genesis__Application_Parties__c(); 
                P.id=parties.id;
                P.Approve_Elgibile_EMI__c= EMI1;
                updateSanctEMI.add(p);
                CoApp_EMI=CoApp_EMI+EMI1;
            }
            
            
        }  
        System.debug('CoApp_EMI'+CoApp_EMI);
        Decimal Total_Emi=EMI+CoApp_EMI;  
        System.debug('Total_Emi'+Total_Emi);
        if(updateSanctEMI!=null && updateSanctEMI.size()>0)
            update updateSanctEMI;
        return Total_Emi;
    }    
    
    //Start Validation on Task --------------------------------------------------------------------------
    public static void ValidateTask(Task tsk){
        System.debug('Inside ValidateTask Task.Subject>>>'+tsk.Subject);
        try{
            genesis__Applications__c appdet = queryService.getApplication(tsk.WhatId);//V1.1
            List<genesis__Application_Parties__c> partieslist=queryService.PartyListApp(tsk.WhatId);
            List<genesis__Application_Parties__c> partListSizechck = new List<genesis__Application_Parties__c>();
            Decimal TotalChequeBounc = 0;
            if((appdet.Record_Type_Name__c == Constants.HOMELOAN || appdet.Record_Type_Name__c == Constants.LAPLOAN || appdet.Record_Type_Name__c == Constants.PERSONALLOAN || appdet.Record_Type_Name__c == Constants.VL2W || appdet.Record_Type_Name__c == Constants.VL4W) && (appdet.Application_Stage__c != Constants.APPLICATION_REJECTED_MAINSTAGE && appdet.Application_Stage__c != Constants.DEACTIVATED_APPLICATIONS_MAINSTAGE)){//v2.3
                
                if(tsk.Subject == 'SI/ E-mandate' && tsk.Status == 'Completed'){
                    list<CBS_API_Log__c> cbsLogs = [select id, Status__c, Sequence_No__c from CBS_API_Log__c where Sequence_No__c = '21' AND Application__c =: appdet.Id];
                    if((appdet.E_mandate_UMRN_No__c != null && appdet.E_mandate_UMRN_No__c != '') || (cbsLogs.size() > 0 && cbsLogs[0].Status__c == 'Success')){
                        changeFinalSubStage(appdet, 'SI/ E-mandate');
                    }else{
                        tsk.addError('E-mandate/ UMRN No. is required!!');
                    }                                      
                }
                
                //added by prashant singh on 19-11-2018
                if(tsk.Subject =='Validate sanction at re-calculated eligibility' && tsk.Status =='Completed' && tsk.sanction__c==false){           
                    tsk.addError('Please approve/reject the sanction on Sanction Approval tab');           
                    
                }
                //prashant ends
                //RMD task completion not allow manually -2019-01-03
                if(tsk.Subject =='Approve score deviation' && tsk.Status =='Completed' && tsk.sanction__c==false){           
                    tsk.addError('Please approve/reject the Approve score deviation task on Score card tab');           
                    
                }
                // V1.7 Start
                if(tsk.Subject =='Approve KYC' && tsk.Status =='Completed'){
                    for(genesis__Application_Parties__c p:appdet.genesis__Application_Parties__r){
                        if(!p.IsKYC__c){
                            tsk.addError('KYC Not completed'); 
                        }
                    }
                }//V1.7 end
                
                //v1.6(start)
                //Complete Documentation validation
                if(tsk.Subject == 'Complete Documentation' && tsk.Status =='Completed')
                {
                    System.debug('validate Complete Documentation and initiate CBS***');
                    Integer docCount = 0;
                    set<String> docNameSet = new set<String>();
                    for(Digio_Document_ID__c ddi:appdet.Digio_Documnet_ID__r){
                        if(ddi.Name!=Constants.VLDEALERACK){
                            docNameSet.add(ddi.Name+'_Uploaded%');
                        }
                        if(ddi.Signed_by_Customer_Uploaded__c=='Yes' && ddi.Document_ID__c!=null && ddi.Document_ID__c!=''){
                            docCount++;
                        }
                    }
                    List<Attachment> attchLst = [Select Id,Name,ParentId from Attachment where Name Like:docNameSet and ParentId=:appdet.Id];
                    //System.debug(attchLst.size()+'<<<attchLst>>>'+attchLst);
                    if(docNameSet.size()==docCount && docNameSet.size()==attchLst.size()){
                        System.debug('Initiate CBS $$$');
                        genesis__Applications__c appln = new genesis__Applications__c();
                        if (appdet.Record_Type_Name__c == Constants.PERSONALLOAN || appdet.Record_Type_Name__c == Constants.VL2W || appdet.Record_Type_Name__c == Constants.VL4W) {
                            CBS_API_Calling_HL.call_CBS_API(appdet.Id);
                            
                        }
                        appln.Id = tsk.WhatId;
                        appln.Sub_Stage__c = Constants.DISBURSEMENT_DOCUMENTS_ESIGNED_SUBSTAGE;
                        appln.Initiate_CBS_Call__c = true;
                        update appln;
                    }else {
                        tsk.addError('Please sign and upload all require documents!');
                    }
                }
                
                //Verify Documentation validation
                if(tsk.Subject == 'Verify Documentation' && tsk.Status =='Completed')
                {
                    System.debug('validate Verify Documentation***');
                    Profile profileName=[Select Id,Name from Profile where name =:'Verifying Officer' limit 1];
                    if(profileName.id==userinfo.getProfileId()){
                        Integer docComplete = 0;
                        Integer reviewCount = 0;
                        Integer digioCount = 0;
                        List<Task> tskList = new List<Task>();
                        set<Id> ddiSet = new set<Id>();
                        for(Digio_Document_ID__c ddi:appdet.Digio_Documnet_ID__r){
                            if(ddi.Name!=Constants.VLDEALERACK){
                                digioCount++;
                            }
                            if(ddi.Document_Complete__c){
                                docComplete++;
                            } else if (ddi.Reviewer_Comments__c!=null && ddi.Reviewer_Comments__c!='') {
                                reviewCount++;
                                ddiSet.add(ddi.Id);
                            }
                        }
                        System.debug('digioCount=='+digioCount+'| docComplete=='+docComplete+'| reviewCount=='+reviewCount+'| ddiSet=='+ddiSet);
                        if (digioCount != docComplete+reviewCount) {
                            tsk.addError('Please mark document upload complete or write comments!');
                        } else if (reviewCount>0) {
                            System.debug('Inside Correct Documentation task');
                            String usrId = TaskFlow_Helper.getUserList(appdet.Branch_Code__c,'Branch manager');
                            System.debug('^^^usrId^^^^'+usrId);
                            if(usrId != null){
                                TaskFlow_Helper.creatTaskAll(appdet.Id, usrId, 'Correct Documentation', 1);
                            }
                            List<Digio_Document_ID__c> digioList = new List<Digio_Document_ID__c>();
                            for(Id digioId: ddiSet) {
                                Digio_Document_ID__c digio = new Digio_Document_ID__c(Id=digioId,Document_ID__c='');
                                digioList.add(digio);
                            }
                            if (digioList.size()>0) {
                                update digioList;
                            }
                        } else {
                            if (tsk.Id!=null && tsk.WhatId!=null) {
                                tskList = [Select Subject,WhatId,Status From Task Where WhatId =: tsk.WhatId AND Status !='Completed' and Subject!='Verify Documentation'];
                                System.debug(tskList.size()+'**tskList==>'+tskList);
                            }
                            if(tskList.size()==0){
                                genesis__Applications__c appln = new genesis__Applications__c();
                                appln.Id = tsk.WhatId;
                                appln.Sub_Stage__c = Constants.App_Process_Closed;
                                update appln;
                            }
                        } 
                    } else {
                        tsk.addError('Only Verifying Officer can complete this task!');
                    } 
                }
                
                //Correct Documentation validation
                if(tsk.Subject == 'Correct Documentation' && tsk.Status =='Completed')
                {
                    System.debug('validate Correct Documentation***');
                    Integer reUpload = 0;
                    Integer digioCount = 0;
                    for(Digio_Document_ID__c ddi:appdet.Digio_Documnet_ID__r){
                        if(ddi.Name!=Constants.VLDEALERACK){
                            digioCount++;
                        }
                        if(ddi.Document_ID__c!=null && ddi.Document_ID__c!=''){
                            reUpload++;
                        }
                    }
                    if (digioCount == reUpload) {
                        System.debug('Inside Verify Documentation task');
                        String usrId = TaskFlow_Helper.getUserList(appdet.Branch_Code__c,'Verifying Officer');
                        System.debug('^^^usrId^^^^'+usrId);
                        if(usrId != null){
                            TaskFlow_Helper.creatTaskAll(appdet.Id, usrId, 'Verify Documentation',1);
                        }
                    } else {
                        tsk.addError('Please re-upload unchecked documents');
                    }
                }
                //v1.6(end)
                
                //v2.3(start)Verify FI rejection
                if(tsk.Subject == 'Verify FI rejection' && tsk.Status == 'Completed'){
                    System.debug('inside Verify FI task validation');
                    if(tsk.WhatId != null){
                        if(tsk.OwnerId == UserInfo.getUserId()){
                            if(appdet.RLPC_head_Comments__c == null){
                                tsk.addError('Please fill Branch Manager Comment field');
                            }
                            List<Astute_Verification__c> astList = new List<Astute_Verification__c>();
                            astList = queryService.getAstuteRecord(tsk.WhatId);
                            for(Astute_Verification__c astute: astList) {
                                if (astute.Case_Id__c==Constants.FI_MANUAL && (astute.Date_of_Visit__c==null || astute.Time_of_Visit__c==null || astute.Contacted_Person__c==null || (astute.Change_in_Address__c && (astute.Revised_Address__c ==null || astute.Revised_Address__c =='')))){
                                    tsk.addError('Please fill mandatory fields!');
                                }
                                if(astute.Case_Id__c!=Constants.FI_MANUAL && astute.DeDupe_Status__c==null){
                                    tsk.addError('All astute response yet to be obtain');
                                }
                            }
                        }else {
                            tsk.addError('Only Assigned Branch Manager can complete '+tsk.Subject+' task!');
                        }
                    }
                }
                
                //Approve FI
                if(tsk.Subject == 'Approve FI' && tsk.Status == 'Completed'){
                    System.debug('inside Approve FI task validation');
                    if(tsk.WhatId != null){
                        if(tsk.OwnerId == UserInfo.getUserId())
                        {
                            if(appdet.DM_comments__c == null ){
                                tsk.addError('Please fill DM comment fields!'); 
                            } else if(appdet.FI_Final_Decision__c == null ){
                                tsk.addError('Please Approve FI Verification!'); 
                            } else {
                                update getUpdatedAccAddress(tsk.WhatId);
                            }
                        }else {
                            tsk.addError('Only Assigned DOO can complete '+tsk.Subject+' task!');
                        }
                    }
                }//v2.3(end)

                //v2.5(start)
                if(tsk.Subject == 'FEC Clearance' && tsk.Status == 'Completed'){
                    System.debug('inside FEC Clearance task validation');
                    if(tsk.OwnerId == UserInfo.getUserId()){
                        if(tsk.WhatId != null){
                            if(appdet.FEC__r.size() > 0)
                            {
                                if(appdet.FEC__r[0].FEC_Date__c == null || appdet.FEC__r[0].FEC_No__c == null || !appdet.FEC__r[0].Is_FEC_Completed__c){
                                    tsk.addError('Please fill FEC details!'); 
                                }
                                changeFinalSubStage(appdet, 'FEC Clearance');
                            } else {
                                tsk.addError('FEC Details not found!');
                            }
                        }
                    }else {
                        tsk.addError('Only assigned user can complete '+tsk.Subject+' task!');
                    }
                }//v2.5(end)
            }
            
            //--------------------------------------------HOMELOAN start here++++++++++++++++++++++++++++
            if(appdet.Record_Type_Name__c == Constants.HOMELOAN && (appdet.Application_Stage__c != Constants.APPLICATION_REJECTED_MAINSTAGE && appdet.Application_Stage__c != Constants.DEACTIVATED_APPLICATIONS_MAINSTAGE)){//v2.3
                clcommon__Collateral__c Collateral= [Select Id,Instruction_to_Branch__c,Advocate_Name__c,Residual_Life_of_Property__c,Valuation_Date__c,Valuer_Name__c,Legal_Opinion_Date__c,Final_Construction__c from clcommon__Collateral__c Where genesis__Application__c =: appdet.Id  and Active__c=true limit 1];
                Integer VerifyCount = 0;
                Integer financialPartyCount = 0;
                // added by Venu 27_7_18_13_17
                if(tsk.Subject =='Verify property and upload valuation and legal reports' && tsk.Status =='Completed'){
                    if(Utility.ISStringBlankorNull(string.valueOf(appdet.Branch_manager_visit_date__c)) || Utility.ISStringBlankorNull(appdet.Branch_manager_visit_comments__c)){
                        tsk.addError('Property Visit Data Not Entered'); 
                    }
                }
                if(tsk.Subject =='Legal clearance' && tsk.Status =='Completed'){
                    boolean PropVal=false;
                    List<Task> lstTask = new List<Task>();
                    lstTask = appdet.tasks;
                    for(Task T:lstTask){
                        System.debug('Task Subject>>>'+T.Subject);
                        if(T.Subject=='Verify property and upload valuation and legal reports' && t.Status =='Completed')
                            PropVal=true;
                    }
                    System.debug('PropVal'+PropVal);
                    if(!PropVal)
                        tsk.addError('Please Complete the Property task');

                    //COLLATERAL STRUCTURE CHANGES--on 27-11-2018
                    if(Utility.ISStringBlankorNull(string.valueOf(Collateral.Valuation_Date__c)) || Utility.ISStringBlankorNull(Collateral.Valuer_Name__c) || Utility.ISStringBlankorNull(string.valueOf(Collateral.Legal_Opinion_Date__c)) || Utility.ISStringBlankorNull(Collateral.Advocate_Name__c) || Utility.ISStringBlankorNull(Collateral.Instruction_to_Branch__c) || appdet.Branch_manager_visit_date__c == NULL || Utility.ISStringBlankorNull(appdet.Branch_manager_visit_comments__c)){
                        tsk.addError('Legal Clearance Details not Entered'); 
                    }
                    legalDeskCheck(appdet);
                }
                // End here
                if(tsk.Subject =='Approve income' && tsk.Status =='Completed'){
                    if(tsk.WhatId != null){
                        
                        for(genesis__Application_Parties__c acc : partieslist){
                            if(acc.Financial_Applicant__c == true){
                                financialPartyCount++;
                                if(acc.Verify_PAN_Number__c == 'Yes'){
                                    VerifyCount++;
                                }
                            }
                            // TotalChequeBounc Count v1.9
                            TotalChequeBounc = TotalChequeBounc + acc.Total_ChequeECS_bounces__c!= null?acc.Total_ChequeECS_bounces__c:0;   
                            
                        }
                        if(financialPartyCount != VerifyCount){
                            // add error
                            tsk.addError('Please Complete Verification Of PAN'); 
                        }else if(TotalChequeBounc > 5 ){
                            //appdet.Application_Stage__c =Constants.APP_REJECTED_STAGE;        
                            appdet.Sub_Stage__c='Cheque Returns';
                            appdet.Total_Cheque_Bounces__c = TotalChequeBounc;
                            ApplicationTriggerHandler.IsFirstRun = False;
                            update appdet;
                        }
                    }
                }
                
                // Upload EC validation on task status chnage to completed
                if(tsk.Subject =='Upload latest EC' && tsk.Status =='Completed'){
                    if(tsk.WhatId != null){
                        genesis__Applications__c appEC = queryService.getApp(tsk.WhatId);
                        System.debug('EC task '+ tsk.Subject);
                        System.debug('App Details ' + appEC.EC_Number__c +' ' +appEC.EC_Issuance_Date__c +' MOD '+appEC.MOD_Date__c+' ' +appEC.Upload_EC__c);
                        if(appEC.EC_Issuance_Date__c != null && appEC.MOD_Date__c != null){
                            if(appEC.EC_Number__c == null && appEC.EC_Issuance_Date__c < appEC.MOD_Date__c && appEC.Upload_EC__c == False){
                                tsk.addError('Please fill all the EC details & Issuance date should be after MOD Date');
                            }
                        }else{
                            tsk.addError('Please fill the Issuance date and MOD date');
                        }                
                    }
                }
                
                // Take-over Validation
                if(tsk.Subject =='Take-over Validation' && tsk.Status =='Completed'){
                    if(tsk.WhatId != null){
                        genesis__Applications__c appTO = queryService.getApp(tsk.WhatId);
                        System.debug('Take-over task '+ tsk.Subject);
                        if(appTO.Sanctioned_Loan_Amount__c == null || appTO.Outstanding_Loan_Amount__c == null || appTO.Date_of_Loan_Sanction_Existing_Loan__c == null || appTO.Sanctioned_Loan_Term_Existing_Loan__c == null || appTO.Outstanding_Loan_Term_Existing_Loan__c == null || appTO.Sanctioned_ROI_Existing_Loan__c == null || appTO.Current_ROI_Existing_Loan__c == null || appTO.Start_Date_of_EMI_Existing_Loan__c == null || appTO.Upload_comfort_letter__c == false){
                            tsk.addError('Please fill all the Take over details');
                        }else if(appTO.Sanctioned_ROI_Existing_Loan__c > 100 || appTO.Current_ROI_Existing_Loan__c > 100){
                            tsk.addError('ROI cannot be more than 100');
                        }else if(appTO.Start_Date_of_EMI_Existing_Loan__c < appTO.Date_of_Loan_Sanction_Existing_Loan__c){
                            tsk.addError('Date of EMI cannot be earlier than start date of loan sanction');
                        }                   
                    }
                }
                
                //Policy Insurance Validation(PL)
                if(tsk.Subject =='Update credit life insurance' && tsk.Status =='Completed'){
                    if(tsk.WhatId != null){
                        List<clcommon__Collateral_Insurance__c> insId = queryService.getInsurance(tsk.WhatId);
                        System.debug('Property Insurance'+ tsk.Subject);
                        if(insId.size() <> 0){    
                            if(insId[0].Upload_Insurance_Policy__c == false || insId[0].Policy_Type_pl__c == null || insId[0].clcommon__Policy_Number__c == null ||  insId[0].Date_Policy_Expiry__c == null || insId[0].Date_Insure__c == null || insId[0].Is_KVB_the_designated_assignee__c == 'No' || insId[0].Standing_Instruction_E_Mandate_Set_up_Co__c == 'No' ){
                                tsk.addError('Please fill all the Policy Insurance details');
                            }else if(insId[0].Date_Policy_Expiry__c < insId[0].Date_Insure__c){
                                tsk.addError('Policy end date cannot be earlier than Policy start date');
                            }else if(insId[0].Policy_Period__c < 1){
                                tsk.addError('Policy Period should be more than one year');
                            }
                        }else{
                            tsk.addError('Please fill all the Policy Insurance Details.');
                        } 
                    }
                }
                
                if(tsk.Subject =='Additonal Income Assessment' && tsk.Status =='Completed'){
                    if(tsk.WhatId != null){
                        //List<genesis__Application_Parties__c> partieslist=queryService.getparties(tsk.WhatId);
                        for(genesis__Application_Parties__c par : partieslist){
                            if(par.Agriculture2__c == null){
                                VerifyCount++;
                            }
                        }
                        if(partieslist.size() == VerifyCount){
                            System.debug('Additonal Income Assessment Details');
                            tsk.addError('Please fill the Agriculture Income approved value');
                        } 
                    }
                }
                
                //Enter property details - Validation
                if(tsk.Subject == 'Enter property details' && tsk.Status == 'Completed'){
                    if(tsk.WhatId != null){
                        //change appTo.Residual_Life_of_Property__c ---added by prashant singh on 21_11_2018....collateral structure changes
                        if(Collateral.Residual_Life_of_Property__c == null)
                            tsk.addError('Please fill Residual life of property');
                        //if(appdet.Sub_Type__c == Constants.Sub_Type_Top_Up && (Collateral.Final_Construction__c == null || Collateral.Final_Construction__c == 'No'))//v2.5//removed after discussion with harsh
                        //    tsk.addError('Top Up loan cannot be provided to a property under construction');
                    }
                }
                
                //Assess income
                if(tsk.Subject == 'Assess income' && tsk.Status == 'Completed'){
                    if(tsk.WhatId != null){
                        
                        // change parties
                        //List<genesis__Application_Parties__c> partieslist=queryService.getparties(tsk.WhatId);
                        for(genesis__Application_Parties__c par : partieslist){
                            if(par.Financial_Applicant__c == true){
                                if((par.Average_Balances_6_months__c == 0 || par.Average_Balances_6_months__c==null)  && (par.Financial_Applicant__c == true) ){
                                    tsk.addError('Average Six Month Balances should be greater than 0');
                                }
                                
                                if((par.Existing_Emis__c == null || par.Max_Existing_EMI__c <>  par.Existing_Emis__c && (par.EMI_Comments__c == null || par.EMI_Comments__c == '')) && par.genesis__Party_Type__c==Constants.PRIMARY_APP ){
                                    tsk.addError('Please enter Existing EMI Approved & RLPC comments for Approved EMI.');
                                }
                                
                                if((Utility.ISStringBlankorNull(string.valueof(par.Primary_Bank__c)) || Utility.ISStringBlankorNull(par.Bank_Account_Number__c) ) && par.Financial_Applicant__c== true){
                                    tsk.addError('Please enter Bank Name & Primary Bank Account Number.');
                                }
                            }
                            
                        }
                        
                    }
                }
                
                if((tsk.Subject == 'Approve disbursement' || tsk.Subject == 'Approval for disbursement') && tsk.Status == 'Completed'){//v2.4
                    String docGen = appdet.Document_Generation__c;
                    Integer docCount = 0;
                    if(docGen != null && docGen != ''){
                        if (docGen.contains(Constants.C1docGen) && docGen.contains(Constants.C1class2Sign) && docGen.contains(Constants.C1DocID)){
                            docCount++;
                        }
                        if (docGen.contains(Constants.A23DocGen) && docGen.contains(Constants.A23Class2) && docGen.contains(Constants.A23DocID)){
                            docCount++;
                        }
                        if (docGen.contains(Constants.A46DocGene) && docGen.contains(Constants.A46Class2sign) && docGen.contains(Constants.A46DocID)){
                            docCount++;
                        }
                        if (docGen.contains(Constants.B17DocGen) && docGen.contains(Constants.B17DocID)){
                            docCount++;
                        }
                        if (docGen.contains(Constants.B1DOcGene) && docGen.contains(Constants.B1DOcID)){
                            docCount++;
                        }
                        if (docGen.contains(Constants.A66DocGene) && docGen.contains(Constants.A66Class2sign) && docGen.contains(Constants.A66DocID)){
                            docCount++;
                        }
                        if (docGen.contains(Constants.A54DocGene) && docGen.contains(Constants.A54Class2sign) && docGen.contains(Constants.A54DocID)){
                            docCount++;
                        }
                        Integer HlDocsCount = Call_BRE_HL.DocumnetsCount(appdet);
                        if (appdet.Sub_Type__c != Constants.Sub_Type_Reimbursement && (appdet.Sub_Type__c == Constants.Sub_Type_Take_Over || (appdet.Loan_Purpose__c==Constants.IdentifiedProperty || appdet.Loan_Purpose__c==Constants.ConstructionOn))) {
                            HlDocsCount = HlDocsCount-1;
                        }
                        System.debug('docCount:::'+docCount);
                        System.debug('HlDocsCount:::'+HlDocsCount);
                        if (docCount == HlDocsCount) {
                            appdet.Sub_Stage__c = Constants.Sub_Stage_DisbuApprov;
                            update appdet;
                        }else{
                            tsk.addError('All the required documents to be generated for the application');
                        }
                    } else {
                        tsk.addError('Please generate all the required documents!');
                    }
                }
                
                if(tsk.Subject == 'Initiate MOD' && tsk.Status == 'Completed'){
                    if(tsk.WhatId != null){
                        if(appdet.Sub_Stage__c != 'Loan Sanctioned Non-STP' && appdet.Sub_Stage__c != 'Mod Initiated' && appdet.Sub_Stage__c != 'Loan Account Opened'){
                            tsk.addError('Sub Stage should be Loan Sanctioned Non-STP or Loan Account Opened');
                        }else {
                            if(appdet.Sub_Type__c==Constants.Sub_Type_Top_Up){//v2.5
                                if(Utility.ISStringBlankorNull(string.valueOf(appdet.MOD_Date__c)) || Utility.ISStringBlankorNull(string.valueOf(appdet.All_property_Documents_Uploaded__c)) || Utility.ISStringBlankorNull(string.valueOf(appdet.Sale_Deed_Colleced__c))){
                                    tsk.addError('Please fill the Applicaiton MOD Details');
                                }
                            }else if((appdet.Document_Generation__c ==null || appdet.Document_Generation__c =='')  || (!appdet.Document_Generation__c.contains(Constants.B1DOcGene))){
                                tsk.addError('B1 Documents not Generated');
                            }else if(appdet.Sub_Type__c != Constants.Sub_Type_Reimbursement && appdet.Loan_Purpose__c!=Constants.Construction && appdet.Loan_Purpose__c!=Constants.RepairHouse && appdet.Legal_desk_state_flag__c==false){//v2.5
                                String usrId = TaskFlow_Helper.getUserList(appdet.Branch_Code__c,'Branch manager');
                                if(usrId != null){
                                    TaskFlow_Helper.creatTaskAll(appdet.Id, usrId, 'Complete Documentation', 1);
                                }
                            }
                        }
                        if(appdet.Sub_Type__c == Constants.Sub_Type_Take_Over || (appdet.Sub_Type__c !=Constants.Sub_Type_Take_Over && appdet.Sub_Type__c !=Constants.Sub_Type_Top_Up && (appdet.Loan_Purpose__c==Constants.Construction || appdet.Loan_Purpose__c==Constants.RepairHouse))){//v2.5
                            List<Task> tskList = new List <Task>();
                            list<Digio_Document_ID__c> ddiList = new list<Digio_Document_ID__c>();
                            list<Document_Applicant__c> daList = new list<Document_Applicant__c>();
                            Boolean flag = true;
                            tskList = [Select Subject,WhatId,Status From Task Where WhatId =: tsk.WhatId AND Status !='Completed' AND Subject != 'Initiate MOD'];
                            if (appdet.Legal_desk_state_flag__c) {
                                ddiList = [Select id, Name from Digio_Document_ID__c where Name='B1' AND Application__c =: appdet.Id];
                                if (ddiList.size() > 0 ) {
                                   daList = [Select id, Digio_Document_ID__c, eSigned__c from Document_Applicant__c where Digio_Document_ID__c =: ddiList[0].id];
                                    for(Document_Applicant__c da : daList){
                                        if(da.eSigned__c== false){
                                            flag = false;
                                        }
                                    } 
                                } else {
                                    flag = false;
                                }
                            }
                            if(appdet.Legal_desk_state_flag__c  && flag == true && tskList.size() == 0){
                                changeFinalSubStage(appdet, 'Initiate MOD');
                            } else if(!appdet.Legal_desk_state_flag__c && tskList.size() == 0){
                                changeFinalSubStage(appdet, 'Initiate MOD');
                            } else {
                                genesis__Applications__c appln = new genesis__Applications__c();
                                appln.Sub_Stage__c = Constants.InitaiteMOD;
                                appln.Id = appdet.Id;
                                update appln;
                            }
                        }else if((appdet.Sub_Type__c ==Constants.Sub_Type_Top_Up) || (appdet.Sub_Type__c != Constants.Sub_Type_Take_Over && (appdet.Loan_Purpose__c==Constants.IdentifiedProperty || appdet.Loan_Purpose__c==Constants.ConstructionOn))){//v2.5
                            genesis__Applications__c appln = new genesis__Applications__c();
                            appln.Sub_Stage__c = Constants.InitaiteMOD;
                            appln.Id = appdet.Id;
                            update appln;
                        }
                    }
                }
                // Ended by Venu v1.3

                
                // V2.7 Start Top up tasks
                if((tsk.Subject =='Enter Top Up Details'  ||  tsk.Subject =='Approve Top Up Details' )&& tsk.Status =='Completed'){
                    List<Facility__c> facilityList = new List<Facility__c>();
                        facilityList = queryService.getFacilityRecord(tsk.WhatId,true);
                    if (facilityList.size() > 0 && Utility.ISStringBlankorNull(facilityList[0].Existing_HL_MOD_No__c) || Utility.ISStringBlankorNull(string.valueof(facilityList[0].Existing_HL_MOD_Date__c)) || Utility.ISStringBlankorNull(facilityList[0].Existing_HL_MOD_SRO__c)|| Utility.ISStringBlankorNull(string.valueof(facilityList[0].Existing_HL_A23_Agreement_Date__c))){
                            tsk.addError('Please Provide the Approved Details'); 
                      
                    }
                }
                // V2.7 End
                
                //v2.5(start)
                if((tsk.Subject == 'Verify Expenses incurred' || tsk.Subject == 'Approve Expenses incurred') && tsk.Status == 'Completed'){
                    if(tsk.WhatId != null){
                        clcommon__Collateral__c coll = new clcommon__Collateral__c();
                        coll = appdet.genesis__Collaterals__r.size() > 0 ? appdet.genesis__Collaterals__r[0] : null;
                        if(coll != null && coll.Approved_Cost_incurred_in_last_6_Months__c == null){
                            tsk.addError('Please Enter Approved Cost Incurred in last 6 Months' );
                        } else if (coll == null) {
                            tsk.addError('Collateral not found!');
                        }
                    }
                }
                
                if((tsk.Subject == 'Verify Take Over details' || tsk.Subject == 'Approve Take Over details') && tsk.Status == 'Completed'){
                    if(tsk.WhatId != null){
                        List<Facility__c> facilityList = new List<Facility__c>();
                        facilityList = queryService.getFacilityRecord(tsk.WhatId,true);
                        if (facilityList.size() > 0 && (facilityList[0].Takeover_Loan_Account_No__c == null || facilityList[0].Bank_Name__c == null || facilityList[0].Takeover_Sanctioned_Loan_Amount__c == null || facilityList[0].Takeover_Sanctioned_Loan_Tenure_months__c == null || facilityList[0].Takeover_Outstanding_Loan_Amount__c == null || facilityList[0].Takeover_Outstanding_Loan_Tenure_months__c == null || facilityList[0].Takeover_Loans_EMI__c == null || facilityList[0].Takeover_Holiday_Period_months__c == null || facilityList[0].Takeover_Outstanding_as_on__c == null || facilityList[0].Approved_Takeover_Outstanding_Loan_Amoun__c == null || facilityList[0].Approved_Takeover_Bank_Name__c == null || facilityList[0].Approved_Takeover_Loans_EMI__c == null )) {
                            tsk.addError('Please fill all mandatory fields');
                        } else if (facilityList.size() == 0) {
                            tsk.addError('Facility not found!');
                        }
                    }
                }
                                
                if(tsk.Subject == 'Collect Original Documents' && tsk.Status == 'Completed'){
                    if(tsk.WhatId != null){
                        List<Document_Model__c> documentLst = new List<Document_Model__c>();
                        documentLst = [Select Id,Document_Name__c,Document_ID__c,Is_Checked__c from Document_Model__c where Application__c=:tsk.WhatId];
                        for(Document_Model__c docMod: documentLst) {
                            if ((docMod.Document_Name__c == 'Original Sale Deed' || docMod.Document_Name__c == 'Existing Banker\'s cancellation of MOD') && (docMod.Document_ID__c == null || !docMod.Is_Checked__c)) {
                                tsk.addError('Please fill all mandatory fields');
                            }
                        }
                        if (documentLst.size() == 0) {
                            tsk.addError('No Documents list found!');
                        }
                    }
                }
                if(tsk.Subject == 'Supplementary Legal Clearance' && tsk.Status == 'Completed'){
                    if(tsk.WhatId != null){
                        clcommon__Collateral__c coll = new clcommon__Collateral__c();
                        coll = appdet.genesis__Collaterals__r.size() > 0 ? appdet.genesis__Collaterals__r[0] : null;
                        if(coll != null && coll.Date_Of_Valuation2__c == null || coll.Valuers_Name2__c == null || coll.Lawyers_Name2__c == null  || coll.Instruction_to_Branch2__c == null || coll.Date_Of_Legal_Opinion2__c == null){
                            tsk.addError('Please fill all mandatory fields');
                        }else if (coll == null) {
                            tsk.addError('Collateral not found!');
                        }
                    }
                }
                
                //if(tsk.Subject == 'Verify Loan Application' && tsk.Status == 'Completed' && tsk.sanction__c==false){
                //    tsk.addError('Please approve/reject the application from Take Over Details Page');
                //}//v2.5(end)
            }
            //--------------------------------------------HOMELOAN End here ++++++++++++++++++++++++++
            
            
            //--------------------------------------------Lap start here+++++++++++++++++++++++++++++
            if(appdet.Record_Type_Name__c == Constants.LAPLOAN && (appdet.Application_Stage__c != Constants.APPLICATION_REJECTED_MAINSTAGE && appdet.Application_Stage__c != Constants.DEACTIVATED_APPLICATIONS_MAINSTAGE)){//v2.3
                Integer VerifyCount1 = 0;
                Integer financialPartyCount1 = 0;
                
                // change -parties
                if(tsk.Subject == 'Assess income' && tsk.Status == 'Completed'){//v2.4
                    if(tsk.WhatId != null){
                        
                        for(genesis__Application_Parties__c par : partieslist){
                            
                            if(par.Verify_PAN_Number__c == 'Yes' && par.Financial_Applicant__c == true){
                                VerifyCount1++;
                            }
                            if((par.Average_Balances_6_months__c == 0 || par.Average_Balances_6_months__c == null) && (par.Financial_Applicant__c == true)){
                                tsk.addError('Average Six Month Balances should be greater than 0');
                            } 
                            if(par.Financial_Applicant__c == true){
                                partListSizechck.add(par);
                                if(((par.Existing_Emis__c == null || par.Max_Existing_EMI__c <>  par.Existing_Emis__c) && (par.EMI_Comments__c == null || par.EMI_Comments__c == '')) && par.genesis__Party_Type__c==Constants.PRIMARY_APP   ){
                                    tsk.addError('Please enter Existing EMI Approved & RLPC comments for Approved EMI.');
                                }      
                            }
                            if((Utility.ISStringBlankorNull(string.valueof(par.IFSC_code__c)) ||    Utility.ISStringBlankorNull(par.Bank_Account_Number__c)) && par.Financial_Applicant__c== true){
                                tsk.addError('Please enter IFSC Code & Primary Bank Account Number.');
                            }
                            
                        }
                        
                        System.debug('&&&&&&'+VerifyCount1+'$$$$$$$'+partieslist.size());
                        
                        if(partListSizechck.size() != VerifyCount1){
                            // add error
                            tsk.addError('Please  Complete  Verification  of  PAN'); 
                        }
                        if(appdet.NMI_Approved__c == 0 || appdet.NMI_Approved__c == null){
                            tsk.addError('Approved NMI should be greater than 0');
                        }
                        
                    }
                }
                
                if(tsk.Subject == 'Approve income' && tsk.Status == 'Completed'){ // v1.9
                    if(tsk.WhatId != null){    
                        for(genesis__Application_Parties__c acc : partieslist){
                            // TotalChequeBounc Count v1.9
                            TotalChequeBounc +=  acc.Total_ChequeECS_bounces__c!= null?acc.Total_ChequeECS_bounces__c:0;   
                        }
                        if(TotalChequeBounc > 5){
                            //appdet.Application_Stage__c =Constants.APP_REJECTED_STAGE;        
                            appdet.Sub_Stage__c='Cheque Returns';
                            appdet.Total_Cheque_Bounces__c = TotalChequeBounc;
                            ApplicationTriggerHandler.IsFirstRun = False;
                            update appdet;
                        }
                    }
                }
                ///additional income
                if(tsk.Subject =='Additonal Income Assessment' && tsk.Status =='Completed'){
                    System.debug('*Additonal Income Assessment');
                    if(tsk.WhatId != null){     
                        
                        for(genesis__Application_Parties__c par : partieslist){
                            if(par.Financial_Applicant__c == true){
                                financialPartyCount1++;
                                if(par.Agriculture2__c == null){
                                    VerifyCount1++;
                                }
                                
                                if(par.Verify_PAN_Number__c == 'Yes'){
                                    VerifyCount1++;
                                }
                            }
                        }
                        
                        if(partieslist.size() == VerifyCount1 || appdet.NMI_Approved__c==NULL || appdet.Existing_EMI_s__c==NULL || appdet.Total_Cheque_Bounces__c==NULL || appdet.AVG_Balance__c==NULL){
                            System.debug('Additonal Income Assessment Details');
                            // add error
                            tsk.addError('Please fill the mandatory fields of Income verification Tab');
                        } 
                        if(financialPartyCount1 != VerifyCount1){
                            // add error
                            tsk.addError('Please Complete Verification Of PAN'); 
                        }            
                    }
                }                  
                ///////// Enter property details //v2.4
                if(tsk.Subject == 'Enter property details' && tsk.Status == 'Completed'){//v2.4
                    System.debug('* inside Enter property details'); //v2.4
                    if(tsk.WhatId != null){
                        
                        List<clcommon__Collateral__c> oblist=[select id,Total_Market_value__c,Vacant_Land_area__c,genesis__Application__c,clcommon__Collateral_Type__c,Collateral_Type__c,Valuation_Date__c,Collateral_Uses__c,EM_Charge_types__c,No_of_tenants__c,Collateral_Market_Value__c,State__c,clcommon__City__c,Nature_of_Property__c,clcommon__Postal_Code__c,VillageTown__c,Final_Construction__c from clcommon__Collateral__c where genesis__Application__c =:appdet.Id];
                        for(clcommon__Collateral__c ob:oblist){
                            if(ob.Collateral_Uses__c == null || ob.EM_Charge_Types__c == null || ob.No_of_tenants__c == null || ob.Vacant_Land_area__c == null || ob.Collateral_Market_Value__c == null || ob.Valuation_Date__c == null || ob.State__c == null || ob.clcommon__City__c == null || ob.clcommon__Postal_Code__c == null || ob.VillageTown__c == null || ob.Collateral_Market_Value__c == 0.00 || ob.Total_Market_value__c == 0.00 || ob.Final_Construction__c==null){
                                tsk.addError('Total market value should be greater than 0 OR Please fill collateral details');   
                                break;
                            }
                        }
                    }  
                }
                //// Initiate MOD
                if(tsk.Subject == 'Initiate MOD' && tsk.Status == 'Completed'){
                    
                    if(tsk.WhatId != null){
                        //  genesis__Applications__c appTO = queryService.getApp(tsk.WhatId);
                        if(appdet.Sanction_Date__c == null ){
                            tsk.addError('Please fill sanction date');
                        }else if((appdet.Document_Generation__c ==null || appdet.Document_Generation__c =='') || (!appdet.Document_Generation__c.contains('B1 Doc Generation'))){
                            tsk.addError('B1 Document is not Generated');
                        }
                        if(appdet.Sub_Stage__c != 'Loan Sanctioned Non-STP' && appdet.Sub_Stage__c != 'Mod Initiated'){
                            tsk.addError('Sub Stage should be Loan Sanctioned Non-STP');
                        }
                    }
                }            
                ///legal clearence
                List<genesis__Applications__c> applist=new List<genesis__Applications__c>();
                if(tsk.Subject == 'Legal clearance' && tsk.Status == 'Completed'){
                    System.debug('tsk.WhatId****'+tsk.WhatId);
                    
                    if(tsk.WhatId != null){
                        
                        List<clcommon__Collateral__c> oblist=[select  id, Is_property_legally_valid__c,Valuation_Date__c,Valuer_Name__c,  Legal_Opinion_Date__c,Vacant_Land_area__c,Collateral_Type__c, Advocate_Name__c,No_of_tenants__c from clcommon__Collateral__c  where genesis__Application__c =:appdet.Id];
                        System.debug('oblist:::::'+oblist);
                        for(clcommon__Collateral__c ob:oblist){
                            if(ob.Is_property_legally_valid__c=='no'){
                                System.debug('inside if');
                                appdet.Sub_Stage__c='Legal Clearance Rejected';
                                appdet.Application_Stage__c='Application Rejected';
                                System.debug('appdet::::'+appdet);
                            }
                            System.debug('applist'+applist);
                            // update applist;
                            if(ob.Is_property_legally_valid__c == null || ob.Valuation_Date__c==null || ob.Valuer_Name__c==null ||ob.Legal_Opinion_Date__c==null  ||ob.Advocate_Name__c==null) {   
                                tsk.addError('Please fill details field of legal clearence'); 
                                break;
                            }
                            integer ten = Integer.valueOf(ob.No_of_tenants__c);
                            if(ten > 10 && ob.Collateral_Type__c == 'Land & Building'){
                                tsk.addError('Properties with more than 10 tenants are not allowed');
                                break;
                            }
                            if(ob.Vacant_Land_area__c > 10000 && ob.Collateral_Type__c == 'Vacant Land'){
                                tsk.addError('Properties with area of land more than 10000 sq.ft. are not allowed');
                                break;
                            }
                            if(appdet.Branch_manager_visit_date__c == null || appdet.Branch_manager_visit_comments__c == null){
                                tsk.addError('Please fill branch manager visit date and visit comments');
                            }
                            
                        }
                        List <String> Accids = new List <String>();
                        List<genesis__Application_Parties__c> PTList = [Select Id,Key_Contact__c From genesis__Application_Parties__c where Company__c = true AND genesis__Application__c =: tsk.WhatId AND 
                                                                        Active__c = true AND Financial_Applicant__c = true AND (genesis__Party_Type__c ='Partner' OR genesis__Party_Type__c ='Proprietor')];
                        System.debug('PTList::::PTList:::PTList:::'+PTList);
                        if(PTList.size() > 0){
                            for(genesis__Application_Parties__c PT : PTList){
                                Accids.add(PT.Key_Contact__c);
                            }        
                            List <Account> accList = [Select Id,Name,Bureau_Score__c,Jocata_List_Match__c,CBS_Customer_ID__c,PersonBirthdate,PersonMailingStreet,PersonMailingCity,
                                                      PersonMailingState,PersonMailingCountry,Nationality__pc,Pan_Number__c,Driving_License_ID__c,
                                                      Aadhaar_Number__pc,Ration_Card__c,PersonMobilePhone,BillingStreet,BillingCountry,BillingState,BillingCity,Phone,PersonEmail from Account Where ID IN: Accids];
                            //List <TU_Error__c> tuErr = [select Id,Account__r.Id,Response__c From TU_Error__c where Id IN: Accids];
                            System.debug('$$$$$$$$$$$'+accList);
                            if(accList.size()>0){
                                for(Account acc : accList){
                                    if(acc.Bureau_Score__c == null || acc.Bureau_Score__c == ''){
                                        tsk.addError('Bureau Trigger did not happened for firm'+acc.Name); 
                                        break;
                                    }else if(acc.Jocata_List_Match__c == null || acc.Jocata_List_Match__c == ''){
                                        tsk.addError('List Matching did not happened for firm'+acc.Name); 
                                        break;
                                    }
                                }
                            }
                        }
                    } 
                    legalDeskCheck(appdet);
                }
                
                //approve disbursment
                if(tsk.Subject == 'Approve disbursement' && tsk.Status == 'Completed'){
                    if(tsk.WhatId != null){
                        genesis__Applications__c appTO = queryService.getApp(tsk.WhatId);
                        System.debug(')()()('+appTO);    
                        List<genesis__Application_Parties__c> ptList = [select Id from genesis__Application_Parties__c where genesis__Party_Type__c =:Constants.Gurantor AND Active__c =: true AND genesis__Application__r.Id =: appTO.Id];                        
                        if(appTO.genesis__Disbursement_Date__c !=null && appTO.MOD_Date__c !=null 
                           && appTO.genesis__Disbursement_Date__c < appTO.MOD_Date__c){
                               tsk.addError('Disbursement date cannot be before MOD date');  
                           }else if(appTO.Document_Generation__c != null){
                               if(((!appTO.Document_Generation__c.contains('A46 Doc Generation')) && (ptList.size() > 0)) || (!appTO.Document_Generation__c.contains('A23 Doc Generation')) || appTO.genesis__Disbursement_Date__c == null || appTO.Status_of_Deed__c == null || appTO.Type_Of_Charge__c == null){
                                   tsk.addError('Disbursment Document not generated');
                               }else{
                                   appTO.Sub_Stage__c = 'Disbursement Approved';
                                   appTO.Application_Stage__c = 'Disbursement Applications';
                                   ApplicationTriggerHandler.IsFirstRun = false;
                                   update appTO;
                                   System.debug('====='+appTO.Sub_Stage__c);
                               }
                           }else{
                               appTO.Sub_Stage__c = 'Disbursement Approved';
                               appTO.Application_Stage__c = 'Disbursement Applications';
                               ApplicationTriggerHandler.IsFirstRun = false;
                               update appTO;
                               System.debug('====='+appTO.Sub_Stage__c);
                           }
                    }
                }
                
                if((tsk.Subject == 'Verify property and upload valuation and legal reports') && tsk.Status == 'Completed'){//v2.4
                    System.debug('**Verify property and purpose of loan or Legal clearance');
                    if(tsk.WhatId != null){
                        if(appdet.Loan_Purpose__c==null || appdet.Branch_manager_visit_date__c==null || appdet.Branch_manager_visit_comments__c==null ){
                            tsk.addError('please fill  Loan purpose, visit date and comments');  
                        }
                    }
                }
                
            }
            //--------------------------------------------Lap end here++++++++++++++++++++++++++++++
            
            //------------------------------------------- Start Personal Loan++++++++++++++++++++++++++++
            if(appdet.Record_Type_Name__c==Constants.PERSONALLOAN && (appdet.Application_Stage__c != Constants.APPLICATION_REJECTED_MAINSTAGE && appdet.Application_Stage__c != Constants.DEACTIVATED_APPLICATIONS_MAINSTAGE)){//v2.3
                // rmd task --start
                if(tsk.Subject =='RMD Application Review' && tsk.Status =='Completed' && tsk.sanction__c==false){           
                    tsk.addError('Please approve/reject the RMD Application Review task on score tab');           
                    
                }
                // rmd task --end
                
                ///update creadit life insurence
                if(tsk.Subject =='Update credit life insurance' && tsk.Status =='Completed'){
                    
                    if(tsk.WhatId != null){
                        List<clcommon__Collateral_Insurance__c> insId = queryService.getInsurance(tsk.WhatId);
                        
                        if(insId.size() <> 0){    
                            if(insId[0].Upload_Insurance_Policy__c == false || insId[0].Policy_Type_pl__c == null || insId[0].clcommon__Policy_Number__c == null ||  insId[0].Date_Policy_Expiry__c == null || insId[0].Date_Insure__c == null || insId[0].Is_KVB_the_designated_assignee__c == 'No' || insId[0].Standing_Instruction_E_Mandate_Set_up_Co__c == 'No' ){
                                tsk.addError('Please fill all the Policy Insurance details');
                            }else if(insId[0].Date_Policy_Expiry__c < insId[0].Date_Insure__c){
                                tsk.addError('Policy end date cannot be earlier than Policy start date');
                            }      
                            else if(insId[0].Policy_Period__c < 1){
                                tsk.addError('Policy Period should be more than one year');
                            }
                        }else{
                            tsk.addError('Please fill all the Policy Insurance details');
                        } 
                        //application stage update 26-07-2018
                        genesis__Applications__c appdetails=queryService.getApp(tsk.WhatId);
                        changeFinalSubStage(appdetails, 'Update credit life insurance');
                        
                    }
                }
                
                
                //Assess Income PL
                // change parties
                //List<genesis__Application_Parties__c> partieslist=queryService.getparties(tsk.WhatId);
                for(genesis__Application_Parties__c par : partieslist){
                    if(par.genesis__Party_Type__c == Constants.PRIMARY_APP){
                        //Approve income
                        if(tsk.Subject =='Approve income' && tsk.Status =='Completed'){
                            System.debug('*Approve income');
                            if(tsk.WhatId != null){
                                if(appdet.Employment_Type__c != 'Salaried' && appdet.FI_Status__c == null && appdet.NMI_Approved__c <= 0 ){
                                    tsk.addError('Please fill FI details  or approved NMI should be greater than 0');                    
                                }
                                // TotalChequeBounc Count v1.9
                                TotalChequeBounc = TotalChequeBounc + par.Total_ChequeECS_bounces__c!= null?par.Total_ChequeECS_bounces__c:0;   
                                if(TotalChequeBounc > 1){
                                    //appdet.Application_Stage__c =Constants.APP_REJECTED_STAGE;        
                                    appdet.Sub_Stage__c='Cheque Returns';
                                    appdet.Total_Cheque_Bounces__c = TotalChequeBounc;
                                    ApplicationTriggerHandler.IsFirstRun = False;
                                    update appdet;
                                }
                                if(par.NMI_Approved__c < 25000 && par.Financial_Applicant__c && par.Employment_Types__c==constants.EmpType_Salaried){ // v1.9
                                    //appdet.Application_Stage__c =Constants.APP_REJECTED_STAGE;
                                    appdet.Sub_Stage__c= 'Income assessment rejected';
                                    ApplicationTriggerHandler.IsFirstRun = False;
                                    update appdet;
                                }      
                            }   
                        }
                        
                        if(tsk.Subject == 'Assess income' && tsk.Status == 'Completed'){
                            if(tsk.WhatId != null){
                                if((par.Existing_Emis__c == null || par.Max_Existing_EMI__c <>  par.Existing_Emis__c) && (par.EMI_Comments__c == null || par.EMI_Comments__c == '') ){
                                    tsk.addError('Please enter Existing EMI Approved & RLPC comments for Approved EMI.');
                                }
                                if(par.Employment_Type__c == 'Salaried' && (par.NMI_Approved__c - par.Max_Existing_EMI__c) <25000){
                                    tsk.addError('Approved NMI can not be less than 25000 for Salaried and  Non Govt. employee');
                                } 
                                if((Utility.ISStringBlankorNull(string.valueof(par.IFSC_code__c)) ||    Utility.ISStringBlankorNull(par.Bank_Account_Number__c) )&& par.Financial_Applicant__c== true){
                                    tsk.addError('Please enter IFSC Code & Primary Bank Account Number.');
                                }
                            }
                        }
                    }
                    
                    if(tsk.Subject == 'Failed Disbursement' && tsk.Status == 'Completed'){
                        if(tsk.WhatId != null){
                            genesis__Applications__c appTO = queryService.getApp(tsk.WhatId);
                            CBS_API_Log__c CBSFail = [Select id, Name,Sequence_No__c, CreatedDate, API_Name__c,Application__c,Status__c from CBS_API_Log__c where Sequence_No__c =: Constants.PL_DISBURSMNTFAIL_SEQ_NO AND  Application__c=: appTO.id order by CreatedDate desc limit 1];
                            if(appTO.Legal_desk_state_flag__c == true && CBSFail.Status__c !='Success'){
                                tsk.addError('Disbursement not yet completed');
                            }
                            if(appTO.Legal_desk_state_flag__c == false && appTO.All_signed_documents_been_uploaded__c == false){
                                tsk.addError('Please Upload all signed documents');
                            }
                            if(appTO.Legal_desk_state_flag__c == false && appTO.All_signed_documents_been_uploaded__c == true && CBSFail.Status__c !='Success'){
                                tsk.addError('Disbursement not yet completed');
                            }
                        }
                    }   
                } //end for loop
                
                //v2.1(start)
                //SI/ E-mandate task validation for PL
                /*if(tsk.Subject == 'SI/ E-mandate' && tsk.Status == 'Completed'){
System.debug('*SI/ E-mandate**');
if(tsk.WhatId != null){
if(appdet.Status__c !='Success'){
tsk.addError('Status should be success!!');
}
else if (appdet.Is_GMRA_Policy_Selected__c) {
List<Task> tskList = new List <Task>();
tskList = [Select Subject,WhatId,Status From Task Where WhatId =: tsk.WhatId AND Status !='Completed' and Subject!='SI/ E-mandate'];
if(tskList.size()==0){
genesis__Applications__c appln = new genesis__Applications__c();
appln.Application_Stage__c = Constants.DISBURSED_APPLICATION_MAINSTAGE;
appln.Sub_Stage__c = Constants.App_Process_Closed;
ApplicationTriggerHandler.IsFirstRun = False;
update appln;                      
}
}                            
}                                      
}*/
                //v2.1(end)
            }
            //---------------------------------------------- End Personal Loan+++++++++++++++++++++++++
            
            //----------------------------------------------Start Vehicle Loan--------------------------------
            //V1.1-start
            if((appdet.Record_Type_Name__c==Constants.VL2W || appdet.Record_Type_Name__c==Constants.VL4W) && (appdet.Application_Stage__c != Constants.APPLICATION_REJECTED_MAINSTAGE && appdet.Application_Stage__c != Constants.DEACTIVATED_APPLICATIONS_MAINSTAGE)){//v2.3
                if(tsk.Subject == 'Assess Income' && tsk.Status == 'Completed'){
                    Integer VerifyCount1 = 0;
                    Integer PrimaryBankNullCount = 0;
                    Integer financialPartyCount2 = 0;
                    if(tsk.WhatId != null){
                        for(genesis__Application_Parties__c appParty: appdet.genesis__Application_Parties__r) {
                            
                            if((Utility.ISStringBlankorNull(string.valueof(appParty.IFSC_code__c)) ||   Utility.ISStringBlankorNull(appParty.Bank_Account_Number__c) ) && appParty.Financial_Applicant__c== true){
                                tsk.addError('Please enter IFSC Code & Primary Bank Account Number.');
                            }
                            
                            if(appParty.Verify_PAN_Number__c == 'Yes' && appParty.Financial_Applicant__c == true){
                                VerifyCount1++;
                                financialPartyCount2++;
                            }
                            //added -niladri-suggested by shreya
                            if((appParty.Average_Balances_6_months__c == 0 || appParty.Average_Balances_6_months__c == null) && (appParty.Financial_Applicant__c == true)){
                                tsk.addError('Average Six Month Balances should be greater than 0');
                            } 
                            //
                            if(appParty.Financial_Applicant__c == true && appParty.Primary_Bank__c==null) {
                                PrimaryBankNullCount++;
                            }
                            if(appParty.Financial_Applicant__c){
                                partListSizechck.add(appParty);
                            }
                            if((appParty.Existing_Emis__c == 0 || appParty.Existing_Emis__c == null || appParty.Max_Existing_EMI__c <>  appParty.Existing_Emis__c) && (appParty.EMI_Comments__c == null || appParty.EMI_Comments__c == '') && appParty.Financial_Applicant__c == true){
                                tsk.addError('Please enter Existing EMI Approved & RLPC comments for Approved EMI.');
                            } 
                        }
                        System.debug(partListSizechck.size()+'==partieslist.size()==PrimaryBankNullCount=='+PrimaryBankNullCount);
                        if(financialPartyCount2 != VerifyCount1){
                            //System.debug('Please Complete Verification Of PAN');
                            tsk.addError('Please Complete Verification Of PAN'); 
                        }   
                        if(PrimaryBankNullCount > 0){
                            //System.debug('Bank Name cannot be null!!');
                            tsk.addError('Bank Name cannot be null!!'); 
                        }                            
                    }                                      
                } 
                
                if(tsk.Subject == 'Approve Income' && tsk.Status == 'Completed'){
                    System.debug('*inside Approve Income**appdet.NMI_Approved__c=='+appdet.NMI_Approved__c);
                    if(tsk.WhatId != null){
                        if(appdet.NMI_Approved__c == null || appdet.NMI_Approved__c == 0){    
                            tsk.addError('NMI approved cannot be null!!');
                        }else if(appdet.Total_Cheque_Bounces__c > 5){ //v1.9
                            //appdet.Application_Stage__c =Constants.APP_REJECTED_STAGE;        
                            appdet.Sub_Stage__c='Cheque Returns';
                            ApplicationTriggerHandler.IsFirstRun = False;
                            update appdet;
                        } //v1.9
                        for(genesis__Application_Parties__c appParty: appdet.genesis__Application_Parties__r) {
                            if(appParty.Financial_Applicant__c &&( (appParty.NMI_Approved__c < Integer.valueOf(Label.VL_MIN_EMI_2W) && appdet.Record_Type_Name__c==Constants.VL2W) || (appParty.NMI_Approved__c < Integer.valueOf(Label.VL_MIN_EMI_4W) && appdet.Record_Type_Name__c==Constants.VL4W) ) ){
                                //appdet.Application_Stage__c =Constants.APP_REJECTED_STAGE;
                                appdet.Sub_Stage__c= 'Income assessment rejected';
                                ApplicationTriggerHandler.IsFirstRun = False;
                                update appdet; //v1.9
                            }
                        }                             
                    }                                      
                }
                
                /*if(tsk.Subject == 'SI/ E-mandate' && tsk.Status == 'Completed'){
System.debug('*SI/ E-mandate**');
if(tsk.WhatId != null){
if(appdet.Status__c !='Success'){
tsk.addError('Status should be success!!');
}                            
}   
if (tsk.Id!=null && tsk.WhatId!=null) {
List<Task> tskList = new List <Task>();
tskList = [Select Subject,WhatId,Status From Task Where WhatId =: tsk.WhatId AND Status !='Completed' and Subject!='SI/ E-mandate'];
if(tskList.size()==0){
genesis__Applications__c appln = new genesis__Applications__c();
appln.Id = tsk.WhatId;
appln.Sub_Stage__c = Constants.App_Process_Closed;
appln.Application_Stage__c=Constants.DISBURSED_APPLICATION_MAINSTAGE;
ApplicationTriggerHandler.IsFirstRun  = false;
update appln;
}
}
}*/
                //v1.4(start)
                if(tsk.Subject == 'Generate dealer document' && tsk.Status == 'Completed'){
                    System.debug('*Generate dealer document**');
                    if(tsk.WhatId != null){
                        String DDNo  = appdet.genesis__Collaterals__r[0].DD_No__c;
                        if(!appdet.Document_Generation__c.contains(Constants.VL3_DOCGEN) || DDNo==null || DDNo=='' || !appdet.Document_Generation__c.contains(Constants.VL6_DOCGEN)){
                            tsk.addError('Please generate dealer document!');
                        }                                
                    }                                      
                }
                //v1.4(end)
                
              
                //start 
                //Update mandatory documents & verify RC details task validation and update stage
                if(tsk.Subject =='Update mandatory documents & verify RC details' && tsk.Status =='Completed'){ 
                    System.debug('*Update mandatory documents & verify RC details**');
                    if(tsk.WhatId != null && appdet.genesis__Collaterals__r.size()>0){
                        clcommon__Collateral__c collateral=new clcommon__Collateral__c();
                        collateral = appdet.genesis__Collaterals__r[0];
                        
                        if(!collateral.clcommon__Collateral_Insurance_Required__c || !collateral.clcommon__Homestead_Property__c || !collateral.clcommon__IDERA__c || !collateral.clcommon__Inspection_Report__c)    
                            tsk.addError('Upload mandatory documents!!');  
                        
                        if(collateral.clcommon__Vehicle_Serial_Number__c==null || collateral.Financing_Authority__c==null || collateral.Vehicle_Owner_Name__c==null)    
                            tsk.addError('Get RC details!!');  
                        if(collateral.RC_Date__c.daysBetween(System.today())> 90){
                            tsk.addError('vehicle age is more than 90 days');
                        }
                        if(collateral.NameMatch__c==null || collateral.CollateralMatch__c== null ){
                            tsk.addError('please select two question on vehicle page');
                        }
                        if(!(collateral.clcommon__Vehicle_Serial_Number__c.equalsIgnoreCase(collateral.Engine_No__c)) && !(collateral.Chassis_Number__c.equalsIgnoreCase(collateral.Chassis_No__c))){
                            if(!(collateral.clcommon__Vehicle_Serial_Number__c.left(4).equalsIgnoreCase(collateral.Engine_No__c.left(4))) && !(collateral.Chassis_Number__c.left(4).equalsIgnoreCase(collateral.Chassis_No__c.left(4)))){
                                
                                tsk.addError('Engine no or chasis no is not matched'); 
                            }
                        }
                         String financeAuth=collateral.Financing_Authority__c;
                set<string> karurlist=new Set<string>{'Vysya','VYSYA','KVB','kvb','vysya'};
                boolean checkKVB=false;
                List<String> lsttest=financeAuth.split(' ');

              for(String s: lsttest){
                if(karurlist.contains(s)){
                checkKVB=true;
                System.debug('tesr'+checkKVB);
               break;
        }
    }
                        
                        
                        if(collateral.NameMatch__c=='Yes' && collateral.CollateralMatch__c=='Yes' && checkKVB && collateral.RC_Response_Error_Message__c!=Constants.RegistrationNot){
                            List<string> rctaskname=new List<string>{'Update mandatory documents & verify RC details','Confirm RC details'};                    
                            List<Task> tskList = new List <Task>();
                            if (tsk.Id!=null && tsk.WhatId!=null){
                                tskList = [Select Subject,WhatId,Status From Task Where WhatId =: tsk.WhatId AND Status != 'Completed' and Subject=:rctaskname];
                                System.debug(tskList.size()+'**tskList==>'+tskList);
                            }
                            if(tskList.size()==0){
                                genesis__Applications__c appln = new genesis__Applications__c();
                                appln.Id = tsk.WhatId;
                                appln.Sub_Stage__c = Constants.col_details;
                                update appln;
                            }
                        }
                        
                        
                    }
                    
                }
                
                //end of Update mandatory documents & verify RC details task
              
            //start---
            if((tsk.Subject =='Confirm RC details' || tsk.Subject =='Validate collateral details mis-match') && tsk.Status =='Completed'){
                System.debug('*Confirm RC details**'); 
                if(tsk.WhatId != null && appdet.genesis__Collaterals__r.size()>0){
                    clcommon__Collateral__c collateral=new clcommon__Collateral__c();
                    collateral = appdet.genesis__Collaterals__r[0];
                    
                    if(collateral.Security_Details__c==null)    
                        tsk.addError('Please fill comments!!');
                    
                    if (collateral.Security_Details__c!=null ) {
                        List<Task> tskList = new List <Task>();
                        if (tsk.Id!=null && tsk.WhatId!=null) {
                            tskList = [Select Subject,WhatId,Status From Task Where WhatId =: tsk.WhatId AND Status !='Completed' AND (Subject=:'Confirm RC details' OR Subject =:'Validate collateral details mis-match')];
                            System.debug(tskList.size()+'**tskList==>'+tskList);
                        }
                        if(tskList.size()==0){
                            genesis__Applications__c appln = new genesis__Applications__c();
                            appln.Id = tsk.WhatId;
                            appln.Sub_Stage__c = Constants.col_details;
                            update appln;
                        } 
                    }
                }
                
            }
            }  
            //end----
            
            //----------------------------------------------End Vehicle Loan--------------------------------
        }
        catch(exception e){
            System.debug('error LineNumber'+e.getLineNumber()+' message '+e.getMessage());
            HandleBusinessException.captureError('Retry_Task_call', 'ValidateTask', e);
        }
    }
    //End Validation on Task ---------------------------------------------------------------------------
    
    // v1.8 Start
    public static double conversion(decimal D){
        decimal z;
        if(D>0){
            z=decimal.valueOf((integer.valueOf(D))/1000)*1000;
        }
        else{
            z=D;  
        }
        return z;
    }// v1.8 End
    
    
    // v1.8 Start
    // Rerun eligibility on FI Status from Application.
    public static void FIRerunElig(List<genesis__Applications__c> Newapps, Map<Id,genesis__Applications__c>  oldApp){
        Boolean fiRmd=false;
        List<Task> PLtskList = new List <Task>();
        List<Task> PLtskList1 =new List<Task>();
        List<Task> IncompleteList = new List <Task>();
        List <String> completeList = new List<String>();
        Task TaskT = new Task();
        for(genesis__Applications__c app : Newapps){
            if((app.Record_Type_Name__c == Constants.LAPLOAN || app.Record_Type_Name__c == Constants.PERSONALLOAN || app.Record_Type_Name__c  == Constants.HOMELOAN || app.Record_Type_Name__c  ==Constants.VL4W || app.Record_Type_Name__c  ==Constants.VL2W) && oldApp.get(app.Id).FI_Status__c <> app.FI_Status__c && app.FI_Status__c == Constants.PL_FIRES_POSI){
                PLtskList = [Select Subject,WhatId,Status From Task Where WhatId =: oldApp.keySet()]; // AND Status = 'Completed'];
                PLtskList1 = [Select Subject,WhatId,Status From Task Where WhatId =: oldApp.keySet() AND Subject!='Verify KYC'];
            }    
        }
        if(PLtskList.size() > 0){
            
            for(Task tk : PLtskList){
                if(tk.subject=='RMD Application Review'){
                    fiRmd=true;
                }
                if(tk.Status != 'Completed'){
                    IncompleteList.add(tk);
                }
                else if(tk.Status == 'Completed'){
                    completeList.add(tk.Subject);
                }
            }
        }
        
        for(genesis__Applications__c Ap:Newapps){
            genesis__Applications__c oldPlan = oldApp.get(Ap.Id);
            System.debug('##### in rerun positive '+ Newapps);
            if(PLtskList.size() > 0){
                if( Ap.FI_Status__c == Constants.PL_FIRES_POSI && oldPlan.FI_Status__c != Ap.FI_Status__c  && Ap.Record_Type_Name__c  == Constants.PERSONALLOAN && IncompleteList.Size() == 0){
                    if(fiRmd){
                        recallTasknew(null,True,Ap.id);
                    }
                    else{
                        recallTasknew(PLtskList1[0],false,Ap.id);
                    }     
                }else if( Ap.FI_Status__c == Constants.PL_FIRES_POSI && oldPlan.FI_Status__c != Ap.FI_Status__c && Ap.Record_Type_Name__c  == Constants.LAPLOAN && IncompleteList.Size() == 0){
                    recallTasknew(null,True,Ap.id);
                }else if( Ap.FI_Status__c == Constants.PL_FIRES_POSI && oldPlan.FI_Status__c != Ap.FI_Status__c && IncompleteList.Size() == 0 && (Ap.Record_Type_Name__c  == Constants.VL4W || Ap.Record_Type_Name__c  == Constants.VL2W)){
                    System.debug('##### before VL FI Rerun on Positive '+ Ap.FI_Status__c);
                    recallTasknew(null,True,Ap.id);
                }
                else if( IncompleteList.Size()==0  && Ap.Record_Type_Name__c  == Constants.HOMELOAN ){
                    recallTasknew(null,True,Ap.id);
                }
            }else if(PLtskList.size() <= 0){
                // prashant singh----Ap.Record_Type_Name__c==Constants.HOMELOAN
                if( (Ap.FI_Status__c == Constants.PL_FIRES_POSI && oldPlan.FI_Status__c != Ap.FI_Status__c  && (Ap.Record_Type_Name__c  == Constants.PERSONALLOAN ||  Ap.Record_Type_Name__c  == Constants.LAPLOAN || Ap.Record_Type_Name__c  == Constants.VL4W || Ap.Record_Type_Name__c  == Constants.VL2W))) {
                    System.debug('##### apids '+ Ap.id);
                    recallTasknew(null,True,Ap.id);
                }
            } 
            
        }
    }    // v1.8 END 
    
    //v2.3(start)
    public static List<Account> getUpdatedAccAddress(Id appId){
        try {
            List<Astute_Verification__c> astList = new List<Astute_Verification__c>();
            astList = queryService.getAstuteRecord(appId);
            set<id> accIdSet = new set<Id>();
            for(Astute_Verification__c astute: astList) {
                accIdSet.add(astute.Account__c);
            }
            Map<Id,Account> mapAcc = new Map<Id,Account>(queryService.accListCust(new List<id>(accIdSet)));
            Map<Id,Account> accMapToUpdate = new Map<Id,Account>();
            for(Astute_Verification__c astute: astList){
                Account acc = new Account();
                if (accMapToUpdate.containsKey(astute.Account__c)) {
                    acc = accMapToUpdate.get(astute.Account__c);
                }
                if (astute.Case_Id__c==Constants.FI_MANUAL && astute.Change_in_Address__c && astute.Revised_Address__c !=null){
                    if (astute.Property_Type__c==Constants.ACTIVITY_DESCR) {
                        acc.PersonMailingStreet = astute.Revised_Address__c;
                    } else if (astute.Property_Type__c==Constants.ACTIVITY_DESCO){
                        if(mapAcc.get(astute.Account__c).RecordType.DeveloperName==Constants.BUSINESS_ACCOUNT){
                            acc.Billingstreet = astute.Revised_Address__c;
                        } else {
                            acc.Holding_Comp_Address__c = astute.Revised_Address__c;
                        }
                    }
                    acc.Id = astute.Account__c;
                    accMapToUpdate.put(astute.Account__c,acc);
                }
            }
            return accMapToUpdate.values();
        } catch(Exception e) {
            System.debug('error LineNumber'+e.getLineNumber()+' message '+e.getMessage());
            return null;
        }
    }
    //v2.3(end)
    public static void changeFinalSubStage(genesis__Applications__c app, String taskName){
        genesis__Applications__c application = new genesis__Applications__c();
        List<Task> tskList =  [Select Subject,WhatId,Status From Task Where WhatId =: app.Id AND Status !='Completed' AND Subject !=: taskName];
        if(tskList.size() == 0){
            application.Id = app.Id;
            application.Sub_Stage__c = Constants.App_Process_Closed;
            if((app.Record_Type_Name__c == 'Home Loan' || app.Record_Type_Name__c == 'LAP') && taskName == 'SI/ E-mandate'){
                update application;    
            }
            else if((app.Record_Type_Name__c == 'Personal Loan' || app.Record_Type_Name__c == 'VL2W' || app.Record_Type_Name__c == 'VL4W') && (taskName == 'SI/ E-mandate' || taskName =='Update credit life insurance')){
                ApplicationTriggerHandler.IsFirstRun = False;
                update application;
            }else{
                update application;
            }
            
        }
        
    }
     public static boolean ValidationOfAssessIncomeTaskWithFCU(genesis__Applications__c app){
        List<Task> tskList = new List<Task>();
        tskList = [Select Id,WhatID,Status,Subject From Task Where WhatID =: app.Id AND Subject='Trigger FCU' AND Status!='Complete'];
         if(tskList.size()!=0) return true; else return false;
    }
    public static void legalDeskCheck(genesis__Applications__c app){
		List<String> SM = new List<String>();
		for(State_Master__c sMaster : [select id, Name from State_Master__c where Legal_desk_state_flag__c = true]){
			SM.add((sMaster.Name).toUpperCase());
		}

		Map<String, String> stateMap = new Map<String, String>();
		for(Branch_Master__c bm : [select id, CODCCBRN__c, State__c from Branch_Master__c]){
			stateMap.put(bm.CODCCBRN__c, bm.State__c);
		}

		if(!SM.contains(stateMap.get(app.Branch_Code__c))){
			genesis__Applications__c gap = new genesis__Applications__c();
			gap.Legal_desk_state_flag__c = false;
			gap.id = app.id;
			update gap;
		}
	}
    
}