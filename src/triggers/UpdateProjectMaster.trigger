trigger UpdateProjectMaster on Flat_Master__c (before insert,before update) {
  
    set<string>  pCode= new set<string>();
    for(Flat_Master__c fMaster:Trigger.new){
        if(fMaster.Project_Code__c!=null){
            pCode.add(fMaster.Project_Code__c);
          }
    }
    if(pCode.size()>0  ){
        UpdateProjectMasterHandler.callProjectMaster(Trigger.new,pCode);
    }
   
}