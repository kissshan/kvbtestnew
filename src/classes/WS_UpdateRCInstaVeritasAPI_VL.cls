/*
* Name     		: WS_UpdateRCInstaVeritasAPI_VL
* Company  		: ET Marlabs
* Purpose  		: This class is used for update RC details of vehicles via auto update API call
* Author   		: Braj Mohan
* Created Date 	: 05-Sep-2018
*/
@RestResource(urlMapping='/UpdateVLRCInstaVeritasAPI')
global with sharing class WS_UpdateRCInstaVeritasAPI_VL {
	global class Response extends WS_Response{

    }
    @HttpPost
    global static Response getVehicleRCDetails(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
        SavePoint sp		 = Database.setSavepoint();
        if(req == null || req.requestBody == null){
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);                     
        }else{
            try{
                system.debug('##InstaVeritas VL_RC reqbody=='+req);
                String jsonData	= req.requestBody.toString();
                System.debug('InstaVeritas Update API jsonData=='+jsonData);
                List<VL_RC_Response> updateAutoResponse = VL_RC_Response.parse(jsonData);
                if(updateAutoResponse != null){
                    try{
                        WS_RCInstaVeritasAPI_VL.createVL_RC(updateAutoResponse,null);
                        //TL_RCVerification.createVL_RC(updateAutoResponse,null);
                    }catch(Exception ex){
                        System.debug(ex.getLineNumber());
                        System.debug(ex.getStackTraceString());
                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null,Constants.WS_ERROR_CODE,ex.getMessage());                   
                    }
                } else {
                	return getWSResponse(res, Constants.WS_ERROR_STATUS, 'InstaVeritas Response is null!!', Constants.WS_ERROR_CODE, null);
                }                
            }catch(Exception e){
                res.errorMessage = e.getMessage()+' AT '+ e.getLineNumber()+ e.getStackTraceString();
            	System.debug(e.getMessage()+' Error while getting updated Response for vehicle RC details==>'+ e.getLineNumber()+ e.getStackTraceString());
            	HandleBusinessException.captureError('WS_UpdateRCInstaVeritasAPI_VL', 'getVehicleRCDetails', e);
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