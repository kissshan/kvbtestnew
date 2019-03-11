public class SME_Enhance_Update {
    
    public static Decimal currencyFormatter(String amt){
        if(amt == '' || amt == null){
            RETURN 0.0;
        }
        else
            RETURN decimal.valueOf(amt.replace(',', ''));
    }
    
    public static Customer360view getSME_Enhance_Update(Customer360view customObj){
        
        Account acc                                                     = new Account();
        List<genesis__Applications__c> appInfo         = new List<genesis__Applications__c>();
        List<genesis__Application_Parties__c> listOfParties= new  List<genesis__Application_Parties__c>();
        Map<String,List<String>> YearToMissingFinancialYearMap = new Map<String,List<String>>();
        Map<String,String> mapPartyType                                 = new Map<String,String>();
        Account currentCustomer                                         = new Account();
        List<Account> listaccount                                       = new List<Account>();
        String custFinancialYear                                        ='';
        String custFinancialMonth                                       ='';
        Integer custFinancialclosingBal                                 = 0;
        
        List<String> listDeveloperName                                  = new List<String>{'Land_And_Buildings_Other'};
        List<String> appStageFE                                         = new List<String>{'Application review-Critical changes'};
        List<genesis__Applications__c> appln                            = new List<genesis__Applications__c>();
        Map<String,id> recordtypeIdMap                                  = Utility.getRecordTypeID(listDeveloperName);
        List<Limit_Assessment__c> limassList                            = new List<Limit_Assessment__c>();
        List<Limit_Assessment__c> limassListC                           = new List<Limit_Assessment__c>();
        List<Account> newlistacc                                        = new List<Account>();
        Set<Account> deletePartyAcc                                     = new set<Account>();
        set<id> partyIdObj                                              = new set<id>();
        genesis__Applications__c app                                    = new genesis__Applications__c();
        genesis__Applications__c applicationObj                         = new genesis__Applications__c();
        List<genesis__Applications__c> listOfApp                        = new List<genesis__Applications__c>();
        List<genesis__Application_Collateral__c> listAppCollateral      = new List<genesis__Application_Collateral__c>();
        List<Ownership__c> ownerShipListToInsert                        = new List<Ownership__c>();
        List<Ownership__c> ownerShipListToUpdate                        = new List<Ownership__c>();
        List<genesis__Application_Parties__c> listappparty              = new List<genesis__Application_Parties__c>();
        List<genesis__Application_Parties__c> listapppartyUpsertonExtid = new List<genesis__Application_Parties__c>();
        List<genesis__Application_Parties__c> listapppartyUpsertonid    = new List<genesis__Application_Parties__c>();
        List<genesis__Application_Parties__c> listOfRejectedParty       = new List<genesis__Application_Parties__c>();
        List<genesis__Application_Parties__c> listappparty_OwnerId      = new List<genesis__Application_Parties__c>();
        List<Facility__c> listFacility                                  = new List<Facility__c>();
        List<Facility__c> listFacilityDelete                            = new List<Facility__c>();
        Set<String> listOfStringForAPPCollDelete                        = new Set<String>();
        List<clcommon__Collateral__c> listCollateralInsert              = new List<clcommon__Collateral__c>();
        List<clcommon__Collateral__c> listCollateralUpdate              = new List<clcommon__Collateral__c>();
        List<genesis__Application_Parties__c> deleteappparty            = new List<genesis__Application_Parties__c>();
        List<Property__c> listPropertyinsert                            = new List<Property__c>();
        List<Property__c> listPropertyupdate                            = new List<Property__c>();
        List<Property__c> listPropertyinsertAccountTag                  = new List<Property__c>();
        List<Debtors__c> listDebtorsInsert                              = new List<Debtors__c>();
        List<Debtors__c> listDebtorsupdate                              = new List<Debtors__c>();
        List<Sundry_Creditors__c>   listSundryCreditorInsert            = new List<Sundry_Creditors__c>();
        List<Sundry_Creditors__c>   listSundryCreditorupdate            = new List<Sundry_Creditors__c>();
        List<Group_Concern__c> listGroupConInsert                       = new List<Group_Concern__c>();
        List<Group_Concern__c> listGroupConUpdate                       = new List<Group_Concern__c>();
        List<Group_Concern__c> listGroupConDelete                       = new List<Group_Concern__c>();
        List<Perfios__c> listOfPerfios                                  = new List<Perfios__c>();
        Set<String> setOfFacilitiesId                                   = new Set<String>();
        Map<String,Property__c> mapOfPropertyAccountTag                 = new Map<String,Property__c>();
        List<Account> newOrExistingAccountList                                 = new List<Account>(); 
        //For Task 
        Map<String,Task> mapOfTask ;
        //User Object
        User userObj;
        Integer currentYear                                             = Utility.getCurrentYear();
        String cyString                                                 = String.valueOf(currentYear);
        String currentFY                                                = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
        String prevFY                                                   = (currentYear-2)+'-'+Integer.valueOf(String.valueOf(currentYear-1).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
        String n_1_FY                                           = (currentYear - 3) + '-' + Integer.valueOf(String.valueOf(currentYear - 2).subString(String.valueOf(currentYear - 1).length() - 2, String.valueOf(currentYear - 1).length()));
        String nextEstFiscalYear                                        = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
        String nextProjFiscalYear                                       = (currentYear+1)+'-'+Integer.valueOf(String.valueOf(currentYear+2).subString(String.valueOf(currentYear+2).length()-2,String.valueOf(currentYear+2).length()));
        List<Task> taskCompleteList                                     = new List<Task>();
        
        Id personAccountTypeId                                          = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Boolean allPartySigned                                          = true;
        Boolean isRejected_Application                                  = false;
        //system.debug('=======sme enhance update=======');
        if(customObj !=null) {
            appInfo                                        = SOQL_Util.getApplication(new Set<Id>{customObj.LOS_APPLICATION_ID});
            //Download Signed Document on status update
            //This method includes callout, it always needs to before any DML/sendEmail operation
            SMELoan_Helper.downloadSignedDocument(customObj);
            
            updateCustomerFeedBack(customObj);
            
            if(customObj.LOS_QUESTION_NEW_LOAN != null)
                app.SME_New_Loan_Questions__c =customObj.LOS_QUESTION_NEW_LOAN;
            
            if(customObj.TYPE_OF_APPLICATION != null)
                app.Type_of_Application__c =customObj.TYPE_OF_APPLICATION;


            if(customObj.APPLICATION_STAGE== Constants.Enhancement_App_Submitted || customObj.APPLICATION_STAGE==Constants.Adhoc_App_Submitted || customObj.APPLICATION_STAGE==Constants.New_Loan_Submitted || customObj.APPLICATION_STAGE == Constants.APPLICATION_REVIEW_CRITICAL_CHANGE){
                app.BRE_Done__c = false;
                app.MOD_Date__c=null;
                app.All_property_Documents_Uploaded__c='';
                app.Sale_Deed_Colleced__c='';
                app.Documents_Uploaded__c = false;
                app.MOD_Branch__c='';
            }
            //if(customObj.APPLICATION_STAGE==Constants.New_Loan_Submitted){
                //List<genesis__Application_Document_Category__c> appdoccategory=DocumentFetch.checkDocumentCategory2(customObj.LOS_APPLICATION_ID,new List<String>{},new Set<String>{});
            //}
            updateSliderChanges(customObj , customObj.LOS_APPLICATION_ID);
            if(customObj.APPLICATION_STAGE == Constants.Exceeding_App_Submitted)
                deleteFacility(customObj.LOS_APPLICATION_ID);
            List<Customer360view.cls_KEY_PERSON_DETAILS> listKeyPersonDetails     =  new List<Customer360view.cls_KEY_PERSON_DETAILS>();
            if(customObj.KEY_PERSON_DETAILS != null)
                listKeyPersonDetails                                              = customObj.KEY_PERSON_DETAILS;
            
            //Liabilities API
            if(customObj.BusinessLiabilityDetails !=null){
                Customer360view.cls_BusinessLiabilityDetails businessLiabilityObj = customObj.BusinessLiabilityDetails;
                if(businessLiabilityObj !=null && customObj.LOS_APPLICATION_ID !=null && customObj.LOS_CUSTOMER_SF_ID !=null){
                    SMELoan_Helper_Handler.updateBusinessLiablities(customObj.LOS_APPLICATION_ID,customObj.LOS_CUSTOMER_SF_ID,businessLiabilityObj);    
                }
            }
            if(customObj.KeyPersonLiabilityDetails !=null){
                List<Customer360view.cls_KeyPersonLiabilityDetails> kPersonLiabilityObj = customObj.KeyPersonLiabilityDetails;
                if(kPersonLiabilityObj !=null && kPersonLiabilityObj.size() > 0 && customObj.LOS_APPLICATION_ID !=null && customObj.LOS_CUSTOMER_SF_ID !=null){
                    SMELoan_Helper_Handler.updateKeyPersonLiablities(customObj.LOS_APPLICATION_ID,kPersonLiabilityObj);    
                }
            }
            /* New Loan Questions Updation*/
            if(customObj.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION !=null){
                //system.debug('@@@EXISTING_FACILITY_QUESTION@@@');
                SecurityCoverageRefactorModel.updateQuestionAndAnswer(customObj,customObj.LOS_APPLICATION_ID);
            }
            if(customObj.COMPANY_DETAILS.NEW_FACILITY_QUESTION !=null){
                SecurityCoverageRefactorModel.updateQuestionAndAnswer(customObj,customObj.LOS_APPLICATION_ID);
            }

            If(!Utility.ISStringBlankorNull(customObj.LOS_APPLICATION_ID)) {
                app.id = customObj.LOS_APPLICATION_ID;
            }
            
            if(customObj.APPLICATION_STAGE != null){
                //if(customObj.APPLICATION_STAGE== Constants.Enhancement_App_Submitted || customObj.APPLICATION_STAGE==Constants.Exceeding_App_Submitted || customObj.APPLICATION_STAGE==Constants.Adhoc_App_Submitted || customObj.APPLICATION_STAGE==Constants.New_Loan_Submitted || (customObj.APP_TYPE == Constants.SME_NEW_LOAN_RECORD_TYPE && customObj.APPLICATION_STAGE == Constants.APPLICATION_REVIEW_CRITICAL_CHANGE)){
                if((customObj.APPLICATION_STAGE == Constants.Enhancement_App_Submitted || customObj.APPLICATION_STAGE == Constants.Exceeding_App_Submitted || customObj.APPLICATION_STAGE == Constants.Adhoc_App_Submitted || customObj.APPLICATION_STAGE == Constants.New_Loan_Submitted || customObj.APPLICATION_STAGE == Constants.APPLICATION_REVIEW_CRITICAL_CHANGE) && customObj.APP_SUB_STAGE != Constants.INSUFFICIENT_COLLATERAL_COVERAGE ){
                    if(customObj.APP_TYPE == 'SME_Enhancement' || (customObj.APP_TYPE == 'SME_NEW_Loan' && customObj.TYPE.contains('ETB-WC'))){
                        System.debug('BeFore Bundling Queries used in this apex code so far: @@@@' + Limits.getQueries());
                        
                        TL_EnhanceUpdate_Helper.bundling(customObj.LOS_APPLICATION_ID,customObj.LOS_CUSTOMER_SF_ID);
                   
                        System.debug('After Bundling Queries used in this apex code so far: @@@@' + Limits.getQueries());
                    }
                    listOfParties  = SOQL_Util.getListOfPartiesByAppId(customObj.LOS_APPLICATION_ID);
                    If(customObj.TYPE.contains('NTB') || customObj.TYPE.contains('ETB-CA')){
                        If(listOfParties !=null && listOfParties.size() > 0){ //listappparty_OwnerId
                            for(genesis__Application_Parties__c appPartiesObj   :   listOfParties) {
                                If(appPartiesObj !=null){
                                    //System.debug('oldOwnerId:::'+appPartiesObj.Id);
                                    appPartiesObj.OwnerId   = appPartiesObj.genesis__Application__r.OwnerId;
                                    listappparty_OwnerId.add(appPartiesObj);
                                }
                            }   
                        }    
                    }
                    List<User> COuserLst=SOQL_Util.getBRCreditOfficer(customObj.LOS_APPLICATION_ID);
                    if(COuserLst.size()>0){
                            Try{
                                Set<Id> accIds= new Set<Id>();
                                for(genesis__Application_Parties__c par : listOfParties){
                                    if(par.genesis__Party_Account_Name__c != null){
                                        accIds.add(par.genesis__Party_Account_Name__c);   
                                    }
                                }
                                RecordsSharingAccess.accountRecordsShare(accIds,COuserLst[0]);
                            }catch(Exception e){}
                    }
                    mapOfTask = SOQL_Util.checkExixtingTaskForAnyStatus(customObj.LOS_APPLICATION_ID);
                    if(Underwriting_CTRL_Helper.checkIfFECollateralExist(customObj.LOS_APPLICATION_ID) && (customObj.APP_TYPE == 'SME_AdHoc' || customObj.APP_TYPE == 'SME_Enhancement' || customObj.APP_TYPE == 'SME_NEW_Loan')){
                        if(mapOfTask !=null && mapOfTask.size() > 0){
                            if(! mapOfTask.containsKey('M121 A Needed')){
                                SOQL_Util.createTaskForBMWithoutCheckExTask(appInfo,'Complete M121 A for new collateral','M121 A Needed');
                            }
                        }else{
                            SOQL_Util.createTaskForBMWithoutCheckExTask(appInfo,'Complete M121 A for new collateral','M121 A Needed');
                        }
                    }
                    
                    if(COuserLst.size()>0){
                        if(mapOfTask !=null && mapOfTask.size() > 0){
                            if(! mapOfTask.containsKey('Qualitative Input Needed')){
                                SOQL_Util.createTaskForBRCreditOfficerWithoutCheckExTask(customObj.LOS_APPLICATION_ID,COuserLst[0].Id,'Qualitative input required','Qualitative Input Needed');        
                            }
                        }else{
                            SOQL_Util.createTaskForBRCreditOfficerWithoutCheckExTask(customObj.LOS_APPLICATION_ID,COuserLst[0].Id,'Qualitative input required','Qualitative Input Needed');    
                        }
                    }else{
                        if(mapOfTask !=null && mapOfTask.size() > 0){
                            if(! mapOfTask.containsKey('Qualitative Input Needed')){
                                SOQL_Util.createTaskForBMWithoutCheckExTask(appInfo,'Qualitative input required','Qualitative Input Needed');        
                            }
                        }else{
                            SOQL_Util.createTaskForBMWithoutCheckExTask(appInfo,'Qualitative input required','Qualitative Input Needed');    
                        }
                    }
                    if(customObj.APPLICATION_STAGE==Constants.New_Loan_Submitted || (customObj.APP_TYPE == Constants.SME_NEW_LOAN_RECORD_TYPE && customObj.APPLICATION_STAGE == Constants.APPLICATION_REVIEW_CRITICAL_CHANGE)){
                        if(customObj.COMPANY_DETAILS != null){
                            if(mapOfTask !=null && mapOfTask.size() > 0 ){
                                if(! mapOfTask.containsKey('Takeover Intelligence')){
                                    SOQL_Util.createTaskForBMWithoutCheckExTask(appInfo,'Complete new loan request formalities','Takeover Intelligence');    
                                }
                            }else{
                                SOQL_Util.createTaskForBMWithoutCheckExTask(appInfo,'Complete new loan request formalities','Takeover Intelligence');
                            }
                            If(customObj.TYPE.contains('NTB') || customObj.TYPE.contains('New to credit')){
                                if(mapOfTask !=null && mapOfTask.size() > 0 ){
                                    if(! mapOfTask.containsKey('Takeover Intelligence')){
                                        SOQL_Util.createTaskForBMWithoutCheckExTask(appInfo,'Unit visit report and market intelligence','Market Intelligence');    
                                    }
                                }else{
                                    SOQL_Util.createTaskForBMWithoutCheckExTask(appInfo,'Unit visit report and market intelligence','Market Intelligence');
                                }
                            }
                        }
                    }
                    if(customObj.APPLICATION_STAGE != Constants.New_Loan_Submitted){
                        LandingPageHelper.preEnhancementChecksTrigger(customObj.LOS_APPLICATION_ID);
                    }
                    if(customObj.APPLICATION_STAGE==Constants.New_Loan_Submitted || (customObj.APP_TYPE == Constants.SME_NEW_LOAN_RECORD_TYPE && customObj.APPLICATION_STAGE == Constants.APPLICATION_REVIEW_CRITICAL_CHANGE)){
                        isRejected_Application = SMELoan_Helper_Fetch_Handler.getSubmissionForRejectNTBusiness(customObj.LOS_APPLICATION_ID);
                        //System.debug('isRejected_Application @@@@ '+isRejected_Application);
                        If(isRejected_Application){
                            app.Application_Stage__c   = 'Application Rejected';
                            //taskCompleteList = SOQL_Util.completeTask(app.Id);
                            taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
                        }else{
                            app.Application_Stage__c   = customObj.APPLICATION_STAGE;
                        }
                    }else{
                        app.Application_Stage__c        = customObj.APPLICATION_STAGE;    
                    } 

                    if(!Underwriting_CTRL_Helper.checkIfM21ExistForLastThreeYears(customObj.LOS_CUSTOMER_SF_ID) &&  (customObj.APPLICATION_STAGE== Constants.Enhancement_App_Submitted || customObj.APPLICATION_STAGE==Constants.New_Loan_Submitted || (customObj.APPLICATION_STAGE == Constants.APPLICATION_REVIEW_CRITICAL_CHANGE && (customObj.APP_TYPE == Constants.SME_NEW_LOAN_RECORD_TYPE || customObj.APP_TYPE == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT)))){
                        If(customObj.IS_CLPC_TASK !=null && (customObj.IS_CLPC_TASK =='Yes' || customObj.IS_CLPC_TASK =='True' || customObj.IS_CLPC_TASK =='1')){
                            List<Task> taskList                     = new List<Task>();
                            if(mapOfTask !=null && mapOfTask.size() > 0 ){
                                if(!mapOfTask.containsKey('Financial Upload')){
                                    taskList.add(SanctionUnderwriting_Process.getTaskObj(customObj.LOS_APPLICATION_ID, appInfo[0].OwnerId, 'Financial upload', 'Financial Upload'));
                                    //Underwriting_CTRL_Helper.createCLPCTask(customObj.LOS_APPLICATION_ID,'Financial Upload','CLPC task for financial upload');    
                                }
                            }else{
                                taskList.add(SanctionUnderwriting_Process.getTaskObj(customObj.LOS_APPLICATION_ID, appInfo[0].OwnerId, 'Financial upload', 'Financial Upload'));
                                //Underwriting_CTRL_Helper.createCLPCTask(customObj.LOS_APPLICATION_ID,'Financial Upload','CLPC task for financial upload'); 
                            }
                            if(taskList.size() > 0){
                                INSERT taskList;
                            }
                        }
                    }
                    
                }else if(appStageFE.contains(customObj.APPLICATION_STAGE)) {
                    Underwriting_CTRL_Helper.createLegalEvaluationTaskForBM(customObj.LOS_APPLICATION_ID,'Critical Changes','Review critical changes');
                    app.Application_Stage__c = customObj.APPLICATION_STAGE;
                    If(customObj.IS_PROVISIONAL_FINANCIAL !=null && (customObj.IS_PROVISIONAL_FINANCIAL == '1' || customObj.IS_PROVISIONAL_FINANCIAL == 'Yes' || customObj.IS_PROVISIONAL_FINANCIAL == 'true')){
                        app.is_Provisional__c   = true;    
                    }else If(customObj.IS_PROVISIONAL_FINANCIAL !=null && (customObj.IS_PROVISIONAL_FINANCIAL == '0' || customObj.IS_PROVISIONAL_FINANCIAL == 'No' || customObj.IS_PROVISIONAL_FINANCIAL == 'false')){
                        app.is_Provisional__c   = false;    
                    }
                }else {
                    if(customObj.APPLICATION_STAGE != '')
                    app.Application_Stage__c = customObj.APPLICATION_STAGE;
                }
                if(customObj.APPLICATION_STAGE == 'New Loans - Application Review-Critical changes' || customObj.APPLICATION_STAGE == 'Application Review-Critical changes'){
                    Underwriting_CTRL_Helper.createLegalEvaluationTaskForBM(customObj.LOS_APPLICATION_ID,'Critical Changes','Review critical changes');
                }
                
            }
            if(customObj.COMPANY_DETAILS !=null && customObj.COMPANY_DETAILS.OVERALL_EXPOSURE != null){
                app.Overall_Exposure__c =  Decimal.valueOf(customObj.COMPANY_DETAILS.OVERALL_EXPOSURE);
                /*List<Facility__c> listOfFacility = SanctionMatrixControllerHelper_EA.getAllFacilities(customObj.LOS_APPLICATION_ID);
                If(listOfFacility !=null && listOfFacility.size() > 0){
                app.Overall_Exposure__c = SanctionMatrixControllerHelper_EA.getLimitAmountAggregate(listOfFacility);
                } */
            }
            if(customObj.COMPANY_DETAILS !=null && customObj.COMPANY_DETAILS.BUREAU_FEE_RESULT != null){
                app.Bureau_Fee_Result__c= customObj.COMPANY_DETAILS.BUREAU_FEE_RESULT;
                if(customObj.COMPANY_DETAILS.BUREAU_FEE_RESULT== 'Success' && appInfo[0].RecordType.DeveloperName== 'SME_NEW_Loan' && customObj.LOS_APPLICATION_ID!=null){//customObj.COMPANY_DETAILS.CUSTOMER_ID !=null && appInfo[0].Id!=null){
                    LandingPageHelper.preEnhancementChecksTrigger(customObj.LOS_APPLICATION_ID);
                    //TermLoan_SOQL_Util.futureSmeTUcall(new List<String> {customObj.COMPANY_DETAILS.CUSTOMER_ID},'SME',appInfo[0].Id);
                    //CommercialPR_EAE_Batch.getCommercialPR_EAE_Request(new List<String> {customObj.COMPANY_DETAILS.CUSTOMER_ID},'SME',appInfo[0].Id);
                }
            }
            if(customObj.COMPANY_DETAILS.BUREAU_FEE== null){
                app.Bureau_Fee__c= 1000;
            }
            if(customObj.COMPANY_DETAILS.LEGAL_CHARGES!= null){
                app.Legal_Charges__c= Decimal.valueOf(customObj.COMPANY_DETAILS.LEGAL_CHARGES);
            }

            if(customObj.COMPANY_DETAILS.CREDIT_BUREAU_CHECK!= null){
                app.Credit_Bureau_Check__c= customObj.COMPANY_DETAILS.CREDIT_BUREAU_CHECK== 'True' ? true: false;
            }
            

            if(customObj.COMPANY_DETAILS !=null && customObj.COMPANY_DETAILS.NET_BANKING_FLAG != null){
                app.Net_Banking_Flag__c= customObj.COMPANY_DETAILS.NET_BANKING_FLAG== 'True' ? true: false;
            }
            if(customObj.COMPANY_DETAILS !=null && customObj.COMPANY_DETAILS.PROCESSING_FEE_RESULT != null){
                app.Processing_Fee_Result__c= customObj.COMPANY_DETAILS.PROCESSING_FEE_RESULT;
            }
            If(!Utility.ISStringBlankorNull(customObj.APPLICATION_UI_STAGE)){
                app.Application_UI_Stage__c      = customObj.APPLICATION_UI_STAGE;
                If(customObj.APPLICATION_UI_STAGE =='CompanyDetailsView'){
                    If(customObj.TYPE.contains('NTB') || customObj.TYPE.contains('ETB-CA')){
                        If(!Utility.ISStringBlankorNull(customObj.BRANCH_CODE)){
                            app.Branch_Code__c   = customObj.BRANCH_CODE;
                           userObj = SOQL_Util.getUserByBranchCode(customObj.BRANCH_CODE);
                            If(userObj !=null && userObj.Id !=null){
                                 acc.OwnerId    =  userObj.Id;
                                 app.OwnerId    =  userObj.Id;
                            }
                        }
                        If(!Utility.ISStringBlankorNull(customObj.BRANCH_NAME)){
                            app.Branch_Name__c   = customObj.BRANCH_NAME;
                        }    
                    }
                    /*genesis__Applications__c appForTUObj = SOQL_Util.getApplicationId_By_Name('',customObj.LOS_APPLICATION_ID);
                    If(appForTUObj !=null){
                        If(appForTUObj.RecordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE && appForTUObj.CommercialPR_Stage__c !='Completed'){
                            runCommercialPR(appForTUObj.genesis__Account__r.CBS_Customer_ID__c,app.Id); 
                        }   
                    } */
                }
            }
            If(!Utility.ISStringBlankorNull(customObj.APP_SUB_STAGE)){
                if(isRejected_Application){
                    app.Sub_Stage__c    =   'No Loan relationship';     
                }else{
                    app.Sub_Stage__c    =   customObj.APP_SUB_STAGE; 
                }
            }
            //cls_APP_REQUEST
            If(customObj.APP_TYPE == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || customObj.APP_TYPE == Constants.SME_NEW_LOAN_RECORD_TYPE){
                If (!Utility.ISStringBlankorNull(customObj.APPLICATION_TO_CLOSE)) {
                    If (customObj.APPLICATION_TO_CLOSE =='1' || customObj.APPLICATION_TO_CLOSE =='Yes' || customObj.APPLICATION_TO_CLOSE =='True') {
                        If (!Utility.ISStringBlankorNull(customObj.PARENT_APPLICATION)) {
                            applicationObj.id = (Id)customObj.PARENT_APPLICATION;
                            //applicationObj.Application_Stage__c = 'Enhancement/New Loan under process';
                            listOfApp.add(applicationObj);
                        }
                    }
                }
            }
            
            If(customObj.NEW_REQUEST !=null && customObj.APP_TYPE != Constants.SME_NEW_LOAN_RECORD_TYPE){
                String ExternalID;
                Customer360view.cls_APP_REQUEST  appRequestObj      =   customObj.NEW_REQUEST;
                If(appRequestObj !=null){
                    If(!Utility.ISStringBlankorNull(appRequestObj.REQ_REASON))
                        app.Request_Reason__c       =   appRequestObj.REQ_REASON;
                    If(!Utility.ISStringBlankorNull(appRequestObj.REASON_FOR_APPLICATION))
                        app.Reason_for_Application__c = appRequestObj.REASON_FOR_APPLICATION;
                    //public string EAE_RENEWAL_DATE;LIMIT_PERIOD
                    If(customObj.APP_TYPE=='SME_Enhancement'){
                        app.EAE_Renewal_Date_in_days__c                                 =   365;
                    }else If(customObj.APP_TYPE=='SME_Exceeding' && !Utility.ISStringBlankorNull(appRequestObj.LIMIT_PERIOD)){
                        
                        app.EAE_Renewal_Date_in_days__c                                 = Decimal.valueOf(appRequestObj.LIMIT_PERIOD);
                    }else If(customObj.APP_TYPE=='SME_AdHoc' && !Utility.ISStringBlankorNull(appRequestObj.LIMIT_PERIOD)){
                        app.EAE_Renewal_Date_in_days__c                                 = Decimal.valueOf(appRequestObj.LIMIT_PERIOD);
                    }
                    //List Of Facility
                    If(appRequestObj.FACILITY_INFO !=null){
                        List<Customer360view.cls_FACILITIES> listFacilitiesWrapp         =   appRequestObj.FACILITY_INFO;
                        If(listFacilitiesWrapp !=null && listFacilitiesWrapp.size() > 0){
                            for(Customer360view.cls_FACILITIES  facilityOBjWrp  :   listFacilitiesWrapp){
                                Facility__c     facilityObj                             =   new Facility__c();
                                If(facilityOBjWrp !=null){
                                    If(!Utility.ISStringBlankorNull(facilityOBjWrp.FACILITY_ID)){
                                        setOfFacilitiesId.add(facilityOBjWrp.FACILITY_ID);
                                        facilityObj.id                                  =   facilityOBjWrp.FACILITY_ID;
                                    }
                                    If(!Utility.ISStringBlankorNull(facilityOBjWrp.ACCOUNT_NUMBER)){
                                        ExternalID                                      =   facilityOBjWrp.ACCOUNT_NUMBER;
                                    }
                                    If(!Utility.ISStringBlankorNull(facilityOBjWrp.NEW_LIMIT_AMT))
                                        facilityObj.New_Limit_Amount__c                 =   SMELoan_Helper.currencyFormatter(facilityOBjWrp.NEW_LIMIT_AMT);
                                    
                                    If(!Utility.ISStringBlankorNull(facilityOBjWrp.DAYS))
                                        facilityObj.Recommended_Days__c                 =   Decimal.valueOf(facilityOBjWrp.DAYS);
                                    If(!Utility.ISStringBlankorNull(facilityOBjWrp.IS_DELETED)){
                                        If((facilityOBjWrp.IS_DELETED =='1' || facilityOBjWrp.IS_DELETED =='True' || facilityOBjWrp.IS_DELETED =='Yes') && facilityOBjWrp.FACILITY_ID !=null && facilityOBjWrp.FACILITY_ID !=''){
                                            facilityObj.id                                  =   facilityOBjWrp.FACILITY_ID;
                                            listOfStringForAPPCollDelete.add(facilityOBjWrp.FACILITY_ID);
                                            listFacilityDelete.add(facilityObj);
                                        }
                                    }
                                    
                                }
                                //system.debug('facilityObj---> ' + facilityObj);
                                listFacility.add(facilityObj);
                            }
                        }
                    }
                    If(appRequestObj.COLLATERAL_DETAILS !=null){
                        List<Customer360view.cls_NETWORTH_DETAILS>  listcollateralWrp   =   appRequestObj.COLLATERAL_DETAILS;
                        If(listcollateralWrp !=null){
                            for(Customer360view.cls_NETWORTH_DETAILS    collObjWrp      :   listcollateralWrp) {
                                String externalIdForCollateral                          =   SOQL_Util.getRandomExternalIdForCollateral();
                                clcommon__Collateral__c  collObj                        =   new clcommon__Collateral__c();
                                If(collObjWrp !=null){
                                    If(!Utility.ISStringBlankorNull(collObjWrp.LOS_PROPERTY_ID))
                                        collObj.id                                  = collObjWrp.LOS_PROPERTY_ID;
                                    If(!Utility.ISStringBlankorNull(collObjWrp.NATURE_OF_PROPERTY))
                                        collObj.Nature_of_Property__c               = collObjWrp.NATURE_OF_PROPERTY;
                                    If(!Utility.ISStringBlankorNull(collObjWrp.OWNERSHIP_TYPE))
                                        collObj.Ownership_Type__c                   = collObjWrp.OWNERSHIP_TYPE;
                                    If(!Utility.ISStringBlankorNull(collObjWrp.PERCENTAGE_OWNERSHIP))
                                        collObj.Percentage_of_Ownership__c          = Decimal.valueOf(collObjWrp.PERCENTAGE_OWNERSHIP);
                                    If(!Utility.ISStringBlankorNull(collObjWrp.PROPERTY_VALUE))
                                        collObj.Total_Asset_Value__c                = SMELoan_Helper.currencyFormatter(collObjWrp.PROPERTY_VALUE);
                                    If(!Utility.ISStringBlankorNull(collObjWrp.SURVEY_NO)){
                                        collObj.SurveyKhasraKhataPatta_No__c        = collObjWrp.SURVEY_NO;
                                        //system.debug('collObjWrp.PROPERTY_VALUE===> '+collObjWrp.PROPERTY_VALUE);
                                    }
                                    If(!Utility.ISStringBlankorNull(collObjWrp.PROPERTY_VALUE))
                                        collObj.clcommon__Value__c                        = Decimal.valueOf(collObjWrp.PROPERTY_VALUE);
                                    If(!Utility.ISStringBlankorNull(collObjWrp.MORTGAGE_DETAILS))
                                        collObj.MORT_TYPE__c                        = collObjWrp.MORTGAGE_DETAILS;
                                    If(!Utility.ISStringBlankorNull(collObjWrp.ASSET_TYPE))
                                        collObj.Collateral_Category__c              = collObjWrp.ASSET_TYPE;
                                    If(!Utility.ISStringBlankorNull(collObjWrp.DOOR_NO))
                                        collObj.Door__c                             = collObjWrp.DOOR_NO;
                                    If(!Utility.ISStringBlankorNull(collObjWrp.NEAREST_LANDMARK))
                                        collObj.Landmark__c                         = collObjWrp.NEAREST_LANDMARK;
                                    If(!Utility.ISStringBlankorNull(collObjWrp.PROPERTY_AREA))
                                        collObj.Area_Square_Feet__c                 = Decimal.valueOf(collObjWrp.PROPERTY_AREA);
                                    If(externalIdForCollateral !=null && externalIdForCollateral !='') {
                                        collObj.External_ID__c                      =   externalIdForCollateral;
                                        collObj.clcommon__Collateral_Name__c        =   externalIdForCollateral;
                                    }
                                    collObj.FE_Created__c                           = true;
                                    
                                    If(collObjWrp.ADDRESS !=null){
                                        Customer360view.cls_ADDRESS  cusParAdd      = collObjWrp.ADDRESS;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.TALUK))
                                            collObj.TalukaTehsil__c                 = cusParAdd.TALUK;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.STREET))
                                            collObj.Street_NameNo__c                = cusParAdd.STREET;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.CITY))
                                            collObj.clcommon__City__c               = cusParAdd.CITY;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.STATE))
                                            collObj.State__c                        = cusParAdd.STATE;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.PIN_CODE))
                                            collObj.clcommon__Postal_Code__c        = cusParAdd.PIN_CODE;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.COUNTRY))
                                            collObj.Country__c                      = cusParAdd.COUNTRY;
                                    }
                                    
                                    collObj.RecordTypeId                           =   recordtypeIdMap.get('Land_And_Buildings_Other');
                                    If(collObjWrp.LOS_PROPERTY_ID !=null && collObjWrp.LOS_PROPERTY_ID !=''){
                                        listCollateralUpdate.add(collObj);
                                    }else{
                                        listCollateralInsert.add(collObj);
                                        genesis__Application_Collateral__c appCollateralObj    =  new genesis__Application_Collateral__c();
                                        appCollateralObj.genesis__Collateral__r                =  new clcommon__Collateral__c(External_ID__c  =   externalIdForCollateral);
                                        appCollateralObj.Application__c                        =  customObj.LOS_APPLICATION_ID;
                                        //appCollateralObj.Facility__r                           =  new Facility__c(External_ID__c = ExternalID+'@'+customObj.LOS_APPLICATION_ID);
                                        appCollateralObj.External_ID__c                        =  /*ExternalID+'@'+customObj.LOS_APPLICATION_ID+'@'+*/externalIdForCollateral;
                                        If(!Utility.ISStringBlankorNull(collObjWrp.PROPERTY_TYPE))
                                            appCollateralObj.Security_Type__c                   =  collObjWrp.PROPERTY_TYPE;
                                        listAppCollateral.add(appCollateralObj);
                                    }
                                    if(collObjWrp.TILE_HOLDERS != null &&  !(collObjWrp.TILE_HOLDERS).isEmpty()){
                                        Ownership__c  ownerShipRec;
                                        for(Customer360view.cls_TITLE_HOLDER titleHolderRec:collObjWrp.TILE_HOLDERS){
                                            ownerShipRec= new Ownership__c();
                                            if(!Utility.ISStringBlankorNull(titleHolderRec.LOS_TITLE_HOLDER_RECORD_ID)){
                                                //system.debug('titleHolderRec.LOS_TITLE_HOLDER_RECORD_ID==> '+titleHolderRec.LOS_TITLE_HOLDER_RECORD_ID);
                                                ownerShipRec.Id                                 =   titleHolderRec.LOS_TITLE_HOLDER_RECORD_ID ;
                                                ownerShipRec.Account__c                         =   titleHolderRec.LOS_TITLE_HOLDER_ID;
                                                ownerShipListToUpdate.add(ownerShipRec);
                                            }else{
                                                //system.debug('titleHolderRec.LOS_TITLE_HOLDER_ID==> '+titleHolderRec.LOS_TITLE_HOLDER_ID+' collObjWrp.LOS_PROPERTY_ID===> '+collObjWrp.LOS_PROPERTY_ID);
                                                If(!Utility.ISStringBlankorNull(titleHolderRec.LOS_TITLE_HOLDER_ID))
                                                    ownerShipRec.Account__c                         =   titleHolderRec.LOS_TITLE_HOLDER_ID;
                                                If(!Utility.ISStringBlankorNull(collObjWrp.LOS_PROPERTY_ID)){
                                                    ownerShipRec.Collateral__c                  =   collObjWrp.LOS_PROPERTY_ID;    
                                                }else{
                                                    System.debug('Non Title hold');
                                                    ownerShipRec.Collateral__r                  =  new clcommon__Collateral__c(External_ID__c  =   externalIdForCollateral);
                                                }
                                                //ownerShipRec.Name       =   titleHolderRec.LOS_TITLE_HOLDER_NAME;
                                                ownerShipListToInsert.add(ownerShipRec);
                                            }
                                        }
                                    }
                                }
                            }
                            If(listFacility !=null && !listFacility.isEmpty() && listAppCollateral !=null && !listAppCollateral.isEmpty()){
                                Map<String,String> mapOfString = getMapSecurityType(setOfFacilitiesId);
                                for(Facility__c facObj :    listFacility) {
                                    for(genesis__Application_Collateral__c  appCollateralObject :   listAppCollateral){
                                        appCollateralObject.Facility__c         =   facObj.Id;
                                        appCollateralObject.External_ID__c      =   facObj.External_Id__c+'@'+appCollateralObject.External_ID__c;
                                        If(mapOfString !=null && mapOfString.containsKey(facObj.Id)){
                                            appCollateralObject.Security_Type__c =   mapOfString.get(facObj.Id);  
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            
            //NET_WORTH_STATEMENT
            If(customObj.NET_WORTH_STATEMENT !=null){
                Customer360view.cls_NET_WORTH_STATEMENT netWorthStmObj  =   customObj.NET_WORTH_STATEMENT;
                If(!Utility.ISStringBlankorNull(netWorthStmObj.TOTAL_OUTSTANDING_LIABALITIES))
                    app.Total_Outstanding_Liabilities__c                    =   Decimal.valueOf(netWorthStmObj.TOTAL_OUTSTANDING_LIABALITIES);
                If(!Utility.ISStringBlankorNull(netWorthStmObj.TOTAL_NETWORTH))
                    app.Total_Networth__c                                   =   Decimal.valueOf(netWorthStmObj.TOTAL_NETWORTH);
                If(!Utility.ISStringBlankorNull(netWorthStmObj.ORIGINAL_AMOUNT_INVESTMENTS))
                    app.Original_Amount_Investments__c                      =   Decimal.valueOf(netWorthStmObj.ORIGINAL_AMOUNT_INVESTMENTS);
            }
            if(customObj.MISSING_FINACIAL_YEARS != null){
                for(Customer360view.cls_MISSING_FIN  mssngFinObj  :  customObj.MISSING_FINACIAL_YEARS){
                    if(YearToMissingFinancialYearMap.containsKey(mssngFinObj.year)){
                        YearToMissingFinancialYearMap.get(mssngFinObj.year).add(mssngFinObj.CA_NAME);
                        YearToMissingFinancialYearMap.get(mssngFinObj.year).add(mssngFinObj.CA_NUMBER);
                    }
                    else{
                        YearToMissingFinancialYearMap.put(mssngFinObj.year,new List<String>{mssngFinObj.CA_NAME,mssngFinObj.CA_NUMBER});
                    }
                }
            }
            System.debug('YearToMissingFinancialYearMap:::'+YearToMissingFinancialYearMap);
            //cls_ACTUAL_EST_PRO
            If(customObj.FINANCIALS !=null) {
                List<M68_Balance_Sheet_Analysis__c> m68DataListToInsert = new List<M68_Balance_Sheet_Analysis__c>();
                List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();
                Map<String,M68_Balance_Sheet_Analysis__c> m68dataMapToUpdate = new Map<String,M68_Balance_Sheet_Analysis__c>();
                Map<String,M68_Balance_Sheet_Analysis__c> m68dataMapToInsert = new Map<String,M68_Balance_Sheet_Analysis__c>();
                M68_Balance_Sheet_Analysis__c m68CurrentYTD = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ProjNext2 = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68EstNext = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActPrev = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActN_1 = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActCurrent = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActCreditorsProjNext2 = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActDebtorsProjNext2 = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActCreditorsEstNext = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActDebtorsEstNext = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActCreditorsActCurrent = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActDebtorsActCurrent = new M68_Balance_Sheet_Analysis__c(); 
                if(customObj.FINANCIALS.SALES != null){
                    if(customObj.FINANCIALS.SALES.YTD_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentYTD  = customObj.FINANCIALS.SALES.YTD_CURRENT_FY;
                        if(salesCurrentYTD.LOS_ID != null && salesCurrentYTD.LOS_ID != ''){

                            m68Data.Id = salesCurrentYTD.LOS_ID;
                            m68Data.Month__c = salesCurrentYTD.MONTH;
                            m68Data.Net_sales__c = currencyFormatter(salesCurrentYTD.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextEstFiscalYear+'@YTD';
                            //m68DataList.add(m68CurrentYTD);
                            m68dataMapToUpdate.put('YTD_CURRENT_FY',m68Data);
                        }
                        else if(salesCurrentYTD.FY_TOTAL != null && salesCurrentYTD.FY_TOTAL != ''){
                            m68Data.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68Data.Fiscal_Year__c = nextEstFiscalYear;
                            m68Data.Financial_type__c = 'YTD';
                            m68Data.Month__c = salesCurrentYTD.MONTH;
                            m68Data.Net_sales__c = currencyFormatter(salesCurrentYTD.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextEstFiscalYear+'@YTD';
                            if(YearToMissingFinancialYearMap.get(nextEstFiscalYear) != null){
                                m68Data.CA_Name__c = YearToMissingFinancialYearMap.get(nextEstFiscalYear)[0];
                                m68Data.CA_Number__c = YearToMissingFinancialYearMap.get(nextEstFiscalYear)[1];
                            }
                            m68dataMapToInsert.put('YTD_CURRENT_FY',m68Data);
                        }
                    }
                    if(customObj.FINANCIALS.SALES.PROJ_NEXT2_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesNext2Proj  = customObj.FINANCIALS.SALES.PROJ_NEXT2_FY;
                        if(salesNext2Proj.LOS_ID != null && salesNext2Proj.LOS_ID != ''){
                            m68Data.Id = salesNext2Proj.LOS_ID;
                            m68Data.Net_sales__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextProjFiscalYear+'@Projected';
                            //m68DataList.add(m68ProjNext2);
                            m68dataMapToUpdate.put('PROJ_NEXT2_FY',m68Data);
                        }
                        else if(salesNext2Proj.FY_TOTAL != null && salesNext2Proj.FY_TOTAL != ''){
                            m68Data.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68Data.Fiscal_Year__c = nextProjFiscalYear;
                            m68Data.Financial_type__c = 'Projected';
                            m68Data.Net_sales__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextProjFiscalYear+'@Projected';
                            if(YearToMissingFinancialYearMap.get(nextProjFiscalYear) != null){
                                m68Data.CA_Name__c = YearToMissingFinancialYearMap.get(nextProjFiscalYear)[0];
                                m68Data.CA_Number__c = YearToMissingFinancialYearMap.get(nextProjFiscalYear)[1];
                            }
                            m68dataMapToInsert.put('PROJ_NEXT2_FY',m68Data);
                        }
                    }
                    if(customObj.FINANCIALS.SALES.EST_NEXT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesNextEst  = customObj.FINANCIALS.SALES.EST_NEXT_FY;
                        if(salesNextEst.LOS_ID != null && salesNextEst.LOS_ID != ''){
                            m68Data.Id = salesNextEst.LOS_ID;
                            m68Data.Net_sales__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextEstFiscalYear+'@Estimated';
                            //m68DataList.add(m68EstNext);
                            m68dataMapToUpdate.put('EST_NEXT_FY',m68Data);
                        }
                        else if(salesNextEst.FY_TOTAL != null && salesNextEst.FY_TOTAL != ''){
                            m68Data.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68Data.Fiscal_Year__c = nextEstFiscalYear;
                            m68Data.Financial_type__c = 'Estimated';
                            m68Data.Net_sales__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextEstFiscalYear+'@Estimated';
                            if(YearToMissingFinancialYearMap.get(nextEstFiscalYear) != null){
                                m68Data.CA_Name__c = YearToMissingFinancialYearMap.get(nextEstFiscalYear)[0];
                                m68Data.CA_Number__c = YearToMissingFinancialYearMap.get(nextEstFiscalYear)[1];
                            }
                            m68dataMapToInsert.put('EST_NEXT_FY',m68Data);
                        }
                    }
                    if(customObj.FINANCIALS.SALES.ACTUAL_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.SALES.ACTUAL_CURRENT_FY;
                        if(salesCurrentAct.LOS_ID != null && salesCurrentAct.LOS_ID != ''){
                            m68Data.Id = salesCurrentAct.LOS_ID;
                            m68Data.Net_sales__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@Actual';
                            //m68DataList.add(m68ActCurrent);
                            m68dataMapToUpdate.put('ACTUAL_CURRENT_FY',m68Data);
                        }
                        else if(salesCurrentAct.FY_TOTAL != null && salesCurrentAct.FY_TOTAL != ''){
                            m68Data.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68Data.Fiscal_Year__c = currentFY;
                            m68Data.Financial_type__c = 'Actual';
                            m68Data.Net_sales__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@Actual';
                            if(YearToMissingFinancialYearMap.get(currentFY) != null){
                                m68Data.CA_Name__c = YearToMissingFinancialYearMap.get(currentFY)[0];
                                m68Data.CA_Number__c = YearToMissingFinancialYearMap.get(currentFY)[1];
                            }
                            m68dataMapToInsert.put('ACTUAL_CURRENT_FY',m68Data);
                        }
                    }
                    if(customObj.FINANCIALS.SALES.ACTUAL_PREV_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.SALES.ACTUAL_PREV_FY;
                        if(salesCurrentAct.LOS_ID != null && salesCurrentAct.LOS_ID != ''){
                            m68Data.Id = salesCurrentAct.LOS_ID;
                            m68Data.Net_sales__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+prevFY+'@Actual';
                            //m68DataList.add(m68ActCurrent);
                            m68dataMapToUpdate.put('ACTUAL_PREV_FY',m68Data);
                        }
                        else if(salesCurrentAct.FY_TOTAL != null && salesCurrentAct.FY_TOTAL != ''){ //n_1_FY
                            m68Data.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68Data.Fiscal_Year__c = prevFY;
                            m68Data.Financial_type__c = 'Actual';
                            m68Data.Net_sales__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+prevFY+'@Actual';
                            if(YearToMissingFinancialYearMap.get(prevFY) != null){
                                m68Data.CA_Name__c = YearToMissingFinancialYearMap.get(prevFY)[0];
                                m68Data.CA_Number__c = YearToMissingFinancialYearMap.get(prevFY)[1];
                            }
                            m68dataMapToInsert.put('ACTUAL_PREV_FY',m68Data);
                        }
                    }
                    if(customObj.FINANCIALS.SALES.ACTUAL_N_1_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.SALES.ACTUAL_N_1_FY;
                        if(salesCurrentAct.LOS_ID != null && salesCurrentAct.LOS_ID != ''){
                            m68Data.Id = salesCurrentAct.LOS_ID;
                            m68Data.Net_sales__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+n_1_FY+'@Actual';
                            //m68DataList.add(m68ActCurrent);
                            m68dataMapToUpdate.put('ACTUAL_N_1_FY',m68Data);
                        }
                        else if(salesCurrentAct.FY_TOTAL != null && salesCurrentAct.FY_TOTAL != ''){
                            m68Data.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68Data.Fiscal_Year__c = n_1_FY;
                            m68Data.Financial_type__c = 'Actual';
                            m68Data.Net_sales__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68Data.External_Id__c =  customObj.CUSTOMER_ID+'@'+n_1_FY+'@Actual';
                            if(YearToMissingFinancialYearMap.get(n_1_FY) != null){
                                m68Data.CA_Name__c = YearToMissingFinancialYearMap.get(n_1_FY)[0];
                                m68Data.CA_Number__c = YearToMissingFinancialYearMap.get(n_1_FY)[1];
                            }
                            m68dataMapToInsert.put('ACTUAL_N_1_FY',m68Data);
                        }
                    }
                }
                if(customObj.FINANCIALS.PURCHASE != null){//m68dataMapToUpdate m68dataMapToInsert
                    if(customObj.FINANCIALS.PURCHASE.YTD_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentYTD  = customObj.FINANCIALS.PURCHASE.YTD_CURRENT_FY; 
                        if(salesCurrentYTD.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToUpdate.get('YTD_CURRENT_FY').Purchases__c = currencyFormatter(salesCurrentYTD.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToInsert.get('YTD_CURRENT_FY').Purchases__c = currencyFormatter(salesCurrentYTD.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PURCHASE.PROJ_NEXT2_FY != null){
                        Customer360view.cls_FY salesNext2Proj  = customObj.FINANCIALS.PURCHASE.PROJ_NEXT2_FY;   
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNext2Proj.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToUpdate.get('PROJ_NEXT2_FY').Purchases__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToInsert.get('PROJ_NEXT2_FY').Purchases__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PURCHASE.EST_NEXT_FY != null){
                        Customer360view.cls_FY salesNextEst  = customObj.FINANCIALS.PURCHASE.EST_NEXT_FY;  
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNextEst.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToUpdate.get('EST_NEXT_FY').Purchases__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToInsert.get('EST_NEXT_FY').Purchases__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PURCHASE.ACTUAL_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.PURCHASE.ACTUAL_CURRENT_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToUpdate.get('ACTUAL_CURRENT_FY').Purchases__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToInsert.get('ACTUAL_CURRENT_FY').Purchases__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PURCHASE.ACTUAL_PREV_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.PURCHASE.ACTUAL_PREV_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToUpdate.get('ACTUAL_PREV_FY').Purchases__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToInsert.get('ACTUAL_PREV_FY').Purchases__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PURCHASE.ACTUAL_N_1_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.PURCHASE.ACTUAL_N_1_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToUpdate.get('ACTUAL_N_1_FY').Purchases__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToInsert.get('ACTUAL_N_1_FY').Purchases__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                }
                if(customObj.FINANCIALS.SUNDARY_CREDITOR_AEP != null){
                    if(customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.PROJ_NEXT2_FY != null){
                        Customer360view.cls_FY salesNext2Proj  = customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.PROJ_NEXT2_FY;   
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNext2Proj.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToUpdate.get('PROJ_NEXT2_FY').Sundry_Creditors__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToInsert.get('PROJ_NEXT2_FY').Sundry_Creditors__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.EST_NEXT_FY != null){
                        Customer360view.cls_FY salesNextEst  = customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.EST_NEXT_FY;  
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNextEst.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToUpdate.get('EST_NEXT_FY').Sundry_Creditors__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToInsert.get('EST_NEXT_FY').Sundry_Creditors__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_CURRENT_FY != null){
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_CURRENT_FY;  
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToUpdate.get('ACTUAL_CURRENT_FY').Sundry_Creditors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToInsert.get('ACTUAL_CURRENT_FY').Sundry_Creditors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_PREV_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_PREV_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToUpdate.get('ACTUAL_PREV_FY').Sundry_Creditors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToInsert.get('ACTUAL_PREV_FY').Sundry_Creditors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_N_1_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_N_1_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToUpdate.get('ACTUAL_N_1_FY').Sundry_Creditors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToInsert.get('ACTUAL_N_1_FY').Sundry_Creditors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.YTD_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.SUNDARY_CREDITOR_AEP.YTD_CURRENT_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToUpdate.get('YTD_CURRENT_FY').Sundry_Creditors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToInsert.get('YTD_CURRENT_FY').Sundry_Creditors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                }
                if(customObj.FINANCIALS.DEBITOR_AEP != null){
                    if(customObj.FINANCIALS.DEBITOR_AEP.PROJ_NEXT2_FY != null){
                        Customer360view.cls_FY salesNext2Proj  = customObj.FINANCIALS.DEBITOR_AEP.PROJ_NEXT2_FY;  
                        if(salesNext2Proj.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToUpdate.get('PROJ_NEXT2_FY').Sundry_Debtors__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToInsert.get('PROJ_NEXT2_FY').Sundry_Debtors__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.DEBITOR_AEP.EST_NEXT_FY != null){
                        Customer360view.cls_FY salesNextEst  = customObj.FINANCIALS.DEBITOR_AEP.EST_NEXT_FY;  
                        if(salesNextEst.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToUpdate.get('EST_NEXT_FY').Sundry_Debtors__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToInsert.get('EST_NEXT_FY').Sundry_Debtors__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.DEBITOR_AEP.ACTUAL_CURRENT_FY != null){
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.DEBITOR_AEP.ACTUAL_CURRENT_FY;  
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToUpdate.get('ACTUAL_CURRENT_FY').Sundry_Debtors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToInsert.get('ACTUAL_CURRENT_FY').Sundry_Debtors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.DEBITOR_AEP.ACTUAL_PREV_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.DEBITOR_AEP.ACTUAL_PREV_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToUpdate.get('ACTUAL_PREV_FY').Sundry_Debtors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToInsert.get('ACTUAL_PREV_FY').Sundry_Debtors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.DEBITOR_AEP.ACTUAL_N_1_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.DEBITOR_AEP.ACTUAL_N_1_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToUpdate.get('ACTUAL_N_1_FY').Sundry_Debtors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToInsert.get('ACTUAL_N_1_FY').Sundry_Debtors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                  if(customObj.FINANCIALS.DEBITOR_AEP.YTD_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.DEBITOR_AEP.YTD_CURRENT_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToUpdate.get('YTD_CURRENT_FY').Sundry_Debtors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToInsert.get('YTD_CURRENT_FY').Sundry_Debtors__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                }

                Map<String,Map<String,M68_Balance_Sheet_Analysis__c>> m68datamap=new Map<String,Map<String,M68_Balance_Sheet_Analysis__c>>();
                
                if(customObj!=null){
                    System.debug('m68dataMapToInsert ==== '+m68dataMapToInsert);
                    System.debug('m68dataMapToUpdate ==== '+m68dataMapToUpdate);
                    m68datamap=createm68dataforLBOthersPM(customObj,m68dataMapToInsert,m68dataMapToUpdate);
                    if(m68datamap!=null && !m68datamap.isEmpty()){
                        if(m68datamap.get('m68dataMapToUpdate')!=null && !m68datamap.get('m68dataMapToUpdate').isEmpty()){
                            m68dataMapToUpdate.putall(m68datamap.get('m68dataMapToUpdate'));
                        }
                        if(m68datamap.get('m68dataMapToInsert')!=null && !m68datamap.get('m68dataMapToInsert').isEmpty()){
                            m68dataMapToInsert.putall(m68datamap.get('m68dataMapToInsert'));
                        }
                    }
                }
                
                if(!m68dataMapToUpdate.isEmpty()){ 
                    UPDATE m68dataMapToUpdate.values() ;
                }
                if(!m68dataMapToInsert.isEmpty()){
                    UPSERT m68dataMapToInsert.values() External_Id__c;
                }
            }
            
            If(customObj.DEBTORS_CREDITORS_DETAILS !=null){
                Customer360view.cls_DEBTORS_CREDITORS_INFO      debtorsCREDITORSInfoObj     =   customObj.DEBTORS_CREDITORS_DETAILS;
                If(debtorsCREDITORSInfoObj !=null){
                    List<Customer360view.cls_DEBTORS_CREDITORS> listDebotorsAsFinacialEnd   =   debtorsCREDITORSInfoObj.DEBOTORS_AS_FINACIAL_END;
                    If(listDebotorsAsFinacialEnd !=null && listDebotorsAsFinacialEnd.size() > 0){
                        for(Customer360view.cls_DEBTORS_CREDITORS   debotorsAsFinacialEndObj    :   listDebotorsAsFinacialEnd){
                            Debtors__c  debtorObj                               = new Debtors__c();
                            If(debotorsAsFinacialEndObj !=null){
                                
                                If(!Utility.ISStringBlankorNull(debotorsAsFinacialEndObj.NAME))
                                    debtorObj.Customer_Name__c                  =   debotorsAsFinacialEndObj.NAME;
                                If(!Utility.ISStringBlankorNull(debotorsAsFinacialEndObj.AGE))
                                    debtorObj.Age__c                            =   debotorsAsFinacialEndObj.AGE;
                                If(!Utility.ISStringBlankorNull(debotorsAsFinacialEndObj.AMOUNT))
                                    debtorObj.Amount_Collected__c               =   SMELoan_Helper.currencyFormatter(debotorsAsFinacialEndObj.AMOUNT);
                                
                                debtorObj.Fiscal_Year__c                        =   currentFY;
                                If(!Utility.ISStringBlankorNull(customObj.LOS_CUSTOMER_SF_ID))
                                    debtorObj.Account__c                        =   customObj.LOS_CUSTOMER_SF_ID;
                                If(!Utility.ISStringBlankorNull(debotorsAsFinacialEndObj.LOS_RECORD_ID)){
                                    debtorObj.id                                =   debotorsAsFinacialEndObj.LOS_RECORD_ID;
                                    listDebtorsupdate.add(debtorObj);
                                }else{
                                    listDebtorsInsert.add(debtorObj);
                                }
                            }
                        }
                    }
                    List<Customer360view.cls_DEBTORS_CREDITORS> listDebotorsAsCurrentDate   =   debtorsCREDITORSInfoObj.DEBOTORS_AS_CURRENT_DATE;
                    If(listDebotorsAsCurrentDate !=null && listDebotorsAsCurrentDate.size() > 0){
                        for(Customer360view.cls_DEBTORS_CREDITORS   debotorsAsCurrentDateObj    :   listDebotorsAsCurrentDate){
                            Debtors__c  debtorObj                               = new Debtors__c();
                            If(debotorsAsCurrentDateObj !=null){
                                
                                If(!Utility.ISStringBlankorNull(debotorsAsCurrentDateObj.NAME))
                                    debtorObj.Customer_Name__c                  =   debotorsAsCurrentDateObj.NAME;
                                If(!Utility.ISStringBlankorNull(debotorsAsCurrentDateObj.AGE))
                                    debtorObj.Age__c                            =   debotorsAsCurrentDateObj.AGE;
                                If(!Utility.ISStringBlankorNull(debotorsAsCurrentDateObj.AMOUNT))
                                    debtorObj.Amount_Collected__c               =   SMELoan_Helper.currencyFormatter(debotorsAsCurrentDateObj.AMOUNT);
                                
                                debtorObj.Fiscal_Year__c                        =   nextEstFiscalYear;
                                If(!Utility.ISStringBlankorNull(customObj.LOS_CUSTOMER_SF_ID))
                                    debtorObj.Account__c                        =   customObj.LOS_CUSTOMER_SF_ID;
                                
                                If(!Utility.ISStringBlankorNull(debotorsAsCurrentDateObj.LOS_RECORD_ID)){
                                    debtorObj.id                                =   debotorsAsCurrentDateObj.LOS_RECORD_ID;
                                    listDebtorsupdate.add(debtorObj);
                                }else{
                                    listDebtorsInsert.add(debtorObj);
                                }
                            }
                        }
                    }
                    List<Customer360view.cls_DEBTORS_CREDITORS> listCreditorsAsFinacialEnd  =   debtorsCREDITORSInfoObj.CREDITORS_AS_FINACIAL_END;
                    If(listCreditorsAsFinacialEnd !=null && listCreditorsAsFinacialEnd.size() > 0){
                        for(Customer360view.cls_DEBTORS_CREDITORS   creditorsAsFinacialEndObj  :   listCreditorsAsFinacialEnd){
                            Sundry_Creditors__c     sundryCreditorsObj          =   new Sundry_Creditors__c();
                            If(creditorsAsFinacialEndObj !=null){
                                If(!Utility.ISStringBlankorNull(creditorsAsFinacialEndObj.NAME))
                                    sundryCreditorsObj.Name_Of_Trade_Creditors__c       =   creditorsAsFinacialEndObj.NAME;
                                If(!Utility.ISStringBlankorNull(creditorsAsFinacialEndObj.AGE))
                                    sundryCreditorsObj.Age__c                           =   creditorsAsFinacialEndObj.AGE;
                                If(!Utility.ISStringBlankorNull(creditorsAsFinacialEndObj.AMOUNT))
                                    sundryCreditorsObj.Amount_To_Be_Paid__c             =   SMELoan_Helper.currencyFormatter(creditorsAsFinacialEndObj.AMOUNT);
                                
                                sundryCreditorsObj.Fiscal_Year__c                       =   currentFY;
                                If(!Utility.ISStringBlankorNull(customObj.LOS_CUSTOMER_SF_ID))
                                    sundryCreditorsObj.Account__c                       =   customObj.LOS_CUSTOMER_SF_ID;
                                If(!Utility.ISStringBlankorNull(creditorsAsFinacialEndObj.LOS_RECORD_ID)){
                                    sundryCreditorsObj.id                               =   creditorsAsFinacialEndObj.LOS_RECORD_ID;
                                    listSundryCreditorupdate.add(sundryCreditorsObj);
                                }else{
                                    listSundryCreditorInsert.add(sundryCreditorsObj);
                                }
                            }
                        }
                    }
                    List<Customer360view.cls_DEBTORS_CREDITORS> listCreditorsAsCurrentDate  =   debtorsCREDITORSInfoObj.CREDITORS_AS_CURRENT_DATE;
                    If(listCreditorsAsCurrentDate !=null && listCreditorsAsCurrentDate.size() > 0){
                        for(Customer360view.cls_DEBTORS_CREDITORS   creditorsAsCurrentDateObj   :   listCreditorsAsCurrentDate){
                            Sundry_Creditors__c     sundryCreditorsObj          =   new Sundry_Creditors__c();
                            If(creditorsAsCurrentDateObj !=null){
                                If(!Utility.ISStringBlankorNull(creditorsAsCurrentDateObj.NAME))
                                    sundryCreditorsObj.Name_Of_Trade_Creditors__c       =   creditorsAsCurrentDateObj.NAME;
                                If(!Utility.ISStringBlankorNull(creditorsAsCurrentDateObj.AGE))
                                    sundryCreditorsObj.Age__c                           =   creditorsAsCurrentDateObj.AGE;
                                If(!Utility.ISStringBlankorNull(creditorsAsCurrentDateObj.AMOUNT))
                                    sundryCreditorsObj.Amount_To_Be_Paid__c             =   SMELoan_Helper.currencyFormatter(creditorsAsCurrentDateObj.AMOUNT);
                                
                                sundryCreditorsObj.Fiscal_Year__c                       =   nextEstFiscalYear;
                                If(!Utility.ISStringBlankorNull(customObj.LOS_CUSTOMER_SF_ID))
                                    sundryCreditorsObj.Account__c                       =   customObj.LOS_CUSTOMER_SF_ID;
                                
                                If(!Utility.ISStringBlankorNull(creditorsAsCurrentDateObj.LOS_RECORD_ID)){
                                    sundryCreditorsObj.id                               =   creditorsAsCurrentDateObj.LOS_RECORD_ID;
                                    listSundryCreditorupdate.add(sundryCreditorsObj);
                                }else{
                                    listSundryCreditorInsert.add(sundryCreditorsObj);
                                }
                            }
                        }
                    }
                    
                }
            }
            // COMPANY_DETAILS
            If(!Utility.ISStringBlankorNull(customObj.LOS_CUSTOMER_SF_ID)){
                acc.id                                                          = customObj.LOS_CUSTOMER_SF_ID;
                currentCustomer                                                 = Utility.getAccountdetails(customObj.LOS_CUSTOMER_SF_ID);
                
                custFinancialYear                                               = currentCustomer.Limit_Assesment_Final_Financial_Year__c;
                custFinancialMonth                                              = currentCustomer.Limit_Assesment_Final_Month__c;
                custFinancialclosingBal                                         = Integer.valueOf(currentCustomer.Limit_Assesment_Closing_Balance__c);
                
            }
            System.debug('#######'+appInfo[0].Industry_Type__c+'mmm'+currentCustomer.Line_of_Activity__c);
            if(appInfo[0].Industry_Type__c != null && currentCustomer.Line_of_Activity__c != null){
                List<Line_Of_Activity__mdt> lineOfactivity= [select Unique_Key__c,Line_Of_Activity__c,Activity_Value__c from Line_Of_Activity__mdt
                where Line_Of_Activity__c=: appInfo[0].Industry_Type__c.toUpperCase() AND Activity_Value__c=: currentCustomer.Line_of_Activity__c];
                System.debug('#######'+lineOfactivity);
                if(lineOfactivity.size()>0){
                    app.UNIQUE_KEY__c= lineOfactivity[0].Unique_Key__c;
                }
            }


            If(customObj.COMPANY_DETAILS !=null) {
                if(customObj.COMPANY_DETAILS !=null && customObj.COMPANY_DETAILS.OVERALL_EXPOSURE != null){
                    acc.Overall_Exposure__c =  SOQL_Util.getOverallExposure(customObj.LOS_CUSTOMER_SF_ID);
                    //System.debug('@@@@@@@@@@@@@@@@'+acc.Overall_Exposure__c);
                }
                Customer360view.cls_COMPANY_DETAILS cusPrmDetail     = customObj.COMPANY_DETAILS;
                
                if(cusPrmDetail != null){
                    If(!Utility.ISStringBlankorNull(cusPrmDetail.BORROWER_NAME))
                        acc.Name                               = cusPrmDetail.BORROWER_NAME;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY)) {
                            System.debug('########'+customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY);
                          acc.Line_of_Activity__c = customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY;
                    }
                    /*Added for Term LOAN Change*/
                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PROFIT_AFTER_TAX))
                        acc.Profit_after_tax__c = Decimal.valueOf(customObj.COMPANY_DETAILS.PROFIT_AFTER_TAX);
                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.NET_FIXED_ASSET_LAND_AND_BUILDING))
                        acc.Net_Fixed_Asset_Land_and_Building__c = Decimal.valueOf(customObj.COMPANY_DETAILS.NET_FIXED_ASSET_LAND_AND_BUILDING);
                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.NET_FIXED_ASSET_PLANT_AND_MACHINERY))
                        acc.Net_Fixed_Asset_Plant_and_Machinery__c = Decimal.valueOf(customObj.COMPANY_DETAILS.NET_FIXED_ASSET_PLANT_AND_MACHINERY);
                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PREVIOUS_YEAR_GROWTH_RATE))
                        acc.Previous_Year_Growth_Rate__c = Decimal.valueOf(customObj.COMPANY_DETAILS.PREVIOUS_YEAR_GROWTH_RATE);
                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.UDYOG_ADHAAR_NUMBER))
                        acc.Udyog_Adhaar_Number__c = Decimal.valueOf(customObj.COMPANY_DETAILS.UDYOG_ADHAAR_NUMBER);

                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PRIMARY_BANK_NAME))
                        acc.Primary_Bank_Name__c = customObj.COMPANY_DETAILS.PRIMARY_BANK_NAME;
                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PRIMARY_IFSC_CODE))
                        acc.Primary_IFSC_Code__c = customObj.COMPANY_DETAILS.PRIMARY_IFSC_CODE;
                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PRIMARY_BRANCH_NAME))
                        acc.Primary_Branch_Name__c = customObj.COMPANY_DETAILS.PRIMARY_BRANCH_NAME;
                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PRIMARY_ACCOUNT_NUMBER))
                        acc.Primary_Account_Number__c = customObj.COMPANY_DETAILS.PRIMARY_ACCOUNT_NUMBER;

                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY_CODE))
                        acc.Line_of_Activity_code__c = customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY_CODE;
                    
                    if (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.CIN_NUMBER)){
                        acc.CIN_Number__c = customObj.COMPANY_DETAILS.CIN_NUMBER;
                        if(customObj.APP_TYPE != 'SME_Exceeding'){
                            Boolean flag  = SOQL_Util.getApplicationProbe42(customObj.LOS_APPLICATION_ID);
                            If(!flag){
                                //call future method for probe 42 data
                                getProbeDetails(customObj.LOS_CUSTOMER_SF_ID,customObj.LOS_APPLICATION_ID);
                            }
                        }
                    }
                    If(!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.REASONS_FOR_GST_NOT_APPLICABLE)){
                        acc.Reasons_for_exemption_from_GST__c = customObj.COMPANY_DETAILS.REASONS_FOR_GST_NOT_APPLICABLE;
                    }
                    If(!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.TURNOVER))
                        acc.Annual_TurnoverIncome__c            = Decimal.valueOf(customObj.COMPANY_DETAILS.TURNOVER);
                    If(!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PRINCIPAL_NATURE_OF_BUSINESS))
                        acc.Principal_nature_of_business__c     = customObj.COMPANY_DETAILS.PRINCIPAL_NATURE_OF_BUSINESS;
                    If(!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.IE_CODE_NUMBER)){
                        acc.IE_Code__c = customObj.COMPANY_DETAILS.IE_CODE_NUMBER;
                    }
                    If(!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PRIORITY)){
                        If(customObj.COMPANY_DETAILS.PRIORITY=='Yes' || customObj.COMPANY_DETAILS.PRIORITY =='True' || customObj.COMPANY_DETAILS.PRIORITY =='1'){
                            acc.Priority_Sector__c = true;    
                        }else{
                            acc.Priority_Sector__c = false;
                        }    
                    }
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.UAM_NUMBER))
                        acc.UAM_Number__c = customObj.COMPANY_DETAILS.UAM_NUMBER;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.MAJOR_ACTIVITY))
                        acc.Major_Activity__c = customObj.COMPANY_DETAILS.MAJOR_ACTIVITY;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.ENTERPRISE_TYPE))
                        acc.Enterprise_Type__c = customObj.COMPANY_DETAILS.ENTERPRISE_TYPE;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.ACTIVITY_TYPE))
                        acc.Activity_Type__c = customObj.COMPANY_DETAILS.ACTIVITY_TYPE;
                    
                    If(!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.DATE_OF_INCORPORATION)){
                        acc.Date_of_Incorporation__c = Date.valueOf(customObj.COMPANY_DETAILS.DATE_OF_INCORPORATION);
                        Integer incorporationYear  =  Integer.valueOf(customObj.COMPANY_DETAILS.DATE_OF_INCORPORATION.split('-')[0]);
                        Integer currentYearIN      = Utility.getCurrentYear();
                        
                        If(incorporationYear > (currentYearIN -2)){
                            
                            app.New_to_Business__c = true;
                        }else if(incorporationYear == (currentYearIN -2)){
                            
                            Integer incorporationMonth  =  Integer.valueOf(customObj.COMPANY_DETAILS.DATE_OF_INCORPORATION.split('-')[1]);
                            Integer incorporationDay  =  Integer.valueOf(customObj.COMPANY_DETAILS.DATE_OF_INCORPORATION.split('-')[2]);
                            if(incorporationMonth < 04 || incorporationMonth < 4){
                                app.New_to_Business__c = false; 
                            }else if(incorporationDay > 1 && (incorporationMonth >= 04 || incorporationMonth >= 4)){
                                app.New_to_Business__c = true;  
                            }else{
                               app.New_to_Business__c = false; 
                            } 
                        }else{
                            app.New_to_Business__c = false;
                           
                        }
                    }
                    
                    If(!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.RECONSTITUTED)){
                        If(customObj.COMPANY_DETAILS.RECONSTITUTED=='Yes' || customObj.COMPANY_DETAILS.RECONSTITUTED =='True' || customObj.COMPANY_DETAILS.RECONSTITUTED =='1'){
                            acc.Firm_Company_was_Reconstituted__c = true;    
                        }else{
                            acc.Firm_Company_was_Reconstituted__c = false;
                        }    
                    }
                    
                    Customer360view.cls_COMPANY_PRIMARY_DETAILS cusDetailPRM = customObj.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS;
                    if(cusDetailPRM != null){
                        If (!Utility.ISStringBlankorNull(cusDetailPRM.NAME_OF_THE_GROUP))
                            acc.Group_Name__c = cusDetailPRM.NAME_OF_THE_GROUP;
                        If (!Utility.ISStringBlankorNull(cusDetailPRM.NAME))
                            acc.Name__c = cusDetailPRM.NAME;
                        
                        If (!Utility.ISStringBlankorNull(cusDetailPRM.INDUSTRY_TYPE)){
                            acc.Industry_Type__c = cusDetailPRM.INDUSTRY_TYPE;
                            app.Industry_type_Application__c = cusDetailPRM.INDUSTRY_TYPE;

                            If((customObj.TYPE.contains('ETB-CA') || customObj.TYPE.contains('NTB'))&& ((cusDetailPRM.INDUSTRY_TYPE == 'Services' || cusDetailPRM.INDUSTRY_TYPE =='Education'))){
                                acc.Cash_Budget__c = true;
                            }
                        }
                        If (!Utility.ISStringBlankorNull(cusDetailPRM.GST_NUMBER)) {
                            acc.GST_Number__c = cusDetailPRM.GST_NUMBER;
                            genesis__Applications__c appObject = getApplicationById(customObj.LOS_APPLICATION_ID);
                            If(appObject !=null && appObject.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                getGSTR38Details(customObj.LOS_CUSTOMER_SF_ID,customObj.LOS_APPLICATION_ID,cusDetailPRM.GST_NUMBER);
                            }
                        }     
                    }
                    
                    If(customObj.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS !=null && customObj.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS != null){
                        Customer360view.cls_CONSTITUTION_DETAILS cusReCnstDetail     = customObj.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS;
                        If(cusReCnstDetail !=null){
                            If(cusReCnstDetail.CONSTITUTION !=null)
                                acc.Constitution__c                     = cusReCnstDetail.CONSTITUTION;
                            If(cusReCnstDetail.RECONSTITUTION_DATE !=null && cusReCnstDetail.RECONSTITUTION_DATE != '')
                                acc.Latest_Date_Of_Reconstitution__c    = Date.valueOf(cusReCnstDetail.RECONSTITUTION_DATE);
                        }
                    }
                }
                List<Customer360view.cls_GROUP_CONCERN_DETAILS> listGroupConcern = customObj.COMPANY_DETAILS.GROUP_CONCERN_DETAILS;
                if (listGroupConcern != null && listGroupConcern.size() > 0) {
                    for (Customer360view.cls_GROUP_CONCERN_DETAILS groupConcernObj : listGroupConcern) {
                        Group_Concern__c gcObject = new Group_Concern__c();
                        if (groupConcernObj != null) {
                            If (!Utility.ISStringBlankorNull(groupConcernObj.GROUP_CONCERN_ID))
                                gcObject.id = groupConcernObj.GROUP_CONCERN_ID;
                            If (!Utility.ISStringBlankorNull(groupConcernObj.PAN_NUMBER))
                                gcObject.Pan_card_Number__c = groupConcernObj.PAN_NUMBER;
                            If (!Utility.ISStringBlankorNull(groupConcernObj.BANK_NAME))
                                gcObject.Bank_Name__c = groupConcernObj.BANK_NAME;
                            If (!Utility.ISStringBlankorNull(groupConcernObj.FIRM_RELATED_NAME))
                                gcObject.Related_firm_Name__c = groupConcernObj.FIRM_RELATED_NAME;
                            If (!Utility.ISStringBlankorNull(groupConcernObj.LIMIT_AMOUNT))
                                gcObject.Limit_Amount__c = Decimal.valueOf(groupConcernObj.LIMIT_AMOUNT);
                            If (!Utility.ISStringBlankorNull(groupConcernObj.TYPE))
                                gcObject.Type__c = groupConcernObj.TYPE;
                            if (groupConcernObj.GROUP_CONCERN_ID != null && groupConcernObj.GROUP_CONCERN_ID != '') {
                                
                                if(groupConcernObj.IS_DELETED){
                                    listGroupConDelete.add(gcObject);
                                }else{
                                    listGroupConUpdate.add(gcObject);
                                }
                                
                            }
                                                        
                            else{
                                gcObject.Group_1__c = customObj.LOS_CUSTOMER_SF_ID;
                                listGroupConInsert.add(gcObject);
                            }
                        }
                    }
                }
            }
            
            //COMPANY_COMMUNICATION_DETAILS
            If(customObj.COMPANY_DETAILS !=null && customObj.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS !=null) {
                Customer360view.cls_COMPANY_COMMUNICATION_DETAILS cusCmpCommDetail  = customObj.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS;
                If(cusCmpCommDetail !=null){
                    If(cusCmpCommDetail.REGISTERED_OFFICE_ADDRESS !=null) {
                        Customer360view.cls_ADDRESS  cusCmpAdd                          = cusCmpCommDetail.REGISTERED_OFFICE_ADDRESS;
                        If(!Utility.ISStringBlankorNull(cusCmpAdd.STREET))
                            acc.BillingStreet                                           = cusCmpAdd.STREET;
                        If(!Utility.ISStringBlankorNull(cusCmpAdd.CITY))
                            acc.BillingCity                                             = cusCmpAdd.CITY;
                        If(!Utility.ISStringBlankorNull(cusCmpAdd.PIN_CODE))
                            acc.BillingPostalCode                                       = cusCmpAdd.PIN_CODE;
                        If(!Utility.ISStringBlankorNull(cusCmpAdd.STATE))
                            acc.BillingState                                            = cusCmpAdd.STATE;
                        acc.BillingCountry                                              = 'India';
                    }
                    If(cusCmpCommDetail.CORPORATE_OFFICE_ADDRESS !=null) {
                        Customer360view.cls_ADDRESS  cusCmpAdd                  = cusCmpCommDetail.CORPORATE_OFFICE_ADDRESS;
                        If(!Utility.ISStringBlankorNull(cusCmpAdd.STREET))
                            acc.ShippingStreet                                           = cusCmpAdd.STREET;
                        If(!Utility.ISStringBlankorNull(cusCmpAdd.CITY))
                            acc.ShippingCity                                             = cusCmpAdd.CITY;
                        If(!Utility.ISStringBlankorNull(cusCmpAdd.PIN_CODE))
                            acc.ShippingPostalCode                                       = cusCmpAdd.PIN_CODE;
                        If(!Utility.ISStringBlankorNull(cusCmpAdd.STATE))
                            acc.ShippingState                                            = cusCmpAdd.STATE;
                       acc.ShippingCountry                                               = 'India';
                    }
                    If(!Utility.ISStringBlankorNull(cusCmpCommDetail.CONTACT_PERSON_NAME))
                        acc.Contact_Person_Name__c                                      = cusCmpCommDetail.CONTACT_PERSON_NAME;
                    If(!Utility.ISStringBlankorNull(cusCmpCommDetail.CONTACT_NUMBER))
                        acc.Cust_mobile_phone__c                                        = cusCmpCommDetail.CONTACT_NUMBER;
                    If(!Utility.ISStringBlankorNull(cusCmpCommDetail.EMAIL_ADDRESS))
                        acc.Company_Email__c                                            = cusCmpCommDetail.EMAIL_ADDRESS;
                }
            }
            //SME NEW Loan Facility Insert.
            If(customObj.COMPANY_DETAILS !=null && customObj.COMPANY_DETAILS.NEW_LOAN_FACILITY_DETAILS !=null){
                //System.debug('New Loan facility Details----> 1029');
                genesis__Applications__c appObject = getApplicationById(customObj.LOS_APPLICATION_ID);
                If(appObject !=null && appObject.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    
                    SMELoan_Helper_Handler.createFacilityForNewLoan(customObj.COMPANY_DETAILS.NEW_LOAN_FACILITY_DETAILS,appObject.Id,appObject.genesis__Account__c);
                    System.debug('SMELoan_Helper_Handler.Application_Type @@@@@'+ SMELoan_Helper_Handler.Application_Type);
                    If(SMELoan_Helper_Handler.Application_Type !=null && SMELoan_Helper_Handler.Application_Type !=''){
                       app.Type__c      =   SMELoan_Helper_Handler.Application_Type;
                        If(SMELoan_Helper_Handler.Application_Type.contains('Takeover')){
                            app.New_to_Business__c = false;    
                        } 
                    }else{
                        System.debug('customObj.TYPE @@@'+customObj.TYPE);
                        if(customObj.TYPE.contains('Takeover')){
                            if(customObj.TYPE.contains('ETB-WC')){
                                app.Type__c  = 'ETB-WC';    
                            }else if(customObj.TYPE.contains('ETB-CA')){
                                app.Type__c  = 'ETB-CA';    
                            }else if(customObj.TYPE.contains('NTB')){
                                app.Type__c  = 'NTB';   
                            }    
                        }
                    }
                    If(!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.NEW_LOAN_FACILITY_DETAILS.APPLICATION_EXPOSURE)){
                        app.New_Loan_Application_Exposure__c  =  Decimal.valueOf(customObj.COMPANY_DETAILS.NEW_LOAN_FACILITY_DETAILS.APPLICATION_EXPOSURE);      
                    }
                } 
            }
            // REJECCTED KEY_PERSON_DETAILS
            If(customObj.COMPANY_DETAILS !=null && customObj.COMPANY_DETAILS .REJECTED_KEY_PERSON !=null){
                Map<Id,genesis__Application_Parties__c>  mapOfParties = new Map<Id,genesis__Application_Parties__c>([select id,genesis__Party_Account_Name__r.Name,genesis__Party_Account_Name__r.CBS_Customer_ID__c,Active__c,Is_New__c,genesis__Application__c from genesis__Application_Parties__c WHERE genesis__Application__c =:customObj.LOS_APPLICATION_ID AND Active__c = true]);
                If(mapOfParties !=null && mapOfParties.size() > 0){
                    List<Customer360view.cls_REJECTED_KEY_PERSON> listRejectedKeyPerson = customObj.COMPANY_DETAILS .REJECTED_KEY_PERSON;
                    If(listRejectedKeyPerson !=null && listRejectedKeyPerson.size() > 0){ 
                        for(Customer360view.cls_REJECTED_KEY_PERSON rejectedKeyPersonObj : listRejectedKeyPerson){
                            Account partyAccountDeleteObj                  =  new Account();
                            If(mapOfParties.containsKey((Id)rejectedKeyPersonObj.ID)){
                                genesis__Application_Parties__c appPartyCheck = mapOfParties.get((Id)rejectedKeyPersonObj.ID);
                                
                                If(appPartyCheck !=null){ 
                                    If(appPartyCheck.genesis__Party_Account_Name__r.CBS_Customer_ID__c !=null){
                                        appPartyCheck.Active__c = false;
                                        appPartyCheck.Is_New__c = false;
                                        listOfRejectedParty.add(appPartyCheck);
                                        app.Sub_Stage__c= '';
                                    }else{
                                        partyAccountDeleteObj.Id = appPartyCheck.genesis__Party_Account_Name__c;
                                        deletePartyAcc.add(partyAccountDeleteObj);
                                        deleteappparty.add(appPartyCheck);
                                        app.Sub_Stage__c= '';
                                        
                                    }
                                }   
                            }
                        }
                    }
                }
            }
            //Section 20 for customer
            if(customObj.COMPANY_DETAILS != null && customObj.COMPANY_DETAILS.SECTION_20_CUSTOMER != null){
                 Customer360view.cls_SECTION_20_CUSTOMER cusSection20   = customObj.COMPANY_DETAILS.SECTION_20_CUSTOMER;
                if(cusSection20 !=null){
                    if(!Utility.ISStringBlankorNull(cusSection20.NAME_OF_DIRECTOR))
                        acc.Name_Of_Director_Related_To__c  =   cusSection20.NAME_OF_DIRECTOR; 
                    if(!Utility.ISStringBlankorNull(cusSection20.NAME_OF_BANK))
                        acc.Bank_name__c        =   cusSection20.NAME_OF_BANK;
                    if(!Utility.ISStringBlankorNull(cusSection20.NATURE_OF_RELATIONSHIP))
                        acc.Relationship__c     =   cusSection20.NATURE_OF_RELATIONSHIP;
                    if(cusSection20.SECTION_20 != null && cusSection20.SECTION_20 == 'Yes' || cusSection20.SECTION_20 =='True' || cusSection20.SECTION_20 =='1'){
                        acc.is_Section_20__c    = true;
                    }
                }
            }
            if(customObj.COMPANY_DETAILS != null && customObj.LIMIT_ASSESMENT != null){
                Id LimitAssessment_Parent_RecordType = Schema.SObjectType.Limit_Assessment__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
                Id LimitAssessment_Child_RecordType  = Schema.SObjectType.Limit_Assessment__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
                Integer currentClosingBalance = 0;
                String flagforLastMonth = '';
                Integer maxDrawingPower = 0;
                
                for(Customer360view.cls_LIMIT_ASSESMENT lim : customObj.LIMIT_ASSESMENT){
                    Limit_Assessment__c limAssP     = new Limit_Assessment__c();
                    limAssP.Year__c = lim.YEAR;
                    
                    //Condition for checking Year should not be null. If null donot perform any operation.
                    If(lim.YEAR !=null && lim.YEAR !=''){
                        limAssP.Account__c = acc.Id;
                        String External_Parent  = acc.Id+'@'+lim.YEAR;
                        limAssP.External_Id__c  =   External_Parent;
                        Integer flag =0;
                        Integer closingBalanceOfLastYear = 0;
                        String startingMonth ='';
                        If(lim.monthwiseInfo !=null)
                            for(Customer360view.cls_LIMIT_ASSESMENT_INFO limassinfo: lim.monthwiseInfo){
                                Limit_Assessment__c limAssC                     = new Limit_Assessment__c();
                                //Condition for checking Month should not be null. If null donot perform any operation for this particular Month.
                                If(limassinfo.MONTH !=null && limassinfo.MONTH !=''){
                                    if(flag==0){
                                        currentClosingBalance = custFinancialclosingBal;
                                        startingMonth=limassinfo.MONTH;
                                        flag++;
                                    }
                                    if(Utility.convertMonthTextToNumber(startingMonth) == Utility.convertMonthTextToNumber(custFinancialMonth) -1){
                                        limAssC.Opening_Balance__c                      = custFinancialclosingBal;
                                    }else{
                                        limAssC.Opening_Balance__c                      = currentClosingBalance;
                                    }
                                    limAssC.Month__c                                = limassinfo.MONTH;
                                    flagforLastMonth                                = limassinfo.MONTH;
                                    limAssC.Year__c                                 = lim.YEAR;
                                    //inflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Advances_from_customers))
                                        limAssC.Advances_from_customers__c              = Decimal.valueOf(limassinfo.Advances_from_customers);
                                    //inflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Cash_Sales_Receipts))
                                        limAssC.Cash_Sales_Receipts__c                  = Decimal.valueOf(limassinfo.Cash_Sales_Receipts);
                                    //inflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Credit_Purchases))
                                        limAssC.Credit_Purchases__c                     = Decimal.valueOf(limassinfo.Credit_Purchases);
                                    //inflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Other_receipts_if_any))
                                        limAssC.Other_receipts_if_any__c                = Decimal.valueOf(limassinfo.Other_receipts_if_any);
                                    //inflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Realization_of_debtors))
                                        limAssC.Realization_of_debtors__c               = Decimal.valueOf(limassinfo.Realization_of_debtors);
                                    //outflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Payment_of_creditors))
                                        limAssC.Payment_of_creditors__c                 = Decimal.valueOf(limassinfo.Payment_of_creditors);
                                    //outflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Payment_of_Expenses))
                                        limAssC.Payment_of_Expenses__c                  = Decimal.valueOf(limassinfo.Payment_of_Expenses);
                                    //outflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Purchases))
                                        limAssC.Purchases__c                            = Decimal.valueOf(limassinfo.Purchases);
                                    //outflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Salary_and_Wages))
                                        limAssC.Salary_and_Wages__c                     = Decimal.valueOf(limassinfo.Salary_and_Wages);
                                    //outflow
                                    If(!Utility.ISStringBlankorNull(limassinfo.Other_payments_if_any))
                                        limAssC.Other_payments_if_any__c                = Decimal.valueOf(limassinfo.Other_payments_if_any);
                                    
                                    /*
                                     Calculation related to Opening, Closing and Drawing Power
                                    */
                                    
                                    // Opening Balance for current month is Closing balance of previous month
                                    
                                    // Closing Balance  = Inflow sum + Opening Balance - Outflow Sum
                                    
                                    limAssC.Closing_Balance__c                      =((limAssC.Advances_from_customers__c  != null ?limAssC.Advances_from_customers__c:0)+ (limAssC.Cash_Sales_Receipts__c  != null ?limAssC.Cash_Sales_Receipts__c:0)+ (limAssC.Credit_Purchases__c  != null ?limAssC.Credit_Purchases__c:0)+ (limAssC.Other_receipts_if_any__c  != null ?limAssC.Other_receipts_if_any__c:0)+ (limAssC.Realization_of_debtors__c  != null ?limAssC.Realization_of_debtors__c:0))+(Integer.valueOf(limAssC.Opening_Balance__c  != null ?limAssC.Opening_Balance__c:0))-((limAssC.Payment_of_Expenses__c != null ?limAssC.Payment_of_Expenses__c:0)+ (limAssC.Payment_of_creditors__c != null ?limAssC.Payment_of_creditors__c:0) + (limAssC.Purchases__c  != null ?limAssC.Purchases__c:0) + (limAssC.Salary_and_Wages__c  != null ?limAssC.Salary_and_Wages__c:0) + (limAssC.Other_payments_if_any__c  != null ?limAssC.Other_payments_if_any__c:0));
                                    // Drawing Power is Absolute value of closing balance
                                    limAssC.Drawing_Power__c                        = math.abs(limAssC.Closing_Balance__c);
                                    if(limAssC.Drawing_Power__c > maxDrawingPower)
                                        maxDrawingPower = Integer.valueOf(limAssC.Drawing_Power__c);
                                    If(!Utility.ISStringBlankorNull(customObj.LOS_APPLICATION_ID))
                                        limAssC.Application__c                          = customObj.LOS_APPLICATION_ID;
                                    limAssC.Limit_Assessment_Info__r                = new Limit_Assessment__c(External_Id__c = External_Parent);
                                    limAssC.External_Id__c                          = acc.Id+'@'+limAssP.Year__c+'@'+limassC.Month__c;
                                    limAssC.RecordTypeId                            = LimitAssessment_Child_RecordType;
                                    
                                    currentClosingBalance                           = Integer.valueOf(limAssC.Closing_Balance__c);
                                    limassListC.add(limAssC);
                                }
                            }
                        custFinancialclosingBal = currentClosingBalance;
                        limassP.RecordTypeId = LimitAssessment_Parent_RecordType;
                        limassList.add(limassP);
                    }
                }
                // Below line update three field (Month, closing balance and drawing power on customer level ) for limit assesment
                currentCustomer.Limit_Assessment_Drawing_Power__c           = Decimal.valueOf(maxDrawingPower);
                currentCustomer.Limit_Assesment_Closing_Balance__c          = custFinancialclosingBal;
                currentCustomer.Limit_Assesment_Final_Month__c              = flagforLastMonth;
            }
            if(acc !=null && acc.Id != null)
                listaccount.add(acc);
            
            // KEY_PERSON_DETAILS
            if(listKeyPersonDetails !=null && listKeyPersonDetails.size()> 0){
                String aadharReference  = '';
                for(Customer360view.cls_KEY_PERSON_DETAILS kpd : listKeyPersonDetails){
                    Account accObj                                  = new Account();
                    If(!Utility.ISStringBlankorNull(kpd.CBS_CUSTOMER_ID))
                        accObj.CBS_Customer_ID__c                  = kpd.CBS_CUSTOMER_ID;
                    If(!Utility.ISStringBlankorNull(kpd.PASSPORT_NUMBER))
                        accObj.Passport_Number__pc                  = kpd.PASSPORT_NUMBER;
                    If(!Utility.ISStringBlankorNull(kpd.SEX))
                        accObj.Gender__pc                           = kpd.SEX;
                    If(!Utility.ISStringBlankorNull(kpd.NATIONALITY))
                        accObj.Nationality__pc                      = kpd.NATIONALITY ;
                    If(!Utility.ISStringBlankorNull(kpd.FATHER_NAME))
                        accObj.Father_Name__pc                      = kpd.FATHER_NAME;
                    If(!Utility.ISStringBlankorNull(kpd.MARITAL_STATUS))
                        accObj.Marital_Status__pc                   = kpd.MARITAL_STATUS;
                    If(!Utility.ISStringBlankorNull(kpd.SPOUSE_NAME))
                        accObj.Spouse_Name__pc                      = kpd.SPOUSE_NAME;
                    If(!Utility.ISStringBlankorNull(kpd.CASTE))
                        accObj.Caste__pc                            = kpd.CASTE;
                    If(!Utility.ISStringBlankorNull(kpd.RELIGION))
                        accObj.Religion__c                            = kpd.RELIGION;
                    If(!Utility.ISStringBlankorNull(kpd.RELIGION_CODE))
                        accObj.Religion_code__pc                      = kpd.RELIGION_CODE;
                    If(!Utility.ISStringBlankorNull(kpd.IS_PHYSTCALLY_HANDICAPPED))
                        accObj.Is_Physically_Handicapped__c         = kpd.IS_PHYSTCALLY_HANDICAPPED=='Yes'? true:false;
                    If(!Utility.ISStringBlankorNull(kpd.IS_EXSERVICE_MAN))
                        accObj.Is_Ex_Service_Man__c                 = kpd.IS_EXSERVICE_MAN=='Yes'? true:false;
                    
                    // Communication Details
                    if(kpd.COMMUNICATION_DETAILS != null){
                        Customer360view.cls_COMMUNICATION_DETAILS  objCommDetails = kpd.COMMUNICATION_DETAILS;
                        If(objCommDetails !=null){
                            If(!Utility.ISStringBlankorNull(objCommDetails.MOBILE_NUMBER))
                                accObj.PersonMobilePhone                    = objCommDetails.MOBILE_NUMBER;
                            If(!Utility.ISStringBlankorNull(objCommDetails.EMAIL_ADDRESS))
                                accObj.PersonEmail                          = objCommDetails.EMAIL_ADDRESS;
                            // PARMANENT_ADDRESS
                            If(objCommDetails.PARMANENT_ADDRESS != null) {
                                Customer360view.cls_ADDRESS  cusParAdd      = objCommDetails.PARMANENT_ADDRESS;
                                If(!Utility.ISStringBlankorNull(cusParAdd.STREET))
                                    accObj.PersonMailingStreet              = cusParAdd.STREET;
                                If(!Utility.ISStringBlankorNull(cusParAdd.CITY))
                                    accObj.PersonMailingCity                = cusParAdd.CITY;
                                If(!Utility.ISStringBlankorNull(cusParAdd.STATE))
                                    accObj.PersonMailingState               = cusParAdd.STATE;
                                If(!Utility.ISStringBlankorNull(cusParAdd.PIN_CODE))
                                    accObj.PersonMailingPostalCode          = cusParAdd.PIN_CODE;
                                If(!Utility.ISStringBlankorNull(cusParAdd.COUNTRY))
                                    accObj.PersonMailingCountry             = cusParAdd.COUNTRY;
                            }
                            //kpd.COMMUNICATION_DETAILS.ADDRESS             = null;
                        }
                    }
                    Customer360view.cls_PRIMARY_DETAILS objPrimDetails;
                    If(kpd.PRIMARY_DETAILS !=null){
                        objPrimDetails = kpd.PRIMARY_DETAILS;
                        If(objPrimDetails !=null){
                            If(!Utility.ISStringBlankorNull(objPrimDetails.LOS_PERSON_ACCOUNT_ID))
                                accObj.Id                                   =  objPrimDetails.LOS_PERSON_ACCOUNT_ID;
                            If(!Utility.ISStringBlankorNull(objPrimDetails.FIRST_NAME))
                                accObj.FirstName                            =  objPrimDetails.FIRST_NAME;
                            If(!Utility.ISStringBlankorNull(objPrimDetails.LAST_NAME)){
                                accObj.LastName                         =  objPrimDetails.LAST_NAME;
                            }
                            If(!Utility.ISStringBlankorNull(objPrimDetails.DESIGNATION))
                                accObj.Designation__pc                      = objPrimDetails.DESIGNATION;
                            If(!Utility.ISStringBlankorNull(objPrimDetails.DOB))
                                accObj.PersonBirthdate                      = Date.valueOf(objPrimDetails.DOB);
                            If(!Utility.ISStringBlankorNull(objPrimDetails.EDUCATIONAL_QUALIFICATION))
                                accObj.Education_Qualification__pc          = objPrimDetails.EDUCATIONAL_QUALIFICATION;
                            
                            If(!Utility.ISStringBlankorNull(objPrimDetails.EDUCATIONAL_QUALIFICATION_CODE))
                                accObj.Education_Qualification_code__pc     = objPrimDetails.EDUCATIONAL_QUALIFICATION_CODE;
                            
                            If(!Utility.ISStringBlankorNull(objPrimDetails.AADHAAR_NUMBER)){
                                accObj.Aadhaar_Number__pc                   = objPrimDetails.AADHAAR_NUMBER;
                                aadharReference                             = objPrimDetails.AADHAAR_NUMBER;
                                If(!Utility.ISStringBlankorNull(kpd.PARTY_TYPE))
                                    mapPartyType.put(objPrimDetails.AADHAAR_NUMBER,kpd.PARTY_TYPE);
                                If(!Utility.ISStringBlankorNull(kpd.GUARANTOR))
                                    mapPartyType.put(objPrimDetails.AADHAAR_NUMBER+'GUARANTOR',kpd.GUARANTOR);
                            }    
                            If(!Utility.ISStringBlankorNull(objPrimDetails.PAN_NUMBER)){
                                accObj.Pan_Number__c                        = objPrimDetails.PAN_NUMBER;
                            }
                        }
                    }
                    //system.debug(objPrimDetails.PAN_NUMBER+':::::'+objPrimDetails.AADHAAR_NUMBER);
                    //NETWORTH_DETAILS
                    if(kpd.NETWORTH_DETAILS != null){
                        List<Customer360view.cls_NETWORTH_DETAILS>  netWorthDetailObjRecds   = kpd.NETWORTH_DETAILS;
                        If(netWorthDetailObjRecds !=null){
                            for(Customer360view.cls_NETWORTH_DETAILS netWorthDetailObj : netWorthDetailObjRecds){
                                If(netWorthDetailObj !=null){
                                    //System.debug('Networth details@@@@ '+netWorthDetailObj); 
                                    Property__c     propObj         =   new Property__c();
                                    if(!Utility.ISStringBlankorNull(kpd.PRIMARY_DETAILS.LOS_PERSON_ACCOUNT_ID)){
                                        propObj.Account__c = kpd.PRIMARY_DETAILS.LOS_PERSON_ACCOUNT_ID;    
                                    }
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.LOS_PROPERTY_ID))
                                        propObj.id                             = netWorthDetailObj.LOS_PROPERTY_ID;
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.NATURE_OF_PROPERTY))
                                        propObj.Nature_of_Property__c            = netWorthDetailObj.NATURE_OF_PROPERTY;
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.OWNERSHIP_TYPE))
                                        propObj.Ownership_Type__c                = netWorthDetailObj.OWNERSHIP_TYPE;
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.PROPERTY_VALUE))
                                        propObj.Property_Value__c                   = SMELoan_Helper.currencyFormatter(netWorthDetailObj.PROPERTY_VALUE);
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.SURVEY_NO))
                                        propObj.Survey_No__c                   = netWorthDetailObj.SURVEY_NO;
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.MORTGAGE_DETAILS))
                                        propObj.Details_of_mortgage_if_any__c                   = netWorthDetailObj.MORTGAGE_DETAILS;
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.ASSET_TYPE))
                                        propObj.Asset_Type__c                   = netWorthDetailObj.ASSET_TYPE;
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.DOOR_NO))
                                        propObj.Door_Number__c                   = netWorthDetailObj.DOOR_NO;
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.NEAREST_LANDMARK))
                                        propObj.Nearest_Landmark__c                   = netWorthDetailObj.NEAREST_LANDMARK;
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.PROPERTY_AREA))
                                        propObj.Area__c                   = netWorthDetailObj.PROPERTY_AREA;
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.EXISTING_NETWORTH))
                                        propObj.Existing_Networth__c                   = SMELoan_Helper.currencyFormatter(netWorthDetailObj.EXISTING_NETWORTH);
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.PERCENTAGE_OWNERSHIP))
                                        propObj.Ownership_percentage__c                   = Decimal.valueOf(netWorthDetailObj.PERCENTAGE_OWNERSHIP);
                                    If(netWorthDetailObj.IS_COLLATERAL !=null && (netWorthDetailObj.IS_COLLATERAL == 'True' || netWorthDetailObj.IS_COLLATERAL =='Yes' || netWorthDetailObj.IS_COLLATERAL =='1')){
                                        propObj.is_Collateral__c                = true; 
                                    }
                                    If(netWorthDetailObj.ADDRESS !=null){
                                        Customer360view.cls_ADDRESS  cusParAdd      = netWorthDetailObj.ADDRESS;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.STREET))
                                            propObj.Property_Street__c              = cusParAdd.STREET;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.CITY))
                                            propObj.Property_City__c                = cusParAdd.CITY;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.STATE))
                                            propObj.Property_State__c               = cusParAdd.STATE;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.PIN_CODE))
                                            propObj.Property_Pincode__c          = cusParAdd.PIN_CODE;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.COUNTRY))
                                            propObj.Property_Country__c             = cusParAdd.COUNTRY;
                                        If(!Utility.ISStringBlankorNull(cusParAdd.TALUK))
                                            propObj.Taluk__c                        = cusParAdd.TALUK;
                                        
                                    }
                                    If(!Utility.ISStringBlankorNull(netWorthDetailObj.LOS_PROPERTY_ID)){
                                        
                                        listPropertyupdate.add(propObj);
                                    }else{
                                        if(!Utility.ISStringBlankorNull(kpd.PRIMARY_DETAILS.LOS_PERSON_ACCOUNT_ID)){
                                            listPropertyinsert.add(propObj);
                                        }else{
                                            mapOfPropertyAccountTag.put(aadharReference,propObj);       
                                        }   
                                    }
                                }
                            }
                        }
                    }
                    
                    //cls_SECTION_CHANGES
                    Customer360view.cls_SECTION_CHANGES     sectionChangesObj = kpd.SECTION_CHANGES;
                    If(sectionChangesObj !=null) {
                        If(!Utility.ISStringBlankorNull(sectionChangesObj.NAME))
                            accObj.Name_Of_Director_Related_To__c = sectionChangesObj.NAME;
                        If(!Utility.ISStringBlankorNull(sectionChangesObj.RELATIONSHIP))
                            accObj.Relationship__c                = sectionChangesObj.RELATIONSHIP;
                        If(!Utility.ISStringBlankorNull(sectionChangesObj.BANK_NAME))
                            accObj.Bank_name__c                   = sectionChangesObj.BANK_NAME;
                        If(!Utility.ISStringBlankorNull(sectionChangesObj.IS_KVB_DIRECTOR))
                            accObj.Is_KVB_Director__c             = sectionChangesObj.IS_KVB_DIRECTOR=='Yes'? true:false;
                    }
                    
                    //Parties's Update.
                    genesis__Application_Parties__c appPartyObj    = new genesis__Application_Parties__c();
                    Boolean partyTypeFlag = false;
                    If(!Utility.ISStringBlankorNull(kpd.PARTY_TYPE)){
                        If(kpd.LOS_PARTY_TYPE_ID !=null){
                            if(!Utility.ISStringBlankorNull(kpd.DIGIO_STATUS)) appPartyObj.Status__c = kpd.DIGIO_STATUS;
                            If(kpd.GUARANTOR !=null){
                                If(kpd.GUARANTOR =='Yes' || kpd.GUARANTOR == 'True' || kpd.GUARANTOR =='1'){
                                    appPartyObj.Guarantor__c                       = true;    
                                }else {
                                    appPartyObj.Guarantor__c                       = false;
                                }
                            }
                            appPartyObj.Id                                 = kpd.LOS_PARTY_TYPE_ID;
                            appPartyObj.genesis__Party_Type__c             = kpd.PARTY_TYPE;
                            if(!Utility.ISStringBlankorNull(kpd.DELETEKEYPERSON) && kpd.DELETEKEYPERSON!='Yes'){
                                if(appPartyObj.External_ID__c== null){
                                  appPartyObj.External_ID__c=  customObj.CUSTOMER_ID+'@'+accObj.id+'@'+app.Id;
                                }
                                listappparty.add(appPartyObj);
                            }
                            partyTypeFlag = true;
                        }
                    }
                    If(!Utility.ISStringBlankorNull(kpd.DELETEKEYPERSON) && kpd.DELETEKEYPERSON=='Yes' || kpd.DELETEKEYPERSON=='1' || kpd.DELETEKEYPERSON=='True'){
                        appPartyObj.is_Deleted__c = true;
                        appPartyObj.Active__c     = false;
                    }
                    if(!partyTypeFlag && !Utility.ISStringBlankorNull(kpd.LOS_PARTY_TYPE_ID) && !Utility.ISStringBlankorNull(kpd.DIGIO_STATUS)){
                        appPartyObj.Id                                 = kpd.LOS_PARTY_TYPE_ID;
                        appPartyObj.Status__c = kpd.DIGIO_STATUS;
                        if(appPartyObj.External_ID__c== null){
                          appPartyObj.External_ID__c=  customObj.CUSTOMER_ID+'@'+accObj.id+'@'+app.Id;
                        }
                        listappparty.add(appPartyObj);
                    }
                    
                    if(!Utility.ISStringBlankorNull(kpd.DELETEKEYPERSON) && kpd.DELETEKEYPERSON=='Yes'){
                        if(kpd.LOS_PARTY_TYPE_ID !=null){
                            //System.debug('kpd.DELETEKEYPERSON====> '+kpd.DELETEKEYPERSON);
                            appPartyObj.Id                                 = kpd.LOS_PARTY_TYPE_ID;
                            appPartyObj.Active__c                          = false;
                            appPartyObj.Is_New__c                          = false;
                            if(appPartyObj.External_ID__c== null){
                              appPartyObj.External_ID__c=  customObj.CUSTOMER_ID+'@'+accObj.id+'@'+app.Id;
                            }
                            listappparty.add(appPartyObj);
                            If(kpd.CBS_CUSTOMER_ID == null || kpd.CBS_CUSTOMER_ID !='')
                                partyIdObj.add(accObj.id);
                        }
                    }  
                    
                    If(accObj !=null) {
                        if(accObj.Id !=null && !partyIdObj.contains(accObj.Id)){
                            If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY))
                            accObj.Line_of_Activity__c = customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY;
                            listaccount.add(accObj);
                        }else If(accObj.Id == null && kpd.LOS_PARTY_TYPE_ID == null){
                                accObj.RecordTypeId = personAccountTypeId;
                                newlistacc.add(accObj);
                        }
                    }
                }
            }
        }
        If(limassList.size() > 0){
            upsert limassList External_Id__c;
            upsert limassListC External_Id__c;
        }
        
        If(listaccount.size() > 0){
            AccountTriggerHandler.isAccountTrigger = false;
            System.debug('########'+listaccount);
            System.debug('########'+listaccount[0].Line_of_Activity__c);
            update listaccount;
            If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY))
                currentCustomer.Line_of_Activity__c = customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY;
            update currentCustomer;
        }
        If(newlistacc.size() > 0){
            Set<String> panLst= new Set<String>();
            Set<String> adharLst= new Set<String>();
            Map<String,Account> mapOfExistingAccount = new Map<String,Account>();
            for(Account newAcc: newlistacc){
                if(newAcc.Aadhaar_Number__pc != null){
                    adharLst.add(newAcc.Aadhaar_Number__pc);
                }else if(newAcc.Pan_Number__c != null){
                    panLst.add(newAcc.Pan_Number__c);
                } 
            }
            map<Id,Account> mapOfAccount = new map<Id,Account>();
            mapOfAccount = SOQL_Util.getKeyPersonDetails(panLst,adharLst);
            //System.debug('mapOfAccount:::'+mapOfAccount);
            if(mapOfAccount !=null && mapOfAccount.size() > 1)
                RETURN null;
            if(mapOfAccount !=null && mapOfAccount.size()> 0){
                for(Account accObject : mapOfAccount.values()){
                    if(accObject.Aadhaar_Number__pc !=null && accObject.Aadhaar_Number__pc !=''){
                        mapOfExistingAccount.put(accObject.Aadhaar_Number__pc,accObject);
                    }else if(accObject.Pan_Number__c !=null && accObject.Pan_Number__c !=''){
                        mapOfExistingAccount.put(accObject.Pan_Number__c,accObject);    
                    }
                }
            }
            //System.debug('mapOfExistingAccount:::'+mapOfExistingAccount);
            for(Account ac: newlistacc){
                if(ac.Aadhaar_Number__pc !=null && mapOfExistingAccount.size() > 0 && mapOfExistingAccount.containsKey(ac.Aadhaar_Number__pc)){
                    ac.Id = mapOfExistingAccount.get(ac.Aadhaar_Number__pc).Id;
                    newOrExistingAccountList.add(ac);
                }else if(ac.Pan_Number__c !=null && mapOfExistingAccount.size() > 0 && mapOfExistingAccount.containsKey(ac.Pan_Number__c)){
                    ac.Id = mapOfExistingAccount.get(ac.Pan_Number__c).Id;
                    newOrExistingAccountList.add(ac);
                }else{
                    newOrExistingAccountList.add(ac);
                }  
            }
            //System.debug(newOrExistingAccountList.size()+'newOrExistingAccountList:::'+newOrExistingAccountList);
            if(newOrExistingAccountList.size()>0) upsert newOrExistingAccountList;
        }
        //System.debug('customObj.COMPANY_DETAILS.LEGAL_CHARGES_RESULT=='+customObj.COMPANY_DETAILS.LEGAL_CHARGES_RESULT);
        //System.debug('app.Application_Stage__c==='+app.Application_Stage__c);
        if(customObj.COMPANY_DETAILS.LEGAL_CHARGES_RESULT!= null){
                app.Legal_Charges_Result__c= customObj.COMPANY_DETAILS.LEGAL_CHARGES_RESULT;
                if(customObj.APP_TYPE==Constants.SME_NEW_LOAN_RECORD_TYPE && app.Legal_Charges_Result__c==Constants.LEGAL_CHARGES_RESULT){
                    SOQL_Util.createTaskForBM(app.Id,'Validate TL Details','Validate TL Details');
                }
                //System.debug('customObj.APP_TYPE==='+customObj.APP_TYPE);
                if(customObj.APP_TYPE==Constants.SME_NEW_LOAN_RECORD_TYPE && app.Legal_Charges_Result__c==Constants.LEGAL_CHARGES_RESULT && app.Application_Stage__c==Constants.NEW_LOAN_FINAL_SANCTION){
                    app.Sub_Stage__c=Constants.LEGAL_CLEARANCE_PENDING;
                    if(checkFENonFECollateralEvaluationdateexists(app.id)){
                       Underwriting_CTRL_Helper.createLegalEvaluationTaskForBM(app.Id,'Collateral Evaluation','BM task for uploading Valuation report and Legal opinion');
                    }
                }
            }
            //System.debug('app.Sub_Stage__c=='+app.Sub_Stage__c);
        If(app !=null && app.id != null){
            listOfApp.add(app);
            
        }
        If(listOfApp.size() >0){
            //System.debug('List of Application'+listOfApp);
            //ApplicationTriggerHandler.IsFirstRun = false;
            update  listOfApp;
            if(taskCompleteList.size() > 0){
                TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
                 update taskCompleteList;
            }
            //Document Review Task creation for BM
            try{
                //System.debug('reviewerTaskCreationInitiated'+app.RecordType.DeveloperName);
                Boolean reviewerTaskCreationFlag = false;
                //appln = [SELECT Id,Application_Stage__c,OwnerId FROM genesis__Applications__c WHERE Id =: customObj.LOS_APPLICATION_ID];
                if(appInfo[0].Application_Stage__c != customObj.APPLICATION_STAGE){
                    if(customObj.APP_TYPE == Constants.SME_APP_RECORD_TYPE && (customObj.APPLICATION_STAGE == 'E-sign pending-final' || customObj.APPLICATION_STAGE == 'E-sign pending')){
                        reviewerTaskCreationFlag = true;
                        appInfo[0].Application_Stage__c = customObj.APPLICATION_STAGE;
                    }
                    if(customObj.APP_TYPE == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT && customObj.APPLICATION_STAGE == 'Enhancement- E-sign pending'){
                        reviewerTaskCreationFlag = true;
                        appInfo[0].Application_Stage__c = customObj.APPLICATION_STAGE;
                    }
                    if(customObj.APP_TYPE == Constants.SME_APP_RECORD_TYPE_EXCEEDING && customObj.APPLICATION_STAGE == 'Exceeding- E-sign pending'){
                        reviewerTaskCreationFlag = true;
                        appInfo[0].Application_Stage__c = customObj.APPLICATION_STAGE;
                    }
                    if(customObj.APP_TYPE == Constants.SME_APP_RECORD_TYPE_ADHOC && customObj.APPLICATION_STAGE == 'Adhoc- E-sign pending'){
                        reviewerTaskCreationFlag = true;
                        appInfo[0].Application_Stage__c = customObj.APPLICATION_STAGE;
                    }
                    if(customObj.APP_TYPE == Constants.SME_NEW_LOAN_RECORD_TYPE && customObj.APPLICATION_STAGE == 'New loan- E-sign pending'){
                        reviewerTaskCreationFlag = true;
                        appInfo[0].Application_Stage__c = customObj.APPLICATION_STAGE;
                    }
                }
                if(reviewerTaskCreationFlag){
                    List<User> COuserLst=SOQL_Util.getBRCreditOfficer(appInfo[0].Id); 
                    if(COuserLst.size()>0){
                        SOQL_Util.createTaskForBRCreditOfficer(appInfo[0].Id,COuserLst[0].Id,'Document Review','Complete documentation');

                    }else{
                        Task taskObj = SanctionUnderwriting_Process.getTaskObj(appInfo[0].Id,appInfo[0].OwnerId,'Complete Documentation','Document Review');
                        taskObj.ActivityDate = system.today()+1;
                        TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
                        insert taskObj;
                    }
                    SME_SendSMSService.sendSmsForTasks(appInfo[0].Id,'Complete documentation','Document Review'); 
                    ApplicationTriggerHandler.IsFirstRun = false;
                    UPDATE appInfo;
                }
                Set<String> setOfString = new Set<String>{app.id};
                SME_SendSMSService.sendSMSApp_SME(setOfString);
            }catch(Exception ex){
                System.debug('Exception'+ex.getMessage());
            }
        }
       
        // New Key Contact PartyType   
        try{
            if(newOrExistingAccountList.size()>0 && (!(String.isBlank(newOrExistingAccountList[0].Aadhaar_Number__pc)) || !(String.isBlank(newOrExistingAccountList[0].Pan_Number__c)))){
               /* List<genesis__Application_Parties__c> partiesList = new List<genesis__Application_Parties__c>();
                partiesList = [Select Id, genesis__Party_Account_Name__c, genesis__Party_Account_Name__r.Aadhaar_Number__pc, genesis__Party_Account_Name__r.Pan_Number__c from genesis__Application_Parties__c 
                               Where genesis__Party_Account_Name__r.Aadhaar_Number__pc =: newOrExistingAccountList[0].Aadhaar_Number__pc AND genesis__Party_Account_Name__r.Pan_Number__c =: newOrExistingAccountList[0].Pan_Number__c];
                if(partiesList.size() > 0){
                    System.debug('partiesList'+partiesList);
                    for(genesis__Application_Parties__c partyobj : partiesList){
                       // partyobj.genesis__Party_Account_Name__r.Aadhaar_Number__pc.addError('Multiple Aadhar number '+partyobj.genesis__Party_Account_Name__r.Aadhaar_Number__pc+' exists for same key person in LOS - Please contact DTPC call center');
                       // partyobj.genesis__Party_Account_Name__r.Pan_Number__c.addError('Multiple Pan number '+partyobj.genesis__Party_Account_Name__r.Pan_Number__c+' exists for same key person in LOS - Please contact DTPC call center');
                    }
                }*/
                for(Account accObj  :  newOrExistingAccountList)  {
                    if(accObj !=null){
                        genesis__Application_Parties__c appPartyObj    = new genesis__Application_Parties__c();
                        appPartyObj.genesis__Application__c            = app.Id;
                        appPartyObj.genesis__Party_Account_Name__c     = accObj.Id;
                        appPartyObj.Key_Contact__c                     = acc.Id;
                        appPartyObj.Active__c                          = true;
                        appPartyObj.Is_New__c                          = true;
                        appPartyObj.Signatories__c                     = true;
                        appPartyObj.External_ID__c                     = customObj.CUSTOMER_ID+'@'+accObj.id+'@'+app.Id;
                        if(mapOfPropertyAccountTag.containsKey(accObj.Aadhaar_Number__pc)){
                            Property__c probObj =   mapOfPropertyAccountTag.get(accObj.Aadhaar_Number__pc);
                            probObj.Account__c  =   accObj.Id;
                            listPropertyinsertAccountTag.add(probObj);
                        }
                        if(mapPartyType.containsKey(accObj.Aadhaar_Number__pc)){
                            appPartyObj.genesis__Party_Type__c         = mapPartyType.get(accObj.Aadhaar_Number__pc);
                            If(mapPartyType.containskey(accObj.Aadhaar_Number__pc+'GUARANTOR') && (mapPartyType.get(accObj.Aadhaar_Number__pc+'GUARANTOR') == 'Yes' || mapPartyType.get(accObj.Aadhaar_Number__pc+'GUARANTOR') =='True' || mapPartyType.get(accObj.Aadhaar_Number__pc+'GUARANTOR') == '1')){
                                appPartyObj.Guarantor__c               =   true; 
                            }
                        }
                        appPartyObj.Product_Type__c                    = 'SME';
                        If(appPartyObj !=null){
                            listappparty.add(appPartyObj);
                        }
                    }
                }
            }
            
            If(listappparty.size() > 0){
                //System.debug('List Of Parties Update'+listappparty);
                for(genesis__Application_Parties__c appParty:listappparty){
                    if(appParty.id==null && appParty.External_ID__c!=null){
                        listapppartyUpsertonExtid.add(appParty);
                    }
                    else{
                        listapppartyUpsertonid.add(appParty);
                    }
                }
                if(listapppartyUpsertonid.size() > 0){
                    SendSMSService.Recusrive = false;
                    upsert listapppartyUpsertonid; //External_ID__c;
                }
                if(listapppartyUpsertonExtid.size() >0){
                    SendSMSService.Recusrive = false;
                    upsert listapppartyUpsertonExtid External_ID__c;
                }
            }
            If(listOfRejectedParty.size() > 0){  
                SendSMSService.Recusrive = false;
                update listOfRejectedParty;
            }
            List<Account> listPartyAccount = new List<Account>();
            listPartyAccount.addAll(deletePartyAcc);
            If(listPartyAccount.size() > 0){
                delete listPartyAccount;
            }
            If(deleteappparty.size() > 0){
                delete deleteappparty;
            }
            If(listFacility.size() > 0){
                update listFacility;
            }
            If(listPropertyinsertAccountTag.size() > 0){
               listPropertyinsert.addAll(listPropertyinsertAccountTag); 
            }
            If(listPropertyinsert.size() >0){
                insert listPropertyinsert;
                
            }
            If(listPropertyupdate.size() >0)
                UPDATE listPropertyupdate;
            
            
            try{
                If(listappparty_OwnerId.size() > 0){
                    PartyTriggerHandeller.isPartyTrigger = false;
                    //System.debug(listappparty_OwnerId[0].ownerId);
                    update listappparty_OwnerId;
                }    
            }catch(Exception ex){
                System.debug('Exception'+ ex.getStackTraceString()); 
           }
            // for facility and Application Collateral delete for New Loan Application.
            If(listFacilityDelete.size() > 0){
                If(listOfStringForAPPCollDelete.size() > 0){
                    List<genesis__Application_Collateral__c> listAppCollateralDelete = [select id,Facility__c from genesis__Application_Collateral__c where Facility__c IN : listOfStringForAPPCollDelete];
                    If(listAppCollateralDelete.size() > 0){
                        delete listAppCollateralDelete;
                    }
                }
                delete listFacilityDelete;  
            }
            If(listCollateralInsert.size() > 0){
                insert listCollateralInsert;
            }
            If(listCollateralupdate.size() > 0) {
                
                update listCollateralupdate;
            }
            /*insert listAppCollateral;*/
            If(listAppCollateral.size() > 0){
                insert listAppCollateral;
            }
            If(ownerShipListToInsert.size() > 0){
                insert ownerShipListToInsert;
            }
            If(ownerShipListToInsert.size() > 0){
                update ownerShipListToInsert;
            }
            If(listDebtorsInsert.size() > 0){
                insert listDebtorsInsert;
            }
            If(listDebtorsupdate.size() > 0){
                update listDebtorsupdate;
            }
            If(listSundryCreditorInsert.size() > 0){
                insert listSundryCreditorInsert;
            }
            If(listSundryCreditorupdate.size() > 0){
                update listSundryCreditorupdate;
            }
            if (listGroupConUpdate.size() > 0) {
                update listGroupConUpdate;
            }
            if(listGroupConDelete.size() > 0){
                delete listGroupConDelete;
            }
            if (listGroupConInsert.size() > 0) {
                insert listGroupConInsert;
            }
            if(listOfPerfios.size() > 0){
                insert listOfPerfios; 
            }
            if(customObj != null) updateSanctionDocument(customObj);
            return Handle_FetchSMEReq_Response.getApplicationInfo(customObj.CUSTOMER_ID,customObj.LOS_APPLICATION_ID);
            //return null;
        }catch(Exception e){
            //HandleBusinessException.captureError('SMELoan_Helper', 'getCustomAppDetailsUpdate', e);
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getStackTraceString());
            return null;
        }
    }
    
    
    //Added by : Souvik Banik.
    //Purpose  : Update Customer Feedback Details.
    //Params   : Customer360view object.
    public static void updateCustomerFeedBack(Customer360view custObj){
        try{
            Boolean flag = false;
            if(custObj != null){
                if(custObj.CUSTOMER_QUERY != null && custObj.CUSTOMER_QUERY.ALL_QUERIES != null){
                    List<Customer_Feedback__c> custFeedList = new List<Customer_Feedback__c>();
                    for(Customer360view.cls_CUSTOMER_QUERY custWrap : custObj.CUSTOMER_QUERY.ALL_QUERIES){
                        if(custWrap.Status == 'NA' && !Utility.ISStringBlankorNull(custWrap.Answer)){
                            flag = true;
                            Customer_Feedback__c custFeed = new Customer_Feedback__c();
                            custFeed.Id             = custWrap.LOS_ID;
                            custFeed.Question__c    = custWrap.Question;
                            custFeed.Status__c      = 'Completed';
                            custFeed.Answer__c      = custWrap.Answer;
                            custFeedList.add(custFeed);
                        }
                    }
                    update custFeedList;
                    createTaskForQueryRespondedUser(custObj.LOS_APPLICATION_ID,'Customer Followup Responded',Constants.CUSTOMER_RESPONDED_TASK_SUBJECT);
                }
            }
        }catch(Exception e){
            System.debug('Exeption In::: '+e.getCause()+'Line number---> '+e.getLineNumber()+'Error Message---> '+e.getMessage()+'StackTrace---> '+e.getStackTraceString());
        }
    }
    
    //Added by : Souvik Banik.
    //Purpose  : Update Digio Document Details.
    //Params   : Customer360view object.
    
    public static void updateSanctionDocument(Customer360view custObj){
        try{
            Boolean allDocSignedFlag = true;
            Boolean isRenewalApplication = false;
            Boolean isExceedingApplication = false;
            
            List<Digio_Document_ID__c> docDetailList = new List<Digio_Document_ID__c >();
            List<Document_Applicant__c> docApplicantListToUpdate = new List<Document_Applicant__c >();
            
            if(custObj.SANCTION_DOCUMENT_LIST != null){
                for(Customer360view.cls_Sanction_Document docRec : custObj.SANCTION_DOCUMENT_LIST){
                    if(docRec.Signers != null){
                        for(Customer360view.cls_Signatory  signatoryRec : docRec.Signers){
                            if(signatoryRec.IS_ESIGN_DONE== true){
                                Document_Applicant__c docAppRec =  new Document_Applicant__c();
                                docAppRec.Id                    =  signatoryRec.LOS_Digio_Status_Updation_Id;
                                docAppRec.eSigned__c            =  True;
                                docApplicantListToUpdate.add(docAppRec);
                            }
                        }
                    }
                }
            }
            
            if(docApplicantListToUpdate.size() > 0){
                update docApplicantListToUpdate;
                
                docDetailList =[SELECT Id,Status__c,Application__r.RecordType.developerName,Application__r.Application_Stage__c,Application__r.Id FROM Digio_Document_ID__c WHERE Application__c =: custObj.LOS_APPLICATION_ID AND Document_ID__c != null];
                for(Digio_Document_ID__c docDetail : docDetailList){
                    if(docdetail.Status__c != 'Completed') allDocSignedFlag = false;
                    if(docDetail.Application__r.RecordType.developerName == Constants.SME_APP_RECORD_TYPE) isRenewalApplication = true;
                    if(docDetail.Application__r.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_EXCEEDING) isExceedingApplication = true;
                }
                if(allDocSignedFlag && isRenewalApplication){
                    genesis__Applications__c app = new genesis__Applications__c(Id = docDetailList[0].Application__r.Id);
                    if (docDetailList[0].Application__r.Application_Stage__c == 'Interim sanction offered' || docDetailList[0].Application__r.Application_Stage__c == 'E-sign pending') app.Application_Stage__c = 'Sanction complete';
                    else if (docDetailList[0].Application__r.Application_Stage__c == 'Final Sanction Offered' || docDetailList[0].Application__r.Application_Stage__c == 'E-sign pending-final') app.Application_Stage__c = 'Sanction complete- Final Sanction';
                    
                    //ApplicationTriggerHandler.IsFirstRun = false;
                    UPDATE app;
                }
                else if(allDocSignedFlag && isExceedingApplication){
                    //callCBS_APIs(custObj.LOS_APPLICATION_ID);
                    SME_CBS_Handler.limitUpdation_ChargeColllection(new List<Id>{custObj.LOS_APPLICATION_ID});
                }
                else if(allDocSignedFlag && !isRenewalApplication && !isExceedingApplication){
                    callCBS_APIs(custObj.LOS_APPLICATION_ID);
                }
            }
        }catch(Exception e){
            System.debug('Exeption In::: '+e.getCause()+'Line number---> '+e.getLineNumber()+'Error Message---> '+e.getMessage()+'StackTrace---> '+e.getStackTraceString());
        }
    }
    
    //Added by : Souvik Banik.
    //Purpose  : Update facility new limit amount and application reason for reject and terms & conditions.
    //Params   : Customer360view Objcet and Application Id.
    public static void updateSliderChanges(Customer360view custObj,String Los_App_Id){
        try{
            
            if(custObj != null){
                if(custObj.SLIDER_CHANGES != null){
                    List<Facility__c> facList = new List<Facility__c>();
                    
                    if(!custObj.SLIDER_CHANGES.Facility_Wise_New_Limit.isEmpty())
                        for(Customer360view.cls_New_facility_Info custWrap : custObj.SLIDER_CHANGES.Facility_Wise_New_Limit){
                            Facility__c facRec         = new Facility__c();
                            facRec.Id                  = custWrap.LOS_Facility_Id;
                            facRec.New_Limit_Amount__c = Decimal.valueOf(custWrap.New_Limit_Amount);
                            facList.add(facRec);
                        }
                    //System.debug(' LosAppId '+Los_App_Id);
                    genesis__Applications__c  genApp                     = new genesis__Applications__c();
                    if(Los_App_Id != null){
                        genApp.Id                                        = Los_App_Id;
                        genApp.Reason_for_Reject_Application__c          = custObj.SLIDER_CHANGES.Reason_For_Reject;
                        genApp.Terms_and_Conditions__c                   = custObj.SLIDER_CHANGES.Terms_And_Condition;
                        //genApp.EMINMI__c                                 = Decimal.valueOf(custObj.SLIDER_CHANGES.EMI_NMI);
                        genApp.Sub_Stage__c                              = custObj.SLIDER_CHANGES.APP_SUBSTAGE;
                        genApp.Application_Stage__c                      = custObj.SLIDER_CHANGES.APP_STAGE;
                        /*System.debug(' @@@@33 '+genApp.Application_Stage__c +' sub Stage ::: ' + genApp.Sub_Stage__c +' Terms_and_Conditions__c::: '+ genApp.Terms_and_Conditions__c);
                        System.debug(' appStage:: ' + custObj.SLIDER_CHANGES.APP_STAGE);*/
                    }
                    if(custObj.SLIDER_CHANGES.ACCEPTED == 'NO'){
                        //System.debug('Inside no');
                        if(custObj.APP_SUB_STAGE != 'T and C Rejected'){
                            //system.debug('inside other stage');
                            if(custObj.APPLICATION_STAGE != null && custObj.APPLICATION_STAGE == 'Withdrawn by customer'){
                                genApp.Application_Stage__c = custObj.APPLICATION_STAGE;
                            }
                        }
                        // custObj.APP_SUB_STAGE == 'T and C Rejected'
                        else{
                            if(custObj.APPLICATION_STAGE != null && custObj.APPLICATION_STAGE == 'Enhancement- Application Review' && custObj.APP_TYPE == 'SME_Enhancement')
                                genApp.Application_Stage__c = custObj.APPLICATION_STAGE;
                            if(custObj.APPLICATION_STAGE != null && custObj.APPLICATION_STAGE == 'Adhoc-Application review' && custObj.APP_TYPE == 'SME_AdHoc')
                                genApp.Application_Stage__c = custObj.APPLICATION_STAGE;
                            if(custObj.APP_SUB_STAGE != null && custObj.APP_SUB_STAGE == 'T and C Rejected')
                                genApp.Sub_Stage__c = custObj.APP_SUB_STAGE;
                            createTaskForQueryRespondedUser(genApp.Id,'Revise Sanction Terms & Condition','Revised Sanction Terms & Conditions Requested');
                        }
                    }else{
                        //SanctionMatrixController_EA.createTaskForBM(genApp.Id);
                        SOQL_Util.createTaskForBM(genApp.Id,'Revised Loan Amount Requested','Revise Loan Amount');
                        genApp.Application_Stage__c = 'Application Review - BM Modified';
                    }
                    if(genApp != null){
                        update genApp;
                    }
                    if(! facList.isEmpty()){
                        update facList;
                    }
                }
            }
        }catch(Exception e){
            System.debug('Exeption In::: '+e.getCause()+'Line number---> '+e.getLineNumber()+'Error Message---> '+e.getMessage()+'StackTrace---> '+e.getStackTraceString());
        }
    }
    
    
    //Added by : Souvik Banik.
    //Purpose  : Create Task for Facility Authority Recommendation's Higher Authority.
    //Params   : Application Id.
    public static void createTaskForQueryRespondedUser(String appId,String taskType,String taskSubject){
        try{
            String role = '';
            Task taskObj = new Task();
            List<User> authUser = new List<User>();
            List<Facility__c> facilityList = SanctionUnderwriting_Process.getFacilityAuthority(appId);
            for(Facility__c facObj : facilityList){
                if(facObj.Highest_Authority__c == TRUE){
                    role = facObj.Role__c;
                }
                if(role!= null && role != ''){
                    authUser = SanctionUnderwriting_Process.getUserRecord(role,null);
                }
                if(! authUser.isEmpty()){
                    taskObj = SanctionUnderwriting_Process.getTaskObj(appId,authUser[0].Id,taskSubject,taskType);
                    TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
                }
            }
            Insert taskObj;
        }catch(Exception e){
            System.debug('Exeption In::: '+e.getCause()+'Line number---> '+e.getLineNumber()+'Error Message---> '+e.getMessage()+'StackTrace---> '+e.getStackTraceString());
        }
    }
    
    //Added by : Souvik Banik.
    //Purpose  : Delete all Facility which has no value in New Limit Amount field and its Application should be type of Exceediing.
    //Params   : Application Id.
    public static void deleteFacility(String applnId){
        
        try{
            List<Facility__C> facListToDelete = new List<Facility__C>();
            if(applnId != null){
                facListToDelete = [SELECT Id,Application__c,To_Be_Deleted__c FROM Facility__C WHERE Application__c =: applnId AND To_Be_Deleted__c != NULL AND 
                                   Application__r.Record_Type_Name__c = 'SME Exceeding' AND Application__r.Application_Stage__c = 'Exceeding- Application submitted'];
            }
            if(! facListToDelete.isEmpty()){
                DELETE facListToDelete;
            }
        }catch(Exception e){
            System.debug('Exeption In::: '+e.getCause()+'Line number---> '+e.getLineNumber()+'Error Message---> '+e.getMessage()+'StackTrace---> '+e.getStackTraceString());
        }
    }
    
    @future(callout = true)
    public static void getProbeDetails(String custId,String appId){
        If(custId !=null && custId !=''){
            WS_Probe42Data.getResponse(custId,appId);
        }
        
    }
    @future(callout = true)
    public static void getGSTR38Details(String custId,String appId,String gst){
        If(custId !=null && custId !='' && appId !=null && appId !='' && gst !=null && gst !=''){
            WS_GSTR3B_Report_Aggregation_API.sendRequest(custId,appId,gst);
        }
        
    }
    public static genesis__Applications__c getApplicationById(String appId){
        //system.debug('appId==============> 12345  '+appId);
        If(appId !=null){
            return [select id,RecordType.developerName,Application_Stage__c,genesis__Account__c from genesis__Applications__c where Id =:appId];
        }
        return null;
    }
    public static Map<String,String> getMapSecurityType(Set<String> setOfFacilitiesId){
        Map<String,String> mapOfSecurityType = new  Map<String,String>();
        If(setOfFacilitiesId !=null){
            try{
                List<genesis__Application_Collateral__c> listOfAppColl = [Select id,Security_Type__c,Facility__c from genesis__Application_Collateral__c where Facility__c IN : setOfFacilitiesId];
                If(listOfAppColl !=null && listOfAppColl.size() >0){
                    for(genesis__Application_Collateral__c appCollObj : listOfAppColl){
                        If(appCollObj !=null){
                            If(!mapOfSecurityType.containsKey(appCollObj.Facility__c)){
                                mapOfSecurityType.put(appCollObj.Facility__c, appCollObj.Security_Type__c);
                            }    
                        }
                    }
                    return mapOfSecurityType;
                }
            }catch(Exception ex){
                System.debug('Exception'+ex.getStackTraceString());
            }
        }
        return null;
    }
    
    @future(callout = true)
    public static void callCBS_APIs(String appId){
        SME_CBS_EAE.requestHandler(appId);
    }
    public static Boolean checkIfLandAndBuildingFECollateralExist(String appId){
        try {
            List<genesis__Application_Collateral__c> allAppCollateral       = new List<genesis__Application_Collateral__c>();

            String Land_And_Building_RT                                     = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();
            allAppCollateral                                                = [SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c=:appId AND genesis__Collateral__r.RecordTypeId =:Land_And_Building_RT and genesis__Collateral__r.FE_Created__c=true];
            if(allAppCollateral.size() == 0) {
                return false;
            }else{
                return true;
            }

        } catch (Exception e) {
            return false;
        }
    }

    public static Boolean checkFENonFECollateralEvaluationdateexists(String appId){
        Boolean flag=false;    
        Date addedDate;
        try{
              List<genesis__Application_Collateral__c> allAppCollateral       = new List<genesis__Application_Collateral__c>();  
              String Land_And_Building_RT                                     = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();
              allAppCollateral=[SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c,genesis__Collateral__r.Valuation_Date__c from genesis__Application_Collateral__c where Application__c=:appId AND genesis__Collateral__r.RecordTypeId =:Land_And_Building_RT];
              if(allAppCollateral!=null && allAppCollateral.size()>0){
                For(genesis__Application_Collateral__c appcoll:allAppCollateral){
                    //addedDate=appcoll.genesis__Collateral__r.Valuation_Date__c.addyears(3);
                    if((appcoll.genesis__Collateral__r.Valuation_Date__c!=null && (appcoll.genesis__Collateral__r.Valuation_Date__c).addyears(3) >= date.today() && appcoll.genesis__Collateral__r.FE_Created__c==false) || appcoll.genesis__Collateral__r.FE_Created__c==true){
                        flag=true;
                        break;
                    }
                }
              }
        }
        catch(Exception ex){
            HandleBusinessException.captureError('SME_Enhance_Update','checkFENonFECollateralEvaluationdateexists',ex);
        }
        return flag;
    }
    public static Map<String,Map<String,M68_Balance_Sheet_Analysis__c>> createm68dataforLBOthersPM(Customer360view customObj,Map<String,M68_Balance_Sheet_Analysis__c> m68dataMapToInsert,Map<String,M68_Balance_Sheet_Analysis__c> m68dataMapToUpdate){
    //Map<String,M68_Balance_Sheet_Analysis__c> m68dataMapToInsert = new Map<String,M68_Balance_Sheet_Analysis__c>();
    //Map<String,M68_Balance_Sheet_Analysis__c> m68dataMapToUpdate = new Map<String,M68_Balance_Sheet_Analysis__c>();
    Integer currentYear                                             = Utility.getCurrentYear();
    String nextEstFiscalYear                                        = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
    String nextProjFiscalYear                                       = (currentYear+1)+'-'+Integer.valueOf(String.valueOf(currentYear+2).subString(String.valueOf(currentYear+2).length()-2,String.valueOf(currentYear+2).length()));
    String cyString                                                 = String.valueOf(currentYear);
    String currentFY                                                = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
    String prevFY                                                   = (currentYear-2)+'-'+Integer.valueOf(String.valueOf(currentYear-1).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
    String n_1_FY                                           = (currentYear - 3) + '-' + Integer.valueOf(String.valueOf(currentYear - 2).subString(String.valueOf(currentYear - 1).length() - 2, String.valueOf(currentYear - 1).length()));
    Map<String,Map<String,M68_Balance_Sheet_Analysis__c>> m68datamap=new Map<String,Map<String,M68_Balance_Sheet_Analysis__c>>();
           System.debug('prevFY=='+prevFY);
           /* System.debug('Customobj ===='+Customobj);
            System.debug('customObj.FINANCIALS.LAND_AND_BUILDING =='+customObj.FINANCIALS.LAND_AND_BUILDING);
            System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.YTD_CURRENT_FY =='+customObj.FINANCIALS.LAND_AND_BUILDING.YTD_CURRENT_FY);
            System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.YTD_CURRENT_FY.FY_TOTAL =='+customObj.FINANCIALS.LAND_AND_BUILDING.YTD_CURRENT_FY);*/
            if(customObj.FINANCIALS.LAND_AND_BUILDING != null){
            //m68dataMapToUpdate m68dataMapToInsert
                    if(customObj.FINANCIALS.LAND_AND_BUILDING.YTD_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentYTD  = customObj.FINANCIALS.LAND_AND_BUILDING.YTD_CURRENT_FY; 
                        if(salesCurrentYTD.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('YTD_CURRENT_FY')){
                                /*System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.YTD_CURRENT_FY =='+m68dataMapToUpdate);*/
                                m68dataMapToUpdate.get('YTD_CURRENT_FY').Land_Building__c = commastringToDecimaal(salesCurrentYTD.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('YTD_CURRENT_FY')){

                                m68dataMapToInsert.get('YTD_CURRENT_FY').Land_Building__c = commastringToDecimaal(salesCurrentYTD.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.LAND_AND_BUILDING.PROJ_NEXT2_FY != null){
                        Customer360view.cls_FY salesNext2Proj  = customObj.FINANCIALS.LAND_AND_BUILDING.PROJ_NEXT2_FY;   
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNext2Proj.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('PROJ_NEXT2_FY')){
                                /*System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.PROJ_NEXT2_FY =='+m68dataMapToUpdate);*/
                                m68dataMapToUpdate.get('PROJ_NEXT2_FY').Land_Building__c = commastringToDecimaal(salesNext2Proj.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToInsert.get('PROJ_NEXT2_FY').Land_Building__c = commastringToDecimaal(salesNext2Proj.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.LAND_AND_BUILDING.EST_NEXT_FY != null){
                        Customer360view.cls_FY salesNextEst  = customObj.FINANCIALS.LAND_AND_BUILDING.EST_NEXT_FY;  
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNextEst.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('EST_NEXT_FY')){
                                //System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.EST_NEXT_FY =='+m68dataMapToUpdate);
                                m68dataMapToUpdate.get('EST_NEXT_FY').Land_Building__c = commastringToDecimaal(salesNextEst.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToInsert.get('EST_NEXT_FY').Land_Building__c = commastringToDecimaal(salesNextEst.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_CURRENT_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToUpdate.get('ACTUAL_CURRENT_FY').Land_Building__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToInsert.get('ACTUAL_CURRENT_FY').Land_Building__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_PREV_FY=='+customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_PREV_FY);
                    System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_PREV_FY=='+customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_PREV_FY);
                    //System.debug('m68dataMapToUpdate.get(ACTUAL_PREV_FY).Land_Building__c=='+m68dataMapToUpdate.get('ACTUAL_PREV_FY').Land_Building__c);
                    if(customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_PREV_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_PREV_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToUpdate.get('ACTUAL_PREV_FY').Land_Building__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToInsert.get('ACTUAL_PREV_FY').Land_Building__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    //System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY =='+customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY);
                    //System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY.FY_TOTAL =='+customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY.FY_TOTAL);
                    if(customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToUpdate.get('ACTUAL_N_1_FY').Land_Building__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                                //System.debug('m68dataMapToUpdate.get(ACTUAL_N_1_FY).Land_Building__c ===='+m68dataMapToUpdate.get('ACTUAL_N_1_FY').Land_Building__c);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_N_1_FY')){
                                 //System.debug('customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY.FY_TOTAL===='+customObj.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY.FY_TOTAL);
                                //System.debug('m68dataMapToUpdate.get(ACTUAL_N_1_FY).Land_Building__c ==='+m68dataMapToUpdate.get('ACTUAL_N_1_FY').Land_Building__c);
                                //System.debug('commastringToDecimaal(salesCurrentAct.FY_TOTAL) =='+commastringToDecimaal(salesCurrentAct.FY_TOTAL));
                                m68dataMapToInsert.get('ACTUAL_N_1_FY').Land_Building__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                                //System.debug('m68dataMapToUpdate.get(ACTUAL_N_1_FY).Land_Building__c ==='+m68dataMapToUpdate.get('ACTUAL_N_1_FY').Land_Building__c);
                            }
                        }
                    }
                    
                    
                }

                if(customObj.FINANCIALS.PLANT_AND_MACHINERY != null){
                    if(customObj.FINANCIALS.PLANT_AND_MACHINERY.YTD_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentYTD  = customObj.FINANCIALS.PLANT_AND_MACHINERY.YTD_CURRENT_FY; 
                        if(salesCurrentYTD.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToUpdate.get('YTD_CURRENT_FY').Plant_Machinery__c = commastringToDecimaal(salesCurrentYTD.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToInsert.get('YTD_CURRENT_FY').Plant_Machinery__c = Integer.ValueOf(salesCurrentYTD.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PLANT_AND_MACHINERY.PROJ_NEXT2_FY != null){
                        Customer360view.cls_FY salesNext2Proj  = customObj.FINANCIALS.PLANT_AND_MACHINERY.PROJ_NEXT2_FY;   
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNext2Proj.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToUpdate.get('PROJ_NEXT2_FY').Plant_Machinery__c = commastringToDecimaal(salesNext2Proj.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToInsert.get('PROJ_NEXT2_FY').Plant_Machinery__c = commastringToDecimaal(salesNext2Proj.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PLANT_AND_MACHINERY.EST_NEXT_FY != null){
                        Customer360view.cls_FY salesNextEst  = customObj.FINANCIALS.PLANT_AND_MACHINERY.EST_NEXT_FY;  
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNextEst.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToUpdate.get('EST_NEXT_FY').Plant_Machinery__c = commastringToDecimaal(salesNextEst.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToInsert.get('EST_NEXT_FY').Plant_Machinery__c = commastringToDecimaal(salesNextEst.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_CURRENT_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToUpdate.get('ACTUAL_CURRENT_FY').Plant_Machinery__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToInsert.get('ACTUAL_CURRENT_FY').Plant_Machinery__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_PREV_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_PREV_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToUpdate.get('ACTUAL_PREV_FY').Plant_Machinery__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToInsert.get('ACTUAL_PREV_FY').Plant_Machinery__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_N_1_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_N_1_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToUpdate.get('ACTUAL_N_1_FY').Plant_Machinery__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                                //System.debug('m68dataMapToUpdate.get(ACTUAL_N_1_FY).Plant_Machinery__c ==='+m68dataMapToUpdate.get('ACTUAL_N_1_FY').Plant_Machinery__c);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToInsert.get('ACTUAL_N_1_FY').Plant_Machinery__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                }

                if(customObj.FINANCIALS.INTANGIBLE_OTHERS != null){
                    if(customObj.FINANCIALS.INTANGIBLE_OTHERS.YTD_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentYTD  = customObj.FINANCIALS.INTANGIBLE_OTHERS.YTD_CURRENT_FY; 
                        if(salesCurrentYTD.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToUpdate.get('YTD_CURRENT_FY').Intangible_Others__c = commastringToDecimaal(salesCurrentYTD.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('YTD_CURRENT_FY')){
                                m68dataMapToInsert.get('YTD_CURRENT_FY').Intangible_Others__c = commastringToDecimaal(salesCurrentYTD.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.INTANGIBLE_OTHERS.PROJ_NEXT2_FY != null){
                        Customer360view.cls_FY salesNext2Proj  = customObj.FINANCIALS.INTANGIBLE_OTHERS.PROJ_NEXT2_FY;   
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNext2Proj.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToUpdate.get('PROJ_NEXT2_FY').Intangible_Others__c = commastringToDecimaal(salesNext2Proj.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('PROJ_NEXT2_FY')){
                                m68dataMapToInsert.get('PROJ_NEXT2_FY').Intangible_Others__c = commastringToDecimaal(salesNext2Proj.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.INTANGIBLE_OTHERS.EST_NEXT_FY != null){
                        Customer360view.cls_FY salesNextEst  = customObj.FINANCIALS.INTANGIBLE_OTHERS.EST_NEXT_FY;  
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        if(salesNextEst.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToUpdate.get('EST_NEXT_FY').Intangible_Others__c = commastringToDecimaal(salesNextEst.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('EST_NEXT_FY')){
                                m68dataMapToInsert.get('EST_NEXT_FY').Intangible_Others__c = commastringToDecimaal(salesNextEst.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_CURRENT_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_CURRENT_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToUpdate.get('ACTUAL_CURRENT_FY').Intangible_Others__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_CURRENT_FY')){
                                m68dataMapToInsert.get('ACTUAL_CURRENT_FY').Intangible_Others__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    if(customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_PREV_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_PREV_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToUpdate.get('ACTUAL_PREV_FY').Intangible_Others__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_PREV_FY')){
                                m68dataMapToInsert.get('ACTUAL_PREV_FY').Intangible_Others__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                    //System.debug('customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_N_1_FY =='+customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_N_1_FY);
                    //System.debug('customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_N_1_FY.FY_TOTAL =='+customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_N_1_FY.FY_TOTAL);
                    if(customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_N_1_FY != null){
                        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
                        Customer360view.cls_FY salesCurrentAct  = customObj.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_N_1_FY;
                        if(salesCurrentAct.FY_TOTAL != ''){
                            if(m68dataMapToUpdate.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToUpdate.get('ACTUAL_N_1_FY').Intangible_Others__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                            else if(m68dataMapToInsert.keyset().contains('ACTUAL_N_1_FY')){
                                m68dataMapToInsert.get('ACTUAL_N_1_FY').Intangible_Others__c = commastringToDecimaal(salesCurrentAct.FY_TOTAL);
                            }
                        }
                    }
                }
            System.debug('m68dataMapToUpdate==== '+m68dataMapToUpdate);
            System.debug('m68dataMapToUpdate==== '+m68dataMapToInsert);
        if(m68dataMapToInsert!=null && m68dataMapToUpdate!=null){
            if(!m68dataMapToInsert.isEmpty()){
                m68datamap.put('m68dataMapToInsert',m68dataMapToInsert);
            }
            if(!m68dataMapToUpdate.isEmpty()){
                m68datamap.put('m68dataMapToUpdate',m68dataMapToUpdate);
            }
        }

    return m68datamap;
}

     public static Decimal commastringToDecimaal(String value){
        Decimal retval=0.0;
        if(value!=null){
            value=value.replaceAll('[^.\\d]','');
            retval=Decimal.valueOf(value);
        }

        return retval;
    }
}