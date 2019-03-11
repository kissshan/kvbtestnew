public class Batch_eStamp_B1_DocGeneration implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts{
    String query    = '';
    string applId   = '';
    Integer count = 0;
    
    public Batch_eStamp_B1_DocGeneration(string appId){
        this.applId = appId;
    }
   public Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('applId::'+applId);
        query = 'SELECT id,Name,SurveyKhasraKhataPatta_No__c,Collateral_Type__c,genesis__Application__r.Legal_desk_state_flag__c,EM_Charge_type__c,Nature_of_Property__c,PlotDoorShopBungalow_No__c,Buildup_Area__c,ExtentCarpet_area_Built_up_area__c,Floor_No__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,State__c,Property_Pincode__c,Total_Market_value__c,clcommon__City__c,clcommon__Postal_Code__c,genesis__Application__c,Building_Name__c,Valuation_Date__c FROM clcommon__Collateral__c WHERE Active__c = true AND genesis__Application__c = :applId';
        system.debug('query:-'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<clcommon__Collateral__c> records) {
        try{
            System.debug('records:::'+records);
            for(clcommon__Collateral__c cl :records){
                if(cl.genesis__Application__r.Legal_desk_state_flag__c == true){
                    DigioDocGenerationHL.CallDocuments(applId,Constants.LAPMOD,records);
                }else{
                    LAP_Digio_Service_B1.digioDocGen(applId,Constants.LAP_B1_B2DOC,records);//prashant singh change done on 30/10/2018 LAP_B1_Sign-->Constants.LAP_B1_B2DOC
                }
            }
          count++;
        }catch(Exception e){
            HandleBusinessException.captureError('Batch_eStamp_B1_DocGeneration','execute', e);
        }
    }
    public void finish(Database.BatchableContext BC) {       
        System.debug('count=='+count);
    }
}