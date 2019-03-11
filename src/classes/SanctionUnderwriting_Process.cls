/*
* @name         :   SanctionUnderwriting_Process
* @description  :   This class is used for sanction authority 
application review/approval task process and to check logged in 
user status for Underwriting dashboard
* @author       :   Amritesh
*/
public class SanctionUnderwriting_Process {
    
    public static string APP_CURRENT_SATGE;
    public static string APP_PREV_SATGE;
    
    Public static final String COMMITTE_TASK_SUBJECT    = 'Application Approval Pending';
    Public static final String SANC_OFFICER_TASK_SUBJ   = 'Application Review Pending';
    public static final String ADDITIONAL_CHARGE_STAGE  = 'Additional Charge Required';
    Public static final String ADDITIONAL_CHARGE_TO_BE_CREATED      = 'Additional charge to be created';
    Public static final String DEVIATION_TASK_SUBJECT   = 'Application Deviation Approval Pending';
    Public static final String APPILICATION_REVIEW      = 'Application Review';
    Public static final String EME_BM_REVIEW            = 'EME BM Review';
    Public static final String SANCTION_APPROVAL        = 'Sanction Approval';
    Public static final String DEVIATION_APPROVAL       = 'Deviation Approval';
    public static final String REFERRED_BACK_TASK_SUBJ  = 'Referred back by previous Authority';
    public static final String REFERRED_BACK_TASK_TYPE  = 'Referred by previous Authority';
    public static final Set<String> COMMITEE_ROLES      =  new Set<String>{'DOCC','COCC'};
    Public static final String COMMITTEE_REVIEW_MSG     = 'Application sent for committee review';
    public static final Set<String> TASK_STAGES         = new Set<String>{APPILICATION_REVIEW,SANCTION_APPROVAL,DEVIATION_APPROVAL,EME_BM_REVIEW,'Pre-disbursement Approval','Referred by previous Authority'};
    public static String applnId = '';

    public static Boolean checkIfOpenTaskExist(String appId, String taskownerId){
        try{
            List<Task> getExistingTaskList;
            if(appId != null && taskownerId != null){
                getExistingTaskList = [SELECT Id,OwnerId,Status,WhatId FROM Task WHERE WhatId=:appId AND OwnerId =: taskownerId AND Status != 'Completed'];
            }
            if(getExistingTaskList.size()>0){
                System.debug('Task already exist');
                return TRUE;
            }
            else{
                System.debug('Task does not exist');
                return FALSE;
            }
        }catch(Exception e){
            return FALSE;
        }
    }
    
