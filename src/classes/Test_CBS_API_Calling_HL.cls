//written by anonymous
//modified by prashant singh
//date:-01-10-2018
//for class:-CBS_API_Calling_HL
//code coverage:--80%
@isTest
public class Test_CBS_API_Calling_HL {
    public static genesis__Applications__c genApp;
    
    @isTest
    public static void method_Call_CBS_API_1(){
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '6';
        cbsLog.Status__c = 'Failure';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

        
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
        
    }
     @isTest
    public static void method_Call_CBS_API_2(){
        try{
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '6';
        cbsLog.Status__c = 'Success';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

        
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
        }catch(Exception e)
        {
            system.debug('Exception:-'+e);
        }
        }
            
    @isTest
    public static void method_Call_CBS_API_3(){
try{
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '7';
        cbsLog.Status__c = 'Success';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

        
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
 }catch(Exception e)
        {
            system.debug('Exception:-'+e);
        }
        
    }
     @isTest
    public static void method_Call_CBS_API_4(){
try{
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '2';
        cbsLog.Status__c = 'Success';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

        
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
 }catch(Exception e)
        {
            system.debug('Exception:-'+e);
        }
        
    }
     @isTest
    public static void method_Call_CBS_API_5(){
try{
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '2';
        cbsLog.Status__c = 'Failure';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

        
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
 }catch(Exception e)
        {
            system.debug('Exception:-'+e);
        }
        
    }
    
    @isTest
    public static void method_Call_CBS_API_6(){
try{
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '3';
        cbsLog.Status__c = 'Success';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

        
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
 }catch(Exception e)
        {
            system.debug('Exception:-'+e);
        }
        
    }
   @isTest
    public static void method_Call_CBS_API_7(){
try{
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '3';
        cbsLog.Status__c = 'Failure';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

        
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
 }catch(Exception e)
        {
            system.debug('Exception:-'+e);
        }
        
    }
      @isTest
    public static void method_Call_CBS_API_8(){
try{
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '11';
        cbsLog.Status__c = 'Failure';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

        
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
 }catch(Exception e)
        {
            system.debug('Exception:-'+e);
        }
        
    }
     @isTest
    public static void method_Call_CBS_API_9(){
try{
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '11';
        cbsLog.Status__c = 'Success';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

    //.cls_in_msg cbr=new CBR_DTLS_HELPER_HL.cls_in_msg();    
    
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
 }catch(Exception e)
        {
            system.debug('Exception:-'+e);
        }
        
    }
     @isTest
    public static void method_Call_CBS_API_10(){
try{
        genesis__Applications__c newGen = new genesis__Applications__c();
        newGen.Sub_Stage__c = 'Application Created';
        INSERT newGen;
        System.debug('~~newGen'+newGen);
        
        genApp = TestUtility.intialSetUp('Home Loan', true);
        genApp.Sub_Stage__c = 'Disbursement Documents Esigned';
        UPDATE genApp;
        
        
        
        List<genesis__Applications__c> genList = new List<genesis__Applications__c>();
        genList.add(genApp);
        System.debug('~~genList'+genList);
        
        Map<Id,genesis__Applications__c> genMap = new Map<Id,genesis__Applications__c>();
        genMap.put(genApp.Id, genApp);
        System.debug('~~genMap'+genMap);
        
        CBS_API_Log__c cbsLog = new CBS_API_Log__c();
        cbsLog.Sequence_No__c = '11';
        cbsLog.Status__c = 'Failure';
        cbsLog.Application__c = genApp.Id;
        INSERT cbsLog;
        
        List<CBS_API_Log__c> listLog = new List<CBS_API_Log__c>();
        listLog.add(cbsLog);

        
        Test.startTest();
        CBS_API_Calling_HL.call_CBS_API(genList[0].id);
        CBS_API_Calling_HL.call_CBS_log(listLog);
        CBS_API_Calling_HL.initiateDisbursment(genList,genMap);
        Test.stopTest();
 }catch(Exception e)
        {
            system.debug('Exception:-'+e);
        }
        
    }
    
    
    
    
}