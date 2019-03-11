/**
 * Created by ET-MARLABS on 29-05-2018.
 */

public with sharing class SanctionMatrixControllerHelper_EA {

    /**
     * This methods returns all the role data for new EA_Sanctionmatrix defined at custom metadata level
     *
     * @return List of EAE_Sanction_Matrix__mdt
     */


    public Static List<EAE_Sanction_Matrix__mdt> getEAESanction_matricesRecords(String isBM){
        List<String> managerRoles = new List<String>{'BR_MGR_SMALL','BR_MGR_MEDIUM','BR_MGR_LARGE','BR_MGR_VERYLARGE','BR_MGR_XPLARGE'};
        if(isBM == 'Yes')
        return [SELECT Role__c,Limit_in_Amount__c,Limit_in_Percentage__c,Order__c,Period_in_days__c,No_of_application_per_year__c FROM EAE_Sanction_Matrix__mdt WHERE Role__c IN:managerRoles ORDER BY Order__c ASC];
        else
        return [SELECT Role__c,Limit_in_Amount__c,Limit_in_Percentage__c,Order__c,Period_in_days__c,No_of_application_per_year__c FROM EAE_Sanction_Matrix__mdt WHERE Role__c NOT IN:managerRoles ORDER BY Order__c ASC];

    }

    /**
     * This method gives List of all facilities for a given application id
     *
     * @param appId
     *
     * @return List of Facility__c
     */
    public static List<Facility__c> getAllFacilities(String appId){
        try{
            if(appId != null && appId != ''){
                return SOQL_Util.getFacilities(appId);
            }else{
                system.debug('appId seems to be blank or null');
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return  null;
        }
    }

    /**
     * This method calculates Existing Limit  Aggregate for all facilities
     *
     * @param allFacilities
     *
     * @return
     */
    public static Decimal getExistingLimitAggregate(List<Facility__c> allFacilities){
        try{
            Decimal totalExistingLimit         = 0;
            if(allFacilities != null && !allFacilities.isEmpty()){

                for(Facility__c facilityRec:allFacilities){
                    if(facilityRec.Existing_Limit__c != null)
                    totalExistingLimit        += facilityRec.Existing_Limit__c;
                }

                return totalExistingLimit;
            }else{
                system.debug('No Facility record is available');
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }
    /**
     * This method calculates Limit Amount Aggregate for all facilities
     *
     * @param allFacilities
     *
     * @return
     */
    public static Decimal getLimitAmountAggregate(List<Facility__c> allFacilities){
        try{
            Decimal totalExistingLimit         = 0;
            if(allFacilities != null && !allFacilities.isEmpty()){

                for(Facility__c facilityRec:allFacilities){
                    //if(facilityRec.Existing_Limit__c != null)
                    totalExistingLimit        += facilityRec.Limit_Amount__c;
                }

                return totalExistingLimit;
            }else{
                system.debug('No Facility record is available');
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }
    /**
     * This method calculates New Limit Amount Aggregate for all facilities
     *
     * @param allFacilities
     *
     * @return getNewLimitAggregate
     */
    public static Decimal getNewLimitAggregate(List<Facility__c> allFacilities){
        try{
            Decimal totalNewLimit              = 0;
            if(allFacilities != null && !allFacilities.isEmpty()){

                for(Facility__c facilityRec:allFacilities){
                    if(facilityRec.New_Limit_Amount__c != null)
                        totalNewLimit             += facilityRec.Recommended_Limit__c;
                }

                return totalNewLimit;
            }else{
                system.debug('No Facility record is available');
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }
    public static Decimal getAggregatedAmount(String appId){
        try {
            Decimal totalNewLimit              = 0;
            genesis__Applications__c app = new genesis__Applications__c(Id = appId);
            string query                              = 'Select id,New_Limit_Amount__c,Application__c from Facility__c where Application__c =:appId';
            List<Facility__c> allFacilities           = new List<Facility__c>();
            for(Facility__c facilityRec:allFacilities){
                if(facilityRec.New_Limit_Amount__c != null)
                    totalNewLimit             += facilityRec.New_Limit_Amount__c;
            }
            if(totalNewLimit != 0){
                app.Total_Requested_Amount__c = totalNewLimit;
                ApplicationTriggerHandler.IsFirstRun = false;
                UPDATE app;
            }
            return totalNewLimit;

        } catch (Exception e) {
            HandleBusinessException.captureError('SanctionMatrix', 'getAggregatedAmount', e);
            system.debug('Exception::'+e.getMessage());
            return null;
        }
    }
    /**
     * This method calculates recommended Limit  Aggregate for all facilities
     *
     * @param allFacilities
     *
     * @return
     */
    public static Decimal getRecommendedAggregate(List<Facility__c> allFacilities){
        try{
            Decimal totalRecommendedLimit         = 0;
            if(allFacilities != null && !allFacilities.isEmpty()){

                for(Facility__c facilityRec:allFacilities){
                    if(facilityRec.Recommended_Limit__c != null)
                        totalRecommendedLimit        += facilityRec.Recommended_Limit__c;
                }

                return totalRecommendedLimit;
            }else{
                system.debug('No Facility record is available');
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }

    /**
     * Method returns x% of specified Existing limit(Aggregated value of all facilities)
     * x->this value is defined at metadata level for a given role.
     *
     * @param existingLimit
     * @param percentVlaue
     *
     * @return decimal
     */
    public static Decimal getSpecifiedPercentageValueOfExistingLimit(Decimal existingLimit, Decimal percentVlaue){
        try{

            if(existingLimit != null && percentVlaue != null){

                return (existingLimit * percentVlaue ) / 100;
            }else{
                system.debug('Some error in calculating getSpecifiedPercentageOfExistingLimit' +existingLimit+'!!!'+percentVlaue);
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }

    /**
     * Method to calculate minimum of what a Role can approve
     *  i.e Minimum of following 2
     *  1)x% of Existing limit amount specified (10 or 50) on metadata level
     *  2)Limit amount specified for role on metadata level
     *
     * @param specifiedPercentageValueForRole
     * @param LimitAmountForRole
     *
     * @return decimal
     */
    public static Decimal calculateMinimum(Decimal specifiedPercentageValueForRole, Decimal LimitAmountForRole){
        try{

            if(specifiedPercentageValueForRole != null && LimitAmountForRole != null){

                return specifiedPercentageValueForRole < LimitAmountForRole ? specifiedPercentageValueForRole : LimitAmountForRole;
            }else{
                system.debug('Some error in calculating Minimum' +specifiedPercentageValueForRole+'!!!'+LimitAmountForRole);
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }

    /**
     * Method to know whether a given role can approve new limit depending upon his
     *  1.10 % of existing limit
     *  2.Or his capability limit amount defined in metadata level
     *
     * @param highestAmountRoleCanApprove
     * @param aggregateNewLimitAmount
     *
     * @return Boolean flag indicating whether role can approve new limit or not
     */

    public static Boolean canGivenRoleSanctionNewLimit(Decimal highestAmountRoleCanApprove, Decimal aggregateNewLimitAmount){
        try{

            if(highestAmountRoleCanApprove != null && aggregateNewLimitAmount != null){

                return aggregateNewLimitAmount <= highestAmountRoleCanApprove ? TRUE : FALSE;
            }else{
                system.debug('Some error in calculating canGivenRoleSanctionNewLimit' +highestAmountRoleCanApprove+'!!!'+aggregateNewLimitAmount);
                return null;
            }
        }catch(Exception e){
            system.debug('Exeption In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }
    public static string getLastRenewal_Sanction(String custId){
        try {
            if(custId != null && custId!= ''){
                genesis__Applications__c appObj = [select id,Last_Renewal_Sanction_Authority__c,genesis__Account__r.CBS_Customer_ID__c from genesis__Applications__c where genesis__Account__r.CBS_Customer_ID__c = :custId AND RecordType.DeveloperName = 'SME_Renewal'];
                If (appObj != null && appObj.Last_Renewal_Sanction_Authority__c != null && appObj.Last_Renewal_Sanction_Authority__c != '') {
                    return appObj.Last_Renewal_Sanction_Authority__c;
                } else {
                    return null;
                }
            }else{
                return null;
            }

        }catch (Exception e){
            return null ;
        }
    }
    

    /* This Method is used to insert Child Facility(Authority Recommendation) under each Parent Facility */
    public static  String saveAllFacilityRecomendation(List<EAE_Sanction_Matrix__mdt> mdtList, String appId,Boolean isManagerHigherAuthority){
        try{
            List<Facility__c> parentFacilityList                = getAllFacilities(appId);
            List<Facility__c> childFacilityList;
            Id facilityRecTypeId                                = SOQL_Util.getRecordTypeIdBySobject(Constants.FACILITY_CHILD_RECORD_TYPE,Constants.SME_FACILITY);
            
            if(! parentFacilityList.isEmpty()){
                for(Facility__c parentFacRec : parentFacilityList){
                    childFacilityList                           = new List<Facility__c>();
                    Facility__c childFacilityRec;
                    if(! mdtList.isEmpty()){
                        for(EAE_Sanction_Matrix__mdt mdtObj : mdtList){
                            if(mdtObj != null && mdtObj.Role__c != null){
                                System.debug('@@@@@@'+mdtObj);
                                childFacilityRec                                = new Facility__c();
                                if( mdtObj.Order__c > 1){
                                    childFacilityRec.Higher_Authority_Order__c  = 2;
                                    childFacilityRec.Highest_Authority__c  = true;
                                }
                                else{
                                    childFacilityRec.Highest_Authority__c  = isManagerHigherAuthority;
                                    childFacilityRec.Higher_Authority_Order__c  = mdtObj.Order__c;
                                }
                                childFacilityRec.Role__c                        = mdtObj.Role__c;
                                childFacilityRec.RecordTypeId                   = facilityRecTypeId;
                                childFacilityRec.Facility__c                    = parentFacRec.Id;
                                childFacilityList.add(childFacilityRec);
                            }

                        }
                    }
                    
                    if(! childFacilityList.isEmpty()){
                        insert childFacilityList;
                    }
                }
            }
            return 'Success';
        }catch(Exception e){
            system.debug('Exeption In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return null;
        }
    }
    public static String changeBMAsHighrAuthoriry(String appId,Boolean isBMHigherAuth){
        try {
            if(appId != null && isBMHigherAuth == true){
                        List<String> allFacilityIds = new List<String>();
                        List<Facility__c> allCildFacility  = new List<Facility__c>();
                        List<Facility__c> allFacility = SOQL_Util.getFacilities(appId);
                        if(! allFacility.isEmpty()){
                            for(Facility__c facilityRec :allFacility){
                                allFacilityIds.add(facilityRec.Id);
                            }
                            if(! allFacilityIds.isEmpty()){
                                allCildFacility = SOQL_Util.getAllChildFacilities(allFacilityIds);
                                System.debug('@@@@@@@@@@@'+allCildFacility);
                            }
                            for(Facility__c childFacilityRec:allCildFacility){
                                if(!childFacilityRec.Deviation_Approver__c)
                                childFacilityRec.Highest_Authority__c = true;
                            }
                            update allCildFacility;

                        }
                return 'Bm Has been made final Authority';
            }
            return 'Some error Occurred';
        } catch (Exception e) {
            system.debug('Exeption In::::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return 'Exeption: In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage();
        }

    }
    public static String getApplicationManagerRole(String appId){
        try {
            String appManagerRole                           = '';
            User appOwner                                   = new User();
            List<genesis__Applications__c> appInfo          = new List<genesis__Applications__c>();
            if(appId != null && appId != ''){
                appInfo = SOQL_Util.getApplication(new Set<Id>{appId});
                if(! appInfo.isEmpty() && appInfo[0].genesis__Account__c != null){
                    appOwner = appOwnerInfo(appInfo[0].OwnerId);
                }
                if(appOwner != null){
                    appManagerRole  =    appOwner.Designation__c;

                }
            }
            return appManagerRole;
        } catch (Exception e) {
            system.debug('Exeption In::::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return '';
        }
    }
    public static String createAuthorityRecommendationForBM(String appId){
        try{
            User    appOwner                                = new User();
            String  appManagerRole                          = '';
            Decimal aggregateExistingLimit                  = 0;
            Decimal aggregateNewLimit                       = 0;
            
            List<EAE_Sanction_Matrix__mdt> mngrRoles        = new List<EAE_Sanction_Matrix__mdt>();
            List<genesis__Applications__c> appInfo          = new List<genesis__Applications__c>();
            List<Facility__c> allFacilities                 = new List<Facility__c>();
            
            mngrRoles   =  getEAESanction_matricesRecords('Yes');
            
            if(appId != null && appId != ''){
                appInfo = SOQL_Util.getApplication(new Set<Id>{appId});
                if(! appInfo.isEmpty() && appInfo[0].genesis__Account__c != null){
                    SanctionMatrixController_EA.applicationCountByRole = SanctionMatrixController_EA.getSanctionAuthority_Count(appInfo[0].genesis__Account__c);
                    appOwner = appOwnerInfo(appInfo[0].OwnerId);
                }
                if(appOwner != null){
                    appManagerRole  =    appOwner.Designation__c;
                }
            }
            else{
                System.debug('Application Id is Null');
            }
            EAE_Sanction_Matrix__mdt managerRolerec = new EAE_Sanction_Matrix__mdt();
            if(mngrRoles != null){
                for(EAE_Sanction_Matrix__mdt sanctionRec : mngrRoles){
                    if(sanctionRec.Role__c == appManagerRole){
                        managerRolerec = sanctionRec;
                    }
                }
            }
            List<EAE_Sanction_Matrix__mdt> metadataList = new List<EAE_Sanction_Matrix__mdt>();
            metadataList.add(managerRolerec);
            saveAllFacilityRecomendation(metadataList,appId,false);
            if(! Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appId,SanctionUnderwriting_Process.APPILICATION_REVIEW))
            SanctionMatrixController_EA.createTaskForBM(appId);
            return 'SUCCESS';
        }catch(Exception e){
            system.debug('Exeption In::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
            return null;
        }
    }

    public static User appOwnerInfo(String appOwnerId){
        return [Select id,Designation__c,Division,Name from User where Id=:appOwnerId];
    }
    public static Boolean checkIfBMRoleAlreadyExist(String appId){

        try {
            if(appId != null){
                List<String> allFacilityIds = new List<String>();
                List<Facility__c> allCildFacility  = new List<Facility__c>();
                List<Facility__c> allFacility = SOQL_Util.getFacilities(appId);
                System.debug('Helper All Facility--> '+ allFacility);
                if(! allFacility.isEmpty()){
                    for(Facility__c facilityRec :allFacility){
                        allFacilityIds.add(facilityRec.Id);
                    }
                    if(! allFacilityIds.isEmpty()){
                        allCildFacility = SOQL_Util.getAllChildFacilities(allFacilityIds);
                        System.debug('@@@@@@@@@@@'+allCildFacility);
                    }
                    System.debug('#####'+getApplicationManagerRole(appId));
                    for(Facility__c childFacilityRec:allCildFacility){
                        if(childFacilityRec.Role__c == getApplicationManagerRole(appId))
                            return true;
                        //childFacilityRec.Highest_Authority__c = true;
                    }
                    update allCildFacility;

                }

            }
            return false;
        } catch (Exception e) {
            system.debug('Exeption In::::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage());
            return false;
        }

    }
    

}