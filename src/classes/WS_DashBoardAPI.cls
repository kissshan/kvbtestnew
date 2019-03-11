@RestResource(urlMapping='/FetchApplications/*')

Global class WS_DashBoardAPI {
    
     global class Response extends WS_Response{
        public list<genesis__Applications__c> ApplicationList;
         
      
    }
    
    @Httpget
    global static Response FetchApplicationts(){
        
         RestRequest req = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        Response res=new Response();
        string AppType=req.params.get('AppType'); 
        if(!(AppType instanceof ID)){

            res.status 		   = 'ERROR';
            res.errorMessage   = 'APPLICANT Type IS INVALID';
            res.statusCode = '400';
            return res;
        }else{
            try{
               // list<genesis__Applications__c> Applist=[select ID,name,genesis_accounts__c ];
            }
            catch(exception e){
                
            }
        }
        return res;
    }


}