//This Docket related class is not using anymore, as for now.
@isTest
public class Test_Docket_Download_Service {
   public static genesis__Applications__c app;
    public static void init(){
        app=TestUtility.intialSetUp('HomeLoan',true);
        
        KVB_Endpoint_URLs__c loanChargeURLs = new KVB_Endpoint_URLs__c();
        loanChargeURLs.Name = 'DocketESignDownload' ;
        loanChargeURLs.Endpoint_URL__c = 'http://www.kvbbank.net/ext_bpms/rest/CueRest/invokeESBService/CBS_CBR_DTLS_MNT_HL' ;
        loanChargeURLs.Password__c = '' ;
        loanChargeURLs.Username__c = '' ;
        INSERT loanChargeURLs;
        
    }
    @isTest
    public static void methodCallResponse(){
        init();
        MockResponse mokResp = new MockResponse();
        mokResp.serviceName = 'DocketESignDownload';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mokResp);
        Docket_Download_Service.downloadRequest('2787328', app.id);
        Test.stopTest();
    }
    @isTest
    public static void method1(){
        init();
        String body=    
            '{'+
            '"LOS_APPID":"'+app.id+'" '+
            '"IS_Submitted":"Yes",'+
            '"After_ESign":"Yes", '+
            '"Doc_ID":"50000" '+
            '}';
        
        blob b=Blob.valueOf(body);
        Attachment att=new Attachment();
        att.Body=b;
        att.ParentId=app.id;
        att.Name='TestName';
        insert att;
        
        Map<string,string> docmap=new Map<string,string>();
        docmap.put('TestName', 'TestName');
        Docket_Download_Service.replaceDocument(docmap, app.Id);
        
    }
    
    public static String getResponse(){
        
        return '{"response": {"Status": "sucess","ErrorCode": "00","ErrorDescription": "sucess for ","outMap": {"ErrorCode": "00","ErrorMessage ":"Success"}}}';
        
    }
    
}