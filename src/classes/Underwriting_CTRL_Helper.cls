/*
* @name : Underwriting_CTRL_Helper
* @description: Helper class for Underwriting_CTRL Class
* 
*/
global class Underwriting_CTRL_Helper {

    public static String auditRTypeID                                                       = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get(Constants.SANCTION_AUTHORITY_LABEL).getRecordTypeId();
    public static String auditTCRTypeID                                                     = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get(Constants.UNDERWRITING_T_N_C).getRecordTypeId();
    public static String auditPreTCRTypeID                                                  = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get(Constants.UNDERWRITING_PRE_T_N_C).getRecordTypeId();
    public static String applicationSubStage                                                = '';
    public static Boolean isFinalCoverageLess                                               = false;
    public static String applicationStage                                                   = '';
    public static String applicationUiStage                                                 = '';
    Public static List<String> BMAuthrecommendationIds                                      = new List<String>();
    public static Set<String> setOfString                                                   = new Set<String>();
    public static Processing_charges_scheme__c  processRec                                  = new Processing_charges_scheme__c();
    public static Boolean isSchematicNonFunded                                              = false;
    public static Boolean ifSchematic                                                       = false;
    public static Non_Schematic_Processing_Charges__c nonFundedProcessingCharges            = new Non_Schematic_Processing_Charges__c();
    public static String deviationReason                                                    ='';
    static Decimal  FinalValueToBePassed            = 0.00;
    static Decimal  deviationvalue                  = 0.00;
    static Decimal  finalDeviationValue             = 0.00;
    static Decimal  existingProcFee                 = 0.00;
    static Decimal  productRenewalFee               = 0.00;
    static Decimal  deviationvalueRenewal           = 0.00;
    static Decimal  finalDeviationValueRenewal      = 0.00;
    static Decimal  enhanceDeviationValueToBePassed = 0.00;
    static Decimal  renewalDeviationValueToBePassed = 0.00;

    public Underwriting_CTRL.UnderwritingWrapper getDashboardContent(string appId, User currentUserInfo){

        Underwriting_CTRL.UnderwritingWrapper creditScore                                   = new Underwriting_CTRL.UnderwritingWrapper();
        List<Underwriting_CTRL.ScoreWrapper> creditScores                               = new List<Underwriting_CTRL.ScoreWrapper>();
        try{

            creditScore.loggedInUser                                                        = currentUserInfo;
            creditScore.scores                                                              = new List<Credit_Underwriting__c>();
            List<Credit_Underwriting__c> underwritingscores                                 = getapplnUnderwriting(appId);
            creditScore.sanctionauthComments                                                = new List<Audit__c>();
            creditScore.termsCondtionComments                                               = new List<Audit__c>();
            creditScore.preDisbursementComments                                             = new List<Audit__c>();
            creditScore.mclrRate                                                            = getMCLRValuesFromMaster();
            List<Audit__c> auditComments                                                    = getAuthorityComment(appId);

            for(Audit__c a : auditComments){
                if(a.RecordType.DeveloperName == Constants.UNDERWRITING_T_C_RTYPE){
                    creditScore.termsCondtionComments.add(a);
                }else if(a.RecordType.DeveloperName == Constants.PREDISBURSEMENT_T_C_RTYPE){
                    creditScore.preDisbursementComments.add(a);
                }else{
                    creditScore.sanctionauthComments.add(a);
                }
            }

            for(Credit_Underwriting__c cw : underwritingscores){
                Underwriting_CTRL.ScoreWrapper sw                                           = new Underwriting_CTRL.ScoreWrapper();
                sw.applicationId                                                            = cw.Application__c;
                sw.parentAppraisal                                                          = cw.Appraisal__c;
                sw.parentScore                                                              = cw.Application_Score__c;
                sw.parentvalue                                                              = cw.Application_Value__c;
                sw.parentweight                                                             = cw.Application_Weight__c;
                sw.parentScorePerc                                                          = cw.Application_Score_Percent__c;
                sw.childApplicationScore                                                    = new List<Credit_Underwriting__c>();
                sw.childFlags                                                               = new List<Credit_Underwriting__c>();

                for(Credit_Underwriting__c child : cw.Credit_Underwritings__r){
                    if(child.RecordType.DeveloperName == Constants.CU_CHILD_APP_SCORE_RECORD_TYPE){
                        sw.childApplicationScore.add(child);
                    }
                    if(child.RecordType.DeveloperName == Constants.CU_CHILD_FLAG_RECORD_TYPE){
                        sw.childFlags.add(child);
                    }
                }
                creditScores.add(sw);
            }

            creditScore.applicationInfo                                                     = new genesis__Applications__c();
            creditScore.applicationInfo                                                     = Underwriting_CTRL_Helper.getapplnInformation(appId);
            creditScore.termLoanExposure                                                    = Underwriting_CTRL_Helper.getTermLoanAmount(appId,creditScore.applicationInfo.genesis__Account__r.Id);

            creditScore.roleWiseLimitAmount                                                 = new Map<String, Decimal>();
            creditScore.reccomendationCappingDetails                                        = new List<Authority_Hierarchy_Level__mdt>();
            creditScore.reccomendationCappingDetails                                        = getReccomendationCappingDetails();
            if(creditScore.applicationInfo.RecordType.DeveloperName != 'SME_Exceeding'){
                creditScore.roleWiseLimitAmount                                             = Underwriting_CTRL_Helper.getRoleWiseLimitAmount();
            }else{
                creditScore.roleWiseLimitAmount                                              = Underwriting_CTRL_Helper.getRoleWiseLimitAmountForExceeding();
            }

            creditScore.userList                                                            = new List<user>();
            creditScore.userList                                                            = [Select id,Name from User where Profile.Name =: Constants.SYSTEM_ADMIN_PROFILE];

            creditScore.creditScores                                                        = creditScores;
            creditScore.recommHistory                                                       = new List<genesis__Application_Status_History__c>();
            creditScore.recommHistory                                                       = getRecommendationHistory(appId);
            creditScore.facilityList                                                        = new List<Facility__c>();
            creditScore.facilityList                                                        = getFacilityData(appId);
            creditScore.underWritingDashboardRuleCriteria                                   = underwritingdashboardrulecriteria__c.getAll();
            creditScore.kvbCompanyDetails                                                   = KVB_Company_Details__c.getInstance();


            List<Renewal_Checklists__c> checkList                                           = new List<Renewal_Checklists__c>();
            checkList   = [Select id,Checklist_Name__c,Complied__c from Renewal_Checklists__c where Complied__c =:Constants.NO_STRING AND Application__c =:appId];
            creditScore.pendingPreRenewalList                                               = new List<String>();
            creditScore.pendingPreRenewalList                                               = getCheckListPendingReason(checkList);

        }catch(Exception e){
            system.debug('Exception::'+e.getMessage());
        }
		System.debug('---> creditScore'+creditScore);
        return creditScore;
    }

    /**
* Method to create mod task for BM
*
* @param appId
* @param type
* @param subject
*
* @return
*/
    public static string createMODTaskForBm(string appId,String type,String subject){
        try {
            if(!checkIFOpenTaskAlreadyExist(appId,type)){
                List<genesis__Applications__c> appInfo                                      = new List<genesis__Applications__c>();
                appInfo                                                                     = SOQL_Util.getApplication(new Set<Id>{appId});
                Task taskRec                                                                = SanctionUnderwriting_Process.getTaskObj(appId, appInfo[0].OwnerId, subject, type);
                TaskFlow_Helper.TASK_TRIGGER_RUNNING                                        = true;
                insert taskRec;
                return 'MOD Task for BM has been created';
            }else{
                return 'MOD Task already created for BM';
            }


        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createMODTaskForBm', e);
            return 'Some Error Occurred';
        }
    }

    /**
* Re-Usable Method to check if Open Task Exist given Task type
*
* @param appId
* @param taskType
*
* @return
*/
    public static Boolean checkIFOpenTaskAlreadyExist(string appId,String taskType) {
        List<Task> getExistingTaskList;
        if(taskType =='EME BM Review')
            getExistingTaskList                                                       = [SELECT Id FROM Task where WhatId=:appId and Type IN ('EME BM Review','Application Review') And Status!='Completed'];
        else
                getExistingTaskList                                                       = [SELECT Id FROM Task where WhatId=:appId and Type=:taskType And Status!='Completed'];

        return getExistingTaskList.size()>0?true:false;

    }
    public static Boolean checkIFM121TaskCompleted(string appId) {
        try {
            List<Task> getExistingTaskList                                              = new List<Task>();
            getExistingTaskList                                                         = [SELECT Id FROM Task where WhatId=:appId and Type='M121 A Needed' And Status='Completed'];
            List<Task> getExistingOpenTaskList                                              = new List<Task>();
            getExistingOpenTaskList = [SELECT Id FROM Task where WhatId=:appId and Type='M121 A Needed' And Status='Not Started'];
            if(getExistingOpenTaskList.isEmpty()){
                return true;
            }else{
                if(getExistingTaskList.size()>0){
                    return true;
                }else{
                    return false;
                }
            }
            /*if(getExistingTaskList != null){
                //return getExistingTaskList.size()>0?true:false;
                if(getExistingTaskList.size()>0){
                    return true;
                }else if(getExistingTaskList.size()==0 && getExistingOpenTaskList.isEmpty()){
                    return
                }
            }else{
                List<Task> getExistingOpenTaskList                                              = new List<Task>();
                getExistingOpenTaskList = [SELECT Id FROM Task where WhatId=:appId and Type='M121 A Needed' And Status='Not Started'];
                if(getExistingOpenTaskList != null){
                    //getExistingOpenTaskList.size() == 0?true:false;
                    if(getExistingOpenTaskList.isEmpty()) return true;
                    else
                            return false;
                }
                return false;
            }*/

        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIFM121TaskCompleted', e);
            //return 'Error :'+e.getMessage()+' At '+e.getLineNumber();
            return false;
        }


    }

    /**
* Method Used to Update Application Stage to "Insufficient collateral coverage"
*
* @param appData
*
* @return
*/
    public static String updateApplicationStage(genesis__Applications__c appData){
        try{

            if(appData != null){
                appData.Application_UI_Stage__c                                             = SOQL_Util.getApplicationUISatge(appData.Id);
                appData.Is_Financial_security_Coverage_Less__c                              = true;
                ApplicationTriggerHandler.IsFirstRun                                        = false;
                update appData;
                return 'Application Sub-Stage has been changed to Insufficient Collateral Coverage';
            }else{
                return 'Application Data is undefined';
            }

        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateApplicationStage', e);
            //return 'Error :'+e.getMessage()+' At '+e.getLineNumber();
            return 'Some Error Occurred';
        }

    }

    /**
* Method To Keep Count of How many times Final aUTHORITY hAS REJECTED pRE-DISBERSEMENT From BM
*
* @param appId
* @param currStatus
*
* @return
*/
    public static Boolean isPreDisburementTaskCountOne(String  appId,String currStatus) {
        try{
            List<Task> preDisbersementTaskList                                              = new List<Task>();

            if(currStatus == 'Completed')
                preDisbersementTaskList                                                    = [Select Id,WhatId from Task where Type='Pre-disbursement Approval' and Status='Completed' and WhatId=:appId];
            else
                    preDisbersementTaskList                                                   = [Select Id,WhatId from Task where Type='Pre-disbursement Approval' and Status!='Completed' and WhatId=:appId];

            return preDisbersementTaskList.size()==1 ? true :false;
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'isPreDisburementTaskCountOne', e);
            return null;
        }

    }

    /**
* Method Used to calculate final coverage once bm has complied all Pre-disbersement Terms and Condition
*
* @param appId
*
* @return
*/
    public static String updateApplicationStagetoFinalSanction(String appId){
        try{
            closeExistingTask(appId,'Pre-disbursement Approval');
            return updateFinalSecurityCoverage(appId,'FINAL_AUTHORITY');
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateApplicationStagetoFinalSanction', e);
            return 'Some Error Occurred';
        }
    }

    /**
* re-Usable Method To Check if Collateral from Front-End Exist
*
* @param appId
*
* @return
*/
    public static Boolean checkIfFECollateralExist(String appId){
        try {
            List<genesis__Application_Collateral__c> existingFECollaterals                      = [SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c from genesis__Application_Collateral__c where Application__c=:appId AND genesis__Collateral__r.FE_Created__c=true];
            return existingFECollaterals.size()>0 ? true:false;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIfFECollateralExist', e);
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber());
            return false;
        }
    }

    /**
* Method to calculate final Security Coverage(reusable)
* Is Called from Leagal Evaluaation Page as well As Underwriting dashboard
* @param appId
* @param isFinalAuthOrLegal
*
* @return
*/
    webservice static String updateFinalSecurityCoverage(String appId,String isFinalAuthOrLegal){
        try {

            String returnString='';
            genesis__Applications__c appRecord ;
            Boolean isMarketValueValid                                                              = false;
            List<genesis__Application_Collateral__c> allAppCollateral                               = new List<genesis__Application_Collateral__c>();
            List<genesis__Application_Collateral__c> existingFECollaterals                          = new List<genesis__Application_Collateral__c>();
            String Land_And_Building_RT                                                             = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();
            String Land_And_Building_Other_RT                                                       = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Buildings - Other').getRecordTypeId();
            existingFECollaterals                                                                   = [SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c from genesis__Application_Collateral__c where Application__c=:appId AND genesis__Collateral__r.FE_Created__c=true];


            if(appId != null && appId !=''){
                appRecord                                                                       = [SELECT Id,Application_Stage__c,Name,Security_coverage__c,Sub_Stage__c,Legal_clearance__c,Recommended_Security_Coverage__c FROM genesis__Applications__c WHERE Id=:appId];

            }
            System.debug('###########'+appRecord);
            for(genesis__Application_Collateral__c appColRecord:[SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c=:appId AND genesis__Collateral__r.FE_Created__c=true]){
                if(appColRecord.genesis__Collateral__r.FE_Created__c == true )
                    isMarketValueValid                                                          = true;
            }
            //allAppCollateral                                                                        =[SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c=:appId AND (genesis__Collateral__r.RecordTypeId =:Land_And_Building_RT OR genesis__Collateral__r.RecordTypeId=:Land_And_Building_Other_RT)];
            //if(allAppCollateral.size() == 0) isMarketValueValid = false;
            // Code to check if legal clearence flag is false (If and only if FE CReated is true for any of the Collateral)


            if(isFinalAuthOrLegal == 'FINAL_AUTHORITY'){


                if(appRecord != null && ((appRecord.Legal_clearance__c && isMarketValueValid) || ! isMarketValueValid)){
                    // if legal has already been done
                    if(isRMDTaskHasBeenDone(appId)){
                        returnString                                                            =  updateFinalSecurityCoverageHelper(appId,'FSO');
                    }
                    else{
                        returnString                                                            =  updateFinalSecurityCoverageHelper(appId,'FS');
                    }
                }else {
                    appRecord.Sub_Stage__c                                                  = 'Legal Clearance Pending';
                    applicationSubStage                                                     = appRecord.Sub_Stage__c;
                    update appRecord;
                    updateFinalSecurityCoverageHelper(appId,'FS');
                    returnString                                                            = 'Application Sub Stage changed to Legal Clearance Pending';
                }

            }else if(isFinalAuthOrLegal == 'LEGAL' ){
                closeExistingLeagalTask(appId,'Legal Evaluation');
                // Below three update lines are common in both(if else)
                if(appRecord.Sub_Stage__c == 'Legal Clearance Pending' && isRMDTaskHasBeenDone(appId)){
                    appRecord.Sub_Stage__c                                                      = 'Legal Clearance Approved';
                    appRecord.Legal_clearance__c                                                = TRUE;
                    applicationSubStage                                                         = appRecord.Sub_Stage__c;
                    update appRecord;
                    updateFacilitySpread(appId);
                    returnString                                                                =  updateFinalSecurityCoverageHelper(appId,'FSO');
                }else{
                    appRecord.Sub_Stage__c                                                      = 'Legal Clearance Approved';
                    applicationSubStage                                                         = appRecord.Sub_Stage__c;
                    appRecord.Legal_clearance__c                                                = TRUE;
                    update appRecord;
                    returnString                                                                =  'Final Authority Recommendation is Pending';
                }
            }else if(isFinalAuthOrLegal == 'RMD'){
                if(((appRecord.Legal_clearance__c && isMarketValueValid) || ! isMarketValueValid) && (appRecord.Application_Stage__c == 'Enhancement- Final sanction' || appRecord.Application_Stage__c == 'Adhoc-Final sanction' || appRecord.Application_Stage__c == 'New loan - Final sanction')){
                    //appRecord.Sub_Stage__c                                                      = 'Legal Clearance Approved';
                    //appRecord.Legal_clearance__c                                                = TRUE;
                    //applicationSubStage                                                         = appRecord.Sub_Stage__c;
                    //update appRecord;
                    updateFacilitySpread(appId);
                    returnString                                                                =  updateFinalSecurityCoverageHelper(appId,'FSO');
                }else{
                    returnString                                                                =  'Legal Clearence or Final Authority Reccomendation is Pending';

                }

            }
            else{
                returnString                                                                    = 'Parameters for Calculating Final Coverage are not correct';
            }

            return returnString;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateFinalSecurityCoverage', e);
            return 'Some Error Occurred while updating final security coverage';
        }


    }

    /**
* * Method to calculate final Security Coverage(reusable)
* Is Called from Leagal Evaluaation Page as well As Underwriting dashboard
*
* @param appId
*
* @return
*/
    public static String updateFinalSecurityCoverageHelper(String appId ,String stageName){
        try{
            genesis__Applications__c appRecord ;
            String returnString='';
            Boolean isMarketValueValid                                                              = true;
            Map<String,Decimal>  securCoverage                                                      = new Map<String, Decimal>();
            List<genesis__Application_Collateral__c> allAppCollateral                               = new List<genesis__Application_Collateral__c>();
            String Land_And_Building_RT                                                             = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();
            String Land_And_Building_Other_RT                                                        = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Buildings - Other').getRecordTypeId();
            if(appId != null && appId !=''){
                appRecord                                                                           = [SELECT Id,Application_Stage__c,Name,Type__c,Security_coverage__c,Recommended_Security_Coverage__c,RecordType.DeveloperName,Legal_clearance__c FROM genesis__Applications__c WHERE Id=:appId];
            }

            allAppCollateral                                                                        =[SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c=:appId AND (genesis__Collateral__r.RecordTypeId =:Land_And_Building_RT OR genesis__Collateral__r.RecordTypeId=:Land_And_Building_Other_RT)];
            if(allAppCollateral.size() == 0) isMarketValueValid = false;

            // Code to run if all collateral has has market value as >=0
            string query                                                                            = 'Select id,Product_Category__c,Application__r.New_to_Business__c,Application__r.Is_Take_Over__c,Application__r.Type__c,Application__r.Parent_Application__c,Name,Application__r.RecordType.DeveloperName,Application__c,Application__r.ownerId,Application__r.Application_Stage__c,Limit_Amount__c,Existing_Limit__c,Type__c,Application__r.genesis__Account__c,CL_Product__c,Existing_Rate__c,Existing_Processing_Charge__c,Approved_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Recommended_Limit__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c'+', (select id,genesis__Collateral__c from Facility_Security__r) from Facility__c where Application__c =:appId';
            List<Facility__c> facList                                                               = Database.query(query);
            SanctionMatrix_Calculation sanc                                                         = new SanctionMatrix_Calculation();
            SanctionMatrix_Calculation.COVERAGE_MAP coveragemap                                     = new SanctionMatrix_Calculation.COVERAGE_MAP();

            coveragemap                                                                         = sanc.calculateAuthority(facList,false,SanctionMatrix_Calculation.ONLY_COVERAGE_METHOD,null);

            if(isMarketValueValid ){
                system.debug('Exeption In::');

                system.debug('Exeption In::');
                if(stageName=='FSO') {
                    if (appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT) {
                        appRecord.Application_Stage__c = 'Enhancement- Final sanction offered';
                        applicationStage = 'Enhancement- Final sanction offered';
                        returnString = 'Application stage has been changed to ' + 'Enhancement- Final sanction offered';
                    }
                    if (appRecord.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE) {
                        appRecord.Application_Stage__c = Constants.NEW_LOAN_FINAL_SANCTION_OFFERED;
                        applicationStage = Constants.NEW_LOAN_FINAL_SANCTION_OFFERED;
                        returnString = 'Application stage has been changed to ' + Constants.NEW_LOAN_FINAL_SANCTION_OFFERED;
                    }

                    else if (appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC) {
                        appRecord.Application_Stage__c = 'Adhoc- Final sanction offered';
                        applicationStage = 'Adhoc- Final sanction offered';
                        returnString = 'Application stage has been changed to ' + 'Adhoc- Final sanction offered';
                    }
                    appRecord.Sub_Stage__c = '';
                    applicationSubStage = appRecord.Sub_Stage__c;
                }
            }
            if(coveragemap != null){
                appRecord.Security_coverage__c                                                      = coveragemap.finalCoverage;
            }

            if(coveragemap.message == SanctionMatrix_Calculation.INSUFFICIENT_COVERAGE){

                createInsCollTaskForBm(appId);

                appRecord.Sub_Stage__c                                                              = 'Insufficient collateral coverage';
                applicationUiStage                                                                 = SOQL_Util.getApplicationUISatge(appId);
                applicationSubStage                                                                 = 'Insufficient collateral coverage';
                isFinalCoverageLess                                                                 = true;
                appRecord.Is_Financial_security_Coverage_Less__c                                    = true;
                if(appRecord.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    appRecord.Application_Stage__c                                                      = Constants.New_Loan_Submitted;
                }else{

                    appRecord.Application_Stage__c                                                      = 'Application review';
                }
                returnString                                                                        =  'BM Has been Notified for Adding up additional collateral';
            }else if(coveragemap.message == SanctionMatrix_Calculation.SUFFICIENT_COVERAGE && stageName == 'FS'){
                system.debug('Exeption In::');
                isFinalCoverageLess                                                                 = false;
                appRecord.Is_Financial_security_Coverage_Less__c                                    = false;
                //appRecord.Sub_Stage__c                                                              = 'MOD Pending';

                if(appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                    appRecord.Application_Stage__c                                                  = 'Enhancement- Final sanction';
                    applicationStage                                                                = 'Enhancement- Final sanction';
                }
                else if(appRecord.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    appRecord.Application_Stage__c                                                  = Constants.NEW_LOAN_FINAL_SANCTION;
                    applicationStage                                                                = Constants.NEW_LOAN_FINAL_SANCTION;
                }

                else if(appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                    appRecord.Application_Stage__c                                                  = 'Adhoc-Final sanction';
                    applicationStage                                                                = 'Adhoc-Final sanction';
                }

            }
            update appRecord;
            if(appRecord.Application_Stage__c == Constants.NEW_LOAN_FINAL_SANCTION_OFFERED && appRecord.Type__c !=null && appRecord.Type__c.contains('NTB')){
                List<User> COuserLst=SOQL_Util.getBRCreditOfficer(appId);
                if(COuserLst.size()>0){
                    SOQL_Util.createTaskForBRCreditOfficer(appId,COuserLst[0].Id,'Fill CBS Customer Info','Update CBS Info');

                }else{
                    SOQL_Util.createTaskForBM(appId,'Fill CBS Customer Info','Update CBS Info');
                }
            }
            setOfString.add(appRecord.id);
            return returnString;
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateFinalSecurityCoverageHelper', e);
            return 'Some Error Occurred';
        }
    }

    /**
* re-Usable Method to trim Salesdforce 18 digit id to 15 Digit
*
* @param securityCoverage
*
* @return
*/
    public static Map<String,Decimal> getTrimmedIds(Map<String,Decimal> securityCoverage){

        Map<String,Decimal> securityCoverageMapToReturn                                             = new Map<String,Decimal>();
        for(String keyValue:securityCoverage.keySet()){
            securityCoverageMapToReturn.put(keyValue.left(15),securityCoverage.get(keyValue));

        }if (! securityCoverageMapToReturn.isEmpty()) {
            return securityCoverageMapToReturn;
        }else{
            return  null;
        }
    }

    /**
* Method To Close BM Task and Update Application with given Application Stage
*
* @param appupdate
*
* @return
*/
    public static Underwriting_CTRL.ReturnWrap updateApplicationAndTaskForBUUser(genesis__Applications__c appupdate){

        Underwriting_CTRL.ReturnWrap wrp                                                            = new Underwriting_CTRL.ReturnWrap();
        User loggedInUser                                                                           = SanctionUnderwriting_Process.currentUserInfo();
        List<Task> authTask                                                                         = new List<Task>();

        try{

            authTask                                                                                = SanctionUnderwriting_Process.getUserTaskList(appupdate.Id,loggedInUser.Id);
            //System.debug('@@@@'+authTask);
            if(authTask.size() > 0){
                for(Task t : authTask){
                    t.Status                                                                        = Constants.COMPLETED_STATUS;
                }
                TaskFlow_Helper.TASK_TRIGGER_RUNNING                                                = true;
                update authTask;
            }
            update appupdate;

            wrp.message                                                                             = 'BM recommendation has been saved.';
            return wrp;

        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateApplicationAndTaskForBUUser', e);
            wrp.message                                     ='Some Error Occurred while saving your inputs';
            return wrp;
        }


    }

    /**
* Method To Calculate Processing Charges
*
* @param savedata
*/
    public static void calculateProcessingCharges(Underwriting_CTRL.saveWrapper savedata){
        try {
            nonFundedProcessingCharges                                                              = getNonSchematicProcessingCharges();
            System.debug('@@@@@@'+nonFundedProcessingCharges);
            System.debug('@@@@@@'+nonFundedProcessingCharges);

            List<String> parentFacilityIds                                                          = new List<String>();
            List<String> productIds                                                                 = new List<String>();

            for(Integer fCount = 0; fCount < savedata.facility.size(); fCount++){
                parentFacilityIds.add(savedata.facility[fCount].Id);
                productIds.add(savedata.facility[fCount].CL_Product__c);
            }

            if(!parentFacilityIds.isEmpty()){
                System.debug('@ parentFacilityIds'+parentFacilityIds);
                System.debug('@ productIds'+productIds);
                ifSchematic                                                                          = checkIfFacilityIsScematic(parentFacilityIds);
                System.debug('@ if Schematic'+ifSchematic);
                if(ifSchematic){
                    processRec                                                                      = getProcessingFeeRecord(productIds);
                }/*else{
processRec                                                                      = getProcessingFeeRecord(productIds,'No');
}*/
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'calculateProcessingCharges', e);
        }

    }

    /**
* Method To Update two Field on Facility(Final_Enhanced_Processing_Fee__c,Existing_Enhanced_Processing_Fee__c) According to proceesing charge record selecetd
*
* @param childFacRecord
* @param aggregateRecLimit
*
* @return
*/
    public static Facility__c calculatePercentageChangeInExistingFacility(Facility__c childFacRecord,Decimal aggregateRecLimit){
        try {

            System.debug('childFacRecord'+childFacRecord);
            System.debug('childFacRecord.Recommended_Processing_Charge__c'+childFacRecord.Recommended_Processing_Charge__c);
            if(childFacRecord != null && childFacRecord.Recommended_Processing_Charge__c != null){

                System.debug('childFacRecord.Type__c'+childFacRecord.Type__c);
                if(childFacRecord.Type__c == 'Non-Funded'){

                    if(ifSchematic){
                        //Apply Schematic

                        if(processRec  != null){

                            if(aggregateRecLimit >processRec.Limit__c){


                                if(processRec.New_Greater_than_limit__c != null){

                                    childFacRecord.Final_Enhanced_Processing_Fee__c                         = childFacRecord.Recommended_Processing_Charge__c;

                                    //Decimal percentageToBeLessed                                            =(childFacRecord.Recommended_Processing_Charge__c/processRec.New_Greater_than_limit__c)*100;
                                    Decimal percentageToBeLessed                                            = getPercentageToBeDeviated(childFacRecord.Recommended_Processing_Charge__c,processRec.New_Greater_than_limit__c);

                                    if(childFacRecord.Recommended_Processing_Charge__c <=processRec.New_Greater_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                      = childFacRecord.Existing_Processing_Charge__c - (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(childFacRecord.Recommended_Processing_Charge__c >processRec.New_Greater_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c + (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(percentageToBeLessed == 100)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c;
                                }

                            }else{
                                if(processRec.New_Less_than_limit__c != null){
                                    childFacRecord.Final_Enhanced_Processing_Fee__c                         = childFacRecord.Recommended_Processing_Charge__c;
                                    //Decimal percentageToBeLessed                                            =(childFacRecord.Recommended_Processing_Charge__c/processRec.New_Less_than_limit__c)*100;
                                    Decimal percentageToBeLessed                                            = getPercentageToBeDeviated(childFacRecord.Recommended_Processing_Charge__c,processRec.New_Less_than_limit__c);

                                    if(childFacRecord.Recommended_Processing_Charge__c <=processRec.New_Less_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c - (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(childFacRecord.Recommended_Processing_Charge__c >processRec.New_Less_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c + (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(percentageToBeLessed == 100)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c;
                                }
                            }
                        }
                        System.debug('childFacRecord.Type__c'+childFacRecord);
                    }else{
                        //Apply Non-Schematic
                        if(nonFundedProcessingCharges != null){
                            if(aggregateRecLimit >nonFundedProcessingCharges.Limit__c){
                                if(nonFundedProcessingCharges.New_Greater_than_limit__c != null){
                                    childFacRecord.Final_Enhanced_Processing_Fee__c                         = childFacRecord.Recommended_Processing_Charge__c;
                                    //Decimal percentageToBeLessed                                            =(childFacRecord.Recommended_Processing_Charge__c/nonFundedProcessingCharges.New_Greater_than_limit__c)*100;
                                    Decimal percentageToBeLessed                                            = getPercentageToBeDeviated(childFacRecord.Recommended_Processing_Charge__c,nonFundedProcessingCharges.New_Greater_than_limit__c);

                                    if(childFacRecord.Recommended_Processing_Charge__c <=nonFundedProcessingCharges.New_Greater_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                      = childFacRecord.Existing_Processing_Charge__c - (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(childFacRecord.Recommended_Processing_Charge__c >nonFundedProcessingCharges.New_Greater_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c + (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(percentageToBeLessed == 100)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c;
                                }

                            }else{
                                if(nonFundedProcessingCharges.New_Less_than_limit__c != null){
                                    childFacRecord.Final_Enhanced_Processing_Fee__c                         = childFacRecord.Recommended_Processing_Charge__c;
                                    //Decimal percentageToBeLessed                                            =(childFacRecord.Recommended_Processing_Charge__c/nonFundedProcessingCharges.New_Less_than_limit__c)*100;
                                    Decimal percentageToBeLessed                                            = getPercentageToBeDeviated(childFacRecord.Recommended_Processing_Charge__c,nonFundedProcessingCharges.New_Less_than_limit__c);

                                    if(childFacRecord.Recommended_Processing_Charge__c <=nonFundedProcessingCharges.New_Less_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c - (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(childFacRecord.Recommended_Processing_Charge__c >nonFundedProcessingCharges.New_Less_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c + (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(percentageToBeLessed == 100)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c;
                                }
                            }
                        }
                        System.debug('childFacRecord.Type__c'+childFacRecord);

                    }
                }else if(childFacRecord.Type__c == 'Funded'){

                    if(ifSchematic){
                        //Apply Schematic
                        System.debug('###########'+ifSchematic);
                        if(processRec  != null){
                            System.debug('###########'+processRec);
                            if(aggregateRecLimit >processRec.Limit__c){
                                System.debug('###########'+processRec.Limit__c);
                                if(processRec.New_Greater_than_limit__c != null){
                                    System.debug('###########'+processRec.New_Greater_than_limit__c);
                                    childFacRecord.Final_Enhanced_Processing_Fee__c                         = childFacRecord.Recommended_Processing_Charge__c;
                                    //Decimal percentageToBeLessed                                            =(childFacRecord.Recommended_Processing_Charge__c/processRec.New_Greater_than_limit__c)*100;
                                    Decimal percentageToBeLessed                                            = getPercentageToBeDeviated(childFacRecord.Recommended_Processing_Charge__c,processRec.New_Greater_than_limit__c);
                                    System.debug('###########'+percentageToBeLessed);
                                    if(childFacRecord.Recommended_Processing_Charge__c <=processRec.New_Greater_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                      = childFacRecord.Existing_Processing_Charge__c - (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(childFacRecord.Recommended_Processing_Charge__c >processRec.New_Greater_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c + (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(percentageToBeLessed == 100.00)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c;
                                }

                            }else{
                                if(processRec.New_Less_than_limit__c != null){
                                    childFacRecord.Final_Enhanced_Processing_Fee__c                         = childFacRecord.Recommended_Processing_Charge__c;
                                    //Decimal percentageToBeLessed                                            =(childFacRecord.Recommended_Processing_Charge__c/processRec.New_Less_than_limit__c)*100;
                                    Decimal percentageToBeLessed                                            = getPercentageToBeDeviated(childFacRecord.Recommended_Processing_Charge__c,processRec.New_Less_than_limit__c);

                                    if(childFacRecord.Recommended_Processing_Charge__c <=processRec.New_Less_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c - (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(childFacRecord.Recommended_Processing_Charge__c >processRec.New_Less_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c + (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(percentageToBeLessed == 100.00)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c;
                                }
                            }
                        }
                        System.debug('childFacRecord.Type__c'+childFacRecord);
                    }else{
                        //Apply Non-Schematic
                        if(nonFundedProcessingCharges != null){
                            if(aggregateRecLimit >nonFundedProcessingCharges.Limit__c){
                                if(nonFundedProcessingCharges.New_Greater_than_limit__c != null){
                                    childFacRecord.Final_Enhanced_Processing_Fee__c                         = childFacRecord.Recommended_Processing_Charge__c;
                                    //Decimal percentageToBeLessed                                            =(childFacRecord.Recommended_Processing_Charge__c/nonFundedProcessingCharges.New_Greater_than_limit__c)*100;
                                    Decimal percentageToBeLessed                                            = getPercentageToBeDeviated(childFacRecord.Recommended_Processing_Charge__c,nonFundedProcessingCharges.New_Greater_than_limit__c);

                                    if(childFacRecord.Recommended_Processing_Charge__c <=nonFundedProcessingCharges.New_Greater_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                      = childFacRecord.Existing_Processing_Charge__c - (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(childFacRecord.Recommended_Processing_Charge__c >nonFundedProcessingCharges.New_Greater_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c + (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(percentageToBeLessed == 100.00)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c;
                                }

                            }else{
                                if(nonFundedProcessingCharges.New_Less_than_limit__c != null){
                                    childFacRecord.Final_Enhanced_Processing_Fee__c                         = childFacRecord.Recommended_Processing_Charge__c;
                                    //Decimal percentageToBeLessed                                            =(childFacRecord.Recommended_Processing_Charge__c/nonFundedProcessingCharges.New_Less_than_limit__c)*100;
                                    Decimal percentageToBeLessed                                            = getPercentageToBeDeviated(childFacRecord.Recommended_Processing_Charge__c,nonFundedProcessingCharges.New_Less_than_limit__c);

                                    if(childFacRecord.Recommended_Processing_Charge__c <=nonFundedProcessingCharges.New_Less_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c - (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(childFacRecord.Recommended_Processing_Charge__c >nonFundedProcessingCharges.New_Less_than_limit__c)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c + (childFacRecord.Existing_Processing_Charge__c*percentageToBeLessed)/100;
                                    if(percentageToBeLessed == 100.00)
                                        childFacRecord.Existing_Enhanced_Processing_Fee__c                  = childFacRecord.Existing_Processing_Charge__c;
                                }
                            }
                        }
                        System.debug('childFacRecord.Type__c'+childFacRecord);
                    }
                }
            }
            //return childFacRecord;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'calculatePercentageChangeInExistingFacility', e);
        }
        System.debug('###########'+childFacRecord);
        return childFacRecord;
    }
    public static Decimal getPercentageToBeDeviated(Decimal reccomended,Decimal newLimit){
        if(reccomended > newLimit){
            return ((reccomended-newLimit)/newLimit)*100;
        }else{
            return ((newLimit-reccomended)/newLimit)*100;
        }
    }
    /**
* Method to get Appropriate Processing Charge Record on the basis of Schematic/NonSchematic
*
* @param productIds
* @param schematicOrNonSchematic
*
* @return
*/
    public static Processing_charges_scheme__c getProcessingFeeRecord(List<String> productIds){
        try {

            List<Processing_charges_scheme__c> processingChargesRecord                             = [Select Id,Name,Product__c,Limit__c,New_Greater_than_limit__c,New_Less_than_limit__c,Renewal_Greater_than_limit__c,Renewal_Less_than_limit__c,Product__r.Schematic_Loan__c from Processing_charges_scheme__c where Product__c IN:productIds];
            System.debug('@ Processing Charge'+processingChargesRecord);
            if(!processingChargesRecord.isEmpty()){
                return processingChargesRecord[0];
            }
            return null;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'getProcessingFeeRecord', e);
            return null;
        }

    }

    /**
* Method To Check if facility Is Schematic or Non-Schematic
*
* @param parentFacilityIds
*
* @return
*/
    public static Boolean checkIfFacilityIsScematic(List<String> parentFacilityIds){
        try {
            List<Facility__c> parentFacilityRec                                                     = [Select Id,CL_Product__c,CL_Product__r.Schematic_Loan__c,CL_Product__r.Is_Schematic_Non_Funded__c from Facility__c where Id IN:parentFacilityIds And CL_Product__r.Schematic_Loan__c ='Yes'];
            for(Facility__c facRec:parentFacilityRec){
                if(facRec.CL_Product__r.Is_Schematic_Non_Funded__c)
                    isSchematicNonFunded                                                            = true;

            }
            return parentFacilityRec.size()>0 ?true:false;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIfFacilityIsScematic', e);
            return false;
        }

    }

    public static Underwriting_CTRL.ReturnWrap saveData(Underwriting_CTRL.saveWrapper savedata){
        String finalAuthComment                                     ='';
        Underwriting_CTRL.ReturnWrap wrp                            = new Underwriting_CTRL.ReturnWrap();
        Savepoint sp                                                = database.setSavepoint();
        List<Facility__c> facilities                                = new List<Facility__c>();
        Set<string> newRoleList                                     = new Set<string>();
        genesis__Applications__c appupdate                          = new genesis__Applications__c();
        genesis__Applications__c applnInfo                          = new genesis__Applications__c();
        integer finalRoleOrder                                      = 0;
        string currentRole                                          = '';

        Boolean isExceedingAdhoc                                    = false;
        Boolean isExceedingFinalAuth                                = false;
        List<genesis__Application_Status_History__c> appHistoryList = new List<genesis__Application_Status_History__c>();
        Map<String,Deviation_Rules__c> ruleMap                      = new Map<String,Deviation_Rules__c>();
        List<Facility__c>              facilitiesToUpdateWithSpread = new List<Facility__c>();
        Map<Id,Decimal>                facilityByMCLR               = new Map<Id, Decimal>();
        facilityByMCLR                                              = facilityWiseMCLRRate(savedata.appId);

        Map<Id,Decimal> faciIdwithValMap                            = new Map<Id,Decimal>();
        Facility__c facInstance;

        List<Renewal_Checklists__c> checkList                       = new List<Renewal_Checklists__c>();
        try{
            applnInfo                                               = Underwriting_CTRL_Helper.getapplnInformation(savedata.appId);
            if(applnInfo !=null && applnInfo.New_to_Business__c && savedata.IsFinalAuthority){
                checkList                                           = [Select id,Checklist_Name__c,Complied__c from Renewal_Checklists__c where Complied__c =:Constants.NO_STRING AND Application__c =:savedata.appId];    
            }else if(applnInfo !=null && !applnInfo.New_to_Business__c){
                checkList                                           = [Select id,Checklist_Name__c,Complied__c from Renewal_Checklists__c where Complied__c =:Constants.NO_STRING AND Application__c =:savedata.appId];
            }
            List<String> reRenewalList                              = new List<String>();
            If(!checkList.isEmpty()){
                Underwriting_CTRL_Helper ctrl                           = new Underwriting_CTRL_Helper ();
                reRenewalList                                           = ctrl.getCheckListPendingReason(checkList);    
            }
            List<Authority_Hierarchy_Level__mdt> authLevelList      = new List<Authority_Hierarchy_Level__mdt>();
            if(applnInfo !=null && applnInfo.New_to_Business__c && savedata.IsFinalAuthority){
                authLevelList                                           = SanctionMatrix_Helper.getAuthorityLevel();       
            }else if(applnInfo !=null && !applnInfo.New_to_Business__c){
                authLevelList                                           = SanctionMatrix_Helper.getAuthorityLevel();    
            }
            BMAuthrecommendationIds                                 = SOQL_Util.BMAuthrecommendationIdsHelper(savedata.appId);
            applicationStage                                        = applnInfo.Application_Stage__c;
            if(applnInfo != null){
                // Earlier it was for Exceeding and adhoc
                // Now only for  Exceeding
                if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                    isExceedingAdhoc = true;
                    if(!savedata.isMoreThanTenDays && !savedata.IsFinalAuthority && SanctionMatrixController_EA.saveAuthorityreccomendations(savedata.appId,savedata.isMoreThanTenDays,false) == 'BM'){
                        System.debug('@@@ Calling Exceeding Sanction');
                        isExceedingFinalAuth =true;
                    }


                }
            }
            List<Deviation_Rules__c> deviationRules                 = new List<Deviation_Rules__c>();
            if(applnInfo !=null && applnInfo.New_to_Business__c && savedata.IsFinalAuthority){
                deviationRules                 = [select id,CO_GM__c,COCC__c,DOCC__c,Schematic__c,Rule__c,President_and_COO__c,Limit_Value__c from Deviation_Rules__c];
            }else if(applnInfo !=null && !applnInfo.New_to_Business__c){
                deviationRules                 = [select id,CO_GM__c,COCC__c,DOCC__c,Schematic__c,Rule__c,President_and_COO__c,Limit_Value__c from Deviation_Rules__c];
            }
            String fchildRecordTypeID                               = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get(Constants.FACILITY_CHILD_RECORD_TYPE).getRecordTypeId();

            User loggedInUser                                       = SanctionUnderwriting_Process.currentUserInfo();
            If(deviationRules !=null && !deviationRules.isEmpty()){
                for(Deviation_Rules__c rule:deviationRules){
                    ruleMap.put(rule.Rule__c, rule);
                }    
            }
            // Code Added for computing spread value
            faciIdwithValMap = Underwriting_CTRL_Helper.getFacilityWiseSpreadValues(savedata.appId);

            System.debug('########'+faciIdwithValMap);
            Decimal MCLRFromMCLRMaster = getMCLRValuesFromMaster();
            if(faciIdwithValMap != null)
                if(!faciIdwithValMap.isEmpty() && (applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == 'SME_Renewal')){
                    // Updating Existing spread value on parent facility
                    for(Id facId:faciIdwithValMap.keySet()){
                        if(faciIdwithValMap.get(facId) != null)
                            //facInstance = new Facility__c(Id=facId,Existing_Spread__c=faciIdwithValMap.get(facId),Existing_Rate__c=facilityByMCLR.get(facId)+faciIdwithValMap.get(facId));
                            facInstance = new Facility__c(Id=facId,BRE_Spread__c=faciIdwithValMap.get(facId),BRE_Rate__c=faciIdwithValMap.get(facId)+MCLRFromMCLRMaster);

                        facilitiesToUpdateWithSpread.add(facInstance);
                    }
                    if(!facilitiesToUpdateWithSpread.isEmpty()) update facilitiesToUpdateWithSpread;

                    // Updating Existing Spread in saveData.facility
                    for(Integer fCount = 0; fCount < savedata.facility.size(); fCount++){
                        //savedata.facility[fCount].Existing_Rate__c = savedata.facility[fCount].MCLR_Rate__c + faciIdwithValMap.get(savedata.facility[fCount].Facility__c);

                    }
                }
            // not for exceeding and adhoc
            if(savedata.facility.size() > 0){
                if(savedata.isSaveOrSubmit == YearDataConstant.submitAction && (applnInfo.Application_Stage__c   != Constants.APPLICATION_REVIEW_STAGE && applnInfo.Application_Stage__c   != Constants.APP_REVIEW_FINANCIAL_STAGE)
                        && applnInfo.Overall_Score__c !=null   ){
                    // && applnInfo.Type__c != 'NTB - New to credit' && applnInfo.Type__c != 'ETB-CA - New to credit'
                    if( (savedata.IsFinalAuthority || (isExceedingFinalAuth)) && ((Decimal.valueOf(applnInfo.Overall_Score__c) < KVB_Company_Details__c.getOrgDefaults().Overall_score__c || (AccountTriggerHandler.checkFinancialFlagStatus(applnInfo.Id) && applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE)) || (((Decimal.valueOf(applnInfo.Overall_Score__c) >= KVB_Company_Details__c.getOrgDefaults().Rejection_Threshold__c) && (Decimal.valueOf(applnInfo.Overall_Score__c) < KVB_Company_Details__c.getOrgDefaults().Overall_score__c))))){
                        String nextHrchyLevel                       = getLevelHirerachyMap(authLevelList,savedata.facility[0].Role__c);
                       /* if(applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE ){
                            if(applnInfo.New_to_Business__c){
                                if(nextHrchyLevel != null){
                                    deviationReason +='Overall score deviation;';
                                    newRoleList.add(nextHrchyLevel);
                                }
                            }
                        }else{*/
                            system.debug('nextHrchyLevel:::'+nextHrchyLevel);
                            if(nextHrchyLevel != null){
                                deviationReason +='Overall score deviation;';
                                newRoleList.add(nextHrchyLevel);
                            }
                        //}
                    }
                }
                if(savedata.IsFinalAuthority && applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE ){
                    String nextHrchyLevel                       = getLevelHirerachyMap(authLevelList,savedata.facility[0].Role__c);
                    Map<String,Boolean> hasDeviated             =  new Map<String, Boolean>();
                    hasDeviated                                 = YearDataConstant.getCibilScore_Reject(savedata.appId);
                    if(!hasDeviated.isEmpty()){
                        if(hasDeviated.containsKey('IS_DEVIATED_CIBIL') && hasDeviated.get('IS_DEVIATED_CIBIL')==true){
                            deviationReason +='Cibil Deviation;';
                            newRoleList.add('RMD');
                        }
                        else if(hasDeviated.containsKey('IS_DEVIATED_CMR') && hasDeviated.get('IS_DEVIATED_CMR')==true){
                            deviationReason +='CMR Deviation;';
                            newRoleList.add('RMD');
                        }
                    }
                }
                /*if(savedata.isSaveOrSubmit == YearDataConstant.submitAction && applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE && savedata.IsFinalAuthority){
                    if(!YearDataConstant.getCheque_Return_Gr_than_2(applnInfo) || !YearDataConstant.getManagement_Exp_Gr_than_3(applnInfo) || !YearDataConstant.getMinCibilScore_Gr_than_700(savedata.appId)){

                        String nextHrchyLevel                       = getLevelHirerachyMap(authLevelList,savedata.facility[0].Role__c);
                        System.debug('############## nextHrchyLevel'+nextHrchyLevel);
                        if(nextHrchyLevel != null){
                            deviationReason +='New to Credit Deviation;';
                            newRoleList.add(nextHrchyLevel);
                        }
                    }
                }*/
                if(savedata.isSaveOrSubmit == YearDataConstant.submitAction && !isExceedingAdhoc  && savedata.IsFinalAuthority && loggedInUser.Designation__c.contains('BR_') && reRenewalList.size()>0){
                    if(applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                        if(applnInfo.Type__c == 'ETB-WC'){
                            deviationReason +='Pre-renewal deviation;';
                            newRoleList.add('DO_DM');
                        }
                    }else{
                        deviationReason +='Pre-renewal deviation;';
                        newRoleList.add('DO_DM');
                    }
                }
                Decimal aggreegateLimit = 0;
                if(savedata.facility !=null){
                    for(Integer fCount = 0; fCount < savedata.facility.size(); fCount++){
                        if(savedata.facility[fCount].Recommended_Limit__c !=null)
                            aggreegateLimit+=savedata.facility[fCount].Recommended_Limit__c;
                    }
                }
                System.debug('@@@@@@@@@@@@2'+aggreegateLimit);
                if(savedata.IsFinalAuthority ){
                    Decimal  LimitAssesmentComparableValue       = Underwriting_CTRL_Helper.getMBFPValue(savedata.appId);
                    System.debug('@@@@@@@@@@@@ LimitAssesmentComparableValue'+LimitAssesmentComparableValue);
                    if(LimitAssesmentComparableValue != null && aggreegateLimit >LimitAssesmentComparableValue){
                        String nextHrchyLevel                       = getLevelHirerachyMap(authLevelList,savedata.facility[0].Role__c);
                        if(nextHrchyLevel != null){
                            deviationReason +='Limit Deviation;';
                            newRoleList.add(nextHrchyLevel);
                        }
                    }
                    If(applnInfo.New_to_Business__c){
                        Boolean isNTBRMD_Deviation = false;
                        isNTBRMD_Deviation = YearDataConstant.checkNewToBusinessRMD_Deviation(applnInfo.Id);
                        if(isNTBRMD_Deviation && aggreegateLimit > 2500000){
                            deviationReason +='New to business;';
                            newRoleList.add('RMD');    
                        }
                    }
                }
                for(Integer fCount = 0; fCount < savedata.facility.size(); fCount++){
                    System.debug('**************'+savedata.facility[fCount].Recommended_Limit__c);
                    System.debug('**************'+savedata.facility[fCount].Recommended_Processing_Charge__c);
                    System.debug('@@@@'+savedata.facility[fCount]);
                    if((applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE) && savedata.IsFinalAuthority){
                        calculateProcessingCharges(savedata);
                        //savedata.facility[fCount] = calculatePercentageChangeInExistingFacility(savedata.facility[fCount],aggreegateLimit);
                    }

                    genesis__Application_Status_History__c appHistory = new genesis__Application_Status_History__c();
                    Deviation_Rules__c devRule;
                    currentRole                                       = savedata.facility[fCount].Role__c;
                    finalRoleOrder                                    = integer.valueOf( savedata.facility[fCount].Higher_Authority_Order__c);
                    Facility__c facility                              = new Facility__c();
                    Facility__c parentFacility                        = new Facility__c();
                    facility.Id                                       = savedata.facility[fCount].id;
                    parentFacility.Id                                 = savedata.facility[fCount].Facility__c;
                    parentFacility.Is_Save_Operation_Done__c          = savedata.facility[fCount].Is_Save_Operation_Done__c;
                    parentFacility.Is_Facility_App_Type_Upadte__c		  = savedata.facility[fCount].Is_Facility_App_Type_Upadte__c;
                    parentFacility.Faciliity_Type__c		  = savedata.facility[fCount].Facility_Application_Type__c;
                    if(savedata.facility[fCount].Recommended_Limit__c != null && savedata.facility[fCount].Recommended_Limit__c >=0){

                        facility.Recommended_Limit__c                 = savedata.facility[fCount].Recommended_Limit__c;
                        appHistory.Recommendation_Limit_Rs__c         = savedata.facility[fCount].Recommended_Limit__c;
                        parentFacility.Recommended_Limit__c           = savedata.facility[fCount].Recommended_Limit__c;

                    }
                    if((applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE) && savedata.IsFinalAuthority){
                        System.debug('@@@@@@@@@@@@@@@@@@@@@@@'+savedata.facility[fCount].Existing_Enhanced_Processing_Fee__c);
                        System.debug('@@@@@@@@@@@@@@@@@@@@@@@'+savedata.facility[fCount].Final_Enhanced_Processing_Fee__c);
                        if(savedata.facility[fCount].Existing_Enhanced_Processing_Fee__c != null && savedata.facility[fCount].Existing_Enhanced_Processing_Fee__c >=0){
                            parentFacility.Existing_Enhanced_Processing_Fee__c = savedata.facility[fCount].Existing_Enhanced_Processing_Fee__c;
                        }
                        if(savedata.facility[fCount].Final_Enhanced_Processing_Fee__c != null && savedata.facility[fCount].Final_Enhanced_Processing_Fee__c >=0){
                            parentFacility.Final_Enhanced_Processing_Fee__c = savedata.facility[fCount].Final_Enhanced_Processing_Fee__c;
                        }
                    }
                    System.debug('@@@@'+isExceedingAdhoc);
                    if((isExceedingAdhoc || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC)  && savedata.facility[fCount].Recommended_Days__c != null && savedata.facility[fCount].Recommended_Days__c >=0){
                        System.debug('@@@@'+savedata.facility[fCount].Recommended_Days__c);
                        facility.Recommended_Days__c                 = savedata.facility[fCount].Recommended_Days__c;
                        parentFacility.Recommended_Days__c           = savedata.facility[fCount].Recommended_Days__c;

                    }
                    // Spread deviation would'nt be there in case of Exceeding and Adhoc
                    if(savedata.facility[fCount].Recommended_Rate__c != null && savedata.facility[fCount].Recommended_Rate__c >= 0 ){
                        facility.Recommended_Rate__c                    = savedata.facility[fCount].Recommended_Rate__c;
                        parentFacility.Recommended_Rate__c              = savedata.facility[fCount].Recommended_Rate__c;
                        appHistory.Recommendation_Rate_of_Intrest__c    = savedata.facility[fCount].Recommended_Rate__c;
                        // Removing deviation on Reccommended rate
                        /*decimal extVal                                  = (savedata.facility[fCount].BRE_Rate__c).setScale(2);
                        decimal recmVal                                 = (savedata.facility[fCount].Recommended_Rate__c).setScale(2);
                        if(savedata.isSaveOrSubmit == YearDataConstant.submitAction && !isExceedingAdhoc && savedata.IsFinalAuthority && (currentRole != Constants.COCC_ROLE) && (recmVal < extVal)){
                            deviationReason +='ROI deviation;';
                            newRoleList.add(calculateROICOMMSNDeviation(savedata, fCount, devRule,ruleMap, fchildRecordTypeID));
                        }*/
                        // And putting deviation on Reccommended Spread

                        System.debug('Parent BRE value ROI'+parentFacility);
                        System.debug('child BRE value ROI'+facility);
                        if(savedata.facility[fCount].Type__c == 'Funded' && savedata.facility[fCount].BRE_Spread__c != null && savedata.facility[fCount].Recommended_Spread__c!=null && applnInfo.RecordType.DeveloperName != Constants.SME_APP_RECORD_TYPE_ADHOC &&  applnInfo.RecordType.DeveloperName != Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                            decimal extVal=0.0;
                            decimal recmVal=0.0;
                            System.debug('child BRE value ROI');
                            if(savedata.facility[fCount].BRE_Spread__c != null)
                                extVal                                  = (savedata.facility[fCount].BRE_Spread__c).setScale(2);
                            if(savedata.facility[fCount].Recommended_Spread__c != null)
                                recmVal                                 = (savedata.facility[fCount].Recommended_Spread__c).setScale(2);
                            if(savedata.isSaveOrSubmit == YearDataConstant.submitAction && !isExceedingAdhoc && savedata.IsFinalAuthority && (currentRole != Constants.COCC_ROLE) && (recmVal < extVal)){
                                deviationReason +='ROI deviation;';
                                newRoleList.add(calculateROICOMMSNDeviation(savedata, fCount, devRule,ruleMap, fchildRecordTypeID));
                            }
                        }
                    }
                    if(isExceedingAdhoc && savedata.facility[fCount].Margin_Receivables__c != null && savedata.facility[fCount].Margin_Receivables__c >= 0){
                        facility.Margin_Receivables__c                              = savedata.facility[fCount].Margin_Receivables__c;
                        parentFacility.Margin_Receivables__c                        = savedata.facility[fCount].Margin_Receivables__c;
                    }
                    if(isExceedingAdhoc && savedata.facility[fCount].Recommended_Processing_Charge__c != null && savedata.facility[fCount].Recommended_Processing_Charge__c >= 0 ){
                        facility.Recommended_Processing_Charge__c       = savedata.facility[fCount].Recommended_Processing_Charge__c;
                        parentFacility.Recommended_Processing_Charge__c = savedata.facility[fCount].Recommended_Processing_Charge__c;
                    }
                    if(isExceedingAdhoc && savedata.facility[fCount].Recommended_Rate__c != null  && savedata.facility[fCount].Recommended_Rate__c >= 0){
                        facility.Recommended_Rate__c       = savedata.facility[fCount].Recommended_Rate__c;
                        parentFacility.Recommended_Rate__c = savedata.facility[fCount].Recommended_Rate__c;
                    }
                    if(isExceedingAdhoc && savedata.facility[fCount].Margin__c != null && savedata.facility[fCount].Margin__c >= 0){
                        facility.Margin__c                              = savedata.facility[fCount].Margin__c;
                        parentFacility.Margin__c                        = savedata.facility[fCount].Margin__c;
                    }
                    if( !isExceedingAdhoc && savedata.facility[fCount].Margin__c != null && savedata.facility[fCount].Margin__c >= 0){

                        facility.Margin__c                              = savedata.facility[fCount].Margin__c;
                        parentFacility.Margin__c                        = savedata.facility[fCount].Margin__c;

                        if(savedata.isSaveOrSubmit == YearDataConstant.submitAction &&savedata.IsFinalAuthority && (currentRole != Constants.COCC_ROLE) && savedata.facility[fCount].BRE_Margin__c >=0){

                            if(savedata.facility[fCount].Product_Category__c == Constants.SOD_CATEGORY
                                    && ((savedata.facility[fCount].BRE_Margin__c).setScale(2) > (savedata.facility[fCount].Margin__c).setScale(2))){

                                devRule                                 = ruleMap.get(Constants.MARGIN_SOD);
                                deviationReason +='Margin deviation;';
                                newRoleList.add(marginDeviation(savedata.facility[fCount].Margin__c, fCount, devRule,fchildRecordTypeID));
                            }
                        }
                    }

                    if( !isExceedingAdhoc && savedata.facility[fCount].Margin_Receivables__c != null && savedata.facility[fCount].Margin_Receivables__c >= 0){

                        facility.Margin_Receivables__c                  = savedata.facility[fCount].Margin_Receivables__c;
                        parentFacility.Margin_Receivables__c            = savedata.facility[fCount].Margin_Receivables__c;

                        if(savedata.isSaveOrSubmit == YearDataConstant.submitAction && savedata.IsFinalAuthority && (currentRole != Constants.COCC_ROLE) && savedata.facility[fCount].BRE_Margin_Receivables__c >= 0){

                            if(savedata.facility[fCount].Product_Category__c == Constants.OCC_CATEGORY
                                    && ((savedata.facility[fCount].BRE_Margin_Receivables__c).setScale(2) > (savedata.facility[fCount].Margin_Receivables__c).setScale(2))){

                                devRule                                 = ruleMap.get(Constants.MARGIN_RECIEVABLES);
                                if(!deviationReason.contains('Margin deviation')) deviationReason +='Margin deviation;';
                                newRoleList.add(marginDeviation(savedata.facility[fCount].Margin_Receivables__c, fCount, devRule,fchildRecordTypeID));
                            }
                        }
                    }

                    if( !isExceedingAdhoc && savedata.facility[fCount].Margin_Stock_Manufacturing__c != null && savedata.facility[fCount].Margin_Stock_Manufacturing__c >=0){

                        facility.Margin_Stock_Manufacturing__c          = savedata.facility[fCount].Margin_Stock_Manufacturing__c;
                        parentFacility.Margin_Stock_Manufacturing__c    = savedata.facility[fCount].Margin_Stock_Manufacturing__c;

                        if(savedata.isSaveOrSubmit == YearDataConstant.submitAction && savedata.IsFinalAuthority && (currentRole != Constants.COCC_ROLE) && savedata.facility[fCount].BRE_Margin_Stock_Manufacturing__c >= 0){

                            if(savedata.facility[fCount].Product_Category__c == Constants.OCC_CATEGORY && savedata.facility[fCount].Industry__c  != null
                                    && savedata.facility[fCount].Industry__c == Constants.MANUFACTURING_INDUSTRY
                                    && ((savedata.facility[fCount].BRE_Margin_Stock_Manufacturing__c).setScale(2) > (savedata.facility[fCount].Margin_Stock_Manufacturing__c).setScale(2))){

                                devRule                                  = ruleMap.get(Constants.MARGIN_STOCK_MANUFACTURING);
                                if(!deviationReason.contains('Margin deviation')) deviationReason +='Margin deviation;';
                                newRoleList.add(marginDeviation(savedata.facility[fCount].Margin_Stock_Manufacturing__c, fCount, devRule,fchildRecordTypeID));
                            }
                        }
                    }

                    if(!isExceedingAdhoc && savedata.facility[fCount].Margin_Stock_Trading__c != null && savedata.facility[fCount].Margin_Stock_Trading__c >= 0){

                        facility.Margin_Stock_Trading__c                = savedata.facility[fCount].Margin_Stock_Trading__c;
                        parentFacility.Margin_Stock_Trading__c          = savedata.facility[fCount].Margin_Stock_Trading__c;

                        if(savedata.isSaveOrSubmit == YearDataConstant.submitAction &&  savedata.IsFinalAuthority && (currentRole != Constants.COCC_ROLE) && savedata.facility[fCount].BRE_Margin_Stock_Trading__c != null && savedata.facility[fCount].BRE_Margin_Stock_Trading__c >=0){
                            if(savedata.facility[fCount].Product_Category__c == Constants.OCC_CATEGORY && savedata.facility[fCount].Industry__c  != null
                                    && savedata.facility[fCount].Industry__c == Constants.TRADING_INDUSTRY
                                    && ((savedata.facility[fCount].BRE_Margin_Stock_Trading__c).setScale(2) > (savedata.facility[fCount].Margin_Stock_Trading__c).setScale(2))){

                                devRule                              = ruleMap.get(Constants.MARGIN_STOCK_TRADING);
                                if(!deviationReason.contains('Margin deviation')) deviationReason +='Margin deviation;';
                                newRoleList.add(marginDeviation(savedata.facility[fCount].Margin_Stock_Trading__c, fCount, devRule,fchildRecordTypeID));
                            }
                        }
                    }
                    Boolean processingFeeFlag = false;
                    if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT) {
                        system.debug('inside enhancement block::');
                        system.debug('savedata.facility[fCount].Facility_Application_Type__c::'+savedata.facility[fCount].Facility_Application_Type__c);
                        
                        // Get Existing Changes Processing Fee from My Wrapper
                        // Compare it with Product processing fee
                       
                        if(savedata.facility[fCount].Facility_Application_Type__c == 'Enhancement'){
                            system.debug('inside enhancement facility::');
                            if(savedata.existingFeeWrap!= null){
                                system.debug('savedata.existingFeeWrap::'+savedata.existingFeeWrap);
                                for(Underwriting_CTRL.existingFeeWrapper feeWrap:savedata.existingFeeWrap){
                                    if(feeWrap.id == savedata.facility[fCount].id){
                                        parentFacility.Renewal_Processing_Charge__c = feeWrap.processingFee;
                                        if(feeWrap.processingFee < feeWrap.productExstingFee){
                                            FinalValueToBePassed = feeWrap.productExstingFee - feeWrap.processingFee;
                                            system.debug('FinalValueToBePassed::'+FinalValueToBePassed);
                                            if(FinalValueToBePassed > existingProcFee){
                                                system.debug('inside greater::'+FinalValueToBePassed+' '+existingProcFee);
                                                existingProcFee = FinalValueToBePassed;
                                                system.debug('existingProcFee::'+existingProcFee);
                                            }
                                            productRenewalFee = feeWrap.productExstingFee;
                                            system.debug('existingProcFee::'+existingProcFee+' '+'productRenewalFee::'+productRenewalFee);
                                        }
                                    }
                                }
                            }
                            //2. Compare Reccomended PF with Existing Fee
                            facility.Recommended_Processing_Charge__c       = savedata.facility[fCount].Recommended_Processing_Charge__c;
                            parentFacility.Recommended_Processing_Charge__c       = savedata.facility[fCount].Recommended_Processing_Charge__c;
                            if(((savedata.facility[fCount].Recommended_Processing_Charge__c).setScale(2) < (savedata.facility[fCount].BRE_Processing_Charge__c).setScale(2))){
                                deviationvalue = (savedata.facility[fCount].BRE_Processing_Charge__c).setScale(2) - (savedata.facility[fCount].Recommended_Processing_Charge__c).setScale(2);
                                system.debug('deviationvalue::'+deviationvalue);
                                system.debug('finalDeviationValue::'+finalDeviationValue);
                                if(deviationvalue > finalDeviationValue){
                                    finalDeviationValue = deviationvalue;
                                }
                                
                            }
                            system.debug('existingProcFee::'+existingProcFee+'finalDeviationValue::'+finalDeviationValue);
                            if(existingProcFee > finalDeviationValue){
                                system.debug('existingProcFee > finalDeviationValue');
                                enhanceDeviationValueToBePassed = (existingProcFee/productRenewalFee) * 100;
                                system.debug('enhanceDeviationValueToBePassed::'+enhanceDeviationValueToBePassed);
                            }
                            else if(existingProcFee < finalDeviationValue){
                                system.debug('existingProcFee < finalDeviationValue::');
                                enhanceDeviationValueToBePassed = (finalDeviationValue/savedata.facility[fCount].BRE_Processing_Charge__c) * 100;
                                system.debug('enhanceDeviationValueToBePassed::'+enhanceDeviationValueToBePassed);
                            }
                        }else if(savedata.facility[fCount].Facility_Application_Type__c == 'Renewal'){
                            system.debug('inside renewal facility::');
                            facility.Recommended_Processing_Charge__c       = savedata.facility[fCount].Recommended_Processing_Charge__c;
                            parentFacility.Recommended_Processing_Charge__c       = savedata.facility[fCount].Recommended_Processing_Charge__c;
                            if(((savedata.facility[fCount].Recommended_Processing_Charge__c).setScale(2) < (savedata.facility[fCount].BRE_Processing_Charge__c).setScale(2))){
                                deviationvalueRenewal = (savedata.facility[fCount].BRE_Processing_Charge__c).setScale(2) - (savedata.facility[fCount].Recommended_Processing_Charge__c).setScale(2);
                                system.debug('(savedata.facility[fCount].BRE_Processing_Charge__c).setScale(2)::'+(savedata.facility[fCount].BRE_Processing_Charge__c).setScale(2));
                                system.debug('(savedata.facility[fCount].Recommended_Processing_Charge__c).setScale(2)'+(savedata.facility[fCount].Recommended_Processing_Charge__c).setScale(2));
                                system.debug('final::'+((savedata.facility[fCount].BRE_Processing_Charge__c).setScale(2) - (savedata.facility[fCount].Recommended_Processing_Charge__c).setScale(2)));
                                if(deviationvalueRenewal > finalDeviationValueRenewal){
                                    finalDeviationValueRenewal = deviationvalueRenewal;
                                }
                                
                            }
                            renewalDeviationValueToBePassed = (finalDeviationValueRenewal/savedata.facility[fCount].BRE_Processing_Charge__c) * 100;
                            system.debug('renewalDeviationValueToBePassed::'+renewalDeviationValueToBePassed);
                        }
                        
                        if(fCount == (savedata.facility.size() - 1) && savedata.isSaveOrSubmit == YearDataConstant.submitAction && savedata.IsFinalAuthority && (currentRole != Constants.COCC_ROLE)){
                            String isSacmaticOrNot = savedata.facility[fCount].Product_Schematic__c;
                            system.debug('enhanceDeviationValueToBePassed::'+enhanceDeviationValueToBePassed);
                            system.debug('renewalDeviationValueToBePassed::'+renewalDeviationValueToBePassed);
                            if(enhanceDeviationValueToBePassed > renewalDeviationValueToBePassed){
                                //method call
                                deviationReason +='Processing fee deviation;';
                                newRoleList.add(calculateProcessingDeviationForEnhancement(isSacmaticOrNot,enhanceDeviationValueToBePassed,devRule,ruleMap));
                            }else if(enhanceDeviationValueToBePassed < renewalDeviationValueToBePassed){
                                //method call
                                deviationReason +='Processing fee deviation;';
                                newRoleList.add(calculateProcessingDeviationForEnhancement(isSacmaticOrNot,renewalDeviationValueToBePassed,devRule,ruleMap));
                            }
                        }
                        
                    }
                    if(!isExceedingAdhoc && savedata.facility[fCount].Recommended_Processing_Charge__c != null && savedata.facility[fCount].BRE_Processing_Charge__c != null
                            && savedata.facility[fCount].Recommended_Processing_Charge__c >= 0 && savedata.facility[fCount].BRE_Processing_Charge__c >= 0 && applnInfo.RecordType.DeveloperName != Constants.SME_APP_RECORD_TYPE_ADHOC &&  applnInfo.RecordType.DeveloperName != Constants.SME_APP_RECORD_TYPE_EXCEEDING && applnInfo.RecordType.DeveloperName != Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){

                        facility.Recommended_Processing_Charge__c       = savedata.facility[fCount].Recommended_Processing_Charge__c;
                        parentFacility.Recommended_Processing_Charge__c = savedata.facility[fCount].Recommended_Processing_Charge__c;

                        if(savedata.isSaveOrSubmit == YearDataConstant.submitAction && savedata.IsFinalAuthority && (currentRole != Constants.COCC_ROLE) ){
                            if(savedata.facility[fCount].BRE_Processing_Charge__c != null && savedata.IsFinalAuthority
                                    && ((savedata.facility[fCount].Recommended_Processing_Charge__c).setScale(2) < (savedata.facility[fCount].BRE_Processing_Charge__c).setScale(2))){
                                deviationReason +='Processing fee deviation;';
                                newRoleList.add(calculateProcessingDeviation(savedata,fCount,devRule,ruleMap,fchildRecordTypeID));
                            }
                        }
                    }

                    appHistory.Facility__c                              = savedata.facility[fCount].CL_Product__c;
                    appHistory.genesis__Application__c                  = savedata.appId;
                    appHistory.User_Role__c                             = savedata.facility[fCount].Role__c;
                    appHistory.User_Name__c                             = loggedInUser.Name;
                    appHistory.Type__c                                  = Constants.RECOMMENDED_CHANGE_TYPE_HISTORY;
                    appHistoryList.add(appHistory);
                    facilities.add(facility);
                    facilities.add(parentFacility);
                }
                system.debug('@@@@'+newRoleList)   ;
                if(facilities.size()>0) update facilities;
                if(savedata.isSaveOrSubmit == YearDataConstant.submitAction ) {
                    try {

                        if ((newRoleList.size() > 0) && (savedata.actionPerformed == Constants.APPROVE_ACTION || savedata.actionPerformed == Constants.RECOMMEND_TO_HIGHER_ACTION || (savedata.actionPerformed == 'BM-Reccomendation' && isExceedingFinalAuth) || (savedata.actionPerformed == 'BM-Reccomendation' && savedata.IsFinalAuthority))) {

                            String finalDeviationAuthority = SanctionUnderwriting_Process.gethighestRole(newRoleList, authLevelList);
                            List<Facility__c> listFacility = [select id,recordTypeId,CL_Product__c from Facility__c where Application__c = :savedata.appId AND RecordType.DeveloperName = :Constants.FACILITY_PARENT_RECORD_TYPE];

                            List<Facility__c> fullFacilityList = new List<Facility__c>();
                            finalRoleOrder++; //next order
                            for (Integer fCount = 0; fCount < listFacility.size(); fCount++) {
                                Facility__c newFac = new Facility__c();
                                newFac.Facility__c = listFacility[fCount].id;
                                newFac.CL_Product__c = listFacility[fCount].CL_Product__c;
                                newFac.Read_Only_User__c = false;
                                newFac.Deviation_Approver__c = true;
                                newFac.RecordTypeId = fchildRecordTypeID;
                                newFac.Role__c = finalDeviationAuthority;
                                newFac.Higher_Authority_Order__c = finalRoleOrder;
                                fullFacilityList.add(newFac);
                            }

                            if (fullFacilityList.size() > 0) insert fullFacilityList;
                        }
                    } catch (Exception e) {
                        system.debug('Exeption In::' + e.getCause() + '--------' + e.getLineNumber());
                    }
                }
            }
            system.debug('Exeption In::'+savedata.applicationInfo.Type__c);
            appupdate.id            = savedata.appId;
            if(savedata.applicationInfo.Type__c != null)
                appupdate.Type__c       = savedata.applicationInfo.Type__c;
            String nextAppStage     = '';
            string deviationStage   = '';
            System.debug('KVB_Company_Details__c'+KVB_Company_Details__c.getOrgDefaults().NTB_Processing_fee_limit__c);
            if( applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                if(savedata.actionPerformed == 'BM-Reccomendation' ){
                    If(appupdate.Type__c !=null && appupdate.Type__c.contains('NTB')){
                        System.debug('Inside Processing  Fee');

                        //return (Processing_Charge * KVB_Company_Details__c.getOrgDefaults().NTB_Processing_fee_limit__c) / 100;
                        appupdate.genesis__Fees_Amount__c =((KVB_Company_Details__c.getOrgDefaults().NTB_Processing_fee_limit__c)* calculateProcessingChargeForNTB(savedata.facility).setScale(2))/100;
                        System.debug('Inside Processing Amount'+ appupdate.genesis__Fees_Amount__c);

                    }
                }
                System.debug('######'+savedata.IsFinalAuthority);
                if(savedata.IsFinalAuthority){
                    System.debug('######'+savedata.IsFinalAuthority);

                    If(appupdate.Type__c !=null && appupdate.Type__c.contains('NTB')){
                        System.debug('######'+appupdate.Type__c);
                        // Already taken from customer -->
                        System.debug('Inside Processing  Fee'+applnInfo.Processing_Charges__c);
                        System.debug('Inside Processing  Fee'+savedata.facility);
                        if(applnInfo.Processing_Charges__c != null)
                            appupdate.genesis__Fees_Amount__c     = calculateProcessingChargeForNTB(savedata.facility).setScale(2) -  applnInfo.Processing_Charges__c;
                    }
                }

            }
            // Changed code because of Coll And Credit officer task
            List<Facility__c> facList = new List<Facility__c>();
            SanctionMatrix_Calculation sanc = new SanctionMatrix_Calculation();
            SanctionMatrix_Calculation.COVERAGE_MAP coveragemap = new SanctionMatrix_Calculation.COVERAGE_MAP();
            if(!isExceedingAdhoc){

                facList = [Select id,Product_Category__c,Application__r.Parent_Application__c,Application__r.New_to_Business__c,Application__r.Is_Take_Over__c,Application__r.Type__c,Name,Application__c,Application__r.RecordType.DeveloperName,Application__r.ownerId,Application__r.Application_Stage__c,Limit_Amount__c,Existing_Limit__c,Type__c,Application__r.genesis__Account__c,CL_Product__c,Existing_Rate__c,Existing_Processing_Charge__c,Approved_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Recommended_Limit__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c, (select id,genesis__Collateral__c from Facility_Security__r) from Facility__c where Application__c = :savedata.appId];
                coveragemap = sanc.calculateAuthority(facList, false, SanctionMatrix_Calculation.ONLY_COVERAGE_METHOD, null);

            }
            system.debug('savedata==========> '+savedata);
            if((savedata.isSaveOrSubmit == YearDataConstant.submitAction && savedata.actionPerformed != 'BM-Reccomendation' || (savedata.actionPerformed == 'BM-Reccomendation' && (savedata.IsFinalAuthority || isExceedingFinalAuth)))) {
                /*System.debug('@@@@@'+'Inside BM Recommendation');
                System.debug('@@@@@'+'Inside BM Recommendation'+savedata.actionPerformed);
                System.debug('@@@@@'+'Inside BM Recommendation'+savedata.IsFinalAuthority);
                System.debug('@@@@@'+'Inside BM Recommendation'+isExceedingFinalAuth);*/
                if ( savedata.IsFinalAuthority && !isExceedingAdhoc) {
                    if (savedata.isSaveOrSubmit == YearDataConstant.submitAction && coveragemap.message == SanctionMatrix_Calculation.SUFFICIENT_COVERAGE && !applnInfo.Legal_clearance__c ){
                        System.debug('$$$$$$$$$$');
                        if(!checkIFOpenTaskAlreadyExist(savedata.appId,'Collateral Evaluation'))
                            checkIfLegalTaskHasToBeCreatedForBM(savedata.appId, true);
                    }

                }
                if (savedata.actionPerformed == Constants.APPROVE_ACTION || ((savedata.actionPerformed == 'BM-Reccomendation'|| savedata.actionPerformed=='Recommend to higher authority') && (savedata.IsFinalAuthority || isExceedingFinalAuth))) {
                    System.debug('@@@@@'+'Inside BM Approve action');
                    string stage = '';
                    if (applnInfo.Application_Stage__c == Constants.APPLICATION_REVIEW_STAGE
                            || applnInfo.Application_Stage__c == Constants.APP_DEVIATION_PENDING_STAGE) {
                        stage = Constants.INTERIM_SANCTION_STAGE;
                        if (newRoleList.size() > 0) deviationStage = Constants.APP_DEVIATION_PENDING_STAGE;
                    }
                    if (applnInfo.Application_Stage__c == Constants.APP_REVIEW_FINANCIAL_STAGE
                            || applnInfo.Application_Stage__c == Constants.APP_DEVIATION_FINANCIAL_STAGE) {
                        stage = Constants.FINAL_SANCTION_STAGE;
                        if (newRoleList.size() > 0) deviationStage = Constants.APP_DEVIATION_FINANCIAL_STAGE;
                    }
                    if (applnInfo.Application_Stage__c == Constants.APP_REVIEW_FINAL_STAGE
                            || applnInfo.Application_Stage__c == Constants.APP_FINAL_DEVIATION) {
                        stage = Constants.APP_FILLING_FINAL_STAGE;
                        if (newRoleList.size() > 0) deviationStage = Constants.APP_FINAL_DEVIATION;
                    }
                    System.debug('@@@@@@ contains commitee roles'+loggedInUser.Designation__c);
                    if (!SanctionUnderwriting_Process.COMMITEE_ROLES.contains(loggedInUser.Designation__c)) {
                        if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE ){
                            wrp.message = Constants.SME_RENEWAL_APPROVED;
                            appupdate.Application_Stage__c = stage;
                        }else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){

                            if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT)
                                if(substageVerify(savedata.appId))
                                    stage = 'Enhancement- Final sanction offered';
                                else
                                        stage = 'Enhancement- Final sanction';
                            else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC)
                                if(substageVerify(savedata.appId))
                                    stage = 'Adhoc- Final sanction offered';
                                else
                                        stage = 'Adhoc-Final sanction';
                            else if(applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)
                                if(substageVerify(savedata.appId))
                                    stage = Constants.NEW_LOAN_FINAL_SANCTION_OFFERED;
                                else
                                        stage = Constants.NEW_LOAN_FINAL_SANCTION ;
                            else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                                System.debug('Exceeding-Final sanction');
                                stage = 'Exceeding-Final sanction';
                                if(isExceedingFinalAuth){

                                    nextAppStage = stage;
                                    System.debug('@ Next App Stage'+nextAppStage);
                                    wrp.message = 'Application Stage changed to Exceeding-Final Sanction';
                                    appupdate.Application_Stage__c =Constants.SME_APP_STAGE_EXE_FINAL_SANC ;
                                    appupdate.Sanction_Authority__c = loggedInUser.Designation__c;
                                    finalAuthComment = SanctionMatrixController_EA.saveAuthorityreccomendations(savedata.appId,savedata.isMoreThanTenDays,true);
                                    wrp.finalAuthMessage = finalAuthComment;
                                    wrp.message='';
                                }
                            }



                            if (newRoleList.size() > 0) deviationStage = Constants.APP_DEVIATION_PENDING_STAGE;
                            if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT)
                                wrp.message = 'Recommendation And Pre-Disbersement conditions has been saved.';
                            if(applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)
                                wrp.message = 'Recommendation has been saved successfully.';
                        }
                    } else {
                        wrp.message = SanctionUnderwriting_Process.COMMITTEE_REVIEW_MSG;
                    }
                    if(isExceedingAdhoc && savedata.actionPerformed == Constants.APPROVE_ACTION && savedata.IsFinalAuthority){
                        if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                            wrp.message = 'Application Stage changed to Exceeding-Final Sanction';
                            appupdate.Application_Stage__c =Constants.SME_APP_STAGE_EXE_FINAL_SANC ;
                        }

                        appupdate.Sanction_Authority__c = loggedInUser.Designation__c;
                    }
                    wrp.stage = Constants.SUCCESS_STATUS;
                    nextAppStage = stage;
                }
                System.debug('@ Next App Stage'+nextAppStage);
                if (savedata.actionPerformed == Constants.MARK_EXIT_ACTION) {
                    appupdate.Application_Stage__c = Constants.EXIT_STAGE;
                    appupdate.Sub_Stage__c = '';
                    if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE)
                        wrp.message = Constants.SME_RENEWAL_REJECTED;
                    else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                        wrp.message = 'Enhancement Application has been rejected.';
                    }else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                        wrp.message = 'AdHoc Application has been rejected.';
                    }else if(applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                        wrp.message = 'SME New Laon Application has been rejected.';
                    }

                    wrp.stage = Constants.SUCCESS_STATUS;
                }
                if (savedata.actionPerformed == Constants.RECOMMEND_TO_HIGHER_ACTION && (isExceedingAdhoc || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE) ) {
                    if(isExceedingAdhoc){
                        System.debug('@@@@ Calling Exceeding Sanction Matrix');
                        finalAuthComment = SanctionMatrixController_EA.saveAuthorityreccomendations(savedata.appId,savedata.isMoreThanTenDays,true);
                        wrp.finalAuthMessage = finalAuthComment;
                        wrp.message='';
                    }

                    wrp.message = Constants.AUTHORITY_REVIEW_SENT;
                    wrp.stage = Constants.SUCCESS_STATUS;
                }
            }else if(savedata.actionPerformed == 'BM-Reccomendation' && savedata.isSaveOrSubmit == YearDataConstant.submitAction){
                // Calculate Estimated Security
                if(!isExceedingAdhoc) {
                    /*List<Facility__c> facList = [Select id,Application__r.Parent_Application__c,Application__r.New_to_Business__c,Application__r.Is_Take_Over__c,Application__r.Type__c,Name,Application__c,Application__r.RecordType.DeveloperName,Application__r.ownerId,Application__r.Application_Stage__c,Limit_Amount__c,Existing_Limit__c,Type__c,Application__r.genesis__Account__c,CL_Product__c,Existing_Rate__c,Existing_Processing_Charge__c,Approved_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Recommended_Limit__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c, (select id,genesis__Collateral__c from Facility_Security__r) from Facility__c where Application__c = :savedata.appId];
                    //List<Facility__c> facList                               = Database.query(query);
                    SanctionMatrix_Calculation sanc = new SanctionMatrix_Calculation();

                    SanctionMatrix_Calculation.COVERAGE_MAP coveragemap = new SanctionMatrix_Calculation.COVERAGE_MAP();
                    coveragemap = sanc.calculateAuthority(facList, false, SanctionMatrix_Calculation.ONLY_COVERAGE_METHOD, null);
*/
                    if (coveragemap.finalCoverage != null)
                        appupdate.Security_coverage__c = coveragemap.finalCoverage;

                    if (SOQL_Util.isBMFinalAuth(savedata.appId) && savedata.IsFinalAuthority ) {
                        if (savedata.isSaveOrSubmit == YearDataConstant.submitAction && coveragemap.message == SanctionMatrix_Calculation.SUFFICIENT_COVERAGE && !applnInfo.Legal_clearance__c ){
                            System.debug('$$$$$$$$$$');
                            if(!checkIFOpenTaskAlreadyExist(savedata.appId,'Collateral Evaluation'))
                                checkIfLegalTaskHasToBeCreatedForBM(savedata.appId, true);
                        }

                    }else if(!SOQL_Util.isBMFinalAuth(savedata.appId)  && !savedata.IsFinalAuthority){
                        if(!checkIFOpenTaskAlreadyExist(savedata.appId,'Collateral Evaluation'))
                            checkIfLegalTaskHasToBeCreatedForBM(savedata.appId, true);
                    }
                    //
                    // Change stage if recommended is greater than estimated
                    if (coveragemap.message == SanctionMatrix_Calculation.INSUFFICIENT_COVERAGE) {
                        appupdate.Is_Financial_security_Coverage_Less__c = true;
                        appupdate.Sub_Stage__c = 'Insufficient collateral coverage';
                        appupdate.Application_UI_Stage__c = SOQL_Util.getApplicationUISatge(savedata.appId);
                        wrp.message = 'Application Sub-Stage has been changed to Insufficient Collateral Coverage';
                    }
                    if (coveragemap.message == SanctionMatrix_Calculation.SUFFICIENT_COVERAGE) {
                        appupdate.Is_Financial_security_Coverage_Less__c = false;
                        wrp.message = 'BM recommendation has been saved successfully.';
                    }
                }
                if(isExceedingAdhoc){
                    finalAuthComment = SanctionMatrixController_EA.saveAuthorityreccomendations(savedata.appId,savedata.isMoreThanTenDays,true);
                    system.debug('finalAuthComment===> '+finalAuthComment);
                    wrp.finalAuthMessage = finalAuthComment;
                    wrp.message='';
                }
            }

            if(isExceedingAdhoc && finalAuthComment=='BM' && savedata.isSaveOrSubmit == YearDataConstant.submitAction){
                if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                    appupdate.Application_Stage__c =Constants.SME_APP_STAGE_EXE_FINAL_SANC ;
                }
                appupdate.Sanction_Authority__c = loggedInUser.Designation__c;
            }
            if(savedata.isSaveOrSubmit == YearDataConstant.submitAction){
                if(appHistoryList.size() > 0) insert appHistoryList;
            }

            if(saveData.bmCommentsList != null && saveData.bmCommentsList.size() > 0){
                update saveData.bmCommentsList;
            }

            if(saveData.termsAndConditions != null && saveData.termsAndConditions.size() > 0 && savedata.isSaveOrSubmit == YearDataConstant.submitAction){
                insert saveData.termsAndConditions;
            }
            if( saveData.preDisbersementtermsAndConditions != null && saveData.preDisbersementtermsAndConditions.size() > 0 ){
                insert saveData.preDisbersementtermsAndConditions;
                if(! SOQL_Util.isBMFinalAuth(savedata.appId))
                    SOQL_Util.createTaskForBM(savedata.appId,'Submit compliance for Pre-disbursement','Pre-disbursement Approval');
            }
            boolean deviatiated = false;

            if(savedata.isSaveOrSubmit == YearDataConstant.submitAction && newRoleList.size() > 0){
                deviatiated = true;
                appupdate.Application_Stage__c  = deviationStage;
                wrp.message                     = Constants.DEVIATION_MESSAGE;
                wrp.stage                       = Constants.DEVIATION_STATUS;
            }

            string currentStatus                            = '';
            System.debug('Application APP_CURRENT_SATGE');
            System.debug(nextAppStage);
            System.debug('Application APP_PREV_SATGE');
            System.debug(applnInfo.Application_Stage__c);
            SanctionUnderwriting_Process.APP_CURRENT_SATGE  = nextAppStage;
            SanctionUnderwriting_Process.APP_PREV_SATGE     = applnInfo.Application_Stage__c;
            if(savedata.isSaveOrSubmit == YearDataConstant.submitAction) {
                List<Task> authTask = new List<Task>();
                authTask = SanctionUnderwriting_Process.getUserTaskList(savedata.appId, loggedInUser.Id);

                if (authTask.size() > 0) {
                    for (Task t : authTask) {
                        t.Status = Constants.COMPLETED_STATUS;
                    }
                    TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
                    update authTask;
                }
            }

            if(savedata.IsFinalAuthority && (applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)  && !deviatiated && SanctionUnderwriting_Process.isEveryPreDisbersementBMComplied(savedata.appId)){
                System.debug('@@@@@@'+'Inside Legal Pending');
                updateFinalSecurityCoverage(savedata.appId,'FINAL_AUTHORITY');
                if(applicationSubStage != '')
                    appupdate.Sub_Stage__c =applicationSubStage;
                if(applicationStage != '')
                    appupdate.Application_Stage__c =applicationStage;
                if(applicationUiStage != '')
                    appupdate.Application_UI_Stage__c =applicationUiStage;
                appupdate.Is_Financial_security_Coverage_Less__c = isFinalCoverageLess;
            }
            if( savedata.IsFinalAuthority && !deviatiated){
                if(savedata.isSaveOrSubmit == YearDataConstant.submitAction) {
                    System.debug('Creating task for next authority');
                    // Task for committe Member
                    if (SanctionUnderwriting_Process.COMMITEE_ROLES.contains(loggedInUser.Designation__c)) {
                        SanctionUnderwriting_Process.getCommitteMemebers(loggedInUser.Division, savedata.appId, loggedInUser.Designation__c);
                        currentStatus = loggedInUser.Designation__c + ' Committee Review';
                    }
                }
            }else{
                if(savedata.isSaveOrSubmit == YearDataConstant.submitAction) {
                    if (!deviatiated && (applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)) {
                        System.debug('Creating task for next authority ');
                        SanctionMatrix_Helper.reRunSactionAuth(savedata.appId);
                    }
                    string role = SanctionUnderwriting_Process.createTaskForNextAuthority(savedata.appId, deviatiated);
                    if (role != null && role != '') {
                        if (savedata.IsFinalAuthority && deviatiated) {
                            currentStatus = role + ' ' + 'deviation pending';
                        } else {
                            currentStatus = role + ' ' + 'review';
                        }
                    }
                }

            }
            System.debug('@@@'+wrp.message)   ;
            appupdate.genesis__Status__c            = currentStatus;
            if(savedata.isSaveOrSubmit == YearDataConstant.submitAction)
                appupdate.Deviation_Reason__c           = deviationReason;
            update appupdate;
            //setOfString.add(appupdate.id);

        }catch(Exception e){

            wrp.message = 'Error while saving your inputs.';
            wrp.stage   = Constants.ERROR_STATUS;
            database.rollback(sp);
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'saveData', e);
        }
        return wrp;
    }

    /**
* Helper Method to create task for Previous Authority
*
* @param applId
*
* @return
*/

    public static string createTaskForPreviousAuthority(Underwriting_CTRL.saveWrapper savedata) {
        try {
            if(savedata.termsAndConditions != null && savedata.termsAndConditions.size() > 0){
                insert savedata.termsAndConditions;
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createTaskForPreviousAuthority', e);
        }

        return createrefferBackTask(savedata);

    }

    public static String createrefferBackTask(Underwriting_CTRL.saveWrapper savedata){
        try {

            if(savedata.actionPerformed == 'REFFER_BACK'){
                system.debug('inside if condition');

                User loggedUser = SanctionUnderwriting_Process.currentUserInfo();
                if(savedata.appId != null)SanctionUnderwriting_Process.closeTaskForLoggedInUser(loggedUser, savedata.appId);

                SOQL_Util.createTaskForBM(savedata.appId,'Application Review Pending - Reffer Back','EME BM Review');
                //return 'Task has been cretaed for BM';

                return 'Task has been created for BM';
            }else{
                return 'Some Error occurred';
            }

        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createrefferBackTask', e);
            return 'Some Error occurred';
        }
    }


    /**
* // This method is used to store Credit Officer review comment and assign task to next higher authority
*
* @param appId
* @param comment
*
* @return
*/
    public static Underwriting_CTRL.ReturnWrap saveOtherAuthorityInput(string appId, String comment){
        Savepoint sp                                                                                = database.setSavepoint();
        Underwriting_CTRL.ReturnWrap resp                                                           = new Underwriting_CTRL.ReturnWrap();
        try{
            String auditRTypeID                                                                     = Underwriting_CTRL_Helper.auditRTypeID;
            User loggedInUser                                                                       = SanctionUnderwriting_Process.currentUserInfo();
            List<Task> authTask                                                                     = new List<Task>();
            authTask                                                                                = SanctionUnderwriting_Process.getUserTaskList(appId,loggedInUser.Id);

            if(authTask.size() > 0){
                for(Task t : authTask){
                    t.Status    = Constants.COMPLETED_STATUS;
                }
                TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
                update authTask;
                if(comment != null && comment != '' && loggedInUser.id != null){

                    Audit__c acomment                                                               = new Audit__c();
                    acomment.Sanction_Authority_Comment__c                                          = comment;
                    acomment.Application__c                                                         = appId;
                    acomment.RecordtypeId                                                           = auditRTypeID;
                    acomment.User__c                                                                = loggedInUser.Id;
                    acomment.Role_Name__c															= loggedInUser.Designation__c;
                    insert acomment;

                    String currentStatus                                                            = '';
                    User finalUser                                                                  = getFinalAuthorityUser(appId,loggedInUser);
                    if(finalUser.Designation__c != null){
                        currentStatus                                                               = finalUser.Designation__c+' Review';
                        String taskType                                                             = '';
                        string taskSubj                                                             = '';
                        if(SanctionUnderwriting_Process.COMMITEE_ROLES.contains(finalUser.Designation__c)){
                            taskType                                                                = SanctionUnderwriting_Process.SANCTION_APPROVAL;
                            taskSubj                                                                = SanctionUnderwriting_Process.COMMITTE_TASK_SUBJECT;
                        }else{
                            taskType                                                                = SanctionUnderwriting_Process.APPILICATION_REVIEW;
                            taskSubj                                                                = SanctionUnderwriting_Process.SANC_OFFICER_TASK_SUBJ;
                        }
                        if(SanctionUnderwriting_Process.checkIfNextAuthIsRMD(appId)){
                            currentStatus                                                           = 'RMD Review';
                            SanctionUnderwriting_Process.createTaskForNextAuthority(appId, false);
                        }else{

                            Task newTask                                                 = SanctionUnderwriting_Process.getTaskObj(appId, finalUser.Id, taskSubj, taskType);
                            SanctionUnderwriting_Process.createTaskforOtherAuthority(newTask);
                        }


                    }

                    genesis__Applications__c apptoUpdate                                            = new genesis__Applications__c();
                    apptoUpdate.Id                                                                  = appId;
                    apptoUpdate.genesis__Status__c                                                  = currentStatus;
                    ApplicationTriggerHandler.IsFirstRun                                            = false;
                    update apptoUpdate;
                }
            }

            resp.message                                                                            = Constants.RECORD_SAVED_MSG;
            resp.stage                                                                              = Constants.SUCCESS_STATUS;
        }catch(Exception e){
            database.rollback(sp);
            resp.message                                                                            = Constants.ERROR_MESSAGE;
            resp.stage                                                                              = Constants.ERROR_STATUS;
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'saveOtherAuthorityInput', e);
            system.debug('Exception::'+e.getMessage());
        }
        return resp;
    }

    public static String otherAuthorityReferBackhelper(string appId, String comment){
        try {

            String auditRTypeID                                                                     = Underwriting_CTRL_Helper.auditRTypeID;
            User loggedInUser                                                                       = SanctionUnderwriting_Process.currentUserInfo();
            Audit__c acomment                                                               = new Audit__c();
            acomment.Sanction_Authority_Comment__c                                          = comment;
            acomment.Application__c                                                         = appId;
            acomment.RecordtypeId                                                           = auditRTypeID;
            acomment.User__c                                                                = loggedInUser.Id;
            acomment.Role_Name__c															= loggedInUser.Designation__c;
            insert acomment;
            return SanctionUnderwriting_Process.createTaskForPreviousAuthority(appId);
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'otherAuthorityReferBackhelper', e);
            system.debug('Exception::'+e.getMessage());
            return 'Some Error Occurred';
        }
    }


    /**
* // This method used to approve/reject deviation or committee member approval/rejection and assign task to
*
* @param appId
* @param action
* @param userStatus
* @param auditComment
*
* @return
*/
    public static Underwriting_CTRL.ReturnWrap saveSanctionAuthorityInput(string appId, String action, SanctionUnderwriting_Process.userInfoWrapper userStatus, Audit__c auditComment){

        Savepoint sp                                                                                = database.setSavepoint();
        Underwriting_CTRL.ReturnWrap resp                                                           = new Underwriting_CTRL.ReturnWrap();
        genesis__Applications__c appupdate                                                          = new genesis__Applications__c();
        //genesis__Applications__c appRec = [Select Id,Name ,Legal_clearance__c from genesis__Applications__c where Id=:appId];
        appupdate.Id                                                                                = appId;
        try{

            User loggedInUser                                                                       = SanctionUnderwriting_Process.currentUserInfo();
            List<Task> authTask                                                                     = new List<Task>();
            authTask                                                                                = SanctionUnderwriting_Process.getUserTaskList(appId,loggedInUser.Id);
            String applnPrevStage                                                                   = '';
            String applStage                                                                        = '';
            if(auditComment != null && auditComment.Application__c != null
                    && (auditComment.Sanction_Authority_Comment__c != null && auditComment.Sanction_Authority_Comment__c != '')){
                insert auditComment;
            }

            if(authTask.size() > 0){

                for(Task t : authTask){
                    t.Status                                                                        = Constants.COMPLETED_STATUS;
                    if(action == Constants.APPROVE_ACTION)
                        t.Approval_Status__c                                                        = Constants.APPROVED_STATUS;
                    else
                            t.Approval_Status__c                                                        = Constants.REJECTED_STATUS;

                    applnPrevStage                                                                  = t.Application_Stage__c;
                    applStage                                                                       = t.Application_Previous_Stage__c;
                }
                TaskFlow_Helper.TASK_TRIGGER_RUNNING                                                = true;
                update authTask;

                genesis__Applications__c applnInfo                                                  = getapplnInformation(appId);
                if(userStatus.isDeviationApprover){

                    if(action == Constants.APPROVE_ACTION){
                        if(loggedInUser.Designation__c == 'DOCC' || loggedInUser.Designation__c == 'COCC'){
                            //Create tasks for committe members
                            SanctionUnderwriting_Process.APP_PREV_SATGE                                 = applnInfo.Application_Stage__c;
                            if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                                if(!checkIfLandAndBuildingOrOtherCollateralExistNotFECreated(appId))
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Enhancement- Final sanction';
                                else
                                        SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Enhancement- Final sanction offered';
                            }else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                                if(!checkIfLandAndBuildingOrOtherCollateralExistNotFECreated(appId))
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Adhoc-Final sanction';
                                else
                                        SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Adhoc- Final sanction offered';
                            }else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                                SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Exceeding-Final sanction';
                            }else if(applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                if(!checkIfLandAndBuildingOrOtherCollateralExistNotFECreated(appId))
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'New loan - Final sanction';
                                else
                                        SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'New Loan - Final sanction offered';
                            }else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE){
                                if(applnInfo.Overall_Exposure__c <= Constants.SME_FIFTY_LAKH){
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = Constants.APP_FILLING_FINAL_STAGE;
                                }else if(applnInfo.Overall_Exposure__c > Constants.SME_FIFTY_LAKH){
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = Constants.INTERIM_SANCTION_STAGE;
                                }

                            }
                            appupdate.Sub_Stage__c                                                      = '';
                            if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                System.debug('###################');
                                if(checkIfLandAndBuildingOrOtherCollateralExist(appId) && !applnInfo.Legal_clearance__c){
                                    System.debug('###################');
                                    appupdate.Sub_Stage__c = 'Legal Clearance Pending';
                                }


                            }
                            SanctionUnderwriting_Process.getCommitteMemebers(loggedInUser.Division,appId,loggedInUser.Designation__c);
                            //appupdate.Application_Stage__c                                              = applnPrevStage;

                            appupdate.genesis__Status__c                                                = '';
                            appupdate.Deviation_Reason__c                                               = '';
                            resp.message                                                                = 'Processed further for committe members';
                            appupdate.genesis__Status__c                                                =  loggedInUser.Designation__c+' Committee Review';
                        }
                        else{
                            /*if(checkIfLandAndBuildingOrOtherCollateralExist(appId) && applnInfo.RecordType.DeveloperName != 'SME_Renewal'){
                                //Underwriting_CTRL_Helper.createMODTaskForBm(appId,'MOD Needed','MOD Needed');
                            }*/
                            appupdate.Application_Stage__c                                              = applnPrevStage;
                            appupdate.Sub_Stage__c                                                      = '';
                            appupdate.genesis__Status__c                                                = '';
                            appupdate.Deviation_Reason__c                                               = '';
                            resp.message                                                                = '';

                            if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                System.debug('###################');
                                if(checkIfLandAndBuildingOrOtherCollateralExist(appId) && !applnInfo.Legal_clearance__c){
                                    System.debug('###################');
                                    appupdate.Sub_Stage__c = 'Legal Clearance Pending';
                                }


                            }


                        }
                    }else{
                        resp.message                                                                = Constants.REJECTALERT_MESSAGE;
                        appupdate.Application_Stage__c                                              = applStage;
                        appupdate.genesis__Status__c                                                = 'Deviation Rejected';
                        User finalUser                                                              = getFinalAuthorityUser(appId,loggedInUser);
                        string taskType                                                             = SanctionUnderwriting_Process.APPILICATION_REVIEW;
                        string taskSubj                                                             = 'Application Review  - '+loggedInUser.Designation__c+' deviation Rejected';
                        Task newTask                                                                = SanctionUnderwriting_Process.getTaskObj(appId, finalUser.Id, taskSubj, taskType);
                        SanctionUnderwriting_Process.createTaskforOtherAuthority(newTask);
                    }

                }else{
                    User finalUser                                                                  = getFinalAuthorityUser(appId,loggedInUser);
                    //if(finalUser.Designation__c == 'DOCC' || finalUser.Designation__c == 'COCC'){
                    boolean committeTaskDone                                                    = false;
                    if(applnInfo.Committe__c != null){
                        committeTaskDone                                                        = SanctionUnderwriting_Process.checkMemberApproved(appId, applnInfo.Committe__c);
                    }
                    if(committeTaskDone){
                        genesis__Applications__c apptoUpdate                                    = new genesis__Applications__c();
                        apptoUpdate.Id                                                          = appId;
                        apptoUpdate.Application_Stage__c                                        = applnPrevStage;
                        apptoUpdate.genesis__Status__c                                          = '';
                        ApplicationTriggerHandler.IsFirstRun                                    = false;
                        update apptoUpdate;
                        setOfString.add(apptoUpdate.id);
                    }
                    //}
                    if(action == Constants.APPROVE_ACTION){
                        resp.message                                                                = Constants.SANCTION_SUCC_MESSAGE;
                    }else{
                        resp.message                                                                = Constants.SANCTION_REJ_MESSAGE;
                    }
                }

                resp.stage                                                                          = Constants.SUCCESS_STATUS;
            }
            if(appupdate != null && appupdate.Id != null){
                ApplicationTriggerHandler.IsFirstRun                                                = false;
                update appupdate;
            }
        }catch(Exception e){
            database.rollback(sp);
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'saveSanctionAuthorityInput', e);
            resp.message                                                                            = Constants.ERROR_MESSAGE;
            resp.stage                                                                              = Constants.ERROR_STATUS;
        }
        return resp;
    }
    public static Underwriting_CTRL.ReturnWrap sanctionApprovalSubmitRefactor(string appId, String action, SanctionUnderwriting_Process.userInfoWrapper userStatus, Audit__c auditComment,Underwriting_CTRL.saveWrapper savedata){

        Savepoint sp                                                                                = database.setSavepoint();
        Underwriting_CTRL.ReturnWrap resp                                                           = new Underwriting_CTRL.ReturnWrap();
        genesis__Applications__c appupdate                                                          = new genesis__Applications__c();
        //genesis__Applications__c appRec = [Select Id,Name ,Legal_clearance__c from genesis__Applications__c where Id=:appId];
        appupdate.Id                                                                                = appId;
        try{

            User loggedInUser                                                                       = SanctionUnderwriting_Process.currentUserInfo();
            List<Task> authTask                                                                     = new List<Task>();
            authTask                                                                                = SanctionUnderwriting_Process.getUserTaskList(appId,loggedInUser.Id);
            String applnPrevStage                                                                   = '';
            String applStage                                                                        = '';
            if(auditComment != null && auditComment.Application__c != null
                    && (auditComment.Sanction_Authority_Comment__c != null && auditComment.Sanction_Authority_Comment__c != '')){
                insert auditComment;
            }
            if(savedata.facility != null){
                updateReccomendationValueForDeviationAurhority(savedata);
            }

            if(authTask.size() > 0){

                for(Task t : authTask){
                    t.Status                                                                        = Constants.COMPLETED_STATUS;
                    if(action == Constants.APPROVE_ACTION)
                        t.Approval_Status__c                                                        = Constants.APPROVED_STATUS;
                    else
                            t.Approval_Status__c                                                        = Constants.REJECTED_STATUS;

                    applnPrevStage                                                                  = t.Application_Stage__c;
                    applStage                                                                       = t.Application_Previous_Stage__c;
                }
                TaskFlow_Helper.TASK_TRIGGER_RUNNING                                                = true;
                update authTask;

                genesis__Applications__c applnInfo                                                  = getapplnInformation(appId);
                if(userStatus.isDeviationApprover){

                    if(action == Constants.APPROVE_ACTION){
                        if(loggedInUser.Designation__c == 'DOCC' || loggedInUser.Designation__c == 'COCC'){
                            //Create tasks for committe members
                            SanctionUnderwriting_Process.APP_PREV_SATGE                                 = applnInfo.Application_Stage__c;
                            if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                                if(!checkIfLandAndBuildingOrOtherCollateralExist(appId))
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Enhancement- Final sanction';
                                else
                                        SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Enhancement- Final sanction offered';
                            }else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                                if(!checkIfLandAndBuildingOrOtherCollateralExist(appId))
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Adhoc-Final sanction';
                                else
                                        SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Adhoc- Final sanction offered';
                            }else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                                SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'Exceeding-Final sanction';
                            }else if(applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                if(!checkIfLandAndBuildingOrOtherCollateralExist(appId))
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'New loan - Final sanction';
                                else
                                        SanctionUnderwriting_Process.APP_CURRENT_SATGE = 'New Loan - Final sanction offered';
                            }else if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE){
                                if(applnInfo.Overall_Exposure__c <= Constants.SME_FIFTY_LAKH){
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = Constants.APP_FILLING_FINAL_STAGE;
                                }else if(applnInfo.Overall_Exposure__c > Constants.SME_FIFTY_LAKH){
                                    SanctionUnderwriting_Process.APP_CURRENT_SATGE = Constants.INTERIM_SANCTION_STAGE;
                                }

                            }
                            appupdate.Sub_Stage__c                                                      = '';
                            if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                System.debug('###################');
                                if(checkIfLandAndBuildingOrOtherCollateralExist(appId) && !applnInfo.Legal_clearance__c){
                                    System.debug('###################');
                                    appupdate.Sub_Stage__c = 'Legal Clearance Pending';
                                }


                            }
                            SanctionUnderwriting_Process.getCommitteMemebers(loggedInUser.Division,appId,loggedInUser.Designation__c);
                            //appupdate.Application_Stage__c                                              = applnPrevStage;

                            appupdate.genesis__Status__c                                                = '';
                            appupdate.Deviation_Reason__c                                               = '';
                            resp.message                                                                = 'Processed further for committe members';
                            appupdate.genesis__Status__c                                                =  loggedInUser.Designation__c+' Committee Review';
                        }
                        else{
                            /*if(checkIfLandAndBuildingOrOtherCollateralExist(appId) && applnInfo.RecordType.DeveloperName != 'SME_Renewal'){
                                //Underwriting_CTRL_Helper.createMODTaskForBm(appId,'MOD Needed','MOD Needed');
                            }*/
                            appupdate.Application_Stage__c                                              = applnPrevStage;
                            appupdate.Sub_Stage__c                                                      = '';
                            appupdate.genesis__Status__c                                                = '';
                            appupdate.Deviation_Reason__c                                               = '';
                            resp.message                                                                = '';

                            if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                System.debug('###################');
                                if(checkIfLandAndBuildingOrOtherCollateralExist(appId) && !applnInfo.Legal_clearance__c){
                                    System.debug('###################');
                                    appupdate.Sub_Stage__c = 'Legal Clearance Pending';
                                }


                            }


                        }
                    }else{
                        resp.message                                                                = Constants.REJECTALERT_MESSAGE;
                        //appupdate.Application_Stage__c                                              = applStage;
                        appupdate.Application_Stage__c                                              = 'Application Rejected';
                        appupdate.genesis__Status__c                                                = 'Deviation Rejected';
                        User finalUser                                                              = getFinalAuthorityUser(appId,loggedInUser);
                        string taskType                                                             = SanctionUnderwriting_Process.APPILICATION_REVIEW;
                        string taskSubj                                                             = 'Application Review  - '+loggedInUser.Designation__c+' deviation Rejected';
                        Task newTask                                                                = SanctionUnderwriting_Process.getTaskObj(appId, finalUser.Id, taskSubj, taskType);
                        SanctionUnderwriting_Process.createTaskforOtherAuthority(newTask);
                    }

                }else{
                    User finalUser                                                                  = getFinalAuthorityUser(appId,loggedInUser);
                    //if(finalUser.Designation__c == 'DOCC' || finalUser.Designation__c == 'COCC'){
                    System.debug('#########'+applnInfo.Committe__c);
                    System.debug('#########'+appId);
                    boolean committeTaskDone                                                    = false;
                    if(applnInfo.Committe__c != null){
                        committeTaskDone                                                        = SanctionUnderwriting_Process.checkMemberApproved(appId, applnInfo.Committe__c);
                        System.debug('#########'+committeTaskDone);

                    }
                    if(committeTaskDone){
                        System.debug('#########'+committeTaskDone);
                        system.debug('applnPrevStage::'+applnPrevStage);
                        genesis__Applications__c apptoUpdate                                    = new genesis__Applications__c();
                        apptoUpdate.Id                                                          = appId;
                        apptoUpdate.Application_Stage__c                                        = applnPrevStage;
                        apptoUpdate.genesis__Status__c                                          = '';
                        ApplicationTriggerHandler.IsFirstRun                                    = false;
                        update apptoUpdate;
                        setOfString.add(apptoUpdate.id);
                    }
                    //}
                    if(action == Constants.APPROVE_ACTION){
                        resp.message                                                                = Constants.SANCTION_SUCC_MESSAGE;
                    }else{
                        resp.message                                                                = Constants.SANCTION_REJ_MESSAGE;
                    }
                }

                resp.stage                                                                          = Constants.SUCCESS_STATUS;
            }
            if(appupdate != null && appupdate.Id != null){
                ApplicationTriggerHandler.IsFirstRun                                                = false;
                update appupdate;
            }
        }catch(Exception e){
            database.rollback(sp);
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'saveSanctionAuthorityInput', e);
            resp.message                                                                            = Constants.ERROR_MESSAGE;
            resp.stage                                                                              = Constants.ERROR_STATUS;
        }
        return resp;
    }

    /**
* Methods To Save All Pre disbersement Comments Given By BM
*
* @param auditRecs
* @param appId
*
* @return
*/
    public static  String savePreDisbursementComments(List<Audit__c> auditRecs,String appId){
        Boolean flag=false;
        try{
            if(! auditRecs.isEmpty()){

                update auditRecs;
                String taskCreatedornot                                                             = createPredisbursementTaskForFinalAuthority(appId);
                flag = SanctionUnderwriting_Process.isEveryPreDisbersementBMComplied(appId);
                if(flag){
                    closeExistingBMTask(appId,'Pre-disbursement Approval');
                    return 'All Compliance have been saved.';

                }else{
                    return ''+taskCreatedornot;
                }

            }else{
                return null;
            }
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'savePreDisbursementComments', e);
            return 'Some Error Occurred';
        }
    }

    /**
* Method to Create Pre Dis task For Final Auth Once BM has given its Comments
*
* @param appId
*
* @return
*/
    public static String createPredisbursementTaskForFinalAuthority(String appId){
        User finalUser;
        User loggedInUser;

        try{
            loggedInUser                                                                           = SanctionUnderwriting_Process.currentUserInfo();
            finalUser                                                                              = getFinalAuthorityUser(appId,loggedInUser);
            Task newTask                                                                           = SanctionUnderwriting_Process.getTaskObj(appId, finalUser.Id, 'Pre-disbursement Approval needed', 'Pre-disbursement Approval');

            if(newTask != null){
                insert newTask;
                return 'Task has been created for final authority';
            }else{
                system.debug('Exeption In::');
                return 'Some Error';

            }
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createPredisbursementTaskForFinalAuthority', e);
            return 'Some Error Occurred';
        }
    }
    public static List<Audit__c> getAuthorityComment(string appId){
        return [select Id,User__c,User__r.Name,User__r.Designation__c,Complied__c,Reason__c,Sanction_Authority_Comment__c,Application__c,Terms_and_Conditions__c,
                RecordType.DeveloperName,createdDate from Audit__c where (RecordType.DeveloperName =:Constants.SANCTION_AUTHORITY_AUDIT_RTYPE OR
        RecordType.DeveloperName =:Constants.UNDERWRITING_T_C_RTYPE OR
        RecordType.DeveloperName =:Constants.PREDISBURSEMENT_T_C_RTYPE ) AND Application__c =:appId];
    }

    public static List<genesis__Application_Status_History__c> getRecommendationHistory(string appId){
        return [SELECT Id,genesis__Application__c,Type__c,Recommendation_Limit_Rs__c,Facility__c,Recommendation_Rate_of_Intrest__c,User_Name__c,User_Role__c,createdDate
        FROM genesis__Application_Status_History__c where genesis__Application__r.id =: appId AND Type__c=:Constants.RECOMMENDED_CHANGE_TYPE_HISTORY];
    }

    public static List<Facility__c> getFacilityData(string appId){
        return [select Id,Application__c,Facility_Application_Type__c,Is_Facility_App_Type_Upadte__c,Recommended_Rate__c,Recommended_Limit__c,Faciliity_Type__c,Renewal_Processing_Charge__c,Recommended_Processing_Charge__c,Recommended_Spread__c,BRE_Limit__c,Name,NTB_Facility_Type__c,Is_Save_Operation_Done__c,New_Limit_Amount__c,Purpose_of_Shifting__c,Application__r.genesis__Account__c,Industry__c,CL_Product__c,Product_Category__c,CL_Product__r.clcommon__Product_Name__c,CL_Product__r.Facility_Category__c,BRE_Rate__c,BRE_Margin_Receivables__c,BRE_Margin_Stock_Manufacturing__c,BRE_Margin_Stock_Trading__c,
                Existing_Limit__c,Existing_Rate__c,Type__c,Approved_Margin__c,BRE_Spread__c,CL_Product__r.Processing_fee_renwal__c,CL_Product__r.Schematic_Loan__c,Existing_Processing_Charge__c,BRE_Processing_Charge__c,Existing_Spread__c,
                Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c,Application__r.OwnerId,Application__r.genesis__Account__r.Industry_Type__c,
                Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,MCLR_Rate__c,BRE_Margin__c,
        (Select id,Facility__c,Renewal_Processing_Charge__c,Recommended_Days__c,Deviation_Approver__c,Highest_Authority__c,Recommended_Rate__c,Recommended_Limit__c,Role__c,
                Higher_Authority_Order__c,Existing_Processing_Charge__c,Read_Only_User__c,Recommended_Processing_Charge__c,
                Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,BRE_Limit__c,Margin_Stock_Trading__c
        from Facilities__r where RecordType.DeveloperName=:Constants.FACILITY_CHILD_RECORD_TYPE AND Read_Only_User__c=false)
        FROM Facility__c where Application__r.id=: appId AND RecordType.DeveloperName =:Constants.FACILITY_PARENT_RECORD_TYPE And Active__c=true];
    }

    // Get Pre-Renewal compliance failed Reason list
    public List<String> getCheckListPendingReason(List<Renewal_Checklists__c> checkList){
        return SanctionUnderwriting_Process.getCheckListPendingReason(checkList);
    }

    public static List<Credit_Underwriting__c> getapplnUnderwriting(string appId){
        return [Select id,Appraisal__c,Comments__c,Application_Score__c,Application_Value__c,
                Application_Weight__c,Application__c,Application_Score_Percent__c,
        (Select id,Underwriting_Variable__c,toLabel(Variable_type__c),Application_Value__c,Application_Weight__c,Comments__c,
                Application_Score__c,Flags_Value__c,Flags_Range__c,RecordTypeId,RecordType.DeveloperName,Threshold_breached__c
        from Credit_Underwritings__r)
        from Credit_Underwriting__c where Application__c =: appId Order by Display_Order__c];
    }

    public static genesis__Applications__c getapplnInformation(string appId){
        
        return [Select id,No_of_years_of_operation__c,Name,Type__c,Deviation_Reason__c,Management_experience__c,Inward_cheque_return__c,Overall_Exposure__c,RecordType.DeveloperName,Processing_Fee__c,Processing_Charges__c,Is_Take_Over__c,New_to_Business__c,Legal_clearance__c,Request_Reason__c,Reason_for_Application__c,EAE_Renewal_Date_in_days__c,Is_Financial_security_Coverage_Less__c,Risk_Rating__c,Overall_Score__c,genesis__Account__r.Name,OwnerId,Committe__c,genesis__Account__r.Description,
                genesis__Account__r.Id,genesis__Account__r.Overall_Exposure__c,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.Group_Name__c,Application_Stage__c,
                genesis__Account__r.Name_of_the_Chief_Person__c,Application_Status__c,Company_Profile__c,Key_Management_Profile__c,Beuro_Profile__c,Market_Profile__c,
                genesis__Account__r.Branch_Code__c,genesis__Account__r.SMA_Classification__c,genesis__Account__r.Date_of_Incorporation__c,genesis__Account__r.Branch_Name__c,genesis__Account__r.Line_of_Activity__c,
                Branch_Code__c,Branch_Name__c,Recommended_Security_Coverage__c,Security_coverage__c,genesis__Customer_Cash_Used_For__c from genesis__Applications__c where id=: appId];
    }


    public static String currency(String i) {
        String s = ( Decimal.valueOf(i==null||i.trim()==''?'0':i).setScale(2) + 0.001 ).format();
        return s.substring(0,s.length()-1);
    }


    public static Decimal decimalConversion(Decimal decimalCon){
        Decimal sumD = 0.0;
        for (Integer i = 0; i < 10; i++) {
            sumD += decimalCon;
        }
        return sumD;
    }

    public static Decimal getPercentageChangeInValue(Decimal oldValue,Decimal newValue){
        Decimal diffValue = Math.abs(oldValue-newValue);
        return diffValue;
    }

    public static string calculateROICOMMSNDeviation(Underwriting_CTRL.saveWrapper savedata, integer fCount, Deviation_Rules__c devRule,Map<String,Deviation_Rules__c> ruleMap, string fchildRecordTypeID){

        string finalRole        = '';
        Decimal deviationdiff   = 0;
        if(savedata.facility[fCount].BRE_Spread__c!=null && savedata.facility[fCount].Recommended_Spread__c!=null)
            deviationdiff = getPercentageChangeInValue(savedata.facility[fCount].BRE_Spread__c,savedata.facility[fCount].Recommended_Spread__c);
        System.debug('#########'+savedata.facility[fCount].Recommended_Spread__c);
        System.debug('#########'+deviationdiff);
        System.debug('#########'+savedata.facility[fCount].BRE_Spread__c);
        if(savedata.facility[fCount].Product_Schematic__c == 'Yes'){
            System.debug('#########'+savedata.facility[fCount].BRE_Spread__c);
            if(savedata.facility[fCount].Type__c == 'Funded'){
                System.debug('#########'+savedata.facility[fCount].BRE_Spread__c);
                devRule = ruleMap.get('ROI');
            }else{
                System.debug('#########'+savedata.facility[fCount].BRE_Spread__c);
                devRule = ruleMap.get('COMISSION BG');
            }
            finalRole                   = getDeviationRole(deviationdiff,devRule);
        }else{
            System.debug('#########'+savedata.facility[fCount].BRE_Spread__c);
            if(savedata.facility[fCount].Type__c == 'Funded'){
                System.debug('#########'+savedata.facility[fCount].BRE_Spread__c);
                devRule = ruleMap.get('ROI-Non Schematic');
            }else{
                System.debug('#########'+savedata.facility[fCount].BRE_Spread__c);
                devRule = ruleMap.get('COMISSION BG');
            }
            finalRole                   = getDeviationRole(deviationdiff,devRule);
        }
        return finalRole;
    }

    public static string calculateProcessingDeviation(Underwriting_CTRL.saveWrapper savedata, integer fCount, Deviation_Rules__c devRule,Map<String,Deviation_Rules__c> ruleMap, string fchildRecordTypeID){

        string finalRole        = '';
        Decimal deviationdiff   = 0;
        if(savedata.facility[fCount].Existing_Processing_Charge__c != null && savedata.facility[fCount].Existing_Processing_Charge__c > 0
                && savedata.facility[fCount].Recommended_Processing_Charge__c != null){
            deviationdiff   = (getPercentageChangeInValue(savedata.facility[fCount].Existing_Processing_Charge__c,savedata.facility[fCount].Recommended_Processing_Charge__c)/savedata.facility[fCount].Existing_Processing_Charge__c) * 100;
        }
        if(savedata.facility[fCount].Product_Schematic__c == 'Yes'){
            devRule = ruleMap.get('PROCESSING CHARGE SCHEMATIC');
            finalRole                   = getDeviationRole(deviationdiff,devRule);
        }else{
            devRule = ruleMap.get('PROCESSING CHARGE NON SCHEMATIC');
            finalRole                   = getDeviationRole(deviationdiff,devRule);
        }
        return finalRole;
    }
    
    public static string calculateProcessingDeviationForEnhancement(String schematicValue,Decimal finalDeviationValue,Deviation_Rules__c devRule,Map<String,Deviation_Rules__c> ruleMap){
		system.debug('finalDeviationValue::'+finalDeviationValue);
        system.debug('schematicValue::'+schematicValue);
        string finalRole        = '';
        /*system.debug('savedata.facility[fCount].Existing_Processing_Charge__c::'+savedata.facility[fCount].Existing_Processing_Charge__c);
        system.debug('savedata.facility[fCount].Recommended_Processing_Charge__c::'+savedata.facility[fCount].Recommended_Processing_Charge__c);
        if(savedata.facility[fCount].Existing_Processing_Charge__c != null && savedata.facility[fCount].Existing_Processing_Charge__c > 0
                && savedata.facility[fCount].Recommended_Processing_Charge__c != null){
                  deviationdiff =   (valueToBeComparedFrom/valueToBeComparedTo) * 100;
            //deviationdiff   = (getPercentageChangeInValue(valueToBeComparedTo,valueToBeComparedFrom)/valueToBeComparedTo) * 100;
                    system.debug('deviationdiff::'+deviationdiff);
        }*/
        if(schematicValue == 'Yes'){
            devRule = ruleMap.get('PROCESSING CHARGE SCHEMATIC');
            finalRole                   = getDeviationRole(finalDeviationValue,devRule);
        }else{
            devRule = ruleMap.get('PROCESSING CHARGE NON SCHEMATIC');
            finalRole                   = getDeviationRole(finalDeviationValue,devRule);
        }
        return finalRole;
    }

    public static string marginDeviation(Decimal newVal, integer fCount, Deviation_Rules__c devRule,string fchildRecordTypeID){

        string finalRole            = '';
        //Decimal deviationdiff       = getPercentageChangeInValue(existing,newVal);
        finalRole                   = geMargintDeviationRole(newVal,devRule);
        return finalRole;
    }

    public static string getDeviationRole(Decimal deviationVal,Deviation_Rules__c devRule){

        if(deviationVal <= (Decimal)devRule.get('DOCC__c')){
            return 'DOCC';
        }else if(deviationVal > (Decimal)devRule.get('DOCC__c') && deviationVal <= (Decimal)devRule.get('CO_GM__c')){
            return 'CO_GM';
        }else if(deviationVal > (Decimal)devRule.get('CO_GM__c') ){
            return 'President_COO';
        }else if(deviationVal >= (Decimal)devRule.get('COCC__c')){
            return 'COCC';
        }
        return null;
    }

    public static string geMargintDeviationRole(Decimal deviationVal,Deviation_Rules__c devRule){

        if((Decimal)devRule.get('DOCC__c') > 0 && deviationVal <= (Decimal)devRule.get('Limit_Value__c')
                && deviationVal >= (Decimal)devRule.get('DOCC__c')){
            return 'DOCC';
        }else if((Decimal)devRule.get('CO_GM__c') > 0 && deviationVal >= (Decimal)devRule.get('CO_GM__c')
                && deviationVal <= (Decimal)devRule.get('Limit_Value__c')){
            return 'CO_GM';
        }else if((Decimal)devRule.get('President_and_COO__c') > 0 && deviationVal >= (Decimal)devRule.get('President_and_COO__c')
                && deviationVal <= (Decimal)devRule.get('Limit_Value__c')){
            return 'President_COO';
        }else if((Decimal)devRule.get('COCC__c') > 0 && deviationVal >= (Decimal)devRule.get('COCC__c')
                && deviationVal <= (Decimal)devRule.get('Limit_Value__c')){
            return 'COCC';
        }
        return null;
    }

    public static User getFinalAuthorityUser(string applId , User currentUser){
        User finalUser              = new User();
        List<User> finalUserList    = new List<User>();
        string role = '';
        List<Facility__c> facilityList  = SanctionUnderwriting_Process.getFacilityAuthority(applId);
        for(Facility__c f : facilityList){
            if(f.Highest_Authority__c){
                role    = f.Role__C;
                break;
            }
        }
        if(role != '' && role !=null){
            if(role.startsWith('BR_')){
                genesis__Applications__c applRecord = [SELECT Id,OwnerId FROM genesis__Applications__c WHERE Id =:applId LIMIT 1];
                finalUser                           = [SELECT id,Designation__c,Division,IsActive FROM user where IsActive=true AND Id =:applRecord.OwnerId LIMIT 1];
            }else{
                if(currentUser.Division =='Central Office' && role != 'CO_CC' && role != 'CO_GM'){
                    genesis__Applications__c applRecord                   = [SELECT Id,OwnerId FROM genesis__Applications__c WHERE Id =:applId LIMIT 1];
                    User branchUser = finalUser                           = [SELECT id,Designation__c,Division,IsActive FROM user where IsActive=true AND Id =:applRecord.OwnerId LIMIT 1];
                    finalUserList   = SanctionUnderwriting_Process.getUserRecord(role, branchUser.Division);
                    if(finalUserList.size() > 0){
                        finalUser   = finalUserList[0];
                    }
                }else{
                    finalUserList   = SanctionUnderwriting_Process.getUserRecord(role, currentUser.Division);
                    if(finalUserList.size() > 0){
                        finalUser   = finalUserList[0];
                    }
                }

            }

        }
        return finalUser;
    }

    public static String getLevelHirerachyMap(List<Authority_Hierarchy_Level__mdt> authLevelList,String hLevel){
        if(hLevel != null && hLevel != Constants.COCC_ROLE){
            Map<Decimal,String> authLevelmap = new Map<Decimal,String>();
            Decimal authLevel;
            for(Authority_Hierarchy_Level__mdt ahl : authLevelList){
                if(hLevel == ahl.DeveloperName ){
                    if(ahl.DeveloperName.contains('BR_MGR'))
                        authLevel = 8;
                    else
                            authLevel = ahl.Authority_Level__c +1;
                }
                if(ahl.Authority_Level__c != null && ahl.Authority_Level__c > 0){
                    authLevelmap.put(Integer.ValueOf(ahl.Authority_Level__c),ahl.DeveloperName);
                }
            }
            RETURN authLevelmap.get(authLevel);
        }
        else
                RETURN hLevel;
    }
    /*
This method is used to send Notification to BM in case of final security coverage is less than recommended
*/
    public static String sendNotificationToBM(String appId){

        try{
            genesis__Applications__c apprecord;
            List<String> toAddresses                                = new List<String>();
            apprecord                                               = [Select Id,Name,Owner.Email from genesis__Applications__c WHERE Id =:appId];

            if(apprecord != null && apprecord.Owner.Email != null){
                toAddresses.add(apprecord.Owner.Email) ;
            }

            if(!toAddresses.isEmpty()){
                return sendEmail(toAddresses,null,'kvv@support.com','Final Security Coverage is less','',null,null);
            }else{
                return null;
            }

        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'sendNotificationToBM', e);
            return 'Some Error Occurred';
        }

    }

    public static String sendEmail(List<String> toAddresses,List<String> ccAddresses,String setReplyTo,String subject,String emailTemplateId,String plainTextBody,String setHtmlBody){

        try{

            Messaging.SingleEmailMessage mail                       = new Messaging.SingleEmailMessage();

            if(!toAddresses.isEmpty()){
                mail.setToAddresses(toAddresses);
            }
            if(!ccAddresses.isEmpty()){
                mail.setCcAddresses(ccAddresses);
            }
            if(setReplyTo != '' && setReplyTo != null){
                mail.setReplyTo(setReplyTo);
            }
            if(subject != '' && subject != null){
                mail.setSubject(subject);
            }
            if(emailTemplateId != null && emailTemplateId != ''){
                mail.setTemplateID(emailTemplateId);
            }
            if(plainTextBody != '' && plainTextBody != null){
                mail.setPlainTextBody(plainTextBody);
            }
            if(setHtmlBody != '' && plainTextBody != null){
                mail.setHtmlBody(setHtmlBody);
            }
            List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
            if (owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            return 'Email has been sent';

        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'sendEmail', e);
            return 'Some Error Occurred';
        }

    }
    /*
This method is used to create Task (Type- > Insufficient Collateral Coverage) for BM when Final Coverage < Recommended coverage
*/
    public static String createInsCollTaskForBm(String appId){

        Task taskToInsert;
        genesis__Applications__c apprecord;
        try{

            apprecord                                               = [Select Id,Name,OwnerId from genesis__Applications__c WHERE Id =:appId];

            if(apprecord != null && apprecord.OwnerId != null){
                //taskToInsert                                            = SanctionUnderwriting_Process.getTaskObj(appId,apprecord.OwnerId, 'Insufficient collateral coverage','Insufficent collateral coverage');
                taskToInsert                                            = SanctionUnderwriting_Process.getTaskObj(appId,apprecord.OwnerId, 'Insufficient collateral coverage','EME BM Review');

            }

            if(taskToInsert != null){
                TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
                insert taskToInsert;
                return 'Task for BM has been Created';
            }else{
                return 'Task creation for BM Has failed';
            }


        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createInsCollTaskForBm', e);
            return 'Some Error Occurred';
        }

    }

    public static Decimal getRecomendedLimitAggregate(String appId){
        try{
            List<Facility__c> allfacilities                        = new List<Facility__c>();
            Decimal aggregateRecomendedLimit                       = 0;
            allfacilities                                          = SanctionMatrixControllerHelper_EA.getAllFacilities(appId);
            aggregateRecomendedLimit                               = SanctionMatrixControllerHelper_EA.getRecommendedAggregate(allfacilities);
            return aggregateRecomendedLimit;
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'getRecomendedLimitAggregate', e);
            return null;
        }
    }

    /**
* Method to create Property Evaluation task for clpc user And close Collateral Evaluation task for CLPC user
*
* @param appId
* @param type
* @param subject
*
* @return
*/
    webservice  static String createCLPCTask(String appId,String type,String subject){
        try {
            List<Task> taskList                     = new List<Task>();
            User rlpcUser = SOQL_Util.getRLPCUser(appId);
            closeExistingBMTask(appId,'Collateral Evaluation');

            if(rlpcUser != null)
                taskList.add(SanctionUnderwriting_Process.getTaskObj(appId, rlpcUser.Id, subject, type));
            if(! taskList.isEmpty() && !checkIFOpenTaskAlreadyExist(appId,'Property Evaluation'))
                insert taskList;
            return 'Task has been created for CLPC User';
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createCLPCTask', e);
            return 'Some Error Occurred while creating clpc task';
        }
    }

    /**
* Method to create Legal Task for BM and close existing Property Evaluation Task
*
* @param appId
* @param type
* @param subject
*
* @return
*/
    webservice  static String createDOLegalTask(String appId,String type,String subject){
        try {
            List<Task> taskList                     = new List<Task>();
            User rlpcUser = SOQL_Util.getDOLegalUser(appId);
            closeExistingCLPCTask(appId,'Property Evaluation');
            if(rlpcUser != null && rlpcUser.Id !=null)
                taskList.add(SanctionUnderwriting_Process.getTaskObj(appId, rlpcUser.Id, subject, type));
            if(! taskList.isEmpty() && !checkIFOpenTaskAlreadyExist(appId,'Legal Evaluation'))
                insert taskList;
            return 'Task has been created for DO Leagal Officer';
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createDOLegalTask', e);
            return 'Some Error Occurred DO leagal task';
        }
    }

    /**
* Method is called from Skuid View to close mod task for Bm and then updates the application stage
*
* @param appId
* @param taskType
*/
    webservice static void closeExistingBMTaskMOD(string appId,String taskType) {
        try {
            genesis__Applications__c appRecord = [Select Id,Name,Type__c,Application_Stage__c,RecordType.DeveloperName from genesis__Applications__c where Id=:appId];

            if(appRecord!= null && (appRecord.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE || appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC)){
                // And Also don't call this method when already MOD has been completed
                if(checkIFAllB1DocumentsAreAvailable(appId,appRecord.RecordType.DeveloperName,appRecord.Application_Stage__c)){//checkIFAllB1DocumentsAreAvailable(appId)){
                    closeExistingBMTask(appId,taskType);
                    if(appRecord.Type__c != null && appRecord.Type__c.contains('Takeover')){
                        SME_CBS_EAE.verifyDocumentTaskCreate(appRecord.Id);
                    }
                    appRecord.Sub_Stage__c = '';
                    update appRecord;
                }
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'closeExistingBMTaskMOD', e);
        }
    }
    webservice static void closeExistingBMTask(string appId,String taskType) {

        try{
            List<String> taskTypeLst= new List<String>{taskType};


            List<genesis__Applications__c> appInfo         = new List<genesis__Applications__c>();
            appInfo                                        = SOQL_Util.getApplication(new Set<Id>{appId});
            /*if(taskType== 'MOD Needed'){
                taskTypeLst.add('Generate Documents');
                if(appInfo[0].RecordType.DeveloperName== Constants.SME_NEW_LOAN_RECORD_TYPE && appInfo[0].Type__c!=null && appInfo[0].Type__c.contains('Takeover')){
                    taskTypeLst.add('Complete takeover formalities');
                }
            }*/
            List<Task> existingTaskList= new List<Task>();
            List<User> coUserList= SOQL_Util.getBRCreditOfficer(appId);
            existingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And OwnerId =: appInfo[0].OwnerId And Type IN : taskTypeLst]; //(Type=:taskType OR Type='Generate Documents')
            if(existingTaskList.size()==0 && coUserList.size()>0){
                existingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And OwnerId =: coUserList[0].Id And Type IN : taskTypeLst];
            }
            map<String,Task> taskTypemap= new map<String,Task>();
            if(existingTaskList.size() > 0){
                for(Task tsk : existingTaskList){
                    taskTypemap.put(tsk.Type,tsk);
                }
            }
            system.debug('existingTaskList.size====> '+existingTaskList.size());
            Boolean allB1DocFlag= checkIFAllB1DocumentsAreAvailable(appId,appInfo[0].RecordType.DeveloperName,appInfo[0].Application_Stage__c); // = checkIFAllB1DocumentsAreAvailable(appId);
            system.debug('allB1DocFlag======> '+allB1DocFlag);
            if( taskTypemap!=null){
                Task tskRec= taskTypemap.get(taskType);
                if(taskType == 'MOD Needed'){
                    system.debug('tskRec====> '+tskRec);
                    system.debug('allB1DocFlag====> '+allB1DocFlag);
                    if(allB1DocFlag && tskRec.Status=='Not Started'){
                        tskRec.Status= 'Completed';
                        Update tskRec;
                    }
                }else if(tskRec.Status=='Not Started'){
                    tskRec.Status= 'Completed';
                    Update tskRec;
                }
            }

            if(taskType== 'MOD Needed'){
                for(task tk:[SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId  And Type IN ('Generate Documents','Complete takeover formalities') ]){
                    taskTypemap.put(tk.Type,tk);
                }
            }

            if(taskType == 'MOD Needed' && allB1DocFlag && taskTypemap.containskey('Generate Documents') && taskTypemap.get('Generate Documents').Status== 'Completed'){
                Boolean CompDocFlag= false;

                if(appInfo[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                    appInfo[0].Application_Stage__c = 'Enhancement- E-sign pending';
                    CompDocFlag= true;
                }
                if(appInfo[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                    appInfo[0].Application_Stage__c = 'Adhoc- E-sign pending';
                    CompDocFlag= true;
                }
                if(appInfo[0].RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    if(appInfo[0].Type__c!=null && appInfo[0].Type__c.contains('Takeover') && appInfo[0].Application_Stage__c=='New Loan- Final Sanction Accepted'){
                        if(taskTypemap.containskey('Complete takeover formalities') && taskTypemap.get('Complete takeover formalities').Status== 'Completed'){
                            appInfo[0].Application_Stage__c = 'New loan- E-sign pending';
                            CompDocFlag= true;
                        }
                    }else{
                        appInfo[0].Application_Stage__c = 'New loan- E-sign pending';
                        CompDocFlag= true;
                    }

                }

                appInfo[0].Sub_Stage__c            = '';

                ApplicationTriggerHandler.IsFirstRun = false;
                update appInfo;
                if(CompDocFlag){
                    //SME_Digio_Service_EAE.createCompleteDocTask(appInfo[0].Id);
                }
                if(appInfo[0].Application_Stage__c == Constants.NEW_LOAN_FINAL_SANCTION_OFFERED && appInfo[0].Type__c.contains('NTB')){
                    List<User> COuserLst=SOQL_Util.getBRCreditOfficer(appId);
                    if(COuserLst.size()>0){
                        SOQL_Util.createTaskForBRCreditOfficer(appId,COuserLst[0].Id,'Fill CBS Customer Info','Update CBS Info');

                    }else{
                        SOQL_Util.createTaskForBM(appId,'Fill CBS Customer Info','Update CBS Info');
                    }
                }
            }
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'closeExistingBMTask', e);
        }

    }

    /**
* Method to check if all B! documents are available for Each Collateral
*
* @param appId
*
* @return
*/
    public static Boolean checkIFAllB1DocumentsAreAvailable(string appId,string recordType,string appStage) {
        try {

            List<genesis__Application_Collateral__c> allAppFEColList;
            List<Attachment> attList;
            List<String> attachDocNameList= new List<String>();
            
            if(recordType!= 'SME_NEW_Loan'){
                allAppFEColList = [Select id,genesis__Collateral__r.Name,Application__c,genesis__Collateral__r.FE_Created__c,genesis__Collateral__r.Active__c from genesis__Application_Collateral__c where Application__c=:appId And genesis__Collateral__r.FE_Created__c=true And genesis__Collateral__r.Active__c=true];
                attList = [Select Id,Name FROM Attachment WHERE parentId = :appId And Name like 'B1_EAE%'];
            }else if(recordType== 'SME_NEW_Loan' && appStage== 'New Loan- Final Sanction Accepted'){
                allAppFEColList = [Select id,genesis__Collateral__r.Name,Application__c,genesis__Collateral__r.FE_Created__c,genesis__Collateral__r.Active__c from genesis__Application_Collateral__c where Application__c=:appId And genesis__Collateral__r.FE_Created__c=true And genesis__Collateral__r.Active__c=true AND genesis__Collateral__r.Category_of_Loan__c NOT IN ('Outright purchase of building','Purchase of land and construction there on')];
                for(genesis__Application_Collateral__c appCollat:allAppFEColList){
                    attachDocNameList.add('B1_EAE_'+appCollat.genesis__Collateral__r.Name+'.pdf');
                }
                system.debug('attachDocNameList======> '+attachDocNameList);
                                if(attachDocNameList.size()>0){
                   attList = [Select Id,Name FROM Attachment WHERE parentId = :appId And Name IN : attachDocNameList]; 
                }
                system.debug('attList======> '+attList);

            }else if(recordType== 'SME_NEW_Loan' && appStage== 'Limit Opened'){
                allAppFEColList = [Select id,Name,genesis__Collateral__r.Name,Application__c,genesis__Collateral__r.FE_Created__c,genesis__Collateral__r.Active__c from genesis__Application_Collateral__c where Application__c=:appId And genesis__Collateral__r.FE_Created__c=true And genesis__Collateral__r.Active__c=true AND genesis__Collateral__r.Category_of_Loan__c IN ('Outright purchase of building','Purchase of land and construction there on')];
                for(genesis__Application_Collateral__c appCollat:allAppFEColList){
                    attachDocNameList.add('B1_EAE_'+appCollat.genesis__Collateral__r.Name+'.pdf');
                }
                if(attachDocNameList.size()>0){
                   attList = [Select Id,Name FROM Attachment WHERE parentId = :appId And Name IN : attachDocNameList]; 
                }
            }
            system.debug('allAppFEColList===> '+allAppFEColList.size()+'; attList===>'+attList.size());
            if(allAppFEColList.size()>0){
                
                if(!attList.isEmpty())
                    return allAppFEColList.size() == attList.size() ? true:false;
                else
                        return false;
            }else{
                return true;
            }


        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIFAllB1DocumentsAreAvailable', e);
            return null;
        }
    }
    /**
* Method is used to close Existing CLPC User task
*
* @param appId
* @param taskType
*/
    public static void closeExistingCLPCTask(string appId,String taskType) {
        try{
            User rlpcUser = SOQL_Util.getRLPCUser(appId);
            List<Task> getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And OwnerId =: rlpcUser.Id And Type=:taskType And Status = 'Not Started'];

            if(! getExistingTaskList.isEmpty()){
                getExistingTaskList[0].Status = 'Completed';
            }
            update getExistingTaskList;
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'closeExistingCLPCTask', e);
        }

    }

    /**
* Method is used to close Existing Legal User task
*
* @param appId
* @param taskType
*/
    public static void closeExistingLeagalTask(string appId,String taskType) {
        try{
            User rlpcUser = SOQL_Util.getDOLegalUser(appId);
            List<Task> getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And OwnerId =: rlpcUser.Id And Type=:taskType And Status = 'Not Started'];

            if(! getExistingTaskList.isEmpty()){
                getExistingTaskList[0].Status = 'Completed';
            }
            update getExistingTaskList;
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'closeExistingLeagalTask', e);
        }

    }

    /**
* Method to close a existing task of given type
*
* @param appId
* @param taskType
*/
    webservice static void closeExistingTask(string appId,String taskType) {
        try{
            User currentUserInfo                                    = SanctionUnderwriting_Process.currentUserInfo();
            System.debug('currentUserInfo::::::::::'+currentUserInfo);
            List<Task> getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And Type=:taskType And OwnerId =: currentUserInfo.Id And Status = 'Not Started'];

            if(! getExistingTaskList.isEmpty()){
                getExistingTaskList[0].Status = 'Completed';
            }
            update getExistingTaskList;
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'closeExistingTask', e);
        }

    }

    /**
* Method to Create task for BM
*
* @param appId
* @param taskType
* @param subject
*
* @return
*/
    public static String createLegalEvaluationTaskForBM(string appId,String taskType,String subject) {
        try {
            List<Task> taskList                                     = new List<Task>();
            List<genesis__Applications__c> appInfo                  = new List<genesis__Applications__c>();
            appInfo                                                 = SOQL_Util.getApplication(new Set<Id>{appId});
            taskList.add(SanctionUnderwriting_Process.getTaskObj(appId, appInfo[0].OwnerId, subject, taskType));

            //if(! taskList.isEmpty() && !checkIFOpenTaskAlreadyExist(appId,taskType)){
            if(! taskList.isEmpty() && ! SOQL_Util.checkIfTaskIsPresent(appId,subject,taskType)){
                System.debug('@@@@@'+taskType);
                TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
                insert taskList;
            }
            return 'Legal Evaluation Task has been created for BM user.';

        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createLegalEvaluationTaskForBM', e);
            return 'Some Error Occurred';
        }
    }

    /**
* Check if All m68 record is available
*
* @param customerId
*
* @return
*/
    public static Boolean checkIfM21ExistForLastThreeYears(String customerId){
        try {
            List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();
            List<String> fyList = new List<String>{YearDataConstant.currFiscalYear, YearDataConstant.nthFiscalYear, YearDataConstant.n_1_FiscalYear};
            m68DataList = SOQL_Util.getM68Data(customerId, fyList);
            if(m68DataList.size()>0){
                if(m68DataList.size()==3 && isAllDataSourceAvailable(m68DataList)){
                    return true;
                }else{
                    return false;
                }
            }else{
                return false;
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIfM21ExistForLastThreeYears', e);
            return false;
        }
    }

    /**
* Method to know if All m68 data is either from perfios and probe42
*
* @param m68DataList
*
* @return
*/
    public static Boolean isAllDataSourceAvailable(List<M68_Balance_Sheet_Analysis__c> m68DataList){
        try {
            if(m68DataList.size()>0){
                for(M68_Balance_Sheet_Analysis__c m68Rec:m68DataList){
                    if(m68Rec.Data_Source__c == '' || m68Rec.Data_Source__c == null)
                        return false;
                }
            }
            return true;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'isAllDataSourceAvailable', e);
            return null;
        }
    }

    /**
* Method to know if an Application is  Enhancement
*
* @param appId
*
* @return
*/
    public static Boolean isEnhancementApplication(String appId){
        try{
            List<genesis__Applications__c >         applnInfo                 = new List<genesis__Applications__c>();
            applnInfo                                                         = [Select id, name ,RecordType.DeveloperName from genesis__Applications__c where Id=:appId];
            if(applnInfo != null && !applnInfo.isEmpty()){
                if(applnInfo[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT)
                    return true;

            }
            return false;
        }catch (Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'isEnhancementApplication', e);
            return false;
        }

    }
    /**
* Method to know if an Application is  New Loan
*
* @param appId
*
* @return
*/
    public static Boolean isNewLoanApplication(String appId){
        try{
            List<genesis__Applications__c >         applnInfo                 = new List<genesis__Applications__c>();
            applnInfo                                                         = [Select id, name ,RecordType.DeveloperName from genesis__Applications__c where Id=:appId];
            if(applnInfo != null && !applnInfo.isEmpty()){
                if(applnInfo[0].RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)
                    return true;
            }
            return false;
        }catch (Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'isEnhancementApplication', e);
            return false;
        }

    }
    // Method to return Application Object of appId.
    public static genesis__Applications__c getRecordTypeName(String appId){
        try{
            genesis__Applications__c applnInfo             = [Select id, name ,Type__c,RecordType.DeveloperName from genesis__Applications__c where Id=:appId];
            if(applnInfo != null){
                return applnInfo;
            }
        }catch (Exception e){
            system.debug('Error ::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
        }
        return null;
    }

    /**
* Method to know if an Application is  Adhoc
*
* @param appId
*
* @return
*/
    public static Boolean isAdhocApplication(String appId){
        try{
            List<genesis__Applications__c >         applnInfo                       = new List<genesis__Applications__c>();
            applnInfo                                                               = [Select id, name ,RecordType.DeveloperName from genesis__Applications__c where Id=:appId];
            if(applnInfo != null && !applnInfo.isEmpty()){
                if(applnInfo[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC)
                    return true;

            }
            return false;
        }catch (Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'isAdhocApplication', e);
            system.debug('Error @::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return false;
        }

    }

    /**
* Method to know if an Application is Exceeding or Adhoc
*
* @param appId
*
* @return
*/
    public static Boolean isExceedingAdhoc(String appId){
        try{
            List<genesis__Applications__c >         applnInfo                       = new List<genesis__Applications__c>();
            applnInfo                                                               = [Select id, name ,RecordType.DeveloperName from genesis__Applications__c where Id=:appId];
            if(applnInfo != null && !applnInfo.isEmpty()){
                if(applnInfo[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING || applnInfo[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC)
                    return true;

            }
            return false;
        }catch (Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'isExceedingAdhoc', e);
            system.debug('Error ::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return false;
        }

    }
    /**
* Method to know if an Application is Exceeding
*
* @param appId
*
* @return
*/
    public static Boolean isExceeding(String appId){
        try{
            List<genesis__Applications__c >         applnInfo                       = new List<genesis__Applications__c>();
            applnInfo                                                               = [Select id, name ,RecordType.DeveloperName from genesis__Applications__c where Id=:appId];
            if(applnInfo != null && !applnInfo.isEmpty()){
                if(applnInfo[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING)
                    return true;

            }
            return false;
        }catch (Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'isExceedingAdhoc', e);
            system.debug('Error ::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return false;
        }

    }

    /**
* Method to Create Collateral Evaluation Task For BM
*
* @param appId
* @param isRecommendedLessThanEqualToEstimated
*
* @return
*/
    public static String checkIfLegalTaskHasToBeCreatedForBM(string appId,Boolean isRecommendedLessThanEqualToEstimated) {
        try {

            Boolean isFECreatedCollateralExist                                          = false;
            for(genesis__Application_Collateral__c appColRecord:[SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c=:appId AND genesis__Collateral__r.FE_Created__c=true]){
                if(appColRecord.genesis__Collateral__r.FE_Created__c)
                    isFECreatedCollateralExist                                              = true;
            }
            // Code to run if all collateral has has market value as >=0
            if(isFECreatedCollateralExist && isRecommendedLessThanEqualToEstimated){
                genesis__Applications__c    appObject   = getRecordTypeName(appId);
                List<User> COuserLst=SOQL_Util.getBRCreditOfficer(appId);
                If(appObject !=null && appObject.RecordType.DeveloperName   == Constants.SME_NEW_LOAN_RECORD_TYPE && appObject.Type__c !=null && appObject.Type__c.contains('NTB')){
                    if(COuserLst.size()>0){
                        SOQL_Util.createTaskForBRCreditOfficer(appId,COuserLst[0].Id,'Collect processing fees from the new to bank customer','BM task for Collect processing fees from the new to bank customer');

                    }else{
                        SOQL_Util.createTaskForBM(appId,'Collect processing fees from the new to bank customer','BM task for Collect processing fees from the new to bank customer');
                    }
                }
                if(COuserLst.size()>0){

                    SOQL_Util.createTaskForBRCreditOfficer(appId,COuserLst[0].Id,'BM task for uploading Valuation report and Legal opinion','Collateral Evaluation');

                }else{
                    createLegalEvaluationTaskForBM(appId,'Collateral Evaluation','BM task for uploading Valuation report and Legal opinion');
                }


            }
            return '';
        }catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIfLegalTaskHasToBeCreatedForBM', e);
            return 'Some Error Occurred';
        }

    }

    /**
* Method to Run BRE
*
* @param appId
*
* @return
*/
    webservice  static String runBreAfterM121(String appId){
        try {

            if(appId != null){

                closeExistingBMTask(appId,'M121 A Needed');
                return runBreAfterM121Helper(appId);

            }

            return 'Some Error while running BRE';
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'runBreAfterM121', e);
            system.debug('Error :::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return 'Some Error Occurred while running BRE';
        }
    }

    /**
* Helper Method to run BRE
*
* @param appId
*
* @return
*/
    public  static String runBreAfterM121Helper(String appId){
        try {
            String isBreSuccess = '';
            Map<String, Schema.SObjectField> accountFieldMap                                = Schema.getGlobalDescribe().get('genesis__Applications__c' ).getDescribe().fields.getMap();
            List<genesis__Applications__c> applicationList                                  = new List<genesis__Applications__c>();
            Set<string> APP_TYPE                                                            = new Set<string>{Constants.SME_APP_RECORD_TYPE_ENHANCEMENT};
            Decimal exposureLimit                                                           = KVB_Company_Details__c.getOrgDefaults().Overall_Exposure_Limit__c;
            String query                                                                    = 'SELECT ';
            for(Schema.SObjectField s : accountFieldMap.values()){
                query                                                                       = query + s.getDescribe().getName()+',';
            }
            query                                                                          += 'RecordType.DeveloperName,genesis__Account__r.Date_of_Incorporation__c,genesis__Account__r.CUSTSINCE__c,(SELECT Id,genesis__Party_Account_Name__r.CIBIL_Status__pc,genesis__Party_Account_Name__r.CIBIL_Score__c FROM genesis__Application_Parties__r WHERE Active__c = true) FROM genesis__Applications__c WHERE Qualitative_input_done__c=true AND CommercialPR_Stage__c = \'Completed\' AND List_Matching_Stage__c = \'Completed\' AND Active__c = true AND Id=:appId';
            for(genesis__Applications__c app : Database.query(query)){
                if(app.genesis__Application_Parties__r.size() > 0){
                    Integer partyCount                                                      = 0;
                    for(genesis__Application_Parties__c party : app.genesis__Application_Parties__r){
                        if(party.genesis__Party_Account_Name__r.CIBIL_Status__pc == 'Complete' && party.genesis__Party_Account_Name__r.CIBIL_Score__c != null ){
                            partyCount++;
                        }
                    }
                    if(partyCount == app.genesis__Application_Parties__r.size())applicationList.add(app);
                }else{
                    applicationList.add(app);
                }
            }

            if(!applicationList.isEmpty()){
                // ApplicationList will contain only one record-Koi future main ungli na uthaye ->Ye code Amritesh ne likhwaya hai
                for(genesis__Applications__c app : applicationList ){
                    Boolean shallBREExecuted                                                = false;
                    if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT ) {
                        if(app.Overall_Exposure__c > exposureLimit){
                            if(app.Perfios_Captured__c)
                                shallBREExecuted                                            = true;
                            else
                                    shallBREExecuted = false;
                        }else if(app.Overall_Exposure__c>0){
                            shallBREExecuted                                                = true;
                        }
                    }else if(app.RecordType.DeveloperName != Constants.SME_APP_RECORD_TYPE_ENHANCEMENT && app.RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE && app.Overall_Exposure__c >=0){
                        shallBREExecuted                                                = true;
                    }else if(app.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                        Boolean flag = YearDataConstant.isRunBREForNewLoan(app.Id);
                        System.debug('flag@@@2290'+flag);
                        if(flag){

                            if(app.Overall_Exposure__c > exposureLimit){
                                if(app.Perfios_Captured__c)
                                    shallBREExecuted                                            = true;
                                else
                                        shallBREExecuted = false;
                            }else if(app.Overall_Exposure__c>0){
                                shallBREExecuted                                                = true;
                            }
                        }
                    }
                    if(shallBREExecuted){
                        try{
                            SME_BRE_Score_Calculator.runBRERule(app,true);
                            isBreSuccess                                                    = 'BRE Executed Successful';
                        }
                        catch(Exception e){
                            isBreSuccess                                                    = e.getMessage() + ' AT '+e.getLineNumber()+' StackTrace '+e.getStackTraceString();
                        }
                    }else{
                        isBreSuccess = 'Pre-Enhancement Checks to run BRE is Pending';
                    }

                }
            }else{
                isBreSuccess = 'Pre-Enhancement Checks to run BRE is Pending';
            }
            return isBreSuccess;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'runBreAfterM121Helper', e);
            return 'Some Error Occurred';
        }
    }

    /**
* Method To create Authority recoomendation for Exceeding record
* Method is being called from skuid view
* @param appId
*
* @return
*/
    webservice  static string createBMAuthRecommendationIfNotExist(String appId){
        try{

            if(!SanctionMatrixControllerHelper_EA.checkIfBMRoleAlreadyExist((appId))) {

                User userRec;
                genesis__Applications__c appRec;
                String bmDesignation                                         = '';
                String facilityChildRTypeID                                  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
                List<Facility__c> bmTaskList                                 = new List<Facility__c>();
                if (appId != null && appId != '') {
                    appRec                                                   = [SELECT Id,OwnerId,RecordType.DeveloperName from genesis__Applications__c where Id = :appId];
                    if (appRec.OwnerId != null) {
                        userRec                                              = [Select Id,Designation__c FROM User where id = :appRec.OwnerId];
                        if (userRec.Designation__c != null) {
                            bmDesignation                                    = userRec.Designation__c;
                        }
                    }
                }

                string query                                                 = 'Select id,Name,Application__c,Application__r.ownerId,Application__r.Application_Stage__c,Limit_Amount__c,Existing_Limit__c,Type__c,Application__r.genesis__Account__c,CL_Product__c,Existing_Rate__c,Existing_Processing_Charge__c,Approved_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Recommended_Limit__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c' + ', (select id,genesis__Collateral__c from Facility_Security__r) from Facility__c where Application__c =:appId';
                List<Facility__c> facList                                    = Database.query(query);

                if (!facList.isEmpty()) {
                    for (Facility__c facRec : facList) {

                        Facility__c bmFacility                               = new Facility__c();
                        bmFacility.Facility__c                               = facRec.Id;
                        bmFacility.CL_Product__c                             = facRec.CL_Product__c;
                        bmFacility.EME_BM_User__c                            = TRUE ;
                        bmFacility.Higher_Authority_Order__c                 = 1;
                        if (bmDesignation != '')
                            bmFacility.Role__c                               = bmDesignation;
                        bmFacility.RecordTypeId                              = facilityChildRTypeID;
                        bmTaskList.add(bmFacility);

                    }
                }
                Task taskForBM;
                if (appId != null && appRec.OwnerId != null) {
                    if (!Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appId, 'EME BM Review'))
                        taskForBM                                              = SanctionUnderwriting_Process.getTaskObj(appId, appRec.OwnerId, 'BM Recommendation', 'EME BM Review');
                }

                if (!bmTaskList.isEmpty()) {
                    insert bmTaskList;
                }
                if (taskForBM != null) {
                    insert taskForBM;
                }
            }
            return 'BM Authority recommendation has been created';
        }catch(Exception ex){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createBMAuthRecommendationIfNotExist', ex);
            return 'Some error Occurred BM Authority recommendation';
        }
    }

    /**
* Method to check if Signer Details is needed in fetch Api
*
* @param appId`
* @param docName
*
* @return
*/
    public static Boolean checkIfSignerDetailsNeeded(string appId,String docName) {
        try {
            List<genesis__Application_Parties__c> grPartyList               = new List<genesis__Application_Parties__c>();
            List<String> docNames;
            List<Digio_Document_ID__c> digioDocumentIDS                     = new List<Digio_Document_ID__c>();

            grPartyList = [SELECT Id,Guarantor__c FROM genesis__Application_Parties__c WHERE genesis__Application__c =: appId AND Guarantor__c = true];

            if(grPartyList.size() > 0)
                docNames = new List<String>{'Exceeding Sanction Letter','Guarantor Agreement'};
            else
                    docNames = new List<String>{'Exceeding Sanction Letter'};

            digioDocumentIDS                                                = [Select id,Name from Digio_Document_ID__c where Application__c=:appId and Name IN :docNames];

            if((digioDocumentIDS.size() == 2 && grPartyList.size() > 0) || (digioDocumentIDS.size() == 1 && grPartyList.size() == 0))
                return true;
            else
                    return false;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIfSignerDetailsNeeded', e);
            return false;
        }
    }

    /**
* Helper to mark BM As Higher Authority on first final security coverage run
*
* @param BMAuthrecommendationIds
* @param appId
*/
    public static void markBMAsHighestAuth(List<String> BMAuthrecommendationIds,String appId){
        List<Facility__c> allChildFac                                       = new List<Facility__c>();
        Facility__c facRec;
        try {
            If(!BMAuthrecommendationIds.isEmpty()){
                for(String bmRecId : BMAuthrecommendationIds){
                    facRec                                                  = new Facility__c(Id=bmRecId,Highest_Authority__c=TRUE);
                    allChildFac.add(facRec);
                }
            }
            if(!allChildFac.isEmpty()) update allChildFac;
            SOQL_Util.createTaskForBM(appId,'BM Recommendation','EME BM Review');
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'markBMAsHighestAuth', e);
        }

    }

    /**
* Method To Reject Exceeding/Adhoc Application
*
* @param appId
*
* @return
*/
    public static string rejectExceedingAdhocHelper(String appId){

        try {
            genesis__Applications__c app                                    = [SELECT Id,Name,Parent_Application__c,Active__c,RecordType.DeveloperName,RecordTypeId,Application_Stage__c,Application_UI_Stage__c from genesis__Applications__c where Id=:appId];
            if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING)
                app.Application_Stage__c                                    = 'Exceeding Application close';
            else if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC)
                app.Application_Stage__c                                    = 'Adhoc Application close';
            update app;
            setOfString.add(app.id);
            User loggedUser                                                 = SanctionUnderwriting_Process.currentUserInfo();
            SanctionUnderwriting_Process.closeTaskForLoggedInUser(loggedUser, appId);
            return 'Application has been rejected';
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'rejectExceedingAdhocHelper', e);
            return 'Some Error Occurred';
        }
    }

    /**
* Method To Reject(rebundle) Enhancement Application
*
* @param appId
*
* @return
*/
    public static string rejectEnhancementHelper(String appId){

        try {
            genesis__Applications__c enhanceApplication                     = [SELECT Id,Name,Parent_Application__c,genesis__Account__r.Name,Active__c,OwnerId,Record_Type_Name__c,RecordTypeId,RecordType.DeveloperName,Application_Stage__c,Application_UI_Stage__c from genesis__Applications__c where Id=:appId];
            genesis__Applications__c appInactive                            =  new genesis__Applications__c();
            String RecordTypeName                                           =  enhanceApplication.Record_Type_Name__c;
            Id devRecordTypeId                                              = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.SME_RECORD_TYPE_LABEL).getRecordTypeId();
            enhanceApplication.RecordTypeId                                 =  devRecordTypeId;
            enhanceApplication.Application_Stage__c                         = 'Application review -with financials';
            enhanceApplication.Application_UI_Stage__c                      = 'Submission';
            enhanceApplication.Type__c                                      = 'Final Sanction';

            If(enhanceApplication.Parent_Application__c !=null){
                appInactive = SME_BRE_Score_Calculator.getDueDatebyAppId(enhanceApplication.Parent_Application__c);
                appInactive.Active__c                                       = false;
            }

            //for send SMS & Email to BM.
            SME_BRE_Score_Calculator.sendSMSForApplicationReject(enhanceApplication,RecordTypeName);

            ApplicationTriggerHandler.IsFirstRun                            = false;
            UPDATE enhanceApplication;
            UPDATE appInactive;
            setOfString.add(enhanceApplication.id);
            User loggedUser                                                 = SanctionUnderwriting_Process.currentUserInfo();
            SanctionUnderwriting_Process.closeTaskForLoggedInUser(loggedUser, appId);
            return 'Application Has been Rejected';
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'rejectEnhancementHelper', e);
            return 'Some Error Occurred';
        }
    }

    /* Controller Class Method */

