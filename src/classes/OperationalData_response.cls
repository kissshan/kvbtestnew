/*
* @name         : OperationalData_response
  @description  : operation data change API response structure
  @author       : Amritesh
*/
public class OperationalData_response{
    public String bpms_error_code;  //00
  public cls_out_msg out_msg;
  public String bpms_error_msg;  //Success
  public class cls_out_msg {
    public cls_Operational_Data[] Operational_Data;
    public Integer TotalSize;  //2
    public cls_AccountNumber AccountNumber;
  }
  public class cls_AccountNumber {
    public String CustomerID; //5314604
    public cls_CustAccNo[] CustAccNo;
  }
  public class cls_CustAccNo {
    public String AccountNo;  //1422135000001181
  }
  public class cls_Operational_Data {
    public String Customer_Id;  //9874514
    public cls_CustomerData[] CustomerData;
  }
  public class cls_CustomerData {
    public String FISCAL_YR;  //2015-2016
        public String FDATE;  //2015-2016
        public String TDATE;  //2015-2016
    public cls_Ops_Data[] Ops_Data;
  }
  public class cls_Ops_Data {
    public cls_InwdChqRtns[] InwdChqRtns;
	public List<cls_PCLN_ExtBY_brchManul> PCLN_ExtBY_brchManul;//
	public List<cls_PCLN_Intrst_Earned> PCLN_Intrst_Earned;//
    public cls_AvgLimit[] AvgLimit;
    public cls_TotalOutwdChqRecvd[] TotalOutwdChqRecvd;
    public cls_PromptCloseExceeding[] PromptCloseExceeding;
	public List<cls_DTPCBillsOvrDueManual> DTPCBillsOvrDueManual;//
	public List<cls_FBN_FBP_EBD_RADV_Opened> FBN_FBP_EBD_RADV_Opened;//

    public cls_LCBGDevpt[] LCBGDevpt;
    public cls_ForeignBills[] ForeignBills;
	public List<cls_PCLN_PCFC_Opened> PCLN_PCFC_Opened;//
public List<cls_Devolved_LC_BG> Devolved_LC_BG;//
    public cls_CashWithdrwalAmtSum[] CashWithdrwalAmtSum;
    public cls_TotalInwdClrCheqs[] TotalInwdClrCheqs;
    public cls_CreditSummation[] CreditSummation;
    public cls_CashDepositCount[] CashDepositCount;
    public cls_CashWithdrawalCount[] CashWithdrawalCount;
	public List<cls_FBN_FBP_EBD_RADV_Avg> FBN_FBP_EBD_RADV_Avg;//
    public cls_DebitSummation[] DebitSummation;
    public cls_DebitCount[] DebitCount;
    public cls_InterestEarned[] InterestEarned;
    public cls_ExceedingsIntrPaid[] ExceedingsIntrPaid;
	public List<cls_PCLN_PCFC_Min_Max_Amt> PCLN_PCFC_Min_Max_Amt;//
	public List<cls_Forward_Contract_Bkd> Forward_Contract_Bkd;//
	public List<cls_TradeCredit> TradeCredit;//
    public cls_Top5CrSumParties[] Top5CrSumParties;
	public List<cls_Forward_Contract_Cancldby_custBnk> Forward_Contract_Cancldby_custBnk;//

    public cls_OutwdChqRtns[] OutwdChqRtns;
	public List<cls_CrystalizedBills> CrystalizedBills;//
    public cls_HighValChqRtns[] HighValChqRtns;
	public List<cls_CommissionEarned> CommissionEarned;//
	
