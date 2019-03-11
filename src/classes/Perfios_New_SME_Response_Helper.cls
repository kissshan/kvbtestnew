/*
* Name          : Perfios_New_SME_Response_Helper
* Description   : Helper class for Perfios_New_SME_Response_Handler. 
* Author        : Raushan Abhishek
*/
public class Perfios_New_SME_Response_Helper {
    
    public static Perfios_New_SME_Response_Helper.cls_Perfios_New_SME getSUMOfOperationalData(Perfios_New_SME_Response perfiosObjWrrp, Map<String,Operations_Detail__c> mapOfOperationalData){
        
        Operations_Detail__c	opdObject ;
        
        If(mapOfOperationalData ==null){
            opdObject	= new Operations_Detail__c();
        }else if(!mapOfOperationalData.containsKey('YTD')){
            opdObject	= new Operations_Detail__c();
        }else{
            opdObject =  mapOfOperationalData.get('YTD');
        }
        Perfios_New_SME_Response_Helper.cls_Perfios_New_SME  perfiosSMEWrrp;
        If(perfiosObjWrrp !=null){
            perfiosSMEWrrp  = new Perfios_New_SME_Response_Helper.cls_Perfios_New_SME();
            If(perfiosObjWrrp.summaryInfo !=null){
                Perfios_New_SME_Response.cls_SummaryInfo    summaryObjWrrp =    perfiosObjWrrp.summaryInfo;
                If(summaryObjWrrp !=null){
                    If(!Utility.ISStringBlankorNull(summaryObjWrrp.highestNonTechnicalBounce)){
                        If(opdObject.Maximum_Return_Amount__c !=null){
                            perfiosSMEWrrp.Max_inward_cheq_bounce = String.valueOf(opdObject.Maximum_Return_Amount__c + Decimal.valueOf(summaryObjWrrp.highestNonTechnicalBounce));    
                        }else{
                            perfiosSMEWrrp.Max_inward_cheq_bounce = summaryObjWrrp.highestNonTechnicalBounce;
                        }
                    }
                    If(!Utility.ISStringBlankorNull(summaryObjWrrp.lowestNonTechnicalBounce)){
                        If(opdObject.Minimum_Return_Amount__c !=null){
                            perfiosSMEWrrp.Min_inward_cheq_bounce = String.valueOf(opdObject.Minimum_Return_Amount__c + Decimal.valueOf(summaryObjWrrp.lowestNonTechnicalBounce));    
                        }else{
                            perfiosSMEWrrp.Min_inward_cheq_bounce = summaryObjWrrp.lowestNonTechnicalBounce;
                        } 
                    }
                    If(summaryObjWrrp.total !=null){
                        Perfios_New_SME_Response.cls_Total  totalObjWrrp    =    summaryObjWrrp.total;
                        If(totalObjWrrp !=null){
                            /*If(!Utility.ISStringBlankorNull(totalObjWrrp.intPayDelay)){
                                if(opdObject.Delay_in_interest_count_days__c !=null){
                                    if(opdObject.Sum_of_delay_in_interest_rate__c !=null && opdObject.Count_of_delay_rate_of_interest__c !=null && opdObject.Count_of_delay_rate_of_interest__c > 0){
                                    perfiosSMEWrrp.Delay_in_interest			 = String.valueOf((opdObject.Sum_of_delay_in_interest_rate__c + Decimal.valueOf(totalObjWrrp.intPayDelay)) / (opdObject.Count_of_delay_rate_of_interest__c +1));
                                    perfiosSMEWrrp.Sum_Of_Delay_in_interest	 	 = String.valueOf(opdObject.Sum_of_delay_in_interest_rate__c + Decimal.valueOf(totalObjWrrp.intPayDelay));
                                    perfiosSMEWrrp.Count_Of_Delay_in_interest 	 = String.valueOf(opdObject.Count_of_delay_rate_of_interest__c +1); 
                                
                                }else{
                                    perfiosSMEWrrp.Delay_in_interest			 = String.valueOf((opdObject.Delay_in_interest_count_days__c + Decimal.valueOf(totalObjWrrp.intPayDelay)) / 2);
                                    perfiosSMEWrrp.Sum_Of_Delay_in_interest	 	 = String.valueOf(opdObject.Delay_in_interest_count_days__c + Decimal.valueOf(totalObjWrrp.intPayDelay));
                                    perfiosSMEWrrp.Count_Of_Delay_in_interest 	 = String.valueOf(2);
                                }
                               }else {
                                    perfiosSMEWrrp.Delay_in_interest					=  totalObjWrrp.intPayDelay;
                                    perfiosSMEWrrp.Sum_Of_Delay_in_interest	 		= String.valueOf(Decimal.valueOf(totalObjWrrp.intPayDelay));
                                    perfiosSMEWrrp.Count_Of_Delay_in_interest 		= String.valueOf(1); 
                                }
                             } */
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.totalDebit)){
                                If(opdObject.FIN_DR_AMT__c !=null){
                                    perfiosSMEWrrp.Amount_of_debit_summation = String.valueOf(opdObject.FIN_DR_AMT__c + Decimal.valueOf(totalObjWrrp.totalDebit));
                                }else{
                                    perfiosSMEWrrp.Amount_of_debit_summation =  totalObjWrrp.totalDebit;
                                }
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.totalCredit)){
                                If(opdObject.FIN_CR_AMT__c !=null){
                                    perfiosSMEWrrp.Amount_of_credit_summation = String.valueOf(opdObject.FIN_CR_AMT__c + Decimal.valueOf(totalObjWrrp.totalCredit));
                                }else{
                                    perfiosSMEWrrp.Amount_of_credit_summation = totalObjWrrp.totalCredit;
                                }
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.debits)){
                                If(opdObject.FIN_DR_CNT__c !=null){
                                    perfiosSMEWrrp.No_of_debit_summation	= String.valueOf(opdObject.FIN_DR_CNT__c + Decimal.valueOf(totalObjWrrp.debits));
                                }else{
                                    perfiosSMEWrrp.No_of_debit_summation	=  totalObjWrrp.debits;
                                }
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.Credits)){
                                If(opdObject.FIN_CR_CNT__c !=null){
                                    perfiosSMEWrrp.No_of_credit_summation	= String.valueOf(opdObject.FIN_CR_CNT__c + Decimal.valueOf(totalObjWrrp.Credits));
                                }else{
                                    perfiosSMEWrrp.No_of_credit_summation  	= totalObjWrrp.Credits;
                                }
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.overdrawnInstances)){
                                If(opdObject.No_of_Exceedings__c !=null){
                                    perfiosSMEWrrp.No_of_exceedings	= String.valueOf(opdObject.No_of_Exceedings__c + Decimal.valueOf(totalObjWrrp.overdrawnInstances));
                                }else{
                                    perfiosSMEWrrp.No_of_exceedings = totalObjWrrp.overdrawnInstances;
                                } 
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.inwBounces)){
                                If(opdObject.Inward_check_return__c !=null){
                                    perfiosSMEWrrp.No_of_inward_cheq_return	= String.valueOf(opdObject.Inward_check_return__c + Decimal.valueOf(totalObjWrrp.inwBounces));
                                }else{
                                    perfiosSMEWrrp.No_of_inward_cheq_return = totalObjWrrp.inwBounces;
                                }
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.outwBounces)){
                                If(opdObject.Outward_check_return__c !=null){
                                    perfiosSMEWrrp.No_of_outward_clearing_chq_return	= String.valueOf(opdObject.Outward_check_return__c + Decimal.valueOf(totalObjWrrp.outwBounces));
                                }else{
                                    perfiosSMEWrrp.No_of_outward_clearing_chq_return 	= totalObjWrrp.outwBounces;
                                } 
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.cashDeposits)){
                                If(opdObject.Credit_cash_count__c !=null){
                                    perfiosSMEWrrp.No_of_cash_credit	= String.valueOf(opdObject.Credit_cash_count__c + Decimal.valueOf(totalObjWrrp.cashDeposits));
                                }else{
                                    perfiosSMEWrrp.No_of_cash_credit 	= totalObjWrrp.cashDeposits;
                                } 
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.totalCashWithdrawal)){
                                If(opdObject.DR_AMT__c !=null){
                                    perfiosSMEWrrp.Total_Cash_Withdrawal	= String.valueOf(opdObject.DR_AMT__c + Decimal.valueOf(totalObjWrrp.totalCashWithdrawal));
                                }else{
                                    perfiosSMEWrrp.Total_Cash_Withdrawal 	= totalObjWrrp.totalCashWithdrawal;
                                } 
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.totalCashDeposit)){
                                If(opdObject.Credit_Cash_Amount__c !=null){
                                    perfiosSMEWrrp.Amount_of_cash_credit	= String.valueOf(opdObject.Credit_Cash_Amount__c + Decimal.valueOf(totalObjWrrp.totalCashDeposit));
                                }else{
                                    perfiosSMEWrrp.Amount_of_cash_credit 	= totalObjWrrp.totalCashDeposit;
                                } 
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.cashWithdrawals)){
                                If(opdObject.DR_CNT__c !=null){
                                    perfiosSMEWrrp.No_of_cash_debot		= String.valueOf(opdObject.DR_CNT__c + Decimal.valueOf(totalObjWrrp.cashWithdrawals));
                                }else{
                                    perfiosSMEWrrp.No_of_cash_debot 	= totalObjWrrp.cashWithdrawals;
                                } 
                            }
                            If(!Utility.ISStringBlankorNull(totalObjWrrp.totalInterestIncome)){
                                If(opdObject.Intrest_Recieved_Amount__c !=null){
                                    perfiosSMEWrrp.Interest_earned		= String.valueOf(opdObject.Intrest_Recieved_Amount__c + Decimal.valueOf(totalObjWrrp.totalInterestIncome));
                                }else{
                                    perfiosSMEWrrp.Interest_earned 		= totalObjWrrp.totalInterestIncome;
                                } 
                            }
                        }
                        If(summaryObjWrrp.average !=null){
                            Perfios_New_SME_Response.cls_Average    averageObjWrrp  =    summaryObjWrrp.average;
                            If(!Utility.ISStringBlankorNull(averageObjWrrp.balAvg)){
                                If(opdObject.Availment_amount__c !=null){
                                    perfiosSMEWrrp.Average_availment		= String.valueOf(opdObject.Availment_amount__c + Decimal.valueOf(averageObjWrrp.balAvg));
                                }else{
                                    perfiosSMEWrrp.Average_availment 		= averageObjWrrp.balAvg;
                                } 
                            }
                        } 
                        //return perfiosSMEWrrp; 
                    } 
                }
            }
            If(perfiosObjWrrp.AdditionalSummaryDetails !=null){
                List<Perfios_New_SME_Response.cls_AdditionalSummaryDetails> listadditionalSummaryDetails = perfiosObjWrrp.AdditionalSummaryDetails;
                Decimal totalNumberOfTimes = 0;
                if(listadditionalSummaryDetails !=null && listadditionalSummaryDetails.size() > 0){
                    for(Perfios_New_SME_Response.cls_AdditionalSummaryDetails additionalSummaryObj : listadditionalSummaryDetails){
                        if(additionalSummaryObj !=null && additionalSummaryObj.noOfTimesInterestServiceBefore !=null && additionalSummaryObj.noOfTimesInterestServiceBefore !=''){
                            totalNumberOfTimes +=   Decimal.valueOf(additionalSummaryObj.noOfTimesInterestServiceBefore); 
                        }    
                    }
                    if(totalNumberOfTimes > 0){
                        if(opdObject.Delay_in_interest_count_days__c !=null){
                            if(opdObject.Sum_of_delay_in_interest_rate__c !=null && opdObject.Count_of_delay_rate_of_interest__c !=null && opdObject.Count_of_delay_rate_of_interest__c > 0){
                                perfiosSMEWrrp.Delay_in_interest			 = String.valueOf((opdObject.Sum_of_delay_in_interest_rate__c + totalNumberOfTimes) / (opdObject.Count_of_delay_rate_of_interest__c +1));
                                perfiosSMEWrrp.Sum_Of_Delay_in_interest	 	 = String.valueOf(opdObject.Sum_of_delay_in_interest_rate__c + totalNumberOfTimes);
                                perfiosSMEWrrp.Count_Of_Delay_in_interest 	 = String.valueOf(opdObject.Count_of_delay_rate_of_interest__c +1); 
                                
                            }else{
                                perfiosSMEWrrp.Delay_in_interest			 = String.valueOf((opdObject.Delay_in_interest_count_days__c + totalNumberOfTimes) / 2);
                                perfiosSMEWrrp.Sum_Of_Delay_in_interest	 	 = String.valueOf(opdObject.Delay_in_interest_count_days__c + totalNumberOfTimes);
                                perfiosSMEWrrp.Count_Of_Delay_in_interest 	 = String.valueOf(2);
                            }
                        }else {
                            perfiosSMEWrrp.Delay_in_interest				= String.valueOf(totalNumberOfTimes);
                            perfiosSMEWrrp.Sum_Of_Delay_in_interest	 		= String.valueOf(totalNumberOfTimes);
                            perfiosSMEWrrp.Count_Of_Delay_in_interest 		= String.valueOf(1); 
                        }
                    }
                }
            }
        }
        return perfiosSMEWrrp; 
    }
    
    public class cls_Perfios_New_SME {
        
        public String No_of_credit_cash_count;
        public String No_of_inward_cheq_return;
        public String Average_availment;
        public String Delay_in_interest;
        public String Max_inward_cheq_bounce;
        public String Min_inward_cheq_bounce;
        public String Amount_of_cash_credit;
        public String No_of_debit_summation;
        public String Amount_of_debit_summation;
        public String Amount_of_credit_summation;
        public String No_of_credit_summation;
        public String No_of_cash_debot;
        public String No_of_cash_credit;
        public String No_of_exceedings;
        public String No_of_overdue_expeort;
        public String Amount_of_overdue_export;
        public String Max_amount_of_overdue;
        public String Min_FBLS_amt;
        public String Interest_earned;
        public String No_of_time_sservice_charges_collected;
        public String Amount_of_service_charge;
        public String No_of_time_exceeded;
        public String Interest_earned_from_exceeding;
        public String No_of_outward_clearing_chq_return;
        public String Average_days_of_exceeding;
        public String Total_Cash_Withdrawal;
        public String Sum_Of_Delay_in_interest;
        public String Count_Of_Delay_in_interest;
        
    }
    
}