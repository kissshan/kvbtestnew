/*
* Name    		: HL_DigioTemplateService_Test
* Company  		: ET Marlabs
* Purpose   	: Test class for HL_DigioTemplateService
* Author  		: Braj Mohan
* Created Date 	: 21-09-2018
*/
//modified by prashant singh---on 03/11/2018
//class name:-- HL_DigioTemplateService
//code coverage---  88% 


@isTest
private class HL_DigioTemplateService_Test{

	@testSetup 
	static void setup(){
	    
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
            Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
        genApp.RecordTypeId = genAppRecordType;
        genApp.genesis__Interest_Rate__c=12;
        genApp.Sanctioned_EMI__c=12.90;
        genApp.genesis__Disbursement_Date__c=date.parse('05/12/2018');
            genApp.Sanctioned_Tenure__c=230;
            insert genApp;
            for(integer i=0;i<4;i++)
            {
            genesis__Application_Parties__c genPar = new genesis__Application_Parties__c();
        genPar.genesis__Party_Account_Name__c = acc.Id;
        genPar.Key_Contact__c = acc.Id;
        genPar.genesis__Application__c = genApp.Id;
        genPar.genesis__Party_Type__c = Constants.Co_Borrower;
        genPar.Active__c=true;
        genPar.Company__c=false;
        genPar.Title_Holder__c=true;
        INSERT genPar;
           }
           for(integer i=0;i<10;i++)
            {
            genesis__Application_Parties__c genPar = new genesis__Application_Parties__c();
        genPar.genesis__Party_Account_Name__c = acc.Id;
        genPar.Key_Contact__c = acc.Id;
        genPar.genesis__Application__c = genApp.Id;
        genPar.genesis__Party_Type__c = Constants.Gurantor;
        genPar.Active__c=true;
        genPar.Company__c=false;
        genPar.Title_Holder__c=true;
        INSERT genPar;
           }
     
           for(integer i=0;i<10;i++)
           {
 clcommon__Collateral__c cc=new clcommon__Collateral__c();
        cc.Advances_Paid__c=100;
        cc.Branch_Name__c='san';
        cc.Dealer_name__c='test';
        cc.Dealer_Email__c='cc@gmail.com';
        cc.genesis__Application__c=genApp.Id;
        cc.clcommon__Manufacturer__c='ooie';
        cc.clcommon__Model__c='iwej';
        cc.Variant__c='jsdj';
        cc.clcommon__Collateral_Name__c='test123';
             cc.Collateral_Type__c='Vehicles';
        insert cc;
               
               Ownership__c ownr= SME_TestUtil.createOwnership(cc.Id,acc.Id);
        insert ownr;
           }
           for(integer i=0;i<20;i++)
           {
         MOD_Documents__c modobj=new MOD_Documents__c();
        modobj.DOcNo__c='2829';
        modobj.Document_Upload_Type__c='Copy';
        modobj.Application__c=genApp.id;
        insert modobj;
           }
        
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
	static void testHL_DigioTemplateServiceForHL() {
        
		List<genesis__Applications__c> appLst = [Select Id,Name,genesis__Account__c from genesis__Applications__c];
        list<clcommon__Collateral__c> col=[SELECT id,Name,SurveyKhasraKhataPatta_No__c,Collateral_Type__c,EM_Charge_type__c,Nature_of_Property__c,PlotDoorShopBungalow_No__c,Buildup_Area__c,ExtentCarpet_area_Built_up_area__c,Floor_No__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,State__c,Property_Pincode__c,Total_Market_value__c,clcommon__City__c,clcommon__Postal_Code__c,Building_Name__c,Valuation_Date__c FROM clcommon__Collateral__c limit 7]; 
		genesis__Applications__c appln = new genesis__Applications__c();
		appln.Id = appLst[0].id;
		appln.genesis__Margin__c = 10;
		appln.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();
		update appln;
		System.debug('#####testHL_DigioTemplateServiceForHL()-appln=='+ appln);

		Test.startTest();
			HL_DigioTemplateService.getHLSanctionLetter(appln.Id,'VL_Sanction_Letter_v.6');
			HL_DigioTemplateService.getHLAcknowledgeSanctionC1(appln.Id,'VL_PaymentAck_v.1');
			HL_DigioTemplateService.getPLSanctionLetter(appln.Id,'VL_Hypothecation_v.6');
			HL_DigioTemplateService.plLoanAgreement(appln.Id,'VL_Hypothecation_v.6');
			HL_DigioTemplateService.C1SanctionAcknowledgementforLAP(appln.Id,'VL_Hypothecation_v.6');
			HL_DigioTemplateService.A23D_LAFADocForLap(appln.Id,'LAP_A23_V11');
        HL_DigioTemplateService.A46AgreementDocForLap(appln.Id,'LAP_A46_V9');
        
          LAP_Digio_Service_B1.collValue=col[0];
                  LAP_Digio_Service_B1.collValue=col[1];

        HL_DigioTemplateService.B1_DigioDocForLap(appln.Id,'LAP_B1_V11');
        
        HL_DigioTemplateService.getHL_Digio_Manual_A23(appln.Id,'HL_Digio_Manual_A23_v.2');
        HL_DigioTemplateService.getHL_Digio_Manual_A46(appln.Id,'HL_Digio_Manual_A46_v.2');
        HL_DigioTemplateService.getHL_Digio_Manual_B17(appln.Id,'HL_Digio_Manual_B17_v.2');
        HL_DigioTemplateService.getHL_Digio_Manual_B1B2(appln.Id,'HL_Digio_Manual_B1B2_v.10	');




        
        

        
		Test.stopTest();
	}

	

}