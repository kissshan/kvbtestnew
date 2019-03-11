@isTest
public class Test_PartyService {
@isTest
    public static void method1(){
        genesis__Applications__c appobj= TestUtility.intialSetUp('klkLoan',true);
        //insert appobj;
        //genesis__Applications__c appobj2= TestUtility.intialSetUp('testLoan',true);
        //insert appobj2;
        Account acc=new Account(Name='TestName');
        insert acc;
        Test.startTest();
        PartyService.createParty(Acc.Id,'coapplicant','brother',appobj.id,acc.Id);
        PartyService.getpartys(acc.Id,appobj.Id);
        PartyService.getApppartys(appobj.Id);
        Test.stopTest();
        
    }
    @isTest
    public static void method2(){
        genesis__Applications__c appobj= TestUtility.intialSetUp('klkLoan1',true);
        Account acc=new Account(Name='TestName1');
        insert acc;
        PartyService.getApppartys(appobj.Id);
        PartyService.getpartys(acc.Id,appobj.Id);
    }
    @isTest
    public static void  method3(){
        genesis__Applications__c appobj= TestUtility.intialSetUp('klkLoan1',true);
        Account acc=new Account(Name='TestName1');
        insert acc;
        PartyService.getApppartys(appobj.Id);
    }
}