/*
* Name    : Probe42_Response_Handler
* Company  : ET Marlabs
* Purpose   : Handler class of Probe42_Response_Structure. 
* Author  : Raushan
*/
public class Probe42_Response_Handler {
    
    //Get Probe42_Response Structure Data.
    public static void getProbe42Data(Probe42_Response_Structure probe42WrpObj,String custId,String appId,String custCbsId) {
        List < M68_Balance_Sheet_Analysis__c > listOfM68Obj = new List < M68_Balance_Sheet_Analysis__c > ();
        genesis__Applications__c    app  = new genesis__Applications__c();
        If(probe42WrpObj != null) {
            
            If(probe42WrpObj.data != null) {
                
                Probe42_Response_Structure.Data dataObj = probe42WrpObj.data;
                
                If(dataObj != null) {
                    
                    If(dataObj.detailed_financials != null) {
                        String natureStr = 'standalone'; 
                        
                        List <Probe42_Response_Structure.Detailed_financials> ListDetailedFinObj = dataObj.detailed_financials;
                        
                        If(ListDetailedFinObj != null) {
                            
                            for (Probe42_Response_Structure.Detailed_financials detailedFinObj: ListDetailedFinObj) {
                                If((detailedFinObj.nature).equalsignorecase(natureStr)){
                                    
                                    If(detailedFinObj != null) {
                                        
                                        If(detailedFinObj.year != null && detailedFinObj.year != '') {
                                            Boolean flag = Utility.getFiscalYearFlag(detailedFinObj.year);
                                            If(flag) {
                                                M68_Balance_Sheet_Analysis__c m68Obj = new M68_Balance_Sheet_Analysis__c();
                                                String fiscalStr = Utility.getFiscalYearByDate(detailedFinObj.year);
                                                m68Obj.Fiscal_Year__c = fiscalStr;
                                                m68Obj.Financial_type__c = 'Actual';
                                                m68Obj.Account__c    = custId;
                                                m68Obj.Data_Source__c = 'Probe 42';
                                                m68Obj.External_Id__c =  custCbsId+'@'+fiscalStr+'@Actual';
                                                app.Id                = appId;
                                                app.is_Probe_42__c    = true;
                                                If(detailedFinObj.bs != null) {
                                                    
                                                    Probe42_Response_Structure.Bs bsObj = detailedFinObj.bs;
                                                    
                                                    If(bsObj != null) {
                                                        
                                                        If(bsObj.liabilities != null) {
                                                            
                                                            Probe42_Response_Structure.Liabilities liabilitiesObj = bsObj.liabilities;
                                                            If(liabilitiesObj != null) {
                                                                m68Obj.NW_Others1__c = 0;
                                                                m68Obj.TL_Others_1__c = 0;
                                                                m68Obj.TL_Others_2__c = 0;
                                                                
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.share_capital))
                                                                    m68Obj.Paid_Up_Capital__c = Decimal.valueOf(liabilitiesObj.share_capital);
                                                                
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.deferred_government_grants))
                                                                    m68Obj.NW_Others1__c += Decimal.valueOf(liabilitiesObj.deferred_government_grants);
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.money_received_against_share_warrants))
                                                                    m68Obj.NW_Others1__c += Decimal.valueOf(liabilitiesObj.money_received_against_share_warrants);
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.minority_interest))
                                                                    m68Obj.NW_Others1__c += Decimal.valueOf(liabilitiesObj.minority_interest);
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.share_application_money_pending_allotment))
                                                                    m68Obj.NW_Others1__c += Decimal.valueOf(liabilitiesObj.share_application_money_pending_allotment);
                                                                
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.reserves_and_surplus))
                                                                    m68Obj.General_Reserves__c = Decimal.valueOf(liabilitiesObj.reserves_and_surplus);
                                                                
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.long_term_borrowings))
                                                                    m68Obj.TL_Others_1__c = Decimal.valueOf(liabilitiesObj.long_term_borrowings);
                                                                
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.deferred_tax_liabilities_net))
                                                                    m68Obj.TL_Others_2__c += Decimal.valueOf(liabilitiesObj.deferred_tax_liabilities_net);
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.foreign_curr_monetary_item_trans_diff_liability_account))
                                                                    m68Obj.TL_Others_2__c += Decimal.valueOf(liabilitiesObj.foreign_curr_monetary_item_trans_diff_liability_account);
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.other_long_term_liabilities))
                                                                    m68Obj.TL_Others_2__c += Decimal.valueOf(liabilitiesObj.other_long_term_liabilities);
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.long_term_provisions))
                                                                    m68Obj.TL_Others_2__c += Decimal.valueOf(liabilitiesObj.long_term_provisions);
                                                                
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.short_term_borrowings))
                                                                    m68Obj.Bank_Borrowings__c = Decimal.valueOf(liabilitiesObj.short_term_borrowings);
                                                                
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.trade_payables))
                                                                    m68Obj.Sundry_Creditors__c = Decimal.valueOf(liabilitiesObj.trade_payables);
                                                                
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.other_current_liabilities))
                                                                    m68Obj.Other_Current_Liabilities__c = Decimal.valueOf(liabilitiesObj.other_current_liabilities);
                                                                
                                                                If(!Utility.ISStringBlankorNull(liabilitiesObj.short_term_provisions))
                                                                    m68Obj.Provisions__c = Decimal.valueOf(liabilitiesObj.short_term_provisions);
                                                                //If(!Utility.ISStringBlankorNull(liabilitiesObj.given_liabilities_total))
                                                                //m68Obj.Total_Outside_Liabilities__c  =  Decimal.valueOf(liabilitiesObj.given_liabilities_total);                          
                                                            }
                                                        }
                                                        If(bsObj.subTotals != null) {
                                                            Probe42_Response_Structure.SubTotals subTotalsObj = bsObj.subTotals;
                                                            
                                                            If(subTotalsObj != null) {
                                                                /*If(!Utility.ISStringBlankorNull(subTotalsObj.total_current_liabilities))
                                                                //m68Obj.Total_Current_Liabilities__c  =            Decimal.valueOf(subTotalsObj.total_current_liabilities);
                                                                If(!Utility.ISStringBlankorNull(subTotalsObj.net_fixed_assets))
                                                                //m68Obj.Total_Fixed_Assets__c  =  Decimal.valueOf(subTotalsObj.net_fixed_assets);
                                                                If(!Utility.ISStringBlankorNull(subTotalsObj.total_current_assets))
                                                                //m68Obj.Total_Current_Assets__c  =  Decimal.valueOf(subTotalsObj.total_current_assets);
                                                                If(!Utility.ISStringBlankorNull(subTotalsObj.capital_wip))
                                                                m68Obj.Capital_WIP__c  =  Decimal.valueOf(subTotalsObj.capital_wip);  */
                                                            }
                                                        }
                                                        If(bsObj.assets != null) {
                                                            Probe42_Response_Structure.Assets assetsObj = bsObj.assets;
                                                            m68Obj.Fixed_Assests_Others__c = 0;
                                                            m68Obj.Capital_WIP__c = 0;
                                                            m68Obj.Non_Current_others__c = 0;
                                                            m68Obj.Other_Current_Assests__c = 0;
                                                            
                                                            If(assetsObj != null) {
                                                                
                                                                If(!Utility.ISStringBlankorNull(assetsObj.producing_properties))
                                                                    m68Obj.Fixed_Assests_Others__c += Decimal.valueOf(assetsObj.producing_properties);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.intangible_assets))
                                                                    m68Obj.Fixed_Assests_Others__c += Decimal.valueOf(assetsObj.intangible_assets);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.preproducing_properties))
                                                                    m68Obj.Fixed_Assests_Others__c += Decimal.valueOf(assetsObj.preproducing_properties);
                                                                
                                                                If(!Utility.ISStringBlankorNull(assetsObj.tangible_assets_capital_work_in_progress))
                                                                    m68Obj.Capital_WIP__c += Decimal.valueOf(assetsObj.tangible_assets_capital_work_in_progress);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.intangible_assets_under_development))
                                                                    m68Obj.Capital_WIP__c += Decimal.valueOf(assetsObj.intangible_assets_under_development);
                                                                
                                                                If(!Utility.ISStringBlankorNull(assetsObj.noncurrent_investments))
                                                                    m68Obj.Non_Current_others__c += Decimal.valueOf(assetsObj.noncurrent_investments);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.deferred_tax_assets_net))
                                                                    m68Obj.Non_Current_others__c += Decimal.valueOf(assetsObj.deferred_tax_assets_net);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.foreign_curr_monetary_item_trans_diff_asset_account))
                                                                    m68Obj.Non_Current_others__c += Decimal.valueOf(assetsObj.foreign_curr_monetary_item_trans_diff_asset_account);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.long_term_loans_and_advances))
                                                                    m68Obj.Non_Current_others__c += Decimal.valueOf(assetsObj.long_term_loans_and_advances);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.other_noncurrent_assets))
                                                                    m68Obj.Non_Current_others__c += Decimal.valueOf(assetsObj.other_noncurrent_assets);
                                                                
                                                                If(!Utility.ISStringBlankorNull(assetsObj.current_investments))
                                                                    m68Obj.Other_Current_Assests__c += Decimal.valueOf(assetsObj.current_investments);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.other_current_assets))
                                                                    m68Obj.Other_Current_Assests__c += Decimal.valueOf(assetsObj.other_current_assets);
                                                                
                                                                If(!Utility.ISStringBlankorNull(assetsObj.inventories))
                                                                    m68Obj.Inventories__c = Decimal.valueOf(assetsObj.inventories);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.trade_receivables))
                                                                    m68Obj.Sundry_Debtors__c = Decimal.valueOf(assetsObj.trade_receivables);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.cash_and_bank_balances))
                                                                    m68Obj.Cash_and_Bank_Balances__c = Decimal.valueOf(assetsObj.cash_and_bank_balances);
                                                                If(!Utility.ISStringBlankorNull(assetsObj.short_term_loans_and_advances))
                                                                    m68Obj.Advances_and_deposits__c = Decimal.valueOf(assetsObj.short_term_loans_and_advances);
                                                            }
                                                        }
                                                    }
                                                    
                                                    If(detailedFinObj.pnl != null) {
                                                        Probe42_Response_Structure.Pnl pnlObj = detailedFinObj.pnl;
                                                        m68Obj.Purchases__c = 0;
                                                        If(pnlObj != null) {
                                                            Probe42_Response_Structure.LineItems lineItemsObj = pnlObj.lineItems;
                                                            If(lineItemsObj != null) {
                                                                If(!Utility.ISStringBlankorNull(lineItemsObj.net_revenue))
                                                                    m68Obj.Net_sales__c = Decimal.valueOf(lineItemsObj.net_revenue);
                                                                
                                                                If(!Utility.ISStringBlankorNull(lineItemsObj.total_cost_of_materials_consumed))
                                                                    m68Obj.Purchases__c += Decimal.valueOf(lineItemsObj.total_cost_of_materials_consumed);
                                                                If(!Utility.ISStringBlankorNull(lineItemsObj.total_purchases_of_stock_in_trade))
                                                                    m68Obj.Purchases__c += Decimal.valueOf(lineItemsObj.total_purchases_of_stock_in_trade);
                                                                If(!Utility.ISStringBlankorNull(lineItemsObj.total_changes_in_inventories_or_finished_goods))
                                                                    m68Obj.Purchases__c += Decimal.valueOf(lineItemsObj.total_changes_in_inventories_or_finished_goods);
                                                                
                                                                If(!Utility.ISStringBlankorNull(lineItemsObj.other_income))
                                                                    m68Obj.Other_income__c = Decimal.valueOf(lineItemsObj.other_income);
                                                                If(!Utility.ISStringBlankorNull(lineItemsObj.depreciation))
                                                                    m68Obj.Depreciation__c = Decimal.valueOf(lineItemsObj.depreciation);
                                                                If(!Utility.ISStringBlankorNull(lineItemsObj.profit_after_tax))
                                                                    m68Obj.Net_profit__c = Decimal.valueOf(lineItemsObj.profit_after_tax);
                                                                If(!Utility.ISStringBlankorNull(lineItemsObj.profit_before_interest_and_tax))
                                                                    m68Obj.Profit_before_Interest_and_tax__c = Decimal.valueOf(lineItemsObj.profit_before_interest_and_tax);
                                                                If(!Utility.ISStringBlankorNull(lineItemsObj.interest))
                                                                    m68Obj.Interest_Expense__c = Decimal.valueOf(lineItemsObj.interest);
                                                            }
                                                        }
                                                    }
                                                }
                                                listOfM68Obj.add(m68Obj);
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            }
                            If(listOfM68Obj.size() > 0) {
                                try{
                                    upsert listOfM68Obj External_Id__c;
                                    if(app.id !=null){
                                        update app;
                                    }    
                                }catch(Exception ex){
                                    System.debug('Exception'+ex.getMessage()+'Line Number'+ex.getLineNumber());
                                }
                                
                            }
                        }
                        
                    }
                }
                
            }
            If(probe42WrpObj.metadata != null) {
                Probe42_Response_Structure.Metadata metadataObj = probe42WrpObj.metadata;
                If(metadataObj != null) {
                    
                }
            }
        }
        
    }
}