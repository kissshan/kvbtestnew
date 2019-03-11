/**
* Created by ET-MARLABS on 21-05-2018.
*/

public with sharing class YTDAnalysisController {

    /**
    * get Estimate Sales Analysis Flag
    *
    * @param sObjectType - The type to register
    *
    */

    public static Map<String , Boolean> creditorDebtorsAnalysisMap      = new Map<String, Boolean>();

    public static Map<String , Boolean> ytdAnalysisMap                  = new Map<String, Boolean>();

    public static Map<String,List<Credit_Underwriting__c>>  getAllFlagAnalysis(String losCustId,String appId){


        String recordTypeName                                           = SOQL_Util.getRecordTypeNameByRecordId(appId);
        Boolean isExceedingAdhocLessThanFifty                           = false;

        if(recordTypeName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || recordTypeName== Constants.SME_APP_RECORD_TYPE_ADHOC || recordTypeName== Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || recordTypeName== Constants.SME_NEW_LOAN_RECORD_TYPE) 
            isExceedingAdhocLessThanFifty                               = YTDAnalysisHelper.isExceedingAdhocLessThanFifty(appId) != null ? YTDAnalysisHelper.isExceedingAdhocLessThanFifty(appId) :false ;

        System.debug('@@@@isExceedingAdhocLessThanFifty---> '+isExceedingAdhocLessThanFifty);
        System.debug('@@@@recordTypeName---> '+recordTypeName);

        Map<String,List<Credit_Underwriting__c>> allFlagMap             = new Map<String,List<Credit_Underwriting__c>>();
        If(losCustId !=null && appId !=null ){
            String Str                                                  = YTDAnalysisHelper.getEstimateSalesAnalysis(losCustId,appId);
            system.debug('String@@@@'+Str);
            If(ytdAnalysisMap !=null){
                // send false for enhancement
                List<Credit_Underwriting__c> listOfCredit               = new List<Credit_Underwriting__c>();
                if(recordTypeName==Constants.SME_APP_RECORD_TYPE_EXCEEDING || recordTypeName== Constants.SME_APP_RECORD_TYPE_ADHOC){
                    listOfCredit = getCreditUnderwritingYTD(ytdAnalysisMap,true);
                }else if(recordTypeName== Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || recordTypeName== Constants.SME_NEW_LOAN_RECORD_TYPE){
                    listOfCredit = getCreditUnderwritingYTD(ytdAnalysisMap,isExceedingAdhocLessThanFifty);
                }
                /*listOfCredit                                            = getCreditUnderwritingYTD(ytdAnalysisMap,isExceedingAdhocLessThanFifty);*/

                If(listOfCredit !=null && !listOfCredit.isEmpty()){
                    allFlagMap.put('Financial Triangulation',listOfCredit);
                    System.debug('List of Credit Underwriting '+listOfCredit);
                }
            }
        }
        /*If(losCustId !=null && (recordTypeName==Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || recordTypeName== Constants.SME_NEW_LOAN_RECORD_TYPE)){
            List<Credit_Underwriting__c> listOfCredit = new List<Credit_Underwriting__c>();
            listOfCredit                                                = YTDAnalysisHelper.getCreditorDebitorsFlag(losCustId);
            If(!listOfCredit.isEmpty()){
                allFlagMap.put('Debtors/Creditors Analysis',listOfCredit);
            }
        }*/
        if(recordTypeName==Constants.SME_NEW_LOAN_RECORD_TYPE){
            List<Credit_Underwriting__c> listOfCredit = new List<Credit_Underwriting__c>();
            //listOfCredit                                                = YTDAnalysisHelper.getGstflags(losCustId,appId);
            listOfCredit=getCreditUnderwritingGST(YTDAnalysisHelper.getGstflags(losCustId,appId));
            If(!listOfCredit.isEmpty()){
                allFlagMap.put('GST Traingulation',listOfCredit);
            }
        }
        If(allFlagMap !=null){
            System.debug('All MAP Flag'+allFlagMap);
            return allFlagMap;
        }
        return new Map<String,List<Credit_Underwriting__c>>();
    }


    //Flag update in Credit Underwriting object for YTD Analysis.
    public static List<Credit_Underwriting__c> getCreditUnderwritingYTD(Map<String , Boolean> ytdAnalysisMap,Boolean isExceedingAdhocLessThanFifty){

        String appraisal = 'Financial Triangulation';
        String applicationScoreRecType = SOQL_Util.getRecordTypeId('Child_Application_Score');
        String childFlagRecType = SOQL_Util.getRecordTypeId('Child_Flag');

        If(ytdAnalysisMap !=null){
            system.debug('ytdAnalysisMap==++'+ytdAnalysisMap);
            List<Credit_Underwriting__c> listOfCredit                   =   new List<Credit_Underwriting__c>();
            for(String str    : ytdAnalysisMap.keySet()){

                If(str !=null && str !='' && !(isExceedingAdhocLessThanFifty)){
                    // Inserting application score type records
                    if(!ytdAnalysisMap.get(str)){
                        Credit_Underwriting__c creditUnderObj               = new Credit_Underwriting__c();
                        creditUnderObj.RecordTypeId                         = applicationScoreRecType;
                        creditUnderObj.Appraisal__c                         = appraisal;
                        creditUnderObj.Variable_type__c                     = str;
                        //creditUnderObj.Flags_Value__c                       = String.valueOf(ytdAnalysisMap.get(str));
                        creditUnderObj.Application_Value__c                       = String.valueOf(YTDAnalysisHelper.ytdAnalysisValueMap.get(str));
                        creditUnderObj.Threshold_breached__c                     = false;
                        listOfCredit.add(creditUnderObj);
                    }

                    // Inserting child flag type records
                    if(ytdAnalysisMap.get(str)){
                        Credit_Underwriting__c creditUnderObjChild               = new Credit_Underwriting__c();
                        creditUnderObjChild.RecordTypeId                         = childFlagRecType;
                        creditUnderObjChild.Appraisal__c                         = appraisal;
                        creditUnderObjChild.Variable_type__c                     = str;
                        creditUnderObjChild.Flags_Value__c                       = String.valueOf(YTDAnalysisHelper.ytdAnalysisValueMap.get(str));
                        creditUnderObjChild.Flags_Range__c                       = String.valueOf(YTDAnalysisHelper.ytdAnalysisRangeMap.get(str));
                        creditUnderObjChild.Threshold_breached__c                     = ytdAnalysisMap.get(str);
                        listOfCredit.add(creditUnderObjChild);
                    }

                }else if(str !=null && str !='' && isExceedingAdhocLessThanFifty){
                    if(str != 'YTD Sales (Rs. )' && str != 'YTD Purchase (Rs.)')
                        continue;
                    else{
                        if(!ytdAnalysisMap.get(str)){
                            Credit_Underwriting__c creditUnderObj           = new Credit_Underwriting__c();
                            creditUnderObj.RecordTypeId                         = applicationScoreRecType;
                            creditUnderObj.Appraisal__c                     = appraisal;
                            creditUnderObj.Variable_type__c                 = str;
                            creditUnderObj.Application_Value__c                   = String.valueOf(YTDAnalysisHelper.ytdAnalysisValueMap.get(str));
                            creditUnderObj.Threshold_breached__c                     = false;

                            listOfCredit.add(creditUnderObj);
                        }


                        if(ytdAnalysisMap.get(str)){
                            Credit_Underwriting__c creditUnderObjChild               = new Credit_Underwriting__c();
                            creditUnderObjChild.RecordTypeId                         = childFlagRecType;
                            creditUnderObjChild.Appraisal__c                         = appraisal;
                            creditUnderObjChild.Variable_type__c                     = str;
                            creditUnderObjChild.Flags_Value__c                       = String.valueOf(YTDAnalysisHelper.ytdAnalysisValueMap.get(str));
                            creditUnderObjChild.Flags_Range__c                       = String.valueOf(YTDAnalysisHelper.ytdAnalysisRangeMap.get(str));
                            creditUnderObjChild.Threshold_breached__c                     = ytdAnalysisMap.get(str);
                            listOfCredit.add(creditUnderObjChild);
                        }
                    }

                }
            }
            If(!listOfCredit.isEmpty()){
                return listOfCredit;
            }

        }
        return new List<Credit_Underwriting__c>();
    }
    public static List<Credit_Underwriting__c> getCreditUnderwritingGST(Map<String , Boolean> creditorDebtorsAnalysisMap){
        system.debug('creditorDebtorsAnalysisMap==++'+creditorDebtorsAnalysisMap);
    	String appraisal = 'GST Traingulation';
        String applicationScoreRecType = SOQL_Util.getRecordTypeId('Child_Application_Score');
        String childFlagRecType = SOQL_Util.getRecordTypeId('Child_Flag');

        If(creditorDebtorsAnalysisMap !=null){
            List<Credit_Underwriting__c> listOfCredit   =   new List<Credit_Underwriting__c>();
            for(String str    : creditorDebtorsAnalysisMap.keySet()){
                If(str !=null && str !=''){
                    // Application Score Records
                    if(!creditorDebtorsAnalysisMap.get(str)){
                        Credit_Underwriting__c creditUnderObj   = new Credit_Underwriting__c();
                        creditUnderObj.RecordTypeId             = applicationScoreRecType;
                        creditUnderObj.Appraisal__c             = appraisal;
                        creditUnderObj.Variable_type__c         = str;
                        //creditUnderObj.Application_Value__c     = String.valueOf(YTDAnalysisHelper.ytdAnalysisValueMap.get(str));
                        creditUnderObj.Threshold_breached__c    = false;
                        listOfCredit.add(creditUnderObj);
                    }
                    

                    if(creditorDebtorsAnalysisMap.get(str)){
                        Credit_Underwriting__c creditUnderObjChild               = new Credit_Underwriting__c();
                        creditUnderObjChild.RecordTypeId                         = childFlagRecType;
                        creditUnderObjChild.Appraisal__c                         = appraisal;
                        creditUnderObjChild.Variable_type__c                     = str;
                        //creditUnderObjChild.Flags_Value__c                       = String.valueOf(YTDAnalysisHelper.ytdAnalysisValueMap.get(str));
                        //creditUnderObjChild.Flags_Range__c                       = String.valueOf(YTDAnalysisHelper.ytdAnalysisRangeMap.get(str));
                        creditUnderObjChild.Flags_Range__c                       = String.valueOf('>15% or <-15%');
                        creditUnderObjChild.Threshold_breached__c                = creditorDebtorsAnalysisMap.get(str);
                        listOfCredit.add(creditUnderObjChild);
                    }
                }
            }
            If(!listOfCredit.isEmpty()){
                return listOfCredit;
            }
        }
        return new List<Credit_Underwriting__c>();
    }



}