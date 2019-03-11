public class WS_Loan_Charge_Collection {
    public static void charge_collection(){
        Loan_Charge_Collection_Handler cbs = new Loan_Charge_Collection_Handler();
        cbs.inputVariables = new Loan_Charge_Collection_Handler.inputVariables();
        Loan_Charge_Collection_Handler.inputVariables cbsCC  = new Loan_Charge_Collection_Handler.inputVariables();
        cbsCC.in_msg = new Loan_Charge_Collection_Handler.in_msg();
        cbs.inputVariables = cbsCC;
        cbs.exe_tenantId = '';
        cbs.owner_tenantId = '';
        cbsCC.in_msg.TransactionBranch = '';
        cbsCC.in_msg.ToGLAccountNo = '';
        cbsCC.in_msg.TransactionAmount = '';
        cbsCC.in_msg.UserReferenceNumber = '';
        cbsCC.in_msg.Narration = '';
        cbsCC.in_msg.FromCASAAccountNo = '';
        cbsCC.in_msg.ToGlBranchCode = '';
        callChargeCollection(JSON.serialize(cbs));
    }
    public static void callChargeCollection(String chargeCol){
        try{
        System.debug('#######'+chargeCol);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('Loan_Charge_Collection');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,chargeCol,headerMap,label.CA_CERTIFICATE); 
        }Catch(Exception e){}
    }
}