/*
* Name          : Docket_ESign_Service
* Description   : Upload Docket
* Author        : Dushyant
*/
public class Docket_ESign_Service {
    public static String uploadDocketForCoBrwr(String appId, String signerType){
        try{
            //variable declaration
            List<Attachment> appDocments;
            List<String> emailList= new List<String>();
            List<String> attchNameList = new List<String>();
            List<Cordinate__mdt> cordinateList = new List<Cordinate__mdt>();
            List<DocumentName__mdt> documentMetadataList = new List<DocumentName__mdt>();
            Docket_ESign_Service.ESignRequest eSignReq      = new Docket_ESign_Service.ESignRequest();
            Map<String,Docket_ESign_Service.cls_signers> signerMap = new Map<String,Docket_ESign_Service.cls_signers>();
            List<Docket_ESign_Service.cls_pdfs> pdfList     = new List<Docket_ESign_Service.cls_pdfs>();
            Map<String,Map<Integer,List<Object>>> signMap   = new Map<String,Map<Integer,List<Object>>>();
            //get application details
            genesis__Applications__c appln = [Select id,genesis__Account__c,genesis__Account__r.PersonEmail,genesis__Account__r.Aadhaar_Number__pc,Sanction_Doc_Generation_Check__c,Sanction_Class2_Check__c,
                                              Sanction_ESign_Check__c from genesis__Applications__c where Id =: appId];
            emailList.add(appln.genesis__Account__r.PersonEmail);
            string prAadhar = appln.genesis__Account__r.Aadhaar_Number__pc!=null?appln.genesis__Account__r.Aadhaar_Number__pc:'';
            signerMap.put(appln.genesis__Account__r.PersonEmail,new Docket_ESign_Service.cls_signers(appln.genesis__Account__r.PersonEmail,prAadhar,Constants.DOCKET_UPLOAD_REASON_HL));
            
            if(!appln.Sanction_ESign_Check__c){ 
                List<genesis__Application_Parties__c> parties;
                //fetch attachments against application based on signer type
                if(signerType == 'Co-Borrower'){
                    appDocments = [SELECT id,Name,Body FROM Attachment WHERE ParentId =: appId AND Name IN : Constants.APP_ATTACHMENT_COBORROWER.split(':')]; 
                }
                else if(signerType == 'Gurantor'){
                    appDocments = [SELECT id,Name,Body FROM Attachment WHERE ParentId =: appId AND Name IN : Constants.APP_ATTACHMENT_GUARANTOR.split(':')];
                }
                System.debug(appDocments.size());
                System.debug(appId);
                System.debug(signerType);
                //System.debug(appId);
                //fetch parties agaist application
                parties = new List<genesis__Application_Parties__c>([Select id,genesis__Application__c,Guarantor__c,genesis__Party_Account_Name__c,Signatories__c,
                                                                     genesis__Party_Account_Name__r.Name,Party_Sub_Type__c,genesis__Party_Type__c,Active__c,
                                                                     genesis__Party_Account_Name__r.PersonEmail,genesis__Party_Account_Name__r.Aadhaar_Number__pc
                                                                     from genesis__Application_Parties__c where genesis__Application__c = :appId 
                                                                     AND Active__c =true AND genesis__Party_Account_Name__r.PersonEmail != null
                                                                     AND genesis__Party_Account_Name__r.RecordType.DeveloperName ='PersonAccount' AND genesis__Party_Type__c =: signerType AND  Active__c = true]);// Guarantor__c = true AND Signatories__c =true 
               
                if(!parties.isEmpty() ){
                    //fetch cordinates against document type
                    List<Cordinate__mdt> cordList = [SELECT Id,DeveloperName,PageNumber__c,llx__c,lly__c,urx__c,ury__c FROM Cordinate__mdt WHERE DocumentName__r.DeveloperName LIKE 'C_1%'];
                    List<Cordinate__mdt> cordList1 = new List<Cordinate__mdt>();
                    List<String> docName;
                    //fetch cordinates
                    if(signerType == 'Co-Borrower'){
                        docName = new List<String>{'A_23%','B_17%'};
                            }
                    else if(signerType == 'Gurantor'){
                        docName = new List<String>{'A_46%'};
                            }
                    if(docName != null && !docName.isEmpty()){
                        cordList1 = [SELECT Id,DeveloperName,PageNumber__c,llx__c,lly__c,urx__c,ury__c FROM Cordinate__mdt WHERE DocumentName__r.DeveloperName LIKE : docName AND SignerType__c =: signerType];
                        cordList.addAll(cordList1);
                    }
                    for(Cordinate__mdt cord : cordList){
                        System.debug(cord.PageNumber__c+'----'+cord.DeveloperName);
                    }
                    
                    For(genesis__Application_Parties__c p : parties){
                        //preparing signer map
                        string aadhar = p.genesis__Party_Account_Name__r.Aadhaar_Number__pc!=null?p.genesis__Party_Account_Name__r.Aadhaar_Number__pc:'';
                        if(!signerMap.keySet().contains(p.genesis__Party_Account_Name__r.PersonEmail)){
                            signerMap.put(p.genesis__Party_Account_Name__r.PersonEmail,new Docket_ESign_Service.cls_signers(p.genesis__Party_Account_Name__r.PersonEmail,aadhar,Constants.DOCKET_UPLOAD_REASON_HL));
                        }
                        emailList.add(p.genesis__Party_Account_Name__r.PersonEmail);
                        /*//Docket_ESign_Service.cls_1 cord1 = new Docket_ESign_Service.cls_1(444.24,666.16,559.44,715.12);
Map<Integer,List<Object>> tempMap = new Map<Integer,List<Object>>();
for(Cordinate__mdt cordMdt : cordList){
Docket_ESign_Service.cls_1 cord = new Docket_ESign_Service.cls_1(cordMdt.llx__c,cordMdt.lly__c,cordMdt.urx__c,cordMdt.ury__c);
if(tempMap.get((Integer)cordMdt.PageNumber__c) == null){
//tempMap.put((Integer)cordMdt.PageNumber__c, new List<Object>{cord});
//Needs to be replaced later
tempMap.put(1, new List<Object>{cord});
}
else{
List<Object> tObj = tempMap.get((Integer)cordMdt.PageNumber__c);
tObj.add(new Docket_ESign_Service.cls_1(cordMdt.llx__c,cordMdt.lly__c,cordMdt.urx__c,cordMdt.ury__c));
//tempMap.put((Integer)cordMdt.PageNumber__c,tObj);
//Needs to be replaced later
tempMap.put(1,tObj);
}
}
//tempMap.put(1, new List<Object>{cord});//,cord1
signMap.put(p.genesis__Party_Account_Name__r.PersonEmail, tempMap);*/
                    }
                    for(String eml : emailList){
                        Map<Integer,List<Object>> tempMap = new Map<Integer,List<Object>>();
                        for(Cordinate__mdt cordMdt : cordList){
                            Docket_ESign_Service.cls_1 cord = new Docket_ESign_Service.cls_1(cordMdt.llx__c,cordMdt.lly__c,cordMdt.urx__c,cordMdt.ury__c);
                            if(tempMap.get((Integer)cordMdt.PageNumber__c) == null){
                                //tempMap.put((Integer)cordMdt.PageNumber__c, new List<Object>{cord});
                                //Needs to be replaced later
                                tempMap.put(1, new List<Object>{cord});
                            }
                            else{
                                List<Object> tObj = tempMap.get((Integer)cordMdt.PageNumber__c);
                                tObj.add(new Docket_ESign_Service.cls_1(cordMdt.llx__c,cordMdt.lly__c,cordMdt.urx__c,cordMdt.ury__c));
                                //tempMap.put((Integer)cordMdt.PageNumber__c,tObj);
                                //Needs to be replaced later
                                tempMap.put(1,tObj);
                            }
                        }
                        signMap.put(eml, tempMap);
                    }
                }
                
            }
            if(!appDocments.isEmpty()){
                for(Attachment att : appDocments){
                    attchNameList.add(att.Name);
                    pdfList.add(new Docket_ESign_Service.cls_pdfs(att,'custom',signMap));
                }
            }
            if(!attchNameList.isEmpty()){
                documentMetadataList = [SELECT Id,MasterLabel FROM DocumentName__mdt];
            }
            //preparing docket upload structure
            eSignReq.exe_tenantId           = 'cuecent_tenant';
            eSignReq.owner_tenantId         = 'cuecent_tenant';
            eSignReq.inputVariables         = new Docket_ESign_Service.cls_inputVariables();
            eSignReq.inputVariables.in_msg              = '';
            eSignReq.inputVariables.inputMap            = new Docket_ESign_Service.cls_map();
            eSignReq.inputVariables.inputMap.signers    = new List<Docket_ESign_Service.cls_signers>();
            eSignReq.inputVariables.inputMap.signers    = signerMap.values();
            eSignReq.inputVariables.inputMap.pdfs       = new List<Docket_ESign_Service.cls_pdfs>();
            eSignReq.inputVariables.inputMap.pdfs       = pdfList;
            //making callout to upload docket
            HTTPResponse response           = new HTTPResponse();
            Map<String,String> headerMap    = new Map<String,String>();              
            headerMap.put('Content-Type','application/json'); 
            System.debug(eSignReq);
            
            string reqStr = JSON.serialize(eSignReq);
            System.debug(Utility.getEndpoint('DocketESignUpload'));
            System.debug('reqStr'+reqStr);
            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('DocketESignUpload'), 'POST', null,reqStr,headerMap,label.CA_CERTIFICATE);
            System.debug(response.getStatusCode());
            System.debug(response.getBody());
            //store docket id on successful creation of docket
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonString = response.getBody();
                system.debug('jsonData::'+jsonString);
                Map<String, Object> resObj = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
                Map<String, Object> resObjMap = (Map<String,Object>)resObj.get('outMap');
                System.debug('DocketId-----'+resObjMap.get('id'));
                RETURN 'Success';
            }else{
                System.debug('Request Failed');
                System.debug(response.getStatusCode());
                RETURN 'Failed';
            }
            
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            RETURN 'Failed';
        }
        
    }
    
    // Request Wrapper classes
    public class ESignRequest{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;       
    }
    public class cls_inputVariables {
        public String in_msg;
        public cls_map inputMap;
    }
    public class cls_map {
        public List<cls_signers> signers;
        public cls_pdfs[] pdfs;
    }
    //inner class to create documnet structure
    public class cls_pdfs {
        public String file_name;
        public String file_data;
        public String display_on_page;
        public Map<String,Map<Integer,List<Object>>> sign_coordinates;
        
        public cls_pdfs(Attachment att,String displayOnPage,Map<String,Map<Integer,List<Object>>> sign_coordinates){
            this.sign_coordinates = sign_coordinates;
            this.file_name = att.Name; 
            this.file_data = EncodingUtil.base64Encode(att.body);
            //this.file_data = 'JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagoDAgbg0KMDAwMDMwODQ1MSAwMDAwMCBuDQowMDAwMzEyMTkzIDAwMDAwIG4NCjAwMDAzMTY4MjMgMDAwMDAgbg0KMDAwMDMxMjUyNSAwMDAwMCBuDQowMDAwMzE0OTI4IDAwMDAwIG4NCjAwMDAzMTY3MDcgMDAwMDAgbg0KMDAwMDMyMjA5MSAwMDAwMCBuDQp0cmF';
            this.display_on_page = displayOnPage;
        }
        public cls_pdfs(){}
    }
    //inner class to create signers structure
    public class cls_signers {
        public String identifier;   
        public String aadhaar_id;   
        public String reason;   
        
        public cls_signers(String identifier,String aadhaar_id,String reason){
            
            this.identifier = identifier; 
            this.aadhaar_id = aadhaar_id;
            this.reason = reason;
        }
        public cls_signers(){}
    }
    //class to create cordinate structure
    public class cls_1 {
        public Decimal llx; 
        public Decimal lly; 
        public Decimal urx; 
        public Decimal ury; 
        public cls_1(Decimal llx, Decimal lly, Decimal urx, Decimal ury){
            this.llx = llx;
            this.lly = lly;
            this.urx = urx;
            this.ury = ury;
        }
        public cls_1(){}
    }
}