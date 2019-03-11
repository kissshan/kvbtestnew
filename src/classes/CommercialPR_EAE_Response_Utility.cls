/*
 * Name     : CommercialPR_EAE_Response_Utility
 * Company  : ET Marlabs
 * Purpose  : Utility class for CommercialPR_EAE_Response_Handler Class. 
 * Author   : Raushan
 */
public with sharing class CommercialPR_EAE_Response_Utility {
    //YourInstitution
    public static ints__TransUnion_Credit_Report__c getYourInstitution(Object obj, ints__TransUnion_Credit_Report__c transUnionObj) {
        CommercialPR_EAE_Response.YourInstitution yourInstitutionObj = (CommercialPR_EAE_Response.YourInstitution) obj;
        If(yourInstitutionObj != null){
                If(!Utility.ISStringBlankorNull(yourInstitutionObj.current)) {
                transUnionObj.Your_Institution_Current__c = yourInstitutionObj.current;
            }
            If(!Utility.ISStringBlankorNull(yourInstitutionObj.last24Months)) {
                transUnionObj.YourInstitution_Last24Months__c = yourInstitutionObj.last24Months;
                
            }
        }
        
        return transUnionObj; 
  }      
    //Outside Institution
    public static ints__TransUnion_Credit_Report__c getOutsideInstitution(Object obj, ints__TransUnion_Credit_Report__c transUnionObj) {
        CommercialPR_EAE_Response.YourInstitution yourInstitutionObj = (CommercialPR_EAE_Response.YourInstitution) obj;
        If(yourInstitutionObj != null) {
            If(!Utility.ISStringBlankorNull(yourInstitutionObj.current)) {
                transUnionObj.Outside_Current__c = yourInstitutionObj.current;
            }
            If(!Utility.ISStringBlankorNull(yourInstitutionObj.last24Months)) {
                transUnionObj.Outside_InstitutionLast24Months__c = yourInstitutionObj.last24Months;
            }
        }
        return transUnionObj;
    }
    //YourInstitution_Y
    public static Derogatory_Information__c getYourInstitution_Y(Object obj, Derogatory_Information__c derogatoryInformationObject) {
        CommercialPR_EAE_Response.YourInstitution_Y yourInstitutionObj = (CommercialPR_EAE_Response.YourInstitution_Y) obj;
        If(yourInstitutionObj != null) {
            If(!Utility.ISStringBlankorNull(yourInstitutionObj.wilfulDefault))
            derogatoryInformationObject.Wilful_Default__c = Integer.valueOf(yourInstitutionObj.wilfulDefault);

            derogatoryInformationObject = getSuitFilled(yourInstitutionObj.suitFilled, derogatoryInformationObject);
            derogatoryInformationObject = getwrittenOff(yourInstitutionObj.writtenOff, derogatoryInformationObject);
            derogatoryInformationObject = getSettled(yourInstitutionObj.settled, derogatoryInformationObject);
            derogatoryInformationObject = getInvoked(yourInstitutionObj.invoked, derogatoryInformationObject);
            derogatoryInformationObject = getOverdueCF(yourInstitutionObj.overdueCF, derogatoryInformationObject);

            If(!Utility.ISStringBlankorNull(yourInstitutionObj.dishonoredCheque))
            derogatoryInformationObject.Dishonored_Cheque__c = Integer.valueOf(yourInstitutionObj.dishonoredCheque);
        }
        return derogatoryInformationObject;
    }
    //SuitFilled
    public static Derogatory_Information__c getSuitFilled(Object obj, Derogatory_Information__c derogatoryInformationObject) {
        CommercialPR_EAE_Response.SuitFilled suitFilledObj = (CommercialPR_EAE_Response.SuitFilled) obj;
        If(suitFilledObj != null) {
            If(!Utility.ISStringBlankorNull(suitFilledObj.numberOfSuitFiled))
            derogatoryInformationObject.SuitFilled_Number_of_SuitFiled__c = Integer.valueOf(suitFilledObj.numberOfSuitFiled);
            If(!Utility.ISStringBlankorNull(suitFilledObj.amt))
            derogatoryInformationObject.SuitFilled_Amount__c = Decimal.valueOf(suitFilledObj.amt);
        }
        return derogatoryInformationObject;
    }
    //writtenOff
    public static Derogatory_Information__c getwrittenOff(Object obj, Derogatory_Information__c derogatoryInformationObject) {
        CommercialPR_EAE_Response.SuitFilled suitFilledObj = (CommercialPR_EAE_Response.SuitFilled) obj;
        If(suitFilledObj != null) {
            If(!Utility.ISStringBlankorNull(suitFilledObj.numberOfSuitFiled))
            derogatoryInformationObject.Writtenoff_number_of_SuitFiled__c = Integer.valueOf(suitFilledObj.numberOfSuitFiled);
            If(!Utility.ISStringBlankorNull(suitFilledObj.amt))
            derogatoryInformationObject.Writtenoff_Amount__c = Decimal.valueOf(suitFilledObj.amt);
        }
        return derogatoryInformationObject;
    }
    //settled
    public static Derogatory_Information__c getSettled(Object obj, Derogatory_Information__c derogatoryInformationObject) {
        CommercialPR_EAE_Response.SuitFilled suitFilledObj = (CommercialPR_EAE_Response.SuitFilled) obj;
        If(suitFilledObj != null) {
            If(!Utility.ISStringBlankorNull(suitFilledObj.numberOfSuitFiled))
            derogatoryInformationObject.Settled_Number_of_SuitFiled__c = Integer.valueOf(suitFilledObj.numberOfSuitFiled);
            If(!Utility.ISStringBlankorNull(suitFilledObj.amt))
            derogatoryInformationObject.Settled_Amount__c = Decimal.valueOf(suitFilledObj.amt);
        }
        return derogatoryInformationObject;
    }
    //invoked
    public static Derogatory_Information__c getInvoked(Object obj, Derogatory_Information__c derogatoryInformationObject) {
        CommercialPR_EAE_Response.SuitFilled suitFilledObj = (CommercialPR_EAE_Response.SuitFilled) obj;
        If(suitFilledObj != null) {
            If(!Utility.ISStringBlankorNull(suitFilledObj.numberOfSuitFiled))
            derogatoryInformationObject.Invoked_Number_of_SuitFiled__c = Integer.valueOf(suitFilledObj.numberOfSuitFiled);
            If(!Utility.ISStringBlankorNull(suitFilledObj.amt))
            derogatoryInformationObject.Invoked_Amount__c = Decimal.valueOf(suitFilledObj.amt);
        }
        return derogatoryInformationObject;
    }
    //overdueCF
    public static Derogatory_Information__c getOverdueCF(Object obj, Derogatory_Information__c derogatoryInformationObject) {
        CommercialPR_EAE_Response.SuitFilled suitFilledObj = (CommercialPR_EAE_Response.SuitFilled) obj;
        If(suitFilledObj != null) {
            If(!Utility.ISStringBlankorNull(suitFilledObj.numberOfSuitFiled))
            derogatoryInformationObject.OverdueCF_Number_of_SuitFiled__c = Integer.valueOf(suitFilledObj.numberOfSuitFiled);
            If(!Utility.ISStringBlankorNull(suitFilledObj.amt))
            derogatoryInformationObject.OverdueCF_Amount__c = Decimal.valueOf(suitFilledObj.amt);
        }
        return derogatoryInformationObject;
    }
    //NonFunded
    public static OustandingBalancebyCF__c getNonFunded(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.NonFunded nonFundedObj = (CommercialPR_EAE_Response.NonFunded) obj;
        If(nonFundedObj != null) {
            CommercialPR_EAE_Response.STDVec sTDVecObj = nonFundedObj.STDVec;
            If(sTDVecObj != null) {
                oustandingBalancebyCFObj = getDPD0(sTDVecObj.DPD0, oustandingBalancebyCFObj);
                oustandingBalancebyCFObj = getDPD1to30(sTDVecObj.DPD1to30, oustandingBalancebyCFObj);
                oustandingBalancebyCFObj = getDPD31to60(sTDVecObj.DPD31to60, oustandingBalancebyCFObj);
                oustandingBalancebyCFObj = getDPD61to90(sTDVecObj.DPD61to90, oustandingBalancebyCFObj);
            }
            CommercialPR_EAE_Response.NONSTDVec nONSTDVecObj = nonFundedObj.NONSTDVec;
            If(nONSTDVecObj != null) {
                oustandingBalancebyCFObj = getDPD91to180(nONSTDVecObj.DPD91to180, oustandingBalancebyCFObj);
                oustandingBalancebyCFObj = getgreaterthan180DPD(nONSTDVecObj.greaterthan180DPD, oustandingBalancebyCFObj);
                oustandingBalancebyCFObj = getsub(nONSTDVecObj.sub, oustandingBalancebyCFObj);
                oustandingBalancebyCFObj = getdbt(nONSTDVecObj.dbt, oustandingBalancebyCFObj);
                oustandingBalancebyCFObj = getloss(nONSTDVecObj.loss, oustandingBalancebyCFObj);
            }
            //total
            oustandingBalancebyCFObj = getTotal(nonFundedObj.total, oustandingBalancebyCFObj);
        }
        return oustandingBalancebyCFObj;
    }
    //DPD0
    public static OustandingBalancebyCF__c getDPD0(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.DPD0_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.DPD0_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //DPD1to30
    public static OustandingBalancebyCF__c getDPD1to30(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.DPD1to30_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.DPD1to30_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //DPD31to60
    public static OustandingBalancebyCF__c getDPD31to60(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.DPD31to60_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.DPD31to60_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //DPD61to90
    public static OustandingBalancebyCF__c getDPD61to90(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.DPD61to90_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.DPD61to90_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //DPD91to180
    public static OustandingBalancebyCF__c getDPD91to180(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.DPD91to180_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.DPD91to180_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //greaterthan180DPD
    public static OustandingBalancebyCF__c getgreaterthan180DPD(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.Greater_than_180_DPD_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.Greater_than180DPD_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //sub
    public static OustandingBalancebyCF__c getsub(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.Sub_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.Sub_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //dbt
    public static OustandingBalancebyCF__c getdbt(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.Dbt_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.Dbt_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //loss
    public static OustandingBalancebyCF__c getloss(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.Loss_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.Loss_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //Total
    public static OustandingBalancebyCF__c getTotal(Object obj, OustandingBalancebyCF__c oustandingBalancebyCFObj) {
        CommercialPR_EAE_Response.DPD0 DPD0Obj = (CommercialPR_EAE_Response.DPD0) obj;
        If(DPD0Obj != null) {
            If(!Utility.ISStringBlankorNull(DPD0Obj.count))
            oustandingBalancebyCFObj.Total_Count__c = Integer.valueOf(DPD0Obj.count);
            If(!Utility.ISStringBlankorNull(DPD0Obj.value))
            oustandingBalancebyCFObj.Total_Value__c = Integer.valueOf(DPD0Obj.value);
        }
        return oustandingBalancebyCFObj;
    }
    //TotalCF
    public static Credit_Profile__c getTotalCF(Object obj, Credit_Profile__c creditProfileObj) {
        CommercialPR_EAE_Response.TotalCF totalCFObj = (CommercialPR_EAE_Response.TotalCF) obj;
        If(totalCFObj != null) {
            If(!Utility.ISStringBlankorNull(totalCFObj.borrower))
            creditProfileObj.Borrower__c = Integer.valueOf(totalCFObj.borrower);
            If(!Utility.ISStringBlankorNull(totalCFObj.guarantor))
            creditProfileObj.Guaruntor__c = Integer.valueOf(totalCFObj.guarantor);
            If(!Utility.ISStringBlankorNull(totalCFObj.borrowerPercentage))
            creditProfileObj.TotalCF_Borrower_Percentage__c = totalCFObj.borrowerPercentage;
            If(!Utility.ISStringBlankorNull(totalCFObj.guarantorPercentage))
            creditProfileObj.TotalCF_Guarantor_Percentage__c = totalCFObj.guarantorPercentage;
            
        }
        return creditProfileObj;
    }
    //Deliquent CF
    public static Credit_Profile__c getDelinquentCF(Object obj, Credit_Profile__c creditProfileObj) {
        CommercialPR_EAE_Response.TotalCF totalCFObj = (CommercialPR_EAE_Response.TotalCF) obj;
        If(totalCFObj != null) {
            If(!Utility.ISStringBlankorNull(totalCFObj.borrower))
            creditProfileObj.Delinquent_CF_Borrower__c = Integer.valueOf(totalCFObj.borrower);
            If(!Utility.ISStringBlankorNull(totalCFObj.guarantor))
            creditProfileObj.Delinquent_CF_Guaruntor__c = Integer.valueOf(totalCFObj.guarantor);
            If(!Utility.ISStringBlankorNull(totalCFObj.borrowerPercentage))
            creditProfileObj.DeliquentCF_Borrower_Percentage__c = totalCFObj.borrowerPercentage;
            If(!Utility.ISStringBlankorNull(totalCFObj.guarantorPercentage))
            creditProfileObj.DeliquentCF_Guarantor_Percentage__c = totalCFObj.guarantorPercentage;
        }
        return creditProfileObj;
    }
    //TotalOutstanding
    public static Credit_Profile__c getTotalOutstanding(Object obj, Credit_Profile__c creditProfileObj) {
        CommercialPR_EAE_Response.TotalCF totalOutstandingObj = (CommercialPR_EAE_Response.TotalCF) obj;
        If(totalOutstandingObj != null) {
            If(!Utility.ISStringBlankorNull(totalOutstandingObj.borrower))
            creditProfileObj.Total_Outstanding_Borrower__c = Integer.valueOf(totalOutstandingObj.borrower);
            If(!Utility.ISStringBlankorNull(totalOutstandingObj.borrowerPercentage))
            creditProfileObj.Borrower_Percentage__c = totalOutstandingObj.borrowerPercentage;
            If(!Utility.ISStringBlankorNull(totalOutstandingObj.guarantor))
            creditProfileObj.Total_Outstanding_Guaruntor__c = Integer.valueOf(totalOutstandingObj.guarantor);
            If(!Utility.ISStringBlankorNull(totalOutstandingObj.guarantorPercentage))
            creditProfileObj.Guaruntor_Percentage__c = totalOutstandingObj.guarantorPercentage;
        }
        return creditProfileObj;
    }
    //Delinquent Outstanding
    public static Credit_Profile__c getDelinquentOutstanding(Object obj, Credit_Profile__c creditProfileObj) {
        CommercialPR_EAE_Response.TotalCF totalOutstandingObj = (CommercialPR_EAE_Response.TotalCF) obj;
        If(totalOutstandingObj != null) {
            If(!Utility.ISStringBlankorNull(totalOutstandingObj.borrower))
            creditProfileObj.Delinquent_Outstanding_CF_Borrower__c = Integer.valueOf(totalOutstandingObj.borrower);
            If(!Utility.ISStringBlankorNull(totalOutstandingObj.borrowerPercentage))
            creditProfileObj.Deliquent_Borrower_Percentage__c = totalOutstandingObj.borrowerPercentage;
            If(!Utility.ISStringBlankorNull(totalOutstandingObj.guarantor))
            creditProfileObj.Delinquent_Outstanding_CF_Guaruntor__c = Integer.valueOf(totalOutstandingObj.guarantor);
            If(!Utility.ISStringBlankorNull(totalOutstandingObj.guarantorPercentage))
            creditProfileObj.Deliquent_Guarantor_Percentage__c = totalOutstandingObj.guarantorPercentage;
        }
        return creditProfileObj;
    }
    //Total
    public static Credit_Profile__c getTotal(Object obj, Credit_Profile__c creditProfileObj) {
        CommercialPR_EAE_Response.Total totalObj = (CommercialPR_EAE_Response.Total) obj;
        If(totalObj != null) {
            If(!Utility.ISStringBlankorNull(totalObj.totalLenders))
            creditProfileObj.Total_Lender__c = Integer.valueOf(totalObj.totalLenders);
            If(!Utility.ISStringBlankorNull(totalObj.totalCF))
            creditProfileObj.Total_CF__c = Integer.valueOf(totalObj.totalCF);
            If(!Utility.ISStringBlankorNull(totalObj.openCF))
            creditProfileObj.Open_CF__c = Integer.valueOf(totalObj.openCF);
            If(!Utility.ISStringBlankorNull(totalObj.totalOutstanding))
            creditProfileObj.Total_Outstanding__c = Integer.valueOf(totalObj.totalOutstanding);
            If(!Utility.ISStringBlankorNull(totalObj.latestCFOpenedDate))
            creditProfileObj.Latest_Opened_CF_Date__c = totalObj.latestCFOpenedDate;
            If(!Utility.ISStringBlankorNull(totalObj.delinquentCF))
            creditProfileObj.Delinquent_CF__c = Integer.valueOf(totalObj.delinquentCF);
            If(!Utility.ISStringBlankorNull(totalObj.delinquentOutstanding))
            creditProfileObj.Delinquent_Outstanding__c = Integer.valueOf(totalObj.delinquentOutstanding);
        }
        return creditProfileObj;
    }
}