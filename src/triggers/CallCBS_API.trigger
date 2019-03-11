trigger CallCBS_API on CBS_API_Log__c (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        //call CBS call CLass
        if(CBS_API_Calling_HL.runCBS_LogTrigger){
            CBS_API_Calling_HL.call_CBS_log(Trigger.new);
        }
    }
}