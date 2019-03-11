/*
* Name     : FetchCityMaster
* Company  : ET Marlabs
* Purpose  : Used to fetch city mater 
* Author   : Dushyant
*/
@RestResource(urlMapping='/fetchCityMaster')
global with sharing class FetchCityMaster {
    global class Response extends WS_Response{
        List<City> cityList;
        Integer totalSize;
        public Response(){  
            cityList = new List<City>();
        }
    }
    global class requestParam {
        public String stateCode;
    }
    global class City{
        public string Id;
        public string Name;
        public string VL_City_ID;
        public string CODPIN;
    }
    @HttpPost
    global static Response getCityMater(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
        SavePoint sp         = Database.setSavepoint();
        if(req == null || req.requestBody == null){
            res.status             = Constants.WS_ERROR_STATUS;
            res.errorMessage       = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode         = Constants.WS_ERROR_CODE;
            return res;
        }else{
            try{
                String jsonData                 = req.requestBody.toString();
                List<City_Master__c> cityMasterList = new List<City_Master__c>();
                FetchCityMaster.requestParam cityMasterReq  = (FetchCityMaster.requestParam)System.JSON.deserialize(jsonData, FetchCityMaster.requestParam.class);
                if(cityMasterReq != null){
                    try{
                        cityMasterList = [SELECT Id,Name,VL_City_ID__c,CODPIN__c FROM City_Master__c WHERE CODSTATE__c =:cityMasterReq.stateCode];
                        res = prepareResponse(cityMasterList);
                    }
                    catch(Exception e){
                        System.debug(e.getLineNumber());
                        System.debug(e.getStackTraceString());
                        res.status          = Constants.WS_ERROR_STATUS;
                        res.errorMessage    = e.getMessage();
                        res.statusCode      = Constants.WS_ERROR_CODE;
                        return res;
                    }
                }
            }
            catch(Exception e){
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
                System.debug(e.getStackTraceString());
                res.status          = Constants.WS_ERROR_STATUS;
                res.errorMessage    = e.getMessage();
                res.statusCode      = Constants.WS_ERROR_CODE;
                return res;
            }
        }
        RETURN res;
    }
    public static Response prepareResponse(List<City_Master__c> cityMasterList){
        system.debug('cityMasterList==++'+cityMasterList);
        Response res         = new Response();
        res.totalSize = cityMasterList.size();
        List<FetchCityMaster.City> cityList = new List<FetchCityMaster.City>();
        for(City_Master__c cityObj : cityMasterList){
            FetchCityMaster.City city= new FetchCityMaster.City();
            city.Id = cityObj.Id;
            city.Name = cityObj.Name;
            city.VL_City_ID = cityObj.VL_City_ID__c;
            city.CODPIN = cityObj.CODPIN__c;
            cityList.add(city);
        }
        res.cityList = cityList;
        RETURN res;
    }
}