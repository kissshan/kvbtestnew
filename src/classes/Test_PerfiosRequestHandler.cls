@isTest
public class Test_PerfiosRequestHandler {
    
    
    
    @isTest
    public static void method1(){
        
        Perfios__c per = new Perfios__c();
        INSERT per;
        Ratio__c rObj = new Ratio__c();
        rObj.Perfios__c = per.Id;
        INSERT rObj;
        
        
        PerfiosStructureBuilder.cls_AddNonCashExpenses nonCashExp = new PerfiosStructureBuilder.cls_AddNonCashExpenses();
        nonCashExp.Amortization = 68548;
        nonCashExp.InterestOnPartnersCapital = 68676;
        nonCashExp.NetLossOnForeignCurrencyTransactionsAndTranslation = 68623;
        nonCashExp.LossOnSaleOfLongTermInvestments = 68620;
        
        PerfiosStructureBuilder.cls_LessNonCashIncome nonCashInc = new PerfiosStructureBuilder.cls_LessNonCashIncome();
        nonCashInc.ProfitGainOnSaleOfCurrentInvestments = 68406;
        nonCashInc.ProfitOnSaleOfFixedAssets = 68420;
        
        PerfiosStructureBuilder.cls_CalculationOfNetOperatingIncome netOpeInc = new PerfiosStructureBuilder.cls_CalculationOfNetOperatingIncome();
        netOpeInc.NetOperatingIncome = 961658;
        netOpeInc.LessNonCashIncome = nonCashInc;
        netOpeInc.AddNonCashExpenses = nonCashExp;
        
        PerfiosStructureBuilder.cls_ShortTermSolvencyRatios shortTermRat = new PerfiosStructureBuilder.cls_ShortTermSolvencyRatios();
        shortTermRat.QuickRatioAcidTestRatioLiquidRatioExcludingInventories = 1.50880052511828;
        shortTermRat.QuickRatioAcidTestRatioLiquidRatioExcludingInventoriesAndDebtorsMoreThan6Months = 1.25739277298591;
        shortTermRat.QuickRatioAcidTestRatioLiquidRatioExcludingDebtors = 1.25726001836439;
        shortTermRat.CurrentRatio = 1.76010871128451;
        
        PerfiosStructureBuilder.cls_LeverageRatios levRatio = new PerfiosStructureBuilder.cls_LeverageRatios();
        levRatio.InterestCoverageRatio = -0.503804542105302;
        levRatio.DebtRatio = 0.132666925941201;
        
        PerfiosStructureBuilder.cls_TurnoverRatios turnovrRat = new PerfiosStructureBuilder.cls_TurnoverRatios();
        turnovrRat.NetAssetsTurnoverRatioCapitalTurnoverRatio = 0.0912102131746752;
        turnovrRat.CurrentAssetsTurnoverRatio = 0.143249228474275;
        
        PerfiosStructureBuilder.cls_OtherRatios OthrRat = new PerfiosStructureBuilder.cls_OtherRatios();
        OthrRat.TotalLiabilitiesTangibleNetworth = 8.02950897422596;
        
        PerfiosStructureBuilder.cls_RatiosAppearingInBalanceSheet balSheet = new PerfiosStructureBuilder.cls_RatiosAppearingInBalanceSheet();
        balSheet.OtherRatios = OthrRat;
        balSheet.TurnoverRatios = turnovrRat;
        balSheet.LeverageRatios = levRatio;
        balSheet.ShortTermSolvencyRatios = shortTermRat;
        
        PerfiosStructureBuilder.cls_ProfitabilityRatios proRatio = new PerfiosStructureBuilder.cls_ProfitabilityRatios();
        proRatio.ReturnOnEquity = 1.01842272976538;
        proRatio.ReturnOnInvestment = 0.0921240094981457;
        
        PerfiosStructureBuilder.cls_RatiosAppearingInProfitAndLossAccount proLoss = new PerfiosStructureBuilder.cls_RatiosAppearingInProfitAndLossAccount();
        proLoss.ProfitabilityRatios = proRatio;
        
        PerfiosStructureBuilder.cls_FinancialRatios finRat = new PerfiosStructureBuilder.cls_FinancialRatios();
        finRat.RatiosAppearingInBalanceSheet = balSheet;
        finRat.RatiosAppearingInProfitAndLossAccount = proLoss;
        
        PerfiosStructureBuilder.cls_PLItems pliItms = new PerfiosStructureBuilder.cls_PLItems();
        pliItms.ChangesInInventories = 68447;
        pliItms.CostOfMaterialsConsumed = 68436;
        pliItms.DirectExpenses = 68580;
        pliItms.GrossProfit = -205536;
        pliItms.PurchasesOfStockInTrade = 68446;
        pliItms.SalesRevenueFromOperations = 68373;
        
        PerfiosStructureBuilder.cls_CalculationOfCashProfits cashPro = new PerfiosStructureBuilder.cls_CalculationOfCashProfits();
        cashPro.CashProfits = 137257;
        cashPro.Interest = -137073;
        cashPro.Sales = 68373;
        cashPro.ProfitBeforeInterestAndTaxOperatingProfit = 69058;
        
        PerfiosStructureBuilder.cls_Liabilities liab = new PerfiosStructureBuilder.cls_Liabilities();
        liab.LongTermDebt = 203111;
        liab.PaidUpCapitalPartnersContribution = 67420;
        liab.Reserves = 51;
        liab.TotalLiabilities = 541759;
        liab.ShortTermDebt = 271177;
        liab.Provisions = 135563;
        liab.TradePayables = 67788;
        
        PerfiosStructureBuilder.cls_Assets asset = new PerfiosStructureBuilder.cls_Assets();
        asset.CashCashEquivalents = 68190;
        asset.Inventories  = 68149;
        asset.NetFixedAssets = 271550;
        asset.TotalNonCurrentAssets = 543496;
        
        PerfiosStructureBuilder.cls_MiscellaneousItems misc = new PerfiosStructureBuilder.cls_MiscellaneousItems();
        misc.CapitalEmployedOrNetAssets = 749620;
        misc.DebtService = 546627;
        misc.EmployeeCosts = 68457 ;
        misc.WorkingCapitalGap = 273529;
        misc.RawMaterialCostsOrPurchasesOfStockinTrade = 68446;
        misc.QuickAssetsExcludingInventories = 409152;
        misc.SalesAdvertisingOrMarketingExpenses = 68625;
        misc.LongTermBorrowings = 67672;
        misc.QuickAssetsExcludingDebtors = 340940;
        misc.ShortTermBorrowings = 67754;
        misc.CreditorsForGoods = 135589;
        misc.InvestmentInGroupCompanies = 12;
        misc.OutsideLiabilities = 135426;
        misc.QuickAssetsExcludingDebtorsMoreThan6MonthsAndInventories = 340976;
        
        PerfiosStructureBuilder.RatiosParse ratParse = new PerfiosStructureBuilder.RatiosParse();
        ratParse.Assets = asset;
        ratParse.CalculationOfCashProfits = cashPro;
        ratParse.CalculationOfNetOperatingIncome = netOpeInc;
        ratParse.FinancialRatios = finRat;
        ratParse.MiscellaneousItems = misc;
        ratParse.Liabilities = liab;
        ratParse.PLItems = pliItms;
        
        
        Test.startTest();    
        PerfiosRequestHandler.inserRatios(ratParse, per.Id);
        Test.stopTest();
        
    }
    
