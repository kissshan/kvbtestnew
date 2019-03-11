/*
* Name     : WS_SMEHelper
* Company  : ET Marlabs
* Purpose  : This class is used as a helper for SME Webservice
* Author   : Amritesh
*/
public with sharing class SMELoan_Helper {

    public static List<String> documentCategoryType = new List<String>{'SME Financial Document'};
    //Newly Added
    public static Map<String,List<String>> YearToMissingFinancialYearMap = new Map<String,List<String>>();

        public static List<Customers.cls_customerDetails> getCustomerWrapper(List<Account> allAccounts) {
            
            Map<String, List<genesis__Applications__c>> appListByCustomer = new Map<String, List<genesis__Applications__c>>();
            
            List<Customers.cls_customerDetails> custList = new List<Customers.cls_customerDetails>();
            

            
            List<String> appIds = new List<String>();
            set<Id> appIdset= new set<Id>();
            map<Id,String> c1DocExistMap= new map<Id,String>();
            
            List<genesis__Applications__c> appRecords = new List<genesis__Applications__c>();
            
            for (Account accRec : allAccounts) {
                for (genesis__Applications__c apprec : accRec.genesis__Applications_account__r) {
                    System.debug('@@@' + apprec);
                    appIds.add(apprec.Id);
                    appIdset.add(apprec.Id);
                }
            }
            
            appRecords = SOQL_Util.getApplicationListForFetchCustomerList(appIds);
            c1DocExistMap=  SOQL_Util.C1ExistCheck(appIdset);
            
            for (genesis__Applications__c appRec : appRecords) {
                if (appListByCustomer.containsKey(appRec.genesis__Account__r.CBS_Customer_ID__c)) {
                    // error
                    List<genesis__Applications__c> ExistingappRecords = appListByCustomer.get(appRec.genesis__Account__r.CBS_Customer_ID__c);
                    ExistingappRecords.add(appRec);
                    appListByCustomer.put(appRec.genesis__Account__r.CBS_Customer_ID__c, ExistingappRecords);
                } else {
                    appListByCustomer.put(appRec.genesis__Account__r.CBS_Customer_ID__c, new List<genesis__Applications__c>{appRec});
                }
            }
            
            for (Account accRec : allAccounts) {
                
                Customers.cls_customerDetails cus = new Customers.cls_customerDetails();
                cus.LOS_SF_RECORD_ID = accRec.Id;
                cus.customerID = accRec.CBS_Customer_ID__c;
                cus.customerName = accRec.Name;
                
                cus.appln_info = new List<Customers.cls_ApplicationDetails>();
                
                List<genesis__Applications__c> allAppRecords = appListByCustomer.get(accRec.CBS_Customer_ID__c);
                if (allAppRecords != null)
                    for (genesis__Applications__c appRec : allAppRecords) {
                        Decimal loanAmount = 0.0;
                        Customers.cls_ApplicationDetails appWrap = new Customers.cls_ApplicationDetails();
                        appWrap.app_los_id = appRec.Id;
                        appWrap.app_name = appRec.Name;
                        appWrap.IS_C1_GENERATED= c1DocExistMap!=null && c1DocExistMap.containskey(appRec.Id) ? c1DocExistMap.get(appRec.Id) : 'false';
                        appWrap.app_stage = appRec.Application_Stage__c != null ? appRec.Application_Stage__c : '';
                        appWrap.app_ui_stage = appRec.Application_UI_Stage__c != null ? appRec.Application_UI_Stage__c : '';
                        
                        appWrap.app_type = appRec.RecordType.DeveloperName;
                        appWrap.Type     = appRec.Type__c !=null ? appRec.Type__c : ''; 
                        appWrap.app_due_date = appRec.Renewal_Due_Date__c != null ? appRec.Renewal_Due_Date__c.format() : '';
                        //appWrap.app_total_amount = appRec.genesis__Loan_Amount__c != null ? String.valueOf(appRec.genesis__Loan_Amount__c) : '';

                        appWrap.product_code = appRec.genesis__Product_Type__c != null ? String.valueOf(appRec.genesis__Product_Type__c) : '';
                        appWrap.ALL_FACILITIES = new List<Customers.cls_AppLication_Facilities>();
                        for (Facility__c facRec : appRec.Facilities__r) {
                            Customers.cls_AppLication_Facilities facWrap = new Customers.cls_AppLication_Facilities();
                            facWrap.facilityID = facRec.id;
                            facWrap.facilityLimitAmount =(String.valueOf(facRec.Limit_Amount__c)) != null ? String.valueOf(facRec.Limit_Amount__c) :'';
                            facWrap.facilityAccountNumber = facRec.Account_Number__c != null ? facRec.Account_Number__c : '';
                            facWrap.facilityProductCode = facRec.CL_Product__r.Product_Code__c != null ? facRec.CL_Product__r.Product_Code__c : '';
                            facWrap.facilityProductName = facRec.Product_Name__c != null ? facRec.Product_Name__c : '';
                            if(facRec.Existing_Limit__c != null) loanAmount += facRec.Existing_Limit__c;
                            //facWrap.facilityExistingLimit           = String.valueOf(facRec.Existing_Limit__c);
                            //facWrap
                            appWrap.ALL_FACILITIES.add(facWrap);
                        }
                        appWrap.app_total_amount = String.valueOf(loanAmount);
                        cus.appln_info.add(appWrap);
                    }
                
                custList.add(cus);
            }
            
            
            return custList;
        }


    public static Customer360view getCustomer(string appID, string custID) {
        try {
            Map<Id, genesis__Applications__c> applnInfo = SOQL_Util.getApplicationDetail(appID, custID);
            List<Facility__c> facilityList = new List<Facility__c>();
            if (appID != null) {
                facilityList = SOQL_Util.getFacilities(appID);
            }
            if (applnInfo != null && applnInfo.size() > 0) {
                return SMELoan_Helper.getCustomAppDetails(applnInfo, custID, appID, facilityList);
            } else {
                return null;
            }
        } catch (Exception e) {
            //HandleBusinessException.captureError('SMELoan_Helper', 'getCustomer', e);
            return null;
        }
    }
    
    /*
Get Application,Company,Key Person and Collateral Details coming from Middleware.
*/
    public static Customer360view getCustomAppDetails(Map<Id, genesis__Applications__c> applnInfo, string custID, String appID, List<Facility__c> facilityList) {
        //List<String> documentCategoryType = new List<String>{'SME Financial Document'};
        List<genesis__Application_Document_Category__c> catList = new List<genesis__Application_Document_Category__c>();
        List<genesis__Application_Document_Category__c> catListFinancial = new List<genesis__Application_Document_Category__c>();
        Set<String> allMissingYear                             = new Set<String>();
        Boolean TU_TRIGGER_COMPLETED_FOR_ALL_PA= true;
        List<genesis__Application_Parties__c> listOfParties  = SOQL_Util.getListOfPartiesByAppId(appID);
        Decimal existingNetworth     = 0.0;
        Boolean Expansion_Criteria= false;
        Customer360view cusdetail   = new Customer360view();

        cusdetail.ENHANCEMENT_MAX_LIMIT = String.valueOf(KVB_Company_Details__c.getOrgDefaults().ENHANCEMENT_MAX_LIMIT__c);
        if(listOfParties.size()>0){
            for(genesis__Application_Parties__c party: listOfParties){
                if(party.genesis__Party_Account_Name__r.CIBIL_Status__pc!= 'Complete'){
                    TU_TRIGGER_COMPLETED_FOR_ALL_PA= false;
                }
            }
        }
        

        if (applnInfo.get(appID).RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE) {
            List<String> docCatNameList         = new List<String>();
            Decimal TotalExistingLimit = 0.0;
            
            //for Overall Exposure
            AccountTriggerHandler.limitCalculation(applnInfo.get(appID));
            TotalExistingLimit = AccountTriggerHandler.exposureAmount;
            If(TotalExistingLimit > 0.0 || TotalExistingLimit > 0){
                If(TotalExistingLimit <= 5000000){ //
                    docCatNameList.add('SME ETB-NTB <50');
                    
                }else If(TotalExistingLimit > 5000000){
                    docCatNameList.add('SME ETB-NTB >50');                     
                }
            }
            If(applnInfo.get(appID).Type__c.contains('NTB')){
                If(applnInfo.get(appID).genesis__Account__r.Constitution__c == 'LLP'){                
                    docCatNameList.add('KYC -LLP');
                    system.debug('::test::'+docCatNameList);
                }
                else If(applnInfo.get(appID).genesis__Account__r.Constitution__c == 'Public Limited' || applnInfo.get(appID).genesis__Account__r.Constitution__c == 'Private Limited'){
                    docCatNameList.add('KYC -Company');
                }
                else If(applnInfo.get(appID).genesis__Account__r.Constitution__c == 'Partnership'){
                    docCatNameList.add('KYC -Partnership firm');
                }
                else If(applnInfo.get(appID).genesis__Account__r.Constitution__c == 'Trust'){
                    docCatNameList.add('KYC-TRUST');//
                }
                else If(applnInfo.get(appID).genesis__Account__r.Constitution__c == 'Proprietorship'){
                    docCatNameList.add('KYC -Self Prop');//KYC-HUF
                }
                else If(applnInfo.get(appID).genesis__Account__r.Constitution__c == 'HUF'){
                    docCatNameList.add('KYC-HUF');//
                }    
            }
            docCatNameList.add('TOL_TNW_Statement');
            catList   = DocumentFetch.checkDocumentCategory(appID,docCatNameList);

        }
        List<DocumentFetch.DocumentCategory> docCatList = new List<DocumentFetch.DocumentCategory>();
        List<Customer360view.cls_FINANCIAL_SECTION> fSectionList = new List<Customer360view.cls_FINANCIAL_SECTION>();
        List<Customer360view.cls_FINANCIAL_SECTION> cSectionList = new List<Customer360view.cls_FINANCIAL_SECTION>();
        List<Customer360view.cls_GROUP_CONCERN_DETAILS> gConcernList = new List<Customer360view.cls_GROUP_CONCERN_DETAILS>();
        //List<Customer360view.cls_NETWORTH_DETAILS> netWorthlistObj       = new List<Customer360view.cls_NETWORTH_DETAILS>();
        Set<Id> accIdList = new Set<Id>();
        for (genesis__Applications__c app : applnInfo.values()) {
            accIdList.add(app.genesis__Account__c);
        }
        List<Facility__c> loanFacilityList = new List<Facility__c>();
        loanFacilityList = SOQL_Util.getLoanFacilityList(accIdList);
        
        cusdetail.SANCTION_DOCUMENT_LIST = new List<Customer360view.cls_Sanction_Document>();
        
        if(Underwriting_CTRL_Helper.checkIfSignerDetailsNeeded(appID,Label.Exceeding_Final_Sanction) && applnInfo.get(appID).RecordType.DeveloperName =='SME_Exceeding'){
            cusdetail.SANCTION_DOCUMENT_LIST = getSanctionDocument(appID);
        }else if(applnInfo.get(appID).RecordType.DeveloperName !='SME_Exceeding'){
            cusdetail.SANCTION_DOCUMENT_LIST = getSanctionDocument(appID);
        }
        
        cusdetail.CUSTOMER_QUERY = new Customer360view.cls_QUERY_FOLLOWUP();
        cusdetail.CUSTOMER_QUERY.QUERY_FOLLOW_CATEGOREY = new DocumentFetch.DocumentCategory();
        cusdetail.CUSTOMER_QUERY.ALL_QUERIES = new List<Customer360view.cls_CUSTOMER_QUERY>();
        //Integer keyPersonCount;
        
        for (string app : applnInfo.keySet()) {
            cusdetail.LOS_APPLICATION_ID = applnInfo.get(app).id;
            cusdetail.LOS_APPLICATION_NAME = applnInfo.get(app).Name;
            cusdetail.REQUEST_DATE_TIME = string.valueOf(system.now());
            cusdetail.APPLICATION_UI_STAGE = Utility.getBlankStringIfNull(applnInfo.get(app).Application_UI_Stage__c);
            cusdetail.APPLICATION_STAGE = Utility.getBlankStringIfNull(applnInfo.get(app).Application_Stage__c);
            cusdetail.TYPE_OF_APPLICATION= Utility.getBlankStringIfNull(applnInfo.get(app).Type_of_Application__c);            
            //cusdetail.APP_SUB_STAGE = '';
            cusdetail.APP_SUB_STAGE = Utility.getBlankStringIfNull(applnInfo.get(app).Sub_Stage__c);
            cusdetail.LOS_CUSTOMER_SF_ID = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__c);
            //cusdetail.CUSTOMER_ID     = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__c);
            cusdetail.CUSTOMER_ID       =   Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.CBS_Customer_ID__c);
            cusdetail.LOS_BASE_DOMAIN_URL = System.Label.Site_Doc_URL;
            cusdetail.DIGIO_DOC_ID = Utility.getBlankStringIfNull(applnInfo.get(app).Sanction_ESign_Id__c);
            cusdetail.APPLICATION_TO_CLOSE = applnInfo.get(app).Application_to_close__c == true ? '1' : '0';
            cusdetail.PARENT_APPLICATION = Utility.getBlankStringIfNull(applnInfo.get(app).Parent_Application__c);
            cusdetail.APP_TYPE = Utility.getBlankStringIfNull(applnInfo.get(app).RecordType.DeveloperName);
            cusdetail.TYPE                  = Utility.getBlankStringIfNull(applnInfo.get(app).Type__c);
            cusdetail.BRANCH_CODE          = Utility.getBlankStringIfNull(applnInfo.get(app).Branch_Code__c);
            cusdetail.BRANCH_NAME           = Utility.getBlankStringIfNull(applnInfo.get(app).Branch_Name__c);
            if(applnInfo.get(app).Renewal_Due_Date__c !=null){
            	cusdetail.RENEWAL_DUE_DATE		=	String.valueOf(applnInfo.get(app).Renewal_Due_Date__c);    
            }
            //Liabilities API
            If(applnInfo.get(app).RecordType.DeveloperName == 'SME_NEW_Loan'){
                Boolean isLiabilities			= SMELoan_Helper_Fetch_Handler.checkLiabilitiesData(applnInfo.get(app).id);
                If(isLiabilities !=null && isLiabilities){
                    cusdetail.IS_LIABILITIES_DATA = 'Yes';    
                }else{
                    cusdetail.IS_LIABILITIES_DATA = 'No';
                }                
            }
            Integer  monthDate              = System.today().month();
            If(monthDate >= 4 && monthDate <= 9 ){
                cusdetail.IS_PROVISIONAL_FINANCIAL= 'Yes';
            }else{
                cusdetail.IS_PROVISIONAL_FINANCIAL= 'No';
            }
            cusdetail.NEW_TO_BUSINESS = applnInfo.get(app).New_to_Business__c == true ? '1' : '0';
            DocumentFetch.DocumentCategory tolTnwDocument        = new DocumentFetch.DocumentCategory();
            //SUMMARY
            cusdetail.SUMMARY_VIEW = new Customer360view.cls_SUMMARY();
            //GSTN_FINANCIAL
            cusdetail.GSTN_FINANCIAL                 =   new List<Customer360view.cls_GSTN_FINANCIAL>();
            List<GSTN_Info__c> listofGstn            =   SOQL_Util.getGSTN_InfoByAccId(applnInfo.get(app).Id);
            If(listofGstn !=null){
                for(GSTN_Info__c    gstnObj : listofGstn){
                    Customer360view.cls_GSTN_FINANCIAL gstnWrrp  = new Customer360view.cls_GSTN_FINANCIAL();
                    If(gstnObj.Months__c !=null){
                        If(gstnObj.Months__c == '12'){
                            gstnWrrp.ACTUAL_SALES = Utility.getBlankStringIfNull(String.valueOf(gstnObj.Total_Sales__c)); 
                            gstnWrrp.YTD_SALES    = '';
                            gstnWrrp.YTD_MONTH   = Utility.getMonthRange(Integer.valueOf(gstnObj.Months__c));
                        }else{
                            If(gstnObj.To_Date__c !=null){
                                Integer month   = Integer.valueOf(gstnObj.To_Date__c.substring(0,2));
                                if(month >= Integer.valueOf(gstnObj.Months__c) - 2){
                                    gstnWrrp.YTD_SALES = Utility.getBlankStringIfNull(String.valueOf(gstnObj.Total_Sales__c)); 
                                    gstnWrrp.ACTUAL_SALES = '';
                                    gstnWrrp.YTD_MONTH   =  Utility.getMonthRange(Integer.valueOf(gstnObj.Months__c) - 2);
                                }else{
                                    gstnWrrp.YTD_SALES      = '';
                                    gstnWrrp.ACTUAL_SALES   = '';
                                    gstnWrrp.YTD_MONTH      = '';
                                }
                            }
                        } 
                        cusdetail.GSTN_FINANCIAL.add(gstnWrrp);         
                    }
                }  
            }
            //cusdetail.SLIDER_CHANGES = new Customer360view.cls_Slider_Changes();
            //cusdetail.SLIDER_CHANGES.EMI_NMI=Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).EMINMI__c));
            // COMPANY_DETAILS
            cusdetail.COMPANY_DETAILS = new Customer360view.cls_COMPANY_DETAILS();

            if (applnInfo.get(appID).RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE) {
                If (applnInfo.get(appID).genesis__Account__r.Date_of_Incorporation__c != null) {
                    cusdetail.COMPANY_DETAILS.IS_NEW_TO_BUSINESS_TL = Utility.isNewToBuisness(applnInfo.get(appID).genesis__Account__r.Date_of_Incorporation__c);
                }
                if (applnInfo.get(appID).New_Loan_Inputs__r != null && applnInfo.get(appID).New_Loan_Inputs__r.size() > 0) {
                    Decimal futureCountOfVehicle = applnInfo.get(appID).New_Loan_Inputs__r[0].Future_Count_of_Vehicles__c;
                    cusdetail.COMPANY_DETAILS.IS_SRTO = futureCountOfVehicle <= Limit_Assessement__c.getValues('Limit Parameters').Number_of_Vehicles__c ? true : false;
                }
            }else{
                cusdetail.COMPANY_DETAILS.IS_NEW_TO_BUSINESS_TL = false;
                cusdetail.COMPANY_DETAILS.IS_SRTO               = false;
            }
            System.debug('Date of incorporation '+String.valueOf(applnInfo.get(app).genesis__Account__r.Date_of_Incorporation__c));
            cusdetail.COMPANY_DETAILS.DATE_OF_INCORPORATION = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Date_of_Incorporation__c));
            cusdetail.loanInfo = new Customer360view.cls_LOANDETAIL();
            
            cusdetail.COMPANY_DETAILS.RECONSTITUTED = applnInfo.get(app).genesis__Account__r.Firm_Company_was_Reconstituted__c == true ? '1' : '0';
            //cusdetail.SUMMARY_VIEW.CONSTITUTION_CHANGED = new Customer360view.cls_CONSTITUTION();
            If (applnInfo.get(app).genesis__Account__r.Previous_Constitution__c != null && cusdetail.COMPANY_DETAILS.RECONSTITUTED == '0' && !applnInfo.get(app).Critical_Change_done__c) {
                //cusdetail.SUMMARY_VIEW.CONSTITUTION_CHANGED = new Customer360view.cls_CONSTITUTION();
                //cusdetail.SUMMARY_VIEW.CONSTITUTION_CHANGED.NEW_VALUE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Constitution__c);
            }
            If (applnInfo.get(app).genesis__Account__r.Previous_Constitution__c != null && cusdetail.COMPANY_DETAILS.RECONSTITUTED == '1' && !applnInfo.get(app).Critical_Change_done__c) {
                cusdetail.SUMMARY_VIEW.CONSTITUTION_CHANGED = new Customer360view.cls_CONSTITUTION();
                cusdetail.SUMMARY_VIEW.CONSTITUTION_CHANGED.NEW_VALUE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Constitution__c);
                cusdetail.SUMMARY_VIEW.CONSTITUTION_CHANGED.PREVIOUS_VALUE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Previous_Constitution__c);
            }
            
            cusdetail.SUMMARY_VIEW.NEW_KEYPERSON = new Customer360view.cls_KEYPERSON();
            cusdetail.SUMMARY_VIEW.NEW_KEYPERSON.NAMES = '';
            
            cusdetail.SUMMARY_VIEW.DELETE_KEYPERSON = new Customer360view.cls_KEYPERSON();
            cusdetail.SUMMARY_VIEW.DELETE_KEYPERSON.NAMES = '';
            //Utility.getBlankStringIfNull(applnInfo.get(app).Deleted_Person__c);
            
            cusdetail.NEW_REQUEST                                                             = new Customer360view.cls_APP_REQUEST();
            cusdetail.NEW_REQUEST.REQ_REASON                                                  = '';
            cusdetail.NEW_REQUEST.REASON_FOR_APPLICATION                                      = '';
            cusdetail.NEW_REQUEST.LIMIT_PERIOD                                                = '';
            cusdetail.NEW_REQUEST.FACILITY_INFO                                               = new List<Customer360view.cls_FACILITIES>();
            
            cusdetail.SUMMARY_VIEW.SEC_20_CHANGES = new List<Customer360view.cls_SECTION_CHANGES>();
            cusdetail.SUMMARY_VIEW.REQUEST_SUMMARY = new Customer360view.cls_REQUEST_SUMMARY();
            cusdetail.SUMMARY_VIEW.REQUEST_SUMMARY.REASON_FOR_APPLICATION                     = Utility.getBlankStringIfNull(applnInfo.get(app).Reason_for_Application__c);
            cusdetail.SUMMARY_VIEW.REQUEST_SUMMARY.LIMIT_PERIOD                               = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).EAE_Renewal_Date_in_days__c));
            cusdetail.SUMMARY_VIEW.REQUEST_SUMMARY.FACILITY_INFO                              = new List<Customer360view.cls_FACILITIES>();
            
            //CUSTOMER_QUERY Details
            cusdetail.CUSTOMER_QUERY                            = new Customer360view.cls_QUERY_FOLLOWUP();
            cusdetail.CUSTOMER_QUERY.ALL_QUERIES                = new List<Customer360view.cls_CUSTOMER_QUERY>();
            //FINANCIALS_DETAILS
            cusdetail.FINANCIALS = new Customer360view.cls_FINANCIAL_STATEMENT();
            cusdetail.FINANCIALS.SALES = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.PURCHASE = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.DEBITOR_AEP = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.LAND_AND_BUILDING = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.PLANT_AND_MACHINERY = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.INTANGIBLE_OTHERS = new Customer360view.cls_FINANCIALS();
            System.debug('cusdetail.FINANCIALS' + cusdetail.FINANCIALS);
            Integer currentYear = Utility.getCurrentYear();
            String cyString = String.valueOf(currentYear);
            List<String> missingFinancialYear = new List<String>();
            String currFiscalYear = (currentYear - 1) + '-' + Integer.valueOf(cyString.subString(cyString.length() - 2, cyString.length()));
            String prevFiscalYear = (currentYear - 2) + '-' + Integer.valueOf(String.valueOf(currentYear - 1).subString(String.valueOf(currentYear - 1).length() - 2, String.valueOf(currentYear - 1).length()));
            String nextEstFiscalYear = currentYear + '-' + Integer.valueOf(String.valueOf(currentYear + 1).subString(String.valueOf(currentYear + 1).length() - 2, String.valueOf(currentYear + 1).length()));
            String nextProjFiscalYear = (currentYear + 1) + '-' + Integer.valueOf(String.valueOf(currentYear + 2).subString(String.valueOf(currentYear + 2).length() - 2, String.valueOf(currentYear + 2).length()));
            String n_1_FiscalYear = (currentYear - 3) + '-' + Integer.valueOf(String.valueOf(currentYear - 2).subString(String.valueOf(currentYear - 1).length() - 2, String.valueOf(currentYear - 1).length()));
            String n_2_FiscalYear = (currentYear - 4) + '-' + Integer.valueOf(String.valueOf(currentYear - 3).subString(String.valueOf(currentYear - 1).length() - 2, String.valueOf(currentYear - 1).length()));
            List<String> fyList = new List<String>{currFiscalYear, prevFiscalYear, nextEstFiscalYear, nextProjFiscalYear, n_1_FiscalYear, n_2_FiscalYear};
                
                List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();
                Map<String, Integer> m28CountForlastThreeYear = new Map<String, Integer>{prevFiscalYear => 0, n_1_FiscalYear => 0, currFiscalYear => 0};
                m68DataList = SOQL_Util.getM68Data(cusdetail.LOS_CUSTOMER_SF_ID, fyList);
            
            
            cusdetail.FINANCIALS.DEBITOR_AEP                                = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_PREV_FY                 =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_CURRENT_FY              =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_N_1_FY                 =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.DEBITOR_AEP.YTD_CURRENT_FY                 =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.DEBITOR_AEP.EST_NEXT_FY                    =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.DEBITOR_AEP.PROJ_NEXT2_FY                  =new Customer360view.cls_FY();
            
            cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP                       = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_PREV_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_CURRENT_FY     =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_N_1_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.YTD_CURRENT_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.EST_NEXT_FY           =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.PROJ_NEXT2_FY         =new Customer360view.cls_FY();//ACTUAL_n_1_FY
            
            cusdetail.FINANCIALS.LAND_AND_BUILDING                       = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.LAND_AND_BUILDING.ACTUAL_PREV_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.LAND_AND_BUILDING.ACTUAL_CURRENT_FY     =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.LAND_AND_BUILDING.YTD_CURRENT_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.LAND_AND_BUILDING.EST_NEXT_FY           =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.LAND_AND_BUILDING.PROJ_NEXT2_FY         =new Customer360view.cls_FY();
            
            cusdetail.FINANCIALS.PLANT_AND_MACHINERY                       = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_PREV_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_CURRENT_FY     =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_N_1_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.PLANT_AND_MACHINERY.YTD_CURRENT_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.PLANT_AND_MACHINERY.EST_NEXT_FY           =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.PLANT_AND_MACHINERY.PROJ_NEXT2_FY         =new Customer360view.cls_FY();
            
            cusdetail.FINANCIALS.INTANGIBLE_OTHERS                       = new Customer360view.cls_FINANCIALS();
            cusdetail.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_PREV_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_CURRENT_FY     =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_N_1_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.INTANGIBLE_OTHERS.YTD_CURRENT_FY        =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.INTANGIBLE_OTHERS.EST_NEXT_FY           =new Customer360view.cls_FY();
            cusdetail.FINANCIALS.INTANGIBLE_OTHERS.PROJ_NEXT2_FY         =new Customer360view.cls_FY();
            
            
            if (m68DataList != null && !m68DataList.isEmpty()) {
                
                /*cusdetail.FINANCIALS.DEBITOR_AEP                                = new Customer360view.cls_FINANCIALS();
                cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_PREV_FY                 =new Customer360view.cls_FY();
                cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_CURRENT_FY              =new Customer360view.cls_FY();
                cusdetail.FINANCIALS.DEBITOR_AEP.YTD_CURRENT_FY                 =new Customer360view.cls_FY();
                cusdetail.FINANCIALS.DEBITOR_AEP.EST_NEXT_FY                    =new Customer360view.cls_FY();
                cusdetail.FINANCIALS.DEBITOR_AEP.PROJ_NEXT2_FY                  =new Customer360view.cls_FY();

                cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP                       = new Customer360view.cls_FINANCIALS();
                cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_PREV_FY        =new Customer360view.cls_FY();
                cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_CURRENT_FY     =new Customer360view.cls_FY();
                cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.YTD_CURRENT_FY        =new Customer360view.cls_FY();
                cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.EST_NEXT_FY           =new Customer360view.cls_FY();
                cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.PROJ_NEXT2_FY         =new Customer360view.cls_FY();*/
                
                for (M68_Balance_Sheet_Analysis__c m68Data : m68DataList) {
                    
                    Customer360view.cls_FY fyDetailSales = new Customer360view.cls_FY();
                    Customer360view.cls_FY fyDetailPurchase = new Customer360view.cls_FY();
                    Customer360view.cls_FY fyDetailCreditors = new Customer360view.cls_FY();
                    Customer360view.cls_FY fyDetailDebtors = new Customer360view.cls_FY();
                    Customer360view.cls_FY fyLandANDBuilding = new Customer360view.cls_FY();
                    Customer360view.cls_FY fyPLANTANDMACHINERY = new Customer360view.cls_FY();
                    Customer360view.cls_FY fyINTANGIBLEOTHERS = new Customer360view.cls_FY();
                    
                    fyDetailSales.MONTH = '';
                    fyDetailSales.LOS_ID = m68Data.Id;
                    
                    
                    fyDetailPurchase.MONTH = '';
                    fyDetailPurchase.LOS_ID = m68Data.Id;
                    
                    fyDetailCreditors.MONTH = '';
                    fyDetailCreditors.LOS_ID = m68Data.Id;
                    
                    fyDetailDebtors.MONTH = '';
                    fyDetailDebtors.LOS_ID = m68Data.Id;
                    
                    fyLandANDBuilding.MONTH = '';
                    fyLandANDBuilding.LOS_ID = m68Data.Id;
                    
                    fyPLANTANDMACHINERY.MONTH = '';
                    fyPLANTANDMACHINERY.LOS_ID = m68Data.Id;
                    
                    fyINTANGIBLEOTHERS.MONTH = '';
                    fyINTANGIBLEOTHERS.LOS_ID = m68Data.Id;

                    if (m68Data.Financial_type__c == 'Actual' && m68Data.Fiscal_Year__c == currFiscalYear) {
                        fyDetailSales.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailPurchase.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailCreditors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailDebtors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyLandANDBuilding.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyPLANTANDMACHINERY.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyINTANGIBLEOTHERS.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailSales.FY_TOTAL = m68Data.Net_sales__c != null ? String.valueOf(m68Data.Net_sales__c) : '';
                        System.debug('fyDetailSales' + fyDetailSales);
                        cusdetail.FINANCIALS.SALES.ACTUAL_CURRENT_FY = fyDetailSales;
                        System.debug('cusdetail.FINANCIALS.SALES.ACTUAL_CURRENT_FY' + cusdetail.FINANCIALS.SALES.ACTUAL_CURRENT_FY);
                        fyDetailPurchase.FY_TOTAL = m68Data.Purchases__c != null ? String.valueOf(m68Data.Purchases__c) : '';
                        System.debug('fyDetailPurchase' + fyDetailPurchase);
                        cusdetail.FINANCIALS.PURCHASE.ACTUAL_CURRENT_FY = fyDetailPurchase;
                        fyDetailCreditors.FY_TOTAL = m68Data.Sundry_Creditors__c != null ? String.valueOf(m68Data.Sundry_Creditors__c) : '';
                        cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_CURRENT_FY = fyDetailCreditors;
                        fyDetailDebtors.FY_TOTAL = m68Data.Sundry_Debtors__c != null ? String.valueOf(m68Data.Sundry_Debtors__c) : '';
                        cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_CURRENT_FY = fyDetailDebtors;
                        fyLandANDBuilding.FY_TOTAL = m68Data.Land_Building__c != null ? String.valueOf(m68Data.Land_Building__c) : '';
                        cusdetail.FINANCIALS.LAND_AND_BUILDING.ACTUAL_CURRENT_FY = fyLandANDBuilding;
                        fyPLANTANDMACHINERY.FY_TOTAL = m68Data.Plant_Machinery__c != null ? String.valueOf(m68Data.Plant_Machinery__c) : '';
                        cusdetail.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_CURRENT_FY = fyPLANTANDMACHINERY;
                        fyINTANGIBLEOTHERS.FY_TOTAL = m68Data.Intangible_Others__c != null ? String.valueOf(m68Data.Intangible_Others__c) : '';
                        cusdetail.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_CURRENT_FY = fyINTANGIBLEOTHERS;
                        //m28CountForlastThreeYear.put(currFiscalYear,1);
                    } else if (m68Data.Financial_type__c == 'Actual' && m68Data.Fiscal_Year__c == prevFiscalYear) {
                        fyDetailSales.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailPurchase.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailCreditors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailDebtors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyLandANDBuilding.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyPLANTANDMACHINERY.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyINTANGIBLEOTHERS.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailSales.FY_TOTAL = m68Data.Net_sales__c != null ? String.valueOf(m68Data.Net_sales__c) : '';
                        cusdetail.FINANCIALS.SALES.ACTUAL_PREV_FY = fyDetailSales;
                        fyDetailPurchase.FY_TOTAL = m68Data.Purchases__c != null ? String.valueOf(m68Data.Purchases__c) : '';
                        cusdetail.FINANCIALS.PURCHASE.ACTUAL_PREV_FY = fyDetailPurchase;
                        fyDetailCreditors.FY_TOTAL = m68Data.Sundry_Creditors__c != null ? String.valueOf(m68Data.Sundry_Creditors__c) : '';
                        cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_PREV_FY = fyDetailCreditors;
                        fyDetailDebtors.FY_TOTAL = m68Data.Sundry_Debtors__c != null ? String.valueOf(m68Data.Sundry_Debtors__c) : '';
                        cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_PREV_FY = fyDetailDebtors;
                        fyLandANDBuilding.FY_TOTAL = m68Data.Land_Building__c != null ? String.valueOf(m68Data.Land_Building__c) : '';
                        cusdetail.FINANCIALS.LAND_AND_BUILDING.ACTUAL_CURRENT_FY = fyLandANDBuilding;
                        fyPLANTANDMACHINERY.FY_TOTAL = m68Data.Plant_Machinery__c != null ? String.valueOf(m68Data.Plant_Machinery__c) : '';
                        cusdetail.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_CURRENT_FY = fyPLANTANDMACHINERY;
                        fyINTANGIBLEOTHERS.FY_TOTAL = m68Data.Intangible_Others__c != null ? String.valueOf(m68Data.Intangible_Others__c) : '';
                        cusdetail.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_CURRENT_FY = fyINTANGIBLEOTHERS;

                        //m28CountForlastThreeYear.put(prevFiscalYear,1);
                    } else if (m68Data.Financial_type__c == 'Actual' && m68Data.Fiscal_Year__c == n_1_FiscalYear) {
                        fyDetailSales.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailPurchase.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailCreditors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailDebtors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyLandANDBuilding.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyPLANTANDMACHINERY.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyINTANGIBLEOTHERS.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Actual)';
                        fyDetailSales.FY_TOTAL = m68Data.Net_sales__c != null ? String.valueOf(m68Data.Net_sales__c) : '';
                        cusdetail.FINANCIALS.SALES.ACTUAL_N_1_FY = fyDetailSales;
                        fyDetailPurchase.FY_TOTAL = m68Data.Purchases__c != null ? String.valueOf(m68Data.Purchases__c) : '';
                        cusdetail.FINANCIALS.PURCHASE.ACTUAL_N_1_FY = fyDetailPurchase;
                        fyDetailCreditors.FY_TOTAL = m68Data.Sundry_Creditors__c != null ? String.valueOf(m68Data.Sundry_Creditors__c) : '';
                        cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_N_1_FY = fyDetailCreditors;
                        fyDetailDebtors.FY_TOTAL = m68Data.Sundry_Debtors__c != null ? String.valueOf(m68Data.Sundry_Debtors__c) : '';
                        cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_N_1_FY = fyDetailDebtors;
                        fyLandANDBuilding.FY_TOTAL = m68Data.Land_Building__c != null ? String.valueOf(m68Data.Land_Building__c) : '';
                        cusdetail.FINANCIALS.LAND_AND_BUILDING.ACTUAL_N_1_FY = fyLandANDBuilding;
                        fyPLANTANDMACHINERY.FY_TOTAL = m68Data.Plant_Machinery__c != null ? String.valueOf(m68Data.Plant_Machinery__c) : '';
                        cusdetail.FINANCIALS.PLANT_AND_MACHINERY.ACTUAL_N_1_FY = fyPLANTANDMACHINERY;
                        fyINTANGIBLEOTHERS.FY_TOTAL = m68Data.Intangible_Others__c != null ? String.valueOf(m68Data.Intangible_Others__c) : '';
                        cusdetail.FINANCIALS.INTANGIBLE_OTHERS.ACTUAL_N_1_FY = fyINTANGIBLEOTHERS;
                        //m28CountForlastThreeYear.put(n_1_FiscalYear,1);
                    } else if (m68Data.Financial_type__c == 'Actual' && m68Data.Fiscal_Year__c == n_2_FiscalYear) {
                        //m28CountForlastThreeYear.put(n_2_FiscalYear,1);
                    } else if (m68Data.Financial_type__c == 'YTD' && m68Data.Fiscal_Year__c == nextEstFiscalYear) {
                        fyDetailSales.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(YTD)';
                        fyDetailPurchase.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(YTD)';
                        fyDetailCreditors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(YTD)';
                        fyDetailDebtors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(YTD)';
                        fyLandANDBuilding.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(YTD)';
                        fyPLANTANDMACHINERY.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(YTD)';
                        fyINTANGIBLEOTHERS.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(YTD)';
                        fyLandANDBuilding.MONTH = m68Data.Month__c != null ? String.valueOf(m68Data.Month__c) : '';
                        fyPLANTANDMACHINERY.MONTH = m68Data.Month__c != null ? String.valueOf(m68Data.Month__c) : '';
                        fyINTANGIBLEOTHERS.MONTH = m68Data.Month__c != null ? String.valueOf(m68Data.Month__c) : '';
                        fyDetailSales.MONTH = m68Data.Month__c != null ? String.valueOf(m68Data.Month__c) : '';
                        fyDetailSales.FY_TOTAL = m68Data.Net_sales__c != null ? String.valueOf(m68Data.Net_sales__c) : '';
                        cusdetail.FINANCIALS.SALES.YTD_CURRENT_FY = fyDetailSales;
                        fyDetailPurchase.MONTH = m68Data.Month__c != null ? String.valueOf(m68Data.Month__c) : '';
                        fyDetailPurchase.FY_TOTAL = m68Data.Purchases__c != null ? String.valueOf(m68Data.Purchases__c) : '';
                        cusdetail.FINANCIALS.PURCHASE.YTD_CURRENT_FY = fyDetailPurchase;
                        fyDetailCreditors.FY_TOTAL = m68Data.Sundry_Creditors__c != null ? String.valueOf(m68Data.Sundry_Creditors__c) : '';
                        cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.YTD_CURRENT_FY = fyDetailCreditors;
                        fyDetailDebtors.FY_TOTAL = m68Data.Sundry_Debtors__c != null ? String.valueOf(m68Data.Sundry_Debtors__c) : '';
                        cusdetail.FINANCIALS.DEBITOR_AEP.YTD_CURRENT_FY = fyDetailDebtors;
                        fyLandANDBuilding.FY_TOTAL = m68Data.Land_Building__c != null ? String.valueOf(m68Data.Land_Building__c) : '';
                        cusdetail.FINANCIALS.LAND_AND_BUILDING.YTD_CURRENT_FY = fyLandANDBuilding;
                        fyPLANTANDMACHINERY.FY_TOTAL = m68Data.Plant_Machinery__c != null ? String.valueOf(m68Data.Plant_Machinery__c) : '';
                        cusdetail.FINANCIALS.PLANT_AND_MACHINERY.YTD_CURRENT_FY = fyPLANTANDMACHINERY;
                        fyINTANGIBLEOTHERS.FY_TOTAL = m68Data.Intangible_Others__c != null ? String.valueOf(m68Data.Intangible_Others__c) : '';
                        cusdetail.FINANCIALS.INTANGIBLE_OTHERS.YTD_CURRENT_FY = fyINTANGIBLEOTHERS;
                    } else if (m68Data.Financial_type__c == 'Estimated' && m68Data.Fiscal_Year__c == nextEstFiscalYear) {
                        fyDetailSales.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Estimated)';
                        fyDetailPurchase.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Estimated)';
                        fyDetailCreditors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Estimated)';
                        fyDetailDebtors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Estimated)';
                        fyLandANDBuilding.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Estimated)';
                        fyPLANTANDMACHINERY.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Estimated)';
                        fyINTANGIBLEOTHERS.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Estimated)';
                        fyDetailSales.FY_TOTAL = m68Data.Net_sales__c != null ? String.valueOf(m68Data.Net_sales__c) : '';
                        cusdetail.FINANCIALS.SALES.EST_NEXT_FY = fyDetailSales;
                        fyDetailPurchase.FY_TOTAL = m68Data.Purchases__c != null ? String.valueOf(m68Data.Purchases__c) : '';
                        cusdetail.FINANCIALS.PURCHASE.EST_NEXT_FY = fyDetailPurchase;
                        fyDetailCreditors.FY_TOTAL = m68Data.Sundry_Creditors__c != null ? String.valueOf(m68Data.Sundry_Creditors__c) : '';
                        cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.EST_NEXT_FY = fyDetailCreditors;
                        fyDetailDebtors.FY_TOTAL = m68Data.Sundry_Debtors__c != null ? String.valueOf(m68Data.Sundry_Debtors__c) : '';
                        if(fyDetailDebtors != null)
                            cusdetail.FINANCIALS.DEBITOR_AEP.EST_NEXT_FY = fyDetailDebtors;

                        fyLandANDBuilding.FY_TOTAL = m68Data.Land_Building__c != null ? String.valueOf(m68Data.Land_Building__c) : '';
                        cusdetail.FINANCIALS.LAND_AND_BUILDING.EST_NEXT_FY = fyLandANDBuilding;
                        fyPLANTANDMACHINERY.FY_TOTAL = m68Data.Plant_Machinery__c != null ? String.valueOf(m68Data.Plant_Machinery__c) : '';
                        cusdetail.FINANCIALS.PLANT_AND_MACHINERY.EST_NEXT_FY = fyPLANTANDMACHINERY;
                        fyINTANGIBLEOTHERS.FY_TOTAL = m68Data.Intangible_Others__c != null ? String.valueOf(m68Data.Intangible_Others__c) : '';
                        cusdetail.FINANCIALS.INTANGIBLE_OTHERS.EST_NEXT_FY = fyINTANGIBLEOTHERS;
                    }
                    if (m68Data.Financial_type__c == 'Projected' && m68Data.Fiscal_Year__c == nextProjFiscalYear) {
                        fyDetailSales.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Projected)';
                        fyDetailPurchase.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Projected)';
                        fyDetailCreditors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Projected)';
                        fyDetailDebtors.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Projected)';
                        fyLandANDBuilding.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Projected)';
                        fyPLANTANDMACHINERY.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Projected)';
                        fyINTANGIBLEOTHERS.FY_LABEL = 'FY' + m68Data.Fiscal_Year__c.right(2) + '(Projected)';
                        fyDetailSales.FY_TOTAL = m68Data.Net_sales__c != null ? String.valueOf(m68Data.Net_sales__c) : '';
                        cusdetail.FINANCIALS.SALES.PROJ_NEXT2_FY = fyDetailSales;
                        fyDetailPurchase.FY_TOTAL = m68Data.Purchases__c != null ? String.valueOf(m68Data.Purchases__c) : '';
                        cusdetail.FINANCIALS.PURCHASE.PROJ_NEXT2_FY = fyDetailPurchase;
                        fyDetailCreditors.FY_TOTAL = m68Data.Sundry_Creditors__c != null ? String.valueOf(m68Data.Sundry_Creditors__c) : '';
                        cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.PROJ_NEXT2_FY = fyDetailCreditors;
                        fyDetailDebtors.FY_TOTAL = m68Data.Sundry_Debtors__c != null ? String.valueOf(m68Data.Sundry_Debtors__c) : '';
                        cusdetail.FINANCIALS.DEBITOR_AEP.PROJ_NEXT2_FY = fyDetailDebtors;
                        fyLandANDBuilding.FY_TOTAL = m68Data.Land_Building__c != null ? String.valueOf(m68Data.Land_Building__c) : '';
                        cusdetail.FINANCIALS.LAND_AND_BUILDING.PROJ_NEXT2_FY = fyLandANDBuilding;
                        fyPLANTANDMACHINERY.FY_TOTAL = m68Data.Plant_Machinery__c != null ? String.valueOf(m68Data.Plant_Machinery__c) : '';
                        cusdetail.FINANCIALS.PLANT_AND_MACHINERY.PROJ_NEXT2_FY = fyPLANTANDMACHINERY;
                        fyINTANGIBLEOTHERS.FY_TOTAL = m68Data.Intangible_Others__c != null ? String.valueOf(m68Data.Intangible_Others__c) : '';
                        cusdetail.FINANCIALS.INTANGIBLE_OTHERS.PROJ_NEXT2_FY = fyINTANGIBLEOTHERS;
                    }

                }
            }
            Boolean isCurrentYearDataAvailable = false;

            System.debug('@@@@@'+allMissingYear);
            allMissingYear = new Set<String>();
            System.debug('cusdetail.LOS_CUSTOMER_SF_ID '+cusdetail.LOS_CUSTOMER_SF_ID);
            System.debug('date of incorporate'+applnInfo.get(app).genesis__Account__r.Date_of_Incorporation__c);
            //allMissingYear.addAll(YearDataConstant.getAllMissingYear(cusdetail.LOS_CUSTOMER_SF_ID,false));
            allMissingYear.addAll(YearDataConstant.sendMissingYearsFinancials(applnInfo.get(app).genesis__Account__r.id));
            System.debug('allMissingYear'+allMissingYear);
            System.debug('prevFiscalYear -> '+prevFiscalYear);
            System.debug('n_1_FiscalYear -> '+n_1_FiscalYear);
            System.debug('currFiscalYear -> '+currFiscalYear);

            cusdetail.MISSING_FINACIAL_YEARS = new List<Customer360view.cls_MISSING_FIN>();
            If (m68DataList != null) {
                System.debug('cusdetail.LOS_CUSTOMER_SF_ID:::'+cusdetail.LOS_CUSTOMER_SF_ID);
                for (M68_Balance_Sheet_Analysis__c m68Object : m68DataList) {
                            Customer360view.cls_MISSING_FIN missingFinObj = new Customer360view.cls_MISSING_FIN();
                            If (m68Object != null) {
                                If (m68Object.Financial_type__c == 'Actual' && m68Object.Fiscal_Year__c == currFiscalYear && m68Object.Data_Source__c != null) {
                                    missingFinObj.year = m68Object.Fiscal_Year__c;
                                    missingFinObj.status = 'Completed';
                                    missingFinObj.datasource = Utility.getBlankStringIfNull(m68Object.Data_Source__c);
                                    missingFinObj.CA_NAME = m68Object.CA_Name__c != null ? m68Object.CA_Name__c : '';
                                    missingFinObj.CA_NUMBER = m68Object.CA_Number__c != null ? m68Object.CA_Number__c : '';
                                    if(allMissingYear.contains(currFiscalYear))
                                        cusdetail.MISSING_FINACIAL_YEARS.add(missingFinObj);
                                    m28CountForlastThreeYear.put(currFiscalYear, 1);
                                    isCurrentYearDataAvailable = true;
                                } else If (m68Object.Financial_type__c == 'Actual' && m68Object.Fiscal_Year__c == prevFiscalYear && m68Object.Data_Source__c != null) {
                                    missingFinObj.year = m68Object.Fiscal_Year__c;
                                    missingFinObj.status = 'Completed';
                                    missingFinObj.datasource = Utility.getBlankStringIfNull(m68Object.Data_Source__c);
                                    missingFinObj.CA_NAME = m68Object.CA_Name__c != null ? m68Object.CA_Name__c : '';
                                    missingFinObj.CA_NUMBER = m68Object.CA_Number__c != null ? m68Object.CA_Number__c : '';
                                    if(allMissingYear.contains(prevFiscalYear))
                                        cusdetail.MISSING_FINACIAL_YEARS.add(missingFinObj);
                                    m28CountForlastThreeYear.put(prevFiscalYear, 1);
                                } else If (m68Object.Financial_type__c == 'Actual' && m68Object.Fiscal_Year__c == n_1_FiscalYear && m68Object.Data_Source__c != null) {
                                    missingFinObj.year = m68Object.Fiscal_Year__c;
                                    missingFinObj.status = 'Completed';
                                    missingFinObj.datasource = Utility.getBlankStringIfNull(m68Object.Data_Source__c);
                                    missingFinObj.CA_NAME = m68Object.CA_Name__c != null ? m68Object.CA_Name__c : '';
                                    missingFinObj.CA_NUMBER = m68Object.CA_Number__c != null ? m68Object.CA_Number__c : '';
                                    if(allMissingYear.contains(n_1_FiscalYear))
                                        cusdetail.MISSING_FINACIAL_YEARS.add(missingFinObj);
                                    m28CountForlastThreeYear.put(n_1_FiscalYear, 1);
                                }
                                
                            }
                        }
                If (m28CountForlastThreeYear.get(currFiscalYear) == 0) {
                    Customer360view.cls_MISSING_FIN missingFinObj = new Customer360view.cls_MISSING_FIN();
                    missingFinObj.year = currFiscalYear;
                    missingFinObj.status = 'NA';
                    missingFinObj.datasource = '';
                    missingFinObj.CA_NAME = '';
                    missingFinObj.CA_NUMBER = '';
                    if(allMissingYear.contains(currFiscalYear))
                    cusdetail.MISSING_FINACIAL_YEARS.add(missingFinObj);
                    //allMissingYear.add(currFiscalYear);
                }
                If (m28CountForlastThreeYear.get(prevFiscalYear) == 0) {
                    Customer360view.cls_MISSING_FIN missingFinObj = new Customer360view.cls_MISSING_FIN();
                    missingFinObj.year = prevFiscalYear;
                    missingFinObj.status = 'NA';
                    missingFinObj.datasource = '';
                    missingFinObj.CA_NAME = '';
                    missingFinObj.CA_NUMBER = '';
                    if(allMissingYear.contains(prevFiscalYear))
                    cusdetail.MISSING_FINACIAL_YEARS.add(missingFinObj);
                    //allMissingYear.add(prevFiscalYear);
                }
                If (m28CountForlastThreeYear.get(n_1_FiscalYear) == 0) {
                    Customer360view.cls_MISSING_FIN missingFinObj = new Customer360view.cls_MISSING_FIN();
                    missingFinObj.year = n_1_FiscalYear;
                    missingFinObj.status = 'NA';
                    missingFinObj.datasource = '';
                    missingFinObj.CA_NAME = '';
                    missingFinObj.CA_NUMBER = '';
                    if(allMissingYear.contains(n_1_FiscalYear))
                    cusdetail.MISSING_FINACIAL_YEARS.add(missingFinObj);
                    //allMissingYear.add(n_1_FiscalYear);
                }
            }

            //allMissingYear = (new Set<String>)YearDataConstant.getAllMissingYear(cusdetail.LOS_CUSTOMER_SF_ID,false);
            if (cusdetail.FINANCIALS.SALES.YTD_CURRENT_FY == null || cusdetail.FINANCIALS.PURCHASE.YTD_CURRENT_FY == null) {
                Customer360view.cls_FY fyDetail = new Customer360view.cls_FY();
                fyDetail.FY_LABEL = 'FY' + nextEstFiscalYear.right(2) + '(YTD)';
                fyDetail.MONTH = '';
                fyDetail.LOS_ID = '';
                fyDetail.FY_TOTAL = '';
                cusdetail.FINANCIALS.SALES.YTD_CURRENT_FY = fyDetail;
                cusdetail.FINANCIALS.PURCHASE.YTD_CURRENT_FY = fyDetail;
                cusdetail.FINANCIALS.DEBITOR_AEP.YTD_CURRENT_FY = fyDetail;
                cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.YTD_CURRENT_FY = fyDetail;
            }
            if (cusdetail.FINANCIALS.SALES.ACTUAL_CURRENT_FY == null) {
                Customer360view.cls_FY fyDetail = new Customer360view.cls_FY();
                fyDetail.FY_LABEL = 'FY' + currFiscalYear.right(2) + '(Actual)';
                fyDetail.MONTH = '';
                fyDetail.LOS_ID = '';
                fyDetail.FY_TOTAL = '';
                cusdetail.FINANCIALS.SALES.ACTUAL_CURRENT_FY = fyDetail;
                cusdetail.FINANCIALS.PURCHASE.ACTUAL_CURRENT_FY = fyDetail;
                //cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_CURRENT_FY = fyDetail;
                //cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_CURRENT_FY = fyDetail;
            }
            if (cusdetail.FINANCIALS.SALES.ACTUAL_PREV_FY == null) {
                Customer360view.cls_FY fyDetail = new Customer360view.cls_FY();
                fyDetail.FY_LABEL = 'FY' + prevFiscalYear.right(2) + '(Actual)';
                fyDetail.MONTH = '';
                fyDetail.LOS_ID = '';
                fyDetail.FY_TOTAL = '';
                cusdetail.FINANCIALS.SALES.ACTUAL_PREV_FY = fyDetail;
                cusdetail.FINANCIALS.PURCHASE.ACTUAL_PREV_FY = fyDetail;
                cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_PREV_FY = fyDetail;
                cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_PREV_FY = fyDetail;
            }
            if (cusdetail.FINANCIALS.SALES.ACTUAL_N_1_FY == null) {
                Customer360view.cls_FY fyDetail = new Customer360view.cls_FY();
                fyDetail.FY_LABEL = 'FY' + n_1_FiscalYear.right(2) + '(Actual)';
                fyDetail.MONTH = '';
                fyDetail.LOS_ID = '';
                fyDetail.FY_TOTAL = '';
                cusdetail.FINANCIALS.SALES.ACTUAL_N_1_FY = fyDetail;
                cusdetail.FINANCIALS.PURCHASE.ACTUAL_N_1_FY = fyDetail;
                cusdetail.FINANCIALS.DEBITOR_AEP.ACTUAL_N_1_FY = fyDetail;
                cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.ACTUAL_N_1_FY = fyDetail;
            }
            if (cusdetail.FINANCIALS.SALES.EST_NEXT_FY == null) {
                Customer360view.cls_FY fyDetail = new Customer360view.cls_FY();
                fyDetail.FY_LABEL = 'FY' + nextEstFiscalYear.right(2) + '(Estimated)';
                fyDetail.MONTH = '';
                fyDetail.LOS_ID = '';
                fyDetail.FY_TOTAL = '';
                cusdetail.FINANCIALS.SALES.EST_NEXT_FY = fyDetail;
                cusdetail.FINANCIALS.PURCHASE.EST_NEXT_FY = fyDetail;
                //cusdetail.FINANCIALS.DEBITOR_AEP.EST_NEXT_FY = fyDetail;
                //cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.EST_NEXT_FY = fyDetail;
            }
            if (cusdetail.FINANCIALS.SALES.PROJ_NEXT2_FY == null) {
                Customer360view.cls_FY fyDetail = new Customer360view.cls_FY();
                fyDetail.FY_LABEL = 'FY' + nextProjFiscalYear.right(2) + '(Projected)';
                fyDetail.MONTH = '';
                fyDetail.LOS_ID = '';
                fyDetail.FY_TOTAL = '';
                cusdetail.FINANCIALS.SALES.PROJ_NEXT2_FY = fyDetail;
                cusdetail.FINANCIALS.PURCHASE.PROJ_NEXT2_FY = fyDetail;
                //cusdetail.FINANCIALS.DEBITOR_AEP.PROJ_NEXT2_FY = fyDetail;
                //cusdetail.FINANCIALS.SUNDARY_CREDITOR_AEP.PROJ_NEXT2_FY = fyDetail;
            }
            //CUST_ENHANCEMENT
            cusdetail.CUST_ENHANCEMENT = new Customer360view.CustEnhancementDetails();
            cusdetail.CUST_ENHANCEMENT.REASON = applnInfo.get(app).Enhancement_reason__c != null ? String.valueOf(applnInfo.get(app).Enhancement_reason__c) : '';
            
            //FINANCIAL_DETAILS
            cusdetail.FINANCIAL_SECTION = new List<Customer360view.cls_FINANCIAL_SECTION>();
            for (genesis__AppDocCatAttachmentJunction__c appDocCatJunc : DocumentFetch.getFinanceDetails(appId)) {
                if (!appDocCatJunc.genesis__Application_Document_Category__r.Name.contains('Constitution Supporting Document')  && ! appDocCatJunc.genesis__Application_Document_Category__r.Name.contains('Constitution Deed Document')) {
                    fSectionList.add(new Customer360view.cls_FINANCIAL_SECTION(appDocCatJunc.genesis__Application_Document_Category__r.Name, appDocCatJunc.genesis__AttachmentId__c, appDocCatJunc.genesis__Application_Document_Category__r.App_Doc_Category_No__c));
                } else {
                    cSectionList.add(new Customer360view.cls_FINANCIAL_SECTION(appDocCatJunc.genesis__Application_Document_Category__r.Name, appDocCatJunc.genesis__AttachmentId__c, appDocCatJunc.genesis__Application_Document_Category__r.App_Doc_Category_No__c));
                }
            }
            if (!fSectionList.isEmpty()) {
                cusdetail.FINANCIAL_SECTION = fSectionList;
            }
            
            //DOCUMENT_DETAILS
            System.debug(catList.size()+'#####'+catList);
            String indivITRCategID  ='';
            DocumentFetch.DocumentCategory orderSDocument               = new DocumentFetch.DocumentCategory();
            DocumentFetch.DocumentCategory queryFollowupDocument        = new DocumentFetch.DocumentCategory();
            DocumentFetch.DocumentCategory enhancementDocument          = new DocumentFetch.DocumentCategory();
            List<DocumentFetch.DocumentCategory> contitutoinCatList     = new List<DocumentFetch.DocumentCategory>();
            List<genesis__Application_Document_Category__c> allOtherDocs = new List<genesis__Application_Document_Category__c>();
            List<DocumentFetch.DocumentCategory> masterList = new List<DocumentFetch.DocumentCategory>();
            System.debug('appID ==> '+appID+'|| documentCategoryType==> '+documentCategoryType+'|| allMissingYear ==>'+allMissingYear);
            if(applnInfo.get(app).RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                System.debug('#########');
                catListFinancial = DocumentFetch.checkDocumentCategory2(appID,documentCategoryType,allMissingYear);
            }
            catList.addAll(DocumentFetch.checkDocumentCategory2(appID,documentCategoryType,allMissingYear));
            /*else{
                catList.addAll(DocumentFetch.checkDocumentCategory2(appID,documentCategoryType,allMissingYear));
            }*/

            if(!catList.isEmpty()){
                for(genesis__Application_Document_Category__c dCat : catList){
                    if(! (dCat.Name).contains('Individual ITR') && !(dCat.Name).contains('Legal')){
                        if(! (dCat.Name).contains('Constitution Supporting Document') && ! (dCat.Name).contains('Constitution Deed Document')){
                            if((dCat.Name).contains('Query Followup') && applnInfo.get(appID).RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE){
                                queryFollowupDocument = new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                            }else if( (dCat.Name).contains('Orders On Hand')){
                                orderSDocument = new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                                if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0)
                                    orderSDocument.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';
                                DocumentFetch.DocumentCategory docFetchDOcObj   = new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                                docFetchDOcObj.PARENT_CAT_NAME = dCat.Parent_Category_Name__c != null ? dCat.Parent_Category_Name__c:'';
                                masterList.add(docFetchDOcObj);
                            }
                            else if( (dCat.Name).contains('Enhancement Documents')){
                                enhancementDocument = new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                                if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0)
                                    enhancementDocument.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';
                                
                            }else{
                                if( !(dCat.Name).contains('Audited') || !(dCat.Name).contains('Form 3CA/3CB/3CD')){
                                    DocumentFetch.DocumentCategory docFetchDOcObj   = new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                                    docFetchDOcObj.PARENT_CAT_NAME = dCat.Parent_Category_Name__c != null ? dCat.Parent_Category_Name__c:'';
                                    if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0)
                                        docFetchDOcObj.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';
                                    masterList.add(docFetchDOcObj);
                                }
                                //if(applnInfo.get(appID).RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE && (dCat.Name).contains('Legal'))
                                //allOtherDocs.add(dCat);
                            }
                        }else{
                            If(applnInfo.get(appID).Type__c != null && !applnInfo.get(appID).Type__c.contains('NTB')){
                                DocumentFetch.DocumentCategory  docFetchObj =   new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                                if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0)
                                    docFetchObj.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';
                                contitutoinCatList.add(docFetchObj);    
                            }
                        } 
                    }else if((dCat.Name).contains('Individual ITR')){
                        indivITRCategID = dCat.Id;
                    }
                }
                //for(genesis__Application_Document_Category__c dCat : catListFinancial){
                //    allOtherDocs.add(dCat);
                //}
                System.debug('@@@@@@@@@@@'+allOtherDocs);
                if(orderSDocument != null && applnInfo.get(appID).RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE){
                    cusdetail.ORDERS_ON_HAND = orderSDocument;
                }
                if(queryFollowupDocument!=null){
                    cusdetail.CUSTOMER_QUERY.QUERY_FOLLOW_CATEGOREY = new DocumentFetch.DocumentCategory();
                    cusdetail.CUSTOMER_QUERY.QUERY_FOLLOW_CATEGOREY =queryFollowupDocument;
                }
                if(enhancementDocument!=null){
                    cusdetail.ENHANCEMENT_DOCUMENTS = new DocumentFetch.DocumentCategory();
                    cusdetail.ENHANCEMENT_DOCUMENTS =enhancementDocument;
                }
                //if((applnInfo.get(app).RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE)){
                cusdetail.DOCUMENT_CATEGORY_LIST                = new DocumentFetch.DocCatRequest();
                cusdetail.DOCUMENT_CATEGORY_LIST.CATEGORY_LIST  = new List<DocumentFetch.DocumentCategory>();
                cusdetail.DOCUMENT_CATEGORY_LIST.CATEGORY_LIST  = docCatList;
                cusdetail.MASTER_DOC_CAT_LIST                   = new List<DocumentFetch.DocumentCategory>();
                cusdetail.financial_documents                   = new List<Customer360view.cls_newFinacialDocuments>();
                System.debug('cusdetail.MASTER_DOC_CAT_LIST'+cusdetail.MASTER_DOC_CAT_LIST);
                if(!catListFinancial.isEmpty() && applnInfo.get(appID).RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    System.debug('cusdetail.MASTER_DOC_CAT_LIST'+cusdetail.MASTER_DOC_CAT_LIST);

                    cusdetail.financial_documents               = getUpdatedFinanialDocWrapper(applnInfo,catListFinancial,allMissingYear,isCurrentYearDataAvailable);
                    for(genesis__Application_Document_Category__c dCat : catListFinancial){
                        System.debug('dCat'+dCat.Parent_Category_Name__c);
                        DocumentFetch.DocumentCategory  docFetchCatObj  =   new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                        docFetchCatObj.PARENT_CAT_NAME = dCat.Parent_Category_Name__c != null ? dCat.Parent_Category_Name__c:'';
                        System.debug('docFetchCatObj'+docFetchCatObj);
                        if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0){
                            docFetchCatObj.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';
                        }

                        masterList.add(docFetchCatObj);
                    }
                }
                else{
                    System.debug('cusdetail.MASTER_DOC_CAT_LIST'+cusdetail.MASTER_DOC_CAT_LIST);
                    cusdetail.financial_documents               = getUpdatedFinanialDocWrapper(applnInfo,catList,allMissingYear,isCurrentYearDataAvailable);
                    for(genesis__Application_Document_Category__c dCat : catList){
                        System.debug('dCat'+dCat);
                        DocumentFetch.DocumentCategory  docFetchCatObj  =   new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                        docFetchCatObj.PARENT_CAT_NAME = dCat.Parent_Category_Name__c != null ? dCat.Parent_Category_Name__c:'';
                        System.debug('docFetchCatObj'+docFetchCatObj);
                        if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0){
                            docFetchCatObj.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';

                        }

                        masterList.add(docFetchCatObj);
                    }
                }
                /*else if(applnInfo.get(app).RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                    catListFinancial = DocumentFetch.checkDocumentCategory2(appID,documentCategoryType,allMissingYear);
                }*/
                //if(!masterList.isEmpty() && applnInfo.get(app).RecordType.DeveloperName != Constants.SME_NEW_LOAN_RECORD_TYPE){
                    cusdetail.MASTER_DOC_CAT_LIST               = masterList;
                System.debug('cusdetail.MASTER_DOC_CAT_LIST'+cusdetail.MASTER_DOC_CAT_LIST);
                //}
                //}
                
            }
            if(!catList.isEmpty() && (applnInfo.get(app).RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)){
                Set<String> setOfDocumentCat                             =  new Set<String>{'KYC -LLP','KYC -Company','KYC -Partnership firm','KYC -Self Prop','KYC-TRUST','KYC-HUF'};
                List<DocumentFetch.DocumentCategory> newSourcingCatList  = new List<DocumentFetch.DocumentCategory>();
                
                for (genesis__Application_Document_Category__c dCat : catList) { //   
                    If(setOfDocumentCat.contains(dCat.Parent_Category_Name__c)){                        
                        DocumentFetch.DocumentCategory  docFetchCatObj  =   new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                        if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0)
                            docFetchCatObj.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';
                        
                        contitutoinCatList.add(docFetchCatObj);
                    }else if(dCat.Parent_Category_Name__c =='TOL_TNW_Statement'){
                        tolTnwDocument = new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                        if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0)
                            tolTnwDocument.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';
                    }
                    else{
                        DocumentFetch.DocumentCategory  docFetchCatObj  =   new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c), dCat.Name, dCat.Id);
                        if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0)
                            docFetchCatObj.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';
                        newSourcingCatList.add(docFetchCatObj);   
                    }
                    
                }
                if(!newSourcingCatList.isEmpty()){
                    cusdetail.DOCUMENT_CATEGORY_LIST = new DocumentFetch.DocCatRequest();
                    cusdetail.DOCUMENT_CATEGORY_LIST.CATEGORY_LIST = new List<DocumentFetch.DocumentCategory>();
                    //code commented by ajeet
                    cusdetail.DOCUMENT_CATEGORY_LIST.CATEGORY_LIST = newSourcingCatList;
                }
                
            }            
            //COMPANY_PRIMARY_DETAILS
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS = new Customer360view.cls_COMPANY_PRIMARY_DETAILS();
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.NAME_OF_THE_GROUP = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Group_Name__c);
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.NAME = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Name__c);
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.INDUSTRY_TYPE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Industry_Type__c);
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.GST_NUMBER = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.GST_Number__c);
            
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS = new Customer360view.cls_CONSTITUTION_DETAILS();
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS.CONSTITUTION = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Constitution__c);
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS.RECONSTITUTION_DATE = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Latest_Date_Of_Reconstitution__c));
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS.CONSTITUTION_DOCUMENT_CATEGORY = new DocumentFetch.DocCatRequest();
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS.CONSTITUTION_DOCUMENT_CATEGORY.CATEGORY_LIST = new List<DocumentFetch.DocumentCategory>();
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS.CONSTITUTION_DOCUMENT_CATEGORY.CATEGORY_LIST = contitutoinCatList;
            cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS.CONSTITUTION_EXISTING_DOC = cSectionList;
            

            cusdetail.COMPANY_DETAILS.GROUP_CONCERN_DETAILS = new List<Customer360view.cls_GROUP_CONCERN_DETAILS>();
            for (Group_Concern__c groupConcernObj : SOQL_Util.getGroupConcern(String.valueOf(applnInfo.get(app).genesis__Account__c))) {
                Customer360view.cls_GROUP_CONCERN_DETAILS groupConcernObject = new Customer360view.cls_GROUP_CONCERN_DETAILS();
                if (groupConcernObj != null && groupConcernObj.Group_2__c != null) {
                    //gConcernList.add(new Customer360view.cls_GROUP_CONCERN_DETAILS(groupConcernObj.Group_2__r.Pan_Number__c,groupConcernObj.Group_2__r.Name,groupConcernObj.Group_2__r.Bank_name__c,String.valueOf(groupConcernObj.Group_2__r.Limit__c),groupConcernObj.Type__c));
                    groupConcernObject.GROUP_CONCERN_ID = groupConcernObj.id;
                    groupConcernObject.PAN_NUMBER = Utility.getBlankStringIfNull(groupConcernObj.Group_2__r.Pan_Number__c);
                    groupConcernObject.FIRM_RELATED_NAME = Utility.getBlankStringIfNull(groupConcernObj.Group_2__r.Name);
                    groupConcernObject.BANK_NAME = Utility.getBlankStringIfNull(groupConcernObj.Group_2__r.Bank_name__c);
                    groupConcernObject.LIMIT_AMOUNT = Utility.getBlankStringIfNull(String.valueOf(groupConcernObj.Group_2__r.Limit__c));
                    groupConcernObject.TYPE = Utility.getBlankStringIfNull(groupConcernObj.Type__c);
                    gConcernList.add(groupConcernObject);
                } else if (groupConcernObj != null) {
                    groupConcernObject.GROUP_CONCERN_ID = groupConcernObj.id;
                    groupConcernObject.PAN_NUMBER = Utility.getBlankStringIfNull(groupConcernObj.Pan_card_Number__c);
                    groupConcernObject.BANK_NAME = Utility.getBlankStringIfNull(groupConcernObj.Bank_name__c);
                    groupConcernObject.LIMIT_AMOUNT = Utility.getBlankStringIfNull(String.valueOf(groupConcernObj.Limit_Amount__c));
                    groupConcernObject.TYPE = Utility.getBlankStringIfNull(groupConcernObj.Type__c);
                    gConcernList.add(groupConcernObject);
                }
                if (!gConcernList.isEmpty()) {
                    cusdetail.COMPANY_DETAILS.GROUP_CONCERN_DETAILS = gConcernList;
                }
            }
            //COMPANY_COMMUNICATION_DETAILS
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS = new Customer360view.cls_COMPANY_COMMUNICATION_DETAILS();
            
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.REGISTERED_OFFICE_ADDRESS = new Customer360view.cls_ADDRESS();
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.REGISTERED_OFFICE_ADDRESS.STREET = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.BillingStreet);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.REGISTERED_OFFICE_ADDRESS.CITY = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.BillingCity);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.REGISTERED_OFFICE_ADDRESS.STATE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.BillingState);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.REGISTERED_OFFICE_ADDRESS.COUNTRY = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.BillingCountry);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.REGISTERED_OFFICE_ADDRESS.PIN_CODE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.BillingPostalCode);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.CONTACT_PERSON_NAME = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Contact_Person_Name__c);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.CONTACT_NUMBER = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Cust_mobile_phone__c);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.EMAIL_ADDRESS = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Company_Email__c);
            
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.CORPORATE_OFFICE_ADDRESS = new Customer360view.cls_ADDRESS();
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.CORPORATE_OFFICE_ADDRESS.STREET = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.ShippingStreet);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.CORPORATE_OFFICE_ADDRESS.CITY = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.ShippingCity);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.CORPORATE_OFFICE_ADDRESS.STATE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.ShippingState);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.CORPORATE_OFFICE_ADDRESS.COUNTRY = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.ShippingCountry);
            cusdetail.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS.CORPORATE_OFFICE_ADDRESS.PIN_CODE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.ShippingPostalCode);
            
            // COMPANY_DETAILS
            cusdetail.COMPANY_DETAILS.COLLATERAL_DETAILS = new Customer360view.cls_COLLATERAL_DETAILS();
            cusdetail.COMPANY_DETAILS.CUSTOMER_ID = Utility.getBlankStringIfNull(applnInfo.get(app).CustomerID__c);
            cusdetail.COMPANY_DETAILS.LOAN_ACCOUNT_NO = Utility.getBlankStringIfNull(applnInfo.get(app).Loan_Account_Number__c);
            cusdetail.COMPANY_DETAILS.BORROWER_NAME = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Name);

                    cusdetail.COMPANY_DETAILS.BORROWER_LOS_ID = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Id);

            cusdetail.COMPANY_DETAILS.CONTACT_PERSON_DESIGNATION = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Contact_Person_Designation__c);
            cusdetail.COMPANY_DETAILS.LINE_OF_ACTIVITY = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Line_of_Activity__c);
            cusdetail.COMPANY_DETAILS.LINE_OF_ACTIVITY_CODE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Line_of_Activity_code__c);
            cusdetail.COMPANY_DETAILS.CIN_NUMBER = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.CIN_Number__c);
            cusdetail.COMPANY_DETAILS.PAN_NUMBER = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Pan_Number__c);
            cusdetail.COMPANY_DETAILS.IE_CODE_NUMBER = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.IE_Code__c);
            cusdetail.COMPANY_DETAILS.REASONS_FOR_GST_NOT_APPLICABLE = applnInfo.get(app).genesis__Account__r.Reasons_for_exemption_from_GST__c;
            cusdetail.COMPANY_DETAILS.TURNOVER = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Annual_TurnoverIncome__c));
            cusdetail.COMPANY_DETAILS.PRINCIPAL_NATURE_OF_BUSINESS = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Principal_nature_of_business__c);
            cusdetail.COMPANY_DETAILS.PRIORITY                      = applnInfo.get(app).genesis__Account__r.Priority_Sector__c ==true ?'1':'0';
            cusdetail.COMPANY_DETAILS.RELATED = '';
            cusdetail.COMPANY_DETAILS.PROCESSING_FEE    = Utility.getBlankStringIfNull(String.valueOf(KVB_Company_Details__c.getOrgDefaults().Processing_Fee__c));
            cusdetail.COMPANY_DETAILS.STATUS    = Utility.getBlankStringIfNull(applnInfo.get(app).PG_Status__c);
            cusdetail.COMPANY_DETAILS.UAM_NUMBER  = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.UAM_Number__c);
            cusdetail.COMPANY_DETAILS.MAJOR_ACTIVITY  = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Major_Activity__c);
            cusdetail.COMPANY_DETAILS.ENTERPRISE_TYPE = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Enterprise_Type__c);
            cusdetail.COMPANY_DETAILS.ACTIVITY_TYPE   = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Activity_Type__c);
            // cusdetail.COMPANY_DETAILS.NAME_OF_THE_FACILITY       = '';
            cusdetail.COMPANY_DETAILS.LOAN_AMOUNT = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Loan_Amount__c));
            /*cusdetail.COMPANY_DETAILS.APPROVED_LOAN_AMOUNT = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Approved_Loan_Amount__c));*/
            cusdetail.COMPANY_DETAILS.BALANCE_OUTSTANDING = '';
            cusdetail.COMPANY_DETAILS.OVER_DUE = '';

            /*Added for Term LOAN Chnages*/
            if(TU_TRIGGER_COMPLETED_FOR_ALL_PA!= false && applnInfo.get(app).CommercialPR_Stage__c== 'Completed'){
                cusdetail.COMPANY_DETAILS.TU_TRIGGER_COMPLETED= 'Yes';
            }else{
               cusdetail.COMPANY_DETAILS.TU_TRIGGER_COMPLETED= 'No'; 
            }
            
            cusdetail.COMPANY_DETAILS.PROFIT_AFTER_TAX= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Profit_after_tax__c));
            cusdetail.COMPANY_DETAILS.NET_FIXED_ASSET_LAND_AND_BUILDING= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Net_Fixed_Asset_Land_and_Building__c));
            cusdetail.COMPANY_DETAILS.NET_FIXED_ASSET_PLANT_AND_MACHINERY= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Net_Fixed_Asset_Plant_and_Machinery__c));
            cusdetail.COMPANY_DETAILS.PREVIOUS_YEAR_GROWTH_RATE= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Previous_Year_Growth_Rate__c));
            cusdetail.COMPANY_DETAILS.UDYOG_ADHAAR_NUMBER= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Udyog_Adhaar_Number__c));
            cusdetail.COMPANY_DETAILS.BUREAU_FEE= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Bureau_Fee__c));
            cusdetail.COMPANY_DETAILS.BUREAU_FEE_RESULT= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Bureau_Fee_Result__c));
            cusdetail.COMPANY_DETAILS.NET_BANKING_FLAG= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Net_Banking_Flag__c));
            cusdetail.COMPANY_DETAILS.PROCESSING_FEE_RESULT= Utility.getBlankStringIfNull(applnInfo.get(app).Processing_Fee_Result__c);
            cusdetail.COMPANY_DETAILS.LEGAL_CHARGES= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Legal_Charges__c));
            cusdetail.COMPANY_DETAILS.LEGAL_CHARGES_RESULT= Utility.getBlankStringIfNull(applnInfo.get(app).Legal_Charges_Result__c);
            cusdetail.COMPANY_DETAILS.UNIQUE_KEY= Utility.getBlankStringIfNull(applnInfo.get(app).UNIQUE_KEY__c);

            cusdetail.COMPANY_DETAILS.LEGAL_OPINION_WITH_GST= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Legal_Opinion_with_GST__c));
            cusdetail.COMPANY_DETAILS.VALUATION_CHARGES= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Valuation_Charges__c));
            cusdetail.COMPANY_DETAILS.VALUATION_CHARGES_WITH_GST= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Valuation_Charges_with_GST__c));
            cusdetail.COMPANY_DETAILS.BUREAU_FEE_GST= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Bureau_Fees_GST__c));
            cusdetail.COMPANY_DETAILS.TRANSACTION_DATE= String.valueOf(system.today());
            cusdetail.COMPANY_DETAILS.PRIMARY_BANK_NAME= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Primary_Bank_Name__c));
            cusdetail.COMPANY_DETAILS.PRIMARY_IFSC_CODE= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Primary_IFSC_Code__c));
            cusdetail.COMPANY_DETAILS.PRIMARY_BRANCH_NAME= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Primary_Branch_Name__c));
            cusdetail.COMPANY_DETAILS.PRIMARY_ACCOUNT_NUMBER= Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).genesis__Account__r.Primary_Account_Number__c));
            cusdetail.COMPANY_DETAILS.CREDIT_BUREAU_CHECK= applnInfo.get(app).Credit_Bureau_Check__c== true ? 'True': 'False';

            if(applnInfo.get(app).genesis__Account__r.Primary_IFSC_Code__c== null){
                cusdetail.COMPANY_DETAILS.ACCOUNT_BANK_MAP = TermLoan_SOQL_Util.bankAndAccountMap(app);
            }

            for(facility__c faci:facilityList){
                if(faci.Purpose_of_Loan__c!=null && Constants.expansion_CriteriaList.contains(faci.Purpose_of_Loan__c)){
                    Expansion_Criteria= true;
                    break;
                }
            }
            cusdetail.COMPANY_DETAILS.EXPANSION_CRITERIA= Expansion_Criteria== true ? 'True': 'False';
            AccountTriggerHandler.limitCalculation(applnInfo.get(app));
            /*cusdetail.COMPANY_DETAILS.OVERALL_EXPOSURE = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Overall_Exposure__c));*/
            //cusdetail.COMPANY_DETAILS.OVERALL_EXPOSURE = Utility.getBlankStringIfNull(String.valueOf(AccountTriggerHandler.exposureAmount));
            cusdetail.COMPANY_DETAILS.OVERALL_EXPOSURE = String.valueOf(LimitAssessmentHelper.getOverallExposure_TL(applnInfo.get(app).genesis__Account__c,applnInfo.get(app).Id,applnInfo.get(app).RecordType.DeveloperName));
            cusdetail.COMPANY_DETAILS.DOCUMENT_SECTION = new List<Customer360view.cls_DOCUMENT_SECTION>();
            cusdetail.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION = new Customer360view.cls_CURRENT_LOAN_APPLICATION();
            //for SME NEW Loan Facility Details.
            If(cusdetail.APP_TYPE == Constants.SME_NEW_LOAN_RECORD_TYPE){
                cusdetail.COMPANY_DETAILS.NEW_LOAN_FACILITY_DETAILS = new Customer360view.cls_NEW_LOAN_FACILITY_DETAILS();
                cusdetail.COMPANY_DETAILS.NEW_LOAN_FACILITY_DETAILS = SMELoan_Helper_Fetch_Handler.getNewLoanFacilityDetails(cusdetail.COMPANY_DETAILS.NEW_LOAN_FACILITY_DETAILS,applnInfo.get(app).genesis__Account__c,applnInfo.get(app).Id,applnInfo.get(app).Facilities__r);
                if(cusdetail.COMPANY_DETAILS.NEW_LOAN_FACILITY_DETAILS == null){
                    cusdetail.COMPANY_DETAILS.NEW_LOAN_FACILITY_DETAILS = new Customer360view.cls_NEW_LOAN_FACILITY_DETAILS();
                }
            }
            // REJECTED KEYPERSON
            cusdetail.COMPANY_DETAILS.REJECTED_KEY_PERSON       =   new List<Customer360view.cls_REJECTED_KEY_PERSON>();
           /////////////////////////////////
            Set<Id> setOfPartiesId = new Set<Id>();
            for(genesis__Application_Parties__c appPartiesObj : applnInfo.get(app).genesis__Application_Parties__r){
                if(appPartiesObj !=null && appPartiesObj.genesis__Party_Account_Name__c !=null){
                	setOfPartiesId.add(appPartiesObj.genesis__Party_Account_Name__c);    
                }    
            }
            List<Property__c> listOfProperties = new List<Property__c>();
            if(!setOfPartiesId.isEmpty()){
            	listOfProperties =   SOQL_Util.getProperty(setOfPartiesId);  
            }
            cusdetail.KEY_PERSON_DETAILS                        = new List<Customer360view.cls_KEY_PERSON_DETAILS>();
            // KEY_PERSON_DETAILS
            for (genesis__Application_Parties__c ap : (applnInfo.get(app).genesis__Application_Parties__r)) {
                Customer360view.cls_KEY_PERSON_DETAILS kpd = new Customer360view.cls_KEY_PERSON_DETAILS();
                kpd.CBS_CUSTOMER_ID = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.CBS_Customer_ID__c);
                kpd.PASSPORT_NUMBER = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Passport_Number__pc);
                kpd.DIGIO_STATUS = Utility.getBlankStringIfNull(ap.Status__c);
                kpd.SEX = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Gender__pc);
                kpd.NATIONALITY = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Nationality__pc);
                kpd.FATHER_NAME = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Father_Name__pc);
                kpd.MARITAL_STATUS = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Marital_Status__pc);
                kpd.SPOUSE_NAME = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Spouse_Name__pc);
                kpd.CASTE = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Caste__pc);
                kpd.RESIDENTIAL_STATUS = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Residential_Status__pc);
                kpd.RESIDENCE_TYPE = '';
                kpd.DIN_NUMBER = Utility.getBlankStringIfNull(String.valueOf(ap.genesis__Party_Account_Name__r.DIN_Number__pc));
                kpd.LAND_AND_BUILDING = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Land_and_building__pc);
                kpd.LOCATION_TYPE = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Location_Type__pc);
                kpd.CITY = '';
                kpd.STATE = '';
                kpd.PINCODE = '';
                kpd.BUILT_UP_AREA = Utility.getBlankStringIfNull(String.valueOf(ap.genesis__Party_Account_Name__r.Built_up_Area__pc));
                kpd.NUMBER_OF_STOREYS = Utility.getBlankStringIfNull(String.valueOf(ap.genesis__Party_Account_Name__r.Number_of_Storeys__pc));
                kpd.VALUE_OF_LAND_AND_BUILDING = Utility.getBlankStringIfNull(String.valueOf(ap.genesis__Party_Account_Name__r.Value_Of_Land_Building__pc));
                kpd.ALREADY_CHARGED = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Already_Charged__pc);
                kpd.JOINT_HOLDERS = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Joint_holder_CUTSTOMER_NAME__c);
                kpd.TYPE_OF_LAND = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Type_of_Land__pc);
                kpd.TYPE_OF_OWNERSHIP = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Type_of_Ownership__pc);
                kpd.AREA_OF_LAND = Utility.getBlankStringIfNull(String.valueOf(ap.genesis__Party_Account_Name__r.Area_of_Land__pc));
                kpd.VALUE_OF_LAND = Utility.getBlankStringIfNull(String.valueOf(ap.genesis__Party_Account_Name__r.Value_Of_Land__pc));
                kpd.PARTY_TYPE = Utility.getBlankStringIfNull(ap.genesis__Party_Type__c);
                kpd.LOS_PARTY_TYPE_ID = Utility.getBlankStringIfNull(ap.Id);
                kpd.PRODUCT_TYPE = Utility.getBlankStringIfNull(ap.Product_Type__c);
                kpd.RELIGION = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Religion__c);
                kpd.RELIGION_CODE = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Religion_code__pc);
                kpd.GUARANTOR = ap.Guarantor__c == true ? 'Yes' : 'No';
                kpd.IS_ACTIVE = ap.Active__c == true ? 'Yes' : 'No';
                If(ap.Active__c == true && ap.Is_New__c == true && ap.genesis__Party_Account_Name__r.Name != null && !applnInfo.get(app).Critical_Change_done__c) {
                    cusdetail.SUMMARY_VIEW.NEW_KEYPERSON.NAMES += ' ' + ap.genesis__Party_Account_Name__r.Name;
                }
                If(ap.Active__c == false && ap.genesis__Party_Account_Name__r.CBS_Customer_ID__c != null && ap.genesis__Party_Account_Name__r.Name != null && !applnInfo.get(app).Critical_Change_done__c) {
                    cusdetail.SUMMARY_VIEW.DELETE_KEYPERSON.NAMES += ' ' + ap.genesis__Party_Account_Name__r.Name;
                }
                If(ap.Active__c ==true && ap.Is_New__c == true && ap.genesis__Party_Account_Name__r.Name != null && (applnInfo.get(app).Sub_Stage__c =='Key person change decline' || applnInfo.get(app).Sub_Stage__c =='More than 1 critical change decline')) {
                    Customer360view.cls_REJECTED_KEY_PERSON kreject = new Customer360view.cls_REJECTED_KEY_PERSON();
                    kreject.ID      =   Utility.getBlankStringIfNull(ap.Id);
                    kreject.NAME    =   Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Name);
                    cusdetail.COMPANY_DETAILS.REJECTED_KEY_PERSON.add(kreject);
                }
                kpd.DELETEKEYPERSON = ap.is_Deleted__c==true ? 'Yes' : 'No';
                kpd.IS_PHYSTCALLY_HANDICAPPED = ap.genesis__Party_Account_Name__r.Is_Physically_Handicapped__c == true ? 'Yes' : 'No';
                kpd.IS_EXSERVICE_MAN = ap.genesis__Party_Account_Name__r.Is_Ex_Service_Man__c == true ? 'Yes' : 'No';
                kpd.NETWORTH_DETAILS = new List<Customer360view.cls_NETWORTH_DETAILS>();
                kpd.ITR_DOCCATEGORY_ID = indivITRCategID;
                //List<Property__c> listOfProperties = SOQL_Util.getProperty(ap.genesis__Party_Account_Name__c);
                If (listOfProperties != null && !listOfProperties.isEmpty()) {
                    for (Property__c propObj : listOfProperties) {
                        Customer360view.cls_NETWORTH_DETAILS netwrth = new Customer360view.cls_NETWORTH_DETAILS();
                        If (propObj != null && propObj.Account__c !=null && propObj.Account__c == ap.genesis__Party_Account_Name__c) {
                            netwrth.LOS_PROPERTY_ID = Utility.getBlankStringIfNull(propObj.id);
                            If(propObj.Existing_Networth__c !=null){
                                netwrth.Existing_Networth = Utility.getBlankStringIfNull(String.valueOf(propObj.Existing_Networth__c));
                            }
                            netwrth.PROPERTY_TYPE = Utility.getBlankStringIfNull(propObj.Property_Type__c);
                            If(propObj.Property_Value__c !=null){
                                netwrth.PROPERTY_VALUE = Utility.getBlankStringIfNull(String.valueOf(propObj.Property_Value__c));
                                existingNetworth += propObj.Property_Value__c;    
                            }
                            netwrth.NATURE_OF_PROPERTY = Utility.getBlankStringIfNull(String.valueOf(propObj.Nature_of_Property__c));
                            netwrth.OWNERSHIP_TYPE = Utility.getBlankStringIfNull(propObj.Ownership_Type__c);
                            netwrth.SURVEY_NO = Utility.getBlankStringIfNull(String.valueOf(propObj.Survey_No__c));
                            netwrth.MORTGAGE_DETAILS = Utility.getBlankStringIfNull(String.valueOf(propObj.Details_of_mortgage_if_any__c));
                            netwrth.PERCENTAGE_OWNERSHIP = Utility.getBlankStringIfNull(String.valueOf(propObj.Ownership_percentage__c));
                            netwrth.DOOR_NO = Utility.getBlankStringIfNull(String.valueOf(propObj.Door_Number__c));
                            netwrth.NEAREST_LANDMARK = Utility.getBlankStringIfNull(String.valueOf(propObj.Nearest_Landmark__c));
                            netwrth.PROPERTY_AREA = Utility.getBlankStringIfNull(String.valueOf(propObj.Area__c));
                            netwrth.ASSET_TYPE = Utility.getBlankStringIfNull(String.valueOf(propObj.Asset_Type__c));
                            netwrth.IS_COLLATERAL   = Utility.getBlankStringIfNull(String.valueOf(propObj.is_Collateral__c));
                            netwrth.ADDRESS = new Customer360view.cls_ADDRESS();
                            netwrth.ADDRESS.STREET = Utility.getBlankStringIfNull(propObj.Property_Street__c);
                            netwrth.ADDRESS.CITY = Utility.getBlankStringIfNull(propObj.Property_City__c);
                            netwrth.ADDRESS.STATE = Utility.getBlankStringIfNull(propObj.Property_State__c);
                            netwrth.ADDRESS.COUNTRY = Utility.getBlankStringIfNull(propObj.Property_Country__c);
                            netwrth.ADDRESS.PIN_CODE = Utility.getBlankStringIfNull(propObj.Property_Pincode__c);
                            netwrth.ADDRESS.TALUK = Utility.getBlankStringIfNull(propObj.Taluk__c);
                            kpd.NETWORTH_DETAILS.add(netwrth);
                            
                        }
                    }
                }
                kpd.EXISTING_NETWORTH   = String.valueOf(existingNetworth);
                kpd.COMMUNICATION_DETAILS = new Customer360view.cls_COMMUNICATION_DETAILS();
                kpd.COMMUNICATION_DETAILS.MOBILE_NUMBER = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.PersonMobilePhone);
                kpd.COMMUNICATION_DETAILS.EMAIL_ADDRESS = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.PersonEmail);
                kpd.COMMUNICATION_DETAILS.PARMANENT_ADDRESS = new Customer360view.cls_ADDRESS();
                kpd.COMMUNICATION_DETAILS.PARMANENT_ADDRESS.STREET = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.PersonMailingStreet);
                kpd.COMMUNICATION_DETAILS.PARMANENT_ADDRESS.CITY = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.PersonMailingCity);
                kpd.COMMUNICATION_DETAILS.PARMANENT_ADDRESS.STATE = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.PersonMailingState);
                kpd.COMMUNICATION_DETAILS.PARMANENT_ADDRESS.COUNTRY = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.PersonMailingCountry);
                kpd.COMMUNICATION_DETAILS.PARMANENT_ADDRESS.PIN_CODE = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.PersonMailingPostalCode);
                //  kpd.COMMUNICATION_DETAILS.ADDRESS             = '';
                
                kpd.PRIMARY_DETAILS = new Customer360view.cls_PRIMARY_DETAILS();
                //kpd.PRIMARY_DETAILS.NAME                    = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Name);
                kpd.PRIMARY_DETAILS.FIRST_NAME = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.FirstName);
                kpd.PRIMARY_DETAILS.LAST_NAME = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.LastName);
                kpd.PRIMARY_DETAILS.DESIGNATION = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Designation__pc);
                kpd.PRIMARY_DETAILS.DOB = Utility.getBlankStringIfNull(String.valueOf(ap.genesis__Party_Account_Name__r.PersonBirthdate));
                //System.debug('Date of Birth'+kpd.PRIMARY_DETAILS.DOB);
                kpd.PRIMARY_DETAILS.EDUCATIONAL_QUALIFICATION = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Education_Qualification__pc);
                kpd.PRIMARY_DETAILS.EDUCATIONAL_QUALIFICATION_CODE = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Education_Qualification_code__pc);
                kpd.PRIMARY_DETAILS.AADHAAR_NUMBER = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Aadhaar_Number__pc);
                kpd.PRIMARY_DETAILS.PAN_NUMBER = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Pan_Number__c);
                kpd.PRIMARY_DETAILS.LOS_PERSON_ACCOUNT_ID = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__c);
                
                kpd.SECTION_CHANGES = new Customer360view.cls_SECTION_CHANGES();
                kpd.SECTION_CHANGES.NAME = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Name_Of_Director_Related_To__c);
                kpd.SECTION_CHANGES.RELATIONSHIP = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Relationship__c);
                kpd.SECTION_CHANGES.BANK_NAME = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Bank_name__c);
                kpd.SECTION_CHANGES.IS_KVB_DIRECTOR = ap.genesis__Party_Account_Name__r.Is_KVB_Director__c == true ? 'Yes' : 'No';
                kpd.SECTION_CHANGES.FIRST_NAME = '';
                kpd.SECTION_CHANGES.LAST_NAME = '';
                
                //SECTION_CHANGES
                if(!applnInfo.get(app).Critical_Change_done__c){
                    boolean isAnyChange = false;
                    Customer360view.cls_SECTION_CHANGES kpdSec = new Customer360view.cls_SECTION_CHANGES();
                    kpdSec.FIRST_NAME = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.FirstName);
                    kpdSec.LAST_NAME = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.LastName);
                    if (ap.genesis__Party_Account_Name__r.Name_Of_Director_Related_To__c != null && ap.genesis__Party_Account_Name__r.Name_Of_Director_Related_To__c != '') {
                        kpdSec.NAME = ap.genesis__Party_Account_Name__r.Name_Of_Director_Related_To__c;
                        isAnyChange = true;
                    } else {
                        kpdSec.NAME = '';
                    }
                    if (ap.genesis__Party_Account_Name__r.Relationship__c != null && ap.genesis__Party_Account_Name__r.Relationship__c != '') {
                        kpdSec.RELATIONSHIP = ap.genesis__Party_Account_Name__r.Relationship__c;
                        isAnyChange = true;
                    } else {
                        kpdSec.RELATIONSHIP = '';
                    }
                    if (ap.genesis__Party_Account_Name__r.Bank_name__c != null && ap.genesis__Party_Account_Name__r.Bank_name__c != '') {
                        kpdSec.BANK_NAME = Utility.getBlankStringIfNull(ap.genesis__Party_Account_Name__r.Bank_name__c);
                        isAnyChange = true;
                    } else {
                        kpdSec.BANK_NAME = '';
                    }
                    if (ap.genesis__Party_Account_Name__r.Is_KVB_Director__c) {
                        kpdSec.IS_KVB_DIRECTOR = 'Yes';
                        isAnyChange = true;
                    } else {
                        kpdSec.IS_KVB_DIRECTOR = '';
                    }
                    
                    if (isAnyChange)cusdetail.SUMMARY_VIEW.SEC_20_CHANGES.add(kpdSec);
                    
                }
                
                cusdetail.KEY_PERSON_DETAILS.add(kpd);
                //keyPersonCount= cusdetail.KEY_PERSON_DETAILS.size();
            }
            /*if(keyPersonCount!=null){
                cusdetail.COMPANY_DETAILS.BUREAU_FEE=  String.valueOf( (1000+100*(keyPersonCount))+(0.18*(1000+100*(keyPersonCount))) );
                genesis__Applications__c appRec= new genesis__Applications__c(Id=appID);
                appRec.Bureau_Fee__c= (1000+100*(keyPersonCount))+(0.18*(1000+100*(keyPersonCount)));
                update appRec;
            }*/
            //CURRENT_LOAN_APPLICATION
            cusdetail.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION.PRIMARY_SECURITIES = new List<Customer360view.cls_PRIMARY_SECURITIES>();
            cusdetail.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION.COLLATERAL_SECURITIES = new List<Customer360view.cls_COLLATERAL_SECURITIES>();
            cusdetail.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION.PRESENT_RATE_OF_INTEREST = String.valueOf(applnInfo.get(app).genesis__Interest_Rate__c);
            
            // Customer Securities
            cusdetail.COMPANY_DETAILS.COLLATERAL_DETAILS.PRIMARY_SECURITIES = new List<Customer360view.cls_PRIMARY_SECURITIES>();
            cusdetail.COMPANY_DETAILS.COLLATERAL_DETAILS.COLLATERAL_SECURITIES = new List<Customer360view.cls_COLLATERAL_SECURITIES>();
            Set<String> setObj = new Set<String>();
            for (genesis__Application_Collateral__c cl : (applnInfo.get(app).Application_Collateral__r)) {
                If (!setObj.contains(cl.Application__c + '' + cl.genesis__Collateral__r.Id)) {
                    if (cl.Security_Type__c != null && cl.Security_Type__c == Constants.PRIMARY_SECURITIES) {
                        Customer360view.cls_PRIMARY_SECURITIES pObj = new Customer360view.cls_PRIMARY_SECURITIES();
                        pObj.LOS_FACILITY_SECURITY_ID = cl.Id;
                        pObj.LOS_PRIMARY_SECURITY_ID = cl.genesis__Collateral__r.Id;
                        pObj.SECYRITY_TYPE = Utility.getBlankStringIfNull(cl.Security_Type__c);
                        pObj.SECURITY_ADDRESS = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.clcommon__Address__c);
                        pObj.SECURITY_OWNERSHIP_TYPE = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Ownership_Type__c);
                        pObj.SECURITY_VALUATION_DATE = Utility.getBlankStringIfNull(String.valueOf(cl.genesis__Collateral__r.clcommon__Value_Date__c));
                        pObj.SECURITY_VALUE = Utility.getBlankStringIfNull(String.valueOf(cl.genesis__Collateral__r.clcommon__Value__c));
                        pObj.NATURE_OF_PROPERTY = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Nature_of_Property__c);
                        pObj.PERCENTAGE_OWNERSHIP = Utility.getBlankStringIfNull(String.Valueof(cl.genesis__Collateral__r.Percentage_of_Ownership__c));
                        pObj.SURVEY_NO = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.SurveyKhasraKhataPatta_No__c);
                        pObj.MORTGAGE_DETAILS = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.MORT_TYPE__c);
                        pObj.ASSET_TYPE = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Collateral_Category__c);
                        pObj.DOOR_NO = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Door__c);
                        pObj.NEAREST_LANDMARK = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Landmark__c);
                        pObj.PROPERTY_AREA = Utility.getBlankStringIfNull(String.Valueof(cl.genesis__Collateral__r.Area_Square_Feet__c));
                        pObj.ADDRESS = new Customer360view.cls_ADDRESS();
                        pObj.ADDRESS.STREET = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Street_NameNo__c);
                        pObj.ADDRESS.CITY = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.clcommon__City__c);
                        pObj.ADDRESS.STATE = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.State__c);
                        pObj.ADDRESS.PIN_CODE = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.clcommon__Postal_Code__c);
                        pObj.ADDRESS.COUNTRY = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Country__c);
                        pObj.ADDRESS.TALUK = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.TalukaTehsil__c);
                        cusdetail.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION.PRIMARY_SECURITIES.add(pObj);
                        cusdetail.COMPANY_DETAILS.COLLATERAL_DETAILS.PRIMARY_SECURITIES.add(pObj);
                    }
                    
                    if (cl.Security_Type__c != null && cl.Security_Type__c == Constants.COLLATERAL_SECURITIES) {
                        Customer360view.cls_COLLATERAL_SECURITIES cObj = new Customer360view.cls_COLLATERAL_SECURITIES();
                        cObj.LOS_FACILITY_SECURITY_ID = cl.Id;
                        cObj.LOS_COLLATERAL_SECURITY_ID = cl.genesis__Collateral__r.Id;
                        cObj.SECYRITY_TYPE = Utility.getBlankStringIfNull(cl.Security_Type__c);
                        cObj.SECURITY_ADDRESS = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.clcommon__Address__c);
                        cObj.SECURITY_OWNERSHIP_TYPE = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Ownership_Type__c);
                        cObj.SECURITY_VALUATION_DATE = Utility.getBlankStringIfNull(String.valueOf(cl.genesis__Collateral__r.clcommon__Value_Date__c));
                        cObj.SECURITY_VALUE = Utility.getBlankStringIfNull(String.valueOf(cl.genesis__Collateral__r.clcommon__Value__c));
                        cObj.NATURE_OF_PROPERTY = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Nature_of_Property__c);
                        cObj.PERCENTAGE_OWNERSHIP = Utility.getBlankStringIfNull(String.Valueof(cl.genesis__Collateral__r.Percentage_of_Ownership__c));
                        cObj.SURVEY_NO = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.SurveyKhasraKhataPatta_No__c);
                        cObj.MORTGAGE_DETAILS = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.MORT_TYPE__c);
                        cObj.ASSET_TYPE = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Collateral_Category__c);
                        cObj.DOOR_NO = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Door__c);
                        cObj.NEAREST_LANDMARK = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Landmark__c);
                        cObj.PROPERTY_AREA = Utility.getBlankStringIfNull(String.Valueof(cl.genesis__Collateral__r.Area_Square_Feet__c));
                        cObj.ADDRESS = new Customer360view.cls_ADDRESS();
                        cObj.ADDRESS.STREET = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Street_NameNo__c);
                        cObj.ADDRESS.CITY = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.clcommon__City__c);
                        cObj.ADDRESS.STATE = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.State__c);
                        cObj.ADDRESS.PIN_CODE = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.clcommon__Postal_Code__c);
                        cObj.ADDRESS.COUNTRY = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.Country__c);
                        cObj.ADDRESS.TALUK = Utility.getBlankStringIfNull(cl.genesis__Collateral__r.TalukaTehsil__c);
                        cusdetail.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION.COLLATERAL_SECURITIES.add(cObj);
                        cusdetail.COMPANY_DETAILS.COLLATERAL_DETAILS.COLLATERAL_SECURITIES.add(cObj);
                    }
                    setObj.add(cl.Application__c + '' + cl.genesis__Collateral__r.Id);
                }
                
            }
            //SECTION 20 for Business Account
            cusdetail.COMPANY_DETAILS.SECTION_20_CUSTOMER   =   new Customer360view.cls_SECTION_20_CUSTOMER();
            cusdetail.COMPANY_DETAILS.SECTION_20_CUSTOMER.NAME_OF_DIRECTOR = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Name_Of_Director_Related_To__c);
            cusdetail.COMPANY_DETAILS.SECTION_20_CUSTOMER.NAME_OF_BANK     = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Bank_name__c);
            cusdetail.COMPANY_DETAILS.SECTION_20_CUSTOMER.NATURE_OF_RELATIONSHIP = Utility.getBlankStringIfNull(applnInfo.get(app).genesis__Account__r.Relationship__c);
            cusdetail.COMPANY_DETAILS.SECTION_20_CUSTOMER.SECTION_20     = applnInfo.get(app).genesis__Account__r.is_Section_20__c ? 'Yes':'No';
            
            cusdetail.SANCTION_SECTION = new Customer360view.cls_SANCTION_SECTION();
            cusdetail.SANCTION_SECTION.RECOMMENDED_FINAL_RATE_OF_INTEREST = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Recommended_Final_Rate_of_Interest__c));
            cusdetail.loanInfo.MY_LOAN = new List<Customer360view.cls_FACILITIES>();
            cusdetail.loanInfo.WORKING_CAPITAL = new List<Customer360view.cls_FACILITIES>();
            if (facilityList.size() > 0 && applnInfo.get(app).RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE) {
                
                for (Facility__c f : facilityList) {
                    System.debug('@@@@@@@'+f);
                    Customer360view.cls_FACILITIES fac = new Customer360view.cls_FACILITIES();
                    fac.NAME_OF_THE_FACILITY = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.clcommon__Product_Name__c));
                    fac.ACCOUNT_NUMBER = Utility.getBlankStringIfNull(String.valueOf(f.Account_Number__c));
                    fac.APPROVED_LIMIT = Utility.getBlankStringIfNull(String.valueOf(f.Recommended_Limit__c));
                    fac.TOTAL_LOAN_AMT = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Limit__c));
                    fac.BALANCE_OUTSTANDING = Utility.getBlankStringIfNull(String.valueOf(f.Balance_Outstandings__c));
                    fac.LIMIT_AMT = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Limit__c));
                    fac.OVER_DUE = Utility.getBlankStringIfNull(String.valueOf(f.Over_Due__c));
                    fac.INTEREST_RATE = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Rate__c));
                    fac.PRODUCT_CODE = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.Product_Code__c));
                    cusdetail.loanInfo.WORKING_CAPITAL.add(fac);
                }
                if (!loanFacilityList.isEmpty()) {
                    for (Facility__c f : loanFacilityList) {
                        Customer360view.cls_FACILITIES fac = new Customer360view.cls_FACILITIES();
                        fac.NAME_OF_THE_FACILITY = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.clcommon__Product_Name__c));
                        fac.ACCOUNT_NUMBER = Utility.getBlankStringIfNull(String.valueOf(f.Account_Number__c));
                        fac.APPROVED_LIMIT = Utility.getBlankStringIfNull(String.valueOf(f.Recommended_Limit__c));
                        fac.TOTAL_LOAN_AMT = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Limit__c));
                        fac.BALANCE_OUTSTANDING = Utility.getBlankStringIfNull(String.valueOf(f.Balance_Outstandings__c));
                        fac.LIMIT_AMT = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Limit__c));
                        fac.OVER_DUE = Utility.getBlankStringIfNull(String.valueOf(f.Over_Due__c));
                        fac.INTEREST_RATE = Utility.getBlankStringIfNull(String.valueOf(f.Existing_Rate__c));
                        fac.PRODUCT_CODE = Utility.getBlankStringIfNull(String.valueOf(f.CL_Product__r.Product_Code__c));
                        cusdetail.loanInfo.MY_LOAN.add(fac);
                    }
                }
            }
            
            
            // Stock Statment
            cusdetail.loanInfo.STOCK = new Customer360view.STOCK_MODEL();
            cusdetail.loanInfo.STOCK.templates = new List<Customer360view.STOCK_TEMPLATE>();
            cusdetail.loanInfo.STOCK.templates = Utility.getStockTemplates();
            cusdetail.loanInfo.STOCK.STOCK_STATEMENT = new List<Customer360view.cls_STOCK_STATEMENT>();
            cusdetail.loanInfo.STOCK.STOCK_STATEMENT = Utility.getStockStatementDetails(custId);

                    //Net worth statement
            cusdetail.NET_WORTH_STATEMENT                                       = new Customer360view.cls_NET_WORTH_STATEMENT();
            cusdetail.NET_WORTH_STATEMENT.TOL_AND_TNW_DOC_CATEGORY              = new DocumentFetch.DocumentCategory();
            If(cusdetail.NET_WORTH_STATEMENT !=null){
                cusdetail.NET_WORTH_STATEMENT.TOTAL_OUTSTANDING_LIABALITIES      = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Total_Outstanding_Liabilities__c));
                cusdetail.NET_WORTH_STATEMENT.TOTAL_NETWORTH                     = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Total_Networth__c));
                cusdetail.NET_WORTH_STATEMENT.ORIGINAL_AMOUNT_INVESTMENTS        = Utility.getBlankStringIfNull(String.valueOf(applnInfo.get(app).Original_Amount_Investments__c));
                If(tolTnwDocument !=null)
                    cusdetail.NET_WORTH_STATEMENT.TOL_AND_TNW_DOC_CATEGORY       = new DocumentFetch.DocumentCategory();
                cusdetail.NET_WORTH_STATEMENT.TOL_AND_TNW_DOC_CATEGORY       = tolTnwDocument; 
            }     
            
        }
        
        cusdetail = fetchCustomerFeedback(cusdetail.LOS_APPLICATION_ID, cusdetail);
        return cusdetail;
    }
    
    /*
* Update Application,Company, Key Person and Collateral Details coming from Middleware.    
*/
    public static Customer360view getCustomAppDetailsUpdate(Customer360view customObj) {
        System.debug('customObj.COMPANY_DETAILS.DATE_OF_INCORPORATION '+customObj.COMPANY_DETAILS.DATE_OF_INCORPORATION);
        Account acc = new Account();
        List<Account> listaccount = new List<Account>();
        List<Account> newlistacc = new List<Account>();
        Set<Account> deletePartyAcc = new set<Account>();
        set<id> partyIdObj = new set<id>();
        Map<String, String> mapPartyType = new Map<String, String>();
        List<Account> newOrExistingAccountList= new List<Account>();
        genesis__Applications__c app = new genesis__Applications__c();
        genesis__Applications__c applicationObj = new genesis__Applications__c();
        List<genesis__Application_Collateral__c> listcollateral = new List<genesis__Application_Collateral__c>();
        List<genesis__Application_Parties__c> listappparty = new List<genesis__Application_Parties__c>();
        List<genesis__Application_Parties__c> deleteappparty = new List<genesis__Application_Parties__c>();
        List<Property__c> listPropertyinsert = new List<Property__c>();
        List<Property__c> listPropertyupdate = new List<Property__c>();
        List<Task> newRLPCTask = new List<Task>();
        
        List<Group_Concern__c> listGroupConInsert = new List<Group_Concern__c>();
        List<Group_Concern__c> listGroupConUpdate = new List<Group_Concern__c>();
        
        Integer currentYear = Utility.getCurrentYear();
        String cyString = String.valueOf(currentYear);
        String currentFY = (currentYear - 1) + '-' + Integer.valueOf(cyString.subString(cyString.length() - 2, cyString.length()));
        String prevFY = (currentYear - 2) + '-' + Integer.valueOf(String.valueOf(currentYear - 1).subString(String.valueOf(currentYear - 1).length() - 2, String.valueOf(currentYear - 1).length()));
        String nextEstFiscalYear = currentYear + '-' + Integer.valueOf(String.valueOf(currentYear + 1).subString(String.valueOf(currentYear + 1).length() - 2, String.valueOf(currentYear + 1).length()));
        String nextProjFiscalYear = (currentYear + 1) + '-' + Integer.valueOf(String.valueOf(currentYear + 2).subString(String.valueOf(currentYear + 2).length() - 2, String.valueOf(currentYear + 2).length()));
        
        List<genesis__Applications__c> appln = new List<genesis__Applications__c>();
        List<String> appStageFE = new List<String>{
            'Application Filling - Critical Changes', 'Application review-Critical changes'
                };
                    Id personAccountTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Boolean allPartySigned = true;
        if (customObj != null) {
            List<Customer360view.cls_KEY_PERSON_DETAILS> listKeyPersonDetails = customObj.KEY_PERSON_DETAILS;
            //Download Signed Document on status update
            downloadSignedDocument(customObj);
            //update signed status
            SME_Enhance_Update.updateSanctionDocument(customObj);
            
            //Liabilities API
            if(customObj.BusinessLiabilityDetails !=null){
                Customer360view.cls_BusinessLiabilityDetails businessLiabilityObj = customObj.BusinessLiabilityDetails;
                if(businessLiabilityObj !=null && customObj.LOS_APPLICATION_ID !=null && customObj.LOS_CUSTOMER_SF_ID !=null){
                    SMELoan_Helper_Handler.updateBusinessLiablities(customObj.LOS_APPLICATION_ID,customObj.LOS_CUSTOMER_SF_ID,businessLiabilityObj);    
                }
            }
            if(customObj.KeyPersonLiabilityDetails !=null){
                List<Customer360view.cls_KeyPersonLiabilityDetails> kPersonLiabilityObj = customObj.KeyPersonLiabilityDetails;
                if(kPersonLiabilityObj !=null && kPersonLiabilityObj.size() > 0 && customObj.LOS_APPLICATION_ID !=null && customObj.LOS_CUSTOMER_SF_ID !=null){
                    SMELoan_Helper_Handler.updateKeyPersonLiablities(customObj.LOS_APPLICATION_ID,kPersonLiabilityObj);    
                }
            }
            
            If (!Utility.ISStringBlankorNull(customObj.LOS_APPLICATION_ID))
                app.id = customObj.LOS_APPLICATION_ID;
            If (!Utility.ISStringBlankorNull(customObj.APPLICATION_UI_STAGE))
                app.Application_UI_Stage__c = customObj.APPLICATION_UI_STAGE;
            If (!Utility.ISStringBlankorNull(customObj.APPLICATION_STAGE) && appStageFE.contains(customObj.APPLICATION_STAGE))
                app.Application_Stage__c = customObj.APPLICATION_STAGE;
            If (!Utility.ISStringBlankorNull(customObj.LOS_CUSTOMER_SF_ID))
                app.genesis__Account__c = customObj.LOS_CUSTOMER_SF_ID;
            
            If (!Utility.ISStringBlankorNull(customObj.APP_SUB_STAGE) && customObj.APP_SUB_STAGE == Constants.FINANCIAL_DONE) {
                app.Sub_Stage__c = Constants.FINANCIAL_DONE;
                app.CLPC_review_done__c = false;
                User rlpcUser = SOQL_Util.getRLPCUser(customObj.LOS_APPLICATION_ID);
                newRLPCTask.add(SanctionUnderwriting_Process.getTaskObj(customObj.LOS_APPLICATION_ID, rlpcUser.Id, Constants.RLPC_FINANCIAL_TASK, ''));
            }
            If (customObj.COMPANY_DETAILS != null)
                If (customObj.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION != null)
                If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION.PRESENT_RATE_OF_INTEREST))
                app.genesis__Interest_Rate__c = Double.valueOf(customObj.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION.PRESENT_RATE_OF_INTEREST);
            If (customObj.COMPANY_DETAILS != null)
                If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LOAN_ACCOUNT_NO))
                app.Loan_Account_Number__c = customObj.COMPANY_DETAILS.LOAN_ACCOUNT_NO;
            If (customObj.SANCTION_SECTION != null)
                If (!Utility.ISStringBlankorNull(customObj.SANCTION_SECTION.RECOMMENDED_FINAL_RATE_OF_INTEREST))
                app.Recommended_Final_Rate_of_Interest__c = Double.valueOf(customObj.SANCTION_SECTION.RECOMMENDED_FINAL_RATE_OF_INTEREST);
            
            //CUST_ENHANCEMENT
            if (customObj.CUST_ENHANCEMENT != null) {//currencyFormatter
                if (customObj.CUST_ENHANCEMENT.REASON != '' && customObj.CUST_ENHANCEMENT.REASON != null)
                    app.Enhancement_reason__c = customObj.CUST_ENHANCEMENT.REASON;
                                
                app.Application_Stage__c = 'Application close-enhancement';
            }
            
            // COMPANY_DETAILS                     
            If (!Utility.ISStringBlankorNull(customObj.LOS_CUSTOMER_SF_ID))
                acc.id = customObj.LOS_CUSTOMER_SF_ID;
            If (customObj.COMPANY_DETAILS != null) {
                Customer360view.cls_COMPANY_PRIMARY_DETAILS cusPrmDetail = customObj.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS;
                
                if (cusPrmDetail != null) {
                    If (!Utility.ISStringBlankorNull(cusPrmDetail.NAME))
                        acc.Name__c = cusPrmDetail.NAME;
                    
                    //cusdetail.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.NAME_OF_THE_GROUP = null;
                    If (!Utility.ISStringBlankorNull(cusPrmDetail.INDUSTRY_TYPE))
                        acc.Industry_Type__c = cusPrmDetail.INDUSTRY_TYPE;
                    If (!Utility.ISStringBlankorNull(cusPrmDetail.GST_NUMBER)) {
                        acc.GST_Number__c = cusPrmDetail.GST_NUMBER;
                    }
                    System.debug('Const::' + customObj.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS);
                    If (customObj.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS != null) {
                        Customer360view.cls_CONSTITUTION_DETAILS cusReCnstDetail = customObj.COMPANY_DETAILS.COMPANY_PRIMARY_DETAILS.CONSTITUTION_DETAILS;
                        If (cusReCnstDetail != null) {
                            If (cusReCnstDetail.CONSTITUTION != null)
                                acc.Constitution__c = cusReCnstDetail.CONSTITUTION;
                            If (cusReCnstDetail.RECONSTITUTION_DATE != null && cusReCnstDetail.RECONSTITUTION_DATE != '')
                                acc.Latest_Date_Of_Reconstitution__c = Date.valueOf(cusReCnstDetail.RECONSTITUTION_DATE);
                        }
                    }
                }
                
            }

            //MISSING_FINACIAL_YEARS
            if(customObj.MISSING_FINACIAL_YEARS != null){
                for(Customer360view.cls_MISSING_FIN  mssngFinObj  :  customObj.MISSING_FINACIAL_YEARS){
                    if(YearToMissingFinancialYearMap.containsKey(mssngFinObj.year)){
                        YearToMissingFinancialYearMap.get(mssngFinObj.year).add(mssngFinObj.CA_NUMBER);
                        YearToMissingFinancialYearMap.get(mssngFinObj.year).add(mssngFinObj.CA_NAME);
                    }
                    else{
                        YearToMissingFinancialYearMap.put(mssngFinObj.year,new List<String>{mssngFinObj.CA_NUMBER,mssngFinObj.CA_NAME});
                    }
                }
            }
			System.debug('YearToMissingFinancialYearMap:::'+YearToMissingFinancialYearMap);

            //FINANCIALS            
            If (customObj.FINANCIALS != null) {
                List<M68_Balance_Sheet_Analysis__c> m68DataListToInsert = new List<M68_Balance_Sheet_Analysis__c>();
                List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();
                M68_Balance_Sheet_Analysis__c m68CurrentYTD = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ProjNext2 = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68EstNext = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActPrev = new M68_Balance_Sheet_Analysis__c();
                M68_Balance_Sheet_Analysis__c m68ActCurrent = new M68_Balance_Sheet_Analysis__c();
                
                //System.debug(customObj.FINANCIALS.SALES);
                if (customObj.FINANCIALS.SALES != null) {
                    if (customObj.FINANCIALS.SALES.YTD_CURRENT_FY != null) {
                        Customer360view.cls_FY salesCurrentYTD = customObj.FINANCIALS.SALES.YTD_CURRENT_FY;
                        if (salesCurrentYTD.LOS_ID != null && salesCurrentYTD.LOS_ID != '') {
                            m68CurrentYTD.Id = salesCurrentYTD.LOS_ID;
                            m68CurrentYTD.Month__c = salesCurrentYTD.MONTH;
                            m68CurrentYTD.Net_sales__c = currencyFormatter(salesCurrentYTD.FY_TOTAL);
                            m68CurrentYTD.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@YTD';
                            m68DataList.add(m68CurrentYTD);
                        } else if (salesCurrentYTD.FY_TOTAL != null && salesCurrentYTD.FY_TOTAL != '') {
                            m68CurrentYTD.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68CurrentYTD.Fiscal_Year__c = currentFY;
                            m68CurrentYTD.Financial_type__c = 'YTD';
                            m68CurrentYTD.Month__c = salesCurrentYTD.MONTH;
                            m68CurrentYTD.Net_sales__c = currencyFormatter(salesCurrentYTD.FY_TOTAL);
                            m68CurrentYTD.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@YTD';
                            if(YearToMissingFinancialYearMap.get(currentFY) != null){
                                m68CurrentYTD.CA_Name__c = YearToMissingFinancialYearMap.get(currentFY)[0];
                                m68CurrentYTD.CA_Number__c = YearToMissingFinancialYearMap.get(currentFY)[1];
                            }
                            m68DataListToInsert.add(m68CurrentYTD);
                        }
                    }
                    if (customObj.FINANCIALS.SALES.PROJ_NEXT2_FY != null) {
                        Customer360view.cls_FY salesNext2Proj = customObj.FINANCIALS.SALES.PROJ_NEXT2_FY;
                        if (salesNext2Proj.LOS_ID != null && salesNext2Proj.LOS_ID != '') {
                            m68ProjNext2.Id = salesNext2Proj.LOS_ID;
                            m68ProjNext2.Net_sales__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            m68ProjNext2.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextProjFiscalYear+'@Projected';
                            m68DataList.add(m68ProjNext2);
                        } else if (salesNext2Proj.FY_TOTAL != null && salesNext2Proj.FY_TOTAL != '') {
                            m68ProjNext2.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68ProjNext2.Fiscal_Year__c = nextProjFiscalYear;
                            m68ProjNext2.Financial_type__c = 'Projected';
                            m68ProjNext2.Net_sales__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            m68ProjNext2.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextProjFiscalYear+'@Projected';
                            if(YearToMissingFinancialYearMap.get(nextProjFiscalYear) != null){
                                m68ProjNext2.CA_Name__c = YearToMissingFinancialYearMap.get(nextProjFiscalYear)[0];
                                m68ProjNext2.CA_Number__c = YearToMissingFinancialYearMap.get(nextProjFiscalYear)[1];
                            }
                            
                            m68DataListToInsert.add(m68ProjNext2);
                        }
                    }
                    if (customObj.FINANCIALS.SALES.EST_NEXT_FY != null) {
                        Customer360view.cls_FY salesNextEst = customObj.FINANCIALS.SALES.EST_NEXT_FY;
                        if (salesNextEst.LOS_ID != null && salesNextEst.LOS_ID != '') {
                            m68EstNext.Id = salesNextEst.LOS_ID;
                            m68EstNext.Net_sales__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            m68EstNext.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextEstFiscalYear+'@Estimated';
                            m68DataList.add(m68EstNext);
                        } else if (salesNextEst.FY_TOTAL != null && salesNextEst.FY_TOTAL != '') {
                            m68EstNext.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68EstNext.Fiscal_Year__c = nextEstFiscalYear;
                            m68EstNext.Financial_type__c = 'Estimated';
                            m68EstNext.Net_sales__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            m68EstNext.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextEstFiscalYear+'@Estimated';
                            if(YearToMissingFinancialYearMap.get(nextEstFiscalYear) != null){
                                m68EstNext.CA_Name__c = YearToMissingFinancialYearMap.get(nextEstFiscalYear)[0];
                                m68EstNext.CA_Number__c = YearToMissingFinancialYearMap.get(nextEstFiscalYear)[1];
                            }
                            m68DataListToInsert.add(m68EstNext);
                        }
                    }
                    if (customObj.FINANCIALS.SALES.ACTUAL_CURRENT_FY != null) {
                        Customer360view.cls_FY salesCurrentAct = customObj.FINANCIALS.SALES.ACTUAL_CURRENT_FY;
                        if (salesCurrentAct.LOS_ID != null && salesCurrentAct.LOS_ID != '') {
                            m68ActCurrent.Id = salesCurrentAct.LOS_ID;
                            m68ActCurrent.Net_sales__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68ActCurrent.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@Actual';
                            m68DataList.add(m68ActCurrent);
                        } else if (salesCurrentAct.FY_TOTAL != null && salesCurrentAct.FY_TOTAL != '') {
                            m68ActCurrent.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68ActCurrent.Fiscal_Year__c = currentFY;
                            m68ActCurrent.Financial_type__c = 'Actual';
                            m68ActCurrent.Net_sales__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68ActCurrent.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@Actual';
                            if(YearToMissingFinancialYearMap.get(currentFY) != null){
                                m68ActCurrent.CA_Name__c = YearToMissingFinancialYearMap.get(currentFY)[0];
                                m68ActCurrent.CA_Number__c = YearToMissingFinancialYearMap.get(currentFY)[1];
                            }
                            m68DataListToInsert.add(m68ActCurrent);
                        }
                    }
                }
                if (customObj.FINANCIALS.PURCHASE != null) {
                    if (customObj.FINANCIALS.PURCHASE.YTD_CURRENT_FY != null) {
                        Customer360view.cls_FY salesCurrentYTD = customObj.FINANCIALS.PURCHASE.YTD_CURRENT_FY;
                        if (m68CurrentYTD.Net_sales__c != null && salesCurrentYTD.FY_TOTAL != '') {
                            m68CurrentYTD.Purchases__c = currencyFormatter(salesCurrentYTD.FY_TOTAL);
                            m68CurrentYTD.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@YTD';
                            m68CurrentYTD.Month__c = salesCurrentYTD.MONTH;
                        } else if (m68CurrentYTD.Net_sales__c == null && salesCurrentYTD.FY_TOTAL != '') {
                            m68CurrentYTD.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68CurrentYTD.Fiscal_Year__c = currentFY;
                            m68CurrentYTD.Financial_type__c = 'YTD';
                            m68CurrentYTD.Month__c = salesCurrentYTD.MONTH;
                            m68CurrentYTD.Purchases__c = currencyFormatter(salesCurrentYTD.FY_TOTAL);
                            m68CurrentYTD.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@YTD';
                            if(YearToMissingFinancialYearMap.get(currentFY) != null){
                                m68CurrentYTD.CA_Name__c = YearToMissingFinancialYearMap.get(currentFY)[0];
                                m68CurrentYTD.CA_Number__c = YearToMissingFinancialYearMap.get(currentFY)[1];
                            }
                            m68DataListToInsert.add(m68CurrentYTD);
                        }
                    }
                    if (customObj.FINANCIALS.PURCHASE.PROJ_NEXT2_FY != null) {
                        Customer360view.cls_FY salesNext2Proj = customObj.FINANCIALS.PURCHASE.PROJ_NEXT2_FY;
                        if (m68ProjNext2.Net_sales__c != null && salesNext2Proj.FY_TOTAL != '') {
                            m68ProjNext2.Purchases__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            m68ProjNext2.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextProjFiscalYear+'@Projected';
                        } else if (m68ProjNext2.Net_sales__c == null && salesNext2Proj.FY_TOTAL != '') {
                            m68ProjNext2.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68ProjNext2.Fiscal_Year__c = nextProjFiscalYear;
                            m68ProjNext2.Financial_type__c = 'Projected';
                            m68ProjNext2.Purchases__c = currencyFormatter(salesNext2Proj.FY_TOTAL);
                            m68ProjNext2.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextProjFiscalYear+'@Projected';
                            if(YearToMissingFinancialYearMap.get(nextProjFiscalYear) != null){
                                m68ProjNext2.CA_Name__c = YearToMissingFinancialYearMap.get(nextProjFiscalYear)[0];
                                m68ProjNext2.CA_Number__c = YearToMissingFinancialYearMap.get(nextProjFiscalYear)[1];
                            }
                            m68DataListToInsert.add(m68ProjNext2);
                        }
                    }
                    if (customObj.FINANCIALS.PURCHASE.EST_NEXT_FY != null) {
                        Customer360view.cls_FY salesNextEst = customObj.FINANCIALS.PURCHASE.EST_NEXT_FY;
                        if (m68EstNext.Net_sales__c != null && salesNextEst.FY_TOTAL != '') {
                            m68EstNext.Purchases__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            m68EstNext.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextEstFiscalYear+'@Estimated';
                        } else if (m68EstNext.Net_sales__c == null && salesNextEst.FY_TOTAL != '') {
                            m68EstNext.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68EstNext.Fiscal_Year__c = nextEstFiscalYear;
                            m68EstNext.Financial_type__c = 'Estimated';
                            m68EstNext.Purchases__c = currencyFormatter(salesNextEst.FY_TOTAL);
                            m68EstNext.External_Id__c =  customObj.CUSTOMER_ID+'@'+nextEstFiscalYear+'@Estimated';
                            if(YearToMissingFinancialYearMap.get(nextEstFiscalYear) != null){
                                m68EstNext.CA_Name__c = YearToMissingFinancialYearMap.get(nextEstFiscalYear)[0];
                                m68EstNext.CA_Number__c = YearToMissingFinancialYearMap.get(nextEstFiscalYear)[1];
                            }
                            m68DataListToInsert.add(m68EstNext);
                        }
                    }
                    if (customObj.FINANCIALS.PURCHASE.ACTUAL_CURRENT_FY != null) {
                        Customer360view.cls_FY salesCurrentAct = customObj.FINANCIALS.PURCHASE.ACTUAL_CURRENT_FY;
                        if (m68ActCurrent.Net_sales__c != null && salesCurrentAct.FY_TOTAL != '') {
                            m68ActCurrent.Purchases__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68ActCurrent.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@Actual';
                        } else if (m68ActCurrent.Net_sales__c == null && salesCurrentAct.FY_TOTAL != '') {
                            m68ActCurrent.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            m68ActCurrent.Fiscal_Year__c = currentFY;
                            m68ActCurrent.Financial_type__c = 'Actual';
                            m68ActCurrent.Purchases__c = currencyFormatter(salesCurrentAct.FY_TOTAL);
                            m68ActCurrent.External_Id__c =  customObj.CUSTOMER_ID+'@'+currentFY+'@Actual';
                            if(YearToMissingFinancialYearMap.get(currentFY) != null){
                                m68ActCurrent.CA_Name__c = YearToMissingFinancialYearMap.get(currentFY)[0];
                                m68ActCurrent.CA_Number__c = YearToMissingFinancialYearMap.get(currentFY)[1];
                            }
                            m68DataListToInsert.add(m68ActCurrent);
                        }
                    }
                }
                if (!m68DataList.isEmpty()) {
                    UPSERT m68DataList;
                }
                if (!m68DataListToInsert.isEmpty()) {
                    UPSERT m68DataListToInsert External_Id__c;
                }
            }
            
            /*List<Stock_Below_Limit__c> updateStockList = new List<Stock_Below_Limit__c>();
            List<Stocks__c> updateStocks = new List<Stocks__c>();
            // Stock Below Limit Update
            if (customObj.loanInfo != null && customObj.loanInfo.STOCK != null && customObj.loanInfo.STOCK.STOCK_STATEMENT != null) {
                for (Customer360view.cls_STOCK_STATEMENT stk : customObj.loanInfo.STOCK.STOCK_STATEMENT) {
                    if (stk.belowLimit != null) {
                        Stock_Below_Limit__c stock = new Stock_Below_Limit__c();
                        Stocks__c parent = new Stocks__c();
                        if (stk.belowLimit.LOS_RECORD_ID != null && stk.belowLimit.LOS_RECORD_ID != '') {
                            stock.Id = stk.belowLimit.LOS_RECORD_ID;
                        } else {
                            parent.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            parent.Year__c = stk.YEAR;
                            parent.Month__c = stk.MONTH;
                            parent.Unique_Key__c = customObj.COMPANY_DETAILS.CUSTOMER_ID + '_' + stk.MONTH + '_' + stk.YEAR;
                            updateStocks.add(parent);
                            
                            stock.stocks__r = new Stocks__c(Unique_Key__c = parent.Unique_Key__c);
                        }
                        
                        if (stk.belowLimit.OPENING_STOCK != null && stk.belowLimit.OPENING_STOCK != '')
                            stock.Opening_Stock__c = currencyFormatter(stk.belowLimit.OPENING_STOCK);
                        if (stk.belowLimit.PURCHASE != null && stk.belowLimit.PURCHASE != '')
                            stock.Purchases__c = currencyFormatter(stk.belowLimit.PURCHASE);
                        if (stk.belowLimit.SALES != null && stk.belowLimit.SALES != '')
                            stock.Sales__c = currencyFormatter(stk.belowLimit.SALES);
                        if (stk.belowLimit.SUNDRY_DEBT != null && stk.belowLimit.SUNDRY_DEBT != '')
                            stock.Sundry_Debtors__c = currencyFormatter(stk.belowLimit.SUNDRY_DEBT);
                        if (stk.belowLimit.SUNDRY_CREDIT != null && stk.belowLimit.SUNDRY_CREDIT != '') {
                            stock.Sundry_Creditors__c = currencyFormatter(stk.belowLimit.SUNDRY_CREDIT);
                        }
                        updateStockList.add(stock);
                    }
                }
                if (updateStocks.size() > 0) upsert updateStocks Unique_Key__c;
                if (updateStockList.size() > 0) upsert updateStockList;
            }*/
            updateStockStatement(customObj);
            
            //COMPANY_COMMUNICATION_DETAILS
            If (customObj.COMPANY_DETAILS != null) {
                Customer360view.cls_COMPANY_COMMUNICATION_DETAILS cusCmpCommDetail = customObj.COMPANY_DETAILS.COMPANY_COMMUNICATION_DETAILS;
                If (cusCmpCommDetail != null) {
                    If (cusCmpCommDetail.REGISTERED_OFFICE_ADDRESS != null) {
                        Customer360view.cls_ADDRESS cusCmpAdd = cusCmpCommDetail.REGISTERED_OFFICE_ADDRESS;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.STREET))
                            acc.BillingStreet = cusCmpAdd.STREET;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.CITY))
                            acc.BillingCity = cusCmpAdd.CITY;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.PIN_CODE))
                            acc.BillingPostalCode = cusCmpAdd.PIN_CODE;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.STATE))
                            acc.BillingState = cusCmpAdd.STATE;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.COUNTRY))
                            acc.BillingCountry = cusCmpAdd.COUNTRY;
                    }
                    If (cusCmpCommDetail.CORPORATE_OFFICE_ADDRESS != null) {
                        Customer360view.cls_ADDRESS cusCmpAdd = cusCmpCommDetail.CORPORATE_OFFICE_ADDRESS;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.STREET))
                            acc.ShippingStreet = cusCmpAdd.STREET;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.CITY))
                            acc.ShippingCity = cusCmpAdd.CITY;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.PIN_CODE))
                            acc.ShippingPostalCode = cusCmpAdd.PIN_CODE;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.STATE))
                            acc.ShippingState = cusCmpAdd.STATE;
                        If (!Utility.ISStringBlankorNull(cusCmpAdd.COUNTRY))
                            acc.ShippingCountry = cusCmpAdd.COUNTRY;
                    }
                    If (!Utility.ISStringBlankorNull(cusCmpCommDetail.CONTACT_PERSON_NAME))
                        acc.Contact_Person_Name__c = cusCmpCommDetail.CONTACT_PERSON_NAME;
                    If (!Utility.ISStringBlankorNull(cusCmpCommDetail.CONTACT_NUMBER))
                        acc.Phone = cusCmpCommDetail.CONTACT_NUMBER;
                }
            }
            // COMPANY_DETAILS
            If (customObj.COMPANY_DETAILS != null) {
                Customer360view.cls_COLLATERAL_DETAILS cusCollateralDetails = customObj.COMPANY_DETAILS.COLLATERAL_DETAILS;
                If (customObj.COMPANY_DETAILS != null) {
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.BORROWER_NAME))
                        acc.Name = customObj.COMPANY_DETAILS.BORROWER_NAME;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.CONTACT_PERSON_DESIGNATION))
                        acc.Contact_Person_Designation__c = customObj.COMPANY_DETAILS.CONTACT_PERSON_DESIGNATION;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY)) {
                        acc.Line_of_Activity__c = customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY;
                        If (customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY == 'Service Provision') {
                            acc.Cash_Budget__c = true;
                        }
                    }
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY_CODE))
                        acc.Line_of_Activity_code__c = customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY_CODE;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.CIN_NUMBER)){
                        acc.CIN_Number__c = customObj.COMPANY_DETAILS.CIN_NUMBER;
                        
                       Boolean flag  = SOQL_Util.getApplicationProbe42(customObj.LOS_APPLICATION_ID);
                        If(!flag){
                            //call future method for probe 42 data
                            getProbeDetails(customObj.LOS_CUSTOMER_SF_ID,customObj.LOS_APPLICATION_ID);
                        }
                    }
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PAN_NUMBER))
                        acc.Pan_Number__c = customObj.COMPANY_DETAILS.PAN_NUMBER;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.IE_CODE_NUMBER))
                        acc.IE_Code__c = customObj.COMPANY_DETAILS.IE_CODE_NUMBER;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.RECONSTITUTED))
                        acc.Firm_Company_was_Reconstituted__c = customObj.COMPANY_DETAILS.RECONSTITUTED == '1' ? true : false;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.RELATED))
                        acc.Related__c = customObj.COMPANY_DETAILS.RELATED;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LOAN_AMOUNT))
                        acc.Total_Loan_Amount__c = double.valueOf(customObj.COMPANY_DETAILS.LOAN_AMOUNT);
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.BALANCE_OUTSTANDING))
                        acc.Balance_Outstandings__c = double.valueOf(customObj.COMPANY_DETAILS.BALANCE_OUTSTANDING);
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.OVER_DUE))
                        acc.Over_Due__c = customObj.COMPANY_DETAILS.OVER_DUE;
                    //If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.REASONS_FOR_GST_NOT_APPLICABLE))
                    //acc.Reasons_for_exemption_from_GST__c = customObj.COMPANY_DETAILS.REASONS_FOR_GST_NOT_APPLICABLE;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.TURNOVER))
                        acc.Annual_TurnoverIncome__c = Decimal.valueOf(customObj.COMPANY_DETAILS.TURNOVER);
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.PRINCIPAL_NATURE_OF_BUSINESS))
                        acc.Principal_nature_of_business__c = customObj.COMPANY_DETAILS.PRINCIPAL_NATURE_OF_BUSINESS;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.UAM_NUMBER))
                        acc.UAM_Number__c = customObj.COMPANY_DETAILS.UAM_NUMBER;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.MAJOR_ACTIVITY))
                        acc.Major_Activity__c = customObj.COMPANY_DETAILS.MAJOR_ACTIVITY;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.ENTERPRISE_TYPE))
                        acc.Enterprise_Type__c = customObj.COMPANY_DETAILS.ENTERPRISE_TYPE;
                    If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.ACTIVITY_TYPE))
                        acc.Activity_Type__c = customObj.COMPANY_DETAILS.ACTIVITY_TYPE;
                }
            }
            if (customObj.COMPANY_DETAILS != null) {
                List<Customer360view.cls_GROUP_CONCERN_DETAILS> listGroupConcern = customObj.COMPANY_DETAILS.GROUP_CONCERN_DETAILS;
                if (listGroupConcern != null && listGroupConcern.size() > 0) {
                    for (Customer360view.cls_GROUP_CONCERN_DETAILS groupConcernObj : listGroupConcern) {
                        Group_Concern__c gcObject = new Group_Concern__c();
                        if (groupConcernObj != null) {
                            If (!Utility.ISStringBlankorNull(groupConcernObj.GROUP_CONCERN_ID))
                                gcObject.id = groupConcernObj.GROUP_CONCERN_ID;
                            If (!Utility.ISStringBlankorNull(groupConcernObj.PAN_NUMBER))
                                gcObject.Pan_card_Number__c = groupConcernObj.PAN_NUMBER;
                            If (!Utility.ISStringBlankorNull(groupConcernObj.BANK_NAME))
                                gcObject.Bank_Name__c = groupConcernObj.BANK_NAME;
                            If (!Utility.ISStringBlankorNull(groupConcernObj.LIMIT_AMOUNT))
                                gcObject.Limit_Amount__c = Decimal.valueOf(groupConcernObj.LIMIT_AMOUNT);
                            If (!Utility.ISStringBlankorNull(groupConcernObj.TYPE))
                                gcObject.Type__c = groupConcernObj.TYPE;
                            if (groupConcernObj.GROUP_CONCERN_ID != null) {
                                listGroupConUpdate.add(gcObject);
                            } else {
                                gcObject.Group_1__c = customObj.LOS_CUSTOMER_SF_ID;
                                listGroupConInsert.add(gcObject);
                            }
                        }
                    }
                }
            }
            if (acc != null && acc.Id != null){
                If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY))
                    acc.Line_of_Activity__c = customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY;
                listaccount.add(acc);
            }

            If (customObj.COMPANY_DETAILS != null) {
                List<Customer360view.cls_DOCUMENT_SECTION> listDocumentSection = customObj.COMPANY_DETAILS.DOCUMENT_SECTION;
                Customer360view.cls_CURRENT_LOAN_APPLICATION currentLoanApp = customObj.COMPANY_DETAILS.CURRENT_LOAN_APPLICATION;
            }
            
            //List<Customer360view.cls_KEY_PERSON_DETAILS> listKeyPersonDetails =  customObj.KEY_PERSON_DETAILS;
            // KEY_PERSON_DETAILS
            if (listKeyPersonDetails != null && listKeyPersonDetails.size() > 0) {
                
                for (Customer360view.cls_KEY_PERSON_DETAILS kpd : listKeyPersonDetails) {
                    
                    Account accObj = new Account();
                    If (!Utility.ISStringBlankorNull(kpd.PASSPORT_NUMBER))
                        accObj.Passport_Number__pc = kpd.PASSPORT_NUMBER;
                    If (!Utility.ISStringBlankorNull(kpd.SEX))
                        accObj.Gender__pc = kpd.SEX;
                    If (!Utility.ISStringBlankorNull(kpd.NATIONALITY))
                        accObj.Nationality__pc = kpd.NATIONALITY ;
                    If (!Utility.ISStringBlankorNull(kpd.FATHER_NAME))
                        accObj.Father_Name__pc = kpd.FATHER_NAME;
                    If (!Utility.ISStringBlankorNull(kpd.MARITAL_STATUS))
                        accObj.Marital_Status__pc = kpd.MARITAL_STATUS;
                    If (!Utility.ISStringBlankorNull(kpd.SPOUSE_NAME))
                        accObj.Spouse_Name__pc = kpd.SPOUSE_NAME;
                    If (!Utility.ISStringBlankorNull(kpd.CASTE))
                        accObj.Caste__pc = kpd.CASTE;
                    If (!Utility.ISStringBlankorNull(kpd.RESIDENTIAL_STATUS))
                        accObj.Residential_Status__pc = kpd.RESIDENTIAL_STATUS;
                    If (!Utility.ISStringBlankorNull(kpd.DIN_NUMBER))
                        accObj.DIN_Number__pc = Decimal.valueOf(kpd.DIN_NUMBER);
                    If (!Utility.ISStringBlankorNull(kpd.LAND_AND_BUILDING))
                        accObj.Land_and_building__pc = kpd.LAND_AND_BUILDING;
                    If (!Utility.ISStringBlankorNull(kpd.LOCATION_TYPE))
                        accObj.Location_Type__pc = kpd.LOCATION_TYPE;
                    If (!Utility.ISStringBlankorNull(kpd.BUILT_UP_AREA))
                        accObj.Built_up_Area__pc = Decimal.valueOf(kpd.BUILT_UP_AREA);
                    If (!Utility.ISStringBlankorNull(kpd.NUMBER_OF_STOREYS))
                        accObj.Number_of_Storeys__pc = Decimal.valueOf(kpd.NUMBER_OF_STOREYS);
                    If (!Utility.ISStringBlankorNull(kpd.VALUE_OF_LAND_AND_BUILDING))
                        accObj.Value_Of_Land_Building__pc = Decimal.valueOf(kpd.VALUE_OF_LAND_AND_BUILDING);
                    If (!Utility.ISStringBlankorNull(kpd.ALREADY_CHARGED))
                        accObj.Already_Charged__pc = kpd.ALREADY_CHARGED;
                    If (!Utility.ISStringBlankorNull(kpd.JOINT_HOLDERS))
                        accObj.Joint_holder_CUTSTOMER_NAME__c = kpd.JOINT_HOLDERS;
                    If (!Utility.ISStringBlankorNull(kpd.TYPE_OF_LAND))
                        accObj.Type_of_Land__pc = kpd.TYPE_OF_LAND;
                    If (!Utility.ISStringBlankorNull(kpd.TYPE_OF_OWNERSHIP))
                        accObj.Type_of_Ownership__pc = kpd.TYPE_OF_OWNERSHIP;
                    If (!Utility.ISStringBlankorNull(kpd.AREA_OF_LAND))
                        accObj.Area_of_Land__pc = Decimal.valueOf(kpd.AREA_OF_LAND);
                    If (!Utility.ISStringBlankorNull(kpd.VALUE_OF_LAND))
                        accObj.Value_Of_Land__pc = Decimal.valueOf(kpd.VALUE_OF_LAND);
                    If (!Utility.ISStringBlankorNull(kpd.IS_PHYSTCALLY_HANDICAPPED))
                        accObj.Is_Physically_Handicapped__c = kpd.IS_PHYSTCALLY_HANDICAPPED == 'Yes' ? true : false;
                    If (!Utility.ISStringBlankorNull(kpd.IS_EXSERVICE_MAN))
                        accObj.Is_Ex_Service_Man__c = kpd.IS_EXSERVICE_MAN == 'Yes' ? true : false;
                    If(!Utility.ISStringBlankorNull(kpd.RELIGION))
                        accObj.Religion__c      = kpd.RELIGION;
                    If(!Utility.ISStringBlankorNull(kpd.RELIGION_CODE))
                        accObj.Religion_code__pc = kpd.RELIGION_CODE;
                    
                    //NETWORTH_DETAILS
                    List<Customer360view.cls_NETWORTH_DETAILS> netWorthDetailObjRecds = kpd.NETWORTH_DETAILS;
                    If (netWorthDetailObjRecds != null) {
                        for (Customer360view.cls_NETWORTH_DETAILS netWorthDetailObj : netWorthDetailObjRecds) {
                            If (netWorthDetailObj != null) {
                                Property__c propObj = new Property__c();
                                If (!Utility.ISStringBlankorNull(kpd.PRIMARY_DETAILS.LOS_PERSON_ACCOUNT_ID))
                                    propObj.Account__c = kpd.PRIMARY_DETAILS.LOS_PERSON_ACCOUNT_ID;
                                If (!Utility.ISStringBlankorNull(netWorthDetailObj.LOS_PROPERTY_ID))
                                    propObj.id = netWorthDetailObj.LOS_PROPERTY_ID;
                                If (!Utility.ISStringBlankorNull(netWorthDetailObj.Existing_Networth))
                                    propObj.Existing_Networth__c = Decimal.valueOf(netWorthDetailObj.Existing_Networth);
                                If (!Utility.ISStringBlankorNull(netWorthDetailObj.PROPERTY_TYPE))
                                    propObj.Property_Type__c = netWorthDetailObj.PROPERTY_TYPE;
                                If (!Utility.ISStringBlankorNull(netWorthDetailObj.PROPERTY_VALUE))
                                    propObj.Property_Value__c = Decimal.ValueOf(netWorthDetailObj.PROPERTY_VALUE);
                                If (netWorthDetailObj.ADDRESS != null) {
                                    Customer360view.cls_ADDRESS cusParAdd = netWorthDetailObj.ADDRESS;
                                    If (!Utility.ISStringBlankorNull(cusParAdd.STREET))
                                        propObj.Property_Street__c = cusParAdd.STREET;
                                    If (!Utility.ISStringBlankorNull(cusParAdd.CITY))
                                        propObj.Property_City__c = cusParAdd.CITY;
                                    If (!Utility.ISStringBlankorNull(cusParAdd.STATE))
                                        propObj.Property_State__c = cusParAdd.STATE;
                                    If (!Utility.ISStringBlankorNull(cusParAdd.PIN_CODE))
                                        propObj.Property_Pincode__c = cusParAdd.PIN_CODE;
                                    If (!Utility.ISStringBlankorNull(cusParAdd.COUNTRY))
                                        propObj.Property_Country__c = cusParAdd.COUNTRY;
                                }
                                If (!Utility.ISStringBlankorNull(netWorthDetailObj.LOS_PROPERTY_ID)) {
                                    listPropertyupdate.add(propObj);
                                } else {
                                    listPropertyinsert.add(propObj);
                                }
                            }
                        }
                    }
                    
                    // Communication Details
                    Customer360view.cls_COMMUNICATION_DETAILS objCommDetails = kpd.COMMUNICATION_DETAILS;
                    If (objCommDetails != null) {
                        If (!Utility.ISStringBlankorNull(objCommDetails.MOBILE_NUMBER))
                            accObj.PersonMobilePhone = objCommDetails.MOBILE_NUMBER;
                        If (!Utility.ISStringBlankorNull(objCommDetails.EMAIL_ADDRESS))
                            accObj.PersonEmail = objCommDetails.EMAIL_ADDRESS;
                        // PARMANENT_ADDRESS 
                        If (objCommDetails.PARMANENT_ADDRESS != null) {
                            Customer360view.cls_ADDRESS cusParAdd = objCommDetails.PARMANENT_ADDRESS;
                            If (!Utility.ISStringBlankorNull(cusParAdd.STREET))
                                accObj.PersonMailingStreet = cusParAdd.STREET;
                            If (!Utility.ISStringBlankorNull(cusParAdd.CITY))
                                accObj.PersonMailingCity = cusParAdd.CITY;
                            If (!Utility.ISStringBlankorNull(cusParAdd.STATE))
                                accObj.PersonMailingState = cusParAdd.STATE;
                            If (!Utility.ISStringBlankorNull(cusParAdd.PIN_CODE))
                                accObj.PersonMailingPostalCode = cusParAdd.PIN_CODE;
                            If (!Utility.ISStringBlankorNull(cusParAdd.COUNTRY))
                                accObj.PersonMailingCountry = cusParAdd.COUNTRY;
                        }
                        //kpd.COMMUNICATION_DETAILS.ADDRESS             = null;
                    }
                    Customer360view.cls_PRIMARY_DETAILS objPrimDetails = kpd.PRIMARY_DETAILS;
                    If (objPrimDetails != null) {
                        If (!Utility.ISStringBlankorNull(objPrimDetails.LOS_PERSON_ACCOUNT_ID))
                            accObj.Id = objPrimDetails.LOS_PERSON_ACCOUNT_ID;
                        If (!Utility.ISStringBlankorNull(objPrimDetails.FIRST_NAME))
                            accObj.FirstName = objPrimDetails.FIRST_NAME;
                        If (!Utility.ISStringBlankorNull(objPrimDetails.LAST_NAME)) {
                            accObj.LastName = objPrimDetails.LAST_NAME;
                        }
                        If (!Utility.ISStringBlankorNull(objPrimDetails.DESIGNATION))
                            accObj.Designation__pc = objPrimDetails.DESIGNATION;
                        If (!Utility.ISStringBlankorNull(objPrimDetails.DOB))
                            accObj.PersonBirthdate = Date.valueOf(objPrimDetails.DOB);
                        If (!Utility.ISStringBlankorNull(objPrimDetails.EDUCATIONAL_QUALIFICATION))
                            accObj.Education_Qualification__pc = objPrimDetails.EDUCATIONAL_QUALIFICATION;
                        If(!Utility.ISStringBlankorNull(objPrimDetails.EDUCATIONAL_QUALIFICATION_CODE))
                              accObj.Education_Qualification_code__pc     = objPrimDetails.EDUCATIONAL_QUALIFICATION_CODE;
                        If (!Utility.ISStringBlankorNull(objPrimDetails.AADHAAR_NUMBER)) {
                             accObj.Aadhaar_Number__pc = objPrimDetails.AADHAAR_NUMBER;
                            If (!Utility.ISStringBlankorNull(kpd.PARTY_TYPE))
                                mapPartyType.put(objPrimDetails.AADHAAR_NUMBER, kpd.PARTY_TYPE);
                        }
                        If (!Utility.ISStringBlankorNull(objPrimDetails.PAN_NUMBER))
                            accObj.Pan_Number__c = objPrimDetails.PAN_NUMBER;
                    }
                    //cls_SECTION_CHANGES
                    Customer360view.cls_SECTION_CHANGES sectionChangesObj = kpd.SECTION_CHANGES;
                    If (sectionChangesObj != null) {
                        If (!Utility.ISStringBlankorNull(sectionChangesObj.NAME))
                            accObj.Name_Of_Director_Related_To__c = sectionChangesObj.NAME;
                        If (!Utility.ISStringBlankorNull(sectionChangesObj.RELATIONSHIP))
                            accObj.Relationship__c = sectionChangesObj.RELATIONSHIP;
                        If (!Utility.ISStringBlankorNull(sectionChangesObj.BANK_NAME))
                            accObj.Bank_name__c = sectionChangesObj.BANK_NAME;
                        If (!Utility.ISStringBlankorNull(sectionChangesObj.IS_KVB_DIRECTOR))
                            accObj.Is_KVB_Director__c = sectionChangesObj.IS_KVB_DIRECTOR == 'Yes' ? true : false;
                    }
                    
                    //Parties's Update.
                    genesis__Application_Parties__c appPartyObj = new genesis__Application_Parties__c();
                    Boolean partyTypeFlag = false;
                    
                    If (!Utility.ISStringBlankorNull(kpd.PARTY_TYPE)) {
                        If (kpd.LOS_PARTY_TYPE_ID != null) {
                            if (!Utility.ISStringBlankorNull(kpd.DIGIO_STATUS)) appPartyObj.Status__c = kpd.DIGIO_STATUS;
                            appPartyObj.Id = kpd.LOS_PARTY_TYPE_ID;
                            appPartyObj.genesis__Party_Type__c = kpd.PARTY_TYPE;
                            listappparty.add(appPartyObj);
                            partyTypeFlag = true;
                        }
                    }
                    
                    if (!partyTypeFlag && !Utility.ISStringBlankorNull(kpd.LOS_PARTY_TYPE_ID) && !Utility.ISStringBlankorNull(kpd.DIGIO_STATUS)) {
                        appPartyObj.Id = kpd.LOS_PARTY_TYPE_ID;
                        appPartyObj.Status__c = kpd.DIGIO_STATUS;
                        listappparty.add(appPartyObj);
                    }
                    
                    If (!Utility.ISStringBlankorNull(kpd.DELETEKEYPERSON) && kpd.DELETEKEYPERSON == 'Yes') {
                        If (kpd.LOS_PARTY_TYPE_ID != null) {
                            appPartyObj.Id = kpd.LOS_PARTY_TYPE_ID;
                            appPartyObj.Active__c = false;
                            appPartyObj.Is_New__c = false;
                            If (kpd.CBS_CUSTOMER_ID != null && kpd.CBS_CUSTOMER_ID != '') {
                                listappparty.add(appPartyObj);
                            } else {
                                deleteappparty.add(appPartyObj);
                                partyIdObj.add(accObj.id);
                                deletePartyAcc.add(accObj);
                            }
                        }
                    }
                    
                    If (accObj != null) {
                        if (accObj.Id != null && !partyIdObj.contains(accObj.Id)) {
                            If (!Utility.ISStringBlankorNull(customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY))
                                accObj.Line_of_Activity__c = customObj.COMPANY_DETAILS.LINE_OF_ACTIVITY;
                            listaccount.add(accObj);
                        } else If (accObj.Id == null && kpd.LOS_PARTY_TYPE_ID == null) {
                            accObj.RecordTypeId = personAccountTypeId;
                            System.debug('kpd.PARTY_TYPE' + kpd.PARTY_TYPE);
                            newlistacc.add(accObj);
                        }
                    }
                    
                }
            }
        }
        
        If (listaccount.size() > 0) {
            System.debug('kpd.PARTY_TYPE' + listaccount);
            update listaccount;
        }
        /*If (newlistacc.size() > 0)
        insert newlistacc;*/
        if(newlistacc.size() > 0){
            Set<String> panLst= new Set<String>();
            Set<String> adharLst= new Set<String>();
            Map<String,Account> mapOfExistingAccount = new Map<String,Account>();
            for(Account newAcc: newlistacc){
                if(newAcc.Aadhaar_Number__pc != null){
                    adharLst.add(newAcc.Aadhaar_Number__pc);
                }else if(newAcc.Pan_Number__c != null){
                    panLst.add(newAcc.Pan_Number__c);
                } 
            }
            map<Id,Account> mapOfAccount= SOQL_Util.getKeyPersonDetails(panLst,adharLst);
            if(mapOfAccount !=null && mapOfAccount.size()> 0){
                for(Account accObject : mapOfAccount.values()){
                    if(accObject.Aadhaar_Number__pc !=null && accObject.Aadhaar_Number__pc !=''){
                        mapOfExistingAccount.put(accObject.Aadhaar_Number__pc,accObject);
                    }else if(accObject.Pan_Number__c !=null && accObject.Pan_Number__c !=''){
                        mapOfExistingAccount.put(accObject.Pan_Number__c,accObject);    
                    }
                }
            }
            for(Account ac: newlistacc){
                if(ac.Aadhaar_Number__pc !=null && mapOfExistingAccount.size() > 0 && mapOfExistingAccount.containsKey(ac.Aadhaar_Number__pc)){
                    ac.Id = mapOfExistingAccount.get(ac.Aadhaar_Number__pc).Id;
                    newOrExistingAccountList.add(ac);
                }else if(ac.Pan_Number__c !=null && mapOfExistingAccount.size() > 0 && mapOfExistingAccount.containsKey(ac.Pan_Number__c)){
                    ac.Id = mapOfExistingAccount.get(ac.Pan_Number__c).Id;
                    newOrExistingAccountList.add(ac);
                }else{
                    newOrExistingAccountList.add(ac);
                }  
            }
            if(newOrExistingAccountList.size()>0) upsert newOrExistingAccountList;
        }

        If (app != null && app.id != null){
            update app;
        }
        
        
        If (listPropertyinsert.size() > 0)
            insert listPropertyinsert;
        
        If (listPropertyupdate.size() > 0)
            UPDATE listPropertyupdate;
        // New Key Contact PartyType   
        try {
            if (newOrExistingAccountList != null) {
                for (Account accObj : newOrExistingAccountList) {
                    if (accObj != null) {
                        genesis__Application_Parties__c appPartyObj = new genesis__Application_Parties__c();
                        appPartyObj.genesis__Application__c = app.Id;
                        appPartyObj.genesis__Party_Account_Name__c = accObj.Id;
                        appPartyObj.Key_Contact__c = acc.Id;
                        appPartyObj.Active__c = true;
                        appPartyObj.Is_New__c = true;
                        appPartyObj.genesis__Party_Type__c = mapPartyType.get(accObj.Aadhaar_Number__pc);
                        appPartyObj.Product_Type__c = 'SME';
                        If (appPartyObj != null)
                            listappparty.add(appPartyObj);
                    }
                }
            }
            
            If (listappparty.size() > 0) {
                SendSMSService.Recusrive = false;
                upsert listappparty;
            }
            List<Account> listPartyAccount = new List<Account>();
            listPartyAccount.addAll(deletePartyAcc);
            If (listPartyAccount.size() > 0) {
                delete listPartyAccount;
            }
            If (deleteappparty.size() > 0) {
                delete deleteappparty;
            }
            if (listGroupConUpdate.size() > 0) {
                update listGroupConUpdate;
            }
            if (listGroupConInsert.size() > 0) {
                insert listGroupConInsert;
            }
            if (newRLPCTask.size() > 0) {
                TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
                try {
                    if(! Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExistForRLPC(customObj.LOS_APPLICATION_ID,Constants.RLPC_FINANCIAL_TASK))
                    insert newRLPCTask;
                } catch (Exception ex) {
                    //HandleBusinessException.captureError('SMELoan_Helper', 'getCustomAppDetailsUpdate', ex);
                    system.debug('No CLPC Task Error' + ex.getmessage());
                }
            }
            System.debug(customObj.LOS_APPLICATION_ID);
            System.debug(customObj.COMPANY_DETAILS.CUSTOMER_ID);
            
            return getCustomer(customObj.LOS_APPLICATION_ID, customObj.COMPANY_DETAILS.CUSTOMER_ID);
        } catch (Exception e) {
            //HandleBusinessException.captureError('SMELoan_Helper', 'getCustomAppDetailsUpdate', e);
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            return null;
        }
    }
    
    public static Decimal currencyFormatter(String amt) {
        if (amt == '' || amt == null) {
            RETURN 0.0;
        } else
            RETURN decimal.valueOf(amt.replace(',', ''));
    }
    
    
    //Added by : Souvik Banik.
    //Purpose  : Fetch Customer Feedback Details and returning Customer360view object.
    //Params   : Application Id and Customer360view object.
    public static Customer360view fetchCustomerFeedback(String appId, Customer360view custObj) {
        try {
            if (appId != null) {
                custObj.CUSTOMER_QUERY.ALL_QUERIES = new List<Customer360view.cls_CUSTOMER_QUERY>();
                List<Customer_Feedback__c> custFeedBackList = new List<Customer_Feedback__c>();
                custFeedBackList = SOQL_Util.getAllCustomerFeedback(appId);
                if (!custFeedBackList.isEmpty()) {
                    for (Customer_Feedback__c custFeedObj : custFeedBackList) {
                        Customer360view.cls_CUSTOMER_QUERY wrapObj = new Customer360view.cls_CUSTOMER_QUERY();
                        wrapObj.LOS_ID = custFeedObj.Id;
                        wrapObj.Question = custFeedObj.Question__c != null ? custFeedObj.Question__c : '';
                        wrapObj.Answer = custFeedObj.Answer__c != null ? custFeedObj.Answer__c : '';
                        wrapObj.Status = custFeedObj.Status__c != null ? custFeedObj.Status__c : '';
                        custObj.CUSTOMER_QUERY.ALL_QUERIES.add(wrapObj);
                    }
                }
            }
            return custObj;
        } catch (Exception e) {
            System.debug('Error Message---> ' + e.getMessage() + '---> ' + e.getCause() + 'Line no---> ' + e.getLineNumber() + 'StackTrace---> ' + e.getStackTraceString());
            return null;
        }
    }
    
    //Added by : Souvik Banik.
    //Purpose  : Fetch Digio Document Details.
    //Params   : Application Id.
    public static List<Customer360view.cls_Sanction_Document> getSanctionDocument(String appId) {
        try {
            List<Digio_Document_ID__c> digioDocList = new List<Digio_Document_ID__c>();
            if(appId != NULL){
                digioDocList = [SELECT Id,Application__r.Application_Stage__c,DMS_UUID__c,Name,Application__c,Error_Message__c,(Select id,eSigned__c,Party__c,Party__r.genesis__Party_Account_Name__c,Digio_Document_ID__c from Document_Applicants__r) FROM Digio_Document_ID__c WHERE Application__c =: appId];
            }
            Map<String,List<Digio_Document_ID__c>> finalMap = new Map<String,List<Digio_Document_ID__c>>();
            List<Customer360view.cls_Sanction_Document> allSanctionDocs = new List<Customer360view.cls_Sanction_Document>();
            for(Digio_Document_ID__c digioDocRec : digioDocList){
                System.debug(digioDocRec.Application__r.Application_Stage__c);
                System.debug(digioDocRec.Name);
                if(!(digioDocRec.Application__r.Application_Stage__c == 'Final Sanction' && digioDocRec.Name.contains('SME_ProvisionalSanctionLetter'))){
                    Customer360view.cls_Sanction_Document docObject = new Customer360view.cls_Sanction_Document();
                    docObject.Document_Id = digioDocRec.Id;
                    docObject.Document_Name = digioDocRec.Name;
                    docObject.DMS_UUID  = digioDocRec.DMS_UUID__c;
                    docObject.Signers                       = new List<Customer360view.cls_Signatory>();
                    for(Document_Applicant__c rec : digioDocRec.Document_Applicants__r){
                        Customer360view.cls_Signatory signer = new Customer360view.cls_Signatory();
                        signer.LOS_Party_Id                    = rec.Party__r.genesis__Party_Account_Name__c;
                        signer.IS_ESIGN_DONE                   = rec.eSigned__c;
                        signer.LOS_Digio_Status_Updation_Id    = rec.Id;
                        docObject.Signers.add(signer);
                    }
                    allSanctionDocs.add(docObject);
                }
            }   
            if(!allSanctionDocs.isEmpty())
                return allSanctionDocs;
            else
                return null;
        } catch (Exception e) {
            System.debug('Error  Message---> ' + e.getMessage() + '---> ' + e.getCause() + 'Line no---> ' + e.getLineNumber() + 'StackTrace---> ' + e.getStackTraceString());
            return null;
        }
    }
    
    
    public static List<Customer360view.cls_newFinacialDocuments> getUpdatedFinanialDocWrapper(Map<Id, genesis__Applications__c> applnInfo,List<genesis__Application_Document_Category__c> allOtherDocs,Set<String> allMissingYear, Boolean isCurrentYearDataAvailable){
        try {
            System.debug('applnInfo -> '+applnInfo);
            System.debug('allOtherDocs -> '+allOtherDocs);
            System.debug('allMissingYear -> '+allMissingYear);
            System.debug('isCurrentYearDataAvailable -> '+isCurrentYearDataAvailable);
            List<genesis__Application_Document_Category__c> currentYearData             = new List<genesis__Application_Document_Category__c>();
            List<genesis__Application_Document_Category__c> n_1_YearData                = new List<genesis__Application_Document_Category__c>();
            List<genesis__Application_Document_Category__c> n_2_YearData                = new List<genesis__Application_Document_Category__c>();
            List<Customer360view.cls_newFinacialDocuments> finWrapToReturn              = new List<Customer360view.cls_newFinacialDocuments>();
            Map<String,String> mapOfcurrentYearData         = new Map<String,String>();
            for(genesis__Application_Document_Category__c dCat:allOtherDocs){
                if((dCat.Name).contains(YearDataConstant.currFiscalYear)){
                    System.debug('@@@@@'+dCat.Name);
                    if( !dCat.Name.contains('Individual ITR') && !dCat.Name.contains('Constitution Deed Document') && !dCat.Name.contains('Constitution Supporting Document') && !dCat.Name.contains('Orders On Hand') && !dCat.Name.contains('Enhancement Documents') && !dCat.Name.contains('Query Followup') && !dCat.Name.contains('Legal Document') && !dCat.Name.contains('Legal Valuation')){
                        If( !mapOfcurrentYearData.containsKey(dCat.Name)){
                            currentYearData.add(dCat);
                            mapOfcurrentYearData.put(dCat.Name,dCat.Name);
                        }
                    }
                }
                else if((dCat.Name).contains(YearDataConstant.nthFiscalYear)){
                    System.debug('@@@@@'+dCat.Name);
                    n_1_YearData.add(dCat);
                }
                else if((dCat.Name).contains(YearDataConstant.n_1_FiscalYear)){
                    System.debug('@@@@@'+dCat.Name);
                    n_2_YearData.add(dCat);
                }
            }
            System.debug('currentYearData -> '+currentYearData);
            if(!currentYearData.isEmpty() && !isCurrentYearDataAvailable){
                Customer360view.cls_newFinacialDocuments       finWrap                  = new Customer360view.cls_newFinacialDocuments();
                finWrap.year                                                            = YearDataConstant.currFiscalYear;
                finWrap.Category_list                                                   = new List<DocumentFetch.DocumentCategory>();
                for(genesis__Application_Document_Category__c dCat:currentYearData){
                    DocumentFetch.DocumentCategory dCatObj = new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                    dCatObj.PARENT_CAT_NAME = dCat.Parent_Category_Name__c != null ? dCat.Parent_Category_Name__c:'';
                    if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0){
                        dCatObj.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';

                    }

                    finWrap.Category_list.add(dCatObj);
                }
                finWrapToReturn.add(finWrap);
            }
            System.debug('n_1_YearData ->'+n_1_YearData);
            if(!n_1_YearData.isEmpty() ){
                Customer360view.cls_newFinacialDocuments       finWrap                  = new Customer360view.cls_newFinacialDocuments();
                finWrap.year                                                            = YearDataConstant.nthFiscalYear;
                finWrap.Category_list                                                   = new List<DocumentFetch.DocumentCategory>();
                for(genesis__Application_Document_Category__c dCat:n_1_YearData){
                    DocumentFetch.DocumentCategory dCatObj = new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                    dCatObj.PARENT_CAT_NAME = dCat.Parent_Category_Name__c != null ? dCat.Parent_Category_Name__c:'';
                    if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0){
                        dCatObj.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';

                    }

                    finWrap.Category_list.add(dCatObj);
                }
                finWrapToReturn.add(finWrap);
            }
            System.debug('n_2_YearData -> '+n_2_YearData);
            if(!n_2_YearData.isEmpty()){
                Customer360view.cls_newFinacialDocuments       finWrap                  = new Customer360view.cls_newFinacialDocuments();
                finWrap.year                                                            = YearDataConstant.n_1_FiscalYear;
                finWrap.Category_list                                                   = new List<DocumentFetch.DocumentCategory>();
                for(genesis__Application_Document_Category__c dCat:n_2_YearData){
                    DocumentFetch.DocumentCategory dCatObj = new DocumentFetch.DocumentCategory(string.valueof(dCat.App_Doc_Category_No__c),dCat.Name,dCat.Id);
                    dCatObj.PARENT_CAT_NAME = dCat.Parent_Category_Name__c != null ? dCat.Parent_Category_Name__c:'';
                    if(dCat.genesis__AppDocCatAttachmentJunctions__r.size() > 0){
                        dCatObj.DMS_UUID = dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c !=null ? dCat.genesis__AppDocCatAttachmentJunctions__r[0].DMS_UUID__c : '';

                    }
                    finWrap.Category_list.add(dCatObj);
                }
                finWrapToReturn.add(finWrap);
            }
            return finWrapToReturn;
        } catch (Exception e) {
            System.debug('Error  Message-c--> ' + e.getMessage() + '---> ' + e.getCause() + 'Line no---> ' + e.getLineNumber() + 'StackTrace---> ' + e.getStackTraceString());
            return null;
        }
    }
    public static void downloadSignedDocument(Customer360view custObj){
        try{
            List<genesis__Applications__c> app = new List<genesis__Applications__c>();
            List<Attachment> attList = new List<Attachment>();
            List<Document_Applicant__c> applicantList = new List<Document_Applicant__c>();
            String docApplicantId = '';
            if(custObj.SANCTION_DOCUMENT_LIST != null){
                for(Customer360view.cls_Sanction_Document docRec : custObj.SANCTION_DOCUMENT_LIST){
                    if(docRec.Signers != null){
                        for(Customer360view.cls_Signatory  signatoryRec : docRec.Signers){
                            //if(signatoryRec.IS_ESIGN_DONE == true){
                                docApplicantId = signatoryRec.LOS_Digio_Status_Updation_Id;
                            //}
                        }
                    }
                }
            }
            if(docApplicantId != ''){
                applicantList = [SELECT Id,Digio_Document_ID__r.Document_ID__c FROM Document_Applicant__c WHERE Id =: docApplicantId];
                if(applicantList[0].Digio_Document_ID__r.Document_ID__c != null)
                    attList = [SELECT Id,Description FROM Attachment WHERE Id =: applicantList[0].Digio_Document_ID__r.Document_ID__c];
                if(attList.size() > 0 && attList[0].Description != null) Digioe_Docs_Service.downloadDocument(attList[0].Description);
            }
        }
        catch(Exception e){
            HandleBusinessException.captureError('SMELoan_Helper','downloadSignedDocument', e);
        }
    }
    public static String updateStockStatement(Customer360view customObj){
        try {
            List<Stock_Below_Limit__c> updateStockList = new List<Stock_Below_Limit__c>();
            List<Stocks__c> updateStocks = new List<Stocks__c>();
            // Stock Below Limit Update
            if (customObj.loanInfo != null && customObj.loanInfo.STOCK != null && customObj.loanInfo.STOCK.STOCK_STATEMENT != null) {
                for (Customer360view.cls_STOCK_STATEMENT stk : customObj.loanInfo.STOCK.STOCK_STATEMENT) {
                    if (stk.belowLimit != null) {
                        Stock_Below_Limit__c stock = new Stock_Below_Limit__c();
                        Stocks__c parent = new Stocks__c();
                        if (stk.belowLimit.LOS_RECORD_ID != null && stk.belowLimit.LOS_RECORD_ID != '') {
                            stock.Id = stk.belowLimit.LOS_RECORD_ID;
                        } else {
                            parent.Account__c = customObj.LOS_CUSTOMER_SF_ID;
                            parent.Year__c = stk.YEAR;
                            parent.Month__c = stk.MONTH;
                            parent.Unique_Key__c = customObj.CUSTOMER_ID + '_' + stk.MONTH + '_' + stk.YEAR;
                            updateStocks.add(parent);

                            stock.stocks__r = new Stocks__c(Unique_Key__c = parent.Unique_Key__c);
                        }

                        if (stk.belowLimit.OPENING_STOCK != null && stk.belowLimit.OPENING_STOCK != '')
                            stock.Opening_Stock__c = currencyFormatter(stk.belowLimit.OPENING_STOCK);
                        if (stk.belowLimit.PURCHASE != null && stk.belowLimit.PURCHASE != '')
                            stock.Purchases__c = currencyFormatter(stk.belowLimit.PURCHASE);
                        if (stk.belowLimit.SALES != null && stk.belowLimit.SALES != '')
                            stock.Sales__c = currencyFormatter(stk.belowLimit.SALES);
                        if (stk.belowLimit.SUNDRY_DEBT != null && stk.belowLimit.SUNDRY_DEBT != '')
                            stock.Sundry_Debtors__c = currencyFormatter(stk.belowLimit.SUNDRY_DEBT);
                        if (stk.belowLimit.SUNDRY_CREDIT != null && stk.belowLimit.SUNDRY_CREDIT != '') {
                            stock.Sundry_Creditors__c = currencyFormatter(stk.belowLimit.SUNDRY_CREDIT);
                        }
                        updateStockList.add(stock);
                    }
                }
                if (updateStocks.size() > 0) upsert updateStocks Unique_Key__c;
                if (updateStockList.size() > 0) upsert updateStockList;
            }
            return 'Stck Statement for customer has been update sucessfully.';
        } catch (Exception e) {
            HandleBusinessException.captureError('SMELoan_Helper','downloadSignedDocument', e);
            return 'Error ::: '+e.getMessage()+' AT '+e.getLineNumber()+' STACKTRACE '+e.getStackTraceString();
        }
    }
    
    // Probe42 callout.
    @future(callout = true)
    public static void getProbeDetails(String custId,String appId){
        If(custId !=null && custId !=''){
            WS_Probe42Data.getResponse(custId,appId);
        }
        
    }
}