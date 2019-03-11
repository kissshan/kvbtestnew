@isTest
public class Test_WS_DropDownValues_SME {
    @isTest
    public static void method1(){
        genesis__Applications__c app = TestUtility.intialSetUp('TestName',true);
        List<All_Drop_Down_value__mdt> listallDropDownObj = new List<All_Drop_Down_value__mdt>();
        listallDropDownObj	= [select id,Label,Field_Api_Name__c,Object_Api_Name__c from All_Drop_Down_value__mdt];
        
        Test.startTest();
        WS_DropDownValues_SME.Response rs = WS_DropDownValues_SME.getAllPicklistvalues();
        DROW_DOWN_WRAPPER dropWrap = new DROW_DOWN_WRAPPER();
        Test.stopTest();
        
    } 
}