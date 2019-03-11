/*
    Button_Utility class For SME Products.
*/
global class Button_Utility {
    //method called from Application page on button click
    webService static void runBRE(String appId){
        try {
            genesis__Applications__c app;
            Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get('genesis__Applications__c' ).getDescribe().fields.getMap();

            String query = 'SELECT ';
            for(Schema.SObjectField s : accountFieldMap.values()){
                query = query + s.getDescribe().getName()+',';
            }
            query   = query + 'genesis__Account__r.Date_of_Incorporation__c,genesis__Account__r.CUSTSINCE__c,RecordType.DeveloperName,(SELECT Id,Existing_Limit__c,Limit_Amount__c,Balance_Outstandings__c,Amount_Yet_disbursed__c FROM Facilities__r) ';

            //query   = query.removeEnd(',');
            query   = query + ' FROM genesis__Applications__c WHERE Id =: appId';
            System.debug(query);
            app = Database.query(query);
            if(app.RecordType_Developer_Name__c !='SME_Renewal' && !app.BRE_Done__c){
                SME_BRE_Score_Calculator.runBRERule(app,true);
            }else if(app.RecordType_Developer_Name__c =='SME_Renewal'){
                SME_BRE_Score_Calculator.runBRERule(app,true);
            }
            if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE)
                Underwriting_CTRL_Helper.updateBreSpreadAfterBREForRenewal(appId);
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getStackTraceString());
        }

    }
    webService static void generateB1document(String appId,String collateralId){
        SME_Digio_Service_EAE.docGenAndSignDoc(appId,'',new List<Id>(),collateralId);
    }
    
    //method to run personCIBILBatch from Skuid Page
    webService static void runPersonCIBILBatch(String appId){
        if(appId != null){
            Database.executeBatch(new Person_CIBIL_Call('ID = \''+appId+'\''),1);
        }
    }
    
    //method to run personCIBILBatch by passing Account ID from javaScript button in Classic view
    webservice static void runPersonCIBIL(string personAccId){
        List<Account> records = new List<Account>();
        if(personAccId != null){
            try{
                String accountQuery = 'Select id,FirstName,name,LastName,MiddleName,Gender__pc,PersonBirthdate,Aadhaar_Number__pc,Pan_Number__c,PersonMobilePhone,'+
                    +'PersonMailingStreet,PersonMailingCity,Full_Name__c,PersonMailingPostalCode,PersonMailingState from Account where Id ='+'\''+personAccId+'\'';
                List<Account> accRecords = Database.Query(accountQuery);   
                Person_CIBIL_Call pc = new Person_CIBIL_Call('');
                Database.BatchableContext BC;
                pc.execute(BC,accRecords);
            }catch(Exception e){
                system.debug('Exeption In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
            }
        }
    }
    
    //method for Run List Matching
    webService static void runListMatching(String appId){
        if(appId != null){
            Database.executeBatch(new Batch_JocataListMatching('ID = \''+appId+'\''),1);
            
        }
    }
    
    //method to Get List Matching Status
    webService static void getListMatchingStatus(String appId){
        if(appId != null){
            Database.executeBatch(new Batch_JocataListMatchStatus('ID = \''+appId+'\''),1);
        }
    }
    
    
    //method to get pre renewal checklist
    webService static void getPreRenewalChecklist(String appId){
        if(appId != null){
            try {
                SME_PRE_RENEWAL_CHECKING.createPrechecklist(new List<Id>{appId});
            }catch (Exception e) {
                system.debug('Exeption In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
            }
        }
    }
    
    webservice static void createTaskForBM(Id appId,String subject,String type){
        try {
            List<genesis__Applications__c> appInfo                 = new List<genesis__Applications__c>();
            appInfo                                        = SOQL_Util.getApplication(new Set<Id>{appId});
            Task taskRec = SanctionUnderwriting_Process.getTaskObj(appId, appInfo[0].OwnerId, subject, type);
            TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
            if (!Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appId, type))
                insert taskRec;
        } catch (Exception e) {
            system.debug('Exeption In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
        }
        
    }
    
    webService static string callFacilityDocGenBatch(string appId){
        try{
            Database.executeBatch(new Batch_GenerateFacility_Doc(appId),1);
            return 'Document Generation Initiated';
        }catch(Exception ex){
            return 'Document Generation Failed';
        }
        
    }
    
    //Document generation on MOD stage change
    webService static void generateMOD_LeagalDocuments(String appId,String facilityId){
        SME_Digio_Service_EAE.docGenAndSignDoc(appId,'',new List<Id>{facilityId},'');
    }
    //method called from Application page on button click
    webService static void runSanctionAuth(String appId){
        //Re run sanction Auth
        If(appId !=null){
            Database.executeBatch(new SanctionMatrix_Calc_Batch(appId));
        }
    }
    @future(callout=true)
    public static void generateDocs(Set<String> appIdsForFinancialUploads,Set<String> appIdsForModUploads){
        //Final sanction latters
        System.debug('appIdsForFinancialUploads----> ' + appIdsForFinancialUploads);
        System.debug('%%%%' + appIdsForFinancialUploads.size());
        System.debug('%-----' + appIdsForModUploads.size());
        
        if(appIdsForFinancialUploads.size() > 0){
            for(String appId : appIdsForFinancialUploads){
                System.debug('*****' + appId);
                System.debug(' Before docGenAndSignDoc');
                SME_Digio_Service_EAE.docGenAndSignDoc(appId,'MOD Needed',new List<Id>(),'');
            }
        }
        //Doc generation on MOD trigger
        /*if(appIdsForModUploads.size() > 0){
for(String facilityId : appIdsForModUploads){
SME_Digio_Service_EAE.docGenAndSignDoc(appId,'',new List<Id>{facilityId},'');
}
}*/
    }
    webService static string calSecurityCoverage(String appId){
        try{
            User userRec;
            genesis__Applications__c     appRec;
            String bmDesignation                                    ='';
            String facilityChildRTypeID                             = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
            List<Facility__c> bmTaskList                            = new List<Facility__c>();
            if(appId != null && appId != ''){
                appRec                                              = [SELECT Id,OwnerId,RecordType.DeveloperName from genesis__Applications__c where Id=:appId];
                if(appRec.OwnerId != null){
                    userRec = [Select Id,Designation__c FROM User where id=:appRec.OwnerId];
                    if(userRec.Designation__c != null){
                        bmDesignation                               = userRec.Designation__c;
                    }
                }
            }
            
            string query                                            = 'Select id,Product_Category__c,CL_Product__r.Facility_Category__c,Name,Application__c,Application__r.RecordType.DeveloperName,Application__r.ownerId,Application__r.Application_Stage__c,Limit_Amount__c,Existing_Limit__c,Type__c,Application__r.genesis__Account__c,CL_Product__c,Existing_Rate__c,Existing_Processing_Charge__c,Approved_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Recommended_Limit__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c,Existing_Spread__c,MCLR_Rate__c'+', (select id,genesis__Collateral__c from Facility_Security__r) from Facility__c where Application__c =:appId';
            List<Facility__c> facList                               = Database.query(query);
            SanctionMatrix_Calculation sanc                         = new SanctionMatrix_Calculation();
            //Map<String,Decimal>  securCoverage                    = sanc.calculateAuthority(facList,true,null,null);
            
            SanctionMatrix_Calculation.COVERAGE_MAP coveragemap     = new SanctionMatrix_Calculation.COVERAGE_MAP();
            coveragemap                                             = sanc.calculateAuthority(facList,true,null,null);
            
            
            genesis__Applications__c appln                          = new genesis__Applications__c();
            appln.Id                                                = appId;
            
            if(coveragemap.finalCoverage != null)
                appln.Security_coverage__c                    = coveragemap.finalCoverage;
            system.debug(appln);
            update appln;
            if(!facList.isEmpty()){
                for(Facility__c facRec:facList){
                    
                    Facility__c bmFacility                          = new Facility__c();
                    bmFacility.Facility__c                          = facRec.Id;
                    bmFacility.CL_Product__c                        = facRec.CL_Product__c;
                    bmFacility.EME_BM_User__c                       = TRUE ;
                    bmFacility.Higher_Authority_Order__c            = 1;
                    if(bmDesignation != '')
                        bmFacility.Role__c                          = bmDesignation;
                    bmFacility.RecordTypeId                         = facilityChildRTypeID;
                    bmTaskList.add(bmFacility);
                    
                }
            }
            Task taskForBM;
            if(appId != null && appRec.OwnerId != null){
                if(!Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appId,'EME BM Review'))
                    taskForBM                                           = SanctionUnderwriting_Process.getTaskObj(appId, appRec.OwnerId, 'BM Recommendation', 'EME BM Review');
            }
            
            if(!bmTaskList.isEmpty()){
                //if(appRec.RecordType.DeveloperName == 'SME_Renewal')
                insert bmTaskList;
            }
            if(taskForBM != null ){
                insert taskForBM;
            }
            return String.ValueOf(coveragemap.finalCoverage);
        }catch(Exception ex){            
            system.debug('Exception::'+ex.getMessage());
            return null;
        }
    }
    webservice static void closeExistingBMTask(string appId,String taskType) {
        System.debug('Call closeExisting BM Taask from Skuid Page');
        try{
            List<genesis__Applications__c> appInfo         = new List<genesis__Applications__c>();
            appInfo                                        = SOQL_Util.getApplication(new Set<Id>{appId});
            List<Task> getExistingTaskList= new List<Task>();
            List<User> coUserList= SOQL_Util.getBRCreditOfficer(appId);
            getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And OwnerId =: appInfo[0].OwnerId And Type=:taskType And Status = 'Not Started'];
            
            if(getExistingTaskList.size()==0 && coUserList.size()>0){
                getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And OwnerId =: coUserList[0].Id And Type=:taskType And Status = 'Not Started'];
            }

            if(! getExistingTaskList.isEmpty()){
                getExistingTaskList[0].Status = 'Completed';
            }
            System.debug('Update 206 task status'+ getExistingTaskList);
            update getExistingTaskList;
            System.debug('Updated task status'+ getExistingTaskList);
        }catch(Exception ex){
            System.debug('Exception'+ ex.getStackTraceString()+'LINE NUMBER '+ex.getLineNumber() + 'Message '+ ex.getMessage());
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateAppStage', ex);
        }
    }
    webservice static void adminStageReset(String appId,String appStage){
        System.debug('appStage---> ' + appStage);
        genesis__Applications__c app = new genesis__Applications__c();
        List<Attachment> attList = new List<Attachment>();
        List<Digio_Document_ID__c> docDetailList = new List<Digio_Document_ID__c>();
        app = [SELECT Id,Application_Stage__c,Next_Renewal_Date__c,Sanction_Date__c,RecordType.DeveloperName,Sanction_Class2_Check__c,Sanction_Doc_Generation_Check__c,Sanction_Letter_Name__c,Sanction_ESign_Check__c,All_Party_Signed__c,Sanction_ESign_Id__c,Document_Page_Count__c FROM genesis__Applications__c WHERE Id =: appId];
        System.debug('rectype--> ' + app.RecordType.DeveloperName);
        if(app.RecordType.DeveloperName == 'SME_Renewal'){
            app.Application_Stage__c = appStage;
            app.Next_Renewal_Date__c = null;
            app.Sanction_Date__c = null;
            app.Sanction_Class2_Check__c = false;
            app.Sanction_Doc_Generation_Check__c = false;
            app.Sanction_Letter_Name__c = null;
            app.Sanction_ESign_Check__c = false;
            app.All_Party_Signed__c = false;
            app.Sanction_ESign_Id__c = null;
            app.Document_Page_Count__c = null;
            
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE app;
            
            attList = [SELECT Id FROM Attachment WHERE ParentId =: appId];
            DELETE attList;
            
            docDetailList = [SELECt Id FROM Digio_Document_ID__c WHERE Application__c =: appId];
            DELETE docDetailList;
            
            docGeneration(appId);
        }

        // Newly Added 
        if(app.RecordType.DeveloperName == 'SME_Enhancement' || app.RecordType.DeveloperName == 'SME_AdHoc' || app.RecordType.DeveloperName == 'SME_Exceeding'){
            System.debug('appStage---> ' + appStage);
            app.Application_Stage__c = appStage;
            app.Next_Renewal_Date__c = null;
            app.Sanction_Date__c = null;
            app.Sanction_Class2_Check__c = false;
            app.Sanction_Doc_Generation_Check__c = false;
            app.Sanction_Letter_Name__c = null;
            app.Sanction_ESign_Check__c = false;
            app.All_Party_Signed__c = false;
            app.Sanction_ESign_Id__c = null;
            app.Document_Page_Count__c = null;
            
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE app;
            
            attList = [SELECT Id FROM Attachment WHERE ParentId =: appId AND Name LIKE '%SanctionLetter%'];
            DELETE attList;
            
            docDetailList = [SELECt Id FROM Digio_Document_ID__c WHERE Application__c =: appId];
            DELETE docDetailList;
            
            docGenerationForSME_EAE_Future(appId,'MOD Needed');
        }
    }
    @future(callout = true)
    public static void docGeneration(String appId){
        SME_Digio_Service_EAE.docGenAndSignDoc(appId,'',new List<Id>{},'');
    }

    @future(callout = true)
    webService static void docGenerationForSME_EAE_Future(String appId, String modString){
        SME_Digio_Service_EAE.docGenAndSignDoc(appId,modString,new List<Id>{},'');
    }
    webService static void docGenerationForSME_EAE(String appId, String modString){
        SME_Digio_Service_EAE.docGenAndSignDoc(appId,modString,new List<Id>{},'');
    }
    //Update existing margin on facilities
    webservice static void updateFacilityExistMargin(String facId){
        try {
            Facility__c facObject = [SELECT Id,Name,Type__c,Application__c,Product_Category__c,Active__c,CL_Product__c,NTB_Facility_Type__c,Approved_Margin__c,CL_Product__r.Existing_Margin__c,
                    CL_Product__r.Existing_Margin_Receivables__c,CL_Product__r.Existing_Margin_Stock_Manufacturing__c,CL_Product__r.Existing_Margin_Stock_Trading__c,
                    CL_Product__r.Processing_fee_fresh__c,CL_Product__r.Existing_Rate_Commission__c,CL_Product__r.Processing_fee_renwal__c,CL_Product__r.MCLR_Rate__c FROM Facility__c WHERE Id =: facId];
            //Decimal mclrRate =Underwriting_CTRL_Helper.getMCLRValuesFromMaster();
           // System.debug('MCLR:::'+mclrRate);
            List<genesis__Application_Collateral__c> listofAppcoll  = [select id,Facility__c,Facility__r.Product_Category__c,Security_Type__c from genesis__Application_Collateral__c where Facility__c =:facId];

            if(facObject !=null && facObject.CL_Product__c != null){


                /*if(psaObj.Margin__c !=null && psaObj.Margin__c !=''){
                    facObject.Approved_Margin__c = Decimal.valueOf(psaObj.Margin__c);
                } */
                if(facObject.Type__c !='Funded'){
                    facObject.BRE_Spread__c = 0.0;
                    facObject.BRE_Rate__c = facObject.CL_Product__r.Existing_Rate_Commission__c;
                }
                if(facObject.CL_Product__r.Existing_Margin__c != null){
                    facObject.BRE_Margin__c = facObject.CL_Product__r.Existing_Margin__c;
                }
                /*if(mclrRate != null){
                    facObject.MCLR_Rate__c = mclrRate;
                }*/
                if(facObject.CL_Product__r.Existing_Margin_Receivables__c != null){
                    facObject.BRE_Margin_Receivables__c = facObject.CL_Product__r.Existing_Margin_Receivables__c;
                }
                if(facObject.CL_Product__r.Existing_Margin_Stock_Manufacturing__c != null){
                    facObject.BRE_Margin_Stock_Manufacturing__c = facObject.CL_Product__r.Existing_Margin_Stock_Manufacturing__c;
                }
                if(facObject.CL_Product__r.Existing_Margin_Stock_Trading__c !=null){
                    facObject.BRE_Margin_Stock_Trading__c = facObject.CL_Product__r.Existing_Margin_Stock_Trading__c;
                }
                if(facObject.NTB_Facility_Type__c !=null){
                    if(facObject.NTB_Facility_Type__c == 'Renewal'){
                        facObject.BRE_Processing_Charge__c    = facObject.CL_Product__r.Processing_fee_renwal__c != null ?  facObject.CL_Product__r.Processing_fee_renwal__c : null;
                    }else{
                        facObject.BRE_Processing_Charge__c    = facObject.CL_Product__r.Processing_fee_fresh__c != null ? facObject.CL_Product__r.Processing_fee_fresh__c : null;
                    }
                }
                update facObject;
                
            }
            // Application Collateral
            if(listofAppcoll !=null && !listofAppcoll.isEmpty()){
                for(genesis__Application_Collateral__c appCollObj : listofAppcoll){
                    if(appCollObj.Facility__r.Product_Category__c !=null && appCollObj.Facility__r.Product_Category__c !=''){
                        if(appCollObj.Facility__r.Product_Category__c == 'SOD'){
                            appCollObj.Security_Type__c =   'Primary Securities';
                        }else{
                            appCollObj.Security_Type__c =   'Collateral Securities';
                        }
                    }
                }
                update listofAppcoll;
            }
        } catch (Exception e) {
            System.debug('@@@@@@@@'+e.getMessage() + '##########' +e.getLineNumber() +'@@@@@@@@@@@@@'+e.getStackTraceString());
            HandleBusinessException.captureError('Button_Utility', 'updateFacilityExistMargin', e);
        }
    }
    
    webService static void setUpLimit(String appId){
        List<genesis__Applications__c> appList = [SELECT Id,RecordType.DeveloperName,CustomerID__c FROM genesis__Applications__c WHERE Id =: appId];
        if(appList.size() > 0){
            if(appList[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                SME_CBS_Handler.limitUpdation_ChargeColllection(new List<Id>{appList[0].Id});
            }
            if(appList[0].RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                SME_CBS_EAE.requestHandlerNewLoan(appList[0].Id,appList[0].CustomerID__c);
            }
            if(appList[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE || appList[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || appList[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
                SME_CBS_EAE.requestHandler(appList[0].Id);
            }
        }
    }
    
    @future(callout = true)
    webService static void runCBS_NewLoan_NTB(String appId,String cbsCustId){
        SME_CBS_EAE.requestHandlerNewLoan(appId,cbsCustId);
    }

    webservice static void uploadPerfiosDoc(String appId){
        SME_PerfiosCallout.ProcessPerfios(appId);
        //List<genesis__AppDocCatAttachmentJunction__c> AppDocJunList= [Select id,Document_Submitted__c,Dms_Uuid__c,F_Year__c,genesis__Application_Document_Category__r.Name,genesis__Application_Document_Category__c,genesis__Application_Document_Category__r.genesis__Application__c from genesis__AppDocCatAttachmentJunction__c where genesis__Application_Document_Category__r.genesis__Application__c=: appId AND F_Year__c != null];
        //system.debug(AppDocJunList);
    }

    webservice static void GenerateAllFinalDocumets(String appId){
        
        Set<String> collateralIdLst= new Set<String>();
        List<Id> facilityIdLst= new List<Id>();

        List<genesis__Applications__c>  appLst = [Select id,Type__c,Parent_Application__c,genesis__Disbursement_Date__c,genesis__Account__r.Constitution__c,genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.PersonMailingCountry,genesis__Account__r.BillingState,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingCountry,genesis__Account__r.BillingStreet,Branch_Code__c,genesis__Account__r.BillingCity,MOD_Date__c,Primary_Applicant__c,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,Sanctioned_Tenure__c,Branch_Name__c,Branch_City__c,Name,genesis__Account__r.Name,recordType.developerName,Application_Stage__c,Document_Page_Count__c,genesis__Account__c,Sanction_Doc_Generation_Check__c,Sanction_Class2_Check__c,Sanction_Letter_Name__c,Sanction_ESign_Check__c,EAE_Renewal_Date_in_days__c,Month_Of_Disbursal__c,Book_Debts_Age__c,MODTL_Required__c,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c,Security_Description__c,genesis__Account__r.Industry,San_Ref_Date__c,Sanction_Reference_Number__c,genesis__Total_Upfront_Payments__c,Day_Of_Disbursal__c,
               (Select Id,genesis__Application__c,genesis__Party_Type__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Account_Name__r.Age__c,genesis__Party_Account_Name__r.Father_Name__pc,genesis__Party_Account_Name__r.BillingStreet,genesis__Party_Account_Name__r.BillingCity,genesis__Party_Account_Name__r.BillingState,genesis__Party_Account_Name__r.BillingPostalCode,Relationship_to_Borrower__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.PersonMobilePhone,Identifier__c,Signer_page_no__c,llx__c,lly__c,urx__c,ury__c  
                FROM genesis__Application_Parties__r WHERE  genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND Signatories__c =true),
               (SELECT Id,Name,genesis__Collateral__c FROM Application_Collateral__r),
               (SELECT Id,NTB_Facility_Type__c,Name,Industry__c,Limit_Amount__c,Existing_Enhanced_Processing_Fee__c,Final_Enhanced_Processing_Fee__c,Recommended_Rate__c,Existing_Spread__c,Final_Spread__c,Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Limit__c,Existing_Margin_Stock_Trading__c,New_Limit_Amount__c,MCLR_Rate__c,Nature_of_Document__c,Date_of_Document__c,Recommended_Limit__c,CL_Product__c,Existing_Rate__c,Application__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,Recommended_Processing_Charge__c,Recommended_Days__c,Interest_Type__c,Type__c,Approved_Margin__c,CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,Margin_Stock_Trading__c,BRE_Limit__c,BRE_Rate__c,BRE_Spread__c,Variance__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Balance_Outstandings__c,Guarantee_Date__c,Account_Number__c FROM Facilities__r),
               (SELECT Application__c,Address_Location_of_Unit__c FROM Units_Visit__r WHERE Application__c =: appId LIMIT 1),
               (SELECT id,Tag_Name__c,Terms_and_Conditions__c FROM Audits__r WHERE RecordType.DeveloperName ='Underwriting_T_C' AND Application__c =: appId AND Type__c = 'Final Sanction')
               from genesis__Applications__c where Id =: appId];

        for(Facility__c faciLst: appLst[0].Facilities__r){
            facilityIdLst.add(faciLst.Id);
        }

        if(facilityIdLst.size()>0){ // A1,C7,C8,C9  Doc Generation
            try{
                SME_Digio_Service_EAE.docGenAndSignDoc(appId,'',facilityIdLst,''); 
                SME_Digio_Service_EAE.docGenAndSignDoc(appId,'MOD Needed',new List<Id>(),'');
            }
            catch(Exception e){
                System.debug(e.getMessage());
                System.debug(e.getStackTraceString());
            }
            
        }
    }

    webservice static void fnlAcceptedTaskCheck(String appId){
        if(appId !=null && appId !=''){
            List<Task> taskLst= [Select type,status from task where WhatId=: appId AND type In ('MOD Needed','Generate Documents','Complete takeover formalities') AND status !='Completed'];
            system.debug('taskLst===> '+taskLst);
            if(taskLst.size()== 0){
                genesis__Applications__c app= new genesis__Applications__c(Id= appId);
                app.Application_Stage__c= 'New loan- E-sign pending';
                update app;
                SOQL_Util.createTaskForBM(app.Id,'Approve Disbursement','Approve Disbursement');
                SME_Digio_Service_EAE.createCompleteDocTask(appId);
            }    
        }
    }
    webservice static void discontinuationApplication(String appId){
        if(appId !=null && appId !=''){
            System.debug('appId====> '+appId);
            List<genesis__Applications__c> listApplication  =   new List<genesis__Applications__c>();
            List<Task> taskCompleteList = new List<Task>();
            Account accObj  =   new Account();
            try{
                genesis__Applications__c app    = [select id,genesis__Account__c,Application_to_close__c,RecordType.DeveloperName,Type__c,Parent_Application__c from genesis__Applications__c where Id =: appId AND Active__c = true]; 
               system.debug('app@@=='+app);
                if(app !=null && app.RecordType.DeveloperName !='SME_Renewal'){
                    if(app.Application_to_close__c){
                        genesis__Applications__c appInactive = new genesis__Applications__c();
                        Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.SME_RECORD_TYPE_LABEL).getRecordTypeId();
                        //app.RecordTypeId   =  devRecordTypeId;
                        //app.Application_Stage__c = 'Application review -with financials';
                        app.Application_Stage__c = 'Discontinued Application';
                        app.Application_UI_Stage__c ='Submission';
                        //app.Type__c             = 'Final Sanction';
                        /*If(app.Parent_Application__c !=null){
                            appInactive = SME_BRE_Score_Calculator.getDueDatebyAppId(app.Parent_Application__c);
                            appInactive.Active__c   = false;
                            listApplication.add(appInactive);
                        }*/
                    }else{
                        if(app.Type__c !=null && (app.Type__c.contains('NTB') || app.Type__c.contains('ETB-CA')) && app.genesis__Account__c !=null){
                            accObj.id   =   app.genesis__Account__c;
                            accObj.Active__c    =   false;
                        }
                        app.Application_Stage__c    =   'Discontinued Application';  
                        //taskCompleteList = SOQL_Util.completeTask(app.Id);
                        taskCompleteList = SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
                    }
                    listApplication.add(app);
                    System.debug('listApplication=='+listApplication);
                }
                if(listApplication !=null && !listApplication.isEmpty()){
                    //ApplicationTriggerHandler.IsFirstRun = false;
                    update listApplication;
                    if(taskCompleteList.size() > 0){
                        TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
                        update taskCompleteList;
                    }
                }
                if(accObj.id !=null){
                    AccountTriggerHandler.isAccountTrigger = true;
                    Update accObj;
                }
            }catch(Exception ex){
                HandleBusinessException.captureError('Button_Utility', 'discontinuationApplication', ex);    
            }    
        }    
    }

    //check existing task of Application. Either it is completed or Not.
    webservice static Boolean checkExistingTask(String appId,String taskType){
        if(appId !=null && appId !=null && taskType !=null && taskType !=''){
            try{
                map<String,Task> mapOfTask = SOQL_Util.checkExixtingTaskForAnyStatus(appId);
                if(mapOfTask !=null && mapOfTask.size() > 0 && mapOfTask.containsKey(taskType)){
                    return true;    
                }    
            }catch(Exception ex){
                HandleBusinessException.captureError('Button_Utility', 'checkExistingTask', ex);    
            }
        }
        return false;
    }

    //Refresh Liabilities API Data.
    @future(callout = true)
    webservice static void getLiabilitiesAPIData(String appId){
        if(appId !=null && appId !=''){
            try{
                WS_LiabilitiesAPI.getDataFromCBS(appId);    
            }catch(Exception ex){
                System.debug('Exception ::'+ex.getMessage() +'Line Number ::'+ex.getLineNumber());
            }
        }    
    }


    /*
        Name    : runListMatchingForPerson

        Purpose : This Method is used for running Person ListMatching manually from skuid(Under Admin Console section), 
                  and it will store the Jocata Transaction Id in Account level.

        Params  : Application Id
    */
    /*webService static void runListMatchingForPerson(String appId){
        Map<String,String> personCustIdTxIdMap = new Map<String,String>();
        List<Account>   listOfAccount          = new List<Account>();
        try{
            if(appId != null){
                genesis__Applications__c appObj = new genesis__Applications__c(Id = appId);
                //personCustIdTxIdMap = Batch_jocataListMatchingHelper.getJocataTocken(appObj,false,true);
            }
            if(personCustIdTxIdMap != null){
                for(String custId : personCustIdTxIdMap.keySet()){
                    Account acTemp = new Account();
                    acTemp.Id                            = custId;
                    acTemp.Jocata_TxnId__c               = personCustIdTxIdMap.get(custId); 
                    acTemp.List_Matching_Trigger_Time__c = System.now();
                    listOfAccount.add(acTemp);
                }
            }
            if(! listOfAccount.isEmpty()){
                AccountTriggerHandler.isAccountTrigger = true;
                UPDATE listOfAccount;
            }
        }catch(Exception ex){
            System.debug('Exception :: '+ex.getMessage() +'Line Number :: '+ex.getLineNumber());
        }
    }*/
    
    //method to Get List Matching Status for Person Account
    /*webService static void getListMatchingStatusForPerson(String appId){
        if(appId != null){
            Database.executeBatch(new Batch_JocataListMatchStatus('ID = \''+appId+'\''),1);
        }
    }*/
    // Method for Correct Application Button.
    webservice static void correctApplicationButton(String appId){
        if(appId !=null && appId !=''){
            try{
            	genesis__Applications__c appObj	=	new genesis__Applications__c();
                appObj.id = appId;
                appObj.Application_Stage__c = 'New loans - Application created';
                appObj.Application_UI_Stage__c = 'CompanyDetailsView';
                appObj.Application_Status__c = 'Application Created';
                appObj.BRE_Done__c  = false;
                
                ApplicationTriggerHandler.IsFirstRun = false;
				UPDATE appObj;
				
                List<Facility__c> listOfParentFacilities = [SELECT Id,Application__c,Active__c from Facility__c where Application__c =:appId];
                if(listOfParentFacilities !=null && !listOfParentFacilities.isEmpty()){
                	List<Facility__c> listOfChidFacilities	= [SELECT id,Facility__c from Facility__c where Facility__c IN:listOfParentFacilities]; 
                    if(listOfChidFacilities !=null && !listOfChidFacilities.isEmpty()){
                        DELETE listOfChidFacilities;
                    }
                }
                
                List<String> listOfTaskOnSubmitStage = new List<String>{'Qualitative Input Needed','Takeover Intelligence','Market Intelligence','Verified diff b/w App Exposure and TU Exposure as per Application','Financial Upload'};    
				List<Task> listOfTask = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId];
                if(listOfTask !=null && !listOfTask.isEmpty()){
                    for(Task taskObj : listOfTask){
                        if(taskObj.Type !=null && taskObj.Type =='M121 A Needed'){
                        	taskObj.Status = 'Not Started';    
                        }else if(taskObj.Type !=null && !listOfTaskOnSubmitStage.contains(taskObj.Type)){
                        	taskObj.Status = 'Closed';    
                        }
                    }
                    TaskFlow_Helper.TASK_TRIGGER_RUNNING = True;
                    UPDATE listOfTask;
                }
            }catch(Exception ex){
            	System.debug('Line No .'+ex.getLineNumber() + 'Message '+ ex.getMessage());    
            }
        }    
    }

}