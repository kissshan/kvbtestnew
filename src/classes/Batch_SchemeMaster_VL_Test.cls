@isTest
private class Batch_SchemeMaster_VL_Test
{
	@isTest
	static void TestSchemMaster()
	{
		List<genesis__Applications__c> applist=VL_Test_Utility.intialSetUp(true,true);
		List<clcommon__Collateral__c> collst = [Select id,genesis__Application__c,Scheme_Type__c from clcommon__Collateral__c where genesis__Application__c =:applist limit 1];
		Scheme_Master__c schms = new Scheme_Master__c();
		schms.Name = 'TestSchemes';
		schms.Active_Flag__c = True;
		schms.End_Date__c = system.today().adddays(-2);
		

		Test.startTest();
		insert schms;
		if(collst.size() > 0){
			List<Scheme_Master__c> scm = [select id,Scheme_Code__c from Scheme_Master__c where id =: schms.id limit 1];
			collst[0].Scheme_Type__c = scm[0].Scheme_Code__c;
			update collst;
		}
		Batch_SchemeMaster_VL obj = new Batch_SchemeMaster_VL();   
        String chron = '0 0 23 * * ?';        
        String jobid = System.schedule('testScheduledApexScheme', chron, obj);

        CronTrigger ct = [Select id , CronExpression from CronTrigger where id = :jobId];
        System.assertEquals(chron,ct.CronExpression); 
		
		Test.stopTest();
	}
}