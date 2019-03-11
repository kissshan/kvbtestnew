/*
* Name    : WS_ApiGatewayAccToken
* Company : ET Marlabs
* Purpose : This class is used get access token of API GATEWAY
* Author  : Subas
*/
public class WS_ApiGatewayAccToken {
    
    public static String getAccTkn(){ 
        String accessTkn = '';
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('Apigee_Access_Token');
        System.debug('@@@@@@@'+kvb);
        system.debug('kvb.Username__c:-'+kvb.Username__c);
        String auth = kvb.Username__c;
        String endPoint = kvb.Endpoint_URL__c;
        Map<String,String> headerMap                            = new Map<String,String>();
        //headerMap.put('Authorization','Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        headerMap.put('Authorization',auth);
        headerMap.put('Content-Type','application/x-www-form-urlencoded');
        HTTPResponse response                                   = new HTTPResponse();
        //String endPoint                                         ='https://kvb-dev.apigee.net/next/v1/oauth/cc/accesstoken';
        system.debug('**HeaderMap**'+headerMap);
        STRING REQ= 'grant_type=client_credentials';
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,REQ,headerMap,null);
        system.debug('##Response'+response.getBody()); 
        
        APGResposne apg = (APGResposne)JSON.deserialize(response.getBody(), APGResposne.class);
        system.debug('apg::'+apg.access_token);
        accessTkn = 'Bearer '+apg.access_token;
        return accessTkn;
    }
    
    public class APGResposne{
        public string access_token;
        public string expires_in;
    }
}