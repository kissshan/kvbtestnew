/*
* Name      : RejectionScenarioHandeller
* Compnay   : ET Marlabs
* Purpose   : For LAP Rejection Scenario basesd on Collateral 
* Author    : Niladri
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
v1.1    12-Sep-2018    Braj         #VL741:Addition of min EMI and min tenure rejection scenario
v1.2    09-Oct-2018    Braj         #VL741:Added rejection scenario for vehicle price variance
v1.3    08-Jan-2019    Braj         Closure of all open tasks if application is rejected or deactivated
*******************************************************************************************/
public class RejectionScenarioHandeller {
    
    private static RejectionScenarioHandeller instance;
    public static Boolean IsFirstRun = true;
    //Singleton class Method.
    public static RejectionScenarioHandeller getInstance(){
        if(instance==null){
            instance=new RejectionScenarioHandeller();
        }
        return instance;
    }
    
    //Rejection scenario for LAP
    public static void RejectioMethod(Map<id,genesis__Applications__c> newMapApp,Map<id,genesis__Applications__c> oldMapApp){
        try{
            List<genesis__Applications__c> applist=new List<genesis__Applications__c>();
            Decimal totalIncome;
            for(genesis__Applications__c app :newMapApp.values()){
                System.debug('@aj app:::'+app);
                if((oldMapApp.get(app.id).Sub_Stage__c == 'Property information captured' || app.Sub_Stage__c=='Property information captured') && app.Record_Type_Name__c =='LAP' ){
                    
                    List<clcommon__Collateral__c> collataralList=[select EM_Charge_Types__c,No_of_tenants__c,Vacant_Land_area__c,clcommon__City__c from  clcommon__Collateral__c where genesis__Application__c =:app.Id];
                    
                    System.debug('#### '+collataralList);
                    for(clcommon__Collateral__c colvalue : collataralList){
                        if(colvalue.EM_Charge_Types__c !='Fresh') {
                            
                            app.Reject_Scenario__c = 'Charge can only be Fresh EM for digital applications';
                            app.Sub_Stage__c       = Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
                            //   applist.add(app);
                            break;
                        }
                        
                        else if((colvalue.No_of_tenants__c != null ? Integer.valueOf(colvalue.No_of_tenants__c) : 0) >10){
                            System.debug('inside if for no of tenants');
                            app.Reject_Scenario__c = 'No. of tenants cannot be >10 for digital applications';
                            app.Sub_Stage__c       = Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
                            //   applist.add(app);
                            break;
                        }
                        else if(colvalue.Vacant_Land_area__c > 10000){
                            app.Reject_Scenario__c  = 'Vacant land cannot be >10000 sq ft for digital applications';
                            app.Sub_Stage__c        = Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
                            //    applist.add(app);
                            break;
                        }  
                        /*
else if(colvalue.clcommon__City__c != getBranchCity(app.Branch_Code__c,false)){
app.Reject_Scenario__c  = 'Property and KVB branch need to be in the same city for digital LAP';
app.Sub_Stage__c        = Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
//    applist.add(app);
break;
} */
                        
                        else if(colvalue.EM_Charge_Types__c =='Fresh' && (colvalue.No_of_tenants__c != null ? Integer.valueOf(colvalue.No_of_tenants__c) : 0) <10 && colvalue.Vacant_Land_area__c < 10000 && (colvalue.clcommon__City__c == getBranchCity(app.Branch_Code__c,false))){
                            if(!String.isBlank(app.Reject_Scenario__c)){
                                app.Reject_Scenario__c = '';
                            }                            
                        }                        
                    }
                }
                
                 if(oldMapApp.get(app.id).Sub_Stage__c !='Loan Requirement Captured' && app.Sub_Stage__c=='Loan Requirement Captured' && app.Record_Type_Name__c =='LAP' ){                
                    List<genesis__Application_Parties__c> PTList = new List<genesis__Application_Parties__c>();
                    PTList = [Select Id From genesis__Application_Parties__c Where genesis__Application__c =: app.Id AND Active__c = true AND Company__c = false];
                    if(PTList.size() == 1 && (app.GMRA_Amount__c==null || app.GMRA_Amount__c==0)){
                        app.Reject_Scenario__c  = 'GMRA needs to be selected for single applicants';
                        app.Sub_Stage__c        = 'Property Information Captured';   
                    }else{
                        app.Reject_Scenario__c  = '';                       
                    }
                }
                
                if(oldMapApp.get(app.id).Sub_Stage__c != Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE && app.Sub_Stage__c==Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE && app.Record_Type_Name__c =='LAP' ){                
                    List<genesis__Application_Parties__c> PTList = new List<genesis__Application_Parties__c>();
                    PTList = [Select Id From genesis__Application_Parties__c Where genesis__Application__c =: app.Id AND Active__c = true AND Company__c = false];
                    if(PTList.size() == 1){
                      //  app.Reject_Scenario__c  = 'Application should have at least one Co-applicant or Guarantor';
                      //  app.Sub_Stage__c        = 'Application Created';   
                    }else{
                        app.Reject_Scenario__c  = '';                       
                    }
                }
                
            }
            
        }
        catch(Exception e){
            System.debug('exception'+e);
            HandleBusinessException.captureError('RejectionScenarioHandeller', 'RejectioMethod', e);
        }
        
    }
    
