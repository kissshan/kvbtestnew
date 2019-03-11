public with sharing class DealerAPICallout {
	public static String auth;
	/*public class DealerResponse{
		public cls_result[] result;
	}
	class cls_result {
		public String name;	//Kun Hyundai Purasaivakkam
		public String make;	//8
		public cls_addressDetails[] addressDetails;
	}
	class cls_addressDetails {
		public String id;	//
		public String address;	//No 7,Gangadeewarar Koil ST,Purasawakkam
		public String city;	//Chennai
		public String make;	//8
		public String email;	//kunrajeshm@gmail.com
		public String phone;	//9167014403
		public String pincode;	//600084
		public String state;	//Tamil Nadu
	}*/

	public static String getDealerDetails(String make_Id,String city_Id,String vehicle_type){
		try{
			
			HTTPResponse response = new HTTPResponse();
	        Map<String,String> headerMap = new Map<String,String>();  
	        //headerMap.put('Content-Type','application/json'); 
	        if(make_Id!= null && city_Id!=null && vehicle_type!=null ){
	        	auth=WS_ApiGatewayAccToken.getAccTkn();
	        	headerMap.put('Authorization',auth);
		        String endPointWithData= Utility.getFullEndpoints('Dealer_API_Callout');//'https://kvb-test.apigee.net/next/v1/vehiclemaster/dealers?makeId=&cityId=&vehicletype=';
				endPointWithData= endPointWithData.replace('makeId=', 'makeId='+make_Id);
				endPointWithData= endPointWithData.replace('cityId=', 'cityId='+city_Id);
				endPointWithData= endPointWithData.replace('vehicletype=', 'vehicletype='+vehicle_type);

		        response= HttpUtility.sendHTTPRequest(endPointWithData, 'GET', null,null,headerMap,null);
		        
			    

			    if(response.getStatusCode()== 200){
			    	String jsonData = response.getBody();
			    	System.debug('Dealer_API_Callout Res===> '+jsonData);
			    	return jsonData;
			    }else{
			    	throw new CustomException('API Failed');
			    }
	        }else{
	        	throw new CustomException('Required Data Missing');
	        }
	        
		}catch(Exception ex){
			System.debug('LineNumber '+ex.getLineNumber());
			System.debug('ErrorMsg '+ex.getMessage());
			System.debug('CauseMsg '+ex.getCause());
			return ex.getMessage();
		}

	}
}