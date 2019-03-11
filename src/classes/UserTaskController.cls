/*
* @name : UserTaskController
* @purpose : Controller class for UserTaskListPage
* @author : 
* @LastModifiedBy : Souvik Banik, on 15.10.2018 
* 
*/

public class UserTaskController {

    public static List<Task> taskList{get;set;}
    public static List<taskWrap> newTaskList{get;set;} // This List we are sending to the page which are of 'taskWrap' type.
    public static String taskId{get;set;}             // Based on this variable we are changing the status of Task as 'Completed'. This variable holds the selected Task Id.

    public UserTaskController(){
        UserTaskControllerHelper();
    }
    
    // Method To Fetch All The Assigned Task For The Logged in User.
    public void UserTaskControllerHelper(){
        try{
            Set<String> idList  = new Set<String>();
            newTaskList 		= new List<taskWrap>();
            Map<String,String> appNameByAppId = new Map<String,String>();
            taskId 				= '';
            taskList = new List<Task>();
            taskList = [SELECT Id,Status,Subject,WhatId,OwnerID,Company_Name__c,Product_Name__c,ActivityDate FROM Task WHERE OwnerID =: UserInfo.getUserId() ORDER BY CreatedDate DESC];
            for(task taskObj : taskList){
                idList.add(taskObj.WhatId);
            }
            List<genesis__Applications__c> appList = [SELECT Id,Name FROM genesis__Applications__c WHERE Id IN : idList];
            for(genesis__Applications__c appObj : appList){
                appNameByAppId.put(appObj.Id,appObj.Name);
            }
            for(task taskObj : taskList){
                newTaskList.add(new taskWrap(taskObj,appNameByAppId.get(taskObj.WhatId)));
            }
        }catch(Exception e){
            HandleBusinessException.captureError('UserTaskController', 'UserTaskControllerHelper', e);
        }
    }

    // Method To Complete The Selected Task
    public void completeSelectedTask(){
        try{
            if(taskId != null && taskId != ''){
                Task task = new Task(Id=taskId,Status = 'Completed');
                UPDATE task;
            }
            UserTaskControllerHelper();
        }catch(Exception e){
            HandleBusinessException.captureError('UserTaskController', 'completeSelectedTask', e);
        }
    }

    // Final Wrapper Class that we are sending to the page
    public class taskWrap{
        public Task taskRec{get;set;}
        public String appName{get;set;}
        public taskWrap(Task taskRec,String appName){
            this.taskRec = taskRec;
            this.appName = appName;
        }

    }

}