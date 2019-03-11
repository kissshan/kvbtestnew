/*
* Name          : PerfiosErrorTriggerHandler
* Description   : Haldles all logic for perfios error creation or changes
* Author        : Dushyant
*/
public class PerfiosErrorTriggerHandler {
    //singleton instance
    public static PerfiosErrorTriggerHandler instance = null;
    
    //constructor
    public PerfiosErrorTriggerHandler(){}
    
    //get singleton instance
    public static PerfiosErrorTriggerHandler getInstance(){
        if(instance == null){
            instance = new PerfiosErrorTriggerHandler();
        }
        return instance;
    }
    //Update application stage on transaction id update for perfios error update
    public void updateApplicationStatus(List<Perfios_Error__c> newList){
        /*List<Account> accList = new List<Account>();
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        Map<Id,String> accIdErrorMap = new Map<Id,String>();

        for(Perfios_Error__c pError : newList){
                accIdErrorMap.put(pError.Perfios__r.Applicant_Name__c,pError.Error_message__c);
        }
        
        appList = [SELECT recordTypeID,Application_Stage__c,genesis__Account__c,RecordType.DeveloperName FROM genesis__Applications__c WHERE genesis__Account__c IN :accIdErrorMap.keySet()];
        if(!appList.isEmpty()){
            for(genesis__Applications__c app : appList){
                if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE && app.Application_Stage__c != Constants.APP_STAGE_CLOSE && app.Application_Stage__c != Constants.APP_STAGE_WB_CUST){
                    app.Application_Stage__c = Constants.APP_STAGE_PERFIOS_ERROR;
                    accList.add(new Account(Id = app.genesis__Account__c,Perfios_error_message__c = accIdErrorMap.get(app.genesis__Account__c)));
                }
            }
            if(!accList.isEmpty()){
                UPDATE appList;
                UPDATE accList;
            }
        }*/
    }
}