@isTest
public class Test_perfiosCalculations {
    
    @isTest
    public static void method1(){
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='Test');
        insert product;
        Account acc = new Account(firstName='Niladri',LastName='Kundu');
        insert acc;
        
        genesis__Applications__c newApp = new genesis__Applications__c();
        newApp.genesis__Loan_Amount__c = 100000;
        newApp.genesis__Term__c =12;
        newApp.genesis__Amortization_Term__c = 12;
        newApp.genesis__Interest_Rate__c = 15;
        newApp.genesis__Payment_Frequency__c = 'Monthly';
        newApp.genesis__Account__c =acc.id;
        newApp.genesis__CL_Product__c = product.id;
        newApp.Sub_Stage__c = 'Disbursement Rejected';
        //newApp.Application_Stage__c = 'Sanction complete- Final Sanction';
        insert newApp;
        
        genesis__Application_Parties__c party =new genesis__Application_Parties__c();
        party.Key_Contact__c = acc.id;
        party.genesis__Party_Account_Name__c=acc.id;
        party.genesis__Party_Type__c = Constants.Co_Borrower;
        party.genesis__Application__c=newApp.id;
        party.Employment_Types__c='Salaried';
        party.NMI_as_per_ITR__c	=10000;
        party.ITR_Uploaded__c=true;
        party.NMI_as_per_BS__c=287877;
        party.NMI_as_per_26AS__c=77777;
        
        insert party;
        ITR_Response__c parobj=new ITR_Response__c();
        parobj.Account__c=acc.id;
        parobj.Application__c=newApp.id;
      /*  it.Agriculture_ITR2__c=200000;
        it.Year1__c='1';
        it.Agriculture_ITR1__c=50000;
        it.Agriculture_ITR3__c=92892;
        it.Annual_Agriculture_Income_ITR__c=278722;
        it.Annual_Capital_Gain1__c=28782;*/
        parobj.Estimated_Agriculture_ITR__c=27621;
        parobj.Estimated_Income_ITR__c=6766;
                     parobj.Year1__c ='2001';
                    parobj.Year2__c =  '2002';
                    parobj.Year3__c =  '2002';
                    parobj.Gross_Income1__c = 60000;
                    parobj.Annual_Tax1__c = 60000;
                    parobj.Gross_Income2__c = 60000;
                    parobj.Annual_Tax2__c = 60000;               
                	parobj.Gross_Income3__c = 60000;
                    parobj.Annual_Tax3__c = 60000;
                    parobj.Annual_Capital_Gain1__c = 60000;
                    parobj.Interest_Income1__c = 60000;
                    parobj.Dividend_Income1__c = 60000;
                    parobj.Annual_Capital_Gain2__c = 60000;
                    parobj.Interest_Income2__c = 60000;
                    parobj.Dividend_Income2__c = 60000;
                	parobj.Annual_Capital_Gain3__c = 60000;
                    parobj.Interest_income3__c =60000;
                    parobj.Dividend_income3__c =60000;
                    parobj.Agriculture_ITR1__c = 60000;
                    parobj.Agriculture_ITR2__c = 60000;
                    parobj.Agriculture_ITR3__c = 60000;
                    parobj.Share_of_Profit1__c = 60000;
                    parobj.Share_of_Profit2__c = 60000;
                    parobj.Share_of_Profit3__c = 60000;
                    parobj.Annual_Agriculture_Income_ITR__c = 60000;
                    parobj.Annual_Share_of_Profit_Firm_ITR__c =60000;
            
        insert  parobj;
        Test.startTest();
        Perfios__c pe=new Perfios__c(Application__c=newApp.id,	Applicant_Name__c=acc.id,Active__c=true,Bank_Name__c='testkvb');
        insert pe;
        Monthly_Detials_Perfios__c monpe=new Monthly_Detials_Perfios__c(Perfios__c=pe.id,Total_Salary__c=19000,Year__c='2009',Total_EMI_issue__c=66666,	Month_Name__c='Jan');
        insert monpe;
        Monthly_Detials_Perfios__c monpe2=new Monthly_Detials_Perfios__c(Perfios__c=pe.id,Total_Salary__c=18000,Year__c='2010',Total_EMI_issue__c=6578,   Month_Name__c='FEB');
        insert monpe2;
        Monthly_Detials_Perfios__c monpe3=new Monthly_Detials_Perfios__c(Perfios__c=pe.id,Total_Salary__c=19000,Year__c='2009',Total_EMI_issue__c=66666,	Month_Name__c='Jan');
        insert monpe3;
        Monthly_Detials_Perfios__c monpe4=new Monthly_Detials_Perfios__c(Perfios__c=pe.id,Total_Salary__c=18000,Year__c='2010',Total_EMI_issue__c=6578,   Month_Name__c='FEB');
        insert monpe4;
        Monthly_Detials_Perfios__c monpe5=new Monthly_Detials_Perfios__c(Perfios__c=pe.id,Total_Salary__c=19000,Year__c='2009',Total_EMI_issue__c=66666,	Month_Name__c='Jan');
        insert monpe5;
        Monthly_Detials_Perfios__c monpe6=new Monthly_Detials_Perfios__c(Perfios__c=pe.id,Total_Salary__c=18000,Year__c='2010',Total_EMI_issue__c=6578,   Month_Name__c='FEB');
        insert monpe6;
        perfiosCalculations.CalculateBS(acc.id,newApp.id);
        System.debug('pe'+pe);
        Test.stopTest();
        
    }
}