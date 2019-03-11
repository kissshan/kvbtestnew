/*
 * @Name        : SanctionMatrix_Calc_Batch_Test
 * @Description : Test class for SanctionMatrix_Calc_Batch
 * @Date		: 08/08/2018
 * @Author      : Ashish
 * Last Modified By : Yadagri
*/ 
@isTest
public class SanctionMatrix_Calc_Batch_Test {
    @isTest 
    public static void SanctionMatrixMethod(){
        Id prodRecType = Schema.SObjectType.clcommon__CL_Product__c.getRecordTypeInfosByName().get('Product Child').getRecordTypeId();
        clcommon__CL_Product__c prod = new clcommon__CL_Product__c(clcommon__Product_Name__c = 'Personal Loan');
        prod.RecordTypeId = prodRecType;
        insert prod;
    	Account acc = Utility_Test.createAccount('Karunanidhi', '1857', '2334233423');
        insert acc;
        genesis__Applications__c app = Utility_Test.createApplication('1857', acc.ID);
		app.Sub_Stage__c = 'Identified for renewal';
        insert app;
        genesis__Applications__c genApp = [select id, Sub_Stage__c from genesis__Applications__c where id =: app.Id];
        Facility__c fac = new Facility__c();
        fac.Application__c  = genApp.Id;
        fac.CL_Product__c = prod.Id;
        fac.Active__c = true;
        insert fac;
        clcommon__Collateral__c col = new clcommon__Collateral__c();
        //insert col;
        genesis__Application_Collateral__c appColl = new genesis__Application_Collateral__c();
        //appcol
        update fac;
        
        Authority_Sanction_Limit__c authSanctionLimit = new Authority_Sanction_Limit__c();
        insert authSanctionLimit;
        List<Sanction_Authority_Matrix_Association__c> samaList = new List<Sanction_Authority_Matrix_Association__c>();
        Sanction_Authority_Matrix_Association__c sama = new Sanction_Authority_Matrix_Association__c();
        sama.Authority_Sanction_Limit__c=authSanctionLimit.id;
        insert sama;
        samaList.add(sama);
        Test.startTest();
            SanctionMatrix_Calculation.sanctionLimitComparision(app.Id, 20000,samaList, 'Branch Manager');
        	SanctionMatrix_Calc_Batch sanc = new SanctionMatrix_Calc_Batch(genApp.Id);
        	DataBase.executeBatch(sanc);
		Test.stopTest();
    }
}