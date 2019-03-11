/*
* Name    : Batch_TaskEscilationMatrix 
* Company : ET Marlabs
* Purpose : This batch is used to send escalation mails for open tasks more than 7 days, 14 days and 21 days to appropriate users
* Author  : Shubham Shukla
*/
global class Batch_TaskEscilationMatrix implements Database.Batchable<sObject>, Database.Stateful {
   
    public Blob csvBlob1;
    public Blob csvBlob2;
    public Blob csvBlob3;
    public Blob csvBlob4;
    public Blob csvBlob5;
    public Blob csvBlob6;
    public Blob csvBlob7;
    public Blob csvBlob8;
    public String finalBlob1 = '';
    public String finalBlob2 = '';
    public String finalBlob3 = '';
    public String finalBlob4 = '';
    public String finalBlob5 = '';
    public String finalBlob6 = '';
    public String finalBlob7 = '';
    public String csvStringByutil1 ='';
    public String csvStringByutil2 ='';
    public String csvStringByutil3 ='';
    public String csvStringByutil4 ='';
    public String csvStringByutil5 ='';
    public String csvStringByutil6 ='';
    public String csvStringByutil7 ='';
    public List<User> SecondAuthorityuser = new List<User>();
    public List<String> SecondAuthorityuserEmail = new List<String>();
    public List<User> presidentUser = new List<User>();
    public List<String> presidentEmail = new List<String>();
    public List<String> firstAuthUser1 = new List<String>();
    public List<String> firstAuthUser2 = new List<String>();
    public List<String> firstAuthUser3 = new List<String>();
    public List<String> firstAuthUser4 = new List<String>();
    public List<String> firstAuthUser5 = new List<String>();
    public List<Task> bmTasks = new List<Task>();
    public List<Task> lclTasks = new List<Task>();
    public List<Task> rlpcTasks = new List<Task>(); 
    public List<Task> rmdTasks = new List<Task>();
    public List<Task> rpcTasks = new List<Task>();
    public List<Task> allTaskRec = new List<Task>();
    public Map<String,List<Task>> taskForCSVbyDM = new Map<String,List<Task>>();

    public Map<String,User> userMap = new  Map<String,User>();
    public List<User> usrList = new List<User>();
    public List<Task_Escalation_Matrix__mdt> tskEscRoleList = new List<Task_Escalation_Matrix__mdt>();
    public User userRec = new User();
    public List<String> queryFields = new List<String>{'Owner_Division__c','Owner_Branch__c','Application_Type__c','Application_Record_Type__c','Application_Name__c','Subject','Owner_name__c','Due_Date__c','Pending_Days__c'};
    
    public Batch_TaskEscilationMatrix(){
       
        tskEscRoleList = [SELECT Id, Task_Owner_Role__c, Role_Name__c, Min_Days_Range__c, Max_Days_Range__c FROM Task_Escalation_Matrix__mdt];
        usrList = [Select id,UserRole.Name,UserRoleId,Designation__c,Division,Name from User];
        for(user u : usrList){
            userMap.put(u.Id, u);
        }
       
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        String query = 'SELECT Id, OwnerId, Test_check__c, Owner_name__c, Application_Name__c,Subject, WhatId, ActivityDate,Createddate, Pending_Days__c, Due_Date__c,Created_Date__c,Owner_Division__c,Owner.UserRole.Name,Status,Owner_Branch__c, Product_Name__c, Application_Type__c, Application_Record_Type__c FROM Task Where Status !=\'Completed\' AND ActivityDate != null AND Subject != null AND Due_Date__c != null';
    
        return Database.getquerylocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Task> scope){

        Date startDate;
        Date dueDate; 
        Integer daysBetween; 
        String roleName;
        String csvFileString1;
        String csvFileString2;
        Integer count = 0;
        Boolean flag = true;
        Boolean flag1 = true;
        Boolean flag2 = true;
        Boolean flag3 = true;
        Boolean flag4 = true;
        Boolean flag5 = true;
        Boolean flag6 = true;
        Boolean flag7 = true;
        Boolean flag8 = true;
        
        for(Task tsk : scope){
            allTaskRec.add(tsk);
        }
        
        Set<Id> roleIdSet = new Set<Id>();
        List<User> dmList = new List<User>();
            
        for(Task t : scope){
            
            if(userMap.containsKey(t.OwnerId)){
                userRec = userMap.get(t.OwnerId);
            }
           
            roleName = userRec.UserRole.Name;
          	System.debug('roleName==>'+roleName);
            if(roleName == 'Branch manager'){
                bmTasks.add(t);   
            }
            if(roleName == 'RPC Outsource Officer'){
                lclTasks.add(t);
            }
            
            if(roleName == 'RLPC Head'){
                rlpcTasks.add(t);
            }
            
            if(roleName == 'Legal Clearance Officer'){
                rmdTasks.add(t);
            }
            
            if(roleName == 'RMD officer'){
                rpcTasks.add(t);
            }
        }
        
            SecondAuthorityuser = getUserUtility.getSecondLevelAuthorityUser(scope);
            System.debug('******************'+SecondAuthorityuser);
            for(User uRec : SecondAuthorityuser){
                if(!SecondAuthorityuserEmail.contains(uRec.Email)){
                    SecondAuthorityuserEmail.add(uRec.Email);
                }  
            }
            presidentUser = getUserUtility.getPresidentUser(scope);
        
            for(User preUsr : presidentUser){
                if(!presidentEmail.contains(preUsr.Email)){
                    presidentEmail.add(preUsr.Email); 
                }
            }
    }  
    global void finish(Database.BatchableContext BC){
               
        taskForCSVbyDM = getUserUtility.getUserbyDivision(bmTasks);
        System.debug('taskForCSVbyDM::::BM Tasks-->'+taskForCSVbyDM);
        
        for(String usr : taskForCSVbyDM.keySet()){

            if(!firstAuthUser1.contains(usr)){
                firstAuthUser1.add(usr);
            }
            if(csvStringByutil1 != ''){
                csvStringByutil1 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
            }else{
                csvStringByutil1 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
            }

            System.debug('csvStringByutil1 =>'+csvStringByutil1);
			finalBlob1 = finalBlob1 + csvStringByutil1;
            csvBlob1 = Blob.valueOf(finalBlob1);
            System.debug('#####:::shubham'+csvBlob1);
        }
        if(firstAuthUser1.size() > 0){
            getUserUtility.sendEmail(csvBlob1,firstAuthUser1);
        }
               
        taskForCSVbyDM = getUserUtility.getUserbyDivision(lclTasks);
		
       for(String usr : taskForCSVbyDM.keySet()){
            if(!firstAuthUser2.contains(usr)){
               firstAuthUser2.add(usr); 
            }
           if(csvStringByutil2 != ''){
               csvStringByutil2 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
           }else{
               csvStringByutil2 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
           }
           	System.debug('csvStringByutil2 =>'+csvStringByutil2);
			finalBlob2 = finalBlob2 + csvStringByutil2;
            csvBlob2 = Blob.valueOf(finalBlob2);
        } 
        if(firstAuthUser2.size() > 0){
            getUserUtility.sendEmail(csvBlob2,firstAuthUser2);
        }
        
         taskForCSVbyDM = getUserUtility.getUserbyDivision(rlpcTasks);
		
         for(String usr : taskForCSVbyDM.keySet()){
             if(!firstAuthUser3.contains(usr)){
                 firstAuthUser3.add(usr);
             }
             if(csvStringByutil3 != ''){
                 csvStringByutil3 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
             }else{
                 csvStringByutil3 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
             }
             System.debug('csvStringByutil3 =>'+csvStringByutil3);
			 finalBlob3 = finalBlob3 + csvStringByutil3;			
             csvBlob3 = Blob.valueOf(finalBlob3);
           
        }
        if(firstAuthUser3.size() > 0){
              getUserUtility.sendEmail(csvBlob3,firstAuthUser3);
        }
        
         taskForCSVbyDM = getUserUtility.getUserbyDivision(rmdTasks);
        
         for(String usr : taskForCSVbyDM.keySet()){
             if(!firstAuthUser4.contains(usr)){
                 firstAuthUser4.add(usr);
             }
             if(csvStringByutil4 != ''){
                 csvStringByutil4 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
             }else{
                 csvStringByutil4 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
             }
             System.debug('csvStringByutil4 =>'+csvStringByutil4);
			 finalBlob4 = finalBlob4 + csvStringByutil4;
             csvBlob4 = Blob.valueOf(finalBlob4);
        } 
        if(firstAuthUser4.size() > 0){
            getUserUtility.sendEmail(csvBlob4,firstAuthUser4);
        }
        
        taskForCSVbyDM = getUserUtility.getUserbyDivision(rpcTasks);

        for(String usr : taskForCSVbyDM.keySet()){
            if(!firstAuthUser5.contains(usr)){
                firstAuthUser5.add(usr);
            }
            if(csvStringByutil5 != ''){
                csvStringByutil5 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
            }else{
                csvStringByutil5 += getUserUtility.getCsvString(taskForCSVbyDM.get(usr),7,queryFields);
            }
            System.debug('csvStringByutil5 =>'+csvStringByutil5);

			finalBlob5 = finalBlob5 + csvStringByutil5;
            csvBlob5 = Blob.valueOf(finalBlob5);
        } 

        if(firstAuthUser5.size() > 0){
             getUserUtility.sendEmail(csvBlob5,firstAuthUser5);
        }
             
            csvStringByutil6 = getUserUtility.getCsvString(allTaskRec,14,queryFields);
            
			finalBlob6 = finalBlob6 + csvStringByutil6;
            csvBlob6 = Blob.valueOf(finalBlob6);
        if(SecondAuthorityuserEmail.size() > 0){
             getUserUtility.sendEmail(csvBlob6,SecondAuthorityuserEmail);
        }
                    if(csvStringByutil7 != ''){
                csvStringByutil7 += getUserUtility.getCsvString(allTaskRec,21,queryFields);
            }else{
                csvStringByutil7 += getUserUtility.getCsvString(allTaskRec,21,queryFields);
            }
            System.debug('csvStringByutil7 =>'+csvStringByutil7);
        	finalBlob7 = finalBlob7 + csvStringByutil7;
        
			if(csvStringByutil7!=null){
                csvBlob7 = Blob.valueOf(finalBlob7);
            }
        if(presidentEmail.size() > 0)
        getUserUtility.sendEmail(csvBlob7,presidentEmail);
    }
}