@isTest
public class Test_EthicsResponse {
static testMethod void testParse() {
		String json=		'{'+
		'   "bpms_error_code": "00"'+
		
		'}';
		 EthicsResponse.parse(json);
		
	} 
}