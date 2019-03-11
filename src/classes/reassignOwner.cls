public class reassignOwner {
    public list<string>taskIdList = new list<string>();
    public list <wrappertask>       childwrapper{get;set;}
    public list <cls_WrapperAssign> lstWrpCls   {set;get;}
    public list <task> taskList {get;set;}
    public List <User> userList {set;get;}
    public Integer usercount    {set;get;}
    public Integer taskCount    {set;get;}
    public boolean s1           {get;set;}
   
    public reassignOwner(ApexPages.StandardController stdController){
        s1=true;
        string appId = stdController.getId();
        // taskList = [select id,Type,Status from task where whatid =: appId AND Status = 'Completed'];
        taskList = [select id,Type,Status from task where whatid ='a4V0l0000004vGR' AND Status = 'Completed'];
        system.debug('data::::'+taskList);
        childwrapper = new list<wrappertask>();
        for(task taskObj : taskList){
          	wrappertask obj = new wrappertask(false,taskObj.id,taskobj.type,taskObj.Status);
            childwrapper.add(obj);
        }
        system.debug('childwrapperlist:::'+childwrapper);
        List<GroupMember> lstGroupMember = [SELECT UserOrGroupId FROM GroupMember];
        Set<Id> userIds = new Set<Id>();
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
    
    public void confirmToAssign(){
        string taskOwnerId;
        string taskId;
        list<task>compTaskList = new list<task>();
        try{
           
            if(checkIfOnlyOneCheckBoxisSelected()){
                
                task taskCreate = new task();
                for(cls_WrapperAssign childRec:lstWrpCls){
                    if(childRec.selected == true){
                        taskOwnerId = childRec.groupMember;
                    }
                }
                if(taskIdList.size()>0){
                    compTaskList = [select id from task where id in:taskIdList];
                }
               
                if(compTaskList.size()>0){
                    for(task taskObj : compTaskList){
                        system.debug('inside for loop');
                        taskObj.Status = 'Not Started';
                        taskObj.OwnerId = taskOwnerId;
                    }
                    TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
                    update compTaskList;
                }
                
            }
        }catch(Exception e){
            System.debug('############'+e.getMessage()+' AT '+e.getLineNumber() +' STACKTRACE STRING' +e.getStackTraceString());
            HandleBusinessException.captureError('TaskAssignmentPageController', 'reassign Task', e);
        }
        
    }
    
    public boolean checkIfOnlyOneCheckBoxisSelected(){
        try{
            System.debug('############');
            usercount =0;
            if(lstWrpCls!= null && !lstWrpCls.isEmpty()){
                for(cls_WrapperAssign childRec:lstWrpCls){
                    if(childRec.selected==true){
                        usercount++;
                    }
                }
            }
            if(usercount == 1){
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
    
    public void ReassignOwner(){
        taskCount = 0;
        for(wrappertask childRec:childwrapper){
            if(childRec.selected == true){
                taskIdList.add(childRec.taskId);
                taskCount++;
            }
        } 
        
        s1=false;
    }
    
    public class wrappertask{
        public string taskId{get;set;}
        public boolean selected{get;set;}
        public string taskType{get;set;}
        public string taskStatus{get;set;}
        public wrappertask(boolean sel,string ids,string type,string status){
            selected = sel;
            taskId = ids;
            taskType = type;
            taskStatus = status;
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