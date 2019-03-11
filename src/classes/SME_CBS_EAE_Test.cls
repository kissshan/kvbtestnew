/*
* Description : SME_CBS_EAE_Test
* Author       : Yadagiri
*/
@isTest
public class SME_CBS_EAE_Test {
    @isTest
    public static void testMethod1(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Service_Type_Name__c='CollateralDlink';
        genApp.Next_Renewal_Date__c = Date.newInstance(2018, 09, 18);
        genApp.EAE_Renewal_Date_in_days__c = 200;
        genApp.Charge_collection_done__c = false;
        genapp.Processing_Charges__c = 2399;
        genApp.Cibil_Charges__c = 1222;
        genApp.Branch_Code__c = '1857';
       	insert genApp;
        
       /* KVB_Endpoint_URLs__c kvbUrl = new KVB_Endpoint_URLs__c(name='EAE_D_Link',Endpoint_URL__c='/ext_bpms/rest/CueRest/invokeESBService/FCR_CASA_COLL_DLINK_LINKAGE');
        insert kvbUrl;*/
        
        KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
        insert kvb;
        
        KVB_Endpoint_URLs__c kvb_end = new KVB_Endpoint_URLs__c();
        kvb_end.Name = 'EAE_Colll_Creation';
        kvb_end.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/HL_CBS_SERVICES';
        insert kvb_end;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('KVB Product','KVB77','Funded');
        insert clProd;
        
        Id facilityRecordType = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId();

        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'KVB234',23000);
        fac.RecordTypeId=facilityRecordType;
        fac.Active__c = true;
        fac.Account_Number__c = '12345643546';
        fac.Recommended_Limit__c = 10000;
        insert fac;
        
        clcommon__Collateral__c colleteral =SME_TestUtil.createcollateral(genApp.Id,'Test Colleteral','Vacant Land');
        colleteral.FE_Created__c=true;
        colleteral.clcommon__Value__c = 55000;
        insert colleteral;
        
        Branch_Master__c bm = new Branch_Master__c(); 
        bm.CODCCBRN__c = '1857';
        bm.State__c = 'HARYANA';
        insert bm;
        
        /*Stamping_Charges__mdt obj = new Stamping_Charges__mdt();
        obj.DeveloperName = bm.State__c;
        insert obj;*/
        
        LIst<Stamping_Charges__mdt> scmdt = new LIst<Stamping_Charges__mdt>();
        scmdt = [Select ID,MasterLabel,GCFA_V2__c,Declaration_Of_Title_Mortgage__c,Declaration_of_Original_Mortgage__c,
                                               Create_Mortgage_Charges__c,Housing_Loan_Agreement__c,Agreement_of_Guarantee__c 
            From Stamping_Charges__mdt];
        system.debug('stamp in test::'+scmdt);
              

        genesis__Application_Collateral__c genAppColl = SME_TestUtil.createAppCollateral(acc.Id,genApp.Id,fac.Id,colleteral.Id);
        insert genAppColl;
        
        insert new KVB_Endpoint_URLs__c(name ='EAE_D_Link',Endpoint_URL__c = 'http://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/FCR_CASA_COLL_DLINK_LINKAGE');

		genesis__Applications__c appl = [select id,Cibil_Charges__c, Processing_Charges__c,genesis__Account__r.Branch_Code__c, Name, Branch_Code__c,Charge_collection_done__c, genesis__Account__c,RecordType.developerName, Application_Stage__c, Sub_Stage__c, Application_UI_Stage__c, RecordTypeId, Active__c, Type__c, Service_Type_Name__c, EAE_Renewal_Date_in_days__c, Next_Renewal_Date__c,  (select id, Account_Number__c ,Recommended_Limit__c from  Facilities__r) from genesis__Applications__c where id =: genApp.Id];
			        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_CBS_EAE.coll_D_Link(genApp,false);
        SME_CBS_EAE.requestHandler(genApp.id);
        SME_CBS_EAE.collLinkage(appl, true);
        Test.stopTest();
        
    }
    @isTest
    public static void testMethod2(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Service_Type_Name__c='CollateralCreation';
        insert genApp;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('KVB Product','KVB77','Funded');
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'KVB234',23000);
        insert fac;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_CBS_EAE.requestHandler(genApp.Id);
        Test.stopTest();
    }
    @isTest
    public static void testMethod3(){
        CBS_OD_TOD_Formatter cs=new CBS_OD_TOD_Formatter();
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
       Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();

        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Service_Type_Name__c='LimitUpdation';
        genApp.EAE_Renewal_Date_in_days__c=23;
        genApp.RecordTypeId=genAppRecordType;
        insert genApp;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('KVB Product','KVB77','Funded');
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'KVB234',23000);
        insert fac;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_CBS_EAE.requestHandler(genApp.Id);
        Test.stopTest();
        

    }
    @isTest
    public static void testMethod4(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
      Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Exceeding').getRecordTypeId();

        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Service_Type_Name__c='CollateralLinkage';
        genApp.RecordTypeId=genAppRecordType;
        insert genApp;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('KVB Product','KVB77','Funded');
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'KVB234',23000);
        insert fac;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_CBS_EAE.requestHandler(genApp.Id);
        Test.stopTest();
    }
    @isTest
    public static void testMethod5(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Service_Type_Name__c='ChargeCollection';
        insert genApp;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('KVB Product','KVB77','Funded');
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'KVB234',23000);
        insert fac;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_CBS_EAE.requestHandler(genApp.Id);
        Test.stopTest();
    }
    @isTest
    public static void testMethod6(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.Service_Type_Name__c='Loan_Account_Creation';
        insert genApp;
        
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('KVB Product','KVB77','Funded');
        insert clProd;
        
        Facility__c fac = SME_TestUtil.createFacility(genApp.Id,clProd.Id,'KVB234',23000);
        insert fac;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        SME_CBS_EAE.requestHandler(genApp.Id);
        Test.stopTest();
    }
    
}