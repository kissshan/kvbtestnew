/*
* Name      : WS_CBS_CustdetailsModification
* Compnay   : ET Marlabs
* Purpose   : For Retail Service(CustdetailsModification) 
* Author    : Venu
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================

*******************************************************************************************/
public class Ws_CBS_CustdetailsModification {
    public static   Map<ID,genesis__Application_Parties__c> partyMap; //............v1.1
    
    // Request
    public class CustdetailsModificationReq{
        public String exe_tenantId;	//cuecent_tenant
        public String owner_tenantId;	//cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String ApplicationId;	//addnvsifhskjf
        public cls_CustomerDetails[] CustomerDetails;
        public String TransactionBranch;	//1412
    }
    public class cls_CustomerDetails {
        public String ApplicantId;	//789454
        public String CustomerID;	//2431557
        public String EmailID;	//aabc456@gmail.com
        public String Profession;	//22
        public String CustAddress1;	//789454
        public String CustAddress2;	//2431557
        public String CustAddress3;	//aabc456@gmail.com
        public String CustCity;	//22
        public String CustState;	//2431557
        public String CustCountry;	//aabc456@gmail.com
        public String Zipcode;	//22
        public String Prefix;	//aabc456@gmail.com
        public String Sex;	//22
    }
    
    // Response
    public class CustdetailsModificationResponse{
        public String bpms_error_code;	//00
        public cls_out_msg out_msg;
        public String bpms_error_msg;	//Success
    }
    public class cls_out_msg {
        public cls_SuccessResponse[] SuccessResponse;
        public cls_FailureResponse[] FailureResponse;
        public String ApplicationId;	//addnvsifhskjf
    }
    public class cls_SuccessResponse {
        public String MessagesArray;	//
        public String IsServiceChargeApplied;	//false
        public String ApplicantId;	//789454
        public String ReplyCode;	//0
        public String TransactionStatus;	//Success
        public String ErrorCode;	//0
        public String IsOverriden;	//false
        public String SpReturnValue;	//0
        public String Memo;	//
        public String ExternalReferenceNo;	//
        public String ReplyText;	//
    }
    public class cls_FailureResponse {
        public String Response;	//99
        public String ApplicantId;	//12346
        public String ReasonMessage;	// Internal OLTP Error. 
        public String ErrorCode;	//CI212
        public String ErrorMessage;	//INV_PRE_GEN_XREF
        public String ReasonCode;	//29
        public String HttpStatus;	//504
    }
    @future (Callout=true)
    public static void CBS_CustmodificationrequestF(String appID,Map<string,string> accMap){
        CBS_Custmodificationrequest(appID,accMap);
    }
    
    public static void CBS_Custmodificationrequest(String appID,Map<string,string> accMap){
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appID);
        Ws_CBS_CustdetailsModification.CustdetailsModificationReq  cbs=  new Ws_CBS_CustdetailsModification.CustdetailsModificationReq();
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbs.inputVariables = new Ws_CBS_CustdetailsModification.cls_inputVariables();
        Ws_CBS_CustdetailsModification.cls_inputVariables cbsInput = new Ws_CBS_CustdetailsModification.cls_inputVariables();
        cbsInput.in_msg = new Ws_CBS_CustdetailsModification.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbsInput.in_msg.ApplicationId=application.id;
        cbsInput.in_msg.CustomerDetails = new List<Ws_CBS_CustdetailsModification.cls_CustomerDetails>();
        List<Account> AccList=  queryService.accList(appID);
        partymap(appID);//.........v1.1
        
