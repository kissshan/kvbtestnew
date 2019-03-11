public class OVERALL_EXPOSURE_UPDATION {
    
    /* EOM Request - Start*/
    public class updateOverAllExposureRequst{
        public List<cls_updateOverAllExposure> updateOverAllExposure;
    }
    public class cls_updateOverAllExposure {
        public String Customer_ID;  //567546745
        public String Account_Number;   //345678567
        public String Outstanding_Balance;  //12312.90
        public String Rate_Of_Interest; //54
        public String Amount_Yet_Disbursed; //2345356.99
        public String holiday_period;
    }
    /* EOM Request - End*/

    /* EOM Response - Start*/
    public class updateOverAllExposureResponse{
        public cls_SuccessResult SuccessResult;
        public cls_FailureResult FailureResult; 
    }
    public class cls_SuccessResult {
        public cls_ResultData[] ResultData;
    }
    public class cls_FailureResult {
        public cls_ResultData[] ResultData;
    }
    public class cls_ResultData {
        public String Account_Number;   //123456
        public String Message;  //Success
    }
    /* EOM Response - End*/

    /* NEW EOM Request - Start*/
    public class updateOverAllExposureRequest{
        public cls_out_msg out_msg;
        public updateOverAllExposureRequest(){
            out_msg= new cls_out_msg();
        }
    }
    public class cls_out_msg {
        public Integer total_size;  //100
        public cls_updateOverAllExposure[] updateOverAllExposure;
    }
    /* NEW EOM Request - End*/


}