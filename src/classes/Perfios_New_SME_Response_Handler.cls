/*
* Name          : Perfios_New_SME_Response_Handler
* Description   : Handler class for Perfios_New_SME_Response. 
* Author        : Raushan Abhishek
*/
public class Perfios_New_SME_Response_Handler {
    public static String BANK_NAME	= '';
    
    public static Map<String,List<Operations_Detail__c>> getPerfiosData(Perfios_New_SME_Response  perfiosObjWrrp, String accountId){
        boolean opbankDetailsExist=false;
        Integer currentYear = Utility.getCurrentYear();
        String cyString = String.valueOf(currentYear);
        String currFiscalYear = (currentYear - 1) + '-' + Integer.valueOf(cyString.subString(cyString.length() - 2, cyString.length()));
        String nextEstFiscalYear = currentYear + '-' + Integer.valueOf(String.valueOf(currentYear + 1).subString(String.valueOf(currentYear + 1).length() - 2, String.valueOf(currentYear + 1).length()));
        List<Operations_Detail__c> listOfOperation		=	new List<Operations_Detail__c>();
        List<Operations_Detail__c> updateOperation		=	new List<Operations_Detail__c>();
        Operations_Detail__c    opdObject   			=   new Operations_Detail__c();
        Operations_Detail__c    opdInstObject   		=   new Operations_Detail__c();
        Operations_Detail__c    opdYTDUpdateObject   	=   new Operations_Detail__c();
        Operations_Detail__c    opdActualUpdateObject   =   new Operations_Detail__c();
        
        String YTD										=	'YTD';
        String ACTUAL									=	'Actual';
        Map<String,List<Operations_Detail__c>> mapOfOperationalReturn = new Map<String,List<Operations_Detail__c>>();
        Map<String,Operations_Detail__c> mapOfOperationalData = new Map<String,Operations_Detail__c>();
        
        If(perfiosObjWrrp !=null && accountId !=null){
            List<String> listOfString = new List<String>{};
                Map<String, Schema.SObjectField> operationalFieldMap = Schema.getGlobalDescribe().get('Operations_Detail__c').getDescribe().fields.getMap();
            String query = 'SELECT '; 
            for(Schema.SObjectField s : operationalFieldMap.values()){
                query = query + s.getDescribe().getName()+',';    
            }
            query = query.removeEnd(',') + ' from Operations_Detail__c where Account__c =: accountId';
            
            List<Operations_Detail__c> listOfOperationForCal = Database.query(query);
            
            If(listOfOperationForCal !=null){
                for(Operations_Detail__c opdObj : listOfOperationForCal)  {
                    If(opdObj.Fiscal_Type__c == YTD && opdObj.Fiscal_Year__c == nextEstFiscalYear){
                        mapOfOperationalData.put(YTD,opdObj);
                    }else if(opdObj.Fiscal_Type__c == ACTUAL && opdObj.Fiscal_Year__c == currFiscalYear){
                        mapOfOperationalData.put(ACTUAL,opdObj);
                    }
                }
            }
            If(perfiosObjWrrp.customerInfo != null){
                Perfios_New_SME_Response.cls_CustomerInfo    customerObjWrrp =    perfiosObjWrrp.customerInfo;
                Perfios_New_SME_Response.cls_SummaryInfo summaryInfoWrp= perfiosObjWrrp.summaryInfo;
                if(summaryInfoWrp.accNo!= null && summaryInfoWrp.accNo!= '' && accountId!=null){
                    opbankDetailsExist= TermLoan_SOQL_Util.bankDataExist(summaryInfoWrp.accNo,accountId);
                }
                If(customerObjWrrp.name !=null && customerObjWrrp.name !=''){
                    BANK_NAME	=  customerObjWrrp.name;   
                } 
            }
            if(opbankDetailsExist== false){
                Perfios_New_SME_Response_Helper.cls_Perfios_New_SME   perfiosNewWrrpObj    = Perfios_New_SME_Response_Helper.getSUMOfOperationalData(perfiosObjWrrp, mapOfOperationalData);
                If(perfiosNewWrrpObj !=null){
                    opdObject.Account__c                    =   (Id)accountId;
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Max_inward_cheq_bounce))
                        opdObject.Maximum_Return_Amount__c =  Decimal.valueOf(perfiosNewWrrpObj.Max_inward_cheq_bounce);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Min_inward_cheq_bounce))
                        opdObject.Minimum_Return_Amount__c =  Decimal.valueOf(perfiosNewWrrpObj.Min_inward_cheq_bounce);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Delay_in_interest))
                        opdObject.Delay_in_interest_count_days__c =  Decimal.valueOf(perfiosNewWrrpObj.Delay_in_interest);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Amount_of_debit_summation))
                        opdObject.FIN_DR_AMT__c =  Decimal.valueOf(perfiosNewWrrpObj.Amount_of_debit_summation);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Amount_of_credit_summation))
                        opdObject.FIN_CR_AMT__c =  Decimal.valueOf(perfiosNewWrrpObj.Amount_of_credit_summation);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.No_of_debit_summation))
                        opdObject.FIN_DR_CNT__c =  Decimal.valueOf(perfiosNewWrrpObj.No_of_debit_summation);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.No_of_credit_summation))
                        opdObject.FIN_CR_CNT__c =  Decimal.valueOf(perfiosNewWrrpObj.No_of_credit_summation);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.No_of_exceedings))
                        opdObject.No_of_Exceedings__c =  Decimal.valueOf(perfiosNewWrrpObj.No_of_exceedings);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.No_of_inward_cheq_return))
                        opdObject.Inward_check_return__c =  Decimal.valueOf(perfiosNewWrrpObj.No_of_inward_cheq_return);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.No_of_outward_clearing_chq_return))
                        opdObject.Outward_check_return__c =  Decimal.valueOf(perfiosNewWrrpObj.No_of_outward_clearing_chq_return);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.No_of_cash_credit))
                        opdObject.Credit_cash_count__c =  Decimal.valueOf(perfiosNewWrrpObj.No_of_cash_credit);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Total_Cash_Withdrawal))
                        opdObject.DR_AMT__c =  Decimal.valueOf(perfiosNewWrrpObj.Total_Cash_Withdrawal);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Amount_of_cash_credit))
                        opdObject.Credit_Cash_Amount__c =  Decimal.valueOf(perfiosNewWrrpObj.Amount_of_cash_credit);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.No_of_cash_debot))
                        opdObject.DR_CNT__c =  Decimal.valueOf(perfiosNewWrrpObj.No_of_cash_debot);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Interest_earned))
                        opdObject.Intrest_Recieved_Amount__c =  Decimal.valueOf(perfiosNewWrrpObj.Interest_earned);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Average_availment))
                        opdObject.Availment_amount__c =  Decimal.valueOf(perfiosNewWrrpObj.Average_availment);
                    
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Sum_Of_Delay_in_interest))
                        opdObject.Sum_of_delay_in_interest_rate__c   =  Decimal.valueOf(perfiosNewWrrpObj.Sum_Of_Delay_in_interest);
                    If(!Utility.ISStringBlankorNull(perfiosNewWrrpObj.Count_Of_Delay_in_interest))
                        opdObject.Count_of_delay_rate_of_interest__c =  Decimal.valueOf(perfiosNewWrrpObj.Count_Of_Delay_in_interest);
                    
                    If(mapOfOperationalData !=null && mapOfOperationalData.size()>0){
                        If(mapOfOperationalData.containsKey(YTD)){
                            opdYTDUpdateObject  = opdObject;
                            opdYTDUpdateObject.Id = mapOfOperationalData.get(YTD).Id;
                            opdYTDUpdateObject.Fiscal_Type__c = YTD;
                            updateOperation.add(opdYTDUpdateObject);
                            
                        }
                        If(mapOfOperationalData.containsKey(ACTUAL)){
                            opdActualUpdateObject   = opdObject.clone(false, false, false, false);
                            opdActualUpdateObject.Id = mapOfOperationalData.get(ACTUAL).Id;
                            opdActualUpdateObject.Fiscal_Type__c = ACTUAL;
                            updateOperation.add(opdActualUpdateObject);
                            
                        }
                        if(!mapOfOperationalData.containsKey(YTD)){
                            if(nextEstFiscalYear !=null){
                                opdInstObject    =  opdObject;
                                opdInstObject.Id  = null;
                                opdInstObject.Fiscal_Year__c = nextEstFiscalYear;
                                opdInstObject.Fiscal_Type__c = YTD;
                                listOfOperation.add(opdInstObject); 
                            }  
                        }else if(!mapOfOperationalData.containsKey(ACTUAL)){
                            opdInstObject    =  opdObject;
                            opdInstObject.Id = null;
                            opdInstObject.Fiscal_Year__c = currFiscalYear;
                            opdInstObject.Fiscal_Type__c = ACTUAL;
                            listOfOperation.add(opdInstObject); 
                        }
                    }else{
                        if(currFiscalYear !=null){
                            opdObject.Fiscal_Year__c = currFiscalYear;
                            opdObject.Fiscal_Type__c = ACTUAL;
                            listOfOperation.add(opdObject);
                        }
                        if(nextEstFiscalYear !=null){
                            opdInstObject   =   opdObject.clone(false,false,false,false);
                            opdInstObject.Fiscal_Year__c = nextEstFiscalYear;
                            opdInstObject.Fiscal_Type__c = YTD;
                            listOfOperation.add(opdInstObject);
                        }   
                    }
                }

            }
            
        }
        If(listOfOperation.size() > 0){
            mapOfOperationalReturn.put('Insert',listOfOperation);
        }
        If(updateOperation.size() > 0){
            mapOfOperationalReturn.put('Update',updateOperation);
        }
        If(mapOfOperationalReturn.size() >0){
            return mapOfOperationalReturn;
        }
        return new Map<String,List<Operations_Detail__c>>(); 
    }

    public static void insertPerfiosdata(Perfios_New_SME_Response  perfiosObjWrrp, String accId){
        try{
            if(perfiosObjWrrp!= null){
                List<Bank_Operations_Detail__c> existBankOpDetl;
                Perfios_New_SME_Response.cls_CustomerInfo customerInfoObjwrp= perfiosObjWrrp.customerInfo;
                Perfios_New_SME_Response.cls_SummaryInfo    summaryObjWrrp =    perfiosObjWrrp.summaryInfo;
                String ExtrnlId= accId+'@@'+summaryObjWrrp.accNo+'@@'+customerInfoObjwrp.perfiosTransactionId;
                if(ExtrnlId!=null){
                    existBankOpDetl= [select id from Bank_Operations_Detail__c where External_Id__c=: ExtrnlId];
                }
                Bank_Operations_Detail__c bankOpData= new Bank_Operations_Detail__c();
                if(summaryObjWrrp!= null){
                    bankOpData.Maximum_Return_Amount__c= summaryObjWrrp.highestNonTechnicalBounce!= null ? Decimal.valueOf(summaryObjWrrp.highestNonTechnicalBounce):0;
                    bankOpData.Maximum_Return_Amount__c= summaryObjWrrp.lowestNonTechnicalBounce!= null ? Decimal.valueOf(summaryObjWrrp.lowestNonTechnicalBounce): 0;
                    bankOpData.Bank_Account_No__c= summaryObjWrrp.accNo;
                    bankOpData.Bank_Account_Type__c= summaryObjWrrp.accType;
                    bankOpData.Bank_Name__c= summaryObjWrrp.instName;
                    if(summaryObjWrrp.total!=null){
                        Perfios_New_SME_Response.cls_Total  totalObjWrrp    =    summaryObjWrrp.total;
                        if(totalObjWrrp!= null){
                            bankOpData.FIN_DR_AMT__c= totalObjWrrp.totalDebit!=null ? Decimal.valueOf(totalObjWrrp.totalDebit):0;
                            bankOpData.FIN_CR_AMT__c= totalObjWrrp.totalCredit!=null ? Decimal.valueOf(totalObjWrrp.totalCredit):0;
                            bankOpData.FIN_DR_CNT__c= totalObjWrrp.debits!=null ? Decimal.valueOf(totalObjWrrp.debits):0;
                            bankOpData.FIN_CR_CNT__c= totalObjWrrp.Credits!=null ? Decimal.valueOf(totalObjWrrp.Credits):0;
                            bankOpData.No_of_Exceedings__c= totalObjWrrp.overdrawnInstances!=null ? Decimal.valueOf(totalObjWrrp.overdrawnInstances):0;
                            bankOpData.Inward_check_return__c= totalObjWrrp.inwBounces!=null ? Decimal.valueOf(totalObjWrrp.inwBounces):0;
                            bankOpData.Outward_check_return__c= totalObjWrrp.outwBounces!=null ? Decimal.valueOf(totalObjWrrp.outwBounces):0;
                            bankOpData.Credit_cash_count__c= totalObjWrrp.cashDeposits!=null ? Decimal.valueOf(totalObjWrrp.cashDeposits):0;
                            bankOpData.DR_AMT__c= totalObjWrrp.totalCashWithdrawal!=null ? Decimal.valueOf(totalObjWrrp.totalCashWithdrawal):0;
                            bankOpData.Credit_Cash_Amount__c= totalObjWrrp.totalCashDeposit!=null ? Decimal.valueOf(totalObjWrrp.totalCashDeposit):0;
                            bankOpData.DR_CNT__c= totalObjWrrp.cashWithdrawals!=null ? Decimal.valueOf(totalObjWrrp.cashWithdrawals):0;
                            bankOpData.Intrest_Recieved_Amount__c= totalObjWrrp.totalInterestIncome!=null ? Decimal.valueOf(totalObjWrrp.totalInterestIncome):0;
                        }
                        
                    }
                    if(summaryObjWrrp.average !=null){
                        Perfios_New_SME_Response.cls_Average    averageObjWrrp= summaryObjWrrp.average;
                        bankOpData.Availment_amount__c= averageObjWrrp.balAvg!=null ? Decimal.valueOf(averageObjWrrp.balAvg):0;
                    }
                    
                }
                if(perfiosObjWrrp.AdditionalSummaryDetails !=null){
                    List<Perfios_New_SME_Response.cls_AdditionalSummaryDetails> listadditionalSummaryDetails = perfiosObjWrrp.AdditionalSummaryDetails;
                    Decimal totalNumberOfTimes = 0;
                    if(listadditionalSummaryDetails !=null && listadditionalSummaryDetails.size() > 0){
                        for(Perfios_New_SME_Response.cls_AdditionalSummaryDetails additionalSummaryObj : listadditionalSummaryDetails){
                            if(additionalSummaryObj !=null && additionalSummaryObj.noOfTimesInterestServiceBefore !=null && additionalSummaryObj.noOfTimesInterestServiceBefore !=''){
                                totalNumberOfTimes +=   Decimal.valueOf(additionalSummaryObj.noOfTimesInterestServiceBefore); 
                            }    
                        }
                        if(totalNumberOfTimes > 0){
                            bankOpData.Delay_in_interest_count_days__c= totalNumberOfTimes;
                            bankOpData.Sum_of_delay_in_interest_rate__c= totalNumberOfTimes;
                            bankOpData.Count_of_delay_rate_of_interest__c= 1;
                        }
                    }
                }
                if(bankOpData!=null){
                    bankOpData.Account__c= accId;
                    bankOpData.Bank_Type__c= 'Non KVB';
                    if(existBankOpDetl.size()>0){
                        bankOpData.id= existBankOpDetl[0].Id;
                    }else{
                        bankOpData.External_Id__c= ExtrnlId;
                    }
                    
                    upsert bankOpData;
                }
            }

        }catch(Exception ex){
            system.debug('Line Number====> '+ex.getLineNumber());
            system.debug('Message=====>'+ex.getMessage());
        }
        
        

    }
    
}