/**
* Method To Reject(rebundle) Enhancement Application
*
* @param appId
*
* @return
*/
    public static string rejectNewLoanHelper(String appId){

        try {
            genesis__Applications__c newLoanApplication                     = [SELECT Id,Name,Parent_Application__c,genesis__Account__r.Name,Active__c,OwnerId,Record_Type_Name__c,RecordTypeId,RecordType.DeveloperName,Application_Stage__c,Application_UI_Stage__c from genesis__Applications__c where Id=:appId];
            genesis__Applications__c appInactive                            =  new genesis__Applications__c();
            String RecordTypeName                                           =  newLoanApplication.Record_Type_Name__c;
            Id devRecordTypeId                                              = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.SME_RECORD_TYPE_LABEL).getRecordTypeId();
            newLoanApplication.RecordTypeId                                 =  devRecordTypeId;
            newLoanApplication.Application_Stage__c                         = 'New loan - Application rejected';
            newLoanApplication.Sub_Stage__c                                 = 'Rejected by sanction authority';

            If(newLoanApplication.Parent_Application__c !=null){
                appInactive = SME_BRE_Score_Calculator.getDueDatebyAppId(newLoanApplication.Parent_Application__c);
                appInactive.Active__c                                       = false;
            }

            //for send SMS & Email to BM.
            SME_BRE_Score_Calculator.sendSMSForApplicationReject(newLoanApplication,RecordTypeName);

            ApplicationTriggerHandler.IsFirstRun                            = false;
            UPDATE newLoanApplication;
            UPDATE appInactive;
            setOfString.add(newLoanApplication.id);
            User loggedUser                                                 = SanctionUnderwriting_Process.currentUserInfo();
            SanctionUnderwriting_Process.closeTaskForLoggedInUser(loggedUser, appId);
            return 'Application Has been Rejected';
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'rejectEnhancementHelper', e);
            return 'Some Error Occurred';
        }
    }
    

    /**
* Helper Method to calulate Security Coverage for temporary purpose(On BM Reccommendation)
* Just to show "Insufficient Collateral Coveage Pop-up"
* @param applId
* @param savedata
*
* @return
*/
    public static string checkSecurityCoverageHelper(string applId,Underwriting_CTRL.saveWrapper savedata){

        try {

            List<Facility__c> facList                               = [Select id,Product_Category__c,Application__r.Is_Take_Over__c,CL_Product__r.Facility_Category__c,Application__r.Type__c,Application__r.New_to_Business__c,Name,Application__c,Application__r.Parent_Application__c,Application__r.ownerId,Application__r.RecordType.DeveloperName,Application__r.Application_Stage__c,Limit_Amount__c,Existing_Limit__c,Type__c,Application__r.genesis__Account__c,CL_Product__c,Existing_Rate__c,Existing_Processing_Charge__c,Approved_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Recommended_Limit__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c, (select id,genesis__Collateral__c from Facility_Security__r) from Facility__c where Application__c =:applId];

            for(Facility__c f : facList){
                for(Integer fCount = 0; fCount < savedata.facility.size(); fCount++){

                    if(String.valueOf(f.id).left(15) == String.valueOf(savedata.facility[fCount].Facility__c).left(15)){
                        f.Recommended_Limit__c           = savedata.facility[fCount].Recommended_Limit__c;
                        f.Margin__c                      = savedata.facility[fCount].Margin__c;
                    }
                }
            }
            SanctionMatrix_Calculation sanc                         = new SanctionMatrix_Calculation();
            SanctionMatrix_Calculation.COVERAGE_MAP coveragemap     = new SanctionMatrix_Calculation.COVERAGE_MAP();
            if(facList[0].Application__r.Type__c == 'RENEWAL'){
                coveragemap                                             = sanc.calculateAuthority(facList,true,SanctionMatrix_Calculation.ONLY_COVERAGE_METHOD,null);
            }else{
                coveragemap                                             = sanc.calculateAuthority(facList,false,SanctionMatrix_Calculation.ONLY_COVERAGE_METHOD,null);
            }
            system.debug('coveragemap::'+coveragemap);
            if(facList[0].Application__r.RecordType.DeveloperName == 'SME_NEW_Loan' && facList[0].Application__r.New_to_Business__c){
                if(facList[0].Product_Category__c == 'SOD' && coveragemap.CollateralCoverage.get(applId) < 200.00){
                    system.debug('sod:::'+coveragemap.CollateralCoverage.get(applId));
                    return SanctionMatrix_Calculation.INSUFFICIENT_COVERAGE;
                }
                else if(facList[0].Product_Category__c == 'OCC' && coveragemap.CollateralCoverage.get(applId) < 100.00){
                    system.debug('OCC:::'+coveragemap.CollateralCoverage.get(applId));
                    return SanctionMatrix_Calculation.INSUFFICIENT_COVERAGE;
                }
            }
            if(coveragemap.message == SanctionMatrix_Calculation.INSUFFICIENT_COVERAGE ){
                system.debug('inside insufficient coverage:::'+coveragemap.CollateralCoverage.get(applId));
                 return coveragemap.outMsg;
            }
            else{
                system.debug('inside sufficient coverage:::'+coveragemap.CollateralCoverage.get(applId));
                return SanctionMatrix_Calculation.SUFFICIENT_COVERAGE;
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'getEstimatedCoverageHelper', e);
            return 'Some Error Occurred';
        }
    }

    /**
* Method used to send Email/SMS to customer on Various Stgae changes
*/
    public static void sendSMSEmailToCustomer(){
        if(setOfString.size()> 0){
            //SME_SendSMSService.sendSMSApp_SME(setOfString);
        }
    }

    /**
* Method Used to get Term loan Amount. This is useful as it is used for capping Limit amount.
*
* @param appId
* @param custId
*
* @return
*/
    public static Decimal getTermLoanAmount(String appId,String custId){
        try {
            if(appId != null && custId != null){
                appId = appId.left(15);
                custId = custId.left(15);
                Map<String, String> appIdVsCustIdMap                    = new Map<String, String>{appId => custId};
                Map<string, Decimal> appIdVsTermLoanExpoMap             = new Map<String, Decimal>();
                appIdVsTermLoanExpoMap                                  = SanctionMatrix_calculation.getCustTermLoanExposure(appIdVsCustIdMap);
                if(appIdVsTermLoanExpoMap!=null && !appIdVsTermLoanExpoMap.isEmpty()){
                    if(appIdVsTermLoanExpoMap.containsKey(appId) && appIdVsTermLoanExpoMap.get(appId) != null)
                        return appIdVsTermLoanExpoMap.get(appId);
                }
            }
            return 0;

        } catch (Exception e) {
            system.debug('Error ::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return 0;
        }
    }

    /**
* Method to get Limit Capping for Final Authority Role (Capping data is stored in Metadata Records) -> For Enhancement/Adhoc
* Dont't use Exception Class Method as this method is called at page load
*
* @return
*/
    public static Map<String,Decimal> getRoleWiseLimitAmount(){
        try {
            Map<string, Decimal> roleVsLimitMap                             = new Map<String, Decimal>();
            List<Authority_Hierarchy_Level__mdt> roleWiseLimitFromMetaData  = SanctionMatrix_Helper.getAuthorityLevel();
            if(!roleWiseLimitFromMetaData.isEmpty()){
                for(Authority_Hierarchy_Level__mdt metaDataRec : roleWiseLimitFromMetaData)
                    roleVsLimitMap.put(metaDataRec.MasterLabel,metaDataRec.EAE_Limit__c);
            }
            return roleVsLimitMap;
        } catch (Exception e) {
            system.debug('Error ::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return null;
        }

    }
    public static List<Authority_Hierarchy_Level__mdt> getReccomendationCappingDetails(){
        try {
            return  SanctionMatrix_Helper.getAuthorityLevel();

        } catch (Exception e) {
            system.debug('Error ::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return null;
        }

    }

    /**
* Method to get Limit Capping for Final Authority Role (Capping data is stored in Metadata Records) -> For Exceeding
* Dont't use Exception Class Method as this method is called at page load
* @return
*/
    public static Map<String,Decimal> getRoleWiseLimitAmountForExceeding(){
        try {
            Map<string, Decimal> roleVsLimitMap                             = new Map<String, Decimal>();
            List<EAE_Sanction_Matrix__mdt> roleWiseLimitFromMetaData  = [SELECT Role__c,Limit_in_Amount__c,Limit_in_Percentage__c,Order__c,Period_in_days__c,No_of_application_per_year__c FROM EAE_Sanction_Matrix__mdt ];
            if(!roleWiseLimitFromMetaData.isEmpty()){
                for(EAE_Sanction_Matrix__mdt metaDataRec : roleWiseLimitFromMetaData)
                    roleVsLimitMap.put(metaDataRec.Role__c,metaDataRec.Limit_in_Amount__c);
            }
            return roleVsLimitMap;
        } catch (Exception e) {
            system.debug('Error ::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return null;
        }

    }

    /**
* Method to update New Audit Records(When request comes from Front-end to change terms and condition by customer)
* Final Authority gets S&P Terms as editable.
* @param applId
* @param commentList
*
* @return
*/
    public static String updateFinalAuthTermsAndCondition(string applId,List<Audit__c> commentList){
        try {
            List<Audit__c> auditRecordstoBeInserted                 = new List<Audit__c>();
            User loggedInUser                                       = SanctionUnderwriting_Process.currentUserInfo();

            if(!commentList.isEmpty()){
                deleteExistingAuditRecs(applId);
                insert commentList;
                closeExistingTask(applId,'Revise Sanction Terms & Condition');
                updateAppStage(applId);
                return 'Terms and Conditions have been Updated.';

            }
            return 'Some Error Occurred';

        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateFinalAuthTermsAndCondition', e);
            return 'Some Error Occurred';
        }

    }
    public static String updatedeviationApproverTermsAndCondition(string applId,List<Audit__c> commentList){
        try {
            List<Audit__c> auditRecordstoBeInserted                 = new List<Audit__c>();
            User loggedInUser                                       = SanctionUnderwriting_Process.currentUserInfo();

            if(!commentList.isEmpty()){
                deleteExistingAuditRecs(applId);
                insert commentList;
                return 'Terms and Conditions have been Updated.';

            }
            return 'Some Error Occurred';
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updatedeviationApproverTermsAndCondition', e);
            return 'Some Error Occurred';
        }
    }







    /**
* Method to delete Existing Audit Records(When request comes from Front-end to change terms and condition by customer)
* Final Authority gets S&P Terms as editable.
* @param applId
*/
    public static void deleteExistingAuditRecs(string applId){
        try {
            if(applId != null){
                List<Audit__c> commentList = [Select Id,RecordTypeId from Audit__c where Application__c=:applId and RecordTypeId=:auditTCRTypeID];
                if(!commentList.isEmpty()){
                    delete commentList;
                }
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'deleteExistingAuditRecs', e);
        }

    }

    /**
* Helper Method to update AppStage to Final Sanction And final Sanction offered(Method was made because same functionality was required at two places)
*
* @param appId
*/
    public static Boolean checkIfLandAndBuildingOrOtherCollateralExist(String appId){
        try {
            List<genesis__Application_Collateral__c> allAppCollateral       = new List<genesis__Application_Collateral__c>();

            String Land_And_Building_RT                                     = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();
            String Land_And_Building_Other_RT                               = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Buildings - Other').getRecordTypeId();
            allAppCollateral                                                = [SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c=:appId AND (genesis__Collateral__r.RecordTypeId =:Land_And_Building_RT OR genesis__Collateral__r.RecordTypeId=:Land_And_Building_Other_RT)];
            if(allAppCollateral.size() == 0) {
                return false;
            }else{
                return true;
            }

        } catch (Exception e) {
            return false;
        }
    }

    public static Boolean checkIfLandAndBuildingOrOtherCollateralExistNotFECreated(String appId){
        try {
            List<genesis__Application_Collateral__c> allAppCollateral       = new List<genesis__Application_Collateral__c>();

            String Land_And_Building_RT                                     = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();
            String Land_And_Building_Other_RT                               = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Buildings - Other').getRecordTypeId();
            allAppCollateral                                                = [SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c=:appId AND (genesis__Collateral__r.RecordTypeId =:Land_And_Building_RT OR genesis__Collateral__r.RecordTypeId=:Land_And_Building_Other_RT) AND genesis__Collateral__r.FE_Created__c = false];
            if(allAppCollateral.size() == 0) {
                return false;
            }else{
                return true;
            }

        } catch (Exception e) {
            return false;
        }
    }

    public static void updateAppStage(String appId){
        try {
            genesis__Applications__c appRecord ;
            Boolean isMarketValueValid                                      = true;
            List<genesis__Application_Collateral__c> allAppCollateral       = new List<genesis__Application_Collateral__c>();
            String Land_And_Building_RT                                     = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();
            String Land_And_Building_Other_RT  = Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Buildings - Other').getRecordTypeId();

            if(appId != null && appId !=''){
                appRecord                                                   = [SELECT Id,Type__c,Name,Security_coverage__c,Recommended_Security_Coverage__c,RecordType.DeveloperName FROM genesis__Applications__c WHERE Id=:appId];
            }
            allAppCollateral                                                                        =[SELECT Id,genesis__Collateral__r.Collateral_Market_Value__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c=:appId AND (genesis__Collateral__r.RecordTypeId =:Land_And_Building_RT OR genesis__Collateral__r.RecordTypeId=:Land_And_Building_Other_RT)];
            if(allAppCollateral.size() == 0) isMarketValueValid = false;

            if(isMarketValueValid){
                if(appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                    appRecord.Application_Stage__c                          = 'Enhancement- Final sanction';
                    appRecord.Sub_Stage__c                                  = '';
                }
                else if(appRecord.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    appRecord.Application_Stage__c                          = Constants.NEW_LOAN_FINAL_SANCTION;
                    appRecord.Sub_Stage__c                                  = '';
                }

                else if(appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                    appRecord.Application_Stage__c                          = 'Adhoc-Final sanction';
                    appRecord.Sub_Stage__c                                  = '';
                }
                appRecord.MOD_Date__c                                       = null;
                appRecord.All_property_Documents_Uploaded__c                = '';
                appRecord.Sale_Deed_Colleced__c                             = '';
                appRecord.Documents_Uploaded__c                             = false;
                appRecord.MOD_Branch__c                                     = '';
                if((appRecord.Type__c).contains('Takeover') ){
                    SOQL_Util.createTaskForBM(appId,'Complete takeover formalities','Complete takeover formalities');
                }else{
                    //createMODTaskForBm(appId,'MOD Needed','MOD Needed');
                }
            }else{
                if(appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                    appRecord.Application_Stage__c                          = 'Enhancement- Final sanction offered';
                    appRecord.Sub_Stage__c                                  = '';
                }
                else if(appRecord.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    appRecord.Application_Stage__c                          = Constants.NEW_LOAN_FINAL_SANCTION_OFFERED;
                    appRecord.Sub_Stage__c                                  = '';
                }

                else if(appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                    appRecord.Application_Stage__c                          = 'Adhoc- Final sanction offered';
                    appRecord.Sub_Stage__c                                  = '';
                }
            }
            update appRecord;
            if(appRecord.Application_Stage__c == Constants.NEW_LOAN_FINAL_SANCTION_OFFERED && appRecord.Type__c.contains('NTB')){
                List<User> COuserLst=SOQL_Util.getBRCreditOfficer(appId);
                if(COuserLst.size()>0){
                    SOQL_Util.createTaskForBRCreditOfficer(appId,COuserLst[0].Id,'Fill CBS Customer Info','Update CBS Info');

                }else{
                    SOQL_Util.createTaskForBM(appId,'Fill CBS Customer Info','Update CBS Info');
                }
            }

        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateAppStage', e);
        }

    }

    /**
* Method Used To update Limit Amount(When Bm Gives reccomendation) After slider change operation By Customer
*
* @param savedata
*
* @return -> Method called from Underwriting Dashboard for Enhancement/Adhoc
*/
    public static Underwriting_CTRL.ReturnWrap updateLimitAmount(Underwriting_CTRL.saveWrapper savedata){

        Underwriting_CTRL.ReturnWrap wrp                                = new Underwriting_CTRL.ReturnWrap();

        try {
            List<Facility__c> facilities                                = new List<Facility__c>();
            List<genesis__Application_Status_History__c> appHistoryList = new List<genesis__Application_Status_History__c>();
            User loggedInUser                                           = SanctionUnderwriting_Process.currentUserInfo();
            if(savedata.facility.size() > 0){
                for(Integer fCount = 0; fCount < savedata.facility.size(); fCount++){

                    genesis__Application_Status_History__c appHistory   = new genesis__Application_Status_History__c();
                    Facility__c facility                                = new Facility__c();
                    Facility__c parentFacility                          = new Facility__c();
                    facility.Id                                         = savedata.facility[fCount].id;
                    parentFacility.Id                                   = savedata.facility[fCount].Facility__c;

                    if(savedata.facility[fCount].Recommended_Limit__c != null && savedata.facility[fCount].Recommended_Limit__c>=0){

                        facility.Recommended_Limit__c                   = savedata.facility[fCount].Recommended_Limit__c;
                        appHistory.Recommendation_Limit_Rs__c           = savedata.facility[fCount].Recommended_Limit__c;
                        parentFacility.Recommended_Limit__c             = savedata.facility[fCount].Recommended_Limit__c;



                    }
                    appHistory.Facility__c                              = savedata.facility[fCount].CL_Product__c;
                    appHistory.genesis__Application__c                  = savedata.appId;
                    appHistory.User_Role__c                             = savedata.facility[fCount].Role__c;
                    appHistory.User_Name__c                             = loggedInUser.Name;
                    appHistory.Type__c                                  = Constants.RECOMMENDED_CHANGE_TYPE_HISTORY;

                    appHistoryList.add(appHistory);
                    facilities.add(facility);
                    facilities.add(parentFacility);
                }
            }
            if(appHistoryList.size() > 0) insert appHistoryList;
            if(facilities.size()>0) update facilities;

            wrp.message                                                 = 'Limit Amount Has Been Updated';
            closeExistingTask(savedata.appId,'Revise Loan Amount');
            updateAppStage(savedata.appId);

        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateLimitAmount', e);
            wrp.message                                                 = 'Some Error Occurred while updating limit amount';
        }
        return wrp;
    }

    /**
* Method to fetch processing charge values for non-schematic products from the custom setting
*
* @return
*/
    public static Non_Schematic_Processing_Charges__c getNonSchematicProcessingCharges(){
        try {
            return Non_Schematic_Processing_Charges__c.getValues('Non Schematic Processing Charges');
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'getNonSchematicProcessingCharges', e);
            return null;

        }
    }
    public static Boolean getAccountOperationalDataForCurrentYTD(String accountId){
        try {
            if(accountId != null){
                Operations_Detail__c oppData = [Select Id,FIN_CR_AMT__c from Operations_Detail__c where Account__c=:accountId and Fiscal_Year__c=:YearDataConstant.currFiscalYear and Fiscal_Type__c='YTD'];
                if(oppData != null && oppData.FIN_CR_AMT__c != null && oppData.FIN_CR_AMT__c>0)
                    return true;
            }

        } catch (Exception e) {
            System.debug('@@@@@@@'+e.getStackTraceString()+' At '+e.getLineNumber());
        }
        return false;
    }
    public static Boolean getNetSalesForNewSourcing(String accountId){
        try {

            List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();
            List<String> fyList = new List<String>{YearDataConstant.currFiscalYear};
            m68DataList = SOQL_Util.getM68Data(accountId, fyList);
            if(!m68DataList.isEmpty()){
                for(M68_Balance_Sheet_Analysis__c m68Rec:m68DataList){
                    if(m68Rec.Data_Source__c != null && m68Rec.Net_sales__c != null && m68Rec.Net_sales__c >0 && m68Rec.Financial_type__c == 'Actual')
                        return true;

                }
            }

        } catch (Exception e) {

        }
        return false;
    }
    public static Boolean checkIfNewDashboardIsNeeded(String accountId){
        try {
            if(accountId != null){
                return getAccountOperationalDataForCurrentYTD(accountId) ||  getNetSalesForNewSourcing(accountId) ? false:true;
            }
        } catch (Exception e) {

        }
        return null;
    }
    public static string saveProfileDataForNewSourcing(genesis__Applications__c appRecord){
        try {
            if(appRecord != null){
                update appRecord;
            }
            return 'Profile Info has been updated successfully';
        } catch (Exception e) {
            return 'Some error occurred while saving profile information';
        }
    }
    webservice static String runCommercialCibil(String appId){
        try {
            String cbsId                    = [Select Id, Name,genesis__Account__r.CBS_Customer_ID__c from genesis__Applications__c where Id=:appId].genesis__Account__r.CBS_Customer_ID__c;
            System.debug('@@@@@@@@@@@'+cbsId);
            if(cbsId != null && appId != null){
                List<String> listOfCustomerId   = new List<String>{cbsId};
                CommercialPR_EAE_Batch.getCommercialPR_EAE_Request(listOfCustomerId,'SME',appId);

                return 'Commercial Cibil has been fired';
            }else{
                return 'Some error while firing commercial cibil.';
            }

        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'getNonSchematicProcessingCharges', e);
            return 'Some error while firing commercial cibil.';
        }
    }
    //Method for Calculate Processing charge for NTB Type Customer.
    public static Decimal calculateProcessingChargeForNTB(List<Facility__c> listOfFacility){
        Decimal recommended_Limit       = 0.0;
        Decimal recommended_Processing  = 0.0;
        Decimal Processing_Charge       = 0.0;
        try{
            If(listOfFacility !=null && listOfFacility.size() > 0){
                for(Facility__c facObj  :   listOfFacility){
                    if(facObj !=null){
                        if(facObj.Recommended_Limit__c !=null && facObj.Recommended_Processing_Charge__c !=null){
                            Processing_Charge += (facObj.Recommended_Limit__c * facObj.Recommended_Processing_Charge__c/100);
                        }
                    }
                }
            }

            if(Processing_Charge > 0 || Processing_Charge > 0.0){
                System.debug('Processing_Charge'+Processing_Charge);
                return Processing_Charge;
            }
        }catch(Exception ex){
            System.debug('Exception'+ex.getStackTraceString());
        }
        return 0.0 ;
    }
    public static void updateFacilitySpread(String appId){
        try {
            Map<Id,Decimal> faciIdwithValMap = new Map<Id,Decimal>();
            faciIdwithValMap = Underwriting_CTRL_Helper.getFacilityWiseSpreadValues(appId);
            List<Facility__c> facListToUpdate = new List<Facility__c>();
            Facility__c fac;
            System.debug('########'+faciIdwithValMap);
            if(!faciIdwithValMap.isEmpty()){
                for(String facId:faciIdwithValMap.keySet()){
                    fac = new Facility__c(Id=facId,Existing_Spread__c=faciIdwithValMap.get(facId));
                    facListToUpdate.add(fac);

                }
            }
            if(!facListToUpdate.isEmpty()){
                update facListToUpdate;
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'getFacilityWiseSpreadValues', e);
        }

    }

    public static Map<Id,Decimal> getFacilityWiseSpreadValues(String appId){
        try {
            string query                                                                            = 'Select id,Product_Category__c,Application__r.New_to_Business__c,Application__r.Is_Take_Over__c,Application__r.Type__c,Application__r.Parent_Application__c,Name,Application__r.RecordType.DeveloperName,Application__c,Application__r.ownerId,Application__r.Application_Stage__c,Limit_Amount__c,Existing_Limit__c,Type__c,Application__r.genesis__Account__c,CL_Product__c,Existing_Rate__c,Existing_Processing_Charge__c,Approved_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Recommended_Limit__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c'+', (select id,genesis__Collateral__c from Facility_Security__r) from Facility__c where Application__c =:appId';
            List<Facility__c> facList                                                               = Database.query(query);

            SanctionMatrix_Calculation sanc = new SanctionMatrix_Calculation();
            SanctionMatrix_Calculation.COVERAGE_MAP coveragemap = new SanctionMatrix_Calculation.COVERAGE_MAP();
            coveragemap = sanc.calculateAuthority(facList,false,SanctionMatrix_Calculation.ONLY_COVERAGE_METHOD,null);
            System.debug('Exception'+coveragemap);
            if(coveragemap.finalCoverage != null){
                return ROIComputationEAE.computeROI(appId,coveragemap.finalCoverage);
            }
            return null;


        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', '', e);
            return null;
        }

    }

    //Method to check whether BM is Final Authority
    public static Boolean checkIfBMIsFinalAuthority(String applnId){
        try{
            if(applnId !=  null){
                List<Facility__c> facList = [SELECT Id,Name,Application__c,(SELECT Id,Role__c,Highest_Authority__c FROM Facilities__r WHERE Highest_Authority__c = true AND RecordType.DeveloperName = 'Child') FROM Facility__c WHERE Application__c =: applnId AND RecordType.DeveloperName = 'Parent'];
                if(! facList.isEmpty()){
                    for(Facility__c childRec : facList[0].Facilities__r){
                        if((childRec.Role__c).contains('BR_MGR'))
                            return true;
                    }
                }
            }
            return false;
        }catch(Exception e){
            System.debug('Error Message---> ' + e.getMessage());
            return false;
        }
    }
    public static Map<Id,Decimal> facilityWiseMCLRRate(String appId){
        try {
            Map<Id,Decimal> mclrByFacId = new Map<Id, Decimal>();
            for(Facility__c facRecord :[SELECT Id,MCLR_Rate__c from Facility__c where Application__c=:appId And Active__c = true]){
                mclrByFacId.put(facRecord.Id,facRecord.MCLR_Rate__c);
            }
            if(!mclrByFacId.isEmpty()) return mclrByFacId;
            else return mclrByFacId;
        } catch (Exception e) {
            System.debug('Error Message---> ' + e.getMessage());
            return null;
        }
    }

    /**
* Re-Usable Method to check if Open Task Exist given Task subject
*
* @param appId
* @param taskSubject
*
* @return
*/
    public static Boolean checkIFOpenTaskAlreadyExistForRLPC(string appId,String taskSubject) {
        try{
            List<Task> getExistingTaskList;
            getExistingTaskList = [SELECT Id,Subject FROM Task WHERE WhatId=:appId AND Subject=:taskSubject AND Status!='Completed'];
            return getExistingTaskList.size()>0?true:false;
        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIFOpenTaskAlreadyExistForRLPC', e);
            return false;
        }
    }
    public static Decimal getMCLRValuesFromMaster(){
        try {
            Decimal mclrValue =  [Select Id,COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=365.0  Limit 1].MCLR_Of_Interest__c;
            //return 9.55;
            return mclrValue;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'getMCLRValuesFromMaster', e);
            return null;
        }
    }
    webService static void updateBreSpreadAfterBREForRenewal(String appId){
        try {
            // This method will also incorporate values from Product master(Margin And Processing fee)
            Facility__c facInstance;
            Decimal MCLRRate                    = getMCLRValuesFromMaster();
            Map<Id, Decimal> faciIdwithValMap = new Map<Id, Decimal>();
            List<Facility__c> facilitiesToUpdateWithSpread = new List<Facility__c>();
            faciIdwithValMap = Underwriting_CTRL_Helper.getFacilityWiseSpreadValues(appId);

            if (!faciIdwithValMap.isEmpty())
                /*&& applnInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE*/
                for (Id facId : faciIdwithValMap.keySet()) {
                    if (faciIdwithValMap.get(facId) != null)
                        facInstance = new Facility__c(Id = facId, BRE_Spread__c = faciIdwithValMap.get(facId),BRE_Rate__c=faciIdwithValMap.get(facId)+MCLRRate);
                    facilitiesToUpdateWithSpread.add(facInstance);
                }
            if (!facilitiesToUpdateWithSpread.isEmpty()) update facilitiesToUpdateWithSpread;

            // This method will also incorporate values from Product master(Margin And Processing fee)
            updateProductMasterValuesForRenewal(appId);

        }catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateBreSpreadAfterBREForRenewal', e);
            //return null;
        }
    }
    public static void updateProductMasterValuesForRenewal(String appId){
        try {
            String parenttype = 'Parent';

            String queryToFacility = 'select id,Type__c,CL_Product__r.Processing_fee_renwal__c,CL_Product__r.Processing_fee_fresh__c,Application__c, Total_Loan_Amount__c, Balance_Outstandings__c,'+
                    'Over_Due__c, Existing_Spread__c, Recommended_Spread__c, MCLR_Rate__c, Existing_Processing_Charge__c,CL_Product__c, Interest_Type__c,Margin__c,'+
                    'approved_Margin__c, Loan_Purpose__c, Account_Number__c, Limit_Amount__c, Existing_Margin_Receivables__c, '+
                    'Amount_Disbursed__c, Amount_Net_Disbursed__c, Amount_Yet_disbursed__c, Variance__c, recordTypeId,Recommended_Rate__c, '+
                    'Final_Authority_Name__c, Processing_Charge__c, Existing_Rate__c, Existing_Limit__c,'+
                    '(select id, Facility__c, genesis__Collateral__c, Application__c, Security_Type__c from Facility_Security__r),'+
                    'CL_Product__r.Existing_Margin__c,CL_Product__r.Existing_Rate_Commission__c,CL_Product__r.Existing_Margin_Receivables__c,CL_Product__r.Existing_Margin_Stock_Manufacturing__c,CL_Product__r.Existing_Margin_Stock_Trading__c,CL_Product__r.MCLR_Rate__c,'+
                    'existing_Margin_Stock_Manufacturing__c, Existing_Margin_Stock_Trading__c from Facility__c where Recordtype.DeveloperName =: parenttype AND Application__c=:appId';

            List<Facility__c> facility = Database.query(queryToFacility);

            List<Facility__c> facilityList = new List<Facility__c>();

            for(Facility__c faci : facility){
                Facility__c fc = new Facility__c();

                fc.Id           = faci.id;
                if(faci.CL_Product__r.Processing_fee_renwal__c != null){
                    fc.BRE_Processing_Charge__c = faci.CL_Product__r.Processing_fee_renwal__c!=null ? faci.CL_Product__r.Processing_fee_renwal__c : null;

                }
                if(faci.Type__c !='Funded'){
                    fc.BRE_Spread__c = 0.0;
                    fc.BRE_Rate__c = faci.CL_Product__r.Existing_Rate_Commission__c;
                }
                // Filling Margin
                if(faci.CL_Product__r.Existing_Margin__c != null) {
                    fc.BRE_Margin__c = faci.CL_Product__r.Existing_Margin__c;
                }
                // Filling Margin Receivables
                if(faci.CL_Product__r.Existing_Margin_Receivables__c != null){
                    fc.BRE_Margin_Receivables__c = faci.CL_Product__r.Existing_Margin_Receivables__c; //faci.Existing_Margin_Receivables__c;
                }
                // Filling Margin Stock_Manufacturing
                if(faci.CL_Product__r.Existing_Margin_Stock_Manufacturing__c != null){
                    fc.BRE_Margin_Stock_Manufacturing__c =  faci.CL_Product__r.Existing_Margin_Stock_Manufacturing__c;//faci.Existing_Margin_Stock_Manufacturing__c;
                }
                // Filling Margin Stock_Trading
                if(faci.CL_Product__r.Existing_Margin_Stock_Trading__c != null){
                    fc.BRE_Margin_Stock_Trading__c = faci.CL_Product__r.Existing_Margin_Stock_Trading__c; //faci.Existing_Margin_Stock_Trading__c;
                }
                facilityList.add(fc);
            }
            if(! facilityList.isEmpty()) update facilityList;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateProductMasterValuesForRenewal', e);
        }
    }

    public static Boolean substageVerify(String appId){
        try{
            if(checkIfFECollateralExist(appId)){
                String appSubstage = [SELECT Id, Sub_Stage__c FROM genesis__Applications__c WHERE Id =: appId].Sub_Stage__c;
                system.debug('subStage:::'+appSubstage);
                if(appSubstage!= null && appSubstage == 'Legal Clearance Approved'){
                    system.debug('inside if');
                    RETURN true;
                }else{
                    RETURN false;
                }
            }else{
                RETURN true;
            }

        }catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'substageVerify', e);
            RETURN true;
        }
    }

    public static void createRMDTask(String appId){
        try {
            String rmdUser = SMESanction_DocReq.getRMDUserAssign(appId);
            if(rmdUser != null && rmdUser != ''){
               Task rmdTaskInstance = SanctionUnderwriting_Process.getTaskObj(appId,rmdUser,'RMD Review','RMD Review');
                insert rmdTaskInstance; 
            }
            
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createRMDTask', e);
            //RETURN true;
        }
    }
    public static Boolean isUDEnabledForRMD(String appId){
        try {
            User loggedUser = SanctionUnderwriting_Process.currentUserInfo();
            if(loggedUser != null && loggedUser.Designation__c == 'RMD' ){
                if(checkIFOpenTaskAlreadyExist(appId,'RMD Review')){
                    return true;
                }
            }
            return false;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'createRMDTask', e);
            return false;
        }
    }
    public Static String rejectNewLoanByRMDHelper(String appId,String comment){
        try{
            User loggedUser                                                                     = SanctionUnderwriting_Process.currentUserInfo();
            String auditRTypeID                                                                 = Underwriting_CTRL_Helper.auditRTypeID;
            List<genesis__Applications__c> appRecordList                                        = [SELECT Id,Application_Stage__c,Sub_Stage__c FROM genesis__Applications__c WHERE Id =: appId];

            if(comment != null && comment != '' && loggedUser.Id != null){
                Audit__c acomment                                                               = new Audit__c();
                acomment.Sanction_Authority_Comment__c                                          = comment;
                acomment.Application__c                                                         = appId;
                acomment.RecordtypeId                                                           = auditRTypeID;
                acomment.User__c                                                                = loggedUser.Id;
                acomment.Role_Name__c															= loggedUser.Designation__c;
                insert acomment;
            }
            if(appRecordList.size()>0){
                appRecordList[0].Application_Stage__c                                           = 'Application Rejected';
                appRecordList[0].Sub_Stage__c                                                   = 'RMD Rejected';
                ApplicationTriggerHandler.IsFirstRun                                            = false;
                UPDATE appRecordList;
                closeExistingTask(appId,'RMD Review');
                RETURN 'Application has been rejected by RMD';

            }else{
                RETURN 'Some error occured';
            }
        }catch(Exception e){
            HandleBusinessException.captureError('UnderWriting', 'isapplicationRejected',e);
            RETURN 'Some error occured';
        }
    }
    public Static String acceptNewLoanByRMDHelper(String appId,String comment){
        try{
            User loggedUser                                                                     = SanctionUnderwriting_Process.currentUserInfo();
            String auditRTypeID                                                                 = Underwriting_CTRL_Helper.auditRTypeID;
            List<genesis__Applications__c> appRecordList                                        = [SELECT Id,Application_Stage__c,Sub_Stage__c FROM genesis__Applications__c WHERE Id =: appId];

            if(comment != null && comment != '' && loggedUser.Id != null){
                Audit__c acomment                                                               = new Audit__c();
                acomment.Sanction_Authority_Comment__c                                          = comment;
                acomment.Application__c                                                         = appId;
                acomment.RecordtypeId                                                           = auditRTypeID;
                acomment.User__c                                                                = loggedUser.Id;
                acomment.Role_Name__c															= loggedUser.Designation__c;
                insert acomment;
            }
            closeExistingTask(appId,'RMD Review');
            return updateFinalSecurityCoverage(appId,'RMD');
        }catch(Exception e){
            HandleBusinessException.captureError('UnderWriting', 'acceptNewLoanByRMDHelper',e);
            RETURN 'Some error occured';
        }
    }
    public static Boolean isRMDTaskHasBeenDone(String appId){
        try {

            List<Task> getExistingTaskList                                            = new List<Task>();
            getExistingTaskList                                                       = [SELECT Id,Type,Status FROM Task where WhatId=:appId and Type='RMD Review'];

            if(!getExistingTaskList.isEmpty()){
                Boolean isAllRMDTaskCompleted = false;
                for(Task taskRec:getExistingTaskList){
                    if(taskRec.Status =='Completed' ) isAllRMDTaskCompleted = true;
                    else
                            isAllRMDTaskCompleted = false;
                }
                if(isAllRMDTaskCompleted == true){
                    return true;
                }
                else{
                    return false;
                }


            }else{
                return true;
            }

        } catch (Exception e) {
            HandleBusinessException.captureError('UnderWriting', 'isRMDTaskHasBeenDone',e);
            return true;
        }
    }
    public static Decimal getMBFPValue(String appId){
        try {
            if(appId != null){
                Application_AssessmentCtrl.applicationId = appId;
                Application_AssessmentCtrl applicationAssessmentInstance = new Application_AssessmentCtrl();
                applicationAssessmentInstance.calculateFLC_ILCAssessment();
                System.debug('###########'+applicationAssessmentInstance.fundedFacilitiesObj);

                if(applicationAssessmentInstance.fundedFacilitiesObj.smalleritem != null){
                    return applicationAssessmentInstance.fundedFacilitiesObj.smalleritem;
                }
            }

        } catch (Exception e) {
            HandleBusinessException.captureError('UnderWriting', 'getMBFPValue',e);

        }
        return null;
    }
    public static Decimal getLesserValueForNewToCredit(String appId){
        try {
            genesis__Applications__c appRecord = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Id=:appId];
            M68_Balance_Sheet_Analysis__c currentYearM68ActualRecord = getM68DetailByYearAndFiscalType(YearDataConstant.currFiscalYear,'Actual',appRecord.genesis__Account__c);
            Operations_Detail__c currentYearOperationalActualRecord = getOperationDetailByYearAndFiscalType(YearDataConstant.nextEstFiscalYear,'YTD',appRecord.genesis__Account__c);


            Decimal lessofThreeValue = SOQL_Util.getMinMaxDecimal(new List<Decimal>{currentYearOperationalActualRecord.FIN_CR_AMT__c !=null ?currentYearOperationalActualRecord.FIN_CR_AMT__c /4 :0.0,currentYearM68ActualRecord.Net_sales__c != null ? currentYearM68ActualRecord.Net_sales__c/4:0.0,currentYearM68ActualRecord.Total_Net_Worth__c != null ? currentYearM68ActualRecord.Total_Net_Worth__c*5:0.0},'MIN');



            return lessofThreeValue;
        } catch (Exception e) {
            //HandleBusinessException.captureError('UnderWriting', 'getLesserValueForNewToCredit',e);
        }
        return null;
    }
    public Static Operations_Detail__c getOperationDetailByYearAndFiscalType(String year,String fisType,String custId){
        return [SELECT Id,Name,Fiscal_Year__c,Fiscal_Type__c,FIN_CR_AMT__c  from Operations_Detail__c where Account__c=:custId And Fiscal_Year__c=:year And Fiscal_Type__c=:fisType];
    }
    public Static M68_Balance_Sheet_Analysis__c getM68DetailByYearAndFiscalType(String year,String fisType,String custId){
        return [SELECT Id,Name,Fiscal_Year__c,Financial_type__c,Net_sales__c,Total_Net_Worth__c from M68_Balance_Sheet_Analysis__c where Account__c=:custId And Fiscal_Year__c=:year And Financial_type__c=:fisType];
    }

    /* Method to get Total Amount of Credit Summation */
    public static Decimal getTotalAmtOfcreditSummation(String appId){
        try{
            Decimal TotalAmtOfcreditSummation = null;
            genesis__Applications__c appRec;
            if(appId != null){
                appRec = [SELECT Id,Name,genesis__Account__c FROM genesis__Applications__c WHERE Id =: appId AND Active__c = true];
            }
            Operations_Detail__c opDetalRec = Underwriting_CTRL_Helper.getOperationDetailByYearAndFiscalType(YearDataConstant.nextEstFiscalYear,'YTD',appRec.genesis__Account__c);
            return TotalAmtOfcreditSummation = opDetalRec.FIN_CR_AMT__c != null ? (opDetalRec.FIN_CR_AMT__c)/4 : null;
            
        }catch(Exception e){
            return null;
        }
    }
    public static String updateReccomendationValueForDeviationAurhority(Underwriting_CTRL.saveWrapper savedata){
        try {
            User loggedInUser                                           = SanctionUnderwriting_Process.currentUserInfo();
            genesis__Applications__c applnInfo                          = new genesis__Applications__c();
            applnInfo                                                   = Underwriting_CTRL_Helper.getapplnInformation(savedata.appId);
            List<genesis__Application_Status_History__c> appHistoryList = new List<genesis__Application_Status_History__c>();

            List<Facility__c> facilities                                = new List<Facility__c>();

            Boolean isExceedingAdhoc                                    = false;


            if(applnInfo != null){
                if(applnInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                    isExceedingAdhoc = true;
                }
            }
            for(Integer fCount = 0; fCount < savedata.facility.size(); fCount++){
                Facility__c facility                              = new Facility__c();
                Facility__c parentFacility                        = new Facility__c();
                genesis__Application_Status_History__c appHistory = new genesis__Application_Status_History__c();

                facility.Id                                       = savedata.facility[fCount].id;
                parentFacility.Id                                 = savedata.facility[fCount].Facility__c;
                if(savedata.facility[fCount].Recommended_Limit__c != null && savedata.facility[fCount].Recommended_Limit__c >=0){

                    facility.Recommended_Limit__c                 = savedata.facility[fCount].Recommended_Limit__c;
                    appHistory.Recommendation_Limit_Rs__c         = savedata.facility[fCount].Recommended_Limit__c;
                    parentFacility.Recommended_Limit__c           = savedata.facility[fCount].Recommended_Limit__c;

                }
                if(savedata.facility[fCount].Recommended_Rate__c != null && savedata.facility[fCount].Recommended_Rate__c >= 0 ){
                    facility.Recommended_Rate__c                    = savedata.facility[fCount].Recommended_Rate__c;
                    parentFacility.Recommended_Rate__c              = savedata.facility[fCount].Recommended_Rate__c;
                    appHistory.Recommendation_Rate_of_Intrest__c    = savedata.facility[fCount].Recommended_Rate__c;
                }
                if(savedata.facility[fCount].Margin_Receivables__c != null && savedata.facility[fCount].Margin_Receivables__c >= 0){
                    facility.Margin_Receivables__c                              = savedata.facility[fCount].Margin_Receivables__c;
                    parentFacility.Margin_Receivables__c                        = savedata.facility[fCount].Margin_Receivables__c;
                }
                if(savedata.facility[fCount].Recommended_Processing_Charge__c != null && savedata.facility[fCount].Recommended_Processing_Charge__c >= 0 ){
                    facility.Recommended_Processing_Charge__c       = savedata.facility[fCount].Recommended_Processing_Charge__c;
                    parentFacility.Recommended_Processing_Charge__c = savedata.facility[fCount].Recommended_Processing_Charge__c;
                }
                if(savedata.facility[fCount].Margin__c != null && savedata.facility[fCount].Margin__c >= 0){
                    facility.Margin__c                              = savedata.facility[fCount].Margin__c;
                    parentFacility.Margin__c                        = savedata.facility[fCount].Margin__c;
                }
                if(savedata.facility[fCount].Margin_Stock_Manufacturing__c != null && savedata.facility[fCount].Margin_Stock_Manufacturing__c >=0){

                    facility.Margin_Stock_Manufacturing__c          = savedata.facility[fCount].Margin_Stock_Manufacturing__c;
                    parentFacility.Margin_Stock_Manufacturing__c    = savedata.facility[fCount].Margin_Stock_Manufacturing__c;
                }
                if(savedata.facility[fCount].Margin_Stock_Trading__c != null && savedata.facility[fCount].Margin_Stock_Trading__c >= 0){

                    facility.Margin_Stock_Trading__c                = savedata.facility[fCount].Margin_Stock_Trading__c;
                    parentFacility.Margin_Stock_Trading__c          = savedata.facility[fCount].Margin_Stock_Trading__c;
                }
                appHistory.Facility__c                              = savedata.facility[fCount].CL_Product__c;
                appHistory.genesis__Application__c                  = savedata.appId;
                appHistory.User_Role__c                             = savedata.facility[fCount].Role__c;
                appHistory.User_Name__c                             = loggedInUser.Name;
                appHistory.Type__c                                  = Constants.RECOMMENDED_CHANGE_TYPE_HISTORY;
                appHistoryList.add(appHistory);
                facilities.add(facility);
                facilities.add(parentFacility);

            }
            if(facilities.size()>0) update facilities;
            if(appHistoryList.size() > 0) insert appHistoryList;

            return 'Facility values have been updated properly';
        } catch (Exception e) {
            HandleBusinessException.captureError('UnderWriting', 'updateFacilityreccomendationValueFordeviationAurhority',e);
            return null;
        }
    }
    //Method for New to credit.
    public static Decimal getFinalAuthorityRecommedationForNewToCreditType(String appId,List<Facility__c> listOfFacility){
        System.debug('appId @@@'+appId);
        System.debug('listOfFacility @@@'+listOfFacility);
        Decimal returnRecommendedLimit;
        if(appId !=null && appId !='' && listOfFacility !=null && listOfFacility.size()> 0){
            Decimal sumOfRecommendedLimit = 0;
            returnRecommendedLimit = 0;
            try{
                genesis__Applications__c appObj  = [Select id,Name,CustomerID__c,genesis__Account__c from genesis__Applications__c where Id =: appId];
                if(appObj !=null){
                    for(Facility__c facObj  : listOfFacility){
                        if(facObj !=null && facObj.Recommended_Limit__c !=null){
                            sumOfRecommendedLimit += facObj.Recommended_Limit__c;
                        }
                    }
                    System.debug('sumOfRecommendedLimit @@@'+sumOfRecommendedLimit);
                    if(sumOfRecommendedLimit > 0 && sumOfRecommendedLimit < 5000000){
                        Decimal calculateValue = YearDataConstant.getFinalAuthRecomForLessThan_50L(appObj);
                        if(calculateValue !=null && calculateValue > 0 && sumOfRecommendedLimit > calculateValue){
                            returnRecommendedLimit = sumOfRecommendedLimit-calculateValue;
                        }
                    }else if(sumOfRecommendedLimit >= 5000000){
                        Decimal netSalesValue = 0;
                        Decimal calculatedValue = YearDataConstant.getFinalAuthRecomForLessThan_50L(appObj);
                        M68_Balance_Sheet_Analysis__c M68Obj = [Select id,Net_sales__c,Account__c,Financial_type__c,Fiscal_Year__c from M68_Balance_Sheet_Analysis__c where Account__c =:appObj.genesis__Account__c AND Fiscal_Year__c =: YearDataConstant.currFiscalYear AND Financial_type__c = 'Actual' Limit 1];
                        If(M68Obj !=null && M68Obj.Net_sales__c !=null && M68Obj.Net_sales__c > 0 && calculatedValue > 0){
                            Decimal calculateLowestValue = (M68Obj.Net_sales__c * 0.25);
                            if(calculateLowestValue < calculatedValue && calculateLowestValue < sumOfRecommendedLimit){
                                returnRecommendedLimit = (sumOfRecommendedLimit - calculateLowestValue);
                            }else if(calculateLowestValue > calculatedValue && calculatedValue < sumOfRecommendedLimit){
                                returnRecommendedLimit = (sumOfRecommendedLimit - calculatedValue);
                            }
                        }
                   }    
                }
            }catch(Exception ex){
                System.debug('Exception Message'+ ex.getMessage());
                System.debug('Exception '+ ex.getStackTraceString());
            }
        }
        System.debug('returnRecommendedLimit @@@@'+returnRecommendedLimit);
        return returnRecommendedLimit;
    }


}