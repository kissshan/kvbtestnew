/*
 * Description : Check E-sign status of signer's   
 * Author      : Amritesh
 */ 
public class DigioSignerStatus implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    
    static final string ESING_PENDING   = 'E-sign pending';
    static List<genesis__Applications__c> applnToudate  = new List<genesis__Applications__c>();
    static List<String> emaiLList   = new List<String>();
    static List<String> mobList     = new List<String>();
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'Select id,All_Party_Signed__c,Sanction_ESign_Id__c from genesis__Applications__c where Active__c = true AND Sanction_ESign_Id__c != null AND All_Party_Signed__c = false AND Application_Stage__c=:ESING_PENDING AND CreatedDate =LAST_N_YEARS:1';
        return database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<genesis__Applications__c> records) {
                
        for(genesis__Applications__c appln : records){
            // Call Digio API for Signer's Status
            //applnToudate.add(callDigioService(appln));
            callDigioService(appln);
        }
    }  
       
    public void finish(Database.BatchableContext BC) {
        if(applnToudate.size() > 0){            
            update applnToudate;
        }
    }
         
    public genesis__Applications__c callDigioService(genesis__Applications__c app){
        try{
            Map<String,String> headerMap = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response = new HTTPResponse();
            DigioReq req        = new DigioReq();
            req.exe_tenantId    = 'cuecent_tenant';
            req.owner_tenantId  = 'cuecent_tenant';
            req.serviceName     = 'GetDocumentDetails';
            req.inputVariables  = new cls_inputVariables();
            req.inputVariables.in_msg       = '';
            req.inputVariables.documentId   = app.Sanction_ESign_Id__c; 
            String reqString    = JSON.serialize(req);
            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('DigioDocDetail'), 'POST',null ,reqString ,headerMap,label.CA_CERTIFICATE);
            System.debug(response);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String resp = response.getBody();
                System.debug('resp==++'+resp);
                //List<>
                integer totalParties    = 0;
                DigioResponse appReqObj = (DigioResponse)Json.deserialize(resp, DigioResponse.class);
                system.debug('appReqObj==++'+appReqObj);
                List<digioSignerStatus.cls_signing_parties> parties = new List<digioSignerStatus.cls_signing_parties>();
                if(appReqObj.outMap != null ){
                    if(appReqObj.outMap.agreement_status == 'requested'){
                        parties         = appReqObj.outMap.signing_parties;
                        totalParties    = parties.size();
                        for(digioSignerStatus.cls_signing_parties p : parties){
                            if(p.status != 'signed'){
                                if(p.reason == constants.EMAIL_REASON){
                                    emaiLList.add(p.identifier);
                                }
                                if(p.reason == constants.MOB_REASON){ 
                                    mobList.add(p.identifier);
                                }
                            }
                        } 
                    }
                    if(appReqObj.outMap.agreement_status != 'expired' && appReqObj.outMap.agreement_status == 'completed'){
                        applnToudate.add(new genesis__Applications__c(id=app.Id,All_Party_Signed__c=true,Application_Stage__c='Sanction complete'));
                    }
                }                
            }else{
                
            }
        }catch(Exception e){
           system.debug('e==++'+e.getMessage()+'=='+e.getLineNumber()); 
        }
        return null;
    }

    public class DigioReq{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public String serviceName;  //GetDocumentDetails
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public String in_msg;   //
        public String documentId;   //DID180102184256000B2H9W7Y3TJUTBW
    }
    
    public class DigioResponse {
        public String bpms_error_code;  //00
        public String bpms_error_msg;
        public cls_outMap outMap;
    }
    public class cls_outMap {
        public String file_name;    //test.pdf
        public String channel;  //api
        public String created_at;   //2018-01-02 18:42:56
        public cls_signing_parties[] signing_parties;
        public Integer no_of_pages; //3
        public String self_sign_type;   //aadhaar
        public String agreement_type;   //outbound
        public String updated_at;   //2018-01-03 18:15:18
        public cls_sign_request_details sign_request_details;
        public boolean is_agreement;
        public String agreement_status; //expired
        public String id;   //DID180102184256000B2H9W7Y3TJUTBW
        public boolean self_signed;
    }
    public class cls_signing_parties {
        public String identifier;   //sanket@digio.in
        public String reason;   //I accept the terms
        public String updated_at;   //2018-01-09 15:30:43
        public String expire_on;    //2018-01-12 23:59:59
        public String name; //sanket@digio.in
        public String type; //self
        public String status;   //expired
        public String signature_type;   //aadhaar
    }
    public class cls_sign_request_details {
        public String identifier;   //sriram@kvbmail.com
        public String expire_on;    //2018-01-12 23:59:59
        public String name; //KVB
        public String requested_on; //2018-01-02 18:42:56
        public String requester_type;   //org
    }
}