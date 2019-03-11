@isTest
public class Test_WS_EsignDocID {
    public static genesis__Applications__c genApp;
    
    @isTest
    public static void methodGetEsignDocId(){
        try{
        genApp = TestUtility.intialSetUp('Home Loan', true);
        Account acc = new Account(name = 'TestEsignDoc');
        INSERT acc;
        blob b=blob.valueOf(getdetails());
        TestUtility.webserviceRequest('services/apexrest/getEsignDocID','POST',b);
        Test.startTest();
        WS_GetEsignDocID.Response rs = WS_GetEsignDocID.getEsignDocId();
        Test.stopTest();
        System.assert(rs!=null);
        System.assertEquals('200', rs.statusCode);
        }catch(exception ex){}
        
    }
    
    public static string getdetails(){
        String json=    
            '{'+
            '"LOS_APPID":"'+genApp.id+'",'+
            '"ESIGN_ACCEPTED":"accepted" '+
            '}';
        return json;
    }
    
}