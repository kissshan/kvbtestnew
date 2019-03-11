/*
* Name          : TaskNotificationBatch
* Description   : Send notification to all task owner if due date passed
* Author        : Dushyant
*/
global class TaskNotificationBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = 'SELECT Id,ActivityDate,WhatId,OwnerId,Owner.Email,Manager_email__c,Manager_name__c,Subject,Owner_name__c,Status FROM Task WHERE ActivityDate > TODAY';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Task> taskList){
        //System.debug('taskList::'+taskList);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
        String body;
        String taskSubject = 'Task escalation!';
        String imageLogo = SME_Email_Handler.getDocumentLogoUrl();
        System.debug('imageLogo'+imageLogo);
        Map<String,String> emailMap = new Map<String,String>(); //key->Manager Email ,value->Email Body
        
        for(Task tsk : taskList){
            if(tsk.Manager_email__c != null){
                body = 'Dear '+tsk.Manager_name__c+',<br><br>As of this email, Task :'+tsk.Subject+' assigned to '+tsk.Owner_name__c+' is now overdue since '+Date.valueOf(tsk.ActivityDate).format()+' with the status: '+tsk.Status+'. Please look into the same and ensure completion of the task as soon as possible. <br><br>Thanks.<br><br><img src="'+imageLogo+'"/>';
                emailMap.put(tsk.Manager_email__c,body);
            }
        }
        
        if(emailMap.size() > 0){
            for(Task tsk : taskList){
                if(tsk.Manager_email__c != null){
                    if(emailMap.containsKey(tsk.Manager_email__c)){
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.toAddresses = new List<String>{tsk.Manager_email__c};
                            message.setSubject(taskSubject);
                        message.setReplyTo('support@kvb.com');
                        message.setSenderDisplayName('KVB TEAM');
                        message.setBccSender(false);
                        message.setHtmlBody(emailMap.get(tsk.Manager_email__c));
                        messages.add(message);
                        
                    } 
                } 
            }
        }
        
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if(results.size() > 0 ){
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){}
    
    //This method is used for the to get userid,which user have less number of tasks.
    public static String getUserId(String appId){
        Id userId;
        try{
            Integer taskCount = 0;
            User appOwner = new User();
            Map<Id,user> userMap = new Map<Id,User>();
            List<Task>  taskList = new List<Task>();
            Map<Id,Integer>  userTaskCountMap  =  new Map<Id,Integer>();
            genesis__Applications__c app = new genesis__Applications__c();
            
            app = [select id,owner.name,OwnerId,name from genesis__Applications__c where Id =:appId ];
            appOwner = [select id,Division,Designation__c from User where Id =: app.OwnerId];
            userMap = new Map<Id,User>([select id,Division,Designation__c from User where Designation__c='DO Credit Officer' and Division =: appOwner.Division]);
            taskList = [select id,OwnerId,WhoId from task where OwnerId IN : userMap.keySet()];
            System.debug(userMap.keySet().size());
            System.debug(taskList.size());
            for(Task tsk : taskList){
                if(userTaskCountMap.containsKey(tsk.OwnerId)){
                    Integer temp = userTaskCountMap.get(tsk.OwnerId);
                    temp++;
                    userTaskCountMap.put(tsk.OwnerId,temp);
                }else{
                    userTaskCountMap.put(tsk.OwnerId,1);
                }
            }
            System.debug(userTaskCountMap);
            
            for(Id ur :userTaskCountMap.keySet()){
                if(taskCount == 0){
                    taskCount = taskCount = userTaskCountMap.get(ur);
                    userId = ur;
                    continue;
                }
                if(userTaskCountMap.get(ur) < taskCount){
                    taskCount = userTaskCountMap.get(ur);
                    userId = ur;
                } 
            }
        }
        catch(Exception e){
            System.debug('Error Message---> ' + e.getMessage()+'---> '+e.getCause()+'Line no---> '+e.getLineNumber()+'StackTrace---> '+e.getStackTraceString());
        }
        System.debug(userId);
        return userId;
    }
}