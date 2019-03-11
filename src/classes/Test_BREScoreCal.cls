//written by prashant singh
//code coverage=76%

@isTest
public class Test_BREScoreCal {
  
    @testsetup
    public static void testsetup(){
        try{        
            Trigger_Setting__c cuslabel=new Trigger_Setting__c();
            cuslabel.Execute_Application_Trigger__c=true;
            insert cuslabel;
            genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
            
            clcommon__Collateral__c collat=new clcommon__Collateral__c();
            collat.Collateral_Uses__c='Residential';
            collat.clcommon__Collateral_Name__c='kk';
            collat.active__c=true;
                
            collat.genesis__Application__c=app.id;
            insert collat;  
            
            list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([select id,Employment_Types__c,CIBIL_Scores__c from genesis__Application_Parties__c where (genesis__Party_Type__c =: Constants.Co_Borrower OR genesis__Party_Type__c=:Constants.PRIMARY_APP) ]);
            System.debug('party'+party);
            if(party.size()>0){
                party[0].genesis__Application__c=app.id;
                party[0].CIBIL_Scores__c=750.00;
                party[0].Employment_Types__c='Agriculturist';
                party[0].Active__c=true;
                party[0].Financial_Applicant__c=true;          
                party[0].Additional_Income__c=1000000;
                party[0].Total_ChequeECS_bounces__c=1000.20;
                party[0].Average_Balances_6_months__c=10000.00;
                party[0].Net_Monthly_Income__c=1000.00;
                party[0].Perfios_Captured__c=true;
                party[0].Agriculture2__c=100000.00;
                
                party[0].Gross_Income1__c=1000000.00;
                party[0].Gross_Income2__c=100000000.00;
                
                
                party[0].Salary_Credited_1__c=1000.00;
                party[0].Salary_Credited_2__c=10000000.00;
                party[0].Salary_Credited_3__c=19920.00;
                
                party[0].Annual_Tax2__c=100000000000.00;
                
                party[0].Interest_Income1__c=12322;
                party[0].Interest_Income2__c=2000.00;
                
                party[0].Dividend_Income1__c=132.00;
                party[0].Dividend_Income2__c=200.00;
                
                party[0].Share_of_Profit_1__c=123.00;
                party[0].Share_of_Profit_2__c=2000.00;
                
                party[0].Agriculture_ITR1__c=3242.00;
                party[0].Agriculture_ITR2__c=100000.00;
                
                party[0].Additional_Income_Amount1__c=124323.00;
                party[0].Additional_Income_Amount2__c=124323.00;
                party[0].Additional_Income_Amount3__c=124323.00;
                party[0].Additional_Income_Amount4__c=124323.00;
                party[0].Additional_Income_Amount5__c=124323.00;
                party[0].Annual_Share_of_Profit_Firm__c=7432.00;
                party[0].Rental2__c=889.00;
                party[0].Pension_Income2__c=1234323.00;
                party[0].Others_Income2__c=3241.00;
                party[0].Approved_NMI_LAP__c=2345.00;
                party[0].Income_Computation_From__c='ITR';
                party[0].Annual_Capital_Gain1__c=2345;
                party[0].Annual_Capital_Gain2__c=3234344;
                party[0].Annual_Tax1__c=12.00;
                //party[0].Employment_Types__c='Salaried';
                party[0].Annual_Other_IncomeRecurring_CreditsITR__c=232.00;
                party[0].Estimated_Business_Income__c=2421112311333.00;
                party[0].Amount_Paid__c=3131.00;
                party[0].Tax_Deducted__c=13133;
                party[0].Active__c=true;
                party[0].Company__c=false;
                
                update party[0];
                
                Branch_Master__c brmas=new Branch_Master__c();
                brmas.CODCCBRN__c='1858';
                brmas.Retail_Category__c='A';
                brmas.NAMCCCITY__c='CHENNAI';
                brmas.State__c='TAMIL NADU';
                insert brmas;

                MCLR_Excess_Code__c mclrExcess=new MCLR_Excess_Code__c();
                mclrExcess.Employment_Type__c='Salaried';
                mclrExcess.Excess__c=7;
                mclrExcess.From_CIBIL__c=750;
                mclrExcess.Product_Name__c=Constants.LAPLOAN;
                mclrExcess.Retail_Category__c=brmas.Retail_Category__c ;
                mclrExcess.TO_CIBIL__c=800;
                mclrExcess.Name='Excess1';
                insert mclrExcess;
                
                MCLR_Excess_Code__c mclrExcess1=new MCLR_Excess_Code__c();
                mclrExcess1.Employment_Type__c='Salaried';
                mclrExcess1.Excess__c=5;
                mclrExcess1.From_CIBIL__c=750;
                mclrExcess1.Product_Name__c=Constants.HOMELOAN;
                mclrExcess1.Retail_Category__c=brmas.Retail_Category__c ;
                mclrExcess1.TO_CIBIL__c=800;
                mclrExcess1.Name='Excess2';
                insert mclrExcess1;

                MCLR_Excess_Code__c mclrExcess2=new MCLR_Excess_Code__c();
                mclrExcess2.Employment_Type__c='Salaried';
                mclrExcess2.Excess__c=6;
                mclrExcess2.From_CIBIL__c=700;
                mclrExcess2.Product_Name__c=Constants.HOMELOAN;
                mclrExcess2.Retail_Category__c=brmas.Retail_Category__c ;
                mclrExcess2.TO_CIBIL__c=800;
                mclrExcess2.Name='Excess3';
                insert mclrExcess2;

                MCLR_Excess_Code__c mclrExcess3=new MCLR_Excess_Code__c();
                mclrExcess3.Employment_Type__c='Salaried';
                mclrExcess3.Excess__c=6;         
                mclrExcess3.From_CIBIL__c=650;
                mclrExcess3.Product_Name__c=Constants.HOMELOAN;
                mclrExcess3.Retail_Category__c=brmas.Retail_Category__c ;
                mclrExcess3.TO_CIBIL__c=800;
                mclrExcess3.Name='Excess4';
                insert mclrExcess3;

                MCLR_Excess_Code__c mclrExcess4=new MCLR_Excess_Code__c();
                mclrExcess4.Employment_Type__c='Salaried';
                mclrExcess4.Excess__c=6;
                mclrExcess4.From_CIBIL__c=-1;
                mclrExcess4.Product_Name__c=Constants.HOMELOAN;
                mclrExcess4.Retail_Category__c=brmas.Retail_Category__c ;
                mclrExcess4.TO_CIBIL__c=800;
                mclrExcess4.Name='Excess5';
                insert mclrExcess4;

                MCLR_Master__c mclrmstr=new MCLR_Master__c();
                mclrmstr.MCLR_Of_Interest__c=12.20;       
                mclrmstr.COD_Term_From__c=90;
                insert mclrmstr; 

                MCLR_Master__c mclrmstr1=new MCLR_Master__c();
                mclrmstr1.MCLR_Of_Interest__c=12;       
                mclrmstr1.COD_Term_From__c=365;
                insert mclrmstr1;

                MCLR_Master__c mclrmstr2=new MCLR_Master__c();
                mclrmstr2.MCLR_Of_Interest__c=12;
                mclrmstr2.COD_Term_From__c=30;
                insert mclrmstr2;
                   
                account ac=[select id from account limit 1] ;
                    
                Perfios__c per=new Perfios__c();
                per.Active__c=true;
                per.Application__c=app.id;
                per.Cheque_Bounces__c=123;
                per.AvgBalance_Of_6_Months__c=0;
                per.Applicant_Name__c=ac.id;
                insert per;
                    
                System.debug('update'+party);
                System.debug('app method 1:-'+app);
            }

        }catch(exception e){
            System.debug('Error@@@@@Line:'+e.getLineNumber()+'message#####'+e.getMessage() +'Stack#####'+e.getStackTraceString());
        }
    }
  
