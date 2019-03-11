/*
* Name          : Perfios_New_SME_Response
* Description   : Response Structure for 
* Author        : Raushan Abhishek
*/
public class Perfios_New_SME_Response {
	public cls_CustomerInfo customerInfo;
	public cls_SummaryInfo summaryInfo;
	public List<cls_MonthlyDetails> monthlyDetails;
	public List<cls_EODBalances> eODBalances;
	public List<cls_Top5FundsReceived> top5FundsReceived;
	public List<cls_Top5FundsReceived> top5FundsTransferred;
	public List<cls_BouncedOrPenalXns> bouncedOrPenalXns;
	public List<cls_AccountXns> accountXns;
	public List<cls_AdditionalSummaryDetails> AdditionalSummaryDetails;
	public List<cls_AdditionalMonthlyDetails> AdditionalMonthlyDetails;
	public List<cls_AdditionalCustomerInfo> AdditionalCustomerInfo;

	public class cls_MonthlyDetails {
		public String balAvg;
		public String balMax;
		public String balMin;
		public String bankCharges;
		public String bounceOrPenalCharges;
		public String cashDeposits;
		public String cashWithdrawals;
		public String chqDeposits;
		public String chqIssues;
		public String credits;
		public String creditsAPS;
		public String creditsSC;
		public String creditsSelf;
		public String debits;
		public String debitsAPS;
		public String dpLimit;
		public String interestPaid;
		public String intPayDelay;
		public String inwBounces;
		public String inwBounceTechnical;
		public String inwChqBounces;
		public String monthName;
		public String outwBounces;
		public String outwChqBounces;
		public String overdrawnAmount;
		public String overdrawnDays;
		public String overdrawnInstances;
		public String snLimit;
		public String startDate;
		public String totalBankCharge;
		public String totalBounceOrPenalCharge;
		public String totalCashDeposit;
		public String totalCashWithdrawal;
		public String totalChqDeposit;
		public String totalChqIssue;
		public String totalCredit;
		public String totalCreditSC;
		public String totalCreditSelf;
		public String totalDebit;
		public String totalInterestIncome;
		public String totalInterestPaid;
		public String totalInwBounceTechnical;
		public String totalInwChqBounce;
		public String totalOutwChqBounce;
	}

	public class cls_AdditionalSummaryDetails {
		public String totalChqDeposits;
		public String totalChqIssues;
		public String totalInterestEarned;
		public String noOfTimesInterestServiceBefore;
	}

	public class cls_AdditionalMonthlyDetails {
		public String monthName;
		public String avgUtilization;
		public String overdrawnComparedToLimit;
		public String cashToTotalRatio;
	}

	public class cls_Average {
		public String balAvg;
		public String balMax;
		public String balMin;
		public String bankCharges;
		public String bounceOrPenalCharges;
		public String cashDeposits;
		public String cashWithdrawals;
		public String chqDeposits;
		public String chqIssues;
		public String credits;
		public String creditsAPS;
		public String creditsSC;
		public String creditsSelf;
		public String debits;
		public String debitsAPS;
		public String dpLimit;
		public String interestPaid;
		public String intPayDelay;
		public String inwBounces;
		public String inwBounceTechnical;
		public String inwChqBounces;
		public String outwBounces;
		public String outwChqBounces;
		public String overdrawnAmount;
		public String overdrawnDays;
		public String overdrawnInstances;
		public String snLimit;
		public String totalBankCharge;
		public String totalBounceOrPenalCharge;
		public String totalCashDeposit;
		public String totalCashWithdrawal;
		public String totalChqDeposit;
		public String totalChqIssue;
		public String totalCredit;
		public String totalCreditSC;
		public String totalCreditSelf;
		public String totalDebit;
		public String totalInterestIncome;
		public String totalInterestPaid;
		public String totalInwBounceTechnical;
		public String totalInwChqBounce;
		public String totalOutwChqBounce;
	}

	public class cls_EODBalances {
		public String eODBalanceDate;
		public String balance;
	}

	public class cls_Top5FundsReceived {
		public String month;
		public String category;
		public String amount;
	}

	public class cls_AdditionalCustomerInfo {
		public String vintageDate;
		public String facility;
	}

	public class cls_BouncedOrPenalXns {
		//public String date;
		public String chqNo;
		public String narration;
		public String amount;
		public String category;
		public String balance;
	}

	public class cls_Total {
		public String balAvg;
		public String balMax;
		public String balMin;
		public String bankCharges;
		public String bounceOrPenalCharges;
		public String cashDeposits;
		public String cashWithdrawals;
		public String chqDeposits;
		public String chqIssues;
		public String credits;
		public String creditsAPS;
		public String creditsSC;
		public String creditsSelf;
		public String debits;
		public String debitsAPS;
		public String dpLimit;
		public String interestPaid;
		public String intPayDelay;
		public String inwBounces;
		public String inwBounceTechnical;
		public String inwChqBounces;
		public String outwBounces;
		public String outwChqBounces;
		public String overdrawnAmount;
		public String overdrawnDays;
		public String overdrawnInstances;
		public String snLimit;
		public String totalBankCharge;
		public String totalBounceOrPenalCharge;
		public String totalCashDeposit;
		public String totalCashWithdrawal;
		public String totalChqDeposit;
		public String totalChqIssue;
		public String totalCredit;
		public String totalCreditSC;
		public String totalCreditSelf;
		public String totalDebit;
		public String totalInterestIncome;
		public String totalInterestPaid;
		public String totalInwBounceTechnical;
		public String totalInwChqBounce;
		public String totalOutwChqBounce;
	}

	public class cls_CustomerInfo {
		public String name;
		public String address;
		public String landline;
		public String mobile;
		public String email;
		public String pan;
		public String perfiosTransactionId;
		public String customerTransactionId;
		public String bank;
		public String instId;
	}

	public class cls_Xns {
		public String xnsDate;
		public String balance;
	}

	public class cls_SummaryInfo {
		public String instName;
		public String accNo;
		public String accType;
		public String fullMonthCount;
		public String highestNonTechnicalBounce;
		public String lowestNonTechnicalBounce;
		public cls_Total total;
		public cls_Average average;
	}

	public class cls_AccountXns {
		public String accountNo;
		public String accountType;
		public List<cls_Xns> xns;
	}

	
	public static Perfios_New_SME_Response parse(String json) {
		return (Perfios_New_SME_Response) System.JSON.deserialize(json, Perfios_New_SME_Response.class);
	}
}