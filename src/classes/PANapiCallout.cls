public with sharing class PANapiCallout {
	public PANapiCallout() {
		
	}
	public static String auth;
	public static String getPANDetails(String pan_Id){
		try{
			auth=WS_ApiGatewayAccToken.getAccTkn();
			HTTPResponse response = new HTTPResponse();
	        Map<String,String> headerMap = new Map<String,String>();  
	        //headerMap.put('Content-Type','application/json');
	        if(pan_Id!=null){
	        	headerMap.put('Authorization',auth);
		        String endPointWithData= Utility.getFullEndpoints('PAN_API_Callout');//'https://kvb-test.apigee.net/next/v1/vehiclemaster/dealers?makeId=&cityId=&vehicletype=';
				endPointWithData= endPointWithData+pan_Id;

		        response= HttpUtility.sendHTTPRequest(endPointWithData, 'GET', null,null,headerMap,null);
		        
			    

			    if(response.getStatusCode()== 200){
			    	String jsonData = response.getBody();
			    	System.debug('PAN_API_Callout Res===> '+jsonData);
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