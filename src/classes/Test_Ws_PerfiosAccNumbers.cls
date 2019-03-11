//written by prashant singh.
//code coverage:--93%
//class:--Ws_PerfiosAccNumbers
@istest
public class Test_Ws_PerfiosAccNumbers {
       public static testMethod void method1(){
         
         Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
         genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
         Account acc = new Account();
         acc.LastName = 'Ashish';
         acc.Full_Name__c = 'Ashish G Jain';
         acc.PersonEmail = 'qulity@data.com';
         acc.PersonMobilePhone = '2335232345'; 
         acc.RecordTypeID = RecordTypeIdclPerson;
         insert acc; 
            String jSon = '{'+
                '"ClientID" : "'+acc.Id+'",'+
                '"RequestID" : "3434343",'+
                '"Txn_ID" : "12121",'+
                '"Status" : "pass",'+
                '"BSuploadType" : "netbanking",'+
                '"ApplicationID" : "'+app.Id+'",'+
                '"Url" : null,'+
                '"BankName" : "Axis Bank",'+
                '"Method" : "BS",'+
                '"RequestID2" : "12121",'+
                '"Account_Numbers" :[{'+
                '"BankAccNumber" : "1312212"'+
                '}]'+
             '}';
        Blob b = Blob.valueOf(jSon);
          Perfios__c perf = new Perfios__c();
        perf.Applicant_Name__c = acc.id;
         perf.Active__c=true;
         perf.Application__c=app.id;
         perf.Bank_Account_Number__c='1312212';
        INSERT perf;
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', b);
        Test.startTest();
        Ws_PerfiosAccNumbers.CreateBankaccounts();
        Test.stopTest();
    }
     public static testMethod void method2(){
         
         Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
         genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
         Account acc = new Account();
         acc.LastName = 'Ashish';
         acc.Full_Name__c = 'Ashish G Jain';
         acc.PersonEmail = 'qulity@data.com';
         acc.PersonMobilePhone = '2335232345'; 
         acc.RecordTypeID = RecordTypeIdclPerson;
         insert acc; 
          Perfios__c perf = new Perfios__c();
        perf.Applicant_Name__c = acc.id;
         perf.Active__c=true;
         perf.Application__c=app.id;
         perf.Bank_Account_Number__c='1312212';
        INSERT perf; 
            String jSon = '{'+
                '"ClientID" : "'+acc.Id+'",'+
                '"RequestID" : "3434343",'+
                '"Txn_ID" : "12121",'+
                '"Status" : "pass",'+
                '"BSuploadType" : "netbanking",'+
                '"ApplicationID" : "'+app.Id+'",'+
                '"Url" : null,'+
                '"BankName" : "Axis Bank",'+
                '"Method" : "BS",'+
                '"RequestID2" : "12121",'+
                '"Account_Numbers" :[{'+
                '"BankAccNumber" : "1312212",'+'"RecordID" : "'+perf.id+'",'+'"Deleted":"mm"'+
                '}]'+
             '}';
        Blob b = Blob.valueOf(jSon);
         
        
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', b);
        Test.startTest();
        Ws_PerfiosAccNumbers.CreateBankaccounts();
        Test.stopTest();
    }
     public static testMethod void perfiosUpdateMethod4(){
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', null);
        Test.startTest();
        Ws_PerfiosAccNumbers.CreateBankaccounts();
        Test.stopTest();
    }
}