/* Pusrpose: Test class for Class Name: WS_CBS_MIS_Update_HL
* Author: Ankur Koul
* Last modified by:17/8/2018
* Code Coverage : 87%--updated coverage
*/
@isTest
public class Test_WS_CBS_MIS_Update_HL 
{
    @isTest
    public static void Mis_Update()
    {
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
        genesis__Applications__c genApp= SME_TestUtil.createApplication('Chennai',acc.Id,'Application Filling','FI Approved','Submission');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Loan_Account_Number__c='test12333';
        insert genApp;
        
        insert new KVB_Endpoint_URLs__c(name ='CBS_MIS_Update',Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF');

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CBS_MIS_Update_HL.Mis_Update(genApp.Id,UpcbsLog);
        Test.stopTest();
    }
    @isTest
    public static void Mis_Update_1()
    {
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        list<CBS_API_Log__c> UpcbsLog = new List<CBS_API_Log__c>();
        
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Personal Loan').getRecordTypeId();
        genesis__Applications__c genApp= SME_TestUtil.createApplication('Chennai',acc.Id,'Application Filling','FI Approved','Submission');
        genApp.RecordTypeId=genAppRecordType;
        genApp.Loan_Account_Number__c='test12333';
        insert genApp;
        
        insert new KVB_Endpoint_URLs__c(name ='CBS_MIS_Update',Endpoint_URL__c = 'http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_MIS_XREF1');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        WS_CBS_MIS_Update_HL.Mis_Update(genApp.Id,UpcbsLog);
        Test.stopTest();
    }
}