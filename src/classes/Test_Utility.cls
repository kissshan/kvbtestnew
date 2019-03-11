/*
* Description : Test_Utility
* Author      : Kishan Panchal
*/
@isTest
public class Test_Utility {
    
    @isTest public static void method1(){
        
        insert new DIGIO_Templates__c(Name = 'A23');
        insert new KVB_Company_Details__c(Admin_email__c = 'dushyant.kumar@etmarlabs.com');
        
        Utility.runApplicationTrigger();
        Utility.runAccountTrigger();
        Utility.ISStringBlankorNull('abc');
        Utility.convertMonthTextToNumber('JAN');
        Utility.convertYearToDateToNumber('April');
        Utility.getBlankStringIfNull('sjd');
        utility.getCibilTScore('Cibil');
        Utility.getExecuteBatch();
        Utility.getDIGIOTemplateId('A23');
        utility.getCurrentYear();
        utility.generateRandomString();
        utility.isNullOrZeroDecimal(10.00);
        Utility.getStockTemplates();
        Utility.getLast3MonthList();
        Utility.getStockStatementDetails('827732');
        Utility.getMonthName(1);
        utility.dateFormatter();
        utility.dateFormatter(system.today());
        utility.sendEmail('test','test failed');
        utility.getDashboardAccessdesignations();
        utility.getFiscalYearFlag('10-09-2018');
        utility.getFiscalYearByDate('10-09-2018');
        utility.getLocalDateAndTime();
        utility.getNatureOfPropertyByCode();
        utility.getMonthRange(1);
        utility.getStateToBranchCodeMap();
        utility.getStateFromBranchCode('1234');
        insert new KVB_Endpoint_URLs__c(Name = 'SMS_Service');
        Utility.getEndpoint('SMS_Service');
        Utility.getEndpointApigee('SMS_Service');
        Utility.getFullEndpoints('SMS_Service');
    }
    
    @isTest static void method2(){
        Utility.ISStringBlankorNull('');
        Utility.convertMonthTextToNumber('FEB');
        Utility.convertYearToDateToNumber('Apr-May');
        utility.getCibilTScore('Neg');
        utility.isNullOrZeroDecimal(0.0);
        Utility.getMonthName(2);
        utility.getMonthRange(2);
    }
    
    @isTest static void method3(){
        Utility.convertMonthTextToNumber('MAR');
        Utility.convertYearToDateToNumber('Apr-Jun');
        utility.getCibilTScore('PLCibil');
        Utility.getMonthName(3);
        utility.getMonthRange(3);
    }
    
    @isTest static void method4(){
        Utility.convertMonthTextToNumber('APR');
        Utility.convertYearToDateToNumber('Apr-Jul');
        Utility.getMonthName(4);
        utility.getMonthRange(4);
    }
    
    @isTest static void method5(){
        Utility.convertMonthTextToNumber('MAY');
        Utility.convertYearToDateToNumber('Apr-Aug');
        Utility.getMonthName(5);
        utility.getMonthRange(5);
    }
    
    @isTest static void method6(){
        Utility.convertMonthTextToNumber('JUN');
        Utility.convertYearToDateToNumber('Apr-Sept');
        Utility.getMonthName(6);
        utility.getMonthRange(6);
    }
    
    @isTest static void method7(){
        Utility.convertMonthTextToNumber('JUL');
        Utility.convertYearToDateToNumber('Apr-Oct');
        Utility.getMonthName(7);
        utility.getMonthRange(7);
    }
    
    @isTest static void method8(){
        Utility.convertMonthTextToNumber('AUG');
        Utility.convertYearToDateToNumber('Apr-Nov');
        Utility.getMonthName(8);
        utility.getMonthRange(8);
    }
    
    @isTest static void method9(){
        Utility.convertMonthTextToNumber('SEP');
        Utility.convertYearToDateToNumber('Apr-Dec');
        Utility.getMonthName(9);
        utility.getMonthRange(9);
    }
    
    @isTest static void method10(){
        Utility.convertMonthTextToNumber('OCT');
        Utility.convertYearToDateToNumber('Apr-Jan');
        Utility.getMonthName(10);
        utility.getMonthRange(10);
    }
    
    @isTest static void method11(){
        Utility.convertMonthTextToNumber('NOV');
        Utility.convertYearToDateToNumber('Apr-Feb');
        Utility.getMonthName(11);
        utility.getMonthRange(11);
    }
}