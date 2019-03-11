/*
@name         : CBS_SI_CreateHandler
@description  : CBS SI Create API Handler class 
@author       : Ashok

-----------------------------------------------------------------------
Version     Date            Author          Remarks                                                 
=======     ==========      =============   ==================================
v1.1        13-Feb-2019     Braj            #HL MVP2:Replaced query service to get collateral and task records; removed appln close condition for all product to create FEC task at loan acc opened
*******************************************************************************************/

public with sharing class CBS_SI_CreateHandler {
    
    public static void CBS_SI_Creation(List<Id> updatedAppIdList,List<CBS_API_Log__c> UpcbsLog,string loanNo){ 
        List<genesis__Applications__c> updatedAppList = new List<genesis__Applications__c>();        
        updatedAppList = [SELECT Id,Record_Type_Name__c,Loan_Account_Number__c,genesis__Payment_Amount__c,SI_Account_Number__c,SI_Bank_Name__c FROM genesis__Applications__c WHERE Id IN :updatedAppIdList];
        DateTime yourDate = Datetime.now();
        String dateOutput = yourDate.format('dd/MM/yyyy');
        
        
        for(genesis__Applications__c app : updatedAppList){
            if(app.SI_Bank_Name__c <> null && app.SI_Bank_Name__c == Constants.PL_SI_KVB) {
                CBS_SI_CreationPL cbs = new CBS_SI_CreationPL();
                cbs.exe_tenantId = 'cuecent_tenant';
                cbs.owner_tenantId = 'cuecent_tenant';
                cbs.inputVariables = new CBS_SI_CreationPL.cls_inputVariables();
                cbs.inputVariables.in_msg = new CBS_SI_CreationPL.cls_in_msg();
                cbs.inputVariables.in_msg.TransactionBranch = '';
                cbs.inputVariables.in_msg.UserReferenceNumber = '';
                cbs.inputVariables.in_msg.AccountNo = app.Loan_Account_Number__c != null ? app.Loan_Account_Number__c : loanNo;
                cbs.inputVariables.in_msg.TsfFrmCasa = 'Y';
                cbs.inputVariables.in_msg.CasaAcctNo = string.valueOf(app.SI_Account_Number__c);
                cbs.inputVariables.in_msg.SalChkCredit = 'N';
                cbs.inputVariables.in_msg.EmployerCode = '';
                cbs.inputVariables.in_msg.SalCreditDrwDown = 'N';
                cbs.inputVariables.in_msg.SalCreditPct = '';
                cbs.inputVariables.in_msg.Mode = 'A';
                System.debug('##### input data '+ cbs);
                SICreationCallOut(JSON.serialize(cbs),app.id,UpcbsLog,loanNo);
            }
        }
        
    }
    
    
    //Helper method to make callout for CustomerId Creation
    /*  @future(callout = true)
    public static void SICreationCallOutF(String custData,String app){
    SICreationCallOut(custData,app);
    } */
    public static void SICreationCallOut(String custData,String app,List<CBS_API_Log__c> UpcbsLog,string loanNo){
        System.debug('####'+custData);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_SI_API'); 
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,custData,headerMap,label.CA_CERTIFICATE);
        System.debug('$$$$'+response.getBody());
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();            
                // Add response structure of SI after request - Pending from CBS
                CBS_SI_CreationPL res = (CBS_SI_CreationPL)Json.deserialize(jsonString,CBS_SI_CreationPL.class);
                System.debug('SI Response Data: '+ res);
                // Send Email on loan account open 
                genesis__Applications__c application = new genesis__Applications__c();
                //application = queryService.getApp(app);//v1.1
                application = queryService.getApplication(app);//v1.1
                genesis__Applications__c ap = new genesis__Applications__c();
                if(integer.valueof(res.out_msg.ErrorCode) == 0){
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = app;//App.Id;
                    log.API_Name__c = 'CBS_SI_API';
                    log.Status__c = 'Success';
                    log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    log.Sequence_No__c = '21';  
                    UpcbsLog.add(log);  // CBS_001
                    insert UpcbsLog; // CBS_001
                    //insert log; 
                    System.debug('record type'+application.Record_Type_Name__c);
                    if(application.Record_Type_Name__c  == Constants.PERSONALLOAN || application.Record_Type_Name__c  == Constants.HOMELOAN || application.Record_Type_Name__c==Constants.VL4W || application.Record_Type_Name__c==Constants.VL2W){
                        ap.Sub_Stage__c = Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE;

                        //v1.1(start)
                        /*if(application.Loan_Purpose__c==Constants.Construction || application.Loan_Purpose__c==Constants.RepairHouse)
                            ap.Sub_Stage__c = Constants.App_Process_Closed;
                        
                        if (application.Record_Type_Name__c  == Constants.PERSONALLOAN && application.Is_GMRA_Policy_Selected__c) {
                            ap.Application_Stage__c = Constants.DISBURSED_APPLICATION_MAINSTAGE;
                            ap.Sub_Stage__c = Constants.App_Process_Closed;       
                        }*/
                        //v1.1(end)
                        ap.genesis__Disbursement_Date__c = System.today();
                    } 
                    else{
                        if(application.Record_Type_Name__c!=Constants.VL4W || application.Record_Type_Name__c!=Constants.VL2W){
                            //ap.Application_Stage__c = Constants.DISBURSED_APPLICATION_MAINSTAGE;
                            //ap.Sub_Stage__c = Constants.App_Process_Closed;
                            ap.Sub_Stage__c = Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE;//v1.1
                        } 
                    }
                    
                    ap.Id = app;//app.Id;
                    ap.Retry_CBS__c = True; // Retry true means success
                    //ap.SI_Applicant__c = res.out_msg.Response.AcctpayInstrResponse.CustomerName != null ? res.out_msg.Response.AcctpayInstrResponse.CustomerName : '';
                    ap.Status__c = res.out_msg.ErrorMessage;
                    if(loanNo != null && loanNo != '')
                        {ap.Loan_Account_Number__c = loanNo;}
                    //ApplicationTriggerHandler.IsFirstRun = False;
                    update ap;
                }else{
                    
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = app;//App.Id;
                    log.API_Name__c = 'CBS_SI_API';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.Failure.ErrorMessage;
                    log.Sequence_No__c = '21';
                    log.Reason_Code__c = res.out_msg.Failure.Reason.Code;
                    log.Reason_Message__c = res.out_msg.Failure.Reason.Message;
                    UpcbsLog.add(log); // CBS_001
                    insert UpcbsLog;
                    //insert log;
                    ap.Id = app;
                    ap.Error_Reason_si__c = res.out_msg.Failure.Reason.Message;
                    ap.Status__c = res.out_msg.ErrorMessage;
                    ap.Sub_Stage__c = 'Loan Account Opened';  
                    if(loanNo != null && loanNo != '')
                    {ap.Loan_Account_Number__c = loanNo;} 
                    //ap.SI_Applicant__c = res.out_msg.Response.AcctpayInstrResponse.CustomerName != null ? res.out_msg.Response.AcctpayInstrResponse.CustomerName : '';
                    ApplicationTriggerHandler.IsFirstRun = False;
                    update ap;
                }      
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = app;//App.Id;
                log.API_Name__c = 'CBS_SI_API';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = 'CBS_SI_API_Not Hit';
                log.Sequence_No__c = '21';  
                UpcbsLog.add(log);  // CBS_001
                insert UpcbsLog; // CBS_001          
                //for pre approved loan
                if(loanNo != null && app !=null){
                    genesis__Applications__c a= new genesis__Applications__c();
                    a.Id = app;
                    a.Loan_Account_Number__c = loanNo;                    
                    update a;
                }
                
            }
        }catch(Exception e){
            System.debug('Exception - '+e.getMessage()+' '+e.getStackTraceString()+' Line No : '+e.getLineNumber());
            HandleBusinessException.captureError('CBS_SI_API','SICreationCallOut', e);
        }
    }
}