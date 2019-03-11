/*
* Name      : WS_State_Master.
* Company   : ET Marlabs
* Purpose   : Used to Update or Insert State Master Information. 
* Author    : Raushan
*/
public class WS_State_Master {
    
    public static void masterRequest(){
        try{
            List<State_Master__c> stateMasterList   =   new List<State_Master__c>();
            WS_State_Master.Request_State   req     =   new WS_State_Master.Request_State();
            req.exe_tenantId                        =   'cuecent_tenant';
            req.owner_tenantId                      =   'cuecent_tenant';
            req.inputVariables                      =   new WS_State_Master.cls_inputVariables();
            
            Map<String,String> headerMap                            = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            HTTPResponse response                                   = new HTTPResponse();
            for(Integer retryCount = 0;retryCount < 3; retryCount++){
                try{
                    response = HttpUtility.sendHTTPRequest(Utility.getEndpoint('State_Master_API'), 'POST', null,JSON.serialize(req),headerMap,label.CA_CERTIFICATE);
                    String jsonString = response.getBody();
                    System.debug(jsonString);
                    If(response.getStatusCode() ==200 || response.getStatusCode() ==201){
                        WS_State_Master.Response_State resObj   =   (WS_State_Master.Response_State)Json.deserialize(jsonString, WS_State_Master.Response_State.class);
                        If(resObj.out_msg.ErrorCode == '0'){
                            for(WS_State_Master.cls_State_Master stateObj  : resObj.out_msg.State_Master){
                                State_Master__c  stateObject  = new State_Master__c();
                                If(stateObj !=null){
                                    If(!Utility.ISStringBlankorNull(stateObj.COD_STATE))
                                        stateObject.COD_STATE__c =  stateObj.COD_STATE;
                                    If(!Utility.ISStringBlankorNull(stateObj.NAM_STATE))
                                        stateObject.Name            =   stateObj.NAM_STATE;
                                    
                                    stateMasterList.add(stateObject); 
                                }
                            } 
                        } 
                        else throw new CustomException('Error occured in response while fetching State master data');
                        
                        If(!stateMasterList.isEmpty()){
                            UPSERT stateMasterList COD_STATE__c; 
                            break;
                        }
                    }
                    
                }catch(Exception e){
                    System.debug(e.getStackTraceString());
                    if(retryCount == 2){
                        //Send Email
                        Utility.sendEmail('State Master ',e.getMessage());
                        break;
                    }
                }
                
                if(retryCount == 2){
                    //Send Email
                    Utility.sendEmail('State master ', 'Retry Failed'); 
                    break;
                }
            }
            
        }catch(Exception ex){
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            Utility.sendEmail('State Master','Retry Failed');
            //throw new CustomException('Error occured in response while fetching State master data'); 
        }    
    } 
    
    //Request Formatter
    public class Request_State{
        public String exe_tenantId;
        public String owner_tenantId;   
        public cls_inputVariables inputVariables;
    }
    public class cls_inputVariables {}
    
    //Response Formatter
    public class Response_State{
        public String bpms_error_code;  //00
        public String bpms_error_msg;   //Success
        public cls_out_msg out_msg;
    }
    public class cls_out_msg {
        public String HttpStatus;   //500
        public String ErrorCode;    //MW9999
        public String ErrorMessage; //TECHNICAL ERROR
        public cls_State_Master[] State_Master;
    }
    public class cls_State_Master {
        public String COD_STATE;    //1  
        public String NAM_STATE;    //Andaman and Nicobar Islands
    }
    
}