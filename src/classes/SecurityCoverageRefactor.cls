/**
 * Created by ET-MARLABS on 26-12-2018.
 */

global with sharing class SecurityCoverageRefactor {

    public static Map<String,List<FacilityPriorityByCollateral>> facilityPriorityOrderByCollateral  =  new Map<String, List<FacilityPriorityByCollateral>>();
    public static Map<String,Security_Configuration_Master__mdt> securityMasterByProduct            = new Map<String, Security_Configuration_Master__mdt>();
    public static Map<String,Decimal> faclityAmountByFaclity                                        = new Map<String, Decimal>();
    public static Map<String,Boolean> existingTLByFaclity                                           = new Map<String, Boolean>();
    public static Map<String,Decimal> collateralAmountBycollateral                                  = new Map<String, Decimal>();
    public static String applicationId                                                              = '';
    public Static void securityCoverageCalculation(String appId){

        try {
            // 1. Get All Application Collaterals
            applicationId                                                                           = appId;
            Set<String> allColIds                                                                   = new Set<String>();
            Map<Id,genesis__Application_Collateral__c> allAppCollateralsMap                         = new Map<Id, genesis__Application_Collateral__c>();

            Map<Id,List<genesis__Application_Collateral__c>> allApplicationCollateralsByCollId      =  new Map<Id, List<genesis__Application_Collateral__c>>();

            allAppCollateralsMap                                                                    = SecurityCoverageRefactorModel.getAllApplicationColletrForApplication(appId);
            System.debug(' allAppCollateralsMap ==> '+allAppCollateralsMap);
            // 2. Get All failities linked to above collaterals (Map of All Application Collateral by Collateral)
            allColIds                                                                               = SecurityCoverageRefactorHelper.getAllCollateralIdsFromApplicationCollateral(allAppCollateralsMap.values());
            System.debug(' allColIds ==> '+allColIds);
            allApplicationCollateralsByCollId                                                       = SecurityCoverageRefactorHelper.getApplicationCollateralsByCollateral(allColIds);
            System.debug(' allApplicationCollateralsByCollId ==> '+allApplicationCollateralsByCollId);
            securityMasterByProduct                                                                 = SecurityCoverageRefactorModel.getSecurityMastersByProduct();
            System.debug(' securityMasterByProduct ==> '+securityMasterByProduct);
            // Allocation Logic
            //1. Find All Existing Facility Vs/ New Facility
            for(Id collId:allApplicationCollateralsByCollId.keySet()){
                SecurityCoverageRefactorHelper.collateralOrderCounter =0;
                SecurityCoverageRefactorHelper.collateralOrderCounter++;
                SecurityCoverageRefactorHelper.coverAllExistingFacility(allApplicationCollateralsByCollId.get(collId),collId);

                System.debug('Final Collateral And facility Order '+facilityPriorityOrderByCollateral);

            }
            System.debug('Final Collateral And facility Order '+facilityPriorityOrderByCollateral);
            SecurityCoverageRefactorHelper.processApplicationSecurityCoverage(appId);

        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactor','securityCoverageCalculation',e);
        }

    }

    webService static String calculateSecurityCoverage(String appId){
        try {
            securityCoverageCalculation(appId);
            return 'Security Coverage has been calculated.';
        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactor','calculateSecurityCoverage',e);
            return 'Some Error Occured'+' AT '+e.getLineNumber() ;
        }
    }

    public class FacilityPriorityByCollateral{

        public String facId;
        public String productName;
        public Integer order;
        public String isPrimaryOrCollateral;

        public FacilityPriorityByCollateral(String facId,String productName,Integer isPrimaryOrCollateral,String primOrColl){
            this.facId = facId;
            this.productName = productName;
            this.order = isPrimaryOrCollateral;
            this.isPrimaryOrCollateral = primOrColl;
        }
    }
}