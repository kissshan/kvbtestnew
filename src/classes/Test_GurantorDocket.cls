@isTest
public class Test_GurantorDocket {
@isTest
    public static void method1(){
          genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
          List<genesis__Applications__c> applist=new List<genesis__Applications__c>();
          applist.add(app);
          Map<Id,genesis__Applications__c> oldApp=new Map<Id,genesis__Applications__c>();
          oldApp.put(app.id, app);
          GurantorDocket.callDocket(applist, oldApp);
    }
}