        if(AccList !=null && AccList.size()>0){
           Map<string,String> StMap=Statemap();
            Map<string,String> CouMap=Countrymap();
            for(Account acc : accList){
                Ws_CBS_CustdetailsModification.cls_CustomerDetails req = new Ws_CBS_CustdetailsModification.cls_CustomerDetails();
                req.ApplicantId=acc.id;
                if(!Utility.ISStringBlankorNull(acc.CBS_Customer_ID__c)){
                     req.CustomerID=acc.CBS_Customer_ID__c;
                }
               else if(accMap <> null){
                     req.CustomerID=accMap.get(acc.id);
                }
                else{
                     req.CustomerID='';
                }
               
                req.EmailID=acc.PersonEmail;
              //req.Profession=acc.CBS_Prof_Code__c;
                req.Profession=partyMap.get(acc.id).CBS_Prof_Code__c;  //.......... V1.1
                req.CustAddress1 = acc.PersonMailingStreet;
                req.CustAddress2 = '';
                req.CustAddress3 = '';
                req.CustCity = acc.PersonMailingCity;
                req.CustState = StMap!=null?StMap.get(acc.PersonMailingState):'';
                req.CustCountry = CouMap!=null?CouMap.get(acc.PersonMailingCountry):'';
                req.Zipcode = acc.PersonMailingPostalCode;
                req.Prefix = acc.PersonTitle!= null ? acc.PersonTitle.replace('.','') : '';
                req.Sex = acc.Gender__pc;
                cbsInput.in_msg.CustomerDetails.add(req);
                // req.TransactionBranch
              
                
            }
              getCustomerdetailsUpdate(JSON.serialize(cbs),application.id,accMap);
            
        }
        
        
    }
    
    public static void getCustomerdetailsUpdate(String CustomData,String appID,Map<string,string> accMap){
        system.debug('^^^^^'+CustomData);
           list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_FCR_CustModi');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,CustomData,headerMap,label.CA_CERTIFICATE); 
        system.debug('#####'+response);
        system.debug('$$$$ final update'+response.getBody());
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                system.debug('jsonString'+jsonString);
                Ws_CBS_CustdetailsModification.CustdetailsModificationResponse res=(Ws_CBS_CustdetailsModification.CustdetailsModificationResponse)Json.deserialize(jsonString,Ws_CBS_CustdetailsModification.CustdetailsModificationResponse.class);
                if(res.out_msg.FailureResponse.size()>0){
                    CBS_API_Log__c log = cbsLogs(appID,'CBS_CUSTDetailUpdate_API','Failure',res.out_msg.FailureResponse[0].ErrorMessage,'3.5',res.out_msg.FailureResponse[0].ReasonCode,res.out_msg.FailureResponse[0].ReasonMessage);   
                    UpcbsLog.add(log);
                    CBS_API_Log__c CbsDedup = cbsLogs(appID,'CBS_Dedupe','Success','Cust Detail Not Updated','1','',''); 
                    UpcbsLog.add(CbsDedup);
                    insert UpcbsLog;
                    
                }
                else{
                   
                    WS_CBS_Loan_Creation_HL.createLoan(appID,accMap);
                   
                }
            }
            else{
                 
                    CBS_API_Log__c log = cbsLogs(appID,'CBS_CUSTDetailUpdate_API','Failure','CBS_CUSTDetailUpdate No-hit','3.5','','');   
                    UpcbsLog.add(log);
                    CBS_API_Log__c CbsDedup = cbsLogs(appID,'CBS_Dedupe','Success','Cust Detail Not Updated','1','',''); 
                    UpcbsLog.add(CbsDedup);
                    insert UpcbsLog;
                  
                
            }
        }
        catch(exception e){
            HandleBusinessException.captureError('Ws_CBS_CustdetailsModification','getCustomerdetailsUpdate', e);
        }
        
    }
    
    public static CBS_API_Log__c cbsLogs(string AppID,String ApiName,string Status,String SuccessMsg,string Sequence,String ReasonCode,String ReasonMsg){
        CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = AppID;
                    log.API_Name__c = ApiName;
                    log.Status__c = Status;
                    log.Success_Error_Message__c = SuccessMsg;
                    log.Sequence_No__c = Sequence;
                    log.Reason_Code__c = ReasonCode;
                    log.Reason_Message__c = ReasonMsg;
                    
        return log;
    }
    
    public static map<string,string> Countrymap(){
         List<Country_Master__mdt> concode = [Select ID,MasterLabel,Code__c From Country_Master__mdt ];
       map<string,string> CMap=new map<string,string>();
        for(Country_Master__mdt C:concode){
            if(CMap.containsKey(C.MasterLabel)){
                CMap.get(C.MasterLabel);
            }
            else{
                CMap.put(C.MasterLabel,C.Code__c);
            }
            
        }
        return Cmap;
    }
    public static map<string,string> Statemap(){
         List<State__mdt> statcode = [Select ID,MasterLabel,COD_STATE__c From State__mdt ];
       map<string,string> SMap=new map<string,string>();
        for(State__mdt C:statcode){
            if(SMap.containsKey(C.MasterLabel)){
                SMap.get(C.MasterLabel);
            }
            else{
                SMap.put(C.MasterLabel,C.COD_STATE__c);
            }
            
        }
        return SMap;
    }
    public static void partymap(string AppID){//............v1.1
       List<genesis__Application_Parties__c> partyList= [select id,genesis__Party_Account_Name__c,CBS_Prof_Code__c  from genesis__Application_Parties__c where genesis__Application__c=:appID];
        partyMap=new Map<Id,genesis__Application_Parties__c>();
		 for(genesis__Application_Parties__c par :partyList){
		 partyMap.put(par.genesis__Party_Account_Name__c,par);
		 } 
        System.debug('**partyMap'+partyMap);
    }
}