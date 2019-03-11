/*
* Name          : SME_BRE_Calculator
* Description   : BRE_calculation
* Author        : Dushyant
*/
global class SME_BRE_Score_Calculator {
    public static genesis__Applications__c app = new genesis__Applications__c();
    public static List<Facility__c> facilityList = new List<Facility__c>();
    public static M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
    public static M68_Balance_Sheet_Analysis__c m68DataPrevYear = new M68_Balance_Sheet_Analysis__c();
    public static M68_Balance_Sheet_Analysis__c m68DataEst = new M68_Balance_Sheet_Analysis__c();
    public static M68_Balance_Sheet_Analysis__c m68Data_3_YearPrior = new M68_Balance_Sheet_Analysis__c();
    public static M68_Balance_Sheet_Analysis__c m68DataCurrYear = new M68_Balance_Sheet_Analysis__c();
    public static Expenses__c expance = new Expenses__c();
    public static OtherExpenses__c othExp = new OtherExpenses__c();
    public static List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();
    public static List<Credit_Facility_Detail__c> cfDetailList = new List<Credit_Facility_Detail__c>();
    public static Operations_Detail__c opDetailPrev = new Operations_Detail__c();
    public static Operations_Detail__c oprDetail = new Operations_Detail__c();
    public static Operations_Detail__c oprDetailYTD = new Operations_Detail__c();
    public static List<genesis__Application_s_Scorecard__c> scoreCardResList = new List<genesis__Application_s_Scorecard__c>();
    public static List<Score_weight_max__mdt> maxWeightList = new List<Score_weight_max__mdt>();
    public static List<Score_variable__mdt> scoreVarList = new List<Score_variable__mdt>();
    public static List<clcommon__Bank_Account__c> bankAccList = new List<clcommon__Bank_Account__c>();
    public static List<RankVec__c> rankList = new List<RankVec__c>();
    public static List<genesis__Application_Collateral__c> appCollateralList = new List<genesis__Application_Collateral__c>();
    public static TU_Message__c tuMessage = new TU_Message__c();
    public static List<Derogatory_Information__c> drgInfoList = new List<Derogatory_Information__c>();
    public static Enquiry_Summary__c enqSumm = new Enquiry_Summary__c();
    public static ints__TransUnion_Credit_Report__c tuDetail = new ints__TransUnion_Credit_Report__c();
    public static List<Score_Range__mdt> scorerangeList = new List<Score_Range__mdt>();
    public static List<Credit_Underwriting__c> cuParentList = new List<Credit_Underwriting__c>();
    public static List<Credit_Underwriting__c> cuChildList = new List<Credit_Underwriting__c>();
    public static Map<String,List<Credit_Underwriting__c>> EAE_variables = new Map<String,List<Credit_Underwriting__c>>();
    public static Map<Id,BRE_Category__mdt> categoryMap = new Map<Id,BRE_Category__mdt>();
    public static Map<String,Id> cuParentIdMap = new Map<String,Id>();
    public static Map<String,String> nameWeightMap = new Map<String,String>();
    public static List<genesis__Applications__c> listApplication = new List<genesis__Applications__c>();
    public static Map<String,String> flagNameValueMap = new Map<String,String>();
    public static Map<String,String> nameValueMap = new Map<String,String>();
    public static Map<String,String> nameScoreMap = new Map<String,String>();
    public static Map<String,String> nameRangeMap = new Map<String,String>();
    public static List<clcommon__Collateral_Insurance__c> collInsuranceList = new List<clcommon__Collateral_Insurance__c>();
    public static List<clcommon__Collateral__c> collateralList = new List<clcommon__Collateral__c>();
    public static List<Facility__c> facList = new List<Facility__c>();
    public static List<Renewal_Checklists__c> preCheckList = new List<Renewal_Checklists__c>();
    
    public static Decimal operatingMargin =0.0;
    public static Decimal netProfitMargin =0.0;
    public static Decimal dpdStatusWorst = 0.0;
    public static Decimal debitSumComparedToPrevYrPurch = 0.0;
    public static Decimal overAllExposure = 0.0;
    public static Decimal appOverAllExposure = 0.0;
    
    public static Boolean isAllTaskCompleted = false;
    public static Boolean isAllAppCondCompleted = false;
    public static Id cuParentRecTypeId = Schema.SObjectType.Credit_Underwriting__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
    public static Id cuChildFlagRecTypeId = Schema.SObjectType.Credit_Underwriting__c.getRecordTypeInfosByName().get('Child Flag').getRecordTypeId();
    public static Id cuChildScoreRecTypeId = Schema.SObjectType.Credit_Underwriting__c.getRecordTypeInfosByName().get('Child Application Score').getRecordTypeId();    
    
    public static Integer currentYear = Utility.getCurrentYear();
    public static String cyString = String.valueOf(currentYear);
    public static String fiscalYear = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
    public static String prevFiscalYear = (currentYear-2)+'-'+Integer.valueOf(String.valueOf(currentYear-1).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
    public static String prior_3_fiscalYear = (currentYear-3)+'-'+Integer.valueOf(String.valueOf(currentYear-2).subString(String.valueOf(currentYear-2).length()-2,String.valueOf(currentYear-2).length()));
    public static String nextFY = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
    
    public static void queryService(String appId){//1
        //Application query
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get('genesis__Applications__c' ).getDescribe().fields.getMap();
        
        String query = 'SELECT ';
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';
        }
        query   = query + 'genesis__Account__r.Date_of_Incorporation__c,genesis__Account__r.CUSTSINCE__c,RecordType.DeveloperName,(SELECT Id,Existing_Limit__c,Limit_Amount__c,Balance_Outstandings__c,Amount_Yet_disbursed__c FROM Facilities__r) ';
        query   = query + ' FROM genesis__Applications__c WHERE Id =: appId';
        app = Database.query(query);
        String accId = app.genesis__Account__c;
        //Feching all necessary data for the calculation
        try{
            m68Data = [SELECT Fiscal_Year__c,Total_Net_Worth__c,Total_Term_Liabilities__c,Account__r.Succession_plan__c,Income_tax_paid__c,Interest_Expense__c,Depreciation__c,Account__r.Management_experience__c,Account__r.Court_cases_non_credit_related__c,Account__r.Nature_of_product_manufactured_traded__c,Account__r.Selling_and_distribution_arrangement__c,Account__r.Industry_outlook__c,Account__r.Competition__c,Account__r.Government_policies__c,Account__r.External_certifications__c,Purchases__c,Total_Current_Assets__c,TOL_TNW_Ratio__c,Debtors_Velocity_days__c,Creditors_Velocity_days__c,Inventories__c,Total_Current_Liabilities__c,Stock_Turnover_Ratio__c,Net_Profit_Margin__c,Net_Working_Capital__c,Account__r.Since_Year__c,Total_Non_Current_Assets__c,Account__r.CA_with_other_banks__c,Account__r.CIBIL_Score__c,Account__r.Due_date_of_last_stock_statement_not_upl__c,Account__r.Date_of_Incorporation__c,Net_sales__c,Net_profit__c,Current_Ratio__c FROM M68_Balance_Sheet_Analysis__c WHERE Fiscal_Year__c =: fiscalYear AND Account__c =: app.genesis__Account__c AND Financial_type__c = 'Actual' ORDER BY CreatedDate DESC LIMIT 1];
        }catch(Exception qe){}
        try{
            m68DataCurrYear = [SELECT Fiscal_Year__c,Total_Net_Worth__c,Total_Term_Liabilities__c,Account__r.Succession_plan__c,Income_tax_paid__c,Interest_Expense__c,Depreciation__c,Account__r.Management_experience__c,Account__r.Court_cases_non_credit_related__c,Account__r.Nature_of_product_manufactured_traded__c,Account__r.Selling_and_distribution_arrangement__c,Account__r.Industry_outlook__c,Account__r.Competition__c,Account__r.Government_policies__c,Account__r.External_certifications__c,Purchases__c,Total_Current_Assets__c,TOL_TNW_Ratio__c,Debtors_Velocity_days__c,Creditors_Velocity_days__c,Inventories__c,Total_Current_Liabilities__c,Stock_Turnover_Ratio__c,Net_Profit_Margin__c,Net_Working_Capital__c,Account__r.Since_Year__c,Total_Non_Current_Assets__c,Account__r.CA_with_other_banks__c,Account__r.CIBIL_Score__c,Account__r.Due_date_of_last_stock_statement_not_upl__c,Account__r.Date_of_Incorporation__c,Net_sales__c,Net_profit__c,Current_Ratio__c FROM M68_Balance_Sheet_Analysis__c WHERE Fiscal_Year__c =: nextFY AND Account__c =: app.genesis__Account__c AND Financial_type__c = 'Estimated' ORDER BY CreatedDate DESC LIMIT 1];
        }catch(Exception qe){}
        try{
            facilityList = [SELECT Id,Existing_Limit__c,Delay__c FROM Facility__c WHERE Application__c =: app.Id];
        }catch(Exception qe){}
        try{
            m68DataPrevYear = [SELECT Purchases__c,Net_profit__c,Total_Current_Assets__c,TOL_TNW_Ratio__c,Debtors_Velocity_days__c,Creditors_Velocity_days__c,Inventories__c,Total_Current_Liabilities__c,Stock_Turnover_Ratio__c,Net_Profit_Margin__c,Net_Working_Capital__c,Total_Non_Current_Assets__c,Net_sales__c FROM M68_Balance_Sheet_Analysis__c WHERE Fiscal_Year__c =: prevFiscalYear AND Account__c =: app.genesis__Account__c AND Financial_type__c = 'Actual' ORDER BY CreatedDate DESC LIMIT 1];
        }catch(Exception qe){}
        try{
            List<Expenses__c> expanseList= [SELECt id,FinanceCostTotal__c,DepreciationAndAmortizationTotal__c FROM Expenses__c WHERE Profit_And_Loss__r.Perfios__r.Applicant_Name__c =: app.genesis__Account__c LIMIT 1];
            if(!expanseList.isEmpty()){
                expance = expanseList[0];
            }
        }catch(Exception qe){}
        try{
            List<OtherExpenses__c> othExpList=[SELECT IncomeTaxPaid__c FROM OtherExpenses__c WHERE Expenses__c =: expance.Id];
            if(!othExpList.isEmpty()){
                othExp = othExpList[0];
            }

        }catch(Exception qe){}
        try{
            partyList = [SELECT Id,genesis__Party_Account_Name__r.CIBIL_Score__c,Guarantor__c FROM genesis__Application_Parties__c WHERE genesis__Application__c =: app.Id AND Active__c = true];
        }catch(Exception qe){}
        try{
            cfDetailList = [SELECT Id,Name,Tu_Credit_Report__c,DPD1_to_30amt__c,DPD31_to_60_amt__c,DPD61_to_90_amt__c,DPD91_to_180_amt__c,DPD_above_180_amt__c,DPD_Average__c,(SELECT Id,Credit_Facility_Detail__c,Month__c,ACorDPD__c from TU_CFHistories__r order by Name ASC LIMIT 12) FROM Credit_Facility_Detail__c WHERE Tu_Credit_Report__r.Account__c =: app.genesis__Account__c];
        }catch(Exception qe){}
        try{
            List<Operations_Detail__c> opDetailPrevList = [SELECT Outward_check_return__c,Company_premises__c,FIN_CR_AMT__c,Number_of_Bills__c,Devolvement_LC_Count__c,Devolvement_BG_Count__c,Maximum_Return_Amount__c,Credit_Cash_Amount__c,Average_days_of_Exceedings__c,Minimum_Return_Amount__c,Outward_Check_Count__c,No_of_Exceedings__c,Id,DR_AMT__c FROM Operations_Detail__c WHERE Fiscal_Year__c =: prevFiscalYear AND Account__c =: app.genesis__Account__c AND Fiscal_Type__c = 'Actual' LIMIT 1];
            if(!opDetailPrevList.isEmpty()){
                opDetailPrev = opDetailPrevList[0];
            }
        }catch(Exception qe){}
        try{
            scorerangeList = [SELECT Id,Score_variable__r.MasterLabel,Industry_type__c,Operator__c,Value_less__c,Value_more__c FROM Score_Range__mdt];
        }catch(Exception qe){}
        try{
            maxWeightList = [SELECT Id,Max_weight__c,Industry_type__c,Score_variable_name__c FROM Score_weight_max__mdt];
        }catch(Exception qe){}
        try{
            scoreVarList = [SELECT MasterLabel,(SELECT Id,Score_variable__r.MasterLabel,Industry_type__c,Operator__c,Value_less__c,Value_more__c FROM Score_Ranges__r) FROM Score_variable__mdt];
        }catch(Exception qe){}
        String query1   = 'Select ';
        Map<String, Schema.SObjectField> accountFieldMap1 = Schema.getGlobalDescribe().get( 'Operations_Detail__c' ).getDescribe().fields.getMap();
        for(Schema.SObjectField s : accountFieldMap1.values()){
            query1 = query1 + s.getDescribe().getName()+',';
        }
        query1   = query1.removeEnd(',');
        query1   = query1 + ' from Operations_Detail__c WHERE Fiscal_Year__c =: fiscalYear AND Fiscal_Type__c =\'Actual\' AND Account__c =: accId LIMIT 1';
        try{
            oprDetail = Database.query(query1);
        }
        catch(Exception qe){}
        try{
            categoryMap = new Map<Id,BRE_Category__mdt>([SELECT Id,DeveloperName,MasterLabel,(SELECT Id,DeveloperName,BRE_Category__c,Range__c,MasterLabel FROM Flag_Variables__r),(SELECT Id,DeveloperName,BRE_Category__c,MasterLabel FROM Score_variables__r) FROM BRE_Category__mdt]);
        }catch(Exception qe){}
        try{
            facList = [SELECT id,New_Limit_Amount__c,Application__c FROM Facility__c WHERE Application__c =:app.Id];
        }
        catch(Exception qe){}
        try{
            bankAccList = [SELECT Id,List_Name__c,List_Matching__r.Account__r.Jocata_List_Match__c,List_Matching__r.Account__r.BOE_Unutilized_List__c,List_Matching__r.Account__r.Ship_bill_not_lodged__c,List_Matching__r.Account__r.IRM_Unutilized_List__c,List_Matching__r.Account__r.ORM_Unutilized_List__c FROM clcommon__Bank_Account__c WHERE List_Matching__r.Account__c =: app.genesis__Account__c AND List_Matching__r.Match_Flag__c = true];
        }catch(Exception qe){}
        try{
            m68DataEst = [SELECT Purchases__c,Total_Current_Assets__c,TOL_TNW_Ratio__c,Debtors_Velocity_days__c,Creditors_Velocity_days__c,Inventories__c,Total_Current_Liabilities__c,Stock_Turnover_Ratio__c,Net_Profit_Margin__c,Net_Working_Capital__c,Total_Non_Current_Assets__c,Account__r.CIBIL_Score__c,Account__r.Date_of_Incorporation__c,Net_sales__c,Net_profit__c,Current_Ratio__c FROM M68_Balance_Sheet_Analysis__c WHERE Fiscal_Year__c =: fiscalYear AND Account__c =: app.genesis__Account__c AND Financial_type__c = 'Estimated' ORDER BY CreatedDate DESC LIMIT 1];
        }catch(Exception qe){}
        try{
            m68Data_3_YearPrior = [SELECT Purchases__c,Total_Current_Assets__c,TOL_TNW_Ratio__c,Debtors_Velocity_days__c,Creditors_Velocity_days__c,Inventories__c,Total_Current_Liabilities__c,Stock_Turnover_Ratio__c,Net_Profit_Margin__c,Net_Working_Capital__c,Account__r.CIBIL_Score__c,Account__r.Date_of_Incorporation__c,Net_sales__c,Net_profit__c,Current_Ratio__c FROM M68_Balance_Sheet_Analysis__c WHERE Fiscal_Year__c =: prior_3_fiscalYear AND Account__c =: app.genesis__Account__c AND Financial_type__c = 'Actual' ORDER BY CreatedDate DESC LIMIT 1];
        }catch(Exception qe){}
        try{
            List<Operations_Detail__c> opList = new List<Operations_Detail__c>();
            if(System.now().month() == 4)
                opList = [SELECT Id,FIN_DR_AMT__c,FIN_CR_AMT__c,Availment_amount__c,Delay_in_interest_count_days__c,Inward_check_return__c,Outward_check_return__c,Company_premises__c,Number_of_Bills__c,Devolvement_LC_Count__c,Devolvement_BG_Count__c,Maximum_Return_Amount__c,Credit_Cash_Amount__c,Average_days_of_Exceedings__c,Minimum_Return_Amount__c,Outward_Check_Count__c,No_of_Exceedings__c,DR_AMT__c FROM Operations_Detail__c WHERE Account__c =: app.genesis__Account__c AND Fiscal_Year__c =: fiscalYear AND Fiscal_Type__c = 'Actual' LIMIT 1];
            else
                    opList = [SELECT Id,FIN_DR_AMT__c,FIN_CR_AMT__c,Availment_amount__c,Delay_in_interest_count_days__c,Inward_check_return__c,Outward_check_return__c,Company_premises__c,Number_of_Bills__c,Devolvement_LC_Count__c,Devolvement_BG_Count__c,Maximum_Return_Amount__c,Credit_Cash_Amount__c,Average_days_of_Exceedings__c,Minimum_Return_Amount__c,Outward_Check_Count__c,No_of_Exceedings__c,DR_AMT__c FROM Operations_Detail__c WHERE Account__c =: app.genesis__Account__c AND Fiscal_Type__c = 'YTD' LIMIT 1];
            if(!opList.isEmpty()){
                oprDetailYTD = opList[0];
            }

        }catch(Exception qe){}
        try{
            List<ints__TransUnion_Credit_Report__c> tuList =  [SELECT Id,Rank_Value__c FROM ints__TransUnion_Credit_Report__c WHERE Account__c =: app.genesis__Account__c AND Fiscal_year__c =: fiscalYear LIMIT 1];
            if (!tuList.isEmpty()) {
                tuDetail = tuList[0];
            }
        }catch(Exception qe){}
        try{
            List<Enquiry_Summary__c> tuCreditList =  [SELECT Id,Total__c FROM Enquiry_Summary__c WHERE Tu_Credit_Report__c =: tuDetail.Id AND Type__c = 'Total' LIMIT 1];
            if(!tuCreditList.isEmpty()){
                enqSumm = tuCreditList[0];

            }
        }catch(Exception qe){}
        try{
            drgInfoList = [SELECT Id,Invoked_Number_of_SuitFiled__c,Settled_Number_of_SuitFiled__c,Writtenoff_number_of_SuitFiled__c,SuitFilled_Number_of_SuitFiled__c,OverdueCF_Number_of_SuitFiled__c FROM Derogatory_Information__c WHERE Tu_Credit_Report__c =: tuDetail.Id AND SubType__c = 'Total' LIMIT 1];
        }catch(Exception qe){}
        try{
            tuMessage = [SELECT Id,Credit_Rating_Summary_Message__c FROM TU_Message__c WHERE TU_Credit_Report__c =: tuDetail.Id LIMIT 1];
        }catch(Exception qe){}
        try{
            appCollateralList = [SELECT Id,genesis__Collateral__r.clcommon__Value__c,genesis__Collateral__r.clcommon__Collateral_Type__r.Name FROM genesis__Application_Collateral__c WHERE Application__c =: app.Id];
        }catch(Exception qe){}
        try{
            rankList = [SELECT Rank_Value__c FROM RankVec__c WHERE Tu_Credit_Report__r.Account__c =: app.genesis__Account__c];
        }
        catch(Exception e){}
        try{
            collInsuranceList = [SELECT Security_Value__c FROM clcommon__Collateral_Insurance__c WHERE Account__c =: app.genesis__Account__c];
        }
        catch(Exception e){}
        try{
            preCheckList = [SELECT Id,Complied__c FROM Renewal_Checklists__c WHERE Application__c =: app.Id AND Checklist_Name__c = 'If up to date stock statement received?'];
        }
        catch(Exception e){}
    }
    public static void runBRERule(genesis__Applications__c appln,Boolean firstRun){//2
        Savepoint sp = Database.setSavepoint();
        queryService(appln.Id);
        try{
            if(oprDetail != null && oprDetail.FIN_DR_AMT__c != null && oprDetail.FIN_CR_AMT__c != null){
                if(app.RecordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    if(app.Type__c.contains('NTB') || app.Type__c.contains('New to credit')){
                        isAllTaskCompleted  =  YearDataConstant.checkAllTaskDoneForBRERun(app.id,Constants.listOfTaskOfNewLoan_NTB);
                        isAllAppCondCompleted = YearDataConstant.checkAppConditionForBRERun(app.Id);    
                    }else{
                        isAllTaskCompleted  =  YearDataConstant.checkAllTaskDoneForBRERun(app.id,Constants.listOfTaskOfNewLoan);
                        isAllAppCondCompleted = YearDataConstant.checkAppConditionForBRERun(app.Id);
                    }
                }else if(app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                    isAllTaskCompleted  =  YearDataConstant.checkAllTaskDoneForBRERun(app.id,Constants.listOfTaskOfEnhacement);
                    isAllAppCondCompleted = YearDataConstant.checkAppConditionForBRERun(app.Id);    
                }else if(app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                    isAllTaskCompleted  =  YearDataConstant.checkAllTaskDoneForBRERun(app.id,Constants.listOfTaskOfExceeding);
                    isAllAppCondCompleted = YearDataConstant.checkAppConditionForBRERun(app.Id);    
                }else{
                    isAllTaskCompleted  = true;
                    isAllAppCondCompleted = true;
                }
                System.debug('isAllTaskCompleted::'+isAllTaskCompleted);
                System.debug('isAllAppCondCompleted::'+isAllAppCondCompleted);
                if(isAllTaskCompleted && isAllAppCondCompleted){
                    Map<Id,Credit_Underwriting__c> parentCUTodelete = new Map<Id,Credit_Underwriting__c>();
                    List<Credit_Underwriting__c> childCUTodelete = new List<Credit_Underwriting__c>();
                    parentCUTodelete = new Map<Id,Credit_Underwriting__c>([SELECT Id FROM Credit_Underwriting__c WHERE Application__c =: app.Id]);
                    childCUTodelete = [SELECT Id FROM Credit_Underwriting__c WHERE Underwriting_Variable__c IN : parentCUTodelete.keyset()];
                    DELETE childCUTodelete;
                    DELETE parentCUTodelete.values();
                    DELETE [SELECT Id FROM genesis__Application_s_Scorecard__c WHERE genesis__Application__c =: app.Id];
                    overAllExposure = KVB_Company_Details__c.getInstance().Overall_Exposure_Limit__c;
                    if(app.RecordType.DeveloperName == 'SME_Renewal'){
                        AccountTriggerHandler.limitCalculation(app);
                        appOverAllExposure = AccountTriggerHandler.exposureAmount;
                        app.Overall_Exposure__c = appOverAllExposure;
                    }
                    scoreValCalculation();
                    //Score card creation
                    String scoreCardCreatedFlag = genesis.ScorecardAPI.generateScorecard(app.Id);
                    System.debug('scoreCardCreatedFlag::'+scoreCardCreatedFlag);
                    //Credit underwriting creation on success scorecard creation
                    if(scoreCardCreatedFlag == Constants.SCORECARD_CREATION_SUCCESS_STATUS){
                        EAE_variables = YTDAnalysisController.getAllFlagAnalysis(app.genesis__Account__c,app.Id);
                        if(!categoryMap.keySet().isEmpty()){
                            for(Id catId : categoryMap.keySet()){
                                if(!(categoryMap.get(catId).MasterLabel == 'Financial' && (app.Overall_Exposure__c <= overAllExposure || app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING))){
                                    Credit_Underwriting__c cuParent = new Credit_Underwriting__c(RecordTypeId = cuParentRecTypeId,Application__c = app.Id);
                                    cuParent.Appraisal__c = categoryMap.get(catId).MasterLabel;
                                    cuParentList.add(cuParent);
                                }
                            }
                            if(!EAE_variables.isEmpty()){
                                Credit_Underwriting__c cuChild;
                                for(String key : EAE_variables.keySet()){
                                    Credit_Underwriting__c cuParent = new Credit_Underwriting__c(RecordTypeId = cuParentRecTypeId,Application__c = app.Id);
                                    cuParent.Appraisal__c = key;
                                    cuParentList.add(cuParent);
                                }
                            }
                            if(!cuParentList.isEmpty()){
                                INSERT cuParentList;
                                for(Credit_Underwriting__c cuPar : cuParentList){
                                    cuParentIdMap.put(cuPar.Appraisal__c,cuPar.Id);
                                }
                            }
                            if(!EAE_variables.keySet().isEmpty()){
                                for(String key : EAE_variables.keySet()){
                                    if(!EAE_variables.get(key).isEmpty()){
                                        for(Credit_Underwriting__c cuChild :EAE_variables.get(key)){
                                            cuChild.Underwriting_Variable__c = cuParentIdMap.get(cuChild.Appraisal__c);
                                        }
                                        cuChildList.addAll(EAE_variables.get(key));
                                    }
                                }
                            }
                            if(variableCreation(app).size() >0){
                                INSERT cuChildList;
                                updateCategoryValues(app,firstRun);
                            }
                            else
                                Database.rollback(sp);
                        }
                    }
                }
            } 
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getStackTraceString());
            Database.rollback(sp);
        }
    }
    public static void scoreValCalculation(){//3
        String accId = app.genesis__Account__c;
        Decimal avgLimit =0.0;
        Decimal avgDPD =0;
        Integer historySize = 0;
        Decimal totalDPDVal = 0.0;
        for(Credit_Facility_Detail__c cfDetail : cfDetailList){
            if(cfDetail.TU_CFHistories__r.size() > 0){
                historySize += cfDetail.TU_CFHistories__r.size();
                totalDPDVal += calculateDPDVal(cfDetail.TU_CFHistories__r);
            }
        }
        if(historySize != 0) avgDPD = (totalDPDVal / historySize);
        //Calculate average existing limit value
        for(Facility__c fac : facilityList){
            if(fac.Existing_Limit__c != null) avgLimit+= fac.Existing_Limit__c;
        }
        
        app.Current_ratio__c =Utility.isNullOrZeroDecimal(m68Data.Current_Ratio__c);
        if(Utility.isNullOrZeroDecimal(Utility.isNullOrZeroDecimal(oprDetail.Availment_amount__c)) != 0.0){
            app.Working_capital_turnover_ratio__c = (Utility.isNullOrZeroDecimal(m68Data.Net_sales__c) / oprDetail.Availment_amount__c)*-1;
        }
        else
            app.Working_capital_turnover_ratio__c = 0.0;
        if(app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE && Utility.isNullOrZeroDecimal(expance.FinanceCostTotal__c) != 0.0){
            app.Interest_service_coverage_ratio__c = ((Utility.isNullOrZeroDecimal(m68Data.Net_profit__c)+expance.FinanceCostTotal__c+Utility.isNullOrZeroDecimal(othExp.IncomeTaxPaid__c)+Utility.isNullOrZeroDecimal(m68Data.Depreciation__c))/expance.FinanceCostTotal__c);
        }
        else if((app.RecordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_EXCEEDING || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ADHOC) && Utility.isNullOrZeroDecimal(m68Data.Interest_Expense__c) != 0.0 ){
            app.Interest_service_coverage_ratio__c = ((Utility.isNullOrZeroDecimal(m68Data.Net_profit__c)+m68Data.Interest_Expense__c+Utility.isNullOrZeroDecimal(m68Data.Income_tax_paid__c)+Utility.isNullOrZeroDecimal(m68Data.Depreciation__c))/m68Data.Interest_Expense__c);
        }
        else
            app.Interest_service_coverage_ratio__c = 0.0;
        
        if(avgLimit != 0.0){
            app.Average_limit_utilization__c =(Utility.isNullOrZeroDecimal(oprDetailYTD.Availment_amount__c) / avgLimit)*-100;
        }
        else
            app.Average_limit_utilization__c = 0.0;
        
        app.Delay_in_servicing_of_working_cap_int__c = Utility.isNullOrZeroDecimal(oprDetailYTD.Delay_in_interest_count_days__c);
        if(Utility.isNullOrZeroDecimal(m68Data.Net_sales__c) != 0.0){
            app.Credit_summation_compared_to_previous_yr__c = (Utility.isNullOrZeroDecimal(oprDetail.FIN_CR_AMT__c) / m68Data.Net_sales__c)*100;
        }
        else
            app.Credit_summation_compared_to_previous_yr__c = 0.0;
        app.Inward_cheque_return__c = Utility.isNullOrZeroDecimal(oprDetailYTD.Inward_check_return__c);
        if(app.genesis__Account__r.Date_of_Incorporation__c != null){
            app.No_of_years_of_operation__c = getNoOfyearOfOperation(app.genesis__Account__r.Date_of_Incorporation__c);
        }
        else
            app.No_of_years_of_operation__c = 0.0;
        
        //CIBIL Score calculation
        List<Decimal> cibilScoreList = new List<Decimal>();
        if(!partyList.isEmpty()){
            for(genesis__Application_Parties__c party : partyList){
                if(party.genesis__Party_Account_Name__r.CIBIL_Score__c != null && party.genesis__Party_Account_Name__r.CIBIL_Score__c != -1){
                    cibilScoreList.add(party.genesis__Party_Account_Name__r.CIBIL_Score__c);
                }
            }
        }
        if(!cibilScoreList.isEmpty()){
            cibilScoreList.sort();
            app.CIBIL_score__c = cibilScoreList[0];
        }
        else
            app.CIBIL_score__c = 0;
        
        app.DPD_status__c = avgDPD;
        System.debug(+':::opr'+oprDetailYTD);
        if(oprDetailYTD.Availment_amount__c != null && oprDetailYTD.Availment_amount__c != 0 && oprDetailYTD.FIN_CR_AMT__c != null){
            app.Credit_summation_to_average_availment__c = (oprDetailYTD.FIN_CR_AMT__c/oprDetailYTD.Availment_amount__c)*-1;
        }
        else
            app.Credit_summation_to_average_availment__c = 0;
        
        Decimal grCount = 0;
        for(genesis__Application_Parties__c party : partyList){
            if(!party.Guarantor__c)
                grCount++;
        }
        app.PartyCount__c = grCount;
        Decimal totalNewLimit              = 0;
        for(Facility__c facilityRec : facList){
            if(facilityRec.New_Limit_Amount__c != null)
                totalNewLimit             += facilityRec.New_Limit_Amount__c;
        }
        app.Total_Requested_Amount__c = totalNewLimit;
        
        if(app.Management_experience__c != null){
            if(app.Management_experience__c == 'New to Business Line (less than 1 year in the line of business).' || app.Management_experience__c == 'Having experience of 1 or more years but less than 3 years.')
                app.Management_experience_BRE__c = '0 to 3 years';
            else if(app.Management_experience__c == 'Having experience of 3 or more years but less than 5 years in the line of business.')
                app.Management_experience_BRE__c = '3 to 5 years';
            else
                app.Management_experience_BRE__c = '>= 5 years';
        }
        if(app.genesis__Account__r.CUSTSINCE__c != null){
            app.Length_of_relationship_with_the_bank_BRE__c = System.Today().year()-app.genesis__Account__r.CUSTSINCE__c.year();
        }
        else
            app.Length_of_relationship_with_the_bank_BRE__c = 0;
        if(m68Data!=null && Utility.isNullOrZeroDecimal(m68Data.Purchases__c)!=0){
            debitSumComparedToPrevYrPurch = ((Utility.isNullOrZeroDecimal(oprDetail.FIN_DR_AMT__c)/m68Data.Purchases__c)*100).setScale(2);
        }
        else
            debitSumComparedToPrevYrPurch = 0.0;
        app.Debit_summ_to_prev_yr_purchase_BRE__c = debitSumComparedToPrevYrPurch;
        System.debug(m68Data.Fiscal_Year__c);
        System.debug(m68Data.Purchases__c);
        System.debug(oprDetail.Fiscal_Year__c);
        System.debug(oprDetail.FIN_DR_AMT__c);
        System.debug(debitSumComparedToPrevYrPurch);
        netProfitMargin = Utility.isNullOrZeroDecimal(m68Data.Net_Profit_Margin__c);
        if(app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE && Utility.isNullOrZeroDecimal(m68Data.Net_sales__c) != 0.0){
            operatingMargin = ((Utility.isNullOrZeroDecimal(m68Data.Net_profit__c)+Utility.isNullOrZeroDecimal(expance.FinanceCostTotal__c)+Utility.isNullOrZeroDecimal(othExp.IncomeTaxPaid__c)+Utility.isNullOrZeroDecimal(m68Data.Depreciation__c))/Utility.isNullOrZeroDecimal(m68Data.Net_sales__c))*100;
        }
        else if((app.RecordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_EXCEEDING || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ADHOC) && Utility.isNullOrZeroDecimal(m68Data.Net_sales__c) != 0){
            operatingMargin = ((Utility.isNullOrZeroDecimal(m68Data.Net_profit__c)+Utility.isNullOrZeroDecimal(m68Data.Interest_Expense__c)+Utility.isNullOrZeroDecimal(m68Data.Income_tax_paid__c)+Utility.isNullOrZeroDecimal(m68Data.Depreciation__c))/Utility.isNullOrZeroDecimal(m68Data.Net_sales__c))*100;
        } 
        else
            operatingMargin = 0.0;
        app.genesis__Margin__c = operatingMargin.setScale(2);
        if((Utility.isNullOrZeroDecimal(m68Data.Total_Current_Liabilities__c) + Utility.isNullOrZeroDecimal(m68Data.Total_Term_Liabilities__c)) != 0){
            app.genesis__Rate_Ceiling__c = Utility.isNullOrZeroDecimal(m68Data.Total_Net_Worth__c) / (Utility.isNullOrZeroDecimal(m68Data.Total_Current_Liabilities__c) + Utility.isNullOrZeroDecimal(m68Data.Total_Term_Liabilities__c));
        }
        else
            app.genesis__Rate_Ceiling__c = 0.0;
        if(m68Data.Net_profit__c > 0 && m68DataPrevYear.Net_profit__c > 0 )
            app.Consistency_of_Profits__c = 'Yes';
        else
            app.Consistency_of_Profits__c = 'No';
        ApplicationTriggerHandler.IsFirstRun = false;
        UPDATE app;
    }
    public static List<Credit_Underwriting__c> variableCreation(genesis__Applications__c app){//4
        calculateScoreValues(app);
        if(!categoryMap.keySet().isEmpty()){
            cuChildList.addAll(calculateFlagValues(app));
            RETURN cuChildList;
        }
        else
            RETURN null;
    }
    public static void calculateScoreValues(genesis__Applications__c app){//5
        Decimal exposureValueTocompare = overAllExposure;
        String industryType = '';
        if(app.Industry_type_Application__c == 'Manufacturing') industryType = 'Manufacturing';
        else if(app.Industry_type_Application__c == 'TRADING') industryType = 'TRADING';
        else industryType = 'Others';
        try{
            scoreCardResList = [SELECT genesis__Field_Name__c,Id,genesis__Weight__c,genesis__Weighted_Score__c FROM genesis__Application_s_Scorecard__c WHERE genesis__Application__c =: app.Id AND genesis__Criteria_Match__c = true];
        }catch(Exception qe){}
        //Score and value calculation of Score variables
        for(genesis__Application_s_Scorecard__c scoreCard : scoreCardResList){
            System.debug('scoreCardName:::'+scoreCard.genesis__Field_Name__c);
            if(scoreCard.genesis__Field_Name__c == 'Current ratio'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Current_ratio__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Working capital turnover ratio'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Working_capital_turnover_ratio__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Interest service coverage ratio'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Interest_service_coverage_ratio__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Average limit utilization(%)'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Average_limit_utilization__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Delay in servicing interest(# of times)'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Delay_in_servicing_of_working_cap_int__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Credit summation to prev yr sales(%)'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Credit_summation_compared_to_previous_yr__c).setScale(2)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Inward cheque return'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Inward_cheque_return__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'No of years of operation'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.No_of_years_of_operation__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'CIBIL score'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.CIBIL_score__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'DPD status (Average DPD)'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.DPD_status__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Credit summ to avg availment'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Credit_summation_to_average_availment__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'PartyCount'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.PartyCount__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Consistency of Profits'){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf(app.Consistency_of_Profits__c));
            }
            if(scoreCard.genesis__Field_Name__c == 'Management experience BRE' && (app.Type__c.contains('New to credit') || app.New_to_Business__c)){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf(app.Management_experience_BRE__c));
            }
            if(scoreCard.genesis__Field_Name__c == 'Length of relationship with the bank BRE' && (app.Type__c.contains('New to credit') || app.New_to_Business__c)){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Length_of_relationship_with_the_bank_BRE__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Debit summ to prev yr purchase(%)' && (app.Type__c.contains('New to credit') || app.New_to_Business__c)){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Debit_summ_to_prev_yr_purchase_BRE__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Margin To Be Paid' && app.Type__c.contains('New to credit')){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.Margin_To_Be_Paid__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Margin' && app.Type__c.contains('New to credit')){
                nameScoreMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put(scoreCard.genesis__Field_Name__c,String.valueOf((app.genesis__Margin__c).setScale(1)));
            }
            if(scoreCard.genesis__Field_Name__c == 'Rate Ceiling' && app.Type__c.contains('New to credit')){
                nameScoreMap.put('ENW/Total Liabilities',String.valueOf((scoreCard.genesis__Weighted_Score__c).setScale(2)));
                nameValueMap.put('ENW/Total Liabilities',String.valueOf((app.genesis__Rate_Ceiling__c).setScale(1)));
            }
        }
        //Maximum wieght calculation
        for(Score_weight_max__mdt maxWt :maxWeightList){
            if(maxWt.Industry_type__c == industryType){
                nameWeightMap.put(maxWt.Score_variable_name__c,String.valueOf(maxWt.Max_weight__c));
            }
        }
        //Range calculation
        if(!scoreVarList.isEmpty()){
            for(Score_variable__mdt sVar : scoreVarList){
                if(!sVar.Score_Ranges__r.isEmpty()){
                    for(Score_Range__mdt sRange : sVar.Score_Ranges__r){
                        if(sRange.Industry_type__c == industryType){
                            if(app.Overall_Exposure__c < exposureValueTocompare)
                                nameRangeMap.put(sVar.MasterLabel,sRange.Value_less__c != null ? sRange.Operator__c + String.valueOf(sRange.Value_less__c) : 'N/A');
                            else
                                nameRangeMap.put(sVar.MasterLabel,sRange.Value_more__c != null ? sRange.Operator__c + String.valueOf(sRange.Value_more__c) : 'N/A');
                        }
                    }
                }
            }
            if((app.New_to_Business__c || app.Type__c.contains('New to credit')) && app.Inward_cheque_return__c !=null && app.Inward_cheque_return__c>0){
                nameRangeMap.put('Inward cheque return','> 0');
            }
        }
        for(Id catId : categoryMap.keySet()){
            Credit_Underwriting__c cuChild;
            if(!categoryMap.get(catId).Score_variables__r.isEmpty()){
                for(Score_variable__mdt scoreVar : categoryMap.get(catId).Score_variables__r){
                    if(!((app.Overall_Exposure__c > overAllExposure && scoreVar.MasterLabel == 'Credit summ to avg availment') || (app.RecordType.DeveloperName == 'SME_Renewal' && app.Overall_Exposure__c < overAllExposure && scoreVar.MasterLabel == 'Credit summation to prev yr sales(%)'))){
                        System.debug('scoreVar.MasterLabel:::'+scoreVar.MasterLabel);
                        cuChild = new Credit_Underwriting__c();
                        cuChild.Underwriting_Variable__c = cuParentIdMap.get(categoryMap.get(catId).MasterLabel);
                        cuChild.Appraisal__c = categoryMap.get(catId).MasterLabel;
                        if(scoreVar.MasterLabel == 'Margin')
                            cuChild.Variable_type__c = 'Operating Margin(%)';
                        else
                            cuChild.Variable_type__c = scoreVar.MasterLabel;
                        cuChild.Application_Value__c = nameValueMap.get(scoreVar.MasterLabel);
                        cuChild.Application_Weight__c = nameWeightMap.get(scoreVar.MasterLabel);
                        cuChild.Application_Score__c = nameScoreMap.get(scoreVar.MasterLabel);
                         if((nameScoreMap.get(scoreVar.MasterLabel) != null && scoreVar.MasterLabel == 'No of years of operation' && app.No_of_years_of_operation__c < 8) || (app.Type__c != null && app.Type__c.contains('New to credit') && ((scoreVar.MasterLabel == 'Inward cheque return' && nameValueMap.get(scoreVar.MasterLabel) != null && Decimal.valueOf(nameValueMap.get(scoreVar.MasterLabel)) > 0) || (scoreVar.MasterLabel == 'Credit summation to prev yr sales(%)' && nameValueMap.get(scoreVar.MasterLabel) != null && Decimal.valueOf(nameValueMap.get(scoreVar.MasterLabel)) < 60)))){  
                            cuChild.Threshold_breached__c = true;
                            cuChild.Flags_Value__c = nameValueMap.get(scoreVar.MasterLabel);
                            cuChild.RecordTypeId = cuChildFlagRecTypeId;
                        }
                        else if(nameScoreMap.get(scoreVar.MasterLabel) != null && Decimal.valueOf(nameScoreMap.get(scoreVar.MasterLabel)) > 0){
                            cuChild.Threshold_breached__c = false;
                            cuChild.RecordTypeId = cuChildScoreRecTypeId;
                        }
                        else{
                            cuChild.Threshold_breached__c = true;
                            cuChild.Flags_Value__c = nameValueMap.get(scoreVar.MasterLabel);
                            cuChild.RecordTypeId = cuChildFlagRecTypeId;
                        }
                        cuChild.Flags_Range__c = nameRangeMap.get(scoreVar.MasterLabel);
                        if(nameScoreMap.get(scoreVar.MasterLabel) != null){
                            if(!((cuChild.Variable_type__c == 'Credit summ to avg availment' || cuChild.Variable_type__c == 'Delay in servicing interest(# of times)' || cuChild.Variable_type__c == 'Average limit utilization(%)') && app.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE && app.Type__c != null && app.Type__c.contains('New to credit'))){
                                cuChildList.add(cuChild);
                            }
                        }  
                    }
                }
            }
        }
    }
    public static List<Credit_Underwriting__c> calculateFlagValues(genesis__Applications__c app){//6
        List<Credit_Underwriting__c> cuChildFlagList = new List<Credit_Underwriting__c>();
        Decimal avgLimit = 0.0;
        Decimal suitFiledTotal = 0;
        Decimal fullInsuranceValue = 0.0;
        //Financials variables
        Decimal salesTrend_3_yrs = 0.0;
        String diversionOfFunds = '';
        String trendInInventoryTurnoverRatio = '';
        Decimal TOL_TNW = 0.0;
        Decimal debtorsVelocity = 0;
        Decimal creditorsVelocity = 0;
        Decimal quickRatio = 0.0;
        Decimal projectedVsActualsAchievementsOfSales = 0.0;
        //Account operations variables
        Decimal debitSumComparedToCurrYrPurch = 0.0;
        Decimal creditSumComparedToCurrYrSales = 0.0;
        Decimal exceedings = 0;
        Decimal promptnessOfClosingExceeding = 0;
        Decimal lowValueChequeReturns = 0.0;
        Decimal outwardChequeReturns = 0;
        Decimal highValueChequeReturns = 0.0;
        Decimal LCBG_Devolvement = 0;
        String CA_WithOtherBanks = '';//FE
        String delayInSubmittingStockStmnt = '';
        Decimal foreignBillsRemainingOutstanding = 0;
        //Applicant variables
        String companyPremise ='';
        Decimal lengthOfRelationshipWithTheBank = 0;
        String successionPlan ='';
        String managementExperience ='';
        String courtCases ='';
        String negativeListMatch = '';
        //Bureau variables
        Decimal CMR =0;
        Decimal DPD_Status_Worst_DPD = 0;
        Decimal noOfEnquiries = 0;
        Decimal noOfSuitsFiled = 0;
        String externalRating = '';
        //Collateral variables
        String typeOfsecurity = '';
        Decimal securityCoverage = 0.0;
        String availabilityOfFullInsurance ='';
        //Market VAriables
        String natureOfProductManufacturedTraded = '';
        String sellingAndDistributionArrangement = '';
        String industryOutlook = '';
        String competition = '';
        String governmentPolicies = '';
        String externalCertfications = '';
        typeOfsecurity = '';
        //Calculation of availability Of Full Insurance and type of security
        Set<Id> collateralIds = new Set<Id>();
        if(!appCollateralList.isEmpty()){
            for(genesis__Application_Collateral__c appColl : appCollateralList){
                collateralIds.add(appColl.genesis__Collateral__c);
            }
            collateralList = [SELECT clcommon__Collateral_Type__r.name,clcommon__Value__c FROM clcommon__Collateral__c WHERE Id IN :collateralIds AND Active__c = true];
            if(!collateralList.isEmpty()){
                for(clcommon__Collateral__c coll : collateralList){
                    typeOfsecurity += Utility.ISStringBlankorNull(coll.clcommon__Collateral_Type__r.Name)?'':coll.clcommon__Collateral_Type__r.Name+',';
                }
            }
        }
        typeOfsecurity = typeOfsecurity.removeEnd(',');
        for(clcommon__Collateral_Insurance__c collIns : collInsuranceList){
            fullInsuranceValue += Utility.isNullOrZeroDecimal(collIns.Security_Value__c);
        }
        //Calculate average existing limit value
        for(Facility__c fac : facilityList){
            if(fac.Existing_Limit__c != null) avgLimit+= fac.Existing_Limit__c;
        }
        //Calculating no of suit filed
        for(Derogatory_Information__c dInfo : drgInfoList){
            suitFiledTotal+= Integer.valueOf(Utility.isNullOrZeroDecimal(dInfo.SuitFilled_Number_of_SuitFiled__c)+Utility.isNullOrZeroDecimal(dInfo.Writtenoff_number_of_SuitFiled__c)+Utility.isNullOrZeroDecimal(dInfo.Settled_Number_of_SuitFiled__c)+Utility.isNullOrZeroDecimal(dInfo.Invoked_Number_of_SuitFiled__c)+Utility.isNullOrZeroDecimal(dInfo.OverdueCF_Number_of_SuitFiled__c));
        }
        //Negative list match flag value calculation
        for(clcommon__Bank_Account__c bAcc : bankAccList){
            if(bAcc.List_Name__c != null) negativeListMatch = negativeListMatch + bAcc.List_Name__c + ',';
        }
        if(!bankAccList.isEmpty()){
            if(bankAccList[0].List_Matching__r.Account__r.Jocata_List_Match__c == 'Yes') negativeListMatch = negativeListMatch + 'Jocata List Match,';
            if(bankAccList[0].List_Matching__r.Account__r.BOE_Unutilized_List__c == 'Yes') negativeListMatch = negativeListMatch + 'BOE Unutilized List,';
            if(bankAccList[0].List_Matching__r.Account__r.Ship_bill_not_lodged__c == 'Yes') negativeListMatch = negativeListMatch + 'Ship bill not lodged,';
            if(bankAccList[0].List_Matching__r.Account__r.IRM_Unutilized_List__c == 'Yes') negativeListMatch = negativeListMatch + 'IRM Unutilized List,';
            if(bankAccList[0].List_Matching__r.Account__r.ORM_Unutilized_List__c == 'Yes') negativeListMatch = negativeListMatch + 'ORM Unutilized List,';
        }
        negativeListMatch   = negativeListMatch.removeEnd(',');
        //######Financials calculation
        if(Utility.isNullOrZeroDecimal(m68Data_3_YearPrior.Net_sales__c) != 0) salesTrend_3_yrs =((Math.pow((Utility.isNullOrZeroDecimal(m68Data.Net_sales__c)/Utility.isNullOrZeroDecimal(m68Data_3_YearPrior.Net_sales__c)).doubleValue(), (0.33).doubleValue()))-1)*100;
        flagNameValueMap.put('Sales trend (CAGR-3 yrs)',String.valueOf(Math.round(salesTrend_3_yrs)));
        if(m68Data.Current_Ratio__c < 1.33 && (Utility.isNullOrZeroDecimal(m68Data.Net_Working_Capital__c)-Utility.isNullOrZeroDecimal(m68DataPrevYear.Net_Working_Capital__c)) <0 && (Utility.isNullOrZeroDecimal(m68Data.Total_Non_Current_Assets__c)-Utility.isNullOrZeroDecimal(m68DataPrevYear.Total_Non_Current_Assets__c)) >0){
            diversionOfFunds = 'Y';
        }
        else{
            diversionOfFunds = 'N';
        }
        flagNameValueMap.put('Diversion of funds',diversionOfFunds);
        flagNameValueMap.put('Operating Margin(%)',String.valueOf(Math.round(operatingMargin.setscale(3))));
        flagNameValueMap.put('Net profit Margin(%)',String.valueOf(Math.round(netProfitMargin)));
        if((Utility.isNullOrZeroDecimal(m68Data.Stock_Turnover_Ratio__c) - Utility.isNullOrZeroDecimal(m68DataPrevYear.Stock_Turnover_Ratio__c)) > 0){
            trendInInventoryTurnoverRatio = 'N';
        }
        else{
            trendInInventoryTurnoverRatio = 'Y';
        }
        flagNameValueMap.put('Declining inventory turnover',trendInInventoryTurnoverRatio);
        TOL_TNW = Utility.isNullOrZeroDecimal(m68Data.TOL_TNW_Ratio__c);
        flagNameValueMap.put('TOL/ TNW',String.valueOf(Math.round(TOL_TNW)));
        debtorsVelocity = Utility.isNullOrZeroDecimal(m68Data.Debtors_Velocity_days__c);
        flagNameValueMap.put('Debtors velocity(days)',String.valueOf(Math.round(debtorsVelocity)));
        creditorsVelocity = Utility.isNullOrZeroDecimal(m68Data.Creditors_Velocity_days__c);
        flagNameValueMap.put('Creditors velocity(days)',String.valueOf(Math.round(creditorsVelocity)));
        if(Utility.isNullOrZeroDecimal(m68Data.Total_Current_Liabilities__c) != 0) quickRatio = (Utility.isNullOrZeroDecimal(m68Data.Total_Current_Assets__c)-Utility.isNullOrZeroDecimal(m68Data.Inventories__c))/Utility.isNullOrZeroDecimal(m68Data.Total_Current_Liabilities__c);
        flagNameValueMap.put('Quick ratio',String.valueOf(Math.round(quickRatio)));
        if(Utility.isNullOrZeroDecimal(m68DataEst.Net_sales__c) != 0) projectedVsActualsAchievementsOfSales = (Utility.isNullOrZeroDecimal(m68Data.Net_sales__c)/Utility.isNullOrZeroDecimal(m68DataEst.Net_sales__c))*100;
        flagNameValueMap.put('Projected vs Actual sales(%)',String.valueOf(Math.round(projectedVsActualsAchievementsOfSales)));
        //#####Account operations calculation
        flagNameValueMap.put('Debit summation to prev yr purchase(%)',String.valueOf(debitSumComparedToPrevYrPurch.setScale(2)));
        if(Utility.isNullOrZeroDecimal(m68DataCurrYear.Purchases__c) != 0.0){
            debitSumComparedToCurrYrPurch = Utility.isNullOrZeroDecimal(oprDetailYTD.FIN_DR_AMT__c)/Utility.isNullOrZeroDecimal(m68DataCurrYear.Purchases__c);
        }
        else
            debitSumComparedToCurrYrPurch = 0.0;
        flagNameValueMap.put('Debit summation to curr yr purchase(%)',String.valueOf((debitSumComparedToCurrYrPurch*100).setScale(2)));
        if(Utility.isNullOrZeroDecimal(m68DataCurrYear.Net_sales__c) != 0.0){
            creditSumComparedToCurrYrSales = (Utility.isNullOrZeroDecimal(oprDetailYTD.FIN_CR_AMT__c)/m68DataCurrYear.Net_sales__c)*100;
        }
        else
            creditSumComparedToCurrYrSales = 0.0;
        flagNameValueMap.put('Credit summation to curr yr sales(%)',String.valueOf(creditSumComparedToCurrYrSales.setScale(2)));
        exceedings = Integer.valueOf(Utility.isNullOrZeroDecimal(oprDetailYTD.No_of_Exceedings__c));
        flagNameValueMap.put('Exceedings (# of times)',String.valueOf(Math.round(exceedings)));
        promptnessOfClosingExceeding = (Integer)(Utility.isNullOrZeroDecimal(oprDetailYTD.Average_days_of_Exceedings__c));
        flagNameValueMap.put('Delay in closing of exceeding (Adhoc,OD)',String.valueOf(Math.round(promptnessOfClosingExceeding)));
        lowValueChequeReturns = Utility.isNullOrZeroDecimal(oprDetailYTD.Minimum_Return_Amount__c);
        flagNameValueMap.put('Low value cheque returns (Rs.)',String.valueOf(Math.round(lowValueChequeReturns)));
        outwardChequeReturns = (Integer)Utility.isNullOrZeroDecimal(oprDetailYTD.Outward_check_return__c);
        flagNameValueMap.put('Outward cheque returns',String.valueOf(Math.round(outwardChequeReturns)));
        highValueChequeReturns = Utility.isNullOrZeroDecimal(oprDetailYTD.Maximum_Return_Amount__c);
        flagNameValueMap.put('High value cheque returns (Rs.)',String.valueOf(Math.round(highValueChequeReturns)));
        LCBG_Devolvement = (Integer)Utility.isNullOrZeroDecimal(oprDetailYTD.Devolvement_BG_Count__c)+(Integer)Utility.isNullOrZeroDecimal(oprDetailYTD.Devolvement_LC_Count__c);
        flagNameValueMap.put('LC/BG devolvement (Nos.)',String.valueOf(Math.round(LCBG_Devolvement)));
        CA_WithOtherBanks = Utility.ISStringBlankorNull(app.CA_with_other_banks__c)?'':app.CA_with_other_banks__c;
        flagNameValueMap.put('CA with other banks',CA_WithOtherBanks);
        if(preCheckList.size() > 0)
            delayInSubmittingStockStmnt = preCheckList[0].Complied__c;//(System.Today().daysBetween(m68Data.Account__r.Due_date_of_last_stock_statement_not_upl__c))/365;
        flagNameValueMap.put('Delay in submission of stock statement',delayInSubmittingStockStmnt);
        foreignBillsRemainingOutstanding = (Integer)Utility.isNullOrZeroDecimal(oprDetailYTD.Number_of_Bills__c);
        flagNameValueMap.put('Foreign bills overdue (Nos.)',String.valueOf(Math.round(foreignBillsRemainingOutstanding)));
        //#####Applicant
        companyPremise = Utility.ISStringBlankorNull(oprDetail.Company_premises__c)?'':oprDetail.Company_premises__c;//@@---to be uploaded
        flagNameValueMap.put('Company premise (Owned/Leased/Rented)',companyPremise);
        if(app.genesis__Account__r.CUSTSINCE__c != null){
            lengthOfRelationshipWithTheBank = System.Today().year()-app.genesis__Account__r.CUSTSINCE__c.year();
        }
        else
            lengthOfRelationshipWithTheBank = 0;
        flagNameValueMap.put('Length of relationship with the bank',String.valueOf(Math.round(lengthOfRelationshipWithTheBank)));
        successionPlan = Utility.ISStringBlankorNull(app.Succession_plan__c)?'':app.Succession_plan__c;//FE
        flagNameValueMap.put('Succession plan',String.valueOf(successionPlan));
        managementExperience = Utility.ISStringBlankorNull(app.Management_experience__c)?'':app.Management_experience__c;//FE
        flagNameValueMap.put('Management experience',String.valueOf(managementExperience));
        courtCases = Utility.ISStringBlankorNull(app.Court_cases_non_credit_related__c)?'':app.Court_cases_non_credit_related__c;//FE
        flagNameValueMap.put('Court cases ( non credit related)',String.valueOf(courtCases));
        //########Bureauo calculation
        if(!rankList.isEmpty()) CMR = rankList[0].Rank_Value__c != null && rankList[0].Rank_Value__c != 'NA' ? Integer.valueOf(rankList[0].Rank_Value__c.subString(4,rankList[0].Rank_Value__c.length())) : 0;//TU--TransUnion Credit Report--Rank Value
        flagNameValueMap.put('CMR',String.valueOf(CMR));
        DPD_Status_Worst_DPD = Utility.isNullOrZeroDecimal(dpdStatusWorst);//TU
        flagNameValueMap.put('DPD status- worst DPD (last 1 year)',String.valueOf(Math.round(DPD_Status_Worst_DPD)));
        noOfEnquiries = math.round(Utility.isNullOrZeroDecimal(enqSumm.Total__c));//TU--TransUnion Credit Report--Enquiry_Summary__c.Total__c
        flagNameValueMap.put('No of enquiries',String.valueOf(noOfEnquiries));
        noOfSuitsFiled = Math.round(Utility.isNullOrZeroDecimal(suitFiledTotal));//TU--TransUnion Credit Report--Derogatory Information(Type/SubType)
        flagNameValueMap.put('No of suits filed (credit related)',String.valueOf(noOfSuitsFiled));
        externalRating = Utility.ISStringBlankorNull(tuMessage.Credit_Rating_Summary_Message__c)?'':tuMessage.Credit_Rating_Summary_Message__c;//TU--TransUnion Credit Report---TU Message--Credit Rating Summary Message
        flagNameValueMap.put('External rating',String.valueOf(externalRating));
        //########Collateral calculation
        flagNameValueMap.put('Type of security',String.valueOf(typeOfsecurity));
        securityCoverage = app.Security_coverage__c;
        flagNameValueMap.put('Security coverage (%)',String.valueOf(Math.round(Utility.isNullOrZeroDecimal(securityCoverage))));
        availabilityOfFullInsurance = String.valueOf(fullInsuranceValue.setScale(1));
        flagNameValueMap.put('Availability of full insurance',String.valueOf(availabilityOfFullInsurance));
        //########Market calculation
        natureOfProductManufacturedTraded = Utility.ISStringBlankorNull(app.Nature_of_product_manufactured_traded__c)?'':app.Nature_of_product_manufactured_traded__c;//FE
        flagNameValueMap.put('Nature of product manufactured / traded',String.valueOf(natureOfProductManufacturedTraded));
        sellingAndDistributionArrangement = Utility.ISStringBlankorNull(app.Selling_and_distribution_arrangement__c)?'':app.Selling_and_distribution_arrangement__c;//FE
        flagNameValueMap.put('Selling and distribution arrangement',String.valueOf(sellingAndDistributionArrangement));
        industryOutlook = Utility.ISStringBlankorNull(app.Industry_outlook__c)?'':app.Industry_outlook__c;//FE
        flagNameValueMap.put('Industry outlook',String.valueOf(industryOutlook));
        if(app.Competition__c != null) competition = app.Competition__c;//FE
        flagNameValueMap.put('Competition',String.valueOf(competition));
        governmentPolicies = Utility.ISStringBlankorNull(app.Government_policies__c)?'':app.Government_policies__c;//FE
        flagNameValueMap.put('Government policies',String.valueOf(governmentPolicies));
        externalCertfications = Utility.ISStringBlankorNull(app.External_certfications__c)?'':app.External_certfications__c;//FE
        flagNameValueMap.put('External certfications',String.valueOf(externalCertfications));
        //if(negativeListMatch != '') flagNameValueMap.put('Negative list match',negativeListMatch);
        flagNameValueMap.put('Negative list match',negativeListMatch);
        
        //Flag creation cuChildList
        Credit_Underwriting__c  cuChild;
        if(!categoryMap.isEmpty()){
            for(Id catId : categoryMap.keySet()){
                if(!categoryMap.get(catId).Flag_Variables__r.isEmpty()){
                    for(Flag_Variable__mdt flagvar : categoryMap.get(catId).Flag_Variables__r){
                        if(!(app.recordType.DeveloperName == 'SME_Renewal' && app.Overall_Exposure__c < overAllExposure && (flagvar.MasterLabel == 'Credit summation to curr yr sales(%)' || flagvar.MasterLabel == 'Debit summation to prev yr purchase(%)' || flagvar.MasterLabel == 'Debit summation to curr yr purchase(%)'))){
                            if(!(((flagvar.MasterLabel == 'Debit summation to prev yr purchase(%)' || flagvar.MasterLabel == 'CA with other banks' || flagvar.MasterLabel == 'Exceedings (# of times)' || flagvar.MasterLabel == 'LC/BG devolvement (Nos.)' || flagvar.MasterLabel == 'Foreign bills overdue (Nos.)' || flagvar.MasterLabel == 'Delay in submission of stock statement' || flagvar.MasterLabel == 'Promptness of closing exceeding(days)'|| flagvar.MasterLabel == 'Management experience'|| flagvar.MasterLabel == 'Length of relationship with the bank' || flagvar.MasterLabel == 'Net profit Margin(%)' || flagvar.MasterLabel == 'Operating Margin(%)' || flagvar.MasterLabel == 'Delay in closing of exceeding (Adhoc,OD)') && app.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE && app.Type__c != null && app.Type__c.contains('New to credit')) || ((flagvar.MasterLabel == 'Debit summation to prev yr purchase(%)' || flagvar.MasterLabel == 'Delay in closing of exceeding (Adhoc,OD)' || flagvar.MasterLabel == 'Delay in submission of stock statement') && app.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE && app.New_to_Business__c))){
                                cuChild = new Credit_Underwriting__c();
                                if(flagvar.MasterLabel == 'Sales trend (CAGR-3 yrs)' && Math.round(salesTrend_3_yrs) <= 0){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Operating Margin(%)' && operatingMargin <= 0){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'TOL/ TNW' && TOL_TNW >= 8){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Debtors velocity(days)' && debtorsVelocity > 180){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Creditors velocity(days)' && creditorsVelocity > 120){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Quick ratio' && quickRatio <0.9 && quickRatio >= 2){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Projected vs Actual sales(%)' && projectedVsActualsAchievementsOfSales < 80){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Debit summation to prev yr purchase(%)' && debitSumComparedToPrevYrPurch < 60){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Credit summation to prev yr sales(%)' && app.Credit_summation_compared_to_previous_yr__c < 60){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Exceedings (# of times)' && exceedings > 6){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Delay in closing of exceeding (Adhoc,OD)' && promptnessOfClosingExceeding > 30){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Delay in submission of stock statement' && delayInSubmittingStockStmnt == 'Yes'){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'CMR' && CMR >= 6){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'DPD status- worst DPD (last 1 year)' && DPD_Status_Worst_DPD > 30){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Succession plan' && app.Succession_plan__c == 'The key person is more than 60 years old and no succession plan in place'){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                } 
                                else if(flagvar.MasterLabel == 'Management experience' && app.Management_experience__c == 'New to Business Line (less than 1 year in the line of business).' && app.Type__c != null && !app.Type__c.contains('New to credit')){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                } 
                                else if(flagvar.MasterLabel == 'Court cases ( non credit related)' && app.Court_cases_non_credit_related__c == 'Yes'){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Industry outlook' && app.Industry_outlook__c != 'Red'){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Government policies' && app.Government_policies__c == 'Negative influence in the form high excise burden, unviable price regulation, forced production limits, cheaper imports, unfavorable labor laws, freebies.'){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Company premise (Owned/Leased/Rented)' && companyPremise == 'Rented'){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Negative list match' && negativeListMatch != ''){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'CA with other banks' && app.CA_with_other_banks__c == 'Yes'){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'LC/BG devolvement (Nos.)' && LCBG_Devolvement > 0){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Foreign bills overdue (Nos.)' && foreignBillsRemainingOutstanding > 0){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'Competition' && app.Competition__c == 'Borrower faces heavy competition'){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'No of suits filed (credit related)' && noOfSuitsFiled > 0){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else if(flagvar.MasterLabel == 'No of enquiries' && noOfEnquiries >= 3){
                                    cuChildFlagList.add(createCUChildRecord(catId,flagvar));
                                }
                                else{
                                    System.debug('###ScoreVar###'+flagvar.MasterLabel);
                                    cuChild = new Credit_Underwriting__c(RecordTypeId = cuChildScoreRecTypeId);
                                    cuChild.Underwriting_Variable__c = cuParentIdMap.get(categoryMap.get(catId).MasterLabel);
                                    cuChild.Appraisal__c = categoryMap.get(catId).MasterLabel;
                                    cuChild.Variable_type__c = flagvar.MasterLabel;
                                    cuChild.Flags_Value__c = flagNameValueMap.get(flagvar.MasterLabel);
                                    cuChild.Flags_Range__c = flagvar.Range__c;
                                    cuChild.Threshold_breached__c = false;
                                    cuChild.Application_Value__c = flagNameValueMap.get(flagvar.MasterLabel);
                                    cuChild.Application_Weight__c = 'N/A';
                                    cuChild.Application_Score__c = 'N/A';
                                    cuChildFlagList.add(cuChild);
                                }
                            }
                        }
                    }
                }
            }
        }
        RETURN cuChildFlagList;
    }
    public static void updateCategoryValues(genesis__Applications__c app,Boolean firstRun){//7
        List<Task> taskCompleteList = new List<Task>();
        List<Credit_Underwriting__c> cuDetails = new List<Credit_Underwriting__c>();
        try{
            cuDetails = [SELECT Id,Appraisal__c,recordTypeId,Application_Score__c,Application_Weight__c,Application_Value__c,(SELECT Id,Threshold_breached__c,Appraisal__c,recordTypeId,Application_Weight__c,Application_Score__c,Application_Value__c FROM Credit_Underwritings__r) FROM Credit_Underwriting__c WHERE Application__c =: app.Id];
        }catch(Exception qe){}
        Boolean fillingInitiatedFlag    = false;
        Boolean newLoanFlagCheck        = false;
        Decimal overallScore            = 0.0;
        if(!cuDetails.isEmpty()){
            for(Credit_Underwriting__c cuParent : cuDetails){
                if(!cuParent.Credit_Underwritings__r.isEmpty()){
                    Decimal scoreValue = 0.0;
                    Decimal weightValue = 0.0;
                    for(Credit_Underwriting__c cuChild : cuParent.Credit_Underwritings__r){
                        //if(cuChild.recordTypeId == cuChildScoreRecTypeId){
                            if(cuChild.Application_Score__c != null){
                                scoreValue += checkDecimal(cuChild.Application_Score__c);
                                overallScore += checkDecimal(cuChild.Application_Score__c);
                            }
                        //}
                        //Check for any flag breached for Accountoperation and bureau
                        if((cuParent.Appraisal__c == 'Account operation' || cuParent.Appraisal__c == 'Bureau') && cuChild.Threshold_breached__c == true)
                            fillingInitiatedFlag = true;
                        //Check breached flag for new loan
                        if(cuChild.Threshold_breached__c == true) newLoanFlagCheck = true;
                    }
                    cuParent.Application_Score__c = String.valueOf(scoreValue);
                    cuParent.Application_Weight__c = String.valueOf(Math.round(weightValue));
                }
            }
            UPDATE cuDetails;
        }
        if(app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE || app.RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE){
            //Task creation on BRE run for application owner
            Task taskRec = SanctionUnderwriting_Process.getTaskObj(app.Id, app.OwnerId, SanctionUnderwriting_Process.SANC_OFFICER_TASK_SUBJ, SanctionUnderwriting_Process.APPILICATION_REVIEW);
            taskRec.ActivityDate = System.today()+1;
            
            SanctionUnderwriting_Process.createTaskforOtherAuthority(taskRec);
            if(app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE){
                if(!firstRun){
                    app.Application_Stage__c = 'Application review -with financials';
                    app.OD_limit_creation_updation__c = false;
                    app.Charge_collection_done__c = false;
                }else{
                    //Change of application stage for breached flags or after limit check
                    if(AccountTriggerHandler.limitCalculation(app)){
                        app.Application_Stage__c = 'Application Review - Final Authority';
                    }
                    else if(fillingInitiatedFlag){
                        app.Application_Stage__c = 'Application review';
                    }
                    else{
                        app.Application_Stage__c = 'Application filling initiated';
                    }
                }
                app.Application_UI_Stage__c = 'NA';
            }
        }
        app.Overall_Score__c = String.valueOf(overallScore);
        Boolean isRejected = false;
        if(overallScore < KVB_Company_Details__c.getOrgDefaults().Rejection_Threshold__c && (app.RecordType.DeveloperName ==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || app.RecordType.DeveloperName ==Constants.SME_NEW_LOAN_RECORD_TYPE )){// && !app.New_to_Business__c
            genesis__Applications__c appInactive    =   new genesis__Applications__c();
            isRejected                              = true;
            If(app.Application_to_close__c){
                Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.SME_RECORD_TYPE_LABEL).getRecordTypeId();
                app.RecordTypeId   =  devRecordTypeId;
                app.Application_Stage__c = 'Application review -with financials';
                app.Application_UI_Stage__c ='Submission';
                app.Type__c             = 'Final Sanction';
                If(app.Parent_Application__c !=null){
                    appInactive = getDueDatebyAppId(app.Parent_Application__c);
                    appInactive.Active__c   = false;
                    listApplication.add(appInactive);
                }
            }else{
                if(app.New_to_Business__c){
                    if(app.No_of_years_of_operation__c >= 1){
                        app.Application_Stage__c = 'Application Rejected';
                        //taskCompleteList = SOQL_Util.completeTask(app.Id);
                        taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
                    }else{
                        isRejected = false;
                    }
                }
                else{
                    app.Application_Stage__c = 'Application Rejected';
                    //taskCompleteList = SOQL_Util.completeTask(app.Id);
                    taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
                }
            }
            If(appInactive.Renewal_Due_Date__c !=null){
                app.Renewal_Due_Date__c = appInactive.Renewal_Due_Date__c;
            }
        }
        else if(overallScore < KVB_Company_Details__c.getOrgDefaults().Rejection_Threshold__c && (app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING || app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC )){
            app.Application_Stage__c        = 'Application Rejected';
            isRejected                      = true;
            //taskCompleteList = SOQL_Util.completeTask(app.Id);
            taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
        }
        else if(overallScore > KVB_Company_Details__c.getOrgDefaults().Rejection_Threshold_New_Loan__c && !newLoanFlagCheck && app.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
            app.Application_Stage__c        = 'New loan - Informal sanction through STP';
        }
        app.BRE_Done__c         = true;
        listApplication.add(app);
        
        If(listApplication.size() > 0){
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE listApplication;
            if(taskCompleteList.size() > 0){
                TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
                UPDATE taskCompleteList;
            }
            if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE)
                updateBreSpread_Renewal(app.Id);
            try{
                Set<String> setOfString = new Set<String>{app.id};
                    sendSMS(app.id);
            }catch(Exception e){
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
                System.debug(e.getStackTraceString());
                System.debug('Exception'+e.getMessage());
            }
        }
        if(!isRejected && (app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING || app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || app.RecordType.DeveloperName ==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || app.RecordType.DeveloperName ==Constants.SME_NEW_LOAN_RECORD_TYPE)){
            deleteChildFacilities(new Set<String>{app.Id});
            if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                SanctionMatrixControllerHelper_EA.createAuthorityRecommendationForBM(app.Id);
            }else if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC || app.RecordType.DeveloperName ==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || app.RecordType.DeveloperName ==Constants.SME_NEW_LOAN_RECORD_TYPE){
                Underwriting_CTRL_Helper.createBMAuthRecommendationIfNotExist(app.Id);
            }
        }
        System.debug('BRE run completed!!!');
    }
    public static genesis__Applications__c getDueDatebyAppId(String appId){//8
        genesis__Applications__c app = [select id,Renewal_Due_Date__c from genesis__Applications__c where Id =:appId];
        If(app !=null){
            return app;
        }
        return null;
    }
    webservice static void sendSMS(String appId){//9
        SME_SendSMSService.sendSMSApp_SME(new Set<String>{appId});
    }
    public static void deleteChildFacilities(Set<String> appIdSet){//10
        List<Facility__c> childFacilityList = new List<Facility__c>();
        if(!appIdSet.iseMpty()){
            childFacilityList = [SELECT Id FROM Facility__c WHERE facility__r.Application__c IN : appIdSet AND RecordType.DeveloperName = 'Child'];
        }
        if(!childFacilityList.isEmpty()){
            DELETE childFacilityList;
        }
    }
    public static Credit_Underwriting__c createCUChildRecord(Id catId,Flag_Variable__mdt flagvar){//11
        Credit_Underwriting__c  cuChildFlag = new Credit_Underwriting__c();
        cuChildFlag = new Credit_Underwriting__c(RecordTypeId = cuChildFlagRecTypeId);
        cuChildFlag.Underwriting_Variable__c = cuParentIdMap.get(categoryMap.get(catId).MasterLabel);
        cuChildFlag.Appraisal__c = categoryMap.get(catId).MasterLabel;
        cuChildFlag.Variable_type__c = flagvar.MasterLabel;
        cuChildFlag.Flags_Value__c = flagNameValueMap.get(flagvar.MasterLabel);
        cuChildFlag.Flags_Range__c = flagvar.Range__c;
        cuChildFlag.Threshold_breached__c = true;
        RETURN cuChildFlag;
    }
    public static Decimal checkDecimal(String valToCheck){//12
        if(valToCheck == null)
            RETURN 0;
        else{
            try{
                RETURN Decimal.valueOf(valToCheck);
            }
            catch(Exception e){
                RETURN 0;
            }
        }
    }
    public static Decimal calculateDPDVal(List<TU_CFHistory__c> tuCreditHistoryList){//13
        Decimal dpdVal = 0.0;
        Decimal totalDPDLocal = 0.0;
        for(TU_CFHistory__c tuCreditHistory : tuCreditHistoryList){
            if(tuCreditHistory.ACorDPD__c != null){
                if(tuCreditHistory.ACorDPD__c.equalsIgnoreCase('Standard')){
                    totalDPDLocal += 0;
                    dpdVal = 0;
                }else if(tuCreditHistory.ACorDPD__c.equalsIgnoreCase('SUB-STANDARD')){
                    totalDPDLocal += 91;
                    dpdVal = 91;
                }else if(tuCreditHistory.ACorDPD__c.equalsIgnoreCase('LOSS')){
                    totalDPDLocal += 432;
                    dpdVal = 432;
                }else if(tuCreditHistory.ACorDPD__c.equalsIgnoreCase('SPECIAL MENTION ACCOUNT')){
                    totalDPDLocal += 30;
                    dpdVal = 30;
                }else if(tuCreditHistory.ACorDPD__c.containsIgnoreCase('SMA-0')){
                    totalDPDLocal += 30;
                    dpdVal = 30;
                }else if(tuCreditHistory.ACorDPD__c.containsIgnoreCase('SMA-1')){
                    totalDPDLocal += 60;
                    dpdVal = 60;
                }else if(tuCreditHistory.ACorDPD__c.containsIgnoreCase('SMA-2')){
                    totalDPDLocal += 90;
                    dpdVal = 90;
                }else if(tuCreditHistory.ACorDPD__c.containsIgnoreCase('DOUBTFUL')){
                    totalDPDLocal += 91;
                    dpdVal = 91;
                }else if(tuCreditHistory.ACorDPD__c.containsIgnoreCase('DAYS PAST DUE')){
                    String firstArg = tuCreditHistory.ACorDPD__c.split(' ')[0];
                    totalDPDLocal += Decimal.ValueOf(firstArg);
                    dpdVal = Decimal.ValueOf(firstArg);
                }
                if(dpdVal > dpdStatusWorst) dpdStatusWorst = dpdVal;
            }
        }
        RETURN totalDPDLocal;
    }
    public static Decimal checkFormatMax(Decimal valToStore, String valToCheck){//4
        if(valToCheck != null){
            List<String> splitedValue = valToCheck.split('-');
            if(valToStore < Decimal.valueOf(splitedValue[splitedValue.size()-1])){
                valToStore = Decimal.valueOf(splitedValue[splitedValue.size()-1]);
            }
        }
        RETURN valToStore;
    }
    public static void sendSMSForApplicationReject(genesis__Applications__c appObj , String RecordTypeName){//15
        try{
            if(appObj !=null && RecordTypeName !=null && RecordTypeName != '' && (RecordTypeName == 'SME Enhancement' || RecordTypeName == 'SME NEW Loan')){
                List<User> userObj= [select id,Name,Email,MobilePhone from User where id=: appObj.Ownerid];
                String messageTemp= 'Application Number <<Application ID>> for <<Customer Name>> has now been converted into a renewal application as the <<original record type>> application has been rejected by sanction authority. Please proceed to complete renewal process for existing facilities';
                messageTemp = messageTemp.replace('<<Application ID>>',appObj.Name);
                messageTemp = messageTemp.replace('<<Customer Name>>',appObj.genesis__Account__r.Name);
                messageTemp = messageTemp.replace('<<original record type>>',RecordTypeName);
                if(userObj[0].MobilePhone != null && userObj[0].MobilePhone != ''){
                    String mobileStrNumber= userObj[0].MobilePhone;
                    If(mobileStrNumber.length() == 12){
                        SMS_Services.sendSMSCall(mobileStrNumber,messageTemp);
                    }else if(mobileStrNumber.length() == 10){
                        mobileStrNumber    = '91'+mobileStrNumber;
                        SMS_Services.sendSMSCall(mobileStrNumber,messageTemp);
                    }
                }
                if(userObj[0].Email !=null && userObj[0].Email !=''){
                    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                    String logoUrl = SME_Email_Handler.getDocumentLogoUrl();
                    String emailBody = 'Dear '+userObj[0].Name+',<br/>  Application number '+appObj.Name+' for '+appObj.genesis__Account__r.Name +' has now been converted into a renewal application as the '+RecordTypeName+' application has been rejected by sanction authority. Please proceed to complete renewal process for existing facilities';
                    emailBody +='<br/>'+'<img src="'+logoUrl+'"/>'+'\t <b>Karur Vysya Bank</b>';
                    emails.add(SME_Email_Handler.getEmailTemplates(userObj[0].Email,emailBody));
                    Messaging.sendEmail(emails);
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getStackTraceString());
            System.debug('Exception_Message'+e.getMessage() + 'Line Number '+e.getLineNumber());
        }
    }
    public static integer getNoOfyearOfOperation(date incorpDate){
        date todaydate=system.today();
        integer startfinyear;
        integer enddatefinyear;
        if(incorpDate.month() < 4 ||(incorpDate.month() == 4 && incorpDate.day() == 1))
            startfinyear = incorpDate.year();
        else
            startfinyear = (incorpDate.addYears(1)).year();
        if(todaydate.month() > 3 ||(incorpDate.month() == 3 && todaydate.day() == 31))
            enddatefinyear = todaydate.year();  
        else
            enddatefinyear = (todaydate.year())-1;
        enddatefinyear = enddatefinyear - startfinyear;
        return enddatefinyear;        
    }
    @future
    public static void updateBreSpread_Renewal(String appId){
    Underwriting_CTRL_Helper.updateBreSpreadAfterBREForRenewal(appId);        
    }
}