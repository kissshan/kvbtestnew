/*
* @purpose : Call Cibil for individual customers
* @author  : Amritesh
*/ 
public class Person_CIBIL_Call implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts{
    public CibilResponse cibilRes;
    public List<genesis__Application_Parties__c> parties;
    List<genesis__Applications__c> applicationList;
    public String whereCondition                            = '';
    public Set<String> personAccIds                                 = new Set<String>();
    public List<genesis__Application_Parties__c> partyList  = new List<genesis__Application_Parties__c>();
    public Person_CIBIL_Call(String condition){
        whereCondition = condition;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('whereCondition::'+whereCondition);
        String stage        ='Identified for renewal';
        List<String> listRecordTypeName = new List<String>();
        String cibilStatus  = 'Complete';
        //String stageToExclude     = 'Greater than 1Cr.';
        Integer days        = Utility.getExecuteBatch();
        if(whereCondition == ''){
            If(System.Label.APPLICATION_RECORDTYPE_NAME != null){
                for(String str : (System.Label.APPLICATION_RECORDTYPE_NAME).split(',')){
                    listRecordTypeName.add('\''+str+'\'');
                }
                whereCondition = 'Application_Stage__c =:stage AND Active__c = true AND Execute_batch_in_days__c <=:days AND Recordtype.DeveloperName  IN '+listRecordTypeName;
            }
        }
        
        
        String applQuery = 'SELECT id,BRE_Done__c,Recordtype.DeveloperName,(Select id,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CIBIL_Status__pc from genesis__Application_Parties__r where genesis__Party_Account_Name__c!=null AND Active__c = true ) from genesis__Applications__c WHERE '+whereCondition;
        System.debug('applQuery::'+applQuery);
        applicationList = Database.query(applQuery);
        if(!applicationList.isEmpty()){
            for(genesis__Applications__c genAplObj : applicationList){
                if(genAplObj.genesis__Application_Parties__r != null){
                    partyList.addAll(genAplObj.genesis__Application_Parties__r);
                }
            } 
        }
        if(!partyList.isEmpty()){
            for(genesis__Application_Parties__c partyRec :partyList){
                personAccIds.add(partyRec.genesis__Party_Account_Name__c);
            }
        }
        String accountQuery = 'Select id,FirstName,name,LastName,MiddleName,Gender__pc,PersonBirthdate,Aadhaar_Number__pc,Pan_Number__c,PersonMobilePhone,'+
            +'PersonMailingStreet,PersonMailingCity,Full_Name__c,PersonMailingPostalCode,PersonMailingState from Account where Id IN :personAccIds AND CIBIL_Status__pc != \'Complete\' AND RecordType.DeveloperName = \'PersonAccount\'';
        return Database.getQueryLocator(accountQuery);   
    }
    public void execute(Database.BatchableContext BC, List<Account> records) {
        try{
            CibilRequestTU_HL cibilReq  = WS_CibilServiceTU_HL.prepareRequest(records[0], Constants.CIBIL);
            cibilRes = new CibilResponse();
            if(cibilReq != null){
                CibilResponseTU_HL  tuReq   = WS_CibilServiceTU_HL.callCibil(cibilReq);
                if(tuReq != null){
                    cibilRes = CibilTUService.getcibildetails(tuReq, Constants.HL_CibilRecordType);
                    if(cibilRes == null || cibilRes.Result==false){
                        changeCIBILStatus(records[0].id);  
                    }
                }else{
                    changeCIBILStatus(records[0].id);  
                }
            }else{
                changeCIBILStatus(records[0].id);  
            }
        }catch(Exception e){
            system.debug('Person CIBIL Call Failed::'+e.getMessage()+':::'+e.getStackTraceString());
            changeCIBILStatus(records[0].id);
        }     
    }
    
    public void changeCIBILStatus(Id accRecId){
        Account accRec = new Account();
        accRec.id = accRecId;
        accRec.CIBIL_Status__pc = 'Error';
        accRec.TU_Trigger_Time__c = System.now();
        if(CibilTUService.INVALID_REQUEST_MSG != null) accRec.CIBIL_Error_Reason__pc = CibilTUService.INVALID_REQUEST_MSG;
        AccountTriggerHandler.isAccountTrigger = true;
        update accRec;
    }
    public void finish(Database.BatchableContext BC) {
        if(applicationList !=null && !applicationList.isEmpty()){
            if(applicationList[0].Recordtype.DeveloperName == 'SME_NEW_Loan' && !applicationList[0].BRE_Done__c){
                SME_BRE_Score_Calculator.runBRERule(applicationList[0],false);    
            }    
        }    
    }
}