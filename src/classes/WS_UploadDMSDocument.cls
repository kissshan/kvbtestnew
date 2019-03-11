/*
* Name          : WS_UploadDMSDocument
* Description   : API for upload Attachement to DMS from Los. 
* Author        : Raushan Abhishek
*/
global class WS_UploadDMSDocument {
    
    public static void getAttachement(String appId,String customerId,String recordTypName,String digioDocumentId,Attachment attachmentObj,String appDOCCatAttId){
        
        if(appId !=null && appId != '' && attachmentObj !=null && recordTypName.contains('SME')){
            try{
            System.debug('attachmentObj@@@'+attachmentObj);
            Boolean isAppDOCJuc_Attachement	=	true;
            Request_Structure	reqObj	=	new Request_Structure();
            reqObj.parentFolderUuid		=	'';
            reqObj.name					=	attachmentObj.Name;
            reqObj.mineType				=	attachmentObj.ContentType;
            reqObj.fileString			=	EncodingUtil.base64Encode(attachmentObj.Body);
            reqObj.ext					=	attachmentObj.ContentType!= null ? attachmentObj.ContentType.split('/')[1] :null;
            reqObj.root					=	false;
            reqObj.metadata				=	new Metadata();
            reqObj.metadata.applicationType	=	recordTypName;
            reqObj.metadata.applicationId	=	appId;
            reqObj.metadata.customerId		=	customerId;
            reqObj.metadata.documentType	=	attachmentObj.ContentType;

                Map<String,String> headerMap   = new Map<String,String>();
                System.debug('Access Toiken'+WS_ApiGatewayAccToken.getAccTkn());
                headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
                headerMap.put('Content-Type', 'application/json');
                HttpResponse response  = new HttpResponse();
                System.debug('Header Map'+headerMap);
                response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('Dms_Upload_Document'),'POST',null, json.serialize(reqObj),headerMap,null);
                
                If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    String jsonData         = response.getBody();
                    System.debug('jsonData@@'+jsonData);
                    Response_Structure resObj	=	(Response_Structure)System.JSON.deserialize(jsonData, Response_Structure.class);
                    if(digioDocumentId !=null && digioDocumentId !=''){
                        Digio_Document_ID__c	digioDocumentObj	=	new Digio_Document_ID__c();
                        digioDocumentObj.id	=	digioDocumentId; 
                        if(resObj.data !=null && resObj.data !=''){
                            digioDocumentObj.DMS_UUID__c	=   resObj.data;
                            digioDocumentObj.Document_ID__c =	'';
                        }
                        
                        update digioDocumentObj;
                    }
                    if(appDOCCatAttId !=null && appDOCCatAttId !=''){
                        
                        genesis__AppDocCatAttachmentJunction__c	appDOCCatAttObj	=	new genesis__AppDocCatAttachmentJunction__c();
                        appDOCCatAttObj.id	=	appDOCCatAttId;
                        if(resObj.data !=null && resObj.data !=''){
                            appDocCatAttObj.DMS_UUID__c	=   resObj.data;
                            appDocCatAttObj.genesis__AttachmentId__c = '';
                        }
                        
                        update appDOCCatAttObj; 
                    }
                    if(resObj.status !=null && resObj.status ==1){
                    	delete attachmentObj;    
                    }
                }else{
               		System.debug('response@@@@@'+response.getStatusCode() + 'Body'+ response.getBody());     
                }
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() + 'AT '+ ex.getLineNumber());

            }
        }
    }
    public class Request_Structure {
        
        public String parentFolderUuid;
        public String name;
        public String mineType;
        public String fileString;
        public Metadata metadata;
        public String ext;
        public Boolean root;
    }
    public class Metadata {
        public String applicationType;
        public String applicationId;
        public String customerId;
        public String documentType;
        public String accountNumbers;
    }
    public class Response_Structure {
        public Integer status;
        public String data;
        public String errorMessage;
        public String errorCode;
    }
    
}