    @istest static void method1()
    {
        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        update app; 
       
    }

    @istest static void method2()
    {
        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();
        
        app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        
        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c='Salaried';
        update party[0];
        update app; 
    }
    @istest static void method3()
    {
        MCLR_Excess_Code__c mclrexcess=[select id,Product_Name__c from MCLR_Excess_Code__c Limit 1];
        mclrexcess.Product_Name__c=Constants.VL4W;
        update mclrexcess;
        list<account> acc=new list<account>([select id,Banking_with_us__c from account]);
        acc[0].Banking_with_us__c=date.newInstance(2018, 09, 12);
        update acc[0];
        system.debug('acc:-'+acc);

        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL4W).getRecordTypeId();
        app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        update app;
    }
    @istest static void method3_1()
    {
        MCLR_Excess_Code__c mclrexcess=[select id,Product_Name__c from MCLR_Excess_Code__c Limit 1];
        mclrexcess.Product_Name__c=Constants.VL4W;
        update mclrexcess;

        list<account> acc=new list<account>([select id,Banking_with_us__c from account]);
        acc[0].Banking_with_us__c=date.newInstance(2018, 09, 12);
        update acc[0];
        system.debug('acc:-'+acc);

        genesis__Applications__c app=[select id,RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        List<genesis__Application_Parties__c> PartyList = [Select Id,genesis__Party_Account_Name__c,Approved_NMI_From_ITR__c,Agriculture2__c,Perfios_Captured__c,age__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,Net_Monthly_Income__c,Total_Annual_other_Income_Claimed__c,CIBIL_Scores__c,Average_Balances_6_months__c,Total_ChequeECS_bounces__c,Employment_Types__c,Additional_Income_Amount1__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c From genesis__Application_Parties__c where  genesis__Application__c =: app.Id AND Active__c =: True AND Financial_Applicant__c =: True AND (genesis__Party_Type__c =: Constants.Co_Borrower OR genesis__Party_Type__c=: Constants.PRIMARY_APP) limit 1];
        PartyList[0].Employment_Types__c='Agriculturist';
            update PartyList;
        system.debug('PartyList:-'+PartyList);
        String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();
        app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        update app;
    }
    
     @istest static void method3_2()
    {
        MCLR_Excess_Code__c mclrexcess=[select id,Product_Name__c from MCLR_Excess_Code__c Limit 1];
        mclrexcess.Product_Name__c=Constants.VL4W;
        update mclrexcess;
        list<account> acc=new list<account>([select id,Banking_with_us__c from account]);
        acc[0].Banking_with_us__c=date.newInstance(2018, 09, 12);
        update acc[0];
        system.debug('acc:-'+acc);

        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        List<genesis__Application_Parties__c> PartyList = [Select Id,genesis__Party_Account_Name__c,Approved_NMI_From_ITR__c,Agriculture2__c,Perfios_Captured__c,age__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,Net_Monthly_Income__c,Total_Annual_other_Income_Claimed__c,CIBIL_Scores__c,Average_Balances_6_months__c,Total_ChequeECS_bounces__c,Employment_Types__c,Additional_Income_Amount1__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c From genesis__Application_Parties__c where  genesis__Application__c =: app.Id AND Active__c =: True AND Financial_Applicant__c =: True AND (genesis__Party_Type__c =: Constants.Co_Borrower OR genesis__Party_Type__c=: Constants.PRIMARY_APP) limit 1];
        PartyList[0].Employment_Types__c='pras';
            update PartyList;
        String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL4W).getRecordTypeId();
        app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        update app;
    }
     @istest static void method3_3()
    {
        MCLR_Excess_Code__c mclrexcess=[select id,Product_Name__c from MCLR_Excess_Code__c Limit 1];
        mclrexcess.Product_Name__c=Constants.VL4W;
        update mclrexcess;
        list<account> acc=new list<account>([select id,Banking_with_us__c from account]);
        acc[0].Banking_with_us__c=date.newInstance(2018, 09, 12);
        update acc[0];
        system.debug('acc:-'+acc);

        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        List<genesis__Application_Parties__c> PartyList = [Select Id,genesis__Party_Account_Name__c,Approved_NMI_From_ITR__c,Agriculture2__c,Perfios_Captured__c,age__c,NMI_Approved__c,NMI_Claimed_By_Customer__c,Net_Monthly_Income__c,Total_Annual_other_Income_Claimed__c,CIBIL_Scores__c,Average_Balances_6_months__c,Total_ChequeECS_bounces__c,Employment_Types__c,Additional_Income_Amount1__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c From genesis__Application_Parties__c where  genesis__Application__c =: app.Id AND Active__c =: True AND Financial_Applicant__c =: True AND (genesis__Party_Type__c =: Constants.Co_Borrower OR genesis__Party_Type__c=: Constants.PRIMARY_APP) limit 1];
        PartyList[0].Employment_Types__c='pras';
            update PartyList;
        String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL2W).getRecordTypeId();
        app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        update app;
    }

    @istest static void method4()
    {
        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
        
        app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        
        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c=constants.EmpType_Other;
        update party[0];
        update app; 
        BREScoreCal.HL_Intrate(app);// calling HL_Intrate(app) because of laploan.
    }
    
    @istest static void method5()
    {
        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();

        app.RecordTypeId=hlRecType;
        app.Perfios_Captured__c=false;
        app.Sub_Stage__c=constants.WORK_INFORMATION_CAPTURED_SUBSTAGE;
        update app;
    }

    @istest static void method7()
    {
        MCLR_Master__c mclrMaster = [select COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c limit 1];
        System.debug('mclrMaster=='+mclrMaster);   

        MCLR_Excess_Code__c mclrexcess=[select id,Product_Name__c from MCLR_Excess_Code__c Limit 1];
        mclrexcess.Product_Name__c=Constants.VL4W;
        update mclrexcess;

        clcommon__CL_Product__c cl=[select id from clcommon__CL_Product__c];
        cl.MCLR_Type__c='One Month';
        update cl;
        clcommon__Collateral__c collat=[select id,clcommon__City__c from clcommon__Collateral__c];
        
        collat.clcommon__City__c='CHENNAI';
        update collat;
        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
        
        app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        
        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c=constants.EmpType_Other;
        update party[0];
        update app; 
     //  BREScoreCal.HL_Intrate(app);// calling HL_Intrate(app) because of laploan.
    }
    
    @istest static void method8()
    {
        MCLR_Master__c mclrMaster = [select COD_Term_From__c,MCLR_Of_Interest__c from MCLR_Master__c limit 1];
        System.debug('mclrMaster=='+mclrMaster);
        
        //MCLR_Excess_Code__c excess = [Select ID,Excess__c,Retail_Category__c,Product_Name__c,From_CIBIL__c from MCLR_Excess_Code__c Limit 1];
        //System.debug('excess=='+excess);            
            
        
        MCLR_Excess_Code__c mclrexcess=[select id,Retail_Category__c,From_CIBIL__c,Product_Name__c from MCLR_Excess_Code__c Limit 1];
        //mclrexcess.Product_Name__c=Constants.VL4W;
        mclrexcess.Product_Name__c=Constants.LAPLOAN;
        mclrexcess.From_CIBIL__c=700;
        update mclrexcess;
        system.debug('mclrexcess:-'+mclrexcess);

        clcommon__CL_Product__c cl=[select id from clcommon__CL_Product__c];
        cl.MCLR_Type__c='Three Month';
        update cl;
        clcommon__Collateral__c collat=[select id,clcommon__City__c from clcommon__Collateral__c];
        
        collat.clcommon__City__c='CHENNAI';
        update collat;
        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
        
        app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c FROM genesis__Application_Parties__c]);
        system.debug('party:-'+party);
        party[0].Employment_Types__c=constants.EmpType_Other;
        party[0].CIBIL_Scores__c=700;
        update party[0];
        update app; 
    }

    @istest static void method9()
    {
       
        MCLR_Master__c mclrmstr=[select id ,COD_Term_From__c from MCLR_Master__c limit 1];      
        mclrmstr.COD_Term_From__c=365;
        update mclrmstr;         
        MCLR_Excess_Code__c m=[select id,From_CIBIL__c from MCLR_Excess_Code__c Limit 1];        
        m.From_CIBIL__c=650;  
        update m;
        
        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        //String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();
        
        //app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;    
    
        
        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c='Salaried';
        party[0].CIBIL_Scores__c=650.00;
        update party[0];
        update app;   
        System.debug('max'+party[0].CIBIL_Scores__c);
    }

    @istest static void method11()
    {
        MCLR_Master__c mclrmstr=[select id ,COD_Term_From__c from MCLR_Master__c limit 1];      
        mclrmstr.COD_Term_From__c=365;
        update mclrmstr;         
        MCLR_Excess_Code__c m=[select id,From_CIBIL__c from MCLR_Excess_Code__c Limit 1];        
        m.From_CIBIL__c=700;  
        update m;
        
        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        //String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();
        
        //app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;    
    
        
        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c='Salaried';
        party[0].CIBIL_Scores__c=700.00;
        update party[0];
        update app;       
        
        
        System.debug('max'+party[0].CIBIL_Scores__c);
    }

    @istest static void method10()
    {
        MCLR_Master__c mclrmstr=[select id ,COD_Term_From__c from MCLR_Master__c limit 1];      
        mclrmstr.COD_Term_From__c=365;
        update mclrmstr;         
        MCLR_Excess_Code__c m=[select id,From_CIBIL__c from MCLR_Excess_Code__c Limit 1];        
        m.From_CIBIL__c=-1;
        update m;
        
        genesis__Applications__c app=[select RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        //String hlRecType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();
        
        //app.RecordTypeId=hlRecType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
    
        
        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c='Salaried';
        party[0].CIBIL_Scores__c=-1.00;
        party[0].genesis__Party_Type__c=Constants.PRIMARY_APP;
        update party[0];
        update app;       
        
        System.debug('max'+party[0].CIBIL_Scores__c);
    }

    @isTest
    public static void BREScoreCal_testcase5(){

        genesis__Applications__c app=[select Id,Name,Record_Type_Name__c,RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String recType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(constants.HOMELOAN).getRecordTypeId();
        app.RecordTypeId=recType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        app.Property_City__c = 'CHENNAI';
        app.Age_Of_The_Building__c = 40;
        //app.Residual_Life_of_Property__c = 90;
        app.genesis__Term__c=12;
        update app;

        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c='Salaried';
        party[0].CIBIL_Scores__c=750;
        party[0].genesis__Party_Type__c=Constants.PRIMARY_APP;
        update party[0];

        Test.startTest();
            BREScoreCal.Calculate_Bre(app,500000,2000,Constants.Sub_Stage_LoanReqCaptured);
        Test.stopTest();
    }

    @isTest
    public static void BREScoreCal_testcase6(){

        genesis__Applications__c app=[select Id,Name,Record_Type_Name__c,RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String recType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL4W).getRecordTypeId();
        app.RecordTypeId=recType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        app.Property_City__c = 'CHENNAI';
        app.Age_Of_The_Building__c = 40;
        //app.Residual_Life_of_Property__c = 90;
        update app;

        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c='Salaried';
        party[0].CIBIL_Scores__c=750;
        party[0].genesis__Party_Type__c=Constants.PRIMARY_APP;
        update party[0];

        Test.startTest();
            BREScoreCal.HL_Intrate(app);
        Test.stopTest();
    }

    @isTest
    public static void BREScoreCal_testcase7(){

        genesis__Applications__c app=[select Id,Name,Record_Type_Name__c,RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String recType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
        app.RecordTypeId=recType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        app.Property_City__c = 'CHENNAI';
        app.Age_Of_The_Building__c = 40;
        //app.Residual_Life_of_Property__c = 90;
        update app;

        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c='Salaried';
        party[0].CIBIL_Scores__c=750;
        party[0].genesis__Party_Type__c=Constants.PRIMARY_APP;
        update party[0];

        Test.startTest();
            BREScoreCal.HL_Intrate(app);
        Test.stopTest();
    }
     @isTest
    public static void BREScoreCal_testcase7_1(){

        genesis__Applications__c app=[select Id,Name,Record_Type_Name__c,RecordTypeId,Sub_Stage__c from genesis__Applications__c limit 1];
        String recType= Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
        app.RecordTypeId=recType;
        app.Sub_Stage__c=constants.Sub_Stage_LoanReqCaptured;
        app.Property_City__c = 'CHENNAI';
        app.Age_Of_The_Building__c = 40;
        //app.Residual_Life_of_Property__c = 90;
        update app;

        list<genesis__Application_Parties__c> party = new list<genesis__Application_Parties__c>([SELECT id,Employment_Types__c FROM genesis__Application_Parties__c]);
        party[0].Employment_Types__c='Salaried';
        party[0].CIBIL_Scores__c=750;
        party[0].genesis__Party_Type__c=Constants.PRIMARY_APP;
        update party[0];
        try{
        Test.startTest();
            BREScoreCal.HL_Intrate(app);
        Test.stopTest();
        }catch(exception e)
        {}
    }
    //braj(end)
   
}