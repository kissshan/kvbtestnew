@isTest
public class Test_LAP_Digio_Service_B1 {
    @testsetup
public static void setupMethod()
{

      Account acc = Utility_Test.createAccount('JArvis', '1323', '42354324');
   // acc.PersonEmail='p@gmail.com';
   // acc.PersonMobilePhone='2322221312';
        insert acc;
     genesis__Applications__c app = Utility_Test.createApplication('1323', acc.id);
        app.SI_Bank_Name__c='Karur Vysya Bank';
        insert app;
    genesis__Application_Parties__c genPar = new genesis__Application_Parties__c();
        genPar.genesis__Party_Account_Name__c = acc.Id;
        genPar.Key_Contact__c = acc.Id;
        genPar.genesis__Application__c = app.Id;
        genPar.genesis__Party_Type__c = Constants.Co_Borrower;
        genPar.Active__c=true;
        genPar.Company__c=false;
        INSERT genPar;
    clcommon__Collateral__c cc=new clcommon__Collateral__c();
        cc.Advances_Paid__c=100;
        cc.Branch_Name__c='san';
        cc.Dealer_name__c='test';
        cc.Dealer_Email__c='cc@gmail.com';
        cc.genesis__Application__c=app.Id;
        cc.clcommon__Manufacturer__c='ooie';
        cc.clcommon__Model__c='iwej';
        cc.Variant__c='jsdj';
        cc.clcommon__Collateral_Name__c='test123';
             cc.Collateral_Type__c='Vehicles';
        insert cc;
    KVB_Endpoint_URLs__c kvb1 = new KVB_Endpoint_URLs__c();
     	KVB1.Name = 'DocGeneration';
        KVB1.Endpoint_URL__c = '/bpmsUAT/rest/CueRest/invokeESBService/CreateDocTemplate1';
        KVB1.Username__c='prashant';
     	insert kvb1;
     KVB_Company_Details__c kvb = new KVB_Company_Details__c();
		kvb.KVB_MW_Base_URL__c = 'https://www.kvbbank.net';
        kvb.GST__c = 18;
    kvb.Key_Store_Name__c='prashant';
        insert kvb;
     DIGIO_Templates__c digio=new DIGIO_Templates__c();
         digio.Template_Unique_Id__c='56gy78ug';
        digio.Name=Constants.LAP_B1_B2DOC;
        insert digio;
    genesis__Application_Document_Category__c appdoccat=new genesis__Application_Document_Category__c();
        appdoccat.genesis__Application__c=app.id;
            appdoccat.name=Constants.LoanDocuments;
            insert appdoccat;
    
}
    @isTest
    public static void method1()
    {
         genesis__Applications__c app = [Select id,genesis__Account__c,Day_Of_Disbursal__c,Legal_desk_state_flag__c,Document_Generation__c from genesis__Applications__c ];
        system.debug('jj:-'+app);
        //genesis__Applications__c app=[select id from genesis__Applications__c];
        app.Legal_desk_state_flag__c=false;
        update app;
        List<clcommon__Collateral__c> colList=[SELECT id,Name,SurveyKhasraKhataPatta_No__c,Collateral_Type__c,EM_Charge_type__c,Nature_of_Property__c,PlotDoorShopBungalow_No__c,Buildup_Area__c,ExtentCarpet_area_Built_up_area__c,Floor_No__c,Stage_Sector_Ward_Block_No__c,Building_Society_Name__c,Street_NameNo__c,VillageTown__c,TalukaTehsil__c,District_Name__c,State__c,Property_Pincode__c,Total_Market_value__c,clcommon__City__c,clcommon__Postal_Code__c,Building_Name__c,Valuation_Date__c from  clcommon__Collateral__c];
        test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        LAP_Digio_Service_B1.digioDocGen(app.id,Constants.LAP_B1_B2DOC,colList);
        test.stopTest();
        
    }
}