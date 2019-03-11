/*
* Name      : AccountEODResponse_Handler
* Company   : ET Marlabs
* Purpose   : To used as a Handler class for AccountEODResponse. 
* Author    : Raushan
*/

public class AccountEODResponse_Handler{
    
    public static WS_AccountEODDeltaChange.Response  getAccountEOD(AccountEODResponse acctEODRes){
        List<String> colleteralIdToDelete = new List<String>();
        List<String> inactivePartiesList = new List<String>();
        List<String> colIdList = new List<String>();
        //List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();
        WS_AccountEODDeltaChange.Response res = new WS_AccountEODDeltaChange.Response();
        WS_AccountEODDeltaChange.AccInsertResponse  accInsertRes; 
        WS_AccountEODDeltaChange.AccSuccessResponse accSuccessRes; 
        Map<String,genesis__Applications__c> custIdAppMap = new Map<String,genesis__Applications__c>();
        Map<String,Map<String,Boolean>> inActiveFacilityCheckMap = new Map<String,Map<String,Boolean>>();
        String deactiveAppId;
        
        //List of Developer Name
        List<String> listDeveloperName = new List<String>{'Business_Account','PersonAccount','SME_Renewal','Term_Loan','Child','Land_And_Building','Parent'};
            //Map<String,id> recordtypeIdMap = Utility.getRecordTypeID(listDeveloperName);
            Map<String,id> recordtypeIdMap = new Map<String,id>();
        recordtypeIdMap.put('Business_Account',Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId());
        recordtypeIdMap.put('PersonAccount',Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        recordtypeIdMap.put('SME_Renewal',Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId());
        recordtypeIdMap.put('Term_Loan',Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Term Loan').getRecordTypeId());
        recordtypeIdMap.put('Land_And_Building',Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId());
        recordtypeIdMap.put('Other',Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Other').getRecordTypeId());
        recordtypeIdMap.put('Parent',Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId());
        
        List<Integer> listSucess       = new List<Integer>();
        Set<String> custIdSet = new Set<String>();
        
        Integer Total_NumberOF_Request = 0;
        Integer successCount = 0;
        
        If(acctEODRes !=null){
            Decimal oneYrMCLR = 0.0;
            oneYrMCLR = [SELECT MCLR_Of_Interest__c FROM MCLR_Master__c WHERE COD_Term_From__c >= 365].MCLR_Of_Interest__c;
            AccountEODResponse.cls_out_msg  outMsgObj   =   acctEODRes.out_msg;
            
            Map<string,genesis__Applications__c> mapApplication =   new  Map<string,genesis__Applications__c>();
            Map<String,string> collateralVsAppCollateral    = new Map<String,string>();
            
            If(outMsgObj !=null && Integer.valueOf(outMsgObj.total_size) <=10){
                Total_NumberOF_Request = Integer.valueOf(outMsgObj.total_size);
                List<AccountEODResponse.cls_ACCOUNT> listAccount    =   outMsgObj.ACCOUNT;
                Set<String> branchCodeSet = new Set<String>();
                if(listAccount !=null && ! listAccount.isEmpty()){
                    Integer i = 0;
                    for(AccountEODResponse.cls_ACCOUNT  accountWrppObj  :   listAccount){
                        AccountEOD_Helper.getAppDetailsUpdated(accountWrppObj);
                        List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();
                        Map<String,Boolean> colIdBoolMap = new Map<String,Boolean>();
                        Map<String,Boolean> partyCbsIdMap = new Map<String,Boolean>();
                        Boolean is_Facility_Inactive = false;
                        List<Account> listAccountObject = new List<Account>();
                        List<Account> personAccList = new List<Account>();
                        List<genesis__Applications__c> listApp      =   new List<genesis__Applications__c>();
                        List<Facility__c> listFacility              =   new List<Facility__c>();
                        List<genesis__Applications__c> appToUpdateList = new List<genesis__Applications__c>();
                        List<genesis__Applications__c> appToInsertList = new List<genesis__Applications__c>();
                        List<genesis__Applications__c> appLessToUpsert = new List<genesis__Applications__c>();
                        List<genesis__Applications__c> appToUpsertList = new List<genesis__Applications__c>();
                        
                        Map<String,clcommon__Collateral__c> mapCOllateral = new Map<String,clcommon__Collateral__c> ();
                        List<genesis__Application_Collateral__c> listAppCollateral = new List<genesis__Application_Collateral__c>();
                        Map<String,Ownership__c> mapOwnership       =   new Map<String,Ownership__c>();
                        Map<String,Survey__c> mapSurvey             =   new Map<String,Survey__c>();
                        List<clcommon__Collateral_Insurance__c> listInsurance   =   new List<clcommon__Collateral_Insurance__c>();
                        List<Group_Concern__c> listGroupConcern     =   new List<Group_Concern__c>();
                        
                        accInsertRes =  new WS_AccountEODDeltaChange.AccInsertResponse(); 
                        accSuccessRes = new WS_AccountEODDeltaChange.AccSuccessResponse(); 
                        Savepoint sp = Database.setSavepoint();
                        System.debug('CustId111:::'+accountWrppObj.customer_id);
                        Account accountMainObj      =   new Account();
                        if(accountWrppObj !=null){
                            try{
                                If(!Utility.ISStringBlankorNull(accountWrppObj.name))
                                    accountMainObj.name     =   accountWrppObj.name;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.customer_id)){
                                    accountMainObj.CBS_Customer_ID__c   =   accountWrppObj.customer_id;
                                }
                                If(!Utility.ISStringBlankorNull(accountWrppObj.account_open_date))
                                    accountMainObj.ACCT_OPEN_DATE__c    =   Date.parse(accountWrppObj.account_open_date);
                                If(!Utility.ISStringBlankorNull(accountWrppObj.banking_with_us))
                                    accountMainObj.Banking_with_us__c   =   Date.parse(accountWrppObj.banking_with_us);
                                If(!Utility.ISStringBlankorNull(accountWrppObj.is_kvb_director)){
                                    accountMainObj.IS_KVB_DIRECTOR__C   =   checkBooleanReq(accountWrppObj.is_kvb_director);
                                }
                                
                                If(!Utility.ISStringBlankorNull(accountWrppObj.branch_code))
                                    accountMainObj.Branch_Code__c       =   accountWrppObj.branch_code; 
                                If(!Utility.ISStringBlankorNull(accountWrppObj.branch_name))
                                    accountMainObj.Branch_Name__c       =   accountWrppObj.branch_name;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.export_zone)){
                                    accountMainObj.Export_Zone__c = checkBooleanReq(accountWrppObj.export_zone);
                                } 
                                If(!Utility.ISStringBlankorNull(accountWrppObj.cin_number))
                                    accountMainObj.CIN_Number__c            =   accountWrppObj.cin_number;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.pan_number))
                                    accountMainObj.Pan_Number__c            =   accountWrppObj.pan_number;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.chief_person_name))
                                    accountMainObj.Name_of_the_Chief_Person__c =  accountWrppObj.chief_person_name;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.contact_person_name))
                                    accountMainObj.Contact_Person_Name__c   =   accountWrppObj.contact_person_name;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.contact_person_designation))
                                    accountMainObj.Contact_Person_Designation__c  =     accountWrppObj.contact_person_designation; 
                                If(!Utility.ISStringBlankorNull(accountWrppObj.constitution))
                                    accountMainObj.Constitution__c          =   accountWrppObj.constitution; 
                                If(!Utility.ISStringBlankorNull(accountWrppObj.customer_type)) 
                                    accountMainObj.Customer_Type__c         =   accountWrppObj.customer_type;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.date_of_incorporation)) 
                                    accountMainObj.Date_of_Incorporation__c =   Date.parse(accountWrppObj.date_of_incorporation);
                                If(!Utility.ISStringBlankorNull(accountWrppObj.firm_company_was_reconstituted)){
                                    accountMainObj.Firm_Company_was_Reconstituted__c = checkBooleanReq(accountWrppObj.firm_company_was_reconstituted);
                                }
                                If(!Utility.ISStringBlankorNull(accountWrppObj.gst_number))
                                    accountMainObj.GST_Number__c                =   accountWrppObj.gst_number;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.ie_code))
                                    accountMainObj.IE_Code__c               =   accountWrppObj.ie_code;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.industry_type))
                                    accountMainObj.Industry_Type__c             =   accountWrppObj.industry_type;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.line_of_activity)){
                                    accountMainObj.Line_of_Activity__c      =   accountWrppObj.line_of_activity;
                                    If(accountWrppObj.Line_of_activity == 'Service Provision'){
                                        accountMainObj.Cash_Budget__c = true;
                                    }
                                }
                                If(!Utility.ISStringBlankorNull(accountWrppObj.national_identification))
                                    accountMainObj.National_Identification_Code__c  =   accountWrppObj.national_identification;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.networth_as_on))
                                    accountMainObj.Networth_as_on__c        =   Date.parse(accountWrppObj.networth_as_on);
                                If(!Utility.ISStringBlankorNull(accountWrppObj.existing_networth))
                                    accountMainObj.Existing_Networth__c         =   Decimal.valueOf(accountWrppObj.existing_networth);
                                If(!Utility.ISStringBlankorNull(accountWrppObj.number_of_share_held))
                                    accountMainObj.Number_of_Shares_Held__c     =   Integer.valueOf(accountWrppObj.number_of_share_held);
                                If(!Utility.ISStringBlankorNull(accountWrppObj.over_due))
                                    accountMainObj.Over_Due__c              =   accountWrppObj.over_due; 
                                If(!Utility.ISStringBlankorNull(accountWrppObj.paid_up_capital_on))
                                    accountMainObj.Paid_Up_Capital_On__c        =   Date.parse(accountWrppObj.paid_up_capital_on);
                                If(!Utility.ISStringBlankorNull(accountWrppObj.paid_up))
                                    accountMainObj.Paid_Up__c               =   Decimal.valueOf(accountWrppObj.paid_up); 
                                If(!Utility.ISStringBlankorNull(accountWrppObj.priority_sector)){
                                    accountMainObj.Priority_Sector__c           = checkBooleanReq(accountWrppObj.priority_sector);
                                }
                                If(!Utility.ISStringBlankorNull(accountWrppObj.whether_sme)){
                                    accountMainObj.Whether_SME__c = checkBooleanReq(accountWrppObj.whether_sme);
                                }
                                If(!Utility.ISStringBlankorNull(accountWrppObj.registered_office_street))
                                    accountMainObj.BillingStreet                =   accountWrppObj.registered_office_street;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.registered_office_city))
                                    accountMainObj.BillingCity              =   accountWrppObj.registered_office_city;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.registered_office_state))
                                    accountMainObj.BillingState             =   accountWrppObj.registered_office_state;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.registered_office_country))
                                    accountMainObj.BillingCountry               =   accountWrppObj.registered_office_country;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.registered_office_postalcode))
                                    accountMainObj.BillingPostalCode            =   accountWrppObj.registered_office_postalcode;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.corporate_office_street))
                                    accountMainObj.ShippingStreet               =   accountWrppObj.corporate_office_street; 
                                If(!Utility.ISStringBlankorNull(accountWrppObj.corporate_office_city))
                                    accountMainObj.ShippingCity                 =   accountWrppObj.corporate_office_city;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.corporate_office_state))
                                    accountMainObj.ShippingState                =   accountWrppObj.corporate_office_state;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.corporate_office_country))
                                    accountMainObj.ShippingCountry              =   accountWrppObj.corporate_office_country;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.corporate_office_postalcode))
                                    accountMainObj.ShippingPostalCode           =   accountWrppObj.corporate_office_postalcode;
                                If(!Utility.ISStringBlankorNull(accountWrppObj.Ship_bill_date))
                                    accountMainObj.Ship_bill_date__c            =   Date.parse(accountWrppObj.Ship_bill_date);
                                If(!Utility.ISStringBlankorNull(accountWrppObj.Remit_date))
                                    accountMainObj.Remit_date__c                =   Date.parse(accountWrppObj.Remit_date);
                                If(!Utility.ISStringBlankorNull(accountWrppObj.ORM_date))
                                    accountMainObj.ORM_date__c                  =   Date.parse(accountWrppObj.ORM_date);
                                
                                String recordTypeIDStr                          =   recordtypeIdMap.get('Business_Account');                
                                accountMainObj.RecordTypeId                     =   recordTypeIDStr;
                                listAccountObject.add(accountMainObj);
                            }catch(Exception ex){
                                System.debug('Inside Business');
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'ACCOUNT';
                                res.Error_List.add(accInsertRes);
                            }
                            //Fetching Customer_activeApplication_facility details
                            custIdAppMap                 =     AccountEOD_Helper.getAppDetails(listAccount);
                            inActiveFacilityCheckMap    =   AccountEOD_Helper.inActiveFacilityCheckMap;
                            System.debug('inActiveFacilityCheckMap:::'+inActiveFacilityCheckMap );
                            //list of Parties
                            List<AccountEODResponse.cls_PARTIES> listPartiesWrrp    =   accountWrppObj.PARTIES;
                            Map<String,string> partyCollAppUnique = new Map<String,String>();
                            
                            If(listPartiesWrrp !=null &&  ! listPartiesWrrp.isEmpty()){
                                for(AccountEODResponse.cls_PARTIES  partiesObect    :   listPartiesWrrp){
                                    Boolean party_flag  =   false;
                                    String ExternalID_Party =   '';
                                    
                                    Account accPerson = new Account();
                                    genesis__Application_Parties__c     partiesObj  =   new genesis__Application_Parties__c();
                                    If(partiesObect !=null){
                                        try{
                                            If(!Utility.ISStringBlankorNull(partiesObect.is_active)){
                                                
                                                partiesObj.Active__c = checkBooleanReq(partiesObect.is_active);
                                                system.debug('partiesObj.Active__c'+ partiesObj.Active__c);
                                            }
                                            If(!Utility.ISStringBlankorNull(partiesObect.Business_custid)){
                                                partiesObj.Key_Contact__r       =   new Account(CBS_Customer_ID__c = partiesObect.Business_custid);
                                                ExternalID_Party                =   partiesObect.Business_custid;    
                                            } 
                                            If(!Utility.ISStringBlankorNull(partiesObect.customer_id)){
                                                partyCbsIdMap.put(partiesObect.customer_id,checkBooleanReq(partiesObect.is_active));
                                                partiesObj.genesis__Party_Account_Name__r = new Account(CBS_Customer_ID__c = partiesObect.customer_id);
                                                accPerson.CBS_Customer_ID__c = partiesObect.customer_id;
                                                partiesObj.External_ID__c    = ExternalID_Party +'@'+ partiesObect.customer_id;
                                            }
                                            If(!Utility.ISStringBlankorNull(partiesObect.name))
                                                accPerson.LastName = partiesObect.name;
                                            If(!Utility.ISStringBlankorNull(partiesObect.applicant_related_to_bank_director)){
                                                accPerson.Is_Applicant_Related_To_Bank_Directors__c = checkBooleanReq(partiesObect.applicant_related_to_bank_director);
                                            }
                                            If(!Utility.ISStringBlankorNull(partiesObect.pan_number))
                                                accPerson.Pan_Number__c = partiesObect.pan_number;
                                            If(!Utility.ISStringBlankorNull(partiesObect.aadhar_card)) 
                                                accPerson.Aadhaar_Number__pc =  partiesObect.aadhar_card;
                                            If(!Utility.ISStringBlankorNull(partiesObect.passport))
                                                accPerson.Passport_Number__pc = partiesObect.passport;
                                            If(!Utility.ISStringBlankorNull(partiesObect.spouse_name))
                                                accPerson.Cust_Spouse_Name__c = partiesObect.spouse_name;
                                            If(!Utility.ISStringBlankorNull(partiesObect.voter_id))
                                                accPerson.Voter_Id__c        =  partiesObect.voter_id;
                                            If(!Utility.ISStringBlankorNull(partiesObect.marital_status))
                                                accPerson.Marital_Status__pc =  partiesObect.marital_status;
                                            If(!Utility.ISStringBlankorNull(partiesObect.designation))
                                                accPerson.Designation__pc    =  partiesObect.designation;
                                            If(!Utility.ISStringBlankorNull(partiesObect.education_qualification))
                                                accPerson.Education_Qualification__pc   =   partiesObect.education_qualification;
                                            If(!Utility.ISStringBlankorNull(partiesObect.electricity_no))
                                                accPerson.Electricity_Customer_No__c    =   partiesObect.electricity_no;
                                            If(!Utility.ISStringBlankorNull(partiesObect.nationality))
                                                accPerson.Nationality__pc   =   partiesObect.nationality;
                                            If(!Utility.ISStringBlankorNull(partiesObect.ration_card))
                                                accPerson.Ration_Card__c    =   partiesObect.ration_card;
                                            If(!Utility.ISStringBlankorNull(partiesObect.email))
                                                accPerson.PersonEmail       =   partiesObect.email;
                                            If(!Utility.ISStringBlankorNull(partiesObect.mobile))
                                                accPerson.PersonMobilePhone =   partiesObect.mobile;
                                            If(!Utility.ISStringBlankorNull(partiesObect.DOB))
                                                accPerson.PersonBirthdate   =   Date.parse(partiesObect.DOB);
                                            If(!Utility.ISStringBlankorNull(partiesObect.father_name))
                                                accPerson.Father_Name__pc   =   partiesObect.father_name; 
                                            If(!Utility.ISStringBlankorNull(partiesObect.husband_name))
                                                accPerson.Husband_Name__pc  =   partiesObect.husband_name;
                                            If(!Utility.ISStringBlankorNull(partiesObect.gender))
                                                accPerson.Gender__pc        =   partiesObect.gender;
                                            If(!Utility.ISStringBlankorNull(partiesObect.branch_code))
                                                accPerson.Branch_Code__c    =   partiesObect.branch_code;
                                            If(!Utility.ISStringBlankorNull(partiesObect.customer_type))
                                                accPerson.Customer_Type__c  =   partiesObect.customer_type;
                                            If(!Utility.ISStringBlankorNull(partiesObect.branch_name))
                                                accPerson.Branch_Name__c    =   partiesObect.branch_name;
                                            If(!Utility.ISStringBlankorNull(partiesObect.banking_with_us))
                                                accPerson.Banking_with_us__c =  Date.parse(partiesObect.banking_with_us); 
                                            If(!Utility.ISStringBlankorNull(partiesObect.customer_ic))
                                                accPerson.Customer_IC__c    =   partiesObect.customer_ic;
                                            If(!Utility.ISStringBlankorNull(partiesObect.Permanent_Street))
                                                accPerson.PersonMailingStreet       =   partiesObect.Permanent_Street;
                                            If(!Utility.ISStringBlankorNull(partiesObect.Permanent_city))
                                                accPerson.PersonMailingCity         =   partiesObect.Permanent_city;
                                            If(!Utility.ISStringBlankorNull(partiesObect.Permanent_pincode))
                                                accPerson.PersonMailingPostalCode   =   partiesObect.Permanent_pincode;
                                            If(!Utility.ISStringBlankorNull(partiesObect.Permanent_country))
                                                accPerson.PersonMailingCountry      =   partiesObect.Permanent_country;
                                            If(!Utility.ISStringBlankorNull(partiesObect.Permanent_State))
                                                accPerson.PersonMailingState      =   partiesObect.Permanent_State;
                                            //Active_Partner
                                            If(!Utility.ISStringBlankorNull(partiesObect.Active_Partener))
                                                partiesObj.Active__c                =   checkBooleanReq(partiesObect.Active_Partener);
                                            
                                            String recordTypeIDPer                  =   recordtypeIdMap.get('PersonAccount');               
                                            accPerson.RecordTypeId                  =   recordTypeIDPer;    
                                            
                                            If(!Utility.ISStringBlankorNull(partiesObect.party_type)){
                                                partiesObj.genesis__Party_Type__c   =   partiesObect.party_type;
                                                //Partner should be considered as guaranter
                                                If(partiesObect.party_type.equalsIgnoreCase('Partner')){
                                                    partiesObj.Guarantor__c  = true; 
                                                }
                                                If(partiesObect.party_type.equalsIgnoreCase('Guarantor')){
                                                    partiesObj.Signatories__c = true;
                                                    partiesObj.Guarantor__c  = true; 
                                                }else{
                                                    partiesObj.Signatories__c = true;
                                                }
                                            }
                                            partiesObj.Product_Type__c              =   'SME';
                                            personAccList.add(accPerson);
                                            partyList.add(partiesObj);
                                        }catch(Exception ex){
                                            System.debug('Inside Parties');
                                            Database.rollback(sp);
                                            res.status                  = Constants.WS_ERROR_STATUS;
                                            res.statusCode              = Constants.WS_ERROR_CODE;
                                            accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                            accInsertRes.error_reason   = ex.getMessage(); 
                                            accInsertRes.error_table    = 'PARTIES';
                                            res.Error_List.add(accInsertRes);
                                            break;
                                        }
                                        //List of Facilities
                                        List<AccountEODResponse.cls_FACILITY> listPartiesFacWrrp    =   partiesObect.PARTIES_FACILITY;
                                        String ExternalAppPro_WC    =   'LOS_WC0001';
                                        String ExternalAppProd_TL   =   'LOS_TL0002';
                                        String ExternalApp_ID       =   '';
                                        String Class_String_WC      =   'Working capital loan';
                                        String SubClass_Fun         =   'FUND';
                                        String SubClass_NonFun      =   'NON FUND';
                                        List<date> listDateFun      =   new List<date>();
                                        List<date> listDateNonFun   =   new List<date>();
                                        Map<String,genesis__Applications__c> partyAppUniqueMapDetail = new Map<String,genesis__Applications__c>();
                                        
                                        If(listPartiesFacWrrp !=null && ! listPartiesFacWrrp.isEmpty()){
                                            
                                            for(AccountEODResponse.cls_FACILITY  facPartyObj : listPartiesFacWrrp){
                                                genesis__Applications__c    appPartyObj =   new genesis__Applications__c();
                                                Facility__c facilityObj =   new Facility__c();
                                                Boolean facility_Party_flag = false;
                                                string appExternalKey       = '';
                                                string appDueDate           = '';
                                                
                                                If(facPartyObj !=null){
                                                    try{
                                                        facilityObj.MCLR_Rate__c = oneYrMCLR;
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.customer_id)){
                                                            ExternalApp_ID = facPartyObj.customer_id;
                                                            appPartyObj.genesis__Account__r = new Account(CBS_Customer_ID__c = facPartyObj.customer_id); 
                                                            appExternalKey  = facPartyObj.customer_id;                                                      
                                                        }
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.branch_code))
                                                            appPartyObj.Branch_Code__c  =   facPartyObj.branch_code;
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.branch_name))
                                                            appPartyObj.Branch_Name__c  =   facPartyObj.branch_name;
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.product_class) && Class_String_WC.equalsIgnoreCase(facPartyObj.product_class) && !Utility.ISStringBlankorNull(facPartyObj.due_date) && !Utility.ISStringBlankorNull(facPartyObj.sub_class)) {
                                                            appDueDate  = String.valueof(Date.parse(facPartyObj.due_date));
                                                            If(SubClass_Fun.equalsIgnoreCase(facPartyObj.sub_class))
                                                                listDateFun.add(Date.parse(facPartyObj.due_date));
                                                            
                                                            If(SubClass_NonFun.equalsIgnoreCase(facPartyObj.sub_class))
                                                                listDateNonFun.add(Date.parse(facPartyObj.due_date));
                                                        }
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.product_class)) {
                                                            facilityObj.Class__c    =   facPartyObj.product_class;
                                                            
                                                            If(Class_String_WC.equalsIgnoreCase(facPartyObj.product_class)){
                                                                
                                                                appPartyObj.genesis__CL_Product__r  =   new clcommon__CL_Product__c(Los_Customer_Id__c = ExternalAppPro_WC);
                                                                String recordTypeIDApp              =   recordtypeIdMap.get('SME_Renewal');             
                                                                appPartyObj.RecordTypeId            =   recordTypeIDApp;
                                                                appExternalKey                      =   ExternalApp_ID+'@'+appDueDate;
                                                            }else{
                                                                
                                                                appPartyObj.genesis__CL_Product__r  =   new clcommon__CL_Product__c(Los_Customer_Id__c = ExternalAppProd_TL);
                                                                String recordTypeIDApp              =   recordtypeIdMap.get('Term_Loan');               
                                                                appPartyObj.RecordTypeId            =   recordTypeIDApp;
                                                                appExternalKey                      =   ExternalApp_ID+'@Term Loan';
                                                            }
                                                        }
                                                        
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.fec_number))
                                                            appPartyObj.FEC_Reference_Number__c =   facPartyObj.fec_number; 
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.fin_year)) 
                                                            appPartyObj.Latest_Audited_Financial_Statement_Year__c  =   Date.parse(facPartyObj.fin_year);
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.sanction_auth))
                                                            appPartyObj.Sanction_Authority__c   =   facPartyObj.sanction_auth;
                                                        
                                                        //Facility Record.                                                       
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.existing_limit))
                                                            facilityObj.Existing_Limit__c       =   Decimal.valueOf(facPartyObj.existing_limit);
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.balos))
                                                            facilityObj.Balance_Outstandings__c =   Decimal.valueOf(facPartyObj.balos); 
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.int_rate))
                                                            facilityObj.Existing_Rate__c        =   Decimal.valueOf(facPartyObj.int_rate); 
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.arrears))
                                                            facilityObj.Arrears__c              =   Double.valueOf(facPartyObj.arrears);
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.amount_disbursed))
                                                            facilityObj.Amount_Disbursed__c     =   Double.valueOf(facPartyObj.amount_disbursed);
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.amount_net_disbursed))
                                                            facilityObj.Amount_Net_Disbursed__c =   Double.valueOf(facPartyObj.amount_net_disbursed);
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.amount_yet_disbursed))
                                                            facilityObj.Amount_Yet_disbursed__c =   Double.valueOf(facPartyObj.amount_yet_disbursed);
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.purpose_of_loan))
                                                            facilityObj.Loan_Purpose__c         =   facPartyObj.purpose_of_loan;
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.los_prod_code))
                                                            facilityObj.CL_Product__r           =   new clcommon__CL_Product__c(Los_Customer_Id__c = facPartyObj.los_prod_code);
                                                        If(!Utility.ISStringBlankorNull(facPartyObj.active)){
                                                            if(checkBooleanReq(facPartyObj.active)){
                                                                facilityObj.Active__c           = true;
                                                                is_Facility_Inactive            = true;
                                                            }
                                                        }
                                                    }catch(Exception ex){
                                                        System.debug('Inside Facility');
                                                        Database.rollback(sp);
                                                        res.status                  = Constants.WS_ERROR_STATUS;
                                                        res.statusCode              = Constants.WS_ERROR_CODE;
                                                        accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                                        accInsertRes.error_reason   = ex.getMessage(); 
                                                        accInsertRes.error_table    = 'Business Facilities / Parties Facilities';
                                                        res.Error_List.add(accInsertRes);
                                                        party_flag = true;
                                                        break;
                                                    }
                                                    //List of Collateral 
                                                    List<AccountEODResponse.cls_COLLATERALS> mapCOllateralWrrap = facPartyObj.PARTIES_COLLATERALS;
                                                    If(mapCOllateralWrrap !=null && ! mapCOllateralWrrap.isEmpty()){
                                                        for(AccountEODResponse.cls_COLLATERALS  collateralWrrpObj   :   mapCOllateralWrrap){
                                                            String ExternalID_AppCo = '';
                                                            Boolean collateral_Party_flag = false;
                                                            clcommon__Collateral__c collateralObj   =   new clcommon__Collateral__c();
                                                            genesis__Application_Collateral__c appCollateralObj =   new genesis__Application_Collateral__c();
                                                            If(collateralWrrpObj !=null){
                                                                try{
                                                                    colIdList.add(collateralWrrpObj.collateral_id);
                                                                    
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.collateral_id)){
                                                                        collateralObj.External_ID__c    =   collateralWrrpObj.collateral_id;
                                                                        collateralObj.clcommon__Collateral_Name__c = collateralWrrpObj.collateral_id;
                                                                        ExternalID_AppCo = collateralWrrpObj.collateral_id;
                                                                        appCollateralObj.genesis__Collateral__r =   new clcommon__Collateral__c(External_ID__c = collateralWrrpObj.collateral_id);
                                                                    }
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.branch_code))
                                                                        collateralObj.User_Branch_Number__c =   collateralWrrpObj.branch_code;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.cersai_asset_id))
                                                                        collateralObj.Asset_ID__c           =   collateralWrrpObj.cersai_asset_id;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.cersai_security_id))
                                                                        collateralObj.Cersai_Security_Id__c =   collateralWrrpObj.cersai_security_id;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.cersai_reg_date))
                                                                        collateralObj.Cersai_Registration_Date__c   =   Date.parse(collateralWrrpObj.cersai_reg_date);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.srn_no))
                                                                        collateralObj.SRN_Number__c         =   collateralWrrpObj.srn_no;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.srn_date))
                                                                        collateralObj.SRN_Date__c           =   Date.parse(collateralWrrpObj.srn_date);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.nature_of_property)){
                                                                        Map<String,String> mapOfString      =  Utility.getNatureOfPropertyByCode();
                                                                        If(mapOfString !=null && mapOfString.containsKey(collateralWrrpObj.nature_of_property)){
                                                                            collateralObj.Nature_of_Property__c =   mapOfString.get(collateralWrrpObj.nature_of_property);
                                                                        }
                                                                    }
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.tot_survey_numbers))
                                                                        collateralObj.Total_Survery_Number__c   =   collateralWrrpObj.tot_survey_numbers;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.plot_no))
                                                                        collateralObj.PlotDoorShopBungalow_No__c    =   collateralWrrpObj.plot_no;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.door_no))
                                                                        collateralObj.Door__c   =   collateralWrrpObj.door_no;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.area_sqft))
                                                                        collateralObj.Area_Square_Feet__c   =   Decimal.valueOf(collateralWrrpObj.area_sqft);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.floor_no))
                                                                        collateralObj.Floor_No__c           =   collateralWrrpObj.floor_no;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.block_ward_no))
                                                                        collateralObj.Stage_Sector_Ward_Block_No__c =   collateralWrrpObj.block_ward_no;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.building_name))
                                                                        collateralObj.Building_Name__c  =   collateralWrrpObj.building_name;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.street))
                                                                        collateralObj.Street_NameNo__c  =   collateralWrrpObj.street;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.landmark))
                                                                        collateralObj.Landmark__c       =   collateralWrrpObj.landmark;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.state_name))
                                                                        collateralObj.State__c          =   collateralWrrpObj.state_name;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.district))
                                                                        collateralObj.District_Name__c  =   collateralWrrpObj.district;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.taluk))
                                                                        collateralObj.TalukaTehsil__c   =   collateralWrrpObj.taluk;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.sro_name))
                                                                        collateralObj.SRO__c            =   collateralWrrpObj.sro_name;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.city))
                                                                        collateralObj.clcommon__City__c =   collateralWrrpObj.city;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.pincode))
                                                                        collateralObj.clcommon__Postal_Code__c  =   collateralWrrpObj.pincode;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.land_value))
                                                                        collateralObj.Land_Value__c     =   Decimal.valueOf(collateralWrrpObj.land_value);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.building_value))
                                                                        collateralObj.Building_Value__c =   Decimal.valueOf(collateralWrrpObj.building_value);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.tot_asset_value))
                                                                        collateralObj.clcommon__Value__c  =   Decimal.valueOf(collateralWrrpObj.tot_asset_value);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.carpet_area))
                                                                        collateralObj.Carpet_Area__c    =   Decimal.valueOf(collateralWrrpObj.carpet_area);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.builtup))
                                                                        collateralObj.Buildup_Area__c   =   Decimal.valueOf(collateralWrrpObj.builtup);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.valuation_date))
                                                                        collateralObj.Valuation_Date__c =   Date.parse(collateralWrrpObj.valuation_date);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.valuer_name))
                                                                        collateralObj.Valuer_Name__c    =   collateralWrrpObj.valuer_name;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.valuer_identity))
                                                                        collateralObj.Valuer_Identity__c =  collateralWrrpObj.valuer_identity;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.legal_opinion_date))
                                                                        collateralObj.Legal_Opinion_Date__c =   Date.parse(collateralWrrpObj.legal_opinion_date);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.advocate_name))
                                                                        collateralObj.Advocate_Name__c      =   collateralWrrpObj.advocate_name;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.advocate_identity))
                                                                        collateralObj.Advocate_Identity__c  =   collateralWrrpObj.advocate_identity;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.em_date))
                                                                        collateralObj.EM_Date__c    =   Date.parse(collateralWrrpObj.em_date);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.latitude))
                                                                        collateralObj.Latitude__c   =   Decimal.valueOf(collateralWrrpObj.latitude);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.longitude))
                                                                        collateralObj.Longitude__c  =   Decimal.valueOf(collateralWrrpObj.longitude);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.ownership_type))
                                                                        collateralObj.Ownership_Type__c =   collateralWrrpObj.ownership_type;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.no_of_owners))
                                                                        collateralObj.Number_of_joint_owners__c =   Integer.valueOf(collateralWrrpObj.no_of_owners);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.mortgage_type))
                                                                        collateralObj.MORT_TYPE__c  =   collateralWrrpObj.mortgage_type;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.document_type))
                                                                        collateralObj.DOC_TYPE__c   =   collateralWrrpObj.document_type;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.document_no))
                                                                        collateralObj.Document_Number__c    =   collateralWrrpObj.document_no;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.document_date))
                                                                        collateralObj.Document_Date__c  =   Date.parse(collateralWrrpObj.document_date);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.ec_date))
                                                                        collateralObj.EC_Date__c    =   Date.parse(collateralWrrpObj.ec_date);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.collateral_category))
                                                                        collateralObj.Collateral_Category__c    =   collateralWrrpObj.collateral_category;
                                                                    
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.branch_name))
                                                                        collateralObj.Branch_Name__c =   collateralWrrpObj.branch_name;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.surrender_value))
                                                                        collateralObj.Surrender_Value__c =   Decimal.valueOf(collateralWrrpObj.surrender_value);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.policy_number))
                                                                        collateralObj.clcommon__Policy_Number__c =   collateralWrrpObj.policy_number;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.maturity_date))
                                                                        collateralObj.Maturity_Date__c =   Date.valueOf(collateralWrrpObj.maturity_date);
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.vehicle_number))
                                                                        collateralObj.Vehicle_Number__c =   collateralWrrpObj.vehicle_number;
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.machinery_model))
                                                                        collateralObj.Machinery_Model__c =   collateralWrrpObj.machinery_model;
                                                                    
                                                                    
                                                                    //Application Collateral
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.account_number)){
                                                                        ExternalID_AppCo                =   ExternalID_AppCo +'@'+ collateralWrrpObj.account_number;
                                                                        appCollateralObj.External_ID__c =   ExternalID_AppCo; 
                                                                        mapApplication.put(ExternalID_AppCo,appPartyObj);
                                                                        partyCollAppUnique.put(ExternalID_AppCo,collateralWrrpObj.account_number);
                                                                        collateralVsAppCollateral.put(ExternalID_AppCo,collateralObj.External_ID__c);
                                                                    }
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.is_active)){
                                                                        if(checkBooleanReq(collateralWrrpObj.is_active))
                                                                            collateralObj.Active__c = true;
                                                                        else{
                                                                            collateralObj.Active__c = false;
                                                                            colleteralIdToDelete.add(collateralWrrpObj.collateral_id);
                                                                        }
                                                                    }
                                                                    If(!Utility.ISStringBlankorNull(collateralWrrpObj.collateral_type))
                                                                        appCollateralObj.Security_Type__c = collateralWrrpObj.collateral_type;
                                                                    
                                                                    String recordTypeIDColl                 =   recordtypeIdMap.get('Land_And_Building');               
                                                                    collateralObj.RecordTypeId              =   recordTypeIDColl;
                                                                    
                                                                }catch(Exception ex){
                                                                    System.debug('Inside COllateral');
                                                                    Database.rollback(sp);
                                                                    res.status                  = Constants.WS_ERROR_STATUS;
                                                                    res.statusCode              = Constants.WS_ERROR_CODE;
                                                                    accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                                                    accInsertRes.error_reason   = ex.getMessage(); 
                                                                    accInsertRes.error_table    = 'COLLATERALS / PARTIES_COLLATERALS';
                                                                    res.Error_List.add(accInsertRes);
                                                                    facility_Party_flag = true;
                                                                    break;
                                                                }
                                                                List<AccountEODResponse.cls_OWNERSHIP>  listOwnerWrpp=  collateralWrrpObj.PARTIES_OWNERSHIP;
                                                                If(listOwnerWrpp !=null && !listOwnerWrpp.isEmpty()){
                                                                    for(AccountEODResponse.cls_OWNERSHIP    ownershipWrppObj    : listOwnerWrpp) {
                                                                        String ExternalID_Owner         =   '';
                                                                        Ownership__c    ownershipObj    =   new  Ownership__c();
                                                                        If(ownershipWrppObj !=null){
                                                                            try{
                                                                                If(!Utility.ISStringBlankorNull(ownershipWrppObj.Collateral_id)) {
                                                                                    ownershipObj.Collateral__r  = new clcommon__Collateral__c(External_ID__c =ownershipWrppObj.Collateral_id);
                                                                                    ExternalID_Owner    =   ownershipWrppObj.Collateral_id;
                                                                                    ownershipObj.CBS_Collateral_Id__c = ownershipWrppObj.Collateral_id;
                                                                                }
                                                                                
                                                                                If(!Utility.ISStringBlankorNull(ownershipWrppObj.branch_code))
                                                                                    ownershipObj.Branch_Code__c =   ownershipWrppObj.branch_code;
                                                                                If(!Utility.ISStringBlankorNull(ownershipWrppObj.owner_name))
                                                                                    ownershipObj.Owner_Customer_Name__c =   ownershipWrppObj.owner_name;
                                                                                If(!Utility.ISStringBlankorNull(ownershipWrppObj.loan_custid))
                                                                                    ownershipObj.Customer_id__c    =   ownershipWrppObj.loan_custid;
                                                                                If(!Utility.ISStringBlankorNull(ownershipWrppObj.owner_aadhar))
                                                                                    ownershipObj.Owner_Aadharcard_Number__c =   ownershipWrppObj.owner_aadhar;
                                                                                If(!Utility.ISStringBlankorNull(ownershipWrppObj.owner_pan))
                                                                                    ownershipObj.Owner_Pancard_Number__c    =   ownershipWrppObj.owner_pan;
                                                                                If(!Utility.ISStringBlankorNull(ownershipWrppObj.loan_custid)){
                                                                                    ownershipObj.Owner_Customer_Id__c  = ownershipWrppObj.owner_cust_id;
                                                                                    ownershipObj.Account__r =   new Account(CBS_Customer_ID__c=ownershipWrppObj.owner_cust_id);
                                                                                    ExternalID_Owner = ExternalID_Owner+'@'+ownershipWrppObj.owner_cust_id;
                                                                                    ownershipObj.External_ID__c =   ExternalID_Owner;
                                                                                    mapOwnership.put(ExternalID_Owner,ownershipObj);
                                                                                }
                                                                            }catch(Exception ex){
                                                                                System.debug('Inside Ownership');
                                                                                Database.rollback(sp);
                                                                                res.status                  = Constants.WS_ERROR_STATUS;
                                                                                res.statusCode              = Constants.WS_ERROR_CODE;
                                                                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                                                                accInsertRes.error_reason   = ex.getMessage(); 
                                                                                accInsertRes.error_table    = 'OWNERSHIP / PARTIES_OWNERSHIP';
                                                                                res.Error_List.add(accInsertRes);
                                                                                collateral_Party_flag = true;
                                                                                break;
                                                                            }   
                                                                        }
                                                                    }
                                                                }
                                                                
                                                                List<AccountEODResponse.cls_Survey> mapSurveyWrpp=  collateralWrrpObj.PARTIES_Survey;
                                                                If(mapSurveyWrpp !=null && ! mapSurveyWrpp.isEmpty()){
                                                                    for(AccountEODResponse.cls_Survey   surveyWrrpObj   : mapSurveyWrpp){
                                                                        String ExternalID_Survey =  ''; 
                                                                        Survey__c   surveyObj   =   new Survey__c();
                                                                        If(surveyWrrpObj !=null){
                                                                            try{
                                                                                If(!Utility.ISStringBlankorNull(surveyWrrpObj.Collateral_id)){
                                                                                    surveyObj.Collateral__r     =   new clcommon__Collateral__c(External_ID__c = surveyWrrpObj.Collateral_id);
                                                                                    ExternalID_Survey   =   surveyWrrpObj.Collateral_id;
                                                                                }
                                                                                If(!Utility.ISStringBlankorNull(surveyWrrpObj.Branch_code))
                                                                                    surveyObj.Branch_Number__c  =   surveyWrrpObj.Branch_code;
                                                                                If(!Utility.ISStringBlankorNull(surveyWrrpObj.Survey_No)){
                                                                                    surveyObj.Suvery_Number__c  =   surveyWrrpObj.Survey_No;
                                                                                    ExternalID_Survey = ExternalID_Survey + '@'+surveyWrrpObj.Survey_No;
                                                                                }
                                                                                If(!Utility.ISStringBlankorNull(surveyWrrpObj.sub_div_No)){
                                                                                    surveyObj.Sub_Division_Number__c    =   surveyWrrpObj.sub_div_No;
                                                                                    ExternalID_Survey = ExternalID_Survey + '@'+surveyWrrpObj.sub_div_No;
                                                                                }
                                                                                If(!Utility.ISStringBlankorNull(ExternalID_Survey)){
                                                                                    surveyObj.External_ID__c    =   ExternalID_Survey;
                                                                                    mapSurvey.put(ExternalID_Survey,surveyObj);
                                                                                }
                                                                                
                                                                            }catch(Exception ex){
                                                                                System.debug('Inside Survey');
                                                                                Database.rollback(sp);
                                                                                res.status                  = Constants.WS_ERROR_STATUS;
                                                                                res.statusCode              = Constants.WS_ERROR_CODE;
                                                                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                                                                accInsertRes.error_reason   = ex.getMessage(); 
                                                                                accInsertRes.error_table    = 'Survey / PARTIES_Survey';
                                                                                res.Error_List.add(accInsertRes);
                                                                                collateral_Party_flag = true;
                                                                                break;
                                                                            }
                                                                        }   
                                                                    }
                                                                }
                                                            }
                                                            If(collateral_Party_flag){
                                                                facility_Party_flag = true; 
                                                                break; 
                                                            }
                                                            mapCOllateral.put(collateralWrrpObj.collateral_id,collateralObj);
                                                            listAppCollateral.add(appCollateralObj);
                                                        } 
                                                    }
                                                    If(facility_Party_flag){
                                                        party_flag = true;  
                                                        break;  
                                                    }
                                                    String recordTypeIDFac                  =   recordtypeIdMap.get('Parent');              
                                                    facilityObj.RecordTypeId                =   recordTypeIDFac;
                                                    listFacility.add(facilityObj);
                                                }
                                                
                                                if(!partyAppUniqueMapDetail.containsKey(appExternalKey)){
                                                    partyAppUniqueMapDetail.put(appExternalKey,appPartyObj);
                                                    If(!listDateFun.isEmpty()){
                                                        listDateFun.sort();
                                                        appPartyObj.Renewal_Due_Date__c = listDateFun.get(0);
                                                        ExternalApp_ID                  = ExternalApp_ID +'@'+listDateFun.get(0);
                                                        listDateFun.clear();
                                                    }else if(!listDateNonFun.isEmpty()){
                                                        listDateNonFun.sort();
                                                        appPartyObj.Renewal_Due_Date__c = listDateNonFun.get(0);
                                                        ExternalApp_ID                  = ExternalApp_ID +'@'+listDateNonFun.get(0);
                                                        listDateNonFun.clear();
                                                    }else{
                                                        ExternalApp_ID  = ExternalApp_ID +'@Term Loan';
                                                    }
                                                    If(!Utility.ISStringBlankorNull(ExternalApp_ID))
                                                        appPartyObj.External_Id__c = ExternalApp_ID;
                                                    
                                                    listApp.add(appPartyObj);
                                                }
                                                
                                                If(!Utility.ISStringBlankorNull(facPartyObj.account_number)) {
                                                    facilityObj.Account_Number__c       =   facPartyObj.account_number;
                                                    
                                                    Map<String,Boolean> facilityMap = new Map<String,Boolean>();
                                                    if(inActiveFacilityCheckMap.get(facPartyObj.customer_id) != null){
                                                        facilityMap = inActiveFacilityCheckMap.get(facPartyObj.customer_id);
                                                        facilityMap.put(facPartyObj.account_number,checkBooleanReq(facPartyObj.active));
                                                    }
                                                    else{
                                                        facilityMap.put(facPartyObj.account_number,checkBooleanReq(facPartyObj.active));
                                                    }
                                                    inActiveFacilityCheckMap.put(facPartyObj.customer_id,facilityMap);
                                                    
                                                    if(partyAppUniqueMapDetail.containsKey(appExternalKey) && partyAppUniqueMapDetail.get(appExternalKey) != null)
                                                        mapApplication.put(facPartyObj.account_number,partyAppUniqueMapDetail.get(appExternalKey));
                                                }
                                            }
                                            
                                        }
                                        //List of Collateral Insurance 
                                        List<AccountEODResponse.cls_INSURANCE> listInsuranceWrrp    =   partiesObect.PARTIES_INSURANCE;
                                        
                                        If(listInsuranceWrrp !=null && ! listInsuranceWrrp.isEmpty()){
                                            for(AccountEODResponse.cls_INSURANCE    insuranceWrrpObj    : listInsuranceWrrp)  {
                                                String ExternalID_Ins   = '';
                                                clcommon__Collateral_Insurance__c   collateralInsuranceObj  =   new clcommon__Collateral_Insurance__c();
                                                If(insuranceWrrpObj !=null){
                                                    try{
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.customer_id)) {
                                                            collateralInsuranceObj.Account__r   =   new Account(CBS_Customer_ID__c = insuranceWrrpObj.customer_id); 
                                                        }
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Entry_Branch_Code))
                                                            collateralInsuranceObj.Entry_Branch_Code__c = Integer.valueOf(insuranceWrrpObj.Entry_Branch_Code);
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Assured_Amount)){
                                                            collateralInsuranceObj.Assured_Amount__c    = Decimal.valueOf(insuranceWrrpObj.Assured_Amount);
                                                        }
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.CBS_Reference_Value)){
                                                            collateralInsuranceObj.CBS_Reference_Value__c   =   insuranceWrrpObj.CBS_Reference_Value;
                                                            ExternalID_Ins                                  = insuranceWrrpObj.CBS_Reference_Value;
                                                        }
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Insurance_Details))
                                                            collateralInsuranceObj.Insurance_Details__c     =   insuranceWrrpObj.Insurance_Details;
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Sl_No)){
                                                            collateralInsuranceObj.Sl_No__c                 =   Integer.valueOf(insuranceWrrpObj.Sl_No);
                                                            ExternalID_Ins                                  =   ExternalID_Ins+ '@'+ insuranceWrrpObj.Sl_No;
                                                        }
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Security_Type))
                                                            collateralInsuranceObj.Security_Type__c         =   insuranceWrrpObj.Security_Type;
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Security_Value))
                                                            collateralInsuranceObj.Security_Value__c        =   Decimal.valueOf(insuranceWrrpObj.Security_Value);
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Date_Insure))
                                                            collateralInsuranceObj.Date_Insure__c           =   Date.parse(insuranceWrrpObj.Date_Insure);
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Date_Policy_Expiry)) {
                                                            collateralInsuranceObj.Date_Policy_Expiry__c    =   Date.parse(insuranceWrrpObj.Date_Policy_Expiry);
                                                        }
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Insurer_Name))
                                                            collateralInsuranceObj.Insurer_Name__c  =   insuranceWrrpObj.Insurer_Name;
                                                        If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Insurer_Number)){
                                                            collateralInsuranceObj.Insurer_Number__c =  insuranceWrrpObj.Insurer_Number;
                                                            ExternalID_Ins          =   ExternalID_Ins+'@'+ insuranceWrrpObj.Insurer_Number;
                                                        }
                                                        If(!Utility.ISStringBlankorNull(ExternalID_Ins))
                                                            collateralInsuranceObj.External_ID__c   =   ExternalID_Ins;
                                                        listInsurance.add(collateralInsuranceObj);
                                                    }catch(Exception ex){
                                                        System.debug('Inside Insurance');
                                                        Database.rollback(sp);
                                                        res.status                  = Constants.WS_ERROR_STATUS;
                                                        res.statusCode              = Constants.WS_ERROR_CODE;
                                                        accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                                        accInsertRes.error_reason   = ex.getMessage(); 
                                                        accInsertRes.error_table    = 'INSURANCE / PARTIES_INSURANCE';
                                                        res.Error_List.add(accInsertRes);
                                                        party_flag = true;
                                                        break;
                                                    }   
                                                }    
                                            }  
                                        }
                                    }
                                    If(party_flag){
                                        break;
                                    }
                                }
                            }
                            
                            //List of Facilities
                            List<AccountEODResponse.cls_FACILITY> listPartiesFacWrrp    =   accountWrppObj.FACILITY;
                            String ExternalAppPro_WC    =   'LOS_WC0001';
                            String ExternalAppProd_TL   =   'LOS_TL0002';
                            String ExternalApp_ID       =   '';
                            String Class_String_WC      =   'Working capital loan';
                            String SubClass_Fun         =   'FUND';
                            String SubClass_NonFun      =   'NON FUND';
                            List<date> listDateFun      =   new List<date>();
                            List<date> listDateNonFun   =   new List<date>();
                            Date renewalAppDueDate;
                            Boolean renewalApplicationCreated = false;
                            Boolean TL_ApplicationCreated = false;
                            Map<String,genesis__Applications__c> appUniqueMapDetail = new Map<String,genesis__Applications__c>();
                            Map<String,string> collAppUnique = new Map<String,String>();
                            If(listPartiesFacWrrp !=null && !listPartiesFacWrrp.isEmpty()){
                                for(AccountEODResponse.cls_FACILITY  facPartyObj : listPartiesFacWrrp){
                                    If(!Utility.ISStringBlankorNull(facPartyObj.product_class) && Class_String_WC.equalsIgnoreCase(facPartyObj.product_class) && !Utility.ISStringBlankorNull(facPartyObj.due_date) && !Utility.ISStringBlankorNull(facPartyObj.sub_class)) {
                                        If(SubClass_Fun.equalsIgnoreCase(facPartyObj.sub_class))
                                            listDateFun.add(Date.parse(facPartyObj.due_date));
                                        If(SubClass_NonFun.equalsIgnoreCase(facPartyObj.sub_class))
                                            listDateNonFun.add(Date.parse(facPartyObj.due_date));  
                                    }
                                }
                                if(listDateFun.size() > 0){
                                    listDateFun.sort();
                                    renewalAppDueDate = listDateFun.get(listDateFun.size()-1);
                                }
                                else if(listDateNonFun.size() > 0){
                                    listDateNonFun.sort();
                                    renewalAppDueDate = listDateNonFun.get(listDateNonFun.size()-1);
                                }
                                System.debug(renewalAppDueDate );
                                for(AccountEODResponse.cls_FACILITY  facPartyObj : listPartiesFacWrrp){
                                    genesis__Applications__c    appPartyObj =   new genesis__Applications__c();
                                    Facility__c facilityObj =   new Facility__c();
                                    Boolean facility_flag   =   false;
                                    
                                    string appExternalKey       = '';
                                    
                                    If(facPartyObj !=null){
                                        try{
                                            facilityObj.MCLR_Rate__c = oneYrMCLR;
                                            If(!Utility.ISStringBlankorNull(facPartyObj.customer_id)){
                                                ExternalApp_ID = facPartyObj.customer_id;
                                                appPartyObj.genesis__Account__r = new Account(CBS_Customer_ID__c = facPartyObj.customer_id);
                                                appExternalKey  = facPartyObj.customer_id;                                      
                                            }
                                            If(!Utility.ISStringBlankorNull(facPartyObj.branch_code))
                                                appPartyObj.Branch_Code__c  =   facPartyObj.branch_code;
                                            If(!Utility.ISStringBlankorNull(facPartyObj.branch_name))
                                                appPartyObj.Branch_Name__c  =   facPartyObj.branch_name;
                                            If(!Utility.ISStringBlankorNull(facPartyObj.product_class)) {
                                                facilityObj.Class__c    =   facPartyObj.product_class;
                                                If(Class_String_WC.equalsIgnoreCase(facPartyObj.product_class)){
                                                    appPartyObj.genesis__CL_Product__r  =   new clcommon__CL_Product__c(Los_Customer_Id__c = ExternalAppPro_WC);
                                                    String recordTypeIDApp              =   recordtypeIdMap.get('SME_Renewal');             
                                                    appPartyObj.RecordTypeId            =   recordTypeIDApp;
                                                }else{
                                                    appPartyObj.genesis__CL_Product__r  =   new clcommon__CL_Product__c(Los_Customer_Id__c = ExternalAppProd_TL);                                                    
                                                    String recordTypeIDApp              =   recordtypeIdMap.get('Term_Loan');               
                                                    appPartyObj.RecordTypeId            =   recordTypeIDApp;
                                                }
                                            }
                                            
                                            If(!Utility.ISStringBlankorNull(facPartyObj.fec_number))
                                                appPartyObj.FEC_Reference_Number__c =   facPartyObj.fec_number; 
                                            If(!Utility.ISStringBlankorNull(facPartyObj.fin_year)) 
                                                appPartyObj.Latest_Audited_Financial_Statement_Year__c  =   Date.parse(facPartyObj.fin_year);
                                            If(!Utility.ISStringBlankorNull(facPartyObj.existing_limit))
                                                facilityObj.Existing_Limit__c       =   Decimal.valueOf(facPartyObj.existing_limit);
                                            If(!Utility.ISStringBlankorNull(facPartyObj.balos))
                                                facilityObj.Balance_Outstandings__c =   Decimal.valueOf(facPartyObj.balos); 
                                            If(!Utility.ISStringBlankorNull(facPartyObj.int_rate))
                                                facilityObj.Existing_Rate__c        =   Decimal.valueOf(facPartyObj.int_rate); 
                                            If(!Utility.ISStringBlankorNull(facPartyObj.arrears))
                                                facilityObj.Arrears__c              =   Double.valueOf(facPartyObj.arrears);
                                            If(!Utility.ISStringBlankorNull(facPartyObj.amount_disbursed))
                                                facilityObj.Amount_Disbursed__c     =   Double.valueOf(facPartyObj.amount_disbursed);
                                            If(!Utility.ISStringBlankorNull(facPartyObj.amount_net_disbursed))
                                                facilityObj.Amount_Net_Disbursed__c =   Double.valueOf(facPartyObj.amount_net_disbursed);
                                            If(!Utility.ISStringBlankorNull(facPartyObj.amount_yet_disbursed))
                                                facilityObj.Amount_Yet_disbursed__c =   Double.valueOf(facPartyObj.amount_yet_disbursed);
                                            If(!Utility.ISStringBlankorNull(facPartyObj.purpose_of_loan))
                                                facilityObj.Loan_Purpose__c         =   facPartyObj.purpose_of_loan;
                                            If(!Utility.ISStringBlankorNull(facPartyObj.los_prod_code))
                                                facilityObj.CL_Product__r           =   new clcommon__CL_Product__c(Los_Customer_Id__c = facPartyObj.los_prod_code);
                                            If(!Utility.ISStringBlankorNull(facPartyObj.active))
                                                facilityObj.Active__c               =   checkBooleanReq(facPartyObj.active);
                                        }catch(Exception ex){
                                            System.debug('Inside Facility');
                                            Database.rollback(sp);
                                            res.status                  = Constants.WS_ERROR_STATUS;
                                            res.statusCode              = Constants.WS_ERROR_CODE;
                                            accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                            accInsertRes.error_reason   = ex.getMessage(); 
                                            accInsertRes.error_table    = 'FACILITY / PARTIES_FACILITY';
                                            res.Error_List.add(accInsertRes);
                                            break;
                                        }   
                                        //List of Collateral 
                                        List<AccountEODResponse.cls_COLLATERALS> mapCOllateralWrrap = facPartyObj.COLLATERALS;
                                        If(mapCOllateralWrrap !=null && ! mapCOllateralWrrap.isEmpty()){
                                            for(AccountEODResponse.cls_COLLATERALS  collateralWrrpObj   :   mapCOllateralWrrap){
                                                String ExternalID_AppCo = '';
                                                Boolean collateral_flag = false;
                                                clcommon__Collateral__c collateralObj   =   new clcommon__Collateral__c();
                                                genesis__Application_Collateral__c appCollateralObj =   new genesis__Application_Collateral__c();
                                                If(collateralWrrpObj !=null){
                                                    try{
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.collateral_id)){
                                                            if(Class_String_WC.equalsIgnoreCase(facPartyObj.product_class)){
                                                                colIdBoolMap.put(collateralWrrpObj.collateral_id,checkBooleanReq(collateralWrrpObj.is_active));
                                                            }
                                                            system.debug('colmapid::::'+colIdBoolMap);
                                                            collateralObj.External_ID__c    =   collateralWrrpObj.collateral_id;
                                                            collateralObj.clcommon__Collateral_Name__c = collateralWrrpObj.collateral_id;
                                                            ExternalID_AppCo = collateralWrrpObj.collateral_id;
                                                            appCollateralObj.genesis__Collateral__r =   new clcommon__Collateral__c(External_ID__c = collateralWrrpObj.collateral_id);
                                                        }
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.branch_code))
                                                            collateralObj.User_Branch_Number__c =   collateralWrrpObj.branch_code;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.cersai_asset_id))
                                                            collateralObj.Asset_ID__c           =   collateralWrrpObj.cersai_asset_id;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.cersai_security_id))
                                                            collateralObj.Cersai_Security_Id__c =   collateralWrrpObj.cersai_security_id;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.cersai_reg_date))
                                                            collateralObj.Cersai_Registration_Date__c   =   Date.parse(collateralWrrpObj.cersai_reg_date);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.srn_no))
                                                            collateralObj.SRN_Number__c         =   collateralWrrpObj.srn_no;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.srn_date))
                                                            collateralObj.SRN_Date__c           =   Date.parse(collateralWrrpObj.srn_date);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.nature_of_property)){
                                                            Map<String,String> mapOfString      =  Utility.getNatureOfPropertyByCode();
                                                            If(mapOfString !=null && mapOfString.containsKey(collateralWrrpObj.nature_of_property)){
                                                                collateralObj.Nature_of_Property__c =   mapOfString.get(collateralWrrpObj.nature_of_property);
                                                            }
                                                        }
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.tot_survey_numbers))
                                                            collateralObj.Total_Survery_Number__c   =   collateralWrrpObj.tot_survey_numbers;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.plot_no))
                                                            collateralObj.PlotDoorShopBungalow_No__c    =   collateralWrrpObj.plot_no;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.door_no))
                                                            collateralObj.Door__c   =   collateralWrrpObj.door_no;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.area_sqft))
                                                            collateralObj.Area_Square_Feet__c   =   Decimal.valueOf(collateralWrrpObj.area_sqft);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.floor_no))
                                                            collateralObj.Floor_No__c           =   collateralWrrpObj.floor_no;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.block_ward_no))
                                                            collateralObj.Stage_Sector_Ward_Block_No__c =   collateralWrrpObj.block_ward_no;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.building_name))
                                                            collateralObj.Building_Name__c  =   collateralWrrpObj.building_name;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.street))
                                                            collateralObj.Street_NameNo__c  =   collateralWrrpObj.street;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.landmark))
                                                            collateralObj.Landmark__c       =   collateralWrrpObj.landmark;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.state_name))
                                                            collateralObj.State__c          =   collateralWrrpObj.state_name;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.district))
                                                            collateralObj.District_Name__c  =   collateralWrrpObj.district;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.taluk))
                                                            collateralObj.TalukaTehsil__c   =   collateralWrrpObj.taluk;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.sro_name))
                                                            collateralObj.SRO__c            =   collateralWrrpObj.sro_name;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.city))
                                                            collateralObj.clcommon__City__c =   collateralWrrpObj.city;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.pincode))
                                                            collateralObj.clcommon__Postal_Code__c  =   collateralWrrpObj.pincode;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.land_value))
                                                            collateralObj.Land_Value__c     =   Decimal.valueOf(collateralWrrpObj.land_value);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.building_value))
                                                            collateralObj.Building_Value__c =   Decimal.valueOf(collateralWrrpObj.building_value);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.tot_asset_value))
                                                            collateralObj.clcommon__Value__c  =   Decimal.valueOf(collateralWrrpObj.tot_asset_value);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.carpet_area))
                                                            collateralObj.Carpet_Area__c    =   Decimal.valueOf(collateralWrrpObj.carpet_area);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.builtup))
                                                            collateralObj.Buildup_Area__c   =   Decimal.valueOf(collateralWrrpObj.builtup);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.valuation_date))
                                                            collateralObj.Valuation_Date__c =   Date.parse(collateralWrrpObj.valuation_date);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.valuer_name))
                                                            collateralObj.Valuer_Name__c    =   collateralWrrpObj.valuer_name;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.valuer_identity))
                                                            collateralObj.Valuer_Identity__c =  collateralWrrpObj.valuer_identity;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.legal_opinion_date))
                                                            collateralObj.Legal_Opinion_Date__c =   Date.parse(collateralWrrpObj.legal_opinion_date);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.advocate_name))
                                                            collateralObj.Advocate_Name__c      =   collateralWrrpObj.advocate_name;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.advocate_identity))
                                                            collateralObj.Advocate_Identity__c  =   collateralWrrpObj.advocate_identity;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.em_date))
                                                            collateralObj.EM_Date__c    =   Date.parse(collateralWrrpObj.em_date);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.latitude))
                                                            collateralObj.Latitude__c   =   Decimal.valueOf(collateralWrrpObj.latitude);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.longitude))
                                                            collateralObj.Longitude__c  =   Decimal.valueOf(collateralWrrpObj.longitude);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.ownership_type))
                                                            collateralObj.Ownership_Type__c =   collateralWrrpObj.ownership_type;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.no_of_owners))
                                                            collateralObj.Number_of_joint_owners__c =   Integer.valueOf(collateralWrrpObj.no_of_owners);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.mortgage_type))
                                                            collateralObj.MORT_TYPE__c  =   collateralWrrpObj.mortgage_type;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.document_type))
                                                            collateralObj.DOC_TYPE__c   =   collateralWrrpObj.document_type;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.document_no))
                                                            collateralObj.Document_Number__c    =   collateralWrrpObj.document_no;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.document_date))
                                                            collateralObj.Document_Date__c  =   Date.parse(collateralWrrpObj.document_date);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.ec_date))
                                                            collateralObj.EC_Date__c    =   Date.parse(collateralWrrpObj.ec_date);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.collateral_category))
                                                            collateralObj.Collateral_Category__c    =   collateralWrrpObj.collateral_category; 
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.branch_name))
                                                            collateralObj.Branch_Name__c =   collateralWrrpObj.branch_name;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.surrender_value))
                                                            collateralObj.Surrender_Value__c =   Decimal.valueOf(collateralWrrpObj.surrender_value);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.policy_number))
                                                            collateralObj.clcommon__Policy_Number__c =   collateralWrrpObj.policy_number;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.maturity_date))
                                                            collateralObj.Maturity_Date__c =   Date.valueOf(collateralWrrpObj.maturity_date);
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.vehicle_number))
                                                            collateralObj.Vehicle_Number__c =   collateralWrrpObj.vehicle_number;
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.machinery_model))
                                                            collateralObj.Machinery_Model__c =   collateralWrrpObj.machinery_model;
                                                        
                                                        //Application Collateral
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.account_number)){
                                                            ExternalID_AppCo                =   ExternalID_AppCo +'@'+ collateralWrrpObj.account_number;
                                                            appCollateralObj.External_ID__c =   ExternalID_AppCo; 
                                                            mapApplication.put(ExternalID_AppCo,appPartyObj);
                                                            collAppUnique.put(ExternalID_AppCo,collateralWrrpObj.account_number);
                                                            collateralVsAppCollateral.put(ExternalID_AppCo,collateralObj.External_ID__c);
                                                        }
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.is_active)){
                                                            if(checkBooleanReq(collateralWrrpObj.is_active))
                                                                collateralObj.Active__c = true;
                                                            else{
                                                                collateralObj.Active__c = false;
                                                                colleteralIdToDelete.add(collateralWrrpObj.collateral_id);
                                                            }
                                                        }
                                                        If(!Utility.ISStringBlankorNull(collateralWrrpObj.collateral_type))
                                                            appCollateralObj.Security_Type__c = collateralWrrpObj.collateral_type;
                                                        
                                                        String recordTypeIDColl                 =   recordtypeIdMap.get('Land_And_Building');               
                                                        collateralObj.RecordTypeId              =   recordTypeIDColl;
                                                        
                                                    }catch(Exception ex){
                                                        System.debug('Inside Collateral');
                                                        Database.rollback(sp);
                                                        res.status                  = Constants.WS_ERROR_STATUS;
                                                        res.statusCode              = Constants.WS_ERROR_CODE;
                                                        accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                                        accInsertRes.error_reason   = ex.getMessage(); 
                                                        accInsertRes.error_table    = 'COLLATERALS / PARTIES_COLLATERALS';
                                                        res.Error_List.add(accInsertRes);
                                                        facility_flag =true;
                                                        break;
                                                    }
                                                    List<AccountEODResponse.cls_OWNERSHIP>  listOwnerWrpp=  collateralWrrpObj.OWNERSHIP;
                                                    If(listOwnerWrpp !=null && !listOwnerWrpp.isEmpty()){
                                                        for(AccountEODResponse.cls_OWNERSHIP    ownershipWrppObj    : listOwnerWrpp) {
                                                            String ExternalID_Owner         =   '';
                                                            Ownership__c    ownershipObj    =   new  Ownership__c();
                                                            If(ownershipWrppObj !=null){
                                                                try{
                                                                    If(!Utility.ISStringBlankorNull(ownershipWrppObj.Collateral_id)) {
                                                                        ownershipObj.Collateral__r  = new clcommon__Collateral__c(External_ID__c =ownershipWrppObj.Collateral_id);
                                                                        ExternalID_Owner    =   ownershipWrppObj.Collateral_id;
                                                                        ownershipObj.CBS_Collateral_Id__c = ownershipWrppObj.Collateral_id;
                                                                    }
                                                                    
                                                                    If(!Utility.ISStringBlankorNull(ownershipWrppObj.branch_code))
                                                                        ownershipObj.Branch_Code__c =   ownershipWrppObj.branch_code;
                                                                    If(!Utility.ISStringBlankorNull(ownershipWrppObj.owner_name))
                                                                        ownershipObj.Owner_Customer_Name__c =   ownershipWrppObj.owner_name;
                                                                    If(!Utility.ISStringBlankorNull(ownershipWrppObj.loan_custid))
                                                                        ownershipObj.Customer_id__c    =   ownershipWrppObj.loan_custid;
                                                                    If(!Utility.ISStringBlankorNull(ownershipWrppObj.owner_aadhar))
                                                                        ownershipObj.Owner_Aadharcard_Number__c =   ownershipWrppObj.owner_aadhar;
                                                                    If(!Utility.ISStringBlankorNull(ownershipWrppObj.owner_pan))
                                                                        ownershipObj.Owner_Pancard_Number__c    =   ownershipWrppObj.owner_pan;
                                                                    If(!Utility.ISStringBlankorNull(ownershipWrppObj.owner_cust_id)){
                                                                        ownershipObj.Owner_Customer_Id__c  = ownershipWrppObj.owner_cust_id;
                                                                        ownershipObj.Account__r =   new Account(CBS_Customer_ID__c=ownershipWrppObj.owner_cust_id);
                                                                        ExternalID_Owner = ExternalID_Owner+'@'+ownershipWrppObj.owner_cust_id;
                                                                        ownershipObj.External_ID__c =   ExternalID_Owner;
                                                                        mapOwnership.put(ExternalID_Owner,ownershipObj);
                                                                    }
                                                                }catch(Exception ex){
                                                                    System.debug('Inside Ownership');
                                                                    Database.rollback(sp);
                                                                    res.status                  = Constants.WS_ERROR_STATUS;
                                                                    res.statusCode              = Constants.WS_ERROR_CODE;
                                                                    accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                                                    accInsertRes.error_reason   = ex.getMessage(); 
                                                                    accInsertRes.error_table    = 'OWNERSHIP / PARTIES_OWNERSHIP';
                                                                    res.Error_List.add(accInsertRes);
                                                                    collateral_flag = true;
                                                                    break;
                                                                }   
                                                            }
                                                        }
                                                    }
                                                    
                                                    List<AccountEODResponse.cls_Survey> mapSurveyWrpp=  collateralWrrpObj.Survey;
                                                    If(mapSurveyWrpp !=null && ! mapSurveyWrpp.isEmpty()){
                                                        for(AccountEODResponse.cls_Survey   surveyWrrpObj   : mapSurveyWrpp){
                                                            String ExternalID_Survey =  ''; 
                                                            Survey__c   surveyObj   =   new Survey__c();
                                                            If(surveyWrrpObj !=null){
                                                                try{
                                                                    If(!Utility.ISStringBlankorNull(surveyWrrpObj.Collateral_id)){
                                                                        surveyObj.Collateral__r     =   new clcommon__Collateral__c(External_ID__c = surveyWrrpObj.Collateral_id);
                                                                        ExternalID_Survey   =   surveyWrrpObj.Collateral_id;
                                                                    }
                                                                    If(!Utility.ISStringBlankorNull(surveyWrrpObj.Branch_code))
                                                                        surveyObj.Branch_Number__c  =   surveyWrrpObj.Branch_code;
                                                                    If(!Utility.ISStringBlankorNull(surveyWrrpObj.Survey_No)){
                                                                        surveyObj.Suvery_Number__c  =   surveyWrrpObj.Survey_No;
                                                                        ExternalID_Survey = ExternalID_Survey + '@'+surveyWrrpObj.Survey_No;
                                                                    }
                                                                    If(!Utility.ISStringBlankorNull(surveyWrrpObj.sub_div_No)){
                                                                        surveyObj.Sub_Division_Number__c    =   surveyWrrpObj.sub_div_No;
                                                                        ExternalID_Survey = ExternalID_Survey + '@'+surveyWrrpObj.sub_div_No;
                                                                    }
                                                                    If(!Utility.ISStringBlankorNull(ExternalID_Survey)){
                                                                        surveyObj.External_ID__c    =   ExternalID_Survey;
                                                                        mapSurvey.put(ExternalID_Survey,surveyObj);
                                                                    }
                                                                }catch(Exception ex){
                                                                    System.debug('Inside Survey Business');
                                                                    Database.rollback(sp);
                                                                    res.status                  = Constants.WS_ERROR_STATUS;
                                                                    res.statusCode              = Constants.WS_ERROR_CODE;
                                                                    accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                                                    accInsertRes.error_reason   = ex.getMessage(); 
                                                                    accInsertRes.error_table    = 'Survey / PARTIES_Survey';
                                                                    res.Error_List.add(accInsertRes);
                                                                    collateral_flag = true;
                                                                    break;
                                                                }   
                                                            }
                                                        }
                                                    }
                                                }
                                                mapCOllateral.put(collateralWrrpObj.collateral_id,collateralObj);
                                                listAppCollateral.add(appCollateralObj);
                                                
                                                If(collateral_flag){
                                                    facility_flag = true; 
                                                    break;    
                                                }
                                                
                                            } 
                                        }
                                        String recordTypeIDFac                  =   recordtypeIdMap.get('Parent');              
                                        facilityObj.RecordTypeId                =   recordTypeIDFac;
                                        listFacility.add(facilityObj);
                                        
                                        If(facility_flag){
                                            break;
                                        }
                                    }
                                    If(!Utility.ISStringBlankorNull(facPartyObj.product_class) && Class_String_WC.equalsIgnoreCase(facPartyObj.product_class) && renewalAppDueDate != null){
                                        listDateFun.sort();
                                        
                                        appPartyObj.Renewal_Due_Date__c = renewalAppDueDate;
                                        ExternalApp_ID = ExternalApp_ID +'@'+ renewalAppDueDate;
                                        appPartyObj.External_Id__c = ExternalApp_ID;
                                        if(!renewalApplicationCreated){
                                            listApp.add(appPartyObj);
                                            appUniqueMapDetail.put(ExternalApp_ID,appPartyObj);
                                        }
                                        
                                        listDateFun.clear();
                                        renewalApplicationCreated = true;
                                    }
                                    else{
                                        ExternalApp_ID  = ExternalApp_ID +'@Term Loan';
                                        appPartyObj.External_Id__c = ExternalApp_ID;
                                        if(!TL_ApplicationCreated){
                                            appUniqueMapDetail.put(ExternalApp_ID,appPartyObj);
                                            listApp.add(appPartyObj);
                                        }
                                        TL_ApplicationCreated = true;
                                    }
                                    If(!Utility.ISStringBlankorNull(facPartyObj.account_number)){
                                        facilityObj.Account_Number__c       =  facPartyObj.account_number;
                                        Map<String,Boolean> facilityMap = new Map<String,Boolean>();
                                        if(inActiveFacilityCheckMap.get(facPartyObj.customer_id) != null){
                                            facilityMap = inActiveFacilityCheckMap.get(facPartyObj.customer_id);
                                            facilityMap.put(facPartyObj.account_number,checkBooleanReq(facPartyObj.active));
                                        }
                                        else{
                                            facilityMap.put(facPartyObj.account_number,checkBooleanReq(facPartyObj.active));
                                        }
                                        inActiveFacilityCheckMap.put(facPartyObj.customer_id,facilityMap);
                                        System.debug(facPartyObj.account_number+'::appUniqueMapDetail::'+appUniqueMapDetail);
                                        if(appUniqueMapDetail.containsKey(ExternalApp_ID) && appUniqueMapDetail.get(ExternalApp_ID) != null)
                                            mapApplication.put(facPartyObj.account_number,appUniqueMapDetail.get(ExternalApp_ID));
                                    }
                                } 
                            }
                            //List of Collateral Insurance 
                            List<AccountEODResponse.cls_INSURANCE> listInsuranceWrrp    =   accountWrppObj.INSURANCE;
                            
                            If(listInsuranceWrrp !=null){
                                for(AccountEODResponse.cls_INSURANCE    insuranceWrrpObj    : listInsuranceWrrp)  {
                                    String ExternalID_Ins   = '';
                                    clcommon__Collateral_Insurance__c   collateralInsuranceObj  =   new clcommon__Collateral_Insurance__c();
                                    If(insuranceWrrpObj !=null){
                                        try{
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.customer_id)) {
                                                collateralInsuranceObj.Account__r   =   new Account(CBS_Customer_ID__c = insuranceWrrpObj.customer_id); 
                                            }
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Entry_Branch_Code))
                                                collateralInsuranceObj.Entry_Branch_Code__c = Integer.valueOf(insuranceWrrpObj.Entry_Branch_Code);
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Assured_Amount)){
                                                collateralInsuranceObj.Assured_Amount__c    = Decimal.valueOf(insuranceWrrpObj.Assured_Amount);
                                            }
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.CBS_Reference_Value)){
                                                collateralInsuranceObj.CBS_Reference_Value__c   =   insuranceWrrpObj.CBS_Reference_Value;
                                                ExternalID_Ins                                  = insuranceWrrpObj.CBS_Reference_Value;
                                            }
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Insurance_Details))
                                                collateralInsuranceObj.Insurance_Details__c     =   insuranceWrrpObj.Insurance_Details;
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Sl_No)){
                                                collateralInsuranceObj.Sl_No__c                 =   Integer.valueOf(insuranceWrrpObj.Sl_No);
                                                ExternalID_Ins                                  =   ExternalID_Ins+ '@'+ insuranceWrrpObj.Sl_No;
                                            }
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Security_Type))
                                                collateralInsuranceObj.Security_Type__c         =   insuranceWrrpObj.Security_Type;
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Security_Value))
                                                collateralInsuranceObj.Security_Value__c        =   Decimal.valueOf(insuranceWrrpObj.Security_Value);
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Date_Insure))
                                                collateralInsuranceObj.Date_Insure__c           =   Date.parse(insuranceWrrpObj.Date_Insure);
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Date_Policy_Expiry)) {
                                                collateralInsuranceObj.Date_Policy_Expiry__c    =   Date.parse(insuranceWrrpObj.Date_Policy_Expiry);
                                            }
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Insurer_Name))
                                                collateralInsuranceObj.Insurer_Name__c  =   insuranceWrrpObj.Insurer_Name;
                                            If(!Utility.ISStringBlankorNull(insuranceWrrpObj.Insurer_Number)){
                                                collateralInsuranceObj.Insurer_Number__c =  insuranceWrrpObj.Insurer_Number;
                                                ExternalID_Ins          =   ExternalID_Ins+'@'+ insuranceWrrpObj.Insurer_Number;
                                            }
                                            If(!Utility.ISStringBlankorNull(ExternalID_Ins))
                                                collateralInsuranceObj.External_ID__c   =   ExternalID_Ins;
                                            listInsurance.add(collateralInsuranceObj);
                                        }catch(Exception ex){
                                            System.debug('Inside Insurance concern');
                                            Database.rollback(sp);
                                            res.status                  = Constants.WS_ERROR_STATUS;
                                            res.statusCode              = Constants.WS_ERROR_CODE;
                                            accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                            accInsertRes.error_reason   = ex.getMessage(); 
                                            accInsertRes.error_table    = 'INSURANCE / PARTIES_INSURANCE';
                                            res.Error_List.add(accInsertRes);
                                            break;
                                        }
                                    }    
                                }  
                            }
                            
                            //List of Group Concern
                            List<AccountEODResponse.cls_GROUP_CONCERN> listGroupConcernWrrp =   accountWrppObj.GROUP_CONCERN;
                            If(listGroupConcernWrrp !=null && !listGroupConcernWrrp.isEmpty()){
                                for(AccountEODResponse.cls_GROUP_CONCERN    groupConcernWrrpObj     :  listGroupConcernWrrp) {
                                    String              ExternalID_Grp      =   '';
                                    Account             accGroupObj         =   new Account();                  
                                    Group_Concern__c    groupConcernObj     =   new Group_Concern__c();
                                    If(groupConcernWrrpObj !=null){
                                        try{    
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.firm_custid)){
                                                groupConcernObj.Group_1__r      =   new Account(CBS_Customer_ID__c = groupConcernWrrpObj.firm_custid);
                                                ExternalID_Grp                  =   groupConcernWrrpObj.firm_custid;
                                            }
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.related_firm_custid)) {
                                                groupConcernObj.Group_2__r      =   new Account(CBS_Customer_ID__c = groupConcernWrrpObj.related_firm_custid);  
                                                groupConcernObj.External_ID__c  =   ExternalID_Grp +'@'+ groupConcernWrrpObj.related_firm_custid;
                                                accGroupObj.CBS_Customer_ID__c  =   groupConcernWrrpObj.related_firm_custid;
                                            }
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.comp_detail_type))
                                                groupConcernObj.Type__c         =   groupConcernWrrpObj.comp_detail_type;
                                            
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.related_firm_name))
                                                accGroupObj.name        =   groupConcernWrrpObj.related_firm_name;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.account_open_date))
                                                accGroupObj.ACCT_OPEN_DATE__c   =   Date.parse(groupConcernWrrpObj.account_open_date);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.banking_with_us))
                                                accGroupObj.Banking_with_us__c  =   Date.parse(groupConcernWrrpObj.banking_with_us);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.branch_code))
                                                accGroupObj.Branch_Code__c      =   groupConcernWrrpObj.branch_code; 
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.branch_name))
                                                accGroupObj.Branch_Name__c      =   groupConcernWrrpObj.branch_name;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.export_zone)) 
                                                accGroupObj.Export_Zone__c      =   checkBooleanReq(groupConcernWrrpObj.export_zone);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.cin_number))
                                                accGroupObj.CIN_Number__c           =   groupConcernWrrpObj.cin_number;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.pan_number))
                                                accGroupObj.Pan_Number__c           =   groupConcernWrrpObj.pan_number;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.chief_person_name))
                                                accGroupObj.Name_of_the_Chief_Person__c =  groupConcernWrrpObj.chief_person_name;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.contact_person_name))
                                                accGroupObj.Contact_Person_Name__c      =   groupConcernWrrpObj.contact_person_name;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.contact_person_designation))
                                                accGroupObj.Contact_Person_Designation__c  =    groupConcernWrrpObj.contact_person_designation; 
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.constitution))
                                                accGroupObj.Constitution__c             =   groupConcernWrrpObj.constitution; 
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.customer_type)) 
                                                accGroupObj.Customer_Type__c            =   groupConcernWrrpObj.customer_type;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.date_of_incorporation)) 
                                                accGroupObj.Date_of_Incorporation__c    =   Date.parse(groupConcernWrrpObj.date_of_incorporation);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.firm_company_was_reconstituted))
                                                accGroupObj.Firm_Company_was_Reconstituted__c   =   checkBooleanReq(groupConcernWrrpObj.firm_company_was_reconstituted);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.gst_number))
                                                accGroupObj.GST_Number__c               =   groupConcernWrrpObj.gst_number;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.ie_code))
                                                accGroupObj.IE_Code__c                  =   groupConcernWrrpObj.ie_code;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.industry_type))
                                                accGroupObj.Industry_Type__c            =   groupConcernWrrpObj.industry_type;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.line_of_activity))
                                                accGroupObj.Line_of_Activity__c     =   groupConcernWrrpObj.line_of_activity;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.national_identification))
                                                accGroupObj.National_Identification_Code__c     =   groupConcernWrrpObj.national_identification;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.networth_as_on))
                                                accGroupObj.Networth_as_on__c       =   Date.parse(groupConcernWrrpObj.networth_as_on);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.existing_networth))
                                                accGroupObj.Existing_Networth__c        =   Decimal.valueOf(groupConcernWrrpObj.existing_networth);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.number_of_share_held))
                                                accGroupObj.Number_of_Shares_Held__c    =   Integer.valueOf(groupConcernWrrpObj.number_of_share_held);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.over_due))
                                                accGroupObj.Over_Due__c                 =   groupConcernWrrpObj.over_due; 
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.paid_up_capital_on))
                                                accGroupObj.Paid_Up_Capital_On__c       =   Date.parse(groupConcernWrrpObj.paid_up_capital_on);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.paid_up))
                                                accGroupObj.Paid_Up__c              =   Decimal.valueOf(groupConcernWrrpObj.paid_up); 
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.priority_sector))
                                                accGroupObj.Priority_Sector__c          =   checkBooleanReq(groupConcernWrrpObj.priority_sector);
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.whether_sme)){
                                                accGroupObj.Whether_SME__c = checkBooleanReq(groupConcernWrrpObj.whether_sme);
                                            }
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.registered_office_street))
                                                accGroupObj.BillingStreet               =   groupConcernWrrpObj.registered_office_street;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.registered_office_city))
                                                accGroupObj.BillingCity                 =   groupConcernWrrpObj.registered_office_city;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.registered_office_state))
                                                accGroupObj.BillingState                =   groupConcernWrrpObj.registered_office_state;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.registered_office_country))
                                                accGroupObj.BillingCountry              =   groupConcernWrrpObj.registered_office_country;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.registered_office_postalcode))
                                                accGroupObj.BillingPostalCode           =   groupConcernWrrpObj.registered_office_postalcode;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.corporate_office_street))
                                                accGroupObj.ShippingStreet              =   groupConcernWrrpObj.corporate_office_street; 
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.corporate_office_city))
                                                accGroupObj.ShippingCity                =   groupConcernWrrpObj.corporate_office_city;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.corporate_office_state))
                                                accGroupObj.ShippingState               =   groupConcernWrrpObj.corporate_office_state;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.corporate_office_country))
                                                accGroupObj.ShippingCountry             =   groupConcernWrrpObj.corporate_office_country;
                                            If(!Utility.ISStringBlankorNull(groupConcernWrrpObj.corporate_office_postalcode))
                                                accGroupObj.ShippingPostalCode          =   groupConcernWrrpObj.corporate_office_postalcode;
                                            
                                            String recordTypeIDGrStr                    =   recordtypeIdMap.get('Business_Account');                
                                            accGroupObj.RecordTypeId                    =   recordTypeIDGrStr;
                                            listAccountObject.add(accGroupObj); 
                                            
                                            listGroupConcern.add(groupConcernObj);
                                        }catch(Exception ex){
                                            System.debug('Inside Group concern');
                                            Database.rollback(sp);
                                            res.status                  = Constants.WS_ERROR_STATUS;
                                            res.statusCode              = Constants.WS_ERROR_CODE;
                                            accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                            accInsertRes.error_reason   = ex.getMessage(); 
                                            accInsertRes.error_table    = 'GROUP_CONCERN';
                                            res.Error_List.add(accInsertRes);
                                            break;
                                        }
                                    }    
                                }
                            }
                            try{
                                System.debug('############:::: ' + personAccList);
                                If(!listAccountObject.isEmpty()){
                                    System.debug('RESULT----->>> ' + listAccountObject);
                                    AccountTriggerHandler.isAccountTrigger = false;
                                    UPSERT listAccountObject CBS_Customer_ID__c;
                                }
                                If(!personAccList.isEmpty()){
                                    System.debug('############:::: ' + personAccList);
                                    AccountTriggerHandler.isAccountTrigger = false;
                                    UPSERT personAccList CBS_Customer_ID__c;
                                }
                            }catch(Exception ex){
                                system.debug('Inside  Account catch block');
                                Database.rollback(sp);
                                System.debug('Message::'+ex.getMessage() + 'Cause'+ ex.getCause());
                                System.debug('Error::'+ex.getStackTraceString());
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'ACCOUNT / PARTIES / GROUP_CONCERN';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }
                            try{
                                ApplicationTriggerHandler.IsFirstRun = false;
                                System.debug('listAppSize::'+listApp.size());
                                If(!listApp.isEmpty()) {
                                    System.debug('custIdAppMap:::'+custIdAppMap);
                                    System.debug('inActiveFacilityCheckMap:::'+inActiveFacilityCheckMap );
                                    for(genesis__Applications__c app : listApp){
                                        String appCustId = app.genesis__Account__r.CBS_Customer_ID__c;
                                        
                                        if(app.Branch_Code__c != null) branchCodeSet.add(app.Branch_Code__c);
                                        
                                        System.debug(app.External_Id__c+'----'+app.Renewal_Due_Date__c);
                                        if(app.Renewal_Due_Date__c != null && System.today().monthsBetween(app.Renewal_Due_Date__c) <= 6){
                                            System.debug('Lesser case:::');
                                            //update existing application
                                            if(custIdAppMap.get(appCustId) != null){
                                                app.Id = custIdAppMap.get(appCustId).Id;
                                                app.Active__c = true;
                                                if(custIdAppMap.get(appCustId).Renewal_Due_Date__c == null)
                                                    app.CBS_Due_Date__c =  app.Renewal_Due_Date__c;
                                                
                                                //Check Closed Account
                                                app = checkClosedApplication(app,appCustId,inActiveFacilityCheckMap);
                                                //app = checkClosedApplication(app,inActiveFacilityCheckMap);
                                            }           
                                            else{
                                                app.CBS_Due_Date__c =  app.Renewal_Due_Date__c;
                                                app.Application_Stage__c = Constants.APPLN_INITIATED;
                                                app.Active__c = true;
                                            }
                                            appLessToUpsert.add(app);
                                        }
                                        else if(app.Renewal_Due_Date__c != null && System.today().monthsBetween(app.Renewal_Due_Date__c) > 6){
                                            System.debug('Greater case:::');
                                            if(custIdAppMap.get(appCustId) != null){
                                                if(custIdAppMap.get(appCustId).Application_Stage__c == Constants.APPLN_MORE_THAN_6_MONTH){
                                                    app.Id = custIdAppMap.get(appCustId).Id;
                                                    //Check Closed Account
                                                    app = checkClosedApplication(app,appCustId,inActiveFacilityCheckMap);
                                                    //app = checkClosedApplication(app,inActiveFacilityCheckMap);
                                                    appToUpdateList.add(app);
                                                }
                                                else{
                                                    genesis__Applications__c appToDeactivate = new genesis__Applications__c(Id = custIdAppMap.get(appCustId).Id, Active__c = false);
                                                    deactiveAppId = custIdAppMap.get(appCustId).Id;
                                                    if(custIdAppMap.get(appCustId).Renewal_Due_Date__c == null)
                                                        appToDeactivate.CBS_Due_Date__c = app.Renewal_Due_Date__c;
                                                    appToUpdateList.add(appToDeactivate);
                                                    
                                                    app.Active__c = true;
                                                    app.Application_Stage__c = Constants.APPLN_MORE_THAN_6_MONTH;
                                                    app.Type__c  = 'RENEWAL';
                                                    appToInsertList.add(app);
                                                }
                                            }
                                            else{
                                                app.Active__c = true;
                                                app.Application_Stage__c = Constants.APPLN_MORE_THAN_6_MONTH;
                                                app.CBS_Due_Date__c = app.Renewal_Due_Date__c;
                                                app.Type__c  = 'RENEWAL';
                                                appToInsertList.add(app);
                                            }
                                        }
                                        else{
                                            //Term loan applications
                                            app.Application_Stage__c = Constants.TL_INITIATED;
                                            appToUpsertList.add(app);
                                        }
                                    }
                                } 
                                if(!appToUpdateList.isEmpty()){
                                    //deactivate existing applications
                                    UPDATE appToUpdateList;
                                    createPreRenewalChecklist(appToUpdateList);
                                }
                                if(!appToInsertList.isEmpty()){
                                    //Insert applications
                                    INSERT appToInsertList;
                                    createPreRenewalChecklist(appToInsertList);
                                } 
                                if(!appLessToUpsert.isEmpty()){
                                    for(genesis__Applications__c app : appLessToUpsert){
                                        System.debug(app.Id+'--'+app.External_Id__c);
                                    }
                                    UPSERT appLessToUpsert;
                                    createPreRenewalChecklist(appLessToUpsert);
                                }
                                if(!appToUpsertList.isEmpty()){
                                    //Upsert  existing applications
                                    UPSERT appToUpsertList External_Id__c;
                                    createPreRenewalChecklist(appToUpsertList);
                                }                               
                            }catch(Exception ex){
                                system.debug('Inside  Application catch block');
                                System.debug(ex.getMessage());
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'Business Facilities / Parties Facilities';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }
                            
                            Map<String,string> appNumVsExternalMap    = new Map<String,string>();
                            try{
                                If(!listFacility.isEmpty()) {
                                    List<Facility__c> missedFac        = new List<Facility__c>();
                                    List<Facility__c> passedFac        = new List<Facility__c>();
                                    List<Facility__c> finalList        = new List<Facility__c>();
                                    for(Facility__c     facilityObj     : listFacility){
                                        if(mapApplication.get(facilityObj.Account_Number__c) != null 
                                           && mapApplication.get(facilityObj.Account_Number__c).Id !=null){
                                               facilityObj.Application__c  =   mapApplication.get(facilityObj.Account_Number__c).Id; 
                                               string appId        = mapApplication.get(facilityObj.Account_Number__c).Id;
                                               if(appId.length() == 18 ) appId = appId.substring(0,appId .length()-3);                                                
                                               facilityObj.External_Id__c  =   facilityObj.Account_Number__c+'@'+appId;
                                               appNumVsExternalMap.put(facilityObj.Account_Number__c,facilityObj.External_Id__c);
                                               
                                               //Prepopulation of facility existing data
                                               if(mapApplication.get(facilityObj.Account_Number__c).Application_Stage__c == '>6 months due for renewal' && AccountEOD_Helper.accNumFacMap.get(facilityObj.Account_Number__c) != null){
                                                   Facility__c fac = AccountEOD_Helper.accNumFacMap.get(facilityObj.Account_Number__c);
                                                   
                                                   if(fac.Recommended_Processing_Charge__c != null) facilityObj.Existing_Processing_Charge__c = fac.Recommended_Processing_Charge__c;
                                                   else if(fac.Existing_Processing_Charge__c != null) facilityObj.Existing_Processing_Charge__c = fac.Existing_Processing_Charge__c;
                                                   
                                                   if(fac.Margin__c != null) facilityObj.Approved_Margin__c = fac.Margin__c;
                                                   else if(fac.Approved_Margin__c != null) facilityObj.Approved_Margin__c = fac.Approved_Margin__c;
                                                   
                                                   if(fac.Margin_Receivables__c != null) facilityObj.Existing_Margin_Receivables__c = fac.Margin_Receivables__c;
                                                   else if(fac.Existing_Margin_Receivables__c != null) facilityObj.Existing_Margin_Receivables__c = fac.Existing_Margin_Receivables__c;
                                                   
                                                   if(fac.Margin_Stock_Manufacturing__c != null) facilityObj.Existing_Margin_Stock_Manufacturing__c = fac.Margin_Stock_Manufacturing__c;
                                                   else if(fac.Existing_Margin_Stock_Manufacturing__c != null) facilityObj.Existing_Margin_Stock_Manufacturing__c = fac.Existing_Margin_Stock_Manufacturing__c;
                                                   
                                                   if(fac.Margin_Stock_Trading__c != null) facilityObj.Existing_Margin_Stock_Trading__c = fac.Margin_Stock_Trading__c;
                                                   else if(fac.Existing_Margin_Stock_Trading__c != null) facilityObj.Existing_Margin_Stock_Trading__c = fac.Existing_Margin_Stock_Trading__c;
                                               }
                                           }
                                    }
                                    UPSERT listFacility External_Id__c;
                                }
                            }catch(Exception ex){
                                system.debug('Inside  Facility catch block');
                                System.debug(ex.getMessage());
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'FACILITY / PARTIES_FACILITY';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }   
                            try{
                                If(!partyList.isEmpty()){
                                    SendSMSService.Recusrive = false;
                                    for(genesis__Application_Parties__c party : partyList ){
                                        if(!appToInsertList.isEmpty()){
                                            party.genesis__Application__c = appToInsertList[0].Id;
                                            System.debug(party.Id+'::QQ:'+party.External_ID__c);
                                            party.External_ID__c += +'@'+appToInsertList[0].Id;
                                            System.debug(party.Id+'::RR:'+party.External_ID__c);
                                        }
                                        else if(custIdAppMap.get(party.Key_Contact__r.CBS_Customer_ID__c) != null){
                                            party.genesis__Application__c = custIdAppMap.get(party.Key_Contact__r.CBS_Customer_ID__c).Id;
                                            System.debug(party.Id+'::QQ:'+party.External_ID__c);
                                            party.External_ID__c += +'@'+custIdAppMap.get(party.Key_Contact__r.CBS_Customer_ID__c).Id;
                                            System.debug(party.Id+'::RR:'+party.External_ID__c);
                                        }
                                    }
                                    
                                    for(genesis__Application_Parties__c party : partyList ){
                                      System.debug(party.Id+'::PP:'+party.External_ID__c);
                                    }
                                    UPSERT partyList External_ID__c;
                                }  
                            }catch(Exception ex){
                                system.debug('Inside  Party catch block');
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'PARTIES';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }
                            try{
                                If(!mapCOllateral.isEmpty()){
                                    UPSERT mapCOllateral.values() External_ID__c; 
                                } 
                            }catch(Exception ex){
                                system.debug('Inside  Collateral catch block');
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'COLLATERALS / PARTIES_COLLATERALS';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }
                            try{
                                If(!listAppCollateral.isEmpty()) {
                                    for(genesis__Application_Collateral__c  appCollateral   :   listAppCollateral){
                                        if(collAppUnique.get(appCollateral.External_ID__c) !=null && mapApplication.get(collAppUnique.get(appCollateral.External_ID__c)) !=null &&
                                           mapApplication.get(collAppUnique.get(appCollateral.External_ID__c)).Id !=null){
                                               appCollateral.Application__c    =   mapApplication.get(collAppUnique.get(appCollateral.External_ID__c)).Id;
                                               appCollateral.Facility__r            = new Facility__c(External_ID__c = appNumVsExternalMap.get(collAppUnique.get(appCollateral.External_ID__c)));
                                               appCollateral.External_ID__c         =   appNumVsExternalMap.get(collAppUnique.get(appCollateral.External_ID__c))+'@'+collateralVsAppCollateral.get(appCollateral.External_ID__c);
                                           }
                                        if(partyCollAppUnique.get(appCollateral.External_ID__c) !=null && mapApplication.get(partyCollAppUnique.get(appCollateral.External_ID__c)) !=null &&
                                           mapApplication.get(partyCollAppUnique.get(appCollateral.External_ID__c)).Id !=null){
                                               appCollateral.Application__c    =   mapApplication.get(partyCollAppUnique.get(appCollateral.External_ID__c)).Id;
                                               appCollateral.Facility__r            = new Facility__c(External_ID__c = appNumVsExternalMap.get(partyCollAppUnique.get(appCollateral.External_ID__c)));
                                               appCollateral.External_ID__c         =   appNumVsExternalMap.get(partyCollAppUnique.get(appCollateral.External_ID__c))+'@'+collateralVsAppCollateral.get(appCollateral.External_ID__c);
                                           }
                                    }
                                    UPSERT listAppCollateral External_ID__c;
                                    list<genesis__Application_Collateral__c> inactiveColleteralId = [SELECT Id FROM genesis__Application_Collateral__c WHERE genesis__Collateral__r.clcommon__Collateral_Name__c IN :colleteralIdToDelete];
                                }
                            }catch(Exception ex){
                                system.debug('Inside Application Collateral catch block');
                                System.debug(ex.getStackTraceString());
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'COLLATERALS / PARTIES_COLLATERALS';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }
                            try{
                                If(!mapOwnership.isEmpty()) {
                                    UPSERT mapOwnership.values() External_ID__c;
                                }    
                            }catch(Exception ex){
                                system.debug('Inside Ownership catch block');
                                system.debug(ex.getMessage());
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'OWNERSHIP / PARTIES_OWNERSHIP';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }
                            try{
                                If(!mapSurvey.isEmpty()) {
                                    UPSERT mapSurvey.values() External_ID__c;
                                    System.debug('Survey ::'+ mapSurvey.size());
                                }    
                            }catch(Exception ex){
                                system.debug('Inside Survey catch block');
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'Survey / PARTIES_Survey';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }
                            try{
                                If(!listInsurance.isEmpty()) {
                                    UPSERT listInsurance External_ID__c;
                                    System.debug('Insurance ::'+listInsurance.size());
                                }    
                            }catch(Exception ex){
                                system.debug('Inside Insurance catch block');
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'INSURANCE / PARTIES_INSURANCE';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }
                            try{
                                If(!listGroupConcern.isEmpty()){
                                    UPSERT listGroupConcern External_ID__c;
                                    System.debug('Group Concern ::'+listGroupConcern.size());
                                }    
                            }catch(Exception ex){
                                system.debug('Inside Group Concern catch block');
                                Database.rollback(sp);
                                res.status                  = Constants.WS_ERROR_STATUS;
                                res.statusCode              = Constants.WS_ERROR_CODE;  
                                accInsertRes.cust_Id        = accountWrppObj.customer_id;
                                accInsertRes.error_reason   = ex.getMessage(); 
                                accInsertRes.error_table    = 'GROUP_CONCERN';
                                res.Error_List.add(accInsertRes);
                                continue;
                            }
                        }
                        
                        successCount++;
                        accSuccessRes.cust_Id = accountWrppObj.customer_id;
                        accSuccessRes.sucess_message = 'Account insert success';
                        res.Success_List.add(accSuccessRes);
                        custIdSet.add(accountWrppObj.customer_id);
                        
                        listSucess.add(i++);
                        system.debug(partyCbsIdMap+':::Handler:::'+colIdBoolMap);
                        
                        if(partyCbsIdMap.size()>0 || colIdBoolMap.size()>0) 
                            AccountEOD_Helper.resetApplication(partyCbsIdMap,colIdBoolMap);
                        AccountEOD_Helper.appAccNumPartyMap.clear();
                        AccountEOD_Helper.enhancementApp = null;
                        AccountEOD_Helper.adhocApp = null;
                        AccountEOD_Helper.exceddingApp = null;
                        AccountEOD_Helper.newLoanApp = null;
                        AccountEOD_Helper.appObj = null;
                         if(deactiveAppId != null)
                            AccountEOD_Helper.changeParentIdOnEnhancNewLoanApp(deactiveAppId);
                    }
                }else{
                    res.status                  = Constants.WS_ERROR_STATUS;
                    res.statusCode              = Constants.WS_ERROR_CODE;
                    res.errorMessage            = 'Requested List size is more than 10';
                } 
                if(!res.Success_List.isEmpty() && !branchCodeSet.isEmpty()){
                    AccountEOD_Helper.ownershipAssignment(branchCodeSet);
                }
                if(!res.Error_List.isEmpty()){
                    for(WS_AccountEODDeltaChange.AccInsertResponse error : res.Error_List){
                        if(error.error_reason.contains('Cannot specify any additional fields when marrying or separating a Person-Account'))
                            error.error_reason = 'Unexpected customer type conversion';
                    }
                }
            }               
        }
        if(!colleteralIdToDelete.isEmpty()){
            System.debug('colleteralIdToDelete::'+colleteralIdToDelete);
            DELETE [SELECT Id FROM genesis__Application_Collateral__c WHERE genesis__Collateral__r.clcommon__Collateral_Name__c IN :colleteralIdToDelete];
        }
        System.debug('custIdSet:::'+custIdSet);
        
        if(custIdSet.size() > 0) AccountEOD_Helper.checkLimitValue(custIdSet);
        res.failed_Account          = res.Error_List.size();
        res.success_Account         = successCount;
        If(listSucess.size()+res.Error_List.size() !=Total_NumberOF_Request){
            res.status                  = Constants.WS_ERROR_STATUS;
            res.statusCode              = Constants.WS_ERROR_CODE;
            res.errorMessage            = 'Request and response size does not matched';  
        }
        RETURN res;
    }
    public static Boolean checkBooleanReq(String reqString){
        if(reqString == '1' || reqString == 'true' || reqString == 'Yes'){
            RETURN true;
        }
        else
            RETURN false;
    }
    
    //Closed Account Check
    public static genesis__Applications__c checkClosedApplication(genesis__Applications__c app,String appCustId,Map<String,Map<String,Boolean>> inActiveFacilityCheckMap){
        Boolean inactiveFacilityFlag = false;
        if(inActiveFacilityCheckMap.get(appCustId) != null){
            for(String accNumber : inActiveFacilityCheckMap.get(appCustId).keySet()){
                if(inActiveFacilityCheckMap.get(appCustId).get(accNumber)){
                    inactiveFacilityFlag = true;
                }
            }
        }
        if(!inactiveFacilityFlag){
            app.Application_Stage__c = 'Account Closed';
            app.Active__c = false;
        }
        RETURN app;
    }
    public static genesis__Applications__c checkClosedApplication1(genesis__Applications__c app,Map<String,Boolean> inActiveFacilityCheckMap){
        Boolean inactiveFacilityFlag = false;
        if(inActiveFacilityCheckMap.size() > 0){
            inactiveFacilityFlag = true;
            for(Boolean active : inActiveFacilityCheckMap.values()){
                if(active == true){
                    inactiveFacilityFlag = false;
                }
            }
        }
        
        if(inactiveFacilityFlag == true){
            app.Application_Stage__c = 'Account Closed';
            app.Active__c = false;
        }
        RETURN app; 
    }
    public static void createPreRenewalChecklist(List<genesis__Applications__c> appList){
        if(appList.size() > 0){
            Set<Id> appIdSet = new Set<Id>();
            List<genesis__Applications__c> appListToCheck = new List<genesis__Applications__c>();
            for(genesis__Applications__c app : appList){
                appIdSet.add(app.Id);
            }
            appListToCheck = [SELECT Id,(SELECT Id FROM Pre_Renewal_Checklists__r) FROM genesis__Applications__c WHERE Id IN : appIdSet];
            for(genesis__Applications__c app : appListToCheck){
                if(app.Pre_Renewal_Checklists__r.size() == 0)
                    SME_PRE_RENEWAL_CHECKING.createPrechecklist(new List<Id>{app.Id});
            }
        }
    }
}