    // Rejection clear Sceanrio for LAP by Venu
    public static void ClearRejectscenario(List<genesis__Applications__c> APlist,Map<Id,genesis__Applications__c> oldApp){
        
        for(genesis__Applications__c app : APlist){
            
            //if(oldPlan.Sub_Stage__c==Ap.Sub_Stage__c && (Ap.Sub_Stage__c==Constants.Sub_Stage_WorkInfoCaptured  || Ap.Sub_Stage__c==Constants.AppCreateStage || Ap.Sub_Stage__c==Constants.Sub_Stage_PropInfoCaptured) && ap.Record_Type_Name__c ==Constants.LAPLOAN ){
            if(oldApp.get(app.id).Sub_Stage__c != app.Sub_Stage__c && app.Record_Type_Name__c == Constants.LAPLOAN){
                
                if(!Utility.ISStringBlankorNull(app.Reject_Scenario__c)){
                    app.Reject_Scenario__c='';
                }
            }
        }
    }
    
    //Rejection scenario for Personal Loan
    public static void RejectioMethodHomeLoan(Map<id,genesis__Applications__c> newMapApp,Map<id,genesis__Applications__c> oldMapApp){
        List<genesis__Applications__c> applist=new List<genesis__Applications__c>();  
        List<genesis__Applications__c> Newapplist = [ select id,NMI_Claimed_By_Customer__c, PMin__c,Sub_Stage__c,PMax__c,Record_Type_Name__c,Total_Cheque_Bounces__c,Nmax__c,Sanction_Message__c, genesis__account__r.Perfios_Captured__c, Additional_Income__c,genesis__account__r.Same_Present_Address_Permanent_Address__c,genesis__account__r.Current_Address_As_Permanent_Address__c, genesis__account__r.Are_you_An_Existing_Customer__c from genesis__applications__c where id IN : newMapApp.keySet()];
           for(genesis__Applications__c app :Newapplist){
               genesis__applications__c appListUp = new genesis__applications__c();
    			        if( (app.Sub_Stage__c=='Property Information Captured' && oldMapApp.get(app.id).Sub_Stage__c <> 'Property Information Captured') && app.Record_Type_Name__c == Constants.HOMELOAN){
                                if(app.PMax__c < app.PMin__c) {
                                    appListUp.Reject_Scenario__c='Eligibility below minimum threshold of INR '+app.PMin__c;
                                    appListUp.Id = app.id;
                                    applist.add(appListUp);
                                }
                        }
           }
           ApplicationTriggerHandler.IsFirstRun = False;
           update applist;  
    }
    public static void RejectioMethodPersonalLoan(Map<id,genesis__Applications__c> newMapApp,Map<id,genesis__Applications__c> oldMapApp){
        System.debug('Inside RejectioMethodPersonalLoan()***newMapApp***'+newMapApp);
        genesis__applications__c appListUp = new genesis__applications__c();
        
        Map<Id,Id> accIdbyAppId = new Map<Id,Id>();
        Map<Id,Account> accbyAppId = new Map<Id,Account>();
        Map<Id,List<genesis__Application_Parties__c>> partyMap=new Map<Id,List<genesis__Application_Parties__c>>();
        Map<Id,Decimal> appIdToAllPartyNMIMap=new Map<Id,Decimal>();//v1.1
        for(genesis__Applications__c appRec:newMapApp.values()){
            accIdbyAppId.put(appRec.genesis__Account__c,appRec.Id);
        }
        System.debug('accIdbyAppId>>>'+accIdbyAppId);
        for(genesis__Application_Parties__c accRec:[SELECT Id,Active__c,Company__c,Name,Employment_Types__c,Annual_Other_IncomeRecurring_CreditsITR__c,Age__c,Net_Monthly_Income__c,Employment_SubType__c,genesis__Party_Account_Name__c,genesis__Application__c,Additional_Income_Amount1__c,NMI_Claimed_By_Customer__c from genesis__Application_Parties__c where genesis__Application__c IN:newMapApp.keySet() AND Active__c =: true AND Company__c =: false AND Financial_Applicant__c = true]){//v1.1:added filter for financial application
            if (partyMap.containsKey(accRec.genesis__Application__c)) {
                partyMap.get(accRec.genesis__Application__c).add(accRec);
            } else {
                partyMap.put(accRec.genesis__Application__c,new List<genesis__Application_Parties__c>{accRec});
            }
            //v1.1-start // Commented due to individual party NMI check 2018-12-27 
            /*Decimal NMIClaimed = 0;
            if (appIdToAllPartyNMIMap.containsKey(accRec.genesis__Application__c)) {
                NMIClaimed = appIdToAllPartyNMIMap.get(accRec.genesis__Application__c)+accRec.NMI_Claimed_By_Customer__c;
                appIdToAllPartyNMIMap.put(accRec.genesis__Application__c,NMIClaimed);
            } else {
                appIdToAllPartyNMIMap.put(accRec.genesis__Application__c,accRec.NMI_Claimed_By_Customer__c);
            }*/
            //v1.1-end
        }
        System.debug('partyMap>>>'+partyMap);
        try{
            List<genesis__Applications__c> applist=new List<genesis__Applications__c>();
            List<genesis__Applications__c> Newapplist = [ select id,NMI_Claimed_By_Customer__c, PMin__c,Sub_Stage__c,PMax__c,Record_Type_Name__c,Total_Cheque_Bounces__c,Nmax__c,Sanction_Message__c, genesis__account__r.Perfios_Captured__c, Additional_Income__c,genesis__account__r.Same_Present_Address_Permanent_Address__c,genesis__account__r.Current_Address_As_Permanent_Address__c, genesis__account__r.Are_you_An_Existing_Customer__c,
                                        (select id,ExshowRoomPrice_Api__c,ExShow_Room_Price__c from genesis__Collaterals__r) from genesis__applications__c where id IN : newMapApp.keySet()];
            
            if(Newapplist.size() > 0 && RejectionScenarioHandeller.IsFirstRun){
                IsFirstRun = false;
                for(genesis__Applications__c app :Newapplist){
                    System.debug('each app >>>'+app);
                    if(partyMap.containskey(app.Id) ){
                        List<genesis__Application_Parties__c> parLst=partyMap.get(app.Id);
                        
                        for(genesis__Application_Parties__c par: parLst) {
                            System.debug('each party >>>'+par);
                            //capture income information related by Ashish (Start Here)
                            if((app.Sub_Stage__c==Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE && oldMapApp.get(app.id).Sub_Stage__c <> Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE ) && app.Record_Type_Name__c == Constants.PERSONALLOAN){
                                if(par.Employment_Types__c == Constants.EmpType_Salaried){
                                    if(par.Age__c < 23){
                                        appListUp.Application_Stage__c = Constants.APP_REJECTED_STAGE;
                                        appListUp.Sub_Stage__c = 'Age Ineligible';
                                        appListUp.error_message_pl__c = 'Applicant age is less than 23 years and is not eligible for a loan';
                                        appListUp.Reject_Scenario__c='Applicant age is less than 23 years and is not eligible for a loan';
                                        appListUp.Id = app.id;
                                        applist.add(appListUp);
                                        break;
                                    }
                                    Decimal REcurringIncome = 0;
                                    if(par.Annual_Other_IncomeRecurring_CreditsITR__c != null){
                                        REcurringIncome =  par.Annual_Other_IncomeRecurring_CreditsITR__c;
                                    }
                                    
                                    if((par.Net_Monthly_Income__c - REcurringIncome) < 25000){
                                        appListUp.Sub_Stage__c = 'Application Created';
                                        appListUp.error_message_pl__c = 'Minimum income criterion not met, loan cannot be processed';
                                        appListUp.Reject_Scenario__c= 'NMI does not meet minimum NMI criterion';
                                        appListUp.Id = app.id;
                                        applist.add(appListUp);
                                        break;
                                    }
                                    if((par.Net_Monthly_Income__c - REcurringIncome) > 25000) {
                                        appListUp.Reject_Scenario__c = '';
                                        appListUp.error_message_pl__c = '';
                                        appListUp.Id = app.id;
                                        applist.add(appListUp);
                                        break;
                                    }
                                }else
                                    if(par.Age__c < 25){
                                        appListUp.Application_Stage__c = Constants.APP_REJECTED_STAGE;
                                        appListUp.Sub_Stage__c = 'Age Ineligible';
                                        appListUp.error_message_pl__c = 'Applicant age is less than 25 years and is not eligible for a loan';
                                        appListUp.Reject_Scenario__c= 'Applicant age is less than 25 years and is not eligible for a loan';
                                        appListUp.Id = app.id;
                                        applist.add(appListUp);
                                        break;
                                    }
                            }
                            //capture income information related by Ashish (Ends Here)
                            
                            if( (app.Sub_Stage__c==Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE && oldMapApp.get(app.id).Sub_Stage__c <> Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE ) && app.Record_Type_Name__c == Constants.PERSONALLOAN ){
                                //Personal Loan 
                                if(app.PMax__c < app.PMin__c) {
                                    
                                    appListUp.Reject_Scenario__c='Eligibility below minimum threshold of INR 50,000';
                                    appListUp.Sub_Stage__c='Application Created';
                                    appListUp.Id = app.id;
                                    applist.add(appListUp);
                                    break;
                                }
                                if(app.Nmax__c < 12){
                                    
                                    appListUp.Reject_Scenario__c='Minimum Tenure ineligible';
                                    appListUp.Sub_Stage__c='Application Created';
                                    appListUp.error_message_pl__c ='Customer not eligible for loan based on age criterion';
                                    appListUp.Id = app.id;
                                    applist.add(appListUp);
                                    break; 
                                }
                                if(app.Total_Cheque_Bounces__c> 1){
                                    
                                    appListUp.Reject_Scenario__c='Cheque Returns';
                                    appListUp.Sub_Stage__c='Application Created';
                                    appListUp.Id = app.id;
                                    applist.add(appListUp);
                                    break; 
                                } 
                                if(app.PMax__c > app.PMin__c && app.Nmax__c >12 && app.Total_Cheque_Bounces__c < 1 ){
                                    appListUp.Reject_Scenario__c=''; 
                                    appListUp.Id = app.id;
                                    applist.add(appListUp);
                                    break; 
                                }
                            }
                            
                            // Vehicle Loan Rejection scenario -start
                            if( (app.Sub_Stage__c==Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE && oldMapApp.get(app.id).Sub_Stage__c <> Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE ) && (app.Record_Type_Name__c == Constants.VL2W || app.Record_Type_Name__c == Constants.VL4W) ){
                                system.debug('app.Record_Type_Name__c:::'+app.Record_Type_Name__c);
                                if(par.Age__c < 18){
                                    System.debug('par.Age__c:::'+par.Age__c);
                                    appListUp.Application_Stage__c = Constants.APP_REJECTED_STAGE;
                                    appListUp.Sub_Stage__c = 'Age Ineligible';
                                    appListUp.error_message_pl__c = 'Applicant age is less than 18 years and is not eligible for a loan';
                                    appListUp.Reject_Scenario__c='Applicant age is less than 18 years and is not eligible for a loan';
                                    appListUp.Id = app.id;
                                    applist.add(appListUp);
                                    break;
                                }
                                
                                if(app.PMax__c < app.PMin__c ) {
                                    System.debug('app.pmax:::'+app.PMax__c);
                                    appListUp.Reject_Scenario__c='Eligibility below minimum threshold';
                                    appListUp.error_message_pl__c='Eligibility below minimum threshold of INR'+String.valueof(app.PMin__c);
                                    appListUp.Sub_Stage__c=Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
                                    appListUp.Id = app.id;
                                    // newMapApp.get(app.id).put()
                                    system.debug('##### '+ appListUp);
                                    applist.add(appListUp);
                                    break;
                                }
                                
                                //v1.1-start
                                //System.debug(appIdToAllPartyNMIMap.size()+'^^appIdToAllPartyNMIMap**'+appIdToAllPartyNMIMap);
                                if(app.Record_Type_Name__c == Constants.VL2W){
                                    if(app.Nmax__c < 12){
                                        System.debug('app.nmax:::'+app.Nmax__c);
                                        appListUp.Reject_Scenario__c='Minimum Tenure ineligible';
                                      //appListUp.Sub_Stage__c=Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
                                        appListUp.Sub_Stage__c=Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE;
                                        appListUp.error_message_pl__c ='Customer not eligible for loan based on age criterion';
                                        appListUp.Id = app.id;
                                        applist.add(appListUp);
                                        break; 
                                    }
                                    if(par.NMI_Claimed_By_Customer__c < Integer.valueOf(Label.VL_MIN_EMI_2W)){
                                        appListUp.Reject_Scenario__c='Eligibility below minimum threshold ';
                              //        appListUp.Sub_Stage__c=Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
                                        appListUp.Sub_Stage__c=Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE;
                                        appListUp.error_message_pl__c ='Eligibility below minimum threshold of INR '+String.valueof(app.PMin__c);
                                        appListUp.Id = app.id;
                                        applist.add(appListUp);
                                        break;
                                    }
                                }
                                
                                if(app.Record_Type_Name__c == Constants.VL4W){
                                    if(app.Nmax__c < 36){
                                        System.debug('app.nmax:::'+app.Nmax__c);
                                        appListUp.Reject_Scenario__c='Minimum Tenure ineligible';
                                        appListUp.Sub_Stage__c=Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE;
                                        appListUp.error_message_pl__c ='Customer not eligible for loan based on age criterion';
                                        appListUp.Id = app.id;
                                        applist.add(appListUp);
                                        break; 
                                    }
                                    if(par.NMI_Claimed_By_Customer__c < Integer.valueOf(Label.VL_MIN_EMI_4W)){
                                        appListUp.Reject_Scenario__c='Eligibility below minimum threshold';
                                        appListUp.Sub_Stage__c=Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE;
                                        appListUp.error_message_pl__c ='Eligibility below minimum threshold of INR '+String.valueof(app.PMin__c);
                                        appListUp.Id = app.id;
                                        applist.add(appListUp);
                                        break;
                                    }
                                    
                                }//v1.1-end
                                
                            }// Vehicle Loan Rejection scenario -end
                            
                        }//end of party for loop
                        
                    }//end of partyMap contains check

                    //VL collateral rejection scenario
                    System.debug('app.genesis__Collaterals__r.size()>>> '+app.genesis__Collaterals__r.size());
                    if( (app.Sub_Stage__c==Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE && oldMapApp.get(app.id).Sub_Stage__c <> Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE ) && (app.Record_Type_Name__c == Constants.VL2W || app.Record_Type_Name__c == Constants.VL4W) ){
                        for(clcommon__Collateral__c cols:app.genesis__Collaterals__r){
                            System.debug('each Collateral>>>'+cols);
                            //Rejection scenario for Vehicle value null
                            if(Utility.ISStringBlankorNull(string.valueof(cols.ExshowRoomPrice_Api__c) ) ){
                                appListUp.Reject_Scenario__c='Kindly check vehicle and dealer details';
                                appListUp.error_message_pl__c ='Kindly check vehicle and dealer details';
                                appListUp.Sub_Stage__c=Constants.APPLICATION_CREATED_SUBSTAGE;
                                appListUp.Id = app.id;
                                applist.add(appListUp);
                                break;
                            }
                            /*//v1.2(start)
                            //added rejection scenario for vehicle price variance more than 10%
                            if(string.valueof(cols.ExshowRoomPrice_Api__c)!=null && string.valueof(cols.ExShow_Room_Price__c)!=null){
                                if (cols.ExShow_Room_Price__c>cols.ExshowRoomPrice_Api__c) {
                                    Decimal priceVariance = Math.abs(cols.ExShow_Room_Price__c-cols.ExshowRoomPrice_Api__c)*100/cols.ExshowRoomPrice_Api__c;
                                    System.debug('priceVariance>>>'+priceVariance);
                                    if (priceVariance > 10) {
                                        appListUp.Reject_Scenario__c='Vehicle value does not match market price';
                                        appListUp.error_message_pl__c ='Vehicle value does not match market price';
                                        appListUp.Sub_Stage__c=Constants.APPLICATION_CREATED_SUBSTAGE;
                                        appListUp.Id = app.id;
                                        applist.add(appListUp);
                                        break;
                                    } 
                                }
                            }
                            //v1.2(end)*///commented after discussion with Akshaya;Date:05-11-2018
                        }//end of collateral for loop
                    }//end of VL collateral rejection scenario
                }//end of application for loop

                ApplicationTriggerHandler.IsFirstRun = False;
                update applist;  
            }//IsFirstRun(end)
        }catch(Exception e){
            System.debug('exception'+e.getMessage()+'At'+e.getLineNumber());
            HandleBusinessException.captureError('RejectionScenarioHandeller', 'RejectioMethodPersonalLoan', e); 
        }
        
    }
    public static String getBranchCity(String branchCode, boolean check){
        List <Branch_Master__c> branchL = [Select Id,CODCCBRN__c,State__c,Retail_Category__c,NAMCCCITY__c from Branch_Master__c where CODCCBRN__c =:branchCode Limit 1];
        if(branchL.size()>0){
            if(check == true){
                return branchL[0].Retail_Category__c;
            }else if(check == false){
                return branchL[0].NAMCCCITY__c;   
            }
        }
        return null;
    }

