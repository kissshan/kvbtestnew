/*
* Name          : PerfiosErrorTrigger
* Description   : Haldles all events for perfios error
* Author        : Dushyant
*/
trigger PerfiosErrorTrigger on Perfios_Error__c (before insert, before update, after update) {
    //Handler singleton object
    PerfiosErrorTriggerHandler perfErrorObj = PerfiosErrorTriggerHandler.getInstance();
    
    //Update application stage on transaction id update for perfios error update getInstance
    if(trigger.isInsert && trigger.isAfter){
        perfErrorObj.updateApplicationStatus(trigger.new);
    }
}