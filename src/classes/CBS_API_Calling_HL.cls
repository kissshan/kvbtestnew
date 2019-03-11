/*
* Name      : CBS_API_Calling_HL
* Compnay   : ET Marlabs
* Purpose   : Call CBS API in Sequence  
* Author    : Subas
*******************************************************************
* Modification : CBS_001 Add code for success response of all Single CBS APIs.
* Developer : Ashok 
*/
public class CBS_API_Calling_HL { 
    public static Boolean runCBS_LogTrigger = true;
    public static void call_CBS_API(String AppId){
        try{
            if(!String.isBlank(AppId)){
                WS_CBS_Dedupe.callDedupe(AppId);
            } 
        }Catch(Exception e){}
    }
    public static void call_CBS_log(List<CBS_API_Log__c > logList){
        List<ID> EkycAccSuccess = new List<ID>();
        List<ID> EkycAccFailure = new List<ID>();
        List<ID> CustAccSuccess = new List<ID>();
        List<ID> CustAccFailure = new List<ID>();
        List<ID> fileUpSuccess = new List<ID>();
        List<ID> fileUpFail = new List<ID>();
        List<Id> ODTODSuccess = new List<Id>();
        Boolean ODTODFailureFlag = false;
        String AppId = '';
        String recordType = '';
        list<genesis__Applications__c> ApList=[select id,Sub_Type__c,(select id,Valuation_Applicable__c from genesis__Collaterals__r) from genesis__Applications__c where id=:logList[0].Application__c];
        for(CBS_API_Log__c log : logList){
            if((log.Sequence_No__c =='6' || log.Sequence_No__c =='6.1' || log.Sequence_No__c =='6.2') && log.Status__c=='Failure'){ 
                //call colletral creation
                //WS_CBS_Collateral_Creation.Collateral_Creation(log.Application__c);
            }
             if(log.Sequence_No__c =='6.1'  && log.Status__c=='Success' && ApList!=null && ApList[0].Sub_Type__c==Constants.Sub_Type_Top_Up){ 
                
                WS_CBS_Collateral_Creation.Collateral_CreationF(log.Application__c,null,null);
            }
            if(log.Sequence_No__c =='6.2'  && log.Status__c=='Success' && ApList!=null && ApList[0].Sub_Type__c==Constants.Sub_Type_Top_Up){ 
               
                 WS_CBS_Collateral_Linkage_HL.linkCollateralF(log.Application__c,null);
            }
            if(log.Sequence_No__c =='6' && log.Status__c=='Success'){
                  WS_CBS_Collateral_Linkage_HL.linkCollateralF(log.Application__c,null);
            }
            if(log.Sequence_No__c =='7' && log.Status__c=='Failure'){
                //call colletral linkage
                //WS_CBS_Collateral_Linkage_HL.linkCollateral(log.Application__c);
            }if(log.Sequence_No__c =='7' && log.Status__c=='Success'){
                //Call cbr file updation
                WS_CBS_CBR_DTLS_HL.CBR_DTLSF(log.Application__c);
                
            }if(log.Sequence_No__c =='2' && log.Status__c=='Success'){
                //call Customer ID creation                
                EkycAccSuccess.add(log.Application__c);
                AppId = log.Application__c;
                recordType = log.RecordType__c;
                
            }if(log.Sequence_No__c =='2' && log.Status__c=='Failure'){
                //call EKYC manually 
                EkycAccFailure.add(log.Applicant__c);
                if(log.Success_Error_Code__c =='CI1005' || log.Success_Error_Message__c == 'Invalid Customer ID or IC Combination'){
                    System.debug('log >>> ' + log);
                    WS_CBS_CreateCustIC.cbs_CreateCustIC(log.Application__c,log.Applicant__c); //// CBS_001
                }
                
            }if(log.Sequence_No__c =='3' && log.Status__c=='Success'){
                //Call Loan Creation
                CustAccSuccess.add(log.Applicant__c);
                AppId = log.Application__c;
                recordType = log.RecordType__c;
            }if(log.Sequence_No__c =='3' && log.Status__c=='Failure'){
                //Call cust Id manually
                CustAccFailure.add(log.Applicant__c);
            }
            if(log.Sequence_No__c =='11' && log.Status__c=='Success'){
                fileUpSuccess.add(log.Applicant__c);
                AppId = log.Application__c ;
                recordType = log.RecordType__c;
            }
            if(log.Sequence_No__c =='11' && log.Status__c=='Failure'){
                fileUpFail.add(log.Applicant__c);
            }
            if(log.Sequence_No__c =='12' && log.Status__c !='Failure'){
                //OD/TOD modification    
                ODTODFailureFlag = true;
                ODTODSuccess.add(log.Applicant__c);            
                AppId = log.Application__c;
                recordType = log.RecordType__c;
            }
            if(log.Sequence_No__c == '15' && log.Status__c == 'Success'){
                if((log.Application_Record_Type__c == 'SME AdHoc' || log.Application_Record_Type__c == 'SME Enhancement' || log.Application_Record_Type__c == 'SME Renewal') && log.API_Name__c == 'Loan_Collateral_Creation_HL')
                    SME_CBS_EAE.limitUpdation(log.Application__c,false);
            }
            if(log.Sequence_No__c == '16' && log.Status__c == 'Success'){
                if(log.Application_Record_Type__c == 'SME NEW Loan' && log.API_Name__c == 'Loan_Collateral_Creation_HL')
                    SME_CBS_EAE.limitUpdation(log.Application__c,false);
            }
        } 
        if(ODTODFailureFlag  && ODTODSuccess.size() > 0){
            //call customer Id Creation
            if(recordType == 'SME Renewal'){
                //ApplicationTriggerHelper.ODTOD_CallHandler(ODTODSuccess); //OD/TOD modifiaction for SME
            }
            
            
        }
        if(EkycAccFailure.size() == 0 && EkycAccSuccess.size() > 0){
            //added for third party
            genesis__Applications__c app = new genesis__Applications__c();
            app = [SELECT genesis__CL_Product_Name__c FROM genesis__Applications__c WHERE Id=:AppId];
            //call customer Id Creation
            if(recordType == 'SME Renewal'){
                SME_CBS_Handler.customerIdCreation(EkycAccSuccess); //Customer ID creation for SME
            }else if(recordType == Constants.PERSONALLOAN && !app.genesis__CL_Product_Name__c.contains('Co-Lending')){ // Personal loan 
                //Call Loan Creation for PL
                  Ws_CBS_CustdetailsModification.CBS_CustmodificationrequestF(AppId,null);  // No Ekyc for PL
            }
            else{
                WS_CBS_Create_CustID.getCBSIDF(AppId); //Customer ID creation for HL
            }            
        }
        if(CustAccFailure.size() == 0 && CustAccSuccess.size() > 0){
            if(recordType == 'SME Renewal'){
                SME_CBS_Handler.customerLinkage(CustAccSuccess);   //Customer Linkage SME 
            }else{
                //Call Loan Creation HL
                  Ws_CBS_CustdetailsModification.CBS_CustmodificationrequestF(AppId,null); 
            }
        }    
        if(fileUpFail.size() == 0 && fileUpSuccess.size()>0){
            
            genesis__Applications__c application = queryService.getApp(AppId);
            if(application.Record_Type_Name__c == 'Personal Loan'){
                WS_CBS_HOST_Disbursment_HL.Host_request(AppId,null);                
            }
            else if(system.today() >= application.genesis__Disbursement_Date__c){
                WS_CBS_HOST_Disbursment_HL.Host_request(AppId,null);                
            }            
            
          /*  if(recordType == Constants.PERSONALLOAN){ 
                    system.debug('************* Photo upload ---> '+AppId);
                    WS_CBS_Loan_Disbursment_HL.callDisb(AppId); 
                }else{
                    // For HL logic 
                    genesis__Applications__c app = new genesis__Applications__c();
                    app.Id = AppId;
                    app.Retry_CBS__c = True;
                    update app;
                } */
        }
    }
    public static void initiateDisbursment(List<genesis__Applications__c> appList, Map<Id,genesis__Applications__c> oldList){
        //Initiate_Disbursement__c
        for(genesis__Applications__c app : appList){ 
            if(oldList.get(app.Id).Initiate_Disbursement__c <> app.Initiate_Disbursement__c && app.Initiate_Disbursement__c == True){          
                system.debug('*************'+app.Id);
                WS_CBS_Dedupe.callDedupe(app.Id);
                //WS_CBS_HOST_Disbursment_HL.Host_request(app.Id); 
                //WS_CBS_Loan_Disbursment_HL.callDisb(app.Id);                
            }
            System.debug('test 1234');
            //vl col update
             if(oldList.get(app.Id).Sub_Stage__c <> app.Sub_Stage__c && app.Sub_Stage__c =='Collaterals details captured' && (app.Record_Type_Name__c=='VL4W' || app.Record_Type_Name__c=='VL2W') ){
                 Ws_CBS_collateral_updateAPI.Collateral_Update(app.id,null);
             }
        }
    }
}