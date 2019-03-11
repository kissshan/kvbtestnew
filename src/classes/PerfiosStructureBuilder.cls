/*
* Name          : PerfiosStructureBuilder
* Description   : Structurize Perfios data, to be inserted in the system
* Author        : Dushyant
*/
public class PerfiosStructureBuilder {
    //Parsing Ratios Data
    public class RatiosParse{
        public cls_MiscellaneousItems MiscellaneousItems;
        public cls_Assets Assets;
        public cls_Liabilities Liabilities;
        public cls_CalculationOfCashProfits CalculationOfCashProfits;
        public cls_PLItems PLItems;
        public cls_FinancialRatios FinancialRatios;
        public cls_CalculationOfNetOperatingIncome CalculationOfNetOperatingIncome;
    }
	public class cls_MiscellaneousItems {
		public Decimal LongTermBorrowings;	//67672
		public Decimal QuickAssetsExcludingDebtors;	//340940
		public Decimal ShortTermBorrowings;	//67754
		public Decimal CreditorsForGoods;	//135589
		public Decimal InvestmentInGroupCompanies;	//12
		public Decimal OutsideLiabilities;	//135426
		public Decimal QuickAssetsExcludingDebtorsMoreThan6MonthsAndInventories;	//340976
		public Decimal CapitalEmployedOrNetAssets;	//749620
		public Decimal DebtService;	//546627
		public Decimal EmployeeCosts;	//68457
		public Decimal WorkingCapitalGap;	//273529
		public Decimal RawMaterialCostsOrPurchasesOfStockinTrade;	//68446
		public Decimal QuickAssetsExcludingInventories;	//409152
		public Decimal SalesAdvertisingOrMarketingExpenses;	//68625
	}
	public class cls_Assets {
		public Decimal NetFixedAssets;	//271550
		public Decimal TotalNonCurrentAssets;	//543496
		public Decimal Inventories;	//68149
		public Decimal CashCashEquivalents;	//68190
		public Decimal OtherCurrentAssets;	//68297
		public Decimal ShortTermInvestments;	//68095
		public Decimal ShortTermLoansAdvances;	//68209
		public Decimal TotalAssets;	//1020797
		public Decimal TotalCurrentAssets;	//477301
		public Decimal TradeReceivablesDebtorsLessThan6Months;	//68185
		public Decimal TradeReceivablesDebtorsMoreThan6Months;	//68176
	}
	public class cls_Liabilities {
		public Decimal Reserves;	//51
		public Decimal TotalLiabilities;	//541759
		public Decimal LongTermDebt;	//203111
		public Decimal PaidUpCapitalPartnersContribution;	//67420
		public Decimal ShortTermDebt;	//271177
		public Decimal TangibleNetworthOwnersEquityShareholdersEquityProprietaryFund;	//67471
		public Decimal TradePayables;	//67788
		public Decimal Provisions;	//135563
	}
	public class cls_CalculationOfCashProfits {
		public Decimal Interest;	//-137073
		public Decimal CashProfits;	//137257
		public Decimal Sales;	//68373
		public Decimal ProfitBeforeInterestAndTaxOperatingProfit;	//69058
		public Decimal ProfitBeforeDepreciationAndAmortisationInterestAndTax;	//137601
		public Decimal TotalExpenses;	//-837
		public Decimal OtherIncome;	//68391
		public Decimal Tax;	//137417
		public Decimal TotalIncome;	//136764
		public Decimal ProfitAfterTax;	//68714
		public Decimal DepreciationAndAmortisation;	//68543
		public Decimal ProfitBeforeTax;	//206131
	}
	public class cls_PLItems {
		public Decimal DirectExpenses;	//68580
		public Decimal ChangesInInventories;	//68447
		public Decimal GrossProfit;	//-205536
		public Decimal SalesRevenueFromOperations;	//68373
		public Decimal CostOfMaterialsConsumed;	//68436
		public Decimal PurchasesOfStockInTrade;	//68446
	}
	public class cls_FinancialRatios {
		public cls_RatiosAppearingInProfitAndLossAccount RatiosAppearingInProfitAndLossAccount;
		public cls_RatiosAppearingInBalanceSheet RatiosAppearingInBalanceSheet;
	}
	public class cls_RatiosAppearingInProfitAndLossAccount {
		public cls_ProfitabilityRatios ProfitabilityRatios;
	}
	public class cls_ProfitabilityRatios {
		public Double ReturnOnEquity;	//1.01842272976538
		public Double ReturnOnInvestment;	//0.0921240094981457
		public Double GrossMargin;	//-3.00609889868808
		public Double CashProfitMargin;	//2.00747371038275
		public Double ReturnOnCapitalEmployed;	//-0.0911915370454364
		public Double ReturnOnAssets;	//0.0673140693007523
        public Double OperatingProfitRatio;	//1.0329121222313
		public Decimal NetMargin;	//#REF!
	}
	public class cls_RatiosAppearingInBalanceSheet {
		public cls_OtherRatios OtherRatios;
		public cls_TurnoverRatios TurnoverRatios;
		public cls_LeverageRatios LeverageRatios;
		public cls_ShortTermSolvencyRatios ShortTermSolvencyRatios;
	}
	public class cls_OtherRatios {
		public Double TotalLiabilitiesTangibleNetworth;	//8.02950897422596
		public Double EmployeeCostsSales;	//1.00122855513141
		public Double CurrentAssetsSales;	//6.98084039021251
		public Double InvestmentInGroupCompaniesNW;	//0.000177854189207215
		public Double TotalAssetsSales;	//14.9298261009463
		public Double RMCostsSales;	//1.00106767291182
		public Double MarketingExpensesSales;	//1.00368566539423
	}
	public class cls_TurnoverRatios {
		public Double NetAssetsTurnoverRatioCapitalTurnoverRatio;	//0.0912102131746752
		public Double CurrentAssetsTurnoverRatio;	//0.143249228474275
		public Double DebtorsDaysDebtorsCollectionPeriod;	//727.944729644743
		public Double TotalAssetsTurnoverRatio;	//0.0669800165948764
		public Double FixedAssetsTurnoverRatio;	//0.25178788436752
		public Double InventoryDaysStockReplenishmentPeriod;	//181.714735511772
		public Double WorkingCapitalTurnoverRatio;	//4.00054114928407
		public Double CreditorsDaysCreditorsPaymentPeriod;	//1117.66974151153
	}
	public class cls_LeverageRatios {
		public Double InterestCoverageRatio;	//-0.503804542105302
		public Double DebtRatio;	//0.132666925941201
		public Double DebtEquityRatio;	//2.00717345229802
		public Double EquityRatio;	//0.090006936848003
		public Double DebtServiceCoverageRatio;	//1.75925814129196
	}
	public class cls_ShortTermSolvencyRatios {
		public Double QuickRatioAcidTestRatioLiquidRatioExcludingInventories;	//1.50880052511828
		public Double QuickRatioAcidTestRatioLiquidRatioExcludingInventoriesAndDebtorsMoreThan6Months;	//1.25739277298591
		public Double QuickRatioAcidTestRatioLiquidRatioExcludingDebtors;	//1.25726001836439
		public Double CurrentRatio;	//1.76010871128451
	}
	public class cls_CalculationOfNetOperatingIncome {
		public Decimal NetOperatingIncome;	//961658
		public cls_LessNonCashIncome LessNonCashIncome;
		public cls_AddNonCashExpenses AddNonCashExpenses;
		public Decimal ProfitAfterTax;	//68714
	}
	public class cls_LessNonCashIncome {
		public Decimal ProfitGainOnSaleOfCurrentInvestments;	//68406
		public Decimal ProfitOnSaleOfFixedAssets;	//68420
		public Decimal LiabilitiesProvisionsNoLongerRequiredWrittenBack;	//68424
		public Decimal ProfitGainOnSaleOfLongTermInvestments;	//68407
		public Decimal NetGainOnForeignCurrencyTransactionsAndTranslation;	//68415
		public Decimal RentalIncomeIncludingRentFromOperatingLeases;	//68419
	}
	public class cls_AddNonCashExpenses {
		public Decimal Amortization;	//68548
		public Decimal InterestOnPartnersCapital;	//68676
		public Decimal NetLossOnForeignCurrencyTransactionsAndTranslation;	//68623
		public Decimal LossOnSaleOfLongTermInvestments;	//68620
		public Decimal Impairment;	//68645
		public Decimal PreliminaryExpensesWrittenOff;	//68613
		public Decimal IntangibleAssetsWrittenOffAmortised;	//68617
		public Decimal ExpenseOnEmployeeStockOptionScheme;	//68471
		public Decimal LossOnSaleOfCurrentInvestments;	//68619
		public Decimal LossOnSaleOfFixedAssets;	//68616
		public Decimal SalariesToPartnersDirectors;	//68677
		public Decimal DiscountOnIssueOfDebenturesWrittenOff;	//68615
		public Decimal PremiumOnRedemptionOfDebentures;	//68621
		public Decimal Depreciation;	//68547
		public Decimal InterestOnLoans;	//137067
		public Decimal PremiumOnRedemptionOfPreferenceShares;	//68622
		public Decimal BadTradeAndOtherReceivablesLoansAndAdvancesWrittenOff;	//68624
		public Decimal DiscountOnIssueOfSharesWrittenOff;	//68614
	}
	public static PerfiosStructureBuilder.RatiosParse ratioParser(String json){
		return (PerfiosStructureBuilder.RatiosParse) System.JSON.deserialize(json, PerfiosStructureBuilder.RatiosParse.class);
	}
    
