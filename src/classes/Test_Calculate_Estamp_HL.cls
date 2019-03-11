/*Name : Calculate_Estamp_HL
 *Author : Ashish
 *Date : 10/09/18
 */
//modified by:-prashant singh
//code coverage:-79%
@isTest
public class Test_Calculate_Estamp_HL {
    public testMethod static void method1(){
        
        Id record_type_HL = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();    
		
        Branch_Master__c bm = new Branch_Master__c(CODCCBRN__c = '1857',State__c = 'Tamil Nadu', Special_Branches__c = true);
        insert bm;
        
        genesis__Applications__c app=TestUtility.intialSetUp('Home Loan',true) ;
        app.RecordTypeId = record_type_HL;
        app.Open_CASA_Account__c = 'N/A';
        app.Plan_Approval_available__c = 'N/A';
        app.Verify_Sale_Agreement__c = 'N/A';
        app.Verify_Construction__c = 'N/A';
        app.Verify_Advance_Payment__c = 'N/A';
        app.Execute_Tripartite_Agreement__c = 'N/A';
        app.Verify_Latest_EC__c = 'N/A';
        app.Verify_NOC__c = 'N/A';
        app.Verify_Margin_Payment__c = 'N/A';
        app.Complete_E_KYC_for_NTB_customers__c = 'N/A';
        app.Branch_Code__c = '1857';
        app.Tripartite_Agreement__c = true;
        app.Branch_City__c = '1857';
        app.Sub_Stage__c = 'Work Information Captured';
        app.Charges_Processed__c=true;
        update app;
        
        genesis__Application_Parties__c appPar = new genesis__Application_Parties__c(genesis__Application__c = app.Id, genesis__Party_Type__c = 'Co-Borrower', CIBIL_Scores__c = 700, Company__c = false);
        insert appPar;
        
        genesis__Applications__c app1 = [select id,Charges_Processed__c,Record_Type_Name__c,Sub_Stage__c,Tripartite_Agreement__c,Branch_City__c,Branch_Code__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id from genesis__Application_Parties__r) from genesis__Applications__c where id =: app.Id];
        
        List<genesis__Applications__c> appnewList=new List<genesis__Applications__c>();
        appnewList.add(app1);
        
        genesis__Applications__c app2= new genesis__Applications__c();
        app2.Id = app.Id;
        app2.RecordTypeId = record_type_HL;
        app2.Open_CASA_Account__c = 'Yes';
        app2.Plan_Approval_available__c = 'Yes';
        app2.Verify_Sale_Agreement__c = 'Yes';
        app2.Verify_Construction__c = 'Yes';
        app2.Verify_Advance_Payment__c = 'Yes';
        app2.Execute_Tripartite_Agreement__c = 'Yes';
        app2.Verify_Latest_EC__c = 'Yes';
        app2.Verify_NOC__c = 'Yes';
        app2.Verify_Margin_Payment__c = 'Yes';
        app2.Complete_E_KYC_for_NTB_customers__c = 'Yes';
        app2.Tripartite_Agreement__c = false;
        app2.Sub_Stage__c = 'Application Created';
        update app2;
        
