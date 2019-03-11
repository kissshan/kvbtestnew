//uday kali--->87% coverage
@isTest
public class Test_DocumentFetch {
    
    @isTest
    public static void method1(){
    
    Account acc = new Account(Name = 'Test');
        Insert acc;
 
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Account__c = acc.Id;
        Insert genApp;
        
        genesis__Document_Category__c genDocCat = new genesis__Document_Category__c();
        genDocCat.Document_Category__c='TestCategory';
        genDocCat.genesis__Category_Name__c='Testname';
        genDocCat.Doc_Category_No__c =21;
        insert genDocCat;
        
        genesis__Document_Category__c genDocCat1 = new genesis__Document_Category__c();
        genDocCat1.Document_Category__c='TestCategoryies';
        genDocCat1.genesis__Category_Name__c='Testnames';
        genDocCat1.Doc_Category_No__c =20;
        genDocCat1.genesis__Parent_Document_Category__c =genDocCat.Id;
        insert genDocCat1;
        
       
        
            
        genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
        genAppDocCat.App_Doc_Category_No__c = 23;
        genAppDocCat.genesis__Document_Category__c =genDocCat.Id;
        genAppDocCat.genesis__Application__c =genApp.Id;
        genAppDocCat.Name ='TestDocument';
        
        insert  genAppDocCat;
        
        genesis__AppDocCatAttachmentJunction__c genAppAttJun = new genesis__AppDocCatAttachmentJunction__c();
        genAppAttJun.genesis__AttachmentId__c = 'Testname';
        insert genAppAttJun;
        
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=genAppAttJun.id;
        insert attach;
        
        
        Map<id,genesis__AppDocCatAttachmentJunction__c> genMap=new Map<id,genesis__AppDocCatAttachmentJunction__c>();
        //genMap.put(genAppDocCat.Id, genAppDocCat);
        
        
        DocumentFetch.getFinanceDetails(genAppAttJun.Id);
        DocumentFetch.FinanceSection finSec = new DocumentFetch.FinanceSection();
        DocumentFetch.checkDocumentCategory(genApp.Id,new List<String>{'TestCategory'});
        DocumentFetch.checkDocumentCategory2(genApp.Id,new List<String>{'TestCategory'}, new Set<String>{'2015-16'});
        DocumentFetch.deleteDocAndDocumentCategory(genMap);
        
    }
        @isTest
    public static void method2(){
    
    Account acc = new Account(Name = 'Test');
        Insert acc;
 
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Account__c = acc.Id;
        Insert genApp;
        
        genesis__Document_Category__c genDocCat = new genesis__Document_Category__c();
        genDocCat.Document_Category__c='TestCategory';
        genDocCat.genesis__Category_Name__c='Testname';
        genDocCat.Doc_Category_No__c =21;
        insert genDocCat;
        
        genesis__Document_Category__c genDocCat1 = new genesis__Document_Category__c();
        genDocCat1.Document_Category__c='TestCategoryies';
        genDocCat1.genesis__Category_Name__c='Testnames';
        genDocCat1.Doc_Category_No__c =20;
        genDocCat1.genesis__Parent_Document_Category__c =genDocCat.Id;
        insert genDocCat1;
        
       
        
            
        genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
        genAppDocCat.App_Doc_Category_No__c = 23;
        genAppDocCat.genesis__Document_Category__c =genDocCat.Id;
        //genAppDocCat.genesis__Application__c =genApp.Id;
        genAppDocCat.Name ='TestDocument';
        
        insert  genAppDocCat;
        
        genesis__AppDocCatAttachmentJunction__c genAppAttJun = new genesis__AppDocCatAttachmentJunction__c();
        genAppAttJun.genesis__AttachmentId__c = 'Testname';
        insert genAppAttJun;
        
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=genAppAttJun.id;
        insert attach;
        
        
        Map<id,genesis__AppDocCatAttachmentJunction__c> genMap=new Map<id,genesis__AppDocCatAttachmentJunction__c>();
        //genMap.put(genAppDocCat.Id, genAppDocCat);
        
        
        DocumentFetch.getFinanceDetails(genAppAttJun.Id);
        DocumentFetch.FinanceSection finSec = new DocumentFetch.FinanceSection();
        DocumentFetch.checkDocumentCategory(genApp.Id,new List<String>{'TestCategory'});
        DocumentFetch.checkDocumentCategory2(genApp.Id,new List<String>{'TestCategory'}, new Set<String>{'2015-16'});
        DocumentFetch.deleteDocAndDocumentCategory(genMap);
        
    }
    @isTest
    public static void method3(){
    
    Account acc = new Account(Name = 'Test');
        Insert acc;
 
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Account__c = acc.Id;
        Insert genApp;
        
        genesis__Document_Category__c genDocCat = new genesis__Document_Category__c();
        genDocCat.Document_Category__c='TestCategory';
        genDocCat.genesis__Category_Name__c='Testname';
        genDocCat.Doc_Category_No__c =21;
        insert genDocCat;
        
        genesis__Document_Category__c genDocCat1 = new genesis__Document_Category__c();
        genDocCat1.Document_Category__c='TestCategoryies';
        genDocCat1.genesis__Category_Name__c='Testnames';
        genDocCat1.Doc_Category_No__c =20;
        genDocCat1.genesis__Parent_Document_Category__c =genDocCat.Id;
        insert genDocCat1;
        
       
        
            
        genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
        genAppDocCat.App_Doc_Category_No__c = 23;
        genAppDocCat.genesis__Document_Category__c =genDocCat.Id;
        //genAppDocCat.genesis__Application__c =genApp.Id;
        genAppDocCat.Name ='TestDocument';
        
       // insert  genAppDocCat;
        
        genesis__AppDocCatAttachmentJunction__c genAppAttJun = new genesis__AppDocCatAttachmentJunction__c();
        genAppAttJun.genesis__AttachmentId__c = 'Testname';
        insert genAppAttJun;
        
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=genAppAttJun.id;
        insert attach;
        
        
        Map<id,genesis__AppDocCatAttachmentJunction__c> genMap=new Map<id,genesis__AppDocCatAttachmentJunction__c>();
        //genMap.put(genAppDocCat.Id, genAppDocCat);
        
        
        DocumentFetch.getFinanceDetails(genAppAttJun.Id);
        DocumentFetch.FinanceSection finSec = new DocumentFetch.FinanceSection();
        DocumentFetch.checkDocumentCategory(genApp.Id,new List<String>{'TestCategory'});
        DocumentFetch.checkDocumentCategory2(genApp.Id,new List<String>{'TestCategoryies'}, new Set<String>{'2015-16'});
        DocumentFetch.deleteDocAndDocumentCategory(genMap);
        
    }
    @isTest
    public static void method4(){
    
    Account acc = new Account(Name = 'Test');
        Insert acc;
 
        genesis__Applications__c genApp = new genesis__Applications__c();
        genApp.genesis__Account__c = acc.Id;
        Insert genApp;
        
        genesis__Document_Category__c genDocCat = new genesis__Document_Category__c();
        genDocCat.Document_Category__c='TestCategory';
        genDocCat.genesis__Category_Name__c='Testname';
        genDocCat.Doc_Category_No__c =21;
        insert genDocCat;
        
        genesis__Document_Category__c genDocCat1 = new genesis__Document_Category__c();
        genDocCat1.Document_Category__c='TestCategoryies';
        genDocCat1.genesis__Category_Name__c='Testnames';
        genDocCat1.Doc_Category_No__c =20;
        genDocCat1.genesis__Parent_Document_Category__c =genDocCat.Id;
        insert genDocCat1;
        
       
        
            
        genesis__Application_Document_Category__c genAppDocCat = new genesis__Application_Document_Category__c();
        genAppDocCat.App_Doc_Category_No__c = 23;
        genAppDocCat.genesis__Document_Category__c =genDocCat.Id;
        genAppDocCat.genesis__Application__c =genApp.Id;
        genAppDocCat.Name ='TestDocument';
        
       insert  genAppDocCat;
        
        genesis__AppDocCatAttachmentJunction__c genAppAttJun = new genesis__AppDocCatAttachmentJunction__c();
        genAppAttJun.genesis__AttachmentId__c = 'Testname';
        genAppAttJun.genesis__Application_Document_Category__c=genAppDocCat.id;
          insert genAppAttJun;
        
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=genAppAttJun.id;
        insert attach;
        
        
        Map<id,genesis__AppDocCatAttachmentJunction__c> genMap=new Map<id,genesis__AppDocCatAttachmentJunction__c>();
        genMap.put(genAppAttJun.Id, genAppAttJun);
        
        
        DocumentFetch.getFinanceDetails(genAppAttJun.Id);
        DocumentFetch.FinanceSection finSec = new DocumentFetch.FinanceSection();
        DocumentFetch.FinanceSection finSec1 = new DocumentFetch.FinanceSection('','','');
        DocumentFetch.checkDocumentCategory(genApp.Id,new List<String>{'TestCategory'});
        DocumentFetch.checkDocumentCategory2(genApp.Id,new List<String>{'TestCategoryies'}, new Set<String>{'2015-16'});
        DocumentFetch.deleteDocAndDocumentCategory(genMap);
        DocumentFetch.DocumentCategory doc=new DocumentFetch.DocumentCategory();
        DocumentFetch.DocumentCategory doc1=new DocumentFetch.DocumentCategory('','','');
    }
    }