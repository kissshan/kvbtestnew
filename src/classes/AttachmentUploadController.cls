/*
* Name      : AttachmentUploadController
* Company   : ET Marlabs
* Purpose   : Controller class for AttachmentUploadVfPage page.
* Author    : Raushan
*/
public with sharing class AttachmentUploadController {
    public String Content_Type {get;set;}
     public genesis__Applications__c appRecord{get;set;}
    public Digio_Document_ID__c    digioDocumentId{get;set;}
     public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    public AttachmentUploadController(){
        
        String URL =ApexPages.currentPage().getUrl();
        String subUrl   =   URL.split('id=')[1];
        subUrl          =   subUrl.split('&')[0];
        digioDocumentId = [select id,Name,Document_ID__c ,Application__c,Application__r.Name from Digio_Document_ID__c where id =:subUrl];

        appRecord =[Select Id,Name from genesis__Applications__c where Id=:digioDocumentId.Application__c];
        
        
    }
    public void upload() {
        try {
            attachment.OwnerId = UserInfo.getUserId();
            String digioDacId   = apexpages.currentpage().getparameters().get('id');
            Digio_Document_ID__c    digioDocumentId = [select id,Name,Document_ID__c ,Application__c,Application__r.Name from Digio_Document_ID__c where id =:digioDacId];
            if(digioDocumentId !=null){
                attachment.ParentId = digioDocumentId.Application__c;
                attachment.Name     =   digioDocumentId.Name +'.'+ Content_Type.split('/')[1];
                attachment.ContentType  = Content_Type;
                attachment.IsPrivate = false;
               
                insert attachment;
                digioDocumentId.Document_ID__c  = attachment.Id;
                update digioDocumentId;  
                
            }
            
                      
            
        } catch (Exception ex) {
            HandleBusinessException.captureError('AttachmentUploadController', 'upload', ex);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
        } 
        
    }
    
}