    public cls_LowValChqRtns[] LowValChqRtns;
    public String CustomerId;  //9874514
    public cls_Exceedings[] Exceedings;
    public cls_DelayServWorkCapInt[] DelayServWorkCapInt;
    public cls_CashDepositAmtSum[] CashDepositAmtSum;
	public List<cls_LC_BG_Opened> LC_BG_Opened;//
	public List<cls_BillsOverDue> BillsOverDue;//
	public List<cls_MBillsReceived> MBillsReceived;//
    public cls_ServiceCharges[] ServiceCharges;
	public List<cls_LC_BG_Avg_Util> LC_BG_Avg_Util;//
    public cls_Top5DrSumParties[] Top5DrSumParties;
    public cls_CreditCount[] CreditCount;
  }
  public class cls_InwdChqRtns {
    public String FISCAL_YR;  //2015-2016
    public String INWD_CHQ_RTN;  //14
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_PCLN_ExtBY_brchManul {//
		public String AVG_DAYS;
		public String MAX_LCY_AMOUNT;
		public String NO_OF_CONTRACTS;
		public String MIN_LCY_AMOUNT;
	}
	public class cls_PCLN_Intrst_Earned {//
		public String N_INT_AMT;
	}
	public class cls_DTPCBillsOvrDueManual {//
		public String AMOUNT;
		public String MIN_AMOUNT;
		public String MAX_AMOUNT;
		public String NO_OF_CONTRACTS;
		public String AVG_OD_DAYS;
		public String NO_OD_DAYS;
	}
	public class cls_FBN_FBP_EBD_RADV_Opened {
		public String AMOUNT;
		public String N_NO;
	}
  public class cls_AvgLimit {
    public String FISCAL_YR;  //2015-2016
    public String AMOUNT;  //-188880252.55
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_TotalOutwdChqRecvd {
    public String FISCAL_YR;  //2015-2016
    public String OUTW_CNT;  //337
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
        public String OUT_CHK_RES;
  }
  public class cls_PromptCloseExceeding {
    public String EXCEED_DAYS_SUM;  //36
    public String FISCAL_YR;  //2015-2016
    public String EXCEED_DAYS_CNT;  //2
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
    public String EXCD_AVERAGE;  //18
  }
  public class cls_LCBGDevpt {
        public String DVBG_CNT;  //18
        public String DVLC_CNT;  //18
  }
  public class cls_ForeignBills {
        public String N_BILLS;  //18
        public String INR_BAL;  //18
        public String MAX_INR;  //18
        public String MIN_INR;  //18
  }
  public class cls_PCLN_PCFC_Opened {//
		public String N_DISB_AMT;
		public String N_DISB_NO;
	}
	