        app2 = [select id,Charges_Processed__c,Record_Type_Name__c,Branch_City__c,genesis__CL_Product__c, Branch_Code__c,Tripartite_Agreement__c,Sub_Stage__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id from genesis__Application_Parties__r) from genesis__Applications__c where id =: app2.id];
        
        Map<id,genesis__Applications__c> oldmap=new  Map<id,genesis__Applications__c>();
        oldmap.put(app2.id, app2);
        
        Test.startTest();
            Calculate_Estamp_HL.calEstamp(appnewList,oldmap);
        	Calculate_Estamp_HL.HLScoreRejectionScenario(appnewList, oldmap);
            Calculate_Estamp_HL.BranchRejectionHL(appnewList, oldmap);
        Test.stopTest();
    }
    
    public testMethod static void method2(){
        Id record_type_HL = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();    
		
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='LAP');
        insert product;
        
        Branch_Master__c bm = new Branch_Master__c(CODCCBRN__c = '1857',State__c = 'Tamil Nadu', Special_Branches__c = true);
        insert bm;
        
        genesis__Applications__c app=TestUtility.intialSetUp('LAP',true) ;
        app.RecordTypeId = record_type_HL;
        app.Open_CASA_Account__c = 'N/A';
        app.Plan_Approval_available__c = 'N/A';
        app.Verify_Sale_Agreement__c = 'N/A';
        app.Verify_Construction__c = 'N/A';
        app.Verify_Advance_Payment__c = 'N/A';
        app.Execute_Tripartite_Agreement__c = 'N/A';
        app.Verify_Latest_EC__c = 'N/A';
        app.Verify_NOC__c = 'N/A';
        app.Verify_Margin_Payment__c = 'N/A';
        app.Complete_E_KYC_for_NTB_customers__c = 'N/A';
        app.Branch_Code__c = '1857';
        app.Tripartite_Agreement__c = true;
        app.Branch_City__c = '1857';
        app.Sub_Stage__c = 'Loan Requirement Captured';
        app.genesis__CL_Product__c = product.id;
        update app;
        
        genesis__Application_Parties__c appPar = new genesis__Application_Parties__c(genesis__Application__c = app.Id, genesis__Party_Type__c = 'Co-Borrower');
        insert appPar;
        
        genesis__Applications__c app1 = [select id,Record_Type_Name__c,genesis__CL_Product__c, Sub_Stage__c,Tripartite_Agreement__c,Branch_City__c,Branch_Code__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id from genesis__Application_Parties__r) from genesis__Applications__c where id =: app.Id];
        
        List<genesis__Applications__c> appnewList=new List<genesis__Applications__c>();
        appnewList.add(app1);
        
        genesis__Applications__c app2= new genesis__Applications__c();
        app2.Id = app.Id;
        app2.RecordTypeId = record_type_HL;
        app2.Open_CASA_Account__c = 'Yes';
        app2.Plan_Approval_available__c = 'Yes';
        app2.Verify_Sale_Agreement__c = 'Yes';
        app2.Verify_Construction__c = 'Yes';
        app2.Verify_Advance_Payment__c = 'Yes';
        app2.Execute_Tripartite_Agreement__c = 'Yes';
        app2.Verify_Latest_EC__c = 'Yes';
        app2.Verify_NOC__c = 'Yes';
        app2.Verify_Margin_Payment__c = 'Yes';
        app2.Complete_E_KYC_for_NTB_customers__c = 'Yes';
        app2.Tripartite_Agreement__c = false;
        app2.Sub_Stage__c = 'Loan Requirement Captured'; 
        update app2;
        
        app2 = [select id,Record_Type_Name__c,Branch_City__c,Branch_Code__c,Tripartite_Agreement__c,Sub_Stage__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id from genesis__Application_Parties__r) from genesis__Applications__c where id =: app2.id];
        
        Map<id,genesis__Applications__c> oldmap=new  Map<id,genesis__Applications__c>();
        oldmap.put(app2.id, app2);
        
        Test.startTest();
            Calculate_Estamp_HL.HLScoreRejectionScenario(appnewList, oldmap);
        Test.stopTest();
    }
    public testMethod static void method3(){
        Id record_type_HL = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();    
		
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='LAP');
        insert product;
        
        Branch_Master__c bm = new Branch_Master__c(CODCCBRN__c = '1857',State__c = 'Tamil Nadu', Special_Branches__c = true);
        insert bm;
        
        genesis__Applications__c app=TestUtility.intialSetUp('LAP',true) ;
        app.RecordTypeId = record_type_HL;
        app.Open_CASA_Account__c = 'N/A';
        app.Plan_Approval_available__c = 'N/A';
        app.Verify_Sale_Agreement__c = 'N/A';
        app.Verify_Construction__c = 'N/A';
        app.Verify_Advance_Payment__c = 'N/A';
        app.Execute_Tripartite_Agreement__c = 'N/A';
        app.Verify_Latest_EC__c = 'N/A';
        app.Verify_NOC__c = 'N/A';
        app.Verify_Margin_Payment__c = 'N/A';
        app.Complete_E_KYC_for_NTB_customers__c = 'N/A';
        app.Branch_Code__c = '1857';
        app.Tripartite_Agreement__c = true;
        app.Branch_City__c = '1857';
        app.Sub_Stage__c = 'Loan Requirement Captured';
      //   app.Sub_Stage__c = 'Terms and Conditions Accepted';
        app.genesis__CL_Product__c = product.id;
        app.Tripartite_Agreement__c=false;
        update app;
        
        genesis__Application_Parties__c appPar = new genesis__Application_Parties__c(genesis__Application__c = app.Id, genesis__Party_Type__c = 'Primary Applicant');
        insert appPar;
        
        genesis__Applications__c app1 = [select id,Record_Type_Name__c,genesis__CL_Product__c, Sub_Stage__c,Tripartite_Agreement__c,Branch_City__c,Branch_Code__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id from genesis__Application_Parties__r) from genesis__Applications__c where id =: app.Id];
        
        List<genesis__Applications__c> appnewList=new List<genesis__Applications__c>();
        appnewList.add(app1);
        
        genesis__Applications__c app2= new genesis__Applications__c();
        app2.Id = app.Id;
        app2.RecordTypeId = record_type_HL;
        app2.Open_CASA_Account__c = 'Yes';
        app2.Plan_Approval_available__c = 'Yes';
        app2.Verify_Sale_Agreement__c = 'Yes';
        app2.Verify_Construction__c = 'Yes';
        app2.Verify_Advance_Payment__c = 'Yes';
        app2.Execute_Tripartite_Agreement__c = 'Yes';
        app2.Verify_Latest_EC__c = 'Yes';
        app2.Verify_NOC__c = 'Yes';
        app2.Verify_Margin_Payment__c = 'Yes';
        app2.Complete_E_KYC_for_NTB_customers__c = 'Yes';
      //  app2.Tripartite_Agreement__c = true;
       // app2.Sub_Stage__c = 'Work Information Captured'; 
       app2.Sub_Stage__c = 'Terms and Conditions Accepted';
        update app2;
        
        app2 = [select id,Record_Type_Name__c,Branch_City__c,Branch_Code__c,Tripartite_Agreement__c,Sub_Stage__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id from genesis__Application_Parties__r) from genesis__Applications__c where id =: app2.id];
        
        Map<id,genesis__Applications__c> oldmap=new  Map<id,genesis__Applications__c>();
        oldmap.put(app2.id, app2);
        
        Test.startTest();
            Calculate_Estamp_HL.HLScoreRejectionScenario(appnewList, oldmap);
        	Calculate_Estamp_HL.BranchRejectionHL(appnewList, oldmap);
        Test.stopTest();
    }
     public testMethod static void method4(){
        Id record_type_HL = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();    
		
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='LAP');
        insert product;
        
        Branch_Master__c bm = new Branch_Master__c(CODCCBRN__c = '1857',State__c = 'Tamil Nadu', Special_Branches__c = true);
        insert bm;
        
        genesis__Applications__c app=TestUtility.intialSetUp('LAP',true) ;
        app.RecordTypeId = record_type_HL;
        app.Open_CASA_Account__c = 'N/A';
        app.Plan_Approval_available__c = 'N/A';
        app.Verify_Sale_Agreement__c = 'N/A';
        app.Verify_Construction__c = 'N/A';
        app.Verify_Advance_Payment__c = 'N/A';
        app.Execute_Tripartite_Agreement__c = 'N/A';
        app.Verify_Latest_EC__c = 'N/A';
        app.Verify_NOC__c = 'N/A';
        app.Verify_Margin_Payment__c = 'N/A';
        app.Complete_E_KYC_for_NTB_customers__c = 'N/A';
        app.Branch_Code__c = '1857';
        app.Tripartite_Agreement__c = true;
        app.Branch_City__c = '1857';
        app.Sub_Stage__c = 'Loan Requirement Captured';
      //   app.Sub_Stage__c = 'Terms and Conditions Accepted';
        app.genesis__CL_Product__c = product.id;
        app.Tripartite_Agreement__c=false;
        update app;
        
        genesis__Application_Parties__c appPar = new genesis__Application_Parties__c(genesis__Application__c = app.Id, genesis__Party_Type__c = 'Primary Applicant');
        insert appPar;
        
        genesis__Applications__c app1 = [select id,Record_Type_Name__c,genesis__CL_Product__c, Sub_Stage__c,Tripartite_Agreement__c,Branch_City__c,Branch_Code__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id from genesis__Application_Parties__r) from genesis__Applications__c where id =: app.Id];
        
        List<genesis__Applications__c> appnewList=new List<genesis__Applications__c>();
        appnewList.add(app1);
        
        genesis__Applications__c app2= new genesis__Applications__c();
        app2.Id = app.Id;
        app2.RecordTypeId = record_type_HL;
        app2.Open_CASA_Account__c = 'Yes';
        app2.Plan_Approval_available__c = 'Yes';
        app2.Verify_Sale_Agreement__c = 'Yes';
        app2.Verify_Construction__c = 'Yes';
        app2.Verify_Advance_Payment__c = 'Yes';
        app2.Execute_Tripartite_Agreement__c = 'Yes';
        app2.Verify_Latest_EC__c = 'Yes';
        app2.Verify_NOC__c = 'Yes';
        app2.Verify_Margin_Payment__c = 'Yes';
        app2.Complete_E_KYC_for_NTB_customers__c = 'Yes';
        app2.Tripartite_Agreement__c = true;
       // app2.Sub_Stage__c = 'Work Information Captured'; 
       app2.Sub_Stage__c = 'Terms and Conditions Accepted';
        update app2;
        
        app2 = [select id,Record_Type_Name__c,Branch_City__c,Branch_Code__c,Tripartite_Agreement__c,Sub_Stage__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id from genesis__Application_Parties__r) from genesis__Applications__c where id =: app2.id];
        
        Map<id,genesis__Applications__c> oldmap=new  Map<id,genesis__Applications__c>();
        oldmap.put(app2.id, app2);
        
        Test.startTest();
            Calculate_Estamp_HL.HLScoreRejectionScenario(appnewList, oldmap);
        	Calculate_Estamp_HL.BranchRejectionHL(appnewList, oldmap);
        Test.stopTest();
    }

    //add for branch code
    public testMethod static void method5(){

        
        Id record_type_HL = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();    
		
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='LAP');
        insert product;
        
        Branch_Master__c bm = new Branch_Master__c(CODCCBRN__c = '1857',State__c = 'Tamil Nadu', Special_Branches__c = true);
        insert bm;
        
        genesis__Applications__c app=TestUtility.intialSetUp('LAP',true) ;
        app.RecordTypeId = record_type_HL;
        app.Open_CASA_Account__c = 'N/A';
        app.Plan_Approval_available__c = 'N/A';
        app.Verify_Sale_Agreement__c = 'N/A';
        app.Verify_Construction__c = 'N/A';
        app.Verify_Advance_Payment__c = 'N/A';
        app.Execute_Tripartite_Agreement__c = 'N/A';
        app.Verify_Latest_EC__c = 'N/A';
        app.Verify_NOC__c = 'N/A';
        app.Verify_Margin_Payment__c = 'N/A';
        app.Complete_E_KYC_for_NTB_customers__c = 'N/A';
        app.Branch_Code__c = '1857';
        app.Tripartite_Agreement__c = true;
        app.Branch_City__c = '1857';
        app.Sub_Stage__c = 'Property Information Captured';
      //   app.Sub_Stage__c = 'Terms and Conditions Accepted';
        app.genesis__CL_Product__c = product.id;
        app.Tripartite_Agreement__c=false;
        update app;
        
        genesis__Application_Parties__c appPar = new genesis__Application_Parties__c(genesis__Application__c = app.Id, genesis__Party_Type__c = 'Primary Applicant',Active__c=true,Company__c=false,CIBIL_Scores__c=720);
        insert appPar;
        
        genesis__Applications__c app1 = [select id,Record_Type_Name__c,genesis__CL_Product__c, Sub_Stage__c,Tripartite_Agreement__c,Branch_City__c,Branch_Code__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id,genesis__Party_Type__c,Active__c,Company__c from genesis__Application_Parties__r) from genesis__Applications__c where id =: app.Id];
        
        List<genesis__Applications__c> appnewList=new List<genesis__Applications__c>();
        appnewList.add(app1);
        
        genesis__Applications__c app2= new genesis__Applications__c();
        app2.Id = app.Id;
        app2.RecordTypeId = record_type_HL;
        app2.Open_CASA_Account__c = 'Yes';
        app2.Plan_Approval_available__c = 'Yes';
        app2.Verify_Sale_Agreement__c = 'Yes';
        app2.Verify_Construction__c = 'Yes';
        app2.Verify_Advance_Payment__c = 'Yes';
        app2.Execute_Tripartite_Agreement__c = 'Yes';
        app2.Verify_Latest_EC__c = 'Yes';
        app2.Verify_NOC__c = 'Yes';
        app2.Verify_Margin_Payment__c = 'Yes';
        app2.Complete_E_KYC_for_NTB_customers__c = 'Yes';
        app2.Tripartite_Agreement__c = true;
        app2.Branch_Code__c= '1857';
       app2.Sub_Stage__c = 'Work Information Captured'; 
      // app2.Sub_Stage__c = 'Property Information Captured';
        update app2;
        
        app2 = [select id,Record_Type_Name__c,Branch_City__c,Branch_Code__c,Tripartite_Agreement__c,Sub_Stage__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id,genesis__Party_Type__c,Company__c,Active__c,CIBIL_Scores__c from genesis__Application_Parties__r) from genesis__Applications__c where id =: app2.id];
        
        Map<id,genesis__Applications__c> oldmap=new  Map<id,genesis__Applications__c>();
        oldmap.put(app2.id, app2);
        
        Test.startTest();
            Calculate_Estamp_HL.HLScoreRejectionScenario(appnewList, oldmap);
        	Calculate_Estamp_HL.BranchRejectionHL(appnewList, oldmap);
        Test.stopTest();
    }

     //add for branch code
    public testMethod static void method6(){
        
        Id record_type_HL = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();    
		
        clcommon__CL_Product__c product = new clcommon__CL_Product__c(clcommon__Product_Name__c='LAP',Special_Branches_Cutoff__c=800);
        insert product;
        
        Branch_Master__c bm = new Branch_Master__c(CODCCBRN__c = '1857',State__c = 'Tamil Nadu', Special_Branches__c = true);
        insert bm;
        
        genesis__Applications__c app=TestUtility.intialSetUp('LAP',true) ;
        app.RecordTypeId = record_type_HL;
        app.Open_CASA_Account__c = 'N/A';
        app.Plan_Approval_available__c = 'N/A';
        app.Verify_Sale_Agreement__c = 'N/A';
        app.Verify_Construction__c = 'N/A';
        app.Verify_Advance_Payment__c = 'N/A';
        app.Execute_Tripartite_Agreement__c = 'N/A';
        app.Verify_Latest_EC__c = 'N/A';
        app.Verify_NOC__c = 'N/A';
        app.Verify_Margin_Payment__c = 'N/A';
        app.Complete_E_KYC_for_NTB_customers__c = 'N/A';
        app.Branch_Code__c = '1857';
        app.Tripartite_Agreement__c = true;
        app.Branch_City__c = '1857';
        app.Sub_Stage__c = 'Property Information Captured';
      //   app.Sub_Stage__c = 'Terms and Conditions Accepted';
        app.genesis__CL_Product__c = product.id;
        app.Tripartite_Agreement__c=false;
        update app;
        
        genesis__Application_Parties__c appPar = new genesis__Application_Parties__c(genesis__Application__c = app.Id, genesis__Party_Type__c = 'Co-Borrower',Active__c=true,Company__c=false,CIBIL_Scores__c=720);
        insert appPar;
        
        genesis__Applications__c app1 = [select id,Record_Type_Name__c,genesis__CL_Product__c, Sub_Stage__c,Tripartite_Agreement__c,Branch_City__c,Branch_Code__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id,genesis__Party_Type__c,Active__c,Company__c from genesis__Application_Parties__r) from genesis__Applications__c where id =: app.Id];
        
        List<genesis__Applications__c> appnewList=new List<genesis__Applications__c>();
        appnewList.add(app1);
        
        genesis__Applications__c app2= new genesis__Applications__c();
        app2.Id = app.Id;
        app2.RecordTypeId = record_type_HL;
        app2.Open_CASA_Account__c = 'Yes';
        app2.Plan_Approval_available__c = 'Yes';
        app2.Verify_Sale_Agreement__c = 'Yes';
        app2.Verify_Construction__c = 'Yes';
        app2.Verify_Advance_Payment__c = 'Yes';
        app2.Execute_Tripartite_Agreement__c = 'Yes';
        app2.Verify_Latest_EC__c = 'Yes';
        app2.Verify_NOC__c = 'Yes';
        app2.Verify_Margin_Payment__c = 'Yes';
        app2.Complete_E_KYC_for_NTB_customers__c = 'Yes';
        app2.Tripartite_Agreement__c = true;
        app2.Branch_Code__c= '1857';
       app2.Sub_Stage__c = 'Work Information Captured'; 
      // app2.Sub_Stage__c = 'Property Information Captured';
        update app2;
        
        app2 = [select id,Record_Type_Name__c,Branch_City__c,Branch_Code__c,Tripartite_Agreement__c,Sub_Stage__c,RecordTypeId,Verify_Advance_Payment__c,Complete_E_KYC_for_NTB_customers__c,Verify_Margin_Payment__c,Verify_NOC__c,Verify_Latest_EC__c, Execute_Tripartite_Agreement__c, Open_CASA_Account__c,Plan_Approval_available__c,Loan_Purpose__c, Verify_Sale_Agreement__c,Verify_Construction__c ,(select id,genesis__Party_Type__c,Company__c,Active__c,CIBIL_Scores__c from genesis__Application_Parties__r) from genesis__Applications__c where id =: app2.id];
        
        Map<id,genesis__Applications__c> oldmap=new  Map<id,genesis__Applications__c>();
        oldmap.put(app2.id, app2);
        
        Test.startTest();
            Calculate_Estamp_HL.HLScoreRejectionScenario(appnewList, oldmap);
        	Calculate_Estamp_HL.BranchRejectionHL(appnewList, oldmap);
        Test.stopTest();
    }

}