public with sharing class GSTapiCallout {
	public static String auth;
	public GSTapiCallout() {
		
	}
	public static Object getGSTDetails(String gst_In,String action){
		try{
			auth=WS_ApiGatewayAccToken.getAccTkn();
			HTTPResponse response = new HTTPResponse();
	        Map<String,String> headerMap = new Map<String,String>();  
	        //headerMap.put('Content-Type','application/json');
	        if(gst_In!=null && action!=null){
	        	headerMap.put('Authorization',auth);
		        String endPointWithData= Utility.getFullEndpoints('GST_API_Callout');//'https://kvb-test.apigee.net/next/v1/vehiclemaster/dealers?makeId=&cityId=&vehicletype=';
				endPointWithData= endPointWithData.replace('gstin=', 'gstin='+gst_In);
				endPointWithData= endPointWithData.replace('action=', 'action='+action);
                //endPointWithData = 'https://kvb-test.apigee.net/next/v1/gst/searchtaxpayer?gstin=&action=';
		        response= HttpUtility.sendHTTPRequest(endPointWithData, 'GET', null,null,headerMap,null);
		        
			    

			    if(response.getStatusCode()== 200){
			    	/*String jsonData = response.getBody();
                    
                    System.debug('GST_API_Callout Res===> '+jsonData);
                    PassengerVehicleWrappers.stateClass stateResults = (PassengerVehicleWrappers.stateClass) System.JSON.deserialize(jsonData, PassengerVehicleWrappers.stateClass.class);
			    	System.debug('GST_API_Callout Res===> '+stateResults);*/
                    //objToBeReturned = stateResults;
                    
			    	return response.getBody();
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