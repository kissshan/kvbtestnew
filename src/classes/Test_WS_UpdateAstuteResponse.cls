@isTest
public class Test_WS_UpdateAstuteResponse {
Static genesis__Applications__c app;
    static Account acc;
    static Account acc1;
    //valid data
    @isTest
    public static void getSMECustomersValid() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        acc = new Account(Name = 'TestName');
        insert acc;
        blob b = blob.valueOf(getdetails());
        TestUtility.webserviceRequest('services/apexrest/updateAstutesRecord', 'POST', b);
        Test.startTest();
        WS_UpdateAstuteResponse.getCustomerView();
        Test.stopTest();
        

    }
  
     //Null data
   @isTest 
    public static void getSMECustomersNull() {
        app = TestUtility.intialSetUp('HomeLoan', true);
        TestUtility.webserviceRequest('services/apexrest/updateAstutesRecord', 'POST',Null);
        Test.startTest();
        WS_UpdateAstuteResponse.getCustomerView();
        Test.stopTest();
        

    }

    public static string getdetails() {
        String json =
            '{' +
            '"Emp_Name":"Niladri" ,' +
            '"Branch_Code":"005" ' +
            '}';

        return json;
    }

    public static string getdetails1() {
        String json =
            '{' +
            '"ApplicantIDuu":"' + acc.id + '" ,' +
            '"action":"test" ' +
            '}';

        return json;
    }
}