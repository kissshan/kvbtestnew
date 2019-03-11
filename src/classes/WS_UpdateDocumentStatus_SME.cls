/*
 * Name    : WS_UpdateDocumentStatus_SME
 * Company  : ET Marlabs
 * Purpose   : This class is used to get SME document status.
 * Author  : Dushyant
*/
@RestResource(urlMapping='/updateDocumentStatus')
global with sharing class WS_UpdateDocumentStatus_SME {
    global class Response extends WS_Response{}
    public class ReqWrapObj{
        public String LOS_APP_ID;
        public String LOS_PARTY_TYPE_ID;
        public String CUST_ID;
        public String STATUS;
    }
    @HttpPost
    global static response updateDocStatus(){
        RestRequest req      = Restcontext.Request;
        Response res         = new Response(); 
        
         if(req == null || req.requestBody == null){
            res.status           = Constants.WS_ERROR_STATUS;
            res.errorMessage     = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode        = Constants.WS_ERROR_CODE;
            return res;            
        }else{
            try{
                String jsonData   = req.requestBody.toString();
                ReqWrapObj reqObj   = (ReqWrapObj)Json.deserialize(jsonData, ReqWrapObj.class);
                if(returnNullRequestStatus(reqObj,res) != null){
                    RETURN returnNullRequestStatus(reqObj,res);
                }
                
                if(reqObj.STATUS != null){
                    res.status              = Constants.WS_SUCCESS_STATUS;
                    res.statusCode          = Constants.WS_SUCCESS_CODE;
                    updateStatusOnParty(reqObj);
                }
            }
            catch(Exception e){
                res.status              = Constants.WS_ERROR_STATUS;
                res.errorMessage        = e.getMessage();
                res.statusCode          = Constants.WS_ERROR_CODE;
                system.debug('Exception::'+e.getMessage());
                system.debug('Exception::'+e.getLineNumber());
                return res;
            }
        }
        
        RETURN res;
    }
    public static Response returnNullRequestStatus(ReqWrapObj reqObj,Response res){
        if(reqObj.LOS_APP_ID == null || reqObj.LOS_APP_ID == '' || reqObj.LOS_PARTY_TYPE_ID == null || reqObj.LOS_PARTY_TYPE_ID == '' || reqObj.STATUS == null || reqObj.STATUS == ''){
            res.status              = Constants.WS_ERROR_STATUS;
            res.errorMessage        = 'Mandetory field is missing!!!';
            res.statusCode          = Constants.WS_ERROR_CODE;
            RETURN res;
        }
        else
            RETURN null;
    }
    public static void updateStatusOnParty(ReqWrapObj reqObj){
        List<genesis__Applications__c> appList = new List<genesis__Applications__c>();
        Boolean allPartySignedFlag = true;
        
        if(reqObj.LOS_APP_ID != null && reqObj.LOS_APP_ID != ''){
            try{
                appList = [SELECT All_Party_Signed__c,(SELECT Id,Name,Status__c FROM genesis__Application_Parties__r WHERE Active__c = true) FROM genesis__Applications__c WHERE Id =: reqObj.LOS_APP_ID];
            }
            catch(Exception e){}
            System.debug(reqObj);
            if(!appList.isEmpty() && !appList[0].genesis__Application_Parties__r.isEmpty()){
                for(genesis__Application_Parties__c party : appList[0].genesis__Application_Parties__r){
                    if(reqObj.LOS_PARTY_TYPE_ID == party.Id){
                        party.Id = reqObj.LOS_PARTY_TYPE_ID;
                        party.Status__c =  reqObj.STATUS;
                    }
                    if(party.Status__c != 'Completed') allPartySignedFlag = false;
                    System.debug(party.Name+'---'+party.Status__c);
                }
                System.debug(allPartySignedFlag);
                if(allPartySignedFlag){
                    appList[0].All_Party_Signed__c = true;
                }
                if(!appList[0].genesis__Application_Parties__r.isEmpty()) UPDATE appList[0].genesis__Application_Parties__r;
                UPDATE appList;
            }
        }
    }
}