/*
* Name     : WS_UpdateFieldVerificationAPI
* Company  : ET Marlabs
* Purpose  : This is response structure for WS_UpdateAstuteResponse
* Author   : Shubham Shukla
*/
@RestResource(urlMapping='/updateAstutesRecord')
global with sharing class WS_UpdateAstuteResponse {
	global class Response extends WS_Response{

    }
    @HttpPost
    global static Response getCustomerView(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
        SavePoint sp		 = Database.setSavepoint();
        if(req == null || req.requestBody == null){
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);                     
        }else{
            try{
                system.debug('##reqbody'+req);
                String jsonData 	        	= req.requestBody.toString();
                System.debug('jsonData'+jsonData);
                WS_UpdateAstuteRequest updateAstuteObj 	= WS_UpdateAstuteRequest.parse(jsonData);
                if(updateAstuteObj == null){
                    return getWSResponse(res, Constants.WS_ERROR_STATUS, 'Request Body is null.', Constants.WS_ERROR_CODE, null);                    
                }
                if(updateAstuteObj != null){
                    try{
                        WS_UpdateAstuteHandler.getAstuteDetails(updateAstuteObj);
                    }catch(Exception ex){
                        System.debug(ex.getLineNumber());
                        System.debug(ex.getStackTraceString());
                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null,Constants.WS_ERROR_CODE,ex.getMessage());                   
                    }
                }                
            }catch(Exception e){
                res.errorMessage = e.getMessage()+' AT '+ e.getLineNumber()+ e.getStackTraceString();
            	System.debug(e.getMessage()+' AT '+ e.getLineNumber()+ e.getStackTraceString());
                return getWSResponse(res, Constants.WS_ERROR_STATUS,null, Constants.WS_ERROR_CODE, e.getMessage());                   
            }
            
        }
        return res;
    }
    
    static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg){
        res.status         	= status;
        res.successMessage  = succMsg;
        res.statusCode 	   	= statusCode;
        res.errorMessage	= errMsg;
        return res;
    }
    
}