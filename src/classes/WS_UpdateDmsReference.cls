/*
* Name          : WS_UpdateDmsReference
* Description   : Update DMS refernce details from FE
* Author        : Raushan
*/
@RestResource(urlMapping = '/updateDMSReference')
global class WS_UpdateDmsReference {
    //Response structure
    global class Response extends WS_Response {}
    public class ReqWrapObj {
        List<DMS_Structure.DMSRefrenceWrapper> DMS_REFRENCE_INFO = new List<DMS_Structure.DMSRefrenceWrapper>();
    }
    @HttpPost
    global static Response getDmsDetails() {
        RestRequest req = Restcontext.Request;
        Response res = new Response();
        if (req == null || req.requestBody == null) {
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);
        } else {
            try {
                String jsonData = req.requestBody.toString();
                ReqWrapObj reqObj = (ReqWrapObj) Json.deserialize(jsonData, ReqWrapObj.class);
                if(reqObj.DMS_REFRENCE_INFO.size() > 0){
                    res.successMessage = UpdateDMSReferenceHelper.updateDmsRefrecnce(reqObj.DMS_REFRENCE_INFO);
                }else{
                    res.successMessage = 'Error in request';
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