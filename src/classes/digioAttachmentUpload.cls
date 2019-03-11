public class digioAttachmentUpload {
    @RemoteAction
    public static List<Digio_Document_ID__c> getAllDigioRecords(String abc){
        return [SELECT Id,name,Document_ID__c,Signed__c ,Signed_by_Customer_Uploaded__c,View_Document__c,Document_Complete__c,Reviewer_Comments__c from Digio_Document_ID__c where Application__c='a4V0l0000004oUt'];
    }
    
    
    
    
    
    
    @RemoteAction
    public static String doUploadAttachment(String recId, String attachmentBody, String attachmentName, String attachmentId) {
        if(recId != null) {
            
                if(attachmentBody != null) {
                    Attachment att = getAttachment(attachmentId);
                    String newBody = '';
                    if(att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);
                    }
                    newBody += attachmentBody;
                    att.Body = EncodingUtil.base64Decode(newBody);
                    if(attachmentId == null) {
                        att.Name = attachmentName;
                        att.parentId = recId;
                    }
                    upsert att;
                    return att.Id;
                } else {
                    return 'Attachment Body was null';
                }
            
        } else {
            return 'Account Id was null';
        }
    }
     
    
     
    
     
    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }
}