    //Parsing ProfitAndLoss Data
    public class ProfitAndLossParse{
        public cls_StatementOfProfitAndLoss StatementOfProfitAndLoss;
    }
	public class cls_StatementOfProfitAndLoss {
		public Decimal InterestOnCapital;	//68676
		public cls_EarningsPerEquityShareAfterExtraordinaryItems EarningsPerEquityShareAfterExtraordinaryItems;
		public Decimal ProfitBeforeExtraordinaryItemsAndTax;	//68678
		public cls_Expenses Expenses;
		public Decimal ProfitFromDiscontinuingOperationsAfterTax;	//68713
		public Decimal TaxExpenseOfDiscontinuingOperations;	//68712
		public cls_ExceptionalItems ExceptionalItems;
		public cls_RevenueFromOperations RevenueFromOperations;
		public cls_TaxExpense TaxExpense;
		public Decimal ProfitBeforeExceptionalAndExtraordinaryItemsAndTaxProfitBeforeInterestOnCapitalRemunerationAndTax;	//68654
		public Decimal PartnersRemunerationSalary;	//68677
		public Decimal ProfitIeProfitAfterTax;	//68714
		public cls_BalanceCarriedToBalanceSheetInPropeitorAccount BalanceCarriedToBalanceSheetInPropeitorAccount;
		public cls_ExtraordinaryItems ExtraordinaryItems;
		public Decimal TrasferredToReservesAndSurplus;	//68717
		public Decimal BalanceBroughtForwardFromPreviousYear;	//68715
		public Decimal ProfitForThePeriodFromContinuingOperations;	//68710
		public Decimal TotalRevenue;	//68434
		public Decimal ProfitFromDiscontinuingOperations;	//68711
		public cls_NonOperatingIncome NonOperatingIncome;
		public Decimal AmountAvailableForAppropriations;	//68716
		public cls_EarningsPerEquityShareBeforeExtraordinaryItems EarningsPerEquityShareBeforeExtraordinaryItems;
		public Decimal ProfitBeforeTax;	//68706
	}
	public class cls_EarningsPerEquityShareAfterExtraordinaryItems {
		public Decimal Basic;	//68749
		public Decimal Diluted;	//68750
	}
	public class cls_Expenses {
		public cls_OtherExpenses OtherExpenses;
		public cls_ChangesInInventories ChangesInInventories;
		public cls_ManagerialRemuneration ManagerialRemuneration;
		public Decimal TotalExpenses;	//68653
		public cls_FinanceCost FinanceCost;
		public cls_CostOfMaterialsConsumed CostOfMaterialsConsumed;
		public Decimal PurchasesOfStockInTrade;	//68446
		public cls_InsuranceExpenses InsuranceExpenses;
		public cls_PowerAndFuel PowerAndFuel;
		public cls_AuditorsFees AuditorsFees;
		public cls_EmployeeBenefitExpenses EmployeeBenefitExpenses;
		public cls_DepreciationAndAmortizationExpenses DepreciationAndAmortizationExpenses;
	}
	public class cls_OtherExpenses {
		public cls_DirectExpenses DirectExpenses;
		public Decimal GrandTotalOfOtherExpenses;	//68651
		public cls_InDirectExpenses InDirectExpenses;
	}
	public class cls_DirectExpenses {
		public Decimal FreightFreightInwards;	//68557
		public Decimal FactoryExpenses;	//68577
		public Decimal OtherDirectExpenses;	//68578
		public cls_Electricity Electricity;
		public Decimal WagesLabourCharges;	//68559
		public cls_RepairsAndMaintenance RepairsAndMaintenance;
		public Decimal Commission;	//68576
		public Decimal TotalOfDirectExpenses;	//68580
		public Decimal CarriageInwards;	//68558
		public cls_InsuranceCharges InsuranceCharges;
		public cls_Rent Rent;
	}
	public class cls_Electricity {
		public Decimal Others;	//68563
		public Decimal Factory;	//68561
		public Decimal Godown;	//68562
	}
	public class cls_RepairsAndMaintenance {
		public Decimal Building;	//68593
		public Decimal Others;	//68594
        public Decimal PlantAndMachinery;	//68594
	}
	public class cls_InsuranceCharges {
		public Decimal Others;	//68571
		public Decimal Factory;	//68569
		public Decimal Godown;	//68570
	}
	public class cls_Rent {
		public Decimal Others;	//68591
		public Decimal LeaseRentals;	//68590
        public Decimal Factory;	//68590
        public Decimal Godown;	//68590
	}
	public class cls_InDirectExpenses {
		public Decimal Water;	//68588
		public Decimal Entertainment;	//68642
		public Decimal OtherTaxesPaid;	//68639
		public Decimal Impairment;	//68645
		public Decimal ProvisionForContingencies;	//68631
		public Decimal Conference;	//68643
		public Decimal DiscountOnIssueOfDebenturesWrittenOff;	//68615
		public Decimal PremiumOnRedemptionOfDebentures;	//68621
		public Decimal SecurityExpenses;	//68646
		public Decimal PremiumOnRedemptionOfPreferenceShares;	//68622
		public cls_TravellingAndConveyance TravellingAndConveyance;
		public Decimal DiscountOnIssueOfSharesWrittenOff;	//68614
		public Decimal PrintingAndStationery;	//68602
		public Decimal CommissionBrokerageExpenses;	//68608
		public Decimal NetLossOnForeignCurrencyTransactionsAndTranslation;	//68623
		public Decimal LicenseExpense;	//68599
		public Decimal DevelopmentAndTrainingExpenses;	//68640
		public Decimal UnderwritingCommission;	//68607
		public Decimal PreliminaryExpensesWrittenOff;	//68613
		public Decimal LossOnSaleOfFixedAssets;	//68616
		public Decimal TotalOfIndirectExpenses;	//68649
		public Decimal OfficeExpenses;	//68606
		public Decimal ProvisionForEstimatedLossesOnOnerousContracts;	//68630
		public Decimal WarrantiesExpense;	//68600
		public Decimal TelephoneExpensesCommunicationCharges;	//68605
		public Decimal Hospitality;	//68641
		public Decimal LegalAndProfessionalCharges;	//68612
		public cls_ProposedDividend ProposedDividend;
		public Decimal BusinessPromotion;	//68610
		public Decimal IncomeTaxPaid;	//68638
		public Decimal Subcontracting;	//68587
		public Decimal DonationAndContributions;	//68611
		public cls_ConsumptionOf ConsumptionOf;
		public Decimal Royalty;	//68644
		public Decimal ProfessionalFeesConsultancyFeesFeesForTechnicalServices;	//68604
		public Decimal SalesDiscountDiscountAllowed;	//68609
		public Decimal ProvisionForEstimatedLossOnDerivatives;	//68628
		public Decimal OtherExpenses;	//68647
		public Decimal ProvisionForDoubtfulTradeAndOtherReceivablesLoansAndAdvances;	//68627
		public Decimal AdvertisingMarketingExpenses;	//68625
		public Decimal IntangibleAssetsWrittenOffAmortised;	//68617
		public Decimal ProvisionForWarranty;	//68629
		public Decimal FreightExpenses;	//68601
		public Decimal PostageAndCourierExpenses;	//68603
		public Decimal BadTradeAndOtherReceivablesLoansAndAdvancesWrittenOff;	//68624
		public cls_RepairsAndMaintenance RepairsAndMaintenance;
		public cls_LossOnSaleOfInvestments LossOnSaleOfInvestments;
		public Decimal MiscellaneousExpensesWrittenOff;	//68648
		public cls_TaxOnDividend TaxOnDividend;
		public Decimal ProvisionForLossesInSubsidiaryCompanies;	//68626
		public cls_Rent Rent;
	}
	public class cls_TravellingAndConveyance {
		public Decimal ConveyanceExpenses;	//68598
		public Decimal DomesticTravellingExpenses;	//68596
		public Decimal ForeignTravellingExpenses;	//68597
	}
	public class cls_ProposedDividend {
		public Decimal PreferenceDividend;	//68633
		public Decimal EquityDividend;	//68634
	}
	public class cls_ConsumptionOf {
		public Decimal StoresAndSpareParts;	//68584
		public Decimal OtherMaterials;	//68586
		public Decimal LooseTools;	//68585
	}
	public class cls_LossOnSaleOfInvestments {
		public Decimal CurrentInvestments;	//68619
		public Decimal LongTermInvestments;	//68620
	}
	public class cls_TaxOnDividend {
		public Decimal PreferenceDividend;	//68636
		public Decimal EquityDividend;	//68637
	}
	public class cls_ChangesInInventories {
		public Decimal FinishedGoods;	//68451
		public Decimal Total;	//68455
		public Decimal WorkInProgress;	//68452
		public Decimal StockInTrade;	//68453
	}
	public class cls_ManagerialRemuneration {
		public Decimal PartTimeDirector;	//68487
		public Decimal WholeTimeDirector;	//68486
		public Decimal Total;	//68489
		public Decimal ManagingDirector;	//68485
		public Decimal Manager;	//68484
	}
	public class cls_FinanceCost {
		public Decimal Others;	//68539
		public Decimal ServiceChargesByOtherFinancialInstitutions;	//68538
		public Decimal Total;	//68541
		public cls_InterestExpense InterestExpense;
		public Decimal ServiceChargesByBankBankCharges;	//68537
		public Decimal QuasiInterest;	//68536
	}
	public class cls_InterestExpense {
		public Decimal OnOverdraft;	//68534
		public Decimal OnBankLoans;	//68532
		public Decimal OnCashCredits;	//68533
		public Decimal OnBondsDebentures;	//68531
		public Decimal OnOthers;	//68535
	}
	public class cls_CostOfMaterialsConsumed {
		public Decimal ClosingStock;	//68442
		public Decimal CostOfMaterialsConsumed;	//68444
		public Decimal OpeningStock;	//68440
		public Decimal Purchases;	//68441
	}
	public class cls_InsuranceExpenses {
		public Decimal KeymanInsurance;	//68510
		public Decimal LifeInsurance;	//68509
		public Decimal Total;	//68513
		public Decimal MedicalInsurance;	//68508
		public Decimal OtherInsurance;	//68511
	}
	public class cls_PowerAndFuel {
		public Decimal OtherFuelExpenses;	//68522
		public Decimal LiquidFuelExpenses;	//68520
		public Decimal Total;	//68524
		public Decimal ElectricityExpenses;	//68519
		public Decimal GaseousFuelExpenses;	//68521
	}
	public class cls_AuditorsFees {
		public Decimal OtherServices;	//68500
		public Decimal TaxationMatters;	//68497
		public Decimal Total;	//68502
		public Decimal ManagementServices;	//68499
		public Decimal StatuatoryServices;	//68496
		public Decimal CompanyLawMatters;	//68498
	}
	public class cls_EmployeeBenefitExpenses {
		public Decimal Others;	//68475
		public Decimal LeaveEncashment;	//68472
		public Decimal SalariesAndWages;	//68461
		public Decimal Total;	//68477
		public Decimal Bonus;	//68469
		public cls_ContributionsToFunds ContributionsToFunds;
		public Decimal ReimbursementOfMedicalExpenses;	//68470
		public Decimal ExpenseOnEmployeeStockOptionScheme;	//68471
		public Decimal LeaveTravelBenefits;	//68473
		public Decimal StaffWelfareExpenses;	//68474
	}
	public class cls_ContributionsToFunds {
		public Decimal ContributionToRecognisedProvidentFund;	//68463
		public Decimal ContributionToApprovedSuperannuationFund;	//68464
		public Decimal ContributionToOtherFunds;	//68466
		public Decimal TotalContributionsToProvidentAndOtherFunds;	//68467
		public Decimal ContributionToRecognisedGratuityFund;	//68465
	}
	public class cls_DepreciationAndAmortizationExpenses {
		public Decimal Depreciation;	//68547
		public Decimal Total;	//68550
		public Decimal Amortisation;	//68548
	}
	public class cls_ExceptionalItems {
		public cls_ExceptionalItemsWhichAreGains ExceptionalItemsWhichAreGains;
		public cls_ExceptionalItemsWhichAreLossses ExceptionalItemsWhichAreLossses;
		public Decimal Total;	//68674
	}
	public class cls_ExceptionalItemsWhichAreGains {
		public Decimal ProfitsGainsOnDisposalOfAssetsOtherThanFixedAssets;	//68661
		public Decimal AbnormalGainsOnLongTermContracts;	//68662
		public Decimal ProfitsGainsOnDisposalOfFixedAssets;	//68660
		public Decimal Total;	//68665
		public Decimal AmountsReceivedInSettlementOfInsuranceClaims;	//68663
		public Decimal OtherExceptionalItems;	//68664
	}
	public class cls_ExceptionalItemsWhichAreLossses {
		public Decimal LossesOnDisposalOfFixedAssets;	//68668
		public Decimal Total;	//68672
		public Decimal LossesOnDisposalOfAssetsOtherThanFixedAssets;	//68669
		public Decimal OtherExceptionalItems;	//68671
		public Decimal AbnormalLossesOnLongTermContracts;	//68670
	}
	public class cls_RevenueFromOperations {
		public cls_DomesticTurnover DomesticTurnover;
		public cls_ExportTurnover ExportTurnover;
		public Decimal Total;	//68390
	}
	public class cls_DomesticTurnover {
		public Decimal SaleOrSupplyOfServices;	//68379
		public Decimal NetDomesticTurnover;	//68382
		public Decimal LessExciseAndOtherDuties;	//68381
		public Decimal SaleOfGoodsManufactured;	//68377
		public Decimal SaleOfGoodsTraded;	//68378
		public Decimal OtherOperatingIncome;	//68380
	}
	public class cls_ExportTurnover {
		public Decimal SaleOrSupplyOfServices;	//68386
		public Decimal LessExciseAndOtherDuties;	//68388
		public Decimal SaleOfGoodsManufactured;	//68384
		public Decimal SaleOfGoodsTraded;	//68385
		public Decimal NetExportTurnover;	//68389
		public Decimal OtherOperatingIncome;	//68387
	}
	public class cls_TaxExpense {
		public Decimal CurrentTax;	//68708
		public Decimal DeferredTax;	//68709
	}
	public class cls_BalanceCarriedToBalanceSheetInPropeitorAccount {
		public Decimal PartnerA;	//68722
		public Decimal PartnerC;	//68724
		public Decimal PartnerB;	//68723
		public Decimal PartnerE;	//68726
		public Decimal PartnerD;	//68725
		public Decimal PartnerG;	//68728
		public Decimal PartnerF;	//68727
		public Decimal PartnerQ;	//68738
		public Decimal PartnerP;	//68737
		public Decimal PartnerS;	//68740
		public Decimal PartnerR;	//68739
		public Decimal PartnerT;	//68741
		public Decimal Total;	//68743
		public Decimal PartnerI;	//68730
		public Decimal PartnerH;	//68729
		public Decimal PartnerK;	//68732
		public Decimal PartnerJ;	//68731
		public Decimal PartnerM;	//68734
		public Decimal PartnerL;	//68733
		public Decimal PartnerO;	//68736
		public Decimal PartnerN;	//68735
	}
	public class cls_ExtraordinaryItems {
		public Decimal Total;	//68704
		public cls_ExtraordinaryItemsWhichAreGains ExtraordinaryItemsWhichAreGains;
		public cls_ExtraordinaryItemsWhichAreLossses ExtraordinaryItemsWhichAreLossses;
	}
	public class cls_ExtraordinaryItemsWhichAreGains {
		public Decimal GainsFromTheSaleOfAssets;	//68684
		public Decimal NegativeGoodwill;	//68686
		public Decimal InvestorsShareOfInvesteesExtraordinaryItems;	//68690
		public Decimal WinningALawSuit;	//68687
		public Decimal Total;	//68692
		public Decimal UnusualSalesOfAssets;	//68688
		public Decimal ReceiptOfLICPolicyAmountOnSuddenDeathOfCEOOtherKeyPersons;	//68689
		public Decimal OtherExtraordinaryItems;	//68691
		public Decimal GainsFromEarlyRetirementOfDebt;	//68685
	}
	public class cls_ExtraordinaryItemsWhichAreLossses {
		public Decimal LossesFromCatastrophicEvents;	//68695
		public Decimal CostsAcquiredFromAcquiringLawSuits;	//68699
		public Decimal Total;	//68702
		public Decimal LossesFromTheSaleOfAssets;	//68697
		public Decimal RestructuringCostsThatComeWithLayingOffEmployees;	//68700
		public Decimal LossesDueToDebtorsBankruptcy;	//68696
		public Decimal OtherExtraordinaryItems;	//68701
		public Decimal LossesFromWritingOffIntangibleAssets;	//68698
	}
	public class cls_NonOperatingIncome {
		public cls_InterestIncome InterestIncome;
		public Decimal NetIncomeTaxRefunds;	//68428
		public Decimal MiscellaneousIncome;	//68429
		//public cls_OtherNonOperatingIncome OtherNonOperatingIncome;
		public Decimal GrandTotal;	//68432
		public Decimal OtherNonoperatingIncome1;	//68430
		public Decimal CommissionIncome;	//68427
		public Decimal NetGainOnForeignCurrencyTransactionsAndTranslation;	//68415
		public cls_DividendIncome DividendIncome;
		public cls_NetGainOnSale NetGainOnSale;
	}
	public class cls_InterestIncome {
		public Decimal InterestIncomeFromLongTermInvestments;	//68400
		public Decimal OtherInterest;	//68402
		public Decimal InterestIncomeFromCurrentInvestments;	//68399
		public Decimal InterestOnIncomeTaxRefund;	//68401
		public Decimal InterestOnOverdueTradeReceivables;	//68398
		public Decimal InterestFromBanks;	//68396
		public Decimal TotalInterestIncome;	//68403
		public Decimal InterestOnLoansAndAdvances;	//68397
	}
	public class cls_OtherNonOperatingIncome {
		public Decimal ShareOfProfitFromLLPs;	//68423
		public Decimal ShareOfProfitFromAOPs;	//68422
		public Decimal ShareOfProfitFromPartnershipFirms;	//68421
		public Decimal ProfitOnSaleOfFixedAssets;	//68420
		public Decimal LiabilitiesProvisionsNoLongerRequired;	//68424
		public Decimal RentalIncomeIncludingRentFromOperatingLeases;	//68419
		public Decimal TotalOtherNonOperatingIncome;	//68425
		public Decimal RentalIncomeFromInvestmentProperties;	//68418
	}
	public class cls_DividendIncome {
		public Decimal TotalDividendIncome;	//68408
		public Decimal FromCurrentInvestments;	//68406
		public Decimal FromLongtermInvestments;	//68407
	}
	public class cls_NetGainOnSale {
		public Decimal TotalNetGainOnSaleOfInvestments;	//68413
		public Decimal LongtermInvestments;	//68412
		public Decimal CurrentInvestments;	//68411
	}
	public class cls_EarningsPerEquityShareBeforeExtraordinaryItems {
		public Decimal Basic;	//68746
		public Decimal Diluted;	//68747
	}
	public static PerfiosStructureBuilder.ProfitAndLossParse plParser(String json){
		return (PerfiosStructureBuilder.ProfitAndLossParse) System.JSON.deserialize(json, PerfiosStructureBuilder.ProfitAndLossParse.class);
	}
    //Parsing BalanceSheet Data
    public class BalanceSheetParse{
        public cls_BS_Assets Assets;
        public cls_EquitiesAndLiabilities EquitiesAndLiabilities;
    }
    public class cls_BS_Assets{
		public Decimal Total;	//20753
		public cls_CurrentAssets CurrentAssets;
		public cls_NonCurrentAssets NonCurrentAssets;
	}
	public class cls_CurrentAssets {
		public cls_Inventories Inventories;
		public cls_CashAndCashEquivalents CashAndCashEquivalents;
		public cls_OtherCurrentAssets OtherCurrentAssets;
		public cls_TradeReceivablesOrSundryDebtors TradeReceivablesOrSundryDebtors;
		public cls_ShortTermLoansAndAdvances ShortTermLoansAndAdvances;
		public cls_CurrentInvestments CurrentInvestments;
	}
	public class cls_Inventories {
		public Decimal Others;	//20601
		public Decimal LessProvisionForObsoleteStock;	//20603
		public Decimal GrossTotalOfInventories;	//20602
		public Decimal ObsoleteStock;	//20600
		public Decimal FinishedGoods;	//20595
		public Decimal NetOfInventories;	//20604
		public Decimal StoresAndSparesConsumables;	//20597
		public Decimal GoodsInTransit;	//20599
		public Decimal Stockintrade;	//20596
		public Decimal RawMaterials;	//20593
		public Decimal LooseTools;	//20598
		public Decimal Workinprogress;	//20594
	}
	public class cls_CashAndCashEquivalents {
		public cls_BalancesWithBanks BalancesWithBanks;
		public Decimal Others;	//20646
		public Decimal CashOnHand;	//20634
		public Decimal Total;	//20647
		public Decimal ChequesDraftsOnHand;	//20635
	}
	public class cls_BalancesWithBanks {
		public Decimal InFlexiDepositAccounts;	//20640
		public Decimal InCurrentAccounts;	//20637
		public Decimal InDepositAccounts;	//20639
		public Decimal InEEFCAccounts;	//20638
		public cls_InEarmarkedAccounts InEarmarkedAccounts;
	}
	public class cls_InEarmarkedAccounts {
		public Decimal OtherEarmarkedAccounts;	//20645
		public Decimal UnpaidMaturedDebentures;	//20644
		public Decimal UnpaidMaturedDeposits;	//20643
		public Decimal UnpaidDividendAccounts;	//20642
	}
	public class cls_OtherCurrentAssets {
		public Decimal ContractuallyReimbursableExpenses;	//20748
		public Decimal Others;	//20749
		public Decimal UnbilledRevenue;	//20741
		public Decimal BalanceWithGovernmentAuthorities;	//20742
		public Decimal InterestAccruedOnTradeReceivables;	//20746
		public Decimal Total;	//20751
		public Decimal InterestAccruedOnInvestments;	//20745
		public Decimal InsuranceClaims;	//20747
		public Decimal InterestAccruedOnDeposits;	//20744
		public Decimal AncillaryBorrowingCosts;	//20743
	}
	public class cls_TradeReceivablesOrSundryDebtors {
		public cls_WithinSixMonths WithinSixMonths;
		public cls_ExceedingSixMonths ExceedingSixMonths;
		public Decimal Total;	//20606
	}
	public class cls_WithinSixMonths {
		public Decimal LessProvisionAllowanceForBadAndDoubtfulDebts;	//20624
		public Decimal Doubtful;	//20622
		public Decimal DebtDueByDirectorsothersOfficersOfTheCompany;	//20626
		public Decimal NetTradeReceivables;	//20625
		public Decimal SecuredConsideredGood;	//20620
		public Decimal TotalTradeReceivables;	//20623
		public Decimal UnsecuredConsideredGood;	//20621
	}
	public class cls_ExceedingSixMonths {
		public Decimal LessProvisionAllowanceForBadAndDoubtfulDebts;	//20615
		public Decimal Doubtful;	//20613
		public Decimal DebtDueByDirectorsothersOfficersOfTheCompany;	//20617
		public Decimal NetTradeReceivables;	//20616
		public Decimal SecuredConsideredGood;	//20611
		public Decimal TotalTradeReceivables;	//20614
		public Decimal UnsecuredConsideredGood;	//20612
	}
	public class cls_ShortTermLoansAndAdvances {
		public cls_SecuredShortTermLoansAndAdvances SecuredShortTermLoansAndAdvances;
		public Decimal Total;	//20649
		public cls_UnSecuredShortTermLoansAndAdvances UnSecuredShortTermLoansAndAdvances;
		public cls_DoubtfulShortTermLoansAndAdvances DoubtfulShortTermLoansAndAdvances;
	}
	public class cls_SecuredShortTermLoansAndAdvances {
		public Decimal OtherLoansAndAdvances;	//20671
		public Decimal SecurityDeposits;	//20654
		public Decimal NetSecuredShortTermLoanAndAdvances;	//20677
		public Decimal TotalOfSecuredShortTermLoanAndAdvances;	//20672
		public Decimal AdvanceTax;	//20669
		public Decimal LoansAndAdvancesToRelatedParties;	//20655
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Decimal LoansAndAdvancesToEmployees;	//20656
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Decimal InterCorporateDeposits;	//20670
		public Decimal LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//20678
	}
	public class cls_BalancesWithGovernmentAuthorities {
		public Decimal VATCreditReceivable;	//20444
		public Decimal CENVATCreditReceivable;	//20443
		public Decimal TotalBalancesWithGovernmentAuthorities;	//20447
		public Decimal ServiceTaxCreditReceivable;	//20445
		public Decimal OtherReceivables;	//20446
	}
	public class cls_AllowanceForBadAndDoubtfulLoansAndAdvances {
		public Decimal FromOthers;	//20453
		public Decimal FromRelatedParties;	//20452
	}
	public class cls_PrepaidExpenses {
		public Decimal AnnualMaintnanceContracts;	//20436
		public Decimal OtherPrepaidExpenses;	//20437
		public Decimal InsurancePremium;	//20435
		public Decimal TotalPrepaidExpenses;	//20438
	}
	public class cls_UnSecuredShortTermLoansAndAdvances {
		public Decimal OtherLoansAndAdvances;	//20698
		public Decimal SecurityDeposits;	//20681
		public Decimal AdvanceTax;	//20696
		public Decimal TotalOfUnsecuredShortTermLoanAndAdvances;	//20699
		public Decimal LoansAndAdvancesToRelatedParties;	//20682
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Decimal NetUnsecuredShortTermLoanAndAdvances;	//20704
		public Decimal LoansAndAdvancesToEmployees;	//20683
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Decimal InterCorporateDeposits;	//20697
		public Decimal LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//20705
	}
	public class cls_DoubtfulShortTermLoansAndAdvances {
		public Decimal OtherLoansAndAdvances;	//20725
		public Decimal NetDoubtfulShortTermLoanAndAdvances;	//20731
		public Decimal TotalOfDoubtfulShortTermLoanAndAdvances;	//20726
		public Decimal SecurityDeposits;	//20708
		public Decimal AdvanceTax;	//20723
		public Decimal LoansAndAdvancesToRelatedParties;	//20709
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Decimal LoansAndAdvancesToEmployees;	//20710
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Decimal InterCorporateDeposits;	//20724
		public Decimal LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//20732
	}
	public class cls_CurrentInvestments {
		public Decimal InvestmentInMutualFunds;	//20584
		public cls_InvestmentInDebenturesOrBonds InvestmentInDebenturesOrBonds;
		public cls_InvestmentProperty InvestmentProperty;
		public cls_InvestmentInEquityInstruments InvestmentInEquityInstruments;
		public Decimal OtherCurrentInvestments;	//20585
		public Decimal Total;	//20587
		public cls_CurrentPortionOfLongTermInvestments CurrentPortionOfLongTermInvestments;
		public cls_InvestmentInGovernmentAndTrustSecurities InvestmentInGovernmentAndTrustSecurities;
		public Decimal InvestmentInPartnershipFirms;	//20583
		public cls_InvestmentInPreferenceShares InvestmentInPreferenceShares;
	}
	public class cls_InvestmentInDebenturesOrBonds {
		public Decimal OfSubsidiaries;	//20409
		public Decimal OfJointVentureCompanies;	//20411
		public Decimal OfOtherEntities;	//20413
		public Decimal Total;	//20414
		public Decimal OfAssociates;	//20410
		public Decimal OfControlledSpecialPurposeEntities;	//20412
	}
	public class cls_InvestmentProperty {
		public Decimal NetInvestmentProperty;	//20389
		public Decimal Impairment;	//20388
		public Decimal GrossTotalOfInvestmentProperty;	//20386
		public Decimal LessDepreciation;	//20387
	}
	public class cls_InvestmentInEquityInstruments {
		public Decimal OfSubsidiaries;	//20391
		public Decimal OfJointVentureCompanies;	//20393
		public Decimal OfOtherEntities;	//20395
		public Decimal Total;	//20396
		public Decimal OfAssociates;	//20392
		public Decimal OfControlledSpecialPurposeEntities;	//20394
	}
	public class cls_CurrentPortionOfLongTermInvestments {
		public Decimal InvestmentInMutualFunds;	//20544
		public Decimal InvestmentInTrustSecurities;	//20542
		public Decimal InvestmentInDebenturesOrBonds;	//20543
		public Decimal LessProvisionForDiminutionInValueOfCurrentPortionOfLongTermInvestments;	//20547
		public Decimal NetOfCurrentPortionOfLongTermInvestments;	//20548
		public Decimal OtherInvestments;	//20545
		public Decimal GrossTotalOfCurrentPortionOfLongTermInvestments;	//20546
		public Decimal InvestmentInGovernmentSecurities;	//20541
		public Decimal InvestmentInPreferenceShares;	//20540
	}
	public class cls_InvestmentInGovernmentAndTrustSecurities {
		public Decimal TrustSecurities;	//20406
		public Decimal GovernmentSecurities;	//20405
		public Decimal Total;	//20407
	}
	public class cls_InvestmentInPreferenceShares {
		public Decimal OfSubsidiaries;	//20398
		public Decimal OfJointVentureCompanies;	//20400
		public Decimal OfOtherEntities;	//20402
		public Decimal Total;	//20403
		public Decimal OfAssociates;	//20399
		public Decimal OfControlledSpecialPurposeEntities;	//20401
	}
	public class cls_NonCurrentAssets {
		public Decimal DeferredTaxAssets;	//20424
		public cls_FixedAssets FixedAssets;
		public cls_LongTermLoansAndAdvances LongTermLoansAndAdvances;
		public cls_OtherNonCurrentAssets OtherNonCurrentAssets;
		public cls_NonCurrentInvestments NonCurrentInvestments;
	}
	public class cls_FixedAssets {
		public cls_InTangibleAssets InTangibleAssets;
		public Decimal CapitalWorkInProgress;	//20340
		public Decimal InTangibleAssetsUnderDevelopment;	//20341
		public cls_TangibleAssets TangibleAssets;
	}
	public class cls_InTangibleAssets {
		public cls_InTangibleAssetsDepreciation InTangibleAssetsDepreciation;
		public cls_InTangibleAssetsNet InTangibleAssetsNet;
		public cls_InTangibleAssetsGrossBlock InTangibleAssetsGrossBlock;
	}
	public class cls_InTangibleAssetsDepreciation {
		public Decimal LicensesAndFranchise;	//67895
		public Decimal Others;	//67896
		public Decimal MiningRights;	//67892
		public Decimal ModelsDesignsAndPrototypes;	//67894
		public Decimal ComputerSoftware;	//67890
		public Decimal Goodwill;	//67888
		public Decimal Total;	//67898
		public Decimal CopyrightsPatentsAndOtherIntellectualPropertyRights;	//67893
		public Decimal MastheadsAndPublishingTitles;	//67891
		public Decimal BrandsTrademarks;	//67889
	}
	public class cls_InTangibleAssetsNet {
		public Decimal LicensesAndFranchise;	//-47560
		public Decimal Others;	//-47560
		public Decimal MiningRights;	//-47560
		public Decimal ModelsDesignsAndPrototypes;	//-47560
		public Decimal ComputerSoftware;	//-47560
		public Decimal Goodwill;	//-47560
		public Decimal Total;	//-428040
		public Decimal CopyrightsPatentsAndOtherIntellectualPropertyRights;	//-47560
		public Decimal MastheadsAndPublishingTitles;	//-47560
		public Decimal BrandsTrademarks;	//-47560
	}
	public class cls_InTangibleAssetsGrossBlock {
		public Decimal LicensesAndFranchise;	//20335
		public Decimal Others;	//20336
		public Decimal MiningRights;	//20332
		public Decimal ModelsDesignsAndPrototypes;	//20334
		public Decimal ComputerSoftware;	//20330
		public Decimal Goodwill;	//20328
		public Decimal Total;	//20338
		public Decimal CopyrightsPatentsAndOtherIntellectualPropertyRights;	//20333
		public Decimal MastheadsAndPublishingTitles;	//20331
		public Decimal BrandsTrademarks;	//20329
	}
	public class cls_TangibleAssets {
		public cls_TangibleAssetsDepreciation TangibleAssetsDepreciation;
		public cls_TangibleAssetsNet TangibleAssetsNet;
		public cls_TangibleAssetsGrossBlock TangibleAssetsGrossBlock;
	}
	public class cls_TangibleAssetsDepreciation {
		public Decimal Computers;	//67878
		public Decimal Others;	//67879
		public Decimal Buildings;	//67872
		public Decimal FurnitureAndFixtures;	//67874
		public Decimal PlantAndEquipment;	//67873
		public Decimal LeaseholdImprovements;	//67877
		public Decimal Total;	//67881
		public Decimal OfficeEquipment;	//67876
		public Decimal Land;	//67871
		public Decimal Vehicles;	//67875
	}
	public class cls_TangibleAssetsNet {
		public Decimal Computers;	//-47560
		public Decimal Others;	//-47560
		public Decimal Buildings;	//-47560
		public Decimal FurnitureAndFixtures;	//-47560
		public Decimal PlantAndEquipment;	//-47560
		public Decimal LeaseholdImprovements;	//-47560
		public Decimal Total;	//-428040
		public Decimal OfficeEquipment;	//-47560
		public Decimal Land;	//-47560
		public Decimal Vehicles;	//-47560
	}
	public class cls_TangibleAssetsGrossBlock {
		public Decimal Computers;	//20318
		public Decimal Others;	//20319
		public Decimal Buildings;	//20312
		public Decimal FurnitureAndFixtures;	//20314
		public Decimal PlantAndEquipment;	//20313
		public Decimal LeaseholdImprovements;	//20317
		public Decimal Total;	//20321
		public Decimal OfficeEquipment;	//20316
		public Decimal Land;	//20311
		public Decimal Vehicles;	//20315
	}
	public class cls_LongTermLoansAndAdvances {
		public cls_DoubtfulLongTermLoansAndAdvances DoubtfulLongTermLoansAndAdvances;
		public Decimal Total;	//20425
		public cls_UnsecuredLongTermLoansAndAdvances UnsecuredLongTermLoansAndAdvances;
		public cls_SecuredLongTermLoansAndAdvances SecuredLongTermLoansAndAdvances;
	}
	public class cls_DoubtfulLongTermLoansAndAdvances {
		public Decimal OtherLoansAndAdvances;	//20505
		public Decimal TotalDoubtfulLongTermLoanAndAdvances;	//20506
		public Decimal CapitalAdvances;	//20486
		public Decimal SecurityDeposits;	//20487
		public Decimal LoansAndAdvancesToRelatedParties;	//20488
		public Decimal MATCreditAvailment;	//20497
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Decimal NetDoubtfulLongTermLoanAndAdvances;	//20510
		public Decimal LoansAndAdvancesToEmployees;	//20489
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Decimal LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//20511
	}
	public class cls_UnsecuredLongTermLoansAndAdvances {
		public Decimal OtherLoansAndAdvances;	//20477
		public Decimal CapitalAdvances;	//20458
		public Decimal SecurityDeposits;	//20459
		public Decimal LoansAndAdvancesToRelatedParties;	//20460
		public Decimal MATCreditAvailment;	//20469
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Decimal NetUnsecuredLongTermLoanAndAdvances;	//20482
		public Decimal LoansAndAdvancesToEmployees;	//20461
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Decimal TotalUnsecuredLongTermLoanAndAdvances;	//20478
		public Decimal LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//20483
	}
	public class cls_SecuredLongTermLoansAndAdvances {
		public Decimal OtherLoansAndAdvances;	//20449
		public Decimal CapitalAdvances;	//20430
		public Decimal SecurityDeposits;	//20431
		public Decimal LoansAndAdvancesToRelatedParties;	//20432
		public Decimal MATCreditAvailment;	//20441
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Decimal TotalSecuredLongTermLoanAndAdvances;	//20450
		public Decimal LoansAndAdvancesToEmployees;	//20433
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Decimal NetSecuredLongTermLoanAndAdvances;	//20454
		public Decimal LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//20455
	}
	public class cls_OtherNonCurrentAssets {
		public Decimal ContractuallyReimbursableExpenses;	//20529
		public Decimal Others;	//20530
		public Decimal InterestAccruedOnTradeReceivables;	//20526
		public Decimal InterestAccruedOnInvestments;	//20525
		public Decimal InsuranceClaims;	//20527
		public Decimal ShareIssueExpenses;	//20521
		public Decimal InterestAccruedOnDeposits;	//20524
		public Decimal TradeReceivables;	//20519
		public Decimal DiscountOnIssueOfDebentures;	//20523
		public Decimal ReceivablesOnSaleOfFixedAssets;	//20528
		public Decimal DiscountOnIssueOfShares;	//20522
		public Decimal Total;	//20532
		public Decimal AncillaryBorrowingCosts;	//20520
	}
	public class cls_NonCurrentInvestments {
		public Decimal Total;	//20342
		public cls_TradeInvestments TradeInvestments;
		public cls_OtherInvestments OtherInvestments;
	}
	public class cls_TradeInvestments {
		public Decimal InvestmentInMutualFunds;	//20378
		public Decimal TotalOfNonCurrentTradeInvestments;	//20382
		public cls_InvestmentInDebenturesOrBonds InvestmentInDebenturesOrBonds;
		public cls_InvestmentProperty InvestmentProperty;
		public cls_InvestmentInEquityInstruments InvestmentInEquityInstruments;
		public Decimal GrossTotal;	//20380
		public Decimal LessProvisionForDiminutionInValueOfInvestments;	//20381
		public cls_InvestmentInGovernmentAndTrustSecurities InvestmentInGovernmentAndTrustSecurities;
		public Decimal InvestmentInPartnershipFirms;	//20377
		public cls_InvestmentInPreferenceShares InvestmentInPreferenceShares;
		public Decimal OtherLongTermInvestments;	//20379
	}
	public class cls_OtherInvestments {
		public Decimal InvestmentInMutualFunds;	//20416
		public Decimal TotalOfOtherNonCurrentInvestments;	//20420
		public cls_InvestmentInDebenturesOrBonds InvestmentInDebenturesOrBonds;
		public cls_InvestmentProperty InvestmentProperty;
		public cls_InvestmentInEquityInstruments InvestmentInEquityInstruments;
		public Decimal GrossTotal;	//20418
		public Decimal LessProvisionForDiminutionInValueOfInvestments;	//20419
		public cls_InvestmentInGovernmentAndTrustSecurities InvestmentInGovernmentAndTrustSecurities;
		public Decimal InvestmentInPartnershipFirms;	//20415
		public cls_InvestmentInPreferenceShares InvestmentInPreferenceShares;
		public Decimal OtherLongTermInvestments;	//20417
	}
	public class cls_EquitiesAndLiabilities {
		public cls_ShareholdersFunds ShareholdersFunds;
		public cls_NonCurrentLiabilitiesOrLongTermLiabilities NonCurrentLiabilitiesOrLongTermLiabilities;
		public Decimal ShareApplicationMoneyPendingAllotment;	//20110
		public Decimal Total;	//20301
		public cls_CurrentLiabilitiesOrShortTermLiabilities CurrentLiabilitiesOrShortTermLiabilities;
	}
	public class cls_ShareholdersFunds {
		public cls_ShareCapital ShareCapital;
		public cls_ReserveAndSurplus ReserveAndSurplus;
		public Decimal MoneyReceivedAgainstShareWarrants;	//20109
	}
	public class cls_ShareCapital {
		public cls_InCaseOfCorporates InCaseOfCorporates;
		public cls_InCaseOfPropreitershipOrPartnership InCaseOfPropreitershipOrPartnership;
		public Decimal Total;	//19860
	}
	public class cls_InCaseOfCorporates {
		public cls_IssuedCapital IssuedCapital;
		public cls_SubscribedButNotFullyPaidUp SubscribedButNotFullyPaidUp;
		public cls_AuthorisedShareCapital AuthorisedShareCapital;
		public cls_SubscribedAndFullyPaidUp SubscribedAndFullyPaidUp;
	}
	public class cls_IssuedCapital {
		public Decimal EquityShareCapital;	//19873
		public Decimal TotalOfIssuedCapital;	//19875
		public Decimal PreferenceShareCapital;	//19874
	}
	public class cls_SubscribedButNotFullyPaidUp {
		public Decimal EquityShareCapital;	//19909
		public Decimal TotalOfSubscribedButNotFullyPaidUpCapital;	//19911
		public Decimal PreferenceShareCapital;	//19910
	}
	public class cls_AuthorisedShareCapital {
		public Decimal EquityShareCapital;	//19868
		public Decimal PreferenceShareCapital;	//19869
		public Decimal TotalOfAuthorisedShareCapital;	//19870
	}
	public class cls_SubscribedAndFullyPaidUp {
		public cls_EquityShareCapital EquityShareCapital;
		public cls_PreferenceShareCapital PreferenceShareCapital;
	}
	public class cls_EquityShareCapital {
		public Decimal Others;	//19887
		public Decimal PrivatePlacementArisingOutOfConversionOfDebenturesOrPreferenceShares;	//19882
		public Decimal PublicIssue;	//19879
		public Decimal OtherPrivatePlacement;	//19883
		public Decimal SubscribedAndFullyPaidUp;	//19891
		public Decimal RightsIssue;	//19881
		public Decimal BonusIssue;	//19880
		public Decimal EmployeeStockOptionPlan;	//19886
		public Decimal Total;	//19888
		public Decimal PreferentialAllotmentArisingOutOfConversionOfDebenturesOrPreferenceShares;	//19884
		public Decimal CallsUnpaidByOthers;	//19890
		public Decimal OtherPreferentialAllotment;	//19885
		public Decimal LessCallsUnpaidByDirectors;	//19889
	}
	public class cls_PreferenceShareCapital {
		public Decimal Others;	//19902
		public Decimal PrivatePlacementArisingOutOfConversionOfDebenturesOrPreferenceShares;	//19897
		public Decimal PublicIssue;	//19894
		public Decimal OtherPrivatePlacement;	//19898
		public Decimal SubscribedAndFullyPaidUp;	//19906
		public Decimal RightsIssue;	//19896
		public Decimal BonusIssue;	//19895
		public Decimal EmployeeStockOptionPlan;	//19901
		public Decimal Total;	//19903
		public Decimal PreferentialAllotmentArisingOutOfConversionOfDebenturesOrPreferenceShares;	//19899
		public Decimal CallsUnpaidByOthers;	//19905
		public Decimal OtherPreferentialAllotment;	//19900
		public Decimal LessCallsUnpaidByDirectors;	//19904
	}
	public class cls_InCaseOfPropreitershipOrPartnership {
		public cls_PartnersCapitalAccount PartnersCapitalAccount;
		public cls_PartnersCurrentAccount PartnersCurrentAccount;
	}
	public class cls_PartnersCapitalAccount {
		public Decimal PartnerA;	//19921
		public Decimal PartnerC;	//19923
		public Decimal PartnerB;	//19922
		public Decimal PartnerE;	//19925
		public Decimal PartnerD;	//19924
		public Decimal PartnerG;	//19927
		public Decimal PartnerF;	//19926
		public Decimal PartnerQ;	//19937
		public Decimal PartnerP;	//19936
		public Decimal PartnerS;	//19939
		public Decimal PartnerR;	//19938
		public Decimal PartnerT;	//19940
		public Decimal Total;	//19942
		public Decimal PartnerI;	//19929
		public Decimal PartnerH;	//19928
		public Decimal PartnerK;	//19931
		public Decimal PartnerJ;	//19930
		public Decimal PartnerM;	//19933
		public Decimal PartnerL;	//19932
		public Decimal PartnerO;	//19935
		public Decimal PartnerN;	//19934
	}
	public class cls_PartnersCurrentAccount {
		public Decimal PartnerA;	//19971
		public Decimal PartnerC;	//19973
		public Decimal PartnerB;	//19972
		public Decimal PartnerE;	//19975
		public Decimal PartnerD;	//19974
		public Decimal PartnerG;	//19977
		public Decimal PartnerF;	//19976
		public Decimal PartnerQ;	//19987
		public Decimal PartnerP;	//19986
		public Decimal PartnerS;	//19989
		public Decimal PartnerR;	//19988
		public Decimal PartnerT;	//19990
		public Decimal Total;	//19992
		public Decimal PartnerI;	//19979
		public Decimal PartnerH;	//19978
		public Decimal PartnerK;	//19981
		public Decimal PartnerJ;	//19980
		public Decimal PartnerM;	//19983
		public Decimal PartnerL;	//19982
		public Decimal PartnerO;	//19985
		public Decimal PartnerN;	//19984
	}
	public class cls_ReserveAndSurplus {
		public cls_RevaluationReserve RevaluationReserve;
		public cls_ShareOptionsOutstandingAccount ShareOptionsOutstandingAccount;
		public cls_DebentureRedemptionReserve DebentureRedemptionReserve;
		public cls_OtherReserves OtherReserves;
		public cls_SurplusOrDeficitInTheStatementOfProfitAndLoss SurplusOrDeficitInTheStatementOfProfitAndLoss;
		public cls_SurplusToBeDistributedToThePartners SurplusToBeDistributedToThePartners;
		public cls_HedgingReserve HedgingReserve;
		public cls_SecuritiesPremiumAccount SecuritiesPremiumAccount;
		public cls_CapitalRedemptionReserve CapitalRedemptionReserve;
		public cls_CapitalReserve CapitalReserve;
		public cls_GeneralReserve GeneralReserve;
		public Decimal Total;	//20019
		public cls_ForeignCurrencyTranslationReserve ForeignCurrencyTranslationReserve;
	}
	public class cls_RevaluationReserve {
		public Decimal ClosingBalance;	//20056
		public Decimal OpeningBalance;	//20052
		public Decimal TransferredDuringTheYear;	//20055
		public Decimal AddAdditionOnRevaluationsDuringTheYear;	//20053
		public Decimal LessUtilisedDuringTheYear;	//20054
	}
	public class cls_ShareOptionsOutstandingAccount {
		public Decimal ClosingBalance;	//20063
		public Decimal OpeningBalance;	//20059
		public Decimal TransferredDuringTheYear;	//20062
		public Decimal LessUtilisedDuringTheYear;	//20061
		public Decimal AddAmountsRecordedOnGrantsmodificationscancellationsDuringTheYear;	//20060
	}
	public class cls_DebentureRedemptionReserve {
		public Decimal ClosingBalance;	//20049
		public Decimal OpeningBalance;	//20045
		public Decimal TransferredDuringTheYear;	//20048
		public Decimal AddAdditionsDuringTheYear;	//20046
		public Decimal LessUtilisedDuringTheYear;	//20047
	}
	public class cls_OtherReserves {
		public Decimal ClosingBalance;	//20105
		public Decimal OpeningBalance;	//20101
		public Decimal TransferredDuringTheYear;	//20104
		public Decimal LessUtilisationsDuringTheYear;	//20103
		public Decimal AddAdditionsDuringTheYear;	//20102
	}
	public class cls_SurplusOrDeficitInTheStatementOfProfitAndLoss {
		public Decimal ClosingBalance;	//20091
		public Decimal OpeningBalance;	//20087
		public Decimal TransferredDuringTheYear;	//20090
		public Decimal LessUtilisationsDuringTheYear;	//20089
		public Decimal AddAdditionsDuringTheYear;	//20088
	}
	public class cls_SurplusToBeDistributedToThePartners {
		public Decimal ClosingBalance;	//20098
		public Decimal OpeningBalance;	//20094
		public Decimal TransferredDuringTheYear;	//20097
		public Decimal LessUtilisationsDuringTheYear;	//20096
		public Decimal AddAdditionsDuringTheYear;	//20095
	}
	public class cls_HedgingReserve {
		public Decimal AddEffectOfForeignExchangeRateVariationsOnHedgingInstrumentsOutstandingAtTheEndOfTheYear;	//20081
		public Decimal ClosingBalance;	//20084
		public Decimal OpeningBalance;	//20080
		public Decimal TransferredDuringTheYear;	//20083
		public Decimal LessEffectOfForeignExchangeRateVariationsOnHedgingInstrumentsOutstandingAtTheEndOfTheYear;	//20082
	}
	public class cls_SecuritiesPremiumAccount {
		public Decimal ClosingBalance;	//20042
		public Decimal OpeningBalance;	//20038
		public Decimal TransferredDuringTheYear;	//20041
		public Decimal AddAdditionsDuringTheYear;	//20039
		public Decimal LessUtilisedDuringTheYear;	//20040
	}
	public class cls_CapitalRedemptionReserve {
		public Decimal ClosingBalance;	//20035
		public Decimal OpeningBalance;	//20031
		public Decimal TransferredDuringTheYear;	//20034
		public Decimal AddAdditionsDuringTheYear;	//20032
		public Decimal LessUtilisedDuringTheYear;	//20033
	}
	public class cls_CapitalReserve {
		public Decimal ClosingBalance;	//20028
		public Decimal OpeningBalance;	//20024
		public Decimal TransferredDuringTheYear;	//20027
		public Decimal AddAdditionsDuringTheYear;	//20025
		public Decimal LessUtilisedDuringTheYear;	//20026
	}
	public class cls_GeneralReserve {
		public Decimal ClosingBalance;	//20070
		public Decimal AddTransferredFromSurplusInStatementOfProfitAndLoss;	//20067
		public Decimal OpeningBalance;	//20066
		public Decimal TransferredDuringTheYear;	//20069
		public Decimal LessUtilisedDuringTheYear;	//20068
	}
	public class cls_ForeignCurrencyTranslationReserve {
		public Decimal ClosingBalance;	//20077
		public Decimal OpeningBalance;	//20073
		public Decimal TransferredDuringTheYear;	//20076
		public Decimal AddEffectOfForeignExchangeRateVariationsDuringTheYear;	//20074
		public Decimal LessEffectOfForeignExchangeRateVariationsDuringTheYear;	//20075
	}
	public class cls_NonCurrentLiabilitiesOrLongTermLiabilities {
		public cls_LongTermBorrowings LongTermBorrowings;
		public Decimal DeferredTaxLiabilities;	//20148
		public cls_LongTermProvisions LongTermProvisions;
		public cls_OtherLongTermLiabilities OtherLongTermLiabilities;
	}
	public class cls_LongTermBorrowings {
		public cls_UnSecuredLongTermBorrowings UnSecuredLongTermBorrowings;
		public Decimal Total;	//20112
		public cls_SecuredLongTermBorrowings SecuredLongTermBorrowings;
	}
	public class cls_UnSecuredLongTermBorrowings {
		public cls_DomesticLoans DomesticLoans;
		public Decimal OutOfAboveTotalAggregateAmountGuaranteedByDirectors;	//20146
		public Decimal TotalUnsecuredLongTermBorrowings;	//20145
		public Decimal ForeignCurrencyLoans;	//20133
	}
	public class cls_DomesticLoans {
		public Decimal LoansAndAdvancesFromRelatedParties;	//20219     
		public Decimal OtherLoansAndAdvances;	//20224
		public Decimal Deposits;	//20220
		public cls_LoansRepayableOnDemand LoansRepayableOnDemand;
		public Decimal InterCorporateBorrowings;	//20221
		public Decimal CashCredits;	//20222
		public Decimal Overdrafts;	//20223 
        public Decimal DeferredPaymentLiabilities;	//20223
        public cls_TermLoans TermLoans;	//20223
        public Decimal QuasiEquity;	//20223
        public Decimal BondsDebentures;	//20223
        public Decimal LongTermMaturitiesOfFinancialLeaseObligations;	//20223
        public Decimal OtherLoansAdvances;	//20223
	}
	public class cls_TermLoans {
		public Decimal FromBanks;	//20122
		public Decimal FromOtherParties;	//20123
	}
	public class cls_SecuredLongTermBorrowings {
		public cls_DomesticLoans DomesticLoans;
		public Decimal OutOfAboveTotalAggregateAmountGuaranteedByDirectors;	//20130
		public Decimal TotalSecuredLongTermBorrowings;	//20129
		public Decimal ForeignCurrencyLoans;	//20117
	}
	public class cls_LongTermProvisions {
		public Decimal Total;	//20191
		public cls_ProvisionForEmployeeBenefits ProvisionForEmployeeBenefits;
		public cls_ProvisionOthers ProvisionOthers;
	}
	public class cls_ProvisionForEmployeeBenefits {
		public Decimal ProvisionForPostemploymentMedicalBenefits;	//20280
		public Decimal ProvisionForCompensatedAbsences;	//20278
		public Decimal Total;	//20284
		public Decimal ProvisionForOtherEmployeeBenefits;	//20282
		public Decimal ProvisionForOtherDefinedBenefitPlans;	//20281
		public Decimal ProvisionForBonus;	//20283
		public Decimal ProvisionForGratuity;	//20279
	}
	public class cls_ProvisionOthers {
		public Decimal ProvisionForPremiumPayableOnRedemptionOfBonds;	//20288
		public Decimal ProvisionForProposedPreferenceDividend;	//20294
		public Decimal ProvisionForOtherContingencies;	//20292
		public Decimal ProvisionForEstimatedLossesOnOnerousContracts;	//20291
		public Decimal Total;	//20297
		public Decimal ProvisionForEstimatedLossOnDerivatives;	//20289
		public Decimal ProvisionForTaxOnProposedDividends;	//20295
		public Decimal ProvisionForWarranty;	//20290
		public Decimal ProvisionForProposedEquityDividend;	//20293
		public Decimal ProvisionOthers;	//20296
		public Decimal ProvisionForTax;	//20287
	}
	public class cls_OtherLongTermLiabilities {
		public cls_Others Others;
		public Decimal Total;	//20168
		public cls_TradePayables TradePayables;
	}
	public class cls_Others {
		public Decimal Others;	//20166
		public Decimal InterestAccruedButNotDueOnBorrowings;	//20160
		public Decimal InterestAccruedOnOthers;	//20162
		public Decimal ContractuallyReimburseableExpenses;	//20165
		public Decimal TradeSecurityDeposits;	//20163
		public Decimal PayablesOnPurchaseOfFixedAssets;	//20158
		public Decimal InterestAccruedOnTradePayables;	//20161
		public Decimal IncomeReceivedInAdvance;	//20159
		public Decimal AdvancesFromCustomers;	//20164
	}
	public class cls_TradePayables {
		public Decimal Acceptances;	//20154
		public Decimal OtherThanAcceptances;	//20155
	}
	public class cls_CurrentLiabilitiesOrShortTermLiabilities {
		public cls_TradePayablesOrSundryCreditors TradePayablesOrSundryCreditors;
		public cls_ShortTermBorrowings ShortTermBorrowings;
		public cls_ShortTermProvisions ShortTermProvisions;
		public cls_OtherCurrentLiabilities OtherCurrentLiabilities;
	}
	public class cls_TradePayablesOrSundryCreditors {
		public cls_ForGoods ForGoods;
		public Decimal Total;	//20228
		public cls_ForExpenses ForExpenses;
	}
	public class cls_ForGoods {
		public Decimal Acceptances;	//20234
		public Decimal Others;	//20235
	}
	public class cls_ForExpenses {
		public Decimal Acceptances;	//20237
		public Decimal Others;	//20238
	}
	public class cls_ShortTermBorrowings {
		public cls_SecuredShortTermBorrowings SecuredShortTermBorrowings;
		public Decimal Total;	//20194
		public cls_UnSecuredShortTermBorrowings UnSecuredShortTermBorrowings;
	}
	public class cls_SecuredShortTermBorrowings {
		public cls_DomesticLoans DomesticLoans;
		public Decimal OutOfAboveTotalAggregateAmountGuaranteedByDirectors;	//20211
		public Decimal TotalSecuredShortTermBorrowings;	//20210
		public Decimal ForeignCurrencyLoans;	//20199
	}
	public class cls_LoansRepayableOnDemand {
		public Decimal FromBanks;	//20217
		public Decimal FromOtherParties;	//20218
	}
	public class cls_UnSecuredShortTermBorrowings {
		public cls_DomesticLoans DomesticLoans;
		public Decimal TotalUnsecuredShortTermBorrowings;	//20225
		public Decimal OutOfAboveTotalAggregateAmountGuaranteedByDirectors;	//20226
		public Decimal ForeignCurrencyLoans;	//20214
	}
	public class cls_ShortTermProvisions {
		public Decimal Total;	//20273
		public cls_ProvisionForEmployeeBenefits ProvisionForEmployeeBenefits;
		public cls_ProvisionOthers ProvisionOthers;
	}
	public class cls_OtherCurrentLiabilities {
		public Decimal UnpaidMaturedDebenturesAndInterestAccruedThereon;	//20253
		public Decimal InterestAccruedButNotDueOnBorrowings;	//20248
		public cls_OtherPayables OtherPayables;
		public Decimal UnpaidDividends;	//20251
		public Decimal CurrentMaturitiesOfFinanceLeaseObligations;	//20247
		public Decimal Total;	//20271
		public Decimal InterestAccruedAndDueOnBorrowings;	//20249
		public Decimal ContractuallyReimburseableExpenses;	//20254
		public Decimal IncomeReceivedInAdvance;	//20250
		public Decimal CurrentMaturitiesOfLongtermDebt;	//20246
		public Decimal UnpaidMaturedDepositsAndInterestAccruedThereon;	//20252
	}
	public class cls_OtherPayables {
		public Decimal Others;	//20269
		public cls_StatutoryRemittances StatutoryRemittances;
		public Decimal InterestAccruedOnOthers;	//20267
		public Decimal TradeSecurityDeposits;	//20268
		public Decimal InterestAccruedOnTradePayables;	//20266
	}
	public class cls_StatutoryRemittances {
		public Decimal ContributionToEmployeesStateInsurance;	//20258
		public Decimal Others;	//20264
		public Decimal Total;	//20265
		public Decimal VATPayable;	//20260
		public Decimal ContributionToProvidentFund;	//20257
		public Decimal WealthTaxPayable;	//20262
		public Decimal ExciseDutyPayable;	//20259
		public Decimal CustomsDutyPayable;	//20261
		public Decimal EntryTaxPayable;	//20263
	}
	public static PerfiosStructureBuilder.BalanceSheetParse bSheetParser(String json){
		return (PerfiosStructureBuilder.BalanceSheetParse) System.JSON.deserialize(json, PerfiosStructureBuilder.BalanceSheetParse.class);
	}
    //Parsing CashFlowStatement Data
    public class CashFlowStatementParse{
		public Decimal CashAndCashEquivalentsAtTheEndOfTheYear;	//170349
		public Decimal AddCashAndCashEquivalentsAtTheBeginningOfTheYear;	//68190
		public cls_CashFlowFromOperatingActivities CashFlowFromOperatingActivities;
		public cls_CashFlowFromFinancingActivities CashFlowFromFinancingActivities;
		public cls_CashFlowFromInvestingActivities CashFlowFromInvestingActivities;
		public Decimal CashAndCashEquivalentsAsPerTheBooks;	//20630
		public Decimal Difference;	//149719
		public Decimal NetIncreaseOrDecreaseInCashAndCashEquivalents;	//102159
	}
	
