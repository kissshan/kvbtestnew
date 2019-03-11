/*
* Name      : SME_perfiosReportBatch
* Compnay   : ET Marlabs
* Purpose   : getting the Financial Report data from DMS 
* Author    : Vignesh
*/
global class SME_perfiosReportBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global final String query;
    global String auth;
    global String endPoint;
    String appId = '';
    global Set<String> txnIdSet= new Set<String>();
    global SME_perfiosReportBatch() {
        query= 'SELECT Id,genesis__Application__c,genesis__Application__r.genesis__Account__c,Transaction_Id__c,Success_Error_Msg__c FROM genesis__Application_Document_Category__c WHERE Transaction_Id__c <> null AND Success_Error_Msg__c= \'Financial Data Processing Completed\' ';
    }
    global SME_perfiosReportBatch(String query){
        this.query= query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<genesis__Application_Document_Category__c> scope) {
        Set<String> successTxIdSet = new Set<String>();
        Set<String> FailedTxIdSet= new Set<String>();
        Map<String,genesis__Application_Document_Category__c> trIdDocCatMap = new Map<String,genesis__Application_Document_Category__c>();
        try{
            for(genesis__Application_Document_Category__c appDocCat : scope){
                trIdDocCatMap.put(appDocCat.Transaction_Id__c,appDocCat);
            }
            for(String trId: trIdDocCatMap.keySet()){
                auth= WS_ApiGatewayAccToken.getAccTkn();
                endPoint=Utility.getFullEndpoints('Perfios_Financial_Report')+trId;
                HTTPResponse response = new HTTPResponse();
                Map<String,String> headerMap = new Map<String,String>(); 
                headerMap.put('Authorization',auth);
                System.debug('headerMap==> '+headerMap);
                response = HttpUtility.sendHTTPRequest(endPoint, 'GET', null,null,headerMap,null);
                String jsonData = response.getBody();
                System.debug('jsonData String== '+jsonData);
                if(response.getStatuscode()== 200){
                    
                    //Create Perfios Record\\
                    genesis__Application_Document_Category__c appdocRec= trIdDocCatMap.containskey(trId) && trIdDocCatMap.get(trId)!=null ? trIdDocCatMap.get(trId) : null;
                    if(appdocRec!=null){
                        Perfios__c  per= new Perfios__c();
                        per.Transaction_Id__c= trId;
                        per.Application__c= appdocRec.genesis__Application__c;
                        per.Application_id__c= appdocRec.genesis__Application__c;
                        per.Applicant_Name__c= appdocRec.genesis__Application__r.genesis__Account__c;
                        Insert per;
                    }
                    
                    
                    
                    
                    successTxIdSet.add(trId);
                    trIdDocCatMap.get(trId).Success_Error_Msg__c= 'Financial Data Received';
                    WS_PerfiosRequestProcess.handlePerfiosRequest(jsonData);
                }else{
                    FailedTxIdSet.add(trId);
                    appId = trIdDocCatMap.get(trId).genesis__Application__c;
                    PerfiosJsonRequestResponsee.financialReportRes reportRes= (PerfiosJsonRequestResponsee.financialReportRes)Json.deserialize(jsonData, PerfiosJsonRequestResponsee.financialReportRes.class);
                    trIdDocCatMap.get(trId).Success_Error_Msg__c =   'Error: '+reportRes.errorMessage;//'Report Generation Failed'; //appDocJn.Success_Error_Msg__c!= null? appDocJn.Success_Error_Msg__c+', Report Generation Failed' :
                }
            }
            if(appId != ''){
                List<Task> tskLst= [SELECT id,whatId,Status FROM Task WHERE whatId =: appId AND Type= 'Financial Upload'];
                for(Task t: tskLst){
                    t.Status= 'Reopened';
                }
                if(tskLst.size() > 0) Update tskLst;
            }
            if(trIdDocCatMap.size()>0){
                List<genesis__AppDocCatAttachmentJunction__c> appDocJnLst= [SELECT id,Success_Error_Msg__c,Transaction_Id__c FROM genesis__AppDocCatAttachmentJunction__c WHERE Transaction_Id__c IN: successTxIdSet OR Transaction_Id__c IN: FailedTxIdSet];
                for(genesis__AppDocCatAttachmentJunction__c appDocJn:appDocJnLst){
                    if(successTxIdSet.contains(appDocJn.Transaction_Id__c)){
                        appDocJn.Success_Error_Msg__c= 'Financial Data Received';
                    }else if(FailedTxIdSet.contains(appDocJn.Transaction_Id__c)){
                        appDocJn.Success_Error_Msg__c= 'Financial Data Received Failed';
                        appDocJn.Backend_Doc_Check__c= false;
                        appDocJn.Document_Submitted__c= false;
                    }
                    
                    
                }
                UPDATE trIdDocCatMap.values();
                Update appDocJnLst;
            }
        }
        catch(Exception e){
            System.debug('Exception Error  '+e.getMessage());
            System.debug('Exception Line Number  '+e.getLineNumber());
            HandleBusinessException.captureError('SME_perfiosReportBatch', 'BatchRocess', e);
        }
    }
    global void finish(Database.BatchableContext BC) {}
    public static void perfiosFinancialReport(Ws_PerfiosUpdate.cls_PerfDetails cPerfios){
        try{
            if(cPerfios.Status == 'COMPLETED'){
                String accesstoken;
                String endPoint;
                String appId = '';
                String perfiosTxId = cPerfios.Txn_ID;
                List<genesis__Application_Document_Category__c> appDocCatList = [SELECT Id,genesis__Application__c,genesis__Application__r.genesis__Account__c,Transaction_Id__c,Success_Error_Msg__c,(SELECT Id,Success_Error_Msg__c,Transaction_Id__c FROM genesis__AppDocCatAttachmentJunctions__r) FROM genesis__Application_Document_Category__c WHERE Transaction_Id__c =: perfiosTxId];
                Perfios__c  perfiosObj;
                accesstoken= WS_ApiGatewayAccToken.getAccTkn();
                for(genesis__Application_Document_Category__c docCat : appDocCatList){
                    endPoint=Utility.getFullEndpoints('Perfios_Financial_Report')+docCat.Transaction_Id__c;
                    HTTPResponse response = new HTTPResponse();
                    Map<String,String> headerMap = new Map<String,String>(); 
                    headerMap.put('Authorization',accesstoken);
                    System.debug('headerMap==> '+headerMap);
                    response = HttpUtility.sendHTTPRequest(endPoint, 'GET', null,null,headerMap,null);
                    String jsonData = response.getBody();
                    System.debug('jsonData String== '+jsonData);
                    if(response.getStatuscode()== 200){
                        /*Create Perfios Record*/
                        perfiosObj= new Perfios__c();
                        perfiosObj.Transaction_Id__c= docCat.Transaction_Id__c;
                        perfiosObj.Application__c= docCat.genesis__Application__c;
                        perfiosObj.Application_id__c= docCat.genesis__Application__c;
                        perfiosObj.Applicant_Name__c= docCat.genesis__Application__r.genesis__Account__c;
                        docCat.Success_Error_Msg__c= 'Financial Data Received';
                        WS_PerfiosRequestProcess.handlePerfiosRequest(jsonData);
                    }else{
                        appId = docCat.genesis__Application__c;
                        PerfiosJsonRequestResponsee.financialReportRes reportRes= (PerfiosJsonRequestResponsee.financialReportRes)Json.deserialize(jsonData, PerfiosJsonRequestResponsee.financialReportRes.class);
                        docCat.Success_Error_Msg__c =   'Error: '+reportRes.errorMessage;
                    }
                }
                if(perfiosObj != null)
                    INSERT perfiosObj;
                if(appId != ''){
                    List<Task> tskLst= [SELECT id,whatId,Status FROM Task WHERE whatId =: appId AND Type= 'Financial Upload'];
                    for(Task tsk: tskLst){
                        tsk.Status= 'Reopened';
                    }
                    if(tskLst.size() > 0){
                        TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
						Update tskLst;
                    }
                }
                if(appDocCatList.size()>0){
                    List<genesis__AppDocCatAttachmentJunction__c> appDocJnLst = new List<genesis__AppDocCatAttachmentJunction__c>();
                    for(genesis__Application_Document_Category__c docCat : appDocCatList){
                        for(genesis__AppDocCatAttachmentJunction__c appDocJn : docCat.genesis__AppDocCatAttachmentJunctions__r){
                            if(cPerfios.Status == 'COMPLETED'){
                                appDocJn.Success_Error_Msg__c= 'Financial Data Received';
                            }
                            else{
                                appDocJn.Success_Error_Msg__c= 'Financial Data Received Failed';
                                appDocJn.Backend_Doc_Check__c= false;
                                appDocJn.Document_Submitted__c= false;
                            }
                            appDocJnLst.add(appDocJn);
                        }
                    }
                    UPDATE appDocCatList;
                    if(appDocJnLst.size() > 0)
                        UPDATE appDocJnLst;
                }
            }
        }
        catch(Exception e){
            System.debug('Exception Error  '+e.getMessage());
            System.debug('Exception Line Number  '+e.getLineNumber());
            HandleBusinessException.captureError('SME_perfiosReportBatch', 'BatchProcess', e);
        }
    }
}