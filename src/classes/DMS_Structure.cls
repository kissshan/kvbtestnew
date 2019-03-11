/*
* Name          : DMS_Structure
* Description   : DMS Request/Response Structure
* Author        : Dushyant
*/
public class DMS_Structure {
    
    public static String getESigned(DMS_Structure.ESignRequest eSignReq){
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
    public class DocDowloandById{
        public Integer status;
        public docDetail data;
        public String errorMessage;
        public Integer errorCode;
    }  
    public class DocDetail {
        public String ext;
        public String parentFolderName;
        public String fileName;
        public String mimeType;
        public String parentUuid;
        public String fileStream;
    }
    public class DMS_Upload_Document{ 
        public Integer status;
        public Integer data;
        public String errorMessage;
        public Integer errorCode;
    }
    //Document generation request
    public class DocumentUploadRes{
        public String bpms_error_code;  //00
        public String bpms_error_msg;  //Success
        public String uuid;  //660
        public String totalPages;  //660
    }
    //Class-2 request
    public class class2Req {
        public String exe_tenantId;  //cuecent_tenant
        public String owner_tenantId;  //cuecent_tenant
        public cls_inputVariables_1 inputVariables;
        public String applicationType;  //1
        public String applicationId;  //1
        public String customerId;  //1
        public String documentType;  //abc
        public String accountNumbers;  //1
        public String uuid;  //595
    }
    public class cls_inputVariables_1 {
        public String in_msg;   //
        public cls_inputMap inputMap;
    }
    public class cls_1 {
        public decimal llx;  //315
        public decimal lly;  //20
        public decimal urx;  //455
        public decimal ury;  //60
        public cls_1(){}
        public cls_1(decimal llx, decimal lly, decimal urx, decimal ury){
            this.llx = llx;
            this.lly = lly;
            this.urx = urx;
            this.ury = ury;
        }
    }
    public class cls_inputMap {
        public String name;  //Signers name
        public String key_store_name;  //kvb
        public String reason;  //Testing
        public String location;  //Bangalore
        public String display_on_page;  //custom
        public Map<Integer,List<Object>> sign_coordinates;
    }
    
    public class Sign_Request_Details {
        public String name; //Organization name registered with Digio account
        public String identifier; //Organization email address registered with Digio account
        public String requested_on; //"yyyy-mm-dd hh:mm:ss": Timestamp of Sign Request origination in IST
        public String expire_on; //"yyyy-mm-dd hh:mm:ss": Timestamp of Sign Request expiry in IST, if set.
        public String requester_type;
    }
    public class DMSRefrenceWrapper {
        public String LOS_CUSTOMER_ID;
        public String LOS_APPLICATION_ID;
        public String LOS_DOC_NAME;
        public String LOS_DOC_REFRENCE_ID;
        public String LOS_DOC_UUID;
        public String LOS_DOC_CATEGOREY_ID;
        public Boolean Los_Is_Deleted;
    }
    //Digio DocumentId Generation
    //Request
    public class ESignRequest{
        public String exe_tenantId;   //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public String applicationType;   //$$$$
        public String applicationId;   //$$$$
        public String customerId;   //$$$$
        public String documentType;   //$$$$
        public String accountNumbers;   //$$$$
        public String uuid;   //$$$$
        public cls_inputVariables inputVariables;       
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
    //Resoponse
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
    //DMS eStamp response structure - LegalDesk
    public class EStampResponse{
        public String status;
        public String message;
        public EStampResult result;
    }
    public class EStampResult {
        public String TransactionID;
        public String ApplicationID;
        public Boolean eStampApproved;
        public Integer pageCount;
        public Integer uuid;
    }

    //Metadata update API structure
    public updateMetadataReq[] updateMetadataReq; 
    /* DocumentProcess Req and Res- Start */
    public class updateMetadataReq{
        public Integer uuid; 
        public metadataProps properties;      
    }
    public class metadataProps{
        public String applicationType;
        public String applicationId;
        public String customerId;
        public String documentType;
        public String accountNumbers;
    }
    public class updateMetadataRes{
        public Integer status;
        public Data data;
        public String errorMessage;
        public Integer errorCode;
    }
    public class Data {
        public List<String> Failed_ErrorMsg;
        public List<Integer> Failed_UUID;
        public List<Integer> Success_UUID;
    }

    //Upload document to DMS
    public class uploadDocReq{
        public String parentFolderUuid;	//
        public String name;	//test3.pdf
        public String mineType;	//application/pdf
        public String fileString;	
        public cls_metadata metadata;
        public String ext;	//pdf
        public boolean root;
    }
   public class cls_metadata {
        public String applicationType;	//a4V0l000000HsIl
        public String applicationId;	//a4V0l000000HsIp
        public String customerId;	//5656941
        public String documentType;	//
        public String accountNumbers;	//
    }
    public class uploadDocRes{
        public Integer status;	//1
        public Integer data;	//9326
        public cls_errorMessage errorMessage;
        public Integer errorCode;	//0
    }
    public class cls_errorMessage {
    }
}