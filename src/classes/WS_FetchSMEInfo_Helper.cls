/*
* Description : Helper class of WS_FetchSMEInfo
* Author       : Raushan
*/
public class WS_FetchSMEInfo_Helper {
    public static String userId = '';
    public CustomerDetail CustomerDetail;
    
    public class CustomerDetail {
        public String Applicant_name;
        public String Application_No;
        public String Constitution;
        public String Customer_Id;
        public String Line_of_activity;
        public String Industry_type;
        public String PAN;
        public String GST_NUMBER;
        public String MSME;
        public String Import_Export_Code;
        public Registered_Address Registered_Address;
        public Registered_Address Communication_Address;
        public List < cls_Key_Person_Details > Key_Person_Details;
        public String Contact_Name;
        public String Contact_Number;
        public String EMAIL_ADDRESS;
        public String Group_Name;
        public String Name;
        public String CIN;
        public String REASONS_FOR_GST_NOT_APPLICABLE;
        public String Turnover;
        public String PRINCIPAL_NATURE_OF_BUSINESS;
        public String Date_Incorporated;
        public String BRANCH_CODE;
        public String BRANCH_NAME;
        public String CUST_SINCE;
        public List<cls_FACILITY_DETAILS> FACILITY_DETAILS;
        public List<cls_Key_Person_Details> TL_KEY_PERSON_DETAILS;
    }
    public class cls_FACILITY_DETAILS{
        public String Date_Of_Maturity;         
        public String Product_Name;             
        public String Amt_Disbursed;            
        public String Amt_Face_Value;           
        public String Tenor;                    
        public String Product_Code;             
        public String Bal_Book;                 
        public String Date_Of_AccountOpen;      
        public String Amt_Net_Disbursed;        
        public String Holiday_Period;           
        public String Account_Number; 

        public List<cls_COLLATERAL_DETAILS> COLLATERAL_DETAILS;          

    }
    public class cls_TL_KEY_PERSON_DETAILS{
        public String Email;
        public String Party_Type;
        public String Address;
        public String City;
        public String Gender;
        public String Date_Of_Birth;
        public String Mobile;
        public String Nationality;
        public String Name;
        public String Customer_Id;
        public String State;
        public String Spouse_Name;
        public String Country;
        public String PAN;
        public String Adhaar_Number;
        public String Pincode;
        public String Passport_No;
    }
    public class cls_COLLATERAL_DETAILS{
        public String Tot_Survery_Number;        
        public String District_Name;             
        public String Valuer_Name;               
        public String Cersai_Asset_Id;           
        public String Latitude;                  
        public String Carpet_Area;               
        public String Em_Date;                   
        public String Document_Type;             
        public String Door_Number;               
        public String PinCode;                   
        public String Legal_Opinion_Date;        
        public String Ownership_Type;            
        public String Valuer_Identity;           
        public String City_Town;                 
        public String State_Name;                
        public String Cersai_Security;           
        public String Valuation_Date;            
        public String Document_Date;             
        public String Floor_Number;              
        public String Account_Number;            
        public String Cersai_Reg_Date;           
        public String Building_Name;             
        public String No_Of_Joint_Owners;        
        public String Branch_Code;               
        public String Advocate_Name;            
        public String Taluk_Name;                
        public String Srn_Number;                
        public String Street_Name;               
        public String Landmark;                  
        public String Sro_Name;                  
        public String Tot_Asset_Value;           
        public String Longitude;                 
        public String Land_Value;                
        public String Nature_Of_Property;        
        public String Collatera_Id;              
        public String Plot_Number;               
        public String EC_Date;                   
        public String Cust_Id;                   
        public String Srn_Date_Mca;              
        public String Building_Value;            
        public String Advocate_Identity;         
        public String Builtup_Area;              
        public String Document_No;               
        public String Mortgage_Type;             
        public String Area_Sqft;                 
        public String Block_Ward_No;             

    }
    public class cls_Key_Person_Details {
        public String Name;
        public String Party_Type;
        public String Customer_ID;
        public String Passport_No;
        public String Nationality;
        public String PAN;
        public String Aadhaar_Number;
        public String Date_Of_Birth;
        public String Phone;
        public String Email;
        public String Gender;
        public Registered_Address Registered_Address;
    }
    public class Registered_Address {
        public String Address;
        public String City;
        public String State;
        public String Country;
        public String PostalCode;
    }
    
