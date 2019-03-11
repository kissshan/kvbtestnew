/*
 * Name     : WS_CommercialPRResponse
 * Company  : ET Marlabs
 * Purpose  : Used to read CommercialPR Processing and Storing CommercialPR data in LOS System against Account. 
 * Author   : Raushan
*/
@RestResource(urlMapping='/pushCommercialPRData')
global with sharing class WS_CommercialPRResponse {
    global class Response extends WS_Response{
        public List<FailedDataResponse> Error_List;
        public List<InsertedDataResponse> Success_List;
        public Integer failed_Count; 
        public Integer success_Count;
        public Response(){
            Error_List     = new List<FailedDataResponse>();
            Success_List   = new List<InsertedDataResponse>();              
        }
    }
    global class FailedDataResponse{
        public string cust_Id;
        public string error_reason;
        public string error_table;
    }
    global class InsertedDataResponse{
        public string cust_Id;
        public string sucess_message;
    }
    
    @HttpPost
    global static Response getCustomerView(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
        SavePoint sp         = Database.setSavepoint();
        if(req == null || req.requestBody == null){
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);                     
        }else{
            try{
                String jsonData                 = req.requestBody.toString();
                System.debug('jsonData'+jsonData);
                CommercialPRResponse commObj    = CommercialPRResponse.parse(jsonData);
                System.debug('CommericiapPRResponse'+commObj);
                if(commObj == null){
                    return getWSResponse(res, Constants.WS_ERROR_STATUS, 'Request Body is null.', Constants.WS_ERROR_CODE, null);                    
                }
                if(commObj != null){
                    try{
                         res = CommercialPRHandle.getCommercialPRDetails(commObj);
                         if(res.Success_List.size() > 0){
                             res.success_Count = res.Success_List.size();
                         }
                         if(res.Error_List.size() > 0){
                             res.failed_Count = res.Error_List.size();
                             res.statusCode              = Constants.WS_ERROR_CODE;
                         }
                    }catch(Exception ex){
                        //database.rollback(sp);
                        System.debug(ex.getLineNumber());
                        System.debug(ex.getStackTraceString());
                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null,Constants.WS_ERROR_CODE,ex.getMessage());                   
                    }
                }                
            }catch(Exception e){
                System.debug(e.getLineNumber());
                return getWSResponse(res, Constants.WS_ERROR_STATUS,null, Constants.WS_ERROR_CODE, e.getMessage());                   
            }
            
        }
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