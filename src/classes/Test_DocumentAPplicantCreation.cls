@isTest
public class Test_DocumentAPplicantCreation {

    @isTest
    public static void method1(){
        genesis__Applications__c app=TestUtility.intialSetUp('Test',true) ;
        Digio_Document_ID__c ob=new Digio_Document_ID__c(Application__c=app.Id);
        insert ob;
    }
}