    public CustomerDetail parse(String json) {
        return (CustomerDetail) System.JSON.deserialize(json, CustomerDetail.class);
    }
    public static String updateCustomerDetails(CustomerDetail cusObj, String Type, String Customer_ID, Account existCust) {
        
        If(cusObj != null) {
            try {
                if (cusObj.BRANCH_CODE != null && cusObj.BRANCH_CODE != '') {
                    User userObj = SOQL_Util.getUserByBranchCode(cusObj.BRANCH_CODE);
                    if (userObj != null) {
                        userId = userObj.Id;
                    }
                }
            } catch (Exception ex) {
                System.debug('Exception ::' + ex.getMessage() + 'Line number' + ex.getLineNumber());
            }
            Account accObject = new Account();
            String appCloneId = '';
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            If(!Utility.ISStringBlankorNull(cusObj.Applicant_name))
                accObject.Name = cusObj.Applicant_name;
            If(!Utility.ISStringBlankorNull(cusObj.Constitution))
                accObject.Constitution__c = cusObj.Constitution;
            If(!Utility.ISStringBlankorNull(Customer_ID))
                accObject.CBS_Customer_ID__c = Customer_ID;
            If(!Utility.ISStringBlankorNull(cusObj.Line_of_activity)) {
                accObject.Line_of_Activity__c = cusObj.Line_of_activity;
                /*If(cusObj.Line_of_activity == 'Service Provision'){
                    accObject.Cash_Budget__c = true;
                } */
            }
            accObject.RecordTypeId = devRecordTypeId;
            If(!Utility.ISStringBlankorNull(cusObj.Industry_type))
                accObject.Industry_Type__c = cusObj.Industry_type;
            If(!Utility.ISStringBlankorNull(cusObj.PAN))
                accObject.Pan_Number__c = cusObj.PAN;
            If(!Utility.ISStringBlankorNull(cusObj.GST_NUMBER)) {
                accObject.GST_Number__c = cusObj.GST_NUMBER;
                System.debug('GST NUMBER' + cusObj.GST_NUMBER);
            }
            If(!Utility.ISStringBlankorNull(cusObj.Contact_Name))
                accObject.Contact_Person_Name__c = cusObj.Contact_Name;
            If(!Utility.ISStringBlankorNull(cusObj.Contact_Number))
                accObject.Cust_mobile_phone__c = cusObj.Contact_Number;
            If(!Utility.ISStringBlankorNull(cusObj.EMAIL_ADDRESS))
                accObject.Company_Email__c = cusObj.EMAIL_ADDRESS;
            If(!Utility.ISStringBlankorNull(cusObj.Group_Name))
                accObject.Group_Name__c = cusObj.Group_Name;
            If(!Utility.ISStringBlankorNull(cusObj.CUST_SINCE))
                accObject.CUSTSINCE__c = Date.parse(cusObj.CUST_SINCE);
            If(!Utility.ISStringBlankorNull(cusObj.CIN))
                accObject.CIN_Number__c = cusObj.CIN;
            If(!Utility.ISStringBlankorNull(cusObj.BRANCH_CODE))
                accObject.Branch_Code__c = cusObj.BRANCH_CODE;
            If(!Utility.ISStringBlankorNull(cusObj.BRANCH_NAME))
                accObject.Branch_Name__c = cusObj.BRANCH_NAME;
            If(!Utility.ISStringBlankorNull(cusObj.REASONS_FOR_GST_NOT_APPLICABLE)) {
                accObject.Reasons_for_exemption_from_GST__c = cusObj.REASONS_FOR_GST_NOT_APPLICABLE;
            }
            If(!Utility.ISStringBlankorNull(cusObj.Turnover))
                accObject.Annual_TurnoverIncome__c = Decimal.valueOf(cusObj.Turnover);
            If(!Utility.ISStringBlankorNull(cusObj.PRINCIPAL_NATURE_OF_BUSINESS)) {
                accObject.Principal_nature_of_business__c = cusObj.PRINCIPAL_NATURE_OF_BUSINESS;
            } //Date_Incorporated
            If(!Utility.ISStringBlankorNull(cusObj.Date_Incorporated)) {
                accObject.Date_of_Incorporation__c = Date.parse(cusObj.Date_Incorporated);
            }
            If(cusObj.Registered_Address != null) {
                WS_FetchSMEInfo_Helper.Registered_Address registeredObj = cusObj.Registered_Address;
                If(registeredObj != null) {
                    If(!Utility.ISStringBlankorNull(registeredObj.Address))
                        accObject.BillingStreet = registeredObj.Address;
                    If(!Utility.ISStringBlankorNull(registeredObj.City))
                        accObject.BillingCity = registeredObj.City;
                    If(!Utility.ISStringBlankorNull(registeredObj.State))
                        accObject.BillingState = registeredObj.State;
                    If(!Utility.ISStringBlankorNull(registeredObj.PostalCode))
                        accObject.BillingPostalCode = registeredObj.PostalCode;
                    
                    accObject.BillingCountry = 'India';
                }
            }
            If(cusObj.Communication_Address != null) {
                WS_FetchSMEInfo_Helper.Registered_Address communicationObj = cusObj.Communication_Address;
                If(communicationObj != null) {
                    
                    If(!Utility.ISStringBlankorNull(communicationObj.Address))
                        accObject.ShippingStreet = communicationObj.Address;
                    If(!Utility.ISStringBlankorNull(communicationObj.City))
                        accObject.ShippingCity = communicationObj.City;
                    If(!Utility.ISStringBlankorNull(communicationObj.State))
                        accObject.ShippingState = communicationObj.State;
                    If(!Utility.ISStringBlankorNull(communicationObj.PostalCode))
                        accObject.ShippingPostalCode = communicationObj.PostalCode;
                    accObject.ShippingCountry = 'india';
                    if (userId != null && userId != '') {
                        accObject.OwnerId = (id) userId;
                    }
                    
                }
            }
            If(existCust !=null){
                accObject.Id    = existCust.id;
                accObject.Active__c = true;
                accObject.CBS_Customer_ID__c = existCust.CBS_Customer_ID__c;
                AccountTriggerHandler.isAccountTrigger = false;
                update accObject;
            
            }else If(accObject != null) {
                System.debug('accObject' + accObject);
                AccountTriggerHandler.isAccountTrigger = false;
                insert accObject;
                If(Type == 'NTB') {
                    accObject.CBS_Customer_ID__c = accObject.id;
                    update accObject;
                } else if (Type == 'ETB-CA') {
                    System.debug('***Calling Operation Data*** '+accObject.CBS_Customer_ID__c);
                    If(accObject.CBS_Customer_ID__c != null && accObject.CBS_Customer_ID__c != '') {
                        callOperationaData_API(accObject.CBS_Customer_ID__c);
                    }
                    
                }
                
            }
            System.debug('accObject.CBS_Customer_ID__c===> '+accObject.CBS_Customer_ID__c);
            If(accObject.CBS_Customer_ID__c != null && accObject.CBS_Customer_ID__c != '') {
                
                return accObject.CBS_Customer_ID__c;
            }
            
        }
        return null;
    }
    
