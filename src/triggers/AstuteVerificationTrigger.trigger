trigger AstuteVerificationTrigger on Astute_Verification__c (before insert, before update, after insert, after update) {

	if(trigger.isAfter && trigger.isUpdate){
		AstuteVerificationTriggerHandler.fiStatusUpdate(trigger.new);
	}
	if(trigger.isAfter && trigger.isInsert){
		AstuteVerificationTriggerHandler.fiStatusInsert(trigger.new);
	}

}