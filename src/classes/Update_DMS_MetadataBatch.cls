/*
* Name          : Update_DMS_MetadataBatch
* Description   : Batch to update metadata to DMS
* Author        : Laxman
*/
public class Update_DMS_MetadataBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public String accessToken;
    public String whereCondition = '';
    public Update_DMS_MetadataBatch(String condition){
        whereCondition = condition;
    }
    public Database.QueryLocator start(Database.BatchableContext BC){
        if(whereCondition == null || whereCondition == '')
            whereCondition = 'Active__c = True AND RecordType_Developer_Name__c IN (\'SME_Renewal\',\'SME_Exceeding\',\'SME_Enhancement\',\'SME_AdHoc\',\'SME_NEW_Loan\')  AND Application_Stage__c = \'Limit Opened\'';
        String query = 'SELECT Id,Name,Active__c,CustomerID__c,Application_Stage__c,RecordType_Developer_Name__c, (SELECT Id,Account_Number__c FROM Facilities__r), (SELECT Id,Name FROM genesis__Application_Document_Category__r) FROM genesis__Applications__c WHERE ';
        query += whereCondition;
        system.debug('query***'+query);
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> AppList){
        if(AppList.size() > 0){
            accessToken = WS_ApiGatewayAccToken.getAccTkn();
            system.debug('Accesstoken***'+accessToken);
        }
        UpdateDMSMetadataFormatter dmsmetadata = new UpdateDMSMetadataFormatter();
        UpdateDMSMetadataFormatter.metadataProps propObj = new UpdateDMSMetadataFormatter.metadataProps();
        List<UpdateDMSMetadataFormatter.updateMetadataReq> updateMetadataReqList = new List<UpdateDMSMetadataFormatter.updateMetadataReq>();
        List<genesis__AppDocCatAttachmentJunction__c> appDocJunList = new List<genesis__AppDocCatAttachmentJunction__c>();
        Set<Id> documentId = new Set<Id>();
        Map<String,genesis__AppDocCatAttachmentJunction__c> AppDocMap = new Map<String,genesis__AppDocCatAttachmentJunction__c>();
        for(genesis__Applications__c appobj : AppList){
            propObj.applicationId= appobj.Name;
            propObj.applicationType= appobj.RecordType_Developer_Name__c;
            propObj.customerId= appobj.CustomerID__c;
            for(Facility__c facilityobj : appobj.Facilities__r){
                propObj.accountNumbers = facilityobj.Account_Number__c;
            }
            for(genesis__Application_Document_Category__c docobj : appobj.genesis__Application_Document_Category__r){
                documentId.add(docobj.Id);
                propObj.documentType = docobj.Name;
            }
        }
        appDocJunList = [SELECT Id,Dms_Uuid__c,Success_Error_Msg__c FROM genesis__AppDocCatAttachmentJunction__c WHERE genesis__Application_Document_Category__c IN : documentId];
        for(genesis__AppDocCatAttachmentJunction__c appDocJn: appDocJunList){
            UpdateDMSMetadataFormatter.updateMetadataReq reqObj = new UpdateDMSMetadataFormatter.updateMetadataReq();
            reqObj.uuid = Integer.valueof(appDocJn.Dms_Uuid__c); 
            AppDocMap.put(appDocJn.Dms_Uuid__c, appDocJn);
            
            reqObj.properties = propObj;
            updateMetadataReqList.add(reqObj);
            dmsmetadata.updateMetadataReq = updateMetadataReqList;
        }  
        string reqStr = JSON.serialize(dmsmetadata.updateMetadataReq);
        System.debug('FinancialProcess Req===> '+reqStr);
        HTTPResponse response = new HTTPResponse();
        Map<String,String> headerMap = new Map<String,String>();  
        headerMap.put('Authorization',accessToken);
        response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('Update DMS Metadata'), 'POST', null,reqStr,headerMap,null);
        String jsonData = response.getBody();
        System.debug('Response===> '+jsonData);
        UpdateDMSMetadataFormatter.updateMetadataRes resObj = new UpdateDMSMetadataFormatter.updateMetadataRes();
        if(response.getStatuscode()== 201 || response.getStatuscode()== 200){
            resObj = (UpdateDMSMetadataFormatter.updateMetadataRes)Json.deserialize(jsonData, UpdateDMSMetadataFormatter.updateMetadataRes.class);          
            System.debug('Metadata Updated'+resObj); 
        }
        List<Integer> successList = resObj.data.Success_UUID;
        System.debug('successList'+successList);
        List<String>  errormsgList = resObj.data.Failed_ErrorMsg;
        System.debug('errormsgList'+errormsgList);
        List<genesis__AppDocCatAttachmentJunction__c> UpdateAppDocCatAttJunList = new List<genesis__AppDocCatAttachmentJunction__c>();        
        for(genesis__AppDocCatAttachmentJunction__c appDocJn: appDocJunList){
            if(appDocJn.Dms_Uuid__c == AppDocMap.get(appDocJn.Dms_Uuid__c).Dms_Uuid__c){
                if(successList.size() > 0){
                    appDocJn.Success_Error_Msg__c = 'Metadata Updated';
                    System.debug('appDocJn.Success_Error_Msg__c++*'+appDocJn.Success_Error_Msg__c);
                }else if(errormsgList.size() > 0){
                    appDocJn.Success_Error_Msg__c = errormsgList[0]+','+appDocJn.Dms_Uuid__c;
                    System.debug('appDocJn.Success_Error_Msg__c>>>'+appDocJn.Success_Error_Msg__c);
                }
                UpdateAppDocCatAttJunList.add(appDocJn);     
            }        
        }
        update UpdateAppDocCatAttJunList;
    }
    public void finish(Database.BatchableContext BC){}
}