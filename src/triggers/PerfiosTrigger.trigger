/* 
* Name     : PerfiosTrigger
* Purpose  : Trigger class to handle events on Perfios object
* Company  : ET Marlabs            appTriggerHandlerObj.AfterUpdateCls(Trigger.new,Trigger.oldMap,Trigger.old,Trigger.newMap);
*/
trigger PerfiosTrigger on Perfios__c (after update, before update, after insert, before insert) {

        //Handler singleton instance
        PerfiosTriggerHandler perfiosHandlerObj = PerfiosTriggerHandler.getInstance();
        
        // After Update 
        if(Trigger.isUpdate && Trigger.isAfter){
            perfiosHandlerObj.afterUpdate(Trigger.newMap,Trigger.oldMap);
            perfiosHandlerObj.updateEmiAcc(Trigger.new,Trigger.oldMap);
        }
}