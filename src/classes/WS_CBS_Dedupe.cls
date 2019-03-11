/*
* Name    : WS_CBS_Dedupe
* Company : ET Marlabs
* Purpose : This class is used to call CBS dedupe API
* Author  : Subas
*/
public class WS_CBS_Dedupe {
    public class CBS_Dedupe_Request{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String ApplicantNo;
        public cls_ApplicantDetails[] ApplicantDetails;
    }
    public class cls_ApplicantDetails {
        public String adharNo;  //939465806578
        public String panNo;    //AFSPN5930P
        public String custIc;   //NALIN19051981M
        public String ExpCustType;
        public String applicantId;
    }
    
    //Response structure
    public class CBS_Dedupe_Response{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;   //Success
    }
    public class cls_out_msg {
        public cls_DedupeFailureResponse[] DedupeFailureResponse;
        public cls_DedupeSuccessResponse[] DedupeSuccessResponse;
        public String ApplicantNo;  //012345678901
    }
    public class cls_DedupeFailureResponse {
        public String Response; //99
        public String Message;  // Internal OLTP Error. 
        public cls_custDetails custDetails;
        public String ErrorCode;    //CI9142
        public String ErrorMessage; //No Record Found For Input Data
        public String Code;    //29
    }
    public class cls_custDetails {
        public String panNo;    //
        public String custIc;   //
        public String ExpCustType;
        public String applicantId;  //0015D0000123wNmQAI
        public String adharNo;  //1234556789123

    }
    public class cls_DedupeSuccessResponse {
        public String AadharNo; //
        public String Sex;  //M
        public String CustomerIC;   //NALIN19051981M
        public String PanNo;    //
        public String CustomerId;   //87099
        public String CustMobNo;    //919843832343
        public String DriveLic; //
        public String PresentAddress;   //S/O SHANMUGAM K, 35, EAST GOWRIPURAM, KARUR India Tamil Nadu Karur 639002
        public String CustNameSpouse;   //
        public String RationId; //
        public String EKYCResponse; //SUCCESS
        public String DOB;  //1981-05-19
        public String PassportNo;   //
        public String FullName; //NALINAKRISHNAN S
        public String VoterId;  //
        public String CustEmail;    //nalinakrishnan@yahoo.co.in
        public String CustNameFather;   //
        public String ErrorCode;    //00
        public String ErrorMessage; //success
        public String LetterFromAuthority;  //N
        public String PermAddress;  //S/O SHANMUGAM K, 35, EAST GOWRIPURAM, KARUR India Tamil Nadu Karur 639002
        public String CustomerType;    //Y-Business Acc, N-Person Acc
        public cls_custDeatils custDeatils;
    }
    public class cls_custDeatils {
        public String panNo;    //
        public String custIc;   //NALIN19051981M
        public String applicantId;  //0015D0000080wNmQAI
        public String adharNo;  //
    }
    @future (Callout=true)
    public static void callDedupe(String AppId){
        List<String> custID  = new List<String>();
        List<ID> accountIds = new List<ID>();
        String LoanAcNo = '';
        List <Account> accList = new List <Account>();
        accList = queryService.accList(AppId);
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appId);        
        for(Account acc : accList){
            accountIds.add(acc.ID);
        }
        
