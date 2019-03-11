/*
* Name          : PerfiosReportResponseHL
* Description   : Structurize Perfios data, to be inserted in the system
* Author        : Venu Gopal
*/
public class PerfiosReportResponseHL{
	public cls_customerInfo customerInfo;
	public cls_summaryInfo summaryInfo;
	public cls_monthlyDetails[] monthlyDetails;
	public cls_eODBalances[] eODBalances;
	public cls_highValueDebitXns[] highValueDebitXns;
	public cls_regularCredits[] regularCredits;
	public cls_highValueCreditXns[] highValueCreditXns;
	public cls_accountXns[] accountXns;
	public cls_customUserInfo customUserInfo;
	public cls_AdditionalMonthlyDetails[] AdditionalMonthlyDetails;
	public cls_AdditionalSummaryDetails AdditionalSummaryDetails;
	public cls_AdditionalForm26ASInfo AdditionalForm26ASInfo;
    public cls_Form26ASInfo Form26ASInfo;
    public cls_iTRVInfo iTRVInfo;
    public cls_itrFormData itrFormData;
    
   public class cls_iTRVInfo {
		public cls_iTRV[] iTRV;
	}
	public class cls_iTRV {
		public String ay;	//2016-17
		public String formNo;	//ITR-1
		public String originalOrRevised;	//ORIGINAL
		public String AO;	//WARD 7(2)(3)
		public String ackNo;	//548082390301116
		public String dateOfSubmission;	//2016-11-30
		public cls_personalDetails personalDetails;
		public cls_incomeDetails incomeDetails;
	}
	public class cls_incomeDetails {
		public Integer grossTotalIncome;	//564551
		public Integer deductionsUnderChapter6A;	//152801
		public Integer totalIncome;	//411750
		public Integer currentYearLoss;	//0
		public Integer netTaxPayable;	//14600
		public Integer interestPayable;	//0
		public Integer totalTaxAndInterestPayable;	//14600
		public Integer advanceTaxPaid;	//0
		public Integer tdsPaid;	//14600
		public Integer tcsPaid;	//0
		public Integer selfAssessmentTaxPaid;	//0
		public Integer totalTaxPaid;	//14600
		public Integer taxPayable;	//0
		public Integer refund;	//0
		public Integer agricultureExemptIncome;	//0
		public Integer otherExemptIncome;	//0
	}
    
