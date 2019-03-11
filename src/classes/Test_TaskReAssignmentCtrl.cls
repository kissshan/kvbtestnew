@isTest
public class Test_TaskReAssignmentCtrl{

    @testsetup
    public static void setupMethod()
    {

        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true);
        User usr = VL_Test_Utility.createUser('braj.test@test.com');
        usr.Super_User__c = true;
        Insert usr;
        System.debug('usr=='+usr);    
        Task tsk = VL_Test_Utility.createTask(applist[0].id,usr.Id,'Generate dealer document','Not Started',1);
        Insert tsk;
        System.debug('tsk>>'+tsk);
    }

	@isTest(SeeAllData=false)
	public static void testTaskReAssignment(){

        List<Task> lstTask = [Select Id,Subject,OwnerId,Owner.Name,Owner.UserRoleId,WhatId,CreatedDate,ActivityDate,Status from Task where Status!='Completed'];
        System.debug(lstTask.size()+'+lstTask>>'+lstTask);
        
        User usr = new User();
        if (lstTask.size()>0) {
            usr = [Select Id,Name,UserRoleId from User where Id=:lstTask[0].OwnerId];
            System.debug('+usr>>1'+usr);
        } else {
            usr = [Select Id,Name,UserRoleId from User limit 1];
            System.debug('+usr>>2'+usr);
        }

        Group RLPCGroup = new Group();
        RLPCGroup.Name = 'RLPCGroup';
        RLPCGroup.DeveloperName = 'ABC';
        INSERT RLPCGroup;

        System.debug('RLPCGroup>>'+RLPCGroup);

        GroupMember gpm = new GroupMember();
        gpm.GroupId = RLPCGroup.Id;
        gpm.UserOrGroupId = usr.Id;
        Database.insert(gpm);

        System.debug('gpm>>'+gpm);      

        Test.StartTest();
        System.runAs(usr){
            PageReference pageRef = Page.TaskReAssignmentPage;
            Test.setCurrentPage(pageRef);
            
            TaskReAssignmentCtrl scc = new TaskReAssignmentCtrl();
    
            //scc.tskWrpLst[0].isSelect=true;
            //scc.usrWrpLst[0].isSelect=true;
    
            /*TaskReAssignmentCtrl.taskWrap taskWrp = new scc.taskWrap(lstTask[0],true);  
            taskWrp.getPage(1);
            taskWrp.isTaskSelected();
    
            TaskReAssignmentCtrl.usrWrap usrWrp = new scc.usrWrap(usr,true);  
            usrWrp.getPage1(1);
            usrWrp.isUserSelected();*/
            
            List<TaskReAssignmentCtrl.taskWrap> tskWrpLst = new List<TaskReAssignmentCtrl.taskWrap>();
            //tskWrpLst.add(new TaskReAssignmentCtrl.taskWrap(lstTask[0],true));
            scc.tskWrpLst=tskWrpLst;
            
            List<TaskReAssignmentCtrl.usrWrap> usrWrpLst = new List<TaskReAssignmentCtrl.usrWrap>();
            //usrWrpLst.add(new TaskReAssignmentCtrl.usrWrap(usr,true));
            scc.usrWrpLst=usrWrpLst;
    
            scc.loadData();
            scc.nextPage();
            scc.prevPage();
            scc.getDisablePrevious();
            scc.getDisableNext();
            scc.nextPage1();
            scc.prevPage1();
            scc.getDisablePrevious1();
            scc.getDisableNext1();
            scc.reAssign();
            scc.filterTaskByOwner();
            //scc.isTaskSelected();
            //scc.isUserSelected();
        }
        Test.StopTest();
	}
    
    /*@isTest
	public static void testNegativeScenario(){
		Trigger_Setting__c custmsetting=new Trigger_Setting__c();
        custmsetting.Execute_Application_Trigger__c=true;
        insert custmsetting;
        ApplicationTriggerHandler.IsFirstRun=true;

        List<Task> lstTask = [Select Id,Subject,OwnerId,Owner.Name,Owner.UserRoleId,WhatId,CreatedDate,ActivityDate,Status from Task where Status!='Completed'];
        System.debug(lstTask.size()+'+lstTask>>'+lstTask);

        User usr = [Select Id,Name,UserRoleId from User where Id=:lstTask[0].OwnerId];
        System.debug('+usr>>'+usr);

        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        PageReference pageRef = Page.TaskReAssignmentPage;
        Test.setCurrentPage(pageRef);

        TaskReAssignmentCtrl scc = new TaskReAssignmentCtrl();
        scc.selectedGrpId = 'qwertyu1234567';
        scc.selectedOwnerId = 'qwertyu1234567';
        scc.tabId = 'qwertyu1234567';
        scc.loadData();
        scc.nextPage();
        scc.prevPage();
        scc.getDisablePrevious();
        scc.getDisableNext();
        scc.nextPage1();
        scc.prevPage1();
        scc.getDisablePrevious1();
        scc.getDisableNext1();
        scc.reAssign();
        scc.filterTaskByOwner();
        scc.isTaskSelected();
        scc.isUserSelected();
        //scc.getGrpUser('qwerty123456');
        scc.getGrpTask(new List<User>{new User()});
        scc.getPage(100);
        scc.getPage1(100);
        Test.StopTest();
    }*/
}