        WS_CBS_Dedupe.CBS_Dedupe_Request cbs = new WS_CBS_Dedupe.CBS_Dedupe_Request();
        cbs.inputVariables = new WS_CBS_Dedupe.cls_inputVariables();
        WS_CBS_Dedupe.cls_inputVariables cbsInput = new WS_CBS_Dedupe.cls_inputVariables();
        cbsInput.in_msg = new WS_CBS_Dedupe.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbsInput.in_msg.ApplicantNo = AppId;
        cbsInput.in_msg.ApplicantDetails = new List<cls_ApplicantDetails>();
        List<Account> accountList = new List<Account>();
        for(Account acc : accList){
            if(string.isBlank(acc.Customer_IC__c)){
                accountList.add(acc);
            }
            if(acc.CBS_Customer_ID__c == null || acc.CBS_Customer_ID__c ==''){
                cls_ApplicantDetails rq = new cls_ApplicantDetails();
                //system.debug('^^^^'+WS_getAadharNo.getAadharNo(acc.Aadhaar_Number__pc));    
                rq.adharNo = WS_getAadharNo.getAadharNo(acc.Aadhaar_Number__pc);
                rq.custIc = acc.Customer_IC__c;
                rq.panNo = acc.Pan_Number__c;
                rq.ExpCustType = 'P';
                rq.applicantId = acc.Id;
                cbsInput.in_msg.ApplicantDetails.add(rq);
                /*if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                     getDedupe(JSON.serialize(cbs),AppId); 
                }*/


            }else{
                custID.add(acc.CBS_Customer_ID__c);
            }
        }
        system.debug('accList:::'+accList);
        if(accountList.size() == 0 && application.Record_Type_Name__c != Constants.PERSONALLOAN){
            if(accList.size() == custID.size()){
                //call loan account opening
                System.debug('custID:::'+custID);
                if(application.Loan_Account_Number__c == null){                
                    Ws_CBS_CustdetailsModification.CBS_Custmodificationrequest(AppId,null);                
                }
            }else{            
                getDedupe(JSON.serialize(cbs),AppId);            
            }

        }else if(accList.size() == custID.size() && application.Record_Type_Name__c == Constants.PERSONALLOAN && application.Loan_Account_Number__c == null){
                              
                    Ws_CBS_CustdetailsModification.CBS_Custmodificationrequest(AppId,null);                
             
        }
        else{
            if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                    getDedupe(JSON.serialize(cbs),AppId);
                }else{
                    List<CBS_API_Log__c> logList = new List<CBS_API_Log__c>();
                    for(Account a : accountList){
                        CBS_API_Log__c log = new CBS_API_Log__c();    
                        log.Application__c = AppId;
                        log.Applicant__c = a.Id;
                        log.API_Name__c = 'CBS_Dedupe';
                        log.Status__c = 'Failure';
                        log.Success_Error_Message__c = 'Customer IC should not be blank';
                        log.Sequence_No__c = '1';  
                        logList.add(log);
                    }
                    insert logList;
                }
        }
    }
    public static void getDedupe(String dedupeData, String AppId){
        system.debug('####'+dedupeData);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Dedupe_Bulk');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,dedupeData,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        List <ID> AppIDList = new List<ID>();
        CBS_API_Log__c log = new CBS_API_Log__c();
        List <ID> accEKYC = new List <ID>();
        List <ID> accList = new List <ID>();
        List <String> accIdList = new List<String>();
        List<Account> accountList = new List<Account>();
        List<String> MessageList = new List<String>();
        List<CBS_API_Log__c> logList = new List<CBS_API_Log__c>();
        Map<String,String> DedupeStatus = new Map<String,String>();
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();    
                
                WS_CBS_Dedupe.CBS_Dedupe_Response res = (WS_CBS_Dedupe.CBS_Dedupe_Response)Json.deserialize(jsonString,WS_CBS_Dedupe.CBS_Dedupe_Response.class);
                System.debug('Dedupe responses ---> '+res);
                
                if(res.out_msg.DedupeFailureResponse.size()>0){
                    for(WS_CBS_Dedupe.cls_DedupeFailureResponse rq : res.out_msg.DedupeFailureResponse){
                        accIdList.add(rq.custDetails.applicantId);
                    }
                }
                if(res.out_msg.DedupeSuccessResponse.size()>0){
                    for(WS_CBS_Dedupe.cls_DedupeSuccessResponse rq : res.out_msg.DedupeSuccessResponse){                    
                        DedupeStatus.put(rq.custDeatils.applicantId, rq.CustomerId);
                    }
                }
                system.System.debug('DedupeStatus >>> ' + DedupeStatus);
                if(accIdList.size()>0 && DedupeStatus.size() == 0){
                    //Call EKYC                 
                    WS_CBS_eKYC_Creation_HL.cbs_eKYC_Creation(accIdList,AppId,null);
                }else if(DedupeStatus.size()>0 && accIdList.size() == 0){
                    //call loan creation
                     Ws_CBS_CustdetailsModification.CBS_Custmodificationrequest(AppId,DedupeStatus);
                }else if(accIdList.size() >0 && DedupeStatus.size()>0){
                    //call ekyc and update account
                    WS_CBS_eKYC_Creation_HL.cbs_eKYC_Creation(accIdList,AppId,DedupeStatus);
                }else{
                    //error in dedup API
                }
            }else{
                // CBS_001 : CBS Dedupe success response insert
                CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                CbsDedup.Application__c = AppId;
                CbsDedup.API_Name__c = 'CBS_Dedupe';
                CbsDedup.Status__c = 'Failure';
                CbsDedup.Sequence_No__c = '1';  
                CbsDedup.Success_Error_Message__c = 'CBS_Dedupe No-hit';
                insert CbsDedup;
            }
        }catch(exception e){
               HandleBusinessException.captureError('WS_CBS_Dedupe','getDedupe', e); 
               // CBS_001 : CBS Dedupe success response insert
                CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                CbsDedup.Application__c = AppId;
                CbsDedup.API_Name__c = 'CBS_Dedupe';
                CbsDedup.Status__c = 'Failure';
                CbsDedup.Sequence_No__c = '1';  
                CbsDedup.Success_Error_Message__c = 'CBS_Dedupe Exception'+ e.getMessage();
                insert CbsDedup; 
        }    
    }
    
}