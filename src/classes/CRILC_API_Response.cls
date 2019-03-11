/*
 * Name     : CRILC_API_Response
 * Company  : ET Marlabs
 * Purpose  : To used as a Response for . 
 * Author   : Raushan
*/
public class CRILC_API_Response {
    
    public BanksExposureToBorrower banksExposureToBorrower;
	public StatusOfClassificationOfBorrower statusOfClassificationOfBorrower;
	public String customerId;

	public class RepaymentHistory {
		public String borrowerClassifiedAsSMA2;
		public String reportingLenderName;
		public String changedStatus;
		public String changedStatusDate;
		public String amountOutstandingWhenTheBorrowerClassified;
		public String totalLimitSanctionedWhenTheBorrowerClassifiedAsSMA2;
		public String amountOutstandingAsOnDateOfChangedStatus;
		public String borrowerWasClassifiedAsSMA1DuringThePastOneYear;
		public String ifYesDate1;
		public String ifYesDate2;
		public String ifYesDate3;
		public String remarks;
	}

	public class AmountOutStanding {
		public String total;
		public String funded;
		public String nonFunded;
	}

	public class ReportOnExposure {
		public List<ReportDetailsList> reportDetailsList;
		public String quarter;
	}

	public class AssetClassificationOfBorrower {
		public String referenceDateOfCrilcMain;
		public String nameOfReportingBank;
		public String assetClassification;
		public String smaClassification;
		public String whetherMaintainingCurrentAccountYesOrNo;
	}

	public class ReportingLenders {
		public String reportingDate;
		public String reportingLenders;
		public String status;
	}

	public class ReportDetailsList {
		public String assetClassification;
		public String noOfLenders;
		public AmountOutStanding amountOutStanding;
		public String unsecuredAmountOutstanding;
		public AmountOutStanding creditExposure;
		public String investmentExposure;
		public String totalExposure;
		public String balanceInCurrentAccount;
	}

	public class StatusOfClassificationOfBorrower {
		public String borrowerName;
		public String panNumber;
		public String amountInRs;
		public String reportGeneratedOn;
		public String Source1;
		public List<ReportingLenders> reportingLenders;
		public String source2;
		public List<RepaymentHistory> repaymentHistory;
		public String borrowerAccountReportedAsRFAToCRILC;
		public String borrowerIsReportedAsFraudToCRILC;
		public List<AssetClassificationOfBorrower> assetClassificationOfBorrower;
	}

	public class BanksExposureToBorrower {
		public String borrowerName;
		public String pan;
		public String lei;
		public String amountInRs;
		public String reportGeneratedOn;
		public String noOfBankSubmittedCrilcMainReturn;
		public String source;
		public List<ReportOnExposure> reportOnExposure;
	}

	public static CRILC_API_Response parse(String json) {
		return (CRILC_API_Response) System.JSON.deserialize(json, CRILC_API_Response.class);
	}
}