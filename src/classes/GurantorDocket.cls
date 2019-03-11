/*
* Name          : GurantorDocket
* Description   : Call the GurantorDocket 
* Author        : Venu
*/
public class GurantorDocket {
   
    public static void callDocket(list<genesis__Applications__c> Applist,Map<Id,genesis__Applications__c> oldApp){
      system.debug('Start');
      //  list<genesis__Applications__c> APlist=[select id,Sub_Stage__c,Borrowers_Esign__c from genesis__Applications__c where ID IN:Trigger.newMap.keySet()  limit 10];
      
        for(genesis__Applications__c App: Applist){
            
            genesis__Applications__c oldPlan = oldApp.get(App.Id);
            if(oldPlan.Borrowers_Esign__c==False){
                 
            if(App.Borrowers_Esign__c==True){
                CallDocketGurantor(App.Id);
               
            }
            }
             }
}
    @future(callout=true)
    
    public static void CallDocketGurantor( string APPId){
        
         Docket_ESign_Service.uploadDocketForCoBrwr(APPId, Constants.Gurantor);
                 
    }
}