	public class cls_Devolved_LC_BG {//
		public String ACCT_OPEN_BAL;
		public String MAX_ACCT_OPEN_BAL;
		public String DVLC_CNT;
		public String DVBG_CNT;
		public String MIN_ACCT_OPEN_BAL;
	}
  public class cls_CashWithdrwalAmtSum {
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String DR_CASH_AMT;  //34292500
    public String FDATE;  //2015-04-01
        public String DR_CASH_CNT;
  }
  public class cls_TotalInwdClrCheqs {
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String INW_CNT;  //626
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_CreditSummation {
    public String FIN_CR_AMT;  //809232794.92
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
        public String CR_SUM_AMT;
  }
  public class cls_CashDepositCount {
    public String CR_CASH_CNT;  //15
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
        public String CASH_CR_CNT;
  }
  public class cls_CashWithdrawalCount {
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String DR_CASH_CNT;  //98
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
        public String CASH_DR_CNT;
  }
  public class cls_FBN_FBP_EBD_RADV_Avg {//
		public String AVG_UTIL;
	}
  public class cls_DebitSummation {
    public String INT_TR_AMOUNT;  //189438146
    public String FISCAL_YR;  //2015-2016
    public String FIN_DR_AMT;  //794737448.59
    public String V_CUST_CODE;  //9874514
    public String INT_TR_CNT;  //148
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
        public String DR_SUM_AMT;
  }
  public class cls_DebitCount {
    public String FIN_DR_CNT;  //2432
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
        public String DR_SUM_CNT;
  }
  public class cls_InterestEarned {
    public String INT_REVD_AMT;  //31880986.5
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_ExceedingsIntrPaid {
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String EXCD_INT_DR;  //223246.81
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_PCLN_PCFC_Min_Max_Amt {//
		public String N_MAX_AMT;
		public String N_MIN_AMT;
	}
	public class cls_Forward_Contract_Bkd {//
		public String AMOUNT_PURCHASE;
		public String CNT_SALES;
		public String CNT_PURCHASE;
		public String AMOUNT_SALES;
	}
	public class cls_TradeCredit {//
		public String MIN_DAYS;
		public String AMOUNT_LCY;
		public String MAX_DAYS;
		public String NO_CONTRACTS;
		public String AMOUNT_FCY;
	}

  public class cls_Top5CrSumParties {
    public String TO_ACC;  //AEGAN INDUSTRIES PRIVATE LIMITED-0920102000003551
    public String FISCAL_YR;  //2015-2016
    public String FROM_ACC;  //SWAMY COTTON MILL TI-1234223000000707
    public String V_CUST_CODE;  //9874514
    public String TYP;  //NEFT CREDIT
    public String CR_AMT;  //106739412
    public String CR_CNT;  //30
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_Forward_Contract_Cancldby_custBnk {//
		public String AMOUNT_LOSS_GAIN;
		public String AMOUNT_PURCHASE;
		public String CNT_SALES;
		public String CNT_PURCHASE;
		public String AMOUNT_SALES;
	}
  public class cls_OutwdChqRtns {
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String OUTWD_CHQ_RTN;  //6
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_CrystalizedBills {//
		public String N_DISB_AMT;
		public String N_CONTRACTS;
		public String N_MAX_AMT;
		public String N_MIN_AMT;
	}
  public class cls_HighValChqRtns {
    public String MAX_RET_AMT;  //949297
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_CommissionEarned {//
		public String NO_CNT;
		public String AMOUNT;
	}
	
  public class cls_LowValChqRtns {
    public String MIN_RET_AMT;  //16730
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_Exceedings {
    public String FISCAL_YR;  //2015-2016
    public String NO_OF_EXCD;  //16
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_DelayServWorkCapInt {
        public String INT_DR_CNT;  //4079299
  }
  public class cls_CashDepositAmtSum {
    public String CR_CASH_AMT;  //4079299
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
  }
  public class cls_LC_BG_Opened {//
		public String BG_AMOUNT;
		public String N_LC_CONTRACTS;
		public String N_BG_CONTRACTS;
		public String LC_AMOUNT;
	}
	public class cls_BillsOverDue {//
		public String AMOUNT;
		public String AVG_OD_DAYS;
		public String NO_OD_DAYS;
	}
	public class cls_MBillsReceived {
		public String N_CONTRACTS;
		public String AMOUNT;
	}
  public class cls_ServiceCharges {
    public String FISCAL_YR;  //2015-2016
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String DR_SERV_CNT;  //296
    public String FDATE;  //2015-04-01
    public String DR_SERV_AMT;  //222510.99
  }
  public class cls_LC_BG_Avg_Util {
		public String AVG_UTIL;
		public String NO_CONTRACTS;
	}
  public class cls_Top5DrSumParties {
    public String TO_ACC;  //PSR ASSOCIATE-1246261006260
    public String DR_CNT;  //74
    public String FISCAL_YR;  //2015-2016
    public String FROM_ACC;  //SWAMY COTTON MILL TI-1234223000000707
    public String V_CUST_CODE;  //9874514
    public String TYP;  //DEBIT
    public String TDATE;  //2016-03-31
    public String DR_AMT;  //86610434
    public String FDATE;  //2015-04-01
  }
  public class cls_CreditCount {
    public String FISCAL_YR;  //2015-2016
    public String FIN_CR_CNT;  //1066
    public String V_CUST_CODE;  //9874514
    public String TDATE;  //2016-03-31
    public String FDATE;  //2015-04-01
        public String CR_SUM_CNT;
  }
  public static OperationalData_response parse(String json){
    return (OperationalData_response) System.JSON.deserialize(json, OperationalData_response.class);
  }
}