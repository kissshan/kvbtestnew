/**
 * Created by ET-MARLABS on 06-03-2019.
 */

public with sharing class TermLoanModelClass {

    public static Map<Id,genesis__Applications__c> appRecordMap = new Map<Id, genesis__Applications__c>();
    public static Map<Id,Account> accountRecMap= new Map<Id,Account>();
    public static Map<Id,List<Task>> taskrecMap=new Map<id,List<Task>>();
    public static Map<id,List<Facility__c>> facilityrecMap=new Map<id,List<Facility__c>>();
    public static Map<Id,User> userInfoMap;
    public static Map<Id,Deviation_Rules__c> deviationInfoMap;
    public static Map<Id,List<Credit_Underwriting__c>> creditUnderwritingInfoMap;
    public static Map<Id,List<Audit__c>> auditInfoMap;
    public static Map<Id,List<genesis__Application_Parties__c>> partyInfoMap;
    public static Decimal mclrValues = 0.00;
	

    public static void prepareCurrentAuditInfo(String appId){
        if(!userInfoMap.containsKey(appId)){
            List<Audit__c> recList = [select Id,User__c,User__r.Name,User__r.Designation__c,Complied__c,Reason__c,Sanction_Authority_Comment__c,Application__c,Terms_and_Conditions__c,
                    RecordType.DeveloperName,createdDate from Audit__c where (RecordType.DeveloperName =:Constants.SANCTION_AUTHORITY_AUDIT_RTYPE OR
            RecordType.DeveloperName =:Constants.UNDERWRITING_T_C_RTYPE OR
            RecordType.DeveloperName =:Constants.PREDISBURSEMENT_T_C_RTYPE ) AND Application__c =:appId];
            if(!recList.isEmpty()){
                auditInfoMap.put(appId,recList);
            }
        }
    }
    public static void prepareCurrentPartyInfo(String appId){
        if(!partyInfoMap.containsKey(appId)){
            partyInfoMap.put(appId,[SELECT Id,Name,genesis__Application__c,Key_Contact__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.Name,genesis__Party_Account_Name__r.PersonMobilePhone FROM genesis__Application_Parties__c WHERE  genesis__Application__c =: appId]);
        }
    }
    public static void prepareCurrentUserInfo(String userId){
        if(!userInfoMap.containsKey(userId)){
            userInfoMap.put(userId,[Select id,Designation__c,Division,Name from User where Id=:userId]);
        }
    }
    public static void prepareCurrentMCLRInfo(){
        if(mclrValues == 0.00){
            mclrValues = [Select Id,COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c where COD_Term_From__c=365.0  Limit 1].MCLR_Of_Interest__c;
        }
    }
    public static void prepareCurrentcreditUnderwritingInfo(String appId){
        if(!creditUnderwritingInfoMap.containsKey(appId)){
           List<Credit_Underwriting__c> recList = [Select id,Appraisal__c,Comments__c,Application_Score__c,Application_Value__c,
                   Application_Weight__c,Application__c,Application_Score_Percent__c,
           (Select id,Underwriting_Variable__c,toLabel(Variable_type__c),Application_Value__c,Application_Weight__c,Comments__c,
                   Application_Score__c,Flags_Value__c,Flags_Range__c,RecordTypeId,RecordType.DeveloperName,Threshold_breached__c
           from Credit_Underwritings__r)
           from Credit_Underwriting__c where Application__c =: appId Order by Display_Order__c];
            if(!recList.isEmpty()){
                creditUnderwritingInfoMap.put(appId,recList);
            }
        }
    }

    public static void prepareCurrentApplicationInfo(String appId){
        if(!appRecordMap.containsKey(appId)){
            appRecordMap.put(appId,[select id,Bureau_Fees_GST__c,EMINMI__c,Active__c,Legal_Charges_Result__c,UNIQUE_KEY__c,Processing_Fee_Result__c,Bureau_Fee__c,Application_Stage__c,BRE_Done__c,Type_of_Application__c,Overall_Exposure__c,Sub_Stage__c,Approved_Loan_Amount__c,Application_to_close__c,Parent_Application__c,is_Probe_42__c,Loan_Account_Number__c,Deleted_Person__c,Recommended_Final_Rate_of_Interest__c,genesis__Account__r.Udyog_Adhaar_Number__c,
                                                            Sanction_Authority_Limit__c,recordtype.developername,recordtypeid,New_to_Business__c,Branch_Code__c,Branch_Name__c,genesis__Account__c,genesis__Account__r.Name,genesis__Account__r.Contact_Person_Name__c,PG_Status__c,Renewal_Due_Date__c,
                                                            Request_Reason__c,EAE_Renewal_Date_in_days__c,Reason_for_Application__c,genesis__Account__r.Previous_Constitution__c,genesis__Account__r.Line_of_Activity__c,genesis__Account__r.CIN_Number__c,Application_Status__c,Cash_Flow_Method__c,
                                                            genesis__Account__r.GST_Number__c,genesis__Account__r.Total_Loan_Amount__c,(select id,BM_Comment__c,Checklist_Name__c,Comment__c,Complied__c,DO_Comment__c,Reason__c,Sl_No__c from Pre_Renewal_Checklists__r),(select id,Account__c,Application__c,External_Id__c,From_Date__c,Parent__c,GST_Number__c,Message__c,Months__c,Status__c,To_Date__c,Total_Sales__c,Year__c from GSTN_Info__r),(SELECT Id,Name,Future_Count_of_Vehicles__c,Input_Given_By__c from New_Loan_Inputs__r where Input_Given_By__c='Customer' Limit 1 ) from genesis__Applications__c where Id =:appId]);
        }
        
    }
    
    public static void  prepareCurrentAccountInfo(String accid){
        if(!accountRecMap.containsKey(accid)){
            accountRecMap.put(accid,[select Profit_after_tax__c,Net_Fixed_Asset_Land_and_Building__c,Net_Fixed_Asset_Plant_and_Machinery__c,Previous_Year_Growth_Rate__c,Udyog_Adhaar_Number__c,Primary_Bank_Name__c,Primary_IFSC_Code__c,Primary_Branch_Name__c,Primary_Account_Number__c,
                                     id,Name,Contact_Person_Name__c,Contact_Person_Designation__c,Previous_Constitution__c,Line_of_Activity__c,CIN_Number__c,Cust_mobile_phone__c,Date_of_Institution__c,Pan_Number__c,IE_Code__c,Designation__pc,Group_Name__c,
                                     Reasons_for_exemption_from_GST__c,Annual_TurnoverIncome__c,Company_Email__c,Aadhaar_Number__pc,CBS_Customer_ID__c,Education_Qualification__pc,
                                     PersonBirthdate,Principal_nature_of_business__c,Cash_Budget__c,PersonMobilePhone,PersonEmail,BillingStreet,Number_of_Shares_Held__c,UAM_Number__c,Major_Activity__c,Enterprise_Type__c,Activity_Type__c,BillingCity,Limit_Assesment_Closing_Balance__c,
                                     BillingPostalCode,BillingState,BillingCountry,Latest_Date_Of_Reconstitution__c,ShippingStreet,ShippingCity,ShippingPostalCode,
                                     Amount_of_Shares__pc,Name_Of_Director_Related_To__c,Bank_name__c,Relationship__c,is_Section_20__c,Balance_Outstandings__c,Name_of_Facility__c,Related__c,ShippingState,ShippingCountry,Percentage_of_holding__pc,Group__c,
                                     Date_of_Incorporation__c,Name__c,Constitution__c,Present_interest__c,Phone,Line_of_Activity_code__c,Priority_Sector__c,Over_Due__c,Industry_Type__c,Firm_Company_was_Reconstituted__c,GST_Number__c,Total_Loan_Amount__c,
                                     (select id,Account__c,Advances_and_deposits__c,Advance_to_suppliers__c,Bank_Borrowings__c,Bank_Deposits__c,CA_Name__c,CA_Number__c,Capital_WIP__c,Cash_and_Bank_Balances__c,Cash_profit__c,CL_Others_1__c,CL_Others_2__c,
                                     Creditors_Velocity_days__c,Current_Ratio__c,Data_Source__c,Debtors_Velocity_days__c,Depreciation__c,External_Id__c,Financial_type__c,Fiscal_Year__c,General_Reserves__c,Gross_sales__c,Income_tax_paid__c,Interest_Expense__c,
                                     Inventories__c,Inv_in_shares_etc__c,Inv_in_Sister_Associates__c,Is_new__c,Land_Building__c,Misc_Expenditure__c,MissingYear__c,Month__c,Net_profit__c,Net_Profit_Margin__c,Net_sales__c,Net_Working_Capital__c,Non_Current_others__c,
                                     NW_Others1__c,NW_Others2__c,OCA1__c,OCA2__c,Other_Current_Assests__c,Other_Current_Liabilities__c,Other_income__c,Other_Reserves__c,Fixed_Assests_Others__c,Intangible_Others__c,Other_Term_Liabilites__c,Paid_Up_Capital__c,Plant_Machinery__c,
                                     Profit_Loss_Account__c,Profit_before_Interest_and_tax__c,Provisions__c,Purchases__c,Revaluation_Reserves__c,Share_Application_Money__c,Share_Premium__c,Stock_Turnover_Ratio__c,Sundry_Creditors__c,Sundry_Creditors_Exp__c,
                                     Sundry_Creditors_Finance__c,Sundry_Debtors__c,Surplus_in_P_L__c,Tangible_Net_Worth__c,Term_Loan_1_Yr__c,Term_loan_Banks_FIs__c,Term_LoanNBFCs__c,TL_Others_1__c,TL_Others_2__c,TOL_TNW_Ratio__c,TOL_TNW_Ratio_QE__c,Total_Assets__c,
                                     Total_Current_Assets__c,Total_Current_Liabilities__c,Total_Fixed_Assets__c,Total_Intangible_Assets__c,Total_Liabilities__c,Total_Net_Worth__c,Total_Non_Current_Assets__c,Total_Outside_Liabilities__c,Total_Term_Liabilities__c,
                                     Unsecured_Loans_F_R__c,Year__c from M68_Balance_Sheet_Analysis__r),(select id,Account__c,Credit_cash_count__c,Fiscal_Year__c,Fiscal_Type__c,Availment_amount__c,Debit_count__c,Debit_Summation__c,From_Date__c,To_Date__c,Credit_Cash_Amount__c,
                                     FIN_DR_CNT__c,FIN_CR_CNT__c,FIN_CR_AMT__c,Intrest_Recieved_Amount__c,Service_Charge_count__c,Services_Charges_Amount__c,New_Data__c from Operations_Details__r) from account where id=:accid]);

        }
    }

    public static void prepareCurrentTaskInfo(String appid){
        if(!taskrecMap.containsKey(appid)){
            taskrecMap.put(appid,[select id,subject,type,status,whatid,whoid,ownerid from Task where whatid=:appid]);
        }
    }

    public static void prepareCurrentFacilityInfo(String appid){
        if(!facilityrecMap.containskey(appid)){
            String queryString='';
            String fieldslist='';
            Map<String, Schema.SObjectField> facilityFieldMap = Schema.getGlobalDescribe().get( 'Facility__c' ).getDescribe().fields.getMap();
            for(Schema.SObjectField s : facilityFieldMap.values()){
                fieldslist = fieldslist + s.getDescribe().getName()+',';
             }
            queryString='select '+fieldslist+'(select '+fieldslist+'from Facilities__r where Read_Only_User__c=false AND RecordType.DeveloperName =\'Child\' AND Facility__r.Application__c =:appId) from Facility__c And Application__c=:appId And Active__c=true AND RecordType.DeveloperName =\'Parent\'';
            facilityrecMap.put(appid,Database.query(queryString));
        }
        system.debug('facilityrecMap::'+facilityrecMap);
    }
    public static void prepareCurrentDeviationInfo(String appId){
        try{
            if(!deviationInfoMap.isEmpty())
                deviationInfoMap.put(appId,[select id,CO_GM__c,COCC__c,DOCC__c,Schematic__c,Rule__c,President_and_COO__c,Limit_Value__c,(Select id,Name from CL_Products1__r),(Select id,Name from CL_Products__r) from Deviation_Rules__c]);
        }catch(Exception e){
            HandleBusinessException.captureError('className','methodName',e);
            System.debug('Error Message :'+e.getMessage()+' AT '+e.getLineNumber());
        }
    }

   
    
    
    
    
}