/*
* Name     : WS_EsignDocID
* Compnay  : ET Marlabs
* Purpose  : Get Esign Document ID.
* Author   : Dushyant
*/ 
@RestResource(urlMapping='/getEsignDocID')
global with sharing class WS_GetEsignDocID {

    //Response Structure.
     global class Response extends WS_Response{
       public eSignResponse eSignRes;
       public Response(){
         eSignRes = new eSignResponse();
       }
    }
    //Wrapper Class.
    public class eSignResponse{
        public String LOS_APPID;
        public string DOC_REF_ID;
        public string docID;
        public String LOS_PARTY_TYPE_ID;
    }

    //Wrapper Class.
    public class ReqWrapObj {
        public String LOS_APPID;
        public String DOC_REF_ID;
        public String LOS_PARTY_TYPE_ID;
  }
    
    @HttpPost
    global static Response getEsignDocId(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();    
        
        if(req == null || req.requestBody == null){
            res.status           = Constants.WS_ERROR_STATUS;
            res.errorMessage     = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode        = Constants.WS_ERROR_CODE;
            //return res;            
        }else{
            String jsonData   = req.requestBody.toString(); 
            System.debug('jsonData:::'+jsonData);       
            ReqWrapObj reqObj   = (ReqWrapObj)Json.deserialize(jsonData, ReqWrapObj.class);
            system.debug('reqObj::'+reqObj);
            //Removed as eSign is removedfrom SME
            //res = SME_Digio_Service_EAE.doESignUpdated(reqObj.LOS_APPID,reqObj.DOC_REF_ID);
            System.debug('resObj::'+res);
        }
        
         return res;
    }        
}