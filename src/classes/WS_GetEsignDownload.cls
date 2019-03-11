/*
* Name       : WS_GetEsignDownload
* Compnay   : ET Marlabs
* Purpose  : Get Document against application Id, document Id and completion status
* Author   : Dushyant
*/ 
@RestResource(urlMapping='/getEsignDocument')
global with sharing class WS_GetEsignDownload {
    //preparing response structure
    global class Response extends WS_Response{
        public DocResponse docRes;
        public Response(){
            docRes = new DocResponse();
        }
    }
    //Response structure
    public class DocResponse{
        public string docID;
        public String pdfContent;
        public String LOS_Id;
    }
    //Request structure
    public class ReqWrapObj {
        public String LOS_APPID;
        public String DOC_ID;
        public String IS_Complted;
    }
    //Haldling POST request
    @HttpPost
    global static Response getdocument(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();    
        
        System.debug(req);
        System.debug(req.requestBody);
        //Chech for null/blank request
        if(req == null || req.requestBody == null){
            res.status           = Constants.WS_ERROR_STATUS;
            res.errorMessage     = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode        = Constants.WS_ERROR_CODE;
            return res;            
        }else{
            String jsonData   = req.requestBody.toString();
            //Parse request
            ReqWrapObj reqObj   = (ReqWrapObj)Json.deserialize(jsonData, ReqWrapObj.class);
            system.debug(reqObj.LOS_APPID);
            system.debug(reqObj.DOC_ID);
            system.debug(reqObj.IS_Complted);
            //Check completion status
            if(reqObj.IS_Complted =='Yes' || reqObj.IS_Complted =='1'){
                //method call to get the pdf document
                return getWSResponse(res, Constants.WS_SUCCESS_STATUS, 'Success!', Constants.WS_SUCCESS_CODE, reqObj.DOC_ID, reqObj.LOS_APPID);
            }
            else{
                return getWSResponse(res, Constants.WS_SUCCESS_STATUS, 'Success!', Constants.WS_SUCCESS_CODE, null, reqObj.LOS_APPID);
            }
        }
    }  
    //Helper method to create response contaning document
    public static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string documentId, String losId){
        res.status           = status;
        res.successMessage  = succMsg;
        res.statusCode        = statusCode;
        //Fetching document against document id
        String pdfContent = Digioe_Docs_Service.downloadDocument(documentId);
        //preparing response
        if(pdfContent != null){
            res.docRes.docID = documentId;
            res.docRes.pdfContent = pdfContent;
            res.docRes.LOS_Id = losId;
        }
        else{
            res.docRes.docID = documentId;
            res.docRes.pdfContent = '';
            res.docRes.LOS_Id = '';
        }
        return res;
    }
}