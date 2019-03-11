@isTest
public class SanctionMatrix_Calculation_Test {
	 @isTest 
    public static void method1(){
        Id prodRecType = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c(clcommon__Product_Name__c = 'Personal Loan');
        prod.RecordTypeId = prodRecType;
        insert prod;
        Account acc = Utility_Test.createAccount('Karunanidhi', '1857', '2334233423');
        insert acc;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genesis__Applications__c parentapp = Utility_Test.createApplication('1857', acc.ID);
        parentapp.Sub_Stage__c = 'Identified for renewal';
        parentapp.RecordTypeId=genAppRecordType;
        parentapp.New_to_Business__c=True;
        parentapp.Active__c=True;
        insert parentapp;
        
        genesis__Applications__c app = Utility_Test.createApplication('1857', acc.ID);
        app.Sub_Stage__c = 'Identified for renewal';
        app.RecordTypeId=genAppRecordType;
        app.New_to_Business__c=True;
        app.Parent_Application__c='';
        app.Active__c=True;
        app.Parent_Application__c=parentapp.id;
        insert app;
       
         list<Facility__c> listfac = new list<Facility__c>();
        Facility__c fac = new Facility__c();
        fac.Application__c  = app.Id;
        fac.CL_Product__c = prod.Id;
        fac.Active__c = false;
        listfac.add(fac);
         insert listfac;
        
        Facility__c fac1 = new Facility__c();
        fac1.Application__c  = app.Id;
        fac1.CL_Product__c = prod.Id;
        fac1.Active__c = true;
        insert fac1;
		
		  list<clcommon__Collateral__c> col =SME_TestUtil.colDataList(app.id,'Test','Vehicles');
        insert col;
     
        genesis__Application_Collateral__c appColl =SME_TestUtil.createAppCollateral(acc.Id,app.Id,fac.id,col[0].id);
      	insert appColl;
        
           genesis__Application_Collateral__c ac=new genesis__Application_Collateral__c();
            ac.Application__c=app.id;
            ac.Account__c=acc.id;
            ac.Facility__c=fac1.id;
            ac.genesis__Collateral__c=col[0].id;
            insert ac;
  
               
             
        Authority_Sanction_Limit__c authSanctionLimit = new Authority_Sanction_Limit__c();
        insert authSanctionLimit;
        List<Sanction_Authority_Matrix_Association__c> samaList = new List<Sanction_Authority_Matrix_Association__c>();
        Sanction_Authority_Matrix_Association__c sama = new Sanction_Authority_Matrix_Association__c();
        sama.Authority_Sanction_Limit__c=authSanctionLimit.id;
        insert sama;
        samaList.add(sama);
        Test.startTest();
           Map<Id,Facility__c> exisFinalUser        = SanctionUnderwriting_Process.getExistingAuthorityLevel(app.id);
            SanctionMatrix_Calculation sancMat=new SanctionMatrix_Calculation();
            SanctionMatrix_Calculation.COVERAGE_MAP mymap=sancMat.calculateAuthority(listfac,true,'FINAL_AUTHORITY',exisFinalUser);
        Test.stopTest();
    }
     @isTest 
    public static void method2(){
       /* Id prodRecType = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c(clcommon__Product_Name__c = 'Personal Loan');
        prod.RecordTypeId = prodRecType;
        insert prod;*/
        
        clcommon__CL_Product__c prod= SME_TestUtil.createclproduct('Personal Loan','345','Funded');
        
        insert prod;
        prod.Facility_Category__c='L & B';
        
        Account acc = Utility_Test.createAccount('Karunanidhi', '1857', '2334233423');
        insert acc;
         genesis__Applications__c PareApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        PareApp.Active__c = true;
         insert PareApp;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genesis__Applications__c app = Utility_Test.createApplication('1857', acc.ID);
        app.Sub_Stage__c = 'Identified for renewal';
        app.RecordTypeId=genAppRecordType;
        app.New_to_Business__c=True;
        app.Active__c=True;
        app.Parent_Application__c=PareApp.id;
        insert app;
        
        list<Facility__c> listfac = new list<Facility__c>();
        Facility__c fac = new Facility__c();
        fac.Application__c  = app.Id;
        fac.CL_Product__c = prod.Id;
        fac.Active__c = false;
        listfac.add(fac);
         insert listfac;
        
        Facility__c fac1 = new Facility__c();
        fac1.Application__c  = app.Id;
        fac1.CL_Product__c = prod.Id;
        fac1.Active__c = true;
        insert fac1;
        
       // list<Facility__c> face=[select id,Application__c,Active__c,CL_Product__c from Facility__c where id =: listfac and active__c = false];
              
        list<clcommon__Collateral__c> col =SME_TestUtil.colDataList(app.id,'Test','Vehicles');
        insert col;
     
        genesis__Application_Collateral__c appColl =SME_TestUtil.createAppCollateral(acc.Id,app.Id,listfac[0].id,col[0].id);
      	insert appColl;
        
           genesis__Application_Collateral__c ac=new genesis__Application_Collateral__c();
            ac.Application__c=app.id;
            ac.Account__c=acc.id;
            ac.Facility__c=fac1.id;
            ac.genesis__Collateral__c=col[0].id;
            insert ac;
  
       
        Authority_Sanction_Limit__c authSanctionLimit = new Authority_Sanction_Limit__c();
        insert authSanctionLimit;
        
        Authority_Category__c authCat=new Authority_Category__c();
        authCat.Name='BR_MGR_SMALL';
        authCat.Type__c='Small';
        insert authCat;
        
        
        Security_Coverage_Config__c scc=new Security_Coverage_Config__c();
        scc.Primary_Security_Margin__c=14;
        scc.Security_Category__c='Primary';
        scc.Security_Type__c='L & B';
        insert scc;
        
        Product_Security_Association__c psa=new Product_Security_Association__c();
        psa.Overall_Exposure_Check__c=true;
        psa.Product__c=prod.id;
        psa.Security_Coverage_Config__c = scc.id;
        insert psa;       
        
        Product_Security_Authority_Association__c psaa=new Product_Security_Authority_Association__c();
        psaa.Product_Security_Association__c=psa.id;
        psaa.Authority_Category__c=authCat.id;
        insert psaa;
        
        List<Sanction_Authority_Matrix_Association__c> samaList = new List<Sanction_Authority_Matrix_Association__c>();
        Sanction_Authority_Matrix_Association__c sama = new Sanction_Authority_Matrix_Association__c();
        sama.Authority_Sanction_Limit__c=authSanctionLimit.id;
        sama.Product_Security_Authority_Association__c=psaa.id;
        
        insert sama;
       Sanction_Authority_Matrix_Association__c samaformula=[select id,Security_Type__c,Security_Category__c from Sanction_Authority_Matrix_Association__c];
        samaList.add(sama);
        Test.startTest();
            //SanctionMatrix_Calculation.sanctionLimitComparision(app.Id, 20000,samaList, 'Branch Manager');
            //SanctionMatrix_Calc_Batch sanc = new SanctionMatrix_Calc_Batch(app.Id);
            //DataBase.executeBatch(sanc);
            Map<Id,Facility__c> exisFinalUser        = SanctionUnderwriting_Process.getExistingAuthorityLevel(app.id);
            SanctionMatrix_Calculation sancMat=new SanctionMatrix_Calculation();
             SanctionMatrix_Calculation.COVERAGE_MAP mymap =  sancMat.calculateAuthority(listfac,true,'FINAL_AUTHORITY',exisFinalUser);
        Test.stopTest();
    }
    @isTest 
    public static void method3(){
       /* Id prodRecType = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c(clcommon__Product_Name__c = 'Personal Loan');
        prod.RecordTypeId = prodRecType;
        insert prod;*/
        
        clcommon__CL_Product__c prod= SME_TestUtil.createclproduct('Personal Loan','345','Funded');
        insert prod;
        
        
        Account acc = Utility_Test.createAccount('Karunanidhi', '1857', '2334233423');
        insert acc;
         genesis__Applications__c PareApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        PareApp.Active__c = true;
         insert PareApp;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genesis__Applications__c app = Utility_Test.createApplication('1857', acc.ID);
        app.Sub_Stage__c = 'Identified for renewal';
        app.RecordTypeId=genAppRecordType;
        app.New_to_Business__c=True;
        app.Active__c=True;
        app.Parent_Application__c=PareApp.id;
        insert app;
       
        
        list<Facility__c> listfac = new list<Facility__c>();
        Facility__c fac = new Facility__c();
        fac.Application__c  = app.Id;
        fac.CL_Product__c = prod.Id;
        fac.Active__c = false;
        listfac.add(fac);
         insert listfac;
        
        Facility__c fac1 = new Facility__c();
        fac1.Application__c  = app.Id;
        fac1.CL_Product__c = prod.Id;
        fac1.Active__c = true;
        insert fac1;
                      
        list<clcommon__Collateral__c> col =SME_TestUtil.colDataList(app.id,'Test','Vehicles');
        insert col;
     
        genesis__Application_Collateral__c appColl =SME_TestUtil.createAppCollateral(acc.Id,app.Id,listfac[0].id,col[0].id);
        insert appColl;
        
        
        
           genesis__Application_Collateral__c ac=new genesis__Application_Collateral__c();
            ac.Application__c=app.id;
            ac.Account__c=acc.id;
            ac.Facility__c=fac1.id;
            ac.genesis__Collateral__c=col[0].id;
            insert ac;
  
       
       
        Authority_Sanction_Limit__c authSanctionLimit = new Authority_Sanction_Limit__c();
        insert authSanctionLimit;
        
        Authority_Category__c authCat=new Authority_Category__c();
        authCat.Name='BR_MGR_SMALL';
        authCat.Type__c='Small';
        insert authCat;
        
        
        Security_Coverage_Config__c scc=new Security_Coverage_Config__c();
        scc.Primary_Security_Margin__c=14;
        scc.Security_Category__c='Collateral';
        scc.Security_Type__c='L & B';
        scc.Collateral_Security_Type__c='Fixed Deposit';
        insert scc;
        
        Product_Security_Association__c psa=new Product_Security_Association__c();
        psa.Overall_Exposure_Check__c=true;
        psa.Product__c=prod.id;
        psa.Security_Coverage_Config__c = scc.id;
        insert psa;       
        
        Product_Security_Authority_Association__c psaa=new Product_Security_Authority_Association__c();
        psaa.Product_Security_Association__c=psa.id;
        psaa.Authority_Category__c=authCat.id;
        insert psaa;
        
        List<Sanction_Authority_Matrix_Association__c> samaList = new List<Sanction_Authority_Matrix_Association__c>();
        Sanction_Authority_Matrix_Association__c sama = new Sanction_Authority_Matrix_Association__c();
        sama.Authority_Sanction_Limit__c=authSanctionLimit.id;
        sama.Product_Security_Authority_Association__c=psaa.id;
        
        insert sama;
       Sanction_Authority_Matrix_Association__c samaformula=[select id,Security_Type__c,Security_Category__c from Sanction_Authority_Matrix_Association__c];
        samaList.add(sama);
        Test.startTest();
            //SanctionMatrix_Calculation.sanctionLimitComparision(app.Id, 20000,samaList, 'Branch Manager');
            //SanctionMatrix_Calc_Batch sanc = new SanctionMatrix_Calc_Batch(app.Id);
            //DataBase.executeBatch(sanc);
            Map<Id,Facility__c> exisFinalUser        = SanctionUnderwriting_Process.getExistingAuthorityLevel(app.id);
            SanctionMatrix_Calculation sancMat=new SanctionMatrix_Calculation();
             SanctionMatrix_Calculation.COVERAGE_MAP mymap =  sancMat.calculateAuthority(listfac,true,'FINAL_AUTHORITY',exisFinalUser);
        Test.stopTest();
    }
      @isTest 
    public static void method03(){
       /* Id prodRecType = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c(clcommon__Product_Name__c = 'Personal Loan');
        prod.RecordTypeId = prodRecType;
        insert prod;*/
        
        clcommon__CL_Product__c prod= SME_TestUtil.createclproduct('Personal Loan','345','Funded');
        insert prod;
        
        
        Account acc = Utility_Test.createAccount('Karunanidhi', '1857', '2334233423');
        insert acc;
         genesis__Applications__c PareApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        PareApp.Active__c = true;
         insert PareApp;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genesis__Applications__c app = Utility_Test.createApplication('1857', acc.ID);
        app.Sub_Stage__c = 'Identified for renewal';
        app.RecordTypeId=genAppRecordType;
        app.New_to_Business__c=True;
        app.Active__c=True;
        app.Parent_Application__c=PareApp.id;
        insert app;
       
        
        list<Facility__c> listfac = new list<Facility__c>();
        Facility__c fac = new Facility__c();
        fac.Application__c  = app.Id;
        fac.CL_Product__c = prod.Id;
        fac.Active__c = false;
        listfac.add(fac);
         insert listfac;
        
        Facility__c fac1 = new Facility__c();
        fac1.Application__c  = app.Id;
        fac1.CL_Product__c = prod.Id;
        fac1.Active__c = true;
        insert fac1;
                      
        list<clcommon__Collateral__c> col =SME_TestUtil.colDataList(app.id,'Test','Vehicles');
        insert col;
     
        genesis__Application_Collateral__c appColl =SME_TestUtil.createAppCollateral(acc.Id,app.Id,listfac[0].id,col[0].id);
        insert appColl;
        
        
       genesis__Application_Collateral__c ac=new genesis__Application_Collateral__c();
        ac.Application__c=app.id;
        ac.Account__c=acc.id;
        ac.Facility__c=fac1.id;
        ac.genesis__Collateral__c=col[0].id;
        insert ac;
       
        Authority_Sanction_Limit__c authSanctionLimit = new Authority_Sanction_Limit__c();
        insert authSanctionLimit;
        
        Authority_Category__c authCat=new Authority_Category__c();
        authCat.Name='BR_MGR_SMALL';
        authCat.Type__c='Small';
        insert authCat;
        
        
        Security_Coverage_Config__c scc=new Security_Coverage_Config__c();
        scc.Primary_Security_Margin__c=14;
        scc.Security_Category__c='Collateral';
        scc.Security_Type__c='L & B';
        scc.Collateral_Security_Type__c='Fixed Deposit';
        insert scc;
        
        Product_Security_Association__c psa=new Product_Security_Association__c();
        psa.Overall_Exposure_Check__c=true;
        psa.Product__c=prod.id;
        psa.Security_Coverage_Config__c = scc.id;
        insert psa;       
        
        Product_Security_Authority_Association__c psaa=new Product_Security_Authority_Association__c();
        psaa.Product_Security_Association__c=psa.id;
        psaa.Authority_Category__c=authCat.id;
        insert psaa;
        
        List<Sanction_Authority_Matrix_Association__c> samaList = new List<Sanction_Authority_Matrix_Association__c>();
        Sanction_Authority_Matrix_Association__c sama = new Sanction_Authority_Matrix_Association__c();
        sama.Authority_Sanction_Limit__c=authSanctionLimit.id;
        sama.Product_Security_Authority_Association__c=psaa.id;
        
        insert sama;
       Sanction_Authority_Matrix_Association__c samaformula=[select id,Security_Type__c,Security_Category__c from Sanction_Authority_Matrix_Association__c];
        samaList.add(sama);
        Test.startTest();
            SanctionMatrix_Calculation.sanctionLimitComparision(app.Id, 20000,samaList, 'Branch Manager');
            SanctionMatrix_Calc_Batch sanc = new SanctionMatrix_Calc_Batch(app.Id);
            DataBase.executeBatch(sanc);
            
        Test.stopTest();
    }
     @isTest 
    public static void method4(){
       /* Id prodRecType = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c(clcommon__Product_Name__c = 'Personal Loan');
        prod.RecordTypeId = prodRecType;
        insert prod;*/
        
        clcommon__CL_Product__c prod= SME_TestUtil.createclproduct('Personal Loan','345','Funded');
        insert prod;
        
        
        Account acc = Utility_Test.createAccount('Karunanidhi', '1857', '2334233423');
        insert acc;
         genesis__Applications__c PareApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        PareApp.Active__c = true;
         insert PareApp;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genesis__Applications__c app = Utility_Test.createApplication('1857', acc.ID);
        app.Sub_Stage__c = 'Identified for renewal';
        app.RecordTypeId=genAppRecordType;
        app.New_to_Business__c=True;
        app.Active__c=True;
        app.Parent_Application__c=PareApp.id;
        app.Sanction_Authority__c='CO_GM';
        insert app;
       
        
        list<Facility__c> listfac = new list<Facility__c>();
        Facility__c fac = new Facility__c();
        fac.Application__c  = app.Id;
        fac.CL_Product__c = prod.Id;
        fac.Active__c = false;
        listfac.add(fac);
         insert listfac;
        
        Facility__c fac1 = new Facility__c();
        fac1.Application__c  = app.Id;
        fac1.CL_Product__c = prod.Id;
        fac1.Active__c = true;
        insert fac1;
                      
        list<clcommon__Collateral__c> col =SME_TestUtil.colDataList(app.id,'Test','Vehicles');
        insert col;
     
        genesis__Application_Collateral__c appColl =SME_TestUtil.createAppCollateral(acc.Id,app.Id,listfac[0].id,col[0].id);
        insert appColl;
        
        
       genesis__Application_Collateral__c ac=new genesis__Application_Collateral__c();
        ac.Application__c=app.id;
        ac.Account__c=acc.id;
        ac.Facility__c=fac1.id;
        ac.genesis__Collateral__c=col[0].id;
        insert ac;

        Authority_Sanction_Limit__c authSanctionLimit = new Authority_Sanction_Limit__c();
        insert authSanctionLimit;
        
        Authority_Category__c authCat=new Authority_Category__c();
        authCat.Name='BR_MGR_SMALL';
        authCat.Type__c='Small';
        insert authCat;
        
        
        Security_Coverage_Config__c scc=new Security_Coverage_Config__c();
        scc.Primary_Security_Margin__c=14;
        scc.Security_Category__c='Collateral';
        scc.Security_Type__c='Fixed Deposit';
        scc.Collateral_Security_Type__c='Fixed Deposit';
        scc.Collateral_Margin_Start_Range__c=70;
        scc.Collateral_Margin_End_Range__c=50;
        insert scc;
        
        Product_Security_Association__c psa=new Product_Security_Association__c();
        psa.Overall_Exposure_Check__c=true;
        psa.Product__c=prod.id;
        psa.Security_Coverage_Config__c = scc.id;
        insert psa;       
        
        Product_Security_Authority_Association__c psaa=new Product_Security_Authority_Association__c();
        psaa.Product_Security_Association__c=psa.id;
        psaa.Authority_Category__c=authCat.id;
        insert psaa;
        
        List<Sanction_Authority_Matrix_Association__c> samaList = new List<Sanction_Authority_Matrix_Association__c>();
        Sanction_Authority_Matrix_Association__c sama = new Sanction_Authority_Matrix_Association__c();
        sama.Authority_Sanction_Limit__c=authSanctionLimit.id;
        sama.Product_Security_Authority_Association__c=psaa.id;
        
        insert sama;
       Sanction_Authority_Matrix_Association__c samaformula=[select id,Security_Type__c,Security_Category__c from Sanction_Authority_Matrix_Association__c];
        samaList.add(sama);
        Test.startTest();
            //SanctionMatrix_Calculation.sanctionLimitComparision(app.Id, 20000,samaList, 'Branch Manager');
            //SanctionMatrix_Calc_Batch sanc = new SanctionMatrix_Calc_Batch(app.Id);
            //DataBase.executeBatch(sanc);
            Map<Id,Facility__c> exisFinalUser        = SanctionUnderwriting_Process.getExistingAuthorityLevel(app.id);
            SanctionMatrix_Calculation sancMat=new SanctionMatrix_Calculation();
             SanctionMatrix_Calculation.COVERAGE_MAP mymap =  sancMat.calculateAuthority(listfac,true,'FINAL_AUTHORITY',exisFinalUser);
        Test.stopTest();
    }
      @isTest 
    public static void method5(){
       /* Id prodRecType = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c(clcommon__Product_Name__c = 'Personal Loan');
        prod.RecordTypeId = prodRecType;
        insert prod;*/
        
        clcommon__CL_Product__c prod= SME_TestUtil.createclproduct('Personal Loan','345','Funded');
        insert prod;
        
        
        Account acc = Utility_Test.createAccount('Karunanidhi', '1857', '2334233423');
        insert acc;
         genesis__Applications__c PareApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        PareApp.Active__c = true;
         insert PareApp;
        Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME NEW Loan').getRecordTypeId();
        genesis__Applications__c app = Utility_Test.createApplication('1857', acc.ID);
        app.Sub_Stage__c = 'Identified for renewal';
        app.RecordTypeId=genAppRecordType;
        app.New_to_Business__c=True;
        app.Active__c=True;
        app.Parent_Application__c=PareApp.id;
        app.Sanction_Authority__c='CO_GM';
        insert app;
       
        
         list<Facility__c> listfac = new list<Facility__c>();
        Facility__c fac = new Facility__c();
        fac.Application__c  = app.Id;
        fac.CL_Product__c = prod.Id;
        fac.Active__c = false;
        listfac.add(fac);
         insert listfac;
        
        Facility__c fac1 = new Facility__c();
        fac1.Application__c  = app.Id;
        fac1.CL_Product__c = prod.Id;
        fac1.Active__c = true;
        insert fac1;
                      
        list<clcommon__Collateral__c> col =SME_TestUtil.colDataList(app.id,'Test','Vehicles');
        insert col;
     
        genesis__Application_Collateral__c appColl =SME_TestUtil.createAppCollateral(acc.Id,app.Id,listfac[0].id,col[0].id);
        insert appColl;
        
        
       genesis__Application_Collateral__c ac=new genesis__Application_Collateral__c();
        ac.Application__c=app.id;
        ac.Account__c=acc.id;
        ac.Facility__c=fac1.id;
        ac.genesis__Collateral__c=col[0].id;
        insert ac;

        Authority_Sanction_Limit__c authSanctionLimit = new Authority_Sanction_Limit__c();
        insert authSanctionLimit;
        
        Authority_Category__c authCat=new Authority_Category__c();
        authCat.Name='BR_MGR_SMALL';
        authCat.Type__c='Small';
        insert authCat;
        
        
        Security_Coverage_Config__c scc=new Security_Coverage_Config__c();
        scc.Primary_Security_Margin__c=14;
        scc.Security_Category__c='Collateral';
        scc.Security_Type__c='Fixed Deposit';
        scc.Collateral_Security_Type__c='Fixed Deposit';
        scc.Collateral_Margin_Start_Range__c=70;
        scc.Collateral_Margin_End_Range__c=50;
        insert scc;
        
        Product_Security_Association__c psa=new Product_Security_Association__c();
        psa.Overall_Exposure_Check__c=true;
        psa.Product__c=prod.id;
        psa.Security_Coverage_Config__c = scc.id;
        insert psa;       
        
        Product_Security_Authority_Association__c psaa=new Product_Security_Authority_Association__c();
        psaa.Product_Security_Association__c=psa.id;
        psaa.Authority_Category__c=authCat.id;
        insert psaa;
        
        List<Sanction_Authority_Matrix_Association__c> samaList = new List<Sanction_Authority_Matrix_Association__c>();
        Sanction_Authority_Matrix_Association__c sama = new Sanction_Authority_Matrix_Association__c();
        sama.Authority_Sanction_Limit__c=authSanctionLimit.id;
        sama.Product_Security_Authority_Association__c=psaa.id;
        insert sama;

              
        
        samaList.add(sama);
        Test.startTest();
            //SanctionMatrix_Calculation.sanctionLimitComparision(app.Id, 20000,samaList, 'Branch Manager');
            //SanctionMatrix_Calc_Batch sanc = new SanctionMatrix_Calc_Batch(app.Id);
            //DataBase.executeBatch(sanc);
            Map<Id,Facility__c> exisFinalUser        = SanctionUnderwriting_Process.getExistingAuthorityLevel(app.id);
            SanctionMatrix_Calculation sancMat=new SanctionMatrix_Calculation();
             SanctionMatrix_Calculation.COVERAGE_MAP mymap =  sancMat.calculateAuthority(listfac,true,'FINAL_AUTHORITY',exisFinalUser);
        Test.stopTest();
    }
}