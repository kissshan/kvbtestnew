/*
* Name          : SME_BRE_Batch
* Description   : Run BRE
* Author        : Dushyant
*/
global class SME_BRE_Batch implements Database.Batchable<sObject>{
    String whereCondition = '';
    public SME_BRE_Batch(String whereCondition){
        this.whereCondition = whereCondition;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get('genesis__Applications__c' ).getDescribe().fields.getMap();
        
        String query = 'SELECT ';    
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+',';    
        }
        query += 'genesis__Account__r.Date_of_Incorporation__c,genesis__Account__r.CUSTSINCE__c,RecordType.developerName,(SELECT Id,genesis__Party_Account_Name__r.CIBIL_Status__pc,genesis__Party_Account_Name__r.CIBIL_Score__c FROM genesis__Application_Parties__r WHERE Active__c = true),(SELECT Id,Existing_Limit__c,Limit_Amount__c,Balance_Outstandings__c,Amount_Yet_disbursed__c FROM Facilities__r) FROM genesis__Applications__c';       
        if(whereCondition == '') query += ' WHERE Qualitative_input_done__c=true AND CommercialPR_Stage__c = \'Completed\' AND List_Matching_Stage__c = \'Completed\' AND Active__c = true AND ((RecordType.DeveloperName = \'SME_Renewal\' AND Application_Stage__c = \'Identified for renewal\') OR (RecordType.DeveloperName = \'SME_Enhancement\' AND Application_Stage__c = \'Enhancement- Application submitted\' AND BRE_Done__c !=true) OR (RecordType.DeveloperName = \'SME_Exceeding\' AND Application_Stage__c = \'Exceeding- Application submitted\' AND BRE_Done__c !=true) OR (RecordType.DeveloperName = \'SME_AdHoc\' AND Application_Stage__c = \'Adhoc- Application submitted\' AND BRE_Done__c !=true) OR (RecordType.DeveloperName = \'SME_NEW_Loan\' AND Application_Stage__c = \'New loans- Application submitted\' AND BRE_Done__c !=true))';
        else query += whereCondition;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<genesis__Applications__c> appList){
        Integer renewDuration;
        List<genesis__Applications__c> applicationList = new List<genesis__Applications__c>();
        for(genesis__Applications__c app : appList){
            renewDuration = System.today().daysBetween(app.Renewal_Due_Date__c);
            if(renewDuration <= 30 && app.genesis__Application_Parties__r.size() > 0){
                Integer partyCount = 0;
                for(genesis__Application_Parties__c party : app.genesis__Application_Parties__r){
                    if(party.genesis__Party_Account_Name__r.CIBIL_Status__pc == 'Complete' && party.genesis__Party_Account_Name__r.CIBIL_Score__c != null ){
                        partyCount += 1;
                    }
                }
                if(partyCount == app.genesis__Application_Parties__r.size())applicationList.add(app);
            }
        }
        
        if(!applicationList.isEmpty()){
            for(genesis__Applications__c app : applicationList ){
                try{
                    //Secound parameter to specify if its BRE first run
                    SME_BRE_Score_Calculator.runBRERule(app,true);    
                }
                catch(Exception e){}
            }
        }
    }
    global void finish(Database.BatchableContext BC){}
}