/*
* Name    : Test_queryService
* Company : ET Marlabs
* Purpose : Test class for queryService
* Author  : Subas
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
v1.1    20-Sep-2018    Prashant      Added test method
v1.2    28-Sep-2018    Braj          Added and Modified some test method
*******************************************************************************************/
//modified by prashant singh on 25-11-2018
//code coverage:--74%
@isTest
private class TaskFlow_Helper_Test{
    
    public static genesis__Applications__c genesis_applications_Obj =  TestUtility.intialSetUp('Home Loan', true);
    public static genesis__Applications__c genesis_applications_Obj1 =  TestUtility.intialSetUp('Home Loan1', true);
    
    @testSetup
    static void setupTestData(){

    	//v1.2(start)
        //initial test setup
        List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);

        genesis__Applications__c app = new genesis__Applications__c();
        app = appLst[0];
        app.Branch_Code__c = '1825';
        update app;

        User usr = VL_Test_Utility.createUser('braj@etmarlabs.com');
        Insert usr;
        //System.debug('usr>>>'+usr);

        List<UserRole> roleList= [SELECT Id, Name, DeveloperName FROM UserRole WHERE Name ='Branch manager' Limit 1];

        if (roleList.size()>0) {
	        //usr.UserRoleId = roleList[0].Id;//getting user while updating userrole
	        usr.Designation__c = 'RLPC processing officer';
        	usr.Office_Code__c = '1857';
	        update usr;
        }

        System.debug([Select ID From User where Office_Code__c =:'1825']);

        Branch_Master__c branchMaster = VL_Test_Utility.createBranchMaster('B','CHENNAI','1825');
        insert branchMaster;

        State_Master__c stateMaster=VL_Test_Utility.createStateMaster('TAMIL NADU',true);
        Insert stateMaster;

        String usrId = TaskFlow_Helper.getUserList(app.Branch_Code__c,'Branch manager');
      //  System.debug('usrId=='+usrId);

        Task tsk = VL_Test_Utility.createTask(app.id,usr.Id,'Assess income','Not Started',0);
        Insert tsk;
        //v1.2(end);
        
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        
        // genesis_applications_Obj.Flags_Raised__c=true;
        update genesis_applications_Obj;
       // system.debug('app'+genesis_applications_Obj);
        Account account_Obj = new Account(name = 'test1',Bureau_Score__c='8');
        insert account_Obj;
        
        
        
