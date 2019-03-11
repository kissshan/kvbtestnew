public class Batch_JocataListMatchStatusHelper {
    
    public static JocataListMatching_Model.JocataLMStatusResponse getJocataListMatchingresponse(string tranxId){
        
        try{
            string endUrl   = Utility.getFullEndpoints('ListMatchingSatusAPI');     
            endUrl          = endUrl+Integer.ValueOf(tranxId);
            
            HTTPResponse response = new HTTPResponse();
            Map<String,String> headerMap = new Map<String,String>();  
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            
            System.debug('Header'+headerMap);
            System.debug('Endpoint url'+endUrl);
            response = HttpUtility.sendHTTPRequest(endUrl,'GET', null,null,headerMap,null);
            System.debug('!!!!@#$%^&'+response);
            System.debug('response status '+headerMap);
            System.debug(response.getStatusCode());
            System.debug(response.getBody());
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonData = response.getBody();
                System.debug(jsonData);
                JocataListMatching_Model.JocataLMStatusResponse jlmRes = (JocataListMatching_Model.JocataLMStatusResponse)Json.deserialize(jsonData, JocataListMatching_Model.JocataLMStatusResponse.class);
                System.debug(jlmRes);
                return jlmRes;
                
            }else{
                return null;
            }   
            
        }catch(Exception e){
            System.debug('Exception'+e.getMessage() +'On Line'+e.getLineNumber());
            return null;
        }
    }
    
}