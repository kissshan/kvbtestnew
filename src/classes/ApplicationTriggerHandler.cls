/*
* Name    : ApplicationTiggerHandler 
* Company : ET Marlabs
* Author  : Venu
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
V1.1    27-Aug-2018    Braj          addition of Vehicle loan for FI and changes in sub stage for FI calling.
V1.2    27-Aug-2018    Ashok         Rerun of FI trigger #VL717
V1.3    06-Sep-2018    Braj          #VL717:Added method ApplicationStageUpdateHandler.updateApplicationStage()
V1.4    26-Sep-2018    Braj          #VL717:Added method FindPerfiosPrimaryBank() to updating Book_Debts_Age__c(Processing fee waiveoff)
V1.5    20-Nov-2018    Dipen         Condition added in AfterInsertCls method to stop sms for third party application.
V1.6    04-Dec-2018    Braj          Trigger point for document generation (legal/non-legal) for VL and PL changed to Processing Fee Paid
v1.7    28-Dec-2018    Braj          Rule Based FI are implemented for LAP and HL similar to VL
*******************************************************************************************/

public class ApplicationTriggerHandler {
    //singleton instance
    private static ApplicationTriggerHandler instance = null;
    
    //constructor
    private ApplicationTriggerHandler(){}
    
    //get singleton instance
    public static ApplicationTriggerHandler getInstance(){
        if(instance == null){
            instance = new ApplicationTriggerHandler();
        }
        RETURN instance;
    }
    public static Boolean IsFirstRun = true;
    public Boolean recursionFlag = false;
    
