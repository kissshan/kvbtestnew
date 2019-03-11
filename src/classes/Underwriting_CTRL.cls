/*
* Name      : Underwriting_CTRL
* Purpose   : Controller class for Underwriting Dashboard.
* Author    : Amritesh/Vinay        
*/
public class Underwriting_CTRL {
    //asdf
    public UnderwritingWrapper creditScore                      {get;set;}
    public string creditScoreStr                                {get;set;}
    public string appId                                         {get;set;}
    public string sanprocessJson                                {get;set;}
    public String auditRTypeID                                  {get;set;}
    public String auditTCRTypeID                                {get;set;}
    public String auditPreTCRTypeID                             {get;set;}

    public string dashboardFor                                  {get;set;}
    public boolean riskUser                                     {get;set;}
    public SanctionUnderwriting_Process.userInfoWrapper sancprocess {get; set;}


    //Constructor
    public Underwriting_CTRL(){
        try{
            riskUser                                            = false;
            appId                                               = apexpages.currentpage().getparameters().get('id');
            loadPageData(appId);
            
        }catch(Exception e){
            appId                                               = '';
            system.debug('exception:::'+e.getStackTraceString());
        }
    }
    /*@RemoteAction
    public static string createTaskForPreviousAuthority(string applId) {
        return Underwriting_CTRL_Helper.createTaskForPreviousAuthority(applId);
    }*/
    @RemoteAction
    public static string createTaskForPreviousAuthority(saveWrapper savedata) {
        return Underwriting_CTRL_Helper.createTaskForPreviousAuthority(savedata);
    }
	
    @RemoteAction
    public static Decimal getFinalAuthorityRecommedationForNewToCreditType(String appId,List<Facility__c> listOfFacility){
        return Underwriting_CTRL_Helper.getFinalAuthorityRecommedationForNewToCreditType(appId,listOfFacility);
    }
    
    @RemoteAction
    public static string saveProfileDataForNewSourcing(genesis__Applications__c appRecord) {

        return Underwriting_CTRL_Helper.saveProfileDataForNewSourcing(appRecord);
    }
    @RemoteAction
    public static string rejectEnhancement(string applId) {
        return Underwriting_CTRL_Helper.rejectEnhancementHelper(applId);
    }
    @RemoteAction
    public static string rejectNewLoan(string applId) {
        return Underwriting_CTRL_Helper.rejectNewLoanHelper(applId);
    }
    
    @RemoteAction
    public static string checkSecurityCoverage(string applId,saveWrapper savedata) {
        return Underwriting_CTRL_Helper.checkSecurityCoverageHelper(applId,savedata);
        //return null;
    }

    @RemoteAction
    public static string updateFinalAuthTermsAndCondition(string applId,List<Audit__c> commentList) {
        return Underwriting_CTRL_Helper.updateFinalAuthTermsAndCondition(applId,commentList);
    }
    @RemoteAction
    public static string updatedeviationApproverTermsAndCondition(string applId,List<Audit__c> commentList) {

        return Underwriting_CTRL_Helper.updatedeviationApproverTermsAndCondition(applId,commentList);
    }
    @RemoteAction
    public static string rejectExceedingAdhoc(string applId) {
        return Underwriting_CTRL_Helper.rejectExceedingAdhocHelper(applId);
    }

    // Save sanction authority input
    @RemoteAction
    public static ReturnWrap saveUnderWrite(saveWrapper savedata){

        if(savedata.actionPerformed == 'LIMIT_UPDATION'){
            return Underwriting_CTRL_Helper.updateLimitAmount(savedata);
        }else{
            return Underwriting_CTRL_Helper.saveData(savedata);
        }

    }
    @RemoteAction
    public static String updateApplicationStagetoFinalSanction(String appId){
        return Underwriting_CTRL_Helper.updateApplicationStagetoFinalSanction(appId);
    }
    @RemoteAction
    public static String savePreDisbursementComments(List<Audit__c> auditRecs,String appId){
        //System.debug('@@@@'+auditRecs);
        return Underwriting_CTRL_Helper.savePreDisbursementComments(auditRecs,appId);
        //return null;
    }
    @RemoteAction
    public static String updateApplicationStage(genesis__Applications__c appData){
        //return Underwriting_CTRL_Helper.saveData(savedata);
        return Underwriting_CTRL_Helper.updateApplicationStage(appData);
    }

