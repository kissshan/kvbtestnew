/*
* Name    		: VL_DigioTemplateService_Test
* Company  		: ET Marlabs
* Purpose   	: VL_DigioTemplateService && WS_eStampDocGen test class
* Author  		: Braj Mohan
* Created Date 	: 21-09-2018
*/

@isTest
public class VL_DigioTemplateService_Test {

	@testSetup 
	static void setup(){
		//initial test setup
		List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);

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
	static void testVLDigioTemplateForVL2W() {
		List<genesis__Applications__c> appLst = [Select Id from genesis__Applications__c where Record_Type_Name__c = 'VL2W'];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);
		appln.genesis__Interest_Rate__c = null;
		appln.Sanctioned_EMI__c =null;
		update appln;
		System.debug('#####testVLDigioTemplateForVL2W()-appln=='+ appln);

		Test.startTest();
			VL_DigioTemplateService.getVLSanctionLetter(appln.Id,'VL_Sanction_Letter_v.5');
			VL_DigioTemplateService.VlDealerPaymentLetter(appln.Id,'VL_PaymentAuth_v.3');
			VL_DigioTemplateService.VlPaymentAcknowledgementLetter(appln.Id,'VL_PaymentAck_v.1');
			VL_DigioTemplateService.VL_HypothecationDoc(appln.Id,'VL_Hypothecation_v.6');
            VL_DigioTemplateService.VlCoveringLetter(appln.Id,'VL_Covering_v.2');
			WS_eStampDocGen.createDoc(appln,Constants.VLHYPOTHECATIONLD,'Bearer 456','MAHARASHTRA');
		Test.stopTest();
	}
	
	@isTest 
	static void testVLDigioTemplateForVL4W() {
		List<genesis__Applications__c> appLst = [Select Id from genesis__Applications__c where Record_Type_Name__c = 'VL4W'];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);
		System.debug('testVLDigioTemplateForVL2W()-appln**'+appln);

		Test.startTest();
			VL_DigioTemplateService.getVLSanctionLetter(appln.Id,'VL_Sanction_Letter_v.5');
			VL_DigioTemplateService.VlDealerPaymentLetter(appln.Id,'VL_PaymentAuth_v.3');
			VL_DigioTemplateService.VlPaymentAcknowledgementLetter(appln.Id,'VL_PaymentAck_v.1');
			VL_DigioTemplateService.VL_HypothecationDoc(appln.Id,'VL_Hypothecation_v.6');
            VL_DigioTemplateService.VlCoveringLetter(appln.Id,'VL_Covering_v.2');
			WS_eStampDocGen.createDoc(appln,Constants.VLHYPOTHECATIONLD,'Bearer 456','MAHARASHTRA');
		Test.stopTest();
	}

	@isTest 
	static void testVLDigioTemplateNegative() {
		String appId = 'qwerty12345';
		System.debug('testVLDigioTemplateNegative()-appId=='+appId);
		//genesis__Applications__c appln = new genesis__Applications__c(Id=appId);
		Test.startTest();
			VL_DigioTemplateService.getVLSanctionLetter(appId,'VL_Sanction_Letter_v.5');
			VL_DigioTemplateService.VlDealerPaymentLetter(appId,'VL_PaymentAuth_v.3');
			VL_DigioTemplateService.VlPaymentAcknowledgementLetter(appId,'VL_PaymentAck_v.1');
			VL_DigioTemplateService.VL_HypothecationDoc(appId,'VL_Hypothecation_v.6');
            VL_DigioTemplateService.VlCoveringLetter(appId,'VL_Covering_v.2');
			//WS_eStampDocGen.createDoc(appln,Constants.VLHYPOTHECATIONLD,'Bearer 456','MAHARASHTRA');
		Test.stopTest();
	}

}