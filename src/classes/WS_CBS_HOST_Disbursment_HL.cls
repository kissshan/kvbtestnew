/*
* Name    : WS_CBS_HOST_Disbursment_HL
* Company : ET Marlabs
* Purpose : This class Will be used to CBS (HOST_Disbursment) 
* Author  : Subas
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
    V1.1    29-Nov-2018    Venu         #CBS API Disbursement AMOUnt,Disbursement Mode Changes
   
*******************************************************************************************/

public class WS_CBS_HOST_Disbursment_HL {
    public class CBS_HOST_Request{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;        
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String AccountNo;    //1152753000002996
        public String DisbursementAmount;   //500000
        public String DisbursementMode; //2
        public String ScheduleType; //3001
        public String AuthId;   //SYSTEM01
        public String WaiveDednInd; //Y
        public String ExtUniqueRefId;   //1
        public String TransactionBranch;    //1152
        public String AmountInstal; //0
        public String EPIPrincRepayInstal;  //
        public String EPIPrincFreq; //
        public String EPIInstalAmt; //
        public String EPIDatRpayPrinc;  //
        public String EPITermYr;    //
        public String EPITermMonth; //
        public String IPIPrincRepayInstal;  //
        public String IPIPrincFreq; //
        public String IPIInstalAmt; //
        public String IPIDatRpayPrinc;  //
        public String IPIIntRepayInstal;    //
        public String IPIIntFreq;   //
        public String IPIDatRpayInt;    //
        public String IPITermYr;    //
        public String IPITermMonth; //
        public String IPICompfreq;  //
        public String IOIIntRepayInstal;    //
        public String IOIIntFreq;   //
        public String IOIDatRpayInt;    //
        public String IOITermYr;    //
        public String IOITermMonth; //12
        public String FPIPrincRepayInstal;  //
        public String FPIPrincFreq; //
        public String FPIInstalAmt; //
        public String FPIDatRepayPrinc; //
        public String FPIIntRepayInstal;    //
        public String FPIIntFreq;   //
        public String FPITermYr;    //
        public String FPITermMonth; //
        public String MORTermYr;    //
        public String MORTermMonth; //
    }
    //Response structure
    public class CBS_HOST_Response{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;   //Success
    }
    public class cls_out_msg {
        public String Response; //99
        public String SuccessMessage;   //
        public String ReasonMessage;    // Internal OLTP Error. 
        public String ErrorCode;    //4814
        public String ErrorMessage; //Disbursement amount above sanctioned amount
        public String ReasonCode;   //29
    }
    
    @future (Callout=true)
    public static void Host_request(String appID,String loanNo){
        Host_requestNew(appID, loanNo);
    }    
    public static void Host_requestNew(String appID,String loanNo){
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appID);
        WS_CBS_HOST_Disbursment_HL.CBS_HOST_Request cbs = new WS_CBS_HOST_Disbursment_HL.CBS_HOST_Request();
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbs.inputVariables = new WS_CBS_HOST_Disbursment_HL.cls_inputVariables();
        WS_CBS_HOST_Disbursment_HL.cls_inputVariables cbsInput = new WS_CBS_HOST_Disbursment_HL.cls_inputVariables();
        cbsInput.in_msg = new WS_CBS_HOST_Disbursment_HL.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbsInput.in_msg.AccountNo           = application.Loan_Account_Number__c!=null?application.Loan_Account_Number__c:loanNo;
        // V1.1 Start
       if(application.Record_Type_Name__c == Constants.LAPLOAN || application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.HOMELOAN){
           cbsInput.in_msg.DisbursementMode    = '5';
           cbsInput.in_msg.DisbursementAmount  = String.ValueOf(application.Disbursement_Amount__c + (application.Final_GMRA__c  !=null?application.Final_GMRA__c :0));
       }
        else if(application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W ){
            cbsInput.in_msg.DisbursementMode    = '5';
            cbsInput.in_msg.DisbursementAmount  = String.ValueOf(application.Sanction_Authority_Limit__c);
        }
        else{
            cbsInput.in_msg.DisbursementAmount  = String.ValueOf(application.Disbursement_Amount__c);
            cbsInput.in_msg.DisbursementMode    = '2';
        }
        // V1.1 End
        string SchType='';
        string IOTermMont='';
        string IODatre='';
        date RepDate;
        date CalcDate;
        Date TOdayDT= Date.valueOf('2018-11-05 00:00:00'); //system.today();
        
        if(application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
            SchType='1002';
        }
        else{
            SchType='3002';
        }
        
