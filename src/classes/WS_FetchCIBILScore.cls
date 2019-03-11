@RestResource(urlMapping='/FetchCIBILDetails/*')

global class WS_FetchCIBILScore {
    
     global class Response extends WS_Response{
        public Decimal CIBILscore;
         Public String CRITERIA_MATCHED;
         public String ApplicantID;
         
      
    }
    
    @Httpget
    global static Response getCIBILdetails(){
        RestRequest req = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        Response res=new Response();
        
        string AccID=req.params.get('AccId'); 
         if(!(AccId instanceof id)){

            res.status 		   = 'ERROR';
            res.errorMessage   = 'APPLICANT ID IS INVALID';
            res.statusCode = '400';
            return res;
        }else{
            try{
                
                Account acc=[select id,CIBIL_Score__c,CriteriaMatched__c from Account where ID=:AccID];
                res.CIBILscore = acc.CIBIL_Score__c;
                res.CRITERIA_MATCHED = acc.CriteriaMatched__c;
                res.ApplicantID=Acc.Id;
        return res;
            }
            catch(exception e){
                 system.debug('Exception in Creatapplicant'+e.getMessage()+' Stack '+e.getStackTraceString());
           
                res.status          = 'ERROR';
                res.statusCode  = string.valueOf(genesis.Constants.HTTP_INTERNAL_ERROR);
                res.errorMessage  = e.getMessage();
                
                return res;
                
                 
            }
             
    }
    
		return null;
}
}