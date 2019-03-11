/*
* Name    : WS_Vendor_UpdatePropertyinApplication
* Company : ET Marlabs
* Purpose : This class is used to update the property in application from 3rd party
* Author  : Dipen 
*/
@RestResource(urlMapping='/UpdateProperty')
global class WS_Vendor_UpdatePropertyinApplication{
 
    public cls_APPLICATION_DETAILS Application_Details;

    global class Response extends WS_Vendor_RestAPIHelper.WS_Vendor_Response{
        public String Application_Name;
        public String ApplicationId;
    
        global Response(){
            Application_Name = '';
            ApplicationId = ''; 
        }
    } 
    
    public class cls_APPLICATION_DETAILS{
        public String applicationid;
        /*public String Owner_name;    
        public String property_type;
        public String existing_builtuparea; 
        public String site_extent_area_of_the_land; 
        public String date_of_commencement; 
        public String uds;   
        public String date_of_completion;   
        public String cost_of_plot;  
        public String nature_of_property;   
        public String survey_no;
        public String plot_no;
        public String floor_no;
        public String property_no;
        public String address;
        public String property_society;
        public String property_streetname;
        public String property_taluka;
        public String city;
        public String property_district;
        public String state;
        public String pincode;
        public String location_of_property;
        public String distance_of_property;
        public String nearest_landmark;
        public String south;
        public String west;
        public String east;
        public String north;
        public String marketvalue_of_land;
        public String marketvalue_of_building;
        //public String totalmarketvalue;
        public String date_valuation;  
        public String furniture_fixture_cost;
        public String land_cost; */

        public cls_Collateral[] CollateralDetails;    
    }

    public class cls_Collateral {
        //For LAP
        public String nature_of_property; 
        public String collateral_use;   
        public String em_charge_type;   
        public String no_of_tenants;    
        public String claimed_market_value; 
        public String valuation_date;   
        public String is_legally_valid; 
        public String survey_no;    
        public String plot_no;  
        public String floor_no; 
        public String stage_no; 
        public String village;  
        public String area_of_land_sq_ft;   
        public String extent_carpet_area_sq_ft; 
        public String built_up_area_sq_ft;  
        public String address;  
        public String society_name; 
        public String street_name;  
        public String taluka_name;  
        public String district; 
        public String city; 
        public String pincode;  
        public String state;    
        public String location; 
        public String distance_of_property; 
        public String landmark; 
        public String market_value_of_land; 
        public String market_value_of_building; 
        public String residual_life_of_property;    
        public String south;    
        public String west; 
        public String north;    
        public String east; 
        public cls_Owners[] Owners;

        //For VL
        public String Type_Of_Loan;
        public String accessories_value;    
        public String advances_paid;    
        public String chassis_no;   
        public String dd_amount;    
        public String dd_date;  
        public String dealer_email; 
        public String dealer_name;  
        public String dealer_phone; 
        public String dealer_pin;   
        public String exshowroom_price; 
        public String exshowroom_price_car; 
        public String final_vehicle_value;  
        public String financing_authority;  
        public String proforma_invoice_date;    
        public String proforma_invoice_no;  
        public String registration_date;    
        public String registration_no;  
        public String RC_response_error_code;   
        public String RC_response_error_message;    
        public String registration_cost;    
        public String security_details; 
        public String total_vehicle_value;  
        public String variant;  
        public String vehicle_age;  
        public String vehicle_calculated_value; 
        public String vehicle_company;  
        public String vehicle_model;    
        public String vehicle_number;   
        public String vehicle_owner_name;   
        public String manufacturer_name;    
        public String model_name;   
        public String year_name;   
        public String month;
        /*public String address_name; 
        public String city_name;    
        public String state_name;     present in LAP*/
        public String insurance_amount; 
        public String certificated; 
        public String homestead_property;   
        public String collateral_insurance_required;    
        public String IDERA;    
        public String vehicle_serial_no;    
        public String vehicle_description;  
        public String scheme_type; 
        public String body_style;  

        //For HL
        public String Owner_name;   
        public String property_type;    
        public String site_extent_area_of_the_land; 
        public String date_of_commencement; 
        public String uds;  
        public String date_of_completion;   
        public String cost_of_plot; 
        public String hl_nature_of_property;      
        public String flat_no;
        public String property_address;        
        public String furniture_fixture_cost;   
        public String land_cost;    
        public String cost_of_construction; 
        public String whether_construction_complete;    
        public String cost_of_land; 
        public String age_of_building;  
        public String cost_of_repair;     
        public String valuers_name; 
        public String legal_opinon_date;    
        public String lawyer_name;  
        public String cost_of_property; 
        public String proposed_repair_value;     
    }

    public class cls_Owners {
        public String ApplicantId;  
    }
 
    @HttpPost
    global static Response UpdateProperty(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
        if(req == null || req.requestBody == null){
            return getWSResponse(res, Constants.WS_ERROR_STATUS, '', Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL,'');
        }else{
            try{
                String jsonData  = req.requestBody.toString();
                cls_APPLICATION_DETAILS reqApp  = (cls_APPLICATION_DETAILS)Json.deserialize(jsonData, cls_APPLICATION_DETAILS.class);
               
                genesis__Applications__c application = new genesis__Applications__c();              
                application = [select Id,Name,Record_Type_Name__c,Sub_Stage__c,Sourced_By__c from genesis__Applications__c where Id =: reqApp.applicationid];
                List<clcommon__Collateral__c> colList = new List<clcommon__Collateral__c>();
                List<Ownership__c> ownersList = new List<Ownership__c>();
                Map<Id,Integer> mapOwnerCol = new Map<Id,Integer>();
                
                //Map application fields for HL
                /*if(application.Record_Type_Name__c == WS_Vendor_Constants.HOMELOAN){ 
                    String s = checkForInvalidValues(reqApp,null);
                    if(s != null && s != ''){
                        return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_CODE, s,WS_Vendor_Constants.WS_ERROR_TYPE );                
                    }               
                    if(!String.isBlank(reqApp.Owner_name)){
                        application.Name_Of_The_Builder__c = reqApp.Owner_name;
                    }
                    if(!String.isBlank(reqApp.property_type)){
                        application.Property_Type__c = reqApp.property_type;
                    }
                    if(!String.isBlank(reqApp.existing_builtuparea)){
                        application.Existing_Built_up_Area__c = reqApp.existing_builtuparea;
                    }
                    if(!String.isBlank(reqApp.site_extent_area_of_the_land)){
                        application.Area_of_the_Land__c = reqApp.site_extent_area_of_the_land;
                    }
                    if(!String.isBlank(reqApp.date_of_commencement)){
                        application.Date_Of_Commencement__c = date.valueOf(reqApp.date_of_commencement);
                    }
                    if(!String.isBlank(reqApp.uds)){
                        application.UDS_Sq_Ft__c = decimal.valueOf(reqApp.uds);
                    }
                    if(!String.isBlank(reqApp.date_of_completion)){
                        application.Date_Of_Completion__c = date.valueOf(reqApp.date_of_completion);
                    }
                    if(!String.isBlank(reqApp.cost_of_plot)){
                        application.Cost_Of_Flat_House__c = decimal.valueOf(reqApp.cost_of_plot);
                    }
                    if(!String.isBlank(reqApp.nature_of_property)){
                        application.Nature_Of_Property__c = reqApp.nature_of_property;
                    }
                    if(!String.isBlank(reqApp.survey_no)){
                        application.Survey_No_Katha_No_Other_No_s__c = reqApp.survey_no;
                    }
                    if(!String.isBlank(reqApp.plot_no)){
                        application.Flat_No__c = reqApp.plot_no;
                    }
                    if(!String.isBlank(reqApp.floor_no)){
                        application.Floor_No__c = reqApp.floor_no;
                    }
                    if(!String.isBlank(reqApp.property_no)){
                        application.Stage_Sector_Ward_Block_No__c = reqApp.property_no;
                    }
                    if(!String.isBlank(reqApp.address)){
                        application.Property_Address__c = reqApp.address;
                    }
                    if(!String.isBlank(reqApp.property_society)){
                        application.Name_Of_The_Socity__c = reqApp.property_society;
                    }
                    if(!String.isBlank(reqApp.property_streetname)){
                        application.Street_Name__c = reqApp.property_streetname;
                    }
                    if(!String.isBlank(reqApp.property_taluka)){
                        application.Taluka_Tehsil__c = reqApp.property_taluka;
                    }
                    if(!String.isBlank(reqApp.city)){
                        application.Property_City__c = reqApp.city;
                    }
                    if(!String.isBlank(reqApp.property_district)){
                        application.Property_District__c = reqApp.property_district;
                    }
                    if(!String.isBlank(reqApp.state)){
                        application.Property_State__c = reqApp.state;
                    }
                    if(!String.isBlank(reqApp.pincode)){
                        application.Property_Pincode__c = reqApp.pincode;
                    }
                    if(!String.isBlank(reqApp.location_of_property)){
                        application.Location_Of_The_Property__c = reqApp.location_of_property;
                    }
                    if(!String.isBlank(reqApp.distance_of_property)){
                        application.Distance_Of_The_Property__c = reqApp.distance_of_property;
                    }
                    if(!String.isBlank(reqApp.nearest_landmark)){
                        application.Nearest_Landmark__c = reqApp.nearest_landmark;
                    }
                    if(!String.isBlank(reqApp.south)){
                        application.Boundaries_South__c = reqApp.south;
                    }
                    if(!String.isBlank(reqApp.west)){
                        application.Boundaries_West__c = reqApp.west;
                    }
                    if(!String.isBlank(reqApp.east)){
                        application.Boundaries_East__c = reqApp.east;
                    }
                    if(!String.isBlank(reqApp.north)){
                        application.Boundaries_North__c = reqApp.north;
                    }
                    if(!String.isBlank(reqApp.marketvalue_of_land)){
                        application.Market_Value_Of_The_Land__c = decimal.valueOf(reqApp.marketvalue_of_land);
                    }
                    if(!String.isBlank(reqApp.marketvalue_of_building)){
                        application.Market_Value_Of_The_Building__c = decimal.valueOf(reqApp.marketvalue_of_building);
                    }
                    /*if(!String.isBlank(reqApp.totalmarketvalue)){
                        application.Total_Market_value__c = reqApp.totalmarketvalue;
                    }
                    if(!String.isBlank(reqApp.date_valuation)){
                        application.Date_Of_Valuation__c = date.valueOf(reqApp.date_valuation);
                    }
                    if(!String.isBlank(reqApp.furniture_fixture_cost)){
                        application.genesis__Total_Pledged_Collateral_Amount__c  = decimal.valueOf(reqApp.furniture_fixture_cost);
                    }
                    if(!String.isBlank(reqApp.land_cost)){
                        application.genesis__Collateral_Value__c = decimal.valueOf(reqApp.land_cost);
                    }                    
                }*/
                List<String> usrList1 = new List<String>();
                usrList1 = WS_Vendor_RestAPIHelper.getUserList(application.Sourced_By__c);
                if(reqApp.CollateralDetails!=null){
                    Integer i = 0;                    
                    for(cls_Collateral col : reqApp.CollateralDetails){  
                        String s = checkForInvalidValues(null,col);
                        if(s != null && s != ''){
                            return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_CODE, s,WS_Vendor_Constants.WS_ERROR_TYPE );                
                        }                      
                        clcommon__Collateral__c collateral = new clcommon__Collateral__c();
                        collateral.clcommon__Collateral_Name__c = WS_Vendor_RestAPIHelper.getRandomExternalIdForCollateral();  
                        //LAP Collateral Mapping
                        if(!String.isBlank(col.nature_of_property)){
                            collateral.Collateral_Type__c = col.nature_of_property;
                        }
                        if(!String.isBlank(col.collateral_use)){
                            collateral.Collateral_Uses__c = col.collateral_use;
                        }
                        if(!String.isBlank(col.em_charge_type)){
                            collateral.EM_Charge_Types__c = col.em_charge_type;
                        }
                        if(!String.isBlank(col.no_of_tenants)){
                            collateral.No_of_tenants__c = col.no_of_tenants;
                        }
                        if(!String.isBlank(col.claimed_market_value)){
                            collateral.Collateral_Market_Value__c = decimal.ValueOf(col.claimed_market_value);
                        }
                        if(!String.isBlank(col.valuation_date)){
                            collateral.Valuation_Date__c = date.ValueOf(col.valuation_date);
                        }
                        if(!String.isBlank(col.is_legally_valid)){
                            collateral.Is_property_legally_valid__c = col.is_legally_valid;
                        }
                        if(!String.isBlank(col.survey_no)){
                            collateral.SurveyKhasraKhataPatta_No__c = col.survey_no;
                        }
                        if(!String.isBlank(col.plot_no)){
                            collateral.PlotDoorShopBungalow_No__c = col.plot_no;
                        }
                        if(!String.isBlank(col.floor_no)){
                            collateral.Floor_No__c = col.floor_no;
                        }
                        if(!String.isBlank(col.stage_no)){
                            collateral.Stage_Sector_Ward_Block_No__c = col.stage_no;
                        }
                        if(!String.isBlank(col.village)){
                            collateral.VillageTown__c = col.village;
                        }
                        if(!String.isBlank(col.area_of_land_sq_ft)){
                            collateral.Vacant_Land_area__c = decimal.ValueOf(col.area_of_land_sq_ft);
                        }
                        if(!String.isBlank(col.extent_carpet_area_sq_ft)){
                            collateral.ExtentCarpet_area_Built_up_area__c = col.extent_carpet_area_sq_ft;
                        }
                        if(!String.isBlank(col.built_up_area_sq_ft)){
                            collateral.Buildup_Area__c = decimal.ValueOf(col.built_up_area_sq_ft);
                        }
                        if(!String.isBlank(col.address)){
                            collateral.clcommon__Address__c = col.address; //also for VL
                        }
                        if(!String.isBlank(col.society_name)){
                            collateral.Building_Society_Name__c = col.society_name;
                        }
                        if(!String.isBlank(col.street_name)){
                            collateral.Street_NameNo__c = col.street_name;
                        }
                        if(!String.isBlank(col.taluka_name)){
                            collateral.TalukaTehsil__c = col.taluka_name;
                        }
                        if(!String.isBlank(col.district)){
                            collateral.District_Name__c = col.district;
                        }
                        if(!String.isBlank(col.city)){
                            collateral.clcommon__City__c = col.city; //also for VL
                        }
                        if(!String.isBlank(col.pincode)){
                            collateral.Property_Pincode__c = col.pincode;
                        }
                        if(!String.isBlank(col.state)){ 
                            collateral.State__c = col.state; //also for VL
                        }
                        if(!String.isBlank(col.location)){
                            collateral.Location_Of_The_Property__c  = col.location;
                        }
                        if(!String.isBlank(col.distance_of_property)){
                            collateral.Distance_Of_The_Property__c = col.distance_of_property;
                        }
                        if(!String.isBlank(col.landmark)){
                            collateral.Landmark__c = col.landmark;
                        }
                        if(!String.isBlank(col.market_value_of_land)){
                            collateral.Market_Value_Of_The_Land__c = decimal.ValueOf(col.market_value_of_land);
                        }
                        if(!String.isBlank(col.market_value_of_building)){
                            collateral.Market_Value_Of_The_Building__c = decimal.ValueOf(col.market_value_of_building);
                        }
                        if(!String.isBlank(col.residual_life_of_property)){
                            collateral.Residual_Life_of_Property__c = decimal.ValueOf(col.residual_life_of_property);
                        }
                        if(!String.isBlank(col.south)){
                            collateral.Boundaries_South__c = col.south;
                        }
                        if(!String.isBlank(col.west)){
                            collateral.Boundaries_West__c = col.west;
                        }
                        if(!String.isBlank(col.north)){
                            collateral.Boundaries_North__c = col.north;
                        }
                        if(!String.isBlank(col.east)){
                            collateral.Boundaries_East__c = col.east;
                        }
                        //VL Collateral Mapping
                        if(!String.isBlank(col.accessories_value)){
                            collateral.Accessories_value__c = decimal.valueOf(col.accessories_value);
                        }
                        if(!String.isBlank(col.advances_paid)){
                            collateral.Advances_Paid__c = decimal.valueOf(col.advances_paid);
                        }
                        if(!String.isBlank(col.chassis_no)){
                            collateral.Chassis_Number__c = col.chassis_no;
                        }
                        if(!String.isBlank(col.dd_amount)){
                            collateral.DD_Amount__c = col.dd_amount;
                        }
                        if(!String.isBlank(col.dd_date)){
                            collateral.DD_Date__c = date.valueOf(col.dd_date);
                        }
                        if(!String.isBlank(col.dealer_email)){
                            collateral.Dealer_Email__c = col.dealer_email;
                        }
                        if(!String.isBlank(col.dealer_name)){
                            collateral.Dealer_name__c = col.dealer_name;
                        }
                        if(!String.isBlank(col.dealer_phone)){
                            collateral.Dealer_Phone_Number__c = col.dealer_phone;
                        }
                        if(!String.isBlank(col.dealer_pin)){
                            collateral.Dealer_Pincode__c = col.dealer_pin;
                        }
                        if(!String.isBlank(col.exshowroom_price)){
                            collateral.ExShow_Room_Price__c = decimal.valueOf(col.exshowroom_price);
                        }
                        if(!String.isBlank(col.exshowroom_price_car)){
                            collateral.ExshowRoomPrice_Api__c = decimal.valueOf(col.exshowroom_price_car);
                        }
                        if(!String.isBlank(col.final_vehicle_value)){
                            collateral.Final_vehicle_value__c = decimal.valueOf(col.final_vehicle_value);
                        }
                        if(!String.isBlank(col.financing_authority)){
                            collateral.Financing_Authority__c = col.financing_authority;
                        }
                        if(!String.isBlank(col.proforma_invoice_date)){
                            collateral.Proforma_Invoice_Date__c = date.valueOf(col.proforma_invoice_date);
                        }
                        if(!String.isBlank(col.proforma_invoice_no)){
                            collateral.Proforma_Invoice_No__c = col.proforma_invoice_no;
                        }
                        if(!String.isBlank(col.registration_date)){
                            collateral.RC_Date__c = date.valueOf(col.registration_date);
                        }
                        if(!String.isBlank(col.registration_no)){
                            collateral.RC_No__c = col.registration_no;
                        }
                        if(!String.isBlank(col.RC_response_error_code)){
                            collateral.RC_Response_Error_Code__c = col.RC_response_error_code;
                        }
                        if(!String.isBlank(col.RC_response_error_message)){
                            collateral.RC_Response_Error_Message__c = col.RC_response_error_message;
                        }
                        if(!String.isBlank(col.registration_cost)){
                            collateral.Registration_cost__c = decimal.valueOf(col.registration_cost);
                        }
                        if(!String.isBlank(col.security_details)){
                            collateral.Security_Details__c = col.security_details;
                        }
                        if(!String.isBlank(col.total_vehicle_value)){
                            collateral.Total_Vehicle_Value__c = decimal.valueOf(col.total_vehicle_value);
                        }
                        if(!String.isBlank(col.variant)){
                            collateral.Variant__c = col.variant;
                        }
                        if(!String.isBlank(col.vehicle_age)){
                            collateral.Vehicle_Age__c = col.vehicle_age;
                        }
                        if(!String.isBlank(col.vehicle_calculated_value)){
                            collateral.Vehicle_CalculatedValue__c = col.vehicle_calculated_value;
                        }
                        if(!String.isBlank(col.vehicle_company)){
                            collateral.Vehicle_Company__c = col.vehicle_company;
                        }
                        if(!String.isBlank(col.vehicle_model)){
                            collateral.Vehicle_Model__c = col.vehicle_model;
                        }
                        if(!String.isBlank(col.vehicle_number)){
                            collateral.Vehicle_Number__c = col.vehicle_number;
                        }
                        if(!String.isBlank(col.vehicle_owner_name)){
                            collateral.Vehicle_Owner_Name__c = col.vehicle_owner_name;
                        }
                        if(!String.isBlank(col.manufacturer_name)){
                            collateral.clcommon__Manufacturer__c = col.manufacturer_name;
                        }
                        if(!String.isBlank(col.model_name)){
                            collateral.clcommon__Model__c = col.model_name;
                        }
                        if(!String.isBlank(col.year_name)){
                            collateral.clcommon__Year__c = col.year_name;
                        }  
                        if(!String.isBlank(col.month)){
                            collateral.Month__c = col.month;
                        }  
                        if(!String.isBlank(col.insurance_amount)){
                            collateral.clcommon__Insurance_Amount__c = decimal.valueOf(col.insurance_amount);
                        }
                        if(!String.isBlank(col.certificated)){
                            collateral.clcommon__Certificated__c = boolean.valueOf(col.certificated);
                        }
                        if(!String.isBlank(col.homestead_property)){
                            collateral.clcommon__Homestead_Property__c = boolean.valueOf(col.homestead_property);
                        }
                        if(!String.isBlank(col.collateral_insurance_required)){
                            collateral.clcommon__Collateral_Insurance_Required__c = boolean.valueOf(col.collateral_insurance_required);
                        }
                        if(!String.isBlank(col.IDERA)){
                            collateral.clcommon__IDERA__c = boolean.valueOf(col.IDERA);
                        }
                        if(!String.isBlank(col.vehicle_serial_no)){
                            collateral.clcommon__Vehicle_Serial_Number__c = col.vehicle_serial_no;
                        }
                        if(!String.isBlank(col.vehicle_description)){
                            collateral.clcommon__Description__c = col.vehicle_description;
                        }
                        if(!String.isBlank(col.scheme_type)){
                            collateral.Scheme_Type__c = col.scheme_type;
                        }
                        //HL Collateral mapping
                        if(!String.isBlank(col.Owner_name)){
                            collateral.Builder_Present_Owner_Seller_Name__c = col.Owner_name;
                        }
                        if(!String.isBlank(col.property_type)){
                            collateral.clcommon__Property_Type__c = col.property_type;
                        }
                        if(!String.isBlank(col.site_extent_area_of_the_land)){
                            collateral.Area_of_the_Land__c = decimal.valueof(col.site_extent_area_of_the_land);
                        }
                        if(!String.isBlank(col.date_of_commencement)){
                            collateral.Date_Of_Commencement__c = date.valueOf(col.date_of_commencement);
                        }
                        if(!String.isBlank(col.uds)){
                            collateral.UDS_Sq_Ft__c = decimal.valueOf(col.uds);
                        }
                        if(!String.isBlank(col.date_of_completion)){
                            collateral.Date_Of_Completion__c = date.valueOf(col.date_of_completion);
                        }
                        if(!String.isBlank(col.cost_of_plot)){
                            collateral.Cost_Of_Flat_House__c = decimal.valueOf(col.cost_of_plot);
                        }
                        if(!String.isBlank(col.hl_nature_of_property)){
                            collateral.Nature_Of_Property__c = col.hl_nature_of_property;
                        }
                        if(!String.isBlank(col.flat_no)){
                            collateral.Flat_Door_Shop_Bungalow_Nos__c = col.flat_no;
                        }
                        if(!String.isBlank(col.property_address)){
                            collateral.Property_Address__c = col.property_address;
                        }
                        if(!String.isBlank(col.furniture_fixture_cost)){
                            collateral.Furniture_Fixture_Cost__c = decimal.ValueOf(col.furniture_fixture_cost);
                        }
                        if(!String.isBlank(col.land_cost)){
                            collateral.Cost_Of_Land__c = decimal.valueOf(col.land_cost);
                        }
                        if(!String.isBlank(col.cost_of_construction)){
                            collateral.Cost_Of_Construction__c = decimal.valueOf(col.cost_of_construction);
                        }
                        if(!String.isBlank(col.whether_construction_complete)){
                            collateral.Whether_The_Construction_Completed__c = boolean.valueOf(col.whether_construction_complete);
                        }
                        if(!String.isBlank(col.age_of_building)){
                            collateral.Age_Of_The_Building__c = decimal.valueOf(col.age_of_building);
                        }
                        if(!String.isBlank(col.cost_of_repair)){
                            collateral.Cost_Of_Repair__c = decimal.valueOf(col.cost_of_repair);
                        }
                        if(!String.isBlank(col.valuers_name)){
                            collateral.Valuer_Name__c = col.valuers_name;
                        }
                        if(!String.isBlank(col.legal_opinon_date)){
                            collateral.Legal_Opinion_Date__c = date.valueOf(col.legal_opinon_date);
                        }
                        if(!String.isBlank(col.lawyer_name)){
                            collateral.Advocate_Name__c = col.lawyer_name;
                        }
                        if(!String.isBlank(col.cost_of_property)){
                            collateral.Cost_of_Property__c = decimal.valueOf(col.cost_of_property);
                        }
                        if(!String.isBlank(col.proposed_repair_value)){
                            collateral.Market_valueProposedRepairs_Renovation__c = decimal.valueOf(col.proposed_repair_value);
                        }
                        if(!String.isBlank(col.body_style)){
                            collateral.clcommon__Style__c = col.body_style;
                        }

                        if(!String.isBlank(reqApp.applicationid)){
                            collateral.genesis__Application__c = reqApp.applicationid;
                        }
                        if(usrList1.size()>0){
                            collateral.OwnerId = usrList1[0];
                        }
                        if(col.Owners!=null){
                            for(cls_Owners own:col.Owners){                                                            
                                mapOwnerCol.put(own.ApplicantId,i);
                            }
                        }   
                        colList.add(collateral);                                                                          
                        i++;
                    }
                }

                if(colList.size()>0){
                    insert colList;
                }

                for(Id appId : mapOwnerCol.keyset()){
                    Ownership__c own = new Ownership__c();
                    own.Account__c = appId;
                    own.Collateral__c = colList[mapOwnerCol.get(appId)].Id;
                    if(usrList1.size()>0){
                        own.OwnerId = usrList1[0];
                    }
                    ownersList.add(own);
                }

                if(ownersList.size()>0){
                    insert ownersList;
                }
                
                application.Sub_Stage__c = WS_Vendor_Constants.SUB_STAGE_CBS_PENDING;                
                update application;
                res.Application_Name = application.Name;
                res.ApplicationId = application.Id;
                return getWSResponse(res, WS_Vendor_Constants.WS_SUCCESS_STATUS, '', WS_Vendor_Constants.WS_SUCCESS_CODE, '', '');      
            }
            catch(Exception e){                
                system.debug(e.getMessage()+' At '+e.getLineNumber());
                return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_INTERNAL_CODE, WS_Vendor_Constants.WS_INTERNAL_ERROR,WS_Vendor_Constants.WS_ERROR_TYPE_INTERNAL);
            } 
       
        }
    }
    static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg, string errType){
        res.status           = status;
        res.successMessage  = succMsg;
        res.statusCode        = statusCode;
        res.errorMessage  = errMsg;
        res.errorType = errType;
        return res;
    }


    static String checkForInvalidValues(cls_APPLICATION_DETAILS reqApp,cls_Collateral col){
        String s = '';
        /*if(reqApp!=null){
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.uds)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.uds)){
                    s = 'Invalid uds field value';  
                } 
            } 
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.cost_of_plot)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.cost_of_plot)){
                    s = 'Invalid cost_of_plot field value';  
                } 
            } 
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.marketvalue_of_land)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.marketvalue_of_land)){
                    s = 'Invalid marketvalue_of_land field value';  
                } 
            } 
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.marketvalue_of_building)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.marketvalue_of_building)){
                    s = 'Invalid marketvalue_of_building field value';  
                } 
            } 
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.furniture_fixture_cost)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(reqApp.furniture_fixture_cost)){
                    s = 'Invalid furniture_fixture_cost field value';  
                } 
            } 
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.date_of_commencement)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(reqApp.date_of_commencement)){
                    s = 'Invalid date_of_commencement field value';  
                } 
            } 
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.date_of_completion)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(reqApp.date_of_completion)){
                    s = 'Invalid date_of_completion field value';  
                } 
            } 
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(reqApp.date_valuation)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(reqApp.date_valuation)){
                    s = 'Invalid date_valuation field value';  
                } 
            } 
        }*/
        //for LAP
        if(col!=null){
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.valuation_date)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(col.valuation_date)){
                    s = 'Invalid valuation_date field value';  
                } 
            } 
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.claimed_market_value)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.claimed_market_value)){
                    s = 'Invalid claimed_market_value field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.area_of_land_sq_ft)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.area_of_land_sq_ft)){
                    s = 'Invalid area_of_land_sq_ft field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.built_up_area_sq_ft)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.built_up_area_sq_ft)){
                    s = 'Invalid built_up_area_sq_ft field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.market_value_of_land)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.market_value_of_land)){
                    s = 'Invalid market_value_of_land field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.market_value_of_building)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.market_value_of_building)){
                    s = 'Invalid market_value_of_building field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.residual_life_of_property)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.residual_life_of_property)){
                    s = 'Invalid residual_life_of_property field value';  
                } 
            }
            //for VL
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.accessories_value)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.accessories_value)){
                    s = 'Invalid accessories_value field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.advances_paid)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.advances_paid)){
                    s = 'Invalid advances_paid field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.dd_date)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(col.dd_date)){
                    s = 'Invalid dd_date field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.exshowroom_price)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.exshowroom_price)){
                    s = 'Invalid exshowroom_price field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.exshowroom_price_car)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.exshowroom_price_car)){
                    s = 'Invalid exshowroom_price_car field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.final_vehicle_value)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.final_vehicle_value)){
                    s = 'Invalid final_vehicle_value field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.proforma_invoice_date)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(col.proforma_invoice_date)){
                    s = 'Invalid proforma_invoice_date field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.registration_date)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(col.registration_date)){
                    s = 'Invalid registration_date field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.registration_cost)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.registration_cost)){
                    s = 'Invalid registration_cost field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.total_vehicle_value)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.total_vehicle_value)){
                    s = 'Invalid total_vehicle_value field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.insurance_amount)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.insurance_amount)){
                    s = 'Invalid insurance_amount field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.certificated)){
                if(!WS_Vendor_RestAPIHelper.ISBoolean(col.certificated)){
                    s = 'Invalid certificated field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.homestead_property)){
                if(!WS_Vendor_RestAPIHelper.ISBoolean(col.homestead_property)){
                    s = 'Invalid homestead_property field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.collateral_insurance_required)){
                if(!WS_Vendor_RestAPIHelper.ISBoolean(col.collateral_insurance_required)){
                    s = 'Invalid collateral_insurance_required field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.IDERA)){
                if(!WS_Vendor_RestAPIHelper.ISBoolean(col.IDERA)){
                    s = 'Invalid IDERA field value';  
                } 
            }
            //For HL
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.uds)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.uds)){
                    s = 'Invalid uds field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.date_of_commencement)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(col.date_of_commencement)){
                    s = 'Invalid date_of_commencement field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.date_of_completion)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(col.date_of_completion)){
                    s = 'Invalid date_of_completion field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.cost_of_plot)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.cost_of_plot)){
                    s = 'Invalid cost_of_plot field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.furniture_fixture_cost)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.furniture_fixture_cost)){
                    s = 'Invalid furniture_fixture_cost field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.land_cost)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.land_cost)){
                    s = 'Invalid land_cost field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.cost_of_construction)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.cost_of_construction)){
                    s = 'Invalid cost_of_construction field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.whether_construction_complete)){
                if(!WS_Vendor_RestAPIHelper.ISBoolean(col.whether_construction_complete)){
                    s = 'Invalid whether_construction_complete field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.age_of_building)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.age_of_building)){
                    s = 'Invalid age_of_building field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.cost_of_repair)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.cost_of_repair)){
                    s = 'Invalid cost_of_repair field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.legal_opinon_date)){
                if(!WS_Vendor_RestAPIHelper.isValidDate(col.legal_opinon_date)){
                    s = 'Invalid legal_opinon_date field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.cost_of_property)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.cost_of_property)){
                    s = 'Invalid cost_of_property field value';  
                } 
            }
            if(WS_Vendor_RestAPIHelper.ISStringBlankorNull(s) && !WS_Vendor_RestAPIHelper.ISStringBlankorNull(col.proposed_repair_value)){
                if(!WS_Vendor_RestAPIHelper.isNumeric(col.proposed_repair_value)){
                    s = 'Invalid proposed_repair_value field value';  
                } 
            }
        }
        system.debug('string s'+s);
        return s;
    }
}