@RestResource(urlMapping = '/updateOverallExposure')
global class WS_updateOverAllExposure {

    //Response structure
    global class Response extends WS_Response {
        OVERALL_EXPOSURE_UPDATION.updateOverAllExposureResponse ExposureResponse;
        public Response() {
            ExposureResponse = new OVERALL_EXPOSURE_UPDATION.updateOverAllExposureResponse();
        }
    }

    @HttpPost
        global static Response getDmsDetails() {
        RestRequest req = Restcontext.Request;
        Response res = new Response();

        if (req == null || req.requestBody == null) {
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);
        } else{
            try {
                String jsonData = req.requestBody.toString();
                system.debug('jsonData====> '+jsonData);
                //OVERALL_EXPOSURE_UPDATION.updateOverAllExposureRequest reqObj = (OVERALL_EXPOSURE_UPDATION.updateOverAllExposureRequest) Json.deserialize(jsonData, OVERALL_EXPOSURE_UPDATION.updateOverAllExposureRequest.class);
                OVERALL_EXPOSURE_UPDATION.updateOverAllExposureRequest reqObj = (OVERALL_EXPOSURE_UPDATION.updateOverAllExposureRequest) Json.deserialize(jsonData, OVERALL_EXPOSURE_UPDATION.updateOverAllExposureRequest.class);
                system.debug('reqObj====> '+reqObj); 
                system.debug('reqObjupdateOverAllExposureRequest====> '+reqObj.out_msg.updateOverAllExposure);
                /*if(reqObj.updateOverAllExposure!= null ){
                   res.ExposureResponse = OVERALL_EXPOSURE_UPDATION_HELPER.updateOverallExposureData(reqObj.updateOverAllExposure);  
                }*/
                if(reqObj.out_msg.updateOverAllExposure!= null ){
                   res.ExposureResponse = OVERALL_EXPOSURE_UPDATION_HELPER.updateOverallExposureData(reqObj.out_msg.updateOverAllExposure);  
                }

            }catch (Exception ex){
                system.debug('Exception::' + ex.getMessage() + ex.getMessage() + ex.getLineNumber());
                return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Exception' + ex.getMessage() + ex.getLineNumber()+ex.getStackTraceString());
            }
        }
        return res;
    }
    static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg) {
        res.status = status;
        res.successMessage = succMsg;
        res.statusCode = statusCode;
        res.errorMessage = errMsg;
        return res;
    }
}