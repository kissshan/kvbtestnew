/*
* Name      : WS_CBS_Loan_Disbursment_HL
* Compnay   : ET Marlabs
* Purpose   : For HL Service(Loan Disbursment) 
* Author    : Subas
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
V1.1    29-Nov-2018    Venu         #CBS API Disbursement AMOUnt,Redirecting 22nd APi Changes

*******************************************************************************************/
public class WS_CBS_Loan_Disbursment_HL {
    public class Loan_disbursment_Request{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String LoanAccountNumber;    //1152753000002737
        public String AmountDisb;   //500000
        public String FlagTransfer; //2
        public String CASAAccountNumber;    //1152223000000359
        public String Narration;    //DT:HLDISB
        public String TransactionBranch;    //1152
        public String GLAccountNumber;
        public String GLBranchCode;
    }
    //Response structure
    public class Loan_disbursment_Response{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;   //Success
    }
    class cls_out_msg {
        public String ErrorCode;    //EXT_RSP818
        public String ErrorMessage; //Host leg of the Disbursement has not been done. OR Disbursement Done Today.
        public String Response; //99
        public cls_Reason Reason;
        public cls_TransactionStatus TransactionStatus;
    }
    class cls_Reason {
        public String Code; //29
        public String Message;  //Internal OLTP Error.
    }
    class cls_TransactionStatus {
        public String IsServiceChargeApplied;   //false
        public String ReplyCode;    //0
        public String Disbursed;    //
        public cls_ExtendedReply ExtendedReply;
        public String ErrorCode;    //
        public String IsOverriden;  //false
        public String SpReturnValue;    //0
        public String Memo; //
        public String ExternalReferenceNo;  //136162017100400010017
        public String ReplyText;    //
    }
    class cls_ExtendedReply {
        public String MessagesArray;    //
    }
    //@future (Callout=true)
    public static void callDisb(String AppID,List<CBS_API_Log__c> UpcbsLog,string loanNo){
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appID);
        Decimal dibAmount;
        WS_CBS_Loan_Disbursment_HL.Loan_disbursment_Request cbs = new WS_CBS_Loan_Disbursment_HL.Loan_disbursment_Request();
        cbs.inputVariables  = new WS_CBS_Loan_Disbursment_HL.cls_inputVariables();
        WS_CBS_Loan_Disbursment_HL.cls_inputVariables cbsInput = new WS_CBS_Loan_Disbursment_HL.cls_inputVariables();
        cbsInput.in_msg = new WS_CBS_Loan_Disbursment_HL.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        // V1.1 Start
       cbsInput.in_msg.LoanAccountNumber = application.Loan_Account_Number__c != null? application.Loan_Account_Number__c:loanNo;
        cbsInput.in_msg.TransactionBranch = application.Branch_Code__c;
        if(application.Record_Type_Name__c == Constants.LAPLOAN || application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.HOMELOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
            if(application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
                dibAmount= application.Sanction_Authority_Limit__c;
            }
            else{
                dibAmount  =application.Disbursement_Amount__c + (application.Final_GMRA__c  !=null?application.Final_GMRA__c :0);
            }
            cbsInput.in_msg.AmountDisb =String.ValueOf(dibAmount);
            cbsInput.in_msg.CASAAccountNumber = '';
            cbsInput.in_msg.GLAccountNumber = '275300300';
            cbsInput.in_msg.FlagTransfer = '1';
            
            if(application.Record_Type_Name__c == Constants.LAPLOAN){
                cbsInput.in_msg.Narration = 'DT:LAP DISB'+application.Loan_Account_Number__c != null? application.Loan_Account_Number__c:loanNo;
            }else if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                cbsInput.in_msg.Narration = 'DT:PL DISB'+application.Loan_Account_Number__c != null? application.Loan_Account_Number__c:loanNo;    
            }else if(application.Record_Type_Name__c == Constants.HOMELOAN){
                cbsInput.in_msg.Narration = 'DT:HSL DISB'+application.Loan_Account_Number__c != null? application.Loan_Account_Number__c:loanNo;
            }else if(application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
                cbsInput.in_msg.Narration = 'DT:VL DISB'+application.Loan_Account_Number__c != null? application.Loan_Account_Number__c:loanNo;    
            }
            cbsInput.in_msg.GLBranchCode =application.Branch_Code__c;            
        }else{
            cbsInput.in_msg.AmountDisb = String.ValueOf(application.Disbursement_Amount__c);
            cbsInput.in_msg.CASAAccountNumber = Third_Party_CBR_Codes__c.getValues(application.Sourced_By__c).CASAAccountNumber__c;
            cbsInput.in_msg.GLAccountNumber = '';
            cbsInput.in_msg.FlagTransfer = '2';
            cbsInput.in_msg.Narration = 'DT:HSL DISB'+application.Loan_Account_Number__c != null? application.Loan_Account_Number__c:loanNo;
            cbsInput.in_msg.GLBranchCode =  '';    
                  
        } // v1.1 End
        getDisb(JSON.serialize(cbs),application,UpcbsLog,loanNo);
    }
    public static void getDisb(String disbData, genesis__Applications__c appIDPL,List<CBS_API_Log__c> UpcbsLog,string loanNo){
        system.debug('@@@@'+disbData);
        //genesis__Applications__c appIDPL = new genesis__Applications__c();
        //appIDPL = queryService.getApp(appID);
        
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('Branch_Disbursement_HL');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,disbData,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$ final update'+response.getBody());
        try{ 
           If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();            
            WS_CBS_Loan_Disbursment_HL.Loan_disbursment_Response res = (WS_CBS_Loan_Disbursment_HL.Loan_disbursment_Response)Json.deserialize(jsonString,WS_CBS_Loan_Disbursment_HL.Loan_disbursment_Response.class);
            System.debug(res);
            System.debug(res.out_msg.TransactionStatus);
            if(res.out_msg.TransactionStatus != null){  
                
                system.debug('##### not null '+ res.out_msg.TransactionStatus);
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = appIDPL.Id;
                log.API_Name__c = 'Loan_Disbursment_HL';
                log.Status__c = 'Success';
                log.Success_Error_Message__c = 'Success';
                log.Sequence_No__c = '20';
                UpcbsLog.add(log); // CBS_001 
                
                 //for third party
                Boolean runCASA;
                if(appIDPL.genesis__CL_Product_Name__c.contains('Co-Lending')){
                    runCASA = Third_Party_CBR_Codes__c.getValues(appIDPL.Sourced_By__c).Run_CASA_Disbursement__c;
                }else{
                    runCASA = false;
                }
                //
                
                if(appIDPL.SI_Bank_Name__c <> null && appIDPL.SI_Bank_Name__c == Constants.PL_SI_KVB && (((appIDPL.Record_Type_Name__c == Constants.HOMELOAN || appIDPL.Record_Type_Name__c==Constants.VL4W || appIDPL.Record_Type_Name__c==Constants.VL2W) && (!appIDPL.genesis__CL_Product_Name__c.contains('Co-Lending'))) || (appIDPL.genesis__CL_Product_Name__c.contains('Co-Lending') && runCASA == false))){                    
                    List <ID> appIds = new List<ID>();
                    appIds.add(appIDPL.Id);
                    system.debug('##### '+ appIds);
                    
                    CBS_SI_CreateHandler.CBS_SI_Creation(appIds,UpcbsLog,null); //Calling SI CBS API
                }else if(((appIDPL.Record_Type_Name__c == Constants.LAPLOAN || appIDPL.Record_Type_Name__c==Constants.PERSONALLOAN) && !appIDPL.genesis__CL_Product_Name__c.contains('Co-Lending')) || (appIDPL.genesis__CL_Product_Name__c.contains('Co-Lending') && runCASA == true)){
                    WS_CBS_CASA_Disbursement_Retail.CASA_request(appIDPL.id,UpcbsLog,string.valueOf(system.today()),loanNo);
                }
                else{
                    insert UpcbsLog; 
                
                //insert log;  
                if(((appIDPL.Record_Type_Name__c == Constants.HOMELOAN || appIDPL.Record_Type_Name__c==Constants.VL4W || appIDPL.Record_Type_Name__c==Constants.VL2W) && !appIDPL.genesis__CL_Product_Name__c.contains('Co-Lending')) || (appIDPL.genesis__CL_Product_Name__c.contains('Co-Lending') && runCASA == false)){
                    genesis__Applications__c ap = new genesis__Applications__c();
                    if(appIDPL.SI_Bank_Name__c <> null && appIDPL.SI_Bank_Name__c <> Constants.PL_SI_KVB){
                        ap.Installment_Type__c = 'E-mandate';
                    }
                    system.debug('##### ----- in PL / HL'+ appIDPL);
                    
                    ap.Id = appIDPL.Id;
                    ap.genesis__Disbursement_Date__c = system.today();
                    ap.Sub_Stage__c = 'Loan Account Opened';                    
                    ap.Retry_CBS__c = True; // Retry true means success 
                    update ap;
                    String usrId = TaskFlow_Helper.getBMList(appIDPL.Branch_Code__c,'Branch manager');
                    if(usrId !=null || usrId !=''){
                        TaskFlow_Helper.creatTaskAll(appIDPL.Id, usrId, 'SI/ E-mandate', 10);    
                    }
                }
                system.debug('##### out');
                }                                     
        }else{
            CBS_API_Log__c log = new CBS_API_Log__c();    
            log.Application__c = appIDPL.Id;
            log.API_Name__c = 'Loan_Disbursment_HL';
            log.Status__c = 'Failure';
            if(res.out_msg.ErrorMessage != null){
                log.Success_Error_Message__c = res.out_msg.ErrorMessage;
            }else{
                log.Success_Error_Message__c = 'Error';
            }                
            log.Sequence_No__c = '20';  
            UpcbsLog.add(log); // CBS_001  
            insert UpcbsLog;
            //insert log;
            genesis__Applications__c ap = new genesis__Applications__c();
            ap.Id = appIDPL.Id;
            ap.Loan_Account_Number__c = loanNo;
            //Commented on 30/11/2018 ap.Initiate_Disbursement__c = False;
            update ap;
        }
        
    }
        }catch(exception e){
            HandleBusinessException.captureError('Loan_Disbursment_HL','getDisb', e);
        }
}
}