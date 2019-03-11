/*
* Name              : Batch_TaskEscilationMatrixTest
* Company           : ET Marlabs
* Purpose           : Test Class for Batch_TaskEscilationMatrix Class
* Author            : Kriti Umesh
* last Modified By  : 
*/


@istest(seeAlldata=false)
public class Batch_TaskEscilationMatrixTest 
{
    
    public static void createManager(){
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System administrator'];
        UserRole r1 = new UserRole(DeveloperName ='DO_HEAD1', Name ='DO Head');
        insert r1;
        //creating user testdata
        user userobjectExt= new user();
        userobjectExt.UserRoleId=r1.id;
        userobjectExt.Designation__c='manager';
        userobjectExt.Division='CHENNAI';
        userobjectExt.Alias='jsmith';
        userobjectExt.Email='jsmith@acme.com';
        userobjectExt.emailencodingkey='UTF-8';
        userobjectExt.LastName='Smith';
        userobjectExt.LanguageLocaleKey='en_US';
        userobjectExt.LocaleSidKey='en_US';
        userobjectExt.ProfileId=p1.id;
        userobjectExt.TimeZoneSidKey='America/Los_Angeles';
        userobjectExt.Username='do.head@kbv.com';
        insert userobjectExt;
    }
    
    public static User createUser(String usrName,String RoleName, String RoleDName, String usrDiv){
        UserRole r = new UserRole(DeveloperName = RoleDName, Name =RoleName);
        Insert r;
        Profile p = [SELECT Id FROM Profile WHERE Name='System administrator'];
        
        //creating user testdata
        user userobject= new user();
        userobject.UserRoleId=r.id;
        userobject.Designation__c='manager';
        userobject.Division=usrDiv;
        userobject.Alias='jsmith';
        userobject.Email='jsmith@acme.com';
        userobject.emailencodingkey='UTF-8';
        userobject.LastName='Smith';
        userobject.LanguageLocaleKey='en_US';
        userobject.LocaleSidKey='en_US';
        userobject.ProfileId=p.id;
        userobject.TimeZoneSidKey='America/Los_Angeles';
        userobject.Username=usrName;
        insert userobject;
        return userobject;
    }
    
