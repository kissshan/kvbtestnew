/*
* Description : to cover test code for CRILC_API_Response_Handler class
* Author       : Vignesh
*
*/

@isTest
private class CRILC_API_Response_Handler_Test {

	
	@isTest static void test_method_one() {
		Test.startTest();
			CRILC_API_Response criRes= new CRILC_API_Response();

			List<CRILC_API_Response.ReportingLenders> reprtLdrLst= new List<CRILC_API_Response.ReportingLenders>();
			CRILC_API_Response.ReportingLenders reprtLdr= new CRILC_API_Response.ReportingLenders();
			reprtLdr.reportingDate= 'reportingDate';
			reprtLdr.reportingLenders= 'Lader1';
			reprtLdr.status= 'Completed';
			reprtLdrLst.add(reprtLdr);
			system.debug(reprtLdrLst);

			List<CRILC_API_Response.RepaymentHistory> payHstryLst= new List<CRILC_API_Response.RepaymentHistory>();
			CRILC_API_Response.RepaymentHistory payHstry= new CRILC_API_Response.RepaymentHistory();
			payHstry.borrowerClassifiedAsSMA2= 'SMA2';
			payHstry.reportingLenderName= 'Lader2';
			payHstryLst.add(payHstry);

			List<CRILC_API_Response.AssetClassificationOfBorrower> assetBrowLst= new List<CRILC_API_Response.AssetClassificationOfBorrower>();
			CRILC_API_Response.AssetClassificationOfBorrower assetBrow= new CRILC_API_Response.AssetClassificationOfBorrower();
			assetBrow.referenceDateOfCrilcMain= 'main';
			assetBrow.nameOfReportingBank= 'ICICI';
			assetBrow.smaClassification= 'Standard';
			CRILC_API_Response.AssetClassificationOfBorrower assetBrow1= new CRILC_API_Response.AssetClassificationOfBorrower();
			assetBrow1.smaClassification= 'SMA-0';
			CRILC_API_Response.AssetClassificationOfBorrower assetBrow2= new CRILC_API_Response.AssetClassificationOfBorrower();
			assetBrow2.smaClassification= 'SMA-1';
			CRILC_API_Response.AssetClassificationOfBorrower assetBrow3= new CRILC_API_Response.AssetClassificationOfBorrower();
			assetBrow3.smaClassification= 'SMA-2';

			CRILC_API_Response.AssetClassificationOfBorrower assetBrow4= new CRILC_API_Response.AssetClassificationOfBorrower();
			assetBrow4.smaClassification= 'Non-CDR Standard Restructured';
			assetBrowLst.add(assetBrow);
			assetBrowLst.add(assetBrow1);
			assetBrowLst.add(assetBrow2);
			assetBrowLst.add(assetBrow3);
			assetBrowLst.add(assetBrow4);
			

			CRILC_API_Response.statusOfClassificationOfBorrower stsBrow= new CRILC_API_Response.statusOfClassificationOfBorrower();
			stsBrow.borrowerName= 'Ganesh';
			stsBrow.reportingLenders= reprtLdrLst;
			stsBrow.repaymentHistory=payHstryLst;
			stsBrow.assetClassificationOfBorrower= assetBrowLst;

			criRes.statusOfClassificationOfBorrower= stsBrow;


			Account acc = new Account(firstName='Venu',LastName='Gopal', Employment_Type__c = 'Salaried');
        	insert acc;

			CRILC_API_Response_Handler.getCRILC_API_Response(criRes,acc.Id);
		Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}