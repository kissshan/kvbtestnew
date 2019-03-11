/*
* Name    : Ws_IfscCode
* Company : ET Marlabs
* Purpose : This class is used ifsc code branch
* Author  : Niladri
*/
global class Ws_IfscCode {
    Webservice  static void callIfsc(String ifscid,String id){
        Ifsc_request ifscobj=new Ifsc_request();
        ifscobj.exe_tenantId='cuecent_tenant';
        ifscobj.owner_tenantId='cuecent_tenant';
        cls_in_msg msgobj=new cls_in_msg();
        msgobj.IFSC_Code=ifscid;
        cls_inputVariables inp=new cls_inputVariables();
        inp.in_msg=msgobj;
        ifscobj.inputVariables=inp;
         Ifscmethod(JSON.serialize(ifscobj),id,ifscid);
    }

    public static void Ifscmethod(String ifscreq,string appid,String ifscCode){
         
            System.debug('++req'+ifscreq);
            genesis__Application_Parties__c par=[select Primary_Bank__c,Primary_Bank_Branch__c,genesis__Application__c from genesis__Application_Parties__c where   id=:appid]; 
            System.debug('par'+par);
          Map<String,String> headerMap = new Map<String,String>();              
            headerMap.put('Content-Type','application/json');
            HTTPResponse response = new HTTPResponse();
            KVB_Endpoint_URLs__c kvb = KVB_Endpoint_URLs__c.getValues('IFSC');
            String endPoint=kvb.Endpoint_URL__c;
            System.debug('**endPoint'+endPoint); 
            response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('IFSC'), 'POST',null,ifscreq,headerMap,label.CA_CERTIFICATE);
            system.debug('response::'+response);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String jsonData = response.getBody();
                system.debug('jsonData::'+jsonData);
                IfscResponse appReqObj = (IfscResponse)System.JSON.deserialize(jsonData, IfscResponse.class);
                System.debug('**appReqObj'+appReqObj);
                cls_out_msg msobj=appReqObj.out_msg;
                String bankname=msobj.Bank_Name;
                par.Primary_Bank__c=bankname;
                par.Primary_Bank_Branch__c=msobj.Branch_Name;
                par.IFSC_code__c=ifscCode;
                update par;
            }
    
        
    }
    public class Ifsc_request {

    public String exe_tenantId; //cuecent_tenant
    public String owner_tenantId;   //cuecent_tenant
    public cls_inputVariables inputVariables;
}
    Public class cls_inputVariables {
        public cls_in_msg in_msg;
    }
    Public class cls_in_msg {
        public String IFSC_Code;    //ICIC0004354
    }
  /*  public static Ifsc_request parse(String json){
        return (Ifsc_request) System.JSON.deserialize(json, Ifsc_request.class);
    }*/
    
    public class IfscResponse{
    public String bpms_error_code;  //00
    public cls_out_msg out_msg;
    public String bpms_error_msg;//sucess
    }
    public class cls_out_msg {
        public String Branch_Name;  //SECTOR B
        public String Bank_Name;    //ICICI BANK LIMITED
    }
}