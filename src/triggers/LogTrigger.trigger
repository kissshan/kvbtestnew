trigger LogTrigger on clcommon__Log__c (after insert) {
    System.debug('Log Trigger');
    //LogTriggerHandler logTriggerHandlerobj = LogTriggerHandler.getInstance();
         
    //After insert
    if(Trigger.isAfter && Trigger.isInsert){
        LogTriggerHandler.call_ListMatching(trigger.new);
    }
}