@isTest
public class Test_WS_CibilServiceTU_HL {
    public static genesis__Applications__c app;
@isTest
    public static void method1(){
    
        app=TestUtility.intialSetUp('HomeLoan',true);
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc= new Account(
          RecordTypeID=recordTypeId ,
          FirstName='Test FName',
          LastName='Test LName',
          Aadhaar_Number__pc='678905642341',
          Pan_Number__c='AAAPL1234C',
          PersonMailingStreet='test@yahoo.com',
          PersonMailingPostalCode='12345',
          PersonMailingCity='SFO',
          PersonEmail='test@yahoo.com',
          PersonHomePhone='1234567',
          PersonMobilePhone='12345678',
          PersonBirthdate=system.today()  
        );
 
        insert acc;
        WS_CibilServiceTU_HL.prepareRequest(acc,'CIBIL');
    }
    
    @isTest
    public static void method2(){
    
        app=TestUtility.intialSetUp('HomeLoan',true);
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc= new Account(
          RecordTypeID=recordTypeId ,
          FirstName='Test FName',
          LastName='Test LName',
          PersonMailingStreet='test@yahoo.com',
          PersonMailingPostalCode='12345',
          PersonMailingCity='SFO',
          PersonEmail='test@yahoo.com',
          PersonHomePhone='1234567',
          PersonMobilePhone='12345678',
          PersonBirthdate=system.today()  
        );
 
        insert acc;
        WS_CibilServiceTU_HL.prepareRequest(acc,'IDV');
    }
}