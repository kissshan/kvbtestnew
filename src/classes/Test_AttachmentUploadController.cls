/*
 * Author   :    uday kali
 * coverage  :    82%
 */
@isTest
public class Test_AttachmentUploadController {
    @isTest
    public static void method1(){
         PageReference pageRef = new PageReference('/apex/AttachmentUploadVfPage?id=');
         Test.setCurrentPage(pageRef);
       
        
       Account acc=new account();
         acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
         insert acc;
        
        genesis__Applications__c genApp=new genesis__Applications__c();
          genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
        insert genApp;
         
       Digio_Document_ID__c dgoDoc = SME_TestUtil.createDgioDoc(genApp.id,'test');
        //dgoDoc.Document_ID__c = attchObj.Id;
        insert dgoDoc;
         ApexPages.currentPage().getParameters().put('Id', dgoDoc.Id);

        Test.startTest();
        AttachmentUploadController auc=new AttachmentUploadController();
        auc.upload();
        Test.stopTest();
    }
}