/*
* Name    : queryService
* Company : ET Marlabs
* Purpose : This class is used to query on application
* Author  : Subas
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =========    ==================================
V1.1    22-Aug-2018    Braj         Added 'Stamp_Duty__c,genesis__Party_Account_Name__r.Verify_PAN_Number__c' field in query
V1.2    31-Aug-2018    Braj         Added genesis__Collaterals__r inner query 
V1.3    06-Sep-2018   Venu          Added Digio document id child query
V1.3.1  25-Sep-2018    Venu         Added Perfios captured in Autopopulate Query
V1.4    28-Sep-2018    Braj         Query modified as some of the fields are not avalible
V1.5    28-Sep-2018    Venu         Adding KYC and Aadhaar fields in Applicaiton and Party level
V1.6    28-Oct-2018    Braj         Added Digio_Documnet_ID__r query
v1.7    20-Dec-2018    Braj         Astute query added and customer details
v1.8    16-Jan-2019    Braj         #HL MPV2:Added Facility query
*******************************************************************************************/
public class queryService {
    
    public static Date getDateFormatFromString(String dateFromAstitute){
        
        List<String> parts = dateFromAstitute.split('/');
        System.debug('@@@@'+parts);
        Date myDate = Date.newInstance(Integer.valueOf(parts[2]), Integer.valueOf(parts[1]), Integer.valueOf(parts[0]));
        System.debug('@@@@'+myDate);
        return myDate;
    }
    public static list<Account> getApplicants(String Appid){
        System.debug('Appid:::'+Appid);
        set<id> accids = new set<id>();
        for(genesis__Application_Parties__c pacc:[select id,Key_Contact__c,genesis__Party_Account_Name__c from genesis__Application_Parties__c  where genesis__Application__c=:Appid AND Active__c =true])
        {
            accids.add(pacc.genesis__Party_Account_Name__c);
        }
        system.debug('#####'+accids);
        //string query= 'select id,firstName,LastName,PersonBirthdate,PersonEmail,Disbursement_Esign__c,MOD_Esign__c,PersonMobilePhone,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostal,Current_Address_Proof_Type__c,Voter_Id__c,Electricity_Customer_No__c,Customer_LPG_No__c,Water_Bill_No__c,Driving_License_ID__c,Customer_Passport__c,Caste__pc,Marital_Status__c,Branch_Code__c,Is_Physically_Handicapped__c,Is_Ex_Service_Man__c,Religion__c,Cust_Education_qualification__c,Is_Applicant_Related_To_Bank_Directors__c,Name_Of_Bank_Related_To__c,Name_Of_Director_Related_To__c';//v1.4
        String query = 'select id,firstName,LastName,PersonBirthdate,PersonEmail,Disbursement_Esign__c,MOD_Esign__c,PersonMobilePhone,Current_Address_Proof_Type__c,Voter_Id__c,Electricity_Customer_No__c,Customer_LPG_No__c,Water_Bill_No__c,Driving_License_ID__c,Caste__pc,Branch_Code__c,Is_Physically_Handicapped__c,Is_Ex_Service_Man__c,Religion__c,Is_Applicant_Related_To_Bank_Directors__c,Name_Of_Bank_Related_To__c,Name_Of_Director_Related_To__c ';//v1.4
        query = query+'  From Account '; //where id IN:accids
        System.debug('@query:::'+query);
        return Database.query(query);
    }
    public static genesis__Applications__c getApplication(String Appid){
        String query = getQuery('Autopopulate');
        query += ' where id=:Appid';
        System.debug('######'+Limits.getLimitAggregateQueries());
        return Database.query(query);
    }
    //method to return pl proccessing fee
    public static LoanProcess_Config__mdt processingFee(String Loan_Type){
        return [select id, Fee_Percentage__c,Indx_Variance__c,Penal_Interest__c,PreClosure_Charges__c,Loan_Type__c,DocCount__c from LoanProcess_Config__mdt where Loan_Type__c =: Loan_Type limit 1];
    }
    
