/**
 * Created by ET-MARLABS on 07-02-2019.
 */

public with sharing class LimitAssessmentHelper {


    public static void preparePreLiminaryData(String appId){


        LimitAssessment.apprecord                                                       = LimitAssessmentModel.getapplnInformation(appId);

        if(LimitAssessment.apprecord.genesis__Account__r.Date_of_Incorporation__c != null){
            LimitAssessment.dateOfIncorporation                                         = LimitAssessment.apprecord.genesis__Account__r.Date_of_Incorporation__c;
        }
        LimitAssessment.allFacilitiesList                                               = LimitAssessmentModel.getFacilities(appId);
        LimitAssessment.newLoanInputRecord                                              = LimitAssessmentModel.getNewLoanInputRecord(appId);
        LimitAssessment.isNewLoan                                                       = isNewToBuisness(LimitAssessment.apprecord.genesis__Account__r.Id);

        LimitAssessmentHelper.getMaxTenure(appId);
        LimitAssessment.yearList                                                         = LimitAssessmentHelper.getYearList(LimitAssessment.tenureForYearList);


        System.debug('isNewLoan=>'+LimitAssessment.isNewLoan);
        LimitAssessmentHelper.getBaseValueForSalesPurchase(LimitAssessment.apprecord.genesis__Account__r.Id);
        LimitAssessmentHelper.getTenurewiseTLKBVIntrestPorttion(LimitAssessment.apprecord.genesis__Account__r.Id);
        // For Calculating Growth Rate we need New Loan Input Record
        LimitAssessmentHelper.setAdditinalGrowthRate(appId);
        LimitAssessmentHelper.setTaxByConstitution();
        LimitAssessmentHelper.getNewLoandepriciation(LimitAssessment.apprecord.Id);
        LimitAssessmentHelper.createScheduleForOtherAccounts(LimitAssessment.apprecord.genesis__Account__r.Id);

        LimitAssessment.standardGrowthRateNewLoan                                       = Limit_Assessement__c.getValues('Limit Parameters').Standard_Sales_Growth_Rate__c;
        LimitAssessment.standardPurchaseGrowthRateNewLoan                               = Limit_Assessement__c.getValues('Limit Parameters').Standard_Purchase_Growth_Rate__c;

    }

    public static Decimal getBaseValueForSalesPurchase(String custId){

        Decimal baseValue=0.00;
        Integer m68datasize=0;
        Decimal basePurchaseValue=0.00;
        Decimal lygr=0.00;
        Decimal l3ygr=0.00;
        Decimal cyValue=0.00;
        Decimal pyValue=0.00;
        Decimal ptopyValue=0.00;
        Decimal sgrValue=0.00;

        Decimal lyPurchasegr=0.00;
        Decimal l3Purchaseygr=0.00;
        Decimal cyPurchaseValue=0.00;
        Decimal pyPurchaseValue=0.00;
        Decimal ptopyPurchaseValue=0.00;
        Decimal sPurchasegrValue=0.00;
        Decimal lastYearWC=0.00;
        Decimal lastToLastYearWC=0.00;


        try {
            List<M68_Balance_Sheet_Analysis__c> m68DataList = LimitAssessmentModel.getM68ThreeYears(custId);

            if(!LimitAssessment.isNewLoan) {


                for (M68_Balance_Sheet_Analysis__c m68Rec : m68DataList) {

                    // lygr

                    if (m68Rec.Fiscal_Year__c == YearDataConstant.currFiscalYear && m68Rec.Financial_type__c=='Actual') {
                        cyValue = m68Rec.Net_sales__c;
                        cyPurchaseValue = m68Rec.Purchases__c;
                        if (m68Rec.Fixed_Assests_Others__c != null) {
                            LimitAssessment.depritiationBasevalue += m68Rec.Fixed_Assests_Others__c;

                            LimitAssessment.depritiationOther = m68Rec.Fixed_Assests_Others__c;
                        }
                        if (m68Rec.Plant_Machinery__c != null) {
                            LimitAssessment.depritiationBasevalue += m68Rec.Plant_Machinery__c;
                            LimitAssessment.depritiationMachinary = m68Rec.Plant_Machinery__c;
                        }
                        if (m68Rec.Land_Building__c != null) {
                            LimitAssessment.depritiationBasevalue += m68Rec.Land_Building__c;
                            LimitAssessment.depritiationLandAndBuilding = m68Rec.Land_Building__c;
                        }
                        if (m68Rec.Total_Current_Assets__c != null && m68Rec.Total_Current_Liabilities__c != null) {
                            //LimitAssessment.ChangeInWCFromPerfios += m68Rec.Total_Current_Assets__c - m68Rec.Total_Current_Liabilities__c;
                            lastYearWC = m68Rec.Total_Current_Assets__c - m68Rec.Total_Current_Liabilities__c;
                        }

                    }

                    if (m68Rec.Fiscal_Year__c == YearDataConstant.nthFiscalYear && m68Rec.Financial_type__c=='Actual') {
                        pyValue = m68Rec.Net_sales__c;
                        pyPurchaseValue = m68Rec.Purchases__c;
                        if (m68Rec.Total_Current_Assets__c != null && m68Rec.Total_Current_Liabilities__c != null) {
                            //LimitAssessment.ChangeInWCFromPerfios += m68Rec.Total_Current_Assets__c - m68Rec.Total_Current_Liabilities__c;
                            lastToLastYearWC = m68Rec.Total_Current_Assets__c - m68Rec.Total_Current_Liabilities__c;
                        }
                    }

                    if (m68Rec.Fiscal_Year__c == YearDataConstant.n_1_FiscalYear && m68Rec.Financial_type__c=='Actual') {
                        ptopyValue = m68Rec.Net_sales__c;
                        ptopyPurchaseValue = m68Rec.Purchases__c;

                        if (m68Rec.Total_Current_Assets__c != null && m68Rec.Total_Current_Liabilities__c != null) {
                            LimitAssessment.ChangeInWCFromPerfios += m68Rec.Total_Current_Assets__c - m68Rec.Total_Current_Liabilities__c;
                        }
                    }

                    if (m68Rec.Net_sales__c != null && m68Rec.Financial_type__c=='Actual' && (m68Rec.Fiscal_Year__c == YearDataConstant.n_1_FiscalYear || m68Rec.Fiscal_Year__c == YearDataConstant.nthFiscalYear || m68Rec.Fiscal_Year__c == YearDataConstant.currFiscalYear)) {
                        m68datasize++;
                        baseValue += m68Rec.Net_sales__c;
                    }if (m68Rec.Purchases__c != null && m68Rec.Financial_type__c=='Actual' && (m68Rec.Fiscal_Year__c == YearDataConstant.n_1_FiscalYear || m68Rec.Fiscal_Year__c == YearDataConstant.nthFiscalYear || m68Rec.Fiscal_Year__c == YearDataConstant.currFiscalYear)) {

                        basePurchaseValue += m68Rec.Purchases__c;
                    }
                }
                if (LimitAssessment.ChangeInWCFromPerfios != 0.00) {
                    LimitAssessment.ChangeInWCFromPerfios = (lastYearWC - lastToLastYearWC).setScale(2);
                    //LimitAssessment.ChangeInWCFromPerfios = LimitAssessment.ChangeInWCFromPerfios / Decimal.valueOf(m68DataList.size());
                }
                System.debug('m68datasize' + m68datasize);
                baseValue = baseValue / Decimal.valueOf(m68datasize);
                basePurchaseValue = basePurchaseValue / Decimal.valueOf(m68datasize);
                System.debug('@@@@@@@' + baseValue);
                System.debug('@@@@@@@' + cyValue);
                System.debug('@@@@@@@' + pyValue);
                System.debug('@@@@@@@' + ptopyValue);
                if (cyValue != 0.00 && pyValue != 0.00) {
                    lygr = ((cyValue - pyValue) / pyValue) * 100.00;
                }
                if (cyPurchaseValue != 0.00 && pyPurchaseValue != 0.00) {
                    lyPurchasegr = ((cyPurchaseValue - pyPurchaseValue) / pyPurchaseValue) * 100.00;
                }
                if (pyValue != 0.00 && ptopyValue != 0.00) {
                    l3ygr = ((pyValue - ptopyValue) / ptopyValue) * 100.00;
                }
                if (pyPurchaseValue != 0.00 && ptopyPurchaseValue != 0.00) {
                    l3Purchaseygr = ((pyPurchaseValue - ptopyPurchaseValue) / ptopyPurchaseValue) * 100.00;
                }
                if (lygr != null && l3ygr != null) {
                    sgrValue = math.min(lygr, (lygr + l3ygr) / 2);
                }
                if (lyPurchasegr != null && l3Purchaseygr != null) {
                    sPurchasegrValue = math.min(lyPurchasegr, (lyPurchasegr + l3Purchaseygr) / 2);
                }
                System.debug('@@@@@@@' + lygr);
                System.debug('@@@@@@@' + l3ygr);
                System.debug('@@@@@@@' + sgrValue);


                LimitAssessment.baseSalesValue = baseValue;
                LimitAssessment.standardGrowthRate = sgrValue;

                LimitAssessment.basePurchaseValue = basePurchaseValue;
                LimitAssessment.standardPurchaseGrowthRate = sPurchasegrValue;

                System.debug('@@@@@@@' + basePurchaseValue);
                System.debug('@@@@@@@' + sPurchasegrValue);
            }else{

                M68_Balance_Sheet_Analysis__c m68Rec;
                for (M68_Balance_Sheet_Analysis__c rec : m68DataList) {
                    if(rec.Financial_type__c =='Estimated' && rec.Fiscal_Year__c == YearDataConstant.nextEstFiscalYear){
                        m68Rec          = rec;
                    }
                }
                if(m68Rec != null) {
                    if (m68Rec.Fixed_Assests_Others__c != null) {
                        LimitAssessment.baseSalesValue = m68Rec.Net_sales__c;
                    }
                    if (m68Rec.Fixed_Assests_Others__c != null) {
                        LimitAssessment.basePurchaseValue = m68Rec.Purchases__c;
                    }
                    if (m68Rec.Fixed_Assests_Others__c != null) {
                        LimitAssessment.depritiationBasevalue += m68Rec.Fixed_Assests_Others__c;

                        LimitAssessment.depritiationOther = m68Rec.Fixed_Assests_Others__c;
                    }
                    if (m68Rec.Plant_Machinery__c != null) {
                        LimitAssessment.depritiationBasevalue += m68Rec.Plant_Machinery__c;
                        LimitAssessment.depritiationMachinary = m68Rec.Plant_Machinery__c;
                    }
                    if (m68Rec.Land_Building__c != null) {
                        LimitAssessment.depritiationBasevalue += m68Rec.Land_Building__c;
                        LimitAssessment.depritiationLandAndBuilding = m68Rec.Land_Building__c;
                    }
                   /* if (m68Rec.Total_Current_Assets__c != null && m68Rec.Total_Current_Liabilities__c != null) {
                        LimitAssessment.ChangeInWCFromPerfios += m68Rec.Total_Current_Assets__c - m68Rec.Total_Current_Liabilities__c;
                    }*/
                    LimitAssessment.ChangeInWCFromPerfios = 0.00;
                }

            }



        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessmentHelper', 'getBaseValueForSalesPurchase', e);

        }

        return baseValue;
    }
    public static void getMaxTenure(String appId){
        Decimal intrestForWCFacility =0.00;


        List<Facility__c> allTLFacilities = new List<Facility__c>();
        List<Facility__c> allTLTakeOverFacilities = new List<Facility__c>();
        Integer tenure =0;
        for(Facility__c facRec:LimitAssessment.allFacilitiesList){

            if(facRec.Tenure__c >tenure){
                tenure = Integer.valueOf(facRec.Tenure__c);
            }

            if(TermLoanConstants.expansion_CriteriaList.contains(facRec.Purpose_of_Loan__c) ){
                LimitAssessment.isWithInExpansionCriteria = true;
            }

            if(facRec.App_Facility_Type__c =='WC'){
                if(facRec.Recommended_Rate__c != null && facRec.Recommended_Limit__c != null){
                    intrestForWCFacility+= (facRec.Recommended_Rate__c * facRec.Recommended_Rate__c) /100.00;
                }
            }else if(facRec.App_Facility_Type__c =='TL' && !facRec.Takeover__c){
                allTLFacilities.add(facRec);
            }else if(facRec.App_Facility_Type__c =='TL' && facRec.Takeover__c){
                allTLTakeOverFacilities.add(facRec);
            }

        }
        if(!allTLFacilities.isEmpty()){
            //getEmiScheduleForTLFacilities(allTLFacilities);
        }
        if(!allTLTakeOverFacilities.isEmpty()){
            //getEmiScheduleForTLFacilities(allTLTakeOverFacilities);
        }
        System.debug('@@@@@ intrestForWCFacility'+intrestForWCFacility);
        if(tenure != 0){
            LimitAssessment.tenureForYearList = tenure;
            LimitAssessment.maxTenure = tenure/12;
            if(math.mod(tenure,12) > 0){
                LimitAssessment.isMaxTenurePlusOneIsNeeded = true;
                LimitAssessment.maxTenureLoopVariable = LimitAssessment.maxTenure +1;
            }else{
                LimitAssessment.maxTenureLoopVariable = LimitAssessment.maxTenure ;
            }
        }

    }


    public static void getEmiScheduleForTLFacilities(List<Facility__c> tlFacilityList){

    }
    public static Decimal getdepritiatedvalueforGivenYearExisting(Decimal baseValue,Decimal roi, Integer yearValue){
        try {
            if(yearValue == 1){
                return (baseValue * roi )/100.00;
            }else{
                return ( decimal.valueOf(math.pow(Double.valueOf(100.00-roi),Double.valueOf(yearValue-1.00)))/Decimal.valueOf(math.pow(Double.valueOf(100.00),Double.valueOf(Decimal.valueOf(yearValue)-1.00))))*((baseValue * roi )/100.00);
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessmentHelper', 'getdepritiatedvalueforGivenYear', e);
            return null;
        }
    }
    public static Decimal getdepritiatedvalueforGivenYear(Decimal baseValue,Decimal roi, Integer yearValue){
        try {
            Integer howManyMonthsInLast                                             = LimitAssessmentHelper.getMonthsBetweenFiscalYear(LimitAssessment.yearList[0],' TO ');

            Decimal firstYearValue= ((baseValue * roi *Decimal.valueOf(howManyMonthsInLast))/100.00)/12.00;

            if(yearValue == 1){
                return (((baseValue * roi *Decimal.valueOf(howManyMonthsInLast))/100.00)/12.00).setScale(2);
            }else{
                return (( decimal.valueOf(math.pow(Double.valueOf(100.00-roi),Double.valueOf(yearValue-1.00)))/Decimal.valueOf(math.pow(Double.valueOf(100.00),Double.valueOf(Decimal.valueOf(yearValue)-1.00))))*(((baseValue-firstYearValue) * roi )/100.00)).setScale(2);
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessmentHelper', 'getdepritiatedvalueforGivenYear', e);
            return null;
        }
    }
    public static List<Decimal> negateAListFromOther(List<Decimal> firstList,List<Decimal> secondList){
        System.debug(' First List =>'+firstList);
        System.debug(' second List =>'+secondList);
        List<Decimal> valuesToBeReturned = new List<Decimal>();

        if(firstList.size()>secondList.size()){
            for(Integer i=0;i<firstList.size();i++){
                if(i<secondList.size())
                    valuesToBeReturned.add(firstList[i]-secondList[i]);
                else{
                    valuesToBeReturned.add(firstList[i]);
                }
            }
        }else{
            for(Integer i=0;i<secondList.size();i++){
                if(i<firstList.size())
                    valuesToBeReturned.add(firstList[i]-secondList[i]);
                else{
                    valuesToBeReturned.add(secondList[i]);
                }
            }
        }
        return valuesToBeReturned;
    }
    public static List<Decimal> decreasevaluesByGivenRatio(List<Decimal> firstList,decimal ratio,String operation){
        List<Decimal> valuesToBeReturned = new List<Decimal>();

        for(Integer i=0;i<firstList.size();i++){
            if(operation == 'RATIO')
            valuesToBeReturned.add((firstList[i]*100.00)/ratio);
            else if(operation == 'DIVIDE')
            valuesToBeReturned.add((firstList[i])/ratio);
        }
        return valuesToBeReturned;
    }
    public static List<Decimal> addAListToOther(List<Decimal> firstList,List<Decimal> secondList){

        List<Decimal> valuesToBeReturned = new List<Decimal>();
        if(firstList.size()>secondList.size()){
            for(Integer i=0;i<firstList.size();i++){
                if(i<secondList.size())
                    valuesToBeReturned.add(firstList[i]+secondList[i]);
                else{
                    valuesToBeReturned.add(firstList[i]);
                }
            }
        }else{
            for(Integer i=0;i<secondList.size();i++){
                if(i<firstList.size())
                    valuesToBeReturned.add(firstList[i]+secondList[i]);
                else{
                    valuesToBeReturned.add(secondList[i]);
                }
            }
        }
        /*for(Integer i=0;i<firstList.size();i++){
            valuesToBeReturned.add(firstList[i]+secondList[i]);
        }*/
        return valuesToBeReturned;
    }
    public static Decimal getAverageOfIntrestValueonPerfios(String cusId){
        Decimal avgOfTotalInt = 0.00;
        Decimal avgOfTotalCurrentAsset = 0.00;
        try {
            List<Perfios__c> perfiosrecList = LimitAssessmentModel.getPerfiosRecords(cusId);
            if (perfiosrecList != null) {
                for(Perfios__c perRec:perfiosrecList){
                    if(perRec.Total_InterestPaid__c != null){
                        avgOfTotalInt+=perRec.Total_InterestPaid__c;
                    }

                }
                if(perfiosrecList.size()>0)
                avgOfTotalInt = avgOfTotalInt /Decimal.valueOf(perfiosrecList.size());
            }

        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessmentHelper', 'getAverageOfIntrestValueonPerfios', e);
        }
        return avgOfTotalInt;

    }
    public static void setTaxByConstitution(){
        Decimal taxPercentageOnTheBasisOfConstitution = 0.00;
        if(LimitAssessment.apprecord.genesis__Account__r.Constitution__c == 'Partnership'){
            LimitAssessment.taxByConstitution = 30.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Constitution__c == 'Private Limited'){
            LimitAssessment.taxByConstitution = 30.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Constitution__c == 'Public Limited'){
            LimitAssessment.taxByConstitution = 30.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Constitution__c == 'Proprietorship'){
            LimitAssessment.taxByConstitution = 30.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Constitution__c == 'HUF'){
            LimitAssessment.taxByConstitution = 30.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Constitution__c == 'Trust'){
            LimitAssessment.taxByConstitution = 30.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Constitution__c == 'SOLE PROPREITOR'){
                LimitAssessment.taxByConstitution = 30.00;
        }

        if(LimitAssessment.apprecord.genesis__Account__r.Industry_Type__c == 'Manufacturing'){
            LimitAssessment.availableCashFlowForNL =150.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Industry_Type__c == 'Agriculture'){
            LimitAssessment.availableCashFlowForNL =150.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Industry_Type__c == 'Services'){
            LimitAssessment.availableCashFlowForNL =150.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Industry_Type__c == 'Education'){
            LimitAssessment.availableCashFlowForNL =150.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Industry_Type__c == 'OTHERS'){
            LimitAssessment.availableCashFlowForNL =150.00;
        }else if(LimitAssessment.apprecord.genesis__Account__r.Industry_Type__c == 'CONSTRUCTION'){
            LimitAssessment.availableCashFlowForNL =150.00;
        }
    }

    public static List<Decimal> increaseListValueByGivenPercentage (Decimal perValue,List<Decimal> listValues){
        List<Decimal> listValuesToBeReturned = new List<Decimal>();
        for(Decimal value:listValues){
            if(value <0){
                listValuesToBeReturned.add(0.00);
            }else{
                listValuesToBeReturned.add(((value*perValue)/100.00));

            }
        }
        return listValuesToBeReturned;
    }

    public static void getNewLoandepriciation(String appId){
        try {
            List<genesis__Application_Collateral__c> allTLPrimaryCollaterals =LimitAssessmentModel.getAllApplicationColletrForApplication(appId);
            Decimal plantAndMac = 0.00;
            Decimal landAndBuilding = 0.00;
            Decimal Others = 0.00;
            System.debug(allTLPrimaryCollaterals.size());
            Set<String> distinctCollIds = new Set<String>();
            if(!allTLPrimaryCollaterals.isEmpty()){
                for(genesis__Application_Collateral__c appCollRec:allTLPrimaryCollaterals){
                    if(!distinctCollIds.contains(appCollRec.genesis__Collateral__c)) {
                        if (appCollRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.OTHER_RTDN || appCollRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.COMMERCIAL_MACHINERY_RTDN || appCollRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.CONSTRUCTION_EQUIPMENT_RTDN) {

                            if (appCollRec.genesis__Collateral__r.Machinery_Cost__c != null)
                                Others += appCollRec.genesis__Collateral__r.Machinery_Cost__c;

                        } else if (appCollRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.LAND_AND_BUILDING_RTDN && appCollRec.genesis__Collateral__r.Is_TL_Collateral__c) {
                            landAndBuilding += appCollRec.genesis__Collateral__r.Market_Value_2__c != null ? appCollRec.genesis__Collateral__r.Market_Value_2__c : appCollRec.genesis__Collateral__r.Total_Asset_Value__c;
                        }else if (appCollRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.PASSENGER_VEHICLE_RTDN) {
                            System.debug('plantAndMac=>'+plantAndMac);
                            plantAndMac += math.min(appCollRec.genesis__Collateral__r.ExshowRoomPrice_Api__c != null ? appCollRec.genesis__Collateral__r.ExshowRoomPrice_Api__c : 0.00, appCollRec.genesis__Collateral__r.ExShow_Room_Price__c != null ? appCollRec.genesis__Collateral__r.ExShow_Room_Price__c : 0.00);
                            System.debug('plantAndMac=>'+plantAndMac);
                        } else if (appCollRec.genesis__Collateral__r.RecordType.DeveloperName == TermLoanConstants.COMMERCIAL_VEHICLE_RTDN) {

                            plantAndMac += math.min(appCollRec.genesis__Collateral__r.ExshowRoomPrice_Api__c != null ? appCollRec.genesis__Collateral__r.ExshowRoomPrice_Api__c : 0.00, (appCollRec.genesis__Collateral__r.Chassis_Cost__c != null ? appCollRec.genesis__Collateral__r.Chassis_Cost__c : 0.00 + appCollRec.genesis__Collateral__r.Body_Building_Cost__c != null ? appCollRec.genesis__Collateral__r.Body_Building_Cost__c : 0.00));
                            System.debug('plantAndMac=>'+plantAndMac);
                        }
                        distinctCollIds.add(appCollRec.genesis__Collateral__c);
                    }

                }
            }

            System.debug('landAndBuilding=>'+LimitAssessment.depritiationBasevalueNL);
            System.debug('plantAndMac =>'+plantAndMac);
            System.debug('Others =>'+Others);


            LimitAssessment.depritiationBasevalueNL = landAndBuilding+plantAndMac+Others;
            LimitAssessment.depritiationLandAndBuildingNL = landAndBuilding;
            LimitAssessment.depritiationMachinaryNL = plantAndMac;
            LimitAssessment.depritiationOtherNL = Others;
            System.debug('LimitAssessment.depritiationBasevalueNL =>'+LimitAssessment.depritiationBasevalueNL);
            System.debug('LimitAssessment.depritiationLandAndBuildingNL =>'+LimitAssessment.depritiationLandAndBuildingNL);
            System.debug('LimitAssessment.depritiationMachinaryNL =>'+LimitAssessment.depritiationMachinaryNL);
        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessmentHeler','getNewLoandepriciation',e);
        }

    }


    public static void createScheduleForOtherAccounts(String custId){

        List<Current_Account__c> allTLNonKVB = LimitAssessmentModel.getOtherAccountsFromCustomer(custId);
        Map<String,List<emiScheduleWrapper>> scheduleMap = new Map<String, List<emiScheduleWrapper>>();
        Map<String,List<emiScheduleWrapper>> scheduleMapWCOtherAccount = new Map<String, List<emiScheduleWrapper>>();
        // Variables for holding tenure wise other Accounts variable
        List<Decimal> tenureWiseWCIntrestValue = new List<Decimal>();
        List<Decimal> tempList = new List<Decimal>();

        for(Current_Account__c otherAcc:allTLNonKVB){
            if(otherAcc.RecordType.DeveloperName == 'Term_Loan_other'){

                Date firstDate = LimitAssessment.todaysDate;
                Date secondDate = otherAcc.Tenure_Start_Date__c;
                Integer monthsBetween = secondDate.monthsBetween(firstDate);

                Integer tenure  = Integer.valueOf(otherAcc.Tenure__c);
                Decimal emiAmount = getEmi(otherAcc.Sanctioned_Amount__c ,Decimal.valueOf(tenure),otherAcc.Interest_Rate__c );
                System.debug('emiAmount=>'+emiAmount);
                List<emiScheduleWrapper> schedule = createSchedule(otherAcc.Sanctioned_Amount__c,emiAmount,tenure,otherAcc.Interest_Rate__c);
                if(monthsBetween >1){
                    schedule =(List<emiScheduleWrapper>)spliceAGivenDyanmicList(schedule, monthsBetween+1, tenure);
                }
                scheduleMap.put(otherAcc.Name,schedule);

            }
            else if(otherAcc.RecordType.DeveloperName == 'WC_Other'){

                tempList = tenureWiseWCIntrestValue;
                tenureWiseWCIntrestValue = new List<Decimal>();

                Decimal wcIntrest = (otherAcc.Sanctioned_Amount__c * otherAcc.Interest_Rate__c) /100.00;

                for(Integer i=0;i<=otherAcc.Tenure__c /12;i++){

                    if(tempList.size()>0 && i<tempList.size()){
                        tenureWiseWCIntrestValue.add(tempList[i]+wcIntrest);
                    }else{
                        tenureWiseWCIntrestValue.add(wcIntrest);
                    }
                }


            }
        }
        if(!tenureWiseWCIntrestValue.isEmpty()){
            System.debug('tenureWiseWCIntrestValue =>'+tenureWiseWCIntrestValue);
            LimitAssessment.tenureWiseIntPortionOtherAccountWC = tenureWiseWCIntrestValue;
        }

        System.debug('scheduleMap =>'+scheduleMap);
        System.debug('scheduleMap size =>'+scheduleMap.size());

        if(!scheduleMap.isEmpty()){
            LimitAssessment.tenureWiseIntrestPortionNONKVBTLOTHERAccount = getTenureWiseValueFromSchedule(scheduleMap,true);

            System.debug('LimitAssessment.tenureWiseIntrestPortionNONKVBTLOTHERAccount  =>'+LimitAssessment.tenureWiseIntrestPortionNONKVBTLOTHERAccount );
        }

    }

    public static List<Decimal> getTenureWiseWCIntrest(){
        List<Decimal> tenureWiseWCIntrestValue = new List<Decimal>();
        Map<String,List<emiScheduleWrapper>> scheduleMap = new Map<String, List<emiScheduleWrapper>>();


        for(Facility__c facRec:LimitAssessment.allFacilitiesList){
            List<Decimal> tempList = tenureWiseWCIntrestValue;
            tenureWiseWCIntrestValue = new List<Decimal>();
            if(facRec.App_Facility_Type__c == 'WC' && facRec.NTB_Facility_Type__c != 'Renewal' && !facRec.Takeover__c){
                Decimal wcIntrest = (facRec.Recommended_Limit__c * facRec.Recommended_Rate__c) /100.00;
                System.debug('facRec.Tenure__c /12'+facRec.Tenure__c /12);
                for(Integer i=0;i<=facRec.Tenure__c /12;i++){

                    if(tempList.size()>0 && i<tempList.size()){
                        tenureWiseWCIntrestValue.add(tempList[i]+wcIntrest);
                    }else{
                        tenureWiseWCIntrestValue.add(wcIntrest);
                    }
                }

            }else if(facRec.App_Facility_Type__c == 'TL' && !facRec.Takeover__c){
                Integer tenure  = Integer.valueOf(facRec.Tenure__c);
                Decimal emiAmount = getEmi(facRec.Recommended_Limit__c ,Decimal.valueOf(tenure),facRec.Recommended_Rate__c );
                System.debug('emiAmount=>'+emiAmount);

                scheduleMap.put(facRec.Name,createSchedule(facRec.Recommended_Limit__c,emiAmount,tenure,facRec.Recommended_Rate__c));
                System.debug('scheduleMap=>'+scheduleMap);

            }
        }
        /*for(LimitAssessmentHelper.emiScheduleWrapper emiWrap:scheduleMap.values()){

        }*/
        // nl is just tl kvb facilities

        LimitAssessment.tenureWiseIntrestPortionNL = getTenureWiseValueFromSchedule(scheduleMap,false);

        System.debug('tenureWiseIntrestPortionNL'+LimitAssessment.tenureWiseIntrestPortionNL);
        System.debug('tenureWiseWCIntrestValue'+tenureWiseWCIntrestValue);
        return tenureWiseWCIntrestValue;
    }
    public static List<Decimal> getTenureWiseValueFromScheduleForTLRecType(Map<String,List<emiScheduleWrapper>> scheduleMap , Boolean isOtherAccount){
        try {

            List<decimal> tenureWiseIntrestPortion = new List<Decimal>();

            if(!scheduleMap.isEmpty() ){
                System.debug('yearList'+LimitAssessment.yearList);
                Integer howManyMonthsInThisPack = LimitAssessmentHelper.getMonthsBetweenFiscalYear(LimitAssessment.yearList[0],' TO ');
                for(String facname:scheduleMap.keySet()){

                    Integer Counter =0;
                    decimal tvelweMonthAggregate =0.00;
                    decimal intitalYearAggregate =0.00;
                    decimal finalYearAggregate =0.00;
                    Integer elseIfCounter = 0;

                    List<emiScheduleWrapper> wrapList = scheduleMap.get(facname);
                    System.debug('howManyMonthsInThisPack =>'+howManyMonthsInThisPack);
                    Date dateOfDisbursement = LimitAssessment.allTLKVBFacilities.get(facname).Date_of_Disbursement__c;
                    Integer whichMonthToStartFrom = dateOfDisbursement.monthsBetween(LimitAssessment.todaysDate);
                    System.debug('whichMonthToStartFrom =>'+whichMonthToStartFrom);
                    for(Integer i=whichMonthToStartFrom+1;i<wrapList.size();i++){

                        if(i<=howManyMonthsInThisPack+whichMonthToStartFrom){
                            intitalYearAggregate += wrapList[i].intrestComponent;
                            Counter++;
                        }else if(i>howManyMonthsInThisPack+whichMonthToStartFrom && i<=whichMonthToStartFrom+Counter+12){

                            tvelweMonthAggregate += wrapList[i].intrestComponent;
                            elseIfCounter++;
                            if(elseIfCounter == 12){
                                tenureWiseIntrestPortion.add(tvelweMonthAggregate);
                                elseIfCounter =0;
                                tvelweMonthAggregate = 0.00;
                                Counter+=12;

                            }
                        }
                    }
                    System.debug('intitalYearAggregate =>'+intitalYearAggregate);
                    System.debug('tenureWiseIntrestPortion =>'+tenureWiseIntrestPortion);
                    if(intitalYearAggregate != 0.00){
                        if(tenureWiseIntrestPortion != null && tenureWiseIntrestPortion.size()>1){
                            tenureWiseIntrestPortion.add(0,intitalYearAggregate);
                        }else{
                            if(tenureWiseIntrestPortion.size()>0)
                                tenureWiseIntrestPortion.add(0,intitalYearAggregate);
                            else
                                    tenureWiseIntrestPortion.add(intitalYearAggregate);
                        }
                    }
                    if(tvelweMonthAggregate != 0.00){
                        tenureWiseIntrestPortion.add(tvelweMonthAggregate);
                    }
                }

            }
            System.debug('tenureWiseIntrestPortion'+tenureWiseIntrestPortion);
            return tenureWiseIntrestPortion;
        } catch (Exception e) {

            HandleBusinessException.captureError('LimitAssessmentHelper','getTenureWiseValueFromSchedule',e);
            System.debug('tenureWiseIntrestPortion'+e.getMessage()+e.getLineNumber());
            return null;
        }

    }
    public static List<Decimal> getTenureWiseValueFromSchedule(Map<String,List<emiScheduleWrapper>> scheduleMap , Boolean isOtherAccount){
        try {

            List<decimal> tenureWiseIntrestPortion = new List<Decimal>();

            if(!scheduleMap.isEmpty() ){
                System.debug('yearList'+LimitAssessment.yearList);
                Integer howManyMonthsInThisPack = LimitAssessmentHelper.getMonthsBetweenFiscalYear(LimitAssessment.yearList[0],' TO ');
                for(String facname:scheduleMap.keySet()){

                    Integer Counter =0;
                    decimal tvelweMonthAggregate =0.00;
                    decimal intitalYearAggregate =0.00;
                    decimal finalYearAggregate =0.00;
                    Integer elseIfCounter = 0;

                    List<emiScheduleWrapper> wrapList = scheduleMap.get(facname);
                    System.debug('howManyMonthsInThisPack =>'+howManyMonthsInThisPack);
                    for(Integer i=1;i<wrapList.size()+1;i++){

                        if(i<=howManyMonthsInThisPack){
                            intitalYearAggregate += wrapList[i-1].intrestComponent;
                            Counter++;
                        }else if(i>howManyMonthsInThisPack && i<=Counter+12){

                            tvelweMonthAggregate += wrapList[i-1].intrestComponent;
                            elseIfCounter++;
                            if(elseIfCounter == 12){
                                tenureWiseIntrestPortion.add(tvelweMonthAggregate);
                                elseIfCounter =0;
                                tvelweMonthAggregate = 0.00;
                                Counter+=12;

                            }
                        }
                    }
                    System.debug('intitalYearAggregate =>'+intitalYearAggregate);
                    if(intitalYearAggregate != 0.00){
                        if(tenureWiseIntrestPortion != null && tenureWiseIntrestPortion.size()>1){
                            tenureWiseIntrestPortion.add(0,intitalYearAggregate);
                        }else{
                            if(tenureWiseIntrestPortion.size()>0)
                                tenureWiseIntrestPortion.add(0,intitalYearAggregate);
                            else
                                    tenureWiseIntrestPortion.add(intitalYearAggregate);
                        }
                    }
                    if(tvelweMonthAggregate != 0.00){
                        tenureWiseIntrestPortion.add(tvelweMonthAggregate);
                    }
                }

            }/*else if(!scheduleMap.isEmpty() && !isOtherAccount){

                for(String facname:scheduleMap.keySet()){
                    Integer counter = 0;
                    Decimal aggregateForTweleveMonth = 0.00;
                    for(emiScheduleWrapper emiWrap:scheduleMap.get(facname)){
                        counter++;
                        if(counter>12){
                            counter =1;


                            if(tenureWiseIntrestPortion != null && tenureWiseIntrestPortion.size()>counter){
                                tenureWiseIntrestPortion.add(tenureWiseIntrestPortion[counter]+aggregateForTweleveMonth);
                            }else{
                                tenureWiseIntrestPortion.add(aggregateForTweleveMonth);

                            }
                            aggregateForTweleveMonth = emiWrap.intrestComponent;
                        }else{
                            aggregateForTweleveMonth += emiWrap.intrestComponent;
                        }
                    }
                }
            }*/
            System.debug('tenureWiseIntrestPortion'+tenureWiseIntrestPortion);
            return tenureWiseIntrestPortion;
        } catch (Exception e) {

            HandleBusinessException.captureError('LimitAssessmentHelper','getTenureWiseValueFromSchedule',e);
            System.debug('tenureWiseIntrestPortion'+e.getMessage()+e.getLineNumber());
            return null;
        }

    }

    public static void getTenurewiseTLKBVIntrestPorttion(String custId){
        List<Facility__c> allTLKVBFacilities = LimitAssessmentModel.getActiveTlRecordTypeFacilities(custId);
        List<Decimal> tenureWiseTLRTFACILITIESIntrestValue = new List<Decimal>();
        Map<String,List<emiScheduleWrapper>> scheduleMap = new Map<String, List<emiScheduleWrapper>>();
        if(allTLKVBFacilities != null && !allTLKVBFacilities.isEmpty()){

            for(Facility__c facRec:allTLKVBFacilities){
                LimitAssessment.allTLKVBFacilities.put(facRec.Name,facRec);
                Integer tenure  = Integer.valueOf(facRec.Tenure__c);
                Decimal emiAmount = getEmi(facRec.Existing_Limit__c ,Decimal.valueOf(tenure),facRec.Existing_Rate__c );
                System.debug('emiAmount=>'+emiAmount);

                scheduleMap.put(facRec.Name,createSchedule(facRec.Existing_Limit__c,emiAmount,tenure,facRec.Existing_Rate__c));

            }
        }
        System.debug('scheduleMap =>'+scheduleMap);
        if(!scheduleMap.isEmpty()){
            tenureWiseTLRTFACILITIESIntrestValue = getTenureWiseValueFromScheduleForTLRecType(scheduleMap,true);
        }
        System.debug('tenureWiseTLRTFACILITIESIntrestValue =>'+tenureWiseTLRTFACILITIESIntrestValue);
        if(tenureWiseTLRTFACILITIESIntrestValue != null && !tenureWiseTLRTFACILITIESIntrestValue.isEmpty()){
            LimitAssessment.tenureWiseTLRTFACILITIESIntrestValue = tenureWiseTLRTFACILITIESIntrestValue;
        }

        //return tenureWiseTLRTFACILITIESIntrestValue;
    }

    public static void setAdditinalGrowthRate(String appId){

        try {

            /*
                Capacity,Capacity Utilization,Room Capacity,Room Utlization,Seating Capacity,Seating Utilization,Count of Vehicles,Count of Employees,Count of Students,Value of Orders,Cost
                    (Future Parameter Value (all expect cost)  - Current Parameter Value (all except cost))/Current Parameter Value (all except cost);
                    (Future Parameter Value (only cost)  - Current Parameter Value (only cost))/Current Parameter Value (only cost);
            */


            if(LimitAssessment.newLoanInputRecord != null){
                if(LimitAssessment.apprecord.UNIQUE_KEY__c == 'Service - Transport')
                LimitAssessment.isSRTO = LimitAssessmentHelper.getOverallExposure_TL(LimitAssessment.apprecord.genesis__Account__r.Id,LimitAssessment.apprecord.Id,LimitAssessment.apprecord.RecordType.DeveloperName) <= 5000000.00 ? true :false;

                //LimitAssessment.isSRTO = LimitAssessment.newLoanInputRecord.Future_Count_of_Vehicles__c <= 3 ? true :false;

                LimitAssessment.monthafterWhcichAdditionalGrowthHasToBeApplied = (LimitAssessment.todaysDate).monthsBetween(LimitAssessment.newLoanInputRecord.What_is_date_of_comercial_prod__c);
                System.debug('monthafterWhcichAdditionalGrowthHasToBeApplied'+LimitAssessment.monthafterWhcichAdditionalGrowthHasToBeApplied);
                LimitAssessment.totalMonthsForWhichAdditionalGRIsToBeApplyed = Integer.valueOf(LimitAssessment.newLoanInputRecord.Howmany_mnths_to_rlize_fullbenefit__c);


                System.debug(LimitAssessment.totalMonthsForWhichAdditionalGRIsToBeApplyed);
                Decimal futureParameterValuesAllExceptCost = (LimitAssessment.newLoanInputRecord.Future_Capacity__c != null ? (LimitAssessment.newLoanInputRecord.Future_Capacity__c * LimitAssessment.newLoanInputRecord.Future_Capacity_Utilization__c):0.00) +
                        (LimitAssessment.newLoanInputRecord.Future_Room_Capacity__c != null ?(LimitAssessment.newLoanInputRecord.Future_Room_Capacity__c * LimitAssessment.newLoanInputRecord.Future_Room_Utlization__c):0.00) +
                        (LimitAssessment.newLoanInputRecord.Future_Seating_Capacity__c != null ?(LimitAssessment.newLoanInputRecord.Future_Seating_Capacity__c * LimitAssessment.newLoanInputRecord.Future_Seating_Utilization__c):0.00) +
                        + (LimitAssessment.newLoanInputRecord.Future_Count_of_Vehicles__c!=null?LimitAssessment.newLoanInputRecord.Future_Count_of_Vehicles__c:0.00) + (LimitAssessment.newLoanInputRecord.Future_Count_of_Employees__c!=null ?LimitAssessment.newLoanInputRecord.Future_Count_of_Employees__c:0.00) + (LimitAssessment.newLoanInputRecord.Future_Count_of_Students__c!=null ?LimitAssessment.newLoanInputRecord.Future_Count_of_Students__c:0.00) + (LimitAssessment.newLoanInputRecord.Future_Value_of_Orders__c!=null?LimitAssessment.newLoanInputRecord.Future_Value_of_Orders__c:0.00);

                Decimal currentParameterValuesAllExceptCost = (LimitAssessment.newLoanInputRecord.Current_Capacity__c!=null?(LimitAssessment.newLoanInputRecord.Current_Capacity__c * LimitAssessment.newLoanInputRecord.Current_Capacity_Utilization__c):0.00) +
                        (LimitAssessment.newLoanInputRecord.Current_Room_Capacity__c!=null?(LimitAssessment.newLoanInputRecord.Current_Room_Capacity__c * LimitAssessment.newLoanInputRecord.Current_Room_Utlization__c):0.00) +
                        (LimitAssessment.newLoanInputRecord.Current_Seating_Capacity__c!=null?(LimitAssessment.newLoanInputRecord.Current_Seating_Capacity__c * LimitAssessment.newLoanInputRecord.Current_Seating_Utilization__c):0.00) +
                        + (LimitAssessment.newLoanInputRecord.Current_Count_of_Vehicles__c!=null?LimitAssessment.newLoanInputRecord.Current_Count_of_Vehicles__c:0.00 )+ (LimitAssessment.newLoanInputRecord.Current_Count_of_Employees__c !=null ?LimitAssessment.newLoanInputRecord.Current_Count_of_Employees__c :0.00)+( LimitAssessment.newLoanInputRecord.Current_Count_of_Students__c !=null?LimitAssessment.newLoanInputRecord.Current_Count_of_Students__c:0.00)+ (LimitAssessment.newLoanInputRecord.Current_Value_of_Orders__c!=null?LimitAssessment.newLoanInputRecord.Current_Value_of_Orders__c:0.00);


                Decimal futureParameterValuesOnlyCost = LimitAssessment.newLoanInputRecord.Future_Cost__c != null ?LimitAssessment.newLoanInputRecord.Future_Cost__c:0.00;
                Decimal currentParameterValuesOnlyCost = LimitAssessment.newLoanInputRecord.Current_Cost__c != null ?LimitAssessment.newLoanInputRecord.Current_Cost__c:0.00;

                if(futureParameterValuesAllExceptCost != null && currentParameterValuesAllExceptCost != null){
                    /*System.debug('futureParameterValuesOnlyCost'+futureParameterValuesOnlyCost);
                    System.debug('currentParameterValuesAllExceptCost'+currentParameterValuesAllExceptCost);
                    System.debug('currentParameterValuesAllExceptCost'+currentParameterValuesAllExceptCost);*/
                    LimitAssessment.additionalGrowthRate = ((futureParameterValuesAllExceptCost - currentParameterValuesAllExceptCost) / currentParameterValuesAllExceptCost)*100.00;
                    /*System.debug('LimitAssessment.additionalGrowthRate'+LimitAssessment.additionalGrowthRate);*/
                }
                if(futureParameterValuesOnlyCost != null && currentParameterValuesOnlyCost != null){
                    LimitAssessment.additionalPurchaseGrowthRate = ((futureParameterValuesOnlyCost - currentParameterValuesOnlyCost) / currentParameterValuesOnlyCost)*100.00;
                    /*System.debug('LimitAssessment.additionalPurchaseGrowthRate'+LimitAssessment.additionalPurchaseGrowthRate);*/
                }
            }

        } catch (Exception e) {
            HandleBusinessException.captureError('LimitAssessmentHelper', 'setAdditinalGrowthRate', e);
        }
    }
    public static List<String> getYearList(Integer tenure){
        List<String> listToBeReturned = new List<String>();

        Integer currentMonth = LimitAssessment.todaysDate.month();
        Integer tenureMinusCurrentMonth = tenure-currentMonth;

        Integer alreadyHandledMonths = 0;
        Integer currentYear = 0;
        // Initial Year Handling
        if(currentMonth<=3){
                listToBeReturned.add(convertMonthTextToNumber(currentMonth)+'-'+String.valueOf(LimitAssessment.todaysDate.year()) +' TO '+'MAR-'+String.valueOf(LimitAssessment.todaysDate.year()));
                alreadyHandledMonths = 3 - currentMonth;
                currentYear = LimitAssessment.todaysDate.year();
        }else{
            // if tenure has enough months
            // tenure should always be greater than 12 - currentmonth
            if(tenure>12 - currentMonth){
                listToBeReturned.add(convertMonthTextToNumber(currentMonth)+'-'+String.valueOf(LimitAssessment.todaysDate.year()) +' TO '+'MAR-'+String.valueOf(LimitAssessment.todaysDate.year()+1));
                alreadyHandledMonths = 12 - currentMonth +3;
                currentYear = LimitAssessment.todaysDate.year()+1;
            }
            else{
                listToBeReturned.add(convertMonthTextToNumber(currentMonth)+'-'+String.valueOf(LimitAssessment.todaysDate.year()) +' TO '+''+convertMonthTextToNumber(tenure+currentMonth)+String.valueOf(LimitAssessment.todaysDate.year()));
                alreadyHandledMonths = 12 - currentMonth;
                currentYear = LimitAssessment.todaysDate.year();
            }

        }
        System.debug('listToBeReturned =>'+listToBeReturned);

        System.debug('alreadyHandledMonths =>'+alreadyHandledMonths);

        Integer leftOverMonthsAfterIntialYear = tenure - alreadyHandledMonths;
        System.debug('leftOverMonthsAfterIntialYear =>'+leftOverMonthsAfterIntialYear);

        Integer allSets = leftOverMonthsAfterIntialYear / 12 ;
        Integer leftOverForLastYear = math.mod(leftOverMonthsAfterIntialYear,12);
        System.debug('leftOverForLastYear =>'+leftOverForLastYear);
        if(allSets >=1){
            for(Integer i=1;i<=allSets;i++){
                listToBeReturned.add('APR-'+String.valueOf(currentYear)+' TO '+ 'MAR-'+String.valueOf(currentYear+1));
                currentYear++;
            }
        }
        // Handle for leftOverMonths in last year
        if(leftOverForLastYear != 0){
            listToBeReturned.add(getyearValue(currentYear,leftOverForLastYear));
        }

        return listToBeReturned;

    }

    public static string getyearValue(Integer year,Integer monthToBeAdded){
        // don't pass number greater than 12 in monthToBeAdded
        if(monthToBeAdded <=8){
            return 'APR-'+string.valueOf(year)+' TO '+convertMonthTextToNumber(4+monthToBeAdded)+'-'+String.valueOf(year);
        }else if(monthToBeAdded <=11){
            monthToBeAdded = monthToBeAdded-8;
            return 'APR-'+string.valueOf(year)+' TO '+convertMonthTextToNumber(monthToBeAdded)+'-'+String.valueOf(year+1);
        }else{
            return null;
        }
    }

    public static String convertMonthTextToNumber(Integer matrixMonth){
        if(matrixMonth == 1){
            return 'JAN';
        }else if(matrixMonth == 2){
            return 'FEB';
        }else if(matrixMonth == 3){
            return 'MAR';
        }else if(matrixMonth == 4){
            return 'APR';
        }else if(matrixMonth == 5){
            return 'MAY';
        }else if(matrixMonth == 6){
            return 'JUN';
        }else if(matrixMonth == 7){
            return 'JUL';
        }else if(matrixMonth == 8){
            return 'AUG';
        }else if(matrixMonth == 9){
            return 'SEP';
        }else if(matrixMonth == 10){
            return 'OCT';
        }else if(matrixMonth == 11){
            return 'NOV';
        }else{
            return 'DEC';
        }
    }

    public Static Integer getMonthsBetweenFiscalYear(String StrVal,String seprator){
        try{
            System.debug('StrVal =>'+StrVal +'seprator=>'+seprator);
            String s = StrVal;
            String[] str = s.split(seprator);
            String fisrt = str[0]; //FEB-2019
            String second = str[1]; //MAR-2019
            String[] f1year = fisrt.split('-');
            String[] s2year = second.split('-');
            String m1 = f1year[0];
            String m2 = s2year[0];

            Integer y1 = Integer.valueOf(f1year[1]);
            Integer y2 = Integer.valueOf(s2year[1]);
            Integer myVal = 0;
            System.debug('y1 =>'+StrVal +'y2=>'+seprator);
            if(y2 - y1 == 0){
                myVal = Utility.convertMonthTextToNumber(m2) - Utility.convertMonthTextToNumber(m1);
            }
            else if(y2-y1 == 1) {
                myVal = (12 - Utility.convertMonthTextToNumber(m1)) + Utility.convertMonthTextToNumber(m2);
            }
            System.debug('myVal =>'+myVal);
            return (myVal >= 0) ? myVal+1 : null;
        }catch(Exception e){
            System.debug('Error Message ::: ' + e.getMessage());
            return null;
        }
    }



    public static Boolean isNewToBuisness(String custId){
        Integer incorporationYear = LimitAssessment.dateOfIncorporation.year();
        System.debug('incorporationYear =>'+incorporationYear);
        Integer currentYearIN      = Utility.getCurrentYear();
        System.debug('currentYearIN =>'+currentYearIN);
        If(incorporationYear > (currentYearIN -1)){
            return true;
        }else{
            return false;
        }

    }

    public static Boolean isSRTO(String appId){
        New_Loan_Input__c newLoanInput = LimitAssessmentModel.getNewLoanInputRecord(appId);
        System.debug(Limit_Assessement__c.getValues('Limit Parameters').Number_of_Vehicles__c);
        System.debug(newLoanInput.Future_Count_of_Vehicles__c);
        return newLoanInput.Future_Count_of_Vehicles__c <= Limit_Assessement__c.getValues('Limit Parameters').Number_of_Vehicles__c ? true :false;
     }

    public static Boolean checkIfSrtoOrNewToBuisness(String appId,String custId){
        return isSRTO(appId) ? true:isNewToBuisness(custId) ? true:false;
    }

    public static Decimal getEmi(Decimal principle,Decimal tenureInMonths,Decimal monthlyRoi){
        monthlyRoi = monthlyRoi /100.00/12.00;
        return (((principle*monthlyRoi)*math.pow(Double.valueOf(1.00+monthlyRoi),Double.valueOf(tenureInMonths)))/(math.pow(Double.valueOf(1.00+monthlyRoi),Double.valueOf(tenureInMonths)) - 1.00));
    }

    public static List<emiScheduleWrapper> createSchedule(Decimal principle,Decimal emiAmount,Integer tenureInMonths,Decimal monthlyRoi){

        monthlyRoi = monthlyRoi /100.00/12.00;
        List<emiScheduleWrapper> emiWrap = new List<LimitAssessmentHelper.emiScheduleWrapper>();

        for(Integer i=1;i<=tenureInMonths;i++){
            Decimal intrestPortion = emiAmount - (math.pow(Double.valueOf(1.00000 + monthlyRoi) , Double.valueOf(-1 +i)) *(emiAmount - (monthlyRoi * principle)));
            emiWrap.add(new emiScheduleWrapper(i,(emiAmount-intrestPortion).setScale(2),intrestPortion.setScale(2)));

        }
        for(emiScheduleWrapper emiWrapa:emiWrap){
            System.debug('emiWrap Emi=>'+emiWrapa);
        }
        System.debug('emiWrap =>'+emiWrap);
        return emiWrap;
    }

    public static List<Object> spliceAGivenDyanmicList(List<Object> input, Integer ge, Integer l){
        // ge = greate and equal index (from where you wanna have data)
        // l = last index upto which you want data
        //  List<String> sliced = (List<String>)spliceAGivenDyanmicList(data, 1, 3);
        List<Object> output = input.clone();
        for (Integer i = 0; i < ge; i++) output.remove(0);
        Integer elements = l - ge;
        while (output.size() > elements) output.remove(elements);
        return output;
    }

    public class emiScheduleWrapper{

        public Integer monthValue;
        public Decimal principleComponent;
        public Decimal intrestComponent;

        public emiScheduleWrapper(Integer monthValue,Decimal principleComponent,Decimal intrestComponent){
            this.monthValue = monthValue;
            this.principleComponent = principleComponent;
            this.intrestComponent = intrestComponent;
        }
    }

    public static void getExistingIntrestForSrtoCondition(){
        try {
            // 1. Existing IntrestFor WC (KVB Renewal/Takeover) And for Other Account
            //2. TL non KVB
            // 3. Tl RecordType All facilities
            Map<String,List<emiScheduleWrapper>> scheduleMapTakeOver = new Map<String, List<emiScheduleWrapper>>();
            Map<String,List<emiScheduleWrapper>> scheduleMap = new Map<String, List<emiScheduleWrapper>>();
            List<Decimal> tenureWiseWCIntrestValue = new List<Decimal>();
            List<Decimal> tempList = new List<Decimal>();

            for(Facility__c facRec:LimitAssessment.allFacilitiesList){
                tempList = tenureWiseWCIntrestValue;
                tenureWiseWCIntrestValue = new List<Decimal>();
                if(facRec.App_Facility_Type__c == 'WC' && (facRec.NTB_Facility_Type__c == 'Renewal' || facRec.Takeover__c)){
                    Decimal wcIntrest = (facRec.Recommended_Limit__c * facRec.Recommended_Rate__c) /100.00;
                    System.debug('facRec.Tenure__c /12'+facRec.Tenure__c /12);
                    for(Integer i=0;i<=facRec.Tenure__c /12;i++){

                        if(tempList.size()>0 && i<tempList.size()){
                            tenureWiseWCIntrestValue.add(tempList[i]+wcIntrest);
                        }else{
                            tenureWiseWCIntrestValue.add(wcIntrest);
                        }
                    }

                }else if(facRec.App_Facility_Type__c == 'TL' && facRec.Takeover__c){
                    Integer tenure  = Integer.valueOf(facRec.Tenure__c);
                    Decimal emiAmount = getEmi(facRec.Recommended_Limit__c ,Decimal.valueOf(tenure),facRec.Recommended_Rate__c );
                    System.debug('emiAmount=>'+emiAmount);

                    scheduleMapTakeOver.put(facRec.Name,createSchedule(facRec.Recommended_Limit__c,emiAmount,tenure,facRec.Recommended_Rate__c));

                }
            }
            if(!scheduleMapTakeOver.isEmpty()){
                LimitAssessment.tenureWiseIntPortionKVBTakeOverTL = getTenureWiseValueFromSchedule(scheduleMapTakeOver,true);
            }
            if(!tenureWiseWCIntrestValue.isEmpty()){
                LimitAssessment.tenureWiseIntPortionKVBRenewalTakeOverWC = tenureWiseWCIntrestValue;
            }
        } catch (Exception e) {

        }
    }
    public static Decimal getOverallExposure_TL(String accId, String appId,String recType){
        Decimal sum= 0.0;
        if(accId !=null && accId !=''){
            try {
                String termLoanRecType='Term_Loan';
                List<String> listOfRecordType =new List<String>{'SME_AdHoc','SME_Enhancement','SME_Exceeding','SME_NEW_Loan','SME_Renewal'};
                List<String> applicationStagetoBeExcluded = new List<String>{'Discontinued Application','Deactivated Applications','Duplicate Application','New loan - Application rejected','New loan- Declined by customer','Application Rejected','Adhoc- Application created','Enhancement- Delined by customer','Account Closed','Exceeding- Application created'};
                Map<String,Boolean> mapOfAccountExclude = new Map<String,Boolean>();

                if(recType == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                    applicationStagetoBeExcluded.add('New loans - Application created');
                }else if(recType == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    applicationStagetoBeExcluded.add('Enhancement- Application created');
                }
                Map<Id,genesis__Applications__c> mapOfApplication = new Map<Id, genesis__Applications__c>();
                Map<Id,genesis__Applications__c> tempMap = new Map<Id,genesis__Applications__c>([select id,genesis__Account__c,RecordType.DeveloperName,Active__c,Application_Stage__c from genesis__Applications__c where genesis__Account__c=:accid and (Active__c=true OR RecordType.DeveloperName =: termloanrectype) AND Application_Stage__c Not IN:applicationStagetoBeExcluded]);

                if(tempMap.containsKey(appId)){
                    mapOfApplication.put(appId,tempMap.get(appId));
                    tempMap.remove(appId);
                    mapOfApplication.putAll(tempMap);
                }

                Map<Id,Facility__c> mapOfFacilitiesForCurrApp = new Map<Id,Facility__c>([select id,Application__c,Account_Number__c,BRE_Limit__c,Amount_Yet_disbursed__c,Balance_Outstandings__c,Limit_start_date__c,Recommended_Days__c,Application__r.RecordType.DeveloperName from Facility__c where Application__c =:appId AND Active__c=true]);

                if(mapOfFacilitiesForCurrApp !=null && !mapOfFacilitiesForCurrApp.isEmpty()) {
                    for (Facility__c facObj : mapOfFacilitiesForCurrApp.values()) {
                        if(appId !=null && appId !='' && facObj.Application__c == appId ){
                            if(facObj.Account_Number__c !=null){
                                mapOfAccountExclude.put(facObj.Account_Number__c,True);
                            }
                            sum += facObj.BRE_Limit__c;
                        }
                    }
                }

                System.debug('mapOfApplication@@@@@@'+mapOfApplication);
                System.debug('mapOfApplication@@@@@@'+mapOfApplication.size());

                if(mapOfApplication !=null && mapOfApplication.size() > 0){
                    Map<Id,Facility__c> mapOfFacilities = new Map<Id,Facility__c>([select id,Application__c,Account_Number__c,BRE_Limit__c,Amount_Yet_disbursed__c,Balance_Outstandings__c,Limit_start_date__c,Recommended_Days__c,Application__r.RecordType.DeveloperName from Facility__c where Application__c IN : mapOfApplication.keySet() AND Active__c=true And Application__c NOT IN:new List<String>{appId}]);
                    System.debug('mapOfFacilities@@@@'+mapOfFacilities);
                    if(mapOfFacilities !=null && !mapOfFacilities.isEmpty()){
                        for(Facility__c facObj : mapOfFacilities.values()){
                            System.debug(' Record Type'+facObj.Application__r.RecordType.DeveloperName);
                            if(facObj.Application__r.RecordType.DeveloperName !=termloanrectype){
                                
                                if(facObj.Application__c != appId) {
                                    if(facObj.Account_Number__c !=null){
                                        if(mapOfAccountExclude.containsKey(facObj.Account_Number__c) && (facObj.Application__r.RecordType.DeveloperName ==Constants.SME_APP_RECORD_TYPE_ADHOC || facObj.Application__r.RecordType.DeveloperName ==Constants.SME_APP_RECORD_TYPE_EXCEEDING)){
                                            System.debug('Inside @@@@'+facObj.Account_Number__c);
                                        }else{
                                            System.debug('second last else'+facObj.Account_Number__c);
                                            sum += facObj.BRE_Limit__c;
                                        }
                                    }else{
                                        System.debug('last else'+facObj.Account_Number__c);
                                        sum += facObj.BRE_Limit__c;
                                    }
                                }
                            }
                            else{
                                System.debug('term loan '+facObj.id+ '  '+facObj.Amount_Yet_disbursed__c+facObj.Balance_Outstandings__c);
                                if(facObj.Amount_Yet_disbursed__c != null && facObj.Balance_Outstandings__c != null)
                                    sum=sum+facObj.Amount_Yet_disbursed__c.abs() + facObj.Balance_Outstandings__c.abs();
                                else if(facObj.Amount_Yet_disbursed__c != null && facObj.Balance_Outstandings__c == null)
                                    sum=sum+facObj.Amount_Yet_disbursed__c.abs();
                                else if(facObj.Amount_Yet_disbursed__c == null && facObj.Balance_Outstandings__c != null)
                                    sum=sum+facObj.Balance_Outstandings__c.abs();
                            }
                        }
                    }
                    System.debug('mapOfAccountExclude@@@@@'+mapOfAccountExclude);
                }
            } catch (Exception e) {
                HandleBusinessException.captureError('Soql_Util','getOverallExposure_TL',e);
            }
        }
        System.debug('sum'+sum);
        return sum;
    }

}