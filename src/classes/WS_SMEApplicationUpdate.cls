@RestResource(urlMapping='/updateSMEApplication')
global with sharing class WS_SMEApplicationUpdate {
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
        //SavePoint sp       = Database.setSavepoint();
        if(req == null || req.requestBody == null){
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);                     
        }else{
            try{
                String jsonData             = req.requestBody.toString();
                system.debug('Update API Request'+jsonData);
                Customer360view customObj   = Customer360view.parse(jsonData);
                //system.debug('customObj::'+customObj);
                if(customObj == null){
                    return getWSResponse(res, Constants.WS_SUCCESS_STATUS, 'Request Body is null.', Constants.WS_SUCCESS_CODE, null);                    
                }
                if(customObj.CUSTOMER_ID == null || customObj.CUSTOMER_ID == ''){
                    return getWSResponse(res, Constants.WS_SUCCESS_STATUS, 'Customer Id is null or empty.', Constants.WS_SUCCESS_CODE, null); 
                }
                if(customObj.LOS_APPLICATION_ID == null || customObj.LOS_APPLICATION_ID == ''){
                    return getWSResponse(res, Constants.WS_SUCCESS_STATUS, 'LOS Application id is null or empty.', Constants.WS_SUCCESS_CODE, null); 
                }
                if(customObj.LOS_CUSTOMER_SF_ID == null || customObj.LOS_CUSTOMER_SF_ID == ''){
                    return getWSResponse(res, Constants.WS_SUCCESS_STATUS, 'LOS Customer Id is null or empty.', Constants.WS_SUCCESS_CODE, null); 
                }
                if((customObj.CUSTOMER_ID != null || customObj.CUSTOMER_ID !='') && (customObj.LOS_CUSTOMER_SF_ID != null || customObj.LOS_CUSTOMER_SF_ID != '') && customObj.IS_ONLY_STOCK_UPDATION!= null && Boolean.valueOf(customObj.IS_ONLY_STOCK_UPDATION)){
                    String reurnString = SMELoan_Helper.updateStockStatement(customObj);
                    return getWSResponse(res, Constants.WS_SUCCESS_STATUS, reurnString, Constants.WS_SUCCESS_CODE, null);
                }
                else if(customObj != null){
                    try{
                        //system.debug('=========applicationupdate=====');
                        res.customerFullView = SME_Enhance_Update.getSME_Enhance_Update(customObj); 
                        if(res.customerFullView == null && SOQL_Util.personDedupeFailed){
                            if(SOQL_Util.dedupeAadharReferece.size() > 0)
                            	return getWSResponse(res, Constants.WS_ERROR_STATUS, null,Constants.WS_ERROR_CODE,'Multiple Aadhar number '+SOQL_Util.dedupeAadharReferece+' exists for same key person in LOS - Please contact DTPC call center');
                            else if(SOQL_Util.dedupePancard.size() > 0)
                            	return getWSResponse(res, Constants.WS_ERROR_STATUS, null,Constants.WS_ERROR_CODE,'Multiple PAN number '+SOQL_Util.dedupePancard+' exists for same key person in LOS - Please contact DTPC call center');
                        }
                            
                        System.debug('1.Number of Queries used in this apex code so far: @@@@' + Limits.getQueries());
                    }catch(Exception ex){
                        //database.rollback(sp);
                        System.debug(ex.getLineNumber());
                        System.debug(ex.getStackTraceString());
                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null,Constants.WS_ERROR_CODE,ex.getMessage());                   
                    }
                }                
            }catch(Exception e){
                System.debug(e.getLineNumber());
                System.debug(e.getCause());
                System.debug(e.getMessage());
                System.debug(e.getStackTraceString());
                return getWSResponse(res, Constants.WS_ERROR_STATUS,null, Constants.WS_ERROR_CODE, e.getMessage());                   
            }
            
        }
        system.debug('Update API Response====> '+res);
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