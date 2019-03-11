/*
* Name      : WS_CustomerApplicationDetail
* Compnay   : ET Marlabs
* Purpose   : To get customer and Application Detail
* Author    : Amritesh
*/ 

@RestResource(urlMapping='/getCustomer360View')
global with sharing class WS_CustomerApplicationDetail {
    
    global class Response extends WS_Response{
        
        public Customer360view customerFullView;
        public Response(){
            customerFullView    = new Customer360view();            
        }
    }
    
    public class ReqWrapObj {
        public String Emp_Name;
        public String Branch_Code;
        public String Customer_ID;
        public String Application_ID;
        public String CUST_LOGIN; //Yes/NO
    }
    
    @HttpPost
    global static Response getCustomerView(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
        
        if(req == null || req.requestBody == null){
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);                     
        }else{
            try{
                String jsonData     = req.requestBody.toString();                            
                ReqWrapObj reqObj   = (ReqWrapObj)Json.deserialize(jsonData, ReqWrapObj.class);
                
                if(reqObj.Customer_ID == null || reqObj.Customer_ID ==''){
                    return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Customer_ID is required.');                    
                }
                if((reqObj.Application_ID == null || reqObj.Application_ID =='') && reqObj.CUST_LOGIN == 'No'){
                    return getWSResponse(res, Constants.WS_ERROR_STATUS,null, Constants.WS_ERROR_CODE, 'Application_ID is required.');                   
                }
                  if(reqObj.CUST_LOGIN == 'Yes' || reqObj.CUST_LOGIN == '1'){
                            try{
                            String applnId  = [Select id from genesis__Applications__c where genesis__Account__r.CBS_Customer_ID__c =:reqObj.Customer_ID AND Active__c = true AND RecordType.DeveloperName = 'SME_Renewal' limit 1].Id;
                            res.customerFullView = SMELoan_Helper.getCustomer(applnId,reqObj.Customer_ID);
                    }catch(Exception ex){
                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, ex.getMessage());                   
                        }
                      
                    }else{
                            if(reqObj.Application_ID != null && reqObj.Customer_ID != null){
                                res.customerFullView = SMELoan_Helper.getCustomer(reqObj.Application_ID,reqObj.Customer_ID);
                        } 
                
                }
            }catch(Exception e){
                return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, e.getMessage());                   
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