/*
* Name      : TestRecordsSharingAccess
* Compnay   : ET Marlabs
* Author    : Vignesh
*/
@isTest
public class TestRecordsSharingAccess {
	
	@isTest static void test_method_one() {
		Map<String,ID> profiles = new Map<String,ID>();
	    List<Profile> ps = [select id, name from Profile where name = 'BR_CREDIT_OFFICER' or name = 'BR_MGR_MEDIUM'or name = 'System Administrator'];
	    for(Profile p : ps){
	        profiles.put(p.name, p.id);
	    }

	    User brUser = new User(alias = 'standt', 
	      email='standarduser@testorg.com', 
	      emailencodingkey='UTF-8', 
	      lastname='Testing', languagelocalekey='en_US', 
	      localesidkey='en_US', 
	      profileid = profiles.get('BR_MGR_MEDIUM'), 
	      timezonesidkey='America/Los_Angeles', 
	      username='BR_MGR_MEDIUM@testorg.com');
	    insert brUser;

	    User SysUser = new User(alias = 'standt', 
	      email='standarduser1@testorg.com', 
	      emailencodingkey='UTF-8', 
	      lastname='Testing1', languagelocalekey='en_US', 
	      localesidkey='en_US', 
	      profileid = profiles.get('System Administrator'), 
	      timezonesidkey='America/Los_Angeles', 
	      username='sys@testorg.com');
	    insert SysUser;

	    User brCOuser = new User(alias = 'standt', 
	      email='standarduser1@testorg.com', 
	      emailencodingkey='UTF-8', 
	      lastname='Testing2', languagelocalekey='en_US', 
	      localesidkey='en_US', 
	      profileid = profiles.get('BR_CREDIT_OFFICER'), 
	      timezonesidkey='America/Los_Angeles', 
	      username='BR_CREDIT_OFFICER@testorg.com');
	    insert brCOuser;


	    Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Is_KVB_Director__c=True;
        acc.Net_Monthly_Income__c=34.4;
        acc.Previous_Constitution__c='LLP';
        acc.Constitution__c='LLP';
        acc.Income_Computation_From__c='Bank Statement';
        acc.Gross_Income_3__c=345.4;
        acc.Salary_Credited_1__c=22.33;
        acc.Employment_Type__c='Salaried';
        acc.ownerid= brUser.Id;
        insert acc;
	    system.runas(SysUser){
	      	RecordsSharingAccess.accountRecordsShare(new Set<Id>{acc.id},brCOuser);
	      	RecordsSharingAccess.removeAccountRecordsShare(new Set<Id>{acc.id},brCOuser);
	    }
	}	
}