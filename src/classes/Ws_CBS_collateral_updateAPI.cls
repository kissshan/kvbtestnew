/*
* Name      : Ws_collateral_updateAPI
* Compnay   : ET Marlabs
* Purpose   : For VL collateral update api 
* Author    : Niladri
*/
public class Ws_CBS_collateral_updateAPI {
    @future (Callout=true)
    public static void Collateral_Update(String appId,String loanNo){
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appId);
        List<ID> AccIDs = new List<ID>();     
        List<clcommon__Collateral__c> collList = queryService.getCollateral(appId);
        Collateral_Creation_Helper_HL cbs = new Collateral_Creation_Helper_HL();
        cbs.inputVariables = new Collateral_Creation_Helper_HL.cls_inputVariables();
        Collateral_Creation_Helper_HL.cls_inputVariables cbsCol = new Collateral_Creation_Helper_HL.cls_inputVariables();        
        cbsCol.in_msg = new Collateral_Creation_Helper_HL.cls_in_msg();
        cbs.inputVariables = cbsCol;
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbsCol.in_msg.serviceName = 'Loan_Collateral_Creation_HL';
        cbsCol.in_msg.ApplicationId = appId;
        cbsCol.in_msg.CollateralCreationDetails = new List<Collateral_Creation_Helper_HL.cls_CollateralCreationDetails>();
       if((application.Record_Type_Name__c  == Constants.VL2W || application.Record_Type_Name__c  == Constants.VL4W) && application.Sub_Stage__c=='Collaterals details captured'){
           System.debug('**inside');
            Collateral_Creation_Helper_HL.cls_CollateralCreationDetails rq = new Collateral_Creation_Helper_HL.cls_CollateralCreationDetails();
            rq.ApplicantId = application.Primary_Applicant_Id__c;
            rq.Channel ='BRN';
            rq.TransactionBranch =application.Branch_Code__c;
		    String CollId = '';
			 if(loanNo != null){
                CollId = loanNo + '1';  //For one collateral Id creation
            }else{
                CollId = application.Loan_Account_Number__c + '1';
            }    
            rq.CollateralID =CollId;
            rq.CollateralCode ='144';           
            rq.BranchCode = application.Branch_Code__c; 
            rq.DocumentCode =''; 
            rq.FlgOperation ='M';     
            rq.TypeofCharge = '1';                   
            rq.NameofLender = '';                
            rq.DeedStatus = '';
            rq.CustodianName ='';    
            rq.DateDeedsSent = '';
            rq.ExpectedReturnDate ='';  
            rq.DeedDetails ='deed';
            rq.RegisteringAuth =''; 
            rq.InsurancePlanCode ='';   
            rq.InsurancePolicyNumber ='';   
            rq.InsurancePremiumBilling =''; 
            rq.BillingMode =''; 
            rq.Percentage ='';  
            rq.PremiumBilingAccount ='';    
            rq.InsurancePremiumAmount ='';  
            rq.NonStandardCollId ='';   
            rq.Description1 ='';    
            rq.Description2 ='';       
            rq.DescriptionAuto1 ='.';
            rq.DescriptionAuto2 ='.';
            if(application.Record_Type_Name__c  == Constants.VL2W || application.Record_Type_Name__c  == Constants.VL4W){
                rq.ChasisNumber =collList[0].Chassis_Number__c != null ? collList[0].Chassis_Number__c : '0';    
                rq.EngineNumber =collList[0].clcommon__Vehicle_Serial_Number__c != null ?collList[0].clcommon__Vehicle_Serial_Number__c :'0';    
                rq.RegistrationNumber =collList[0].RC_No__c != null ? collList[0].RC_No__c :'0';  
                rq.OriginalValue = collList[0].Total_Vehicle_Value__c != null ? String.ValueOf(collList[0].Total_Vehicle_Value__c) : '';  
                rq.LastValue = collList[0].Total_Vehicle_Value__c != null ? String.ValueOf(collList[0].Total_Vehicle_Value__c) : '';  
                rq.MarketValue = collList[0].Total_Vehicle_Value__c != null ? String.ValueOf(collList[0].Total_Vehicle_Value__c) : '';    
                rq.DatOrginalValuation =application.Sanction_Date__c != null ? String.ValueOf(application.Sanction_Date__c).replace('-','') : ''; 
                rq.DatLastValuation = application.Sanction_Date__c != null ? String.ValueOf(application.Sanction_Date__c).replace('-','') : '';
            	rq.ModelNumber = String.ValueOf(collList[0].clcommon__Model__c);	
                String MonthsStr;
                if(collList[0].Month__c!=null && collList[0].Month__c.length() == 1){
                    MonthsStr = '0'+collList[0].Month__c;
                }else{
                    MonthsStr = collList[0].Month__c != null ? collList[0].Month__c : '';
                }				
                rq.YearofMfg = String.ValueOf(collList[0].clcommon__Year__c)+MonthsStr; 				
               
            }
           
         /*  if(application.Record_Type_Name__c  == Constants.VL2W){
                rq.CollateralCode ='144'; 
            }
            if(application.Record_Type_Name__c  == Constants.VL4W){
                rq.CollateralCode ='119'; 
            }  */
            rq.SecurityCode ='';    
            rq.NumberofUnits ='';   
            rq.SeriesNumber1 ='';   
            rq.SeriesNumber2 ='';   
            rq.Location ='';
			rq.AreaUnit ='';   
            rq.TotalArea = '';
            rq.TypeofProperty ='';
            rq.DatLeaseExpiry ='';  
            rq.ForcedSaleValue =''; 
            rq.QuitRentValue ='';   
            rq.DescriptionProp1 ='.';   
            rq.DescriptionProp2 ='.';   
            rq.Make ='';    
            rq.SLNum ='';   
            rq.RegNo ='';   
            rq.EngNo ='';   
            rq.HPCapacity ='';  
            rq.MachDesciption ='';  
            rq.AreaCult ='';    
            rq.AreaLand ='';    
            rq.DetailsCult =''; 
            rq.VillageNam ='';  
            rq.SurveyNo ='';    
            rq.SecDescription1 =''; 
            rq.SecDescription2 =''; 
            rq.Breed ='';   
            rq.Age =''; 
            rq.Quantity ='';    
            rq.CatDescription1 =''; 
            rq.CatDescription2 =''; 
            rq.IdentMArk ='';   
            rq.ASNAcctNumber ='';   
            rq.TotNumUnits =''; 
            rq.CertNumber ='';  
            rq.CertNumber1 =''; 
            rq.CertNumber2 =''; 
            rq.CertNumber3 =''; 
            rq.CertNumber4 =''; 
            rq.DivDate =''; 
            rq.SecurityCodec ='';   
            rq.GrossWeight =''; 
            rq.NetWeight ='';   
            rq.AppraiserValue ='';  
            rq.DateValuation ='';   
            rq.DescCommodity ='';   
            rq.ExtUniqueRefId ='1';  //make it qnique
            if(application.genesis__CL_Product_Name__c!=null){
                if(application.genesis__CL_Product_Name__c.contains('Co-Lending') && application.Record_Type_Name__c  != Constants.VL2W && application.Record_Type_Name__c  != Constants.VL4W){
                    rq.NameofLender = application.Sourced_By__c;
                }
            }
           System.debug('rq'+rq);
            cbsCol.in_msg.CollateralCreationDetails.add(rq);
        }

