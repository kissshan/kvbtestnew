public with sharing class PassengerVehicleCallout {
    public static String auth;
    public PassengerVehicleCallout() {

    }
    public static Object getPasengerVehicleApi(Map<String, String> data,String action){
    try{


        String endPointWithData = callPasengerVehicleApi(data,action);
        System.debug('endPointWithData'+endPointWithData);
        auth=WS_ApiGatewayAccToken.getAccTkn();
        HTTPResponse response = new HTTPResponse();
        Map<String,String> headerMap = new Map<String,String>();
        //headerMap.put('Content-Type','application/json');

        headerMap.put('Authorization',auth);

        response= HttpUtility.sendHTTPRequest(endPointWithData, 'GET', null,null,headerMap,null);



        if(response.getStatusCode()== 200){
            String jsonData = response.getBody();
            System.debug('jsonData'+jsonData);


            return jsonData;
        }else{
            throw new CustomException('API Failed');
        }

        }catch(Exception ex){
            System.debug('LineNumber '+ex.getLineNumber());
            System.debug('ErrorMsg '+ex.getMessage());
            System.debug('CauseMsg '+ex.getCause());
            return ex.getMessage();
        }

    }
    public static String callPasengerVehicleApi(Map<String, String> data,String action){
        if(action == 'GET_STATE'){

            String endPointWithData = Utility.getFullEndpoints('TL_PV_STATELIST');
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;

        }else if(action == 'GET_CITIES'){
            String endPointWithData= Utility.getFullEndpoints('TL_PV_CITIES');
            if(data.containsKey('STATEID'))
            endPointWithData= endPointWithData.replace('stateId=', 'stateId='+Integer.valueOf(data.get('STATEID')));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_DEALERS'){
            String endPointWithData= Utility.getFullEndpoints('TL_PV_DEALERS');
            if(data.containsKey('MAKEID'))
            endPointWithData= endPointWithData.replace('makeId=', 'makeId='+Integer.valueOf(data.get('MAKEID')));
            if(data.containsKey('CITYID'))
            endPointWithData= endPointWithData.replace('cityId=', 'cityId='+Integer.valueOf(data.get('CITYID')));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_MAKE'){
            String endPointWithData= Utility.getFullEndpoints('TL_PV_MAKELIST');
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_MODEL'){
            String endPointWithData= Utility.getFullEndpoints('TL_PV_MODELLIST');
            if(data.containsKey('MAKEID'))
            endPointWithData= endPointWithData.replace('makeId=', 'makeId='+Integer.valueOf(data.get('MAKEID')));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_VERSION'){
            String endPointWithData = Utility.getFullEndpoints('TL_PV_VERSIONLIST');
            if(data.containsKey('MODELID'))
            endPointWithData= endPointWithData.replace('modelId=', 'modelId='+Integer.valueOf(data.get('MODELID')));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;

        }else if(action == 'GET_PRICE'){
            String endPointWithData= Utility.getFullEndpoints('TL_PV_PRICELIST');
            if(data.containsKey('VERSIONID'))
            endPointWithData= endPointWithData.replace('versionid=', 'versionid='+Integer.valueOf(data.get('VERSIONID')));
            if(data.containsKey('CITYID'))
            endPointWithData= endPointWithData.replace('cityId=', 'cityId='+Integer.valueOf(data.get('CITYID')));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_MAKE_BUS'){
            String endPointWithData= Utility.getFullEndpoints('TL_BS_MAKELIST');
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_CITIES_BUS'){
            String endPointWithData= Utility.getFullEndpoints('TL_BS_CITIES');
            if(data.containsKey('BRANDID'))
            endPointWithData=endPointWithData.replace('brand_link_rewrite=','brand_link_rewrite='+data.get('BRANDID'));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_DEALERS_BUS'){
            String endPointWithData=Utility.getFullEndpoints('TL_BUS_DEALERS');
            if(data.containskey('BRANDID'))
            endPointWithData=endPointWithData.replace('brand=','brand='+data.get('BRANDID'));
            if(data.containskey('CITYID'))
            endPointWithData=endPointWithData.replace('city=','city='+data.get('CITYID'));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }
        else if(action == 'GET_MODEL_BUS'){
            String endPointWithData=Utility.getFullEndpoints('TL_BS_MODEL');
            if(data.containskey('BRANDID'))
            endPointWithData=endPointWithData.replace('brand_link_rewrite=','brand_link_rewrite='+data.get('BRANDID'));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_VARIANT_BUS'){
            String endPointWithData=Utility.getFullEndpoints('TL_BS_VARIANT');
            if(data.containskey('BRANDID'))
            endPointWithData=endPointWithData.replace('brand_link_rewrite=','brand_link_rewrite='+data.get('BRANDID'));
            if(data.containskey('MODELID'))
            endPointWithData=endPointWithData.replace('model_link_rewrite=','model_link_rewrite='+data.get('MODELID'));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_MAKE_TRUCK'){
            String endPointWithData= Utility.getFullEndpoints('TL_TR_MAKELIST');
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_CITIES_TRUCK'){
            String endPointWithData= Utility.getFullEndpoints('TL_TR_CITIES');
            if(data.containskey('BRANDID'))
            endPointWithData=endPointWithData.replace('brand_link_rewrite=','brand_link_rewrite='+data.get('BRANDID'));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_DEALERS_TRUCK'){
            String endPointWithData=Utility.getFullEndpoints('TL_TR_DEALERS');
            if(data.containskey('BRANDID'))
            endPointWithData=endPointWithData.replace('brand=','brand='+data.get('BRANDID'));
            if(data.containskey('CITYID'))
            endPointWithData=endPointWithData.replace('city=','city='+data.get('CITYID'));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_MODEL_TRUCK'){
            String endPointWithData=Utility.getFullEndpoints('TL_TR_MODEL');
            if(data.containskey('BRANDID'))
            endPointWithData=endPointWithData.replace('brand_link_rewrite=','brand_link_rewrite='+data.get('BRANDID'));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }else if(action == 'GET_VARIANT_TRUCK'){
            String endPointWithData=Utility.getFullEndpoints('TL_TR_VARIANT');
            if(data.containskey('BRANDID'))
            endPointWithData=endPointWithData.replace('brand_link_rewrite=','brand_link_rewrite='+data.get('BRANDID'));
            if(data.containskey('MODELID'))
            endPointWithData=endPointWithData.replace('model_link_rewrite=','model_link_rewrite='+data.get('MODELID'));
            System.debug('endPointWithData'+endPointWithData);
            return endPointWithData;
        }


        else{
            return '';
        }
    }
}