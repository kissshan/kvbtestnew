@isTest
public class Test_OperationDataCalculation_SME {
    @isTest
    public static void method1(){
        genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
        Integer currentYear = Utility.getCurrentYear();
        String cyString = String.valueOf(currentYear);
        String currentFY = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length()));
        M68_Balance_Sheet_Analysis__c mobj=new M68_Balance_Sheet_Analysis__c();
        mobj.Net_sales__c=700;
        mobj.Net_profit__c=8999;
        mobj.Fiscal_Year__c=currentFY;
        System.debug('mobj'+mobj);
        insert mobj;
        System.debug('**Current_Ratio__c'+mobj.Current_Ratio__c);
        
        Perfios__c per = new Perfios__c();
        per.Fiscal_Year__c = currentFY;
        INSERT per;
        
        ProfitAndLoss__c proLoss = new ProfitAndLoss__c();
        proLoss.Perfios__c = per.Id;
        INSERT proLoss;
        
        Expenses__c expn = new Expenses__c();
        expn.DepreciationAndAmortizationTotal__c = 1000;
        expn.FinanceCostTotal__c = 2000;
        expn.Profit_And_Loss__c = proLoss.Id;
        INSERT expn;
        
        Account acc = new Account(name='testName');
        acc.CBS_Customer_ID__c = 'appid';
        INSERT acc;
        
        // Applicant_Name__c appl = new Applicant_Name__c();
        // INSERT appl;
        
        Perfios__c perf = new Perfios__c();
        perf.Applicant_Name__c = acc.id;
        INSERT perf;
        
        ProfitAndLoss__c profLoss = new ProfitAndLoss__c();
        profLoss.Perfios__c = perf.Id;
        INSERT profLoss;
        
        Expenses__c exp = new Expenses__c();
        exp.Profit_And_Loss__c = profLoss.id;
        INSERT exp;
        
        OtherExpenses__c othrExpn = new OtherExpenses__c(); 
        othrExpn.IncomeTaxPaid__c = 500;
        othrExpn.Expenses__c = exp.Id;
        INSERT othrExpn;
        
        
        OperationDataCalculation_SME.getScoreValue('appid');
    }
}