        updateCollateral(JSON.serialize(cbs),appId,loanNo);
    }
    public static void updateCollateral(String collateralData, String applicationId,String loanNo){
       List<CBS_API_Log__c> UpcbsLog=new List<CBS_API_Log__c>();
        genesis__Applications__c appdata=[select id,Sub_Stage__c from genesis__Applications__c where id=:applicationId];
        List<Task> tasklist=[select id,subject,Status from task where whatid=:applicationId];
        System.debug('tasklist'+tasklist);
        System.debug('#######'+collateralData);
        List<Account> accountList = new List<Account>();
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Bulk_API');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,collateralData,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                Collateral_Creation_Helper_HL.CBS_ColletralCreation_response res = (Collateral_Creation_Helper_HL.CBS_ColletralCreation_response)JSON.deserialize(jsonString, Collateral_Creation_Helper_HL.CBS_ColletralCreation_response.class);
                system.debug('**Res**'+res);
				
        
				
                if(res.out_msg.Status_Desc != 'Success'){
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = applicationId;
                    log.API_Name__c = 'CBS_collateral_update_API';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.Status_Desc;
                    log.Sequence_No__c = '22';  
                    UpcbsLog.add(log);
                    system.debug('UpcbsLog6-->'+UpcbsLog);
                    //insert UpcbsLog; //CBS_001 
                }
				
                 if(res.out_msg.Status_Desc == 'Success'){
					if(appdata.Sub_Stage__c=='Collaterals details captured'){
                                                
            /*    CBS_API_Log__c log = new CBS_API_Log__c();    
                  log.Application__c = applicationId;
                  log.API_Name__c = 'CBS_collateral_update_API';
                  log.Status__c = 'Success';
                  log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                  log.Sequence_No__c = '22';  
                  UpcbsLog.add(log);*/
                        
                         boolean allTaskCompleted = true;
                          for(Task tk:tasklist){
                                if(tk.Status !='Completed')
                                    allTaskCompleted = false;
                            }
                          /*  if(allTaskCompleted){
                               genesis__Applications__c a= new genesis__Applications__c();
                               a.Id = applicationId;
						       a.Sub_Stage__c='Applicaton Processed - Closed';
                               a.Retry_CBS__c = True;
                               ApplicationTriggerHandler.IsFirstRun  = false; 
						       update a;
                            }*/
						 
					}
                 }
				
				
                 insert UpcbsLog; //   CBS_001
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = applicationId;
                log.API_Name__c = 'CBS_collateral_update_API';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = 'CollateralCreation_CBS_Error_No_Hit';
                log.Sequence_No__c = '22';  
                UpcbsLog.add(log);
                system.debug('UpcbsLog6-->'+UpcbsLog);
                insert UpcbsLog; //CBS_001  
            }
        }catch(exception e){
            HandleBusinessException.captureError('Ws_collateral_updateAPI','updateCollateral', e);
        }
    }
}