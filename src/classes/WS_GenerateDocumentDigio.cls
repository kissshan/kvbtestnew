/*
* Name      : WS_GenerateDocumentDigio
* Compnay   : ET Marlabs
* Purpose   : WS Class to handle Digio Document Generation and Class2 Sign. Also this 
              class is used for Document Downdload from Digio
* Author    : Raushan
*/ 
@RestResource(urlMapping='/generateDigioDocument')
global with sharing class WS_GenerateDocumentDigio {
    
    global class Response extends WS_Response{
        public DOC_Response docResObj;
        public Response() {
            docResObj   = new DOC_Response(); 
        }
    }
    //Response Structure.
    public class DOC_Response{
        public String LOS_APPID;
        public String docPDFContent;
        public String Doc_ID;
        public DOC_Response(){
            LOS_APPID='';
            docPDFContent='';
            Doc_ID ='';
        }
    }
    //Wrapper class.
    public class ReqWrapObj {
        public String LOS_APPID;
        public String IS_Submitted; //Yes/No
        public String After_ESign; // Yes/No
        public string Doc_ID;
    }
    
    @HttpPost
    global static Response getSMECustomers(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();  
        System.debug('req::: ' + req);  
        
        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }
        else{
            String jsonData     = req.requestBody.toString(); 
            system.debug('request Data:: ' + jsonData);   

            ReqWrapObj reqObj   = (ReqWrapObj)Json.deserialize(jsonData, ReqWrapObj.class);
            System.debug('reqObj:: ' + reqObj);

            if(reqObj.IS_Submitted == null || reqObj.LOS_APPID == null){
                   return getWSResponse(res, Constants.WS_ERROR_STATUS, 'Invalid Request!', Constants.WS_ERROR_CODE, null);
               }
            
            if(reqObj.IS_Submitted =='Yes') {
                // return Class-2 Signed PDF Doc to FE
                res = SME_Digio_Service_EAE.docGenAndSignDoc(reqObj.LOS_APPID,'',new List<Id>(),'');
                system.debug('resData:::9:::: ' + res);
            }
            System.debug('reqObj.Doc_ID:::: ' + reqObj.Doc_ID);
            if(reqObj.IS_Submitted =='No' && (reqObj.Doc_ID != null || reqObj.Doc_ID !='')){
                
                List<Digio_Document_ID__c> docDetailList = new List<Digio_Document_ID__c>();
                List<Attachment> attList = new List<Attachment>();
                
                docDetailList = [SELECT Id,Document_ID__c FROM Digio_Document_ID__c WHERE Id =: reqObj.Doc_ID];
                attList = [SELECT Id,Name,Body FROM Attachment WHERE Id =: docDetailList[0].Document_ID__c];
                res.docResObj.docPDFContent     = EncodingUtil.base64Encode(attList[0].Body);
                res.docResObj.Doc_ID            = reqObj.Doc_ID;
                res.docResObj.LOS_APPID         = reqObj.LOS_APPID;
                res.status                      = Constants.WS_SUCCESS_STATUS;
                res.statusCode                  = Constants.WS_SUCCESS_CODE;
            }
            
        }
        system.debug('Response resData::  ' + res);
        return res;
    }
    static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg){
        res.status          = status;
        res.successMessage  = succMsg;
        res.statusCode      = statusCode;
        res.errorMessage    = errMsg;
        return res;
    }        
}