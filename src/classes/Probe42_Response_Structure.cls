/*
 * Name		: Probe42_Response_Structure
 * Company	: ET Marlabs
 * Purpose 	: Sync Probe42 data into Los System. 
 * Author	: Raushan
*/
public class Probe42_Response_Structure {
    
    public Data data;
	public Metadata metadata;
	
    public class SubTotals{
		public String total_current_assets;
		public String capital_wip;
		public String net_fixed_assets;
		public String total_debt;
		public String total_current_liabilities;
		public String total_operating_cost;
		public String total_equity;
	}
	public class Pnl{
		public LineItems lineItems;
		public SubTotals subTotals;
	}
	public class Metadata{
		public String last_updated;
		public String api_version;
	}
	public class LineItems{
		public String other_income;
		public String interest;
		public String profit_before_interest_and_tax;
		public String profit_before_tax_and_exceptional_items_before_tax;
		public String depreciation;
		public String exceptional_items_before_tax;
		public String operating_profit;
		public String profit_before_tax;
		public String total_other_expenses;
		public String income_tax;
		public String total_employee_benefit_expense;
		public String profit_for_period_from_continuing_operations;
		public String total_changes_in_inventories_or_finished_goods;
		public String profit_from_discontinuing_operation_after_tax;
		public String total_purchases_of_stock_in_trade;
		public String minority_interest_and_profit_from_associates_and_joint_ventures;
		public String total_cost_of_materials_consumed;
		public String profit_after_tax;
		public String net_revenue;
	}
	public class Liabilities{
		public String trade_payables;
		public String deferred_tax_liabilities_net;
		public String foreign_curr_monetary_item_trans_diff_liability_account;
		public String long_term_borrowings;
		public String other_long_term_liabilities;
		public String minority_interest;
		public String long_term_provisions;
		public String deferred_government_grants;
		public String short_term_borrowings;
		public String share_application_money_pending_allotment;
		public String other_current_liabilities;
		public String money_received_against_share_warrants;
		public String short_term_provisions;
		public String reserves_and_surplus;
		public String given_liabilities_total;
		public String share_capital;
	}
	public class Detailed_financials{
		public String filing_standard;
		public Bs bs;
		public String stated_on;
		public Pnl pnl;
		public String nature;
		public String year;
	}
	public class Data{
		public list<Detailed_financials> detailed_financials;
	}
	public class Bs{
		public Liabilities liabilities;
		public SubTotals subTotals;
		public Assets assets;
	}
	public class Assets{
		public String given_assets_total;
		public String foreign_curr_monetary_item_trans_diff_asset_account;
		public String long_term_loans_and_advances;
		public String deferred_tax_assets_net;
		public String other_noncurrent_assets;
		public String noncurrent_investments;
		public String current_investments;
		public String intangible_assets_under_development;
		public String inventories;
		public String tangible_assets_capital_work_in_progress;
		public String trade_receivables;
		public String preproducing_properties;
		public String cash_and_bank_balances;
		public String intangible_assets;
		public String short_term_loans_and_advances;
		public String producing_properties;
		public String other_current_assets;
		public String tangible_assets;
	}
	public static Probe42_Response_Structure parse(String json) {
		return (Probe42_Response_Structure) System.JSON.deserialize(json, Probe42_Response_Structure.class);
	}
}