    public static String createApplication(String Customer_ID, String Type, CustomerDetail cusObj, String LoanType) {
        try{
            If(Customer_ID != null && Customer_ID != '') {
                Id devRecordTypeId;
                genesis__Applications__c newApplicationObj = new genesis__Applications__c();
                if(LoanType== 'Term Loan'){
                    devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.TERM_LOAN).getRecordTypeId();
                    newApplicationObj.Application_Stage__c = 'TL Open Applications';  
                }else{
                    devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.SME_NEW_LOAN_RECORD_TYPE_LABEL).getRecordTypeId();
                    newApplicationObj.Application_Stage__c = 'New loans - Application created'; // TL Open Applications
                }
                newApplicationObj.genesis__Account__r = new Account(CBS_Customer_ID__c = Customer_ID);
                //newApplicationObj.genesis__Account__c= Customer_ID;
                System.debug('Customer_ID' + Customer_ID);
                newApplicationObj.RecordTypeId = devRecordTypeId;
                newApplicationObj.Type__c = Type;
                newApplicationObj.Active__c = LoanType== 'Term Loan'? false :true;
                newApplicationObj.CBS_API_Sequence__c = '16';
                
                if (cusObj.BRANCH_CODE != null && cusObj.BRANCH_CODE != '')
                    newApplicationObj.Branch_Code__c = cusObj.BRANCH_CODE;
                if (cusObj.BRANCH_NAME != null && cusObj.BRANCH_NAME != '')
                    newApplicationObj.Branch_Name__c = cusObj.BRANCH_NAME;
                if (userId != null && userId != '') {
                    newApplicationObj.OwnerId = (id) userId;
                }
                If(newApplicationObj != null) {
                    System.debug('newApplicationObj' + newApplicationObj);
                    insert newApplicationObj;
                    If(newApplicationObj.Type__c == 'NTB') {
                        try {
                            Set < String > setOfString = new Set < String > {
                                newApplicationObj.id
                                    };
                                        SME_SendSMSService.sendSMSApp_SME(setOfString);
                        } catch (Exception ex) {
                            System.debug('Exception' + ex.getMessage());
                        }
                    }
                    return newApplicationObj.id;
                }     
            }

        }
        catch(Exception ex){
            System.debug('Error Message====> '+ex.getMessage()+'Error Line Number====> '+ex.getLineNumber());
            return null;
        }
        
        return null;
    }
    public static void createParties(String Customer_ID, String appId, List < cls_Key_Person_Details > listKeyPersonWrp, String Type) {
        
        Set < String > listOfAadhar = new Set < String > ();
        Set < String > listOfPan = new Set < String > ();
        List < Account > listKeyPerson = new List < Account > ();
        List < Account > updateKeyPerson = new List < Account > ();
        Boolean isNewKeyPerson = true;
        List < genesis__Application_Parties__c > listOfParties = new List < genesis__Application_Parties__c > ();
        Map < String, String > mapOfString = new Map < String, String > ();
        Map < String, Account > mapOfExistingKeyPerson = new Map < String, Account > ();
        If(Customer_ID != null && Customer_ID != '' && appId != null && appId != '') {
            //PERSON_ACCOUNT
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            If(listKeyPersonWrp != null && !listKeyPersonWrp.isEmpty()) {
                for (cls_Key_Person_Details Kpd: listKeyPersonWrp) {
                    if (Kpd != null) {
                        If(!Utility.ISStringBlankorNull(Kpd.Aadhaar_Number)) {
                            listOfAadhar.add(Kpd.Aadhaar_Number);
                        } else If(!Utility.ISStringBlankorNull(Kpd.PAN)) {
                            listOfPan.add(Kpd.PAN);
                        }
                    }
                    
                }
                //Map < Id, Account > mapOfAccount = SOQL_Util.getKeyPersonDetails(listOfPan, listOfAadhar);
                Map < Id, Account > mapOfAccount = new Map < Id, Account >();
                If(mapOfAccount != null && mapOfAccount.size() > 0) {
                    for (Account accObj: mapOfAccount.values()) {
                        if (accObj != null) {
                            if (accObj.Aadhaar_Number__pc != null && accObj.Aadhaar_Number__pc != '') {
                                mapOfExistingKeyPerson.put(accObj.Aadhaar_Number__pc, accObj);
                            } else if (accObj.Pan_Number__c != null && accObj.Pan_Number__c != '') {
                                mapOfExistingKeyPerson.put(accObj.Pan_Number__c, accObj);
                            }
                        }
                    }
                }
                for (cls_Key_Person_Details Kpd: listKeyPersonWrp) {
                    
                    Account keyPersonObj = new Account();
                    
                    If(Kpd != null) {
                        If(!Utility.ISStringBlankorNull(Kpd.Name))
                            keyPersonObj.LastName = Kpd.Name;
                        If(!Utility.ISStringBlankorNull(Kpd.Customer_ID))
                            keyPersonObj.CBS_Customer_ID__c = Kpd.Customer_ID;
                        If(!Utility.ISStringBlankorNull(Kpd.Passport_No))
                            keyPersonObj.Passport_Number__pc = Kpd.Passport_No;
                        If(!Utility.ISStringBlankorNull(Kpd.Nationality))
                            keyPersonObj.Nationality__pc = Kpd.Nationality;
                        If(!Utility.ISStringBlankorNull(Kpd.PAN))
                            keyPersonObj.Pan_Number__c = Kpd.PAN;
                        If(!Utility.ISStringBlankorNull(Kpd.Aadhaar_Number)) {
                            
                            keyPersonObj.Aadhaar_Number__pc = Kpd.Aadhaar_Number;
                            If(!Utility.ISStringBlankorNull(Kpd.Party_Type))
                                mapOfString.put(Kpd.Aadhaar_Number, Kpd.Party_Type);
                        }
                        If(!Utility.ISStringBlankorNull(Kpd.Date_Of_Birth))
                            keyPersonObj.PersonBirthdate = Date.parse(Kpd.Date_Of_Birth);
                        If(!Utility.ISStringBlankorNull(Kpd.Gender))
                            keyPersonObj.Gender__pc = Kpd.Gender;
                        If(!Utility.ISStringBlankorNull(Kpd.Phone))
                            keyPersonObj.PersonMobilePhone = Kpd.Phone;
                        If(!Utility.ISStringBlankorNull(Kpd.Email))
                            keyPersonObj.PersonEmail = Kpd.Email;
                        If(Kpd.Registered_Address != null) {
                            WS_FetchSMEInfo_Helper.Registered_Address registeredObj = Kpd.Registered_Address;
                            If(registeredObj != null) {
                                If(!Utility.ISStringBlankorNull(registeredObj.Address))
                                    keyPersonObj.PersonMailingStreet = registeredObj.Address;
                                If(!Utility.ISStringBlankorNull(registeredObj.City))
                                    keyPersonObj.PersonMailingCity = registeredObj.City;
                                If(!Utility.ISStringBlankorNull(registeredObj.State))
                                    keyPersonObj.PersonMailingState = registeredObj.State;
                                If(!Utility.ISStringBlankorNull(registeredObj.Country))
                                    keyPersonObj.PersonMailingCountry = registeredObj.Country;
                                If(!Utility.ISStringBlankorNull(registeredObj.PostalCode))
                                    keyPersonObj.PersonMailingPostalCode = registeredObj.PostalCode;
                            }
                            
                        }
                        if (userId != null && userId != '') {
                            keyPersonObj.OwnerId = (id) userId;
                        }
                        if (mapOfExistingKeyPerson != null && mapOfExistingKeyPerson.size() > 0) {
                            if (Kpd.Aadhaar_Number !=null && Kpd.Aadhaar_Number != '' && mapOfExistingKeyPerson.containsKey(Kpd.Aadhaar_Number)) {
                                keyPersonObj.Id = mapOfExistingKeyPerson.get(Kpd.Aadhaar_Number).Id;
                                isNewKeyPerson = false;
                                
                                updateKeyPerson.add(keyPersonObj);
                            } else if(Kpd.PAN !=null && Kpd.PAN !='' && mapOfExistingKeyPerson.containsKey(Kpd.PAN)) {
                                keyPersonObj.Id = mapOfExistingKeyPerson.get(Kpd.PAN).Id;
                                isNewKeyPerson = false;
                                
                                updateKeyPerson.add(keyPersonObj);
                            }
                        } else if (isNewKeyPerson) {
                            keyPersonObj.RecordTypeId = devRecordTypeId;
                            listKeyPerson.add(keyPersonObj);
                        }
                        
                    }
                }
                
            }
            If(listKeyPerson.size() > 0) {
                If(Type != null && Type != '' && Type != 'NTB') {
                    AccountTriggerHandler.isAccountTrigger = false;
                    upsert listKeyPerson CBS_Customer_ID__c;
                } else if (Type != null && Type != '' && Type == 'NTB') {
                    AccountTriggerHandler.isAccountTrigger = false;
                    insert listKeyPerson;
                    for (Account accObj: listKeyPerson) {
                        accObj.CBS_Customer_ID__c = accObj.id;
                        updateKeyPerson.add(accObj);
                    }
                    //update listKeyPerson;
                }
            }
            If(updateKeyPerson != null && updateKeyPerson.size() > 0) {
                System.debug('updateKeyPerson======> 1 '+updateKeyPerson);

                AccountTriggerHandler.isAccountTrigger = false;
                map<Id,Account> accMap= new map<Id,Account>();
                for(Account acc: updateKeyPerson){
                    accMap.put(acc.Id,acc);
                }
                System.debug('updateKeyPerson======> 2 '+accMap.values());
                if(accMap.size()>0) update accMap.values();//update updateKeyPerson;
            }
            If(listKeyPerson.size() > 0) {
                for (Account acc: listKeyPerson) {
                    genesis__Application_Parties__c newPartiesObj = new genesis__Application_Parties__c();
                    newPartiesObj.genesis__Application__c = (Id) appId;
                    newPartiesObj.Key_Contact__r = new Account(CBS_Customer_ID__c = Customer_ID);
                    newPartiesObj.genesis__Party_Account_Name__c = acc.id;
                    newPartiesObj.Active__c = true;
                    newPartiesObj.Signatories__c = true;
                    newPartiesObj.Product_Type__c = 'SME';
                    newPartiesObj.External_ID__c = Customer_ID+'@'+acc.CBS_Customer_ID__c+'@'+appId;
                    If(!Utility.ISStringBlankorNull(mapOfString.get(acc.Aadhaar_Number__pc)))
                        newPartiesObj.genesis__Party_Type__c = mapOfString.get(acc.Aadhaar_Number__pc);
                    
                    if (userId != null && userId != '') {
                        newPartiesObj.OwnerId = (id) userId;
                    }
                    listOfParties.add(newPartiesObj);
                }
            }
            If(updateKeyPerson.size() > 0) {
                for (Account acc: updateKeyPerson) {
                    genesis__Application_Parties__c newPartiesObj = new genesis__Application_Parties__c();
                    newPartiesObj.genesis__Application__c = (Id) appId;
                    newPartiesObj.Key_Contact__r = new Account(CBS_Customer_ID__c = Customer_ID);
                    newPartiesObj.genesis__Party_Account_Name__c = acc.id;
                    newPartiesObj.Active__c = true;
                    newPartiesObj.Signatories__c = true;
                    newPartiesObj.Product_Type__c = 'SME';
                    newPartiesObj.External_ID__c = Customer_ID+'@'+acc.CBS_Customer_ID__c+'@'+appId;//'@SME_NEW_Loan';
                    If(!Utility.ISStringBlankorNull(mapOfString.get(acc.Aadhaar_Number__pc)))
                        newPartiesObj.genesis__Party_Type__c = mapOfString.get(acc.Aadhaar_Number__pc);
                    
                    if (userId != null && userId != '') {
                        newPartiesObj.OwnerId = (id) userId;
                    }
                    listOfParties.add(newPartiesObj);
                }
            }
            If(listOfParties.size() > 0) {
                /*map<String,genesis__Application_Parties__c> partyMap= new map<String,genesis__Application_Parties__c>();
                System.debug('insertParties======> 1 '+listOfParties);
                for(genesis__Application_Parties__c prt: listOfParties){
                    partyMap.put(prt.genesis__Application__c,prt);
                }
                System.debug('insertParties======> 2 '+partyMap.values());
                if(partyMap.size()>0) insert partyMap.values();*/ 
                System.debug('insertParties======> 1 '+listOfParties);
                insert listOfParties;
            }
        }
        
    }
    @future(callout = true)
    public static void callOperationaData_API(String custId) {
        WS_NewLoan_OperationalData.getRequest(custId);
    }
    /*Term Loan V1- Start*/
    public static List<Facility__c> createORupdateFaciCollatAppCollat(List<WS_FetchSMEInfo_Helper.cls_FACILITY_DETAILS> facilityWrpList,String appId){
        map<String, Facility__c> faciMapwithAccNumber;//= SOQL_Util.faciMapwithACnumber();
        List<Facility__c> toBeUpsertFaciLst= new List<Facility__c>();
        List<clcommon__Collateral__c> toBeUpsertCollatLst= new List<clcommon__Collateral__c>();
        List<genesis__Application_Collateral__c> toBeUpsertAppCollatLst= new List<genesis__Application_Collateral__c>();
        
        List<Facility__c> toBeInsertFaciLst= new List<Facility__c>();
        List<Facility__c> toBeUpdateFaciLst= new List<Facility__c>();
        Set<String> newAccountNoSet= new Set<String>();
        Set<String> AllAccountNoSet= new Set<String>();
        for(cls_FACILITY_DETAILS faciWrp: facilityWrpList){
            AllAccountNoSet.add(faciWrp.Account_Number);
        }
        if(AllAccountNoSet.size()>0){
            faciMapwithAccNumber= SOQL_Util.faciMapwithACnumber(AllAccountNoSet);
        }

        for(cls_FACILITY_DETAILS faciWrp: facilityWrpList){
            String faciExternalId= faciWrp.Account_Number+'@'+appId;
            Facility__c faci= new Facility__c();
            //faci.Limit_end_date__c= faciWrp.Date_Of_Maturity; formula field
            //faci.Product_Name__c= faciWrp.Product_Name;
            If(!Utility.ISStringBlankorNull(faciWrp.Amt_Disbursed))
                faci.Amount_Disbursed__c= decimal.valueof(faciWrp.Amt_Disbursed);
            //faci.Limit_Amount__c= faciWrp.Amt_Face_Value;   formula field
            If(!Utility.ISStringBlankorNull(faciWrp.Tenor))
                faci.Tenure__c= decimal.valueof(faciWrp.Tenor);
            If(!Utility.ISStringBlankorNull(faciWrp.Bal_Book))
                faci.Balance_Outstandings__c= decimal.valueof(faciWrp.Bal_Book);
            //faci.Limit_start_date__c= faciWrp.Date_Of_AccountOpen; formula filed
            If(!Utility.ISStringBlankorNull(faciWrp.Amt_Net_Disbursed))
                faci.Amount_Net_Disbursed__c= decimal.valueof(faciWrp.Amt_Net_Disbursed);
            If(!Utility.ISStringBlankorNull(faciWrp.Holiday_Period))
                faci.Holiday_Period__c= decimal.valueof(faciWrp.Holiday_Period);

            faci.Application__c= appId;
            faci.Account_Number__c= faciWrp.Account_Number;
            faci.External_Id__c= faciExternalId;
            toBeUpsertFaciLst.add(faci);

            for(cls_COLLATERAL_DETAILS collaWrp: faciWrp.COLLATERAL_DETAILS){
                String collatExternalId= collaWrp.Collatera_Id;
                clcommon__Collateral__c colla= new clcommon__Collateral__c();
                colla.Total_Survery_Number__c= collaWrp.Tot_Survery_Number;
                colla.District_Name__c= collaWrp.District_Name;
                colla.Valuer_Name__c= collaWrp.Valuer_Name;
                colla.Asset_ID__c= collaWrp.Cersai_Asset_Id;
                If(!Utility.ISStringBlankorNull(collaWrp.Latitude))
                    colla.Latitude__c= Decimal.valueOf(collaWrp.Latitude);
                If(!Utility.ISStringBlankorNull(collaWrp.Carpet_Area))
                    colla.Carpet_Area__c= Decimal.valueOf(collaWrp.Carpet_Area);
                If(!Utility.ISStringBlankorNull(collaWrp.Em_Date))
                    colla.EM_Date__c= Date.parse(collaWrp.Em_Date);
                colla.DOC_TYPE__c= collaWrp.Document_Type;
                colla.Door__c= collaWrp.Door_Number;
                colla.clcommon__Postal_Code__c= collaWrp.PinCode;
                If(!Utility.ISStringBlankorNull(collaWrp.Legal_Opinion_Date))
                    colla.Legal_Opinion_Date__c= Date.parse(collaWrp.Legal_Opinion_Date);
                colla.Ownership_Type__c= collaWrp.Ownership_Type;
                colla.Valuer_Identity__c= collaWrp.Valuer_Identity;
                colla.clcommon__City__c= collaWrp.City_Town;
                colla.State__c= collaWrp.State_Name;
                colla.Cersai_Security_Id__c= collaWrp.Cersai_Security;
                If(!Utility.ISStringBlankorNull(collaWrp.Valuation_Date))
                    colla.Valuation_Date__c= Date.parse(collaWrp.Valuation_Date);
                If(!Utility.ISStringBlankorNull(collaWrp.Document_Date))
                    colla.Document_Date__c= Date.parse(collaWrp.Document_Date);
                colla.Floor_No__c= collaWrp.Floor_Number;
                //colla.clcommon__Account_Number__c= collaWrp.Account_Number;
                If(!Utility.ISStringBlankorNull(collaWrp.Cersai_Reg_Date))
                    colla.Cersai_Registration_Date__c= Date.parse(collaWrp.Cersai_Reg_Date);
                colla.Building_Name__c= collaWrp.Building_Name;
                If(!Utility.ISStringBlankorNull(collaWrp.No_Of_Joint_Owners))
                colla.Number_of_joint_owners__c= Decimal.valueOf(collaWrp.No_Of_Joint_Owners);
                //colla.vlookup= collaWrp.Branch_Code;
                colla.Advocate_Name__c= collaWrp.Advocate_Name;
                colla.TalukaTehsil__c= collaWrp.Taluk_Name;
                colla.SRN_Number__c= collaWrp.Srn_Number;
                colla.Street_NameNo__c= collaWrp.Street_Name;
                colla.Landmark__c= collaWrp.Landmark;
                colla.SRO__c= collaWrp.Sro_Name;
                If(!Utility.ISStringBlankorNull(collaWrp.Tot_Asset_Value))
                    colla.clcommon__Value__c= Decimal.valueOf(collaWrp.Tot_Asset_Value);
                If(!Utility.ISStringBlankorNull(collaWrp.Longitude))
                    colla.Longitude__c= Decimal.valueOf(collaWrp.Longitude);
                If(!Utility.ISStringBlankorNull(collaWrp.Land_Value))
                    colla.Land_Value__c= Decimal.valueOf(collaWrp.Land_Value);
                colla.Nature_of_Property__c= collaWrp.Nature_Of_Property;
                colla.PlotDoorShopBungalow_No__c= collaWrp.Plot_Number;
                If(!Utility.ISStringBlankorNull(collaWrp.EC_Date))
                    colla.EC_Date__c= Date.parse(collaWrp.EC_Date);
                //colla.Customer_id__c= collaWrp.Cust_Id;
                If(!Utility.ISStringBlankorNull(collaWrp.Srn_Date_Mca))    
                    colla.SRN_Date__c= Date.parse(collaWrp.Srn_Date_Mca);
                If(!Utility.ISStringBlankorNull(collaWrp.Building_Value)) 
                    colla.Building_Value__c= Decimal.valueOf(collaWrp.Building_Value);
                colla.Advocate_Identity__c= collaWrp.Advocate_Identity;
                If(!Utility.ISStringBlankorNull(collaWrp.Builtup_Area)) 
                    colla.Buildup_Area__c= Decimal.valueOf(collaWrp.Builtup_Area);
                colla.Document_Number__c= collaWrp.Document_No;
                colla.MORT_TYPE__c= collaWrp.Mortgage_Type;
                If(!Utility.ISStringBlankorNull(collaWrp.Area_Sqft)) 
                    colla.Area_Square_Feet__c= Decimal.valueOf(collaWrp.Area_Sqft);
                colla.Stage_Sector_Ward_Block_No__c= collaWrp.Block_Ward_No;

                colla.clcommon__Collateral_Name__c= collaWrp.Collatera_Id;
                colla.External_ID__c= collaWrp.Collatera_Id;
                toBeUpsertCollatLst.add(colla);

                genesis__Application_Collateral__c appCollat= new genesis__Application_Collateral__c();
                appCollat.Facility__r= new Facility__c(External_Id__c= faciExternalId);
                appCollat.genesis__Collateral__r= new clcommon__Collateral__c(External_Id__c= collatExternalId);
                appCollat.External_Id__c= faciExternalId+'@'+collatExternalId;
                appCollat.Application__c= appId;
                toBeUpsertAppCollatLst.add(appCollat);


            }    
        }
        if(toBeUpsertFaciLst.size()>0) UPSERT toBeUpsertFaciLst External_Id__c;
        if(toBeUpsertCollatLst.size()>0){
            map<String,clcommon__Collateral__c> colatMapValues= new map<String,clcommon__Collateral__c>();
           for(clcommon__Collateral__c coll:toBeUpsertCollatLst){
                colatMapValues.put(coll.clcommon__Collateral_Name__c,coll);
           } 
         if(colatMapValues.size()>0) UPSERT colatMapValues.values() External_Id__c;
        }
        if(toBeUpsertAppCollatLst.size()>0) UPSERT toBeUpsertAppCollatLst External_Id__c;

        
        return null;
    }
    
    /*Term Loan V1- End*/
    
}