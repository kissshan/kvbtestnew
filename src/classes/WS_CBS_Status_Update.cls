/*
* Name    : WS_CBS_Status_Update 
* Company : ET Marlabs
* Purpose : This class is used to update CBS API details
* Author  : Subas
*/

@RestResource(urlMapping='/updateCBSstatus')
global class WS_CBS_Status_Update {
    
    global class Response extends WS_Response{
        
        public CBS_API_Log__c application;
        public Response(){
            application = new CBS_API_Log__c();            
        }
    }
    
    public cbsStatusReq cbsStatus;
    public class cbsStatusReq{
        public String ApplicationId;
        public String ApiName;
        public List<acctReqWrapper> CbsStatus;
    }
    public class acctReqWrapper {
        
        public String ApplicantId;        
        public String SequenceNo;
        public String Status;
        public string succErrCode;
        public string message;
        public string CustomerID;
    }
    @HttpPost
    global static Response getMandateFields(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();    
        Integer count = 0;
        String FailCustIDs = ''; // CBS005
        Boolean SuccessFlgs = True;
        String ErrorMsg,FailStatus,APIName,ErrCode,SuccessStatus;
        String AppID,SAccId,FAccId,SCustId,FCustId;
        List<genesis__Applications__c> appList =new List<genesis__Applications__c>();
         List<genesis__Applications__c> appList1 =new List<genesis__Applications__c>();
        if(req == null || req.requestBody == null){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }else{
            List<CBS_API_Log__c> rencustomers = new List<CBS_API_Log__c>();
            try{                
                String jsonData  = req.requestBody.toString();  
                system.debug('#####'+jsonData);
                cbsStatusReq rq  = (cbsStatusReq)Json.deserialize(jsonData, cbsStatusReq.class);                   
                system.debug('****rq****'+rq);
                List<Account> accList = new List<Account>();
                List<ID> AccIds = new List<ID>(); // CBS005
                List<ID> SuccessAccIDs = new List<ID>(); // CBS005

                List<genesis__Application_Parties__c> partyListupdat = new List<genesis__Application_Parties__c>(); // CBS005
                List<clcommon__Collateral__c> CollUpdate = new List<clcommon__Collateral__c>();
                String ExpsnAppID;
                List<Account> updateAccList = new List<Account>();
                try{
                    if(rq.ApplicationId != null && rq.ApplicationId != '')
                        appList = [SELECT Id,RecordType.DeveloperName,Sub_Type__c,Record_Type_Name__c FROM genesis__Applications__c WHERE Id =: rq.ApplicationId];
                }
                catch(Exception e){}
                
                for(acctReqWrapper reqObj : rq.CbsStatus){
                    Account ac = new Account();
                    ExpsnAppID = rq.ApplicationID;
                    if(reqObj.Status == 'Success'){
                        Count ++;
                        APIName = rq.ApiName;
                        SuccessStatus = reqObj.Status;
                        AppID = rq.ApplicationID;
                        SAccId = reqObj.ApplicantId;
                        SCustId = reqObj.CustomerID;
                        SuccessAccIDs.add(SAccId); // CBS005
                        if(!String.isBlank(SCustId) && !String.isBlank(SAccId)){
                            ac.Id = SAccId;
                            ac.CBS_Customer_ID__c = SCustId;
                            updateAccList.add(ac);
                        }
                    }else if(reqObj.Status == 'Failure'){
                        SuccessFlgs = False;
                        FailStatus = reqObj.Status;
                        APIName = rq.ApiName;
                        ErrCode = reqObj.succErrCode;
                        AppID = rq.ApplicationID;
                        FAccId = reqObj.ApplicantId;
                        FCustId = reqObj.CustomerID;
                        FailCustIDs += reqObj.ApplicantId +','; // CBS005
                        AccIds.add(FAccId); // CBS005
                        if(!String.isBlank(FAccId) && !String.isBlank(FCustId)){
                            ac.Id = FAccId;
                            ac.CBS_Customer_ID__c = FCustId;
                            updateAccList.add(ac);
                        }
                        if(reqObj.message <> null)
                            ErrorMsg = reqObj.message;
                    }
                    
                }
                List<CBS_API_Log__c> cbsloglist1=queryService.getCbsLogRecord(AppID,'Loan_Collateral_Creation_HL','Success','6');
               
      
                CBS_API_Log__c cbsLog =new CBS_API_Log__c();
                //Account ac = new Account();

                if(SuccessFlgs){
                    cbsLog.Application__c = AppID;
                    cbsLog.Applicant__c = SAccId;
                    cbsLog.API_Name__c = APIName;
                    cbsLog.Status__c = SuccessStatus;
                    if(APIName == 'Customer_ID_Creation_HL'){
                        cbsLog.Sequence_No__c = '3';
                    }else If(APIName == 'EKYCUpdation_HL'){
                        cbsLog.Sequence_No__c = '2';
                    }else if(APIName == 'Loan_Collateral_Creation_HL'){
                        if(appList.size() > 0 && appList[0].RecordType.DeveloperName == 'SME_NEW_Loan')
                            cbsLog.Sequence_No__c = '16';
                        else if(appList.size() > 0 && appList[0].RecordType.DeveloperName.contains('SME'))
                            cbsLog.Sequence_No__c = '15';
                        else{
                              List<CBS_API_Log__c> cbsloglist=queryService.getCbsLogRecord(AppID,'Loan_Collateral_Modification_HL','Success','6.2');
                            if(appList[0].Sub_Type__c==Constants.Sub_Type_Top_Up && cbsloglist.size()==0){
                                 cbsLog.Sequence_No__c = '6.2'; 
                                cbsLog.API_Name__c = 'Loan_Collateral_Modification_HL';
                            }
                        else if((appList[0].Record_Type_Name__c==Constants.VL2W || appList[0].Record_Type_Name__c==Constants.VL4W ) && cbsloglist1.size()==1){
                            cbsLog.Sequence_No__c = '22';
							cbsLog.API_Name__c ='CBS_collateral_update_API';
                             genesis__Applications__c apptest=[select id,Record_Type_Name__c from genesis__Applications__c where id=:AppID];
                           List<Task> tasklist=[select id,subject,Status from task where whatid=:AppID];
                        boolean allTaskCompleted = true;
                       if(apptest.Record_Type_Name__c=='VL4W' || apptest.Record_Type_Name__c=='VL2W'){
                      allTaskCompleted = true;
                          for(Task tk:tasklist){
                                if(tk.Status !='Completed')
                                    allTaskCompleted = false;
                            }
                }
							if(allTaskCompleted){
                               genesis__Applications__c a= new genesis__Applications__c();
                               a.Id = AppID;
						       a.Sub_Stage__c='Applicaton Processed - Closed';
                               a.Retry_CBS__c = True;
                               appList1.add(a); 
						      
                            }
						 
						}
                             else
                               cbsLog.Sequence_No__c = '6'; 
                        }
                    }
                          
                    else if(APIName == 'Term_Loan_Linkage_Collateral_HL'){
                       
                              List<CBS_API_Log__c> cbsloglist=queryService.getCbsLogRecord(AppID,'Term_Loan_Delete_Collateral_HL','Success','6.1');
                            if(appList[0].Sub_Type__c==Constants.Sub_Type_Top_Up && cbsloglist.size()==0){
                                 cbsLog.Sequence_No__c = '6.1'; 
                                cbsLog.API_Name__c = 'Term_Loan_Delete_Collateral_HL';
                            }
                            else
                               cbsLog.Sequence_No__c = '7';  
                        }
                      else if(APIName == 'FCR_CUST_SIGN_PHOTO_ADD_HL'){
                        cbsLog.Sequence_No__c = '11';
                    }
                    /*if(!String.isBlank(SCustId) && !String.isBlank(SAccId)){
                        ac.Id = SAccId;
                        ac.CBS_Customer_ID__c = SCustId;
                    }*/          
                }else{
                        cbsLog.Application__c = AppID;
                        cbsLog.Applicant__c = FAccId;
                        cbsLog.API_Name__c = APIName;
                        cbsLog.Status__c = FailStatus;
                        if(APIName == 'Customer_ID_Creation_HL'){
                            cbsLog.Sequence_No__c = '3';
                        }else If(APIName == 'EKYCUpdation_HL'){
                            cbsLog.Sequence_No__c = '2';
                        }else if(APIName == 'Loan_Collateral_Creation_HL'){
                            if(appList.size() > 0 && appList[0].RecordType.DeveloperName == 'SME_NEW_Loan')
                                cbsLog.Sequence_No__c = '16';
                            else if(appList.size() > 0 && appList[0].RecordType.DeveloperName.contains('SME'))
                                cbsLog.Sequence_No__c = '15';
                           else {
                              List<CBS_API_Log__c> cbsloglist=queryService.getCbsLogRecord(AppID,'Loan_Collateral_Modification_HL','Success','6.2');
                            if(appList[0].Sub_Type__c==Constants.Sub_Type_Top_Up && cbsloglist.size()==0){
                                 cbsLog.Sequence_No__c = '6.2'; 
                                cbsLog.API_Name__c = 'Loan_Collateral_Modification_HL';
                            }
                            else if((appList[0].Record_Type_Name__c==Constants.VL2W || appList[0].Record_Type_Name__c==Constants.VL4W )&& cbsloglist1.size()==1){
                            cbsLog.Sequence_No__c = '22';
							cbsLog.API_Name__c ='CBS_collateral_update_API';
						}   
                            else
                               cbsLog.Sequence_No__c = '6';
							}							
                        }
                        else if(APIName == 'Term_Loan_Linkage_Collateral_HL'){
                              List<CBS_API_Log__c> cbsloglist=queryService.getCbsLogRecord(AppID,'Term_Loan_Delete_Collateral_HL','Success','6.1');
                            if(appList[0].Sub_Type__c==Constants.Sub_Type_Top_Up && cbsloglist.size()==0){
                                 cbsLog.Sequence_No__c = '6.1'; 
                                cbsLog.API_Name__c = 'Term_Loan_Delete_Collateral_HL';
                            }
                            else
                               cbsLog.Sequence_No__c = '7';  
                        }else if(APIName == 'FCR_CUST_SIGN_PHOTO_ADD_HL'){
                            cbsLog.Sequence_No__c = '11';
                        }
                        cbsLog.Success_Error_Code__c = ErrCode;
                        cbsLog.Success_Error_Message__c = ErrorMsg;
                        cbsLog.FailCustomerIds__c = FailCustIDs;
                        /*if(!String.isBlank(FAccId) && !String.isBlank(FCustId)){
                        ac.Id = FAccId;
                        ac.CBS_Customer_ID__c = FCustId;
                        }*/          
                }

                if(SuccessAccIDs.size() > 0){
                    System.debug('SuccessAccIDs >>> ' + SuccessAccIDs);
                    // CBS 005 Bulk api response handling
                    partyListupdat = queryService.PartyListPartyIDs(SuccessAccIDs,AppID); // CBS005
                    if(APIName == 'EKYCUpdation_HL'){
                        for(genesis__Application_Parties__c parts:partyListupdat){ // CBS005
                                parts.RetryEkyc__c = True;
                            }
                    }else if(APIName == 'Loan_Collateral_Creation_HL'){
                        CollUpdate = queryService.getCollateralWithAccID(SuccessAccIDs,AppID,'CC'); //CBS005
                        if(CollUpdate.size()>0){
                         for(clcommon__Collateral__c cols: CollUpdate){ 
                                cols.RetryColltrlCBS__c = True;
                            }
                        }
                    }else if(APIName == 'Term_Loan_Linkage_Collateral_HL'){
                        CollUpdate = queryService.getCollateralWithAccID(SuccessAccIDs,AppID,'CL'); //CBS005        
                        for(clcommon__Collateral__c cols: CollUpdate){      
                                 cols.RetryLinkColltrlCBS__c = True;     
                            }
                    }
                }
                
                try {
                        if(partyListupdat.size() > 0){ // CBS005
                            System.debug('partyListupdat >>> ' + partyListupdat);
                            update partyListupdat;
                        }
                        if(CollUpdate.size() > 0){ //CBS005
                            System.debug('CollUpdate >>> ' + CollUpdate);
                            update CollUpdate;
                        }
                        
                        update updateAccList;
                        
                        if(cbsLog.Application__c != null){
                            insert cbsLog;
                        }
						if(appList1.size() > 0){
                         update appList1;
                   }


                } catch(Exception ex) {
                    System.debug('cbsInsert >> '+ex.getMessage());
                    HandleBusinessException.captureError('WS_CBS_Status_Update','getMandateFields'+ExpsnAppID, ex);
                }
                
                /*if(ac.Id !=null){
                    update ac;
                }*/
               /* for(acctReqWrapper reqObj : rq.CbsStatus){
                    CBS_API_Log__c app =new CBS_API_Log__c();
                    if(!String.isBlank(rq.ApplicationID)){
                        app.Application__c = rq.ApplicationID;
                    }
                    if(!String.isBlank(rq.ApiName)){
                        app.API_Name__c = rq.ApiName;
                    }
                    if(!String.isBlank(reqObj.ApplicantId)){
                        app.Applicant__c = reqObj.ApplicantId;
                    }
                    if(rq.ApiName == 'Customer_ID_Creation_HL'){
                        app.Sequence_No__c = '3';
                    }else If(rq.ApiName == 'EKYCUpdation_HL'){
                        app.Sequence_No__c = '2';
                    }else if(rq.ApiName == 'Loan_Collateral_Creation_HL'){
                        app.Sequence_No__c = '6';
                    }else if(rq.ApiName == 'Term_Loan_Linkage_Collateral_HL'){
                        app.Sequence_No__c = '7';
                    }else if(rq.ApiName == 'FCR_CUST_SIGN_PHOTO_ADD_HL'){
                        app.Sequence_No__c = '11';
                    }
                    
                    if(!String.isBlank(reqObj.Status)){
                        app.Status__c = reqObj.Status;
                    }
                    if(!String.isBlank(reqObj.succErrCode)){
                        app.Success_Error_Code__c = reqObj.succErrCode;
                    }
                    if(!String.isBlank(reqObj.message)){
                        app.Success_Error_Message__c = reqObj.message;
                    }
                    if(!String.isBlank(reqObj.CustomerID)){
                        app.Success_Error_Message__c = reqObj.CustomerID;
                    }
                    //rencustomers.add(app);
                    if(!String.isBlank(reqObj.CustomerID) && !String.isBlank(reqObj.ApplicantId)){
                        Account ac = new Account();
                        ac.Id = reqObj.ApplicantId;
                        ac.CBS_Customer_ID__c = reqObj.CustomerID;
                        //accList.add(ac);
                    }                    
                }*/
                
                //if(rencustomers.size()>0){
                    //insert rencustomers;
                //}
                //if(accList.size()>0){
                   // update accList;
                //}
                
                //res.application  = rq.ApplicationID;
                res.status      = Constants.WS_SUCCESS_STATUS;
                res.statusCode  = Constants.WS_SUCCESS_CODE;
            }catch(Exception e){
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage   = e.getMessage();
                res.statusCode  = Constants.WS_ERROR_CODE;
                system.debug('Exception::'+e.getMessage());
                return res;
            }          
            
            
            return res;
        }        
    }
    
}