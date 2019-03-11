//written by anonymous
//modified by prashant singh
//code coverage:-90% 
//date:-05-10-2018
//class:---Ws_PerfiosUpdate + HL_ITRCallingAPI
@isTest
public class Test_Ws_PerfiosUpdate {
    public static testMethod void perfiosUpdateMethod1(){
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvb1;
        KVB_Endpoint_URLs__c kvb  = new KVB_Endpoint_URLs__c(name='ITRReport',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/analysis/itr/report');
        insert kvb;
      
        Blob b = Blob.valueOf(getData('BS'));
        System.debug('b:::'+b);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', b);
        Test.startTest();
        Ws_PerfiosUpdate.CreateBankaccounts();
        Test.stopTest();
    }
    public static testMethod void perfiosUpdateMethod2(){
        
        
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc;
        genesis__applications__c app = VL_Test_Utility.createApplication('1857',acc.id,'Loan account open','Home Loan');
        insert app;
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
            '"Status" : "Completed",'+
            '"BSuploadType" : "netbanking",'+
            '"ApplicationID" : "'+app.Id+'",'+
            '"Url" : "http://www.abcd.com/",'+
            '"BankName" : "Axis Bank",'+
            '"Method" : "BS",'+
            '"RequestID2" : "12121",'+
            '"Account_Numbers" :[{'+
            '"BankAccNumber" : "1312212"'+
            '}]'+
            '}';
        Blob b = Blob.valueOf(jSon);
        
         
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', b);
        Test.startTest();
        Ws_PerfiosUpdate.CreateBankaccounts();
        HL_ITRCallingAPI.callform26AS('ITR','1212');
        Test.stopTest();
    }
    
    public static testMethod void perfiosUpdateMethod3(){
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'Apigee_Access_Token';
        KVB1.Endpoint_URL__c = 'https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken';
        kvb1.Username__c='prashant singh';
     	insert kvb1;
        KVB_Endpoint_URLs__c kvb2 = new KVB_Endpoint_URLs__c();
     	KVB2.Name = 'ITRReport';
        KVB2.Endpoint_URL__c = 'https://kvb-test.apigee.net/next/v1/analysis/itr/report?reportFormat=json&requestId=1212';
     	insert kvb2;
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc;
        genesis__applications__c app = VL_Test_Utility.createApplication('1857',acc.id,'Loan account open','Home Loan');
        insert app;
        String jSon = '{'+
            '"ClientID" : "'+acc.Id+'",'+
            '"RequestID" : "3434343",'+
            '"Txn_ID" : "12121",'+
            '"Status" : "Completed",'+
            '"BSuploadType" : "netbanking",'+
            '"ApplicationID" : "'+app.Id+'",'+
            '"Url" : "http://www.abcd.com/",'+
            '"BankName" : "Axis Bank",'+
            '"Method" : "ITR",'+
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
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', b);
        Test.startTest();
        Ws_PerfiosUpdate.CreateBankaccounts();
        HL_ITRCallingAPI.callform26AS('json','1212');
        Test.stopTest();
    }
    /* public static testMethod void perfiosUpdateMethod4(){
TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', null);
Test.startTest();
Ws_PerfiosUpdate.CreateBankaccounts();
Test.stopTest();
}*/
    
    public static String getData(String method){
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
            '"Url" : "http://www.abcd.com/",'+
            '"BankName" : "Axis Bank",'+
            '"Method" : "'+method+'",'+
            '"RequestID2" : "12121",'+
            '"Account_Numbers" :[{'+
            '"BankAccNumber" : "1312212"'+
            '}]'+
            '}';
        System.debug('jSon:::'+jSon);
        return jSon;
    }
    
    ////for new
      public static testMethod void perfiosUpdateMethod5(){

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
'"Status" : "Completed",'+
'"BSuploadType" : "netbanking",'+
'"ApplicationID" :"12121",'+
'"Url" : "http://www.abcd.com/",'+
'"BankName" : "Axis Bank",'+
'"Method" : "ITR",'+
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
Ws_PerfiosUpdate.CreateBankaccounts();
Test.stopTest();
}
    public static testMethod void perfiosUpdateMethod6(){
        
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc;
        genesis__applications__c app = VL_Test_Utility.createApplication('1857',acc.id,'Loan account open','Home Loan');
        insert app;
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
            '"Status" : "Completed",'+
            '"BSuploadType" : "netbanking",'+
            '"ApplicationID" : "'+app.Id+'",'+          
            '"BankName" : "Axis Bank",'+
            '"Method" : "BS",'+
            '"RequestID2" : "12121",'+
            '"Account_Numbers" :[{'+
            '"BankAccNumber" : "1312212"'+
            '}]'+
            '}';
        Blob b = Blob.valueOf(jSon);
        
        
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', b);
        Test.startTest();
        Ws_PerfiosUpdate.CreateBankaccounts();
        Test.stopTest();
    }
  public static testMethod void perfiosUpdateMethod7(){
        
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc;
        genesis__applications__c app = VL_Test_Utility.createApplication('1857',acc.id,'Loan account open','Home Loan');
        insert app;
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
            '"Status" : "NACompleted",'+
            '"BSuploadType" : "netbanking",'+
            '"ApplicationID" : "'+app.Id+'",'+          
            '"BankName" : "Axis Bank",'+
            '"Method" : "BS",'+
            '"RequestID2" : "12121",'+
            '"Account_Numbers" :[{'+
            '"BankAccNumber" : "1312212"'+
            '}]'+
            '}';
        Blob b = Blob.valueOf(jSon);
        
        
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', b);
        Test.startTest();
        Ws_PerfiosUpdate.CreateBankaccounts();
        Test.stopTest();
    }
    public static testMethod void perfiosUpdateMethod9(){
        
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc;
        genesis__applications__c app = VL_Test_Utility.createApplication('1857',acc.id,'Loan account open','Home Loan');
        insert app;
        Perfios__c perf = new Perfios__c();
        perf.Applicant_Name__c = acc.id;
        perf.Active__c=true;
        perf.Application__c=app.id;
        perf.Bank_Account_Number__c='1312212';
        INSERT perf;
        String jSon = '{'+
            '"ClientID" : "pp",'+
            '"RequestID" : "3434343",'+
            '"Txn_ID" : "12121",'+
            '"Status" : "Completed",'+
            '"BSuploadType" : "netbanking",'+
            '"ApplicationID" : "'+app.Id+'",'+
            '"Url" : "http://www.abcd.com/",'+
            '"BankName" : "Axis Bank",'+
            '"Method" : "BS",'+
            '"RequestID2" : "12121",'+
            '"Account_Numbers" :[{'+
            '"BankAccNumber" : "1312212"'+
            '}]'+
            '}';
        Blob b = Blob.valueOf(jSon);
        
        
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', b);
        Test.startTest();
        Ws_PerfiosUpdate.CreateBankaccounts();
        Test.stopTest();
    }
    
}