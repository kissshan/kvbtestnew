/*
* Name      : WS_CBS_Loan_Creation_HL
* Compnay   : ET Marlabs
* Purpose   : For HL Service(Open Loan Account in CBS and Link customer) 
* Author    : Subas
*******************************************************************
* Modification : CBS_001 Add code for success response of all Single CBS APIs.
* Developer : Ashok 
*/
public class WS_CBS_Loan_Creation_HL {
    @future (Callout=true)
    public Static void createLoanF(String appId,Map<string,string>accMap){
        createLoan(appID,accMap);
    }    
    public static Void createLoan(String appId,Map<string,string>accMap){
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appId);
        Loan_Creation_Helper_HL cbs = new Loan_Creation_Helper_HL();
        cbs.inputVariables = new Loan_Creation_Helper_HL.cls_inputVariables();
        Loan_Creation_Helper_HL.cls_inputVariables cbsInput = new Loan_Creation_Helper_HL.cls_inputVariables();
        cbsInput.in_msg = new Loan_Creation_Helper_HL.cls_in_msg();
        cbs.exe_tenantId ='cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbs.inputVariables = cbsInput;
        cbsInput.in_msg.AssetValue = String.valueOf(application.Sanction_Authority_Limit__c);//String.valueOf(application.Total_Market_value__c);
        cbsInput.in_msg.BranchCode = application.Branch_Code__c;
        cbsInput.in_msg.Contribution = '0';
        cbsInput.in_msg.CustomerId = application.CustomerID__c;
        Decimal IntVar =0; 
        // PL Interest variance
        String PLCustID = '';
        if(application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
            LoanProcess_Config__mdt proFees = queryService.processingFee('PL');
            System.debug('profees:::'+profees);
            if(String.valueOf(proFees.Indx_Variance__c) <> null && String.valueOf(application.genesis__Interest_Rate__c) <> null)
                IntVar = application.genesis__Interest_Rate__c - proFees.Indx_Variance__c;
            
            /*if(accMap <> null)    
{
for(String str : accMap.keySet()){ PLCustID = accMap.get(str);}
cbsInput.in_msg.CustomerId = application.CustomerID__c != null ? application.CustomerID__c : PLCustID;
//accMap.clear();
}*/
        }
        else if(application.Record_Type_Name__c == Constants.LAPLOAN){
            if(String.valueOf(application.Interest_Variation__c) <> null){
                IntVar = application.Interest_Variation__c;
            }
        }
        else if(application.Record_Type_Name__c == Constants.HOMELOAN){
            IntVar =  VariationHL(application);
        }
        if(application.genesis__CL_Product_Name__c!=null){
            if(application.genesis__CL_Product_Name__c.contains('Co-Lending')){
                IntVar=application.Interest_Variation__c;
            }
        }
        // Code Added for ETB Treat as NTB will get Cust ID in Dedupe response CBS003
        if(accMap <> null)    
        {
            for(String str : accMap.keySet()){ 
                if(String.valueof(application.genesis__Account__c) == str)
                    PLCustID = accMap.get(str); // Primary Applicant Customer ID
            }
            cbsInput.in_msg.CustomerId = application.CustomerID__c != null ? application.CustomerID__c : PLCustID;
        }
        if(IntVar != null){
            cbsInput.in_msg.InterestVariance = String.valueOf(IntVar);
        }
        // cbsInput.in_msg.InterestVariance = String.ValueOf(application.Interest_Variation_HL__c);
        cbsInput.in_msg.LoanAmount = String.valueOf(application.Sanction_Authority_Limit__c);
        cbsInput.in_msg.LoanPurpose = String.valueOf(application.Loan_Purpose__c) != null ? String.valueOf(application.Loan_Purpose__c) : '';
        cbsInput.in_msg.LoanTerm = String.valueOf(application.Sanctioned_Tenure__c);
        cbsInput.in_msg.ProductCode = application.Product_Code__c;
        cbsInput.in_msg.ScheduleName = 'EMI MONTHLY';
        cbsInput.in_msg.TransactionBranch = application.Branch_Code__c;
        
