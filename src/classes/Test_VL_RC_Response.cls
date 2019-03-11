@isTest
public class Test_VL_RC_Response {
@isTest
    public static void method1(){
        String reqBody = '[{"registration_number":"TN47U6007","chassis_number":"MA3EED81SOO8XXXXX","engine_number":"F10DN47XXXXX","fuel_type":"PETROL","registration_date":"22-Mar-2010","registering_authority":"KARUR RTO","registration_state":"TAMIL NADU","vehicle_company":"MARUTI SUZUKI INDIA LTD","vehicle_model":"WAGON R VXI SBIII","vehicle_type":"MOTOR CAR (L)","vehicle_age":"8 Years & 6 Months old","owners_name":"S.MANIVANNAN","fitness_upto":"21-Mar-2025","fuel_norms":"NOT AVAILABLE","insurance_upto":"02-Feb-2019","expiry_date":"NA","fitness_certificate_expiry_date":"21-Mar-2025","owner_serial_number":"1","financing_authority":"THE KARUR VYSYA BANK LTD","blacklisted":false,"blacklisted_reason":"","mv_tax_paid_upto":"NA","mv_tax_structure":"LifeTime"}]';
        VL_RC_Response ob=new VL_RC_Response();
        VL_RC_Response.parse(reqBody);
    }
    
}