/*
* Description : Probe42_Response_Handler_Test
* Author       : Vignesh
*/



@isTest
private class Probe42_Response_Handler_Test {
	
	@isTest static void test_method_one() {
		Probe42_Response_Structure ProbRes= new Probe42_Response_Structure();


		Probe42_Response_Structure.Liabilities liab= new Probe42_Response_Structure.Liabilities();
		liab.trade_payables= '3232545432';
		liab.deferred_tax_liabilities_net= '3232545432';
		liab.foreign_curr_monetary_item_trans_diff_liability_account= '3232545432';
		liab.long_term_borrowings= '3232545432';
		liab.other_long_term_liabilities= '3232545432';
		liab.minority_interest= '3232545432';
		liab.long_term_provisions= '3232545432';
		liab.deferred_government_grants= '3232545432';
		liab.short_term_borrowings= '3232545432';
		liab.share_application_money_pending_allotment= '3232545432';
		liab.other_current_liabilities= '3232545432';
		liab.money_received_against_share_warrants= '3232545432';
		liab.short_term_provisions= '3232545432';
		liab.reserves_and_surplus= '3232545432';
		liab.given_liabilities_total= '3232545432';
		liab.share_capital= '3232545432';

		Probe42_Response_Structure.SubTotals subTl= new Probe42_Response_Structure.SubTotals();
		subTl.total_current_assets= '3131';
		subTl.net_fixed_assets= '3131';
		subTl.total_debt= '3131';
		subTl.total_current_liabilities= '3131';
		subTl.total_operating_cost= '3131';
		subTl.total_equity= '3131';

		Probe42_Response_Structure.Assets asst= new Probe42_Response_Structure.Assets();
		asst.given_assets_total='1234';
		asst.foreign_curr_monetary_item_trans_diff_asset_account='1234';
		asst.long_term_loans_and_advances='1234';
		asst.deferred_tax_assets_net='1234';
		asst.other_noncurrent_assets='1234';
		asst.noncurrent_investments='1234';
		asst.current_investments='1234';
		asst.intangible_assets_under_development='1234';
		asst.inventories='1234';
		asst.tangible_assets_capital_work_in_progress='1234';
		asst.trade_receivables='1234';
		asst.preproducing_properties='1234';
		asst.cash_and_bank_balances='1234';
		asst.intangible_assets='1234';
		asst.short_term_loans_and_advances='1234';
		asst.producing_properties='1234';
		asst.other_current_assets='1234';
		asst.tangible_assets='1234';

		Probe42_Response_Structure.bs bsObj= new Probe42_Response_Structure.bs();
		bsObj.liabilities= liab;
		bsObj.subTotals=subTl;
		bsObj.assets= asst;

		Probe42_Response_Structure.LineItems lnitm= new Probe42_Response_Structure.LineItems();
		
		lnitm.interest= '12345';
		lnitm.profit_before_interest_and_tax= '12345';
		lnitm.profit_before_tax_and_exceptional_items_before_tax= '12345';
		lnitm.depreciation= '12345';
		lnitm.exceptional_items_before_tax= '12345';
		lnitm.operating_profit= '12345';
		lnitm.profit_before_tax= '12345';
		lnitm.total_other_expenses= '12345';
		lnitm.income_tax= '12345';
		lnitm.total_employee_benefit_expense= '12345';
		lnitm.profit_for_period_from_continuing_operations= '12345';
		lnitm.total_changes_in_inventories_or_finished_goods= '12345';
		lnitm.profit_from_discontinuing_operation_after_tax= '12345';
		lnitm.total_purchases_of_stock_in_trade= '12345';
		lnitm.minority_interest_and_profit_from_associates_and_joint_ventures= '12345';
		lnitm.total_cost_of_materials_consumed= '12345';
		lnitm.profit_after_tax= '12345';
		lnitm.net_revenue= '12345';

		Probe42_Response_Structure.Pnl pl= new Probe42_Response_Structure.Pnl();
		pl.lineItems= lnitm;
		pl.subTotals=subTl;

		Probe42_Response_Structure.Detailed_financials dtlFin= new Probe42_Response_Structure.Detailed_financials();
		dtlFin.filing_standard= 'filing_standard';
		dtlFin.stated_on= 'stated_on';
		dtlFin.nature='standalone';  // else condition
		dtlFin.year= '2017-18';
		dtlFin.bs= bsObj;
		dtlFin.pnl= pl;
		List<Probe42_Response_Structure.Detailed_financials > dtlFinLst= new List<Probe42_Response_Structure.Detailed_financials > ();
		dtlFinLst.add(dtlFin);

		Probe42_Response_Structure.Data dt= new Probe42_Response_Structure.Data();
		dt.detailed_financials= dtlFinLst;

		Probe42_Response_Structure.Metadata mtData= new Probe42_Response_Structure.Metadata();
		mtData.last_updated= '20-12-2017';
		mtData.api_version= '3.2';

		ProbRes.data= dt;
		ProbRes.metadata= mtData;

		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId 		= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.Aadhaar_Number__c	=  '1234567689900';
        acc.Pan_Number__c		=	'BXCV12PIL';
        acc.BillingStreet		=  '30 A T.Nagar';
        acc.BillingCity			=  'Chennai';
        acc.BillingState		=  'Tamil Nadu';
        acc.BillingPostalCode	=  '560029';
        acc.Constitution__c		=  'Private Limited';
        acc.Line_of_Activity__c	=  'Retail Trade';
        acc.RecordTypeId		=	devRecordTypeId;
        acc.CBS_Customer_ID__c= '1234678';
        insert acc;
        genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();       
        app.Active__c		= true;
        app.RecordTypeId	=  RecordTypeIdApp;
        insert app;

		Test.startTest();
		Probe42_Response_Handler.getProbe42Data(ProbRes,acc.Id,app.Id,acc.CBS_Customer_ID__c);
		Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}