@isTest
public class Retry_Task_call_VL_Test {

     @isTest
    public static void method1(){
       /* Account acc=VL_Test_Utility.createAccount('TestName', '1857','678906','KVB');
        insert acc;
        genesis__Applications__c genApp=VL_Test_Utility.createApplication('1857',acc.id,'Terms and Conditions Accepted','VL4W');
        insert genApp;
        genApp.genesis__Term__c=8;
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL2W').getRecordTypeId(); 
        genApp.RecordTypeId=RecordTypeIdgenApp;
        update genApp;*/
        
        //
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true);
        genesis__Applications__c genApp=applist[0];
        genApp.genesis__Term__c=10;
        genApp.Pre_approved_flag__c=true;
        update genApp;
        clcommon__CL_Product__c clpro=VL_Test_Utility.createProduct('Digital Two wheeler loan - 745');
        insert clpro;
        genApp=[select id,name,Pre_approved_flag__c,RecordTypeId,Application_Score__c,Record_Type_Name__c,genesis__Loan_Amount__c,Sub_Stage__c,genesis__Interest_Rate__c,genesis__Term__c,(select id,Existing_Emis__c,Agriculture2__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false)from genesis__Applications__c where id =:applist[0].id];
       
        Test.startTest();
        Retry_Task_call_VL.RecalculateEligibilityVL(genApp,'0');
        Test.stopTest();
    }
     @isTest
    public static void method2(){
       Branch_Master__c bb=VL_Test_Utility.getbranchmaster('A','Kolkata','1857');
        insert bb;
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true);
        genesis__Applications__c genApp=applist[1];
        genApp.genesis__Term__c=10;
        genApp.Branch_Code__c='1857';
        genApp.Pre_approved_flag__c=true;
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL4W').getRecordTypeId(); 
        genApp.RecordTypeId=RecordTypeIdgenApp;
        update genApp;
        MCLR_Excess_Code__c mm=new MCLR_Excess_Code__c();
        mm.Employment_Type__c='Salaried';
        mm.Excess__c=9.5;
        mm.From_CIBIL__c=750;
        mm.Name='testExcess1';
        mm.Product_Name__c='VL4W';
        mm.TO_CIBIL__c=800;
        mm.Retail_Category__c='A';
        insert mm;
        MCLR_Master__c mcMaster=new MCLR_Master__c();
        mcMaster.COD_Term_From__c=365;
        mcMaster.MCLR_Of_Interest__c=10;
        insert mcMaster;
        clcommon__CL_Product__c clpro=VL_Test_Utility.createProduct('Digital four wheeler loan - 775');
        insert clpro;
        genApp=[select id,name,Branch_Code__c,Pre_approved_flag__c,RecordTypeId,Application_Score__c,Record_Type_Name__c,genesis__Loan_Amount__c,Sub_Stage__c,genesis__Interest_Rate__c,genesis__Term__c,(select id,Existing_Emis__c,Agriculture2__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false)from genesis__Applications__c where id =:genApp.id];
       
        Test.startTest();
        Retry_Task_call_VL.RecalculateEligibilityVL(genApp,'3');
        Test.stopTest();
    }
    
      @isTest
    public static void method3(){
       
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true);
        genesis__Applications__c genApp=applist[0];
        genApp.genesis__Term__c=10;
        genApp.Pre_approved_flag__c=true;
        genApp.Max_CIBIL_Score__c=751;
        update genApp;
        clcommon__CL_Product__c clpro=VL_Test_Utility.createProduct('Digital Two wheeler loan - 745');
        insert clpro;
        genApp=[select id,Max_CIBIL_Score__c,name,Pre_approved_flag__c,RecordTypeId,Application_Score__c,Record_Type_Name__c,genesis__Loan_Amount__c,Sub_Stage__c,genesis__Interest_Rate__c,genesis__Term__c,(select id,Existing_Emis__c,Agriculture2__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false)from genesis__Applications__c where id =:applist[0].id];
       
        Test.startTest();
        Retry_Task_call_VL.RecalculateEligibilityVL(genApp,'3');
        Test.stopTest();
    }
    
     @isTest
    public static void method4(){
       
         Trigger_Setting__c custmsetting=new Trigger_Setting__c();
        custmsetting.Execute_Application_Trigger__c=true;
        insert custmsetting;
        ApplicationTriggerHandler.IsFirstRun=true;
        String customLabelValue = System.Label.VL_Waiver_Percent;
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true);
        genesis__Applications__c genApp =new genesis__Applications__c();
        genApp.id=applist[0].id;
        genApp.genesis__Term__c=10;
        genApp.Sub_Stage__c='Terms and Conditions Accepted';
        genApp.Pre_approved_flag__c=true;
        genApp.Perfios_Captured__c=true;
        update genApp;
      /*  clcommon__CL_Product__c clpro=VL_Test_Utility.createProduct('Digital Two wheeler loan - 745');
        insert clpro;
        genApp=[select id,name,Pre_approved_flag__c,RecordTypeId,Application_Score__c,Record_Type_Name__c,genesis__Loan_Amount__c,Sub_Stage__c,genesis__Interest_Rate__c,genesis__Term__c,(select id,Existing_Emis__c,Agriculture2__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false)from genesis__Applications__c where id =:applist[0].id];
       
        Test.startTest();
        Retry_Task_call_VL.RecalculateEligibilityVL(genApp,'3');
        Test.stopTest();*/
    }
    
        @isTest
    public static void method5(){
        Test.startTest();
        MCLR_Excess_Code__c mm=new MCLR_Excess_Code__c();
        mm.Employment_Type__c='Salaried';
        mm.Excess__c=9.5;
        mm.From_CIBIL__c=750;
        mm.Name='testExcess1';
        mm.Product_Name__c='VL2W';
        mm.TO_CIBIL__c=800;
        mm.Retail_Category__c='D';
        insert mm;
        MCLR_Master__c mcMaster=new MCLR_Master__c();
        mcMaster.COD_Term_From__c=365;
        mcMaster.MCLR_Of_Interest__c=10;
        insert mcMaster;
        
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true); 
        genesis__Applications__c genApp;
       
        clcommon__CL_Product__c clpro=VL_Test_Utility.createProduct('Digital Two wheeler loan - 774');
        insert clpro;
        genApp=[select id,Acknowledgement__c,Max_CIBIL_Score__c,name,Pre_approved_flag__c,RecordTypeId,Application_Score__c,Record_Type_Name__c,genesis__Loan_Amount__c,Sub_Stage__c,genesis__Interest_Rate__c,genesis__Term__c,(select id,Existing_Emis__c,Agriculture2__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false)from genesis__Applications__c where id =:applist[0].id];
        genApp.genesis__Term__c=10;
        genApp.Pre_approved_flag__c=true;
        genApp.Max_CIBIL_Score__c=751;
        genApp.Acknowledgement__c=true;
        update genApp;
       
        Retry_Task_call_VL.RecalculateEligibilityVL(genApp,'3');
        Test.stopTest();
    }
    
  @isTest
    public static void method6(){
        Test.startTest();
        MCLR_Excess_Code__c mm=new MCLR_Excess_Code__c();
        mm.Employment_Type__c='Salaried';
        mm.Excess__c=9.5;
        mm.From_CIBIL__c=750;
        mm.Name='testExcess1';
        mm.Product_Name__c='VL2W';
        mm.TO_CIBIL__c=800;
        mm.Retail_Category__c='D';
        insert mm;
        MCLR_Master__c mcMaster=new MCLR_Master__c();
        mcMaster.COD_Term_From__c=365;
        mcMaster.MCLR_Of_Interest__c=10;
        insert mcMaster;
        
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true); 
        genesis__Applications__c genApp;
       
        clcommon__CL_Product__c clpro=VL_Test_Utility.createProduct('Digital Two wheeler loan - 774');
        insert clpro;
        genApp=[select id,Acknowledgement__c,Max_CIBIL_Score__c,name,Pre_approved_flag__c,RecordTypeId,Application_Score__c,Record_Type_Name__c,genesis__Loan_Amount__c,Sub_Stage__c,genesis__Interest_Rate__c,genesis__Term__c,(select id,genesis__Party_Account_Name__r.Customer_ID_Creation_Date__c,Existing_Emis__c,Agriculture2__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false)from genesis__Applications__c where id =:applist[0].id];
        genApp.genesis__Term__c=10;
        genApp.Pre_approved_flag__c=true;
        genApp.Max_CIBIL_Score__c=751;
        genApp.Acknowledgement__c=true;
        genApp.PMin__c=1000;
        update genApp;
       
        Retry_Task_call_VL.RecalculateEligibilityVL(genApp,'3');
        Test.stopTest();
    }
    @isTest
    public static void method7(){
        Test.startTest();
        MCLR_Excess_Code__c mm=new MCLR_Excess_Code__c();
        mm.Employment_Type__c='Salaried';
        mm.Excess__c=9.5;
        mm.From_CIBIL__c=750;
        mm.Name='testExcess1';
        mm.Product_Name__c='VL2W';
        mm.TO_CIBIL__c=800;
        mm.Retail_Category__c='D';
        insert mm;
        MCLR_Master__c mcMaster=new MCLR_Master__c();
        mcMaster.COD_Term_From__c=365;
        mcMaster.MCLR_Of_Interest__c=10;
        insert mcMaster;
        
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true); 
        genesis__Applications__c genApp;
       
      
        
        clcommon__CL_Product__c clpro=VL_Test_Utility.createProduct('Digital Two wheeler loan - 774');
        insert clpro;
        genApp=[select id,Acknowledgement__c,Max_CIBIL_Score__c,name,Pre_approved_flag__c,RecordTypeId,Application_Score__c,Record_Type_Name__c,genesis__Loan_Amount__c,Sub_Stage__c,genesis__Interest_Rate__c,genesis__Term__c,(select id,Existing_Emis__c,Agriculture2__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false)from genesis__Applications__c where id =:applist[0].id];
        genApp.genesis__Term__c=10;
        genApp.Pre_approved_flag__c=true;
        genApp.Max_CIBIL_Score__c=751;
        genApp.Acknowledgement__c=true;
        update genApp;
        clcommon__Collateral__c cl=[select id,ExshowRoomPrice_Api__c,ExShow_Room_Price__c from clcommon__Collateral__c where genesis__Application__c=:genApp.id ];
        cl.ExshowRoomPrice_Api__c=300000;
        cl.ExShow_Room_Price__c=300001;
        update cl;
        Retry_Task_call_VL.RecalculateEligibilityVL(genApp,'1');
        Test.stopTest();
    }
       @isTest
    public static void method8(){
       
        List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true);
        genesis__Applications__c genApp=applist[0];
        genApp.genesis__Term__c=10;
        genApp.Pre_approved_flag__c=true;
        genApp.Max_CIBIL_Score__c=751;
        update genApp;
        clcommon__CL_Product__c clpro=VL_Test_Utility.createProduct('Digital Two wheeler loan - 745');
        insert clpro;
        genApp=[select id,Max_CIBIL_Score__c,name,Pre_approved_flag__c,RecordTypeId,Application_Score__c,Record_Type_Name__c,genesis__Loan_Amount__c,Sub_Stage__c,genesis__Interest_Rate__c,genesis__Term__c,(select id,Existing_Emis__c,Agriculture2__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false)from genesis__Applications__c where id =:applist[0].id];
         genesis__Application_Parties__c party=new genesis__Application_Parties__c();
        for(genesis__Application_Parties__c pp :genApp.genesis__Application_Parties__r){
          
            party.id=pp.id;
            
            party.Employment_Types__c='Agriculturist';
        }
        Update party;
        Test.startTest();
        Retry_Task_call_VL.RecalculateEligibilityVL(genApp,'3');
        Test.stopTest();
    }
    
}