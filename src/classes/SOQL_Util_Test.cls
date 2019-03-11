@isTest
private class SOQL_Util_Test {

  @isTest static void test_method_one() {
        Set<Id> accList = new Set<Id>();
        List<Id> appIds = new List<Id>();
        Set<Id> appIdList = new Set<Id>();
        Set<String> allPersonAccount = new Set<String>();
        List<String> fyList = new List<String>();
        List<String> collIds = new List<String>();
        List<Decimal> listofNumber = new List<Decimal>();
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        clcommon__CL_Product__c clProd = SME_TestUtil.createclproduct('SME','998','Funded');
        insert clProd;
      
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        Id devRecordTypeId     = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        acc.RecordTypeId    =  devRecordTypeId;
        acc.CBS_Customer_ID__c= '12345677';
        insert acc;
        accList.add(acc.Id);
        
        genesis__Applications__c app = SME_TestUtil.createApplication('KB23',acc.Id,'New Loans- Application created','FI_Approved','COMPANY_DETAILS');
        Id RecordTypeIdApp  = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();  //  SME NEW Loan          
        app.Active__c    = true;
        app.Branch_Code__c = '1861';        
        app.RecordTypeId  =  RecordTypeIdApp;
        insert app;
        appIds.add(app.Id);
        appIdList.add(app.Id);	
        appList.add(app);        
      
        genesis__Application_Parties__c party =new genesis__Application_Parties__c();
        party.Key_Contact__c = acc.id;
        party.genesis__Party_Account_Name__c=acc.id;
        party.genesis__Party_Type__c = Constants.Co_Borrower;
        party.genesis__Application__c = app.Id;
        party.Active__c = true;
        insert party;
      
        clcommon__Collateral__c collObj = new clcommon__Collateral__c();
        collObj.clcommon__Collateral_Name__c = SOQL_Util.getRandomExternalIdForCollateral();
        collObj.genesis__Application__c = app.Id;
        collObj.FE_Created__c = true;
        insert collObj;
        collIds.add(collObj.Id);
      
        genesis__Application_Collateral__c col = new genesis__Application_Collateral__c();
        col.Application__c = app.Id;
        col.genesis__Collateral__c = collObj.Id;       
        insert col;
      
        Task tsk = new Task();
        tsk.WhatId = app.Id;
        tsk.genesis__Application__c = app.Id;         
        tsk.ActivityDate = system.today();
        tsk.Subject = 'e-Mandate';
        tsk.Status = 'Not Started';
        tsk.Priority = 'High';
        tsk.Type = 'Test';
        insert tsk;
       
        M68_Balance_Sheet_Analysis__c m68Bal3= new M68_Balance_Sheet_Analysis__c();
        m68Bal3.Account__c= acc.Id;
        m68Bal3.Fiscal_Year__c= '2017-18';
        insert m68Bal3;
        M68_Balance_Sheet_Analysis__c m68Bal4= new M68_Balance_Sheet_Analysis__c();
        m68Bal4.Account__c= acc.Id;
        m68Bal4.Fiscal_Year__c= '2018-19';
        insert m68Bal4;      
      	     
        listofNumber.add(6);
        listofNumber.add(5);
        listofNumber.add(7);
            
        Test.startTest();
        SOQL_Util.getLoanFacilityList(accList);
        SOQL_Util.getApplicationListForFetchCustomerList(appIds);
        SOQL_Util.updateCollateralNon_Enforcable(collObj.Id);
        SOQL_Util.getFacilities(app.Id);
        SOQL_Util.getFacilities('');
        SOQL_Util.getApplicationList(appIds);
      	SOQL_Util.getAccountAudit(acc.Id);
      	SOQL_Util.getAllCustomerFeedback(app.Id);
      	SOQL_Util.getGroupConcern(acc.Id);
        SOQL_Util.getProperty(accList);
        SOQL_Util.isM68MissingForLastThreeYears(acc.Id);
        SOQL_Util.getApplication(appIdList);
        SOQL_Util.getM68Data(acc.Id,fyList);
        SOQL_Util.getAppCollaterals(app.Id);
        SOQL_Util.getCollateralWithCollIds(collIds);
        SOQL_Util.getAllChildFacilities(fyList);
        SOQL_Util.BMAuthrecommendationIdsHelper(app.Id);
        SOQL_Util.getApplicationUISatge(app.Id);
        SOQL_Util.isBMFinalAuth(app.Id);
        SOQL_Util.isEnhancementAdhocApplication(app.Id);
        SOQL_Util.getGSTN_InfoByAccId(app.Id);
        SOQL_Util.checkNullMobNum(app.Id);
        SOQL_Util.C1ExistCheck(appIdList);
        SOQL_Util.completeTask(app.Id);
        SOQL_Util.getOverallExposure(acc.Id);
        SOQL_Util.checkExixtingTaskForAnyStatus(app.Id);
        SOQL_Util.getListOfPartiesByAppId(app.Id);
        SOQL_Util.getoverallexposureforapplication(app.Id);
        SOQL_Util.getAllBuisnessAccountFromPAOfParty(allPersonAccount);
        SOQL_Util.getOverallExpoFromParties(app.Id);
        SOQL_Util.closeTaskForRejectAndDiscontinuedApp(app.Id);
        SOQL_Util.securityMasterMap();
        SOQL_Util.getApplicationDueDate('12345677');
        SOQL_Util.getAccountDetails('CCMUB1945E');
        SOQL_Util.getFirmDetails(app.Id);
        SOQL_Util.getApplicationProbe42(app.Id);
        SOQL_Util.getCollateralWithTitleHolder(app.Id);
        SOQL_Util.getCustApplicationListbyCustomer('12345677');
        SOQL_Util.checkIfTaskIsPresent(app.Id,'e-Mandate','Test');
        SOQL_Util.createTaskForBM(app.Id,'e-Mandate','Test');
        SOQL_Util.getApplicationId_By_Name(app.Name,app.Id);
        //SOQL_Util.getApplicationList('1861');
        SOQL_Util.getApplicationList('1861',RecordTypeIdApp,clProd.id);
        SOQL_Util.getCustApplicationList('12345677',RecordTypeIdApp,clProd.id);
        SOQL_Util.createTaskForBMWithoutCheckExTask(appList,'e-Mandate','Test');
        SOQL_Util.createTaskForBRCreditOfficerWithoutCheckExTask(app.Id,UserInfo.getUserId(),'e-Mandate','Test');
        SOQL_Util.createTaskForBRCreditOfficer(app.Id,'1861','e-Mandate','Test');
        SOQL_Util.BranchCreditOfficerIdMap(appList);
        SOQL_Util.getMinMaxDecimal(listofNumber,'min');
        SOQL_Util.getMinMaxDecimal(listofNumber,'max');
        SOQL_Util.closeDocGenTaskForBM(app.Id,'Test');
        SOQL_Util.getUserByBranchCode('');
        SOQL_Util.getAllCustomerByBranchCode('1861');
        SOQL_Util.getProductID('998');
      	SOQL_Util.getRecordTypeId('Business_Account');
        SOQL_Util.getRecordTypeIdBySobject('Business_Account','Account');
        SOQL_Util.faciMapwithACnumber(allPersonAccount);
        SOQL_Util.collaMapwithNNnumber(allPersonAccount);
        SOQL_Util.getFacilityList(fyList);
        SOQL_Util.getCustomerRecordType('12345677');
        SOQL_Util.getExistingApplication('12345677','SME Renewal');
        SOQL_Util.getApplicationDetail(app.Id, '12345677');
        SOQL_Util.getKeyPersonDetails(allPersonAccount,allPersonAccount);
        SOQL_Util.getProductDetails(fyList);
        SOQL_Util.getOverallExposure_TL(acc.Id,app.Id);
        SOQL_Util.getBRCreditOfficer(app.Id);
        SOQL_Util.getDebtors('12345677');
        SOQL_Util.updateAcountOverallExposure('12345677');
        SOQL_Util.getSundryCreditors('12345677');
        SOQL_Util.getRLPCUser(app.Id);
        SOQL_Util.getDOLegalUser(app.Id);
        SOQL_Util.getLegalOfficerUser(app.Id);      
        Test.stopTest();
  }
}