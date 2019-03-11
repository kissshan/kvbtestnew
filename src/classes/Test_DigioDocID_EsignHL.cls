@isTest
public class Test_DigioDocID_EsignHL {
    @isTest
    public static void methodDocumentIDGeneration(){
        genesis__Applications__c genApp = TestUtility.intialSetUp('Home Loan', true);
        Test.startTest();
        DigioDocID_EsignHL.DocumentIDGeneration(genApp.Id, 'Filename', 10, 'class2doc');
        Test.stopTest();
    }

}