	public class cls_CashFlowFromOperatingActivities {
		public Decimal CashFlowFromExtraordinaryItems;	//21119
		public cls_ItemsToBeAddedMinusFinanceCosts ItemsToBeAddedMinusFinanceCosts;
		public cls_ItemsToBeDeductedMinusNonOperatingIncome ItemsToBeDeductedMinusNonOperatingIncome;
		public cls_ChangesInWorkingCapital ChangesInWorkingCapital;
		public Decimal CashFlowFromExceptionalItems;	//21095
		public Decimal NetIncomeTaxPaidOrRefunds;	//-42297
		public Decimal NetCashFlowFromOrUsedInOperatingActivities;	//158324
		public Decimal NetProfitOrLossBeforeExceptionalAndExtraordinaryItemsAndTax;	//21094
		public cls_ItemsToBeAddedMinusNonOperatingExpenses ItemsToBeAddedMinusNonOperatingExpenses;
		public Decimal OperatingProfitOrLossBeforeExtraordinaryItems;	//179443
		public Decimal OperatingProfitOrLossBeforeAdjustmentsAndWorkingCapitalChanges;	//478279
		public Decimal OperatingProfitOrLossBeforeExceptionalAndExtraordinaryItems;	//200538
		public Decimal OperatingProfitOrLossBeforeWorkingCapitalChanges;	//311447
	}
	public class cls_ItemsToBeAddedMinusFinanceCosts {
		public Decimal OtherFinanceCost;	//20979
		public Decimal InterestExpenseOnOtherBorrowings;	//20975
		public Decimal InterestExpenseOnBankLoans;	//20972
		public Decimal InterestExpenseOnDebentures;	//20971
		public Decimal InterestExpenseOnCashCredits;	//20973
		public Decimal QuasiInterest;	//20976
		public Decimal InterestExpenseOnOverdrafts;	//20974
	}
	public class cls_ItemsToBeDeductedMinusNonOperatingIncome {
		public Decimal InterestIncome;	//20843
		public Decimal ProfitGainOnSaleOfCurrentInvestments;	//20851
		public Decimal ProfitOnSaleOfFixedAssets;	//20860
		public Decimal LiabilitiesProvisionsNoLongerRequiredWrittenBack;	//20864
		public Decimal ProfitGainOnSaleOfLongTermInvestments;	//20852
		public Decimal NetGainOnForeignCurrencyTransactionsAndTranslation;	//20855
		public Decimal RentalIncomeIncludingRentFromOperatingLeases;	//20859
		public Decimal DividendIncome;	//20848
	}
	public class cls_ChangesInWorkingCapital {
		public cls_AdjustmentsForIncreaseOrDecreaseInOperatingLiabilities AdjustmentsForIncreaseOrDecreaseInOperatingLiabilities;
		public Decimal OperatingProfitOrLossAfterIncreaseOrDecreaseInOperatingLiabilities;	//242835
		public cls_AdjustmentsForIncreaseOrDecreaseInOperatingAssets AdjustmentsForIncreaseOrDecreaseInOperatingAssets;
		public Decimal OperatingProfitOrLossAfterIncreaseOrDecreaseInOperatingAssets;	//480635
	}
	public class cls_AdjustmentsForIncreaseOrDecreaseInOperatingLiabilities {
		public Decimal ShorttermProvisions;	//-47560
		public Decimal OtherCurrentLiabilities;	//-47560
		public Decimal OtherNonCurrentLiabilities;	//-47560
		public Decimal TradePayables;	//-47560
		public Decimal LongtermProvisions;	//-47560
	}
	public class cls_AdjustmentsForIncreaseOrDecreaseInOperatingAssets {
		public Decimal Inventories;	//47560
		public Decimal OtherCurrentAssets;	//47560
		public Decimal OtherNonCurrentAssets;	//12
		public Decimal TradeReceivables;	//26496
		public Decimal ShorttermLoansAndAdvances;	//47560
	}
	public class cls_ItemsToBeAddedMinusNonOperatingExpenses {
		public Decimal Amortization;	//20988
		public Decimal NetLossOnForeignCurrencyTransactionsAndTranslation;	//21063
		public Decimal ProvisionForDoubtfulTradeAndOtherReceivablesLoansAndAdvances;	//21067
		public Decimal LossOnSaleOfLongTermInvestments;	//21060
		public Decimal Impairment;	//21085
		public Decimal PreliminaryExpensesWrittenOff;	//21053
		public Decimal IntangibleAssetsWrittenOffAmortised;	//21057
		public Decimal LossOnSaleOfCurrentInvestments;	//21059
		public Decimal LossOnSaleOfFixedAssets;	//21056
		public Decimal DiscountOnIssueOfDebenturesWrittenOff;	//21055
		public Decimal PremiumOnRedemptionOfDebentures;	//21061
		public Decimal Depreciation;	//20987
		public Decimal PremiumOnRedemptionOfPreferenceShares;	//21062
		public Decimal BadTradeAndOtherReceivablesLoansAndAdvancesWrittenOff;	//21064
		public Decimal DiscountOnIssueOfSharesWrittenOff;	//21054
		public Decimal MiscellaneousExpensesWrittenOff;	//21088
		public Decimal ChangesInRevaluationReserve;	//-47560
		public Decimal ProvisionForLossesInSubsidiaryCompanies;	//21066
	}
	public class cls_CashFlowFromFinancingActivities {
		public Decimal DividendsPaid;	//42147
		public Decimal InterestExpenseOnOtherBorrowings;	//-20975
		public Decimal ShareApplicationMoneyReceived;	//-47560
		public Decimal InterestExpenseOnBankLoans;	//-20972
		public Decimal QuasiInterest;	//-20976
		public Decimal ProceedsFromSecurityPremium;	//-47560
		public Decimal AdditionsOfDebentureRedemptionReserve;	//20046
		public Decimal OtherFinanceCost;	//-20979
		public Decimal ProceedsFromIssueOfEquityShares;	//-47560
		public Decimal CapitalChanges;	//-116214
		public Decimal ProceedsFromIssueOfPreferenceShares;	//-47560
		public Decimal NetCashFlowFromFinancingActivities;	//-471583
		public Decimal InterestExpenseOnDebentures;	//-20971
		public Decimal InterestExpenseOnCashCredits;	//-20973
		public Decimal ProceedsFromShorttermBorrowings;	//-47560
		public Decimal TaxOnDividend;	//42153
		public Decimal AdditionsOfCapitalReserve;	//20025
		public Decimal ProceedsFromIssueOfShareWarrants;	//-47560
		public Decimal InterestExpenseOnOverdrafts;	//-20974
		public Decimal ProceedsFromLongtermBorrowings;	//-47560
	}
	public class cls_CashFlowFromInvestingActivities {
		public Decimal NetLossOnForeignCurrencyTransactionsAndTranslation;	//-21063
		public Decimal DividendReceivedFromLongTermInvestments;	//20847
		public Decimal InterestReceivedFromInvestments;	//20843
		public Decimal OtherNonOperatingIncome;	//41723
		public Decimal ProceedsFromSaleOfOtherFixedAssets;	//95120
		public Decimal SaleOfCurrentInvestments;	//68411
		public Decimal DividendReceivedFromCurrentInvestments;	//20846
		public Decimal LongtermLoansAndAdvances;	//47560
		public Decimal NetCashFlowFromInvestingActivities;	//415418
		public Decimal ProceedsFromSaleOfIntangibleAssets;	//26572
		public Decimal ProfitOnSaleOfFixedAssets;	//-196
		public Decimal ProceedsFromSaleOfTangibleAssets;	//5488
		public Decimal SaleOfLongtermInvestments;	//68412
		public Decimal NetGainOnForeignCurrencyTransactionsAndTranslation;	//20855
		public Decimal TotalOfProceedsFromSaleOfFixedAssets;	//126984
	}
	public static PerfiosStructureBuilder.CashFlowStatementParse cfsParser(String json){
		return (PerfiosStructureBuilder.CashFlowStatementParse) System.JSON.deserialize(json, PerfiosStructureBuilder.CashFlowStatementParse.class);
	}
}