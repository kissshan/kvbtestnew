/*
* Name      : WS_CustomerApplicationUpdate
* Compnay   : ET Marlabs
* Purpose   : To Update customer and Application Details.
*/ 

 @RestResource(urlMapping='/updateCustomer360View')
global with sharing class WS_CustomerApplicationUpdate {
   
    global class Response extends WS_Response{
        
        public Customer360view customerFullView;
        public Response(){
            customerFullView    = new Customer360view();            
        }
    }
    
  
    @HttpPost
    global static Response getCustomerView(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
        //SavePoint sp         = Database.setSavepoint();
        if(req == null || req.requestBody == null){
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);                     
        }else{
            try{
                String jsonData             = req.requestBody.toString(); 
                System.debug('jsonData:::'+jsonData);
                Customer360view customObj   = Customer360view.parse(jsonData);
                System.debug('customObj::'+customObj);
                if(customObj == null){
                    return getWSResponse(res, Constants.WS_SUCCESS_STATUS, 'Request Body is null.', Constants.WS_SUCCESS_CODE, null);                    
                }
                if(customObj != null){
                    try{
                        res.customerFullView = SMELoan_Helper.getCustomAppDetailsUpdate(customObj);                       
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