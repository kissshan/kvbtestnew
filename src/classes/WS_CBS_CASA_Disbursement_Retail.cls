/*
* Name      : WS_CBS_CASA_Disbursement_Retail
* Compnay   : ET Marlabs
* Purpose   : For Retail Service(CASA Disbursment) 
* Author    : Venu
-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
v1.1        14-Dec-2018     Braj            Added LoanAccountNumber tag and passing its value to CBS
*******************************************************************************************/
public class WS_CBS_CASA_Disbursement_Retail {
    // Request
    public class CBS_CASA_Request{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String ApplicationNumber;    //a4V7F000000RznOUAJ
        public String LoanAmount;   //3836.62
        public String SB_AccountNumber; //1211155000100329
        public String TransactionDate;  //27/11/2018
        public String BranchCode;   //1717
        public String Narration;    //DT:HSL DISB1463777000000022
        public String LoanAccountNumber;//v1.1    //1235655000100329
    }
    
    // Response
    public class CASA_Response{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;   //Success
    }
    public class cls_out_msg {
        public String CBSReferenceNo;   //2017100400010173
        public String ApplicationNumber;    //a4V0l0000004HqiEAE
        public String ErrorCode;    //0
        public String ErrorMessage; //Success
    }
    // Prepare Request
    public static void CASA_request(String appID,List<CBS_API_Log__c> UpcbsLog,string DisbDate,string loanNo){
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appID);
        WS_CBS_CASA_Disbursement_Retail.CBS_CASA_Request cbs= new WS_CBS_CASA_Disbursement_Retail.CBS_CASA_Request();
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbs.inputVariables = new WS_CBS_CASA_Disbursement_Retail.cls_inputVariables();
        WS_CBS_CASA_Disbursement_Retail.cls_inputVariables cbsInput = new WS_CBS_CASA_Disbursement_Retail.cls_inputVariables();
        cbsInput.in_msg = new WS_CBS_CASA_Disbursement_Retail.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbsInput.in_msg.ApplicationNumber=application.id;
        cbsInput.in_msg.LoanAmount=String.ValueOf(application.Disbursement_Amount__c);
        string AccNumber='';
        if(!Utility.ISStringBlankorNull(application.Disbursement_Account_Number__c)){
            AccNumber=application.Disbursement_Account_Number__c;
        }
        else if(application.Record_Type_Name__c==Constants.LAPLOAN){
            AccNumber=application.CASA_Account_No__c;
        }
        cbsInput.in_msg.LoanAccountNumber = application.Loan_Account_Number__c  != null? application.Loan_Account_Number__c:loanNo ;//v1.1
        cbsInput.in_msg.SB_AccountNumber=AccNumber;
        Date dt = date.valueOf(DisbDate);
        cbsInput.in_msg.TransactionDate= '10/11/2018';//DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('dd/MM/YYYY');//braj:date formatting
        cbsInput.in_msg.BranchCode=application.Branch_Code__c;
        