   public  class cls_itrFormData {
		public cls_itrDetails itrDetails;
	}
    public class cls_itrDetails {
		public cls_itr2[] itr2;
		public cls_itr1[] itr1;
	}
    	public class cls_itr2 {
		public String ay;	//2017-18
		public String fy;	//2016-17
		public cls_partBTI partBTI;
		public cls_personalInfo personalInfo;
		public cls_scheduleOS scheduleOS;
		public String type;	//ITR2
	}
	public class cls_partBTI {
		public Integer aggregateIncome;	//827100
		public Integer balanceAfterSetoffLosses;	//577102
		public Integer broughtFwdLossesSetoff;	//0
		public cls_capGain capGain;
		public Integer currentYearLoss;	//0
		public Integer deductionsUnderScheduleVIA;	//175000
		public Integer grossTotalIncome;	//577102
		public Integer incChargeTaxSplRate111A112;	//0
		public Integer incChargeableTaxSplRates;	//0
		public cls_incFromOS incFromOS;
		public Integer incomeFromHP;	//0
		public Integer lossesOfCurrentYearCarriedFwd;	//0
		public Integer netAgricultureIncomeOrOtherIncomeForRate;	//425000
		public cls_profBusGain profBusGain;
		public Integer salaries;	//562600
		public Integer totalIncome;	//402100
		public Integer totalTI;	//577102
	}
	public class cls_capGain {
		public cls_longTerm longTerm;
		public cls_shortTerm shortTerm;
		public Integer totalCapGains;	//0
	}
	public class cls_longTerm {
		public Integer longTerm10Per;	//0
		public Integer longTerm20Per;	//0
		public Integer totalLongTerm;	//0
	}
	public class cls_shortTerm {
		public Integer shortTerm15Per;	//0
		public Integer shortTerm30Per;	//0
		public Integer shortTermAppRate;	//0
		public Integer totalShortTerm;	//0
	}
	public class cls_incFromOS {
		public Integer fromOwnRaceHorse;	//0
		public Integer incChargblSplRate;	//0
		public Integer otherSrcThanOwnRaceHorse;	//14502
		public Integer totIncFromOS;	//14502
	}
	public class cls_profBusGain {
		public Integer totProfBusGain;	//0
	}
	public class cls_address {
		public String cityOrTownOrDistrict;	//Bengaluru
		public Integer countryCode;	//91
		public String emailAddress;	//finance@sst-india.com
		public cls_emailAddressSec emailAddressSec;
		public String localityOrArea;	//Tavarekere Village
		public String mobileNo;	//9036090278
		public cls_mobileNoSec mobileNoSec;
		public cls_phone phone;
		public String pinCode;	//560081
		public cls_residenceName residenceName;
		public String residenceNo;	//# 35
		public String roadOrStreet;	//1st A Cross
		public Integer stateCode;	//15
	}
	public class cls_residenceName {
	}
	public class cls_assesseeName {
		public String firstName;	//DEF
		public String surNameOrOrgName;	//ABC
	}
    public class cls_personalInfo {
		public cls_address address;
		public cls_assesseeName assesseeName;
		public String dob;	//1988-12-25
		public String employerCategory;	//OTH
		public String gender;	//F
		public String pan;	//ABCDE5699Q
		public String status;	//I
	}
	public class cls_scheduleOS {
		public Integer incChargeable;	//14502
		public cls_incFromOwnHorse incFromOwnHorse;
		public cls_incOthThanOwnRaceHorse incOthThanOwnRaceHorse;
		public Integer totOthSrcNoRaceHorse;	//14502
	}
	public class cls_incFromOwnHorse {
		public Integer balanceOwnRaceHorse;	//0
		public Integer deductSec57;	//0
		public Integer receipts;	//0
	}
	public class cls_incOthThanOwnRaceHorse {
		public Integer balanceNoRaceHorse;	//14502
		public cls_deductions deductions;
		public Integer dividendGross;	//0
		public Integer grossAmtChargblNormalRate;	//14502
		public cls_incChargblSplRateOS incChargblSplRateOS;
		public Integer interestGross;	//14502
		public Integer othersGross;	//0
		public cls_othersGrossDtls[] othersGrossDtls;
		public Integer rentFromMachPlantBldgs;	//0
		public Integer totalOSGross;	//14502
	}
	public class cls_deductions {
		public Integer depreciation;	//0
		public Integer expenses;	//0
		public Integer totDeductions;	//0
	}
	public class cls_incChargblSplRateOS {
		public Integer dividendIncome115BBDA;	//0
		public Integer dividendIncome115BBE;	//0
		public Integer dividendIncome115BBF;	//0
		public Integer secXIIOth;	//0
		public Integer totalAmtTaxUsDTAASchOs;	//0
		public Integer totalOSGrossChargblSplRate;	//0
		public Integer winningFrmLotteries;	//0
	}
	public class cls_othersGrossDtls {
		public cls_otherSourceDesc otherSourceDesc;
		public Integer sourceAmount;	//0
		public String sourceDescription;	//5BB
	}
	public class cls_otherSourceDesc {
	}
    
    public class cls_itr1 {
		public String ay;	//2016-17
		public cls_filingStatus filingStatus;
		public String fy;	//2015-16
		public cls_itr1IncomeDeductions itr1IncomeDeductions;
		public cls_itr1TaxComputation itr1TaxComputation;
		public cls_personalInfo personalInfo;
		public cls_refund refund;
		public cls_taxPaid taxPaid;
		public cls_tdSonOthThanSals tdSonOthThanSals;
		public cls_tdSonSalaries tdSonSalaries;
		public String type;	//ITR1
	}
	public class cls_filingStatus {
	}
	public class cls_itr1IncomeDeductions {
		public cls_deductUndChapVIA deductUndChapVIA;
		public Integer grossTotIncome;	//564551
		public Integer incomeFromSal;	//562600
		public Integer incomeOthSrc;	//1951
		public Integer totalIncome;	//411750
		public Integer totalIncomeOfHP;	//0
		public cls_usrDeductUndChapVIA usrDeductUndChapVIA;
	}
	public class cls_deductUndChapVIA {
		public Integer section80C;	//145850
		public Integer section80CCC;	//0
		public Integer section80CCDEmployeeOrSE;	//0
		public Integer section80CCDEmployer;	//0
		public Integer section80CCG;	//0
		public Integer section80D;	//5000
		public Integer section80DD;	//0
		public Integer section80DDB;	//0
		public Integer section80E;	//0
		public Integer section80G;	//0
		public Integer section80GG;	//0
		public Integer section80GGA;	//0
		public Integer section80GGC;	//0
		public Integer section80IA;	//0
		public Integer section80IAB;	//0
		public Integer section80IB;	//0
		public Integer section80IC;	//0
		public Integer section80ID;	//0
		public Integer section80JJA;	//0
		public Integer section80QQB;	//0
		public Integer section80RRB;	//0
		public Integer section80TTA;	//1951
		public Integer section80U;	//0
		public Integer totalChapVIADeductions;	//152801
	}
	public class cls_usrDeductUndChapVIA {
		public Integer section80C;	//145850
		public Integer section80CCC;	//0
		public Integer section80CCDEmployeeOrSE;	//0
		public Integer section80CCDEmployer;	//0
		public Integer section80CCG;	//0
		public Integer section80D;	//5000
		public Integer section80DD;	//0
		public Integer section80DDB;	//0
		public Integer section80E;	//0
		public Integer section80G;	//0
		public Integer section80GG;	//0
		public Integer section80GGA;	//0
		public Integer section80GGC;	//0
		public Integer section80IA;	//0
		public Integer section80IAB;	//0
		public Integer section80IB;	//0
		public Integer section80IC;	//0
		public Integer section80ID;	//0
		public Integer section80JJA;	//0
		public Integer section80QQB;	//0
		public Integer section80RRB;	//0
		public Integer section80TTA;	//1951
		public Integer section80U;	//0
		public Integer totalChapVIADeductions;	//152801
	}
	public class cls_itr1TaxComputation {
	}
	public class cls_emailAddressSec {
	}
	public class cls_mobileNoSec {
	}
	public class cls_phone {
	}
	public class cls_refund {
	}
	public class cls_taxPaid {
	}
	public class cls_tdSonOthThanSals {
	}
	public class cls_tdSonSalaries {
	}
    
    
    
