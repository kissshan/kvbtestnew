/**
 * Created by ET-MARLABS on 26-12-2018.
 */

public with sharing class SecurityCoverageRefactorModel {

    public static List<String> applicationStagetoBeExcluded = new List<String>{'Discontinued Application','Deactivated Applications','Duplicate Application','New loan - Application rejected','New loan- Declined by customer','New loans - Application created','Application Rejected','Adhoc- Application created','Enhancement- Delined by customer','Enhancement- Application created','Account Closed'};

    public Static Map<Id,genesis__Application_Collateral__c> getAllApplicationColletrForApplication(String appId){
        return new Map<Id,genesis__Application_Collateral__c> ( [SELECT id,Allocated_residual__c,Allocated_Amount__c,Application__r.RecordType.DeveloperName,Application__r.genesis__Account__r.Constitution__c,Facility__r.Account_Number__c,Application__r.Application_Stage__c,genesis__Collateral__r.Name,Facility__r.CL_Product__r.Facility_Code__c,genesis__Collateral__c,genesis__Collateral__r.clcommon__Value__c,Facility__r.Product_Name__c,Facility__r.BRE_Limit__c,genesis__Collateral__r.EM_Date__c,Facility__c,Security_Type__c,Application__r.Active__c FROM genesis__Application_Collateral__c WHERE Application__c =: appId And (Application__r.Active__c =true OR Application__r.RecordType.DeveloperName ='Term_Loan') And Facility__r.Active__c=true And Application__r.RecordType.DeveloperName !='SME_Exceeding' And Application__r.Application_Stage__c NOT IN:applicationStagetoBeExcluded]);
    }
    public Static Map<Id,genesis__Application_Collateral__c> getAllApplicationColletrForGivenCollaterals(List<String> colIds){
        return new Map<Id,genesis__Application_Collateral__c> ( [SELECT id,Allocated_residual__c,Allocated_Amount__c,Application__r.RecordType.DeveloperName,Application__r.genesis__Account__r.Constitution__c,Facility__r.Account_Number__c,Application__r.Application_Stage__c,genesis__Collateral__r.Name,Facility__r.CL_Product__r.Facility_Code__c,genesis__Collateral__c,genesis__Collateral__r.clcommon__Value__c,Facility__r.Product_Name__c,Facility__r.BRE_Limit__c,genesis__Collateral__r.EM_Date__c,Facility__c,Security_Type__c,Application__r.Active__c FROM genesis__Application_Collateral__c WHERE genesis__Collateral__c IN :colIds And (Application__r.Active__c =true OR Application__r.RecordType.DeveloperName ='Term_Loan') And Facility__r.Active__c=true And Application__r.RecordType.DeveloperName !='SME_Exceeding' And Application__r.Application_Stage__c NOT IN:applicationStagetoBeExcluded]);
    }

    public Static list<genesis__Application_Collateral__c> getAllApplicationColletrForCollaterals(Set<String> colIds){
        list<genesis__Application_Collateral__c> appCollToBeReturned = [SELECT id,Application__r.RecordType.DeveloperName,genesis__Collateral__c,Application__r.Application_Stage__c,Facility__r.Account_Number__c,Facility__r.CL_Product__r.Facility_Code__c,genesis__Collateral__r.Name,genesis__Collateral__r.clcommon__Value__c,Facility__c,Facility__r.Product_Name__c,Facility__r.BRE_Limit__c,Facility__r.CL_Product__r.Name,Security_Type__c,genesis__Collateral__r.EM_Date__c,genesis__Collateral__r.CreatedDate,Application__r.Active__c FROM genesis__Application_Collateral__c WHERE genesis__Collateral__c IN :colIds AND (Application__r.Active__c =true OR Application__r.RecordType.DeveloperName ='Term_Loan') And Facility__r.Active__c=true And Application__r.RecordType.DeveloperName !='SME_Exceeding' And Application__r.Application_Stage__c NOT IN:applicationStagetoBeExcluded ORDER BY  genesis__Collateral__r.EM_Date__c ASC, genesis__Collateral__r.CreatedDate ASC];

        Map<String,genesis__Application_Collateral__c> nonDupe =  new Map<String, genesis__Application_Collateral__c>();
        Map<String,List<genesis__Application_Collateral__c>> dupe =  new Map<String, List<genesis__Application_Collateral__c>>();

        List<genesis__Application_Collateral__c> tempNonDuplicate = new List<genesis__Application_Collateral__c>();
        List<genesis__Application_Collateral__c> duplicateFindingList = new List<genesis__Application_Collateral__c>();

        // work for Facility where Account number is null -> New Loan
        for(genesis__Application_Collateral__c appColRec:appCollToBeReturned){
            System.debug('appColRec.Facility__r.Account_Number__c'+appColRec.Facility__r.Account_Number__c);
            if(String.isBlank(appColRec.Facility__r.Account_Number__c)){

                tempNonDuplicate.add(appColRec);

            }else{
                 duplicateFindingList.add(appColRec);

            }
        }
        System.debug('tempNonDuplicate'+tempNonDuplicate);
        System.debug('duplicateFindingList'+duplicateFindingList);
        List<genesis__Application_Collateral__c> tepAppCollList = new List<genesis__Application_Collateral__c>();
        for(genesis__Application_Collateral__c appColRec:duplicateFindingList){
                // nondupe will get emptied at the very second app col ->
                // if Up
                // if facility Account number exist in dupe, then put it in dupe
                if(dupe.containsKey(appColRec.Facility__r.Account_Number__c)){
                    dupe.get(appColRec.Facility__r.Account_Number__c).add(appColRec);
                    continue;
                }
                if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC && appColRec.Application__c != SecurityCoverageRefactor.applicationId){
                    tepAppCollList.add(appColRec);
                    //nonDupe.put(appColRec.Facility__r.Account_Number__c,appColRec);
                    System.debug('tepAppCollList'+tepAppCollList);
                    continue;
                }
                if(!nonDupe.containsKey(appColRec.Facility__r.Account_Number__c)){
                    nonDupe.put(appColRec.Facility__r.Account_Number__c,appColRec);
                    System.debug('nonDupe'+nonDupe);
                }else {
                    genesis__Application_Collateral__c appTempRec = nonDupe.get(appColRec.Facility__r.Account_Number__c);
                    nonDupe.remove(appColRec.Facility__r.Account_Number__c);
                    if(dupe.containsKey(appColRec.Facility__r.Account_Number__c)){
                        dupe.get(appColRec.Facility__r.Account_Number__c).add(appColRec);
                        dupe.get(appColRec.Facility__r.Account_Number__c).add(appTempRec);
                        System.debug('dupe'+dupe);
                    }else{
                        dupe.put(appColRec.Facility__r.Account_Number__c,new List<genesis__Application_Collateral__c>{appColRec,appTempRec});
                        System.debug('dupe'+dupe);
                    }
                    /*if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC && appColRec.Application__c != SecurityCoverageRefactor.applicationId){
                        tepAppCollList.add(appColRec);
                        //nonDupe.put(appColRec.Facility__r.Account_Number__c,appColRec);
                        System.debug('nonDupe'+nonDupe);
                        continue;
                    }else{
                        genesis__Application_Collateral__c appTempRec = nonDupe.get(appColRec.Facility__r.Account_Number__c);
                        nonDupe.remove(appColRec.Facility__r.Account_Number__c);
                        if(dupe.containsKey(appColRec.Facility__r.Account_Number__c)){
                            dupe.get(appColRec.Facility__r.Account_Number__c).add(appColRec);
                            dupe.get(appColRec.Facility__r.Account_Number__c).add(appTempRec);
                            System.debug('dupe'+dupe);
                        }else{
                            dupe.put(appColRec.Facility__r.Account_Number__c,new List<genesis__Application_Collateral__c>{appColRec,appTempRec});
                            System.debug('dupe'+dupe);
                        }
                    }*/

                }

        }
        System.debug('nonDupe nonDupe'+nonDupe);
        System.debug('dupe'+dupe);
        if(nonDupe.size()>0){
            tempNonDuplicate.addAll(nonDupe.values());
        }
        if(tepAppCollList.size()>0){
            tempNonDuplicate.addAll(tempNonDuplicate);
        }
        System.debug('tempNonDuplicate'+tempNonDuplicate);
        dupe = getDupeListInOrder(dupe);
        System.debug('dupe'+dupe);
        for(String facAccNumber:dupe.keySet()){
            boolean flagnewLoan = false;
            boolean flagEnhancement = false;
            for(genesis__Application_Collateral__c appColRec:dupe.get(facAccNumber)){
                /*if(appColRec.Application__c == SecurityCoverageRefactor.applicationId){
                    tempNonDuplicate.add(appColRec);
                    continue;
                }*/
                /*if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                    tempNonDuplicate.add(appColRec);
                }*/
                if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){

                    if(appColRec.Application__c == SecurityCoverageRefactor.applicationId){
                        tempNonDuplicate.add(appColRec);

                    }else{
                        System.debug('This line shall not be executed');
                        /*tempNonDuplicate.add(appColRec);
                        break;*/
                    }

                }else if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    flagnewLoan =true;
                    if(appColRec.Application__c == SecurityCoverageRefactor.applicationId){
                        tempNonDuplicate.add(appColRec);

                    }else{
                        tempNonDuplicate.add(appColRec);
                        break;
                    }

                }else if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                    flagEnhancement = true;
                    if(appColRec.Application__c == SecurityCoverageRefactor.applicationId){
                        tempNonDuplicate.add(appColRec);

                    }else{
                        tempNonDuplicate.add(appColRec);
                        break;
                    }
                }else if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE && !flagnewLoan && !flagEnhancement){
                    if(appColRec.Application__c == SecurityCoverageRefactor.applicationId){
                        tempNonDuplicate.add(appColRec);

                    }else{
                        tempNonDuplicate.add(appColRec);
                        break;
                    }
                }
            }
        }
        System.debug('###############'+tempNonDuplicate);
        System.debug('@@@@@@@@@'+tempNonDuplicate);
        return tempNonDuplicate;
        //return [SELECT id,genesis__Collateral__c,Application__r.Application_Stage__c,Facility__r.Account_Number__c,Facility__r.CL_Product__r.Facility_Code__c,genesis__Collateral__r.Name,genesis__Collateral__r.clcommon__Value__c,Facility__c,Facility__r.Product_Name__c,Facility__r.BRE_Limit__c,Facility__r.CL_Product__r.Name,Security_Type__c,genesis__Collateral__r.EM_Date__c,genesis__Collateral__r.CreatedDate,Application__r.Active__c FROM genesis__Application_Collateral__c WHERE genesis__Collateral__c IN :colIds AND (Application__r.Active__c =true OR Application__r.RecordType.DeveloperName ='Term_Loan') And Facility__r.Active__c=true And Application__r.RecordType.DeveloperName !='SME_Exceeding' And Application__r.Application_Stage__c NOT IN:applicationStagetoBeExcluded ORDER BY  genesis__Collateral__r.EM_Date__c ASC, genesis__Collateral__r.CreatedDate ASC];
    }
    public static Map<String,List<genesis__Application_Collateral__c>> getDupeListInOrder(Map<String,List<genesis__Application_Collateral__c>> dupe){
        Map<String,List<genesis__Application_Collateral__c>> dupeToBeReturned = new Map<String, List<genesis__Application_Collateral__c>>();
        List<genesis__Application_Collateral__c> adHocAppCol = new List<genesis__Application_Collateral__c>();
        List<genesis__Application_Collateral__c> newLoanAppCol = new List<genesis__Application_Collateral__c>();
        List<genesis__Application_Collateral__c> enhancementAppCol = new List<genesis__Application_Collateral__c>();
        List<genesis__Application_Collateral__c> renewalAppCol = new List<genesis__Application_Collateral__c>();
        for(String facAccNumber:dupe.keySet()){
            for(genesis__Application_Collateral__c appColRec:dupe.get(facAccNumber)){
                if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                    adHocAppCol.add(appColRec);
                }else if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    newLoanAppCol.add(appColRec);
                }else if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
                    enhancementAppCol.add(appColRec);

                }else if(appColRec.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE){
                    renewalAppCol.add(appColRec);
                }
            }
            System.debug('adHocAppCol'+adHocAppCol);
            System.debug('newLoanAppCol'+newLoanAppCol);
            System.debug('enhancementAppCol'+enhancementAppCol);
            System.debug('renewalAppCol'+renewalAppCol);
            List<genesis__Application_Collateral__c> tempList = new List<genesis__Application_Collateral__c>();
            tempList.addAll(adHocAppCol);
            tempList.addAll(newLoanAppCol);
            tempList.addAll(enhancementAppCol);
            tempList.addAll(renewalAppCol);



            dupeToBeReturned.put(facAccNumber,tempList);
        }
        return dupeToBeReturned;
    }

    public static List<Security_Configuration_Master__mdt> getSecurityMasters(){
       return [Select Id,MasterLabel,DeveloperName,Value_Required_For_Spread_Calculation__c,Is_Collateral_Security_Required__c,Is_Primary_Security_Required__c,Collateral_Security_Coverage__c,Primary_Security_Coverage__c,Priority__c,Residual_Priority__c,CMR_Rules__c from Security_Configuration_Master__mdt];
    }
    public static Map<String,Security_Configuration_Master__mdt> getSecurityMastersByProduct(){
        Map<String,Security_Configuration_Master__mdt> securityMasterByProduct = new Map<String, Security_Configuration_Master__mdt>();
        for(Security_Configuration_Master__mdt securityMasterRec:[Select Id,Value_Required_For_Spread_Calculation__c,Is_Collateral_Security_Required__c,Is_Primary_Security_Required__c,MasterLabel,DeveloperName,Collateral_Security_Coverage__c,Primary_Security_Coverage__c,Priority__c,Residual_Priority__c,CMR_Rules__c from Security_Configuration_Master__mdt]){
            securityMasterByProduct.put(securityMasterRec.MasterLabel,securityMasterRec);
        }
        return securityMasterByProduct;
    }
    public static genesis__Application_Collateral__c getAppCollByFacAndCollId(String facId,String collId){
        return [Select Id,Name,Facility__c,genesis__Collateral__c,Allocated_Amount__c,Application__c,Application__r.Active__c,Application__r.Application_Stage__c  from genesis__Application_Collateral__c where Facility__c=:facId AND genesis__Collateral__c=:collId And (Application__r.Active__c =true OR Application__r.RecordType.DeveloperName ='Term_Loan') And Facility__r.Active__c=true And Application__r.RecordType.DeveloperName !='SME_Exceeding' And Application__r.Application_Stage__c NOT IN:applicationStagetoBeExcluded  LIMIT 1];
    }
    public static Map<Id,Facility__c> getFacilityByFacId(String appId){
                Map<Id,Facility__c> mapToBeReturned = new  Map<Id, Facility__c>();
                for(Facility__c facRecord:SOQL_Util.getFacilities(appId)){
                    mapToBeReturned.put(facRecord.Id,facRecord);
                }
        return mapToBeReturned;
    }
    public static Map<String,String> getFieldLabels(String objName,Set<String> fieldApiName,Boolean reversMap){

        Map<String,String> fieldLabelByFieldApiName =new Map<String, String>();
        Map<String,String> fieldApiByFieldLabel =new Map<String, String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();


        for (String fieldName: fieldMap.keySet()) {
            System.debug('@@@@'+fieldName);
            if(fieldApiName.contains(fieldName)){
                //fieldMap.get(abc).getDescribe().getLabel();
                System.debug('###########'+fieldMap.get(fieldName).getDescribe().getLabel());
                fieldLabelByFieldApiName.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());
                fieldApiByFieldLabel.put(fieldMap.get(fieldName).getDescribe().getLabel(),fieldName);
            }
        }
        if(!reversMap){
            return fieldLabelByFieldApiName;
        }else{
            return fieldApiByFieldLabel;
        }

    }
    public static Customer360view getQuestionAnswerList(String appId){ //Customer360view custView,
        List<New_Loan_Question__c> allNewLoanQuestion = [Select Id,Name,Is_Existing_Question__c,Priority__c from New_Loan_Question__c ];

        Map<String,New_Loan_Question__c> allExistingQuestionSet = new Map<String, New_Loan_Question__c>();
        Map<String,New_Loan_Question__c> allNewQuestionSet = new Map<String, New_Loan_Question__c>();
        for(New_Loan_Question__c newLoanQuestionRec:allNewLoanQuestion){
            if(newLoanQuestionRec.Is_Existing_Question__c){
                allExistingQuestionSet.put(newLoanQuestionRec.Name,newLoanQuestionRec);
            }else{

                allNewQuestionSet.put(newLoanQuestionRec.Name,newLoanQuestionRec);
            }
        }

        Map<String,String> fieldLabelByFieldApiNameForExisting = getFieldLabels('New_Loan_Input__c',allExistingQuestionSet.keySet(),false);
        Map<String,String> fieldLabelByFieldApiNameForNew      = getFieldLabels('New_Loan_Input__c',allNewQuestionSet.keySet(),false);

        System.debug('fieldLabelByFieldApiNameForExisting' +fieldLabelByFieldApiNameForExisting);
        System.debug('fieldLabelByFieldApiNameForNew' +fieldLabelByFieldApiNameForNew);
        /* what_type_of_loans_are_needed__c,hat_tl_facilities_are_needed__c,what_benefits_will_be_achieved__c,what_wc_facilities_are_needed__c,how_will_foling_params_change__c,howmany_mnths_to_rlize_fullbenefit__c,date_of_commercial_production__c*/
        List<New_Loan_Input__c> apprecord = [SELECT Id,Name,current_seating_capacity__c,current_seating_utilization__c,future_seating_capacity__c,future_seating_utilization__c,months_from_dccp__c,sources_of_margin_money__c,what_is_date_of_comercial_prod__c,sources_of_funding__c,areas_of_investment__c,investment_value__c,howmany_mnths_to_rlize_fullbenefit__c,Current_Capacity__c,Future_Capacity__c,Current_Capacity_Utilization__c,Future_Capacity_Utilization__c,Current_Room_Capacity__c,Future_Room_Capacity__c,Current_Room_Utlization__c,Future_Room_Utlization__c,Current_Count_of_Vehicles__c,Future_Count_of_Vehicles__c,Current_Count_of_Employees__c,Future_Count_of_Employees__c,Current_Count_of_Students__c,Future_Count_of_Students__c,Current_Value_of_Orders__c,Future_Value_of_Orders__c,Current_Cost__c,Future_Cost__c,Application__c,WC_facility_with_other_bank__c,TL_facility_with_other_bank__c,Please_select_relevant_WC_banks__c,Please_select_relevant_TL_banks__c,Please_select_relevant_CA_banks__c,facilities_with_other_banks__c,CA_Facility_with_Other_bank__c,Additional_Facility_Other_ank__c from New_Loan_Input__c where Application__c=:appId AND Input_Given_By__c= 'Customer'];

        Customer360view custView= new Customer360view();
        custView.COMPANY_DETAILS= new Customer360view.cls_COMPANY_DETAILS();

        custView.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION = new List<Customer360view.QuestionAndAnswer>();
        custView.COMPANY_DETAILS.NEW_FACILITY_QUESTION = new List<Customer360view.QuestionAndAnswer>();



        for(String keyValue :fieldLabelByFieldApiNameForExisting.keySet()){
            if(allExistingQuestionSet.size()>0 && allExistingQuestionSet.keySet().contains(keyValue)){
                Customer360view.QuestionAndAnswer questionInstance = new Customer360view.QuestionAndAnswer();
                questionInstance.question = fieldLabelByFieldApiNameForExisting.get(keyValue);
                questionInstance.priority= String.valueOf(allExistingQuestionSet.get(keyValue).Priority__c);
                if(apprecord.size()>0)
                questionInstance.answer= String.valueOf(apprecord[0].get(keyValue));
                custView.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION.add(questionInstance);
            }

        }

        for(String keyValue :fieldLabelByFieldApiNameForNew.keySet()){
            if(allNewQuestionSet.size()>0 && allNewQuestionSet.keySet().contains(keyValue)){
                Customer360view.QuestionAndAnswer questionInstance = new Customer360view.QuestionAndAnswer();
                questionInstance.question = fieldLabelByFieldApiNameForNew.get(keyValue);
                questionInstance.priority= String.valueOf(allNewQuestionSet.get(keyValue).Priority__c);
                if(apprecord.size()>0)
                questionInstance.answer= String.valueOf(apprecord[0].get(keyValue));
                custView.COMPANY_DETAILS.NEW_FACILITY_QUESTION.add(questionInstance);
            }

        }


        return custView;
    }
    public static void updateQuestionAndAnswer(Customer360view cust,String appId){

        try {
            List<New_Loan_Question__c> allNewLoanQuestion = [Select Id,Name,Is_Existing_Question__c,Priority__c from New_Loan_Question__c ];
            List<genesis__Applications__c> appRecList = [Select Id,Name,CA_with_other_banks__c from genesis__Applications__c where Id=:appId ];

            Map<String,New_Loan_Question__c> allExistingQuestionSet = new Map<String, New_Loan_Question__c>();
            Map<String,New_Loan_Question__c> allNewQuestionSet = new Map<String, New_Loan_Question__c>();
            for(New_Loan_Question__c newLoanQuestionRec:allNewLoanQuestion){
                if(newLoanQuestionRec.Is_Existing_Question__c){
                    allExistingQuestionSet.put(newLoanQuestionRec.Name,newLoanQuestionRec);
                }else{

                    allNewQuestionSet.put(newLoanQuestionRec.Name,newLoanQuestionRec);
                }
            }

            Map<String,String> fieldLabelByFieldApiNameForExisting = getFieldLabels('New_Loan_Input__c',allExistingQuestionSet.keySet(),true);
            Map<String,String> fieldLabelByFieldApiNameForNew      = getFieldLabels('New_Loan_Input__c',allNewQuestionSet.keySet(),true);
            System.debug('@@@@fieldLabelByFieldApiNameForExisting'+fieldLabelByFieldApiNameForExisting);
            List<New_Loan_Input__c> accRec = [SELECT Id,Name,Application__c,CA_Facility_with_Other_bank__c,Additional_Facility_Other_ank__c from New_Loan_Input__c where Application__c=:appId ORDER BY Input_Given_By__c LIMIT 2];//AND Input_Given_By__c= 'Customer'];
            System.debug('@@@@@cust.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION'+cust.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION);
            if(cust.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION != null){
                for(Customer360view.QuestionAndAnswer questionInstance : cust.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION){
                    System.debug('@@@@@questionInstance'+questionInstance);
                    if(accRec.size()>0){
                        System.debug('@@ questionInstance.question'+questionInstance.question);
                        System.debug('@@ questionInstance.question'+questionInstance.answer);
                        System.debug('@@ fieldLabelByFieldApiNameForExisting.get(questionInstance.question)'+fieldLabelByFieldApiNameForExisting.get(questionInstance.question));
                        accRec[0].put(fieldLabelByFieldApiNameForExisting.get(questionInstance.question),questionInstance.answer);
                    }
                    
                    if(questionInstance.question == 'Do you have CA facility with other bank?' && questionInstance.answer != ''){
                        System.debug('@@@@@questionInstance'+questionInstance.question);
                        appRecList[0].CA_with_other_banks__c = questionInstance.answer;
                    }

                }
            }
            if(cust.COMPANY_DETAILS.NEW_FACILITY_QUESTION != null){
                for(Customer360view.QuestionAndAnswer questionInstance : cust.COMPANY_DETAILS.NEW_FACILITY_QUESTION){
                    if(accRec.size()>0){
                        System.debug('questionInstance.question==> '+questionInstance.question+' questionInstance.answer===> '+questionInstance.answer);
                            /*if(questionInstance.question!='What is date of commercial production?' && questionInstance.question!='What are the sources of funding?' ){
                                System.debug('Anydatatype_msg'+questionInstance.question);
                                System.debug('questionInstance.question======> '+questionInstance.question+ 'questionInstance.question.isNumeric()===> '+questionInstance.question.isNumeric());
                                if( questionInstance.question!='What are the sources of margin money?' && questionInstance.question!='What are the areas of investment?'){//questionInstance.question.isNumeric()== false && ====questionInstance.question=='What is the total investment value?' || =='What is current capacity?'){
                                    accRec[0].put(fieldLabelByFieldApiNameForNew.get(questionInstance.question),Decimal.valueOf(questionInstance.answer));

                                }else{
                                    accRec[0].put(fieldLabelByFieldApiNameForNew.get(questionInstance.question),questionInstance.answer);

                                }
                            }*/

                            /*if(questionInstance.question!='What are the sources of funding?'){*/
                                if(TermLoanConstants.numberList.contains(questionInstance.question) && questionInstance.answer!=null && questionInstance.answer!=''){
                                    accRec[0].put(fieldLabelByFieldApiNameForNew.get(questionInstance.question),Decimal.valueOf(questionInstance.answer));
                                    accRec[1].put(fieldLabelByFieldApiNameForNew.get(questionInstance.question),Decimal.valueOf(questionInstance.answer));
                                }else if(TermLoanConstants.dateList.contains(questionInstance.question) && questionInstance.answer!=null && questionInstance.answer!=''){
                                    accRec[0].put(fieldLabelByFieldApiNameForNew.get(questionInstance.question),Date.valueOf(questionInstance.answer));
                                    accRec[1].put(fieldLabelByFieldApiNameForNew.get(questionInstance.question),Date.valueOf(questionInstance.answer));
                                }else if(TermLoanConstants.StringPickList.contains(questionInstance.question) && questionInstance.answer!=null && questionInstance.answer!=''){
                                    accRec[0].put(fieldLabelByFieldApiNameForNew.get(questionInstance.question),questionInstance.answer);
                                    accRec[1].put(fieldLabelByFieldApiNameForNew.get(questionInstance.question),questionInstance.answer);
                                }

                            //}
                    }
                }
            }
            System.debug('@@@@ accRec[0]'+accRec[0]);
            update accRec;
            System.debug('appRecList=====> '+appRecList);
            update appRecList;
        } catch (Exception e) {
            HandleBusinessException.captureError('SecurityCoverageRefactorModel','updateQuestionAndAnswer',e);
        }
    }




}