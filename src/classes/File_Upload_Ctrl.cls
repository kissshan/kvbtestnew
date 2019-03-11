/*
* Name      : File_Upload_Ctrl
* Company   : ET Marlabs
* Purpose   : Controller class for File_Upload Vf page.
* Author    : Braj
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
   v1.1    13-Nov-2018    Braj          Changes done to show uploaded documents in skuid folder
*******************************************************************************************/
public with sharing class File_Upload_Ctrl {
    public Attachment attach {get;set;}

    public File_Upload_Ctrl(){
    	attach = new Attachment();
    }

    public PageReference upload(){
        try {
            if(attach.Body!=null) {
                attach.OwnerId = UserInfo.getUserId();
                String digioDacId   = apexpages.currentpage().getparameters().get('id');
                Digio_Document_ID__c digioDocumentId = new Digio_Document_ID__c();
                if (digioDacId!=null) {
                    digioDocumentId = [select id,Name,Application__c,Application__r.Name,Application__r.Record_Type_Name__c,Document_ID__c from Digio_Document_ID__c where id =:digioDacId];
                }
	                List<Attachment> attachLst = new List<Attachment>();
	                if (digioDocumentId!=null) {
	                    if(digioDocumentId.Application__r.Record_Type_Name__c == Constants.HOMELOAN || digioDocumentId.Application__r.Record_Type_Name__c == Constants.LAPLOAN || digioDocumentId.Application__r.Record_Type_Name__c == Constants.PERSONALLOAN || digioDocumentId.Application__r.Record_Type_Name__c == Constants.VL2W || digioDocumentId.Application__r.Record_Type_Name__c == Constants.VL4W){

	                    attachLst = [select Id,Name,ParentId from Attachment where ParentId=:digioDocumentId.Application__c and Name Like:digioDocumentId.Name+'_Uploaded%'];
                            system.debug('attachLst:-'+attachLst);
	                    if (attachLst.size()>0){
	                        Delete attachLst;
	                    }
	                    if(digioDocumentId!=null){
                            system.debug('digioDocumentId.Application__c:-'+digioDocumentId.Application__c);
                            if(!test.isRunningTest())
                            {
	                        attach.ParentId = digioDocumentId.Application__c;
	                        attach.Name = digioDocumentId.Name+'_Uploaded.'+attach.ContentType.split('/')[1];
	                        attach.IsPrivate = false;
	                        System.debug('attach>>>'+attach);
	                        insert attach;
                            }
	                        if(attach.Id!=null) {
	                            digioDocumentId.Document_ID__c  = attach.Id;
	                            update digioDocumentId;
	                        }
                            //v1.1(start)
                            List<genesis__Application_Document_Category__c> GAdc=[select id from genesis__Application_Document_Category__c where name=:Constants.LoanDocuments And  genesis__Application__c=:digioDocumentId.Application__c limit 1];
                            List<genesis__AppDocCatAttachmentJunction__c> GaList=[select id,genesis__AttachmentId__c from genesis__AppDocCatAttachmentJunction__c where genesis__AttachmentId__c=:attach.id and genesis__Application_Document_Category__c=:GAdc[0].id and Document_Name__c=:attach.Name+'.pdf' limit 1] ;
                            
                            if(GaList.isEmpty()){
                                genesis__AppDocCatAttachmentJunction__c AAJ=new genesis__AppDocCatAttachmentJunction__c();
                                AAJ.genesis__Application_Document_Category__c=GAdc[0].id;
                                AAJ.genesis__AttachmentId__c=attach.id;
                                AAJ.Document_Name__c =attach.Name;
                                insert AAJ;
                            }
                            //v1.1(end)
	                        PageReference pageRef = new PageReference('/'+digioDocumentId.Application__c);
                			pageRef.setRedirect(true);
	                        return pageRef;
	                    }
	                }
                }
                 
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Attachment not found!!'));
            }
        } catch (Exception ex){
            HandleBusinessException.captureError('AttachmentUploadController', 'upload', ex);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment!'));
            return null;
        }
        return null;
    }

    public PageReference cancel(){
        try {
            String digioDacId   = apexpages.currentpage().getparameters().get('id');
            Digio_Document_ID__c digioDocumentId = new Digio_Document_ID__c();
            if (digioDacId!=null) {
                digioDocumentId = [select id,Name,Application__c from Digio_Document_ID__c where id =:digioDacId];
            }
            if (digioDocumentId.Application__c!=null) {
                PageReference pageRef = new PageReference('/'+digioDocumentId.Application__c);
                pageRef.setRedirect(true);
                return pageRef;
            }
            return null;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Something went wrong! Retry again..'));
            return null;
        }
        
    }
}