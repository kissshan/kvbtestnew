/*
* Name          : Docket_Download_Service
* Description   : Handles Docket download request/response
* Author        : Dushyant
*/
public class Docket_Download_Service {
    public static void downloadRequest(String docketId, String appId){
        //genesis__Applications__c application = [SELECT Id,Name FROM genesis__Applications__c WHERE Id =: appId];
        Docket_Download_Service.EDownloadRequest eDownReq = new Docket_Download_Service.EDownloadRequest();
        map<String,String> docNameBodyMap = new Map<String,String>();
        //preparing request structure
        eDownReq.exe_tenantId           = 'cuecent_tenant';
        eDownReq.owner_tenantId         = 'cuecent_tenant'; 
        eDownReq.inputVariables         = new Docket_Download_Service.cls_inputVariables();
        eDownReq.inputVariables.in_msg  = '';
        eDownReq.inputVariables.documetId   = docketId;
        
        string reqStr = JSON.serialize(eDownReq);
        System.debug(reqStr);
        //Callout to download Docket
        HTTPResponse response           = new HTTPResponse();
        Map<String,String> headerMap    = new Map<String,String>();             
        headerMap.put('Content-Type','application/json');
        response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('DocketESignDownload'), 'POST', null,reqStr,headerMap,label.CA_CERTIFICATE);
        
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();
            system.debug('jsonData::'+jsonString);
            Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
            System.debug(obj.get('outMap'));
            
            Map<String, Object> outMap = (Map<String,Object>)obj.get('outMap');
            
            if(outMap.get('ErrorCode') == '00' && outMap.get('ErrorMessage') == 'Success'){
                List<Object> documentObjList = (List<Object>)outMap.get('documents');
                for(Object key : documentObjList){
                    System.debug(key);
                    Map<String, Object> fileContentObjList = (Map<String, Object>)key;
                    docNameBodyMap.put((String)fileContentObjList.get('file_name'),(String)fileContentObjList.get('file_content'));
                }  
                for(String s: docNameBodyMap.keySet()){
                    System.debug(s);
                    System.debug(docNameBodyMap.get(s));
                }
                replaceDocument(docNameBodyMap,appId);
            }
            
            else{
                throw new CustomException('Error occured while downloading. Response code- '+outMap.get('ErrorCode')+', Error message-'+outMap.get('ErrorMessage'));
            }
                
            
            
        }else{
            system.debug('**Status code-'+response.getStatusCode()+' **Status-'+response.getStatus()); 
            throw new CustomException('DIGIO download failed. Status code-'+response.getStatusCode());
        }
    }
    //Update signed docket
    public static void replaceDocument(Map<String,String> docDetails, String appId){
        List<Attachment> attList = new List<Attachment>();
        //Attachment att = new Attachment();
        attList = [Select Id,Body,ParentId,Name from Attachment where ParentId=:appId AND Name IN :docDetails.keySet()];
        if(!attList.isEmpty()){
            for(Attachment att: attList){
                att.Body = EncodingUtil.base64Decode(docDetails.get(att.Name));
            }
            UPDATE attList;
        }
    }
    // Request Wrapper classes
    public class EDownloadRequest{
        public String exe_tenantId;
        public String owner_tenantId;
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public String in_msg;
        public String documetId;
    }
}