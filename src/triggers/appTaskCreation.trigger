/*
* Name    : appTaskCreation 
* Company : ET Marlabs
* Purpose : This class is used to assign Task to the users HL
* Author  : Subas
*/
trigger appTaskCreation on Task (after update,before update, before delete, after insert,before insert) {

    String objectType ='';
    Set<Id> appIdSet= new Set<Id>();
  
        if(Trigger.IsAfter && Trigger.IsUpdate && !TaskFlow_Helper.TASK_TRIGGER_RUNNING){
            for(Task t : Trigger.new){
                if(t.whatID<>null){
                    Id applicationId = t.whatID;
                    Id ownerId       = t.whoId;
                    objectType = String.ValueOf(applicationId.getsobjecttype());
                    if(objectType == 'genesis__Applications__c' & t.Status =='Completed'){
                        TaskFlow_Helper.createTaskApp(applicationId,t.Subject,t);
                        Retry_Task_call.recallTask(t);
                        Retry_Task_call.ValidateTask(t);
                    }
                }
            }
            
        }
    
    // code
    if( Trigger.IsBefore && (Trigger.IsUpdate || Trigger.IsInsert) && !TaskFlow_Helper.TASK_TRIGGER_RUNNING){
       for(Task t : Trigger.new){
           if(t.whatID<>null ){
               Id applicationId = t.whatID;
               objectType = String.ValueOf(applicationId.getsobjecttype());
               if(objectType == 'genesis__Applications__c')
               appIdSet.add(t.whatID);
           }
       }
       if(appIdSet.size()>=1){
           String dateVal;
           Date createdDateVal;
           String creatdate = '';
           map<Id,genesis__Applications__c> appMap= new map<Id,genesis__Applications__c>([select Id,Name,genesis__Account__r.Name,RecordType.developerName from genesis__Applications__c where Id IN: appIdSet]);
           for(Task t : Trigger.new){
               if(t.whatID<>null ){
                 //  dateVal  = t.ActivityDate.format();
                   
                  // dateVal = DateTime.newInstance(t.ActivityDate.year(),t.ActivityDate.month(),t.ActivityDate.day()).format('YYYY-MM-DD');
                //  dateVal =String.valueOf(t.ActivityDate.year())+'-'+String.valueOf(t.ActivityDate.month())+'-'+String.valueOf(t.ActivityDate.day());
                   
                   System.debug('dateVal:::'+dateVal);
                   if(t.CreatedDate!= null){ // Shubham shukla-----
                    createdDateVal = Date.valueOf(t.CreatedDate);
                    creatdate = createdDateVal.format();
                   }
                   Id appId = t.whatID;
                   Id owner = t.OwnerId;
                   User u = [Select id,UserRole.Name,UserRoleId,Designation__c,Division,Name from User where Id=:owner];
                   objectType = String.ValueOf(appId.getsobjecttype());
                   if(objectType == 'genesis__Applications__c' && appMap.containsKey(appId) && appMap.get(appId)!=null){
                       t.Company_Name__c= appMap.get(appId).genesis__Account__r.Name;
                       t.Product_Name__c= appMap.get(appId).RecordType.developerName;
                       t.Application_Name__c = appMap.get(appId).Name;
                  //     t.Due_Date__c = String.valueOf(dateVal);
                       t.Created_Date__c = String.valueOf(creatdate);
                       t.Owner_Division__c = u.Division;
                 /*      if(t.Application_Record_Type__c == 'SME_Renewal' || t.Application_Record_Type__c == 'SME_Enhancement' || t.Application_Record_Type__c == 'SME_NEW_Loan' || t.Application_Record_Type__c == 'SME_Exceeding' || t.Application_Record_Type__c == 'SME_AdHoc'){
                           t.Application_Type__c = 'SME Application';
                       }else if(t.Application_Record_Type__c == 'Home_Loan' || t.Application_Record_Type__c == 'Personal_Loan' || t.Application_Record_Type__c == 'LAP' || t.Application_Record_Type__c == 'VL2W' || t.Application_Record_Type__c == 'VL4W'){
                           t.Application_Type__c = 'Retail Application';
                       } */
                   }
               }
           }
       }

       if(Trigger.IsInsert && Trigger.IsBefore && !TaskFlow_Helper.TASK_TRIGGER_RUNNING){
        taskTriggerHelper.fillControllingPickListValue(Trigger.new);
       } 

       if(Trigger.IsUpdate && Trigger.isBefore && !TaskFlow_Helper.TASK_TRIGGER_RUNNING){
        for(Task tk : Trigger.new){
            tk.Current_Task__c  = tk.Primary_Owner_BM_Comments__c;
            tk.Primary_Owner_BM_Comments__c = '';
        }

        taskTriggerHelper.updateTask(Trigger.new,Trigger.old);
        taskTriggerHelper.referValidation(Trigger.new,Trigger.old);
        taskTriggerHelper.validateCategoryChangeForBM(Trigger.newMap,Trigger.oldMap);
       }

   }
    // upload EC validation on before update status to completed
    if(Trigger.IsBefore && Trigger.IsUpdate && !TaskFlow_Helper.TASK_TRIGGER_RUNNING){
        for(Task t : Trigger.new){
            if(t.whatID<>null){
                
                Id applicationId = t.whatID;
                
                objectType = String.ValueOf(applicationId.getsobjecttype());
                
                if(objectType == 'genesis__Applications__c' & t.Status =='Completed'){
                
                    Retry_Task_call.ValidateTask(t);
                    
                }
            }
        }
    }


    if( Trigger.IsBefore && Trigger.isDelete && !TaskFlow_Helper.TASK_TRIGGER_RUNNING ){
        for(Task t : Trigger.old){
            if( t.NonDeletable__c){
                TaskFlow_Helper.preventTaskDeletion(t);
            }
        }
    }

    if( Trigger.IsAfter && Trigger.isInsert && !TaskFlow_Helper.TASK_TRIGGER_RUNNING){
        taskTriggerHandler.parentTATInsert(Trigger.new);
    }
}