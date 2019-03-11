/*
* Name      : TaskReAssignmentCtrl
* Company   : ET Marlabs
* Purpose   : Controller class for TaskReAssignmentPage Vf page.
* Author    : Braj
*CreatedDate: 14-11-2018
*/
public class TaskReAssignmentCtrl {
    //for pre-load users and tasks
    public List<taskWrap> tskWrpLst{get;set;}//task list
    public List<Task> taskList{get;set;}
    public List<User> usrlst{get;set;}
    public List<usrWrap> usrWrpLst{get;set;}//user list
    public String loginUserId='';
    public String tabId='';
    
    //for task table
    public integer total_size; //used to show user the total size of the list
    private integer list_size=15; //sets the page size or number of rows for Tasks
    public integer counter{get;set;} //keeps track of the offset

    //for user table
    public integer total_size1; //used to show user the total size of the list
    private integer list_size1=15; //sets the page size or number of rows for Users
    public integer counter1{get;set;} //keeps track of the offset

    //for group picklist
    public String selectedGrpId{get;set;}
    public List<SelectOption> grpOption{get;set;}
    public Map<Id,User> mapUser;
    public Map<Id,List<Id>> mapUsrToGrp = new Map<Id,List<Id>>();
    public Map<Id,List<Id>> mapGrpToUsr = new Map<Id,List<Id>>();

    //for owner picklist
    public String selectedOwnerId{get;set;}
    public List<SelectOption> ownerOption{get;set;}
    public List<Task> grpTask;
    public Boolean isRender{get;set;}

    public TaskReAssignmentCtrl(){
        loginUserId = Userinfo.getUserId();
        tabId = ApexPages.currentPage().getParameters().get('sfdc.tabName');
        //System.debug('tabId>>'+tabId);
        isRender = true;
        mapUser = new Map<Id,User>([Select Id,Name,UserRoleId,UserRole.Name,ProfileId,Super_User__c from User where isActive=true]);
        //System.debug('mapUser size>>'+mapUser.size());
        if(mapUser.get(loginUserId).Super_User__c){
            loadData();
        }
    }

