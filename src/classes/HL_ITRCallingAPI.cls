public class HL_ITRCallingAPI {

    public static string callform26AS(string TxnID,string reportType){
         try{
            system.debug('TxnID === '+TxnID);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            HTTPResponse response                                   = new HTTPResponse();
            String endPoint                                         = Utility.getFullEndpoints('ITRReport');
            endPoint          = endPoint+TxnID;
            endpoint          =endPoint+system.label.ITRReport+reportType;
            response = HttpUtility.sendHTTPRequest(endPoint, 'GET', null,null,headerMap,null);
            system.debug('$$$$'+response.getBody());
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsona = response.getBody();
                system.debug('jsona'+jsona);
              //  Form26asResponse res = (Form26asResponse)Json.deserialize(jsona,Form26asResponse.class);
                system.debug('res'+jsona);
                return jsona;
            }else{
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
        }catch(Exception e){
            system.debug(e.getLineNumber()+'sss'+e.getStackTraceString());
        }  
        
        
        return null;
        
    }

}