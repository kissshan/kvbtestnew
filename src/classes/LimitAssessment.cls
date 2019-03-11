global class LimitAssessment {


    public static Decimal baseSalesValue                                                    = 0.00;
    public static Decimal standardGrowthRate                                                = 0.00;
    public static Decimal additionalGrowthRate                                              = 0.00;

    public static Decimal standardGrowthRateNewLoan                                         = 0.00;
    public static Decimal standardPurchaseGrowthRateNewLoan                                 = 0.00;

    public static Decimal basePurchaseValue                                                 = 0.00;
    public static Decimal standardPurchaseGrowthRate                                        = 0.00;
    public static Decimal additionalPurchaseGrowthRate                                      = 0.00;

    public static Decimal depritiationBasevalue                                             =0.00;
    public static Decimal depritiationLandAndBuilding                                       =0.00;
    public static Decimal depritiationMachinary                                             =0.00;
    public static Decimal depritiationOther                                                 =0.00;

    public static Decimal depritiationBasevalueNL                                           =0.00;
    public static Decimal depritiationLandAndBuildingNL                                     =0.00;
    public static Decimal depritiationMachinaryNL                                           =0.00;
    public static Decimal depritiationOtherNL                                               =0.00;

    public static Decimal avgTotlIntrestFromPerfios                                         =0.00;
    public static Decimal ChangeInWCFromPerfios                                             =0.00;

    public static Integer maxTenure                                                         = 0;
    public static Boolean isWithInExpansionCriteria                                         = false;
    public static Boolean isSRTO                                                            = false;
    public static Boolean isNewLoan                                                         = false;

    public static Decimal taxByConstitution                                                 =0.00;
    public static Decimal availableCashFlow                                                 =0.00;
    public static Decimal availableCashFlowForNL                                            =0.00;
    public static genesis__Applications__c apprecord ;
    public static Boolean isAppTakeOver                                                     = false;
    public static Date todaysDate                                                           = System.today();
    public static Date dateOfIncorporation                                                  = System.today();
    public static List<Facility__c> allFacilitiesList                                       = new List<Facility__c>();
    public static List<Decimal> tenureWiseIntrestPortionNL                                  = new List<Decimal>();
    public static List<Decimal> tenureWiseIntrestPortionNONKVBTLOTHERAccount                = new List<Decimal>();
    public static List<Decimal> tenureWiseIntrestPortionNONKVB_WC_OTHERAccount              = new List<Decimal>();

    public static New_Loan_Input__c newLoanInputRecord ;
    public static Integer totalMonthsForWhichAdditionalGRIsToBeApplyed                      = 0;
    public static Decimal salesAGRPerMonth                                                  = 0.00;
    public static Decimal purchaseAGRPerMonth                                               = 0.00;
    public static Integer monthafterWhcichAdditionalGrowthHasToBeApplied                    = 0;
    public static Integer numberOfMonthsInWhichFullPotentialWillBeAchieved                  = 0;
    public static Boolean isMaxTenurePlusOneIsNeeded                                        = false;
    public static Integer maxTenureLoopVariable                                             =0;
    public static Integer tenureForYearList                                                 =0;
    public static List<String> yearList                                                     = new List<String>();

    public static List<Decimal> tenureWiseTLRTFACILITIESIntrestValue                        = new List<Decimal>();

            // List Of Decimals For Handling SRTO Conditions for Existing Intrest
    public static List<Decimal> tenureWiseIntPortionKVBRenewalTakeOverWC                    = new List<Decimal>();
    public static List<Decimal> tenureWiseIntPortionOtherAccountWC                          = new List<Decimal>();
    public static List<Decimal> tenureWiseIntPortionKVBTakeOverTL                           = new List<Decimal>();
    public static Map<String,Facility__c> allTLKVBFacilities                                = new Map<String, Facility__c>();

    @AuraEnabled
    public static List<Account> getAllAccounts(String appId){
        return [Select Id,Name,Industry_Type__c from Account where Industry_Type__c!=null limit 5];
    }
    @AuraEnabled
    public static List<pmaxOnewWrap> getAllPrimarySecuredApplicationCollaterals(String appId){
        try {
            List<genesis__Application_Collateral__c> appCollRecList                         =  [Select Id,Name,Facility__r.Recommended_Rate__c,Facility__c,Facility__r.Name,genesis__Collateral__r.RecordType.DeveloperName,genesis__Collateral__c,Facility__r.App_Facility_Type__c,Facility__r.Margin__c,Facility__r.BRE_Limit__c,genesis__Collateral__r.Machinery_Cost__c,genesis__Collateral__r.Installation_Cost__c,genesis__Collateral__r.Other_Cost__c,genesis__Collateral__r.Tax__c,genesis__Collateral__r.Chassis_Cost__c,genesis__Collateral__r.Body_Building_Cost__c,genesis__Collateral__r.ExshowRoomPrice_Api__c from genesis__Application_Collateral__c where Application__c =:appId And Security_Type__c ='Primary Securities' And Facility__r.App_Facility_Type__c ='TL'];

            Map<String,pmaxOnewWrap> facilityWisePmax1                                      = new Map<String, LimitAssessment.pmaxOnewWrap>();

            for(genesis__Application_Collateral__c appColRec:appCollRecList){

                Decimal minFromLimit                                                        = math.min(appColRec.Facility__r.Recommended_Limit__c != null?appColRec.Facility__r.Recommended_Limit__c:0.00,appColRec.Facility__r.BRE_Limit__c != null ?appColRec.Facility__r.BRE_Limit__c:0.00);
                Decimal EmiRequired                                                         = LimitAssessmentHelper.getEmi(minFromLimit,appColRec.Facility__r.Tenure__c,appColRec.Facility__r.Recommended_Rate__c);

                if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.LAND_AND_BUILDING_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField                                              = appColRec.genesis__Collateral__r.Total_Asset_Value__c != null ?appColRec.genesis__Collateral__r.Total_Asset_Value__c:0.00;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{


                        Decimal sumOfCostField                                              = appColRec.genesis__Collateral__r.Total_Asset_Value__c != null ?appColRec.genesis__Collateral__r.Total_Asset_Value__c:0.00;
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }

                else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.COMMERCIAL_MACHINERY_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField                                              = appColRec.genesis__Collateral__r.Machinery_Cost__c + appColRec.genesis__Collateral__r.Installation_Cost__c+appColRec.genesis__Collateral__r.Other_Cost__c +appColRec.genesis__Collateral__r.Tax__c;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{

                        Decimal sumOfCostField                                              = appColRec.genesis__Collateral__r.Machinery_Cost__c + appColRec.genesis__Collateral__r.Installation_Cost__c+appColRec.genesis__Collateral__r.Other_Cost__c +appColRec.genesis__Collateral__r.Tax__c;
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }

                else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.CONSTRUCTION_EQUIPMENT_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField                                              = appColRec.genesis__Collateral__r.Machinery_Cost__c + appColRec.genesis__Collateral__r.Installation_Cost__c+appColRec.genesis__Collateral__r.Other_Cost__c +appColRec.genesis__Collateral__r.Tax__c;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{

                        Decimal sumOfCostField                                              = appColRec.genesis__Collateral__r.Machinery_Cost__c + appColRec.genesis__Collateral__r.Installation_Cost__c+appColRec.genesis__Collateral__r.Other_Cost__c +appColRec.genesis__Collateral__r.Tax__c;
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }

                else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.OTHER_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField                                              = appColRec.genesis__Collateral__r.Machinery_Cost__c + appColRec.genesis__Collateral__r.Installation_Cost__c+appColRec.genesis__Collateral__r.Other_Cost__c +appColRec.genesis__Collateral__r.Tax__c;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{

                        Decimal sumOfCostField                                              = appColRec.genesis__Collateral__r.Machinery_Cost__c + appColRec.genesis__Collateral__r.Installation_Cost__c+appColRec.genesis__Collateral__r.Other_Cost__c +appColRec.genesis__Collateral__r.Tax__c;
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 + sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }

                else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.COMMERCIAL_VEHICLE_RTDN){

                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField                                              = Math.MIN(appColRec.genesis__Collateral__r.Chassis_Cost__c + appColRec.genesis__Collateral__r.Body_Building_Cost__c , appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c) + appColRec.genesis__Collateral__r.Other_Cost__c + appColRec.genesis__Collateral__r.Tax__c ;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{

                        Decimal sumOfCostField                                              = Math.MIN(appColRec.genesis__Collateral__r.Chassis_Cost__c + appColRec.genesis__Collateral__r.Body_Building_Cost__c , appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c) + appColRec.genesis__Collateral__r.Other_Cost__c + appColRec.genesis__Collateral__r.Tax__c ;
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 +sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }

                else if(appColRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.PASSENGER_VEHICLE_RTDN){
                    if(!facilityWisePmax1.containsKey(appColRec.Facility__c)){

                        Decimal sumOfCostField                                              = math.min(appColRec.genesis__Collateral__r.ExShow_Room_Price__c , appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c) + appColRec.genesis__Collateral__r.clcommon__Insurance_Amount__c +appColRec.genesis__Collateral__r.Registration_cost__c + math.min(50000.00,appColRec.genesis__Collateral__r.Accessories_value__c) ;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }else{

                        Decimal sumOfCostField                                              = math.min(appColRec.genesis__Collateral__r.ExShow_Room_Price__c , appColRec.genesis__Collateral__r.ExshowRoomPrice_Api__c) + appColRec.genesis__Collateral__r.clcommon__Insurance_Amount__c +appColRec.genesis__Collateral__r.Registration_cost__c + math.min(50000.00,appColRec.genesis__Collateral__r.Accessories_value__c) ;
                        sumOfCostField                                                      = facilityWisePmax1.get(appColRec.Facility__c).pmax1 +sumOfCostField;
                        facilityWisePmax1.put(appColRec.Facility__c ,new pmaxOnewWrap(appColRec.Facility__r.Name,appColRec.Facility__c,sumOfCostField,EmiRequired) );

                    }
                }
            }
            return facilityWisePmax1.values();
        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessment','pmax1 calculation',e);
            return null;
        }
    }
    @AuraEnabled
    public static List<pmaxTwowWrap> getPMaxTwoData(String appId){
        try {
            System.debug('appId'+appId);
            //appId                                                                           = 'a4V0l0000004y7FEAQ';
            LimitAssessmentHelper.preparePreLiminaryData(appId);

            avgTotlIntrestFromPerfios                                                       = LimitAssessmentHelper.getAverageOfIntrestValueonPerfios(apprecord.genesis__Account__r.Id);
            List<pmaxTwowWrap> wrapListToBeReturned                                         = new List<pmaxTwowWrap>();

            List<Decimal> getSalesValue                                                     = new List<Decimal>();
            List<Decimal> tenureWisePurchaseValue                                           = new List<Decimal>();
            List<Decimal> tenureWiseDepritioationValue                                      = new List<Decimal>();
            List<Decimal> tenureWiseDepritioationValueNL                                    = new List<Decimal>();
            List<Decimal> tenureWiseAvgIntFromPerfiosValue                                  = new List<Decimal>();
            List<Decimal> tenureWiseChangeInWC                                              = new List<Decimal>();
            Decimal tempData                                                                = 0.00;
            Decimal tempPurchaseData                                                        = 0.00;
            Decimal tempDepritiation                                                        = 0.00;
            System.debug('tenureForYearList'+tenureForYearList);

            System.debug('yearList'+yearList);
            /*standardGrowthRate                                                              = 10.00;
            standardPurchaseGrowthRate                                                      = 10.00;
            additionalGrowthRate                                                            = 50.00;
            additionalPurchaseGrowthRate                                                    = 50.00;*/
            System.debug('totalMonthsForWhichAdditionalGRIsToBeApplyed'+totalMonthsForWhichAdditionalGRIsToBeApplyed);
            System.debug('additionalGrowthRate'+additionalGrowthRate);
            System.debug('additionalPurchaseGrowthRate'+additionalPurchaseGrowthRate);
            salesAGRPerMonth                                                                = additionalGrowthRate/Decimal.valueOf(totalMonthsForWhichAdditionalGRIsToBeApplyed);
            System.debug('salesAGRPerMonth'+salesAGRPerMonth);
            purchaseAGRPerMonth                                                             = additionalPurchaseGrowthRate/Decimal.valueOf(totalMonthsForWhichAdditionalGRIsToBeApplyed);
            System.debug('LimitAssessment.isSRTO'+LimitAssessment.isSRTO);
            if(LimitAssessment.isSRTO){
                standardGrowthRate                                                              = standardGrowthRateNewLoan;
                standardPurchaseGrowthRate                                                      = standardPurchaseGrowthRateNewLoan;
            }
            System.debug('salesAGRPerMonth'+salesAGRPerMonth);
            System.debug('salesAGRPerMonth'+standardGrowthRate);
            System.debug('purchaseAGRPerMonth'+standardPurchaseGrowthRate);
            System.debug('salesAGRPerMonth'+salesAGRPerMonth);
            System.debug('purchaseAGRPerMonth'+purchaseAGRPerMonth);

            Integer monthsAlreadyPassed                                                     = 0;
            Integer monthsAlreadyPassedForAgr                                               = 0;

            List<genesis__Application_Collateral__c> appCollRecList                         =  [Select Id,Name,Facility__r.Recommended_Rate__c,Facility__c,Facility__r.Tenure__c,Facility__r.Recommended_Limit__c,Facility__r.Name,genesis__Collateral__r.RecordType.DeveloperName,genesis__Collateral__c,Facility__r.App_Facility_Type__c,Facility__r.Margin__c,Facility__r.BRE_Limit__c,genesis__Collateral__r.Machinery_Cost__c,genesis__Collateral__r.Installation_Cost__c,genesis__Collateral__r.Other_Cost__c,genesis__Collateral__r.Tax__c,genesis__Collateral__r.Chassis_Cost__c,genesis__Collateral__r.Body_Building_Cost__c,genesis__Collateral__r.ExshowRoomPrice_Api__c from genesis__Application_Collateral__c where Application__c =:appId And Security_Type__c ='Primary Securities' And Facility__r.App_Facility_Type__c ='TL'];

            Map<String,pmaxOnewWrap> facilityWisePmax1 = new Map<String, LimitAssessment.pmaxOnewWrap>();
            Decimal EmiRequired = 0.00;
            for(genesis__Application_Collateral__c appColRec:appCollRecList) {
                Decimal minFromLimit = math.min(appColRec.Facility__r.Recommended_Limit__c != null?appColRec.Facility__r.Recommended_Limit__c:0.00,appColRec.Facility__r.BRE_Limit__c != null ?appColRec.Facility__r.BRE_Limit__c:0.00);

                EmiRequired                                                                 += LimitAssessmentHelper.getEmi(minFromLimit, appColRec.Facility__r.Tenure__c, appColRec.Facility__r.Recommended_Rate__c);
            }
            System.debug('yearList =>'+yearList);
            System.debug('maxTenureLoopVariable =>'+maxTenureLoopVariable);
            for(Integer i=0;i<=maxTenureLoopVariable;i++){

                // Handling Gst Values
                // get the month from which agr has to be applyed
                // upto which additional gr has to be applyed
                //20-35
                //
                //4 months pe additional gr
                // pack pe yearly
                // agrpermonth = agr / (20-35)
                // standardgr + monthsincurrentPach*agrpermonth
                // leftover pe monthly
                Decimal salesGrWhichneedsToBeApplyed                                        = standardGrowthRate;
                Decimal purchaseGrWhichneedsToBeApplyed                                     = standardPurchaseGrowthRate;

                System.debug('salesGrWhichneedsToBeApplyed'+salesGrWhichneedsToBeApplyed);
                System.debug('purchaseGrWhichneedsToBeApplyed'+purchaseGrWhichneedsToBeApplyed);
                // Additional calculation for handling Additional gr
                // 1. check if agr has to be applyed according to date of commercial production
                // if i =0, then see how many month difference bw first year's yearlist

                Integer howManyMonthsInThisPack                                             = LimitAssessmentHelper.getMonthsBetweenFiscalYear(yearList[i],' TO ');
                System.debug(' i= '+i+'howManyMonthsInThisPack =>'+howManyMonthsInThisPack);
                monthsAlreadyPassed                                                         += LimitAssessmentHelper.getMonthsBetweenFiscalYear(yearList[i],' TO ');
                Integer howManyMonthsToAlocate =0;
                System.debug('monthsAlreadyPassed'+monthsAlreadyPassed);
                System.debug('monthafterWhcichAdditionalGrowthHasToBeApplied'+monthafterWhcichAdditionalGrowthHasToBeApplied);
                if(monthsAlreadyPassed>monthafterWhcichAdditionalGrowthHasToBeApplied){
                    // && monthsAlreadyPassed < monthafterWhcichAdditionalGrowthHasToBeApplied+newLoanInputRecord.Howmany_mnths_to_rlize_fullbenefit__c
                    // do this activity only until this condition matces (not required)
                    /*if(monthsAlreadyPassed < monthafterWhcichAdditionalGrowthHasToBeApplied + (newLoanInputRecord.Howmany_mnths_to_rlize_fullbenefit__c -1)){

                    }*/
                    if(monthsAlreadyPassedForAgr <= newLoanInputRecord.Howmany_mnths_to_rlize_fullbenefit__c){
                        /*if()*/
                        System.debug('howManyMonthsToAlocate'+howManyMonthsToAlocate);
                        Integer handlerForFirstPackwithLessMonth                            = Integer.valueOf(newLoanInputRecord.Howmany_mnths_to_rlize_fullbenefit__c )- monthsAlreadyPassedForAgr;
                        System.debug('handlerForFirstPackwithLessMonth'+handlerForFirstPackwithLessMonth);
                        howManyMonthsToAlocate                                              = monthsAlreadyPassed - monthafterWhcichAdditionalGrowthHasToBeApplied - monthsAlreadyPassedForAgr;
                        System.debug('howManyMonthsToAlocate'+howManyMonthsToAlocate);

                        howManyMonthsToAlocate                                              = howManyMonthsToAlocate<handlerForFirstPackwithLessMonth ?howManyMonthsToAlocate:handlerForFirstPackwithLessMonth;
                        monthsAlreadyPassedForAgr                                           += howManyMonthsToAlocate;
                        /*System.debug('monthsAlreadyPassedForAgr'+monthsAlreadyPassedForAgr);
                        System.debug('howManyMonthsToAlocate'+howManyMonthsToAlocate);*/
                    }



                }
                System.debug('howManyMonthsToAlocate'+howManyMonthsToAlocate);
                if(howManyMonthsToAlocate != 0){
                    salesGrWhichneedsToBeApplyed                                            = standardGrowthRate + Decimal.valueOf(howManyMonthsToAlocate) * salesAGRPerMonth;
                    purchaseGrWhichneedsToBeApplyed                                         = standardPurchaseGrowthRate + Decimal.valueOf(howManyMonthsToAlocate) * purchaseAGRPerMonth;
                }


                System.debug('salesGrWhichneedsToBeApplyed'+salesGrWhichneedsToBeApplyed);
                System.debug('purchaseGrWhichneedsToBeApplyed'+purchaseGrWhichneedsToBeApplyed);

                if(i==maxTenureLoopVariable){
                    // Handling Gst Values

                    Integer howManyMonthsInLast                                             = LimitAssessmentHelper.getMonthsBetweenFiscalYear(yearList[maxTenureLoopVariable],' TO ');
                    Decimal monthwiseSGR                                                    = salesGrWhichneedsToBeApplyed/12.00;
                    tempData                                                                = ((getSalesValue[i-1]*monthwiseSGR*howManyMonthsInLast) /(100.00)).setScale(2) + getSalesValue[i-1].setScale(2);

                    tempPurchaseData                                                        = ((tenureWisePurchaseValue[i-1]*(purchaseGrWhichneedsToBeApplyed/12.00)*howManyMonthsInLast) /(100.00)).setScale(2) + tenureWisePurchaseValue[i-1].setScale(2);

                    getSalesValue.add(tempData);
                    tenureWisePurchaseValue.add(tempPurchaseData);

                }else{
                    /*if(i==2){
                        System.debug('i= '+i+' purchaseGrWhichneedsToBeApplyed'+purchaseGrWhichneedsToBeApplyed);
                    }*/
                    if(isNewLoan && i == 0){
                        tempData = baseSalesValue.setScale(2);
                        tempPurchaseData = basePurchaseValue.setScale(2);
                        getSalesValue.add(tempData);
                        tenureWisePurchaseValue.add(tempPurchaseData);
                    }else{
                        if(i==0){
                            System.debug('i= '+i+' salesGrWhichneedsToBeApplyed'+salesGrWhichneedsToBeApplyed);
                            //if(salesGrWhichneedsToBeApplyed > standardGrowthRate){
                                System.debug('inside if'+i);
                                tempData                                                            = (((baseSalesValue*salesGrWhichneedsToBeApplyed) /100.00).setScale(2) + baseSalesValue.setScale(2)).setScale(2);
                                tempPurchaseData                                                    = basePurchaseValue.setScale(2) + ((basePurchaseValue*purchaseGrWhichneedsToBeApplyed) /100.00).setScale(2);
                            /*}else{
                                System.debug('inside else'+i);
                                tempData = baseSalesValue.setScale(2);
                                tempPurchaseData = basePurchaseValue.setScale(2);
                            }*/

                        }else {
                            tempData = ((tempData * salesGrWhichneedsToBeApplyed) / 100.00).setScale(2) + tempData.setScale(2);
                            tempPurchaseData = (tempPurchaseData.setScale(2) + ((tempPurchaseData * purchaseGrWhichneedsToBeApplyed) / 100.00).setScale(2)).setScale(2) ;

                        }
                        getSalesValue.add(tempData);
                        tenureWisePurchaseValue.add(tempPurchaseData);
                    }

                }

            }

            for(Integer i=0;i<maxTenure+2;i++){

                // Depretiation / Amortization calculation
                decimal landAndBuildingDepritiatedValue                                     = 0.00;
                decimal pantAndMachinaryDepritiatedValue                                    = 0.00;
                decimal otherDepritiatedValue                                               = 0.00;
                if(depritiationLandAndBuilding != 0.00){
                    landAndBuildingDepritiatedValue                                         = LimitAssessmentHelper.getdepritiatedvalueforGivenYearExisting(depritiationLandAndBuilding,40.00,i);
                }
                if(depritiationMachinary != 0.00){
                    pantAndMachinaryDepritiatedValue                                        = LimitAssessmentHelper.getdepritiatedvalueforGivenYearExisting(depritiationMachinary,40.00,i);
                }
                if(depritiationOther != 0.00){
                    otherDepritiatedValue                                                   = LimitAssessmentHelper.getdepritiatedvalueforGivenYearExisting(depritiationOther,15.00,i);
                }
                if(i!=0){
                    tenureWiseDepritioationValue.add(landAndBuildingDepritiatedValue.setScale(2) + pantAndMachinaryDepritiatedValue.setScale(2) + otherDepritiatedValue.setScale(2));

                }/*else{
                    tenureWiseDepritioationValue.add(depritiationBasevalue.setScale(2));
                }*/

                // Depretiation for NL

                decimal landAndBuildingDepritiatedValueNL                                   =0.00;
                decimal pantAndMachinaryDepritiatedValueNL                                  =0.00;
                decimal otherDepritiatedValueNL =0.00;
                if(depritiationLandAndBuildingNL != 0.00){
                    System.debug('depritiationLandAndBuildingNL =>'+depritiationLandAndBuildingNL);
                    landAndBuildingDepritiatedValueNL                                       = LimitAssessmentHelper.getdepritiatedvalueforGivenYear(depritiationLandAndBuildingNL,40.00,i);
                    System.debug('landAndBuildingDepritiatedValueNL =>'+landAndBuildingDepritiatedValueNL);
                }
                if(depritiationMachinaryNL != 0.00){
                    System.debug('depritiationMachinaryNL =>'+depritiationMachinaryNL);
                    pantAndMachinaryDepritiatedValueNL                                      = LimitAssessmentHelper.getdepritiatedvalueforGivenYear(depritiationMachinaryNL,40.00,i);
                    System.debug('pantAndMachinaryDepritiatedValueNL =>'+pantAndMachinaryDepritiatedValueNL);
                }
                if(depritiationOtherNL != 0.00){
                    System.debug('depritiationOtherNL =>'+depritiationOtherNL);
                    otherDepritiatedValueNL                                                 = LimitAssessmentHelper.getdepritiatedvalueforGivenYear(depritiationOtherNL,15.00,i);
                    System.debug('otherDepritiatedValueNL =>'+otherDepritiatedValueNL);
                }
                if(i!=0) {
                    tenureWiseDepritioationValueNL.add(landAndBuildingDepritiatedValueNL + pantAndMachinaryDepritiatedValueNL + otherDepritiatedValueNL);
                    tenureWiseAvgIntFromPerfiosValue.add(avgTotlIntrestFromPerfios);
                    tenureWiseChangeInWC.add(ChangeInWCFromPerfios);
                    //tenureWiseChangeInWC.add(ChangeInWCFromPerfios);
                }/*else{
                    tenureWiseDepritioationValueNL.add(depritiationBasevalueNL.setScale(2));
                }*/

                //tenureWiseAvgIntFromPerfiosValue.add(avgTotlIntrestFromPerfios);

            }

            if(isNewLoan){
                LimitAssessmentHelper.getExistingIntrestForSrtoCondition();
               // tenureWiseAvgIntFromPerfiosValue =
               // avgTotlIntrestFromPerfios = tenureWiseAvgIntFromPerfiosValue[0];
                System.debug('tenureWiseIntPortionKVBRenewalTakeOverWC =>'+tenureWiseIntPortionKVBRenewalTakeOverWC);
                System.debug('tenureWiseIntPortionOtherAccountWC =>'+tenureWiseIntPortionOtherAccountWC);
                System.debug('tenureWiseIntPortionKVBTakeOverTL =>'+tenureWiseIntPortionKVBTakeOverTL);
                System.debug('tenureWiseIntrestPortionNONKVBTLOTHERAccount =>'+tenureWiseIntrestPortionNONKVBTLOTHERAccount);
                System.debug('tenureWiseTLRTFACILITIESIntrestValue =>'+tenureWiseTLRTFACILITIESIntrestValue);

                List<Decimal> wctotal = LimitAssessmentHelper.addAListToOther(tenureWiseIntPortionKVBRenewalTakeOverWC,tenureWiseIntPortionOtherAccountWC);

                List<Decimal> tltotal = LimitAssessmentHelper.addAListToOther(tenureWiseIntPortionKVBTakeOverTL,tenureWiseIntrestPortionNONKVBTLOTHERAccount);

                List<Decimal> wcandtl = LimitAssessmentHelper.addAListToOther(wctotal,tltotal);

                List<Decimal> wctlAndTlRecType = LimitAssessmentHelper.addAListToOther(tenureWiseTLRTFACILITIESIntrestValue,wcandtl);
                tenureWiseAvgIntFromPerfiosValue = wctlAndTlRecType;

                avgTotlIntrestFromPerfios = tenureWiseAvgIntFromPerfiosValue[0];

            }


            wrapListToBeReturned.add(new pmaxTwowWrap('Component Name','Base Value',true,yearList));


            wrapListToBeReturned.add(new pmaxTwowWrap('Income/Sales',baseSalesValue.setScale(2),false,getSalesValue));

            wrapListToBeReturned.add(new pmaxTwowWrap('Purchase/Cost',basePurchaseValue.setScale(2),false,tenureWisePurchaseValue));
            List<Decimal> ebitdaValues                                                      = LimitAssessmentHelper.negateAListFromOther(getSalesValue,tenureWisePurchaseValue);
            wrapListToBeReturned.add(new pmaxTwowWrap('EBITDA',(baseSalesValue - basePurchaseValue).setScale(2) ,false,ebitdaValues));

            wrapListToBeReturned.add(new pmaxTwowWrap('Existing Asset',depritiationBasevalue.setScale(2),false,tenureWiseDepritioationValue));
            /*if(!tenureWiseDepritioationValueNL.isEmpty()){
                if(tenureWiseDepritioationValueNL.size()>0){
                    Integer howManyMonthsInLast                                             = LimitAssessmentHelper.getMonthsBetweenFiscalYear(yearList[0],' TO ');
                    tenureWiseDepritioationValueNL[0]                                       =(( tenureWiseDepritioationValueNL[0]*Decimal.valueOf(howManyMonthsInLast))/12.00).setScale(2);
                }
            }*/
            wrapListToBeReturned.add(new pmaxTwowWrap('Depreciation from New Asset',depritiationBasevalueNL.setScale(2),false,tenureWiseDepritioationValueNL));
            List<Decimal> tempebitValues                                                    = LimitAssessmentHelper.negateAListFromOther(ebitdaValues,tenureWiseDepritioationValue);
            List<Decimal> ebitValues                                                        = LimitAssessmentHelper.negateAListFromOther(tempebitValues,tenureWiseDepritioationValueNL);
            wrapListToBeReturned.add(new pmaxTwowWrap('EBIT',(baseSalesValue - basePurchaseValue - depritiationBasevalue-depritiationBasevalueNL).setScale(2),false,ebitValues));

            //if(Lim)
            wrapListToBeReturned.add(new pmaxTwowWrap('Existing Interest (WC and TL)',avgTotlIntrestFromPerfios.setScale(2),false,tenureWiseAvgIntFromPerfiosValue));
            // decrease Existing intrest + intrest from new loan which we haven't calculated yet

            // WC Intrest + New Loan intrest
            // All working capital Facilities
            List<Decimal> tenureWiseWCIntrestValue                                          = LimitAssessmentHelper.getTenureWiseWCIntrest();
            System.debug('tenureWiseWCIntrestValue=>'+tenureWiseWCIntrestValue);
            System.debug('tenureWiseIntrestPortionNL=>'+tenureWiseIntrestPortionNL);

            /*wrapListToBeReturned.add(new pmaxTwowWrap('New Loan WC Intrest',tenureWiseWCIntrestValue[0],false,tenureWiseWCIntrestValue));
            wrapListToBeReturned.add(new pmaxTwowWrap('New Loan TL Intrest',tenureWiseIntrestPortionNL[0],false,tenureWiseIntrestPortionNL));*/
            List<Decimal> newLoanWCPlusTLIntrestValues;
            if(tenureWiseWCIntrestValue != null && tenureWiseIntrestPortionNL != null)
                        newLoanWCPlusTLIntrestValues                                      = LimitAssessmentHelper.addAListToOther(tenureWiseWCIntrestValue,tenureWiseIntrestPortionNL);
            else if(tenureWiseWCIntrestValue== null && tenureWiseIntrestPortionNL != null)
                        newLoanWCPlusTLIntrestValues                                      = tenureWiseIntrestPortionNL;
            else if(tenureWiseWCIntrestValue!= null && tenureWiseIntrestPortionNL == null)
                        newLoanWCPlusTLIntrestValues                                      = tenureWiseWCIntrestValue;
            if(newLoanWCPlusTLIntrestValues.size()>0)
            wrapListToBeReturned.add(new pmaxTwowWrap(' New Interest (WC and TL)',newLoanWCPlusTLIntrestValues[0].setScale(2),false,newLoanWCPlusTLIntrestValues));


            List<Decimal> pbtValues                                                         = LimitAssessmentHelper.negateAListFromOther(ebitValues,LimitAssessmentHelper.addAListToOther(tenureWiseAvgIntFromPerfiosValue,newLoanWCPlusTLIntrestValues));
            Decimal pbtBaseValue                                                            = baseSalesValue - basePurchaseValue - depritiationBasevalue - depritiationBasevalueNL - avgTotlIntrestFromPerfios-newLoanWCPlusTLIntrestValues[0];
            wrapListToBeReturned.add(new pmaxTwowWrap('Profit before tax (PBT)/EBT',pbtBaseValue.setScale(2),false,pbtValues));
            // tax value will on the basis of constitution

            List<Decimal> taxValues                                                         = LimitAssessmentHelper.increaseListValueByGivenPercentage(taxByConstitution,pbtValues);

            wrapListToBeReturned.add(new pmaxTwowWrap('Provision for taxes',taxValues[0],false,taxValues));

            List<Decimal> patValues                                                         = LimitAssessmentHelper.negateAListFromOther(pbtValues,taxValues);
            //wrapListToBeReturned.add(new pmaxTwowWrap('Profit after tax (PAT)',((baseSalesValue - basePurchaseValue - depritiationBasevalue -depritiationBasevalueNL - avgTotlIntrestFromPerfios)-((((baseSalesValue - basePurchaseValue - depritiationBasevalue -depritiationBasevalueNL - avgTotlIntrestFromPerfios- newLoanWCPlusTLIntrestValues[0])*taxByConstitution )/100.00))),false,patValues));
            wrapListToBeReturned.add(new pmaxTwowWrap('Profit after tax (PAT)',(pbtBaseValue-taxValues[0]).setScale(2),false,patValues));
            wrapListToBeReturned.add(new pmaxTwowWrap('Change in Working Capital',ChangeInWCFromPerfios.setScale(2),false,tenureWiseChangeInWC));

            // this method is used for calculating TL nonkvb other Account

            if(apprecord.genesis__Account__r.Date_of_Incorporation__c != null){
                dateOfIncorporation                                                         = apprecord.genesis__Account__r.Date_of_Incorporation__c;
            }

            System.debug(' =>'+tenureWiseIntrestPortionNONKVBTLOTHERAccount);
            List<Decimal> tlIntrestWithTLRT;

            // Code For ocf Base value
            Decimal ocfBaseValue                                                            = pbtBaseValue +depritiationBasevalueNL + depritiationBasevalue + (((pbtBaseValue)*taxByConstitution )/100.00 ) + ChangeInWCFromPerfios - 0.0;

            // Existing Asset Deprition And New Asset depriation
            List<Decimal> tenureWisedepri                                                   = LimitAssessmentHelper.addAListToOther(tenureWiseDepritioationValueNL ,tenureWiseDepritioationValue);

            // Pat And Depritiation
            List<Decimal> patAndDepritiation                                                = LimitAssessmentHelper.addAListToOther(patValues,tenureWisedepri);

            List<Decimal> patTaxAndDepritiation;
            patTaxAndDepritiation                                                           = LimitAssessmentHelper.addAListToOther(patAndDepritiation,taxValues );
            //List<Decimal> tenureWiseTLRTFACILITIESIntrestValue                              = LimitAssessmentHelper.getTenurewiseTLKBVIntrestPorttion(apprecord.genesis__Account__r.Id);
            List<Decimal> patTaxDepriAndChangeInWC;
            patTaxDepriAndChangeInWC                                                        = LimitAssessmentHelper.addAListToOther(tenureWiseChangeInWC,patTaxAndDepritiation );

            List<Decimal> TlIntrestForOCF;
            // New Tl Intrest + Existing(Other Acc +TLRT)
            if(!tenureWiseIntrestPortionNL.isEmpty()){
                //1.tenureWiseIntrestPortionNL
                //2.tenureWiseIntrestPortionNONKVBTLOTHERAccount
                //3.tenureWiseTLRTFACILITIESIntrestValue
                TlIntrestForOCF = tenureWiseIntrestPortionNL;

            }
            System.debug('TlIntrestForOCF'+TlIntrestForOCF);

            if(!tenureWiseIntrestPortionNL.isEmpty())
                System.debug('tenureWiseIntrestPortionNL'+tenureWiseIntrestPortionNL);
            if(!tenureWiseIntrestPortionNONKVBTLOTHERAccount.isEmpty())
                System.debug('tenureWiseIntrestPortionNONKVBTLOTHERAccount'+tenureWiseIntrestPortionNONKVBTLOTHERAccount);

            if(tenureWiseIntrestPortionNONKVBTLOTHERAccount!=null){
                TlIntrestForOCF = LimitAssessmentHelper.addAListToOther(TlIntrestForOCF,tenureWiseIntrestPortionNONKVBTLOTHERAccount);
            }
            if(tenureWiseTLRTFACILITIESIntrestValue != null){
                TlIntrestForOCF = LimitAssessmentHelper.addAListToOther(TlIntrestForOCF,tenureWiseTLRTFACILITIESIntrestValue);

            }

            System.debug('TlIntrestForOCF'+TlIntrestForOCF);

            List<Decimal> ocfValues;
            if(TlIntrestForOCF!=null && !patTaxDepriAndChangeInWC.isEmpty())
            ocfValues                                                         = LimitAssessmentHelper.addAListToOther(patTaxDepriAndChangeInWC,TlIntrestForOCF);

            System.debug('ocfValues'+ocfValues);

            wrapListToBeReturned.add(new pmaxTwowWrap('Opreating Cash Flow',ocfBaseValue.setScale(2),false,ocfValues));

            List<Decimal> currObValues                                                      = LimitAssessmentHelper.addAListToOther(tenureWiseTLRTFACILITIESIntrestValue , tenureWiseIntrestPortionNONKVBTLOTHERAccount);
            if (currObValues != null && currObValues.size()>0) {
                wrapListToBeReturned.add(new pmaxTwowWrap('Current Obligations',currObValues[0].setScale(2),false,currObValues));
            }
            List<Decimal> availCashFlowValues;
            if(ocfValues!=null && currObValues!=null)
            availCashFlowValues                                                             = LimitAssessmentHelper.negateAListFromOther(ocfValues,currObValues);
            if (availCashFlowValues != null && availCashFlowValues.size()>0) {
                wrapListToBeReturned.add(new pmaxTwowWrap('Available CashFlow',availCashFlowValues[0].setScale(2) ,false,availCashFlowValues));
            }

            /*List<Decimal> availCashFlowValuesForNL                                          = LimitAssessmentHelper.decreasevaluesByGivenRatio(availCashFlowValues,availableCashFlowForNL,'RATIO');
            if (availCashFlowValuesForNL != null && availCashFlowValuesForNL.size()>0) {
                wrapListToBeReturned.add(new pmaxTwowWrap('Available Cash For New Loan',availCashFlowValuesForNL[0].setScale(2) ,false,availCashFlowValuesForNL));
            }
            List<Decimal> newLoanDscr                                                       = LimitAssessmentHelper.decreasevaluesByGivenRatio(availCashFlowValuesForNL,EmiRequired /12.00,'DIVIDE');
            if (newLoanDscr != null && newLoanDscr.size()>0) {
                wrapListToBeReturned.add(new pmaxTwowWrap('New Loan DSCR',newLoanDscr[0] ,false,newLoanDscr));
            }*/


            System.debug('wrapListToBeReturned=>'+wrapListToBeReturned);
            return wrapListToBeReturned;
        } catch (Exception e) {

            HandleBusinessException.captureError('LimitAssessment','getPMaxTwoData',e);
            return null;
        }

    }
    public class pmaxOnewWrap{

        @AuraEnabled
        public String FacId;
        @AuraEnabled
        public String FacName;
        @AuraEnabled
        public Decimal pmax1;
        @AuraEnabled
        public Decimal emiRequired;

        public pmaxOnewWrap(String facName,String facId,Decimal pmaDecimal,Decimal emiRequired){
            this.FacId          = facId;
            this.FacName        = facName;
            this.pmax1          = pmaDecimal;
            this.emiRequired    = emiRequired;
        }
    }

    public class pmaxTwowWrap{

        @AuraEnabled
        public String componentName;
        @AuraEnabled
        public Object baseValue;
        @AuraEnabled
        public Boolean isHeader;
        @AuraEnabled
        public List<Object> tenureVsValue;

        public pmaxTwowWrap(String componentName,Object baseValue,Boolean isHeader,List<Object> tenureVsValue){
            this.componentName  = componentName;
            this.baseValue      = baseValue;
            this.isHeader       = isHeader;
            this.tenureVsValue  = tenureVsValue;
        }
    }

}