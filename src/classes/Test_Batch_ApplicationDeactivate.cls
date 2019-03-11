//written by prashant singh
//code coverage:-76%
@istest
public class Test_Batch_ApplicationDeactivate {
    
    @testsetup
    public static void setupMethod()
    {
        
        String BranchCode = '1857';
        Boolean ReRun = false;
        Decimal PMAX1 = 29756.00;
        String checkCal = '3';
        Account acc=new Account(Name='testname');
        acc.Financial_Applicant__c=true;
        acc.Employment_Type__c='Salaried';
        acc.Agriculture2__c =  2000.44;
        acc.Annual_Share_of_Profit_Firm__c = 3434.34;
        acc.Rental2__c = 2344.45;
        acc.Pension_Income2__c = 7654.98;
        acc.Others_Income2__c = 2434.34;
        acc.Income_Computation_From__c = 'Bank Statement';
        acc.Salary_Credited_1__c = 2000.34;
        acc.Salary_Credited_2__c = 1000.99;
        acc.Salary_Credited_3__c = 0;
        
        insert acc;
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='LAP',Product_Code__c='776');
        insert product;

        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 8730000.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = 'Purchase of land and construction there on';
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
        	genApp.Sub_Stage__c='FI Approved';
        	genApp.Application_Stage__c='Saved Applications';
        	genApp.genesis__CL_Product__c=product.id;
        	//genApp.Created_Date__c=Date.parse('01/21/2019');
            insert genApp; 
        
         genesis__Applications__History hstry=new genesis__Applications__History();
        hstry.Field='Sub_Stage__c';
        hstry.parentId=genApp.id;
        
        insert hstry;
        


    }
    @istest
    public static void method1()
    {

        Batch_ApplicationDeactivate btch=new Batch_ApplicationDeactivate();
        Database.executeBatch(btch);
    }
        @istest
    public static void method2()
    {
        clcommon__CL_Product__c prod=[select id,Product_Code__c from clcommon__CL_Product__c];
        prod.Product_Code__c='774';
        update prod;

        
        Batch_ApplicationDeactivate btch=new Batch_ApplicationDeactivate();
        Database.executeBatch(btch);
    }
     @istest
    public static void method3()
    {
        String BranchCode = '1857';
        Boolean ReRun = false;
        Decimal PMAX1 = 29756.00;
        String checkCal = '3';
        Account acc=new Account(Name='testname');
        acc.Financial_Applicant__c=true;
        acc.Employment_Type__c='Salaried';
        acc.Agriculture2__c =  2000.44;
        acc.Annual_Share_of_Profit_Firm__c = 3434.34;
        acc.Rental2__c = 2344.45;
        acc.Pension_Income2__c = 7654.98;
        acc.Others_Income2__c = 2434.34;
        acc.Income_Computation_From__c = 'Bank Statement';
        acc.Salary_Credited_1__c = 2000.34;
        acc.Salary_Credited_2__c = 1000.99;
        acc.Salary_Credited_3__c = 0;
        
        insert acc;
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='LAP',Product_Code__c='776');
        //insert product;

        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 8730000.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = 'Purchase of land and construction there on';
            genApp.Cost_Of_Flat_House__c = 400000.00;
            genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
        	genApp.Sub_Stage__c='FI Approved';
        	genApp.Application_Stage__c='Saved Applications';
        	genApp.genesis__CL_Product__c=product.id;
        	
            insert genApp; 
        
             genesis__Applications__History hstry=new genesis__Applications__History();
            hstry.Field='Sub_Stage__c';
        hstry.parentId=genApp.id;
        
        insert hstry;
        
        Batch_ApplicationDeactivate btch=new Batch_ApplicationDeactivate();
       // Database.executeBatch(btch);
    }


}