/*
* Name      : WS_CBS_Collateral_Linkage_HL
* Compnay   : ET Marlabs
* Purpose   : For HL Service(Collateral linkage) 
* Author    : Subas
*/
public class WS_CBS_Collateral_Linkage_HL {
  @future (Callout=true)
    public static void linkCollateralF(String AppId,String loanNo){
        List<CBS_API_Log__c> UpcbsLog =  new List<CBS_API_Log__c>();
        linkCollateral(AppId,loanNo,UpcbsLog);
    }
    public static void linkCollateral(String AppId,String loanNo,List<CBS_API_Log__c> UpcbsLog){
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appId);
        List<ID> AccIDs = new List<ID>();
        //List<clcommon__Collateral__c> collList = queryService.getCollateral(appId);
        List<clcommon__Collateral__c> collList = queryService.getCollateralWithAccID(AccIDs,appId,'CL');
        Collateral_Linkage_Helper_HL cbs = new Collateral_Linkage_Helper_HL();
        cbs.inputVariables = new Collateral_Linkage_Helper_HL.cls_inputVariables();
        Collateral_Linkage_Helper_HL.cls_inputVariables cbsCol = new Collateral_Linkage_Helper_HL.cls_inputVariables();
        cbsCol.in_msg = new Collateral_Linkage_Helper_HL.cls_in_msg();
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbsCol.in_msg.serviceName = 'Term_Loan_Linkage_Collateral_HL';
        cbsCol.in_msg.ApplicationId = AppId;
        cbsCol.in_msg.LinkCollateralDetails = new List<Collateral_Linkage_Helper_HL.cls_LinkCollateralDetails>();
		if(application.Record_Type_Name__c == Constants.HOMELOAN || application.Record_Type_Name__c == Constants.VL4W || application.Record_Type_Name__c == Constants.VL2W){
            Collateral_Linkage_Helper_HL.cls_LinkCollateralDetails rq = new Collateral_Linkage_Helper_HL.cls_LinkCollateralDetails();
            rq.ApplicantID = application.Primary_Applicant_Id__c;
            rq.TransactionBranch = application.Branch_Code__c;
            rq.AccountNo = application.Loan_Account_Number__c;
            rq.CollateralCode = '107';
            rq.CollateralID = application.Loan_Account_Number__c + '1';//application.Primary_Collateral_ID__c;
            //added by prashant singh on 22-11-2018....collateral structure changes----collList[0]
					
            rq.CollateralValue =  collList[0].Total_Market_value__c!= null ? String.ValueOf(collList[0].Total_Market_value__c) : '';//String.ValueOf(application.Cost_Of_Flat_House__c);
            //prashant ends 

            if(application.Record_Type_Name__c == Constants.VL4W || application.Record_Type_Name__c == Constants.VL2W){
                rq.CollateralValue = collList[0].Total_Vehicle_Value__c != null ? String.ValueOf(collList[0].Total_Vehicle_Value__c) : '';//String.ValueOf(application.Cost_Of_Flat_House__c);
            }
            if(application.Record_Type_Name__c  == Constants.VL2W){
                rq.CollateralCode ='144'; 
            }
            if(application.Record_Type_Name__c  == Constants.VL4W){
                rq.CollateralCode ='119'; 
            }  
            rq.ExtUniqueRefId = '1';
            rq.FlgOperation = 'A';
            rq.SecurityType = 'P';
            rq.Channel = 'BRN';
			if(application.Sub_Type__c==Constants.Sub_Type_Top_Up){
				List<Facility__c> FacList=queryService.getFacilityRecord(application.id,true);
				if(FacList.size()>0 && FacList!=null){
					List<CBS_API_Log__c> CBSLogs=[select id,Sequence_No__c,Status__c from CBS_API_Log__c where Sequence_No__c='6.1' and Status__c='Success' and Application__c=:application.id];
					if(CBSLogs.size()==0){
			rq.CollateralID = collList[0].CBS_Collateral_ID__c;//application.Primary_Collateral_ID__c;
			rq.AccountNo = FacList[0].Existing_HL_Loan_Account_No__c ;
			 rq.FlgOperation = 'D';
					}
					else if(CBSLogs.size()==1){
                        decimal totMvalue= collList[0].Total_Market_value__c!=null?collList[0].Total_Market_value__c:0;
                        decimal topExistingHL= FacList[0].Existing_HL_Oustanding_Balance__c!=null?FacList[0].Existing_HL_Oustanding_Balance__c:0;
                        decimal SacAmount= application.Sanction_Authority_Limit__c!=null?application.Sanction_Authority_Limit__c:0;
					Collateral_Linkage_Helper_HL.cls_LinkCollateralDetails rqe = new Collateral_Linkage_Helper_HL.cls_LinkCollateralDetails();
					rqe.ApplicantID = application.Primary_Applicant_Id__c;
					rqe.TransactionBranch = application.Branch_Code__c;
					rqe.AccountNo = FacList[0].Existing_HL_Loan_Account_No__c;
					rqe.CollateralCode = '107';
					rqe.CollateralID = collList[0].CBS_Collateral_ID__c;
                    rq.CollateralID=collList[0].CBS_Collateral_ID__c;
                    rq.CollateralValue =  ((topExistingHL/(topExistingHL+SacAmount))*totMvalue)!=null?String.ValueOf(((topExistingHL/(topExistingHL+SacAmount))*totMvalue)):'';
					rqe.CollateralValue =  ((SacAmount/(topExistingHL+SacAmount))*totMvalue)!=null?String.ValueOf(((SacAmount/(topExistingHL+SacAmount))*totMvalue)):'';
					rqe.ExtUniqueRefId = '1';
					rqe.FlgOperation = 'A';
					rqe.SecurityType = 'P';
					rqe.Channel = 'BRN';
					cbsCol.in_msg.LinkCollateralDetails.add(rqe);
					}
				}
			}
            cbsCol.in_msg.LinkCollateralDetails.add(rq);
        }
		else if(application.Record_Type_Name__c == Constants.LAPLOAN){
            if(collList.size() > 0){
                Integer i = 0;
                for(clcommon__Collateral__c col : collList){
                    Collateral_Linkage_Helper_HL.cls_LinkCollateralDetails rq = new Collateral_Linkage_Helper_HL.cls_LinkCollateralDetails();
                    rq.ApplicantID = application.Primary_Applicant_Id__c;
                    rq.TransactionBranch = application.Branch_Code__c;
                    rq.AccountNo = application.Loan_Account_Number__c;
                    rq.CollateralCode = '107';
                    i = i + 1;
                    rq.CollateralID = application.Loan_Account_Number__c + string.valueOf(i);//application.Primary_Collateral_ID__c;
                    rq.CollateralValue = col.Collateral_Market_Value__c != null ? String.ValueOf(col.Collateral_Market_Value__c) : '';	
                    rq.ExtUniqueRefId = string.valueOf(i);
                    rq.FlgOperation = 'A';
                    rq.SecurityType = 'P';
                    rq.Channel = 'BRN';
                    cbsCol.in_msg.LinkCollateralDetails.add(rq);      
                }
            }
        }
        cbs.inputVariables = cbsCol;        
        callCollateralLink(JSON.serialize(cbs),application,loanNo,UpcbsLog);
    }
    public static void callCollateralLink(String collateralDetails,genesis__Applications__c application,String loanNo,List<CBS_API_Log__c> UpcbsLog){
        System.debug('#######'+collateralDetails);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Bulk_API');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,collateralDetails,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
      List<CBS_API_Log__c> CBSLogs=[select id,Sequence_No__c,Status__c from CBS_API_Log__c where Sequence_No__c='6.2' and Status__c='Success'];   
        try{ 
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                Collateral_Linkage_Helper_HL.Collateral_Linkage_Response res = (Collateral_Linkage_Helper_HL.Collateral_Linkage_Response)Json.deserialize(jsonString,Collateral_Linkage_Helper_HL.Collateral_Linkage_Response.class);
                system.debug('**Res**'+res);
				 if(loanNo != null && application.id !=null){
                    genesis__Applications__c a= new genesis__Applications__c();
                    a.Id = application.id;
                    a.Loan_Account_Number__c = loanNo;
                    update a;
                }   
				if(res.out_msg.Status_Desc != 'Success'){
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = application.id;
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.Status_Desc;
					if(CBSLogs.size()==0 && application.Sub_Type__c==Constants.Sub_Type_Top_Up){
						log.API_Name__c = 'Term_Loan_Delete_Collateral_HL';
                    log.Sequence_No__c = '6.1';
					}
					else{
					log.API_Name__c = 'Term_Loan_Linkage_Collateral_HL';
                    log.Sequence_No__c = '7';
					}					
                    UpcbsLog.add(log); 
                } 
                insert UpcbsLog;
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = application.id;
                log.Status__c = 'Failure';
               
				if(CBSLogs.size()==0 && application.Sub_Type__c==Constants.Sub_Type_Top_Up){
					log.API_Name__c = 'Term_Loan_Delete_Collateral_HL';
                    log.Sequence_No__c = '6.1';
					log.Success_Error_Message__c = 'CollateralDeletion_CBS_Error_No_Hit';
					}
					else{
					log.API_Name__c = 'Term_Loan_Linkage_Collateral_HL';
                    log.Sequence_No__c = '7';
					log.Success_Error_Message__c = 'CollateralLinkage_CBS_Error_No_Hit';
					}	  
                insert log;             
            }
        }catch(exception e){
            HandleBusinessException.captureError('Term_Loan_Linkage_Collateral_HL','callCollateralLink', e);
            CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = application.id;
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = 'Exception '+e.getMessage();
					if(CBSLogs.size()==0 && application.Sub_Type__c==Constants.Sub_Type_Top_Up){
						log.API_Name__c = 'Term_Loan_Delete_Collateral_HL';
                    log.Sequence_No__c = '6.1';
					}
					else{
					log.API_Name__c = 'Term_Loan_Linkage_Collateral_HL';
                    log.Sequence_No__c = '7';
					}					
                    UpcbsLog.add(log);
            insert log;
        }
    }
    
}