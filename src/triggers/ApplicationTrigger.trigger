trigger ApplicationTrigger on genesis__Applications__c (after update, before update, after insert, before insert) {

    if(Utility.runApplicationTrigger()){
        //Handler singleton object
        ApplicationTriggerHandler appTriggerHandlerObj = ApplicationTriggerHandler.getInstance();
        ApplicationTriggerThirdPartyHandler appTriggerThirdPartyHandler = ApplicationTriggerThirdPartyHandler.getInstance();
        // After Update 
        System.debug('Trigger.isUpdate==='+Trigger.isUpdate);
        System.debug('ApplicationTriggerHandler.IsFirstRun=='+ApplicationTriggerHandler.IsFirstRun);
        if(Trigger.isUpdate && Trigger.isAfter &&  ApplicationTriggerHandler.IsFirstRun ){
            appTriggerHandlerObj.AfterUpdateCls(Trigger.new,Trigger.oldMap,Trigger.old,Trigger.newMap);
            appTriggerThirdPartyHandler.afterUpdateThirdPartyApplication(Trigger.new);
            TL_EnhanceUpdate_Helper.ApllicationTriggerUbundling(Trigger.new);
        }
        
        // After Insert
        if(Trigger.isInsert && Trigger.isAfter  && ApplicationTriggerHandler.IsFirstRun){
            appTriggerHandlerObj.AfterInsertCls(Trigger.new);
            appTriggerThirdPartyHandler.afterInsertThirdPartyApplication(Trigger.new);                   
        }
        System.debug('$$$$$$$$');
        
        // Before Update
        if(Trigger.isUpdate && Trigger.isBefore  && ApplicationTriggerHandler.IsFirstRun){
            System.debug('$$$$$$$$');
             appTriggerHandlerObj.BeforeUpdateCls(Trigger.new,Trigger.newMap,Trigger.oldMap);
             appTriggerThirdPartyHandler.beforeUpdateThirdPartyApplication(Trigger.new,Trigger.oldMap);              
        }
        
        // Before Insert
        if(Trigger.isBefore && Trigger.isInsert && ApplicationTriggerHandler.IsFirstRun){
             appTriggerHandlerObj.BeofreInsertCls(Trigger.new);
             appTriggerThirdPartyHandler.beforeInsertThirdPartyApplication(Trigger.new);
        }

        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        System.debug('2.Number of DML rows in this apex code so far: ' + Limits.getDmlRows());
        System.debug('3.Number of DML executed so far : ' + Limits.getDmlStatements());

        //PB reatil checks
        if(Trigger.isUpdate && Trigger.isAfter && Trigger.new[0].Sub_Stage__c != Trigger.oldMap.get(Trigger.new[0].Id).Sub_Stage__c && Trigger.new[0].Sub_Stage__c == Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE){
            System.debug('ApplicationTriggerHandler.IsFirstRun >>> ' + ApplicationTriggerHandler.IsFirstRun);
            TaskFlow_Helper.createTask(Trigger.new,Trigger.old);
            TaskFlow_Helper.CloseNstpTask(Trigger.newMap,Trigger.oldMap);
            if(ProcessingFee.IsDocumentRun){
                 System.debug('inside c1');
            ProcessingFee.callPropertyDetails(Trigger.new,Trigger.oldMap);//For HL & LAP doc generation
             }
        }

        
    }
    
}