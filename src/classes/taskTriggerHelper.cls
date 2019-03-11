/*#################################################################################################################################
* Name      : taskTriggerHelper
* Company   : ET Marlabs
* Purpose   : Helper class for taskTrigger 
* Author    : Shubham Shukla 
 ##################################################################################################################################*/
public class taskTriggerHelper {
public static void updateTask(List<Task> newtaskList, List<Task> oldtasklist){
    try{
        String objectType ='';
        for(Task ot : oldtasklist){
            for(Task tt : newtaskList){
                if(tt.whatID<>null){
                    Id applicationId = tt.whatID;
                    Id ownerId       = tt.OwnerId;
                    Id oldownerId    = ot.OwnerId;
                    objectType = String.ValueOf(applicationId.getsobjecttype());
                    if(objectType == 'genesis__Applications__c'){
                        if(tt.Status == 'Completed' || tt.Status == 'Referred back' || tt.Status == 'Assign to primary owner')
                          taskTriggerHandler.calculateTAT(applicationId,ownerId,oldownerId,tt.Subject,tt);
                    }
                }
            }
        }
    }catch(Exception e){
            System.debug('e'+e);
             HandleBusinessException.captureError('taskTriggerHelper', 'updateTask', e);
    }
}
        public static void fillControllingPickListValue(List<Task> taskRecordList){

            // Code for insertion of Is_ref_BackEnabled/Task controlling picklist val
            List<Refer_back__mdt> referMdt = new list<Refer_back__mdt>();
            referMdt = [SELECT id,Task_Subject__c,Is_Refer_back_Allow__c,controllingPickValue__c FROM Refer_back__mdt WHERE Is_Refer_back_Allow__c = true];
            Map<String,Refer_back__mdt> mdtMap = new Map<String,Refer_back__mdt>();

            if(referMdt.size() > 0){
                for(Refer_back__mdt refferBackRecord:referMdt){
                    mdtMap.put(refferBackRecord.Task_Subject__c,refferBackRecord);
                } 
            }  

            if(taskRecordList.size() > 0){
                for(Task taskRec:taskRecordList){
                    if(mdtMap.containsKey(taskRec.Subject)){
                        taskRec.is_refer_back_allow__c = mdtMap.get(taskRec.Subject).Is_Refer_back_Allow__c;
                        taskRec.Category_Controller_Value__c = mdtMap.get(taskRec.Subject).controllingPickValue__c;
                    }
                }
            }
            
        }
 //refer back validation
        public static void referValidation(List<Task> newKsatList, List<Task> oldKsatlist){
            try{

                Set<String> tskSub  = new Set<String>();
                List<Refer_back__mdt> referBackMdt = new list<Refer_back__mdt>();
                referBackMdt = [SELECT id,Task_Subject__c,Is_Refer_back_Allow__c,controllingPickValue__c FROM Refer_back__mdt WHERE Is_Refer_back_Allow__c = true];

                for(Refer_back__mdt mdt : referBackMdt){
                    tskSub.add(mdt.Task_Subject__c);
                }
                for(Task tRec : newKsatList){
                   
                    if((tRec.Product_Name__c == Constants.LAPLOAN || tRec.Product_Name__c == Constants.HOMELOAN || tRec.Product_Name__c == Constants.PL || tRec.Product_Name__c == Constants.VL2W || tRec.Product_Name__c == Constants.VL4W)){
                        if(tRec.is_refer_back_allow__c == false && (tRec.Status == 'Referred back' || tRec.Status == 'Assign to primary owner') && !tskSub.contains(tRec.Task_Subject__c)){
                            tRec.addError('Sorry, You are not allowed to perform this action !');
                        }
                    }
                }
     
            }catch(Exception e){
                System.debug('e'+e);
                 HandleBusinessException.captureError('taskTriggerHelper', 'referValidation', e);
            }
        }
        public static void validateCategoryChangeForBM(Map<Id,Task> newmap, Map<Id,Task> oldMap){
            Id currentUserId;
            Id loggeninUser = UserInfo.getUserId();
            Set<String> tskSubSet  = new Set<String>();
            User us = [SELECT Id, Name, UserRoleId, UserRole.Name FROM User WHERE Id=:loggeninUser];
            List<Refer_back__mdt> referBackMdts = new list<Refer_back__mdt>();
            referBackMdts = [SELECT id,Task_Subject__c,Is_Refer_back_Allow__c,controllingPickValue__c FROM Refer_back__mdt WHERE Is_Refer_back_Allow__c = true];

            for(Refer_back__mdt mdts : referBackMdts){
                tskSubSet.add(mdts.Task_Subject__c);
            }
            for(Task taskRec:newmap.values()){
                if((taskRec.Product_Name__c == Constants.LAPLOAN || taskRec.Product_Name__c == Constants.HOMELOAN || taskRec.Product_Name__c == Constants.PL || taskRec.Product_Name__c == Constants.VL2W || taskRec.Product_Name__c == Constants.VL4W) && taskRec.is_refer_back_allow__c == true){
                    currentUserId=oldMap.get(taskRec.Id).OwnerId;
                    if(us.UserRole.Name == 'Branch manager'){
                        if(currentUserId != taskRec.Parent_Owner_Id__c){
                            System.debug('AAAAAQQA'+currentUserId + ':::'+taskRec.Parent_Owner_Id__c);
                            if(oldmap.get(taskRec.Id).OwnerId != taskRec.OwnerId){
                                if((taskRec.Status == 'Completed' || taskRec.Status == 'Not Started' || taskRec.Status == 'Referred back' || taskRec.Status == 'In Progress') && tskSubSet.contains(taskRec.Task_Subject__c)){
                                    System.debug('@&@&@&@&^^^^'+currentUserId);
                                    System.debug('AAAAAAAAAAA'+oldmap.get(taskRec.Id).Status);
                                    System.debug('BBBBBBBBBBBB'+taskRec.Status);
                                    taskRec.addError('You can choose only Assign back to primary owner status');
                                }
                            }
                             
                        }else if(currentUserId == taskRec.Parent_Owner_Id__c){
                            if(oldmap.get(taskRec.Id).OwnerId != taskRec.OwnerId){
                                if(taskRec.Status == 'Assign to primary owner' && tskSubSet.contains(taskRec.Task_Subject__c)){
                                    taskRec.addError('You can not choose Assign back to primary owner status');
                                }
                            }
                        }
                    }
                }
            }  

        }
    
}