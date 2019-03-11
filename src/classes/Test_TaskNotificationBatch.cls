@isTest
public class Test_TaskNotificationBatch {
    @isTest
    public static void method1(){
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        user u1=Utility_Test.createUser('TestUserkvbank@test.com');
        u1.ManagerID=u.id;
        insert u1;   
        System.RunAs(u1){
            List<Task> tasks = new List<Task>{};
            date myDate = date.newInstance(2019, 11, 21);
            String userId = UserInfo.getUserId();
            Document document;
            
            document = new Document();
            document.Body = Blob.valueOf('Some Text');
            document.ContentType = 'application/pdf';
            document.DeveloperName = 'my_document';
            document.IsPublic = true;
            document.Name = 'My Document';
            document.FolderId = [select id from folder where name = 'Skuid Logos'].id;
            insert document;
            document =[Select Id,Name,LastModifiedById from Document where DeveloperName ='my_document' ];
            System.debug('document.Name'+document.Name);
            
            Task t = new Task();
            t.OwnerId = userId;
            t.Subject = 'Hello World';
            t.Status = 'Open';
            t.Priority = 'Normal';
            t.ActivityDate=myDate;
            insert t;
            
            Test.startTest();
            TaskNotificationBatch ob=new TaskNotificationBatch();
            DataBase.executeBatch(ob);
            Test.stopTest();
        }
    }
}