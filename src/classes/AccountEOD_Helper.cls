/*
* Name      : AccountEOD_Helper
* Company   : ET Marlabs
* Purpose   : Helper class for AccountEODResponse. 
* Author    : Dushyant
*/

public class AccountEOD_Helper {
    public static genesis__Applications__c appObj;
    Public Static genesis__Applications__c enhancementApp;
    Public Static genesis__Applications__c adhocApp;
    Public Static genesis__Applications__c exceddingApp;
    Public Static genesis__Applications__c newLoanApp;
    public static Map<String,Map<String,Boolean>> inActiveFacilityCheckMap;//To Handle Closed Accounts
    public static Map<String,Facility__c> accNumFacMap = new Map<String,Facility__c>();
    public static Set<String> businessCustIdSet = new Set<String>();
    public static Map<String,Set<String>> accNumPartyMap = new Map<String,Set<String>>();// To handle party addition/deletion
    Public Static Map<String,Boolean> appAccNumPartyMap;
    public static Map<String,genesis__Applications__c> custIdAppMap;
    public Static List<String>exsitingColIdList;
    public static Map<String,genesis__Applications__c> getAppDetails(List<AccountEODResponse.cls_ACCOUNT> listAccount){
        inActiveFacilityCheckMap   = new Map<String,Map<String,Boolean>>();
        custIdAppMap = new Map<String,genesis__Applications__c>();
        try{
            Account acc = new Account();
            List<String> custIdList = new List<String>();
            List<genesis__Applications__c> activeApplicationList = new List<genesis__Applications__c>();
            
            for(AccountEODResponse.cls_ACCOUNT  accountWrppObj  :   listAccount){
                custIdList.add(accountWrppObj.customer_id);
                businessCustIdSet.add(accountWrppObj.customer_id);
                for(AccountEODResponse.cls_PARTIES partyObj : accountWrppObj.PARTIES){
                    custIdList.add(partyObj.customer_id);
                }
            }
            System.debug('custIdList::'+custIdList);
            for(genesis__Applications__c app : [SELECT Id,BRE_Done__c,Recordtype.DeveloperName,Active__c,Application_Stage__c,CustomerID__c,Renewal_Due_Date__c,External_Id__c,(select id,Account_Number__c,Active__c,Recommended_Processing_Charge__c,Existing_Processing_Charge__c,Margin__c,Approved_Margin__c,Margin_Receivables__c,Existing_Margin_Receivables__c,Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c,Existing_Margin_Stock_Trading__c from Facilities__r),
                                                (SELECT Id,Active__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c FROM genesis__Application_Parties__r),
                                                (SELECT Id,Name,genesis__Collateral__c,genesis__Collateral__r.clcommon__Collateral_Name__c FROM Application_Collateral__r)
                                                FROM genesis__Applications__c
                                                WHERE CustomerID__c IN : custIdList AND Active__c = true ]){
                                                    if(app.Recordtype.DeveloperName == 'SME_Renewal'){
                                                        Map<String,Boolean> facilityMap = new Map<String,Boolean>();
                                                        custIdAppMap.put(app.CustomerID__c,app);
                                                        If(app.Facilities__r.size() > 0){
                                                            for(Facility__c fac : app.Facilities__r){
                                                                accNumFacMap.put(fac.Account_Number__c,fac);
                                                                facilityMap.put(fac.Account_Number__c,fac.Active__c);
                                                            }
                                                            inActiveFacilityCheckMap.put(app.CustomerID__c,facilityMap);
                                                        }
                                                        if(businessCustIdSet.contains(app.CustomerID__c)){
                                                            System.debug(app.CustomerID__c);
                                                            if(app.genesis__Application_Parties__r.size() >0){
                                                                Set<String> custIdSet = new Set<String>();
                                                                for(genesis__Application_Parties__c party : app.genesis__Application_Parties__r){
                                                                    custIdSet.add(party.genesis__Party_Account_Name__r.CBS_Customer_ID__c);
                                                                    
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
            System.debug('accNumPartyMap::'+accNumPartyMap);
            System.debug('custIdAppMap::'+custIdAppMap);
            System.debug('inActiveFacilityCheckMap::'+inActiveFacilityCheckMap);
            RETURN custIdAppMap;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            RETURN custIdAppMap;
        }
    }
    
    public static void getAppDetailsUpdated(AccountEODResponse.cls_ACCOUNT businessAccDetails){
        String bCustId = businessAccDetails.customer_id;
        List<String> stageListToExclude = new List<String>{'Discontinued Application','New Loan - Application close','Exceeding Application close','Adhoc Application close','Enhancement Application close','Limit Opened','Limit renewed/Application close','New Loan – Application rejected','Application rejected'};
        appAccNumPartyMap = new Map<String,Boolean>();
        for(genesis__Applications__c app : [SELECT Id,BRE_Done__c,Recordtype.DeveloperName,Active__c,Application_Stage__c,CustomerID__c,Renewal_Due_Date__c,External_Id__c,(select id,Account_Number__c,Active__c,Recommended_Processing_Charge__c,Existing_Processing_Charge__c,Margin__c,Approved_Margin__c,Margin_Receivables__c,Existing_Margin_Receivables__c,Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c,Existing_Margin_Stock_Trading__c from Facilities__r),
                                            (SELECT Id,Active__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c FROM genesis__Application_Parties__r),
                                            (SELECT Id,Name,genesis__Collateral__c,genesis__Collateral__r.clcommon__Collateral_Name__c FROM Application_Collateral__r)
                                            FROM genesis__Applications__c
                                            WHERE CustomerID__c  =: bCustId AND Active__c = true ]){
                                                if(app.Recordtype.DeveloperName == 'SME_Renewal'){
                                                    exsitingColIdList = new List<String>();
                                                    appObj = app;
                                                    
                                                    for(genesis__Application_Collateral__c appColl : app.Application_Collateral__r){
                                                        exsitingColIdList.add(appColl.genesis__Collateral__r.clcommon__Collateral_Name__c);
                                                    }
                                                    System.debug(app.CustomerID__c);
                                                    if(app.genesis__Application_Parties__r.size() >0){
                                                        Set<String> custIdSet = new Set<String>();
                                                        for(genesis__Application_Parties__c party : app.genesis__Application_Parties__r){
                                                            custIdSet.add(party.genesis__Party_Account_Name__r.CBS_Customer_ID__c);
                                                            appAccNumPartyMap.put(party.genesis__Party_Account_Name__r.CBS_Customer_ID__c,party.Active__c);
                                                            system.debug('appAccNumPartyMap'+appAccNumPartyMap);
                                                        }
                                                    }
                                                    
                                                }else if(app.Recordtype.DeveloperName == 'SME_Exceeding' && !stageListToExclude.contains(app.Application_Stage__c)){
                                                    exceddingApp = app;
                                                }else if(app.Recordtype.DeveloperName == 'SME_AdHoc' && !stageListToExclude.contains(app.Application_Stage__c)){
                                                    AdhocApp = app;
                                                }else if(app.Recordtype.DeveloperName == 'SME_Enhancement' && !stageListToExclude.contains(app.Application_Stage__c)){
                                                    enhancementApp = app;
                                                }else if(app.Recordtype.DeveloperName == 'SME_NEW_Loan' && !stageListToExclude.contains(app.Application_Stage__c)){
                                                    newLoanApp = app;
                                                }
                                            }
    }
    public static void ownershipAssignment(Set<String> branchCodeSet){
        try{
            List<User> userList = new List<User>();
            String role ='Branch Manager';
            userList = [SELECT Id FROM User WHERE Office_Code__c IN : branchCodeSet AND Role_Name__c =:role AND isActive = true];
            for(User ur : userList){
                ur.Assignment_Required__c = true;
            }
            UPDATE userList;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    
    @future
    public static void checkLimitValue(Set<String> custIdSet){
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        appList = [SELECT Id,Application_Stage__c,(SELECT Id,Existing_Limit__c FROM Facilities__r) FROM genesis__Applications__c WHERE RecordType.DeveloperName = 'SME_Renewal' AND Active__c = true AND CustomerID__c IN:custIdSet]; 
        List<genesis__Applications__c> appToUpdate = new List<genesis__Applications__c>();
        for(genesis__Applications__c app: appList){
            if(!app.Facilities__r.isEmpty()){
                Decimal totalLimit = 0;
                for(Facility__c fac : app.Facilities__r){
                    if(fac.Existing_Limit__c != null) totalLimit += fac.Existing_Limit__c;
                }
                if(totalLimit > 20000000){
                    appToUpdate.add(new genesis__Applications__c(Id = app.Id,Application_Stage__c = 'Greater than 2Cr.'));
                }
            }
        }
        if(!appToUpdate.isEmpty()){
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE appToUpdate;
        }
    }
    //Reset Applications On Party/Collateral Addition/Deletion
    public static void resetApplication(Map<String,Boolean> partyIdMap,Map<String,Boolean> colIdMap){
        try{
            Boolean additionPartyFlag   = false;
            Boolean deletationPartyFlag = false;
            Boolean additionalColFlag = false;
            Boolean deletationColFlag = false;
            Map<String,Id> nameIdEAEMap = new map<String,Id>();
            List<String> availabelOtherAppTypeList = new List<String>();
            List<String> availabelOtherAppIdList   = new List<String>();
            Set<String> addedPartiesSet = new Set<String>();
            Set<String> deletedPartiesSet = new Set<String>();
            Set<String> addedCollSet = new Set<String>();
            Set<String> deletedCollSet = new Set<String>();
            List<Attachment> attListToDelete = new List<Attachment>();
            List<Attachment> renewalAttList = new List<Attachment>();
            List<Attachment> EAEAttList = new List<Attachment>();
            
            List<genesis__Application_Collateral__c> appCollToInsert = new List<genesis__Application_Collateral__c>();
            List<genesis__Application_Collateral__c> appCollToDelete = new List<genesis__Application_Collateral__c>();
            List<genesis__Application_Parties__c> partyListToInsert = new List<genesis__Application_Parties__c>();
            List<genesis__Application_Parties__c> partyListToDeactivate = new List<genesis__Application_Parties__c>();
            
            if(partyIdMap.size() > 0){
                for(String custId : partyIdMap.Keyset()){
                    if((AccountEOD_Helper.appAccNumPartyMap.containskey(custId))){
                        if(partyIdMap.get(custId) != AccountEOD_Helper.appAccNumPartyMap.get(custId) && AccountEOD_Helper.appAccNumPartyMap.get(custId) == true){
                            deletationPartyFlag = true;
                            deletedPartiesSet.add(custId);
                        }else if(partyIdMap.get(custId) != AccountEOD_Helper.appAccNumPartyMap.get(custId) && AccountEOD_Helper.appAccNumPartyMap.get(custId) == false){
                            additionPartyFlag = true;
                            addedPartiesSet.add(custId);
                        }
                    }
                    else if((!AccountEOD_Helper.appAccNumPartyMap.containskey(custId))){
                        additionPartyFlag = true;
                        addedPartiesSet.add(custId);
                    }
                }
            }
            if(colIdMap.size() > 0){
                for(String collId : colIdMap.keySet()){
                    if(!exsitingColIdList.contains(collId)){
                        addedCollSet.add(collId);
                        additionalColFlag = true;
                    }else if(exsitingColIdList.contains(collId)){
                        if(!colIdMap.get(collId)){
                            deletedCollSet.add(collId);
                            deletationColFlag = true;
                        }
                    }
                }
            }
            
            if(enhancementApp != null){
                nameIdEAEMap.put('SME_Enhancement',enhancementApp.Id);
            }
            if(adhocApp != null){
                nameIdEAEMap.put('SME_AdHoc',AdhocApp.Id);
            }
            if(exceddingApp != null){
                nameIdEAEMap.put('SME_Exceeding',ExceddingApp.Id);
            }
            if(newLoanApp != null){
                nameIdEAEMap.put('SME_NEW_Loan',newLoanApp.Id);
            }
            
            EAEAttList = [SELECT Id FROM Attachment WHERE ParentId IN : nameIdEAEMap.values()];
            renewalAttList = [SELECT Id FROM Attachment WHERE ParentId =: appObj.Id];
            if(EAEAttList.size() > 0)
                attListToDelete.addAll(EAEAttList);
            if(renewalAttList.size() > 0)
                attListToDelete.addAll(renewalAttList);
            //if(attListToDelete.size() > 0)
            //DELETE attListToDelete;
            //Cloning and deletion of Party
            System.debug(additionalColFlag+':::'+addedCollSet);
            if(additionalColFlag && addedCollSet.size() > 0){
                List<genesis__Application_Collateral__c> existingCollList = new List<genesis__Application_Collateral__c>();
                List<genesis__Application_Collateral__c> clonedCollList = new List<genesis__Application_Collateral__c>();
                existingCollList = [SELECT Id,Facility__c,genesis__Collateral__c,Security_Type__c FROM genesis__Application_Collateral__c WHERE genesis__Collateral__r.clcommon__Collateral_Name__c IN : addedCollSet AND Application__c = : appObj.Id];
                clonedCollList = existingCollList.deepClone();
                for(Id appEAEID : nameIdEAEMap.values()){
                    for(genesis__Application_Collateral__c coll : clonedCollList){
                        coll.Application__c = appEAEID;
                        appCollToInsert.add(coll);
                    }
                }
                if(appCollToInsert.size() > 0){
                    INSERT appCollToInsert;
                    
                }
                
            }
            if(deletationColFlag && deletedCollSet.size() > 0){
                System.debug(nameIdEAEMap);
                System.debug(deletedCollSet);
                appCollToDelete = [SELECT Id FROM genesis__Application_Collateral__c WHERE Application__c IN : nameIdEAEMap.values() AND genesis__Collateral__r.clcommon__Collateral_Name__c IN :deletedCollSet];
                DELETE appCollToDelete;
            }
            
            //Cloning and deletion of Collateral
            if(additionPartyFlag && addedPartiesSet.size() > 0){
                List<genesis__Application_Parties__c> existingPartyList = new List<genesis__Application_Parties__c>();
                List<genesis__Application_Parties__c> clonedPartyList = new List<genesis__Application_Parties__c>();
                existingPartyList = [SELECT Id,genesis__Party_Account_Name__c,Key_Contact__c,Party_Email__c,genesis__Party_Type__c FROM genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.CBS_Customer_ID__c IN : addedPartiesSet AND genesis__Application__c = : appObj.Id];
                clonedPartyList = existingPartyList.deepClone();
                for(Id appEAEID : nameIdEAEMap.values()){
                    for(genesis__Application_Parties__c party : clonedPartyList){
                        party.genesis__Application__c = appEAEID;
                        partyListToInsert.add(party);
                    }
                }
                if(partyListToInsert.size() > 0)
                    INSERT partyListToInsert;
            }
            if(deletationPartyFlag && deletedPartiesSet.size() > 0){
                partyListToDeactivate = [SELECT Id,Active__c FROM genesis__Application_Parties__c WHERE genesis__Application__c IN : nameIdEAEMap.values() AND genesis__Party_Account_Name__r.CBS_Customer_ID__c IN : deletedPartiesSet];
                if(partyListToDeactivate.size() > 0){
                    for(genesis__Application_Parties__c party : partyListToDeactivate){
                        party.Active__c = false;
                    }
                    UPDATE partyListToDeactivate;
                }
            }
            if(additionPartyFlag || deletationPartyFlag){
                if(additionPartyFlag)
                    resetAppStage(appObj.Id,nameIdEAEMap,'partyAdded',addedPartiesSet);
                if(deletationPartyFlag)
                    resetAppStage(appObj.Id,nameIdEAEMap,'partyDeleted',deletedPartiesSet);
            }
            else if(additionalColFlag || deletationColFlag){
                resetAppStage(appObj.Id,nameIdEAEMap,'CollAddedDeleted',new Set<String>());
            }
            
        }catch(Exception e){
            HandleBusinessException.captureError('AccountEODResponse_Handler','updateApplicationStageByParties',e);
        }
    }
    
    @future(callOut = true)
    public static void resetAppStage(String appId,Map<String,Id> nameIdEAEMap, String changeReason,Set<String> personAccIds){
        System.debug(appId);
        System.debug(changeReason);
        System.debug(nameIdEAEMap);
        System.debug(personAccIds);
        Boolean addedPartyCibilRun = false;
        List<genesis__Applications__c> appEAEList = new List<genesis__Applications__c>();
        List<Account> pAccList = new List<Account>();
        List<Task> taskToCloseList = new List<Task>();
        System.debug('changeReason:::'+changeReason);
        
        if(changeReason == 'partyAdded'){
            addedPartyCibilRun = true;
            try{
                system.debug('personAccIds'+personAccIds);
                pAccList = [Select id,FirstName,name,LastName,MiddleName,Gender__pc,PersonBirthdate,Aadhaar_Number__pc,Pan_Number__c,PersonMobilePhone,PersonMailingStreet,PersonMailingCity,Full_Name__c,PersonMailingPostalCode,PersonMailingState from Account where CBS_Customer_ID__c  IN : personAccIds AND CIBIL_Status__pc != 'Complete' AND RecordType.DeveloperName = 'PersonAccount'];
                system.debug('pAccList:::'+pAccList.size());
                for(Account pAcc : pAccList){
                    Database.BatchableContext BC;
                    List<Account> pAccForCibilRun = new List<Account>();
                    pAccForCibilRun.add(pAcc);
                    Person_CIBIL_Call pCibilBatchObj = new Person_CIBIL_Call('');
                    pCibilBatchObj.execute(BC,pAccForCibilRun);
                    if(pCibilBatchObj.cibilRes.Result == false)
                        addedPartyCibilRun = false;
                }
            }
            catch(Exception e){
                System.debug(e.getMessage());
                System.debug(e.getStackTraceString());
                addedPartyCibilRun = false;
            }
        }
        else if(changeReason == 'partyDeleted')
            addedPartyCibilRun = true;
        
        for(String typeEAE : nameIdEAEMap.keySet()){
            if(typeEAE == 'SME_Exceeding')
                appEAEList.add(updateApplication(nameIdEAEMap.get(typeEAE),'Exceeding- Application submitted'));
            if(typeEAE == 'SME_Enhancement')
                appEAEList.add(updateApplication(nameIdEAEMap.get(typeEAE),'Enhancement- Application submitted'));
            if(typeEAE == 'SME_AdHoc')
                appEAEList.add(updateApplication(nameIdEAEMap.get(typeEAE),'Adhoc- Application submitted'));
            if(typeEAE == 'SME_NEW_Loan')
                appEAEList.add(updateApplication(nameIdEAEMap.get(typeEAE),'New loans- Application submitted'));
            
            //Close Existing Tasks
            taskToCloseList.addAll(closeAllExistingTask(nameIdEAEMap.get(typeEAE)));
            //Run BRE && Sanction Auth
            if(changeReason == 'CollAddedDeleted' || addedPartyCibilRun){
                Button_Utility.runBRE(nameIdEAEMap.get(typeEAE));
                SanctionMatrix_Helper.reRunSactionAuth(nameIdEAEMap.get(typeEAE));
            }
        }
        
        //Update renewal application
        appEAEList.add(updateApplication(appId,'Identified for renewal'));
        if(appEAEList.size() > 0){
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE appEAEList;
        }
        taskToCloseList.addAll(closeAllExistingTask(appId));
        if(taskToCloseList.size() > 0)
            UPDATE taskToCloseList;
    }
    public static genesis__Applications__c updateApplication(String appId,String appStage){
        genesis__Applications__c app = new genesis__Applications__c(Id = appId);
        app.Application_Stage__c = appStage;
        app.Application_UI_Stage__c = 'NA';
        app.Sub_Stage__c = '';
        app.Deviation_Reason__c = '';
        app.Sanction_Date__c = null;
        app.Next_Renewal_Date__c = null;
        app.Sanction_Class2_Check__c = false;
        app.Sanction_Doc_Generation_Check__c = false;
        app.Sanction_Letter_Name__c = null;
        app.Sanction_ESign_Check__c = false;
        app.CBS_API_Sequence__c = '12';
        app.BM_Declaration__c = false;
        app.Processing_Charges__c = null;
        app.genesis__Status__c = '';
        app.Qualitative_input_done__c = false;
        app.Sanction_Authority__c = null;
        app.Nature_of_product_manufactured_traded__c = null;
        app.Succession_plan__c = null;
        app.Management_experience__c = null;
        app.Selling_and_distribution_arrangement__c = null;
        app.External_certfications__c = null;
        app.Government_policies__c = null;
        app.Industry_outlook__c = null;
        app.CA_with_other_banks__c = null;
        app.Court_cases_non_credit_related__c = null;
        app.Competition__c = null;
        app.Security_Description__c = null;
        app.Overall_Exposure__c = null;
        app.Security_coverage__c = null;
        app.Cersai_Charges__c = null;
        app.Processing_Charges__c = null;
        app.Legal_Charges__c = null;
        app.Valuation_Charges__c = null;
        app.Cibil_Charges__c = null;
        app.genesis__Loan_Amount__c = null;
        app.genesis__Days_Convention__c = null;
        app.Current_ratio__c = null;
        app.Working_capital_turnover_ratio__c = null;
        app.Interest_service_coverage_ratio__c = null;
        app.Average_limit_utilization__c = null;
        app.Delay_in_servicing_of_working_cap_int__c = null;
        app.Credit_summation_compared_to_previous_yr__c = null;
        app.Inward_cheque_return__c = null;
        app.No_of_years_of_operation__c = null;
        app.CIBIL_score__c = null;
        app.Credit_summation_to_average_availment__c = null;
        app.OD_limit_creation_updation__c = false;
        app.Charge_collection_done__c = false;
        app.BRE_Done__c = false;
        
        //UPDATE app;
        RETURN app;
    }
    public Static List<Task> closeAllExistingTask(String appId){
        List<Task> taskToCloseList = new List<Task>();
        taskToCloseList = [select id,status from task where Whatid =: appId AND status != 'Completed' AND Type NOT IN ('M121 A Needed','Takeover Intelligence')];
        for(Task taskObj : taskToCloseList){
            taskObj.Status = 'Completed';
        }
        RETURN taskToCloseList;
    }
    
    @future(callOut = true)
    public Static void changeParentIdOnEnhancNewLoanApp(String appId){
        String activeRenewalApp;
        List<genesis__Applications__c> EAE_AppToUpdate = new List<genesis__Applications__c>();
        String accId = [SELECT id, name, genesis__Account__c FROM genesis__Applications__c WHERE id =: appId LIMIT 1].genesis__Account__c;
        Account parentAccObj =[SELECT id, name, (SELECT id, name,Parent_Application__c,recordtype.developername FROM genesis__Applications_account__r WHERE active__c = true) FROM account WHERE id =: accId];
        if(parentAccObj != null){
            for(genesis__Applications__c app : parentAccObj.genesis__Applications_account__r){
                if(app.recordtype.developername == 'SME_Renewal'){
                    activeRenewalApp = app.Id;
                }
            }
            for(genesis__Applications__c app : parentAccObj.genesis__Applications_account__r){
                if(app.recordtype.developername == 'SME_Enhancement' || app.recordtype.developername == 'SME_NEW_Loan'){
                    app.Parent_Application__c = activeRenewalApp;
                    EAE_AppToUpdate.add(app);
                }
            }
            if(EAE_AppToUpdate.size()>0){
                ApplicationTriggerHandler.IsFirstRun = false;
                UPDATE EAE_AppToUpdate;
            }
        }
    }
}