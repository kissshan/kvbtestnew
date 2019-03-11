/*
* Name    : Call_BRE_HL
* Company : ET Marlabs
* Purpose : This class is used to call BRE
* Author  : Subas
*/
public class Call_BRE_HL {
    public static void call_BRE(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        Decimal calVal = 0.00;
        set<id> AppListIDs=new set<id>();
        for(genesis__Applications__c Ap:appList){
            AppListIDs.add(Ap.id);
        }
        if(AppListIDs!=null && AppListIDs.size()>0){
         List<genesis__Applications__c> listapp =[select id,Retail_BRE_Hit__c,Record_Type_Name__c,sub_stage__c,FI_Status__c from genesis__Applications__c where ID IN: AppListIDs];
            if(listapp!=null && listapp.size()>0){
                for(genesis__Applications__c app : listapp){
                   System.debug(' OldStage>>> ' + oldList.get(app.Id).sub_stage__c +' NewStg>> '+ app.Sub_Stage__c +' NEWBREHIT>> '+ app.Retail_BRE_Hit__c + ' OLD BREHIT>> ' + oldList.get(app.Id).Retail_BRE_Hit__c );

                    if(app.Record_Type_Name__c == Constants.HOMELOAN || app.Record_Type_Name__c == Constants.LAPLOAN || app.Record_Type_Name__c ==Constants.VL2W || app.Record_Type_Name__c ==Constants.VL4W || app.Record_Type_Name__c ==Constants.PERSONALLOAN){
                        if((oldList.get(app.Id).sub_stage__c <> app.Sub_Stage__c && app.Sub_Stage__c == Constants.LOAN_REQUIREMENT_CAPTURED_SUBSTAGE && app.Retail_BRE_Hit__c == 1) || (oldList.get(app.Id).Sub_Stage__c == 'Terms and Conditions Accepted' && app.Retail_BRE_Hit__c != oldList.get(app.Id).Retail_BRE_Hit__c && (app.Retail_BRE_Hit__c == 2 || app.Retail_BRE_Hit__c == 3) ))
                        {
                            System.debug(' 1234OldStage>>> ' + oldList.get(app.Id).sub_stage__c +' NewStg>> '+ app.Sub_Stage__c +' NEWBREHIT>> '+ app.Retail_BRE_Hit__c + ' OLD BREHIT>> ' + oldList.get(app.Id).Retail_BRE_Hit__c );
                            String s = genesis.ScorecardAPI.generateScorecard(app.Id);
                            system.debug('***Re_run_BRE ScorecardAPI ****'+s);                  
                        }
                    }
                   /*Commented old code to implement rocess builder code
                    if(((oldList.get(app.Id).sub_stage__c <> app.Sub_Stage__c && (app.Sub_Stage__c =='Loan Requirement Captured' || app.Sub_Stage__c =='Loan Sanctioned Non-STP')) || (app.Retail_BRE_Hit__c != oldList.get(app.Id).Retail_BRE_Hit__c)) && (app.Record_Type_Name__c =='Home Loan' || app.Record_Type_Name__c =='LAP')){ 
                        String s = genesis.ScorecardAPI.generateScorecard(app.Id);
                        system.debug('*******'+s);                
                    }else if(oldList.get(app.Id).sub_stage__c <> app.Sub_Stage__c && app.Sub_Stage__c =='Terms and Conditions Accepted' && app.Record_Type_Name__c =='Home Loan'){
                        String s = genesis.ScorecardAPI.generateScorecard(app.Id);
                        system.debug('***Re_run_BRE****'+s);                   
                    }
                   //braj-start
                    else if(((oldList.get(app.Id).sub_stage__c <> app.Sub_Stage__c && app.Sub_Stage__c == Constants.LOAN_REQUIREMENT_CAPTURED_SUBSTAGE) || ( oldList.get(app.Id).Sub_Stage__c == 'Terms and Conditions Accepted' && (app.Retail_BRE_Hit__c != oldList.get(app.Id).Retail_BRE_Hit__c || app.FI_Status__c == Constants.PL_FIRES_POSI) )) && (app.Record_Type_Name__c ==Constants.VL2W || app.Record_Type_Name__c ==Constants.VL4W)){
                        System.debug(' 1234OldStage>>> ' + oldList.get(app.Id).sub_stage__c +' NewStg>> '+ app.Sub_Stage__c +' NEWBREHIT>> '+ app.Retail_BRE_Hit__c + ' OLD BREHIT>> ' + oldList.get(app.Id).Retail_BRE_Hit__c );
                        String s = genesis.ScorecardAPI.generateScorecard(app.Id);
                        system.debug('***Re_run_BRE for Vehicle Loan****'+s);                  
                    }
                    System.debug(' OldStage>>> ' + oldList.get(app.Id).sub_stage__c +' NewStg>> '+ app.Sub_Stage__c +' NEWBREHIT>> '+ app.Retail_BRE_Hit__c + ' OLD BREHIT>> ' + oldList.get(app.Id).Retail_BRE_Hit__c );
                    //braj-end*/
                }
            }
        }
    }
    
    public static integer DocumnetsCount(genesis__Applications__c App){
        integer HLDocCount;
        if(App.Record_Type_Name__c == Constants.HOMELOAN){
            if (App.Sub_Type__c == Constants.Sub_Type_Top_Up)
                HLDocCount=2;
            else if(App.Sub_Type__c == Constants.Sub_Type_Take_Over)
                HLDocCount=4;
            else {
                HLDocCount=3;
            }
            if(App.genesis__Application_Parties__r.size()>0){
                boolean Guarantor=false;
                for(genesis__Application_Parties__c Part :App.genesis__Application_Parties__r){
                    if(Part.genesis__Party_Type__c==Constants.Gurantor && !Guarantor){
                        Guarantor=true;
                    }
                }
                if(Guarantor)
                    HLDocCount = HLDocCount+1;
            }
            
            if(App.Loan_Purpose__c==Constants.IdentifiedProperty || App.Loan_Purpose__c==Constants.ConstructionOn){
               HLDocCount = HLDocCount+1;
            }
            /*else  if(App.Loan_Purpose__c==Constants.Construction || App.Loan_Purpose__c==Constants.RepairHouse){
                HLDocCount = HLDocCount+2;
            }*///commented by braj on 15-02-2019 as B2 document is not generating anymore
        }
        return HLDocCount;
    }
}