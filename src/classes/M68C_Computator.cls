/*
* Name          : M68C_Computator
* Description   : to do the calculation and store the values
* Author        : Dushyant
*/
public class M68C_Computator{
    public static void calculateM68Data(Id accId,String fiscalYear,String reportType,String custCbsId){
        System.debug('fiscalYear:::'+fiscalYear);
        String currentFY           = 'FY'+Date.Today().Year();
        String prevFY             = 'FY'+(Date.Today().Year()-1);
        Secured_Short_Term_Borrowings__c secStBorr = new Secured_Short_Term_Borrowings__c();
        UnSecuredShortTermBorrowings__c unSecStb = new UnSecuredShortTermBorrowings__c();
        CurrentLiabilitiesOrShortTermLiabilities__c clsl = new CurrentLiabilitiesOrShortTermLiabilities__c();
        ShortTermProvisions__c stProv = new ShortTermProvisions__c();
        ShortTermLoansAndAdvances__c secStlAdv = new ShortTermLoansAndAdvances__c();
        ShortTermLoansAndAdvances__c unsecStlAdv = new ShortTermLoansAndAdvances__c();
        ShortTermLoansAndAdvances__c dbtsecStlAdv = new ShortTermLoansAndAdvances__c();
        List<ShortTermLoansAndAdvances__c> stlAdvList = new List<ShortTermLoansAndAdvances__c>();
        OtherCurrentLiabilities__c ocLib = new OtherCurrentLiabilities__c();
        OtherLongTermLiabilities__c oltLib = new OtherLongTermLiabilities__c();
        Current_Assets__c currAst = new Current_Assets__c();
        TradeReceivablesOrSundryDebtors__c trsdWithin6Month = new TradeReceivablesOrSundryDebtors__c();
        TradeReceivablesOrSundryDebtors__c exceed6Month = new TradeReceivablesOrSundryDebtors__c();
        List<TradeReceivablesOrSundryDebtors__c> tradeRcvSynddbtrs = new List<TradeReceivablesOrSundryDebtors__c>();
        LongTermBorrowings__c secltBorr = new LongTermBorrowings__c();
        LongTermBorrowings__c unSecltBorr = new LongTermBorrowings__c();
        List<LongTermBorrowings__c> ltBorrList = new List<LongTermBorrowings__c>();
        LongTermProvisions__c ltpr = new LongTermProvisions__c();
        NonCurrentLiabilitiesOrLongTermLiabiliti__c nclntl = new NonCurrentLiabilitiesOrLongTermLiabiliti__c();
        TangibleAssets__c tangAst = new TangibleAssets__c();
        FixedAssets__c fAst = new FixedAssets__c();
        ShareCapital__c shcap = new ShareCapital__c();
        EquitiesAndLiabilities__c el = new EquitiesAndLiabilities__c();
        ReserveAndSurplus__c spa_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c gen_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c capRes_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c crr_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c sooa_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c fctr_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c h_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c otherRes_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c rev_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c surpDef_rs = new ReserveAndSurplus__c();
        ReserveAndSurplus__c surpPartner_rs = new ReserveAndSurplus__c();
        List<ReserveAndSurplus__c> resSurpList = new List<ReserveAndSurplus__c>();
        Shareholders_Funds__c shFunds = new Shareholders_Funds__c();
        NonCurrentInvestments__c tradeNCI = new NonCurrentInvestments__c();
        NonCurrentInvestments__c otherNCI = new NonCurrentInvestments__c();
        List<NonCurrentInvestments__c> nciList = new List<NonCurrentInvestments__c>();
        CurrentInvestments__c curInv = new CurrentInvestments__c();
        NonCurrentAssets__c ncAst = new NonCurrentAssets__c();
        LongTermLoansAndAdvances__c ltlaa = new LongTermLoansAndAdvances__c();
        Assets__c ast = new Assets__c();
        BalanceSheet__c bSt = new BalanceSheet__c();
        RevenueFromOperations__c rfo = new RevenueFromOperations__c();
        InTangibleAssets__c inTangAstNet = new InTangibleAssets__c();
        Expenses__c exp = new Expenses__c();
        ProfitAndLoss__c pl = new ProfitAndLoss__c();
        NonOperatingIncome__c noInc = new NonOperatingIncome__c();
        //query perfios data and do the calculation
        ast = [SELECT Id FROM Assets__c WHERE Balance_Sheet__r.Perfios__r.Fiscal_Year__c = :fiscalYear AND Balance_Sheet__r.Perfios__r.Applicant_Name__c =: accId LIMIT 1];
        bSt = [SELECT Id FROM BalanceSheet__c WHERE Perfios__r.Fiscal_Year__c = :fiscalYear AND Perfios__r.Applicant_Name__c =: accId LIMIT 1];
        pl = [SELECT Id,ProfitIeProfitAfterTax__c FROM ProfitAndLoss__c WHERE Perfios__r.Applicant_Name__c =: accId AND Perfios__r.Fiscal_Year__c = :fiscalYear];
        exp = [SELECT Id,DepreciationAndAmortizationTotal__c,PurchasesOfStockInTrade__c,CostOfMaterialsConsumed__c,ChangesInInventoriesTotal__c FROM Expenses__c WHERE Profit_And_Loss__r.Perfios__r.Applicant_Name__c =: accId AND Profit_And_Loss__r.Perfios__r.Fiscal_Year__c = :fiscalYear];
        inTangAstNet = [SELECT Id,Others__c,Total__c FROM InTangibleAssets__c WHERE Fixed_Assets__r.Non_Current_Assets__r.Assets__c =:ast.Id AND Type__c = 'In Tangible Assets Net'];
        el = [SELECT ShareApplicationMoneyPendingAllotment__c FROM EquitiesAndLiabilities__c WHERE Balance_Sheet__c =:bSt.Id];
        currAst = [SELECT OtherCurrentAssetsTotal__c,BWB_InDepositAccounts__c,BWB_InFlexiDepositAccounts__c,GrossTotalOfInventories__c,LessProvisionForObsoleteStock__c,CashOnHand__c,ChequesDraftsOnHand__c,BWB_InCurrentAccounts__c,BWB_InEEFCAccounts__c,BWB_IEA_OtherEarmarkedAccounts__c,BWB_IEA_UnpaidDividendAccounts__c,BWB_IEA_UnpaidMaturedDebentures__c,BWB_IEA_UnpaidMaturedDeposits__c,CashAndCashEquivalentsOthers__c FROM Current_Assets__c WHERE Assets__c =:ast.Id];
        clsl = [SELECT ForGoods_Acceptances__c,ForGoods_Others__c,ForExpenses_Acceptances__c,ForExpenses_Others__c FROM CurrentLiabilitiesOrShortTermLiabilities__c WHERE Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        stProv = [SELECT Total__c FROM ShortTermProvisions__c WHERE CurrentLiabilitiesOrShortTermLiabilities__r.Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        stlAdvList = [SELECT Type__c,AdvanceTax__c,SecurityDeposits__c,OtherLoansAndAdvances__c,InterCorporateDeposits__c,TotalBalancesWithGovernmentAuthorities__c,TotalPrepaidExpenses__c,LoansAndAdvancesToEmployees__c,LoansAndAdvancesToRelatedParties__c,FromOthers__c,FromRelatedParties__c FROM ShortTermLoansAndAdvances__c WHERE Current_Assets__r.Assets__c =:ast.Id];
        ocLib = [SELECT IncomeReceivedInAdvance__c,UnpaidDividends__c,UnpaidMaturedDebenturesAndInterestAccrue__c,UnpaidMaturedDepositsAndInterestAccruedT__c,ContractuallyReimburseableExpenses__c,SR_Total__c,InterestAccruedOnTradePayables__c,InterestAccruedOnOthers__c,TradeSecurityDeposits__c,Others__c,CurrentMaturitiesOfLongtermDebt__c,CurrentMaturitiesOfFinanceLeaseObligatio__c,InterestAccruedButNotDueOnBorrowings__c,InterestAccruedAndDueOnBorrowings__c FROM OtherCurrentLiabilities__c WHERE CurrentLiabilitiesOrShortTermLiabilities__r.Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        oltLib = [SELECT Acceptances__c,OtherThanAcceptances__c,TradeSecurityDeposits__c,PayablesOnPurchaseOfFixedAssets__c,Others__c,InterestAccruedOnTradePayables__c,InterestAccruedOnOthers__c,InterestAccruedButNotDueOnBorrowings__c,IncomeReceivedInAdvance__c,ContractuallyReimburseableExpenses__c,AdvancesFromCustomers__c FROM OtherLongTermLiabilities__c WHERE NonCurrentLiabilities_LongTermLiability__r.Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        secStBorr = [SELECT ForeignCurrencyLoans__c,LoansRepayableOnDemandFromBanks__c,CashCredits__c,Overdrafts__c,LoansRepayableOnDemandFromOtherParties__c,LoansAndAdvancesFromRelatedParties__c,Deposits__c,InterCorporateBorrowings__c,OtherLoansAndAdvances__c FROM Secured_Short_Term_Borrowings__c WHERE Short_Term_Borrowings__r.CurrentLiabilitiesOrShortTermLiabilities__r.Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        tradeRcvSynddbtrs = [SELECT Type__c,TotalTradeReceivables__c,NetTradeReceivables__c FROM TradeReceivablesOrSundryDebtors__c WHERE Current_Assets__r.Assets__c =: ast.id];
        ltBorrList = [SELECT Type__c,ForeignCurrencyLoans__c,QuasiEquity__c,BondsDebentures__c,TermLoans_FromOtherParties__c,DeferredPaymentLiabilities__c,Deposits__c,LoansAndAdvancesFromRelatedParties__c,LongTermMaturitiesOfFinancialLeaseObliga__c,OtherLoansAdvances__c,TermLoans_FromBanks__c FROM LongTermBorrowings__c WHERE Type__c = 'Secured Long Term Borrowings' AND NonCurrentLiabilities_LongTermLiability__r.Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        unSecStb = [SELECT LoansRepayableOnDemandFromOtherParties__c,OtherLoansAndAdvances__c,LoansAndAdvancesFromRelatedParties__c,Deposits__c,InterCorporateBorrowings__c,ForeignCurrencyLoans__c,LoansRepayableOnDemandFromBanks__c,CashCredits__c,Overdrafts__c FROM UnSecuredShortTermBorrowings__c WHERE Short_Term_Borrowings__r.CurrentLiabilitiesOrShortTermLiabilities__r.Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        ltpr = [SELECT Total__c FROM LongTermProvisions__c WHERE NonCurrentLiabilities_LongTermLiability__r.Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        nclntl = [SELECT DeferredTaxLiabilities__c  FROM NonCurrentLiabilitiesOrLongTermLiabiliti__c WHERE Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        tangAst = [SELECT FurnitureAndFixtures__c,Vehicles__c,OfficeEquipment__c,LeaseholdImprovements__c,Computers__c,Others__c,Land__c,Buildings__c,PlantAndEquipment__c FROM TangibleAssets__c WHERE Fixed_Assets__r.Non_Current_Assets__r.Assets__c =:ast.Id AND Type__c = 'Tangible Assets Net'];
        fAst = [SELECT InTangibleAssetsUnderDevelopment__c,CapitalWorkInProgress__c FROM FixedAssets__c WHERE Non_Current_Assets__r.Assets__c =:ast.Id];
        shcap = [SELECT Id,Total__c FROM ShareCapital__c WHERE Shareholders_Funds__r.Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        shFunds = [SELECT MoneyReceivedAgainstShareWarrants__c FROM Shareholders_Funds__c WHERE Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        resSurpList = [SELECT ClosingBalance__c,Type__c FROM ReserveAndSurplus__c WHERE Shareholders_Funds__r.Equities_And_Liabilities__r.Balance_Sheet__c =:bSt.Id];
        nciList =  [SELECT Type__c,Type_Total__c,NetInvestmentProperty__c,GovernmentAndTrustSecurities_Total__c,OtherLongTermInvestments__c,LessProvisionForDiminutionInValueOfInves__c,EI_Total__c,PS_Total__c,DB_Total__c,InvestmentInMutualFunds__c,InvestmentInPartnershipFirms__c FROM NonCurrentInvestments__c WHERE Type__c = 'Trade Investments' AND Non_Current_Assets__r.Assets__c =:ast.Id];
        curInv = [SELECT NetInvestmentProperty__c,IIGATS_Total__c,OtherCurrentInvestments__c,NetOfCurrentPortionOfLongTermInvestments__c,PreferenceShares_Total__c,InvestmentInMutualFunds__c,InvestmentInPartnershipFirms__c,DebenturesOrBonds_Total__c,EquityInstruments_Total__c FROM CurrentInvestments__c WHERE Current_Assets__r.Assets__c =:ast.Id];
        ncAst = [SELECT NonCurrentAssets_Total__c,DeferredTaxAssets__c,NonCurrentAssets_Others__c FROM NonCurrentAssets__c WHERE Assets__c =: ast.Id];
        ltlaa = [SELECT Total__c FROM LongTermLoansAndAdvances__c WHERE Non_Current_Assets__r.Assets__c =:ast.Id LIMIT 1];
        rfo = [SELECT NetDomesticTurnover__c,ExpSaleOfGoodsManufactured__c,DomSaleOfGoodsManufactured__c,ExpSaleOfGoodsTraded__c,DomSaleOfGoodsTraded__c,NetExportTurnover__c,ExpSaleOrSupplyOfServices__c,DomesticSaleOrSupplyOfServices__c,Total__c,DomLessExciseAndOtherDuties__c,ExpLessExciseAndOtherDuties__c FROM RevenueFromOperations__c WHERE Profit_And_Loss__r.Perfios__r.Fiscal_Year__c =: fiscalYear  AND Profit_And_Loss__r.Perfios__r.Applicant_Name__c =: accId  LIMIT 1];
        noInc = [SELECT GrandTotal__c FROM NonOperatingIncome__c WHERE Profit_And_Loss__c =: pl.Id];
        
        for(ShortTermLoansAndAdvances__c stlaad : stlAdvList){
            if(stlaad.Type__c == 'Secured Short Term Loans And Advances')
                secStlAdv = stlaad;
            if(stlaad.Type__c == 'Un Secured Short Term Loans And Advances')
                unsecStlAdv = stlaad;
            if(stlaad.Type__c == 'Doubtful Short Term Loans And Advances')
                dbtsecStlAdv = stlaad;
        }
        for(TradeReceivablesOrSundryDebtors__c trosd : tradeRcvSynddbtrs){
            if(trosd.Type__c == 'Within Six Months')
                trsdWithin6Month = trosd;
            if(trosd.Type__c == 'Exceeding Six Months')
                exceed6Month = trosd;
        }
        for(LongTermBorrowings__c ltb : ltBorrList){
            if(ltb.Type__c == 'Secured Long Term Borrowings')
                secltBorr = ltb;
            if(ltb.Type__c == 'UnSecured Long Term Borrowings')
                unSecltBorr = ltb;
        }
        for(ReserveAndSurplus__c ras : resSurpList){
            if(ras.Type__c == 'Securities Premium Account')
                spa_rs = ras;
            if(ras.Type__c == 'General Reserve')
                gen_rs = ras;
            if(ras.Type__c == 'Capital Reserve')
                capRes_rs = ras;
            if(ras.Type__c == 'Capital Redemption Reserve')
                crr_rs = ras;
            if(ras.Type__c == 'Share Options Outstanding Account')
                sooa_rs = ras;
            if(ras.Type__c == 'Foreign Currency Translation Reserve')
                fctr_rs = ras;
            if(ras.Type__c == 'Hedging Reserve')
                h_rs = ras;
            if(ras.Type__c == 'Other Reserves')
                otherRes_rs = ras;
            if(ras.Type__c == 'Revaluation Reserve')
                rev_rs = ras;
            if(ras.Type__c == 'Surplus Or Deficit In The Statement Of Profit And Loss')
                surpDef_rs = ras;
            if(ras.Type__c == 'Surplus To Be Distributed To The Partners')
                surpPartner_rs = ras;
        }
        for(NonCurrentInvestments__c nci : nciList){
            if(nci.Type__c == 'Trade Investments')
                tradeNCI = nci;
            if(nci.Type__c == 'Other Investments')
                otherNCI = nci;
        }
        M68_Balance_Sheet_Analysis__c m68Data = new M68_Balance_Sheet_Analysis__c();
        m68Data.Fiscal_Year__c   = fiscalYear;
        m68Data.External_Id__c =  custCbsId+'@'+fiscalYear+'@Actual';
        m68Data.Data_Source__c   = 'Perfios';
        if(reportType == null || reportType == '' || reportType == 'Actual') m68Data.Financial_type__c = 'Actual';
        else m68Data.Financial_type__c = 'Provisional';
        m68Data.Account__c = accId;
        m68Data.Bank_Borrowings__c = Utility.isNullOrZeroDecimal(secStBorr.ForeignCurrencyLoans__c)+secStBorr.LoansRepayableOnDemandFromBanks__c+secStBorr.CashCredits__c+secStBorr.Overdrafts__c+unSecStb.ForeignCurrencyLoans__c+unSecStb.LoansRepayableOnDemandFromBanks__c+unSecStb.CashCredits__c+ unSecStb.Overdrafts__c;
        m68Data.Sundry_Creditors__c = clsl.ForGoods_Acceptances__c+clsl.ForGoods_Others__c;
        m68Data.Sundry_Creditors_Finance__c = secStBorr.LoansRepayableOnDemandFromOtherParties__c + unSecStb.LoansRepayableOnDemandFromOtherParties__c;
        m68Data.Sundry_Creditors_Exp__c = clsl.ForExpenses_Acceptances__c+clsl.ForExpenses_Others__c;
        m68Data.Provisions__c = stProv.PFEB_Total__c+tradeNCI.LessProvisionForDiminutionInValueOfInves__c+otherNCI.LessProvisionForDiminutionInValueOfInves__c+secStlAdv.FromRelatedParties__c+secStlAdv.FromOthers__c+unsecStlAdv.FromRelatedParties__c+unsecStlAdv.FromOthers__c+dbtsecStlAdv.FromRelatedParties__c+dbtsecStlAdv.FromOthers__c;
        m68Data.Term_Loan_1_Yr__c = ocLib.CurrentMaturitiesOfLongtermDebt__c+ocLib.CurrentMaturitiesOfFinanceLeaseObligatio__c+ocLib.InterestAccruedButNotDueOnBorrowings__c+ocLib.InterestAccruedAndDueOnBorrowings__c;
        m68Data.Other_Current_Liabilities__c = oltLib.AdvancesFromCustomers__c+secStBorr.Deposits__c+secStBorr.InterCorporateBorrowings__c+secStBorr.LoansAndAdvancesFromRelatedParties__c+unSecStb.LoansAndAdvancesFromRelatedParties__c+unSecStb.Deposits__c+unSecStb.InterCorporateBorrowings__c+unSecStb.OtherLoansAndAdvances__c+secStBorr.OtherLoansAndAdvances__c;
        m68Data.CL_Others_1__c = ocLib.IncomeReceivedInAdvance__c+ocLib.UnpaidDividends__c+ocLib.UnpaidMaturedDebenturesAndInterestAccrue__c+ocLib.UnpaidMaturedDepositsAndInterestAccruedT__c+ocLib.ContractuallyReimburseableExpenses__c+ocLib.SR_Total__c+ocLib.InterestAccruedOnTradePayables__c+ocLib.InterestAccruedOnOthers__c+ocLib.TradeSecurityDeposits__c+ocLib.Others__c;
        //m68Data.CL_Others_2__c = 0.0;//Formula not given
        m68Data.Cash_and_Bank_Balances__c = currAst.CashOnHand__c+currAst.ChequesDraftsOnHand__c+currAst.BWB_InCurrentAccounts__c+currAst.BWB_InEEFCAccounts__c+currAst.BWB_IEA_OtherEarmarkedAccounts__c+currAst.BWB_IEA_UnpaidDividendAccounts__c+currAst.BWB_IEA_UnpaidMaturedDebentures__c+currAst.BWB_IEA_UnpaidMaturedDeposits__c+currAst.CashAndCashEquivalentsOthers__c;
        m68Data.Inventories__c = currAst.GrossTotalOfInventories__c+currAst.LessProvisionForObsoleteStock__c;
        m68Data.Sundry_Debtors__c = trsdWithin6Month.NetTradeReceivables__c;
        m68Data.Advances_and_deposits__c = secStlAdv.LoansAndAdvancesToEmployees__c+secStlAdv.LoansAndAdvancesToRelatedParties__c;
        //m68Data.Advance_to_suppliers__c = 0.0;//Formula not given
        m68Data.Bank_Deposits__c = currAst.BWB_InDepositAccounts__c+currAst.BWB_InFlexiDepositAccounts__c;
        m68Data.Other_Current_Assests__c = secStlAdv.TotalPrepaidExpenses__c+secStlAdv.TotalBalancesWithGovernmentAuthorities__c+secStlAdv.AdvanceTax__c+secStlAdv.InterCorporateDeposits__c+secStlAdv.OtherLoansAndAdvances__c+unsecStlAdv.LoansAndAdvancesToRelatedParties__c+unsecStlAdv.LoansAndAdvancesToEmployees__c+unsecStlAdv.TotalPrepaidExpenses__c+unsecStlAdv.TotalBalancesWithGovernmentAuthorities__c+unsecStlAdv.AdvanceTax__c+unsecStlAdv.OtherLoansAndAdvances__c+dbtsecStlAdv.TotalPrepaidExpenses__c+dbtsecStlAdv.TotalBalancesWithGovernmentAuthorities__c+dbtsecStlAdv.AdvanceTax__c+dbtsecStlAdv.OtherLoansAndAdvances__c;
        m68Data.OCA1__c = currAst.OtherCurrentAssetsTotal__c ;
        //m68Data.OCA2__c = 0.0;//Formula not given
        m68Data.Term_loan_Banks_FIs__c = secltBorr.TermLoans_FromBanks__c + unSecltBorr.TermLoans_FromBanks__c;
        m68Data.Unsecured_Loans_F_R__c = unSecltBorr.QuasiEquity__c+unSecltBorr.TermLoans_FromOtherParties__c+unSecltBorr.LoansAndAdvancesFromRelatedParties__c;
        //m68Data.Term_LoanNBFCs__c = 0.0;//Formula not given
        m68Data.Other_Term_Liabilites__c = secltBorr.ForeignCurrencyLoans__c+secltBorr.QuasiEquity__c+secltBorr.BondsDebentures__c+secltBorr.TermLoans_FromOtherParties__c+secltBorr.DeferredPaymentLiabilities__c+secltBorr.Deposits__c+secltBorr.LoansAndAdvancesFromRelatedParties__c+secltBorr.LongTermMaturitiesOfFinancialLeaseObliga__c+secltBorr.OtherLoansAdvances__c+unSecltBorr.ForeignCurrencyLoans__c+unSecltBorr.BondsDebentures__c+unSecltBorr.DeferredPaymentLiabilities__c+unSecltBorr.Deposits__c+unSecltBorr.LongTermMaturitiesOfFinancialLeaseObliga__c+unSecltBorr.OtherLoansAdvances__c+oltLib.Acceptances__c+oltLib.OtherThanAcceptances__c+oltLib.TradeSecurityDeposits__c+oltLib.PayablesOnPurchaseOfFixedAssets__c+oltLib.Others__c+oltLib.InterestAccruedOnTradePayables__c+oltLib.InterestAccruedOnOthers__c+oltLib.InterestAccruedButNotDueOnBorrowings__c+oltLib.IncomeReceivedInAdvance__c+oltLib.ContractuallyReimburseableExpenses__c;
        m68Data.TL_Others_1__c = ltpr.Total__c;
        m68Data.TL_Others_2__c = nclntl.DeferredTaxLiabilities__c;
        m68Data.Land_Building__c = tangAst.Land__c+tangAst.Buildings__c;
        m68Data.Plant_Machinery__c = tangAst.PlantAndEquipment__c;
        m68Data.Fixed_Assests_Others__c = tangAst.FurnitureAndFixtures__c+tangAst.Vehicles__c+tangAst.OfficeEquipment__c+tangAst.LeaseholdImprovements__c+tangAst.Computers__c+tangAst.Others__c;
        m68Data.Capital_WIP__c = fAst.CapitalWorkInProgress__c;
        m68Data.Paid_Up_Capital__c = shcap.Total__c;
        m68Data.Share_Application_Money__c = el.ShareApplicationMoneyPendingAllotment__c;
        m68Data.Share_Premium__c = spa_rs.ClosingBalance__c;
        m68Data.General_Reserves__c = gen_rs.ClosingBalance__c;
        m68Data.Other_Reserves__c = capRes_rs.ClosingBalance__c+crr_rs.ClosingBalance__c+sooa_rs.ClosingBalance__c+fctr_rs.ClosingBalance__c+h_rs.ClosingBalance__c+otherRes_rs.ClosingBalance__c;
        m68Data.Revaluation_Reserves__c = rev_rs.ClosingBalance__c;
        m68Data.Surplus_in_P_L__c = surpDef_rs.ClosingBalance__c+surpPartner_rs.ClosingBalance__c;
        m68Data.NW_Others1__c = shFunds.MoneyReceivedAgainstShareWarrants__c;
        //m68Data.NW_Others2__c = 0.0;//Formula not given
        m68Data.Inv_in_Sister_Associates__c = tradeNCI.EI_OfSubsidiaries__c+tradeNCI.EI_OfAssociates__c+tradeNCI.EI_OfControlledSpecialPurposeEntities__c+tradeNCI.PS_OfSubsidiaries__c+tradeNCI.PS_OfAssociates__c+tradeNCI.PS_OfControlledSpecialPurposeEntities__c+tradeNCI.DB_OfSubsidiaries__c+tradeNCI.DB_OfAssociates__c+tradeNCI.DB_OfControlledSpecialPurposeEntities__c+otherNCI.EI_OfSubsidiaries__c+otherNCI.EI_OfAssociates__c+otherNCI.EI_OfControlledSpecialPurposeEntities__c+otherNCI.PS_OfSubsidiaries__c+otherNCI.PS_OfAssociates__c+otherNCI.PS_OfControlledSpecialPurposeEntities__c+otherNCI.DB_OfSubsidiaries__c+otherNCI.DB_OfAssociates__c+otherNCI.DB_OfControlledSpecialPurposeEntities__c+curInv.EquityInstruments_OfSubsidiaries__c+curInv.EquityInstruments_OfAssociates__c+curInv.EquityInstruments_OfControlledSpecialPur__c+curInv.PreferenceShares_OfSubsidiaries__c+curInv.PreferenceShares_OfAssociates__c+curInv.PreferenceShares_OfControlledSpecialPurp__c+curInv.DebenturesOrBonds_OfSubsidiaries__c+curInv.DebenturesOrBonds_OfAssociates__c+curInv.DebenturesOrBonds_OfControlledSpecialPur__c+curInv.InvestmentInPartnershipFirms__c;
        m68Data.Inv_in_shares_etc__c =  tradeNCI.EI_OfJointVentureCompanies__c+tradeNCI.EI_OfOtherEntities__c+tradeNCI.PS_OfJointVentureCompanies__c+tradeNCI.PS_OfOtherEntities__c+tradeNCI.DB_OfJointVentureCompanies__c+tradeNCI.DB_OfOtherEntities__c+tradeNCI.InvestmentInMutualFunds__c+otherNCI.EI_OfJointVentureCompanies__c+otherNCI.EI_OfOtherEntities__c+otherNCI.PS_OfJointVentureCompanies__c+otherNCI.PS_OfOtherEntities__c+otherNCI.DB_OfJointVentureCompanies__c+otherNCI.DB_OfOtherEntities__c+otherNCI.InvestmentInMutualFunds__c+curInv.NetOfCurrentPortionOfLongTermInvestments__c+curInv.EquityInstruments_OfJointVentureCompanie__c+curInv.EquityInstruments_OfOtherEntities__c+curInv.PreferenceShares_OfJointVentureCompanies__c+curInv.PreferenceShares_OfOtherEntities__c+curInv.DebenturesOrBonds_OfJointVentureCompanie__c+curInv.DebenturesOrBonds_OfOtherEntities__c+curInv.InvestmentInMutualFunds__c;
        m68Data.Non_Current_others__c = ncAst.DeferredTaxAssets__c+tradeNCI.NetInvestmentProperty__c+tradeNCI.GovernmentAndTrustSecurities_Total__c+otherNCI.NetInvestmentProperty__c+tradeNCI.GovernmentAndTrustSecurities_Total__c+tradeNCI.OtherLongTermInvestments__c+ltlaa.Total__c+ncAst.NonCurrentAssets_Total__c+curInv.NetInvestmentProperty__c+curInv.IIGATS_Total__c+curInv.OtherCurrentInvestments__c+secStlAdv.SecurityDeposits__c+unsecStlAdv.SecurityDeposits__c+unsecStlAdv.InterCorporateDeposits__c+dbtsecStlAdv.SecurityDeposits__c+dbtsecStlAdv.LoansAndAdvancesToRelatedParties__c+dbtsecStlAdv.LoansAndAdvancesToEmployees__c+dbtsecStlAdv.InterCorporateDeposits__c+exceed6Month.NetTradeReceivables__c;
        //m68Data.Profit_Loss_Account__c = 0.0;//Formula not given
        //m68Data.Misc_Expenditure__c = 0.0;//Formula not given
        m68Data.Intangible_Others__c = inTangAstNet.Total__c + fAst.InTangibleAssetsUnderDevelopment__c;
        m68Data.Gross_sales__c = rfo.Total__c+rfo.DomLessExciseAndOtherDuties__c+rfo.ExpLessExciseAndOtherDuties__c;
        m68Data.Net_sales__c = rfo.Total__c;
        m68Data.Purchases__c = exp.PurchasesOfStockInTrade__c+exp.CostOfMaterialsConsumed__c+exp.ChangesInInventoriesTotal__c;
        m68Data.Depreciation__c   = exp.DepreciationAndAmortizationTotal__c;
        m68Data.Net_profit__c   = pl.ProfitIeProfitAfterTax__c;
        m68Data.Other_income__c   = noInc.GrandTotal__c;
        UPSERT m68Data External_Id__c;
    }
}