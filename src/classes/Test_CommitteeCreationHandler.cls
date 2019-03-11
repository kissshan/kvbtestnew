@isTest
public class Test_CommitteeCreationHandler {
@isTest
    public static void method1(){
        CommitteeCreationHandler ob=new CommitteeCreationHandler();
        ob.DOCO_Flag=true;
        ob.userListformat='test';
        ob.onLoad();
    }
    
    
  @isTest  
    public static void method2(){
      User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'BR_MGR_SMALL'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     Designation__c='BR_MGR_SMALL',
     Division='CHENNAI'
    // UserRoleId = r.Id
);  
        
        
        
        ////////////////////////////////////////////////
        User u2 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'BR_MGR_MEDIUM'].Id,
     LastName = 'kundu',
     Email = 'kunduniladri901@gmail.com',
     Username = 'niladri@gmail.com' + System.currentTimeMillis(),
     CompanyName = 'TEST2',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     Designation__c='BR_MGR_SMALL',
     Division='CHENNAI'
    // UserRoleId = r.Id
);  
        
        genesis__Meeting_Schedule__c  me=new genesis__Meeting_Schedule__c();
        me.genesis__Status__c='Completed';
        me.Division__c='CHENNAI';
        me.genesis__Type__c='Board Committee';
        insert me;
        
        genesis__Committee_Member__c  commem=new  genesis__Committee_Member__c();
        commem.Division__c='DOM';
        commem.genesis__User__c=u.Id;
        commem.genesis__Role__c = 'Attendee';
        commem.genesis__Has_Attended__c=true;
        commem.genesis__Meeting_Schedule__c=me.Id;
        insert commem;
        List<user> userlist=new List<user>();
        userlist.add(u);
        userlist.add(u2);
        insert userlist;
        CommitteeCreationHandler.userSaveList(userlist);
    }
}