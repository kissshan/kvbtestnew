//uday----->74%
@isTest
public class FetchCityMaster_Test {
    @isTest
    public static void testMethod1(){
        City_Master__c cm=new City_Master__c();
        cm.Name='Gujarwas';
        cm.CODCITY__c='121';
        cm.CODSTATE__c='31';
        cm.CODPIN__c='123';
        insert cm;
        
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/fetchCityMaster'; 
        req.httpMethod  = 'POST';
        req.requestBody=Blob.valueOf('{"stateCode":"31"}');
        RestContext.request = req;
        RestContext.response = res;
        
        FetchCityMaster.getCityMater();
    }
    @isTest
    public static void testMethod2(){
        
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/fetchCityMaster'; 
        req.httpMethod  = 'POST';
        //req.requestBody=Blob.valueOf('{"stateCode":"31"}');
        RestContext.request = req;
        RestContext.response = res;
        
        FetchCityMaster.getCityMater();
    }
    @isTest
    public static void testMethod3(){
        
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/fetchCityMaster'; 
        req.httpMethod  = 'POST';
        req.requestBody=Blob.valueOf('{"stateCode":}');
        RestContext.request = req;
        RestContext.response = res;
        
        FetchCityMaster.getCityMater();
    }
}