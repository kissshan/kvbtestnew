@RestResource(urlMapping='/PartiesDeactivate')

global class Ws_PartiesDeactive {
    
   global class Response extends WS_Response{
      
        public list<genesis__Application_Parties__c> PartyDetails; 
        
    }
    
    public class partyRequest{
        public string ApplicantID;
        public string ApplicationID;
    }
     
    
    @HttpPost
     global static Response deativateParties(){
      RestRequest req      = Restcontext.Request;
         RestResponse restRes = Restcontext.response;
         Response res         = new Response();
        
        
         if(req.requestBody == null){
           res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage    = Constants.WS_REQ_BODY_IS_NULL;
            res.statusCode      = Constants.WS_ERROR_CODE;
            return res;            
        }else{
            try{
             String jsonData = req.requestBody.toString();
                System.debug('Json Data======>'+jsonData);
                
                partyRequest Preq=(partyRequest)Json.deserialize(jsonData, partyRequest.class);
                 system.debug('partyRequestobj'+Preq);
               
                if((Preq.ApplicantID != null && (Preq.ApplicantID.length() == 15 || Preq.ApplicantID.length() == 18)) && (Preq.ApplicationID!=null && (Preq.ApplicantID.length() == 15 || Preq.ApplicantID.length() == 18))){ 
               list<genesis__Application_Parties__c> partyList  =  PartyService.getpartys(Preq.ApplicantID,Preq.ApplicationID);
               list<genesis__Application_Parties__c> updatePartylist= new  list<genesis__Application_Parties__c>();
                if(partyList.size()>0){
                    for(genesis__Application_Parties__c party:partyList){
                        if(party.Active__c==true){
                         party.Active__c=false;
               			 party.DeActivate_Date__c=system.today();
                        updatePartylist.add(party);
                        }
                    }
                    if(updatePartylist.size()>0){
                update updatePartylist;
                res.PartyDetails=updatePartylist;
                
                   return res; 
                    }
                    else{
                        res.status          = 'ERROR';
               		 res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                	 res.errorMessage  = 'Applicant Deleted Already.';
                	 return res;
                    }
                }
                else{
                     res.status          = 'ERROR';
               		 res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                	 res.errorMessage  = 'Primary applicant can not be Deleted.';
                	 return res;
                }
                }
                else{
                      res.status          = 'ERROR';
               		 res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                	 res.errorMessage  = 'Applicant ID or Application ID should not be blank';
                	 return res;
                }
                
                
            }
            catch(exception e){
               system.debug('Exception in Creatapplicant'+e.getMessage()+' Stack '+e.getStackTraceString());
               // res.errorCode       = genesis.Constants.API_EXCEPTION;
                res.status          = 'ERROR';
                res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                res.errorMessage  = e.getMessage();
                return res;
            }
     
     return res;
     }
     }
}