    //v1.3(start)
    @InvocableMethod
    public static void completeOpenTask(List<Id> ids){
        System.debug('Inside completeOpenTask-ids>>>'+ids);
        List<genesis__Applications__c> listAppln =[select id,genesis__Valid_Pricing_Flag__c,Application_Stage__c,genesis__Account__r.salutation,genesis__CL_Product_Name__c,Name,Sub_Stage__c,Total_Loan_Amount__c,Primary_Applicant__c,Amount_in_Words_And_Figures__c,genesis__Interest_Rate__c,Person_Email__c from genesis__Applications__c where Id IN:ids AND (Application_Stage__c =: Constants.APPLICATION_REJECTED_MAINSTAGE OR Application_Stage__c =: Constants.DEACTIVATED_APPLICATIONS_MAINSTAGE)];
        if(listAppln.size() > 0){
            if (!listAppln[0].genesis__Valid_Pricing_Flag__c) {
                taskClosure(new List<Id>{listAppln[0].Id});
            } else {
                List<Task> lstOpenTask = new List<Task>();
                lstOpenTask = [Select Id,WhatID,Status,Subject From Task Where WhatID IN: listAppln and Status !='Completed' FOR UPDATE];
                if (lstOpenTask.size()>0) {
                    List<Task> taskToUpdate = new List<Task>();
                    for(Task eachTask: lstOpenTask) {
                        Task TaskT = new Task();
                        TaskT.Id = eachTask.Id;
                        TaskT.Status = 'Completed';
                        taskToUpdate.add(TaskT);
                    }
                    TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
                    update taskToUpdate;
                }
            }
        }
    }

