/*
 * @name         : SanctionMatrix_Calculation
 * @description  : Application sanction authority calculation
 * @author       : Amritesh
 */
public class SanctionMatrix_Calculation {

    public static final string ONLY_COVERAGE_METHOD     = 'ONLY_COVERAGE';
    public static final string FINAL_AUTHORITY_METHOD   = 'FINAL_AUTHORITY';
    public static final string INSUFFICIENT_COVERAGE    = 'INSUFFICIENT_COVERAGE';
    public static final string SUFFICIENT_COVERAGE      = 'SUFFICIENT_COVERAGE';

    /*
     * @methodType can be "ONLY_COVERAGE" or "FINAL_AUTHORITY"
     */
    public COVERAGE_MAP calculateAuthority(List<Facility__c> facilities,boolean isRenewal, string methodType, Map<Id, Facility__c> finalFacilityMap){

        COVERAGE_MAP finalCovgMap                               = new COVERAGE_MAP();
        Map<String, Decimal> appSecurityCoverageMap             = new Map<String, Decimal>();
        List<Authority_Hierarchy_Level__mdt> authLevelList      = new List<Authority_Hierarchy_Level__mdt>();
        authLevelList                                           = SanctionMatrix_Helper.getAuthorityLevel();
        try{
            List<String> facilityId = new List<String>();
            Map<String,List<Facility__c>> facilityByAppln       = new Map<String,List<Facility__c>>();
            Set<String> productIds  = new Set<String>();
            Set<string> customerIds = new Set<string>();
            Set<string> facilityIds = new Set<string>();
            set<String> appOwnerIds = new set<String>();
            Map<String, string> appBMAuthMap            = new Map<String, string>();
            Map<String, string> appWiseOwnerId          = new Map<String, string>();
            Map<String, string> prodApplnMap            = new Map<String, string>();
            Map<String, string> applIdVsCustId          = new Map<String, string>();
            Set<String> parentApplnIds                  = new set<String>();

            for(Facility__c f : facilities){
                System.debug('@@@@@@@@@@@@'+f);
                System.debug('TEst f.Application__r.Parent_Application__c'+f.CL_Product__c);
                facilityIds.add(f.Id);
                if(f.Application__r.Parent_Application__c != null)parentApplnIds.add(f.Application__r.Parent_Application__c);
                if(f.CL_Product__c != null){
                    productIds.add(f.CL_Product__c);
                    prodApplnMap.put(f.CL_Product__c, f.Application__c);
                }
                customerIds.add(f.Application__r.genesis__Account__c);
                appOwnerIds.add(f.Application__r.OwnerId);
                appWiseOwnerId.put(f.Application__c, f.Application__r.OwnerId);
                applIdVsCustId.put(f.Application__c,f.Application__r.genesis__Account__c);
                if(facilityByAppln.containsKey(f.Application__c)){
                    facilityByAppln.get(f.Application__c).add(f);
                }else{
                    facilityByAppln.put(f.Application__c, new List<Facility__c>{f});
                }
            }
            // get term loan exposure by application
            Map<string, Decimal> custTermLoanExposure   = getCustTermLoanExposure(applIdVsCustId);
            Map<Id,genesis__Application_Collateral__c> prodSecurityMap;

            Map<Id,User> userInfoMap    = SanctionMatrix_Helper.getUserDetail(appOwnerIds);
            system.debug('prodSecurityMap::39::'+facilityIds);
            prodSecurityMap             = SanctionMatrix_Helper.getFacilityCollaterals(facilityIds);
            Set<string> collateralIds   = new Set<string>();
			System.debug('Test prodSecurityMap'+prodSecurityMap);
            Map<String, List<genesis__Application_Collateral__c>> securityByFac     = new Map<String, List<genesis__Application_Collateral__c>>();
            Map<String, Decimal> facilityToatlSecurity                              = new Map<String, Decimal>();
            for(String s : prodSecurityMap.keySet()){
                System.debug('test s'+s);
                collateralIds.add(prodSecurityMap.get(s).genesis__Collateral__c);
                if(securityByFac.containsKey(prodSecurityMap.get(s).Facility__c)){
                    securityByFac.get(prodSecurityMap.get(s).Facility__c).add(prodSecurityMap.get(s));
                }else{
                    securityByFac.put(prodSecurityMap.get(s).Facility__c, new List<genesis__Application_Collateral__c>{prodSecurityMap.get(s)});
                }

                if(facilityToatlSecurity.containsKey(prodSecurityMap.get(s).Facility__c)){
                    Decimal temp    = facilityToatlSecurity.get(prodSecurityMap.get(s).Facility__c) + prodSecurityMap.get(s).genesis__Collateral__r.clcommon__Value__c;
                    facilityToatlSecurity.put(prodSecurityMap.get(s).Facility__c, temp);
                }else{
                    facilityToatlSecurity.put(prodSecurityMap.get(s).Facility__c, prodSecurityMap.get(s).genesis__Collateral__r.clcommon__Value__c);
                }
            }
		System.debug('collateralIds'+collateralIds+' facilityIds '+facilityIds+' parentApplnIds '+parentApplnIds );
            Map<Id,genesis__Application_Collateral__c> allFacSecurityMap;
            allFacSecurityMap           = SanctionMatrix_Helper.getAllFacilityCollaterals(collateralIds, facilityIds, parentApplnIds);
            System.debug(allFacSecurityMap );
            Set<String> relatedProdIds  = new Set<String>();

            // Related Securities's Facility Product
            for(string s : allFacSecurityMap.keySet()){
                System.debug(allFacSecurityMap.get(s).Facility__r.CL_Product__c);
                if(allFacSecurityMap.get(s).Facility__r.CL_Product__c != null){
                    relatedProdIds.add(allFacSecurityMap.get(s).Facility__r.CL_Product__c);
                }
            }
            if(relatedProdIds.size()>0) productIds.addAll(relatedProdIds);

            List<Sanction_Authority_Matrix_Association__c> matrices                         = new List<Sanction_Authority_Matrix_Association__c>();
            matrices                                                                        = SanctionMatrix_Helper.getSanctionMatricRules(productIds);
            Map<String,List<Sanction_Authority_Matrix_Association__c>> ruleByProduct        = new Map<String,List<Sanction_Authority_Matrix_Association__c>>();
            Map<String,String> securityCategorbyProd                                        = new Map<String,String>();
            Map<string, List<Sanction_Authority_Matrix_Association__c>> parentProdAssoctn   = new Map<string, List<Sanction_Authority_Matrix_Association__c>>();
            Map<String, Decimal> fundedLBProdMap                                            = new Map<String, Decimal>();
            Set<String> otherCollaterlySec                                                  = new Set<String>();
            Map<String, Decimal> nonFundPrmSecMap                                           = new Map<String, Decimal>();
            Map<string, Decimal> collateralProdStartMargin                                  = new Map<string, Decimal>();
            Map<string, Decimal> collateralProdEndMargin                                    = new Map<string, Decimal>();
            Map<string, List<Decimal>> collateralStartMarginList                            = new Map<string, List<Decimal>>();
            Map<string, List<Decimal>> collateralEndMarginList                              = new Map<string, List<Decimal>>();
            Set<String> prodSecuMap         = new Set<String>();
			System.debug(matrices);
            for(Sanction_Authority_Matrix_Association__c sm : matrices){
                System.debug('sm'+sm.Security_Type__c);
                string prodId   = sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Product__c;
                if(prodId != null){
                    if(ruleByProduct.containsKey(prodId)){
                        ruleByProduct.get(prodId).add(sm);
                    }else{
                        ruleByProduct.put(prodId, new List<Sanction_Authority_Matrix_Association__c>{sm});
                    }
                }

                if(sm.Product_Security_Authority_Association__c != null){
                    if(parentProdAssoctn.containsKey(sm.Product_Security_Authority_Association__c)){
                        parentProdAssoctn.get(sm.Product_Security_Authority_Association__c).add(sm);
                    }else{
                        parentProdAssoctn.put(sm.Product_Security_Authority_Association__c,new list<Sanction_Authority_Matrix_Association__c>{sm});
                    }
                }

                Decimal margin  = sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Primary_Security_Margin__c;

                if(prodId !=null && productIds.contains(prodId)){
                    //Map to hold funded product Primary Secured by L&B
                    System.debug('sm.Security_Type__c '+sm.Security_Type__c+' Security_Category__c '+sm.Security_Category__c);
                    if(sm.Security_Type__c == 'L & B' && sm.Security_Category__c == 'Primary' && margin > 0){
                        fundedLBProdMap.put(prodId, margin);
                    }
                    System.debug('Test coll'+sm.Collateral_Security_Type__c+' sm.Security_Category__c '+sm.Security_Category__c);
                    if((sm.Collateral_Security_Type__c == 'L & B' || sm.Collateral_Security_Type__c == 'Fixed Deposit' || sm.Collateral_Security_Type__c == 'Bank Deposit'
                            || sm.Collateral_Security_Type__c == 'Fixed Deposit / Bank Deposit') && sm.Security_Category__c == 'Collateral'){
                        otherCollaterlySec.add(prodId);
                    }
                    if(sm.Security_Type__c == 'Fixed Deposit / Bank Deposit' || sm.Security_Type__c == 'Fixed Deposit'
                            || sm.Security_Type__c == 'Bank Deposit' && margin > 0){
                        nonFundPrmSecMap.put(prodId,margin);
                    }
                    if(sm.Security_Category__c == 'Collateral' && sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_Start_Range__c >= 0
                            && sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_End_Range__c >= 0){
                        //collateralProdStartMargin.put(prodId, sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_Start_Range__c);
                        //collateralProdEndMargin.put(prodId, sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_End_Range__c);

                        if(!prodSecuMap.contains(prodId+sm.Product_Security_Authority_Association__r.Product_Security_Association__c)){
                            Decimal startMargin   = sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_Start_Range__c;
                            Decimal endMargin     = sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_End_Range__c;

                            prodSecuMap.add(prodId+sm.Product_Security_Authority_Association__r.Product_Security_Association__c);
                            if(collateralStartMarginList.containsKey(prodId)){
                                collateralStartMarginList.get(prodId).add(startMargin);
                            }else{
                                collateralStartMarginList.put(prodId, new List<Decimal>{startMargin});
                            }
                            if(collateralEndMarginList.containsKey(prodId)){
                                collateralEndMarginList.get(prodId).add(endMargin);
                            }else{
                                collateralEndMarginList.put(prodId, new List<Decimal>{endMargin});
                            }
                        }
                    }
                }

            }
            system.debug('fundedLBProdMap::117::'+fundedLBProdMap);
            system.debug('otherCollaterlySec::118::'+otherCollaterlySec);
            system.debug('nonFundPrmSecMap::119::'+nonFundPrmSecMap);
            system.debug(collateralProdStartMargin+'::collateralProdMargin::120::'+collateralProdEndMargin);

            // Auhthority level Map
            List<Authority_Hierarchy_Level__mdt> authorityLevel = SanctionMatrix_Helper.getAuthorityLevel();
            Map<string,integer> hierarchyLevel                  = SanctionMatrix_Helper.hierarchyLevel(authorityLevel);
            Map<String, Decimal> relatedSecExposure_A           = new Map<String, Decimal>();
            Map<String, Decimal> otherSecExposure_B             = new Map<String, Decimal>();
            Map<String, Decimal> relatedNonFundedExposure_C     = new Map<String, Decimal>();
            Map<String, String> relatedApplnAuthority           = new Map<String, String>();

            Set<String> fundedFacilityUsed                      = new Set<String>();
            Set<String> allOtherFacilityUsed                    = new Set<String>();
            Set<String> nonfundedFacilityUsed                   = new Set<String>();
            for(string s : allFacSecurityMap.keySet()){

                //Exposure Rule A Calcution: Exposure calculation for related funded facilities primary secured by L&B
                if(allFacSecurityMap.get(s).Facility__r.Type__c == 'Funded' && allFacSecurityMap.get(s).Facility__r.Limit_Amount__c != null &&
                        fundedLBProdMap.containsKey(allFacSecurityMap.get(s).Facility__r.CL_Product__c) && !fundedFacilityUsed.contains(allFacSecurityMap.get(s).Facility__c)){
                    fundedFacilityUsed.add(allFacSecurityMap.get(s).Facility__c);
                    Decimal margin   = fundedLBProdMap.get(allFacSecurityMap.get(s).Facility__r.CL_Product__c);
                    Decimal tempExp  = 0;
                    if(margin < 100){
                        tempExp  = ((allFacSecurityMap.get(s).Facility__r.Limit_Amount__c/(100- margin)) * 100).setScale(2);
                    }
                    if(relatedSecExposure_A.containsKey(allFacSecurityMap.get(s).genesis__Collateral__c)){
                        Decimal existExp = relatedSecExposure_A.get(allFacSecurityMap.get(s).genesis__Collateral__c) + tempExp;
                        relatedSecExposure_A.put(allFacSecurityMap.get(s).genesis__Collateral__c, existExp);
                    }else{
                        relatedSecExposure_A.put(allFacSecurityMap.get(s).genesis__Collateral__c, tempExp);
                    }
                }

                // Exposure Rule B Calcution: All other facilities Collaterally secured by
                //  Land & Building, fixed deposit and bank deposit for related facilities
                if(allFacSecurityMap.get(s).Facility__r.Limit_Amount__c != null){
                    if(otherCollaterlySec.contains(allFacSecurityMap.get(s).Facility__r.CL_Product__c) && !allOtherFacilityUsed.contains(allFacSecurityMap.get(s).Facility__c)){
                        allOtherFacilityUsed.add(allFacSecurityMap.get(s).Facility__c);
                        if(otherSecExposure_B.containsKey(allFacSecurityMap.get(s).genesis__Collateral__c)){
                            double tempVal  = (otherSecExposure_B.get(allFacSecurityMap.get(s).genesis__Collateral__c) + allFacSecurityMap.get(s).Facility__r.Limit_Amount__c).setScale(2);
                            otherSecExposure_B.put(allFacSecurityMap.get(s).genesis__Collateral__c, tempVal);
                        }else{
                            otherSecExposure_B.put(allFacSecurityMap.get(s).genesis__Collateral__c, allFacSecurityMap.get(s).Facility__r.Limit_Amount__c);
                        }
                    }
                }

                // Exposure Rule-C Calculation: Non-Funded facilities where the Primary Security is fixed deposit / bank deposit
                //  for related security
                if(allFacSecurityMap.get(s).Facility__r.Type__c == 'Non-Funded' && allFacSecurityMap.get(s).Facility__r.Limit_Amount__c != null
                        && nonFundPrmSecMap.containsKey(allFacSecurityMap.get(s).Facility__r.CL_Product__c) && !nonfundedFacilityUsed.contains(allFacSecurityMap.get(s).Facility__c)){
                    nonfundedFacilityUsed.add(allFacSecurityMap.get(s).Facility__c);
                    Decimal margin    = fundedLBProdMap.get(allFacSecurityMap.get(s).Facility__r.CL_Product__c);
                    Decimal tempExp   = 0;
                    tempExp   = (allFacSecurityMap.get(s).Facility__r.Limit_Amount__c -(allFacSecurityMap.get(s).Facility__r.Limit_Amount__c * (margin/100))).setScale(2);
                    if(relatedNonFundedExposure_C.containsKey(allFacSecurityMap.get(s).genesis__Collateral__c)){
                        Decimal existExp  = relatedNonFundedExposure_C.get(allFacSecurityMap.get(s).genesis__Collateral__c) + tempExp;
                        relatedNonFundedExposure_C.put(allFacSecurityMap.get(s).genesis__Collateral__c, existExp);
                    }else{
                        relatedNonFundedExposure_C.put(allFacSecurityMap.get(s).genesis__Collateral__c, tempExp);
                    }
                }

                string appAuthority     = allFacSecurityMap.get(s).Application__r.Sanction_Authority__c;
                string securityId       = allFacSecurityMap.get(s).genesis__Collateral__c;
                if(appAuthority != null && securityId != null){
                    if(relatedApplnAuthority.containsKey(securityId)){
                        if(hierarchyLevel.get(appAuthority) > hierarchyLevel.get(relatedApplnAuthority.get(securityId))){
                            relatedApplnAuthority.put(securityId, appAuthority);
                        }
                    }else{
                        relatedApplnAuthority.put(securityId,appAuthority);
                    }
                }
            }

            system.debug('relatedSecExposure_A::186::'+relatedSecExposure_A);
            system.debug('otherSecExposure_B::187::'+otherSecExposure_B);
            system.debug('relatedNonFundedExposure_C::188::'+relatedNonFundedExposure_C);
            system.debug('relatedApplnAuthority::189::'+relatedApplnAuthority);

            Map<String, string> appFinalAuthMap                 = new Map<String, string>();
            Map<String, string> appNoAuthFoundMap               = new Map<String, string>();
            Map<String, Decimal> applinResidualMap_D            = new Map<String, Decimal>();
            Map<String, Decimal> applnOtherFacLBExposure_B      = new Map<String, Decimal>();
            Map<String, Decimal> applnNonFacilityExposure_C     = new Map<String, Decimal>();
            Map<String, Decimal> custOverallExposure            = new Map<String, Decimal>();
            Map<String ,Facility__c> primaryfacilityInfo        = new Map<String ,Facility__c>();
            Map<String, string> highestauthorityRelatedSec      = new Map<String, string>();
            Map<String, Decimal> finalCustOverallExposure       = new Map<String, Decimal>();

            for(String appId : facilityByAppln.KeySet()){
                Decimal totalAppExposure_A                  = 0;
                Decimal totalSecurity_A                     = 0;
                Decimal otherFacilityCollateralExposure_B   = 0;
                Decimal nonFundedFacExposure_C              = 0;
                Decimal appOverallExposure                  = 0;
                Map<String, Decimal> appSecurityValueMap    = new Map<String, Decimal>();
                set<string> A_ExposureUsedForsecurity       = new set<string>();
                set<string> B_ExposureUsedForsecurity       = new set<string>();
                set<string> C_ExposureUsedForsecurity       = new set<string>();
                system.debug(userInfoMap.get(appWiseOwnerId.get(appId)).Designation__c+':Test205:'+appWiseOwnerId.get(appId));
                // Application Owner Designation Map
                if(userInfoMap.get(appWiseOwnerId.get(appId)).Designation__c != null){
                    appBMAuthMap.put(appId, userInfoMap.get(appWiseOwnerId.get(appId)).Designation__c);
                }

                //Exposure Rule-A Calulation :Exposure Calculation for all funded facility secured primaraly by L&B
                for(Facility__c fac : facilityByAppln.get(appId)){
                    appOverallExposure += fac.Limit_Amount__c;

                    if(fac.Product_Category__c  == 'SOD'){
                        Decimal limitAmt    = 0;
                        Decimal margin      = 0;
                        if(isRenewal){
                            limitAmt            = fac.Limit_Amount__c;
                            margin              = fundedLBProdMap.get(fac.CL_Product__c);
                        }
                        else if(fac.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || fac.Application__r.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                            limitAmt            = fac.Recommended_Limit__c;
                            margin              = fac.Margin__c;
                        }else if(fac.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                            limitAmt            = fac.Recommended_Limit__c + fac.Existing_Limit__c;
                            margin              = fac.Margin__c;
                        }
                        if(margin != null){
                            if(margin > 100){
                                appNoAuthFoundMap.put(appId, null);
                                break;
                            }else{
                                if(limitAmt > 0 && margin > 0){
                                    totalAppExposure_A  += ((limitAmt/(100- margin) * 100).setScale(2));
                                }else{
                                    totalAppExposure_A += 0;
                                }
                            }
                        }

                        // Primary Facility
                        primaryfacilityInfo.put(fac.Id, fac);
                    }
                    system.debug('-before-totalAppExposure_A --:262:'+totalAppExposure_A );

                    // Exposure Rule-B Calcution: All other facilities Collaterally secured by
                    //  Land & Building, fixed deposit and bank deposit
                    if(otherCollaterlySec.size() > 0 && otherCollaterlySec.contains(fac.CL_Product__c)){
                        otherFacilityCollateralExposure_B   += fac.Limit_Amount__c;
                    }

                    // Exposure Rule C-Calculation:Exposure for Non-Funded facilities where the Primary Security is fixed deposit / bank deposit
                    if(fac.Type__c == 'Non-Funded'){
                        if(nonFundPrmSecMap.containsKey(fac.CL_Product__c) && nonFundPrmSecMap.get(fac.CL_Product__c) != null && fac.Margin__c !=null){
                            nonFundedFacExposure_C  += (fac.Limit_Amount__c - (fac.Limit_Amount__c* (fac.Margin__c/100))).setScale(2);
                        }
                    }

                    if(securityByFac != null && securityByFac.containsKey(fac.Id)){
                        for(genesis__Application_Collateral__c appSec: securityByFac.get(fac.Id)){

                            string collateralId = appSec.genesis__Collateral__c;
                            // A : final exposure calculation with related security facility exposure
                            if(relatedSecExposure_A.size()> 0 && collateralId != null && relatedSecExposure_A.containsKey(collateralId)
                                    && relatedSecExposure_A.get(collateralId) != null && !A_ExposureUsedForsecurity.contains(collateralId)){
                                totalAppExposure_A += relatedSecExposure_A.get(collateralId);
                                A_ExposureUsedForsecurity.add(collateralId);
                            }
                            system.debug('-after-totalAppExposure_A --:262:'+totalAppExposure_A );
                            system.debug('--totalSecurity_A--:263:'+totalSecurity_A);
                            system.debug('appSecurityValueMap::'+appSecurityValueMap);
                            if(collateralId !=null && !appSecurityValueMap.containsKey(collateralId)){
                                appSecurityValueMap.put(collateralId, totalSecurity_A);
                                totalSecurity_A += appSec.genesis__Collateral__r.clcommon__Value__c;
                                //totalSecurity_A += facilityToatlSecurity.get(fac.Id);
                            }

                            // B: Final Other Exposure calculation with related security facility exposure
                            if(otherSecExposure_B.size()> 0 && collateralId !=null && otherSecExposure_B.containsKey(collateralId)
                                    && !B_ExposureUsedForsecurity.contains(collateralId)){
                                otherFacilityCollateralExposure_B += otherSecExposure_B.get(collateralId);
                                B_ExposureUsedForsecurity.add(collateralId);
                            }

                            // C: Final non-funded exposure calculation with related security facility exposure
                            if(relatedNonFundedExposure_C.containsKey(collateralId) && relatedNonFundedExposure_C.get(collateralId) != null
                                    && !C_ExposureUsedForsecurity.contains(collateralId)){
                                nonFundedFacExposure_C += relatedNonFundedExposure_C.get(collateralId);
                                C_ExposureUsedForsecurity.add(collateralId);
                            }

                            if(relatedApplnAuthority !=null && collateralId !=null && relatedApplnAuthority.containsKey(collateralId)){
                                highestauthorityRelatedSec.put(appId,relatedApplnAuthority.get(collateralId));
                            }
                        }
                    }
                }
                system.debug(totalAppExposure_A+'::A_Expo + totalSecurity_A--:231:'+totalSecurity_A);
                //  Residual Value (D) = (Security Value as per master) – A(Total exposure for funded facility secured primaraly by L&B )
                Decimal residualValue_D = (totalSecurity_A - totalAppExposure_A);
                system.debug('--residualValue_D--:231:'+residualValue_D);
                applinResidualMap_D.put(appId, residualValue_D);

                // Exposure Rule-B: Application wise total exposure of other facilities collateraly
                // secured by L&B etc
                if(otherFacilityCollateralExposure_B > 0){
                    applnOtherFacLBExposure_B.put(appId, otherFacilityCollateralExposure_B);
                }

                // Exposure Rule-C : Application Wise total exposre for non-funded facility primary secured by bank/fixed deposit
                if(nonFundedFacExposure_C > 0){
                    applnNonFacilityExposure_C.put(appId, nonFundedFacExposure_C);
                }

                if(residualValue_D < 0){
                    // No Sanction matrix found for application as residual value is < 0
                    // means Security coverage is less than limit
                    //appNoAuthFoundMap.put(appId, null);
                    if(appOverallExposure > 0){
                        appSecurityCoverageMap.put(appId, (totalSecurity_A/appOverallExposure)*100);
                        finalCovgMap.finalCoverage      = (totalSecurity_A/appOverallExposure)*100;
                    }else{
                        appSecurityCoverageMap.put(appId, 0);
                        finalCovgMap.finalCoverage      = 0;
                    }
                    finalCovgMap.message            = INSUFFICIENT_COVERAGE;
                    finalCovgMap.outMsg             = 'Insufficient coverage'+' by Limit Rs. '+ String.ValueOf(-1* residualValue_D);

                    finalCovgMap.CollateralCoverage = appSecurityCoverageMap;
                }else{
                    system.debug(otherFacilityCollateralExposure_B+'::XYX::'+nonFundedFacExposure_C);
                    Decimal allOtherExposure_E  = otherFacilityCollateralExposure_B + nonFundedFacExposure_C;
                    if(allOtherExposure_E > 0){
                        system.debug(residualValue_D+'::XYX::'+allOtherExposure_E);
                        Decimal secCoveragePerc         = 0;
                        finalCovgMap.message            = SUFFICIENT_COVERAGE;
                        finalCovgMap.outMsg             = '';
                        appSecurityCoverageMap.put(appId,((residualValue_D/allOtherExposure_E)*100).setScale(2));
                        finalCovgMap.CollateralCoverage = appSecurityCoverageMap;
                        
                    }else{
                        finalCovgMap.message            = SUFFICIENT_COVERAGE;
                        finalCovgMap.outMsg             = '';
                        if(appOverallExposure > 0){
                            finalCovgMap.finalCoverage      = (totalSecurity_A/appOverallExposure)*100;
                            appSecurityCoverageMap.put(appId, (totalSecurity_A/appOverallExposure)*100);
                        }else{
                            finalCovgMap.message            = INSUFFICIENT_COVERAGE;
                            appSecurityCoverageMap.put(appId, 0);
                            finalCovgMap.finalCoverage      = 0;
                        }
                        finalCovgMap.CollateralCoverage    = appSecurityCoverageMap;
                    }
                }

                // Total Overall limit Exposure by application
                custOverallExposure.put(appId, appOverallExposure);

                // Final Overall Exposure cal (Existing Facilities limit + Term Loan's exposure)
                if(custTermLoanExposure != null && custTermLoanExposure.size() > 0 && custTermLoanExposure.containsKey(appId.left(15))){
                    decimal tempAmt    = custTermLoanExposure.get(appId.left(15)) + appOverallExposure;
                    finalCustOverallExposure.put(appId, tempAmt);
                }else{
                    finalCustOverallExposure.put(appId, appOverallExposure);
                }
            }

            system.debug('applinResidualMap_D::280::'+applinResidualMap_D);
            system.debug('highestauthorityRelatedSec::281::'+highestauthorityRelatedSec);
            system.debug('applnOtherFacLBExposure_B::282::'+applnOtherFacLBExposure_B);
            system.debug('applnNonFacilityExposure_C::283::'+applnNonFacilityExposure_C);
            system.debug('custOverallExposure::285::'+custOverallExposure);
            system.debug('appFinalAuthMap::286::'+appFinalAuthMap);
            system.debug('appSecurityCoverageMap::287::'+appSecurityCoverageMap);
            system.debug('finalCustOverallExposure::285::'+finalCustOverallExposure);
            // code to update security coverage it time
            List<genesis__Applications__c> applnToUpdateForSecCoverage = new List<genesis__Applications__c>();
            for(String s : appWiseOwnerId.keySet()){
                genesis__Applications__c appln  = new genesis__Applications__c();
                appln.Id    = s;
                if(appSecurityCoverageMap.containsKey(s)){
                    appln.Security_coverage__c  = appSecurityCoverageMap.get(s);
                }
                applnToUpdateForSecCoverage.add(appln);

            }
            if(applnToUpdateForSecCoverage.size() > 0){
                ApplicationTriggerHandler.IsFirstRun    = true;
                update applnToUpdateForSecCoverage;    // update application record
            }

            if(methodType == ONLY_COVERAGE_METHOD && !isRenewal) return finalCovgMap;

            if(collateralStartMarginList.size() > 0 && collateralEndMarginList.size() > 0){
                for(string s : productIds){
                    if(prodApplnMap.containsKey(s)){
                        decimal sCoverg = appSecurityCoverageMap.get(prodApplnMap.get(s));

                        if(collateralStartMarginList.containsKey(s)){
                            List<Decimal> startList = collateralStartMarginList.get(s);
                            startList.sort();
                            decimal temp    = 0;
                            for(Integer i=0;i<startList.size();i++){
                                temp = startList[i];
                                if(sCoverg >= 0 && sCoverg >= temp){
                                    collateralProdStartMargin.put(s, startList[i]);
                                }
                            }
                        }
                        if(collateralEndMarginList.containsKey(s)){
                            List<Decimal> endtList  = collateralEndMarginList.get(s);
                            endtList.sort();
                            for(Integer i=0;i<endtList.size();i++){
                                if(sCoverg >= 0 && sCoverg < endtList[i]){
                                    collateralProdEndMargin.put(s, endtList[i]);
                                    break;
                                }
                            }
                        }
                    }
                }
            }

            system.debug(collateralProdStartMargin+':collateralEndMarginList::::'+collateralProdEndMargin);
            Map<String, string> prodAuthMap                 = new Map<String, string>();
            Map<string,Facility__c> finalfacilityDetails    = new Map<string,Facility__c>();
            Map<String, string> overAllExpauthorityMAP      = new Map<String, string>();

            Map<String, List<Sanction_Authority_Matrix_Association__c>> overallExpMatrix    =  SanctionMatrix_Helper.getOverallMatrix();
            system.debug('appBMAuthMap::307::'+appBMAuthMap);
            system.debug('custOverallExposure::307::'+custOverallExposure);
            for(string s : appBMAuthMap.keySet()){
                if((appNoAuthFoundMap.size()== 0 || (appNoAuthFoundMap.size() > 0 && !appNoAuthFoundMap.containsKey(s)))
                        && finalCustOverallExposure.size() > 0 && finalCustOverallExposure.containsKey(s)){
                    if(overallExpMatrix != null && overallExpMatrix.containsKey(appBMAuthMap.get(s))){
                        overAllExpauthorityMAP  = sanctionLimitComparision(s,finalCustOverallExposure.get(s), overallExpMatrix.get(appBMAuthMap.get(s)), appBMAuthMap.get(s));
                    }
                }
            }
            system.debug(collateralProdStartMargin+'::overAllExpauthorityMAP::305::'+overAllExpauthorityMAP);

            for(string appId : facilityByAppln.keySet()){
                if(appNoAuthFoundMap.size()== 0 || (appNoAuthFoundMap.size() > 0 && !appNoAuthFoundMap.containsKey(appId))){
                    // Finding Authority Matrix level for facilities based on Colletral Security coverage value
                    for(Facility__c fac : facilityByAppln.get(appId)){
                        system.debug(appId+'::fac:336:'+fac);
                        if(appSecurityCoverageMap.size()> 0 && appSecurityCoverageMap.containsKey(appId) && appSecurityCoverageMap.get(appId) >= 0){
                            if(collateralProdStartMargin.size() > 0 && collateralProdStartMargin.containsKey(fac.CL_Product__c) && collateralProdEndMargin.size() > 0 && collateralProdEndMargin.containsKey(fac.CL_Product__c)){
                                if(appSecurityCoverageMap.get(appId) >= collateralProdStartMargin.get(fac.CL_Product__c) && appSecurityCoverageMap.get(appId) < collateralProdEndMargin.get(fac.CL_Product__c)){
                                    if(ruleByProduct.containsKey(fac.CL_Product__c)){

                                        for(Sanction_Authority_Matrix_Association__c sm : ruleByProduct.get(fac.CL_Product__c)){
                                            if(sm.Security_Category__c == 'Collateral'
                                                    && collateralProdStartMargin.get(fac.CL_Product__c) == sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_Start_Range__c
                                                    && collateralProdEndMargin.get(fac.CL_Product__c) == sm.Product_Security_Authority_Association__r.Product_Security_Association__r.Security_Coverage_Config__r.Collateral_Margin_End_Range__c
                                                    && sm.Product_Security_Authority_Association__r.Authority_Category__r.Name == userInfoMap.get(fac.Application__r.OwnerId).Designation__c){
                                                prodAuthMap.put(fac.id, sm.Product_Security_Authority_Association__c);
                                                finalfacilityDetails.put(fac.id,fac);
                                            }
                                        }
                                    }

                                }
                            }
                        }
                        // Finding authority matrix for all other facilities
                        system.debug(fac.id+'::primaryfacilityInfo'+primaryfacilityInfo);
                        if(primaryfacilityInfo.size()> 0 && primaryfacilityInfo.containsKey(fac.id)){
                            if(ruleByProduct.containsKey(fac.CL_Product__c)){
                                for(Sanction_Authority_Matrix_Association__c sm : ruleByProduct.get(fac.CL_Product__c)){
                                    if(sm.Security_Category__c != 'Collateral' && sm.Product_Security_Authority_Association__r.Authority_Category__r.Name == userInfoMap.get(fac.Application__r.OwnerId).Designation__c){
                                        prodAuthMap.put(fac.id, sm.Product_Security_Authority_Association__c);
                                        finalfacilityDetails.put(fac.id,fac);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            system.debug('finalfacilityDetails::337::'+finalfacilityDetails);

            Set<string> prodAuthIds = new Set<string>();
            prodAuthIds.addAll(prodAuthMap.values());
            Map<Id,Product_Security_Authority_Association__c> authSancMap;
            authSancMap = SanctionMatrix_Helper.getMatrixRuleByAuthority(prodAuthIds);

            //Final authority calculation
            for(string s : finalfacilityDetails.keySet()){
                string applnId  = finalfacilityDetails.get(s).Application__c;
                if(appNoAuthFoundMap.size()== 0 || (appNoAuthFoundMap.size() > 0 && !appNoAuthFoundMap.containsKey(applnId))){
                    if(prodAuthMap !=null && prodAuthMap.containsKey(s)){
                        string prdAuthId    = prodAuthMap.get(s);
                        if(authSancMap != null && authSancMap.containsKey(prdAuthId)
                                && authSancMap.get(prdAuthId).Sanction_Authority_Matrix_Association__r.size() > 0){
                            for(Sanction_Authority_Matrix_Association__c auth : authSancMap.get(prdAuthId).Sanction_Authority_Matrix_Association__r){
                                string BM_ROle = '';
                                if(appBMAuthMap.size() > 0 && appBMAuthMap.containsKey(applnId)){
                                    BM_ROle  = appBMAuthMap.get(applnId);
                                }
                                system.debug(finalfacilityDetails.get(s).Limit_Amount__c+'::test::441::'+auth.Sanction_Limit__c);
                                if(finalfacilityDetails != null && finalfacilityDetails.get(s).Limit_Amount__c <= auth.Sanction_Limit__c){
                                    if(appFinalAuthMap.containsKey(applnId)){
                                        if(hierarchyLevel.get(auth.Role__c) > hierarchyLevel.get(appFinalAuthMap.get(applnId))){
                                            if(BM_ROle != auth.Role__c) appFinalAuthMap.put(applnId, auth.Role__c);
                                        }
                                    }else{
                                        system.debug(hierarchyLevel.get(auth.Role__c)+'::final 441::'+hierarchyLevel.get(overAllExpauthorityMAP.get(applnId)));
                                        if(overAllExpauthorityMAP.get(applnId) != null && hierarchyLevel.get(overAllExpauthorityMAP.get(applnId)) != null){
                                            if(hierarchyLevel.get(auth.Role__c) > hierarchyLevel.get(overAllExpauthorityMAP.get(applnId))){
                                                appFinalAuthMap.put(applnId,auth.Role__c);
                                            }else{
                                                appFinalAuthMap.put(applnId,overAllExpauthorityMAP.get(applnId));
                                            }
                                        }else{
                                            if(BM_ROle != auth.Role__c) appFinalAuthMap.put(applnId,auth.Role__c);
                                        }
                                    }
                                    break;
                                }
                            }
                        }
                        if(highestauthorityRelatedSec !=null && highestauthorityRelatedSec.containsKey(applnId)){
                            if(hierarchyLevel.get(highestauthorityRelatedSec.get(applnId)) > hierarchyLevel.get(appFinalAuthMap.get(applnId))){
                                appFinalAuthMap.put(applnId,highestauthorityRelatedSec.get(applnId));
                            }
                        }
                    }
                }
            }
            system.debug('appFinalAuthMap::380::'+appFinalAuthMap);
            Map<String,string> divisionMapping = SanctionMatrix_Helper.getDivisonCOMapping();

            if(finalfacilityDetails.size() == 0){
                if(appFinalAuthMap.size() == 0 && overAllExpauthorityMAP.size() > 0){
                    appFinalAuthMap = overAllExpauthorityMAP;
                }
            }

            system.debug('appFinalAuthMap::420::'+appFinalAuthMap);
            boolean isBMFinalAuth_EAE    = false;
            try{
                List<Facility__c> authorityInsert       = new List<Facility__c>();
                List<Facility__c> existingfacToUpdate   = new List<Facility__c>();
                List<Facility__c> nlFinalAuthIFBM       = new List<Facility__c>();
                Boolean IS_NewLOAN_APP                  = false;
                string facChildRTypeId  = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
                for(Facility__c f : facilities){
                    System.debug(' Test f.Application__r.RecordType.DeveloperName'+f.Application__r.RecordType.DeveloperName);
                    System.debug('f.Application__r.New_to_Business__c'+f.Application__r.New_to_Business__c);
                    if(f.Application__r.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE && (f.Application__r.New_to_Business__c || (f.Application__r.Type__c).contains('Takeover'))){
                        IS_NewLOAN_APP  = true;
                        System.debug('$$$$$$$$$'+' Takeover Case or new to buisness inside BM Final Auth');
                        nlFinalAuthIFBM.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,SYSTEM.LABEL.DO_Credit_Officer,2,false,true));
                        nlFinalAuthIFBM.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,'DO_DM',3,true,false));
                    }
                    if(appNoAuthFoundMap.size()== 0 || (appNoAuthFoundMap.size() > 0 && !appNoAuthFoundMap.containsKey(f.Application__c))){
                        if(appBMAuthMap != null && appBMAuthMap.containsKey(f.Application__c) && isRenewal && ((prodSecurityMap.size() > 0 || f.CL_Product__r.Facility_Category__c == 'OCC'))){
                            boolean isFinalAuthority    = false;
                            if(appFinalAuthMap == null ||  !appFinalAuthMap.containsKey(f.Application__c)){
                                isFinalAuthority    = true;
                            }
                            authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,appBMAuthMap.get(f.Application__c),1,isFinalAuthority,false));
                        }
                        if(appFinalAuthMap != null && appFinalAuthMap.containsKey(f.Application__c) && appFinalAuthMap.get(f.Application__c) != null){
                            integer Order = 2; // Higher authority order for each Facility
                            isBMFinalAuth_EAE = true;
                            if(finalFacilityMap != null && !isRenewal){
                                if(finalFacilityMap.containsKey(f.Id)){
                                    Order   = Integer.ValueOf(finalFacilityMap.get(f.Id).Higher_Authority_Order__c) + 1;
                                    finalFacilityMap.get(f.Id).Highest_Authority__c = false;
                                    finalFacilityMap.get(f.Id).Is_Referred_Back_Enabled__c = true;
                                    existingfacToUpdate.add(finalFacilityMap.get(f.Id));
                                }
                            }

                            if(appFinalAuthMap.get(f.Application__c) != null){
                                if(appFinalAuthMap.get(f.Application__c).contains('DO')){
                                    authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,SYSTEM.LABEL.DO_Credit_Officer,Order,false,true));
                                    Order++;
                                }
                                if(appFinalAuthMap.get(f.Application__c).contains('CO')){
                                    string division = userInfoMap.get(f.Application__r.OwnerId).Division;
                                    if(division != null && divisionMapping.containsKey(division.toUpperCase())){
                                        authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,divisionMapping.get(division.toUpperCase()),Order,false,true));
                                        Order++;
                                    }
                                }
                            }

                            // New RMD Authority for EAE Process if Customer overall exposure > 2 crs (configured limit)
                            if(finalFacilityMap == null && finalCustOverallExposure.get(f.Application__c) != null &&
                                    finalCustOverallExposure.get(f.Application__c) > KVB_Company_Details__c.getInstance().Risk_User_Limit__c && f.Application__r.Application_Stage__c != 'Application review'){
                                authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,SYSTEM.LABEL.Risk_User_Role,Order,false,true));
                                Order++;
                            }
                            if(f.Application__r.Type__c !=null && f.Application__r.Type__c.contains('Takeover')){
                                System.debug('$$$$$$$$$'+' Takeover Case');
                                //this map returns authority level we need to get (authority level + 1)
                                String currentHigherRole    = appFinalAuthMap.get(f.Application__c) ;
                                System.debug('$$$$$$$$$'+' currentHigherRole ' + currentHigherRole);
                                String nextHigherRole       = Underwriting_CTRL_Helper.getLevelHirerachyMap(authLevelList,currentHigherRole);
                                System.debug('$$$$$$$$$'+' nextHigherRole ' + nextHigherRole);
                                if(nextHigherRole != null){
                                    System.debug('$$$$$$$$$'+' nextHigherRole not null' + nextHigherRole);
                                    authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,nextHigherRole,Order,true,false));
                                }else{
                                    System.debug('$$$$$$$$$'+' nextHigherRole is null');
                                    authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,appFinalAuthMap.get(f.Application__c),Order,true,false));
                                }
                                //authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,appFinalAuthMap.get(f.Application__c),Order,true,false));
                                //authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,<next authority level>,Order,true,false));
                            }else{
                                System.debug('$$$$$$$$$'+'is not Takeover Case');
                                authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,appFinalAuthMap.get(f.Application__c),Order,true,false));
                            }

                            //authorityInsert.add(SanctionMatrix_Helper.getChildFacility(facChildRTypeId,f.CL_Product__c,f.Id,appFinalAuthMap.get(f.Application__c),Order,true,false));
                        }
                    }
                }

                system.debug(appWiseOwnerId+'::authorityInsert::395::'+authorityInsert);

                List<genesis__Applications__c> applnToUpdate = new List<genesis__Applications__c>();
                List<Task> newTaskList  = new List<Task>();
                List<User> noAthHead    = SanctionUnderwriting_Process.getUserRecord('CO_GM',null);
                for(String s : appWiseOwnerId.keySet()){
                    genesis__Applications__c appln  = new genesis__Applications__c();
                    appln.Id    = s;
                    if(appFinalAuthMap.containsKey(s)){
                        if(appFinalAuthMap.get(s) != null){
                            appln.Sanction_Authority__c = appFinalAuthMap.get(s);
                        }else{
                            isBMFinalAuth_EAE = true;
                            //if(noAthHead.size()>0) newTaskList.add(SanctionUnderwriting_Process.getTaskObj(s,noAthHead[0].Id,'No Sanction Authority Found',''));
                            // Need to handle exception cases when no authority found
                        }
                    }
                    if(appNoAuthFoundMap.size() > 0 && appNoAuthFoundMap.containsKey(s)){
                        isBMFinalAuth_EAE = true;
                        //if(noAthHead.size()>0) newTaskList.add(SanctionUnderwriting_Process.getTaskObj(s,noAthHead[0].Id,'No Sanction Authority Found',''));
                    }
                    if(appSecurityCoverageMap.containsKey(s)){
                        if(isRenewal)
                            appln.Security_coverage__c  = appSecurityCoverageMap.get(s);
                    }
                    if(custOverallExposure.containsKey(s) && custOverallExposure.get(s) != null &&
                            custOverallExposure.get(s) > 0){
                        appln.genesis__Loan_Amount__c = custOverallExposure.get(s);
                    }
                    applnToUpdate.add(appln);
                }
                system.debug('applnToUpdate::416::'+applnToUpdate);
                if(authorityInsert.size() > 0){
                    insert authorityInsert; // Authority Matrix creation
                }
                if(applnToUpdate.size() > 0){
                    ApplicationTriggerHandler.IsFirstRun    = true;
                    update applnToUpdate;    // update application record
                }
                if(newTaskList.size() > 0){
                    TaskFlow_Helper.TASK_TRIGGER_RUNNING  = true;
                    insert newTaskList;    // Insert Task
                }
                if(existingfacToUpdate.size() > 0){
                    update existingfacToUpdate;
                }

                try{
                    if(!isBMFinalAuth_EAE && appFinalAuthMap.isEmpty() && authorityInsert.isEmpty() && appWiseOwnerId != null && appWiseOwnerId.size() > 0 && appWiseOwnerId.keySet().size() > 0 && !isRenewal) {
                        List<string> tempAppId = new List<String>();
                        tempAppId.addAll(appWiseOwnerId.keySet());
                        if(!IS_NewLOAN_APP && Underwriting_CTRL_Helper.BMAuthrecommendationIds != null && Underwriting_CTRL_Helper.BMAuthrecommendationIds.size()>0){
                            Underwriting_CTRL_Helper.markBMAsHighestAuth(Underwriting_CTRL_Helper.BMAuthrecommendationIds,tempAppId[0]);
                        }else if(IS_NewLOAN_APP && nlFinalAuthIFBM.size() > 0){
                            insert nlFinalAuthIFBM;
                        }
                    }
                }catch(Exception ex){
                    system.debug('Exception::'+ex.getMessage());
                }

            }catch(exception e){
                system.debug('exce::403:'+e.getStackTraceString());
                system.debug('exce::403:'+e.getMessage());
                system.debug('exce::403:'+e.getLineNumber());
            }
        }catch(Exception e){
            system.debug('exce::406:'+e.getLineNumber());
            system.debug('exce::406:'+e.getMessage());
            system.debug('exce::406:'+e.getStackTraceString());
        }

        return finalCovgMap;
    }

    public static Map<String,string> sanctionLimitComparision(string appId, decimal limitValue, List<Sanction_Authority_Matrix_Association__c> listToCompare, string role){

        Map<String,string> finalMap         = new Map<String,string>();
        Map<decimal,string> tempMap         = new Map<decimal,string>();
        Map<decimal,decimal> limitDiffMap   = new Map<Decimal,Decimal>();

        for(Sanction_Authority_Matrix_Association__c sa : listToCompare){
            if(limitValue <= sa.Sanction_Limit__c){
                decimal limitDiff   = (sa.Sanction_Limit__c - limitValue);
                tempMap.put(limitDiff, sa.Role__c);
                if(limitDiffMap.containsKey(limitValue)){
                    if(limitDiff < limitDiffMap.get(limitValue)){
                        limitDiffMap.put(limitValue, limitDiff);
                    }
                }else{
                    limitDiffMap.put(limitValue, limitDiff);
                }
            }
        }

        if(limitDiffMap.size() > 0 && tempMap.size()> 0 && limitDiffMap.get(limitValue) != null
                && tempMap.get(limitDiffMap.get(limitValue)) != null ){
            if(role != tempMap.get(limitDiffMap.get(limitValue))){
                finalMap.put(appId, tempMap.get(limitDiffMap.get(limitValue)));
            }
        }

        return finalMap;
    }

    public static Map<string, Decimal> getCustTermLoanExposure(Map<String, string> appIdVsCustId){

        try{
            Map<string, Decimal> finalMap    = new Map<string, Decimal>();
            Set<String> custIds                   = new Set<String>();
            custIds.addAll(appIdVsCustId.Values());

            List<Facility__c> allTermFacility       = getTermFacility(custIds);
            System.debug('#########'+allTermFacility);
            Map<String, Decimal> custTermLoanMap    = getCusWiseTermLoanCal(allTermFacility);
            System.debug('#########'+custTermLoanMap);
            if(custTermLoanMap == null || custTermLoanMap.size() == 0) return null;
            for(string appId : appIdVsCustId.keySet()){
                System.debug('#########'+appId);
                System.debug('custId not in 15 '+appIdVsCustId.get(appId));

                if(appIdVsCustId.get(appId) != null && custTermLoanMap.containsKey((appIdVsCustId.get(appId)).left(15))){
                    System.debug('#########'+custTermLoanMap.get((appIdVsCustId.get(appId)).left(15)));
                    finalMap.put(appId.left(15),custTermLoanMap.get((appIdVsCustId.get(appId)).left(15)));
                }
            }
            System.debug('######### finalMap'+finalMap);
            return finalMap;
        }catch(Exception e){
            return null;
        }

    }
    public static Map<String, Decimal> getCusWiseTermLoanCal(List<Facility__c> allTermFacility){
        try{
            Map<String, Decimal> custWiseTotal  = new Map<String, Decimal>();
            for(Facility__c f : allTermFacility){
                decimal balcOut        = 0;
                decimal amtyetDis      = 0;
                decimal exposureAmount = 0;
                if(f.Balance_Outstandings__c != null){
                    if(f.Balance_Outstandings__c < 0){
                        balcOut = (-1)*f.Balance_Outstandings__c;
                    }else{
                        balcOut = f.Balance_Outstandings__c;
                    }
                }
                if(f.Amount_Yet_disbursed__c != null){
                    if(f.Amount_Yet_disbursed__c < 0){
                        amtyetDis = (-1)*f.Amount_Yet_disbursed__c;
                    }else{
                        amtyetDis = f.Amount_Yet_disbursed__c;
                    }
                }
                exposureAmount += balcOut + amtyetDis;
                String accountId = (String.valueOf(f.Application__r.genesis__Account__c)).left(15);
                if(custWiseTotal.containsKey(accountId)){
                    Decimal temp = custWiseTotal.get(accountId) + exposureAmount;
                    custWiseTotal.put(accountId,temp);
                }else{

                    custWiseTotal.put(accountId,exposureAmount);
                }
            }
            return custWiseTotal;
        }catch(Exception e){
            return null;
        }
    }

    public static List<Facility__c> getTermFacility(Set<String> custIds){
        return [SELECT Id,Application__c,Application__r.genesis__Account__c,Existing_Limit__c,Limit_Amount__c,Balance_Outstandings__c,Amount_Yet_disbursed__c
        FROM Facility__c where RecordType.DeveloperName='Parent' AND Application__r.RecordType.DeveloperName='Term_Loan'
        AND Application__r.genesis__Account__c IN: custIds];
    }

    public class COVERAGE_MAP{
        public string message;
        public string outMsg;
        public Decimal finalCoverage;
        public Map<string,Decimal> CollateralCoverage;
    }
}