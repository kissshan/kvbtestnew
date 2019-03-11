@isTest
public class Test_UserTaskController {
    @isTest
    public static void methodTaskAssignment(){
        genesis__Applications__c genApp = TestUtility.intialSetUp('TestName',true);
        
        User userobj = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Division = 'DOM');
        
        System.debug('userobj----'+userobj);
        
        System.runAs(userobj){
            Task taskobj1 = new Task();
            taskobj1.OwnerId = userobj.Id;
            taskobj1.WhatId = genApp.Id;
            INSERT taskobj1;
            taskobj1.Status = 'Completed';
            UPDATE taskobj1;
            
            Test.startTest();
            UserTaskController usertaskcon = new UserTaskController();
            usertaskcon.UserTaskControllerHelper();
            usertaskcon.completeSelectedTask();
            Test.stopTest();
            
        }
    }
}