@isTest
public class Test_Ws_PerfiosGetDetaisl {
    @isTest
    public static void method1(){
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc; 
        genesis__Application_Parties__c party =new genesis__Application_Parties__c();
        party.Key_Contact__c = acc.id;
        party.genesis__Party_Account_Name__c=acc.id;
        party.genesis__Party_Type__c = Constants.Co_Borrower;
        party.genesis__Application__c=app.id;
        party.Employment_Types__c='other';
        party.NMI_as_per_ITR__c	=10000;
        party.ITR_Uploaded__c=true;
        party.NMI_as_per_BS__c=287877;
        party.NMI_as_per_26AS__c=77777;
        
        insert party;
        Perfios__c perf = new Perfios__c();
        perf.Applicant_Name__c = acc.id;
        perf.Active__c=true;
        perf.Application__c=app.id;
        perf.Bank_Account_Number__c='1185156000000445';
        INSERT perf;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GetPerfiosDetails'; 
        req.httpMethod  = 'GET';
        req.params.put('AppID',app.id);
        req.params.put('AccID',acc.id);
        
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        Ws_PerfiosGetDetaisl.getDetails();
        Test.stopTest();
    }
}