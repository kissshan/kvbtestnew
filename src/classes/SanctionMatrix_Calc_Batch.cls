/*
 * @name        : SanctionMatrix_Calc_Batch
 * @description : Batch class for application sanction authority calculation
 * @author      : Amriteshh
 */
public class SanctionMatrix_Calc_Batch implements Database.Batchable<sObject>{

    private String applnId;

    public SanctionMatrix_Calc_Batch(String appId) {
        applnId = appId;
    }

    public static set<string> APP_STAGES    = new set<string>{'Identified for renewal'};
    public Database.QueryLocator start(Database.BatchableContext BC){

        string query    = 'Select id,Product_Category__c,CL_Product__r.Facility_Category__c,Application__r.Type__c,Application__r.Is_Take_Over__c,Application__r.New_to_Business__c,Name,Application__c,Application__r.Parent_Application__c,Application__r.RecordType.DeveloperName,Application__r.ownerId,Application__r.Application_Stage__c,Limit_Amount__c,Existing_Limit__c,Type__c,Application__r.genesis__Account__c,CL_Product__c,Existing_Rate__c,Existing_Processing_Charge__c,Approved_Margin__c,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,Recommended_Limit__c,Recommended_Rate__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c'+', (select id,genesis__Collateral__c from Facility_Security__r) ';
        if(applnId != null){
            query           += ' from Facility__c where Active__c = true AND Application__c =:applnId'; // Added only for testing.Remove after testing.
        }else{
            query         += ' from Facility__c where Active__c = true AND Application__c !=null AND Application__r.Application_Stage__c IN:APP_STAGES';
        }

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Facility__c> records) {
        try{
            Set<Id> appIdSet = new Set<Id>();
            //Delete existing authority
            for(Facility__c fac : records){
                appIdSet.add(fac.Application__c);
            }
            List<Facility__c> childFacilityList = new List<Facility__c>();
            if(!appIdSet.iseMpty()){
                childFacilityList = [SELECT Id FROM Facility__c WHERE facility__r.Application__c IN : appIdSet AND RecordType.DeveloperName = 'Child'];
            }
            if(!childFacilityList.isEmpty()){
                DELETE childFacilityList;
            }
            //Create authority
            SanctionMatrix_Calculation  sObj    = new SanctionMatrix_Calculation();
            sObj.calculateAuthority(records,true,null,null);
        }catch(Exception e){}
    }

    public void finish(Database.BatchableContext BC) {
    }
}