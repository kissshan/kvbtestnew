/*
* @name         : SME_CBS_Handler
@description  : CBS callouts handler(SME)
@author       : Dushyant
*/
public class SME_CBS_Handler { 
    Public static Decimal leagalFee       = 0.0;
    public static Decimal cersaiCharge    = 0.0;
    public static Decimal valuationCharge = 0.0;
    public static Decimal stampFeeCharge  = 0;
    public static void eKYC_Updation(List<Id> updatedAppIdList){ 
        
        List<genesis__Applications__c> updatedAppList = new List<genesis__Applications__c>();
        List<genesis__Applications__c> appListToUpdate = new List<genesis__Applications__c>();
        updatedAppList = [SELECT Id,(SELECT Id,Is_New__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c,genesis__Party_Account_Name__c,
                                     genesis__Party_Account_Name__r.Branch_Code__c,genesis__Party_Account_Name__r.Customer_IC__c,
                                     genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.Voter_Id__c,
                                     genesis__Party_Account_Name__r.Passport_Number__pc,genesis__Party_Account_Name__r.Driving_License_ID__c,
                                     genesis__Party_Account_Name__r.National_Identification_Code__c,genesis__Party_Account_Name__r.Other_identification_number__c,
                                     genesis__Party_Account_Name__r.CreatedDate,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,
                                     genesis__Party_Account_Name__r.Telephone_Bill__c,genesis__Party_Account_Name__r.Ration_Card__c,
                                     genesis__Party_Account_Name__r.Employment_Letter__c,genesis__Party_Account_Name__r.Same_Present_Address_Permanent_Address__c,
                                     genesis__Party_Account_Name__r.Bank_Statement__c,genesis__Party_Account_Name__r.Annual_TurnoverIncome__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc FROM genesis__Application_Parties__r WHERE Active__c = true) FROM genesis__Applications__c WHERE Id IN :updatedAppIdList];
        Boolean partyFlag = false;
        for(genesis__Applications__c app : updatedAppList){
            if(!app.genesis__Application_Parties__r.isEmpty()){
                CBS_eKYC_Creation_Handler cbs = new CBS_eKYC_Creation_Handler();
                cbs.exe_tenantId = 'cuecent_tenant';
                cbs.owner_tenantId = 'cuecent_tenant';
                cbs.inputVariables = new CBS_eKYC_Creation_Handler.cls_inputVariables();
                cbs.inputVariables.in_msg = new CBS_eKYC_Creation_Handler.cls_in_msg();
                cbs.inputVariables.in_msg.ApplicationId = app.Id;
                cbs.inputVariables.in_msg.serviceName = 'EKYCUpdation_HL';
                cbs.inputVariables.in_msg.EKYCDetails = new List<CBS_eKYC_Creation_Handler.EKYCDetails>();
                for(genesis__Application_Parties__c party : app.genesis__Application_Parties__r){
                    if(party.Is_New__c && party.genesis__Party_Account_Name__r.CBS_Customer_ID__c == null){
                        partyFlag = true;
                        string aadharcardNo = WS_getAadharNo.getAadharNo(party.genesis__Party_Account_Name__r.Aadhaar_Number__pc); //'499118665246';
                        
                        CBS_eKYC_Creation_Handler.EKYCDetails rq = new CBS_eKYC_Creation_Handler.EKYCDetails();
                        if(aadharcardNo.isNumeric() == True){
                            rq.CodCustUniqueId = aadharcardNo;
                        }else{
                            rq.CodCustUniqueId = '';
                        } 
                        //rq.CodCustUniqueId = '772267219669';//Temp....Remove after testing
                        rq.ApplicantID = party.genesis__Party_Account_Name__c != null ? party.genesis__Party_Account_Name__c : '';
                        rq.PrimaryPassword ='';  
                        rq.BankCode ='53';  
                        rq.ExternalBatchNumber ='';  
                        rq.ExternalReferenceNo =''; 
                        rq.ExternalSystemAuditTrailNumber ='';  
                        rq.LocalDateTimeText ='';  
                        rq.OriginalReferenceNo ='';  
                        rq.OverridenWarnings ='';  
                        rq.PostingDateText ='';  
                        rq.ServiceCode ='';  
                        rq.SessionTicket ='';  
                        rq.TransactionBranch = party.genesis__Party_Account_Name__r.Branch_Code__c != null ? party.genesis__Party_Account_Name__r.Branch_Code__c : '';  
                        rq.UserId ='System01';
                        rq.UserReferenceNumber ='';
                        rq.ValueDateText =party.genesis__Party_Account_Name__r.CreatedDate != null ? Date.valueOf(party.genesis__Party_Account_Name__r.CreatedDate).format() : '';  
                        rq.CodCustIc = party.genesis__Party_Account_Name__r.Customer_IC__c != null ? party.genesis__Party_Account_Name__r.Customer_IC__c : '';  
                        rq.FlgCustTyp ='RESIDENT INDIAN';
                        rq.CodCustId = '0';
                        //rq.CodCustUniqueId = party.genesis__Party_Account_Name__r.Aadhaar_Number__pc != null ? party.genesis__Party_Account_Name__r.Aadhaar_Number__pc : '';
                        rq.FlgPanCard = party.genesis__Party_Account_Name__r.Pan_Number__c != null ? 'Y':'N';
                        rq.CodPanCard = party.genesis__Party_Account_Name__r.Pan_Number__c != null ? party.genesis__Party_Account_Name__r.Pan_Number__c : '';  
                        rq.FlgVoterId = party.genesis__Party_Account_Name__r.Voter_Id__c != null ? 'Y':'N';
                        rq.CodVoterId = party.genesis__Party_Account_Name__r.Voter_Id__c != null ? party.genesis__Party_Account_Name__r.Voter_Id__c : '';  
                        rq.FlgPassport = party.genesis__Party_Account_Name__r.Passport_Number__pc != null ? 'Y':'N';
                        rq.CodPassport = party.genesis__Party_Account_Name__r.Passport_Number__pc != null ? party.genesis__Party_Account_Name__r.Passport_Number__pc : '';  
                        rq.FlgDriveLiscense = party.genesis__Party_Account_Name__r.Driving_License_ID__c != null ? 'Y':'N';
                        rq.CodDriveLiscense = party.genesis__Party_Account_Name__r.Driving_License_ID__c != null ? party.genesis__Party_Account_Name__r.Driving_License_ID__c : ''; 
                        rq.FlgNatIdCard = party.genesis__Party_Account_Name__r.National_Identification_Code__c != null ? 'Y':'N';
                        rq.CodNatIdCard = party.genesis__Party_Account_Name__r.National_Identification_Code__c != null ? party.genesis__Party_Account_Name__r.National_Identification_Code__c : '';  
                        rq.FlgLetterRecogAuth ='N';  
                        rq.CodLetterRecogAuth =''; 
                        rq.FlgOthers = party.genesis__Party_Account_Name__r.Other_identification_number__c != null ? 'Y':'N';
                        rq.CodOthers = party.genesis__Party_Account_Name__r.Other_identification_number__c != null ?party.genesis__Party_Account_Name__r.Other_identification_number__c : '';  
                        rq.FlgPhotoObtained ='Y';  
                        rq.DatPhotoObtained = party.genesis__Party_Account_Name__r.CreatedDate != null ? Date.valueOf(party.genesis__Party_Account_Name__r.CreatedDate).format() : '';  
                        rq.DatCustIdData = party.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c != null ? Date.valueOf(party.genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c).format() : '';
                        rq.CodCustRiskCat ='2';  
                        rq.DatRiskCatReview =party.genesis__Party_Account_Name__r.CreatedDate != null ? Date.valueOf(party.genesis__Party_Account_Name__r.CreatedDate).format() : '';  
                        rq.CodReasonRiskCat ='';
                        rq.FlgTeleBillIndiv = party.genesis__Party_Account_Name__r.Telephone_Bill__c != null ? 'Y':'N';
                        rq.FlgTelephoneBillComp ='N';
                        rq.FlgLtrRcgAuthInd ='N';  
                        rq.FlgElecBillIndiv ='N';
                        rq.FlgRationCardIndiv = party.genesis__Party_Account_Name__r.Ration_Card__c != null ? 'Y':'N'; 
                        rq.FlgEmpLetterIndiv = party.genesis__Party_Account_Name__r.Employment_Letter__c != null ? 'Y':'N';
                        rq.CodOtherDocindiv ='2'; 
                        rq.FlgSameIdProofIndiv = party.genesis__Party_Account_Name__r.Same_Present_Address_Permanent_Address__c != null ? 'Y':'N';
                        rq.FlgIncorpCertifComp ='N';  
                        rq.FlgMoaComp ='N';  
                        rq.FlgAoaComp ='N';  
                        rq.FlgBodResolutionComp ='N';  
                        rq.FlgPoaDocumentComp ='N';
                        rq.FlgBankStmtIndiv = party.genesis__Party_Account_Name__r.Bank_Statement__c != null ? 'Y':'N';
                        rq.FlgPancrdAltLetComp ='N';  
                        rq.CodOtherDocComp ='2';  
                        rq.FlgRegisterCertifPf ='N';  
                        rq.FlgPartnershipDeedPf ='N';  
                        rq.FlgPoaDocumentPf ='N';  
                        rq.CodOffValidDocPf ='';  
                        rq.FlgTelephoneBillPf ='N';  
                        rq.FlgRegisterCertifTf ='N';  
                        rq.FlgPoaDocumentTf ='N';  
                        rq.CodOffValidDocTf ='';  
                        rq.FlgResolMangBodyTf ='N';  
                        rq.FlgTelephoneBillTf ='N';  
                        rq.FlgTelBillOthers ='N';  
                        rq.FlgElecBillOthers ='N';  
                        rq.FlgRegCertifOthers ='';  
                        rq.CodOtherDocOthers ='';  
                        rq.ThresholdPct ='100';  
                        rq.FlgThresholdAlert ='Y';  
                        rq.AnualTurnOver = party.genesis__Party_Account_Name__r.Annual_TurnoverIncome__c != null ? String.valueOf(party.genesis__Party_Account_Name__r.Annual_TurnoverIncome__c) : '1000';
                        rq.FormStatus ='';  
                        rq.FlgEkyc ='Y';  
                        string uniqueno = CreateUniqueId.uniqID();
                        string regex = '[a-zA-Z]{1,}|\\-';
                        String unique = uniqueno.replaceAll(regex, '');
                        rq.EkycRefNo = unique.subString(0,9);
                        rq.channel ='';
                        cbs.inputVariables.in_msg.EKYCDetails.add(rq);
                    }
                } 
                if(partyFlag){
                    update_eKYC_CallOut(JSON.serialize(cbs),app.Id);
                }
                else{
                    genesis__Applications__c appToUpdate = new genesis__Applications__c();
                    appToUpdate.Id = app.Id;
                    appListToUpdate.add(appToUpdate);
                }
                partyFlag = false;
            }
        }
        if(!appListToUpdate.isEmpty()) UPDATE appListToUpdate;
    }
    //Structure formation for Customer Id creation
    public static void customerIdCreation(List<Id> updateAppIdList){
        List<genesis__Applications__c> updatedAppList = new List<genesis__Applications__c>();
        updatedAppList = [SELECT Id,(SELECT Id,Is_New__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c,genesis__Party_Account_Name__c,
                                     genesis__Party_Account_Name__r.Branch_Code__c,genesis__Party_Account_Name__r.Customer_IC__c,
                                     genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.Voter_Id__c,
                                     genesis__Party_Account_Name__r.Passport_Number__pc,genesis__Party_Account_Name__r.Driving_License_ID__c,
                                     genesis__Party_Account_Name__r.National_Identification_Code__c,genesis__Party_Account_Name__r.Other_identification_number__c,
                                     genesis__Party_Account_Name__r.CreatedDate,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,
                                     genesis__Party_Account_Name__r.Telephone_Bill__c,genesis__Party_Account_Name__r.Ration_Card__c,
                                     genesis__Party_Account_Name__r.Employment_Letter__c,genesis__Party_Account_Name__r.Same_Present_Address_Permanent_Address__c,
                                     genesis__Party_Account_Name__r.Bank_Statement__c,genesis__Party_Account_Name__r.Annual_TurnoverIncome__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc, 
                                     genesis__Party_Account_Name__r.Husband_Name__pc,genesis__Party_Account_Name__r.Customer_Type__c,genesis__Party_Account_Name__r.PersonBirthdate,genesis__Party_Account_Name__r.Gender__pc,
                                     genesis__Party_Account_Name__r.Salutation,genesis__Party_Account_Name__r.Father_Name__pc,genesis__Party_Account_Name__r.Name,
                                     genesis__Party_Account_Name__r.Spouse_Name__pc,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.LastName,genesis__Party_Account_Name__r.PersonOtherStreet,
                                     genesis__Party_Account_Name__r.PersonOtherCity,genesis__Party_Account_Name__r.PersonEmail,
                                     genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.PersonOtherPostalCode,
                                     genesis__Party_Account_Name__r.PersonOtherState,genesis__Party_Account_Name__r.Marital_Status__pc,genesis__Party_Account_Name__r.MiddleName,
                                     genesis__Party_Account_Name__r.PersonOtherCountry,
                                     genesis__Party_Account_Name__r.Nationality__pc,genesis__Party_Account_Name__r.CBS_Prof_Code__C FROM genesis__Application_Parties__r WHERE Active__c = true) 
                          FROM genesis__Applications__c WHERE Id IN :updateAppIdList];
        
        for(genesis__Applications__c app : updatedAppList){
            if(!app.genesis__Application_Parties__r.isEmpty()){
                CBS_CustomerID_Creation_Handler cbs = new CBS_CustomerID_Creation_Handler();
                cbs.InputVariables  = new CBS_CustomerID_Creation_Handler.cls_inputVariables();
                CBS_CustomerID_Creation_Handler.cls_inputVariables cbsID = new CBS_CustomerID_Creation_Handler.cls_inputVariables();        
                cbsID.in_msg = new CBS_CustomerID_Creation_Handler.cls_in_msg();
                cbs.InputVariables=cbsID;        
                cbsID.in_msg.ApplicationId = app.Id;
                cbsID.in_msg.serviceName = 'Customer_ID_Creation_HL';
                cbsID.in_msg.CustIDDetails = new List<CBS_CustomerID_Creation_Handler.cls_CustIDDetails>(); 
                
                for(genesis__Application_Parties__c party : app.genesis__Application_Parties__r){
                    if(party.Is_New__c && party.genesis__Party_Account_Name__r.CBS_Customer_ID__c == null){
                        CBS_CustomerID_Creation_Handler.cls_CustIDDetails rq = new CBS_CustomerID_Creation_Handler.cls_CustIDDetails();
                        rq.TransactionBranch = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Branch_Code__c) ? '' : party.genesis__Party_Account_Name__r.Branch_Code__c;
                        rq.DOB = Utility.ISStringBlankorNull(String.ValueOf(party.genesis__Party_Account_Name__r.PersonBirthdate)) ? '' : party.genesis__Party_Account_Name__r.PersonBirthdate.format();
                        rq.NRICity = '';
                        rq.NRIState = '';
                        rq.busnstyp = '';
                        rq.codCustIc = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Customer_IC__c) ? '' : party.genesis__Party_Account_Name__r.Customer_IC__c.toUpperCase();
                        rq.countryResidence = 'IN';
                        rq.custtyp = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Customer_Type__c) ? '' : party.genesis__Party_Account_Name__r.Customer_Type__c;
                        rq.empId = '';
                        rq.fathername = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Father_Name__pc) ? '' : party.genesis__Party_Account_Name__r.Father_Name__pc;
                        rq.firstName = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.FirstName) ? '' : party.genesis__Party_Account_Name__r.FirstName;
                        rq.flgStaff = 'N';
                        rq.fullName =Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Name) ? '' : party.genesis__Party_Account_Name__r.Name;
                        rq.gender = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Gender__pc) ? '' : party.genesis__Party_Account_Name__r.Gender__pc;
                        rq.husbandname = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Husband_Name__pc) ? '' : party.genesis__Party_Account_Name__r.Husband_Name__pc;
                        rq.introId = '';
                        rq.introcat = '1';
                        rq.lang = 'Eng';
                        rq.lastName = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.LastName) ? '' : party.genesis__Party_Account_Name__r.LastName;
                        rq.mailAddr1 = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonOtherStreet) ? '' : party.genesis__Party_Account_Name__r.PersonOtherStreet;
                        rq.mailAddr2 = '.';
                        rq.mailAddr3 = '.';
                        rq.mailCity = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonOtherCity) ? '' : party.genesis__Party_Account_Name__r.PersonOtherCity;
                        rq.mailCtry = queryService.getCode(party.genesis__Party_Account_Name__r.PersonOtherCountry,'1');//Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonOtherCountry) ? '' : party.genesis__Party_Account_Name__r.PersonOtherCountry;
                        rq.mailEmail = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonEmail) ? '' : party.genesis__Party_Account_Name__r.PersonEmail;
                        rq.mailMobno = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonMobilePhone) ? '' : party.genesis__Party_Account_Name__r.PersonMobilePhone;
                        rq.mailPhRes = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Phone) ? '' : party.genesis__Party_Account_Name__r.Phone;
                        rq.mailPin = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonOtherPostalCode) ? '' : party.genesis__Party_Account_Name__r.PersonOtherPostalCode;
                        rq.mailState = queryService.getCode(party.genesis__Party_Account_Name__r.PersonOtherState,'2');//Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.PersonOtherState) ? '' : party.genesis__Party_Account_Name__r.PersonOtherState;
                        rq.maritalStatus = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Marital_Status__pc) ? 'Married' : party.genesis__Party_Account_Name__r.Marital_Status__pc;
                        rq.middleName = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.MiddleName) ? '' : party.genesis__Party_Account_Name__r.MiddleName;
                        rq.namePrefix = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Salutation) ? '' : party.genesis__Party_Account_Name__r.Salutation.replace('.','');
                        rq.nationality = queryService.getCode(party.genesis__Party_Account_Name__r.Nationality__pc,'1');
                        rq.nonCustType = '8';
                        rq.nonCustdtls = 'KYC Provided';
                        rq.proffCode = party.genesis__Party_Account_Name__r.CBS_Prof_Code__C;
                        rq.shrtName = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Name) ? '' : party.genesis__Party_Account_Name__r.Name;
                        rq.spousename = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.Spouse_Name__pc) ? '' : party.genesis__Party_Account_Name__r.Spouse_Name__pc;
                        rq.ApplicantID = party.genesis__Party_Account_Name__c;
                        cbsID.in_msg.CustIDDetails.add(rq);
                    }
                }
                customerIdCreationCallOut(JSON.serialize(cbs),app.Id); 
            }
        }
    }
    //Helper method to make callout for CustomerId Creation
    @future(callout = true)
    public static void customerIdCreationCallOut(String custData,String appId){
        system.debug('####'+custData);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Bulk_API');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,custData,headerMap,label.CA_CERTIFICATE);
        system.debug('$$$$'+response.getBody());
        If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();            
            CBS_CustomerID_Creation_Handler.CBS_CustomerID_Creation_response res = (CBS_CustomerID_Creation_Handler.CBS_CustomerID_Creation_response)Json.deserialize(jsonString,CBS_CustomerID_Creation_Handler.CBS_CustomerID_Creation_response.class);
            System.debug(res);
            if(res.out_msg.Status_Desc != 'Success'){
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'Customer_ID_Creation_SME';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = res.out_msg.Status_Desc;
                log.Sequence_No__c = '3';  
                insert log; 
            }      
        }else{
            CBS_API_Log__c log = new CBS_API_Log__c();    
            log.Application__c = AppId;
            log.API_Name__c = 'Customer_ID_Creation_SME';
            log.Status__c = 'Failure';
            log.Success_Error_Message__c = 'CustomerIdCreation_CBS_Error_No_Hit';
            log.Sequence_No__c = '3';  
            insert log;             
        }
    }
    //Structure formation for Customer Linkage
    public static void customerLinkage(List<Id> updateAppIdList){
        String relTypeCode;
        List<genesis__Applications__c> updatedAppList = new List<genesis__Applications__c>();
        updatedAppList = [SELECT Id,Branch_Name__c,(SELECT Id,Account_Number__c FROM Facilities__r WHERE Type__c = 'Funded'),(SELECT Id,genesis__Party_Type__c,Is_New__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c,genesis__Party_Account_Name__c,
                                                                                                                              genesis__Party_Account_Name__r.Branch_Code__c,genesis__Party_Account_Name__r.Customer_IC__c,
                                                                                                                              genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.Voter_Id__c,
                                                                                                                              genesis__Party_Account_Name__r.Passport_Number__pc,genesis__Party_Account_Name__r.Driving_License_ID__c,
                                                                                                                              genesis__Party_Account_Name__r.National_Identification_Code__c,genesis__Party_Account_Name__r.Other_identification_number__c,
                                                                                                                              genesis__Party_Account_Name__r.CreatedDate,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,
                                                                                                                              genesis__Party_Account_Name__r.Telephone_Bill__c,genesis__Party_Account_Name__r.Ration_Card__c,
                                                                                                                              genesis__Party_Account_Name__r.Employment_Letter__c,genesis__Party_Account_Name__r.Same_Present_Address_Permanent_Address__c,
                                                                                                                              genesis__Party_Account_Name__r.Bank_Statement__c,genesis__Party_Account_Name__r.Annual_TurnoverIncome__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc, 
                                                                                                                              genesis__Party_Account_Name__r.Husband_Name__pc,genesis__Party_Account_Name__r.Customer_Type__c,genesis__Party_Account_Name__r.PersonBirthdate,genesis__Party_Account_Name__r.Gender__pc,
                                                                                                                              genesis__Party_Account_Name__r.Salutation,genesis__Party_Account_Name__r.Father_Name__pc,genesis__Party_Account_Name__r.Name,
                                                                                                                              genesis__Party_Account_Name__r.Spouse_Name__pc,genesis__Party_Account_Name__r.AccountNumber,genesis__Party_Account_Name__r.FirstName,genesis__Party_Account_Name__r.LastName,genesis__Party_Account_Name__r.PersonOtherStreet,genesis__Party_Account_Name__r.PersonOtherCity,genesis__Party_Account_Name__r.PersonOtherCountry,genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.PersonMobilePhone,genesis__Party_Account_Name__r.Phone,genesis__Party_Account_Name__r.PersonOtherPostalCode,genesis__Party_Account_Name__r.PersonOtherState,genesis__Party_Account_Name__r.Marital_Status__pc,genesis__Party_Account_Name__r.MiddleName FROM genesis__Application_Parties__r WHERE Active__c = true AND Is_New__c = true) FROM genesis__Applications__c WHERE Id IN :updateAppIdList];
        
        
        for(genesis__Applications__c app : updatedAppList){
            if(!app.genesis__Application_Parties__r.isEmpty() && !app.Facilities__r.isEmpty()){  
                CBS_CustomerLinkage_Formatter.RequestFormat cbsReqObj = new CBS_CustomerLinkage_Formatter.RequestFormat();
                cbsReqObj.exe_tenantId                              = 'cuecent_tenant';
                cbsReqObj.owner_tenantId                            = 'cuecent_tenant';
                cbsReqObj.inputVariables                            = new CBS_CustomerLinkage_Formatter.cls_inputVariables();
                cbsReqObj.inputVariables.in_msg                     = new CBS_CustomerLinkage_Formatter.cls_in_msg();
                cbsReqObj.inputVariables.in_msg.TransactionBranch   = Utility.ISStringBlankorNull(app.Branch_Name__c) ? '' : app.Branch_Name__c;
                cbsReqObj.inputVariables.in_msg.Mode                = 'M';
                cbsReqObj.inputVariables.in_msg.ValueDateText       = System.today().format();
                
                List<CBS_CustomerLinkage_Formatter.cls_CustDetl> custDetailList = new List<CBS_CustomerLinkage_Formatter.cls_CustDetl>();
                for(genesis__Application_Parties__c party : app.genesis__Application_Parties__r){
                    relTypeCode = queryService.getPartyRelType(party.genesis__Party_Type__c);
                    
                    for(Facility__c facility : app.Facilities__r){
                        if(party.genesis__Party_Account_Name__r.CBS_Customer_ID__c != null){
                            CBS_CustomerLinkage_Formatter.cls_CustDetl custDetail = new CBS_CustomerLinkage_Formatter.cls_CustDetl();
                            custDetail.AccountNo = Utility.ISStringBlankorNull(facility.Account_Number__c) ? '' : facility.Account_Number__c;
                            custDetail.CustId1 = Utility.ISStringBlankorNull(party.genesis__Party_Account_Name__r.CBS_Customer_ID__c) ? '' : party.genesis__Party_Account_Name__r.CBS_Customer_ID__c;
                            custDetail.CustRel1 = relTypeCode != null ? relTypeCode : 'AUS';
                            custDetail.FlgDel = 'N';
                            custDetailList.add(custDetail); 
                        }
                    }
                }
                cbsReqObj.inputVariables.in_msg.CustDetl = custDetailList;
                customerLinkageCallout(JSON.serialize(cbsReqObj),app.Id);
            }
        }
    }
    //Helper method to make callout for Customer Linkage
    @future(callout = true)
    public static void customerLinkageCallout(String custData,String appId){
        KVB_Endpoint_URLs__c endPointUrl = KVB_Endpoint_URLs__c.getValues('CBS_CUST_LINKAGE');
        
        if(endPointUrl != null){
            system.debug('####'+custData);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            String endPoint                                         = endPointUrl.Endpoint_URL__c;
            response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,custData,headerMap,label.CA_CERTIFICATE);
            system.debug('$$$$'+response.getBody());
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                CBS_CustomerLinkage_Formatter.ResponseFormat res = (CBS_CustomerLinkage_Formatter.ResponseFormat)Json.deserialize(jsonString, CBS_CustomerLinkage_Formatter.ResponseFormat.class);
                system.debug('###'+res.out_msg.ErrorCode);
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'CBS_CUST_LINKAGE';
                log.Sequence_No__c = '5';
                if(res.out_msg.SuccessMessage != null && res.out_msg.SuccessMessage == 'Success'){
                    genesis__Applications__c app = new genesis__Applications__c();
                    app.id = appId;
                    //app.Retry_CBS__c =true;
                    UPDATE app;
                    log.Status__c = 'Success';
                    log.Success_Error_Message__c = res.out_msg.SuccessMessage;
                }else{
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    
                }
                insert log;
            }
            else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'CBS_CUST_LINKAGE_SME';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = 'CBS_CUST_LINKAGE_NO_HIT';
                log.Sequence_No__c = '5';
                insert log;
            }
        }
    }
    
    @future(callout = true)
    public static void limitUpdation_ChargeColllection(List<Id> updatedAppIdList){
        if(!updatedAppIdList.isEmpty()){
            List<CBS_API_Log__c> logList = new List<CBS_API_Log__c>();
            Set<String> bmBranchCodeSet = new Set<String>();
            List<Facility__c> facilityList = new List<Facility__c>();
            facilityList = SOQL_Util.getFacilityList(updatedAppIdList);
            List<MCLR_Master__c> mclrRecordList     =  new List<MCLR_Master__c>();
            mclrRecordList = [SELECT Id, Name, COD_Term_From__c, COD_Term_To__c, Effective_Date__c, Expiry_Date__c,  Interest_Rate_Reset__c, Int_ID__c, MCLR_Of_Interest__c 
                              FROM MCLR_Master__c];
            if(!facilityList.isEmpty()){
                for(Facility__c facility : facilityList){
                    bmBranchCodeSet.add(facility.Application__r.genesis__Account__r.Branch_Code__c);
                }
            }
            Map<String,String> bmCodeEmpCodeMap = new Map<String,String>();
            for(User u : [SELECT Id,Office_Code__c,EmployeeNumber FROM User WHERE Office_Code__c IN :bmBranchCodeSet AND Role_Name__c = 'Manager']){
                bmCodeEmpCodeMap.put(u.Office_Code__c,u.EmployeeNumber);
            }
            
            Boolean limitUpdatedFlag    = true;
            Decimal currentMCLR         = 0.0;
            Integer daysDifference      = 0;
            Decimal oneYrMCLR           = 0.0;
            if(!facilityList.isEmpty()){
                for(Facility__c facility : facilityList){
                    if(!facility.Application__r.OD_limit_creation_updation__c){
                        Date endDate;
                        if(facility.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_EXCEEDING && facility.Recommended_Days__c != null){
                            // endDate = System.today().addDays(Integer.valueOf(facility.Application__r.EAE_Renewal_Date_in_days__c));
                            endDate = System.today().addDays(Integer.valueOf(facility.Recommended_Days__c));
                            daysDifference = System.today().daysBetween(endDate);
                        }
                        else if(facility.Application__r.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE && facility.Limit_end_date__c != null){
                            endDate = facility.Limit_end_date__c;
                            daysDifference = System.today().daysBetween(endDate) + 1;
                        }
                        
                        CBS_OD_TOD_Formatter.RequestFormat cbsReqObj = new CBS_OD_TOD_Formatter.RequestFormat();
                        cbsReqObj.exe_tenantId                              = 'cuecent_tenant';
                        cbsReqObj.owner_tenantId                            = 'cuecent_tenant';
                        cbsReqObj.inputVariables                            = new CBS_OD_TOD_Formatter.cls_inputVariables();
                        cbsReqObj.inputVariables.in_msg                     = new CBS_OD_TOD_Formatter.cls_in_msg();
                        cbsReqObj.inputVariables.in_msg.AccountNo           = facility.Account_Number__c != null ? facility.Account_Number__c :  '';
                        cbsReqObj.inputVariables.in_msg.MaintenanceMode     ='M';
                        cbsReqObj.inputVariables.in_msg.LimitStartDate      = facility.Limit_start_date__c != null ? (facility.Limit_start_date__c).format() : '';
                        if(endDate != null)
                            cbsReqObj.inputVariables.in_msg.LimitEndDate    = endDate.format();
                        cbsReqObj.inputVariables.in_msg.LimitAmount         = facility.Recommended_Limit__c != null ? String.valueOf(facility.Recommended_Limit__c).replace(',','') :'';
                        cbsReqObj.inputVariables.in_msg.SecuredFlag         = 'N';
                        cbsReqObj.inputVariables.in_msg.InterestIndexCode   = '9990';//Interest code will be same always--9990---Changed later to ''
                        cbsReqObj.inputVariables.in_msg.InterestRate        = '';//facility.Recommended_Rate__c != null ? String.valueOf(facility.Recommended_Rate__c) : '';
                        if(endDate != null){
                            System.debug('daysDifference:::'+daysDifference);
                            if(!mclrRecordList.isEmpty()){
                                for(MCLR_Master__c mcleRec : mclrRecordList ){
                                    if(mcleRec.COD_Term_From__c >= 365 ){
                                        oneYrMCLR = Utility.isNullOrZeroDecimal(mcleRec.MCLR_Of_Interest__c);
                                    }
                                    if((mcleRec.COD_Term_From__c != null && mcleRec.COD_Term_To__c !=null)
                                       && daysDifference >= mcleRec.COD_Term_From__c && daysDifference <= mcleRec.COD_Term_To__c){
                                           currentMCLR = Utility.isNullOrZeroDecimal(mcleRec.MCLR_Of_Interest__c);
                                       }
                                }
                            }
                        }
                        cbsReqObj.inputVariables.in_msg.InterestVariance = String.valueOf(Utility.isNullOrZeroDecimal(facility.Final_Spread__c) + (oneYrMCLR - currentMCLR));
                        //cbsReqObj.inputVariables.in_msg.InterestVariance = String.valueOf(Utility.isNullOrZeroDecimal(facility.Final_Spread__c));
                        
                        cbsReqObj.inputVariables.in_msg.MakerID                 = 'DTMAKER';
                        cbsReqObj.inputVariables.in_msg.CheckerID               = 'DTCHECKER';
                        System.debug('oneYrMCLR:::'+oneYrMCLR);
                        System.debug('currentMCLR:::'+currentMCLR);
                        System.debug('InterestVariance:::'+cbsReqObj.inputVariables.in_msg.InterestVariance);
                        logList.add(OD_TOD_Callout(JSON.serialize(cbsReqObj),facility.Application__c));
                    }
                }
            }
            for(CBS_API_Log__c log : logList){
                if(log.Status__c != 'Success') limitUpdatedFlag = false;
            }
            if(limitUpdatedFlag) logList.addAll(chargeCollection(updatedAppIdList,false));
            if(!logList.isEmpty()) INSERT logList;
        }
    }
    
    //Helper method to make callout for OD Limit creation/Modification and OD/TOD Limit Varience
    public static CBS_API_Log__c OD_TOD_Callout(String custData,Id appId){
        CBS_API_Log__c log;
        KVB_Endpoint_URLs__c endPointUrl = KVB_Endpoint_URLs__c.getValues('CBS_CASA');
        if(endPointUrl != null){
            system.debug('####'+custData);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            String endPoint                                         = endPointUrl.Endpoint_URL__c;
            response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,custData,headerMap,label.CA_CERTIFICATE);
            system.debug('$$$$'+response.getBody());
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                CBS_OD_TOD_Formatter.ResponseFormat res = (CBS_OD_TOD_Formatter.ResponseFormat)Json.deserialize(jsonString, CBS_OD_TOD_Formatter.ResponseFormat.class);
                system.debug('###'+res.out_msg.ErrorCode);
                log = new CBS_API_Log__c();    
                log.Application__c = appId;
                log.API_Name__c = 'OD/TOD_SME';
                log.Sequence_No__c = '12';  
                
                if(res.out_msg.ErrorCode != null && res.out_msg.ErrorCode == '0'){
                    log.Status__c = 'Success';
                    log.Success_Error_Message__c = res.out_msg.ReplyText;
                }
                else{
                    log.Status__c = 'Failure';
                    if(res.out_msg.ErrorMessage != null && res.out_msg.ErrorMessage != '')
                        log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    else if(res.out_msg.ReplyText != null && res.out_msg.ReplyText != '')
                        log.Success_Error_Message__c = res.out_msg.ReplyText;
                }
            }
            else{
                log.Application__c = appId;
                log.API_Name__c = 'OD/TOD_SME';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = 'OD/TOD_SME_NO_HIT';
                log.Sequence_No__c = '12';  
            }
        }
        RETURN log;
    }
    //Structure formation for Charge collection
    public static List<CBS_API_Log__c> chargeCollection(List<String> appIdList,Boolean reTry){
        List<CBS_API_Log__c> logList = new List<CBS_API_Log__c>();
        Boolean isExccedingApp = false;
        
        Decimal totalAmount = 0.0;
        Decimal gst         = 0.0;
        Set<Id> collIdset = new Set<Id>();
        List<M21_A__c> m21_List = new List<M21_A__c>();
        Decimal gstPercent  = KVB_Company_Details__c.getOrgDefaults().GST__c / 100;
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        appList = [SELECT Id,Legal_desk_state_flag__c,Branch_Code__c,RecordType.developerName,Charge_collection_done__c,Name,Cibil_Charges__c,Cersai_Charges__c,Processing_Charges__c,genesis__Additional_Cash_Required__c,genesis__Account__r.Branch_Code__c,(SELECT Id,genesis__Collateral__c,genesis__Collateral__r.FE_Created__c FROM Application_Collateral__r WHERE genesis__Collateral__r.FE_Created__c = true),(SELECT Id,Account_Number__c,Recommended_Limit__c FROM Facilities__r) FROM genesis__Applications__c WHERE Id IN : appIdList];
        String CHARGE_COLLECTION_GL_TYPES = 'PRCH_CHG:LEGAL_FEE:VALU_FEE:CIBIL_FEE:STMP_FEE:CERSAI_FEE:DOC_FEE';
        List<String> chargeTypeList = CHARGE_COLLECTION_GL_TYPES.split(':');
        if(!appList.isEmpty()){
            for(genesis__Applications__c app : appList){
                if(!app.Charge_collection_done__c){
                    if(app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_EXCEEDING){
                        isExccedingApp = true;
                    }
                    System.debug(valuationCharge);
                    CBS_API_Log__c log = new CBS_API_Log__c();
                    CBS_ChargeCollaction_Formatter.RequestFormat cbsReqObj      = new CBS_ChargeCollaction_Formatter.RequestFormat();
                    cbsReqObj.exe_tenantId                                      = 'cuecent_tenant';
                    cbsReqObj.owner_tenantId                                    = 'cuecent_tenant';
                    cbsReqObj.inputVariables                                    = new CBS_ChargeCollaction_Formatter.cls_inputVariables();
                    cbsReqObj.inputVariables.in_msg                             = new CBS_ChargeCollaction_Formatter.cls_in_msg();
                    cbsReqObj.inputVariables.in_msg.Charges                     = new List<CBS_ChargeCollaction_Formatter.cls_Charges>();
                    
                    if(app.Facilities__r[0].Account_Number__c != null) cbsReqObj.inputVariables.in_msg.AccountNumber               = app.Facilities__r[0].Account_Number__c;
                    if(app.genesis__Account__r.Branch_Code__c != null) cbsReqObj.inputVariables.in_msg.BranchCode                  = app.genesis__Account__r.Branch_Code__c;
                    cbsReqObj.inputVariables.in_msg.ApplicationNumber           = app.Id;
                    cbsReqObj.inputVariables.in_msg.TransactionDate             = System.today().format();
                    cbsReqObj.inputVariables.in_msg.ValueDate                   = System.today().format();
                    cbsReqObj.inputVariables.in_msg.ApplicantName               = app.Name;
                    cbsReqObj.inputVariables.in_msg.Flg_Force_Debit             = 'Y';
                    if(app.Legal_desk_state_flag__c == true){
                        cbsReqObj.inputVariables.in_msg.Flg_StmpFee_Brn = 'N';
                    }
                    if(app.Legal_desk_state_flag__c == false){
                       cbsReqObj.inputVariables.in_msg.Flg_StmpFee_Brn = 'Y';
                    }
                    for(String chargeType : chargeTypeList){
                        CBS_ChargeCollaction_Formatter.cls_Charges charge   = new CBS_ChargeCollaction_Formatter.cls_Charges();
                        charge.GL_Type = chargeType;
                        Decimal chargeAmount = 0.0;
                        Decimal gstCharge = 0.0;
                        if(chargeType == 'PRCH_CHG' && isExccedingApp){
                            if(app.Processing_Charges__c != null){
                                chargeAmount = (app.Processing_Charges__c).setScale(2);
                                gstCharge = (app.Processing_Charges__c * gstPercent).setScale(2);
                                charge.ChargeAmount = chargeAmount;
                                charge.GST_Charge = gstCharge;
                                totalAmount += chargeAmount;
                                totalAmount += gstCharge;
                            }
                            else{
                                charge.ChargeAmount = 0.0;
                                charge.GST_Charge = 0.0;
                            }
                        }
                        else if(chargeType == 'CIBIL_FEE' && !isExccedingApp){
                            if(app.Cibil_Charges__c != null){
                                chargeAmount = (app.Cibil_Charges__c +1000).setScale(2);
                                if(!isExccedingApp) gstCharge = (chargeAmount * gstPercent).setScale(2);
                                charge.ChargeAmount = chargeAmount;
                                charge.GST_Charge = gstCharge;
                                totalAmount += chargeAmount;
                                totalAmount += gstCharge;
                            }
                            else{
                                charge.ChargeAmount = 0.0;
                                charge.GST_Charge = 0.0;
                            }
                        }
                        /*else if(chargeType == 'LEGAL_FEE' && !isExccedingApp){
                            chargeAmount = leagalFee;
                            gstCharge  = leagalFee * gstPercent;
                            charge.ChargeAmount = chargeAmount;
                            charge.GST_Charge =gstCharge;
                            totalAmount += chargeAmount;
                            totalAmount += gstCharge;
                        }*/
                        else if(chargeType == 'STMP_FEE' && !isExccedingApp){
                            charge.ChargeAmount = chargeAmount;
                            charge.GST_Charge =gstCharge;
                        }
                        else if(chargeType == 'CERSAI_FEE' && !isExccedingApp){
                            chargeAmount = app.Cersai_Charges__c;
                            gstCharge  = chargeAmount * gstPercent;
                            charge.ChargeAmount = chargeAmount;
                            charge.GST_Charge =gstCharge;
                            totalAmount += chargeAmount;
                            totalAmount += gstCharge;
                        }
                        /*else if(chargeType == 'VALU_FEE' && !isExccedingApp){
                            chargeAmount = valuationCharge;
                            gstCharge  = valuationCharge * gstPercent;
                            charge.ChargeAmount = chargeAmount;
                            charge.GST_Charge =gstCharge;
                            totalAmount += chargeAmount;
                            totalAmount += gstCharge;
                        }*/
                        else if(chargeType == 'DOC_FEE' && !isExccedingApp){
                            if(app.genesis__Additional_Cash_Required__c != null){
                                chargeAmount        = (app.genesis__Additional_Cash_Required__c).setScale(2);
                                gstCharge           = (chargeAmount * gstPercent).setScale(2);
                                charge.ChargeAmount = chargeAmount;
                                charge.GST_Charge   = gstCharge;
                                totalAmount         += chargeAmount;
                                totalAmount         += gstCharge;
                            }
                            else{
                                charge.ChargeAmount = 0.0;
                                charge.GST_Charge   = 0.0;
                            }
                        }
                        else{
                            charge.ChargeAmount = 0.0;
                            charge.GST_Charge = 0.0;
                        }
                        cbsReqObj.inputVariables.in_msg.Charges.add(charge);
                    }
                    cbsReqObj.inputVariables.in_msg.TotalAmount                 = totalAmount.setScale(2);
                    System.debug(JSON.serialize(cbsReqObj));
                    logList.add(chargeCollectionCallout(JSON.serialize(cbsReqObj),app.Id));
                }
            }
        }
        if(reTry) INSERT logList;
        RETURN logList;
    }
    //Helper method to make callout for Charge collection
    public static CBS_API_Log__c chargeCollectionCallout(String custData,String appId){
        genesis__Applications__c app;
        CBS_API_Log__c log = new CBS_API_Log__c();   
        KVB_Endpoint_URLs__c endPointUrl = KVB_Endpoint_URLs__c.getValues('CBS_ChargeCollection');
        if(endPointUrl != null){
            system.debug('custData####'+custData);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            String endPoint                                         = endPointUrl.Endpoint_URL__c;
            response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,custData,headerMap,label.CA_CERTIFICATE);
            system.debug('$$$$'+response.getBody());
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                CBS_ChargeCollaction_Formatter.ResponseFormat res = (CBS_ChargeCollaction_Formatter.ResponseFormat)Json.deserialize(jsonString, CBS_ChargeCollaction_Formatter.ResponseFormat.class);
                log.Application__c = appId;
                log.API_Name__c = 'ChargeColletction_SME';
                log.Sequence_No__c = '13';  
                
                if(res.out_msg.ErrorCode == '0' && res.out_msg.CBSReferenceNo != null){
                    log.Status__c = 'Success';
                    if(res.out_msg.ErrorMessage != null) log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    log.ExternalReferenceNo__c = res.out_msg.ApplicationNumber;
                    
                    //Update Application
                    updateApplicationStage(appId,true);
                }
                else{
                    updateApplicationStage(appId,false);
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                }
            }
            else{
                log.Application__c = appId;
                log.API_Name__c = 'ChargeColletction_SME';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = 'ChargeColletction_NO_HIT';
                log.Sequence_No__c = '13';  
            }
        }
        RETURN log;
    }
    
    //Helper method to make callout for KYC updation
    @future(callout = true)
    public static void update_eKYC_CallOut(String eKYCData, String AppId){
        system.debug('####'+eKYCData);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Bulk_API');
        System.debug('Endpoint_URL__c::'+kvb.Endpoint_URL__c);
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,eKYCData,headerMap,label.CA_CERTIFICATE);
        system.debug('$$$$'+response.getBody());
        If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();
            CBS_eKYC_Creation_Handler.CBS_eKYC_Response res = (CBS_eKYC_Creation_Handler.CBS_eKYC_Response)Json.deserialize(jsonString, CBS_eKYC_Creation_Handler.CBS_eKYC_Response.Class);
            system.debug('res:::'+res);
            if(res.out_msg.Status_Desc != 'Success'){
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'EKYCUpdation_SME';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = res.out_msg.Status_Desc;
                log.Sequence_No__c = '2';  
                insert log;
            }            
        }else{
            CBS_API_Log__c log = new CBS_API_Log__c();    
            log.Application__c = AppId;
            log.API_Name__c = 'EKYCUpdation_SME';
            log.Status__c = 'Failure';
            log.Success_Error_Message__c = 'CustomerEKYC_CBS_Error_No_Hit';
            log.Sequence_No__c = '2';  
            insert log;
        }
    }
    public static void stockStatement(String accId){
        List<Account> accList = new List<Account>();
        List<Facility__c> facList = new List<Facility__c>();
        List<String> prodCodeList = new List<String>{'202','203','204','223','227','248','249','257','298','221'};
            facList = [SELECT Id FROM Facility__c WHERE Application__r.genesis__Account__c =: accId AND CL_Product__r.Product_Code__c IN : prodCodeList];
        accList = [SELECT Id,Branch_Name__c,Branch_Code__c,Drawing_Power__c FROM Account WHERE Id =:accId];
        if(!facList.isEmpty()){
            CBS_StockStatement_Formatter.RequestFormat sStmnt = new CBS_StockStatement_Formatter.RequestFormat();
            sStmnt.exe_tenantId = 'cuecent_tenant';
            sStmnt.owner_tenantId = 'cuecent_tenant';
            sStmnt.inputVariables = new CBS_StockStatement_Formatter.cls_inputVariables();
            sStmnt.inputVariables.in_msg = new CBS_StockStatement_Formatter.cls_in_msg();
            sStmnt.inputVariables.in_msg.Channel = 'BRN';
            sStmnt.inputVariables.in_msg.ExternalReferenceNo = '1001';
            sStmnt.inputVariables.in_msg.TransactionBranch = facList[0].Application__r.Branch_Name__c != null ? facList[0].Application__r.Branch_Name__c : '';
            sStmnt.inputVariables.in_msg.AccountNo = facList[0].Account_Number__c != null ? facList[0].Account_Number__c : '';
            sStmnt.inputVariables.in_msg.DP_Amt = facList[0].Application__r.genesis__Account__r.Drawing_Power__c != null ? String.valueOf(facList[0].Application__r.genesis__Account__r.Drawing_Power__c) : '';
            sStmnt.inputVariables.in_msg.ExtUniqueRefId = '1';
            sStmnt.inputVariables.in_msg.BranchCode = facList[0].Application__r.Branch_Code__c != null ? facList[0].Application__r.Branch_Code__c : '';
            
            stockStatementCallout(JSON.serialize(sStmnt),accId);
        }
    }
    public static void stockStatementCallout(String reqString, String accId){
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_StockStatement');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,reqString,headerMap,label.CA_CERTIFICATE);
        String jsonString = response.getBody();
        system.debug('$$$$'+jsonString);
        CBS_StockStatement_Formatter.ResponseFormat res = (CBS_StockStatement_Formatter.ResponseFormat)Json.deserialize(jsonString, CBS_StockStatement_Formatter.ResponseFormat.Class);
        System.debug(res);
    }
    /////////////////////////helper methods
    //return Y/N on null check
    public static String strCheckNull(String strToCheck){
        if(strToCheck <> null){
            RETURN 'Y';
        }
        else
            RETURN 'N';
    }
    public static void updateApplicationStage(String appId,boolean chargeCol){
        genesis__Applications__c app = new genesis__Applications__c();
        app = [SELECT Id,Valuation_Charges__c,Legal_Charges__c,Cersai_Charges__c,Total_Stamp_Paper_Charge__c,RecordType.DeveloperName,Owner.Name,genesis__Account__r.Name,Owner.Email,Application_Stage__c,CustomerID__c,OD_limit_creation_updation__c,Charge_collection_done__c,Owner.Phone,(SELECT Id,Account_Number__c FROM Facilities__r) FROM genesis__Applications__c WHERE Id =: appId];
        
        try{
            sendSMS(app);
            sendEmail(app);
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        if(chargeCol == true){
            if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE){
                if(app.Application_Stage__c == 'Sanction complete'){
                    app.Application_Stage__c = 'Limit extended';
                }
                else if(app.Application_Stage__c == 'Sanction complete- Final Sanction'){
                    app.Application_Stage__c = 'Limit renewed/Application close';
                    try{
                        SME_SendSMSService.sendSMSApp_SME(new Set<String>{app.Id});
                    }
                    catch(Exception e){
                        System.debug(e.getMessage());
                        System.debug(e.getLineNumber());
                        System.debug(e.getStackTraceString());
                    }
                }
            }
            else{
                app.Application_Stage__c = 'Limit Opened';
                app.Sub_Stage__c = 'Limit Opened';
            }
            app.Charge_collection_done__c      = true;
            app.Valuation_Charges__c = valuationCharge;
            app.Legal_Charges__c     = leagalFee;
            app.Cersai_Charges__c    = cersaiCharge;
            app.Total_Stamp_Paper_Charge__c = stampFeeCharge;
        }
        else if(chargeCol == false){
            if(app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE){
                if(app.Application_Stage__c == 'E-sign pending' || app.Application_Stage__c == 'Interim sanction offered'){
                    app.Application_Stage__c = 'Sanction complete';
                }
                else if(app.Application_Stage__c == 'E-sign pending-final' || app.Application_Stage__c == 'Final Sanction Offered'){
                    app.Application_Stage__c = 'Sanction complete- Final Sanction';
                }
            }
            else{
                app.Application_Stage__c = 'Limit Opened';
                app.Sub_Stage__c = 'Limit Opened';
            }
        }
        
        app.OD_limit_creation_updation__c    = true;
        ApplicationTriggerHandler.IsFirstRun   = false;
        UPDATE app;
        
    }
    public static void sendEmail(genesis__Applications__c app){
        String accNumberList = '';
        if(app.Facilities__r.size() > 0){
            for(Facility__c facility : app.Facilities__r){
                if(facility.Account_Number__c != null) accNumberList += facility.Account_Number__c+',';
            }
        }
        accNumberList.removeEnd(',');
        
        List<String> emailAddList = new List<String>();
        String emailSubject = 'Renewal of Working Capital Account - Verify the old limit';
        String body = 'Dear Branch Manager,<br><br>M/s '+app.genesis__Account__r.Name+' bearing customer Id '+accNumberList+' have renewed their working capital account under Digital mode.  We request you to ensure deleting the existing limit, in the limit master viz. CHM07, if required.';
        emailAddList = new List<String>{app.Owner.Email};
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = emailAddList;
        message.setSubject(emailSubject);
        message.setReplyTo('support@kvb.com');
        //message.setSenderDisplayName('KVB TEAM');
        message.setBccSender(false);
        message.setHtmlBody(body);
        List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
        if (owea.size() > 0 ) {
            message.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        //System.debug(message);
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    public static void sendSMS(genesis__Applications__c app){
        String mobile_Message;
        try{
            
            List<String> smsAddList = new List<String>();
            List<String> mobile_MessageList             = new List<String>();
            
            smsAddList = new List<String>{app.Owner.Phone};
                for(String mob :smsAddList){
                    mobile_Message = 'Hi Applicant';
                    mobile_MessageList.add(mobile_Message);
                    if(mob != null && mobile_MessageList.size() > 0 && mob != ''){
                        for(String mobile_Msg : mobile_MessageList){
                            SMS_Services.sendSMSCall(mob,mobile_Msg);   
                        }
                    } 
                }
        }catch(Exception ex){
            System.debug('Error while Sending SMS***'+ex.getMessage()+ex.getLineNumber());
        }  
        
    }
    
}