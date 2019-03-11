/*
* Description : SME Ehancement Request API
* Author       : Amritesh
*/
@RestResource(urlMapping = '/getApplicationDetails')
global class WS_FetchSMEInfo {
    
    //Response structure
    global class Response extends WS_Response { 
        Customer360view customerFullView;
        public Response() {
            customerFullView = new Customer360view();
        }
    }
    public class ReqWrapObj {
        public String CUSTOMER_ID;
        public String LOS_APPLICATION_ID;
        public String APP_TYPE;
        public String TYPE;
        public String LOS_APPLICATION_NAME;
        public WS_FetchSMEInfo_Helper.CustomerDetail CustomerDetail;
    }
    
        public static Integer count;

    @HttpPost
    global static Response getApplicationDetail() {
        RestRequest req = Restcontext.Request;
        Response res = new Response();
        if (req == null || req.requestBody == null) {
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);
        } else {
            try {
                String jsonData = req.requestBody.toString();
                ReqWrapObj reqObj = (ReqWrapObj) Json.deserialize(jsonData, ReqWrapObj.class);
                 boolean isApplicationPresent    = false;
                system.debug('reqObj.name:::'+reqObj.LOS_APPLICATION_NAME);
                system.debug('reqObj applicatio id:::'+reqObj.LOS_APPLICATION_ID);
                If((reqObj.LOS_APPLICATION_ID != null && reqObj.LOS_APPLICATION_ID != '') || (reqObj.LOS_APPLICATION_NAME !=null && reqObj.LOS_APPLICATION_NAME !='')) {
                    genesis__Applications__c AppByNameId = SOQL_Util.getApplicationId_By_Name(reqObj.LOS_APPLICATION_NAME,reqObj.LOS_APPLICATION_ID);
                    isApplicationPresent    = true;
                    If(AppByNameId !=null && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                        
                        If(System.today() > AppByNameId.CreatedDate.addDays(Integer.valueOf(Label.Application_Expiry_Days)) && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application Expired.');
                        }

                    }

                    try {
                        system.debug('cbc_customer::'+AppByNameId.genesis__Account__r.CBS_Customer_ID__c);
                        system.debug('AppByNameId.genesis__Account__r.CBS_Customer_ID__c'+AppByNameId.Id);
                            res.customerFullView = Handle_FetchSMEReq_Response.getApplicationInfo(AppByNameId.genesis__Account__r.CBS_Customer_ID__c, AppByNameId.Id);
                    } catch (Exception e) {
                        system.debug('Exception::' + e.getMessage() + e.getLineNumber()+e.getStackTraceString());
                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Exception' + e.getMessage() + e.getLineNumber()+e.getStackTraceString());
                    }
                }
                else if (reqObj.Customer_ID != null && reqObj.Customer_ID != '') {
                    string appClone = '';
                    string enhanceappid='';
                    string appETBId = '';
                    string appId = '';
                    string appFetchId = '';
                    System.debug('Inside reqObj.Customer_ID @@@@@@@@@@@@#######'+reqObj.Customer_ID);
                    If(reqObj.TYPE != 'ETB-CA'){
                        Account accObj  =   WS_LandingPage.getAccountByCustomerID(reqObj.Customer_ID);
                        if(accObj==null){
                            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'No customer found.');
                        }
                    }
                    if (reqObj.TYPE != null && reqObj.TYPE != '') {
                        //appId = (String) LandingPageHelper.landingPageRes(reqObj.Customer_ID, true);
                        if (reqObj.TYPE == 'EAE') {
                            genesis__Applications__c appForInActive = new genesis__Applications__c();
                            
                            if (reqObj.LOS_Application_ID == null || reqObj.LOS_Application_ID == '') {
                                
                                if (reqObj.APP_TYPE != null && reqObj.APP_TYPE != '') {
                                    //Clone Renewal Application for specified APP_TYPE
                                    try {
                                        genesis__Applications__c appLicationObject = new genesis__Applications__c();
                                        
                                        genesis__Applications__c appObject = SOQL_Util.getExistingApplication(reqObj.Customer_ID, reqObj.APP_TYPE);
                                        appId = (String) LandingPageHelper.landingPageRes(reqObj.Customer_ID, true);
                                        System.debug('Inside APP TYPE'+appId);
                                        If(appObject != null) {
                                            appId = appObject.Id;
                                            
                                        } else {
                                            
                                            List < genesis__Applications__c > listAppObjectEAE = SOQL_Util.getApplicationDueDate(reqObj.Customer_ID);
                                            
                                            If(listAppObjectEAE != null && !listAppObjectEAE.isEmpty()) {
                                                
                                                for (genesis__Applications__c appObjectCheck: listAppObjectEAE) {
                                                    
                                                    If(appObjectCheck.recordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE && reqObj.APP_TYPE != 'SME_Exceeding') {
                                                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'New Loan is already in progress. Please contact your branch manager.');
                                                        
                                                    } else If(appObjectCheck.recordType.developerName == Constants.SME_APP_RECORD_TYPE) {
                                                        appLicationObject.Id                    = appObjectCheck.Id;
                                                        appLicationObject.Renewal_Due_Date__c   = appObjectCheck.Renewal_Due_Date__c;
                                                    }
                                                }
                                                If(appLicationObject.Id != null) {
                                                    
                                                    appClone = ApplicationClone.cloneApplication(appId, reqObj.APP_TYPE);/*
                                                    If(appClone != null && appClone != '' && reqObj.APP_TYPE != 'SME_Exceeding' && reqObj.APP_TYPE != 'SME_AdHoc') {
                                                        If(appLicationObject.Renewal_Due_Date__c != null) {
                                                            If(appLicationObject.Renewal_Due_Date__c < (System.today().addDays(90))) {
                                                                appForInActive.id = appClone;
                                                                appForInActive.Application_to_close__c = true;
                                                                appForInActive.Type__c  = reqObj.TYPE;
                                                            }
                                                        }
                                                    }*/
                                                }
                                                /*If(appForInActive.id != null) {
                                                    update appForInActive;
                                                }*/
                                            }
                                        }
                                        If((appId !=null && appId!='') && (appClone ==null || appClone =='')){
                                            appFetchId = appId;
                                        } else if (appClone != null && appClone != '') {
                                            appFetchId = appClone;
                                        }
                                    } catch (Exception e) {
                                        system.debug('Exception:::::' + e.getMessage() + '!!!' + e.getLineNumber());
                                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application Creation Failed.');
                                    }
                                } else {
                                    return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'APP_TYPE is required.');
                                }
                            } else {
                                appFetchId = reqObj.LOS_Application_ID;
                            }
                            if (appFetchId != null && appFetchId != '') {
                                try {
                                    res.customerFullView = Handle_FetchSMEReq_Response.getApplicationInfo(reqObj.Customer_ID, appFetchId);
                                } catch (Exception e) {
                                    system.debug('Exception::' + e.getMessage() + e.getLineNumber());
                                    return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Exception' + e.getMessage() + e.getLineNumber()+e.getStackTraceString());
                                }
                            }
                        }
                        if (reqObj.TYPE == 'ETB-WC') {
                            String accountId     = '';
                            //Clone Renewal Application for specified APP_TYPE
                            if (reqObj.LOS_APPLICATION_ID == null || reqObj.LOS_Application_ID == '') {
                                If(reqObj.LOS_APPLICATION_NAME ==null || reqObj.LOS_APPLICATION_NAME ==''){
                                    try {
                                        genesis__Applications__c appForClone        = new genesis__Applications__c();
                                        genesis__Applications__c appForBundle       = new genesis__Applications__c();
                                        genesis__Applications__c appForCloneEAE     = new genesis__Applications__c();
                                        genesis__Applications__c appForInactive     = new genesis__Applications__c();
                                        Boolean enhancementAppcreated=false;
                                        Map < String, genesis__Applications__c > mapOfApp = new Map < String, genesis__Applications__c > ();
                                        
                                        Id devRecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.SME_NEW_LOAN_RECORD_TYPE_LABEL).getRecordTypeId();
                                        genesis__Applications__c appObject = SOQL_Util.getExistingApplication(reqObj.Customer_ID, reqObj.APP_TYPE);

                                        appETBId = (String) LandingPageHelper.landingPageRes(reqObj.Customer_ID, true);
                                        System.debug('reqObj.Customer_ID==='+reqObj.Customer_ID);
                                        if(appObject !=null){
                                            appClone =   appObject.Id;  
                                        }else{
                                        List<genesis__Applications__c> enhanceap=TermLoan_SOQL_Util.getinactiveEnhancementapp(reqObj.Customer_ID);
                                        System.debug('enhanceap==='+enhanceap);
                                        if(enhanceap!=null && !enhanceap.isEmpty()){
                                            appClone = ApplicationClone.cloneApplication(enhanceap[0].id, Constants.SME_NEW_LOAN_RECORD_TYPE);
                                            enhancementAppcreated=true;
                                        }

                                        If(appETBId != null && appETBId != '' && enhancementAppcreated==false) {
                                        System.debug('count=='+count);
                                        appClone = ApplicationClone.cloneApplication(appETBId, Constants.SME_NEW_LOAN_RECORD_TYPE);
                                        System.debug('count=='+count);
                                            //List < genesis__Applications__c > listAppObject = SOQL_Util.getApplicationDueDate(reqObj.Customer_ID);
                                            /*If(listAppObject != null && !listAppObject.isEmpty()) {
                                                for (genesis__Applications__c appObject: listAppObject) {
                                                    If(appObject != null){
                                                        If(appObject.recordType.developerName == Constants.SME_APP_RECORD_TYPE_ENHANCEMENT) {
                                                            mapOfApp.put(Constants.SME_APP_RECORD_TYPE_ENHANCEMENT, appObject);
                                                        }
                                                        If(appObject.recordType.developerName == Constants.SME_APP_RECORD_TYPE) {
                                                            mapOfApp.put(Constants.SME_APP_RECORD_TYPE, appObject);
                                                        }
                                                    }
                                                }
                                            }*/
                                            //if(mapOfApp.containsKey(Constants.SME_APP_RECORD_TYPE_ENHANCEMENT)){
                                                
                                                //appForCloneEAE      =   mapOfApp.get(Constants.SME_APP_RECORD_TYPE_ENHANCEMENT);
                                                //appForClone         =   mapOfApp.get(Constants.SME_APP_RECORD_TYPE);
                                                //System.debug('appForClone@@##'+appForClone);
                                                /*
                                                If(appForClone.Application_Stage__c == 'Enhancement/New Loan under process'){
                                                    
                                                    If(appForCloneEAE !=null){
                                                        
                                                        appClone = ApplicationClone.cloneApplication(appForCloneEAE.Id, Constants.SME_NEW_LOAN_RECORD_TYPE);
                                                        
                                                        If(appClone !=null && appClone !='') {
                                                            appForBundle.id = appClone;
                                                            appForBundle.Application_to_close__c = true;
                                                            
                                                            // for kill Enhancement Application.
                                                            appForInactive.Id =   appForCloneEAE.Id;
                                                            appForInactive.Active__c = false;
                                                        }
                                                        
                                                    }
                                                    
                                                }*/
                                                /*
                                                else If(((appForCloneEAE.CreatedDate).date().daysBetween(appForClone.Renewal_Due_Date__c))<= (System.today().addDays(90)).daysBetween(System.today())) {
                                                    //For less than 3 months clone and bundling from SME Renewal.
                                                    If(appForClone.Id !=null){
                                                        appClone = ApplicationClone.cloneApplication(appForClone.Id, Constants.SME_NEW_LOAN_RECORD_TYPE);
                                                    }
                                                    If(appClone !=null && appClone !='') {
                                                        appForBundle.id = appClone;
                                                        appForBundle.Application_to_close__c = true;
                                                        
                                                        // for kill Enhancement Application.
                                                        appForInactive.Id =   appForCloneEAE.Id;
                                                        appForInactive.Active__c = false;
                                                    }
                                                    
                                                }
                                                else If(((appForCloneEAE.CreatedDate).date().daysBetween(appForClone.Renewal_Due_Date__c)) > (System.today().addDays(90)).daysBetween(System.today())){
                                                    appClone = ApplicationClone.cloneApplication(appForCloneEAE.Id, Constants.SME_NEW_LOAN_RECORD_TYPE);
                                                    
                                                    If(appClone !=null && appClone !='') {
                                                        appForBundle.id = appClone;
                                                        appForBundle.Application_to_close__c = true;
                                                        
                                                        // for kill Enhancement Application.
                                                        System.debug('appForInactive.Id'+appForInactive.Id);
                                                        appForInactive.Id =   appForCloneEAE.Id;
                                                        appForInactive.Active__c = false;
                                                    }
                                                    
                                                }*/
                                                
                                            //}
                                            /*
                                            else If(mapOfApp !=null && mapOfApp.containsKey(Constants.SME_APP_RECORD_TYPE)){
                                                
                                                appForClone    =   mapOfApp.get(Constants.SME_APP_RECORD_TYPE);
                                                
                                                if(appForClone.Renewal_Due_Date__c < (System.today().addDays(90)) && appForClone.Application_Stage__c!='Enhancement/New Loan under process'){
                                                    
                                                    appClone = ApplicationClone.cloneApplication(appForClone.Id, Constants.SME_NEW_LOAN_RECORD_TYPE);
                                                    
                                                    If(appClone !=null && appClone !='') {
                                                        appForBundle.id = appClone;
                                                        appForBundle.Application_to_close__c = true;
                                                    }
                                                    
                                                }
                                                else if(appForClone.Renewal_Due_Date__c > (System.today().addDays(90)) && appForClone.Application_Stage__c!='Enhancement/New Loan under process'){
                                                    
                                                    appClone = ApplicationClone.cloneApplication(appForClone.Id, Constants.SME_NEW_LOAN_RECORD_TYPE);
                                                    
                                                }
                                                
                                            }*/
                                            
                                        }
                                        }/*
                                        If(appForBundle.id !=null){
                                            ApplicationTriggerHandler.IsFirstRun = false;
                                            update appForBundle;
                                            If(appForBundle.Application_to_close__c){
                                                try{
                                                    Set<String> setOfString = new Set<String>{appForBundle.id};
                                                        SME_SendSMSService.sendSMSApp_SME(setOfString);
                                                }catch(Exception ex){
                                                    System.debug('Exception'+ex.getMessage());
                                                } 
                                                
                                            }
                                        }
                                        If(appForInactive.id !=null){
                                            System.debug('Application Inactive'+appForInactive);
                                            ApplicationTriggerHandler.IsFirstRun = false;
                                            update appForInactive;
                                        }*/
                                    } catch (Exception e) {
                                        system.debug('Exception:::::' + e.getMessage() + '!!!' + e.getLineNumber());
                                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application Creation Failed.');
                                    }
                                }else{
                                    genesis__Applications__c AppByNameId = SOQL_Util.getApplicationId_By_Name(reqObj.LOS_APPLICATION_NAME,reqObj.LOS_Application_ID);
                                    If(AppByNameId !=null && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                        
                                        If(System.today() > AppByNameId.CreatedDate.addDays(Integer.valueOf(Label.Application_Expiry_Days)) && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application Expired.');
                                        }
                                        appClone = AppByNameId.id;
                                        accountId = AppByNameId.genesis__Account__r.CBS_Customer_ID__c;
                                        
                                    }
                                }
                            }else{
                                appClone = reqObj.LOS_Application_ID;
                                
                                genesis__Applications__c AppByNameId = SOQL_Util.getApplicationId_By_Name(reqObj.LOS_APPLICATION_NAME,reqObj.LOS_Application_ID);
                                If(AppByNameId !=null && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                    If(System.today() > AppByNameId.CreatedDate.addDays(Integer.valueOf(Label.Application_Expiry_Days)) && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application Expired.');
                                    }
                                    appClone = AppByNameId.id;
                                    accountId = AppByNameId.genesis__Account__r.CBS_Customer_ID__c;
                                    
                                }
                            }
                            if (appClone != null && appClone != '') {
                                System.debug('########'+appClone);
                                TermLoan_SOQL_Util.createInputRecord(appClone, 'Customer');

                                try {
                                    //res.customerFullView = SMELoan_Helper.getCustomer(appClone, reqObj.Customer_ID);
                                    System.debug('+++++++++++++++');
                                    res.customerFullView = Handle_FetchSMEReq_Response.getApplicationInfo(reqObj.Customer_ID, appClone);
                                } catch (Exception e) {
                                    system.debug('Exception::' + e.getMessage() + e.getLineNumber());
                                    return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Exception' + e.getMessage() + e.getLineNumber()+e.getStackTraceString());
                                }
                            }
                        }
                        if (reqObj.TYPE == 'ETB-CA') {
                            
                            WS_FetchSMEInfo_Helper.CustomerDetail cusObj = (WS_FetchSMEInfo_Helper.CustomerDetail) reqObj.CustomerDetail;
                            system.debug('cysto obj:::'+cusObj);
                            Savepoint sp = Database.setSavepoint();
                            
                            String accountId     = '';
                            String applicationId = '';
                            String TLapplicationId= '';
                            List<clcommon__Collateral__c> newCollatLst= new List<clcommon__Collateral__c>();
                            List<Facility__c> faciList= new List<Facility__c>();
                            
                            try {
                                If(reqObj.LOS_Application_ID == null || reqObj.LOS_Application_ID == ''){
                                    
                                    If(reqObj.LOS_APPLICATION_NAME ==null || reqObj.LOS_APPLICATION_NAME ==''){
                                        If(cusObj != null) {
                                            List<Account> listOfAccount = SOQL_Util.getAccountDetails(cusObj.PAN);
                                            //System.debug('listOfAccount====> '+listOfAccount.size());
                                            If(listOfAccount !=null && listOfAccount.size()>0){
                                                System.debug('****Existing Business Account****');
                                                Boolean isAppPresent = false;
                                                Boolean isTemLoanPresent= false; 
                                                String AppName	=	'';
                                                If(listOfAccount[0].genesis__Applications_account__r.size() > 0){
                                                    for(genesis__Applications__c   appObj :  listOfAccount[0].genesis__Applications_account__r){
                                                        if(appObj !=null && appObj.Application_Stage__c !=null && appObj.Application_Stage__c !='Discontinued Application' && appObj.Application_Stage__c !='New loan - Application close' && appObj.Application_Stage__c !='Limit Opened' && appObj.Application_Stage__c !='Application Rejected' && appObj.RecordType.developerName!= 'Term_Loan'){
                                                            isAppPresent = true;
                                                            AppName	=	appObj.Name;
                                                            //break;
                                                        }
                                                        if(appObj !=null && appObj.RecordType.developerName== 'Term_Loan'){
                                                            isTemLoanPresent= true;
                                                            TLapplicationId= appObj.Id;
                                                            //break;
                                                        }
                                                    }    
                                                }
                                                If(isAppPresent) {
                                                    return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Account already exist with provided PAN OR GST number details. Application Number is '+ AppName +' and mobile number is '+listOfAccount[0].Cust_mobile_phone__c);
                                                }else{
                                                    //for existing Customer.
                                                    accountId = WS_FetchSMEInfo_Helper.updateCustomerDetails(cusObj,reqObj.TYPE,reqObj.Customer_ID,listOfAccount[0]);
                                                    
                                                    If(accountId != null && accountId != '') {
                                                        
                                                        applicationId = WS_FetchSMEInfo_Helper.createApplication(accountId,reqObj.TYPE,cusObj,null);
                                                        /*Term Loan V1- Start*/
                                                        if(applicationId!=null){
                                                            TermLoan_SOQL_Util.createInputRecord(applicationId,'Customer');
                                                        }
                                                        if(isTemLoanPresent== false && cusObj.FACILITY_DETAILS!=null){
                                                            system.debug('isTemLoanPresent===> '+isTemLoanPresent);
                                                            TLapplicationId = WS_FetchSMEInfo_Helper.createApplication(accountId,reqObj.TYPE,cusObj,'Term Loan');
                                                        }
                                                        if(TLapplicationId!= null && TLapplicationId!= '' ){
                                                            List<WS_FetchSMEInfo_Helper.cls_COLLATERAL_DETAILS> AllFaciCollateralsLst= new List<WS_FetchSMEInfo_Helper.cls_COLLATERAL_DETAILS>();
                                                            WS_FetchSMEInfo_Helper.createParties(accountId,TLapplicationId,cusObj.TL_KEY_PERSON_DETAILS,reqObj.TYPE);
                                                            if(cusObj.FACILITY_DETAILS !=null){
                                                                system.debug('cusObj.FACILITY_DETAILS Size===> ');
                                                                WS_FetchSMEInfo_Helper.createORupdateFaciCollatAppCollat(cusObj.FACILITY_DETAILS,TLapplicationId);
                                                            }
                                                        }
                                                        /*Term Loan V1- End*/
                                                        
                                                    }
                                                    If(cusObj.Key_Person_Details !=null && accountId != null && accountId != '' && applicationId != null && applicationId != ''){
                                                        WS_FetchSMEInfo_Helper.createParties(accountId,applicationId,cusObj.Key_Person_Details,reqObj.TYPE);
                                                    }    
                                                } 
                                            }else{
                                                accountId = WS_FetchSMEInfo_Helper.updateCustomerDetails(cusObj,reqObj.TYPE,reqObj.Customer_ID,null);
                                                System.debug('****New Business Account****');
                                                If(accountId != null && accountId != '') {
                                                    applicationId = WS_FetchSMEInfo_Helper.createApplication(accountId,reqObj.TYPE,cusObj,null);
                                                    if(applicationId!=null){
                                                        TermLoan_SOQL_Util.createInputRecord(applicationId, 'Customer');
                                                    }
                                                    if(cusObj.FACILITY_DETAILS!= null){
                                                        TLapplicationId = WS_FetchSMEInfo_Helper.createApplication(accountId,reqObj.TYPE,cusObj,'Term Loan');
                                                    }
                                                    if(TLapplicationId!= null && TLapplicationId!= '' ){
                                                        WS_FetchSMEInfo_Helper.createParties(accountId,TLapplicationId,cusObj.TL_KEY_PERSON_DETAILS,reqObj.TYPE);
                                                        if(cusObj.FACILITY_DETAILS !=null){
                                                            WS_FetchSMEInfo_Helper.createORupdateFaciCollatAppCollat(cusObj.FACILITY_DETAILS,TLapplicationId); 
                                                        }
                                                    }
                                                }
                                                If(cusObj.Key_Person_Details !=null && accountId != null && accountId != '' && applicationId != null && applicationId != ''){
                                                    WS_FetchSMEInfo_Helper.createParties(accountId,applicationId,cusObj.Key_Person_Details,reqObj.TYPE);
                                                }
                                            }
                                        }else{
                                            genesis__Applications__c AppByNameId = SOQL_Util.getApplicationId_By_Name(reqObj.LOS_APPLICATION_NAME,reqObj.LOS_Application_ID);
                                            If(AppByNameId !=null && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                                
                                                If(System.today() > AppByNameId.CreatedDate.addDays(Integer.valueOf(Label.Application_Expiry_Days)) && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                                    return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application Expired.');
                                                }
                                                applicationId = AppByNameId.id;
                                                accountId = AppByNameId.genesis__Account__r.CBS_Customer_ID__c;
                                                
                                            }
                                        }
                                    }else {
                                        applicationId = reqObj.LOS_Application_ID;
                                        genesis__Applications__c AppByNameId = SOQL_Util.getApplicationId_By_Name(reqObj.LOS_APPLICATION_NAME,reqObj.LOS_Application_ID);
                                        If(AppByNameId !=null && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                            If(System.today() > AppByNameId.CreatedDate.addDays(Integer.valueOf(Label.Application_Expiry_Days)) && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                                return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application Expired.');
                                            }
                                            applicationId = AppByNameId.id;
                                            accountId = AppByNameId.genesis__Account__r.CBS_Customer_ID__c;
                                            
                                        }
                                        
                                    }
                                }   
                                
                            } catch (Exception e) {
                                Database.rollback(sp);
                                system.debug('Exception:::::' + e.getMessage() + '!!!' + e.getLineNumber());
                                return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application already exists for the customer in LOS. Request you to retrieve the application by navigating to Active application tab.');
                            }
                            If(accountId != null && accountId != '' && applicationId != null && applicationId != '') {
                                try {
                                    //res.customerFullView = SMELoan_Helper.getCustomer(applicationId, accountId);
                                    res.customerFullView = Handle_FetchSMEReq_Response.getApplicationInfo(accountId, applicationId);
                                } catch (Exception e) {
                                    system.debug('Exception::' + e.getMessage() + e.getLineNumber());
                                    return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Exception' + e.getMessage() + e.getLineNumber()+e.getStackTraceString());
                                }
                            }
                        }
                    } else {
                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'TYPE is required.');
                    }
                }
                
                if(!isApplicationPresent){
                    if (reqObj.Customer_ID == null && reqObj.Customer_ID == '' && reqObj.TYPE != 'NTB') {
                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Customer_ID is required.');
                    }
                    // NTB APPLICATION
                    if ((reqObj.Customer_ID == null || reqObj.Customer_ID == '') && reqObj.TYPE == 'NTB') {
                        
                        WS_FetchSMEInfo_Helper.CustomerDetail cusObj = (WS_FetchSMEInfo_Helper.CustomerDetail) reqObj.CustomerDetail;
                        String applicationId = '';
                        String accountObjId = '';
                        Savepoint sp = Database.setSavepoint();
                        System.debug('cusObj' + cusObj);
                        try {
                            If(reqObj.LOS_Application_ID == null || reqObj.LOS_Application_ID == ''){
                                If(reqObj.LOS_APPLICATION_NAME ==null || reqObj.LOS_APPLICATION_NAME ==''){ //genesis__Account__r.Cust_mobile_phone__c
                                    If(cusObj != null) {
                                        String appId = '';
                                        List<Account> listOfAccount = SOQL_Util.getAccountDetails(cusObj.PAN);
                                        If(listOfAccount !=null && listOfAccount.size()>0){
                                            Boolean isAppPresent = false;
                                            String AppName = '';
                                            If(listOfAccount[0].genesis__Applications_account__r.size() > 0){
                                                for(genesis__Applications__c   appObj :  listOfAccount[0].genesis__Applications_account__r){
                                                    if(appObj !=null && appObj.Application_Stage__c !=null && appObj.Application_Stage__c !='Discontinued Application' && appObj.Application_Stage__c !='New loan - Application close' && appObj.Application_Stage__c !='Application Rejected' && appObj.Application_Stage__c !='Limit Opened'){
                                                        isAppPresent = true;
                                                        AppName	=	appObj.Name;
                                                        break;
                                                    }
                                                }    
                                            }
                                            If(isAppPresent) {
                                                return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Multiple PAN number '+listOfAccount[0].Pan_Number__c+' exists for same business customer in LOS – Please contact DTPC call center ');
                                            }else{
                                                //for existing Customer.
                                                accountObjId = WS_FetchSMEInfo_Helper.updateCustomerDetails(cusObj,reqObj.TYPE,reqObj.Customer_ID,listOfAccount[0]);
                                                System.debug('accountObjId===> '+accountObjId);
                                                If(accountObjId != null && accountObjId != '') {
                                                    
                                                    applicationId = WS_FetchSMEInfo_Helper.createApplication(accountObjId,reqObj.TYPE,cusObj,null);
                                                    if(applicationId != null && applicationId !='')
                                                    TermLoan_SOQL_Util.createInputRecord(applicationId, 'Customer');
                                                }

                                                If(cusObj.Key_Person_Details !=null && accountObjId != null && accountObjId != '' && applicationId != null && applicationId != ''){
                                                    WS_FetchSMEInfo_Helper.createParties(accountObjId,applicationId,cusObj.Key_Person_Details,reqObj.TYPE);
                                                }    
                                            } 
                                        }else {
                                            accountObjId = WS_FetchSMEInfo_Helper.updateCustomerDetails(cusObj,reqObj.TYPE,reqObj.Customer_ID,null);
                                            
                                            If(accountObjId != null && accountObjId != '') {
                                                
                                                applicationId = WS_FetchSMEInfo_Helper.createApplication(accountObjId,reqObj.TYPE,cusObj,null);
                                                
                                            }
                                            If(cusObj.Key_Person_Details !=null && accountObjId != null && accountObjId != '' && applicationId != null && applicationId != ''){
                                                WS_FetchSMEInfo_Helper.createParties(accountObjId,applicationId,cusObj.Key_Person_Details,reqObj.TYPE);
                                            }
                                            
                                        }
                                    }
                                }else{
                                    genesis__Applications__c AppByNameId = SOQL_Util.getApplicationId_By_Name(reqObj.LOS_APPLICATION_NAME,reqObj.LOS_Application_ID);
                                    
                                    If(AppByNameId !=null && AppByNameId.RecordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                        
                                        If(System.today() > AppByNameId.CreatedDate.addDays(Integer.valueOf(Label.Application_Expiry_Days)) && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application Expired.');
                                        }
                                        applicationId = AppByNameId.id;
                                        accountObjId = AppByNameId.genesis__Account__r.CBS_Customer_ID__c;
                                        
                                    }
                                }
                                
                            }else {
                                applicationId = reqObj.LOS_Application_ID;
                                genesis__Applications__c AppByNameId = SOQL_Util.getApplicationId_By_Name(reqObj.LOS_APPLICATION_NAME,reqObj.LOS_Application_ID);
                                If(AppByNameId !=null && AppByNameId.RecordType.developerName == Constants.SME_NEW_LOAN_RECORD_TYPE){
                                    
                                    If(System.today() > AppByNameId.CreatedDate.addDays(Integer.valueOf(Label.Application_Expiry_Days)) && AppByNameId.Application_Stage__c == 'New loans - Application created'){
                                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application Expired.');
                                    }
                                    applicationId = AppByNameId.id;
                                    accountObjId = AppByNameId.genesis__Account__r.CBS_Customer_ID__c;
                                }
                                
                            }
                            
                        } catch (Exception ex) {
                            Database.rollback(sp);
                            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Application already exists for the customer in LOS. Request you to retrieve the application by navigating to Active application tab.'+ex.getMessage() + ex.getLineNumber()+ex.getStackTraceString());
                        }
                        If(accountObjId != null && accountObjId != '' && applicationId != null && applicationId != '') {
                            try {
                                TermLoan_SOQL_Util.createInputRecord(applicationId,'Customer');
                                //res.customerFullView = SMELoan_Helper.getCustomer(applicationId, accountObjId);
                                res.customerFullView = Handle_FetchSMEReq_Response.getApplicationInfo(accountObjId, applicationId);
                            } catch (Exception e) {
                                system.debug('Exception::' + e.getMessage() + e.getLineNumber());
                                return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Exception' + e.getMessage() + e.getLineNumber()+e.getStackTraceString());
                            }
                        }
                    } else if (reqObj.Customer_ID == null || reqObj.Customer_ID == '' && reqObj.TYPE == '') {
                        return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Customer_ID and NTB is Required');
                        
                    }
                }
                System.debug('No of queries used so far'+Limits.getQueries());
            } catch (Exception ex) {
                system.debug('Exception::' + ex.getMessage() + ex.getMessage() + ex.getLineNumber());
                return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Exception' + ex.getMessage() + ex.getLineNumber()+ex.getStackTraceString());
            }
            
            return res;
        }
    }
    static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg) {
        res.status = status;
        res.successMessage = succMsg;
        res.statusCode = statusCode;
        res.errorMessage = errMsg;
        return res;
    }

     
    
}