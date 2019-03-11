/*
* Name          : Digio_ESign_Service
* Description   : Handle Digio E-sign Request/Resposne
* Author        : Amritesh
*/ 
public class Digio_ESign_Service {
    public static String getESigned(Digio_ESign_Service.ESignRequest eSignReq){
        HTTPResponse response = new HTTPResponse();
        Map<String,String> headerMap = new Map<String,String>();              
        headerMap.put('Content-Type','application/json'); 
        if(eSignReq == null) throw new CustomException('Invalid Request for E-Sign');
        string reqStr = JSON.serialize(eSignReq);
        response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('DigioESign'), 'POST', null,reqStr,headerMap,label.CA_CERTIFICATE);
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonData = response.getBody();
            system.debug('jsonData::'+jsonData);
            ESignResponse appReqObj = (ESignResponse)Json.deserialize(jsonData, ESignResponse.class);
            if(appReqObj == null || appReqObj.outMap == null 
               || appReqObj.outMap.id == null || appReqObj.outMap.id == ''){
                throw new CustomException('No Response from Digio');
            }
            return appReqObj.outMap.id;
        }else{
            system.debug('**Status code-'+response.getStatusCode()+' **Status-'+response.getStatus()); 
            throw new CustomException('DIGIO ESign failed. Status code-'+response.getStatusCode());
        }
    } 
       //To be removed
    // Request Wrapper
    public class ESignRequest{
        public String exe_tenantId; 	//cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public String applicationType;   //$$$$
        public String applicationId;   //$$$$
        public String customerId;   //$$$$
        public String documentType;   //$$$$
        public String accountNumbers;   //$$$$
        public String uuid;   //$$$$
        public cls_inputVariables inputVariables;       
    }
    public class cls_1 {
        public Decimal llx; //444.24
        public Decimal lly; //236.16
        public Decimal urx; //559.44
        public Decimal ury; //285.12
        public cls_1(Decimal llx, Decimal lly, Decimal urx, Decimal ury){
            this.llx = llx;
            this.lly = lly;
            this.urx = urx;
            this.ury = ury;
        }
        public cls_1(){}
    }
    public class cls_inputVariables {
        public String in_msg;   //
        public cls_map inputMap;
    }
    public class cls_map {
        public cls_signers[] signers;
        public Integer expire_in_days;  //10
        public String display_on_page;  //custom
        public Map<String,Map<Integer,List<Object>>> sign_coordinates;
        public String file_name;    //test.pdf
        public String file_data;    //JVBERuA4NDZmZDk4Kc3RhcnR4cmVmCjE3ODE2CiUlRU9GCg==
        public boolean notify_signers = false;
        public boolean send_sign_link = false;
    }
    public class cls_signers {
        public String identifier;   //sanket@digio.in
        public String aadhaar_id;   //121212121212
        public String reason;   //I accept the terms
        
        public cls_signers(String identifier,String aadhaar_id,String reason){
            
            this.identifier = identifier; 
            this.aadhaar_id = aadhaar_id;
            this.reason = reason;
        }
        public cls_signers(){}
    }
    
    // Response Wrapper
    public class ESignResponse{
        public cls_outMap outMap;
    }
    public class cls_outMap{
        public String id; //Unique ID to identify document provided by Digio.
        public Boolean is_agreement;
        public String agreement_type; 
        public String agreement_status;
        public String file_name;
        public String self_signed; 
        public Integer no_of_pages; //Number of pages in document
        public String created_at;
        public List<Signing_Parties> signing_parties;
        public Sign_Request_Details sign_request_details;
    }
    
    public class Signing_Parties {
        public String name; //Name of the signing party
        public String identifier; //Email of the signing party
        public String type; //"self": user is signing
        public String status;
        public String signature_type;
        public String reason;
    }
    
    public class Sign_Request_Details {
        public String name; //Organization name registered with Digio account
        public String identifier; //Organization email address registered with Digio account
        public String requested_on; //"yyyy-mm-dd hh:mm:ss": Timestamp of Sign Request origination in IST
        public String expire_on; //"yyyy-mm-dd hh:mm:ss": Timestamp of Sign Request expiry in IST, if set.
        public String requester_type;
    }
}