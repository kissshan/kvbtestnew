@isTest
public class Test_Retry_Task_call {
   
       @isTest
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
        acc.CIBIL_Score__c = 780;
        
        insert acc;
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
            genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c='Co-Borrower';
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Legal Clearance', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
    @isTest
    public static void setupMethod0()
    {
        String BranchCode = '1857';
        Boolean ReRun = false;
        Decimal PMAX1 = 29756.00;
        String checkCal = '3';
        Decimal NMIITR;
        Decimal AddIncome;
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;        
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
        par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Annual_Share_of_Profit_Firm__c = 20000.00;
        par.Gross_Income2__c = 100000.00;
        par.Annual_Capital_Gain2__c = 8670.00;
        par.Annual_Tax2__c = 3450.00;
        par.Interest_Income2__c = 5350.00;
        par.Dividend_Income2__c = 2340.00;
        par.Share_of_Profit_2__c = 6460.00;
        par.Agriculture_ITR2__c = 2440.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        List<genesis__Application_Parties__c> partList = [SELECT Id, Name, Approved_NMI_From_ITR__c, Total_Annual_other_Income_Approved__c FROM genesis__Application_Parties__c WHERE Id =: par.Id];
        NMIITR = partList[0].Approved_NMI_From_ITR__c;
        AddIncome = partList[0].Total_Annual_other_Income_Approved__c;
        System.debug('-----------'+NMIITR);
        System.debug('========'+AddIncome);
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Legal Clearance', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        //ApplicationEligibiltyHandler apth = new ApplicationEligibiltyHandler();
        ApplicationEligibiltyHandler.NMICalcu(NMIITR,AddIncome);
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
     @isTest
    public static void setupMethod00()
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;        
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
        par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;        
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Legal Clearance', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
     @isTest
    public static void setupMethod0PL0()
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;        
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
        par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Legal Clearance', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
    @isTest
    public static void setupMethod0HL0()
    {
        String BranchCode = '1857';
        Boolean ReRun = false;
        String checkCal = '3';
        Decimal PMAX1 = 29756.00;
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
        acc.CIBIL_Score__c = 800;
        insert acc;
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            genApp.Property_City__c = 'Chennai';
            genApp.Branch_Code__c = '1857';
            genApp.GMRA_Amount__c = 400.00;
            genApp.genesis__Loan_Amount__c = 350000.00;
            insert genApp;        
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
        par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        par.CIBIL_Scores__c = 800;
        insert par;
	    
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll; 
        
        Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 750;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 90;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
        
        MCLR_Master__c mclrmstr1 = new MCLR_Master__c();
        mclrmstr1.COD_Term_From__c = 365;
        mclrmstr1.MCLR_Of_Interest__c = 9.65;
        insert mclrmstr1;    
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Legal Clearance', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
    @isTest
    public static void setupMethodLap00()
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;        
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Legal Clearance', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
     @isTest
    public static void setupMethod01()
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 0;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Application_Stage__c = Constants.APP_REJECTED_STAGE;
            genApp.Sub_Stage__c = 'Cheque Returns';
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;        
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Legal Clearance', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
    @isTest
    public static void setupMethod1()
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c='Co-Borrower';
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Approve income', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
     @isTest
    public static void setupMethod11()
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;        
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c='Co-Borrower';
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;      
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'SI/ E-mandate', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
      @isTest
    public static void setupMethod111()
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c='Co-Borrower';
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Initiate MOD', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
    
      @isTest
    public static void setupMethod1111()
    {
        String BranchCode = '1857';
        Boolean ReRun = true;
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp; 
     
		List<genesis__Applications__c> listapp = [select id,Acknowledgement__c,GMRA_Amount__c,Is_GMRA_Policy_Selected__c,Retail_BRE_Hit__c, genesis__CL_Product__c, Sub_Stage__c, Property_City__c, Branch_Code__c, PMax__c , PMin__c, FI_Status__c, Total_Cheque_Bounces__c, Application_Stage__c, Record_Type_Name__c, PreClosure_Interest_Rate__c, Holiday_Period__c,Preclosure_Charges__c,Penal_Interest__c,genesis__Interest_Calculation_Method__c,
                                                     Sanction_Amount_Words__c,Sanctioned_EMI__c, Sanctioned_Tenure__c, Sanction_Authority_Limit__c, genesis__Payment_Amount__c, MCLR_Type__c, genesis__Margin__c, Interest_Variation__c, genesis__Loan_Amount__c, genesis__Term__c, Excess_MCLR__c, Age_Of_The_Building__c,
                                                     Market_Value_Of_The_Building__c, Cost_Of_Flat_House__c, Loan_Purpose__c, Cost_Of_Repair__c, Market_valueProposedRepairs_Renovation__c, genesis__Interest_Rate__c, Total_Market_value__c, Maturity_Time__c, NMI_Approved__c, Cost_Of_Land__c, Cost_Of_Construction__c, 
                                                     (select id, genesis__Party_Type__c, Additional_Income_Amount1__c, Total_Annual_other_Income_Approved__c, Employment_Types__c,NMI_Approved__c, Approved_NMI_From_ITR__c, NMI_Claimed_By_Customer__c,Age__c, Existing_Emis__c, Financial_Applicant__c, Agriculture2__c, Net_Monthly_Income__c,
                                                      Max_Existing_EMI__c from genesis__Application_Parties__r where Active__c=true) from genesis__Applications__c where ID =: genApp.Id];      
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c='Co-Borrower';
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        Task newTask = new Task();             
              
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
    
    @isTest
    public static void setupMethod2()
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
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Assess Income', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
    @isTest
    public static void setupMethod2_1()
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
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Assess Income', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
   
    @isTest
    public static void setupMethod3()
    {
        String BranchCode = '1857';
        Boolean ReRun = true;
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL2W).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c='Co-Borrower';
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 765;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Assess Income', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        
        Retry_Task_call.recallTasknew(newTask,ReRun,genApp.Id);
    }
    public static void setupMethod33()
    {
        String BranchCode = '1857';
        Boolean ReRun = true;
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Sub_Stage__c = 'Loan Sanctioned Non-STP';
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c='Primary Applicant';
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        coll.genesis__Application__c=genApp.id;
        coll.Cost_Of_Flat_House__c=12323.2;
        coll.Market_Value_Of_The_Land__c=1232;
        coll.Market_Value_Of_The_Building__c=12322.2;
        coll.Market_valueProposedRepairs_Renovation__c=12323.34;
        insert coll;
        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 800;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 365;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Assess Income', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        Map<Id,genesis__Applications__c> app = new Map<Id,genesis__Applications__c>();
        genesis__Applications__c apl = new genesis__Applications__c();
        List<genesis__Applications__c> oldList = new List<genesis__Applications__c>();
        oldList.add(genApp);
        apl.Sub_Stage__c = 'All NSTP Processes Completed';
        insert apl;
        app.put(apl.Id,apl);
        
        
        Retry_Task_call.applicationReCal(oldList,app);
        Retry_Task_call.CallEMI(genApp);
    }
    @isTest
    public static void setupMethod34()
    {
        String BranchCode = '1857';
        Boolean ReRun = true;
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Sub_Stage__c = 'Loan Sanctioned Non-STP';
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.IdentifiedProperty;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.Co_Borrower;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Agricul;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        coll.genesis__Application__c=genApp.id;
        coll.Cost_Of_Flat_House__c=12323.2;
        coll.Market_Value_Of_The_Land__c=1232;
        coll.Market_Value_Of_The_Building__c=12322.2;
        coll.Market_valueProposedRepairs_Renovation__c=12323.34;
        insert coll;
        //system.debug('App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c:-'+genApp.genesis__Collaterals__r.Cost_Of_Flat_House__c);

        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 750;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 90;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Assess Income', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        Map<Id,genesis__Applications__c> app = new Map<Id,genesis__Applications__c>();
        genesis__Applications__c apl = new genesis__Applications__c();
        List<genesis__Applications__c> oldList = new List<genesis__Applications__c>();
        oldList.add(genApp);
        apl.Sub_Stage__c = 'All NSTP Processes Completed';
        insert apl;
        app.put(apl.Id,apl);
        
        Retry_Task_call.applicationReCal(oldList,app);
List<genesis__Applications__c> listapp =[select id,Retail_BRE_Hit__c,GMRA_Amount__c,Is_GMRA_Policy_Selected__c,genesis__CL_Product__c,Sub_Stage__c,Branch_Code__c,PMax__c, PMin__c, genesis__Account__r.Total_Annual_other_Income_Approved__c,FI_Status__c,Total_Cheque_Bounces__c,Application_Stage__c,Record_Type_Name__c,PreClosure_Interest_Rate__c,Holiday_Period__c,Preclosure_Charges__c,Penal_Interest__c,genesis__Interest_Calculation_Method__c, Sanctioned_EMI__c,Sanctioned_Tenure__c,Sanction_Authority_Limit__c,genesis__Payment_Amount__c,MCLR_Type__c,genesis__Margin__c,Interest_Variation__c, genesis__Loan_Amount__c,genesis__Term__c,genesis__Account__r.Employment_Type__c,genesis__Account__r.NMI_Approved__c,genesis__Account__r.Approved_NMI_From_ITR__c,Excess_MCLR__c, genesis__Account__r.NMI_Claimed_By_Customer__c, genesis__Account__r.Age__c,genesis__Account__r.Additional_Income_Amount1__c,Loan_Purpose__c,genesis__Account__r.Existing_Emis__c, Pre_approved_flag__c,genesis__Interest_Rate__c,genesis__Account__r.Financial_Applicant__c,genesis__Account__r.Agriculture2__c,Maturity_Time__c,NMI_Approved__c, genesis__Account__r.Net_Monthly_Income__c,genesis__Account__r.Max_Existing_EMI__c, (select id, genesis__Party_Type__c, Additional_Income_Amount1__c, Total_Annual_other_Income_Approved__c, Employment_Types__c, NMI_Approved__c, Approved_NMI_From_ITR__c, NMI_Claimed_By_Customer__c,Age__c, Existing_Emis__c, Financial_Applicant__c, Agriculture2__c, Net_Monthly_Income__c, Max_Existing_EMI__c from genesis__Application_Parties__r where Active__c=true),(select id,clcommon__City__c,Cost_Of_Flat_House__c,Total_Market_value__c,Cost_Of_Repair__c,Market_valueProposedRepairs_Renovation__c,Cost_Of_Construction__c,Market_Value_Of_The_Building__c,Cost_Of_Land__c,Cost_of_Property__c,Age_Of_The_Building__c,Residual_Life_of_Property__c from genesis__Collaterals__r where Active__c=true) from genesis__Applications__c where ID =: genApp.id];        
       // Retry_Task_call.calculateEligibility(listapp[0],'3');
        Retry_Task_call.CallEMI(listapp[0]);

    }
     @isTest
    public static void setupMethod35()
    {
        String BranchCode = '1857';
        Boolean ReRun = true;
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Sub_Stage__c = 'Loan Sanctioned Non-STP';
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.RepairHouse;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.Co_Borrower;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        coll.genesis__Application__c=genApp.id;
        coll.Cost_Of_Flat_House__c=12323.2;
        coll.Market_Value_Of_The_Land__c=1232;
        coll.Market_Value_Of_The_Building__c=12322.2;
        coll.Market_valueProposedRepairs_Renovation__c=12323.34;
        coll.Cost_Of_Repair__c=1234.23;
        coll.Cost_Of_Construction__c=12322.23;
        coll.Cost_Of_Land__c=1232.23;
        
        
        insert coll;
        //system.debug('App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c:-'+genApp.genesis__Collaterals__r.Cost_Of_Flat_House__c);

        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 750;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 90;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Assess Income', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        Map<Id,genesis__Applications__c> app = new Map<Id,genesis__Applications__c>();
        genesis__Applications__c apl = new genesis__Applications__c();
        List<genesis__Applications__c> oldList = new List<genesis__Applications__c>();
        oldList.add(genApp);
        apl.Sub_Stage__c = 'All NSTP Processes Completed';
        insert apl;
        app.put(apl.Id,apl);
        
        Retry_Task_call.applicationReCal(oldList,app);
List<genesis__Applications__c> listapp =[select id,Retail_BRE_Hit__c,GMRA_Amount__c,Is_GMRA_Policy_Selected__c,genesis__CL_Product__c,Sub_Stage__c,Branch_Code__c,PMax__c, PMin__c, genesis__Account__r.Total_Annual_other_Income_Approved__c,FI_Status__c,Total_Cheque_Bounces__c,Application_Stage__c,Record_Type_Name__c,PreClosure_Interest_Rate__c,Holiday_Period__c,Preclosure_Charges__c,Penal_Interest__c,genesis__Interest_Calculation_Method__c, Sanctioned_EMI__c,Sanctioned_Tenure__c,Sanction_Authority_Limit__c,genesis__Payment_Amount__c,MCLR_Type__c,genesis__Margin__c,Interest_Variation__c, genesis__Loan_Amount__c,genesis__Term__c,genesis__Account__r.Employment_Type__c,genesis__Account__r.NMI_Approved__c,genesis__Account__r.Approved_NMI_From_ITR__c,Excess_MCLR__c, genesis__Account__r.NMI_Claimed_By_Customer__c, genesis__Account__r.Age__c,genesis__Account__r.Additional_Income_Amount1__c,Loan_Purpose__c,genesis__Account__r.Existing_Emis__c, Pre_approved_flag__c,genesis__Interest_Rate__c,genesis__Account__r.Financial_Applicant__c,genesis__Account__r.Agriculture2__c,Maturity_Time__c,NMI_Approved__c, genesis__Account__r.Net_Monthly_Income__c,genesis__Account__r.Max_Existing_EMI__c, (select id, genesis__Party_Type__c, Additional_Income_Amount1__c, Total_Annual_other_Income_Approved__c, Employment_Types__c, NMI_Approved__c, Approved_NMI_From_ITR__c, NMI_Claimed_By_Customer__c,Age__c, Existing_Emis__c, Financial_Applicant__c, Agriculture2__c, Net_Monthly_Income__c, Max_Existing_EMI__c from genesis__Application_Parties__r where Active__c=true),(select id,clcommon__City__c,Cost_Of_Flat_House__c,Total_Market_value__c,Cost_Of_Repair__c,Market_valueProposedRepairs_Renovation__c,Cost_Of_Construction__c,Market_Value_Of_The_Building__c,Cost_Of_Land__c,Cost_of_Property__c,Age_Of_The_Building__c,Residual_Life_of_Property__c from genesis__Collaterals__r where Active__c=true) from genesis__Applications__c where ID =: genApp.id];        
       // Retry_Task_call.calculateEligibility(listapp[0],'3');
        Retry_Task_call.CallEMI(listapp[0]);

    }
     @isTest
    public static void setupMethod36()
    {
        String BranchCode = '1857';
        Boolean ReRun = true;
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Sub_Stage__c = 'Loan Sanctioned Non-STP';
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.Construction;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.PRIMARY_APP;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        coll.genesis__Application__c=genApp.id;
        coll.Cost_Of_Flat_House__c=12323.2;
        coll.Market_Value_Of_The_Land__c=1232;
        coll.Market_Value_Of_The_Building__c=12322.2;
        coll.Market_valueProposedRepairs_Renovation__c=12323.34;
        coll.Cost_Of_Repair__c=1234.23;
        coll.Cost_Of_Construction__c=12322.23;
        coll.Cost_Of_Land__c=1232.23;
        
        
        insert coll;
        //system.debug('App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c:-'+genApp.genesis__Collaterals__r.Cost_Of_Flat_House__c);

        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 750;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 90;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Assess Income', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        Map<Id,genesis__Applications__c> app = new Map<Id,genesis__Applications__c>();
        genesis__Applications__c apl = new genesis__Applications__c();
        List<genesis__Applications__c> oldList = new List<genesis__Applications__c>();
        oldList.add(genApp);
        apl.Sub_Stage__c = 'All NSTP Processes Completed';
        insert apl;
        app.put(apl.Id,apl);
        
        Retry_Task_call.applicationReCal(oldList,app);
List<genesis__Applications__c> listapp =[select id,Retail_BRE_Hit__c,GMRA_Amount__c,Is_GMRA_Policy_Selected__c,genesis__CL_Product__c,Sub_Stage__c,Branch_Code__c,PMax__c, PMin__c, genesis__Account__r.Total_Annual_other_Income_Approved__c,FI_Status__c,Total_Cheque_Bounces__c,Application_Stage__c,Record_Type_Name__c,PreClosure_Interest_Rate__c,Holiday_Period__c,Preclosure_Charges__c,Penal_Interest__c,genesis__Interest_Calculation_Method__c, Sanctioned_EMI__c,Sanctioned_Tenure__c,Sanction_Authority_Limit__c,genesis__Payment_Amount__c,MCLR_Type__c,genesis__Margin__c,Interest_Variation__c, genesis__Loan_Amount__c,genesis__Term__c,genesis__Account__r.Employment_Type__c,genesis__Account__r.NMI_Approved__c,genesis__Account__r.Approved_NMI_From_ITR__c,Excess_MCLR__c, genesis__Account__r.NMI_Claimed_By_Customer__c, genesis__Account__r.Age__c,genesis__Account__r.Additional_Income_Amount1__c,Loan_Purpose__c,genesis__Account__r.Existing_Emis__c, Pre_approved_flag__c,genesis__Interest_Rate__c,genesis__Account__r.Financial_Applicant__c,genesis__Account__r.Agriculture2__c,Maturity_Time__c,NMI_Approved__c, genesis__Account__r.Net_Monthly_Income__c,genesis__Account__r.Max_Existing_EMI__c, (select id, genesis__Party_Type__c, Additional_Income_Amount1__c, Total_Annual_other_Income_Approved__c, Employment_Types__c, NMI_Approved__c, Approved_NMI_From_ITR__c, NMI_Claimed_By_Customer__c,Age__c, Existing_Emis__c, Financial_Applicant__c, Agriculture2__c, Net_Monthly_Income__c, Max_Existing_EMI__c from genesis__Application_Parties__r where Active__c=true),(select id,clcommon__City__c,Cost_Of_Flat_House__c,Total_Market_value__c,Cost_Of_Repair__c,Market_valueProposedRepairs_Renovation__c,Cost_Of_Construction__c,Market_Value_Of_The_Building__c,Cost_Of_Land__c,Cost_of_Property__c,Age_Of_The_Building__c,Residual_Life_of_Property__c from genesis__Collaterals__r where Active__c=true) from genesis__Applications__c where ID =: genApp.id];        
       // Retry_Task_call.calculateEligibility(listapp[0],'3');
        Retry_Task_call.CallEMI(listapp[0]);

    }
    
    
     @isTest
    public static void setupMethod37() 
    {
        String BranchCode = '1857';
        Boolean ReRun = true;
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
       
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();
            //genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        	genesis__Applications__c genApp= Utility_Test.createApplication(BranchCode,acc.Id);    
        	genApp.Document_Generation__c='None';
            genApp.Legal_desk_state_flag__c=true;
            genApp.FI_Status__c = Constants.FI_Nega;
            genApp.RecordTypeId = genAppRecordType;
            genApp.genesis__Term__c = 12;
            genApp.genesis__Interest_Rate__c = 15.28;
            genApp.PMin__c = 2078.98;
            genApp.Total_Cheque_Bounces__c = 2;
            genApp.Sub_Stage__c = 'Loan Sanctioned Non-STP';
            genApp.Is_GMRA_Policy_Selected__c = true;
            genApp.Cost_of_Property__c = 2067543.00;
            genApp.Loan_Purpose__c = Constants.ConstructionOn;
            genApp.Cost_Of_Flat_House__c = 400000.00;
             genApp.Market_Value_Of_The_Land__c = 50000.00;
            genApp.Market_Value_Of_The_Building__c = 35000.00;
            genApp.Market_valueProposedRepairs_Renovation__c = 45000.00;
            insert genApp;         
 
        genesis__Application_Parties__c par=new genesis__Application_Parties__c();
        
        par.genesis__Application__c=genApp.id;
        par.genesis__Party_Account_Name__c=acc.id;
        par.genesis__Party_Type__c=Constants.Co_Borrower;
        par.Active__c=true;
        par.Financial_Applicant__c=true;
       // par.Employment_Type__c='Salaried';
        par.Agriculture2__c =  2000.44;
        par.Annual_Share_of_Profit_Firm__c = 3434.34;
        par.Rental2__c = 2344.45;
        par.Pension_Income2__c = 7654.98;
        par.Others_Income2__c = 2434.34;
        par.Income_Computation_From__c = 'Bank Statement';
         par.Salary_Credited_1__c = 200000.34;
        par.Salary_Credited_2__c = 100000.99;
        par.Salary_Credited_3__c = 158000.00;
        par.Employment_Types__c = Constants.EmpType_Salaried;
        par.Gross_Income2__c = 1000.00;
        par.Annual_Capital_Gain2__c = 867.00;
        par.Annual_Tax2__c = 345.00;
        par.Interest_Income2__c = 535.00;
        par.Dividend_Income2__c = 234.00;
        par.Share_of_Profit_2__c = 646.00;
        par.Agriculture_ITR2__c = 244.00;
        par.CIBIL_Scores__c = 800;
        insert par;
        
        clcommon__Collateral__c coll = new clcommon__Collateral__c();
        coll.Scheme_Type__c = 'asdfgh';
        coll.Collateral_Uses__c = 'Residential';
        coll.Collateral_Market_Value__c = 3480075.98;
        coll.clcommon__City__c = 'Chennai';
        coll.clcommon__Collateral_Name__c = 'iyqwtyqw';
        coll.genesis__Application__c=genApp.id;
        coll.Cost_Of_Flat_House__c=12323.2;
        coll.Market_Value_Of_The_Land__c=1232;
        coll.Market_Value_Of_The_Building__c=12322.2;
        coll.Market_valueProposedRepairs_Renovation__c=12323.34;
        coll.Cost_Of_Repair__c=1234.23;
        coll.Cost_Of_Construction__c=12322.23;
        coll.Cost_Of_Land__c=1232.23;
        
        
        insert coll;
        //system.debug('App.genesis__Collaterals__r[0].Cost_Of_Flat_House__c:-'+genApp.genesis__Collaterals__r.Cost_Of_Flat_House__c);

        
          Branch_Master__c brnch = new Branch_Master__c();
        brnch.CODCCBRN__c = '1857';
        brnch.NAMCCCITY__c = 'Chennai';
        brnch.Retail_Category__c = 'A';
        insert brnch;
        
        MCLR_Excess_Code__c mclr = new MCLR_Excess_Code__c();
        mclr.Employment_Type__c = Constants.EmpType_Salaried;
        
        mclr.Excess__c = 9.65;
        mclr.From_CIBIL__c = 750;
        mclr.Product_Name__c = Constants.HOMELOAN;
        mclr.Retail_Category__c = 'A';
        mclr.Name = 'wertyu';
        insert mclr;
            
        MCLR_Master__c mclrmstr = new MCLR_Master__c();
        mclrmstr.COD_Term_From__c = 90;
        mclrmstr.MCLR_Of_Interest__c = 9.65;
        
        insert mclrmstr;
            
        
        Task newTask = new Task(Description = 'Survey Transaction',
                                        Priority = 'Normal', 
                                        Status = 'Completed', 
                                        Subject = 'Assess Income', 
                                        IsReminderSet = true, 
                                        ReminderDateTime = System.now()+1,
                                        WhatID=genApp.id
                                         );             
                insert newTask;
        Map<Id,genesis__Applications__c> app = new Map<Id,genesis__Applications__c>();
        genesis__Applications__c apl = new genesis__Applications__c();
        List<genesis__Applications__c> oldList = new List<genesis__Applications__c>();
        oldList.add(genApp);
        apl.Sub_Stage__c = 'All NSTP Processes Completed';
        insert apl;
        app.put(apl.Id,apl);
        
        Retry_Task_call.applicationReCal(oldList,app);
List<genesis__Applications__c> listapp =[select id,Retail_BRE_Hit__c,GMRA_Amount__c,Is_GMRA_Policy_Selected__c,genesis__CL_Product__c,Sub_Stage__c,Branch_Code__c,PMax__c, PMin__c, genesis__Account__r.Total_Annual_other_Income_Approved__c,FI_Status__c,Total_Cheque_Bounces__c,Application_Stage__c,Record_Type_Name__c,PreClosure_Interest_Rate__c,Holiday_Period__c,Preclosure_Charges__c,Penal_Interest__c,genesis__Interest_Calculation_Method__c, Sanctioned_EMI__c,Sanctioned_Tenure__c,Sanction_Authority_Limit__c,genesis__Payment_Amount__c,MCLR_Type__c,genesis__Margin__c,Interest_Variation__c, genesis__Loan_Amount__c,genesis__Term__c,genesis__Account__r.Employment_Type__c,genesis__Account__r.NMI_Approved__c,genesis__Account__r.Approved_NMI_From_ITR__c,Excess_MCLR__c, genesis__Account__r.NMI_Claimed_By_Customer__c, genesis__Account__r.Age__c,genesis__Account__r.Additional_Income_Amount1__c,Loan_Purpose__c,genesis__Account__r.Existing_Emis__c, Pre_approved_flag__c,genesis__Interest_Rate__c,genesis__Account__r.Financial_Applicant__c,genesis__Account__r.Agriculture2__c,Maturity_Time__c,NMI_Approved__c, genesis__Account__r.Net_Monthly_Income__c,genesis__Account__r.Max_Existing_EMI__c, (select id, genesis__Party_Type__c, Additional_Income_Amount1__c, Total_Annual_other_Income_Approved__c, Employment_Types__c, NMI_Approved__c, Approved_NMI_From_ITR__c, NMI_Claimed_By_Customer__c,Age__c, Existing_Emis__c, Financial_Applicant__c, Agriculture2__c, Net_Monthly_Income__c, Max_Existing_EMI__c from genesis__Application_Parties__r where Active__c=true),(select id,clcommon__City__c,Cost_Of_Flat_House__c,Total_Market_value__c,Cost_Of_Repair__c,Market_valueProposedRepairs_Renovation__c,Cost_Of_Construction__c,Market_Value_Of_The_Building__c,Cost_Of_Land__c,Cost_of_Property__c,Age_Of_The_Building__c,Residual_Life_of_Property__c from genesis__Collaterals__r where Active__c=true) from genesis__Applications__c where ID =: genApp.id];        
       // Retry_Task_call.calculateEligibility(listapp[0],'3');
        Retry_Task_call.CallEMI(listapp[0]); 

    }    
    @isTest
    public static void numberconversion()
    {
        Decimal Num = 2067576.86868;
        NumberToWordConversion nn = new NumberToWordConversion();
        nn.getNumberTOWordConvertion(Num);
        nn.getNumberTOWordConvertion2(Num);
    }
}