/*
 * @description: Batch class to call facility document generation class. 
 * 
 */ 
public class Batch_GenerateFacility_Doc implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts{
    String query    = '';
    string applId   = '';
    
    public Batch_GenerateFacility_Doc(string appId){
        this.applId = appId;
    }
   public Database.QueryLocator start(Database.BatchableContext BC) {
        query = 'SELECT id FROM Facility__c WHERE Active__c = true AND Application__c = :applId';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Facility__c> records) {
        try{
            if(records.size() > 0){
                Button_Utility.generateMOD_LeagalDocuments(applId,records[0].Id);  
            }
        }catch(Exception ex){}
        
    }
    public void finish(Database.BatchableContext BC) {       
        
    }
}