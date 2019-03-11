/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*   Class      :  Batch_ApplicationDeactivate

*   Purpose  : Batch Class to Deactivate old Applications which not moved further from Processing fee pain sub stage (HL, LAP) 
                    and Terms and conditions sub stage (PL, VL).

*   Date       : 06/Dec/2018

*   Author    : Shubham Shukla
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
public class Batch_DeactivateAppOnSubStage implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts{
    String query    = '';
    string applId   = '';
    
    public Batch_DeactivateAppOnSubStage(string appId){
        this.applId = appId;
       // this.applId = 'a4V0l0000004Gg8';
    }
   public Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('applId::'+applId);
        query = 'SELECT id,genesis__Account__r.Name,Type__c,Created_Date__c,RecordType.developerName,Name,Record_Type_Name__c,Primary_Applicant__c,Sanction_Doc_Generation_Check__c,Sub_Stage__c,genesis__Account__c,Project_Code__c,Sourced_By__c,Loan_Purpose__c,Application_Stage__c,Product_Code__c FROM genesis__Applications__c WHERE Sub_Stage__c != \'Loan Account Opened\' AND Sub_Stage__c != \'MOD Initiated\' AND Application_Stage__c != \'Disbursed application\' AND Application_Stage__c != \'Application Rejected\' AND Application_Stage__c != \'Deactivated Applications\' AND (Product_Code__c = \'910\' OR Product_Code__c = \'776\' OR Product_Code__c = \'777\' OR Product_Code__c = \'775\' OR Product_Code__c = \'774\') AND Id =: applId';
      
      //  query = 'SELECT ParentId, OldValue, NewValue, Field, CreatedById, CreatedDate FROM genesis__Applications__History where parentId =: applId AND Field = \'Sub_Stage__c\' AND NewValue = \'Processing Fee Paid\'';
        System.debug('::::::::'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> records) {
        try{
            System.debug('!@#$%'+records);
            List<genesis__Applications__History> appHistoryList  = [SELECT ParentId, OldValue, NewValue, Field, CreatedById, CreatedDate FROM genesis__Applications__History where parentId =: applId AND Field = 'Sub_Stage__c']; 
            System.debug('!!!!!:::::'+appHistoryList);
            Map<Id,genesis__Applications__History> appHistoryMap = new Map<Id,genesis__Applications__History>();
            Map<Id,genesis__Applications__History> appHistMap = new Map<Id,genesis__Applications__History>();
            Map<Id,String> subStageMap = new Map<Id,String>();
            List<genesis__Applications__c> updateApplicationStage = new List<genesis__Applications__c>();
            //String subStage = 'Processing Fee Paid';
            String subStageTC = 'Terms and Conditions Accepted';
            DateTime timeRec;
            DateTime currDate;
            DateTime timeRec1;
            DateTime currDate1;
            Object newValueHist = '';
            for(genesis__Applications__History appHist : appHistoryList){
                    system.debug('=====>'+appHist.newvalue);
                  if(appHist.newvalue == subStageTC){
                        appHistMap.put(appHist.ParentId,appHist);
                    }
               
                    
            }
            System.debug('+++++::::'+appHistoryMap.values());

            for(genesis__Applications__c ap : records){
                if(ap.Application_Stage__c != 'Deactivated Applications'){
                    System.debug('^^^^^^^:::'+records);
                    if(appHistoryMap.size() > 0 || appHistMap.size() > 0){
                        System.debug('appHistoryMap.size()'+appHistoryMap.size());

                        if(appHistoryMap.containsKey(ap.Id)){
                            if((ap.Product_Code__c == '776' && (ap.Loan_Purpose__c == 'Purchase of Identified Property' || ap.Loan_Purpose__c == 'Purchase of land and construction there on')) || (ap.Product_Code__c == '777')){
                                system.debug('---------->'+appHistoryMap.get(ap.id).NewValue);
                                timeRec = appHistoryMap.get(ap.Id).CreatedDate;
                                currDate = System.now();
                                Long tm= currDate.getTime()-timeRec.getTime();
                                Decimal noOfdays = math.mod((((tm/1000)/60)/60)/24,365);
                                System.debug('$$$$:::'+timeRec);
                                if(noOfdays > 90){
                                    ap.Application_Stage__c = 'Deactivated Applications';
                                    ap.genesis__Terms_Selected__c = ap.Sub_Stage__c;
                                    ap.Sub_Stage__c               = 'Deactivated Applications';
                                    ap.genesis__Valid_Pricing_Flag__c = true;
                                }
                                updateApplicationStage.add(ap);
                            }
                        }else if(appHistMap.containsKey(ap.Id)){
                            if(ap.Product_Code__c == '774' || ap.Product_Code__c == '775' || ap.Product_Code__c == '910'){    
                                system.debug('---------->'+appHistMap.get(ap.id).NewValue);
                                timeRec1 = appHistMap.get(ap.Id).CreatedDate;
                                currDate1 = System.now();
                                Long tm1= currDate1.getTime()-timeRec1.getTime();
                                Decimal noOfdays1 = math.mod((((tm1/1000)/60)/60)/24,365);
                                System.debug('$$$$:::'+timeRec1);
                                System.debug('$$$$:::'+noOfdays1);
                                if(noOfdays1 > 90){
                                    System.debug('222222');
                                    ap.Application_Stage__c = 'Deactivated Applications';
                                    ap.genesis__Terms_Selected__c = ap.Sub_Stage__c;
                                    ap.Sub_Stage__c               = 'Deactivated Applications';
                                    ap.genesis__Valid_Pricing_Flag__c = true;
                                }
                                updateApplicationStage.add(ap);
                            }
                        }
                    }
                }
            }
            UPDATE updateApplicationStage;


        }catch(Exception ex){
            System.debug('ex'+ex);
            HandleBusinessException.captureError('Batch_DeactivateAppOnSubStage', 'execute', ex);
        }
        
    }
    public void finish(Database.BatchableContext BC) {       
        
    }
}