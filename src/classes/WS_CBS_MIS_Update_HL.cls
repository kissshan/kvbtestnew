/*
* Name    : WS_MIS_Update_HL
* Company : ET Marlabs
* Purpose : This class CBS API to update MIS
* Author  : Subas
*/
public class WS_CBS_MIS_Update_HL {
    //@future (Callout=true)
    public static void Mis_Update(String appID,List<CBS_API_Log__c> UpcbsLog){
        //List<CBS_API_Log__c> UpcbsLog =  new List<CBS_API_Log__c>();
        Mis_UpdateNEW(appID,null,UpcbsLog); //CBS_001
    }
    public static void Mis_UpdateNEW(String appID,String loanNo,List<CBS_API_Log__c> UpcbsLog){ //CBS_001
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appID);
        CBS_MIS_DATA__c mis = CBS_MIS_DATA__c.getOrgDefaults();   
        System.debug('AppID:::'+AppID);
        
        MIS_Update_Handler cbs = new MIS_Update_Handler();
        cbs.InputVariables = new MIS_Update_Handler.cls_inputVariables();
        MIS_Update_Handler.cls_inputVariables cbsInput = new MIS_Update_Handler.cls_inputVariables();
        cbsInput.in_msg = new MIS_Update_Handler.cls_in_msg();
        cbs.InputVariables = cbsInput;
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        if(loanNo != null){
            cbsInput.in_msg.Mnemonic = loanNo;
        }else{
            cbsInput.in_msg.Mnemonic = application.Loan_Account_Number__c;  
        }         
        cbsInput.in_msg.Security = mis.Security__c;
        if(application.Record_Type_Name__c == Constants.PERSONALLOAN)
            cbsInput.in_msg.Security = '99';

        if(application.Record_Type_Name__c == Constants.VL4W || application.Record_Type_Name__c == Constants.VL2W)
            cbsInput.in_msg.Security = '3';

        cbsInput.in_msg.NoOfDependents ='';  
        cbsInput.in_msg.PrioritySectorCode = mis.Priority_Sector_Code__c;
        if(application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL4W || application.Record_Type_Name__c == Constants.VL2W)
             cbsInput.in_msg.PrioritySectorCode = '999';

        cbsInput.in_msg.SpouseIncome ='99'; 
        if(application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.LAPLOAN) 
            cbsInput.in_msg.Occupation = mis.Occupation__c; //'95019';//  
        
        if(application.Record_Type_Name__c == Constants.VL4W || application.Record_Type_Name__c == Constants.VL2W)
            cbsInput.in_msg.Occupation = '95012'; //As per Sriram sir email occupation value updated on - 10/10/2018

        if(application.Record_Type_Name__c == Constants.HOMELOAN)
            cbsInput.in_msg.Occupation = '95011'; // 10/10/2018

        cbsInput.in_msg.MonthlyHouseHoldIncome ='99';    
        cbsInput.in_msg.RBIPurpose = mis.RBI_Purpose__c; //'99999';     
        cbsInput.in_msg.AssetOwnership = '99';
        //if(application.Record_Type_Name__c == Constants.PERSONALLOAN)
          //  cbsInput.in_msg.AssetOwnership = '99';     
        
        cbsInput.in_msg.Nostro =  mis.Nostro__c;  //'NO_NOSTRO';
        cbsInput.in_msg.ResidenceDetails ='1';  
        cbsInput.in_msg.SelectedSecurityCode = mis.Selected_Security_Code__c;    //'99'; //
        cbsInput.in_msg.CreditCardDetails = '99';//'999';    
        cbsInput.in_msg.BSRActivityCode = mis.BSR_Activity_Code__c;  
        //if(application.Record_Type_Name__c == Constants.PERSONALLOAN)
          //  cbsInput.in_msg.BSRActivityCode = '9';//'3';

        cbsInput.in_msg.BankingActivities ='99';     
        cbsInput.in_msg.CategoryOfBorrowers =mis.Category_Of_Borrowers__c;  // '99';//
        cbsInput.in_msg.InvestmentPreference ='99';  
        cbsInput.in_msg.ExportDocType = mis.Export_Doc_Type__c;  // 'NA';//
        cbsInput.in_msg.LoanDetails ='99';   
        cbsInput.in_msg.ExportStatusHolder = mis.Export_Status_Holder__c;  //'NA';//  
        cbsInput.in_msg.PresentLoanRequirements ='99';   
        cbsInput.in_msg.MakerID = mis.MakerID__c;    
        cbsInput.in_msg.CheckerID = mis.CheckerID__c;    
        getMIS(JSON.serialize(cbs),AppId,loanNo,UpcbsLog);
    }
    public static void getMIS(String misData, String AppId,String loanNo,List<CBS_API_Log__c> UpcbsLog){
        system.debug('####'+misData);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_MIS_Update');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,misData,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();            
                MIS_Update_Handler.MIS_Update_Response res = (MIS_Update_Handler.MIS_Update_Response)Json.deserialize(jsonString,MIS_Update_Handler.MIS_Update_Response.class);
                System.debug(res);
                System.debug(res.out_msg.StatusDecs);
                System.debug(res.out_msg.ErrorMessage);
                if( (res.out_msg.ErrorMessage == null || res.out_msg.ErrorMessage =='') && (res.out_msg.ErrorCode == '0') ){
                    // CBS_001 : CBS MIS_Update success response insert
                        CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                        CbsDedup.Application__c = AppId;
                        CbsDedup.API_Name__c = 'MIS_Update';
                        CbsDedup.Status__c = 'Success';
                        CbsDedup.Success_Error_Message__c = res.out_msg.ErrorMessage;
                        CbsDedup.Sequence_No__c = '10';  
                        UpcbsLog.add(CbsDedup);
                    genesis__Applications__c application = queryService.getApp(appID);
                    //for pre approved loan
                    if(!application.Pre_Approved_Flag__c)
                    {
                        if(loanNo != null){
                            WS_CBS_UploadImage.cbs_photo_uploadNEW(AppId,loanNo,UpcbsLog);
                        }else{
                            WS_CBS_UploadImage.cbs_photo_upload(AppId,UpcbsLog);
                    }     
                    }
                    else if(application.Record_Type_Name__c == 'Personal Loan') //skipping cbs 11 for pre Approve loan
                    {
                        if(loanNo != null){
                            system.System.debug('loanNo >>> ' + loanNo);
                            WS_CBS_HOST_Disbursment_HL.Host_requestNew(AppId,loanNo); 
                        }
                        else
                        {
                            system.debug('loanNo'+ loanNo);
                            WS_CBS_HOST_Disbursment_HL.Host_requestNew(AppId,null);
                        }
                    }
                    
                }else if(res.out_msg.ErrorCode <> '0'){
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = AppId;
                    log.API_Name__c = 'MIS_Update';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    log.Sequence_No__c = '10';  
                    UpcbsLog.add(log); ////CBS_001
                    insert UpcbsLog;
                    //insert log;         //CBS_001         
                    if(loanNo != null && AppID !=null){
                        genesis__Applications__c a= new genesis__Applications__c();
                        a.Id = AppID;
                        a.Loan_Account_Number__c = loanNo;                    
                        update a;
                    } 
                }
            }
        }catch(exception e){
                HandleBusinessException.captureError('WS_CBS_MIS_Update_HL','getMIS', e);
        } 
    }
}