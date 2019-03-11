public class WS_SMECustomerListFetchCallOutMock implements HttpCalloutMock {
	public HTTPResponse respond(HttpRequest req){
		HttpResponse res 	= new HttpResponse();
		res.setHeader('Content-Type','application/json');
		res.setBody('{"CUSTOMER_ID":"10009"}');
		res.setStatusCode(200);
		return res;
	}
    
}