@isTest(SeeAllData = true)
public class Test_Msater_Sync{
    @isTest
    public static void testMethod1(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_BRANCH_MASTER.masterRequest();
        Test.stopTest();
    }
    @isTest
    public static void testMethod2(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CITY_Master.masterRequest();
    }
    @isTest
    public static void testMethod3(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_COUNTRY_Master.masterRequest();
    }
    @isTest
    public static void testMethod4(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_DSA_MASTER.masterRequest();
    }
    @isTest
    public static void testMethod5(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_EMPLOYEE_Master.masterRequest();
    }
    @isTest
    public static void testMethod6(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_MCLR_Master.masterRequest();
    }
    @isTest
    public static void testMethod7(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_Product_Master.masterRequest();
    }
    @isTest
    public static void testMethod8(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_State_Master.masterRequest();
    }
    
}