// modified by prashant singh............................82% code coverage

@isTest
public class Test_WS_UpdateEsignDocStatus {
    Static genesis__Applications__c app;
    static Document_Applicant__c documentApplicantobj;
    
    @testsetup
        public static void setup(){
            KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        insert kvb;
            KVB_Endpoint_URLs__c endurl=new KVB_Endpoint_URLs__c();
            endurl.Name='DocumentDownload';
            endurl.Endpoint_URL__c='/bpmsUAT/rest/CueRest/invokeESBService/DownloadDocument';
            insert endurl;
        }
    //for valid Data(for personal loan)
@isTest
    
    public static void getstatusValidData(){
               app=TestUtility.intialSetUp('HomeLoan',true);
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.PERSONALLOAN).getRecordTypeId();       
			app.RecordTypeId = RecordTypeIdgenApp;
            app.Loan_Purpose__c=Constants.IdentifiedProperty ;
        update app;
        Account acc=new Account(Name='TestName');
        insert acc;
        System.debug('**Account id'+acc.id);
        Digio_Document_ID__c docobj=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='111',Guarantor__c=true,Stamp_Charges__c=100,name='B1');
        insert docobj;
        Digio_Document_ID__c docobj1=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='131',Guarantor__c=true,Stamp_Charges__c=10,name='B2');
        insert docobj1;
        System.debug('**docobj id'+docobj.id);
       //list<Document_Applicant__c> doclis=new list<Document_Applicant__c>();
        documentApplicantobj=new Document_Applicant__c(Account__c=acc.id,Digio_Document_ID__c=docobj.id,eSigned__c=true);
     documentApplicantobj=new Document_Applicant__c(Account__c=acc.id,Digio_Document_ID__c=docobj1.id,eSigned__c=false);

        insert documentApplicantobj;
        
        System.debug('**documentApplicantobj'+documentApplicantobj);
        blob b=blob.valueOf(getdetails());
       TestUtility.webserviceRequest('services/apexrest/UpdateEsignDocStatus','POST',b);
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Test.startTest();
        WS_UpdateEsignDocStatus.Response res=WS_UpdateEsignDocStatus.getstatus();
        Test.stopTest();
     
    }
 // for home loan   
    @isTest
    
    public static void getstatusValidDataForHL(){
               app=TestUtility.intialSetUp('HomeLoan',true);
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.HOMELOAN).getRecordTypeId();       
			app.RecordTypeId = RecordTypeIdgenApp;
            app.Loan_Purpose__c=Constants.IdentifiedProperty ;
        update app;
        Account acc=new Account(Name='TestName');
        insert acc;
        System.debug('**Account id'+acc.id);
        Digio_Document_ID__c docobj=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='111',Guarantor__c=true,Stamp_Charges__c=100,name='B1');
        insert docobj;
        Digio_Document_ID__c docobj1=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='131',Guarantor__c=true,Stamp_Charges__c=10,name='B2');
        insert docobj1;
        System.debug('**docobj id'+docobj.id);
       //list<Document_Applicant__c> doclis=new list<Document_Applicant__c>();
        documentApplicantobj=new Document_Applicant__c(Account__c=acc.id,Digio_Document_ID__c=docobj.id,eSigned__c=true);
     documentApplicantobj=new Document_Applicant__c(Account__c=acc.id,Digio_Document_ID__c=docobj1.id,eSigned__c=false);

        insert documentApplicantobj;
        
        System.debug('**documentApplicantobj'+documentApplicantobj);
        blob b=blob.valueOf(getdetails());
       TestUtility.webserviceRequest('services/apexrest/UpdateEsignDocStatus','POST',b);
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Test.startTest();
        WS_UpdateEsignDocStatus.Response res=WS_UpdateEsignDocStatus.getstatus();
        Test.stopTest();
     
    }
    
    //for lap 
      @isTest
    
    public static void getstatusValidDataForLAP(){
               app=TestUtility.intialSetUp('HomeLoan',true);
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.LAPLOAN).getRecordTypeId();       
			app.RecordTypeId = RecordTypeIdgenApp;
            app.Loan_Purpose__c=Constants.IdentifiedProperty ;
        update app;
        Account acc=new Account(Name='TestName');
        insert acc;
        System.debug('**Account id'+acc.id);
        Digio_Document_ID__c docobj=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='111',Guarantor__c=true,Stamp_Charges__c=100,name='B1');
        insert docobj;
        Digio_Document_ID__c docobj1=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='131',Guarantor__c=true,Stamp_Charges__c=10,name='B2');
        insert docobj1;
        System.debug('**docobj id'+docobj.id);
       //list<Document_Applicant__c> doclis=new list<Document_Applicant__c>();
        documentApplicantobj=new Document_Applicant__c(Account__c=acc.id,Digio_Document_ID__c=docobj.id,eSigned__c=true);
     documentApplicantobj=new Document_Applicant__c(Account__c=acc.id,Digio_Document_ID__c=docobj1.id,eSigned__c=false);

        insert documentApplicantobj;
        
        System.debug('**documentApplicantobj'+documentApplicantobj);
        blob b=blob.valueOf(getdetails());
       TestUtility.webserviceRequest('services/apexrest/UpdateEsignDocStatus','POST',b);
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Test.startTest();
        WS_UpdateEsignDocStatus.Response res=WS_UpdateEsignDocStatus.getstatus();
        Test.stopTest();
     
    }
    
     //for VL
      @isTest
    
    public static void getstatusValidDataForVL(){
               app=TestUtility.intialSetUp('HomeLoan',true);
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(Constants.VL2W).getRecordTypeId();       
			app.RecordTypeId = RecordTypeIdgenApp;
            app.Loan_Purpose__c=Constants.IdentifiedProperty ;
        update app;
        Account acc=new Account(Name='TestName');
        insert acc;
        System.debug('**Account id'+acc.id);
        Digio_Document_ID__c docobj=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='111',Guarantor__c=true,Stamp_Charges__c=100,name='B1');
        insert docobj;
        Digio_Document_ID__c docobj1=new Digio_Document_ID__c(Application__c=app.id,Borrower__c=true,Document_ID__c='131',Guarantor__c=true,Stamp_Charges__c=10,name='B2');
        insert docobj1;
        System.debug('**docobj id'+docobj.id);
       //list<Document_Applicant__c> doclis=new list<Document_Applicant__c>();
        documentApplicantobj=new Document_Applicant__c(Account__c=acc.id,Digio_Document_ID__c=docobj.id,eSigned__c=true);
     documentApplicantobj=new Document_Applicant__c(Account__c=acc.id,Digio_Document_ID__c=docobj1.id,eSigned__c=false);

        insert documentApplicantobj;
        
        System.debug('**documentApplicantobj'+documentApplicantobj);
        blob b=blob.valueOf(getdetails());
       TestUtility.webserviceRequest('services/apexrest/UpdateEsignDocStatus','POST',b);
            Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Test.startTest();
        WS_UpdateEsignDocStatus.Response res=WS_UpdateEsignDocStatus.getstatus();
        Test.stopTest();
     
    }
    
    
     
     
    //for Invalid Data
@isTest
     public static void getstatusInValidData(){
        app=TestUtility.intialSetUp('HomeLoan',true);
        blob b=blob.valueOf(getdetails2());
        TestUtility.webserviceRequest('services/apexrest/UpdateEsignDocStatus','POST',b);
        Test.startTest();
        WS_UpdateEsignDocStatus.Response res=WS_UpdateEsignDocStatus.getstatus();
        Test.stopTest();
        system.assert(res!=null);
        system.assertEquals('400',res.statusCode);
    }
    //for Null value
@isTest
     public static void getstatusNull(){
        app=TestUtility.intialSetUp('HomeLoan',true);
        TestUtility.webserviceRequest('services/apexrest/UpdateEsignDocStatus','POST',null);
        Test.startTest();
        WS_UpdateEsignDocStatus.getstatus();
        Test.stopTest();
        
    }
public static string getdetails(){
        String json=	
	'{'+
	'"eSignStatus":true,'+
	'"docId":"'+documentApplicantobj.id+'" '+
	'}';
    return json;
}
    
    public static string getdetails2(){
        String json=	
	'{'+
	'"eSignStatus":"True",'+
	'"docId":"a6Q5D0000008P5e" '+
	'}';
    return json;
}
}