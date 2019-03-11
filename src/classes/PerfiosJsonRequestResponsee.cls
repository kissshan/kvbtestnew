public with sharing class PerfiosJsonRequestResponsee {

	/* FinanalProcess Req and Res- Start */
	public class FinancialProcessReq{
		public cls_payload payload;		
	}
	public class cls_payload {
		public String loanDuration;	//6
		public String loanAmount;	//100000
		public String loanType;	//SME
		public String financialYear;	//2016
		public String applicationId;
		public cls_documents[] documents;
	}
	public class cls_documents {
		public String uuid;	//100
		public String password;	//1234
	}

	public class FinancialProcessRes{
		public String errorCode;	//INVALID_REQUEST
		public String errorMessage;	//Invalid request payload
		public cls_Accepted Accepted;
		public cls_Rejected Rejected;	
	}
	public class cls_Accepted {
		public String message;	//Transaction submitted for processing
		public String perfiosTransactionId;	//NB4M1538986164412
		public String clientTransactionId;	//d86e8930-eaee-d463-6ac5-d753ba38fb33
	}
	public class cls_Rejected {
		public String message;	//Error occurred while uploading financial
	}



	/* FinancialReport Res- Start*/

	public class financialReportRes{
		public cls_FinancialStatement FinancialStatement;
		public String status;	//rejected
		public String errorCode;	//E_FILE_UNSUPPORTED_FORMAT
		public String errorMessage;	//Data (Balance Sheet and/or P&L) for the selected financial year FY 2016 is not available in the statements uploaded.
		public String perfiosTransactionId;	//DEMH1539287981639
		public String clientTransactionId;	//141e9658-506b-d001-3d6a-56d97536eb3d			
	}
	public class cls_FinancialStatement {
			public cls_Ratios Ratios;
			public String Organisation;	//0048a11e-0ab3-2a30-08f3-9f9eefe0059c
			public cls_FY2016 FY2016;
			public cls_CashFlowStatement CashFlowStatement;
	}
	public class cls_Ratios {
			public cls_FY2016 FY2016;
	}
	public class cls_FY2016 {
			public cls_ProfitAndLoss ProfitAndLoss;
			public cls_BalanceSheet BalanceSheet;
			public cls_CompanyDetails CompanyDetails;
	}
	public class cls_MiscellaneousItems {
			public Integer LongTermBorrowings;	//22306673
			public Integer QuickAssetsExcludingDebtors;	//50999162
			public Integer ShortTermBorrowings;	//0
			public Double CreditorsForGoods;	//22868350.18
			public Integer InvestmentInGroupCompanies;	//0
			public Integer RawMaterialCostsPurchasesOfStockinTrade;	//0
			public Integer OutsideLiabilities;	//22306673
			public Integer SalesAdvertisingMarketingExpenses;	//0
			public Integer QuickAssetsExcludingDebtorsMoreThan6MonthsAndInventories;	//4527893
			public Integer DebtService;	//25000850
			public Integer EmployeeCosts;	//24385
			public Integer WorkingCapitalGap;	//53596698
			public Double CapitalEmployedNetAssets;	//34204256.82
			public Integer QuickAssetsExcludingInventories;	//4527893
	}
	public class cls_Assets {
			public Integer Total;	//57598943
			public cls_CurrentAssets CurrentAssets;
			public cls_NonCurrentAssets NonCurrentAssets;
	}
	public class cls_Liabilities {
			public Integer Reserves;	//0
			public Integer TotalLiabilities;	//57598943
			public Integer LongTermDebt;	//22306673
			public Double PaidUpCapitalPartnersContribution;	//11897583.82
			public Double ShortTermDebt;	//23394686.18
			public Double TangibleNetworthOwnersEquityShareholdersEquityProprietaryFund;	//11897583.82
			public Double TradePayables;	//22868350.18
			public Integer Provisions;	//526336
	}
	public class cls_CalculationOfCashProfits {
			public Integer Interest;	//2694177
			public Integer CashProfits;	//960268
			public Integer Sales;	//30219944
			public Integer ProfitBeforeInterestAndTaxOperatingProfit;	//3155796
			public Integer ProfitBeforeDepreciationAndAmortisationInterestAndTax;	//3654445
			public Integer TotalExpenses;	//26638197
			public Integer OtherIncome;	//72698
			public Integer Tax;	//0
			public Integer TotalIncome;	//30292642
			public Integer ProfitAfterTax;	//461619
			public Integer DepreciationAndAmortisation;	//498649
			public Integer ProfitBeforeTax;	//461619
	}
	public class cls_PLItems {
			public Integer DirectExpenses;	//5517581
			public Integer ChangesInInventories;	//0
			public Integer GrossProfit;	//3726706
			public Integer SalesRevenueFromOperations;	//30219944
			public Integer CostOfMaterialsConsumed;	//20975657
			public Integer PurchasesOfStockInTrade;	//0
	}
	public class cls_FinancialRatios {
			public cls_RatiosAppearingInProfitAndLossAccount RatiosAppearingInProfitAndLossAccount;
			public cls_RatiosAppearingInBalanceSheet RatiosAppearingInBalanceSheet;
	}
	public class cls_RatiosAppearingInProfitAndLossAccount {
			public cls_ProfitabilityRatios ProfitabilityRatios;
	}
	public class cls_ProfitabilityRatios {
			public Double ReturnOnEquity;	//3.879939044632
			public Double ReturnOnInvestment;	//9.22632529806856
			public Double GrossMargin;	//12.3319421108126
			public Double CashProfitMargin;	//3.17759688767127
			public Double OperatingProfitRatio;	//10.4427592585876
			public Double ReturnOnCapitalEmployed;	//9.22632529806856
			public Double ReturnOnAssets;	//0.801436581917831
			public Double NetMargin;	//1.52753095770131
	}
	public class cls_RatiosAppearingInBalanceSheet {
			public cls_OtherRatios OtherRatios;
			public cls_TurnoverRatios TurnoverRatios;
			public cls_LeverageRatios LeverageRatios;
			public cls_ShortTermSolvencyRatios ShortTermSolvencyRatios;
	}
	public class cls_OtherRatios {
			public Double TotalLiabilitiesTangibleNetworth;	//4.8412302759469
			public Double EmployeeCostsSales;	//0.0806917444982691
			public Double CurrentAssetsSales;	//180.824339052382
			public Integer InvestmentInGroupCompaniesNW;	//0
			public Double TotalAssetsSales;	//190.599105676701
			public Integer RMCostsSales;	//0
			public Integer MarketingExpensesSales;	//0
	}
	public class cls_TurnoverRatios {
			public Double NetAssetsTurnoverRatioCapitalTurnoverRatio;	//88.3514123959265
			public Double CurrentAssetsTurnoverRatio;	//55.3022897935391
			public Double DebtorsDaysDebtorsCollectionPeriod;	//44.0350246843608
			public Double TotalAssetsTurnoverRatio;	//52.4661433457208
			public Double FixedAssetsTurnoverRatio;	//1023.04232769305
			public Integer InventoryDaysStockReplenishmentPeriod;	//0
			public Double WorkingCapitalTurnoverRatio;	//56.3839660420871
			public Double CreditorsDaysCreditorsPaymentPeriod;	//258.480111823772
	}
	public class cls_LeverageRatios {
			public Double InterestCoverageRatio;	//1.17133952223629
			public Double DebtRatio;	//0.387275735250906
			public Double DebtEquityRatio;	//1.87489101463628
			public Double EquityRatio;	//0.347839272831188
			public Double DebtServiceCoverageRatio;	//0.146172830123776
	}
	public class cls_ShortTermSolvencyRatios {
			public Double QuickRatioExcludingInventoriesAndDebtorsMoreThan6Months;	//0.193543651971313
			public Double CurrentRatio;	//2.33578743393086
			public Double QuickRatioExcludingInventories;	//0.193543651971313
			public Double QuickRatioExcludingDebtors;	//2.17994640353838
	}
	public class cls_CalculationOfNetOperatingIncome {
			public Integer NetOperatingIncome;	//3654445
			public cls_LessNonCashIncome LessNonCashIncome;
			public cls_AddNonCashExpenses AddNonCashExpenses;
			public Integer ProfitAfterTax;	//461619
	}
	public class cls_LessNonCashIncome {
			public Integer ProfitGainOnSaleOfCurrentInvestments;	//0
			public Integer ProfitOnSaleOfFixedAssets;	//0
			public Integer LiabilitiesProvisionsNoLongerRequiredWrittenBack;	//0
			public Integer ProfitGainOnSaleOfLongTermInvestments;	//0
			public Integer NetGainOnForeignCurrencyTransactionsAndTranslation;	//0
			public Integer RentalIncomeIncludingRentFromOperatingLeases;	//0
	}
	public class cls_AddNonCashExpenses {
			public Integer Amortization;	//0
			public Integer InterestOnPartnersCapital;	//0
			public Integer NetLossOnForeignCurrencyTransactionsAndTranslation;	//0
			public Integer LossOnSaleOfLongTermInvestments;	//0
			public Integer Impairment;	//0
			public Integer PreliminaryExpensesWrittenOff;	//0
			public Integer IntangibleAssetsWrittenOffAmortised;	//0
			public Integer ExpenseOnEmployeeStockOptionScheme;	//0
			public Integer LossOnSaleOfCurrentInvestments;	//0
			public Integer LossOnSaleOfFixedAssets;	//0
			public Integer SalariesToPartnersDirectors;	//0
			public Integer DiscountOnIssueOfDebenturesWrittenOff;	//0
			public Integer PremiumOnRedemptionOfDebentures;	//0
			public Integer Depreciation;	//498649
			public Integer InterestOnLoans;	//2694177
			public Integer PremiumOnRedemptionOfPreferenceShares;	//0
			public Integer BadTradeAndOtherReceivablesLoansAndAdvancesWrittenOff;	//0
			public Integer DiscountOnIssueOfSharesWrittenOff;	//0
	}
	public class cls_ProfitAndLoss {
			public cls_StatementOfProfitAndLoss StatementOfProfitAndLoss;
	}
	public class cls_StatementOfProfitAndLoss {
			public Integer InterestOnCapital;	//0
			public cls_EarningsPerEquityShareAfterExtraordinaryItems EarningsPerEquityShareAfterExtraordinaryItems;
			public Integer ProfitBeforeExtraordinaryItemsAndTax;	//461619
			public cls_Expenses Expenses;
			public Integer ProfitFromDiscontinuingOperationsAfterTax;	//0
			public Integer TaxExpenseOfDiscontinuingOperations;	//0
			public cls_ExceptionalItems ExceptionalItems;
			public cls_RevenueFromOperations RevenueFromOperations;
			public cls_TaxExpense TaxExpense;
			public Integer ProfitBeforeExceptionalAndExtraordinaryItemsAndTaxProfitBeforeInterestOnCapitalRemunerationAndTax;	//461619
			public Integer PartnersRemunerationSalary;	//0
			public Integer ProfitIeProfitAfterTax;	//461619
			public cls_BalanceCarriedToBalanceSheetInPropeitorAccount BalanceCarriedToBalanceSheetInPropeitorAccount;
			public cls_ExtraordinaryItems ExtraordinaryItems;
			public Integer TrasferredToReservesAndSurplus;	//0
			public Integer BalanceBroughtForwardFromPreviousYear;	//0
			public Integer ProfitForThePeriodFromContinuingOperations;	//461619
			public Integer TotalRevenue;	//30292642
			public Integer ProfitFromDiscontinuingOperations;	//0
			public cls_NonOperatingIncome NonOperatingIncome;
			public Integer AmountAvailableForAppropriations;	//461619
			public cls_EarningsPerEquityShareBeforeExtraordinaryItems EarningsPerEquityShareBeforeExtraordinaryItems;
			public Integer ProfitBeforeTax;	//461619
	}
	public class cls_EarningsPerEquityShareAfterExtraordinaryItems {
			public Integer Basic;	//0
			public Integer Diluted;	//0
	}
	public class cls_Expenses {
			public cls_OtherExpenses OtherExpenses;
			public cls_ChangesInInventories ChangesInInventories;
			public cls_ManagerialRemuneration ManagerialRemuneration;
			public Integer TotalExpenses;	//29831023
			public cls_FinanceCost FinanceCost;
			public cls_CostOfMaterialsConsumed CostOfMaterialsConsumed;
			public Integer PurchasesOfStockInTrade;	//0
			public cls_InsuranceExpenses InsuranceExpenses;
			public cls_PowerAndFuel PowerAndFuel;
			public cls_AuditorsFees AuditorsFees;
			public cls_EmployeeBenefitExpenses EmployeeBenefitExpenses;
			public cls_DepreciationAndAmortizationExpenses DepreciationAndAmortizationExpenses;
	}
	public class cls_OtherExpenses {
			public cls_DirectExpenses DirectExpenses;
			public Integer GrandTotalOfOtherExpenses;	//5562599
			public cls_InDirectExpenses InDirectExpenses;
	}
	class cls_DirectExpenses {
			public Integer FreightFreightInwards;	//0
			public Integer FactoryExpenses;	//0
			public Integer OtherDirectExpenses;	//0
			public cls_Electricity Electricity;
			public Integer WagesLabourCharges;	//260500
			public cls_RepairsAndMaintenance RepairsAndMaintenance;
			public Integer Commission;	//0
			public Integer TotalOfDirectExpenses;	//5517581
			public Integer CarriageInwards;	//0
			public cls_InsuranceCharges InsuranceCharges;
			public cls_Rent Rent;
	}
	public class cls_Electricity {
			public Integer Others;	//5257081
			public Integer Factory;	//0
			public Integer Godown;	//0
	}
	public class cls_RepairsAndMaintenance {
			public Integer Building;	//0
			public Integer Others;	//0
	}
	public class cls_InsuranceCharges {
			public Integer Others;	//0
			public Integer Factory;	//0
			public Integer Godown;	//0
	}
	public class cls_Rent {
			public Integer Others;	//0
			public Integer LeaseRentals;	//0
	}
	public class cls_InDirectExpenses {
			public Integer Water;	//0
			public Integer Entertainment;	//0
			public Integer OtherTaxesPaid;	//8800
			public Integer Impairment;	//0
			public Integer ProvisionForContingencies;	//0
			public Integer Conference;	//0
			public Integer DiscountOnIssueOfDebenturesWrittenOff;	//0
			public Integer PremiumOnRedemptionOfDebentures;	//0
			public Integer SecurityExpenses;	//0
			public Integer PremiumOnRedemptionOfPreferenceShares;	//0
			public cls_TravellingAndConveyance TravellingAndConveyance;
			public Integer DiscountOnIssueOfSharesWrittenOff;	//0
			public Integer PrintingAndStationery;	//2840
			public Integer CommissionBrokerageExpenses;	//0
			public Integer NetLossOnForeignCurrencyTransactionsAndTranslation;	//0
			public Integer LicenseExpense;	//0
			public Integer DevelopmentAndTrainingExpenses;	//0
			public Integer UnderwritingCommission;	//0
			public Integer PreliminaryExpensesWrittenOff;	//0
			public Integer LossOnSaleOfFixedAssets;	//0
			public Integer TotalOfIndirectExpenses;	//45018
			public Integer OfficeExpenses;	//0
			public Integer ProvisionForEstimatedLossesOnOnerousContracts;	//0
			public Integer WarrantiesExpense;	//0
			public Integer TelephoneExpensesCommunicationCharges;	//8850
			public Integer Hospitality;	//0
			public Integer LegalAndProfessionalCharges;	//0
			public cls_ProposedDividend ProposedDividend;
			public Integer BusinessPromotion;	//0
			public Integer IncomeTaxPaid;	//0
			public Integer Subcontracting;	//0
			public Integer DonationAndContributions;	//0
			public cls_ConsumptionOf ConsumptionOf;
			public Integer Royalty;	//0
			public Integer ProfessionalFeesConsultancyFeesFeesForTechnicalServices;	//0
			public Integer SalesDiscountDiscountAllowed;	//0
			public Integer ProvisionForEstimatedLossOnDerivatives;	//0
			public Integer OtherExpenses;	//14678
			public Integer ProvisionForDoubtfulTradeAndOtherReceivablesLoansAndAdvances;	//0
			public Integer AdvertisingMarketingExpenses;	//0
			public Integer IntangibleAssetsWrittenOffAmortised;	//0
			public Integer ProvisionForWarranty;	//0
			public Integer FreightExpenses;	//0
			public Integer PostageAndCourierExpenses;	//0
			public Integer BadTradeAndOtherReceivablesLoansAndAdvancesWrittenOff;	//0
			public cls_RepairsAndMaintenance RepairsAndMaintenance;
			public cls_LossOnSaleOfInvestments LossOnSaleOfInvestments;
			public Integer MiscellaneousExpensesWrittenOff;	//0
			public cls_TaxOnDividend TaxOnDividend;
			public Integer ProvisionForLossesInSubsidiaryCompanies;	//0
			public cls_Rent Rent;
	}
	public class cls_TravellingAndConveyance {
			public Integer ConveyanceExpenses;	//9850
			public Integer DomesticTravellingExpenses;	//0
			public Integer ForeignTravellingExpenses;	//0
	}
	public class cls_ProposedDividend {
			public Integer PreferenceDividend;	//0
			public Integer EquityDividend;	//0
	}
	public class cls_ConsumptionOf {
			public Integer StoresAndSpareParts;	//0
			public Integer OtherMaterials;	//0
			public Integer LooseTools;	//0
	}
	public class cls_LossOnSaleOfInvestments {
			public Integer CurrentInvestments;	//0
			public Integer LongTermInvestments;	//0
	}
	public class cls_TaxOnDividend {
			public Integer PreferenceDividend;	//0
			public Integer EquityDividend;	//0
	}
	public class cls_ChangesInInventories {
			public Integer FinishedGoods;	//0
			public Integer Total;	//0
			public Integer WorkInProgress;	//0
			public Integer StockInTrade;	//0
	}
	public class cls_ManagerialRemuneration {
			public Integer PartTimeDirector;	//0
			public Integer WholeTimeDirector;	//0
			public Integer Total;	//0
			public Integer ManagingDirector;	//0
			public Integer Manager;	//0
	}
	public class cls_FinanceCost {
			public Integer Others;	//0
			public Integer ServiceChargesByOtherFinancialInstitutions;	//0
			public Integer Total;	//2710881
			public cls_InterestExpense InterestExpense;
			public Integer ServiceChargesByBankBankCharges;	//16704
			public Integer QuasiInterest;	//0
	}
	public class cls_InterestExpense {
			public Integer OnOverdraft;	//0
			public Integer OnBankLoans;	//2694177
			public Integer OnCashCredits;	//0
			public Integer OnBondsDebentures;	//0
			public Integer OnOthers;	//0
	}
	public class cls_CostOfMaterialsConsumed {
			public Integer ClosingStock;	//50117121
			public Integer CostOfMaterialsConsumed;	//20975657
			public Integer OpeningStock;	//38800360
			public Integer Purchases;	//32292418
	}
	public class cls_InsuranceExpenses {
			public Integer KeymanInsurance;	//0
			public Integer LifeInsurance;	//0
			public Integer Total;	//43852
			public Integer MedicalInsurance;	//0
			public Integer OtherInsurance;	//43852
	}
	public class cls_PowerAndFuel {
			public Integer OtherFuelExpenses;	//0
			public Integer LiquidFuelExpenses;	//0
			public Integer Total;	//0
			public Integer ElectricityExpenses;	//0
			public Integer GaseousFuelExpenses;	//0
	}
	public class cls_AuditorsFees {
			public Integer OtherServices;	//15000
			public Integer TaxationMatters;	//0
			public Integer Total;	//15000
			public Integer ManagementServices;	//0
			public Integer StatuatoryServices;	//0
			public Integer CompanyLawMatters;	//0
	}
	public class cls_EmployeeBenefitExpenses {
			public Integer Others;	//24385
			public Integer LeaveEncashment;	//0
			public Integer SalariesAndWages;	//0
			public Integer Total;	//24385
			public Integer Bonus;	//0
			public cls_ContributionsToFunds ContributionsToFunds;
			public Integer ReimbursementOfMedicalExpenses;	//0
			public Integer ExpenseOnEmployeeStockOptionScheme;	//0
			public Integer LeaveTravelBenefits;	//0
			public Integer StaffWelfareExpenses;	//0
	}
	public class cls_ContributionsToFunds {
			public Integer ContributionToRecognisedProvidentFund;	//0
			public Integer ContributionToApprovedSuperannuationFund;	//0
			public Integer ContributionToOtherFunds;	//0
			public Integer TotalContributionsToProvidentAndOtherFunds;	//0
			public Integer ContributionToRecognisedGratuityFund;	//0
	}
	public class cls_DepreciationAndAmortizationExpenses {
			public Integer Depreciation;	//498649
			public Integer Total;	//498649
			public Integer Amortisation;	//0
	}
	public class cls_ExceptionalItems {
			public cls_ExceptionalItemsWhichAreGains ExceptionalItemsWhichAreGains;
			public cls_ExceptionalItemsWhichAreLossses ExceptionalItemsWhichAreLossses;
			public Integer Total;	//0
	}
	public class cls_ExceptionalItemsWhichAreGains {
			public Integer ProfitsGainsOnDisposalOfAssetsOtherThanFixedAssets;	//0
			public Integer AbnormalGainsOnLongTermContracts;	//0
			public Integer ProfitsGainsOnDisposalOfFixedAssets;	//0
			public Integer Total;	//0
			public Integer AmountsReceivedInSettlementOfInsuranceClaims;	//0
			public Integer OtherExceptionalItems;	//0
	}
	public class cls_ExceptionalItemsWhichAreLossses {
			public Integer LossesOnDisposalOfFixedAssets;	//0
			public Integer Total;	//0
			public Integer LossesOnDisposalOfAssetsOtherThanFixedAssets;	//0
			public Integer OtherExceptionalItems;	//0
			public Integer AbnormalLossesOnLongTermContracts;	//0
	}
	public class cls_RevenueFromOperations {
			public cls_DomesticTurnover DomesticTurnover;
			public cls_ExportTurnover ExportTurnover;
			public Integer Total;	//30219944
	}
	public class cls_DomesticTurnover {
			public Integer SaleOrSupplyOfServices;	//0
			public Integer NetDomesticTurnover;	//30219944
			public Integer LessExciseAndOtherDuties;	//0
			public Integer SaleOfGoodsManufactured;	//0
			public Integer SaleOfGoodsTraded;	//30219944
			public Integer OtherOperatingIncome;	//0
	}
	public class cls_ExportTurnover {
			public Integer SaleOrSupplyOfServices;	//0
			public Integer LessExciseAndOtherDuties;	//0
			public Integer SaleOfGoodsManufactured;	//0
			public Integer SaleOfGoodsTraded;	//0
			public Integer NetExportTurnover;	//0
			public Integer OtherOperatingIncome;	//0
	}
	public class cls_TaxExpense {
			public Integer CurrentTax;	//0
			public Integer DeferredTax;	//0
	}
	public class cls_BalanceCarriedToBalanceSheetInPropeitorAccount {
			public Integer PartnerA;	//0
			public Integer PartnerC;	//0
			public Integer PartnerB;	//0
			public Integer PartnerE;	//0
			public Integer PartnerD;	//0
			public Integer PartnerG;	//0
			public Integer PartnerF;	//0
			public Integer PartnerQ;	//0
			public Integer PartnerP;	//0
			public Integer PartnerS;	//0
			public Integer PartnerR;	//0
			public Integer PartnerT;	//0
			public Integer Total;	//0
			public Integer PartnerI;	//0
			public Integer PartnerH;	//0
			public Integer PartnerK;	//0
			public Integer PartnerJ;	//0
			public Integer PartnerM;	//0
			public Integer PartnerL;	//0
			public Integer PartnerO;	//0
			public Integer PartnerN;	//0
	}
	public class cls_ExtraordinaryItems {
			public Integer Total;	//0
			public cls_ExtraordinaryItemsWhichAreGains ExtraordinaryItemsWhichAreGains;
			public cls_ExtraordinaryItemsWhichAreLossses ExtraordinaryItemsWhichAreLossses;
	}
	public class cls_ExtraordinaryItemsWhichAreGains {
			public Integer GainsFromTheSaleOfAssets;	//0
			public Integer NegativeGoodwill;	//0
			public Integer InvestorsShareOfInvesteesExtraordinaryItems;	//0
			public Integer WinningALawSuit;	//0
			public Integer Total;	//0
			public Integer UnusualSalesOfAssets;	//0
			public Integer ReceiptOfLICPolicyAmountOnSuddenDeathOfCEOOtherKeyPersons;	//0
			public Integer OtherExtraordinaryItems;	//0
			public Integer GainsFromEarlyRetirementOfDebt;	//0
	}
	public class cls_ExtraordinaryItemsWhichAreLossses {
			public Integer LossesFromCatastrophicEvents;	//0
			public Integer CostsAcquiredFromAcquiringLawSuits;	//0
			public Integer Total;	//0
			public Integer LossesFromTheSaleOfAssets;	//0
			public Integer RestructuringCostsThatComeWithLayingOffEmployees;	//0
			public Integer LossesDueToDebtorsBankruptcy;	//0
			public Integer OtherExtraordinaryItems;	//0
			public Integer LossesFromWritingOffIntangibleAssets;	//0
	}
	public class cls_NonOperatingIncome {
		public cls_InterestIncome InterestIncome;
		public Integer NetIncomeTaxRefunds;	//0
		public Integer MiscellaneousIncome;	//0
		public cls_OtherNonOperatingIncome OtherNonOperatingIncome;
		public Integer GrandTotal;	//72698
		//public Integer OtherNonoperatingIncome;	//72698
		public Integer CommissionIncome;	//0
		public Integer NetGainOnForeignCurrencyTransactionsAndTranslation;	//0
		public cls_DividendIncome DividendIncome;
		public cls_NetGainOnSale NetGainOnSale;
	}
	public class cls_InterestIncome {
		public Integer InterestIncomeFromLongTermInvestments;	//0
		public Integer OtherInterest;	//0
		public Integer InterestIncomeFromCurrentInvestments;	//0
		public Integer InterestOnIncomeTaxRefund;	//0
		public Integer InterestOnOverdueTradeReceivables;	//0
		public Integer InterestFromBanks;	//0
		public Integer TotalInterestIncome;	//0
		public Integer InterestOnLoansAndAdvances;	//0
	}
	public class cls_OtherNonOperatingIncome {
		public Integer ShareOfProfitFromLLPs;	//0
		public Integer ShareOfProfitFromPartnershipFirms;	//0
		public Integer ShareOfProfitFromAOPs;	//0
		public Integer ProfitOnSaleOfFixedAssets;	//0
		public Integer LiabilitiesProvisionsNoLongerRequired;	//0
		public Integer RentalIncomeIncludingRentFromOperatingLeases;	//0
		public Integer TotalOtherNonOperatingIncome;	//0
		public Integer RentalIncomeFromInvestmentProperties;	//0
	}
	public class cls_DividendIncome {
		public Integer TotalDividendIncome;	//0
		public Integer FromCurrentInvestments;	//0
		public Integer FromLongtermInvestments;	//0
	}
	public class cls_NetGainOnSale {
		public Integer TotalNetGainOnSaleOfInvestments;	//0
		public Integer LongtermInvestments;	//0
		public Integer CurrentInvestments;	//0
	}
	public class cls_EarningsPerEquityShareBeforeExtraordinaryItems {
		public Integer Basic;	//0
		public Integer Diluted;	//0
	}
	public class cls_BalanceSheet {
		public cls_Assets Assets;
		public cls_EquitiesAndLiabilities EquitiesAndLiabilities;
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
		public Integer Others;	//0
		public Integer LessProvisionForObsoleteStock;	//0
		public Integer GrossTotalOfInventories;	//50117121
		public Integer ObsoleteStock;	//0
		public Integer FinishedGoods;	//50117121
		public Integer NetOfInventories;	//50117121
		public Integer StoresAndSparesConsumables;	//0
		public Integer GoodsInTransit;	//0
		public Integer Stockintrade;	//0
		public Integer RawMaterials;	//0
		public Integer LooseTools;	//0
		public Integer Workinprogress;	//0
	}
	public class cls_CashAndCashEquivalents {
		public cls_BalancesWithBanks BalancesWithBanks;
		public Integer Others;	//0
		public Integer CashOnHand;	//360061
		public Integer Total;	//360061
		public Integer ChequesDraftsOnHand;	//0
	}
	public class cls_BalancesWithBanks {
		public Integer InFlexiDepositAccounts;	//0
		public Integer InCurrentAccounts;	//0
		public Integer InDepositAccounts;	//0
		public Integer InEEFCAccounts;	//0
		public cls_InEarmarkedAccounts InEarmarkedAccounts;
	}
	public class cls_InEarmarkedAccounts {
		public Integer OtherEarmarkedAccounts;	//0
		public Integer UnpaidMaturedDebentures;	//0
		public Integer UnpaidMaturedDeposits;	//0
		public Integer UnpaidDividendAccounts;	//0
	}
	public class cls_OtherCurrentAssets {
		public Integer ContractuallyReimbursableExpenses;	//0
		public Integer Others;	//0
		public Integer UnbilledRevenue;	//0
		public Integer BalanceWithGovernmentAuthorities;	//0
		public Integer InterestAccruedOnTradeReceivables;	//0
		public Integer Total;	//0
		public Integer InterestAccruedOnInvestments;	//0
		public Integer InsuranceClaims;	//0
		public Integer InterestAccruedOnDeposits;	//0
		public Integer AncillaryBorrowingCosts;	//0
	}
	public class cls_TradeReceivablesOrSundryDebtors {
		public cls_WithinSixMonths WithinSixMonths;
		public cls_ExceedingSixMonths ExceedingSixMonths;
		public Integer Total;	//3645852
	}
	public class cls_WithinSixMonths {
		public Integer LessProvisionAllowanceForBadAndDoubtfulDebts;	//0
		public Integer Doubtful;	//0
		public Integer DebtDueByDirectorsothersOfficersOfTheCompany;	//0
		public Integer NetTradeReceivables;	//3645852
		public Integer SecuredConsideredGood;	//0
		public Integer TotalTradeReceivables;	//3645852
		public Integer UnsecuredConsideredGood;	//3645852
	}
	public class cls_ExceedingSixMonths {
		public Integer LessProvisionAllowanceForBadAndDoubtfulDebts;	//0
		public Integer Doubtful;	//0
		public Integer DebtDueByDirectorsothersOfficersOfTheCompany;	//0
		public Integer NetTradeReceivables;	//0
		public Integer SecuredConsideredGood;	//0
		public Integer TotalTradeReceivables;	//0
		public Integer UnsecuredConsideredGood;	//0
	}
	public class cls_ShortTermLoansAndAdvances {
		public cls_SecuredShortTermLoansAndAdvances SecuredShortTermLoansAndAdvances;
		public Integer Total;	//521980
		public cls_UnSecuredShortTermLoansAndAdvances UnSecuredShortTermLoansAndAdvances;
		public cls_DoubtfulShortTermLoansAndAdvances DoubtfulShortTermLoansAndAdvances;
	}
	public class cls_SecuredShortTermLoansAndAdvances {
		public Integer OtherLoansAndAdvances;	//0
		public Integer SecurityDeposits;	//0
		public Integer NetSecuredShortTermLoanAndAdvances;	//0
		public Integer TotalOfSecuredShortTermLoanAndAdvances;	//0
		public Integer AdvanceTax;	//0
		public Integer LoansAndAdvancesToRelatedParties;	//0
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Integer LoansAndAdvancesToEmployees;	//0
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Integer InterCorporateDeposits;	//0
		public Integer LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//0
	}
	public class cls_BalancesWithGovernmentAuthorities {
		public Integer VATCreditReceivable;	//0
		public Integer CENVATCreditReceivable;	//0
		public Integer TotalBalancesWithGovernmentAuthorities;	//0
		public Integer ServiceTaxCreditReceivable;	//0
		public Integer OtherReceivables;	//0
	}
	public class cls_AllowanceForBadAndDoubtfulLoansAndAdvances {
		public Integer FromOthers;	//0
		public Integer FromRelatedParties;	//0
	}
	public class cls_PrepaidExpenses {
		public Integer AnnualMaintnanceContracts;	//0
		public Integer OtherPrepaidExpenses;	//0
		public Integer InsurancePremium;	//0
		public Integer TotalPrepaidExpenses;	//0
	}
	public class cls_UnSecuredShortTermLoansAndAdvances {
		public Integer OtherLoansAndAdvances;	//0
		public Integer SecurityDeposits;	//521980
		public Integer AdvanceTax;	//0
		public Integer TotalOfUnsecuredShortTermLoanAndAdvances;	//521980
		public Integer LoansAndAdvancesToRelatedParties;	//0
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Integer NetUnsecuredShortTermLoanAndAdvances;	//521980
		public Integer LoansAndAdvancesToEmployees;	//0
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Integer InterCorporateDeposits;	//0
		public Integer LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//0
	}
	public class cls_DoubtfulShortTermLoansAndAdvances {
		public Integer OtherLoansAndAdvances;	//0
		public Integer NetDoubtfulShortTermLoanAndAdvances;	//0
		public Integer TotalOfDoubtfulShortTermLoanAndAdvances;	//0
		public Integer SecurityDeposits;	//0
		public Integer AdvanceTax;	//0
		public Integer LoansAndAdvancesToRelatedParties;	//0
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Integer LoansAndAdvancesToEmployees;	//0
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Integer InterCorporateDeposits;	//0
		public Integer LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//0
	}
	public class cls_CurrentInvestments {
		public Integer InvestmentInMutualFunds;	//0
		public cls_InvestmentInDebenturesOrBonds InvestmentInDebenturesOrBonds;
		public cls_InvestmentProperty InvestmentProperty;
		public cls_InvestmentInEquityInstruments InvestmentInEquityInstruments;
		public Integer OtherCurrentInvestments;	//0
		public Integer Total;	//0
		public cls_CurrentPortionOfLongTermInvestments CurrentPortionOfLongTermInvestments;
		public cls_InvestmentInGovernmentAndTrustSecurities InvestmentInGovernmentAndTrustSecurities;
		public Integer InvestmentInPartnershipFirms;	//0
		public cls_InvestmentInPreferenceShares InvestmentInPreferenceShares;
	}
	public class cls_InvestmentInDebenturesOrBonds {
		public Integer OfSubsidiaries;	//0
		public Integer OfJointVentureCompanies;	//0
		public Integer OfOtherEntities;	//0
		public Integer Total;	//0
		public Integer OfAssociates;	//0
		public Integer OfControlledSpecialPurposeEntities;	//0
	}
	public class cls_InvestmentProperty {
		public Integer NetInvestmentProperty;	//0
		public Integer Impairment;	//0
		public Integer GrossTotalOfInvestmentProperty;	//0
		public Integer LessDepreciation;	//0
	}
	public class cls_InvestmentInEquityInstruments {
		public Integer OfSubsidiaries;	//0
		public Integer OfJointVentureCompanies;	//0
		public Integer OfOtherEntities;	//0
		public Integer Total;	//0
		public Integer OfAssociates;	//0
		public Integer OfControlledSpecialPurposeEntities;	//0
	}
	public class cls_CurrentPortionOfLongTermInvestments {
		public Integer InvestmentInMutualFunds;	//0
		public Integer InvestmentInTrustSecurities;	//0
		public Integer InvestmentInDebenturesOrBonds;	//0
		public Integer LessProvisionForDiminutionInValueOfCurrentPortionOfLongTermInvestments;	//0
		public Integer NetOfCurrentPortionOfLongTermInvestments;	//0
		public Integer OtherInvestments;	//0
		public Integer GrossTotalOfCurrentPortionOfLongTermInvestments;	//0
		public Integer InvestmentInGovernmentSecurities;	//0
		public Integer InvestmentInPreferenceShares;	//0
	}
	public class cls_InvestmentInGovernmentAndTrustSecurities {
		public Integer TrustSecurities;	//0
		public Integer GovernmentSecurities;	//0
		public Integer Total;	//0
	}
	public class cls_InvestmentInPreferenceShares {
		public Integer OfSubsidiaries;	//0
		public Integer OfJointVentureCompanies;	//0
		public Integer OfOtherEntities;	//0
		public Integer Total;	//0
		public Integer OfAssociates;	//0
		public Integer OfControlledSpecialPurposeEntities;	//0
	}
	public class cls_NonCurrentAssets {
		public Integer DeferredTaxAssets;	//0
		public cls_FixedAssets FixedAssets;
		public cls_LongTermLoansAndAdvances LongTermLoansAndAdvances;
		public cls_OtherNonCurrentAssets OtherNonCurrentAssets;
		public cls_NonCurrentInvestments NonCurrentInvestments;
	}
	public class cls_FixedAssets {
		public cls_InTangibleAssets InTangibleAssets;
		public Integer CapitalWorkInProgress;	//0
		public Integer InTangibleAssetsUnderDevelopment;	//0
		public cls_TangibleAssets TangibleAssets;
	}
	public class cls_InTangibleAssets {
		public cls_InTangibleAssetsDepreciation InTangibleAssetsDepreciation;
		public cls_InTangibleAssetsNet InTangibleAssetsNet;
		public cls_InTangibleAssetsGrossBlock InTangibleAssetsGrossBlock;
	}
	public class cls_InTangibleAssetsDepreciation {
		public Integer LicensesAndFranchise;	//0
		public Integer Others;	//0
		public Integer MiningRights;	//0
		public Integer ModelsDesignsAndPrototypes;	//0
		public Integer ComputerSoftware;	//0
		public Integer Goodwill;	//0
		public Integer Total;	//0
		public Integer CopyrightsPatentsAndOtherIntellectualPropertyRights;	//0
		public Integer MastheadsAndPublishingTitles;	//0
		public Integer BrandsTrademarks;	//0
	}
	public class cls_InTangibleAssetsNet {
		public Integer LicensesAndFranchise;	//0
		public Integer Others;	//0
		public Integer MiningRights;	//0
		public Integer ModelsDesignsAndPrototypes;	//0
		public Integer ComputerSoftware;	//0
		public Integer Goodwill;	//0
		public Integer Total;	//0
		public Integer CopyrightsPatentsAndOtherIntellectualPropertyRights;	//0
		public Integer MastheadsAndPublishingTitles;	//0
		public Integer BrandsTrademarks;	//0
	}
	public class cls_InTangibleAssetsGrossBlock {
		public Integer LicensesAndFranchise;	//0
		public Integer Others;	//0
		public Integer MiningRights;	//0
		public Integer ModelsDesignsAndPrototypes;	//0
		public Integer ComputerSoftware;	//0
		public Integer Goodwill;	//0
		public Integer Total;	//0
		public Integer CopyrightsPatentsAndOtherIntellectualPropertyRights;	//0
		public Integer MastheadsAndPublishingTitles;	//0
		public Integer BrandsTrademarks;	//0
	}
	public class cls_TangibleAssets {
		public cls_TangibleAssetsDepreciation TangibleAssetsDepreciation;
		public cls_TangibleAssetsNet TangibleAssetsNet;
		public cls_TangibleAssetsGrossBlock TangibleAssetsGrossBlock;
	}
	public class cls_TangibleAssetsDepreciation {
		public Integer Computers;	//325
		public Integer Others;	//205298
		public Integer Buildings;	//37510
		public Integer FurnitureAndFixtures;	//1455
		public Integer PlantAndEquipment;	//254061
		public Integer LeaseholdImprovements;	//0
		public Integer Total;	//498649
		public Integer OfficeEquipment;	//0
		public Integer Land;	//0
		public Integer Vehicles;	//0
	}
	public class cls_TangibleAssetsNet {
		public Integer Computers;	//217
		public Integer Others;	//1163356
		public Integer Buildings;	//337588
		public Integer FurnitureAndFixtures;	//13090
		public Integer PlantAndEquipment;	//1439678
		public Integer LeaseholdImprovements;	//0
		public Integer Total;	//2953929
		public Integer OfficeEquipment;	//0
		public Integer Land;	//0
		public Integer Vehicles;	//0
	}
	public class cls_TangibleAssetsGrossBlock {
		public Integer Computers;	//542
		public Integer Others;	//1368654
		public Integer Buildings;	//375098
		public Integer FurnitureAndFixtures;	//14545
		public Integer PlantAndEquipment;	//1693739
		public Integer LeaseholdImprovements;	//0
		public Integer Total;	//3452578
		public Integer OfficeEquipment;	//0
		public Integer Land;	//0
		public Integer Vehicles;	//0
	}
	public class cls_LongTermLoansAndAdvances {
		public cls_DoubtfulLongTermLoansAndAdvances DoubtfulLongTermLoansAndAdvances;
		public Integer Total;	//0
		public cls_UnsecuredLongTermLoansAndAdvances UnsecuredLongTermLoansAndAdvances;
		public cls_SecuredLongTermLoansAndAdvances SecuredLongTermLoansAndAdvances;
	}
	public class cls_DoubtfulLongTermLoansAndAdvances {
		public Integer OtherLoansAndAdvances;	//0
		public Integer TotalDoubtfulLongTermLoanAndAdvances;	//0
		public Integer CapitalAdvances;	//0
		public Integer SecurityDeposits;	//0
		public Integer LoansAndAdvancesToRelatedParties;	//0
		public Integer MATCreditAvailment;	//0
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Integer NetDoubtfulLongTermLoanAndAdvances;	//0
		public Integer LoansAndAdvancesToEmployees;	//0
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Integer LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//0
	}
	public class cls_UnsecuredLongTermLoansAndAdvances {
		public Integer OtherLoansAndAdvances;	//0
		public Integer CapitalAdvances;	//0
		public Integer SecurityDeposits;	//0
		public Integer LoansAndAdvancesToRelatedParties;	//0
		public Integer MATCreditAvailment;	//0
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Integer NetUnsecuredLongTermLoanAndAdvances;	//0
		public Integer LoansAndAdvancesToEmployees;	//0
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Integer TotalUnsecuredLongTermLoanAndAdvances;	//0
		public Integer LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//0
	}
	public class cls_SecuredLongTermLoansAndAdvances {
		public Integer OtherLoansAndAdvances;	//0
		public Integer CapitalAdvances;	//0
		public Integer SecurityDeposits;	//0
		public Integer LoansAndAdvancesToRelatedParties;	//0
		public Integer MATCreditAvailment;	//0
		public cls_BalancesWithGovernmentAuthorities BalancesWithGovernmentAuthorities;
		public Integer TotalSecuredLongTermLoanAndAdvances;	//0
		public Integer LoansAndAdvancesToEmployees;	//0
		public cls_AllowanceForBadAndDoubtfulLoansAndAdvances AllowanceForBadAndDoubtfulLoansAndAdvances;
		public cls_PrepaidExpenses PrepaidExpenses;
		public Integer NetSecuredLongTermLoanAndAdvances;	//0
		public Integer LoansAndAdvancesDueByDirectorsOtherOfficersOfTheCompany;	//0
	}
	public class cls_OtherNonCurrentAssets {
		public Integer ContractuallyReimbursableExpenses;	//0
		public Integer Others;	//0
		public Integer InterestAccruedOnTradeReceivables;	//0
		public Integer InterestAccruedOnInvestments;	//0
		public Integer InsuranceClaims;	//0
		public Integer ShareIssueExpenses;	//0
		public Integer InterestAccruedOnDeposits;	//0
		public Integer TradeReceivables;	//0
		public Integer DiscountOnIssueOfDebentures;	//0
		public Integer ReceivablesOnSaleOfFixedAssets;	//0
		public Integer DiscountOnIssueOfShares;	//0
		public Integer Total;	//0
		public Integer AncillaryBorrowingCosts;	//0
	}
	public class cls_NonCurrentInvestments {
		public Integer Total;	//0
		public cls_TradeInvestments TradeInvestments;
		public cls_OtherInvestments OtherInvestments;
	}
	public class cls_TradeInvestments {
		public Integer InvestmentInMutualFunds;	//0
		public Integer TotalOfNonCurrentTradeInvestments;	//0
		public cls_InvestmentInDebenturesOrBonds InvestmentInDebenturesOrBonds;
		public cls_InvestmentProperty InvestmentProperty;
		public cls_InvestmentInEquityInstruments InvestmentInEquityInstruments;
		public Integer GrossTotal;	//0
		public Integer LessProvisionForDiminutionInValueOfInvestments;	//0
		public cls_InvestmentInGovernmentAndTrustSecurities InvestmentInGovernmentAndTrustSecurities;
		public Integer InvestmentInPartnershipFirms;	//0
		public cls_InvestmentInPreferenceShares InvestmentInPreferenceShares;
		public Integer OtherLongTermInvestments;	//0
	}
	public class cls_OtherInvestments {
		public Integer InvestmentInMutualFunds;	//0
		public Integer TotalOfOtherNonCurrentInvestments;	//0
		public cls_InvestmentInDebenturesOrBonds InvestmentInDebenturesOrBonds;
		public cls_InvestmentProperty InvestmentProperty;
		public cls_InvestmentInEquityInstruments InvestmentInEquityInstruments;
		public Integer GrossTotal;	//0
		public Integer LessProvisionForDiminutionInValueOfInvestments;	//0
		public cls_InvestmentInGovernmentAndTrustSecurities InvestmentInGovernmentAndTrustSecurities;
		public Integer InvestmentInPartnershipFirms;	//0
		public cls_InvestmentInPreferenceShares InvestmentInPreferenceShares;
		public Integer OtherLongTermInvestments;	//0
	}
	public class cls_EquitiesAndLiabilities {
		public cls_ShareholdersFunds ShareholdersFunds;
		public cls_NonCurrentLiabilitiesOrLongTermLiabilities NonCurrentLiabilitiesOrLongTermLiabilities;
		public Integer ShareApplicationMoneyPendingAllotment;	//0
		public Integer Total;	//57598943
		public cls_CurrentLiabilitiesOrShortTermLiabilities CurrentLiabilitiesOrShortTermLiabilities;
	}
	public class cls_ShareholdersFunds {
		public cls_ShareCapital ShareCapital;
		public cls_ReserveAndSurplus ReserveAndSurplus;
		public Integer MoneyReceivedAgainstShareWarrants;	//0
	}
	public class cls_ShareCapital {
		public cls_InCaseOfCorporates InCaseOfCorporates;
		public cls_InCaseOfPropreitershipOrPartnership InCaseOfPropreitershipOrPartnership;
		public Double Total;	//11897583.82
	}
	public class cls_InCaseOfCorporates {
		public cls_IssuedCapital IssuedCapital;
		public cls_SubscribedButNotFullyPaidUp SubscribedButNotFullyPaidUp;
		public cls_AuthorisedShareCapital AuthorisedShareCapital;
		public cls_SubscribedAndFullyPaidUp SubscribedAndFullyPaidUp;
	}
	public class cls_IssuedCapital {
		public Integer EquityShareCapital;	//0
		public Integer TotalOfIssuedCapital;	//0
		public Integer PreferenceShareCapital;	//0
	}
	public class cls_SubscribedButNotFullyPaidUp {
		public Integer EquityShareCapital;	//0
		public Integer TotalOfSubscribedButNotFullyPaidUpCapital;	//0
		public Integer PreferenceShareCapital;	//0
	}
	public class cls_AuthorisedShareCapital {
		public Integer EquityShareCapital;	//0
		public Integer PreferenceShareCapital;	//0
		public Integer TotalOfAuthorisedShareCapital;	//0
	}
	public class cls_SubscribedAndFullyPaidUp {
		public cls_EquityShareCapital EquityShareCapital;
		public cls_PreferenceShareCapital PreferenceShareCapital;
	}
	public class cls_EquityShareCapital {
		public Integer Others;	//0
		public Integer PrivatePlacementArisingOutOfConversionOfDebenturesOrPreferenceShares;	//0
		public Integer PublicIssue;	//0
		public Integer OtherPrivatePlacement;	//0
		public Integer SubscribedAndFullyPaidUp;	//0
		public Integer RightsIssue;	//0
		public Integer BonusIssue;	//0
		public Integer EmployeeStockOptionPlan;	//0
		public Integer Total;	//0
		public Integer PreferentialAllotmentArisingOutOfConversionOfDebenturesOrPreferenceShares;	//0
		public Integer CallsUnpaidByOthers;	//0
		public Integer OtherPreferentialAllotment;	//0
		public Integer LessCallsUnpaidByDirectors;	//0
	}
	public class cls_PreferenceShareCapital {
		public Integer Others;	//0
		public Integer PrivatePlacementArisingOutOfConversionOfDebenturesOrPreferenceShares;	//0
		public Integer PublicIssue;	//0
		public Integer OtherPrivatePlacement;	//0
		public Integer SubscribedAndFullyPaidUp;	//0
		public Integer RightsIssue;	//0
		public Integer BonusIssue;	//0
		public Integer EmployeeStockOptionPlan;	//0
		public Integer Total;	//0
		public Integer PreferentialAllotmentArisingOutOfConversionOfDebenturesOrPreferenceShares;	//0
		public Integer CallsUnpaidByOthers;	//0
		public Integer OtherPreferentialAllotment;	//0
		public Integer LessCallsUnpaidByDirectors;	//0
	}
	public class cls_InCaseOfPropreitershipOrPartnership {
		public cls_PartnersCapitalAccount PartnersCapitalAccount;
		public cls_PartnersCurrentAccount PartnersCurrentAccount;
	}
	public class cls_PartnersCapitalAccount {
		public Double PartnerA;	//11897583.82
		public Integer PartnerC;	//0
		public Integer PartnerB;	//0
		public Integer PartnerE;	//0
		public Integer PartnerD;	//0
		public Integer PartnerG;	//0
		public Integer PartnerF;	//0
		public Integer PartnerQ;	//0
		public Integer PartnerP;	//0
		public Integer PartnerS;	//0
		public Integer PartnerR;	//0
		public Integer PartnerT;	//0
		public Double Total;	//11897583.82
		public Integer PartnerI;	//0
		public Integer PartnerH;	//0
		public Integer PartnerK;	//0
		public Integer PartnerJ;	//0
		public Integer PartnerM;	//0
		public Integer PartnerL;	//0
		public Integer PartnerO;	//0
		public Integer PartnerN;	//0
	}
	public class cls_PartnersCurrentAccount {
		public Integer PartnerA;	//0
		public Integer PartnerC;	//0
		public Integer PartnerB;	//0
		public Integer PartnerE;	//0
		public Integer PartnerD;	//0
		public Integer PartnerG;	//0
		public Integer PartnerF;	//0
		public Integer PartnerQ;	//0
		public Integer PartnerP;	//0
		public Integer PartnerS;	//0
		public Integer PartnerR;	//0
		public Integer PartnerT;	//0
		public Integer Total;	//0
		public Integer PartnerI;	//0
		public Integer PartnerH;	//0
		public Integer PartnerK;	//0
		public Integer PartnerJ;	//0
		public Integer PartnerM;	//0
		public Integer PartnerL;	//0
		public Integer PartnerO;	//0
		public Integer PartnerN;	//0
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
		public Integer Total;	//0
		public cls_ForeignCurrencyTranslationReserve ForeignCurrencyTranslationReserve;
	}
	public class cls_RevaluationReserve {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer AddAdditionOnRevaluationsDuringTheYear;	//0
		public Integer LessUtilisedDuringTheYear;	//0
	}
	public class cls_ShareOptionsOutstandingAccount {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer LessUtilisedDuringTheYear;	//0
		public Integer AddAmountsRecordedOnGrantsmodificationscancellationsDuringTheYear;	//0
	}
	public class cls_DebentureRedemptionReserve {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer AddAdditionsDuringTheYear;	//0
		public Integer LessUtilisedDuringTheYear;	//0
	}
	public class cls_OtherReserves {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer LessUtilisationsDuringTheYear;	//0
		public Integer AddAdditionsDuringTheYear;	//0
	}
	public class cls_SurplusOrDeficitInTheStatementOfProfitAndLoss {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer LessUtilisationsDuringTheYear;	//0
		public Integer AddAdditionsDuringTheYear;	//0
	}
	public class cls_SurplusToBeDistributedToThePartners {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer LessUtilisationsDuringTheYear;	//0
		public Integer AddAdditionsDuringTheYear;	//0
	}
	public class cls_HedgingReserve {
		public Integer AddEffectOfForeignExchangeRateVariationsOnHedgingInstrumentsOutstandingAtTheEndOfTheYear;	//0
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer LessEffectOfForeignExchangeRateVariationsOnHedgingInstrumentsOutstandingAtTheEndOfTheYear;	//0
	}
	public class cls_SecuritiesPremiumAccount {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer AddAdditionsDuringTheYear;	//0
		public Integer LessUtilisedDuringTheYear;	//0
	}
	public class cls_CapitalRedemptionReserve {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer AddAdditionsDuringTheYear;	//0
		public Integer LessUtilisedDuringTheYear;	//0
	}
	public class cls_CapitalReserve {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer AddAdditionsDuringTheYear;	//0
		public Integer LessUtilisedDuringTheYear;	//0
	}
	public class cls_GeneralReserve {
		public Integer ClosingBalance;	//0
		public Integer AddTransferredFromSurplusInStatementOfProfitAndLoss;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer LessUtilisedDuringTheYear;	//0
	}
	public class cls_ForeignCurrencyTranslationReserve {
		public Integer ClosingBalance;	//0
		public Integer OpeningBalance;	//0
		public Integer TransferredDuringTheYear;	//0
		public Integer AddEffectOfForeignExchangeRateVariationsDuringTheYear;	//0
		public Integer LessEffectOfForeignExchangeRateVariationsDuringTheYear;	//0
	}
	public class cls_NonCurrentLiabilitiesOrLongTermLiabilities {
		public cls_LongTermBorrowings LongTermBorrowings;
		public Integer DeferredTaxLiabilities;	//0
		public cls_LongTermProvisions LongTermProvisions;
		public cls_OtherLongTermLiabilities OtherLongTermLiabilities;
	}
	public class cls_LongTermBorrowings {
		public cls_UnSecuredLongTermBorrowings UnSecuredLongTermBorrowings;
		public Integer Total;	//22306673
		public cls_SecuredLongTermBorrowings SecuredLongTermBorrowings;
	}
	public class cls_UnSecuredLongTermBorrowings {
		public cls_DomesticLoans DomesticLoans;
		public Integer OutOfAboveTotalAggregateAmountGuaranteedByDirectors;	//0
		public Integer TotalUnsecuredLongTermBorrowings;	//2845661
		public Integer ForeignCurrencyLoans;	//0
	}
	public class cls_DomesticLoans {
		public Integer LoansAndAdvancesFromRelatedParties;	//0
		public Integer OtherLoansAndAdvances;	//0
		public Integer Deposits;	//0
		public cls_LoansRepayableOnDemand LoansRepayableOnDemand;
		public Integer InterCorporateBorrowings;	//0
		public Integer CashCredits;	//0
		public Integer Overdrafts;	//0
	}
	public class cls_TermLoans {
		public Integer FromBanks;	//0
		public Integer FromOtherParties;	//0
	}
	public class cls_SecuredLongTermBorrowings {
		public cls_DomesticLoans DomesticLoans;
		public Integer OutOfAboveTotalAggregateAmountGuaranteedByDirectors;	//0
		public Integer TotalSecuredLongTermBorrowings;	//19461012
		public Integer ForeignCurrencyLoans;	//0
	}
	public class cls_LongTermProvisions {
		public Integer Total;	//0
		public cls_ProvisionForEmployeeBenefits ProvisionForEmployeeBenefits;
		public cls_ProvisionOthers ProvisionOthers;
	}
	public class cls_ProvisionForEmployeeBenefits {
		public Integer ProvisionForPostemploymentMedicalBenefits;	//0
		public Integer ProvisionForCompensatedAbsences;	//0
		public Integer Total;	//0
		public Integer ProvisionForOtherEmployeeBenefits;	//0
		public Integer ProvisionForOtherDefinedBenefitPlans;	//0
		public Integer ProvisionForBonus;	//0
		public Integer ProvisionForGratuity;	//0
	}
	public class cls_ProvisionOthers {
		public Integer ProvisionForPremiumPayableOnRedemptionOfBonds;	//0
		public Integer ProvisionForProposedPreferenceDividend;	//0
		public Integer ProvisionForOtherContingencies;	//0
		public Integer ProvisionForEstimatedLossesOnOnerousContracts;	//0
		public Integer Total;	//526336
		public Integer ProvisionForEstimatedLossOnDerivatives;	//0
		public Integer ProvisionForTaxOnProposedDividends;	//0
		public Integer ProvisionForWarranty;	//0
		public Integer ProvisionForProposedEquityDividend;	//0
		public Integer ProvisionOthers;	//526336
		public Integer ProvisionForTax;	//0
	}
	public class cls_OtherLongTermLiabilities {
		public cls_Others Others;
		public Integer Total;	//0
		public cls_TradePayables TradePayables;
	}
	public class cls_Others {
		public Integer Others;	//0
		public Integer InterestAccruedButNotDueOnBorrowings;	//0
		public Integer InterestAccruedOnOthers;	//0
		public Integer ContractuallyReimburseableExpenses;	//0
		public Integer TradeSecurityDeposits;	//0
		public Integer PayablesOnPurchaseOfFixedAssets;	//0
		public Integer InterestAccruedOnTradePayables;	//0
		public Integer IncomeReceivedInAdvance;	//0
		public Integer AdvancesFromCustomers;	//0
	}
	public class cls_TradePayables {
		public Integer Acceptances;	//0
		public Integer OtherThanAcceptances;	//0
	}
	public class cls_CurrentLiabilitiesOrShortTermLiabilities {
		public cls_TradePayablesOrSundryCreditors TradePayablesOrSundryCreditors;
		public cls_ShortTermBorrowings ShortTermBorrowings;
		public cls_ShortTermProvisions ShortTermProvisions;
		public cls_OtherCurrentLiabilities OtherCurrentLiabilities;
	}
	public class cls_TradePayablesOrSundryCreditors {
		public cls_ForGoods ForGoods;
		public Double Total;	//22868350.18
		public cls_ForExpenses ForExpenses;
	}
	public class cls_ForGoods {
		public Integer Acceptances;	//0
		public Double Others;	//22868350.18
	}
	public class cls_ForExpenses {
		public Integer Acceptances;	//0
		public Integer Others;	//0
	}
	public class cls_ShortTermBorrowings {
		public cls_SecuredShortTermBorrowings SecuredShortTermBorrowings;
		public Integer Total;	//0
		public cls_UnSecuredShortTermBorrowings UnSecuredShortTermBorrowings;
	}
	public class cls_SecuredShortTermBorrowings {
		public cls_DomesticLoans DomesticLoans;
		public Integer OutOfAboveTotalAggregateAmountGuaranteedByDirectors;	//0
		public Integer TotalSecuredShortTermBorrowings;	//0
		public Integer ForeignCurrencyLoans;	//0
	}
	public class cls_LoansRepayableOnDemand {
		public Integer FromBanks;	//0
		public Integer FromOtherParties;	//0
	}
	public class cls_UnSecuredShortTermBorrowings {
		public cls_DomesticLoans DomesticLoans;
		public Integer TotalUnsecuredShortTermBorrowings;	//0
		public Integer OutOfAboveTotalAggregateAmountGuaranteedByDirectors;	//0
		public Integer ForeignCurrencyLoans;	//0
	}
	public class cls_ShortTermProvisions {
		public Integer Total;	//526336
		public cls_ProvisionForEmployeeBenefits ProvisionForEmployeeBenefits;
		public cls_ProvisionOthers ProvisionOthers;
	}
	public class cls_OtherCurrentLiabilities {
		public Integer UnpaidMaturedDebenturesAndInterestAccruedThereon;	//0
		public Integer InterestAccruedButNotDueOnBorrowings;	//0
		public cls_OtherPayables OtherPayables;
		public Integer UnpaidDividends;	//0
		public Integer CurrentMaturitiesOfFinanceLeaseObligations;	//0
		public Integer Total;	//0
		public Integer InterestAccruedAndDueOnBorrowings;	//0
		public Integer ContractuallyReimburseableExpenses;	//0
		public Integer IncomeReceivedInAdvance;	//0
		public Integer CurrentMaturitiesOfLongtermDebt;	//0
		public Integer UnpaidMaturedDepositsAndInterestAccruedThereon;	//0
	}
	public class cls_OtherPayables {
		public Integer Others;	//0
		public cls_StatutoryRemittances StatutoryRemittances;
		public Integer InterestAccruedOnOthers;	//0
		public Integer TradeSecurityDeposits;	//0
		public Integer InterestAccruedOnTradePayables;	//0
	}
	public class cls_StatutoryRemittances {
		public Integer ContributionToEmployeesStateInsurance;	//0
		public Integer Others;	//0
		public Integer Total;	//0
		public Integer VATPayable;	//0
		public Integer ContributionToProvidentFund;	//0
		public Integer WealthTaxPayable;	//0
		public Integer ExciseDutyPayable;	//0
		public Integer CustomsDutyPayable;	//0
		public Integer EntryTaxPayable;	//0
	}
	public class cls_CompanyDetails {
		public String Year;	//2015-16
	}
	public class cls_CashFlowStatement {
		public Integer CashAndCashEquivalentsAtTheEndOfTheYear;	//360061
		public Integer AddCashAndCashEquivalentsAtTheBeginningOfTheYear;	//0
		public cls_CashFlowFromOperatingActivities CashFlowFromOperatingActivities;
		public cls_CashFlowFromFinancingActivities CashFlowFromFinancingActivities;
		public cls_CashFlowFromInvestingActivities CashFlowFromInvestingActivities;
		public Integer CashAndCashEquivalentsAsPerTheBooks;	//360061
		public Integer Difference;	//0
		public Integer NetIncreaseOrDecreaseInCashAndCashEquivalents;	//360061
	}
	public class cls_CashFlowFromOperatingActivities {
		public Integer CashFlowFromExtraordinaryItems;	//0
		public cls_ItemsToBeAddedMinusFinanceCosts ItemsToBeAddedMinusFinanceCosts;
		public cls_ItemsToBeDeductedMinusNonOperatingIncome ItemsToBeDeductedMinusNonOperatingIncome;
		public cls_ChangesInWorkingCapital ChangesInWorkingCapital;
		public Integer CashFlowFromExceptionalItems;	//0
		public Integer NetIncomeTaxPaidOrRefunds;	//0
		public Double NetCashFlowFromOrUsedInOperatingActivities;	//-27235821.82
		public Integer NetProfitOrLossBeforeExceptionalAndExtraordinaryItemsAndTax;	//461619
		public cls_ItemsToBeAddedMinusNonOperatingExpenses ItemsToBeAddedMinusNonOperatingExpenses;
		public Double OperatingProfitOrLossBeforeExtraordinaryItems;	//-27235821.82
		public Integer OperatingProfitOrLossBeforeAdjustmentsAndWorkingCapitalChanges;	//3654445
		public Double OperatingProfitOrLossBeforeExceptionalAndExtraordinaryItems;	//-27235821.82
		public Integer OperatingProfitOrLossBeforeWorkingCapitalChanges;	//3654445
	}
	public class cls_ItemsToBeAddedMinusFinanceCosts {
		public Integer OtherFinanceCost;	//0
		public Integer InterestExpenseOnOtherBorrowings;	//0
		public Integer InterestExpenseOnBankLoans;	//2694177
		public Integer InterestExpenseOnDebentures;	//0
		public Integer InterestExpenseOnCashCredits;	//0
		public Integer QuasiInterest;	//0
		public Integer InterestExpenseOnOverdrafts;	//0
	}
	public class cls_ItemsToBeDeductedMinusNonOperatingIncome {
		public Integer InterestIncome;	//0
		public Integer ProfitGainOnSaleOfCurrentInvestments;	//0
		public Integer ProfitOnSaleOfFixedAssets;	//0
		public Integer LiabilitiesProvisionsNoLongerRequiredWrittenBack;	//0
		public Integer ProfitGainOnSaleOfLongTermInvestments;	//0
		public Integer NetGainOnForeignCurrencyTransactionsAndTranslation;	//0
		public Integer RentalIncomeIncludingRentFromOperatingLeases;	//0
		public Integer DividendIncome;	//0
	}
	public class cls_ChangesInWorkingCapital {
		public cls_AdjustmentsForIncreaseOrDecreaseInOperatingLiabilities AdjustmentsForIncreaseOrDecreaseInOperatingLiabilities;
		public Double OperatingProfitOrLossAfterIncreaseOrDecreaseInOperatingLiabilities;	//-27235821.82
		public cls_AdjustmentsForIncreaseOrDecreaseInOperatingAssets AdjustmentsForIncreaseOrDecreaseInOperatingAssets;
		public Integer OperatingProfitOrLossAfterIncreaseOrDecreaseInOperatingAssets;	//-50630508
	}
	public class cls_AdjustmentsForIncreaseOrDecreaseInOperatingLiabilities {
		public Integer ShorttermProvisions;	//526336
		public Integer OtherCurrentLiabilities;	//0
		public Integer OtherNonCurrentLiabilities;	//0
		public Double TradePayables;	//22868350.18
		public Integer LongtermProvisions;	//0
	}
	public class cls_AdjustmentsForIncreaseOrDecreaseInOperatingAssets {
		public Integer Inventories;	//-50117121
		public Integer OtherCurrentAssets;	//0
		public Integer OtherNonCurrentAssets;	//0
		public Integer TradeReceivables;	//-3645852
		public Integer ShorttermLoansAndAdvances;	//-521980
	}
	public class cls_ItemsToBeAddedMinusNonOperatingExpenses {
		public Integer Amortization;	//0
		public Integer NetLossOnForeignCurrencyTransactionsAndTranslation;	//0
		public Integer ProvisionForDoubtfulTradeAndOtherReceivablesLoansAndAdvances;	//0
		public Integer LossOnSaleOfLongTermInvestments;	//0
		public Integer Impairment;	//0
		public Integer PreliminaryExpensesWrittenOff;	//0
		public Integer IntangibleAssetsWrittenOffAmortised;	//0
		public Integer LossOnSaleOfCurrentInvestments;	//0
		public Integer LossOnSaleOfFixedAssets;	//0
		public Integer DiscountOnIssueOfDebenturesWrittenOff;	//0
		public Integer PremiumOnRedemptionOfDebentures;	//0
		public Integer Depreciation;	//498649
		public Integer PremiumOnRedemptionOfPreferenceShares;	//0
		public Integer BadTradeAndOtherReceivablesLoansAndAdvancesWrittenOff;	//0
		public Integer DiscountOnIssueOfSharesWrittenOff;	//0
		public Integer MiscellaneousExpensesWrittenOff;	//0
		public Integer ChangesInRevaluationReserve;	//0
		public Integer ProvisionForLossesInSubsidiaryCompanies;	//0
	}
	public class cls_CashFlowFromFinancingActivities {
		public Integer DividendsPaid;	//0
		public Integer InterestExpenseOnOtherBorrowings;	//0
		public Integer ShareApplicationMoneyReceived;	//0
		public Integer InterestExpenseOnBankLoans;	//-2694177
		public Integer QuasiInterest;	//0
		public Integer ProceedsFromSecurityPremium;	//0
		public Integer AdditionsOfDebentureRedemptionReserve;	//0
		public Integer OtherFinanceCost;	//0
		public Integer ProceedsFromIssueOfEquityShares;	//0
		public Double CapitalChanges;	//11435964.82
		public Integer ProceedsFromIssueOfPreferenceShares;	//0
		public Double NetCashFlowFromFinancingActivities;	//31048460.82
		public Integer InterestExpenseOnDebentures;	//0
		public Integer InterestExpenseOnCashCredits;	//0
		public Integer ProceedsFromShorttermBorrowings;	//0
		public Integer TaxOnDividend;	//0
		public Integer AdditionsOfCapitalReserve;	//0
		public Integer ProceedsFromIssueOfShareWarrants;	//0
		public Integer InterestExpenseOnOverdrafts;	//0
		public Integer ProceedsFromLongtermBorrowings;	//22306673
	}
	public class cls_CashFlowFromInvestingActivities {
		public Integer NetLossOnForeignCurrencyTransactionsAndTranslation;	//0
		public Integer DividendReceivedFromLongTermInvestments;	//0
		public Integer InterestReceivedFromInvestments;	//0
		public Integer OtherNonOperatingIncome;	//0
		public Integer ProceedsFromSaleOfOtherFixedAssets;	//0
		public Integer SaleOfCurrentInvestments;	//0
		public Integer DividendReceivedFromCurrentInvestments;	//0
		public Integer LongtermLoansAndAdvances;	//0
		public Integer NetCashFlowFromInvestingActivities;	//-3452578
		public Integer ProceedsFromSaleOfIntangibleAssets;	//0
		public Integer ProfitOnSaleOfFixedAssets;	//0
		public Integer ProceedsFromSaleOfTangibleAssets;	//-3452578
		public Integer SaleOfLongtermInvestments;	//0
		public Integer NetGainOnForeignCurrencyTransactionsAndTranslation;	//0
		public Integer TotalOfProceedsFromSaleOfFixedAssets;	//-3452578
	}
	/* FinancialReport Res- End*/

}