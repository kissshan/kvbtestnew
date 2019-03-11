/*
 * Purpose : Test class for the CommercialPRBatch_RUN class 
 *Author :uday ----> 75% 
 */
@isTest
public class CommercialPRBatch_RUN_Test {
 public static testmethod void testMethod1() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Pan_Number__c='Doapk2819k';
            acc.BillingCity='Bangalore';
            acc.BillingState='Karnataka';
            acc.BillingPostalCode='86987';
            insert acc;
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Application_Stage__c='Identified for renewal';
            genApp.CommercialPR_Stage__c='Not Initiated';
            //genApp.Execute_batch_in_days__c=7;
            genApp.Active__c=true;
            genApp.genesis__Loan_Amount__c=100000;
            insert genApp;
            
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
        KVB1.Name = 'CommercialPR Req';
        KVB1.Endpoint_URL__c = 'https://www.kvbbank.co.in/bpmsUAT/rest/CueRest/invokeESBService/COMM_PR_REQ';
        insert kvb1; 
           
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
            CommercialPRBatch ob=new CommercialPRBatch('Application_Stage__c =:stage AND CommercialPR_Stage__c IN :setCommercialPRStage AND Execute_batch_in_days__c <=:days AND Active__c = true AND genesis__Account__r.Pan_Number__c != NULL AND genesis__Account__r.BillingCity != NULL AND genesis__Account__r.BillingState != NULL AND genesis__Account__r.BillingPostalCode != NULL AND genesis__Loan_Amount__c != NULL');
            DataBase.executeBatch(ob);
            Test.stopTest();
        }
     }
    public static testmethod void testMethod2() {
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            acc.Pan_Number__c='Doapk2819k';
            acc.BillingCity='Bangalore';
            acc.BillingState='Karnataka';
            acc.BillingPostalCode='86987';
            insert acc;
            
            genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
            genApp.Application_Stage__c='Identified for renewal';
            genApp.CommercialPR_Stage__c='Not Initiated';
            //genApp.Execute_batch_in_days__c=7;
            genApp.Active__c=true;
            genApp.genesis__Loan_Amount__c=100000;
            insert genApp;
           
            Test.startTest();
            CommercialPRBatch ob=new CommercialPRBatch('');
            DataBase.executeBatch(ob);
            Test.stopTest();
        }
     }
}