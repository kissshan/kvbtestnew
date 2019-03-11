/*
* Name          : PerfiosErrorLog_MW
* Description   : Prepares structure of perfios transaction error
* Author        : Dushyant
*/
public class PerfiosErrorLog_MW{
    
    public static String getErrorLog(){
        List<reqStructure> reqStrcList = new List<reqStructure>();
        List<Perfios_Error__c> appList = new List<Perfios_Error__c>();
        List<Account> accList = new List<Account>();
        List<Id> accIdList = new List<Id>();
        
        //fetch application list with perfios error stage
        for(genesis__Applications__c app : [SELECT genesis__Account__c FROM genesis__Applications__c WHERE Application_Stage__c = :Constants.APP_STAGE_PERFIOS_ERROR]){
            accIdList.add(app.genesis__Account__c);
        }
        //prepare the structure
        if(!accIdList.isEmpty()){
            for(Perfios_Error__c pError : [SELECT Transaction_Id__c,Perfios__r.Applicant_Name__r.CBS_Customer_ID__c FROM Perfios_Error__c WHERE Perfios__r.Applicant_Name__c IN :accIdList]){
                reqStrcList.add(new reqStructure(pError.Perfios__r.Applicant_Name__r.CBS_Customer_ID__c,pError.Transaction_Id__c));
            }
        }
        if(!reqStrcList.isEmpty()){
            RETURN JSON.serialize(reqStrcList);
        }
        else
            RETURN null;
    }
    //Wrapper class
    public class reqStructure{
        public String CUST_ID;
        public String TRANSACTION_ID;
        public reqStructure(){}
        public reqStructure(String CUST_ID,String TRANSACTION_ID){
            this.CUST_ID = CUST_ID;
            this.TRANSACTION_ID = TRANSACTION_ID;
        }
    }
}