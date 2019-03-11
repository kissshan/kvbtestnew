/*
* Name          : Test_WS_Vendor_UpdateProperty
* Company       : ET Marlabs
* Class         : WS_Vendor_UpdatePropertyinApplication
* Code coverage : 95%
* Author        : Bhavya P
*/
@isTest
public class Test_WS_Vendor_UpdateProperty{
    
   @istest
    public static void method1() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();        
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.HOMELOAN);
        app.RecordTypeId = Schema.SObjectType.genesis__Applications__c.getRecordTypeInfosByName().get(WS_Vendor_Constants.HOMELOAN).getRecordTypeId();
        /*app.genesis__Account__c = WS_Vendor_TestUtil.createAccount().Id;
        update app;*/
        String jsonString ='{"applicationid": "'+app.Id+'","CollateralDetails": [{"Owner_name": "Bobs Mom","property_type": "Flat","extent_carpet_area_sq_ft": "1427","site_extent_area_of_the_land": "93654","date_of_commencement": "2018-11-10",'+
        +'"uds": "452.00","date_of_completion": "","cost_of_plot": "4000000","hl_nature_of_property": "Residential flat","survey_no": "182,183,184","flat_no": "Flat No.F-321",'+
        +'"floor_no": "Ground floor","stage_no": "1","property_address": "Flat No.F-321,sy no 182,183,184","society_name": "test","street_name": "Nizampet","taluka_name": "Bachupally",'+
        +'"city": "Hyderabad","district": "Medchal","state": "Telangana","pincode": "543112","location": "Urban","distance_of_property": "30 km","landmark": "White petals Mansion",'+
        +'"south": "Lake","west": "Road","east": "Puravankara apt","north": "White petals Mansion","market_value_of_land": "0","market_value_of_building": "237854","valuation_date": "2018-06-10","furniture_fixture_cost": "5432","land_cost": "1234",'+
        +'"built_up_area_sq_ft":"9887","cost_of_construction":"2345678","whether_construction_complete":"","age_of_building":"2","cost_of_repair":"45678","residual_life_of_property":"2",'+
        +'"valuers_name":"testname","legal_opinon_date":"","lawyer_name":"","cost_of_property":"","proposed_repair_value":""}]}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/UpdateProperty';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_UpdatePropertyinApplication.UpdateProperty();
        test.stoptest();
    }

    @istest
    public static void method2() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        //WS_Vendor_TestUtil.createCustomSettingRecords();         
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.LAPLOAN);  
        
        String jsonString ='{"applicationid": "'+app.Id+'", "CollateralDetails": [{"nature_of_property" : "Vehicles","collateral_use" : "Residential","em_charge_type" : "Additional","no_of_tenants" : "2","claimed_market_value" : "70000",'+
        +'"valuation_date" : "2018-09-08","is_legally_valid" : "Yes","survey_no" : "164","plot_no" : "89","floor_no" : "1","stage_no" : "4","village" : "Tavarekere","area_of_land_sq_ft" : "56","extent_carpet_area_sq_ft" : "78","built_up_area_sq_ft" : "89",'+
        +'"address" : "Main road","society_name" : "BTM Layout","street_name" : "Hosur road","taluka_name" : "Bangalore","district" : "Bangalore","city" : "Bangalore","pincode" : "560089","state" : "Karnataka",'+
        +'"location" : "Urban","distance_of_property" : "6","landmark" : "village supermarket","market_value_of_land" : "0","market_value_of_building" : "0","residual_life_of_property" : "3","south" : "lake","west" : "road","north" : "house","east" : "wall"}]}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/UpdateProperty';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
            WS_Vendor_UpdatePropertyinApplication.UpdateProperty();
        test.stoptest();
    }

    @istest
    public static void method3() {         
        WS_Vendor_TestUtil.kvbCompanyDetails();
        WS_Vendor_TestUtil.productDetails();
        //WS_Vendor_TestUtil.createCustomSettingRecords();
        Account ac = new Account();
        ac.RecordTypeId = WS_Vendor_RestAPIHelper.getRecordType(WS_Vendor_Constants.PERSON_ACCOUNT);
        ac.Aadhaar_Number__pc = 'TestRef123456789';
        ac.LastName = 'TestAccount';
        insert ac;
        genesis__Applications__c app = WS_Vendor_TestUtil.createApplication(WS_Vendor_Constants.LAPLOAN);  
        app.Sub_Stage__c = WS_Vendor_Constants.SUB_STAGE_CBS_PENDING;  
        app.genesis__Account__c = ac.Id;
        update app;    
        String jsonString ='{"applicationid": "'+app.Id+'", "CollateralDetails": [{"nature_of_property" : "Vehicles","collateral_use" : "Residential","em_charge_type" : "Additional","no_of_tenants" : "2","claimed_market_value" : "70000",'+
        +'"valuation_date" : "2018-09-08","is_legally_valid" : "Yes","survey_no" : "164","plot_no" : "89","floor_no" : "1","stage_no" : "4","village" : "Tavarekere","area_of_land_sq_ft" : "56","extent_carpet_area_sq_ft" : "78","built_up_area_sq_ft" : "89",'+
        +'"address" : "Main road","society_name" : "BTM Layout","street_name" : "Hosur road","taluka_name" : "Bangalore","district" : "Bangalore","city" : "Bangalore","pincode" : "560089","state" : "Karnataka",'+
        +'"location" : "Urban","distance_of_property" : "6","landmark" : "village supermarket","market_value_of_land" : "0","market_value_of_building" : "0","residual_life_of_property" : "3","south" : "lake","west" : "road","north" : "house","east" : "wall","Owners": [{"ApplicantId":"'+ac.Id+'"}]}]}';
        RestRequest req = new RestRequest();     
        req.requestURI = '/services/apexrest/UpdateProperty';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        test.starttest();
           // WS_Vendor_UpdatePropertyinApplication.UpdateProperty();    
           ThirdParty_BREScoreCal.Calculate_bre(app);       
        test.stoptest();
    }    
}