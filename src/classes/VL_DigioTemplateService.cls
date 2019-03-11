/*
* Name    : VL_DigioTemplateService
* Company : ET Marlabs
* Purpose : This class will be used for pulling data for document generation of vehicle loan
* Author  : Braj
*/
public with sharing class VL_DigioTemplateService {
    
    //----------------------------------------------Sanction letter document generation-Start Here-------------------
    
    public static PL_Approve_Sanction_DigioDocreq getVLSanctionLetter(String appId,String templateId){
        try {
            genesis__Applications__c appln = new genesis__Applications__c();
            
            //get application
            //@param application id
            appln = getApplication(appId);
            
            PL_Approve_Sanction_DigioDocreq PreApp=new PL_Approve_Sanction_DigioDocreq();
            
            PreApp.inputVariables   = new PL_Approve_Sanction_DigioDocreq.cls_inputVariables();
            PreApp.owner_tenantId   = 'cuecent_tenant';
            PreApp.exe_tenantId = 'cuecent_tenant';
            PreApp.serviceName      = 'TestJsonStr';
            PreApp.inputVariables.unique_key    = templateId;
            PreApp.inputVariables.pdf_unique_key = appln.Id;
            PreApp.inputVariables.in_msg        = '';
            PreApp.inputVariables.inputmap  = new PL_Approve_Sanction_DigioDocreq.cls_inputmap();
            
            PreApp.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            PreApp.inputVariables.inputmap.Loc_Ref_Branch=Utility.getBlankStringIfNull(appln.Branch_Name__c);
            PreApp.inputVariables.inputmap.Branch_code=Utility.getBlankStringIfNull(appln.Branch_Code__c);
            PreApp.inputVariables.inputmap.Application_date=Utility.getBlankStringIfNull(String.ValueOf(appln.Created_Date__c));
            PreApp.inputVariables.inputmap.Application_number=Utility.getBlankStringIfNull(appln.Name);
            PreApp.inputVariables.inputmap.Financial_Yr=Utility.getBlankStringIfNull(String.ValueOf(system.today().Year()));
            PreApp.inputVariables.inputmap.sanction_date=Utility.getBlankStringIfNull(String.ValueOf(system.today()));
            PreApp.inputVariables.inputmap.Loan_product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
            PreApp.inputVariables.inputmap.Ap_LT=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c)); 
            PreApp.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
            if(appln.genesis__Interest_Rate__c==null){
                appln.genesis__Interest_Rate__c=0;
            }
            PreApp.inputVariables.inputmap.Int_ROI=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c.setScale(2))) +'%';
            PreApp.inputVariables.inputmap.Interest_Type_Rate = 'Fixed interest rate of '+Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c.setScale(2)))+'%';

            PreApp.inputVariables.inputmap.Processing_charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Processing_Fee__c));
            PreApp.inputVariables.inputmap.Borrower1_Name1=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
            PreApp.inputVariables.inputmap.Borrower1_Add_line1=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherStreet) ;
            PreApp.inputVariables.inputmap.Borrower1_Add_line2=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherCity) ;
            PreApp.inputVariables.inputmap.Borrower1_Add_line3=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherState) +'  '+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherPostalCode);
            PreApp.inputVariables.inputmap.Borrower1_Names=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
            PreApp.inputVariables.inputmap.Conditions_LOS= Utility.getBlankStringIfNull(appln.Conditions_By_Sanction_Authority__c);
            PreApp.inputVariables.inputmap.Borrower1_Pan= Utility.getBlankStringIfNull(appln.genesis__Account__r.Pan_Number__c);
            if(appln.Penal_Interest__c==null){
                appln.Penal_Interest__c=0;
            }
            PreApp.inputVariables.inputmap.Penal_Interest=Utility.getBlankStringIfNull(String.ValueOf(appln.Penal_Interest__c.setScale(2)));
            PreApp.inputVariables.inputmap.Borrower1_Email=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonEmail);
            if(appln.Preclosure_Charges__c==null){
                appln.Preclosure_Charges__c=0;
            } 
            PreApp.inputVariables.inputmap.PreClosure_Charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Preclosure_Charges__c.setScale(2)));
            if(appln.Sanctioned_EMI__c==null){
                appln.Sanctioned_EMI__c=0;
            }
            PreApp.inputVariables.inputmap.EMI_amount=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_EMI__c.setScale(2)));
            PreApp.inputVariables.inputmap.Borrower1_Phone=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMobilePhone);
            if(appln.Non_Refundable_Charges__c==null){
                appln.Non_Refundable_Charges__c=0;
            }
            PreApp.inputVariables.inputmap.Non_refundable_charges= Utility.getBlankStringIfNull(String.ValueOf(appln.Non_Refundable_Charges__c.setScale(2))) ;
            
            //Additional tags for VL
            PreApp.inputVariables.inputmap.DD_FI= Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Expected_First_Payment_Date__c));
            if(appln.Record_Type_Name__c == Constants.VL2W) {
                PreApp.inputVariables.inputmap.Interest_charge= Utility.getBlankStringIfNull(Constants.Interest_charge_2W);
                PreApp.inputVariables.inputmap.Vehicle_Type = Utility.getBlankStringIfNull(Constants.VL2W_Name);
                  //PreApp.inputVariables.inputmap.Interest_Type_Rate=Constants.Fixed;            
            
            } else if(appln.Record_Type_Name__c == Constants.VL4W){
                PreApp.inputVariables.inputmap.Interest_charge= Utility.getBlankStringIfNull(Constants.Interest_charge_4W);
                PreApp.inputVariables.inputmap.Vehicle_Type = Utility.getBlankStringIfNull(Constants.VL4W_Name);
                //PreApp.inputVariables.inputmap.Interest_Type_Rate=Constants.FloatRate; 
            }
            PreApp.inputVariables.inputmap.Int_Type = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Calculation_Method__c));
            String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
            PreApp.inputVariables.inputmap.Ap_LT_inwords = AmtINWrd.replace('Rupess Only','');
            PreApp.inputVariables.inputmap.MCLR_Rate = ' Not Applicable ';//Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Rate__c));
            PreApp.inputVariables.inputmap.Borrower_Details=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c)+' S/W/D of '+Utility.getBlankStringIfNull(appln.genesis__Account__r.Father_Name__pc)+' aged about '+Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Account__r.Age__c))+' residing at '+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherStreet)+','+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherCity)+','+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherState) +'-'+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherPostalCode);
            
            String TempAaadhar = appln.genesis__Account__r.Aadhaar_Number__pc!=null?appln.genesis__Account__r.Aadhaar_Number__pc:'';
            TempAaadhar=WS_getAadharNo.getAadharNo(TempAaadhar);
            PreApp.inputVariables.inputmap.Borrower1_Aadhaar = Utility.getBlankStringIfNull(TempAaadhar);
            
            PreApp.inputVariables.inputmap.Security_any = '';
            PreApp.inputVariables.inputmap.Collateral_Sec = '';
            PreApp.inputVariables.inputmap.Borrower1_eSign = '';
            //PreApp.inputVariables.inputmap.MCLR_Refresh = Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Type__c));//commnetd on date:11-sep-18
            PreApp.inputVariables.inputmap.MCLR_Refresh = '';
            
            //borrower2-start//added for vehicle loan
            if(appln.genesis__Application_Parties__r.size() > 0) {
                PreApp.inputVariables.inputmap.Borrower2_Name1=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Full_Name__c);
                PreApp.inputVariables.inputmap.Borrower2_Add_line1=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.PersonOtherStreet) ;
                PreApp.inputVariables.inputmap.Borrower2_Add_line2=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.PersonOtherCity) ;
                PreApp.inputVariables.inputmap.Borrower2_Add_line3=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.PersonOtherState) +'  '+Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.PersonOtherPostalCode);
                PreApp.inputVariables.inputmap.Guarantor_any=string.valueOf(appln.genesis__Application_Parties__r[0].Guarantor__c);
                PreApp.inputVariables.inputmap.Borrower2_Email=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.PersonEmail);
                PreApp.inputVariables.inputmap.Borrower2_Phone=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.PersonMobilePhone);
                String TemAaadhar = appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Aadhaar_Number__pc!=null?appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Aadhaar_Number__pc:'';
                TemAaadhar=WS_getAadharNo.getAadharNo(TemAaadhar);
                PreApp.inputVariables.inputmap.Borrower2_Aadhaar=Utility.getBlankStringIfNull(TemAaadhar);
                PreApp.inputVariables.inputmap.Borrower2_Names=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Full_Name__c);
                PreApp.inputVariables.inputmap.Borrower2_eSign = '';
                PreApp.inputVariables.inputmap.Borrower2_Pan = Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Pan_Number__c));
            }
            //borrower2-end
            
            if(appln.genesis__Collaterals__r.size() > 0) {
                PreApp.inputVariables.inputmap.Dealer_Name = Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Dealer_name__c);
                PreApp.inputVariables.inputmap.Proforma_No= Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Proforma_Invoice_No__c));
                PreApp.inputVariables.inputmap.DD_PI= Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Proforma_Invoice_Date__c));
                PreApp.inputVariables.inputmap.Primary_Sec = 'Hypothecation of brand new '+appln.genesis__Collaterals__r[0].clcommon__Manufacturer__c+' '+appln.genesis__Collaterals__r[0].clcommon__Model__c+' '+appln.genesis__Collaterals__r[0].Variant__c+' vehicle to be financed by Karur Vysya Bank';
                PreApp.inputVariables.inputmap.V_Amt=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Total_Vehicle_Value__c));
                Decimal MarignPercent = 0.00;
                if(appln.genesis__Collaterals__r[0].Total_Vehicle_Value__c != null && appln.genesis__Collaterals__r[0].Total_Vehicle_Value__c != 0 && appln.genesis__Collaterals__r[0].Advances_Paid__c != null)
                   MarignPercent = (appln.genesis__Collaterals__r[0].Advances_Paid__c/appln.genesis__Collaterals__r[0].Total_Vehicle_Value__c)*100;
                
                PreApp.inputVariables.inputmap.Margin = Utility.getBlankStringIfNull(String.ValueOf(MarignPercent.setScale(2)))+'%';
            }
            
            system.debug('##### Sanction Document request structrue ');
            return PreApp;
        } catch(Exception e) {
            System.debug('##VLSanctionLetter### --- > '+ e.getLineNumber() +' ' +e.getCause());
            HandleBusinessException.captureError('VL_DigioTemplateService', 'getVLSanctionLetter', e);
            return null;
        }
        
    }
    //----------------------------------------------Sanction letter document generation-END Here-------------------
    
    //----------------------------------------------Hypothecation Document generation-Start Here---------------------
    public static PL_Approve_Sanction_DigioDocreq VL_HypothecationDoc(String appId,String templateId){
        try {
            genesis__Applications__c appln = new genesis__Applications__c();
            
            //get application
            //@param application id
            appln = getApplication(appId);
            String borrowerName;
            PL_Approve_Sanction_DigioDocreq PreApp=new PL_Approve_Sanction_DigioDocreq();
            
            PreApp.inputVariables   = new PL_Approve_Sanction_DigioDocreq.cls_inputVariables();
            PreApp.owner_tenantId   = 'cuecent_tenant';
            PreApp.exe_tenantId = 'cuecent_tenant';
            PreApp.serviceName      = 'TestJsonStr';
            PreApp.inputVariables.unique_key    = templateId;
            PreApp.inputVariables.pdf_unique_key = appln.Id;
            PreApp.inputVariables.in_msg        = '';
            PreApp.inputVariables.inputmap  = new PL_Approve_Sanction_DigioDocreq.cls_inputmap();
            
            PreApp.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            PreApp.inputVariables.inputmap.Loc_Ref_Branch=Utility.getBlankStringIfNull(appln.Branch_Name__c);
            PreApp.inputVariables.inputmap.Branch_code=Utility.getBlankStringIfNull(appln.Branch_Code__c);
            PreApp.inputVariables.inputmap.Application_date=Utility.getBlankStringIfNull(String.ValueOf(appln.Created_Date__c));
            PreApp.inputVariables.inputmap.Application_number=Utility.getBlankStringIfNull(appln.Name);
            PreApp.inputVariables.inputmap.Financial_Yr=Utility.getBlankStringIfNull(String.ValueOf(system.today().Year()));
            PreApp.inputVariables.inputmap.sanction_date=Utility.getBlankStringIfNull(String.ValueOf(system.today()));
            PreApp.inputVariables.inputmap.Loan_product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
            PreApp.inputVariables.inputmap.Ap_LT=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c)); 
            PreApp.inputVariables.inputmap.Loan_tenor=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_Tenure__c));
            
            PreApp.inputVariables.inputmap.Processing_charges='Rs. '+ Utility.getBlankStringIfNull(String.ValueOf(appln.Processing_Fee__c));
            PreApp.inputVariables.inputmap.Borrower_Details=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c)+' S/W/D of '+Utility.getBlankStringIfNull(appln.genesis__Account__r.Father_Name__pc)+' aged about '+Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Account__r.Age__c))+' residing at '+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherStreet)+','+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherCity)+','+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherState) +'-'+Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonOtherPostalCode);
            if(appln.Penal_Interest__c==null){
                appln.Penal_Interest__c=0;
            }
            PreApp.inputVariables.inputmap.Penal_Interest=Utility.getBlankStringIfNull(String.ValueOf((appln.Penal_Interest__c.setScale(2))));
            PreApp.inputVariables.inputmap.Borrower1_Names=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
            if(appln.Preclosure_Charges__c==null){
                appln.Preclosure_Charges__c=0;
            }
            PreApp.inputVariables.inputmap.PreClosure_Charges=Utility.getBlankStringIfNull(String.ValueOf(appln.Preclosure_Charges__c.setScale(2)));
            PreApp.inputVariables.inputmap.Borrower1_Phone=Utility.getBlankStringIfNull(appln.genesis__Account__r.PersonMobilePhone);
            
            //Additional tags for Hypothecation Document
            if( appln.FPIPrincRepayInstal__c != null && appln.Sanctioned_Tenure__c != null){
                PreApp.inputVariables.inputmap.DD_FI=Utility.getBlankStringIfNull(String.ValueOf(appln.FPIPrincRepayInstal__c));
                PreApp.inputVariables.inputmap.DD_LI=Utility.getBlankStringIfNull(String.ValueOf((appln.FPIPrincRepayInstal__c).addMonths(integer.valueOf(appln.Sanctioned_Tenure__c-1) )));
            }

            if(appln.Record_Type_Name__c == Constants.VL2W) {
                PreApp.inputVariables.inputmap.Vehicle_Type = Utility.getBlankStringIfNull(Constants.VL2W_Name);
                //PreApp.inputVariables.inputmap.Interest_Type_Rate=Constants.Fixed;//commented on date:11-sep-18
            } else if(appln.Record_Type_Name__c == Constants.VL4W){
                PreApp.inputVariables.inputmap.Vehicle_Type = Utility.getBlankStringIfNull(Constants.VL4W_Name);
                //PreApp.inputVariables.inputmap.Interest_Type_Rate=Constants.FloatRate;//commented on date:11-sep-18
            }
           // system.debug('appln.genesis__Collaterals__r[0].Final_vehicle_value__c:---'+appln.genesis__Collaterals__r[0].Final_vehicle_value__c);
            if(appln.genesis__Collaterals__r.size()>0)  PreApp.inputVariables.inputmap.V_Amt=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Total_Vehicle_Value__c));
            else PreApp.inputVariables.inputmap.V_Amt='';
            String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
            PreApp.inputVariables.inputmap.Ap_LT_inwords = AmtINWrd.replace('Rupess Only','');
            
            //PreApp.inputVariables.inputmap.MCLR_Refresh = Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Type__c));//commnetd on date:11-sep-18
            PreApp.inputVariables.inputmap.MCLR_Refresh = '';

            PreApp.inputVariables.inputmap.Disb_Ref_Day = System.now().format('dd');
            PreApp.inputVariables.inputmap.Disb_Ref_Month = System.now().format('MMMM')+' month';
            PreApp.inputVariables.inputmap.Disb_Ref_Year = System.now().format('yyyy')+' in year';
             borrowerName=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c)+', ';
            if(appln.genesis__Collaterals__r.size() > 0) {
                PreApp.inputVariables.inputmap.Dealer_Name = Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Dealer_name__c);
                PreApp.inputVariables.inputmap.DD_PI= Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Proforma_Invoice_Date__c));
                String vehdetails=appln.genesis__Collaterals__r[0].clcommon__Manufacturer__c+' '+appln.genesis__Collaterals__r[0].clcommon__Model__c+' '+appln.genesis__Collaterals__r[0].Variant__c;
                PreApp.inputVariables.inputmap.Vehicle_Details=Utility.getBlankStringIfNull(vehdetails);
                PreApp.inputVariables.inputmap.Manufacture_Year=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].clcommon__Year__c);
                PreApp.inputVariables.inputmap.Proforma_No= Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Proforma_Invoice_No__c));
            }
            
            //borrower2-start//added for vehicle loan
            if(appln.genesis__Application_Parties__r.size() > 0) {
                borrowerName=borrowerName+Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Full_Name__c);
                PreApp.inputVariables.inputmap.Borrower2_Name1=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Full_Name__c);
                PreApp.inputVariables.inputmap.Borrower2_Names=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Full_Name__c);
            }
            //borrower2-end

            PreApp.inputVariables.inputmap.Borrower_Names=borrowerName; 
            PreApp.inputVariables.inputmap.CC_Details='';
            if(appln.Sanctioned_EMI__c==null){
                appln.Sanctioned_EMI__c=0;
            }
            PreApp.inputVariables.inputmap.EMI_amount=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanctioned_EMI__c.setScale(2)));  
            PreApp.inputVariables.inputmap.Class_2_Signature='';
            if(appln.genesis__Interest_Rate__c==null){
                appln.genesis__Interest_Rate__c=0;
            }
            PreApp.inputVariables.inputmap.Interest_Type_Rate= 'Fixed interest rate of '+Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Interest_Rate__c.setScale(2)))+'%'; 

            System.debug('##### Hypothecation document request structrue ' +PreApp);
            return PreApp;
        } catch(Exception e) {
            System.debug('##Hypothecation### --- > '+ e.getLineNumber() +' ' +e.getCause()+'   message:--'+e.getMessage()+'  trace:--'+e.getStackTraceString());
            HandleBusinessException.captureError('VL_DigioTemplateService', 'VL_HypothecationDoc', e);
            return null;
        }
    }
    //----------------------------------------------Hypothecation Document generation-End Here---------------------
    
    public static PL_Approve_Sanction_DigioDocreq VlDealerPaymentLetter(String appId,String templateId){
        try {
            genesis__Applications__c appln = new genesis__Applications__c();
            appln = getApplication(appId);
            String prodtype;
            if(appln.Record_Type_Name__c==Constants.VL4W){
                prodtype='Four-wheeler';
            }
            else{
                prodtype='Two-wheeler';
            }
            PL_Approve_Sanction_DigioDocreq PreApp=new PL_Approve_Sanction_DigioDocreq();
            
            
            PreApp.inputVariables   = new PL_Approve_Sanction_DigioDocreq.cls_inputVariables();
            PreApp.owner_tenantId   = 'cuecent_tenant';
            PreApp.exe_tenantId = 'cuecent_tenant';
            PreApp.serviceName      = 'TestJsonStr';
            PreApp.inputVariables.unique_key    = templateId;
            PreApp.inputVariables.pdf_unique_key = appln.Id;
            PreApp.inputVariables.in_msg        = '';
            PreApp.inputVariables.inputmap  = new PL_Approve_Sanction_DigioDocreq.cls_inputmap();
            
            PreApp.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ;
            PreApp.inputVariables.inputmap.Loc_Ref_Branch=Utility.getBlankStringIfNull(appln.Branch_Name__c);
            PreApp.inputVariables.inputmap.sanction_date=Utility.getBlankStringIfNull(String.ValueOf(system.today()));
            PreApp.inputVariables.inputmap.Loan_product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
            PreApp.inputVariables.inputmap.Ap_LT=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c)); 
            PreApp.inputVariables.inputmap.Application_number=Utility.getBlankStringIfNull(appln.Name);
            String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c)); 
            PreApp.inputVariables.inputmap.Ap_LT_inwords= AmtINWrd.replace('Rupess Only','');
            PreApp.inputVariables.inputmap.Borrower1_Name1=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
            PreApp.inputVariables.inputmap.Borrower1_Names=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c);
            PreApp.inputVariables.inputmap.Vehicle_Type=Utility.getBlankStringIfNull(prodtype);
            ///vehicle-collateral field
            if((appln.genesis__Collaterals__r).size() > 0) {
                PreApp.inputVariables.inputmap.Dealer_Name=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Dealer_name__c);
                PreApp.inputVariables.inputmap.Dealer_Add=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].clcommon__Address__c);
                String vehdetails=appln.genesis__Collaterals__r[0].clcommon__Manufacturer__c+' '+appln.genesis__Collaterals__r[0].clcommon__Model__c+' '+appln.genesis__Collaterals__r[0].Variant__c;
                PreApp.inputVariables.inputmap.Vehicle_Details=Utility.getBlankStringIfNull(vehdetails);
            }
            //end col
            //borrower2-start//added for vehicle loan
            if(appln.genesis__Application_Parties__r.size() > 0) {
                PreApp.inputVariables.inputmap.Borrower2_Name1=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Full_Name__c);
                PreApp.inputVariables.inputmap.Borrower2_Names=Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Full_Name__c);
            }
            //borrower2-end
            
            //end veh
            System.debug('##### VlDealerPaymentLetter request structrue ');
            return PreApp;
        } catch(Exception e) {
            System.debug('##VlDealerPaymentLetter### --- > '+ e.getLineNumber() +' ' +e.getCause());
            HandleBusinessException.captureError('VL_DigioTemplateService', 'VlDealerPaymentLetter', e);
            return null;
        }
        
        
    }
   public static PL_Approve_Sanction_DigioDocreq VlPaymentAcknowledgementLetter(String appId,String templateId){
        try{
            genesis__Applications__c appln = new genesis__Applications__c();
            appln = getApplication(appId);
            String prodtype;
            String borrowerName;
            String AmtINWrd;
            if(appln.Record_Type_Name__c==Constants.VL4W){
                prodtype=Constants.VL4W_Name;
            }
            else{
                prodtype=Constants.VL2W_Name;
            }
            
            PL_Approve_Sanction_DigioDocreq PreApp=new PL_Approve_Sanction_DigioDocreq();
            
            PreApp.inputVariables   = new PL_Approve_Sanction_DigioDocreq.cls_inputVariables();
            PreApp.owner_tenantId   = 'cuecent_tenant';
            PreApp.exe_tenantId = 'cuecent_tenant';
            PreApp.serviceName      = 'TestJsonStr';
            PreApp.inputVariables.unique_key    = templateId;
            PreApp.inputVariables.pdf_unique_key = appln.Id;
            PreApp.inputVariables.in_msg        = '';
            PreApp.inputVariables.inputmap  = new PL_Approve_Sanction_DigioDocreq.cls_inputmap();
            
            PreApp.inputVariables.inputmap.Auth_Sign_Bnk= Constants.KvbBank ; 
            PreApp.inputVariables.inputmap.Loc_Ref_Branch=Utility.getBlankStringIfNull(appln.Branch_Name__c);
            PreApp.inputVariables.inputmap.sanction_date=Utility.getBlankStringIfNull(String.ValueOf(system.today()));
            PreApp.inputVariables.inputmap.Loan_product=Utility.getBlankStringIfNull(appln.genesis__CL_Product_Name__c);
         // PreApp.inputVariables.inputmap.Ap_LT=Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Authority_Limit__c)); 
           // String AmtINWrd = Utility.getBlankStringIfNull(String.ValueOf(appln.Sanction_Amount_Words__c));
          //  PreApp.inputVariables.inputmap.Ap_LT_inwords=AmtINWrd.replace('Rupess Only','');
            borrowerName=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c)+', ';
            PreApp.inputVariables.inputmap.Vehicle_Type=Utility.getBlankStringIfNull(prodtype); 
            //PreApp.inputVariables.inputmap.MCLR_Refresh=Utility.getBlankStringIfNull(String.ValueOf(appln.MCLR_Type__c));//commnetd on date:11-sep-18
            PreApp.inputVariables.inputmap.MCLR_Refresh = ''; 
            NumberToWordConversion ntw = new NumberToWordConversion();
            ///vehicle-collateral field MCLR_Type__c
            if((appln.genesis__Collaterals__r).size() > 0) {
                PreApp.inputVariables.inputmap.Dealer_Name=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Dealer_name__c);
                PreApp.inputVariables.inputmap.Dealer_Add=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].clcommon__Address__c);
                String vehdetails=appln.genesis__Collaterals__r[0].clcommon__Manufacturer__c+' '+appln.genesis__Collaterals__r[0].clcommon__Model__c+' '+appln.genesis__Collaterals__r[0].Variant__c;
                PreApp.inputVariables.inputmap.Vehicle_Details=Utility.getBlankStringIfNull(vehdetails);
                PreApp.inputVariables.inputmap.V_Amt=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Total_Vehicle_Value__c));
                PreApp.inputVariables.inputmap.Margin_Amt=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Advances_Paid__c));
                PreApp.inputVariables.inputmap.DD_No=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].DD_No__c));
                PreApp.inputVariables.inputmap.DD_date=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].DD_Date__c));
                PreApp.inputVariables.inputmap.Ap_LT=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].DD_Amount__c));
                AmtINWrd= ntw.getNumberTOWordConvertion(Decimal.valueOf(appln.genesis__Collaterals__r[0].DD_Amount__c));
         
            }
            PreApp.inputVariables.inputmap.Ap_LT_inwords=AmtINWrd.replace('Rupess Only','');
            //end col
            //borrower2-start//added for vehicle loan
            if(appln.genesis__Application_Parties__r.size() > 0) {
                borrowerName=borrowerName+Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Full_Name__c);
                
            }
            PreApp.inputVariables.inputmap.Borrower_Names=borrowerName;              
            //borrower2-end
            
            /////end veh
            system.debug('##### VlPaymentAcknowledgementLetter request structrue PreApp -- '+PreApp);
            return PreApp;
        } catch(Exception e) {
            System.debug('##VlPaymentAcknowledgementLetter### --- > '+ e.getLineNumber() +' ' +e.getCause());
            HandleBusinessException.captureError('VL_DigioTemplateService', 'VlPaymentAcknowledgementLetter', e);
            return null;
        }
    }
   // vl covering letter
    public static PL_Approve_Sanction_DigioDocreq VlCoveringLetter(String appId,String templateId){  
       try{
            genesis__Applications__c appln = new genesis__Applications__c();
            appln = getApplication(appId);
            String prodtype;
            String borrowerName;
            String AmtINWrd;
            if(appln.Record_Type_Name__c==Constants.VL4W){
                prodtype=Constants.VL4W_Name;
            }
            else{
                prodtype=Constants.VL2W_Name;
            }
            
            PL_Approve_Sanction_DigioDocreq PreApp=new PL_Approve_Sanction_DigioDocreq();
            
            PreApp.inputVariables   = new PL_Approve_Sanction_DigioDocreq.cls_inputVariables();
            PreApp.owner_tenantId   = 'cuecent_tenant';
            PreApp.exe_tenantId = 'cuecent_tenant';
            PreApp.serviceName      = 'TestJsonStr';
            PreApp.inputVariables.unique_key    = templateId;
            PreApp.inputVariables.pdf_unique_key = appln.Id;
            PreApp.inputVariables.in_msg        = '';
            PreApp.inputVariables.inputmap  = new PL_Approve_Sanction_DigioDocreq.cls_inputmap();
            
         
            PreApp.inputVariables.inputmap.Loc_Ref_Branch=Utility.getBlankStringIfNull(appln.Branch_Name__c);
            PreApp.inputVariables.inputmap.sanction_date=Utility.getBlankStringIfNull(String.ValueOf(system.today()));
            borrowerName=Utility.getBlankStringIfNull(appln.genesis__Account__r.Full_Name__c)+', ';
            PreApp.inputVariables.inputmap.Vehicle_Type=Utility.getBlankStringIfNull(prodtype); 
            PreApp.inputVariables.inputmap.Financial_Yr=Utility.getBlankStringIfNull(String.ValueOf(system.today().Year()));
            PreApp.inputVariables.inputmap.Application_number=Utility.getBlankStringIfNull(appln.Name);
            PreApp.inputVariables.inputmap.Branch_code=Utility.getBlankStringIfNull(appln.Branch_Code__c);
            
            NumberToWordConversion ntw = new NumberToWordConversion();
            ///vehicle-collateral field MCLR_Type__c
            if((appln.genesis__Collaterals__r).size() > 0) {
                PreApp.inputVariables.inputmap.Dealer_Name=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].Dealer_name__c);
                PreApp.inputVariables.inputmap.Dealer_Add=Utility.getBlankStringIfNull(appln.genesis__Collaterals__r[0].clcommon__Address__c);
                String vehdetails=appln.genesis__Collaterals__r[0].clcommon__Manufacturer__c+' '+appln.genesis__Collaterals__r[0].clcommon__Model__c+' '+appln.genesis__Collaterals__r[0].Variant__c;
                PreApp.inputVariables.inputmap.Vehicle_Details=Utility.getBlankStringIfNull(vehdetails);
                PreApp.inputVariables.inputmap.DD_No=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].DD_No__c));
                PreApp.inputVariables.inputmap.DD_date=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].DD_Date__c));
                PreApp.inputVariables.inputmap.DD_amount=Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].DD_Amount__c));
                PreApp.inputVariables.inputmap.Proforma_No= Utility.getBlankStringIfNull(String.ValueOf(appln.genesis__Collaterals__r[0].Proforma_Invoice_No__c));
               
                AmtINWrd= ntw.getNumberTOWordConvertion(Decimal.valueOf(appln.genesis__Collaterals__r[0].DD_Amount__c));
         
            }
            PreApp.inputVariables.inputmap.Ap_LT_inwords=AmtINWrd.replace('Rupess Only','');
            //end col
            //borrower2-start//added for vehicle loan
            if(appln.genesis__Application_Parties__r.size() > 0) {
                borrowerName=borrowerName+Utility.getBlankStringIfNull(appln.genesis__Application_Parties__r[0].genesis__Party_Account_Name__r.Full_Name__c);
                
            }
            PreApp.inputVariables.inputmap.Borrower_Names=borrowerName;              
            //borrower2-end
            
            /////end veh
            system.debug('##### VlCoveringLetter request structrue PreApp -- '+PreApp);
            return PreApp;
        } catch(Exception e) {
            System.debug('##VlCoveringLetter### --- > '+ e.getLineNumber() +' ' +e.getCause());
            HandleBusinessException.captureError('VL_DigioTemplateService', 'VlCoveringLetter', e);
            return null;
        }  
    }
    //end vl covering letter
    
    public static genesis__Applications__c getApplication(String appId){
        try {
            genesis__Applications__c loanApplication = new genesis__Applications__c();
            loanApplication = [Select id,genesis__Account__c,genesis__Payment_Amount__c,genesis__Account__r.Aadhaar_Number__pc,Conditions_By_Sanction_Authority__c,genesis__Account__r.Pan_Number__c,Penal_Interest__c,genesis__Account__r.PersonEmail,Preclosure_Charges__c,Non_Refundable_Charges__c,genesis__Account__r.PersonMobilePhone,genesis__Account__r.Name,Branch_Name__c,genesis__Loan_Amount__c,
                               Branch_Code__c,Sanction_Amount_Words__c,Created_Date__c,Name,genesis__Account__r.BillingStreet,Sanction_Financial_Year__c,Sanction_Date__c,Amount_in_Words_And_Figures__c,
                               genesis__Account__r.BillingCity,genesis__Account__r.BillingState,genesis__Account__r.BillingCountry,genesis__CL_Product_Name__c,genesis__Term__c,
                               genesis__Interest_Rate__c,MCLR_Type__c,genesis__Interest_Calculation_Method__c,Sanctioned_EMI__c,Sanctioned_Tenure__c,Sanction_Authority_Limit__c,Processing_Fee__c,Today_Date__c,genesis__Account__r.Father_Husband_Daughter_Name__c,genesis__Account__r.PersonOtherStreet,FPIPrincRepayInstal__c,
                               genesis__Account__r.PersonOtherCity,genesis__Account__r.PersonOtherState,genesis__Account__r.PersonOtherPostalCode,genesis__Account__r.Full_Name__c,genesis__Account__r.Father_Name__pc,MCLR_Rate__c,genesis__Expected_First_Payment_Date__c,genesis__Margin__c,Record_Type_Name__c,genesis__Account__r.Age__c,
                               (Select id,genesis__Party_Account_Name__r.Aadhaar_Number__pc,Name,genesis__Party_Account_Name__r.Full_Name__c,genesis__Party_Account_Name__r.PersonOtherStreet,genesis__Party_Account_Name__r.PersonOtherCity,genesis__Party_Account_Name__r.PersonOtherState,genesis__Party_Account_Name__r.PersonOtherPostalCode,Guarantor__c,genesis__Party_Account_Name__r.PersonEmail,
                               genesis__Party_Account_Name__r.Pan_Number__c,genesis__Party_Account_Name__r.PersonMobilePhone from genesis__Application_Parties__r where genesis__Party_Type__c =:Constants.Co_Borrower AND Active__c=True Limit 1),(select id,DD_No__c,Total_Vehicle_Value__c,Dealer_name__c,Final_vehicle_value__c,Dealer_Pincode__c,Dealer_Email__c,clcommon__Address__c,clcommon__Manufacturer__c,clcommon__Model__c,Variant__c,Proforma_Invoice_Date__c,Proforma_Invoice_No__c,clcommon__Year__c,Advances_Paid__c,Vehicle_CalculatedValue__c,DD_Amount__c,DD_Date__c from genesis__Collaterals__r LIMIT 1)  
                               from genesis__Applications__c where id =:appId];
            
            return loanApplication;
        } catch(Exception e) {
            System.debug('##getApplication### --- > '+ e.getLineNumber() +' ' +e.getCause());
            HandleBusinessException.captureError('VL_DigioTemplateService', 'getApplication', e);
            return null;
        }
        
    }
}