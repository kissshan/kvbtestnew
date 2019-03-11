@isTest
public class Test_UpdateDocName_Handler {
@isTest
    public static void method1(){
         genesis__Applications__c app=TestUtility.intialSetUp('TestName',true);
        genesis__Application_Document_Category__c ob=new genesis__Application_Document_Category__c();
        ob.genesis__Active__c=true;
        ob.genesis__Application__c=app.id;
        insert ob;
        /// insert attachment
        Account acct = new Account(Name='Test Account'); 
        insert acct;
        Blob b = Blob.valueOf('Test Data');
      
        Attachment attachment = new Attachment();
        attachment.ParentId = acct.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
     
        insert(attachment);

        genesis__AppDocCatAttachmentJunction__c jun=new genesis__AppDocCatAttachmentJunction__c();
        jun.genesis__Application_Document_Category__c=ob.Id;
        insert jun;
        List<genesis__AppDocCatAttachmentJunction__c> junlist=new  List<genesis__AppDocCatAttachmentJunction__c>();
        junlist.add(jun);
        UpdateDocName_Handler.getDocName(junlist);
        UpdateDocName_Handler.getUuidByAttachmentId('si','askjk',attachment.id);
    }
 @isTest
    public static void method2(){
        
    }
}