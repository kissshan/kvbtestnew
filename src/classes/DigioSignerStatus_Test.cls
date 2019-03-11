/*
* Description : DigioSignerStatus_Test
* Author       : uday--->17%
*/
@isTest
public class DigioSignerStatus_Test {
    @isTest
    public static void method1(){
        Account acc = SME_TestUtil.createAccount('HP Agencies','CHENNAI','1210009','Mahesh','Father in law','KVB');
        acc.Industry_Type__c='Manufacturing';
        insert acc;
        
        // Id genAppRecordType = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('SME Renewal').getRecordTypeId();
        
        genesis__Applications__c genApp=SME_TestUtil.createApplication('KB23',acc.Id,'Sanctioned','FI_Approved','COMPANY_DETAILS');
        // genApp.RecordTypeId=genAppRecordType;
        genApp.Active__c=True;
        genApp.Sanction_ESign_Id__c='TY578';
        genApp.All_Party_Signed__c=False;
        genApp.Application_Stage__c='E-sign pending';
        //genApp.CreatedDate=system.today()-250;
        insert genApp;  
        
        KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
        KVB1.Name = 'DigioDocDetail';
        KVB1.Endpoint_URL__c = 'https://www.kvbbank.co.in/bpmsUAT/rest/CueRest/invokeESBService/GetDocumentDetails_LOS';
        insert kvb1; 
        
        Test.startTest(); 
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        DigioSignerStatus obj = new DigioSignerStatus();
        obj.callDigioService(genApp);
        DataBase.executeBatch(obj);
       // DigioSignerStatus.DigioReq deq=new DigioSignerStatus.DigioReq();
        //DigioSignerStatus.DigioResponse drs=new DigioSignerStatus.DigioResponse();
        Test.stopTest();
    }
}