    // Save other authority input
    @RemoteAction
    public static ReturnWrap otherAuthoritySubmit(string appId, String comment){
        return Underwriting_CTRL_Helper.saveOtherAuthorityInput(appId, comment);
    }

    @RemoteAction
    public static String otherAuthorityReferBack(string appId, String comment){
        return Underwriting_CTRL_Helper.otherAuthorityReferBackhelper(appId, comment);
    }
    @RemoteAction
    public static String rejectNewLoanByRMD(String appId,String comment){
        return Underwriting_CTRL_Helper.rejectNewLoanByRMDHelper(appId,comment);
    }
    @RemoteAction
    public static String acceptNewLoanByRMD(String appId,String comment){
        return Underwriting_CTRL_Helper.acceptNewLoanByRMDHelper(appId,comment);
    }

    // Save Sanction Approver Auhtority input
    @RemoteAction
    public static ReturnWrap sanctionApprovalSubmit(string appId, String action, SanctionUnderwriting_Process.userInfoWrapper userStatus, Audit__c auditComment){

        return Underwriting_CTRL_Helper.saveSanctionAuthorityInput(appId, action, userStatus, auditComment);
        //return null;
    }
    @RemoteAction
    public static ReturnWrap sanctionApprovalSubmitRefactor(string appId, String action, SanctionUnderwriting_Process.userInfoWrapper userStatus, Audit__c auditComment,saveWrapper savedata){

        return Underwriting_CTRL_Helper.sanctionApprovalSubmitRefactor(appId, action, userStatus, auditComment,savedata);
        //return null;
    }

    public void loadPageData(string appId){

        auditRTypeID                                            = Underwriting_CTRL_Helper.auditRTypeID;
        auditTCRTypeID                                          = Underwriting_CTRL_Helper.auditTCRTypeID;
        auditPreTCRTypeID                                       = Underwriting_CTRL_Helper.auditPreTCRTypeID;
        creditScoreStr                                          = '';
        sancprocess                                             = new SanctionUnderwriting_Process.userInfoWrapper();
        User currentUserInfo                                    = SanctionUnderwriting_Process.currentUserInfo();
        Set<String> rolesAccessNames                            = Utility.getDashboardAccessdesignations();
        if(rolesAccessNames.contains(currentUserInfo.Designation__c)){
            riskUser    = true;
        }
        UnderwritingWrapper creditScore                         = new UnderwritingWrapper();

        Underwriting_CTRL_Helper underwritingObj                = new Underwriting_CTRL_Helper();
        creditScore                                             = underwritingObj.getDashboardContent(appId,currentUserInfo);
        System.debug('#####'+creditScore);
        System.debug('#####'+creditScore.applicationInfo.Application_Stage__c);
        System.debug('#####'+creditScore.applicationInfo.RecordType.DeveloperName);
        if((creditScore.applicationInfo.Application_Stage__c == Constants.APPLICATION_REVIEW_STAGE
                || creditScore.applicationInfo.Application_Stage__c == Constants.APP_DEVIATION_PENDING_STAGE) &&  creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_Renewal){
            System.debug('##### inside renewal');
            sancprocess                                      = SanctionUnderwriting_Process.getCurrentUserStatus(appId,creditScore.applicationInfo,creditScore.loggedInUser);
            dashboardFor                                     = Constants.INTERIM_EXTENSION_LABEL;
        }
        if((creditScore.applicationInfo.Application_Stage__c == Constants.APP_REVIEW_FINANCIAL_STAGE
                || creditScore.applicationInfo.Application_Stage__c == Constants.APP_DEVIATION_FINANCIAL_STAGE
                || creditScore.applicationInfo.Application_Stage__c == Constants.BRE_DONE_FINANCIALS
                || creditScore.applicationInfo.Application_Stage__c == Constants.APP_REVIEW_FINAL_STAGE
                || creditScore.applicationInfo.Application_Stage__c == Constants.APP_FINAL_DEVIATION) && creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_Renewal){
            System.debug('#####');
            sancprocess                                      = SanctionUnderwriting_Process.getCurrentUserStatus(appId,creditScore.applicationInfo,creditScore.loggedInUser);
            dashboardFor                                     = Constants.RENEWAL_LABEL;
        }
        if(creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING
                ||  creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC
                ||  creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT
                ||  creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
            System.debug('#####');
            sancprocess                                      = SanctionUnderwriting_Process.getCurrentUserStatus(appId,creditScore.applicationInfo,creditScore.loggedInUser);
            if(creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                dashboardFor                                     = Constants.SME_RECORD_TYPE_LABEL_EXE;
            }else if(creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                dashboardFor                                     = Constants.SME_RECORD_TYPE_LABEL_ADHOC;
            }else if(creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                dashboardFor                                     = Constants.SME_NEW_LOAN_RECORD_TYPE_LABEL;
            }
            else if(creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                dashboardFor                                     = Constants.SME_APP_RECORD_TYPE_ENHANCEMENT;
            }
            else if(creditScore.applicationInfo.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                dashboardFor                                     = Constants.SME_RECORD_TYPE_LABEL_ENHANCEMENT;
            }
        }
        System.debug('####'+sancprocess);
        sanprocessJson                                          = JSON.serialize(sancprocess);
        creditScoreStr                                          = JSON.serializePretty(creditScore);
        System.debug('####'+creditScoreStr+' --> sanprocessJson'+sanprocessJson);
    }



