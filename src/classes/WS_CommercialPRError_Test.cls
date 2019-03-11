//uday----->73%
@isTest
public class WS_CommercialPRError_Test {
     @isTest
    public static void testMethod1(){
        
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/pushCommercialPRError'; 
        req.httpMethod  = 'POST';
        req.requestBody=Blob.valueOf('{"out_msg": [{"Req_id": "1667718","Ticket_id": "ERR","Date_Processed": "03102018","Member_Code": "BP03220001","Refrence_Number": "1667718","ID": "BP03220001_BATCH1","Response": "Error","Error": "1006","Error_Description": "The specified Pincode is Invalid."}]}');
        RestContext.request = req;
        RestContext.response = res;
        
        WS_CommercialPRError.getCommercialError();
    }
     @isTest
    public static void testMethod2(){
        
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/uday'; 
        req.httpMethod  = 'post';
        req.requestBody=Blob.valueOf('0xLjQKJeLjz9MKMSA" } }');
        RestContext.request = req;
       // RestContext.response = res;
        
        WS_CommercialPRError.getCommercialError();
    }
    @isTest
    public static void testMethod3(){
        
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/pushCommercialPRError'; 
        req.httpMethod  = 'POST';
       // req.requestBody=Blob.valueOf('');
        RestContext.request = req;
        RestContext.response = res;
        
        WS_CommercialPRError.getCommercialError();
    }
     @isTest
    public static void testMethod4(){
        
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/pushCommercialPRError'; 
        req.httpMethod  = 'POST';
        req.requestBody=Blob.valueOf('');
        RestContext.request = req;
        RestContext.response = res;
        
        WS_CommercialPRError.getCommercialError();
    }
    
    
}