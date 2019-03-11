@isTest
public class AccountEOD_Helper_Test {
    @isTest
    public static void method1(){
        
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','768965','Mahesh','Father in law','KVB');
        insert acc;
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS', 'SME Renewal');
        genApp.Active__c=true;
        insert genApp;
        
        Test.startTest();
        AccountEOD_Helper.ownershipAssignment(new set<String>{'Chennai','Hyderabad'});
        List<AccountEODResponse.cls_ACCOUNT> accList =new List<AccountEODResponse.cls_ACCOUNT>();
        AccountEODResponse.cls_ACCOUNT cls = new AccountEODResponse.cls_ACCOUNT();
        cls.name='';
        cls.customer_id='768965';
        accList.add(cls);
        AccountEOD_Helper.getAppDetails(new List<AccountEODResponse.cls_ACCOUNT> {});
        //AccountEOD_Helper.checkLimitValue(new set<String>{'234567'});
        Test.stopTest();
        
    }
}