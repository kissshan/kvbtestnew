public class Loan_Charge_Collection_Handler {
    public String exe_tenantId; //cuecent_tenant
    public String owner_tenantId;   //cuecent_tenant
    public inputVariables inputVariables;
    public class inputVariables {
        public in_msg in_msg;
    }
    public class in_msg {
        public String TransactionBranch;    //9999
        public String ToGLAccountNo;    //275300900
        public String TransactionAmount;    //1000
        public String UserReferenceNumber;  //2808501901
        public String Narration;    //test
        public String FromCASAAccountNo;    //1219223000000993
        public String ToGlBranchCode;   //1219
    }
    public static Loan_Charge_Collection_Handler parse(String json){
        return (Loan_Charge_Collection_Handler) System.JSON.deserialize(json, Loan_Charge_Collection_Handler.class);
    }
 /*   
    static testMethod void testParse() {
        String json=        '{'+
            '    "exe_tenantId": "cuecent_tenant",'+
            '    "owner_tenantId": "cuecent_tenant",'+
            '    "inputVariables": {'+
            '        "in_msg": {'+
            '        "TransactionBranch":"9999", //branch code'+
            '        "ToGLAccountNo":"275300900", //fixed'+
            '        "TransactionAmount":"1000", //'+
            '        "UserReferenceNumber":"2808501901",'+
            '        "Narration":"test",'+
            '        "FromCASAAccountNo":"1219223000000993",'+
            '        "ToGlBranchCode":"1219"'+
            '       '+
            '        }'+
            '   '+
            '    }'+
            '}';
        Loan_Charge_Collection_Handler obj = parse(json);
        System.assert(obj != null);
    } */
}