/*
* Name          : WS_PerfiosRequestProcess
* Description   : Web service to push perfios data into LOS
* Author        : Dushyant
*/
@RestResource(urlMapping='/pushPerfiosData')
global class WS_PerfiosRequestProcess {
    public static String appId = '';
    //extending response structure
    global class Response extends WS_Response{
        public Response(){}
    }

   
     //handeling POST request
    @HttpPost
    global static Response handlePerfiosRequest(String jsonString){   
        /*RestRequest req     = Restcontext.Request;*/
        Response res        = new Response();
        SavePoint sp       = Database.setSavepoint();
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        //check for null request
        /*if(req == null || req.requestBody == null){
            sendEmail('','','',Constants.WS_REQ_BODY_IS_NULL);
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);                     
        }else{*/
            try{
                //String jsonString             = req.requestBody.toString();
                if(jsonString == null || jsonString == ''){
                    sendEmail('','','',Constants.WS_REQ_BODY_IS_NULL);
                    return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);                    
                }
                else{
                    String fetchedFiscalYear = '';
                    Integer fetchedFiscalYearInt;
                    String fiscalYear;
                    List<Perfios__c> perfios = new List<Perfios__c>();
                    Map<String, Object> reqObj       = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                    String trId             = (String)reqObj.get('transaction_id');
                    Map<String, Object> fContent     = (Map<String,Object>)reqObj.get('file_content');                    
                    Map<String, Object> fStatementObj   = (Map<String,Object>)fContent.get('FinancialStatement');
                    String custId;
                    //Object custId            = fStatementObj.get('Organisation');
                    //Map<String,String> custIdMap    = (Map<String,String>)fStatementObj.get('Organisation');
                    
                    Map<String, Object> ratiosObj     = (Map<String,Object>)fStatementObj.get('Ratios');
                    Map<String, Object> fYearObj;
                    Map<String, Object> fYearObjPrev;
                    
                    System.debug(trId);
                    //System.debug(custId);
                    //List<Account> accList = new List<Account>();
                    String accId;
                    perfios = [SELECT Id,Applicant_Name__r.CBS_Customer_ID__c,Application__c,Application__r.RecordType.developerName,Fiscal_Year__c,Applicant_Name__c,Data_received_for_financial_year__c,Report_Type__c FROM Perfios__c WHERE Transaction_Id__c =:trId];
                    custId= perfios[0].Applicant_Name__r.CBS_Customer_ID__c;
                    accId= perfios[0].Applicant_Name__c; 
                    /*accList = [SELECT Id,(SELECT Application_Stage__c,RecordType.DeveloperName,CommercialPR_Stage__c,Qualitative_input_done__c,List_Matching_Stage__c FROM genesis__Applications_account__r WHERE recordType.DeveloperName =: perfios[0].Application__r.RecordType.developerName AND Active__c = true LIMIT 1) FROM Account WHERE CBS_Customer_ID__c =: String.valueOf(custId)];
                    
                    if(accList.size() == 0){
                        sendEmail(trId,String.valueOf(custId),'Customer Id not recognized!!!','');
                        RETURN getWSResponse(res, Constants.WS_ERROR_STATUS,'', Constants.WS_ERROR_CODE, 'Customer Id not recognized!!!');
                    }
                    else*/ 
                    if(perfios.size() == 0){
                        sendEmail(trId,String.valueOf(custId),'Transaction Id not recognized!!!','');
                        RETURN getWSResponse(res, Constants.WS_ERROR_STATUS,'', Constants.WS_ERROR_CODE, 'Transaction Id not recognized!!!');
                    }
                    else{
                        /*for(Account acc : accList){
                            if(!acc.genesis__Applications_account__r.isEmpty()){
                                for(genesis__Applications__c app : acc.genesis__Applications_account__r){
                                    appList.add(app);
                                }
                            }
                        }*/
                        appList= [SELECT Application_Stage__c,RecordType.DeveloperName,CommercialPR_Stage__c,Qualitative_input_done__c,List_Matching_Stage__c,BRE_Done__c FROM genesis__Applications__c WHERE recordType.DeveloperName =: perfios[0].Application__r.RecordType.developerName AND Active__c = true AND genesis__Account__r.CBS_Customer_ID__c=:custId AND Id=: perfios[0].Application__c  LIMIT 1]; 
                    }
                    //Get fiscal year from the request
                    for(String key : fStatementObj.keySet()){
                        if(key.contains('FY')) fetchedFiscalYear = key;
                    }
                    if(fetchedFiscalYear == ''){
                        if(!appList.isEmpty()){
                            //updateAppStatus(appList,false);
                            updatePerfiosStatus(perfios[0].Id,'Fiscal year is not in correct format');
                        }
                        sendEmail(trId,String.valueOf(custId),'Fiscal year is not in correct format','');
                        //return error message
                        RETURN getWSResponse(res, Constants.WS_ERROR_STATUS,'', Constants.WS_ERROR_CODE, 'Fiscal year is not in correct format');
                    }
                    else{
                        
                        try{
                            fetchedFiscalYearInt = Integer.valueOf(fetchedFiscalYear.subString(fetchedFiscalYear.length()-4,fetchedFiscalYear.length()));
                            fiscalYear = (fetchedFiscalYearInt-1)+'-'+Integer.valueOf(fetchedFiscalYear.subString(fetchedFiscalYear.length()-2,fetchedFiscalYear.length()));
                        }
                        catch(Exception e){
                            if(!appList.isEmpty()){
                                //updateAppStatus(appList,false);
                                updatePerfiosStatus(perfios[0].Id,'Fiscal year is not in correct format');
                            }
                            sendEmail(trId,String.valueOf(custId),'Fiscal year is not in correct format','');
                            RETURN getWSResponse(res, Constants.WS_ERROR_STATUS,'', Constants.WS_ERROR_CODE, 'Fiscal year is not in correct format');
                        }
                        if(perfios.isEmpty()){
                            //Insert untagged perfios data
                            Perfios__c perf = new Perfios__c(Transaction_Id__c = trId,Fiscal_Year__c = fiscalYear,Applicant_Name__c = accId,Report_Type__c = 'Actual');
                            INSERT perf;
                            perfios.add(perf);
                            //Insert Data
                            parse_insert_PerfiosData(fetchedFiscalYear,jsonString,perfios[0].Id);
                        }
                        else{
                            if(perfios[0].Fiscal_Year__c == fiscalYear){
                                if(!appList.isEmpty()){
                                    //updateAppStatus(appList,false);
                                    updatePerfiosStatus(perfios[0].Id,'Perfios data already exist for financial year against pushed Transaction id');
                                }
                                sendEmail(trId,String.valueOf(custId),'Perfios data already exist for financial year against pushed Transaction id','');
                                return getWSResponse(res, Constants.WS_SUCCESS_STATUS,'Perfios data already exist for financial year against pushed Transaction id', Constants.WS_SUCCESS_CODE,'');                   
                            }
                            else{
                                //Insert Data
                                perfios[0].Fiscal_Year__c = fiscalYear;
                                perfios[0].Perfios_Status__c= 'Completed';
                                parse_insert_PerfiosData(fetchedFiscalYear,jsonString,perfios[0].Id);
                                UPDATE perfios[0];
                            }
                        }
                    }
                    // 
                    try{
                        if(!appList.isEmpty()){
                            if(perfiosDoneCheck(appList[0].Id))
                                updateAppStatus(appList,true);
                            //updatePerfiosStatus(perfios[0].Id,'');
                        }
                        M68C_Computator.calculateM68Data(accId,fiscalYear,perfios[0].Report_Type__c,custId);
                    }
                    catch(Exception e){
                        System.debug(e.getMessage());
                        System.debug(e.getLineNumber());
                        RETURN getWSResponse(res, Constants.WS_SUCCESS_STATUS,'Success', Constants.WS_SUCCESS_CODE,'');  
                    }
                }
            }catch(Exception e){
                System.debug(e.getLineNumber());
                //sendEmail('','','', e.getMessage());
                RETURN getWSResponse(res, Constants.WS_ERROR_STATUS,null, Constants.WS_ERROR_CODE, e.getMessage());                   
            }
        //}
        return res;
    }
    //Update  status of the  perfios data :added by - Vignesh
    public static void updatePerfiosStatus(String perId,String errorMsg){
        Perfios__c perRec= new Perfios__c(Id=perId);
        perRec.Perfios_Status__c= 'Error';
        perRec.Error_Message__c= errorMsg;
        update perRec;
    }
    public static void updateAppStatus(List<genesis__Applications__c> appList,Boolean errorStatus){
        Set<Id> appIdSet = new Set<Id>();
        Boolean personCibilFlag = true;
        List<genesis__Application_Parties__c> partyList = new List<genesis__Application_Parties__c>();
        for(genesis__Applications__c app : appList){
            if(errorStatus & app.RecordType.DeveloperName =='SME_Renewal'){
                app.Application_Stage__c = 'Perfios output done';
                app.Perfios_Captured__c = true;
                appId    =  app.Id;  
            }else if(errorStatus & app.RecordType.DeveloperName !='SME_Renewal'){
            	app.Perfios_Captured__c = true;
                appId    =  app.Id;    
            }  
            else app.Application_Stage__c = 'Perfios error';
            appIdSet.add(app.Id);
        }
        ApplicationTriggerHandler.IsFirstRun = false;
        UPDATE appList;

        //close clpc task.
        if(errorStatus && appId !=null && appId != ''){
            try{
                Underwriting_CTRL_Helper.closeExistingCLPCTask(appId,'Financial Upload');
            }catch(Exception ex){
                System.debug('Exception::'+ex.getMessage() +' Line Number'+ ex.getLineNumber());
            }
        }
        
        partyList = [SELECT id,genesis__Party_Account_Name__r.CIBIL_Score__c FROM genesis__Application_Parties__c where genesis__Application__c IN : appIdSet ];
        for(genesis__Application_Parties__c party :  partyList){
            if(party.genesis__Party_Account_Name__r.CIBIL_Score__c == null) personCibilFlag = false;
        }
        for(genesis__Applications__c app : appList){
            //Secound parameter to specify if its BRE first run
            if(errorStatus && app.RecordType.DeveloperName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT && ! app.BRE_Done__c){
                ApplicationTriggerHelper.runBREAfteANDCheckCollateral(app.Id);
            }
            else if(errorStatus && ! app.BRE_Done__c){
                SME_BRE_Score_Calculator.runBRERule(app,false);
            }
        }
        //if(!errorStatus) ApplicationTriggerHelper.deleteFinancialDataHelper(appList);
    }
    //method to parse/insert perfios data
    public static void parse_insert_PerfiosData(String fetchedFiscalYear, String jsonString, Id perfiosId){
        Map<String, Object> reqObj       = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        Map<String, Object> fContent     = (Map<String,Object>)reqObj.get('file_content');                    
        Map<String, Object> fStatementObj   = (Map<String,Object>)fContent.get('FinancialStatement');
        Map<String, Object> ratiosObj     = (Map<String,Object>)fStatementObj.get('Ratios');  
        Map<String, Object> fYearObj;
        PerfiosStructureBuilder.RatiosParse ratioParsedObj;
        //Parsing Ratio and insert
        ratioParsedObj = PerfiosStructureBuilder.ratioParser(JSON.serialize(ratiosObj.get(fetchedFiscalYear)));
        if(ratioParsedObj != null){
            PerfiosRequestHandler.inserRatios(ratioParsedObj,perfiosId);    
        }
        
        //CashFlowStatement handling
        PerfiosStructureBuilder.CashFlowStatementParse cfsParsedObj = PerfiosStructureBuilder.cfsParser(JSON.serialize(fStatementObj.get('CashFlowStatement')));
        if(cfsParsedObj != null){
            PerfiosRequestHandler.inserCFS(cfsParsedObj,perfiosId);  
        }
        
        //FY handling
        fYearObj = (Map<String,Object>)fStatementObj.get(fetchedFiscalYear);
        if(fYearObj != null){
            //P&L handling
            PerfiosStructureBuilder.ProfitAndLossParse plParsedObj     = PerfiosStructureBuilder.plParser(JSON.serialize(fYearObj.get('ProfitAndLoss')));
            if(plParsedObj != null){
                PerfiosRequestHandler.inserPL(plParsedObj,perfiosId);    
            }
            //BalanceSheet handling
            PerfiosStructureBuilder.BalanceSheetParse bSheetParsedObj   = PerfiosStructureBuilder.bSheetParser(JSON.serialize(fYearObj.get('BalanceSheet')));
            if(bSheetParsedObj != null){
                PerfiosRequestHandler.inserBSheet(bSheetParsedObj,perfiosId);    
            }
        }
    }
    //method to prepare response structure
    static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg){
        res.status           = status;
        res.successMessage   = succMsg;
        res.statusCode       = statusCode;
        res.errorMessage     = errMsg;
        return res;
    }
    public static void sendEmail(String txId, String custId,String errorMsg,String msgBody){
        List<String> emailAddList = new List<String>();
        String emailSubject = 'Perfios process failed!';
        String body = 'Error coocured while processing financial data recieved from Perfios';
        if(msgBody == ''){
            body += ' for Customer: '+custId+' and Transanction Id- '+txId;
            if(errorMsg != '' && errorMsg != null){
                body += ', as the error has happened for: '+errorMsg;
            }
        }
        else
            body += ' as the error occured as: '+msgBody;
        
        emailAddList = KVB_Company_Details__c.getOrgDefaults().Admin_email__c.split(';');
        System.debug('emailAddList:::'+emailAddList.size());
        for(String toAdd : emailAddList){
            System.debug(toAdd);
        }
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = emailAddList;
        message.setSubject(emailSubject);
        message.setReplyTo('support@kvb.com');
        message.setSenderDisplayName('KVB TEAM');
        message.setBccSender(false);
        message.setHtmlBody(body);
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }

    //added by - Vignesh
    public static Boolean perfiosDoneCheck(String appId){
        List<Perfios__c> perLst= [SELECT id,Perfios_Status__c FROM Perfios__c WHERE Perfios_Status__c <> 'Completed' AND Application__c=: appId];
        if(perLst.size()>0){
            return false;
        }else{
            return true;
        }
    }
}