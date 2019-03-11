/**
 * Created by ET-MARLABS on 07-03-2019.
 */

public with sharing class UDDashboardTaskHelper {

    public static string APP_CURRENT_SATGE;
    public static string APP_PREV_SATGE;

    Public static final String COMMITTE_TASK_SUBJECT                = 'Application Approval Pending';
    Public static final String SANC_OFFICER_TASK_SUBJ               = 'Application Review Pending';
    public static final String ADDITIONAL_CHARGE_STAGE              = 'Additional Charge Required';
    Public static final String ADDITIONAL_CHARGE_TO_BE_CREATED      = 'Additional charge to be created';
    Public static final String DEVIATION_TASK_SUBJECT               = 'Application Deviation Approval Pending';
    Public static final String APPILICATION_REVIEW                  = 'Application Review';
    Public static final String EME_BM_REVIEW                        = 'EME BM Review';
    Public static final String SANCTION_APPROVAL                    = 'Sanction Approval';
    Public static final String DEVIATION_APPROVAL                   = 'Deviation Approval';
    public static final String REFERRED_BACK_TASK_SUBJ              = 'Referred back by previous Authority';
    public static final String REFERRED_BACK_TASK_TYPE              = 'Referred by previous Authority';
    public static final Set<String> COMMITEE_ROLES                  =  new Set<String>{'DOCC','COCC'};
    Public static final String COMMITTEE_REVIEW_MSG                 = 'Application sent for committee review';
    public static final Set<String> TASK_STAGES                     = new Set<String>{APPILICATION_REVIEW,SANCTION_APPROVAL,DEVIATION_APPROVAL,EME_BM_REVIEW,'Pre-disbursement Approval','Referred by previous Authority'};
    public static String applnId = '';

    public static UserInfoWrapper getCurrentUserStatus(String applnId, genesis__Applications__c appInfo, User loggedInUser ){
        UserInfoWrapper uInfo                   = new UserInfoWrapper();
        List<Facility__c> facAuthority          = getFacilityAuthority(applnId);
        List<Task>  mytaskList                  = getUserTaskList(applnId,loggedInUser.Id);
        List<Task>  otherUsertasks              = getOtherAuthTaskList(applnId,loggedInUser.Id);
        uInfo.isPreDisbersementEnabled          = isEveryPreDisbersementBMComplied(applnId);
        uInfo.isBMreviewDone                    = isBMReviewTaskExist(applnId,'Completed','EME BM Review');
        uInfo.isBMreviewPending                 = isBMReviewTaskExist(applnId,'Not Started','EME BM Review');
        uInfo.isSpecialTermsEditable            = isBMReviewTaskExist(applnId,'Not Started','Revise Sanction Terms & Condition');
        uInfo.isSpecialTermsEditableByDeviation = isBMReviewTaskExist(applnId,'Not Started','Deviation Approval');
        uInfo.isLimitEditable                   = isBMReviewTaskExist(applnId,'Not Started','Revise Loan Amount');
        uInfo.isSubmitEnabledForNTB             = isMarketIntelligenceCompleted(applnId);
        uInfo.isConditionRejected               = checkIFOpenTaskAlreadyExist(applnId,'Customer Followup Responded');
        uInfo.isPreDisbersementCountExcceded    = isPreDisburementTaskCountOne(applnId,'Completed') ;
        uInfo.isPreDisbersementOpenTaskExist    = isPreDisburementTaskCountOne(applnId,'Not Completed');
        uInfo.missingPartyMobileList            = checkNullMobNum(applnId);
        uInfo.isBMFinalAuthority                = checkIfBMIsFinalAuthority(applnId);
        uInfo.isUDEditableForRMD                = isUDEnabledForRMD(applnId);
        uInfo.isM121Completed                   = checkIFM121TaskCompleted(applnId);
        uInfo.totalAmtOfCreditSum               = getTotalAmtOfcreditSummation(applnId);
        uInfo.lowestOfThreeValue                = getLesserValueForNewToCredit(applnId);
        uInfo.isSaveOperationDone               = checkIfIsSaveOperationDone(applnId);
        if(appInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)
            uInfo.isNewDashboardNeeded          =  checkIfNewDashboardIsNeeded(applnId);
        else
            uInfo.isNewDashboardNeeded          = false;
        return uInfo;
    }
    
    public static List<Facility__c> getFacilityAuthority(string appId){
        List<Facility__c> childFacilityToBePassed = new List<Facility__c>();
        list<Facility__c> getFacDetailList = new List<Facility__c>();
        map<id,List<Facility__c>> mapOfChildFac =new map<id,List<Facility__c>>();
        getFacDetailList.addAll(getFacilityRecord(appId));
        if(getFacDetailList.size()>0){
            for(Facility__c fac : getFacDetailList){
                if(fac.RecordType.DeveloperName == 'Parent')
                    mapOfChildFac.put(fac.Id, fac.Facilities__r);
                system.debug('mapOfChildFac::'+mapOfChildFac);
            }
        }
        for(String facId : mapOfChildFac.keySet()){
            childFacilityToBePassed.addAll(mapOfChildFac.get(facId));
        }
        if(childFacilityToBePassed.size()>0)
            return childFacilityToBePassed;
        else
        return null;
    }
    
    public static Boolean checkIfBMIsFinalAuthority(String appId){
        List<Facility__c> childFacilityToBePassed = new List<Facility__c>();
        list<Facility__c> getFacDetailList = new List<Facility__c>();
        map<id,List<Facility__c>> mapOfChildFac =new map<id,List<Facility__c>>();
        getFacDetailList.addAll(getFacilityRecord(appId));
        if(getFacDetailList.size()>0){
            for(Facility__c fac : getFacDetailList){
                if(fac.RecordType.DeveloperName == 'Parent')
                    mapOfChildFac.put(fac.Id, fac.Facilities__r);
                system.debug('mapOfChildFac::'+mapOfChildFac);
            }
        }
        for(String facId : mapOfChildFac.keySet()){
            childFacilityToBePassed.addAll(mapOfChildFac.get(facId));
        }
        if(childFacilityToBePassed.size()>0){
            for(Facility__c fac : childFacilityToBePassed){
                if(fac.RecordType.DeveloperName == 'Child' && fac.Highest_Authority__c && (fac.Role__c).contains('BR_MGR'))
                    return true;
            }
        }
        return false;
    }
    
    public static Boolean checkIfIsSaveOperationDone(String appId){
       list<Facility__c> getFacDetailList = new List<Facility__c>();
        getFacDetailList.addAll(getFacilityRecord(appId));
        if(!getFacDetailList.isEmpty() && getFacDetailList[0].Is_Save_Operation_Done__c)
            return true;
        return false;
    }
    
    public static List<String> checkNullMobNum(String appId){
        List<String> nullMobList = new List<String>();
        List<genesis__Application_Parties__c> partyList      = new List<genesis__Application_Parties__c>();
        if(TermLoanModelClass.partyInfoMap.containsKey(appId)){
            partyList = TermLoanModelClass.partyInfoMap.get(appId);
        }else if(!TermLoanModelClass.partyInfoMap.containsKey(appId)){
            TermLoanModelClass.prepareCurrentPartyInfo(appId);
            partyList = TermLoanModelClass.partyInfoMap.get(appId);
        }
        if(!partyList.isEmpty()){
            for(genesis__Application_Parties__c prty : partyList){
                if(prty.genesis__Party_Account_Name__r.PersonMobilePhone == NULL && prty.Active__c == true)
                    nullMobList.add(prty.genesis__Party_Account_Name__r.Name);
            }
        }
        if(!nullMobList.isEmpty())
            return nullMobList;
        else return null;
    }
    
    public static List<task> getUserTaskList(string applnId,string taskOwnerId){
        List<task> taskListToBePassed = new List<task>();
        List<task> taskList = new List<Task>();
        taskList.addAll(getTaskRecord(applnId));
        if(taskList.size()>0){
            for(task tsk : taskList){
                if(tsk.WhatId == applnId && tsk.NonDeletable__c && tsk.OwnerId == taskOwnerId && tsk.Status != 'Completed' && (tsk.Type == 'APPILICATION_REVIEW' || tsk.Type == 'SANCTION_APPROVAL' || tsk.Type == 'DEVIATION_APPROVAL' || tsk.Type == 'EME_BM_REVIEW' || tsk.Type == 'Pre-disbursement Approval' || tsk.Type == 'Referred by previous Authority'))
                  taskListToBePassed.add(tsk);  
            }
        }
        if(taskListToBePassed.size()>0)
            return taskListToBePassed;
        else return null;
    }
    
    public static List<Task> getOtherAuthTaskList(string applnId,string taskOwnerId){
        List<task> taskListToBePassed = new List<task>();
        List<task> taskList = new List<Task>();
        taskList.addAll(getTaskRecord(applnId));
        if(taskList.size()>0){
            for(task tsk : taskList){
                if(tsk.WhatId == applnId && tsk.NonDeletable__c && tsk.OwnerId != taskOwnerId && tsk.Status != 'Completed' && (tsk.Type == 'APPILICATION_REVIEW' || tsk.Type == 'SANCTION_APPROVAL' || tsk.Type == 'DEVIATION_APPROVAL' || tsk.Type == 'EME_BM_REVIEW' || tsk.Type == 'Pre-disbursement Approval' || tsk.Type == 'Referred by previous Authority'))
                  taskListToBePassed.add(tsk);  
            }
        }
        if(taskListToBePassed.size()>0)
            return taskListToBePassed;
        else return null;
    }
    
    public static Boolean isMarketIntelligenceCompleted(String appId){
        genesis__Applications__c genApp = getApplicationRecord(appId);
        boolean isMarket = false;
        List<task> taskList = new List<Task>();
        taskList.addAll(getTaskRecord(appId));
        if(appId != null && appId != '' && taskList.size()>0){
            if(genApp != null){
                if(genApp.Type__c != null && genApp.Type__c.contains('NTB')){
                    for(task tsk : taskList){
                        if(tsk.WhatId == appId && tsk.Type == 'Market Intelligence' && tsk.Status == 'Completed')
                            isMarket = true;
                        return isMarket;
                    }
                }
                else return true;
            } 
        }
        return false;
    }
    
    public static Boolean isBMReviewTaskExist(String appId , String taskstatus,String taskType){
        User loggedInUser = getUserRecord(userInfo.getUserId());
        boolean isTaskExist = false;
        List<task> taskList = new List<Task>();
        taskList.addAll(getTaskRecord(appId));
        
        if(taskList.size()>0){
            if(taskType == 'EME BM Review')
                for(task tsk : taskList){
                    if(tsk.OwnerId == loggedInUser.Id && tsk.whatId == appId && tsk.Status == taskstatus && (tsk.type == taskType || tsk.type == 'Referred by previous Authority' || tsk.type == 'Application Review'))
                        isTaskExist = true;
                }
            else
                for(task tsk : taskList){
                    if(tsk.OwnerId == loggedInUser.Id && tsk.whatId == appId && tsk.Status == taskstatus && tsk.type == taskType)
                        isTaskExist = true;
                }
        }
        return isTaskExist;
    }
    
    public static Boolean isUDEnabledForRMD(String appId){
        User loggedInUser = getUserRecord(userInfo.getUserId());
        if(loggedInUser != null && loggedInUser.Designation__c == 'RMD'){
            if(checkIFOpenTaskAlreadyExist(appId,'RMD Review'))
            return true;
        }
         return false;   
    }
    
    public static Boolean checkIFOpenTaskAlreadyExist(String appId,String taskType){
        boolean isTaskOpen = false;
        List<task> taskList = new List<Task>();
        taskList.addAll(getTaskRecord(appId));
        
        if(taskList.size()>0){
            if(taskType == 'EME BM Review')
                for(task tsk : taskList){
                    if( tsk.whatId == appId && tsk.Status != 'Completed' && (tsk.type == taskType || tsk.type == 'Application Review'))
                        isTaskOpen = true;
                }
            else
                for(task tsk : taskList){
                    if(tsk.whatId == appId && tsk.Status != 'Completed' && tsk.type == taskType)
                        isTaskOpen = true;
                }
            
        }
        return isTaskOpen;
    }
    
    public static Boolean isPreDisburementTaskCountOne(String  appId,String currStatus){
        boolean isTaskCountOne = false;
        List<task> taskList = new List<Task>();
        taskList.addAll(getTaskRecord(appId));
        
        if(taskList.size()>0){
            if(currStatus == 'Completed')
                for(task tsk : taskList){
                    if( tsk.whatId == appId && tsk.Status == 'Completed' && tsk.type == 'Pre-disbursement Approval')
                        isTaskCountOne = true;
                }
            else
                for(task tsk : taskList){
                    if(tsk.whatId == appId && tsk.Status != 'Completed' && tsk.type == 'Pre-disbursement Approval')
                        isTaskCountOne = true;
                }
        }
        return isTaskCountOne;
    }
    
    public static Boolean isEveryPreDisbersementBMComplied(String appId){
        
        List<Audit__c> preDisbursementComments = new List<Audit__c>();
        if(TermLoanModelClass.auditInfoMap.containsKey(applnId)){
            preDisbursementComments                      = getpreDisbursementCommentsAuthorityComment(TermLoanModelClass.auditInfoMap.get(applnId),appId);
        }else if(!TermLoanModelClass.auditInfoMap.containsKey(applnId)){
            TermLoanModelClass.prepareCurrentAuditInfo(applnId);
            preDisbursementComments                      = getpreDisbursementCommentsAuthorityComment(TermLoanModelClass.auditInfoMap.get(applnId),appId);
        }
        // preDisbursementComments                      = getpreDisbursementCommentsAuthorityComment(appId);
        Boolean isEveryPreDisbersementBMComplied                    = true;
        if(!preDisbursementComments.isEmpty()){
            
            for(Audit__c auditRec:preDisbursementComments){
                if(auditRec.Complied__c != null){
                    isEveryPreDisbersementBMComplied                =  auditRec.Complied__c == 'Yes' ? true : false;
                }else{
                    isEveryPreDisbersementBMComplied                =   false;
                }
            }
        }else{
            // what if there is no pre-disbersement comments
            // Still needs to be improvised
            isEveryPreDisbersementBMComplied                        = true;
        }
        return isEveryPreDisbersementBMComplied ;
        
    }
    
    public static Boolean checkIFM121TaskCompleted(String appId){
        List<task> taskList = new List<Task>();
        taskList.addAll(getTaskRecord(appId));
        
        if(taskList.size()>0){
            for(task tsk : taskList){
                if(tsk.whatId == appId && tsk.Status == 'Not Started' && tsk.type == 'M121 A Needed')
                    return true;
                else if(tsk.whatId == appId && tsk.Status == 'Completed' && tsk.type == 'M121 A Needed')
                    return true;
            }
        }
        return false;
    }
    
    public static List<Audit__c> getpreDisbursementCommentsAuthorityComment(List<Audit__c> auditList,String appId){
        list<Audit__c> auditListToBePass = new List<Audit__c>(); 
        if(auditList.size()>0){
            for(Audit__c aud : auditList){
                if(aud.RecordType.DeveloperName == Constants.PREDISBURSEMENT_T_C_RTYPE && aud.Application__c == appId)
                    auditListToBePass.add(aud);  
            }
        }
        if(auditListToBePass.size()>0)
            return auditListToBePass;
        else return null;
    }
    
    public static Decimal getTotalAmtOfcreditSummation(String appId){
        Decimal operationalDetailValue = 0.0;
        Account acc = new Account();
        genesis__Applications__c genApp = getApplicationRecord(appId);
        acc = getAccountRecord(genApp.genesis__Account__c);
        for(Operations_Detail__c operationDet : acc.Operations_Details__r){
            if(operationDet.Fiscal_Year__c == YearDataConstant.nextEstFiscalYear && operationDet.Fiscal_Type__c == 'YTD' && operationDet.Account__c == acc.Id){
                if(operationDet.FIN_CR_AMT__c != null)
                    operationalDetailValue = operationDet.FIN_CR_AMT__c;
            }
        }
        return operationalDetailValue;
    }
    
    public static Boolean checkIfNewDashboardIsNeeded(String appId){
        Account acc = new Account();
        genesis__Applications__c genApp = getApplicationRecord(appId);
        acc = getAccountRecord(genApp.genesis__Account__c);
        
        for(Operations_Detail__c operationDet : acc.Operations_Details__r){
            if(operationDet.Fiscal_Year__c == YearDataConstant.currFiscalYear && operationDet.Fiscal_Type__c == 'YTD' && operationDet.Account__c == acc.Id){
                if(operationDet.FIN_CR_AMT__c != null && operationDet.FIN_CR_AMT__c > 0)
                   return true; 
            }
        }
        for(M68_Balance_Sheet_Analysis__c m68Det : acc.M68_Balance_Sheet_Analysis__r){
            if(m68Det.Fiscal_Year__c == YearDataConstant.currFiscalYear && m68Det.Financial_type__c == 'Actual' && m68Det.Account__c == acc.Id){
               if(m68Det.Data_Source__c != null && m68Det.Net_sales__c != null && m68Det.Net_sales__c >0) 
                	return true;
                
            }
        }
        return false;
    }
    
    public static Decimal getLesserValueForNewToCredit(String appId){
        Decimal operationalDetailValue          = 0.0;
        Decimal m68NetSales  = 0.0;
        Decimal m68totaleWorth=0.0;
        
        Account acc = new Account();
        genesis__Applications__c genApp = getApplicationRecord(appId);
        acc = getAccountRecord(genApp.genesis__Account__c);
        
        for(M68_Balance_Sheet_Analysis__c m68Det : acc.M68_Balance_Sheet_Analysis__r){
            if(m68Det.Fiscal_Year__c == YearDataConstant.currFiscalYear && m68Det.Financial_type__c == 'Actual' && m68Det.Account__c == acc.Id){
               if(m68Det.Net_sales__c != null) 
                	m68NetSales = m68Det.Net_sales__c;
                if(m68Det.Total_Net_Worth__c != null)
                    m68totaleWorth = m68Det.Total_Net_Worth__c;
            }
        }
        for(Operations_Detail__c operationDet : acc.Operations_Details__r){
            if(operationDet.Fiscal_Year__c == YearDataConstant.nextEstFiscalYear && operationDet.Fiscal_Type__c == 'YTD' && operationDet.Account__c == acc.Id){
                if(operationDet.FIN_CR_AMT__c != null)
                    operationalDetailValue = operationDet.FIN_CR_AMT__c;
            }
        }
        return SOQL_Util.getMinMaxDecimal(new List<Decimal>{operationalDetailValue !=null ?operationalDetailValue /4 :0.0,m68NetSales != null ? m68NetSales/4:0.0,m68totaleWorth != null ? m68totaleWorth*5:0.0},'MIN');  
    }
    
    public static list<task> getTaskRecord(String appId){
        if(TermLoanModelClass.taskrecMap.containsKey(appId)){
            return TermLoanModelClass.taskrecMap.get(appId);
        }else if(!TermLoanModelClass.taskrecMap.containsKey(appId)){
            TermLoanModelClass.prepareCurrentTaskInfo(appId);
            return TermLoanModelClass.taskrecMap.get(appId);
        }
        return null;
    }
    
    public static genesis__Applications__c getApplicationRecord(String appId){
        if(TermLoanModelClass.appRecordMap.containsKey(appId)){
            return TermLoanModelClass.appRecordMap.get(appId);
        }
        else if(!TermLoanModelClass.appRecordMap.containsKey(appId)){
            TermLoanModelClass.prepareCurrentApplicationInfo(appId);
            return TermLoanModelClass.appRecordMap.get(appId);
        }
        return null;
    }
    public static account getAccountRecord(String accId){
        if(TermLoanModelClass.accountRecMap.containsKey(accId)){
            return TermLoanModelClass.accountRecMap.get(accId);
        }
        else if(!TermLoanModelClass.accountRecMap.containsKey(accId)){
            TermLoanModelClass.prepareCurrentAccountInfo(accId);
            return TermLoanModelClass.accountRecMap.get(accId);
        }
        return null;
    }
    
    public static List<Facility__c> getFacilityRecord(String appId){
        if(TermLoanModelClass.facilityrecMap.containsKey(appId)){
            return TermLoanModelClass.facilityrecMap.get(appId);
        }else if(!TermLoanModelClass.facilityrecMap.containsKey(appId)){
            TermLoanModelClass.prepareCurrentFacilityInfo(appId);
            return TermLoanModelClass.facilityrecMap.get(appId);
        }
        return null;
    }
    
    public static User getUserRecord(String userId){
        if(TermLoanModelClass.userInfoMap.containsKey(userId)){
            return TermLoanModelClass.userInfoMap.get(userId);
        }else if(!TermLoanModelClass.userInfoMap.containsKey(userId)){
            TermLoanModelClass.prepareCurrentUserInfo(userId);
            return TermLoanModelClass.userInfoMap.get(userId);
        }
        return null;
    }

    public class UserInfoWrapper{
        public boolean isReadOnly                               {get;set;}
        public boolean isFinalAuhtority                         {get;set;}
        public boolean isSanctionApproval                       {get;set;}
        public boolean isPartOfHierarchy                        {get;set;}
        public boolean isBranchRole                             {get;set;}
        public boolean isApplnReadOnly                          {get;set;}
        public boolean isDeviationApprover                      {get;set;}
        public boolean isEmeBMReviewer                          {get;set;}
        public boolean isPreDisbersementEnabled                 {get;set;}
        public boolean isConditionRejected                      {get;set;}
        public boolean isOwner                                  {get;set;}
        public boolean IsReferredBackEnabled                    {get;set;}
        public boolean isPreDisbersementCountExcceded           {get;set;}
        public boolean isPreDisbersementOpenTaskExist           {get;set;}
        public boolean isBMreviewDone                           {get;set;}
        public boolean isBMreviewPending                        {get;set;}
        public boolean isSpecialTermsEditable                   {get;set;}
        public boolean isSpecialTermsEditableByDeviation        {get;set;}
        public boolean isLimitEditable                          {get;set;}
        public boolean isNewDashboardNeeded                     {get;set;}
        public boolean isSubmitEnabledForNTB                    {get;set;}
        public List<String> missingPartyMobileList              {get;set;}
        public boolean isBMFinalAuthority                       {get;set;}
        public boolean isM121Completed                          {get;set;}
        public boolean isSaveOperationDone                      {get;set;}
        public boolean isUDEditableForRMD                       {get;set;}
        public Decimal totalAmtOfCreditSum                      {get;set;}
        public Decimal lowestOfThreeValue                       {get;set;}
        public Decimal newLoanComparableValue                   {get;set;}
        public Decimal mbfpValue                                {get;set;}
        public String checkLessThanOneYearOrMore				{get;set;}


        public UserInfoWrapper(){
            this.isReadOnly                                     = false;
            this.isFinalAuhtority                               = false;
            this.isSanctionApproval                             = false;
            this.isPartOfHierarchy                              = false;
            this.isBranchRole                                   = false;
            this.isApplnReadOnly                                = false;
            this.isDeviationApprover                            = false;
            this.isEmeBMReviewer                                = false;
            this.isPreDisbersementEnabled                       = false;
            this.isConditionRejected                            = false;
            this.isOwner                                        = false;
            this.IsReferredBackEnabled                          = false;
            this.isPreDisbersementCountExcceded                 = false;
            this.isPreDisbersementOpenTaskExist                 = false;
            this.isBMreviewDone                                 = false;
            this.isBMreviewPending                              = false;
            this.isSpecialTermsEditable                         = false;
            this.isSpecialTermsEditableByDeviation              = false;
            this.isLimitEditable                                = false;
            this.isNewDashboardNeeded                           = false;
            this.isSubmitEnabledForNTB                          = false;
            this.missingPartyMobileList                         = new List<String>();
            this.isBMFinalAuthority                             = false;
            this.isM121Completed                                = false;
            this.isSaveOperationDone                            = false;
            this.isUDEditableForRMD                             = false;
            this.totalAmtOfCreditSum                            = 0.00;
            this.lowestOfThreeValue                             = 0.00;
            this.newLoanComparableValue                         = 0.00;
            this.mbfpValue                                      = 0.00;
            this.checkLessThanOneYearOrMore						= '';

        }
    }
}