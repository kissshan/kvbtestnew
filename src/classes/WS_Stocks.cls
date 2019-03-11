/*
*   Name    : WS_Stocks
*   purpose : Web service to insert/update stocks
*   Author  : Numaan
*/ 
@RestResource(urlMapping='/pushStockStatements')
global class WS_Stocks {
    
    global class Response extends WS_Response{
        
    }

    @HttpPost
    global static Response postStocksStatement(){

        RestRequest req      = Restcontext.Request;
        Response res         = new Response();    
        
        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }else{

            try{
                
                String jsonData     = req.requestBody.toString();
                System.debug('jsonData:::'+jsonData);              
                Stock_Model reqObj  = (Stock_Model)Json.deserialize(jsonData, Stock_Model.class);  

                res = Stocks_Service.saveStocks(reqObj); 
 
            }catch(Exception e){
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage    = e.getMessage();
                res.statusCode      = Constants.WS_ERROR_CODE;
                system.debug('Exception::'+e.getMessage());
                return res;
            }
        }
        return res;
    }   
}