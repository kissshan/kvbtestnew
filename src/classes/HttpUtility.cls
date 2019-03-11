/* 
* Name      : HttpUtility
* Purpose   : This class is used as an utility for all httpRequest .
* Company   : ET Marlabs
* Author    : Amritesh
*/
public class HttpUtility {
    
    public static HttpResponse sendHTTPRequest(String endpoint, String method,String body){
        return sendHTTPRequest(endpoint,method,null,body,null,null);
    }
    public static HttpResponse sendHTTPRequest(String endpoint, String method,String body,String certfName){
        return sendHTTPRequest(endpoint,method,null,body,null,certfName);
    }
    
    public static HttpResponse sendHTTPRequest(String endpoint, String method, Integer timeOut,String body,Map<String,String> headerMap,String certfName){
        System.debug('Header Map'+headerMap);
        Http http = new Http();
        HttpRequest req = new HttpRequest(); 
        
        if(timeOut!=null){
            req.setTimeout(timeOut);
        }else{
            req.setTimeout(120000);
        }
        
        if(certfName != null){
            req.setClientCertificateName(certfName);
        }
        
        req.setEndpoint(endpoint);
        req.setMethod(method);
        
        if(body != null){
            req.setBody(body);
        }
        
        //Header Map to populate html headers
        if(headerMap != null){
            System.debug('Header Map'+headerMap+'	headerMap.keySet():-'+headerMap.keySet());
            for(String key: headerMap.keySet()){
                req.setHeader(key,headerMap.get(key));
            }
        }
        
        system.debug('res:::'+req.toString());
       
        HttpResponse res= http.send(req);
        
        system.debug('response:::'+res);
        system.debug('response:::'+res.getbody());
        return res;
    }
}