        system.debug('integer.valueOf(application.Day_Of_Disbursal__c):-'+integer.valueOf(application.Day_Of_Disbursal__c)+'  holiday:--'+application.Holiday_Period__c);
        if(!application.genesis__CL_Product_Name__c.contains('Co-Lending')){
            if(application.genesis__Disbursement_Date__c ==TOdayDT){
                
                if(integer.valueOf(application.Day_Of_Disbursal__c)==5){
                    if(Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) || application.Holiday_Period__c ==0) {
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
                            SchType='1001';
                        }
                        else{
                            SchType='3001';
                        }
                        
                    }
                    else{
                        IOTermMont= string.valueOf(application.Holiday_Period__c);
                    }
                }
                else if(integer.valueOf(application.Day_Of_Disbursal__c) >=1 &&integer.valueOf(application.Day_Of_Disbursal__c) <=4){
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.Holiday_Period__c !=0) {
                        IOTermMont= string.valueOf(application.Holiday_Period__c+1);
                        RepDate= (application.genesis__Disbursement_Date__c); 
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), 5);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    else{
                        IOTermMont='1';
                        RepDate= application.genesis__Disbursement_Date__c;
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), 5);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    
                }
                else if(integer.valueOf(application.Day_Of_Disbursal__c) >=6 &&integer.valueOf(application.Day_Of_Disbursal__c) <=31){
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.Holiday_Period__c !=0) {
                        IOTermMont= string.valueOf(application.Holiday_Period__c+1);
                        RepDate= (application.genesis__Disbursement_Date__c).addMonths(1); 
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), 5);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    else{
                        IOTermMont='1';
                        RepDate= (application.genesis__Disbursement_Date__c).addMonths(1); 
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), 5);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    
                }
                
                
            }
            else{
                
                if(TOdayDT.day()==5){
                    if(Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) || application.Holiday_Period__c ==0) {
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
                            SchType='1001';
                        }
                        else{
                            SchType='3001';
                        }
                    }
                    else{
                        IOTermMont= string.valueOf(application.Holiday_Period__c);
                    }
                }
                else if(TOdayDT.day() >=1 && TOdayDT.day() <=4){
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.Holiday_Period__c !=0) {
                        IOTermMont= string.valueOf(application.Holiday_Period__c+1);
                        RepDate= (TOdayDT); 
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), 5);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    else{
                        IOTermMont='1';
                        RepDate= TOdayDT;
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), 5);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    
                }
                else if(TOdayDT.day() >=6 && TOdayDT.day() <=31){
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.Holiday_Period__c !=0) {
                        IOTermMont= string.valueOf(application.Holiday_Period__c+1);
                        RepDate= (TOdayDT).addMonths(1); 
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), 5);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    else{
                        IOTermMont='1';
                        RepDate= (TOdayDT).addMonths(1); 
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), 5);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                }
            }
        }else{
        //for third party applications
            Integer disbDate = Integer.valueOf(Third_Party_CBR_Codes__c.getValues(application.Sourced_By__c).Disbursement_Date__c);
            if(application.genesis__Disbursement_Date__c ==TOdayDT){
                
                if(integer.valueOf(application.Day_Of_Disbursal__c)==disbDate){
                    if(Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) || application.Holiday_Period__c ==0) {
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
                            SchType='1001';
                        }
                        else{
                            SchType='3001';
                        }
                        
                    }
                    else{
                        IOTermMont= string.valueOf(application.Holiday_Period__c);
                    }
                }               
                else if(integer.valueOf(application.Day_Of_Disbursal__c) >=1 &&integer.valueOf(application.Day_Of_Disbursal__c) <=(disbDate-1)){
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.Holiday_Period__c !=0) {
                        IOTermMont= string.valueOf(application.Holiday_Period__c+1);
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                            RepDate= (application.genesis__Disbursement_Date__c).addMonths(1);
                        }else{
                            RepDate= (application.genesis__Disbursement_Date__c); 
                        }
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), disbDate);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    else{
                        IOTermMont='1';
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                            RepDate= (application.genesis__Disbursement_Date__c).addMonths(1);
                        }else{
                            RepDate= application.genesis__Disbursement_Date__c;
                        }
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), disbDate);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    
                }
                else if(integer.valueOf(application.Day_Of_Disbursal__c) >=(disbDate+1) &&integer.valueOf(application.Day_Of_Disbursal__c) <=31){
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.Holiday_Period__c !=0) {
                        IOTermMont= string.valueOf(application.Holiday_Period__c+1);
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                            RepDate= (application.genesis__Disbursement_Date__c).addMonths(2);
                        }else{
                            RepDate= (application.genesis__Disbursement_Date__c).addMonths(1);
                        }                       
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), disbDate);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    else{
                        IOTermMont='1';
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                            RepDate= (application.genesis__Disbursement_Date__c).addMonths(2);
                        }else{
                            RepDate= (application.genesis__Disbursement_Date__c).addMonths(1); 
                        }
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), disbDate);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    
                }
                
                
            }
            else{
                
                if(TOdayDT.day()==disbDate){
                    if(Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) || application.Holiday_Period__c ==0) { 
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN || application.Record_Type_Name__c == Constants.VL2W || application.Record_Type_Name__c == Constants.VL4W){
                            SchType='1001';
                        }
                        else{
                            SchType='3001';
                        }
                    }
                    else{
                        IOTermMont= string.valueOf(application.Holiday_Period__c);
                    }
                }
                else if(TOdayDT.day() >=1 && TOdayDT.day() <=(disbDate-1)){
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.Holiday_Period__c !=0) {
                        IOTermMont= string.valueOf(application.Holiday_Period__c+1);
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                            RepDate= (TOdayDT).addMonths(1);
                        }else{
                            RepDate= (TOdayDT); 
                        }
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), disbDate);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    else{
                        IOTermMont='1';
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                            RepDate= (TOdayDT).addMonths(1);
                        }else{
                            RepDate= TOdayDT;
                        }
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), disbDate);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    
                }
                else if(TOdayDT.day() >=(disbDate+1) && TOdayDT.day() <=31){
                    if(!Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) && application.Holiday_Period__c !=0) {
                        IOTermMont= string.valueOf(application.Holiday_Period__c+1);
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                            RepDate= (TOdayDT).addMonths(2);
                        }else{
                            RepDate= (TOdayDT).addMonths(1); 
                        }
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), disbDate);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                    else{
                        IOTermMont='1';
                        if(application.Record_Type_Name__c == Constants.PERSONALLOAN){
                            RepDate= (TOdayDT).addMonths(2);
                        }else{
                            RepDate= (TOdayDT).addMonths(1); 
                        }
                        CalcDate  =date.newInstance(RepDate.year(), RepDate.month(), disbDate);
                        IODatre=  String.ValueOf(CalcDate.format()) ;
                    }
                }
            }
            //third party related code end
        }
        
        cbsInput.in_msg.ScheduleType        =  SchType;      // application.Holiday_Period__c != null ? application.Holiday_Period__c != 0 ? '3002' :'3001' : '3001';
        cbsInput.in_msg.AuthId              = 'SYSTEM01';
        cbsInput.in_msg.WaiveDednInd        = 'Y';
        cbsInput.in_msg.ExtUniqueRefId      = application.Loan_Account_Number__c != null ?application.Loan_Account_Number__c:loanNo +'1';// to be decided
        cbsInput.in_msg.TransactionBranch   = application.Branch_Code__c;
        cbsInput.in_msg.AmountInstal        = '0';
        cbsInput.in_msg.EPIPrincRepayInstal = '';
        cbsInput.in_msg.EPIPrincFreq        = '';
        cbsInput.in_msg.EPIInstalAmt        = '';
        cbsInput.in_msg.EPIDatRpayPrinc     = '';
        cbsInput.in_msg.EPITermYr           = '';
        cbsInput.in_msg.EPITermMonth        = '';
        cbsInput.in_msg.IPIPrincRepayInstal = '';
        cbsInput.in_msg.IPIPrincFreq        = '';
        cbsInput.in_msg.IPIInstalAmt        = '';
        cbsInput.in_msg.IPIDatRpayPrinc     = '';
        cbsInput.in_msg.IPIIntRepayInstal   = '';
        cbsInput.in_msg.IPIIntFreq          = '';
        cbsInput.in_msg.IPIDatRpayInt       = '';
        cbsInput.in_msg.IPITermYr           = '';
        cbsInput.in_msg.IPITermMonth        = '';
        cbsInput.in_msg.IPICompfreq         = '';
        cbsInput.in_msg.IOIIntRepayInstal   = '';
        cbsInput.in_msg.IOIIntFreq          = '';
        cbsInput.in_msg.IOIDatRpayInt       = '05/12/2018';// '19/12/2018';  //IODatre; //
        cbsInput.in_msg.IOITermYr           = '';
        cbsInput.in_msg.IOITermMonth        = '1' ;// IOTermMont; //
        
        //for third party
        if(!Utility.ISStringBlankorNull(application.genesis__CL_Product_Name__c)){
            if(application.Record_Type_Name__c == Constants.PERSONALLOAN && application.genesis__CL_Product_Name__c.contains('Co-Lending')){
                cbsInput.in_msg.EPIDatRpayPrinc = IODatre;
                cbsInput.in_msg.IOIDatRpayInt   = '';
                cbsInput.in_msg.IOITermMonth    = '';
                cbsInput.in_msg.ScheduleType    = '1001';
            }
        }
        //third party related code end
        
        // cbsInput.in_msg.IOITermMonth        = application.Holiday_Period__c != null ? String.ValueOf(application.Holiday_Period__c) : '';
        /* if(application.genesis__Disbursement_Date__c != null){
if(application.Record_Type_Name__c==Constants.HOMELOAN  && !Utility.ISStringBlankorNull(string.valueOf(application.Holiday_Period__c) ) ){
cbsInput.in_msg.FPIPrincRepayInstal = application.FPIPrincRepayInstal2__c != null ? String.ValueOf(application.FPIPrincRepayInstal2__c).replace('-','') : '';

}
else{
cbsInput.in_msg.FPIPrincRepayInstal = application.FPIPrincRepayInstal__c != null ? String.ValueOf(application.FPIPrincRepayInstal__c).replace('-','') : '';
}

}else{*/
        cbsInput.in_msg.FPIPrincRepayInstal = '';
        // }       
        cbsInput.in_msg.FPIPrincFreq        = '';
        cbsInput.in_msg.FPIInstalAmt        = '';
        cbsInput.in_msg.FPIDatRepayPrinc    = '';
        /* if(application.genesis__Disbursement_Date__c != null){
cbsInput.in_msg.FPIIntRepayInstal   = application.FPIIntRepayInstal__c != null ? String.ValueOf(application.FPIIntRepayInstal__c).replace('-','') : '';
}else{ */
        cbsInput.in_msg.FPIIntRepayInstal   = '';
        //  }        
        cbsInput.in_msg.FPIIntFreq          = '';
        cbsInput.in_msg.FPITermYr           = '';
        cbsInput.in_msg.FPITermMonth        = '';
        cbsInput.in_msg.MORTermYr           = '';
        cbsInput.in_msg.MORTermMonth        = '';
        // system.debug('cbsInput'+JSON.serialize(cbs));
        callHostDisb(JSON.serialize(cbs),AppId,loanNo);
    }
    public static void callHostDisb(String HostData, String AppId,string loanNo){
        system.debug('@@@@'+HostData);
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>(); // CBS_001
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('HOST_Disb_HL');
        genesis__Applications__c AppIDPL = queryService.getApp(appId);
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,HostData,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();            
            WS_CBS_HOST_Disbursment_HL.CBS_HOST_Response res = (WS_CBS_HOST_Disbursment_HL.CBS_HOST_Response)Json.deserialize(jsonString,WS_CBS_HOST_Disbursment_HL.CBS_HOST_Response.class);
            System.debug(res);
            System.debug(res.out_msg.ErrorMessage);
            if((res.out_msg.ErrorMessage == null || res.out_msg.ErrorMessage =='') &&  (res.out_msg.ErrorCode =='' ||res.out_msg.ErrorCode == null) ){
                // CBS_001 : CBS LoanCreation success response insert
                        CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                        CbsDedup.Application__c = AppId;
                        CbsDedup.API_Name__c = 'Host_Disb';
                        CbsDedup.Status__c = 'Success';
                        CbsDedup.Success_Error_Message__c = res.out_msg.ErrorMessage;
                        CbsDedup.Sequence_No__c = '11.5';  
                        UpcbsLog.add(CbsDedup);
                //WS_CBS_MIS_Update_HL.Mis_Update(AppId);
                WS_CBS_Loan_Disbursment_HL.callDisb(AppId,UpcbsLog,loanNo);
                
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'Host_Disb';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                log.Sequence_No__c = '11.5';
                log.Success_Error_Code__c = res.out_msg.ErrorCode;
                log.Reason_Message__c =   res.out_msg.ReasonMessage;
                log.Reason_Code__c = res.out_msg.ReasonCode;
                insert log;
                // for pre approve loan
                if(loanNo != null && AppID !=null){
                    genesis__Applications__c a= new genesis__Applications__c();
                    a.Id = AppID;
                    a.Loan_Account_Number__c = loanNo;                    
                    update a;
                }
                
            }
        }
    }
}