@isTest
public class Test_Loan_Charge_Collection_Handler {
   
    public static testMethod void testParse() {
        	String json=        '{'+
            '    "exe_tenantId": "cuecent_tenant",'+
            '    "owner_tenantId": "cuecent_tenant",'+
            '    "inputVariables": {'+
            '        "in_msg": {'+
            '        "TransactionBranch":"9999", '+
            '        "ToGLAccountNo":"275300900",'+
            '        "TransactionAmount":"1000", '+
            '        "UserReferenceNumber":"2808501901",'+
            '        "Narration":"test",'+
            '        "FromCASAAccountNo":"1219223000000993",'+
            '        "ToGlBranchCode":"1219"'+
            '       '+
            '        }'+
            '   '+
            '    }'+
            '}';
      		Loan_Charge_Collection_Handler obj= Loan_Charge_Collection_Handler.parse(json);
        	System.assert(obj != null);
    } 
}