    public static string createTaskForNextAuthority(string applId, boolean deviatiated){
        
        List<Facility__c> facAuthority  = getFacilityAuthority(applId);
        boolean isFinalAuthority        = false;
        integer fCount                  = facAuthority.size();
        integer nextAuhtCount           = 0;
        string role                     = '';
        User loggedUser = currentUserInfo();
        List<genesis__Applications__c> appRec = SOQL_Util.getApplication(new Set<Id>{applId});
        
        for(Facility__c f : facAuthority){
            if(f.role__C    == loggedUser.Designation__c){
                nextAuhtCount = integer.valueof(f.Higher_Authority_Order__c) + 1;
                break;
            }
        }
        System.debug('@@'+nextAuhtCount);
        if(nextAuhtCount <= facAuthority.size()){
            integer index = nextAuhtCount - 1;
            role    = facAuthority[index].Role__c;
            System.debug('## ' + role);
            if(facAuthority[index].Highest_Authority__c){
                system.debug('### '+ facAuthority[index].Highest_Authority__c);
                isFinalAuthority    = true;
            }
        }
        System.debug('@@'+nextAuhtCount);
        List<User> authUser  = new List<User>();
        System.debug('##--> ' + role);
        if(role != null && role != '' && isFinalAuthority && COMMITEE_ROLES.contains(role) && !Underwriting_CTRL_Helper.isExceedingAdhoc(applId)){
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2');
            getCommitteMemebers(loggedUser.Division, applId, role);
        }else{
            if(role != null && role != ''){
                System.debug('@@ '+ role +' '+loggedUser.Division);
                if(role.contains('CO') || role.contains('President') || role=='RMD'){
                    if(role=='RMD'){
                        applnId = applId;
                        authUser = getUserRecord('RMD', 'Central Office');
                    }
                    else{
                        authUser = getUserRecord(role, null);
                    }
                } 
                else{
                    System.debug('@@ '+ role +' '+loggedUser.Division);
                    authUser = getUserRecord(role, loggedUser.Division);
                    System.debug('$$$$ ' + authuser.size());
                }
                
                if(authUser.size() > 0){
                    string taskSubj = '';
                    string taskType = '';
                    if(deviatiated){
                        taskSubj    = DEVIATION_TASK_SUBJECT;
                        if(Underwriting_CTRL_Helper.deviationReason != '')
                            taskSubj += '('+Underwriting_CTRL_Helper.deviationReason.removeEnd(';')+')';
                        taskType    = DEVIATION_APPROVAL;
                    }else{
                        taskSubj    = SANC_OFFICER_TASK_SUBJ;
                        taskType    = APPILICATION_REVIEW;
                    }
                    
                    if(! checkIfOpenTaskExist(applId,authUser[0].Id) && appRec != null && appRec[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE){
                        createTaskforOtherAuthority(getTaskObj(applId,authUser[0].Id,taskSubj,taskType));
                    }
                }
            }
        }
        return role;
    }
    public static boolean checkIfRefferedByFinalAuthToBM(string applId){
        try {
            genesis__Applications__c app = [SELECT Id,Name,Parent_Application__c,Active__c,RecordType.DeveloperName,RecordTypeId,Application_Stage__c,Application_UI_Stage__c from genesis__Applications__c where Id=:applId];
            List<Audit__c> preDisbursementComments                      = getpreDisbursementCommentsAuthorityComment(applId);
            if(isEveryPreDisbersementBMComplied(applId)) return false;
            if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC  || app.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                List<Facility__c> facAuthority  = getFacilityAuthority(applId);
                User loggedUser = currentUserInfo();
                for(Facility__c f : facAuthority) {
                    if (f.role__C == loggedUser.Designation__c && f.Highest_Authority__c && preDisbursementComments.size()>0) {
                        if(applId != null)closeTaskForLoggedInUser(loggedUser, applId);
                        return true;
                        
                    }
                }
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }
    public static string refferBackTOBMForPreDis(String appId){
        try {
            SOQL_Util.createTaskForBM(appId,'Submit compliance for Pre-disbursement','Pre-disbursement Approval');
            return 'Task has been cretaed for BM';
        } catch (Exception e) {
            system.debug('Error ::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return 'Error ::::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber();
        }
    }
    public static string createTaskForPreviousAuthority(string applId){
        try {
            if(checkIfRefferedByFinalAuthToBM(applId)){
                return refferBackTOBMForPreDis(applId);
            }
            System.debug('applId:: '+applId);
            List<Facility__c> facAuthority  =  getFacilityAuthority(applId);
            List<Task> taskList = new List<Task>();
            //boolean isFinalAuthority        = false;
            System.debug('@@ '+facAuthority.size());
            integer fCount                  = facAuthority.size();
            integer prevAuhtCount           = 0;
            string role                     = '';
            User loggedUser = currentUserInfo();
            
            for(Facility__c f : facAuthority){
                if(f.role__C    == loggedUser.Designation__c){
                    prevAuhtCount = integer.valueof(f.Higher_Authority_Order__c) - 1;
                    system.debug('## ' +prevAuhtCount);
                    break;
                }
            }
            if(facAuthority.size() > 0){
                integer index = prevAuhtCount - 1;
                role    = facAuthority[index].Role__c;
                System.debug('$$ '+role);
            }
            taskList = [SELECT Id,Subject,WhatId,Designation__c,OwnerId FROM Task WHERE WhatId =: applId AND Designation__c =: role LIMIT 1];
            System.debug('WhatId '+taskList[0].WhatId);
            System.debug('taskList:: '+taskList.size());
            System.debug('Designation:: '+ taskList[0].Designation__c);
            if(taskList.size() > 0){
                String taskSubj    = REFERRED_BACK_TASK_SUBJ;
                string taskType    = REFERRED_BACK_TASK_TYPE;
                System.debug('OwnerId--> '+taskList[0].OwnerId);
                if(! checkIfOpenTaskExist(applId,taskList[0].OwnerId)){
                    System.debug('Designation:: '+ taskList[0].OwnerId);
                    createTaskforOtherAuthority(getTaskObj(applId,taskList[0].OwnerId,taskSubj,taskType));
                }
            }
            if(applId != null)closeTaskForLoggedInUser(loggedUser, applId);
            return 'Task has been cretaed for previous authority';
        } catch (Exception e) {
            System.debug('@@@@@'+e.getMessage()+' AT '+e.getLineNumber()+' StackTrace '+ e.getStackTraceString());
            return e.getMessage()+' AT '+e.getLineNumber()+' StackTrace '+ e.getStackTraceString();
        }
    }
    
    
    // Get User record by Designation
    public static List<User> getUserRecord(String designation, string division){
        if(designation == 'RMD'){
            String userId_RMD = SMESanction_DocReq.getRMDUserAssign(applnId);
            return [Select id,Designation__c,IsActive from user where Id =:userId_RMD];
        }
        else if(division != null)
            return [Select id,Designation__c,IsActive from user where IsActive=true AND Designation__c =:designation AND Division =:division  limit 1];
        else
            return [Select id,Designation__c,IsActive from user where IsActive=true AND Designation__c =:designation limit 1];
    }
    
    // Get DOCC/COCC Committe Member details for Sanction Approval Task Creation
    public static void getCommitteMemebers(String division, string applId, string committeFor){
        System.debug('LLLLLLLLLL'+division);// CHENNAI
        System.debug('LLLLLLLLLL'+committeFor);// DOCC
        List<genesis__Committee_Member__c> committeMembers  = new List<genesis__Committee_Member__c>();
        string query    = 'Select id,genesis__Meeting_Schedule__c,Name,genesis__User__c,genesis__User__r.Name,genesis__Role__c,genesis__User__r.Designation__c from genesis__Committee_Member__c'+' ';
        query           += 'where genesis__Meeting_Schedule__r.Sanction_Committe_For__c =:committeFor ';
        if(committeFor == 'DOCC' && division != null){
            query   += 'AND genesis__Meeting_Schedule__r.Division__c =:division';
        }
        query   += ' AND genesis__Meeting_Schedule__r.genesis__Status__c =\'New\'';
        system.debug('query::'+query);
        committeMembers = Database.query(query);
        System.debug('######'+committeMembers);
        
        genesis__Applications__c applDetails = [SELECT Id,OwnerId FROM genesis__Applications__c WHERE Id =:applId LIMIT 1];
        
        if(committeMembers.size() > 0){
            createTaskforCommitteMember(committeMembers,applId);
            genesis__Applications__c appl   = new genesis__Applications__c();
            appl.Id                         = applId;
            appl.Committe__c                = committeMembers[0].genesis__Meeting_Schedule__c;
            ApplicationTriggerHandler.IsFirstRun = false;
            update appl; // update committe info on Application
            
            try{
                List<genesis__Applications__share> applShareList = new List<genesis__Applications__share>();
                if(applDetails != null){
                    for(genesis__Committee_Member__c committeMem : committeMembers){
                        if(committeMem.genesis__User__c != null && committeMem.genesis__User__c != applDetails.OwnerId && committeMem.genesis__User__r.Designation__c.contains('BR')){
                            genesis__Applications__share applShareInstance  = new genesis__Applications__share();
                            applShareInstance.ParentId                               = applId;
                            applShareInstance.UserOrGroupId                          = committeMem.genesis__User__c;
                            applShareInstance.RowCause                               = Schema.AccountShare.RowCause.Manual;
                            applShareInstance.AccessLevel                            = 'Edit';
                            applShareList.add(applShareInstance);
                        }
                    }
                    
                    if(!applShareList.isEmpty()){
                        Database.insert(applShareList,false);
                    }
                }
            }catch(Exception e){
                System.debug('Exception '+e.getMessage()+'occured at line number '+e.getLineNumber());
            }
        }
    }
    
    // Create Task for Indiviual User
    public static void createTaskforOtherAuthority(Task individualTask){
        System.debug('@@@'+individualTask);
        TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
        if(APP_CURRENT_SATGE != null && APP_CURRENT_SATGE != ''){
            individualTask.Application_Stage__c     = APP_CURRENT_SATGE;
        }
        if(APP_PREV_SATGE != null && APP_PREV_SATGE != '')individualTask.Application_Previous_Stage__c = APP_PREV_SATGE;
        insert individualTask;
        System.debug('@@@'+individualTask.Id);
    }
    
    // Create Task for each Committe Memeber
    public static void createTaskforCommitteMember(List<genesis__Committee_Member__c> committeMembers,String applnId){
        List<Task> taskToInsert = new List<Task>();
        for(genesis__Committee_Member__c cm : committeMembers){
            Task newTask                    = getTaskObj(applnId, cm.genesis__User__c,COMMITTE_TASK_SUBJECT,SANCTION_APPROVAL);
            newTask.Application_Stage__c    = APP_CURRENT_SATGE;
            if(APP_PREV_SATGE != null && APP_PREV_SATGE != '')newTask.Application_Previous_Stage__c = APP_PREV_SATGE;
            taskToInsert.add(newTask);
        }
        TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
        insert taskToInsert;
    }
    
    // Return task object
    public static Task getTaskObj(String parentId, string taskOwner, string taskSubject, string taskType){
        return new Task(WhatId=parentId,Subject=taskSubject,OwnerId=taskOwner,NonDeletable__c=true,ActivityDate=System.today()+2,Type=taskType);
    }
    
    public static UserInfoWrapper getCurrentUserStatus(String applnId, genesis__Applications__c appInfo, User loggedInUser ){
        UserInfoWrapper uInfo           = new UserInfoWrapper();
        List<Facility__c> facAuthority  = getFacilityAuthority(applnId);
        List<Task>  mytaskList          = getUserTaskList(applnId,loggedInUser.Id);
        List<Task>  otherUsertasks      = getOtherAuthTaskList(applnId,loggedInUser.Id);
        uInfo.isPreDisbersementEnabled  = isEveryPreDisbersementBMComplied(applnId);
        uInfo.isBMreviewDone            = isBMReviewTaskExist(applnId,'Completed','EME BM Review');
        uInfo.isBMreviewPending         =  isBMReviewTaskExist(applnId,'Not Started','EME BM Review');
        uInfo.isSpecialTermsEditable    =  isBMReviewTaskExist(applnId,'Not Started','Revise Sanction Terms & Condition');
        uInfo.isSpecialTermsEditableByDeviation = isBMReviewTaskExist(applnId,'Not Started','Deviation Approval');
        uInfo.isLimitEditable           =  isBMReviewTaskExist(applnId,'Not Started','Revise Loan Amount');
        
        uInfo.isSubmitEnabledForNTB     = YearDataConstant.isMarketIntelligenceCompleted(applnId);
        uInfo.isConditionRejected       = Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(applnId,'Customer Followup Responded');
        uInfo.isPreDisbersementCountExcceded =Underwriting_CTRL_Helper.isPreDisburementTaskCountOne(applnId,'Completed') != null ? Underwriting_CTRL_Helper.isPreDisburementTaskCountOne(applnId,'Completed'):false;
        uInfo.isPreDisbersementOpenTaskExist =Underwriting_CTRL_Helper.isPreDisburementTaskCountOne(applnId,'Not Completed') != null ? Underwriting_CTRL_Helper.isPreDisburementTaskCountOne(applnId,'Not Completed'):false;
        uInfo.missingPartyMobileList    = SOQL_Util.checkNullMobNum(applnId);
        uInfo.isBMFinalAuthority        = Underwriting_CTRL_Helper.checkIfBMIsFinalAuthority(applnId);
        uInfo.isM121Completed           = Underwriting_CTRL_Helper.checkIFM121TaskCompleted(applnId);
        uInfo.isUDEditableForRMD        = Underwriting_CTRL_Helper.isUDEnabledForRMD(applnId);
        uInfo.totalAmtOfCreditSum       = Underwriting_CTRL_Helper.getTotalAmtOfcreditSummation(applnId);
        uInfo.lowestOfThreeValue        = Underwriting_CTRL_Helper.getLesserValueForNewToCredit(applnId);
        uInfo.isSaveOperationDone       = checkIfIsSaveOperationDone(applnId);
        if(appInfo.New_to_Business__c){
            if(Application_AssessmentCtrl.calculateFinancialOneYear(appInfo.genesis__Account__r.Date_of_Incorporation__c)){
                Application_AssessmentCtrl.calculateLimitAssessmentForNTB(appInfo.genesis__Account__r.Id,applnId,appInfo.genesis__Account__r.Date_of_Incorporation__c);
                uInfo.mbfpValue                 = Application_AssessmentCtrl.newLoanMBFPValue;
                uInfo.checkLessThanOneYearOrMore = 'Greater Than One Year';
            }else{
                Application_AssessmentCtrl obj = new Application_AssessmentCtrl();
                uInfo.mbfpValue = Application_AssessmentCtrl.itemAB;
                uInfo.checkLessThanOneYearOrMore = 'less Than One Year';
            }
        }else{
            Application_AssessmentCtrl.calculateLimitAssessmentForNTC(appInfo.genesis__Account__r.Id,applnId);
            System.debug('#####'+Application_AssessmentCtrl.newLoanMBFPValue);
            uInfo.mbfpValue                 = Application_AssessmentCtrl.newLoanMBFPValue;
        }
        if(appInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)
            uInfo.isNewDashboardNeeded      =  Underwriting_CTRL_Helper.checkIfNewDashboardIsNeeded(appInfo.genesis__Account__r.Id);
        else
            uInfo.isNewDashboardNeeded  = false;
        boolean committeTaskDone        = false;
        System.debug('######'+mytaskList);
        System.debug('#####'+otherUsertasks);
        if(facAuthority.size() == 0) return uInfo;
        
        if(appInfo.OwnerId  == loggedInUser.Id){
            uInfo.isOwner = true;
            System.debug('##### inside if');
            if(loggedInUser.Designation__c.contains('BR')){
                if(mytaskList.size() > 0 && otherUsertasks.size() == 0){
                    uInfo.isBranchRole = true;
                    uInfo.isEmeBMReviewer = true;
                    System.debug('##### inside if');
                }
            }
            System.debug('##### inside if');
            uInfo.isReadOnly    = false;
            for(Facility__c f : facAuthority){
                System.debug('##### inside if');
                if(f.role__C    == loggedInUser.Designation__c){
                    System.debug('##### inside if');
                    if((mytaskList.size() > 0 && otherUsertasks.size() == 0) && f.Highest_Authority__c){
                        System.debug('##### inside if');
                        uInfo.isFinalAuhtority  = true;
                        break;
                    }
                }
            }
        }else{
            boolean otherUser   = false;
            for(Facility__c f : facAuthority){
                
                System.debug('##### inside if'+f);
                System.debug('$$$$$$$$$$$'+mytaskList.size());
                if(f.role__C    == loggedInUser.Designation__c && !(loggedInUser.Designation__c).contains('BR_MGR')){
                    System.debug('##### inside if');
                    if(f.Is_Referred_Back_Enabled__c){
                        System.debug('##### inside if');
                        uInfo.IsReferredBackEnabled =  true;
                    }
                    otherUser   = true;
                    if(f.Highest_Authority__c){
                        System.debug('##### inside if');
                        if(mytaskList.size() > 0){
                            System.debug('##### inside if');
                            uInfo.isFinalAuhtority  = true;
                        }
                        break;
                    }else{
                        System.debug('##### inside if');
                        System.debug('##### inside if'+f);
                        if(f.Read_Only_User__c){
                            if(mytaskList.size() > 0){
                                System.debug('##### inside if');
                                uInfo.isReadOnly    = true;
                                /*if(f.Deviation_Approver__c){
System.debug('##### inside if');
uInfo.isDeviationApprover = true;
}*/
                                break;
                            }
                        }
                        else if(f.Deviation_Approver__c){
                            if(mytaskList.size() > 0){
                                System.debug('##### inside if');
                                if(f.Deviation_Approver__c){
                                    System.debug('##### inside if');
                                    uInfo.isDeviationApprover = true;
                                }
                                break;
                            }
                        }
                        else{
                            uInfo.isPartOfHierarchy = true;
                        }
                    }
                }
            }
            if(!otherUser){
                if(mytaskList.size()>0){
                    System.debug('#####');
                    uInfo.isSanctionApproval    = true;
                }
            }else{
                if(mytaskList.size()>0){
                    for(Task taskrec:mytaskList){
                        if(taskrec.OwnerId == loggedInUser.Id && taskrec.Type == 'Sanction Approval'){
                            System.debug('#####');
                            uInfo.isSanctionApproval    = true;
                        }
                    }
                }
            }
        }
        System.debug('#####'+uInfo);
        return uInfo;
    }
    public static Boolean isEveryPreDisbersementBMComplied(String appId){
        
        
        List<Audit__c> preDisbursementComments                      = getpreDisbursementCommentsAuthorityComment(appId);
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
    public static List<Audit__c> getpreDisbursementCommentsAuthorityComment(string appId){
        return [select User__c,User__r.Name,Complied__c,Sanction_Authority_Comment__c,Application__c,Terms_and_Conditions__c,
                RecordType.DeveloperName from Audit__c where (RecordType.DeveloperName =:Constants.PREDISBURSEMENT_T_C_RTYPE ) AND Application__c =:appId];
    }
    public static List<Task> getUserTaskList(string applnId,string taskOwnerId){
        return [Select id,OwnerId,Type,Status,Application_Stage__c,Application_Previous_Stage__c from Task
                where WhatId =:applnId AND nondeletable__c =true
                AND (OwnerID =:taskOwnerId AND Type IN:TASK_STAGES) AND Status != 'Completed'];
    }
    
    public static List<Task> getOtherAuthTaskList(string applnId,string taskOwnerId){
        return [Select id,OwnerId,Status,Application_Stage__c from Task
                where WhatId =:applnId AND nondeletable__c =true
                AND (OwnerID !=:taskOwnerId AND Type IN:TASK_STAGES) AND Status != 'Completed'];
    }
    
    public static List<Facility__c> getFacilityAuthority(string appId){
        List<Facility__c> facilityList          = new List<Facility__c>();
        List<Facility__c> authorityFacilities   = new List<Facility__c>();
        
        authorityFacilities                     = [Select id,(Select id,Facility__c,Facility__r.Application__c,Role__c,Deviation_Approver__c,
                                                              Highest_Authority__c,Is_Referred_Back_Enabled__c,Read_Only_User__c,Higher_Authority_Order__c from Facilities__r
                                                              where Facility__r.Application__c =:appId AND RecordType.DeveloperName ='Child' order by Higher_Authority_Order__c asc)
                                                   from Facility__c where Active__c = true AND Application__c =:appId AND RecordType.DeveloperName ='Parent' limit 1];
        
        if(authorityFacilities.size() > 0) facilityList = authorityFacilities[0].Facilities__r;
        return facilityList;
    }
    public static List<Facility__c> getFacilityAuthorityForAllfacility(string appId){
        
        List<Facility__c> authorityFacilities   = new List<Facility__c>();
        
        authorityFacilities                     = [Select id,Is_Save_Operation_Done__c,(Select id,Facility__c,Is_Referred_Back_Enabled__c,Facility__r.Application__c,Role__c,Deviation_Approver__c,
                                                              Highest_Authority__c,Read_Only_User__c,Higher_Authority_Order__c from Facilities__r
                                                              where Facility__r.Application__c =:appId AND RecordType.DeveloperName ='Child' order by Higher_Authority_Order__c asc)
                                                   from Facility__c where Active__c = true AND Application__c =:appId AND RecordType.DeveloperName ='Parent' limit 1];
        
        if(authorityFacilities.size() > 0)
            return authorityFacilities;
        else
            return  null;
    }
    
    public static Map<Id,Facility__c> getExistingAuthorityLevel(String appId){
        
        try {
            
            
            Map<Id, Facility__c> parentVsChildFacility = new Map<Id, Facility__c>();
            
            List<Facility__c> authorityFacilities = new List<Facility__c>();
            authorityFacilities = getFacilityAuthorityForAllfacility(appId);
            
            if (authorityFacilities.size() > 0) {
                
                for (Facility__c facilityRec : authorityFacilities) {
                    /*if(facilityRec.Highest_Authority__c)
idVsFacility.put(Integer.valueOf(facilityRec.Higher_Authority_Order__c), facilityRec);*/
                    for(Facility__c faclityChild:facilityRec.Facilities__r){
                        
                        if(faclityChild.Highest_Authority__c)
                            parentVsChildFacility.put(facilityRec.Id, faclityChild);
                    }
                }
            }
            if (!parentVsChildFacility.isEmpty()) {
                return parentVsChildFacility;
            } else {
                return null;
            }
        }catch(Exception e){
            System.debug('Error: ' +e.getMessage() +' AT '+e.getLineNumber());
            return null;
        }
        
    }
    
    /**
* Makes Task Status as completed
* @param loggedInUser :Information of the logged in user
* @param applId       :Application to which the task has been assigned
*
*/
    public static void closeTaskForLoggedInUser(User loggedInUser, String applId){
        System.debug('@@aaaaa');
        System.debug('@@aaaaa'+loggedInUser.Id);
        System.debug('@@aaaaa'+applId);
        List<Task> taskList =  [SELECT Id,WhatId,WhoId,Status
        FROM Task
        WHERE OwnerId =:loggedInUser.Id
        AND whatId =:applId
        AND Status != 'Completed' ];
        System.debug('@@'+taskList);
        if(!taskList.isEmpty()){
            System.debug('@@'+taskList);
            for(Task taskRecord : taskList){
                System.debug('@@'+taskRecord);
                //taskRecord.Status = 'Completed';
                taskRecord.Status = 'Closed';
            }
            UPDATE taskList;
        }
    }
    public static Boolean isBMReviewTaskExist(String appId , String taskstatus,String taskType){
        User loggedInUser = currentUserInfo();
        try{
            List<Task> taskList = new List<Task>();
            if(taskType == 'EME BM Review')
                taskList =  [SELECT Id,WhatId,WhoId,Status FROM Task WHERE OwnerId =:loggedInUser.Id AND whatId =:appId AND Status =:taskstatus And (type=:taskType OR type='Referred by previous Authority' OR type='Application Review')];
            else taskList =  [SELECT Id,WhatId,WhoId,Status FROM Task WHERE OwnerId =:loggedInUser.Id AND whatId =:appId AND Status =:taskstatus And type=:taskType ];
            
            return taskList.size()>0?true:false;
        }catch (Exception e){
            return null;
        }
        
    }
    
    public static User currentUserInfo(){
        return [Select id,Designation__c,Division,Name from User where Id=:userInfo.getUserId()];
    }
    
    public static boolean checkMemberApproved(string appId, String committeId){
        
        boolean status          = false;
        List<String>  userIds   = getCommitteMemberIds(committeId);
        if(userIds.size() > 0){
            List<Task> memberTasks  = new List<Task>([Select id,Status,Approval_Status__c,NonDeletable__c
                                                      from Task
                                                      where OwnerId IN :userIds AND WhatID =:appId
                                                      AND NonDeletable__c =true AND Type =:SANCTION_APPROVAL]);
            if(memberTasks.size() > 0){
                integer count = 0;
                for(Task t : memberTasks){
                    if(t.Status == 'Completed' && t.Approval_Status__c == 'Approved'){
                        count++;
                    }
                }
                if(memberTasks.size() == count){
                    status  = true;
                }
            }
        }
        return status;
    }
    
    public static List<String> getCommitteMemberIds(String committeId){
        List<String> userIds                                = new List<String>();
        List<genesis__Committee_Member__c> committeMembers  = new List<genesis__Committee_Member__c>();
        committeMembers     = [Select id,genesis__Meeting_Schedule__c,Name,genesis__User__c,genesis__User__r.Name,genesis__Role__c
                               from genesis__Committee_Member__c
                               where genesis__Meeting_Schedule__c =:committeId];
        for(genesis__Committee_Member__c c : committeMembers){
            if(c.genesis__User__c != null) userIds.add(c.genesis__User__c);
        }
        return userIds;
    }
    
    public static String gethighestRole(Set<String> rolelist, List<Authority_Hierarchy_Level__mdt> authLevelMap){
        //List<Authority_Hierarchy_Level__mdt> authLevelMap = new List<Authority_Hierarchy_Level__mdt>();
        //authLevelMap                                      = SanctionMatrix_Helper.getAuthorityLevel();
        integer roleIndex                                   = 0;
        string highestRole                                  = '';
        for(string role : rolelist){
            for(Authority_Hierarchy_Level__mdt mdtRole : authLevelMap){
                if(mdtRole.Authority_Level__c != null && role == mdtRole.DeveloperName && mdtRole.Authority_Level__c > roleIndex){
                    roleIndex   = Integer.ValueOf(mdtRole.Authority_Level__c);
                    highestRole = role;
                }
            }
        }
        if(highestRole == Constants.PRESIDENT_COO_API)highestRole = Constants.PRESIDENT_COO_NAME;
        return highestRole;
    }
    
    public static List<String> getCheckListPendingReason(List<Renewal_Checklists__c> checkList){
        List<String> reasonList = new List<String>();
        for(Renewal_Checklists__c c : checkList){
            if(c.Checklist_Name__c == 'Have we collected the FEC document (s)?')
                reasonList.add('FEC not obtained');
            if(c.Checklist_Name__c == 'Is CERSAI registration details available?')
                reasonList.add('CERSAI not available');
            if(c.Checklist_Name__c == 'Form 8 Available?')
                reasonList.add('Form 8 not available');
            if(c.Checklist_Name__c == 'Are all Audit Remarks are Closed?')
                reasonList.add('Audit Remarks are open.');
            if(c.Checklist_Name__c == 'If up to date stock statement received?')
                reasonList.add('Stock statement not received.');
            if(c.Checklist_Name__c == 'If special sanctioning terms and conditions are complied by the borrower ?')
                reasonList.add('T&C not complied.');
            if(c.Checklist_Name__c == 'Is the latest unit visit report available?')
                reasonList.add('Visit report not available.');
            if(c.Checklist_Name__c == 'Have we obtained the latest EC?')
                reasonList.add('EC not obtained.');
            if(c.Checklist_Name__c == 'Do we have full insurance coverage?')
                reasonList.add('No full coverage insurance.');
            if(c.Checklist_Name__c == 'Is the last collateral valuation date within 3 years from the renewal date?')
                reasonList.add('Collateral valuation date not valid');
            if(c.Checklist_Name__c == 'Do we have last year audited financials statements?')
                reasonList.add('Last FY statements not available.');
        }
        return reasonList;
    }
    public static Boolean checkIfNextAuthIsRMD(string applId){
        List<Facility__c> facAuthority  = getFacilityAuthority(applId);
        integer fCount                  = facAuthority.size();
        integer nextAuhtCount           = 0;
        string role                     = '';
        User loggedUser = currentUserInfo();
        
        for(Facility__c f : facAuthority){
            if(f.role__C    == loggedUser.Designation__c){
                nextAuhtCount = integer.valueof(f.Higher_Authority_Order__c) + 1;
                break;
            }
        }
        if(nextAuhtCount <= facAuthority.size()){
            integer index = nextAuhtCount - 1;
            role    = facAuthority[index].Role__c;
            System.debug('## ' + role);
        }
        return role=='RMD'?true:false;
    }
    
    public Static Boolean checkIfIsSaveOperationDone(String appId){
         List<Facility__c> facAuthority1  = getFacilityAuthorityForAllfacility(appId);
        if(facAuthority1 <> null && !facAuthority1.isEmpty() && facAuthority1[0].Is_Save_Operation_Done__c){
            system.debug('facAuthority1[0].Is_Save_Operation_Done__c::'+facAuthority1[0].Is_Save_Operation_Done__c);
            return true;
        }
        return false;
    }
    
    // Wrapper class
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