trigger DocumentApplicantCreation on Digio_Document_ID__c (before insert,after insert,before update,after update) {
    
    if(Trigger.IsInsert & Trigger.Isbefore){
        EsignApplicantsMapping.ApplicantCreating(Trigger.new);
    }
    if(Trigger.isUpdate & Trigger.isAfter){
    	//EsignApplicantsMapping.getUUid_ForManualEsign(Trigger.new,Trigger.old,Trigger.newMap,Trigger.oldMap);    
    }
}