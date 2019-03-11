/*
* Name     : Branch_Ownership_Assignment
* Company  : ET Marlabs
* Purpose  : Batch Class for Ownership Assignment. 
* Author   : Raushan
*/
global class Branch_Ownership_Assignment implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts {
    
    public List<User> userListObject   =   new List<User>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String role ='Branch Manager';
        String query ='SELECT id,Office_Code__c,isActive FROM User WHERE Assignment_Required__c=true AND Role_Name__c =:role';
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC, List<User> listUser) {
        Map<String,Id> userBranchMap                                = new Map<String,Id>();
        List<genesis__Applications__c> applList                     = new List<genesis__Applications__c>();
        List<genesis__Application_Parties__c> partyList             = new List<genesis__Application_Parties__c>();
        List<genesis__Application_Collateral__c> appCollList        = new List<genesis__Application_Collateral__c>();
        List<ints__TransUnion_Credit_Report__c> listTU              = new List<ints__TransUnion_Credit_Report__c>();
        List<Facility__c> facilityList                              = new List<Facility__c>();
        Map<String, Account> idAccMap                               = new Map<String, Account>();
        List<AccountShare> accShareList                             = new List<AccountShare>();     
        try{
            if(listUser != null){
                for(User usr : listUser){
                    if(!userBranchMap.containsKey(usr.Office_Code__c) && usr.isActive){
                        userBranchMap.put(usr.Office_Code__c, usr.id);
                    }
                    userListObject.add(usr);
                   System.debug('usr.Office_Code__c'+usr.Office_Code__c);
                System.debug('usr.isActive'+usr.isActive);
                }
                System.debug('userBranchMap'+userBranchMap);
                
                if(!userBranchMap.isEmpty()){
                    applList = [SELECT Id, OwnerId,Branch_Code__c,genesis__Account__c 
                                FROM genesis__Applications__c 
                                WHERE Branch_Code__c IN : userBranchMap.keySet() 
                                AND Active__c = true];
                 System.debug('applList'+applList);
                }
                if(applList !=null && !applList.isEmpty()){
                    for(genesis__Applications__c  appl: applList ){
                        if(userBranchMap.containsKey(appl.Branch_Code__c)){
                            appl.OwnerId                  = userBranchMap.get(appl.Branch_Code__c);
                            
                            If(appl.genesis__Account__c !=null){
                                Account acc = new Account(Id = appl.genesis__Account__c,OwnerId = userBranchMap.get(appl.Branch_Code__c));
                                idAccMap.put(appl.genesis__Account__c,acc);
                            }
                        }
                    }    
                    
                    partyList = [SELECT Id,OwnerId,Key_Contact__c,genesis__Party_Account_Name__r.OwnerId,genesis__Application__c,Key_Contact__r.OwnerId,genesis__Party_Account_Name__c,genesis__Application__r.Branch_Code__c 
                                 FROM genesis__Application_Parties__c
                                 WHERE genesis__Application__c =:applList 
                                 AND Active__c  = true];
                    
                    if(!partyList.isEmpty()){
                        for(genesis__Application_Parties__c party : partyList){
                            if(userBranchMap.containsKey(party.genesis__Application__r.Branch_Code__c)){
                                party.OwnerId                   = userBranchMap.get(party.genesis__Application__r.Branch_Code__c);
                                //Creating an apex sharing Business customer owner can also see person Account info
                                if(party.genesis__Party_Account_Name__c != null && party.Key_Contact__r.OwnerId != party.genesis__Party_Account_Name__r.OwnerId){
                                    AccountShare accShare           = new AccountShare();
                                    accShare.OpportunityAccessLevel = 'Read';
                                    accShare.AccountAccessLevel     = 'Read';
                                    accShare.AccountId              = party.genesis__Party_Account_Name__c;
                                    accShare.UserOrGroupId          = party.Key_Contact__r.OwnerId;
                                    accShare.RowCause               = Schema.AccountShare.RowCause.Manual;
                                    accShareList.add(accShare);
                                }
                            }
                        }
                    }
                    
                    facilityList = [SELECT Id,OwnerId,Application__c,Application__r.Branch_Code__c,Application__r.genesis__Account__c 
                                    FROM Facility__c 
                                    WHERE Application__c IN :applList];
                    
                    if(!facilityList.isEmpty()){
                        for(Facility__c fac : facilityList){
                            if(userBranchMap.containsKey(fac.Application__r.Branch_Code__c)){
                                fac.OwnerId = userBranchMap.get(fac.Application__r.Branch_Code__c);
                            }
                        }
                    }
                    
                    appCollList = [SELECT Id,OwnerId,Facility__c,Facility__r.OwnerId,Application__c,Application__r.OwnerId,Application__r.Branch_Code__c 
                                   FROM genesis__Application_Collateral__c 
                                   WHERE Application__c IN : applList];
                    
                    if(!appCollList.isEmpty()){
                        for(genesis__Application_Collateral__c applColl : appCollList){
                            if(userBranchMap.containsKey(applColl.Application__r.Branch_Code__c)){
                                applColl.OwnerId = userBranchMap.get(applColl.Application__r.Branch_Code__c);
                            }
                        }
                    }
                    
                    if(!idAccMap.keySet().isEmpty()){
                        listTU  = [SELECT id,OwnerId,Account__r.OwnerId,Account__c 
                                   FROM ints__TransUnion_Credit_Report__c 
                                   WHERE Account__c IN : idAccMap.keySet()];
                        
                        if(!listTU.isEmpty()){
                            for(ints__TransUnion_Credit_Report__c tuObj : listTU){
                                if(idAccMap.containsKey(tuObj.Account__c)){
                                    tuObj.OwnerId    = idAccMap.get(tuObj.Account__c).OwnerId;
                                }    
                            }
                        } 
                    }         
                    
                    SendSMSService.Recusrive = false;
                    ApplicationTriggerHandler.IsFirstRun = false;
                    AccountTriggerHandler.isAccountTrigger = false;
                    
                    if(!idAccMap.isEmpty())UPDATE idAccMap.values();  
                    if(!facilityList.isEmpty())UPDATE facilityList;
                    if(!partyList.isEmpty()) UPDATE partyList;
                    if(!appCollList.isEmpty())UPDATE appCollList;
                    if(!listTU.isEmpty()) UPDATE listTU;
                    if(!applList.isEmpty())UPDATE applList; 
                    if(!accShareList.isEmpty())Database.insert(accShareList,false);
                }
            }
        }catch(Exception e){
            System.debug('Exception '+e.getMessage()+'occured at line number '+e.getLineNumber());
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        for(User userObject :   userListObject){
            userObject.Assignment_Required__c = false; 
        }
        UPDATE userListObject; 
    }
    
}