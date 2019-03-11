public class changeAppStageAfterCommRec {
    public static void changeApplicationStageAfterCommRecord(string appId){
       
        integer approvalCount = 0;
        genesis__Applications__c genAppObj = new genesis__Applications__c();
        list<task> lstTaskObj;
        
        if(appId != null && appId!= ''){
            lstTaskObj = [SELECT Application_Previous_Stage__c,Application_Stage__c,
                          Approval_Status__c,Status,Subject,Type,WhatId FROM Task 
                          where Type = 'Deviation Approval' AND WhatId =: appId];
        }
         try{
             if(genAppObj.Application_Stage__c == 'Application deviation pending'){
            if(lstTaskObj != null){
                for(task taskRec : lstTaskObj){
                    if(taskRec.Approval_Status__c == 'Rejected'){
                        genAppObj.Application_Stage__c = 'Enhancement-Application Submitted';
                        break;
                    }
                    else if(taskRec.Approval_Status__c =='Approved'){
                        approvalCount++;
                    }
                }
            }
            
            if(approvalCount == lstTaskObj.size()){
                genAppObj.Application_Stage__c = 'Enhancement-Final sanction offered';
            }
        }
        }
        catch(exception e){
             System.debug('Exception '+e.getMessage()+'occured at line number '+e.getLineNumber());
        }
       
    }
}