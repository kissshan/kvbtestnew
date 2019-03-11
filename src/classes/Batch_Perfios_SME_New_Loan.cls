/*
* Name          : Batch_Perfios_SME_New_Loan
* Description   : Batch class for WS_Perfios_New_SME_Response. 
* Author        : Raushan Abhishek
*/
public class Batch_Perfios_SME_New_Loan implements Database.Batchable<sObject>,Database.Stateful, Database.AllowsCallouts {
   
    Set<Id> setAppId		=	new Set<Id>();
   	Map<String,String> mapOfAppId	= 	new Map<String,String>();
	public String whereCondition = '';
    public Batch_Perfios_SME_New_Loan(String whereCondn){
			whereCondition = whereCondn;
	}
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String RecordTypeName = 'SME_New_Loan_Perfios';
        List<String> status = new List<String>{'Perfios Pending Process','Initiated'};
		if(whereCondition == '' || whereCondition == null){
			whereCondition = 'Perfios_Status__c IN :status AND RecordType.DeveloperName =:RecordTypeName AND Transaction_Id__c != null';
		    system.debug('whereCondition==='+whereCondition);
        }
        String query = 'Select id,Application__c,Transaction_Id__c,Perfios_Status__c,Entity_Id__c,RecordType.DeveloperName from Perfios__c where ' +whereCondition ;
      	system.debug('Cons whereCondition==='+whereCondition);
        system.debug('query====> '+query);
        return Database.getQueryLocator(query);  
    }
    public void execute(Database.BatchableContext BC, List<Perfios__c> records) {
        Boolean isPerfiosError = false;
        Id appId;
        for(Perfios__c perfiosObj : records){
            If(perfiosObj !=null){
                If(perfiosObj.Transaction_Id__c !=null && perfiosObj.Application__c !=null)	{
                    isPerfiosError = WS_Perfios_Get_Operational_Data.sendRequest(perfiosObj.Transaction_Id__c, perfiosObj.Application__c,perfiosObj.id);
                    If(isPerfiosError){
                        setAppId.add(perfiosObj.Application__c);
                    }else{
						mapOfAppId.put(perfiosObj.Application__c, perfiosObj.Application__c);
					}
                }    
            }    
        } 
       
    } 
    public void finish(Database.BatchableContext BC) {
        List<genesis__Applications__c> listOfApplication = new List<genesis__Applications__c>();
        Set<String> setOfSring = new Set<String>();
        If(setAppId !=null && setAppId.size() > 0){
            try{
                   for(Id ids	: setAppId){
                   		genesis__Applications__c appObj	=	new genesis__Applications__c();
                   		appObj.Id	=	ids;
                   		setOfSring.add(ids);     
                   		appObj.Application_Stage__c		= 'New loans - Application created';
                   		appObj.Sub_Stage__c				= 'Re-upload bank statements';
                        appObj.Application_UI_Stage__c	= 'NewLoanDetails';
                   		listOfApplication.add(appObj); 
                	}
                If(listOfApplication !=null && listOfApplication.size() > 0){
                    try{
                        If(setOfSring !=null && setOfSring.size() > 0){
                            SME_SendSMSService.sendSMSApp_SME(setOfSring);    
                        }
                    }catch(Exception ex){
                        System.debug('Exception ::'+ ex.getMessage() +'Line no'+ ex.getLineNumber());
                    }
                    ApplicationTriggerHandler.IsFirstRun = false; 
                    update  listOfApplication;
                }
            }catch(Exception ex){
                System.debug('Exception'+ex.getStackTraceString());
                
            }
        }
		if(mapOfAppId.size() > 0 ){
			for(String ids     : mapOfAppId.values()){
				if(ids != null){
					Underwriting_CTRL_Helper.closeExistingTask(ids,'Financial Upload');		
				}	
			}
			
		}
        
    }
}