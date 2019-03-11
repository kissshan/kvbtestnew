@isTest
public class Test_WS_CBS_Status_Update {
    public static string getData(string method){
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc; 
        
        WS_CBS_Status_Update.cbsStatusReq cbs = new WS_CBS_Status_Update.cbsStatusReq();
        cbs.ApiName = 'Test';
        cbs.ApplicationId = app.id;
        cbs.CbsStatus = new List<WS_CBS_Status_Update.acctReqWrapper>();
        WS_CBS_Status_Update.acctReqWrapper acct = new WS_CBS_Status_Update.acctReqWrapper();
        acct.ApplicantId = acc.id;
        acct.CustomerID = '333';
        acct.Status = 'Success';
        cbs.CbsStatus.add(acct);
        
        string json = json.serialize(cbs);
        System.debug('jSon:::'+jSon);
        return jSon;
    }
    public static string getData1(string method){
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc; 
        
        WS_CBS_Status_Update.cbsStatusReq cbs = new WS_CBS_Status_Update.cbsStatusReq();
        cbs.ApiName = 'Test';
        cbs.ApplicationId = app.id;
        cbs.CbsStatus = new List<WS_CBS_Status_Update.acctReqWrapper>();
        
        WS_CBS_Status_Update.acctReqWrapper acct1 = new WS_CBS_Status_Update.acctReqWrapper();
        acct1.ApplicantId = acc.id;
        acct1.CustomerID = '333';
        acct1.Status = 'Failure';
        cbs.CbsStatus.add(acct1);
        string json = json.serialize(cbs);
        System.debug('jSon:::'+jSon);
        return jSon;
    }
     public static string getData2(string method){
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc; 
        
        WS_CBS_Status_Update.cbsStatusReq cbs = new WS_CBS_Status_Update.cbsStatusReq();
        cbs.ApiName = 'Customer_ID_Creation_HL';
        cbs.ApplicationId = app.id;
        cbs.CbsStatus = new List<WS_CBS_Status_Update.acctReqWrapper>();
        WS_CBS_Status_Update.acctReqWrapper acct = new WS_CBS_Status_Update.acctReqWrapper();
        acct.ApplicantId = acc.id;
        acct.CustomerID = '333';
        acct.Status = 'Success';
        cbs.CbsStatus.add(acct);
        
        string json = json.serialize(cbs);
        System.debug('jSon:::'+jSon);
        return jSon;
    }
     public static string getData3(string method){
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc; 
        
        WS_CBS_Status_Update.cbsStatusReq cbs = new WS_CBS_Status_Update.cbsStatusReq();
        cbs.ApiName = 'EKYCUpdation_HL';
        cbs.ApplicationId = app.id;
        cbs.CbsStatus = new List<WS_CBS_Status_Update.acctReqWrapper>();
        WS_CBS_Status_Update.acctReqWrapper acct = new WS_CBS_Status_Update.acctReqWrapper();
        acct.ApplicantId = acc.id;
        acct.CustomerID = '333';
        acct.Status = 'Success';
        cbs.CbsStatus.add(acct);
        
        string json = json.serialize(cbs);
        System.debug('jSon:::'+jSon);
        return jSon;
    }
     public static string getData4(string method){
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc; 
        
        WS_CBS_Status_Update.cbsStatusReq cbs = new WS_CBS_Status_Update.cbsStatusReq();
        cbs.ApiName = 'Term_Loan_Linkage_Collateral_HL';
        cbs.ApplicationId = app.id;
        cbs.CbsStatus = new List<WS_CBS_Status_Update.acctReqWrapper>();
        WS_CBS_Status_Update.acctReqWrapper acct = new WS_CBS_Status_Update.acctReqWrapper();
        acct.ApplicantId = acc.id;
        acct.CustomerID = '333';
        acct.Status = 'Success';
        cbs.CbsStatus.add(acct);
        
        string json = json.serialize(cbs);
        System.debug('jSon:::'+jSon);
        return jSon;
    }
     public static string getData5(string method){
        Id RecordTypeIdclPerson = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
        Account acc = new Account();
        acc.LastName = 'Ashish';
        acc.Full_Name__c = 'Ashish G Jain';
        acc.PersonEmail = 'qulity@data.com';
        acc.PersonMobilePhone = '2335232345'; 
        acc.RecordTypeID = RecordTypeIdclPerson;
        insert acc; 
        
        WS_CBS_Status_Update.cbsStatusReq cbs = new WS_CBS_Status_Update.cbsStatusReq();
        cbs.ApiName = 'FCR_CUST_SIGN_PHOTO_ADD_HL';
        cbs.ApplicationId = app.id;
        cbs.CbsStatus = new List<WS_CBS_Status_Update.acctReqWrapper>();
        WS_CBS_Status_Update.acctReqWrapper acct = new WS_CBS_Status_Update.acctReqWrapper();
        acct.ApplicantId = acc.id;
        acct.CustomerID = '333';
        acct.Status = 'Success';
        cbs.CbsStatus.add(acct);
        
        string json = json.serialize(cbs);
        System.debug('jSon:::'+jSon);
        return jSon;
    }
    
    
    @isTest  static void WS_CBS_Status_Update2(){
        
        // Blob b = Blob.valueOf(getData('CbsStatus'));
        TestUtility.webserviceRequest('services/apexrest/updateCBSstatus', 'POST', null);
        Test.startTest();
        WS_CBS_Status_Update.getMandateFields();
        Test.stopTest();
    }
    
    @isTest  static void WS_CBS_Status_Update(){
        Blob b = Blob.valueOf(getData('CbsStatus'));
        TestUtility.webserviceRequest('services/apexrest/updateCBSstatus', 'POST', b);
        Test.startTest();
        WS_CBS_Status_Update.getMandateFields();
        Test.stopTest();
    }
    @isTest static  void WS_CBS_Status_Update1(){
        Blob b = Blob.valueOf(getData1('reqObj'));
        System.debug('b:::'+b);
        TestUtility.webserviceRequest('services/apexrest/UpdatePerfios', 'POST', b);
        Test.startTest();
        WS_CBS_Status_Update.getMandateFields();
        Test.stopTest();
    }
    @isTest  static void WS_CBS_Status_Update3(){
        Blob b = Blob.valueOf(getData2('CbsStatus'));
        TestUtility.webserviceRequest('services/apexrest/updateCBSstatus', 'POST', b);
        Test.startTest();
        WS_CBS_Status_Update.getMandateFields();
        Test.stopTest();
    }
    @isTest  static void WS_CBS_Status_Update4(){
        Blob b = Blob.valueOf(getData3('CbsStatus'));
        TestUtility.webserviceRequest('services/apexrest/updateCBSstatus', 'POST', b);
        Test.startTest();
        WS_CBS_Status_Update.getMandateFields();
        Test.stopTest();
    }
     @isTest  static void WS_CBS_Status_Update5(){
         try{
        Blob b = Blob.valueOf(getData4('CbsStatus'));
        TestUtility.webserviceRequest('services/apexrest/updateCBSstatus', 'POST', b);
        Test.startTest();
        WS_CBS_Status_Update.getMandateFields();
        Test.stopTest();
         }catch(exception e)
         {}
    }
    @isTest  static void WS_CBS_Status_Update6(){
        Blob b = Blob.valueOf(getData5('CbsStatus'));
        TestUtility.webserviceRequest('services/apexrest/updateCBSstatus', 'POST', b);
        Test.startTest();
        WS_CBS_Status_Update.getMandateFields();
        Test.stopTest();
    }
}