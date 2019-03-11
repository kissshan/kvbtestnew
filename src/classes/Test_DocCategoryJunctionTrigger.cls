@isTest
public class Test_DocCategoryJunctionTrigger {
@isTest

    public static void method1(){
        genesis__Applications__c app=TestUtility.intialSetUp('Test',true) ;
        genesis__Application_Document_Category__c docobj=new genesis__Application_Document_Category__c();
        docobj.genesis__Application__c=app.id;
        insert docobj;
        genesis__AppDocCatAttachmentJunction__c obj=new genesis__AppDocCatAttachmentJunction__c();
        obj.genesis__Application_Document_Category__c=docobj.id;
        insert obj;
    }
}