/*
* Description : Test_WS_LandingPage
* Author      : Kishan Panchal
*/
@isTest
public class Test_WS_LandingPage {
    public static string getMethod(string method){
       
        Account accObj = new Account(name='kvb');
        insert accObj;
        
        WS_LandingPage.ReqWrapObj obj = new  WS_LandingPage.ReqWrapObj();
        obj.custId = accObj.Id;
        
        string json = json.serialize(obj);
        return jSon;
    }
    
    @isTest static void landingPageMethod(){
        Blob b = Blob.valueOf(getMethod('appDetailObj'));
        TestUtility.webserviceRequest('services/apexrest/getCustomerList', 'POST', b);
        Test.startTest();
        WS_LandingPage.handleRequest();
        Test.stopTest();    
    }
    
    @isTest static void landingPageNullRes(){
        Blob b = Blob.valueOf(getMethod('appDetailObj'));
        Test.startTest();
        WS_LandingPage.handleRequest();
        Test.stopTest();    
    }
    
}