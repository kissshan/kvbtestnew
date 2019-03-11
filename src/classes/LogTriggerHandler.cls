/*
*   Name    : LogTriggerHandler
*   Purpose : Handler class for log trigger, jocata listmatching for third party
*   Author  : Bhavya
*/ 

public class LogTriggerHandler { 
    public static Boolean run_ListMatching_Trigger = true;   
    private static LogTriggerHandler instance;
     //Singleton class Method.
    public static LogTriggerHandler getInstance(){
        if(instance==null){
            instance=new LogTriggerHandler();
        }
        return instance;
    }
    
    public static void call_ListMatching(list<clcommon__Log__c> logs){
        List<Id> listIds = new List<Id>();
        for(clcommon__Log__c log : logs){           
            if(log.Class_Name__c == WS_Vendor_Constants.CLASS_CreateApplicationAndAccount && log.Error_Code__c == WS_Vendor_Constants.WS_SUCCESS_CODE){
                listIds.add(log.Application__c);
            }
        }
        listMatching(listIds);
    }
       
    //jocataListMatching       
    public static void listMatching(list<Id> listIds){ 
        if(listIds.size()>0){
            String whereQuery = 'Id ='+'\''+listIds[0]+'\'';
            Database.executeBatch(new Batch_JocataListMatching(whereQuery),1);
        }
        /*JocataListMatching_Model.JocataLMStatusResponse jocataRes;  
        Map<String,JocataListMatching_Model.JocataLMStatusResponse> accIdToReportMap = new Map<String,JocataListMatching_Model.JocataLMStatusResponse>();                                           
        List<genesis__Applications__c> applicationList = new List<genesis__Applications__c>();  //applications for which listmatching should run          
        Map<String,String> custIdTxIdMap = new Map<String,String>(); //For jocata txnId and account Id
        Map<String,String> accIdToPartyIdMap = new Map<String,String>();
        List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();
        List<Account> listAccount = new List<Account>();
                 
        system.debug('listIds-->'+listIds);        
        if(listIds.size()>0){             
            applicationList = [SELECT Id,List_Matching_Stage__c,genesis__CL_Product_Name__c,(Select Id,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CIBIL_Status__pc FROM genesis__Application_Parties__r WHERE genesis__Party_Account_Name__c != null AND Active__c = true),genesis__Account__c,genesis__Account__r.Id,genesis__Account__r.Name,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.PersonBirthdate,genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,
            genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingCountry,genesis__Account__r.Nationality__pc,genesis__Account__r.Driving_License_ID__c,genesis__Account__r.Pan_Number__c,genesis__Account__r.BillingStreet,genesis__Account__r.BillingState,
            genesis__Account__r.BillingCity,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingCountry,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Ration_Card__c,genesis__Account__r.PersonMobilePhone,genesis__Account__r.Phone,genesis__Account__r.PersonEmail,genesis__Account__r.Jocata_TxnId__c FROM genesis__Applications__c WHERE Id IN:listIds];
        }
        
        for(genesis__Applications__c appObj : applicationList){
             custIdTxIdMap = Batch_jocataListMatchingHelper.getJocataTocken(appObj); //store jocata txnId received from jocata
             partyList.addAll(appObj.genesis__Application_Parties__r);
        }
        
                
        for(genesis__Application_Parties__c party : partyList){
            accIdToPartyIdMap.put(party.genesis__Party_Account_Name__c,party.Id);
        }
        system.debug('custIdTxIdMap-->'+custIdTxIdMap);  
        for(String accId : custIdTxIdMap.keyset()){            
            if(custIdTxIdMap.get(accId)!=null){
                jocataRes = new JocataListMatching_Model.JocataLMStatusResponse();
                String accTxnId = custIdTxIdMap.get(accId);
                system.debug('accTxnId-->'+accTxnId); 
                jocataRes = Batch_JocataListMatchStatusHelper.getJocataListMatchingresponse(accTxnId);             
                if(jocataRes != null && jocataRes.responseResult != null){
                    accIdToReportMap.put(accId,jocataRes);
                }              
            }            
        }
        system.debug('jocataRes-->'+jocataRes); 
        if(accIdToReportMap.size() > 0){
            for(String accountId : accIdToReportMap.keySet()){
                insertListMatchings(accIdToReportMap.get(accountId),accountId,accIdToPartyIdMap.get(accountId),custIdTxIdMap.get(accountId));
            }
        }*/
    } 
                  
    public static void insertListMatchings(JocataListMatching_Model.JocataLMStatusResponse jlmRes,String accId,String partyId, String txnId){
        List<Account> updateAccList  = new List<Account>();  
        List<genesis__Application_Parties__c> updatePartyList  = new List<genesis__Application_Parties__c>();  
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
                updateAccList.add(new Account(Id=accId,Jocata_List_Match__c='Yes',Jocata_TxnId__c = txnId));
                updatePartyList.add(new genesis__Application_Parties__c(Id=partyId,Jocata_List_Match__c = 'Yes'));
            }
            else{
                updateAccList.add(new Account(Id=accId,Jocata_List_Match__c='No',Jocata_TxnId__c = txnId));
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