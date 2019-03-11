/**
 * Created by ET-MARLABS on 16-01-2019.
 */

global with sharing class SanctionAuthority {
    public static Map<Id,clcommon__CL_Product__c> productByProdId                       = new Map<Id, clcommon__CL_Product__c>();
    public static List<Facility__c> allFacList                                          = new List<Facility__c>();
    public static String branchManagerRole                                              = '';
    public static genesis__Applications__c appRecord                                    = new genesis__Applications__c();
    public static List<Overall_Exposure__mdt> overallExpoMetadata                       = new List<Overall_Exposure__mdt>();
    public static String finalDeviationAuthority                                        = '';
    public static Account accountRecord                                                 = new Account();
     public static void calculateAuthority(String appId){

         try {

            overallExpoMetadata = SanctionAuthorityModel.getOverallExposure();
            System.debug('overallExpoMetadata'+overallExpoMetadata);

            branchManagerRole = SanctionAuthorityHelper.getappBranchMangerDesignation(appId);


            appRecord  = SanctionAuthorityModel.getApplicationInfo(appId);
            allFacList = SanctionAuthorityModel.getAllFacilities(appId);
            Decimal aggregateValue = 0.00;
             for(Facility__c facRec:allFacList){
                 aggregateValue+=facRec.BRE_Limit__c;
             }
            System.debug('allFacList'+allFacList);
            accountRecord.Id = appRecord.genesis__Account__c;


            Set<String> allProdIds = new Set<String>();

            allProdIds  = SanctionAuthorityHelper.getProdIdsForGivenFacility(allFacList);
            System.debug('allProdIds'+allProdIds);

            productByProdId = SanctionAuthorityModel.getProductWithAuthorities(allProdIds);
            System.debug('productByProdId'+productByProdId);

            List<Authority_Hierarchy_Level__mdt> authLevelList      = new List<Authority_Hierarchy_Level__mdt>();
            authLevelList                                           = SanctionAuthorityModel.getAuthorityLevel();
            System.debug('authLevelList'+authLevelList);
            //productByProdId =SanctionAuthorityModel.getProductWithAuthorities()
            Set<String> roleList = new Set<String>();
             String applicableRole ='';
            for (Facility__c facRec:allFacList){
                // pass loan amount and Security Coverage


                System.debug('productByProdId.get(facRec.CL_Product__c).Product_Sanction_Authorities__r'+productByProdId.get(facRec.CL_Product__c).Product_Sanction_Authorities__r);

                if(facRec.Is_Primary_Security_Required__c && !facRec.Is_Collateral_Security_Required__c)
                    applicableRole = SanctionAuthorityHelper.getApplicableRole(facRec.BRE_Limit__c,facRec.Primary_Security_Coverage__c,productByProdId.get(facRec.CL_Product__c).Product_Sanction_Authorities__r);
                else if(facRec.Is_Collateral_Security_Required__c && !facRec.Is_Primary_Security_Required__c)
                    applicableRole = SanctionAuthorityHelper.getApplicableRole(facRec.BRE_Limit__c,facRec.Collateral_Security_Coverage__c,productByProdId.get(facRec.CL_Product__c).Product_Sanction_Authorities__r);

                System.debug('applicableRole'+applicableRole);


                if(applicableRole != ''){
                    appRecord.Sanction_Authority__c = applicableRole;
                    roleList.add(applicableRole);
                }

            }
             if(applicableRole != ''){
                 System.debug('applicableRole'+applicableRole);
                 appRecord.Sanction_Authority__c = applicableRole;
                 //roleList.add(applicableRole);
             }

            System.debug('roleList'+roleList);

            String overallExposureWiseRole = '';
             String groupExposureWiseRole = '';
             Decimal overallExposure =0.00;
             overallExposure = SOQL_Util.getOverallExposure(appRecord.genesis__Account__c);
             Decimal groupExposure =0.00;
             groupExposure = SOQL_Util.getoverallexposureforapplication(appRecord.Id);
             System.debug('overallExposure'+overallExposure);
             System.debug('groupExposure'+groupExposure);
            overallExposureWiseRole         = SanctionAuthorityHelper.getApplicableRoleByOverallExposure(appRecord.genesis__Account__r.Overall_Exposure__c);
             groupExposureWiseRole          = SanctionAuthorityHelper.getApplicableRoleByOverallExposure(groupExposure);

            //accountRecord.Sanction_Authority__c =overallExposureWiseRole;
             System.debug('groupExposureWiseRole'+groupExposureWiseRole);
            System.debug('overallExposureWiseRole'+overallExposureWiseRole);
            accountRecord.Sanction_Authority__c =overallExposureWiseRole;
             accountRecord.Overall_Exposure__c  =overallExposure;
             accountRecord.Group_Exposure__c = groupExposure;
            if(overallExposureWiseRole != ''){
                roleList.add(overallExposureWiseRole);
            }
             if(groupExposureWiseRole!=''){
                 roleList.add(groupExposureWiseRole);
             }
             Boolean isDO_DM = false;
             if(appRecord.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE && (appRecord.New_to_Business__c || (appRecord.Type__c).contains('Takeover'))){
                 isDO_DM =true;
            }
             if(isDO_DM){
                 roleList.add('DO_DM');
             }
             System.debug('roleList'+roleList);

            finalDeviationAuthority = SanctionUnderwriting_Process.gethighestRole(roleList, authLevelList);

            System.debug('finalDeviationAuthority'+finalDeviationAuthority);

            List<String> rolesToBeInserted = new List<String>();

            if(finalDeviationAuthority.startsWith('BR_')){
                // Only BM is final Authority
                rolesToBeInserted.add(branchManagerRole);

            }else{
                rolesToBeInserted.add(branchManagerRole);
                rolesToBeInserted.add('DO Credit Officer');

                if(aggregateValue > 10000000.00){
                    rolesToBeInserted.add('RMD');
                }
                rolesToBeInserted.add(finalDeviationAuthority);
            }

            System.debug('rolesToBeInserted'+rolesToBeInserted);
             rolesToBeInserted = new List<String>(new Set<String>(rolesToBeInserted));
             System.debug('rolesToBeInserted'+rolesToBeInserted);
             SanctionAuthorityHelper.insertFacilityRecs(rolesToBeInserted);


                 System.debug('accountRecord'+accountRecord);
                 update accountRecord;
                 System.debug('appRecord'+appRecord);
                 update appRecord;
         } catch (Exception e) {
             HandleBusinessException.captureError('SanctionAuthority','calculateAuthority',e);

         }


    }
    webService static String runSanctionAuth(String appId){
        try {
            calculateAuthority(appId);
            return 'Sanction Authority is being calculated.';
        } catch (Exception e) {
            HandleBusinessException.captureError('SanctionAuthority','runSanctionAuth',e);
            return 'Some Error Occured'+' AT '+e.getLineNumber() ;
        }
    }
}