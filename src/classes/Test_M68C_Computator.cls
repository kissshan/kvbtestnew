/*
* Description : ApplicationTriggerHandler_Test
* Author       : Ashish jain
* last Modified by : Yadagiri
*/
@isTest
public class Test_M68C_Computator {
@isTest
    public static void method1(){
        Account acc=new Account(Name='TestName');
        insert acc;
        
        Perfios__c perobj=new Perfios__c();
        perobj.Applicant_Name__c=acc.Id;
        perobj.Data_received_for_financial_year__c=true;
        perobj.Net_Salary__c=92392;
        perobj.Employment_Type__c='permarent';
        perobj.Fiscal_Year__c='2017';
        insert perobj;
        
        BalanceSheet__c bal=new BalanceSheet__c();
        bal.Perfios__c=perobj.Id;
        bal.ExternalId__c='873287js';
        insert bal;
        
        Assets__c aobj=new Assets__c();
        aobj.Balance_Sheet__c=bal.Id;
        aobj.AssetsTotal__c=231898;
        aobj.ExternalId__c='9331sa';
        insert aobj;
        
        
        ProfitAndLoss__c proobj=new ProfitAndLoss__c();
        proobj.Perfios__c=perobj.id;
        proobj.ProfitIeProfitAfterTax__c=100;
        insert proobj;
        
        Expenses__c exobj=new Expenses__c();
        exobj.Profit_And_Loss__c=proobj.id;
        exobj.PurchasesOfStockInTrade__c =2292;
        exobj.CostOfMaterialsConsumed__c = 339;
        exobj.ChangesInInventoriesTotal__c =3980;
        exobj.DepreciationAndAmortizationTotal__c = 339;
        insert exobj;
        
        NonCurrentAssets__c curobj=new NonCurrentAssets__c();
        curobj.Assets__c=aobj.Id;
        curobj.DeferredTaxAssets__c =3323;
        curObj.NonCurrentAssets_Others__c = 1229;
        curObj.NonCurrentAssets_Total__c=123232.3;
        insert curobj;
        
        FixedAssets__c fixobj=new FixedAssets__c();
        fixobj.Non_Current_Assets__c=curobj.id;
        fixobj.CapitalWorkInProgress__c = 2322;
        fixobj.InTangibleAssetsUnderDevelopment__c =23299;
        
        insert fixobj;
        
        InTangibleAssets__c tanobj=new InTangibleAssets__c();
        tanobj.Fixed_Assets__c=fixobj.Id;
        tanobj.Type__c='In Tangible Assets Net';
        tanObj.Others__c = 2323;
        insert tanobj;
        
        EquitiesAndLiabilities__c equobj=new EquitiesAndLiabilities__c();
        equobj.Balance_Sheet__c=bal.id;
        equobj.ShareApplicationMoneyPendingAllotment__c = 11222;
        insert equobj;
        
        CurrentLiabilitiesOrShortTermLiabilities__c clostl = new CurrentLiabilitiesOrShortTermLiabilities__c();
        clostl.Equities_And_Liabilities__c = equobj.Id;
        clostl.ForGoods_Acceptances__c = 10203;
        clostl.ForGoods_Others__c = 12322;
        clostl.ForExpenses_Acceptances__c = 12323;
        clostl.ForExpenses_Others__c = 32344;
        insert clostl;
        
        ShortTermBorrowings__c stb = new ShortTermBorrowings__c();
        stb.CurrentLiabilitiesOrShortTermLiabilities__c = clostl.Id;
        insert stb;
        
        Secured_Short_Term_Borrowings__c sstb = new Secured_Short_Term_Borrowings__c();
        sstb.Short_Term_Borrowings__c = stb.Id;
        sstb.ForeignCurrencyLoans__c = 100000;
        sstb.LoansRepayableOnDemandFromBanks__c = 100000;
        sstb.CashCredits__c = 100000;
        sstb.Overdrafts__c = 120000;
        sstb.Deposits__c = 12121;
        sstb.InterCorporateBorrowings__c = 23222;
        sstb.LoansAndAdvancesFromRelatedParties__c = 1111;
        sstb.OtherLoansAndAdvances__c = 11298;
        insert sstb;
        
        UnSecuredShortTermBorrowings__c usstb = new UnSecuredShortTermBorrowings__c();
        usstb.Short_Term_Borrowings__c = stb.Id;
        usstb.ForeignCurrencyLoans__c = 100000;
        usstb.CashCredits__c = 120000;
        usstb.LoansRepayableOnDemandFromBanks__c = 10000;
        usstb.Overdrafts__c = 102030;
        usstb.LoansAndAdvancesFromRelatedParties__c = 1111;
        usstb.Deposits__c = 12123;
        usstb.InterCorporateBorrowings__c = 11121;
        usstb.OtherLoansAndAdvances__c = 12111;
        usstb.LoansRepayableOnDemandFromOtherParties__c = 12121;
        usstb.LoansRepayableOnDemandFromOtherParties__c = 12111;
        insert usstb;
                
        Current_Assets__c curAssobj=new Current_Assets__c();
        curAssobj.Assets__c=aobj.id;
        curAssobj.AncillaryBorrowingCosts__c=734872;
        curAssobj.CashOnHand__c=2328;
        curAssobj.CashOnHand__c =1233;
        curAssobj.ChequesDraftsOnHand__c=95495;
        curAssobj.BWB_InCurrentAccounts__c = 49393;
        curAssobj.BWB_InEEFCAccounts__c = 42323;
        curAssobj.BWB_IEA_OtherEarmarkedAccounts__c=34232;
        curAssobj.BWB_IEA_UnpaidDividendAccounts__c = 3223;
        curAssobj.BWB_IEA_UnpaidMaturedDebentures__c = 32322;
        curAssobj.BWB_IEA_UnpaidMaturedDeposits__c = 2322;
        curAssobj.CashAndCashEquivalentsOthers__c = 23239;
        curAssobj.GrossTotalOfInventories__c =121212;
        curAssobj.LessProvisionForObsoleteStock__c = 11122;
        curAssObj.BWB_InDepositAccounts__c = 1211;
        curAssObj.BWB_InFlexiDepositAccounts__c = 9394;
        curAssObj.OtherCurrentAssetsTotal__c = 1211;
        insert curAssobj;
        
        ShortTermProvisions__c stp = new ShortTermProvisions__c();
        stp.CurrentLiabilitiesOrShortTermLiabilities__c = clostl.id;
        stp.Total__c = 100000;
        insert stp;
        
        ShortTermLoansAndAdvances__c stlaa = new ShortTermLoansAndAdvances__c();
        stlaa.Type__c = 'Secured Short Term Loans And Advances';
        stlaa.Current_Assets__c = curAssobj.Id;
        stlaa.AdvanceTax__c =12020;
        stlaa.SecurityDeposits__c =23233;
        stlaa.OtherLoansAndAdvances__c =23233;
        stlaa.InterCorporateDeposits__c = 12343;
        stlaa.TotalBalancesWithGovernmentAuthorities__c = 58668;
        stlaa.TotalPrepaidExpenses__c = 35858;
        stlaa.LoansAndAdvancesToEmployees__c =33321;
        stlaa.LoansAndAdvancesToRelatedParties__c = 23333;
        stlaa.FromOthers__c = 21212;
        stlaa.FromRelatedParties__c = 34332;
        stlaa.LoansAndAdvancesToEmployees__c = 2333;
        stlaa.LoansAndAdvancesToRelatedParties__c = 12121;
        stlaa.TotalPrepaidExpenses__c = 1222;
        stlaa.Total__c = 2121;
        stlaa.SecurityDeposits__c =2323;
        insert stlaa;
        ShortTermLoansAndAdvances__c stlaa1 = new ShortTermLoansAndAdvances__c();
        stlaa1.Type__c = 'Un Secured Short Term Loans And Advances';
        stlaa1.Current_Assets__c = curAssobj.Id;
        stlaa1.AdvanceTax__c =12020;
        stlaa1.SecurityDeposits__c =23233;
        stlaa1.OtherLoansAndAdvances__c =23233;
        stlaa1.InterCorporateDeposits__c = 12343;
        stlaa1.TotalBalancesWithGovernmentAuthorities__c = 58668;
        stlaa1.TotalPrepaidExpenses__c = 35858;
        stlaa1.LoansAndAdvancesToEmployees__c =33321;
        stlaa1.LoansAndAdvancesToRelatedParties__c = 23333;
        stlaa1.FromOthers__c = 21212;
        stlaa1.FromRelatedParties__c = 34332;
        stlaa1.SecurityDeposits__c = 3339;
        insert stlaa1;
        ShortTermLoansAndAdvances__c stlaa2 = new ShortTermLoansAndAdvances__c();
        stlaa2.Type__c = 'Doubtful Short Term Loans And Advances';
        stlaa2.Current_Assets__c = curAssobj.Id;
        stlaa2.AdvanceTax__c =12020;
        stlaa2.SecurityDeposits__c =23233;
        stlaa2.OtherLoansAndAdvances__c =23233;
        stlaa2.InterCorporateDeposits__c = 12343;
        stlaa2.TotalBalancesWithGovernmentAuthorities__c = 58668;
        stlaa2.TotalPrepaidExpenses__c = 35858;
        stlaa2.LoansAndAdvancesToEmployees__c =33321;
        stlaa2.LoansAndAdvancesToRelatedParties__c = 23333;
        stlaa2.FromOthers__c = 21212;
        stlaa2.FromRelatedParties__c = 34332;
        stlaa2.SecurityDeposits__c =4985;
        insert stlaa2;
        
        OtherCurrentLiabilities__c ocl = new OtherCurrentLiabilities__c();
        ocl.CurrentLiabilitiesOrShortTermLiabilities__c = clostl.Id;
        ocl.CurrentMaturitiesOfLongtermDebt__c = 12321;
        ocl.CurrentMaturitiesOfFinanceLeaseObligatio__c = 12121;
        ocl.InterestAccruedButNotDueOnBorrowings__c = 12211;
        ocl.InterestAccruedAndDueOnBorrowings__c = 1211;
        ocl.IncomeReceivedInAdvance__c = 1212;
        ocl.UnpaidDividends__c = 1211;
        ocl.UnpaidMaturedDebenturesAndInterestAccrue__c=1121;
        ocl.UnpaidMaturedDepositsAndInterestAccruedT__c = 1222;
        ocl.ContractuallyReimburseableExpenses__c = 11111;
        ocl.SR_Total__c =22222;
        ocl.InterestAccruedOnTradePayables__c= 57689;
        ocl.InterestAccruedOnOthers__c =11222;
        ocl.TradeSecurityDeposits__c  = 21211;
        ocl.Others__c =32322;
        insert ocl;
        NonCurrentLiabilitiesOrLongTermLiabiliti__c ncloltl = new NonCurrentLiabilitiesOrLongTermLiabiliti__c();
        ncloltl.Equities_And_Liabilities__c = equobj.Id;
        insert ncloltl;
        
        OtherLongTermLiabilities__c oltl = new OtherLongTermLiabilities__c();
        oltl.NonCurrentLiabilities_LongTermLiability__c = ncloltl.Id;
        oltl.AdvancesFromCustomers__c = 1222;
        oltl.Acceptances__c = 12212;
        oltl.OtherThanAcceptances__c = 21222;
        oltl.TradeSecurityDeposits__c = 12122;
        oltl.PayablesOnPurchaseOfFixedAssets__c = 11299;
        oltl.Others__c = 2323;
        oltl.InterestAccruedOnTradePayables__c = 32323;
        oltl.InterestAccruedOnOthers__c = 1221;
        oltl.InterestAccruedButNotDueOnBorrowings__c = 21212;
        oltl.IncomeReceivedInAdvance__c = 2122;
        oltl.ContractuallyReimburseableExpenses__c = 3333;
        insert oltl;
        
        
        TradeReceivablesOrSundryDebtors__c trosd = new TradeReceivablesOrSundryDebtors__c();
        trosd.Type__c = 'Within Six Months';
        trosd.Current_Assets__c = curAssobj.Id;
        trosd.TotalTradeReceivables__c = 12121;
        insert trosd;
        
        TradeReceivablesOrSundryDebtors__c trosd1 = new TradeReceivablesOrSundryDebtors__c();
        trosd1.Type__c = 'Exceeding Six Months';
        trosd1.Current_Assets__c = curAssobj.Id;
        trosd1.TotalTradeReceivables__c = 1323;
        insert trosd1;
        
        LongTermBorrowings__c ltbw = new LongTermBorrowings__c();
        ltbw.Type__c = 'Secured Long Term Borrowings';
        ltbw.NonCurrentLiabilities_LongTermLiability__c = ncloltl.id;
        ltbw.QuasiEquity__c = 11212;
        ltbw.TermLoans_FromOtherParties__c = 2110;
        ltbw.LoansAndAdvancesFromRelatedParties__c = 1238;
        ltbw.ForeignCurrencyLoans__c =1111;
        ltbw.QuasiEquity__c = 12122;
        ltbw.BondsDebentures__c = 32323;
        ltbw.TermLoans_FromOtherParties__c = 21222;
        ltbw.DeferredPaymentLiabilities__c = 12121;
        ltbw.Deposits__c = 2112;
        ltbw.LoansAndAdvancesFromRelatedParties__c = 21212;
        ltbw.LongTermMaturitiesOfFinancialLeaseObliga__c = 12112;
        ltbw.OtherLoansAdvances__c = 31113;
        
        insert ltbw;
        LongTermBorrowings__c ltbw1 = new LongTermBorrowings__c();
        ltbw1.Type__c = 'UnSecured Long Term Borrowings';
        ltbw1.NonCurrentLiabilities_LongTermLiability__c = ncloltl.id;
        ltbw1.ForeignCurrencyLoans__c = 21212;
        ltbw1.BondsDebentures__c = 1212;
        ltbw1.TermLoans_FromBanks__c = 1121;
        ltbw1.DeferredPaymentLiabilities__c  =2322;
        ltbw1.Deposits__c = 23232;
        ltbw1.LongTermMaturitiesOfFinancialLeaseObliga__c = 1222;
        ltbw1.OtherLoansAdvances__c = 2212;
        ltbw1.QuasiEquity__c =1232;
        ltbw1.TermLoans_FromOtherParties__c = 12121;
        ltbw1.LoansAndAdvancesFromRelatedParties__c = 1211;
        insert ltbw1;
        
    LongTermProvisions__c ltpv = new LongTermProvisions__c();
    ltpv.NonCurrentLiabilities_LongTermLiability__c = ncloltl.id;
        insert ltpv;
        
        TangibleAssets__c tngas = new TangibleAssets__c();
        tngas.Fixed_Assets__c = fixobj.id;
        tngas.Type__c = 'Tangible Assets Net';
        tngas.Land__c =1212;
        tngas.Buildings__c =23333;
        tngas.PlantAndEquipment__c = 2221;
        tngas.FurnitureAndFixtures__c = 2212;
        tngas.Vehicles__c =1222;
        tngas.OfficeEquipment__c = 2121;
        tngas.LeaseholdImprovements__c = 2222;
        tngas.Computers__c = 32333;
        tngas.Others__c =3333;
        insert tngas;
        
        Shareholders_Funds__c shf = new Shareholders_Funds__c();
        shf.Equities_And_Liabilities__c =equobj.id;
        insert shf;
        ShareCapital__c shcapi = new ShareCapital__c();
        shcapi.Shareholders_Funds__c = shf.Id;
        shcapi.Total__c =212122;
        insert shcapi;
        
        ReserveAndSurplus__c ras = new ReserveAndSurplus__c();
        ras.Type__c = 'Securities Premium Account';
        ras.Shareholders_Funds__c = shf.Id;
        insert ras;
        ReserveAndSurplus__c ras1 = new ReserveAndSurplus__c();
        ras1.Type__c = 'General Reserve';
        ras1.Shareholders_Funds__c = shf.Id;
        insert ras1;
        ReserveAndSurplus__c ras2 = new ReserveAndSurplus__c();
        ras2.Type__c = 'Capital Reserve';
        ras2.Shareholders_Funds__c = shf.Id;
        ras2.ClosingBalance__c = 11111;
        insert ras2;
        ReserveAndSurplus__c ras3 = new ReserveAndSurplus__c();
        ras3.Type__c = 'Capital Redemption Reserve';
        ras3.Shareholders_Funds__c = shf.Id;
        ras3.ClosingBalance__c = 1131;
        insert ras3;
        ReserveAndSurplus__c ras4 = new ReserveAndSurplus__c();
        ras4.Type__c = 'Share Options Outstanding Account';
        ras4.Shareholders_Funds__c = shf.Id;
        ras4.ClosingBalance__c = 11129;
        insert ras4;
        ReserveAndSurplus__c ras5 = new ReserveAndSurplus__c();
        ras5.Type__c = 'Foreign Currency Translation Reserve';
        ras5.Shareholders_Funds__c = shf.Id;
        ras5.ClosingBalance__c = 111;
        insert ras5;
        ReserveAndSurplus__c ras6 = new ReserveAndSurplus__c();
        ras6.Type__c = 'Hedging Reserve';
        ras6.Shareholders_Funds__c = shf.Id;
        ras6.ClosingBalance__c = 32411;
        insert ras6;
        ReserveAndSurplus__c ras7 = new ReserveAndSurplus__c();
        ras7.Type__c = 'Other Reserves';
        ras7.Shareholders_Funds__c = shf.Id;
        ras7.ClosingBalance__c = 99111;
        insert ras7;
        ReserveAndSurplus__c ras8 = new ReserveAndSurplus__c();
        ras8.Type__c = 'Revaluation Reserve';
        ras8.Shareholders_Funds__c = shf.Id;
        ras8.ClosingBalance__c = 991594;
        insert ras8;
        ReserveAndSurplus__c ras9 = new ReserveAndSurplus__c();
        ras9.Type__c = 'Surplus Or Deficit In The Statement Of Profit And Loss';
        ras9.Shareholders_Funds__c = shf.Id;
        ras9.ClosingBalance__c = 9911;
        insert ras9;
        ReserveAndSurplus__c ras10 = new ReserveAndSurplus__c();
        ras10.Type__c = 'Surplus To Be Distributed To The Partners';
        ras10.Shareholders_Funds__c = shf.Id;
        ras10.ClosingBalance__c = 99151;
        insert ras10;
        
        NonCurrentInvestments__c nci = new NonCurrentInvestments__c();
        nci.Type__c = 'Trade Investments';
        nci.Non_Current_Assets__c = curobj.id;
        nci.InvestmentInPartnershipFirms__c =11111;
        nci.EI_Total__c = 2222;
        nci.PS_Total__c =22112;
        nci.DB_Total__c = 2222;
        nci.InvestmentInMutualFunds__c = 1119;
        nci.NetInvestmentProperty__c = 2298;
        nci.GovernmentAndTrustSecurities_Total__c = 2223;
        nci.OtherLongTermInvestments__c =21109;
        nci.LessProvisionForDiminutionInValueOfInves__c = 2210;
        nci.Type_Total__c=11.2;
        insert nci;
        
        NonCurrentInvestments__c nci1 = new NonCurrentInvestments__c();
        nci1.Type_Total__c=11.2;
        nci1.Type__c = 'Other Investments';
        nci1.Non_Current_Assets__c = curobj.id;
        nci1.InvestmentInPartnershipFirms__c =1121;
        nci1.EI_Total__c =22222;
        nci1.DB_Total__c = 2989;
        nci1.InvestmentInMutualFunds__c = 2232;
        nci1.NetInvestmentProperty__c =2212;
        nci1.GovernmentAndTrustSecurities_Total__c =12232;
        nci1.OtherLongTermInvestments__c =1129;
        nci1.LessProvisionForDiminutionInValueOfInves__c = 21982;
        nci1.InvestmentInPartnershipFirms__c =2121;
        insert nci1;
        
        CurrentInvestments__c currInv = new CurrentInvestments__c();
        currInv.Current_Assets__c = curAssObj.id;
        currInv.EquityInstruments_Total__c =12221;
        currInv.DebenturesOrBonds_Total__c =39393;
        currInv.InvestmentInPartnershipFirms__c =4859;
        currInv.NetOfCurrentPortionOfLongTermInvestments__c = 1212;
        currInv.PreferenceShares_Total__c = 2333;
        currInv.InvestmentInMutualFunds__c =9867;
        currInv.NetInvestmentProperty__c = 19283;
        currInv.IIGATS_Total__c = 9384;
        currInv.OtherCurrentInvestments__c = 1289;
        insert currInv;
        
        /*NonCurrentAssets__c nonCurrAss = new NonCurrentAssets__c();
        nonCurrAss.Assets__c = aobj.id;
        insert nonCurrAss;*/
        
        LongTermLoansAndAdvances__c  ltlaa = new LongTermLoansAndAdvances__c();
        ltlaa.Non_Current_Assets__c = curobj.id;
        ltlaa.Total__c = 3389;
        insert ltlaa;
        RevenueFromOperations__c rfop = new RevenueFromOperations__c();
        rfop.Profit_And_Loss__c = proobj.id;
        rfop.DomesticSaleOrSupplyOfServices__c = 1229;
        rfop.ExpSaleOrSupplyOfServices__c = 22122;
        rfop.NetDomesticTurnover__c = 2293;
        rfop.ExpSaleOfGoodsManufactured__c = 3232;
        rfop.DomSaleOfGoodsManufactured__c = 39843;
        rfop.ExpSaleOfGoodsTraded__c = 38239;
        rfop.DomSaleOfGoodsTraded__c = 2323;
        rfop.NetExportTurnover__c =32323;
        rfop.DomLessExciseAndOtherDuties__c = 3983;
        rfop.ExpLessExciseAndOtherDuties__c = 3233;
        rfop.Total__c=123.45;
        
        insert rfop;
        
        NonOperatingIncome__c noInc = new NonOperatingIncome__c();
        noInc.Profit_And_Loss__c = proobj.id;
        insert noInc; 
        
        M68C_Computator.calculateM68Data(acc.Id,'2017','Actual','');
    }
}