        Task task_Obj = new Task(WhatId = account_Obj.id, ActivityDate = Date.today(), Status = 'Not Started', Priority = 'High', IsReminderSet = false, IsRecurrence = false, genesis__Application__c = genesis_applications_Obj.id, genesis__Completion_Mandatory__c = false, genesis__Is_Parallel__c = false, Pre_defined_task__c = false, NonDeletable__c = false);
        Insert task_Obj;
        
    }
   
    static testMethod void test_createTask_UseCase1(){
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Sub_Stage__c = 'Work Information Captured';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = True;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        
        User user1 = getUser();
       // System.debug('user1:::'+user1);
        user1.Designation__c = 'RLPC processing officer';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void test_createTask_UseCase2(){
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Work Information Captured';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = false;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = True;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = 'DO Processing Officer';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;

        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void test_createTask_UseCase3(){
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = false;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Sub_Stage__c = 'Loan Sanctioned Non-STP';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = True;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = 'Branch manager';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    
    static testMethod void test_createTask_UseCase4(){
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = false;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Sub_Stage__c = 'Loan Sanctioned Non-STP';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = True;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = 'RLPC processing officer';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }   

    static testMethod void test_createTask_UseCase5(){
        //system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = 'RLPC processing officer';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    
    static testMethod void test_createTaskApp_UseCase1(){
        
        String genId = genesis_applications_Obj.id;
        Task task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task limit 1];
        //System.assertEquals(true,task_Obj.size()>0);
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
        TaskFlow_Helper.createTaskApp(genId,'test data', task_Obj);
    }
    static testMethod void test_creatTaskAll_UseCase1(){
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        System.assertEquals(true,task_Obj.size()>0);
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
        User usrId = getUser();
        TaskFlow_Helper.creatTaskAll(genesis_applications_Obj.id,usrId.id,'test data',6);

        
    }
     static testMethod void method_1(){
         genesis_applications_Obj.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
			update genesis_applications_Obj;
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task limit 1];
         //for(task t:task_Obj){ t.WhatId=genesis_applications_Obj.id; t.subject='Correct Documentation';update t;}
		//system.debug('task_Obj:-'+task_Obj);
         //system.debug('genesis_applications_Obj.id:-'+genesis_applications_Obj.id+'genesis_applications_Obj:-'+genesis_applications_Obj);
        System.assertEquals(true,task_Obj.size()>0);
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
        User usrId = getUser();
        TaskFlow_Helper.creatTaskAll(genesis_applications_Obj.id,usrId.id,'Correct Documentation',6);

        
    }
    static testMethod void test_getUserList_UseCase1(){
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        System.assertEquals(true,task_Obj.size()>0);
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
        TaskFlow_Helper.getUserList('1825','Branch manager');
    }
    static testMethod void test_getBMList_UseCase1(){
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        System.assertEquals(true,task_Obj.size()>0);
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
        TaskFlow_Helper.getBMList('test data','test data');
    }
    public static user getUser(){
        Profile prof = new Profile();
        prof = [select id from Profile where name ='System Administrator' limit 1];
        User usrId = new User(Alias = 'standt', Email='ashish.jain@etmarlabs.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',profileid =prof.id, 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', UserName='ashishjain@ajab.com');
        insert usrId;
        return usrId;
    }
    
    //v1.1(start)
    static testMethod void CrTaskAcc_method(){
        Trigger_Setting__c cuslabel=new Trigger_Setting__c();
        cuslabel.Execute_Account_Trigger__c=true;
        insert cuslabel;
        list<genesis__Applications__c> app=new list<genesis__Applications__c>([select id from genesis__Applications__c]);
        list<genesis__Application_Parties__c> party=new list<genesis__Application_Parties__c>([select id,Key_Contact__r.id,genesis__Application__c from genesis__Application_Parties__c]);         
        system.debug('appid'+app[0].id);    
        list<account> acc=new list<account>([select id,Employment_Type__c from account]);
        party[0].Key_Contact__r.id=acc[0].id ;  
        party[0].genesis__Application__c=app[0].id;
        //system.debug('party.genesis__Application__c'+ party[0].genesis__Application__c);
        
        
        acc[0].Employment_Type__c = 'Self-Employed Businessman';
        acc[0].Jocata_List_Match__c='Yes';
        acc[0].Bureau_Score__c='9';
        update acc[0];
        party[0].Active__c=true;
        party[0].Company__c=true;
        update party[0];
    }
    //v1.1(end)
    
    //v1.2(start)
    @isTest
    static void testTaskFlow_HelperForVL(){
        System.debug('testTaskFlow_HelperForVL >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		//genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL2W').getRecordTypeId();
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		List<genesis__Application_Parties__c> PTList = [Select Id,genesis__Application__r.Branch_Code__c,Key_Contact__c,genesis__Party_Account_Name__c From genesis__Application_Parties__c Where genesis__Application__c=: appLst[0].Id];
		if (PTList.size()>0) {
			PTList[0].Company__c = true;
			PTList[0].genesis__Party_Account_Name__c = appLst[0].genesis__Account__c;
			PTList[0].Key_Contact__c = appLst[0].genesis__Account__c;
			update PTList;
		}

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		//('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Additonal Income','Completed',0);
        Insert tsk;
                    
		genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.associtedBuisness(genApp.Id);
		String userid = TaskFlow_Helper.getUserList('1825','Branch manager');
		TaskFlow_Helper.creatTaskAll(genApp.id,'0057F000002wmro','test data',6);//negative test
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Additonal Income', tsk);
		Test.stopTest();
    }

    @isTest
    static void testTaskFlow_HelperForVL1(){
        System.debug('testTaskFlow_HelperForVL1 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE;
		//genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL2W').getRecordTypeId();
		genApp.Branch_Code__c = '1825';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Update mandatory documents & verify RC details','Completed',0);
        Insert tsk;

        genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.associtedBuisness(genApp.Id);
		String userid = TaskFlow_Helper.getUserList('1825','Branch manager');
		//System.debug('userid>>>'+userid);
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Update mandatory documents & verify RC details', tsk);
		Test.stopTest();
    }

    @isTest
    static void testTaskFlow_HelperForHOMELOAN(){
        System.debug('testTaskFlow_HelperForVL2 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Verify FI rejection','Completed',0);
        //Insert tsk;

		genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		//TaskFlow_Helper.createTaskApp(genApp.id,'Verify FI rejection', tsk);
		Test.stopTest();
    }

    @isTest
    static void testTaskFlow_HelperForLAP(){
        System.debug('testTaskFlow_HelperForVL2 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Verify property and purpose of loan','Completed',0);
        Insert tsk;

		genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Verify property and purpose of loan', tsk);
		Test.stopTest();
    }
    //v1.2(end)
    //prashant singh on 24-11-2018
        static testmethod void getRPCUser(){
            //task tsk=[select id from task];
            set<string> rpcusr=new set<string>();
                rpcusr.add('RLPC processing officer');
    TaskFlow_Helper.getRPCUser('1825',rpcusr);
        }
     @isTest
    static void testTaskFlow_HelperForLAP_v1(){
        System.debug('testTaskFlow_HelperForVL2 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Property data entry','Completed',0);
        Insert tsk;

		genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Property data entry', tsk);
		Test.stopTest();
    }
     @isTest
    static void testTaskFlow_HelperForLAP_v2(){
        System.debug('testTaskFlow_HelperForVL2 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Additional Income assessment','Completed',0);
        Insert tsk;

		genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Additional Income assessment', tsk);
		Test.stopTest();
    }
    
    
          static testmethod void preventTaskDeletion_method(){
            task tsk=[select id from task limit 1];
    TaskFlow_Helper.preventTaskDeletion(tsk);
        }
    
    
      static testMethod void Method(){
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Work Information Captured';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = false;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = True;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = 'DO Processing Officer';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
          appl1.Sub_Stage__c= Constants.PERSONNAL_DETAILS_CAPTURED_SUBSTAGE;
          update appl1;
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
       
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
     static testMethod void Method1(){
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Work Information Captured';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = false;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = True;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = 'Branch manager';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
          appl1.Sub_Stage__c=  Constants.SI_DETAILS_CAPTURED_SUBSTAGE;
         
          update appl1;
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
       
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method2(){
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Work Information Captured';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = false;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = True;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = 'Verifying Officer';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
          appl1.Sub_Stage__c=  Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE;
         
          update appl1;
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
       
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
     static testMethod void Method3(){
         
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Work Information Captured';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = false;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = True;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = 'RLPC Processing Officer';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
          appl1.Sub_Stage__c=  'Terms and Conditions Accepted';
         
          update appl1;
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
         
         genesis__Application_Parties__c party =new genesis__Application_Parties__c();     
        party.genesis__Party_Type__c = Constants.Co_Borrower;
        party.Active__c = true;
        party.genesis__Application__c=genesis_applications_Obj.id;
         party.Company__c=false;
         party.IsKYC__c=false;
        insert party;
        
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
       
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method4(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = 'Branch manager';
        user1.Office_Code__c = '1857';
        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'Terms and Conditions Accepted';
         
          update appl1;
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
        System.debug('rt:::'+appl1.Record_Type_Name__c);
        System.debug('rt1:::'+appl2.Record_Type_Name__c);
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
      static testMethod void Method5(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl1.Flags_Raised__c=true;
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl2.Flags_Raised__c=false;	
          appl2.Charges_Processed__c=appl1.Charges_Processed__c;
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method6(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'Loan Sanctioned Non-STP';  
          appl1.Flags_Raised__c=true;
        appl1.Loan_Purpose__c=Constants.IdentifiedProperty;
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl2.Flags_Raised__c=false;	
          appl2.Charges_Processed__c=appl1.Charges_Processed__c;
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
static testMethod void Method7(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'Loan Account Opened';  
          appl1.Flags_Raised__c=true;
        appl1.Loan_Purpose__c=Constants.IdentifiedProperty;
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl2.Flags_Raised__c=false;	
          appl2.Charges_Processed__c=appl1.Charges_Processed__c;
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
static testMethod void Method8(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'MOD Documents Esigned';  
          appl1.Flags_Raised__c=true;
        appl1.Loan_Purpose__c=Constants.IdentifiedProperty;
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl2.Flags_Raised__c=false;	
          appl2.Charges_Processed__c=appl1.Charges_Processed__c;
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }  
    static testMethod void Method9(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl1.Flags_Raised__c=true;
        appl1.Loan_Purpose__c=Constants.IdentifiedProperty;
        appl1.Is_Take_Over__c=true;
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
          appl2.Flags_Raised__c=false;	
          appl2.Charges_Processed__c=appl1.Charges_Processed__c;
        appl2.Is_Take_Over__c=appl1.Is_Take_Over__c;
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }  
     static testMethod void Method10(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl1.Flags_Raised__c=true;
         appl1.FI_Status__c='Fraud';

          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
          appl2.Flags_Raised__c=false;	
          appl2.Charges_Processed__c=appl1.Charges_Processed__c;
        appl2.Is_Take_Over__c=appl1.Is_Take_Over__c;
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }  
    static testMethod void Method11(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl1.Flags_Raised__c=true;

          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
          appl2.Perfios_Captured__c=FALSE;
        
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }  
    static testMethod void Method12(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl1.Flags_Raised__c=true;

          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
          appl2.Perfios_Captured__c=true;
        appl2.Additional_Income_Approval__c=true;
        
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method13(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL2W).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  'Terms and Conditions Accepted';  
          appl1.Flags_Raised__c=true;
			appl1.FI_Status__c='Fraud';
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
          appl2.Perfios_Captured__c=true;
        appl2.Additional_Income_Approval__c=true;
        
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method14(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL2W).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=  Constants.DISBURSEMENT_DOCUMENTS_ESIGNED_SUBSTAGE;  
         
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
         
        
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method15(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN ).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c=   Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE;  
          appl1.Flags_Raised__c=true;
			appl1.FI_Status__c='Fraud';
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
          appl2.Perfios_Captured__c=true;
        appl2.Additional_Income_Approval__c=true;
        appl2.Is_GMRA_Policy_Selected__c=false;
        
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
     static testMethod void Method16(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN ).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c= 'Terms and Conditions Accepted';  
          appl1.Flags_Raised__c=true;
			appl1.FI_Status__c='Fraud';
         appl1.Perfios_Captured__c=false;
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
          appl2.Perfios_Captured__c=true;
        appl2.Additional_Income_Approval__c=true;
        appl2.Is_GMRA_Policy_Selected__c=false;
        
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method17(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN ).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c= 'Terms and Conditions Accepted';  
         
         appl1.Perfios_Captured__c=true;
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
          appl2.Perfios_Captured__c=true;
        appl2.Additional_Income_Approval__c=true;
        appl2.Is_GMRA_Policy_Selected__c=false;
        
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method18(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN ).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c= 'Terms and Conditions Accepted';  
         
         appl1.Perfios_Captured__c=true;
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=   'MOD Documents Esigned';  
        appl2.Additional_Income_Approval__c=true;
        appl2.Is_GMRA_Policy_Selected__c=false;
        
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method19(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN ).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c= 'Terms and Conditions Accepted';  
         appl1.FI_Status__c='Fraud';
         appl1.Perfios_Captured__c=true;
          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=  'Terms and conditions accepted';  
        appl2.Additional_Income_Approval__c=true;
        appl2.Is_GMRA_Policy_Selected__c=false;
        
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    static testMethod void Method20(){
       // system.debug('genesis_applications_Obj'+genesis_applications_Obj);
        
        
          
        Branch_Master__c branchMaster = [select id,CODCCBRN__c from  Branch_Master__c];
        branchMaster.CODCCBRN__c='1857';
        update branchMaster;
       
        Id recttype = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN ).getRecordTypeId();
        System.debug('recttype:::'+recttype);
        list<Account> accList = new list<Account>();
        genesis_applications_Obj.Sub_Stage__c = 'Terms and Conditions Accepted';
        genesis_applications_Obj.Project_Code__c = 'Project Code';
        genesis_applications_Obj.Charges_Processed__c = True;
        genesis_applications_Obj.RecordTypeId = recttype;
        genesis_applications_Obj.Branch_Code__c = '1857';
        genesis_applications_Obj.Flags_Raised__c = true;
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Project_Code__c = 'Project Code';
        genesis_applications_Obj1.Charges_Processed__c = false;
        genesis_applications_Obj1.RecordTypeId = recttype;
        genesis_applications_Obj1.Branch_Code__c = '1857';
        genesis_applications_Obj.SI_Bank_Name__c = 'Axis Bank';
        genesis_applications_Obj1.Flags_Raised__c = true;
        
        User user1 = getUser();
        user1.Designation__c = null;
        user1.Office_Code__c = branchMaster.Division_Code__c;
       // user1.Role_Name__c = 'DO Processing Officer';
          user1.IsActive = true;

        //user1.UserRoleId = URole.Id;
        
        update user1;
        update genesis_applications_Obj;
        update genesis_applications_Obj1;
        genesis__Applications__c appl1 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj.id];
        appl1.Sub_Stage__c= 'Loan Sanctioned Non-STP';  
         appl1.FI_Status__c='Fraud';
         appl1.Perfios_Captured__c=true;
        appl1.Sanction_Date__c=date.parse('10/11/2018');
                appl1.MODValueCheckbox__c=true;

          update appl1;
           
        genesis__Applications__c appl2 = [SELECT Id , Sub_Stage__c,Flags_Raised__c, SI_Bank_Name__c,Is_Take_Over__c,Branch_Code__c,Project_Code__c,Charges_Processed__c,Record_Type_Name__c from genesis__Applications__c WHERE Id =: genesis_applications_Obj1.id];
          appl2.Sub_Stage__c=  'MOD Documents Esigned';  
        appl2.Additional_Income_Approval__c=true;
        appl2.Is_GMRA_Policy_Selected__c=false;
          update appl2;
  
        List<genesis__Applications__c> ga1 = new List<genesis__Applications__c>();
        List<genesis__Applications__c> ga2 = new List<genesis__Applications__c>();
        ga1.add(appl1);
        ga2.add(appl2);
        List<Task> task_Obj  =  [SELECT Id,WhatId,Subject,ActivityDate,Status,Priority,IsReminderSet,IsRecurrence,genesis__Application__c,genesis__Completion_Mandatory__c,genesis__Is_Parallel__c,Pre_defined_task__c,NonDeletable__c from Task];
        TaskFlow_Helper obj01 = new TaskFlow_Helper();
        TaskFlow_Helper.TASK_TRIGGER_RUNNING = false;
		system.debug('ga1:--'+ga1);
        system.debug('ga2:--'+ga2);
        system.debug('user1:-'+user1);
        TaskFlow_Helper.createTask(ga1,ga2);
        System.debug('end point');
    }
    
     @isTest
    static void testTaskFlow_HelperForVL12(){
        System.debug('testTaskFlow_HelperForVL1 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE;
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN ).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Enter property details','Completed',0);
        Insert tsk;

        genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.associtedBuisness(genApp.Id);
		String userid = TaskFlow_Helper.getUserList('1825','Branch manager');
		//System.debug('userid>>>'+userid);
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Enter property details', tsk);
		Test.stopTest();
    }
     @isTest
    static void testTaskFlow_HelperForVL11(){
        System.debug('testTaskFlow_HelperForVL1 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE;
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN ).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Assess income','Completed',0);
        Insert tsk;

        genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.associtedBuisness(genApp.Id);
		String userid = TaskFlow_Helper.getUserList('1825','Branch manager');
		//System.debug('userid>>>'+userid);
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Assess income', tsk);
		Test.stopTest();
    }
     @isTest
    static void testTaskFlow_HelperForVL111(){
        System.debug('testTaskFlow_HelperForVL1 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN ).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
        genApp.FI_Status__c='Negative';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Verify FI rejection','Completed',0);
        Insert tsk;

        genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.associtedBuisness(genApp.Id);
		String userid = TaskFlow_Helper.getUserList('1825','Branch manager');
		//System.debug('userid>>>'+userid);
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Verify FI rejection', tsk);
		Test.stopTest();
    }
     @isTest
    static void testTaskFlow_HelperForVL1111(){
        System.debug('testTaskFlow_HelperForVL1 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN ).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
        genApp.FI_Status__c='Negative';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Verify KYC','Completed',0);
        Insert tsk;

        genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.associtedBuisness(genApp.Id);
		String userid = TaskFlow_Helper.getUserList('1825','Branch manager');
		//System.debug('userid>>>'+userid);
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Verify KYC', tsk);
		Test.stopTest();
    }
    @isTest
    static void testTaskFlow_HelperForVL11111(){
        System.debug('testTaskFlow_HelperForVL1 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN ).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
        genApp.FI_Status__c='Negative';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Verify property and upload valuation and legal reports','Completed',0);
        Insert tsk;

        genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.associtedBuisness(genApp.Id);
		String userid = TaskFlow_Helper.getUserList('1825','Branch manager');
		//System.debug('userid>>>'+userid);
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Verify property and upload valuation and legal reports', tsk);
		Test.stopTest();
    }
      @isTest
    static void testTaskFlow_HelperForVL111111(){
        System.debug('testTaskFlow_HelperForVL1 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN ).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
        genApp.FI_Status__c='Negative';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'RMDTask','Completed',0);
        Insert tsk;

        genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.associtedBuisness(genApp.Id);
		String userid = TaskFlow_Helper.getUserList('1825','Branch manager');
		//System.debug('userid>>>'+userid);
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'RMDTask', tsk);
		Test.stopTest();
    }
    @isTest
    static void testTaskFlow_HelperForVL1111111(){
        System.debug('testTaskFlow_HelperForVL1 >>>');
		Trigger_Setting__c cs = new Trigger_Setting__c();
		cs.Execute_Application_Trigger__c=false;
		insert cs;

		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c where Record_Type_Name__c = 'VL2W' Limit 1];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);

		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp.Id=appln.Id;
		genApp.Sub_Stage__c = 'Terms and Conditions Accepted';
		genApp.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN ).getRecordTypeId();
		genApp.Branch_Code__c = '1825';
        genApp.FI_Status__c='Negative';
		update genApp;
		//System.debug('genApp after>>> '+genApp);

		//String usrId = TaskFlow_Helper.getUserList(genApp.Branch_Code__c,'Branch manager');
		User usr = getUser();
		System.debug('usr>>>'+usr);

		Task tsk = VL_Test_Utility.createTask(genApp.id,usr.Id,'Correct Documentation','Completed',0);
        Insert tsk;

        genesis__Applications__c applnUpdated = queryService.getApplication(genApp.Id);

		Test.startTest();
		TaskFlow_Helper.associtedBuisness(genApp.Id);
		String userid = TaskFlow_Helper.getUserList('1825','Branch manager');
		//System.debug('userid>>>'+userid);
		TaskFlow_Helper.createTask(new List<genesis__Applications__c>{applnUpdated},new List<genesis__Applications__c>{appln});
		TaskFlow_Helper.createTaskApp(genApp.id,'Correct Documentation', tsk);
		Test.stopTest();
    }
    
    

}