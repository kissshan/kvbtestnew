@isTest
public class Test_Loan_Creation_Helper_HL {
    @isTest
    public static String methodparse(){
        String json =  '{'+
            '"exe_tenantId": "cuecent_tenant",'+
            '"owner_tenantId": "cuecent_tenant",'+
            '"inputVariables": {'+
            '"in_msg": {'+
            '"AssetValue": "500000",'+
            '"BranchCode": "1315",'+
            '"Contribution": "0",'+
            '"CustomerId": "6113631",'+
            '"InterestVariance": "2",'+
            '"LoanAmount": "500000",'+
            '"ProductCode": "939",'+
            '"ScheduleName": "9399",'+
            '"TransactionBranch": "Bnglr"'+
            '}'+
            '}'+
            '}';
       
        Loan_Creation_Helper_HL.parse(json);
        RETURN json;
    }
    
    @isTest
    public static void method2(){
        Loan_Creation_Helper_HL.cls_ExtendedReply extRep = new Loan_Creation_Helper_HL.cls_ExtendedReply();
        extRep.MessagesArray = 'thank you';
        Loan_Creation_Helper_HL.cls_Status clStatus= new Loan_Creation_Helper_HL.cls_Status();
        clStatus.IsServiceChargeApplied = 'false';
        clStatus.ReplyCode = '0';
        clStatus.ErrorCode = '1';
        clStatus.IsOverriden = 'false';
        clStatus.SpReturnValue = '0';
        clStatus.Memo = 'TestMemo';
        clStatus.ExternalReferenceNo = '136162017100400010063';
        clStatus.ReplyText = 'testReply';
        clStatus.ExtendedReply = extRep;
        
        Loan_Creation_Helper_HL.cls_LoanResponse loanRes = new  Loan_Creation_Helper_HL.cls_LoanResponse();
        loanRes.AccountId = '1152753000003309';
        loanRes.Status = clStatus;
        
        Loan_Creation_Helper_HL.cls_out_msg clsOutMsg = new Loan_Creation_Helper_HL.cls_out_msg();
        clsOutMsg.ErrorMessage = 'No Record Found For Input Data';
        clsOutMsg.Response = 'Failure';
        clsOutMsg.LoanResponse = loanRes;
        
        Loan_Creation_Helper_HL.Loan_creation_response resp = new Loan_Creation_Helper_HL.Loan_creation_response();
        resp.bpms_error_code = '00';
        resp.out_msg = clsOutMsg;
        resp.bpms_error_msg = 'DedupeFailureResponse';
        
    }
    
}