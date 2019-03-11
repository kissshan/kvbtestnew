global class MockResponse implements HttpCallOutMock{
    global string serviceName;
    global HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json'); 
        String ResponseString = getResponse();
        res.setBody(ResponseString);
        res.setStatusCode(200);
        return res;
    }
    
    
    public string getResponse(){
      if(serviceName == 'Apigee_Access_Token'){
            return Batch_JocataListMatching_Scheduler_Test.apiGeeAccTokenResponse();
        }
        return 'a';
    }
    
    
}