        if(application.Record_Type_Name__c == Constants.LAPLOAN){
            cbsInput.in_msg.Narration = 'DT:LAP DISB'+application.Loan_Account_Number__c  != null? application.Loan_Account_Number__c:loanNo;
        }else if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
            cbsInput.in_msg.Narration = 'DT:PL DISB'+application.Loan_Account_Number__c  != null? application.Loan_Account_Number__c:loanNo;    
        }else if(application.Record_Type_Name__c == Constants.HOMELOAN && application.genesis__CL_Product_Name__c.contains('Co-Lending')){ //added for 3rd party loan applications
            cbsInput.in_msg.Narration = 'DT:HSL DISB'+application.Loan_Account_Number__c  != null? application.Loan_Account_Number__c:loanNo; 
        }else if(application.Record_Type_Name__c == Constants.VL2W && application.genesis__CL_Product_Name__c.contains('Co-Lending')){ //added for 3rd party loan applications
            cbsInput.in_msg.Narration = 'DT:VL2W DISB'+application.Loan_Account_Number__c  != null? application.Loan_Account_Number__c:loanNo; 
        }else if(application.Record_Type_Name__c == Constants.VL2W && application.genesis__CL_Product_Name__c.contains('Co-Lending')){ //added for 3rd party loan applications
            cbsInput.in_msg.Narration = 'DT:VL4W DISB'+application.Loan_Account_Number__c  != null? application.Loan_Account_Number__c:loanNo; 
        }
        
        callgetCASA(JSON.serialize(cbs),application,UpcbsLog,loanNo); 
    }
    public static void callgetCASA(string CasaData,genesis__Applications__c appIDPL ,List<CBS_API_Log__c> UpcbsLog,string loanNo){
        system.debug('@@@@'+CasaData);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Disbu_CASA'); 
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,CasaData,headerMap,label.CA_CERTIFICATE); 
        system.debug('#####'+response);
        system.debug('$$$$ final update'+response.getBody());
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                WS_CBS_CASA_Disbursement_Retail.CASA_Response res=(WS_CBS_CASA_Disbursement_Retail.CASA_Response)Json.deserialize(jsonString,WS_CBS_CASA_Disbursement_Retail.CASA_Response.class);
                System.debug(res);
                System.debug(res.out_msg.ErrorMessage);
                if(res.out_msg.ErrorCode=='0' && res.out_msg.ErrorMessage=='Success'){
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = appIDPL.Id;
                    log.API_Name__c = 'CBS_CASA_API';
                    log.Status__c = 'Success';
                    log.Success_Error_Message__c = 'Success';
                    log.Sequence_No__c = '20.5';
                    UpcbsLog.add(log); // CBS_001 
                    system.debug('appIDPL.SI_Bank_Name__c'+appIDPL.SI_Bank_Name__c);
                    if(appIDPL.SI_Bank_Name__c <> null && appIDPL.SI_Bank_Name__c == Constants.PL_SI_KVB && (appIDPL.Record_Type_Name__c == Constants.LAPLOAN || appIDPL.Record_Type_Name__c==Constants.PERSONALLOAN || appIDPL.genesis__CL_Product_Name__c.contains('Co-Lending'))){
                        List <ID> appIds = new List<ID>();
                        appIds.add(appIDPL.Id);
                        CBS_SI_CreateHandler.CBS_SI_Creation(appIds,UpcbsLog,loanNo); //Calling SI CBS API
                    }
                    else{
                        if(appIDPL.Record_Type_Name__c == Constants.PERSONALLOAN ||  appIDPL.Record_Type_Name__c==Constants.LAPLOAN || appIDPL.genesis__CL_Product_Name__c.contains('Co-Lending')){
                            genesis__Applications__c ap = new genesis__Applications__c();
                            if(appIDPL.SI_Bank_Name__c <> null && appIDPL.SI_Bank_Name__c <> Constants.PL_SI_KVB){
                                ap.Installment_Type__c = 'E-mandate';
                            }
                            system.debug('##### ----- in PL / HL'+ appIDPL);
                            
                            ap.Id = appIDPL.Id;
                            ap.genesis__Disbursement_Date__c = system.today();
                            ap.Sub_Stage__c = 'Loan Account Opened';                    
                            ap.Retry_CBS__c = True; // Retry true means success 
                            if(loanNo != null && loanNo != '')
                               {ap.Loan_Account_Number__c = loanNo ;}
                            update ap;
                            insert UpcbsLog;
                            String usrId = TaskFlow_Helper.getBMList(appIDPL.Branch_Code__c,'Branch manager');
                            if(usrId !=null || usrId !=''){
                                TaskFlow_Helper.creatTaskAll(appIDPL.Id, usrId, 'SI/ E-mandate', 10);    
                            }
                        }
                    }
                }
                else{
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = appIDPL.id;//App.Id;
                    log.API_Name__c = 'CBS_CASA_API';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    log.Sequence_No__c = '20.5';
                    log.Reason_Code__c = res.out_msg.ErrorCode;
                    log.Reason_Message__c = res.out_msg.ErrorMessage;
                    UpcbsLog.add(log); // CBS_001
                    insert UpcbsLog;
                    system.debug('UpcbsLog--->'+UpcbsLog);//added by Bhavya
                    
                    // for pre approved loan  
                    if(loanNo != null && appIDPL !=null){
                        genesis__Applications__c a= new genesis__Applications__c();
                        a.Id = appIDPL.id;
                        a.Loan_Account_Number__c = loanNo;                    
                        update a;
                    }
                    
                }
            }
        }
        catch(exception e){
            HandleBusinessException.captureError('WS_CBS_CASA_Disbursement_Retail','callgetCASA', e);
        }
        
    }
}