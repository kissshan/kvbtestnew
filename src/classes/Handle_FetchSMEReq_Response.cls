/*
*/ 
public class Handle_FetchSMEReq_Response {
    
    public static Customer360view getApplicationInfo(string customerID, string appId){
        System.debug('appId=====> '+appId);
        Integer currentYear                                             = Utility.getCurrentYear();
        String cyString                                                 = String.valueOf(currentYear);
        String currentFY                                                = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
        String prevFY                                                   = (currentYear-2)+'-'+Integer.valueOf(String.valueOf(currentYear-1).subString(String.valueOf(currentYear-1).length()-2,String.valueOf(currentYear-1).length()));
        String nextEstFiscalYear                                        = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
        String nextProjFiscalYear                                       = (currentYear+1)+'-'+Integer.valueOf(String.valueOf(currentYear+2).subString(String.valueOf(currentYear+2).length()-2,String.valueOf(currentYear+2).length()));

        List<DocumentFetch.DocumentCategory> allDocCat                              = new List<DocumentFetch.DocumentCategory>();
        SMELoan_Helper.documentCategoryType                                         = new List<String>{'SME Financial Document','SME EME Document'};
        system.debug('=============Handle_FetchSMEReq_Response==================');
        map<Id,String> c1DocExistMap= SOQL_Util.C1ExistCheck(new Set<Id>{appId});

        Map<Id,genesis__Applications__c> applnMap                                   = SOQL_Util.getApplicationDetail(appId,customerID);
        
        genesis__Applications__c applInfo                                           = applnMap.values()[0];
        List<Facility__c> facilityList                                              = SOQL_Util.getFacilities(appID);
        Customer360view wrp                                                         = new Customer360view();
        
        wrp                                                                         = SMELoan_Helper.getCustomAppDetails(applnMap,customerID,appId,facilityList);
       
        wrp.LIMIT_ASSESMENT                                                          = new list<Customer360view.cls_LIMIT_ASSESMENT>();
        
       // wrp.MISSING_FINACIAL_YEARS                                                  = new List<String>();
        
        wrp.IS_C1_GENERATED= c1DocExistMap!=null && c1DocExistMap.containskey(appId) ? c1DocExistMap.get(appId) : 'false';
        wrp.LOS_QUESTION_NEW_LOAN                                                    = Utility.getBlankStringIfNull(applinfo.SME_New_Loan_Questions__c);

        wrp.CUSTOMER_ID                                                             = Utility.getBlankStringIfNull(applinfo.customerId__c);
        wrp.LOS_CUSTOMER_ID                                                         = Utility.getBlankStringIfNull(applinfo.genesis__Account__c);   
        wrp.APP_TYPE                                                                = applInfo.RecordType.DeveloperName;
        if(applInfo != null){
            if(applInfo.Cash_Flow_Method__c != null){
                wrp.COMPANY_DETAILS.cash_flow_method                                = applInfo.Cash_Flow_Method__c==true?'1':'0';
            }else{
                wrp.COMPANY_DETAILS.cash_flow_method ='0';
            }
        }
        wrp.COMPANY_DETAILS.BORROWER_NAME                                           = Utility.getBlankStringIfNull(applInfo.genesis__Account__r.Name);
        wrp.COMPANY_DETAILS.OPENING_BALANCE                                         = String.valueOf(applInfo.genesis__Account__r.Limit_Assesment_Closing_Balance__c);
        
        
        wrp.NEW_REQUEST                                                             = new Customer360view.cls_APP_REQUEST();
        wrp.NEW_REQUEST.REQ_REASON                                                  = '';
        wrp.NEW_REQUEST.REASON_FOR_APPLICATION                                      = '';
        wrp.NEW_REQUEST.LIMIT_PERIOD                                                = '';
        wrp.NEW_REQUEST.REQ_REASON                                                  = Utility.getBlankStringIfNull(applInfo.Request_Reason__c);
        wrp.NEW_REQUEST.REASON_FOR_APPLICATION                                      = Utility.getBlankStringIfNull(applInfo.Reason_for_Application__c);
        wrp.NEW_REQUEST.LIMIT_PERIOD                                                = Utility.getBlankStringIfNull(String.valueOf(applInfo.EAE_Renewal_Date_in_days__c));
        wrp.NEW_REQUEST.COLLATERAL_DETAILS                                          = new List<Customer360view.cls_NETWORTH_DETAILS>();
        wrp.NEW_REQUEST.COLLATERAL_DETAILS                                          = SMELoan_Helper_Fetch_Handler.getSecurityDeatils(applInfo.Id);
        wrp.NEW_REQUEST.FACILITY_INFO                                               = new List<Customer360view.cls_FACILITIES>();
        for(Facility__c fac : facilityList){
            Customer360view.cls_FACILITIES facInfo                                  = new Customer360view.cls_FACILITIES();
            facInfo.FACILITY_ID                                                     = fac.Id;
            facInfo.NAME_OF_THE_FACILITY                                         	= Utility.getBlankStringIfNull(fac.Product_Name__c); 
            facInfo.APPROVED_LIMIT                                                  = Utility.getBlankStringIfNull(String.valueOf(fac.Recommended_Limit__c));
            facInfo.ACCOUNT_NUMBER                                                  = Utility.getBlankStringIfNull(fac.Account_Number__c);
            facInfo.LIMIT_AMT                                                       = Utility.getBlankStringIfNull(String.Valueof(fac.Existing_Limit__c));
            facInfo.INTEREST_RATE                                                   = Utility.getBlankStringIfNull(String.Valueof(fac.Existing_Rate__c));
            facInfo.PRODUCT_CODE                                                    = Utility.getBlankStringIfNull(String.Valueof(fac.CL_Product__r.Product_Code__c));
            facInfo.NEW_LIMIT_AMT                                                   = Utility.getBlankStringIfNull(String.Valueof(fac.New_Limit_Amount__c));
            facInfo.BALANCE_OUTSTANDING												= Utility.getBlankStringIfNull(String.Valueof(fac.Balance_Outstandings__c));
            facInfo.MARGIN                                                   		= Utility.getBlankStringIfNull(String.Valueof(fac.Margin__c));
            facInfo.END_DATE                                                   		= Utility.getBlankStringIfNull(String.Valueof(fac.Limit_end_date__c));
            facInfo.CURRENT_LIMIT                                                   = Utility.getBlankStringIfNull(String.Valueof(fac.Existing_Limit__c));
            facInfo.PROPOSED_LIMIT                                                  = Utility.getBlankStringIfNull(String.Valueof(fac.Recommended_Limit__c));
            facInfo.REASON_FOR_ENHANCEMENT                                          = Utility.getBlankStringIfNull(fac.Reason_for_Enhancement__c);
            facInfo.IS_DELETED														= '';
            facInfo.PURPOSE_OF_LOAN													= Utility.getBlankStringIfNull(fac.Purpose_of_Loan__c);
            /* Added for New Doc flow - Vignesh*/
            if(applInfo.Application_Stage__c.contains('Final sanction offered')&&( applInfo.RecordType.DeveloperName=='SME_NEW_Loan' || applInfo.RecordType.DeveloperName== 'SME_Enhancement' || applInfo.RecordType.DeveloperName=='SME_AdHoc')){
                facInfo.MCLR_RATE= Utility.getBlankStringIfNull(String.Valueof(fac.MCLR_Rate__c));
                facInfo.Loan_Rate_of_Interest= Utility.getBlankStringIfNull(String.Valueof(fac.Recommended_Rate__c));
                facInfo.VALIDITY_PERIOD= applInfo.RecordType.DeveloperName== 'SME_AdHoc' ? Utility.getBlankStringIfNull(String.Valueof(fac.Recommended_Days__c)) : '365';
                facInfo.Preclosure_Charge= constants.Preclosure_Charge;
                facInfo.Penal_Charges= constants.Penal_Charges;
            }
            if(fac.New_Limit_Amount__c != null){
                facInfo.NEW_LIMIT_AMT                                               = String.valueOf(fac.New_Limit_Amount__c);
            }
            wrp.NEW_REQUEST.FACILITY_INFO.add(facInfo);
        }

        wrp.SUMMARY_VIEW.REQUEST_SUMMARY                                            = new Customer360view.cls_REQUEST_SUMMARY();
        wrp.SUMMARY_VIEW.REQUEST_SUMMARY.REASON_FOR_APPLICATION                     = Utility.getBlankStringIfNull(applInfo.Reason_for_Application__c);
        wrp.SUMMARY_VIEW.REQUEST_SUMMARY.LIMIT_PERIOD                               = Utility.getBlankStringIfNull(String.valueOf(applInfo.EAE_Renewal_Date_in_days__c));
        wrp.SUMMARY_VIEW.REQUEST_SUMMARY.FACILITY_INFO                              = new List<Customer360view.cls_FACILITIES>();
        for(Facility__c fac : facilityList){
            Customer360view.cls_FACILITIES facInfo                                  = new Customer360view.cls_FACILITIES();
            facInfo.FACILITY_ID                                                     = fac.Id;
            facInfo.NAME_OF_THE_FACILITY                                            = Utility.getBlankStringIfNull(fac.Product_Name__c);
            facInfo.APPROVED_LIMIT                                                  = Utility.getBlankStringIfNull(String.valueOf(fac.Recommended_Limit__c));
            facInfo.ACCOUNT_NUMBER                                                  = Utility.getBlankStringIfNull(fac.Account_Number__c);
            facInfo.LIMIT_AMT                                                       = Utility.getBlankStringIfNull(String.Valueof(fac.Existing_Limit__c));
            facInfo.INTEREST_RATE                                                   = Utility.getBlankStringIfNull(String.Valueof(fac.Existing_Rate__c));
            facInfo.PRODUCT_CODE                                                    = Utility.getBlankStringIfNull(String.Valueof(fac.CL_Product__r.Product_Code__c));
            facInfo.APPROVED_LIMIT                                                  = Utility.getBlankStringIfNull(String.Valueof(''));
            facInfo.BALANCE_OUTSTANDING                                             = Utility.getBlankStringIfNull(String.Valueof(''));
            facInfo.OVER_DUE                                                        = Utility.getBlankStringIfNull(String.Valueof(''));
            facInfo.TOTAL_LOAN_AMT                                                  = Utility.getBlankStringIfNull(String.Valueof(''));
            If(fac.New_Limit_Amount__c !=null){
                facInfo.NEW_LIMIT_AMT                                               = String.valueOf(fac.New_Limit_Amount__c);
                wrp.SUMMARY_VIEW.REQUEST_SUMMARY.FACILITY_INFO.add(facInfo);
            }
        }
       
        // DEBTORS CREDITORS DETAILS
        wrp.DEBTORS_CREDITORS_DETAILS                                               = new Customer360view.cls_DEBTORS_CREDITORS_INFO();
        wrp.DEBTORS_CREDITORS_DETAILS.DEBOTORS_AS_FINACIAL_END                      = new List<Customer360view.cls_DEBTORS_CREDITORS>();
        wrp.DEBTORS_CREDITORS_DETAILS.DEBOTORS_AS_CURRENT_DATE                      = new List<Customer360view.cls_DEBTORS_CREDITORS>();
        wrp.DEBTORS_CREDITORS_DETAILS.CREDITORS_AS_FINACIAL_END                     = new List<Customer360view.cls_DEBTORS_CREDITORS>();
        wrp.DEBTORS_CREDITORS_DETAILS.CREDITORS_AS_CURRENT_DATE                     = new List<Customer360view.cls_DEBTORS_CREDITORS>();
        
        for(Debtors__c  debrorsObj      :   SOQL_Util.getDebtors(applinfo.customerId__c)) {
            Customer360view.cls_DEBTORS_CREDITORS   debtorsCreditorsObj             =   new Customer360view.cls_DEBTORS_CREDITORS();
            //DEBOTORS_AS_FINACIAL_END 
            System.debug('Previous Fiscal Year'+currentFY);
            If(debrorsObj.Fiscal_Year__c  == currentFY){
                 debtorsCreditorsObj.NAME                                           =   Utility.getBlankStringIfNull(debrorsObj.Customer_Name__c);
                 debtorsCreditorsObj.LOS_RECORD_ID                                  =   Utility.getBlankStringIfNull(debrorsObj.id);
                 debtorsCreditorsObj.AGE                                            =   Utility.getBlankStringIfNull(debrorsObj.Age__c);
                 debtorsCreditorsObj.AMOUNT                                         =   Utility.getBlankStringIfNull(String.valueOf(debrorsObj.Amount_Collected__c));
                 wrp.DEBTORS_CREDITORS_DETAILS.DEBOTORS_AS_FINACIAL_END.add(debtorsCreditorsObj);
            }
            else If(debrorsObj.Fiscal_Year__c  == nextEstFiscalYear){
                System.debug('Fiscal Year'+nextEstFiscalYear);
                 debtorsCreditorsObj.NAME                                           =   Utility.getBlankStringIfNull(debrorsObj.Customer_Name__c);
                 debtorsCreditorsObj.LOS_RECORD_ID                                  =   Utility.getBlankStringIfNull(debrorsObj.id);
                 debtorsCreditorsObj.AGE                                            =   Utility.getBlankStringIfNull(debrorsObj.Age__c);
                 debtorsCreditorsObj.AMOUNT                                         =   Utility.getBlankStringIfNull(String.valueOf(debrorsObj.Amount_Collected__c));
                 wrp.DEBTORS_CREDITORS_DETAILS.DEBOTORS_AS_CURRENT_DATE.add(debtorsCreditorsObj);
            }
        }
        for(Sundry_Creditors__c sundryCreditorsObj      :   SOQL_Util.getSundryCreditors(applinfo.customerId__c)) {
            Customer360view.cls_DEBTORS_CREDITORS   debtorsCreditorsObj             =   new Customer360view.cls_DEBTORS_CREDITORS();
            //CREDITORS_AS_FINACIAL_END 
            If(sundryCreditorsObj.Fiscal_Year__c  == currentFY){
                 debtorsCreditorsObj.NAME                                           =   Utility.getBlankStringIfNull(sundryCreditorsObj.Name_Of_Trade_Creditors__c);
                 debtorsCreditorsObj.LOS_RECORD_ID                                  =   Utility.getBlankStringIfNull(sundryCreditorsObj.id);
                 debtorsCreditorsObj.AGE                                            =   Utility.getBlankStringIfNull(sundryCreditorsObj.Age__c);
                 debtorsCreditorsObj.AMOUNT                                         =   Utility.getBlankStringIfNull(String.valueOf(sundryCreditorsObj.Amount_To_Be_Paid__c));
                 wrp.DEBTORS_CREDITORS_DETAILS.CREDITORS_AS_FINACIAL_END.add(debtorsCreditorsObj);
            }else If(sundryCreditorsObj.Fiscal_Year__c  == nextEstFiscalYear){
                 debtorsCreditorsObj.NAME                                           =   Utility.getBlankStringIfNull(sundryCreditorsObj.Name_Of_Trade_Creditors__c);
                 debtorsCreditorsObj.LOS_RECORD_ID                                  =   Utility.getBlankStringIfNull(sundryCreditorsObj.id);
                 debtorsCreditorsObj.AGE                                            =   Utility.getBlankStringIfNull(sundryCreditorsObj.Age__c);
                 debtorsCreditorsObj.AMOUNT                                         =   Utility.getBlankStringIfNull(String.valueOf(sundryCreditorsObj.Amount_To_Be_Paid__c));
                 wrp.DEBTORS_CREDITORS_DETAILS.CREDITORS_AS_CURRENT_DATE.add(debtorsCreditorsObj);
            }
        }
      
        wrp.DOWNLOADABLE_TEMPLATES                                                  = new List<Customer360view.cls_TEMPLATES>();
        Customer360view.cls_TEMPLATES templates                                     = new Customer360view.cls_TEMPLATES();
        templates.TEMPLATE_LABEL                                                    = 'LIMIT_ASSESMENT_TEMPLATE';
        templates.TEMPLATE_LINK                                                     = 'https://kvb--SIT.cs58.my.salesforce.com/sfc/p/0l000000D0fN/a/0l0000008QiO/nh5STftZx4Odi9T4PuWH99ZKu9zZoeOlwA9mntFvo3A';
        wrp.DOWNLOADABLE_TEMPLATES.add(templates);
        /*Term Loan */
        //system.debug('wrp=========>1 '+wrp.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION);
        //system.debug('wrp=========>2 '+wrp.COMPANY_DETAILS.NEW_FACILITY_QUESTION);

        Customer360view questionWrp=  SecurityCoverageRefactorModel.getQuestionAnswerList(appId);
        system.debug('questionWrp====> '+questionWrp.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION);
        //wrp.COMPANY_DETAILS
        wrp.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION= new List<Customer360view.QuestionAndAnswer>();
        wrp.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION = questionWrp.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION;
        wrp.COMPANY_DETAILS.NEW_FACILITY_QUESTION= new List<Customer360view.QuestionAndAnswer>();
        //questionWrp.COMPANY_DETAILS.EXISTING_FACILITY_QUESTION;
        wrp.COMPANY_DETAILS.NEW_FACILITY_QUESTION= questionWrp.COMPANY_DETAILS.NEW_FACILITY_QUESTION;
        return wrp;
    }
   
}