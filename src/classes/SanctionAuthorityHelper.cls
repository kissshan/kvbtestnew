/**
 * Created by ET-MARLABS on 16-01-2019.
 */

public with sharing class SanctionAuthorityHelper {

    public static String getappBranchMangerDesignation(String appId){


        genesis__Applications__c appRec = SanctionAuthorityModel.getApplicationInfo(appId);
        System.debug('apprec.OwnerId'+appRec.OwnerId);
        User userRec = SanctionAuthorityModel.getUserInfoById(appRec.OwnerId);
        System.debug('userRec.designation'+userRec.Designation__c);

        if(userRec.Designation__c != null) return userRec.Designation__c;
        else return '';

    }
    public static Set<String> getProdIdsForGivenFacility(List<Facility__c> allFacList){
        Set<String> allProdIds = new Set<String>();
        for (Facility__c facRec:allFacList){
            if(facRec.CL_Product__c != null){
                System.debug('facRec.CL_Product__c'+facRec.CL_Product__c);
                allProdIds.add(facRec.CL_Product__c);

            }

        }
        System.debug('allProdIds'+allProdIds);
        return allProdIds;
    }
    public static string getApplicableRole(Decimal loanAmount,Decimal securityCoverage,List<Product_Sanction_Authority__c> sanctionAuthorities){
        System.debug('loanAmount'+loanAmount);
        System.debug('securityCoverage'+securityCoverage);
        for(Product_Sanction_Authority__c sanctionAuthRec:sanctionAuthorities){
            if((sanctionAuthRec.Name).contains('BR_')){
                System.debug('sanctionAuthRec'+sanctionAuthRec);
                System.debug('sanctionAuthRec.Name'+sanctionAuthRec.Name);
                System.debug('SanctionAuthority.branchManagerRole'+SanctionAuthority.branchManagerRole);
                if(sanctionAuthRec.Name == SanctionAuthority.branchManagerRole){
                    System.debug('sanctionAuthRec.Name'+sanctionAuthRec.Name);
                    if(sanctionAuthRec.Security_Coverage_End_Range__c != 0.00 && sanctionAuthRec.Security_Coverage_Start_Range__c != 0.00){
                        if(loanAmount>=sanctionAuthRec.Limit_Start_Range__c && loanAmount<sanctionAuthRec.Limit_End_Range__c && securityCoverage<sanctionAuthRec.Security_Coverage_End_Range__c && securityCoverage>=sanctionAuthRec.Security_Coverage_Start_Range__c){
                            System.debug('sanctionAuthRec.Name'+sanctionAuthRec.Name);
                            return sanctionAuthRec.Name ;
                        }
                    }else{
                        if(loanAmount>=sanctionAuthRec.Limit_Start_Range__c && loanAmount<sanctionAuthRec.Limit_End_Range__c){
                            System.debug('sanctionAuthRec.Name'+sanctionAuthRec.Name);
                            return sanctionAuthRec.Name ;
                        }
                    }


                }
            }else{
                System.debug('sanctionAuthRec'+sanctionAuthRec);
                if(sanctionAuthRec.Security_Coverage_End_Range__c != 0.00 && sanctionAuthRec.Security_Coverage_Start_Range__c != 0.00){
                    if(loanAmount>=sanctionAuthRec.Limit_Start_Range__c && loanAmount<sanctionAuthRec.Limit_End_Range__c && securityCoverage<sanctionAuthRec.Security_Coverage_End_Range__c && securityCoverage>=sanctionAuthRec.Security_Coverage_Start_Range__c){
                        System.debug('sanctionAuthRec.Name'+sanctionAuthRec.Name);
                        return sanctionAuthRec.Name ;
                    }
                }else{
                    if(loanAmount>=sanctionAuthRec.Limit_Start_Range__c && loanAmount<sanctionAuthRec.Limit_End_Range__c){
                        System.debug('sanctionAuthRec.Name'+sanctionAuthRec.Name);
                        return sanctionAuthRec.Name ;
                    }
                }
               // if(sanctionAuthRec.Limit_Start_Range__c >= )
            }
        }
        return '';
    }
    public static string getApplicableRoleByOverallExposure(Decimal exposureAmount){
        //for(Product_Sanction_Authority__c)
        System.debug('new exposureAmount'+exposureAmount);

        System.debug('SanctionAuthority.branchManagerRole'+SanctionAuthority.branchManagerRole);
        SanctionAuthority.overallExpoMetadata = SanctionAuthorityModel.getOverallExposure();
        for(Overall_Exposure__mdt metaDataRec:SanctionAuthority.overallExpoMetadata){
            System.debug('metaDataRec'+metaDataRec);
            System.debug('metaDataRec.MasterLabel'+metaDataRec.MasterLabel);
            if((metaDataRec.MasterLabel).contains('BR')){
                System.debug('metaDataRec.MasterLabel inside BR'+metaDataRec.MasterLabel );
                if(metaDataRec.MasterLabel == SanctionAuthority.branchManagerRole){
                    if(metaDataRec.Exposure_End_Range__c >exposureAmount){
                        System.debug('metaDataRec.MasterLabel'+metaDataRec.MasterLabel);
                        return metaDataRec.MasterLabel;
                    }
                }
            }else{
                System.debug('metaDataRec.MasterLabel Outside BR'+metaDataRec.MasterLabel);
                if(exposureAmount >= metaDataRec.Exposure_Start_Range__c && exposureAmount <metaDataRec.Exposure_End_Range__c){
                    System.debug('metaDataRec.MasterLabel'+metaDataRec.MasterLabel);
                    return metaDataRec.MasterLabel;
                }
            }

        }
        return '';
    }
    public static void insertFacilityRecs(List<String> rolesToBeInserted){
        try {
            //SanctionAuthority.allFacList = SanctionAuthorityModel.getAllFacilities('a4V0l0000009ApF');
            //System.debug('########'+SanctionAuthority.allFacList);
            //System.debug('########'+SanctionAuthority.allFacList[0].Facilities__r);
            //SanctionAuthority.appRecord = SanctionAuthorityModel.getApplicationInfo('a4V0l0000009ApF');
            //SanctionAuthority.finalDeviationAuthority ='DO_DM';
            string facChildRTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();


            List<Facility__c> facilityListToBeInserted = new List<Facility__c>();
            if(rolesToBeInserted.size()==1){
                System.debug('########'+SanctionAuthority.allFacList);
                // BM is highest Auth
                // Check if Existing child rec is their
                //if yes, update that child rec by marking it as highest Auth
                if((rolesToBeInserted[0]).startsWith('BR')){
                    System.debug('########'+rolesToBeInserted);
                    for(Facility__c facParentRec:SanctionAuthority.allFacList){
                        System.debug('########'+facParentRec);
                        if(facParentRec.Facilities__r.size() == 1) {
                            for (Facility__c childFac : facParentRec.Facilities__r) {
                                System.debug('########' + childFac);
                                Facility__c facInstance = new Facility__c(Id = childFac.Id, Facility__c = facParentRec.Id, Highest_Authority__c = true);
                                facilityListToBeInserted.add(facInstance);
                                break;
                            }
                        }else{
                            facilityListToBeInserted = new List<Facility__c>();
                            // insert one child rec against each parent fac
                            Facility__c facInstance;


                                for(string role:rolesToBeInserted){
                                    facInstance = new Facility__c();
                                    facInstance.RecordTypeId = facChildRTypeId;
                                    facInstance.CL_Product__c = facParentRec.CL_Product__c;
                                    facInstance.Facility__c = facParentRec.Id;
                                    facInstance.Role__c = role;
                                    /*if(role == 'DO Credit Officer'){
                                        facInstance.Read_Only_User__c = false;
                                    }else{
                                        if(SanctionAuthority.finalDeviationAuthority == role)*/
                                    // By Default it would be highest Auth
                                    facInstance.Highest_Authority__c = true;
                                    /*}*/

                                    facInstance.Higher_Authority_Order__c = 1;

                                    facilityListToBeInserted.add(facInstance);
                                }
                            }
                            System.debug('%%%%%%%%%%%%%'+facilityListToBeInserted);
                            if(!facilityListToBeInserted.isEmpty()){
                                upsert facilityListToBeInserted;
                               // facilityListToBeInserted = new List<Facility__c>();
                            }
                        }

                }
                if(!facilityListToBeInserted.isEmpty()){
                    upsert facilityListToBeInserted;
                    facilityListToBeInserted = new List<Facility__c>();
                }

            }else{
                // Update BM Auth Rec And ->No Need
                // Insert other child rec
                if(SanctionAuthority.appRecord.RecordType.DeveloperName != Constants.SME_APP_RECORD_TYPE)
                    rolesToBeInserted.remove(0);

                Facility__c facInstance;
                //SanctionAuthority.allFacList = SanctionAuthorityModel.getAllFacilities('a4V0l0000009ApF');
                //SanctionAuthority.finalDeviationAuthority ='DO_DM';

                for(Facility__c facParentRec:SanctionAuthority.allFacList){
                    Integer fCount;
                    if(SanctionAuthority.appRecord.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE)
                            fCount = 1;
                    else
                            fCount = 2;
                    for(string role:rolesToBeInserted){
                        facInstance = new Facility__c();
                        facInstance.RecordTypeId = facChildRTypeId;
                        facInstance.CL_Product__c = facParentRec.CL_Product__c;
                        facInstance.Facility__c = facParentRec.Id;
                        facInstance.Role__c = role;
                        if(role == 'DO Credit Officer'){
                            facInstance.Read_Only_User__c = false;
                        }else{
                            if(SanctionAuthority.finalDeviationAuthority == role)
                                facInstance.Highest_Authority__c = true;
                        }

                        facInstance.Higher_Authority_Order__c = fCount;

                        facilityListToBeInserted.add(facInstance);
                        fCount++;
                    }
                }
                System.debug('%%%%%%%%%%%%%'+facilityListToBeInserted);
                if(!facilityListToBeInserted.isEmpty()){
                    upsert facilityListToBeInserted;
                }
            }


        } catch (Exception e) {
            HandleBusinessException.captureError('SanctionAuthorityHelper','insertFacilityRecs',e);
        }
    }
}