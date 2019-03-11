/*
* Name    : Re_run_Bureau 
* Company : ET Marlabs
* Purpose : This class is used to re run bureau and list matching (LAP)
* Author  : Subas
*/
public class Re_run_Bureau {
    public static void run_bureau(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        try{
            String type = 'LAP';
            for(genesis__Applications__c app : appList){
                system.debug('oldList.get(app.Id).sub_stage__c:--'+oldList.get(app.Id).sub_stage__c+'     app.Sub_Stage__c:--'+app.Sub_Stage__c);
                if(oldList.get(app.Id).sub_stage__c <> app.Sub_Stage__c && app.Sub_Stage__c =='Terms and Conditions Accepted' && app.Record_Type_Name__c == 'LAP'){                    
                    callCommercial(app.ID, type);
                    //CommercialPR_EAE_Batch.getCommercialPR_EAE_Request(getcompany(app.ID), type,app.ID);
                    //Batch_jocataListMatchingHelper.getJocataTxnforAcc(accountInfo);
                    List <Account> accList = getAccount(app.Id);
                    if(accList.size()>0){
                        callJocataTokenMethod(JSON.Serialize(accList ));
                        for(Account acc : accList){
                            String txnId = Batch_jocataListMatchingHelper.getJocataTxnforAcc(acc);
                            acc.Jocata_TxnId__c = txnId;
                        }
                        System.debug('@#$%^'+accList);
                        update accList;
                       
                    }
                }
                
            }
        }catch(Exception e){
            HandleBusinessException.captureError('Re_run_Bureau', 'run_bureau', e);
        }
    }
    public static List<String> getcompany(String appId){
        List <String> Accids = new List <String>();
        set<id> FiIDs = new Set<id>();
        List<genesis__Application_Parties__c> FIPTList = [Select Id,genesis__Party_Account_Name__r.id,Financial_Applicant__c From genesis__Application_Parties__c where Company__c =:true AND genesis__Application__c =: appId AND Active__c =:true AND Financial_Applicant__c =: true];
        for(genesis__Application_Parties__c fip:FIPTList){
            FiIDs.add(fip.genesis__Party_Account_Name__r.id);
        }
        system.debug('##DataLog### --- > '+FiIDs );
        List<genesis__Application_Parties__c> PTList = [Select Id,Key_Contact__c,Key_Contact__r.CBS_Customer_ID__c From genesis__Application_Parties__c where Company__c =:true AND genesis__Application__c =: appId AND Active__c =:true AND genesis__Party_Account_Name__c =: FiIDs];
        if(PTList.size() >0){
            for(genesis__Application_Parties__c PT : PTList){
                Accids.add(PT.Key_Contact__r.CBS_Customer_ID__c);
            }
    /*      List<ints__TransUnion_Credit_Report__c> trnsList = new List<ints__TransUnion_Credit_Report__c>();
            trnsList = [select Id,Account__r.CBS_Customer_ID__c from ints__TransUnion_Credit_Report__c where Account__r.CBS_Customer_ID__c IN: Accids AND Expired__c =:false];
            List<String> CBSId = new List<String>();
            if(trnsList.size()>0){
                for(ints__TransUnion_Credit_Report__c tu : trnsList){
                    CBSId.add(tu.Account__r.CBS_Customer_ID__c);
                }
                return CBSId;
            } */
            return Accids;
        }
        
        return null;
    }
    public static List<Account> getAccount(String AppId){
        List <String> Accids = new List <String>();
        set<id> FiIDs = new Set<id>();
        List<genesis__Application_Parties__c> FIPTList = [Select Id,genesis__Party_Account_Name__r.id,Financial_Applicant__c From genesis__Application_Parties__c where Company__c =true AND genesis__Application__c =: appId AND Active__c =true AND Financial_Applicant__c = true];
        for(genesis__Application_Parties__c fip:FIPTList){
            FiIDs.add(fip.genesis__Party_Account_Name__r.id);
        }
        List<genesis__Application_Parties__c> PTList = [Select Id,Key_Contact__c From genesis__Application_Parties__c where Company__c =true AND genesis__Application__c =: appId AND Active__c =true AND genesis__Party_Account_Name__c =: FiIDs AND (genesis__Party_Type__c ='Partner' OR genesis__Party_Type__c ='Proprietor') AND Financial_Applicant__c = true];
        if(PTList.size() >0){
            for(genesis__Application_Parties__c PT : PTList){
                Accids.add(PT.Key_Contact__c);
            }        
            List <Account> accList = [Select Id,Name,CBS_Customer_ID__c,PersonBirthdate,PersonMailingStreet,PersonMailingCity,
                                      PersonMailingState,PersonMailingCountry,Nationality__pc,Pan_Number__c,Driving_License_ID__c,
                                      Aadhaar_Number__pc,Ration_Card__c,PersonMobilePhone,BillingStreet,BillingCountry,BillingState,BillingCity,Phone,PersonEmail from Account Where ID IN: Accids];
            return accList;
        }
        return null;
    }
    
    @future (callout=true)
    public static void callJocataTokenMethod(string accString){
        try{
            List<Account> accList = (List<Account>) System.JSON.deserialize(accString,List<Account>.class);
            for(Account acc: accList){
                String txnId = Batch_jocataListMatchingHelper.getJocataTxnforAcc(acc);
                acc.Jocata_TxnId__c = txnId;
            }
			AccountTriggerHandler.isAccountTrigger  = true;          
            update accList;
        }catch(Exception e){}        
    }
    @future (callout=true)
    public static void callCommercial(String appId,String type){
        CommercialPR_EAE_Batch.getCommercialPR_EAE_Request(getcompany(appId), type,appId);
    }
}