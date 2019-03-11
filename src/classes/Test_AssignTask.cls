@isTest(SeeAllData=false)
public class Test_AssignTask {
    public static genesis__Applications__c genApp;
    //public static Application_Stage_by_Task_Matrix__mdt appStage;
    public static Account acc;
    
    @isTest
    public static void init(){
        genApp = Testutility.intialSetUp('Home Loan',true);
        genApp.RecordTypeId = SOQL_Util.getRecordTypeId('SME_Renewal');
        genApp.Application_Stage__c = 'Renewal Due';
        UPDATE genApp;
        
        
    }
    /*@isTest
    public static void methodUserAssign(){ 
        
    }*/
    @isTest
    public static void methodTaskAssignment(){
        init();
        List<genesis__Applications__c> listGenApp = new List<genesis__Applications__c>();
        listGenApp.add(genApp);
        
        //UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
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
            Division = 'DOM'
            //UserRoleId = r.Id
        );
        
        System.debug('u----'+u);
        
        
        System.runAs(u){
             Application_Stage_by_Task_Matrix__mdt metadatalist = new Application_Stage_by_Task_Matrix__mdt();
        System.debug('~~metadatalist'+metadatalist);
        //INSERT metadatalist;
        List<Application_Stage_by_Task_Matrix__mdt> appStage = new List<Application_Stage_by_Task_Matrix__mdt>();
        System.debug('check'+'--------');
        appStage = [SELECT Id,Application_Stage__c,Task_Subject__c,TAT_in_days__c,Role__c FROM Application_Stage_by_Task_Matrix__mdt WHERE Application_Stage__c =:'Renewal Due'];  
        System.debug('~~appStage'+appStage);
        //String 
        
        List<User> listOfUsers = new List<user>();
        listOfUsers = [SELECT Id FROM User WHERE Division =:appStage[0].Role__c ];
        System.debug('~~listOfUsers'+listOfUsers);
        Task t = new Task();
        t.OwnerId = listOfUsers[0].id;
        INSERT t;
        System.debug('~~t'+t);
            
            AssignTask.userAssign(listOfUsers);
        
        }
        AssignTask.taskAssignment(listGenApp);
        
    }
}