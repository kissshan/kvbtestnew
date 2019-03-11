/*
* Name    			: DigioTemplateServiceTest
* Company  			: ET Marlabs
* Purpose   		: Test Class for DigioTemplateService Class
* Author  			: SOUVIK BANIK
* last Modified By 	: SOUVIK BANIK on 31-07-2018
*/

@isTest
public class DigioTemplateServiceTest {
	
	@isTest
	public static void createTestData(){

		Account acc = SME_TestUtil.createAccount('Test','1857','7796660','TESTD','test','KVB');
		acc.Constitution__c = 'LLP';
		acc.Priority_Sector__c = true;
		INSERT acc;

		genesis__Applications__c appln = SME_TestUtil.createApplication('1857',acc.Id,'Adhoc- Application created','MOD Pending','AdhocView');
		appln.Renewal_Due_Date__c = Date.newInstance(2018, 12, 9);
		appln.Sanction_Date__c = Date.newInstance(2018, 07, 20);
		appln.EAE_Renewal_Date_in_days__c = 155;
		appln.Sanction_Authority__c = 'BR_MGR';
		INSERT appln;

		clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('SOD REAL ESTATE','280','Funded');
		clProd.Facility_Category__c = 'SOD';
		INSERT clProd;

		clcommon__CL_Product__c nonFundedClProd = SME_TestUtil.createclproduct('SOD REAL ESTATE','280','Non-Funded');
		nonFundedClProd.Facility_Category__c = 'SOD';
		INSERT nonFundedClProd;

		Facility__c facility = SME_TestUtil.createFacility(appln.Id,clProd.Id,'2207280000000160',2491918.13);
		facility.Loan_Purpose__c = 'To meet working capital requirement';
		facility.Recommended_Processing_Charge__c = 11.01;
		facility.Recommended_Limit__c = 8200000.00;
		facility.Existing_Rate__c = 12.00;
		facility.Recommended_Rate__c = 11.85;
		facility.MCLR_Rate__c = 5.00;
		facility.Existing_Limit__c = 5200000.00;
        facility.Existing_Spread__c = 30;
		INSERT facility;

		Facility__c nonFundedFac = SME_TestUtil.createFacility(appln.Id,nonFundedClProd.Id,'2207280000000160',2491918.13);
		nonFundedFac.Loan_Purpose__c = 'To meet working capital requirement';
		nonFundedFac.Recommended_Processing_Charge__c = 11.01;
		nonFundedFac.Recommended_Limit__c = 8200000.00;
		nonFundedFac.Existing_Rate__c = 12.00;
		nonFundedFac.Recommended_Rate__c = 11.85;
		nonFundedFac.MCLR_Rate__c = 5.00;
		nonFundedFac.Existing_Limit__c = 5200000.00;
		INSERT nonFundedFac;

		clcommon__Collateral__c col = SME_TestUtil.createcollateral(appln.Id,'FE-0000','Fixed Deposit');
        // col.Collateral_Type__c = 'Fixed Deposit';
		INSERT col;

		clcommon__Collateral__c col2 = SME_TestUtil.createcollateral(appln.Id,'FE-0000','Insurance Policies');
		//col2.Collateral_Type__c = 'Insurance Policies';
		INSERT col2;

		clcommon__Collateral__c col3 = SME_TestUtil.createcollateral(appln.Id,'FE-0000','Vehicles');
		//col3.Collateral_Type__c = 'Vehicles';
		INSERT col3;

		clcommon__Collateral__c col4 = SME_TestUtil.createcollateral(appln.Id,'FE-0000','Machinery');
		//col4.Collateral_Type__c = 'Machinery';
		INSERT col4;

		genesis__Application_Collateral__c appCol = SME_TestUtil.createAppCollateral(acc.Id,appln.Id,facility.Id,col.Id);
		appCol.Security_Type__c = 'Collateral Securities';
		INSERT appCol;

		genesis__Application_Collateral__c appCol2 = SME_TestUtil.createAppCollateral(acc.Id,appln.Id,facility.Id,col2.Id);
		appCol2.Security_Type__c = 'Primary Securities';
		INSERT appCol2;

		genesis__Application_Collateral__c appCol3 = SME_TestUtil.createAppCollateral(acc.Id,appln.Id,facility.Id,col3.Id);
		appCol3.Security_Type__c = 'Collateral Securities';
		INSERT appCol3;

		genesis__Application_Collateral__c appCol4 = SME_TestUtil.createAppCollateral(acc.Id,appln.Id,facility.Id,col4.Id);
		appCol4.Security_Type__c = 'Collateral Securities';
		INSERT appCol4;

		genesis__Application_Parties__c party = SME_TestUtil.creategenAppParti(appln.Id,acc.Id,'Partner','Pending');
		INSERT party;

		genesis__Application_Parties__c party2 = SME_TestUtil.creategenAppParti(appln.Id,acc.Id,'Director','Pending');
		INSERT party2;

		genesis__Application_Parties__c party3 = SME_TestUtil.creategenAppParti(appln.Id,acc.Id,'Guarantor','Pending');
		INSERT party3;

		Audit__c audit = SME_TestUtil.createAudit(appln.Id,'SOD','Test',1);
		Id RecordTypeIdAudit = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get('Facility Term and Condition').getRecordTypeId();
		audit.RecordTypeId = RecordTypeIdAudit;
		INSERT audit;

		Audit__c audit2 = SME_TestUtil.createAudit(appln.Id,'SOD','Test',1);
		Id RecordTypeIdAudit2 = Schema.SObjectType.Audit__c.getRecordTypeInfosByName().get('Underwriting T&C').getRecordTypeId();
		audit2.RecordTypeId = RecordTypeIdAudit2;
		audit2.Type__c = 'Final Sanction';
		INSERT audit2;

		Ownership__c ownshp = SME_TestUtil.createOwnership(col.Id,acc.Id);
		INSERT ownshp;

		MCLR_Master__c mclrMaster = SME_TestUtil.createMCLRMaster(11.12,13.25,'CH');
		INSERT mclrMaster;

		KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c();
		kvbDetail.Penal_Interest__c = 3.00;
		kvbDetail.Commitment_charges__c = 0.25;
		INSERT kvbDetail;

		//Security_Text__mdt securitytext = [SELECT Application_Id__c,COLLATERAL_SECURITY__c,PRIMARY_SECURITY__c FROM Security_Text__mdt  WHERE Application_Id__c=: appln.Id LIMIT 1];
        
		Test.startTest();

		DigioTemplateService.getSMESanctionLetter(appln.Id,'SME_ProvisionalSanctionLetter','5qerc12kjhnb');
		/*DigioTemplateService.getSMESanctionLetter(appln.Id,'SME_SanctionLetter','5qerc12kjhnb');
		DigioTemplateService.getSMESanctionLetter(appln.Id,'SME_Sanction_Letter12','5qerc12kjhnb');
		DigioTemplateService.getSMESanctionLetter(appln.Id,'SME_Sanction_Letter13','5qerc12kjhnb');
		DigioTemplateService.getSMESanctionLetter(appln.Id,'SME_Sanction_Letter1','5qerc12kjhnb');*/

		DigioTemplateService.getLetterJSONReq(appln,new List<Facility__c>{facility},new List<genesis__Application_Parties__c>{party},'5qerc12kjhnb');

		//DigioTemplateService.getLetterJSONReq(appln,new List<Facility__c>{nonFundedFac},new List<genesis__Application_Parties__c>{party},'5qerc12kjhnb');


		DigioTemplateService.getOtherCollateralTypeDetails(appCol);
		DigioTemplateService.getOtherCollateralTypeDetails(appCol2);
		DigioTemplateService.getOtherCollateralTypeDetails(appCol3);
		DigioTemplateService.getOtherCollateralTypeDetails(appCol4);
		
		DigioTemplateService.generateMODAfidivateDoc(appln,new List<Facility__c>{facility},'5qerc12kjhnb',col.Id,'100','KARNATAKA');
		DigioTemplateService.generate_DIGITAL_GCFA_v2(appln,'5qerc12kjhnb','100','KARNATAKA','121sfsf');
		DigioTemplateService.generateGuarantorAgreement(appln,new List<Facility__c>{facility},'5qerc12kjhnb','100','KARNATAKA','121sfsf');
		DigioTemplateService.generate_A_1_Doc(appln,'5qerc12kjhnb');
		DigioTemplateService.generate_C_7_Doc(appln,'5qerc12kjhnb');
		DigioTemplateService.generate_C_8_Doc(appln,'5qerc12kjhnb');
		DigioTemplateService.generate_C_9_Doc(appln,'5qerc12kjhnb');
		DigioTemplateService.generate_Exceeding_AdHoc_SanctionLetter(appln,'5qerc12kjhnb');
		DigioTemplateService.generate_Digital_GCFA_C1_v1(appln,'5qerc12kjhnb');
		DigioTemplateService.getBranchCity('1857');
		Test.stopTest();

	}


}