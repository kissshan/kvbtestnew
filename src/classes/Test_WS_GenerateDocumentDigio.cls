@isTest
public class Test_WS_GenerateDocumentDigio {
 Static genesis__Applications__c app;
    static Account acc;
    static Account acc1;
    //valid data
    @isTest
    public static void deativatePartiesValid() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        acc = new Account(Name = 'TestName');
        insert acc;
        acc1 = new Account(Name = 'TestName1');
        insert acc1;
        genesis__Application_Parties__c parobj = TestUtility.createAppParties(acc.Id, acc1.id);
        insert parobj;
        blob b = blob.valueOf(getdetails());
        TestUtility.webserviceRequest('services/apexrest/generateDigioDocument', 'POST', b);
        Test.startTest();
        WS_GenerateDocumentDigio.getSMECustomers();
        Test.stopTest();
     

    }
   
    public static string getdetails() {
        String json=	
	'{'+
	'"LOS_APPID":"'+app.id+'", '+
	'"IS_Submitted":"Yes",'+
	'"After_ESign":"Yes", '+
	'"Doc_ID":"50000shd" '+
	'}';
        return json;
    }


    
}