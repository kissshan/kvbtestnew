public class TaskAssignmentPageController {
    public list <cls_WrapperAssign> lstWrpCls {set;get;}
    public List <User>              userList  {set;get;}
    
    public static list<String> str = new list<string>();
    public Integer count   {set;get;}
    public ID taskId;
    
    public TaskAssignmentPageController(ApexPages.StandardController stdController){
       
        List<GroupMember> lstGroupMember = [SELECT UserOrGroupId FROM GroupMember];
        Set<Id> userIds = new Set<Id>();
        
        taskId   = stdController.getId();
        userList = new List <User>();
       
        for(GroupMember userId:lstGroupMember){
            userIds.add(userId.UserOrGroupId);
        }
        
        userList  = [SELECT id,Name FROM User WHERE Id IN:userIds];
        lstWrpCls = new List<cls_WrapperAssign>();
        
        for(User userRec:userList){
            cls_WrapperAssign childAssgn = new  cls_WrapperAssign(false,userRec.Id,userRec.Name);
            lstWrpCls.add(childAssgn);
        }
    }
    public static void getListValue(list<string>lstStr){
         str.addAll(lstStr);
    	system.debug('query:::'+str);
    }
    public void reassignTask(){
        string taskOwnerId;
		string taskId;
        list<task>compTaskList = new list<task>();
        try{
            //reassignOwner obj = new reassignOwner();
             if(checkIfOnlyOneCheckBoxisSelected()){
            
            task taskCreate = new task();
            for(cls_WrapperAssign childRec:lstWrpCls){
                if(childRec.selected == true){
                   taskOwnerId = childRec.groupMember;
                    taskId = taskId;
                }
            }
                 system.debug('ownerid:::'+taskOwnerId);
                 system.debug('taskid::'+taskId);
                 system.debug('otherobjlist:::'+str);
                 if(str.size()>0){
                    compTaskList = [select id from task where id in:str];
                 }
                 system.debug('completetasklist:::'+compTaskList);
                 if(compTaskList.size()>0){
                     for(task taskObj : compTaskList){
                         system.debug('inside for loop');
                         taskCreate.Status = 'Not Started';
                         //taskCreate.Id = taskId;
                         taskCreate.OwnerId = taskOwnerId;
                     }
                 }
            TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
            update compTaskList;
        }
        }catch(Exception e){
            System.debug('############'+e.getMessage()+' AT '+e.getLineNumber() +' STACKTRACE STRING' +e.getStackTraceString());
            HandleBusinessException.captureError('TaskAssignmentPageController', 'reassign Task', e);
        }
       
    }
    
    public boolean checkIfOnlyOneCheckBoxisSelected(){
        try{
            System.debug('############');
            count =0;
            if(lstWrpCls!= null && !lstWrpCls.isEmpty()){
                for(cls_WrapperAssign childRec:lstWrpCls){
                    if(childRec.selected==true){
                        count++;
                    }
                }
            }
            if(count == 1){
                return true;
            }
            else{
                return false; 
            }
        }catch(Exception e){
            System.debug('############'+e.getMessage()+' AT '+e.getLineNumber() +' STACKTRACE STRING' +e.getStackTraceString());
            HandleBusinessException.captureError('TaskAssignmentPageController', 'checkIfOnlyOneCheckBoxisSelected', e);
            return false;
        }
    }
    
    public class cls_WrapperAssign{
        public boolean selected  {get;set;}
        public id groupMember    {get;set;}
        public string memberName {get;set;}
        
        public cls_WrapperAssign(boolean bool,id groupId,string name){
            selected    = bool;
            groupMember = groupId;
            memberName  = name;
        }
    }
}