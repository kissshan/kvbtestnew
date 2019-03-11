trigger DocCategoryJunctionTrigger on genesis__AppDocCatAttachmentJunction__c (before insert,before update,after insert,after  update) {
    if(Trigger.IsInsert & Trigger.Isbefore){
        UpdateDocName_Handler.getDocName(Trigger.new);
    } 
    if(Trigger.IsInsert & Trigger.IsAfter){
        //Delete other document and documentCategoryJunctionObject against document category after document insert
        DocumentFetch.deleteDocAndDocumentCategory(Trigger.newMap);
       
        UpdateDocName_Handler.updateDMS_Uuid(Trigger.new,Trigger.old,Trigger.newMap,Trigger.oldMap);
        UpdateDocName_Handler.updateCollateralDetails(Trigger.new);
        UpdateDocName_Handler.updatechecklist(Trigger.new);
    }
    if(Trigger.IsUpdate & Trigger.IsAfter){
        UpdateDocName_Handler.updateDMS_Uuid(Trigger.new,Trigger.old,Trigger.newMap,Trigger.oldMap);
    }
}