	public class cls_customerInfo {
		public String name;	//Shangu Shiva
		public String address;	//34 Tafiq Lane, Bangalore, Karnataka 560034
		public String landline;	//080-12345678
		public String mobile;	//9881234567
		public String email;	//shangu@perfios.com
		public String pan;	//AGMPV6437A
		public String perfiosTransactionId;	//AE241522146923157
		public String customerTransactionId;	//ae348f79-d0e8-bddf-c9ff-2edca11f2496
		public String bank;	//Acme Bank Ltd., India
		public Double instId;	//998
        public String errorCode;	//NOT_FOUND
		public String errorMessage;	//No match found for account numbers
	}
	public class cls_summaryInfo {
		public String instName;	//Acme Bank Ltd., India
		public cls_accNo[] accNo;	//5-5XX4XX-X06
		public String accType;	//Savings
		public Double fullMonthCount;	//4
		public cls_total total;
		public cls_average average;
        public string primaryAccNo;
	}
    public class cls_accNo {
        public String bankAccNo;
    }
	public class cls_total {
		public Double bal15;	//468169.8
		public Double bal25;	//392712.46
		public Double bal5;	//258017.46
		public Double balAvg;	//383126.28
		public Double balLast;	//385125.95
		public Double balOpen;	//256892.06
		public Double credits;	//42
		public Double debits;	//99
		public Double emiIssues;	//0
		public Double inwBounces;	//0
		public Double inwECSBounces;	//0
		public Double outwBounces;	//0
		public Double outwECSBounces;	//0
		public Double salaries;	//0
		public Double stopPayments;	//0
		public Double totalCredit;	//564631.98
		public Double totalDebit;	//436398.09
		public Double totalEmiIssue;	//0
		public Double totalInvIncome;	//51541.81
		public Double totalInwECSBounce;	//0
		public Double totalOutwECSBounce;	//0
		public Double totalSalary;	//0
		public Double totalTransferOut;	//25200
	}
	public class cls_average {
		public Double bal15;	//117042.45
		public Double bal25;	//98178.12
		public Double bal5;	//64504.36
		public Double balAvg;	//95781.57
		public Double balLast;	//96281.49
		public Double balOpen;	//64223.01
		public Double credits;	//10
		public Double debits;	//25
		public Double emiIssues;	//0
		public Double inwBounces;	//0
		public Double inwECSBounces;	//0
		public Double outwBounces;	//0
		public Double outwECSBounces;	//0
		public Double salaries;	//0
		public Double stopPayments;	//0
		public Double totalCredit;	//141157.99
		public Double totalDebit;	//109099.52
		public Double totalEmiIssue;	//0
		public Double totalInvIncome;	//12885.45
		public Double totalInwECSBounce;	//0
		public Double totalOutwECSBounce;	//0
		public Double totalSalary;	//0
		public Double totalTransferOut;	//6300
	}
	public class cls_monthlyDetails {
		public Double bal15;	//83373.65
		public Double bal25;	//63408.6
		public Double bal5;	//1366.83
		public Double balAvg;	//56923.54
		public Double balLast;	//62012.06
		public Double balOpen;	//1166.83
		public Double credits;	//7
		public Double debits;	//26
		public Double emiIssues;	//0
		public Double inwBounces;	//0
		public Double inwECSBounces;	//0
		public String monthName;	//Nov-17
		public Double outwBounces;	//0
		public Double outwECSBounces;	//0
		public Double salaries;	//0
		public String startDate;	//2017-11-01
		public Double stopPayments;	//0
		public Double totalCredit;	//111605.26
		public Double totalDebit;	//50760.03
		public Double totalEmiIssue;	//0
		public Double totalInvIncome;	//0
		public Double totalInwECSBounce;	//0
		public Double totalOutwECSBounce;	//0
		public Double totalSalary;	//0
		public Double totalTransferOut;	//4800
	}
	public class cls_eODBalances {
		public String eODBalanceDate;	//2017-11-01
		public Double balance;	//1366.83
	}
  public  class cls_highValueDebitXns {
		public String hvdXnsDate;	//2017-11-02
		public String chqNo;	//1497
		public String narration;	//To Clg : Camlin Ltd KOKUYO CAMLIN
		public Double amount;	//-144295
		public String category;	//Transfer out
		public Double balance;	//296266.79
	}
	public class cls_regularCredits {
		public String regularChangeDate;	//2017-11-15
		public Double regularChangeGroup;	//1
		public String chqNo;	//
		public String narration;	//EBA//20091105083330
		public Double amount;	//16459.21
		public String category;	//Others
		public Double balance;	//98413.25
    
	}
  public  class cls_highValueCreditXns {
		public String hvcXnsDate;	//2017-11-23
		public String chqNo;	//
		public String narration;	//BLUECLICK OFFICE AUTOMATION INDIA-085966
		public Double amount;	//439434
		public String category;	//Others
		public Double balance;	//723274.79
	}
	public class cls_accountXns {
		public String accountNo;	//5-5XX4XX-X06
		public String accountType;	//Savings
		public cls_xns[] xns;
	}
	public class cls_xns {
		public String xnsDate;	//2018-02-12
		public String chqNo;	//
		public String narration;	//EBA//20100202081454
		public Double amount;	//16720.37
		public String category;	//Others
		public Double balance;	//198113.93
	}
	public class cls_customUserInfo {
		public String emiAmount;	//123.00
		public String employmentType;	//Salaried
		public String productType;	//HomeLoan
		public String facility;	//CC
	}
	public class cls_AdditionalMonthlyDetails {
		public String monthName;	//Nov-17
		public Double avgBalance;	//49383.03
	}
	public class cls_AdditionalSummaryDetails {
		public Double avgBalanceOf3Months;	//108734.25
		public Double avgBalanceOf6Months;	//0
		public Double avgBalanceOf12Months;	//0
		public Double avgCreditsOf6Months;	//0
		public Double avgDebitsOf6Months;	//0
		public Double avgTotalCreditOf6Months;	//0
		public Double avgTotalDebitOf6Months;	//0
		public Double avgBalanceOf6MonthsToEMI;	//0
		public String salaryContinuous;	//No
		public Double avgEstimatedIncome;
	}
	public class cls_AdditionalForm26ASInfo {
	}
    public class cls_Form26ASInfo {
		public cls_PersonalDetails PersonalDetails;
		public cls_TDSDetails[] TDSDetails;
		public cls_NonTDSDetails[] NonTDSDetails;
	}
	public class cls_PersonalDetails {
		public String name;	//KRISHNA KUMAR TADIPARTI
		public String address;	//NO 491 RAM NAGAR, KVB STAFF QUARTERS, OFF SALEM BYEPASS ROAD, VENGAMEDU POST, KARUR, TAMILNADU, 639006
		public String dob;	//1967-08-15
		public String pan;	//ABTPT6730E
		public String panStatus;	//Active
	}
	public class cls_TDSDetails {
		public String fy;	//2016-17
		public String ay;	//2017-18
		public cls_TDSs TDSs;
	}
	public class cls_TDSs {
		public cls_TDS[] TDS;
	}
	public class cls_TDS {
		public String tds;	//8202
		public String section;	//192
		public String deductor;	//THE KARUR VYSYA BANK LTD CENTRAL OFFICE
		public String TDSDate;	//2016-04-30
		public String amount;	//105402
		public String tan;	//CHET04666E
	}
	public class cls_NonTDSDetails {
		public String fy;	//2016-17
		public String ay;	//2017-18
	}
	public static PerfiosReportResponseHL parse(String json){
		return (PerfiosReportResponseHL) System.JSON.deserialize(json, PerfiosReportResponseHL.class);
	}
}