public class Batch_JocataListMatchErrorHandling implements Database.Batchable<sObject> {
    String query;
    Static Set<String> APP_SUB_STAGES           = new Set<String>{'Terms and Conditions Accepted'};
        
        public Database.QueryLocator start(Database.BatchableContext BC) {
            string APP_TYPE = 'LAP';
            query = 'SELECT Id,genesis__Application__c,genesis__Application__r.OwnerId,Key_Contact__c,Key_Contact__r.Jocata_TxnId__c,Key_Contact__r.Bureau_Score__c,Key_Contact__r.Jocata_List_Match__c FROM genesis__Application_Parties__c where genesis__Application__r.RecordType.DeveloperName =:APP_TYPE AND genesis__Application__r.Sub_Stage__c IN:APP_SUB_STAGES AND Company__c = true AND genesis__Application__r.Task_Completed__c =false';
            return Database.getQueryLocator(query);
        }
    
    public void execute(Database.BatchableContext BC, List<genesis__Application_Parties__c> partyAccounts){
        
        try{
            
            Map<String,List<Account>> applTaskMap = new Map<string,List<Account>>();
            Set<Id> ownerIds                      = new Set<Id>();
            Map<String,string> appIdVsOwerID      = new Map<String,string>();
            
            for(genesis__Application_Parties__c apRec: partyAccounts){
                ownerIds.add(apRec.genesis__Application__r.OwnerId);
                appIdVsOwerID.put(apRec.genesis__Application__c,apRec.genesis__Application__r.OwnerId);
                //Account acc = new Account(Id=apRec.Key_Contact__c,Bureau_Score__c=apRec.Key_Contact__r.Bureau_Score__c,Jocata_List_Match__c=apRec.Key_Contact__r.Jocata_List_Match__c);
                Account acc = new Account();
                acc = [select Id,Jocata_List_Match__c,Bureau_Score__c,(Select Id,Response__c,Account__c from TU_Errors__r) From Account where Id =: apRec.Key_Contact__c AND Bureau_Score__c =: apRec.Key_Contact__r.Bureau_Score__c AND Jocata_List_Match__c =: apRec.Key_Contact__r.Jocata_List_Match__c];
                if(applTaskMap.containsKey(apRec.genesis__Application__c)){
                    applTaskMap.get(apRec.genesis__Application__c).add(acc);
                }else{
                    List<Account> accts = new List<Account>();
                    accts.add(acc);
                    applTaskMap.put(apRec.genesis__Application__c, accts);
                }            
            }
            system.debug('::applTaskMap::'+applTaskMap);
            Map<String,User> appManagers                = new Map<string,User>(getUserInfo(ownerIds));
            List<Task> taskListToInsert                 = new List<Task>();
            List<genesis__Applications__c> appsToUpdate = new List<genesis__Applications__c>();
            for(String appKey : applTaskMap.keySet()){
                integer jCount  = 0;
                integer bCount  = 0;
                boolean jTask   = false;
                boolean bTask   = false;
                if(applTaskMap.containsKey(appKey) && applTaskMap.get(appKey).size()> 0){
                    system.debug(applTaskMap.get(appKey));
                    for(Account apRec : applTaskMap.get(appKey)){
                        if(apRec.Jocata_List_Match__c != null){
                            jCount++;
                            if(apRec.Jocata_List_Match__c == 'Yes'){
                                jTask   = true;                 
                            }
                        }
                        String tuErr = '';
                        for(TU_Error__c tu : apRec.TU_Errors__r){
                            tuErr = tu.Response__c != null ? tu.Response__c : '';
                        }
                        if(apRec.Bureau_Score__c != null || tuErr == 'NoBorrowerFound'){
                            bCount++;
                            if(Integer.valueOf(apRec.Bureau_Score__c) > 7){
                                bTask = true;                       
                            }
                        }
                    }
                    //if((jCount == applTaskMap.get(appKey).size() && jTask) || (bCount == applTaskMap.get(appKey).size() && bTask)){
                    system.debug((jCount+bCount)+'::Equals::'+((applTaskMap.get(appKey).size())*2));
                    system.debug(jTask+'::Status::'+bTask);
                    if(((jCount+bCount) == (applTaskMap.get(appKey).size())*2) && (jTask || bTask)){                    
                        if(appIdVsOwerID.containsKey(appKey) && appManagers.containsKey(appIdVsOwerID.get(appKey))){
                            appsToUpdate.add(new genesis__Applications__c(Id=appKey,Task_Completed__c=true));
                            taskListToInsert.add(new Task(WhatId=appKey,Subject='Approve associated business entity',OwnerId=appManagers.get(appIdVsOwerID.get(appKey)).ManagerID,NonDeletable__c=true,ActivityDate=System.today()+1));
                        }                   
                    }
                }
            }
            system.debug('::taskListToInsert::'+taskListToInsert);
            if(taskListToInsert.size() > 0){
                TaskFlow_Helper.TASK_TRIGGER_RUNNING    = false;
                ApplicationTriggerHandler.IsFirstRun    = false;
                insert taskListToInsert;
                update appsToUpdate;
            }
        }catch(Exception e){
            system.debug(e.getLineNumber()+'::Exception::'+e.getMessage());
        }   
    }
    public void finish(Database.BatchableContext BC) {
        
    }
    
    public static Map<string,User> getUserInfo(Set<Id> userIds){
        return new Map<string,User>([Select id,Name,ManagerId from User where Id IN :userIds]);
    }
}