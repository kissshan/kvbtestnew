@isTest
public class Test_appTaskCreation {
  
    @isTest
    public static void apptask(){
        
        genesis__Applications__c app=TestUtility.intialSetUp('Test',true) ;
        Task ta=new Task();
        ta.WhatId=app.id;
        ta.Status='Completed';
        ta.Subject='Test';
        insert ta;
        
        ta.Priority = 'High';
        update ta;
    }
}