@isTest
public class Test_DropDownHandler {

    @isTest
    public static void method1(){
        
       DropDownHandler ob=new DropDownHandler();
       DropDownHandler.getPicklistEntries('genesis__Application_Document_Category__c','genesis__Priority__c');
    }
}