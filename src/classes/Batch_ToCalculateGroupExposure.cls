/*******************************************************************************************************
* Purpose       : Batch Class to calculate Group Exposure and Overall Exposure for each Account
* Author        : Divya JC
* CreatedDate   : 06/03/2018
******************************************************************************************************/

global class Batch_ToCalculateGroupExposure implements Database.Batchable<sObject>, Database.Stateful {
    global Set<String> applicationStageSet=new Set<String>();
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String Query;
        applicationStageSet.add('Limit renewed/Application close');
        applicationStageSet.add('Marked as exit');
        applicationStageSet.add('Application close - enhancement');
        Query='Select id,genesis__Account__c from genesis__Applications__c where Application_Stage__c NOT in :applicationStageSet AND RecordType.DeveloperName =\'SME_Renewal\' AND Active__c = true';
        return Database.getQueryLocator(Query);
    }
    
    //--Batch Execute Method.
    global void execute(Database.BatchableContext bc, List <genesis__Applications__c> listOfApplicationRecords) {
        Map<ID,Set<ID>> accountwithParties=new Map<ID,Set<ID>>();
        Map<ID,Set<ID>> accountwithGroups=new Map<ID,Set<ID>>();
        Set<ID> allAccountIDSet=new Set<ID>();
        Set<ID> accountIDSet=new Set<ID>();
        
        system.debug(listOfApplicationRecords);
        try{
            //Get set of all Account Ids
            for(genesis__Applications__c gApp:listOfApplicationRecords){
                if(gApp.genesis__Account__c!=null){
                    accountIDSet.add(gApp.genesis__Account__c);
                    allAccountIDSet.add(gApp.genesis__Account__c);
                }
            }
            system.debug(accountIDSet);
            
            //Map customer account ID with the set of Parties Account IDs
            for(genesis__Application_Parties__c gparty: [Select id,genesis__Party_Account_Name__c,Key_Contact__c from genesis__Application_Parties__c where Key_Contact__c in :accountIDSet AND Active__c = true]){
                allAccountIDSet.add(gparty.genesis__Party_Account_Name__c);
                if(!accountwithParties.containsKey(gparty.Key_Contact__c)){
                    accountwithParties.put(gparty.Key_Contact__c, new Set<ID>{gparty.genesis__Party_Account_Name__c});
                    
                }else{
                    accountwithParties.get(gparty.Key_Contact__c).add(gparty.genesis__Party_Account_Name__c);
                }
            }
            
            //Map customer account ID with the set of Group Account IDs
            for(Group_Concern__c groupC: [Select id,Group_2__c,Group_1__c from Group_Concern__c where Group_1__c in :accountIDSet]){
                allAccountIDSet.add(groupC.Group_2__c);
                if(!accountwithGroups.containsKey(groupC.Group_1__c)){
                    accountwithGroups.put(groupC.Group_1__c, new Set<ID>{groupC.Group_2__c});
                    
                }else{
                    accountwithGroups.get(groupC.Group_1__c).add(groupC.Group_2__c);
                }
            }
            
            Map<ID,Account> accMap=new Map<ID,Account>();
            
            //Query required data for all customer account, group account and Person account
            for(Account acc:[Select id, Group_Exposure__c,Overall_Exposure__c from Account where ID IN:allAccountIDSet]){
                accMap.put(acc.ID,acc);
            }

            Map<ID,List<genesis__Applications__c>> appMap=new Map<ID,List<genesis__Applications__c>>();
            
            //Query all the application for all customer account, group account and Person account
            for(genesis__Applications__c app: [Select id,genesis__Account__c,Overall_Exposure__c,RecordType.DeveloperName,(SELECT Id,Balance_Outstandings__c,Existing_Limit__c,Amount_Yet_disbursed__c FROM Facilities__r where RecordType.DeveloperName='Parent') FROM genesis__Applications__c WHERE Application_Stage__c  NOT IN :applicationStageSet and genesis__Account__c IN:allAccountIDSet AND Active__c = true]){
                if(!appMap.containsKey(app.genesis__Account__c)){
                    appMap.put(app.genesis__Account__c, new List<genesis__Applications__c>{app});
                    
                }else{
                    appMap.get(app.genesis__Account__c).add(app);
                }
            } 
            
            //Calcuate Overall exposure for each account
            for(Account acc:accMap.values()){
                Decimal overallExposure=0.0;
                if(appMap.containskey(acc.id)){
                    for(genesis__Applications__c app:appMap.get(acc.id)){
                        System.debug(app.id);
                        overallExposure+=calculateOverallExposure(app);//get Overall Exposure for each application for each account
                    }
                }
                accMap.get(acc.id).Overall_Exposure__c=overallExposure;
            }
            
            //Calculate Group Exposure for each account
            for(Account acc:accMap.values()){
                Decimal groupExposure=0.0;
                if(accMap.containsKey(acc.id)){
                    if(accountwithParties.containsKey(acc.ID)){
                        for(ID accId: accountwithParties.get(acc.ID)){
                            if(accMap.get(accID).Overall_Exposure__c!=null)
                                groupExposure+=accMap.get(accID).Overall_Exposure__c;
                        }
                    }
                    if(accountwithGroups.containsKey(acc.ID)){
                        for(ID accId: accountwithGroups.get(acc.ID)){
                            if(accMap.get(accID).Overall_Exposure__c!=null)
                                groupExposure+=accMap.get(accID).Overall_Exposure__c;
                        }
                    }
                }
                accMap.get(acc.id).Group_Exposure__c=groupExposure+accMap.get(acc.id).Overall_Exposure__c;
            }
            System.debug(accMap);
            if(accMap.values().size()>0){
                update accMap.values();
            }
        }catch(Exception ex){
            System.debug(ex.getLineNumber()+'-----------'+ex.getMessage());
        }
    }
    
    //Method to calculate OverallExposure for each Application
    global Decimal calculateOverallExposure(genesis__Applications__c app){
        Decimal overAllExposure = 0.0;
        if(app != null){
            System.debug(app);
            if(!app.Facilities__r.isEmpty()){
                for(Facility__c facility : app.Facilities__r){
                    if(app.RecordType.DeveloperName == 'SME_Renewal' && facility.Existing_Limit__c != null){
                        overAllExposure += facility.Existing_Limit__c;
                    }else if(app.RecordType.DeveloperName=='Term_Loan' && facility.Balance_Outstandings__c!=null){
                        decimal balanceOut    = 0;
                        decimal amtYetDis     = 0;
                        if(facility.Amount_Yet_disbursed__c != null){
                            if(facility.Amount_Yet_disbursed__c < 0)
                                balanceOut = -1 * (facility.Amount_Yet_disbursed__c);
                            else
                                balanceOut = facility.Amount_Yet_disbursed__c;
                        }
                        if(facility.Balance_Outstandings__c!= null){
                           if(facility.Balance_Outstandings__c < 0)
                               amtYetDis     = -1 * (facility.Balance_Outstandings__c);
                           else
                               amtYetDis     = facility.Balance_Outstandings__c;
                        }
                        overAllExposure += balanceOut + amtYetDis;
                    }
                }
            }
            
        }
        
        System.debug(overAllExposure);
        return overAllExposure;
        
    } 
    
    //--finish method
    global void finish(Database.BatchableContext bc)
    {
        
    }
}