    // After update
    public void AfterUpdateCls(List<genesis__Applications__c> Applist,Map<Id,genesis__Applications__c> oldApp,List<genesis__Applications__c> oldList,Map<Id,genesis__Applications__c> newApp){
        
        String scoreCardCreatedFlag;
        // Re run eligibility on FI Status get positive.
        Retry_Task_call.FIRerunElig(Applist, oldApp);//V1.2
        
        
        //Create Task for HL
        system.debug('Applist:-'+Applist);
        system.debug('oldList:-'+oldList);
        TaskFlow_Helper.createTask(Applist,oldList);
        
        map<Id,Boolean> modTriggerMap= TermLoan_SOQL_Util.modTriggerMethod(newApp.keySet());
        
        
        Call_BRE_HL.call_BRE(Applist,oldApp);        
        //SendEmailHandler.SendEmail(Applist,oldList);
        SendSMSService.termsSms(Applist,oldApp);
        SendEmailHandler.termsEmail(Applist,oldApp);
        NMICalculations.CallNMI(Applist,oldApp);
        String recordtypeIdSME = SOQL_Util.getRecordTypeId('SME_Renewal');
        List<genesis__Applications__c> changedAppList = new List<genesis__Applications__c>();
        
        ApplicationEligibiltyHandler.CheckEMI(Applist, oldApp);
        ProcessingFee.CallCalculatefee(Applist, oldApp, oldList, newApp);
        // Vl recalculate
        Retry_Task_call_VL.applicationReCalVL(Applist, oldApp);
        Retry_Task_call_VL.FindPerfiosPrimaryBank(Applist, oldApp);//V1.4
        //for PL & VL
        RejectionScenarioHandeller.RejectioMethodPersonalLoan(newApp, oldApp);
        RejectionScenarioHandeller.RejectioMethodHomeLoan(newApp, oldApp);
        SanctionMessageGenerator.sanctionMessageMethod(AppList, oldApp, oldList, newApp);
        system.debug('kk');
        Calculate_Estamp_HL.BranchRejectionHL(Applist, oldApp);
        //Commentd due to process builder //Calculate_Estamp_HL.HLScoreRejectionScenario(Applist,oldApp); //HL Refer to Credit
        Set<String> applicationIds  = new Set<String>();
        
        Set<String> applicationIdsForFinalSanctionDocGeneration  = new Set<String>();
        Set<String> applicationIdsForFinalDocGeneration  = new Set<String>();
        Set<String> applicationIdsForModDocGeneration= new Set<String>();
        Set<String> smeFnlSacOfrdIds= new Set<String>();
        for(genesis__Applications__c app : Applist){
            // For SME Enhancement
            if(app.RecordType_Developer_Name__c == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || app.RecordType_Developer_Name__c == Constants.SME_APP_RECORD_TYPE_EXCEEDING || app.RecordType_Developer_Name__c == Constants.SME_APP_RECORD_TYPE_ADHOC || app.RecordType_Developer_Name__c == Constants.SME_NEW_LOAN_RECORD_TYPE){
                System.debug('Inside First If loop');
                
                if((app.Application_Stage__c == Constants.SME_APP_STAGE_ENHANCEMENT_FINAL_SANC || app.Application_Stage__c == Constants.SME_APP_STAGE_ADHOC_FINAL_SANC || app.Application_Stage__c == Constants.NEW_LOAN_FINAL_SANCTION) && Underwriting_CTRL_Helper.checkIfLandAndBuildingOrOtherCollateralExist(app.Id) && newApp.get(app.Id).Application_Stage__c != oldApp.get(app.Id).Application_Stage__c){
                    //applicationIdsForFinalSanctionDocGeneration.add(app.Id);
                    
                    System.debug('Iddddddd---> ' + applicationIdsForFinalSanctionDocGeneration);
                }
                else if((app.Application_Stage__c == 'Enhancement- Final sanction offered' || app.Application_Stage__c=='Adhoc- Final sanction offered' || app.Application_Stage__c == Constants.NEW_LOAN_FINAL_SANCTION_OFFERED)  && newApp.get(app.Id).Application_Stage__c != oldApp.get(app.Id).Application_Stage__c){ //&& !Underwriting_CTRL_Helper.checkIfLandAndBuildingOrOtherCollateralExist(app.Id)
                    /*applicationIdsForModDocGeneration.add(app.Id);
System.debug('MODIddddddd---> ' + applicationIdsForModDocGeneration);*/
                    /* Need to send SMS and Email to Customer*/
                    smeFnlSacOfrdIds.add(app.Id);
                }
                /* Added for new Doc Flow - Vignesh*/
                else if((app.Application_Stage__c == 'Enhancement- Final Sanction Accepted' || app.Application_Stage__c=='Adhoc- Final Sanction Accepted' || app.Application_Stage__c == 'New Loan- Final Sanction Accepted') &&  newApp.get(app.Id).Application_Stage__c != oldApp.get(app.Id).Application_Stage__c){ //!Underwriting_CTRL_Helper.checkIfLandAndBuildingOrOtherCollateralExist(app.Id) &&
                    /*applicationIdsForModDocGeneration.add(app.Id);
applicationIdsForFinalDocGeneration.add(app.Id);*/
                    
                    /* Create task for BM to Generate all the document except B1 */
                    System.debug('Application Stage ===='+app.Application_Stage__c);
                    SOQL_Util.createTaskForBM(app.Id,'Generate Final Document','Generate Documents');
                    if(app.Type_of_Application__c=='Composite' || app.Type_of_Application__c=='Term Loan'){
                        System.debug('Create Approve Disbursement ===');
                        SOQL_Util.createTaskForBM(app.Id,'Approve Disbursement','Approve Disbursement');
                    }
                    Map<Id,Id> CreditOfficerIdMap= SOQL_Util.BranchCreditOfficerIdMap(Applist);
                    if(modTriggerMap.size()>0 && modTriggerMap.get(app.Id) && (app.Type__c != null && !app.Type__c.contains('Takeover'))){//if( Underwriting_CTRL_Helper.checkIfLandAndBuildingOrOtherCollateralExist(app.Id) && (app.Type__c != null && !app.Type__c.contains('Takeover'))){ 
                        if(CreditOfficerIdMap.containsKey(app.Id) && CreditOfficerIdMap.get(app.Id)!=null){
                            SOQL_Util.createTaskForBRCreditOfficer(app.Id,CreditOfficerIdMap.get(app.Id),'MOD Needed','MOD Needed');
                        }else{
                            SOQL_Util.createTaskForBM(app.Id,'MOD Needed','MOD Needed');
                            
                        }
                    }
                    if(app.Application_Stage__c == 'New Loan- Final Sanction Accepted' && app.Type__c != null && app.Type__c.contains('Takeover')){
                        SOQL_Util.createTaskForBM(app.Id,'Complete takeover formalities','Complete takeover formalities');
                    }
                }
                else if(app.Application_Stage__c == 'Exceeding-Final sanction'){
                    System.debug('Inside Exceeding-Final Sanction');
                    /* Create task for BM to Generate all the document for Exceeding Application */
                    SOQL_Util.createTaskForBM(app.Id,'Generate Final Document','Generate Document');
                    System.debug('After Task Creation Line');
                    
                }
            }
            
            // for SMS and EMAIL
            for(genesis__Applications__c oApp : oldList){ 
                System.debug('test app.genesis__CL_Product_Name__c' + app.genesis__CL_Product_Name__c);
                if(app.Record_Type_Name__c  ==Constants.HOMELOAN && !app.genesis__CL_Product_Name__c.contains('Co-Lending')){
                    if((app.Sub_Stage__c=='Loan Sanctioned Non-STP' || app.Sub_Stage__c=='Loan Sanctioned STP'||  app.Sub_Stage__c=='Loan Sanctioned-Committee' || app.Sub_Stage__c == 'Pre - Approval Approved' || app.Sub_Stage__c == 'Processing Fee Paid' || app.Sub_Stage__c == 'Disbursement Approved' || app.Sub_Stage__c == 'Sanction pending - Non STP' || app.Sub_Stage__c == 'MOD Initiated') && (app.Sub_Stage__c <> oApp.Sub_Stage__c)){
                        //SendSMSService.sendSMSApp(app);
                        SendSMSService.sendSMSApp(JSON.serialize(app));
                    }
                }
                
                
                if(app.Record_Type_Name__c  ==Constants.LAPLOAN && !app.genesis__CL_Product_Name__c.contains('Co-Lending')){
                    if((app.Sub_Stage__c=='Terms and Conditions Accepted' || app.Sub_Stage__c=='Loan Sanctioned Non-STP' ||app.Sub_Stage__c=='Loan account opened' || app.Sub_Stage__c=='Disbursement Documents Esigned') && (app.Sub_Stage__c <> oApp.Sub_Stage__c)){
                        //SendSMSService.sendSMSApp(app);
                        LAP_SendSMS.sendSMSSubstage(JSON.serialize(app));
                    }
                }
                
                System.debug('app.Record_Type_Name__c'+app.Record_Type_Name__c+' app.genesis__CL_Product_Name__c '+ app.genesis__CL_Product_Name__c);
                //vehicle Loan
                if((app.Record_Type_Name__c  ==Constants.VL2W ||  app.Record_Type_Name__c == Constants.VL4W) && !app.genesis__CL_Product_Name__c.contains('Co-Lending')){
                    if((app.Sub_Stage__c=='Terms and Conditions Accepted' || app.Sub_Stage__c=='Loan Sanctioned Non-STP' ||app.Sub_Stage__c=='Loan account opened' || app.Sub_Stage__c=='Disbursement Documents Esigned'||app.Sub_Stage__c=='Loan Sanctioned STP' || app.Sub_Stage__c=='SI details captured' || app.Sub_Stage__c=='Application Rejected') & (app.Sub_Stage__c <> oApp.Sub_Stage__c)){
                        System.debug('%%Call  sendSMSSubstage LAp%%');
                        VL_SendSMS.sendSMSSubstageVL(JSON.serialize(app));
                    }
                }
                
                //v1.7(start)
                //for personal loan
                if(app.Record_Type_Name__c  ==Constants.PERSONALLOAN){
                    if(app.Sub_Stage__c ==Constants.TERMS_AND_CONDITIONS_ACCESPT_SUBSTAGE && oApp.Sub_Stage__c <> Constants.TERMS_AND_CONDITIONS_ACCESPT_SUBSTAGE){
                        AstuteAPIHandler.AstuteCallHandler(app.id);
                    }
                    
                    //v1.6(start)
                    // Document generation trigger point for PL....
                    if(app.Sub_Stage__c ==Constants.PROCESSING_FEE_PAID_SUBSTAGE && oApp.Sub_Stage__c <> Constants.PROCESSING_FEE_PAID_SUBSTAGE){
                        PL_Digio_Services.docGenAndSignDocPL(app.id ,Constants.PRE_APPROVE_SANCTION_PL);
                    }
                    //v1.6(end)
                    
                    if(app.Sub_Stage__c ==Constants.SUBSTAGE_DISBURSEMENTESIGN && oApp.Sub_Stage__c <> Constants.SUBSTAGE_DISBURSEMENTESIGN){
                        CBS_API_Calling_HL.call_CBS_API(app.Id);
                    }
                    if(app.genesis__CL_Product_Name__c!=null && !app.genesis__CL_Product_Name__c.contains('Co-Lending')){
                        LAP_SendSMS.sendSms(JSON.serialize(app));
                    }
                }
                
                if(app.Record_Type_Name__c  ==Constants.LAPLOAN ||  app.Record_Type_Name__c==Constants.HOMELOAN || app.Record_Type_Name__c  == Constants.VL4W || app.Record_Type_Name__c  == Constants.VL2W){
                    if(app.Sub_Stage__c ==Constants.PersonalDetailsCapt && oApp.Sub_Stage__c <> Constants.PersonalDetailsCapt) {
                        System.debug('calling AstuteAPIHandler.VL_FICheck()');
                        AstuteAPIHandler.VL_FICheck(app.id);
                    } else if(app.Sub_Stage__c == Constants.TERMS_AND_CONDITIONS_ACCESPT_SUBSTAGE && oApp.Sub_Stage__c <> Constants.TERMS_AND_CONDITIONS_ACCESPT_SUBSTAGE) {
                        System.debug('calling AstuteAPIHandler.AstuteCallHandler()');
                        AstuteAPIHandler.AstuteCallHandler(app.id);
                    }
                }
                
                // V1.1 -vehicle Loan
                if(app.Record_Type_Name__c  == Constants.VL4W || app.Record_Type_Name__c  == Constants.VL2W) {
                    //v1.6(start)
                    if( (app.Sub_Stage__c ==Constants.PROCESSING_FEE_PAID_SUBSTAGE && oApp.Sub_Stage__c <> Constants.PROCESSING_FEE_PAID_SUBSTAGE) ){
                        VL_Digio_Services.docGenAndSignDocVL(app.id ,Constants.VLSANCTIONLETTER);
                        system.debug('##### Vehicle Document generation triggerd ...');
                    }
                    //v1.6(end)
                    if(app.Sub_Stage__c ==Constants.SUBSTAGE_DISBURSEMENTESIGN && oApp.Sub_Stage__c <> Constants.SUBSTAGE_DISBURSEMENTESIGN){
                        CBS_API_Calling_HL.call_CBS_API(app.Id);
                    }
                }
                //V1.1-end
                //v1.7(end)
            }
        } 
        
        //Send SMS and task creation for SME customer for SME Customer
        ApplicationTriggerHelper.sendSMSandtaskCreation(newApp,oldApp);
        if(smeFnlSacOfrdIds.size()>0){
            SME_SendSMSService.sendSMSApp_SME(smeFnlSacOfrdIds);
        }
        if(!recursionFlag){
            recursionFlag   = true;
            
            //CBS_API calls(KYC,OD/TOD)
            ApplicationTriggerHelper.CBS_ApiCall(newApp,oldApp);//Sanction complete,Sanction complete- Final Sanction
            
            //Delete financial data
            ApplicationTriggerHelper.deleteFinancialData(newApp,oldApp);
            Re_run_Bureau.run_bureau(Applist,oldApp); //Added for LAP bureau call    
            //Clear Perfios Id on Perfios Error
            //ApplicationTriggerHelper.clearPerfiosTxId(newApp,oldApp);
            IsFirstRun      = false;
        }
        if(!applicationIdsForFinalSanctionDocGeneration.isEmpty()){
            Button_Utility.generateDocs(applicationIdsForFinalSanctionDocGeneration,new Set<String>());
        }
        
        //for future method call.
        ApplicationTriggerHelper.qualitativeInputDone(newApp,oldApp);
        
    }
    
