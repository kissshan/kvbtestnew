/*
* Name          : WS_OperationData
* Description   : Web service to push Operational data into the system
* Author        : Dushyant
*/
@RestResource(urlMapping='/pushOperationalData')
global class WS_OperationData {
    //extending response structure
    global class Response extends WS_Response{
        public List<OpsErrorResponse> Error_List;
        public List<OpsSuccessResponse> success_List;
        public Integer failed_Ops_Count;
        public Integer success_Ops_Count;
       public Response(){
         Error_List = new List<OpsErrorResponse>();
            success_List = new List<OpsSuccessResponse>();
       }
    }
    //Response wrapper Class.
    global class OpsErrorResponse{
        public string cust_Id;
        public string error_reason;
    }
    //Response wrapper Class.
    global class OpsSuccessResponse{
        public string cust_Id;
        public string sucess_message;
    }
    
    //handeling POST request
    @HttpPost
    global static Response handleRequest(){
        RestRequest req     = Restcontext.Request;
        Response res        = new Response();
        List<WS_OperationData.OpsErrorResponse> errorList = new List<WS_OperationData.OpsErrorResponse>();
        List<WS_OperationData.OpsSuccessResponse> successList = new List<WS_OperationData.OpsSuccessResponse>();
        if(req == null || req.requestBody == null){
            return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, Constants.WS_REQ_BODY_IS_NULL);                     
        }else{
          try{
                String jsonString             = req.requestBody.toString();
                if(jsonString == null || jsonString == ''){
                    return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, 'Request body is null or blank');                    
                }
                else{
                    OperationalData_response opsData = OperationalData_response.parse(jsonString);
                    System.debug('ExecutionStarted:::');
                    Map<String,String> resDetail;
                    Integer failedOpsCount = 0;
                    Integer successOpsCount = 0;
                    for(OperationalData_response.cls_Operational_Data opData : opsData.out_msg.Operational_Data){
                        resDetail = new Map<String,String>();
                        resDetail = OperationalDataChange_Helper.handleOpsData(opData);
                        System.debug('resDetail:::'+resDetail);
                        if(resDetail != null){
                            failedOpsCount++;
                            WS_OperationData.OpsErrorResponse error = new WS_OperationData.OpsErrorResponse();
                            for(String custId : resDetail.keySet()){
                                error.cust_Id = custId;
                                error.error_reason = resDetail.get(custId);
                            }
                            errorList.add(error);
                        }
                        else{
                            successOpsCount++;
                            WS_OperationData.OpsSuccessResponse success = new WS_OperationData.OpsSuccessResponse();
                            success.cust_Id = opData.Customer_Id;
                            success.sucess_message = 'Data insert success';
                            successList.add(success);
                        }
                    }
                    res.failed_Ops_Count = failedOpsCount;
                    res.success_Ops_Count = successOpsCount;
                    res.Error_List = errorList;
                    res.success_List = successList;
                    if(errorList.size() > 0){
                        res.status          = Constants.WS_SUCCESS_STATUS;
                        res.statusCode      = Constants.WS_ERROR_CODE;
                    }
                }
            }
            catch(Exception e){
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
                return getWSResponse(res, Constants.WS_ERROR_STATUS, null, Constants.WS_ERROR_CODE, e.getMessage());  
            }
        }
        
        RETURN res;
    }
    //method to prepare response structure
    static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg){
        res.status           = status;
        res.successMessage   = succMsg;
        res.statusCode       = statusCode;
        res.errorMessage     = errMsg;
        return res;
    }
}