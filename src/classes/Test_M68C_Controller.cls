@isTest
public class Test_M68C_Controller {
    @isTest
    public static void method1(){
        genesis__Applications__c app=TestUtility.intialSetUp('TestHome',true);
        M68C_Controller ob=new M68C_Controller();
        ob.accName='TestName';
        ob.appId=app.id;
        ob.branchCode='2837872';
        ob.currentFY_DS='test';
        ob.estimatedFY_DS='testestimate';
        ob.prevFY_DS='testprev';
        ob.projectedFY_DS='testpro';
        
        Account acc=new Account(Name='TestName');
        insert acc;
        
        app.genesis__Account__c=acc.id;
        update app;
        
        
        
        PageReference pgRef = Page.M68C; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', acc.id);//Pass Id to page
        
        ob.onLoad();
    }
}