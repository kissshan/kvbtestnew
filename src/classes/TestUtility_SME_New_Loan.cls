public class TestUtility_SME_New_Loan {
 public static Account createAccount(String name, String Branch_Code, String CBS_CustomerId,string nameofdirector,string relationship,string bankname,string transactionId){
        Account  acc = new Account();
        acc.Name=name;
        acc.Branch_Code__c=Branch_Code;
        acc.CBS_Customer_ID__c=CBS_CustomerId;
        acc.Name_Of_Director_Related_To__c=nameofdirector;
        acc.Relationship__c=relationship;
        acc.Bank_name__c=bankname;
     	acc.Jocata_TxnId__c = transactionId;
        return acc;
    }
}