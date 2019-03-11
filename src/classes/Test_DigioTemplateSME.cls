@IsTest
private class Test_DigioTemplateSME{

    static testmethod void testDigioTemplateService(){
        Test.StartTest();
        genesis__Applications__c app = TestUtility.intialSetUp('SME',false);
        
        genesis__Application_Parties__c party   = new genesis__Application_Parties__c();
        party.genesis__Party_Type__c            = 'Guarantor';
        party.genesis__Application__c           = app.Id;
        Test.StopTest();
        
    
    }
}