@isTest
public class Test_LAP_EmailHandaller {
@isTest
    public static void method1(){
    
    Account acc= new Account();
    acc.Name='Testname';
    insert acc;
    /*Attachment Attachment =new Attachment();
        Attachment.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment.body=bodyBlob;
        Attachment.parentId=acc.id;
        insert Attachment ;
        
   Messaging.EmailFileAttachment eAttach = new Messaging.EmailFileAttachment();
    //eAttach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        eAttach.body=bodyBlob;
        //eAttach.parentId=acc.id;
        insert eAttach ;*/
        
        LAP_EmailHandaller.LAP_Email('niladrikundu1993@gmail.com', 'Testemailbody', 'testemailsubj');
        //LAP_EmailHandaller.PLEmail('test@gmail.com', 'Testbody', 'testsubj',null);
    }
}