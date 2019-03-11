/*
* Name          : ApplicationStageUpdateHandler
* Company       : ET Marlabs
* Purpose       : This class will be used to update main stage from substage for vehicle loan
* Author        : Braj Mohan
* Created Date  : 22-08-2018
*/
public class ApplicationStageUpdateHandler {

    //method to update mainstage depend on substage for Vehicle Loan
    public Static void updateApplicationStage(list<genesis__Applications__c> Applist){
        System.debug('Inside ApplicationStageUpdateHandler.updateApplicationStage');
        try{
            if(Applist.size()>0){
                List<genesis__Applications__c> ApplistToUpdate = new List<genesis__Applications__c>();
                Map<String,String> mapStageToSubStageVL = new  Map<String,String>();

                //Application main stage == 'Saved applications'
                mapStageToSubStageVL.put(Constants.APPLICATION_CREATED_SUBSTAGE.toUpperCase(),Constants.SAVED_APPLCIATION_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.VEHICLE_DETAILS_CAPTURED_SUBSTAGE.toUpperCase(),Constants.SAVED_APPLCIATION_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.PLE_APPROVED_SUBSTAGE.toUpperCase(),Constants.SAVED_APPLCIATION_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.WORK_INFORMATION_CAPTURED_SUBSTAGE.toUpperCase(),Constants.SAVED_APPLCIATION_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.LOAN_REQUIREMENT_CAPTURED_SUBSTAGE.toUpperCase(),Constants.SAVED_APPLCIATION_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.PERSONNAL_DETAILS_CAPTURED_SUBSTAGE.toUpperCase(),Constants.SAVED_APPLCIATION_MAINSTAGE);
                //mapStageToSubStageVL.put(Constants.PROCESSING_FEE_PAID_SUBSTAGE.toUpperCase(),Constants.SAVED_APPLCIATION_MAINSTAGE);//main stage changed to Disbursement applications//date:10-Sep-2018
                mapStageToSubStageVL.put(Constants.TERMS_AND_CONDITIONS_ACCESPT_SUBSTAGE.toUpperCase(),Constants.SAVED_APPLCIATION_MAINSTAGE);

                //Application main stage == 'Disbursement applications'
                mapStageToSubStageVL.put(Constants.PROCESSING_FEE_PAID_SUBSTAGE.toUpperCase(),Constants.DISBURSEMENT_APPLICATIONS_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.LOAN_SANCTIONED_STP_SUBSTAGE.toUpperCase(),Constants.DISBURSEMENT_APPLICATIONS_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.LOAN_SANCTIONED_NON_STP_SUBSTAGE.toUpperCase(),Constants.DISBURSEMENT_APPLICATIONS_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.DISBURSEMENT_INFO_CAPTURED_SUBSTAGE.toUpperCase(),Constants.DISBURSEMENT_APPLICATIONS_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.SI_DETAILS_CAPTURED_SUBSTAGE1.toUpperCase(),Constants.DISBURSEMENT_APPLICATIONS_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.DISBURSEMENT_DOCUMENTS_ESIGNED_SUBSTAGE.toUpperCase(),Constants.DISBURSEMENT_APPLICATIONS_MAINSTAGE);

                //Application main stage == 'Disbursed application'
                mapStageToSubStageVL.put(Constants.LOAN_ACCOUNT_OPENED_SUBSTAGE.toUpperCase(),Constants.DISBURSED_APPLICATION_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.APPLICATION_PROCESSED_CLOSED_SUBSTAGE.toUpperCase(),Constants.DISBURSED_APPLICATION_MAINSTAGE);

                //Application main stage == 'Application Rejected'
                mapStageToSubStageVL.put(Constants.LOW_CIBIL_SCORE_SUBSTAGE1.toUpperCase(),Constants.APPLICATION_REJECTED_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.AGE_INELIGIBLE_SUBSTAGE.toUpperCase(),Constants.APPLICATION_REJECTED_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.FI_REJECTED_SUBSTAGE.toUpperCase(),Constants.APPLICATION_REJECTED_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.REJECTED_BY_BRANCH_MANAGER_SUBSTAGE.toUpperCase(),Constants.APPLICATION_REJECTED_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.INCOME_ASSESMENT_REJECTED_SUBSTAGE.toUpperCase(),Constants.APPLICATION_REJECTED_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.INCOME_REJECTED_SUBSTAGE.toUpperCase(),Constants.APPLICATION_REJECTED_MAINSTAGE);
                mapStageToSubStageVL.put(Constants.LOW_APPLICATION_SCORE_SUBSTAGE.toUpperCase(),Constants.APPLICATION_REJECTED_MAINSTAGE);
                            
                for(genesis__Applications__c app:Applist){
                    if(app.Record_Type_Name__c == Constants.VL2W || app.Record_Type_Name__c == Constants.VL4W ){
                       if(mapStageToSubStageVL.containsKey(app.Sub_Stage__c.toUpperCase())){  
                            genesis__Applications__c appObj = new genesis__Applications__c(); 
                            appObj.Application_Stage__c = mapStageToSubStageVL.get(app.Sub_Stage__c.toUpperCase());
                            appObj.Id = app.Id;
                            ApplistToUpdate.add(appObj);
                        }
                    }
                }

                if(!ApplistToUpdate.isEmpty() && ApplistToUpdate.size()>0) {
                    System.debug(ApplistToUpdate.size()+'<--ApplistToUpdate==>'+ApplistToUpdate);
                    ApplicationTriggerHandler.IsFirstRun = false;
                    update ApplistToUpdate;
                }
            }
        }Catch(Exception e){
            System.debug('ApplicationStageUpdateHandler.updateApplicationStage==>'+e.getMessage());
            System.debug(e.getLineNumber());
        }
    }
}