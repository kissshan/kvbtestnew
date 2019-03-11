public class OperationDataCalculation_SME {
    public static void getScoreValue(String appId){
        Decimal currentRatio;
        Decimal workingCapitalTurnoverRatio;
        Decimal interestServiceCoverageRatio;
        Decimal averageLimitUtilization;
        Decimal delayInServicingOfWorkingCapitalInterest;
        decimal creditSummationComparedToPreviousYearSales;
        Decimal inwardChequeReturn;
        Integer noOfYearsOfOperation;
        Decimal successionPlan;
        Integer CIBIL_score;
        Integer DPD_Status;
        Expenses__c exp = new Expenses__c();
        OtherExpenses__c othExp = new OtherExpenses__c();
        M68_Balance_Sheet_Analysis__c m68cData = new M68_Balance_Sheet_Analysis__c();
        Integer currentYear = Utility.getCurrentYear();
        String cyString = String.valueOf(currentYear);
        String currentFY = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
        
        
        m68cData = [SELECT Net_sales__c,Id,Current_Ratio__c,Net_profit__c FROM M68_Balance_Sheet_Analysis__c WHERE Fiscal_Year__c = :currentFY];
        exp = [SELECT DepreciationAndAmortizationTotal__c,FinanceCostTotal__c FROM Expenses__c WHERE Profit_And_Loss__r.Perfios__r.Fiscal_Year__c = :currentFY];
        othExp = [SELECT IncomeTaxPaid__c FROM OtherExpenses__c WHERE Expenses__r.Profit_And_Loss__r.Perfios__r.Applicant_Name__r.CBS_Customer_ID__c = :appId];
        currentRatio = m68cData.Current_Ratio__c;
        //workingCapitalTurnoverRatio = m68cData.Net_sales__c / 
        interestServiceCoverageRatio = (m68cData.Net_profit__c+exp.FinanceCostTotal__c+othExp.IncomeTaxPaid__c+exp.DepreciationAndAmortizationTotal__c)/exp.FinanceCostTotal__c;
    }
}