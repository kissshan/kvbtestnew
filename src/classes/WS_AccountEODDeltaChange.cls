/*
 * Name		: WS_AccountEODDeltaChange.
 * Company	: ET Marlabs
 * Purpose 	: Used to Update or Insert AccountEOD Master Information. 
 * Author	: Raushan
 */

@RestResource(urlMapping='/pushAccountEODMaster')
global with sharing class WS_AccountEODDeltaChange {
    
    //Response Structure.
    global class Response extends WS_Response{
        public List<AccInsertResponse> Error_List;
        public List<AccSuccessResponse> Success_List;
        public Integer failed_Account; 
        public Integer success_Account; 
        public Response(){
            Error_List 		= new List<AccInsertResponse>();
            Success_List 	= new List<AccSuccessResponse>();
        }
    }
    //Response wrapper Class.
    global class AccInsertResponse{
        public string cust_Id;
        public string error_reason;
        public string error_table;
    }
    
    global class AccSuccessResponse{
        public string cust_Id;
        public string sucess_message;
    }
    
    @HttpPost
    global static Response accountDeltaChange(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
    	try{
    		If(req == null || req.requestBody == null){
                res.status         	= Constants.WS_ERROR_STATUS;
            	res.errorMessage   	= Constants.WS_REQ_BODY_IS_NULL;
            	res.statusCode 	   	= Constants.WS_ERROR_CODE;
            }else{
                System.debug('req::'+req);
                System.debug('reqBody::'+req.requestBody);
                String jsonData = req.requestBody.toString();
                System.debug('Json::'+jsonData);
                AccountEODResponse accEODRes = AccountEODResponse.parse(jsonData);
                If(accEODRes !=null){
                	res            = AccountEODResponse_Handler.getAccountEOD(accEODRes);
                    System.debug('res::'+res);
                }else{
                    res.status         	= Constants.WS_ERROR_STATUS;
                    res.errorMessage   	= 'Requested body is not proper';
                    res.statusCode 	   	= Constants.WS_ERROR_CODE;  
                }
            }
    	}catch(Exception ex){
            res.status         	= Constants.WS_ERROR_STATUS;
            res.errorMessage   	= ex.getMessage();
            res.statusCode 	   	= Constants.WS_ERROR_CODE;
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
    	}
        return res;
    }
}