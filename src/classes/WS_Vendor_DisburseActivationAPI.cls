@RestResource(urlMapping='/disburseActivation')
global class WS_Vendor_DisburseActivationAPI{
     global class Response extends WS_Vendor_RestAPIHelper.WS_Vendor_Response{
        public String ApplicationId;
     }
   
    public class cls_Party {
         public boolean active;  
         public id appId; 
    }
     @HttpPost
       global static Response checkForDocument(){
        RestRequest request = Restcontext.Request;
        Response res = new Response(); 
        if(request == null && request.requestBody ==  null){
            return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS, '', WS_Vendor_Constants.WS_ERROR_CODE, WS_Vendor_Constants.WS_REQ_BODY_IS_NULL,'');
        }
        else{
           try{
                  String jsonData  = request.requestBody.toString();
                  cls_Party reqApp=(cls_Party)JSON.deserialize(jsonData,cls_Party.CLASS);
                  Id AppId=reqApp.appId;
               
                       // Photo Validation
                       Boolean Status = photoValidation(AppId);
                       if(Status==true && reqApp.active==true) {
                           //WS_Vendor_CBS_CreateCustIC.cbs_CreateCustIC(AppId);
                           res.ApplicationId=AppId;
                           return getWSResponse(res, WS_Vendor_Constants.WS_SUCCESS_STATUS, WS_Vendor_Constants.CBS_INITIATION_DONE, WS_Vendor_Constants.WS_SUCCESS_CODE, '', '');
                       }
                       else {
                           res.ApplicationId=AppId;
                           return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS,'', WS_Vendor_Constants.WS_ERROR_CODE, WS_Vendor_Constants.NO_PHOTO,'');
                       }
                
             }
             catch(Exception e){
                 return getWSResponse(res, WS_Vendor_Constants.WS_ERROR_STATUS,'', WS_Vendor_Constants.WS_ERROR_INTERNAL_CODE, WS_Vendor_Constants.WS_INTERNAL_ERROR,WS_Vendor_Constants.WS_ERROR_TYPE_INTERNAL);
             }
        }
       }
       static Response getWSResponse(Response res, string status, string succMsg, string statusCode, string errMsg, string errType){
        res.status           = status;
        res.successMessage  = succMsg;
        res.statusCode        = statusCode;
        res.errorMessage  = errMsg;
        res.errorType = errType;
        return res;
    }
     static Boolean photoValidation(Id ApplId){
            boolean status;
            genesis__Application_Document_Category__c photoDoc= [select id,name from genesis__Application_Document_Category__c where name='Photo' and genesis__Application__c=:ApplId limit 1];
            System.debug('Photo id: '+photoDoc.id);
            Set<Id> dList=new Set<Id>();
            list<genesis__Application_Document_Category__c> ApplDoc= [select id,name from genesis__Application_Document_Category__c where genesis__Parent_Application_Document_Category__c=:photoDoc.id];
            for(genesis__Application_Document_Category__c doc : ApplDoc){
                dList.add(doc.id);
                
            }
            System.debug('Applicant Folder- Party:'+dList);
                if(dList.size()>0){
                    list<genesis__Application_Parties__c> party=[select id from genesis__Application_Parties__c where genesis__Application__c=:ApplId];
                    list<genesis__AppDocCatAttachmentJunction__c> attach=[select id from genesis__AppDocCatAttachmentJunction__c where genesis__Application_Document_Category__c IN :dList];
                    if(party.size()>0){
                       if(attach.size()<party.size()){
                            status = false;
                       }
                       else{
                           status = true;
                       }
                    }
                    else{
                        System.debug('No Photo Attached');
                        status = false;
                    }
                 }
                 else{
                     system.debug('Applicant Folders are not created');
                     status = false;
                 }
                 return status;
            
      }
}