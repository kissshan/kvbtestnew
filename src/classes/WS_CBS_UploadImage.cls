/*
* Name      : WS_CBS_UploadImage
* Compnay   : ET Marlabs
* Purpose   : API to upload image  
* Author    : Subas
*/
public class WS_CBS_UploadImage {
    
    //Request structure
    public class WS_CBS_UploadImage_request{
        public String exe_tenantId; //cuecent_tenant
        public String owner_tenantId;   //cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    public class cls_in_msg {
        public String serviceName;  //FCR_CUST_SIGN_PHOTO_ADD_HL
        public String ApplicationId;    //a4V5D0000004F9d
        public cls_PhotoUpdateDetails[] PhotoUpdateDetails;
    }
    public class cls_PhotoUpdateDetails {
        public String ApplicantID;  //0015D000007LYrc
        public String TransactionBranch;    //1152
        public String CodCustId;    //3347040
        public String CodImageType; //1
        public String ESignatureImage;  //photo1.jpg
        public String AttachmentContent;    //
    }
    
    //response structure
    public class WS_CBS_UploadImage_response{
        public String bpms_error_code;  //00
        public cls_out_msg out_msg;
        public String bpms_error_msg;   //Success
    }
    public class cls_out_msg {
        public String Status_Desc;  //Success
        public Integer Status_Code; //1
    }
    public static void cbs_photo_upload(String AppId,List<CBS_API_Log__c> UpcbsLog){
        //List<CBS_API_Log__c> UpcbsLog =  new List<CBS_API_Log__c>();
        cbs_photo_uploadNEW(AppId,null,UpcbsLog);
    }
    public static void cbs_photo_uploadNEW(String AppId,String loanNo,List<CBS_API_Log__c> UpcbsLog){
        genesis__Applications__c application = new genesis__Applications__c();
        application = queryService.getApp(appId);
        List <Account> accList = queryService.accList(AppId);
        List <ID> accIds = new List<ID>();
        for(Account acc : accList){
            accIds.add(acc.Id);
        }
        /* List<genesis__Application_Document_Category__c> appDocCatList = [Select ID,(Select ID,genesis__AttachmentId__c From genesis__AppDocCatAttachmentJunctions__r Limit 1)
From genesis__Application_Document_Category__c Where Applicant__c IN: accIds AND genesis__Parent_Application_Document_Category__r.Name ='Customer’s_Photo']; */
        List<genesis__AppDocCatAttachmentJunction__c> appDocCatList = [Select ID,Dms_Uuid__c,genesis__Application_Document_Category__r.Applicant__r.CBS_Customer_ID__c,Document_Name__c,genesis__AttachmentId__c,genesis__Application_Document_Category__r.Applicant__r.Id From genesis__AppDocCatAttachmentJunction__c Where  genesis__Application_Document_Category__r.Applicant__r.Id IN: accIds AND genesis__Application_Document_Category__r.genesis__Parent_Application_Document_Category__r.Name ='Photo' AND  genesis__Application_Document_Category__r.genesis__Application__r.Id  =: AppId];

        WS_CBS_UploadImage.WS_CBS_UploadImage_request cbs = new WS_CBS_UploadImage.WS_CBS_UploadImage_request();
        cbs.inputVariables = new WS_CBS_UploadImage.cls_inputVariables();
        WS_CBS_UploadImage.cls_inputVariables cbsInput = new WS_CBS_UploadImage.cls_inputVariables();
        cbsInput.in_msg = new WS_CBS_UploadImage.cls_in_msg();
        cbs.inputVariables = cbsInput;
        cbs.exe_tenantId = 'cuecent_tenant';
        cbs.owner_tenantId = 'cuecent_tenant';
        cbsInput.in_msg.ApplicationId = AppId;
        cbsInput.in_msg.serviceName = 'FCR_CUST_SIGN_PHOTO_ADD_HL';
        cbsInput.in_msg.PhotoUpdateDetails = new List<WS_CBS_UploadImage.cls_PhotoUpdateDetails>();
        if(appDocCatList.size() == accList.size()){
            for(genesis__AppDocCatAttachmentJunction__c appDoc : appDocCatList){
                system.debug('+++++'+appDoc.genesis__AttachmentId__c);
                if(appDoc.genesis__AttachmentId__c != null){                            
                    //List <Attachment> att = [SELECT Id, Name, Body FROM Attachment Where Id =: appDoc.genesis__AttachmentId__c];
                    //if(att.size()>0){
                        WS_CBS_UploadImage.cls_PhotoUpdateDetails fileList = new WS_CBS_UploadImage.cls_PhotoUpdateDetails();
                        fileList.ApplicantID = appDoc.genesis__Application_Document_Category__r.Applicant__r.Id;
                        fileList.AttachmentContent = String.valueOf(DMS_Service_Handler.getDocById(appDoc.Dms_Uuid__c,'1'));//EncodingUtil.base64Encode(att[0].Body);
                        fileList.CodCustId = appDoc.genesis__Application_Document_Category__r.Applicant__r.CBS_Customer_ID__c;
                        fileList.CodImageType = '2';
                        fileList.ESignatureImage = appDoc.Document_Name__c;//att[0].Name;  //$$$ verify once and check&&&&
                        fileList.TransactionBranch = application.Branch_Code__c;
                        cbsInput.in_msg.PhotoUpdateDetails.add(fileList);
                    //}
                }
            }
            cbs_file_upload_call(JSON.serialize(cbs),appId,loanNo,UpcbsLog);
        }else{
            Map<String,String> accMap = new Map<String,string>();
            for(Account acc : accList){
                accMap.put(acc.Id,acc.Name);
            }
            system.debug('****'+accMap);
            String AccName ='';
                for(genesis__AppDocCatAttachmentJunction__c apDocs : appDocCatList){
                    if(accIds.contains(apDocs.genesis__Application_Document_Category__r.Applicant__r.Id)){
                        AccName = AccName + ','+ accMap.get(apDocs.genesis__Application_Document_Category__r.Applicant__r.Id);
                    }
                }
            system.debug('^^^'+AccName);
            CBS_API_Log__c log = new CBS_API_Log__c();    
            log.Application__c = appId;
            log.API_Name__c = 'FCR_CUST_SIGN_PHOTO_ADD_HL';
            log.Status__c = 'Failure';
            log.Success_Error_Message__c = 'Please add photo for the applicant'+' '+AccName;
            log.Sequence_No__c = '11';  
            if(loanNo != null && AppID !=null){
                genesis__Applications__c a= new genesis__Applications__c();
                a.Id = AppID;
                a.Loan_Account_Number__c = loanNo;                    
                update a;
            } 
            UpcbsLog.add(log);
            insert UpcbsLog; //CBS_001
            //insert log; 
            }
 
        
    }
    public static void cbs_file_upload_call(String fileUpData,String appId,string loanNo,List<CBS_API_Log__c> UpcbsLog){
        system.debug('@@@'+fileUpData);
        KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('CBS_Bulk_API');
        Map<String,String> headerMap                            = new Map<String,String>();
        headerMap.put('Content-Type','application/json');
        HTTPResponse response                                   = new HTTPResponse();
        String endPoint                                         = kvb.Endpoint_URL__c;
        response = HttpUtility.sendHTTPRequest(endPoint, 'POST', null,fileUpData,headerMap,label.CA_CERTIFICATE);   
        system.debug('#####'+response);
        system.debug('$$$$'+response.getBody());
        If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
            String jsonString = response.getBody();
            WS_CBS_UploadImage.WS_CBS_UploadImage_response res = (WS_CBS_UploadImage.WS_CBS_UploadImage_response )JSON.deserialize(jsonString, WS_CBS_UploadImage.WS_CBS_UploadImage_response .class);
            if(res.out_msg.Status_Desc =='Success'){
                if(loanNo != null && AppID !=null){
                    genesis__Applications__c a= new genesis__Applications__c();
                    a.Id = AppID;
                    a.Loan_Account_Number__c = loanNo;                    
                    update a;
                }
                if(UpcbsLog.size() > 0){
                    insert UpcbsLog;
                    System.debug('UpcbsLog Photo upload >>> ' + UpcbsLog);
                }   
            }else{
                CBS_API_Log__c log = new CBS_API_Log__c();    
                log.Application__c = appId;
                log.API_Name__c = 'FCR_CUST_SIGN_PHOTO_ADD_HL';
                log.Status__c = 'Failure';
                log.Success_Error_Message__c = 'SIGN_PHOTO_ADD_HL_CBS_Error_No_Hit';
                log.Sequence_No__c = '11';  
                UpcbsLog.add(log);
                insert UpcbsLog; //CBS_001
                //insert log; 
                if(loanNo != null && AppID !=null){
                    genesis__Applications__c a= new genesis__Applications__c();
                    a.Id = AppID;
                    a.Loan_Account_Number__c = loanNo;                    
                    update a;
                }                  
            }
        }
    }
}