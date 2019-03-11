/**
 * Created by ET-MARLABS on 07-03-2019.
 */

public class UDDashboard{

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
    public UDDashboard(){
        try{
            riskUser                                            = false;
            appId                                               = apexpages.currentpage().getparameters().get('id');
            loadPageData(appId);
            
        }catch(Exception e){
            appId                                               = '';
            system.debug('exception:::'+e.getStackTraceString());
        }
    }

    public void loadPageData(string appId){

        auditRTypeID                                            = UDDashboardHelper.auditRTypeID;
        auditTCRTypeID                                          = UDDashboardHelper.auditTCRTypeID;
        auditPreTCRTypeID                                       = UDDashboardHelper.auditPreTCRTypeID;
        creditScoreStr                                          = '';
        sancprocess                                             = new SanctionUnderwriting_Process.userInfoWrapper();
        User currentUserInfo;
        if(TermLoanModelClass.userInfoMap.containsKey(userInfo.getUserId())){
            currentUserInfo = TermLoanModelClass.userInfoMap.get(userInfo.getUserId());
        }else{
            TermLoanModelClass.prepareCurrentUserInfo(userInfo.getUserId());
            currentUserInfo = TermLoanModelClass.userInfoMap.get(userInfo.getUserId());
        }
        Set<String> rolesAccessNames                            = UDDashboardModel.getDashboardAccessdesignations();
        if(rolesAccessNames.contains(currentUserInfo.Designation__c)){
            riskUser    = true;
        }
        UnderwritingWrapper creditScore                         = new UnderwritingWrapper();

        UDDashboardHelper underwritingObj                		= new UDDashboardHelper();
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