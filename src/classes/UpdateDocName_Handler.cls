/*
* Name    : UpdateDocName_Handler
* Company : ET Marlabs
* Purpose : This class is used to fetch attachment Name
* Author  : Subas
*/
public class UpdateDocName_Handler {
    public static void getDocName(List<genesis__AppDocCatAttachmentJunction__c > catJunctionList){
        try{
            List <String> attIdList = new List<String>();
            Map<Id,genesis__AppDocCatAttachmentJunction__c> attIdJuncObjMap = new Map<id,genesis__AppDocCatAttachmentJunction__c>();
            for(genesis__AppDocCatAttachmentJunction__c catJuncObj : catJunctionList){
                attIdList.add(catJuncObj.genesis__AttachmentId__c);
                attIdJuncObjMap.put(catJuncObj.genesis__AttachmentId__c,catJuncObj);
            }
            if(attIdList.size() >0){
                List <Attachment> attachList = [SELECT ID,Name FROM Attachment WHERE Id IN: attIdList];
                for(Attachment attach : attachList){
                    attIdJuncObjMap.get(attach.Id).Document_Name__c = attach.Name;
                }
            }
        }Catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
        //updateExternalId(catJunctionList);
    }
   /* public static void updateExternalId(List<genesis__AppDocCatAttachmentJunction__c > catJunctionList){
        
        try{
            for(genesis__AppDocCatAttachmentJunction__c	appDOcAttObj	:	catJunctionList){
                appDOcAttObj.Dms_Uuid__c	=   appDOcAttObj.genesis__AttachmentId__c;
            }
        }catch(Exception ex){
            System.debug('Exception'+ ex.getStackTraceString());  
        }    
    } */


    public static void updateCollateralDetails(List<genesis__AppDocCatAttachmentJunction__c > catJunctionList){
        List <String> allAppDocCatIds = new List<String>();
        Map <String,String> collNameByFieldToUpdate = new Map<String, String>();
        List<clcommon__Collateral__c> appCollListToBeUpdated = new List<clcommon__Collateral__c>();

        for(genesis__AppDocCatAttachmentJunction__c junctionObjRecord:catJunctionList){
            allAppDocCatIds.add(junctionObjRecord.genesis__Application_Document_Category__c);
        }
        if(!allAppDocCatIds.isEmpty()){
            List<genesis__Application_Document_Category__c> appDocCatList = [Select Id,Name from genesis__Application_Document_Category__c where Id IN:allAppDocCatIds And name like 'COL%'];

            if(!appDocCatList.isEmpty()){
                for(genesis__Application_Document_Category__c docCatRecord:appDocCatList){
                    String collName = (docCatRecord.Name).substringBefore(' ');
                    String docName = (docCatRecord.Name).substringAfter(' ');

                    if(collName != '' && docName !=''){
                        collNameByFieldToUpdate.put(collName,docName);
                    }
                }
            }
        }
        if(!collNameByFieldToUpdate.isEmpty()){

            List<clcommon__Collateral__c> appCollList = [SELECT Id,Name,recordtype.developername From clcommon__Collateral__c where Name IN:collNameByFieldToUpdate.keySet()];

            for(clcommon__Collateral__c colRec:appCollList){

                if(collNameByFieldToUpdate.containsKey(colRec.Name)){

                    clcommon__Collateral__c colInstanceToBeUpdated = new clcommon__Collateral__c(Id=colRec.Id);
                    String fieldToBeUpdated = collNameByFieldToUpdate.get(colRec.Name);
                    String recordtypename=colRec.recordtype.developername;
                    System.debug('fieldToBeUpdated '+fieldToBeUpdated+'recordtypename '+recordtypename);
                    if(fieldToBeUpdated == 'Sale_Deed' && recordtypename== 'Land_And_Building'){
                        colInstanceToBeUpdated.IsSaleDeedLoaded__c = true;
                    }
                    else if(fieldToBeUpdated == 'First_Completion_Certificate' && recordtypename =='Land_And_Building'){
                        colInstanceToBeUpdated.IsFirstCompletionCertificate__c = true;
                    }
                    else if(fieldToBeUpdated == 'Installation_Certificate' && recordtypename =='Commercial_Machinery'){
                        colInstanceToBeUpdated.IsInstallationCertificateLoaded__c=true;
                    }
                    else if(fieldToBeUpdated == 'Tax_Invoice' && recordtypename =='Commercial_Machinery'){
                        colInstanceToBeUpdated.IsTaxInvoiceLoaded__c=true;
                    }
                    else if(fieldToBeUpdated == 'RC_Copy' && recordtypename == 'Commercial_Vehicle'){
                        colInstanceToBeUpdated.IsRCCopyLoaded__c=true;
                    }
                    else if(fieldToBeUpdated == 'Tax_Copy' && recordtypename=='Commercial_Vehicle'){
                        colInstanceToBeUpdated.IsTaxInvoiceLoaded__c=true;
                    }
                    else if(fieldToBeUpdated == 'Installation_Certificate' && recordtypename=='Construction_Equipment'){
                        colInstanceToBeUpdated.IsInstallationCertificateLoaded__c=true;
                    }
                    else if(fieldToBeUpdated =='Tax_Invoice' && recordtypename=='Construction_Equipment'){
                        colInstanceToBeUpdated.IsTaxInvoiceLoaded__c=true;
                    }
                    else if(fieldToBeUpdated =='RC_Copy' && recordtypename=='Passenger_Vehicle'){
                        colInstanceToBeUpdated.IsRCCopyLoaded__c=true;
                    }
                    else if(fieldToBeUpdated =='Tax_Copy' && recordtypename=='Passenger_Vehicle'){
                        colInstanceToBeUpdated.IsTaxInvoiceLoaded__c=true;
                    }
                    else if(fieldToBeUpdated == 'Completion_Certificate' && recordtypename=='Other'){
                        colInstanceToBeUpdated.IsCompletionCertificateLoaded__c=true;
                    }
                    else if(fieldToBeUpdated == 'Tax_Invoice' && recordtypename=='Other'){
                        colInstanceToBeUpdated.IsTaxInvoiceLoaded__c=true;
                    }
                    else if(fieldToBeUpdated == 'CA_Certificate' && recordtypename=='Business_Term_Loan'){
                        colInstanceToBeUpdated.IsCACertificateLoaded__c=true;
                    }
                    appCollListToBeUpdated.add(colInstanceToBeUpdated);
                }
            }
        }
        if(!appCollListToBeUpdated.isEmpty()){
            update appCollListToBeUpdated;
        }
    }
    public static void updateDMS_Uuid(List<genesis__AppDocCatAttachmentJunction__c > newListOfAppDOCCat , List<genesis__AppDocCatAttachmentJunction__c > oldListOfAppDOCCat,Map<id,genesis__AppDocCatAttachmentJunction__c> newMapOfAppDOCCat,Map<id,genesis__AppDocCatAttachmentJunction__c> oldMapOfAppDOCCat){
        if(newListOfAppDOCCat !=null && newListOfAppDOCCat.size() > 0 && oldMapOfAppDOCCat !=null && !oldMapOfAppDOCCat.isEmpty()){
            for(genesis__AppDocCatAttachmentJunction__c appDOCCatAttObj		:	newListOfAppDOCCat){
                if(appDOCCatAttObj.genesis__AttachmentId__c !=null && appDOCCatAttObj.genesis__AttachmentId__c !=''){
                    if(oldMapOfAppDOCCat.get(appDOCCatAttObj.Id).genesis__AttachmentId__c != appDOCCatAttObj.genesis__AttachmentId__c){
                        getUuidByAttachmentId(appDOCCatAttObj.genesis__Application_Document_Category__c,appDOCCatAttObj.Id,appDOCCatAttObj.genesis__AttachmentId__c);	
                        
                    }    
                }    
                
            }
        }	    
    }
    @future(CallOut =true)
    public static void getUuidByAttachmentId(String appDocumentCategory, String appDOCCatAttId,String attachmentId){
        try{
            if(appDocumentCategory !=null && appDocumentCategory !='' && appDOCCatAttId !=null && appDOCCatAttId !='' && attachmentId !=null && attachmentId !=''){
                Attachment	attachmentObj	=	[select id,ParentId,Name,ContentType,Body from  Attachment where id =:attachmentId];
                genesis__Application_Document_Category__c	appDocumentCatObj	=	[select id,genesis__Application__c,genesis__Application__r.CustomerID__c,genesis__Application__r.Record_Type_Name__c from genesis__Application_Document_Category__c where id =:appDocumentCategory];
                if(appDocumentCatObj !=null && attachmentObj !=null){
                    WS_UploadDMSDocument.getAttachement(appDocumentCatObj.genesis__Application__c,appDocumentCatObj.genesis__Application__r.CustomerID__c,appDocumentCatObj.genesis__Application__r.Record_Type_Name__c,'',attachmentObj,appDOCCatAttId);
                }
            }
        }catch(Exception ex){
            System.debug('Exception ::'+ ex.getMessage());
        	HandleBusinessException.captureError('UpdateDocName_Handler', 'getUuidByAttachmentId', ex);    
        }
    }

