/*
* Name      : SME_PerfiosCallout
* Compnay   : ET Marlabs
* Purpose   : SME Calling the Perfios for selected Financial year Application Documents
* Author    : Vignesh
*/
global class SME_PerfiosCallout {
    public static String accToken;
    webservice static void ProcessPerfios(String appId){
        try{
            List<genesis__Applications__c> appList= [Select Id,genesis__Account__c,genesis__Loan_Amount__c,RecordType_Developer_Name__c,genesis__Term__c from genesis__Applications__c where id=: appId];
            List<genesis__Application_Document_Category__c> appDocCatList = new List<genesis__Application_Document_Category__c>();
            List<genesis__AppDocCatAttachmentJunction__c> appDocJunList= new List<genesis__AppDocCatAttachmentJunction__c>();
            List<genesis__AppDocCatAttachmentJunction__c> updateAppDocJunList = new List<genesis__AppDocCatAttachmentJunction__c>(); 
            Map<String,List<genesis__AppDocCatAttachmentJunction__c>> appDocJnMap = new Map<String,List<genesis__AppDocCatAttachmentJunction__c>>();
            Map<String, PerfiosJsonRequestResponsee.FinancialProcessRes> fYearResMap= new Map<String, PerfiosJsonRequestResponsee.FinancialProcessRes>();
            Set<String> failedYearListWhileUploading= new set<String>();
            appDocJunList = [Select id,Dms_Uuid__c,F_Year__c,genesis__Application_Document_Category__r.Name,genesis__Application_Document_Category__c,genesis__Application_Document_Category__r.genesis__Application__c from genesis__AppDocCatAttachmentJunction__c where genesis__Application_Document_Category__r.genesis__Application__c=: appId AND F_Year__c != null AND Document_Submitted__c = true];
            System.debug(appDocJunList.size()+'appDocJunList===> '+appDocJunList);
            if(appDocJunList.size()>0){
                accToken = WS_ApiGatewayAccToken.getAccTkn();
                for(genesis__AppDocCatAttachmentJunction__c appDocJn: appDocJunList){
                    if(appDocJnMap.containskey(appDocJn.F_Year__c)){
                        appDocJnMap.get(appDocJn.F_Year__c).add(appDocJn);
                    }else{
                        appDocJnMap.put(appDocJn.F_Year__c, new List<genesis__AppDocCatAttachmentJunction__c>{appDocJn});
                    }
                }
            }
            for(String fYr: appDocJnMap.keyset()){
                HTTPResponse response = new HTTPResponse();
                Map<String,String> headerMap = new Map<String,String>();
                PerfiosJsonRequestResponsee.FinancialProcessReq financialProcessReq= new PerfiosJsonRequestResponsee.FinancialProcessReq();
                PerfiosJsonRequestResponsee.cls_payload processPayload = new PerfiosJsonRequestResponsee.cls_payload();
                List<PerfiosJsonRequestResponsee.cls_documents> documentLst = new List<PerfiosJsonRequestResponsee.cls_documents>();
                
                processPayload.applicationId= appList[0].Id;
                processPayload.loanDuration = '123';//String.valueOf(appList[0].genesis__Term__c);
                processPayload.loanAmount = '12345';//String.valueOf(appList[0].genesis__Loan_Amount__c);
                processPayload.loanType = appList[0].RecordType_Developer_Name__c;
                processPayload.financialYear = String.valueOf(Integer.valueOf(fYr.left(4))+1);
                for(genesis__AppDocCatAttachmentJunction__c appDocJn : appDocJnMap.get(fYr)){
                    PerfiosJsonRequestResponsee.cls_documents doc = new PerfiosJsonRequestResponsee.cls_documents();
                    doc.uuid = appDocJn.Dms_Uuid__c;
                    doc.password = '';
                    documentLst.add(doc);
                }
                processPayload.documents = documentLst;
                financialProcessReq.payload = processPayload;
                string reqStr = JSON.serialize(financialProcessReq);
                System.debug('FinancialProcess Req===> '+reqStr);
                headerMap.put('Content-Type','application/json'); 
                headerMap.put('Authorization',accToken);
                response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('Perfios_Financial_Porcess'), 'POST', null,reqStr,headerMap,null);
                System.debug('response::'+response);
                String jsonData = response.getBody();
                System.debug('FinancialProcess Res===> '+jsonData);
                PerfiosJsonRequestResponsee.FinancialProcessRes fnlProcessRes;
                if(response.getStatuscode() == 200 || response.getStatuscode() == 201){
                    fnlProcessRes = (PerfiosJsonRequestResponsee.FinancialProcessRes)Json.deserialize(jsonData, PerfiosJsonRequestResponsee.FinancialProcessRes.class);
                    fYearResMap.put(fYr,fnlProcessRes);
                }
                else{
                    failedYearListWhileUploading.add(fYr);
                }
            }
            for(String fYr : fYearResMap.keyset()){
                PerfiosJsonRequestResponsee.FinancialProcessRes fnlRes;
                for(genesis__AppDocCatAttachmentJunction__c appDocJn : appDocJnMap.get(fYr)){
                    if(fYr == appDocJn.F_Year__c && fYearResMap.containskey(appDocJn.F_Year__c) && fYearResMap.get(appDocJn.F_Year__c)!= null){
                        fnlRes = fYearResMap.get(fYr);
                        genesis__Application_Document_Category__c appDoc = new genesis__Application_Document_Category__c(Id=appDocJn.genesis__Application_Document_Category__c);
                        if(fnlRes.Rejected != null){
                            appDocJn.Success_Error_Msg__c= 'Error: '+fnlRes.Rejected.message;
                            appDocJn.Document_Submitted__c= false;
                            appDoc.Success_Error_Msg__c= 'Error: '+fnlRes.Rejected.message;
                        }
                        if(fnlRes.Accepted !=null){
                            appDoc.Transaction_Id__c = fnlRes.Accepted.clientTransactionId;
                            appDoc.Success_Error_Msg__c = fnlRes.Accepted.message;
                            appDocJn.Success_Error_Msg__c = fnlRes.Accepted.message;
                            appDocJn.Transaction_Id__c = fnlRes.Accepted.clientTransactionId;
                            //appDocJn.Backend_Doc_Check__c = true;
                            appDocJn.Document_Submitted__c = true;
                        }
                        appDocCatList.add(appDoc);
                        updateAppDocJunList.add(appDocJn);
                    }
                }
            }
            for(String fYear : failedYearListWhileUploading){
                for(genesis__AppDocCatAttachmentJunction__c appDocJn : appDocJnMap.get(fYear)){
                    updateAppDocJunList.add(new genesis__AppDocCatAttachmentJunction__c(Id = appDocJn.Id ,Success_Error_Msg__c = 'Error ocurred while uploading document to Perfios'));
                    appDocCatList.add(new genesis__Application_Document_Category__c(Id = appDocJn.genesis__Application_Document_Category__c ,Success_Error_Msg__c = ''));
                }
            }
            if(appDocCatList.size()>0){
                Update appDocCatList;
            }
            if(updateAppDocJunList.size()>0){
                Update updateAppDocJunList;
            }
        }
        catch(Exception e){
            System.debug('LineNumber '+e.getLineNumber());
            System.debug('ErrorMsg '+e.getMessage());
            System.debug('CauseMsg '+e.getCause());
        }	
    }
}