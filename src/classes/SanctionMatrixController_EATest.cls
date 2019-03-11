/*
* Name              : SanctionMatrixController_EATest
* Company           : ET Marlabs
* Purpose           : Test Class for SanctionMatrixController_EA Class
* Author            : SOUVIK BANIK
* last Modified By  : SOUVIK BANIK on 31-07-2018
*/


@isTest(SeeAllData=False)
public class SanctionMatrixController_EATest {
    
    
    @isTest
    public static void createData(){
        
        Profile p  = [SELECT Id,Name FROM Profile WHERE Name = 'BR_MGR_LARGE'];
        Profile p2 = [SELECT Id,Name FROM Profile WHERE Name = 'DOCC'];
        User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u; 
        System.RunAs(u){
            
            Account acc = new Account(FirstName = 'Test', LastName = 'Data',No_Of_Exceeding_And_Adhoc__c = 2);
            Insert acc;
            
            clcommon__CL_Product__c prodMaster = (clcommon__CL_Product__c)TestUtil_SME.createSobjectTypeRecord('clcommon__CL_Product__c',null,new Map<String,Object>
                                                                                                               {'clcommon__Product_Name__c'=>'Working Capital','Product_Code__c'=>'WC','Product_Type__c'=>'Funded',
                                                                                                                   'Facility_Category__c'=>'SOD','clcommon__Product_Name__c'=>'SOD REAL ESTATE','RecordTypeId'=>'Product_Master'});
            prodMaster.RecordTypeId = SOQL_Util.getRecordTypeId('Product_Child');
            Insert prodMaster;
            
            List<EAE_Sanction_Matrix__mdt> mdt_BR_MGR_LARGE_List = [SELECT Limit_in_Amount__c,Limit_in_Percentage__c,No_of_application_per_year__c,Order__c,Period_in_days__c,
                                                                    Role__c FROM EAE_Sanction_Matrix__mdt WHERE Role__c = 'BR_MGR_LARGE']; 
            List<EAE_Sanction_Matrix__mdt> mdt_DOCC_List         = [SELECT Limit_in_Amount__c,Limit_in_Percentage__c,No_of_application_per_year__c,Order__c,Period_in_days__c,
                                                                    Role__c FROM EAE_Sanction_Matrix__mdt WHERE Role__c = 'DOCC'];
            
            User usrObj = (User)TestUtil_SME.createSobjectTypeRecord('User',
                                                                     null,new Map<String,Object>{'Alias'=>'Alia','Email'=>'test@gmail.com',
                                                                         'EmailEncodingKey'=>'UTF-8','FirstName'=>'Test','LastName'=>'Alias','LanguageLocaleKey'=>'en_US',
                                                                         'LocaleSidKey'=>'en_AU','TimeZoneSidKey'=>'Asia/Kolkata','CommunityNickname'=>'Alia',
                                                                         'ProfileId'=>p.Id,'Username'=>'stndusr@testorg.com',
                                                                         'Office_Code__c'=>1250,'Designation__c'=>'BR_MGR_LARGE'});
            Insert usrObj;
            
            User usrObj2 = (User)TestUtil_SME.createSobjectTypeRecord('User',
                                                                      null,new Map<String,Object>{'Alias'=>'Alia','Email'=>'tst@gmail.com',
                                                                          'EmailEncodingKey'=>'UTF-8','FirstName'=>'Test','LastName'=>'Ali','LanguageLocaleKey'=>'en_US',
                                                                          'LocaleSidKey'=>'en_AU','TimeZoneSidKey'=>'Asia/Kolkata','CommunityNickname'=>'Ali',
                                                                          'ProfileId'=>p2.Id,'Username'=>'stdusr@testorg.com',
                                                                          'Office_Code__c'=>1250,'Designation__c'=>'DOCC'});
            Insert usrObj2;
            
            
            
            
            
            genesis__Applications__c genApp_Renewal=SME_TestUtil.createApplication('KB23',acc.Id,'Identified for renewal','FI_Approved','COMPANY_DETAILS','SME Renewal');
            //  genApp_Renewal.RecordTypeId                     = SOQL_Util.getRecordTypeIdBySobject('SME_Renewal','genesis__Applications__c');
            genApp_Renewal.Sanction_Authority__c            = 'BR_MGR_LARGE';
            Insert genApp_Renewal;
            
            genesis__Applications__c genApp_Exceeding=SME_TestUtil.createApplication('KB23',acc.Id,'Exceeding- Application created','FI_Approved','COMPANY_DETAILS');
            genApp_Exceeding.RecordTypeId                   = SOQL_Util.getRecordTypeIdBySobject('SME_Exceeding','genesis__Applications__c');
            genApp_Renewal.Sanction_Authority__c            = 'BR_MGR_LARGE';
            Insert genApp_Exceeding;
            
            genesis__Applications__c genApp_AdHoc=SME_TestUtil.createApplication('KB23',acc.Id,'Adhoc- Application created','FI_Approved','COMPANY_DETAILS');
            genApp_AdHoc.RecordTypeId                       = SOQL_Util.getRecordTypeIdBySobject('SME_AdHoc','genesis__Applications__c');
            genApp_Renewal.Sanction_Authority__c            = 'BR_MGR_LARGE';
            Insert genApp_AdHoc;    
            
            
            System.debug('genApp_Exceeding.Id--> ' + genApp_Exceeding.Id);
            
            Facility__c facObj          = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                            {'Application__c'=>genApp_Exceeding.Id,'New_Limit_Amount__c'=>2500000.00,'Existing_Limit__c'=>1500000.23,'Recommended_Limit__c'=>1200000.00,
                                                                                                'Existing_Rate__c'=>12.00,'CL_Product__c'=>prodMaster.Id,'recordTypeId'=>SOQL_Util.getRecordTypeIdBySobject('Parent','Facility__c')});
            Insert facObj;
            System.debug('facObj AppId--> ' +facObj.Application__c);
            
            
            Facility__c facObj2         = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                            {'Application__c'=>genApp_Exceeding.Id,'New_Limit_Amount__c'=>7500000.00,'Existing_Limit__c'=>5500000.23,'Recommended_Limit__c'=>6000000.00,
                                                                                                'Existing_Rate__c'=>12.00,'CL_Product__c'=>prodMaster.Id,'recordTypeId'=>SOQL_Util.getRecordTypeIdBySobject('Parent','Facility__c')});
            Insert facObj2;
            System.debug('facObj2 AppId--> ' +facObj2.Application__c);
            
