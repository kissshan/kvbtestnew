/*
 * 	Name 	: Digioe_Sign_Service
 *	Purpose	: This is a service for Digio eSign
 */  
public class Digioe_Sign_Service {
    
	/*
    * Method to retrieve the ESigned document from DIGIO.   
    */
    public static String getSanctionDoc(String appId){
        Attachment attch	= [Select id,body,Name,ContentType from Attachment where ParentId = :appId];
        return EncodingUtil.base64Encode(attch.body);
    }
    

    public class ESignRequest{
        
        public Blob file;
        public ESignSubRequest request;
        public ESignRequest(){
            
            request = new ESignSubRequest();
        }
        public ESignRequest(Blob file,list<Signers> signers,Integer expire_in_days,String display_on_page){
            this.file = file;
            this.request = new ESignSubRequest(signers,expire_in_days,display_on_page);
        }
    }
    
    public class ESignSubRequest{
        
        public list<Signers> signers; //Email address(es) of user(s) from whom signature is requested
        public Integer expire_in_days;
        public String display_on_page;
        
        public ESignSubRequest(list<Signers> signers,Integer expire_in_days,String display_on_page){
            
            this.signers = signers;
            this.expire_in_days = expire_in_days;
            this.display_on_page = display_on_page;
        }
        
        public ESignSubRequest(){ }
    }
    
    public class Signers{
        
        public String identifier; //Email address(es) of user(s) from whom signature is requested
		public String aadhaar_id;
        public String reason;
        
        public Signers(String identifier,String aadhaar_id,String reason){
            
            this.identifier = identifier; 
            this.aadhaar_id = aadhaar_id;
            this.reason = reason;
        }
        public Signers(){ }
    }
    public class ESignResponse{
        
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

    /*
    * Description: Method to request for ESign from DIGIO. This will give doc-id as response.  
    * Author	 : Numaan A.M
    */
    public static String getESigned(ESignRequest eSignReq,String fileName){

        String boundary = '----------------------------741e90d31eff';    
        String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+fileName+'";\nContent-Type: application/pdf';
        String footer = '--'+boundary+'--';               
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n')); 

        while(headerEncoded.endsWith('=')){
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }

        String bodyEncoded = EncodingUtil.base64Encode(eSignReq.file);
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());

        last4Bytes = last4Bytes.substring(0,2) + '0K';
        bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;

        bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded);

        String header2 = '\r\n--'+boundary+'\r\nContent-Disposition: form-data; name="request"';
        String body2 = '\r\n\r\n'+JSON.serialize(eSignReq.request);
        String footer2 = '\r\n--'+boundary+'--';  

        Blob bodyBlob1 = Blob.valueOf(header2+body2+footer2);

        String combinedDataAsHex = EncodingUtil.convertToHex(bodyBlob) + EncodingUtil.convertToHex(bodyBlob1);
        Blob bodyBlob2 = EncodingUtil.convertFromHex(combinedDataAsHex);

        HttpRequest req1 = new HttpRequest();
        req1.setHeader('Content-Type','multipart/form-data; boundary=' + boundary);
        req1.setHeader('Accept','*/*');
        req1.setMethod('POST');
        req1.setEndpoint(Utility.getEndpoint('DigioeSign'));
        req1.setBodyAsBlob(bodyBlob2);
        //req1.setClientCertificateName(Label.MWL_Certificate_Name);
        HTTPResponse response = new HTTPResponse();
        Http http = new Http();
        response = http.send(req1);

        if(response.getStatusCode() == 200){
            String jsonData = response.getBody();
            ESignResponse appReqObj = (ESignResponse)Json.deserialize(jsonData, ESignResponse.class);
            return appReqObj.id;
        }else{
            system.debug('**Status code-'+response.getStatusCode()+' **Status-'+response.getStatus()); 
            throw new CustomException('DIGIO generation failed. Status code-'+response.getStatusCode());
        }

    }


    /*
    * Description: Method to retrieve the ESigned document from DIGIO.   
    * Author	 : Numaan A.M
    */
    public static String getESignedDoc(String docId){

        HTTPResponse response = new HTTPResponse();

        Map<String,String> headerMap = new Map<String,String>();
        headerMap.put('document_id',docId);
        headerMap.put('Content-Type','application/json');
        headerMap.put('Content-Length','0');
  
        response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('DigioeDocDownload'), 'POST', null,null,headerMap,null);

        if(response.getStatusCode() == 200){
 
            return EncodingUtil.base64Encode(response.getBodyAsBlob());
        }else{

            throw new CustomException('DIGIO Doc retrieved failed. Status code-'+response.getStatusCode());
        }
            
    }
}