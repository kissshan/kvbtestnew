@isTest
public class Test_SME_Email_Handler {
    
    public static void method1(){
        genesis__Applications__c app=TestUtility.intialSetUp('TestName',true);
        
        List<Folder> folderlist=[Select Id from folder where name='TestFolder' limit 1];
        System.debug('folderlist:::'+folderlist);
        List<Document> docList = [Select Id  from Document];
        System.debug('docList:::'+docList);
        /*if(docList.size()==0){
Document doc =new Document();
doc.AuthorId = UserInfo.getUserId();
doc.DeveloperName='Kvb_logo_for_Email';
doc.Name='record';
doc.FolderId=folderlist[0].id;
insert doc;
}*/
        SME_Email_Handler.getDocumentLogoUrl();
    }
    
    @isTest
    public static void method2(){
        genesis__Applications__c app=TestUtility.intialSetUp('TestName',true);
      
         Account acc = new Account(firstName='Venu',LastName='Gopal', Employment_Type__c = 'Salaried');
        insert acc;
         clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='hhu');
        insert product;
         genesis__Applications__c newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Loan_Number__c = 'TS123'; 
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
        newApp.genesis__Account__c =acc.id;
        newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = 'Disbursement Rejected';
        insert newApp;
        //newApp.Application_Stage__c = 'Sanction complete- Final Sanction';
        

        SME_Email_Handler.getEmailTemplates('kunduniladri901@gmail.com', 'TestBody');
        // SME_Email_Handler.getESignPartiallyCompleted_Individuals(app);
        //SME_Email_Handler.getRenewalDueTemplates(app);
        SME_Email_Handler.getRenewalApplicationSubmissionPending(newApp);
        SME_Email_Handler.getLoanUnderProcessing(app);
        SME_Email_Handler.getESignPartiallyCompleted_Individuals(app);
    }
}