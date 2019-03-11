/*
* Name      : WS_CBS_Collateral_Creation
* Compnay   : ET Marlabs
* Purpose   : For HL Service(Collateral Creation) 
* Author    : Subas
*/
public class WS_CBS_Collateral_Creation {
    @future (Callout=true)
    public static void Collateral_CreationF(String appId,Map<string,string>accMap,String loanNo){
     List<CBS_API_Log__c> UpcbsLog =  new List<CBS_API_Log__c>();
    Collateral_Creation(appId,accMap,loanNo,UpcbsLog);
    }
          
    public static void Collateral_Creation(String appId,Map<string,string>accMap,String loanNo,List<CBS_API_Log__c> UpcbsLog){
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appId);
        List<ID> AccIDs = new List<ID>();
        //List<clcommon__Collateral__c> collList = queryService.getCollateral(appId);
        List<clcommon__Collateral__c> collList = queryService.getCollateralWithAccID(AccIDs,appId,'CC');
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
        if(application.Record_Type_Name__c == Constants.HOMELOAN || application.Record_Type_Name__c  == Constants.VL2W || application.Record_Type_Name__c  == Constants.VL4W){
            Collateral_Creation_Helper_HL.cls_CollateralCreationDetails rq = new Collateral_Creation_Helper_HL.cls_CollateralCreationDetails();
            rq.ApplicantId = application.Primary_Applicant_Id__c;
            rq.Channel ='BRN';
            rq.TransactionBranch = application.Branch_Code__c;
            //string uniqueno = CreateUniqueId.uniqID();
            //string regex = '[a-zA-Z]{1,}|\\-';
            //String unique = uniqueno.replaceAll(regex, '');    
            String CollId = '';
            if(loanNo != null){
                CollId = loanNo + '1';  //For one collateral Id creation
            }else{
                CollId = application.Loan_Account_Number__c + '1';
            }    
            rq.CollateralID = CollId;//unique.subString(0,10);  //must be unique
            rq.CollateralCode ='107';           
            rq.BranchCode = application.Branch_Code__c; 
            rq.DocumentCode =''; 
            if(application.Sub_Stage__c!='Application Processed - Closed' && application.Sub_Type__c!=Constants.Sub_Type_Top_Up ){
                rq.FlgOperation ='A';           
            }
            else if(application.Sub_Type__c==Constants.Sub_Type_Top_Up){
                CollId = collList[0].CBS_Collateral_ID__c;
                rq.CollateralID = CollId;
                rq.FlgOperation ='M'; 
            }
            else {
                rq.FlgOperation ='M';     
            }
            if(application.Type_Of_Charge__c =='First Charge'){
                rq.TypeofCharge = '1';
            }else if(application.Type_Of_Charge__c =='Second Charge '){
                rq.TypeofCharge = '2';
            }else if(application.Type_Of_Charge__c =='Third Party Charge'){
                rq.TypeofCharge = '3';
            }else{
                rq.TypeofCharge = '';
            }
            if(application.Record_Type_Name__c  == Constants.VL2W || application.Record_Type_Name__c  == Constants.VL4W){
                rq.TypeofCharge = '1';
            }         
            rq.NameofLender = '';//'KVB';//application.Name_of_Lender__c;   
            
            //added by prashant singh on 22-11-2018....collateral structure changes----collList[0]
            rq.OriginalValue = collList[0].Total_Market_value__c != null ? String.ValueOf(collList[0].Total_Market_value__c) : '';  
            rq.LastValue = collList[0].Total_Market_value__c != null ? String.ValueOf(collList[0].Total_Market_value__c) : '';  
            rq.MarketValue = collList[0].Total_Market_value__c != null ? String.ValueOf(collList[0].Total_Market_value__c) : '';    
            rq.DatOrginalValuation = collList[0].Valuation_Date__c != null ? String.ValueOf(collList[0].Valuation_Date__c).replace('-','') : '';  //Change format MW
            rq.DatLastValuation = collList[0].Valuation_Date__c != null ? String.ValueOf(collList[0].Valuation_Date__c).replace('-','') : ''; 
            rq.DeedStatus = '';//application.Status_of_Deed__c; 
            rq.CustodianName = application.Name_of_Custodian__c;    
            //prashant singh ends here
            
            rq.DateDeedsSent = '';//String.ValueOf(application.Sale_Deed_Date__c).replace('-','') : ''; 
            rq.ExpectedReturnDate ='';  
            rq.DeedDetails ='deed';
            if(application.Record_Type_Name__c  == Constants.VL2W || application.Record_Type_Name__c  == Constants.VL4W){
                rq.OriginalValue = collList[0].Total_Vehicle_Value__c != null ? String.ValueOf(collList[0].Total_Vehicle_Value__c) : '';  
                rq.LastValue = collList[0].Total_Vehicle_Value__c != null ? String.ValueOf(collList[0].Total_Vehicle_Value__c) : '';  
                rq.MarketValue = collList[0].Total_Vehicle_Value__c != null ? String.ValueOf(collList[0].Total_Vehicle_Value__c) : '';    
                rq.DatOrginalValuation =application.Sanction_Date__c != null ? String.ValueOf(application.Sanction_Date__c).replace('-','') : ''; 
                rq.DatLastValuation = application.Sanction_Date__c != null ? String.ValueOf(application.Sanction_Date__c).replace('-','') : '';
                //rq.NameofLender = collList[0].Dealer_name__c != null ? String.ValueOf(collList[0].Dealer_name__c) : ''; //dealear name 
                rq.CustodianName = '';  
                rq.DeedDetails ='deed'; 
            } 
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
            rq.ChasisNumber ='';    
            rq.EngineNumber ='';    
            rq.RegistrationNumber ='';  
            rq.ModelNumber =''; 
            rq.YearofMfg ='';   
            rq.DescriptionAuto1 ='';
            rq.DescriptionAuto2 ='';
            if(application.Record_Type_Name__c  == Constants.VL2W || application.Record_Type_Name__c  == Constants.VL4W){
                rq.ChasisNumber =collList[0].Chassis_Number__c != null ? collList[0].Chassis_Number__c : '0';    
                rq.EngineNumber =collList[0].clcommon__Vehicle_Serial_Number__c != null ?collList[0].clcommon__Vehicle_Serial_Number__c :'0';    
                rq.RegistrationNumber =collList[0].RC_No__c != null ? collList[0].RC_No__c :'0';   
                rq.ModelNumber = String.ValueOf(collList[0].clcommon__Model__c); 
                String MonthsStr;
                if(collList[0].Month__c!=null && collList[0].Month__c.length() == 1){
                    MonthsStr = '0'+collList[0].Month__c;
                }else{
                    MonthsStr = collList[0].Month__c != null ? collList[0].Month__c : '';
                }
                
                rq.YearofMfg = String.ValueOf(collList[0].clcommon__Year__c)+MonthsStr;   
                rq.DescriptionAuto1 = String.ValueOf(collList[0].clcommon__Manufacturer__c); 
                rq.DescriptionAuto2 = String.ValueOf(collList[0].clcommon__Manufacturer__c);   
            }
            if(application.Record_Type_Name__c  == Constants.VL2W){
                rq.CollateralCode ='144'; 
            }
            if(application.Record_Type_Name__c  == Constants.VL4W){
                rq.CollateralCode ='119'; 
            }       
            rq.SecurityCode ='';    
            rq.NumberofUnits ='';   
            rq.SeriesNumber1 ='';   
            rq.SeriesNumber2 ='';   
            rq.Location = collList[0].Location_Of_The_Property__c; //added by prashant singh on 22-11-2018....collateral structure changes 
            rq.AreaUnit ='squrefit';   
            //Area_of_the_Land__c
            rq.TotalArea = string.valueOf(collList[0].Area_of_the_Land__c); //added by prashant singh on 22-11-2018....collateral structure changes
            rq.TypeofProperty ='0';//'Freehold' - 0;
            if(application.Record_Type_Name__c  == Constants.VL2W || application.Record_Type_Name__c  == Constants.VL4W){
                String locat = collList[0].clcommon__City__c != null ? collList[0].clcommon__City__c :'';  
                rq.Location =  locat + collList[0].State__c != null ? collList[0].State__c :''; 
                rq.AreaUnit ='meter';    
                rq.TotalArea = ''; 
                rq.TypeofProperty ='';//'Freehold' - 0;     
            }    
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
            cbsCol.in_msg.CollateralCreationDetails.add(rq);
        }
        else if(application.Record_Type_Name__c == Constants.LAPLOAN){
            if(collList.size() > 0){
                Integer i = 0;
                for(clcommon__Collateral__c col : collList){
                    Collateral_Creation_Helper_HL.cls_CollateralCreationDetails rq = new Collateral_Creation_Helper_HL.cls_CollateralCreationDetails();
                    rq.ApplicantId = application.Primary_Applicant_Id__c;  //doubt
                    rq.Channel ='BRN';
                    rq.TransactionBranch = application.Branch_Code__c;
                    //string uniqueno = CreateUniqueId.uniqID();
                    //string regex = '[a-zA-Z]{1,}|\\-';
                    //String unique = uniqueno.replaceAll(regex, '');    
                    String CollId = '';
                    i = i + 1;
                    if(loanNo != null){
                        CollId = loanNo + String.valueOf(i);  //For one collateral Id creation
                    }else{
                        CollId = application.Loan_Account_Number__c + String.valueOf(i);
                    }    
                    rq.CollateralID = CollId;//unique.subString(0,10);  //must be unique
                    rq.CollateralCode ='107';           
                    rq.BranchCode = application.Branch_Code__c; 
                    rq.DocumentCode ='';    
                    rq.FlgOperation ='A';                               
                    rq.TypeofCharge = '1'; //First Charge                           
                    rq.NameofLender = '';//'KVB';//application.Name_of_Lender__c;   
                    rq.OriginalValue = col.Collateral_Market_Value__c != null ? String.ValueOf(col.Collateral_Market_Value__c) : '';    
                    rq.LastValue = col.Collateral_Market_Value__c != null ? String.ValueOf(col.Collateral_Market_Value__c) : '';    
                    rq.MarketValue = col.Collateral_Market_Value__c != null ? String.ValueOf(col.Collateral_Market_Value__c) : '';  
                    rq.DatOrginalValuation = col.Valuation_Date__c != null ? String.ValueOf(col.Valuation_Date__c).replace('-','') : '';    //Change format MW
                    rq.DatLastValuation = col.Valuation_Date__c != null ? String.ValueOf(col.Valuation_Date__c).replace('-','') : '';
                    //rq.DeedStatus = application.Status_of_Deed__c;
                    rq.DeedStatus = '';  
                    rq.CustodianName = application.Name_of_Custodian__c;    
                    rq.DateDeedsSent = '';//String.ValueOf(application.Sale_Deed_Date__c).replace('-','') : ''; 
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
                    rq.ChasisNumber ='';    
                    rq.EngineNumber ='';    
                    rq.RegistrationNumber ='';  
                    rq.ModelNumber =''; 
                    rq.YearofMfg ='';   
                    rq.DescriptionAuto1 ='';    
                    rq.DescriptionAuto2 ='';    
                    rq.SecurityCode ='';    
                    rq.NumberofUnits ='';   
                    rq.SeriesNumber1 ='';   
                    rq.SeriesNumber2 ='';   
                    rq.Location = col.clcommon__City__c;    
                    rq.AreaUnit ='squrefit';    
                    rq.TotalArea = col.Vacant_Land_area__c != null ? String.ValueOf(col.Vacant_Land_area__c) : '0'; 
                    rq.TypeofProperty ='0';//'Freehold' - 0;    
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
                    rq.ExtUniqueRefId = string.valueOf(i);  //make it qnique
                    /*if(application.genesis__CL_Product_Name__c!=null){
                        if(application.genesis__CL_Product_Name__c.contains('Co-Lending')){
                            rq.NameofLender = application.Sourced_By__c;
                        }
                    }*/
                    cbsCol.in_msg.CollateralCreationDetails.add(rq);     
                }
            }
        }
        getCollateral(JSON.serialize(cbs),application,accMap,loanNo,UpcbsLog);
    }
    public static void getCollateral(String collateralData, genesis__Applications__c application,Map<string,string>accMap,String loanNo,List<CBS_API_Log__c> UpcbsLog){
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
                if(accMap != null){
                    if(accMap.size()>0){
                        for(String str : accMap.keySet()){
                            if(str.length()>=15){
                                account acc = new account();
                                acc.Id = str;
                                acc.CBS_Customer_ID__c = accMap.get(str);
                                accountList.add(acc);
                            }
                        }
                        if(accountList.size()>0){
                            update accountList;                
                        }
                    }
                }
                if(loanNo != null && application.id !=null){
                    genesis__Applications__c a= new genesis__Applications__c();
                    a.Id = application.id;
                    a.Loan_Account_Number__c = loanNo;
                    // genesis__Applications__c application = new genesis__Applications__c();
                    // application = queryService.getApp(application.id);
                    // a.Interest_Variation__c = WS_CBS_Loan_Creation_HL.VariationHL(application);
                    update a;
                }            
                if(res.out_msg.Status_Desc != 'Success'){
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = application.id;
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.Status_Desc;
                    if(application.Sub_Type__c==Constants.Sub_Type_Top_Up){
                        log.API_Name__c = 'Loan_Collateral_Modification_HL';
                        log.Sequence_No__c = '6.2';
                    }
                    else{
                        log.API_Name__c = 'Loan_Collateral_Creation_HL';
                        log.Sequence_No__c = '6';
                    }
                    
                    UpcbsLog.add(log);
                    system.debug('UpcbsLog6-->'+UpcbsLog);
                    //insert UpcbsLog; //CBS_001 
                }
                insert UpcbsLog; //   CBS_001
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = application.id;
                log.Status__c = 'Failure';
                if(application.Sub_Type__c==Constants.Sub_Type_Top_Up){
                    log.API_Name__c = 'Loan_Collateral_Modification_HL';
                    log.Sequence_No__c = '6.2';
                    log.Success_Error_Message__c = 'CollateralModification_CBS_Error_No_Hit';
                }
                else{
                    log.API_Name__c = 'Loan_Collateral_Creation_HL';
                    log.Sequence_No__c = '6';
                    log.Success_Error_Message__c = 'CollateralCreation_CBS_Error_No_Hit';
                }
                log.Success_Error_Message__c = 'CollateralCreation_CBS_Error_No_Hit';
                UpcbsLog.add(log);
                system.debug('UpcbsLog6-->'+UpcbsLog);
                insert UpcbsLog; //CBS_001  
            }
        }catch(exception e){
            HandleBusinessException.captureError('WS_CBS_Collateral_CreationHL','getCollateral', e);
            CBS_API_Log__c log = new CBS_API_Log__c();    
            log.Application__c = application.id;
            if(application.Sub_Type__c==Constants.Sub_Type_Top_Up){
                log.API_Name__c = 'Loan_Collateral_Modification_HL';
                log.Sequence_No__c = '6.2';
            }
            else{
                log.API_Name__c = 'Loan_Collateral_Creation_HL';
                log.Sequence_No__c = '6';
            }
            log.Status__c = 'Failure';
            log.Success_Error_Message__c = 'Exception '+e.getMessage();
            UpcbsLog.add(log);
            insert UpcbsLog; //CBS_001
        }
    }
}