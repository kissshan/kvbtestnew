/* 
* Name     : ApplicationTriggerHelper
* Purpose  : Helper class for Application trigger handler
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class ApplicationTriggerHelper {
    //Get SME renewal record type id be name
    static String recordtypeIdSME = SOQL_Util.getRecordTypeId('SME_Renewal');
    
    ///CBS_ApiCalls
    public static void CBS_ApiCall(map<Id,genesis__Applications__c> newMap,map<Id,genesis__Applications__c> oldMap){
        List<Id> updatedAppIdList = new List<Id>();
        for(genesis__Applications__c app : newMap.values()){
            System.debug('Test oldMap.get(app.Id).Application_Stage__c'+oldMap.get(app.Id).Application_Stage__c);
            System.debug('Test app.Application_Stage__c'+app.Application_Stage__c);
            if(app.Application_Stage__c != oldMap.get(app.Id).Application_Stage__c && (app.Application_Stage__c == 'Sanction complete' || app.Application_Stage__c == 'Sanction complete- Final Sanction')){
                updatedAppIdList.add(app.Id);
            }
        }
        List<genesis__Applications__c> updatedAppList = new List<genesis__Applications__c>();
        updatedAppList = [SELECT Id,(SELECT Id,Is_New__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c,genesis__Party_Account_Name__c,
                                     genesis__Party_Account_Name__r.Branch_Code__c,genesis__Party_Account_Name__r.Customer_IC__c,
                                     genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.Voter_Id__c,
                                     genesis__Party_Account_Name__r.Passport_Number__pc,genesis__Party_Account_Name__r.Driving_License_ID__c,
                                     genesis__Party_Account_Name__r.National_Identification_Code__c,genesis__Party_Account_Name__r.Other_identification_number__c,
                                     genesis__Party_Account_Name__r.CreatedDate,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,
                                     genesis__Party_Account_Name__r.Telephone_Bill__c,genesis__Party_Account_Name__r.Ration_Card__c,
                                     genesis__Party_Account_Name__r.Employment_Letter__c,genesis__Party_Account_Name__r.Same_Present_Address_Permanent_Address__c,
                                     genesis__Party_Account_Name__r.Bank_Statement__c,genesis__Party_Account_Name__r.Annual_TurnoverIncome__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc FROM genesis__Application_Parties__r WHERE Active__c = true) FROM genesis__Applications__c WHERE Id IN :updatedAppIdList];
        if(!updatedAppIdList.isEmpty()){
            SME_CBS_Handler.eKYC_Updation(updatedAppIdList);
            
            SME_CBS_Handler.limitUpdation_ChargeColllection(updatedAppIdList);
        }
    }
    
    //Send SMS and task creation for SME customer
    public static void sendSMSandtaskCreation(map<Id,genesis__Applications__c> appNewMap,map<Id,genesis__Applications__c> appOldMap){
        Set<String> applicationIds  = new Set<String>();
        List<genesis__Applications__c> updateAppList = new List<genesis__Applications__c>();
        List<Account> accountsToupdate    = new List<Account>();
        for(genesis__Applications__c app : appNewMap.values()){
            if(String.ValueOf(app.RecordTypeId) == recordtypeIdSME){
                if(appOldMap.get(app.id).Application_Stage__c != appNewMap.get(app.id).Application_Stage__c){
                    applicationIds.add(app.Id);                
                    updateAppList.add(app);
                } 
                
            }
            if(appOldMap.get(app.id).Industry_type_Application__c!= appNewMap.get(app.id).Industry_type_Application__c){
                accountsToupdate.add(new Account(id=app.genesis__Account__c,Industry_Type__c=app.Industry_type_Application__c));
            }
        }
        // Send SMS 
        if(applicationIds.size() > 0) SME_SendSMSService.sendSMSApp_SME(applicationIds); 
        
        //task creation
        if(updateAppList.size()>0) AssignTask.taskAssignment(updateAppList);
        
        if(accountsToupdate.size()>0) {
            AccountTriggerHandler.isAccountTrigger = true;
            update accountsToupdate;
        }
    }
    
    //Reset sign info on change of application stage to 'Limit extended'
    public static void resetSignInfo(map<Id,genesis__Applications__c> newMap,map<Id,genesis__Applications__c> oldMap){
        for(genesis__Applications__c app : newMap.values()){
            if(app.Application_Stage__c != oldMap.get(app.Id).Application_Stage__c && app.Application_Stage__c == 'Limit extended'){
                app.Sanction_ESign_Id__c = '';
                app.Sanction_Class2_Check__c = false;
                app.Sanction_ESign_Check__c = false;
                app.Sanction_Doc_Generation_Check__c = false;
                app.All_Party_Signed__c = false;
                app.Document_Page_Count__c = 0;
                app.Sanction_Letter_Name__c             ='';
            }
        }
    }
    //Delete Financial Data
    public static void deleteFinancialData(map<Id,genesis__Applications__c> newMap,map<Id,genesis__Applications__c> oldMap){
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();

        for(genesis__Applications__c app : newMap.values()){
            System.debug('app.recordType.DeveloperName '+app.recordType.DeveloperName+' app.Application_Stage__c '+app.Application_Stage__c);
           System.debug('oldMap.get(app.Id).Application_Stage__c '+oldMap.get(app.Id).Application_Stage__c);
           System.debug('app.Sub_Stage__c '+app.Sub_Stage__c );
            if(app.recordType.DeveloperName == Constants.SME_APP_RECORD_TYPE && app.Application_Stage__c != oldMap.get(app.Id).Application_Stage__c && ((app.Application_Stage__c == 'Customer follow up- Critical changes'  && app.Sub_Stage__c != oldMap.get(app.Id).Sub_Stage__c && app.Sub_Stage__c == 'Re-upload financials') || app.Application_Stage__c == 'Perfios error')){
                appList.add(app);
            }
        }
        if(!appList.isEmpty()){
            deleteFinancialDataHelper(appList);
        }
        
    }
    public static void deleteFinancialDataHelper(List<genesis__Applications__c> appList){
        List<Id> attIdList = new List<Id>();
        List<Id> appIdList = new List<Id>();
        List<genesis__AppDocCatAttachmentJunction__c> docJuncCatList = new List<genesis__AppDocCatAttachmentJunction__c>();
        List<String> docCatNameList = new List<String>{'Audited-balance sheet document last FY','Trading account document last FY','P&L document last FY','Form 3CA/3CB/3CD'};
            if(!appList.isEmpty()){
                for(genesis__Applications__c app : appList){
                    appIdList.add(app.id);
                }
            }
        if(!appIdList.isEmpty()){
            docJuncCatList = [SELECT Id,genesis__AttachmentId__c FROM genesis__AppDocCatAttachmentJunction__c WHERE genesis__Application_Document_Category__r.genesis__Application__c IN :appIdList AND genesis__Application_Document_Category__r.Name IN :docCatNameList];
        }
        if(!docJuncCatList.isEmpty()){
            for(genesis__AppDocCatAttachmentJunction__c juncCat : docJuncCatList){
                attIdList.add(juncCat.genesis__AttachmentId__c);
            }
        }
        if(!attIdList.isEmpty()){
            DELETE [SELECT Id FROM Attachment WHERE Id IN :attIdList];
        }
        if(!docJuncCatList.isEmpty()){
            DELETE docJuncCatList;
        }
    }
    public static void clearPerfiosTxId(map<Id,genesis__Applications__c> newMap,map<Id,genesis__Applications__c> oldMap){
        List<Id> accIdList = new List<Id>();
        List<Perfios__c> perfList = new List<Perfios__c>();
        //Perfios__c perf = 
        for(genesis__Applications__c app : newMap.values()){
            System.debug('app.Application_Stage__c: '+app.Application_Stage__c+'oldMap.get(app.Id).Application_Stage__c: '+oldMap.get(app.Id).Application_Stage__c);
            if(app.recordType.DeveloperName == Constants.SME_APP_RECORD_TYPE && app.Application_Stage__c != oldMap.get(app.Id).Application_Stage__c && app.Application_Stage__c == 'Perfios error'){
                if(app.genesis__Account__c != null) accIdList.add(app.genesis__Account__c);
            }
        }
        if(!accIdList.isEmpty())
            perfList = [SELECT Id,Transaction_Id__c FROM Perfios__c WHERE Applicant_Name__c IN :accIdList];
        if(!perfList.isEmpty()){
            for(Perfios__c perf : perfList){
                perf.Transaction_Id__c = '';
            }
            UPDATE perfList;
        }
    }
    
    //Date capture for TAT claculation(SME)
    public static void tatCapture(map<Id,genesis__Applications__c> newMap,map<Id,genesis__Applications__c> oldMap){
        for(genesis__Applications__c app : newMap.values()){
            if(app.Application_Stage__c != oldMap.get(app.Id).Application_Stage__c && app.Record_Type_Name__c.contains('SME')){
                List<String> appStageList = new List<String>{'New loan - Final sanction','New Loan - Final sanction offered','Adhoc-Final sanction','Adhoc- Final sanction offered','Exceeding-Final sanction','Enhancement- Final sanction offered','Enhancement- Final sanction','Interim sanction','Final sanction'};
                    if(app.Application_Stage__c == 'Limit Opened'){
                        app.Disbursement_Date__c = DateTime.now();
                    }
                if(appStageList.contains(app.Application_Stage__c) && app.Application_submitted__c != null){
                    //SanctionDate
                    app.Application_initiated__c = DateTime.now();
                }
                if(app.Application_Stage__c == Constants.APPLICATION_REVIEW_STAGE || app.Application_Stage__c == Constants.APP_REVIEW_FINAL_STAGE){
                    app.Pre_renewal_inputs_filled_date__c = DateTime.now();
                }
                if(app.Application_UI_Stage__c != oldMap.get(app.Id).Application_UI_Stage__c && app.Application_UI_Stage__c == 'Submission'){
                    app.Application_submitted__c = DateTime.now();
                }
            }
            if(app.Record_Type_Name__c == Constants.HOMELOAN){
                if(app.Sub_Stage__c != oldMap.get(app.Id).Sub_Stage__c){
                    //Capture Informal Sanction Date
                    if(app.Sub_Stage__c == Constants.APPLICATION_STATGE_TNC_ACCEPTED){
                        app.Informal_Sanction_Date__c = DateTime.now();
                    }
                    //Capture Formal Sanction Date
                    if(app.Sub_Stage__c == Constants.APPL_STAGE_LOAN_SANCTIONED_NON_STOP){
                        app.Formal_Sanction_Date__c = DateTime.now();
                    }
                    //Capture Disbursement date
                    if(app.Sub_Stage__c == Constants.APPL_STAGE_LOAN_ACCOUNT_OPENED){
                        app.Disbursement_Date__c = DateTime.now();
                        
                    }
                }
            } 
        }
    }
    public static void qualitativeInputDone(map<Id,genesis__Applications__c> newMap,map<Id,genesis__Applications__c> oldMap){
        for(genesis__Applications__c app : newMap.values()){
            if(app.RecordType_Developer_Name__c == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || app.RecordType_Developer_Name__c == Constants.SME_APP_RECORD_TYPE_EXCEEDING || app.RecordType_Developer_Name__c == Constants.SME_APP_RECORD_TYPE_ADHOC || app.RecordType_Developer_Name__c == Constants.SME_NEW_LOAN_RECORD_TYPE){
                if(app.Qualitative_input_done__c && !oldMap.get(app.Id).Qualitative_input_done__c){
                    runBREAfterM21Future(app.Id);
                }
            } 
        }       
    }
    public static void runBREAfteANDCheckCollateral(String appId){
        Boolean isFlag = getCollateralFlag(appId);
        If(isFlag){
            Underwriting_CTRL_Helper.runBreAfterM121Helper(appId);
        }
    }
    public static Boolean getCollateralFlag(String appId){
        
        try{
            List<genesis__Application_Collateral__c> listOfAppColl    = new List<genesis__Application_Collateral__c>();
            listOfAppColl = [Select id,Application__c,genesis__Collateral__c,genesis__Collateral__r.FE_Created__c,genesis__Collateral__r.No_of_M21A__c from genesis__Application_Collateral__c where Application__c =:appId AND genesis__Collateral__r.FE_Created__c =true AND genesis__Collateral__r.Active__c =true];
            if(listOfAppColl.size() >0){
                Integer totalLength = 0;
                for(genesis__Application_Collateral__c    appColl : listOfAppColl){
                    If(appColl !=null && appColl.genesis__Collateral__r.No_of_M21A__c > 0){
                        totalLength++;
                    }
                }
                if(listOfAppColl.size() == totalLength){
                    return true;
                }else{
                    return false;
                }
            }else{
                return true;
            }
        }catch(Exception e){
            return true;
        }
    }
    
    Public Static void appChargeCalculation(List<genesis__Applications__c> newList,Map<Id,genesis__Applications__c> newMap,map<Id,genesis__Applications__c> oldMap){
        Boolean chargesCalcRequired = false;
        for(genesis__Applications__c app : newList){
            System.debug('Test app.Application_Stage__c'+app.Application_Stage__c+' oldMap.get(app.Id).Application_Stage__c '+oldMap.get(app.Id).Application_Stage__c);
            if(app.Application_Stage__c != oldMap.get(app.Id).Application_Stage__c && (app.Application_Stage__c == 'Final Sanction' || app.Application_Stage__c == 'Application Filling - Final' || app.Application_Stage__c == 'Interim Sanction' || app.Application_Stage__c == 'Application filling initiated' || app.Application_Stage__c == 'New Loan- Final Sanction Accepted' || app.Application_Stage__c == 'Enhancement- Final Sanction Accepted' || app.Application_Stage__c == 'Adhoc- Final Sanction Accepted' || app.Application_Stage__c == 'Exceeding-Final sanction')){
                chargesCalcRequired = true;
            }
        }
        if(chargesCalcRequired){
            Map<Id,list<Facility__c>> mapOfFacility = new Map<Id,list<Facility__c>>();
            List<Facility__c> facRec = new List<Facility__c>();
            List<genesis__Application_Collateral__c> collList = new List<genesis__Application_Collateral__c>();
            Decimal FinalProcCharge = 0.00;
            Decimal recLimit = 0.0;
            facRec = [SELECT Id,Recommended_Rate__c,Final_Spread__c,Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Limit_Amount__c,Renewal_Processing_Charge__c,
                      Existing_Limit__c,Existing_Margin_Stock_Trading__c,New_Limit_Amount__c,MCLR_Rate__c,Nature_of_Document__c,Date_of_Document__c,
                      Recommended_Limit__c,Facility_Application_Type__c,CL_Product__c,Existing_Rate__c,Application__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,
                      Recommended_Processing_Charge__c,Recommended_Days__c,Interest_Type__c,Type__c,Approved_Margin__c,
                      CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,Margin_Stock_Trading__c,BRE_Limit__c,
                      BRE_Rate__c,BRE_Spread__c,Variance__c,Existing_Spread__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Balance_Outstandings__c,
                      Guarantee_Date__c,Account_Number__c,Application__r.genesis__Account__r.Overall_Exposure__c,Existing_Enhanced_Processing_Fee__c,Application__r.Renewal_Due_Date__c
                      FROM Facility__c WHERE Application__c IN :newMap.keyset()];
            collList = [SELECT Id,genesis__Collateral__c FROM genesis__Application_Collateral__c WHERE Application__c IN :newMap.keyset()];
            for(Facility__c fac : facRec){
                if(mapOfFacility.containsKey(fac.application__r.id)){
                    mapOfFacility.get(fac.application__r.id).add(fac);
                }else{
                    mapOfFacility.put(fac.application__r.id,new List<Facility__c>{fac});
                }
                if(fac.Recommended_Limit__c != null)
                    recLimit += fac.Recommended_Limit__c;
            }
            for(genesis__Applications__c app : newMap.values()){
                if(app.Record_Type_Name__c == Constants.SME_RECORD_TYPE_LABEL){
                    if(app.Application_Stage__c == 'Final Sanction' || app.Application_Stage__c == 'Application Filling - Final' || app.Application_Stage__c == 'Interim Sanction' || app.Application_Stage__c == 'Application filling initiated'){
                        //SME_Renewal Proceesing code::
                        app.Processing_Charges__c = calculateProChargeForRenewal(app,mapOfFacility.get(app.Id)).setScale(2);
                    }
                }
                if(app.Record_Type_Name__c == Constants.SME_RECORD_TYPE_LABEL_ENHANCEMENT || app.Record_Type_Name__c == Constants.SME_NEW_LOAN_RECORD_TYPE_LABEL){
                    if(app.Application_Stage__c == 'New Loan- Final Sanction Accepted' || app.Application_Stage__c == 'Enhancement- Final Sanction Accepted'){
                        //Enhancement/New Loan Proceesing code::
                        app.Processing_Charges__c = SMESanction_DocReq.processingFeeCalculation(mapOfFacility.get(app.Id),app).setscale(2);
                    }
                }
                if(app.Record_Type_Name__c == Constants.SME_RECORD_TYPE_LABEL_ADHOC){
                    if(app.Application_Stage__c == 'Adhoc- Final Sanction Accepted'){
                        //Adhoc Proceesing code::
                        app.Processing_Charges__c = calculateProChargeForExceedingAdhoc(app,mapOfFacility.get(app.Id));
                    }
                }
                System.debug('Test app.Record_Type_Name__c'+app.Record_Type_Name__c+' app.Application_Stage__c '+app.Application_Stage__c);
                if(app.Record_Type_Name__c == Constants.SME_RECORD_TYPE_LABEL_EXE){
                    if(app.Application_Stage__c == 'Exceeding-Final sanction'){
                        //Excedding Proceesing code::
                        app.Processing_Charges__c = calculateProChargeForExceedingAdhoc(app,mapOfFacility.get(app.Id)).setScale(2);
                    }
                }
                app.Legal_Charges__c = legalFeeCalc(recLimit,app,collList);
                app.Cersai_Charges__c = cersaiFeeCalc(collList);
                app.Valuation_Charges__c = valFeeCalc(recLimit,app,collList);
                //Stamp fee is not getting computed in SME, so for storing DOC_FEE-->Total_Stamp_Paper_Charge__c is used
                app.Total_Stamp_Paper_Charge__c = app.genesis__Additional_Cash_Required__c;
            }
        }
    }
    public static Decimal calculateProChargeForRenewal(genesis__Applications__c app,List<Facility__c> facilities){
        Decimal proChargeRenewal = 0.00;
        String next_renewal_Date;
        Date NEXT_RENEW_DATE;
        Integer days = 0;
           System.debug('TESt app.Application_Stage__c: '+app.Application_Stage__c);
        if(app.Application_Stage__c == 'Interim Sanction' || app.Application_Stage__c == 'Application filling initiated'){
            NEXT_RENEW_DATE = SMESanction_DocReq.getNextRenewalDate(System.today(),'Interim Extension');
            if(NEXT_RENEW_DATE != null){
                NEXT_RENEW_DATE = NEXT_RENEW_DATE - 1;
            }
            for(integer i=0; i<facilities.size(); i++){
                decimal charges             = 0;
                System.debug(' facilities[i].application__r.Renewal_Due_Date__c  '+facilities[0].application__r.Renewal_Due_Date__c);
                if(facilities[i].application__r.Renewal_Due_Date__c != null)
                    days =  (facilities[i].application__r.Renewal_Due_Date__c).daysBetween(NEXT_RENEW_DATE);
                if(facilities[i].Recommended_Limit__c != null && facilities[i].Recommended_Processing_Charge__c != null)
                    charges = (facilities[i].Recommended_Limit__c * (facilities[i].Recommended_Processing_Charge__c/100) * days/365).setScale(2);
                proChargeRenewal += charges;
            }
        }else if(app.Application_Stage__c == 'Final Sanction' || app.Application_Stage__c == 'Application Filling - Final'){
            NEXT_RENEW_DATE = SMESanction_DocReq.getNextRenewalDate(System.today(),'Final Sanction');
            if(NEXT_RENEW_DATE != null){
                NEXT_RENEW_DATE = NEXT_RENEW_DATE - 1; 
            }
            for(integer i=0; i<facilities.size(); i++){
                decimal charges             = 0;
                if(facilities[i].application__r.Renewal_Due_Date__c != null)
                    days =  (facilities[i].application__r.Renewal_Due_Date__c).daysBetween(NEXT_RENEW_DATE);
                if(facilities[i].Recommended_Limit__c != null && facilities[i].Recommended_Processing_Charge__c != null)
                    charges = (facilities[i].Recommended_Limit__c * (facilities[i].Recommended_Processing_Charge__c/100) * days/365).setScale(2);
                proChargeRenewal += charges;
            }
        }
        return  proChargeRenewal;
    }
    
    public static Decimal calculateProChargeForExceedingAdhoc(genesis__Applications__c app,List<Facility__c> facilities){
        list<Account> accList = new List<Account>();
        Decimal proChargeOfExcAdhoc = 0.00;
        Decimal totalAMT =0.00;
        Decimal overallExpo = 0.00;
        accList = [SELECT id,Priority_Sector__c,Overall_Exposure__c FROM Account WHERE id =: app.genesis__Account__c];
        if(app.Record_Type_Name__c == Constants.SME_RECORD_TYPE_LABEL_EXE){
            for(Integer i=1; i<= facilities.size(); i++){
                if((facilities[i-1].Recommended_Limit__c) != NULL){
                    totalAMT += facilities[i-1].Recommended_Limit__c;
                    System.debug(' totalAMT ' + totalAMT); 
                    overallExpo = facilities[i-1].Application__r.genesis__Account__r.Overall_Exposure__c;
                    system.debug('overallExpo:::'+overallExpo);
                }
                if(app.Sanction_Authority__c != NULL && app.Sanction_Authority__c.contains('BR_MGR')){
                    if(accList[0].Priority_Sector__c == TRUE && overallExpo < 500000){
                        proChargeOfExcAdhoc = 0.00;
                    }
                    else if((totalAMT <= 500000)){
                        proChargeOfExcAdhoc      = 3000 ;
                    }
                    else if((totalAMT >= 500000 && totalAMT < 1000000)){
                        proChargeOfExcAdhoc = 3000 ;
                    }
                    else if((totalAMT >= 1000000 && totalAMT < 2500000)){
                        proChargeOfExcAdhoc = 4500 ;
                    }
                    else if((totalAMT >= 2500000 && totalAMT < 5000000)){
                        proChargeOfExcAdhoc = 6500 ;
                    }
                }
                else if(accList[0].Priority_Sector__c == TRUE && overallExpo < 500000){
                    proChargeOfExcAdhoc = 0.00;
                }
                else if((totalAMT <= 500000)){
                    proChargeOfExcAdhoc = 6000 ;
                }
                else if((totalAMT >= 500000 && totalAMT < 1000000)){
                    proChargeOfExcAdhoc = 6000;
                }
                else if((totalAMT >= 1000000 && totalAMT < 2000000)){
                    proChargeOfExcAdhoc = 7000;
                }
                else if((totalAMT >= 2000000 && totalAMT < 5000000)){
                    proChargeOfExcAdhoc = 10000;
                }
                else if((totalAMT >= 5000000 && totalAMT < 10000000)){
                    proChargeOfExcAdhoc = 25000;
                }
                else if((totalAMT >= 10000000)){
                    proChargeOfExcAdhoc = 40000;
                }
            }
            return proChargeOfExcAdhoc;
        }else if(app.Record_Type_Name__c == Constants.SME_RECORD_TYPE_LABEL_ADHOC){
            if(app.Sanction_Authority__c != NULL && app.Sanction_Authority__c.contains('BR_MGR')){
                if(accList[0].Priority_Sector__c == TRUE && totalAMT < 500000){
                    proChargeOfExcAdhoc = 0.00;
                }
                else If(accList[0].Priority_Sector__c == FALSE && totalAMT < 500000){
                    proChargeOfExcAdhoc = 3000;
                }
                else If(accList[0].Priority_Sector__c == FALSE && (totalAMT >= 500000 && totalAMT < 1000000)){
                    proChargeOfExcAdhoc      = 3000;
                    
                }
                else If(accList[0].Priority_Sector__c == FALSE && (totalAMT >= 1000000 && totalAMT < 2500000)){
                    proChargeOfExcAdhoc      = 4500;
                }
                else If(accList[0].Priority_Sector__c == FALSE && (totalAMT >= 2500000 && totalAMT < 5000000)){
                    proChargeOfExcAdhoc      = 6500;
                }
            }
            else if(accList[0].Priority_Sector__c == TRUE && totalAMT < 500000){
                proChargeOfExcAdhoc = 0.00;
            }
            else if(accList[0].Priority_Sector__c == TRUE && (totalAMT >= 5000000 && totalAMT < 10000000)){
                proChargeOfExcAdhoc = 0.00;
            }
            else if(totalAMT >= 500000 && totalAMT < 1000000){
                proChargeOfExcAdhoc      = 6000;
            }
            else if(totalAMT >= 1000000 && totalAMT < 2000000){
                proChargeOfExcAdhoc      = 7000;
            }
            else if(totalAMT >= 2000000 && totalAMT < 5000000){
                proChargeOfExcAdhoc      = 10000;
            }
            else if(totalAMT >= 5000000 && totalAMT < 10000000){
                proChargeOfExcAdhoc      = 25000;
            }
            else if(totalAMT >= 5000000 && totalAMT < 10000000){
                proChargeOfExcAdhoc      = 25000;
            }
            else if(accList[0].Priority_Sector__c == FALSE && totalAMT > 10000000){
                proChargeOfExcAdhoc      = 40000;
            }
            return proChargeOfExcAdhoc;
        }
        
        return proChargeOfExcAdhoc;
    }
    
    @future
    public static void runBREAfterM21Future(String appId){
        if(appId !=null && appId !=''){
            runBREAfteANDCheckCollateral(appId);
        }
    } 
    public static Decimal legalFeeCalc(Decimal recLimit,genesis__Applications__c app,List<genesis__Application_Collateral__c> collList){
        Decimal limitValue = 0.0;
        Decimal leagalFee = 0.0;
        limitValue = recLimit * 0.0025;
        system.debug('Limit vaue:::'+limitValue);
        system.debug('collList.size()'+collList.size());
        if(limitValue < 1000) limitValue = 1000;
        else if(limitValue > 2500) limitValue = 2500;
        if(collList != null) leagalFee = limitValue * collList.size();
        if(leagalFee != 0) leagalFee += leagalFee * Decimal.valueOf(System.Label.Legal_Markup);
        RETURN leagalFee;
    }
    public static decimal valFeeCalc(Decimal recLimit,genesis__Applications__c app,List<genesis__Application_Collateral__c> collList){
        Decimal chargeValue = 0.0;
        Decimal valuationCharge = 0.0;
        Set<Id> collIdset                   = new Set<Id>();
        List<M21_A__c> m21_List             = new List<M21_A__c>();
        chargeValue = recLimit * 0.0025;
        if(chargeValue < 1000) chargeValue = 1000;
        else if(chargeValue > 10000) chargeValue = 10000;
        System.debug('test collList.size()'+collList.size());
        if(collList != null && collList.size() > 0){
            for(genesis__Application_Collateral__c coll : collList){
                collIdset.add(coll.genesis__Collateral__c);
            }
            if(collIdset.size() > 0) m21_List = [SELECT Id,Estimated_value_Rs__c FROM M21_A__c WHERE Collateral__c IN : collIdset];
        }
        for(M21_A__c m21 : m21_List){
            if((m21.Estimated_value_Rs__c) <= 20000000) valuationCharge += chargeValue;
            else valuationCharge += (chargeValue * 2);
        }
        if(valuationCharge != 0.0) valuationCharge += valuationCharge * Decimal.valueOf(System.Label.Valuation_Markup);
        RETURN valuationCharge;
    }
    public static Decimal cersaiFeeCalc(List<genesis__Application_Collateral__c> collList){
        Decimal cersaiCharge = 0.0;
        if(collList != null && collList.size() > 0) cersaiCharge = collList.size() * 100;
        if(cersaiCharge != 0.0) cersaiCharge += cersaiCharge * Decimal.valueOf(System.Label.Cersai_Markup);
        RETURN cersaiCharge;
    }
}