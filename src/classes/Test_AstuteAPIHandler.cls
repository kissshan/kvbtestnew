@isTest
public class Test_AstuteAPIHandler {
@isTest
    public static void method1()
    {
        Test.startTest();
        genesis__Applications__c app = TestUtility.intialSetUp('LAP', false);
        AstuteAPIHandler.AstuteCallHandler(app.id);
        Test.stopTest();
    }
}