    public static void testdata(String usrDiv)
    {
        System.runAs (new User(Id = UserInfo.getUserId()) ) {
            //creating account testdata
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB'); 
            insert acc;
            
            //creating application testdata
            genesis__Applications__c genappobj=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            insert genappobj;
            
            //creating branch master testdata
            Branch_Master__c branchobj = new Branch_Master__c();
            branchobj.Division__c=usrDiv;
            branchobj.CODCCBRN__c='CODCCBRN'+Math.random();
            branchobj.NAM_BRANCH__c='kvb';
            branchobj.Division_Code__c='1234';
            insert branchobj;
        }
    }
    @istest
    public static void method_BM()
    {
        User userobjectBM = createUser('bm@kvbmail.com','Branch manager','Branch_manager1','CHENNAI');
        testdata('CHENNAI');
        System.runAs (new User(Id = UserInfo.getUserId()) ) {
            genesis__Applications__c genappobj =[select id from genesis__Applications__c limit 1];
            task taskobject = new task();
            taskobject.OwnerId=userobjectBM.Id;
            taskobject.Test_check__c=true;
            taskobject.Application_Name__c='loan';
            taskobject.Subject='call';
            taskobject.WhatId=genappobj.Id;
            taskobject.ActivityDate=system.today();
            taskobject.Due_Date__c='after 10 days';
            taskobject.Created_Date__c='today';
            taskobject.Owner_Division__c='south';
            taskobject.Status='not completed';
            taskobject.Application_Record_Type__c='small income';
            taskobject.Product_Name__c='home loan';
            taskobject.Application_Type__c='mannual';
            insert taskobject;
        }
        User userobjectROO = createUser('ROO@kvbmail.com','RPC Outsource Officer','RPC_Outsource_Officer1','CHENNAI');
        testdata('CHENNAI');
        System.runAs (new User(Id = UserInfo.getUserId()) ) {
            genesis__Applications__c genappobj =[select id from genesis__Applications__c limit 1];
            task taskobject = new task();
            taskobject.OwnerId=userobjectROO.Id;
            taskobject.Test_check__c=true;
            taskobject.Application_Name__c='loan';
            taskobject.Subject='call';
            taskobject.WhatId=genappobj.Id;
            taskobject.ActivityDate=system.today();
            taskobject.Due_Date__c='after 10 days';
            taskobject.Created_Date__c='today';
            taskobject.Owner_Division__c='south';
            taskobject.Status='not completed';
            taskobject.Application_Record_Type__c='small income';
            taskobject.Product_Name__c='home loan';
            taskobject.Application_Type__c='mannual';
            insert taskobject;
        }
        User userobjectRH = createUser('RH@kvbmail.com','RLPC Head','RLPC_Head1','CHENNAI');
        testdata('CHENNAI');
        System.runAs (new User(Id = UserInfo.getUserId()) ) {
            genesis__Applications__c genappobj =[select id from genesis__Applications__c limit 1];
            task taskobject = new task();
            taskobject.OwnerId=userobjectRH.Id;
            taskobject.Test_check__c=true;
            taskobject.Application_Name__c='loan';
            taskobject.Subject='call';
            taskobject.WhatId=genappobj.Id;
            taskobject.ActivityDate=system.today();
            taskobject.Due_Date__c='after 10 days';
            taskobject.Created_Date__c='today';
            taskobject.Owner_Division__c='south';
            taskobject.Status='not completed';
            taskobject.Application_Record_Type__c='small income';
            taskobject.Product_Name__c='home loan';
            taskobject.Application_Type__c='mannual';
            insert taskobject;
        }
        User userobjectRMD = createUser('RMD@kvbmail.com','RMD officer','RMD_officer1','CHENNAI');
        testdata('CHENNAI');
        System.runAs (new User(Id = UserInfo.getUserId()) ) {
            genesis__Applications__c genappobj =[select id from genesis__Applications__c limit 1];
            task taskobject = new task();
            taskobject.OwnerId=userobjectRMD.Id;
            taskobject.Test_check__c=true;
            taskobject.Application_Name__c='loan';
            taskobject.Subject='call';
            taskobject.WhatId=genappobj.Id;
            taskobject.ActivityDate=system.today();
            taskobject.Due_Date__c='after 10 days';
            taskobject.Created_Date__c='today';
            taskobject.Owner_Division__c='south';
            taskobject.Status='not completed';
            taskobject.Application_Record_Type__c='small income';
            taskobject.Product_Name__c='home loan';
            taskobject.Application_Type__c='mannual';
            insert taskobject;
        }
        User userobjectLCO = createUser('LCO@kvbmail.com','Legal Clearance Officer','Legal_Clearance_Officer1','CHENNAI');
        testdata('CHENNAI');
        System.runAs (new User(Id = UserInfo.getUserId()) ) {
            genesis__Applications__c genappobj =[select id from genesis__Applications__c limit 1];
            task taskobject = new task();
            taskobject.OwnerId=userobjectLCO.Id;
            taskobject.Test_check__c=true;
            taskobject.Application_Name__c='loan';
            taskobject.Subject='call';
            taskobject.WhatId=genappobj.Id;
            taskobject.ActivityDate=system.today();
            taskobject.Due_Date__c='after 10 days';
            taskobject.Created_Date__c='today';
            taskobject.Owner_Division__c='south';
            taskobject.Status='not completed';
            taskobject.Application_Record_Type__c='small income';
            taskobject.Product_Name__c='home loan';
            taskobject.Application_Type__c='mannual';
            insert taskobject;
        }
        createManager();
        Test.startTest();
        //calling batch class
        Batch_TaskEscilationMatrix tskescobj = new Batch_TaskEscilationMatrix();
        DataBase.executeBatch(tskescobj);
        Test.stopTest();
    }
}