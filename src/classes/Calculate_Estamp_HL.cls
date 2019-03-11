/*
* Name    : Calculate_Estamp_HL
* Company : ET Marlabs
* Purpose : This class will calculate Stamp Charge 
* Author  : Subas
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
v1.1    23-Nov-18    Braj           Changes in Processing fee for HL and LAP
*******************************************************************************************/
public class Calculate_Estamp_HL {
    public static void calEstamp(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        try{
            String DocName1 = '';
            String DocName2 = '';
            String DocName3 = '';
            String DocName4 = '';
            String DocName5 = '';
            Decimal stampCharge1 = 0.00;
            Decimal stampCharge2 = 0.00;
            Decimal stampCharge3 = 0.00;
            Decimal stampCharge4 = 0.00;
            Decimal stampCharge5 = 0.00;
            Decimal totalStampChg = 0.00;
            
            for(genesis__Applications__c app : appList){ 
                if (app.Charges_Processed__c){//v1.1
                    if((app.Record_Type_Name__c==Constants.HOMELOAN &&(oldList.get(app.Id).Open_CASA_Account__c <> app.Open_CASA_Account__c || oldList.get(app.Id).Plan_Approval_available__c <> app.Plan_Approval_available__c  || oldList.get(app.Id).Verify_Sale_Agreement__c <> app.Verify_Sale_Agreement__c || oldList.get(app.Id).Verify_Construction__c <> app.Verify_Construction__c || oldList.get(app.Id).Verify_Advance_Payment__c <> app.Verify_Advance_Payment__c || oldList.get(app.Id).Execute_Tripartite_Agreement__c <> app.Execute_Tripartite_Agreement__c || oldList.get(app.Id).Verify_Latest_EC__c <> app.Verify_Latest_EC__c || oldList.get(app.Id).Verify_NOC__c <> app.Verify_NOC__c || oldList.get(app.Id).Verify_Margin_Payment__c <> app.Verify_Margin_Payment__c || oldList.get(app.Id).Complete_E_KYC_for_NTB_customers__c <> app.Complete_E_KYC_for_NTB_customers__c) && (app.Open_CASA_Account__c != 'No' && app.Verify_Sale_Agreement__c != 'No' && app.Verify_Construction__c != 'No' && app.Verify_Advance_Payment__c != 'No' && app.Execute_Tripartite_Agreement__c != 'No' && app.Plan_Approval_available__c!= 'No' && app.Verify_Latest_EC__c != 'No' && app.Verify_NOC__c != 'No' && app.Verify_Margin_Payment__c != 'No' && app.Complete_E_KYC_for_NTB_customers__c != 'No'))|| (app.Record_Type_Name__c==Constants.LAPLOAN && (oldList.get(app.Id).Open_CASA_Account__c <> app.Open_CASA_Account__c || oldList.get(app.Id).Plan_Approval_available__c <> app.Plan_Approval_available__c || oldList.get(app.Id).Complete_E_KYC_for_NTB_customers__c <> app.Complete_E_KYC_for_NTB_customers__c || oldList.get(app.Id).Verify_Latest_EC__c <> app.Verify_Latest_EC__c)&& (app.Complete_E_KYC_for_NTB_customers__c != 'No' && app.Open_CASA_Account__c != 'No' && app.Verify_Latest_EC__c != 'No' && app.Verify_Latest_EC__c != 'No' ))){                   
                        System.debug('*************'+app.Id);                
                        DocName1 = Constants.A23_HL; //Always
                        list<genesis__Applications__c> application = [select id, Name, Record_Type_Name__c,Sub_Stage__c,Loan_Purpose__c,(select id,genesis__Party_Type__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false AND genesis__Party_Type__c=:Constants.Gurantor),(select id,Active__c from genesis__Collaterals__r where active__c=true) from genesis__Applications__c where ID =: app.Id limit 1];
                        string BranchState=[select id,CODCCBRN__c,State__c from Branch_Master__c where CODCCBRN__c=:App.Branch_Code__c limit 1].state__c;
                        BranchState =BranchState!= null ? BranchState.toUpperCase() : '';
                        if(!Utility.ISStringBlankorNull(BranchState)){
                            if(application[0].genesis__Application_Parties__r.size()>0){
                                DocName2 = Constants.A46_HL; //Guarantor                    
                            }
                            if(app.Record_Type_Name__c==Constants.HOMELOAN){
                                if(app.Loan_Purpose__c !='Construction on Own Land' && app.Loan_Purpose__c !='Repair or Renovation of House'){
                                    DocName5 = Constants.B17_HL; //based on loan purpose
                                }
                                
                                DocName3 = Constants.B1_HL; //execute tripartite agreement
                                //DocName4 = Constants.B2_HL; //execute tripartite agreement
                            }
                            else if(app.Record_Type_Name__c==Constants.LAPLOAN){
                                if(application[0].genesis__Collaterals__r.size()>0){
                                    DocName3 = Constants.B1_HL;
                                }
                            }
                            //  String Property_State = app.Property_State__c != null ? app.Property_State__c.toUpperCase() : '';
                            List<Stamping_Charges__mdt> stampChargeAmt =[Select ID,MasterLabel,Declaration_Of_Title_Mortgage__c,Declaration_of_Original_Mortgage__c,
                                                                         Create_Mortgage_Charges__c,Housing_Loan_Agreement__c,Agreement_of_Guarantee__c 
                                                                         From Stamping_Charges__mdt Where MasterLabel =:BranchState Limit 1];
                            system.debug('***Stmp_Charg***'+stampChargeAmt);
                            if(stampChargeAmt.size()>0){
                                if(DocName1 == Constants.A23_HL ){
                                    stampCharge1 = stampChargeAmt[0].Housing_Loan_Agreement__c;
                                }
                                if(DocName2 == Constants.A46_HL){
                                    stampCharge2 = stampChargeAmt[0].Agreement_of_Guarantee__c;
                                }
                                if(app.Record_Type_Name__c==Constants.HOMELOAN){
                                    if(DocName3 == Constants.B1_HL){
                                        stampCharge3 = stampChargeAmt[0].Declaration_Of_Title_Mortgage__c;
                                    }
                                    /*if(DocName4 == Constants.B2_HL){
stampCharge4 = stampChargeAmt[0].Declaration_of_Original_Mortgage__c;
}*/
                                    if(DocName5 == Constants.B17_HL){
                                        stampCharge5 = stampChargeAmt[0].Create_Mortgage_Charges__c;
                                    }
                                }
                                else if(app.Record_Type_Name__c==Constants.LAPLOAN){
                                    if(DocName3 == Constants.B1_HL){
                                        stampCharge3 = stampChargeAmt[0].Declaration_Of_Title_Mortgage__c;
                                        stampCharge3= stampCharge3 *  application[0].genesis__Collaterals__r.size();
                                    }
                                }
                            }
                            totalStampChg = stampCharge1 + stampCharge2 + stampCharge3 +stampCharge5;
                            app.Total_Stamp_Paper_Charge__c = totalStampChg != null ? totalStampChg : 0;
                        }
                    }
                    genesis__Applications__c oldPlan = oldList.get(App.Id);
                    if(app.Record_Type_Name__c ==Constants.HOMELOAN && oldPlan.Tripartite_Agreement__c!=App.Tripartite_Agreement__c && App.Tripartite_Agreement__c){
                        app.Reject_Scenario__c= '';
                        if(app.Sub_Stage__c ==Constants.Sub_Stage_PropInfoCaptured ){ 
                            app.Sub_Stage__c =Constants.Sub_Stage_LoanReqCaptured;
                        }
                    }
                }
            }
        }catch(Exception e){
            //System.debug('Error'+e.getLineNumber()+'Class'+e.getStackTraceString()+'Message'+e.getMessage());
            HandleBusinessException.captureError('Calculate_Estamp_HL','calEstamp', e);
        }
    }
    
