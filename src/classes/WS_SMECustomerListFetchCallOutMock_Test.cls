//uday---->100%
@isTest
public class WS_SMECustomerListFetchCallOutMock_Test {
   @isTest
    public static void testMethod1(){
        HttpRequest req=new HttpRequest();
        WS_SMECustomerListFetchCallOutMock wsm=new WS_SMECustomerListFetchCallOutMock();
        wsm.respond(req);
    }
}