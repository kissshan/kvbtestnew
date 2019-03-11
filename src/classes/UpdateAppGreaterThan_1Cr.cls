/*
 * Name     : UpdateAppGreaterThan_1Cr--->UpdateAppGreaterThan_2Cr
 * Company  : ET Marlabs
 * Purpose  : To stage for application having limit greater than 2 Cr.
 * Author   : Dushyant
*/
public class UpdateAppGreaterThan_1Cr implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts {
    
    public String whereCondition   = '';
    public Set<String> custIdSet = new Set<String>();
    
    public UpdateAppGreaterThan_1Cr(String condition,Set<String> custIdSet){
        if(condition != null && condition != ''){
            whereCondition = ' WHERE ' +condition;
        }
        if(custIdSet != null && !custIdSet.isEmpty()){
            this.custIdSet = custIdSet;
            whereCondition += ' AND CustomerID__c IN:custIdSet';
        } 
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug(whereCondition);
        String applQuery = 'SELECT Id,Application_Stage__c,(SELECT Id,Existing_Limit__c FROM Facilities__r) FROM genesis__Applications__c'+whereCondition;
        System.debug('applQuery*******'+applQuery);
        return Database.getQueryLocator(applQuery);
    }
    
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> appList) {
        List<genesis__Applications__c> appToUpdate = new List<genesis__Applications__c>();
        for(genesis__Applications__c app: appList){
            System.debug('app.Facilities__r'+app.Facilities__r);
            if(!app.Facilities__r.isEmpty()){
                Decimal totalLimit = 0;
                for(Facility__c fac : app.Facilities__r){
                    if(fac.Existing_Limit__c != null) totalLimit += fac.Existing_Limit__c;
                }
                if(totalLimit > 20000000){
                    appToUpdate.add(new genesis__Applications__c(Id = app.Id,Application_Stage__c = 'Greater than 2Cr.'));
                }
            }
        }
        if(!appToUpdate.isEmpty()){
            ApplicationTriggerHandler.IsFirstRun = false;
            UPDATE appToUpdate;
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
}