    public static void HLScoreRejectionScenario(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        list<genesis__Applications__c> ApplicationList  = new list<genesis__Applications__c>();
        list<genesis__Applications__c> updateAppList  = new list<genesis__Applications__c>();
        genesis__applications__c appListUp;
        try{
            for(genesis__Applications__c app : appList){
                genesis__Applications__c oldPlan = oldList.get(App.Id);
                if(app.Record_Type_Name__c ==Constants.HOMELOAN ){
                    if(oldPlan.Sub_Stage__c!=App.Sub_Stage__c && !App.Tripartite_Agreement__c && (app.Sub_Stage__c ==Constants.Sub_Stage_LoanReqCaptured  || app.Sub_Stage__c ==Constants.TermsAccepted || app.Sub_Stage__c ==Constants.APPL_STAGE_LOAN_SANCTIONED_NON_STOP)){ 
                        ApplicationList.add(App);
                    }
                    else if(App.Tripartite_Agreement__c){
                        ApplicationList.add(App);
                    }
                }
            }
            if(ApplicationList.size()>0 && ApplicationList!=null){
                List<genesis__Applications__c> ApList=[select id,Sub_Stage__c,genesis__Total_Score__c,Reject_Scenario__c,Record_Type_Name__c,Tripartite_Agreement__c from genesis__Applications__c where ID IN:APPlist];
                for(genesis__Applications__c Ap:ApList){
                    appListUp =  new genesis__applications__c();
                    System.debug('@AJ app:::'+ap);
                    if(!Ap.Tripartite_Agreement__c && ap.Sub_Stage__c ==Constants.Sub_Stage_LoanReqCaptured ){ 
                        System.debug('@AJ app:::'+ap);
                        if(Ap.genesis__Total_Score__c<50 && Ap.genesis__Total_Score__c>=47 ){
                            appListUp.Sub_Stage__c = Constants.ScoreLowStage;//changed as per dicussion with akshaya:Date:12-12-18
                            appListUp.Reject_Scenario__c= Constants.ScoreLowStage;
                            appListUp.id = Ap.id;
                            updateAppList.add(appListUp);
                        }
                        else if( Ap.genesis__Total_Score__c<47){
                            appListUp.Sub_Stage__c = Constants.Sub_Stage_PropInfoCaptured;
                            appListUp.Reject_Scenario__c= Constants.ScoreLowStage;
                            appListUp.id = Ap.id;
                            updateAppList.add(appListUp);
                        }
                    }
                    else if(!Ap.Tripartite_Agreement__c && (ap.Sub_Stage__c ==Constants.TermsAccepted || ap.Sub_Stage__c ==Constants.APPL_STAGE_LOAN_SANCTIONED_NON_STOP)){
                        if(Ap.genesis__Total_Score__c<47 ){
                            appListUp.Sub_Stage__c = Constants.TermsAccepted;
                            appListUp.Reject_Scenario__c= Constants.ScoreLowStage;
                            appListUp.id = Ap.id;
                            updateAppList.add(appListUp);
                        }
                        else if(Ap.genesis__Total_Score__c<50 && Ap.genesis__Total_Score__c>=47){
                            //  if(app.Sub_Stage__c ==Constants.TermsAccepted)
                            appListUp.Sub_Stage__c = Constants.TermsAccepted;
                            appListUp.Reject_Scenario__c= Constants.ScoreLowStage;
                            appListUp.id = Ap.id;
                            updateAppList.add(appListUp);
                        }
                        
                    }
                    
                    
                    if(Ap.Tripartite_Agreement__c){
                        if( Ap.genesis__Total_Score__c<47){
                            appListUp.Sub_Stage__c = Constants.ScoreLowStage;
                            appListUp.Reject_Scenario__c=Constants.ScoreLowStage;
                            appListUp.id = Ap.id;
                            updateAppList.add(appListUp);
                        }
                    }
                    /*
if(App.Tripartite_Agreement__c){
appListUp.Reject_Scenario__c= '';
if(app.Sub_Stage__c ==Constants.Sub_Stage_PropInfoCaptured ){ 
appListUp.Sub_Stage__c =Constants.Sub_Stage_LoanReqCaptured;
appListUp.id = App.id;
updateAppList.add(appListUp);
}
else if(app.Sub_Stage__c ==Constants.TermsAccepted || app.Sub_Stage__c ==Constants.APPL_STAGE_LOAN_SANCTIONED_NON_STOP ){
appListUp.Sub_Stage__c =Constants.APPL_STAGE_LOAN_SANCTIONED_NON_STOP;
appListUp.id = App.id;
updateAppList.add(appListUp);
}
}  */
                }
                
                if(updateAppList!= null && updateAppList.size()>0){
                    
                    //  ApplicationTriggerHandler.IsFirstRun = False;
                    update updateAppList;
                } 
            }
        }
        catch(exception e){
            system.debug('error'+e.getMessage()+'line Number'+e.getLineNumber());
            HandleBusinessException.captureError('Calculate_Estamp_HL','HLScoreRejectionScenario', e);
        }
    }
    public static void BranchRejectionHL(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        try{
            map<string,id> BrancMap;
            set<id> AppIDs=new Set<Id>();
            list<genesis__Applications__c> UpdateAppList=new list<genesis__Applications__c>();
            list<genesis__Application_Parties__c> UpdateAPartList=new list<genesis__Application_Parties__c>();
            for(genesis__Applications__c app : appList){ 
                genesis__Applications__c oldPlan = oldList.get(App.Id);
                System.debug('@AJ app:::'+app);
                System.debug('@AJ oldPlan:::'+oldPlan);
                if( oldPlan.Sub_Stage__c!=App.Sub_Stage__c && !Utility.ISStringBlankorNull(App.Branch_Code__c) && (((App.Record_Type_Name__c ==Constants.LAPLOAN || App.Record_Type_Name__c ==Constants.HOMELOAN ) && App.Sub_Stage__c == Constants.Sub_Stage_PropInfoCaptured ) || ((App.Record_Type_Name__c ==Constants.VL2W || App.Record_Type_Name__c ==Constants.VL4W) && App.Sub_Stage__c == Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE) || (App.Record_Type_Name__c ==Constants.PERSONALLOAN && App.Sub_Stage__c == Constants.PERSONNAL_DETAILS_CAPTURED_SUBSTAGE ))){
                    system.debug('g');
                    BrancMap =new  map<string,id>();
                    BrancMap.put(App.Branch_Code__c ,app.id);
                }
            }
            
            List<Branch_Master__c> BranchList = new List<Branch_Master__c>();
            if(BrancMap != null){
                system.debug('sdsdsdsdsds'+BrancMap);
                if(BrancMap.keyset() != null)
                    BranchList=[select id,CODCCBRN__c,Special_Branches__c,Retail_Category__c,NAMCCCITY__c from Branch_Master__c where CODCCBRN__c IN:BrancMap.keyset() and Special_Branches__c=true];
                
            }
            system.debug('jjjjjjjjj'+BranchList);
            if(BranchList!= null && BranchList.size()>0){
                for(Branch_Master__c BMast:BranchList){
                    if(BrancMap.containsKey(BMast.CODCCBRN__c)){
                        AppIDs.add(BrancMap.get(BMast.CODCCBRN__c)) ;
                    }
                }
                system.debug('AppIDs'+AppIDs);
                
                //KVB_Company_Details__c company = KVB_Company_Details__c.getOrgDefaults();
                List<genesis__Applications__c> BrApplist=[select id,Sub_Stage__c,Sub_Type__c,genesis__CL_Product__r.Special_Branches_Cutoff__c,Record_Type_Name__c,Branch_Code__c,(select id,CIBIL_Scores__c,genesis__Party_Type__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false ) from genesis__Applications__c where id IN:AppIDs];
                system.debug(BrApplist);
                
                for(genesis__Applications__c DApp:BrApplist){
                    
                    for(genesis__Application_Parties__c Party:DApp.genesis__Application_Parties__r){
                        system.debug('DApp.genesis__CL_Product__r.Special_Branches_Cutoff__c:-'+DApp.genesis__CL_Product__r.Special_Branches_Cutoff__c);
                        if((Party.CIBIL_Scores__c < DApp.genesis__CL_Product__r.Special_Branches_Cutoff__c  && Party.CIBIL_Scores__c >=650) || Party.CIBIL_Scores__c==-1 || (Party.CIBIL_Scores__c>=1 && Party.CIBIL_Scores__c<=10)){
                            boolean Primary=false;
                            boolean Co_borrower=false;
                            if(Party.genesis__Party_Type__c==Constants.PRIMARY_APP){
                                Primary=true;
                            }
                            else {
                                Co_borrower=true;
                                Party.Active__c=false;
                                if((UpdateAppList.size()==0 || UpdateAppList==null) && DApp.Sub_Stage__c!=Constants.LOW_CIBIL_SCORE_SUBSTAGE){
                                    system.debug(BrApplist);
                                    DApp.Sub_Stage__c=Constants.AppCreated;
                                    UpdateAppList.add(DApp);
                                }
                                UpdateAPartList.add(Party);
                            }
                            system.debug('Co_borrower'+Co_borrower+'DApp.Sub_Type__c'+DApp.Sub_Type__c);
                            if(Primary || (Co_borrower && (DApp.Sub_Type__c==Constants.Sub_Type_Top_Up || DApp.Sub_Type__c==Constants.Sub_Type_Take_Over))){
                                system.debug('AppDummy'+UpdateAppList);
                                UpdateAppList.clear();
                                DApp.Sub_Stage__c=Constants.LOW_CIBIL_SCORE_SUBSTAGE;
                                DApp.Reject_Scenario__c=Constants.LOW_CIBIL_SCORE_SUBSTAGE;
                                UpdateAppList.add(DApp); 
                                system.debug('AppDummy1'+UpdateAppList);
                            }
                        }
                    }
                    
                }
                system.debug('AppDummy2'+UpdateAppList);
                if(UpdateAppList.size()>0){
                    update UpdateAppList;
                }
                
                if(UpdateAPartList.size()>0){
                    update UpdateAPartList;
                }
            }
        }
        catch(exception e){
            system.debug('error'+e.getMessage()+'line Number'+e.getLineNumber());
            HandleBusinessException.captureError('Calculate_Estamp_HL','BranchRejectionHL', e);
        }
        
    }
}