    public static List<Perfios__c> GetBankAccounts(string AccID,string AppID){
        // prashant singh only add extra field in query BS_UploadType__c,Status__c,Failure_Reason__c,IS_DELETED__c and replace Active__c=true to IS_DELETED__c=false in perfios
        return [select id,Bank_Account_Number__c,Bank_Name__c,Applicant_Name__c,BS_UploadType__c,Status__c,Failure_Reason__c,IS_DELETED__c,Upload_Bank_Statement__c,Error_Message__c from Perfios__c where Applicant_Name__c=:AccID and  Application__c=:AppID and IS_DELETED__c=false ];
        return null;
    }
    public static String  getQuery(String serviceName){
        string query;
        if(serviceName=='Autopopulate'){
           query = 'Select id,E_mandate_UMRN_No__c,Sale_Deed_Colleced__c,All_property_Documents_Uploaded__c,Sub_Type__c,FI_Final_Decision__c,Pre_approved_value__c,Status__c,Cersai_Charges__c,Disbursement_Amount__c,Cersai_Fee_with_GST__c,Max_EMI__c,Application_Stage__c,Sanction_Authority_Limit__c,Sanctioned_Tenure__c,Sanctioned_EMI__c,Pre_approved_flag__c,Margin_Payment_Mode__c,Margin_Payment_Reference__c,PrimaryApplicant_CIBIL_Score__c,Charges_Processed__c,Branch_manager_visit_date__c,Valuers_Name__c,Latest_Date_of_Visit__c,Branch_manager_visit_comments__c,Instructions_To_Branch__c,Lawyer_name__c,Date_Of_Legal_Opinion__c,Date_Of_Valuation__c,CIBIL_score__c,genesis__CL_Product__r.max_amount__c,genesis__CL_Product__r.LMax_PL__c,Legal_desk_state_flag__c,pmax_limit__c,RLPC_head_Comments__c,genesis__Disbursement_Date__c, MOD_Date__c,DM_comments__c,Sanction_Date__c,Retry_CBS__c,Total_Stamp_Paper_Charge__c,Total_Cheque_Bounces__c, SI_Applicant__c, Minimum_Loan_Amount__c,ITR_Uploaded__c, ITRs_Filled_within_3_Months__c,Employment_Type__c,FI_Status__c,NMI_Approved__c,PMin__c,Sanction_Doc_Generation_Check__c,Docgen_Fail__c,Is_CreditLife__c,Processing_Charges__c,Processing_charges_with_GST__c,Total_GST_Charges__c,CIBIL_Charges_with_GST__c,Cibil_Charges__c,Valuation_Charges__c,Valuation_Charges_with_GST__c,Legal_Charges__c,Legal_Opinion_with_GST__c,Processing_Fee__c,Record_Type_Name__c,Product_Code__c,Error_Message_pl__c,Sanction_Message__c,Interest_Variation__c,Has_the_CBS_disbursement_been_completed__c,Complete_E_KYC_for_NTB_customers__c,Disbursement_Account_Number__c, Disbursement_Account_Bank_Name__c,Disbursement_Account_Branch_Name__c, Disbursement_Account_IFSC_Code__c, SI_Account_Number__c, SI_Bank_Name__c, SI_Branch_Name__c,SI_IFSC_Code__c,Is_Take_Over__c,IFSC_code__c,Branch_Name_Existing__c,Bank_Name__c,Sanctioned_Loan_Amount__c,Outstanding_Loan_Amount__c,Date_of_Loan_Sanction_Existing_Loan__c,Start_Date_of_EMI_Existing_Loan__c,End_Date_of_EMI_Existing_Loan__c,Sanctioned_Loan_Term_Existing_Loan__c,Outstanding_Loan_Term_Existing_Loan__c,Sanctioned_ROI_Existing_Loan__c,Current_ROI_Existing_Loan__c,Reject_Scenario__c,Name,Created_Date__c,EMI_Max__c,Holiday_Max__c,Branch_City_Id__c,Branch_State_Id__c,GMRA_Option__c,Property_State_Id__c,GMRA_Amount__c,Property_City_Id__c,Property_Address_Line_2__c,Branch_City__c,Branch_State__c,Property_City__c,Property_State__c,Property_Pincode__c,FE_Extra__c,Nmax__c,PMax__c,Max_Term__c,Max_LTV__c,genesis__Overall_Status__c,Sanction_ESign_Check__c,Guarantor_Esign_Check__c,Borrowers_Esign__c,Document_Generation__c,Loan_Purpose__c,Cost_Of_Flat_House__c ,Market_Value_Of_The_Land__c ,Cost_Of_Construction__c,Cost_Of_Repair__c,Bank_Of_Existing_Home_Loan__c,Loan_Start_Date_Of_Existing_Home_Loan__c,Tenure_Of_Existing_Home_Loan__c,Outstanding_Balance__c,Project_Code__c,Name_Of_The_Builder__c,Project_Name__c,Tower__c,Flat_No__c,Property_Address__c,Total_Repayment_Amount__c,genesis__Payment_Amount__c,genesis__Interest_Rate__c,genesis__Loan_Amount__c,genesis__Term__c,Holiday_Period__c,Is_GMRA_Policy_Selected__c,Is_GMRA_Policy_Added_To_Loan_Amount__c,Branch_Code__c,Branch_Name__c,Is_Loan_processing_Fee_Paid__c,Documents_Uploaded__c,Sourced_By__c,Sourced_By_Office__c,Sub_Stage__c,(select  genesis__Party_Account_Name__r.Mother_s_Maiden_Name__pc,Average_Balances_6_months__c,Bank_Account_Number__c,Primary_Bank_Branch__c,  IFSC_code__c,  Primary_Bank__c,genesis__Party_Account_Name__r.Current_Address_Proof_Type__c,Financial_Applicant__c,genesis__Party_Account_Name__r.CBS_Account_No_1__c,genesis__Party_Account_Name__r.CBS_Account_No_2__c,genesis__Party_Account_Name__r.CBS_Account_No_3__c,genesis__Party_Account_Name__r.CBS_Account_No_4__c,genesis__Party_Account_Name__r.CBS_Account_No_5__c,genesis__Party_Account_Name__r.Voter_Id__c,  genesis__Party_Account_Name__r.Electricity_Customer_No__c,Salary_Credited_1__c,Salary_Credited_2__c,Salary_Credited_3__c,Salary_Credited_4__c,Salary_Credited_5__c,Salary_Credited_6__c,Employment_Types__c,Employment_SubType__c,genesis__Party_Account_Name__r.Customer_LPG_No__c,genesis__Party_Account_Name__r.Water_Bill_No__c ,genesis__Party_Account_Name__r.Driving_License_ID__c,genesis__Party_Account_Name__r.Branch_Code__c,genesis__Party_Account_Name__r.Is_Physically_Handicapped__c,genesis__Party_Account_Name__r.Is_Ex_Service_Man__c ,genesis__Party_Account_Name__r.Religion__c ,genesis__Party_Account_Name__r.Is_Applicant_Related_To_Bank_Directors__c ,Is_Existing_Customer__c,Income_Computation_From__c,genesis__Party_Account_Name__r.Name_Of_Bank_Related_To__c,genesis__Party_Account_Name__r.Name_Of_Director_Related_To__c,genesis__Party_Account_Name__r.Are_you_An_Existing_Customer__c,genesis__Party_Account_Name__r.CUSTSINCE__c,Key_Contact__r.id,genesis__Party_Account_Name__r.CBS_Customer_ID__c ,genesis__Party_Account_Name__r.Pan_Number__c ,genesis__Party_Account_Name__r.Reason_For_Not_Having_PAN_Card__c,genesis__Party_Account_Name__r.Do_You_Have_Any_Assets__c,genesis__Party_Account_Name__r.Immovable_Assets__c,Is_Bank_Statement_required__c,genesis__Party_Account_Name__r.Other_Assets__c,Employment_Type__c,genesis__Party_Account_Name__r.Type__c,genesis__Party_Account_Name__r.Experience__c,genesis__Party_Account_Name__r.Employment_SubType__c,genesis__Party_Account_Name__r.Company_Name__c,genesis__Party_Account_Name__r.Holding_Comp_Address__c,Net_Monthly_Income__c,genesis__Party_Account_Name__r.Mode_Of_Bank_Statement_Verification__c,genesis__Party_Account_Name__r.Mode_Of_ITR_Verification__c,Additional_Income__c,Source_of_Income1__c,Additional_Income_Amount1__c,Source_Of_Income2__c,Additional_Income_Amount2__c,Source_Of_Income3__c,Additional_Income_Amount3__c,Source_Of_Income4__c,Additional_Income_Amount4__c,Source_Of_Income5__c,Additional_Income_Amount5__c,genesis__Party_Account_Name__r.PersonMailingStreet,genesis__Party_Account_Name__r.PersonMailingCity,genesis__Party_Account_Name__r.PersonMailingState,Tax_Deducted__c,genesis__Party_Account_Name__r.PersonMailingCountry,genesis__Party_Account_Name__r.PersonMailingPostalCode,genesis__Party_Account_Name__r.Passport_Number__pc,genesis__Party_Account_Name__r.Caste__pc,genesis__Party_Account_Name__r.Marital_Status__pc,genesis__Party_Type__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.ints__Bank_Account_Number__pc,genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.LastName,genesis__Party_Account_Name__r.MiddleName,genesis__Party_Account_Name__r.PersonBirthdate ,genesis__Party_Account_Name__r.Father_Name__pc ,genesis__Party_Account_Name__r.Husband_Name__pc ,genesis__Party_Account_Name__r.PersonOtherStreet,genesis__Party_Account_Name__r.PersonOtherCity,genesis__Party_Account_Name__r.PersonOtherState,genesis__Party_Account_Name__r.PersonOtherCountry,genesis__Party_Account_Name__r.PersonOtherPostalCode,genesis__Party_Account_Name__r.Nationality__pc,genesis__Party_Account_Name__r.Residential_Status__pc ,genesis__Party_Account_Name__r.Education_Qualification__pc,genesis__Party_Account_Name__r.ID,genesis__Party_Account_Name__r.Full_Name__c,Same_Present_Address_Permanent_Address__c,Active__c,Exisiting_EMIs_Claimed_by_Customer__c,genesis__Party_Account_Name__r.Present_address_from_CBS__c,Is_ITR_required__c,Company__c,Annual_Capital_Gain1__c,Interest_Income1__c,Dividend_Income1__c,Annual_Tax1__c,Gross_Income2__c,Annual_Capital_Gain2__c,Interest_Income2__c,Dividend_Income2__c,Annual_Tax2__c,Gross_Income3__c,Interest_income3__c,Dividend_income3__c,genesis__Party_Account_Name__r.Tax_3__c,genesis__Party_Account_Name__r.Month_1_Income__c,genesis__Party_Account_Name__r.Month_2_Income__c,genesis__Party_Account_Name__r.Month_3_Income__c,genesis__Party_Account_Name__r.Month_4_Income__c,genesis__Party_Account_Name__r.Month_5_Income__c,genesis__Party_Account_Name__r.Month_6_Income__c,Amount_Paid__c,MinNMI__c,genesis__Party_Account_Name__r.Tax__c,Gross_Income1__c,genesis__Party_Account_Name__r.Agriculture_Income_itr1__c,genesis__Party_Account_Name__r.Agriculture_Income_itr2__c,genesis__Party_Account_Name__r.Agriculture_Income_itr3__c,genesis__Party_Account_Name__r.Share_of_Profit_itr_yr1__c,genesis__Party_Account_Name__r.Share_of_Profit_itr_yr2__c,genesis__Party_Account_Name__r.Share_of_Profit_itr_yr3__c,genesis__Party_Account_Name__r.Company_Pincode__c,genesis__Party_Account_Name__r.Company_City__c,genesis__Party_Account_Name__r.Company_State__c,genesis__Party_Account_Name__r.PersonOtherPhone,genesis__Party_Account_Name__r.Phone,Share_of_Profit_1__c,Share_of_Profit_2__c,Share_of_Profit_3__c,Agriculture_ITR1__c,Agriculture_ITR2__c,Agriculture_ITR3__c,Annual_Tax3__c,Annual_Capital_Gain3__c,Verify_PAN_Number__c,genesis__Party_Account_Name__r.Verify_PAN_Number__c,Existing_Emis__c,Max_Existing_EMI__c,EMI_Comments__c,Perfios_Captured__c,IsKYC__c,NMI_Approved__c,Approved_NMI_From_ITR__c,Agriculture2__c,Title_Holder__c,Official_Email_ID__c from genesis__Application_Parties__r where active__c=true and company__c=false),(select id,Amount__c,name from GMRA__r),(select id,name from genesis__Application_Document_Category__r),(select id,subject,Status from tasks),(select id,RC_Response_Error_Message__c,RC_Date__c,NameMatch__c,CollateralMatch__c,clcommon__Inspection_Report__c,Engine_No__c,Chassis_Number__c,Chassis_No__c,name,Security_Details__c,clcommon__Vehicle_Serial_Number__c,Financing_Authority__c,Vehicle_Owner_Name__c,clcommon__Certificated__c,clcommon__Collateral_Insurance_Required__c,clcommon__Homestead_Property__c,clcommon__IDERA__c,Proforma_Invoice_Date__c,Vehicle_CalculatedValue__c,clcommon__Year__c,clcommon__Model__c,Variant__c,Proforma_Invoice_No__c,Dealer_name__c,clcommon__Manufacturer__c,DD_Amount__c,DD_No__c,Approved_Cost_incurred_in_last_6_Months__c,Final_Construction__c,Date_Of_Legal_Opinion2__c,Date_Of_Valuation2__c,Instruction_to_Branch2__c,Lawyers_Name2__c,Valuers_Name2__c from genesis__Collaterals__r limit 1),(select id,Name,Document_ID__c,Signed_by_Customer_Uploaded__c,Document_Complete__c,Reviewer_Comments__c from Digio_Documnet_ID__r),(Select Id,Name,Application__c,FEC_Date__c,FEC_No__c,Is_FEC_Completed__c from FEC__r Limit 1),genesis__Account__c,Primary_Applicant__c,genesis__Account__r.Age__c,FPIPrincRepayInstal__c from  genesis__Applications__c';//V1.1//v1.2 //V1.3.1 //v1.5 //V1.6//v1.8
                               
        }
        return query; 
    }
    //Returns Application based on DSA code and Stage
    public static List<genesis__Applications__c> getApplication(String dsaID, String appSt){
        DSA_Master__c dsa = new DSA_Master__c();
        dsa = [Select Id,Branch_Code__c,Branch_Name__c,Employ_Code__c,Employ_Name__c,Role__c From DSA_Master__c Where Employ_Code__c =:dsaID Limit 1];
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        List<genesis__Applications__c> smeAppList = new List<genesis__Applications__c>();
        List<String> appStages = new List<String>{'New loan - Final sanction','New Loan - Final sanction offered','Enhancement- Final sanction','Enhancement- Final sanction offered','Exceeding-Final sanction','Exceeding- Final sanction offered','Adhoc-Final sanction','Adhoc- Final sanction offered','Interim sanction offered','Final Sanction Offered'};
            //if(appSt != '' && appSt != null) appStages.add(appSt);
            if(appSt != '' && appSt != null){
                if(dsa.Role__c =='DSA' || dsa.Role__c =='REPBG'){
                    appList   = [Select id,genesis__Account__r.Name,Type__c,RecordType.developerName,Name,Created_Date__c,Record_Type_Name__c,Primary_Applicant__c,Sanction_Doc_Generation_Check__c,Sub_Stage__c,genesis__Account__c,Project_Code__c,Sourced_By__c,Application_Stage__c,Product_Code__c,Sub_Type__c from genesis__Applications__c where Sourced_By__c =:dsaID AND Application_Stage__c =:appSt ORDER BY Name DESC];
                }
                else{
                    appList   = [Select id,Name,genesis__Account__r.Name,Type__c,Created_Date__c,RecordType.developerName,Record_Type_Name__c,Primary_Applicant__c,Sanction_Doc_Generation_Check__c,Sub_Stage__c,genesis__Account__c,Project_Code__c,Sourced_By__c,Application_Stage__c,Product_Code__c,Sub_Type__c from genesis__Applications__c where Branch_Code__c =:dsa.Branch_Code__c AND Application_Stage__c =:appSt ORDER BY Name DESC];
                }
            }
        if(appSt == 'Disbursement Applications'){
            smeAppList    =  [Select id,Name,genesis__Account__r.Name,Type__c,Created_Date__c,RecordType.developerName,Record_Type_Name__c,Primary_Applicant__c,Sanction_Doc_Generation_Check__c,Sub_Stage__c,genesis__Account__c,Project_Code__c,Sourced_By__c,Application_Stage__c,Product_Code__c,Sub_Type__c from genesis__Applications__c where Branch_Code__c =:dsa.Branch_Code__c AND Application_Stage__c IN:appStages ORDER BY Name DESC];
            if(smeAppList.size()>0) appList.addAll(smeAppList);
        }
        
        return appList;        
    }
    public static List<genesis__Applications__c> getAllApplication(){
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        List<String> appStages = new List<String>{'New loan - Final sanction','New Loan - Final sanction offered','Enhancement- Final sanction','Enhancement- Final sanction offered','Exceeding-Final sanction','Exceeding- Final sanction offered','Adhoc-Final sanction','Adhoc- Final sanction offered','Interim sanction offered','Final Sanction Offered'};
            
            appList   = [Select id,Name,genesis__Account__r.Name,Type__c,Created_Date__c,RecordType.developerName,Record_Type_Name__c,Primary_Applicant__c,Sanction_Doc_Generation_Check__c,Sub_Stage__c,genesis__Account__c,Project_Code__c,Sourced_By__c,Application_Stage__c,Product_Code__c from genesis__Applications__c where Application_Stage__c IN:appStages ORDER BY Name DESC];
        
        return appList;
    }
    public static List<genesis__Application_Document_Category__c> getappDocument(String AppId){
        List<genesis__Application_Document_Category__c> AppDocList = [Select Id, Name,Applicant__c,
                                                                      (select Id,genesis__AttachmentId__c,Document_Name__c,Dms_Uuid__c 
                                                                       from genesis__AppDocCatAttachmentJunctions__r) 
                                                                      From genesis__Application_Document_Category__c Where genesis__Application__c =:AppId];
        return AppDocList;
    }
    public static List<Account> accList(String AppID){
        Set<String> accIds = new Set<String>();
        genesis__Applications__c app = [Select Id,genesis__Account__r.ID From genesis__Applications__c where Id =:AppID];
        accIds.add(app.genesis__Account__r.ID);
        List<genesis__Application_Parties__c> partiesList = [Select Id,genesis__Party_Account_Name__c
                                                             From genesis__Application_Parties__c Where genesis__Application__c =:AppID AND Active__c = True AND Company__c = false];
        if(partiesList.size()>0){
            for(genesis__Application_Parties__c pt : partiesList){
                accIds.add(pt.genesis__Party_Account_Name__c);
            }
        }
        List <Account> accountList = [Select Id,Phone,Firm_Address__c,Company_phone__c,Company_Name__c,PersonMailingPostalCode,PersonMailingCity,PersonMailingState,PersonMailingStreet,PersonMailingCountry,Employment_SubType__c,Employment_Type__c,Firm_Pincode__c,Are_you_An_Existing_Customer__c,Name,Salutation,PersonOtherCountry,PersonOtherCity,Gender__pc,FirstName,Father_Name__pc,PersonEmail,Verify_PAN_Number__c,
                                      PersonMobilePhone,Customer_Type__c,Aadhaar_Number__pc,Pan_Number__c,Customer_IC__c,Branch_Code__c,PersonBirthdate,CBS_Prof_Code__C,
                                      Husband_Name__pc,LastName,PersonOtherStreet,PersonOtherPostalCode,PersonOtherState,Marital_Status__pc,MiddleName,Perfios_Captured__c,
                                      Nationality__pc,PersonTitle,Spouse_Name__pc,CBS_Customer_ID__c,Voter_Id__c,Passport_Number__pc,Driving_License_ID__c,
                                      National_Identification_Code__c,Other_identification_number__c,CreatedDate,Customer_ID_Creation_Date__c,NMI_Approved__c,
                                      Same_Present_Address_Permanent_Address__c,Bank_Statement__c,Telephone_Bill__c,Ration_Card__c,Employment_Letter__c,
                                      (Select Id,Digio_Document_ID__c,eSigned__c,Digio_Document_ID__r.Name,
                                       Digio_Document_ID__r.Document_ID__c,Digio_Document_ID__r.Application__c,Digio_Document_ID__r.Application__r.Sanction_Doc_Generation_Check__c From Document_Applicants__r) From Account Where Id IN: accIds];
        return accountList;
    }
    public static List<Account> accListCust(List<ID> AccID){
        List <Account> accountList = [Select Id,Phone,Name,PersonOtherCountry,PersonOtherCity,Gender__pc,FirstName,Father_Name__pc,PersonEmail,PersonMobilePhone,Customer_Type__c,Aadhaar_Number__pc,Pan_Number__c,Customer_IC__c,Branch_Code__c,PersonBirthdate,Husband_Name__pc,LastName,PersonOtherStreet,PersonOtherPostalCode,PersonOtherState,Marital_Status__pc,MiddleName,Nationality__pc,Spouse_Name__pc,CBS_Customer_ID__c,Voter_Id__c,Passport_Number__pc,Driving_License_ID__c,National_Identification_Code__c,Other_identification_number__c,CreatedDate,Customer_ID_Creation_Date__c,Same_Present_Address_Permanent_Address__c,Bank_Statement__c,Telephone_Bill__c,Ration_Card__c,Employment_Letter__c,NMI_Approved__c,Holding_Comp_Address__c,Company_Pincode__c,PersonMailingCity,PersonMailingState,Billingstreet,BillingPostalCode,Billingcity,Billingstate,RecordType.DeveloperName From Account Where Id IN: AccID];//v1.7
        return accountList;
    }    
    public static genesis__Applications__c getApp(String AppId){
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( 'genesis__Applications__c' ).getDescribe().fields.getMap();
        String query = 'SELECT ';
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';    
        }
        query   = query.removeEnd(',');
        query   = query + ' from genesis__Applications__c WHERE Id =\''+AppId+'\'';
        
