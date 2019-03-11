/*
* Name    : CommercialPRErrorHandler
* Company  : ET Marlabs
* Purpose   : Handler class of CommercialPRErrorService . 
* Author  : Raushan
*/
public class CommercialPRErrorHandler {
    
    public static WS_CommercialPRError.Response getCommercialPRError(CommercialPRErrorService commPRErrorObj){
        WS_CommercialPRError.Response res = new WS_CommercialPRError.Response();
        try{        
            List<WS_CommercialPRError.insertedDataResponse>     insertedRes =  new List<WS_CommercialPRError.insertedDataResponse>();  
            List<WS_CommercialPRError.failedDataResponse>       failedRes   =  new List<WS_CommercialPRError.failedDataResponse>(); 
            List<CommercialPRErrorService.Out_msg>  listOutMsg  =  commPRErrorObj.out_msg;
            List<genesis__Applications__c> listAppUpdate  = new List<genesis__Applications__c>();
            Map<String,TU_Error__c> custIdResponseMap   =  new Map<String,TU_Error__c>();
            Map<String,String> custIdErrorMap           =  new Map<String,String>();
            Map<String,String> custIdAppIdMap           =  new Map<String,String>();
            
            If(listOutMsg !=null){
                for(CommercialPRErrorService.Out_msg  commPRErrObj  : listOutMsg){
                    If(commPRErrObj !=null){
                        TU_Error__c TuErrObj = new TU_Error__c();
                        If(!Utility.ISStringBlankorNull(commPRErrObj.Req_id))
                            TuErrObj.Request_Id__c =  commPRErrObj.Req_id;
                        If(!Utility.ISStringBlankorNull(commPRErrObj.ID))
                            TuErrObj.Error_Id__c =  commPRErrObj.ID;
                        If(!Utility.ISStringBlankorNull(commPRErrObj.Error))
                            TuErrObj.Error__c =  commPRErrObj.Error;
                        If(!Utility.ISStringBlankorNull(commPRErrObj.Error))
                            TuErrObj.Error__c =  commPRErrObj.Error;
                        If(!Utility.ISStringBlankorNull(commPRErrObj.Date_Processed))
                            TuErrObj.Date_Processed__c =  commPRErrObj.Date_Processed;
                        If(!Utility.ISStringBlankorNull(commPRErrObj.Member_Code))
                            TuErrObj.Member_Code__c =  commPRErrObj.Member_Code;
                        If(!Utility.ISStringBlankorNull(commPRErrObj.Refrence_Number)){
                            TuErrObj.Reference_Number__c =  commPRErrObj.Refrence_Number;
                            TuErrObj.Account__r = new Account(CBS_Customer_ID__c = commPRErrObj.Refrence_Number); 
                            
                            custIdErrorMap.put(commPRErrObj.Refrence_Number, commPRErrObj.Response);
                        }
                        If(!Utility.ISStringBlankorNull(commPRErrObj.Error_Description))
                            TuErrObj.Error_Description__c =  commPRErrObj.Error_Description;
                        
                        If(!Utility.ISStringBlankorNull(commPRErrObj.Ticket_id))
                            TuErrObj.Ticket_Id__c =  commPRErrObj.Ticket_id;
                        
                        If(!Utility.ISStringBlankorNull(commPRErrObj.Response))
                            TuErrObj.Response__c =  commPRErrObj.Response;     
                        
                        custIdResponseMap.put(commPRErrObj.Refrence_Number,TuErrObj);
                    }    
                }
                System.debug('custIdErrorMap:::'+custIdErrorMap);
                List<genesis__Applications__c> listApp = [select id,CustomerID__c,CommercialPR_Stage__c from genesis__Applications__c where (Active__c = true OR Application_Stage__c = 'Account Closed') AND CustomerID__c IN : custIdErrorMap.keySet() AND RecordType.DeveloperName = 'SME_Renewal'];
                System.debug('listApp.size:::'+listApp.size());
                for(genesis__Applications__c app : listApp){
                    custIdAppIdMap.put(app.CustomerID__c,app.Id);
                }
                
                for(String custId : custIdResponseMap.keySet()){
                    try{
                        System.debug('custId:::'+custId);
                        genesis__Applications__c app = new genesis__Applications__c();
                        INSERT custIdResponseMap.get(custId);
                        app.Id = custIdAppIdMap.get(custId);
                        if(custIdErrorMap.get(custId) == 'No-Hit') app.CommercialPR_Stage__c = 'Completed';
                        else app.CommercialPR_Stage__c = 'Error';
                        
                        listAppUpdate.add(app);
                        WS_CommercialPRError.insertedDataResponse successObj = new WS_CommercialPRError.insertedDataResponse();
                        successObj.cust_Id = custId;
                        successObj.sucess_message = 'TU data insert success';
                        insertedRes.add(successObj);
                    }
                    catch(Exception e){
                        WS_CommercialPRError.failedDataResponse errorObj = new WS_CommercialPRError.failedDataResponse();
                        errorObj.cust_Id = custId;
                        errorObj.error_reason = e.getMessage();
                        failedRes.add(errorObj);
                        
                        System.debug(e.getMessage());
                    }
                }
                
                ApplicationTriggerHandler.IsFirstRun=false;
                UPDATE listAppUpdate;
                
                if(insertedRes.size() > 0) {
                    res.success_Count = insertedRes.size();
                    res.Success_List = insertedRes;
                    
                }
                else
                    res.success_Count = 0;
                
                if(failedRes.size() > 0) {
                    res.failed_Count = failedRes.size();
                    res.Error_List = failedRes;
                    res.status          = Constants.WS_SUCCESS_STATUS;
                    res.statusCode      = Constants.WS_ERROR_CODE;
                }
                else
                    res.failed_Count = 0;
            }
            else{
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage    = 'Request Body is null';
                res.statusCode      = Constants.WS_ERROR_CODE;
                res.success_Count   = 0;
                res.failed_Count    = 0;
            }
        }
        catch(Exception ex){
            System.debug(ex.getMessage());
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = ex.getMessage();
            res.statusCode      = Constants.WS_ERROR_CODE;
        }
        RETURN res;
    }
}