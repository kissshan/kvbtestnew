/* 
* Name     : PerfiosTriggerHandler
* Purpose  : Handler class for PerfiosTrigger
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class PerfiosTriggerHandler {
//singleton instance
    private static PerfiosTriggerHandler instance = null;
    
    //constructor
    private PerfiosTriggerHandler(){}
    
    //get singleton instance
    public static PerfiosTriggerHandler getInstance(){
        if(instance == null){
            instance = new PerfiosTriggerHandler();
        }
        RETURN instance;
    }
    
    public void afterUpdate(Map<Id,Perfios__c> newMap,Map<Id,Perfios__c> oldMap){
        //Update application stage on insertion of Tx Id
        List<Id> accIdList = new List<Id>();
        Map<Id,Id> accAppIdMap = new Map<Id,Id>();
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        for(Id perfId : newMap.keySet()){
            if(newMap.get(perfId).Transaction_Id__c != oldMap.get(perfId).Transaction_Id__c && newMap.get(perfId).Transaction_Id__c != null){
                accIdList.add(newMap.get(perfId).Applicant_Name__c);
            }
        }
        if(!accIdList.isEmpty()){
            appList = [SELECT Id,Application_Stage__c FROM genesis__Applications__c WHERE genesis__Account__c IN :accIdList AND recordType.developerName = :Constants.SME_APP_RECORD_TYPE];
        }
        System.debug('appList'+appList);
        if(!appList.isEmpty()){
            for(genesis__Applications__c app : appList){
                app.Application_Stage__c = 'Perfios upload pending output';
                accAppIdMap.put(app.genesis__Account__c,app.Id);
            }
            for(Perfios__c perf : newMap.values()){
                if(accAppIdMap.get(perf.Applicant_Name__c)!= null)
                    perf.Application_id__c = accAppIdMap.get(perf.Applicant_Name__c);
            }
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE appList;
        }
    }
    //Updating Account with existing emis
    public void updateEmiAcc(List<Perfios__c> newList,Map<Id,Perfios__c> oldMap){
        try{
            Set<ID> accIds = new Set<ID>();
            for(Perfios__c per : newList){
                if((oldMap.get(per.Id).EMI_for_Latest_Month__c <> per.EMI_for_Latest_Month__c) && per.EMI_for_Latest_Month__c != null){
                    accIds.add(per.Applicant_Name__c);
                }
            }
            List<Account> accList = [Select Id,Existing_EMI_Perfios__c, (Select Id,EMI_for_Latest_Month__c From Perfios__r where Active__c = true) From Account Where Id IN: accIds];
            List<Account> accountList = new List<Account>();
            for(Account acc : accList){
                
                Decimal EMIVal = 0;
                system.debug('###'+acc.Perfios__r);
                for(Perfios__c per : acc.Perfios__r){                
                    EMIVal = EMIVal + (per.EMI_for_Latest_Month__c != null ? per.EMI_for_Latest_Month__c : 0);                
                }       
                if(EMIVal > 0){
                    system.debug('@@@'+EMIVal);
                    acc.Existing_EMI_Perfios__c = EMIVal;
                    accountList.add(acc);
                }
            }
            AccountTriggerHandler.isAccountTrigger = false;
            update accountList;
        }catch(Exception e){
                                 system.debug('Error'+e.getStackTraceString()+'Line Number'+e.getLineNumber()+'ErrorMsg : '+e.getMessage());

        }
    }    
}