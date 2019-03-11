trigger updateParty on genesis__Application_Parties__c (after insert, before insert, after update, before update) {
    //Added by Subas for SMS and Email
    /* if(Trigger.isUpdate && Trigger.isAfter){
for(genesis__Application_Parties__c pt : Trigger.New){
SendSMSService.sendSMSParties(pt);
}      
} */
    if(Trigger.isInsert && Trigger.isAfter && SendSMSService.Recusrive){
        for(genesis__Application_Parties__c pt : Trigger.New){
            //SendSMSService.sendSMSParties(pt);
         //   SendSMSService.sendSMSParties(JSON.serialize(pt));
            
            
            genesis__Application_Parties__c parobj=[select genesis__Application__r.Record_Type_Name__c,genesis__Application__r.genesis__CL_Product_Name__c from genesis__Application_Parties__c  where id=:pt.id];
            //  LAP_SendSMS.sendSMSParties(JSON.serialize(pt));
            //if condition added to prevent sms service on third party application creation
            system.debug('parobj.genesis__Application__r.genesis__CL_Product_Name__c'+parobj.genesis__Application__r.genesis__CL_Product_Name__c);
            if((parobj.genesis__Application__r.genesis__CL_Product_Name__c != null && !parobj.genesis__Application__r.genesis__CL_Product_Name__c.contains('Co-Lending'))){
                if(parobj.genesis__Application__r.Record_Type_Name__c == Constants.HOMELOAN){
                    SendSMSService.sendSMSParties(JSON.serialize(pt));
                }
                if(parobj.genesis__Application__r.Record_Type_Name__c== Constants.LAPLOAN){
                    LAP_SendSMS.sendSMSParties(JSON.serialize(pt));
                }
                if(parobj.genesis__Application__r.Record_Type_Name__c== Constants.VL2W || parobj.genesis__Application__r.Record_Type_Name__c==Constants.VL4W ){
                    VL_SendSMS.sendSMSPartiesVL(JSON.serialize(pt));
                }
            }
        }
    }
    
    // Before Update by Venu
      PartyTriggerHandeller parTriggerHandler = PartyTriggerHandeller.getInstance();

    if(Trigger.isUpdate && Trigger.isBefore ){
        SendSMSService.Delparties(Trigger.new,Trigger.newMap,Trigger.oldMap);
    // change for remodel    
       
        parTriggerHandler.updateApproveNMI(Trigger.new,Trigger.oldMap);
        
    }

    ///is after and update on party--remodel
    if(trigger.isUpdate && trigger.isAfter){
        if(!PartyTriggerHandeller.isPartyTrigger){
            //  parTriggerHandler.updateITRAndBankStatement(trigger.new, trigger.oldMap);
            partyUpdateTriggerHandler.appendComment(Trigger.new);
            
            // Added by Raushan
            // Purpose of Auto BRE Run and Person Cibil Score Deviation or Reject Application.And Only for SME Application.
            parTriggerHandler.checkConditionForBRE_Run_OR_Cibil_Score(trigger.new,trigger.old,trigger.newMap,trigger.oldMap);
        }
    } 
}