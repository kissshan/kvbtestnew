@isTest
public class Test_CallCBS_API {

    @isTest
    public static void method1(){
         genesis__Applications__c app=TestUtility.intialSetUp('Test',true) ;
        CBS_API_Log__c ob=new CBS_API_Log__c(API_Name__c='Test',Application__c=app.id);
        insert ob;
    }
}