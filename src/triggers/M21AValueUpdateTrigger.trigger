trigger M21AValueUpdateTrigger on M21_A__c (after insert) {

    if(trigger.isAfter && trigger.IsInsert){
        M21AValueUpdateTriggerHandler.UpdateValueOnCollateral(trigger.new);
    }
}