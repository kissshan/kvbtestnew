//uday----->77%
@isTest
public class SME_CBS_Handler_Test {
    @isTest
    public static void testMethod1(){
        account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        Id RecordTypeIdclProd1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        account acc1= SME_TestUtil.createparentAccount('Test FName','Test LName','nagaram','12345','SFO','test@yahoo.com','1234567','12345678','Mahesh','Father in law','KVB');        
        acc1.RecordTypeId=RecordTypeIdclProd1;
        acc1.Aadhaar_Number__c='499118665246';
        //acc1.CBS_Customer_ID__c='7864527';
        //acc1.CIBIL_Status__pc='Complete';
        //acc1.CIBIL_Score__c=500;
        insert acc1;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
        genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
        genApp.Branch_Name__c='xyz';
        genApp.Processing_Charges__c=500;
        genApp.Cersai_Charges__c=2000;
        genApp.Cibil_Charges__c=300;
        genApp.genesis__Additional_Cash_Required__c=500;
        insert genApp;
        
        genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        prty.Is_New__c=true;
        prty.genesis__Party_Account_Name__c=acc1.id;
        insert prty;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('KVB Product','KVB77','Funded');
        clProd.Product_Code__c='202';
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'KVB234',23000);
        insert fac;
        
        list<id> ids=new list<id>();
        ids.add(genApp.id);
        
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Bulk_API',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES');
        insert kvb;
        
        KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='CBS_CUST_LINKAGE',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_CUST_ACCT_LINK');
        insert kvb1;
        
        KVB_Endpoint_URLs__c kvb2 = new  KVB_Endpoint_URLs__c(name='CBS_CASA',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_CASA_OD_LIMIT_MNT');
        insert kvb2;
        
        KVB_Endpoint_URLs__c kvb3 = new  KVB_Endpoint_URLs__c(name='CBS_ChargeCollection',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_ACDR_GLCR_Charge_COLL');
        insert kvb3;
        
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        kvbDetail.GST__c=80;
        insert kvbDetail;
        
            
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_CBS_Handler.eKYC_Updation(ids);
        SME_CBS_Handler.customerIdCreation(ids);
        SME_CBS_Handler.customerLinkage(ids);
        SME_CBS_Handler.limitUpdation_ChargeColllection(ids);
        //SME_CBS_Handler.stockStatement(acc.id);
        Test.stopTest();
    }
    @isTest
    public static void testMethod2(){
        account acc=SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        Id RecordTypeIdclProd1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        account acc1= SME_TestUtil.createparentAccount('Test FName','Test LName','nagaram','12345','SFO','test@yahoo.com','1234567','12345678','Mahesh','Father in law','KVB');        
        acc1.RecordTypeId=RecordTypeIdclProd1;
        acc1.Aadhaar_Number__c='499118665246';
        //acc1.CBS_Customer_ID__c='7864527';
        //acc1.CIBIL_Status__pc='Complete';
        //acc1.CIBIL_Score__c=500;
        insert acc1;
        
        genesis__Applications__c genApp = SME_TestUtil.createApplication('1857',acc.id,'Application review','test','CompanyDetailsView');
        //genApp.RecordTypeId =  Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();
        genApp.Branch_Name__c='xyz';
        genApp.Processing_Charges__c=500;
        genApp.Cersai_Charges__c=2000;
        genApp.Cibil_Charges__c=300;
        genApp.genesis__Additional_Cash_Required__c=500;
        insert genApp;
        
        genesis__Application_Parties__c prty=SME_TestUtil.creategenAppParti(genApp.Id,acc.Id,'Partner','Pending');
        prty.Is_New__c=true;
        prty.genesis__Party_Account_Name__c=acc1.id;
        insert prty;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('KVB Product','KVB77','Funded');
        clProd.Product_Code__c='202';
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'KVB234',23000);
        insert fac;
        
        list<id> ids=new list<id>();
        ids.add(genApp.id);
        
        KVB_Endpoint_URLs__c kvb = new  KVB_Endpoint_URLs__c(name='CBS_Bulk_API',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES');
        insert kvb;
        
        KVB_Endpoint_URLs__c kvb1 = new  KVB_Endpoint_URLs__c(name='CBS_CUST_LINKAGE',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_CUST_ACCT_LINK');
        insert kvb1;
        
        KVB_Endpoint_URLs__c kvb2 = new  KVB_Endpoint_URLs__c(name='CBS_CASA',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_CASA_OD_LIMIT_MNT');
       insert kvb2;
        
        KVB_Endpoint_URLs__c kvb3 = new  KVB_Endpoint_URLs__c(name='CBS_ChargeCollection',Endpoint_URL__c='http://www.kvbbank.net/bpmsUAT/rest/CueRest/invokeESBService/FCR_TL_ACDR_GLCR_Charge_COLL');
        insert kvb3;
        
        KVB_Company_Details__c kvbDetail = new KVB_Company_Details__c(KVB_Support_Contact__c='test');
        kvbDetail.GST__c=80;
        insert kvbDetail;
        
            
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_CBS_Handler.eKYC_Updation(ids);
        SME_CBS_Handler.customerIdCreation(ids);
        SME_CBS_Handler.customerLinkage(ids);
        SME_CBS_Handler.limitUpdation_ChargeColllection(ids);
        //SME_CBS_Handler.stockStatement(acc.id);
        Test.stopTest();
    }
}