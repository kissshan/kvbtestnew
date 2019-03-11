global class ProcesssingfeesFromCBS{


webService static String checkGlsndamountfromCBS(string appid,String taskType){
    String resultfromCBS='testt';
    Datetime taskcreationdate=null;
    String glnumber;
try{
List<genesis__Applications__c> lapp=SOQL_Util.getApplication(new Set<Id>{appId});
List<Task> getExistingTaskList= new List<Task>();
            List<User> coUserList= SOQL_Util.getBRCreditOfficer(appId);
            getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId,createddate FROM Task where WhatId=:appId And OwnerId =: lapp[0].OwnerId And Type=:taskType And Status = 'Not Started'];
            
            if(getExistingTaskList.size()==0 && coUserList.size()>0){
                getExistingTaskList = [SELECT Id,OwnerId,Status ,Type,WhatId,createddate FROM Task where WhatId=:appId And OwnerId =: coUserList[0].Id And Type=:taskType And Status = 'Not Started'];
            }

            if(! getExistingTaskList.isEmpty()){
               taskcreationdate=getExistingTaskList[0].createddate;
            }else{
            lapp[0].GL_Implemenation_Reference_Number__c='';
lapp[0].Processing_Fee_Result__c='Failure';
update lapp;
            return 'Task is not created yet';
            }



glnumber=String.valueOf(lapp[0].GL_Implemenation_Reference_Number__c );
resultfromCBS=calloutGLImplementationNumber.checGLNumberAndAmount(lapp[0].GL_Implemenation_Reference_Number__c,lapp[0].genesis__Fees_Amount__c,lapp[0].Branch_Code__c,taskcreationdate);



if(resultfromCBS =='Success'){
lapp[0].Processing_Fee_Result__c='Success';

update lapp;
}
else{

lapp[0].GL_Implemenation_Reference_Number__c='';
lapp[0].Processing_Fee_Result__c='Failure';
lapp[0].Processing_Charges__c=null;
update lapp;

}


}

catch(Exception ex){
HandleBusinessException.captureError('ProcesssingfeesFromCBS','checkGlsndamountfromCBS',ex);

}
return resultfromCBS;
}

global static void closeanyTask(String appid,String Subject,String type){
List<Task> lsttask=new List<Task>();
if(!(String.isBlank(appid)) && !(String.isBlank(Subject)) && !(String.isBlank(type)) && appid !=null){

List<Task> tasktobeclose=[SELECT Id,OwnerId,createddate,Status ,Type,WhatId FROM Task where WhatId=:appId And Type=:Subject and subject=:Subject];
For(Task tskrec:tasktobeclose){
 tskRec.Status= 'Completed';
 lsttask.add(tskrec);
}

}
update lsttask;

}

}