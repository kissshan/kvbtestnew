@isTest
public class Test_WS_UpdateLoanApplication {
    Static genesis__Applications__c app;
    //valid Data
@isTest
    public static void getMandateFieldsValid(){
        app=TestUtility.intialSetUp('HomeLoan',true);
        blob b=blob.valueOf(getdetails());
        TestUtility.webserviceRequest('services/apexrest/updateApplication','POST',b);
        Test.startTest();
        WS_UpdateLoanApplication.Response rs=WS_UpdateLoanApplication.getMandateFields();
        Test.stopTest();       
         System.assert(rs!=null);
        System.assertEquals('200', rs.statusCode);
    }
    //Null value
   @isTest 
    public static void getMandateFieldsNull(){
        app=TestUtility.intialSetUp('HomeLoan',true);
        TestUtility.webserviceRequest('services/apexrest/updateApplication','POST',null);
        Test.startTest();
        WS_UpdateLoanApplication.getMandateFields();
        Test.stopTest();
        
    }
    //Invalid Data
    @isTest 
    public static void getMandateFieldsInvalid(){
        app=TestUtility.intialSetUp('HomeLoan',true);
         blob b=blob.valueOf(getdetails2());
        TestUtility.webserviceRequest('services/apexrest/updateApplication','POST',b);
        Test.startTest();
        WS_UpdateLoanApplication.Response rs=WS_UpdateLoanApplication.getMandateFields();
        Test.stopTest();
        System.assert(rs!=null);
        System.assertEquals('400', rs.statusCode);
        
    }
    public static string getdetails(){
        String json=	
	'{'+
	'"ApplicationID":"'+app.id+'", '+
	'"FETransId":"S",'+
	'"PGTransId":"S", '+
	'"TransDateTime":"'+system.today()+'", '+
	'"TotalAmnt":"50000", '+
	'"PgStatus":"Accepted" '+
	'}';
	
        return json;
    }

    public static string getdetails2(){
        String json=	
	'{'+
	'"AppID":"'+app.id+'", '+
	'"FETransId":"S",'+
	'"PGTransId":"S", '+
	'"TransDateTime":"'+system.today()+'", '+
	'"TotalAmnt":"50000", '+
	'"PgStatus":"Accepted" '+
	'}';
	
        return json;
    }

}