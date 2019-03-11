public class UpdateProjectMasterHandler {
    
    public static void callProjectMaster(list<Flat_Master__c> flist,set<string> pCode){
         
       map<string,id> ProjectMap=new map<string,id>();
        try{
        list<Project_Master__c> Pmaster=[select project_code__c from Project_Master__c where project_code__c IN:pcode];
      
       
        for(Project_Master__c projMas:Pmaster){
            ProjectMap.put(projMas.Project_Code__c, projMas.Id);
        }
        
        
        for(Flat_Master__c fm:flist){
        if(ProjectMap.containsKey(fm.Project_Code__c)){
            	 fm.ProjectCode__c=ProjectMap.get(fm.Project_Code__c);
            } 
        }
        }
        catch (exception e){
               system.debug('Exception in Update flatMaster'+e.getMessage()+' Stack '+e.getStackTraceString());
        }
    }

}