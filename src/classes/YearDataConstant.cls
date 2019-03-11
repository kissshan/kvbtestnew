/**
 * Created by ET-MARLABS on 14-06-2018.
 */

global with sharing class YearDataConstant {
    public static final string saveAction                            = 'SAVE';
    public static final string submitAction                          = 'SUBMIT';
    public static Integer currentYear                                = getCurrentYear();
    public static String cyString                                    = String.valueOf(currentYear);
    public static String currFiscalYear                              = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
    public static String nthFiscalYear                               = (currentYear-2)+'-'+Integer.valueOf(String.valueOf(currentYear-1).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
    public static String n_1_FiscalYear                              = (currentYear-3)+'-'+Integer.valueOf(String.valueOf(currentYear-2).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
    public static String n_2_FiscalYear                              = (currentYear-4)+'-'+Integer.valueOf(String.valueOf(currentYear-3).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
    public static String nextEstFiscalYear                           = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
    public static String nextProjFiscalYear                          = (currentYear+1)+'-'+Integer.valueOf(String.valueOf(currentYear+2).subString(String.valueOf(currentYear+2).length()-2,String.valueOf(currentYear+2).length()));
    public static String currFYFullYear                              = (currentYear-1)+'-'+ cyString;
    public static String nextEstFYFullYear                           = currentYear+'-'+String.valueOf(currentYear+1);

    public static void main(){
        //System.debug('@@@@');
    }
    public static Integer getCurrentYear(){
        Integer currentYear;
        if(Date.Today().Month() > 3){
            currentYear = Date.Today().Year();
        }
        else{
            currentYear = (Date.Today().Year()-1);
        }
        RETURN currentYear;
    }
    public static List<String> sendMissingYearsFinancials(String custid){
        List<String> missingyears=new List<String>();
        //System.debug(miSSIngyearS);
        //System.debug(custid);
        //System.debug(custId);
        System.debug(CustId);
        //Date dateofincorporation=new Date();
        List<Account> accList = new List<Account>();
        accList = [SELECT Id,Date_of_Incorporation__c FROM Account WHERE Id =: custId];
        //System.debug('accList ==>'+accList);
        //Boolean subtractyear=false;
        Integer yearofdateofIncorporation=0;
        Date dateofincorporation;
        Date lastfiscalyear;
        Date latestyearfinancial;
        Try{
        if(accList!=null && !accList.isEmpty() && accList[0].Date_of_Incorporation__c!=null){
            dateofincorporation=accList[0].Date_of_Incorporation__c;
            if(date.today().month() <=3){
             lastfiscalyear=date.newInstance(date.today().year()-1,3,31);
            }
            latestyearfinancial=date.newInstance(lastfiscalyear.year(),1,1);
        
        //System.debug('lastfiscalyear '+lastfiscalyear);
        Date maxfinancialyeardetails=date.newInstance(lastfiscalyear.year()-2,3,31);
        System.debug('maxfinancialyeardetails '+maxfinancialyeardetails);
        //System.debug(maxfinancialyeardetails-3);
        yearofdateofIncorporation=dateofincorporation.year();
        if(dateofincorporation!=null){
        if((dateofincorporation) <= (maxfinancialyeardetails)){
            System.debug('same 3 years');
            missingyears.add((maxfinancialyeardetails.year()-1)+'-'+String.valueOf(maxfinancialyeardetails.year()).substring(2));
            missingyears.add((maxfinancialyeardetails.year())+'-'+String.valueOf((maxfinancialyeardetails.year()+1)).substring(2));
            missingyears.add((maxfinancialyeardetails.year()+1)+'-'+String.valueOf((maxfinancialyeardetails.year()+2)).substring(2));
        }
        else {
            if((dateofincorporation) >= (maxfinancialyeardetails+1)){
                System.debug(maxfinancialyeardetails.year());
                System.debug((dateofincorporation.year())-(maxfinancialyeardetails.year()));
                if(((maxfinancialyeardetails.year())-(dateofincorporation.year())) ==0){
                    missingyears.add(dateofincorporation.year()+'-'+String.valueOf((dateofincorporation.year()+1)).substring(2));
                    missingyears.add(((dateofincorporation.year())+1)+'-'+String.valueOf(((dateofincorporation.year())+2)).substring(2));
                }
                else if(((dateofincorporation.year())-(maxfinancialyeardetails.year())) ==1){
                    if(dateofincorporation.month()==1 || dateofincorporation.month()==2 || dateofincorporation.month()==3){
                        missingyears.add(((dateofincorporation.year())-1)+'-'+String.valueOf(((dateofincorporation.year()))).substring(2));
                        missingyears.add(((dateofincorporation.year()))+'-'+String.valueOf(((dateofincorporation.year())+1)).subString(2));
                    }
                    else{
                    missingyears.add(dateofincorporation.year()+'-'+String.valueOf(((dateofincorporation.year())+1)).substring(2));
                    }   
                }
                else if(latestyearfinancial <= dateofincorporation && dateofincorporation <= lastfiscalyear){
                    //System.debug('if date is in last 3 months of fiscal year ');
                    missingyears.add(((dateofincorporation.year())-1)+'-'+String.valueOf(((dateofincorporation.year()))).substring(2));
                }
            }
        }
        }
        }
        }
        catch(Exception ex){
            HandleBusinessException.captureError('Utility', 'sendMissingYearsFinancials =>'+ex.getLineNumber(), ex);
        }
        return missingyears;

    }
    
    public static boolean isPerfiosStatus_Completed(String appId){
        If(appId !=null && appId !=''){
            Integer count = 0;
            List<Perfios__c> listOfPerfios  = [select id,Application__c,Perfios_Status__c,RecordType.DeveloperName from Perfios__c where Application__c =:appId AND RecordType.DeveloperName='SME_New_Loan_Perfios'];
            If(listOfPerfios !=null && listOfPerfios.size() > 0){
                for(Perfios__c perfiosObj   :   listOfPerfios){
                    If(perfiosObj !=null && perfiosObj.Perfios_Status__c =='Completed'){
                        count++ ; 
                    }
                }
                If(count > 0){
                    If(count == listOfPerfios.size()){
                        return true;
                    }
                }
            }else{
                return true;
            }
        }
      return false;  
    }
    public static boolean isTaskCompleted(String appId){
        If(appId !=null && appId !=''){
           Boolean isTakeOver   = false;
           Boolean isMarket     = false;
           List<String> listOftaskType    = new List<String>{'Takeover Intelligence','Market Intelligence'};     
           List<Task> listOfTask    =   [select id,Type,Status,WhatId from Task where WhatId =:appId AND Type IN : listOftaskType AND Status = 'Completed'];
           //system.debug('listOfTask===+++'+listOfTask);
            genesis__Applications__c AppObj  = [select id,Type__c from genesis__Applications__c where id =:appId];
            If(listOfTask !=null && listOfTask.size() > 0){
                for(Task taskObj    :   listOfTask){
                    if(taskObj.Type == 'Takeover Intelligence'){
                        isTakeOver = true;
                    }else if(taskObj.Type == 'Market Intelligence'){
                        isMarket = true;
                    }
                }
                If(AppObj !=null && AppObj.Type__c !=null){
                    If(AppObj.Type__c.contains('ETB-WC') || AppObj.Type__c.contains('ETB-CA')){
                      If(isTakeOver){
                        return true;
                    }    
                    } else if(AppObj.Type__c.contains('NTB')){
                        If(isTakeOver && isMarket){
                        return true;
                    } 
                    }
                }
                
            } else{
                return true;
            }
        }
       return false; 
    }
    public static Boolean isRunBREForNewLoan(String appId){
        Boolean isPerfios   = false;
        Boolean isTask      = false;
        If(appId !=null && appId !=''){
            isPerfios = isPerfiosStatus_Completed(appId);
            isTask    = isTaskCompleted(appId);
        }
        If(isTask && isPerfios){
           return true;    
        }
       return false; 
    }
    public static Boolean isMarketIntelligenceCompleted(String appId){
        If(appId !=null && appId !=''){
            Boolean isMarket     = false;  
            List<String> listOftaskType    = new List<String>{'Market Intelligence'};     
            genesis__Applications__c AppObj  = [select id,Type__c from genesis__Applications__c where id =:appId];
            If(AppObj !=null){
                If(AppObj.Type__c != null && AppObj.Type__c.contains('NTB')){
                    List<Task> listOfTask    =   [select id,Type,Status,WhatId from Task where WhatId =:appId AND Type IN : listOftaskType AND Status = 'Completed'];
                    If(listOfTask !=null && listOfTask.size() > 0){
                        for(Task taskObj    :   listOfTask){
                            if(taskObj.Type == 'Market Intelligence'){
                                isMarket = true;
                            }
                        }
                        If(isMarket){
                            return true;
                        }
                    }    
                }else{
                    return true;
                }
            }
        }
        return false;
    }
    public static Boolean getMinCibilScore_Gr_than_700(String appId){
        if(appId !=null && appId !=''){
            Decimal smallestCibilScore  = 9999;
            try{
                List<genesis__Application_Parties__c> listOfParties  =  [select id,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CIBIL_Score__c from genesis__Application_Parties__c where genesis__Application__c =: appId];
                if(listOfParties !=null && !listOfParties.isEmpty()){
                    for(genesis__Application_Parties__c appPartiesObj  :   listOfParties){
                        if(appPartiesObj.genesis__Party_Account_Name__r.CIBIL_Score__c !=null){
                            if(appPartiesObj.genesis__Party_Account_Name__r.CIBIL_Score__c < smallestCibilScore) {
                              smallestCibilScore =  appPartiesObj.genesis__Party_Account_Name__r.CIBIL_Score__c;  
                            }   
                        }    
                    }
                    if(smallestCibilScore != 9999 && smallestCibilScore > 700){
                        return true;
                    }
                }
            }catch(Exception ex){
              HandleBusinessException.captureError('YearDataConstant', 'getMinCibilScore', ex);    
            }
        }
        return false;
    }

    //Newly Added
    webservice static List<M68_Balance_Sheet_Analysis__c> getCANameNumberMissingYearWise(String custId){
        try{
            List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();
            List<String> yearList = getAllMissingYear(custId,true);
            System.debug('yearList::: ' + yearList);
            if((custId != null || custId != '') && !yearList.isEmpty()){
                return m68DataList = [SELECT Account__c,CA_Name__c,CA_Number__c,Fiscal_Year__c,Financial_type__c FROM M68_Balance_Sheet_Analysis__c WHERE Account__c =: custId AND 
                                    Fiscal_Year__c IN : yearList AND Financial_type__c = 'Actual'];
            }
            else return null;
        }
        catch(Exception e){
            System.debug('Error Message::: ' + e.getMessage());
            return null;
        }
    }


    public static Boolean getManagement_Exp_Gr_than_3(genesis__Applications__c appObj){
        List<String> listOfString  = new List<String>{'Having experience of 1 or more years but less than 3 years.','New to Business Line (less than 1 year in the line of business).'};
        if(appObj !=null && appObj.Management_experience__c != null && !listOfString.contains(appObj.Management_experience__c)){
          return true;    
        }
        return false;
    }
    public static Boolean getCheque_Return_Gr_than_2(genesis__Applications__c appObj){
        /*if(appObj !=null && appObj.Inward_cheque_return__c !=null && appObj.Inward_cheque_return__c > 2){
           return true;
        }
        return false;*/
        if(appObj !=null && appObj.Inward_cheque_return__c !=null && appObj.Inward_cheque_return__c > 2){
            return false;
        }
        return true;
    }
    //check all task complete or not for BRE RUN.
    public static Boolean checkAllTaskDoneForBRERun(String appId,List<String> listOfTaskType){
        boolean isQualitative_Task_Complete = false;
        boolean isNewLoanFormalities_Task_Complete =   false;
        boolean isMarketIntelligece_Task_Complete  =   false;
        boolean isApplicationANDTUExposure_Task_Complete = false;
        boolean isCLPCHead_Task_Complete = false;
        Integer countLength = 0;
        Integer countCompletedTask  = 0;
        Map<String,Boolean> mapOfTaskType    =  new Map<String,Boolean>();
        Map<String,Integer> mapOfTaskforCheck  =  new Map<String,Integer>();
        try{
            if(appId !=null && appId !='' && listOfTaskType !=null && !listOfTaskType.isEmpty()){
                List<Task> listOfTask  = [select id,Type,Status,WhatId from Task where WhatId =:appId];
                 if(listOfTask !=null && !listOfTask.isEmpty()){
                    for(Task taskObj   :   listOfTask){
                        if(taskObj.Type !=null && taskObj.Type !=''){
                            if(mapOfTaskforCheck.containsKey(taskObj.Type)){
                              mapOfTaskforCheck.put(taskObj.Type,mapOfTaskforCheck.get(taskObj.Type)+1);    
                            }else{
                                mapOfTaskforCheck.put(taskObj.Type,1);
                            }
                        }        
                    }
                }
                for(String strObj   :  listOfTaskType){
                    
                    if(strObj == 'Qualitative Input Needed'){
                        mapOfTaskType.put(strObj, isQualitative_Task_Complete);
                    }else if(strObj == 'Takeover Intelligence'){
                        mapOfTaskType.put(strObj, isNewLoanFormalities_Task_Complete); 
                    }else if(strObj == 'Market Intelligence'){
                        mapOfTaskType.put(strObj, isMarketIntelligece_Task_Complete); 
                    }else if(strObj == 'Verified diff b/w App Exposure and TU Exposure as per Application' && mapOfTaskforCheck.containsKey(strObj)){
                        mapOfTaskType.put(strObj, isApplicationANDTUExposure_Task_Complete); 
                    }else if(strObj == 'Financial Upload' && mapOfTaskforCheck.containsKey(strObj)){
                        mapOfTaskType.put(strObj, isCLPCHead_Task_Complete);      
                    } 
                }
                if(listOfTask !=null && !listOfTask.isEmpty()){
                    for(Task taskObj   :   listOfTask){
                        if(taskObj.Type !=null && taskObj.Type !='' && mapOfTaskType.containsKey(taskObj.Type) && taskObj.Status =='Completed'){
                            countLength++;  
                        }
                    }
                    for(String taskType  :  mapOfTaskType.keySet()){
                        if(mapOfTaskforCheck.containsKey(taskType)){
                          countCompletedTask +=  mapOfTaskforCheck.get(taskType);    
                        }      
                    }
                }
                //System.debug('countCompletedTask'+ countCompletedTask +'countLength'+countLength);
                
                if(countLength > 0 && countCompletedTask > 0 && countCompletedTask == countLength){
                    return true;
                }
            }
        }catch(Exception ex){
            HandleBusinessException.captureError('YearDataConstant', 'checkAllTaskDoneForBRERun', ex);
        }
        return false;
    }
    public static Boolean checkAppConditionForBRERun(String appId){
        Integer  countLength    =   0;
        Integer  countPerfioslength = 0;
        Boolean  isPartyCibilCompleted = false;
        Boolean  isCommercialCompleted  = false;
        Boolean  isListMatchingCompleted    =   false;
        try{
            if(appId !=null && appId !=''){
                List<genesis__Application_Parties__c>   listOfAppParty = [select id,genesis__Application__r.BRE_Done__c,genesis__Application__c,genesis__Application__r.RecordType_Developer_Name__c,genesis__Application__r.CommercialPR_Stage__c,genesis__Application__r.List_Matching_Stage__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CIBIL_Status__pc from genesis__Application_Parties__c where genesis__Application__c =:appId AND Active__c = true];
                if(listOfAppParty !=null && !listOfAppParty.isEmpty()  ){
                    for(genesis__Application_Parties__c appPartiesObj   :   listOfAppParty){
                        if(!appPartiesObj.genesis__Application__r.BRE_Done__c && appPartiesObj.genesis__Party_Account_Name__r.CIBIL_Status__pc !=null && appPartiesObj.genesis__Party_Account_Name__r.CIBIL_Status__pc !='' && appPartiesObj.genesis__Party_Account_Name__r.CIBIL_Status__pc =='Complete'){
                            //system.debug('appPartiesObj.genesis__Party_Account_Name__r.CIBIL_Status__pc');
                            countLength++;
                        }
                    }
                    if(countLength > 0 && listOfAppParty.size() == countLength){
                        isPartyCibilCompleted = true;
                    }
                    if(!listOfAppParty[0].genesis__Application__r.BRE_Done__c && listOfAppParty[0].genesis__Application__r.CommercialPR_Stage__c !=null && listOfAppParty[0].genesis__Application__r.CommercialPR_Stage__c =='Completed'){
                        isCommercialCompleted   = true;
                    }
                    if(!listOfAppParty[0].genesis__Application__r.BRE_Done__c && listOfAppParty[0].genesis__Application__r.List_Matching_Stage__c !=null && listOfAppParty[0].genesis__Application__r.List_Matching_Stage__c =='Completed'){
                        isListMatchingCompleted   = true;
                    }
                    if(!listOfAppParty[0].genesis__Application__r.BRE_Done__c && listOfAppParty[0].genesis__Application__r.RecordType_Developer_Name__c =='SME_NEW_Loan'){
                        List<Perfios__c> listOfPerfios  =   [select id,Perfios_Status__c,Application__c,RecordType.DeveloperName from Perfios__c where Application__c =:appId AND RecordType.DeveloperName ='SME_New_Loan_Perfios'];
                        if(listOfPerfios !=null && !listOfPerfios.isEmpty()){
                            for(Perfios__c  perfiosObj  :  listOfPerfios){
                                if(perfiosObj !=null && perfiosObj.Perfios_Status__c !=null && perfiosObj.Perfios_Status__c =='Completed'){
                                    countPerfioslength++;
                                }
                            }
                            if(isPartyCibilCompleted && isCommercialCompleted && isListMatchingCompleted && countPerfioslength > 0 && listOfPerfios.size() == countPerfioslength){
                                return true;
                            }
                        }else{
                            if(isPartyCibilCompleted && isCommercialCompleted && isListMatchingCompleted){
                                return true;
                            }
                        }
                    }else if(!listOfAppParty[0].genesis__Application__r.BRE_Done__c){
                        if(isPartyCibilCompleted && isCommercialCompleted && isListMatchingCompleted){
                            return true;
                        }
                    }
                }
            }
            System.debug('isPartyCibilCompleted'+isPartyCibilCompleted);
            System.debug('isCommercialCompleted'+isCommercialCompleted);
            System.debug('isListMatchingCompleted'+isListMatchingCompleted);
        }catch(Exception ex){
            HandleBusinessException.captureError('YearDataConstant', 'checkAppConditionForBRERun', ex);
        }
        return false;
    }
    // On the basis of Person cibil OR CMR-Rank Application Reject or Deviation. 
    public static Map<String,Boolean> getCibilScore_Reject(String appId){
        //System.debug('Inside getCibilScore_Reject appId@@@@@'+appId);
        Integer countCibilCompleted =   0;
        Decimal smallestCibilScore  =   99999;
        List<Decimal> listOfNOHitScore  =   new List<Decimal>();
        Map<Id,genesis__Application_Parties__c> mapOfAppParties =   new Map<Id,genesis__Application_Parties__c>();
        Map<String,Boolean> mapOfReturnValue    =   new Map<String,Boolean>();
        List<Task> taskCompleteList     =   new List<Task>();
        if(appId !=null && appId !=''){
            try{
                Boolean is_NewToBusiness = false;
                List<genesis__Application_Parties__c>   listOfAppParty = [select id,CIBIL_Scores__c,genesis__Application__c,genesis__Application__r.CustomerID__c,genesis__Application__r.RecordType_Developer_Name__c,genesis__Application__r.New_to_Business__c,genesis__Application__r.Type__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CIBIL_Status__pc,genesis__Party_Account_Name__r.CIBIL_Score__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c from genesis__Application_Parties__c where genesis__Application__c =:appId AND Active__c = true];
                //System.debug('listOfAppParty@@@@@'+listOfAppParty);
                if(listOfAppParty !=null && listOfAppParty.size() > 0){
                     if((listOfAppParty[0].genesis__Application__r.New_to_Business__c || (listOfAppParty[0].genesis__Application__r.Type__c !=null && listOfAppParty[0].genesis__Application__r.Type__c.contains('New to credit')))){
                         Boolean isExistingKeyPerson = false;
                         if(listOfAppParty[0].genesis__Application__r.New_to_Business__c){
                             for(genesis__Application_Parties__c appPartyObj    :   listOfAppParty){
                                 if(appPartyObj !=null && appPartyObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c !=null){
                                     if(appPartyObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c.length() < 10){
                                        isExistingKeyPerson = true;
                                        break; 
                                     }    
                                 }
                             }    
                         }
                        for(genesis__Application_Parties__c appPartyObj :   listOfAppParty){
                            if(appPartyObj !=null && appPartyObj.genesis__Party_Account_Name__r.CIBIL_Status__pc !=null && appPartyObj.genesis__Party_Account_Name__r.CIBIL_Status__pc !='' && appPartyObj.genesis__Party_Account_Name__r.CIBIL_Status__pc =='Complete' && appPartyObj.CIBIL_Scores__c !=null){
                                if(appPartyObj.CIBIL_Scores__c!= -1 && appPartyObj.CIBIL_Scores__c != 5){
                                    if(appPartyObj.genesis__Party_Account_Name__r.CIBIL_Score__c < smallestCibilScore){
                                        smallestCibilScore =   appPartyObj.genesis__Party_Account_Name__r.CIBIL_Score__c;    
                                    }     
                                }else if(appPartyObj.CIBIL_Scores__c == -1 || appPartyObj.CIBIL_Scores__c == 5){
                                    listOfNOHitScore.add(appPartyObj.CIBIL_Scores__c);    
                                }
                            }
                        }
                        //System.debug('smallestCibilScore @@@@'+ smallestCibilScore);
                        //System.debug('isExistingKeyPerson @@@@'+ isExistingKeyPerson);
                        If((listOfAppParty[0].genesis__Application__r.New_to_Business__c && isExistingKeyPerson && smallestCibilScore < 700)  || (listOfAppParty[0].genesis__Application__r.New_to_Business__c && !isExistingKeyPerson && smallestCibilScore < 750)|| (listOfAppParty[0].genesis__Application__r.Type__c !=null && listOfAppParty[0].genesis__Application__r.Type__c.contains('New to credit') && smallestCibilScore < 650)){
                            genesis__Applications__c    app = new genesis__Applications__c();
                            app.id  =   (id)appId;
                            app.Application_Stage__c = 'Application Rejected';
                            app.Sub_Stage__c         = 'Low Cibil Score';
                            //taskCompleteList = SOQL_Util.completeTask(app.Id);
                            taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
                            
                            ApplicationTriggerHandler.IsFirstRun = false;
                            update app;
                            if(taskCompleteList.size() > 0){
                                TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
                                update taskCompleteList;
                            }
                        }else if(listOfNOHitScore.size() > 0 && listOfNOHitScore.size() == listOfAppParty.size()){
                            mapOfReturnValue.put('IS_DEVIATED_CIBIL',true);
                            //System.debug('IS_DEVIATED_CIBIL@@@@@'+ true);
                        }else{
                            //PostDisbursementCheck.UpdateCibil(appId);
                            mapOfReturnValue.put('NO_ACTION',true);
                        }
                        
                    }else if(listOfAppParty[0].genesis__Application__r.Type__c !=null && listOfAppParty[0].genesis__Application__r.Type__c.contains('Takeover')){
                        List<String> listOfCMR_Rank = new List<String>{'CMR-7','CMR-8','CMR-9','CMR-10'};
                        List<RankVec__c> listOfRankVec  =   [select id,Rank_Value__c,Tu_Credit_Report__c,Tu_Credit_Report__r.Account__c from RankVec__c where Tu_Credit_Report__r.Account__c =:listOfAppParty[0].genesis__Application__r.CustomerID__c Order By CreatedDate DESC limit 1];
                        //system.debug('listOfRankVec==++'+listOfRankVec);
                        //system.debug('=====++++'+listOfAppParty[0].genesis__Application__r.CustomerID__c);
                        //system.debug('=====++++'+listOfRankVec[0].Tu_Credit_Report__r.Account__c);
                        if(listOfRankVec !=null && listOfRankVec.size() > 0){
                            if(listOfRankVec[0].Rank_Value__c !=null && listOfCMR_Rank.contains(listOfRankVec[0].Rank_Value__c)){
                                genesis__Applications__c    app = new genesis__Applications__c();
                                app.id  =   (id)appId;
                                app.Application_Stage__c = 'Application Rejected';
                                app.Sub_Stage__c         = 'High CMR Rank';
                                //taskCompleteList = SOQL_Util.completeTask(app.Id);
                                taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
                                
                                ApplicationTriggerHandler.IsFirstRun = false;
                                update app;
                                if(taskCompleteList.size() > 0){
                                    TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
                                    update taskCompleteList;
                                }
                            }else if(listOfRankVec[0].Rank_Value__c !=null && listOfRankVec[0].Rank_Value__c =='CMR-6'){
                                mapOfReturnValue.put('IS_DEVIATED_CMR',true);    
                            }else{
                                PostDisbursementCheck.UpdateCibil(appId);
                                mapOfReturnValue.put('NO_ACTION',true);    
                            }
                        }
                    }
                }
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() +'Line Number ::'+ex.getLineNumber());
                HandleBusinessException.captureError('YearDataConstant', 'getCibilScore_Reject_OR_Deviation', ex);    
            }
        }
        return  mapOfReturnValue;
    }

    public static Decimal getFinalAuthRecomForLessThan_50L(genesis__Applications__c appObj){
        Decimal calculatedLimit;
        if(appObj !=null){
            calculatedLimit = 0;
            try{
                List<GSTN_Info__c> listofGstn            =   SOQL_Util.getGSTN_InfoByAccId(appObj.Id);
                If(listofGstn !=null && listofGstn.size() > 0){
                    for(GSTN_Info__c  gstnObj   : listofGstn){
                        if(gstnObj.Year__c !=null && gstnObj.Months__c !=null && gstnObj.Total_Sales__c !=null && gstnObj.Total_Sales__c > 0){
                            if(gstnObj.Year__c == nextEstFYFullYear && Integer.valueOf(gstnObj.Months__c) >= 6){
                                calculatedLimit = ((gstnObj.Total_Sales__c *(12/Integer.valueOf(gstnObj.Months__c)))*0.25);
                                break;
                            }else if(gstnObj.Year__c == currFYFullYear && gstnObj.Months__c == '12'){
                                calculatedLimit = gstnObj.Total_Sales__c * 0.25 ;
                            }
                        }
                    }
                }
                If(calculatedLimit == 0){
                    Operations_Detail__c    operationObj    =   [Select id,Fiscal_Type__c,Fiscal_Year__c,FIN_CR_AMT__c,Account__c from Operations_Detail__c where Account__c =:appObj.genesis__Account__c AND Fiscal_Year__c =: nextEstFiscalYear AND Fiscal_Type__c ='YTD' limit 1];
                    if(operationObj !=null && operationObj.FIN_CR_AMT__c !=null){
                        calculatedLimit = operationObj.FIN_CR_AMT__c * 0.25;    
                    }
                }
            }catch(Exception ex){
               System.debug('Exception '+ex.getMessage() +'Line No.'+ ex.getLineNumber());    
            }
        }
        //System.debug('calculatedLimit@@@@@@'+calculatedLimit);
        return calculatedLimit;
    }
    //getting missing financial Year.
   webservice static List<String> getAllMissingYear(String custId,Boolean checkTwoYearFlag){
       List<Account> accList = new List<Account>();
       accList = [SELECT Id,Date_of_Incorporation__c FROM Account WHERE Id =: custId];
       //system.debug('accList==++'+accList);
       List<String> fisicalYearList = new List<String>();
       Date incorporateDate = accList[0].Date_of_Incorporation__c;
       string incorporateDatestr;
       if(incorporateDate!=null)
       incorporateDatestr = DateTime.newInstance(incorporateDate.year(),incorporateDate.month(),incorporateDate.day()).format('yyyy-MM-dd');
       /*System.debug(incorporateDate);
       System.debug(incorporateDatestr+':::'+n_1_FiscalYear);
       System.debug('n_1_FiscalYear***'+n_1_FiscalYear);
       System.debug('nthFiscalYear***'+nthFiscalYear);
       System.debug('currFiscalYear***'+currFiscalYear);*/
       if(incorporateDatestr!= null && (incorporateDatestr < n_1_FiscalYear)){
           if(!checkTwoYearFlag)
           fisicalYearList.add(n_1_FiscalYear);
           //System.debug('fisicalYearList***'+fisicalYearList);
       } 
       if(incorporateDatestr!= null && (incorporateDatestr < nthFiscalYear)){
           fisicalYearList.add(nthFiscalYear);
           //System.debug('fisicalYearList***'+fisicalYearList);
       }
       if(incorporateDatestr!= null && (incorporateDatestr < currFiscalYear)){
           fisicalYearList.add(currFiscalYear);
           //System.debug('fisicalYearList***'+fisicalYearList);
       }
       List<String> allMissingYear = new List<String>();
       Map<String, Integer> m28CountForlastThreeYear = new Map<String, Integer>();
       List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();
       if(custId !=null && custId !=''){
           try{
               
               List<String> fyList = new List<String>();
               if(!fisicalYearList.isEmpty())
               fyList.addAll(fisicalYearList);
               //fyList.add(currFiscalYear);
               //fyList.add(nthFiscalYear);
               //system.debug('fyList>>**'+fyList);
               /*if(!checkTwoYearFlag){
                   system.debug('fyList**'+fyList);
                   fyList.add(n_1_FiscalYear);
               }*/
               //system.debug('m68DataList**'+m68DataList);
               m68DataList = SOQL_Util.getM68Data(custId, fyList);
               for(String year:fyList){
                   m28CountForlastThreeYear.put(year,0);
               }
               /*m28CountForlastThreeYear.put(nthFiscalYear,0);
               m28CountForlastThreeYear.put(n_1_FiscalYear,0);
               //system.debug('m28CountForlastThreeYear>>**'+m28CountForlastThreeYear);
               if(!checkTwoYearFlag){
                   //system.debug('m28CountForlastThreeYear**'+m28CountForlastThreeYear);
                   m28CountForlastThreeYear.put(currFiscalYear,0);
               }*/
               
               if(m68DataList != null && !m68DataList.isEmpty()){
                   for(M68_Balance_Sheet_Analysis__c m68Data : m68DataList){
                       if(m68Data.Financial_type__c == 'Actual' && m68Data.Fiscal_Year__c == currFiscalYear && m68Data.Data_Source__c != null){
                           m28CountForlastThreeYear.put(currFiscalYear,1);
                       }else if(m68Data.Financial_type__c == 'Actual' && m68Data.Fiscal_Year__c == nthFiscalYear && m68Data.Data_Source__c != null){
                           m28CountForlastThreeYear.put(nthFiscalYear,1);
                       }else if(m68Data.Financial_type__c == 'Actual' && m68Data.Fiscal_Year__c == n_1_FiscalYear && m68Data.Data_Source__c != null){
                           m28CountForlastThreeYear.put(n_1_FiscalYear,1);
                       }
                   }

               }
               if(m28CountForlastThreeYear.get(currFiscalYear) == 0){
                   allMissingYear.add(currFiscalYear);
               }
               if(m28CountForlastThreeYear.get(nthFiscalYear) == 0){
                   allMissingYear.add(nthFiscalYear);
               }
               if(m28CountForlastThreeYear.get(n_1_FiscalYear) == 0){
                   allMissingYear.add(n_1_FiscalYear);
               }
               // system.debug('allMissingYear:-'+allMissingYear+'  allMissingYear.isEmpty():-'+allMissingYear.isEmpty());
               if(allMissingYear !=null && !allMissingYear.isEmpty()){
                   //System.debug('allMissingYear@@@@@@'+allMissingYear);
                   return allMissingYear;
               }
           }catch(Exception ex){
               HandleBusinessException.captureError('YearDataConstant', 'getAllMissingYear', ex);
               return null;
           }
       }
       return allMissingYear;
   }
    public static Boolean checkNewToBusinessRMD_Deviation(String appId){
        if(appId !=null && appId !=''){
            try{
                Boolean isFinancialYear = true;
                List<genesis__Applications__c> listOfApp = [Select id,New_to_Business__c,RecordType.DeveloperName,genesis__Account__r.Date_of_Incorporation__c from genesis__Applications__c where Id =:appId];
                if(listOfApp !=null && listOfApp.size() >0){
                    isFinancialYear =  Application_AssessmentCtrl.calculateFinancialOneYear(listOfApp[0].genesis__Account__r.Date_of_Incorporation__c);
                    //System.debug('isFinancialYear@@@'+isFinancialYear);
                    if(!isFinancialYear){
                        return true;
                    }
                }
            }catch(Exception ex){
                HandleBusinessException.captureError('YearDataConstant', 'checkNewToBusinessRMD_Deviation', ex);    
            }
        }
        return false;
    }

    public static Map<String,Boolean> getCibilScore_Reject_New(String appId){
        Integer countCibilCompleted =   0;
        Boolean cibilFromProduct=false;
        Decimal smallestCibilScore  =   99999;
        List<Decimal> listOfNOHitScore  =   new List<Decimal>();
        Map<Id,genesis__Application_Parties__c> mapOfAppParties =   new Map<Id,genesis__Application_Parties__c>();
        Map<String,Boolean> mapOfReturnValue    =   new Map<String,Boolean>();
        List<Task> taskCompleteList     =   new List<Task>();
        if(appId !=null && appId !=''){
            try{
                Boolean productCibilCheck=false;
                Boolean is_NewToBusiness = false;
                List<genesis__Application_Parties__c>   listOfAppParty = [select id,CIBIL_Scores__c,genesis__Application__c,genesis__Application__r.genesis__Account__c,genesis__Application__r.CustomerID__c,genesis__Application__r.RecordType_Developer_Name__c,genesis__Application__r.New_to_Business__c,genesis__Application__r.Type__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CIBIL_Status__pc,genesis__Party_Account_Name__r.CIBIL_Score__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c from genesis__Application_Parties__c where genesis__Application__c =:appId AND Active__c = true];
                System.debug('listOfAppParty=='+listOfAppParty);
                if(listOfAppParty !=null && listOfAppParty.size() > 0 && listOfAppParty[0].genesis__Application__r.Type__c !=null){
                    List<String> listOfCMR_Rank = new List<String>{'CMR-7','CMR-8','CMR-9','CMR-10'};
                    List<RankVec__c> listOfRankVec  =   [select id,Rank_Value__c,Tu_Credit_Report__c,Tu_Credit_Report__r.Account__c from RankVec__c where Tu_Credit_Report__r.Account__c =:listOfAppParty[0].genesis__Application__r.genesis__Account__c Order By CreatedDate DESC limit 1];
                    System.debug('listOfRankVec===='+listOfRankVec);
                    if(listOfRankVec !=null && listOfRankVec.size() > 0){
                            if(listOfRankVec[0].Rank_Value__c !=null && listOfCMR_Rank.contains(listOfRankVec[0].Rank_Value__c)){
                                genesis__Applications__c    app = new genesis__Applications__c();
                                app.id  =   (id)appId;
                                app.Application_Stage__c = 'Application Rejected';
                                app.Sub_Stage__c         = 'High CMR Rank';
                                //taskCompleteList = SOQL_Util.completeTask(app.Id);
                                taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
                                
                                ApplicationTriggerHandler.IsFirstRun = false;
                                update app;
                                if(taskCompleteList.size() > 0){
                                    TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
                                    update taskCompleteList;
                                }
                            }else if(listOfRankVec[0].Rank_Value__c !=null && listOfRankVec[0].Rank_Value__c =='CMR-6'){
                                mapOfReturnValue.put('IS_DEVIATED_CMR',true);    
                            }
                            else{
                                //PostDisbursementCheck.UpdateCibil(appId);
                                if(listOfAppParty[0].genesis__Application__r.Type__c.contains('New to credit') || listOfAppParty[0].genesis__Application__r.Type__c.contains('New to Bank') || listOfAppParty[0].genesis__Application__r.Type__c.contains('Takeover')){
                                    if(!ForntbNtcTakeover(listOfAppParty).isEmpty()){
                                        mapOfReturnValue.putall(ForntbNtcTakeover(listOfAppParty));
                                    }
                                }  
                            }
                        }
                        else{
                            System.debug('No Rank Records');
                            productCibilCheck=PostDisbursementCheck.UpdateCibil(appId);
                            System.debug('productCibilCheck=='+productCibilCheck);
                            if(productCibilCheck==false){
                            // Steps to do, Alreay updating Application
                            }
                            else{
                                if(listOfAppParty[0].genesis__Application__r.Type__c.contains('New to credit') || listOfAppParty[0].genesis__Application__r.Type__c.contains('New to Bank') || listOfAppParty[0].genesis__Application__r.Type__c.contains('Takeover')){}
                                if(!ForntbNtcTakeover(listOfAppParty).isEmpty()){
                                        mapOfReturnValue.putall(ForntbNtcTakeover(listOfAppParty));
                                    }
                                }
                            }
                        }
                }
            
            catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() +'Line Number ::'+ex.getLineNumber());
                HandleBusinessException.captureError('YearDataConstant', 'getCibilScore_Reject_New', ex);  
            }
        }
            return mapOfReturnValue;
}


   public static Map<String,Boolean> ForntbNtcTakeover(List<genesis__Application_Parties__c> listOfAppParty){
        Decimal smallestCibilScore  =   99999;
        List<Decimal> listOfNOHitScore  =   new List<Decimal>();
        Map<String,Boolean> mapOfReturnValue    =   new Map<String,Boolean>();
        List<Task> taskCompleteList     =   new List<Task>();

        if((listOfAppParty[0].genesis__Application__r.New_to_Business__c || (listOfAppParty[0].genesis__Application__r.Type__c !=null && listOfAppParty[0].genesis__Application__r.Type__c.contains('New to credit')))){
                        Boolean isExistingKeyPerson = false;
                        //System.debug('listOfAppParty[0].genesis__Application__r.New_to_Business__c==='+listOfAppParty[0].genesis__Application__r.New_to_Business__c);
                        //System.debug('listOfAppParty[0].genesis__Party_Account_Name__c'+listOfAppParty[0].genesis__Party_Account_Name__c);
                        //System.debug('appPartyObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c.length() ===='+listOfAppParty[0].genesis__Party_Account_Name__r.CBS_Customer_ID__c.length());
                        //System.debug(''+);
                        if(listOfAppParty[0].genesis__Application__r.New_to_Business__c){
                            for(genesis__Application_Parties__c appPartyObj :   listOfAppParty){
                                if(appPartyObj !=null && appPartyObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c !=null){
                                    if(appPartyObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c.length() < 10){
                                        isExistingKeyPerson = true;
                                        break; 
                                     }    
                                 }
                            }    
                        }
                        System.debug('isExistingKeyPerson=='+isExistingKeyPerson);
                        for(genesis__Application_Parties__c appPartyObj :   listOfAppParty){
                            if(appPartyObj !=null && appPartyObj.genesis__Party_Account_Name__r.CIBIL_Status__pc !=null && appPartyObj.genesis__Party_Account_Name__r.CIBIL_Status__pc !='' && appPartyObj.genesis__Party_Account_Name__r.CIBIL_Status__pc =='Complete' && appPartyObj.CIBIL_Scores__c !=null){
                                if(appPartyObj.CIBIL_Scores__c!= -1 && appPartyObj.CIBIL_Scores__c != 5){
                                    if(appPartyObj.genesis__Party_Account_Name__r.CIBIL_Score__c < smallestCibilScore){
                                        smallestCibilScore =   appPartyObj.genesis__Party_Account_Name__r.CIBIL_Score__c;    
                                    }     
                                }else if(appPartyObj.CIBIL_Scores__c == -1 || appPartyObj.CIBIL_Scores__c == 5){
                                    listOfNOHitScore.add(appPartyObj.CIBIL_Scores__c);    
                                }
                            }
                        }
                        System.debug('smallestCibilScore=='+smallestCibilScore);
                        System.debug('listOfNOHitScore=='+listOfNOHitScore);
                        If((listOfAppParty[0].genesis__Application__r.New_to_Business__c && isExistingKeyPerson && smallestCibilScore < 700)  || (listOfAppParty[0].genesis__Application__r.New_to_Business__c && !isExistingKeyPerson && smallestCibilScore < 750)|| (listOfAppParty[0].genesis__Application__r.Type__c !=null && listOfAppParty[0].genesis__Application__r.Type__c.contains('New to credit') && smallestCibilScore < 650)){
                            genesis__Applications__c    app = new genesis__Applications__c();
                            app.id  =   (id)listOfAppParty[0].genesis__Application__c;
                            app.Application_Stage__c = 'Application Rejected';
                            app.Sub_Stage__c         = 'Low Cibil Score';
                            //taskCompleteList         = SOQL_Util.completeTask(app.Id);
                            taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
                            
                            ApplicationTriggerHandler.IsFirstRun = false;
                            update app;
                            if(taskCompleteList.size() > 0){
                                TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
                                update taskCompleteList;
                            }
                        }else if(listOfNOHitScore.size() > 0 && listOfNOHitScore.size() == listOfAppParty.size()){
                            mapOfReturnValue.put('IS_DEVIATED_CIBIL',true);
                            //System.debug('IS_DEVIATED_CIBIL@@@@@'+ true);
                        }else{
                            //PostDisbursementCheck.UpdateCibil(appId);
                            mapOfReturnValue.put('NO_ACTION',true);
                        }
       
    }
    return mapOfReturnValue;
    
}
}