    @isTest
    public static void method2(){
        Perfios__c per = new Perfios__c();
        INSERT per;
        Ratio__c rObj = new Ratio__c();
        rObj.Perfios__c = per.Id;
        INSERT rObj;
        
        PerfiosStructureBuilder.cls_EarningsPerEquityShareBeforeExtraordinaryItems items = new PerfiosStructureBuilder.cls_EarningsPerEquityShareBeforeExtraordinaryItems();
        items.Basic = 68746;
        items.Diluted = 68747;
        
        PerfiosStructureBuilder.cls_NetGainOnSale netGain = new PerfiosStructureBuilder.cls_NetGainOnSale();
        netGain.CurrentInvestments = 68411;
        netGain.LongtermInvestments = 68412;
        netGain.TotalNetGainOnSaleOfInvestments = 68413;
        
        PerfiosStructureBuilder.cls_DividendIncome divInc = new PerfiosStructureBuilder.cls_DividendIncome();
        divInc.FromCurrentInvestments = 68406;
        divInc.FromLongtermInvestments = 68407;
        divInc.TotalDividendIncome = 68408;
        
        PerfiosStructureBuilder.cls_OtherNonOperatingIncome othrNonOperInc = new PerfiosStructureBuilder.cls_OtherNonOperatingIncome();
        othrNonOperInc.LiabilitiesProvisionsNoLongerRequired = 68424;
        
        PerfiosStructureBuilder.cls_InterestIncome intInc = new PerfiosStructureBuilder.cls_InterestIncome();
        intInc.InterestFromBanks = 68396;
        
        PerfiosStructureBuilder.cls_NonOperatingIncome nonOperInc = new PerfiosStructureBuilder.cls_NonOperatingIncome();
        nonOperInc.InterestIncome = intInc;
        nonOperInc.NetIncomeTaxRefunds = 68428;
        nonOperInc.MiscellaneousIncome = 68429;
        nonOperInc.GrandTotal = 68430;
        nonOperInc.DividendIncome = divInc;
        nonOperInc.NetGainOnSale = netGain;
        
        PerfiosStructureBuilder.cls_ExtraordinaryItemsWhichAreLossses itmsLoss = new PerfiosStructureBuilder.cls_ExtraordinaryItemsWhichAreLossses();
        itmsLoss.LossesFromCatastrophicEvents = 68695;
        
        PerfiosStructureBuilder.cls_ExtraordinaryItemsWhichAreGains itmsGain = new PerfiosStructureBuilder.cls_ExtraordinaryItemsWhichAreGains();
        itmsGain.GainsFromEarlyRetirementOfDebt = 68696;
        
        PerfiosStructureBuilder.cls_ExtraordinaryItems extOrdItms = new PerfiosStructureBuilder.cls_ExtraordinaryItems();
        extOrdItms.ExtraordinaryItemsWhichAreGains = itmsGain;
        extOrdItms.ExtraordinaryItemsWhichAreLossses = itmsLoss;
        extOrdItms.Total = 68704;
        
        PerfiosStructureBuilder.cls_BalanceCarriedToBalanceSheetInPropeitorAccount balcarried = new PerfiosStructureBuilder.cls_BalanceCarriedToBalanceSheetInPropeitorAccount();
        balcarried.PartnerA = 68722;
        
        PerfiosStructureBuilder.cls_TaxExpense taxExp = new PerfiosStructureBuilder.cls_TaxExpense();
        taxExp.CurrentTax = 68708;
        taxExp.DeferredTax = 68709;
        
        PerfiosStructureBuilder.cls_ExportTurnover expTurnovr = new  PerfiosStructureBuilder.cls_ExportTurnover();
        expTurnovr.SaleOrSupplyOfServices = 68386;
        
        PerfiosStructureBuilder.cls_DomesticTurnover domTurnovr = new PerfiosStructureBuilder.cls_DomesticTurnover();
        domTurnovr.SaleOrSupplyOfServices = 68379;
        
        PerfiosStructureBuilder.cls_RevenueFromOperations revOper = new PerfiosStructureBuilder.cls_RevenueFromOperations();
        revOper.DomesticTurnover = domTurnovr;
        revOper.ExportTurnover = expTurnovr;
        revOper.Total = 68390;
        
        PerfiosStructureBuilder.cls_ExceptionalItemsWhichAreGains excepItmsGain = new PerfiosStructureBuilder.cls_ExceptionalItemsWhichAreGains();
        excepItmsGain.AbnormalGainsOnLongTermContracts = 68662;
        
        PerfiosStructureBuilder.cls_ExceptionalItemsWhichAreLossses excepItmsloss = new PerfiosStructureBuilder.cls_ExceptionalItemsWhichAreLossses();
        excepItmsloss.LossesOnDisposalOfFixedAssets = 68668;
        
        PerfiosStructureBuilder.cls_ExceptionalItems excepItms = new PerfiosStructureBuilder.cls_ExceptionalItems();
        excepItms.ExceptionalItemsWhichAreGains = excepItmsGain;
        excepItms.ExceptionalItemsWhichAreLossses = excepItmsloss;
        excepItms.Total = 69674;
        
        PerfiosStructureBuilder.cls_TravellingAndConveyance travConv = new PerfiosStructureBuilder.cls_TravellingAndConveyance();
        travConv.ConveyanceExpenses = 68598;
        travConv.DomesticTravellingExpenses = 68596;
        travConv.ForeignTravellingExpenses = 68597;
        
        PerfiosStructureBuilder.cls_ProposedDividend propDiv = new PerfiosStructureBuilder.cls_ProposedDividend();
        propDiv.EquityDividend = 68633;
        propDiv.EquityDividend = 68634;
        
        PerfiosStructureBuilder.cls_ConsumptionOf consum = new PerfiosStructureBuilder.cls_ConsumptionOf();
        consum.StoresAndSpareParts = 68584;
        
        PerfiosStructureBuilder.cls_RepairsAndMaintenance repairMain = new PerfiosStructureBuilder.cls_RepairsAndMaintenance();
        repairMain.Building = 68593;
        repairMain.Others = 68594;
        repairMain.PlantAndMachinery = 68595;
        
        PerfiosStructureBuilder.cls_LossOnSaleOfInvestments saleOfInves = new PerfiosStructureBuilder.cls_LossOnSaleOfInvestments();
        saleOfInves.CurrentInvestments = 68619;
        saleOfInves.LongTermInvestments = 68620;
        
        PerfiosStructureBuilder.cls_TaxOnDividend taxOndiv = new PerfiosStructureBuilder.cls_TaxOnDividend();
        taxOndiv.EquityDividend = 68636;
        taxOndiv.PreferenceDividend = 68637;
        
        PerfiosStructureBuilder.cls_Rent rent = new PerfiosStructureBuilder.cls_Rent();
        rent.Factory = 68591;
        rent.Godown = 68592;
        rent.LeaseRentals = 68593;
        rent.Others = 68594;
        
        
        PerfiosStructureBuilder.cls_InDirectExpenses indirectExp = new PerfiosStructureBuilder.cls_InDirectExpenses();
        indirectExp.AdvertisingMarketingExpenses = 68625;
        indirectExp.TravellingAndConveyance = travConv;
        indirectExp.ProposedDividend = propDiv;
        indirectExp.ConsumptionOf = consum;
        indirectExp.RepairsAndMaintenance = repairMain;
        indirectExp.LossOnSaleOfInvestments = saleOfInves;
        indirectExp.TaxOnDividend = taxOndiv;
        indirectExp.Rent = rent;
        
        PerfiosStructureBuilder.cls_Electricity elect = new PerfiosStructureBuilder.cls_Electricity();
        elect.Factory = 68563;
        elect.Godown = 68562;
        elect.Others = 68561;
        
        PerfiosStructureBuilder.cls_RepairsAndMaintenance repairsMaint = new PerfiosStructureBuilder.cls_RepairsAndMaintenance();
        repairsMaint.Building = 68593;
        repairsMaint.Others = 68594;
        repairsMaint.PlantAndMachinery = 68595;
        
        PerfiosStructureBuilder.cls_InsuranceCharges insuCharges = new PerfiosStructureBuilder.cls_InsuranceCharges();
        insuCharges.Factory = 68569;
        insuCharges.Godown = 68570;
        insuCharges.Others = 68571;
        
        PerfiosStructureBuilder.cls_Rent rents = new PerfiosStructureBuilder.cls_Rent();
        rents.Factory = 68590;
        rents.Godown = 68590;
        rents.LeaseRentals = 68590;
        rents.Others = 68591;
        
        PerfiosStructureBuilder.cls_DirectExpenses directExp = new PerfiosStructureBuilder.cls_DirectExpenses();
        directExp.CarriageInwards = 68558;
        directExp.Electricity = elect;
        directExp.RepairsAndMaintenance = repairsMaint;
        directExp.InsuranceCharges = insuCharges;
        directExp.Rent = rents;
        
        PerfiosStructureBuilder.cls_OtherExpenses othrExp = new PerfiosStructureBuilder.cls_OtherExpenses();
        othrExp.DirectExpenses = directExp;
        othrExp.InDirectExpenses = indirectExp;
        othrExp.GrandTotalOfOtherExpenses = 68651;
        
        PerfiosStructureBuilder.cls_AuditorsFees auditFees = new PerfiosStructureBuilder.cls_AuditorsFees();
        auditFees.CompanyLawMatters = 68498;
        auditFees.ManagementServices = 68496;
        auditFees.OtherServices = 68497;
        auditFees.StatuatoryServices = 68499;
        auditFees.TaxationMatters = 68500;
        auditFees.Total = 68501;
        
        PerfiosStructureBuilder.cls_ChangesInInventories inventories = new PerfiosStructureBuilder.cls_ChangesInInventories();
        inventories.FinishedGoods = 68451;
        inventories.StockInTrade = 68452;
        inventories.Total = 68453;
        inventories.WorkInProgress = 68454;
        
        PerfiosStructureBuilder.cls_CostOfMaterialsConsumed matConsumed = new PerfiosStructureBuilder.cls_CostOfMaterialsConsumed();
        matConsumed.ClosingStock = 68442;
        
        PerfiosStructureBuilder.cls_DepreciationAndAmortizationExpenses depAmorExp = new PerfiosStructureBuilder.cls_DepreciationAndAmortizationExpenses();
        depAmorExp.Depreciation = 68547;
        
        PerfiosStructureBuilder.cls_ContributionsToFunds contFunds = new PerfiosStructureBuilder.cls_ContributionsToFunds();
        contFunds.ContributionToApprovedSuperannuationFund = 68463;
        contFunds.ContributionToOtherFunds = 68464;
        contFunds.ContributionToRecognisedGratuityFund = 68465;
        contFunds.ContributionToRecognisedProvidentFund = 68466;
        contFunds.TotalContributionsToProvidentAndOtherFunds = 68467;
        
        PerfiosStructureBuilder.cls_EmployeeBenefitExpenses empBenExp = new PerfiosStructureBuilder.cls_EmployeeBenefitExpenses();
        empBenExp.Bonus = 68469;
        empBenExp.ContributionsToFunds = contFunds;
        
        PerfiosStructureBuilder.cls_InterestExpense intExp = new PerfiosStructureBuilder.cls_InterestExpense();
        intExp.OnBankLoans = 68532;
        
        PerfiosStructureBuilder.cls_FinanceCost finCost = new PerfiosStructureBuilder.cls_FinanceCost();
        finCost.InterestExpense = intExp;
        finCost.Others = 68539;
        
        PerfiosStructureBuilder.cls_InsuranceExpenses insuExp = new PerfiosStructureBuilder.cls_InsuranceExpenses();
        insuExp.KeymanInsurance = 68510;
        insuExp.LifeInsurance = 68511;
        
        PerfiosStructureBuilder.cls_ManagerialRemuneration mangRemu = new PerfiosStructureBuilder.cls_ManagerialRemuneration();
        mangRemu.Manager = 68484;
        
        PerfiosStructureBuilder.cls_PowerAndFuel pwrFuel = new PerfiosStructureBuilder.cls_PowerAndFuel();
        pwrFuel.ElectricityExpenses = 68519;
        
        PerfiosStructureBuilder.cls_Expenses expen = new PerfiosStructureBuilder.cls_Expenses();
        expen.AuditorsFees = auditFees;
        expen.ChangesInInventories = inventories;
        expen.CostOfMaterialsConsumed = matConsumed;
        expen.DepreciationAndAmortizationExpenses = depAmorExp;
        expen.EmployeeBenefitExpenses = empBenExp;
        expen.FinanceCost = finCost;
        expen.InsuranceExpenses = insuExp;
        expen.ManagerialRemuneration = mangRemu;
        expen.OtherExpenses = othrExp;
        expen.PowerAndFuel = pwrFuel;
        expen.PurchasesOfStockInTrade = 68446;
        expen.TotalExpenses = 68653;
        
        PerfiosStructureBuilder.cls_EarningsPerEquityShareAfterExtraordinaryItems exOrdItms = new PerfiosStructureBuilder.cls_EarningsPerEquityShareAfterExtraordinaryItems();
        exOrdItms.Basic = 68749;
        exOrdItms.Diluted = 68750;
        
        PerfiosStructureBuilder.cls_StatementOfProfitAndLoss proLoss = new PerfiosStructureBuilder.cls_StatementOfProfitAndLoss();
        proLoss.InterestOnCapital = 69676;
        proLoss.EarningsPerEquityShareAfterExtraordinaryItems = exOrdItms;
        proLoss.Expenses = expen;
        proLoss.ExceptionalItems = excepItms;
        proLoss.RevenueFromOperations = revOper;
        proLoss.TaxExpense = taxExp;
        proLoss.BalanceCarriedToBalanceSheetInPropeitorAccount = balcarried;
        proLoss.ExtraordinaryItems = extOrdItms;
        proLoss.NonOperatingIncome = nonOperInc;
        proLoss.EarningsPerEquityShareBeforeExtraordinaryItems = items;
        
        PerfiosStructureBuilder.ProfitAndLossParse proLossParse = new PerfiosStructureBuilder.ProfitAndLossParse();
        proLossParse.StatementOfProfitAndLoss = proLoss;
        
        Test.startTest();
        PerfiosRequestHandler.inserPL(proLossParse, per.Id);
        test.stopTest();
    }
    