    // for Before Update
    public void BeforeUpdateCls(list<genesis__Applications__c> Applist,Map<Id,genesis__Applications__c> newApp,Map<Id,genesis__Applications__c> oldApp){
        //Update Legal_Desk_State_Flag for SME Applications
        
        updateLegalDeskFlag(Applist,oldApp);
        ProcessingFee.callPropertyDetails(Applist,oldApp);
        Retry_Task_call.applicationReCal(Applist,oldApp); //added by Subas(HL)
        
        BREScoreCal.breCal(Applist,oldApp);
        BRE_ScoreCalExperian.ExpBreCal(Applist,oldApp); 
        Calculate_Estamp_HL.calEstamp(Applist,oldApp);
        BREScoreCal.updatePerfioscheck(Applist,oldApp);
        RejectionScenarioHandeller.ClearRejectscenario(Applist,oldApp); 
        //  Retry_Task_call.FIRerunElig(Applist, oldApp);
        // V1.2
        CBS_API_Calling_HL.initiateDisbursment(Applist,oldApp); //Start Disbursment
        // ApplicationNMI_Calculaitons.callNMI(Applist, oldApp);
        //  GurantorDocket.callDocket(Applist, oldApp);
        for(genesis__Applications__c app : Applist){
            if(app.Succession_plan__c != null && app.Management_experience__c != null && app.Nature_of_product_manufactured_traded__c != null && app.Selling_and_distribution_arrangement__c != null && app.External_certfications__c != null && app.Government_policies__c != null && app.Industry_outlook__c != null && app.CA_with_other_banks__c != null && app.Court_cases_non_credit_related__c != null){
                if(app.RecordType_Developer_Name__c == Constants.SME_NEW_LOAN_RECORD_TYPE && app.Reason__c !=null) {
                    if(app.Reason__c == 'Yes'){
                        app.Qualitative_input_done__c = true;    
                    }else if(app.Reason__c == 'No'){
                        app.Application_Stage__c    = 'Perfios error';
                    }    
                }else {
                    app.Qualitative_input_done__c = true;
                }
                
            }       
            
        }
        //Reset sign info on change of application stage to 'Limit extended'
        ApplicationTriggerHelper.resetSignInfo(newApp,oldApp);
        
        //Capture dates for TAT calculation
        ApplicationTriggerHelper.tatCapture(newApp,oldApp);
        RejectionScenarioHandeller.RejectioMethod(newApp,oldApp); // Added for reject senario LAP
        ApplicationTriggerHelper.appChargeCalculation(Applist,newApp,oldApp);
        //Re_run_Bureau.run_bureau(Applist,oldApp); //Added for LAP bureau call        
        //for PL
        //RejectionScenarioHandeller.RejectioMethodPersonalLoan(newApp, oldApp);
    }
    
