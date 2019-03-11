/*
* Description : Test_WS_GSTR3B_Report_Aggregation_API
* Author      : Kishan Panchal
*/
@isTest
public class Test_WS_GSTR3B_Report_Aggregation_API {
     static string method(string str){
        WS_GSTR3B_Report_Aggregation_API.ResponseStructure_Child responseObj = new  WS_GSTR3B_Report_Aggregation_API.ResponseStructure_Child();
        responseObj.gstn = '1234';
        responseObj.yearwise = new list<WS_GSTR3B_Report_Aggregation_API.Yearwise>();
        WS_GSTR3B_Report_Aggregation_API.Yearwise apiYearObj = new WS_GSTR3B_Report_Aggregation_API.Yearwise();
        apiYearObj.months = 'august';
        apiYearObj.period_from = 'two month';
        apiYearObj.period_to = 'test';
        apiYearObj.total_sales = '200000';
        apiYearObj.year = '2016';
         
         WS_GSTR3B_Report_Aggregation_API.RequestStructure reqStructure = new WS_GSTR3B_Report_Aggregation_API.RequestStructure();
         reqStructure.from_date = '072017';
         reqStructure.to_date   = '072017';
         reqStructure.gstn      = '12345';
        
        responseObj.yearwise.add(apiYearObj);
        string json = json.serialize(responseObj);
        System.debug('jSon:::'+jSon);
        return jSon;
    }
    @isTest static void fun(){
         Blob b = Blob.valueOf(method('appDetailObj'));
        KVB_Endpoint_URLs__c kvb  = new KVB_Endpoint_URLs__c(name='GSTR3B Report',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/gst/async-gstr3b');
        insert kvb;
       
        KVB_Endpoint_URLs__c kvb2  = new KVB_Endpoint_URLs__c(name='GSTR3B Callback Report',Endpoint_URL__c='/services/apexrest/pushGSTR3BReport');
        insert kvb2;
         KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb1;
        TestUtility.webserviceRequest('services/apexrest/pushGSTR3BReport', 'POST', b);
         
        Test.startTest();
	Test.setMock(HttpCalloutMock.class, new MockHttpResponse());        
        
        WS_GSTR3B_Report_Aggregation_API.getRespone();
        WS_GSTR3B_Report_Aggregation_API.sendRequest('123','456','789');
        
        Test.stopTest(); 
    }
    @isTest static void fun1(){
         Blob b = Blob.valueOf(method('appDetailObj'));
        //TestUtility.webserviceRequest('services/apexrest/pushGSTR3BReport', 'POST', b);
         
        Test.startTest();
        WS_GSTR3B_Report_Aggregation_API.getRespone();
        
        Test.stopTest(); 
    }
}