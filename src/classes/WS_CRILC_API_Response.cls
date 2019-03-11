/*
* Name          : WS_CRILC_API_Response
* Description   : Web service to push Crilc data into Los system.
* Author        : Raushan
*/

global class WS_CRILC_API_Response {
    
        public static void getResponse(String custId){
        WS_CRILC_API_Response.Request_Structure requestObj = new WS_CRILC_API_Response.Request_Structure();
        If(custId !=null && custId !=''){
            Account acc = [select id,CBS_Customer_ID__c,CRILC_TxnId__c from Account where Id =: custId];
            If(acc !=null && acc.CRILC_TxnId__c !=null && acc.CRILC_TxnId__c !=''){
                requestObj.txnId         = acc.CRILC_TxnId__c;
            }
        }
        try{
            Map<String,String> headerMap   = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            //String endPoint	= 'https://kvb-test.apigee.net/next/v1/kyc/status/crilc?txnId='+requestObj.txnId;
            HttpResponse response  = new HttpResponse();
            response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('Crilc Response Apigee')+requestObj.txnId,'GET',null, null,headerMap,null);
            
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonData             = response.getBody();
                System.debug('Json'+jsonData);
                CRILC_API_Response crilcResObj = CRILC_API_Response.parse(jsonData);
                If(crilcResObj !=null){
                    try{
                         CRILC_API_Response_Handler.getCRILC_API_Response(crilcResObj,custId);
                    
                    }catch(Exception ex){
                        System.debug(ex.getLineNumber());
                        System.debug(ex.getStackTraceString());
                    } 
                }
            }else{                
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
        }catch(Exception ex){
            String error = ex.getMessage();
            System.debug('Error Message'+error);
        }
    }
    public class Request_Structure{
        public String txnId;
    }

}