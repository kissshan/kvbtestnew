/*
* Name    	: WS_RCInstaVeritasAPI_VL_Test
* Company  	: ET Marlabs
* Purpose   : WS_RCInstaVeritasAPI_VL & WS_UpdateRCInstaVeritasAPI_VL test class
* Author  	: Braj 
*/

@isTest
public class WS_RCInstaVeritasAPI_VL_Test{

	@testSetup 
	static void setup(){
		//initial test setup
		List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(false,true);

		//Insert DIGIO Templates
		List<DIGIO_Templates__c> digioTemplateLst = VL_Test_Utility.createDigioTemplate();
		Insert digioTemplateLst;

		//Insert KVB Company Details
		KVB_Company_Details__c kvbCompanyDetails = VL_Test_Utility.createKVBCompanyDetails();
		Insert kvbCompanyDetails;

		//Insert KVB Company Details
		List<KVB_Endpoint_URLs__c> kvbEndpointLst = VL_Test_Utility.createKVBEndpointURLs();
		Insert kvbEndpointLst;

	}
	
	@isTest 
	static void testGetRCfromInstaVeritas() {
		clcommon__Collateral__c coll = [Select Id,RC_No__c from clcommon__Collateral__c Limit 1];
		coll.RC_No__c = 'TN47U6007';
		update coll;

		Test.startTest();
		System.assertNotEquals(coll.Id,null);
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		WS_RCInstaVeritasAPI_VL.callVehicleRC('TN47U6007',coll.Id);
		Test.stopTest();
	}

	@isTest 
	static void InstaVeritasNegativeScenario1() {
		clcommon__Collateral__c coll = [Select Id,RC_No__c from clcommon__Collateral__c Limit 1];
		coll.RC_No__c = 'TN47U6008';
		update coll;

		Test.startTest();
		System.assertNotEquals(coll.Id,null);
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		WS_RCInstaVeritasAPI_VL.callVehicleRC('TN47U6008',coll.Id);
		Test.stopTest();
	}

	@isTest 
	static void InstaVeritasNegativeScenario2() {
		clcommon__Collateral__c coll = [Select Id,RC_No__c from clcommon__Collateral__c Limit 1];
		coll.RC_No__c = 'TN47U6009';
		update coll;

		Test.startTest();
		System.assertNotEquals(coll.Id,null);
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		WS_RCInstaVeritasAPI_VL.callVehicleRC('TN47U6009',coll.Id);
		Test.stopTest();
	}

	@isTest 
	static void NegativeTest1() {

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		WS_RCInstaVeritasAPI_VL.callVehicleRC('TN47U6009','qwer76543');
		Test.stopTest();
	}

	@isTest 
	static void NegativeTest2() {

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		WS_RCInstaVeritasAPI_VL.callVehicleRC('TN47U6007','qwer76543');
		Test.stopTest();
	}

	@isTest 
	static void testUpdateRCDetails() {
		clcommon__Collateral__c coll = [Select Id,RC_No__c from clcommon__Collateral__c Limit 1];
		coll.RC_No__c = 'TN47U6007';
		update coll;

		String reqBody = '[{"registration_number":"TN47U6007","chassis_number":"MA3EED81SOO8XXXXX","engine_number":"F10DN47XXXXX","fuel_type":"PETROL","registration_date":"22-Mar-2010","registering_authority":"KARUR RTO","registration_state":"TAMIL NADU","vehicle_company":"MARUTI SUZUKI INDIA LTD","vehicle_model":"WAGON R VXI SBIII","vehicle_type":"MOTOR CAR (L)","vehicle_age":"8 Years & 6 Months old","owners_name":"S.MANIVANNAN","fitness_upto":"21-Mar-2025","fuel_norms":"NOT AVAILABLE","insurance_upto":"02-Feb-2019","expiry_date":"NA","fitness_certificate_expiry_date":"21-Mar-2025","owner_serial_number":"1","financing_authority":"THE KARUR VYSYA BANK LTD","blacklisted":false,"blacklisted_reason":"","mv_tax_paid_upto":"NA","mv_tax_structure":"LifeTime"}]';

		RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = 'services/apexrest/UpdateVLRCInstaVeritasAPI'; 
        req.httpMethod  = 'POST';
        req.requestBody = Blob.valueOf(reqBody);
        RestContext.request = req;
        RestContext.response = res;

		Test.startTest();
			WS_UpdateRCInstaVeritasAPI_VL.getVehicleRCDetails();
		Test.stopTest();
	}

	@isTest 
	static void testUpdateRCDetailsNegative() {

		String reqBody = 'sdfghwertyu12345';
		RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = 'services/apexrest/UpdateVLRCInstaVeritasAPI'; 
        req.httpMethod  = 'POST';
        req.requestBody = Blob.valueOf(reqBody);
        RestContext.request = req;
        RestContext.response = res;

		Test.startTest();
			WS_UpdateRCInstaVeritasAPI_VL.getVehicleRCDetails();
		Test.stopTest();
	}

	@isTest 
	static void testUpdateRCDetailsNegative2() {

		RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = 'services/apexrest/UpdateVLRCInstaVeritasAPI'; 
        req.httpMethod  = 'POST';
        req.requestBody = null;
        RestContext.request = req;
        RestContext.response = res;

		Test.startTest();
			WS_UpdateRCInstaVeritasAPI_VL.getVehicleRCDetails();
		Test.stopTest();
	}

	@isTest 
	static void testUpdateRCDetailsNegative3() {

		String reqBody = '[{"registration_number":"null"}]';
		RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
        
        req.requestURI = 'services/apexrest/UpdateVLRCInstaVeritasAPI'; 
        req.httpMethod  = 'POST';
        req.requestBody = Blob.valueOf(reqBody);
        RestContext.request = req;
        RestContext.response = res;

		Test.startTest();
			WS_UpdateRCInstaVeritasAPI_VL.getVehicleRCDetails();
		Test.stopTest();
	}

	@isTest 
	static void testUpdateRCDetailsNegative4() {
		
    	String reqBody = '[{"registration_number":"TN47U6007","chassis_number":"MA3EED81SOO8XXXXX","engine_number":"F10DN47XXXXX","fuel_type":"PETROL","registration_date":"22-Mar-2010","registering_authority":"KARUR RTO","registration_state":"TAMIL NADU","vehicle_company":"MARUTI SUZUKI INDIA LTD","vehicle_model":"WAGON R VXI SBIII","vehicle_type":"MOTOR CAR (L)","vehicle_age":"8 Years & 6 Months old","owners_name":"S.MANIVANNAN","fitness_upto":"21-Mar-2025","fuel_norms":"NOT AVAILABLE","insurance_upto":"02-Feb-2019","expiry_date":"NA","fitness_certificate_expiry_date":"21-Mar-2025","owner_serial_number":"1","financing_authority":"THE KARUR VYSYA BANK LTD","blacklisted":false,"blacklisted_reason":"","mv_tax_paid_upto":"NA","mv_tax_structure":"LifeTime"}]';
        List<VL_RC_Response> res = VL_RC_Response.parse(reqBody);

		Test.startTest();
			WS_RCInstaVeritasAPI_VL.createVL_RC(res,'qwerty123456');
		Test.stopTest();
	}
}