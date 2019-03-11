/*
* Description : Perfios_New_SME_Response_Handler_Test
* Author   : Vignesh
*/

@isTest
private class Perfios_New_SME_Response_Test {
	
	@isTest static void test_method_one() {
		String Json= '{'+
					 '"customerInfo":{'+
					 '"name":"vignesh"'+
					 '}'+
					 '}';
		Perfios_New_SME_Response.parse(Json);
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}