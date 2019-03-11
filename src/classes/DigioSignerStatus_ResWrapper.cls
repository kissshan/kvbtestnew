// Digio Signer Status Response format
public class DigioSignerStatus_ResWrapper {
    
    public String id;	//DID18011910593714127U8ZJBBZAM6KW
    public boolean is_agreement;
    public String agreement_type;	//outbound
    public String agreement_status;	//completed
    public String file_name;	//SME_SanctionLetter_a4V5D0000004F44
    public String updated_at;	//2018-01-19 11:02:18
    public String created_at;	//2018-01-19 10:59:37
    public boolean self_signed;
    public String self_sign_type;	//aadhaar
    public Integer no_of_pages;	//17
    public cls_signing_parties[] signing_parties;
    public cls_sign_request_details sign_request_details;
    public String channel;	//api
    class cls_signing_parties {
        public String name;	//9597832089
        public String status;	//signed
        public String updated_at;	//2018-01-22 19:35:58
        public String type;	//self
        public String signature_type;	//aadhaar
        public String identifier;	//9597832089
        public String reason;	//SME_SanctionLetter
        public String expire_on;	//2018-01-29 23:59:59
    }
    class cls_sign_request_details {
        public String name;	//KVB
        public String requested_on;	//2018-01-19 10:59:37
        public String expire_on;	//2018-01-29 23:59:59
        public String identifier;	//sriram@kvbmail.com
        public String requester_type;	//org
    }
    public static DigioSignerStatus_ResWrapper parse(String json){
        return (DigioSignerStatus_ResWrapper) System.JSON.deserialize(json, DigioSignerStatus_ResWrapper.class);
    }
}