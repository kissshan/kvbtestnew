/*
 * Name     : WS_CommercialPRError
 * Company  : ET Marlabs
 * Purpose  : Used to storing CommercialPR Error data in LOS System against Account. 
 * Author   : Raushan
*/
@RestResource(urlMapping='/pushCommercialPRError')
global with sharing class WS_CommercialPRError {
    global class Response extends WS_Response{
        public List<failedDataResponse> Error_List;
        public List<insertedDataResponse> Success_List;
        public Integer failed_Count; 
        public Integer success_Count; 
        
        //public CommercialPRErrorService commercialPRErrorObj;
        public Response(){
            //commercialPRErrorObj    = new CommercialPRErrorService();     
            Error_List     = new List<failedDataResponse>();
            Success_List   = new List<insertedDataResponse>();          
        }
    }
    global class failedDataResponse{
        public string cust_Id;
        public string error_reason;
    }
    global class insertedDataResponse{
        public string cust_Id;
        public string sucess_message;
    }
    
    @HttpPost
    global static Response getCommercialError(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
        SavePoint sp         = Database.setSavepoint();
         if(req == null || req.requestBody == null){
             res.status             = Constants.WS_ERROR_STATUS;
             res.errorMessage       = Constants.WS_REQ_BODY_IS_NULL;
             res.statusCode         = Constants.WS_ERROR_CODE;
             return res;
        }else{
            try{
                String jsonData                 = req.requestBody.toString();
                System.debug('jsonData'+jsonData);
                
                CommercialPRErrorService CommERRObject  = CommercialPRErrorService.parse(jsonData);
                System.debug('CommericiapPR-----------'+System.JSON.deserializeUntyped(jsonData));
                System.debug('CommericiapPRResponse'+CommERRObject);
                if(CommERRObject == null){
                    res.status          = Constants.WS_ERROR_STATUS;
                    res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
                    res.statusCode      = Constants.WS_ERROR_CODE;
                    return res;                   
                }
                if(CommERRObject != null){
                    try{
                        res = CommercialPRErrorHandler.getCommercialPRError(CommERRObject); 
                    }catch(Exception ex){
                        //database.rollback(sp);
                        System.debug(ex.getLineNumber());
                        System.debug(ex.getStackTraceString());
                        res.status          = Constants.WS_ERROR_STATUS;
                        res.errorMessage    = ex.getMessage();
                        res.statusCode      = Constants.WS_ERROR_CODE;
                        return res;
                                           
                    }
                } 
               return res;
            }catch(Exception e){
                System.debug(e.getLineNumber());
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage    = e.getMessage();
                res.statusCode      = Constants.WS_ERROR_CODE;
                return res;                   
          }   
        }
     }     
  }