/**
 * Created by ET-MARLABS on 07-03-2019.
 */

global class UDDashboardHelper{


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

    public UDDashboard.UnderwritingWrapper getDashboardContent(string appId, User currentUserInfo){

        UDDashboard.UnderwritingWrapper creditScore                                   = new UDDashboard.UnderwritingWrapper();
        List<UDDashboard.ScoreWrapper> creditScores                               	  = new List<UDDashboard.ScoreWrapper>();
        try{

            creditScore.loggedInUser                                                  = currentUserInfo;
            creditScore.scores                                                              = new List<Credit_Underwriting__c>();
            List<Credit_Underwriting__c> underwritingscores;

            if(TermLoanModelClass.creditUnderwritingInfoMap.containsKey(appId)){
                underwritingscores                                 = TermLoanModelClass.creditUnderwritingInfoMap.get(appId);
            }else{
                TermLoanModelClass.prepareCurrentcreditUnderwritingInfo(appId);
                if(TermLoanModelClass.creditUnderwritingInfoMap.containsKey(appId)){
                    underwritingscores                                 = TermLoanModelClass.creditUnderwritingInfoMap.get(appId);
                }

            }
            creditScore.sanctionauthComments                                                = new List<Audit__c>();
            creditScore.termsCondtionComments                                               = new List<Audit__c>();
            creditScore.preDisbursementComments                                             = new List<Audit__c>();

            if(TermLoanModelClass.mclrValues != 0.00){
                creditScore.mclrRate                                                        = TermLoanModelClass.mclrValues;
            }else{
                TermLoanModelClass.prepareCurrentMCLRInfo();
                if(TermLoanModelClass.mclrValues != 0.00){
                    creditScore.mclrRate                                                        = TermLoanModelClass.mclrValues;
                }
            }

            List<Audit__c> auditComments;
            if(TermLoanModelClass.auditInfoMap.containsKey(appId)){
                auditComments = TermLoanModelClass.auditInfoMap.get(appId);
            }else{
                TermLoanModelClass.prepareCurrentAuditInfo(appId);
                if(TermLoanModelClass.auditInfoMap.containsKey(appId)){
                    auditComments = TermLoanModelClass.auditInfoMap.get(appId);
                }
            }

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
                UDDashboard.ScoreWrapper sw                                           = new UDDashboard.ScoreWrapper();
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
            creditScore.applicationInfo                                                     = UDDashboardHelper.getapplnInformation(appId);
            creditScore.termLoanExposure                                                    = UDDashboardHelper.getTermLoanAmount(appId,creditScore.applicationInfo.genesis__Account__r.Id);

            creditScore.roleWiseLimitAmount                                                 = new Map<String, Decimal>();
            creditScore.reccomendationCappingDetails                                        = new List<Authority_Hierarchy_Level__mdt>();
            creditScore.reccomendationCappingDetails                                        = getReccomendationCappingDetails();
            if(creditScore.applicationInfo.RecordType.DeveloperName != 'SME_Exceeding'){
                creditScore.roleWiseLimitAmount                                             = UDDashboardHelper.getRoleWiseLimitAmount();
            }else{
                creditScore.roleWiseLimitAmount                                              = UDDashboardHelper.getRoleWiseLimitAmountForExceeding();
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
    public static List<Credit_Underwriting__c> getapplnUnderwriting(string appId){
        return [Select id,Appraisal__c,Comments__c,Application_Score__c,Application_Value__c,
                Application_Weight__c,Application__c,Application_Score_Percent__c,
        (Select id,Underwriting_Variable__c,toLabel(Variable_type__c),Application_Value__c,Application_Weight__c,Comments__c,
                Application_Score__c,Flags_Value__c,Flags_Range__c,RecordTypeId,RecordType.DeveloperName,Threshold_breached__c
        from Credit_Underwritings__r)
        from Credit_Underwriting__c where Application__c =: appId Order by Display_Order__c];
    }
    public static Decimal getMCLRValuesFromMaster(){
        try {
            Decimal mclrValue =  [Select Id,COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=365.0  Limit 1].MCLR_Of_Interest__c;
            //return 9.55;
            return mclrValue;
        } catch (Exception e) {
            HandleBusinessException.captureError('UDDashboard_Helper', 'getMCLRValuesFromMaster', e);
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
    public static List<genesis__Application_Status_History__c> getRecommendationHistory(string appId){
        return [SELECT Id,genesis__Application__c,Type__c,Recommendation_Limit_Rs__c,Facility__c,Recommendation_Rate_of_Intrest__c,User_Name__c,User_Role__c,createdDate
        FROM genesis__Application_Status_History__c where genesis__Application__r.id =: appId AND Type__c=:Constants.RECOMMENDED_CHANGE_TYPE_HISTORY];
    }
    public static List<Facility__c> getFacilityData(string appId){
        /*return [select Id,Application__c,Facility_Application_Type__c,Is_Facility_App_Type_Upadte__c,Recommended_Rate__c,Recommended_Limit__c,Faciliity_Type__c,Renewal_Processing_Charge__c,Recommended_Processing_Charge__c,Recommended_Spread__c,BRE_Limit__c,Name,NTB_Facility_Type__c,Is_Save_Operation_Done__c,New_Limit_Amount__c,Purpose_of_Shifting__c,Application__r.genesis__Account__c,Industry__c,CL_Product__c,Product_Category__c,CL_Product__r.clcommon__Product_Name__c,CL_Product__r.Facility_Category__c,BRE_Rate__c,BRE_Margin_Receivables__c,BRE_Margin_Stock_Manufacturing__c,BRE_Margin_Stock_Trading__c,
                Existing_Limit__c,Existing_Rate__c,Type__c,Approved_Margin__c,BRE_Spread__c,CL_Product__r.Processing_fee_renwal__c,CL_Product__r.Schematic_Loan__c,Existing_Processing_Charge__c,BRE_Processing_Charge__c,Existing_Spread__c,
                Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c,Application__r.OwnerId,Application__r.genesis__Account__r.Industry_Type__c,
                Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,MCLR_Rate__c,BRE_Margin__c,
        (Select id,Facility__c,Renewal_Processing_Charge__c,Recommended_Days__c,Deviation_Approver__c,Highest_Authority__c,Recommended_Rate__c,Recommended_Limit__c,Role__c,
                Higher_Authority_Order__c,Existing_Processing_Charge__c,Read_Only_User__c,Recommended_Processing_Charge__c,
                Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,BRE_Limit__c,Margin_Stock_Trading__c
        from Facilities__r where RecordType.DeveloperName=:Constants.FACILITY_CHILD_RECORD_TYPE AND Read_Only_User__c=false)
        FROM Facility__c where Application__r.id=: appId AND RecordType.DeveloperName =:Constants.FACILITY_PARENT_RECORD_TYPE And Active__c=true];*/
        if(TermLoanModelClass.facilityrecMap.containsKey(appId)){
            return TermLoanModelClass.facilityrecMap.get(appId);
        }else{
            TermLoanModelClass.prepareCurrentFacilityInfo(appId);
            return TermLoanModelClass.facilityrecMap.get(appId);
        }
    }
    public List<String> getCheckListPendingReason(List<Renewal_Checklists__c> checkList){
        return SanctionUnderwriting_Process.getCheckListPendingReason(checkList);
    }
    public static List<Audit__c> getAuthorityComment(string appId){
        return [select Id,User__c,User__r.Name,User__r.Designation__c,Complied__c,Reason__c,Sanction_Authority_Comment__c,Application__c,Terms_and_Conditions__c,
                RecordType.DeveloperName,createdDate from Audit__c where (RecordType.DeveloperName =:Constants.SANCTION_AUTHORITY_AUDIT_RTYPE OR
        RecordType.DeveloperName =:Constants.UNDERWRITING_T_C_RTYPE OR
        RecordType.DeveloperName =:Constants.PREDISBURSEMENT_T_C_RTYPE ) AND Application__c =:appId];
    }
    public static genesis__Applications__c getapplnInformation(string appId){

        return [Select id,No_of_years_of_operation__c,Name,Type__c,Deviation_Reason__c,Management_experience__c,Inward_cheque_return__c,Overall_Exposure__c,RecordType.DeveloperName,Processing_Fee__c,Processing_Charges__c,Is_Take_Over__c,New_to_Business__c,Legal_clearance__c,Request_Reason__c,Reason_for_Application__c,EAE_Renewal_Date_in_days__c,Is_Financial_security_Coverage_Less__c,Risk_Rating__c,Overall_Score__c,genesis__Account__r.Name,OwnerId,Committe__c,genesis__Account__r.Description,
                genesis__Account__r.Id,genesis__Account__r.Overall_Exposure__c,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.Group_Name__c,Application_Stage__c,
                genesis__Account__r.Name_of_the_Chief_Person__c,Application_Status__c,Company_Profile__c,Key_Management_Profile__c,Beuro_Profile__c,Market_Profile__c,
                genesis__Account__r.Branch_Code__c,genesis__Account__r.SMA_Classification__c,genesis__Account__r.Date_of_Incorporation__c,genesis__Account__r.Branch_Name__c,genesis__Account__r.Line_of_Activity__c,
                Branch_Code__c,Branch_Name__c,Recommended_Security_Coverage__c,Security_coverage__c,genesis__Customer_Cash_Used_For__c from genesis__Applications__c where id=: appId];
    }
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

}