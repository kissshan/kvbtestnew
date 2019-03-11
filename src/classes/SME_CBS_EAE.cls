/*
@name         : SME_CBS_EAE
@description  : CBS callouts handler(SME_EAE & New_Loan)
@author       : Dushyant
*/
global class SME_CBS_EAE {
    public static Boolean dLinkFlag                     = true;
    public static Boolean collLinkageFlag               = false;
    public static Boolean newAccountFlag                = false;
    public static Boolean keyPersonLinkageFlag          = false;
    public static String cbsCustId                      = '';
    public static Map<Id,String> facIdAccNumberMap      = new Map<Id,String>();
    public static Map<String,Id> mapOfFacilityId        = new Map<String,Id>();
    public static genesis__Applications__c app          = new genesis__Applications__c();
    public static void requestHandler(String appId){
        try{
            genesis__Applications__c app                    = new genesis__Applications__c();
            app = [SELECT Name,genesis__Rate_Floor__c,genesis__Additional_Cash_Required__c ,Application_Stage__c,Legal_desk_state_flag__c,RecordType.DeveloperName,genesis__Account__r.Name,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Customer_IC__c,genesis__Account__r.Pan_Number__c,EAE_Renewal_Date_in_days__c,genesis__Account__r.Branch_Code__c,Id,Cibil_Charges__c,Processing_Charges__c,Charge_collection_done__c,Service_Type_Name__c,Branch_Code__c,genesis__Account__c,genesis__Account__r.Drawing_Power__c,
                   (SELECT Id,Recommended_Limit__c,Account_Number__c FROM Facilities__r),
                   (SELECT Id,genesis__Collateral__c FROM Application_Collateral__r WHERE genesis__Collateral__r.FE_Created__c = true)
                   FROM genesis__Applications__c WHERE Id =: appId];
            System.debug('ServiceType:::'+app.Service_Type_Name__c);
            if(app.Service_Type_Name__c == null || app.Service_Type_Name__c == 'CollateralDlink'){
                coll_D_Link(app,true);
            }
            else if(app.Service_Type_Name__c == 'CollateralCreation'){
                collCreation(app,true);
            }
            else if(app.Service_Type_Name__c == 'LimitUpdation'){
                limitUpdation(appId,false);
            }
            else if(app.Service_Type_Name__c == 'CollateralLinkage'){
                collLinkage(app,true);
            }
            else if(app.Service_Type_Name__c == 'ChargeCollection'){
                chargeCollection(app,true);
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    
    public static void requestHandlerNewLoan(String appId,String custCBSId){
        try{
            app = [SELECT Name,genesis__Additional_Cash_Required__c ,Application_Stage__c,genesis__Rate_Floor__c,Legal_desk_state_flag__c,RecordType.DeveloperName,genesis__Account__r.RecordType.DeveloperName,Type__c,genesis__Account__r.Name,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Customer_IC__c,genesis__Account__r.Pan_Number__c,EAE_Renewal_Date_in_days__c,genesis__Account__r.Branch_Code__c,Id,Cibil_Charges__c,Processing_Charges__c,Charge_collection_done__c,Service_Type_Name__c,Branch_Code__c,genesis__Account__c,genesis__Account__r.Drawing_Power__c,
                   (SELECT Id,Recommended_Limit__c,Account_Number__c FROM Facilities__r),
                   (SELECT Id,genesis__Party_Account_Name__r.CBS_Customer_ID__c FROM genesis__Application_Parties__r),
                   (SELECT Id,genesis__Collateral__c FROM Application_Collateral__r WHERE genesis__Collateral__r.FE_Created__c = true)
                   FROM genesis__Applications__c WHERE Id =: appId];
            System.debug('ServiceType:::'+app.Service_Type_Name__c);
            if((app.Service_Type_Name__c == null || app.Service_Type_Name__c == 'Dedupe_Check') && app.Type__c.contains('NTB')){
                if(custCBSId != '')
                    cbsCustId = custCBSId;
                else if(app.genesis__Account__r.CBS_Customer_ID__c != null)
                    cbsCustId = app.genesis__Account__r.CBS_Customer_ID__c;
                
                dedupeCheck(app);
            }
            else if((app.Service_Type_Name__c == null && app.Type__c.contains('ETB')) || app.Service_Type_Name__c == 'Loan_Account_Creation'){
                createLoanAccount(app,true);
            }
            else if(app.Service_Type_Name__c == 'Customer_Linkage'){
                keyPersonLinkage(appId);
            }
            else if(app.Service_Type_Name__c == 'CollateralDlink' && app.Type__c == 'ETB-WC'){
                coll_D_Link(app,true);
            }
            else if(app.Service_Type_Name__c == 'CollateralCreation'){
                collCreation(app,true);
            }
            else if(app.Service_Type_Name__c == 'LimitUpdation'){
                limitUpdation(appId,false);
            }
            else if(app.Service_Type_Name__c == 'CollateralLinkage'){
                collLinkage(app,true);
            }
            else if(app.Service_Type_Name__c == 'ChargeCollection'){
                chargeCollection(app,true);
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    
    public static List<CBS_API_Log__c> coll_D_Link(genesis__Applications__c app,Boolean reTry){
        List<CBS_API_Log__c> cbsLogList         = new List<CBS_API_Log__c>();
        try{
            List<Facility__c> facList   = new List<Facility__c>();
            facList = [SELECT Id,Existing_Limit__c,Application__r.Branch_Name__c,Account_Number__c,Application__r.genesis__Account__r.Drawing_Power__c,Application__r.Branch_Code__c FROM Facility__c WHERE Application__c =: app.Id AND RecordType.developerName = 'Parent' AND Active__c = true];
            List<SME_CBS_EAE_Formatter.RequestFormat> dLinkReqList = new List<SME_CBS_EAE_Formatter.RequestFormat>();
            if(!facList.isEmpty()){
                for(Facility__c facility : facList){
                    SME_CBS_EAE_Formatter.RequestFormat dLink = new SME_CBS_EAE_Formatter.RequestFormat();
                    dLink.exe_tenantId                                 = 'cuecent_tenant';
                    dLink.owner_tenantId                               = 'cuecent_tenant';
                    dLink.inputVariables                               = new SME_CBS_EAE_Formatter.cls_inputVariables();
                    dLink.inputVariables.in_msg                        = new SME_CBS_EAE_Formatter.cls_in_msg();
                    dLink.inputVariables.in_msg.Channel                = 'BRN';
                    dLink.inputVariables.in_msg.ExternalReferenceNo    = String.valueOf(System.now().millisecond());
                    dLink.inputVariables.in_msg.TransactionBranch      = app.Branch_Code__c != null ? app.Branch_Code__c : '';
                    dLink.inputVariables.in_msg.AccountNo              = facility.Account_Number__c != null ? String.valueOf(facility.Account_Number__c) : '';
                    dLink.inputVariables.in_msg.ExtUniqueRefId         = String.valueOf(System.now().millisecond());
                    dLink.inputVariables.in_msg.BranchCode             = app.Branch_Code__c != null ? app.Branch_Code__c : '';
                    dLink.inputVariables.in_msg.ServiceTypeId          = '1';
                    dLink.inputVariables.in_msg.ServiceTypeName        = 'CollateralDlink';
                    
                    dLinkReqList.add(dLink);
                }
            }
            if(dLinkReqList.size() > 0){
                app.Service_Type_Name__c = 'CollateralDlink';
                for(SME_CBS_EAE_Formatter.RequestFormat dLink : dLinkReqList){
                    cbsLogList.addAll(d_LinkCallout(JSON.serialize(dLink),app));
                }
            }
            if(dLinkFlag){
                //Collateral Creation
                cbsLogList.addAll(collCreation(app,false));
                app.Service_Type_Name__c = 'CollateralCreation';
            }
            if(reTry){
                INSERT cbsLogList;
                ApplicationTriggerHandler.IsFirstRun = false;
                UPDATE app;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN cbsLogList;
    }
    public static List<CBS_API_Log__c> d_LinkCallout(String reqString,genesis__Applications__c app){
        try{
            system.debug('reqString:::'+reqString);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            system.debug('dLinkEndPoint:::'+Utility.getEndpoint('EAE_D_Link'));
            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('EAE_D_Link'), 'POST', null,reqString,headerMap,label.CA_CERTIFICATE);
            System.debug('response'+response);
            String jsonString = response.getBody();
            system.debug('jsonString:::'+jsonString);
            SME_CBS_EAE_Formatter.ResponseFormat res                = (SME_CBS_EAE_Formatter.ResponseFormat)JSON.deserialize(jsonString, SME_CBS_EAE_Formatter.ResponseFormat.Class);
            RETURN responseHandler(res,app,'CollateralDlink');
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            RETURN new List<CBS_API_Log__c>();
        }
    }
    public static List<CBS_API_Log__c> responseHandler(SME_CBS_EAE_Formatter.ResponseFormat res,genesis__Applications__c app,String serviceType){
        List<CBS_API_Log__c> cbsLogList =  new List<CBS_API_Log__c>();
        try{
            serviceType = app.Service_Type_Name__c == null ? 'CollateralDlink' : app.Service_Type_Name__c;
            List<SME_CBS_EAE_Formatter.cls_Success> successList     =  new List<SME_CBS_EAE_Formatter.cls_Success>();
            List<SME_CBS_EAE_Formatter.cls_Failure> failedList      =  new List<SME_CBS_EAE_Formatter.cls_Failure>();
            
            if(res.out_msg.Success != null) successList             =  res.out_msg.Success;
            if(res.out_msg.Failure != null) failedList              =  res.out_msg.Failure;
            
            if(successList.size() > 0){
                List<SME_CBS_EAE_Formatter.cls_Collateral> collateralList;
                for(SME_CBS_EAE_Formatter.cls_Success success : successList){
                    if(serviceType == 'CollateralLinkage')
                        collLinkageFlag = true;
                    
                    collateralList                                  =  new List<SME_CBS_EAE_Formatter.cls_Collateral>();
                    collateralList                                  = success.ODLimitLinkResponse.CollateralDetails.Collateral;
                    if(!collateralList.isEmpty()){
                        if(app.Service_Type_Name__c == 'LimitUpdation') serviceType = 'CollateralLinkage';
                        if(app.Service_Type_Name__c == 'CollateralLinkage') serviceType = 'ChargeCollection';
                        
                        for(SME_CBS_EAE_Formatter.cls_Collateral coll: collateralList){
                            CBS_API_Log__c cbsApiLog                =  new CBS_API_Log__c();
                            cbsApiLog.Service_Type_Name__c          =  serviceType;
                            cbsApiLog.Collateral_Code__c            =  Utility.getBlankStringIfNull(coll.CollateralCode);
                            cbsApiLog.Linked__c                     =  Utility.getBlankStringIfNull(coll.Linked);
                            cbsApiLog.Description__c                =  Utility.getBlankStringIfNull(coll.Description);
                            cbsApiLog.Collateral_ID__c              =  Utility.getBlankStringIfNull(coll.CollateralID);
                            cbsApiLog.Drawing_Power_Update__c       =  Utility.getBlankStringIfNull(coll.DrawingPowerUpdate);
                            cbsApiLog.Collateral_Degree__c          =  Utility.getBlankStringIfNull(coll.CollateralDegree);
                            cbsApiLog.Lendable_Value__c             =  Utility.getBlankStringIfNull(coll.LendableValue);
                            cbsApiLog.Collateral_Value__c           =  Utility.getBlankStringIfNull(coll.CollateralValue);
                            cbsApiLog.Account_No__c                 =  Utility.getBlankStringIfNull(success.ODLimitLinkResponse.AccountNo);
                            cbsApiLog.Limit_Amount__c               =  Utility.getBlankStringIfNull(success.ODLimitLinkResponse.LimitAmount);
                            cbsApiLog.Ext_Unique_Ref_Id__c          =  Utility.getBlankStringIfNull(success.ODLimitLinkResponse.ExtUniqueRefId);
                            cbsApiLog.Limit_No__c                   =  Utility.getBlankStringIfNull(success.ODLimitLinkResponse.LimitNo);
                            cbsApiLog.Customer_Name__c              =  Utility.getBlankStringIfNull(success.ODLimitLinkResponse.CustomerName);
                            cbsApiLog.ExternalReferenceNo__c        =  Utility.getBlankStringIfNull(success.ODLimitLinkResponse.Status.ExternalReferenceNo);
                            cbsApiLog.Application__c                = app.Id;
                            cbsApiLog.API_Name__c                   = serviceType;
                            cbsApiLog.Sequence_No__c                = '15';
                            cbsApiLog.Status__c                     = serviceType+' Success';
                            cbsApiLog.Success_Error_Message__c      = res.out_msg.ErrorMessage;
                            cbsLogList.add(cbsApiLog);
                        }
                    }
                }
            }
            if(failedList.size() > 0){
                for(SME_CBS_EAE_Formatter.cls_Failure failure : failedList){
                    if(failure.ErrorMessage != null && failure.ErrorMessage == 'No limit/More than one limit for this Account'){
                        collLinkageFlag = true;
                    }
                    else
                        collLinkageFlag = false;
                    
                    if(failure.ErrorMessage != null && serviceType == 'CollateralDlink' && (failure.ErrorMessage == 'No Live Limit in CBS' || failure.ErrorMessage == 'No Collateral attached for this AccountNumber')){
                        dLinkFlag = true;
                    }
                    else
                        dLinkFlag = false;
                    
                    CBS_API_Log__c cbsApiLog                = new CBS_API_Log__c();
                    cbsApiLog.Failure_Error_Code__c         = Utility.getBlankStringIfNull(failure.ErrorCode);
                    cbsApiLog.Failure_Error_Message__c      = Utility.getBlankStringIfNull(failure.ErrorMessage);
                    cbsApiLog.Response__c                   = Utility.getBlankStringIfNull(failure.Response);
                    if(failure.Reason != null){
                        cbsApiLog.Reason_Message__c         = Utility.getBlankStringIfNull(failure.Reason.Message);
                        cbsApiLog.Reason_Code__c            = Utility.getBlankStringIfNull(failure.Reason.Code);
                    }
                    if(failure.CallBackData != null){
                        serviceType                         = Utility.getBlankStringIfNull(failure.CallBackData.ServiceTypeName);
                        cbsApiLog.Service_Type_Name__c      = serviceType;
                        cbsApiLog.Account_No__c             = Utility.getBlankStringIfNull(failure.CallBackData.AccountNo);
                        cbsApiLog.Service_Type_Id__c        = Utility.getBlankStringIfNull(failure.CallBackData.ServiceTypeId);
                    }
                    cbsApiLog.bpms_error_msg__c             = Utility.getBlankStringIfNull(res.bpms_error_msg);
                    cbsApiLog.Application__c                = app.Id;
                    cbsApiLog.API_Name__c                   = serviceType;
                    cbsApiLog.Sequence_No__c                = '15';
                    cbsApiLog.Status__c                     = serviceType+' Error';
                    cbsApiLog.Success_Error_Message__c      = res.out_msg.ErrorMessage;
                    cbsLogList.add(cbsApiLog);
                }
            }
            if(app.Service_Type_Name__c == 'Loan_Account_Creation' && res.out_msg != null){
                serviceType                                 = app.Service_Type_Name__c;
                if(res.out_msg.ErrorCode != null && res.out_msg.ErrorCode == '0'){
                    CBS_API_Log__c cbsApiLog                = new CBS_API_Log__c();
                    cbsApiLog.Success_Error_Message__c      = res.out_msg.ReplyText;
                    cbsApiLog.Application__c                = app.Id;
                    cbsApiLog.API_Name__c                   = serviceType;
                    cbsApiLog.Sequence_No__c                = '16';
                    cbsApiLog.Status__c                     = serviceType+'_Success';
                    cbsApiLog.Service_Type_Name__c          = serviceType;
                    cbsLogList.add(cbsApiLog);
                }
                else{
                    CBS_API_Log__c cbsApiLog                = new CBS_API_Log__c();
                    cbsApiLog.Success_Error_Message__c      = res.out_msg.ReplyText;
                    cbsApiLog.Application__c                = app.Id;
                    cbsApiLog.API_Name__c                   = serviceType;
                    cbsApiLog.Sequence_No__c                = '16';
                    cbsApiLog.Status__c                     = serviceType+'_Failure';
                    cbsApiLog.Service_Type_Name__c          = serviceType;
                    cbsLogList.add(cbsApiLog);
                }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN cbsLogList;
    }
    public static CBS_API_Log__c getLogRecord(genesis__Applications__c app){
        CBS_API_Log__c cbsLog   = new CBS_API_Log__c();
        try{
            String serviceType      = app.Service_Type_Name__c;
            String appId            = app.Id;
            Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get('CBS_API_Log__c' ).getDescribe().fields.getMap();
            
            String query = 'SELECT ';
            for(Schema.SObjectField s : accountFieldMap.values()){
                query = query + s.getDescribe().getName()+',';
            }
            query           = query.removeEnd(',');
            query           = query + ' FROM CBS_API_Log__c WHERE Service_Type_Name__c =: serviceType AND Application__c =: appId LIMIT 1';
            System.debug('query:::'+query);
            cbsLog          = Database.query(query);
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN cbsLog;
    }
    public static List<CBS_API_Log__c> collCreation(genesis__Applications__c app,Boolean reTry){
        List<CBS_API_Log__c> cbsApiLogList                              = new List<CBS_API_Log__c>();
        try{
            List<genesis__Application_Collateral__c> collList               = new List<genesis__Application_Collateral__c>();
            collList = [SELECT Id,Name,genesis__Collateral__r.Property_expiry_date_lease__c,genesis__Collateral__r.Security_Info__c,genesis__Collateral__r.Nature_of_Property__c,genesis__Collateral__r.Type_Of_Property__c,genesis__Collateral__r.clcommon__Value__c,Facility__r.Account_Number__c,genesis__Collateral__r.Location_Of_The_Property__c,genesis__Collateral__r.Area_Square_Feet__c,Application__r.Branch_Code__c,genesis__Collateral__r.Valuation_Date__c FROM genesis__Application_Collateral__c WHERE Application__c =: app.Id];
            Collateral_Creation_Helper_HL collCreateObj                     = new Collateral_Creation_Helper_HL();
            collCreateObj.exe_tenantId                                      = 'cuecent_tenant';
            collCreateObj.owner_tenantId                                    = 'cuecent_tenant';
            collCreateObj.inputVariables                                    = new Collateral_Creation_Helper_HL.cls_inputVariables();
            collCreateObj.inputVariables.in_msg                             = new Collateral_Creation_Helper_HL.cls_in_msg();
            collCreateObj.inputVariables.in_msg.serviceName                 = 'Loan_Collateral_Creation_HL';
            System.debug('After Loan_Collateral_Creation_HL');
            collCreateObj.inputVariables.in_msg.ApplicationId               = app.Id;
            collCreateObj.inputVariables.in_msg.CollateralCreationDetails   = new List<Collateral_Creation_Helper_HL.cls_CollateralCreationDetails>();
            for(Integer i = 0; i < collList.size() ; i++){
                Collateral_Creation_Helper_HL.cls_CollateralCreationDetails collDetails = new Collateral_Creation_Helper_HL.cls_CollateralCreationDetails();
                String prpType                          = '0';
                String accNo                            = collList.get(i).Facility__c != null ? collList.get(i).Facility__r.Account_Number__c : '';
                System.debug('accNo-->>>> ' + accNo);
                if(collList.get(i).genesis__Collateral__r.Type_Of_Property__c == 'FreeHold') prpType = '0';
                if(collList.get(i).genesis__Collateral__r.Type_Of_Property__c == 'Leased') prpType = '1';
                
                collDetails.ApplicantId                 = app.genesis__Account__c;
                collDetails.Channel                     = 'BRN';
                collDetails.TransactionBranch           = app.Branch_Code__c;
                //collDetails.CollateralID                = accNo.subString(0,7)+accNo.subString(12,16)+String.valueOf(i + 10);
                collDetails.CollateralID                = collList.get(i).Name.replace('-','');//collList.get(i).Name.Split('-')[1];
                collDetails.CollateralCode              = '107';//For Land & Building
                collDetails.BranchCode                  = collList.get(i).Application__r.Branch_Code__c;
                collDetails.DocumentCode                = collList.get(i).Facility__r.Account_Number__c;  
                collDetails.FlgOperation                = 'A'; 
                
                collDetails.TypeofCharge                = '1';
                collDetails.NameofLender                =  '';
                
                collDetails.OriginalValue               = String.valueOf(collList.get(i).genesis__Collateral__r.clcommon__Value__c);
                collDetails.LastValue                   = String.valueOf(collList.get(i).genesis__Collateral__r.clcommon__Value__c);
                collDetails.MarketValue                 = String.valueOf(collList.get(i).genesis__Collateral__r.clcommon__Value__c);
                collDetails.DatOrginalValuation         = collList.get(i).genesis__Collateral__r.Valuation_Date__c != null ? getDateString(collList.get(i).genesis__Collateral__r.Valuation_Date__c) : '';//'20160926';
                collDetails.DatLastValuation            = collList.get(i).genesis__Collateral__r.Valuation_Date__c != null ? getDateString(collList.get(i).genesis__Collateral__r.Valuation_Date__c ) : '';
                
                collDetails.DeedStatus                  = '0';
                collDetails.CustodianName               = '';
                collDetails.DateDeedsSent               = '';
                collDetails.ExpectedReturnDate          = '';
                collDetails.DeedDetails                 = 'Land and Building';
                collDetails.RegisteringAuth             =  '';
                collDetails.InsurancePlanCode           =  '';
                collDetails.InsurancePolicyNumber       =  ''; 
                collDetails.InsurancePremiumBilling     =  ''; 
                collDetails.BillingMode                 =  ''; 
                collDetails.Percentage                  =  ''; 
                collDetails.PremiumBilingAccount        =  ''; 
                collDetails.InsurancePremiumAmount      =  ''; 
                collDetails.NonStandardCollId           =  ''; 
                collDetails.Description1                =  ''; 
                collDetails.Description2                =  ''; 
                collDetails.ChasisNumber                =  ''; 
                collDetails.EngineNumber                =  ''; 
                collDetails.RegistrationNumber          =  ''; 
                collDetails.ModelNumber                 =  ''; 
                collDetails.YearofMfg                   =  ''; 
                collDetails.DescriptionAuto1            =  ''; 
                collDetails.DescriptionAuto2            =  ''; 
                collDetails.SecurityCode                =  ''; 
                collDetails.NumberofUnits               =  ''; 
                collDetails.SeriesNumber1               =  ''; 
                collDetails.SeriesNumber2               =  ''; 
                
                collDetails.Location                    = collList.get(i).genesis__Collateral__r.Location_Of_The_Property__c != null ? String.valueOf(collList.get(i).genesis__Collateral__r.Location_Of_The_Property__c) : 'Semi Urban';
                collDetails.AreaUnit                    = 'Per Square Feet';
                collDetails.TotalArea                   = String.valueOf(Integer.valueOf(collList.get(i).genesis__Collateral__r.Area_Square_Feet__c));
                collDetails.TypeofProperty              = prpType;
                collDetails.DatLeaseExpiry              = prpType != '0' && collList.get(i).genesis__Collateral__r.Property_expiry_date_lease__c != null ? getDateString(collList.get(i).genesis__Collateral__r.Property_expiry_date_lease__c) : '';
                collDetails.ForcedSaleValue             = '0';
                collDetails.QuitRentValue               = '0';
                collDetails.DescriptionProp1            = collList.get(i).genesis__Collateral__r.Nature_of_Property__c != null ? collList.get(i).genesis__Collateral__r.Nature_of_Property__c.replace('&','') : '';
                collDetails.DescriptionProp2            = collList.get(i).genesis__Collateral__r.Nature_of_Property__c != null ? collList.get(i).genesis__Collateral__r.Nature_of_Property__c.replace('&','') : '';
                //Max length for DescriptionProp1 120 char
                
                collDetails.Make                        = '';
                collDetails.SLNum                       = '';
                collDetails.RegNo                       = '';
                collDetails.EngNo                       = '';
                collDetails.HPCapacity                  = '';
                collDetails.MachDesciption              = '';
                collDetails.AreaCult                    = '';
                collDetails.AreaLand                    = '';
                collDetails.DetailsCult                 = '';
                collDetails.VillageNam                  = '';
                collDetails.SurveyNo                    = '';
                collDetails.SecDescription1             = '';
                collDetails.SecDescription2             = '';
                collDetails.Breed                       = '';
                collDetails.Age                         = '';
                collDetails.Quantity                    = '';
                collDetails.CatDescription1             = '';
                collDetails.CatDescription2             = '';
                collDetails.IdentMArk                   = '';
                collDetails.ASNAcctNumber               = '';
                collDetails.TotNumUnits                 = '';
                collDetails.CertNumber                  = '';
                collDetails.CertNumber1                 = '';
                collDetails.CertNumber2                 = '';
                collDetails.CertNumber3                 = '';
                collDetails.CertNumber4                 = '';
                collDetails.DivDate                     = '';
                collDetails.SecurityCodec               = '';
                collDetails.GrossWeight                 = '';
                collDetails.NetWeight                   = '';
                collDetails.AppraiserValue              = '';
                collDetails.DateValuation               = collList.get(i).genesis__Collateral__r.Valuation_Date__c != null ? getDateString(collList.get(i).genesis__Collateral__r.Valuation_Date__c) : '';
                collDetails.DescCommodity               = '';
                collDetails.ExtUniqueRefId              = collList.get(i).Facility__r.Account_Number__c +(i+1);
                
                collCreateObj.inputVariables.in_msg.CollateralCreationDetails.add(collDetails);
            }
            cbsApiLogList.addAll(collCreationCallout(JSON.serialize(collCreateObj),app));
            if(reTry){
                INSERT cbsApiLogList;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN cbsApiLogList;
    }
    public static List<CBS_API_Log__c> collCreationCallout(String reqString,genesis__Applications__c app){
        List<CBS_API_Log__c> cbsApiLogList = new List<CBS_API_Log__c>();
        try{
            system.debug('reqString:::'+reqString);
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            System.debug('CollCreationEndPoint:::'+Utility.getEndpoint('EAE_Colll_Creation'));
            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('EAE_Colll_Creation'), 'POST', null,reqString,headerMap,label.CA_CERTIFICATE);
            String jsonString = response.getBody();
            system.debug('jsonString:::'+jsonString);
            Collateral_Creation_Helper_HL.CBS_ColletralCreation_response  res = (Collateral_Creation_Helper_HL.CBS_ColletralCreation_response)JSON.deserialize(jsonString, Collateral_Creation_Helper_HL.CBS_ColletralCreation_response.Class);
            System.debug('CollCreationResponse:::'+res);
            if(res.out_msg.Status_Desc != null){
                CBS_API_Log__c cbsLog                   = new CBS_API_Log__c();    
                cbsLog.Application__c                   = app.Id;
                cbsLog.API_Name__c                      = 'CollateralCreation';
                cbsLog.Status__c                        = 'Collateral Creation_SentStatus_'+ res.out_msg.Status_Desc;
                cbsLog.Success_Error_Message__c         = res.out_msg.Status_Desc;
                if(app.recordType.DeveloperName == 'SME_NEW_Loan') cbsLog.Sequence_No__c = '16';
                else cbsLog.Sequence_No__c              = '15'; 
                cbsApiLogList.add(cbsLog);
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN cbsApiLogList;
    }
    @future(callout = true)
    webService static void limitUpdation(String appId,Boolean explicitCall){
        try{
            Date endDate;
            genesis__Applications__c app = new genesis__Applications__c();
            app = [SELECT Name,RecordType_Developer_Name__c,genesis__Rate_Floor__c,genesis__Additional_Cash_Required__c ,Application_Stage__c,Legal_desk_state_flag__c,OwnerId,OD_limit_creation_updation__c,RecordType.developerName,EAE_Renewal_Date_in_days__c,genesis__Account__r.Branch_Code__c,Id,Cibil_Charges__c,Processing_Charges__c,Charge_collection_done__c,Service_Type_Name__c,Branch_Code__c,genesis__Account__c,genesis__Account__r.Drawing_Power__c,Type__c,
                   (SELECT Id,Recommended_Limit__c,Account_Number__c FROM Facilities__r),
                   (SELECT Id,genesis__Collateral__c FROM Application_Collateral__r WHERE genesis__Collateral__r.FE_Created__c = true)
                   FROM genesis__Applications__c WHERE Id =: appId];
            
            String Land_And_Building_RT= Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Building').getRecordTypeId();
            String Land_And_Building_Other_RT= Schema.SObjectType.clcommon__Collateral__c.getRecordTypeInfosByName().get('Land And Buildings - Other').getRecordTypeId();
            List<genesis__Application_Collateral__c>  allAppCollateral= [SELECT Id,Application__c,genesis__Collateral__r.FE_Created__c from genesis__Application_Collateral__c where Application__c =: appId AND genesis__Collateral__r.FE_Created__c= true AND (genesis__Collateral__r.RecordTypeId =:Land_And_Building_RT OR genesis__Collateral__r.RecordTypeId=:Land_And_Building_Other_RT) AND genesis__Collateral__r.Category_of_Loan__c IN ('Outright purchase of building','Purchase of land and construction there on')];
            
            if(!app.OD_limit_creation_updation__c){
                
                List<CBS_API_Log__c> logList = new List<CBS_API_Log__c>();
                Set<String> bmBranchCodeSet = new Set<String>();
                List<Facility__c> facilityList = new List<Facility__c>();
                facilityList = SOQL_Util.getFacilityList(new List<String>{app.Id});
                List<MCLR_Master__c> mclrRecordList = new List<MCLR_Master__c>();
                mclrRecordList = [
                    SELECT Id, Name, COD_Term_From__c, COD_Term_To__c, Effective_Date__c, Expiry_Date__c, Interest_Rate_Reset__c, Int_ID__c, MCLR_Of_Interest__c
                    FROM MCLR_Master__c];
                if (!facilityList.isEmpty()) {
                    for (Facility__c facility : facilityList) {
                        bmBranchCodeSet.add(facility.Application__r.genesis__Account__r.Branch_Code__c);
                    }
                }
                Map<String, String> bmCodeEmpCodeMap = new Map<String, String>();
                for (User u : [SELECT Id,Office_Code__c,EmployeeNumber FROM User WHERE Office_Code__c IN :bmBranchCodeSet AND Role_Name__c = 'Manager']) {
                    bmCodeEmpCodeMap.put(u.Office_Code__c, u.EmployeeNumber);
                }
                Boolean limitUpdatedFlag        = true;
                Decimal currentMCLR             = 0.0;
                Integer daysDifference          = 0;
                Decimal oneYrMCLR               = 0.0;
                Decimal lmitAmtToUpdate         = 0.0;
                if (!facilityList.isEmpty()) {
                    for (Facility__c facility : facilityList) {
                        if (!facility.Application__r.OD_limit_creation_updation__c) {
                            if (app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ADHOC || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_EXCEEDING || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT) {
                                endDate                                         = System.today().addDays(Integer.valueOf(app.EAE_Renewal_Date_in_days__c));    
                            }else if(app.RecordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                endDate                                         = System.today().addDays(365);
                            }else {
                                endDate                                         = facility.Limit_end_date__c;    
                            }
                            if (explicitCall) {
                                lmitAmtToUpdate                                 = facility.Existing_Limit__c;
                            }else if (app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ADHOC) {
                                lmitAmtToUpdate                                 = facility.Recommended_Limit__c - facility.Existing_Limit__c;
                            }else if(app.RecordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE && (facility.NTB_Facility_Type__c == 'WC KVB' || facility.NTB_Facility_Type__c == 'New' || facility.NTB_Facility_Type__c == 'Renewal' || facility.NTB_Facility_Type__c == 'WC Others')) {
                                lmitAmtToUpdate                                 = facility.Limit_Amount__c;
                            }else{
                                lmitAmtToUpdate                                 = facility.Recommended_Limit__c;
                            }
                            System.debug('lmitAmtToUpdate::'+lmitAmtToUpdate);
                            CBS_OD_TOD_Formatter.RequestFormat cbsReqObj = new CBS_OD_TOD_Formatter.RequestFormat();
                            cbsReqObj.exe_tenantId                              = 'cuecent_tenant';
                            cbsReqObj.owner_tenantId                            = 'cuecent_tenant';
                            cbsReqObj.inputVariables                            = new CBS_OD_TOD_Formatter.cls_inputVariables();
                            cbsReqObj.inputVariables.in_msg                     = new CBS_OD_TOD_Formatter.cls_in_msg();
                            cbsReqObj.inputVariables.in_msg.AccountNo           = facility.Account_Number__c != null ? facility.Account_Number__c : '';
                            cbsReqObj.inputVariables.in_msg.MaintenanceMode     = 'M';
                            cbsReqObj.inputVariables.in_msg.LimitStartDate      = facility.Limit_start_date__c != null ? (facility.Limit_start_date__c).format() : '';
                            cbsReqObj.inputVariables.in_msg.LimitEndDate        = endDate.format();
                            cbsReqObj.inputVariables.in_msg.LimitAmount         = String.valueOf(lmitAmtToUpdate);
                            cbsReqObj.inputVariables.in_msg.SecuredFlag     = 'Y';
                            cbsReqObj.inputVariables.in_msg.InterestIndexCode   = '9990';//Interest code will be same always--9990---Changed later to ''
                            cbsReqObj.inputVariables.in_msg.InterestRate        = '';//facility.Recommended_Rate__c != null ? String.valueOf(facility.Recommended_Rate__c) : '';
                            if(app.RecordType.developerName == 'SME_Renewal' || app.RecordType.developerName == 'SME_AdHoc'){
                                if(facility.Application__r.Next_Renewal_Date__c != null){
                                    daysDifference = System.today().daysBetween(facility.Application__r.Next_Renewal_Date__c) + 1;
                                    System.debug('daysDifference:::' + daysDifference);
                                    if (!mclrRecordList.isEmpty()) {
                                        for (MCLR_Master__c mcleRec : mclrRecordList) {
                                            if (mcleRec.COD_Term_From__c >= 365) {
                                                oneYrMCLR = Utility.isNullOrZeroDecimal(mcleRec.MCLR_Of_Interest__c);
                                            }
                                            if ((mcleRec.COD_Term_From__c != null && mcleRec.COD_Term_To__c != null)
                                                && daysDifference >= mcleRec.COD_Term_From__c && daysDifference <= mcleRec.COD_Term_To__c) {
                                                    currentMCLR = Utility.isNullOrZeroDecimal(mcleRec.MCLR_Of_Interest__c);
                                                }
                                        }
                                    }
                                }
                                cbsReqObj.inputVariables.in_msg.InterestVariance = String.valueOf(Utility.isNullOrZeroDecimal(facility.Final_Spread__c) + (oneYrMCLR - currentMCLR));
                            }
                            else{
                                cbsReqObj.inputVariables.in_msg.InterestVariance = String.valueOf(Utility.isNullOrZeroDecimal(facility.Final_Spread__c));
                            }
                            cbsReqObj.inputVariables.in_msg.MakerID         = 'DTMAKER';
                            cbsReqObj.inputVariables.in_msg.CheckerID       = 'DTCHECKER';
                            System.debug('oneYrMCLR:::' + oneYrMCLR);
                            System.debug('currentMCLR:::' + currentMCLR);
                            System.debug('InterestVariance:::' + cbsReqObj.inputVariables.in_msg.InterestVariance);
                            
                            logList.add(LimitUpdationCallout(JSON.serialize(cbsReqObj), app));
                        }
                    }
                }
                for (CBS_API_Log__c log : logList) {
                    if (log.Status__c != 'Success') limitUpdatedFlag = false;
                    
                }
                if (limitUpdatedFlag && !explicitCall){
                    
                    logList.addAll(collLinkage(app, false));
                }
                if (!logList.isEmpty()) INSERT logList;
                if(limitUpdatedFlag){
                    ApplicationTriggerHandler.IsFirstRun        = false;
                    if(app.RecordType.DeveloperName == 'SME_Renewal' && app.Application_Stage__c == 'E-sign pending'){
                        app.Application_Stage__c = 'Limit extended';
                    }
                    else{
                        app.Application_Stage__c = 'Limit Opened';
                        if(app.Type_of_Application__c=='Composite' || app.Type_of_Application__c=='Term Loan'){
                            SOQL_Util.createTaskForBM(app.id,'SI/Emandate Details','Verify SI/Emandate Details');
                            SOQL_Util.createTaskForBM(app.Id,'Validate Post Disbursement Details','Validate Post Disbursement Details');
                            try{
                                    SME_SendSMSService.sendSMSApp_SME(new Set<String>{app.Id});
                            }
                            catch(Exception e){
                                System.debug(e.getMessage());
                                System.debug(e.getLineNumber());
                                System.debug(e.getStackTraceString());
                            }
                        }
                        if((Underwriting_CTRL_Helper.checkIfLandAndBuildingOrOtherCollateralExist(app.Id) && (app.Type__c != null && app.Type__c.contains('Takeover'))) || (app.RecordType_Developer_Name__c== 'SME_NEW_Loan' && allAppCollateral.size()>0)){
                            List<User> listofUser  = SOQL_Util.getBRCreditOfficer(app.Id);
                            if(listofUser !=null && !listofUser.isEmpty()){
                                SOQL_Util.createTaskForBRCreditOfficer(app.Id,listofUser[0].id,'MOD Needed','MOD Needed');    
                            }else{
                                SOQL_Util.createTaskForBM(app.Id,'MOD Needed','MOD Needed'); 
                            }
                        }
                    }  
                    app.Sub_Stage__c = 'Limit Opened';
                    app.OD_limit_creation_updation__c           =true;
                    update app;
                }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    //Helper method to make callout for OD Limit creation/Modification and OD/TOD Limit Varience
    public static CBS_API_Log__c LimitUpdationCallout(String custData,genesis__Applications__c app){
        CBS_API_Log__c log;
        try{
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            System.debug(Utility.getEndpoint('CBS_CASA_EAE'));
            System.debug('reqJSON::'+custData);
            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('CBS_CASA_EAE'), 'POST', null,custData,headerMap,label.CA_CERTIFICATE);
            system.debug('$$$$'+response.getBody());
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                CBS_OD_TOD_Formatter.ResponseFormat res = (CBS_OD_TOD_Formatter.ResponseFormat)Json.deserialize(jsonString, CBS_OD_TOD_Formatter.ResponseFormat.class);
                system.debug('###'+res.out_msg.ErrorCode);
                log                                 = new CBS_API_Log__c();    
                log.Application__c                  = app.Id;
                log.API_Name__c                     = 'LimitUpdation';
                if(app.recordType.developerName == 'SME_NEW_Loan'){
                    log.Sequence_No__c              = '16';     
                }
                else
                    log.Sequence_No__c              = '15'; 
                
                
                if(res.out_msg.ErrorCode != null && res.out_msg.ErrorCode == '0'){
                    log.Status__c                   = 'Success';
                    log.Success_Error_Message__c    = res.out_msg.ReplyText;
                }
                else{
                    log.Status__c                   = 'Failure';
                    log.Success_Error_Message__c    = res.out_msg.ReplyText;
                }
            }
            else{
                log.Application__c                  = app.Id;
                log.API_Name__c                     = 'OD/TOD_SME';
                log.Status__c                       = 'Failure';
                log.Success_Error_Message__c        = 'OD/TOD_SME_NO_HIT';
                if(app.recordType.developerName == 'SME_NEW_Loan'){
                    log.Sequence_No__c              = '16';     
                }
                else
                    log.Sequence_No__c              = '15'; 
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN log;
    }
    public static List<CBS_API_Log__c> collLinkage(genesis__Applications__c app,Boolean reTry){
        List<CBS_API_Log__c> logList                                = new List<CBS_API_Log__c>();
        try{
            List<genesis__Application_Collateral__c> collList = new List<genesis__Application_Collateral__c>();
            List<Facility__c> facilityList                              = new List<Facility__c>();
            Date endDate;
            
            collList = [SELECT Id,Name,genesis__Collateral__r.clcommon__Value__c,genesis__Collateral__r.Security_Info__c,genesis__Collateral__r.clcommon__Collateral_Name__c,Facility__r.Account_Number__c FROM genesis__Application_Collateral__c WHERE Application__c =: app.Id];
            facilityList = SOQL_Util.getFacilityList(new List<String>{app.Id});
            for(Facility__c facility : facilityList){
                if(app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ADHOC || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_EXCEEDING || app.RecordType.developerName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT)
                    endDate                                             = System.today().addDays(Integer.valueOf(app.EAE_Renewal_Date_in_days__c));
                else if(app.RecordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE)
                    endDate                                             = System.today().addDays(365);
                else
                    endDate                                             = facility.Limit_end_date__c;
                
                SME_CBS_EAE_Formatter.RequestFormat collCreate = new SME_CBS_EAE_Formatter.RequestFormat();
                collCreate.exe_tenantId                                 = 'cuecent_tenant';
                collCreate.owner_tenantId                               = 'cuecent_tenant';
                collCreate.inputVariables                               = new SME_CBS_EAE_Formatter.cls_inputVariables();
                collCreate.inputVariables.in_msg                        = new SME_CBS_EAE_Formatter.cls_in_msg();
                collCreate.inputVariables.in_msg.Channel                = 'BRN';
                collCreate.inputVariables.in_msg.ExternalReferenceNo    = String.valueOf(System.now().millisecond());
                collCreate.inputVariables.in_msg.TransactionBranch      = app.Branch_Code__c != null ? app.Branch_Code__c : '';
                collCreate.inputVariables.in_msg.AccountNo              = facility.Account_Number__c != null ? facility.Account_Number__c : '';
                collCreate.inputVariables.in_msg.ExtUniqueRefId         = String.valueOf(System.now().millisecond());
                collCreate.inputVariables.in_msg.CollAddModDel          = '1';
                collCreate.inputVariables.in_msg.ServiceTypeName        = 'CollateralLinkage';
                collCreate.inputVariables.in_msg.ServiceTypeId          = '2';
                collCreate.inputVariables.in_msg.FlgInquire             = 'N';
                collCreate.inputVariables.in_msg.LimitStartDate         = facility.Limit_start_date__c != null ? (facility.Limit_start_date__c).format() : '';
                collCreate.inputVariables.in_msg.LimitEndDate           = endDate.format();//facility.Limit_end_date__c != null ? (facility.Limit_end_date__c).format() : '';
                //collCreate.inputVariables.in_msg.LimitNo              = '1';
                collCreate.inputVariables.in_msg.linkageDetails         = new List<SME_CBS_EAE_Formatter.cls_linkageDetails>();
                Integer counter                                         = 0;
                for(genesis__Application_Collateral__c coll : collList){
                    String accNo = coll.Facility__r.Account_Number__c;
                    SME_CBS_EAE_Formatter.cls_linkageDetails linkageDet = new SME_CBS_EAE_Formatter.cls_linkageDetails();
                    //linkageDet.CollateralID                             =  accNo.subString(0,7)+accNo.subString(12,16)+String.valueOf(counter + 10);
                    linkageDet.CollateralID                             = coll.Name.replace('-','');//coll.Name.Split('-')[1];
                    linkageDet.CollateralCode                           = '107';
                    linkageDet.CollateralDegree                         = 'P';
                    linkageDet.CollateralAmt                            = String.valueOf(coll.genesis__Collateral__r.clcommon__Value__c.round());
                    linkageDet.CollateralDesc                           = 'CollateralDesc';
                    linkageDet.LinkCollateral                           = 'Y';
                    
                    collCreate.inputVariables.in_msg.linkageDetails.add(linkageDet);
                    counter++;
                }
                logList.addAll(collLinkageCallOut(JSON.serialize(collCreate),app));
            }
            if(collLinkageFlag) logList.addAll(chargeCollection(app,false));
            if(reTry) INSERT logList;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN logList;
    }
    public static List<CBS_API_Log__c> collLinkageCallOut(String reqString,genesis__Applications__c app){
        system.debug('reqString:::'+reqString);
        List<CBS_API_Log__c> logList = new List<CBS_API_Log__c>();
        try{
            try{
                Map<String,String> headerMap                            = new Map<String,String>();
                headerMap.put('Content-Type','application/json');
                HTTPResponse response                                   = new HTTPResponse();
                response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('EAE_D_Link'), 'POST', null,reqString,headerMap,label.CA_CERTIFICATE);
                String jsonString = response.getBody();
                System.debug('jsonString ::'+jsonString);
                SME_CBS_EAE_Formatter.ResponseFormat res = (SME_CBS_EAE_Formatter.ResponseFormat)JSON.deserialize(jsonString, SME_CBS_EAE_Formatter.ResponseFormat.Class);
                logList = responseHandler(res,app,'CollateralLinkage');
            }
            catch(Exception e){
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN logList;
    }
    //Charge Collection API Callout
    public static List<CBS_API_Log__c> chargeCollection(genesis__Applications__c app,Boolean reTry){
        List<CBS_API_Log__c> logList        = new List<CBS_API_Log__c>();
        try{
            Decimal totalAmount                 = 0.0;
            Decimal gst                         = 0.0;
            Set<Id> collIdset                   = new Set<Id>();
            List<M21_A__c> m21_List             = new List<M21_A__c>();
            Decimal gstPercent  = KVB_Company_Details__c.getOrgDefaults().GST__c / 100;
            String CHARGE_COLLECTION_GL_TYPES = 'PRCH_CHG:LEGAL_FEE:VALU_FEE:CIBIL_FEE:STMP_FEE:CERSAI_FEE:DOC_FEE';
            
            if(app != null){
                if(!app.Charge_collection_done__c){
                    decimal recLimit = 0.0;
                    for(Facility__c fac : app.Facilities__r){
                        if(fac.Recommended_Limit__c != null)
                            recLimit += fac.Recommended_Limit__c;
                    }
                    //Value assignment
                    CBS_API_Log__c log = new CBS_API_Log__c();
                    CBS_ChargeCollaction_Formatter.RequestFormat cbsReqObj      = new CBS_ChargeCollaction_Formatter.RequestFormat();
                    cbsReqObj.exe_tenantId                                      = 'cuecent_tenant';
                    cbsReqObj.owner_tenantId                                    = 'cuecent_tenant';
                    cbsReqObj.inputVariables                                    = new CBS_ChargeCollaction_Formatter.cls_inputVariables();
                    cbsReqObj.inputVariables.in_msg                             = new CBS_ChargeCollaction_Formatter.cls_in_msg();
                    cbsReqObj.inputVariables.in_msg.Charges                     = new List<CBS_ChargeCollaction_Formatter.cls_Charges>();
                    
                    if(app.Facilities__r[0].Account_Number__c != null) cbsReqObj.inputVariables.in_msg.AccountNumber               = app.Facilities__r[0].Account_Number__c;
                    if(app.Branch_Code__c != null) cbsReqObj.inputVariables.in_msg.BranchCode                  = app.Branch_Code__c;
                    cbsReqObj.inputVariables.in_msg.ApplicationNumber           = app.Id;
                    cbsReqObj.inputVariables.in_msg.TransactionDate             = System.today().format();
                    cbsReqObj.inputVariables.in_msg.ValueDate                   = System.today().format();
                    cbsReqObj.inputVariables.in_msg.ApplicantName               = app.Name;
                    cbsReqObj.inputVariables.in_msg.Flg_Force_Debit             = 'Y';
                    if(app.Legal_desk_state_flag__c == true){
                        cbsReqObj.inputVariables.in_msg.Flg_StmpFee_Brn = 'N';
                    }
                    if(app.Legal_desk_state_flag__c == false){
                        cbsReqObj.inputVariables.in_msg.Flg_StmpFee_Brn = 'Y';
                    }
                    for(String chargeType : CHARGE_COLLECTION_GL_TYPES.split(':')){
                        CBS_ChargeCollaction_Formatter.cls_Charges charge   = new CBS_ChargeCollaction_Formatter.cls_Charges();
                        charge.GL_Type              = chargeType;
                        Decimal chargeAmount        = 0.0;
                        Decimal gstCharge           = 0.0;
                        if(chargeType == 'PRCH_CHG'){
                            if(app.RecordType.developerName == 'SME_NEW_Loan'){
                                if(app.genesis__Rate_Floor__c != null){
                                    Decimal prChg = app.Processing_Charges__c != null ? app.Processing_Charges__c : 0.0;
                                    chargeAmount        = (app.genesis__Rate_Floor__c - prChg).setScale(2);
                                    gstCharge           = (app.genesis__Rate_Floor__c * gstPercent).setScale(2);
                                    charge.ChargeAmount = chargeAmount;
                                    charge.GST_Charge   = gstCharge;
                                    totalAmount         += chargeAmount;
                                    totalAmount         += gstCharge;
                                }else{
                                    charge.ChargeAmount = 0.0;
                                    charge.GST_Charge   = 0.0;
                                }
                            }
                            else if(app.Processing_Charges__c != null){
                                system.debug('inside porcessing fee:::'+app.Processing_Charges__c);
                                chargeAmount        = (app.Processing_Charges__c).setScale(2);
                                gstCharge           = (app.Processing_Charges__c * gstPercent).setScale(2);
                                charge.ChargeAmount = chargeAmount;
                                charge.GST_Charge   = gstCharge;
                                totalAmount         += chargeAmount;
                                totalAmount         += gstCharge;
                            }
                            else{
                                charge.ChargeAmount = 0.0;
                                charge.GST_Charge   = 0.0;
                            }
                        }else if(chargeType == 'CIBIL_FEE'){
                            if(app.Cibil_Charges__c != null){
                                chargeAmount        = (app.Cibil_Charges__c +1000).setScale(2);
                                gstCharge           = (chargeAmount * gstPercent).setScale(2);
                                charge.ChargeAmount = chargeAmount;
                                charge.GST_Charge   = gstCharge;
                                totalAmount         += chargeAmount;
                                totalAmount         += gstCharge;
                            }
                            else{
                                charge.ChargeAmount = 0.0;
                                charge.GST_Charge   = 0.0;
                            }
                        }else if(chargeType == 'LEGAL_FEE'){
                            if(app.RecordType.developerName == 'SME_NEW_Loan' || app.RecordType.developerName == 'SME_Enhancement'){
                                chargeAmount            = app.Legal_Charges__c;
                                gstCharge               = app.Legal_Charges__c * gstPercent;
                                charge.ChargeAmount     = chargeAmount;
                                charge.GST_Charge       = gstCharge;
                                totalAmount             += chargeAmount;
                                totalAmount             += gstCharge;
                            }else{
                                charge.ChargeAmount = 0.0;
                                charge.GST_Charge   = 0.0;
                            }
                        }
                        else if(chargeType == 'STMP_FEE'){
                            charge.ChargeAmount = 0.0;
                            charge.GST_Charge   = 0.0;
                        }
                        else if(chargeType == 'CERSAI_FEE'){
                            if(app.RecordType.developerName != 'SME_Renewal'){
                                chargeAmount            = app.Cersai_Charges__c;
                                gstCharge               = app.Cersai_Charges__c * gstPercent;
                                charge.ChargeAmount     = chargeAmount;
                                charge.GST_Charge       = gstCharge;
                                totalAmount             += chargeAmount;
                                totalAmount             += gstCharge;
                            }
                            else{
                                charge.ChargeAmount = 0.0;
                                charge.GST_Charge   = 0.0;
                            }
                        }
                        else if(chargeType == 'VALU_FEE'){
                            if(app.RecordType.developerName == 'SME_NEW_Loan' || app.RecordType.developerName == 'SME_Enhancement'){
                                chargeAmount            = app.Valuation_Charges__c;
                                gstCharge               = app.Valuation_Charges__c * gstPercent;
                                charge.ChargeAmount     = chargeAmount;
                                charge.GST_Charge       = gstCharge;
                                totalAmount             += chargeAmount;
                                totalAmount             += gstCharge;
                            }else{
                                charge.ChargeAmount = 0.0;
                                charge.GST_Charge   = 0.0;
                            }
                        }
                        else if(chargeType == 'DOC_FEE'){
                            if(app.genesis__Additional_Cash_Required__c != null && (app.RecordType.developerName == 'SME_Enhancement' || app.RecordType.developerName == 'SME_NEW_Loan' || app.RecordType.developerName == 'SME_AdHoc')){
                                chargeAmount        = (app.genesis__Additional_Cash_Required__c).setScale(2);
                                gstCharge           = (chargeAmount * gstPercent).setScale(2);
                                charge.ChargeAmount = chargeAmount;
                                charge.GST_Charge   = gstCharge;
                                totalAmount         += chargeAmount;
                                totalAmount         += gstCharge;
                            }
                            else{
                                charge.ChargeAmount = 0.0;
                                charge.GST_Charge   = 0.0;
                            }
                        }
                        cbsReqObj.inputVariables.in_msg.Charges.add(charge);
                    }
                    cbsReqObj.inputVariables.in_msg.TotalAmount                 = totalAmount.setScale(2);
                    System.debug(JSON.serialize(cbsReqObj));
                    logList.add(chargeCollectionCallout(JSON.serialize(cbsReqObj),app.Id));
                }
            }
            if(reTry){
                INSERT logList;
            }
            if(app.RecordType.DeveloperName == Constants.SME_NEW_LOAN_RECORD_TYPE)
                Underwriting_CTRL_Helper.createMODTaskForBm(app.Id,'MOD Needed','MOD Needed');
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN logList;
    }
    //Helper method to make callout for Charge collection
    public static CBS_API_Log__c chargeCollectionCallout(String custData,String appId){
        CBS_API_Log__c log                  = new CBS_API_Log__c(); 
        try{
            genesis__Applications__c app = [SELECT Id,genesis__Rate_Floor__c,genesis__Additional_Cash_Required__c,Cibil_Charges__c,Application_Stage__c,Legal_desk_state_flag__c,Total_Stamp_Paper_Charge__c,Cersai_Charges__c,Legal_Charges__c,Valuation_Charges__c,recordType.developerName FROM genesis__Applications__c WHERE Id =: appId];
            Boolean successFlag                 = false;
            KVB_Endpoint_URLs__c endPointUrl = KVB_Endpoint_URLs__c.getValues('CBS_ChargeCollection');
            if(endPointUrl != null){
                system.debug('custData####'+custData);
                Map<String,String> headerMap                            = new Map<String,String>();
                headerMap.put('Content-Type','application/json');
                HTTPResponse response                                   = new HTTPResponse();
                String endPoint                                         = endPointUrl.Endpoint_URL__c;
                response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,custData,headerMap,label.CA_CERTIFICATE);
                system.debug('$$$$'+response.getBody());
                If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    String jsonString = response.getBody();
                    CBS_ChargeCollaction_Formatter.ResponseFormat res = (CBS_ChargeCollaction_Formatter.ResponseFormat)Json.deserialize(jsonString, CBS_ChargeCollaction_Formatter.ResponseFormat.class);
                    log.Application__c          = appId;
                    log.API_Name__c             = 'ChargeColletction_SME';
                    if(res.out_msg.ErrorCode == '0' && res.out_msg.CBSReferenceNo != null){
                        successFlag             = true;
                        log.Status__c           = 'Success';
                        if(res.out_msg.ErrorMessage != null) log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                        log.ExternalReferenceNo__c = res.out_msg.ApplicationNumber;
                    }
                    else{
                        log.Status__c           = 'Failure';
                        log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    }
                }
                else{
                    log.Application__c          = appId;
                    log.API_Name__c             = 'ChargeColletction_SME';
                    log.Status__c               = 'Failure';
                    log.Success_Error_Message__c = 'ChargeColletction_NO_HIT';
                }
                if(app.recordType.developerName == 'SME_NEW_Loan'){
                    log.Sequence_No__c              = '16';     
                }
                else
                    log.Sequence_No__c              = '15';
            }
            if(successFlag){
                if(app.RecordType.Developername == 'SME_Enhancement') app.Application_Stage__c = 'Enhancement Application close';
                if(app.RecordType.Developername == 'SME_Exceeding') app.Application_Stage__c = 'Exceeding Application close';
                if(app.RecordType.Developername == 'SME_AdHoc') app.Application_Stage__c = 'Adhoc Application close';
                //if(app.RecordType.Developername == 'SME_NEW_Loan') app.Application_Stage__c = 'New loan - Application close';
            }
            
            ApplicationTriggerHandler.IsFirstRun = false;           
            UPDATE app;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN log;
    }
    public static String getDateString(Date dt){
        String dateString = '';
        try{
            Map<String,String> mapOfNumber = new Map<String,String>{'1'=>'01','2'=>'02','3'=>'03','4'=>'04','5'=>'05','6'=>'06','7'=>'07','8'=>'08','9'=>'09'};
                try{
                    if(dt != null){
                        List<String> listOfDateString = String.valueOf(dt).split('-');
                        if(listOfDateString !=null && listOfDateString.size() > 0 ){
                            dateString = listOfDateString[0]; 
                            if(mapOfNumber.containsKey(listOfDateString[1])){
                                dateString = dateString+mapOfNumber.get(listOfDateString[1]);
                            }else{
                                dateString = dateString+listOfDateString[1];
                            }
                            if(mapOfNumber.containsKey(listOfDateString[2])){
                                dateString = dateString+mapOfNumber.get(listOfDateString[2]);
                            }else{
                                dateString = dateString+listOfDateString[2];
                            }
                            return dateString;
                        }
                    }   
                }catch(Exception ex){
                    System.debug('Exception'+ex.getMessage());
                }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        return null;
    }
    public static void dedupeCheck(genesis__Applications__c app){
        try{
            System.debug('CustomerId****'+cbsCustId);
            List<CBS_API_Log__c> logList                = new List<CBS_API_Log__c>();
            Boolean customerVeried                      = false;
            WS_CBS_Dedupe.CBS_Dedupe_Request dedupeReq  = new WS_CBS_Dedupe.CBS_Dedupe_Request();
            dedupeReq.inputVariables                    = new WS_CBS_Dedupe.cls_inputVariables();
            dedupeReq.exe_tenantId                      = 'cuecent_tenant';
            dedupeReq.owner_tenantId                    = 'cuecent_tenant';
            dedupeReq.inputVariables.in_msg                     = new WS_CBS_Dedupe.cls_in_msg();
            dedupeReq.inputVariables.in_msg.ApplicantNo         = app.Id;
            dedupeReq.inputVariables.in_msg.ApplicantDetails    = new List<WS_CBS_Dedupe.cls_ApplicantDetails>();
            
            WS_CBS_Dedupe.cls_ApplicantDetails appdetail = new WS_CBS_Dedupe.cls_ApplicantDetails();
            appdetail.adharNo = app.genesis__Account__r.Pan_Number__c != null ? WS_getAadharNo.getAadharNo(app.genesis__Account__r.Pan_Number__c) : '';
            appdetail.panNo = app.genesis__Account__r.Pan_Number__c != null ? app.genesis__Account__r.Pan_Number__c : '';
            appdetail.custIc = app.genesis__Account__r.Customer_IC__c != null ? app.genesis__Account__r.Customer_IC__c : '';
            if(app.genesis__Account__r.RecordType.DeveloperName != null && app.genesis__Account__r.RecordType.DeveloperName == 'Business_Account'){
                appdetail.ExpCustType = 'B';
            }if(app.genesis__Account__r.RecordType.DeveloperName != null && app.genesis__Account__r.RecordType.DeveloperName == 'PersonAccount'){
                appdetail.ExpCustType = 'P';
            }
            appdetail.applicantId                               = cbsCustId;
            dedupeReq.inputVariables.in_msg.ApplicantDetails.add(appdetail);
            System.debug('DedupeReq::'+JSON.serialize(dedupeReq));
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('CBS_Dedupe_Bulk_NewLoan'), 'POST', null,JSON.serialize(dedupeReq),headerMap,label.CA_CERTIFICATE);
            system.debug('$$$$'+response.getBody());
            CBS_API_Log__c log                              = new CBS_API_Log__c();
            log.Application__c                              = app.Id;
            log.API_Name__c                                 = 'Dedupe_Status_SME_NewLoan';
            log.Sequence_No__c                              = '16';
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                WS_CBS_Dedupe.CBS_Dedupe_Response res = (WS_CBS_Dedupe.CBS_Dedupe_Response)Json.deserialize(jsonString, WS_CBS_Dedupe.CBS_Dedupe_Response.class);
                if(res.out_msg.DedupeSuccessResponse != null && res.out_msg.DedupeSuccessResponse.size() > 0){
                    for(WS_CBS_Dedupe.cls_DedupeSuccessResponse deDupeRes : res.out_msg.DedupeSuccessResponse){
                        if(deDupeRes.CustomerId != null && deDupeRes.CustomerId == cbsCustId)
                            customerVeried                  = true;
                    }
                }
                else{
                    customerVeried                          = false;
                }
                if(customerVeried)
                    log.Success_Error_Message__c            = 'Dedupe_Status_SME_NewLoan_Verified';
                else
                    log.Success_Error_Message__c            = 'Dedupe_Status_SME_NewLoan_Not_Verified';
                log.Status__c                           = 'Success';
            }
            else{
                log.Status__c                               = 'Failure';
                log.Success_Error_Message__c                = 'Dedupe_Status_SME_NewLoan_Failure';
            }
            logList.add(log);
            if(customerVeried){
                app.Service_Type_Name__c                    = 'Loan_Account_Creation';
                logList.addAll(createLoanAccount(app,false));
            }
            else{
                app.Service_Type_Name__c                    = 'Dedupe_Check';
            }
            INSERT logList;
            
            ApplicationTriggerHandler.IsFirstRun            = false; 
            UPDATE app;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    public static List<CBS_API_Log__c> createLoanAccount(genesis__Applications__c app,Boolean reTry){ 
        List<CBS_API_Log__c> cbsLogList                                             = new List<CBS_API_Log__c>(); 
        try{
            If(app !=null){
                List<SME_CBS_EAE_Formatter.RequestFormat> createAccReqList = new List<SME_CBS_EAE_Formatter.RequestFormat>();   
                List<Facility__c> listOfFacility  = [SELECT Id,Application__r.Branch_Name__c,NTB_Facility_Type__c,Account_Number__c,Application__r.genesis__Account__c,Application__r.genesis__Account__r.Name,Application__r.genesis__Account__r.CBS_Customer_ID__c,Application__r.Branch_Code__c,CL_Product__r.Product_Code__c FROM Facility__c WHERE Application__c =: app.Id AND RecordType.developerName = 'Parent' AND Active__c = true];
                If(listOfFacility !=null && listOfFacility.size() > 0){
                    for(Facility__c  facObj  :  listOfFacility){
                        System.debug(facObj.NTB_Facility_Type__c);
                        System.debug(facObj.Account_Number__c);
                        System.debug(facObj.NTB_Facility_Type__c != 'WC KVB' && facObj.NTB_Facility_Type__c != 'Renewal');
                        System.debug(facObj.Account_Number__c == null);
                        If(facObj.NTB_Facility_Type__c != 'WC KVB' && facObj.NTB_Facility_Type__c != 'Renewal' && facObj.Account_Number__c == null){
                            SME_CBS_EAE_Formatter.RequestFormat loanAccCreate = new SME_CBS_EAE_Formatter.RequestFormat();
                            loanAccCreate.exe_tenantId                                 = 'cuecent_tenant';
                            loanAccCreate.owner_tenantId                               = 'cuecent_tenant';
                            loanAccCreate.inputVariables                               = new SME_CBS_EAE_Formatter.cls_inputVariables();
                            loanAccCreate.inputVariables.in_msg                        = new SME_CBS_EAE_Formatter.cls_in_msg();
                            loanAccCreate.inputVariables.in_msg.Cod_Cust1              = facObj.Application__r.genesis__Account__r.CBS_Customer_ID__c !=null ? facObj.Application__r.genesis__Account__r.CBS_Customer_ID__c : '';
                            loanAccCreate.inputVariables.in_msg.Cod_Acct_Cust_Rel1      = Constants.CODE_ACCT_CUST_REL1;
                            loanAccCreate.inputVariables.in_msg.Nam_Cust_Shrt           = facObj.Application__r.genesis__Account__r.Name !=null ? facObj.Application__r.genesis__Account__r.Name : '';
                            loanAccCreate.inputVariables.in_msg.Cod_Cc_Brn              = facObj.Application__r.Branch_Code__c !=null ? facObj.Application__r.Branch_Code__c : '';
                            loanAccCreate.inputVariables.in_msg.Cod_Prod                = facObj.CL_Product__r.Product_Code__c !=null ? facObj.CL_Product__r.Product_Code__c : '';
                            loanAccCreate.inputVariables.in_msg.Cod_Org_Brn             = facObj.Application__r.Branch_Code__c !=null ? facObj.Application__r.Branch_Code__c : '';
                            loanAccCreate.inputVariables.in_msg.Acct_Desc               = facObj.Application__r.genesis__Account__r.Name !=null ? facObj.Application__r.genesis__Account__r.Name : '';
                            loanAccCreate.inputVariables.in_msg.Cod_Cust2               = Constants.CODE_CUST_2;
                            loanAccCreate.inputVariables.in_msg.Cod_Acct_Cust_Rel2      = '';
                            loanAccCreate.inputVariables.in_msg.Cod_Cust3               = Constants.CODE_CUST_3;
                            loanAccCreate.inputVariables.in_msg.Cod_Acct_Cust_Rel3      = '';
                            loanAccCreate.inputVariables.in_msg.Flg_Sc_Waiver           = Constants.FLG_SC_WAIVER;
                            loanAccCreate.inputVariables.in_msg.Flg_Int_Waiver          = Constants.FLG_INT_WAIVER;
                            loanAccCreate.inputVariables.in_msg.Cod_Officerid           = Constants.CODE_OFFICER_ID;
                            loanAccCreate.inputVariables.in_msg.Cod_Makerid             = Constants.CODE_MAKER_ID;
                            loanAccCreate.inputVariables.in_msg.Cod_Chkrid              = Constants.CODE_CHECKKER_ID;
                            loanAccCreate.inputVariables.in_msg.Cod_Lang                = Constants.CODE_LANG;
                            loanAccCreate.inputVariables.in_msg.Flg_Joint_Acct          = Constants.FLAG_JOINT_ACC;
                            loanAccCreate.inputVariables.in_msg.Cod_Module              = Constants.CODE_MODULE;
                            loanAccCreate.inputVariables.in_msg.Cod_Tds                 = Constants.CODE_TDS;
                            loanAccCreate.inputVariables.in_msg.Cod_Tds_2               = Constants.CODE_TDS_2;
                            loanAccCreate.inputVariables.in_msg.User_Id                 = Constants.USER_ID;
                            
                            String randomValue                                          = String.valueOf(Math.random());
                            loanAccCreate.inputVariables.in_msg.Cod_Laps_Reference_No  = randomValue.subString(2,randomValue.length()-1);
                            //Map of Facility for Account number Updation.
                            mapOfFacilityId.put(loanAccCreate.inputVariables.in_msg.Cod_Laps_Reference_No,facObj.Id);
                            System.debug('mapOfFacilityId::'+mapOfFacilityId);
                            createAccReqList.add(loanAccCreate);
                        }
                    } 
                    if(createAccReqList.size() > 0){
                        app.Service_Type_Name__c                = 'Loan_Account_Creation';
                        for(SME_CBS_EAE_Formatter.RequestFormat accCreation : createAccReqList){
                            cbsLogList.addAll(new_LoanAccount_Callout(JSON.serialize(accCreation),app));
                        }
                        If(newAccountFlag){
                            //cbsLogList.addAll(collCreation(app,true));  
                            keyPersonLinkage(app.Id);                         
                        }
                        if(cbsLogList.size() > 0 && reTry){
                            insert cbsLogList;
                            ApplicationTriggerHandler.IsFirstRun = false;
                            UPDATE app;
                        }
                    }
                } 
                if(facIdAccNumberMap.size() > 0){
                    facilityAccNumberUpdate(mapOfFacilityId,facIdAccNumberMap);
                }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN cbsLogList;
    }
    public static List<CBS_API_Log__c> new_LoanAccount_Callout(String reqString,genesis__Applications__c app){
        try{
            System.debug('AccountCreationReq:::'+reqString);
            Map<String,String> headerMap                        = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                               = new HTTPResponse();
            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('NEW_LOAN_ACCOUNT_CREATION'), 'POST', null,reqString,headerMap,label.CA_CERTIFICATE);
            String jsonString = response.getBody();
            
            SME_CBS_EAE_Formatter.ResponseFormat res = (SME_CBS_EAE_Formatter.ResponseFormat)JSON.deserialize(jsonString, SME_CBS_EAE_Formatter.ResponseFormat.Class);
            System.debug('AccountCreationRes:::'+jsonString);
            If(res !=null && res.out_msg !=null){
                SME_CBS_EAE_Formatter.cls_out_msg outmsgObj     = res.out_msg;
                If(outmsgObj !=null){
                    If(outmsgObj.ErrorCode !=null && outmsgObj.ErrorCode !='' && outmsgObj.ErrorCode =='0'){
                        newAccountFlag                          = true;
                        If(outmsgObj.Cod_Acct_No !=null && outmsgObj.Cod_Acct_No !=null && outmsgObj.Cod_Laps_Reference_No !=null && outmsgObj.Cod_Laps_Reference_No !=''){
                            
                            If(mapOfFacilityId.containsKey(outmsgObj.Cod_Laps_Reference_No)){
                                System.debug('CreatedAccountNumber::'+outmsgObj.Cod_Acct_No);
                                String facId                    = mapOfFacilityId.get(outmsgObj.Cod_Laps_Reference_No);
                                String facAccNumber             = outmsgObj.Cod_Acct_No;
                                facIdAccNumberMap.put(facId,facAccNumber);
                            }
                        }     
                    }else{
                        newAccountFlag                          = false;
                    }    
                }
            }
            RETURN responseHandler(res,app,'Loan_Account_Creation');
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            RETURN new List<CBS_API_Log__c>();
        }
    }
    
    public static void facilityAccNumberUpdate(Map<String,Id> externalId_FacIdMap,Map<Id,String> facIdAccNumberMap){
        try{
            List<Facility__c> facList           = new List<Facility__c>();
            for(Id facId : facIdAccNumberMap.keySet()){
                if(facIdAccNumberMap.get(facId) != null){
                    Facility__c fac             = new Facility__c();
                    fac.Id                      = facId;
                    fac.Account_Number__c       = facIdAccNumberMap.get(facId);
                    facList.add(fac);
                }
            }
            if(facList.size() > 0) UPDATE facList;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    @future(Callout = true)
    public static void keyPersonLinkage(String appId){
        genesis__Applications__c app = new genesis__Applications__c();
        Map<String,String> custRelMap = new Map<String,String>{'Authorised Signatory'=>'AUS','Co-Applicant'=>'COA','Co-Obligant'=>'COB','Developer'=>'DEV','Guarantor'=>'GUA','Guardian'=>'GUR','Joint AND Others'=>'JAO','Joint OR Others'=>'JOO','Partner'=>'PAR','Proprietor'=>'PRO','Solicitor'=>'SOL','Third Party'=>'THR','Trustee'=>'TRU','Valuer'=>'VAL','Director'=>'AUS','Co-Borrower'=>'COB','Promotors'=>'AUS'};
            app = [SELECT Name,genesis__Rate_Floor__c,genesis__Additional_Cash_Required__c,Application_Stage__c,Legal_desk_state_flag__c,RecordType.DeveloperName,Type__c,genesis__Account__r.Name,genesis__Account__r.CBS_Customer_ID__c,genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Customer_IC__c,genesis__Account__r.Pan_Number__c,EAE_Renewal_Date_in_days__c,genesis__Account__r.Branch_Code__c,Id,Cibil_Charges__c,Processing_Charges__c,Charge_collection_done__c,Service_Type_Name__c,Branch_Code__c,genesis__Account__c,genesis__Account__r.Drawing_Power__c,
                   (SELECT Id,Application__r.CustomerID__c,Recommended_Limit__c,Account_Number__c FROM Facilities__r WHERE Active__c = true),
                   (SELECT Id,genesis__Party_Type__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c FROM genesis__Application_Parties__r WHERE Active__c = true),
                   (SELECT Id,genesis__Collateral__c FROM Application_Collateral__r WHERE genesis__Collateral__r.FE_Created__c = true)
                   FROM genesis__Applications__c WHERE Id =: appId];
        
        List<CBS_API_Log__c> cbsApiLogList                  = new List<CBS_API_Log__c>();
        try{
            for(Facility__c fac : app.Facilities__r){
                CBS_CustomerLinkage_Formatter.RequestFormat cbsReqObj = new CBS_CustomerLinkage_Formatter.RequestFormat();
                cbsReqObj.exe_tenantId                          = 'cuecent_tenant';
                cbsReqObj.owner_tenantId                        = 'cuecent_tenant';
                cbsReqObj.inputVariables                        = new CBS_CustomerLinkage_Formatter.cls_inputVariables();
                cbsReqObj.inputVariables.in_msg                 = new CBS_CustomerLinkage_Formatter.cls_in_msg();
                cbsReqObj.inputVariables.in_msg.TransactionBranch = app.Branch_Code__c;
                cbsReqObj.inputVariables.in_msg.Mode = 'M';
                cbsReqObj.inputVariables.in_msg.ValueDateText   = String.ValueOf(system.today().format()).replace('/','-');
                List<CBS_CustomerLinkage_Formatter.cls_CustDetl> custDetailList = new List<CBS_CustomerLinkage_Formatter.cls_CustDetl>();
                
                CBS_CustomerLinkage_Formatter.cls_CustDetl custDetail = new CBS_CustomerLinkage_Formatter.cls_CustDetl();
                if(fac.Account_Number__c != null)
                    custDetail.AccountNo                    = fac.Account_Number__c;
                custDetail.CustId1                      = fac.Application__r.CustomerID__c;
                custDetail.CustRel1                     = 'SOW';
                custDetail.FlgDel                       = 'N';
                custDetailList.add(custDetail);
                for(genesis__Application_Parties__c party : app.genesis__Application_Parties__r){
                    CBS_CustomerLinkage_Formatter.cls_CustDetl custDetail1 = new CBS_CustomerLinkage_Formatter.cls_CustDetl();
                    if(fac.Account_Number__c != null)
                        custDetail1.AccountNo                    = fac.Account_Number__c;
                    custDetail1.CustId1                      = party.genesis__Party_Account_Name__r.CBS_Customer_ID__c;
                    custDetail1.CustRel1                     = custRelMap.get(party.genesis__Party_Type__c);
                    custDetail1.FlgDel                       = 'N';
                    custDetailList.add(custDetail1);
                }
                cbsReqObj.inputVariables.in_msg.CustDetl    = custDetailList;
                cbsApiLogList.addAll(keyPersonLinkageCallout(JSON.serialize(cbsReqObj),app.Id));
            }
            if(keyPersonLinkageFlag && app.Type__c == 'ETB-WC'){
                cbsApiLogList.addAll(coll_D_Link(app,false));
            }
            else if(keyPersonLinkageFlag && (app.Type__c == 'ETB-CA' || app.Type__c.contains( 'NTB'))){
                cbsApiLogList.addAll(collCreation(app,false));
            }
            if(cbsApiLogList.size() > 0){
                INSERT cbsApiLogList;
                
                ApplicationTriggerHandler.IsFirstRun = false;
                UPDATE app;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    
    public static List<CBS_API_Log__c> keyPersonLinkageCallout(String reqData,String appId){
        List<CBS_API_Log__c> cbsApiLogList                          = new List<CBS_API_Log__c>();
        try{
            app.Service_Type_Name__c                                    = 'Customer_Linkage';
            List<Account> accountList                                   = new List<Account>();
            String CustLinkRes                                          = '';
            KVB_Endpoint_URLs__c endPointUrl = KVB_Endpoint_URLs__c.getValues('CBS_CUST_LINKAGE');
            if(endPointUrl != null){
                CBS_API_Log__c cbsLog                                   = new CBS_API_Log__c(); 
                cbsLog.Application__c                                   = appId;
                cbsLog.API_Name__c                                      = 'Customer_Linkage';
                cbsLog.Sequence_No__c                                   = '16'; 
                
                system.debug('keyPersonLinkageReq::'+reqData);
                Map<String,String> headerMap                            = new Map<String,String>();
                headerMap.put('Content-Type','application/json');
                HTTPResponse response                                   = new HTTPResponse();
                String endPoint                                         = endPointUrl.Endpoint_URL__c;
                response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,reqData,headerMap,label.CA_CERTIFICATE);
                system.debug('keyPersonLinkageRes::'+response.getBody());
                If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    String jsonString = response.getBody();
                    CBS_CustomerLinkage_Formatter.ResponseFormat res    = (CBS_CustomerLinkage_Formatter.ResponseFormat)Json.deserialize(jsonString, CBS_CustomerLinkage_Formatter.ResponseFormat.class);
                    system.debug('###'+res.out_msg.ErrorMessage);
                    cbsLog.Success_Error_Message__c                     = res.out_msg.ErrorMessage;
                    if(res.out_msg.ErrorCode == '0'){
                        keyPersonLinkageFlag                            = true;
                        cbsLog.Status__c                                = 'Customer_Linkage_Success';
                    }else{
                        cbsLog.Status__c                                = 'Customer_Linkage_Failure';
                    }
                }else{
                    cbsLog.Success_Error_Message__c                     = 'Customer_Linkage_Failure';
                    cbsLog.Status__c                                    = 'Customer_Linkage_Failure';
                }
                cbsApiLogList.add(cbsLog);
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN cbsApiLogList;
    }
    public static void updateAppStageAsLimitUpdated(String appId){
        try {
            genesis__Applications__c appObj = new genesis__Applications__c();
            appObj.Id                       = appId;
            appObj.Sub_Stage__c = 'Limit Opened';
            ApplicationTriggerHandler.IsFirstRun = false;
            update appObj;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIFOpenTaskAlreadyExistForRLPC', e);
        }
    }
    public static void verifyDocumentTaskCreate(String  appId){
        try {
            if(!Underwriting_CTRL_Helper.checkIFOpenTaskAlreadyExist(appId,'Verify Document')){
                User verifyOfficer = getDoCreditOfficerUser(appId);
                Task taskObj = SanctionUnderwriting_Process.getTaskObj(appId,verifyOfficer.Id,'Verify Documentation','Verify Document');
                taskObj.ActivityDate = system.today()+1;
                TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
                insert taskObj;
            }
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'checkIFOpenTaskAlreadyExistForRLPC', e);
        }
    }
    public static User getDoCreditOfficerUser(String appId){
        try {
            genesis__Applications__c applDetails = [SELECT Id,genesis__Rate_Floor__c,genesis__Additional_Cash_Required__c,Application_Stage__c,Legal_desk_state_flag__c,RecordType.DeveloperName,OwnerId FROM genesis__Applications__c WHERE Id =:appId LIMIT 1];
            
            String BranchOwnerDivision =[Select id,Designation__c,Division from User where Id=:applDetails.OwnerId].Division;
            User appOwner =
                [Select id,Designation__c,IsActive from user where IsActive=true AND Designation__c ='Verifying Officer' AND Division = 'Central Office'  limit 1];
            System.debug(''+appOwner);
            return appOwner;
        } catch (Exception e) {
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'getDoCreditOfficerUser', e);
            return null;
        }
    }
    webservice static String taskCompleteButton(String appId){
        try{
            List<task> taskObjLst                       = new List<task>();
            List<Digio_Document_ID__c > digioDocIdLst   = new List<Digio_Document_ID__c>();
            digioDocIdLst                               = [SELECT id,name,Document_Complete__c,Application__r.id,Application__r.Ownerid FROM Digio_Document_ID__c WHERE Application__r.id =: appId And Document_ID__c= null];
            List<Digio_Document_ID__c > docRejectedIdList= new List<Digio_Document_ID__c>();
            docRejectedIdList                               = [SELECT id,name,Document_Complete__c,Application__r.id,Application__r.Ownerid FROM Digio_Document_ID__c WHERE Application__r.id =: appId And Document_Complete__c =false];
            
            User usrObj = [SELECT Id,username,Designation__c FROM User WHERE Id =: userInfo.getUserId()];
            if(usrObj.Designation__c.contains('BR_MGR') || usrObj.Designation__c=='BR_CREDIT_OFFICER'){
                System.debug('###########'+digioDocIdLst);
                if(digioDocIdLst != null && digioDocIdLst.isEmpty()){
                    Button_Utility.closeExistingBMTask(appId,'Document Review');
                    verifyDocumentTaskCreate(appId);
                    return 'Task has been created for Verify Officer Has Been Creted';
                }else{
                    System.debug('Inside Else');
                    return 'Some Error Occurred';
                }
            }
            else if(usrObj.Designation__c == 'Verifying Officer'){
                // 1. Task Complete
                List<task> taskCorrectLst = [SELECT id,Status,Type,whatid FROM task WHERE type = 'Verify Document' and Status != 'Completed' and whatid =: appId LIMIT 1];
                if(taskCorrectLst.size()>0){
                    for(task taskObj1 : taskCorrectLst){
                        task tasjObj = new task();
                        tasjObj.Id = taskObj1.id;
                        tasjObj.Status = 'Completed';
                        taskObjLst.add(tasjObj);
                    }
                    if(!taskObjLst.isEmpty()){
                        update taskObjLst;
                    }
                }
                if(docRejectedIdList != null && docRejectedIdList.isEmpty()){
                    genesis__Applications__c appln = new genesis__Applications__c();
                    appln.Sub_Stage__c = 'Application Processed - Closed';
                    appln.id = appId;
                    ApplicationTriggerHandler.IsFirstRun = false;
                    update appln;
                    return 'Application Substage has been moved to Application Processed - Closed';
                }else{
                    task taskObject1 = new task();
                    taskObject1 = SanctionUnderwriting_Process.getTaskObj(appId,docRejectedIdList[0].Application__r.OwnerId,'Correct Document','Document Review');
                    taskObject1.ActivityDate = system.today()+1;
                    TaskFlow_Helper.TASK_TRIGGER_RUNNING = true;
                    insert taskObject1;
                    return 'Document Correction task has been created for Branch Manager';
                }
            }else{
                return 'Some Error Occurred';
            }
        }
        catch(Exception e){
            HandleBusinessException.captureError('Underwriting_CTRL_Helper', 'updateAppStage', e);
            return 'Error : '+e.getMessage()+' AT '+e.getLineNumber();
        }
    }
}