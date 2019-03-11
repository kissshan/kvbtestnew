/*
* Name    : WS_getAadharNo
* Company : ET Marlabs
* Purpose : This class is used get access token of API GATEWAY
* Author  : Subas
*/
public class WS_getAadharNo {
    public static String getAadharNo(String AadharRefNo){
        if(!String.isBlank(AadharRefNo)){
        String AadharNo = '';
        String accessTkn = WS_ApiGatewayAccToken.getAccTkn();
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('Get_AadharNo');
        String endPoint = kvb.Endpoint_URL__c + AadharRefNo;
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Authorization',accessTkn);
        headerMap.put('Cache-Control','no-cache');
        HTTPResponse response                                   = new HTTPResponse();
        //String endPoint                                         ='https://kvb-dev.apigee.net/next/v1/mw/uid/reference/'+AadharRefNo;
        STRING REQ= 'grant_type=client_credentials';
        response = HttpUtility.sendHTTPRequest(endPoint, 'GET', null,null,headerMap,null);
        system.debug('##Response'+response.getBody());
        WS_getAadharNo.getAadhar_Response getAadhar = (WS_getAadharNo.getAadhar_Response)JSON.deserialize(response.getBody(), WS_getAadharNo.getAadhar_Response.class);
        system.debug('*********'+getAadhar);
        if(getAadhar.out_msg.aadhaarNumber <> null){
            AadharNo = getAadhar.out_msg.aadhaarNumber;
        }else{
            AadharNo = getAadhar.out_msg.ERR_MSG;
        }
        
        system.debug('^^AadharNo^^'+AadharNo);
        return AadharNo;
        }
        return '';
    }
    public class getAadhar_Response{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;
    }
    Public class cls_out_msg {
        public String gender;   //M
        public String vtc;  //...
        public String locality; //
        public String houseNumber;  //....
        public String dateOfBirth;  //....
        public String advRefKey;    //d6d0bb53-14ba-4293-a32b-23f6569a768f
        public String aadhaarNumber;    //123456781234
        public String careOf;   //....
        public String residentName; //....
        public String street;   //....
        public String district; //....
        public String pinCode;  //639006
        public String state;    //Tamil Nadu
        public String landmark; //
        public String subDistrict;  //....
        public String postOffice;   //Vengamedu
        public String STATUS;
        public String ERR_MSG;
    }
  //  Public class cls_bpms_error_msg {
    //}
}