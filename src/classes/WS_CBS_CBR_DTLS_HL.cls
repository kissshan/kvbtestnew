/*
* Name    : WS_CBS_CBR_DTLS_HL
* Company : ET Marlabs
* Purpose : This class Will be used to CBS (CBR) 
* Author  : Subas
*/
public class WS_CBS_CBR_DTLS_HL {
    @future (Callout=true)
    public static void CBR_DTLSF(String AppID){        
        CBR_DTLS(AppID);        
    }
    public static void CBR_DTLS(String AppID){
        List<CBS_API_Log__c> UpcbsLog =  new List<CBS_API_Log__c>();
        CBR_DTLSNEW(AppID,null,UpcbsLog);
    }   
    public static void CBR_DTLSNEW(String AppID,String loanNo,List<CBS_API_Log__c> UpcbsLog){ //CBS_001       
        System.debug('AppID:::'+AppID);
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appID);
        genesis__Applications__c app = new genesis__Applications__c();
        app = [SELECT Id,genesis__CL_Product__r.clcommon__Product_Name__c FROM genesis__Applications__c WHERE Id =: AppId];   
        System.debug('AppID:::'+AppID);
        CBR_DTLS_HELPER_HL cbs = new CBR_DTLS_HELPER_HL();
        cbs.inputVariables = new CBR_DTLS_HELPER_HL.cls_inputVariables();
        CBR_DTLS_HELPER_HL.cls_inputVariables cbsInput = new CBR_DTLS_HELPER_HL.cls_inputVariables();
        cbsInput.in_msg = new CBR_DTLS_HELPER_HL.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        if(loanNo != null){
            cbsInput.in_msg.AccountNumber  = loanNo;
        }else{
            cbsInput.in_msg.AccountNumber  = application.Loan_Account_Number__c;    //1219223000000526
        }        
        cbsInput.in_msg.CustomerID  = application.CustomerID__c;    //28957
        cbsInput.in_msg.MISType  = 'LN';//'CH'; //CH
        cbsInput.in_msg.GovtScheme  = '';   //null
        cbsInput.in_msg.Guarantee  = '';    //null
        cbsInput.in_msg.Others  = '';   //null
        cbsInput.in_msg.Refinance  = '';    //null
        cbsInput.in_msg.SanctionReference  = '';    //null
        cbsInput.in_msg.SanctionDate  =  application.Sanction_Date__c != null ? formatDateto(application.Sanction_Date__c) : null;//'07102017';
        cbsInput.in_msg.DateoOfDPN  = application.Sanction_Date__c != null ? formatDateto(application.Sanction_Date__c) : null; //formatDate(application.Created_Date__c); //'07102017';
        if(application.Record_Type_Name__c  == Constants.PERSONALLOAN){
            cbsInput.in_msg.SanctionDate  =  application.Sanction_Date__c != null ? formatDateto(application.Sanction_Date__c) : null;//'07102017';
            //cbsInput.in_msg.DateoOfDPN  = application.Sanction_Date__c != null ? formatDateto(application.Sanction_Date__c) : null;
        }
        if(application.Record_Type_Name__c  == Constants.VL2W || application.Record_Type_Name__c  == Constants.VL4W){
            cbsInput.in_msg.DateoOfDPN  = '';
        }
        cbsInput.in_msg.DateOfRevivalLetter  = '';  //null
        cbsInput.in_msg.PSDateOfValuation_Inspection  = ''; //null
        cbsInput.in_msg.Investment_In_P_And_M  = '';    //null
        cbsInput.in_msg.CreditRiskRating  = ''; //null
        cbsInput.in_msg.RiskClass  = '';    //null
        cbsInput.in_msg.SME  = '';  //null
        cbsInput.in_msg.RiskWeight  = '';   //null
        cbsInput.in_msg.LoanDate  = application.Sanction_Date__c != null ? formatDateto(application.Sanction_Date__c) : null;//formatDate(application.Created_Date__c);//'07102017';  //null create date
        /*if(application.Record_Type_Name__c  == Constants.PERSONALLOAN){
            cbsInput.in_msg.LoanDate  = application.Sanction_Date__c != null ? formatDateto(application.Sanction_Date__c) : null;
        }*/
        cbsInput.in_msg.SanctionBy  = 1;    //0
        cbsInput.in_msg.PSValue_On_Date_Of_Inspection  = 0; //0
        cbsInput.in_msg.CSValue_On_Date_Of_Inspection  = 0; //0
        cbsInput.in_msg.SubsidyAmount  = 0; //0
        cbsInput.in_msg.Margin  = 0;    //0
        cbsInput.in_msg.Code_No_Of_Manager_Sanction  = 0;   //0
        cbsInput.in_msg.RBIPurposeCode  = 0;    //0
        cbsInput.in_msg.ENCPortCode  = 0;   //0
        cbsInput.in_msg.SectorEngagedIn  = 0;   //0
        cbsInput.in_msg.Investment_In_Equipment_Service  = 0;   //0
        cbsInput.in_msg.Sales_Turnover_Rupees  = 0; //0
        cbsInput.in_msg.Number_Of_Items_Jewels  = 0;    //0
        cbsInput.in_msg.Jewels_Gross_Weight_gms  = 0;   //0
        cbsInput.in_msg.Jewels_Net_Weight_gms  = 0; //0
        cbsInput.in_msg.Category_Of_Borrowers  = 99;    //0
        /*if(app.genesis__CL_Product__r.clcommon__Product_Name__c.contains('Co-Lending')){
            cbsInput.in_msg.Category_Of_Borrowers = Integer.valueOf(Third_Party_CBR_Codes__c.getValues(application.Sourced_By__c).CBR_Code__c);
        }*/
        cbsInput.in_msg.MakerID  = 'TELLER';    //TELLER
        cbsInput.in_msg.CheckerID  = 'SYSSUPER';    //SYSSUPER
        if(application.Record_Type_Name__c  == Constants.PERSONALLOAN){
            cbsInput.in_msg.DateoOfDPN  = null;
             cbsInput.in_msg.LoanDate  = null;
            cbsInput.in_msg.DateOfRevivalLetter  = null;  //null
            cbsInput.in_msg.PSDateOfValuation_Inspection  = null; //null
            cbsInput.in_msg.Investment_In_P_And_M  = null;    //null
            cbsInput.in_msg.CreditRiskRating  = null; //null
            cbsInput.in_msg.RiskClass  = null;    //null
            cbsInput.in_msg.SME  = null;  //null
            cbsInput.in_msg.RiskWeight  = null; 
            cbsInput.in_msg.PSValue_On_Date_Of_Inspection  = null; //0
            cbsInput.in_msg.CSValue_On_Date_Of_Inspection  = null; //0
            cbsInput.in_msg.SubsidyAmount  = null; //0
            cbsInput.in_msg.Margin  = null;    //0
            cbsInput.in_msg.Code_No_Of_Manager_Sanction  = null;   //0
            cbsInput.in_msg.RBIPurposeCode  = null;    //0
            cbsInput.in_msg.ENCPortCode  = null;   //0
            cbsInput.in_msg.SectorEngagedIn  = null;   //0
            cbsInput.in_msg.Investment_In_Equipment_Service  = null;   //0
            cbsInput.in_msg.Sales_Turnover_Rupees  = null; //0
            cbsInput.in_msg.Number_Of_Items_Jewels  = null;    //0
            cbsInput.in_msg.Jewels_Gross_Weight_gms  = null;   //0
            cbsInput.in_msg.Jewels_Net_Weight_gms  = null; //0
        }
        if(app.genesis__CL_Product__r.clcommon__Product_Name__c!=null){
            if(app.genesis__CL_Product__r.clcommon__Product_Name__c.contains('Co-Lending')){
                cbsInput.in_msg.ENCPortCode = Integer.valueOf(Third_Party_CBR_Codes__c.getValues(application.Sourced_By__c).CBR_Code__c);
            }
        }
        System.debug('cbs:::'+cbs);
        getCBR(JSON.serialize(cbs),AppID,loanNo,UpcbsLog); //CBS_001
        System.debug('AppId:::'+AppId);
    }
    public static void getCBR(String cbrData,String AppID,String loanNo,List<CBS_API_Log__c> UpcbsLog){ //CBS_001
        system.debug('%%%%%'+cbrData);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_CBR_DTLS_MNT_HL');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,cbrData,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        try{
            If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();            
                CBR_DTLS_HELPER_HL.CBR_DTLS_RESPONSE res = (CBR_DTLS_HELPER_HL.CBR_DTLS_RESPONSE)Json.deserialize(jsonString,CBR_DTLS_HELPER_HL.CBR_DTLS_RESPONSE.class);
                System.debug(res);
                System.debug(res.out_msg.ErrorMessage);
                if(res.out_msg.ErrorMessage == 'Success'){
                    // CBS_001 : CBS CBR_Update success response insert
                        CBS_API_Log__c CbsDedup = new CBS_API_Log__c();
                        CbsDedup.Application__c = AppID;
                        CbsDedup.API_Name__c = 'CBR_Update';
                        CbsDedup.Status__c = 'Success';
                        CbsDedup.Success_Error_Message__c = res.out_msg.ErrorMessage;
                        CbsDedup.Sequence_No__c = '8';  
                        UpcbsLog.add(CbsDedup);
                    if(loanNo != null){
                        WS_CBS_MIS_Update_HL.Mis_UpdateNEW(AppId,loanNo,UpcbsLog);
                    }else{
                        WS_CBS_MIS_Update_HL.Mis_Update(AppId,UpcbsLog);
                    }
                }else{
                    system.debug('UpcbsLog1-->'+UpcbsLog);
                    CBS_API_Log__c log = new CBS_API_Log__c();    
                    log.Application__c = AppId;
                    log.API_Name__c = 'CBR_Update';
                    log.Status__c = 'Failure';
                    log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                    log.Sequence_No__c = '8';  
                    UpcbsLog.add(log);
                    system.debug('UpcbsLog2-->'+UpcbsLog);
                    insert UpcbsLog; //CBS_001
                    //insert log;  //CBS_001
                    if(loanNo != null && AppID !=null){
                        genesis__Applications__c a= new genesis__Applications__c();
                        a.Id = AppID;
                        a.Loan_Account_Number__c = loanNo;                    
                        update a;
                    }                  
                }
            }
        }catch(exception e){
                HandleBusinessException.captureError('WS_CBS_CBR_DTLS_HL','getCBR', e);
        }        
    }
    public static String formatDate(Date d) {
        return String.ValueOf(d.day() + d.month() + d.year());
    }
    public static String formatDateto(Date d) {
        //return String.ValueOf(d.day()) +  String.ValueOf(d.month()) +  String.ValueOf(d.year());

        Map<String,String> mapOfNumber = new Map<String,String>{'1'=>'01','2'=>'02','3'=>'03','4'=>'04','5'=>'05','6'=>'06','7'=>'07','8'=>'08','9'=>'09'};
        String dateString = '';
       
        try{
            if(d != null){
                system.debug('dates '+d);
                List<String> listOfDateString = String.valueOf(d).split('-');
                if(listOfDateString !=null && listOfDateString.size() > 0 ){
                    dateString = listOfDateString[2]; 
                    if(mapOfNumber.containsKey(listOfDateString[1])){
                        dateString = dateString+mapOfNumber.get(listOfDateString[1]);
                    }else{
                        dateString = dateString+listOfDateString[1];
                    }
                    if(mapOfNumber.containsKey(listOfDateString[0])){
                        dateString = dateString+mapOfNumber.get(listOfDateString[0]);
                    }else{
                        dateString = dateString+listOfDateString[0];
                    }
                    return dateString;
                }
            }   
        }catch(Exception ex){
            System.debug('Exception'+ex.getMessage());
            
        }
         return null;
    }
}