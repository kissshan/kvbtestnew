/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*   Class      :  Batch_ApplicationDeactivate

*   Purpose    : Batch Class to Deactivate old Applications which not moved further.

*   Date       : 06/Dec/2018

*   Author     : Shubham Shukla
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
public class Batch_ApplicationDeactivate implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts{
    
    public Batch_ApplicationDeactivate(){
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //String appStage = 'Deactivated Applications';String 
        String query = 'SELECT id,Loan_Purpose__c,genesis__Account__r.Name,Type__c,RecordType.developerName,Name,Created_Date__c,Record_Type_Name__c,Primary_Applicant__c,Sanction_Doc_Generation_Check__c,Sub_Stage__c,genesis__Account__c,Project_Code__c,Sourced_By__c,Application_Stage__c,Product_Code__c FROM genesis__Applications__c WHERE  Application_Stage__c = \'Saved Applications\' AND (Product_Code__c = \'910\' OR Product_Code__c = \'776\' OR Product_Code__c = \'777\' OR Product_Code__c = \'775\' OR Product_Code__c = \'774\')';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> records) {
        try{
            List<genesis__Applications__c> updateAppList = new List<genesis__Applications__c>();
            genesis__Applications__c appRecord ;
            for(genesis__Applications__c app : records){
                if(app.Application_Stage__c != 'Deactivated Applications' && app.Sub_Stage__c != 'Processing Fee Paid' && app.Sub_Stage__c != 'Terms and Conditions Accepted'){
                    Date startDate = app.Created_Date__c;
                    Date dueDate = System.today();
                    Integer daysBetween = startDate.daysBetween(dueDate);
                    if(daysBetween > 30){
                        appRecord = new genesis__Applications__c();
                        appRecord.Id = app.Id;
                        appRecord.genesis__Terms_Selected__c = app.Sub_Stage__c;
						appRecord.Application_Stage__c = 'Deactivated Applications';
                        appRecord.Sub_Stage__c               = 'Deactivated Applications';
                        appRecord.genesis__Valid_Pricing_Flag__c = true;
                        
                        updateAppList.add(appRecord);
                    }
                    
                }
            }
            UPDATE updateAppList;  
            deactivateApplication(records);
        }catch(Exception ex){
            System.debug('ex'+ex);
            HandleBusinessException.captureError('Batch_ApplicationDeactivate', 'execute', ex);
        }
    }
    
    public void deactivateApplication(List<genesis__Applications__c> appList){
        try{
            List<genesis__Applications__c> updateAppList = new List<genesis__Applications__c>();
            List<genesis__Applications__History> appHistoryList = new List<genesis__Applications__History>();
            genesis__Applications__c appRecord ;
            String subStageTC = 'Terms and Conditions Accepted';
            
            
            for(genesis__Applications__c app : appList){
                
                if(app.Application_Stage__c != 'Deactivated Applications' && app.Application_Stage__c != 'Disbursed application' && app.Application_Stage__c != 'Rejected application' && app.Sub_Stage__c  != 'Loan Account Opened' && app.Sub_Stage__c != 'MOD Initiated' )
                   
                    appHistoryList = [SELECT ParentId, OldValue, NewValue, Field, CreatedById, CreatedDate FROM genesis__Applications__History where parentId =: app.Id AND Field = 'Sub_Stage__c']; 
                   
                	for(genesis__Applications__History appHist : appHistoryList){
                       
                        if(appHist.NewValue == subStageTC && ((Date.valueOf(appHist.CreatedDate)).daysBetween(date.valueOf(System.today()))) >90){
                           
                            appRecord = new genesis__Applications__c();
                            appRecord.Id = app.Id;
                            
                            appRecord.genesis__Terms_Selected__c = app.Sub_Stage__c;
                            appRecord.Application_Stage__c = 'Deactivated Applications';
                            appRecord.Sub_Stage__c               = 'Deactivated Applications';

                            appRecord.genesis__Valid_Pricing_Flag__c = true;
                        
                            updateAppList.add(appRecord);
                        }
                    }
            }
            if(!updateAppList.isEmpty()){
                update updateAppList;
            }
                
        }catch(Exception e){
            
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
    
}