/*
* Name          : SME_MCLR_Batch
* Description   : Populate MCLR value on Facility
* Author        : Dushyant
*/
global class SME_MCLR_Batch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String recTypeDevName = Constants.SME_APP_RECORD_TYPE;
        String parentRecType  = Constants.FACILITY_PARENT_RECORD_TYPE;
        List<String> appStageToExclude = new List<String>{'Greater than 2Cr.','Interim sanction offered','Final Sanction Offered','E-sign pending','E-sign pending-final','Sanction complete','Sanction complete- Final Sanction','Limit extended','Limit renewed/Application close'};
        
        String query = 'SELECT Id,MCLR_Rate__c, Recommended_Rate__c,(SELECT Id,Recommended_Rate__c, MCLR_Rate__c, Read_Only_User__c, Deviation_Approver__c FROM Facilities__r WHERE Highest_Authority__c =  true) FROM Facility__c WHERE Application__r.recordType.DeveloperName =: recTypeDevName AND Active__c = true AND recordType.DeveloperName =:parentRecType AND Application__r.Application_Stage__c NOT IN :appStageToExclude';
        //System.debug('query::'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Facility__c> facList){
        System.debug('facList.size()::'+facList.size());
        List<MCLR_Master__c> mclrList               = new List<MCLR_Master__c>();
        List<Facility__c> childFacListToUpdate      = new List<Facility__c>();
        Decimal rateDiff                            = 0.0;
        
        mclrList = [SELECT MCLR_Of_Interest__c FROM MCLR_Master__c WHERE COD_Term_From__c >= 365];
        //Updated by Ashik
        if(!mclrList.isEmpty()){
            for(Facility__c facility : facList){
                if(mclrList[0].MCLR_Of_Interest__c != null && facility.MCLR_Rate__c != null ){
                    rateDiff = mclrList[0].MCLR_Of_Interest__c - facility.MCLR_Rate__c;
                    if(rateDiff != 0.0){
                        facility.MCLR_Rate__c           = mclrList[0].MCLR_Of_Interest__c;
                        if(facility.Recommended_Rate__c != null){
                            facility.Recommended_Rate__c += rateDiff;
                            if(!facility.Facilities__r.isEmpty()){
                                for(Facility__c childFacRec : facility.Facilities__r){
                                    childFacRec.Recommended_Rate__c = facility.Recommended_Rate__c;
                                    childFacListToUpdate.add(childFacRec);
                                }
                            }
                        }
                    }
                } 
            }
        }
       
        if(!facList.isEmpty()) UPDATE facList;
        if(!childFacListToUpdate.isEmpty()) UPDATE childFacListToUpdate;
        
    }
    
    global void finish(Database.BatchableContext BC){}
}