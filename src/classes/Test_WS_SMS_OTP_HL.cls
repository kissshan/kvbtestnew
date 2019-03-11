//writtent by prashant singh
//class name:---WS_SMS_OTP_HL
//code coverage------- 94%
@istest
public class Test_WS_SMS_OTP_HL {
@testsetup
    public static void setupMethod()
        
    {	
          KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb; 
       KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'CBS_OTP_SERVICE';
        KVB1.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/OTP_REQ';
     	insert kvb1;
        
         KVB_Endpoint_URLs__c kvb2 = new KVB_Endpoint_URLs__c();
     	KVB2.Name = 'Processing_Fee_API';
        KVB2.Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_ACDR_GLCR_Charge_COLL';
     	insert kvb2;
		genesis__Applications__c app = TestUtility.intialSetUp('HomeLoan', true);
          
    } 
    
        @istest
    public static void method1()        
    {
        try{
        genesis__Applications__c app=[select id from genesis__Applications__c limit 1];
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		test.startTest();
        WS_SMS_OTP_HL.generateOTP('100');
        test.stopTest();
        }
        catch(Exception e)
        {
            system.debug('Exception:---'+e);
        }
    }
    
    @istest
    public static void method2()        
    {
          try{
        genesis__Applications__c app=[select id from genesis__Applications__c limit 1];
         Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		test.startTest();
        WS_SMS_OTP_HL.validateOTP('100','1',app.id);
        test.stopTest();
          }
        catch(Exception e)
        {
            system.debug('Exception:---'+e);
        }
    }
}