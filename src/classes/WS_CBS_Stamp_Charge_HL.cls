/*
* Name      : WS_CBS_Stamp_Charge_HL
* Compnay   : ET Marlabs
* Purpose   : For HL Service(API used for stamp charge collection) 
* Author    : Subas
*/
public class WS_CBS_Stamp_Charge_HL {
    public static void sendStamp_Charge(String appId, String AccNumber){
        genesis__Applications__c application = new genesis__Applications__c(); 
        application = queryService.getApp(appId);
        Decimal TotalChargeAmount = (application.Cersai_Charges__c != null ? application.Cersai_Charges__c : 0) + (application.Cersai_Fee_with_GST__c != null ? application.Cersai_Fee_with_GST__c : 0)+ (application.Total_Stamp_Paper_Charge__c != null ? application.Total_Stamp_Paper_Charge__c : 0);
        Decimal TotalGST = (application.Cersai_Fee_with_GST__c != null ? application.Cersai_Fee_with_GST__c : 0);
        
        CBS_Stamp_Charge_Handler_HL cbs = new CBS_Stamp_Charge_Handler_HL();
        cbs.inputVariables = new CBS_Stamp_Charge_Handler_HL.cls_inputVariables();
        CBS_Stamp_Charge_Handler_HL.cls_inputVariables cbsInput = new CBS_Stamp_Charge_Handler_HL.cls_inputVariables();
        cbsInput.in_msg = new CBS_Stamp_Charge_Handler_HL.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbsInput.in_msg.AccountNumber = AccNumber;//application.genesis__Bank_Account_Number__c;
        cbsInput.in_msg.BranchCode = application.Branch_Code__c;
        cbsInput.in_msg.TotalAmount = TotalChargeAmount;
      //  cbsInput.in_msg.GST_Charge = Integer.valueOf(TotalGST);
        cbsInput.in_msg.ApplicationNumber = application.Name;
        cbsInput.in_msg.ApplicantName = application.Primary_Applicant__c;
        cbsInput.in_msg.TransactionDate = String.valueOf(system.today().format()); //'04/10/2017';29/3/2018
        cbsInput.in_msg.ValueDate = String.valueOf(system.today().format()); //'04/10/2017';
        cbsInput.in_msg.Flg_StmpFee_Brn= application.Legal_desk_state_flag__c==true?'N':'Y';
        cbsInput.in_msg.Flg_Force_Debit='N';//Braj:'N' for retails;Date:04-12-18
        cbsInput.in_msg.Charges = new List<CBS_Stamp_Charge_Handler_HL.cls_Charges>();
        List<CBS_Stamp_Charge_Handler_HL.cls_Charges> chargeList = new List<CBS_Stamp_Charge_Handler_HL.cls_Charges>();
        CBS_Stamp_Charge_Handler_HL.cls_Charges charge = new CBS_Stamp_Charge_Handler_HL.cls_Charges();        
        charge.GL_Type = 'CERSAI_FEE';
        charge.ChargeAmount = application.Cersai_Charges__c != null ? application.Cersai_Charges__c : 0;
         charge.GST_Charge=TotalGST;
        chargeList.add(charge);
        CBS_Stamp_Charge_Handler_HL.cls_Charges charge2 = new CBS_Stamp_Charge_Handler_HL.cls_Charges();
        charge2.GL_Type = 'STMP_FEE';
        charge2.ChargeAmount = application.Total_Stamp_Paper_Charge__c != null ? application.Total_Stamp_Paper_Charge__c : 0;
        charge2.GST_Charge=0;
        chargeList.add(charge2);
       /* CBS_Stamp_Charge_Handler_HL.cls_Charges charge3 = new CBS_Stamp_Charge_Handler_HL.cls_Charges();
        charge3.GL_Type = 'GST_FEE';
        charge3.ChargeAmount = Integer.ValueOf(application.Cersai_Fee_with_GST__c != null ? application.Cersai_Fee_with_GST__c : 0);
        chargeList.add(charge3); */
        cbsInput.in_msg.Charges = chargeList;
        pushCharge(JSON.serialize(cbs),appId,AccNumber);        
    }
    public static void pushCharge(String ChargeLoad,String appId, String AccNumber){
        system.debug('####'+ChargeLoad);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('Processing_Fee_API');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,ChargeLoad,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();            
            CBS_Stamp_Charge_Handler_HL.CBS_Stamp_Charge_Response res = (CBS_Stamp_Charge_Handler_HL.CBS_Stamp_Charge_Response)Json.deserialize(jsonString,CBS_Stamp_Charge_Handler_HL.CBS_Stamp_Charge_Response.class);
            System.debug(res);
            System.debug(res.out_msg.StatusDecs);
            System.debug(res.out_msg.ErrorMessage);
            if(res.out_msg.StatusDecs != null){
                //CBS_Charge_Payment_Completed
                genesis__Applications__c a = new genesis__Applications__c();
                a.Id = appId;
                a.CBS_Charge_Payment_Completed__c = true;
                a.CASA_Account_No__c     = AccNumber;
                update a;
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'Stamp_Processing Fee';
                log.Status__c = 'Success';
                log.Success_Error_Message__c = res.out_msg.StatusDecs;
                //log.Sequence_No__c = '15';  
                insert log;                
            }else if(res.out_msg.ErrorMessage == 'Success'){
                genesis__Applications__c a = new genesis__Applications__c();
                a.Id = appId;
                a.CBS_Charge_Payment_Completed__c = true;
                a.CASA_Account_No__c     = AccNumber;
                update a;                
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'Stamp_Processing Fee';
                log.Status__c = 'Success';
                log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                //log.Sequence_No__c = '15';  
                insert log;                 
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = AppId;
                log.API_Name__c = 'Stamp_Processing Fee';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = res.out_msg.ErrorMessage;
                //log.Sequence_No__c = '15';  
                insert log;                 
            }
        }else{
            CBS_API_Log__c log = new CBS_API_Log__c();    
            log.Application__c = AppId;
            log.API_Name__c = 'Stamp_Processing Fee';
            log.Status__c = 'Failure';
            log.Success_Error_Message__c = response.getBody();
            //log.Sequence_No__c = '15';  
            insert log;            
        }
    }
}