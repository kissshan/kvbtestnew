/*
@name         : SME_StockStatementHandler
@description  : CBS callouts handler(SME)
@author       : Dushyant
*/
public class SME_StockStatementHandler{
    public static void requestHandler(String appId){
        genesis__Applications__c app = new genesis__Applications__c();
        app = [SELECT Id,Service_Type_Name__c,Branch_Code__c,genesis__Account__c,genesis__Account__r.Drawing_Power__c FROM genesis__Applications__c WHERE Id =: appId];
        System.debug('ServiceType:::'+app.Service_Type_Name__c);
        if(app.Service_Type_Name__c == null || app.Service_Type_Name__c == 'CollateralDlink'){
            coll_D_Link(app);
        }
        else if(app.Service_Type_Name__c == 'CollateralCreation'){
            collCreation(app);
        }
        else if(app.Service_Type_Name__c == 'CollateralLinkage'){
            collLinkage(app);
        }
    }
    public static void coll_D_Link(genesis__Applications__c app){
        List<Account> accList       = new List<Account>();
        List<Facility__c> facList   = new List<Facility__c>();
        String occProdCodes         = System.Label.OCC_Product_Codes;
        List<String> prodCodeList   = new List<String>();
        if(occProdCodes != null){
            prodCodeList = (occProdCodes).split(',');
        }
        accList = [SELECT Id,Branch_Name__c,Branch_Code__c,Drawing_Power__c FROM Account WHERE Id =: app.genesis__Account__c];
        facList = [SELECT Id,Existing_Limit__c,Application__r.Branch_Name__c,Account_Number__c,Application__r.genesis__Account__r.Drawing_Power__c,Application__r.Branch_Code__c FROM Facility__c WHERE Application__c =: app.Id AND CL_Product__r.Product_Code__c IN : prodCodeList AND RecordType.developerName = 'Parent'];
        System.debug('facList'+facList);
        System.debug('accList'+accList);
        
        if(!facList.isEmpty()){
            Dp_Updation_Formatter.RequestFormat sStmnt = new Dp_Updation_Formatter.RequestFormat();
            sStmnt.exe_tenantId                                 = 'cuecent_tenant';
            sStmnt.owner_tenantId                               = 'cuecent_tenant';
            sStmnt.inputVariables                               = new Dp_Updation_Formatter.cls_inputVariables();
            sStmnt.inputVariables.in_msg                        = new Dp_Updation_Formatter.cls_in_msg();
            sStmnt.inputVariables.in_msg.Channel                = 'BRN';
            sStmnt.inputVariables.in_msg.ExternalReferenceNo    = '1001';
            sStmnt.inputVariables.in_msg.TransactionBranch      = app.Branch_Code__c != null ? app.Branch_Code__c : '';
            sStmnt.inputVariables.in_msg.AccountNo              = facList[0].Account_Number__c != null ? facList[0].Account_Number__c : '';
            sStmnt.inputVariables.in_msg.DP_Amt                 = app.genesis__Account__r.Drawing_Power__c != null ? String.valueOf(app.genesis__Account__r.Drawing_Power__c.round()) : '';
            sStmnt.inputVariables.in_msg.ExtUniqueRefId         = '1';
            sStmnt.inputVariables.in_msg.BranchCode             = app.Branch_Code__c != null ? app.Branch_Code__c : '';
            sStmnt.inputVariables.in_msg.ServiceTypeId          = '1';
            sStmnt.inputVariables.in_msg.ServiceTypeName        = 'CollateralDlink';
            
            d_LinkCallout(JSON.serialize(sStmnt),app);
        }
    }
    public static void collCreation(genesis__Applications__c app){
        String occProdCodes         = System.Label.OCC_Product_Codes;
        List<Facility__c> facList   = new List<Facility__c>();
        List<String> prodCodeList   = new List<String>();
        if(occProdCodes != null){
            prodCodeList = (occProdCodes).split(',');
        }
        facList = [SELECT Id,Existing_Limit__c,Application__r.Branch_Name__c,Account_Number__c,Application__r.genesis__Account__r.Drawing_Power__c,Application__r.Branch_Code__c FROM Facility__c WHERE Application__c =: app.Id AND CL_Product__r.Product_Code__c IN : prodCodeList AND RecordType.developerName = 'Parent'];
        
        CBS_API_Log__c cbsApiLog       = new CBS_API_Log__c();
        cbsApiLog = getLogRecord(app);
        DP_Updation_Formatter.RequestFormat sCollCreation   = new DP_Updation_Formatter.RequestFormat();
        sCollCreation.exe_tenantId                                  = 'cuecent_tenant';
        sCollCreation.owner_tenantId                                = 'cuecent_tenant';
        sCollCreation.inputVariables                                = new DP_Updation_Formatter.cls_inputVariables();
        sCollCreation.inputVariables.in_msg                         = new DP_Updation_Formatter.cls_in_msg();
        sCollCreation.inputVariables.in_msg.Channel                 = cbsApiLog.Channel__c;
        sCollCreation.inputVariables.in_msg.ExternalReferenceNo     = '';
        sCollCreation.inputVariables.in_msg.TransactionBranch       = app.Branch_Code__c != null ? app.Branch_Code__c : '';
        sCollCreation.inputVariables.in_msg.AccountNo               = cbsApiLog.Account_No__c;
        sCollCreation.inputVariables.in_msg.DP_Amt                  = app.genesis__Account__r.Drawing_Power__c != null ? String.valueOf(app.genesis__Account__r.Drawing_Power__c.round()) : '';
        sCollCreation.inputVariables.in_msg.ExtUniqueRefId          = cbsApiLog.Ext_Unique_Ref_Id__c;
        sCollCreation.inputVariables.in_msg.CollateralID            = cbsApiLog.Collateral_ID__c;
        sCollCreation.inputVariables.in_msg.CollateralCode          = cbsApiLog.Collateral_Code__c;
        sCollCreation.inputVariables.in_msg.BranchCode              = app.Branch_Code__c != null ? app.Branch_Code__c : '';
        sCollCreation.inputVariables.in_msg.TypeofCharge            = cbsApiLog.Type_of_Charge__c;
        sCollCreation.inputVariables.in_msg.DatOrginalValuation     = String.valueOf(cbsApiLog.Date_Orginal_Valuation__c);
        sCollCreation.inputVariables.in_msg.DatLastValuation        = String.valueOf(cbsApiLog.Date_Last_Valuation__c);
        sCollCreation.inputVariables.in_msg.DeedStatus              = cbsApiLog.Deed_Status__c;
        sCollCreation.inputVariables.in_msg.Location                = cbsApiLog.Location__c;
        sCollCreation.inputVariables.in_msg.AreaUnit                = cbsApiLog.Area_Unit__c;
        sCollCreation.inputVariables.in_msg.TotalArea               = cbsApiLog.Total_Area__c;
        sCollCreation.inputVariables.in_msg.TypeofProperty          = cbsApiLog.Type_of_Property__c;
        sCollCreation.inputVariables.in_msg.DatLeaseExpiry          = String.valueOf(cbsApiLog.Date_Lease_Expiry__c);
        sCollCreation.inputVariables.in_msg.DescriptionProp1        = cbsApiLog.Description_Prop1__c;
        sCollCreation.inputVariables.in_msg.DescriptionProp2        = cbsApiLog.Description_Prop2__c;
        sCollCreation.inputVariables.in_msg.DocumentCode            = '';
        sCollCreation.inputVariables.in_msg.FlgOperation            = '';
        sCollCreation.inputVariables.in_msg.NameofLender            = cbsApiLog.Name_of_Lender__c;
        sCollCreation.inputVariables.in_msg.OriginalValue           = cbsApiLog.Original_Value__c;
        sCollCreation.inputVariables.in_msg.LastValue               = cbsApiLog.Last_Value__c;
        sCollCreation.inputVariables.in_msg.MarketValue             = cbsApiLog.Market_Value__c;
        sCollCreation.inputVariables.in_msg.CustodianName           = '';
        sCollCreation.inputVariables.in_msg.DateDeedsSent           = '';
        sCollCreation.inputVariables.in_msg.ExpectedReturnDate      = '';
        sCollCreation.inputVariables.in_msg.DeedDetails             = cbsApiLog.Deed_Details__c;
        sCollCreation.inputVariables.in_msg.RegisteringAuth         = '';
        sCollCreation.inputVariables.in_msg.InsurancePlanCode       = '';
        sCollCreation.inputVariables.in_msg.InsurancePolicyNumber   = '';
        sCollCreation.inputVariables.in_msg.InsurancePremiumBilling = '';
        sCollCreation.inputVariables.in_msg.BillingMode             = '';
        sCollCreation.inputVariables.in_msg.Percentage              = '';
        sCollCreation.inputVariables.in_msg.PremiumBilingAccount    = '';
        sCollCreation.inputVariables.in_msg.InsurancePremiumAmount  = '';
        sCollCreation.inputVariables.in_msg.NonStandardCollId       = '';
        sCollCreation.inputVariables.in_msg.Description1            = '';
        sCollCreation.inputVariables.in_msg.Description1            = '';
        sCollCreation.inputVariables.in_msg.Description2            = '';
        sCollCreation.inputVariables.in_msg.ChasisNumber            = '';
        sCollCreation.inputVariables.in_msg.EngineNumber            = '';
        sCollCreation.inputVariables.in_msg.RegistrationNumber      = '';
        sCollCreation.inputVariables.in_msg.Description1            = '';
        sCollCreation.inputVariables.in_msg.ModelNumber             = '';
        sCollCreation.inputVariables.in_msg.YearofMfg               = '';
        sCollCreation.inputVariables.in_msg.DescriptionAuto1        = '';
        sCollCreation.inputVariables.in_msg.DescriptionAuto2        = '';
        sCollCreation.inputVariables.in_msg.SecurityCode            = '';
        sCollCreation.inputVariables.in_msg.NumberofUnits           = '';
        sCollCreation.inputVariables.in_msg.SeriesNumber1           = '';
        sCollCreation.inputVariables.in_msg.SeriesNumber2           = '';
        sCollCreation.inputVariables.in_msg.ForcedSaleValue         = '';
        sCollCreation.inputVariables.in_msg.QuitRentValue           = '';
        sCollCreation.inputVariables.in_msg.Make                    = '';
        sCollCreation.inputVariables.in_msg.SLNum                   = '';
        sCollCreation.inputVariables.in_msg.RegNo                   = '';
        sCollCreation.inputVariables.in_msg.EngNo                   = '';
        sCollCreation.inputVariables.in_msg.HPCapacity              = '';
        sCollCreation.inputVariables.in_msg.MachDesciption          = '';
        sCollCreation.inputVariables.in_msg.AreaCult                = '';
        sCollCreation.inputVariables.in_msg.AreaLand                = '';
        sCollCreation.inputVariables.in_msg.DetailsCult             = '';
        sCollCreation.inputVariables.in_msg.VillageNam              = '';
        sCollCreation.inputVariables.in_msg.SurveyNo                = '';
        sCollCreation.inputVariables.in_msg.SecDescription1         = '';
        sCollCreation.inputVariables.in_msg.SecDescription2         = '';
        sCollCreation.inputVariables.in_msg.Breed                   = '';
        sCollCreation.inputVariables.in_msg.Age                     = '';
        sCollCreation.inputVariables.in_msg.Number1                 = '';
        sCollCreation.inputVariables.in_msg.Quantity                = '';
        sCollCreation.inputVariables.in_msg.CatDescription1         = '';
        sCollCreation.inputVariables.in_msg.CatDescription2         = '';
        sCollCreation.inputVariables.in_msg.IdentMArk               = '';
        sCollCreation.inputVariables.in_msg.ASNAcctNumber           = '';
        sCollCreation.inputVariables.in_msg.TotNumUnits             = '';
        sCollCreation.inputVariables.in_msg.CertNumber              = '';
        sCollCreation.inputVariables.in_msg.CertNumber1             = '';
        sCollCreation.inputVariables.in_msg.CertNumber2             = '';
        sCollCreation.inputVariables.in_msg.CertNumber3             = '';
        sCollCreation.inputVariables.in_msg.CertNumber4             = '';
        sCollCreation.inputVariables.in_msg.DivDate                 = '';
        sCollCreation.inputVariables.in_msg.SecurityCodec           = '';
        sCollCreation.inputVariables.in_msg.GrossWeight             = '';
        sCollCreation.inputVariables.in_msg.NetWeight               = '';
        sCollCreation.inputVariables.in_msg.AppraiserValue          = '';
        sCollCreation.inputVariables.in_msg.DateValuation           = '';
        sCollCreation.inputVariables.in_msg.DescCommodity           = '';
        sCollCreation.inputVariables.in_msg.ServiceTypeId           = cbsApiLog.Service_Type_Id__c;
        sCollCreation.inputVariables.in_msg.ServiceTypeName         = cbsApiLog.Service_Type_Name__c;
        sCollCreation.inputVariables.in_msg.LimitNo                 = cbsApiLog.Limit_No__c;
        sCollCreation.inputVariables.in_msg.CollateralDegree        = cbsApiLog.Collateral_Degree__c;
        sCollCreation.inputVariables.in_msg.CollateralAmt           = cbsApiLog.Amt_Collateral__c;
        sCollCreation.inputVariables.in_msg.CollateralDesc          = cbsApiLog.collateral_Desc__c;
        
        collCreationCallout(JSON.serialize(sCollCreation),app);
    }
    public static void collLinkage(genesis__Applications__c app){
        CBS_API_Log__c cbsApiLog       = new CBS_API_Log__c();
        cbsApiLog = getLogRecord(app);
        DP_Updation_Formatter.RequestFormat sCollLinkage   = new DP_Updation_Formatter.RequestFormat();
        sCollLinkage.exe_tenantId                                  = 'cuecent_tenant';
        sCollLinkage.owner_tenantId                                = 'cuecent_tenant';
        sCollLinkage.inputVariables                                = new DP_Updation_Formatter.cls_inputVariables();
        sCollLinkage.inputVariables.in_msg                         = new DP_Updation_Formatter.cls_in_msg();
        sCollLinkage.inputVariables.in_msg.Channel                 = cbsApiLog.Channel__c;
        sCollLinkage.inputVariables.in_msg.TransactionBranch       = cbsApiLog.Transaction_Branch__c;
        sCollLinkage.inputVariables.in_msg.AccountNo               = cbsApiLog.Account_No__c;
        sCollLinkage.inputVariables.in_msg.CollateralAmt           = app.genesis__Account__r.Drawing_Power__c != null ? String.valueOf(app.genesis__Account__r.Drawing_Power__c.round()) : '';
        sCollLinkage.inputVariables.in_msg.ExtUniqueRefId          = cbsApiLog.Ext_Unique_Ref_Id__c;
        sCollLinkage.inputVariables.in_msg.ServiceTypeId           = cbsApiLog.Service_Type_Id__c;
        sCollLinkage.inputVariables.in_msg.ServiceTypeName         = cbsApiLog.Service_Type_Name__c;
        sCollLinkage.inputVariables.in_msg.CollateralDesc          = cbsApiLog.collateral_Desc__c;
        sCollLinkage.inputVariables.in_msg.CollateralDegree        = cbsApiLog.Collateral_Degree__c;
        sCollLinkage.inputVariables.in_msg.CollateralCode          = cbsApiLog.Collateral_Code__c;
        sCollLinkage.inputVariables.in_msg.CollateralID            = cbsApiLog.Collateral_ID__c;
        sCollLinkage.inputVariables.in_msg.LimitNo                 = cbsApiLog.Limit_No__c;
        
        collLinkageCallout(JSON.serialize(sCollLinkage),app);
    }
    public static void d_LinkCallout(String reqString,genesis__Applications__c app){
        //system.debug('reqString:::'+reqString);
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        System.debug('Endpoint:::'+Utility.getEndpoint('CBS_StockStatement'));
        response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('CBS_StockStatement'), 'POST', null,reqString,headerMap,label.CA_CERTIFICATE);
        String jsonString = response.getBody();
        //system.debug('jsonString:::'+jsonString);
        DP_Updation_Formatter.ResponseFormat res = (DP_Updation_Formatter.ResponseFormat)JSON.deserialize(jsonString, DP_Updation_Formatter.ResponseFormat.Class);
        responseHandler(res,app);
    }
    public static void collCreationCallout(String reqString,genesis__Applications__c app){
        //system.debug('reqString:::'+reqString);
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        //System.debug(Utility.getEndpoint('CBS_StockStatement'));
        response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('CBS_StockStatement'), 'POST', null,reqString,headerMap,label.CA_CERTIFICATE);
        String jsonString = response.getBody();
        //system.debug('jsonString:::'+jsonString);
        DP_Updation_Formatter.ResponseFormat res = (DP_Updation_Formatter.ResponseFormat)JSON.deserialize(jsonString, DP_Updation_Formatter.ResponseFormat.Class);
        responseHandler(res,app);
    }
    public static void collLinkageCallout(String reqString,genesis__Applications__c app){
        //system.debug('reqString:::'+reqString);
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('CBS_StockStatement'), 'POST', null,reqString,headerMap,label.CA_CERTIFICATE);
        String jsonString = response.getBody();
        //system.debug('jsonString:::'+jsonString);
        DP_Updation_Formatter.ResponseFormat res = (DP_Updation_Formatter.ResponseFormat)JSON.deserialize(jsonString, DP_Updation_Formatter.ResponseFormat.Class);
        responseHandler(res,app);
    }
    
    public static void responseHandler(DP_Updation_Formatter.ResponseFormat res,genesis__Applications__c app){
        if(res.out_msg.Success != null){
            List<DP_Updation_Formatter.cls_Collateral> collateralList =  new List<DP_Updation_Formatter.cls_Collateral>();
            collateralList = res.out_msg.Success.ODLimitLinkResponse.CollateralDetails.Collateral;
            if(!collateralList.isEmpty()){
                List<CBS_API_Log__c> cbsApliLogList =  new List<CBS_API_Log__c>();
                for(DP_Updation_Formatter.cls_Collateral coll: collateralList){
                    CBS_API_Log__c cbsApiLog                =  new CBS_API_Log__c();
                    cbsApiLog.Service_Type_Name__c          =  'DP updation Success';
                    cbsApiLog.Collateral_Code__c            =  Utility.getBlankStringIfNull(coll.CollateralCode);
                    cbsApiLog.Linked__c                     =  Utility.getBlankStringIfNull(coll.Linked);
                    cbsApiLog.Description__c                =  Utility.getBlankStringIfNull(coll.Description);
                    cbsApiLog.Collateral_ID__c              =  Utility.getBlankStringIfNull(coll.CollateralID);
                    cbsApiLog.Drawing_Power_Update__c       =  Utility.getBlankStringIfNull(coll.DrawingPowerUpdate);
                    cbsApiLog.Collateral_Degree__c          =  Utility.getBlankStringIfNull(coll.CollateralDegree);
                    cbsApiLog.Lendable_Value__c             =  Utility.getBlankStringIfNull(coll.LendableValue);
                    cbsApiLog.Collateral_Value__c           =  Utility.getBlankStringIfNull(coll.CollateralValue);
                    cbsApiLog.Account_No__c                 =  Utility.getBlankStringIfNull(res.out_msg.Success.ODLimitLinkResponse.AccountNo);
                    cbsApiLog.Limit_Amount__c               =  Utility.getBlankStringIfNull(res.out_msg.Success.ODLimitLinkResponse.LimitAmount);
                    cbsApiLog.Ext_Unique_Ref_Id__c          =  Utility.getBlankStringIfNull(res.out_msg.Success.ODLimitLinkResponse.ExtUniqueRefId);
                    cbsApiLog.Limit_No__c                   =  Utility.getBlankStringIfNull(res.out_msg.Success.ODLimitLinkResponse.LimitNo);
                    cbsApiLog.Customer_Name__c              =  Utility.getBlankStringIfNull(res.out_msg.Success.ODLimitLinkResponse.CustomerName);
                    cbsApiLog.ExternalReferenceNo__c        =  Utility.getBlankStringIfNull(res.out_msg.Success.ODLimitLinkResponse.Status.ExternalReferenceNo);
                    
                    cbsApiLog.Application__c = app.Id;
                    cbsApiLog.API_Name__c = 'Stock Statement';
                    cbsApiLog.Sequence_No__c = '14'; 
                    cbsApiLog.Status__c = 'Stock Statement Success';
                    cbsApiLog.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    cbsApliLogList.add(cbsApiLog);
                }
                if(!cbsApliLogList.isEmpty())INSERT cbsApliLogList;
            }
            ApplicationTriggerHandler.IsFirstRun = false;
            app.Service_Type_Name__c = 'Stock Statement Success';
            UPDATE app;
        }
        else if(res.out_msg.Failure != null){
            errorResponse(res,app);
        }   
    }
    public static void errorResponse(DP_Updation_Formatter.ResponseFormat res,genesis__Applications__c app){
        CBS_API_Log__c cbsApiLog                = new CBS_API_Log__c();
        //cbsApiLog.bpms_error_code__c          = Utility.getBlankStringIfNull(res.bpms_error_code);
        cbsApiLog.Failure_Error_Code__c         = Utility.getBlankStringIfNull(res.out_msg.Failure.ErrorCode);
        cbsApiLog.Failure_Error_Message__c      = Utility.getBlankStringIfNull(res.out_msg.Failure.ErrorMessage);
        cbsApiLog.Response__c                   = Utility.getBlankStringIfNull(res.out_msg.Failure.Response);
        if(res.out_msg.Failure.Reason != null){
            cbsApiLog.Reason_Message__c         = Utility.getBlankStringIfNull(res.out_msg.Failure.Reason.Message);
            cbsApiLog.Reason_Code__c            = Utility.getBlankStringIfNull(res.out_msg.Failure.Reason.Code);
        }
        if(res.out_msg.Failure.CallBackData != null){
            cbsApiLog.Service_Type_Name__c      = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.ServiceTypeName);
            cbsApiLog.Account_No__c             = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.AccountNo);
            cbsApiLog.Service_Type_Id__c        = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.ServiceTypeId);
            cbsApiLog.DP_Amt__c                 = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.DP_Amt);
            cbsApiLog.Collateral_ID__c          = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.CollateralID);
            cbsApiLog.Limit_No__c               = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.LimitNo);
            cbsApiLog.Collateral_Degree__c      = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.CollateralDegree);
            cbsApiLog.Type_of_Property__c       = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.TypeofProperty);
            cbsApiLog.Market_Value__c           = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.MarketValue);
            cbsApiLog.Total_Area__c             = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.TotalArea);
            cbsApiLog.Date_Lease_Expiry__c      = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.DatLeaseExpiry);
            cbsApiLog.Date_Orginal_Valuation__c = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.DatOrginalValuation);
            cbsApiLog.Amt_Collateral__c         = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.CollateralAmt);
            cbsApiLog.Ext_Unique_Ref_Id__c      = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.ExtUniqueRefId);
            cbsApiLog.Description_Prop1__c      = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.DescriptionProp1);
            cbsApiLog.Description_Prop2__c      = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.DescriptionProp2);
            cbsApiLog.Area_Unit__c              = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.AreaUnit);
            cbsApiLog.Type_of_Charge__c         = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.TypeofCharge);
            cbsApiLog.Deed_Details__c           = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.DeedDetails);
            cbsApiLog.Name_of_Lender__c         = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.NameofLender);
            cbsApiLog.collateral_Desc__c        = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.collateralDesc);
            cbsApiLog.Channel__c                = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.Channel);
            cbsApiLog.Original_Value__c         = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.OriginalValue);
            cbsApiLog.Deed_Status__c            = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.DeedStatus);
            cbsApiLog.Date_Last_Valuation__c    = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.DatLastValuation);
            cbsApiLog.Collateral_Code__c        = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.CollateralCode);
            cbsApiLog.Last_Value__c             = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.LastValue);
            cbsApiLog.Transaction_Branch__c     = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.TransactionBranch);
            cbsApiLog.Location__c               = Utility.getBlankStringIfNull(res.out_msg.Failure.CallBackData.Location);
        }
        
        cbsApiLog.bpms_error_msg__c             = Utility.getBlankStringIfNull(res.bpms_error_msg);  
        cbsApiLog.Application__c                = app.Id;
        cbsApiLog.API_Name__c                   = 'Stock Statement';
        cbsApiLog.Sequence_No__c                = '14'; 
        cbsApiLog.Status__c                     = 'Error_'+res.out_msg.Failure.CallBackData.ServiceTypeName;
        cbsApiLog.Success_Error_Message__c      = res.out_msg.ErrorMessage; 
        
        INSERT cbsApiLog;
        
        ApplicationTriggerHandler.IsFirstRun = false;
        app.Service_Type_Name__c = res.out_msg.Failure.CallBackData.ServiceTypeName;
        UPDATE app;
    }
    
    public static CBS_API_Log__c getLogRecord(genesis__Applications__c app){
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        String serviceType = app.Service_Type_Name__c;
        String appId = app.Id;
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get('CBS_API_Log__c' ).getDescribe().fields.getMap();
        
        String query = 'SELECT ';    
        for(Schema.SObjectField s : accountFieldMap.values()){
            query = query + s.getDescribe().getName()+','; 
        }
         query   = query.removeEnd(',');
        query   = query + ' FROM CBS_API_Log__c WHERE Service_Type_Name__c =: serviceType AND Application__c =: appId LIMIT 1';
        System.debug('query:::'+query);
        cbsLog = Database.query(query);
        
        RETURN cbsLog;
    }
}