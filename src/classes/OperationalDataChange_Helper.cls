/*
* @name         : OperationalDataChange_Helper
@description  : Helper class for WS_OperationalDataChange. Used to parse the resonse
and create/update Operation data against an account.
@author       : Dushyant
*/
public class OperationalDataChange_Helper {
    public static WS_OperationData.Response opsDataHelper(){
        
        RETURN null;
    }
    public static Map<String,String> handleOpsData(OperationalData_response.cls_Operational_Data opsDataReq){
        Map<String,String> errorDetail = new Map<String,String>();
        try{
            String custId = opsDataReq.Customer_Id;
            List<Account> acc = new List<Account>();
            List<Id> insertedOpsDataId = new List<Id>();
            List<NEFT_Debit_Credit__c> neftCrDrListToDelete = new List<NEFT_Debit_Credit__c>();
            List<NEFT_Debit_Credit__c> insertNeftCrDrList = new List<NEFT_Debit_Credit__c>();
            List<Operations_Detail__c> opsDataToInsertList = new List<Operations_Detail__c>();
            List<Operations_Detail__c> updateExistOpDetail = new List<Operations_Detail__c>();
            acc = [Select id from Account where CBS_Customer_ID__c=:custId Limit 1];
            
            List<OperationalData_response.cls_CustomerData> opsDataList = new List<OperationalData_response.cls_CustomerData>();
            opsDataList = opsDataReq.CustomerData;
            for(OperationalData_response.cls_CustomerData opsdata : opsDataList){
                Savepoint sp = Database.setSavepoint();
                try{
                    //List<Operations_Detail__c> updateExistOpDetail = new List<Operations_Detail__c>();
                    Operations_Detail__c newOpDetail = new Operations_Detail__c();
                    
                    if(opsData.FDATE != null && opsData.FDATE != ''){
                        newOpDetail.From_Date__c = Date.valueOf(opsData.FDATE);
                    }
                    if(opsData.TDATE != null && opsData.TDATE != ''){
                        newOpDetail.To_Date__c = Date.valueOf(opsData.TDATE);
                    }
                    if(opsData.Ops_Data[0].InwdChqRtns != null && opsData.Ops_Data[0].InwdChqRtns.size() > 0 && opsData.Ops_Data[0].InwdChqRtns[0].INWD_CHQ_RTN != null && opsData.Ops_Data[0].InwdChqRtns[0].INWD_CHQ_RTN != ''){
                        newOpDetail.Inward_check_return__c = Decimal.valueOf(opsData.Ops_Data[0].InwdChqRtns[0].INWD_CHQ_RTN);
                    }
                    if(opsData.Ops_Data[0].AvgLimit != null && opsData.Ops_Data[0].AvgLimit.size() > 0 && opsData.Ops_Data[0].AvgLimit[0].AMOUNT != null && opsData.Ops_Data[0].AvgLimit[0].AMOUNT != ''){
                        newOpDetail.Availment_amount__c = Decimal.valueOf(opsData.Ops_Data[0].AvgLimit[0].AMOUNT);
                    }
                    if(opsData.Ops_Data[0].TotalOutwdChqRecvd != null && opsData.Ops_Data[0].TotalOutwdChqRecvd.size() > 0){
                        if(opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUTW_CNT != null && opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUTW_CNT != '') {
                            newOpDetail.Outward_Check_Count__c=Decimal.valueOf(opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUTW_CNT);    
                        }
                        if(opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUT_CHK_RES != null && opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUT_CHK_RES != '') {
                            newOpDetail.Outward_Check_Count__c=Decimal.valueOf(opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUT_CHK_RES);    
                        }
                    }
                    if(opsData.Ops_Data[0].PromptCloseExceeding != null && opsData.Ops_Data[0].PromptCloseExceeding.size() > 0){
                        if(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_SUM!=null && opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_SUM!= ''){
                            newOpDetail.Exceed_Days_sum_Prompt__c=Decimal.valueOf(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_SUM);
                        }
                        if(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_CNT!=null && opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_CNT!= ''){
                            newOpDetail.Exceed_Days_count_Prompt__c=Decimal.valueOf(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_CNT);
                        }
                        if(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCD_AVERAGE != null){
                            newOpDetail.Average_days_of_Exceedings__c=Decimal.valueOf(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCD_AVERAGE);
                        }
                    }
                    if(opsData.Ops_Data[0].LCBGDevpt != null && opsData.Ops_Data[0].LCBGDevpt.size() > 0){
                        if(opsData.Ops_Data[0].LCBGDevpt[0].DVBG_CNT!=null && opsData.Ops_Data[0].LCBGDevpt[0].DVBG_CNT!= ''){
                            newOpDetail.Devolvement_BG_Count__c=Decimal.valueOf(opsData.Ops_Data[0].LCBGDevpt[0].DVBG_CNT);
                        }
                        if(opsData.Ops_Data[0].LCBGDevpt[0].DVLC_CNT!=null && opsData.Ops_Data[0].LCBGDevpt[0].DVBG_CNT!= ''){
                            newOpDetail.Devolvement_LC_Count__c=Decimal.valueOf(opsData.Ops_Data[0].LCBGDevpt[0].DVLC_CNT);
                        }
                    }
                    if(opsData.Ops_Data[0].ForeignBills != null && opsData.Ops_Data[0].ForeignBills.size() > 0){
                        if(opsData.Ops_Data[0].ForeignBills[0].N_BILLS!=null && opsData.Ops_Data[0].ForeignBills[0].N_BILLS!= ''){
                            newOpDetail.Number_of_Bills__c=Decimal.valueOf(opsData.Ops_Data[0].ForeignBills[0].N_BILLS);
                        }
                        if(opsData.Ops_Data[0].ForeignBills[0].INR_BAL!=null && opsData.Ops_Data[0].ForeignBills[0].INR_BAL!= ''){
                            newOpDetail.Balance_of_FBLS_OD__c=Decimal.valueOf(opsData.Ops_Data[0].ForeignBills[0].INR_BAL);
                        }
                        if(opsData.Ops_Data[0].ForeignBills[0].MAX_INR!=null && opsData.Ops_Data[0].ForeignBills[0].MAX_INR!= ''){
                            newOpDetail.Max_FBLS_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].ForeignBills[0].MAX_INR);
                        }
                        if(opsData.Ops_Data[0].ForeignBills[0].MIN_INR!=null && opsData.Ops_Data[0].ForeignBills[0].MIN_INR!= ''){
                            newOpDetail.Min_FBLS_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].ForeignBills[0].MIN_INR);
                        }
                    }
                    if(opsData.Ops_Data[0].CashWithdrwalAmtSum != null && opsData.Ops_Data[0].CashWithdrwalAmtSum.size() > 0){
                        if(opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_AMT !=null && opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_AMT!= '')
                            newOpDetail.Debit_Summation__c= Decimal.valueOf(opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_AMT);
                        
                        if(opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_CNT !=null && opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_CNT!= '')
                            newOpDetail.Debit_Summation__c = Decimal.valueOf(opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_CNT);
                    }
                    if(opsData.Ops_Data[0].TotalInwdClrCheqs != null && opsData.Ops_Data[0].TotalInwdClrCheqs.size() > 0 && opsData.Ops_Data[0].TotalInwdClrCheqs[0].INW_CNT != null && opsData.Ops_Data[0].TotalInwdClrCheqs[0].INW_CNT!= ''){
                        newOpDetail.Inward_cheque_Count__c=Decimal.valueOf(opsData.Ops_Data[0].TotalInwdClrCheqs[0].INW_CNT);
                    }
                    if(opsData.Ops_Data[0].CreditSummation != null && opsData.Ops_Data[0].CreditSummation.size() > 0){
                        if(opsData.Ops_Data[0].CreditSummation[0].FIN_CR_AMT != null && opsData.Ops_Data[0].CreditSummation[0].FIN_CR_AMT!= '')
                            newOpDetail.FIN_CR_AMT__c=Decimal.valueOf(opsData.Ops_Data[0].CreditSummation[0].FIN_CR_AMT);
                        
                        if(opsData.Ops_Data[0].CreditSummation[0].CR_SUM_AMT != null && opsData.Ops_Data[0].CreditSummation[0].CR_SUM_AMT!= '')
                            newOpDetail.FIN_CR_AMT__c=Decimal.valueOf(opsData.Ops_Data[0].CreditSummation[0].CR_SUM_AMT);
                    }
                    if(opsData.Ops_Data[0].CashDepositCount != null && opsData.Ops_Data[0].CashDepositCount.size() > 0){
                        if(opsData.Ops_Data[0].CashDepositCount[0].CR_CASH_CNT != null && opsData.Ops_Data[0].CashDepositCount[0].CR_CASH_CNT!= ''){
                            newOpDetail.Credit_cash_count__c=Decimal.valueOf(opsData.Ops_Data[0].CashDepositCount[0].CR_CASH_CNT);    
                        }
                        if(opsData.Ops_Data[0].CashDepositCount[0].CASH_CR_CNT != null && opsData.Ops_Data[0].CashDepositCount[0].CASH_CR_CNT!= ''){
                            newOpDetail.Credit_cash_count__c=Decimal.valueOf(opsData.Ops_Data[0].CashDepositCount[0].CASH_CR_CNT);
                        }
                    }
                    if(opsData.Ops_Data[0].CashWithdrawalCount != null && opsData.Ops_Data[0].CashWithdrawalCount.size() > 0 ){
                        if(opsData.Ops_Data[0].CashWithdrawalCount[0].DR_CASH_CNT != null && opsData.Ops_Data[0].CashWithdrawalCount[0].DR_CASH_CNT!= ''){
                            newOpDetail.Debit_count__c=Decimal.valueOf(opsData.Ops_Data[0].CashWithdrawalCount[0].DR_CASH_CNT);    
                        }
                        if(opsData.Ops_Data[0].CashWithdrawalCount[0].CASH_DR_CNT != null && opsData.Ops_Data[0].CashWithdrawalCount[0].CASH_DR_CNT!= ''){
                            newOpDetail.DR_CNT__c =Decimal.valueOf(opsData.Ops_Data[0].CashWithdrawalCount[0].CASH_DR_CNT);    
                        }
                    }
                    if(opsData.Ops_Data[0].DebitSummation != null && opsData.Ops_Data[0].DebitSummation.size() > 0){
                        if(opsData.Ops_Data[0].DebitSummation[0].FIN_DR_AMT != null && opsData.Ops_Data[0].DebitSummation[0].FIN_DR_AMT!= ''){
                            newOpDetail.FIN_DR_AMT__c=Decimal.valueOf(opsData.Ops_Data[0].DebitSummation[0].FIN_DR_AMT);
                        }
                        if(opsData.Ops_Data[0].DebitSummation[0].INT_TR_AMOUNT != null && opsData.Ops_Data[0].DebitSummation[0].INT_TR_AMOUNT!= ''){
                            newOpDetail.INT_TR_AMOUNT__c=Decimal.valueOf(opsData.Ops_Data[0].DebitSummation[0].INT_TR_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].DebitSummation[0].INT_TR_CNT != null && opsData.Ops_Data[0].DebitSummation[0].INT_TR_CNT!= ''){
                            newOpDetail.INT_TR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].DebitSummation[0].INT_TR_CNT);
                        }
                        if(opsData.Ops_Data[0].DebitSummation[0].DR_SUM_AMT != null && opsData.Ops_Data[0].DebitSummation[0].DR_SUM_AMT!= ''){
                            newOpDetail.FIN_DR_AMT__c =Decimal.valueOf(opsData.Ops_Data[0].DebitSummation[0].DR_SUM_AMT);
                        }
                    }
                    if(opsData.Ops_Data[0].DebitCount != null && opsData.Ops_Data[0].DebitCount.size() > 0){
                        if(opsData.Ops_Data[0].DebitCount[0].FIN_DR_CNT != null && opsData.Ops_Data[0].DebitCount[0].FIN_DR_CNT!= ''){
                            newOpDetail.FIN_DR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].DebitCount[0].FIN_DR_CNT);
                        }
                        if(opsData.Ops_Data[0].DebitCount[0].DR_SUM_CNT != null && opsData.Ops_Data[0].DebitCount[0].DR_SUM_CNT!= ''){
                            newOpDetail.FIN_DR_CNT__c = Decimal.valueOf(opsData.Ops_Data[0].DebitCount[0].DR_SUM_CNT);
                        }	
                    }
                    if(opsData.Ops_Data[0].InterestEarned != null && opsData.Ops_Data[0].InterestEarned.size() > 0 && opsData.Ops_Data[0].InterestEarned[0].INT_REVD_AMT != null && opsData.Ops_Data[0].InterestEarned[0].INT_REVD_AMT != ''){
                        newOpDetail.Intrest_Recieved_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].InterestEarned[0].INT_REVD_AMT);
                    }
                    if(opsData.Ops_Data[0].ExceedingsIntrPaid != null && opsData.Ops_Data[0].ExceedingsIntrPaid.size() > 0 && opsData.Ops_Data[0].ExceedingsIntrPaid[0].EXCD_INT_DR != null && opsData.Ops_Data[0].ExceedingsIntrPaid[0].EXCD_INT_DR!= ''){
                        newOpDetail.Exceeding_Intrest_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].ExceedingsIntrPaid[0].EXCD_INT_DR);
                    }
                    if(opsData.Ops_Data[0].OutwdChqRtns != null && opsData.Ops_Data[0].OutwdChqRtns.size() > 0 && opsData.Ops_Data[0].OutwdChqRtns[0].OUTWD_CHQ_RTN != null && opsData.Ops_Data[0].OutwdChqRtns[0].OUTWD_CHQ_RTN!= ''){
                        newOpDetail.Outward_check_return__c=Decimal.valueOf(opsData.Ops_Data[0].OutwdChqRtns[0].OUTWD_CHQ_RTN);
                    }
                    if(opsData.Ops_Data[0].HighValChqRtns != null && opsData.Ops_Data[0].HighValChqRtns.size() > 0 && opsData.Ops_Data[0].HighValChqRtns[0].MAX_RET_AMT != null && opsData.Ops_Data[0].HighValChqRtns[0].MAX_RET_AMT!= ''){
                        newOpDetail.Maximum_Return_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].HighValChqRtns[0].MAX_RET_AMT);
                    }
                    if(opsData.Ops_Data[0].LowValChqRtns != null && opsData.Ops_Data[0].LowValChqRtns.size() > 0 && opsData.Ops_Data[0].LowValChqRtns[0].MIN_RET_AMT != null && opsData.Ops_Data[0].LowValChqRtns[0].MIN_RET_AMT!= ''){
                        newOpDetail.Minimum_Return_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].LowValChqRtns[0].MIN_RET_AMT);
                    }
                    if(opsData.Ops_Data[0].Exceedings != null && opsData.Ops_Data[0].Exceedings.size() > 0 && opsData.Ops_Data[0].Exceedings[0].NO_OF_EXCD != null && opsData.Ops_Data[0].Exceedings[0].NO_OF_EXCD!= ''){
                        newOpDetail.No_of_Exceedings__c=Decimal.valueOf(opsData.Ops_Data[0].Exceedings[0].NO_OF_EXCD);
                    }
                    if(opsData.Ops_Data[0].DelayServWorkCapInt != null && opsData.Ops_Data[0].DelayServWorkCapInt.size() > 0 && opsData.Ops_Data[0].DelayServWorkCapInt[0].INT_DR_CNT != null && opsData.Ops_Data[0].DelayServWorkCapInt[0].INT_DR_CNT != ''){
                        newOpDetail.Delay_in_interest_count_days__c=Decimal.valueOf(opsData.Ops_Data[0].DelayServWorkCapInt[0].INT_DR_CNT);
                    }
                    if(opsData.Ops_Data[0].CashDepositAmtSum != null && opsData.Ops_Data[0].CashDepositAmtSum.size() > 0 && opsData.Ops_Data[0].CashDepositAmtSum[0].CR_CASH_AMT != null && opsData.Ops_Data[0].CashDepositAmtSum[0].CR_CASH_AMT!= ''){
                        newOpDetail.Credit_Cash_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].CashDepositAmtSum[0].CR_CASH_AMT);
                    }
                    if(opsData.Ops_Data[0].ServiceCharges != null && opsData.Ops_Data[0].ServiceCharges.size() > 0){
                        if(opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_CNT!=null && opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_CNT!= ''){
                            newOpDetail.Service_Charge_count__c=Decimal.valueOf(opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_CNT);
                        }
                        if(opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_AMT!=null && opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_AMT!= ''){
                            newOpDetail.Services_Charges_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_AMT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].CreditCount != null && opsData.Ops_Data[0].CreditCount.size() > 0){
                        if(opsData.Ops_Data[0].CreditCount[0].FIN_CR_CNT != null && opsData.Ops_Data[0].CreditCount[0].FIN_CR_CNT!= '') {
                            newOpDetail.FIN_CR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].CreditCount[0].FIN_CR_CNT);    
                        }
                        if(opsData.Ops_Data[0].CreditCount[0].CR_SUM_CNT != null && opsData.Ops_Data[0].CreditCount[0].CR_SUM_CNT!= '') {
                            newOpDetail.FIN_CR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].CreditCount[0].CR_SUM_CNT);    
                        }
                    }
                    /*FCC Mapping*/
                    if(opsData.Ops_Data[0].PCLN_ExtBY_brchManul != null && opsData.Ops_Data[0].PCLN_ExtBY_brchManul.size()>0){
                        if(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MAX_LCY_AMOUNT != null && opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MAX_LCY_AMOUNT != ''){
                            newOpDetail.max_amt_of_ext_conTrade_Cre_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MAX_LCY_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].NO_OF_CONTRACTS != null && opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].NO_OF_CONTRACTS != ''){
                            newOpDetail.No_of_Manually_ext_ConTrade_Cre_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].NO_OF_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MIN_LCY_AMOUNT != null && opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MIN_LCY_AMOUNT != ''){
                            newOpDetail.Min_amt_of_ext_conTrade_Cre_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MIN_LCY_AMOUNT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].PCLN_Intrst_Earned != null && opsData.Ops_Data[0].PCLN_Intrst_Earned.size()>0 && opsData.Ops_Data[0].PCLN_Intrst_Earned[0].N_INT_AMT != null && opsData.Ops_Data[0].PCLN_Intrst_Earned[0].N_INT_AMT != ''){
                        newOpDetail.Amount_of_interest_Commission_earned__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_Intrst_Earned[0].N_INT_AMT);
                    }
                    
                    if(opsData.Ops_Data[0].DTPCBillsOvrDueManual != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual.size()>0){
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AMOUNT != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AMOUNT != ''){
                            newOpDetail.Amount_of_manually_ext_conTrade_Cre_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AMOUNT);
                        }
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MIN_AMOUNT != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MIN_AMOUNT != ''){
                            newOpDetail.Min_amt_of_ext_conTrade_Cre_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MIN_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MAX_AMOUNT != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MAX_AMOUNT != ''){
                            newOpDetail.max_amt_of_ext_conTrade_Cre_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MAX_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].NO_OF_CONTRACTS != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].NO_OF_CONTRACTS != ''){
                            newOpDetail.No_of_Manually_ext_ConTrade_Cre_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].NO_OF_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AVG_OD_DAYS != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AVG_OD_DAYS != ''){
                            newOpDetail.Average_days_Overdue_Contract_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AVG_OD_DAYS );
                        }
                    }
                    
                    if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened.size()>0){
                        if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].AMOUNT != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].AMOUNT != ''){
                            newOpDetail.Amount_of_Contract_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].AMOUNT);
                        }
                        if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].N_NO != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].N_NO != ''){
                            newOpDetail.Total_No_of_contracts_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].N_NO);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].PCLN_PCFC_Opened != null && opsData.Ops_Data[0].PCLN_PCFC_Opened.size()>0){
                        if(opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_AMT != null && opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_AMT != ''){
                            newOpDetail.Amount_of_Contract_PCL__c = Decimal.valueof(opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_AMT);
                        }
                        if(opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_NO != null && opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_NO != ''){
                            newOpDetail.Total_No_of_contracts_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_NO);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].Devolved_LC_BG != null && opsData.Ops_Data[0].Devolved_LC_BG.size()>0){
                        if(opsData.Ops_Data[0].Devolved_LC_BG[0].ACCT_OPEN_BAL != null && opsData.Ops_Data[0].Devolved_LC_BG[0].ACCT_OPEN_BAL != ''){
                            
                        }
                        if(opsData.Ops_Data[0].Devolved_LC_BG[0].DVLC_CNT != null && opsData.Ops_Data[0].Devolved_LC_BG[0].DVLC_CNT != ''){
                            newOpDetail.Noof_crystDevInkCan_CEL_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].Devolved_LC_BG[0].DVLC_CNT);
                        }
                        if(opsData.Ops_Data[0].Devolved_LC_BG[0].DVBG_CNT != null && opsData.Ops_Data[0].Devolved_LC_BG[0].DVBG_CNT != ''){
                            newOpDetail.Noof_crystDevInkCan_CEL_IBG__c = Decimal.valueOf(opsData.Ops_Data[0].Devolved_LC_BG[0].DVBG_CNT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg.size()>0){
                        if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg[0].AVG_UTIL != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg[0].AVG_UTIL != ''){
                            newOpDetail.Average_Availment_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg[0].AVG_UTIL);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt != null && opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt.size()>0){
                        if(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MAX_AMT != null && opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MAX_AMT != ''){
                            newOpDetail.Maximum_amount_of_contract_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MAX_AMT);
                        }
                        if(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MIN_AMT != null && opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MIN_AMT != ''){
                            newOpDetail.Minimum_amount_of_contract_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MIN_AMT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].Forward_Contract_Bkd != null && opsData.Ops_Data[0].Forward_Contract_Bkd.size()>0){
                        if(opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_PURCHASE != null && opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_PURCHASE != '' && opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_SALES != null && opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_SALES != ''){
                            newOpDetail.Amount_of_Contract_CEL__c = Decimal.valueOf(opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_PURCHASE + opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_SALES);
                        }
                        if(opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_SALES != null && opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_SALES != '' && opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_PURCHASE != null && opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_PURCHASE != ''){
                            newOpDetail.Total_No_of_contracts_CEL__c = Decimal.valueOf(opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_SALES + opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_PURCHASE);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].TradeCredit != null && opsData.Ops_Data[0].TradeCredit.size()>0){
                        if(opsData.Ops_Data[0].TradeCredit[0].NO_CONTRACTS != null && opsData.Ops_Data[0].TradeCredit[0].NO_CONTRACTS != ''){
                            newOpDetail.No_of_Manually_ext_ConTrade_Cre_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].TradeCredit[0].NO_CONTRACTS);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk.size()>0){
                        if(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_SALES != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_SALES != '' && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_PURCHASE != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_PURCHASE != ''){
                            newOpDetail.Noof_crystDevInkCan_CEL_CEL__c = Decimal.valueOf(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_SALES + opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_PURCHASE + opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_PURCHASE);
                        }
                        if(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_PURCHASE != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_PURCHASE  != '' && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_SALES != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_SALES != ''){
                            newOpDetail.amount_of_crystDevInkCan_CEL_CEL__c = Decimal.valueOf(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_PURCHASE + opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_SALES);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].CrystalizedBills != null && opsData.Ops_Data[0].CrystalizedBills.size()>0){
                        if(opsData.Ops_Data[0].CrystalizedBills[0].N_DISB_AMT != null && opsData.Ops_Data[0].CrystalizedBills[0].N_DISB_AMT != ''){
                            newOpDetail.amount_of_crystDevInkCan_CEL_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].CrystalizedBills[0].N_DISB_AMT);
                        }
                        if(opsData.Ops_Data[0].CrystalizedBills[0].N_CONTRACTS != null && opsData.Ops_Data[0].CrystalizedBills[0].N_CONTRACTS != ''){
                            newOpDetail.Noof_crystDevInkCan_CEL_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].CrystalizedBills[0].N_CONTRACTS);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].LC_BG_Opened != null && opsData.Ops_Data[0].LC_BG_Opened.size()>0){
                        if(opsData.Ops_Data[0].LC_BG_Opened[0].BG_AMOUNT != null && opsData.Ops_Data[0].LC_BG_Opened[0].BG_AMOUNT != ''){
                            newOpDetail.Amount_of_Contract_IBG__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Opened[0].BG_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].LC_BG_Opened[0].N_LC_CONTRACTS != null && opsData.Ops_Data[0].LC_BG_Opened[0].N_LC_CONTRACTS != ''){
                            newOpDetail.Total_No_of_contracts_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Opened[0].N_LC_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].LC_BG_Opened[0].N_BG_CONTRACTS != null && opsData.Ops_Data[0].LC_BG_Opened[0].N_BG_CONTRACTS != ''){
                            newOpDetail.Total_No_of_contracts_IBG__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Opened[0].N_BG_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].LC_BG_Opened[0].LC_AMOUNT != null && opsData.Ops_Data[0].LC_BG_Opened[0].LC_AMOUNT != ''){
                            newOpDetail.Amount_of_Contract_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Opened[0].LC_AMOUNT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].BillsOverDue != null && opsData.Ops_Data[0].BillsOverDue.size()>0){
                        if(opsData.Ops_Data[0].BillsOverDue[0].AVG_OD_DAYS != null && opsData.Ops_Data[0].BillsOverDue[0].AVG_OD_DAYS != ''){
                            newOpDetail.Average_days_Overdue_Contract_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].BillsOverDue[0].AVG_OD_DAYS);
                        }
                        if(opsData.Ops_Data[0].BillsOverDue[0].NO_OD_DAYS != null && opsData.Ops_Data[0].BillsOverDue[0].NO_OD_DAYS != ''){
                            newOpDetail.No_of_overdue_contract_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].BillsOverDue[0].NO_OD_DAYS);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].MBillsReceived != null && opsData.Ops_Data[0].MBillsReceived.size()>0){
                        if(opsData.Ops_Data[0].MBillsReceived[0].N_CONTRACTS != null && opsData.Ops_Data[0].MBillsReceived[0].N_CONTRACTS != ''){
                            newOpDetail.No_of_MBILL_MBIL_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].MBillsReceived[0].N_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].MBillsReceived[0].AMOUNT != null && opsData.Ops_Data[0].MBillsReceived[0].AMOUNT != null){
                            newOpDetail.Amount_of_MBILL_MBIL_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].MBillsReceived[0].AMOUNT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].LC_BG_Avg_Util != null && opsData.Ops_Data[0].LC_BG_Avg_Util.size()>0){
                        if(opsData.Ops_Data[0].LC_BG_Avg_Util[0].NO_CONTRACTS != null && opsData.Ops_Data[0].LC_BG_Avg_Util[0].NO_CONTRACTS != ''){
                            newOpDetail.Average_Availment_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Avg_Util[0].NO_CONTRACTS);
                        }
                    }
                    
                    /*.....*/
                    if(acc[0].Id != null){
                        newOpDetail.Account__c=acc[0].Id;
                    }
                    
                    String extID='';
                    if(opsData.FISCAL_YR =='LAST_12_MONTHS'){
                        Integer currentYear = Utility.getCurrentYear();
                        String cyString = String.valueOf(currentYear);
                        String currentFY = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
                        
                        newOpDetail.Fiscal_Type__c ='YTD';
                        newOpDetail.Fiscal_Year__c = currentFY;
                        extID=custId+'@'+newOpDetail.Fiscal_Year__c+'@'+newOpDetail.Fiscal_Type__c;
                        
                        List<Operations_Detail__c> existOpDetail=[Select ID,External_Id__c,Fiscal_Year__c,Fiscal_Type__c from Operations_Detail__c where External_Id__c=:extID limit 1];
                        if(existOpDetail.size()>0){
                            if(System.now().month()==Integer.ValueOf(System.Label.OperationalDataChangeMonth) && System.now().day()==Integer.valueOf(System.Label.OperationalDataChangeDate)){
                                existOpDetail[0].Fiscal_Type__c='Actual';
                                existOpDetail[0].External_Id__c=custId+'@'+existOpDetail[0].Fiscal_Year__c+'@'+existOpDetail[0].Fiscal_Type__c;
                                updateExistOpDetail.add(existOpDetail[0]);
                            }else {
                                newOpDetail.id=existOpDetail[0].id;
                            }                   
                        }
                    }
                    else{
                        System.debug('Fyear 171 -->'+ opsData.FISCAL_YR);
                        List<String> fYear = opsData.FISCAL_YR.split('-');
                        newOpDetail.Fiscal_Type__c ='Actual';
                        newOpDetail.Fiscal_Year__c =fYear[0]+'-'+fYear[1].subString(2,4);
                        
                        extID=custId+'@'+newOpDetail.Fiscal_Year__c+'@'+newOpDetail.Fiscal_Type__c;
                    }
                    
                    newOpDetail.External_Id__c=extID;
                    opsDataToInsertList.add(newOpDetail);
                    //UPSERT newOpDetail External_Id__c;
                    //if(updateExistOpDetail.size()>0)
                    //  update updateExistOpDetail;
                    //insertedOpsDataId.add(newOpDetail.Id);
                    
                    
                    Id CrRecordTypeId = Schema.SObjectType.NEFT_Debit_Credit__c.getRecordTypeInfosByName().get('Credit').getRecordTypeId();
                    Id DrRecordTypeId = Schema.SObjectType.NEFT_Debit_Credit__c.getRecordTypeInfosByName().get('Debit').getRecordTypeId();
                    if(opsData.Ops_Data[0].Top5CrSumParties!=null && opsData.Ops_Data[0].Top5CrSumParties.size()>0){
                        for(integer i=0;i<opsData.Ops_Data[0].Top5CrSumParties.size();i++){
                            NEFT_Debit_Credit__c neftCrDr=new NEFT_Debit_Credit__c();
                            //neftCrDr.Operations_Detail__c=newOpDetail.id;
                            neftCrDr.Operations_Detail__r = new Operations_Detail__c(External_Id__c = newOpDetail.External_Id__c);
                            neftCrDr.Type__c=opsData.Ops_Data[0].Top5CrSumParties[i].TYP;
                            neftCrDr.To_Account__c=opsData.Ops_Data[0].Top5CrSumParties[i].TO_ACC;
                            neftCrDr.From_Account__c=opsData.Ops_Data[0].Top5CrSumParties[i].FROM_ACC;
                            neftCrDr.Credit_Sum_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].Top5CrSumParties[i].CR_AMT);
                            neftCrDr.Credit_Sum_Count__c=Decimal.valueOf(opsData.Ops_Data[0].Top5CrSumParties[i].CR_CNT);
                            neftCrDr.recordTypeID=CrRecordTypeId;
                            insertNeftCrDrList.add(neftCrDr);
                        }
                    }
                    if(opsData.Ops_Data[0].Top5DrSumParties!=null && opsData.Ops_Data[0].Top5DrSumParties.size()>0){
                        for(integer i=0;i<opsData.Ops_Data[0].Top5DrSumParties.size();i++){
                            NEFT_Debit_Credit__c neftCrDr=new NEFT_Debit_Credit__c();
                            //neftCrDr.Operations_Detail__c=newOpDetail.id;
                            neftCrDr.Operations_Detail__r = new Operations_Detail__c(External_Id__c = newOpDetail.External_Id__c);
                            neftCrDr.Type__c=opsData.Ops_Data[0].Top5DrSumParties[i].TYP;
                            neftCrDr.To_Account__c=opsData.Ops_Data[0].Top5DrSumParties[i].TO_ACC;
                            neftCrDr.From_Account__c=opsData.Ops_Data[0].Top5DrSumParties[i].FROM_ACC;
                            neftCrDr.DR_AMT__c=Decimal.valueOf(opsData.Ops_Data[0].Top5DrSumParties[i].DR_AMT);
                            neftCrDr.DR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].Top5DrSumParties[i].DR_CNT);
                            neftCrDr.recordTypeID=DrRecordTypeId;
                            insertNeftCrDrList.add(neftCrDr);
                        }
                    }
                    
                    if(insertNeftCrDrList.size()>0){
                        //insert insertNeftCrDrList;
                        //opsDetailCreditDebitMap.put(newOpDetail.id,insertNeftCrDrList);
                    }
                }
                catch(Exception e){
                    System.debug(e.getMessage());
                    System.debug(e.getLineNumber());
                    Database.rollback(sp);
                }
            }
            if(!opsDataToInsertList.isEmpty()){
                UPSERT opsDataToInsertList External_Id__c;
                for(Operations_Detail__c opsData : opsDataToInsertList){
                    insertedOpsDataId.add(opsData.Id);
                }
            }
            if(!updateExistOpDetail.isEmpty()){
                update updateExistOpDetail;
            }
            
            
            //delete existing NEFT credit/debit
            neftCrDrListToDelete=[Select id from NEFT_Debit_Credit__c where Operations_Detail__c IN :insertedOpsDataId];
            if(neftCrDrListToDelete.size()>0) delete neftCrDrListToDelete;
            if(insertNeftCrDrList.size()>0) INSERT insertNeftCrDrList;
            /*if(!opsDetailCreditDebitMap.isEmpty()){
        for(opsDetailCreditDebitMap.values()){//insertNeftCrDrList
        }
        }*/
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            errorDetail.put(opsDataReq.Customer_Id,e.getMessage());
            RETURN errorDetail;
        }
        RETURN null;
    }


    public static Map<String,String> insertOpsData(OperationalData_response.cls_Operational_Data opsDataReq,map<String,String> accountMap){
        Map<String,String> errorDetail = new Map<String,String>();
        try{
            String custId = opsDataReq.Customer_Id;
            List<Account> acc = new List<Account>();
            List<Id> insertedOpsDataId = new List<Id>();
            List<NEFT_Debit_Credit__c> neftCrDrListToDelete = new List<NEFT_Debit_Credit__c>();
            List<NEFT_Debit_Credit__c> insertNeftCrDrList = new List<NEFT_Debit_Credit__c>();
            List<Bank_Operations_Detail__c> opsDataToInsertList = new List<Bank_Operations_Detail__c>();
            List<Bank_Operations_Detail__c> updateExistOpDetail = new List<Bank_Operations_Detail__c>();
            acc = [Select id from Account where CBS_Customer_ID__c=:custId Limit 1];
            
            List<OperationalData_response.cls_CustomerData> opsDataList = new List<OperationalData_response.cls_CustomerData>();
            opsDataList = opsDataReq.CustomerData;
            for(OperationalData_response.cls_CustomerData opsdata : opsDataList){
                Savepoint sp = Database.setSavepoint();
                try{
                    //List<Operations_Detail__c> updateExistOpDetail = new List<Operations_Detail__c>();
                    Bank_Operations_Detail__c newOpDetail = new Bank_Operations_Detail__c();
                    
                    newOpDetail.Bank_Account_No__c= accountMap.get(custId);
                    newOpDetail.Bank_Name__c= 'KVB';

                    if(opsData.FDATE != null && opsData.FDATE != ''){
                        newOpDetail.From_Date__c = Date.valueOf(opsData.FDATE);
                    }
                    if(opsData.TDATE != null && opsData.TDATE != ''){
                        newOpDetail.To_Date__c = Date.valueOf(opsData.TDATE);
                    }
                    if(opsData.Ops_Data[0].InwdChqRtns != null && opsData.Ops_Data[0].InwdChqRtns.size() > 0 && opsData.Ops_Data[0].InwdChqRtns[0].INWD_CHQ_RTN != null && opsData.Ops_Data[0].InwdChqRtns[0].INWD_CHQ_RTN != ''){
                        newOpDetail.Inward_check_return__c = Decimal.valueOf(opsData.Ops_Data[0].InwdChqRtns[0].INWD_CHQ_RTN);
                    }
                    if(opsData.Ops_Data[0].AvgLimit != null && opsData.Ops_Data[0].AvgLimit.size() > 0 && opsData.Ops_Data[0].AvgLimit[0].AMOUNT != null && opsData.Ops_Data[0].AvgLimit[0].AMOUNT != ''){
                        newOpDetail.Availment_amount__c = Decimal.valueOf(opsData.Ops_Data[0].AvgLimit[0].AMOUNT);
                    }
                    if(opsData.Ops_Data[0].TotalOutwdChqRecvd != null && opsData.Ops_Data[0].TotalOutwdChqRecvd.size() > 0){
                        if(opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUTW_CNT != null && opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUTW_CNT != '') {
                            newOpDetail.Outward_Check_Count__c=Decimal.valueOf(opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUTW_CNT);    
                        }
                        if(opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUT_CHK_RES != null && opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUT_CHK_RES != '') {
                            newOpDetail.Outward_Check_Count__c=Decimal.valueOf(opsData.Ops_Data[0].TotalOutwdChqRecvd[0].OUT_CHK_RES);    
                        }
                    }
                    if(opsData.Ops_Data[0].PromptCloseExceeding != null && opsData.Ops_Data[0].PromptCloseExceeding.size() > 0){
                        if(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_SUM!=null && opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_SUM!= ''){
                            newOpDetail.Exceed_Days_sum_Prompt__c=Decimal.valueOf(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_SUM);
                        }
                        if(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_CNT!=null && opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_CNT!= ''){
                            newOpDetail.Exceed_Days_count_Prompt__c=Decimal.valueOf(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCEED_DAYS_CNT);
                        }
                        if(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCD_AVERAGE != null){
                            newOpDetail.Average_days_of_Exceedings__c=Decimal.valueOf(opsData.Ops_Data[0].PromptCloseExceeding[0].EXCD_AVERAGE);
                        }
                    }
                    if(opsData.Ops_Data[0].LCBGDevpt != null && opsData.Ops_Data[0].LCBGDevpt.size() > 0){
                        if(opsData.Ops_Data[0].LCBGDevpt[0].DVBG_CNT!=null && opsData.Ops_Data[0].LCBGDevpt[0].DVBG_CNT!= ''){
                            newOpDetail.Devolvement_BG_Count__c=Decimal.valueOf(opsData.Ops_Data[0].LCBGDevpt[0].DVBG_CNT);
                        }
                        if(opsData.Ops_Data[0].LCBGDevpt[0].DVLC_CNT!=null && opsData.Ops_Data[0].LCBGDevpt[0].DVBG_CNT!= ''){
                            newOpDetail.Devolvement_LC_Count__c=Decimal.valueOf(opsData.Ops_Data[0].LCBGDevpt[0].DVLC_CNT);
                        }
                    }
                    if(opsData.Ops_Data[0].ForeignBills != null && opsData.Ops_Data[0].ForeignBills.size() > 0){
                        if(opsData.Ops_Data[0].ForeignBills[0].N_BILLS!=null && opsData.Ops_Data[0].ForeignBills[0].N_BILLS!= ''){
                            newOpDetail.Number_of_Bills__c=Decimal.valueOf(opsData.Ops_Data[0].ForeignBills[0].N_BILLS);
                        }
                        if(opsData.Ops_Data[0].ForeignBills[0].INR_BAL!=null && opsData.Ops_Data[0].ForeignBills[0].INR_BAL!= ''){
                            newOpDetail.Balance_of_FBLS_OD__c=Decimal.valueOf(opsData.Ops_Data[0].ForeignBills[0].INR_BAL);
                        }
                        if(opsData.Ops_Data[0].ForeignBills[0].MAX_INR!=null && opsData.Ops_Data[0].ForeignBills[0].MAX_INR!= ''){
                            newOpDetail.Max_FBLS_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].ForeignBills[0].MAX_INR);
                        }
                        if(opsData.Ops_Data[0].ForeignBills[0].MIN_INR!=null && opsData.Ops_Data[0].ForeignBills[0].MIN_INR!= ''){
                            newOpDetail.Min_FBLS_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].ForeignBills[0].MIN_INR);
                        }
                    }
                    if(opsData.Ops_Data[0].CashWithdrwalAmtSum != null && opsData.Ops_Data[0].CashWithdrwalAmtSum.size() > 0){
                        if(opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_AMT !=null && opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_AMT!= '')
                            newOpDetail.Debit_Summation__c= Decimal.valueOf(opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_AMT);
                        
                        if(opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_CNT !=null && opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_CNT!= '')
                            newOpDetail.Debit_Summation__c = Decimal.valueOf(opsData.Ops_Data[0].CashWithdrwalAmtSum[0].DR_CASH_CNT);
                    }
                    if(opsData.Ops_Data[0].TotalInwdClrCheqs != null && opsData.Ops_Data[0].TotalInwdClrCheqs.size() > 0 && opsData.Ops_Data[0].TotalInwdClrCheqs[0].INW_CNT != null && opsData.Ops_Data[0].TotalInwdClrCheqs[0].INW_CNT!= ''){
                        newOpDetail.Inward_cheque_Count__c=Decimal.valueOf(opsData.Ops_Data[0].TotalInwdClrCheqs[0].INW_CNT);
                    }
                    if(opsData.Ops_Data[0].CreditSummation != null && opsData.Ops_Data[0].CreditSummation.size() > 0){
                        if(opsData.Ops_Data[0].CreditSummation[0].FIN_CR_AMT != null && opsData.Ops_Data[0].CreditSummation[0].FIN_CR_AMT!= '')
                            newOpDetail.FIN_CR_AMT__c=Decimal.valueOf(opsData.Ops_Data[0].CreditSummation[0].FIN_CR_AMT);
                        
                        if(opsData.Ops_Data[0].CreditSummation[0].CR_SUM_AMT != null && opsData.Ops_Data[0].CreditSummation[0].CR_SUM_AMT!= '')
                            newOpDetail.FIN_CR_AMT__c=Decimal.valueOf(opsData.Ops_Data[0].CreditSummation[0].CR_SUM_AMT);
                    }
                    if(opsData.Ops_Data[0].CashDepositCount != null && opsData.Ops_Data[0].CashDepositCount.size() > 0){
                        if(opsData.Ops_Data[0].CashDepositCount[0].CR_CASH_CNT != null && opsData.Ops_Data[0].CashDepositCount[0].CR_CASH_CNT!= ''){
                            newOpDetail.Credit_cash_count__c=Decimal.valueOf(opsData.Ops_Data[0].CashDepositCount[0].CR_CASH_CNT);    
                        }
                        if(opsData.Ops_Data[0].CashDepositCount[0].CASH_CR_CNT != null && opsData.Ops_Data[0].CashDepositCount[0].CASH_CR_CNT!= ''){
                            newOpDetail.Credit_cash_count__c=Decimal.valueOf(opsData.Ops_Data[0].CashDepositCount[0].CASH_CR_CNT);
                        }
                    }
                    if(opsData.Ops_Data[0].CashWithdrawalCount != null && opsData.Ops_Data[0].CashWithdrawalCount.size() > 0 ){
                        if(opsData.Ops_Data[0].CashWithdrawalCount[0].DR_CASH_CNT != null && opsData.Ops_Data[0].CashWithdrawalCount[0].DR_CASH_CNT!= ''){
                            newOpDetail.Debit_count__c=Decimal.valueOf(opsData.Ops_Data[0].CashWithdrawalCount[0].DR_CASH_CNT);    
                        }
                        if(opsData.Ops_Data[0].CashWithdrawalCount[0].CASH_DR_CNT != null && opsData.Ops_Data[0].CashWithdrawalCount[0].CASH_DR_CNT!= ''){
                            newOpDetail.DR_CNT__c =Decimal.valueOf(opsData.Ops_Data[0].CashWithdrawalCount[0].CASH_DR_CNT);    
                        }
                    }
                    if(opsData.Ops_Data[0].DebitSummation != null && opsData.Ops_Data[0].DebitSummation.size() > 0){
                        if(opsData.Ops_Data[0].DebitSummation[0].FIN_DR_AMT != null && opsData.Ops_Data[0].DebitSummation[0].FIN_DR_AMT!= ''){
                            newOpDetail.FIN_DR_AMT__c=Decimal.valueOf(opsData.Ops_Data[0].DebitSummation[0].FIN_DR_AMT);
                        }
                        if(opsData.Ops_Data[0].DebitSummation[0].INT_TR_AMOUNT != null && opsData.Ops_Data[0].DebitSummation[0].INT_TR_AMOUNT!= ''){
                            newOpDetail.INT_TR_AMOUNT__c=Decimal.valueOf(opsData.Ops_Data[0].DebitSummation[0].INT_TR_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].DebitSummation[0].INT_TR_CNT != null && opsData.Ops_Data[0].DebitSummation[0].INT_TR_CNT!= ''){
                            newOpDetail.INT_TR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].DebitSummation[0].INT_TR_CNT);
                        }
                        if(opsData.Ops_Data[0].DebitSummation[0].DR_SUM_AMT != null && opsData.Ops_Data[0].DebitSummation[0].DR_SUM_AMT!= ''){
                            newOpDetail.FIN_DR_AMT__c =Decimal.valueOf(opsData.Ops_Data[0].DebitSummation[0].DR_SUM_AMT);
                        }
                    }
                    if(opsData.Ops_Data[0].DebitCount != null && opsData.Ops_Data[0].DebitCount.size() > 0){
                        if(opsData.Ops_Data[0].DebitCount[0].FIN_DR_CNT != null && opsData.Ops_Data[0].DebitCount[0].FIN_DR_CNT!= ''){
                            newOpDetail.FIN_DR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].DebitCount[0].FIN_DR_CNT);
                        }
                        if(opsData.Ops_Data[0].DebitCount[0].DR_SUM_CNT != null && opsData.Ops_Data[0].DebitCount[0].DR_SUM_CNT!= ''){
                            newOpDetail.FIN_DR_CNT__c = Decimal.valueOf(opsData.Ops_Data[0].DebitCount[0].DR_SUM_CNT);
                        }   
                    }
                    if(opsData.Ops_Data[0].InterestEarned != null && opsData.Ops_Data[0].InterestEarned.size() > 0 && opsData.Ops_Data[0].InterestEarned[0].INT_REVD_AMT != null && opsData.Ops_Data[0].InterestEarned[0].INT_REVD_AMT != ''){
                        newOpDetail.Intrest_Recieved_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].InterestEarned[0].INT_REVD_AMT);
                    }
                    if(opsData.Ops_Data[0].ExceedingsIntrPaid != null && opsData.Ops_Data[0].ExceedingsIntrPaid.size() > 0 && opsData.Ops_Data[0].ExceedingsIntrPaid[0].EXCD_INT_DR != null && opsData.Ops_Data[0].ExceedingsIntrPaid[0].EXCD_INT_DR!= ''){
                        newOpDetail.Exceeding_Intrest_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].ExceedingsIntrPaid[0].EXCD_INT_DR);
                    }
                    if(opsData.Ops_Data[0].OutwdChqRtns != null && opsData.Ops_Data[0].OutwdChqRtns.size() > 0 && opsData.Ops_Data[0].OutwdChqRtns[0].OUTWD_CHQ_RTN != null && opsData.Ops_Data[0].OutwdChqRtns[0].OUTWD_CHQ_RTN!= ''){
                        newOpDetail.Outward_check_return__c=Decimal.valueOf(opsData.Ops_Data[0].OutwdChqRtns[0].OUTWD_CHQ_RTN);
                    }
                    if(opsData.Ops_Data[0].HighValChqRtns != null && opsData.Ops_Data[0].HighValChqRtns.size() > 0 && opsData.Ops_Data[0].HighValChqRtns[0].MAX_RET_AMT != null && opsData.Ops_Data[0].HighValChqRtns[0].MAX_RET_AMT!= ''){
                        newOpDetail.Maximum_Return_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].HighValChqRtns[0].MAX_RET_AMT);
                    }
                    if(opsData.Ops_Data[0].LowValChqRtns != null && opsData.Ops_Data[0].LowValChqRtns.size() > 0 && opsData.Ops_Data[0].LowValChqRtns[0].MIN_RET_AMT != null && opsData.Ops_Data[0].LowValChqRtns[0].MIN_RET_AMT!= ''){
                        newOpDetail.Minimum_Return_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].LowValChqRtns[0].MIN_RET_AMT);
                    }
                    if(opsData.Ops_Data[0].Exceedings != null && opsData.Ops_Data[0].Exceedings.size() > 0 && opsData.Ops_Data[0].Exceedings[0].NO_OF_EXCD != null && opsData.Ops_Data[0].Exceedings[0].NO_OF_EXCD!= ''){
                        newOpDetail.No_of_Exceedings__c=Decimal.valueOf(opsData.Ops_Data[0].Exceedings[0].NO_OF_EXCD);
                    }
                    if(opsData.Ops_Data[0].DelayServWorkCapInt != null && opsData.Ops_Data[0].DelayServWorkCapInt.size() > 0 && opsData.Ops_Data[0].DelayServWorkCapInt[0].INT_DR_CNT != null && opsData.Ops_Data[0].DelayServWorkCapInt[0].INT_DR_CNT != ''){
                        newOpDetail.Delay_in_interest_count_days__c=Decimal.valueOf(opsData.Ops_Data[0].DelayServWorkCapInt[0].INT_DR_CNT);
                    }
                    if(opsData.Ops_Data[0].CashDepositAmtSum != null && opsData.Ops_Data[0].CashDepositAmtSum.size() > 0 && opsData.Ops_Data[0].CashDepositAmtSum[0].CR_CASH_AMT != null && opsData.Ops_Data[0].CashDepositAmtSum[0].CR_CASH_AMT!= ''){
                        newOpDetail.Credit_Cash_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].CashDepositAmtSum[0].CR_CASH_AMT);
                    }
                    if(opsData.Ops_Data[0].ServiceCharges != null && opsData.Ops_Data[0].ServiceCharges.size() > 0){
                        if(opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_CNT!=null && opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_CNT!= ''){
                            newOpDetail.Service_Charge_count__c=Decimal.valueOf(opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_CNT);
                        }
                        if(opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_AMT!=null && opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_AMT!= ''){
                            newOpDetail.Services_Charges_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].ServiceCharges[0].DR_SERV_AMT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].CreditCount != null && opsData.Ops_Data[0].CreditCount.size() > 0){
                        if(opsData.Ops_Data[0].CreditCount[0].FIN_CR_CNT != null && opsData.Ops_Data[0].CreditCount[0].FIN_CR_CNT!= '') {
                            newOpDetail.FIN_CR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].CreditCount[0].FIN_CR_CNT);    
                        }
                        if(opsData.Ops_Data[0].CreditCount[0].CR_SUM_CNT != null && opsData.Ops_Data[0].CreditCount[0].CR_SUM_CNT!= '') {
                            newOpDetail.FIN_CR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].CreditCount[0].CR_SUM_CNT);    
                        }
                    }
                    /*FCC Mapping*/
                    if(opsData.Ops_Data[0].PCLN_ExtBY_brchManul != null && opsData.Ops_Data[0].PCLN_ExtBY_brchManul.size()>0){
                        if(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MAX_LCY_AMOUNT != null && opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MAX_LCY_AMOUNT != ''){
                            newOpDetail.max_amt_of_ext_conTrade_Cre_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MAX_LCY_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].NO_OF_CONTRACTS != null && opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].NO_OF_CONTRACTS != ''){
                            newOpDetail.No_of_Manually_ext_ConTrade_Cre_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].NO_OF_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MIN_LCY_AMOUNT != null && opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MIN_LCY_AMOUNT != ''){
                            newOpDetail.Min_amt_of_ext_conTrade_Cre_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_ExtBY_brchManul[0].MIN_LCY_AMOUNT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].PCLN_Intrst_Earned != null && opsData.Ops_Data[0].PCLN_Intrst_Earned.size()>0 && opsData.Ops_Data[0].PCLN_Intrst_Earned[0].N_INT_AMT != null && opsData.Ops_Data[0].PCLN_Intrst_Earned[0].N_INT_AMT != ''){
                        newOpDetail.Amount_of_interest_Commission_earned__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_Intrst_Earned[0].N_INT_AMT);
                    }
                    
                    if(opsData.Ops_Data[0].DTPCBillsOvrDueManual != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual.size()>0){
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AMOUNT != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AMOUNT != ''){
                            newOpDetail.Amount_of_manually_ext_conTrade_Cre_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AMOUNT);
                        }
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MIN_AMOUNT != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MIN_AMOUNT != ''){
                            newOpDetail.Min_amt_of_ext_conTrade_Cre_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MIN_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MAX_AMOUNT != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MAX_AMOUNT != ''){
                            newOpDetail.max_amt_of_ext_conTrade_Cre_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].MAX_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].NO_OF_CONTRACTS != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].NO_OF_CONTRACTS != ''){
                            newOpDetail.No_of_Manually_ext_ConTrade_Cre_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].NO_OF_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AVG_OD_DAYS != null && opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AVG_OD_DAYS != ''){
                            newOpDetail.Average_days_Overdue_Contract_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].DTPCBillsOvrDueManual[0].AVG_OD_DAYS );
                        }
                    }
                    
                    if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened.size()>0){
                        if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].AMOUNT != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].AMOUNT != ''){
                            newOpDetail.Amount_of_Contract_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].AMOUNT);
                        }
                        if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].N_NO != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].N_NO != ''){
                            newOpDetail.Total_No_of_contracts_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Opened[0].N_NO);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].PCLN_PCFC_Opened != null && opsData.Ops_Data[0].PCLN_PCFC_Opened.size()>0){
                        if(opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_AMT != null && opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_AMT != ''){
                            newOpDetail.Amount_of_Contract_PCL__c = Decimal.valueof(opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_AMT);
                        }
                        if(opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_NO != null && opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_NO != ''){
                            newOpDetail.Total_No_of_contracts_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_PCFC_Opened[0].N_DISB_NO);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].Devolved_LC_BG != null && opsData.Ops_Data[0].Devolved_LC_BG.size()>0){
                        if(opsData.Ops_Data[0].Devolved_LC_BG[0].ACCT_OPEN_BAL != null && opsData.Ops_Data[0].Devolved_LC_BG[0].ACCT_OPEN_BAL != ''){
                            
                        }
                        if(opsData.Ops_Data[0].Devolved_LC_BG[0].DVLC_CNT != null && opsData.Ops_Data[0].Devolved_LC_BG[0].DVLC_CNT != ''){
                            newOpDetail.Noof_crystDevInkCan_CEL_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].Devolved_LC_BG[0].DVLC_CNT);
                        }
                        if(opsData.Ops_Data[0].Devolved_LC_BG[0].DVBG_CNT != null && opsData.Ops_Data[0].Devolved_LC_BG[0].DVBG_CNT != ''){
                            newOpDetail.Noof_crystDevInkCan_CEL_IBG__c = Decimal.valueOf(opsData.Ops_Data[0].Devolved_LC_BG[0].DVBG_CNT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg.size()>0){
                        if(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg[0].AVG_UTIL != null && opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg[0].AVG_UTIL != ''){
                            newOpDetail.Average_Availment_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].FBN_FBP_EBD_RADV_Avg[0].AVG_UTIL);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt != null && opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt.size()>0){
                        if(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MAX_AMT != null && opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MAX_AMT != ''){
                            newOpDetail.Maximum_amount_of_contract_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MAX_AMT);
                        }
                        if(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MIN_AMT != null && opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MIN_AMT != ''){
                            newOpDetail.Minimum_amount_of_contract_PCL__c = Decimal.valueOf(opsData.Ops_Data[0].PCLN_PCFC_Min_Max_Amt[0].N_MIN_AMT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].Forward_Contract_Bkd != null && opsData.Ops_Data[0].Forward_Contract_Bkd.size()>0){
                        if(opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_PURCHASE != null && opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_PURCHASE != '' && opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_SALES != null && opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_SALES != ''){
                            newOpDetail.Amount_of_Contract_CEL__c = Decimal.valueOf(opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_PURCHASE + opsData.Ops_Data[0].Forward_Contract_Bkd[0].AMOUNT_SALES);
                        }
                        if(opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_SALES != null && opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_SALES != '' && opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_PURCHASE != null && opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_PURCHASE != ''){
                            newOpDetail.Total_No_of_contracts_CEL__c = Decimal.valueOf(opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_SALES + opsData.Ops_Data[0].Forward_Contract_Bkd[0].CNT_PURCHASE);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].TradeCredit != null && opsData.Ops_Data[0].TradeCredit.size()>0){
                        if(opsData.Ops_Data[0].TradeCredit[0].NO_CONTRACTS != null && opsData.Ops_Data[0].TradeCredit[0].NO_CONTRACTS != ''){
                            newOpDetail.No_of_Manually_ext_ConTrade_Cre_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].TradeCredit[0].NO_CONTRACTS);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk.size()>0){
                        if(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_SALES != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_SALES != '' && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_PURCHASE != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_PURCHASE != ''){
                            newOpDetail.Noof_crystDevInkCan_CEL_CEL__c = Decimal.valueOf(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_SALES + opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_PURCHASE + opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].CNT_PURCHASE);
                        }
                        if(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_PURCHASE != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_PURCHASE  != '' && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_SALES != null && opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_SALES != ''){
                            newOpDetail.amount_of_crystDevInkCan_CEL_CEL__c = Decimal.valueOf(opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_PURCHASE + opsData.Ops_Data[0].Forward_Contract_Cancldby_custBnk[0].AMOUNT_SALES);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].CrystalizedBills != null && opsData.Ops_Data[0].CrystalizedBills.size()>0){
                        if(opsData.Ops_Data[0].CrystalizedBills[0].N_DISB_AMT != null && opsData.Ops_Data[0].CrystalizedBills[0].N_DISB_AMT != ''){
                            newOpDetail.amount_of_crystDevInkCan_CEL_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].CrystalizedBills[0].N_DISB_AMT);
                        }
                        if(opsData.Ops_Data[0].CrystalizedBills[0].N_CONTRACTS != null && opsData.Ops_Data[0].CrystalizedBills[0].N_CONTRACTS != ''){
                            newOpDetail.Noof_crystDevInkCan_CEL_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].CrystalizedBills[0].N_CONTRACTS);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].LC_BG_Opened != null && opsData.Ops_Data[0].LC_BG_Opened.size()>0){
                        if(opsData.Ops_Data[0].LC_BG_Opened[0].BG_AMOUNT != null && opsData.Ops_Data[0].LC_BG_Opened[0].BG_AMOUNT != ''){
                            newOpDetail.Amount_of_Contract_IBG__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Opened[0].BG_AMOUNT);
                        }
                        if(opsData.Ops_Data[0].LC_BG_Opened[0].N_LC_CONTRACTS != null && opsData.Ops_Data[0].LC_BG_Opened[0].N_LC_CONTRACTS != ''){
                            newOpDetail.Total_No_of_contracts_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Opened[0].N_LC_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].LC_BG_Opened[0].N_BG_CONTRACTS != null && opsData.Ops_Data[0].LC_BG_Opened[0].N_BG_CONTRACTS != ''){
                            newOpDetail.Total_No_of_contracts_IBG__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Opened[0].N_BG_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].LC_BG_Opened[0].LC_AMOUNT != null && opsData.Ops_Data[0].LC_BG_Opened[0].LC_AMOUNT != ''){
                            newOpDetail.Amount_of_Contract_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Opened[0].LC_AMOUNT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].BillsOverDue != null && opsData.Ops_Data[0].BillsOverDue.size()>0){
                        if(opsData.Ops_Data[0].BillsOverDue[0].AVG_OD_DAYS != null && opsData.Ops_Data[0].BillsOverDue[0].AVG_OD_DAYS != ''){
                            newOpDetail.Average_days_Overdue_Contract_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].BillsOverDue[0].AVG_OD_DAYS);
                        }
                        if(opsData.Ops_Data[0].BillsOverDue[0].NO_OD_DAYS != null && opsData.Ops_Data[0].BillsOverDue[0].NO_OD_DAYS != ''){
                            newOpDetail.No_of_overdue_contract_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].BillsOverDue[0].NO_OD_DAYS);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].MBillsReceived != null && opsData.Ops_Data[0].MBillsReceived.size()>0){
                        if(opsData.Ops_Data[0].MBillsReceived[0].N_CONTRACTS != null && opsData.Ops_Data[0].MBillsReceived[0].N_CONTRACTS != ''){
                            newOpDetail.No_of_MBILL_MBIL_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].MBillsReceived[0].N_CONTRACTS);
                        }
                        if(opsData.Ops_Data[0].MBillsReceived[0].AMOUNT != null && opsData.Ops_Data[0].MBillsReceived[0].AMOUNT != null){
                            newOpDetail.Amount_of_MBILL_MBIL_FBN__c = Decimal.valueOf(opsData.Ops_Data[0].MBillsReceived[0].AMOUNT);
                        }
                    }
                    
                    if(opsData.Ops_Data[0].LC_BG_Avg_Util != null && opsData.Ops_Data[0].LC_BG_Avg_Util.size()>0){
                        if(opsData.Ops_Data[0].LC_BG_Avg_Util[0].NO_CONTRACTS != null && opsData.Ops_Data[0].LC_BG_Avg_Util[0].NO_CONTRACTS != ''){
                            newOpDetail.Average_Availment_ILC__c = Decimal.valueOf(opsData.Ops_Data[0].LC_BG_Avg_Util[0].NO_CONTRACTS);
                        }
                    }
                    
                    /*.....*/
                    if(acc[0].Id != null){
                        newOpDetail.Account__c=acc[0].Id;
                        newOpDetail.Bank_Type__c= 'KVB';
                    }
                    
                    String extID='';
                    if(opsData.FISCAL_YR =='LAST_12_MONTHS'){
                        Integer currentYear = Utility.getCurrentYear();
                        String cyString = String.valueOf(currentYear);
                        String currentFY = currentYear+'-'+Integer.valueOf(String.valueOf(currentYear+1).subString(String.valueOf(currentYear+1).length()-2,String.valueOf(currentYear+1).length()));
                        
                        newOpDetail.Fiscal_Type__c ='YTD';
                        newOpDetail.Fiscal_Year__c = currentFY;
                        extID=custId+'@'+newOpDetail.Fiscal_Year__c+'@'+newOpDetail.Fiscal_Type__c;
                        
                        List<Bank_Operations_Detail__c> existOpDetail=[Select ID,External_Id__c,Fiscal_Year__c,Fiscal_Type__c from Bank_Operations_Detail__c where External_Id__c=:extID limit 1];
                        if(existOpDetail.size()>0){
                            if(System.now().month()==Integer.ValueOf(System.Label.OperationalDataChangeMonth) && System.now().day()==Integer.valueOf(System.Label.OperationalDataChangeDate)){
                                existOpDetail[0].Fiscal_Type__c='Actual';
                                existOpDetail[0].External_Id__c='Bank'+custId+'@'+existOpDetail[0].Fiscal_Year__c+'@'+existOpDetail[0].Fiscal_Type__c;
                                updateExistOpDetail.add(existOpDetail[0]);
                            }else {
                                newOpDetail.id=existOpDetail[0].id;
                            }                   
                        }
                    }
                    else{
                        System.debug('Fyear 171 -->'+ opsData.FISCAL_YR);
                        List<String> fYear = opsData.FISCAL_YR.split('-');
                        newOpDetail.Fiscal_Type__c ='Actual';
                        newOpDetail.Fiscal_Year__c =fYear[0]+'-'+fYear[1].subString(2,4);
                        
                        extID='Bank'+custId+'@'+newOpDetail.Fiscal_Year__c+'@'+newOpDetail.Fiscal_Type__c;
                    }
                    
                    newOpDetail.External_Id__c=extID;
                    opsDataToInsertList.add(newOpDetail);
                    //UPSERT newOpDetail External_Id__c;
                    //if(updateExistOpDetail.size()>0)
                    //  update updateExistOpDetail;
                    //insertedOpsDataId.add(newOpDetail.Id);
                    
                    
                    /*Id CrRecordTypeId = Schema.SObjectType.NEFT_Debit_Credit__c.getRecordTypeInfosByName().get('Credit').getRecordTypeId();
                    Id DrRecordTypeId = Schema.SObjectType.NEFT_Debit_Credit__c.getRecordTypeInfosByName().get('Debit').getRecordTypeId();
                    if(opsData.Ops_Data[0].Top5CrSumParties!=null && opsData.Ops_Data[0].Top5CrSumParties.size()>0){
                        for(integer i=0;i<opsData.Ops_Data[0].Top5CrSumParties.size();i++){
                            NEFT_Debit_Credit__c neftCrDr=new NEFT_Debit_Credit__c();
                            //neftCrDr.Operations_Detail__c=newOpDetail.id;
                            neftCrDr.Operations_Detail__r = new Operations_Detail__c(External_Id__c = newOpDetail.External_Id__c);
                            neftCrDr.Type__c=opsData.Ops_Data[0].Top5CrSumParties[i].TYP;
                            neftCrDr.To_Account__c=opsData.Ops_Data[0].Top5CrSumParties[i].TO_ACC;
                            neftCrDr.From_Account__c=opsData.Ops_Data[0].Top5CrSumParties[i].FROM_ACC;
                            neftCrDr.Credit_Sum_Amount__c=Decimal.valueOf(opsData.Ops_Data[0].Top5CrSumParties[i].CR_AMT);
                            neftCrDr.Credit_Sum_Count__c=Decimal.valueOf(opsData.Ops_Data[0].Top5CrSumParties[i].CR_CNT);
                            neftCrDr.recordTypeID=CrRecordTypeId;
                            insertNeftCrDrList.add(neftCrDr);
                        }
                    }
                    if(opsData.Ops_Data[0].Top5DrSumParties!=null && opsData.Ops_Data[0].Top5DrSumParties.size()>0){
                        for(integer i=0;i<opsData.Ops_Data[0].Top5DrSumParties.size();i++){
                            NEFT_Debit_Credit__c neftCrDr=new NEFT_Debit_Credit__c();
                            //neftCrDr.Operations_Detail__c=newOpDetail.id;
                            neftCrDr.Operations_Detail__r = new Operations_Detail__c(External_Id__c = newOpDetail.External_Id__c);
                            neftCrDr.Type__c=opsData.Ops_Data[0].Top5DrSumParties[i].TYP;
                            neftCrDr.To_Account__c=opsData.Ops_Data[0].Top5DrSumParties[i].TO_ACC;
                            neftCrDr.From_Account__c=opsData.Ops_Data[0].Top5DrSumParties[i].FROM_ACC;
                            neftCrDr.DR_AMT__c=Decimal.valueOf(opsData.Ops_Data[0].Top5DrSumParties[i].DR_AMT);
                            neftCrDr.DR_CNT__c=Decimal.valueOf(opsData.Ops_Data[0].Top5DrSumParties[i].DR_CNT);
                            neftCrDr.recordTypeID=DrRecordTypeId;
                            insertNeftCrDrList.add(neftCrDr);
                        }
                    }*/
                    
                    if(insertNeftCrDrList.size()>0){
                        //insert insertNeftCrDrList;
                        //opsDetailCreditDebitMap.put(newOpDetail.id,insertNeftCrDrList);
                    }
                }
                catch(Exception e){
                    System.debug(e.getMessage());
                    System.debug(e.getLineNumber());
                    Database.rollback(sp);
                }
            }
            if(!opsDataToInsertList.isEmpty()){
                UPSERT opsDataToInsertList External_Id__c;
                for(Bank_Operations_Detail__c opsData : opsDataToInsertList){
                    insertedOpsDataId.add(opsData.Id);
                }
            }
            if(!updateExistOpDetail.isEmpty()){
                update updateExistOpDetail;
            }
            
            
            //delete existing NEFT credit/debit
            /*neftCrDrListToDelete=[Select id from NEFT_Debit_Credit__c where Operations_Detail__c IN :insertedOpsDataId];
            if(neftCrDrListToDelete.size()>0) delete neftCrDrListToDelete;
            if(insertNeftCrDrList.size()>0) INSERT insertNeftCrDrList;*/
            /*if(!opsDetailCreditDebitMap.isEmpty()){
        for(opsDetailCreditDebitMap.values()){//insertNeftCrDrList
        }
        }*/
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            errorDetail.put(opsDataReq.Customer_Id,e.getMessage());
            RETURN errorDetail;
        }
        RETURN null;
    }
}