/*
* Description : Perfios_New_SME_Response_Handler_Test
* Author       : Vignesh
*/



@isTest
private class Perfios_New_SME_Response_Helper_Test {
	
	@isTest static void test_method_one() {

		Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
            insert acc;
            
		Operations_Detail__c opDetl= new Operations_Detail__c();
            opDetl.Account__c= acc.Id;
            opDetl.Fiscal_Type__c= 'YTD';
            opDetl.Fiscal_Year__c= '2018-19';
            opDetl.DR_AMT__c=23455;
            opDetl.Credit_Cash_Amount__c=23456;
            opDetl.Maximum_Return_Amount__c=3456;
            opDetl.Minimum_Return_Amount__c= 4566;
            opDetl.FIN_DR_AMT__c = 5353;
            opDetl.FIN_CR_AMT__c =4342;
            opDetl.FIN_DR_CNT__c=43;
            opDetl.FIN_CR_CNT__c =34;
            opDetl.No_of_Exceedings__c=43;
            opDetl.Inward_check_return__c=23;
            opDetl.Outward_check_return__c=32;
            opDetl.Credit_cash_count__c =32;
            opDetl.Intrest_Recieved_Amount__c=32;
            opDetl.Availment_amount__c= 2343;



            insert opDetl;

            Operations_Detail__c opDetl1= new Operations_Detail__c();
            opDetl1.Account__c= acc.Id;
            opDetl1.Fiscal_Type__c= 'ACTUAL';
            opDetl1.Fiscal_Year__c= '2017-18';
            opDetl1.DR_AMT__c=23455;
            opDetl1.Credit_Cash_Amount__c=23456;
            opDetl1.Maximum_Return_Amount__c= 3456;
            opDetl1.Minimum_Return_Amount__c=  4566;
            opDetl1.FIN_DR_AMT__c =  5353;
            opDetl1.FIN_CR_AMT__c=  4342;
            opDetl1.FIN_DR_CNT__c =43;
            opDetl1.FIN_CR_CNT__c  =34;
            opDetl1.No_of_Exceedings__c=  43;
            opDetl1.Inward_check_return__c = 23;
            opDetl1.Outward_check_return__c=  32;
            opDetl1.Credit_cash_count__c =32;
            opDetl1.Intrest_Recieved_Amount__c =32;
            opDetl1.Availment_amount__c=  2343;
            insert opDetl1;

            Map<String,Operations_Detail__c> OprDtlMap= new Map<String,Operations_Detail__c>();
            OprDtlMap.put('YTD',opDetl);
            OprDtlMap.put('ACTUAL',opDetl1);

            Perfios_New_SME_Response perfiRes= new Perfios_New_SME_Response();

            Perfios_New_SME_Response.cls_CustomerInfo custInfo= new Perfios_New_SME_Response.cls_CustomerInfo();
            custInfo.name= 'Vignesh';
            custInfo.address= 'Bengaluru';

            Perfios_New_SME_Response.cls_Total tot= new Perfios_New_SME_Response.cls_Total();
            tot.intPayDelay= '2';
            tot.totalDebit= '34562'; 
            tot.totalCredit= '32455';
            tot.debits= '23456';
            tot.Credits= '32567';
            tot.overdrawnInstances= '23445';
            tot.inwBounces= '3245';
            tot.cashDeposits= '3456';
            tot.totalCashWithdrawal= '32456';
            tot.totalCashDeposit= '34524';
            tot.cashWithdrawals= '34567';
            tot.totalInterestIncome= '23456';

            Perfios_New_SME_Response.cls_Average avg= new Perfios_New_SME_Response.cls_Average();
            avg.balAvg= '2345678';

            Perfios_New_SME_Response.cls_SummaryInfo summInfo= new Perfios_New_SME_Response.cls_SummaryInfo();
            summInfo.instName= 'instName';
            summInfo.accNo= '12338934';
            summInfo.total= tot;
            summInfo.highestNonTechnicalBounce= '4356782';
            summInfo.lowestNonTechnicalBounce= '345672';
            summInfo.average= avg;

            perfiRes.customerInfo= custInfo;
            perfiRes.summaryInfo= summInfo;

            

            Test.startTest();
            Perfios_New_SME_Response_Helper.cls_Perfios_New_SME PerNewObj= new Perfios_New_SME_Response_Helper.cls_Perfios_New_SME();
            PerNewObj=Perfios_New_SME_Response_Helper.getSUMOfOperationalData(perfiRes.summaryInfo,OprDtlMap);
            Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		Test.startTest();
		Perfios_New_SME_Response_Helper.cls_Perfios_New_SME perObj= new Perfios_New_SME_Response_Helper.cls_Perfios_New_SME();
		perObj.No_of_credit_cash_count='45';

		/*String json= '{'+
					 '"cls_Perfios_New_SME": {'+
					 '"No_of_credit_cash_count":"32"'+
					 '}'+
					 '}';
		perObj=(Perfios_New_SME_Response_Helper.cls_Perfios_New_SME ) System.JSON.deserialize(json, Perfios_New_SME_Response_Helper.cls_Perfios_New_SME .class);*/
		Test.stopTest();
	}
	
}