/*
* Name     : SOQL_Util
* Company  : ET Marlabs
* Purpose  : This class is used as an utility for all SOQL Queries
* Author   : Amritesh
*/
global class SOQL_Util {
    public static Set<String> dedupePancard = new Set<String>();
    public static Set<String> dedupeAadharReferece = new Set<String>();
    public static Boolean personDedupeFailed = false;
    public static List<genesis__Applications__c> getApplicationList(string branchCode){
        String queryString      = 'Select Id,Name,RecordType.DeveloperName,CustomerID__c,genesis__Account__c,genesis__Account__r.Name,Loan_Account_Number__c,Renewal_Due_Date__c,genesis__Loan_Amount__c,Pre_Renewal_Checklist__c,Application_Status__c,Application_UI_Stage__c,Application_Stage__c, (select id,Existing_Limit__c,Balance_Outstandings__c from Facilities__r)from genesis__Applications__c';
        queryString             += ' where genesis__CL_Product__c =:productId AND Branch_Code__c =:branchCode AND RecordTypeId =:rtypeID AND Active__c = true';
        return database.query(queryString);
        //  Renewal_Due__c = true --Condition needs to be added
    }
    public static List<genesis__Applications__c> getApplicationList(string branchCode, string rtypeID, string productId){
        String queryString      = 'Select Id,Name,RecordType.DeveloperName,CustomerID__c,genesis__Account__c,genesis__Account__r.Name,Loan_Account_Number__c,Renewal_Due_Date__c,genesis__Loan_Amount__c,Pre_Renewal_Checklist__c,Application_Status__c,Application_UI_Stage__c,Application_Stage__c, (select id,Existing_Limit__c,Balance_Outstandings__c from Facilities__r)from genesis__Applications__c';
        queryString             += ' where genesis__CL_Product__c =:productId AND Branch_Code__c =:branchCode AND RecordTypeId =:rtypeID AND Active__c = true';
        return database.query(queryString);
        // Renewal_Due__c = true --Condition needs to be added
    }
    
    public static List<genesis__Applications__c> getApplicationList(List<string> appIds){
        String queryString      = 'Select Id,Name,RecordType.DeveloperName,CustomerID__c,genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.CBS_Customer_ID__c,Loan_Account_Number__c,Renewal_Due_Date__c,genesis__Loan_Amount__c,Pre_Renewal_Checklist__c,Application_Status__c,Application_UI_Stage__c,Application_Stage__c, (select id,Existing_Limit__c,Balance_Outstandings__c from Facilities__r where Active__c = true)from genesis__Applications__c';
        queryString             += ' where Id IN:appIds AND  Active__c = true';
        return database.query(queryString);
        // Renewal_Due__c = true --Condition needs to be added
    }
    
    public static List<genesis__Applications__c> getCustApplicationList(string CustId, string rtypeID, string productId){
        String queryString      = 'Select Id,Name,RecordType.DeveloperName,CustomerID__c,genesis__Account__c,genesis__Account__r.Name,Loan_Account_Number__c,Renewal_Due_Date__c,Pre_Renewal_Checklist__c,Application_Status__c,Application_UI_Stage__c,Application_Stage__c,(select id,Existing_Limit__c,Balance_Outstandings__c from Facilities__r) from genesis__Applications__c';
        queryString             += ' where Renewal_Due__c = true AND genesis__CL_Product__c =:productId AND CustomerID__c =:CustId AND RecordTypeId =:rtypeID';
        return database.query(queryString);
    }
    
    public static List<genesis__Applications__c> getApplicationListForFetchCustomerList(List<string> appIds){
        List<String> closeStageList = new List<String>{'Limit renewed/Application close','Application close - enhancement','Enhancement Application close','Exceeding Application close','Adhoc Application close','New loan - Application close','Discontinued Application','Limit Opened'};
        String queryString      = 'Select Id,genesis__Product_Type__c,Name,Renewal_Due_Date__c,Type__c,RecordType.DeveloperName,CustomerID__c,genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.CBS_Customer_ID__c,Loan_Account_Number__c,genesis__Loan_Amount__c,Pre_Renewal_Checklist__c,Application_Status__c,Application_UI_Stage__c,Application_Stage__c, (select id,Existing_Limit__c,CL_Product__r.Id,CL_Product__r.Product_Code__c,Account_Number__c,Balance_Outstandings__c,Limit_Amount__c,CL_Product__c,Product_Name__c from Facilities__r where Active__c = true)from genesis__Applications__c';
        queryString             += ' where Id IN:appIds AND Application_Stage__c NOT IN :closeStageList AND Active__c = true';
        return database.query(queryString);
        //// Renewal_Due__c = true --Condition needs to be added
    }
    
    public static List<Account> getAllCustomerByBranchCode(string branchCode) {
        // return [SELECT Id,Name,CBS_Customer_ID__c,(SELECT Id,Renewal_Due_Date__c,Application_Stage__c,Application_UI_Stage__c from genesis__Applications_account__r) from Account where Branch_Code__c=:branchCode And RecordType.DeveloperName=:Constants.BUSINESS_ACCOUNT];
        return [SELECT Id,Name,CBS_Customer_ID__c,(SELECT Id,Renewal_Due_Date__c,Application_Stage__c,Application_UI_Stage__c from genesis__Applications_account__r where Branch_Code__c=:branchCode) from Account where Id IN (select genesis__Account__c from genesis__Applications__c where Branch_Code__c=:branchCode) And RecordType.DeveloperName=:Constants.BUSINESS_ACCOUNT];
        
    }
    
    public static string getProductID(String productCode){
        return [Select id from clcommon__CL_Product__c where Product_Code__c =:productCode LIMIT 1].Id;
    }
    
    public static string getRecordTypeId(String rtypeName){
        return [Select id from RecordType where DeveloperName =:rtypeName].Id;
    }
    public static string getRecordTypeIdBySobject(String rtypeName,String obj){
        return [SELECT id,SobjectType,IsActive FROM RecordType WHERE IsActive = TRUE AND DeveloperName =: rtypeName AND SobjectType =: obj].Id;
    }
    
    public static string getCustomerRecordType(string customerId){
        return [Select Id,recordtypeId,recordtype.DeveloperName from Account where CBS_Customer_ID__c =:customerId limit 1].recordtype.DeveloperName;
    }
    
    public static Account getAccountAudit(string accountId){
        return [Select Id,CBS_Customer_ID__c,Branch_Code__c from Account where Id=:accountId limit 1];
    }
    
    // Get Application Facilities info
    public static List<Facility__c> getFacilities(string appId){
        if(appId != null && appId != '')
            return [Select Id,BRE_Limit__c,Type__c,MCLR_Rate__c,CL_Product__r.Facility_Code__c,Tenure__c,Holiday_Period__c,Recommended_Days__c,Recommended_Rate__c,Existing_Spread__c,Recommended_Limit__c,CL_Product__c,CL_Product__r.clcommon__Product_Name__c,CL_Product__r.CIBIL_Required__c,Limit_Amount__c,Existing_Limit__c,Existing_Rate__c,CL_Product__r.Product_Code__c,
                    Account_Number__c,Application__c,Purpose_of_Loan__c,Total_Loan_Amount__c,Balance_Outstandings__c,New_Limit_Amount__c,Over_Due__c,Product_Name__c,Requested_Amount__c,Limit_Period_In_Days__c,
                    Margin__c,Limit_end_date__c,Bank_Statement_from_Date__c,Bank_Statement_to_Date__c,Bank_Name__c,Type_of_Loan__c,Limit_start_date__c,Takeover__c,NTB_Facility_Category__c,
                    Purpose_of_Shifting__c,NTB_Product_Type__c,Start_Date_Other__c,NTB_Facility_Type__c,Other_Facility_Name__c,Unique_Number_for_NTB__c,Reason_for_Enhancement__c,Date_of_Document__c,
                    (SELECT Id FROM Facility_Security__r)
                    from Facility__c where Application__c=:appId AND RecordType.DeveloperName ='Parent'];
        else
            return null;
    }
    public static List<Facility__c> getFacilityList(List<String> appIdList){
        return [Select Id,Recommended_Days__c,Existing_Spread__c,Application__r.Sanction_Date__c,Application__r.OD_limit_creation_updation__c,Limit_Amount__c,Processing_Charge__c,Variance__c,Application__r.Next_Renewal_Date__c,Application__r.Cibil_Charges__c,Limit_start_date__c,Limit_end_date__c,Due_Date__c,Existing_Limit__c,Final_Spread__c,Recommended_Rate__c,Recommended_Limit__c,Application__r.Sanction_Authority__c,Application__r.Renewal_Due_Date__c,Application__r.genesis__Account__r.Branch_Code__c,Application__c,Application__r.Name,Recommended_Processing_Charge__c,CL_Product__c,CL_Product__r.clcommon__Product_Name__c,Existing_Rate__c,
                Account_Number__c,Total_Loan_Amount__c,NTB_Facility_Type__c,Balance_Outstandings__c,New_Limit_Amount__c,Over_Due__c,CL_Product__r.Product_Code__c,Product_Name__c,Requested_Amount__c,Limit_Period_In_Days__c,Application__r.RecordType.DeveloperName,Application__r.EAE_Renewal_Date_in_days__c,
                (SELECT Id FROM Facility_Security__r)
                from Facility__c where Application__c IN :appIdList AND RecordType.DeveloperName ='Parent' AND Type__c = 'Funded'];
    }
    public static List<Facility__c> getLoanFacilityList(Set<Id> accIdList){
        return [Select Id,Limit_end_date__c,Due_Date__c,Recommended_Limit__c,Recommended_Rate__c,Limit_Amount__c,Application__r.Renewal_Due_Date__c,Application__r.genesis__Account__r.Branch_Code__c,Application__c,Application__r.Name,Recommended_Processing_Charge__c,CL_Product__c,CL_Product__r.clcommon__Product_Name__c,Existing_Rate__c,
                Account_Number__c,Total_Loan_Amount__c,Balance_Outstandings__c,New_Limit_Amount__c,Over_Due__c,CL_Product__r.Product_Code__c,Existing_Limit__c,Product_Name__c,Requested_Amount__c,Limit_Period_In_Days__c,Date_of_Document__c
                from Facility__c where Application__r.genesis__Account__c IN :accIdList AND RecordType.DeveloperName ='Parent' AND Application__r.RecordType.DeveloperName = 'Term_Loan'];
    }
    
    public static List<Customer_Feedback__c> getAllCustomerFeedback(String appId){
        List<Customer_Feedback__c> custFeedbackList = new List<Customer_Feedback__c>();
        If(appId != null){
            custFeedbackList = [SELECT Id,Name,Application__c,Question__c,Answer__c,Status__c FROM Customer_Feedback__c
                                WHERE Application__c =: appId];
        }
        return custFeedbackList;
        
    }
    
    public static Map<Id,genesis__Applications__c> getApplicationDetail(string appId, string customerId){
        String custRecordType   = getCustomerRecordType(customerId);
        Map<Id,genesis__Applications__c> appln = new Map<Id,genesis__Applications__c>();
        if(custRecordType == Constants.BUSINESS_ACCOUNT){
            // put Overall_Exposure__c in below query
            appln   = new Map<Id,genesis__Applications__c>([select id,Bureau_Fees_GST__c,CommercialPR_Stage__c,EMINMI__c,Valuation_Charges_with_GST__c,Valuation_Charges__c,Legal_Opinion_with_GST__c,Legal_Charges__c,Legal_Charges_Result__c,UNIQUE_KEY__c,Processing_Fee_Result__c  ,Net_Banking_Flag__c,Bureau_Fee__c,Bureau_Fee_Result__c,Type_of_Application__c,Overall_Exposure__c,SME_New_Loan_Questions__c,Critical_Change_done__c,Sub_Stage__c,Approved_Loan_Amount__c,Total_Networth__c,Total_Outstanding_Liabilities__c,Original_Amount_Investments__c,Type__c,Application_to_close__c,Parent_Application__c,is_Probe_42__c,Enhancement_reason__c,Name,Application_UI_Stage__c,Loan_Account_Number__c,Deleted_Person__c,Recommended_Final_Rate_of_Interest__c,Sundry_Creditor_Atual__c,Sundry_Creditor_Estimated__c,Sundry_Creditor_Projected__c,
                                                            Credit_Bureau_Check__c,genesis__Account__r.Profit_after_tax__c,genesis__Account__r.Net_Fixed_Asset_Land_and_Building__c,genesis__Account__r.Net_Fixed_Asset_Plant_and_Machinery__c,genesis__Account__r.Previous_Year_Growth_Rate__c,genesis__Account__r.Udyog_Adhaar_Number__c,
                                                            genesis__Account__r.Primary_Bank_Name__c,genesis__Account__r.Primary_IFSC_Code__c,genesis__Account__r.Primary_Branch_Name__c,genesis__Account__r.Primary_Account_Number__c,
                                                            New_to_Business__c,Key_person_change_done__c,Branch_Code__c,Branch_Name__c,genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.Contact_Person_Name__c,PG_Status__c,Renewal_Due_Date__c,
                                                            Request_Reason__c,EAE_Renewal_Date_in_days__c,Reason_for_Application__c,genesis__Account__r.Contact_Person_Designation__c,genesis__Account__r.Previous_Constitution__c,genesis__Account__r.Line_of_Activity__c,genesis__Account__r.CIN_Number__c,Application_Status__c,Cash_Flow_Method__c,
                                                            genesis__Account__r.Cust_mobile_phone__c,genesis__Account__r.Date_of_Institution__c,genesis__Account__r.Pan_Number__c,genesis__Account__r.IE_Code__c,genesis__Loan_Amount__c,genesis__Account__r.Designation__pc,CustomerID__c,genesis__Account__r.Group_Name__c,genesis__Account__r.Reasons_for_exemption_from_GST__c,genesis__Account__r.Annual_TurnoverIncome__c,
                                                            genesis__Account__r.Company_Email__c,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.Education_Qualification__pc,genesis__Account__r.PersonBirthdate,Application_Stage__c,Sanction_ESign_Id__c,RecordType.DeveloperName,genesis__Account__r.Principal_nature_of_business__c,genesis__Account__r.Cash_Budget__c,
                                                            genesis__Account__r.PersonMobilePhone,genesis__Account__r.PersonEmail,genesis__Account__r.BillingStreet,genesis__Account__r.Number_of_Shares_Held__c,RecordTypeId,genesis__Account__r.UAM_Number__c,genesis__Account__r.Major_Activity__c,genesis__Account__r.Enterprise_Type__c,genesis__Account__r.Activity_Type__c,
                                                            genesis__Account__r.BillingCity,genesis__Account__r.Limit_Assesment_Closing_Balance__c,genesis__Account__r.BillingPostalCode,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__Account__r.Latest_Date_Of_Reconstitution__c,
                                                            genesis__Account__r.ShippingStreet,genesis__Account__r.ShippingCity,genesis__Account__r.ShippingPostalCode,genesis__Account__r.Amount_of_Shares__pc,genesis__Account__r.Name_Of_Director_Related_To__c,genesis__Account__r.Bank_name__c,genesis__Account__r.Relationship__c,genesis__Account__r.is_Section_20__c,
                                                            genesis__Account__r.Balance_Outstandings__c,genesis__Account__r.Name_of_Facility__c,genesis__Account__r.Related__c,genesis__Account__r.ShippingState,genesis__Account__r.ShippingCountry,genesis__Account__r.Percentage_of_holding__pc,genesis__Interest_Rate__c,
                                                            genesis__Margin__c,genesis__Account__r.Group__c,genesis__Account__r.Date_of_Incorporation__c,genesis__Account__r.Name__c,genesis__Account__r.Constitution__c,genesis__Account__r.Present_interest__c,genesis__Account__r.Phone,genesis__Account__r.Line_of_Activity_code__c,
                                                            genesis__Account__r.Priority_Sector__c,genesis__Account__r.Over_Due__c,genesis__Account__r.Industry_Type__c,genesis__Account__r.Firm_Company_was_Reconstituted__c,genesis__Account__r.GST_Number__c,genesis__Account__r.Total_Loan_Amount__c,
                                                            (Select id,genesis__Collateral__r.clcommon__City__c,genesis__Collateral__r.clcommon__Collateral_Category__r.Name,genesis__Collateral__r.clcommon__Collateral_Name__c,genesis__Collateral__r.clcommon__Collateral_Type__r.Name,genesis__Collateral__r.clcommon__Collateral_Type__c,
                                                             genesis__Collateral__r.clcommon__Collateral_Category__c,Facility__c,Account__c,Application__c,genesis__Collateral__r.id,genesis__Collateral__r.clcommon__Value__c,genesis__Collateral__r.Ownership_Type__c,genesis__Collateral__r.clcommon__Address__c,
                                                             genesis__Collateral__r.clcommon__Value_Date__c,genesis__Collateral__r.Total_Asset_Value__c,genesis__Collateral__r.Nature_of_Property__c,genesis__Collateral__r.Commercial_Vehicle_Category__c,genesis__Collateral__r.SurveyKhasraKhataPatta_No__c,genesis__Collateral__r.MORT_TYPE__c,genesis__Collateral__r.Collateral_Category__c,genesis__Collateral__r.Door__c,
                                                             genesis__Collateral__r.Percentage_of_Ownership__c,genesis__Collateral__r.Landmark__c,genesis__Collateral__r.TalukaTehsil__c,genesis__Collateral__r.Area_Square_Feet__c,genesis__Collateral__r.Street_NameNo__c,genesis__Collateral__r.State__c,genesis__Collateral__r.Country__c,genesis__Collateral__r.clcommon__Postal_Code__c,Security_Type__c from Application_Collateral__r),
                                                            (Select id,genesis__Application__c,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.LastName,genesis__Party_Account_Name__r.Name,
                                                             genesis__Party_Account_Name__r.Passport_Number__pc, genesis__Party_Account_Name__r.Gender__pc,genesis__Party_Account_Name__r.Nationality__pc,
                                                             genesis__Party_Account_Name__r.Father_Name__pc ,genesis__Party_Account_Name__r.Marital_Status__pc,genesis__Party_Account_Name__r.Designation__pc,
                                                             genesis__Party_Account_Name__r.Caste__pc,genesis__Party_Account_Name__r.DIN_Number__pc,genesis__Party_Account_Name__r.Pan_Number__c,
                                                             genesis__Party_Account_Name__r.Location_Type__pc,genesis__Party_Account_Name__r.Built_up_Area__pc,genesis__Party_Account_Name__r.Number_of_Storeys__pc,
                                                             genesis__Party_Account_Name__r.Joint_holder_CUTSTOMER_NAME__c,genesis__Party_Account_Name__r.Value_Of_Land_Building__pc,
                                                             genesis__Party_Account_Name__r.Land_and_building__pc,genesis__Party_Account_Name__r.Residential_Status__pc,genesis__Party_Account_Name__r.Spouse_Name__pc,
                                                             genesis__Party_Account_Name__r.Already_Charged__pc,genesis__Party_Account_Name__r.Type_of_Land__pc,genesis__Party_Account_Name__r.Type_of_Ownership__pc,
                                                             genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.CBS_Customer_ID__c,genesis__Party_Account_Name__r.Area_of_Land__pc,
                                                             genesis__Party_Account_Name__r.Education_Qualification__pc,genesis__Party_Account_Name__r.Net_Worth__pc,genesis__Party_Account_Name__r.Value_Of_Land__pc,
                                                             genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.Name_Of_Director_Related_To__c,
                                                             genesis__Party_Account_Name__r.PersonMailingState,genesis__Party_Account_Name__r.PersonMailingPostalCode,genesis__Party_Account_Name__r.Relationship__c,
                                                             genesis__Party_Account_Name__r.Previous_Contact_Number__c,genesis__Party_Account_Name__r.Previous_Contact_Person__c,genesis__Party_Account_Name__r.Bank_name__c,
                                                             genesis__Party_Account_Name__r.Previous_GST_Number__c,genesis__Party_Account_Name__r.Previous_Whether_the_firm_was_reconstitu__c,genesis__Party_Account_Name__r.Is_KVB_Director__c,
                                                             genesis__Party_Account_Name__r.Previous_Address_of_Land__pc,genesis__Party_Account_Name__r.Previous_Education_Qualification__pc,genesis__Party_Account_Name__r.Religion_code__pc,
                                                             genesis__Party_Account_Name__r.Previous_Net_Worth__pc,genesis__Party_Account_Name__r.Previous_Type_of_Land__pc,genesis__Party_Account_Name__r.Previous_Value_of_Land__pc,genesis__Party_Account_Name__r.Religion__c,
                                                             genesis__Party_Account_Name__r.PersonMailingCountry,genesis__Party_Account_Name__r.Guarantor_Networth__c,Guarantor__c,genesis__Party_Account_Name__r.Existing_Networth__c,genesis__Party_Account_Name__r.Education_Qualification_code__pc,
                                                             genesis__Party_Account_Name__r.Property_City__c,genesis__Party_Account_Name__r.Property_Country__c,genesis__Party_Account_Name__r.Property_State__c,
                                                             genesis__Party_Account_Name__r.Property_Street__c,genesis__Party_Account_Name__r.Property_Type__c,genesis__Party_Account_Name__r.Property_Value__c,genesis__Party_Account_Name__r.Propety_Pincode__c,
                                                             genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Is_Physically_Handicapped__c,genesis__Party_Account_Name__r.Is_Ex_Service_Man__c,
                                                             Key_Contact__c,genesis__Party_Account_Name__r.PersonBirthdate,genesis__Party_Account_Name__c,genesis__Party_Type__c,Active__c,Is_New__c,is_Deleted__c,Critical_Change__c,Status__c,Product_Type__c from genesis__Application_Parties__r WHERE Active__c = true),
                                                            (SELECT Id,Original_Tenure__c,App_Facility_Type__c,Facility_Product_category__c,CL_Product__r.Facility_Code__c,Existing_Limit__c,Limit_Amount__c,Balance_Outstandings__c,Amount_Yet_disbursed__c,Existing_Spread__c,Account_Number__c,CL_Product__r.clcommon__Product_Name__c,NTB_Facility_Type__c,Requested_Amount__c,New_Limit_Amount__c,Interest_Rate__c,
                                                              Primary_Security_Requested__c,Collateral_Security_Requested__c,Type_Of_Request__c,Bank_Institution__c,  
                                                             Date_of_Disbursement__c,Margin__c,Facility_Sequence_Number__c,Repayment_Type__c,Purpose_of_Loan__c,Applicant_Contribution__c,One_Time_LC_BG__c,MCLR_Rate__c,Existing_Rate__c,Recommended_Days__c,Recommended_Rate__c,Sanction_Limit__c,Limit_end_date__c,Loan_Purpose__c,Product_Name__c,Recommended_Limit__c,CL_Product__c,Unique_Number_for_NTB__c,Nature_of_Advance__c,NTB_Product_Type__c,Bank_Name__c,External_Id__c,NTB_Facility_Category__c,Tenure__c,Holiday_Period__c,Current_Outstanding__c,EMINMI__c,Nature_of_Facility__c,Current_Balance__c FROM Facilities__r)
                    ,(SELECT Id,Name,Future_Count_of_Vehicles__c,Input_Given_By__c from New_Loan_Inputs__r where Input_Given_By__c='Customer' Limit 1 ) from genesis__Applications__c where Id =:appId]);
        }
        
        return appln;
    }
    public static List<Group_Concern__c> getGroupConcern(String accID){
        return [select id,Group_1__c,Group_1__r.Name,Group_2__r.Limit__c,Group_2__r.Bank_name__c,Group_2__r.Pan_Number__c,Type__c,Limit_Amount__c,Bank_Name__c,Pan_card_Number__c,Group_2__c,Group_2__r.Name from Group_Concern__c where Group_1__c =:accID];
    }
    public static List<Property__c> getProperty(Set<Id> setOfAccId) {
        return [select id,Account__c,Existing_Networth__c,Nature_of_Property__c,Property_City__c,Property_Country__c,Property_Pincode__c,Property_State__c,Property_Street__c,Property_Type__c,Property_value__c,Area__c,Asset_Type__c,Details_of_mortgage_if_any__c,Door_Number__c,Ownership_percentage__c,Ownership_Type__c,Survey_No__c,Taluk__c,Nearest_Landmark__c,is_Collateral__c from Property__c where Account__c IN : setOfAccId];
    }
    public static List<Debtors__c> getDebtors(string customerId){
        return [select id,Age__c,Customer_Name__c,Amount_Collected__c,Fiscal_Year__c from Debtors__c where Account__r.CBS_Customer_ID__c =:customerId];
    }
    public static List<Sundry_Creditors__c> getSundryCreditors(string customerId){
        return [select id,Age__c,Amount_To_Be_Paid__c,Name_Of_Trade_Creditors__c,Fiscal_Year__c from Sundry_Creditors__c where Account__r.CBS_Customer_ID__c =:customerId];
    }
    //Get M68C data filtere>d by customer id and financial year list(2015-2016,2016-2017...)
    public static List<M68_Balance_Sheet_Analysis__c> getM68Data(String accId,List<String> fyList){
        List<M68_Balance_Sheet_Analysis__c> m68DataList = new List<M68_Balance_Sheet_Analysis__c>();
        String query ='SELECT ';
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( 'M68_Balance_Sheet_Analysis__c' ).getDescribe().fields.getMap();
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';
        }
        query   = query.removeEnd(',');
        query   = query + ' from M68_Balance_Sheet_Analysis__c WHERE Account__c =\''+accId+'\' AND Fiscal_Year__c IN :fyList';
        
        system.debug('===Start Query :::'+query);
        m68DataList = Database.query(query);
        system.debug('m68DataList*****'+m68DataList);
        RETURN m68DataList;
    }
    public static Boolean isM68MissingForLastThreeYears(String accId){
        try {
            List<M68_Balance_Sheet_Analysis__c> m68DataList = [Select id,Fiscal_Year__c,Financial_type__c from M68_Balance_Sheet_Analysis__c where Account__c=:accId And Financial_type__c='Actual'];
            
            if(!m68DataList.isEmpty()){
                if(m68DataList.size() == 3){
                    return false;
                }
            }
            return TRUE;
        } catch (Exception e) {
            return true;
        }
        
    }
    public static String getRandomExternalIdForCollateral(){
        
        String leftPaddedString = getRandomString();
        return 'FE-'+leftPaddedString;
        
    }
    
    public static String getRandomString(){
        Integer randomInteger = Crypto.getRandomInteger();
        String randomString=String.valueOf(math.abs(randomInteger));
        String leftPadding = '000000';
        String leftPaddedString = randomString.leftPad(20,leftPadding);
        return leftPaddedString+String.valueOf(DateTime.now().millisecond());
    }
    
    public static List<genesis__Applications__c> getApplication(Set<Id> appIdList){
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( 'genesis__Applications__c' ).getDescribe().fields.getMap();
        String query = 'SELECT ';
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';
        }
        
        query   = query.removeEnd(',');
        query   = query + ',RecordType.DeveloperName from genesis__Applications__c WHERE Id IN :appIdList';
        
        system.debug('===Start Query :::'+query);
        RETURN Database.query(query);
    }
    
    public static User getRLPCUser(String appId){
        User rlpcUser   = new User();
        try{
            String appOwner = [Select OwnerId from genesis__Applications__c where id=:appId limit 1].OwnerId;
            String DivisVal = [Select Division from User where id=:appOwner limit 1].Division;
            rlpcUser        = [Select id from User where Designation__c='CLPC Head' AND Division=:DivisVal AND IsActive = true limit 1];
            
        }catch(Exception e){}
        return rlpcUser;
    }
    public static User getDOLegalUser(String appId){
        User rlpcUser   = new User();
        try{
            String appOwner = [Select OwnerId from genesis__Applications__c where id=:appId limit 1].OwnerId;
            String DivisVal = [Select Division from User where id=:appOwner limit 1].Division;
            rlpcUser        = [Select id from User where Designation__c='Legal' AND Division=:DivisVal limit 1];
            
        }catch(Exception e){}
        return rlpcUser ;
    }
    public static User getLegalOfficerUser(String appId){
        User legalUser   = new User();
        try{
            String appOwner = [Select OwnerId from genesis__Applications__c where id=:appId limit 1].OwnerId;
            String DivisVal = [Select Division from User where id=:appOwner limit 1].Division;
            legalUser       = [Select id from User where Designation__c='Legal Officer' AND Division=:DivisVal limit 1];
            
        }catch(Exception e){}
        return legalUser;
    }
    
    public static genesis__Applications__c getExistingApplication(String CustId,String APP_TYPE){
        
        List<String> appStage = new List<String>{'Limit renewed/Application close','Application close - enhancement','Enhancement Application close','Exceeding Application close','Adhoc Application close','Discontinued Application','New loan - Application close','Limit Opened'};
        List<genesis__Applications__c>    listAppObject   =   [select id,Application_Stage__c,genesis__Account__r.CBS_Customer_Id__c,RecordType.DeveloperName from genesis__Applications__c where genesis__Account__r.CBS_Customer_Id__c =: CustId AND RecordType.DeveloperName =: APP_TYPE AND Application_Stage__c NOT IN : appStage AND Active__c = true Order by  createddate LIMIT 1 ];
        if(! listAppObject.isEmpty()){
            return listAppObject[0];
        }else{
            return null;
        }
        
    }
    //using for update api delete functionality
    
    
    public static String getRecordTypeNameByRecordId(Id recId){
        
        String recordQuery = 'SELECT Id,RecordType.developerName from '+String.valueOf(recId.getSObjectType())+' WHERE Id=:recId '+' Limit 1';
        genesis__Applications__c record = new genesis__Applications__c();
        record = DataBase.Query(recordQuery);
        
        return record.RecordType.developerName;
    }
    public static List<genesis__Applications__c> getApplicationDueDate(String CustId){
        List<genesis__Applications__c>    listAppObject   =  [select id,Application_Stage__c,genesis__Account__r.CBS_Customer_Id__c,Renewal_Due_Date__c,CreatedDate,RecordType.DeveloperName from genesis__Applications__c where genesis__Account__r.CBS_Customer_Id__c=: CustId AND Active__c = true];
        if(!listAppObject.isEmpty()){
            return listAppObject;
        }else{
            return null;
        }
    }
    public static List<Account> getAccountDetails(String pancard){
        String RecordTypeName = Constants.BUSINESS_ACCOUNT;
        List<Account> listOfAccount =[Select id,Pan_Number__c,Cust_mobile_phone__c,GST_Number__c,RecordType.developerName,CBS_Customer_ID__c,(SELECT id,Name,Application_Stage__c,RecordType.developerName from genesis__Applications_account__r where (RecordType.developerName ='SME_NEW_Loan' AND Active__c = True) OR (RecordType.developerName ='Term_Loan' AND Active__c = false)) from Account WHERE Pan_Number__c =:pancard AND RecordType.DeveloperName =:RecordTypeName limit 1];
        if(listOfAccount !=null && listOfAccount.size() > 0){
            return listOfAccount;
        }
        return null;
    }
    public static List<clcommon__Collateral__c> getAppCollaterals(String appId){
        List<clcommon__Collateral__c> delQuery = [SELECT Id, genesis__Application__c, (Select Id, Account__r.Name from Ownerships__r) FROM clcommon__Collateral__c WHERE genesis__Application__c=:appId];
        System.debug('delQuery'+delQuery);
        return delQuery;
    }
    
    public static List<genesis__Application_Parties__c> getFirmDetails(String appleId){
        List<genesis__Application_Parties__c> businessParties = [SELECT Id, Applicant_Name__c, genesis__Application__c, Company__c, Key_Contact__c, genesis__Party_Account_Name__c, Party_Sub_Type__c, genesis__Party_Type__c, Product_Type__c, Status__c FROM genesis__Application_Parties__c WHERE Company__c = true];
        System.debug('businessParties'+businessParties);
        return businessParties;
    }
    public static Boolean getApplicationProbe42(String appId){
        If(appId !=null && appId !=''){
            genesis__Applications__c  appObj = [select id,is_Probe_42__c from genesis__Applications__c where id =:appId];
            return appObj.is_Probe_42__c;
        }
        return false;
    }
    
    public static List<clcommon__Collateral__c> getCollateralWithTitleHolder(String appId){
        try {
            List<String>                             allColIdList   = new List<String>();
            List<clcommon__Collateral__c>            allColRecList  = new List<clcommon__Collateral__c>();
            if(appId != null){
                List<genesis__Application_Collateral__c> appColList = [Select Id,Application__c,genesis__Collateral__c,Facility__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c=:appId AND genesis__Collateral__r.FE_Created__c =true];
                
                if (! appColList.isEmpty()) {
                    for(genesis__Application_Collateral__c appColRec:appColList){
                        allColIdList.add(appColRec.genesis__Collateral__c);
                    }
                    if(! allColIdList.isEmpty()){
                        allColRecList                               = getCollateralWithCollIds(allColIdList);
                    }
                }
            }
            if(! allColRecList.isEmpty())
                return allColRecList;
            else
                return null;
        } catch (Exception e) {
            system.debug('Error :::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return null;
        }
    }
    public static List<clcommon__Collateral__c> getCollateralWithCollIds(List<String> collIds){
        try {
            if(collIds != null){
                Map<String, Schema.SObjectField> partiesFieldMap = Schema.getGlobalDescribe().get('clcommon__Collateral__c' ).getDescribe().fields.getMap();
                String query = 'SELECT ';
                for(Schema.SObjectField s : partiesFieldMap.values()){
                    query = query + s.getDescribe().getName()+',';
                }
                //query=query.removeEnd(',');
                query += 'RecordType.DeveloperName,RecordType.Name,';
                query += '( Select Account__c,Account__r.Name from Ownerships__r)';
                
                query += ' FROM clcommon__Collateral__c where Id IN:collIds';
                System.debug('@@@@@'+query);
                return Database.query(query);
            }
            return null;
        } catch (Exception e) {
            system.debug('Error :::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return null;
        }
    }
    
    public static genesis__Applications__c getApplicationId_By_Name(String AppName,String appId){
        Boolean flag = false;
        String query = 'select id,Name,RecordType.developerName,CommercialPR_Stage__c,genesis__Account__r.CBS_Customer_ID__c,CreatedDate,Application_Stage__c from genesis__Applications__c ';
        query+=' WHERE ';
        If(AppName !=null && AppName !=''){
            query+= 'Name =:AppName';
        }else If(appId !=null && appId !=''){
            query+= ' Id =:appId';
            //System.debug('query 300'+query);
        }else{
            flag = true;
        }
        System.debug('query 300'+query);
        if(!flag){
            List<genesis__Applications__c> sobjList = Database.query(query);
            System.debug('sobjList305'+sobjList);
            If(!sobjList.isEmpty()){
                // System.debug('sobjList307'+sobjList[0]);
                return sobjList[0];
            }
        }
        return null;
    }
    webservice static void createTaskForBM(Id appId,String subject,String type){
        try {
            List<genesis__Applications__c> appInfo                 = new List<genesis__Applications__c>();
            appInfo                                        = SOQL_Util.getApplication(new Set<Id>{appId});
            Task taskRec = SanctionUnderwriting_Process.getTaskObj(appId, appInfo[0].OwnerId, subject, type);
            TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
            if (!Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appId, type)){
                if(type == 'Takeover Intelligence'){
                    List<User> bmCreditOfficer = new List<User>();
                    bmCreditOfficer = [SELECT Id, Profile.Name FROM User WHERE Profile.Name ='BR_CREDIT_OFFICER'];
                    system.debug('bmCreditOfficer'+bmCreditOfficer);
                    if(!bmCreditOfficer.isEmpty()){
                        taskRec.OwnerId = bmCreditOfficer[0].Id;
                    }
                }
                system.debug('taskRec::::inside if'+taskRec);
                insert taskRec;                
            }
            system.debug('outside:::');
        } catch (Exception e) {
            system.debug('Exeption In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
        }
        
    }
    public static void createTaskForBMWithoutCheckExTask(List<genesis__Applications__c> appList,String subject,String type){
        try {
            if(appList.size() > 0){
                Task taskRec = SanctionUnderwriting_Process.getTaskObj(appList[0].Id, appList[0].OwnerId, subject, type);
                TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
                insert taskRec;
            }
        } catch (Exception e) {
            system.debug('Exeption In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
        }
    }
    /*Branch Credit Officer -Start*/
    public static Map<Id,Id> BranchCreditOfficerIdMap(List<genesis__Applications__c> Applist){ //Set<Id> appIds){
        Map<Id,Id> appCreditMap= new Map<Id,Id>();
        Set<String> officeCodeSet = new Set<String>();
        map<String,User> officeCodeUsrMap= new map<String,User>();
        //map<Id,genesis__Applications__c> IdAppMap= new map<Id,genesis__Applications__c>([SELECT Id,Branch_Code__c,OwnerId from genesis__Applications__c where Id IN :appIds]);
        for(genesis__Applications__c app: Applist){//IdAppMap.values()){
            officeCodeSet.add(app.Branch_Code__c);
        }
        if(officeCodeSet.size()>0){
            for(user usr: [Select id,Office_Code__c from User where Designation__c='BR_CREDIT_OFFICER' AND Role_Name__c='Branch Credit Officer' AND Office_Code__c IN :officeCodeSet AND IsActive = true]){
                officeCodeUsrMap.put(usr.Office_Code__c,usr);
            }
        }
        for(genesis__Applications__c app: Applist){//IdAppMap.values()){
            if(officeCodeUsrMap.containsKey(app.Branch_Code__c)){
                appCreditMap.put(app.Id,officeCodeUsrMap.get(app.Branch_Code__c).Id);
            }else{
                appCreditMap.put(app.Id,null);
            }
        }
        return appCreditMap;

    }
    public static List<User> getBRCreditOfficer(String appId){
        List<User> BRCreditOfficer   = new List<User>();
        User BMUser= new User();
        try{
            
            List<genesis__Applications__c> appLst = [Select OwnerId,Branch_Code__c from genesis__Applications__c where id=:appId limit 1];
            if(appLst.size()>0){
                BRCreditOfficer = [Select id from User where Designation__c='BR_CREDIT_OFFICER' AND Role_Name__c='Branch Credit Officer' AND Office_Code__c=:appLst[0].Branch_Code__c AND IsActive = true limit 1];
                System.debug('BRCreditOfficer===> '+BRCreditOfficer);
            }
        }catch(Exception e){}
        return BRCreditOfficer;
    }

    public static void createTaskForBRCreditOfficer(Id appId,String BranchCoId,String subject,String type){
        try {
            Task taskRec = SanctionUnderwriting_Process.getTaskObj(appId,BranchCoId, subject, type);
            TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
            if(subject == 'BM task for uploading Valuation report and Legal opinion' && type == 'Collateral Evaluation' && !checkIfTaskIsPresent(appId,subject,type)){
                insert taskRec;
            }
            else if (subject != 'BM task for uploading Valuation report and Legal opinion' && !Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appId, type))
                insert taskRec;
        } catch (Exception e) {
            system.debug('Exeption In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
        }
        
    }
    public static void createTaskForBRCreditOfficerWithoutCheckExTask(Id appId,String ownerId,String subject,String type){
        try {
            Task taskRec = SanctionUnderwriting_Process.getTaskObj(appId,ownerId, subject, type);
            TaskFlow_Helper.TASK_TRIGGER_RUNNING    = true;
                insert taskRec;
        } catch (Exception e) {
            system.debug('Exeption In:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
        }
        
    }
    /*Branch Credit Officer -End*/
    public static List<Facility__c> getAllChildFacilities(List<String> allParentFacilityId){
        try {
            if(!allParentFacilityId.isEmpty())
                return [SELECT  Id, Name,Role__c,Deviation_Approver__c from Facility__c where Facility__c IN:allParentFacilityId];
            else
                return null;
        } catch (Exception e) {
            system.debug('Exeption bIn:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
            return null;
        }
    }
    public static List<String> BMAuthrecommendationIdsHelper(String appId){
        try {
            List<String> BMAuthrecommendationIds                = new List<String>();
            List<String> allParentFacilityId                    = new List<String>();
            List<Facility__c> allChildFac                       = new List<Facility__c>();
            List<Facility__c> allFacility                       = SOQL_Util.getFacilities(appId);
            
            if(! allFacility.isEmpty()){
                for(Facility__c facilityRec :allFacility){
                    allParentFacilityId.add(facilityRec.Id);
                }
            }
            if(!allParentFacilityId.isEmpty())
                allChildFac =  [SELECT  Id, Name,Role__c from Facility__c where Facility__c IN:allParentFacilityId];
            if(!allChildFac.isEmpty()){
                for(Facility__c childFacRec:allChildFac){
                    if(childFacRec.Role__c.contains('BR'))
                        BMAuthrecommendationIds.add(childFacRec.Id);
                }
            }
            return BMAuthrecommendationIds;
        } catch (Exception e) {
            system.debug('Exeption bIn1:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
            return null;
        }
    }
    public static string getApplicationUISatge(String appId){
        String recordTypeName = getRecordTypeNameByRecordId(appId);
        if(recordTypeName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT)
            return 'EnhancementView';
        else if(recordTypeName == Constants.SME_APP_RECORD_TYPE_ADHOC)
            return 'AdhocView';
        else if(recordTypeName == Constants.SME_NEW_LOAN_RECORD_TYPE)
            return 'NewLoanDetails';
        else
            return '';
        
    }
    
    public static Boolean isBMFinalAuth(String appId){
        try {
            List<Facility__c> facAuthority  = SanctionUnderwriting_Process.getFacilityAuthority(appId);
            if(! facAuthority.isEmpty())
                for(Facility__c f : facAuthority){
                    if(f.role__C.contains('BR') && f.Highest_Authority__c){
                        return true;
                    }
                }
            return false;
        } catch (Exception e) {
            system.debug('Exeption bIn1:::'+e.getCause()+'--------'+e.getLineNumber()+e.getMessage()+e.getStackTraceString());
            return false;
        }
        
    }
    public static Boolean isEnhancementAdhocApplication(String appId){
        try{
            List<genesis__Applications__c >         applnInfo                 = new List<genesis__Applications__c>();
            applnInfo                                                         = [Select id, name ,RecordType.DeveloperName from genesis__Applications__c where Id=:appId];
            if(applnInfo != null && !applnInfo.isEmpty()){
                if(applnInfo[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT || applnInfo[0].RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ADHOC)
                    return true;
                
            }
            return false;
        }catch (Exception e){
            system.debug('Error ::::'+e.getMessage()+' AT '+e.getLineNumber()+' stack::::: '+e.getLineNumber());
            return false;
        }
        
    }
    public static List<GSTN_Info__c> getGSTN_InfoByAccId(String appId){
        If(appId !=null && appId !=''){
            List<GSTN_Info__c> listOfGSTN = [select id,Total_Sales__c,Year__c,GST_Number__c,From_Date__c,To_Date__c,Months__c,RecordType.DeveloperName,Parent__r.Application__c from GSTN_Info__c where Parent__r.Application__c =:appId AND RecordType.DeveloperName ='Child'];
            If(listOfGSTN !=null){
            }
            return listOfGSTN;
        }
        return null; 
    }

    //Method to check NULL value for mobile number's  in Party Record and will list of Name of Party who don't hav e mobile no.
    public static List<String> checkNullMobNum(String appId){
        List<String> nullMobList                             = new List<String>();
        try {

            List<genesis__Application_Parties__c> partyList      = new List<genesis__Application_Parties__c>();

            partyList                                            = [SELECT Id,Name,genesis__Application__c,Key_Contact__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Name,genesis__Party_Account_Name__r.PersonMobilePhone FROM genesis__Application_Parties__c WHERE genesis__Party_Account_Name__r.PersonMobilePhone = NULL AND genesis__Application__c =: appId AND Active__c = true];

            if(! partyList.isEmpty()){
                for(genesis__Application_Parties__c prty : partyList){
                    nullMobList.add(prty.genesis__Party_Account_Name__r.Name);
                }
            }
            
        } catch (Exception e) {
            HandleBusinessException.captureError('SOQL_Util', 'checkNullMobNum', e);
            system.debug('Exception::'+e.getMessage());
        }

        return nullMobList;
    }
    //get user by Branch code
    public static User getUserByBranchCode(String BranchCode){
        If(BranchCode !=null && BranchCode !=''){
            User userObj    = [select id,Office_Code__c,isActive,Role_Name__c from User where Office_Code__c =:BranchCode AND Role_Name__c ='Branch Manager' AND isActive = true];
            If(userObj !=null){
                return userObj;
            }
        }
      return new User();  
    }
    public static List<genesis__Application_Parties__c> getListOfPartiesByAppId(String appId){
        If(appId !=null && appId !=''){
            List<genesis__Application_Parties__c>  listOfParties = [select id,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CIBIL_Status__pc,CIBIL_Score__c,genesis__Application__c,genesis__Application__r.OwnerId from genesis__Application_Parties__c where genesis__Application__c =: appId];
            If(listOfParties !=null && listOfParties.size() > 0){
                return listOfParties;    
            }
        }
        return new List<genesis__Application_Parties__c>();
    }
     webservice static void updateCollateralNon_Enforcable(String collId){
        if(collId !=null && collId !=null){
            clcommon__Collateral__c     collObj = new clcommon__Collateral__c();
            collObj.Id                      =   (id)collId;
            collObj.clcommon__Value__c      =  0.0;
            update collObj;
        }
    }
    public static map<Id,String> C1ExistCheck(set<Id> appIdLst){
        map<Id,String> c1DocMap= new map<Id,String>();
        List<Attachment> attList=[SELECT id,ParentId FROM Attachment WHERE ParentId IN: appIdLst AND Name like  'Sanction Document%'];
        for(Attachment att: attList){
            c1DocMap.put(att.ParentId,'true');
        }
        return c1DocMap;
        /*if(attList.size()>0){
            return true;
        }else{
            return false;
        }*/
    }
    
    /* Method to close Doc Generation Task For BM -- Exceeding Doc Gen Flow */
    public static void closeDocGenTaskForBM(string appId,String taskType) {
        try{
            User currentUserInfo                                    = SanctionUnderwriting_Process.currentUserInfo();
            System.debug('currentUserInfo::::::::::'+currentUserInfo);
            List<Task> getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId FROM Task where WhatId=:appId And Type=:taskType And OwnerId =: currentUserInfo.Id ];

            if(! getExistingTaskList.isEmpty()){
                getExistingTaskList[0].Status = 'Completed';
            }
            update getExistingTaskList;
        }catch(Exception e){
            HandleBusinessException.captureError('SOQL', 'closeExistingTask', e);
        }
    }
     /* Method to close all tasks for Application Rejected/Discontinued application */
    public static List<Task> completeTask(string appId){
      List<Task> taskList = new List<Task>();
       taskList = [SELECT Id,WhatId FROM Task where WhatId =:appId AND Status != 'Completed'];
        for(Task taskobj : taskList){
           taskobj.Status = 'Completed';
        }
        RETURN taskList;
    }

    /* Method to get Max & Min Decimal Value from a list based on passing parameter */
     public static Decimal getMinMaxDecimal(List<Decimal> listofNumber,String type){
        try{
            Decimal finalValue = 0.00;
            if(! listofNumber.isEmpty())
                listofNumber.sort();
                Integer n = listofNumber.size();
                if(type == 'Max' || type == 'mAx' || type == 'maX' || type == 'max' || type == 'MAX'){
                     finalValue = listofNumber[n-1];
                }
                if(type == 'Min' || type == 'mIn' || type == 'miN' || type == 'min' || type == 'MIN'){
                    finalValue = listofNumber[0];
                }
                return finalValue;
        }catch(Exception e){
            return null;
        } 
    }

    public static Map<Id,Account> getKeyPersonDetails(Set<String> pancard,Set<String> aadharReferece){
        //Boolean flag=false;
        dedupePancard = pancard;
        dedupeAadharReferece = aadharReferece;
        System.debug(pancard+':::'+aadharReferece);
        Boolean isList = false;
        String appRecordType    = Constants.PERSON_ACCOUNT_DEVNAME;
        String query='SELECT id,Name,Pan_Number__c,Aadhaar_Number__pc,Cust_mobile_phone__c,RecordType.developerName from Account ';
        query+='WHERE RecordType.developerName =: appRecordType AND ';
        if(aadharReferece !=null && aadharReferece.size() > 0 && pancard !=null && pancard.size()> 0){
            query+= '(Aadhaar_Number__pc IN : aadharReferece OR Pan_Number__c IN: pancard)';
            
            isList = true;
        }else if((aadharReferece !=null && aadharReferece.size() > 0)){
            query+= 'Aadhaar_Number__pc IN : aadharReferece ';
            
            isList = true;
        }else if((pancard !=null && pancard.size()> 0)){
            query+= 'Pan_Number__c IN: pancard ';

            isList = true;
        }
        System.debug('Query:::'+query);
        if(isList){
            Map<Id,Account> sobjList = new Map<Id,Account>((List<Account>)Database.query(query));
            If(sobjList != null && !sobjList.isEmpty()){
                if(sobjList.size() > 1)
                    personDedupeFailed = true;
                return sobjList;
            }
        }
        return null;
    }
    public static Map<String,Task> checkExixtingTaskForAnyStatus(String appId){
        List<Task> getExistingTaskList;
        Map<String,Task> mapOfTask = new Map<String,Task>();
        try{
            if(appId !=null && appId !=''){
                getExistingTaskList   = [SELECT Id,Type,Status,WhatId FROM Task where WhatId=:appId];
                if(getExistingTaskList.size() > 0){
                    for(Task taskObj : getExistingTaskList){
                        if(taskObj !=null && taskObj.Type !=null){
                            mapOfTask.put(taskObj.Type,taskObj);
                        }
                    }
                }
            }    
        }catch(Exception ex){
            HandleBusinessException.captureError('SOQL_Util', 'checkExixtingTaskForAnyStatus', ex);    
        }
       return mapOfTask; 
    }
    /*Term Loan V1- Start*/
    public static map<String, Facility__c> faciMapwithACnumber(Set<String> AccountNoSet){
        map<String, Facility__c> faciMap= new map<String, Facility__c>();
        for(Facility__c faci: [select id,Account_Number__c from Facility__c where Account_Number__c IN: AccountNoSet]){
            faciMap.put(faci.Account_Number__c,faci);
        }
        return faciMap;
    }
    public static map<String, clcommon__Collateral__c> collaMapwithNNnumber(Set<String> NNnoSet){
        map<String, clcommon__Collateral__c> collaMap= new map<String, clcommon__Collateral__c>();
        for(clcommon__Collateral__c colla: [select id,clcommon__Collateral_Name__c from clcommon__Collateral__c where clcommon__Collateral_Name__c IN: NNnoSet]){
            collaMap.put(colla.clcommon__Collateral_Name__c,colla);
        }
        return collaMap;
    }
    
    
   public static Decimal getOverallExposure(String accid){
       Decimal sum=0.00;
       try {
           String termloanrectype='Term Loan';

           List<String> recstype=new List<String>{'SME AdHoc','SME Enhancement','SME Exceeding','SME NEW Loan','SME Renewal'};
           List<String> applicationStagetoBeExcluded = new List<String>{'Discontinued Application','Deactivated Applications','Duplicate Application','New loan - Application rejected','New loan- Declined by customer','New loans - Application created','Application Rejected','Adhoc- Application created','Enhancement- Delined by customer','Enhancement- Application created','Account Closed','Exceeding- Application created'};
           List<genesis__Applications__c> allApps=[select id,genesis__Account__r.id,(select id,BRE_Limit__c,Amount_Yet_disbursed__c,Balance_Outstandings__c,Application__r.recordtype.name from Facilities__r where Active__c=true) from genesis__Applications__c where genesis__Account__r.id=:accid and (Active__c=true or recordtype.name=:termloanrectype) AND Application_Stage__c Not IN:applicationStagetoBeExcluded];
           // List<genesis__Applications__c> termloanapps=[select id,genesis__Account__r.id,(select id,Amount_Yet_disbursed__c from Facilities__r where Active__c=true) from genesis__Applications__c where recordtype.name=:termloanrectype and Active__c=false];



           For(genesis__Applications__c ap: allapps){

               for(Facility__c fac: ap.Facilities__r){
                   if(fac.Application__r.recordtype.name !=termloanrectype){
                       System.debug(' norma recs type '+fac.Id+' '+fac.BRE_Limit__c);
                       sum=sum+fac.BRE_Limit__c;

                   }
                   else{
                       System.debug('term loan '+fac.id+ '  '+fac.Amount_Yet_disbursed__c+fac.Balance_Outstandings__c);
                       if(fac.Amount_Yet_disbursed__c != null && fac.Balance_Outstandings__c != null)
                       sum=sum+fac.Amount_Yet_disbursed__c.abs() + fac.Balance_Outstandings__c.abs();
                       else if(fac.Amount_Yet_disbursed__c != null && fac.Balance_Outstandings__c == null)
                           sum=sum+fac.Amount_Yet_disbursed__c.abs();
                       else if(fac.Amount_Yet_disbursed__c == null && fac.Balance_Outstandings__c != null)
                           sum=sum+fac.Balance_Outstandings__c.abs();

                   }
                   System.debug('sum at each faicility : '+ sum);
               }
           }
       } catch (Exception e) {
           HandleBusinessException.captureError('Soql_Util','insertFacilityRecs',e);

       }
       return sum;
   
   }
    public static Decimal getOverallExposure_TL(String accId, String appId){
        Decimal sum= 0.0;
        if(accId !=null && accId !=''){
            try {
                String termLoanRecType='Term_Loan';
                List<String> listOfRecordType =new List<String>{'SME_AdHoc','SME_Enhancement','SME_Exceeding','SME_NEW_Loan','SME_Renewal'};
                List<String> applicationStagetoBeExcluded = new List<String>{'Discontinued Application','Deactivated Applications','Duplicate Application','New loan - Application rejected','New loan- Declined by customer','New loans - Application created','Application Rejected','Adhoc- Application created','Enhancement- Delined by customer','Enhancement- Application created','Account Closed','Exceeding- Application created'};
                Map<Id,genesis__Applications__c> mapOfApplication = new Map<Id,genesis__Applications__c>([select id,genesis__Account__c,RecordType.DeveloperName,Active__c,Application_Stage__c from genesis__Applications__c where genesis__Account__c=:accid and (Active__c=true OR RecordType.DeveloperName =: termloanrectype) AND Application_Stage__c Not IN:applicationStagetoBeExcluded]);
                System.debug('mapOfApplication@@@@@@'+mapOfApplication);
                Map<String,Boolean> mapOfAccountExclude = new Map<String,Boolean>();
                if(mapOfApplication !=null && mapOfApplication.size() > 0){
                    Map<Id,Facility__c> mapOfFacilities = new Map<Id,Facility__c>([select id,Application__c,Account_Number__c,BRE_Limit__c,Amount_Yet_disbursed__c,Balance_Outstandings__c,Limit_start_date__c,Recommended_Days__c,Application__r.RecordType.DeveloperName from Facility__c where Application__c IN : mapOfApplication.keySet() AND Active__c=true]);
                    System.debug('mapOfFacilities@@@@'+mapOfFacilities);
                    if(mapOfFacilities !=null && !mapOfFacilities.isEmpty()){
                        for(Facility__c facObj : mapOfFacilities.values()){
                            if(facObj.Application__r.RecordType.DeveloperName !=termloanrectype){
                                if(appId !=null && appId !='' && facObj.Application__c == appId && facObj.Account_Number__c !=null){
                                    mapOfAccountExclude.put(facObj.Account_Number__c,True);
                                    sum += facObj.BRE_Limit__c;    
                                }else {
                                    if(facObj.Account_Number__c !=null && mapOfAccountExclude.containsKey(facObj.Account_Number__c) && (facObj.Limit_start_date__c !=null && facObj.Recommended_Days__c !=null && facObj.Limit_start_date__c.addDays(Integer.valueOf(facObj.Recommended_Days__c)) <= System.today())){
                                    	System.debug('Inside @@@@'+facObj.Account_Number__c);	    
                                    }else{
                                    	sum += facObj.BRE_Limit__c;    
                                    }   
                                }
                            }
                            else{
                                System.debug('term loan '+facObj.id+ '  '+facObj.Amount_Yet_disbursed__c+facObj.Balance_Outstandings__c);
                                if(facObj.Amount_Yet_disbursed__c != null && facObj.Balance_Outstandings__c != null)
                                    sum=sum+facObj.Amount_Yet_disbursed__c.abs() + facObj.Balance_Outstandings__c.abs();
                                else if(facObj.Amount_Yet_disbursed__c != null && facObj.Balance_Outstandings__c == null)
                                    sum=sum+facObj.Amount_Yet_disbursed__c.abs();
                                else if(facObj.Amount_Yet_disbursed__c == null && facObj.Balance_Outstandings__c != null)
                                    sum=sum+facObj.Balance_Outstandings__c.abs();
                            }
                        }
                    }
                    System.debug('mapOfAccountExclude@@@@@'+mapOfAccountExclude);
                }
            } catch (Exception e) {
                HandleBusinessException.captureError('Soql_Util','getOverallExposure_TL',e);
            }    
        }
        return sum;
    }
    public static void updateAcountOverallExposure(String custId){
        try {
            System.debug('Overall Expo'+getOverallExposure(custId));
            update new Account(Id=custId,Overall_Exposure__c=getOverallExposure(custId));

        } catch (Exception e) {
            HandleBusinessException.captureError('Soql_Util','insertFacilityRecs',e);
        }
    }
    
    public static Decimal getoverallexposureforapplication(String applicationid){

        Map<String,Decimal> overallexposurebycustomer =new Map<String,Decimal>();
        Map<String,Decimal> custOverAllExpoByBuisnessAccount = new Map<String, Decimal>();
        Set<id> collateraliset=new Set<id>();
        Decimal overallExpo =0.00;
         List<String> applicationStagetoBeExcluded = new List<String>{'Discontinued Application','Deactivated Applications','Duplicate Application','New loan - Application rejected','New loan- Declined by customer','New loans - Application created','Application Rejected','Adhoc- Application created','Enhancement- Delined by customer','Enhancement- Application created','Account Closed','Exceeding- Application created'};

        List<genesis__Application_Collateral__c> collaterallist=[select id,genesis__Collateral__r.id,Application__r.Application_Stage__c  from genesis__Application_Collateral__c where Application__r.id =: applicationid AND Application__r.Application_Stage__c NOT IN:applicationStagetoBeExcluded];
        //System.debug('collateral ids for this application' +collaterallist);
       
        For(genesis__Application_Collateral__c collateral_rec:collaterallist){
            collateraliset.add(collateral_rec.genesis__Collateral__r.id);         
        }
        System.debug('collateral ids for this application '+collateraliset.size() +' ids of collateral '+collateraliset);

        List<Ownership__c> listofowner=[select id,account__r.id,account__r.Overall_Exposure__c from Ownership__c where Collateral__r.id in :collateraliset];
        System.debug('list of owner '+listofowner);
        For(Ownership__c ownerrec:listofowner){
            overallexposurebycustomer.put(ownerrec.account__r.id,ownerrec.account__r.Overall_Exposure__c);
            
        }
        System.debug('returning mAP '+overallexposurebycustomer);
        custOverAllExpoByBuisnessAccount = getOverallExpoFromParties(applicationid);
        System.debug('custOverAllExpoByBuisnessAccount '+custOverAllExpoByBuisnessAccount);
        if(!custOverAllExpoByBuisnessAccount.isEmpty()){
            overallexposurebycustomer.putAll(custOverAllExpoByBuisnessAccount);
            System.debug('returning mAP '+overallexposurebycustomer);
        }

        for(Decimal exposureValue:overallexposurebycustomer.values()){
            System.debug('exposureValue '+exposureValue);
            if(exposureValue != null)
                overallExpo+=exposureValue;

        }
        System.debug('overallExpo '+overallExpo);
        return overallExpo;
        
        
    }
    public static Map<String,Decimal> getOverallExpoFromParties(String appId){
        try {
            Set<String> allPersonAccount = new Set<String>();
            Set<String> allBuisnessAccount = new Set<String>();
            Map<String,Decimal> custOverAllExpoByBuisnessAccount = new Map<String, Decimal>();

            for(genesis__Application_Parties__c partyRec :[Select id,name ,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.RecordType.DeveloperName,Key_Contact__c,genesis__Party_Account_Name__r.Overall_Exposure__c from genesis__Application_Parties__c where genesis__Application__c=:appId]){
                // Check if genesis__Party_Account_Name__c is BA
                System.debug('partyRec.genesis__Party_Account_Name__r.RecordType.DeveloperName'+partyRec.genesis__Party_Account_Name__r.RecordType.DeveloperName);
                if(partyRec.genesis__Party_Account_Name__r.RecordType.DeveloperName != 'PersonAccount'){
                    allBuisnessAccount.add(partyRec.genesis__Party_Account_Name__c);
                    if(partyRec.genesis__Party_Account_Name__r.Overall_Exposure__c != null)
                    custOverAllExpoByBuisnessAccount.put(partyRec.genesis__Party_Account_Name__c,partyRec.genesis__Party_Account_Name__r.Overall_Exposure__c);
                }else{
                    allPersonAccount.add(partyRec.genesis__Party_Account_Name__c);
                }
            }

            System.debug('custOverAllExpoByBuisnessAccount'+custOverAllExpoByBuisnessAccount);
            System.debug('allBuisnessAccount'+allBuisnessAccount);
            if(!allPersonAccount.isEmpty()){
                //Set<String> getAllBAAccount = getAllBuisnessAccountFromPAOfParty(allPersonAccount);
                Map<String,Decimal> tempMap =  getAllBuisnessAccountFromPAOfParty(allPersonAccount);
                System.debug('tempMap'+tempMap);
                if(tempMap!= null && tempMap.size()>0)
                    custOverAllExpoByBuisnessAccount.putAll(tempMap);
            }
            System.debug('custOverAllExpoByBuisnessAccount'+custOverAllExpoByBuisnessAccount);

            return custOverAllExpoByBuisnessAccount;

        } catch (Exception e) {
            HandleBusinessException.captureError('Soql_Util','getOverallExpoFromParties',e);
            return null;
        }

    }

    public static Map<String,Decimal> getAllBuisnessAccountFromPAOfParty(Set<String> allPersonAccount){

        Map<String,Decimal> custOverAllExpoByBuisnessAccount = new Map<String, Decimal>();
        for(genesis__Application_Parties__c appPartyRec:[Select Id,genesis__Party_Account_Name__c,Key_Contact__c,Key_Contact__r.Overall_Exposure__c from genesis__Application_Parties__c where genesis__Party_Account_Name__c IN:allPersonAccount]){
            if(appPartyRec.Key_Contact__r.Overall_Exposure__c != null)
            custOverAllExpoByBuisnessAccount.put(appPartyRec.Key_Contact__c,appPartyRec.Key_Contact__r.Overall_Exposure__c);
        }

        System.debug('custOverAllExpoByBuisnessAccount'+custOverAllExpoByBuisnessAccount);
        return custOverAllExpoByBuisnessAccount;
    }
    
    public static map<String,Security_Requirement_Master__c> securityMasterMap(){
        map<String,Security_Requirement_Master__c> returnMap= new map<String,Security_Requirement_Master__c>();
        List<Security_Requirement_Master__c> securityList= [SELECT Id, Name, Collateral_Security_Requested__c, Primary_Security_Requested__c FROM Security_Requirement_Master__c];
        for(Security_Requirement_Master__c sec: securityList){
            returnMap.put(sec.Name,sec);
        }
        return returnMap;
    }

    /*Term Loan V1- End*/


    /*
        Name    : checkIfTaskIsPresent.
        Purpose : Method to check whether any task is present with same subject and type.
        Param   : Application Id, Task Subject & Task type.
    */
    public static Boolean checkIfTaskIsPresent(string appId,String taskSubject,String type) {
        try{
            List<Task> getExistingTaskList;
            getExistingTaskList = [SELECT Id,Subject,Type FROM Task WHERE WhatId =: appId AND Subject =: taskSubject AND Type =: type];
            return getExistingTaskList.size() > 0 ? true : false;
        }catch(Exception e){
            HandleBusinessException.captureError('SOQL_Util', 'checkIfTaskIsPresent', e);
            return false;
        }
    }

    public static List<genesis__Applications__c> getCustApplicationListbyCustomer(string CustId){
        String queryString      = 'Select Id,Name,RecordType.DeveloperName,CustomerID__c,genesis__Account__c,genesis__Account__r.Name,Loan_Account_Number__c,Renewal_Due_Date__c,Pre_Renewal_Checklist__c,Application_Status__c,Application_UI_Stage__c,Application_Stage__c,(select id,Existing_Limit__c,Balance_Outstandings__c from Facilities__r) from genesis__Applications__c';
        queryString             += ' where CustomerID__c =:CustId';
        return database.query(queryString);
    }

    /*
        Name    : closeTaskForRejectAndDiscontinuedApp.
        Purpose : Method to close all the Not Started status tasks for Application Rejected/Discontinued application stage.
        Param   : Application Id.
    */
    public static List<Task> closeTaskForRejectAndDiscontinuedApp(string appId){
        try{
            List<Task> taskList = new List<Task>();
            taskList = [SELECT Id,WhatId FROM Task where WhatId =: appId AND Status != 'Completed'];
            if(! taskList.isEmpty()){
                for(Task taskobj : taskList){
                   taskobj.Status = 'Closed';
                }
                return taskList;
            }
            else return null;
            
        }
        catch(Exception e){
            HandleBusinessException.captureError('SOQL_Util', 'closeTaskForRejectAndDiscontinuedApp', e);
            return null;
        }
    }

    public static List<clcommon__CL_Product__c> getProductDetails(List<String> productcategory){
        String queryString='select id,name,CIBIL_Required__c,Facility_Category__c,(select id,cibil__c from Product_Support_Configurations__r) from clcommon__CL_Product__c where Facility_Category__c in: productcategory';
        return Database.Query(queryString);
    }

}