    //Final Wrapper passed from Page to Controller
    public class saveWrapper{
        public List<Facility__c>                                facility;
        public List<Credit_Underwriting__c>                     bmCommentsList;
        public List<Audit__c>                                   termsAndConditions;
        public List<Audit__c>                                   preDisbersementtermsAndConditions;
        public string                                           actionPerformed;
        public string                                           isSaveOrSubmit;
        public string                                           isStageChanged;
        public genesis__Applications__c                         applicationInfo;
        public string                                           appId;
        public Integer                                          roleCount;
        public boolean                                          IsFinalAuthority;
        public boolean                                          isReadOnly;
        public boolean                                          isMoreThanTenDays;
        public List<existingFeeWrapper>                         existingFeeWrap;
		
    }

    // Wrapper to pass data on page on load
    public class UnderwritingWrapper{
        public Account                                          customerInfo;
        public genesis__Applications__c                         applicationInfo;
        public List<User>                                       userList;
        public User                                             loggedInUser;
        public List<Credit_Underwriting__c>                     scores;
        public List<ScoreWrapper>                               creditScores;
        public List<genesis__Application_Status_History__c >    recommHistory;
        public List<Facility__c>                                facilityList;
        public List<string>                                     pendingPreRenewalList;
        public Map<String,underwritingdashboardrulecriteria__c> underWritingDashboardRuleCriteria;
        public List<Audit__c>                                   sanctionauthComments;
        public List<Audit__c>                                   termsCondtionComments;
        public List<Audit__c>                                   preDisbursementComments;
        public KVB_Company_Details__c                           kvbCompanyDetails;
        public Decimal                                          termLoanExposure;
        public Decimal                                          mclrRate;
        public Map<String,Decimal>                              roleWiseLimitAmount;
        public List<Authority_Hierarchy_Level__mdt>             reccomendationCappingDetails;
    }

    public class ScoreWrapper {
        public string                                           applicationId;
        public string                                           parentAppraisal;
        public string                                           parentScore;
        public string                                           parentvalue;
        public string                                           parentweight;
        public Double                                           parentScorePerc;
        public List<Credit_Underwriting__c>                     childApplicationScore;
        public List<Credit_Underwriting__c>                     childFlags;
    }
    public class existingFeeWrapper{
        public string                                            id;
        public string                                            parentFacId;
        public Decimal 											 productExstingFee;
        public Decimal                                           processingFee;
    }

    public class ReturnWrap{
        public string                                           message;
        public string                                           stage;
        public string                                           finalAuthMessage;
    }
}