/*
* Name   :SME_PRE_RENEWAL_CHECKING
* Purpose: Check application record before pre-renewal record creation
* Author : Amritesh 
*/ 
public class SME_PRE_RENEWAL_CHECKING {
    
    public static void createPrechecklist(List<Id> listappId){
        Integer i;
        try{
            //genesis__Applications__c appInfo  = SOQL_Util.getApplication(appID);
            //Latest_Valuation_Date__c,
            //Latest_Audited_Financial_Statement_Year__c
            
            //Get current fiscal year
            Integer currentYear = Utility.getCurrentYear();
            String cyString = String.valueOf(currentYear);
            String currentFY = '('+(currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()))+')';
            
            List<genesis__Applications__c> listappInfo  = [Select id,FEC_Reference_Number__c,Security_ID__c,Asset_ID__c,Charge_ID__c,
                                                   SRN_ID__c,Insurance_Number__c,Insurance_Value__c,Insurance_Start_Date__c,
                                                   Insurance_End_Date__c,Asset_Description__c,Asset_Value__c,Latest_Month_Stock_Statement__c,
                                                   Latest_Date_of_Visit__c,EC_Reference__c,EC_Date__c,Latest_Audited_Financial_Statement_Year__c,Latest_Valuation_Date__c,
                                                   EC_Start_Date__c,EC_End_Date__c,Pre_Renewal_Checklist__c
                                                   from genesis__Applications__c where id IN : listappId];
            
            List<Pre_Renewal_Checklist__mdt> preChecklist   = new List<Pre_Renewal_Checklist__mdt>();
            preChecklist    = [Select id,MasterLabel,DeveloperName,SeqNo__c,Checklist_Name__c from Pre_Renewal_Checklist__mdt];
            
            List<Renewal_Checklists__c> newlist =  new List<Renewal_Checklists__c>();
            
           // Map<genesis__Applications__c,int> mapObject = new Map<genesis__Applications__c,int>();
            List<genesis__Applications__c> listappObj = new List<genesis__Applications__c>();
            
            for(genesis__Applications__c appInfo : listappInfo){
                
                i =0; //reset the value.
                for(Pre_Renewal_Checklist__mdt pr : preChecklist){
                    if(pr.SeqNo__c == 1){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        if(appInfo != null && appInfo.FEC_Reference_Number__c !=null){
                            rCheck.Complied__c  = Constants.SME_YES;
                            i++;
                        }
                        newlist.add(rCheck);
                    }
                    if(pr.SeqNo__c  == 2){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        if(appInfo != null && appInfo.Security_ID__c !=null && appInfo.Asset_ID__c != null
                           && appInfo.Asset_Description__c != null && appInfo.Asset_Value__c !=null){
                               rCheck.Complied__c   = Constants.SME_YES;
                               i++;
                           }
                        newlist.add(rCheck);
                    }
                    if(pr.SeqNo__c  == 3){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        if(appInfo != null && appInfo.Charge_ID__c !=null && appInfo.SRN_ID__c != null){
                            rCheck.Complied__c  = Constants.SME_YES;
                            i++;
                        }
                        newlist.add(rCheck);
                    }
                    if(pr.SeqNo__c  == 4){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        newlist.add(rCheck);
                    }
                    if(pr.SeqNo__c  == 5){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        if(appInfo != null && appInfo.Latest_Month_Stock_Statement__c !=null ){
                            rCheck.Complied__c  = Constants.SME_YES;
                            i++;
                        }
                        newlist.add(rCheck);
                    }
                    if(pr.SeqNo__c  == 6){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        newlist.add(rCheck);
                    }
                    if(pr.SeqNo__c  == 7){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        if(appInfo != null && appInfo.Latest_Date_of_Visit__c !=null){
                            rCheck.Complied__c  = Constants.SME_YES;
                            i++;
                        }
                        newlist.add(rCheck);
                    }
                    if(pr.SeqNo__c  == 8){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        if(appInfo != null && appInfo.EC_Reference__c != null && appInfo.EC_Date__c != null
                           && appInfo.EC_Start_Date__c !=null && appInfo.EC_End_Date__c !=null){
                            rCheck.Complied__c  = Constants.SME_YES;
                            i++;
                        } 
                        newlist.add(rCheck);
                    }
                    if(pr.SeqNo__c  == 9){
                       Renewal_Checklists__c rCheck = getPreRenewalObj(pr, appInfo.id);
                       if(appInfo != null && appInfo.Insurance_Number__c != null && appInfo.Insurance_Value__c != null
                           && appInfo.Insurance_Start_Date__c !=null && appInfo.Insurance_End_Date__c !=null){
                               rCheck.Complied__c   = Constants.SME_YES;
                               i++;
                        }
                        newlist.add(rCheck);
                    }
                   if(pr.SeqNo__c   == 10){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        if(appInfo != null && appInfo.Latest_Valuation_Date__c != null){
                               rCheck.Complied__c   = Constants.SME_YES;
                               i++;
                           }
                        newlist.add(rCheck);
                    } 
                    if(pr.SeqNo__c  == 11){
                        Renewal_Checklists__c rCheck    = getPreRenewalObj(pr, appInfo.id);
                        rCheck.Checklist_Name__c +=  currentFY;             
                        if(appInfo != null && appInfo.Latest_Audited_Financial_Statement_Year__c != null){
                               rCheck.Complied__c   = Constants.SME_YES;
                               i++;
                           }
                        newlist.add(rCheck);
                    } 
                    
                }
                if(i==9){
                    appInfo.Pre_Renewal_Checklist__c ='Approved';
                    listappObj.add(appInfo);
                }
           }
           if(newlist.size()>0)
                insert newlist;
                
           if(listappObj.size()>0) 
                update listappObj; 
          
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    }
    
    static Renewal_Checklists__c getPreRenewalObj(Pre_Renewal_Checklist__mdt mdt, string appId){
        return new Renewal_Checklists__c(Checklist_Name__c=mdt.Checklist_Name__c,Sl_No__c=String.ValueOf(Integer.valueOf(mdt.SeqNo__c)),Application__c=appId);      
    }
    
}