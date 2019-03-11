/*
* Name      : WS_CBS_eKYC_Creation_HL
* Compnay   : ET Marlabs
* Purpose   : For HL Service(Customer eKYC creation in CBS) 
* Author    : Subas
*******************************************************************
* Modification : CBS_001 Add code for success response of all Single CBS APIs.
* Developer : Ashok 
*/

public class WS_CBS_eKYC_Creation_HL {
    //@future (Callout=true)
    public static void cbs_eKYC_Creation(List<ID> accIds, String AppId, Map<string,string>accMap){
        //List <Account> accList = new List <Account>();
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appId);        
        // Re model chnages
        List<genesis__Application_Parties__c>  accList = new List<genesis__Application_Parties__c>();
        if(accIds !=null){
            if(accList.size() > 0){
                //accList = queryService.accListCust(accIds);   
            }else{
                //accList = queryService.accList(AppId);
                accList= queryService.PartyListPartyIDs(accIds,AppId);
            }            
        }else{
            accList = queryService.PartyListApp(AppId);
        }        
        system.debug('##EKYCAccountList##'+accList.size());         
        CBS_eKYC_Creation_Handler cbs = new CBS_eKYC_Creation_Handler();
        cbs.inputVariables = new CBS_eKYC_Creation_Handler.cls_inputVariables();
        CBS_eKYC_Creation_Handler.cls_inputVariables clsInput = new CBS_eKYC_Creation_Handler.cls_inputVariables();
        clsInput.in_msg = new CBS_eKYC_Creation_Handler.cls_in_msg();
        cbs.inputVariables = clsInput;
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        clsInput.in_msg.ApplicationId = AppId;
        clsInput.in_msg.serviceName = 'EKYCUpdation_HL';
        clsInput.in_msg.EKYCDetails = new List<CBS_eKYC_Creation_Handler.EKYCDetails>();
        for(genesis__Application_Parties__c acc : accList){
            CBS_eKYC_Creation_Handler.EKYCDetails rq = new CBS_eKYC_Creation_Handler.EKYCDetails();            
            rq.ApplicantID = acc.genesis__Party_Account_Name__r.ID;
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
            rq.TransactionBranch = application.Branch_Code__c;  //pass branch code
            rq.UserId ='SYSTEM01';  
            rq.UserReferenceNumber =''; 
            rq.ValueDateText ='';   
            rq.CodCustIc = acc.genesis__Party_Account_Name__r.Customer_IC__c;   
            rq.FlgCustTyp ='RESIDENT INDIAN';   
            rq.CodCustId = '0';//acc.CBS_Customer_ID__c;    
            string aadharcardNo = WS_getAadharNo.getAadharNo(acc.genesis__Party_Account_Name__r.Aadhaar_Number__pc); //'499118665246';
            if(aadharcardNo.isNumeric() == True){
                rq.CodCustUniqueId = aadharcardNo;
            }else{
                rq.CodCustUniqueId = '';
            }                          
            if(acc.genesis__Party_Account_Name__r.Pan_Number__c <> null){
                rq.FlgPanCard ='Y'; 
            }else{rq.FlgPanCard ='N';}
            rq.CodPanCard = acc.genesis__Party_Account_Name__r.Pan_Number__c;   
            if(acc.genesis__Party_Account_Name__r.Voter_Id__c <>null){
                rq.FlgVoterId ='Y';
            }else{rq.FlgVoterId ='N';}          
            rq.CodVoterId = acc.genesis__Party_Account_Name__r.Voter_Id__c; 
            if(acc.genesis__Party_Account_Name__r.Passport_Number__pc <>null){
                rq.FlgPassport = 'Y';   
            }else{rq.FlgPassport = 'N';}
            rq.CodPassport = acc.genesis__Party_Account_Name__r.Passport_Number__pc;    
            if(acc.genesis__Party_Account_Name__r.Driving_License_ID__c <>null){
                rq.FlgDriveLiscense ='Y';
            }else{rq.FlgDriveLiscense ='N';}        
            rq.CodDriveLiscense = acc.genesis__Party_Account_Name__r.Driving_License_ID__c; 
            if(acc.genesis__Party_Account_Name__r.National_Identification_Code__c <>null){
                rq.FlgNatIdCard ='Y';
            }else{rq.FlgNatIdCard ='N';}            
            rq.CodNatIdCard = acc.genesis__Party_Account_Name__r.National_Identification_Code__c;   
            rq.FlgLetterRecogAuth ='N'; 
            rq.CodLetterRecogAuth ='';  
            if(acc.genesis__Party_Account_Name__r.Other_identification_number__c <>null){
                rq.FlgOthers ='Y';
            }else{rq.FlgOthers ='N';}        
            rq.CodOthers = acc.genesis__Party_Account_Name__r.Other_identification_number__c;   
            rq.FlgPhotoObtained ='Y';   
            /*rq.DatPhotoObtained = acc.genesis__Party_Account_Name__r.CreatedDate != null ? String.valueOf(date.valueOf(acc.genesis__Party_Account_Name__r.CreatedDate).format()) : '';  //'10/03/2018'; //
            rq.DatCustIdData = String.ValueOf(date.valueOf(system.today()).format()) != null ? String.ValueOf(date.valueOf(system.today()).format()) : '';  // 10/03/2018'; //
            rq.CodCustRiskCat ='2'; 
            rq.DatRiskCatReview = system.today() != null ? String.ValueOf(date.valueOf(system.today()).format()) : ''; //'10/03/2018';*/
            
            rq.DatPhotoObtained = '03/11/2018';
            rq.DatCustIdData = '03/11/2018';
            rq.CodCustRiskCat ='2'; 
            rq.DatRiskCatReview = '03/11/2018';
             
            rq.CodReasonRiskCat ='';
            if(acc.genesis__Party_Account_Name__r.Telephone_Bill__c <>null){
                rq.FlgTeleBillIndiv ='Y';
            }else{rq.FlgTeleBillIndiv ='N';}                   
            rq.FlgTelephoneBillComp ='N';
            rq.FlgLtrRcgAuthInd ='N';   
            rq.FlgElecBillIndiv ='N';
            if(acc.genesis__Party_Account_Name__r.Ration_Card__c <>null){
                rq.FlgRationCardIndiv ='Y';
            }else{rq.FlgRationCardIndiv ='N';}  
            if(acc.genesis__Party_Account_Name__r.Employment_Letter__c <> null){
                rq.FlgEmpLetterIndiv ='Y';
            }else{rq.FlgEmpLetterIndiv ='N';}           
            rq.CodOtherDocindiv ='2';   
            if(acc.Same_Present_Address_Permanent_Address__c <> null){
                rq.FlgSameIdProofIndiv ='Y';
            }else{rq.FlgSameIdProofIndiv ='N';}         
            rq.FlgIncorpCertifComp ='N';    
            rq.FlgMoaComp ='N'; 
            rq.FlgAoaComp ='N'; 
            rq.FlgBodResolutionComp ='N';   
            rq.FlgPoaDocumentComp ='N'; 
            if(acc.genesis__Party_Account_Name__r.Bank_Statement__c <> null){
                rq.FlgBankStmtIndiv ='Y';
            }else{rq.FlgBankStmtIndiv ='N';}    
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
            rq.FlgRegCertifOthers ='N'; 
            rq.CodOtherDocOthers ='';   
            rq.ThresholdPct ='100'; 
            rq.FlgThresholdAlert ='Y';  
            rq.AnualTurnOver =  String.ValueOf(((acc.NMI_Approved__c != null ? Integer.ValueOf(acc.NMI_Approved__c) : 0 ) * 12)==0?1:((acc.NMI_Approved__c != null ? Integer.ValueOf(acc.NMI_Approved__c) : 0 ) * 12));             
            rq.FormStatus ='';  
            rq.FlgEkyc ='Y';
            string uniqueno = CreateUniqueId.uniqID();
            string regex = '[a-zA-Z]{1,}|\\-';
            String unique = uniqueno.replaceAll(regex, '');
            rq.EkycRefNo = unique.subString(0,9);   
            rq.channel ='';
            clsInput.in_msg.EKYCDetails.add(rq);
        }        
        