        if(accMap != null){
            cbsLoanCreation(JSON.serialize(cbs),appId,accMap);
        }else{
            cbsLoanCreation(JSON.serialize(cbs),appId,null);
        }
        
    }
    public static void cbsLoanCreation(String cbsCrt,String ApplicationId,Map<string,string>accMap){
        System.debug('#######'+cbsCrt);
        List<Account> accountList = new List<Account>();
        String LoanAccountNo = '';
        // 3.8 : API 5 called if multiple applicant
        List<genesis__Application_Parties__c> partyLists = new List<genesis__Application_Parties__c>();
        partyLists = [Select Id,genesis__Party_Type__c,genesis__Party_Account_Name__c From genesis__Application_Parties__c Where genesis__Application__c =: ApplicationId AND Active__c = true AND Company__c = false];
        genesis__Applications__c ApplicationRecord = queryService.getApp(ApplicationId);
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>(); // CBS_001
        String DedupeCustIDs;
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Loan_Creation_HL');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,cbsCrt,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();            
                Loan_Creation_Helper_HL.Loan_creation_response res = (Loan_Creation_Helper_HL.Loan_creation_response)Json.deserialize(jsonString,Loan_Creation_Helper_HL.Loan_creation_response.class);
                System.debug(res);
                if(res.out_msg.ErrorMessage == null){
                    System.debug(res.out_msg.LoanResponse.AccountId);
                    if(!String.isBlank(res.out_msg.LoanResponse.AccountId)){ 
                        LoanAccountNo = res.out_msg.LoanResponse.AccountId;
                        // CBS_001 : CBS LoanCreation success response insert
                        CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                        CbsDedup.Application__c = ApplicationId;
                        CbsDedup.API_Name__c = 'Loan_Account_Creation';
                        CbsDedup.Status__c = 'Success';
                        CbsDedup.Success_Error_Message__c = 'LoanAccNo - '+LoanAccountNo;
                        CbsDedup.Failure_Error_Message__c = 'Request >> '+cbsCrt+' Response >> '+ String.valueOf(res);
                        CbsDedup.Sequence_No__c = '4';  
                        
                        UpcbsLog.add(CbsDedup);
                        CBS_API_Log__c logs = new CBS_API_Log__c();    
                        logs.Application__c = ApplicationId;
                        logs.API_Name__c = 'CBS_CUSTDetailUpdate_API';
                        logs.Status__c = 'Success';
                        logs.Success_Error_Message__c = 'Success';
                        logs.Sequence_No__c = '3.5';
                        UpcbsLog.add(logs); 
                        
                        if(partyLists.size() == 1){
                            if(ApplicationRecord.Record_Type_Name__c == Constants.PERSONALLOAN){
                                // For Personal Loan call CBR
                                WS_CBS_CBR_DTLS_HL.CBR_DTLSNEW(ApplicationId,LoanAccountNo,UpcbsLog);   //CBS_001
                            }else{
                                //Call Colleteral Creation
                                 if(ApplicationRecord.Sub_Type__c==Constants.Sub_Type_Top_Up)
                            	WS_CBS_Collateral_Linkage_HL.linkCollateral(ApplicationId,LoanAccountNo,UpcbsLog);
                       			 else
                       			 WS_CBS_Collateral_Creation.Collateral_Creation(ApplicationId,accMap,LoanAccountNo,UpcbsLog);
                               
                            }
                        }else{customerLinkage(LoanAccountNo,ApplicationId,accMap,UpcbsLog);} //CBS_001);}
                    }
                }
                else if(!String.isBlank(res.out_msg.ErrorMessage)){
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = ApplicationId;
                    log.API_Name__c = 'Loan_Account_Creation';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    log.Failure_Error_Message__c = 'Request >> '+cbsCrt+' Response >> '+ String.valueOf(res);
                    log.Sequence_No__c = '4';  
                    UpcbsLog.add(log);
                    system.debug('------'+accMap);
                    if(accMap != null){
                        if(accMap.size()>0){
                            for(String str : accMap.keySet()){
                                if(str.length()>=15){
                                    account acc = new account();
                                    acc.Id = str;
                                    if(accMap.get(str) != null || accMap.get(str) != ''){
                                        acc.CBS_Customer_ID__c = accMap.get(str);
                                        DedupeCustIDs+= accMap.get(str)+' ';
                                    }
                                    accountList.add(acc);
                                }
                            }
                            // CBS_001 : CBS Dedupe success response insert
                            CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                            CbsDedup.Application__c = ApplicationId;
                            CbsDedup.API_Name__c = 'CBS_Dedupe';
                            CbsDedup.Status__c = 'Success';
                            CbsDedup.Sequence_No__c = '1';  
                            CbsDedup.Success_Error_Message__c = 'Cust4ID - '+DedupeCustIDs;
                            UpcbsLog.add(CbsDedup);
                            if(accountList.size()>0){
                                update accountList;                
                            }
                        }  
                    }
					insert UpcbsLog;
                }
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = ApplicationId;
                log.API_Name__c = 'Loan_Account_Creation';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = 'LoanCreation_CBS_Error_No_Hit';
                log.Sequence_No__c = '4';  
                UpcbsLog.add(log);
                CBS_API_Log__c logs = new CBS_API_Log__c();    
                logs.Application__c = ApplicationId;
                logs.API_Name__c = 'CBS_CUSTDetailUpdate_API';
                logs.Status__c = 'Success';
                logs.Success_Error_Message__c = 'Success';
                logs.Sequence_No__c = '3.5';
                UpcbsLog.add(logs); 
				insert UpcbsLog;
            }
            
        }catch(exception e){
            HandleBusinessException.captureError('WS_CBS_Loan_Creation_HL','cbsLoanCreation', e);
        }
        
    }
    
    public Static Decimal VariationHL(genesis__Applications__c app){
        decimal IntVaraitaion;
        if(!Utility.ISStringBlankorNull(string.valueof(app.Max_CIBIL_Score__c))){
            if(app.Max_CIBIL_Score__c>=750){
                IntVaraitaion=ApplicationEligibiltyHandler.getMCLR(90,null,null) - ApplicationEligibiltyHandler.getMCLR(365,null,null);
            }
            else if(app.Max_CIBIL_Score__c<750){
                IntVaraitaion=app.Interest_Variation__c;
            }
        }
        
        return IntVaraitaion;
    }  
    
    
    /********************************Customer Linkage HL********************************/
    @future (Callout=true)
    public static void customerLinkageF(String loanNo, String appId,Map<string,string>accMap){
        List<CBS_API_Log__c> UpcbsLog =  new List<CBS_API_Log__c>();
        customerLinkage(loanNo,appId,accMap,UpcbsLog);
    }    
    public static void customerLinkage(String loanNo, String appId,Map<string,string>accMap,list<CBS_API_Log__c> UpcbsLog){
        List <Account> accList = queryService.accList(appId);
        genesis__Applications__c application = queryService.getApp(appId);
        if(loanNo ==null){
            loanNo = application.Loan_Account_Number__c;
        }        
        Map<String,String> partyMap = new Map<String,String>();
        List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();
        partyList = [Select Id,genesis__Party_Type__c,genesis__Party_Account_Name__c From genesis__Application_Parties__c Where genesis__Application__c =: appId AND Active__c = true AND Company__c = false];
        for(genesis__Application_Parties__c pt : partyList){
            partyMap.put(pt.genesis__Party_Account_Name__c,pt.genesis__Party_Type__c);
        }
        CBS_CustomerLinkage_Formatter.RequestFormat cbsReqObj = new CBS_CustomerLinkage_Formatter.RequestFormat();
        cbsReqObj.exe_tenantId      = 'cuecent_tenant';
        cbsReqObj.owner_tenantId    = 'cuecent_tenant';
        cbsReqObj.inputVariables    = new CBS_CustomerLinkage_Formatter.cls_inputVariables();
        cbsReqObj.inputVariables.in_msg = new CBS_CustomerLinkage_Formatter.cls_in_msg();
        cbsReqObj.inputVariables.in_msg.TransactionBranch = application.Branch_Code__c;
        cbsReqObj.inputVariables.in_msg.Mode = 'M';
        cbsReqObj.inputVariables.in_msg.ValueDateText = String.ValueOf(system.today().format()).replace('/','-'); //!= null ? String.ValueOf(system.today().format()).replace('/','-') : '';//'01-01-2018';
        
        List<CBS_CustomerLinkage_Formatter.cls_CustDetl> custDetailList = new List<CBS_CustomerLinkage_Formatter.cls_CustDetl>();
        Integer co_brr = 0;
        Integer gr_brr = 0;
        for(Account acc : accList){
            if(partyMap.get(acc.Id) == Constants.Co_Borrower){    
                co_brr++;
            }
            else if(partyMap.get(acc.Id) == Constants.Gurantor){
                gr_brr++;
            }
        }
        for(Account acc : accList){
            CBS_CustomerLinkage_Formatter.cls_CustDetl custDetail = new CBS_CustomerLinkage_Formatter.cls_CustDetl();
            custDetail.AccountNo = loanNo;
            custDetail.CustId1 = acc.CBS_Customer_ID__c;
            if(accMap != null){ //CBS005
                custDetail.CustId1 =accMap.get(acc.id)!=null?accMap.get(acc.id):acc.CBS_Customer_ID__c;
            }
            if(accList.size() == 1){
                custDetail.CustRel1 = 'SOW';
            }
            else if(co_brr == 0 && gr_brr > 0){
                if(application.genesis__Account__c == acc.Id){
                    custDetail.CustRel1 = 'SOW';
                }else if(partyMap.get(acc.Id) == Constants.Gurantor){
                    custDetail.CustRel1 = 'GUA';
                }
            }else{
                system.debug('^^partyMap^^'+partyMap+'^^acc.Id^^'+acc.Id);
                if(application.genesis__Account__c == acc.Id){
                    custDetail.CustRel1 = 'JOF';                
                }else if(partyMap.get(acc.Id) == Constants.Co_Borrower){                
                    custDetail.CustRel1 = 'JOO';
                }else if(partyMap.get(acc.Id) == Constants.Gurantor){
                    custDetail.CustRel1 = 'GUA';
                }
            }      
            custDetail.FlgDel = 'N';
            custDetailList.add(custDetail);
        }
        cbsReqObj.inputVariables.in_msg.CustDetl = custDetailList;
        customerLinkageCallout(JSON.serialize(cbsReqObj),appId,accMap,loanNo,UpcbsLog);//CBS_001););
        
    }
    //Helper method to make callout for Customer Linkage
    
    public static void customerLinkageCallout(String custData,String appId,Map<string,string>accMap,String loanNo,List<CBS_API_Log__c> UpcbsLog){
        List<Account> accountList = new List<Account>();
        String CustLinkRes = '';
        String DedupeCustIDs;
        KVB_Endpoint_URLs__c endPointUrl = KVB_Endpoint_URLs__c.getValues('CBS_CUST_LINKAGE');
        genesis__Applications__c AppIDPL = queryService.getApp(appId);
        if(endPointUrl != null){
            system.debug('####'+custData);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            String endPoint                                         = endPointUrl.Endpoint_URL__c;
            response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,custData,headerMap,label.CA_CERTIFICATE);
            system.debug('$$$$'+response.getBody());
            try{ 
                If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    String jsonString = response.getBody();
                    CBS_CustomerLinkage_Formatter.ResponseFormat res = (CBS_CustomerLinkage_Formatter.ResponseFormat)Json.deserialize(jsonString, CBS_CustomerLinkage_Formatter.ResponseFormat.class);
                    system.debug('###'+res.out_msg.ErrorMessage);
                    if(res.out_msg.ErrorMessage == null){
                        // CBS_001 : CBS Dedupe success response insert
                        CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                        CbsDedup.Application__c = AppId;
                        CbsDedup.API_Name__c = 'Loan_Account_Linkage';
                        CbsDedup.Status__c = 'Success';
                        CbsDedup.Sequence_No__c = '5';  
                        CbsDedup.Success_Error_Message__c = res.out_msg.ErrorMessage;
                        CbsDedup.Failure_Error_Message__c =  'Request >> '+custData+' Response >> '+ String.valueOf(res);
                        UpcbsLog.add(CbsDedup);
                        //Call Colleteral Creation
                        if(AppIDPL.Sub_Type__c==Constants.Sub_Type_Top_Up)
                            WS_CBS_Collateral_Linkage_HL.linkCollateral(appId,loanNo,UpcbsLog);
                        else
                        WS_CBS_Collateral_Creation.Collateral_Creation(appId,accMap,loanNo,UpcbsLog);
                    }else{
                        //CustLinkRes = res.out_msg.ErrorMessage;
                        CBS_API_Log__c log = new CBS_API_Log__c();    
                        log.Application__c = appId;
                        log.API_Name__c = 'Loan_Account_Linkage';
                        log.Status__c = 'Failure';
                        log.Success_Error_Message__c = res.out_msg.ErrorMessage+'('+loanNo+')';
                        log.Failure_Error_Message__c =  'Request >> '+custData+' Response >> '+ String.valueOf(res);
                        log.Sequence_No__c = '5';  
                        UpcbsLog.add(log); ////CBS_001
                        System.debug('UpcbsLog >>> ' + UpcbsLog);
                        //insert log;
                        if(accMap != null){
                            if(accMap.size()>0){
                                for(String str : accMap.keySet()){
                                    if(str.length()>=15){
                                        account acc = new account();
                                        acc.Id = str;
                                        if(accMap.get(str) != null || accMap.get(str) != ''){
                                            acc.CBS_Customer_ID__c = accMap.get(str);
                                            DedupeCustIDs+= accMap.get(str)+' ';
                                        }
                                        accountList.add(acc);
                                    }
                                }
                                // CBS_001 : CBS Dedupe success response insert
                                CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                                CbsDedup.Application__c = appId;
                                CbsDedup.API_Name__c = 'CBS_Dedupe';
                                CbsDedup.Status__c = 'Success';
                                CbsDedup.Sequence_No__c = '1';  
                                CbsDedup.Success_Error_Message__c = 'Cust5ID - '+DedupeCustIDs;
                                UpcbsLog.add(CbsDedup);
                                if(accountList.size()>0){
                                    update accountList;                
                                }
                            }
                        }
                        upsert UpcbsLog;
                        if(loanNo != null && appId !=null){
                            genesis__Applications__c a= new genesis__Applications__c();
                            a.Id = appId;
                            a.Loan_Account_Number__c = loanNo;
                            a.Interest_Variation__c = VariationHL(AppIDPL);
                            a.CBS_API_Sequence__c = '5'; //added here to update seq no 5 coz not updated through WFlow.
                            ApplicationTriggerHandler.IsFirstRun = False;
                            update a;
                        }
                    }
                }else{
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = appId;
                    log.API_Name__c = 'Loan_Account_Linkage';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = 'LoanLinkage_CBS_Error_No_Hit';
                    log.Sequence_No__c = '5';  
                    log.Failure_Error_Message__c =  'Request >> '+custData;
                    UpcbsLog.add(log); ////CBS_001
                    upsert UpcbsLog;
                }
            }catch(exception e){
                HandleBusinessException.captureError('WS_CBS_Loan_Creation_HL','customerLinkageCallout', e);
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = appId;
                log.API_Name__c = 'Loan_Account_Linkage';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = 'Exception '+e.getMessage();
                log.Failure_Error_Message__c =  'Request >> '+custData;
                log.Sequence_No__c = '5';  
                UpcbsLog.add(log); ////CBS_001
                upsert UpcbsLog;
            }
        }
        
    }
    
}