    public void loadData(){
        try {
            selectedGrpId=null;
            selectedOwnerId='ALL';
            
            grpOption = new List<SelectOption>();
            ownerOption = new List<SelectOption>();

            List<GroupMember> lstGroupMember = [Select Id,GroupId,UserOrGroupId FROM GroupMember];

            for(GroupMember GM: lstGroupMember){
                //map login super user to all included group
                if(GM.UserOrGroupId == loginUserId && mapUser.get(GM.UserOrGroupId).Super_User__c){
                    if(mapUsrToGrp.containsKey(GM.UserOrGroupId)){
                        mapUsrToGrp.get(GM.UserOrGroupId).add(GM.GroupId);
                    } else {
                        mapUsrToGrp.put(GM.UserOrGroupId, new List<Id>{GM.GroupId});
                    }
                }
                //map all user of one group
                if (mapGrpToUsr.containsKey(GM.GroupId)){
                    mapGrpToUsr.get(GM.GroupId).add(GM.UserOrGroupId);
                }else {
                    mapGrpToUsr.put(GM.GroupId, new List<Id>{GM.UserOrGroupId});
                }
            }
            //System.debug('mapUsrToGrp>>'+mapUsrToGrp);
            //System.debug('mapGrpToUsr>>'+mapGrpToUsr);

            List<Group> lstPublicGrp = [SELECT Id, Name, DeveloperName, Type, Email, OwnerId FROM Group where Type = 'regular'];

            Map<String,Id> sortedGroup = new Map<String,Id>();
            for(Group grp: lstPublicGrp) {
                if (!mapUsrToGrp.isEmpty() && mapUsrToGrp.get(loginUserId).contains(grp.Id)){
                    grpOption.add(new SelectOption(grp.Id,grp.Name));
                    sortedGroup.put(grp.Name, grp.Id);
                }
            }
            //System.debug('grpOption>>'+grpOption);

            if (!sortedGroup.isEmpty() && mapUsrToGrp.get(loginUserId).size()>0){
                List<String> sortedGrpLst = new List<String>(sortedGroup.keySet());
                sortedGrpLst.sort();
                selectedGrpId = sortedGroup.get(sortedGrpLst[0]);
            } else {
                isRender = false;
            }
            //System.debug(isRender);
            //calling group change method
            changeGroup();

        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }

    //change group
    public void changeGroup(){
        try {
            //System.debug('Inside changeGroup');
            //user related fucntionality
            usrlst = new List<User>(getGrpUser(selectedGrpId));
            total_size1 = usrlst.size();
            counter1 = 1;
            usrWrpLst = new List<usrWrap>();
            getPage1(counter1);//call pagination method

            //task related functionality
            taskList = new List<Task>(getGrpTask(usrlst));
            total_size = taskList.size();
            counter = 1;
            tskWrpLst = new List<taskWrap>();
            getPage(counter);//call pagination method

            //refresh Owner Picklist
            ownerOption.clear();
            set<String> ownerSet = new set<String>();
            ownerOption.add(new SelectOption('ALL','All'));
            for(Task tk: taskList){
                if (!ownerSet.contains(tk.OwnerId)){
                    ownerSet.add(tk.OwnerId);
                    //System.debug('tk.OwnerId>>'+tk.OwnerId);
                    //System.debug('tk.Owner.Name>>'+tk.Owner.Name);
                    ownerOption.add(new SelectOption(tk.OwnerId,tk.Owner.Name));
                }
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        
    }

    //get selected group of users 
    public List<User> getGrpUser(Id GrpId){
        //System.debug('GrpId>>'+GrpId);
        List<User> grpUsers = new List<User>();
        if (!mapGrpToUsr.isEmpty() && GrpId!=null){
            for(Id uId: mapGrpToUsr.get(GrpId)){
                grpUsers.add(mapUser.get(uId));
            }
        }
        //System.debug('grpUsers size'+ grpUsers.size());
        return grpUsers;
    }

    //get selected group of Tasks
    public List<Task> getGrpTask(List<User> usrlist){
        try {
           grpTask = new List<Task>();
           List<Task> lstTask = new List<Task>();
           set<Id> appIdSet = new set<Id>();
            if (usrlist.size()>0){
                lstTask = [Select Id,Subject,OwnerId,Owner.Name,Owner.UserRoleId,WhatId,What.Name,CreatedDate,ActivityDate,Status from Task where OwnerId IN:usrlist And Status!='Completed' And OwnerId!=null And WhatId!=null Order by ActivityDate Desc ];
            }
            //System.debug('lstTask size'+ lstTask.size());
            for(Task tsk: lstTask) {
                appIdSet.add(tsk.WhatId);
            }
            List<String> recTypes = new List<String>{Constants.HOMELOAN,Constants.LAPLOAN,Constants.PERSONALLOAN,Constants.VL2W,Constants.VL4W};
            Map<Id,genesis__Applications__c> mapApp = new Map<Id,genesis__Applications__c>([Select Id,Name,Record_Type_Name__c from genesis__Applications__c where Id IN:appIdSet and Record_Type_Name__c IN:recTypes]);
            for(Task tsk: lstTask) {
                if(mapApp.containsKey(tsk.WhatId)){
                    grpTask.add(tsk);
                }
            }
            //System.debug('grpTask size'+ grpTask.size());
            return grpTask; 
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        
    }

    public void filterTaskByOwner(){
        try {
            //System.debug('Inside filterTaskByOwner()');
            taskList.clear();
            if(selectedOwnerId!='ALL'){
                for(Task eachTsk: grpTask){
                    if (eachTsk.OwnerId == selectedOwnerId) {
                        taskList.add(eachTsk);
                    }
                }
            } else {
                taskList = grpTask;
            }

            total_size = taskList.size();
            counter = 1;
            tskWrpLst = new List<taskWrap>();
            getPage(counter);//call pagination method
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        
    }



    //do pagination
    public void getPage(integer cnt){
        //System.debug('Inside getPage');
        //System.debug(list_size+'##'+cnt);
        tskWrpLst.clear();
        for(integer i=(cnt-1)*list_size;i<cnt*list_size;i++){
            if(taskList.size()-1>=i){
                tskWrpLst.add(new taskWrap(taskList.get(i),false));
            }
        }
    }

    //get next set of record
    public pageReference nextPage(){
        //System.debug('Inside nextPage');
        //System.debug(list_size+'-<--list_size||-counter-->'+counter);
        if(taskList.size()>counter*list_size){
            counter++;
            getPage(counter);
        }
        return null;
    }
    
    //get previous set of record
    public pageReference prevPage(){
        //System.debug('Inside prevPage');
        //System.debug('counter==>'+counter);
        if (counter>1){
            counter--;
            getPage(counter);
        }
        return null;
    }
    
    //this will disable the previous buttons
    public Boolean getDisablePrevious(){
        //System.debug('Inside getDisablePrevious');
        //System.debug('counter-->'+counter);
        if (counter-1>0) 
            return false; 
        else 
            return true;
    }
    
    //this will disable the next buttons
    public Boolean getDisableNext(){
        //System.debug('Inside getDisableNext'); 
        //System.debug(counter+'####'+list_size+'*****'+total_size);
        if (counter*list_size < total_size) 
            return false; 
        else 
            return true;
    }

    //do pagination
    public void getPage1(integer cnt){
        //System.debug('Inside getPage1');
        //System.debug(list_size1+'##'+cnt);
        usrWrpLst.clear();
        for(integer i=(cnt-1)*list_size1;i<cnt*list_size1;i++){
            if(usrlst.size()-1>=i){
                usrWrpLst.add(new usrWrap(usrlst.get(i),false));
            }
        }
        //System.debug(usrWrpLst.size()+'<<usrWrpLst>>'+usrWrpLst);
    }

    //get next set of record
    public pageReference nextPage1(){
        //System.debug('Inside nextPage1');
        //System.debug(list_size1+'-<--list_size1||-counter1-->'+counter1);
        if(usrlst.size()>counter1*list_size1){
            counter1++;
            getPage1(counter1);
        }
        return null;
    }
    
    //get previous set of record
    public pageReference prevPage1(){
        //System.debug('Inside prevPage1');
        //System.debug('counter1==>'+counter1);
        if (counter1>1){
            counter1--;
            getPage1(counter1);
        }
        return null;
    }
    
    //this will disable the previous buttons
    public Boolean getDisablePrevious1(){
        //System.debug('Inside getDisablePrevious1');
        //System.debug('counter1-->'+counter1);
        if (counter1-1>0)
            return false; 
        else 
            return true;
    }
    
    //this will disable the next buttons
    public Boolean getDisableNext1(){
        //System.debug('Inside getDisableNext1'); 
        //System.debug(counter1+'####'+list_size1+'*****'+total_size1);
        if (counter1*list_size1 < total_size1) 
            return false;
        else 
            return true;
    }

    Public PageReference reAssign(){
        try {
            Boolean taskSelected = false;
            Boolean userSelected = false;
            Id usrId = null;

            if (isTaskSelected()) {
                taskSelected = true;
            }
            if (isUserSelected()) {
                userSelected = true;
            }

            if (taskSelected && userSelected) {
                for(usrWrap eachUsrWp:usrWrpLst){
                    if(eachUsrWp.isSelect==true){
                        usrId = eachUsrWp.usr.Id;
                    }
                }

                List<Task> taskToUpdate= new List<Task>();
                set<Id> taskIdSet = new set<Id>();
                for(taskWrap eachUsrWp:tskWrpLst){
                    if(eachUsrWp.isSelect==true){
                        taskToUpdate.add(new Task(Id=eachUsrWp.tsk.Id,OwnerId=usrId,Parent_Owner_Id__c=usrId));
                        taskIdSet.add(eachUsrWp.tsk.Id);
                    }
                }
                Id parentRecordId = Schema.SObjectType.Task_TAT__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
                List<Task_TAT__c> taskTATtoUpdate = new List<Task_TAT__c>();
                for(Task_TAT__c tat:[SELECT Id,Name,Application__c,OwnerId,Task_Subject__c,Primary_Owner__c,RecordTypeId,Parent_Record__c,Task_Id__c FROM Task_TAT__c WHERE Task_Id__c IN:taskIdSet Order By CreatedDate Asc]){
                    if (tat.RecordTypeId==parentRecordId && tat.Parent_Record__c) {
                        taskTATtoUpdate.add(new Task_TAT__c(Id=tat.Id,OwnerId=usrId,Primary_Owner__c=usrId,Current_User__c=usrId));
                    } else if(!tat.Parent_Record__c && tat.Task_Id__c!=null){
                        taskTATtoUpdate.add(new Task_TAT__c(Id=tat.Id,OwnerId=usrId,Primary_Owner__c=usrId,Current_User__c=usrId));
                    }
                }
                //System.debug('taskToUpdate size >>'+taskToUpdate.size());
                //System.debug('taskTATtoUpdate size >>'+taskTATtoUpdate.size());

                if (!taskToUpdate.isEmpty() && taskToUpdate.size()>0){
                    Update taskToUpdate;
                    update taskTATtoUpdate;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Task successfully assign to selected user.'));
                    PageReference pageRef;
                    if (tabId != '' && tabId != null) {
                        pageRef = new PageReference('/apex/TaskReAssignmentPage?sfdc.tabName='+tabId);
                    } else {
                        pageRef = new PageReference('/apex/TaskReAssignmentPage');
                    }
                    pageRef.setRedirect(true);
                    return pageRef;
                }
            } else if (!taskSelected) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'Please select atleast one task!'));
            } else if (!userSelected) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'Please select one user!'));
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Something went wrong!!'));
            }
            return null;
        } catch(Exception e) {
            //System.debug('reAssign()-Line No '+e.getLineNumber()+ 'Error Message ' +e.getMessage()+' StackTrace ' +e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            HandleBusinessException.captureError('TaskReAssignmentCtrl', 'reAssign', e);
            return null;
        }
    }

    public boolean isTaskSelected(){
        try{
            //System.debug('isTaskSelected');
            Integer count=0;
            if(tskWrpLst!= null && !tskWrpLst.isEmpty()){
                for(taskWrap eachUsrWp:tskWrpLst){
                    if(eachUsrWp.isSelect==true){
                        count++;
                    }
                }
            }
            if(count>0){
                return true;
            }
            else{
                return false; 
            }
        }catch(Exception e){
            HandleBusinessException.captureError('TaskReAssignmentCtrl', 'isTaskSelected', e);
            return false;
        }
    }

    public boolean isUserSelected(){
        try{
            //System.debug('isUserSelected');
            Integer count=0;
            if(usrWrpLst!= null && !usrWrpLst.isEmpty()){
                for(usrWrap eachUsrWp:usrWrpLst){
                    if(eachUsrWp.isSelect==true){
                        count++;
                    }
                }
            }
            if(count==1){
                return true;
            }
            else{
                return false; 
            }
        }catch(Exception e){
            HandleBusinessException.captureError('TaskReAssignmentCtrl', 'isUserSelected', e);
            return false;
        }
    }

    public class taskWrap{
        public Task tsk{get;set;}
        public Boolean isSelect{get;set;}
        public taskWrap(Task tsk,Boolean isSelect){
            this.tsk = tsk;
            this.isSelect = isSelect;
        }
    }

    public class usrWrap{
        public User usr{get;set;}
        public Boolean isSelect{get;set;}
        public usrWrap(User usr,Boolean isSelect){
            this.usr = usr;
            this.isSelect = isSelect;
        }
    }
}