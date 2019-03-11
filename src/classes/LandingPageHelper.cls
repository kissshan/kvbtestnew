/*
* Name          : LandingPageHelper
* Description   : Helper class for WS_LandingPage, prepares response structure.
* Author        : Dushyant
*/
public class LandingPageHelper {
    public static String SME_appId = '';
    public static Object landingPageRes(String custId, Boolean landingReqFlag){//WS_LandingPage.Response
        
        // Added By Ajeet
        List<Facility__c> facilityList              = new List<Facility__c>();
        List<Facility__c> loanFacilityList          = new List<Facility__c>();
        Set<Id> accIdList                           = new Set<Id>();
        String applicationId                        = '';
        System.debug('custId::'+custId);
        WS_LandingPage.Response res = new WS_LandingPage.Response();
        Boolean facDetailPrepared = false;
        System.debug('custId::'+custId);
        
        try{
            System.debug('custId::'+custId);
            List<String> closeStageList = new List<String>{'Limit renewed/Application close','Application close - enhancement','Enhancement Application close','Exceeding Application close','Adhoc Application close'};
                List<String> appRecordTypeList = new List<String>{'SME_AdHoc','SME_Enhancement','SME_Exceeding','SME_Renewal','SME_NEW_Loan','Term_Loan'};
                    List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
            List<WS_LandingPage.AppDetails> appDetList = new List<WS_LandingPage.AppDetails>();
            appList =[SELECT Id,genesis__Account__c,Processing_Fee_Result__c,Net_Banking_Flag__c,Type__c,genesis__Account__r.PersonBirthdate,genesis__Account__r.Jocata_TxnId__c,Name,Recordtype.DeveloperName,genesis__Loan_Amount__c,Application_Stage__c,RecordType.Name,Sub_Stage__c,Application_UI_Stage__c,Renewal_Due_Date__c,
                      Active__c,(SELECT Existing_Limit__c,Existing_Rate__c,CL_Product__r.Product_Code__c,CL_Product__r.Name,Account_Number__c,Balance_Outstandings__c FROM Facilities__r WHERE RecordType.DeveloperName = 'Parent')
                      FROM genesis__Applications__c WHERE genesis__Account__r.CBS_Customer_ID__c =: custId AND RecordType.DeveloperName IN :appRecordTypeList AND Application_Stage__c NOT IN :closeStageList AND (Active__c=true OR RecordType.DeveloperName='Term_Loan')];
            if(!appList.isEmpty()){
                String greaterThreeMonthapp = '';
                for(genesis__Applications__c app : appList){
                    
                    accIdList.add(app.genesis__Account__c);
                    Decimal existingLimitTotal = 0.0;
                    WS_LandingPage.AppDetails appDet = new WS_LandingPage.AppDetails();
                    appDet.app_los_id = app.Id;
                    appDet.app_type = app.RecordType.DeveloperName;
                    appDet.app_stage = app.Application_Stage__c != null ? app.Application_Stage__c : '';
                    appDet.app_sub_stage = app.Sub_Stage__c != null ? app.Sub_Stage__c : '';
                    appDet.app_ui_stage = app.Application_UI_Stage__c != null ? app.Application_UI_Stage__c : '';
                    appDet.app_due_date = app.Renewal_Due_Date__c != null ? app.Renewal_Due_Date__c.format() : '';
                    appDet.app_name = app.Name;
                    appDet.LOS_SF_RECORD_ID = app.genesis__Account__c;
                    appDet.app_total_amount = app.genesis__Loan_Amount__c != null ? String.valueOf(app.genesis__Loan_Amount__c) : '';

                    appDet.NET_BANKING_FLAG = app.Net_Banking_Flag__c != null ? (app.Net_Banking_Flag__c== true? 'True': 'False') : '';
                    appDet.PROCESSING_FEE_RESULT = app.Processing_Fee_Result__c != null ? app.Processing_Fee_Result__c : '';

                    //appDet.Type    = 
                    if(app.Recordtype.DeveloperName == 'SME_Enhancement' || app.Recordtype.DeveloperName == 'SME_Exceeding' || app.Recordtype.DeveloperName == 'SME_AdHoc'){
                        appDet.Type = app.Type__c != null ? app.Type__c : '';
                    }
                    if(app.Recordtype.DeveloperName == 'SME_NEW_Loan'){
                        appDet.Type = app.Type__c != null ? app.Type__c : '';
                    }
                    if(app.Recordtype.DeveloperName == 'Term_Loan'){
                        appDet.Type = app.Type__c != null ? app.Type__c : '';
                    }
                    
                    if(app.Recordtype.DeveloperName == 'SME_Renewal' ){
                        appDet.Type = app.Type__c != null ? app.Type__c : '';
                        if(!closeStageList.contains(app.Application_Stage__c)){
                            if(!app.Facilities__r.isEmpty()){
                                applicationId = app.Id;
                                facDetailPrepared = true;
                                
                                //res.landing_info.facility_info = getFacilityInfo(app.Facilities__r);
                                if(landingReqFlag){
                                    If(app.Renewal_Due_Date__c < (System.today().addDays(90))){
                                        RETURN app.Id;  
                                    }else{
                                        greaterThreeMonthapp = app.Id;
                                    }
                                } 
                            }
                        }
                    }
                    If(app.Recordtype.DeveloperName == 'SME_Enhancement' && landingReqFlag){
                        RETURN app.Id;
                    }else if(greaterThreeMonthapp !=null && greaterThreeMonthapp !=''){
                        return greaterThreeMonthapp;
                    }
                    appDetList.add(appDet);
                }
            }
            res.landing_info.loanInfo  = new Customer360view.cls_LOANDETAIL();
            //WS_LandingPage.LandingInfo parent = new WS_LandingPage.
            if(applicationId != null && applicationId != ''){
                System.debug('applicationId'+applicationId);
                facilityList    = SOQL_Util.getFacilities(applicationId);   
            }  
            
            loanFacilityList                                = SOQL_Util.getLoanFacilityList(accIdList);
            System.debug('accIdList'+accIdList);
            
            if(facilityList !=null && facilityList.size() > 0){
                res.landing_info.loanInfo.WORKING_CAPITAL  = new List<Customer360view.cls_FACILITIES>();
                res.landing_info.loanInfo.MY_LOAN  = new List<Customer360view.cls_FACILITIES>();
                for(Facility__c f : facilityList){
                    System.debug('@@@@@'+facilityList.size());
                    System.debug('@@@@@ffffff'+facilityList);
                    Customer360view.cls_FACILITIES fac  = new Customer360view.cls_FACILITIES();
                   // fac.NAME_OF_THE_FACILITY    = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.clcommon__Product_Name__c));
                    fac.ACCOUNT_NUMBER          = Utility.getBlankStringIfNull(String.valueOf(f.Account_Number__c));
                   // fac.TOTAL_LOAN_AMT          = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Limit__c));
                   // fac.BALANCE_OUTSTANDING     = Utility.getBlankStringIfNull(String.valueOf(f.Balance_Outstandings__c));
                    fac.LIMIT_AMT               = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Limit__c));
                   // fac.OVER_DUE                = Utility.getBlankStringIfNull(String.valueOf(f.Over_Due__c));
                    fac.INTEREST_RATE           = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Rate__c));
                   // fac.PRODUCT_CODE            = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.Product_Code__c));
                    fac.PRODUCT_NAME            = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.clcommon__Product_Name__c));
                    fac.DATE_OF_MATURITY= Utility.getBlankStringIfNull(String.valueOf(f.Limit_end_date__c));
                    System.debug('@@@@@'+fac);
                    res.landing_info.loanInfo.WORKING_CAPITAL.add(fac);                
                }   
                if(!loanFacilityList.isEmpty()){
                    for(Facility__c f : loanFacilityList){
                        Customer360view.cls_FACILITIES fac  = new Customer360view.cls_FACILITIES();
                        //fac.NAME_OF_THE_FACILITY    = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.clcommon__Product_Name__c));
                        fac.ACCOUNT_NUMBER          = Utility.getBlankStringIfNull(String.valueOf(f.Account_Number__c));
                        //fac.TOTAL_LOAN_AMT          = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Limit__c));
                        //fac.BALANCE_OUTSTANDING     = Utility.getBlankStringIfNull(String.valueOf(f.Balance_Outstandings__c));
                        fac.LIMIT_AMT               = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Limit__c));
                        //fac.OVER_DUE                = Utility.getBlankStringIfNull(String.valueOf(f.Over_Due__c));
                        fac.INTEREST_RATE           = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Rate__c));
                       // fac.PRODUCT_CODE            = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.Product_Code__c));
                        fac.PRODUCT_NAME            = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.clcommon__Product_Name__c));
                        fac.DATE_OF_MATURITY= Utility.getBlankStringIfNull(String.valueOf(f.Limit_end_date__c));
                        res.landing_info.loanInfo.MY_LOAN.add(fac);                
                    }
                }
            }
            
            // Stock Statment
            res.landing_info.loanInfo.STOCK                    = new Customer360view.STOCK_MODEL();
            res.landing_info.loanInfo.STOCK.templates          = new List<Customer360view.STOCK_TEMPLATE>();
            res.landing_info.loanInfo.STOCK.templates          = Utility.getStockTemplates();
            res.landing_info.loanInfo.STOCK.STOCK_STATEMENT    = new List<Customer360view.cls_STOCK_STATEMENT>();
            res.landing_info.loanInfo.STOCK.STOCK_STATEMENT    = Utility.getStockStatementDetails(custId);
            res.landing_info.appln_info = appDetList;
        }
        catch(Exception e){
            System.debug(e.getMessage()+e.getLineNumber());
            System.debug(e.getStackTraceString());
            res.status = Constants.WS_ERROR_STATUS;
            res.errorMessage = Constants.WS_ERROR_STATUS;
            res.successMessage = '';
            res.statusCode = Constants.WS_ERROR_CODE;
        }
        System.debug('res:::'+res);
        RETURN res;
    }
    public static genesis__Applications__c getAppDetail(String custId){
        RETURN null;
    }
    
    @future(callout=true)
    public static void preEnhancementChecksTrigger(String appId){
        try{

            List<Account>               updateAccList               = new List<Account>();
            List<genesis__Applications__c> clonedApp                = new List<genesis__Applications__c>();
            List<genesis__Applications__c> parentApp                = new List<genesis__Applications__c>();
            genesis__Applications__c appToUpdate                    = new genesis__Applications__c(Id=appId);
            Account acc = new Account();
            Database.BatchableContext BC;
            Boolean bureauFlag = false;
            Boolean listMatchingFlag = false;
            
            List<String> listOfErrorResponse	= new List<String>{'No-Hit','NoBorrowerFound'};
            clonedApp = [SELECT Id,Type__c,genesis__Account__r.Jocata_TxnId__c,RecordType.DeveloperName,Renewal_Due_Date__c,Parent_Application__c,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingCountry,genesis__Account__r.Nationality__pc,genesis__Account__r.Driving_License_ID__c,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Ration_Card__c,genesis__Account__r.PersonMobilePhone,genesis__Account__r.Phone,genesis__Account__r.PersonEmail,genesis__Account__c,genesis__Account__r.PersonBirthdate,genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,Product_Code__c,genesis__Loan_Amount__c,Application_Stage__c,Pre_Renewal_Checklist__c,CommercialPR_Stage__c,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.AccountNumber,genesis__Account__r.Name,genesis__Account__r.BillingStreet,genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingCountry,genesis__Account__r.Pan_Number__c,
                         (SELECT id,genesis__Party_Account_Name__c FROM genesis__Application_Parties__r WHERE genesis__Party_Account_Name__c!=null AND Active__c = true),
                         (SELECT Id FROM Pre_Renewal_Checklists__r)
                         FROM genesis__Applications__c WHERE Id =:appId];
            acc = [SELECT Id,(SELECT Id,CreatedDate FROM List_Matchings__r ORDER BY CreatedDate ASC),
                   (SELECT Id,CreatedDate FROM TransUnion_Credit_Reports__r ORDER BY CreatedDate ASC),
                   (SELECT Id,CreatedDate,Response__c FROM TU_Errors__r where Response__c IN : listOfErrorResponse ORDER BY CreatedDate ASC)
                   FROM Account WHERE Id =: clonedApp[0].genesis__Account__c];
            
            if(!acc.List_Matchings__r.isEmpty()){
                if(acc.List_Matchings__r[0].CreatedDate.month()-System.today().month() > 3){
                    listMatchingFlag = true;
                }else{
                    appToUpdate.List_Matching_Stage__c='Completed';
                }
            }else{
                listMatchingFlag = true;
            }
            if(!acc.TransUnion_Credit_Reports__r.isEmpty()){
                if(acc.TransUnion_Credit_Reports__r[0].CreatedDate.month()-System.today().month() > 3){
                    bureauFlag = true;
                }else{
                    appToUpdate.CommercialPR_Stage__c='Completed';
                }
            }else if(!acc.TU_Errors__r.isEmpty()){
            	if(acc.TU_Errors__r[0].CreatedDate.month()-System.today().month() > 3){
                    bureauFlag = true;
                }else{
                    appToUpdate.CommercialPR_Stage__c='Completed';
                }    
            }else{
                bureauFlag = true;
            }
            
            if(bureauFlag == false){
                System.debug('@@@ asdf');
                excuteListMatchingBatch(clonedApp,false,listMatchingFlag);
            }else{
                excuteListMatchingBatch(clonedApp,true,listMatchingFlag);
            }
            If(!clonedApp.isEmpty()){
                String devName = SOQL_Util.getRecordTypeNameByRecordId(clonedApp[0].id);
                If(devName !=Constants.SME_APP_RECORD_TYPE_EXCEEDING && devName !=Constants.SME_APP_RECORD_TYPE_ADHOC){
                    if(clonedApp[0].Renewal_Due_Date__c != null && System.today().daysBetween(clonedApp[0].Renewal_Due_Date__c) <= 2){
                        if(clonedApp[0].Pre_Renewal_Checklists__r.isEmpty()){
                            parentApp = [SELECT Id,(SELECT Id,Application__c,Checklist_Name__c,Comment__c,Complied__c,Reason__c,Sl_No__c FROM Pre_Renewal_Checklists__r) FROM genesis__Applications__c WHERE Id =: clonedApp[0].Parent_Application__c];
                            if(parentApp[0].Pre_Renewal_Checklists__r.isEmpty()){
                                //Trigger CheckList
                                System.debug('@@@ createPrechecklist');
                                if(!checkIfPrerenewalExist(appId))
                                SME_PRE_RENEWAL_CHECKING.createPrechecklist(new List<Id>{clonedApp[0].Id});
                            }
                            else{
                                //Clone CheckList
                                System.debug('@@@ clonedCheckList');
                                List<Renewal_Checklists__c> clonedCheckList = new List<Renewal_Checklists__c>();
                                clonedCheckList.addAll(parentApp[0].Pre_Renewal_Checklists__r);
                                for(Renewal_Checklists__c cCL : clonedCheckList){
                                    cCL.Application__c = clonedApp[0].Id;
                                }
                                if(!checkIfPrerenewalExist(appId))
                                INSERT clonedCheckList;
                            }
                        }
                        
                    }
                    else{
                        if(!checkIfPrerenewalExist(appId))
                        SME_PRE_RENEWAL_CHECKING.createPrechecklist(new List<Id>{clonedApp[0].Id});
                    }    
                }
            } 
            update appToUpdate;
        }catch(Exception ex){
            System.debug('Exception'+ex.getMessage()+ex.getLineNumber());
            System.debug(ex.getStackTraceString());
        }
    }
    public static void excuteListMatchingBatch(List<genesis__Applications__c> clonedApp,Boolean runBureauBatch,Boolean listMatchingFlag){
        
        List<genesis__Applications__c> apptoUpdate              = new List<genesis__Applications__c>();
        List<Account>               updateAccList               = new List<Account>(); 
        Database.BatchableContext BC;
        //Newly Added
        Map<String,String> custIdJocataTxIdMap = new Map<String,String>();
        Boolean checkIfTxnId = false;
        
        if(listMatchingFlag){
            System.debug('#####'+'excuteListMatchingBatch');
            //String jocataToken = '';//Batch_jocataListMatchingHelper.getJocataTocken(clonedApp[0],false);
            //Newly Added
            if(clonedApp != null){
                //jocataToken = custIdJocataTxIdMap.get(clonedApp[0].genesis__Account__c);
                for(genesis__Applications__c appObj : clonedApp){

                    genesis__Applications__c app = new genesis__Applications__c();

                    custIdJocataTxIdMap = Batch_jocataListMatchingHelper.getJocataTocken(clonedApp[0]); // Map to hold AccountId for Jocata Transaction Id.
                    checkIfTxnId = true;
                    if(custIdJocataTxIdMap.size() > 0){
                        for(String accountId : custIdJocataTxIdMap.keySet()){
                            Account acc = new Account();
                            acc.Id = accountId;
                            acc.List_Matching_Trigger_Time__c = System.now();
                            if(custIdJocataTxIdMap.get(accountId) != null){
                                acc.Jocata_TxnId__c = custIdJocataTxIdMap.get(accountId); //Storing Jocata Transaction ID in Account level, it is not null.
                            }
                            else checkIfTxnId = false;
                            updateAccList.add(acc);                                 //List to hold all Account(Business/KeyPerson) data, for updation.
                        }
                    }
                    If(appObj != null){
                        System.debug('Flag Value ---> ' + checkIfTxnId);
                        app.Id = appObj.Id;
                        if(checkIfTxnId) app.List_Matching_Stage__c    = 'Sent';    // If all account's Jocata Txn Id is present then setting the stage as SENT.
                        apptoUpdate.add(app);                                      //List to hold all Application data, for updation of List Matching Stage field.
                    } 
                }

                /*//UPDATE Account
                if(!updateAccList.isEmpty()){
                    AccountTriggerHandler.isAccountTrigger=true;
                    try{
                        UPDATE updateAccList; 
                    }catch(Exception ex){
                        System.debug('@@@@@ inside acc UPDATE'+ex.getMessage()+ex.getLineNumber());
                    }
                }

                //UPDATE Application
                if(!apptoUpdate.isEmpty()){
                    ApplicationTriggerHandler.IsFirstRun=false;
                    try{
                        UPDATE apptoUpdate;  
                    }catch(Exception ex){
                        System.debug('@@@@@ inside app UPDATE'+ex.getMessage()+ex.getLineNumber());
                    }
                }*/

            } 
            

            /*if(jocataToken != null){
            //if(custIdJocataTxIdMap != null){
                apptoUpdate.add(new genesis__Applications__c(Id=clonedApp[0].Id,List_Matching_Status__c =true,List_Matching_Stage__c='Sent'));
                updateAccList.add(new Account(Id=clonedApp[0].genesis__Account__r.Id,Jocata_TxnId__c=jocataToken));
            }*/
        }
        
        // commercial pr call
        System.debug('#####'+clonedApp);
        System.debug('#####'+clonedApp[0]);
        If(clonedApp[0].RecordType.DeveloperName !=null && clonedApp[0].RecordType.DeveloperName!=''){//!= Constants.SME_NEW_LOAN_RECORD_TYPE){
            String Type = 'SME';
            if(runBureauBatch == true){
                String custId = clonedApp[0].genesis__Account__r.CBS_Customer_ID__c;
                If(custId !=null && custId !=''){
                    List<String> listCustId = new List<String>{custId};
                    System.debug('listCustId===> '+listCustId);
                        If(listCustId !=null && listCustId.size()> 0 ){
                            System.debug('**Calling Commercial PR**');
                            CommercialPR_EAE_Batch.getCommercialPR_EAE_Request(listCustId,Type,clonedApp[0].Id);   
                        }
                } 
            }    
        }
        if(apptoUpdate.size() > 0){
            ApplicationTriggerHandler.IsFirstRun = false;
            update apptoUpdate;
            System.debug('#####'+apptoUpdate[0].Id);
        }
        if(updateAccList.size() > 0){
            AccountTriggerHandler.isAccountTrigger  = true;
            //false the checkbox
            update updateAccList;
        }
        
        
    }
    public static void excuteBureauBatch(List<genesis__Applications__c> clonedApp){
        
        
    }
    public static Boolean checkIfPrerenewalExist(String appId){
        try {
            genesis__Applications__c appRecord                  = new genesis__Applications__c();
            appRecord                                           = [SELECT Id, (SELECT Id FROM Pre_Renewal_Checklists__r) FROM genesis__Applications__c WHERE Id =:appId];
            if((appRecord.Pre_Renewal_Checklists__r != null ) && (appRecord.Pre_Renewal_Checklists__r).size()>0)
                return true;
            else
                    return false;
        } catch (Exception e) {
            HandleBusinessException.captureError('LandPageHelper', 'checkIfPrerenewalExist', e);
            return false;
        }


    }
    
}