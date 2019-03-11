@RestResource(urlMapping='/getDoc')
global with sharing class WS_docFetch {
    
    global class Response extends WS_Response{        
        public DocMasterFetchHandler.DocumentWrap docCategories;
        public Response(){
            docCategories    = new DocMasterFetchHandler.DocumentWrap();            
        }
    }
    
    @HttpGet
    global static Response getDetails(){
        RestRequest req = Restcontext.Request;
        Response res         = new Response(); 
        //DetailResponse res = new DetailResponse();        
        string appId = req.params.get('appId');
        try{       
        res.docCategories   = DocMasterFetchHandler.getDocumentCategory(appId);
        return res;
        }Catch(Exception e){
            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage   = 'No Document Category Found';//e.getMessage();
            res.statusCode  = Constants.WS_ERROR_CODE;
            system.debug('Exception::'+e.getMessage());
            return res;
        }
    }
}