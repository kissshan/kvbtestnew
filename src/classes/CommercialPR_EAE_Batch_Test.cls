@isTest
public class CommercialPR_EAE_Batch_Test {
     public static List<String> listOfCustomerId;
     //public static genesis__Applications__c app;
     //public static Account acc;
     @testSetup static void setup() {
        // Create common test accounts
		/*KVB_Endpoint_URLs__c kvb = new KVB_Endpoint_URLs__c();
        kvb.Name	= 'Apigee_Access_Token';
        kvb.Endpoint_URL__c = '/next/v1/oauth/cc/accesstoken';
        kvb.Username__c	= 'Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==';
        insert kvb;*/
         
         Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId      = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.Aadhaar_Number__c   =  '1234567689900';
        acc.Pan_Number__c       =   'BXCV12PIL';
        acc.BillingStreet       =  '30 A T.Nagar';
        acc.BillingCity         =  'Chennai';
        acc.BillingState        =  'Tamil Nadu';
        acc.BillingPostalCode   =  '560029';
        acc.Constitution__c     =  'Private Limited';
        acc.Line_of_Activity__c =  'Retail Trade';
        acc.RecordTypeId        =   devRecordTypeId;
        acc.CBS_Customer_ID__c  = '1234hfag8f321hntqf'; 
        acc.CIBIL_Score__c      = 1.0;
        insert acc;
    }
    
     @isTest
    public static void method2(){
        KVB_Endpoint_URLs__c kvbEndpoint2 = new KVB_Endpoint_URLs__c(name='Apigee_Access_Token',Endpoint_URL__c='https://kvb-test.apigee.net/next/v1/oauth/cc/accesstoken',Username__c='Basic d0QxWjFHaXA3RzdBbkFDUjhSeTBXcEczWThCd0cwQlo6QkFMREJTOERGOU1FYWFSRA==');
        insert kvbEndpoint2;
        
        KVB_Endpoint_URLs__c kvb = new KVB_Endpoint_URLs__c();
        kvb.Name    = 'CommercialPR_Apigee';
        kvb.Endpoint_URL__c = 'https://kvb-test.apigee.net/next/v1/commercial/report';
        insert kvb;
        
        MockHttpResponse mockObj= new MockHttpResponse();
        MockTest moc            = new MockTest();
        Test.setMock(HttpCalloutMock.class,  mockObj);
        
        Account acc =[select id,CBS_Customer_ID__c from Account limit 1];
        
        Account personAcc 	= SME_TestUtil.createparentAccount('', 'Satish Verma','NGR Layout','560068','Bangaluru','abc@gmail.com','876543278','9854325689','abc','xyz','jkl');
        Id devRecordTypeIdPer 		= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        personAcc.Aadhaar_Number__c	=  '1234567689900';
        personAcc.Pan_Number__c		=	'BXCV12PIL';
        personAcc.RecordTypeId		= devRecordTypeIdPer;        
        insert personAcc;

        genesis__Applications__c app1 = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();       
        app1.Active__c       = true;      
        app1.RecordTypeId    =  RecordTypeIdApp;
        insert app1;
        
        genesis__Application_Parties__c appParties = SME_TestUtil.creategenAppParti(app1.Id,acc.Id,'Director','');
        appParties.genesis__Party_Account_Name__c = personAcc.Id;
        appParties.Active__c	= true;        
        insert appParties;


        List<ints__TransUnion_Credit_Report__c> transCredRep1 = new List<ints__TransUnion_Credit_Report__c>();
        ints__TransUnion_Credit_Report__c transCredRep= new ints__TransUnion_Credit_Report__c();
        transCredRep.Account__c=acc.Id;
        transCredRep1.add(transCredRep);
        //Insert transCredRep1;

        List<Enquiry_Summary__c> enqSummLst= new List<Enquiry_Summary__c>();
        Enquiry_Summary__c enqSumm= new Enquiry_Summary__c();
        enqSumm.Enquiry_Purpose__c='Test Enq';
        //insert enqSumm;
        enqSummLst.add(enqSumm);

        
        Test.startTest();
        CommercialPR_EAE_Batch  commObj = new CommercialPR_EAE_Batch();
        CommercialPR_EAE_Batch.listTransUnion.add(transCredRep); //= new List<ints__TransUnion_Credit_Report__c>{transCredRep};
        CommercialPR_EAE_Batch.listAccount.add(acc);
       
        List<String> listOfCustomerId1    = new List<String>{acc.CBS_Customer_ID__c};
        CommercialPR_EAE_Batch.getCommercialPR_EAE_Request(listOfCustomerId1,'SME',app1.Id);
        Test.stopTest();

    }     
    
}