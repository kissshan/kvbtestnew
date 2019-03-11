@isTest
public class Test_WS_eStampDocGen {
    
  // public static genesis__Applications__c genApp;
    @istest
    public static void method1(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();        
       System.debug('genAppRecordType.Name'+genAppRecordType);
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        insert genApp;
        
        genApp =[select id, name,RecordType.Name from genesis__Applications__c where Branch_Code__c= 'KB23'];
        System.debug('genApp.RecordType.Name'+genApp.RecordType.Name);
        genApp.Cersai_Charges__c=700;
        genApp.Property_State__c='ORISSA';
        update genApp;
        System.debug('genApp.RecordType.Name1'+genApp.RecordType.Name);

        //  Stamping_Charges__mdt ob=new Stamping_Charges__mdt();
        //  ob.Agreement_of_Guarantee__c=8000;
        Stamping_Charges__mdt ob2=[select Declaration_of_Original_Mortgage__c,MasterLabel from Stamping_Charges__mdt where MasterLabel=:'ORISSA' ];
        System.debug('**ob2'+ob2);
        insert new DIGIO_Templates__c(Name ='A23');
        MOD_Documents__c modobj=new MOD_Documents__c();
        modobj.DOcNo__c='2829';
        modobj.Document_Upload_Type__c='Copy';
        modobj.Application__c=genApp.id;
        insert modobj;
        
     
        genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
        parobj.genesis__Application__c=genApp.id;
        parobj.genesis__Party_Account_Name__c=acc.Id;
        parobj.genesis__Party_Type__c='Co-Borrower';
        parobj.Title_Holder__c=true;
        insert parobj;
          genesis__Application_Parties__c parobj1=new genesis__Application_Parties__c();
        parobj1.genesis__Application__c=genApp.id;
        parobj1.genesis__Party_Account_Name__c=acc.Id;
        parobj1.genesis__Party_Type__c='Co-Borrower';
        parobj1.Title_Holder__c=true;
        insert parobj1;
          genesis__Application_Parties__c parobj2=new genesis__Application_Parties__c();
        parobj2.genesis__Application__c=genApp.id;
        parobj2.genesis__Party_Account_Name__c=acc.Id;
        parobj2.genesis__Party_Type__c='Co-Borrower';
        parobj2.Title_Holder__c= true;
        insert parobj2;
         genesis__Application_Parties__c parobj3=new genesis__Application_Parties__c();
        parobj3.genesis__Application__c=genApp.id;
        parobj3.genesis__Party_Account_Name__c=acc.Id;
        parobj3.genesis__Party_Type__c='Guarantor';
        parobj3.Title_Holder__c=true;
        insert parobj3;
        genesis__Application_Parties__c parobj4=new genesis__Application_Parties__c();
        parobj4.genesis__Application__c=genApp.id;
        parobj4.genesis__Party_Account_Name__c=acc.Id;
        parobj4.genesis__Party_Type__c='Guarantor';
        parobj4.Title_Holder__c= true;
        insert parobj4;
        genesis__Application_Parties__c parobj5=new genesis__Application_Parties__c();
        parobj5.genesis__Application__c=genApp.id;
        parobj5.genesis__Party_Account_Name__c=acc.Id;
        parobj5.genesis__Party_Type__c='Guarantor';
        parobj5.Title_Holder__c = true;
        insert parobj5;
             
        genesis__Application_Parties__c parobj6=new genesis__Application_Parties__c();
        parobj6.genesis__Application__c=genApp.id;
        parobj6.genesis__Party_Account_Name__c=acc.Id;
        parobj6.genesis__Party_Type__c='Guarantor';
        parobj6.Title_Holder__c=true;
        insert parobj6;
          genesis__Application_Parties__c parobj7=new genesis__Application_Parties__c();
        parobj7.genesis__Application__c=genApp.id;
        parobj7.genesis__Party_Account_Name__c=acc.Id;
        parobj7.genesis__Party_Type__c='Guarantor';
        parobj7.Title_Holder__c=true;
        insert parobj7;
          genesis__Application_Parties__c parobj8=new genesis__Application_Parties__c();
        parobj8.genesis__Application__c=genApp.id;
        parobj8.genesis__Party_Account_Name__c=acc.Id;
        parobj8.genesis__Party_Type__c='Guarantor';
        parobj8.Title_Holder__c= true;
        insert parobj8;
         genesis__Application_Parties__c parobj9=new genesis__Application_Parties__c();
        parobj9.genesis__Application__c=genApp.id;
        parobj9.genesis__Party_Account_Name__c=acc.Id;
        parobj9.genesis__Party_Type__c='Guarantor';
        parobj9.Title_Holder__c=true;
        insert parobj9;
        genesis__Application_Parties__c parobj10=new genesis__Application_Parties__c();
        parobj10.genesis__Application__c=genApp.id;
        parobj10.genesis__Party_Account_Name__c=acc.Id;
        parobj10.genesis__Party_Type__c='Guarantor';
        parobj10.Title_Holder__c= true;
        insert parobj10;
        genesis__Application_Parties__c parobj11=new genesis__Application_Parties__c();
        parobj11.genesis__Application__c=genApp.id;
        parobj11.genesis__Party_Account_Name__c=acc.Id;
        parobj11.genesis__Party_Type__c='Guarantor';
        parobj11.Title_Holder__c = true;
        insert parobj11;
           genesis__Application_Parties__c parobj12=new genesis__Application_Parties__c();
        parobj12.genesis__Application__c=genApp.id;
        parobj12.genesis__Party_Account_Name__c=acc.Id;
        parobj12.genesis__Party_Type__c='Guarantor';
        parobj12.Title_Holder__c = true;
        insert parobj12;
        
        /*ob.MasterLabel='wb';
ob.Declaration_of_Original_Mortgage__c=18298;
ob.Declaration_Of_Title_Mortgage__c=303;
ob.DeveloperName='testdev';
ob.Create_Mortgage_Charges__c=239839;
ob.Housing_Loan_Agreement__c=928382;*/
        //insert ob;
        KVB_Endpoint_URLs__c loanChargeURLs = new KVB_Endpoint_URLs__c();
        loanChargeURLs.Name = 'eStamp_url_test' ;
        loanChargeURLs.Endpoint_URL__c = 'http://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/Collateral_creation_HL' ;
        loanChargeURLs.Password__c = '' ;
        loanChargeURLs.Username__c = '' ;
        INSERT loanChargeURLs;
        Stamping_Charges__mdt stcMtc1 = new Stamping_Charges__mdt();
        
        //Parties creation
        /*genesis__Application_Parties__c  part1 = new genesis__Application_Parties__c();
part1.Active__c = true;
part1.genesis__Application__c = app.id;
insert part1;*/
    
   
        MockResponse mokResp = new MockResponse();
        mokResp.serviceName = 'eStamp_url_test';
        String eStampReq = '"error_code":"0"';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mokResp);
        WS_eStampDocGen.createDoc(genApp ,'A23','823ejws','ANDHRA PRADESH');
        WS_eStampDocGen.createDoc(genApp ,'LAP_A23','823ejws','ANDHRA PRADESH');
        WS_eStampDocGen.createDoc(genApp ,'A46','823ejws','ANDHRA PRADESH');
        WS_eStampDocGen.createDoc(genApp ,'LAP_A46','823ejws','ANDHRA PRADESH');
        WS_eStampDocGen.createDoc(genApp ,'B1','823ejws','ANDHRA PRADESH');
        WS_eStampDocGen.createDoc(genApp ,'LAP_B1','823ejws','ANDHRA PRADESH');
        WS_eStampDocGen.createDoc(genApp ,'B2','823ejws','ANDHRA PRADESH');
        WS_eStampDocGen.createDoc(genApp ,'B17','823ejws','ANDHRA PRADESH');
        WS_eStampDocGen.createDoc(genApp ,'PL Loan Agreement','823ejws','ANDHRA PRADESH');
        WS_eStampDocGen.calleStampAPI(eStampReq, 'A23', 100, '823ejws');
        WS_eStampDocGen.createVal(genApp);
        Test.stopTest();
    }
    
    @istest
    public static void method3(){
        Account acc = SME_TestUtil.createAccount('HP Agencies3','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL4W').getRecordTypeId();        
       System.debug('genAppRecordType.Name'+genAppRecordType);
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        insert genApp;
        clcommon__Collateral__c col=new clcommon__Collateral__c();
        col.genesis__Application__c=genApp.id;
        col.clcommon__Collateral_Name__c='test';
        insert col;
        Ownership__c ow=new Ownership__c();
        ow.Account__c=acc.id;
        insert ow;
        List<Ownership__c> owlist=new List<Ownership__c>();
        owlist.add(ow);
        
        genApp =[select id, name,RecordType.Name,Record_Type_Name__c from genesis__Applications__c where Branch_Code__c= 'KB23'];
        System.debug('genApp.RecordType.Name'+genApp.RecordType.Name);
        genApp.Cersai_Charges__c=700;
        genApp.Property_State__c='ORISSA';
        update genApp;
        System.debug('genApp.RecordType.Name1'+genApp.RecordType.Name);

        //  Stamping_Charges__mdt ob=new Stamping_Charges__mdt();
        //  ob.Agreement_of_Guarantee__c=8000;
        Stamping_Charges__mdt ob2=[select Declaration_of_Original_Mortgage__c,MasterLabel from Stamping_Charges__mdt where MasterLabel=:'ORISSA' ];
        System.debug('**ob2'+ob2);
        insert new DIGIO_Templates__c(Name ='A23');
        MOD_Documents__c modobj=new MOD_Documents__c();
        modobj.DOcNo__c='2829';
        modobj.Document_Upload_Type__c='Copy';
        modobj.Application__c=genApp.id;
        insert modobj;
        
     
        genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
        parobj.genesis__Application__c=genApp.id;
        parobj.genesis__Party_Account_Name__c=acc.Id;
        parobj.genesis__Party_Type__c='Co-Borrower';
        parobj.Title_Holder__c=true;
        insert parobj;
         KVB_Endpoint_URLs__c loanChargeURLs = new KVB_Endpoint_URLs__c();
        loanChargeURLs.Name = 'eStamp_url_test' ;
        loanChargeURLs.Endpoint_URL__c = 'http://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/Collateral_creation_HL' ;
        loanChargeURLs.Password__c = '' ;
        loanChargeURLs.Username__c = '' ;
        INSERT loanChargeURLs;
        Stamping_Charges__mdt stcMtc1 = new Stamping_Charges__mdt();
        
        //Parties creation
        /*genesis__Application_Parties__c  part1 = new genesis__Application_Parties__c();
part1.Active__c = true;
part1.genesis__Application__c = app.id;
insert part1;*/
    
   
        MockResponse mokResp = new MockResponse();
        mokResp.serviceName = 'eStamp_url_test';
        String eStampReq = '"error_code":"0"';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mokResp);
        WS_eStampDocGen.createDocnew(genApp ,col,owlist,'A23','823ejws','ANDHRA PRADESH');
    
    }
     @istest
    public static void method2(){
        Account acc = SME_TestUtil.createAccount('HP Agencies2','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('LAP').getRecordTypeId();        
       System.debug('genAppRecordType.Name'+genAppRecordType);
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        insert genApp;
        clcommon__Collateral__c col=new clcommon__Collateral__c();
        col.genesis__Application__c=genApp.id;
        col.clcommon__Collateral_Name__c='test';
        insert col;
        Ownership__c ow=new Ownership__c();
        ow.Account__c=acc.id;
        insert ow;
        List<Ownership__c> owlist=new List<Ownership__c>();
        owlist.add(ow);
        
        genApp =[select id, name,RecordType.Name,Record_Type_Name__c from genesis__Applications__c where Branch_Code__c= 'KB23'];
        System.debug('genApp.RecordType.Name'+genApp.RecordType.Name);
        genApp.Cersai_Charges__c=700;
        genApp.Property_State__c='ORISSA';
        update genApp;
        System.debug('genApp.RecordType.Name1'+genApp.RecordType.Name);

        //  Stamping_Charges__mdt ob=new Stamping_Charges__mdt();
        //  ob.Agreement_of_Guarantee__c=8000;
        Stamping_Charges__mdt ob2=[select Declaration_of_Original_Mortgage__c,MasterLabel from Stamping_Charges__mdt where MasterLabel=:'ORISSA' ];
        System.debug('**ob2'+ob2);
        insert new DIGIO_Templates__c(Name ='A23');
        MOD_Documents__c modobj=new MOD_Documents__c();
        modobj.DOcNo__c='2829';
        modobj.Document_Upload_Type__c='Copy';
        modobj.Application__c=genApp.id;
        insert modobj;
        
     
        genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
        parobj.genesis__Application__c=genApp.id;
        parobj.genesis__Party_Account_Name__c=acc.Id;
        parobj.genesis__Party_Type__c='Co-Borrower';
        parobj.Title_Holder__c=true;
        insert parobj;
         KVB_Endpoint_URLs__c loanChargeURLs = new KVB_Endpoint_URLs__c();
        loanChargeURLs.Name = 'eStamp_url_test' ;
        loanChargeURLs.Endpoint_URL__c = 'http://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/Collateral_creation_HL' ;
        loanChargeURLs.Password__c = '' ;
        loanChargeURLs.Username__c = '' ;
        INSERT loanChargeURLs;
        Stamping_Charges__mdt stcMtc1 = new Stamping_Charges__mdt();
        
        //Parties creation
        /*genesis__Application_Parties__c  part1 = new genesis__Application_Parties__c();
part1.Active__c = true;
part1.genesis__Application__c = app.id;
insert part1;*/
    
   
        MockResponse mokResp = new MockResponse();
        mokResp.serviceName = 'eStamp_url_test';
        String eStampReq = '"error_code":"0"';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mokResp);
        WS_eStampDocGen.createDocnew(genApp ,col,owlist,'A23','823ejws','ANDHRA PRADESH');
    
    }
      @istest
    public static void method4(){
        Account acc = SME_TestUtil.createAccount('HP Agencies4','CHENNAI','1210009','Mahesh','Father in law','KVB');
        insert acc;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('VL2W').getRecordTypeId();        
       System.debug('genAppRecordType.Name'+genAppRecordType);
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        genApp.RecordTypeId=genAppRecordType;
        insert genApp;
        clcommon__Collateral__c col=new clcommon__Collateral__c();
        col.genesis__Application__c=genApp.id;
        col.clcommon__Collateral_Name__c='test';
        insert col;
        Ownership__c ow=new Ownership__c();
        ow.Account__c=acc.id;
        insert ow;
        List<Ownership__c> owlist=new List<Ownership__c>();
        owlist.add(ow);
        
        genApp =[select id, name,RecordType.Name,Record_Type_Name__c from genesis__Applications__c where Branch_Code__c= 'KB23'];
        System.debug('genApp.RecordType.Name'+genApp.RecordType.Name);
        genApp.Cersai_Charges__c=700;
        genApp.Property_State__c='ORISSA';
        update genApp;
        System.debug('genApp.RecordType.Name1'+genApp.RecordType.Name);

        //  Stamping_Charges__mdt ob=new Stamping_Charges__mdt();
        //  ob.Agreement_of_Guarantee__c=8000;
        Stamping_Charges__mdt ob2=[select Declaration_of_Original_Mortgage__c,MasterLabel from Stamping_Charges__mdt where MasterLabel=:'ORISSA' ];
        System.debug('**ob2'+ob2);
        insert new DIGIO_Templates__c(Name ='A23');
        MOD_Documents__c modobj=new MOD_Documents__c();
        modobj.DOcNo__c='2829';
        modobj.Document_Upload_Type__c='Copy';
        modobj.Application__c=genApp.id;
        insert modobj;
        
     
        genesis__Application_Parties__c parobj=new genesis__Application_Parties__c();
        parobj.genesis__Application__c=genApp.id;
        parobj.genesis__Party_Account_Name__c=acc.Id;
        parobj.genesis__Party_Type__c='Co-Borrower';
        parobj.Title_Holder__c=true;
        insert parobj;
         KVB_Endpoint_URLs__c loanChargeURLs = new KVB_Endpoint_URLs__c();
        loanChargeURLs.Name = 'eStamp_url_test' ;
        loanChargeURLs.Endpoint_URL__c = 'http://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/Collateral_creation_HL' ;
        loanChargeURLs.Password__c = '' ;
        loanChargeURLs.Username__c = '' ;
        INSERT loanChargeURLs;
        Stamping_Charges__mdt stcMtc1 = new Stamping_Charges__mdt();
        
        //Parties creation
        /*genesis__Application_Parties__c  part1 = new genesis__Application_Parties__c();
part1.Active__c = true;
part1.genesis__Application__c = app.id;
insert part1;*/
    
   
        MockResponse mokResp = new MockResponse();
        mokResp.serviceName = 'eStamp_url_test';
        String eStampReq = '"error_code":"0"';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mokResp);
        WS_eStampDocGen.createDocnew(genApp ,col,owlist,'A23','823ejws','ANDHRA PRADESH');
    
    }
}