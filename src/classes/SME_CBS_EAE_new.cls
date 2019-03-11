public class SME_CBS_EAE_new{

	public static Boolean dLinkFlag                     = true;
    public static Boolean collLinkageFlag               = false;
    public static Boolean newAccountFlag                = false;
    public static Boolean keyPersonLinkageFlag          = false;
    public static Integer partiesCount;
    public static String cbsCustId                      = '';
    public static Map<Id,String> facIdAccNumberMap      = new Map<Id,String>();
    public static Map<String,Id> mapOfFacilityId        = new Map<String,Id>();
    public static genesis__Applications__c app          = new genesis__Applications__c();
    public static Set<String> custidSet                   = new Set<String>();
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
	            Boolean customerVeried                      = true;
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
	                custidSet.add(app.genesis__Account__r.CBS_Customer_ID__c);
	            }if(app.genesis__Account__r.RecordType.DeveloperName != null && app.genesis__Account__r.RecordType.DeveloperName == 'PersonAccount'){
	                appdetail.ExpCustType = 'P';
	            }
	            appdetail.applicantId                               = app.genesis__Account__c;

	            dedupeReq.inputVariables.in_msg.ApplicantDetails.add(appdetail);
	            if(app.genesis__Application_Parties__r!=null && app.genesis__Application_Parties__r.size()>0){
	            	partiesCount=app.genesis__Application_Parties__r.size();
	            	for(genesis__Application_Parties__c partyrec:app.genesis__Application_Parties__r){
	            		custidSet.add(partyrec.genesis__Party_Account_Name__r.CBS_Customer_ID__c);
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
	                        if(!custidSet.contains(deDupeRes.CustomerId)){
	                        	customerVeried=false;
	                        }
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
                List<Facility__c> listOfFacility  = [SELECT Id,Application__r.Branch_Name__c,NTB_Facility_Type__c,Loan_Purpose__c,Application__r.Interest_Variation__c,Application__r.Sanctioned_Tenure__c,Recommended_Limit__c,Account_Number__c,Variance__c,App_Facility_Type__c,Total_Loan_Amount__c,Applicant_Contribution__c,Application__r.genesis__Account__c,Application__r.genesis__Account__r.Name,Application__r.genesis__Account__r.CBS_Customer_ID__c,Application__r.Branch_Code__c,CL_Product__r.Product_Code__c FROM Facility__c WHERE Application__c =: app.Id AND RecordType.developerName = 'Parent' AND Active__c = true];
                SME_CBS_EAE_Formatter.RequestFormat tlloanAccCreate=new SME_CBS_EAE_Formatter.RequestFormat();
                tlloanAccCreate.inputVariables = new SME_CBS_EAE_Formatter.cls_inputVariables();
                tlloanAccCreate.inputVariables.in_msg = new SME_CBS_EAE_Formatter.cls_in_msg();
                List<SME_CBS_EAE_Formatter.cls_TL_Account_Dtls> tlactlist=new List<SME_CBS_EAE_Formatter.cls_TL_Account_Dtls>();
                If(listOfFacility !=null && listOfFacility.size() > 0){
                    for(Facility__c  facObj  :  listOfFacility){
                        System.debug(facObj.NTB_Facility_Type__c);
                        System.debug(facObj.Account_Number__c);
                        System.debug(facObj.NTB_Facility_Type__c != 'WC KVB' && facObj.NTB_Facility_Type__c != 'Renewal');
                        System.debug(facObj.Account_Number__c == null);
                        if(facObj.App_Facility_Type__c!=null && facObj.App_Facility_Type__c=='TL' && facObj.Account_Number__c==null){
                        	System.debug('inside tl Facility__c');
                        	SME_CBS_EAE_Formatter.cls_TL_Account_Dtls tlacct=new SME_CBS_EAE_Formatter.cls_TL_Account_Dtls();
                        	tlacct.AssetValue=facObj.Recommended_Limit__c != null ? String.valueOf(facObj.Recommended_Limit__c) :'';
                        	tlacct.BranchCode=facObj.Application__r.Branch_Code__c !=null ? facObj.Application__r.Branch_Code__c : '';
                        	tlacct.Contribution='0';
                        	tlacct.CustomerId=facObj.Application__r.genesis__Account__r.CBS_Customer_ID__c !=null ? facObj.Application__r.genesis__Account__r.CBS_Customer_ID__c : '';
                        	tlacct.InterestVariance=facObj.Application__r.Interest_Variation__c !=null ? String.valueOf(facObj.Application__r.Interest_Variation__c) :'';
                        	tlacct.LoanAmount=facObj.Recommended_Limit__c != null ? String.valueOf(facObj.Recommended_Limit__c) :'';
                        	tlacct.LoanPurpose=facObj.Loan_Purpose__c != null ? String.valueOf(facObj.Loan_Purpose__c) : '';
                        	tlacct.LoanTerm=facObj.Application__r.Sanctioned_Tenure__c != null ? String.valueOf(facObj.Application__r.Sanctioned_Tenure__c) : '';
                        	tlacct.ProductCode=facObj.CL_Product__r.Product_Code__c !=null ? facObj.CL_Product__r.Product_Code__c : '';
                        	tlacct.TransactionBranch=facObj.Application__r.Branch_Code__c !=null ? facObj.Application__r.Branch_Code__c : '';
                        	tlacct.ScheduleName='EMI MONTHLY';
                        	tlacct.API_Trigger_Date=String.valueOf(Date.today());
                        	tlactlist.add(tlacct);
                        }
                        else if(facObj.NTB_Facility_Type__c != 'WC KVB' && facObj.NTB_Facility_Type__c != 'Renewal' && facObj.Account_Number__c == null){
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
                    else if(tlactlist.size() > 0){
                    	System.debug('tlactlist=='+tlactlist);
                    	app.Service_Type_Name__c                = 'Loan_Account_Creation';
                    	tlloanAccCreate.inputVariables.in_msg.TL_Account_Dtls=tlactlist;
                    	System.debug('loanaccountcreationrequest::'+JSON.serialize(tlloanAccCreate));
                    	Map<String,String> headerMap                            = new Map<String,String>();
			            headerMap.put('Content-Type','application/json');
			            HTTPResponse response                                   = new HTTPResponse();
			            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('CBS_TL_Loan_Account'), 'POST', null,JSON.serialize(tlloanAccCreate),headerMap,label.CA_CERTIFICATE);
			            system.debug('$$$$'+response.getBody());
			            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
			            	
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