    // for After Insert
    List<String> listObj = new List<String>();
    public void AfterInsertCls(list<genesis__Applications__c> Applist){
        //SME Reordtype
        String recordtypeIdSME = SOQL_Util.getRecordTypeId('SME_Renewal');
        
        for(genesis__Applications__c app : Applist){
            //SendEmailHandler.SendEmail(app);
            //Below condition is added for not sending an SMS to third party application -Dipen
            if(app.Sub_Stage__c != WS_Vendor_Constants.SUB_STAGE_APP_CREATED && app.Sub_Stage__c != WS_Vendor_Constants.SUB_STAGE_CBS_PENDING){
                if(app.Record_Type_Name__c==Constants.HOMELOAN){                    
                    SendSMSService.sendSMSonCrt(JSON.serialize(app));
                }
                //// add lap create application-niladri
                if(app.Record_Type_Name__c==Constants.LAPLOAN){
                    LAP_SendSMS.sendSMSonCrt1(JSON.serialize(app));
                }
                
                if(app.Record_Type_Name__c==Constants.VL4W || app.Record_Type_Name__c==Constants.VL2W){
                    System.debug('***inside app create 2w');
                    VL_SendSMS.sendSMSonCrtVL(JSON.serialize(app));
                }
            }
            //for SME Application
            //Added by Raushan
            system.debug('recursionflag:::'+recursionFlag);
            if(!recursionFlag){
                recursionFlag = true;
                if(String.ValueOf(app.RecordTypeId) == recordtypeIdSME){
                    listObj.add(String.valueOf(app.id));                    
                } 
            }
            
            //V1.3-start
            //method to update main stage based on sub stage for vehicle loan
            /*    if(app.Record_Type_Name__c  == Constants.VL4W || app.Record_Type_Name__c  == Constants.VL2W) {
ApplicationStageUpdateHandler.updateApplicationStage(Applist);
}*/
            //V1.3-end
        }  
        system.debug('listObj.size()'+listObj.size());
        if(listObj.size() > 0)SME_PRE_RENEWAL_CHECKING.createPrechecklist(listObj);
        
    }
    
