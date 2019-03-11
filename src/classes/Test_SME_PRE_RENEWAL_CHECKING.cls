@isTest
public class Test_SME_PRE_RENEWAL_CHECKING {
@isTest
    public static void method10(){
        try{
         genesis__Applications__c app=TestUtility.intialSetUp('HomeLoan',true);
          List<string> applist=new List<string>();
          applist.add(app.Id);
          SME_PRE_RENEWAL_CHECKING.createPrechecklist(applist);
        }catch(Exception e){}
    }
    
    
    @isTest
    public static void method3(){
         Trigger_Setting__c cs = new Trigger_Setting__c();
         cs.Execute_Application_Trigger__c=true;
         insert cs;
        
             genesis__Applications__c appnew=TestUtility.intialSetUp('HomeLoan',true);
        genesis__Applications__c app =[select id,genesis__Loan_Amount__c,Sub_Stage__c,Loan_Purpose__c from genesis__Applications__c where id=:appnew.id];
        Id RecordTypeIdgenApp = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get('Home Loan').getRecordTypeId();       
      
         app.Loan_Purpose__c='home';
         app.Flat_No__c = '302';
         app.Sub_Stage__c = 'Loan Sanctioned Non-STP';
         app.genesis__Loan_Amount__c=50000;
         app.RecordTypeId=RecordTypeIdgenApp;
         app.FEC_Reference_Number__c='FEC UNDER PROCESS';
         app.Asset_ID__c='325436456';
         app.Security_ID__c='124345';
         app.Asset_Description__c='Building Construction';
         app.Asset_Value__c='80000000';
         app.Charge_ID__c='346373746';
         app.SRN_ID__c='5635635';
         update app;
         List<genesis__Applications__c> applist=new List<genesis__Applications__c>();
         applist.add(app);
         Map<Id,genesis__Applications__c> AppMap=new Map<Id,genesis__Applications__c>();
         AppMap.put(app.Id, app);
        
         genesis__Applications__c appold=app;
         appold.Loan_Purpose__c='car';
         appold.genesis__Loan_Amount__c=90000;
        appold.Flat_No__c = '402';
        appold.Sub_Stage__c = 'Loan Requirement Captured';
       //   appold.Sub_Stage__c = 'SI details captured'; 
        //appold.Pre_Renewal_Checklist__c = 'Completed';
         update appold;
          List<genesis__Applications__c> applistold=new List<genesis__Applications__c>();
         applistold.add(appold);
        
         List<Id> appId=new List<Id>();
        for(genesis__Applications__c a : applistold)
        {
            
             appId.add(a.id);
        }
        
        
        
         Map<Id,genesis__Applications__c> AppMapold=new Map<Id,genesis__Applications__c>();
         AppMapold.put(appold.Id, appold);
        
        Project_Master__c proMas = new Project_Master__c();
        proMas.City_Town_Village__c = 'Bang';
        proMas.Address_Line_1__c = 'Kormangala';
        proMas.Address_Line_2__c = 'ET Marlabs';
        proMas.Address_Line_3__c = 'India';
        proMas.State__c = 'karnataka';
        proMas.Pin_Code__c = '560029';
        proMas.Boundary_East__c = '2';
        proMas.Boundary_North__c = '2';
        proMas.Boundary_South__c = '2';
        proMas.Boundary_West__c = '2';
        proMas.Project_Name__c = 'KVB Property';
        proMas.Location_Of_The_Proeprty__c = 'Metro';
        proMas.Extent_Area_Sq_Feet__c = '5';
        proMas.District__c = 'Blr';
        proMas.Project_Code__c = '11';
        INSERT proMas;
        //ProjectCode__c     proCode = new ProjectCode__c();
       // proCode.
        string flatids = appold.id;
        Flat_Master__c flatMas = new Flat_Master__c();
        flatMas.Survey_number__c = '123';
        flatMas.Flat_No_House_No__c = flatids;//'402';
        flatMas.ProjectCode__c = proMas.Id;
        flatMas.UDS__c = 20;
        flatMas.Floor_No__c = '1';
        flatMas.Recommended_Rate_Of_Flat_House_Rs_Sq__c = 5000;
        flatMas.Built_Up_Area_Sq_Feet__c = '123';
        flatMas.Date_Of_Valuation_Update__c = system.today();
        flatMas.Market_Value_Of_Property_Rs__c = 5000;
        flatMas.Tower_Construction_Start_Date__c = system.today();
        flatMas.Tower_Construction_End_Date__c = system.today();
        flatMas.Stage_Of_Construction__c = 1;
        flatMas.Valuers_Name__c = 'TestVal';
        //flatMas.Market_Value_Of_the_Building__c = 2000;
       // flatMas.Market_Value_Of_The_Land__c = 3000;
        flatMas.MAST_Of_Property__c = 'KVB';
        flatMas.Presence_of_Amenities__c = 'TestAmen';
        INSERT flatMas;
       // ProcessingFee.CallCalculatefee(applist,AppMap,applistold,AppMapold);
        SME_PRE_RENEWAL_CHECKING.createPrechecklist(appId);
    }
}