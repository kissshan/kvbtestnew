/*
*   Name    : Batch_JocataListMatchStatus
*   purpose : Get the status from Jocata List Matching
*   Author  : Numaan
*/ 
public class Batch_JocataListMatchStatus implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts {
    String query;
    static Set<String>  setObject           = new Set<String>{'Sent'};
    public static List<Account> updateAccList  = new List<Account>();  
    public static List<genesis__Application_Parties__c> updatePartyList  = new List<genesis__Application_Parties__c>();  
    Static Set<String> APP_STAGES           = new Set<String>{Constants.APPLN_INITIATED,Constants.Enhancement_App_Submitted,Constants.Exceeding_App_Submitted,Constants.Adhoc_App_Submitted,Constants.New_Loan_Submitted,Constants.APPLICATION_REVIEW_CRITICAL_CHANGE};  
    static String LIST_MATCHING_STAGE       = 'Completed';
    string whereCondition                   = '';
    
    string SME_APP_RECORD_TYPE              = 'SME_Renewal';
    string SME_APP_RECORD_TYPE_EXCEEDING    = 'SME_Exceeding';
    string SME_APP_RECORD_TYPE_ADHOC        = 'SME_AdHoc';
    string SME_APP_RECORD_TYPE_ENHANCEMENT  = 'SME_Enhancement';
    string SME_NEW_LOAN_RECORD_TYPE         = 'SME_NEW_Loan';
           
