/*
*   Name    : Digioe_Docs_Service
*   purpose : Call Digioe service to get document signed and 
*             document back in SF System
*  Author   : Amritesh
-----------------------------------------------------------------------
Version  Date         Author             Remarks                                                 
=======   ==========   =============  ==================================
v1.1    19-Oct-2018    Braj           Addition of HL Non Legal Desk Digio documents generation
v1.2    25-Feb-2019    Braj           HL MVP2: New document template and signer coordinates for topup and takeover
*******************************************************************************************/
public class Digioe_Docs_Service {
    public static String attachmentId;
    public static genesis__Applications__c app = new genesis__Applications__c();
    Public static string getSanctionDocforSigning(string applicationId){        
        String signedDoc = Digioe_Sign_Service.getSanctionDoc(applicationId);
        return signedDoc;
    }
    /*
    * Method to request for Class-2 Sign for a document
    */
    public static String class2Signer(DocSignerRequest req, integer pageCount, String documentType){
            System.debug('REQUEST:::'+req);
        try{
            String accessToken = WS_ApiGatewayAccToken.getAccTkn();
            //System.debug('DocumentName:::class2Signer'+documentType);
            Map<String,String> headerMap = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',accessToken);
            HTTPResponse response = new HTTPResponse();
            Class2ReqWrap reqWrp    = new Class2ReqWrap();
            reqWrp.exe_tenantId     = 'cuecent_tenant';
            reqWrp.owner_tenantId    = 'cuecent_tenant';
            //reqWrp.serviceName       = 'TestJsonStr';//$$$$
            reqWrp.applicationType    = '1';//$$$$
            reqWrp.applicationId    = '1';//$$$$
            reqWrp.customerId    = '1';//$$$$
            reqWrp.documentType    = documentType;//$$$$
            reqWrp.accountNumbers    = '1';//$$$$
            reqWrp.uuid    = req.file_content;//$$$$
            reqWrp.inputVariables    = new cls_inputVariables();
            reqWrp.inputVariables.in_msg = '';
            reqWrp.inputVariables.inputMap = new DocSignerRequest();
            reqWrp.inputVariables.inputMap    = req;
            reqWrp.inputVariables.inputMap.sign_coordinates = new Map<Integer,List<Object>>();
            if(documentType == 'Loan Agreement'){
                cls_1 con = new cls_1(398.28,330,508.75,394);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-3, new List<Object>{con});
            }
            if(documentType == 'Loan Agreement_New_Loan'){
                cls_1 con = new cls_1(398.28,330,508.75,394);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-3, new List<Object>{con});
            }
            if(documentType == 'Sanction Document'){
                cls_1 con = new cls_1(309.99,624,555.19,678);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-3, new List<Object>{con});
            }
            if(documentType == 'Guarantor Agreement'){
                cls_1 con = new cls_1(343.47,267.95,439.74,293.1);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }

            if(documentType == 'Exceeding Sanction Letter'){
                cls_1 con = new cls_1(409.39,584.46,528.21,633.02);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-1, new List<Object>{con});
            }
            if(documentType == Constants.SANCTION_TEMPLATE_SME || documentType == Constants.SME_SANCTION_Letter123){    
                cls_1 con = new cls_1(414.79,553.29,523.54,626.44);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-9, new List<Object>{con});
            }
             if(documentType == Constants.SME_SANCTION_Letter1 ){
                cls_1 con = new cls_1(414.79,553.29,523.54,626.44);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-4, new List<Object>{con});
            }
             if(documentType == Constants.SME_SANCTION_Letter12){
                cls_1 con = new cls_1(414.79,553.29,523.54,626.44);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-5, new List<Object>{con});
            }
             if(documentType == Constants.SME_SANCTION_Letter13){
                cls_1 con = new cls_1(414.79,553.29,523.54,626.44);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-8, new List<Object>{con});
            }
            if(documentType == Constants.PROV_SANCTION_TEMPLATE_SME){ 
                cls_1 con = new cls_1(375.18,569.89,521.21,644.52);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-4, new List<Object>{con});
            }
             if(documentType == Constants.PRE_Approval_Sanction_HL){
                cls_1 con = new cls_1(310.51,635.62,447.55,670.3);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }
             if(documentType == Constants.Acknowledgement_For_Sanction){
                 System.debug('Test'+documentType);
                 //changes the co-ordinates------prashant singh
                cls_1 con = new cls_1(366.3,91,519.41,131);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-4, new List<Object>{con});
            }
            System.debug('reqWrp.inputVariables.inputMap.sign_coordinates:::::::'+reqWrp.inputVariables.inputMap.sign_coordinates);
             if(documentType == Constants.A23_HL){
                cls_1 con = new cls_1(396.34,274,549.45,314);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }
            if(documentType == Constants.LAP_A23){
                cls_1 con = new cls_1(340,326.05,477.04,360.73);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }
            if(documentType == Constants.A46_HL){
                 System.debug('Test'+documentType);
                //changes the co-ordinates------prashant singh
                cls_1 con = new cls_1(408.94,447,562.05,487);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }
            if(documentType == Constants.LAP_A46){
                cls_1 con = new cls_1(327.86,122.27,464.9,156.95);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }
            if(documentType == Constants.PRE_APPROVE_SANCTION_PL){
                cls_1 con = new cls_1(305.31,178.63,442.35,213.32);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-3, new List<Object>{con});
            }// PL legaldesk document class2 signer will uncomment after tempID get
            if(documentType == Constants.PL_AGREEMENT_DOC){
                cls_1 con = new cls_1(401.46,436.14,542.41,471.81);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }
            if(documentType == Constants.Acknowledgement_For_SanctionLAP){
                cls_1 con = new cls_1(338.27,109.26,475.31,143.95);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-5, new List<Object>{con}); 
            }
            if(documentType == Constants.VLHYPOTHECATIONLD){
                System.debug('Test'+documentType);
                cls_1 con = new cls_1(323.66,639,510.69,694);//updated on date:17-Sept-2018
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }
            if(documentType == Constants.VLSANCTIONLETTER){
                System.debug('Test'+documentType);
                cls_1 con = new cls_1(297.03,604,457.19,663);//updated on date:18-Sept-2018
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount-2, new List<Object>{con});
            }

            //v1.2(start)
            //HL TopUp Signer Request
            if(documentType == Constants.HL_Topup_A66){
                cls_1 con = new cls_1(299.44,318,458.36,363);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }
            //HL Takeover Signer Request
            if(documentType == Constants.HL_Takeover_A54){
                cls_1 con = new cls_1(342.08,213,505.85,271);
                reqWrp.inputVariables.inputMap.sign_coordinates.put(pageCount, new List<Object>{con});
            }
            //v1.2(end)

            if(reqWrp == null) throw new CustomException('Invalid Request');
            string reqString = JSON.serialize(reqWrp);
            response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('DocSigner'), 'POST',null ,reqString ,headerMap,label.CA_CERTIFICATE);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String signedDoc = response.getBody();  
                System.debug('signedDoc::'+signedDoc);            
                //DocSignerResponse appReqObj = (DocSignerResponse)Json.deserialize(signedDoc, DocSignerResponse.class);
                DMS_Structure.DocumentUploadRes appReqObj = (DMS_Structure.DocumentUploadRes)Json.deserialize(signedDoc, DMS_Structure.DocumentUploadRes.class);
                if(appReqObj == null || appReqObj.bpms_error_code  != '00' || appReqObj.uuid == null){
                    //throw new CustomException('Status Code-'+appReqObj.code+' Message-'+appReqObj.message);
                    throw new CustomException('Class-2 Sign Failed.Invalid Response Received.');
                }
                return appReqObj.uuid;                
            }else{
                throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
            }
            
        }catch(Exception e){ 
            //Do not insert clcommon__Log__c here           
            System.debug('Exception in DocSigner '+e.getMessage()+' Stack '+e.getStackTraceString());
            throw new CustomException('Class-2/3 Failed-'+e.getMessage());
        }
    }
    
    public class Class2ReqWrap{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
       // public String serviceName;  //TestJsonStr
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
        public DocSignerRequest inputMap;
    }
    public class DocSignerRequest{
        public String key_store_name = KVB_Company_Details__c.getInstance().Key_Store_Name__c;//Constants.KEYSTORENAME;
        public String name;
        public String reason;
        public String location; //city/town/village
        public String file_content; //base64 string
        public String display_on_page = 'custom'; //options avaliable first/last/all/custom
        public Map<Integer,List<Object>> sign_coordinates;
        public DocSignerRequest(){}
        public DocSignerRequest(String name,String reason,String location,String file_content){
            this.name = name;
            this.reason = reason;
            this.location = location;
            this.file_content = file_content;
        }
    }
    public class cls_1 {
        public decimal llx; //315
        public decimal lly; //20
        public decimal urx; //455
        public decimal ury; //60
        public cls_1(){}
        public cls_1(decimal llx, decimal lly, decimal urx, decimal ury){
            this.llx = llx;
            this.lly = lly;
            this.urx = urx;
            this.ury = ury;
        }
    }
    public class DocSignerResponse{
        public cls_outMap outMap;
    }
    public class cls_outMap {
        public String signed_file_content;  //JVBERi0xLYKJSVFT0YK
    } 
    public class DocGenResponse{
        public cls_outMapDoc outMap;
    }
    public  class cls_outMapDoc {
        public cls_Data Data;
    }
    public class cls_Data {
        public String outfile;  //JiUlRU9G
        public String totalpages;
    } 
    /*
    * Method to generate the document from DIGIO
    */
    public static DMS_Structure.DocumentUploadRes getEDocs(String appId,String documentName,String templateName){
        try{
            System.debug('####### '+ app);
            DMS_Structure.DocumentUploadRes resObj    = new DMS_Structure.DocumentUploadRes();
            //DocGenResponse appReqObj    = new DocGenResponse();
            String req                  = '';
            HTTPResponse response = new HTTPResponse(); 
            if(documentName == Constants.SANCTION_TEMPLATE_SME || documentName == Constants.PROV_SANCTION_TEMPLATE_SME
              || documentName == Constants.SME_SANCTION_Letter123 || documentName == Constants.SME_SANCTION_Letter12
              || documentName == Constants.SME_SANCTION_Letter1 || documentName == Constants.SME_SANCTION_Letter13)                
                req = JSON.serialize(DigioTemplateService.getSMESanctionLetter(appId,documentName,templateName));
            if(documentName == Constants.PRE_Approval_Sanction_HL)
                req=JSON.serialize(HL_DigioTemplateService.getHLSanctionLetter(appId,templateName));
            if(documentName == Constants.Acknowledgement_For_Sanction){
                req=JSON.serialize(HL_DigioTemplateService.getHLAcknowledgeSanctionC1(appId,templateName));
            }

            // PL Sanction letter call//non legal desk---prashant singh
            if(documentName == Constants.PRE_APPROVE_SANCTION_PL || documentName == Constants.PRE_APPROVE_SANCTION_PL_NLD){
                req=JSON.serialize(HL_DigioTemplateService.getPLSanctionLetter(appId,templateName));  
            }
            if(documentName == Constants.PL_loan_Agreement_Letter){
                req=JSON.serialize(HL_DigioTemplateService.plLoanAgreement(appId,templateName));  
            }

            //v1.1(start)//HL Non Legal Desk doc generation
            if(documentName == Constants.HL_DIGIO_MANUAL_A23) {
                req=JSON.serialize(HL_DigioTemplateService.getHL_Digio_Manual_A23(appId,templateName));  
            }
            if(documentName == Constants.HL_DIGIO_MANUAL_A46) {
                req=JSON.serialize(HL_DigioTemplateService.getHL_Digio_Manual_A46(appId,templateName));  
            }
            if(documentName == Constants.HL_DIGIO_MANUAL_B17) {
                req=JSON.serialize(HL_DigioTemplateService.getHL_Digio_Manual_B17(appId,templateName));  
            }
            if(documentName == Constants.HL_DIGIO_MANUAL_B1B2) {
                req=JSON.serialize(HL_DigioTemplateService.getHL_Digio_Manual_B1B2(appId,templateName));  
            }
            if(documentName == Constants.HL_DIGIO_MANUAL_C1C11) {
                req=JSON.serialize(HL_DigioTemplateService.getHLAcknowledgeSanctionC1(appId,templateName));  
            }

            //v1.2(start)
            if(documentName == Constants.HL_Topup_A66_Manual) {
                req=JSON.serialize(HL_DigioTemplateService.getHL_TopUp_A66(appId,templateName));  
                System.debug('req:: HL_Topup_A66_Manual-------> ');
            }
            if(documentName == Constants.HL_Takeover_A54_Manual) {
                req=JSON.serialize(HL_DigioTemplateService.getHL_TakeOver_A54(appId,templateName));  
                System.debug('req:: HL_Takeover_A54_Manual-------> ');
            }
            //v1.2(end)
            
            if(documentName == Constants.VLSANCTIONLETTER || documentName == Constants.VLSANCTIONLETTER_NLD){
                req=JSON.serialize(VL_DigioTemplateService.getVLSanctionLetter(appId,templateName));  
            }
            if(documentName == Constants.VLDEALERPYMNTAUTH || documentName == Constants.VLDEALERPYMNTAUTH_NLD){
                req=JSON.serialize(VL_DigioTemplateService.VlDealerPaymentLetter(appId,templateName));  
            }
            if(documentName == Constants.VLDEALERACK){
                req=JSON.serialize(VL_DigioTemplateService.VlPaymentAcknowledgementLetter(appId,templateName));  
            }
             if(documentName == Constants.VLCover){
                req=JSON.serialize(VL_DigioTemplateService.VlCoveringLetter(appId,templateName));  
            }
            if(documentName == Constants.VLHYPOTHECATION || documentName ==Constants.VLHYPOTHECATIONLD){
                req=JSON.serialize(VL_DigioTemplateService.VL_HypothecationDoc(appId,templateName));  
            }
            if(documentName == Constants.Acknowledgement_For_SanctionLAP || documentName == Constants.Acknowledgement_For_SanctionLAP_NLD){
                List<genesis__Applications__c> appList = [SELECT Id,Name,Sanction_Authority_Limit__c FROM genesis__Applications__c WHERE Id =: appId LIMIT 1];
                if(appList.size()>0){
                    if(appList[0].Sanction_Authority_Limit__c != NULL){
                       req=JSON.serialize(HL_DigioTemplateService.C1SanctionAcknowledgementforLAP(appId,templateName));  
                    }else{
                        appList[0].addError('Sanction Loan Amount should not be ZERO');
                    }
                }
            }
            if(documentName == Constants.LAP_A23D_LAFA){
                req=JSON.serialize(HL_DigioTemplateService.A23D_LAFADocForLap(appId,templateName));  
            }
            if(documentName == Constants.LAP_A46DOC){
                req=JSON.serialize(HL_DigioTemplateService.A46AgreementDocForLap(appId,templateName));
            }
            if(documentName == Constants.LAP_B1_B2DOC){
                req=JSON.serialize(HL_DigioTemplateService.B1_DigioDocForLap(appId,templateName));
            }
            //EAE DocReq structure
            if(documentName == 'A1_EAE'){
                    req=JSON.serialize(DigioTemplateService.generate_A_1_Doc(app,templateName));
            }
            if(documentName == 'C7_EAE'){
                    req=JSON.serialize(DigioTemplateService.generate_C_7_Doc(app,templateName));
            }
            if(documentName == 'C8_EAE'){
                    req=JSON.serialize(DigioTemplateService.generate_C_8_Doc(app,templateName));
            }
            if(documentName == 'C9_EAE'){
                    req=JSON.serialize(DigioTemplateService.generate_C_9_Doc(app,templateName));
            }
            if(documentName == 'Sanction Document'){
                    req=JSON.serialize(DigioTemplateService.generate_Digital_GCFA_C1_v1(app,templateName));
            }
            if(documentName == 'Exceeding Sanction Letter'){
                req=JSON.serialize(DigioTemplateService.generate_Exceeding_AdHoc_SanctionLetter(app,templateName));
            }
            if(documentName == 'B1_EAE'){
                //req = JSON.serialize(DigioTemplateService.generateMODAfidivateDoc(SME_Digio_Service_EAE.app,SME_Digio_Service_EAE.app.Facilities__r,Utility.getDIGIOTemplateId('B1_EAE'),SME_Digio_Service_EAE.B1_CollId,String.valueOf(SME_Digio_Service_EAE.stampCharge),SME_Digio_Service_EAE.branchState));
                req = JSON.serialize(DigioTemplateService.generateMODAfidivateDoc(app,app.Facilities__r,Utility.getDIGIOTemplateId('B1_EAE'),SME_Digio_Service_EAE.B1_CollId));
            }
            if(documentName == System.Label.GCFA_EAE || documentName == System.Label.GCFA_EAE_New_Loan){
                //req = JSON.serialize(DigioTemplateService.generate_DIGITAL_GCFA_v2(SME_Digio_Service_EAE.app,Utility.getDIGIOTemplateId(documentName),String.valueOf(SME_Digio_Service_EAE.stampCharge),SME_Digio_Service_EAE.branchState,SME_Digio_Service_EAE.UID));
                req = JSON.serialize(DigioTemplateService.generate_DIGITAL_GCFA_v2(app,Utility.getDIGIOTemplateId(documentName)));
            }
            if(documentName == System.Label.Guarantor_Agreement_EAE){
                //req = JSON.serialize(DigioTemplateService.generateGuarantorAgreement(SME_Digio_Service_EAE.app,SME_Digio_Service_EAE.app.Facilities__r,Utility.getDIGIOTemplateId(documentName),String.valueOf(SME_Digio_Service_EAE.stampCharge),SME_Digio_Service_EAE.branchState,SME_Digio_Service_EAE.UID));
                req = JSON.serialize(DigioTemplateService.generateGuarantorAgreement(app,SME_Digio_Service_EAE.app.Facilities__r,Utility.getDIGIOTemplateId(documentName)));
            }
            
            System.debug('req::'+req);
            if(req == null) throw new CustomException('Invalid Request');

            if(req != null && req != 'null'){
                resObj = DMS_Service.docGeneration(req);
            }else{
                throw new CustomException('Null template generated');
            }
            System.debug('resObj:::: ' + resObj);   
            RETURN resObj;
            
        }catch(Exception e){
            //Do not insert clcommon__Log__c here
            System.debug('Exception in eDoc generation '+e.getMessage()+' Stack '+e.getStackTraceString()+'Line Number'+e.getLineNumber());
            System.debug(' Cause  ' + e.getCause());
            throw new CustomException('DIGIO document generation failed-'+e.getMessage());
        }  
    }

    
    public static String upsertDoc(String appId,String fileName,String content){
        List<Attachment> attList = new List<Attachment>();
        Attachment att = new Attachment();
        attList = [Select Id,Body,ParentId,Name from Attachment where ParentId=:appId AND Name=:fileName limit 1];
        if(!attList.isEmpty()){
            att = attList[0];
            att.Body = EncodingUtil.base64Decode(content);
            update att;
        }else{
            att.Name = fileName;
            att.ParentId = appId;
            att.Body = EncodingUtil.base64Decode(content);
            insert att;
        }
        RETURN att.Id;
    }
  /*   public static String upsertLAPDoc(String appId,String DocIds,String content){
        
        List<Attachment> attList = new List<Attachment>();
        Attachment att = new Attachment();
        attList = [Select Id,Body,ParentId,Name,Description from Attachment where ParentId=:appId AND Description=:DocIds limit 1];
        if(!attList.isEmpty()){
            att = attList[0];
            att.Body = EncodingUtil.base64Decode(content);
            update att;
        }else{

            att.Description = DocIds;
            att.ParentId = appId;
            att.Body = EncodingUtil.base64Decode(content);
            insert att;
        }
        RETURN att.Id;
    }*/

    public static Blob getAttachmentBody(String pId,String name){
        Attachment att = [Select Id,Body,ParentId,Name from Attachment where ParentId=:pId AND Name=:name limit 1];
        attachmentId = att.Id;
        return att.Body;
    }
    
    public static String downloadDocument(String docId){
        Attachment att = new Attachment();
        DownloadDocoment.DOC_Request eDownReq = new DownloadDocoment.DOC_Request();
        eDownReq.exe_tenantId           = 'cuecent_tenant';
        eDownReq.owner_tenantId         = 'cuecent_tenant'; 
        eDownReq.inputVariables         = new DownloadDocoment.cls_inputVariables();
        eDownReq.inputVariables.in_msg  = '';
        eDownReq.inputVariables.documentId  = docId;
        
        string reqStr = JSON.serialize(eDownReq);
        System.debug('!!--->>'+reqStr);
        HTTPResponse response           = new HTTPResponse();
        Map<String,String> headerMap    = new Map<String,String>();             
        headerMap.put('Content-Type','application/json');
        response = HttpUtility.sendHTTPRequest(Utility.getEndpointApigee('DocumentDownload'), 'POST', null,reqStr,headerMap,label.CA_CERTIFICATE);
        
        
        if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();
            downRes obj = (downRes)JSON.deserialize(jsonString,downRes.class);
            try{
                att = [SELECT Id,ParentId,Name,Body,Description FROM Attachment WHERE Description =: docId];
                upsertDocWithDocId(att,obj.outMap.Base64Str);
            }catch(Exception e){
                System.debug('No Doc found::'+e.getMessage());
            }
            RETURN obj.outMap.Base64Str;
        }else{
            System.debug('**Status code-'+response.getStatusCode()+' **Status-'+response.getStatus()); 
            return null;
        }
    }
    //Needs to be removed
    public static void upsertDocWithDocId(Attachment att,String content){
        att.Body = EncodingUtil.base64Decode(content);
        UPDATE att;
    }
    //Needs to be removed
    public class downRes{
        public outMapClass outMap;
    }
    //Needs to be removed
    public class outMapClass {
        public String RESDate;
        public String SuccessMessage;
        public String RESTime;
        public String ErrorCode;
        public String Base64Str;
    }
}