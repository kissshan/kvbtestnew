@isTest
public class Test_AssignBranch {
    @isTest
    public static void method1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='kundu', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', isActive = true, UserName='kundu12@gmail.com',Office_Code__c='77hh');
        insert u;
        DSA_Master__c obj=new DSA_Master__c(Branch_Code__c='77hh',Employ_Code__c='99oo');
        insert obj;
        //genesis__applications__c app = new 
     /*   Account acc = new Account();
        acc.name='TestName';
        acc.OwnerId=u.Id;
        insert acc;*/
        
        
       // genesis__Application_Parties__c party = new genesis__Application_Parties__c();
        
      /*  genesis__Applications__c app=TestUtility.intialSetUp('TestHomeLoan',true);
        genesis__Applications__c app1=[select id,(select id,genesis__Party_Account_Name__c from genesis__Application_Parties__r) from genesis__Applications__c where id=:app.id];
        AssignBranch.getBranch(app1.id,'77hh','99oo');
        AssignBranch.getDoUser('99oo');
        AssignBranch.getUser('T34');*/
        
        List<genesis__Applications__c> app2list=VL_Test_Utility.intialSetUp(true,true);
        AssignBranch.getBranch(app2list[0].id,'77hh','99oo');
        AssignBranch.getDoUser('99oo');
        AssignBranch.getUser('T34');
    }
    /*public static void method2(){
        
    }*/
}