public class SME_CBS_Shiv{

	public static Boolean dLinkFlag                     = true;
    public static Boolean collLinkageFlag               = false;
    public static Boolean newAccountFlag                = false;
    public static Boolean keyPersonLinkageFlag          = false;
    public static Integer partiesCount;
    public static String cbsCustId                      = '';
    public static Map<Id,String> facIdAccNumberMap      = new Map<Id,String>();
    public static Map<String,Id> mapOfFacilityId        = new Map<String,Id>();
    public static genesis__Applications__c app          = new genesis__Applications__c();
    public static Map<String,String> mapcust                   = new Map<String,String>();
    public static void requestHandler(String appId){
        try{
            genesis__Applications__c app                    = new genesis__Applications__c();
            app = [SELECT Name,genesis__Additional_Cash_Required__c ,Application_Stage__c,genesis__Rate_Floor__c,Legal_desk_state_flag__c,
                   RecordType.DeveloperName,genesis__Account__r.RecordType.DeveloperName,Type__c,genesis__Account__r.Name,genesis__Account__r.CBS_Customer_ID__c,
                   genesis__Account__r.Aadhaar_Number__pc,genesis__Account__r.Customer_IC__c,genesis__Account__r.Pan_Number__c,EAE_Renewal_Date_in_days__c,genesis__Account__r.Branch_Code__c,Id,Cibil_Charges__c,Processing_Charges__c,Charge_collection_done__c,Service_Type_Name__c,Branch_Code__c,genesis__Account__c,genesis__Account__r.Drawing_Power__c,
                   (SELECT Id,Recommended_Limit__c,Account_Number__c FROM Facilities__r),
                   (SELECT Id,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c,genesis__Party_Account_Name__r.Pan_Number__c, genesis__Party_Account_Name__r.Aadhaar_Number__c,genesis__Party_Account_Name__r.Aadhaar_Number__pc,
                    genesis__Party_Account_Name__r.Customer_IC__c	FROM genesis__Application_Parties__r where Active__c=true),
                   (SELECT Id,genesis__Collateral__c FROM Application_Collateral__r WHERE genesis__Collateral__r.FE_Created__c = true)
                   FROM genesis__Applications__c WHERE Id =: appId];          
            
              system.debug('==========>'+app);      
               dedupeCheck(app); 
            }catch(Exception e){}
            
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
	            List<WS_CBS_Dedupe.cls_ApplicantDetails> lstappdetail=new List<WS_CBS_Dedupe.cls_ApplicantDetails>();
	            WS_CBS_Dedupe.cls_ApplicantDetails appdetail = new WS_CBS_Dedupe.cls_ApplicantDetails();
	            appdetail.adharNo = app.genesis__Account__r.Pan_Number__c != null ? WS_getAadharNo.getAadharNo(app.genesis__Account__r.Pan_Number__c) : '';
	            appdetail.panNo = app.genesis__Account__r.Pan_Number__c != null ? app.genesis__Account__r.Pan_Number__c : '';
	            appdetail.custIc = app.genesis__Account__r.Customer_IC__c != null ? app.genesis__Account__r.Customer_IC__c : '';
	            if(app.genesis__Account__r.RecordType.DeveloperName != null && app.genesis__Account__r.RecordType.DeveloperName == 'Business_Account'){
	                appdetail.ExpCustType = 'B';
	                mapcust.put(app.genesis__Account__r.CBS_Customer_ID__c,'B');
	            }if(app.genesis__Account__r.RecordType.DeveloperName != null && app.genesis__Account__r.RecordType.DeveloperName == 'PersonAccount'){
	                appdetail.ExpCustType = 'P';
	            }
	            appdetail.applicantId                               = app.genesis__Account__c;

	            dedupeReq.inputVariables.in_msg.ApplicantDetails.add(appdetail);
	            if(app.genesis__Application_Parties__r!=null && app.genesis__Application_Parties__r.size()>0){
	            	partiesCount=app.genesis__Application_Parties__r.size();
	            	for(genesis__Application_Parties__c partyrec:app.genesis__Application_Parties__r){
	            		mapcust.put(partyrec.genesis__Party_Account_Name__r.CBS_Customer_ID__c,'P');
	            		WS_CBS_Dedupe.cls_ApplicantDetails appdetailrec = new WS_CBS_Dedupe.cls_ApplicantDetails();
	            		appdetailrec.applicantId=partyrec.genesis__Party_Account_Name__c;
	            		appdetailrec.adharNo=partyrec.genesis__Party_Account_Name__r.Aadhaar_Number__pc != null ? WS_getAadharNo.getAadharNo(partyrec.genesis__Party_Account_Name__r.Pan_Number__c) : '';
	            		appdetailrec.panNo=partyrec.genesis__Party_Account_Name__r.Pan_Number__c !=null ? partyrec.genesis__Party_Account_Name__r.Pan_Number__c : '';
	            		appdetailrec.custIc=partyrec.genesis__Party_Account_Name__r.Customer_IC__c !=null ? partyrec.genesis__Party_Account_Name__r.Customer_IC__c: '';
	            		appdetailrec.ExpCustType='P';
	            		dedupeReq.inputVariables.in_msg.ApplicantDetails.add(appdetailrec);
	            	}
	            }
	            System.debug('DedupeReq::'+JSON.serialize(dedupeReq));
	            Map<String,String> headerMap                            = new Map<String,String>();
	            headerMap.put('Content-Type','application/json');
	            HTTPResponse response                                   = new HTTPResponse();
	            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('CBS_Dedupe_Bulk_NewLoan_New'), 'POST', null,JSON.serialize(dedupeReq),headerMap,label.CA_CERTIFICATE);
	            system.debug('$$$$'+response.getBody());
	            CBS_API_Log__c log                              = new CBS_API_Log__c();
	            log.Application__c                              = app.Id;
	            log.API_Name__c                                 = 'Dedupe_Status_SME_NewLoan';
	            //log.Sequence_No__c                              = '16';
	            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
	                String jsonString = response.getBody();
	                WS_CBS_Dedupe.CBS_Dedupe_Response res = (WS_CBS_Dedupe.CBS_Dedupe_Response)Json.deserialize(jsonString, WS_CBS_Dedupe.CBS_Dedupe_Response.class);
	                if(res.out_msg.DedupeSuccessResponse != null && res.out_msg.DedupeSuccessResponse.size() > 0 && partiesCount == (res.out_msg.DedupeSuccessResponse.size() -1)){
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
	                //logList.addAll(createLoanAccount(app,false));
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
                            loanAccCreate.inputVariables                                               = new SME_CBS_EAE_Formatter.cls_inputVariables();
                            loanAccCreate.inputVariables.in_msg                                        = new SME_CBS_EAE_Formatter.cls_in_msg();
                            loanAccCreate.inputVariables.in_msg.CASA_ACCT_DTLS                         = new List<SME_CBS_EAE_Formatter.cls_CASA_ACCT_DTLS>();
                            SME_CBS_EAE_Formatter.cls_CASA_ACCT_DTLS casadetails                       = new SME_CBS_EAE_Formatter.cls_CASA_ACCT_DTLS();
                            casadetails.Cod_Cust1               = facObj.Application__r.genesis__Account__r.CBS_Customer_ID__c !=null ? facObj.Application__r.genesis__Account__r.CBS_Customer_ID__c : '';
                            casadetails.Cod_Acct_Cust_Rel1      = Constants.CODE_ACCT_CUST_REL1;
                            casadetails.Nam_Cust_Shrt           = facObj.Application__r.genesis__Account__r.Name !=null ? facObj.Application__r.genesis__Account__r.Name : '';
                            casadetails.Cod_Cc_Brn              = facObj.Application__r.Branch_Code__c !=null ? facObj.Application__r.Branch_Code__c : '';
                            casadetails.Cod_Prod                = facObj.CL_Product__r.Product_Code__c !=null ? facObj.CL_Product__r.Product_Code__c : '';
                            casadetails.Cod_Org_Brn             = facObj.Application__r.Branch_Code__c !=null ? facObj.Application__r.Branch_Code__c : '';
                            casadetails.Acct_Desc               = facObj.Application__r.genesis__Account__r.Name !=null ? facObj.Application__r.genesis__Account__r.Name : '';
                            casadetails.Cod_Cust2               = Constants.CODE_CUST_2;
                            casadetails.Cod_Acct_Cust_Rel2      = '';
                            casadetails.Cod_Cust3               = Constants.CODE_CUST_3;
                            casadetails.Cod_Acct_Cust_Rel3      = '';
                            casadetails.Flg_Sc_Waiver           = Constants.FLG_SC_WAIVER;
                            casadetails.Flg_Int_Waiver          = Constants.FLG_INT_WAIVER;
                            casadetails.Cod_Officerid           = Constants.CODE_OFFICER_ID;
                            casadetails.Cod_Makerid             = Constants.CODE_MAKER_ID;
                            casadetails.Cod_Chkrid              = Constants.CODE_CHECKKER_ID;
                            casadetails.Cod_Lang                = Constants.CODE_LANG;
                            casadetails.Flg_Joint_Acct          = Constants.FLAG_JOINT_ACC;
                            casadetails.Cod_Module              = Constants.CODE_MODULE;
                            casadetails.Cod_Tds                 = Constants.CODE_TDS;
                            casadetails.Cod_Tds_2               = Constants.CODE_TDS_2;
                            casadetails.User_Id                 = Constants.USER_ID;
                            casadetails.Cod_Laps_Reference_No   ='';
                            casadetails.Limit_Amt               ='';
                            casadetails.API_Trigger_Date        ='';
                            loanAccCreate.inputVariables.in_msg.CASA_ACCT_DTLS.add(casadetails);
                            
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
                            //cbsLogList.addAll(new_LoanAccount_Callout(JSON.serialize(accCreation),app));
                        }
                        If(newAccountFlag){
                            //cbsLogList.addAll(collCreation(app,true));  
                            //keyPersonLinkage(app.Id);                         
                        }
                        if(cbsLogList.size() > 0 && reTry){
                            insert cbsLogList;
                            ApplicationTriggerHandler.IsFirstRun = false;
                            UPDATE app;
                        }
                    }
                } 
                if(facIdAccNumberMap.size() > 0){
                    //facilityAccNumberUpdate(mapOfFacilityId,facIdAccNumberMap);
                }
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        RETURN cbsLogList;
    }

	}