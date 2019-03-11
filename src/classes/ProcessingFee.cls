/*
* Name    : ProcessingFee
* Company : ET Marlabs
* Purpose : This class will be used for Processing fee calculation
* Author  : Venu
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
V1.1    22-Aug-2018    Braj          addition and modification in Vehicle loan calculation
V1.2    30-Aug-2018    Braj          Changes in stamp duty calculation for vehicle loan
v1.3    03-Sep-2018    Braj          Replace state name with state code
V1.4    11-Sep-2018    Braj          #VL741:Re-Modification in processing fee calculation for VL
V1.5    22-Oct-2018    Braj          HL Sanction Letter(C1) Non Legal Desk Document Generation
v1.6    23-Nov-2018    Braj          Changes in stamp and cersai charges of Processing fee for HL and LAP
v1.7    18-Jan-2019    Braj          Added Facilities query and changes in Processing fee & Valuation Charge for HL MVP2
*******************************************************************************************/
public with sharing class ProcessingFee{
    public static Boolean IsFirstRun = true;
    public static Boolean IsDocumentRun=true;
    
    public static void CallCalculatefee(List<genesis__Applications__c> Applist,Map<Id,genesis__Applications__c> oldApp,List<genesis__Applications__c> oldList,Map<Id,genesis__Applications__c> newApp){
       
       
        set<id> appId= new set<id>();
        set<id> accid=new set<id>();
        Set<String> applicationIds  = new Set<String>();
        
        for(genesis__Applications__c app : Applist){
           
            //V1.4-start
            if(((oldApp.get(app.id).Loan_Purpose__c!=app.Loan_Purpose__c) || (oldApp.get(app.id).genesis__Loan_Amount__c!=app.genesis__Loan_Amount__c) || (oldApp.get(app.id).Sub_Stage__c!=app.Sub_Stage__c  && app.Sub_Stage__c ==Constants.PersonalDetailsCapt)) && ((app.Record_Type_Name__c!=Constants.VL2W && app.Record_Type_Name__c!=Constants.VL4W) || app.Record_Type_Name__c!=Constants.PERSONALLOAN)) {
                system.debug('######'+app.id);
                appId.add(app.id);
                if(app.genesis__Account__c!=null){
                    accid.add(app.genesis__Account__c);
                }                
            } else if ((oldApp.get(app.id).Sub_Stage__c!=app.Sub_Stage__c  && app.Sub_Stage__c ==Constants.SI_DETAILS_CAPTURED_SUBSTAGE1) && (app.Record_Type_Name__c==Constants.VL2W || app.Record_Type_Name__c==Constants.VL4W || app.Record_Type_Name__c==Constants.PERSONALLOAN)) {
                System.debug('get app id for calculateFeeList'+app.id);
                appId.add(app.id);
                if(app.genesis__Account__c!=null){
                    accid.add(app.genesis__Account__c);
                } 
                
            } 
            //V1.4-end            
        }
        if((appId.size()>0 || accid.size()>0)  && ProcessingFee.IsFirstRun){
            
            calculateFeeList(appId,accid);
        }
    }
    
    public static void calculateFeeList(set<id> Appid,set<id> accid){
        try{
            IsFirstRun = false;
            system.debug('accid'+accid);
            list<genesis__Applications__c> updateApplist = new list<genesis__Applications__c>();
            list<genesis__Applications__c> ListApp=[select id,(select id,genesis__Application__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false) from genesis__Applications__c where ID IN:AppID];

            //System.debug('ListApp'+ListApp);

            map<id,integer> accCount=new map<id,integer>();
            for(genesis__Applications__c App:ListApp){
                 accCount.put(App.id, 0);
                for(genesis__Application_Parties__c Party:App.genesis__Application_Parties__r){
                      if(accCount.containsKey(party.genesis__Application__c)){
                        integer pCount  = accCount.get(party.genesis__Application__c) + 1;
                        accCount.put(party.genesis__Application__c,pCount);
                    }else{
                        accCount.put(party.genesis__Application__c,1);
                    }
                }
            }
            System.debug('accCount'+accCount); 

            list<genesis__Applications__c> Applist =[select id,Sub_Type__c,genesis__Disbursement_Date__c,Book_Debts_Age__c,Branch_State__c,Branch_Code__c,Penal_Interest__c,Preclosure_Charges__c,Processing_Charges__c,Record_Type_Name__c,genesis__Account__c,genesis__Loan_Amount__c,Loan_Purpose__c,genesis__Account__r.Count_Parties__c,Sanction_Authority_Limit__c,Perfios_Captured__c,(select id,genesis__Party_Type__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false),(select id,Name,Scheme_Type__c,ExShow_Room_Price__c,Vehicle_CalculatedValue__c,Double_Valuation_Charge__c,Valuation_Applicable__c,Claimed_Additional_Charge__c,Approved_Additional_Charge__c from genesis__Collaterals__r where active__c=true),(select id,Name,Existing_HL_Oustanding_Balance__c,Existing_HL_Sanctioned_Amount__c from Facilities__r where Selected_for_Top_Up__c = true) from genesis__Applications__c where id in:accCount.keyset()];//V1.1:added inner query for collateral//v1.4//v1.6:party query added //v1.7
            System.debug('Applist'+Applist);
            
            for(genesis__Applications__c ap:Applist){
                integer partylist=0;
                Decimal LoanAmount;
                Decimal LAtwe_five;
                Decimal SanctAmt;
                String state = Utility.getStateFromBranchCode(ap.Branch_Code__c);//v1.3
                if(ap.genesis__Loan_Amount__c!=null){
                    LoanAmount=ap.genesis__Loan_Amount__c;
                    LAtwe_five=LoanAmount * Decimal.valueOf(System.Label.Legal_Valu_percent);//0.0025
                }
                if(ap.Sanction_Authority_Limit__c !=null){
                    SanctAmt=ap.Sanction_Authority_Limit__c;
                }
                
                // Cibil charges
                if(ap.genesis__Account__c!=null){
                    partylist =accCount.get(ap.id);//+1 remove because it counting one extra party for cibil charge calculation
                }
                else{
                    partylist= 1;  
                }
                ap.Cibil_Charges__c= partylist *100;
                
                //Processing charges
                //v1.6(start)
                if (ap.Record_Type_Name__c ==Constants.HOMELOAN) {

                    if(ap.Sub_Type__c == Constants.Sub_Type_Top_Up){//v1.7
                        ap.Processing_Charges__c = LoanAmount * Constants.ProcessingFee_HL_TopUp > 15000 ? 15000 : LoanAmount * Constants.ProcessingFee_HL_TopUp < 2000 ? 2000 : LoanAmount * Constants.ProcessingFee_HL_TopUp;//0.005//v1.7
                    } else {
                        if(LoanAmount >= Decimal.valueOf(System.Label.Minimum_amount_zero) && LoanAmount <= Decimal.valueOf(System.Label.Loan_Amount25L)){
                            ap.Processing_Charges__c=Decimal.valueOf(System.Label.Proces_fee25);//2500
                        }
                        else if(LoanAmount > Decimal.valueOf(System.Label.Loan_Amount25L) && LoanAmount <= Decimal.valueOf(System.Label.Loan_Amount_50L)){
                            ap.Processing_Charges__c= Decimal.valueOf(System.Label.Proces_fee50);//5000
                        }
                        else if(LoanAmount > Decimal.valueOf(System.Label.Loan_Amount_50L)){
                            ap.Processing_Charges__c= Decimal.valueOf(System.Label.Proces_fee75);//7500
                        }
                    }                    
                    
                    if (!ap.Charges_Processed__c){
                        List<string> docNameLst = new List<string>{'','','','','',''};
                        List<Decimal> stampChargeLst = new List<Decimal>{0,0,0,0,0,0};
                        Decimal totalStampChg = 0.00;

                        string BranchState=[select id,CODCCBRN__c,State__c from Branch_Master__c where CODCCBRN__c=:ap.Branch_Code__c limit 1].state__c;
                        BranchState =BranchState!= null ? BranchState.toUpperCase() : '';
                        if(!Utility.ISStringBlankorNull(BranchState)){
                            docNameLst[0] = Constants.A23_HL; //Always

                            for(genesis__Application_Parties__c party: ap.genesis__Application_Parties__r) {
                                if(party.genesis__Party_Type__c==Constants.Gurantor){
                                    docNameLst[1] = Constants.A46_HL; //Guarantor
                                }
                            }

                            docNameLst[2] = Constants.B1_HL; //Mod
                            
                            if(ap.Loan_Purpose__c !='Construction on Own Land' && ap.Loan_Purpose__c !='Repair or Renovation of House'){
                                docNameLst[3] = Constants.B17_HL; //based on loan purpose
                            }
                            
                            List<Stamping_Charges__mdt> stampChargeAmt =[Select ID,MasterLabel,Declaration_Of_Title_Mortgage__c,Declaration_of_Original_Mortgage__c,Create_Mortgage_Charges__c,Housing_Loan_Agreement__c,Agreement_of_Guarantee__c,HL_TopUp_A66__c,HL_TakeOver_A54__c From Stamping_Charges__mdt Where MasterLabel =:BranchState Limit 1];
                            System.debug('***Stmp_Charg***'+stampChargeAmt);

                            //v1.7(start)
                            if (ap.Sub_Type__c == Constants.Sub_Type_Top_Up) {
                                docNameLst[4] = Constants.HL_Topup_A66;
                            }
                            if (ap.Sub_Type__c == Constants.Sub_Type_Take_Over) {
                                docNameLst[5] = Constants.HL_Takeover_A54;
                            }
                            //v1.7(end)

                            if(stampChargeAmt.size()>0){
                                if(docNameLst[0] == Constants.A23_HL && ap.Sub_Type__c != Constants.Sub_Type_Top_Up){//v1.7
                                    stampChargeLst[0] = stampChargeAmt[0].Housing_Loan_Agreement__c;
                                }
                                if(docNameLst[1] == Constants.A46_HL){
                                    stampChargeLst[1] = stampChargeAmt[0].Agreement_of_Guarantee__c;
                                }
                                if(docNameLst[2] == Constants.B1_HL && ap.Sub_Type__c != Constants.Sub_Type_Top_Up){//v1.7
                                    stampChargeLst[2] = stampChargeAmt[0].Declaration_Of_Title_Mortgage__c;
                                }
                                if(docNameLst[3] == Constants.B17_HL){
                                    stampChargeLst[3] = stampChargeAmt[0].Create_Mortgage_Charges__c;
                                }
                                //v1.7(start)
                                if(docNameLst[4] == Constants.HL_Topup_A66){
                                    stampChargeLst[4] = stampChargeAmt[0].HL_TopUp_A66__c;
                                }
                                if(docNameLst[5] == Constants.HL_Takeover_A54){
                                    stampChargeLst[5] = stampChargeAmt[0].HL_TakeOver_A54__c;
                                }
                                //v1.7(end)
                            }
                            totalStampChg = stampChargeLst[0] + stampChargeLst[1] + stampChargeLst[2] + stampChargeLst[3] + stampChargeLst[4] + stampChargeLst[5];
                            ap.Total_Stamp_Paper_Charge__c = totalStampChg != null ? totalStampChg : 0;
                        }
                    }
                }
                else if(ap.Record_Type_Name__c ==Constants.LAPLOAN){
                    ap.Processing_Charges__c= (Decimal.valueOf(System.Label.Processing_Fee_LAP)/100)*LoanAmount;//Processing_Fee_LAP=0.5
                    if (!ap.Charges_Processed__c){
                        String DocName1 = '';
                        String DocName2 = '';
                        String DocName3 = '';
                        Decimal stampCharge1 = 0.00;
                        Decimal stampCharge2 = 0.00;
                        Decimal stampCharge3 = 0.00;
                        Decimal totalStampChg = 0.00;
                        string BranchState=[select id,CODCCBRN__c,State__c from Branch_Master__c where CODCCBRN__c=:ap.Branch_Code__c limit 1].state__c;
                        BranchState =BranchState!= null ? BranchState.toUpperCase() : '';
                        if(!Utility.ISStringBlankorNull(BranchState)){
                            DocName1 = Constants.LAP_A23;//Always
                            for(genesis__Application_Parties__c party: ap.genesis__Application_Parties__r) {
                                if(party.genesis__Party_Type__c==Constants.Gurantor){
                                    DocName2 = Constants.LAP_A46; //Guarantor
                                }
                            }
                            if(ap.genesis__Collaterals__r.size()>0){
                                DocName3 = Constants.LAP_B1;//Mod
                            }
                            
                            List<Stamping_Charges__mdt> stampChargeAmt =[Select ID,MasterLabel,Declaration_Of_Title_Mortgage__c,Declaration_of_Original_Mortgage__c,
                                                                         Create_Mortgage_Charges__c,Housing_Loan_Agreement__c,Agreement_of_Guarantee__c 
                                                                         From Stamping_Charges__mdt Where MasterLabel =:BranchState Limit 1];
                            System.debug('***Stmp_Charg***'+stampChargeAmt);
                            if(stampChargeAmt.size()>0){
                                if(DocName1 == Constants.LAP_A23 ){
                                    stampCharge1 = stampChargeAmt[0].Housing_Loan_Agreement__c;
                                }
                                if(DocName2 == Constants.LAP_A46){
                                    stampCharge2 = stampChargeAmt[0].Agreement_of_Guarantee__c;
                                }
                                if(DocName3 == Constants.LAP_B1){
                                    stampCharge3 = stampChargeAmt[0].Declaration_Of_Title_Mortgage__c;
                                    stampCharge3= stampCharge3 * ap.genesis__Collaterals__r.size();
                                }
                            }
                            totalStampChg = stampCharge1 + stampCharge2 + stampCharge3;
                            ap.Total_Stamp_Paper_Charge__c = totalStampChg != null ? totalStampChg : 0;
                        }
                    }
                }
                //v1.6(end)

                //pl proccessing fees calculation   
                else if(ap.Record_Type_Name__c == Constants.PERSONALLOAN){
                    
                    LoanProcess_Config__mdt proFees = queryService.processingFee('PL');
                        System.debug('profees:::'+profees);
                    if(String.valueOf(proFees.Fee_Percentage__c) <> null)
                        ap.Processing_Charges__c = (proFees.Fee_Percentage__c/100)*SanctAmt;
                    if(String.valueOf(proFees.PreClosure_Charges__c) <> null)
                        ap.Preclosure_Charges__c = proFees.PreClosure_Charges__c;
                    if(String.valueOf(proFees.Penal_Interest__c) <> null)
                        ap.Penal_Interest__c = proFees.Penal_Interest__c;
                     if(!Utility.ISStringBlankorNull(state)){
                        String branchState = string.valueOf(state).toUpperCase();
                        Stamping_Charges__mdt stampchargePL=[select   MasterLabel,Personal_Loan_Agreement__c from   Stamping_Charges__mdt where   MasterLabel=:branchState Limit 1 ];
                        ap.Total_Stamp_Paper_Charge__c =stampchargePL.Personal_Loan_Agreement__c;
                    }    
                    ap.genesis__Disbursement_Date__c = System.today(); 
                }
                
                //V1.1-start //V1.4-start
                //Vehicle loan calculation
                else if (ap.Record_Type_Name__c == Constants.VL2W || ap.Record_Type_Name__c == Constants.VL4W){
                    String SelectedSchm;
                    List<Scheme_Master__c> SelectedScheme = new List<Scheme_Master__c>();
                    Decimal ProcessingCharges = 0.0;
                    for(clcommon__Collateral__c collateral:ap.genesis__Collaterals__r){
                        SelectedSchm = collateral.Scheme_Type__c != null ? collateral.Scheme_Type__c : '';
                        if(ap.Record_Type_Name__c == Constants.VL2W){
                            if(Decimal.valueof(collateral.Vehicle_CalculatedValue__c) <= Constants.VEHICLECOST2L){
                                ProcessingCharges = Math.max(ap.Sanction_Authority_Limit__c/100,Constants.VEHICLEPF2W1K)*(1-ap.Book_Debts_Age__c);
                            }else if(Decimal.valueof(collateral.Vehicle_CalculatedValue__c) > Constants.VEHICLECOST2L && ap.Sanction_Authority_Limit__c <= Constants.VEHICLECOST10L){
                                ProcessingCharges  = Constants.VEHICLEPF2W3K*(1-ap.Book_Debts_Age__c);
                            }else if (Decimal.valueof(collateral.Vehicle_CalculatedValue__c) > Constants.VEHICLECOST2L && ap.Sanction_Authority_Limit__c > Constants.VEHICLECOST10L) {
                                ProcessingCharges  = Constants.VEHICLEPF2W7500*(1-ap.Book_Debts_Age__c);
                            }
                        }else if (ap.Record_Type_Name__c == Constants.VL4W){
                            if(ap.Sanction_Authority_Limit__c<=Constants.VEHICLECOST10L){
                                ProcessingCharges  = Constants.VEHICLEPF2W3K*(1-ap.Book_Debts_Age__c);
                            }else if (ap.Sanction_Authority_Limit__c>Constants.VEHICLECOST10L){
                                ProcessingCharges  = Constants.VEHICLEPF2W7500*(1-ap.Book_Debts_Age__c);
                            }   
                        }
                    }// end of for loops

                    SelectedScheme =  [Select Id,Name,Scheme_Code__c,ProductType__c,Active_Flag__c,LTV_increase__c,Pricing_Discount__c,Processing_fee_discount__c from Scheme_Master__c Where Scheme_Code__c=:SelectedSchm limit 1];
                    if(SelectedScheme.size() > 0){
                        ap.Processing_Charges__c = ProcessingCharges*(1 - (SelectedScheme[0].Processing_fee_discount__c/100));
                    }else{
                        ap.Processing_Charges__c = ProcessingCharges;
                    }

                    //calculate stamp charges
                    decimal stampduty = 0;
                    ap.Valuation_Charges__c=0;
                    ap.Cersai_Charges__c=Decimal.valueOf(System.Label.Cersai_VL);
                    ap.Legal_Charges__c=0;
                    ap.genesis__Disbursement_Date__c = System.today();
                    //get stamp charges from custom metadata according to Indian State
                    if(!Utility.ISStringBlankorNull(state)){
                        System.debug('**branch'+state); 
                        String branchState = string.valueOf(state).toUpperCase();
                        Stamping_Charges__mdt stampchargePL=[select MasterLabel,Vehicle_Loan_Agreement__c,VL_Stamp_Duty__c from   Stamping_Charges__mdt where   MasterLabel=:branchState Limit 1 ];
                        System.debug('***stampchargePL'+stampchargePL);
                        //V1.2-START
                        if(stampchargePL.VL_Stamp_Duty__c!=null) {
                            stampduty = stampchargePL.VL_Stamp_Duty__c;
                        } else {
                            stampduty=dynamicCalStampDuty(ap.Sanction_Authority_Limit__c,branchState);
                        }
                        ap.Total_Stamp_Paper_Charge__c =stampchargePL.Vehicle_Loan_Agreement__c;// + stampduty ;
                        ap.Max_EMI__c = stampduty; // Changes made on 2018/10/16. - Discusses with Shreya.
                        //V1.2-END
                    }
                    if (ap.Perfios_Captured__c) {
                        ap.Reason_for_waiver__c = 'perfios by all';
                    } 
                }
                //V1.1-end //V1.4-end
                
                if(ap.Loan_Purpose__c!=Constants.Loanpurpose && ap.Record_Type_Name__c == Constants.HOMELOAN){//V1.1

                    //v1.7(start)
                    Decimal claimed_Additional_Charge = 0;
                    if (ap.Sub_Type__c == Constants.Sub_Type_Top_Up && ap.genesis__Collaterals__r.size() > 0 && ap.Facilities__r.size() > 0 ) {
                        clcommon__Collateral__c collateral = new clcommon__Collateral__c();
                        claimed_Additional_Charge = (ap.Facilities__r[0].Existing_HL_Oustanding_Balance__c != null ?ap.Facilities__r[0].Existing_HL_Oustanding_Balance__c : 0) + (LoanAmount != null ?LoanAmount :0) - (ap.Facilities__r[0].Existing_HL_Sanctioned_Amount__c !=null ?ap.Facilities__r[0].Existing_HL_Sanctioned_Amount__c : 0);
                        collateral.Claimed_Additional_Charge__c = claimed_Additional_Charge >= 0 ? claimed_Additional_Charge : 0;
                        collateral.Id = ap.genesis__Collaterals__r[0].Id;
                        update collateral;
                    }

                    // Cersai calculations
                    if((ap.Sub_Type__c == Constants.Sub_Type_Top_Up && claimed_Additional_Charge > 0) ||  ap.Sub_Type__c != Constants.Sub_Type_Top_Up){
                        if(LoanAmount >= Decimal.valueOf(System.Label.Minimum_amount_zero) && LoanAmount <= Decimal.valueOf(System.Label.Cersai_50000)){//System.Label.Cersai_50000=500000
                               ap.Cersai_Charges__c=Decimal.valueOf(System.Label.Cersai);//50
                        }
                        else if(LoanAmount > Decimal.valueOf(System.Label.Cersai_50000)){
                            ap.Cersai_Charges__c= Decimal.valueOf(System.Label.Cersai_above5lac);//100
                        }
                    }
                    
                    
                    
                    // Legal openion
                    if (ap.Sub_Type__c == Constants.Sub_Type_Top_Up) {
                        ap.Legal_Charges__c= 0;
                    } else {
                        if(LAtwe_five<=Decimal.valueOf(System.Label.Legal_min)){
                            ap.Legal_Charges__c= Decimal.valueOf(System.Label.Legal_min);//1000
                        }
                        else if(LAtwe_five > Decimal.valueOf(System.Label.Legal_min) && LAtwe_five < Decimal.valueOf(System.Label.Legal_fee_Max)){
                            ap.Legal_Charges__c=LAtwe_five;
                        }
                        else if(LAtwe_five >= Decimal.valueOf(System.Label.Legal_fee_Max)){
                            ap.Legal_Charges__c= Decimal.valueOf(System.Label.Legal_fee_Max);//2500
                        }
                    }
                    
                    // Valuation charges
                    if (ap.Sub_Type__c == Constants.Sub_Type_Top_Up && !ap.genesis__Collaterals__r[0].Valuation_Applicable__c){
                        ap.Valuation_Charges__c = 0;
                    } else {
                        if(LAtwe_five <= Decimal.valueOf(System.Label.Legal_min)){//1000
                            if (ap.genesis__Collaterals__r.size() > 0 && ap.genesis__Collaterals__r[0].Double_Valuation_Charge__c) {
                                ap.Valuation_Charges__c = Decimal.valueOf(System.Label.Legal_min) * 2;
                            } else {
                                ap.Valuation_Charges__c = Decimal.valueOf(System.Label.Legal_min);
                            }
                        }
                        else if(LAtwe_five > Decimal.valueOf(System.Label.Legal_min) && LAtwe_five < Decimal.valueOf(System.Label.Valution_Fee_Max)){
                            if (ap.genesis__Collaterals__r.size() > 0 && ap.genesis__Collaterals__r[0].Double_Valuation_Charge__c) {
                                ap.Valuation_Charges__c = LAtwe_five * 2;
                            } else {
                                ap.Valuation_Charges__c = LAtwe_five ;
                            }
                        }
                        else if(LAtwe_five >= Decimal.valueOf(System.Label.Valution_Fee_Max)){
                            if (ap.genesis__Collaterals__r.size() > 0 && ap.genesis__Collaterals__r[0].Double_Valuation_Charge__c) {
                                ap.Valuation_Charges__c = Decimal.valueOf(System.Label.Valution_Fee_Max) * 2;
                            } else {
                                ap.Valuation_Charges__c = Decimal.valueOf(System.Label.Valution_Fee_Max);//10000
                            }
                        }
                    }
                    //v1.7(end)
                }

                else if(ap.Record_Type_Name__c <> Constants.VL2W && ap.Record_Type_Name__c <> Constants.VL4W){//V1.1
                    ap.Valuation_Charges__c=0;
                    ap.Cersai_Charges__c=0;
                    ap.Legal_Charges__c=0;
                }
                
                //scaling final figure
                if (ap.Valuation_Charges__c==null) {
                    ap.Valuation_Charges__c = 0;
                }
                ap.Valuation_Charges__c=(ap.Valuation_Charges__c+(ap.Valuation_Charges__c*decimal.valueOf(system.label.Valuation_Markup))).setscale(2);//system.label.Valuation_Markup=0.09
                if (ap.Cersai_Charges__c==null) {
                    ap.Cersai_Charges__c = 0;
                }
                ap.Cersai_Charges__c=(ap.Cersai_Charges__c+(ap.Cersai_Charges__c*decimal.valueOf(system.Label.Cersai_Markup))).setscale(2);//system.Label.Cersai_Markup=0.09
                if (ap.Legal_Charges__c==null) {
                    ap.Legal_Charges__c = 0;
                }
                ap.Legal_Charges__c= (ap.Legal_Charges__c+(ap.Legal_Charges__c*decimal.valueOf(system.label.Legal_Markup))).setscale(2);//system.label.Legal_Markup=0.09
                if (ap.Processing_Charges__c==null) {
                    ap.Processing_Charges__c = 0;
                }
                ap.Processing_Charges__c= ap.Processing_Charges__c.setscale(2);
                if (ap.Cibil_Charges__c==null) {
                    ap.Cibil_Charges__c = 0;
                }
                ap.Cibil_Charges__c=ap.Cibil_Charges__c.setscale(2);
                System.debug('ap.Processing_Charges__c'+ap.Processing_Charges__c);

                if(ap.Record_Type_Name__c == Constants.LAPLOAN){
                    List<clcommon__Collateral__c> COLlist = queryService.getCollateral(ap.Id);
                    Decimal CollareralMarketVal = 0.00;
                    Integer colValE = 0;
                    for(clcommon__Collateral__c col : COLlist){
                        if(col.Collateral_Market_Value__c >= 20000000){
                            colValE = colValE + 2;
                        }else{
                            colValE = colValE + 1;
                        }
                    }                
                    if(COLlist.size() > 0){
                        Integer colCount = COLlist.size();
                        ap.Cersai_Charges__c = ap.Cersai_Charges__c * colCount;
                        ap.Legal_Charges__c = ap.Legal_Charges__c * colCount;   
                        System.debug('------'+colValE);
                        if(colValE > 0){
                            ap.Valuation_Charges__c = ap.Valuation_Charges__c * colValE;
                        }
                    }
                }
                updateApplist.add(ap);
                
            }
            update updateApplist;

        }catch(exception e){
            HandleBusinessException.captureError('ProcessingFee','calculateFeeList', e);
        }
    }
    
    // FOr updating the property details
    
    
    public static Void callPropertyDetails(list<genesis__Applications__c> Applist,Map<Id,genesis__Applications__c> oldApp){
        set<string> flatNo= new set<string> ();
        Map<Id,string> FlatID=new Map<Id,string>();
        
        Map<Id, genesis__Applications__c> rejectedStatements    = new Map<Id, genesis__Applications__c>{};
            for(genesis__Applications__c plan: Applist)
        {
            genesis__Applications__c oldPlan = oldApp.get(plan.Id);
            if(plan != null && oldPlan != null){
                if(plan.Flat_No__c!=oldPlan.Flat_No__c){
                    flatNo.add(Plan.Flat_No__c);
                    FlatID.put(plan.Id, Plan.Flat_No__c);
                }

                // for SME
                if (oldPlan.Pre_Renewal_Checklist__c != 'Rejected'
                        && plan.Pre_Renewal_Checklist__c == 'Rejected'){
                    rejectedStatements.put(plan.Id, plan);
                }
                //Calculating GMRA
                //GmraCal.calGMRA(plan,oldPlan);

                // Document Generation // Add Personal loan type to not generate doc in PL
                System.debug('plan.Sub_Stage__c'+plan.Sub_Stage__c);
                System.debug('oldPlan.Sub_Stage__c'+oldPlan.Sub_Stage__c);
                System.debug('plan.Record_Type_Name__c '+plan.Record_Type_Name__c );

                if(plan.Sub_Stage__c!=oldPlan.Sub_Stage__c && (plan.Record_Type_Name__c ==Constants.HOMELOAN || plan.Record_Type_Name__c ==Constants.LAPLOAN)) {

                    if((plan.Record_Type_Name__c==Constants.HOMELOAN)  && (plan.Sub_Stage__c=='Loan Pre - Approved STP' || plan.Sub_Stage__c=='Loan Pre - Approved NSTP')){ // it should be work for both the stages

                        HL_Digio_Service.docGenAndSignDoc(plan.id, Constants.PRE_Approval_Sanction_HL);
                        IsDocumentRun=false;
                    }
                    if(plan.Sub_Stage__c=='Loan Sanctioned Non-STP' || plan.Sub_Stage__c=='Loan Sanctioned STP'||  plan.Sub_Stage__c=='Loan Sanctioned-Committee'){

                        if(plan.Record_Type_Name__c==Constants.HOMELOAN){
                            HL_Digio_Service.docGenAndSignDoc(plan.id, Constants.Acknowledgement_For_Sanction);
                            //HL_NonLD_Digio_Service.docGenAndSignDoc(plan.id, Constants.HL_DIGIO_MANUAL_C1C11);//V1.5////commented after discussion with Akshaya;reason:same doc generated from other class
                            IsDocumentRun=false;
                        }
                        else if(plan.Record_Type_Name__c==Constants.LAPLOAN){
                            HL_Digio_Service.docGenAndSignDoc(plan.id, Constants.Acknowledgement_For_SanctionLAP);
                            IsDocumentRun=false;
                        }
                    }

                    /* if(plan.Sub_Stage__c=='Disbursement Approved'){
                         system.debug('%%%%%'+plan.id+'####'+Constants.Execution_Certificate_C11_HL);
                         HL_Digio_Service.docGenAndSignDoc(plan.id, Constants.Execution_Certificate_C11_HL);
                     }

                    */
                }
            }

        }
        
        
        if(flatNo.size()>0){
            PropertyDetails(Trigger.new, flatNo);
        }
        
        // for SME
        if (!rejectedStatements.isEmpty())  
        {
            RejectedCheck(rejectedStatements);
        }
        
    }
    public static void PropertyDetails(list<genesis__Applications__c> Applist,set<string> FlatID){
        // List<ID> =New List<ID>();
        try{
            map<string,Flat_Master__c> ProjectMap=new map<string,Flat_Master__c>();
            List<Flat_Master__c> FLatList=[select id,Survey_number__c,Flat_No_House_No__c,ProjectCode__r.City_Town_Village__c,
                                           ProjectCode__r.Address_Line_1__c,ProjectCode__r.Address_Line_2__c,ProjectCode__r.Address_Line_3__c,
                                           ProjectCode__r.State__c,ProjectCode__r.Pin_Code__c,UDS__c,Floor_No__c,
                                           Recommended_Rate_Of_Flat_House_Rs_Sq__c,Built_Up_Area_Sq_Feet__c,Date_Of_Valuation_Update__c,
                                           Market_Value_Of_Property_Rs__c,ProjectCode__r.Boundary_East__c,ProjectCode__r.Boundary_North__c,
                                           ProjectCode__r.Boundary_South__c, ProjectCode__r.Project_Name__c,ProjectCode__r.Boundary_West__c,ProjectCode__r.Location_Of_The_Proeprty__c,
                                           ProjectCode__r.Extent_Area_Sq_Feet__c,ProjectCode__r.District__c,Tower_Construction_Start_Date__c,Construction_End_Date__c,Stage_Of_Construction__c,
                                           Valuers_Name__c,Market_Value_Of_the_Building__c,Market_Value_Of_The_Land__c,MAST_Of_Property__c,Presence_of_Amenities__c,
                                           Quality_Of_Construction_Condition__c,Estimated_ValueonForcedSale__c
                                           from Flat_Master__c where Flat_No_House_No__c IN:FlatID];
            for(Flat_Master__c FM:FLatList){
                ProjectMap.put(FM.Flat_No_House_No__c, FM);
            }
            for(genesis__Applications__c App:Applist){
                if(ProjectMap.containsKey(App.Flat_No__c)){
                    App.Survey_No_Katha_No_Other_No_s__c=ProjectMap.get(App.Flat_No__c).Survey_number__c;
                    App.Estimated_Value_on_Forced_Sale__c=ProjectMap.get(App.Flat_No__c).Estimated_ValueonForcedSale__c;
                    App.Property_Address__c =ProjectMap.get(App.Flat_No__c).ProjectCode__r.Address_Line_1__c+','+ProjectMap.get(App.Flat_No__c).ProjectCode__r.Address_Line_2__c+','+ProjectMap.get(App.Flat_No__c).ProjectCode__r.Address_Line_3__c;
                    App.Property_City__c    =ProjectMap.get(App.Flat_No__c).ProjectCode__r.City_Town_Village__c;
                    App.Property_State__c=ProjectMap.get(App.Flat_No__c).ProjectCode__r.State__c;
                   App.Location_Of_The_Property__c=ProjectMap.get(App.Flat_No__c).ProjectCode__r.Location_Of_The_Proeprty__c;
                    App.Property_Pincode__c=ProjectMap.get(App.Flat_No__c).ProjectCode__r.Pin_Code__c;
                    App.Boundaries_East__c  =ProjectMap.get(App.Flat_No__c).ProjectCode__r.Boundary_East__c;
                    App.Boundaries_North__c=ProjectMap.get(App.Flat_No__c).ProjectCode__r.Boundary_North__c;
                    App.Boundaries_South__c=ProjectMap.get(App.Flat_No__c).ProjectCode__r.Boundary_South__c;
                    App.Boundaries_West__c=ProjectMap.get(App.Flat_No__c).ProjectCode__r.Boundary_West__c;
                    //App.Area_of_the_Land__c=ProjectMap.get(App.Flat_No__c).ProjectCode__r.Extent_Area_Sq_Feet__c;
                    //App.UDS_Sq_Ft__c=ProjectMap.get(App.Flat_No__c).UDS__c;
                    App.Name_Of_The_Socity__c=ProjectMap.get(App.Flat_No__c).ProjectCode__r.Project_Name__c;
                    App.Property_District__c=  ProjectMap.get(App.Flat_No__c).ProjectCode__r.District__c;
                    //if()
                    App.Floor_No__c=ProjectMap.get(App.Flat_No__c).Floor_No__c;
                    //App.Existing_Built_up_Area__c=ProjectMap.get(App.Flat_No__c).Built_Up_Area_Sq_Feet__c;
                   // App.Date_Of_Commencement__c=ProjectMap.get(App.Flat_No__c).Tower_Construction_Start_Date__c;
                    App.Date_Of_Completion__c=ProjectMap.get(App.Flat_No__c).Construction_End_Date__c;
                    App.Percentage_of_Work_Completed__c=ProjectMap.get(App.Flat_No__c).Stage_Of_Construction__c;
                    App.Valuers_Name__c=ProjectMap.get(App.Flat_No__c).Valuers_Name__c;
                    App.Market_Value_Of_The_Land__c=ProjectMap.get(App.Flat_No__c).Market_Value_Of_The_Land__c;
                    App.Market_Value_Of_The_Building__c=ProjectMap.get(App.Flat_No__c).Market_Value_Of_the_Building__c;
                    App.MAST_Of_Property__c=ProjectMap.get(App.Flat_No__c).MAST_Of_Property__c;
                    App.Presence_of_Amenities__c=ProjectMap.get(App.Flat_No__c).Presence_of_Amenities__c;
                    App.Quality_Of_Construction_Condition__c=ProjectMap.get(App.Flat_No__c).Quality_Of_Construction_Condition__c;
                    
                    
                    
                }
            }
        }
        catch(exception e){
            
            system.debug('Updating the Proeprty Details Failed'+e.getMessage()+' Stack '+e.getStackTraceString());
        }
        
    }
    
    
    
    // SME for Rejeted check by Amritesh
    public static void RejectedCheck(Map<Id, genesis__Applications__c> rejectStatements){
        
        
        //Get the most recent approval process instance for the object.
        // If there are some approvals to be reviewed for approval, then
        // get the most recent process instance for each object.
        List<Id> processInstanceIds = new List<Id>{};
            
            for (genesis__Applications__c plans : [SELECT (SELECT ID
                                                           FROM ProcessInstances
                                                           ORDER BY CreatedDate DESC
                                                           LIMIT 1)
                                                   FROM genesis__Applications__c
                                                   WHERE ID IN :rejectStatements.keySet()])
        {
            processInstanceIds.add(plans.ProcessInstances[0].Id);
        }
        
        // Now that we have the most recent process instances, we can check
        // the most recent process steps for comments.  
        for (ProcessInstance pi : [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments 
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 )
                                   FROM ProcessInstance
                                   WHERE Id IN :processInstanceIds
                                   ORDER BY CreatedDate DESC])   
        {                   
            if ((pi.Steps[0].Comments == null || 
                 pi.Steps[0].Comments.trim().length() == 0))
            {
                rejectStatements.get(pi.TargetObjectId).addError(
                    'Operation Cancelled: Please provide a rejection reason!');
            }
        }  
    }
    
    //v1.2-START
    //method to calculate stamp duty for state which has dynamic stamp duty
    public static Decimal dynamicCalStampDuty(Decimal loanAmount,String state){
        Decimal finalLoanAmt = 0;
        if(loanAmount!=null && state!=null) {
            if(state=='Andhra Pradesh') {
                finalLoanAmt = math.min((loanAmount*Constants.STAMPDUTYPERCENT_PT5)/100,Constants.STAMPDUTY2LAKHS);
            }
            if(state=='Gujarat') {
                if(loanAmount<=Constants.LOANAMOUNT10CRORES) {
                    finalLoanAmt = math.min((loanAmount*Constants.STAMPDUTYPERCENT_PT25)/100,Constants.STAMPDUTY3LAKHS);
                } else {
                    finalLoanAmt = math.min((loanAmount*Constants.STAMPDUTYPERCENT_PT5)/100,Constants.STAMPDUTY8LAKHS);
                } 
            }
            if(state=='Karnataka') {
                if(loanAmount<=Constants.LOANAMOUNT10LAKHS) {
                    finalLoanAmt = (loanAmount*Constants.STAMPDUTYPERCENT_PT1)/100;
                } else {
                    finalLoanAmt = (loanAmount*Constants.STAMPDUTYPERCENT_PT2)/100; 
                } 
            }
            if(state=='Maharashtra') {
                if(loanAmount<=Constants.LOANAMOUNT5LAKHS) {
                    finalLoanAmt = (loanAmount*Constants.STAMPDUTYPERCENT_PT1)/100;
                } else {
                    finalLoanAmt = (loanAmount*Constants.STAMPDUTYPERCENT_PT2)/100;
                } 
            }
            if(state=='Telangana') {
                finalLoanAmt = math.min((loanAmount*Constants.STAMPDUTYPERCENT_PT5)/100,Constants.STAMPDUTY2LAKHS);
            }
        }
        return finalLoanAmt;
    }
    //v1.2-END
    
}