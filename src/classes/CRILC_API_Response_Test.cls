/*
* Description : CRILC_API_Response_Test
* Author   : Vignesh
*/
@isTest
private class CRILC_API_Response_Test {
	
	@isTest static void test_method_one() {
		String json=	
            '{'+
            
            '"customerId":"Test23" '+
            '}';
        CRILC_API_Response.parse(json);
	}
	
	@isTest static void test_method_two() {
		CRILC_API_Response criRes= new CRILC_API_Response();
		CRILC_API_Response.BanksExposureToBorrower bnkBro= new CRILC_API_Response.BanksExposureToBorrower();
		CRILC_API_Response.StatusOfClassificationOfBorrower stsBor= new CRILC_API_Response.StatusOfClassificationOfBorrower();
	}
	
}