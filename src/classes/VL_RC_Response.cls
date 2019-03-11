/*
* Name    : VL_RC_Response
* Company : ET Marlabs
* Purpose : Class used for parsing response for new RC
* Author  : Braj
* CreatedDate : 29-Aug-2018
*/
public class VL_RC_Response {
    public String registration_number = '';
    public string chassis_number='';
    public string engine_number='';
    public string fuel_type ='';
    public string registration_date    ='';
    public string registering_authority ='';
    public string registration_state ='';
    public string vehicle_company ='';
    public string vehicle_model ='';
    public string vehicle_type='';
    public string vehicle_age ='';
    public string owners_name='';
    public string expiry_date='';
    public string fitness_certificate_expiry_date='';
    public string owner_serial_number='';
    public string financing_authority ='';
    public string blacklisted ='';
    public string blacklisted_reason='';
    public string mv_tax_paid_upto='';
    public string mv_tax_structure='';
    
    public static List<VL_RC_Response> parse(String json){
		return (List<VL_RC_Response>) System.JSON.deserialize(json, List<VL_RC_Response>.class);
	}
    
}