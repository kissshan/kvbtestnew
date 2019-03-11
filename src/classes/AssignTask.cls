public class AssignTask {
    public static String userAssign(List<User> usrList){                
        String userId='';
        List <ID> IdList = new List <ID>();
        for(User u : usrList){
            IdList.add(u.Id);
        }
        Map<ID,Integer> mapTsk = new Map<ID,Integer>();
        List<Task> tskList = [Select Id,OwnerId,Subject,Status From Task where OwnerId IN:IdList AND Status != 'Completed'];
        for(Task t : tskList){
            if(mapTsk.keySet().contains(t.OwnerId)){
                mapTsk.put(t.OwnerId,mapTsk.get(t.OwnerId)+1);
            }
            else{
                mapTsk.put(t.OwnerId,1);
            }
        }
        for(Id uId : IdList){
            if(!mapTsk.containsKey(uId )){
                mapTsk.put(uId , 0);
            }
        }
        //     for(Id tskOwnerId : mapTsk.keySet()){
        System.debug('---'+mapTsk);
//}        
        String maxSize = null;
        for(String key:mapTsk.keyset()){
            if(maxSize==null||mapTsk.get(key)<mapTsk.get(maxSize))
                maxSize=key;
        }
        system.debug('###'+maxSize);        
        return maxSize;
    }
    //Dynamic task creation depending upon users tasks assigned
    public static void taskAssignment(List<genesis__Applications__c> changedAppList){
        List<String> stageList = new List<String>();
        List<String> divisonList = new List<String>();
        List<Task> userSpecificTask = new List<Task>();
        Map<Id,User> usermap = new Map<Id,User>();
        List<Application_Stage_by_Task_Matrix__mdt> taskMatrixList = new List<Application_Stage_by_Task_Matrix__mdt>();
        Map<ID,Integer> userTaskCountmap = new Map<ID,Integer>();
        map<String,Application_Stage_by_Task_Matrix__mdt> stageTaskDetailsMap = new map<String,Application_Stage_by_Task_Matrix__mdt>();
        
        if(!changedAppList.isEmpty()){
            for(genesis__Applications__c app : changedAppList){
                stageList.add(app.Application_Stage__c);
            }    
        }
        if(!stageList.isEmpty()){
            taskMatrixList = [SELECT Id,Application_Stage__c,Task_Subject__c,TAT_in_days__c,Role__c FROM Application_Stage_by_Task_Matrix__mdt WHERE Application_Stage__c IN : stageList];    
        }
        //System.debug(taskMatrixList.size());
        if(!taskMatrixList.isEmpty()){
            for(Application_Stage_by_Task_Matrix__mdt mdt : taskMatrixList){
                divisonList.add(mdt.Role__c);
                stageTaskDetailsMap.put(mdt.Application_Stage__c,mdt);
            }
            //System.debug(divisonList.size()+'---'+divisonList);
            usermap = New Map<Id,user>([SELECT Id FROM User WHERE Division IN : divisonList]);
            //System.debug(usermap.size());
            userSpecificTask = [SELECT Id,OwnerId FROM task WHERE OwnerId IN : usermap.keySet()];
             //System.debug(userSpecificTask.size());
            for(Task tsk : userSpecificTask){
                if(userTaskCountmap.keySet().contains(tsk.OwnerId)){
                    userTaskCountmap.put(tsk.OwnerId,userTaskCountmap.get(tsk.OwnerId)+1);
                }
                else{
                    userTaskCountmap.put(tsk.OwnerId,1);
                }
            }
            //System.debug(userTaskCountmap);
            Id minUsertaskCountId;
            
            for(genesis__Applications__c app : changedAppList){
                if(!userTaskCountmap.isEmpty()){
                    minUsertaskCountId = getMinCount(userTaskCountmap);
                    if(minUsertaskCountId != null){
                        System.debug('Created Task###');
                        //System.debug(Utility.createTask(app.id, minUsertaskCountId , stageTaskDetailsMap.get(app.Application_Stage__c).Task_Subject__c,stageTaskDetailsMap.get(app.Application_Stage__c).TAT_in_days__c).Id);
                        userTaskCountmap.put(minUsertaskCountId,userTaskCountmap.get(minUsertaskCountId)+1);
                    }
                }
            }
        }
        //System.debug(userTaskCountmap);
    }
    
    public static Id getMinCount(Map<Id,integer> userTaskCountmap){
        Id minCountUserId;
        integer count = 0;
        for(Id userId : userTaskCountmap.keySet()){
            if(count == 0){
                count = userTaskCountmap.get(userId);
                minCountUserId = userId;
            }
            else if(count > userTaskCountmap.get(userId)){
                count = userTaskCountmap.get(userId);
                minCountUserId = userId;
            }
        }
        System.debug(userTaskCountmap);
        RETURN minCountUserId;
    }
    
}