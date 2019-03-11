/*
* Name          : DMS_Service
* Description   : Handle DMS Services(Doc Generation, Class-2 Sign and E-Sign)
* Author        : Dushyant kkkkkkk ssssss
*/ 
public class DMS_Service{
    static string accessToken = '';
    
    public static DMS_Structure.DocumentUploadRes docGeneration(String reqJSON){
        if(reqJSON == null || reqJSON == ''){
            throw new CustomException('null template generated');
        }
        else{
            Map<String,String> headerMap = new Map<String,String>();
            HTTPResponse response = new HTTPResponse();
            DMS_Structure.DocumentUploadRes resObj = new DMS_Structure.DocumentUploadRes();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('DocGenerationDMS'), 'POST', null,reqJSON,headerMap,null);
            System.debug('%%%%%%::>>'+response);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String resString = response.getBody();
                System.debug('resString:::: ' + resString);
                resObj = (DMS_Structure.DocumentUploadRes)Json.deserialize(resString, DMS_Structure.DocumentUploadRes.class); 
                System.debug('RESPONSE::::: '+resObj);
                if(resObj == null || resObj.uuid == null || resObj.totalPages == null){
                    throw new CustomException('Doc Generation Failed.');
                }
                //decimal.valueOf('SVK');                
                return resObj;
            }else{
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
        }
    }
    public static String digioDocumentIdGeneration(Digio_ESign_Service.ESignRequest eSignReq){
        HTTPResponse response = new HTTPResponse();
        Map<String,String> headerMap = new Map<String,String>();              
        headerMap.put('Content-Type','application/json'); 
        if(eSignReq == null) throw new CustomException('Invalid Request for E-Sign');
        string reqStr = JSON.serialize(eSignReq);
        response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('DigioESign'), 'POST', null,reqStr,headerMap,label.CA_CERTIFICATE);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonData = response.getBody();
            system.debug('jsonData::'+jsonData);
            DMS_Structure.ESignResponse eSignRes = (DMS_Structure.ESignResponse)Json.deserialize(jsonData, DMS_Structure.ESignResponse.class);
            if(eSignRes == null || eSignRes.outMap == null 
               || eSignRes.outMap.id == null || eSignRes.outMap.id == ''){
                throw new CustomException('No Response from Digio');
            }
            return eSignRes.outMap.id;
        }else{
            system.debug('**Status code-'+response.getStatusCode()+' **Status-'+response.getStatus()); 
            throw new CustomException('DIGIO ESign failed. Status code-'+response.getStatusCode());
        }
    }


    /*
        Name    -- getEDocs
        Purpose -- Method to generate the document from DIGIO
    */
    public static DMS_Structure.documentUploadRes getEDocs(String appId,String documentName,String templateName){
        try{
            HTTPResponse response = new HTTPResponse(); 
            String req                  = '';
            if(documentName == Constants.SANCTION_TEMPLATE_SME || documentName == Constants.PROV_SANCTION_TEMPLATE_SME
               || documentName == Constants.SME_SANCTION_Letter123 || documentName == Constants.SME_SANCTION_Letter12
               || documentName == Constants.SME_SANCTION_Letter1 || documentName == Constants.SME_SANCTION_Letter13)                
                req = JSON.serialize(DigioTemplateService.getSMESanctionLetter(appId,documentName,templateName));
            
            system.debug('req::'+req); 
            if(req != null && req != ''){ 
                accessToken = WS_ApiGatewayAccToken.getAccTkn();
                Map<String,String> headerMap                            = new Map<String,String>();
                headerMap.put('Content-Type','application/json');
                headerMap.put('Authorization',accessToken);
                
                response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('DocGenerationDMS'), 'POST', null,req,headerMap,null);
                If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    String signedDoc = response.getBody();  
                    system.debug('signedDoc::'+signedDoc);            
                    DMS_Structure.documentUploadRes resObj = (DMS_Structure.documentUploadRes)Json.deserialize(signedDoc, DMS_Structure.documentUploadRes.class);
                    if(resObj == null || resObj.uuid == null){
                        //throw new CustomException('Status Code-'+appReqObj.code+' Message-'+appReqObj.message);
                        throw new CustomException('Document generation failed!!!');
                    }
                    system.debug('uuid::'+resObj.uuid);
                    RETURN resObj;  
                }
                else{
                    throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
                }
            }
            else{
                throw new CustomException('Null template generated');
            }
        }
        catch(Exception e){
            system.debug('Exception in eDoc generation '+e.getMessage()+' Stack '+e.getStackTraceString()+'Line Number'+e.getLineNumber());
            System.debug(' Cause  ' + e.getCause());
            throw new CustomException('DIGIO document generation failed-'+e.getMessage());
        }
    }
    
    /*
* Method to request for Class-2 Sign for a document
*/
    public static String class2Signer(String uuId,String applicationType,String appId,String customerId,String documentName,integer pageCount){
        System.debug('@@@@::: for class 2 sign:::@@@@');
        try{
            accessToken = WS_ApiGatewayAccToken.getAccTkn();
            KVB_Company_Details__c company = KVB_Company_Details__c.getOrgDefaults();
            
            HTTPResponse response = new HTTPResponse(); 
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',accessToken);
            
            DMS_Structure.class2Req reqWrp    = new DMS_Structure.class2Req();
            reqWrp.exe_tenantId     = 'cuecent_tenant';
            reqWrp.owner_tenantId    = 'cuecent_tenant';
            reqWrp.applicationType    = applicationType;
            reqWrp.applicationId    = appId;
            reqWrp.customerId    = customerId;
            reqWrp.documentType    = documentName;
            reqWrp.accountNumbers    = '1';
            reqWrp.uuid    = uuId;
            reqWrp.inputVariables    = new DMS_Structure.cls_inputVariables_1();
            reqWrp.inputVariables.in_msg = '';
            reqWrp.inputVariables.inputMap = new DMS_Structure.cls_inputMap();
            reqWrp.inputVariables.inputMap.name    = SYSTEM.LABEL.DigioKeyPersonName;
            reqWrp.inputVariables.inputMap.key_store_name    = company.Key_Store_Name__c;
            reqWrp.inputVariables.inputMap.reason    = documentName;
            reqWrp.inputVariables.inputMap.location    = company.City__c;
            reqWrp.inputVariables.inputMap.display_on_page    = 'custom';
            
            reqWrp.inputVariables.inputMap.sign_coordinates = new Map<Integer,List<Object>>();
            
            if(documentName == Constants.SANCTION_TEMPLATE_SME || documentName == Constants.SME_SANCTION_Letter123){    
                DMS_Structure.cls_1 con = new DMS_Structure.cls_1(414.79,553.29,523.54,626.44);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-9, new List<Object>{con});
            }
            if(documentName == Constants.SME_SANCTION_Letter1 ){
                DMS_Structure.cls_1 con = new DMS_Structure.cls_1(414.79,553.29,523.54,626.44);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-4, new List<Object>{con});
            }
            if(documentName == Constants.SME_SANCTION_Letter12){
                DMS_Structure.cls_1 con = new DMS_Structure.cls_1(414.79,553.29,523.54,626.44);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-5, new List<Object>{con});
            }
            if(documentName == Constants.SME_SANCTION_Letter13){
                DMS_Structure.cls_1 con = new DMS_Structure.cls_1(414.79,553.29,523.54,626.44);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-8, new List<Object>{con});
            }
            if(documentName == Constants.PROV_SANCTION_TEMPLATE_SME){ 
                DMS_Structure.cls_1 con = new DMS_Structure.cls_1(375.18,569.89,521.21,644.52);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-4, new List<Object>{con});
            }
            string reqString = JSON.serialize(reqWrp);
            System.debug('reqString::'+reqString);
            
            response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('DocSigner'), 'POST', null,reqString,headerMap,null);
            System.debug('response:::::response::::'+response);
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String signedDoc = response.getBody();  
                system.debug('signedDoc::'+signedDoc);            
                DMS_Structure.documentUploadRes resObj = (DMS_Structure.documentUploadRes)Json.deserialize(signedDoc, DMS_Structure.documentUploadRes.class);
                if(resObj == null || resObj.uuid == null){
                    throw new CustomException('Class-2 Sign Failed.Invalid Response Received.');
                }
                system.debug('uuid::'+resObj.uuid);
                return resObj.uuid;  
            }
            else{
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
        }catch(Exception e){            
            system.debug('Exception in DocSigner '+e.getMessage()+' Stack '+e.getStackTraceString());
            throw new CustomException('Class-2/3 Failed-'+e.getMessage());
        }
    }
    public static String getESigned(DMS_Structure.ESignRequest eSignReq){
        String accessToken = WS_ApiGatewayAccToken.getAccTkn();
        HTTPResponse response = new HTTPResponse();
        Map<String,String> headerMap = new Map<String,String>();              
        headerMap.put('Content-Type','application/json'); 
        headerMap.put('Authorization',accessToken); 
        if(eSignReq == null) throw new CustomException('Invalid Request for E-Sign');
        string reqStr = JSON.serialize(eSignReq);
        system.debug('E-Sign reqStr::'+reqStr);
        response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('DigioESign'), 'POST', null,reqStr,headerMap,label.CA_CERTIFICATE);
        
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonData = response.getBody();
            system.debug('jsonData::'+jsonData);
            DMS_Structure.ESignResponse appReqObj = (DMS_Structure.ESignResponse)Json.deserialize(jsonData, DMS_Structure.ESignResponse.class);
            if(appReqObj == null || appReqObj.outMap == null 
               || appReqObj.outMap.id == null || appReqObj.outMap.id == ''){
                   throw new CustomException('No Response from Digio');
               }
            return appReqObj.outMap.id;
        }else{
            system.debug('**Status code-'+response.getStatusCode()+' **Status-'+response.getStatus()); 
            throw new CustomException('DIGIO ESign failed. Status code-'+response.getStatusCode());
        }
    }
    public static String uploadDocument_DMS(String parentFolderUuid, String custId, String appId, String appType, String fileName, String fileContent){
        String accessToken;
		DMS_Structure.uploadDocReq reqObj = new DMS_Structure.uploadDocReq();
		DMS_Structure.cls_metadata reqmetadataObj = new DMS_Structure.cls_metadata();
		List<genesis__AppDocCatAttachmentJunction__c> appDocJunList = new List<genesis__AppDocCatAttachmentJunction__c>();
		 appDocJunList = [SELECT Id,Dms_Uuid__c,genesis__Application_Document_Category__c,genesis__Application_Document_Category__r.Name,genesis__Application_Document_Category__r.genesis__Application__r.RecordType_Developer_Name__c,genesis__Application_Document_Category__r.genesis__Application__c,genesis__Application_Document_Category__r.genesis__Application__r.CustomerID__c
                          FROM genesis__AppDocCatAttachmentJunction__c WHERE genesis__Application_Document_Category__r.genesis__Application__r.RecordType_Developer_Name__c =: appType  
						  AND genesis__Application_Document_Category__r.genesis__Application__r.CustomerID__c =: custId 
						  AND genesis__Application_Document_Category__r.genesis__Application__r.Id =: appId];
        for(genesis__AppDocCatAttachmentJunction__c appDocJn: appDocJunList){
            reqObj.parentFolderUuid = parentFolderUuid;//appDocJn.Dms_Uuid__c;
            reqObj.mineType = 'application/pdf';
            reqObj.ext = '.pdf';
            reqObj.root = false;
            reqObj.fileString = fileContent;
            reqObj.name = fileName;
            reqmetadataObj.applicationType = appDocJn.genesis__Application_Document_Category__r.genesis__Application__r.RecordType_Developer_Name__c;
			reqmetadataObj.applicationId = appDocJn.genesis__Application_Document_Category__r.genesis__Application__c;
			reqmetadataObj.customerId = appDocJn.genesis__Application_Document_Category__r.genesis__Application__r.CustomerID__c;
			reqmetadataObj.documentType = appDocJn.genesis__Application_Document_Category__r.Name;
            reqmetadataObj.accountNumbers = '';
            
            reqObj.metadata = reqmetadataObj;
        } 
		accessToken = WS_ApiGatewayAccToken.getAccTkn();
        system.debug('Accesstoken***'+accessToken);
        string reqStr = JSON.serialize(reqObj);
        System.debug('Request===> '+reqStr);
        HTTPResponse response = new HTTPResponse();
        Map<String,String> headerMap = new Map<String,String>();  
        headerMap.put('Authorization',accessToken);
        response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('Dms_Upload_Document'), 'POST', null,reqStr,headerMap,null);
        String jsonData = response.getBody();
        System.debug('Response===> '+jsonData);
         DMS_Structure.uploadDocRes resObj = new DMS_Structure.uploadDocRes();
        if(response.getStatuscode()== 201 || response.getStatuscode()== 200){
            resObj = (DMS_Structure.uploadDocRes)Json.deserialize(jsonData, DMS_Structure.uploadDocRes.class);          
            System.debug('Metadata Updated'+resObj); 
            RETURN String.valueof(resObj.data);
        }
        RETURN null;
     }
}