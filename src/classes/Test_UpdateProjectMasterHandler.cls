@isTest
public class Test_UpdateProjectMasterHandler {
@isTest
    public static void method1(){
        Project_Master__c ob=new Project_Master__c();
        ob.Project_Code__c='12345';
        insert ob;
        Flat_Master__c fm=new Flat_Master__c();
        fm.Project_Code__c='12345';
        insert fm;
        List<Flat_Master__c> flatlist=new List<Flat_Master__c>();
        flatlist.add(fm);
        set<string> code=new set<string>();
        code.add('12345');
        UpdateProjectMasterHandler.callProjectMaster(flatlist, code);
        
    }
}