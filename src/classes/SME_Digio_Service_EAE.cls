/*
* Name          : SME_Digio_Service_EAE
* Description   : Handle SME Digio Service(Doc Generation, Class-2 Sign and E-Sign)
* Author        : Dushyant
*****************************************************************************************/ 
global class SME_Digio_Service_EAE{
    public static List<clcommon__Collateral__c> collList = new List<clcommon__Collateral__c>();
    public static List<Attachment> attListToDlt = new List<Attachment>();
    public static List<Digio_Document_ID__c> digioDocDetToDelete = new List<Digio_Document_ID__c>();
    public static List<clcommon__Log__c> errorLogToInsert = new List<clcommon__Log__c>();
    public Static HTTPResponse legalDocGenRes;
    public static String renewalDocumentName = '';
    public static Boolean appWiseDocGenFlag = false;
    public static Boolean guaranterCheck = false; 
    public static genesis__Applications__c app = new genesis__Applications__c();
    public Static String B1_CollId = '';
    public Static Decimal stampCharge = 0;
    public Static String branchState = '';
    public Static String UID = System.Label.Legal_Desk_UID;
    
    public static WS_GenerateDocumentDigio.Response docGenAndSignDoc(String appId,String docNameEAE,List<Id> facilityIdList,String collId){
        WS_GenerateDocumentDigio.Response resp  = new WS_GenerateDocumentDigio.Response(); 
        resp.docResObj          = new WS_GenerateDocumentDigio.DOC_Response();
        String templateId = '';
        string accessToken = '';
        List<String> docEncodeFileList    = new List<String>();
        Integer pageCount       = 0;
        String docId = '';
        Map<String,String> docNameUUIDMap = new Map<String,String>();
        Map<String,Integer> docNamePgCountMap = new Map<String,Integer>();
        List<Facility__c> facilityList = new List<Facility__c>();
        List<String> docNameList = new List<String>();
        List<Stamping_Charges__mdt> stampChargeAmt = new List<Stamping_Charges__mdt>();
        List<Attachment> attList = new List<Attachment>();
        List<String> attNameList;
        
        app = [Select id,CreatedDate,Processing_Charges__c,OwnerId,Type__c,Parent_Application__c,genesis__Disbursement_Date__c,genesis__Account__r.Constitution__c,genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.PersonMailingCountry,genesis__Account__r.BillingState,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingCountry,genesis__Account__r.BillingStreet,Branch_Code__c,genesis__Account__r.BillingCity,MOD_Date__c,Primary_Applicant__c,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,Sanctioned_Tenure__c,Branch_Name__c,Branch_City__c,Name,genesis__Account__r.Name,recordType.developerName,Application_Stage__c,Document_Page_Count__c,genesis__Account__c,Sanction_Doc_Generation_Check__c,Sanction_Class2_Check__c,Sanction_Letter_Name__c,Sanction_ESign_Check__c,EAE_Renewal_Date_in_days__c,Month_Of_Disbursal__c,Book_Debts_Age__c,MODTL_Required__c,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c,Security_Description__c,genesis__Account__r.Industry,San_Ref_Date__c,Sanction_Reference_Number__c,genesis__Total_Upfront_Payments__c,Day_Of_Disbursal__c,
               (Select Id,genesis__Application__c,genesis__Party_Type__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Account_Name__r.Age__c,genesis__Party_Account_Name__r.Father_Name__pc,genesis__Party_Account_Name__r.BillingStreet,genesis__Party_Account_Name__r.BillingCity,genesis__Party_Account_Name__r.BillingState,genesis__Party_Account_Name__r.BillingPostalCode,Relationship_to_Borrower__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.PersonMobilePhone,Identifier__c,Signer_page_no__c,llx__c,lly__c,urx__c,ury__c  
                FROM genesis__Application_Parties__r WHERE  genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND Signatories__c =true),
               (SELECT Id,Name,genesis__Collateral__c,genesis__Collateral__r.Name FROM Application_Collateral__r),
               (SELECT Id,NTB_Facility_Type__c,Name,Industry__c,Limit_Amount__c,Existing_Enhanced_Processing_Fee__c,Final_Enhanced_Processing_Fee__c,Recommended_Rate__c,Existing_Spread__c,Final_Spread__c,Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Limit__c,Existing_Margin_Stock_Trading__c,New_Limit_Amount__c,MCLR_Rate__c,Nature_of_Document__c,Date_of_Document__c,Recommended_Limit__c,CL_Product__c,Existing_Rate__c,Application__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,Recommended_Processing_Charge__c,Recommended_Days__c,Interest_Type__c,Type__c,Approved_Margin__c,CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,Margin_Stock_Trading__c,BRE_Limit__c,BRE_Rate__c,BRE_Spread__c,Variance__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Balance_Outstandings__c,Guarantee_Date__c,Account_Number__c FROM Facilities__r),
               (SELECT Application__c,Address_Location_of_Unit__c FROM Units_Visit__r WHERE Application__c =: appId LIMIT 1),
               (SELECT id,Tag_Name__c,Terms_and_Conditions__c FROM Audits__r WHERE RecordType.DeveloperName ='Underwriting_T_C' AND Application__c =: appId AND Type__c = 'Final Sanction')
               from genesis__Applications__c where Id =: appId];
        
        attList = [SELECT Id,Name FROM Attachment WHERE ParentId =: appId];
        attNameList = new List<String>();
        for(Attachment att : attList){
            attNameList.add(att.Name);
        }
        for(genesis__Application_Parties__c prtyObj : app.genesis__Application_Parties__r){
            if(prtyObj.Guarantor__c){
                guaranterCheck = true;
            }
        }
        if(facilityIdList.size() > 0){
            String A1_EAE = System.Label.A1_EAE;
            String C7_EAE = System.Label.C7_EAE;
            String C8_EAE = System.Label.C8_EAE;
            String C9_EAE = System.Label.C9_EAE;
            facilityList = [SELECT Id,NTB_Facility_Type__c,Name,Limit_Amount__c,Existing_Enhanced_Processing_Fee__c,Final_Enhanced_Processing_Fee__c,Recommended_Rate__c,Existing_Spread__c,Final_Spread__c,Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Limit__c,Existing_Margin_Stock_Trading__c,New_Limit_Amount__c,MCLR_Rate__c,Nature_of_Document__c,Date_of_Document__c,Recommended_Limit__c,CL_Product__c,Existing_Rate__c,Application__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,Recommended_Processing_Charge__c,Recommended_Days__c,Interest_Type__c,Type__c,Approved_Margin__c,CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,Margin_Stock_Trading__c,BRE_Limit__c,BRE_Rate__c,BRE_Spread__c,Variance__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Balance_Outstandings__c,Guarantee_Date__c,Account_Number__c FROM Facility__c WHERE Id IN :facilityIdList];
            
            if(app.recordType.DeveloperName == 'SME_NEW_Loan'){
                if(facilityList[0].NTB_Facility_Type__c == 'WC KVB' || facilityList[0].NTB_Facility_Type__c == 'Renewal'){
                    docNameList = new List<String>{A1_EAE,C7_EAE,C8_EAE,C9_EAE};
                }
                else if(facilityList[0].NTB_Facility_Type__c == 'WC Others' || facilityList[0].NTB_Facility_Type__c == 'New'){
                    docNameList = new List<String>{A1_EAE,C9_EAE};
                }
                else
                    docNameList = new List<String>();
            }
            else{
                docNameList = new List<String>{A1_EAE,C7_EAE,C8_EAE,C9_EAE};
            }
            if(facilityList.size() > 0){
                for(Facility__c facility : facilityList){
                    for(String docName : docNameList){
                        docGenAsynchronous(appId,'',facility.Id,'',docName);
                    }
                } 
            }
        }
        else if(collId != null && collId != ''){
            String collname = '';
            B1_CollId = collId;
            String B1_EAE = System.Label.B1_EAE;
            collList = [SELECT Id,Name FROM clcommon__Collateral__c WHERE Id =: collId];
            collname = '%'+collList[0].Name+'%';
            attListToDlt = [SELECT Id FROM Attachment WHERE ParentId =: appId AND Name LIKE :collname];
            digioDocDetToDelete = [SELECT Id FROM Digio_Document_ID__c WHERE Application__c =: appId AND NAME LIKE :collname];
            docNameUUIDMap.put(B1_EAE,'');
            docNamePgCountMap.put(B1_EAE,0);
            branchState     = [SELECT Id,CODCCBRN__c,State__c FROM Branch_Master__c WHERE CODCCBRN__c =: app.Branch_Code__c limit 1].state__c;
            if(branchState != NULL && branchState != ''){  // B1 Doc Legal Desk  //$$$$$$
                docGenAsynchronous(appId,'','', collId,B1_EAE);
            }
            else{
                system.debug('Document Generation Failed - Branch State Not Avvailable');
            }
        }
        else if(docNameEAE == 'MOD Needed'){
            String Exceeding_Final_Sanction         = System.Label.Exceeding_Final_Sanction;
            String GCFA_EAE = System.Label.GCFA_EAE;
            String GCFA_EAE_New_Loan = System.Label.GCFA_EAE_New_Loan;
            String GCFA_C1_EAE = System.Label.GCFA_C1_EAE;
            String Guarantor_Agreement_EAE = System.Label.Guarantor_Agreement_EAE;
            accessToken = WS_ApiGatewayAccToken.getAccTkn(); 
            branchState     = [SELECT Id,CODCCBRN__c,State__c FROM Branch_Master__c WHERE CODCCBRN__c =: app.Branch_Code__c limit 1].state__c;
            
            Map<String,String> recordTypeDocNameMap = new Map<String,String>();
            recordTypeDocNameMap.put(Constants.SME_APP_RECORD_TYPE_ENHANCEMENT,GCFA_EAE+','+GCFA_C1_EAE+','+Guarantor_Agreement_EAE);
            recordTypeDocNameMap.put(Constants.SME_NEW_LOAN_RECORD_TYPE,GCFA_EAE_New_Loan+','+GCFA_C1_EAE+','+Guarantor_Agreement_EAE);
            recordTypeDocNameMap.put(Constants.SME_APP_RECORD_TYPE_ADHOC,GCFA_EAE+','+GCFA_C1_EAE+','+Guarantor_Agreement_EAE);
            recordTypeDocNameMap.put(Constants.SME_APP_RECORD_TYPE_EXCEEDING,Exceeding_Final_Sanction);
            System.debug('Exceeding_Final_Sanction===> '+Exceeding_Final_Sanction);
            for(String docName : recordTypeDocNameMap.get(app.recordType.developerName).split(',')){
                if(!attNameList.contains(docName)){
                    System.debug('docName===> '+docName);
                    try{
                        if(docName == GCFA_EAE || docName == GCFA_EAE_New_Loan){//Loan Agreement
                            docGenAsynchronous(appId,docNameEAE,'','',docName);
                        }
                        else if(docName == Guarantor_Agreement_EAE){// Guarantor Agreement
                            if(guaranterCheck){
                                docGenAsynchronous(appId,docNameEAE,'','',docName);
                            }
                        }
                        else if(docName == GCFA_C1_EAE || docName == Exceeding_Final_Sanction){// Sanction Letter
                            System.debug('Before Sanction Letter Doc Gen calling');
                            docGenAsynchronous(appId,docNameEAE,'','',docName);
                        }
                    }
                    catch(Exception e){
                        System.debug(' Stack1 ' + e.getStackTraceString());
                    }
                }
            }
        }
        else{
            if(app.recordType.developerName == Constants.SME_APP_RECORD_TYPE && !app.Sanction_Doc_Generation_Check__c){
                docGenAsynchronous(appId,'','','','');
            }
        }
        System.debug('DocGeneration Completed');
        app.Sanction_Date__c              = Date.today();
        try{
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE app;
            prepareStructure(new Map<String,String>());
            resp.docResObj.LOS_APPID        = appId;
            if(docNameUUIDMap.values().size() > 0)
                resp.docResObj.docPDFContent    = docNameUUIDMap.values()[0];
            else
                resp.docResObj.docPDFContent = '';
            resp.status                     = Constants.WS_SUCCESS_STATUS;
            resp.statusCode                 = Constants.WS_SUCCESS_CODE;
        }
        catch(Exception e){
            System.debug(e.getStackTraceString());
        }
        RETURN resp;
    }
    public static Decimal stampChargeCalculation(genesis__Applications__c app,String stateName,String docName){
        stampCharge = 0;
        Decimal loanAmnt = 0;
        List<Stamping_Charges__mdt> stChargeMasterList = new List<Stamping_Charges__mdt>();
        stChargeMasterList  = [Select ID,MasterLabel,GCFA_V2__c,Declaration_Of_Title_Mortgage__c,Declaration_of_Original_Mortgage__c,
                               Create_Mortgage_Charges__c,Housing_Loan_Agreement__c,Agreement_of_Guarantee__c 
                               From Stamping_Charges__mdt Where MasterLabel =: stateName Limit 1]; 
        if(stChargeMasterList.size() > 0){
            String B1_EAE = System.Label.B1_EAE;
            String GCFA_EAE = System.Label.GCFA_EAE;
            String Guarantor_Agreement_EAE = System.Label.Guarantor_Agreement_EAE;
            String GCFA_EAE_New_Loan = System.Label.GCFA_EAE_New_Loan;
            if(docName == B1_EAE && stChargeMasterList[0].Declaration_Of_Title_Mortgage__c != null) stampCharge = stChargeMasterList[0].Declaration_Of_Title_Mortgage__c;
            if(docName == Guarantor_Agreement_EAE && stChargeMasterList[0].Agreement_of_Guarantee__c != null) stampCharge = stChargeMasterList[0].Agreement_of_Guarantee__c;
            if(docName == GCFA_EAE || docName == GCFA_EAE_New_Loan){
                if(stChargeMasterList[0].GCFA_V2__c != null){
                    stampCharge = stChargeMasterList[0].GCFA_V2__c;
                }
                else if(stateName == 'ANDHRA PRADESH'){
                    if(app.genesis__Account__r.Priority_Sector__c){
                        stampCharge = 1000;  
                    }else{
                        loanAmnt = app.Facilities__r[0].Limit_Amount__c;
                        Decimal stmpAmt = (loanAmnt * 0.5)/100;
                        if(stmpAmt < 200000){
                            stampCharge = stmpAmt;  
                        }else{
                            stampCharge = 200000;
                        }
                    }
                }else if(stateName == 'GUJARAT'){
                    loanAmnt = app.Facilities__r[0].Limit_Amount__c;
                    if(loanAmnt <= 100000000){
                        Decimal stmpAmt = (loanAmnt * 0.25)/100;
                        if(stmpAmt < 300000){
                            stampCharge = stmpAmt; 
                        }else{
                            stampCharge = 300000;
                        }
                    }else{
                        Decimal stmpAmt = (loanAmnt * 0.50)/100;
                        if(stmpAmt < 800000){
                            stampCharge = stmpAmt; 
                        }else{
                            stampCharge = 800000;
                        }
                    }
                }else if(stateName == 'KARNATAKA'){
                    loanAmnt = app.Facilities__r[0].Limit_Amount__c;
                    if(loanAmnt <= 1000000){
                        Decimal stmpAmt = (loanAmnt * 0.10)/100;
                        stampCharge = stmpAmt; 
                    }else{
                        Decimal stmpAmt = (loanAmnt * 0.20)/100;
                        stampCharge = stmpAmt; 
                    }
                }else if(stateName == 'MAHARASHTRA'){
                    loanAmnt = app.Facilities__r[0].Limit_Amount__c;
                    if(loanAmnt <= 500000){
                        Decimal stmpAmt = (loanAmnt * 0.1)/100;
                        stampCharge = stmpAmt; 
                    }else{
                        Decimal stmpAmt = (loanAmnt * 0.2)/100;
                        stampCharge = stmpAmt; 
                    }   
                }else if(stateName == 'TELANGANA'){
                    if(app.genesis__Account__r.Priority_Sector__c){
                        stampCharge = 1000;
                    }else{
                        loanAmnt = app.Facilities__r[0].Limit_Amount__c;
                        if(loanAmnt < 200000){
                            Decimal stmpAmt = (loanAmnt * 0.50)/100;
                            stampCharge = stmpAmt;  
                        }
                    }
                }
            }
        }
        RETURN stampCharge;
    }
    public static void createCompleteDocTask(String appId){
        List<User> coUserList= SOQL_Util.getBRCreditOfficer(appId);
        if(coUserList.size()>0){
            SOQL_Util.createTaskForBRCreditOfficer(appId,coUserList[0].Id,'Complete documentation','Document Review');
        }else{ 
            SOQL_Util.createTaskForBM(appId,'Complete documentation','Document Review');
        }
    }
    @Future(callout=true)
    public static void docGenAsynchronous(String appId,String docNameEAE,String facId,String collId,String docName){
        Boolean MOD_stageFlag = false;
        Map<String,String> docNameUUIDMap = new Map<String,String>();
        Map<String,Integer> docNamePgCountMap = new Map<String,Integer>();
        genesis__Applications__c app            = new genesis__Applications__c();
        app = [Select id,CreatedDate,Processing_Charges__c,OwnerId,Type__c,Parent_Application__c,genesis__Disbursement_Date__c,genesis__Account__r.Constitution__c,genesis__Account__r.PersonMailingPostalCode,genesis__Account__r.PersonMailingCountry,genesis__Account__r.BillingState,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingCountry,genesis__Account__r.BillingStreet,Branch_Code__c,genesis__Account__r.BillingCity,MOD_Date__c,Primary_Applicant__c,genesis__Account__r.PersonMailingState,genesis__Account__r.PersonMailingStreet,genesis__Account__r.PersonMailingCity,Sanctioned_Tenure__c,Branch_Name__c,Branch_City__c,Name,genesis__Account__r.Name,recordType.developerName,Application_Stage__c,Document_Page_Count__c,genesis__Account__c,Sanction_Doc_Generation_Check__c,Sanction_Class2_Check__c,Sanction_Letter_Name__c,Sanction_ESign_Check__c,EAE_Renewal_Date_in_days__c,Month_Of_Disbursal__c,Book_Debts_Age__c,MODTL_Required__c,Sanction_Authority__c,genesis__Account__r.Priority_Sector__c,Security_Description__c,genesis__Account__r.Industry,San_Ref_Date__c,Sanction_Reference_Number__c,genesis__Total_Upfront_Payments__c,Day_Of_Disbursal__c,
               (Select Id,genesis__Application__c,genesis__Party_Type__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,genesis__Party_Account_Name__r.Name,Active__c,genesis__Party_Account_Name__r.Age__c,genesis__Party_Account_Name__r.Father_Name__pc,genesis__Party_Account_Name__r.BillingStreet,genesis__Party_Account_Name__r.BillingCity,genesis__Party_Account_Name__r.BillingState,genesis__Party_Account_Name__r.BillingPostalCode,Relationship_to_Borrower__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.PersonMobilePhone,Identifier__c,Signer_page_no__c,llx__c,lly__c,urx__c,ury__c  
                FROM genesis__Application_Parties__r WHERE  genesis__Party_Account_Name__r.PersonMobilePhone != null AND Active__c = true AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND Signatories__c =true),
               (SELECT Id,Name,genesis__Collateral__c,genesis__Collateral__r.Name FROM Application_Collateral__r),
               (SELECT Id,NTB_Facility_Type__c,Name,Industry__c,Limit_Amount__c,Existing_Enhanced_Processing_Fee__c,Final_Enhanced_Processing_Fee__c,Recommended_Rate__c,Existing_Spread__c,Final_Spread__c,Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Limit__c,Existing_Margin_Stock_Trading__c,New_Limit_Amount__c,MCLR_Rate__c,Nature_of_Document__c,Date_of_Document__c,Recommended_Limit__c,CL_Product__c,Existing_Rate__c,Application__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,Recommended_Processing_Charge__c,Recommended_Days__c,Interest_Type__c,Type__c,Approved_Margin__c,CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,Margin_Stock_Trading__c,BRE_Limit__c,BRE_Rate__c,BRE_Spread__c,Variance__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Balance_Outstandings__c,Guarantee_Date__c,Account_Number__c FROM Facilities__r),
               (SELECT Application__c,Address_Location_of_Unit__c FROM Units_Visit__r WHERE Application__c =: appId LIMIT 1),
               (SELECT id,Tag_Name__c,Terms_and_Conditions__c FROM Audits__r WHERE RecordType.DeveloperName ='Underwriting_T_C' AND Application__c =: appId AND Type__c = 'Final Sanction')
               from genesis__Applications__c where Id =: appId];

        Digioe_Docs_Service.app = app;
        System.debug('Digioe_Docs_Service.app::: ' + Digioe_Docs_Service.app);
        try{
            for(genesis__Application_Parties__c prtyObj : app.genesis__Application_Parties__r){
                if(prtyObj.Guarantor__c){
                    guaranterCheck = true;
                }
            }
            //Facilitywise Document Genereation.
            if(facId != null && facId != ''){
                List<Facility__c> facList = new List<Facility__c>(); 
                facList =  [SELECT Id,NTB_Facility_Type__c,Name,Limit_Amount__c,Existing_Enhanced_Processing_Fee__c,Final_Enhanced_Processing_Fee__c,Recommended_Rate__c,Existing_Spread__c,Final_Spread__c,Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Limit__c,Existing_Margin_Stock_Trading__c,New_Limit_Amount__c,MCLR_Rate__c,Nature_of_Document__c,Date_of_Document__c,Recommended_Limit__c,CL_Product__c,Existing_Rate__c,Application__c,CL_Product__r.clcommon__Product_Name__c,Loan_Purpose__c,Recommended_Processing_Charge__c,Recommended_Days__c,Interest_Type__c,Type__c,Approved_Margin__c,CL_Product__r.Facility_Category__c,Processing_Charge__c,Existing_Processing_Charge__c,Margin_Stock_Trading__c,BRE_Limit__c,BRE_Rate__c,BRE_Spread__c,Variance__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Balance_Outstandings__c,Guarantee_Date__c,Account_Number__c FROM Facility__c WHERE Id =:facId];
                DMS_Structure.DocumentUploadRes dmsResObj    = Digioe_Docs_Service.getEDocs(appId,docName,Utility.getDIGIOTemplateId(docName));
                if(dmsResObj != null){
                    System.debug('Inside Facility Wise Doc Generation');
                    docNameUUIDMap.put(docname+' '+facList[0].Name,dmsResObj.uuid);
                    docNamePgCountMap.put(docname+' '+facList[0].Name,Integer.valueOf(dmsResObj.totalPages));
                }
            }
            //Collateralwise Document Generation(B1).
            if(collId != null && collId != ''){
                MOD_stageFlag = true;
                String B1_EAE = System.Label.B1_EAE;
                B1_CollId = collId;
                stampCharge = Integer.valueOf(stampChargeCalculation(app,branchState,docName)); 
                branchState     = [SELECT Id,CODCCBRN__c,State__c FROM Branch_Master__c WHERE CODCCBRN__c =: app.Branch_Code__c limit 1].state__c;
                DMS_Structure.DocumentUploadRes dmsResObj    = Digioe_Docs_Service.getEDocs(appId,B1_EAE,Utility.getDIGIOTemplateId(B1_EAE));
                if(dmsResObj != null){
                    System.debug('Inside B1 Doc Generation');
                    docNameUUIDMap.put(B1_EAE,dmsResObj.uuid);
                    docNamePgCountMap.put(B1_EAE,Integer.valueOf(dmsResObj.totalPages));
                    Underwriting_CTRL_Helper.closeExistingBMTask(appId,'MOD Needed');
                }
                else{
                    MOD_stageFlag = false;
                }
            }
            //Applicationwise Document Generation.(Enhancement,Exceeding,AdHoc,New Loan)
            else if(docNameEAE == 'MOD Needed'){
                System.debug('Inside MOD Needed');
                appWiseDocGenFlag = true;
                stampCharge = Integer.valueOf(stampChargeCalculation(app,branchState,docName)); 
                branchState     = [SELECT Id,CODCCBRN__c,State__c FROM Branch_Master__c WHERE CODCCBRN__c =: app.Branch_Code__c limit 1].state__c;
                
                System.debug('TemplateId:::: ' + Utility.getDIGIOTemplateId(docName));
                System.debug('Request:::: ' + Digioe_Docs_Service.getEDocs(appId,docName,Utility.getDIGIOTemplateId(docName)));

                DMS_Structure.DocumentUploadRes dmsResObj    = Digioe_Docs_Service.getEDocs(appId,docName,Utility.getDIGIOTemplateId(docName));
                System.debug('dmsResObj:::: ' + dmsResObj);
                if(dmsResObj != null){
                    
                    System.debug('Inside App Wise Doc Generation');
                    System.debug('dmsResObj.uuid::::: ' + dmsResObj.uuid);
                    
                    docNameUUIDMap.put(docName,dmsResObj.uuid);
                    docNamePgCountMap.put(docName,Integer.valueOf(dmsResObj.totalPages));
                    if(app.RecordType.developerName == 'SME_Exceeding'){
                        SOQL_Util.closeDocGenTaskForBM(appId,'Generate Document');
                        app.Application_Stage__c = 'Exceeding- E-sign pending';
                        createCompleteDocTask(app.Id); 
                    }
                }
            }
            //Renewal Document Generation.
            else{
                if(app.recordType.developerName == Constants.SME_APP_RECORD_TYPE && !app.Sanction_Doc_Generation_Check__c){
                    if(app.Application_Stage__c == 'Interim Sanction' || app.Application_Stage__c == 'Application filling initiated'){
                        docNameEAE = Constants.PROV_SANCTION_TEMPLATE_SME;
                        app.Application_Stage__c              = 'Interim sanction offered';
                    }
                    else if(app.Application_Stage__c == 'Final Sanction' || app.Application_Stage__c == 'Application Filling - Final'){
                        docNameEAE = Constants.SANCTION_TEMPLATE_SME;
                        app.Application_Stage__c                  = 'Final Sanction Offered';
                    }
                    DigioTemplateService.SME_DOCUMENT_NAME = docNameEAE;
                    renewalDocumentName = docNameEAE;
                    DMS_Structure.DocumentUploadRes dmsResObj    = Digioe_Docs_Service.getEDocs(appId,DigioTemplateService.SME_DOCUMENT_NAME,Utility.getDIGIOTemplateId(docName));
                    if(dmsResObj != null){
                        System.debug('Inside Renewal Doc Generation');
                        docNameUUIDMap.put(docNameEAE,dmsResObj.uuid);
                        docNamePgCountMap.put(docNameEAE,Integer.valueOf(dmsResObj.totalpages));
                        app.Sanction_Doc_Generation_Check__c  = true;
                        app.Sanction_Letter_Name__c           = docNameEAE;
                        app.Document_Page_Count__c    = docNamePgCountMap.get(renewalDocumentName);
                        app.Next_Renewal_Date__c      = DigioTemplateService.NEXT_RENEW_DATE;
                    }
                }
            }
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE app;

            System.debug('Doc Name:::: ' + docNameUUIDMap.keySet());
            System.debug('UUID::::: ' + docNameUUIDMap.values());

            mapDocDetail(app,docNameUUIDMap);
            if(MOD_stageFlag) Underwriting_CTRL_Helper.closeExistingBMTask(app.Id,'MOD Needed');
        }
        catch(Exception e){
            clcommon__Log__c logObj = new clcommon__Log__c();
            logObj.Application__c       = appId;
            logObj.Document_Name__c     = docName;
            logObj.Type__c              = 'Document generation error';
            logObj.clcommon__Message__c = e.getMessage();
            errorLogToInsert.add(logObj);
        }
    }
    public static void mapDocDetail(genesis__Applications__c app,Map<String,String> docNameUUIDMap){
        Boolean allDocGenerated = false;
        Boolean MOD_TaskDone = false;
        Boolean MOD_TaskRequired = false;
        Boolean tackOverTsk= false;
        Task docTaskToClose;
        List<String> digioDocIdNameList = new List<String>();
        List<Task> taskList = new List<Task>();
        List<Digio_Document_ID__c> existingDigioDocIdList = new List<Digio_Document_ID__c>();
        List<Digio_Document_ID__c> B1_digioDocIdList = new List<Digio_Document_ID__c>();
        List<Digio_Document_ID__c> digioDocIdToDelete1 = new List<Digio_Document_ID__c>();
        //DELETE [SELECT Id FROM Digio_Document_ID__c WHERE Application__c =: app.Id AND (NOT Name LIKE 'B1_EAE%')];
        Set<String> B1DocNameSet = new Set<String>();
        existingDigioDocIdList = [SELECT Id,Name,DMS_UUID__c FROM Digio_Document_ID__c WHERE Application__c =: app.Id];
        for(Digio_Document_ID__c digioDocIdObj : existingDigioDocIdList){
            digioDocIdNameList.add(digioDocIdObj.Name);
            digioDocIdObj.DMS_UUID__c = docNameUUIDMap.get(digioDocIdObj.Name);
            if(digioDocIdObj.Name.contains('B1_EAE'))
                B1_digioDocIdList.add(digioDocIdObj);
        }
        for(Digio_Document_ID__c digioDocIdObj : B1_digioDocIdList){
            if(B1DocNameSet.contains(digioDocIdObj.Name))
                digioDocIdToDelete1.add(digioDocIdObj);
            else
                B1DocNameSet.add(digioDocIdObj.Name);
        }
        DELETE digioDocIdToDelete1;
        if(appWiseDocGenFlag && digioDocIdNameList.size() > 0){
            allDocGenerated = true;
            if(digioDocIdNameList.size() > 0){
                allDocGenerated = true;
                for(String docName : digioDocIdNameList){
                    if(!digioDocIdNameList.contains(docName))
                        allDocGenerated = false;
                }
            }
        }
        System.debug('allDocGenerated:::'+allDocGenerated);
        if(allDocGenerated){
            taskList = [SELECT Id,Type,Status FROM Task WHERE WhatId =: app.Id  And Type IN ('MOD Needed','Generate Documents','Complete takeover formalities')]; //AND OwnerId =: app.OwnerId
            for(Task taskObj : taskList){
                if(taskObj.Type == 'Generate Documents'){
                    docTaskToClose = taskObj;
                    docTaskToClose.Status = 'Completed';
                }
                if(taskObj.Type == 'MOD Needed'){
                    MOD_TaskRequired = true;
                    if(taskObj.Status == 'Completed'){
                        MOD_TaskDone = true;
                    }
                }
                if(taskObj.Type == 'Complete takeover formalities' && taskObj.Status == 'Completed'){
                    tackOverTsk= true;
                }
            }
        }
        if(docTaskToClose != null){
            UPDATE docTaskToClose;
            if(MOD_TaskDone || !MOD_TaskRequired){
                Boolean CompDocFlag= false;
                if(app.RecordType.developerName == 'SME_AdHoc'){
                    app.Application_Stage__c = 'Adhoc- E-sign pending';
                    CompDocFlag=true;
                }
                if(app.RecordType.developerName == 'SME_Enhancement'){
                    app.Application_Stage__c = 'Enhancement- E-sign pending';
                    CompDocFlag=true;
                }
                if(app.RecordType.developerName == 'SME_NEW_Loan'){
                    if(app.Type__c.contains('Takeover')){
                        if(tackOverTsk){
                            app.Application_Stage__c = 'New loan- E-sign pending';
                            CompDocFlag=true;
                        }
                    }else{
                        app.Application_Stage__c = 'New loan- E-sign pending';
                        CompDocFlag=true;
                    }
                }
                ApplicationTriggerHandler.IsFirstRun = false;
                UPDATE app;
                if(CompDocFlag){
                    createCompleteDocTask(app.Id);
                }
            }
        }
        UPDATE existingDigioDocIdList;
    }
    //Prepare all document staructure for all documents needs to be generated
    public static void prepareStructure(Map<String,String> docNameUUIDMap){
        List<Digio_Document_ID__c> digioDocIdListToInsert = new List<Digio_Document_ID__c>();
        if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE){
            Digio_Document_ID__c digioDocId = new Digio_Document_ID__c();
            digioDocId.Name = renewalDocumentName;
            digioDocId.Application__c = app.Id;
            /*if(docNameUUIDMap.get(renewalDocumentName) != null){
                digioDocId.DMS_UUID__c = docNameUUIDMap.get(digioDocId.Name);
            }*/
            digioDocId.eSign_Required__c = true;
            digioDocIdListToInsert.add(digioDocId);
        }
        else if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT){
            List<String> docNameList = new List<String>{System.Label.GCFA_C1_EAE,System.Label.GCFA_EAE};
                if(guaranterCheck)
                docNameList.add(System.Label.Guarantor_Agreement_EAE);
            if(app.Facilities__r.size()>0){
                for(Facility__c facObj : app.Facilities__r){
                    docNameList.add(System.Label.A1_EAE+' '+facObj.Name);
                    docNameList.add(System.Label.C7_EAE+' '+facObj.Name);
                    docNameList.add(System.Label.C8_EAE+' '+facObj.Name);
                    docNameList.add(System.Label.C9_EAE+' '+facObj.Name);
                }
            }
            if(app.Application_Collateral__r.size() > 0){
                for(genesis__Application_Collateral__c colObj : app.Application_Collateral__r){
                    docNameList.add(System.Label.B1_EAE+'_'+colObj.genesis__Collateral__r.Name);
                }
            }
            for(String docNameObj : docNameList){
                Digio_Document_ID__c digioDocId = new Digio_Document_ID__c();
                digioDocId.Name = docNameObj;
                digioDocId.Application__c = app.Id;
                /*if(docNameUUIDMap.get(digioDocId.Name) != null){
                    digioDocId.DMS_UUID__c = docNameUUIDMap.get(digioDocId.Name);
                }*/
                digioDocId.eSign_Required__c = true;
                digioDocIdListToInsert.add(digioDocId);
            }
        }
        else if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC){
            List<String> docName = new List<String>{System.Label.GCFA_C1_EAE,System.Label.GCFA_EAE};
                if(guaranterCheck)
                docName.add(System.Label.Guarantor_Agreement_EAE);
            if(app.Facilities__r.size()>0){
                for(Facility__c facObj : app.Facilities__r){
                    docName.add(System.Label.A1_EAE+' '+facObj.Name);
                    docName.add(System.Label.C7_EAE+' '+facObj.Name);
                    docName.add(System.Label.C8_EAE+' '+facObj.Name);
                    docName.add(System.Label.C9_EAE+' '+facObj.Name);
                }
            }
            if(app.Application_Collateral__r.size() > 0){
                for(genesis__Application_Collateral__c colObj : app.Application_Collateral__r){
                    docName.add(System.Label.B1_EAE+'_'+colObj.genesis__Collateral__r.Name);
                }
            }
            for(String docNameObj : docName){
                Digio_Document_ID__c digioDocId = new Digio_Document_ID__c();
                digioDocId.Name = docNameObj;
                digioDocId.Application__c = app.Id;
                /*if(docNameUUIDMap.get(digioDocId.Name) != null){
                    digioDocId.DMS_UUID__c = docNameUUIDMap.get(digioDocId.Name);
                }*/
                digioDocId.eSign_Required__c = true;
                digioDocIdListToInsert.add(digioDocId);
            }
        }
        else if(app.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
            List<String> docName = new List<String>{System.Label.GCFA_C1_EAE,System.Label.GCFA_EAE_New_Loan};
                if(guaranterCheck)
                docName.add(System.Label.Guarantor_Agreement_EAE);
            if(app.Facilities__r.size()>0){
                for(Facility__c facObj : app.Facilities__r){
                    if(facObj.NTB_Facility_Type__c == 'WC KVB' || facObj.NTB_Facility_Type__c == 'Renewal'){
                        docName.add(System.Label.A1_EAE+' '+facObj.Name);
                        docName.add(System.Label.C7_EAE+' '+facObj.Name);
                        docName.add(System.Label.C8_EAE+' '+facObj.Name);
                        docName.add(System.Label.C9_EAE+' '+facObj.Name);
                    }
                    else if(facObj.NTB_Facility_Type__c == 'WC Others' || facObj.NTB_Facility_Type__c == 'New'){
                        docName.add(System.Label.A1_EAE+' '+facObj.Name);
                        docName.add(System.Label.C9_EAE+' '+facObj.Name);
                    }
                }
            }
            if(app.Application_Collateral__r.size() > 0){
                for(genesis__Application_Collateral__c colObj : app.Application_Collateral__r){
                    docName.add(System.Label.B1_EAE+'_'+colObj.genesis__Collateral__r.Name);
                }
            }
            for(String docNameObj : docName){
                Digio_Document_ID__c digioDocId = new Digio_Document_ID__c();
                digioDocId.Name = docNameObj;
                digioDocId.Application__c = app.Id;
                /*if(docNameUUIDMap.get(digioDocId.Name) != null){
                    digioDocId.DMS_UUID__c = docNameUUIDMap.get(digioDocId.Name);
                }*/
                digioDocId.eSign_Required__c = true;
                digioDocIdListToInsert.add(digioDocId);
            }
        }
        else if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
            Digio_Document_ID__c digioDocId = new Digio_Document_ID__c();
            digioDocId.Name = System.Label.Exceeding_Final_Sanction;
            digioDocId.Application__c = app.Id;
            /*if(docNameUUIDMap.get(digioDocId.Name) != null){
                digioDocId.DMS_UUID__c = docNameUUIDMap.get(digioDocId.Name);
            }*/
            digioDocId.eSign_Required__c = true;
            digioDocIdListToInsert.add(digioDocId);
        }
        if(digioDocIdListToInsert.size()>0){
            insert digioDocIdListToInsert;
        }

    }
}