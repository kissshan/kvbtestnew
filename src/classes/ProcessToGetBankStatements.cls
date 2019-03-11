public class ProcessToGetBankStatements {
	public Static String accessToken;
    public Static void getBankStatements(){
        accessToken = WS_ApiGatewayAccToken.getAccTkn();
        system.debug('Accesstoken***'+accessToken);
        GetBankStatements.cls_payload reqobj = new GetBankStatements.cls_payload();
        /*string reqStr = JSON.serialize(reqobj);
        System.debug('Request===> '+reqStr);
        HTTPResponse response = new HTTPResponse();
        Map<String,String> headerMap = new Map<String,String>();  
        headerMap.put('Authorization',accessToken);
        response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('Bank Statement API'), 'POST', null,reqStr,headerMap,null);
        String jsonData = response.getBody();
        System.debug('Response===> '+jsonData);*/
    }
}