/*
* Name    : getUserUtility 
* Company : ET Marlabs
* Purpose : This class is used to get the user details on some specific conditions
* Author  : Shubham Shukla
*/
public class getUserUtility {
    
    public static Map<String,List<Task>> getUserbyDivision(List<Task> tskList){
        
        Set<Id> ownerIds = new Set<Id>();
        Set<String> divisionSet = new Set<String>();
        Map<user,List<Task>> tasksbyUserMap = new Map<user,List<Task>>();
        Map<String,List<User>> userByDivision = new Map<String,List<User>>();
        Map<String,List<Task>>  DmuserByTasks = new Map<String,List<Task>>();
        List<User> ListbmheadUser1 = new List<User>();
        List<User> ListbmheadUser2 = new List<User>();
        List<User> ListbmheadUser3 = new List<User>();
        List<User> ListbmheadUser4 = new List<User>();
        List<User> ListbmheadUser5 = new List<User>();
        List<Branch_Master__c> brnchDiv = [SELECT Id, Name, Division__c, CODCCBRN__c, NAM_BRANCH__c, Division_Code__c FROM Branch_Master__c];
        for(Branch_Master__c div : brnchDiv){
            if(!divisionSet.contains(div.Division__c)){
                divisionSet.add(div.Division__c);
            }
        }
        ListbmheadUser1 = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'DO Head'];
        ListbmheadUser2 = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'DGM'];
        ListbmheadUser3 = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'DGM'];
        ListbmheadUser4 = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'DO Head'];
        ListbmheadUser5 = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'RMD DGM'];
        for(Task tk : tskList){
            
            try{
                if(tk.Owner.UserRole.name == 'Branch manager'){
                    
                    Task_Escalation_Matrix__mdt tskescmetadata=fetchEscalationRecord_level1(tk.Owner.UserRole.name);
                    
                    if(tk.Pending_Days__c > tskescmetadata.Min_Days_Range__c)    //(tk.ActivityDate).daysBetween(system.today()) && tskescmetadata.Max_Days_Range__c>(tk.ActivityDate).daysBetween(system.today()) ---- && tskescmetadata.Max_Days_Range__c > tk.Pending_Days__c
                    {
                        if(!ownerIds.contains(tk.OwnerId)){
                            ownerIds.add(tk.OwnerId);
                        }
                        
                       // ListbmheadUser = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'DO Head']; 
                    }
                }else if(tk.Owner.UserRole.Name == 'RPC Outsource Officer'){
                    
                    Task_Escalation_Matrix__mdt tskescmetadata=fetchEscalationRecord_level1(tk.Owner.UserRole.name);
                    if(tk.Pending_Days__c > tskescmetadata.Min_Days_Range__c)
                    {
                        
                        if(!ownerIds.contains(tk.OwnerId)){
                            
                            ownerIds.add(tk.OwnerId);
                        }
                        //ListbmheadUser = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'DGM'];
                        
                    }
                    
                }else if(tk.Owner.UserRole.Name == 'RLPC Head'){
                    
                    Task_Escalation_Matrix__mdt tskescmetadata=fetchEscalationRecord_level1(tk.Owner.UserRole.name);
                    if(tk.Pending_Days__c > tskescmetadata.Min_Days_Range__c)
                    {
                        
                        if(!ownerIds.contains(tk.OwnerId)){
                            
                            ownerIds.add(tk.OwnerId);
                        }
                       // ListbmheadUser = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'DGM'];
                        
                    }
                    
                }else if(tk.Owner.UserRole.name == 'DO Legal Clearance Officer'){
                    
                    Task_Escalation_Matrix__mdt tskescmetadata=fetchEscalationRecord_level1(tk.Owner.UserRole.name);
                    if(tk.Pending_Days__c > tskescmetadata.Min_Days_Range__c)
                    {
                        
                        if(!ownerIds.contains(tk.OwnerId)){
                            
                            ownerIds.add(tk.OwnerId);
                        }
                      //  ListbmheadUser = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'DO Head'];
                        
                    }
                    
                }else if(tk.Owner.UserRole.Name == 'RMD officer'){
                    
                    Task_Escalation_Matrix__mdt tskescmetadata=fetchEscalationRecord_level1(tk.Owner.UserRole.name);
                    if(tk.Pending_Days__c > tskescmetadata.Min_Days_Range__c)
                    {
                        
                        if(!ownerIds.contains(tk.OwnerId)){
                            
                            ownerIds.add(tk.OwnerId);
                        }
                      //  ListbmheadUser = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Division IN: divisionSet AND UserRole.Name = 'RMD DGM'];
                        
                    }
                    
                }
            } catch(Exception e)
            {
                continue;
            }
            
        }
        
        List<User> userList = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where Id IN: ownerIds];
        
        Set<string> setOfDivision = new set<string>();
        for(User us : userList){
            List<Task> newTsk = new List<Task>();
            
            if(ownerIds.contains(us.Id)){
                
                for(Task tks : tskList){
                    if(tks.OwnerId == us.Id && tks.Pending_Days__c > 7){  
                        newTsk.add(tks);
                    }
                }
                System.debug('newTsk>>>>::'+newTsk);
                tasksbyUserMap.put(us,newTsk);
                setOfDivision.add(us.division);
                
            }
            
        }
        
         if(ListbmheadUser1.size() > 0){
            for(User u : ListbmheadUser1){
                List<User> newUser = new List<User>();
                List<task> finaltasklist = new list<task>();
                for(User t : tasksbyUserMap.keyset()){
                    
                    if(u.Division == t.Division){
                        
                        newUser.add(u);
                        
                        finaltasklist.addAll(tasksbyUserMap.get(t));
                    }
                }
                if(newUser != null && newUser.size()>0)
                    userByDivision.put(u.Email,newUser); 
                DmuserByTasks.put(u.Email,finaltasklist);
            }
        }
         if(ListbmheadUser2.size() > 0){
            for(User u : ListbmheadUser2){
                List<User> newUser = new List<User>();
                List<task> finaltasklist = new list<task>();
                for(User t : tasksbyUserMap.keyset()){
                    
                    if(u.Division == t.Division){
                        
                        newUser.add(u);
                        
                        finaltasklist.addAll(tasksbyUserMap.get(t));
                    }
                }
                if(newUser != null && newUser.size()>0)
                    userByDivision.put(u.Email,newUser); 
                DmuserByTasks.put(u.Email,finaltasklist);
            }
        }
         if(ListbmheadUser3.size() > 0){
            for(User u : ListbmheadUser3){
                List<User> newUser = new List<User>();
                List<task> finaltasklist = new list<task>();
                for(User t : tasksbyUserMap.keyset()){
                    
                    if(u.Division == t.Division){
                        
                        newUser.add(u);
                        
                        finaltasklist.addAll(tasksbyUserMap.get(t));
                    }
                }
                if(newUser != null && newUser.size()>0)
                    userByDivision.put(u.Email,newUser); 
                DmuserByTasks.put(u.Email,finaltasklist);
            }
        }
         if(ListbmheadUser4.size() > 0){
            for(User u : ListbmheadUser4){
                List<User> newUser = new List<User>();
                List<task> finaltasklist = new list<task>();
                for(User t : tasksbyUserMap.keyset()){
                    
                    if(u.Division == t.Division){
                        
                        newUser.add(u);
                        
                        finaltasklist.addAll(tasksbyUserMap.get(t));
                    }
                }
                if(newUser != null && newUser.size()>0)
                    userByDivision.put(u.Email,newUser); 
                DmuserByTasks.put(u.Email,finaltasklist);
            }
        }
         if(ListbmheadUser5.size() > 0){
            for(User u : ListbmheadUser5){
                List<User> newUser = new List<User>();
                List<task> finaltasklist = new list<task>();
                for(User t : tasksbyUserMap.keyset()){
                    
                    if(u.Division == t.Division){
                        
                        newUser.add(u);
                        
                        finaltasklist.addAll(tasksbyUserMap.get(t));
                    }
                }
                if(newUser != null && newUser.size()>0)
                    userByDivision.put(u.Email,newUser); 
                DmuserByTasks.put(u.Email,finaltasklist);
            }
        }
        return DmuserByTasks;
    }
    
    public static List<User> getSecondLevelAuthorityUser(List<Task> AllTskList){
        
        List<User> allSecondAuthorityUser = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name from User where UserRole.Name = 'GM'];
        System.debug('General Manager:::::::'+allSecondAuthorityUser);
        return allSecondAuthorityUser;
        
    }
    
    public static List<User> getPresidentUser(List<Task> AllpresidentTskList){
        
        List<User> PresidentUserList = [Select id,UserRole.Name,Email,UserRoleId,Designation__c,Division,Name, IsActive from User where UserRole.Name = 'President' AND IsActive = true];
        System.debug('President User:::::'+PresidentUserList);
        return PresidentUserList;
        
    }
    
    public static void sendEmail(blob csvData,List<String> listofemailaddress){
        List<String> mailList = new List<String>();
        List<String> mailAddresses = new List<String>(); 
        Date fileDate = System.today();
        String messageBody =  '<html><body>Dear sir, <br><br>Please find attached the list of employees for whom tasks related to loan applications are pending as of <br>today. Request you to kindly follow up with the concerned employees and close the pending complete the tasks<br>at the earliest. <br>Feel free to reach out to us in case of any discrepancies. <br><br>Thank you </body></html>';
        
        // List<String> listofemailaddress1= new List<String>{'shubham.shukla@etmarlabs.com'};
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('List of Overdue Tasks_'+String.valueOf(fileDate)+'.csv');
        efa.setBody(csvData);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setToAddresses(listofemailaddress);
        mail.setSenderDisplayName('Support@kvb.com');
        mail.setSubject('List of Overdue Tasks');
        mail.setHtmlBody(messageBody);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});     
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        
    }
    public static String getCsvString(List<task> takList,Integer daysValue,List<String> queryFields){
        
        Integer count = 0;
      //  String csvFileString1;
        String csvFileString2;
        String fileRow1 = '';
        String fieldValue1 = '';
        String csvFileString1 = '';
            system.debug('inside csv for header');
            for(String fieldName : queryFields){  
                 System.debug('fieldName:::==>'+fieldName);
                count++;
                if(count == 1){
                   fieldName = 'Owner Division';
                   csvFileString1 = fieldName.replace(',','');//csvFileString1 + ',' + fieldName.replace(',',''); 
                    System.debug('csvFileString1:::==>'+csvFileString1);
                }
                if(count == 2){
                    fieldName = 'Owner Branch';
                    csvFileString1 = csvFileString1 + ',' + fieldName.replace(',','');
                    System.debug('csvFileString1:::==>'+csvFileString1);
                }
                
                if(count == 3){
                    fieldName = 'Application Type';
                    csvFileString1 = csvFileString1 + ',' + fieldName.replace(',','');
                    System.debug('csvFileString1:::==>'+csvFileString1);
                }
                
                if(count == 4){
                    fieldName = 'Application Record Type';
                    csvFileString1 = csvFileString1 + ',' + fieldName.replace(',','');
                    System.debug('csvFileString1:::==>'+csvFileString1);
                }
                 if(count == 5){
                    String fieldVal = fieldName.replace('What.Name','');
                    fieldVal = 'Application No.';
                    csvFileString1 = csvFileString1 + ',' + fieldVal.replace(',','');
                     System.debug('csvFileString1:::==>'+csvFileString1);
                }
                
                if(count == 6){
                    fieldName = 'Subject';
                    csvFileString1 = csvFileString1 + ',' + fieldName.replace(',','');
                    System.debug('csvFileString1:::==>'+csvFileString1);
                }
                
                if(count == 7){
                    fieldName = 'Assigned to';
                    csvFileString1 = csvFileString1 + ',' + fieldName.replace(',','');
                    System.debug('csvFileString1:::==>'+csvFileString1);
                }
                if(count == 8){
                   fieldName = 'Due Date';
                   csvFileString1 = csvFileString1 + ',' + fieldName.replace(',',''); 
                    System.debug('csvFileString1:::==>'+csvFileString1);
                }
                if(count == 9){
                   fieldName = 'Pending Days';
                   csvFileString1 = csvFileString1 + ',' + fieldName.replace(',',''); 
                    System.debug('csvFileString1:::==>'+csvFileString1);
                }
                
            }
            csvFileString1 = csvFileString1.removeEnd(',') + '\n';
            if(csvFileString1.contains('Application No.')){
    
                String csvLabel = csvFileString1.subString(4);
                //csvFileString1 = csvLabel.replaceFirst(',','') + '\n';
              
            }else{
    
                csvFileString1 = csvFileString1 + csvFileString1.replaceFirst(',','') + '\n';
    
            }
        
        
        for(Task tsk : takList) {
            if(tsk.Pending_Days__c > daysValue){
                fileRow1 = '';
                System.debug('222222===>' + tsk); 
                
                for(String fieldName : queryFields){
                    
                    fieldValue1 = '' + tsk.get(fieldName);
                    System.debug(':::::'+fieldValue1);
                    fieldValue1 = fieldValue1.replace(',','');
                    System.debug('----->'+fieldValue1);
                    fileRow1 = fileRow1 + ',' + fieldValue1;
                    
                }
                
                fileRow1 = fileRow1.replaceFirst(',','');
                csvFileString1 = csvFileString1 + fileRow1 + '\n';
            }
        }
        return csvFileString1;
    }
     public static Task_Escalation_Matrix__mdt fetchEscalationRecord_level1(string name)
    {
        return [select id,Max_Days_Range__c,Min_Days_Range__c from Task_Escalation_Matrix__mdt where MasterLabel=:name];
    }
    
}