    public static void updatechecklist(List<genesis__AppDocCatAttachmentJunction__c > catJunctionList){
        List <String> allAppDocCatIds = new List<String>();
        List <String> checklisttobeupdted = new List<String>();
        List<genesis__Checklist__c> checklistsInstancetobeupdated=new List<genesis__Checklist__c>();
        Set<String> applicationid=new Set<String>();
        try{
        for(genesis__AppDocCatAttachmentJunction__c junctionObjRecord:catJunctionList){
            allAppDocCatIds.add(junctionObjRecord.genesis__Application_Document_Category__c);
        }

        if(!allAppDocCatIds.isEmpty()){
            List<genesis__Application_Document_Category__c> appDocCatList = [Select Id,Name,genesis__Application__r.id from genesis__Application_Document_Category__c where Id IN:allAppDocCatIds And name like 'CheckList%'];
            System.debug(appDocCatList);
            if(!appDocCatList.isEmpty()){
                for(genesis__Application_Document_Category__c docCatRecord:appDocCatList){
                    //String collName = (docCatRecord.Name).substringBefore(' ');
                    checklisttobeupdted.add((docCatRecord.Name).substringAfter(' '));
                    applicationid.add(docCatRecord.genesis__Application__r.id);
                }
            }
        }
        System.debug(applicationid);
        System.debug(checklisttobeupdted);
        if(!checklisttobeupdted.isEmpty()){

            List<genesis__Checklist__c> checklists=[select id,OneDocumentUpload__c from genesis__Checklist__c where name__c in :checklisttobeupdted and genesis__Application__r.id in :applicationid];
            System.debug(checklists);
            for(genesis__Checklist__c checklistInstance:checklists){
                checklistInstance.OneDocumentUpload__c=true;
                checklistsInstancetobeupdated.add(checklistInstance);
            }

        }
        System.debug(checklistsInstancetobeupdated);
        if(!checklistsInstancetobeupdated.isEmpty()){
            update checklistsInstancetobeupdated;
        }
    }
    catch(Exception ex){
        HandleBusinessException.captureError('UpdateDocName_Handler', 'updatechecklist', ex);
    }

    }
}