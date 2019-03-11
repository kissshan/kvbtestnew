/*
* Name          : WS_Probe42Data
* Description   : Web service to push Probe 42 data into Los system
* Author        : Raushan
*/
global class WS_Probe42Data {
    
    public static void getResponse(String custId,String appId){
        WS_Probe42Data.Request_Structure requestObj = new WS_Probe42Data.Request_Structure();
        Account acc = new Account();
        If(custId !=null && custId !=''){
            acc = [select id,CBS_Customer_ID__c,CIN_Number__c from Account where Id =: custId];
            If(acc !=null && acc.CIN_Number__c !=null && acc.CIN_Number__c !=''){
                //requestObj.Customer_ID = acc.CBS_Customer_ID__c;
                requestObj.CIN         = acc.CIN_Number__c;
            }
        }
        try{
            Map<String,String> headerMap   = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            //JSON.serialize(requestObj)
            HttpResponse response  = new HttpResponse();
            
            response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('Probe_42_Apigee')+requestObj.CIN,'GET',null, null,headerMap,null);
            
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonData             = response.getBody();
                System.debug('Json&&&&&&&'+jsonData);
                Probe42_Response_Structure probeResObj = Probe42_Response_Structure.parse(jsonData);
                If(probeResObj !=null){
                    try{
                         Probe42_Response_Handler.getProbe42Data(probeResObj,custId,appId,acc.CBS_Customer_ID__c);
                    
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
        //public String Customer_ID;
        public String CIN;
    }
}