@isTest
public class Test_APPDocCategoryCreation {
    public static genesis__Applications__c genApp;
    public static genesis__Document_Category__c genDocCat;
    public static Account acc;
    
    @isTest
    public static void init(){
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genDocCat = TestUtility.createDocumentCat(Constants.FIReport);
        acc = new Account(name = 'Priti@');
    }
    @isTest
    public static void methodCreateDocCat(){
        init();
        
        APPDocCategoryCreation.CreateDocCat(genApp, acc, true);
        APPDocCategoryCreation.CreateDocCat(genApp, acc, false);
    }
     @isTest
    public static void methodCreateDocCat2(){
        init();
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL4W').getRecordTypeId(); 
        genApp.RecordTypeId=RecordTypeIdgenApp;
        update genApp;
        genApp=[select id,name,Branch_Code__c,Pre_approved_flag__c,RecordTypeId,Application_Score__c,Record_Type_Name__c,genesis__Loan_Amount__c,Sub_Stage__c,genesis__Interest_Rate__c,genesis__Term__c,(select id,Existing_Emis__c,Agriculture2__c,genesis__Party_Account_Name__c,genesis__Party_Type__c,Max_Existing_EMI__c,Annual_Other_IncomeRecurring_CreditsITR__c,
                                CIBIL_Scores__c,Approved_NMI_From_ITR__c,Additional_Income_Amount1__c,
                                NMI_Approved__c,NMI_Claimed_By_Customer__c,Employment_Types__c,Net_Monthly_Income__c,Age_In_Months__c,
                                Financial_Applicant__c,genesis__Party_Account_Name__r.age__c from genesis__Application_Parties__r where Active__c=true AND Company__c = false)from genesis__Applications__c where id =:genApp.id];
       

        APPDocCategoryCreation.CreateDocCat(genApp, acc, true);
        APPDocCategoryCreation.CreateDocCat(genApp, acc, false);
    }

}