    @isTest
    public static void method3(){
        Perfios__c per = new Perfios__c();
        INSERT per;
        Ratio__c rObj = new Ratio__c();
        rObj.Perfios__c = per.Id;
        INSERT rObj;
        
        PerfiosStructureBuilder.cls_StatutoryRemittances statRem = new PerfiosStructureBuilder.cls_StatutoryRemittances();
        statRem.ContributionToEmployeesStateInsurance = 20258;
        
        PerfiosStructureBuilder.cls_OtherPayables othrpay = new PerfiosStructureBuilder.cls_OtherPayables();
        othrpay.InterestAccruedOnOthers = 20267;
        othrpay.StatutoryRemittances = statRem;
        
        PerfiosStructureBuilder.cls_OtherCurrentLiabilities othrCurLiab = new PerfiosStructureBuilder.cls_OtherCurrentLiabilities();
        othrCurLiab.ContractuallyReimburseableExpenses = 20268;
        othrCurLiab.OtherPayables = othrpay;
        
        PerfiosStructureBuilder.cls_ProvisionForEmployeeBenefits empBen = new PerfiosStructureBuilder.cls_ProvisionForEmployeeBenefits();
        empBen.ProvisionForBonus = 20271;
        empBen.ProvisionForPostemploymentMedicalBenefits = 20280;
		empBen.ProvisionForCompensatedAbsences=20278;
		empBen.Total=20284;
		//public Decimal ProvisionForOtherEmployeeBenefits;	//20282
		//public Decimal ProvisionForOtherDefinedBenefitPlans;	//20281
		//public Decimal ProvisionForBonus;	//20283
		//public Decimal ProvisionForGratuity;	//20279
        
        PerfiosStructureBuilder.cls_ProvisionOthers othrsProv = new PerfiosStructureBuilder.cls_ProvisionOthers();
        othrsProv.ProvisionForEstimatedLossesOnOnerousContracts = 20269;
        
        PerfiosStructureBuilder.cls_ShortTermProvisions prov = new PerfiosStructureBuilder.cls_ShortTermProvisions();
        prov.ProvisionForEmployeeBenefits = empBen;
        prov.ProvisionOthers = othrsProv;
        prov.Total = 20273;
        
        PerfiosStructureBuilder.cls_LoansRepayableOnDemand onDem = new PerfiosStructureBuilder.cls_LoansRepayableOnDemand();
        onDem.FromBanks = 20217;
        onDem.FromOtherParties = 20218;
        
        PerfiosStructureBuilder.cls_TermLoans termLoans = new PerfiosStructureBuilder.cls_TermLoans();
        termLoans.FromBanks = 20217;
        termLoans.FromOtherParties = 20218;
        
        PerfiosStructureBuilder.cls_DomesticLoans domLoans = new PerfiosStructureBuilder.cls_DomesticLoans();
        domLoans.LoansAndAdvancesFromRelatedParties = 20219;
        domLoans.LoansRepayableOnDemand = onDem;
        domLoans.TermLoans = termLoans;
        domLoans.CashCredits = 20274;
        
        PerfiosStructureBuilder.cls_UnSecuredShortTermBorrowings unsecBorr = new PerfiosStructureBuilder.cls_UnSecuredShortTermBorrowings();
        unsecBorr.DomesticLoans = domLoans;
        unsecBorr.TotalUnsecuredShortTermBorrowings = 20275;
        
        PerfiosStructureBuilder.cls_LoansRepayableOnDemand repOnDemand = new PerfiosStructureBuilder.cls_LoansRepayableOnDemand();
        repOnDemand.FromBanks = 20217;
        repOnDemand.FromOtherParties = 20218;
        
        PerfiosStructureBuilder.cls_SecuredShortTermBorrowings secBorr = new PerfiosStructureBuilder.cls_SecuredShortTermBorrowings();
        secBorr.DomesticLoans = domLoans;
        secBorr.OutOfAboveTotalAggregateAmountGuaranteedByDirectors =20211;
        
        PerfiosStructureBuilder.cls_ShortTermBorrowings shrtTermBorr = new PerfiosStructureBuilder.cls_ShortTermBorrowings();
        shrtTermBorr.SecuredShortTermBorrowings = secBorr;
        shrtTermBorr.UnSecuredShortTermBorrowings = unsecBorr;
        
        PerfiosStructureBuilder.cls_ForExpenses forExp = new PerfiosStructureBuilder.cls_ForExpenses();
        forExp.Acceptances = 20212;
        
        PerfiosStructureBuilder.cls_ForGoods forGoods = new PerfiosStructureBuilder.cls_ForGoods();
        forGoods.Acceptances = 20213;
        
        PerfiosStructureBuilder.cls_TradePayablesOrSundryCreditors cred = new PerfiosStructureBuilder.cls_TradePayablesOrSundryCreditors();
        cred.ForExpenses = forExp;
        cred.ForGoods = forGoods;
        
        PerfiosStructureBuilder.cls_CurrentLiabilitiesOrShortTermLiabilities currLiab = new PerfiosStructureBuilder.cls_CurrentLiabilitiesOrShortTermLiabilities();
        currLiab.OtherCurrentLiabilities = othrCurLiab;
        currLiab.ShortTermBorrowings = shrtTermBorr;
        currLiab.ShortTermProvisions = prov;
        currLiab.OtherCurrentLiabilities = othrCurLiab;
        currLiab.TradePayablesOrSundryCreditors = cred;
        
        PerfiosStructureBuilder.cls_TradePayables tradePay = new PerfiosStructureBuilder.cls_TradePayables();
        tradePay.Acceptances = 20214;
        
        PerfiosStructureBuilder.cls_Others othrs = new PerfiosStructureBuilder.cls_Others();
        
        PerfiosStructureBuilder.cls_OtherLongTermLiabilities othrsLongTermLiab = new PerfiosStructureBuilder.cls_OtherLongTermLiabilities();
        othrsLongTermLiab.Others = othrs;
        othrsLongTermLiab.TradePayables = tradePay;
        
        PerfiosStructureBuilder.cls_ProvisionOthers provOthrs = new PerfiosStructureBuilder.cls_ProvisionOthers();
        provOthrs.ProvisionForPremiumPayableOnRedemptionOfBonds=0288;
		provOthrs.ProvisionForProposedPreferenceDividend=20294;
		provOthrs.ProvisionForOtherContingencies=20292;
        
        PerfiosStructureBuilder.cls_ProvisionForEmployeeBenefits empBenProv = new PerfiosStructureBuilder.cls_ProvisionForEmployeeBenefits();
        empBenProv.ProvisionForPostemploymentMedicalBenefits=20280;
		empBenProv.ProvisionForCompensatedAbsences=20278;
		empBenProv.Total=20279;	
        
        PerfiosStructureBuilder.cls_LongTermProvisions longTermProv = new PerfiosStructureBuilder.cls_LongTermProvisions();
        longTermProv.ProvisionForEmployeeBenefits =empBenProv;
        longTermProv.ProvisionOthers = provOthrs;
       // PerfiosStructureBuilder.cls_DomesticLoans domLoan = new PerfiosStructureBuilder.cls_DomesticLoans();
        
        PerfiosStructureBuilder.cls_SecuredLongTermBorrowings secLongBorr = new PerfiosStructureBuilder.cls_SecuredLongTermBorrowings();
        secLongBorr.DomesticLoans = domLoans;
        
        PerfiosStructureBuilder.cls_TermLoans trmLoans = new PerfiosStructureBuilder.cls_TermLoans();
        
        PerfiosStructureBuilder.cls_UnSecuredLongTermBorrowings unSecLongBorr = new PerfiosStructureBuilder.cls_UnSecuredLongTermBorrowings();
        unSecLongBorr.DomesticLoans = domLoans;
        unSecLongBorr.OutOfAboveTotalAggregateAmountGuaranteedByDirectors = 20146;
        
        PerfiosStructureBuilder.cls_LongTermBorrowings longTermBorr = new PerfiosStructureBuilder.cls_LongTermBorrowings();
        longTermBorr.SecuredLongTermBorrowings = secLongBorr;
        longTermBorr.UnSecuredLongTermBorrowings = unSecLongBorr;
        
        PerfiosStructureBuilder.cls_NonCurrentLiabilitiesOrLongTermLiabilities longTermLiab = new PerfiosStructureBuilder.cls_NonCurrentLiabilitiesOrLongTermLiabilities();
        longTermLiab.DeferredTaxLiabilities = 20147;
        longTermLiab.LongTermBorrowings = longTermBorr;
        longTermLiab.LongTermProvisions = longTermProv;
        longTermLiab.OtherLongTermLiabilities = othrsLongTermLiab;
        
        PerfiosStructureBuilder.cls_ForeignCurrencyTranslationReserve currTrans = new PerfiosStructureBuilder.cls_ForeignCurrencyTranslationReserve();
        currTrans.AddEffectOfForeignExchangeRateVariationsDuringTheYear = 20148;
        
        PerfiosStructureBuilder.cls_GeneralReserve genReserve = new PerfiosStructureBuilder.cls_GeneralReserve();
        genReserve.AddTransferredFromSurplusInStatementOfProfitAndLoss = 20149;
        
        PerfiosStructureBuilder.cls_CapitalReserve capRes = new PerfiosStructureBuilder.cls_CapitalReserve();
        capRes.AddAdditionsDuringTheYear = 20150;
        
        PerfiosStructureBuilder.cls_CapitalRedemptionReserve redRes = new PerfiosStructureBuilder.cls_CapitalRedemptionReserve ();
        redRes.AddAdditionsDuringTheYear = 20151;
        
        PerfiosStructureBuilder.cls_SecuritiesPremiumAccount premAcc = new PerfiosStructureBuilder.cls_SecuritiesPremiumAccount();
        premAcc.AddAdditionsDuringTheYear = 20152;
        
        PerfiosStructureBuilder.cls_HedgingReserve hedgRes = new PerfiosStructureBuilder.cls_HedgingReserve();
        hedgRes.AddEffectOfForeignExchangeRateVariationsOnHedgingInstrumentsOutstandingAtTheEndOfTheYear = 20153;
        
        PerfiosStructureBuilder.cls_RevaluationReserve revResv = new PerfiosStructureBuilder.cls_RevaluationReserve();
        revResv.ClosingBalance = 20056;
		revResv.OpeningBalance = 20052;
		revResv.TransferredDuringTheYear = 20055;
		revResv.AddAdditionOnRevaluationsDuringTheYear = 20053;
		revResv.LessUtilisedDuringTheYear = 20054;
        
        PerfiosStructureBuilder.cls_ShareOptionsOutstandingAccount outAcc = new PerfiosStructureBuilder.cls_ShareOptionsOutstandingAccount();
        outAcc.ClosingBalance = 20056;
		outAcc.OpeningBalance = 20052;
		outAcc.TransferredDuringTheYear = 20055;
		//outAcc.AdditionOnRevaluationsDuringTheYear = 20053;
		outAcc.LessUtilisedDuringTheYear = 20054;
        
        PerfiosStructureBuilder.cls_DebentureRedemptionReserve debResv = new PerfiosStructureBuilder.cls_DebentureRedemptionReserve();
       	debResv.ClosingBalance = 20056;
		debResv.OpeningBalance = 20052;
		debResv.TransferredDuringTheYear = 20055;
		//debResv.AddAdditionOnRevaluationsDuringTheYear = 20053;
		debResv.LessUtilisedDuringTheYear = 20054;
        
        PerfiosStructureBuilder.cls_OtherReserves othrResv = new PerfiosStructureBuilder.cls_OtherReserves();
       	othrResv.ClosingBalance = 20056;
		othrResv.OpeningBalance = 20052;
		othrResv.TransferredDuringTheYear = 20055;
        
        PerfiosStructureBuilder.cls_SurplusOrDeficitInTheStatementOfProfitAndLoss surplus = new PerfiosStructureBuilder.cls_SurplusOrDeficitInTheStatementOfProfitAndLoss();
        surplus.ClosingBalance = 20056;
		surplus.OpeningBalance = 20052;
		surplus.TransferredDuringTheYear = 20055;
        
        PerfiosStructureBuilder.cls_SurplusToBeDistributedToThePartners surDist = new PerfiosStructureBuilder.cls_SurplusToBeDistributedToThePartners();
        surDist.ClosingBalance = 20056;
		surDist.OpeningBalance = 20052;
		surDist.TransferredDuringTheYear = 20055;
        
        
        PerfiosStructureBuilder.cls_ReserveAndSurplus resSur = new PerfiosStructureBuilder.cls_ReserveAndSurplus();
        resSur.CapitalRedemptionReserve = redRes;
        resSur.CapitalReserve = capRes;
        resSur.GeneralReserve = genReserve;
        resSur.ForeignCurrencyTranslationReserve = currTrans;
        resSur.SecuritiesPremiumAccount = premAcc;
        resSur.HedgingReserve = hedgRes;
        resSur.SurplusToBeDistributedToThePartners = surDist;
        resSur.SurplusOrDeficitInTheStatementOfProfitAndLoss = surplus;
        resSur.OtherReserves = othrResv;
        resSur.DebentureRedemptionReserve = debResv;
        resSur.ShareOptionsOutstandingAccount = outAcc;
        resSur.RevaluationReserve = revResv;
        
        PerfiosStructureBuilder.cls_PartnersCurrentAccount partCurrAcc = new PerfiosStructureBuilder.cls_PartnersCurrentAccount();
        partCurrAcc.PartnerA = 19971;
        
        PerfiosStructureBuilder.cls_PartnersCapitalAccount partCapAcc = new PerfiosStructureBuilder.cls_PartnersCapitalAccount();
        partCapAcc.PartnerA = 19972;
        
        PerfiosStructureBuilder.cls_InCaseOfPropreitershipOrPartnership propPart = new PerfiosStructureBuilder.cls_InCaseOfPropreitershipOrPartnership();
        propPart.PartnersCapitalAccount = partCapAcc;
        propPart.PartnersCurrentAccount = partCurrAcc;
        
       
        
        PerfiosStructureBuilder.cls_EquityShareCapital equCap = new PerfiosStructureBuilder.cls_EquityShareCapital();
        equCap.Others = 19887;
        
        PerfiosStructureBuilder.cls_PreferenceShareCapital prefCap = new PerfiosStructureBuilder.cls_PreferenceShareCapital();
        prefCap.Others = 19902;
        
        PerfiosStructureBuilder.cls_AuthorisedShareCapital authCap = new PerfiosStructureBuilder.cls_AuthorisedShareCapital();
        authCap.EquityShareCapital = 19868;
        authCap.PreferenceShareCapital = 19869;
        authCap.TotalOfAuthorisedShareCapital = 19870;
        
        PerfiosStructureBuilder.cls_SubscribedAndFullyPaidUp fullyPaid = new PerfiosStructureBuilder.cls_SubscribedAndFullyPaidUp();
        fullyPaid.EquityShareCapital = equCap;
        fullyPaid.PreferenceShareCapital = prefCap;
        
        PerfiosStructureBuilder.cls_SubscribedButNotFullyPaidUp notFullypaid = new PerfiosStructureBuilder.cls_SubscribedButNotFullyPaidUp();
        notFullypaid.EquityShareCapital = 19909;
		notFullypaid.TotalOfSubscribedButNotFullyPaidUpCapital = 19911;
		notFullypaid.PreferenceShareCapital = 19910;
        
        PerfiosStructureBuilder.cls_IssuedCapital issuCap = new PerfiosStructureBuilder.cls_IssuedCapital();
        issuCap.EquityShareCapital = 19873;
		issuCap.TotalOfIssuedCapital = 19875;
		issuCap.PreferenceShareCapital = 19874;
        
        PerfiosStructureBuilder.cls_InCaseOfCorporates corp = new PerfiosStructureBuilder.cls_InCaseOfCorporates();
        corp.AuthorisedShareCapital = authCap;
        corp.IssuedCapital = issuCap;
        corp.SubscribedAndFullyPaidUp = fullyPaid;
        corp.SubscribedButNotFullyPaidUp = notFullypaid;
        
        PerfiosStructureBuilder.cls_ShareCapital shareCap = new PerfiosStructureBuilder.cls_ShareCapital();
        shareCap.InCaseOfCorporates = corp;
        shareCap.InCaseOfPropreitershipOrPartnership = propPart;
        shareCap.Total = 19973;
        
        PerfiosStructureBuilder.cls_ShareholdersFunds funds = new PerfiosStructureBuilder.cls_ShareholdersFunds();
        funds.MoneyReceivedAgainstShareWarrants = 19974;
        funds.ReserveAndSurplus = resSur;
        funds.ShareCapital = shareCap;
        
        PerfiosStructureBuilder.cls_EquitiesAndLiabilities equiLiab = new PerfiosStructureBuilder.cls_EquitiesAndLiabilities();
        equiLiab.CurrentLiabilitiesOrShortTermLiabilities = currLiab;
        equiLiab.NonCurrentLiabilitiesOrLongTermLiabilities = longTermLiab;
        equiLiab.ShareApplicationMoneyPendingAllotment =  null;
        equiLiab.ShareholdersFunds = funds;
        
        PerfiosStructureBuilder.cls_InvestmentInPreferenceShares invPref = new PerfiosStructureBuilder.cls_InvestmentInPreferenceShares();
        invPref.OfSubsidiaries = 20398;
        invPref.OfJointVentureCompanies = 20400;
        invPref.OfOtherEntities = 20402;
        invPref.Total = 20403;
        invPref.OfAssociates = 20399;
        invPref.OfControlledSpecialPurposeEntities = 20401;
        
        PerfiosStructureBuilder.cls_InvestmentInDebenturesOrBonds invBonds = new PerfiosStructureBuilder.cls_InvestmentInDebenturesOrBonds();
        invBonds.OfAssociates = 20552;
        invBonds.OfControlledSpecialPurposeEntities = 20553;
        invBonds.OfJointVentureCompanies = 20554;
        invBonds.OfOtherEntities = 20555;
        
        PerfiosStructureBuilder.cls_InvestmentInEquityInstruments invEquInst = new PerfiosStructureBuilder.cls_InvestmentInEquityInstruments();
        invEquInst.OfAssociates = 20556;
        invEquInst.OfControlledSpecialPurposeEntities = 20557;
        invEquInst.OfJointVentureCompanies = 20558;
        invEquInst.OfOtherEntities = 20559;
        invEquInst.OfSubsidiaries = 20560;
        
        PerfiosStructureBuilder.cls_InvestmentInGovernmentAndTrustSecurities invTruSec = new PerfiosStructureBuilder.cls_InvestmentInGovernmentAndTrustSecurities();
        invTruSec.GovernmentSecurities = 20561;
        
        PerfiosStructureBuilder.cls_InvestmentProperty invPro = new PerfiosStructureBuilder.cls_InvestmentProperty();
        invPro.GrossTotalOfInvestmentProperty = 20562;
        
        
        PerfiosStructureBuilder.cls_OtherInvestments othrInvest = new PerfiosStructureBuilder.cls_OtherInvestments();
        othrInvest.InvestmentInDebenturesOrBonds = invBonds;
        othrInvest.InvestmentInEquityInstruments = invEquInst;
        othrInvest.InvestmentInGovernmentAndTrustSecurities = invTruSec;
        othrInvest.InvestmentInMutualFunds = 19975;
        othrInvest.InvestmentInPreferenceShares = invPref;
        othrInvest.InvestmentProperty = invPro;
        othrInvest.OtherLongTermInvestments = 19976;
        
        PerfiosStructureBuilder.cls_TradeInvestments tradeInves = new PerfiosStructureBuilder.cls_TradeInvestments();
        tradeInves.InvestmentInDebenturesOrBonds = invBonds;
        tradeInves.InvestmentInEquityInstruments = invEquInst;
        tradeInves.InvestmentInGovernmentAndTrustSecurities = invTruSec;
        tradeInves.InvestmentProperty = invPro;
        tradeInves.InvestmentInPreferenceShares = invPref;
        
        PerfiosStructureBuilder.cls_NonCurrentInvestments nonCurrInv = new PerfiosStructureBuilder.cls_NonCurrentInvestments();
        nonCurrInv.OtherInvestments = othrInvest;
        nonCurrInv.Total = 19977;
        nonCurrInv.TradeInvestments = tradeInves;
        
        PerfiosStructureBuilder.cls_OtherNonCurrentAssets othrNonCurr = new PerfiosStructureBuilder.cls_OtherNonCurrentAssets();
        othrNonCurr.ContractuallyReimbursableExpenses = 20529;
        othrNonCurr.Others = 20530;
        
        PerfiosStructureBuilder.cls_BalancesWithGovernmentAuthorities balGovAuth = new PerfiosStructureBuilder.cls_BalancesWithGovernmentAuthorities();
        balGovAuth.VATCreditReceivable = 20444;
        balGovAuth.CENVATCreditReceivable = 20445;
        balGovAuth.TotalBalancesWithGovernmentAuthorities = 20446;
        balGovAuth.ServiceTaxCreditReceivable = 20447;
        balGovAuth.OtherReceivables = 20448;
        
        PerfiosStructureBuilder.cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowLoans = new PerfiosStructureBuilder.cls_AllowanceForBadAndDoubtfulLoansAndAdvances();
        AllowLoans.FromOthers = 20453;
        AllowLoans.FromRelatedParties = 20454;
        
        PerfiosStructureBuilder.cls_PrepaidExpenses prePaidExp = new PerfiosStructureBuilder.cls_PrepaidExpenses();
        prePaidExp.AnnualMaintnanceContracts = 20436;
        prePaidExp.OtherPrepaidExpenses = 20437;
        prePaidExp.InsurancePremium = 20438;
        prePaidExp.TotalPrepaidExpenses = 20439;
        
        PerfiosStructureBuilder.cls_SecuredLongTermLoansAndAdvances loansAdv = new PerfiosStructureBuilder.cls_SecuredLongTermLoansAndAdvances();
        loansAdv.AllowanceForBadAndDoubtfulLoansAndAdvances = AllowLoans;
        loansAdv.BalancesWithGovernmentAuthorities = balGovAuth;
        loansAdv.PrepaidExpenses = prePaidExp;
        loansAdv.CapitalAdvances = 20430;
        loansAdv.LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany = 20455;
        loansAdv.LoansAndAdvancesToEmployees = 20456;
        loansAdv.LoansAndAdvancesToEmployees = 20457;
        // loansAdv.InterCorporateDeposits = 20458;
        loansAdv.LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany = 20678;
        
        
        
        PerfiosStructureBuilder.cls_UnsecuredLongTermLoansAndAdvances unsecLoans = new PerfiosStructureBuilder.cls_UnsecuredLongTermLoansAndAdvances();
        unsecLoans.OtherLoansAndAdvances = 20477;
        unsecLoans.BalancesWithGovernmentAuthorities = balGovAuth;
        unsecLoans.PrepaidExpenses = prePaidExp;
        unsecLoans.AllowanceForBadAndDoubtfulLoansAndAdvances = AllowLoans;
        
        PerfiosStructureBuilder.cls_DoubtfulLongTermLoansAndAdvances doubtLoans = new PerfiosStructureBuilder.cls_DoubtfulLongTermLoansAndAdvances();
        doubtLoans.AllowanceForBadAndDoubtfulLoansAndAdvances = AllowLoans;
        doubtLoans.BalancesWithGovernmentAuthorities = balGovAuth;
        doubtLoans.PrepaidExpenses = prePaidExp;
        
        PerfiosStructureBuilder.cls_LongTermLoansAndAdvances longTermsLoan = new PerfiosStructureBuilder.cls_LongTermLoansAndAdvances();
        longTermsLoan.DoubtfulLongTermLoansAndAdvances = doubtLoans;
        longTermsLoan.SecuredLongTermLoansAndAdvances = loansAdv;
        longTermsLoan.UnsecuredLongTermLoansAndAdvances = unsecLoans;
        
        PerfiosStructureBuilder.cls_InTangibleAssetsDepreciation inTanAssDep = new PerfiosStructureBuilder.cls_InTangibleAssetsDepreciation();
        inTanAssDep.LicensesAndFranchise = 67895;
        inTanAssDep.Others = 67896;
        
        PerfiosStructureBuilder.cls_InTangibleAssetsGrossBlock inTanGross = new PerfiosStructureBuilder.cls_InTangibleAssetsGrossBlock();
        inTanGross.LicensesAndFranchise = 67897;	
        inTanGross.Others = 67898;
        
        PerfiosStructureBuilder.cls_InTangibleAssetsNet inTanAssNet = new PerfiosStructureBuilder.cls_InTangibleAssetsNet();
        inTanAssNet.LicensesAndFranchise = 67897;	
        inTanAssNet.Others = 67898;
        
        PerfiosStructureBuilder.cls_TangibleAssetsDepreciation tanAssDep = new PerfiosStructureBuilder.cls_TangibleAssetsDepreciation();
        tanAssDep.Buildings = 67872;
        tanAssDep.Computers = 67873;
        
        PerfiosStructureBuilder.cls_TangibleAssetsNet tanAssNet = new PerfiosStructureBuilder.cls_TangibleAssetsNet();
        tanAssNet.Buildings = 67874;
        tanAssNet.Computers = 67875;
        
        PerfiosStructureBuilder.cls_TangibleAssetsGrossBlock tanAssGross = new PerfiosStructureBuilder.cls_TangibleAssetsGrossBlock();
        tanAssGross.Buildings = 67876;
        tanAssGross.Computers = 67877;
        
        PerfiosStructureBuilder.cls_TangibleAssets tangAsst = new PerfiosStructureBuilder.cls_TangibleAssets();
        tangAsst.TangibleAssetsDepreciation = tanAssDep;
        tangAsst.TangibleAssetsGrossBlock = tanAssGross;
        tangAsst.TangibleAssetsNet = tanAssNet;
        
        
        
        PerfiosStructureBuilder.cls_InTangibleAssets inTangAss = new PerfiosStructureBuilder.cls_InTangibleAssets();
        inTangAss.InTangibleAssetsDepreciation = inTanAssDep;
        inTangAss.InTangibleAssetsGrossBlock = inTanGross;
        inTangAss.InTangibleAssetsNet = inTanAssNet;
        
        PerfiosStructureBuilder.cls_FixedAssets fixAsst = new PerfiosStructureBuilder.cls_FixedAssets();
        fixAsst.CapitalWorkInProgress = 20340;
        fixAsst.InTangibleAssets = inTangAss;
        fixAsst.TangibleAssets = tangAsst;
        
        PerfiosStructureBuilder.cls_LongTermLoansAndAdvances longTermLoans = new PerfiosStructureBuilder.cls_LongTermLoansAndAdvances();
        longTermLoans.DoubtfulLongTermLoansAndAdvances = doubtLoans;
        longTermLoans.SecuredLongTermLoansAndAdvances = loansAdv;
        longTermLoans.UnsecuredLongTermLoansAndAdvances = unsecLoans;
        
        PerfiosStructureBuilder.cls_NonCurrentAssets nonCurrAss = new PerfiosStructureBuilder.cls_NonCurrentAssets();
        nonCurrAss.DeferredTaxAssets = 20424;
        nonCurrAss.FixedAssets = fixAsst;
        nonCurrAss.LongTermLoansAndAdvances = longTermLoans;
        nonCurrAss.NonCurrentInvestments = nonCurrInv;
        nonCurrAss.OtherNonCurrentAssets = othrNonCurr;
        
        PerfiosStructureBuilder.cls_PreferenceShareCapital prefShareCap = new PerfiosStructureBuilder.cls_PreferenceShareCapital();
        prefShareCap.BonusIssue = 20425;
        prefShareCap.CallsUnpaidByOthers = 20426;
        
        PerfiosStructureBuilder.cls_CurrentPortionOfLongTermInvestments currLongInv = new PerfiosStructureBuilder.cls_CurrentPortionOfLongTermInvestments();
        currLongInv.InvestmentInMutualFunds = 20544;
        currLongInv.GrossTotalOfCurrentPortionOfLongTermInvestments = 20545;
        currLongInv.InvestmentInDebenturesOrBonds = 20546;
        currLongInv.InvestmentInGovernmentSecurities = 20547;
        currLongInv.InvestmentInTrustSecurities = 20548;
        currLongInv.LessProvisionForDiminutionInValueOfCurrentPortionOfLongTermInvestments = 20549;
        currLongInv.NetOfCurrentPortionOfLongTermInvestments = 20550;
        currLongInv.OtherInvestments = 20551;
        
        
        PerfiosStructureBuilder.cls_CurrentInvestments currInv = new PerfiosStructureBuilder.cls_CurrentInvestments();
        currInv.CurrentPortionOfLongTermInvestments = currLongInv;
        currInv.InvestmentInDebenturesOrBonds = invBonds;
        currInv.InvestmentInEquityInstruments = invEquInst;
        currInv.InvestmentInGovernmentAndTrustSecurities = invTruSec;
       	currInv.InvestmentInPreferenceShares = invPref;
        currInv.InvestmentInPartnershipFirms = 20425;
        currInv.InvestmentProperty = invPro;
        currInv.Total = 20426;
        currInv.InvestmentInMutualFunds = 20584;
        currInv.OtherCurrentInvestments = 20585;
        
        
        
        PerfiosStructureBuilder.cls_DoubtfulShortTermLoansAndAdvances shrtTrm = new PerfiosStructureBuilder.cls_DoubtfulShortTermLoansAndAdvances();
        shrtTrm.AdvanceTax = 20427;
        shrtTrm.AllowanceForBadAndDoubtfulLoansAndAdvances = AllowLoans;
        shrtTrm.PrepaidExpenses = prePaidExp;
        shrtTrm.BalancesWithGovernmentAuthorities = balGovAuth;
        shrtTrm.OtherLoansAndAdvances = 20725;
        shrtTrm.NetDoubtfulShortTermLoanAndAdvances = 20726;
        shrtTrm.TotalOfDoubtfulShortTermLoanAndAdvances = 20727;
        shrtTrm.SecurityDeposits = 20728;
        shrtTrm.LoansAndAdvancesToRelatedParties = 20729;
        shrtTrm.LoansAndAdvancesToEmployees = 20710;
        shrtTrm.InterCorporateDeposits = 20711;
        shrtTrm.LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany = 20732;
        
        PerfiosStructureBuilder.cls_UnSecuredShortTermLoansAndAdvances unSec= new PerfiosStructureBuilder.cls_UnSecuredShortTermLoansAndAdvances();
        unSec.AdvanceTax = 20428;
        unSec.AllowanceForBadAndDoubtfulLoansAndAdvances = AllowLoans;
        unSec.BalancesWithGovernmentAuthorities = balGovAuth;
        unSec.PrepaidExpenses = prePaidExp;
        
        PerfiosStructureBuilder.cls_SecuredShortTermLoansAndAdvances secShrtTerm = new PerfiosStructureBuilder.cls_SecuredShortTermLoansAndAdvances();
        secShrtTerm.AdvanceTax = 20429;
        secShrtTerm.AllowanceForBadAndDoubtfulLoansAndAdvances = AllowLoans;
        secShrtTerm.BalancesWithGovernmentAuthorities = balGovAuth;
        secShrtTerm.PrepaidExpenses = prePaidExp;
        secShrtTerm.TotalOfSecuredShortTermLoanAndAdvances = 20430;
        secShrtTerm.SecurityDeposits = 20654;
        secShrtTerm.NetSecuredShortTermLoanAndAdvances = 20677;
        secShrtTerm.LoansAndAdvancesToRelatedParties = 20678;
        
        
        PerfiosStructureBuilder.cls_ShortTermLoansAndAdvances shtTermLoans = new PerfiosStructureBuilder.cls_ShortTermLoansAndAdvances();
        shtTermLoans.DoubtfulShortTermLoansAndAdvances = shrtTrm;
        shtTermLoans.SecuredShortTermLoansAndAdvances = secShrtTerm;
        shtTermLoans.Total = 20431;
        shtTermLoans.UnSecuredShortTermLoansAndAdvances = unSec;
        
        PerfiosStructureBuilder.cls_ExceedingSixMonths excSixmnths = new PerfiosStructureBuilder.cls_ExceedingSixMonths();
        excSixmnths.DebtDueByDirectorsothersOfficersOfTheCompany = 20432;
        excSixmnths.Doubtful = 20433;
        
        PerfiosStructureBuilder.cls_WithinSixMonths withinSixmnts = new PerfiosStructureBuilder.cls_WithinSixMonths();
        withinSixmnts.DebtDueByDirectorsothersOfficersOfTheCompany = 20434;
        withinSixmnts.Doubtful = 20435;
        
        PerfiosStructureBuilder.cls_TradeReceivablesOrSundryDebtors traderec = new PerfiosStructureBuilder.cls_TradeReceivablesOrSundryDebtors();
        traderec.ExceedingSixMonths = excSixmnths;
        traderec.Total = 20436;
        traderec.WithinSixMonths = withinSixmnts;
        
        PerfiosStructureBuilder.cls_OtherCurrentAssets othrAsst = new PerfiosStructureBuilder.cls_OtherCurrentAssets();
        othrAsst.AncillaryBorrowingCosts = 20437;
        othrAsst.BalanceWithGovernmentAuthorities = 20438;
        
        PerfiosStructureBuilder.cls_InEarmarkedAccounts inAcc = new PerfiosStructureBuilder.cls_InEarmarkedAccounts();
        inAcc.OtherEarmarkedAccounts = 20439;
        inAcc.UnpaidDividendAccounts = 20440;
        
        PerfiosStructureBuilder.cls_BalancesWithBanks balWithBanks = new PerfiosStructureBuilder.cls_BalancesWithBanks();
        balWithBanks.InCurrentAccounts = 20441;
        balWithBanks.InDepositAccounts = 20442;
        balWithBanks.InEarmarkedAccounts = inAcc;
        balWithBanks.InEEFCAccounts = 20638;
        balWithBanks.InFlexiDepositAccounts = 20639;
        
        PerfiosStructureBuilder.cls_CashAndCashEquivalents cashEqu = new PerfiosStructureBuilder.cls_CashAndCashEquivalents();
        cashEqu.BalancesWithBanks = balWithBanks;
        cashEqu.CashOnHand = 20640;
        cashEqu.ChequesDraftsOnHand = 20641;
        
        PerfiosStructureBuilder.cls_Inventories inven = new PerfiosStructureBuilder.cls_Inventories();
        inven.FinishedGoods = 20642;
        inven.GoodsInTransit = 20643;
        
        PerfiosStructureBuilder.cls_CurrentAssets currAssts = new PerfiosStructureBuilder.cls_CurrentAssets();
        currAssts.CashAndCashEquivalents = cashEqu;
        currAssts.CurrentInvestments = currInv;
        currAssts.Inventories = inven;
        currAssts.OtherCurrentAssets = othrAsst;
        currAssts.ShortTermLoansAndAdvances = shtTermLoans;
        currAssts.TradeReceivablesOrSundryDebtors = traderec;
        
        PerfiosStructureBuilder.cls_BS_Assets bsAssts = new PerfiosStructureBuilder.cls_BS_Assets();
        bsAssts.CurrentAssets = currAssts;
        bsAssts.NonCurrentAssets = nonCurrAss;
        bsAssts.Total = 20644;
        
        PerfiosStructureBuilder.BalanceSheetParse balSheetParse = new PerfiosStructureBuilder.BalanceSheetParse();
        balSheetParse.Assets = bsAssts;
        balSheetParse.EquitiesAndLiabilities = equiLiab;
        
        Test.startTest();
        PerfiosRequestHandler.inserBSheet(balSheetParse, per.Id);
        test.stopTest();
        
        
        
    }
    
}