/*
 * Name     : AccountTrigger
 * Company  : ET Marlabs
 * Purpose  : Trigger for update Account. 
 * Author   : Raushan
 * Additional Comment : Please use AccountTriggerHandler.isAccountTrigger variable for recursion Handler. 
*/
trigger AccountTrigger on Account (before insert,before update, after insert, after update) {

    if(Utility.runAccountTrigger()){
    
        AccountTriggerHandler accTriggerHandler = AccountTriggerHandler.getInstance();
        if(trigger.isUpdate && trigger.isBefore){
            if(!AccountTriggerHandler.isAccountTrigger)
                accTriggerHandler.beforeUpdate(Trigger.newMap, Trigger.oldMap, Trigger.new);
        }
        if(trigger.isUpdate && trigger.isAfter){
            if(!AccountTriggerHandler.isAccountTrigger){
                accTriggerHandler.updateITRAndBankStatement(trigger.new, trigger.oldMap);
            }
        }        
    }
}