    //For Before Insert
    public void BeofreInsertCls(list<genesis__Applications__c> Applist){
        
    }
    public void updateLegalDeskFlag(List<genesis__Applications__c> appNewList, Map<Id,genesis__Applications__c> appOldMap){
        for(genesis__Applications__c app : appNewList){
            if(app.Record_Type_Name__c.contains('SME')){
                if(app.Branch_Code__c != null && app.Application_Stage__c != null && appOldMap.get(app.Id).Application_Stage__c != app.Application_Stage__c && ((app.Record_Type_Name__c == 'SME Renewal' && app.Application_Stage__c == 'Final sanction offered') || (app.Record_Type_Name__c == 'SME NEW Loan' && app.Application_Stage__c == 'New Loan - Final sanction offered') || (app.Record_Type_Name__c == 'SME Exceeding' && app.Application_Stage__c == 'Exceeding- Final sanction offered') || (app.Record_Type_Name__c == 'SME Enhancement' && app.Application_Stage__c == 'Enhancement- Final sanction offered') || (app.Record_Type_Name__c == 'SME AdHoc' && app.Application_Stage__c == 'Adhoc- Final sanction offered'))){
                    List<Branch_Master__c> brMasterList = new List<Branch_Master__c>();
                    List<State_Master__c> stMasterList = new List<State_Master__c>();
                    brMasterList = [select id, CODCCBRN__c, State__c from Branch_Master__c where CODCCBRN__c = :app.Branch_Code__c Limit 1];
                    if(brMasterList.size() > 0 && brMasterList[0].State__c != null){
                        stMasterList = [SELECT Id,Legal_desk_state_flag__c FROM State_Master__c WHERE Name =: brMasterList[0].State__c];
                        if(stMasterList.size() > 0 && stMasterList[0].Legal_desk_state_flag__c == true){
                            app.Legal_desk_state_flag__c = true;
                        }
                    }
                }
            }
        }
    }

    public void sendSME_SMS_ApplicationAfterInsert(list<genesis__Applications__c> Applist,Map<Id,genesis__Applications__c> newApp,Map<Id,genesis__Applications__c> oldApp){

    }
}