    @future
    public static void taskClosure(List<Id> appIds){
        System.debug('Inside taskClosure-appIds>>>'+appIds);
        List<genesis__Applications__c> listAppln =[select id,Application_Stage__c,genesis__Account__r.salutation,genesis__CL_Product_Name__c,Name,Sub_Stage__c,Total_Loan_Amount__c,Primary_Applicant__c,Amount_in_Words_And_Figures__c,genesis__Interest_Rate__c,Person_Email__c from genesis__Applications__c where Id IN:appIds AND (Application_Stage__c =: Constants.APPLICATION_REJECTED_MAINSTAGE OR Application_Stage__c =: Constants.DEACTIVATED_APPLICATIONS_MAINSTAGE)];
        List<Task> lstOpenTask = new List<Task>();
        lstOpenTask = [Select Id,WhatID,Status,Subject From Task Where WhatID IN: listAppln and Status !='Completed' FOR UPDATE];
        if (lstOpenTask.size()>0) {
            List<Task> taskToUpdate = new List<Task>();
            for(Task eachTask: lstOpenTask) {
                Task TaskT = new Task();
                TaskT.Id = eachTask.Id;
                TaskT.Status = 'Completed';
                taskToUpdate.add(TaskT);
            }
            TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
            update taskToUpdate;
        }
    }
    //v1.3(end)
    
}