        if(accList.size() > 0){
           geteKYC(json.serialize(cbs),AppId,accMap);
        }else if(accList.size() == 0){
           WS_CBS_Create_CustID.getCBSID(AppId); //CBS005 -Bulk response all sucess call to 3rd api 2018/12/04
        }
    }
    public static void geteKYC(String eKYCData,String AppId,Map<string,string>accMap){
        system.debug('^^^^^'+eKYCData);
        List<Account> accountList = new List<Account>();
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>(); // CBS_001
        String DedupeCustIDs;
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Bulk_API');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,eKYCData,headerMap,label.CA_CERTIFICATE);
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody(); 
                CBS_eKYC_Creation_Handler.CBS_eKYC_Response res = (CBS_eKYC_Creation_Handler.CBS_eKYC_Response)Json.deserialize(jsonString, CBS_eKYC_Creation_Handler.CBS_eKYC_Response.Class);
                system.debug('@@@'+res);
                if(accMap != null){
                    if(accMap.size()>0){
                        for(String str : accMap.keySet()){
                            if(str.length()>=15){
                                account acc = new account();
                                acc.Id = str;
                                acc.CBS_Customer_ID__c = accMap.get(str);
                                accountList.add(acc);
                                DedupeCustIDs += accMap.get(str)+' ';
                            }
                        }
                        // CBS_001 : CBS Dedupe success response insert
                            CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                            CbsDedup.Application__c = AppId;
                            CbsDedup.API_Name__c = 'CBS_Dedupe';
                            CbsDedup.Status__c = 'Success';
                            CbsDedup.Sequence_No__c = '1';  
                            CbsDedup.Success_Error_Message__c = 'CustID - '+DedupeCustIDs;
                            UpcbsLog.add(CbsDedup);
                        if(accountList.size()>0){
                            update accountList; 
                        }
                    }
                }
                if(res.out_msg.Status_Desc != 'Success'){
                    // CBS_001 : CBS Dedupe success response insert
                    CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                    CbsDedup.Application__c = AppId;
                    CbsDedup.API_Name__c = 'CBS_Dedupe';
                    CbsDedup.Status__c = 'Success';
                    CbsDedup.Sequence_No__c = '1';  
                    CbsDedup.Success_Error_Message__c = 'CustID Not generated';
                    UpcbsLog.add(CbsDedup);
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = AppId;
                    log.API_Name__c = 'EKYCUpdation_HL';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.Status_Desc;
                    log.Sequence_No__c = '2';
                    UpcbsLog.add(log);  
                }else if(accMap == null){ // else added only for success store
                 // CBS_001 : CBS Dedupe success response insert
                    CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                    CbsDedup.Application__c = AppId;
                    CbsDedup.API_Name__c = 'CBS_Dedupe';
                    CbsDedup.Status__c = 'Success';
                    CbsDedup.Sequence_No__c = '1';  
                    CbsDedup.Success_Error_Message__c = 'DedupeStatus - Null';
                    UpcbsLog.add(CbsDedup);
                }
                insert UpcbsLog; //   CBS_001
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'EKYCUpdation_HL';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = 'CustomerEKYC_CBS_Error_No_Hit';
                log.Sequence_No__c = '2';  
                insert log;
            }
    }catch(exception e){
        HandleBusinessException.captureError('EKYCUpdation_HL','geteKYC', e);
    }
    }
}