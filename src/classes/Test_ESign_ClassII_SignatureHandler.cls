@isTest
public class Test_ESign_ClassII_SignatureHandler {
@isTest
    public static void method1(){
       genesis__Applications__c app=TestUtility.intialSetUp('TestHome',true);
       ESign_ClassII_SignatureHandler.makeESignSigntureCall(app.ID, app);
    }
}