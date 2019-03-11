/* 
* Name     : WS_BRANCH_MASTER
* Purpose  : Formatter class to prepare request/response structure for BRANCH master sync
* Company  : ET Marlabs
* Author   : Dushyant
*/
public class WS_DSA_MASTER {
    public static void masterRequest(){
        try{
            List<DSA_Master__c> DsaMasterList = new List<DSA_Master__c>();
            WS_DSA_MASTER.RequestFormat req = new WS_DSA_MASTER.RequestFormat();
            req.exe_tenantId 	= 'cuecent_tenant';
            req.owner_tenantId 	= 'cuecent_tenant';
            req.inputVariables 	= new WS_DSA_MASTER.cls_inputVariables();
            Map<String,String> headerMap = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response = new HTTPResponse();
            for(Integer retryCount = 0;retryCount < 3; retryCount++){
                try{
                    response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('DSA_MASTER_API'), 'POST', null,JSON.serialize(req),headerMap,label.CA_CERTIFICATE);
                    String jsonResString = response.getBody();
                    System.debug('jsonResString:::::'+jsonResString);
                    If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                        WS_DSA_Master.ResponseFormat res = (WS_DSA_Master.ResponseFormat)Json.deserialize(jsonResString,WS_DSA_Master.ResponseFormat.class);
                        if(res.out_msg.ErrorCode == '0'){
                            for(cls_DSA_Master dmaData : res.out_msg.DSA_Master){
                                DSA_Master__c dsa = new DSA_Master__c();
                                If(!Utility.ISStringBlankorNull(dmaData.V_BRANCH_CODE))
                                    dsa.Branch_Code__c = dmaData.V_BRANCH_CODE;
                                If(!Utility.ISStringBlankorNull(dmaData.V_BRANCH_NAME))
                                    dsa.Branch_Name__c = dmaData.V_BRANCH_NAME;
                                If(!Utility.ISStringBlankorNull(dmaData.V_LOGIC_DIV))
                                    dsa.Divison__c = dmaData.V_LOGIC_DIV;
                                If(!Utility.ISStringBlankorNull(dmaData.V_EMP_CODE))
                                    dsa.Employ_Code__c = dmaData.V_EMP_CODE;
                                If(!Utility.ISStringBlankorNull(dmaData.V_EMP_NAME))
                                    dsa.Employ_Name__c = dmaData.V_EMP_NAME;
                                If(!Utility.ISStringBlankorNull(dmaData.V_DESIG))
                                    dsa.Role__c = dmaData.V_DESIG;
                                DsaMasterList.add(dsa);
                            }

                            System.debug('100 th---->'+DsaMasterList[100].Employ_Code__c);
                            if(!DsaMasterList.isEmpty()) UPSERT DsaMasterList Employ_Code__c;
                            break;
                        }
                    }
                }catch(Exception e){
                    System.debug(e.getStackTraceString());
                    if(retryCount == 2){
                        //Send Email
                        Utility.sendEmail('DSA Master ',e.getMessage());
                        break;
                    }
                }
                
                if(retryCount == 2){
                    //Send Email
                    Utility.sendEmail('DSA Master ', 'Retry Failed'); 
                    break;
                }
            } 
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            Utility.sendEmail('DSA Master ', 'Retry Failed'); 
            //throw new CustomException('Error occured in response while fetching DSA master data!!!!');        
        }
    }
    
    //request class format
    public class RequestFormat{
        public String exe_tenantId;	//cuecent_tenant
        public String owner_tenantId;	//cuecent_tenant
        public cls_inputVariables inputVariables;
    }
    class cls_inputVariables {
    }
    
    //response class format
    public class ResponseFormat{
        public String bpms_error_code;	//00
        public cls_out_msg out_msg;
        public String bpms_error_msg;	//Success
    }    
    class cls_out_msg {
        public String HttpStatus;	//500
        public String ErrorCode;	//MW9999
        public String ErrorMessage;	//TECHNICAL ERROR
        public cls_DSA_Master[] DSA_Master;
    }
    class cls_DSA_Master {
        public String V_LOGIC_DIV;	//TAMBARAM
        public String V_BRANCH_CODE;	//1190
        public String V_BRANCH_NAME;	//CHENNAI - TAMBARAM
        public String V_EMP_CODE;	//3924
        public String V_EMP_NAME;	//DINESH PRABHA A .
        public String V_DESIG;	//SENIOR MANAGER-BRANCHHEAD
    }
}