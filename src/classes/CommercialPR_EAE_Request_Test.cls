/*
* Description : CommercialPR_EAE_Request
* Author    : Vignesh
*/
@isTest
private class CommercialPR_EAE_Request_Test {
	
	@isTest static void test_method_one() {
		String json=	
            '{'+
            
            '"applicationData":{ '+
            '"ConsumerCIR":"1234"'+
            '}'+
            '}';
        CommercialPR_EAE_Request.parse(json);
	}
	
	@isTest static void test_method_two() {
		CommercialPR_EAE_Request eaeReq= new CommercialPR_EAE_Request();
		CommercialPR_EAE_Request.ApplicationData appData= new CommercialPR_EAE_Request.ApplicationData ();
		CommercialPR_EAE_Request.ApplicantsData apliData= new CommercialPR_EAE_Request.ApplicantsData();
	}
	
}