/*
* Name    	: VL_Digio_Services_Test
* Company  	: ET Marlabs
* Purpose   : VL_Digio_Services test class
* Author  	: Braj 
*/
//modified by prashant singh----
//date:-03/11/2018
//code coverage--80%
@isTest
public class VL_Digio_Services_Test
{
	@testSetup 
	static void setup(){
		//initial test setup
		List<genesis__Applications__c> appLst=VL_Test_Utility.intialSetUp(true,true);

		//Insert DIGIO Templates
		List<DIGIO_Templates__c> digioTemplateLst = VL_Test_Utility.createDigioTemplate();
		Insert digioTemplateLst;

		//Insert KVB Company Details
		//KVB_Company_Details__c kvbCompanyDetails = VL_Test_Utility.createKVBCompanyDetails();
		//Insert kvbCompanyDetails;

		//Insert KVB Company Details
		//List<KVB_Endpoint_URLs__c> kvbEndpointLst = VL_Test_Utility.createKVBEndpointURLs();
		//Insert kvbEndpointLst;
		  KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb;
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'DocGeneration';
        KVB1.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/CreateDocTemplate1';
        KVB1.Username__c='prashant';
     	insert kvb1;
        KVB_Endpoint_URLs__c kvb2 = new KVB_Endpoint_URLs__c();
     	KVB2.Name = 'Apigee_Access_Token';
        KVB2.Endpoint_URL__c = 'https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken';
        KVB2.Username__c='prashant';
     	insert KVB2;
        KVB_Endpoint_URLs__c kvb3 = new KVB_Endpoint_URLs__c();
     	KVB3.Name = 'eStamp_url_test';
        KVB3.Endpoint_URL__c = 'https://kvb-test.apigee.net/next/v1/estamp';
        KVB3.Username__c='prashant';
     	insert KVB3;
        KVB_Endpoint_URLs__c kvb4 = new KVB_Endpoint_URLs__c();
     	KVB4.Name = 'DigioESign';
        KVB4.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/DocumentUploadPdf';
        KVB4.Username__c='prashant';
     	insert KVB4;
         Branch_Master__c brmstr=new Branch_Master__c();
        brmstr.CODCCBRN__c='1857';
        brmstr.State__c='kanpur';
        insert brmstr;

	}
	
	@isTest 
	static void testVLDigioServicesForVL2W() {
		List<genesis__Applications__c> appLst = [Select Id from genesis__Applications__c where Record_Type_Name__c = 'VL2W'];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);
		System.debug('testVLDigioTemplateForVL2W()-appln**'+appln);
        
         genesis__Application_Document_Category__c appdoccat=new genesis__Application_Document_Category__c();
        appdoccat.genesis__Application__c=appln.Id;
            appdoccat.name=Constants.LoanDocuments;
            insert appdoccat;

		Test.startTest();
			Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        //appln.Document_Generation__c=Constants.VL2_DOCGEN;
           appln.Document_Generation__c=Constants.VL1_DOCGEN;
        update appln;
			VL_Digio_Services.docGenAndSignDocVL(appln.Id,Constants.VLSANCTIONLETTER);
			VL_Digio_Services.docGenAndSignDocVL(appln.Id,Constants.VLDEALERACK);  

        
		Test.stopTest();
	}
    @isTest 
	static void testVLDigioServicesForVL2W_1() {
		List<genesis__Applications__c> appLst = [Select Id from genesis__Applications__c where Record_Type_Name__c = 'VL2W'];
		genesis__Applications__c appln = new genesis__Applications__c();
		appln = queryService.getApplication(appLst[0].Id);
		System.debug('testVLDigioTemplateForVL2W()-appln**'+appln);

		Test.startTest();
			Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        //appln.Document_Generation__c=Constants.VL2_DOCGEN;
           appln.Document_Generation__c=Constants.VL1_DOCGEN+';'+Constants.VL2_DOCGEN;
        appln.Branch_Code__c='1857';
        update appln;
			VL_Digio_Services.docGenAndSignDocVL(appln.Id,Constants.VLSANCTIONLETTER);
			VL_Digio_Services.docGenAndSignDocVL(appln.Id,Constants.VLDEALERACK);  
                appln.Document_Generation__c=Constants.VL1_DOCGEN+';'+Constants.VL2_DOCGEN;       
		Test.stopTest();
	}
    //non-legal desk
    @isTest 
	static void testVLDigioServicesForVL2W_2() {
        
        List<genesis__Applications__c> appLst = [Select Id from genesis__Applications__c where Record_Type_Name__c = 'VL2W'];
		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp = queryService.getApplication(appLst[0].Id);
		//System.debug('testVLDigioTemplateForVL2W()-appln**'+appln);
        
        //genesis__Applications__c genApp=[select id,Legal_desk_state_flag__c from genesis__Applications__c limit 1];
		genApp.Legal_desk_state_flag__c=false;
            update genApp;
		Test.startTest(); 
			Test.setMock(HttpCalloutMock.class, new MockHttpResponse());        
                   genApp.Document_Generation__c=Constants.VL1_DOCGEN;
        update genApp;
        VL_Digio_Services.docGenAndSignDocVL(genApp.Id,Constants.VLSANCTIONLETTER);
			VL_Digio_Services.docGenAndSignDocVL(genApp.Id,Constants.VLDEALERACK);         
        
		Test.stopTest();
	}
     @isTest 
	static void testVLDigioServicesForVL2W_3() {
        
        List<genesis__Applications__c> appLst = [Select Id from genesis__Applications__c where Record_Type_Name__c = 'VL2W'];
		genesis__Applications__c genApp = new genesis__Applications__c();
		genApp = queryService.getApplication(appLst[0].Id);
		//System.debug('testVLDigioTemplateForVL2W()-appln**'+appln);
        
        //genesis__Applications__c genApp=[select id,Legal_desk_state_flag__c from genesis__Applications__c limit 1];
		genApp.Legal_desk_state_flag__c=false;
            update genApp;
		Test.startTest(); 
			Test.setMock(HttpCalloutMock.class, new MockHttpResponse());        
           genApp.Document_Generation__c=Constants.VL1_DOCGEN+';'+Constants.VL2_DOCGEN;
        update genApp;
        VL_Digio_Services.docGenAndSignDocVL(genApp.Id,Constants.VLSANCTIONLETTER);
			VL_Digio_Services.docGenAndSignDocVL(genApp.Id,Constants.VLDEALERACK);         
        
		Test.stopTest();
	}
/*
	@isTest 
	static void testVLDigioServicesForVL4W() {
		List<genesis__Applications__c> appLst = [Select Id,Name from genesis__Applications__c where Record_Type_Name__c = 'VL4W'];
		System.debug(appLst.size()+'<--appLst**'+appLst);

		Test.startTest();
		if (appLst.size()>0) {
			VL_Digio_Services.docGenAndSignDocVL(appLst[0].Id,Constants.VLSANCTIONLETTER);
		}
		Test.stopTest();
	}

	@isTest 
	static void testVLDigioServicesNegative() {
		String appId = 'qwerty123456';

		Test.startTest();
			VL_Digio_Services.docGenAndSignDocVL(appId,Constants.VLSANCTIONLETTER);
		Test.stopTest();
	}*/
}