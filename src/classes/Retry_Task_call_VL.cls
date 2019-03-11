/*
* Name          : Retry_Task_call_VL
* Description   : Handle Retry_Task_call_VL
* Author        : Niladri Kundu
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
v1.1    13-Nov-2018    Braj           #VL717:ROI for Cibil score -1 to 10 and 650-700 is also made configurable in custom setting record 'MCLR Excess Code' and re-calculating BankYear again in re-run
v1.2    26-Dec-2018    Braj           #VL774: LTV criteria changes to cibil from loan amount
*******************************************************************************************/

Global class Retry_Task_call_VL {
    public static Boolean IsFirstRun = true;
    public static Decimal IntRate_Latest = 0.0;
    public static Void RecalculateEligibilityVL(genesis__Applications__c application,String checkCal){
        try{
            Decimal pmaxprod;
            //Decimal IntRate_Latest;
            if(application.Record_Type_Name__c==Constants.VL4W){
                    BREScoreCal.IntRateCal Intrest= BREScoreCal.HL_Intrate(application);
                    IntRate_Latest=Intrest.IntRate;
                    System.debug('IntRate >>> ' + IntRate_Latest);
                    //application.genesis__Interest_Rate__c=IntRate_Latest;
                } 
            Decimal EMIMAX = calEMIVL(application);
            Decimal Pmax1 =  calPmaxVL(application);
            Decimal PMax2 = (EMIMAX*((Math.exp(application.genesis__Term__c *(Math.log((1+((application.genesis__Interest_Rate__c /12)/100))))))-1)) / ((( application.genesis__Interest_Rate__c /12)/100)*(Math.exp(application.genesis__Term__c * (Math.log((1+(( application.genesis__Interest_Rate__c /12)/100)))))));            
            Decimal PMax = math.min((Pmax1 != null ? Pmax1 : 0),(PMax2 != null ? PMax2 : 0));            
            PMax = Retry_Task_call.conversion(PMax);
            NumberToWordConversion ntwc = new NumberToWordConversion();
            system.debug('%%%%%'+application.genesis__Loan_Amount__c+'$$'+PMax);
            
            if(application.Record_Type_Name__c==Constants.VL2W){
                clcommon__CL_Product__c m=[select Max_Amount__c,clcommon__Product_Name__c from clcommon__CL_Product__c where    clcommon__Product_Name__c=:Constants.VL2WPRODNM];
                pmaxprod=  m.Max_Amount__c;
            }else{
                clcommon__CL_Product__c m=[select Max_Amount__c,clcommon__Product_Name__c from clcommon__CL_Product__c where    clcommon__Product_Name__c=:Constants.VL4WPRODNM];
                pmaxprod= m.Max_Amount__c; 
            }
            // Pre approved logic 
            /*if(application.Acknowledgement__c ){
                application.Sub_Stage__c = 'Loan Sanctioned STP';
                Application.Sanctioned_Tenure__c = Application.genesis__Term__c;
                Application.Sanction_Authority_Limit__c = Retry_Task_call.conversion(Application.genesis__Loan_Amount__c);
                Application.Disbursement_Amount__c=Retry_Task_call.conversion(Application.genesis__Loan_Amount__c);
                Application.Sanctioned_EMI__c   =Application.genesis__Payment_Amount__c;
                ApplicationTriggerHandler.IsFirstRun = False;
                update application;
            }*/
            //pmin temp
            //if(PMax < application.PMin__c){
            //    System.debug('object >>> check call ' + PMax);
            //    application.Sanction_Authority_Limit__c = PMax;
            //    application.Disbursement_Amount__c=PMax;
            //    application.Sanction_Amount_Words__c = ntwc.getNumberTOWordConvertion(Retry_Task_call.conversion(PMax));
            //    /*application.Sub_Stage__c = 'Income assessment rejected';
            //    application.Application_Stage__c = Constants.APP_REJECTED_STAGE;
            //    */ApplicationTriggerHandler.IsFirstRun = False;
            //    update application;
            //}else{  
                Decimal EMIMAX2;
                if(PMax >= application.genesis__Loan_Amount__c ){
                    EMIMAX2 = application.genesis__Payment_Amount__c;
                    PMax = application.genesis__Loan_Amount__c;
                    //BREScoreCal.Calculate_Bre(application,application.genesis__Loan_Amount__c,application.genesis__Payment_Amount__c,'Loan Sanctioned Non-STP');// VL NEW
                    //BREScoreCal.Calculate_Bre(application,application.genesis__Loan_Amount__c,application.genesis__Payment_Amount__c,'');
                    System.debug('object Loan Amount <= Pmax>>> ' + PMax);
                }else{
                    System.debug('object else Pmax > loan amount >>> ' + Pmax);
                    application.Sanction_Authority_Limit__c = PMax;
                    application.Disbursement_Amount__c = PMax;
                    Decimal R = application.genesis__Interest_Rate__c/1200;
                    Integer N = Integer.ValueOf(application.genesis__Term__c);
                    Decimal Rplus = (1+R);
                    EMIMAX2 = ((PMax) * R * (Rplus.pow(N))/((Rplus.pow(N))-1));
                   // if(application.ValidateTask__c){
                        String usrId = TaskFlow_Helper.getUserList(application.Branch_Code__c,'Branch manager');
                        if(usrId != null){
                            TaskFlow_Helper.creatTaskAll(application.Id, usrId, 'Validate sanction at re-calculated eligibility', 1);                            
                        }
                  //  }
                }
                if(checkCal == '3'|| checkCal == 'VEVL'){
                        System.debug('object checkCal >>> ' + checkCal);
                        BREScoreCal.Calculate_Bre(application,PMax,EMIMAX2,checkCal);
                    }else{
                        BREScoreCal.Calculate_Bre(application,PMax,EMIMAX2,'');
                }
           //pmin temp }
        }
        catch(Exception e){
            system.debug('##Retry Exceptions ### --- > '+ e.getLineNumber() +' '+e.getMessage());
            HandleBusinessException.captureError('Retry_Task_call', 'calculateEligibilityLAP', e);
        }
    }
    
    //calclate eligibility
    public static decimal calPmaxVL(genesis__Applications__c App){
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
        Decimal NmiClaimed = 0.00;
        Decimal ExistingEMI = 0.00;
        Decimal EMIMax = 0.00;
        Decimal Pmax1 = 0.00;
         //VL Scheme Selection Variables
        String SelectedSchm;
        List<Scheme_Master__c> SelectedScheme = new List<Scheme_Master__c>();
        //v1.1(start)
        Map<Decimal,Integer> BankYearList = new Map<Decimal,Integer>();
        Integer MaxBankWithUS = 0;
        Decimal NMIITR1 = 0;
        //v1.1(end)

        genesis__Applications__c App1= appdetails(App.id);
        if(App.Record_Type_Name__c == Constants.VL2W){
            System.debug('*inside VL2W');
            Map<Decimal,String> AppEmpType = NEW Map<Decimal,String>();
            List<Decimal> NetIncome = new List<Decimal>();
            String EMType = '';
            for(genesis__Application_Parties__c pars :App1.genesis__Application_Parties__r){

                NMIITR1=pars.NMI_Approved__c;//v1.1

                if(pars.Financial_Applicant__c && (pars.genesis__Party_Type__c == Constants.PRIMARY_APP || pars.genesis__Party_Type__c == Constants.Co_Borrower)){
                    AppEmpType.put(pars.NMI_Approved__c, pars.Employment_Types__c);
                    //v1.1(start)
                    if(pars.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c <> null){
                        Decimal YearCount = 0.00;
                        YearCount =( (pars.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c.daysBetween(System.today()))/365.2425);
                        System.debug('object YearCount>>> ' + YearCount);
                        BankYearList.put(NMIITR1,Integer.valueOf(YearCount.round(System.RoundingMode.HALF_UP)));
                    }
                    else {
                        BankYearList.put(NMIITR1,0);
                    }
                    //v1.1(end)
                }

            }
            if(AppEmpType.values() <> null){
                NetIncome.addAll(AppEmpType.keySet());
                NetIncome.sort();
                EMType = AppEmpType.get(NetIncome[NetIncome.size()-1]);
            }
            System.debug('EMType >>> ' + EMType);

            //v1.1(start)
            List<Decimal> MaxNMIList = new List<Decimal>();
            if(BankYearList.size() > 0){
                MaxNMIList.addAll(BankYearList.keySet());
                MaxNMIList.sort();
                Integer BnkCount = MaxNMIList.size()-1;
                MaxBankWithUS = BankYearList.get(MaxNMIList[BnkCount]);
                System.debug(' MaxBankWithUS  >>> ' +  MaxBankWithUS );
            }
            //v1.1(end)

            for(clcommon__Collateral__c cc : App1.genesis__Collaterals__r){
                ExShowVehicleCost += Utility.isNullOrZeroDecimal(cc.ExShow_Room_Price__c);
                //  MasterVehicleCost += ApplicationEligibiltyHandler.getPriceMaster(cc.clcommon__Model__c,cc.clcommon__Manufacturer__c,cc.Variant__c);
                MasterVehicleCost += Utility.isNullOrZeroDecimal(cc.ExshowRoomPrice_Api__c); 
                RegistrationCost +=Utility.isNullOrZeroDecimal( cc.Registration_cost__c);
                AccessoriesCost += Utility.isNullOrZeroDecimal(cc.Accessories_value__c);
                InsuranceCost += Utility.isNullOrZeroDecimal(cc.clcommon__Insurance_Amount__c);
                SelectedSchm = cc.Scheme_Type__c != null ? cc.Scheme_Type__c : '';
            }

            SelectedScheme =  [Select Id,Name,Scheme_Code__c,ProductType__c,Active_Flag__c,LTV_increase__c,Pricing_Discount__c,Processing_fee_discount__c from Scheme_Master__c Where ProductType__c=:Constants.VL2W and Scheme_Code__c=:SelectedSchm limit 1];

            VehicleCost = Math.min((Constants.VL_MSTRVLCOSTPRCNT*MasterVehicleCost), (ExShowVehicleCost));
            System.debug('*VehicleCostVL2w'+VehicleCost);
            if(VehicleCost > Constants.VEHICLECOST2L){
                TotalAccessoriesCost = Math.min(20000, AccessoriesCost);
            }else{
                TotalAccessoriesCost = 0;
            }
            TotalVehicleCost =(VehicleCost + RegistrationCost + TotalAccessoriesCost + InsuranceCost);
            System.debug('*TotalVehicleCostvl2w'+TotalVehicleCost);
            Decimal Pmax = 0.00;
            Integer NmaxTW = 0; 
            Decimal AddIncome1 = 0;
            Integer MaxCiblScore = App1.Max_CIBIL_Score__c != null ? Integer.valueOf(App1.Max_CIBIL_Score__c) : 0;
            //Integer MaxBankWithUS = App1.BankYear__c != null ? Integer.valueOf(App1.BankYear__c) : 0;
            EMType = EMType != Constants.EmpType_Salaried  ? Constants.EmpType_Other : EMType;
            String RetCat;

            ApplicationEligibiltyHandler.mclr MInt=new ApplicationEligibiltyHandler.mclr();

            if(SelectedScheme.size() > 0){
                Pmax1 = (SelectedScheme[0].LTV_increase__c*TotalVehicleCost)/100; 
            }else{
                //v1.2(start)
                if(MaxCiblScore>=750){
                    Pmax1 = (Constants.VL4WEQUL_VL90PRCNT*TotalVehicleCost);
                }else if((MaxCiblScore < 750 && MaxCiblScore >= 650) || MaxCiblScore == -1 || MaxCiblScore == 5 || (MaxCiblScore >= 8 && MaxCiblScore <= 10)){
                    Pmax1 = (Constants.VL2WGRET_2L85PRCNT*TotalVehicleCost);
                }
                //v1.2(end)
            }
            
            if(TotalVehicleCost <= Constants.VEHICLECOST2L){
                // Vehicle value <= 2L
                //v1.1(start)
                if( (MaxCiblScore >=-1  && MaxCiblScore <= 10)){
                    RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'C' : 'D') : ( MaxBankWithUS > 0.5 ? 'C' : 'D');
                    System.debug('Below 2L/Cibil=-1/RetCat==='+RetCat+' EMType=='+EMType);
                    MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.VL2W,RetCat,-1,EMType);
                    ROI=   MInt.Excess;
                }
                else if( MaxCiblScore>=650 &&  MaxCiblScore <700){
                    RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'C' : 'D') : ( MaxBankWithUS > 0.5 ? 'C' : 'D');
                    System.debug('Below 2L/Cibil=650/RetCat==='+RetCat+' EMType=='+EMType);
                    MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.VL2W,RetCat,650,EMType);
                    ROI=   MInt.Excess;
                }
                //v1.1(end)
                else if( MaxCiblScore>=700 &&  MaxCiblScore <750){
                    RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'C' : 'D') : ( MaxBankWithUS > 0.5 ? 'C' : 'D');
                    System.debug('Below 2L/Cibil=700/RetCat==='+RetCat+' EMType=='+EMType);
                    MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.VL2W,RetCat,700,EMType);
                    ROI=   MInt.Excess;
                }
                else if( MaxCiblScore>=750){
                    RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'C' : 'D') : ( MaxBankWithUS > 0.5 ? 'C' : 'D');
                    System.debug('Below 2L/Cibil=750/RetCat==='+RetCat+' EMType=='+EMType);
                    MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.VL2W,RetCat,750,EMType);
                    ROI=   MInt.Excess;
                }
            }else{
                // Vehicle value > 2L
                //v1.1(start)
                if( (MaxCiblScore >=-1  && MaxCiblScore <= 10)){
                    RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'A' : 'B') : ( MaxBankWithUS > 0.5 ? 'A' : 'B');
                    System.debug('Above 2L/Cibil=-1/RetCat==='+RetCat+' EMType=='+EMType);
                    MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.VL2W,RetCat,-1,EMType);
                    ROI=   MInt.Excess;
                }
                else if( MaxCiblScore>=650 &&  MaxCiblScore <700){
                    RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'A' : 'B') : ( MaxBankWithUS > 0.5 ? 'A' : 'B');
                    System.debug('Above 2L/Cibil=650/RetCat==='+RetCat+' EMType=='+EMType);
                    MInt=ApplicationEligibiltyHandler.MclrCalc(365,Constants.VL2W,RetCat,650,EMType);
                    ROI=   MInt.Excess;
                }
                //v1.1(end)
                else if( MaxCiblScore>=700 &&  MaxCiblScore <750){
                    RetCat  = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'A' : 'B') : ( MaxBankWithUS > 0.5 ? 'A' : 'B');
                    System.debug('Above 2L/Cibil=700/RetCat==='+RetCat+' EMType=='+EMType);
                    MInt    =ApplicationEligibiltyHandler.MclrCalc(365,Constants.VL2W,RetCat,700,EMType);
                    ROI     =   MInt.Excess;
                }
                else if( MaxCiblScore>=750){
                    RetCat = EMType == Constants.EmpType_Salaried ? (MaxBankWithUS > 0.5 ? 'A' : 'B') : ( MaxBankWithUS > 0.5 ? 'A' : 'B');
                    System.debug('Above 2L/Cibil=750/RetCat==='+RetCat+' EMType=='+EMType);
                    MInt   = ApplicationEligibiltyHandler.MclrCalc(365,Constants.VL2W,RetCat,750,EMType);
                    ROI    = MInt.Excess;
                }
            }

            if(SelectedScheme.size() > 0){
                App.genesis__Interest_Rate__c = (ROI - SelectedScheme[0].Pricing_Discount__c);
            }else{
                App.genesis__Interest_Rate__c = ROI;
            }
            App.BankYear__c = MaxBankWithUS;//v1.1
            // end of new chnages
        }
        if(App.Record_Type_Name__c == Constants.VL4W){
            System.debug('*inside vl4w');
            for(clcommon__Collateral__c cc : App1.genesis__Collaterals__r){
                System.debug('cc'+ cc);
                ExShowVehicleCost = ExShowVehicleCost+Utility.isNullOrZeroDecimal(cc.ExShow_Room_Price__c);
                //    MasterVehicleCost =MasterVehicleCost+ ApplicationEligibiltyHandler.getPriceMaster(cc.clcommon__Model__c,cc.clcommon__Manufacturer__c,cc.Variant__c);
                MasterVehicleCost += Utility.isNullOrZeroDecimal(cc.ExshowRoomPrice_Api__c); 
                System.debug('*MasterVehicleCost'+MasterVehicleCost);
                RegistrationCost = RegistrationCost + Utility.isNullOrZeroDecimal(cc.Registration_cost__c);
                AccessoriesCost =AccessoriesCost +Utility.isNullOrZeroDecimal(cc.Accessories_value__c);
                InsuranceCost = InsuranceCost + Utility.isNullOrZeroDecimal(cc.clcommon__Insurance_Amount__c);
                SelectedSchm = cc.Scheme_Type__c != null ? cc.Scheme_Type__c : '';
            }

            SelectedScheme =  [Select Id,Name,Scheme_Code__c,ProductType__c,Active_Flag__c,LTV_increase__c,Pricing_Discount__c,Processing_fee_discount__c from Scheme_Master__c Where ProductType__c=:Constants.VL4W and Scheme_Code__c=:SelectedSchm limit 1];
            VehicleCost = Math.min((1.05*MasterVehicleCost), (ExShowVehicleCost));
            System.debug('**VehicleCost'+VehicleCost);
            TotalAccessoriesCost = Math.min(50000, AccessoriesCost);
            TotalVehicleCost =(VehicleCost + RegistrationCost + TotalAccessoriesCost + InsuranceCost);
            System.debug('**TotalVehicleCost'+TotalVehicleCost);                            
            Decimal AddIncome1 = 0;
            if(SelectedScheme.size() > 0){
                    Pmax1 = (SelectedScheme[0].LTV_increase__c*TotalVehicleCost)/100;
                    App.genesis__Interest_Rate__c= (IntRate_Latest - SelectedScheme[0].Pricing_Discount__c);
                }else{
                    Pmax1 = (Constants.VL4WEQUL_VL90PRCNT*TotalVehicleCost);
                    App.genesis__Interest_Rate__c=IntRate_Latest;
                }
        }
        return Pmax1;
    }
    //Calculating Max EMI for VL
    public static decimal calEMIVL(genesis__Applications__c App){
        Decimal EMIMax=0;
        Decimal NMI;
        //Decimal ExistingEMI =0;
        //Decimal NmiClaimed = 0.0;  
        Decimal AddIncome1 = 0.00;
        Decimal NMIITR1=0.0;
        
        for(genesis__Application_Parties__c parties:App.genesis__Application_Parties__r){
            System.debug('parties.NMI_Approved__c:::'+parties.NMI_Approved__c);
            //  For Co-applicant and Gurantor EMI
            NMI=parties.NMI_Approved__c;
            NMIITR1=parties.Approved_NMI_From_ITR__c;
            AddIncome1 = parties.Agriculture2__c != null ? parties.Agriculture2__c : 0;
            System.debug('AddIncome1'+AddIncome1);
            Decimal ExistingEMI =0;
            Decimal NmiClaimed = 0.0; 
            Decimal EMICal =0.0;
            if( (parties.genesis__Party_Type__c==Constants.Co_Borrower || parties.genesis__Party_Type__c==Constants.PRIMARY_APP) && parties.Financial_Applicant__c){
                
                if(parties.Employment_Types__c == Constants.EMPTYP_AGRICULTUR){
                    AddIncome1 = 0;
                    if(NMIITR1 < Decimal.ValueOf(Label.VL_NMI_SLAB)){
                        NmiClaimed = NMI !=null? NMI*0.60 : 0;
                    }else{
                        NmiClaimed = NMI !=null? NMI*0.75 : 0;
                    }
                }
                else if(parties.Employment_Types__c != Constants.EMPTYP_AGRICULTUR){
                    System.debug('**employment type -non aggriculturist');
                    if(NMIITR1 < Decimal.ValueOf(Label.VL_NMI_SLAB)){
                        NmiClaimed = ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome1)*0.60;
                    }else{
                        NmiClaimed = ApplicationEligibiltyHandler.NMICalcu(NMIITR1,AddIncome1)*0.75;
                    }  
                }       
                
                ExistingEMI = parties.Existing_Emis__c != null ? parties.Existing_Emis__c : 0 ;
            }

            System.debug('*NmiClaimed'+NmiClaimed);
            if(NmiClaimed>ExistingEMI){
                EMICal = NmiClaimed - ExistingEMI;    
            }else{
                EMICal = 0;
            } 
            EMIMax+=EMICal;
        }
        System.debug('EMIMax >>> ' + EMIMax);
        return EMIMax;
    }    
    //vehicle recalculate Pmax1
    
    public static void applicationReCalVL(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        try{
            System.debug('**inside applicationReCalVL');
            Decimal VehicleCost = 0.00;
            Decimal ExShowVehicleCost = 0.00;
            Decimal MasterVehicleCost = 0.00;
            Decimal TotalVehicleCost = 0.00;
            Decimal RegistrationCost = 0.00;
            Decimal AccessoriesCost = 0.00;
            Decimal TotalAccessoriesCost = 0.00;
            Decimal InsuranceCost = 0.00;
            String colid;
            Decimal Pmax1 = 0.00;  
            List<clcommon__Collateral__c> collist=new List<clcommon__Collateral__c>();
            List<genesis__Applications__c> updtapps = new List<genesis__Applications__c>();
            
            for(genesis__Applications__c application : appList){
                
            //end si details captured
                if((oldList.get(application.Id).sub_stage__c <> application.Sub_Stage__c && application.Sub_Stage__c =='Work Information Captured') && (application.Record_Type_Name__c ==Constants.VL2W || application.Record_Type_Name__c ==Constants.VL4W) ){          
                    // List<genesis__Applications__c> updtapps = new List<genesis__Applications__c>();
                    
                    if(application.Acknowledgement__c){
                        genesis__Applications__c app = new genesis__Applications__c();
                        app.id = application.id;
                        app.Is_ITR_required__c=false;
                        updtapps.add(app);
                    }
                    
                }
                //end work
                if((oldList.get(application.Id).sub_stage__c <> application.Sub_Stage__c && application.Sub_Stage__c =='Terms and Conditions Accepted') && (application.Record_Type_Name__c ==Constants.VL2W || application.Record_Type_Name__c ==Constants.VL4W) ){          
                    System.debug('&&&&&Terms and Conditions Accepted');
                    
                    genesis__Applications__c App=appdetails(application.id);
                    integer l=0;
                    integer a=0;
                    for(genesis__Application_Parties__c par: App.genesis__Application_Parties__r){
                        if(par.Financial_Applicant__c){
                            l++;
                        }                           
                        if(par.Perfios_Captured__c==true && par.IsKYC__c==true && par.Same_Present_Address_Permanent_Address__c==true && par.Total_Additional_Income__c ==0 && !App.Sanction_Class2_Check__c){
                            a++;
                        }
                    }
                    if(l==a){
                        genesis__Applications__c app1 = new genesis__Applications__c();
                        app1.id = application.id;
                        app1.Sub_Stage__c='Loan Sanctioned STP';
                        app1.Sanctioned_Tenure__c = application.genesis__Term__c;
                        app1.Sanction_Authority_Limit__c = Retry_Task_call.conversion(application.genesis__Loan_Amount__c);
                        app1.Disbursement_Amount__c = Retry_Task_call.conversion(application.genesis__Loan_Amount__c);
                        app1.Sanctioned_EMI__c   =application.genesis__Payment_Amount__c;
                        updtapps.add(app1);  
                    }
                    System.debug('**lllll'+updtapps);
                }
                
            }//end for loop
            ApplicationTriggerHandler.IsFirstRun = false;
            update updtapps; 
        }Catch(Exception e){
            system.debug('Class name'+e.getStackTraceString()+'Line number'+e.getLineNumber());
            system.debug('** message'+e.getMessage());
            HandleBusinessException.captureError('Retry_Task_call_VL', 'applicationReCalVL', e);
        }
    }
    
    
    public static void FindPerfiosPrimaryBank(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        try{
            Set<id> appidset=new Set<id>();
            Map<id,Perfios__c> perMap=new Map<id,Perfios__c>();
            Map<id,Perfios__c> perMapSalaried=new Map<id,Perfios__c>();
            Decimal avgbalance=0.0; 
            String primary_bank;
            List<genesis__Application_Parties__c> partylist=new List<genesis__Application_Parties__c>();
            List<genesis__Applications__c> appLstToUpdate = new List<genesis__Applications__c>();
            for(genesis__Applications__c application : appList){
                if(oldList.get(application.Id).sub_stage__c <> application.Sub_Stage__c && application.Sub_Stage__c =='Terms and Conditions Accepted' ){   
                    System.debug('*inside terms and con');
                    genesis__Applications__c App=appdetails(application.id);
                    
                    for(Perfios__c pp:App.Perfios__r){
                        //System.debug('**perfios'+pp);
                        perMapSalaried.put(pp.Applicant_Name__c,pp);
                        
                        if(perMap.get(pp.Applicant_Name__c)!=null && pp.SelfEmpNMI__c > perMap.get(pp.Applicant_Name__c).SelfEmpNMI__c){
                            perMap.put(pp.Applicant_Name__c,pp);
                        }else if(perMap.get(pp.Applicant_Name__c)==null){ 
                            perMap.put(pp.Applicant_Name__c,pp); 
                        }
                    }
                    
                    for(genesis__Application_Parties__c par: App.genesis__Application_Parties__r){
                        
                        genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
                        if(par.Salary_Continous_Flag__c==true && par.Employment_Types__c=='Salaried'){
                            if(perMapSalaried.containsKey(par.genesis__Party_Account_Name__c)){
                                parobj.id=par.id;
                                
                                parobj.Primary_Bank__c=Utility.getBlankStringIfNull(perMapSalaried.get(par.genesis__Party_Account_Name__c).Bank_Name__c);
                                parobj.Bank_Account_Number__c=Utility.getBlankStringIfNull(perMapSalaried.get(par.genesis__Party_Account_Name__c).Bank_Account_Number__c);
                                partylist.add(parobj);
                                
                            }
                        }
                        if(par.Salary_Continous_Flag__c==false && par.Employment_Types__c!='Salaried'){
                            if(perMap.containsKey(par.genesis__Party_Account_Name__c)){
                                parobj.id=par.id;
                                
                                parobj.Primary_Bank__c=Utility.getBlankStringIfNull(perMap.get(par.genesis__Party_Account_Name__c).Bank_Name__c);
                                parobj.Bank_Account_Number__c=Utility.getBlankStringIfNull(perMap.get(par.genesis__Party_Account_Name__c).Bank_Account_Number__c);
                                partylist.add(parobj);
                                
                            }
                        }
                        //end for
                    }
                    System.debug('**partylist'+partylist);

                    //braj-start
                    if (Label.VL_Waiver_Percent!=null && application.Perfios_Captured__c && (application.Record_Type_Name__c == Constants.VL4W || application.Record_Type_Name__c == Constants.VL2W)){
                        genesis__Applications__c appln = new genesis__Applications__c();
                        appln.Book_Debts_Age__c = Decimal.valueOf(Label.VL_Waiver_Percent);
                        appln.id = application.id;
                        appLstToUpdate.add(appln);
                    }
                    System.debug('appLstToUpdate**'+appLstToUpdate);
                    //braj-end
                }

            }//end of for loop
            
            update partylist;

            //braj-start
            ApplicationTriggerHandler.IsFirstRun = false;
            update appLstToUpdate; 
            //braj-end
        }Catch(Exception e){
            system.debug('Class name'+e.getStackTraceString()+'Line number'+e.getLineNumber());
            system.debug('** message'+e.getMessage());
            HandleBusinessException.captureError('Retry_Task_call_VL', 'FindPerfiosPrimaryBank', e);
        }
        
    }
    
    
    Public static genesis__Applications__c appdetails(String appid){
        
        genesis__Applications__c newApplist=[select id,Sanction_Class2_Check__c,PMax__c,Max_CIBIL_Score__c,BankYear__c,Employment_Type__c,Additional_Income__c,FI_Status__c,ITR_Uploaded__c,Acknowledgement__c,Sanctioned_Tenure__c,genesis__Interest_Rate__c,   Pmax2__c,PL_Score__c,CIBIL_score__c, genesis__CL_Product__r.Min_Amount__c, genesis__CL_Product__r.LMax_PL__c, genesis__CL_Product__r.Max_Amount__c,Branch_Code__c,Record_Type_Name__c,Property_City__c,PrimaryApplicant_CIBIL_Score__c,Age_Of_The_Building__c,genesis__Loan_Amount__c,Total_Market_value__c,
                                             Holiday_Max__c,genesis__Account__r.Max_Existing_EMI__c,genesis__Account__r.Net_Monthly_Income__c,genesis__Account__r.NMI_Claimed_By_Customer__c,genesis__Account__r.Employment_Type__c,Is_Take_Over__c,Loan_Purpose__c,Cost_Of_Construction__c,Cost_Of_Land__c,PMax1__c,Cost_Of_Repair__c,
                                             (select id,IsKYC__c,Salary_Continous_Flag__c,Perfios_Captured__c,Same_Present_Address_Permanent_Address__c,Total_Additional_Income__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                              CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                              NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                              Financial_Applicant__c,genesis__Party_Account_Name__r.age__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false), (select id,ExshowRoomPrice_Api__c,Scheme_Type__c,Vehicle_CalculatedValue__c,Final_vehicle_value__c,Collateral_Market_Value__c,clcommon__City__c,clcommon__Insurance_Amount__c,
                                                                                                                                                                                               Dealer_name__c,clcommon__Model__c,clcommon__Make__c,clcommon__Manufacturer__c,Accessories_value__c,ExShow_Room_Price__c,Variant__c,Registration_cost__c,Total_Vehicle_Value__c From genesis__Collaterals__r),(Select id,Applicant_Name__c,SelfEmpNMI__c,Bank_Account_Number__c,AvgBalance_Of_6_Months__c,Bank_Name__c from Perfios__r)
                                             From genesis__Applications__c where id=:appid];
        return newApplist;
    }
}