        system.debug('===Start Query :::'+query);
        RETURN Database.query(query);
    }  
    
    public static List<User> getUserDetails(String whereCondition){
        Map<String, Schema.SObjectField> userFieldMap = Schema.getGlobalDescribe().get( 'User' ).getDescribe().fields.getMap();
        String query            = 'SELECT ';
        
        for(Schema.SObjectField s : userFieldMap.values()){
            query = query + s.getDescribe().getName()+',';    
        }
        query   = query.removeEnd(',');
        query   = query + ' FROM USER';
        System.debug('whereCondition::'+whereCondition);
        if(whereCondition != null && whereCondition != ''){
            query += ' WHERE '+whereCondition;
        }
        system.debug('===Start Query :::'+query);
        RETURN Database.query(query);
    }
    
    
    
    
    public static List<clcommon__Collateral_Insurance__c> getInsurance(String AppId){
        Map<String, Schema.SObjectField> InsuranceFieldMap = Schema.getGlobalDescribe().get( 'clcommon__Collateral_Insurance__c' ).getDescribe().fields.getMap();
        String query = 'SELECT ';
        for(Schema.SObjectField s : InsuranceFieldMap.values()){
            query = query + s.getDescribe().getName()+',';    
        }
        query   = query.removeEnd(',');
        query   = query + ' from clcommon__Collateral_Insurance__c WHERE application__r.id =\''+AppId+'\'';
        
        
        system.debug('===Start Query :::'+query);
        RETURN Database.query(query);
    }
    public static Account getAccount(String AccId){
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( 'Account' ).getDescribe().fields.getMap();
        String query = 'SELECT ';
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';    
        }
        query   = query.removeEnd(',');
        query   = query + ' from Account WHERE Id =\''+accId+'\'';
        
        system.debug('===Start Query :::'+query);
        RETURN Database.query(query);
    }
    //List of Applicant without Guarantor
    public static List<Account> ApplicantList(String AppID){
        Set<String> accIds = new Set<String>();
        genesis__Applications__c app = [Select Id,genesis__Account__r.ID From genesis__Applications__c where Id =:AppID];
        accIds.add(app.genesis__Account__r.ID);
        List<genesis__Application_Parties__c> partiesList = [Select Id,genesis__Party_Account_Name__c
                                                             From genesis__Application_Parties__c Where genesis__Application__c =:AppID AND genesis__Party_Type__c =: 'Co-Borrower' AND Active__c =:True];
        system.debug('partiesList:-'+partiesList);
        if(partiesList.size()>0){
            for(genesis__Application_Parties__c pt : partiesList){
                accIds.add(pt.genesis__Party_Account_Name__c);
            }
        }
        accIds.add(app.genesis__Account__r.Id);
        List <Account> accountList = [Select Id,Financial_Applicant__c,Average_Balances6_months__c,Phone,Name,PersonOtherCountry,PersonOtherCity,Gender__pc,FirstName,Father_Name__pc,PersonEmail,Verify_PAN_Number__c,
                                      PersonMobilePhone,Customer_Type__c,Aadhaar_Number__pc,Pan_Number__c,Customer_IC__c,Branch_Code__c,PersonBirthdate,Perfios_Captured__c,
                                      Husband_Name__pc,LastName,PersonOtherStreet,PersonOtherPostalCode,PersonOtherState,Marital_Status__pc,MiddleName,Additional_Income_Amount1__c,
                                      Nationality__pc,Spouse_Name__pc,CBS_Customer_ID__c,Voter_Id__c,Passport_Number__pc,Driving_License_ID__c,Full_Name__c,Agriculture1__c,
                                      National_Identification_Code__c,Other_identification_number__c,CreatedDate,Customer_ID_Creation_Date__c,NMI_Approved__c,
                                      Same_Present_Address_Permanent_Address__c,Bank_Statement__c,Telephone_Bill__c,Ration_Card__c,Employment_Letter__c,Annual_Agriculture_Income_ITR__c,Agriculture2__c,
                                      (Select Id,Digio_Document_ID__c,eSigned__c,Digio_Document_ID__r.Name,
                                       Digio_Document_ID__r.Document_ID__c From Document_Applicants__r) From Account Where Id IN: accIds AND Financial_Applicant__c =:true];
        return accountList;
    }
    //return state city code
    public static string getCode(String name, String seq){
        if(name != null && name != '' && seq =='1'){  //Country
            List<Country_Master__mdt> concode = [Select ID,MasterLabel,Code__c From Country_Master__mdt where MasterLabel =:name];
            if(!concode.isEmpty()){
                if(concode[0].code__c !=null){
                    return concode[0].code__c;  
                }else{
                    return '';
                }               
            }else{
                return '';
            } 
        }else if(name != null && name != '' && seq =='2'){ //State
            List<State__mdt> stCode  = [Select ID,MasterLabel,COD_STATE__c From State__mdt Where MasterLabel =:name]; 
            if(!stCode.isEmpty()){
                if(stCode[0].COD_STATE__c != null){
                    return stCode[0].COD_STATE__c;
                }else{
                    Return '';
                }
            } 
            else {
                Return '';
            }
            
        }else if(name != null && name != '' && seq =='3'){ //City
            List<City_Master__c> cityCode = [Select Id,Name,CODCITY__c From City_Master__c Where Name =:name];
            if(!cityCode.isEmpty()){
                if(cityCode[0].CODCITY__c != null){
                    return cityCode[0].CODCITY__c;
                }else{
                    RETURN '';
                }
            }
            
            else{
                RETURN '';
            }                          
        }          
        return null;
    }
    public static String getPartyRelType(String partyType){
        Map<String,String> partyrelCodeMap = new Map<String,String>();
        partyrelCodeMap.put('Joint or others','JOO');
        partyrelCodeMap.put('Joint or first','JOF'); 
        partyrelCodeMap.put('Joint and first','JAF');
        partyrelCodeMap.put('Joint and others','JAO');
        partyrelCodeMap.put('Sole Owner','SOW');
        partyrelCodeMap.put('Proprietor','PRO');
        partyrelCodeMap.put('Partner','PAR');
        partyrelCodeMap.put('Authorised Signatory','AUS');
        partyrelCodeMap.put('Guarantor','GUA');
        partyrelCodeMap.put('Third party','THR');
        
        RETURN partyrelCodeMap.get(partyType);
    }
    public static List<clcommon__Collateral__c> getCollateral(String AppID){
        //added by prashant singh on 22-11-2018....collateral structure changes..
        List<clcommon__Collateral__c> colList = [Select Id,Total_cost_incurred_till_date__c,Cost_incurred_in_the_last_6_months__c,Age_Of_The_Building__c,Builder_Present_Owner_Seller_Name__c,Month__c,Cost_of_Property__c,Area_of_the_Land__c,Property_Pincode__c,Cost_Of_Repair__c,Location_Of_The_Property__c,clcommon__Property_Type__c,Market_Value_Of_The_Land__c,Reff_by_Dealer__c,Scheme_Type__c,Manual_Dealer__c,ExshowRoomPrice_Api__c,Final_vehicle_value__c,Advances_Paid__c,Proforma_Invoice_No__c,Proforma_Invoice_Date__c, clcommon__Manufacturer__c,clcommon__Year__c,clcommon__Model__c,Variant__c,Dealer_name__c,Dealer_Email__c, Dealer_Pincode__c,Dealer_Phone_Number__c,   ExShow_Room_Price__c,Registration_cost__c,Accessories_value__c, Total_Vehicle_Value__c,clcommon__Insurance_Amount__c,
                                                 MORT_TYPE__c,clcommon__Address__c,State__c,clcommon__State__c,clcommon__City__c,Flat_Door_Shop_Bungalow_Nos__c,Cost_Of_Flat_House__c,Valuation_Date__c,Total_Market_value__c,
                                                 EM_Charge_type__c,Vehicle_CalculatedValue__c,Whether_The_Construction_Completed__c,Cost_Of_Construction__c,Cost_Of_Land__c,Property_Address__c,No_of_tenants__c,Vacant_Land_area__c,Collateral_Use__c,Collateral_Type__c,RC_No__c,
                                                 Collateral_Uses__c,clcommon__Vehicle_Serial_Number__c,Chassis_Number__c,EM_Charge_Types__c,Collateral_Market_Value__c,clcommon__Postal_Code__c,
                                                 (Select Id,Account__r.Name,Account__r.Id from Ownerships__r) from clcommon__Collateral__c Where genesis__Application__c =:AppID];//Collateral_Use__c//v1.8
        return colList;
    }
    // CBS005 - bulkAPI response and retry code
    public static List<clcommon__Collateral__c> getCollateralWithAccID(List<ID> AccIDs,String AppID,String whereCondition){
        String whereFiltrs = '';
        if(whereCondition == 'CC'){ whereFiltrs = 'RetryColltrlCBS__c = False';
                                  }else if(whereCondition == 'CL'){ whereFiltrs ='RetryLinkColltrlCBS__c = False';}
        
String colList = 'Select Id,Location_Of_The_Property__c,Area_of_the_Land__c,Month__c,RetryColltrlCBS__c,Reff_by_Dealer__c,Scheme_Type__c,Manual_Dealer__c,ExshowRoomPrice_Api__c,Final_vehicle_value__c,Advances_Paid__c,Proforma_Invoice_No__c,Proforma_Invoice_Date__c,clcommon__Manufacturer__c,clcommon__Year__c,clcommon__Model__c,Variant__c,Dealer_name__c,Dealer_Email__c, Dealer_Pincode__c,Dealer_Phone_Number__c,   ExShow_Room_Price__c,Registration_cost__c,Accessories_value__c, Total_Vehicle_Value__c,clcommon__Insurance_Amount__c,MORT_TYPE__c,clcommon__Address__c,State__c,clcommon__City__c,Valuation_Date__c,Total_Market_value__c,EM_Charge_type__c,Vehicle_CalculatedValue__c,No_of_tenants__c,Vacant_Land_area__c,Collateral_Use__c,Collateral_Type__c,RC_No__c, Collateral_Uses__c,clcommon__Vehicle_Serial_Number__c,Chassis_Number__c,EM_Charge_Types__c,Collateral_Market_Value__c,clcommon__Postal_Code__c,CBS_Collateral_ID__c,(Select Id,Account__r.Name,Account__r.Id from Ownerships__r where Account__r.Id IN:AccIDs) from clcommon__Collateral__c Where genesis__Application__c =:AppID AND '+whereFiltrs;        
        return Database.query(colList);
    }
    //Account count
    public static Integer getAccCount(String AppId){
        List <genesis__Application_Parties__c> PTAccList = [select Id, genesis__Application__c, genesis__Party_Account_Name__c, genesis__Party_Type__c, Product_Type__c, Active__c, genesis__Application__r.genesis__Account__c From genesis__Application_Parties__c where genesis__Party_Type__c = 'Co-Borrower' AND Active__c = true AND genesis__Application__c =:AppId];
        Map<String,Integer> countMap = new Map<String,Integer>();
        
        Integer flag=0;
        if(!PTAccList.isEmpty()){
            flag =1;
            for(genesis__Application_Parties__c rec:PTAccList){
                if(!countMap.containsKey(rec.genesis__Party_Account_Name__c)){
                    if(rec.genesis__Party_Account_Name__c != rec.genesis__Application__r.genesis__Account__c) {
                        countMap.put(rec.genesis__Party_Account_Name__c, flag);
                        flag++;
                    }
                }
            }
        }
        System.debug(flag);
        
        if(flag>0)
            return flag;
        else{
            return 1;
        }
    }
    
    public static Decimal getCLProd(String AppId){
        genesis__Applications__c clPro = [SELECT Id,genesis__CL_Product__r.Max_Number_of_Applicants__c FROM genesis__Applications__c WHERE Id =: AppId];
        return clPro.genesis__CL_Product__r.Max_Number_of_Applicants__c;
    }
    public static List<genesis__Application_Parties__c> getCompany(String AppId){
        List <genesis__Application_Parties__c> PTList = [select Id,Key_Contact__r.CBS_Customer_ID__c,Key_Contact__r.Name,Key_Contact__r.BillingState,Key_Contact__r.BillingPostalCode,
                                                         Key_Contact__r.Pan_Number__c,Key_Contact__r.Relationship_with_Firm__c,Key_Contact__r.Firm_Pincode__c,genesis__Party_Account_Name__r.Id,Key_Contact__r.BillingCity,Key_Contact__r.BillingStreet,
                                                         Key_Contact__r.Firm_type__c,Key_Contact__r.Firm_Address__c From genesis__Application_Parties__c where Company__c =: true AND Active__c =:true AND genesis__Application__c =:AppId];//,Key_Contact__r.Firm_Address__c
        return PTList;
    }
    
    
    ///// for parties fields details
    
    public static List<genesis__Application_Parties__c> getparties(String AppId){
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( 'genesis__Application_Parties__c' ).getDescribe().fields.getMap();
        String query = 'SELECT ';
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';    
        }
        query   = query.removeEnd(',');
        query   = query + ' from genesis__Application_Parties__c WHERE  genesis__Application__c =\''+AppId+'\''+'AND Active__c =True AND Company__c =false AND (genesis__Party_Type__c=\''+Constants.Co_Borrower+'\' OR  genesis__Party_Type__c=\''+Constants.PRIMARY_APP+'\' OR  genesis__Party_Type__c=\''+Constants.Gurantor+'\')';  
        
        system.debug('===Start Query :::'+query);
        RETURN Database.query(query);
    }  
    public static List<Account> acclistwithset(set<Id> accid){
        List<Account> acclist=[select id,Verify_PAN_Number__c from Account where ID IN: accid] ;
        return acclist;
    }
    
    public static genesis__Application_Parties__c PartieswithAcc(String AccID ,String AppID){
        genesis__Application_Parties__c par=[select id,genesis__Party_Account_Name__c,Employment_Types__c,NMI_as_per_ITR__c,ITR_Uploaded__c,Computed_NMI__c,NMI_as_per_BS__c,NMI_as_per_26AS__c from genesis__Application_Parties__c where genesis__Party_Account_Name__c =:AccId  AND Active__c =:True AND Company__c =:false AND genesis__Application__c=: AppID];
        System.debug('par'+par);
        return par;
    }
    
    // Remodel Query party using appid
    public static list<genesis__Application_Parties__c> PartyListApp(String AppId){
        
        List<genesis__Application_Parties__c> partyLists=[SELECT Id,Employment_Type__c,Primary_Bank__c,Name,genesis__Application__c,genesis__Credit_Report__c,genesis__Party_Account_Name__c,genesis__Party_Name__c,genesis__Party_Type__c,Active__c,Guarantor__c,Joint_Holder__c,Key_Contact__c,Party_Email__c,Party_Mobile_No__c,Party_Sub_Type__c,Relationship_to_Borrower__c,Signatories__c,Title_Holder__c,Critical_Change__c,Is_New__c,Deleted__c,Applicant_Name__c,Application_No__c,
                                                          Signer_page_no__c,Identifier__c,llx__c,lly__c,urx__c,ury__c,Status__c,eSign_done__c,External_ID__c,Product_Type__c,Company__c,DO_HEAD_Comment__c,CIBIL_Score__c,Date_of_Birth__c,NMI_Claimed_NMIITR__c,NMI_Approved_NMIITR__c,Total_Annual_Additional_Income_Claimed__c,Total_Annual_Additional_Income_Approve__c,Financial_Flag__c,Cheque_Returns__c,Average_CASA_Balance__c,
                                                          CIBIL_EMI_Override__c,Pension_Income2__c,Additional_Income_Amount1__c,Additional_Income_Amount2__c,Additional_Income_Amount3__c,Additional_Income_Amount4__c,Additional_Income_Amount5__c,Additional_Income__c,Age__c,Agriculture2__c,Agriculture_ITR1__c,Agriculture_ITR2__c,Agriculture_ITR3__c,Amount_Paid__c,Annual_Agriculture_Income_Claimed__c,Annual_Agriculture_Income_ITR__c,Annual_Capital_Gain1__c,Annual_Capital_Gain2__c,
                                                          Annual_Capital_Gain3__c,Annual_Other_IncomeRecurring_CreditsITR__c,Annual_Other_Income_Claimed__c,Annual_Share_of_Profit_Firm_ITR__c,Annual_Share_of_Profit_Firm__c,Annual_Tax1__c,Annual_Tax2__c,Annual_Tax3__c,Approved_NMI_From_ITR__c,Approved_NMI_LAP__c,Average_Balances_6_months__c,Balance_Outstandings__c,Bank_Account_Number__c,Built_up_Area__c,Bureau_Score__c,CBS_Prof_Code__c,CIBIL_EMI__c,Company_Phone__c,Company_Pincode__c,
                                                          Computed_NMI__c,Disbursement_Esign__c,Dividend_Income1__c,Dividend_Income2__c,Dividend_Income3__c,EMI_of_Last_Month__c,Employment_SubType__c,Employment_Types__c,Estimated_Business_Income__c,Exisiting_EMIs_Claimed_by_Customer__c,Existing_EMI_Perfios__c,Existing_Emis__c,Financial_Applicant__c,Gross_Income1__c,Gross_Income2__c,Gross_Income3__c,Is_Bank_Statement_required__c,IFSC_code__c,ITR_Uploaded__c,Income_Computation_From__c,
                                                          Interest_Income1__c,Interest_Income2__c,Interest_Income3__c,Is_Existing_Customer__c,Is_ITR_required__c,KVB_EMI__c,MOD_Esign__c,Maturity_date__c,Max_Existing_EMI__c,MinNMI__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,NMI_as_per_26AS__c,NMI_as_per_BS__c,NMI_as_per_ITR__c,NMax__c,Net_Amount_Paid__c,Net_Annual_Income1__c,Net_Annual_Income2__c,Net_Annual_Income3__c,Net_Monthly_Income__c,Others_Income2__c,Perfios_Captured__c,
                                                          Perfios_error_message__c,PreClosureInterestRate__c,Product_Code__c,Salary_Continous_Flag__c,Salary_Credited_1__c,Salary_Credited_2__c,Salary_Credited_3__c,Salary_Credited_4__c,Salary_Credited_5__c,Salary_Credited_6__c,Same_Present_Address_Permanent_Address__c,Share_of_Profit_1__c,Share_of_Profit_2__c,Share_of_Profit_3__c,Source_of_Income1__c,Source_of_Income2__c,
                                                          Source_of_Income3__c,Source_of_Income4__c,Source_of_Income5__c,Tax_3__c,Tax_Deducted__c,Tax__c,Total_Additional_Income__c,Total_Annual_other_Income_Approved__c,Total_Annual_other_Income_Claimed__c,Total_ChequeECS_bounces__c,Total_Loan_Amount__c,EMI_Comments__c,Year1__c,Year2__c,Year3__c,Age_In_Months__c,CIBIL_Scores__c,Eligible_EMI1__c,KVB_Emi_Help__c,
                                                          genesis__Party_Account_Name__r.id,Verify_PAN_Number__c,genesis__Party_Account_Name__r.Customer_IC__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.Voter_Id__c,genesis__Party_Account_Name__r.Passport_Number__pc,genesis__Party_Account_Name__r.Driving_License_ID__c,genesis__Party_Account_Name__r.National_Identification_Code__c,
                                                          genesis__Party_Account_Name__r.Other_identification_number__c,genesis__Party_Account_Name__r.Gender__pc,genesis__Party_Account_Name__r.PersonBirthdate,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.CreatedDate,genesis__Party_Account_Name__r.Telephone_Bill__c,genesis__Party_Account_Name__r.Ration_Card__c,genesis__Party_Account_Name__r.Employment_Letter__c,genesis__Party_Account_Name__r.Bank_Statement__c 
                                                          from genesis__Application_Parties__c WHERE  genesis__Application__c =: AppId AND Active__c = True AND RetryEkyc__c = False AND Company__c = false AND (genesis__Party_Type__c =: Constants.Co_Borrower OR genesis__Party_Type__c =:Constants.PRIMARY_APP)];
        system.debug('partyLists:--'+partyLists);
        return partyLists;
    }
    
    //Query party using appid and list of AccID for Ekyc
    public static list<genesis__Application_Parties__c> PartyListPartyIDs(List<ID> AccId,String AppId){
        
        List<genesis__Application_Parties__c> partyLists=[SELECT Id,Primary_Bank__c,RetryEkyc__c,Name,genesis__Application__c,genesis__Credit_Report__c,genesis__Party_Account_Name__c,genesis__Party_Name__c,genesis__Party_Type__c,Active__c,Guarantor__c,Joint_Holder__c,Key_Contact__c,Party_Email__c,Party_Mobile_No__c,Party_Sub_Type__c,Relationship_to_Borrower__c,Signatories__c,Title_Holder__c,Critical_Change__c,Is_New__c,Deleted__c,Applicant_Name__c,Application_No__c,
                                                          Signer_page_no__c,Identifier__c,llx__c,lly__c,urx__c,ury__c,Status__c,eSign_done__c,External_ID__c,Product_Type__c,Company__c,DO_HEAD_Comment__c,CIBIL_Score__c,Date_of_Birth__c,NMI_Claimed_NMIITR__c,NMI_Approved_NMIITR__c,Total_Annual_Additional_Income_Claimed__c,Total_Annual_Additional_Income_Approve__c,Financial_Flag__c,Cheque_Returns__c,Average_CASA_Balance__c,
                                                          CIBIL_EMI_Override__c,Pension_Income2__c,Additional_Income_Amount1__c,Additional_Income_Amount2__c,Additional_Income_Amount3__c,Additional_Income_Amount4__c,Additional_Income_Amount5__c,Additional_Income__c,Age__c,Agriculture2__c,Agriculture_ITR1__c,Agriculture_ITR2__c,Agriculture_ITR3__c,Amount_Paid__c,Annual_Agriculture_Income_Claimed__c,Annual_Agriculture_Income_ITR__c,Annual_Capital_Gain1__c,Annual_Capital_Gain2__c,
                                                          Annual_Capital_Gain3__c,Annual_Other_IncomeRecurring_CreditsITR__c,Annual_Other_Income_Claimed__c,Annual_Share_of_Profit_Firm_ITR__c,Annual_Share_of_Profit_Firm__c,Annual_Tax1__c,Annual_Tax2__c,Annual_Tax3__c,Approved_NMI_From_ITR__c,Approved_NMI_LAP__c,Average_Balances_6_months__c,Balance_Outstandings__c,Bank_Account_Number__c,Built_up_Area__c,Bureau_Score__c,CBS_Prof_Code__c,CIBIL_EMI__c,Company_Phone__c,Company_Pincode__c,
                                                          Computed_NMI__c,Disbursement_Esign__c,Dividend_Income1__c,Dividend_Income2__c,Dividend_Income3__c,EMI_of_Last_Month__c,Employment_SubType__c,Employment_Types__c,Estimated_Business_Income__c,Exisiting_EMIs_Claimed_by_Customer__c,Existing_EMI_Perfios__c,Existing_Emis__c,Financial_Applicant__c,Gross_Income1__c,Gross_Income2__c,Gross_Income3__c,Is_Bank_Statement_required__c,IFSC_code__c,ITR_Uploaded__c,Income_Computation_From__c,
                                                          Interest_Income1__c,Interest_Income2__c,Interest_Income3__c,Is_Existing_Customer__c,Is_ITR_required__c,KVB_EMI__c,MOD_Esign__c,Maturity_date__c,Max_Existing_EMI__c,MinNMI__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,NMI_as_per_26AS__c,NMI_as_per_BS__c,NMI_as_per_ITR__c,NMax__c,Net_Amount_Paid__c,Net_Annual_Income1__c,Net_Annual_Income2__c,Net_Annual_Income3__c,Net_Monthly_Income__c,Others_Income2__c,Perfios_Captured__c,
                                                          Perfios_error_message__c,PreClosureInterestRate__c,Product_Code__c,Salary_Continous_Flag__c,Salary_Credited_1__c,Salary_Credited_2__c,Salary_Credited_3__c,Salary_Credited_4__c,Salary_Credited_5__c,Salary_Credited_6__c,Same_Present_Address_Permanent_Address__c,Share_of_Profit_1__c,Share_of_Profit_2__c,Share_of_Profit_3__c,Source_of_Income1__c,Source_of_Income2__c,
                                                          Source_of_Income3__c,Source_of_Income4__c,Source_of_Income5__c,Tax_3__c,Tax_Deducted__c,Tax__c,Total_Additional_Income__c,Total_Annual_other_Income_Approved__c,Total_Annual_other_Income_Claimed__c,Total_ChequeECS_bounces__c,Total_Loan_Amount__c,EMI_Comments__c,Year1__c,Year2__c,Year3__c,Age_In_Months__c,CIBIL_Scores__c,Eligible_EMI1__c,KVB_Emi_Help__c,
                                                          genesis__Party_Account_Name__r.id,Verify_PAN_Number__c,genesis__Party_Account_Name__r.Customer_IC__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.Voter_Id__c,genesis__Party_Account_Name__r.Passport_Number__pc,genesis__Party_Account_Name__r.Driving_License_ID__c,genesis__Party_Account_Name__r.National_Identification_Code__c,
                                                          genesis__Party_Account_Name__r.Other_identification_number__c,genesis__Party_Account_Name__r.Gender__pc,genesis__Party_Account_Name__r.PersonBirthdate,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.CreatedDate,genesis__Party_Account_Name__r.Telephone_Bill__c,genesis__Party_Account_Name__r.Ration_Card__c,genesis__Party_Account_Name__r.Employment_Letter__c,genesis__Party_Account_Name__r.Bank_Statement__c 
                                                          from genesis__Application_Parties__c WHERE  genesis__Application__c =: AppId AND Active__c = True AND genesis__Party_Account_Name__r.id IN:AccId AND Company__c = false AND RetryEkyc__c = False AND (genesis__Party_Type__c =: Constants.Co_Borrower OR genesis__Party_Type__c =:Constants.PRIMARY_APP OR genesis__Party_Type__c =:Constants.Gurantor)];
        //system.debug('partyLists:--'+partyLists);
        return partyLists;
    }
    
    // Scheme Master for Vehicle loans
    public static List<Scheme_Master__c> getSchemes(){
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( 'Scheme_Master__c' ).getDescribe().fields.getMap();
        String query = 'SELECT ';
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';    
        }
        query   = query.removeEnd(',');
        query   = query + ' from Scheme_Master__c WHERE Active_Flag__c =True AND Start_Date__c <= Today AND End_Date__c >=Today ';  
        
        system.debug('===Scheme_Master__c Start Query :::'+query);
        RETURN Database.query(query);
    }
    //AccountAppNMI junction Return information
    public static AppAccountNMIJunction__c getNMIJunction(String AccId,String AppID){
        
        if(AccId <> null && AccId <> '' && AppID <> null && AppID <> ''){
            String query1 = 'SELECT Account__c,Application__c,Computed_NMI__c,Name,NMI_as_per_26AS__c,NMI_as_per_BS__c, NMI_as_per_ITR__c FROM AppAccountNMIJunction__c WHERE  Account__r.id =\''+AccId+'\' AND Application__r.id=\''+AppID+'\' LIMIT 1';
            system.debug('===Start Query 1 :::'+query1);
            try{
                RETURN Database.query(query1);
            }catch(exception e){
                AppAccountNMIJunction__c newAppAcJunction = new AppAccountNMIJunction__c();
                newAppAcJunction.Account__c = AccId;
                newAppAcJunction.Application__c = AppID;
                insert newAppAcJunction;
                RETURN newAppAcJunction;
            }
        }
        RETURN null;
    }
    
    //v1.7(start)
    public static List<Astute_Verification__c> getAstuteRecord(String appId){
        try {
            List<Astute_Verification__c> astList = new List<Astute_Verification__c>();
            astList = [SELECT Id,Application__c, Accessibility__c, Account__c, Address_Confirmed__c, Applicant_Relationship__c, Area_SqFt__c, Asset__c, Business_Activity_Level__c, Carpet_Area__c, Case_Id__c, Case_Notification_Id__c, Colleague_Designation__c, Colleague_Mobile__c, Colleague_Name__c, Colleague_Telephone__c, Colleague_Visiting_Card_Obtained__c, Commets__c, Construction__c, Date_Of_Joining__c, Date_of_Visit__c, DeDupe_Remark__c, DeDupe_Status__c, Designation_Of_The_Official_Met__c, Designation__c, Duration_Of_Stay__c, Employer_Address__c, Employer_Name__c, Employer_Verification__c, Employer__c, External_Appearance__c, Grade__c, Internal_Appearance__c, Lift__c, Locality__c, Message__c, Name_of_the_Official_met__c, Nature_Of_Business__c, Nature_Of_Job__c, Negaitve__c, Neighbour_Feedback__c, No_Of_Person_Staying__c, No_Of_Sighted_Clients__c, No_Of_Sighted_Employees__c, No_Of_Storeys__c, Office_Type__c, Ownership_Status__c, PF_Number__c, Person_Contacted__c, Political_Link__c, Prominent_Landmark__c, Property_Type__c, Relationship_With_Applicant__c, Residence_Type__c, Residence_Verification__c, Salary__c, Service_Duration__c, Status_ID__c, Status__c, Stay_Status__c, Time_Of_The_Day__c, Time_of_Visit__c, Type_Of_Job__c, Verifier_Name__c, department__c, Requested_Pincode__c, Expected_Date__c, Active_business_operation_observed__c, Area_Accessibility__c, Change_in_Address__c, Contacted_Person__c, Duration_Of_Stay_Current_Address__c, Employee_ID__c, Office_Name__c, Ownership_Type__c, Person_Residence_Type__c, Revised_Address__c, Role_in_Business__c, Type_of_Business__c, Employment_Type__c, Requested_Address__c, Official_Email_ID__c FROM Astute_Verification__c where Application__c =: appid];
            return astList;
        } catch(Exception e) {
            System.debug('queryService.getAstuteRecord() error LineNumber'+e.getLineNumber()+' message '+e.getMessage());
            HandleBusinessException.captureError('queryService', 'getAstuteRecord', e);
            return null;
        }
    }
    //v1.7(end)
    
    //v1.8(start)
    public static List<Facility__c> getFacilityRecord(String appId,Boolean topup_Select){
        try {
            Map<String, Schema.SObjectField> facilityFieldMap = Schema.getGlobalDescribe().get( 'Facility__c' ).getDescribe().fields.getMap();
            String query = 'SELECT ';
            for(Schema.SObjectField s : facilityFieldMap.values()){
                query = query + s.getDescribe().getName()+',';    
            }
            query   = query.removeEnd(',');
            if (topup_Select)
                query   = query + ' from Facility__c WHERE Application__c = \''+appId+'\' AND Active__c = true AND Selected_for_Top_Up__c = true';
            else
                query   = query + ' from Facility__c WHERE Application__c = \''+appId+'\' AND Active__c = true';

            System.debug('***Facility Query :::'+query);
            RETURN Database.query(query);
        } catch(Exception e) {
            System.debug('queryService.getFacilityRecord() error LineNumber'+e.getLineNumber()+' message '+e.getMessage());
            HandleBusinessException.captureError('queryService', 'getFacilityRecord', e);
            return null;
        }
    }
    //v1.8(end)
     public static List<CBS_API_Log__c> getCbsLogRecord(String appId,String apiname,String success,string seq){
        try {
            Map<String, Schema.SObjectField> CbsLogFieldMap = Schema.getGlobalDescribe().get( 'CBS_API_Log__c' ).getDescribe().fields.getMap();
            String query = 'SELECT id';
            
         
                query   = query + ' from CBS_API_Log__c WHERE Application__c = \''+appId+'\' AND Status__c =\''+success+'\' AND API_Name__c =\''+apiname+'\' AND  Sequence_No__c = \''+seq+'\' ';
           
            System.debug('***cbs log Query :::'+query);
            RETURN Database.query(query);
        } catch(Exception e) {
            System.debug('queryService.getFacilityRecord() error LineNumber'+e.getLineNumber()+' message '+e.getMessage());
            HandleBusinessException.captureError('queryService', 'getFacilityRecord', e);
            return null;
        }
    }

    
}