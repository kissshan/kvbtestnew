/*
* Name          : WS_CRILC_API
* Description   : Web service to Request for CRILC Data.
* Author        : Raushan
*/
global class WS_CRILC_API {
    
    public static Account getRequest(String custSFId,String Pan_Number){
        
        If(custSFId!=null && custSFId !='' && Pan_Number !=null && Pan_Number !=''){
            Request_Structure reqObj	=	new  Request_Structure();
            reqObj.panNumber			=	Pan_Number;
            reqObj.customerId			=   custSFId;
            reqObj.noOfQuarter			=   '';
            //String endPoint = 'https://kvb-test.apigee.net/next/v1/kyc/crilc';
            try{
                
                Map<String,String> headerMap     = new Map<String,String>();
                headerMap.put('Content-Type','application/json');
                headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
                HTTPResponse response                 = new HTTPResponse();
                system.debug('@@@@@@@@@@@'+reqObj);
                response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('Crilc Request Apigee'), 'POST', null,JSON.serialize(reqObj),headerMap,null);
                system.debug('============='+response);
                If(response.getStatusCode() == 200 || response.getStatusCode() == 201	|| response.getStatusCode() == 202){
                    String jsonData                 = response.getBody();
                    System.debug('Response Structure'+jsonData);
                    Response_Structure resStrObj	= (Response_Structure)JSON.deserialize(jsonData, Response_Structure.class);
                    If(resStrObj !=null){
                        If(resStrObj.evokeResponse !=null){
                            Account accObj	=	new Account();
                            WS_CRILC_API.EvokeResponse	evokeObj	=	resStrObj.evokeResponse;
                            If(evokeObj!=null && evokeObj.txnId !=null && evokeObj.txnId !=''){
                                accObj.id	=	(Id)custSFId;
                                accObj.CRILC_TxnId__c	=	evokeObj.txnId;
                                
                                System.debug('Account'+accObj);
                            }
                            If(accObj.id !=null){
                                return accObj;
                            }
                        }
                    }
                    
                }else{
                    throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
                }
            }catch(Exception ex){
              System.debug('Exception ::'+ex.getMessage());
              System.debug('Line Number ::'+ ex.getLineNumber());
               
            }
        } 
        return new Account();
    }
    
    class Request_Structure{
        string panNumber;
        string customerId;
        string noOfQuarter;
    }
    class Response_Structure{
        public EvokeResponse evokeResponse;
    }
    class EvokeResponse{
        public String statusCode;
        public String statusMessage;
        public String txnId;        
    }
}