    public Batch_JocataListMatchStatus(string whereQuery){
        whereCondition    = whereQuery;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {  
        Integer days    = Utility.getExecuteBatch();      
        
         if(whereCondition == '' || whereCondition == null){
            whereCondition = '((RecordType.DeveloperName =: SME_APP_RECORD_TYPE AND Application_Stage__c IN:APP_STAGES AND Execute_batch_in_days__c <=:days) OR (RecordType.DeveloperName =: SME_APP_RECORD_TYPE_EXCEEDING AND Application_Stage__c IN : APP_STAGES) OR (RecordType.DeveloperName =: SME_APP_RECORD_TYPE_ADHOC AND Application_Stage__c IN : APP_STAGES) OR (RecordType.DeveloperName =: SME_APP_RECORD_TYPE_ENHANCEMENT AND Application_Stage__c IN : APP_STAGES) OR (RecordType.DeveloperName =: SME_NEW_LOAN_RECORD_TYPE AND Application_Stage__c IN : APP_STAGES)) AND List_Matching_Stage__c IN:setObject AND genesis__Account__r.Jocata_TxnId__c != null AND Active__c = true';
        }
        
        query = 'SELECT Id,BRE_Done__c,genesis__Account__c,genesis__Account__r.Jocata_TxnId__c,(SELECT Id,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Jocata_TxnId__c FROM genesis__Application_Parties__r WHERE genesis__Party_Account_Name__c != null AND Active__c = true),RecordType.DeveloperName FROM genesis__Applications__c where ' + whereCondition ;
        System.debug('Query@@@@ '+query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> records) {
        List<genesis__Applications__c> apptoUpdate  = new List<genesis__Applications__c>();
        updateAccList                               = new List<Account>();        
        Map<String,String> accIdToTxnIdMap = new Map<String,String>();
        Map<String,String> accIdToPartyIdMap = new Map<String,String>();
        Map<String,JocataListMatching_Model.JocataLMStatusResponse> accIdToReportMap = new Map<String,JocataListMatching_Model.JocataLMStatusResponse>();
        JocataListMatching_Model.JocataLMStatusResponse jocataRes;
        Boolean checkIfReport = true;

        for(genesis__Applications__c app : records){
            accIdToTxnIdMap.put(app.genesis__Account__c,app.genesis__Account__r.Jocata_TxnId__c);
            checkIfReport = true;
        }
        
        for(genesis__Application_Parties__c party : records[0].genesis__Application_Parties__r){
            accIdToTxnIdMap.put(party.genesis__Party_Account_Name__c,party.genesis__Party_Account_Name__r.Jocata_TxnId__c);
            accIdToPartyIdMap.put(party.genesis__Party_Account_Name__c,party.Id);
            checkIfReport = true;
        }
       
        for(String accId : accIdToTxnIdMap.keySet()){
            jocataRes = new JocataListMatching_Model.JocataLMStatusResponse();
            jocataRes = Batch_JocataListMatchStatusHelper.getJocataListMatchingresponse(accIdToTxnIdMap.get(accId));
            if(jocataRes != null && jocataRes.responseResult != null){
                accIdToReportMap.put(accId,jocataRes);
            }
            else checkIfReport = false;
        }

        if(accIdToReportMap.size() > 0){
            for(String accountId : accIdToReportMap.keySet()){
                insertListMatchings(accIdToReportMap.get(accountId),accountId,accIdToPartyIdMap.get(accountId));
            }
        }
        
        genesis__Applications__c appObj = new genesis__Applications__c();
        appObj.Id = records[0].Id;
        if(checkIfReport){
            appObj.List_Matching_Stage__c ='Completed';
            appObj.List_Matching_Status__c = false;
        }
        apptoUpdate.add(appObj);

       
        if(! apptoUpdate.isEmpty()){
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE apptoUpdate;
            if(!records[0].BRE_Done__c && records[0].RecordType.developerName != 'SME_Renewal' && records[0].RecordType.developerName != 'LAP'){
                SME_BRE_Score_Calculator.runBRERule(apptoUpdate[0],false);
            }
        }
        
        ///}

       /* if(! custIdSet.isEmpty()){
            updateAccList = [SELECT Id FROM Account WHERE Id IN : custIdSet];
        }

        if(! updateAccList.isEmpty()){
            AccountTriggerHandler.isAccountTrigger  = true;
            UPDATE updateAccList;
        }*/

        /*for(genesis__Applications__c app : records){
            //System.debug(app.genesis__Account__c+'==='+app.genesis__Account__r.Jocata_TxnId__c+'=='+app.genesis__Account__r.Name);
           JocataListMatching_Model.JocataLMStatusResponse jocataRes= Batch_JocataListMatchStatusHelper.getJocataListMatchingresponse(app.genesis__Account__r.Jocata_TxnId__c);  
            System.debug('@@@@'+jocataRes);
            if(jocataRes != null){                
                insertListMatchings(jocataRes,app.genesis__Account__c);
                apptoUpdate.add(new genesis__Applications__c(Id=app.Id,List_Matching_Stage__c ='Completed',List_Matching_Status__c = false,RecordTypeId = app.RecordTypeId));
            }
        }*/
        
       /* if(apptoUpdate.size() > 0){
            ApplicationTriggerHandler.IsFirstRun = false;
            update apptoUpdate;
            system.debug(apptoUpdate.size()+':::'+apptoUpdate[0].id+':::'+apptoUpdate[0].RecordType.developerName);
            System.debug(records[0].RecordType.DeveloperName);
            if(!records[0].BRE_Done__c && records[0].RecordType.developerName != 'SME_Renewal'){
                SME_BRE_Score_Calculator.runBRERule(apptoUpdate[0],false);
            }
        }*/
        /*if(updateAccList.size() > 0){
            AccountTriggerHandler.isAccountTrigger  = true;
            update updateAccList;
        }*/
    }
    
    public void finish(Database.BatchableContext BC) {       
        
    }
    
    public void insertListMatchings(JocataListMatching_Model.JocataLMStatusResponse jlmRes,String accId,String partyId){
        
        try{
            List_Matching__c listMatch = new List_Matching__c();
            listMatch.Account__c = accId;
            System.debug('Match Flag::: ' + jlmRes.responseResult.matchFlag);
            listMatch.Match_Flag__c = jlmRes.responseResult.matchFlag;
            If(jlmRes.responseResult.searchedDate != null)listMatch.Searched_Date__c = jlmRes.responseResult.searchedDate;
            If(!Utility.ISStringBlankorNull(jlmRes.responseResult.searchedFor))listMatch.Searched_For__c = jlmRes.responseResult.searchedFor;
            If(!Utility.ISStringBlankorNull(jlmRes.responseResult.uniqueRequestId))listMatch.Unique_Request_Id__c = jlmRes.responseResult.uniqueRequestId;
            
            insert listMatch;
            
            if(listMatch.Match_Flag__c){
                updateAccList.add(new Account(Id=accId,Jocata_List_Match__c='Yes'));
                updatePartyList.add(new genesis__Application_Parties__c(Id=partyId,Jocata_List_Match__c = 'Yes'));
            }
            else{
                updateAccList.add(new Account(Id=accId,Jocata_List_Match__c='No'));
                updatePartyList.add(new genesis__Application_Parties__c(Id=partyId,Jocata_List_Match__c = 'No'));
            }
            AccountTriggerHandler.isAccountTrigger  = true;
            UPDATE updateAccList;
            UPDATE updatePartyList;
            
            List<Sobject> sobjInsert = new List<Sobject>();        
            if(jlmRes.responseResult.responseVOList.size() > 0){
                Integer i=0;
                for(JocataListMatching_Model.cls_responseVOList jc:jlmRes.responseResult.responseVOList){
                    String externalId = listMatch.Unique_Request_Id__c+'_'+i;
                    clcommon__Bank_Account__c cb = new clcommon__Bank_Account__c();
                    If(!Utility.ISStringBlankorNull(jc.country)) cb.Country__c = jc.country;
                    If(!Utility.ISStringBlankorNull(jc.din)) cb.Country__c = jc.country;cb.Din__c = jc.din;
                    If(!Utility.ISStringBlankorNull(jc.cin)) cb.Country__c = jc.country;cb.Cin__c = jc.cin;
                    If(!Utility.ISStringBlankorNull(jc.primaryName)) cb.Country__c = jc.country;cb.Primary_Name__c = jc.primaryName;
                    If(!Utility.ISStringBlankorNull(jc.phoneNo))cb.Phone_No__c = jc.phoneNo;
                    If(jc.entryId != null)cb.Entry_Id__c = jc.entryId;
                    If(!Utility.ISStringBlankorNull(jc.score))cb.Score__c = jc.score;
                    If(!Utility.ISStringBlankorNull(jc.passport))cb.Passport__c = jc.passport;
                    If(!Utility.ISStringBlankorNull(jc.dob))cb.Dob__c = jc.dob;
                    If(!Utility.ISStringBlankorNull(jc.customerId))cb.Customer_Id__c = jc.customerId;
                    If(!Utility.ISStringBlankorNull(jc.voterId))cb.Voter_Id__c = jc.voterId;
                    If(!Utility.ISStringBlankorNull(jc.alias))cb.Alias__c = jc.alias;
                    If(!Utility.ISStringBlankorNull(jc.uidai))cb.Uidai__c = jc.uidai;
                    If(!Utility.ISStringBlankorNull(jc.listName))cb.List_Name__c = jc.listName;
                    If(!Utility.ISStringBlankorNull(jc.pan))cb.Pan__c = jc.pan;
                    If(!Utility.ISStringBlankorNull(jc.tinVat))cb.Tin_Vat__c = jc.tinVat;
                    
                    If(!Utility.ISStringBlankorNull(jc.targetData.OtherBank))cb.Other_Bank__c = jc.targetData.OtherBank;
                    If(!Utility.ISStringBlankorNull(jc.targetData.EntityName))cb.Entity_Name__c = jc.targetData.EntityName;
                    If(!Utility.ISStringBlankorNull(jc.targetData.Address))cb.Address__c = jc.targetData.Address;
                    If(!Utility.ISStringBlankorNull(jc.targetData.State))cb.State__c = jc.targetData.State;
                    If(!Utility.ISStringBlankorNull(jc.targetData.BKBR))cb.BKBR__c = jc.targetData.BKBR;
                    If(!Utility.ISStringBlankorNull(jc.targetData.BKNM))cb.clcommon__Bank_Account_Name__c = jc.targetData.BKNM;
                    If(!Utility.ISStringBlankorNull(jc.targetData.DirectorNames))cb.Director_Names__c = jc.targetData.DirectorNames;
                    
                    cb.List_Matching__c = listMatch.Id;
                    cb.External_Id__c = externalId;
                    sobjInsert.add(cb);
                    if(jc.fields.size() > 0){
                        
                        for(JocataListMatching_Model.cls_fields fc:jc.fields){
                            clcommon__Notification__c cln = new clcommon__Notification__c();
                            If(!Utility.ISStringBlankorNull(fc.targetData))cln.Target_Data__c = fc.targetData;
                            If(!Utility.ISStringBlankorNull(fc.sourceData))cln.Source_Data__c = fc.sourceData;
                            If(!Utility.ISStringBlankorNull(fc.matchedField))cln.Matched_Field__c = fc.matchedField;
                            cln.Bank_Account__r = new clcommon__Bank_Account__c(External_Id__c=externalId);
                            sobjInsert.add(cln);
                        }
                    }
                    i++;
                } 
            }
            if(!sobjInsert.isEmpty()){            
                insert sobjInsert;
            }
        
        }catch(Exception ex){
            system.debug('Exception in saving List Matching Status:'+ex.getMessage());
        }
        
    }
}