            Facility__c facObj3         = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                            {'Application__c'=>genApp_AdHoc.Id,'New_Limit_Amount__c'=>7500000.00,'Existing_Limit__c'=>5500000.23,'Recommended_Limit__c'=>6500000.00,
                                                                                                'Existing_Rate__c'=>12.00,'CL_Product__c'=>prodMaster.Id,'recordTypeId'=>SOQL_Util.getRecordTypeIdBySobject('Parent','Facility__c')});
            Insert facObj3;
            System.debug('facObj3 AppId--> ' +facObj3.Application__c);
            
            Facility__c facObj4         = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                            {'Application__c'=>genApp_AdHoc.Id,'New_Limit_Amount__c'=>7500000.00,'Existing_Limit__c'=>5500000.23,'Recommended_Limit__c'=>5800000.00,
                                                                                                'Existing_Rate__c'=>12.00,'CL_Product__c'=>prodMaster.Id,'recordTypeId'=>SOQL_Util.getRecordTypeIdBySobject('Parent','Facility__c')});
            Insert facObj4;
            System.debug('facObj4 AppId--> ' +facObj4.Application__c);
            
            
            
            
            Facility__c childFac1          = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                               {'Facility__c'=>facObj.Id,'recordTypeId'=>SOQL_Util.getRecordTypeIdBySobject('Child','Facility__c')});
            Insert childFac1;
            
            
            Facility__c childFac2          = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                               {'Facility__c'=>facObj2.Id,'recordTypeId'=>SOQL_Util.getRecordTypeIdBySobject('Child','Facility__c')});
            Insert childFac2;
            
            System.debug('genApp_Renewal::: '+genApp_Renewal.id);
            SYstem.debug('genApp_Exceeding.Id:: '+genApp_Exceeding.Id);
            SYstem.debug('genApp_AdHoc.Id.Id:: '+genApp_AdHoc.Id);
            SYstem.debug('facObj.rec::: '+facObj.recordType.DeveloperName+':::facObj2::: '+facObj2.recordType.DeveloperName);
            Test.startTest();
            SanctionMatrixController_EA.saveAuthorityreccomendations(genApp_Exceeding.Id,false,TRUE);
            SanctionMatrixController_EA.saveAuthorityreccomendations(genApp_AdHoc.Id,TRUE,TRUE);
            SanctionMatrixController_EA.getSanctionAuthority_Count(acc.Id);
            SanctionMatrixControllerHelper_EA.getAllFacilities(genApp_Exceeding.Id);
            SanctionMatrixControllerHelper_EA.getAllFacilities(genApp_AdHoc.Id);
            SanctionMatrixControllerHelper_EA.getExistingLimitAggregate(new List<Facility__c>{facObj,facObj2});
            SanctionMatrixControllerHelper_EA.getExistingLimitAggregate(new List<Facility__c>{facObj3,facObj4});
            SanctionMatrixControllerHelper_EA.getNewLimitAggregate(new List<Facility__c>{facObj,facObj2});
            SanctionMatrixControllerHelper_EA.getNewLimitAggregate(new List<Facility__c>{facObj3,facObj4});
            SanctionMatrixControllerHelper_EA.getRecommendedAggregate(new List<Facility__c>{facObj,facObj2});
            SanctionMatrixControllerHelper_EA.getRecommendedAggregate(new List<Facility__c>{facObj3,facObj4});
            SanctionMatrixControllerHelper_EA.getLastRenewal_Sanction(acc.Id);
            
            SanctionMatrixController_EA.createTaskForBM(genApp_Exceeding.Id);
            SanctionMatrixController_EA.createTaskForBM(genApp_AdHoc.Id);
            SanctionMatrixController_EA.getSanctionAuthority_Count(acc.Id);
            SanctionMatrixController_EA.checkIfRoleCrossedItsLimit('BR_MGR_LARGE',6);
            SanctionMatrixController_EA.checkIfRoleCrossedItsLimit('BR_MGR_LARGE',2);
            SanctionMatrixControllerHelper_EA.canGivenRoleSanctionNewLimit(3000000,5000000);
            SanctionMatrixControllerHelper_EA.getExistingLimitAggregate(new List<Facility__c>{facObj,facObj2});
            SanctionMatrixControllerHelper_EA.getExistingLimitAggregate(new List<Facility__c>{facObj3,facObj4});
            SanctionMatrixControllerHelper_EA.getNewLimitAggregate(new List<Facility__c>{facObj,facObj2});
            SanctionMatrixControllerHelper_EA.getNewLimitAggregate(new List<Facility__c>{facObj3,facObj4});
            SanctionMatrixControllerHelper_EA.getRecommendedAggregate(new List<Facility__c>{facObj,facObj2});
            SanctionMatrixControllerHelper_EA.getLastRenewal_Sanction(acc.Id);
            SanctionMatrixControllerHelper_EA.getApplicationManagerRole(genApp_Exceeding.Id);
            SanctionMatrixControllerHelper_EA.getApplicationManagerRole(genApp_AdHoc.Id);
            SanctionMatrixControllerHelper_EA.createAuthorityRecommendationForBM(genApp_Exceeding.Id);
            SanctionMatrixControllerHelper_EA.createAuthorityRecommendationForBM(genApp_AdHoc.Id);
            SanctionMatrixControllerHelper_EA.checkIfBMRoleAlreadyExist(genApp_Exceeding.Id);
            SanctionMatrixControllerHelper_EA.checkIfBMRoleAlreadyExist(genApp_AdHoc.Id);
            Test.stopTest();
        }        
        
        
        
    }
    
    @isTest
    public static void createData2(){
        
        Profile p2 = [SELECT Id,Name FROM Profile WHERE Name = 'DOCC'];
        
          User u = Utility_Test.createUser('TestUserkvb@test.com');
        insert u;
        System.RunAs(u){
            
        
        Account acc = new Account(FirstName = 'Test', LastName = 'Data');
        Insert acc;
        
        clcommon__CL_Product__c prodMaster = (clcommon__CL_Product__c)TestUtil_SME.createSobjectTypeRecord('clcommon__CL_Product__c',null,new Map<String,Object>
                                                                                                           {'clcommon__Product_Name__c'=>'Working Capital','Product_Code__c'=>'WC','Product_Type__c'=>'Funded',
                                                                                                               'Facility_Category__c'=>'SOD','clcommon__Product_Name__c'=>'SOD REAL ESTATE','RecordTypeId'=>'Product_Master'});
        prodMaster.RecordTypeId = SOQL_Util.getRecordTypeId('Product_Child');
        Insert prodMaster;
        
        List<EAE_Sanction_Matrix__mdt> mdt_DOCC_List         = [SELECT Limit_in_Amount__c,Limit_in_Percentage__c,No_of_application_per_year__c,Order__c,Period_in_days__c,
                                                                Role__c FROM EAE_Sanction_Matrix__mdt WHERE Role__c = 'DOCC'];
        
        
        User usrObj2 = (User)TestUtil_SME.createSobjectTypeRecord('User',
                                                                  null,new Map<String,Object>{'Alias'=>'Alia','Email'=>'tst@gmail.com',
                                                                      'EmailEncodingKey'=>'UTF-8','FirstName'=>'Test','LastName'=>'Ali','LanguageLocaleKey'=>'en_US',
                                                                      'LocaleSidKey'=>'en_AU','TimeZoneSidKey'=>'Asia/Kolkata','CommunityNickname'=>'Ali',
                                                                      'ProfileId'=>p2.Id,'Username'=>'stdusr@testorg.com',
                                                                      'Office_Code__c'=>1250,'Designation__c'=>'DOCC'});
        Insert usrObj2;
        
                
        
            /*genesis__Applications__c genApp_Renewal=SME_TestUtil.createApplication('KB23',acc.Id,'Identified for renewal','FI_Approved','COMPANY_DETAILS');
//genApp_Renewal.RecordTypeId = SOQL_Util.getRecordTypeId('SME_Renewal');
genApp_Renewal.Sanction_Authority__c = 'DOCC';
Insert genApp_Renewal;*/
            
            genesis__Applications__c genApp_Exceeding=SME_TestUtil.createApplication('KB23',acc.Id,'Exceeding- Application created','FI_Approved','COMPANY_DETAILS');
            genApp_Exceeding.RecordTypeId = SOQL_Util.getRecordTypeId('SME_Exceeding');
            Insert genApp_Exceeding;
            
            genesis__Applications__c genApp_AdHoc=SME_TestUtil.createApplication('KB23',acc.Id,'Adhoc- Application created','FI_Approved','COMPANY_DETAILS');
            genApp_AdHoc.RecordTypeId = SOQL_Util.getRecordTypeId('SME_AdHoc');
            Insert genApp_AdHoc;
            
            
            Facility__c facObj          = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                            {'Application__c'=>genApp_Exceeding.Id,'New_Limit_Amount__c'=>3000000.00,'Existing_Limit__c'=>30000000.23,
                                                                                                'Existing_Rate__c'=>12.00});
            Insert facObj;
            
            Facility__c facObj2         = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                            {'Application__c'=>genApp_Exceeding.Id,'New_Limit_Amount__c'=>35000000.00,'Existing_Limit__c'=>40000000.23,
                                                                                                'Existing_Rate__c'=>12.00});
            Insert facObj2;
            
            Facility__c facObj3         = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                            {'Application__c'=>genApp_AdHoc.Id,'New_Limit_Amount__c'=>700000.00,'Existing_Limit__c'=>5500000.23,
                                                                                                'Existing_Rate__c'=>12.00});
            Insert facObj3;
            
            Facility__c facObj4         = (Facility__c)TestUtil_SME.createSobjectTypeRecord('Facility__c',null,new Map<String,Object>
                                                                                            {'Application__c'=>genApp_AdHoc.Id,'New_Limit_Amount__c'=>20000000.00,'Existing_Limit__c'=>9900000.23,
                                                                                                'Existing_Rate__c'=>12.00});
            Insert facObj4;
        
           Test.startTest();  
            
            SanctionMatrixController_EA.saveAuthorityreccomendations(genApp_Exceeding.Id,FALSE,FALSE);
            SanctionMatrixController_EA.saveAuthorityreccomendations(genApp_AdHoc.Id,FALSE,TRUE);
            SanctionMatrixController_EA.createTaskForBM(genApp_Exceeding.Id);
            SanctionMatrixController_EA.createTaskForBM(genApp_AdHoc.Id);
            SanctionMatrixController_EA.getSanctionAuthority_Count(acc.Id);
            SanctionMatrixController_EA.checkIfRoleCrossedItsLimit('DOCC',1);
            SanctionMatrixController_EA.checkIfRoleCrossedItsLimit('DOCC',2);
            SanctionMatrixControllerHelper_EA.canGivenRoleSanctionNewLimit(3000000,5000000);
            SanctionMatrixControllerHelper_EA.getExistingLimitAggregate(new List<Facility__c>{facObj,facObj2});
            SanctionMatrixControllerHelper_EA.getExistingLimitAggregate(new List<Facility__c>{facObj3,facObj4});
            SanctionMatrixControllerHelper_EA.getNewLimitAggregate(new List<Facility__c>{facObj,facObj2});
            SanctionMatrixControllerHelper_EA.getNewLimitAggregate(new List<Facility__c>{facObj3,facObj4});
            SanctionMatrixControllerHelper_EA.getRecommendedAggregate(new List<Facility__c>{facObj,facObj2});
            SanctionMatrixControllerHelper_EA.getLastRenewal_Sanction(acc.Id);
        }
        
        Test.stopTest();
        
        
    }   
    
}